; **********************************************************************
; **  ROM info: SC32k                           by Stephen C Cousins  **
; **********************************************************************

            .CODE

            .ORG 0x3000         ;Inserted files start here

; Executable: BASIC.COM
BasicCode:
#INSERTHEX  ..\Apps\MSBASIC_adapted_by_GSearle\SCMon_BASIC_code3000_data8000.hex
BasicCodeEnd:
BasicCodeW: .EQU BasicCode+3    ;Warm start entry 

; Executable: CPM.COM
#IFNDEF     CFBASE1
#DEFINE     CFBASE1 "0x10"
#ENDIF
#IF         PROCESSOR = "Z80"
CPMCode:
#IF         CFBASE1 = "0x10"
#INSERTHEX  ..\Apps\CPM_load_from_compact_flash\SCMon_CPM_loader_Z80_0x10_code8000.hex
#ENDIF
#IF         CFBASE1 = "0x90"
#INSERTHEX  ..\Apps\CPM_load_from_compact_flash\SCMon_CPM_loader_Z80_0x90_code8000.hex
#ENDIF
#ENDIF
#IF         PROCESSOR = "Z180"
CPMCode:
#IF         CFBASE1 = "0x10"
#INSERTHEX  ..\Apps\CPM_load_from_compact_flash\SCMon_CPM_loader_Z180xC0_0x10_code8000.hex
#ENDIF
#IF         CFBASE1 = "0x90"
#INSERTHEX  ..\Apps\CPM_load_from_compact_flash\SCMon_CPM_loader_Z180xC0_0x90_code8000.hex
#ENDIF
#ENDIF
CPMCodeEnd:

; Help extension: BASIC.HLP
BasicHelp:  .DB  "BASIC    Grant Searle's adaptation of Microsoft BASIC",0x0D,0x0A
            .DB  "WBASIC   Warm start BASIC (retains BASIC program)",0x0D,0x0A
            .DB  0
BasicHelpEnd:

; Help extension: CPM.HLP
CPMHelp:    .DB  "CPM      Load CP/M from Compact Flash (requires prepared CF card)",0x0D,0x0A
;           .DB  "CPM      Load CP/M from Compact Flash",0x0D,0x0A
            .DB  0
CPMHelpEnd:


            .ORG 0x7FA0         ;File references downwards from 0x7FF0 

            .DW  0xAA55         ;Identifier
            .DB  "CPM     "     ;File name ("CPM.HLP")
            .DB  0x03           ;File type 3 = Help
            .DB  0              ;Not used
            .DW  CPMHelp        ;Start address
            .DW  CPMHelpEnd-CPMHelp ;Length

            .DW  0xAA55         ;Identifier
            .DB  "CPM     "     ;File name ("CPM.COM")
            .DB  0x41           ;File type 1 = Monitor command, moved to RAM
            .DB  0x80           ;Run in RAM at 0x8000
            .DW  CPMCode        ;Start address
            .DW  CPMCodeEnd-CPMCode ;Length

            .DW  0xAA55         ;Identifier
            .DB  "BASIC   "     ;File name ("BASIC.HLP")
            .DB  0x03           ;File type 3 = Help
            .DB  0              ;Not used
            .DW  BasicHelp      ;Start address
            .DW  BasicHelpEnd-BasicHelp ;Length

            .DW  0xAA55         ;Identifier
            .DB  "WBASIC  "     ;File name ("WBASIC.COM")
            .DB  0x01           ;File type 1 = Monitor command
            .DB  0              ;Not used
            .DW  BasicCodeW     ;Start address
            .DW  BasicCodeEnd-BasicCodeW  ;Length

            .DW  0xAA55         ;Identifier
            .DB  "BASIC   "     ;File name ("BASIC.COM")
            .DB  0x01           ;File type 1 = Monitor command
            .DB  0              ;Not used
            .DW  BasicCode      ;Start address
            .DW  BasicCodeEnd-BasicCode ;Length

#INCLUDE    Monitor\MonitorInfo.asm
; Include Monitor.EXE information at top of bank 1. eg:
;           .ORG 0x1FF0         ;First ROMFS file in 8k bank
;           .DW  0xAA55         ;Identifier
;           .DB  "Monitor "     ;File name ("Monitor.EXE")
;           .DB  2              ;File type 2 = Executable from ROM
;           .DB  0              ;Not used
;           .DW  0x0000         ;Start address
;           .DW  0x2000         ;Length

; **********************************************************************
; **  End of ROM information module                                   **
; **********************************************************************























