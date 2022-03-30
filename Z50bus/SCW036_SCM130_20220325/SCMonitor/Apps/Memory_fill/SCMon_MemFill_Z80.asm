; **********************************************************************
; **  Memory fill for RC2014 etc                by Stephen C Cousins  **
; **********************************************************************

; The program fills all 64k RAM except the few bytes used by this code.


            .PROC Z80           ;SCWorkshop select processor

            .ORG 0x8000

Test:       LD   C,0x55         ;Byte to fill memory with

            LD   A,1            ;So it works on LiNC80 etc
            OUT  (0x38),A       ;Page out ROM

; Fill lower 32K of RAM
            LD   HL,0x0000      ;Start location
@Lower:     LD   (HL),C         ;Write fill byte to RAM
            INC  HL             ;Point to next location
            LD   A,H
            CP   0x80           ;Have we finished?
            JR   NZ,@Lower

            XOR  A              ;So it works on LiNC80 etc
            OUT  (0x38),A       ;Page in ROM

; Fill upper 32K of RAM
            LD   HL,BeginTest   ;Start location
@Upper:     LD   (HL),C         ;Write fill byte to RAM
            INC  HL             ;Point to next location
            LD   A,H
            CP   0x00           ;Have we finished?
            JR   NZ,@Upper

            JP   0x0000         ;Reset system

BeginTest:  ; Upper memory fill begins here



