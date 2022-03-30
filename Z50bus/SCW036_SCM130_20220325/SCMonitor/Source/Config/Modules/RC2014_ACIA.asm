; **********************************************************************
; **  Configuration file                        by Stephen C Cousins  **
; **  Module: RC_ACIA (RC2014 68B50 ACIA module)                      **
; **********************************************************************

; This card contains a 68B50 ACIA
; These settings assume the main bus clock is 7.3728 MHz

#IFNDEF     INCLUDE_ACIA_n1
kACIA1:     .EQU 0x80           ;Base address of serial ACIA #1
#DEFINE     INCLUDE_ACIA_n1     ;Include ACIA #1 support in this build
#ENDIF



