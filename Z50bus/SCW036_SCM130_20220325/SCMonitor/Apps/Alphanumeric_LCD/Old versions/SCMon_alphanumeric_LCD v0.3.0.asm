; **********************************************************************
; **  Alphanumeric LCD example                  by Stephen C Cousins  **
; **********************************************************************
;
; **  Written as a Small Computer Monitor App 
; **  Version 0.3 SCC 2018-06-28
; **  www.scc.me.uk
;
; **********************************************************************
;
; This program is an example of one of the methods of interfacing an 
; alphanumeric LCD module. 
;
; In this example the display is connected to the Z80 PIO parallel
; port A. This is port A of a Z80 PIO, although a simple 8-bit latch
; style output port is all that is actually needed.
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
; LiNC80 PIO address 0x18 to 0x1B (included on LiNC80 SBC1)
;   0x18 = Port A data
;   0x19 = Port B data
;   0x1A = Port A control
;   0x1B = Port B control
;
; RC2014 PIO address 0x68 to 0x6B (using module SC103 Z80 PIO)
;   0x68 = Port A data
;   0x69 = Port B data
;   0x6A = Port A control
;   0x6B = Port B control
;
; Z280RC PIO address 0x68 to 0x6B (using module SC103 Z80 PIO)
;   0x68 = Port A data
;   0x69 = Port B data
;   0x6A = Port A control
;   0x6B = Port B control
;
; To set up PIO port A in mode 3 (control) using LiNC80 as example
;   I/O address 0x1A = 0b11001111 (0xCF)   Select mode 3 (control)
;   I/O address 0x1A = 0b00000000 (0x00)   All pins are output
;
; To write a data byte to the output port using LiNC80 as example
;   I/O address 0x18 = <data byte>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
;

; **********************************************************************

; Select target system
#DEFINE    LINC80
;#DEFINE    RC2014
;#DEFINE    Z280RC

            .PROC Z80           ;SCWorkshop select processor
            .HEXBYTES 0x18      ;SCWorkshop Intel Hex output format


; **********************************************************************
; **  Memory map
; **********************************************************************

CodeORG:    .EQU $8000          ;Loader code runs here
DataORG:    .EQU $8F00          ;Start of data section


; **********************************************************************
; **  Constants
; **********************************************************************

; Constants used by this code module
#IFDEF      LINC80
kDataReg:   .EQU 0x18           ;PIO port A data register
kContReg:   .EQU 0x1A           ;PIO port A control register
#ENDIF
#IFDEF      RC2014
kDataReg:   .EQU 0x68           ;PIO port A data register
kContReg:   .EQU 0x6A           ;PIO port A control register
#ENDIF
#IFDEF      Z280RC
kDataReg:   .EQU 0x68           ;PIO port A data register
kContReg:   .EQU 0x6A           ;PIO port A control register
#ENDIF


; LCD constants required by LCD support module
kLCDPrt:    .EQU kDataReg       ;LCD port is the PIO port A data reg
kLCDBitRS:  .EQU 2              ;Port bit for LCD RS signal
kLCDBitE:   .EQU 3              ;Port bit for LCD E signal
kLCDWidth:  .EQU 20             ;Width in characters

; **********************************************************************
; **  Code library usage
; **********************************************************************

; SCMonAPI functions used
#REQUIRES   aDelayInMS

; Alphanumeric LCD functions used
; no need to specify specific functions for this module


; **********************************************************************
; **  Establish memory sections
; **********************************************************************

            .DATA
            .ORG  DataORG       ;Establish start of data section

            .CODE
            .ORG  CodeORG       ;Establish start of code section


; **********************************************************************
; **  Main program code
; **********************************************************************

; Z280RC requires I/O page selection to access external I/O
; Based on code by Bill Shen
#IFDEF      Z280RC
            ld c,08h            ;Reg c points to I/O page register
            ld l,0h             ;Set I/O page register to 0x00
            db 0edh,6eh         ;This is the op code for LDCTL (C),HL
#ENDIF

; Initalise PIO port A for control mode with all bits set as outputs
            LD   A, 0b11001111
            OUT  (kContReg), A  ;Port A = PIO 'control' mode
            LD   A, 0b00000000
            OUT  (kContReg),A   ;Port A = all lines are outputs

; Initialise alphanumeric LCD module
            CALL fLCD_Init      ;Initialise LCD module

; Display text on first line
            LD   A, kLCD_Line1
            CALL fLCD_Pos       ;Position cursor to location in A
            LD   DE, MsgHello
            CALL fLCD_Str       ;Display string pointed to by DE

; Display text on second line
            LD   A, kLCD_Line2
            CALL fLCD_Pos       ;Position cursor to location in A
            LD   DE, MsgLiNC80
            CALL fLCD_Str       ;Display string pointed to by DE

; Define custom character(s)
            LD   A, 0           ;First character to define (0 to 7)
            LD   DE, BitMaps    ;Pointer to start of bitmap data
            LD   B, 2           ;Number of characters to define
@DefLoop:   CALL fLCD_Def       ;Define custom character
            DJNZ @DefLoop       ;Repeat for each character

; Display custom character 0
            LD   A, kLCD_Line1+14
            CALL fLCD_Pos       ;Position cursor to location in A
            LD   A, 0
            CALL fLCD_Data      ;Write character in A at cursor

; Display custom character 1
            ;LD   A, kLCD_Line2+14
            ;CALL fLCD_Pos      ;Position cursor to location in A
            ;LD   A, 1
            ;CALL fLCD_Data     ;Write character in A at cursor

; Some other things to do
            ;LD   A, kLCD_Clear ;Display clear
            ;LD   A, kLCD_Blink ;Display on with blinking block cursor
            ;LD   A, kLCD_Under ;Display on with underscore cursor
            LD   A, kLCD_On     ;Display on with no cursor
            ;LD   A, kLCD_Off   ;Display off
            CALL fLCD_Inst      ;Send instruction to display

; Z280RC requires I/O page selection to be restored 
; Code by Bill Shen
#IFDEF      Z280RC
            ld c,08h            ;hcs reg c points to I/O page register
            ld l,0feh           ;hcs set I/O page register to 0xFE
            db 0edh,6eh         ;hcs this is the op code for LDCTL (C),HL
#ENDIF

            RET


; Test strings
MsgHello:   .DB  "Hello World!",0
#IFDEF      LINC80
MsgLiNC80:  .DB  "I'm a LiNC80",0
#ENDIF
#IFDEF      RC2014
MsgLiNC80:  .DB  "I'm an RC2014",0
#ENDIF
#IFDEF      Z280RC
MsgLiNC80:  .DB  "I'm a Z280RC",0
#ENDIF

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
            .DB  0b01100
            .DB  0b01010
            .DB  0b11100
            .DB  0b01000
            .DB  0b11100
            .DB  0b01010
            .DB  0b01100
            .DB  0b00000


; **********************************************************************
; **  Includes
; **********************************************************************

#INCLUDE    ..\_CodeLibrary\SCMonitor_API.asm
;#INCLUDE   ..\_CodeLibrary\Utilities.asm
#INCLUDE    ..\_CodeLibrary\Alphanumeric_LCD.asm


; **********************************************************************
; **  Variables
; **********************************************************************

            .DATA

; No variables used

            .END






