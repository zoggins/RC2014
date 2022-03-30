; Example: Interrupt.asm
;
; This program waits in a tight loop until an interrupt occurs then it
; runs the interrupt service routine before returning to the loop.
; The interrupt service copies the input port value to the output port.
;
; Select "Assemble" to assemble the machine code.
; Select menu "View", "Simulated Ports" to see the interactive ports display.
; Select "Walk" to watch this program run.
; Click on the simulated switches to toggle the inputs on and off.
; Note that the LEDs don't update until you select "Interrupt".
;
; Try opening the "View", "Simulation Trace" display to record all the
; steps and the state of interrupt enable and interrupt request.

#TARGET     Simulated_Z80       ; Determines hardware support included

Loop:       NOP                 ; At this point interrupts are disabled
            NOP                 ; Any interrupt request will be
            NOP                 ;   held until interrupts are enabled
            NOP
            NOP
            EI                  ; Enable interrupts
            NOP                 ; At this point interrupts are enabled
            DI                  ; Disable interrupts
            JP Loop


; Mode 1 interrupt service routine starts at address 0x0038
            .ORG 0x0038
            PUSH AF             ; Preserve AF
            IN A,(0)            ; Read input port
            OUT (0),A           ; Write output port
            POP AF              ; Restore AF
            RETI                ; Return from interrupt

