; **********************************************************************
; **  Common start                              by Stephen C Cousins  **
; **********************************************************************

; Set default processor
#IFNDEF     PROCESSOR
#DEFINE     PROCESSOR Z80
#ENDIF

; Configure assembler to generate Z80 code from Zilog mnemonics
#IF         PROCESSOR = "Z80"
            .PROC Z80           ;Select processor for SCWorkshop
#ENDIF

; Configure assembler to generate Z180 code from Zilog mnemonics
#IF         PROCESSOR = "Z180"
            .PROC Z180          ;Select processor for SCWorkshop
#ENDIF

;#INCLUDE   Config\Config_Standard.asm

            .ORG  kCode         ;Establish start of code
CodeBegin:

#INCLUDE    System\Common.asm

#INCLUDE    System\CoreSystem.asm

#IFDEF      IncludeMonitor
#INCLUDE    Monitor\CoreMonitor.asm
#ENDIF

#INCLUDE    BIOS\BIOS_Constants.asm 

#INCLUDE    Config\Common\Config_Common.asm

            .CODE               ;Ensure following is in code section

; BIOS begins here...

















