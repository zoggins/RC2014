; **********************************************************************
; **  Configuration file                        by Stephen C Cousins  **
; **  Module: SC521 #1 (serial card for Z50Bus)                       **
; **********************************************************************

; This card contains a Z80 SIO and hardware baud rate generator

; Z80 CTC common (all CTCs share this setting)
#IFNDEF     CTC_CLK_OSC1843200
#DEFINE     CTC_CLK_OSC1843200  ;CPU7372800 | OSC7372800 | OSC1843200
#ENDIF

; Z80 SIO #1
#IFNDEF     INCLUDE_SIO_n1_std
kSIO1:      .SET 0x80           ;Base address of serial Z80 SIO #1
kSIO1ACTC:  .SET 0              ;Port A's CTC register (0 if n/a)
kSIO1BCTC:  .SET 0              ;Port B's CTC register (0 if n/a)
#DEFINE     INCLUDE_SIO_n1_std  ;Include SIO #1 with Standard register order
#ENDIF






