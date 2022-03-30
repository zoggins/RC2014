; **********************************************************************
; **  ROM info: External OS                     by Stephen C Cousins  **
; **********************************************************************

            .CODE


#DEFINE     Monitor/IncludeMonitorInfo
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


