; **********************************************************************
; **  Port functions                            by Stephen C Cousins  **
; **********************************************************************

; This module provides functions to manipulate I/O ports.
;
; Public functions provided
;   PrtOInit              Initialise output port
;   PrtOWr                Write to output port
;   PrtORd                Read from output port
;   PrtOTst               Test output port bit
;   PrtOSet               Set output port bit
;   PrtOClr               Clear output port bit
;   PrtOInv               Invert output port bit
;   PrtIInit              Initialise input port
;   PrtIRd                Read from input port
;   PrtITst               Test input port bit


; **********************************************************************
; **  Public functions                                                **
; **********************************************************************

            .CODE

; Ports: Initialise output port
;   On entry: A = Output port address
;   On exit:  A = Output port data byte (which will be zero)
;             DE HL IX IY I AF' BC' DE' HL' preserved
PrtOInit:   LD   (iPrtOutA),A   ;Store port address
            XOR  A              ;Clear A (data)
            JR   PrtOWr         ;Write A to output port

; Ports: Read output port data
;   On entry: no parameters required
;   On exit:  A = Output port data
;             BC DE HL IX IY I AF' BC' DE' HL' preserved
PrtORd:     LD   A,(iPrtOutD)   ;Read output port
            RET

; Ports: Test output port bit
;   On entry: A = Bit number 0 to 7
;   On exit:  A = 0 and Z flagged if bit low
;             A !=0 and NZ flagged if bit high
;             DE IX IY I AF' BC' DE' HL' preserved
PrtOTst:    CALL PortMask       ;Get bit mask for bit A
            AND  B              ;Test against bit masked in B
            RET                 ;Flag NZ if bit set

; Ports: Set output port bit
;   On entry: A = Bit number 0 to 7
;   On exit:  A = Output port data
;             DE IX IY I AF' BC' DE' HL' preserved
PrtOSet:    CALL PortMask       ;Get bit mask for bit A
            OR   B              ;Set bit masked in B
            JR   PrtOWr         ;Write to port

; Ports: Clear output port bit
;   On entry: A = Bit number 0 to 7
;   On exit:  A = Output port data
;             DE IX IY I AF' BC' DE' HL' preserved
PrtOClr:    CALL PortMask       ;Get bit mask for bit A
            LD   C,A            ;Remember output port data
            LD   A,B            ;Get bit mask
            CPL                 ;Complement mask (invert bits)
            AND  C              ;Invert bit masked in A
            JR   PrtOWr         ;Write to port

; Ports: Invert output port bit
;   On entry: A = Bit number 0 to 7
;   On exit:  A = Output port data
;             DE IX IY I AF' BC' DE' HL' preserved
PrtOInv:    CALL PortMask       ;Get bit mask for bit A
            XOR  B              ;Invert bit masked in B
            ;JR   PrtOWr        ;Write to port

; Ports: Write to output port 
;   On entry: A = Output data byte
;   On exit:  A = Output port data
;             BC = 16-bit I/O address
;             DE HL IX IY I AF' BC' DE' HL' preserved
PrtOWr:     LD   B,A            ;Remember port data
            LD   A,(iPrtOutA)   ;Get port address 
            LD   C,A            ;Remember port address
            LD   A,B            ;Get port data
            LD   (iPrtOutD),A   ;Store port data
            LD   B,0            ;Support 16-bit I/O addressing
            OUT  (C),A          ;Write to port
            RET


; Ports: Initialise input port
;   On entry: A = Input port address
;   On exit:  A = Input port data
;             DE HL IX IY I AF' BC' DE' HL' preserved
PrtIInit:   LD   (iPrtInA),A    ;Store port address
            XOR  A              ;Clear A (data)
            ;JR   PrtIRd        ;Write A to output port

; Ports: Read input port data
;   On entry: no parameters required
;   On exit:  A = Input port data
;             BC = 16-bit I/O address
;             BC DE HL IX IY I AF' BC' DE' HL' preserved
PrtIRd:     LD   A,(iPrtInA)    ;Get input port address 
            LD   C,A            ;Remember port address
            LD   B,0            ;Support 16-bit I/O addressing
            IN   A,(C)          ;Read input port data
            RET

; Ports: Test input port bit
;   On entry: A = Bit number 0 to 7
;   On exit:  A = 0 and Z flagged if bit low
;             A !=0 and NZ flagged if bit high
;             DE IX IY I AF' BC' DE' HL' preserved
PrtITst:    CALL PortMask       ;Get bit mask for bit A
            PUSH BC
            CALL PrtIRd         ;Read input port
            POP  BC
            AND  B              ;Test against bit masked in B
            RET                 ;Flag NZ if bit set


; **********************************************************************
; **  Private functions                                               **
; **********************************************************************

; Get bit mask for bit A
;   On entry: A = Output port address
;   On exit:  B = Bit mask
;             A = Current output port value
;             DE IX IY I AF' BC' DE' HL' preserved
PortMask:   LD   HL,@MaskTab    ;Start of bit mask table
            LD   C,A            ;Get bit number
            LD   B,0            ;Clear B
            ADD  HL,BC          ;Calculate location of bit mask in table
            LD   B,(HL)         ;Get bit mask
            LD   A,(iPrtOutD)   ;Get output data
            RET
; Bit mask table: bit 0 mask, bit 1 mask, ...
@MaskTab:   .DB  1,2,4,8,16,32,64,128


; **********************************************************************
; **  Private workspace (in RAM)                                      **
; **********************************************************************

            .DATA

iPrtInA:    .DB  0              ;Input port address
iPrtOutA:   .DB  0              ;Output port address
iPrtOutD:   .DB  0              ;Output port data


; **********************************************************************
; **  End of Port functions module                                    **
; **********************************************************************



