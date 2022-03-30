; **********************************************************************
; **  Z180 Download.com installer               by Stephen C Cousins  **
; **********************************************************************

; The program aids installation of Download.com on to a CP/M system

            .PROC Z180          ;SCWorkshop select processor

; WARNING: This program includes a fiddle as SCM v1.02 set the Z180 base
;          address to 0x40. To avoid two versions of this program for
;          the Z180 the memory management code writes to both the 0x40
;          registers and the kZ180Base registers.
kZ180Base:  .EQU 0xC0           ;Z180 register base address ( 0x40 | 0xC0 )

; WARNING: Code is included for both a typical Z80 system and a typical
;          Z180 system. This is crude and could cause problems for some
;          hardware variations.

            .ORG 0x8000

; Page ROM out of lower memory and RAM in
            CALL MMU_RAM        ;Z180 version
            LD   A,1
            OUT  (0x38),A       ;Z80 version

; Move downlaod.com program code to 0x0100 
            LD   HL,Program
            LD   DE,0x0100
            LD   BC,ProgramEnd-Program
            LDIR   

; Page ROM back into lower memory and RAM out
            CALL MMU_ROM        ;Z180 version
            XOR  A
            OUT  (0x38),A       ;Z80 version

; Display instructions
            LD   DE,Message
            LD   C,6            ;API 0x06
            RST  0x30           ;  = Output string

            RET

Message:    .DB  "Download.com is ready to be saved.",0x0D,0x0A
            .DB  "Start CP/M and enter SAVE 2 DOWNLOAD.COM",0x0D,0x0A
            .DB  0


; **********************************************************************
; Memory Management Unit (MMU)
;
;kZ180:     .EQU 0xC0 | 0x40    ;Z180 internal register base address
kZ180:      .EQU kZ180Base      ;Z180 internal register base address
CBR:        .EQU kZ180 + 0x38   ;MMU Control Base Register
BBR:        .EQU kZ180 + 0x39   ;MMU Bank Base Register
CBAR:       .EQU kZ180 + 0x3A   ;MMU Common/Bank Register
;
; Logical (64k) memory is divided into three areas:
;   Common(0)  This is always 0x0000
;   Bank       Starts at BA * 0x1000
;   Common     Starts at CA * 0x1000
;
; Physical (1M) memory is determined as follows:
;    Common(0)  This always starts at 0x00000
;    Bank       Starts at (CBR+CA) * 0x1000
;    Common     Starts at (BBR+BA) * 0x1000
;
; Registers:
;    Bank Base Register        (BBR)  = 0x00 to 0xFF
;    Common Base Register      (CBR)  = 0x00 to 0xFF
;    Common/Bank Area Register (CBAR) = CA.BA (nibbles)
;
; Following a hardware reset the MMU registers are:
;    BBR=0x00, CBR = 0x00, CBAR = 0xFF (= CA.BA)
; Thus the logical (64k) memory to physical (1M) memory mapping is:
;    Common(0) 0x0000 to 0xEFFF -> 0x00000 to 0x0EFFF (ROM)
;    Bank      0xF000 to 0xF000 -> 0x0F000 to 0x0F000 (RAM)
;    Common(1) 0xF000 to 0xFFFF -> 0x0F000 to 0x0FFFF (RAM)
;
; Following SCM initialisation: prior to SCM v1.30
; The logical (64k) memory to physical (1M) memory mapping is such
; that the bottom 32k bytes of logical memory is the bottom 32k
; bytes of the physical Flash ROM, and the top 32k bytes of logical 
; memory is the top 32k bytes of the physical RAM.
;    Common(0) 0x0000 to 0x0000 -> 0x00000 to 0x00000 (ROM)
;    Bank      0x0000 to 0x7FFF -> 0x00000 to 0x07FFF (ROM)
;    Common(1) 0x8000 to 0xFFFF -> 0xF8000 to 0xFFFFF (RAM)
; This is achieved by setting the registers as follows:
;    CBAR = CA.BA = 0x8.0x0 = 0x80
;    BBR  = (physical address)/0x1000 - BA = 0x00 - 0x0 = 0x00
;    CBR  = (physical address)/0x1000 - BA = 0xF8 - 0x8 = 0xF0
;           LD   A, 0x00        ;Physical memory base address:
;           OUT0 (BBR), A       ;  Bank Base = 0x00000
;           LD   A, 0xF0        ;Physical memory base address:
;           OUT0 (CBR), A       ;  Common Base = 0xF8000
;           LD   A, 0x80        ;Logical memory base addresses:
;           OUT0 (CBAR), A      ;  Bank = 0x0000, Common = 0x8000
;
; Following SCM initialisation: from SCM v1.30
; The logical (64k) memory to physical (1M) memory mapping is such
; that the bottom 32k bytes of logical memory is the bottom 32k
; bytes of the physical Flash ROM, and the top 32k bytes of logical 
; memory is near the bottom of the physical RAM.
;    Common(0) 0x0000 to 0x0000 -> 0x00000 to 0x00000 (ROM)
;    Bank      0x0000 to 0x7FFF -> 0x00000 to 0x07FFF (ROM)
;    Common(1) 0x8000 to 0xFFFF -> 0x88000 to 0x8FFFF (RAM)
; This is achieved by setting the registers as follows:
;    CBAR = CA.BA = 0x8.0x0 = 0x80
;    BBR  = (physical address)/0x1000 - BA = 0x00 - 0x0 = 0x00
;    CBR  = (physical address)/0x1000 - BA = 0x88 - 0x8 = 0x80
;           LD   A, 0x00        ;Physical memory base address:
;           OUT0 (BBR), A       ;  Bank Base = 0x00000
;           LD   A, 0x80        ;Physical memory base address:
;           OUT0 (CBR), A       ;  Common Base = 0x88000
;           LD   A, 0x80        ;Logical memory base addresses:
;           OUT0 (CBAR), A      ;  Bank = 0x0000, Common = 0x8000


; Page ROM into logical memory (0x0000 to 0x7FFF)
;
; Set up logical (64k) memory to physical (1M) memory mapping
; such that the bottom 32k bytes of logical memory is the bottom 32k
; bytes of the physical Flash ROM, and the top 32k bytes of logical 
; memory is near the bottom of the physical RAM.
;    Common(0) 0x0000 to 0x0000 -> 0x00000 to 0x00000 (ROM)
;    Bank      0x0000 to 0x7FFF -> 0x00000 to 0x07FFF (ROM)
;    Common(1) 0x8000 to 0xFFFF -> 0x88000 to 0x8FFFF (RAM)
; 
; This is achieved by setting the registers as follows:
;    CBAR = CA.BA = 0x8.0x0 = 0x80
;    BBR  = (physical address)/0x1000 - BA = 0x00 - 0x0 = 0x00
;    CBR  = (physical address)/0x1000 - BA = 0x88 - 0x8 = 0x80
MMU_ROM:    LD   A, 0x00        ;Physical memory base address:  0x00*
;           OUT0 (BBR), A       ;  Bank Base = 0x00000
;           OUT0 (0x79),A       ;Fiddle as SCM 1.02 had base at 0x40
            LD   B,0
            LD   C,BBR
            OUT  (C),A
            LD   C,0x79
            OUT  (C),A
;           LD   A, 0x80        ;Physical memory base address:  0xF0*
;           OUT0 (CBR), A       ;  Common Base = 0x88000
;           LD   A, 0x80        ;Logical memory base addresses: 0x80*
;           OUT0 (CBAR), A      ;  Bank = 0x0000, Common = 0x8000
            RET
; Pre SCM v1.3


; Page RAM into logical memory (0x0000 to 0x7FFF)
;
; Set up logical (64k) memory to physical (1M) memory mapping
; such that the bottom 32k bytes of logical memory is the bottom 32k
; bytes of the physical RAM, and the top 32k bytes of logical 
; memory is the bottom 32k bytes of the physical RAM.
;    Common(0) 0x0000 to 0x0000 -> 0x00000 to 0x00000 (ROM)
;    Bank      0x0000 to 0x7FFF -> 0x80000 to 0x87FFF (RAM)
;    Common(1) 0x8000 to 0xFFFF -> 0x88000 to 0x8FFFF (RAM)
; 
; This is achieved by setting the registers as follows:
;    CBAR = CA.BA = 0x8.0x0 = 0x80
;    BBR  = (physical address)/0x1000 - BA = 0x80 - 0x0 = 0x80
;    CBR  = (physical address)/0x1000 - BA = 0x88 - 0x8 = 0x80
MMU_RAM:    LD   A, 0x80        ;Physical memory base address:  0x80*
;           OUT0 (BBR), A       ;  Bank Base = 0x80000
;           OUT0 (0x79),A       ;Fiddle as SCM 1.02 had base at 0x40
            LD   B,0
            LD   C,BBR
            OUT  (C),A
            LD   C,0x79
            OUT  (C),A
;           LD   A, 0x80        ;Physical memory base address:  0xF0*
;           OUT0 (CBR), A       ;  Common Base = 0x88000
;           LD   A, 0x80        ;Logical memory base addresses: 0x80*
;           OUT0 (CBAR), A      ;  Bank = 0x0000, Common = 0x8000
            RET
; Pre SCM v1.3


; **********************************************************************
; Include the DOWNLOAD.COM program code

Program:
#INSERTHEX  Includes/DOWNLOAD2.hex
ProgramEnd:







