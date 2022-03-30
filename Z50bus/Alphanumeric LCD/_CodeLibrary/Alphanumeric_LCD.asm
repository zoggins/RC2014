; **********************************************************************
; **  Alphanumeric LCD support                  by Stephen C Cousins  **
; **********************************************************************
;
; **  Written as a Small Computer Monitor App 
; **  Version 0.1 SCC 2018-05-16
; **  www.scc.me.uk
;
; **********************************************************************
;
; This module provides support for alphanumeric LCD modules using with
; *  HD44780 (or compatible) controller
; *  5 x 7 pixel fonts
; *  Up to 80 characters in total (eg. 4 lines of 20 characters)
; *  Interface via six digital outputs to the display (see below)
;
; LCD module pinout:
;   1  Vss   0v supply
;   2  Vdd   5v supply
;   3  Vo    LCD input voltage (near zero volts via potentiometer)
;   4  RS    High = data, Low = instruction
;   5  R/W   High = Read, Low = Write
;   6  E     Enable signal (active high)
;   7  DB0   Data bit 0
;   8  DB1   Data bit 1
;   9  DB2   Data bit 2
;  10  DB3   Data bit 3
;  11  DB4   Data bit 4
;  12  DB5   Data bit 5
;  13  DB6   Data bit 6
;  14  DB7   Data bit 7
;  15  A     Backlight anode (+)
;  16  K     Backlight cathode (-)
;
; This interfacing method uses 4-bit data mode and uses time delays
; rather than polling the display's ready status. As a result the 
; interface only requires 6 simple output lines:
;   LCD E   = Microcomputer output port bit <kLCDBitE>
;   LCD RS  = Microcomputer output port bit <kLCDBitRS>
;   LCD DB4 = Microcomputer output port bit 4
;   LCD DB5 = Microcomputer output port bit 5
;   LCD DB6 = Microcomputer output port bit 6
;   LCD DB7 = Microcomputer output port bit 7
; Display's R/W is connected to 0v so it is always in write mode
; All 6 connections must be on the same port address <kLCDPrt>
; This method also allows a decent length of cable from micro to LCD
;
; **********************************************************************
;
; To include the code for any given function provided by this module, 
; add the appropriate #REQUIRES <FunctionName> statement at the top of 
; the parent source file.
; For example:  #REQUIRES   uHexPrefix
;
; Also #INCLUDE this file at some point after the #REQUIRES statements
; in the parent source file.
; For example:  #INCLUDE    ..\_CodeLibrary\Utilities.asm
;
; These are the function names provided by this module:
; fLCD_Init                     ;Initialise LCD
; fLCD_Inst                     ;Send instruction to LCD
; fLCD_Data                     ;Send data byte to LCD
; fLCD_Pos                      ;Position cursor
; fLCD_Str                      ;Display string
; fLCD_Def                      ;Define custom character
;
; **********************************************************************
;
; Requires SCMonAPI.asm to also be included in the project
;
#REQUIRES   aDelayInMS


; **********************************************************************
; **  Constants
; **********************************************************************

; Constants that must be defined externally
;kLCDPrt:   .EQU 0x18           ;Port address used for LCD
;kLCDBitRS: .EQU 2              ;Port bit for LCD RS signal
;kLCDBitE:  .EQU 3              ;Port bit for LCD E signal
;kLCDWidth: .EQU 20             ;Width in characters

; Cursor position values for the start of each line
kLCD_Line1: .EQU 0x00 
kLCD_Line2: .EQU 0x40 
kLCD_Line3: .EQU kLCD_Line1+kLCDWidth
kLCD_Line4: .EQU kLCD_Line1+kLCDWidth 

; Instructions to send as A register to fLCD_Inst
kLCD_Clear: .EQU 0b00000001     ;LCD clear
kLCD_Off:   .EQU 0b00001000     ;LCD off
kLCD_On:    .EQU 0b00001100     ;LCD on, no cursor or blink
kLCD_Under: .EQU 0b00001110     ;LCD on, cursor = underscore
kLCD_Blink: .EQU 0b00001101     ;LCD on, cursor = blink block
kLCD_Both:  .EQU 0b00001111     ;LCD on, cursor = under+blink

; Constants used by this code module
;kLCD_Clr:  .EQU 0b00000001     ;LCD command: Clear display
kLCD_Pos:   .EQU 0b10000000     ;LCD command: Position cursor
kLCD_Def:   .EQU 0b01000000     ;LCD command: Define character


; **********************************************************************
; **  Program code
; **********************************************************************

            .CODE               ;Code section


; **********************************************************************
; **  LCD support functions
; **********************************************************************

; Initialise alphanumeric LCD module
; LCD control register codes:
;   DL   0 = 4-bit mode        1 = 8-bit mode
;   N    0 = 1-line mode       1 = 2-line mode
;   F    0 = Font 5 x 8        1 = Font 5 x 11
;   D    0 = Display off       1 = Display on
;   C    0 = Cursor off        1 = Cursor on
;   B    0 = Blinking off      1 = Blinking on
;   ID   0 = Decrement mode    1 = Increment mode
;   SH   0 = Entire shift off  1 = Entire shift on
fLCD_Init:  LD   A, 40
            CALL LCDDelay       ;Delay 40ms after power up
; For reliable reset set 8-bit mode - 3 times
            CALL WrFn8bit       ;Function = 8-bit mode
            CALL WrFn8bit       ;Function = 8-bit mode
            CALL WrFn8bit       ;Function = 8-bit mode
; Set 4-bit mode
            CALL WrFn4bit       ;Function = 4-bit mode
            CALL LCDDelay1      ;Delay 37 us or more
; Function set
            LD   A, 0b00101000  ;Control reg:  0  0  1  DL N  F  x  x
            CALL fLCD_Inst      ;2 line, display on
; Display On/Off control
            LD   A, 0b00001100  ;Control reg:  0  0  0  0  1  D  C  B 
            CALL fLCD_Inst      ;Display on, cursor on, blink off
; Display Clear
            LD   A, 0b00000001  ;Control reg:  0  0  0  0  0  0  0  1
            CALL fLCD_Inst      ;Clear display
; Entry mode
            LD   A, 0b00000110  ;Control reg:  0  0  0  0  0  1  ID SH
            CALL fLCD_Inst      ;Increment mode, shift off
; Display module now initialised
            RET


; Write instruction to LCD
;   On entry: A = Instruction byte to be written
;   On exit:  AF BC DE HL IX IY I AF' BC' DE' HL' preserved
fLCD_Inst:  PUSH AF
            PUSH AF
            CALL @Wr4bits       ;Write bits 4 to 7 of instruction
            POP  AF
            RLA                 ;Rotate bits 0-3 into bits 4-7...
            RLA
            RLA
            RLA
            CALL @Wr4bits       ;Write bits 0 to 3 of instruction
            LD   A, 2
            CALL LCDDelay       ;Delay 2 ms to complete 
            POP  AF
            RET
@Wr4bits:   AND  0xF0           ;Mask so we only have D4 to D7
            OUT  (kLCDPrt), A   ;Output with E=Low and RS=Low
            SET  kLCDBitE, A
            OUT  (kLCDPrt), A   ;Output with E=High and RS=Low
            RES  kLCDBitE, A
            OUT  (kLCDPrt), A   ;Output with E=Low and RS=Low
            RET


; Write data to LCD
;   On entry: A = Data byte to be written
;   On exit:  AF BC DE HL IX IY I AF' BC' DE' HL' preserved
fLCD_Data:  PUSH AF
            PUSH AF
            CALL @Wr4bits       ;Write bits 4 to 7 of data byte
            POP  AF
            RLA                 ;Rotate bits 0-3 into bits 4-7...
            RLA
            RLA
            RLA
            CALL @Wr4bits       ;Write bits 0 to 3 of data byte
            LD   A, 150
@Wait:      DEC  A              ;Wait a while to allow data 
            JR   NZ, @Wait      ;  write to complete
            POP  AF
            RET
@Wr4bits:   AND  0xF0           ;Mask so we only have D4 to D7
            SET  kLCDBitRS, A
            OUT  (kLCDPrt), A   ;Output with E=Low and RS=High
            SET  kLCDBitE, A
            OUT  (kLCDPrt), A   ;Output with E=High and RS=High
            RES  kLCDBitE, A
            OUT  (kLCDPrt), A   ;Output with E=Low and RS=High
            RES  kLCDBitRS, A
            OUT  (kLCDPrt), A   ;Output with E=Low and RS=Low
            RET


; Position cursor to specified location
;   On entry: A = Cursor position
;   On exit:  AF BC DE HL IX IY I AF' BC' DE' HL' preserved
fLCD_Pos:   PUSH AF
            OR   kLCD_Pos       ;Prepare position cursor instruction
            CALL fLCD_Inst      ;Write instruction to LCD
            POP  AF
            RET


; Output text string to LCD
;   On entry: DE = Pointer to null terminated text string
;   On exit:  BC HL IX IY I AF' BC' DE' HL' preserved
fLCD_Str:   LD   A, (DE)        ;Get character from string
            OR   A              ;Null terminator?
            RET  Z              ;Yes, so finished
            CALL fLCD_Data      ;Write character to display
            INC  DE             ;Point to next character
            JR   fLCD_Str       ;Repeat


; Define custom character
;   On entry: A = Character number (0 to 7)
;             DE = Pointer to character bitmap data
;   On exit:  A = Next character number
;             DE = Next location following bitmap
;             BC HL IX IY I AF' BC' DE' HL' preserved
; Character is 
fLCD_Def:   PUSH BC
            PUSH AF
            RLCA                ;Calculate location
            RLCA                ;  for bitmap data
            RLCA                ;  = 8 x CharacterNumber
            OR   kLCD_Def       ;Prepare define character instruction
            CALL fLCD_Inst      ;Write instruction to LCD
            LD   B, 0
@Loop:      LD   A, (DE)        ;Get byte from bitmap
            CALL fLCD_Data      ;Write byte to display
            INC  DE             ;Point to next byte
            INC  B              ;Count bytes
            BIT  3, B           ;Finish all 8 bytes?
            JR   Z, @Loop       ;No, so repeat
            POP  AF
            INC  A              ;Increment character number
            POP  BC
            RET


; **********************************************************************
; **  Private functions
; **********************************************************************

; Write function to LCD
;   On entry: A = Function byte to be written
;   On exit:  AF BC DE HL IX IY I AF' BC' DE' HL' preserved
WrFn4bit:   LD   A, 0b00100000  ;4-bit mode
            JR   WrFunc
WrFn8bit:   LD   A, 0b00110000  ;8-bit mode
WrFunc:     PUSH AF
            OUT  (kLCDPrt), A   ;Output with E=Low and RS=Low
            SET  kLCDBitE, A
            OUT  (kLCDPrt), A   ;Output with E=High and RS=Low
            RES  kLCDBitE, A
            OUT  (kLCDPrt), A   ;Output with E=Low and RS=Low
            LD   A, 5
            CALL LCDDelay       ;Delay 5 ms to complete
            POP  AF
            RET


; Delay in milliseconds
;   On entry: A = Number of milliseconds delay
;   On exit:  AF BC DE HL IX IY I AF' BC' DE' HL' preserved
LCDDelay1:  LD   A, 1           ;Delay by 1 ms
LCDDelay:   PUSH DE
            LD   E, A           ;Delay by 'A' ms
            LD   D, 0
            CALL aDelayInMS
            POP  DE
            RET


; **********************************************************************
; **  Variables
; **********************************************************************

            .DATA

; No variables used

