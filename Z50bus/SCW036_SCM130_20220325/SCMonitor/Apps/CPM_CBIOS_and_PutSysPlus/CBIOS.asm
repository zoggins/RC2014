; **********************************************************************
; **  CP/M 2.2 CBIOS                            by Stephen C Cousins  **
; **  Based on code by Grant Searle (www.searle.wales)                **
; **********************************************************************

; SCC  2022-03-24 : Release version


; **********************************************************************

;#DEFINE    DEBUG

#INCLUDE    Configure.asm       ;Configuration options

; The configuration file establishes options via #DEFINEs and .EQUs


; **********************************************************************
; **  Memory map
; **********************************************************************

#IFDEF      DEBUG
ccp         .EQU 0xC000         ;Base of CCP
bdos        .EQU ccp + 0x0806   ;Base of BDOS
bios        .EQU ccp + 0x1600   ;Base of BIOS
DataORG:    .EQU 0xDC88         ;Start of workspace data section
#ELSE
ccp         .EQU 0xD000         ;Base of CCP
bdos        .EQU ccp + 0x0806   ;Base of BDOS
bios        .EQU ccp + 0x1600   ;Base of BIOS
DataORG:    .EQU 0xEC88         ;Start of workspace data section
#ENDIF

#IFDEF      DEBUG
iobyte      .EQU 0x9003         ; Intel standard I/O definition byte.
userdrv     .EQU 0x9004         ; Current user number and drive.
tpabuf      .EQU 0x9080         ; Default I/O buffer and command line storage.
#ELSE
iobyte      .EQU 0x0003         ; Intel standard I/O definition byte.
userdrv     .EQU 0x0004         ; Current user number and drive.
tpabuf      .EQU 0x0080         ; Default I/O buffer and command line storage.
#ENDIF

; **********************************************************************
; ** Constants  
; **********************************************************************

LF          .EQU 0AH            ;line feed
FF          .EQU 0CH            ;form feed
CR          .EQU 0DH            ;carriage RETurn

#IF         MPType = "Z180"
kZ180:      .EQU kMPBase
#INCLUDE    Includes/Z180-constants.asm
#ENDIF


; **********************************************************************
; **  Establish memory sections
; **********************************************************************

            .DATA
            .ORG  DataORG       ;Establish start of data section

            .CODE
            .ORG  bios          ;Establish start of code section


; **********************************************************************
; **  Program code 
; **********************************************************************

#IF         MPType = "Z80"
            .PROC Z80
#ENDIF
#IF         MPType = "Z180"
            .PROC Z180
#ENDIF
            .HEXBYTES 0x18      ;SCWorkshop Intel Hex output format

            .CODE

; **********************************************************************
; **  BIOS jump table
; **********************************************************************

            JP   boot           ;  0 Initialize
wboote:     JP   wboot          ;  1 Warm boot
            JP   const          ;  2 Console status
            JP   conin          ;  3 Console input
            JP   conout         ;  4 Console output
            JP   list           ;  5 List output
            JP   punch          ;  6 punch output
            JP   reader         ;  7 Reader input
            JP   home           ;  8 Home disk
            JP   seldsk         ;  9 Select disk
            JP   settrk         ; 10 Select track
            JP   setsec         ; 11 Select sector
            JP   setdma         ; 12 Set DMA Address
            JP   read           ; 13 Read 128 bytes
            JP   write          ; 14 Write 128 bytes
            JP   listst         ; 15 List status
            JP   sectran        ; 16 Sector translate


; **********************************************************************
; **  Include support for storage device(s)
; **********************************************************************

; The storage device (SD) module must provide entry points:
;    SD_cboot                   ;Initialise storage device (cold boot)
;    SD_wboot                   ;Initialise storage device (warm boot)
;    SD_home                    ;BIOS fn 8, Home disk
;    SD_seldsk                  ;BIOS fn 9, Select disk
;    SD_settrk                  ;BIOS fn 10, Set track
;    SD_setsec                  ;BIOS fn 11, Set sector
;    SD_setdma                  ;BIOS fn 12, Set DMA address
;    SD_read                    ;BIOS fn 13, Read 128 bytes
;    SD_write                   ;BIOS fn 14, Write 128 bytes
;    SD_listst                  ;BIOS fn 15, List status
;    SD_sectran                 ;BIOS fn 16, Sector translate

#INCLUDE    Includes/StorageDevice-CF.asm

home:       .EQU SD_home
seldsk:     .EQU SD_seldsk
settrk:     .EQU SD_settrk
setsec:     .EQU SD_setsec
setdma:     .EQU SD_setdma
read:       .EQU SD_read
write:      .EQU SD_write
sectran:    .EQU SD_sectran


; **********************************************************************
; **  Include support for console device(s)
; **********************************************************************

; The console device (CD) module must provide entry points:
;    CD_cboot                   ;Initialise device(s) (cold boot)
;    CD_InterruptA              ;Interrupt routine for port A receive
;    CD_InterruptB              ;Interrupt routine for port B receive
;    CD_InterruptC              ;Interrupt routine for port C receive
;    CD_InterruptD              ;Interrupt routine for port D receive
;    CD_constA,  CD_constB      ;as BIOS fn 2, Console input status 
;    CD_coninA,  CD_coninB      ;as BIOS fn 3/7 Console/reader input
;    CD_conoutA, CD_conoutB     ;as BIOS fn 4/5/6, Console/list/punch output
; This BIOS supports two devices, typically bi-directional serial ports

#IF         CDType = "ACIA"
#INCLUDE    Includes/ConsoleDevice-ACIA.asm
#ENDIF

#IF         CDType = "ASCI"
#INCLUDE    Includes/ConsoleDevice-ASCI.asm
#ENDIF

#IF         CDType = "SIO"
#INCLUDE    Includes/ConsoleDevice-SIO.asm
#ENDIF

#IF         CDType = "BB96"
#INCLUDE    Includes/ConsoleDevice-BB96.asm
#ENDIF


; **********************************************************************
; **  Cold boot
; **********************************************************************

            .CODE

boot:       DI                  ;Disable interrupts
            LD   SP,biosstack   ;Set default stack

#IFDEF      DEBUG
            LD   A,0x01         ;(List is TTY:, Punch is TTY:, Reader is TTY:, Console is TTY:)
            LD   (iobyte),A
#ENDIF

#IFNDEF     DEBUG               ;Debug needs ROM
#IF         MPType = "Z80"
            LD   A,0x01
            OUT  (0x38),A       ;Turn off ROM
#ENDIF
#IF         MPType = "Z180"
;           LD   A,0x01
;           OUT  (0x38),A       ;Turn off ROM
            LD   A,kMPBase      ;Early version of SCM had Z180 base at 0x40
            OUT0 (0x7F),A       ;Start of Z180 internal I/O
#ENDIF
#ENDIF

            CALL CD_cboot       ;Initialise console devices

            CALL printInline    ;Output startup copyright message
            .DB  FF

#IFDEF      NOCHANCE
            .DB "CBIOS "        ; v2.0.0 "
#IF         MPType = "Z80"
            .DB "Z80 "
#ENDIF
#IF         MPType = "Z180"
            .DB "Z180"
#IF         CPUBase = "0xC0"
            .DB "@C0 "
#ENDIF
#ENDIF
#IF         CFBase = "0x10"
            .DB "CFx10 "
#ENDIF
#IF         CFBase = "0x90"
            .DB "CF@90 "
#ENDIF
#IF         CFSize = "64MB"
            .DB "CF64 "
#ENDIF
#IF         CFSize = "128MB"
            .DB "CF128 "
#ENDIF
            .DB CR,LF
            .DB CR,LF
#ENDIF

            .TEXT "CP/M 2.2 "
            .TEXT "Copyright"
            .TEXT " 1979 (c) by Digital Research"
            .DB  ", BIOS-"
            .DB  kBIOS
            .DB  " ("
            #DB  DATE
            .DB  ")"
            .DB CR,LF,0

#IFDEF      DEBUG
@WaitIn:    CALL const
            OR   A
            JR   Z,@WaitIn

            CALL conin

            LD   C,A
            CALL conout

            JR   @WaitIn
#ENDIF

            CALL SD_cboot       ;Cold boot initialise storage devices

            XOR A
            LD (userdrv),A      ;Clear user drive byte

            JP gocpm


; **********************************************************************
; **  Warm boot
; **********************************************************************

wboot:      DI                  ;Disable interrupts
            LD SP,biosstack     ;Set default stack

#IFNDEF     DEBUG               ;Debug needs ROM
#IF         MPType = "Z80"
            LD   A,0x01
            OUT  (0x38),A       ;Turn off ROM
#ENDIF
#IF         MPType = "Z180"
;           LD   A,0x01
;           OUT  (0x38),A       ;Turn off ROM
#ENDIF
#ENDIF

            CALL SD_wboot       ;Warm boot initialise storage devices

;           JP gocpm            ;Fall through to gocpm


; **********************************************************************
; **  Common code for cold and warm boot
; **********************************************************************

gocpm:      LD   HL,CD_InterruptA
            LD   ($40),HL       ;Address of console device interrupt

            LD   HL,tpabuf      ;Address of BIOS DMA buffer
            LD   (dmaAddr),HL
            LD   A,0C3h         ;Opcode for 'JP'
            LD   (00h),A        ;Load at start of RAM
            LD   HL,wboote      ;ADDress of jump for a warm boot
            LD   (01h),HL
            LD   (05h),A        ;Opcode for 'JP'
            LD   HL,bdos        ;ADDress of jump for the BDOS
            LD   (06h),HL
            LD   A,(userdrv)    ;Save new drive number (0)
            LD   C,A            ;Pass drive number in C

#IFDEF      INTERRUPT_MODE_1
; Store jump instrucion at Z80's mode 1 interrupt location
            LD   A,0xC3         ;Z80 JP instruction op-code
            LD   (0x0038),A
            LD   HL,CD_Interrupt
            LD   (0x0039),HL
            IM   1              ;Set interrupt mode 1
#ELSE
; Store high byte of mode 2 interrupt vector table
            LD   A,intvecHi
            LD   I,A            ;Set interrupt vector page 
            IM   2              ;Set interrupt mode 1
#ENDIF
            EI                  ;Enable interrupts

            JP   ccp            ;Start CP/M by jumping to the CCP


; **********************************************************************
; **  Console/Reader/List/Punch device support
; **********************************************************************

            .CODE

; **********************************************************************
; Console device status
;
; On entry: No parameters
; On exit:  A = 0xFF if character(s) available
;           A = 0x00 if no characters available

const:      LD   A,(iobyte)
            AND  00001011b      ;Mask off console and high bit of reader
            CP   00001010b      ;Redirected to reader on UR1/2 (Serial A)
            JP   Z,CD_constA
            CP   00000010b      ;Redirected to reader on TTY/RDR (Serial B)
            JP   Z,CD_constB
            AND  0x03           ;Remove the reader from the mask - only console bits then remain
            CP   0x01
            JP   NZ,CD_constB
            JP   CD_constA

; **********************************************************************
; Reader device character input
;
; On entry: No parameters
; On exit:  A = character input

reader:     LD   A,(iobyte)
            AND  0x08
            CP   0x08
            JR   coninX
;           JP   NZ,coninB
;           JP   coninA

; **********************************************************************
; Console device character input
;
; On entry: No parameters
; On exit:  A = character input

conin:      LD   A,(iobyte)
            AND  0x03
            CP   0x02
            JP   Z,reader       ; "BAT:" redirect
            CP   0x01
coninX:     JP   NZ,CD_coninB
            JP   CD_coninA

; **********************************************************************
; List device character output
;
; On entry: C = character to output
; On exit:  No return value

list:       LD   A,(iobyte)
            AND  0xC0
            CP   0x40
            JR   conoutX
;           JP   NZ,conoutB
;           JP   conoutA

; **********************************************************************
; Punch device character output
;
; On entry: C = character to output
; On exit:  No return value

punch:      LD   A,(iobyte)
            AND  0x20
            CP   0x20
            JR   conoutX
;           JP   NZ,conoutB
;           JP   conoutA

; **********************************************************************
; Console device character output
;
; On entry: C = character to output
; On exit:  No return value

conout:     LD   A,(iobyte)
            AND  0x03
            CP   0x02
            JR   Z,list         ; "BAT:" redirect
            CP   0x01
conoutX:    JP   NZ,CD_conoutB
            JP   CD_conoutA

; **********************************************************************
; List device status
;
; On entry: No parameters
; On exit:  A = 0xFF if character(s) available
;           A = 0x00 if no characters available

listst:     LD   A,0xFF         ;Return list status of 0xFF (ready)
            RET


; **********************************************************************
; **  Utilities
; **********************************************************************

printInline:
            EX   (SP),HL        ;PUSH HL and put RET ADDress into HL
            PUSH  AF
            PUSH  BC
nextILChar: LD    A,(HL)
            OR    A
            JR    Z,endOfPrint
            PUSH  HL
#IFDEF      DEBUG
            LD    C,2
            RST   $30
#ELSE
            LD    C,A
            CALL  conout        ;Print to TTY
#ENDIF
            POP   HL
            INC   HL
            JR    nextILChar
endOfPrint: INC   HL            ;Get past "null" terminator
            POP   BC
            POP   AF
            EX    (SP),HL       ;PUSH new RET ADDress on stack and restore HL
            RET


; **********************************************************************
; **  Special configuration code executed when CP/M first loaded
; **  Warning: Monitor must PUSH required console device number to stack
; **********************************************************************

popAndRun:
#IFNDEF     DEBUG               ;Don't need this in debug mode
            LD   A,0x01 
            OUT  (0x38),A       ;Disable ROM

            POP  AF             ;POP active I/O port from stack
            CP   0x01
            JR   Z,consoleAtB
            LD   A,0x01         ;(List is TTY:, Punch is TTY:, Reader is TTY:, Console is CRT:)
            JR   setIOByte
consoleAtB: LD   A,0x00         ;(List is TTY:, Punch is TTY:, Reader is TTY:, Console is TTY:)
setIOByte:  LD   (iobyte),A

            JP   bios           ;Start CP/M
#ENDIF


; **********************************************************************
; **  Workspace (in RAM)
; **********************************************************************


FillSpace:  .DS  DataORG - $    ;Fill space to start of workspace data

            .DATA

            .DS  0x20           ;Start of BIOS stack area.
biosstack:  .EQU $


; **********************************************************************
; **  Fixed memory locations
; **********************************************************************

; **********************************************************************
; Relocate TPA area from 8100 to 0100 then start CP/M
; Used to manually transfer a loaded program after CP/M was previously loaded

; NOT SUPPORTED
#IFDEF      NOCHANCE
            .CODE
            .ORG 0FFE8H

#IFNDEF     DEBUG
#IF         MPType ="Z80"
            LD   A,0x01
            OUT  (0x38),A
#ENDIF

            LD   HL,0x8100
            LD   DE,0x0100
            LD   BC,0x6000
            LDIR
            JP   bios
#ENDIF
#ENDIF


; **********************************************************************
; Mode 2 interrupt vectors

; 14 interrupt vectors are supported stating at 0xFFE0
; For the Z80:
;   Register I determines the upper byte of the vector table
;   The lower byte is provided by the interrupting device
;     I=0xFF, LoByte=0xE0-0xFA
; For the Z180:
;   Register I determines the upper byte of the vector table
;   Register IL determines the next highest 3 bits (bits 7 to 5)
;   The lowest 5 bits are determined by the interrupted device 
;     For the internal interrupt sources these bits are fixed:
;       00000 = 0x00 = INT1
;       00010 = 0x02 = INT2
;       00100 = 0x04 = Timer 0
;       00110 = 0x06 = Timer 1
;       01000 = 0x08 = DMA channel 0
;       01010 = 0x0A = DMA channel 1
;       01100 = 0x0C = Clocked serial I/O port
;       01110 = 0x0E = Serial port A
;       10000 = 0x10 = Serial port B
;     For other devices (eg. SIO, PIO) LoByte=0xF2-0xFA
;       I=0xFF, IL=0xE0, Z180=0xE0-0xF0, Other=0xF2-0xF6

#IFDEF      DEBUG
            .ORG 0xEFE0
#ELSE
            .ORG 0xFFE0
#ENDIF

; Interrupt vector table
#IF         MPType = "Z80"
intvec:     .DW  CD_InterruptA  ;@FFE0  Z80 SIO
            .DW  0              ;@FFE2  Z80 spare
            .DW  0              ;@FFE4  Z80 spare
            .DW  0              ;@FFE6  Z80 spare
            .DW  0              ;@FFE8  Z80 spare
            .DW  0              ;@FFEA  Z80 spare
            .DW  0              ;@FFEC  Z80 spare
            .DW  0              ;@FFEE  Z80 spare
            .DW  0              ;@FFF0  Z80 spare
            .DW  0              ;@FFF2  Z80 spare
            .DW  0              ;@FFF4  Z80 spare
            .DW  0              ;@FFF6  Z80 spare
            .DW  0              ;@FFF8  Z80 spare
            .DW  0              ;@FFFA  Z80 spare
#ENDIF
#IF         MPType = "Z180"
intvec:     .DW  0              ;@FFE0  Z180 INT1
            .DW  0              ;@FFE2  Z180 INT2
            .DW  0              ;@FFE4  Z180 Timer 0
            .DW  0              ;@FFE6  Z180 Timer 1
            .DW  0              ;@FFE8  Z180 DMA 0
            .DW  0              ;@FFEA  Z180 DMA 1
            .DW  0              ;@FFEC  Z180 CSerial
intconA:    .DW  CD_InterruptA  ;@FFEE  Z180 ASCI 0
intconB:    .DW  CD_InterruptB  ;@FFF0  Z180 ASCI 1
            .DW  0              ;@FFF2  Z180 spare
            .DW  0              ;@FFF4  Z180 spare
            .DW  0              ;@FFF6  Z180 spare
            .DW  0              ;@FFF8  Z180 spare
            .DW  0              ;@FFFA  Z180 spare
#ENDIF

intvecHi:   .EQU intvec \ 256
intvecLo:   .EQU intvec & 255


; **********************************************************************
; Normal start CP/M vector

            .ORG 0FFFEH

#IFNDEF     DEBUG
            .dw popAndRun
#ENDIF



