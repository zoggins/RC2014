; **********************************************************************
; **  ROM info: Monitor's own info              by Stephen C Cousins  **
; **********************************************************************

            .CODE

            .ORG 0xF0+kROMTop*256
            .DW  0xAA55         ;Identifier
            .DB  "Monitor "     ;File name ("Monitor.EXE")
            .DB  2              ;File type 2 = Executable from ROM
            .DB  0              ;Not used
            .DW  0x0000         ;Start address
            .DW  CodeEnd-CodeBegin  ;Length

; **********************************************************************
; **  End of ROM information module                                   **
; **********************************************************************



