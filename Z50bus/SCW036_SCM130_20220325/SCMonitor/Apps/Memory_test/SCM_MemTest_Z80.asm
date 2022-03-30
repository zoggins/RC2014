; **********************************************************************
; **  Memory test for RC2014 etc                by Stephen C Cousins  **
; **********************************************************************

; Lower 32K memory test: 
; The ROM is paged out so there is RAM from 0x0000 to 0x7FFF
; This RAM is then tested
; If a failure is found the faulty address is stored at <result>
; otherwise <result> contains 0x8000
;
; Upper 32K memory test:
; If a failure is found the faulty address is stored at <result>
; otherwise <result> contains 0x0000


            .PROC Z80           ;SCWorkshop select processor

Result:     .EQU 0x8070

            .ORG 0x8000

; Test lower 32K of RAM

Test:       LD   A,1            ;So it works on LiNC80 etc
            OUT  (0x38),A       ;Page out ROM

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

@LoEnd:     XOR  A              ;So it works on LiNC80 etc
            OUT  (0x38),A       ;Page in ROM

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

BeginTest:  ; Upper memory test begins here




