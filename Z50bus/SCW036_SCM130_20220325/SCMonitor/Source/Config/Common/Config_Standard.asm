; **********************************************************************
; **  Config: Standard features                 by Stephen C Cousins  **
; **********************************************************************

; **********************************************************************
; Hardware identifier constants 
;
; These provide the ID for a specific hardware design. They are used in
; the BUILD.ASM file statement:  kConfHardw:  .SET HW_xxxx
; If the configuration is to be used with more than one hardware design, 
; use the value HW_UNKNOWN, unless it defines a hardware specification.
; Any hardware meeting the hardware specification should use the same
; value. In other words, if it is compatible.
;
; Symbol     Value              Description
; ======     =====              ===========
HW_UNKNOWN: .EQU 0              ;0#  <unknown>      Unknown or Custom hardware
HW_SCW:     .EQU 1              ;W1, "SCWorkshop"   SC Workshop / simulated 
HW_SCDEV:   .EQU 2              ;--  "SCDevKit01"   SC Development Kit 01
HW_RC2014:  .EQU 3              ;R#  "RC2014"       RC2014 Generic 
;HW_SC1:    .EQU 4              ;?                  SC101 prototypye only
HW_SBC1:    .EQU 5              ;L1, "LiNC80",      LiNC80 SBC1 with Z50Bus
HW_TomSBC:  .EQU 6              ;T1, "TomsSBC"      Tom Szolyga's Z80 SBC rev C
HW_Z280RC:  .EQU 7              ;Z1, "Z80RC",       Bill Shen's Z280RC
HW_Z80SBC:  .EQU 9              ;Z2, "Z80SBC64",    Bill Shen's Z80SBC RC
HW_ZORAk:   .EQU 10             ;Z8, "ZORAk",       Steve Markowski's ZORAk
HW_Z80PG:   .EQU 11             ;P1, "Z80PG",       John Squires' Z80 Playground
HW_Z50BUS1: .EQU 21             ;F1, "Z50Bus/Z80",  as SC516 & SC118
HW_Z50BUS2: .EQU 22             ;F2, "Z50Bus/Z80",  as SC519+518
HW_Z50BUS3: .EQU 23             ;F3, "Z50Bus/Z180", as SC503 & SC140
HW_RCZ80_2  .EQU 32             ;S2, "RC/Z80",      as SC114
HW_RCZ80_3  .EQU 33             ;S3, "RC/Z80",      as SC108
HW_RCZ180_4 .EQU 34             ;S4, "RC/Z180",     as SC111, legacy mode (Z80 replacement)
HW_RCZ180_5 .EQU 35             ;S5, "RC/Z180",     as SC111+119, native mode
HW_SC101:   .EQU 101            ;S1, SC101 Prototype motherboard
;HW_SC108:  .EQU 108            ;S3, SC108 Z80 processor for RC2014
;HW_SC111:  .EQU 111            ;S4, SC111 Z180 processor for RC2014+
;HW_SC114:  .EQU 114            ;S2, SC114 Z80 SBC / motherboard for RC2014
;HW_SC118:  .EQU 118            ;F1, SC118 Z80 SBC / processor for Z50Bus
HW_SC121:   .EQU 121            ;C1, SC121 Z80 processor for Z50sc
HW_SC126:   .EQU 126            ;S6, "SC126", SC126 Z180 SBC / motherboard ? M1
HW_SC130:   .EQU 130            ;M2, SC130 Z180 SBC / motherboard
HW_SC131:   .EQU 131            ;M3, SC131 Z180 SBC / pocket computer
;HW_SC503:  .EQU 216            ;F3, SC503 Z180 processor for Z50Bus
;HW_SC516:  .EQU 216            ;F1, SC516 Z80 processor for Z50Bus
;HW_SC519:  .EQU 219            ;F2, SC519 Z80 processor for Z50Bus


; **********************************************************************
; Default configuration details

; Configuration identifiers
kConfMajor: .EQU '0'            ;Config: Letter = official, number = user
kConfMinor: .EQU '0'            ;Config: 1 to 9 = official, 0 = user
;#DEFINE    CNAME "Simulated"   ;Configuration name (max 11 characters)

; Hardware ID (use HW_UNKNOWN if not for a very specified product)
kConfHardw: .EQU HW_UNKNOWN     ;Hardware identifier (if known)

; Console devices
kConDef:    .EQU 1              ;Default console device (1 to 6)
kBaud1Def:  .EQU 0x00           ;Console device 1 default baud rate 
kBaud2Def:  .EQU 0x00           ;Console device 2 default baud rate 
kBaud3Def:  .EQU 0x00           ;Console device 3 default baud rate 
kBaud4Def:  .EQU 0x00           ;Console device 4 default baud rate 
kBaud5Def:  .EQU 0x00           ;Console device 5 default baud rate 
kBaud6Def:  .EQU 0x00           ;Console device 6 default baud rate 

; Simple I/O ports (o/p used for selftest/status display)
kPrtIn:     .EQU 0x00           ;General input port
kPrtOut:    .EQU 0x00           ;General output port

; ROM filing system
kROMBanks:  .EQU 1              ;Number of software selectable ROM banks
kROMTop:    .EQU 0x7F           ;Top of banked ROM (hi byte only)

; BIOS specific configuration data
kConfig0:   .EQU 0              ;BIOS specific config data #0
kConfig1:   .EQU 0              ;BIOS specific config data #1
kConfig2:   .EQU 0              ;BIOS specific config data #2
kConfig3:   .EQU 0              ;BIOS specific config data #3
kConfig4:   .EQU 0              ;BIOS specific config data #4
kConfig5:   .EQU 0              ;BIOS specific config data #5
kConfig6:   .EQU 0              ;BIOS specific config data #6
kConfig7:   .EQU 0              ;BIOS specific config data #7
kConfig8:   .EQU 0              ;BIOS specific config data #8
kConfig9:   .EQU 0              ;BIOS specific config data #9
kConfigA:   .EQU 0              ;BIOS specific config data #A
kConfigB:   .EQU 0              ;BIOS specific config data #B


; Processor
;#DEFINE    PROCESSOR Z180      ;Processor type "Z80", "Z180"
kCPUClock:  .EQU 18432000       ;CPU clock speed in Hz
kZ180Base:  .EQU 0xC0           ;Z180 internal register base address


; Memory map (code)
kCode:      .EQU 0x0000         ;Typically 0x0000 or 0xE000

; Memory map (data in RAM)
kData:      .EQU 0xFC00         ;Typically 0xFC00 (to 0xFFFF)


; **********************************************************************
; Optional features (comment out or rename unwanted features)
; Excluding any of these may result in bugs as I don't test every option
; Exporting functions:
#DEFINE     IncludeAPI          ;Application Programming Interface (API)
#DEFINE     IncludeFDOS         ;Very limited CP/M style FDOS support
; Support functions:
#DEFINE     IncludeStrings      ;String support (needs utilities)
#DEFINE     IncludeUtilities    ;Utility functions (needs strings)
; Monitor functions:
#DEFINE     IncludeMonitor      ;Monitor essentials
#IFDEF      IncludeMonitor
#DEFINE     IncludeAssembler    ;Assembler (needs disassembler)
#DEFINE     IncludeBaud         ;Baud rate setting
#DEFINE     IncludeBreakpoint   ;Breakpoint and single stepping (needs disassembler)
#DEFINE     IncludeCommands     ;Command Line Interprester (CLI)
#DEFINE     IncludeDisassemble  ;Disassembler 
#DEFINE     IncludeHelp         ;Extended help text
#DEFINE     IncludeHexLoader    ;Intel hex loader
#DEFINE     IncludeMiniTerm     ;Mini terminal support
;#DEFINE    IncludeTrace        ;Trace execution (incomplete)
#ENDIF
; Extensions:
#DEFINE     IncludeRomFS        ;ROM filing system
;#DEFINE    IncludeScripting    ;Simple scripting (incomplete, needs monitor)
#DEFINE     IncludeSelftest     ;Self test at reset


; **********************************************************************
; **  End of standard configuration details                           **
; **********************************************************************














