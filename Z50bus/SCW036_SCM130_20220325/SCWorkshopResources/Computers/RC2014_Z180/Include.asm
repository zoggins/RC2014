            .COMP RC2014_Z180   ; Select computer
            .PROC Z180          ; Select processor
            .ORG  0x8000        ; Assemble code here
PortOut:    .EQU  0x00          ; Output port
PortIn:     .EQU  0x00          ; Input port
IntMode1:   .EQU  0x38          ; Interrupt routine address
