; RC2014 SID TESTER
; Ported from the code in SID1.BAS

            ORG		$0200

	        CALL	CLEAR_SID
			LD		E, 0

			CALL	SEED

			LD		A, 0x00			; VOICES 1, 2 & 3 == 0x00, 0x07, 0x0E
			LD		(VOICE), A

SETUP:		LD		D, 0x0F		
			LD		A, 0x18
			LD		E, 0
			CALL	SID_IO			; 450 R = 24 : D = 15 : GOSUB 1000	

			LD		A, (VOICE)
			LD		H, A
			LD		D, 0x61		
			LD		A, 0x05
			ADD		H
			LD		E, 0
			CALL	SID_IO			; 451 R = 5 + V : D = 97 : GOSUB 1000

			LD		A, (VOICE)
			LD		H, A
			LD		D, 0xC8		
			LD		A, 0x06
			ADD		H
			LD		E, 0
			CALL	SID_IO			;452 R = 6 + V : D = 200 : GOSUB 1000

			CALL	RND
			LD		A, L
			AND		0x03
OPTION1:	CP		0x00
			JP		NZ, OPTION2		
			LD		D, 0x21
			JP		NEXT
OPTION2:	CP		0x01
			JP		NZ, OPTION3
			LD		D, 0x41
			JP		NEXT
OPTION3:	CP		0x02
			JP		NZ, OPTION4
			LD		D, 0x81
			JP		NEXT
OPTION4:	LD		D, 0x11
NEXT:		LD		A, (VOICE)
			LD		H, A
			LD		A, 0x04
			ADD		H
			LD		E, 0
			CALL	SID_IO			; 453 R = 4 + V : D = W : GOSUB 1000

			LD		A, 0x0			; 460 FOR X = 0 TO 255 STEP INT((RND(1)*15)+1)
			LD		(VX), A

			CALL	RND
			LD		A, L
			AND     0xF0
			SRL		A
			SRL		A
			SRL		A
			SRL		A
			INC		A
			LD		(STEP), A

XLOOP:		LD		A, (VOICE)
			LD		H, A
			LD		A, (VX)
			LD		D, A		
			LD		A, 0x00
			ADD		H
			LD		E, 0
			CALL	SID_IO			; 470 R = 0 + V : D = X : GOSUB 1000

			LD		A, (VOICE)
			LD		H, A
			LD		A, (VX)
			LD		D, A
			LD		A, 0xFF
			SUB		D
			LD		D, A
			LD		A, 0x01
			ADD		H
			LD		E, 0
			CALL	SID_IO			; 471 R = 1 + V : D = 255 - X : GOSUB 1000

			LD		B, 0x60
			CALL	DELAY

			LD		A, 0			; 480 FOR Y = 0 TO 33...
YLOOP:		INC		A
			CP		0x21
			JP		Z, YLOOPXIT
			JP		YLOOP

YLOOPXIT:	LD		A, (STEP)
			LD		B, A
			LD		A, (VX)
			ADD		B
			JP		C, XLOOPXIT
			LD		(VX), A
			JP		XLOOP			;  ...: NEXT Y, X

			LD		A, 0			; 490 FOR X = 0 TO 200: NEXT...
XLOOPXIT:	INC		A
			CP		0xC8
			JP		Z, VOLOFF
			JP		XLOOPXIT

VOLOFF:		LD		D, 0x00	
			LD		A, 0x18
			LD		E, 0
			CALL	SID_IO			; ... : R = 24 : D = 0 :  GOSUB 1000

			LD		A, 0			; 500 FOR X = 0 TO 100: NEXT : GOTO 410
LSTLPXIT:	PUSH	AF
			LD		B, 0x01
			CALL	DELAY
			POP		AF
			INC		A
			CP		0x64			
			JP		Z, SETUP
			JP		LSTLPXIT

VX			DB		0
VOICE		DB		0
STEP		DB		0

TBUF		DB		0, 0, 0, 0, 0, 0

; ENTER WITH:	A = SID REGISTER (0x00 - 0x18)
;				D = DATA BYTE
;				E = INTERRUPT CONTROLLER MODE - BITS 5/6
; (0x00 = OFF,  0x20 = '50Hz',  0x40 = '60Hz'  0x60 = '100Hz')
SID_IO:		LD		C, 0x54		; BASE I/O ADDRESS
			OR		E
			LD		B, A
			OUT		(C), D		; WRITE TO SID.  /CS=0 (B BIT 7)
			NOP
			NOP					; DELAY
			NOP
			SET		7, B		; /CS=1 (B BIT 7)
			OUT		(C), D		; WRITE TO SID
			RET

CLEAR_SID:	LD		C, 0x54		; BASE I/O ADDRESS
			LD		B, 0x98		; SID REGISTER 0x18, /CS =1 (BIT 7)
								; INTERRUPT CONTROLLER OFF
			XOR		A			; OPTIMIZED "LD A, 0" (VOLUME 0)
			OUT		(C), A		; FIRSTY OUT TO ENSURE /CS HIGH
			NOP
			NOP					; DELAY
			NOP
			RES		7, B		; /CS=0 (B BIT 7)
			OUT		(C), A		; WRITE TO SID
			NOP
			NOP					; DELAY
			NOP
			SET		7, B		; /CS=1 (B BIT 7)
			OUT		(C), A		; WRITE TO SID
			RET		

DELAY:		
DELAYOUT:	LD		C, 0xFF
DELAYIN:	DEC		C
			LD		A, C
			CP		0x00
			JP		NZ, DELAYIN
			DEC		B
			LD		A, B
			CP		0x00
			JP		NZ, DELAYOUT
			RET

; 8-bit Xor-Shift random number generator.
; Created by Patrik Rak in 2008 and revised in 2011/2012.
; See http://www.worldofspectrum.org/forums/showthread.php?t=23070
RND:		LD		HL,0XA280   ; YW -> ZT
			LD		DE,0XC0DE   ; XZ -> YW
			LD		(RND+4),HL  ; X = Y, Z = W
			LD		A,L         ; W = W ^ ( W << 3 )
			ADD		A,A
			ADD		A,A
			ADD		A,A
			XOR		L
			LD		L,A
			LD		A,D         ; T = X ^ (X << 1)
			ADD		A,A
			XOR		D
			LD		H,A
			RRA					; T = T ^ (T >> 1) ^ W
			XOR		H
			XOR		L
			LD		H,E         ; Y = Z
			LD		L,A         ; W = T
			LD		(RND+1),HL
			RET 

; THIS ISN'T THE GREATEST SEED GENERATOR, BUT IT WORKS
SEED:
	; SAVE ALL INCOMING REGISTERS
	PUSH	AF
	PUSH	BC
	PUSH	DE
	PUSH	HL

	; GETRTC
	LD	B, 0x20
    LD  HL, TBUF
	RST	08

	; MIX IT ALL INTO THE SEED BYTES
	LD	A, (TBUF+5)
	LD	(RND+1), A
	LD	A, (TBUF+2)
	LD	(RND+2), A
	LD	A, (TBUF+4)
	LD	(RND+4), A
	LD	A, (TBUF+3)
	LD	(RND+5), A

	; RESTORE ALL REGISTERS
	POP	HL
	POP	DE
	POP	BC
	POP	AF
	RET
