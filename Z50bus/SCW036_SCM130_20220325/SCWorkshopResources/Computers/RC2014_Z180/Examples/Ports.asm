; Example: Ports.asm
;
; This program continually reads the input port and writes the result to the output port.

#TARGET     RC2014_Z180          ; Determines hardware support included

Loop:       IN A,(0)            ; Read input port
            OUT (0),A           ; Write output port
            JP Loop

