; **********************************************************************
; **  Configuration file                        by Stephen C Cousins  **
; **  Module: LCD 16x2 via Z80 PIO                                    **
; **********************************************************************

; This card contains a Z80 PIO connected to a 16x2 alphanumeric LCD

#IFNDEF     INCLUDE_LCD16x2
kLCD16x2:   .EQU 0x68           ;Base address of Z80 PIO
#DEFINE     INCLUDE_LCD16x2     ;Include LCD support in this build
#ENDIF



