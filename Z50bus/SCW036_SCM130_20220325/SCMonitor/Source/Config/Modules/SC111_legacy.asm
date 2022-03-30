; **********************************************************************
; **  Configuration file                        by Stephen C Cousins  **
; **  Module: SC111 legacy mode (Z180 module for RC2014 bus)          **
; **********************************************************************

; This card contains a Z180 CPU, ROM, RAM, Clock, Reset, Serial port

; Legacy mode (or Z80 replacement mode) only uses the Z180 as a fast
; Z80. The Z180' serial ports are not used.
; Some modules may require the clock speed to be 7.3728 MHz.

; Processor
#DEFINE     PROCESSOR Z180      ;Processor type "Z80", "Z180"
kCPUClock:  .SET 18432000       ;CPU clock speed in Hz
kZ180Base:  .SET 0xC0           ;Z180 internal register base address

; ROM filing system
kROMBanks:  .SET 1              ;Number of software selectable ROM banks

; Z180 ASCI
;#IFNDEF    INCLUDE_ASCI_n1
;kASCI1:    .SET kZ180Base+0x00 ;Base address of Z180 serial ports (CNTLA0)
;#DEFINE    INCLUDE_ASCI_n1     ;Include ASCI #1 
;#ENDIF


