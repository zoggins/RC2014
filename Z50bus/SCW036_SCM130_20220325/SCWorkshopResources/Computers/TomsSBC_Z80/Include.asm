            .COMP TomsSBC_Z80   ; Select computer
            .PROC Z80           ; Select processor
            .ORG  0x8000        ; Assemble code here
PortOut:    .EQU  0xFF          ; Output port
PortIn:     .EQU  0xFF          ; Input port
IntMode1:   .EQU  0x38          ; Interrupt routine address
