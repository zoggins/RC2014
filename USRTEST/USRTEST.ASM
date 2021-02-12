

			ORG		$0200

SERDEV      EQU     0x80            ; SERIAL DEVICE ADDRESS

DEINT		EQU 	0xE00B			; Read in parameter from BASIC
RETVAL		EQU		0xE00D			; Export Return Value back to BASIC

EXTREG:		CALL	DEINT
			LD		A, D
			AND		0x0F
			LD		B, 0
			CALL	RETVAL
			RET

EXTINT:		CALL	DEINT
			LD		A, D
			AND		0x30
			LD		B, 0
			CALL	RETVAL
			RET

EXTDTA:		CALL	DEINT
			LD		A, E
			LD		B, 0
			CALL	RETVAL
			RET

;*********** COUT - SPECIFIC TO ROMWBW ON RC2014
COUT:
	; SAVE ALL INCOMING REGISTERS
	PUSH	AF
	PUSH	BC
	PUSH	DE
	PUSH	HL
;
	; OUTPUT CHARACTER TO CONSOLE VIA UBIOS
	LD	E, A
	LD	B, 0x01
    LD  C, SERDEV
	RST	08
;
	; RESTORE ALL REGISTERS
	POP	HL
	POP	DE
	POP	BC
	POP	AF
	RET

NumToHex:    ld c, a		; a = number to convert
             call Num1
             call Num1
             ld d, a
             ld a, c
             call Num2
             ld e, a
             ret			; return with hex number in de

Num1:        rra
             rra
             rra
             rra
Num2:        or $F0
             daa
             add a, $A0
             adc a, $40 ; Ascii hex at this point (0 to F)   
             ret