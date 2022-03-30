; **********************************************************************
; **  Configuration file                        by Stephen C Cousins  **
; **  Module: SC125 #1 (serial card for Z50Bus)                       **
; **********************************************************************

; This card contains a Z80 SIO and a Z80 CTC
; CTC channel 0 provides the data clock for SIO port A
; CTC channel 1 provides the data clock for SIO port B
; The card includes a 1.8432 MHz oscillator for the CTC and SIO

; Z80 CTC common (all CTCs share this setting)
#IFNDEF     CTC_CLK_1843200
#DEFINE     CTC_CLK_1843200     ;7372800 | 1843200
#ENDIF

; Z80 CTC #1
#IFNDEF     INCLUDE_CTC_n1
kCTC1:      .SET 0x88           ;Base address of Z80 CTC #1
kDevTick:   .SET kCTC1+2        ;Control register for 200Hz tick
#DEFINE     INCLUDE_CTC_n1      ;Include CTC #1 support in this build
#ENDIF

; Z80 SIO #1
#IFNDEF     INCLUDE_SIO_n1_std
kSIO1:      .SET 0x80           ;Base address of serial Z80 SIO #1
kSIO1ACTC:  .SET kCTC1+0        ;Port A's CTC register (0 if n/a)
kSIO1BCTC:  .SET kCTC1+1        ;Port B's CTC register (0 if n/a)
#DEFINE     INCLUDE_SIO_n1_std  ;Include SIO #1 with Standard register order
#ENDIF






