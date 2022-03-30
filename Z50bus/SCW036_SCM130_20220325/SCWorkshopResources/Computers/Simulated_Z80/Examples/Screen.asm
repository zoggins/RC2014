; Example: Screen.asm
;
; This program writes a message to the simulated memory mapped screen.
;
; Select "Assemble" to assemble the machine code.
; Select menu "View", "Simulated Screen" to see the screen window.
; Select "Walk" to watch this program run.

#TARGET     Simulated_Z80       ; Determines hardware support included

; Copy text to memory mapped screen
            LD HL,text          ; Start of text
            LD DE,ScrnStrt      ; Start of screen memory
            LD BC,50            ; Number of bytes to copy
            LDIR                ; Copy text
loop:       JP loop             ; Stop here

; Text to be copied
text:       .DB "ABCDEFGHIJKLMNOPQRSTUVWXYZ",0





