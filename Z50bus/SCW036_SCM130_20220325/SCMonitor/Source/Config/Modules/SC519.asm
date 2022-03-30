; **********************************************************************
; **  Configuration file                        by Stephen C Cousins  **
; **  Module: SC519 (Z80 memory 128k+128k for Z50Bus)                 **
; **********************************************************************

; This card contains a Z80 memory (128 Flash + 128k RAM

; ROM filing system
kROMBanks:  .SET 1              ;Number of software selectable ROM banks
kROMTop:    .SET 0x7F           ;Top of banked ROM (hi byte only)

; Status LED
#IFNDEF     INCLUDE_StatusLED
kPrtLED:    .SET 0x08           ;Single status LED port (active low)
#DEFINE     INCLUDE_StatusLED
#ENDIF

; Banked RAM
#IFNDEF     INCLUDE_BankedRAM_SC1
kBankPrt:   .SET 0x30           ;Bit 0 high selects secondary RAM bank 
#DEFINE     INCLUDE_BankedRAM_SC1
#ENDIF

; Banked ROM
#IFNDEF     INCLUDE_BankedROM_SC1
#DEFINE     INCLUDE_BankedROM_SC1
#ENDIF

; Bit bang 9600 baud serial port (type SC1)
;#IFNDEF    INCLUDE_BitBangSerial_SC1
;kRtsPrt:   .SET 0x20           ;/RTS output is bit zero
;kTxPrt:    .SET 0x28           ;Transmit output is bit zero
;kRxPrt:    .SET 0x28           ;Receive input is bit 7
;#DEFINE    INCLUDE_BitBangSerial_SC1
;#ENDIF






