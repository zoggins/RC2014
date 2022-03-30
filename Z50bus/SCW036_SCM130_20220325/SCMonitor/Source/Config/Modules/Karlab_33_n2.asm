; **********************************************************************
; **  Configuration file                        by Stephen C Cousins  **
; **  Module: Karlab_33 #2 (Serial 68B50 module)                      **
; **********************************************************************

; This card contains a 68B50 ACIA
; These settings assume the main bus clock is 7.3728 MHz
; Address options 80-87, 90-97, A0-A7, B0-B7, C0-C7, D0-D7, E0-E7, F0-F7

#IFNDEF     INCLUDE_ACIA_n2
kACIA2:     .EQU 0xA0           ;Base address of serial ACIA #2
#DEFINE     INCLUDE_ACIA_n2     ;Include ACIA #2 support in this build
#ENDIF

