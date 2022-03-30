; Example: Count.asm
;
; This program counts from 1 to 10. Or does it count from zero???
;
; Select "Assemble" to assemble the machine code.
; Select menu "View", "Simulated Processor" to see the processor status.
; Select "Walk" to watch this program run.

#TARGET     Simulated_Z80       ; Determines hardware support included

            LD   A,0            ; Start with A = 0
loop:       INC  A              ; Increment A (ie. add one)
            CP   A,10           ; Is A = 10 ?
            JR   NZ,loop        ; No, so go increment again
stop:       JP   stop           ; Yes, so stop here


