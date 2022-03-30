; **********************************************************************
; **  Configuration file                        by Stephen C Cousins  **
; **  Module: SC131 (Z180 SBC)                                        **
; **********************************************************************

; This card contains a Z180 CPU, ROM, RAM, Clock, Reset, Serial port

; Processor
#DEFINE     PROCESSOR Z180      ;Processor type "Z80", "Z180"
kCPUClock:  .SET 18432000       ;CPU clock speed in Hz
kZ180Base:  .SET 0xC0           ;Z180 internal register base address

; ROM filing system
kROMBanks:  .SET 1              ;Number of software selectable ROM banks

; Z180 ASCI
#IFNDEF     INCLUDE_ASCI_n1
kASCI1:     .SET kZ180Base+0x00 ;Base address of Z180 serial ports (CNTLA0)
#DEFINE     INCLUDE_ASCI_n1     ;Include ASCI #1 
#ENDIF

; Status LED
#IFNDEF     INCLUDE_StatusLED
kPrtLED:    .SET 0x0E           ;Single status LED port (active low)
#DEFINE     INCLUDE_StatusLED
#ENDIF

