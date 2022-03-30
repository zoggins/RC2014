; **********************************************************************
; **  Configuration file                        by Stephen C Cousins  **
; **  Module: SC110 (serial card for RC2014 bus)                      **
; **********************************************************************

; This card contains a Z80 SIO and a Z80 CTC
; CTC channels 0 and 3 have no defined function
; CTC channel 1 provides the data clock for SIO port B
; CTC channel 2 provides a clock tick (by default)
; These settings assume the main bus clock is 7.3728 MHz

; Z80 CTC common (all CTCs share this setting)
#IFNDEF     CTC_CLK_7372800
#DEFINE     CTC_CLK_7372800     ;7372800 | 7372800 | 1843200
#ENDIF

; Z80 CTC #1
#IFNDEF     INCLUDE_CTC_n1
kCTC1:      .SET 0x88           ;Base address of Z80 CTC #1
kDevTick:   .SET kCTC1+2        ;Control register for 200Hz tick
#DEFINE     INCLUDE_CTC_n1      ;Include CTC #1 support in this build
#ENDIF

; Z80 SIO #1
#IFNDEF     INCLUDE_SIO_n1_rc
kSIO1:      .SET 0x80           ;Base address of serial Z80 SIO #1
kSIO1ACTC:  .SET 0              ;Port A's CTC register (0 if n/a)
kSIO1BCTC:  .SET kCTC1+1        ;Port B's CTC register (0 if n/a)
#DEFINE     INCLUDE_SIO_n1_rc   ;Include SIO #1 with RC2014 register order
#ENDIF















