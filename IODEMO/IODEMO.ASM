************************************
* Demo using the Digital I/O module 
* and the Digital Output module.
*
* Schematic provided in folder
* Ignore the switches, just
* build the amplifier/speaker
* circuit.
* 
* Adapted from the demo in the
* KIM-1 manual.
*
************************************
OUTPORT 	EQU 	0X00
INPORT 		EQU 	0x03
LEDPORT		EQU		0x03

			ORG 	0x0200

INIT 		MVI 	B,0			; Set B to initial value of 0
START 		INR 	B			; Toggle Speaker
			MOV 	A,B			 
			OUT 	OUTPORT		 
			IN 		INPORT		; Read buttons
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