;************************************
;* Demo using the Digital I/O module 
;* and the Digital Output module.
;*
;* Hardware: v2 speaker board
;*           Digital I/O module @ port 0x03
;*           Digital Output module @ port 0x00
;*
;* Connections: J1 Pin 1 = Digital Output Port 0 Pin 0
;*              J1 9 = GND
;*              J1 10 = 5v
;*
;* Adapted from the demo in the
;* KIM-1 manual.
;*
;************************************
OUTPORT: 	EQU 	0X00
INPORT: 	EQU 	0x03			; in port on I/O module
LEDPORT:	EQU		0x03			; out port on I/O module

			ORG 	0x0200

INIT: 		LD	 	B,0				; Set B to initial value of 0
START: 		INC 	B				; Toggle Speaker
			LD	 	A,B			 
			OUT 	(OUTPORT), A		 
			IN 		A, (INPORT)		; Read buttons
			RRC		A
			AND		0x7F
			OUT		(LEDPORT), A	; Echo buttons onto LEDs
DELAY: 		NOP						; At 7 Mhz you need to slow down 
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
			NOP
			NOP
			NOP
			NOP
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