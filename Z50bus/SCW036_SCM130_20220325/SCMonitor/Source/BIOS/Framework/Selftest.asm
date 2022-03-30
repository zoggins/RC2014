; **********************************************************************
; **  Selftest at reset for Z180 systems        by Stephen C Cousins  **
; **********************************************************************

; This module provides a self-test function which runs at reset.
;
; Initially the digital status port LEDs each flash in turn. This 
; will run even if there is no RAM.
;
; A very simple RAM test using just location 0xFFFE and 0xFFFF is then
; performed. If it fails the self-test repeats from the beginning, so
; the LEDs keep flashing if the RAM fails.
;

; Must be defined externally, eg:
;kPrtOut:   .EQU 0              ;Assume digital status port is present
;kPrtLED:   .EQU 0x08           ;Motherboard LED (active low)

; RAM test
; Determine hi byte of first address to not be tested
; Code assumes last RAM address is 0x##FF
SlfTstEnd1: .EQU HIGH kEndOfData 
SlfTstEnd2: .EQU SlfTstEnd1 + 1
SlfTstEnd:  .EQU SlfTstEnd2 & 0xFF

; **********************************************************************
; **  Public functions                                                **
; **********************************************************************

            .CODE

; Initialially we assume that there is no RAM so we avoid subroutines.

H_Test:     DI

#IF         PROCESSOR = "Z180"

; Initialise Z180's internal register mapping
#IFNDEF     EXTERNALOS          ;Uses external settings
            LD   A, kZ180       ;Start of Z180 internal I/O
            OUT0 (0x3F), A      ;Address ICR = 0x3F before relocation
#ENDIF

; Initialise Memory Management Unit (MMU)
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
; Initialise logical (64k) memory to physical (1M) memory mapping
; such that the bottom 32k bytes of logical memory is the bottom 32k
; bytes of the physical Flash ROM, and the top 32k bytes of logical 
; memory is the near the bottom of the physical RAM. This arrangement
; means when 64k of logical RAM is required it occupies the bottom 
; 64k of physical RAM.
;    Common(0) 0x0000 to 0x0000 -> 0x00000 to 0x00000 (ROM)
;    Bank      0x0000 to 0x7FFF -> 0x00000 to 0x07FFF (ROM)
;    Common(1) 0x8000 to 0xFFFF -> 0x88000 to 0x8FFFF (RAM) *
; 
; * = Changed from 0xF8000->0xFFFFF to 0x88000->0x8FFFF at 2022-02-18
;
; This is achieved by setting the registers as follows:
;    CBAR = CA.BA = 0x8.0x0 = 0x80
;    BBR  = (physical address)/0x1000 - BA = 0x00 - 0x0 = 0x00
;    CBR  = (physical address)/0x1000 - BA = 0x88 - 0x8 = 0x80
;#IFNDEF    EXTERNALOS          ;Uses external settings
#IFNDEF     DO_NOT_REMAP_MEMORY ;Leave memory map unchanged
            LD   A, 0x00        ;Physical memory base address:
            OUT0 (BBR), A       ;  Bank Base   = 0x00000 to 0x07FFF
            LD   A, 0x80        ;Physical memory base address:
            OUT0 (CBR), A       ;  Common Base = 0x88000 to 0x8FFFF
;           LD   A, 0x80        ;Logical memory base addresses:
            OUT0 (CBAR), A      ;  Bank = 0x0000, Common = 0x8000
#ENDIF

#ENDIF

; Special for SC114 style status LED
#IFDEF      INCLUDE_StatusLED
            LD   A,1
            OUT  (kPrtLED),A    ;Turn off motherboard/status LED
#ENDIF

; Flash LEDs in turn to show we get as far as running code
@Selftest:  LD   DE,1           ;Prepared for delay loop
            LD   A,E            ;First byte to write to LEDs = 0x01
@Loop1:     OUT  (kPrtOut),A    ;Write to LEDs
            ;LD   HL,0xE1C0     ;Set delay time (approx 8000 loops)
#IF         PROCESSOR = "Z180"
; Z180 assumed to have a 18.432MHz clock but currently it has maximum
; wait states added and internal clock divide by 2 so running slowly!
            LD   HL,55000       ;Set delay time (approx 10000 loops)
#ELSE
; Z80 assumed to have a 7.3728MHz clock
            LD   HL,50000       ;Set delay time (approx 15000 loops)
#ENDIF
@Delay1:    ADD  HL,DE          ;Delay loop increments HL until
            JR   NC,@Delay1     ;  it reaches zero
            RLCA                ;Rotate LED bit left
            JR   NC,@Loop1      ;Repeat until last LED cleared
            XOR  A              ;Clear A
            OUT  (kPrtOut),A    ;All LEDs off

#IFDEF      NOCHANCE

; Very brief RAM test
; This is the original RAM test from SCM v1.0 to v1.2
            LD   HL,0xFFFF      ;Location to be tested
            LD   A,0x55         ;Test pattern 01010101
            LD   (HL),A         ;Store 01010101 at 0xFFFF
            DEC  HL             ;HL = 0xFFFE
            CPL                 ;Invert bits to 10101010
            LD   (HL),A         ;Store 10101010 at 0xFFFE
            INC  HL             ;HL = 0xFFFF
            CPL                 ;Invert bits to 01010101
            CP   (HL)           ;Test 01010101 at 0xFFFF
            JR   NZ,@Selftest   ;Failed, so restart
            DEC  HL             ;HL = 0xFFFE
            CPL                 ;Invert bits to 10101010
            CP   (HL)           ;Test 10101010 at 0xFFFE
            JR   NZ,@Selftest   ;Failed so restart
; Repeat with all tests inverted
            CPL                 ;Invert bits to 01010101
            LD   (HL),A         ;Store 01010101 at 0xFFFE
            INC  HL             ;HL = 0xFFFF
            CPL                 ;Invert bits to 10101010
            LD   (HL),A         ;Store 10101010 at 0xFFFF
            DEC  HL             ;HL = 0xFFFE
            CPL                 ;Invert bits to 01010101
            CP   (HL)           ;Test 01010101 at 0xFFFE
            JR   NZ,@Selftest   ;Failed, so restart
            INC  HL             ;HL = 0xFFFF
            CPL                 ;Invert bits to 10101010
            CP   (HL)           ;Test 10101010 at 0xFFFF
            JR   NZ,@Selftest   ;Failed, so restart

#ELSE

; More advanced RAM test
; Test all RAM required for SCM to work properly
; Code assumes last RAM address is 0x##FF
            LD   D,SlfTstEnd    ;Hi byte of last test address
; Test for data errors
            LD   HL, kData      ;Start of RAM to be tested
@TstData:   LD   A,0x00         ;Test data byte
            LD   (HL),A         ;Write to RAM
            CP   (HL)           ;Read back and test it
            JR   NZ,@Selftest   ;Failed, so restart
            LD   A,0xFF         ;Test data byte
            LD   (HL),A         ;Write to RAM
            CP   (HL)           ;Read back and test it
            JR   NZ,@Selftest   ;Failed, so restart
            LD   A,0xAA         ;Test data byte
            LD   (HL),A         ;Write to RAM
            CP   (HL)           ;Read back and test it
            JR   NZ,@Selftest   ;Failed, so restart
            LD   A,0x55         ;Test data byte
            LD   (HL),A         ;Write to RAM
            CP   (HL)           ;Read back and test it
            JR   NZ,@Selftest   ;Failed, so restart
            INC  HL             ;Point to next address
            LD   A,H            ;Get address hi byte
            CP   D              ;End of test range?
            JR   NZ,@TstData    ;No, so repeat
; Test for address errors
            LD   HL, kData      ;Start of RAM to be tested
@TstAddWr:  LD   A,H            ;Generate test data byte
            ADD  L              ;  based on address
            LD   (HL),A         ;Write to RAM
            INC  HL             ;Point to next address
            LD   A,H            ;Get address hi byte
            CP   D              ;End of test range?
            JR   NZ,@TstAddWr   ;No, so repeat
            LD   HL, kData      ;Start of RAM to be tested
@TstAddRd:  LD   A,H            ;Generate test data byte
            ADD  L              ;  based on address
            CP   (HL)           ;Compare with byte from RAM
            JR   NZ,@Selftest   ;Failed, so restart
            INC  HL             ;Point to next address
            LD   A,H            ;Get address hi byte
            CP   D              ;End of test range?
            JR   NZ,@TstAddRd   ;No, so repeat

#ENDIF

;SelftestEnd:
            XOR  A
            OUT  (kPrtOut),A    ;All LEDs off

; Special for SC114 style status LED
#IFDEF      INCLUDE_StatusLED
            ;XOR  A
            OUT  (kPrtLED),A    ;Turn off motherboard/status LED
#ENDIF

            JP   CStrt          ;Cold start system
























