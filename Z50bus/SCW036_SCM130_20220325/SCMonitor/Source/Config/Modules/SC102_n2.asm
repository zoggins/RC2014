; **********************************************************************
; **  Configuration file                        by Stephen C Cousins  **
; **  Module: SC102 #2 (Z80 CTC for RC2014)                           **
; **********************************************************************

; This card contains a Z80 CTC and optional clock oscillator
; CTC channels 0 and 3 have no defined function
; CTC channel 1 provides the data clock for SIO port B
; CTC channel 2 provides a clock tick (by default)
; These settings assume the main bus clock is 7.3728 MHz

; Z80 CTC common (all CTCs share this setting)
#IFNDEF     CTC_CLK_7372800
#DEFINE     CTC_CLK_7372800     ;7372800 |1843200
#ENDIF

; Z80 CTC #2
#IFNDEF     INCLUDE_CTC_n2
kCTC2:      .SET 0x8C           ;Base address of Z80 CTC #2
kDevTick:   .SET kCTC1+2        ;Control register for 200Hz tick
#DEFINE     INCLUDE_CTC_n2      ;Include CTC #2 support in this build
#ENDIF



