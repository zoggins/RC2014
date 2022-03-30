; **********************************************************************
; **  Device Driver                             by Stephen C Cousins  **
; **  Hardware:  Generic                                              **
; **  Interface: Alphanumeric LCD as console output device            **
; **********************************************************************

; This module is the driver for an alphanumeric LCD 
;
; The LCD module is configured as a console device. However, the 
; display is very limited and is output only. To work around these
; limitations the device borrows console device 1 as its input
; channel and also copies its output to console device 1.
;
; In this example the display is connected to a Z80 PIO
; Or a simple 8-bit output port could be used (such as SC129) 
;
; This interfacing method uses 4-bit data mode and uses time delays
; rather than polling the display's ready status. As a result the 
; interface only requires 6 simple output lines:
;   Output bit 0 = not used
;   Output bit 1 = not used
;   Output bit 2 = RS         High = data, Low = instruction
;   Output bit 3 = E          Active high
;   Output bit 4 = DB4
;   Output bit 5 = DB5
;   Output bit 6 = DB6
;   Output bit 7 = DB7
; Display's R/W is connected to 0v so it is always in write mode
;
; For further details see the LCD support code
;
; PIO address 0x68 to 0x6B (using module SC103 Z80 PIO)
;   0x68 = Port A data
;   0x69 = Port B data
;   0x6A = Port A control
;   0x6B = Port B control
;
; To set up PIO port A in mode 3 (control) using LiNC80 as example
;   I/O address 0x1A = 0b11001111 (0xCF)   Select mode 3 (control)
;   I/O address 0x1A = 0b00000000 (0x00)   All pins are output
;

            .CODE

; Interface descriptor
            .DB  0              ;Device ID code (not currently used)
            .DW  @String        ;Pointer to device string
            .DW  L16x2_Init     ;Pointer to initialisation code
            .DB  kL16x2Flags    ;Hardware flags bit mask
            .DW  L16x2_Set      ;Point to device settings code
            .DB  1              ;Number of console devices
            .DW  L16x2_RxA      ;Pointer to 1st channel input code
            .DW  L16x2_TxA      ;Pointer to 1st channel output code
@String:    .DB  "LCD 16x2 "
            .DB  "@ "
            .HEXCHAR kL16x2Base \ 16
            .HEXCHAR kL16x2Base & 15
            .DB  kNull


; PIO constants used by this code module
kDataReg:   .EQU 0x68           ;PIO port A data register
kContReg:   .EQU 0x6A           ;PIO port A control register

; LCD constants used by this code module
kLCDPrt:    .EQU kDataReg       ;LCD port is the PIO port A data reg
kLCDBitRS:  .EQU 2              ;Port bit for LCD RS signal
kLCDBitE:   .EQU 3              ;Port bit for LCD E signal
kLCDWidth:  .EQU 20             ;Width in characters


; Initialise
;   On entry: No parameters required
;   On exit:  Z flagged if device is found and initialised
;             AF BC DE HL not specified
;             IX IY I AF' BC' DE' HL' preserved
; If the device is found it is initialised
L16x2_Init:
; Initalise Z80 PIO port A for control mode with all bits set as outputs
            LD   A, 0b11001111
            OUT  (kContReg), A  ;Port A = PIO 'control' mode
            LD   A, 0b00000000
            OUT  (kContReg),A   ;Port A = all lines are outputs
; Initialise alphanumeric LCD module
            CALL fLCD_Init      ;Initialise LCD module
; Some other things to do
            ;LD   A, kLCD_Clear ;Display clear
            ;LD   A, kLCD_Blink ;Display on with blinking block cursor
            ;LD   A, kLCD_Under ;Display on with underscore cursor
            ;LD   A, kLCD_On    ;Display on with no cursor
            ;LD   A, kLCD_Off   ;Display off
            ;CALL fLCD_Inst     ;Send instruction to display
; Display text on first line
            LD   A, kLCD_Line1
            CALL fLCD_Pos       ;Position cursor to location in A
            LD   DE, @MsgHello
            CALL fLCD_Str       ;Display string pointed to by DE
; Initialisation complete
            XOR  A              ;Flag success
            RET                 ;  and return
;
@MsgHello:  .DB  "Hello World!",0


; Input character
;   On entry: No parameters required
;   On exit:  A = Character input from the device
;             NZ flagged if a character has been found
;             BC DE HL IX IY I AF' BC' DE' HL' preserved
L16x2_RxA:
            JP   kJumpTab+0x30  ;Input from console device 1


; Output character
;   On entry: A = Character to be output to the device
;   On exit:  If character output successful (eg. device was ready)
;               NZ flagged and A != 0
;             If character output failed (eg. device busy)
;               Z flagged and A = Character to output
;             BC DE HL IX IY I AF' BC' DE' HL' preserved
L16x2_TxA:
            PUSH AF
            CP   ' '            ;Control character?
            JR   NC,@Tx         ;No, so go output it
            LD   A, kLCD_Clear  ;Display clear instruction
            CALL fLCD_Inst      ;Send instruction
            JR   @Exit
@Tx:        CALL fLCD_Data      ;Write character to display
@Exit:      POP  AF
            JP   kJumpTab+0x33  ;Output to console device 1


; Device settings
;   On entry: No parameters required
;   On entry: A = Property to set: 1 = Baud rate
;             B = Baud rate code
;             C = Console device number (1 to 6)
;   On exit:  IF successful: (ie. valid device and baud code)
;               A != 0 and NZ flagged
;             BC DE HL not specified
;             IX IY I AF' BC' DE' HL' preserved
L16x2_Set:  XOR  A              ;Return failed to set (Z flagged)
            RET


; **********************************************************************
; **  SCM API shims
; **********************************************************************

; API 0x09: Claim/write jump table entry
;   On entry: A = Entry number (0 to n)
;             DE = Address of function
;   On exit:  No parameters returned
;             AF BC DE HL IX IY I AF' BC' DE' HL' preserved
; Some system functions, such as console in and console out, are 
; redirected through a jump table. By claiming a jump table entry the
; function can be handled by any required code. This might allow
; swapping output to a different device, such as a printer.
aClaimJumpTab:
            PUSH AF
            PUSH BC
            PUSH DE
            PUSH HL
            LD   C,0x09         ;API 0x09
            RST  0x30           ;  = Claim jump table entry
            POP  HL
            POP  DE
            POP  BC
            POP  AF
            RET


; API 0x0A: Delay in milliseconds
;   On entry: A = Number of milliseconds delay
;   On exit:  AF BC DE HL IX IY I AF' BC' DE' HL' preserved
aDelayInMS:
            PUSH AF
            PUSH BC
            PUSH DE
            PUSH HL
            LD   D,0
            LD   E,A
            LD   C, 0x0A        ;API 0x0A
            RST  0x30           ;  = Delay in milliseconds
            POP  HL
            POP  DE
            POP  BC
            POP  AF
            RET


; API 0x0C: Read system jump table entry
;   On entry: A = Entry number (0 to n)
;   On exit:  DE = Address of function
;             AF BC HL IX IY I AF' BC' DE' HL' preserved
; Some system functions, such as console in and console out, are 
; redirected through a jump table. By claiming a jump table entry the
; function can be handled by any required code. This might allow
; swapping output to a different device, such as a printer.
aReadJumpTab:
            PUSH AF
            PUSH BC
            PUSH HL
            LD   C,0x0C         ;API 0x0C
            RST  0x30           ;  = Read jump table entry
            POP  HL
            POP  BC
            POP  AF
            RET


; **********************************************************************
; **  Alphanumeric LCD functions
; **********************************************************************

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


; **********************************************************************
; **  End of driver                                                   **
; **********************************************************************

