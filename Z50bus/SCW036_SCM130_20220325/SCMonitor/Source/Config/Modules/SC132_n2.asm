; **********************************************************************
; **  Configuration file                        by Stephen C Cousins  **
; **  Module: SC132 #2 (Z80 SIO/0 for RC2014 bus)                     **
; **********************************************************************

; This card contains a Z80 SIO/0
; The register order is RC2014 compatible.
; Channel A is assumed to be clocked at 7.3728 MHz.
; Channel B is assumed to be clocked from CTC channel 1 (if a CTC is 
; present) otherwise it is 7,3728 MHz.

; Z80 SIO #2 with RC2014 register order
#IFNDEF     INCLUDE_SIO_n2_rc
kSIO1:      .SET 0x84           ;Base address of serial Z80 SIO #2
kSIO1ACTC:  .SET 0              ;Port A's CTC register (0 if n/a)
kSIO1BCTC:  .SET kCTC2+1        ;Port B's CTC register (0 if n/a)
#DEFINE     INCLUDE_SIO_n2_rc   ;Include SIO #2 with RC2014 register order
#ENDIF





