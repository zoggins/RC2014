            .COMP Simulated_Z80 ; Select computer
            .PROC Z80           ; Select processor
            .ORG  0             ; Assemble code here
PortOut:    .EQU  0x00          ; Output port
PortIn:     .EQU  0x00          ; Input port
TermOut:    .EQU  0x01          ; Terminal output port
TermIn:     .EQU  0x02          ; Terminal input port
PrintOut:   .EQU  0x03          ; Printer output port
ScrnStrt:   .EQU  0x4000        ; Screen: Start address
ScrnLen:    .EQU  0x800         ; Screen: Length
IntMode1:   .EQU  0x38          ; Interrupt routine address
