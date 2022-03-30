; **********************************************************************
; **  Configuration file                        by Stephen C Cousins  **
; **  Module: SC520 #2 (serial 68B50 ACIA for Z50Bus)                 **
; **********************************************************************

; This card contains a 68B50 ACIA and a 7.3728 MHz data clock

#IFNDEF     INCLUDE_ACIA_n2
kACIA2:     .EQU 0xA4           ;Base address of serial ACIA #2
#DEFINE     INCLUDE_ACIA_n2     ;Include ACIA #2 support in this build
#ENDIF

