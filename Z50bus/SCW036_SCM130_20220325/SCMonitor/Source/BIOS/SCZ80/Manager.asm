; **********************************************************************
; **  Hardware Manager                          by Stephen C Cousins  **
; **  BIOS: SCZ80                                                     **
; **********************************************************************

; This BIOS uses the optional BIOS framework

; Bios constants - version number
#DEFINE     BNAME "SCZ80"       ;Bios name
kBiosID:    .EQU BI_SCZ80       ;Bios ID (use constant BI_xxxx)
kBiosMajor: .EQU 1              ;Bios version: major
kBiosMinor: .EQU 3              ;Bios version: minor
kBiosRevis: .EQU 0              ;Bios version: revision
;BiosTouch: .EQU 20220227       ;Last date this BIOS code touched

; Global constants - motherboard hardware
;kPrtLED:   .EQU 0x08           ;Motherboard LED port (active low)
;kRtsPrt:   .EQU 0x20           ;/RTS output is bit zero
;kTxPrt:    .EQU 0x28           ;Transmit output is bit zero
;kRxPrt:    .EQU 0x28           ;Receive input is bit 7
;kBankPrt:  .EQU 0x30           ;Motherboard bank select port 

; Constants for additional hardware modules
;kACIA1:    .EQU 0x80           ;Base address of serial ACIA #1
;kACIA2:    .EQU 0xB0           ;Base address of serial ACIA #2
;kSIO1:     .EQU 0x80           ;Base address of serial Z80 SIO #1
;kSIO2:     .EQU 0x84           ;Base address of serial Z80 SIO #2
;kCTC1:     .EQU 0x88           ;Base address of Z80 CTC #1
;kCTC2:     .EQU 0x8C           ;Base address of Z80 CTC #2

; **********************************************************************
; **  Includes                                                        **
; **********************************************************************

; Include jump table at start of BIOS
#INCLUDE    BIOS\BIOS_JumpTable.asm

; Include common BIOS functions and API shims
#INCLUDE    BIOS\BIOS_Common.asm

; Include framework (this is an optional approach to BIOS code)
#INCLUDE    BIOS\Framework\Framework.asm

; Include any additional source files needed for this BIOS
#INCLUDE    BIOS\Framework\Selftest.asm

; Include BIOS framework interface devices...

; Banked RAM type SC1
#IFDEF      INCLUDE_BankedRAM_SC1
#INCLUDE    BIOS\Framework\Devices\BankedRAM_SC1.asm
#ENDIF

; Banked RAM type SC2
#IFDEF      INCLUDE_BankedRAM_SC2
#INCLUDE    BIOS\Framework\Devices\BankedRAM_SC2.asm
#ENDIF

; Banked ROM type SC1
#IFDEF      INCLUDE_BankedROM_SC1
#INCLUDE    BIOS\Framework\Devices\BankedROM_SC1.asm
#ENDIF

; Bit-bang serial port type SC1
#IFDEF      INCLUDE_BitBangSerial_SC1
#INCLUDE    BIOS\Framework\Devices\BitBangSerial_SC1.asm
#ENDIF

; SIO #1 following the RC2014 register order
#IFDEF      INCLUDE_SIO_n1_rc
kSIOBase:   .SET kSIO1          ;I/O base address
kSIOACont:  .SET kSIOBase+0     ;I/O address of control register A
kSIOAData:  .SET kSIOBase+1     ;I/O address of data register A
kSIOBCont:  .SET kSIOBase+2     ;I/O address of control register B
kSIOBData:  .SET kSIOBase+3     ;I/O address of data register B
kSIOFlags:  .SET 0b00000010     ;Hardware flags = SIO #1
kSIOACTC:   .SET kSIO1ACTC      ;I/O address of linked CTC port A
kSIOBCTC:   .SET kSIO1BCTC      ;I/O address of linked CTC port A
SIO_n1_rc:
#DEFINE     SIO_TYPE "(rc) "
#INCLUDE    BIOS\Framework\Devices\SIO.asm
#UNDEFINE   SIO_TYPE
#ENDIF

; SIO #1 following the typical Zilog register order
#IFDEF      INCLUDE_SIO_n1_std
kSIOBase:   .SET kSIO1          ;I/O base address
kSIOACont:  .SET kSIOBase+2     ;I/O address of control register A
kSIOAData:  .SET kSIOBase+0     ;I/O address of data register A
kSIOBCont:  .SET kSIOBase+3     ;I/O address of control register B
kSIOBData:  .SET kSIOBase+1     ;I/O address of data register B
kSIOFlags:  .SET 0b00000010     ;Hardware flags = SIO #1
kSIOACTC:   .SET kSIO1ACTC      ;I/O address of linked CTC port A
kSIOBCTC:   .SET kSIO1BCTC      ;I/O address of linked CTC port A
SIO_n1_std:
#DEFINE     SIO_TYPE ""         ;or "(std) "
#INCLUDE    BIOS\Framework\Devices\SIO.asm
#UNDEFINE   SIO_TYPE
#ENDIF

; SIO #2 following the RC2014 register order
#IFDEF      INCLUDE_SIO_n2_rc
kSIOBase:   .SET kSIO2          ;I/O base address
kSIOACont:  .SET kSIOBase+0     ;I/O address of control register A
kSIOAData:  .SET kSIOBase+1     ;I/O address of data register A
kSIOBCont:  .SET kSIOBase+2     ;I/O address of control register B
kSIOBData:  .SET kSIOBase+3     ;I/O address of data register B
kSIOFlags:  .SET 0b00100000     ;Hardware flags = SIO #2
kSIOACTC:   .SET kSIO2ACTC      ;I/O address of linked CTC port A
kSIOBCTC:   .SET kSIO2BCTC      ;I/O address of linked CTC port A
SIO_n2_rc:
#DEFINE     SIO_TYPE "(rc) "
#INCLUDE    BIOS\Framework\Devices\SIO.asm
#UNDEFINE   SIO_TYPE
#ENDIF

; SIO #2 follows the typical Zilog register order
#IFDEF      INCLUDE_SIO_n2_std
kSIOBase:   .SET kSIO2          ;I/O base address
kSIOACont:  .SET kSIOBase+2     ;I/O address of control register A
kSIOAData:  .SET kSIOBase+0     ;I/O address of data register A
kSIOBCont:  .SET kSIOBase+3     ;I/O address of control register B
kSIOBData:  .SET kSIOBase+1     ;I/O address of data register B
kSIOFlags:  .SET 0b00100000     ;Hardware flags = SIO #2
kSIOACTC:   .SET kSIO2ACTC      ;I/O address of linked CTC port A
kSIOBCTC:   .SET kSIO2BCTC      ;I/O address of linked CTC port A
SIO_n2_std:
#DEFINE     SIO_TYPE ""         ;or "(std) "
#INCLUDE    BIOS\Framework\Devices\SIO.asm
#UNDEFINE   SIO_TYPE
#ENDIF

; ACIA #1
#IFDEF      INCLUDE_ACIA_n1
kACIABase:  .SET kACIA1         ;I/O base address
kACIACont:  .SET kACIABase+0    ;I/O address of control register
kACIAData:  .SET kACIABase+1    ;I/O address of data register
kACIAFlags: .SET 0b00000001     ;Hardware flags = ACIA #1
ACIA_n1:
#INCLUDE    BIOS\Framework\Devices\ACIA.asm
#ENDIF

; ACIA #2
#IFDEF      INCLUDE_ACIA_n2
kACIABase:  .SET kACIA2         ;I/O base address
kACIACont:  .SET kACIABase+0    ;I/O address of control register
kACIAData:  .SET kACIABase+1    ;I/O address of data register
kACIAFlags: .SET 0b00000100     ;Hardware flags = ACIA #2
ACIA_n2:
#INCLUDE    BIOS\Framework\Devices\ACIA.asm
#ENDIF

; CTC #1
#IFDEF      INCLUDE_CTC_n1
kDevBase:   .SET kCTC1          ;I/O base address
kDevFlags:  .SET 0b00010000     ;Hardware flags = CTC #1
;kDevTick:  .SET 2              ;Channel (0 to 3) for 200Hz tick
CTC_n1:
#INCLUDE    BIOS\Framework\Devices\CTC.asm
#ENDIF

; CTC #2
#IFDEF      INCLUDE_CTC_n2
kDevBase:   .SET kCTC2          ;I/O base address
kDevFlags:  .SET 0b01000000     ;Hardware flags = CTC #2
;kDevTick:  .SET 2              ;Channel (0 to 3) for 200Hz tick
CTC_n2:
#INCLUDE    BIOS\Framework\Devices\CTC.asm
#ENDIF

; SCC #1
#IFDEF      INCLUDE_SCC_n1
kSCCBase:   .SET kSCC1          ;I/O base address
kSCCBCont:  .SET kSCCBase+0     ;I/O address of control register B
kSCCACont:  .SET kSCCBase+1     ;I/O address of control register A
kSCCBData:  .SET kSCCBase+2     ;I/O address of data register B
kSCCAData:  .SET kSCCBase+3     ;I/O address of data register A
kSCCFlags:  .SET 0b00000000     ;Hardware flags = SCC #1
SCC_n1:
#INCLUDE    BIOS\Framework\Devices\SCC.asm
#ENDIF

; SCC #2
#IFDEF      INCLUDE_SCC_n2
kSCCBase:   .SET kSCC2          ;I/O base address
kSCCBCont:  .SET kSCCBase+0     ;I/O address of control register B
kSCCACont:  .SET kSCCBase+1     ;I/O address of control register A
kSCCBData:  .SET kSCCBase+2     ;I/O address of data register B
kSCCAData:  .SET kSCCBase+3     ;I/O address of data register A
kSCCFlags:  .SET 0b00000000     ;Hardware flags = SCC #2
SCC_n2:
#INCLUDE    BIOS\Framework\Devices\SCC.asm
#ENDIF

; Compact flash interface (8-bit IDE direct on bus)
#IFDEF      INCLUDE_CFCard
kCFBase:    .SET kCFCard        ;I/O base address
CFCard:
#INCLUDE    BIOS\Framework\Devices\CFCard.asm
#ENDIF

; Diagnostic LEDs (digital output port with 8 LEDs)
#IFDEF      INCLUDE_DiagLEDs
kDiagBase:  .EQU kDiagLEDs      ;I/O base address
DiagLEDs:
#INCLUDE    BIOS\Framework\Devices\DiagLEDs.asm
#ENDIF

; Status LED (single LED)
#IFDEF      INCLUDE_StatusLED
kStatBase:  .EQU kPrtLED        ;I/O base address
StatusLED:
#INCLUDE    BIOS\Framework\Devices\StatusLED.asm
#ENDIF

; LCD 16x2
#IFDEF      INCLUDE_LCD16x2
kL16x2Base: .SET 0x68           ;I/O base address
kL16x2Flags:                    .SET 0b00000000 ;Hardware flags = SCC #2
LCD16x2:
#INCLUDE    BIOS\Framework\Devices\LCD16x2.asm
#ENDIF


; **********************************************************************
; Ensure we assemble to code area

            .CODE

; **********************************************************************
; Self-test
;   On entry: No parameters required
;   On exit:  AF BC DE HL not specified
;             IX IY I AF' BC' DE' HL' not specified
; H_Test      see Selftest.asm


; **********************************************************************
; Initialise BIOS and hardware
;   On entry: No parameters required
;   On exit:  AF BC DE HL not specified
;             IX IY I AF' BC' DE' HL' preserved
; Identify and initialise hardware
; Sets up hardware present flags:
;   Bit 0 = ACIA #1 
;   Bit 1 = SIO #1
;   Bit 2 = ACIA #2
;   Bit 3 = Bit-bang serial
;   Bit 4 = CTC #1
;   Bit 5 = SIO #2 
;   Bit 6 = CTC #2
;   Bit 7 = Z180 serial (or other serial device???)
H_Init:     CALL F_Init         ;Use framework

; Set defaults (this should probably be done by system, not in BIOS)
; The first four console devices have preset baud rates 
            LD   HL,kaBaud1Def  ;Start of baud rates table in ROM
            LD   C,1            ;Console device (1 to 4)
            LD   B,4            ;Number of console devices
@Loop:      LD   A,(HL)         ;Baud rate code
            OR   A              ;Is baud rate specified?
            JR   Z,@Next        ;No, so skip
            PUSH BC
            PUSH HL
            CALL F_SetBaud      ;Use framework to set baud rate
            POP  HL
            POP  BC
@Next:      INC  C              ;Increment console device number
            INC  HL             ;Increment table pointer
            DJNZ @Loop
            RET

; The BIOS framework requires a list of supported devices
; WARNING: SIO port A must be an odd numbered console devices
;          SIO port B must be an even numbered console devices
;          Therefore the SIO devices are listed first
;          SCC (85C50) also requires port A to be odd number
Interfaces:
#IFDEF      INCLUDE_SIO_n1_rc
            .DW  SIO_n1_rc
#ENDIF
#IFDEF      INCLUDE_SIO_n1_std
            .DW  SIO_n1_std
#ENDIF
#IFDEF      INCLUDE_SIO_n2_rc
            .DW  SIO_n2_rc
#ENDIF
#IFDEF      INCLUDE_SIO_n2_std
            .DW  SIO_n2_std
#ENDIF
#IFDEF      INCLUDE_SCC_n1
            .DW  SCC_n1
#ENDIF
#IFDEF      INCLUDE_SCC_n2
            .DW  SCC_n2
#ENDIF
#IFDEF      INCLUDE_CTC_n1
            .DW  CTC_n1
#ENDIF
#IFDEF      INCLUDE_CTC_n2
            .DW  CTC_n2
#ENDIF
#IFDEF      INCLUDE_ACIA_n1
            .DW  ACIA_n1
#ENDIF
#IFDEF      INCLUDE_ACIA_n2
            .DW  ACIA_n2
#ENDIF
#IFDEF      INCLUDE_BitBangSerial_SC1
            .DW  BitBangSerial_SC1
#ENDIF
#IFDEF      INCLUDE_CFCard
            .DW  CFCard
#ENDIF
#IFDEF      INCLUDE_DiagLEDs
            .DW  DiagLEDs
#ENDIF
#IFDEF      INCLUDE_StatusLED
            .DW  StatusLED
#ENDIF
#IFDEF      INCLUDE_LCD16x2
            .DW  LCD16x2
#ENDIF
            .DW  0              ;End of list


; **********************************************************************
; H_GetName   see BIOS_Common.asm


; **********************************************************************
; H_GetVers   see BIOS_Common.asm


; **********************************************************************
; Set baud rate
;   On entry: A = Baud rate code
;             C = Console device number (1 to 6)
;   On exit:  IF successful: (ie. valid device and baud code)
;               A != 0 and NZ flagged
;             BC DE HL not specified
;             IX IY I AF' BC' DE' HL' preserved
; A test is made for valid a device number and baud code.
H_SetBaud:  JP   F_SetBaud      ;Use framework


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
; Set up event handler by writing to jump table
@IdleSet:   LD   A,kFnIdle      ;Jump table 0x0C = idle handler
            JP   InitJump       ;Write jump table entry A
; Idle events off handler 
@Return:    XOR  A              ;Return no event (A=0 and Z flagged)
            RET                 ;Idle mode zero routine
; Vector for event handler
@Vector:    .DW  @Return        ;Mode 0 = Off
            .DW  H_PollT2       ;Mode 1 = Hardware, no software version

H_PollT2:   RET


; **********************************************************************
; Output devices message
;   On entry: No parameters required
;   On exit:  AF BC DE HL not specified
;             IX IY I AF' BC' DE' HL' preserved
; List all supported interface devices followed by current console devices
H_MsgDevs:  JP   F_MsgDevs      ;Use framework


; **********************************************************************
; Read from banked RAM
;   On entry: DE = Address in secondary bank
;   On exit:  A = Byte read from RAM
;             F BC DE HL not specified
;             IX IY I AF' BC' DE' HL' preserved
;H_RdRAM:                       ;See Framework\BankedRAM_SC1.asm


; **********************************************************************
; Write to banked RAM
;   On entry: A = Byte to be written to RAM
;             DE = Address in secondary bank
;   On exit:  AF BC DE HL not specified
;             IX IY I AF' BC' DE' HL' preserved
;H_WrRAM:                       ;See Framework\BankedRAM_SC1.asm


; **********************************************************************
; Copy from banked ROM to RAM
;   On entry: A = ROM bank number (0 to n)
;             HL = Source start address (in ROM)
;             DE = Destination start address (in RAM)
;             BC = Number of bytes to copy
;   On exit:  AF BC DE HL not specified
;             IX IY I AF' BC' DE' HL' preserved
;H_CopyROM:                     ;See Framework\BankedROM_SC1.asm


; **********************************************************************
; Execute code in ROM bank
;   On entry: A = ROM bank number (0 to 3)
;             DE = Absolute address to execute
;   On exit:  AF BC DE HL not specified
;             IX IY I AF' BC' DE' HL' preserved
;H_ExecROM:                     ;See Framework\BankedROM_SC1.asm


; **********************************************************************
; H_Delay     see BIOS_Common.asm


; **********************************************************************
; Support functions

; None!


; **********************************************************************
; **  Public workspace (in RAM)                                       **
; **********************************************************************

            .DATA

; None!







































