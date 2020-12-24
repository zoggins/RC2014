************************************
* Demo using the Digital I/O module, 
* Digital Output module and the Digital
* Input module.
*
* Schematic provided in folder
* Switchs must go to 5v and GND, 
* not GND and float.
* 
* Adapted from the demo in the
* KIM-1 manual.
*
************************************
OUTPORT 	EQU 	0X00
INPORT 		EQU 	0x00		; in port on input module
LEDPORT		EQU		0x03		; out port on I/O module

			ORG 	0x0200

INIT 		MVI 	B,0			; Set B to initial value of 0
START 		INR 	B			; Toggle Speaker
			MOV 	A,B			 
			OUT 	OUTPORT
			IN 		INPORT		; Read buttons
			ANI		0x7F
			OUT		LEDPORT		; Echo buttons onto LEDs
DELAY 		NOP					; At 7 Mhz you need to slow down 
			NOP					; the program to actually hit
			NOP					; audible frequencies.
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
			DCR		A			; Delay by an amount specified
			JP		DELAY		; by the count in A
			JM		START		; Go Start
			END