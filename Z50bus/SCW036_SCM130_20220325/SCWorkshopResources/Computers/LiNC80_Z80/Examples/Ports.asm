; Example: Ports.asm
;
; This program continually reads the input port and writes the result to the output port.

#TARGET     LiNC80_Z80          ; Determines hardware support included

Loop:       IN A,(0x30)         ; Read input port
            OUT (0x30),A        ; Write output port
            JP Loop

