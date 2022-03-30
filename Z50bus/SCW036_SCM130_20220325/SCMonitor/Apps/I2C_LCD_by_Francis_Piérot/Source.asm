; **********************************************************************
; **  I2C LCD demo  by Francis Pierot                                 **
; **  Original code by Stephen S. Cousins                             **
; **********************************************************************

; This program demonstrates the use of SC126's I2C port with a 
; 4x20 LCD display equiped with an I2C adapter.
;


            .PROC Z180          ;SC126 has a Z180
            .HEXBYTES 0x18      ; Intel format output size

            .DATA
            .ORG 0x8300         ; adjust this depending on code size
            
            .CODE
            .ORG 0x8000         ; make sure we don't interfere with ROM

; Constants needed by the I2C support module
I2C_PORT:   .EQU 0x0C           ;Host I2C port address
I2C_SDA_WR: .EQU 7              ;Host I2C write SDA bit number
I2C_SCL_WR: .EQU 0              ;Host I2C write SCL bit number
I2C_SDA_RD: .EQU 7              ;Host I2C read SDA bit number

I2C_ADDR:   .EQU 0x27 << 1      ;I2C device default address (8574T with A0=A1=A2=1), bit 0 = 0 for R/W

; LCD constants required by LCD support module
kLCDBitRS:  .EQU 0              ;data bit for LCD RS signal
kLCDBitRW:  .EQU 1              ;data bit for LCD R/W signal
kLCDBitE:   .EQU 2              ;data bit for LCD E signal
kLCDBitBL:  .EQU 3              ;data bit for backlighting
kLCDWidth:  .EQU 20             ;Width in characters

; SCMonAPI functions used
#REQUIRES   aDelayInMS          ; A = delay in ms, all registers preserved


            ; close I2C by sending stop
            LD   A,0b11000000   ;SCL and SDA high ->  STOP
            LD   (LCD_BLIGHT),A ;put a non null value in backlighting flag
            CALL I2C_WrPort     ;SCL high and SDA high
            
; Initialise alphanumeric LCD module
            CALL fLCD_Init      ;Initialise LCD module

; Display text on first line
            LD   A, kLCD_Line1
            CALL fLCD_Pos       ;Position cursor to location in A
            CALL fLCD_Print
            .DB "Hello, world!",0

; Display text on second line
            LD   A, kLCD_Line2
            CALL fLCD_Pos       ;Position cursor to location in A
            CALL fLCD_Print
            .DB "I'm an SCZ180/126",0

; Define custom character(s)
            LD   A, 0           ;First character to define (0 to 7)
            LD   DE, BitMaps    ;Pointer to start of bitmap data
            LD   B, 2           ;Number of characters to define
@DefLoop:   CALL fLCD_Def       ;Define custom character
            DJNZ @DefLoop       ;Repeat for each character

; Display custom character 0
            LD   A, kLCD_Line1+19
            CALL fLCD_Pos       ;Position cursor to location in A
            LD   A, 0
            CALL fLCD_Data      ;Write character in A at cursor

; Display custom character 1
            LD   A, kLCD_Line2+19
            CALL fLCD_Pos       ;Position cursor to location in A
            LD   A, 1
            CALL fLCD_Data      ;Write character in A at cursor

; Some other things to do
            ;LD   A, kLCD_Clear ;Display clear
            ;LD   A, kLCD_Blink ;Display on with blinking block cursor
            ;LD   A, kLCD_Under ;Display on with underscore cursor
            LD   A, kLCD_On     ;Display on with no cursor
            ;LD   A, kLCD_Off   ;Display off
            CALL fLCD_Inst      ;Send instruction to display
            
;Move a character on line 3 and 4
LoopRight:
            LD   B, 20          ;count
@NextRight: LD   A, kLCD_Line3
            ADD  20
            SUB  B
            LD   C, '>'
            CALL @DispChar
            DJNZ @NextRight

            LD   B, 20
@NextLeft:  LD   A, kLCD_Line4
            ADD  A,B
            SUB  1
            LD   C, '<'
            CALL @DispChar
            DJNZ @NextLeft

; FINISHED!
            RET
            
; display character from C at position from A            
@DispChar:  PUSH AF
            CALL fLCD_Pos       ;set cursor position
            LD   A, C
            CALL fLCD_Data      ;display character
            LD   A,200
            CALL aDelayInMS     ;and wait so it is displayed long enough
            POP  AF
            CALL fLCD_Pos       ;reset cursor position
            LD   A,' '
            CALL fLCD_Data      ;erase character
            RET

; Custom characters 5 pixels wide by 8 pixels high
; Up to 8 custom characters can be defined
BitMaps:    
; Character 0x00 = Battery icon
            .DB  0b01110
            .DB  0b11011
            .DB  0b10001
            .DB  0b10001
            .DB  0b11111
            .DB  0b11111
            .DB  0b11111
            .DB  0b11111
; Character 0x01 = Bluetooth icon
            .DB  0b00110
            .DB  0b10101
            .DB  0b01110
            .DB  0b00100
            .DB  0b01110
            .DB  0b10101
            .DB  0b00110
            .DB  0b00000



; **********************************************************************
; Small computer monitor API

; Delay by DE milliseconds (approx)
;   On entry: DE = Delay time in milliseconds
;   On exit:  IX IY preserved
API_Delay:  LD   C,0x0A
            RST  0x30
            RET

; **********************************************************************
; **  Includes
; **********************************************************************
#INCLUDE    I2C.asm
#INCLUDE    SCMonitor_API.asm
#INCLUDE    Alphanumeric_LCD_I2C.asm



            .END





















