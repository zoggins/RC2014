; **********************************************************************
; **  Build Small Computer Monitor Configuration SCWorkshop           **
; **********************************************************************

; Include standard configuration stuff
#INCLUDE    Config\Common\Config_Standard.asm

; SCWorkshop setup
#TARGET     Simulated_Z80       ;Determines hardware support included
#DEFINE     PROCESSOR Z80       ;Processor type "Z80", "Z180"
kCPUClock:  .SET 4000000        ;CPU clock speed in Hz

; Build date
#DEFINE     CDATE "20220227"    ;Build date is embedded in the code

; Configuration identifiers
kConfMajor: .SET 'W'            ;Config: Letter = official, number = user
kConfMinor: .SET '1'            ;Config: 1 to 9 = official, 0 = user
#DEFINE     CNAME "SCWorkshop"  ;Configuration name (max 11 characters)

; Hardware ID (use HW_UNKNOWN if not for a very specified product)
kConfHardw: .SET HW_SCW         ;Hardware identifier (if known)

; Simple I/O ports (o/p used for selftest/status display)
kPrtIn:     .SET 0x00           ;General input port
kPrtOut:    .SET 0x00           ;General output port

; System options
;#DEFINE    ROM_ONLY            ;No option to assemble to upper memory
#DEFINE     BREAKPOINT 28       ;Breakpoint restart (08|10|18|20|28|30)

;kData:     .SET 0x2C00         ;Typically 0xFC00 (to 0xFFFF)

; Handle special requirements when building as CP/M style .COM file
#IFDEF      BUILD_AS_COM_FILE
kCode:      .SET 0x0100         ;Code starts at 0x0100 (not 0x0000)
#ENDIF

; **********************************************************************
; Build the code

#INCLUDE    System\Begin.asm

#INCLUDE    BIOS\SCWorkshop\Manager.asm

#INCLUDE    System\End.asm

#INCLUDE    Config\Common\ROM_Info_SC32k.asm






















