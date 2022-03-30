; **********************************************************************
; **  Configuration file                        by Stephen C Cousins  **
; **  Module: SC520 #1 (serial 68B50 ACIA for Z50Bus)                 **
; **********************************************************************

; This card contains a 68B50 ACIA and a 7.3728 MHz data clock

#IFNDEF     INCLUDE_ACIA_n1
kACIA1:     .EQU 0xA2           ;Base address of serial ACIA #1
#DEFINE     INCLUDE_ACIA_n1     ;Include ACIA #1 support in this build
#ENDIF

