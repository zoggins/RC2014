; **********************************************************************
; **  Alpha module                              by Stephen C Cousins  **
; **********************************************************************

; This module provides the following:
;   Defines the memory map (except kCode and kData)
;   Reset code / Cold start command line interpreter
;   Warm start command line interpreter
;
; Public functions provided:
;   ColdStart             Cold start monitor
;   WarmStart             Warm start monitor
;   InitJumps             Initialise jump table with vector list
;   ClaimJump             Claim jump table entry
;   ReadJump              Read jump table entry
;   MemAPI                Call API with parameters in RAM
;   SelConDev             Select console in/out device
;   SelConDevI            Select console input device
;   SelConDevO            Select console output device
;   DevInput              Input from specified console device
;   DevOutput             Output to specified console device
;   GetConDev             Get current console device numbers
;   GetMemTop             Get top of free memory
;   SetMemTop             Set top of free memory
;   GetVersion            Get version and configuration details
;   OutputMessage         Output specified embedded message
;   SetBaud               Set baud rate for console devices
;   SysReset              System reset


; **********************************************************************
; **  Constants                                                       **
; **********************************************************************

; Operating system version number
;kSysMajor: .EQU 1              ;Bios version: revision
;kSysMinor: .EQU 0              ;Bios version: revision
;kSysRevis: .EQU 1              ;Bios version: revision


; Memory map (ROM or RAM)
Reset:      .EQU 0x0000         ;Z80 reset location


; Page zero use 
; SCMonitor: page zero can be in RAM or ROM
; CP/M: page zero must be in RAM
; <Address>   <Z80 function>   <Monitor>   <CP/M 2>
; 0000-0002   RST 00 / Reset   Cold start  Warm boot
; 0003-0004                    Warm start  IOBYTE / drive & user
; 0005-0007                    As CP/M     FDOS entry point
; 0008-000B   RST 08           Char out    Not used
; 000C-000F                    CstartOld   Not used
; 0010-0013   RST 10           Char in     Not used
; 0014-0017                    WstartOld   Not used
; 0018-001F   RST 18           In status   Not used
; 0020-0027   RST 20           Not used    Not used
; 0028-002F   RST 28           Breakpoint  Debugging
; 0030-0037   RST 30           API entry   Not used
; 0038-003F   RST 38 / INT     Interrupt   Interrupt mode 1 handler
; 0040-005B                    Options     Not used
; 005C-007F                    As CP/M     Default FCB
; 0066-0068   NMI              or Non-maskable interrupt (NMI) handler
; 0080-00FF                    As CP/M     Default DMA

; Memory map (ROM)
;kCode:     .EQU 0x0000         ;Typically 0x0000 or 0xE000

; Memory map (RAM)
;kData:     .EQU 0xFC00         ;Typically 0xFC00 (to 0xFFFF)
; 0xFC00 to 0xFCBF  User stack
; 0xFCC0 to 0xFCFF  System stack
; 0xFD00 to 0xFD7F  Line input buffer
; 0xFD80 to 0xFDFF  String buffer
; 0xFE00 to 0xFE5F  Jump table
; 0xFE60 to 0xFEFF  Workspace (currently using to about 0xFEAF)
; 0xFF00 to 0xFFFF  Pass info between apps and memory banks:
; 0xFF00 to 0xFF7F    Transient data area
; 0xFF80 to 0xFFEF    Transient code area
; 0xFFD0 to 0xFFDF    ROMFS file info block 2
; 0xFFE0 to 0xFFEF    ROMFS file info block 1
; 0xFFF0 to 0xFFFF    System variables
kSPUsr:     .EQU kData+0x00C0   ;Top of stack for user program
kSPSys:     .EQU kData+0x0100   ;Top of stack for system
kInputBuff: .EQU kData+0x0100   ;Line input buffer start    (to +0x017F)
kInputSize: .EQU 128            ;Size of input buffer
kStrBuffer: .EQU kData+0x0180   ;String buffer              (to +0x01FF)
kStrSize:   .EQU 128            ;Size of string buffer
kJumpTab:   .EQU kData+0x0200   ;Redirection jump table     (to +0x025F)
;kWorkspace:                    .EQU kData+0x0260;Space for data & variables (to +0x02FF)
; Pass information between apps and memory banks 0xFF00 to 0xFFFF
kPassData   .EQU kData+0x0300   ;0xFF00 to 0xFF7F Transient data area
kPassCode:  .EQU kData+0x0380   ;0xFF80 to 0xFFEF Transient code area
kPassInfo:  .EQU kData+0x03F0   ;0xFFF0 to 0xFFFF Variable passing area
kPassCtrl:  .EQU kPassInfo+0x00 ;Pass control / paging information
kPassAF:    .EQU kPassInfo+0x02 ;Pass AF to/from API
kPassBC:    .EQU kPassInfo+0x04 ;Pass BC to/from API
kPassDE:    .EQU kPassInfo+0x06 ;Pass DE to/from API
kPassHL:    .EQU kPassInfo+0x08 ;Pass HL --/from API
kPassDevI:  .EQU kPassInfo+0x0A ;Pass current input device
kPassDevO:  .EQU kPassInfo+0x0B ;Pass current output device

; Fixed address to allow external code to use it
kTransCode: .EQU kData+0x0380   ;0xFF80 Transient code area

; Fixed address to allow external code to use this data
iConfigCpy: .EQU kData+0x03F0   ;0xFFF0 Configure register shadow copy
iConfigPre: .EQU kData+0x03F1   ;0xFFF1 Config register previous copy

; Define memory usage
kSysData    .EQU kData + 0x0260
kMonData    .EQU kData + 0x0280
kBiosData   .EQU kData + 0x02C0
kEndOfData  .EQU kData + 0x03FF

; **********************************************************************
; **  Initialise memory sections                                      **
; **********************************************************************

; Initialise data section
            .DATA

            .ORG  kSysData      ;Establish workspace/data area

            .CODE

            .ORG kJumpTab

JpNMI:      JP   0              ;Fn 0x00: Jump to non-maskable interrupt
JpRST08:    JP   0              ;Fn 0x01: Jump to restart 08 handler
JpRST10:    JP   0              ;Fn 0x02: Jump to restart 10 handler
JpRST18:    JP   0              ;Fn 0x03: Jump to restart 18 handler
JpRST20:    JP   0              ;Fn 0x04: Jump to restart 20 handler
JpBP:       JP   0              ;Fn 0x05: Jump to restart 28 breakpoint
JpAPI:      JP   0              ;Fn 0x06: Jump to restart 30 API handler
JpINT:      JP   0              ;Fn 0x07: Jump to restart 38 interrupt handler
JpConIn:    JP   0              ;Fn 0x08: Jump to console input character
JpConOut:   JP   0              ;Fn 0x09: Jump to console output character
            JP   0              ;Fn 0x0A: Jump to console get input status
            JP   0              ;Fn 0x0B: Jump to console get output status
JpIdle:     JP   0              ;Fn 0x0C: Jump to idle handler
JpTimer1:   JP   0              ;Fn 0x0D: Jump to timer 1 handler
JpTimer2:   JP   0              ;Fn 0x0E: Jump to timer 2 handler
JpTimer3:   JP   0              ;Fn 0x0F: Jump to timer 3 handler
            ;Fn 0x10: Start of console device jumps
            JP   0              ;Jump to device 1 input character
            JP   0              ;Jump to device 1 output character
            JP   0              ;Jump to device 2 input character
            JP   0              ;Jump to device 2 output character
            JP   0              ;Jump to device 3 input character
            JP   0              ;Jump to device 3 output character
            JP   0              ;Jump to device 4 input character
            JP   0              ;Jump to device 4 output character
            JP   0              ;Jump to device 5 input character
            JP   0              ;Jump to device 5 output character
            JP   0              ;Jump to device 6 input character
            JP   0              ;Jump to device 6 output character

            .DS   12            ;Workspace starts at kJumpTab + 0x60
;           .ORG  kWorkspace

; Initialise code section
            .CODE
            .ORG  kCode


; **********************************************************************
; **  Page zero default vectors etc, copied to RAM if appropriate     **
; **********************************************************************

; Reset / power up here
Page0Strt:
ColdStart:  JP   HW_Test        ;0x0000  or CP/M 2 Warm boot
WarmStart:  JR   WStrt          ;0x0003  or CP/M 2 IOBYTE/drive & user
            JP   FDOS           ;0x0005  or CP/M 2 FDOS entry point
            JP   JpRST08        ;0x0008  RST 08 Console character out
            .DB  0              ;0x000B  
CStrt:      JP   ColdStrt       ;0x000C  Cold start (eg. after selftest)
            .DB  0              ;0x000F  
            JP   JpRST10        ;0x0010  RST 10 Console character in
            .DB  0              ;0x0013 
WStrt:      JP   WarmStrt       ;0x0014  Warm start (unofficial entry)
            .DB  0              ;0x0017
            JP   JpRST18        ;0x0018  RST 18 Console input status
            .DB  0              ;0x001B
            .DB  "SCM",0        ;0x001C  SCM identifier string
            JP   JpRST20        ;0x0020  RST 20 Not used
            .DB  0,0,0,0,0      ;0x0023
            JP   JpBP           ;0x0028  RST 28 Our debugging breakpoint
            .DB  0              ;0x002B         and CP/M debugging tools
            .DB  kConfMajor     ;0x002C  SCM config major
            .DB  kConfMinor     ;0x002D  SCM config minor
            .DB  0,0            ;0x002E
            JP   JpAPI          ;0x0030  RST 30 API entry point
            .DB  0              ;0x0033         parameters in registers
            JP   MemAPI         ;0x0034  API call with
            .DB  0              ;0x0037         parameters in memory 
            JP   JpINT          ;0x0038  RST 38 Interrupt mode 1 handler
            .DB  0,0,0,0,0      ;0x003B
kaConDev:   .DB  kConDef        ;0x0040  Default console device (1 to 6)
kaBaud1Def: .DB  kBaud1Def      ;0x0041  Default device 1 baud rate
kaBaud2Def: .DB  kBaud2Def      ;0x0042  Default device 2 baud rate
kaBaud3Def: .DB  kBaud3Def      ;0x0043  Default device 3 baud rate
kaBaud4Def: .DB  kBaud4Def      ;0x0044  Default device 4 baud rate
kaBaud5Def: .DB  kBaud5Def      ;0x0045  Default device 5 baud rate
kaBaud6Def: .DB  kBaud6Def      ;0x0046  Default device 6 baud rate
kaPortIn:   .DB  kPrtIn         ;0x0047  Default status input port
kaPortOut:  .DB  kPrtOut        ;0x0048  Default status output port
            .DB  0              ;0x0049  Not used
            .DB  0              ;0x004A  Not used
            .DB  0              ;0x004B  Not used
            .DB  0              ;0x004C  Not used
kaRomTop:   .DB  kROMTop        ;0x004D  Top of RomFS (hi byte)
kaCodeBeg:  .DB  CodeBegin\256  ;0x004E  Start of SCM code (hi byte)
kaCodeEnd:  .DB  CodeEnd\256    ;0x004F  End of SCM code (hi byte)
kaConfig0:  .DB  kConfig0       ;0x0050  BIOS specific config data #0
kaConfig1:  .DB  kConfig1       ;0x0051  BIOS specific config data #1
kaConfig2:  .DB  kConfig2       ;0x0052  BIOS specific config data #2
kaConfig3:  .DB  kConfig3       ;0x0053  BIOS specific config data #3
kaConfig4:  .DB  kConfig4       ;0x0054  BIOS specific config data #4
kaConfig5:  .DB  kConfig5       ;0x0055  BIOS specific config data #5
kaConfig6:  .DB  kConfig6       ;0x0056  BIOS specific config data #6
kaConfig7:  .DB  kConfig7       ;0x0057  BIOS specific config data #7
kaConfig8:  .DB  kConfig8       ;0x0058  BIOS specific config data #8
kaConfig9:  .DB  kConfig9       ;0x0059  BIOS specific config data #9
kaConfigA:  .DB  kConfigA       ;0x005A  BIOS specific config data #A
kaConfigB:  .DB  kConfigB       ;0x005B  BIOS specific config data #B
            .DW  0,0            ;0x005C  CP/M 2 Default FCB
            .DW  0,0,0          ;0x0060         from 0x005C to 0x007F
            JP   JpNMI          ;0x0066  Non-maskable interrupt handler
Page0End:


; **********************************************************************
; **  Jump table defaults to be copied to RAM                         **
; **********************************************************************

JumpStrt:   JP   TrapNMI        ;Fn 0x00: non-maskable interrupt
            JP   OutputChar     ;Fn 0x01: restart 08 output character
            JP   InputChar      ;Fn 0x02: restart 10 input character
            JP   InputStatus    ;Fn 0x03: restart 18 get input status
            JP   TrapCALL       ;Fn 0x04: restart 20 handler
            JP   0              ;Fn 0x05: restart 28 breakpoint handler
            JP   APIHandler     ;Fn 0x06: restart 30 API handler
            JP   TrapINT        ;Fn 0x07: restart 38 interrupt handler
            JP   TrapCALL       ;Fn 0x08: console input character
            JP   TrapCALL       ;Fn 0x09: console output character
            JP   TrapCALL       ;Fn 0x0A: console get input status
            JP   TrapCALL       ;Fn 0x0B: console get output status
            JP   TrapCALL       ;Fn 0x0C: Jump to idle handler
            JP   TrapCALL       ;Fn 0x0D: Jump to timer 1 handler
            JP   TrapCALL       ;Fn 0x0E: Jump to timer 2 handler
            JP   TrapCALL       ;Fn 0x0F: Jump to timer 3 handler
            JP   DevNoIn        ;Fn 0x10: Device 1 input character
            JP   DevNoOut       ;Fn 0x11: Device 1 output character
            JP   DevNoIn        ;Fn 0x10: Device 2 input character
            JP   DevNoOut       ;Fn 0x11: Device 2 output character
            JP   DevNoIn        ;Fn 0x10: Device 3 input character
            JP   DevNoOut       ;Fn 0x11: Device 3 output character
            JP   DevNoIn        ;Fn 0x10: Device 4 input character
            JP   DevNoOut       ;Fn 0x11: Device 4 output character
            JP   DevNoIn        ;Fn 0x10: Device 5 input character
            JP   DevNoOut       ;Fn 0x11: Device 5 output character
            JP   DevNoIn        ;Fn 0x10: Device 6 input character
            JP   DevNoOut       ;Fn 0x11: Device 6 output character
JumpEnd:


; **********************************************************************
; **  Reset code                                                      **
; **********************************************************************

; Cold start Command Line Interpreter
ColdStrt:
#IFNDEF     EXTERNALOS
            DI                  ;Disable interrupts
#ENDIF
            LD   SP,kSPSys      ;Initialise system stack pointer
; Copy vectors etc to page zero in case code is elsewhere
; When using external OS for I/O only initialise SCM's API restart
#IFDEF      EXTERNALOS
            LD   HL,0x0030      ;Address of SCM's API restart
            LD   (HL),0xC3      ;Write JP instruction at restart
            INC  HL             ;Increment address pointer
            LD   DE,JpAPI       ;Write address of API handler
            LD   (HL),E         ;  at restart...
            INC  HL             ;  Should use LD (HL),JpAPI/256 etc
            LD   (HL),D         ;  but homebrew assembler fails at that
#ELSE
            LD   DE,0x0000      ;Copy vectors etc to here
            LD   HL,Page0Strt   ;Copy vectors etc from here
            LD   BC,Page0End-Page0Strt  ;Number of bytes to copy
#IFDEF      ROM_ONLY
            NOP                 ;Do not copy bytes
            NOP
#ELSE
            LDIR                ;Copy bytes
#ENDIF
#ENDIF
; Initialise jump table, other than console devices
            LD   DE,kJumpTab    ;Copy jump table to here
            LD   HL,JumpStrt    ;Copy jump table from here
            LD   BC,JumpEnd-JumpStrt  ;Number of bytes to copy
            LDIR                ;Copy bytes
; Initialise top of memory value
            LD   HL,kData-1     ;Top of free memory
            LD   (iMemTop),HL   ;Set top of free memory
; Initialise ports module for default I/O ports
; This will turn off all outputs at the default output port (LEDs)
            LD   A,(kaPortOut)  ;Default output port address
            CALL PrtOInit       ;Initialise output port
            LD   A,(kaPortIn)   ;Default input port address
            CALL PrtIInit       ;Initialise input port
; Initialise hardware and set up required jump table entries
; This may indicate an error at the default output port (LEDs)
            CALL HW_Init        ;Hardware_Initialise
; Initialise default console device to first physical device
            LD   A,(kaConDev)   ;Default device number
            CALL SelConDev      ;Select console device
; Initialise rest of system
            CALL ConInitialise  ;Initialise the console
#IFDEF      IncludeRomFS
            CALL RomInitialise  ;Initialise RomFS
#ENDIF
#IFDEF      IncludeScripting
            CALL ScrInitialise  ;Initialise script language
#ENDIF
; Output sign-on message
            CALL OutputNewLine  ;Output new line
            CALL OutputNewLine  ;Output new line
            LD   A,kMsgProdID   ;="Small Computer Monitor"
            CALL OutputMessage  ;Output message
            LD   A,'-'          ;="-"
            CALL OutputChar     ;Output character
            LD   A,kSpace       ;=" "
            CALL OutputChar     ;Output character
#IFDEF      NAME_VIA_CODE
            CALL HW_MsgName     ;Output hardware name
#ELSE
            CALL C_GetName      ;Get config name 
            CALL OutputZString  ;Output message at DE
#ENDIF
            CALL OutputNewLine  ;Output new line
#IFNDEF     IncludeCommands
            CALL OutputNewLine  ;Output new line
            LD   A,kMsgAbout    ;="Small Computer Monitor ..."
            CALL OutputMessage  ;Output message A
            CALL OutputNewLine  ;Output new line
            LD   A,kMsgDevice   ;="Devices:"
            CALL OutputMessage  ;Output message A
            LD   A,kMsgDevLst   ;="<device list>"
            CALL OutputMessage  ;Output message A
#ENDIF

; Warm start Command Line Interpreter
WarmStrt:   LD   SP,kSPSys      ;Initialise system stack pointer
#IFDEF      IncludeMonitor
            CALL M_MonInit      ;Initialise monitor
#ENDIF
#IFDEF      IncludeMonitor
;#IFDEF     IncludeCommands
            JP   M_CLILoop      ;Command Line Interpreter main loop
;#ENDIF
#ELSE
@Halt:      JR   @Halt          ;Halt here if no CLI
#ENDIF

; Trap unused entry points
#IFNDEF     IncludeAPI
API:
#ENDIF
#IFNDEF     IncludeFDOS
FDOS:
#ENDIF
#IFNDEF     IncludeBreakpoint
BPHandler:
#ENDIF
TrapCALL:   XOR   A             ;Return A=0x00 and Z flagged
            RET                 ;Return from entry point

; Trap unused mode 1 interrupt
TrapINT:    RETI                ;Return from interrupt

; Trap unused non-maskabler interrupt
TrapNMI:    RETN                ;Return from interrupt

; Default console device routines
DevNoIn:
DevNoOut:   XOR   A             ;Z flagged as no input or output
            RET                 ;Return have done nothing


; **********************************************************************
; **  Public functions                                                **
; **********************************************************************

; System: Get version details
;   On entry: No parameters required
;   On exit:  D,E and A = Bios code version
;               D = kBiosMajor
;               E = kBiosMinor
;               A = kBiosRevis(ion)
;             IX IY I AF' BC' DE' HL' preserved
SysGetVers: LD  D,kSysMajor     ;D = Major version number
            LD  E,kSysMinor     ;E = Minor version number
            LD  A,kSysRevis     ;A = Revision number
            RET


; System: Claim system jump table entry
;   On entry: A = Entry number (0 to n)
;             DE = Address of function
;   On exit:  No parameters returned
;             AF BC DE HL IX IY I AF' BC' DE' HL' preserved
; Some system functions, such as console in and console out, are 
; redirected through a jump table. By claiming a jump table entry the
; function can be handled by any required code. This might allow
; swapping output to a different device, such as a printer.
ClaimJump:  PUSH AF
            PUSH BC
            PUSH HL
            LD   HL,kJumpTab    ;Start of jump table
            LD   B,0            ;Calculate offset and store in BC..
            LD   C,A            ;C = 3 times A..
            ADD  A              ;x2
            ADD  C              ;x3
            LD   C,A
            ADD  HL,BC          ;Find location in table...
; Write jump table entry to memory
            LD   (HL),0xC3      ;Store jump instruction
            INC  HL
            LD   (HL),E         ;Store routine address lo byte
            INC  HL
            LD   (HL),D         ;Store routine address hi byte
            POP  HL
            POP  BC
            POP  AF
            RET


; System: API call with parameters passed via memory
;   On entry: Memory locations kPassXX contain register values
;   On exit:  Memory locations kPassXX contain register values
MemAPI:     LD   HL,(kPassAF)   ;Get AF parameter from RAM
            PUSH HL             ;Pass AF parameter via stack
            POP  AF             ;Get AF parameter from stack
            LD   BC,(kPassBC)   ;Get BC parameter from RAM
            LD   DE,(kPassDE)   ;Get DE parameter from RAM
            LD   HL,(kPassHL)   ;Get HL parameter from RAM
            ;RST  0x30          ;Call API
            CALL JpAPI          ;Call API
            LD   (kPassHL),HL   ;Store HL result in RAM
            LD   (kPassDE),DE   ;Store DE result in RAM
            LD   (kPassBC),BC   ;Store BC result in RAM
            PUSH AF             ;Pass AF result via stack
            POP  HL             ;Get AF result from stack
            LD   (kPassAF),HL   ;Store AF result in RAM
            RET


; System: Read system jump table entry
;   On entry: A = Entry number (0 to n)
;   On exit:  DE = Address of function
;             AF BC HL IX IY I AF' BC' DE' HL' preserved
; Some system functions, such as console in and console out, are 
; redirected through a jump table. By claiming a jump table entry the
; function can be handled by any required code. This might allow
; swapping output to a different device, such as a printer.
ReadJump:   PUSH AF
            PUSH BC
            PUSH HL
            LD   HL,kJumpTab+1  ;Start of jump table + 1
            LD   B,0            ;Calculate offset and store in BC..
            LD   C,A            ;C = 3 times A..
            ADD  A              ;x2
            ADD  C              ;x3
            LD   C,A
            ADD  HL,BC          ;Find location in table...
; Write jump table entry to memory
            LD   E,(HL)         ;Store routine address lo byte
            INC  HL
            LD   D,(HL)         ;Store routine address hi byte
            POP  HL
            POP  BC
            POP  AF
            RET


; System: Select console device
;   On entry: A = New console device number (1 to n)
;   On exit:  AF BC DE HL IX IY I AF' BC' DE' HL' preserved
; The console device list starts at jump table entry kFnDevN.
; Each device has two entries: input and output
; SelConDev  = Select both input and output device
; SelConDevO = Select output device only
; SelConDevI = Select input device only
SelConDev:  CALL SelConDevI     ;Select console input device
;           JP   SelConDevO     ;Select console output device
; Select output device
SelConDevO: PUSH AF
            PUSH DE
            LD   (kPassDevO),A  ;Store output device number
            ADD  A,A            ;Double as two entries each
            ADD  kFnDev1Out-2   ;Function number for device zero
            CALL ReadJump       ;Read source entry
            LD   A,kFnConOut    ;Destination device entry number
            CALL ClaimJump      ;Write destination entry
            POP  DE
            POP  AF
            RET
; Select input device
SelConDevI: PUSH AF
            PUSH DE
            LD   (kPassDevI),A  ;Store input device number
            ADD  A,A            ;Double as two entries each
            ADD  kFnDev1In-2    ;Function number for device zero
            CALL ReadJump       ;Read source entry
            LD   A,kFnConIn     ;Destination device entry number
            CALL ClaimJump      ;Write destination entry
            POP  DE
            POP  AF
            RET


; System: Input from specified console device
;   On entry: E = Console device number (1 to n)
;   On exit:  A = Character input 9if there is one ready)
;             NZ flagged if character has been input
;             BC DE HL IX IY I AF' BC' DE' HL' preserved
DevInput:   LD   A,E            ;Get console device number
            ADD  A,A            ;Double as two entries each
            ADD  kFnDev1In-2    ;Function number for device zero
            CALL ReadJump       ;Read table entry
            EX   DE,HL          ;Get routine address in HL
            JP   (HL)           ;Jump to input routine


; System: Output to specified console device
;   On entry: A = Character to be output
;             E = Console device number (1 to n)
;   On exit:  IX IY I AF' BC' DE' HL' preserved
DevOutput:  PUSH AF             ;Store character to be output
            LD   A,E            ;Get console device number
            ADD  A,A            ;Double as two entries each
            ADD  kFnDev1Out-2   ;Function number for device zero
            CALL ReadJump       ;Read table entry
            EX   DE,HL          ;Get routine address in HL
            POP  AF             ;Restore character to be output
            JP   (HL)           ;Jump to output routine


#IFDEF      NOCHANCE
; System: Delay by specified number of millseconds
;   On entry: DE = Delay time in milliseconds
;   On exit:  BC DE HL IX IY I AF' BC' DE' HL' preserved
; Clock =  1.0000 MHz,  1 ms =  1,000 TCy =  40 * 24 - 36 
; Clock =  4.0000 MHz,  1 ms =  4,000 TCy = 165 * 24 - 36
; Clock =  7.3728 MHz,  1 ms =  7,373 TCy = 306 * 24 - 36
; Clock = 12.0000 MHz,  1 ms = 12,000 TCy = 498 * 24 - 36
; Clock = 20.0000 MHz,  1 ms = 20,000 TCy = 831 * 24 - 36
Delay:      PUSH BC
            PUSH DE
; 1 ms loop, DE times... (overhead = 36 TCy)
@LoopDE:    LD   BC,kDelayCnt   ;[10]  Loop counter
; 26 TCy loop, BC times...
@LoopBC:    DEC  BC             ;[6]
            LD   A,C            ;[4]
            OR   B              ;[4]
            JP   NZ,@LoopBC     ;[10]
            DEC  DE             ;[6]
            LD   A,E            ;[4]
            OR   D              ;[4]
            JR   NZ,@LoopDE     ;[12/7]
            POP  DE
            POP  BC
            RET
#ENDIF


; System: Get current console device numbers
;   On entry: No parameters required
;   On exit:  D = Current console output device number
;             E = Current console input device number
;   On exit:  AF BC HL IX IY I AF' BC' DE' HL' preserved
GetConDev:  LD   DE,(kPassDevI) ;Get console device numbers
            RET


; System: Get top of free memory
;   On entry: No parameters required
;   On exit:  DE = Top of free memory
;   On exit:  AF BC HL IX IY I AF' BC' DE' HL' preserved
GetMemTop:  LD   DE,(iMemTop)   ;Get top of free memory
            RET


; System: Set top of free memory
;   On entry: DE = Top of free memory
;   On exit:  AF BC DE HL IX IY I AF' BC' DE' HL' preserved
SetMemTop:  LD   (iMemTop),DE   ;Set top of free memory
            RET


; System: Get version details
;   On entry: No parameters required
;   On exit:  D,E and A = Monitor code version
;               D = kVersMajor
;               E = kVersMinor
;               A = kVersRevis(ion)
;             B,C = Configuration ID
;               B = kConfMajor ('R'=RC2014, 'L'=LiNC80, etc)
;               C = kConfMinor (sub-type '1', '2', etc)
;             H,L = Target hardware ID
;               H = kHardID (1=Simulator, 2=,SCDevKt, 3=RC2014, etc)
;               L = Hardware option flags (hardware specific)
;             IX IY I AF' BC' DE' HL' preserved
GetVersion:
            CALL HW_GetVers     ;Get BIOS details in H,L,D,E,A
            ;LD  H,kHardID      ;H = BIOS ID (= old Hardware ID)
            ;LD  A,(iHwFlags)   ;Get hardware option flags
            ;LD  L,A            ;L = Hardware option flags
            CALL C_GetInfo      ;Get configuration details in B,C,A
            ;LD  A,kConfHardw   ;A = Hardware identifier
            ;LD  B,kConfMajor   ;B = Major configuration
            ;LD  C,kConfMinor   ;C = Minor configuration 
#IFDEF      IncludeMonitor
            LD  D,kMonMajor     ;D = Major version number
            LD  E,kMonMinor     ;E = Minor version number
            LD  A,kMonRevis     ;A = Revision number
#ELSE
            LD  D,0             ;D = Major version number
            LD  E,0             ;E = Minor version number
            LD  A,0             ;A = Revision number
#ENDIF
            RET


; System: Output message
;  On entry:  A = Message number (0 to n)
;   On exit:  BC DE HL IX IY I AF' BC' DE' HL' preserved
OutputMessage:
            OR   A              ;Null message?
            RET  Z              ;Yes, so abort
            PUSH DE             ;Preserve DE
            PUSH HL             ;Preserve HL
; Monitor message?
#IFDEF      IncludeMonitor
            CALL M_OutputMs     ;Offer message number to monitor
            OR   A              ;Message still needs handling?
            JR   Z,@Exit        ;No, so exit
#ENDIF
; Add any other message generating modules here
; ...........
; System message?
            CP   kMsgLstSys+1   ;Valid system message number?
            JR   NC,@Exit       ;No, so abort
; About message?
            CP   kMsgAbout      ;About message?
            JR   NZ,@NotAbout   ;No, so skip
            LD   DE,szProduct   ;="Small Computer Monitor"
            CALL OutputZString  ;Output message at DE
            LD   DE,szAbout     ;="<about this configuration>"
            CALL OutputZString  ;Output message at DE
            ;LD   DE,szConfig   ;="<config code> <data>"
            ;CALL OutputZString ;Output message at DE

            CALL C_GetInfo      ;Get configuration version
            LD   A,B            ;Get major config code
            CALL OutputChar     ;Output major config char
            LD   A,C            ;Get minor config code
            CALL OutputChar     ;Output minor config char
            LD   A,' '          ;Get space character
            CALL OutputChar     ;Output space character
            CALL C_GetName      ;Get configuration name etc
            EX   DE,HL          ;Get pointer to date string
            CALL OutputZString  ;Output message at DE

#IFDEF      IncludeMonitor
            LD   DE,szMonitor   ;=" Monitor "
            CALL OutputZString  ;Output message at DE
            CALL M_GetVers      ;Get monitor version details
            CALL OutputVers     ;Output version D.E.A
#ENDIF

            ;LD   DE,szOS       ;=" OS "
            ;CALL OutputZString ;Output message at DE
            ;CALL SysGetVers    ;Get system version details
            ;CALL OutputVers    ;Output version D.E.A

            LD   A,','
            CALL OutputChar     ;Output ','
            LD   A,' '
            CALL OutputChar     ;Output ' '

            CALL HW_GetName     ;Get BIOS name
            CALL OutputZString  ;Output message at DE

            LD   DE,szBios      ;=" Bios "
            CALL OutputZString  ;Output message at DE
            CALL HW_GetVers     ;Get Bios version details
            CALL OutputVers     ;Output version D.E.A

            CALL  OutputNewLine

            JR   @Exit
@NotAbout:
; Device list message?
            CP   kMsgDevLst     ;Device list message?
            JR   NZ,@NotDevLst  ;No, so skip
;           LD   DE,szDevices   ;="Devices:"
;           CALL OutputZString  ;Output message at DE
            CALL HW_MsgDevs     ;Output device list
            JR   @Exit
@NotDevLst:
; Other system message?
            LD   E,A            ;Get message number
            LD   D,0
            LD   HL,MsgTabSys   ;Get start of message table
            ADD  HL,DE          ;Calculate location in table
            ADD  HL,DE
            LD   A,(HL)         ;Get address from table...
            INC  HL
            LD   D,(HL)
            LD   E,A
            CALL OutputZString  ;Output message as DE
@Exit:      POP  HL             ;Restore HL
            POP  DE             ;Restore DE
            RET

; Output version number A.D.E
OutputVers: PUSH AF             ;Preserve revision number
            LD   A,D            ;Get major version number
            CALL @OutputN       ;Output number
            CALL @OutputDot     ;Output '.'
            LD   A,E            ;Get major version number
            CALL @OutputN       ;Output number
            CALL @OutputDot     ;Output '.'
            POP  AF             ;Restore revision number
; Output one numbnerical value
@OutputN:   ADD  A,'0'          ;Convert to ASCII
            JP   OutputChar     ;Output ASCII character
; Output '.'
@OutputDot: LD   A,'.'          ;Get character '.'
            JP   OutputChar     ;Outputcharacter '.'


; System: Set baud rate
;  On entry:  A = Device identifier (0x01 to 0x06, or 0x0A to 0x0B)
;             E = Baud rate code 
;   On exit:  IF successful: (ie. valid device and baud code)
;               A != 0 and NZ flagged
;             BC DE HL IX IY I AF' BC' DE' HL' preserved
SetBaud:    CP   0x0A           ;Identifier is a hex letter?
            JR   C,@GotNum      ;No, so skip
            SUB  0x09           ;Convert 0x0A/B to 0x01/2
@GotNum:    LD   C,A            ;Get device identifier (0x01 to 0x06)
            LD   A,E            ;Get baud rate code
; Set baud rate for device C (1 to 6) to baud code A
            JP   HW_SetBaud     ;Failure: A=0 and Z flagged


; System: System reset
;  On entry:  A = Reset type: 
;               0 = Cold start monitor
;               1 = Warm start monitor
;   On exit:  System resets
SysReset:   CP   0x01           ;Warm start monitor
            JP   Z,WarmStart    ;Yes, so warm start monitor
            RST  0              ;Cold start monitor


; **********************************************************************
; **  Constant data                                                   **
; **********************************************************************

; Message strings (zero terminated)
szNull:     .DB  kNull
szProduct:  .DB  "Small Computer Monitor ",kNull
szDevices:  .DB  "Devices detected:",kNewLine,kNull
szAbout:    .DB  "by Stephen C Cousins (www.scc.me.uk)",kNewLine
            .DB  "Configuration ",kNull
szMonitor:  .DB  ", Monitor ",kNull
;szOS:      .DB  ", OS ",kNull
szBios:     .DB  " BIOS ",kNull
szReady:    .DB  "Ready",kNewLine,kNull
szFileEr:   .DB  "File error",kNewLine,kNull


; Message table
MsgTabSys:  .DW  szNull         ;00 = null
            .DW  szProduct      ;01 = Product name
            .DW  szDevices      ;02 = Devices detected
            .DW  szNull         ;03 = About (handled in code)
            .DW  szNull         ;04 = Device list (handled in code)
            .DW  szReady        ;05 = Ready
            .DW  szFileEr       ;05 = File error


; **********************************************************************
; **  Private workspace (in RAM)                                      **
; **********************************************************************

            .DATA

iMemTop:    .DW  0              ;Top of free memory address
































































