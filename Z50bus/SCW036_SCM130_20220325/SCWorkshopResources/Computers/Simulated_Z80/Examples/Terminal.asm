; Example: Terminal.asm
;
; This program continually waits for a key to be pressed on the terminal's
; keyboard and then writes it to the terminal's display.
;
; Select "Assemble" to assemble the machine code.
; Select menu "View", "Simulated Terminal" to see the terminal window.
; Select "Walk" to watch this program run.
; Click on the terminal window and type something. Whatever you type
; will be displayed in the terminal window.

#TARGET     Simulated_Z80       ; Determines hardware support included

Loop:       IN   A,(TermIn)     ; Read from terminal keyboard
            OR   A              ; Key pressed?
            JR   Z,Loop         ; No, so go look again
            OUT  (TermOut),A    ; Write character to terminal screen
            JP   Loop




