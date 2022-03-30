; Example: Ports.asm
;
; This program continually reads the input port and writes the result to the output port.
;
; Select "Assemble" to assemble the machine code.
; Select menu "View", "Simulated Ports" to see the interactive ports display.
; Select "Walk" to watch this program run.
; Click on the simulated switches to toggle the inputs on and off.
; Watch the simulated LEDs turn on and off to match the switch states.

#TARGET     Simulated_Z80       ; Determines hardware support included

Loop:       IN A,(0)            ; Read input port
            OUT (0),A           ; Write output port
            JP Loop


