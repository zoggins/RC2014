; **********************************************************************
; **  Included BIOS support for generic Z50Bus system                 **
; **********************************************************************

; **********************************************************************
; Z80 CTC (counter timer channels) #1 and #2
; CTC channel 0 provides the data clock for SIO port A
; CTC channel 1 provides the data clock for SIO port B
; CTC channel 2 provides a clock tick (CTC #1 is system tick)
; CTC channel 3 have no defined function
; Warning: The CTC must share the same clock as the CPU, or the CTC
;          clock must be less than half the CPU clock rate
; These settings assume the CTC clock source is 1.8432 MHz

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

; Z80 CTC #2
#IFNDEF     INCLUDE_CTC_n2
kCTC2:      .SET 0x8C           ;Base address of Z80 CTC #2
;kDevTick:  .SET kCTC2+2        ;Control register for 200Hz tick
#DEFINE     INCLUDE_CTC_n2      ;Include CTC #2 support in this build
#ENDIF

; **********************************************************************
; Z80 SIO (serial input/output) #1 and #2
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

; Z80 SIO #2 with standard register order
#IFNDEF     INCLUDE_SIO_n2_std
kSIO2:      .SET 0x84           ;Base address of serial Z80 SIO #2
kSIO2ACTC:  .SET kCTC2+0        ;Port A's CTC register (0 if n/a)
kSIO2BCTC:  .SET kCTC2+1        ;Port B's CTC register (0 if n/a)
#DEFINE     INCLUDE_SIO_n2_std  ;Include SIO #2 with Standard register order
#ENDIF

; **********************************************************************
; Serial ACIA (68B50) #1 and #2
; These settings assume the main bus clock is 7.3728 MHz

#IFNDEF     INCLUDE_ACIA_n1
kACIA1:     .EQU 0xA2           ;Base address of serial ACIA #1
#DEFINE     INCLUDE_ACIA_n1     ;Include ACIA #1 support in this build
#ENDIF

#IFNDEF     INCLUDE_ACIA_n2
kACIA2:     .EQU 0xA4           ;Base address of serial ACIA #2
#DEFINE     INCLUDE_ACIA_n2     ;Include ACIA #2 support in this build
#ENDIF

; **********************************************************************
; Compact flash card interface

#DEFINE     CFBASE1 0x90        ;Base address for CF card #1

#IFNDEF     INCLUDE_CFCard
kCFCard:    .EQU 0x90           ;Base address of comact flash card
#DEFINE     INCLUDE_CFCard      ;Include CF Card support in this build
#ENDIF

; **********************************************************************
; Digital input/output port

#IFNDEF     INCLUDE_DigIO
kDigIO:     .EQU 0xA0           ;Base address of digital IO port
#DEFINE     INCLUDE_DigIO       ;Include digital I/O in this build
#ENDIF

; **********************************************************************
; Diagnostic LEDs 

#IFNDEF     INCLUDE_DiagLEDs
#IFNDEF     DiagLEDs_DETECTED
#DEFINE     DiagLEDs_DETECTED TESTABLE  ;ALWAYS | NEVER | TESTABLE
#ENDIF
kDiagLEDs:  .EQU 0xA0           ;Base address of diagnostic LEDs
#DEFINE     INCLUDE_DiagLEDs    ;Include diagnostic LEDs in this build
#ENDIF


