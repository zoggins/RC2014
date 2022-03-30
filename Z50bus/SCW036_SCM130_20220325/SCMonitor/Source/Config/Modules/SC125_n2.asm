; **********************************************************************
; **  Configuration file                        by Stephen C Cousins  **
; **  Module: SC125 #2 (serial card for Z50Bus)                       **
; **********************************************************************

; This card contains a Z80 SIO and a Z80 CTC
; CTC channel 0 provides the data clock for SIO port A
; CTC channel 1 provides the data clock for SIO port B
; The card includes a 1.8432 MHz oscillator for the CTC and SIO

; Z80 CTC common (all CTCs share this setting)
#IFNDEF     CTC_CLK_1843200
#DEFINE     CTC_CLK_1843200     ;7372800 | 1843200
#ENDIF

; Z80 CTC #2
#IFNDEF     INCLUDE_CTC_n2
kCTC2:      .SET 0x8C           ;Base address of Z80 CTC #2
kDevTick:   .SET kCTC2+2        ;Control register for 200Hz tick
#DEFINE     INCLUDE_CTC_n2      ;Include CTC #2 support in this build
#ENDIF

; Z80 SIO #2
#IFNDEF     INCLUDE_SIO_n2_std
kSIO2:      .SET 0x84           ;Base address of serial Z80 SIO #2
kSIO2ACTC:  .SET kCTC2+0        ;Port A's CTC register (0 if n/a)
kSIO2BCTC:  .SET kCTC2+1        ;Port B's CTC register (0 if n/a)
#DEFINE     INCLUDE_SIO_n2_std  ;Include SIO #2 with Standard register order
#ENDIF






