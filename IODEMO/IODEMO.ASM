*********************************
* Demo using the I/O module 
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
*********************************
OUTPORT 	EQU 	0X00
INPORT 		EQU 	0x03
LEDPORT		EQU		0x03

			ORG 	0x0200
INIT 		MVI 	B,0
START 		INR 	B
			MOV 	A,B
			OUT 	OUTPORT
			IN 		INPORT
			OUT		LEDPORT
DELAY 		DCR A
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
			NOP
			NOP
			NOP
			JP DELAY
			JM START