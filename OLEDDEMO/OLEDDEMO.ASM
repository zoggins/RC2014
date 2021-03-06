;************************************
;* Demo of Quazar's OLED Board
;* 
;* Prints "Zoggins" to the screen
;* and uses the buttons/leds on the 
;* Digital I/O board to do different 
;* things
;************************************

OLEDPORT:	EQU		0x50		; OLED address
INPORT:		EQU		0x03		; Digital I/O board's input address
OUTPORT:	EQU		0x03		; Digital I/O board's output address

			ORG		0x0200

INIT:		CALL	RESET
			LD		HL, SEQUENCE
INITLOOP:	LD		A, (HL)
			CP		0xFF
			JR		Z, CLEAR
			CALL	COMMAND
			INC		HL
			JP		INITLOOP
CLEAR:		CALL	CLEAROLED
			CALL	SETWINDOW	; DRAW SOMETHING
			
TERMLOOP:	IN		A, (INPORT)
			OUT		(OUTPORT), A
			CP		0x01		; Button 1
			JR		Z, INVERT	; Inverts Display
			CP		0x02		; Button 2
			JR		Z, NORMAL	; Un-inverts the Display
			CP		0x04		; Button 3
			JR		Z, DR3		; Draw dragon
			CP		0x08		; Button 4
			JR		Z, DR2		; Draw "here"
			CP		0x10		; Button 5
			JR		Z, DR1		; Draw "was"
			CP		0x20		; Button 6
			JR		Z, DR		; Draw "ZOGGINS"
			CP		0x40		; Button 7
			JR		Z, DIM		; Dims the Display
			CP		0x80		; Button 8
			JR		Z, FULL		; Un-Dims the Display
			JR		TERMLOOP
INVERT:		CALL	INVERTEDDIS
			JR		TERMLOOP	
NORMAL:		CALL	NORMALDIS
			JR		TERMLOOP
FULL:		CALL	FULLDISPLAY
			JR		TERMLOOP
DIM:		CALL	DIMDISPLAY
			JR		TERMLOOP
DR:			CALL	DRAWIMAGE
			JR		TERMLOOP
DR1:		CALL	DRAWIMAGE1
			JR		TERMLOOP
DR2:		CALL	DRAWIMAGE2
			JR		TERMLOOP
DR3:		CALL	DRAWIMAGE3
			JR		TERMLOOP
			RET

; SETS THE WINDOW FOR THE ENTIRE SCREEN
; AND DISPLAYS THE DATA IN IMAGE
SETWINDOW:	LD		A, 0x20
			CALL	COMMAND		; WINDOW COMMAND
			LD		A, 0x00
			CALL	COMMAND		; HORIZONTAL WRAPPING

			LD		A, 0x21
			CALL	COMMAND		; WINDOW COLUMNS
			LD		A, 0x04
			CALL	COMMAND		; LEFT MOST COLUMN
			LD		A, 0x83
			CALL	COMMAND		; RIGHT MOST COLUMN

			LD		A, 0x22
			CALL	COMMAND		; WINDOW ROWS
			LD		A, 0x00
			CALL	COMMAND		; TOP ROW
			LD		A, 0x03
			CALL	COMMAND		; BOTTOM ROW

			LD		A, 0xB0
			CALL	COMMAND		; SET POINTER TO START AT TOP ROW
			LD		A, 0x10
			CALL	COMMAND		; SET START AT LEFT MOST COLUMN
			LD		A, 0x04
			CALL	COMMAND		; BOTTOM ROW
DRAWIMAGE:	LD		HL, IMAGE	; IMAGE DATA
			LD		D, 0x00
			JR		WINLOOP
DRAWIMAGE1:	LD		HL, IMAGE1	; IMAGE1 DATA
			LD		D, 0x00
			JR		WINLOOP
DRAWIMAGE2:	LD		HL, IMAGE2	; IMAGE2 DATA
			LD		D, 0x00
			JR		WINLOOP
DRAWIMAGE3:	LD		HL, IMAGE3	; IMAGE3 DATA
			LD		D, 0x00
			JR		WINLOOP
WINLOOP:	LD		A, (HL)
			CALL	OLEDDATA
			INC		HL
			LD		A, (HL)
			CALL	OLEDDATA
			INC		HL
			DEC		D			; LOOP TO DRAW 512 BYTES
			JR		NZ, WINLOOP
			RET

; THIS WAS A DEMO TO SHOW PIXEL PLACEMENT
PIXELROW:	LD		A, 0xB0
			CALL	COMMAND
			LD		A, 0x10
			CALL	COMMAND
			LD		A, 0x04
			CALL	COMMAND
			XOR		A
ROWLOOP:	CALL	OLEDDATA
			INC		A
			CP		0x80
			RET		Z
			JR		ROWLOOP

; STARTUP SEQUENCE COMMANDS
SEQUENCE:	DB		0xAE, 0xD5, 0xA0, 0xA8
			DB		0x1F, 0xD3, 0x00, 0xAD
			DB		0x8E, 0xD8, 0x05, 0xA1
			DB		0xC8, 0xDA, 0x12, 0x91
			DB		0x3F, 0x3F, 0x3F, 0x3F
			DB		0x81, 0x80, 0xD9, 0xD2
			DB		0xDB, 0x34, 0xA6, 0xA4
			DB		0xAF
			DB		0xFF	

; IMAGE = ZOGGINS
IMAGE:      DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0xC0, 0xC0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x03, 0x03, 0x03, 0x03, 0xC3
			DB 0xE3, 0x3B, 0x1F, 0x07, 0x00, 0x00, 0xE0, 0xF0
			DB 0x38, 0x1C, 0x0C, 0x0C, 0x0C, 0x1C, 0x38, 0xF0
			DB 0xE0, 0x00, 0x00, 0xC0, 0xF0, 0x38, 0x1C, 0x0C
			DB 0x0C, 0x0C, 0x0C, 0x18, 0xFC, 0xFC, 0x00, 0x00
			DB 0x00, 0xC0, 0xF0, 0x38, 0x1C, 0x0C, 0x0C, 0x0C
			DB 0x0C, 0x18, 0xFC, 0xFC, 0x00, 0x00, 0x00, 0x00
			DB 0xFC, 0xFC, 0x00, 0x00, 0x00, 0xFC, 0xFC, 0x18
			DB 0x08, 0x0C, 0x0C, 0x0C, 0x1C, 0xF8, 0xF0, 0x00
			DB 0x00, 0x00, 0x70, 0xF8, 0xDC, 0x8C, 0x8C, 0x8C
			DB 0x0C, 0x38, 0x30, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x70, 0x78, 0x6E, 0x67, 0x61
			DB 0x60, 0x60, 0x60, 0x60, 0x40, 0x00, 0x0F, 0x1F
			DB 0x38, 0x70, 0x60, 0x60, 0x60, 0x70, 0x38, 0x1F
			DB 0x0F, 0x00, 0x00, 0x07, 0x1F, 0x38, 0x70, 0x60
			DB 0x60, 0x60, 0x60, 0x30, 0xFF, 0xFF, 0x00, 0x00
			DB 0x00, 0x07, 0x1F, 0x38, 0x70, 0x60, 0x60, 0x60
			DB 0x60, 0x30, 0xFF, 0xFF, 0x00, 0x00, 0x00, 0x00
			DB 0x7F, 0x7F, 0x00, 0x00, 0x00, 0x7F, 0x7F, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x7F, 0x7F, 0x00
			DB 0x00, 0x00, 0x18, 0x38, 0x71, 0x61, 0x61, 0x63
			DB 0x63, 0x33, 0x3F, 0x1E, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x07, 0x07, 0x0C, 0x0C
			DB 0x0C, 0x0C, 0x0C, 0x06, 0x07, 0x03, 0x00, 0x00
			DB 0x00, 0x00, 0x07, 0x07, 0x0C, 0x0C, 0x0C, 0x0C
			DB 0x0C, 0x06, 0x07, 0x03, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

; IMAGE1 = was
IMAGE1:		DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x08, 0xF8, 0xF8, 0x00, 0x00, 0x00, 0x00, 0x80
			DB 0xF8, 0x78, 0xF8, 0x80, 0x00, 0x00, 0x00, 0x80
			DB 0xF0, 0x78, 0x08, 0x00, 0x00, 0x60, 0x70, 0x30
			DB 0x18, 0x18, 0x18, 0x18, 0x18, 0x38, 0xF0, 0xE0
			DB 0x00, 0x00, 0x00, 0x00, 0xE0, 0xF0, 0x38, 0x18
			DB 0x18, 0x18, 0x18, 0x30, 0x70, 0x60, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x0F, 0x7F, 0xF0, 0xC0, 0xF8, 0x3F
			DB 0x03, 0x00, 0x07, 0x7F, 0xF8, 0xC0, 0xF8, 0x1F
			DB 0x03, 0x00, 0x00, 0x00, 0xF0, 0xFC, 0xDC, 0x0E
			DB 0x06, 0x06, 0x06, 0x86, 0x83, 0xE3, 0xFF, 0xFF
			DB 0x00, 0x00, 0x00, 0x20, 0xE3, 0xE3, 0x87, 0x06
			DB 0x06, 0x0E, 0x0E, 0x8C, 0xDC, 0xF8, 0x70, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x03, 0x03, 0x03, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x03, 0x03, 0x01, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x03, 0x03
			DB 0x03, 0x03, 0x03, 0x01, 0x01, 0x00, 0x03, 0x03
			DB 0x02, 0x00, 0x00, 0x00, 0x00, 0x01, 0x03, 0x03
			DB 0x03, 0x03, 0x03, 0x03, 0x01, 0x01, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

; IMAGE2 = here
IMAGE2:		DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0xC0, 0xC0, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0xFF, 0xFF, 0x70, 0x30, 0x18, 0x18
			DB 0x18, 0x18, 0x38, 0xF0, 0xE0, 0x00, 0x00, 0x00
			DB 0x80, 0xE0, 0x70, 0x30, 0x18, 0x18, 0x18, 0x18
			DB 0x18, 0x30, 0x70, 0xE0, 0x80, 0x00, 0x00, 0x00
			DB 0xF8, 0xF8, 0x70, 0x18, 0x18, 0x18, 0x18, 0x00
			DB 0x80, 0xE0, 0x70, 0x30, 0x18, 0x18, 0x18, 0x18
			DB 0x18, 0x30, 0x70, 0xE0, 0x80, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0xFF, 0xFF, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0xFF, 0xFF, 0x00, 0x00, 0x00
			DB 0x3F, 0xFF, 0xE6, 0x86, 0x86, 0x06, 0x06, 0x06
			DB 0x06, 0x86, 0x86, 0xC7, 0x47, 0x00, 0x00, 0x00
			DB 0xFF, 0xFF, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x3F, 0xFF, 0xE6, 0x86, 0x86, 0x06, 0x06, 0x06
			DB 0x06, 0x86, 0x86, 0xC7, 0x47, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x03, 0x03, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x03, 0x03, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x01, 0x01, 0x03, 0x03, 0x03, 0x03
			DB 0x03, 0x03, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x03, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x01, 0x01, 0x03, 0x03, 0x03, 0x03
			DB 0x03, 0x03, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

; IMAGE3 = dragon eyes
IMAGE3:		DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x7F
			DB 0xFF, 0xFE, 0xF1, 0x83, 0x07, 0x0C, 0x00, 0x00
			DB 0x00, 0x00, 0xFF, 0xF0, 0x18, 0x05, 0x03, 0x86
			DB 0x8C, 0xF8, 0xC0, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x80, 0xC0, 0xC0, 0x60
			DB 0x30, 0x30, 0x38, 0x98, 0x8C, 0x8C, 0x86, 0x0E
			DB 0x3B, 0x73, 0xC1, 0x81, 0x01, 0x01, 0xF8, 0x3F
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x80, 0xC0, 0xF0, 0xFC, 0x3F, 0x03
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0xC0, 0xE0
			DB 0xF8, 0xFC, 0xFE, 0x7F, 0x0F, 0x03, 0x01, 0x00
			DB 0x00, 0xC0, 0xE0, 0xF0, 0x78, 0x3C, 0x1C, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x07, 0x9F, 0xFF, 0x7F, 0xFE, 0xF8, 0xF0, 0xC0
			DB 0x80, 0x00, 0x3F, 0xFC, 0xC0, 0x80, 0x1F, 0x3F
			DB 0x1F, 0x0F, 0xFF, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0xC0, 0x60, 0x38
			DB 0x0C, 0x06, 0x03, 0x01, 0xFD, 0x83, 0x00, 0x00
			DB 0x00, 0x00, 0x06, 0x7F, 0xFF, 0xFF, 0xFF, 0xFE
			DB 0x70, 0x00, 0x00, 0x03, 0x0E, 0xF8, 0xFF, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x60, 0x70, 0x78
			DB 0x7C, 0x7E, 0x7F, 0x7F, 0x3F, 0x38, 0x38, 0x18
			DB 0xCC, 0xFC, 0xFC, 0xFE, 0xFF, 0xFF, 0x7F, 0x3F
			DB 0x0F, 0x03, 0x03, 0xFF, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0xFF, 0xFF, 0xFE, 0x3C, 0x70, 0xE0, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x88, 0xC4, 0xC2, 0xE2, 0xF1
			DB 0x79, 0x3C, 0x1C, 0x9E, 0xFF, 0xFF, 0x7F, 0x3F
			DB 0x0F, 0x01, 0x00, 0x00, 0x01, 0x01, 0x03, 0x02
			DB 0x02, 0x03, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x03, 0x0C, 0x18
			DB 0x30, 0x20, 0x40, 0xC0, 0x81, 0x87, 0x8C, 0x90
			DB 0x20, 0x20, 0xC0, 0xC0, 0x80, 0x81, 0x81, 0xC1
			DB 0xC0, 0x60, 0x70, 0x3C, 0x1F, 0x07, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x80, 0xC0, 0xE0, 0xF0, 0xFC, 0xFF
			DB 0x7F, 0x3F, 0x1F, 0x07, 0x03, 0x01, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0xFF, 0xF8, 0x00, 0x00, 0x00
			DB 0xFC, 0xFF, 0xFF, 0xFF, 0xFC, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x18
			DB 0x0C, 0x06, 0x01, 0x00, 0x00, 0x00, 0xC0, 0xF0
			DB 0x38, 0x1C, 0x0E, 0x07, 0x03, 0xE0, 0xC0, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01
			DB 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x30, 0x30, 0x30
			DB 0x20, 0x30, 0x30, 0x38, 0x38, 0x3C, 0x9C, 0xDE
			DB 0xFF, 0x7F, 0x1F, 0x0F, 0x83, 0xE3, 0x7F, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0xFC, 0xFF, 0x07, 0x00, 0xC0, 0xFC
			DB 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0x00, 0x00
			DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

RESET:		LD		C, OLEDPORT	; BASE I/O ADDRESS
			LD		B, 0x06		; RESET HIGH, /CS HIGH
			OUT		(C),A		; OUTPUT BYTE TO OLED INTERFACE
								; (VALUE OF A IRRELEVANT)
			NOP					; DELAY
			NOP
			NOP
			NOP
			RES		2,B			; RESET LOW
			OUT		(C), A		; OUTPUT BYTE TO OLED INTERFACE
			NOP					; LONG DELAY
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
			RET

; ENTER WITH:  A = COMMAND VALUE
COMMAND:	LD		C,OLEDPORT	; BASE I/O ADDRESS
			LD		B,0x00		; RESET LOW, /CS LOW, /COMMAND LOW
			OUT		(C),A		; OUTPUT BYTE TO OLED INTERFACE
								; AS A COMMAND BYTE
			NOP					; DELAY
			NOP
			NOP
			NOP
			SET		1,B			; /CS HIGH
			OUT		(C),A		; OUTPUT BYTE TO OLED INTERFACE
			NOP					; LONG DELAY
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
			RET

; ENTER WITH:  A = GRAPHIC BYTE TO DISPLAY MEMORY
OLEDDATA:	LD		C,OLEDPORT	; BASE I/O ADDRESS
			LD		B, 0x01		; RESET LOW, /CS LOW, /COMMAND HIGH
			OUT		(C),A		; OUTPUT BYTE TO OLED INTERFACE
								; AS A DATA BYTE
			NOP					; DELAY
			NOP
			NOP
			NOP
			SET		1, B		; /CS HIGH
			OUT		(C),A		; OUTPUT BYTE TO OLED INTERFACE
			NOP					; SHORT DELAY
			NOP
			RET

CLEAROLED:	LD		A, 0xB0
			CALL	COMMAND		; SELECT TOP ROW
			CALL	CLEARROW
			LD		A, 0xB1
			CALL	COMMAND		; SELECT SECOND ROW
			CALL	CLEARROW
			LD		A, 0xB2
			CALL	COMMAND		; SELECT THIRD ROW
			CALL	CLEARROW
			LD		A, 0xB3		
			CALL	COMMAND		; SELECT BOTTOM ROW
			CALL	CLEARROW
			RET

CLEARROW:	LD		A, 0x10		
			CALL	COMMAND		; SELECT COLUMN COMMANDS
			LD		A, 0x04
			CALL	COMMAND		; LEFT MOST COLUMN
			XOR		A			; A = 0
			LD		D, 0x80		; COUNTER TO WRITE 128 TIMES
CLEARLOOP:	CALL	OLEDDATA	; WRITE TO DISPLAY RAM
			DEC		D			
			JR		NZ, CLEARLOOP	; DECREASE COUNTER AND LOOP
			RET

DIMDISPLAY:	LD		A, 0x81		; CONTRAST COMMAND
			CALL	COMMAND	
			LD		A, 0x00		; LOWEST BRIGHTNESS
			CALL	COMMAND	
			RET

FULLDISPLAY:	
			LD		A, 0x81		; CONTRAST COMMAND
			CALL	COMMAND	
			LD		A, 0x80		; HIGHEST BRIGHTNESS
			CALL	COMMAND	
			RET

; ENTER WITH:  A = BRIGHTNESS (Variable from 0x00 to 0x80)
SETDISPLAY:
			LD		D, A
			LD		A, 0x81		; CONTRAST COMMAND
			CALL	COMMAND	
			LD		A, D		; SET BRIGHTNESS
			CALL	COMMAND	
			RET

NORMALDIS:	LD		A, 0xA6
			CALL	COMMAND		; NORMAL DISPLAY MODE
			RET

INVERTEDDIS:	
			LD		A, 0xA7
			CALL	COMMAND		; INVERTED DISPLAY MODE
			RET