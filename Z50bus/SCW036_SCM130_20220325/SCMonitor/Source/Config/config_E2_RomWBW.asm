; **********************************************************************
; **  Build Small Computer Monitor Configuration E2 (RomWBW)          **
; **********************************************************************

; Include standard configuration stuff
#INCLUDE    Config\Common\Config_Standard.asm

; Build date
#DEFINE     CDATE "20210508"    ;Build date is embedded in the code

; Configuration identifiers
kConfMajor: .SET 'E'            ;Config: Letter = official, number = user
kConfMinor: .SET '2'            ;Config: 1 to 9 = official, 0 = user
#DEFINE     CNAME "RomWBW"      ;Configuration name (max 11 characters)

; Hardware ID (use HW_UNKNOWN if not for a very specified product)
kConfHardw: .SET HW_UNKNOWN     ;Hardware identifier (if known)

; Console devices
kConDef:    .SET 1              ;Default console device (1 to 6)
kBaud1Def:  .SET 0x11           ;Console device 1 default baud rate 
kBaud2Def:  .SET 0x11           ;Console device 2 default baud rate 

; Simple I/O ports
kPrtIn:     .SET 0x00           ;General input port
kPrtOut:    .SET 0x00           ;General output port

; ROM filing system
kROMBanks:  .SET 1              ;Number of software selectable ROM banks
kROMTop:    .SET 0x7F           ;Top of banked ROM (hi byte only)

; Processor
#DEFINE     PROCESSOR Z80       ;Processor type "Z80", "Z180"
kCPUClock:  .SET 4000000        ;CPU clock speed in Hz
;kZ180Base: .SET 0xC0           ;Z180 internal register base address

; OS
#DEFINE     EXTERNALOS          ;Uses external OS for console I/O

; Memory map
kCode:      .SET 0x0100         ;Typically 0x0000 or 0xE000
kData:      .SET 0x8C00         ;Typically 0xFC00 (to 0xFFFF)

; Exclude
#UNDEFINE   IncludeRomFS        ;Do not include RomFS
#UNDEFINE   IncludeBaud         ;Do not include Baud rate setting


; **********************************************************************
; Build the code

#INCLUDE    System\Begin.asm

#INCLUDE    BIOS\RomWBW\Manager.asm

#INCLUDE    System\End.asm

#INCLUDE    Config\Common\ROM_Info_SC32k_NoApps.asm





