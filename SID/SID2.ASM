; RC2014 SID TESTER
; Ported from the code in SID2.BAS

			ORG		$0200

ENTRY:		CALL	CLEAR_SID
			LD		E, 0

			LD		A, 0x00
			LD		(VI), A

			LD		A, 0x18
			LD		D, 0x0F
			LD		E, 0
			CALL	SID_IO		; 430 R = 24 : D = 15 : GOSUB 1000

			LD		H, 0

SETUP:		LD		A, 0x03		; 431 FOR I = 0 TO 2
			ADD		H
			LD		D, 0x08		
			LD		E, 0
			CALL	SID_IO		; 440 R = V(I)+3 : D = 8 : GOSUB 1000
			LD		A, 0x01
			ADD		H
			LD		D, 0x00
			LD		E, 0
			CALL	SID_IO		; 441 R = V(I)+1 : D = 0 : GOSUB 1000
			LD		A, 0x05
			ADD		H
			LD		D, 0x08
			LD		E, 0
			CALL	SID_IO
			LD		A, 0x06		; 450 R = V(I)+5 : D = 8 : GOSUB 1000
			ADD		H
			LD		D, 0xC6
			LD		E, 0
			CALL	SID_IO		; 451 R = V(I)+6 : D = 198 : GOSUB 1000

			LD		A, H
			ADD		0x07
			CP		0x15
			JP		Z, INITAI
			LD		H, A
			JP		SETUP		; 452 NEXT

INITAI:		LD		A, 0x10		; 460 FOR A = 16 TO 128 STEP 16
			LD		(VA), A

			LD		A, 0x00		; 461 FOR I = 0 TO 2
			LD		(VI), A

AILOOP:		LD      A, (VA)		; 470 IF A > 64 THEN R = V(I)+3 : D = 0 : GOSUB 1000
			CP		0x40		
			JP		C, CONT
			JP		Z, CONT

			LD		A, (VI)
			LD		H, A
			LD		A, 0x03
			ADD		H
			LD		D, 0x00
			LD		E, 0
			CALL	SID_IO

CONT:		LD		A, (VI)		
			LD		H, A
			LD		A, (VA)		
			LD		D, A
			INC		D
			LD		A, 0x04
			ADD		H
			LD		E, 0
			CALL	SID_IO		; 480 R = V(I)+4 : D = A+1 : GOSUB 1000

			LD		A, 0x00
			LD		D, A		
FLOOP1:		LD		A, (VI)		; 490 FOR F = 0 TO 254 STEP 2
			LD		H, A
			LD		A, 0x01
			ADD		H
			LD		E, 0
			CALL	SID_IO		;491 R = V(I)+1 : D = F : GOSUB 1000...

			CALL	DELAY

			INC		D
			INC		D
			LD		A, D
			CP		0x00
			JP		NZ, FLOOP1		; ...: NEXT F

			LD		A, (VA)		
			LD		D, A
			LD		A, (VI)		
			LD		H, A
			LD		A, 0x04
			ADD		H
			LD		E, 0
			CALL	SID_IO			; 500 R = V(I)+4 : D = A : GOSUB 1000
		
			LD		A, 0xC8			; 501 FOR W = 0 TO 200...
WLOOP:		DEC		A
			CP		0xFF
			JP		NZ, WLOOP		; ... : NEXT W

			LD		A, 0x08			
			LD		D, A
			LD		A, (VI)		
			LD		H, A
			LD		A, 0x04
			ADD		H
			LD		E, 0
			CALL	SID_IO			; 510 R = V(I)+4 : D = 8 : GOSUB 1000

			LD		A, 0x00		
			LD		D, A
			LD		A, (VI)		
			LD		H, A
			LD		A, 0x01
			ADD		H
			LD		E, 0
			CALL	SID_IO			; 511 R = V(I)+1 : D = 0 : GOSUB 1000

			LD		A, (VI)
			ADD		0x07
			CP		0x15
			JP		Z, EXITILOOP1
			LD		(VI), A
			JP		AILOOP

EXITILOOP1:	LD		A, 0
			LD		(VI), A
			LD		A, (VA)
			ADD		0x10
			CP		0x90
			JP		Z, EXITALOOP
			LD		(VA), A
			JP		AILOOP			; 520 NEXT I,A...

EXITALOOP:	LD		A, 0x01			; ... : A = 1
			LD		(VA), A
INITLOOPI:	LD		A, 0x00
			LD		(VI), A

ILOOP:		LD		D, 0xFF			; 530 FOR I = 0 TO 2
			LD		A, (VI)		
			LD		H, A
			LD		A, 0x01
			ADD		H
			LD		E, 0
			CALL	SID_IO			; 531 R = V(I)+1 : D = 255 : GOSUB 1000

			LD		A, (VA)			
			SLA		A
			SLA		A
			SLA		A
			SLA		A
			ADD		0x0F
			LD		D, A
			LD		A, 0x18
			LD		E, 0
			CALL	SID_IO			; 540 R = 24 : D = (A*16)+15: GOSUB 1000

			LD		A, (VI)
			LD		C, 0x01
PWR:		CP		0x00
			JP		Z, PWRDONE
			SLA		C
			SUB		0x07
			JP		PWR
PWRDONE:	LD		D, C
			LD		A, 0x17
			LD		E, 0
			CALL	SID_IO			; 541 R = 23 : D = 2^I : GOSUB 1000

			LD		D, 0x81
			LD		A, (VI)		
			LD		H, A
			LD		A, 0x04
			ADD		H
			LD		E, 0
			CALL	SID_IO			; 550 R = V(I)+4 : D = 129 : GOSUB 1000

			LD		D, 0x00			; 560 FOR F = 0 TO 255
FLOOP2:		LD		A, (VI)		
			LD		H, A
			LD		A, 0x16
			LD		E, 0
			CALL	SID_IO			; 561 R = 22 : D = F : GOSUB 1000...

			CALL	DELAY

			INC		D
			LD		A, D
			CP		0x00
			JP		NZ, FLOOP2		;  ...: NEXT F

			LD		A, 0x88
			LD		D, A
			LD		A, (VI)		
			LD		H, A
			LD		A, 0x04
			ADD		H
			LD		E, 0
			CALL	SID_IO			; 570 R = V(I)+4 : D = 136: GOSUB 1000...

			LD		A, (VI)
			ADD		0x07
			CP		0x15
			JP		Z, EXITILOOP2
			LD		(VI), A
			JP		ILOOP			;  ...: NEXT I

EXITILOOP2:	LD		A, (VA)
			SLA		A
			CP		0x08
			JP		NC, EXIT		
			LD		(VA), A
			JP		INITLOOPI		; 580 A = A * 2 : IF A < 8 THEN GOTO 530
			
EXIT:		LD		A, 0x0
			LD		D, A
			LD		A, 0x17
			LD		E, 0
			CALL	SID_IO			; 590 R = 23 : D = 0 : GOSUB 1000

			RST		0

VA			DB		0
VI			DB		0

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

DELAY:		LD		B, 0x15
DELAYOUT1:	LD		C, 0xFF
DELAYIN1:	DEC		C
			LD		A, C
			CP		0x00
			JP		NZ, DELAYIN1
			DEC		B
			LD		A, B
			CP		0x00
			JP		NZ, DELAYOUT1
			RET

