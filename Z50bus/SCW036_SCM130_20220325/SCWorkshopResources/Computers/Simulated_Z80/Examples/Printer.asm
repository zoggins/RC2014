; Example: Printer.asm
;
; This program writes a message to the simulated printer.
;
; Select "Assemble" to assemble the machine code.
; Select menu "View", "Simulated Printer" to see the printer window.
; Select "Walk" to watch this program run.

#TARGET     Simulated_Z80       ; Determines hardware support included

; Copy text to memory mapped screen
            LD   HL,text        ; Start of text
loop:       LD   A,(HL)         ; Get character from message text
            OR   A              ; End of message (A=0)?
stop:       JR   Z,stop         ; Yes, so stop here
            OUT  (PrintOut),A   ; No, so send character to printer
            INC  HL             ; Point to next character in text
            JP   loop           ; Stop here

; Text to be copied
text:       .DB "ABCDEFGHIJKLMNOPQRSTUVWXYZ",0x0D,0x0A
            .DB "This is the 2nd line",0x0D,0x0A
            .DB "This is the 3rd line",0x0D,0x0A
            .DB "This is the 4th line",0x0D,0x0A
            .DB "This is the 5th line",0x0D,0x0A
            .DB 0




