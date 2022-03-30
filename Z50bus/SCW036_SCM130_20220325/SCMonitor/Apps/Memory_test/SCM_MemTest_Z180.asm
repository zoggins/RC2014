; **********************************************************************
; **  Memory test for RC2014 etc                by Stephen C Cousins  **
; **********************************************************************

; This version is for the Z180 CPU with a simple linear physical memory 
; map:
;    0x00000 to 0x7FFFF = ROM
;    0x80000 to 0xFFFFF = RAM
;
; Only 64k bytes of RAM are tested
;
; Lower 32K memory test:
; The ROM is paged out so there is RAM from 0x0000 to 0x7FFF
; This RAM is then tested
; If a failure is found the faulty address is stored at <result>
; otherwise <result> contains 0x8000
;
; Upper 32K memory test:
; If a failure is found the faulty address is stored at <result>
; otherwise <result> contains 0x0000


            .PROC Z180          ;SCWorkshop select processor

Result:     .EQU 0x8090

            .ORG 0x8000

; Test lower 32K of RAM

Test:       CALL MMU_RAM        ;Page in RAM to lower memory

            LD   HL,0x0000      ;Start location

@Lower:     LD   A,(HL)         ;Current contents
            LD   C,A            ;Store current contents
            CPL                 ;Invert bits
            LD   (HL),A         ;Write test pattern
            CP   (HL)           ;Read back and compare
            JR   NZ,@LoEnd      ;Abort if not the same
            LD   A,C            ;Get original contents
            LD   (HL),A         ;Restore origianl contents
            CP   (HL)           ;Read back and compare
            JR   NZ,@LoEnd      ;Abort if not the same
            INC  HL             ;Point to next location
            LD   A,H
            CP   0x80           ;Have we finished?
            JR   NZ,@Lower

@LoEnd:     CALL MMU_ROM        ;Page in ROM to lower memory

            LD   (Result),HL    ;Store current address
            LD   A,H
            CP   0x80           ;Pass?
            JR   NZ,@Failed     ;No, so go report failure

; Test upper 32K of RAM

            LD   HL,BeginTest   ;Start location

@Upper:     LD   A,(HL)         ;Current contents
            LD   C,A            ;Store current contents
            CPL                 ;Invert bits
            LD   (HL),A         ;Write test pattern
            CP   (HL)           ;Read back and compare
            JR   NZ,@HiEnd      ;Abort if not the same
            LD   A,C            ;Get original contents
            LD   (HL),A         ;Restore origianl contents
            CP   (HL)           ;Read back and compare
            JR   NZ,@HiEnd      ;Abort if not the same
            INC  HL             ;Point to next location
            LD   A,H
            CP   0x00           ;Have we finished?
            JR   NZ,@Upper

@HiEnd:     LD   (Result),HL    ;Store current address
            LD   A,H
            CP   0x00           ;Pass?
            JR   NZ,@Failed     ;No, so go report failure

            LD   DE,@Pass       ;Pass message
            LD   C,6            ;API 6
            RST  0x30           ;  = Output message at DE

            LD   C,3            ;API 3
            RST  0x30           ;  = Test for input character
            JR   Z,Test         ;None, so repeat test

            LD   C,1            ;API 1
            RST  0x30           ;  = Input character (flush it)

            LD   C,7            ;API 7
            RST  0x30           ;  = Output new line

            RET

@Failed:    LD   DE,@Fail       ;Fail message
            LD   C,6            ;API 6
            RST  0x30           ;  = Output message at DE
            RET

@Pass:      .DB  "Pass ",0
@Fail:      .DB  "Fail",0x0D,0x0A,0

;BeginTest: ; Upper memory test begins here



; **********************************************************************
; Memory Management Unit (MMU)
;
;kZ180:     .EQU 0xC0           ;Z180 internal register base address
kZ180:      .EQU 0xC0           ;Z180 internal register base address
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
            OUT0 (BBR), A       ;  Bank Base = 0x00000
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
            OUT0 (BBR), A       ;  Bank Base = 0x80000
;           LD   A, 0x80        ;Physical memory base address:  0xF0*
;           OUT0 (CBR), A       ;  Common Base = 0x88000
;           LD   A, 0x80        ;Logical memory base addresses: 0x80*
;           OUT0 (CBAR), A      ;  Bank = 0x0000, Common = 0x8000
            RET
; Pre SCM v1.3

BeginTest:  ; Upper memory test begins here


