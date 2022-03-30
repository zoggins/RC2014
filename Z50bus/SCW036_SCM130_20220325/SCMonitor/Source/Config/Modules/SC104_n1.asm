; **********************************************************************
; **  Configuration file                        by Stephen C Cousins  **
; **  Module: SC104 #1 (Z80 SIO/2 for RC2014 bus)                     **
; **********************************************************************

; This card contains a Z80 SIO/2
; The register order can be with standard Zilog order or RC2014 order
; If a CTC is available it is assumed that:
; CTC channel 0 generates the data clock for SIO port A
; CTC channel 1 generates the data clock for SIO port B
; These settings assume the SIO serial clock is 7.3728 MHz, or it is
; controlled by a CTC

; Z80 SIO #1 with standard register order
#IFNDEF     INCLUDE_SIO_n1_std
kSIO1:      .SET 0x80           ;Base address of serial Z80 SIO #1
kSIO1ACTC:  .SET kCTC1+0        ;Port A's CTC register (0 if n/a)
kSIO1BCTC:  .SET kCTC1+1        ;Port B's CTC register (0 if n/a)
#DEFINE     INCLUDE_SIO_n1_std  ;Include SIO #1 with Standard register order
#ENDIF

; Z80 SIO #1 with RC2014 register order
#IFNDEF     INCLUDE_SIO_n1_rc
kSIO1:      .SET 0x80           ;Base address of serial Z80 SIO #1
kSIO1ACTC:  .SET kCTC1+0        ;Port A's CTC register (0 if n/a)
kSIO1BCTC:  .SET kCTC1+1        ;Port B's CTC register (0 if n/a)
#DEFINE     INCLUDE_SIO_n1_rc   ;Include SIO #1 with RC2014 register order
#ENDIF








