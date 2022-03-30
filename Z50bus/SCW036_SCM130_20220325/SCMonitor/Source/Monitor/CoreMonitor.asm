; **********************************************************************
; **  Include core monitor modules              by Stephen C Cousins  **
; **********************************************************************

; Monitor version number
kMonMajor:  .EQU 1              ;Bios version: revision
kMonMinor:  .EQU 3              ;Bios version: revision
kMonRevis:  .EQU 0              ;Bios version: revision
;VerMTouch: .EQU 20220227       ;Last date monitor code touched


; Monitor functions
#IFDEF      IncludeMonitor
#INCLUDE    Monitor\Monitor.asm ;Minitor essentials
#INCLUDE    Monitor\UtilitiesM.asm
#IFDEF      IncludeStrings
#INCLUDE    Monitor\Strings.asm ;String support
#INCLUDE    Monitor\StringsM.asm
#ENDIF
#ENDIF
#IFDEF      IncludeDisassemble
#INCLUDE    Monitor\Disassembler.asm  ;In-line disassembler
#ENDIF
#IFDEF      IncludeAssembler
#INCLUDE    Monitor\Assembler.asm ;In-line assembler (needs disassembler)
#ENDIF
#IFDEF      IncludeBreakpoint
#INCLUDE    Monitor\Breakpoint.asm  ;Breakpoint handler
#ENDIF
#IFDEF      IncludeCommands
#INCLUDE    Monitor\Commands.asm  ;Command Line Interprester (CLI)
#ENDIF
;#IFDEF     IncludeDisassemble
;#INCLUDE   Monitor\Disassembler.asm  ;In-line disassembler
;#ENDIF
#IFDEF      IncludeScripting
#INCLUDE    Monitor\Script.asm  ;Simple scripting language
#ENDIF

; Extensions
#IFDEF      IncludeTrace
#INCLUDE    Monitor\Trace.asm   ;Trace execution (needs disassembler)
#ENDIF
;#IFDEF     IncludeRomFS
;#INCLUDE   Monitor\RomFS.asm   ;ROM filing system
;#ENDIF

















