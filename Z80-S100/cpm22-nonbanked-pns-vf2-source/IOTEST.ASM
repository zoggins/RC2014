
                        
                        
    .XLINK
    .Z80            ;Z80 OPCODES USED
    .PHEX
    .PABS
    .LOC    100H    ;THIS LOADER BEGINS HERE

	WCON	==	2	;OUTPUT CONSOL
	BDOS	==	5


                        
    MVI             A,0
    STA             ZERO
    MVI             B,0FFH
                        
LOOP:
    IN              0EFH
    ANI             0FFH
    JRZ             Z1
    JMPR            IL
Z1:
    LDA         ZERO
    INR             A
    STA        ZERO
IL:
    DCR             B
    JNZ             LOOP

	LDA		ZERO
	CALL LBYTE

    RET
                     
LBYTE:	PUSH	PSW
	RRC
	RRC
	RRC
	RRC
	CALL	P2
	POP	PSW
P2:	ANI	0FH
	ADI	90H
	DAA
	ACI	40H
	DAA
	MOV	C,A
	JMP	COUT

COUT:
	PUSH	B
	MOV	E,A
	MVI	C,WCON
	CALL	BDOS
	POP	B
	RET
                     
ZERO:   .BLKB   1
                        
.END
