;************************************
;* Demo of I/O on Z80 Membership Card
;*
;* Hardware: v2 speaker board
;*
;* Connections: J1 Pin 1 = Z80MC J2 Pin 1
;*              J1 Pin 2 - 8 = Z80MC J2 Pins 11 - 17
;*              J1 9 = Z80MC J2 Pin 10
;*              J1 10 = Z80MC J2 Pin 20
;*
;* Adapted from the demo in the
;* KIM-1 manual.
;*
;************************************

OUTPORT: 	EQU 	0x40			; out port
INPORT: 	EQU 	0x40			; in port

			ORG 	0x8000

INIT: 		LD	 	B,0				; Set B to initial value of 0
START: 		INC 	B				; Toggle Speaker
			LD	 	A,B
			OUT 	(OUTPORT), A
			IN 		A, (INPORT)		; Read switches
			AND		0x7F
DELAY: 		NOP						; At 4 Mhz you need to slow down 
			NOP						; the program to actually hit
			NOP						; audible frequencies.
			NOP					
			NOP
			NOP
			NOP
			NOP
			NOP
			NOP
			NOP
			DEC		A			; Delay by an amount specified
			JP		P, DELAY	; by the count in A
			JP		M, START	; Go Start