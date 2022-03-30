; **********************************************************************
; **  Build Small Computer Monitor Configuration C1 (SC121 32k ROM)   **
; **********************************************************************

; Include standard configuration stuff
#INCLUDE    Config\Common\Config_Standard.asm

; Build date
#DEFINE     CDATE "20210508"    ;Build date is embedded in the code

; Configuration identifiers
kConfMajor: .SET 'C'            ;Config: Letter = official, number = user
kConfMinor: .SET '1'            ;Config: 1 to 9 = official, 0 = user
#DEFINE     CNAME "SC121"       ;Configuration name (max 11 characters)

; Hardware ID (use HW_UNKNOWN if not for a very specified product)
kConfHardw: .SET HW_SC121       ;Hardware identifier (if known)

; Console devices
; Default to console device 1
; All baud rates are defaults for the hardware to avoid CTC screw ups
kConDef:    .SET 1              ;Default console device (1 to 6)
kBaud1Def:  .SET 0x11           ;Console device 1 default baud rate 
kBaud2Def:  .SET 0x11           ;Console device 2 default baud rate 
kBaud3Def:  .SET 0x11           ;Console device 3 default baud rate 
kBaud4Def:  .SET 0x11           ;Console device 4 default baud rate 

; Simple I/O ports
kPrtIn:     .SET 0x00           ;General input port
kPrtOut:    .SET 0x00           ;General output port

; System options
;#DEFINE    ROM_ONLY            ;No option to assemble to upper memory


; **********************************************************************
; Included BIOS support for optional hardware

; SC118 SBC/Z50Bus Z80 Processor (CPU, RAM, ROM, Clock)
#INCLUDE    Config\Modules\SC121.asm

; Common Z50Bus bus modules
#INCLUDE    Config\Common\Modules_Z50Bus.asm 


; **********************************************************************
; Any required customisations should be here, eg:
; kSIO1:  .SET 0x80             ;Base address of serial Z80 SIO #1


; **********************************************************************
; Build the code

#INCLUDE    System\Begin.asm

#INCLUDE    BIOS\SCZ80\Manager.asm

#INCLUDE    System\End.asm

#INCLUDE    Config\Common\ROM_Info_SC32k.asm




