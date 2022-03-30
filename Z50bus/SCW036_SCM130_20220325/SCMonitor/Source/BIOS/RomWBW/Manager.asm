; **********************************************************************
; **  Hardware Manager                          by Stephen C Cousins  **
; **  Hardware: External OS = CPM                                     **
; **********************************************************************

; Bios constants - name and version number
#DEFINE     BNAME "RomWBW"      ;Bios name
kBiosID:    .EQU BI_ROMWBW      ;Bios ID (use constant BI_xxxx)
kBiosMajor: .EQU 1              ;Bios version: revision
kBiosMinor: .EQU 1              ;Bios version: revision
kBiosRevis: .EQU 0              ;Bios version: revision
;BiosTouch: .EQU 20191114       ;Last date this BIOS code touched


; **********************************************************************
; **  Includes                                                        **
; **********************************************************************

; Include jump table at start of BIOS
#INCLUDE    BIOS\BIOS_JumpTable.asm

; Include common BIOS functions and API shims
#INCLUDE    BIOS\BIOS_Common.asm

; Include any additional source files needed for this BIOS
#INCLUDE    BIOS\RomWBW\Terminal.asm


; **********************************************************************
; Ensure we assemble to code area

            .CODE


; **********************************************************************
; Self-test
;   On entry: No parameters required
;   On exit:  AF BC DE HL not specified
;             IX IY I AF' BC' DE' HL' not specified
H_Test:     JP  CStrt           ;No self-test


; **********************************************************************
; Hardware: Initialise
;   On entry: No parameters required
;   On exit:  AF BC DE HL not specified
;             IX IY I AF' BC' DE' HL' preserved
H_Init:     XOR  A
            LD   (iHwFlags),A   ;Clear hardware flags
            CALL Terminal_Initialise
            LD   HL,@Pointers
            LD   B,4
            LD   A,kFnDev1In
            JP   InitJumps
@Pointers:
            ; Device 1 = Serial terminal
            .DW  Terminal_InputChar
            .DW  Terminal_OutputChar


; **********************************************************************
; Get BIOS name string
;   On entry: No parameters required
;   On exit:  DE = Pointer to BIOS name name string
;             AF BC HL not specified
;             IX IY I AF' BC' DE' HL' preserved
; H_GetName   see Common.asm


; **********************************************************************
; Get version details
;   On entry: No parameters required
;   On exit:  D,E,A = Bios code version (Major, Minor, Revision)
;             B,C = Configuration code (Major, Minor)
;             H,L = Target hardware ID (H) and flags (L)
;             IX IY I AF' BC' DE' HL' preserved
; H_GetVers   see Common.asm


; **********************************************************************
; Set baud rate
;   On entry: A = Baud rate code
;             C = Console device number (1 to 6)
;   On exit:  If successful: A != 0 and NZ flagged
;             If unsuccessful: A = 0 and Z flagged
;             BC DE HL not specified
;             IX IY I AF' BC' DE' HL' preserved
H_SetBaud:  XOR  A              ;Return failure (A=0 and Z flagged)
            RET                 ;Abort as invalid baud rate


; **********************************************************************
; Idle event set up
;   On entry: A = Idle event configuration:
;                 0 = Off (just execute RET instruction)
;                 1 = Software generated timer events
;                 2 = Hardware generated timer events
;   On exit:  AF BC DE HL not specified
;             IX IY I AF' BC' DE' HL' preserved
H_IdleSet:  LD   HL,@Vector     ;Point to idle mode 0 vector
            OR   A              ;A=0?
            JR   Z,@IdleSet     ;Yes, so skip
            INC  HL             ;Point to idle mode 1 vector
            INC  HL
            ;LD   A,0xFF        ;Initialise software timer
            ;LD   (iHwIdle),A   ;  to roll over immediately
            ;LD   A,(iHwFlags)  ;Get device present flags
            ;BIT  4,A           ;Is CTC #1 present?
            ;JR   Z,@IdleSet    ;No, so set for software polling
            ;INC  HL            ;Point to idle mode 2 vector
            ;INC  HL
; Set up event handler by writing to jump table
@IdleSet:   LD   A,kFnIdle      ;Jump table 0x0C = idle handler
            JP   InitJump       ;Write jump table entry A
@Return:    XOR  A              ;Return no event (A=0 and Z flagged)
            RET                 ;Idle mode zero routine
; Vector for event handler
@Vector:    .DW  @Return        ;Mode 0 = Off
            .DW  H_PollT1       ;Mode 1 = Software generated

; **********************************************************************
; Hardware: Poll timer
;   On entry: No parameters required
;   On exit:  If 1ms event to be processed NZ flagged and A != 0
;             BC DE HL IX IY I AF' BC' DE' HL' preserved
; Poll software generated timer to see if a 1ms event has occurred.
; We have to estimate the number of clock cycles used since the last
; call to this routine. When the system is waiting for a console input
; character this will be the time it takes to call here plus the time 
; to poll the serial input device. Lets call this the loop time.
; The rest of the time we don't know so the timer events will probably 
; run slow.
; We generate a 1000 Hz event (every 1,000 micro seconds) by 
; counting processor clock cycles.
; With a 7.3728 Hz CPU clock, 1,000 micro seconds is 7,373 cycles
H_PollT1:   LD   A,(iHwIdle)    ;Get loop counter
            ADD  A,6            ;Add to loop counter
            LD   (iHwIdle),A    ;Store updated counter
            JR   C,@RollOver    ;Skip if roll over (1ms event)
            XOR   A             ;No event so Z flagged and A = 0
            RET
@RollOver:  OR    0xFF          ;1ms event so NZ flagged and A != 0
            RET


; **********************************************************************
; Hardware: Output devices info
;   On entry: No parameters required
;   On exit:  AF BC DE HL not specified
;             IX IY I AF' BC' DE' HL' preserved
;Hardware_Devices:
H_MsgDevs:  LD   DE,@szHwList   ;Simulated hardware list message
            JP   OutputStr      ;Output string
@szHwList:  .DB  "RomWBW console device",kNewLine,kNull


; **********************************************************************
; Read from banked RAM
;   On entry: DE = Address in secondary bank
;   On exit:  A = Byte read from RAM
;             F BC DE HL not specified
;             IX IY I AF' BC' DE' HL' preserved
H_RdRAM:    RET                 ;Banked RAM not supported


; **********************************************************************
; Write to banked RAM
;   On entry: A = Byte to be written to RAM
;             DE = Address in secondary bank
;   On exit:  AF BC DE HL not specified
;             IX IY I AF' BC' DE' HL' preserved
H_WrRAM:    RET                 ;Banked RAM not supported


; **********************************************************************
; Copy from banked ROM to RAM
;   On entry: A = ROM bank number (0 to n)
;             HL = Source start address (in ROM)
;             DE = Destination start address (in RAM)
;             BC = Number of bytes to copy
;   On exit:  AF BC DE HL not specified
;             IX IY I AF' BC' DE' HL' preserved
H_CopyROM:  LDIR                ;Only one bank so just copy memory
            RET


; **********************************************************************
; Execute code in ROM bank
;   On entry: A = ROM bank number (0 to 3)
;             DE = Absolute address to execute
;   On exit:  AF BC DE HL not specified
;             IX IY I AF' BC' DE' HL' preserved
H_ExecROM:  PUSH DE             ;Jump to DE by pushing on
            RET                 ;  to stack and 'returning'


; **********************************************************************
; Delay by DE milliseconds
;   On entry: DE = Delay time in milliseconds
;   On exit:  AF BC DE HL not specified
;             IX IY I AF' BC' DE' HL' preserved
; H_Delay     see Common.asm


; **********************************************************************
; **  Workspace (in RAM)                                              **
; **********************************************************************

            .DATA

iHwIdle:    .DB  0              ;Poll timer count






































