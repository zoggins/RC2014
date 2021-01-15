;************************************
;* Demo using the Z80 PIO module
;* and Digital I/O module.
;*
;* Schematic provided in folder
;* 
;* J1 Pin 1 == PIO Pin PA0
;* J1 Pins 2-8 == PIO Pin PA1-PA7
;* 
;* Adapted from the demo in the
;* KIM-1 manual.
;*
;************************************
PIODPORT: 	EQU 	0x68			; PIO port A data register
PIOCPORT: 	EQU 	0x6A			; PIO port A control register
LEDPORT:	EQU		0x03			; out port on digital I/O module
BTNPORT:	EQU		0x03			; in port on digital I/O module

			ORG 	0x0200

INIT: 		LD	 	B,0				; Set B to initial value of 0
			LD		A, 11001111B	; Set PIO to control mode
			OUT		(PIOCPORT), A
			LD		A, 11111110B	; PA7-PA1 input, PA0 output
			OUT		(PIOCPORT), A
START: 		INC 	B				; Toggle Speaker
			LD	 	A,B
			OUT 	(PIODPORT), A
			IN 		A, (PIODPORT)		; Read switches
			RRC		A
			AND		0x7F
			LD		C,A				; Save switches
			IN		A, (BTNPORT)	; Read buttons
			RRC		A
			AND		0x7F
			OR		C				; OR buttons and switches
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