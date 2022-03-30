; **********************************************************************
; **  Configuration file                        by Stephen C Cousins  **
; **  Module: RC_SIO (RC2014 Z80 SIO/2 module)                        **
; **********************************************************************

; This card contains a Z80 SIO/2
; Baud rates are normally set in hardware from bus clocks (CLK and CLK2)
; These settings assume the main bus clock is 7.3728 MHz

; Z80 SIO #1 with RC2014 register order
#IFNDEF     INCLUDE_SIO_n1_rc
kSIO1:      .SET 0x80           ;Base address of serial Z80 SIO #1
kSIO1ACTC:  .SET kCTC1+0        ;Port A's CTC register (0 if n/a)  SHOULD BE 0
kSIO1BCTC:  .SET kCTC1+1        ;Port B's CTC register (0 if n/a)  SHOULD BE 0
#DEFINE     INCLUDE_SIO_n1_rc   ;Include SIO #1 with RC2014 register order
#ENDIF

; kSIO1ACTC:  .SET kCTC1+0
; This allows baud rate to be set for port A
; However, this module does not support baud rate for port A
; But we leave this here so it does not disable port A baud for other modules


