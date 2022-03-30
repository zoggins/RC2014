; **********************************************************************
; **  Configuration file                        by Stephen C Cousins  **
; **  Module: SC108 (Z80 processor for RC2014)                        **
; **********************************************************************

; This card contains a Z80 CPU, ROM, RAM, Clock, Reset

; Processor
#DEFINE     PROCESSOR Z80       ;Processor type "Z80", "Z180"
kCPUClock:  .SET 7432800        ;CPU clock speed in Hz

; ROM filing system
kROMBanks:  .SET 1              ;Number of software selectable ROM banks
kROMTop:    .SET 0x7F           ;Top of banked ROM (hi byte only)

; Banked RAM
#IFNDEF     INCLUDE_BankedRAM_SC2
kBankPrt:   .SET 0x38           ;Bit 7 high selects secondary RAM bank 
#DEFINE     INCLUDE_BankedRAM_SC2
#ENDIF

; Banked ROM
#IFNDEF     INCLUDE_BankedROM_SC1
#DEFINE     INCLUDE_BankedROM_SC1
#ENDIF

