
; Test Program to interact with the SUPER IO Board
; John Monahan San Ramon CA 94583.    11/13/2021
;==============================================================================
;
;	V1.0	3/17/2021	;Initial Code for V1.0 Board
;	V1.1    5/22/2022	;Removed Zilog UART chip
;	V1.11   7/3/2022	;Minor cleanups
;
						;Equates for display on Propeller Console IO Board (Used In CPM Debugging mode only)
SCROLL			EQU	01H		;Set scrool direction UP.
LF			EQU	0AH
CR			EQU	0DH
BS			EQU	08H		;Back space (required for sector display)
BELL			EQU	07H
SPACE			EQU	20H
FAST			EQU	10H		;High speed scrool
TAB			EQU	09H		;TAB ACROSS (8 SPACES FOR SD Systems Video Board)
ESC			EQU	1BH
CLEAR			EQU	1CH		;<<< Propeller Video Board, Clear to EOL. (Use 80 spaces if EOL not available

FALSE			EQU	0
TRUE			EQU	NOT FALSE

CPM			EQU	FALSE		;TRUE if output via CPM, FALSE if direct to hardware
	
STATUS$BUS$PORT		EQU	0F0H		;CMD Communications port with SUPER_IO Board
DATA$BUS$PORT		EQU	0F1H		;CMD data is sent via this port
CLEAR$FLAG$PORT		EQU	0F2H		;A pulse out to this port will clear error flags
SOFT$RESET$PORT		EQU	0F3H		;Outputting anything to this port reboots the Z80 on the FPGA_DC Board
ABORT$CMD$PORT		EQU	0F4H		;Abort a command
WIFI$RESET$PORT		EQU	0F5H		;Reset ESP8266


;       ------- PS2 KEYBOARD PORTS ---------------	

PS2$STATUS$PORT		EQU	0DAH		;IBM-PC PS2 Keyboard port on S100 bus (P16, P24)
PS2$DATA$PORT		EQU	0DBH

;       ------- S100 SERIAL PORTS ---------------	

USB$STATUS$PORT		EQU	28H		;USB Status Port (P40)
USB$DATA$PORT		EQU	29H		;USB Data Port 

SERIAL$STATUS$PORT	EQU	88H		;RS232 SERIAL Status Port (P17, J1)
SERIAL$DATA$PORT	EQU	89H		;RS232 SERIAL Data Port (P17, J1)

SPEECH$STATUS$PORT	EQU	8AH		;Speech Status Port 
SPEECH$DATA$PORT	EQU	8BH		;Speech Data Port 

;       ------- 8255A PORTS ---------------	

PARALLEL$A		EQU	8CH		;8255A Port A
PARALLEL$B		EQU	8DH		;8255A Port B
PARALLEL$C		EQU	8EH		;8255A Port C
PARALLEL$D		EQU	8FH		;8255A Port D (Control Port).

WRITECFG8255		EQU	10000000b	;Set all three 8255 ports to output mode
READCFG8255		EQU	10011011b	;Set  all three 8255 ports to input mode

;       ------- S100 SOUND PORTS ---------------	

DFP$SOUND$STATUS$PORT	EQU	2AH		;DFP Sound card (P42)
DFP$SOUND$DATA$PORT	EQU	2BH		;DFP Sound card  

FX$SOUND$STATUS$PORT	EQU	2EH		;AdaFruit FX Sound card (P32)
FX$SOUND$DATA$PORT	EQU	2FH		;AdaFruit FX Sound card  

WIFI$STATUS$PORT	EQU	2CH		;WiFi Status Port (P38)
WIFI$DATA$PORT		EQU	2DH		;WiFi Data Port  


 
FX$STATUS$NUMBER	EQU	100		;Status check 100 times else abort


;       ------- SPI I2C PORTS -------------------	


;	Commands to the FPGA_DC Board:-
;	Note these commands are a sub-set of the ZFDC and ZFDC_II Board commands
;	Commands to the FPGA_DC Board:-
;	Note these commands are a sub-set of the old ZFDC and ZFDC_II Board commands

CMD$GET$TIME		EQU	80H		;Get Time and Data from FPGA DC Board RTC
CMD$SET$TIME		EQU	81H		;Set Time and Data on FPGA DC Board RTC

CMD$PRINT$STRING	EQU	82H		;Send a character string to printer.


CMD$FAILED		EQU	0FFH		;CMD failed to exacuite completely
CMD$COMPLETE		EQU	0F0H		;Flag returned by DC board to signal the previous CMD was completed OK
CMD$ABORT		EQU	0E0H		;CMD to abort the current process


	MACLIB	Z80				;For the Z80 DJNZ opcode


;--------------------------------------------------------------------------------------------

	ORG	100H			;<--- For CPM

START:	LXI	SP,STACK
        IF CPM
	LXI     D,SIGN$ON$CPM		;print a welcome message CPM IO
        ELSE
 	LXI     D,SIGN$ON$Z80		;print a welcome message Z80 monitor IO
        ENDIF	

	CALL	PSTRING
	
	JMP	BEGIN
	
	IN	STATUS$BUS$PORT		;(80H) If SUPER IO Board is active this will be X000000X
	CALl	HEXOUT
	CPI	0FFH
	JNZ	BEGIN

	LXI	D,NO$BOARD$MSG		;Board not detected
	CALL	PSTRING
	JP	ABORT
	
					;--------------- Actual start of menu commands ------------------------------
BEGIN:	CALL	ZCRLF
	JMP	MAINLOOP
	

ABORT:	
        IF CPM
	JMP	0H			;Reboot CPM	
        ELSE
 	JMP	0F000H			;Monitor
        ENDIF	


TBL$LIST:
	DW  ERROR			; "A"  
	DW  ERROR			; "B"  
	DW  ERROR			; "C"  
	DW  DFP$SOUND$TEST		; "D"  DFP Sound card test 
	DW  ERROR			; "E"  
	DW  ADAFRUIT$FX			; "F"  AdaFruit Sound card test
	DW  GET$PARALLEL		; "G"  Input 8255A Ports
	DW  SEND$PARALLEL		; "H"  Send data to 8255A ports
	DW  ERROR			; "I"  
	DW  ERROR			; "J"  
	DW  KEY$TEST$PS2		; "K"  PS2 keyboard test
	DW  GET$TIME$DATE		; "L"  Get Date & Time
	DW  ERROR			; "M"  
	DW  ERROR			; "N"  
	DW  ERROR			; "O"  
	DW  PRINTER$TEST		; "P"  Send a string to the printer
	DW  SERIAL$LOOP$TEST		; "Q"  Test close Serial loop
	DW  SERIAL$PORT$TEST		; "R"  Test RS232 port
	DW  TEST$SPEECH			; "S"  
	DW  USB$PORT$TEST		; "T"  Test the USB port
	DW  SET$TIME$DATE		; "U"  Set Data & Time
	DW  ERROR			; "V"  
	DW  WIFI$TEST			; "W"  
	DW  ERROR			; "X" 
	DW  ERROR			; "Y" 
	DW  ERROR			; "Z"  

ERROR:	LXI     D, MSGERR		;CMD error msg
	CALL	PSTRING
	JMP	MAINLOOP
	
					;COMMAND BRANCH TABLE

;-------------------------- MAIN LOOP ------------------------------------------------------------

MAINLOOP:				;print main menu
	LXI	D,MENU$STRING$
	CALL	PSTRING

MAINLOOP1:
	LXI	D,Prompt		;Please Entar a cmd >
	CALL	PSTRING
	
	CALL	ZCI
	CPI	ESC			;Abort if ESC
	JZ	ABORT

	
	CALL	upper
	CPI	'A'			;Must be >= 'A" (Otherwise it jumps off table)
	JC	ERROR
	CPI	'Z'+1			;Must be <= 'Z'
	JNC	ERROR
	MOV	C,A
	CALL	ZCO
	
	CALL	ZCRLF
	
	SBI	'@'			;Adjust to 0,1AH
	
	LXI	H,TBL$LIST		;Get IDE Menu selection
	ADD	A			;X2
	ADD	L
	MOV	L,A
	MOV	A,M
	INX	H
	MOV	H,M
	MOV	L,A			;Jump to table pointer
	PCHL				;JMP (HL)



;------------------------------------- PS/2 Keyboard port test --------------------------------------------------

KEY$TEST$PS2:				;Test PS2 Keyboard Input port
	LXI	D,TEST$PS2$MSG
	CALL	PSTRING
	
PS2$CI:
	IN 	PS2$STATUS$PORT		;NEED CONSTAT TO CLEAN UP SHIFT KEYS ETC
	ANI	01H
	JZ	PS2$CI			;Wait until something there
	IN	PS2$DATA$PORT
	CPI	ESC
	JZ	MAINLOOP
	ANI	7FH			;Always 7 bits only.
	MOV	C,A
	CALL	ZCO
	JMP	PS2$CI

;------------------------------------- USB port test --------------------------------------------------

USB$PORT$TEST:
	LXI	D,TEST$USB$MSG
	CALL	PSTRING

	LXI	D,TEST$USB$MSG
	CALL	USB$STRING

USB$LOOP:
	CALL	ZCSTS	
	JZ	USB$LOOP0
	CALL	ZCI			;Get S100 keyboard chatracter
	CPI	ESC
	JNZ	USB$LOOP0
	LXI	D,DONE$USB$MSG
	CALL	USB$STRING
	JMP	MAINLOOP		;Abort if ESC
	
USB$LOOP0:
	CALL	USB$CI			;Get character from USB terminal
	CPI	ESC
	JNZ	USB$LOOP2
	LXI	D,DONE$USB$MSG
	CALL	USB$STRING
	JMP	MAINLOOP		;Abort if ESC
USB$LOOP2:	
	MOV	C,A
	CALL	USB$CO			;Send character in [C] to USB Port
	CALL	ZCO
USB$LOOP1:
	CALL	USB$STATUS
	JZ	USB$LOOP1
	JMP	USB$LOOP


USB$CO:
	IN	USB$STATUS$PORT		;Print Character, (in [C]), on USB Port
	ANI	00000010B		;Wait until ready
	JNZ	USB$CO	
	MOV	A,C				
	ANI	7FH				
	OUT	USB$DATA$PORT
	RET

USB$STATUS:				;Get USB Input port Status
	IN	USB$STATUS$PORT	
	ANI	01H
	RET				;Ret Z if nothing


USB$CI:	IN 	USB$STATUS$PORT		;Get a character from the USB Port
	ANI	01H
	JZ	USB$CI			;Wait until something is there
	IN	USB$DATA$PORT
	ANI	7FH			;Always 7 bits only.
	RET


;------------------------------------- RS232 SERIAL LOOP Test --------------------------------------------------

SERIAL$LOOP$TEST:
	LXI	D,LOOP$RS232$MSG
	CALL	PSTRING
	
LOOP1:	CALL	ZCI
	MOV	C,A
	CPI	ESC
	JZ	MAINLOOP
	CALL	SERIAL$CO		;Send character in [C]
	CALL	SERIAL$CI		;Pick it up returned
	MOV	C,A	
	CALL	ZCO
	JMP	LOOP1

;------------------------------------- RS232 SERIAL PORT Test --------------------------------------------------

SERIAL$PORT$TEST:
	LXI	D,TEST$RS232$MSG
	CALL	PSTRING
	
	LXI	D,TEST$RS232$MSG
	CALL	SERIAL$STRING

SERIAL$LOOP:
	CALL	ZCSTS	
	JZ	SERIAL$LOOP0
	CALL	ZCI			;Get S100 keyboard chatracter
	CPI	ESC
	JNZ	SERIAL$LOOP0
	LXI	D,DONE$SERIAL$MSG
	CALL	SERIAL$STRING
	JMP	MAINLOOP		;Abort if ESC
	
SERIAL$LOOP0:
	CALL	SERIAL$CI		;Get character from USB terminal
	CPI	ESC
	JNZ	SERIAL$LOOP2
	LXI	D,DONE$SERIAL$MSG
	CALL	SERIAL$STRING
	JMP	MAINLOOP		;Abort if ESC
SERIAL$LOOP2:	
	MOV	C,A
	CALL	ZCO
	CALL	SERIAL$CO		;Send character in [C] to USB Port
SERIAL$LOOP1:
	CALL	SERIAL$STATUS
	JZ	SERIAL$LOOP1
	JMP	SERIAL$LOOP

SERIAL$CO:
	IN	SERIAL$STATUS$PORT	;Print Character, (in [C]), on USB Port
	ANI	00000010B		;Wait until ready
	JNZ	SERIAL$CO	
	MOV	A,C				
	ANI	7FH	
	OUT	SERIAL$DATA$PORT
	RET

SERIAL$STATUS:				;Get Serial Input port Status
	IN	SERIAL$STATUS$PORT	
	ANI	01H
	RET				;Ret Z if nothing


SERIAL$CI:	
	IN 	SERIAL$STATUS$PORT		;Get a character from the USB Port (Not clear why this code does not work)
	ANI	01H
	JZ	SERIAL$CI		;Wait until something is there
	IN	SERIAL$DATA$PORT
	ANI	7FH			;Always 7 bits only.
	RET



;------------------------------------- FX Sound Board Test --------------------------------------------------

ADAFRUIT$FX:				;Initilise the Adafruit FX Sound Board
	MVI	A,0H			;Pulse Reset pin on FX Module
	OUT	FX$SOUND$STATUS$PORT
	MVI	A,80H			;Pulse Reset pin on FX Module (Pin must be HIGH)
	OUT	FX$SOUND$STATUS$PORT
	
	IN	FX$SOUND$DATA$PORT	;2FH
	ORA	A			;Is the card present, should be 00001010
	JNZ	ADAFRUIT$FX1
NO$FX$CARD:
	LXI	D,NO$ADAFRUIT$FX$CARD	;No AdaFruit FX card detected
	CALL	PSTRING
	JMP	MAINLOOP
	
ADAFRUIT$FX1:
	CPI	0FFH
	JZ	NO$FX$CARD		;In case no board

	MVI	B,4			;Collect 4 lines of data sent by the board
FX$LOOP:
	CALL	FX$STATUS
	JZ	FX$LOOP

	CALL	FX$CI
	MOV	C,A
	CALL	ZCO
	CPI	0AH
	JNZ	FX$LOOP
	DJNZ	FX$LOOP

	
;--------------------------------------------------

FX$MENU$LOOP:
	LXI	D,ADAFRUIT$FX$MENU
	CALL	PSTRING
	MVI	C,'>'
	CALL	ZCO			;Send a character
	
	CALL	ZCI
	CPI	ESC
	JZ	MAINLOOP
	CPI	'0'
	JZ	RESET$FX
	CPI	'1'
	JZ	FX$GET$FILES
	CPI	'2'
	JZ	FX$PLAY$FILE
	CPI	'3'
	JZ	FX$PLAY$LOUDER
	CPI	'4'
	JZ	FX$PLAY$LOWER
	CPI	'5'
	JZ	FX$PAUSE
	CPI	'6'
	JZ	FX$RESUME
	CPI	'7'
	JZ	FX$STOP
	CPI	'8'
	JZ	GET$FILE$NAME

	LXI	D,BAD$CMD		;Invalid CMD option
	CALL	PSTRING
	JMP	FX$MENU$LOOP
	
	
;---------------------------------------------------

RESET$FX:
	MVI	A,0H			;Pulse Reset pin on FX Module
	OUT	FX$SOUND$STATUS$PORT
	CALL	DELAY$SHORT
	MVI	A,0H			;Pulse Reset pin on FX Module (Pin must be HIGH)
	OUT	FX$SOUND$STATUS$PORT
	CALL	DELAY$SHORT
	JMP	FX$MENU$LOOP
	
	
FX$GET$FILES:
	MVI	C,'1'
	CALL	ZCO
	CALL	ZCRLF
	CALL	ZCRLF
	
	MVI	C,'L'			;Get files 'L'
	CALL	FX$CO
	MVI	C,0DH
	CALL	FX$CO
	MVI	C,0AH
	CALL	FX$CO
	
FX$LOOP2:
	LXI	H,0 
	SHLD	STATUS$COUNT		;Status check 64K times -- else abort
FX$LOOP1:
	LHLD	STATUS$COUNT
	DCX	H
	SHLD	STATUS$COUNT
	MOV	A,L
	ORA	H
	JZ	FX$MENU$LOOP
	
	CALL	FX$STATUS
	JZ	FX$LOOP1
	CALL	FX$CI
	MOV	C,A
	CALL	ZCO
	JMP	FX$LOOP2
	
	
FX$PLAY$FILE:
	MVI	C,'2'
	CALL	ZCO
	
	CALl	ZCRLF
	CALL	ZCRLF
	
	LXI	D,ENTER$FILE$NO
	CALL	PSTRING
	CALL	GETHEX			;Note must be 2 characters
	STA	FX$FILE$NO

	CALL	ZCRLF
	MVI	C,'#'			;Get file '#'
	CALL	FX$CO
	
	LDA	FX$FILE$NO		;Two characters,  send high digit first
	RRC
	RRC
	RRC
	RRC
	ANI	0FH
	ADI	30H			;Convert to ASCII
	MOV	C,A
	CALL	FX$CO
	
	LDA	FX$FILE$NO		;Get low digit
	ANI	0FH
	ADI	30H			;Convert to ASCII
	MOV	C,A
	CALL	FX$CO
	
	MVI	C,0DH
	CALL	FX$CO
	MVI	C,0AH
	CALL	FX$CO
	
FX$FILE$NUMBER:
	LXI	H,8000H
	SHLD	STATUS$COUNT		;Status check 100 times, if nothing, we aee done return to menu
FX$FILE$NUMBER2:
	LHLD	STATUS$COUNT
	DCX	H
	SHLD	STATUS$COUNT
	MOV	A,L
	ORA	H
	JZ	FX$MENU$LOOP
	
	CALL	FX$STATUS
	JZ	FX$FILE$NUMBER2
	CALL	FX$CI
	MOV	C,A
	CALL	ZCO
	JMP	FX$FILE$NUMBER
	

FX$PLAY$LOUDER:
	MVI	C,'3'
	CALL	ZCO
	LXI	D,FX$UP$VOLUME
	CALL	PSTRING
	CALl	ZCRLF
	
	MVI	C,'+'			;Set vol up
	CALL	FX$CO
	MVI	C,0DH
	CALL	FX$CO
	MVI	C,0AH
	CALL	FX$CO
	
FX$LOUDER1:
	LXI	H,8000H
	SHLD	STATUS$COUNT		;Status check 100 times else abort
FX$LOUDER2:
	LHLD	STATUS$COUNT
	DCX	H
	SHLD	STATUS$COUNT
	MOV	A,L
	ORA	H
	JZ	FX$MENU$LOOP
	
	CALL	FX$STATUS
	JZ	FX$LOUDER2
	CALL	FX$CI
	MOV	C,A
	CALL	ZCO
	JMP	FX$LOUDER1



FX$PLAY$LOWER:
	MVI	C,'4'
	CALL	ZCO
	LXI	D,FX$DOWN$VOLUME
	CALL	PSTRING
	CALl	ZCRLF

	MVI	C,'-'			;Set vol downn
	CALL	FX$CO
	MVI	C,0DH
	CALL	FX$CO
	MVI	C,0AH
	CALL	FX$CO

FX$LOWER1:
	LXI	H,8000H
	SHLD	STATUS$COUNT		;Status check 100 times else abort
FX$LOWER2:
	LHLD	STATUS$COUNT
	DCX	H
	SHLD	STATUS$COUNT
	MOV	A,L
	ORA	H
	JZ	FX$MENU$LOOP
	
	CALL	FX$STATUS
	JZ	FX$LOWER2
	CALL	FX$CI
	MOV	C,A
	CALL	ZCO
	JMP	FX$LOWER1


FX$PAUSE:
	MVI	C,'5'
	CALL	ZCO
	LXI	D,FX$PAUSE$MSG
	CALL	PSTRING

	MVI	C,'='			;Pause signal
	CALL	FX$CO
	MVI	C,0DH
	CALL	FX$CO
	MVI	C,0AH
	CALL	FX$CO
	JZ	FX$MENU$LOOP


FX$RESUME:
	MVI	C,'6'
	CALL	ZCO
	LXI	D,FX$RESUME$MSG
	CALL	PSTRING

	MVI	C,'>'			;Resume signal
	CALL	FX$CO
	MVI	C,0DH
	CALL	FX$CO
	MVI	C,0AH
	CALL	FX$CO
	JZ	FX$MENU$LOOP

FX$STOP:
	MVI	C,'7'
	CALL	ZCO
	LXI	D,FX$STOP$MSG
	CALL	PSTRING

	MVI	C,'q'			;Stop playback
	CALL	FX$CO
	MVI	C,0DH
	CALL	FX$CO
	MVI	C,0AH
	CALL	FX$CO
	JZ	FX$MENU$LOOP


GET$FILE$NAME:				;Get a file
	MVI	C,'8'
	CALL	ZCO
	CALL	ZCRLF
	CALL	ZCRLF
	
	LXI	D,FX$ENTER$NAME
	CALL	PSTRING

	CALL	FILE$NAME		;Name in [HL]

	LXI	D,FX$GOT$NAME
	CALL	PSTRING
	LXI	D,FX$BUFFER
	CALL	PSTRING
	
	MVI	C,'P'			;Get File
	CALL	FX$CO
	MVI	B,12
	LXI	H,FX$BUFFER
MORE$NAME:
	CALL	DELAY$SHORT		;Seems to be needed.
	MOV	C,M
	INX	H
	CALL	FX$CO
	DJNZ	MORE$NAME

	MVI	C,0DH
	CALL	FX$CO
	MVI	C,0AH
	CALL	FX$CO
	
MORE$NAME2:
	LXI	H,0 
	SHLD	STATUS$COUNT		;Status check 100 times else abort
MORE$NAME3:
	LHLD	STATUS$COUNT
	DCX	H
	SHLD	STATUS$COUNT
	MOV	A,L
	ORA	H
	JZ	FX$MENU$LOOP
	
	CALL	FX$STATUS
	JZ	MORE$NAME3
	CALL	FX$CI
	MOV	C,A
	CALL	ZCO
	JMP	MORE$NAME2

;
;
;
;
FILE$NAME:				;Get a 11 character file name
	LXI	H,FX$BUFFER
	MVI	B,13
	MVI	A,20H			;Clear Spaces
MORE$NAME5:
	MOV	M,A
	INX	H
	DJNZ	MORE$NAME5

	LXI	H,FX$BUFFER
	MVI	B,9			;8 characters max
MORE$NAME6:
	CALL	ZCI
	CALL	UPPER			;Must be upper case
	MOV	C,A
	CPI	'.'
	JZ	EXT$NAME		;Get extension			
	CALL	ZCO
	MOV	M,A
	INX	H
	DJNZ	MORE$NAME6
EXT$NAME:
	CALL	ZCO	
	LXI	H,FX$BUFFER$EXT
	
	MVI	B,3			;3 characters max
MORE$NAME7:
	CALL	ZCI
	CALL	UPPER			;Must be upper case
	MOV	C,A
	CALL	ZCO
	MOV	M,A
	INX	H
	DJNZ	MORE$NAME7
	MVI	A,'$'
	MOV	M,A
	RET

;
;--------------------------------- FX Sound card Support Routines ------------------------------

FX$STATUS:				;Get USB Input port Status
	IN	FX$SOUND$STATUS$PORT	
	ANI	01H
	RET				;Ret Z if nothing
	
FX$CI:	IN	FX$SOUND$STATUS$PORT	
	ANI	01H
	JZ	FX$CI
	IN 	FX$SOUND$DATA$PORT	;Get data from the FX Sound Port
	RET
	

FX$CO:	IN	FX$SOUND$STATUS$PORT	;Print Character, (in [C]), on USB Port
	ANI	00000010B		;Wait until ready
	JNZ	FX$CO	
	MOV	A,C
	OUT	FX$SOUND$DATA$PORT
	RET



DELAY$SHORT:
	PUSH	PSW
	PUSH	B
	MVI	A,40			;DELAY ~100 MS (DOES NOT SEEM TO BE CRITICAL)
DELAY3:	MVI	B,0
M11:	DCR	B
	JNZ	M11
	DCR     A
	JNZ     DELAY3
	POP	B
	POP	PSW
	RET

;------------------------------------- DFP SOUND TEST ---------------------------------------

DFP$SOUND$TEST:				;Initilise the DFP Sound Board
DFP$LOOP$TEST:
;	MVI	A,40H
;	MOV	C,A
;	CALL	DFP$CO
;	CALL	DFP$CI
;	MOV	A,C
;	CALL	HEXOUT
;	JMP	MAINLOOP
;	JMP	DFP$LOOP$TEST


	IN	DFP$SOUND$STATUS$PORT
	ORA	A			;Is the card present if so, get 09H
	JNZ	CHECK$BOARD
NO$CARD:
	LXI	D,NO$DFP$CARD		;No DFP card detected
	CALL	PSTRING

CHECK$BOARD:
	CPI	0FFH			;In case actual board is not present
	JZ	NO$CARD

DFP$MENU$LOOP:
	LXI	D,DFP$SOUND$MENU
	CALL	PSTRING
	MVI	C,'>'
	CALL	ZCO			;Send a character
	
	CALL	ZCI
	CPI	ESC
	JZ	MAINLOOP
	MOV	C,A
	CALL	ZCO

	CPI	'0'
	JZ	DFP$PLAY$FILE

	CPI	'1'
	JZ	DFP$SET$VOLUME

	CPI	'2'
	JZ	DFP$REPEAT$PLAY

	CPI	'3'
	JZ	DFP$PAUSE

	CPI	'4'
	JZ	DFP$PLAY

	CPI	'5'
	JZ	DFP$ALL

	CPI	'6'
	JZ	DFP$RESET

	CPI	'7'
	JZ	DFP$BYTE$OUT

	CPI	'8'
	JZ	DFP$QUERY		;This routine is not working correctly
					;returning wrong values
	LXI	D,BAD$CMD
	CALL	PSTRING
	JMP	DFP$MENU$LOOP
	
	
;---------------------------------------------------
		
DFP$PLAY$FILE:				;<<<<<<<< Play a file >>>>>>>>>>
	LXI	D,ENTER$FILE$NO
	CALL	PSTRING
	CALL	GETHEX			;Note must be 2 characters
	STA	DFP$VARIABLE		;Add to CMD paramater
	STA	DFP$CURRENT$TRACK	;Store Current #
	LXI	D,SENDING$CMD
	CALL	PSTRING
	
	LXI	H,FILE$NUMBER$CMD
	CALL	SEND$CMD
	CALL	ZCRLF
	CALL	ZCRLF
	JZ	DFP$MENU$LOOP

	
DFP$SET$VOLUME:				;<<<<<<<< Set Volume >>>>>>>>
	LXI	D,DFP$ENTER$VOLUME
	CALL	PSTRING
	CALL	GETHEX			;Note must be 2 characters
	STA	DFP$VARIABLE		;Add to CMD paramater
	LXI	D,SENDING$CMD
	CALL	PSTRING
					
	LXI	H,DFP$VOLUME$CMD
	CALL	SEND$CMD
	CALL	ZCRLF
	CALL	ZCRLF
	JZ	DFP$MENU$LOOP


DFP$REPEAT$PLAY:			;<<<<<<<< Repeat Play current tarck >>>>>>>>
	LXI	D,DFP$REPEAT$MSG
	CALL	PSTRING
	XRA	A
	STA	DFP$VARIABLE		;No paramater needed
	LXI	D,SENDING$CMD
	CALL	PSTRING
					
	LDA	DFP$CURRENT$TRACK	;Get Current #
	STA	DFP$VARIABLE		;Set current #
	LXI	H,DFP$REPEAT$CMD
	CALL	SEND$CMD
	CALL	ZCRLF
	CALL	ZCRLF
	JZ	DFP$MENU$LOOP


DFP$PAUSE:				;<<<<<<<< Pause Play current tarck >>>>>>>>
	LXI	D,DFP$PAUSE$MSG
	CALL	PSTRING
	XRA	A
	STA	DFP$VARIABLE		;No paramater needed
	LXI	D,SENDING$CMD
	CALL	PSTRING
					
	LXI	H,DFP$PAUSE$CMD
	CALL	SEND$CMD
	CALL	ZCRLF
	CALL	ZCRLF
	JZ	DFP$MENU$LOOP


DFP$PLAY:				;<<<<<<<< Play current tarck >>>>>>>>
	LXI	D,DFP$PLAY$MSG
	CALL	PSTRING
	XRA	A
	STA	DFP$VARIABLE		;No paramater needed
	LXI	D,SENDING$CMD
	CALL	PSTRING
					
	LXI	H,DFP$PLAY$CMD
	CALL	SEND$CMD
	CALL	ZCRLF
	CALL	ZCRLF
	JZ	DFP$MENU$LOOP


DFP$ALL:				;<<<<<<<< Repeat play all tracks >>>>>>>>
	LXI	D,DFP$PLAY$ALL$MSG
	CALL	PSTRING
	MVI	A,01
	STA	DFP$VARIABLE		;No paramater needed
	LXI	D,SENDING$CMD
	CALL	PSTRING
					
	LXI	H,DFP$ALL$PLAY$CMD
	CALL	SEND$CMD
	CALL	ZCRLF
	CALL	ZCRLF
	JZ	DFP$MENU$LOOP



DFP$RESET:				;<<<<<<<< Reset Player >>>>>>>>
	LXI	D,DFP$RESET$MSG
	CALL	PSTRING
	XRA	A
	STA	DFP$VARIABLE		;No paramater needed
	LXI	D,SENDING$CMD
	CALL	PSTRING
					
	LXI	H,DFP$RESET$CMD
	CALL	SEND$CMD
	CALL	ZCRLF
	CALL	ZCRLF
	JZ	DFP$MENU$LOOP


DFP$QUERY:				;<<<<<<<< Query the Player with CMD 42 >>>>>>>>
	LXI	D,DFP$QUERY$MSG
	CALL	PSTRING

	MVI	A,0FEH
	STA	DFP$VARIABLE$HIGH	;Two paramaters needed, HIGH
	MVI	A,0BCH
	STA	DFP$VARIABLE		;LOW, paramater needed
	
	LXI	D,SENDING$CMD
	CALL	PSTRING
					
	LXI	H,DFP$QUERY$VOL$CMD
	CALL	SEND$QUERY$CMD
	
	LXI	D,GOT$BACK
	CALL	PSTRING
	
	MVI	B,10
MORE$QUERY:
	CALL	DFP$CI
	CALL	HEXOUT
	DJNZ	MORE$QUERY
	
	CALL	ZCRLF
	CALL	ZCRLF
	JZ	DFP$MENU$LOOP


DFP$BYTE$OUT:				;;<<<<<<<< Send a Byte (nibble) to port 8AH  >>>>>>>>
	LXI	D,DFP$BYTE$VALUE
	CALL	PSTRING

	CALL	GETHEX			;Note up to characters
	OUT	DFP$SOUND$STATUS$PORT	;Send nibble
	CALL	ZCRLF
	CALL	ZCRLF
	JMP	DFP$MENU$LOOP
	
	
	
	
;--------------------------------- DFP Sound card Support Routines ------------------------------

SEND$CMD				;Send a command
	MOV	C,M			;1. Send 7E FF 06 03 00 00 XX EF
	CALL	DFP$CO
	CALL	HEXOUT

	INX	H
	MOV	C,M			;2. FF (Version Number)
	CALL	DFP$CO
	CALL	HEXOUT

	INX	H
	MOV	C,M			;3. 06 Length
	CALL	DFP$CO
	CALL	HEXOUT

	INX	H
	MOV	C,M			;4. XX CMD
	CALL	DFP$CO
	CALL	HEXOUT

	INX	H
	MOV	C,M			;5. 00  No feedback required
	CALL	DFP$CO
	CALL	HEXOUT

	INX	H
	MOV	C,M
	CALL	DFP$CO
	CALL	HEXOUT

	LDA	DFP$VARIABLE		;7. Get veriable (paramater low)
	MOV	C,A
	CALL	DFP$CO
	CALL	HEXOUT

	MVI	C,0EFH			;8. EF (Terminator)
	CALL	DFP$CO
	CALL	HEXOUT
	RET
	

SEND$QUERY$CMD				;Send a query command 
	MOV	C,M			;1. Send 7E FF 06 03 00 XX XX EF
	CALL	DFP$CO
	CALL	HEXOUT

	INX	H
	MOV	C,M			;2. FF (Version Number)
	CALL	DFP$CO
	CALL	HEXOUT

	INX	H
	MOV	C,M			;3. 06 Length
	CALL	DFP$CO
	CALL	HEXOUT

	INX	H
	MOV	C,M			;4. XX CMD
	CALL	DFP$CO
	CALL	HEXOUT

	INX	H
	MOV	C,M			;5. 00  No feedback required
	CALL	DFP$CO
	CALL	HEXOUT
	
	MVI	C,0			;6.  always 00
	CALL	DFP$CO
	CALL	HEXOUT

	MVI	C,0			;7. always 00
	CALL	DFP$CO
	CALL	HEXOUT

	LDA	DFP$VARIABLE$HIGH 
	MOV	C,A
	CALL	DFP$CO
	CALL	HEXOUT

	LDA	DFP$VARIABLE
	MOV	C,A
	CALL	DFP$CO
	CALL	HEXOUT

	MVI	C,0EFH			;8. EF (Terminator)
	CALL	DFP$CO
	CALL	HEXOUT
	RET
	

DFP$STATUS:				;Get DFP Input port Status
	IN	DFP$SOUND$STATUS$PORT	
	ANI	01H
	RET				;Ret Z if nothing
	
DFP$CI:	IN	DFP$SOUND$STATUS$PORT	
	ANI	01H
	JZ	DFP$CI
	IN 	DFP$SOUND$DATA$PORT	;Get data from the DFP Sound Port
	RET
	

DFP$CO:	IN	DFP$SOUND$STATUS$PORT	;Print Character, (in [C]), on DFP Port
	ANI	00000010B		;Wait until ready
	JNZ	DFP$CO	
	MOV	A,C
	OUT	DFP$SOUND$DATA$PORT
	RET




;------------------------------------- GET/GET 8255A PORT DATA ---------------------------------------
	
SEND$PARALLEL:				; "H"  Send data to 8255A ports
	LXI	D,P$SEND$MSG
	CALL	PSTRING
	
	MVI	A,WRITECFG8255
	OUT	PARALLEL$D

	LXI	D,P$SENDA$MSG		;Enter 8255A Port A (XXH):$'
	CALL	PSTRING
	CALL	GETHEX
	STA	PORT$A$STORE		;Store it in RAM
	OUT	PARALLEL$A

	LXI	D,P$SENDB$MSG		;Enter 8255A Port B (XXH):$'
	CALL	PSTRING
	CALL	GETHEX
	STA	PORT$B$STORE		;Store it in RAM
	OUT	PARALLEL$B

	LXI	D,P$SENDC$MSG		;Enter 8255A Port C (XXH):$'
	CALL	PSTRING
	CALL	GETHEX
	STA	PORT$C$STORE		;Store it in RAM
	OUT	PARALLEL$C

	LXI	D,OUT$RESULT$MSG	;'8255A Ports    A           B              C$'
	CALL	PSTRING

	LXI	D,OUT$RESULT1$MSG	;CR,LF,'             $'
	CALL	PSTRING
	LDA	PORT$A$STORE
	CALL	ZBITS

	LXI	D,OUT$RESULT2$MSG	;'          $'
	CALL	PSTRING
	LDA	PORT$B$STORE
	CALL	ZBITS
	
	LXI	D,OUT$RESULT3$MSG	;'          $'
	CALL	PSTRING
	LDA	PORT$C$STORE
	CALL	ZBITS
	CALL	ZCRLF
	CALl	ZCRLF
	JMP	MAINLOOP		;Done



;------------------------------------- SEND 8255A PORT DATA ---------------------------------------

GET$PARALLEL				; "G"  Input 8255A Ports
	LXI	D,P$GET$MSG
	CALL	PSTRING

	MVI	A,READCFG8255
	OUT	PARALLEL$D

	IN	PARALLEL$A
	STA	PORT$A$STORE		;Store it in RAM
	IN	PARALLEL$B
	STA	PORT$B$STORE		;Store it in RAM
	IN	PARALLEL$C
	STA	PORT$C$STORE		;Store it in RAM

	LXI	D,OUT$RESULT$MSG	;'8255A Ports    A           B              C$'
	CALL	PSTRING

	LXI	D,OUT$RESULT1$MSG	;CR,LF,'             $'
	CALL	PSTRING
	LDA	PORT$A$STORE
	CALL	ZBITS

	LXI	D,OUT$RESULT2$MSG	;'          $'
	CALL	PSTRING
	LDA	PORT$B$STORE
	CALL	ZBITS
	
	LXI	D,OUT$RESULT3$MSG	;'          $'
	CALL	PSTRING
	LDA	PORT$C$STORE
	CALL	ZBITS
	
	CALL	ZCRLF
	CALl	ZCRLF
	JMP	MAINLOOP		;Done




;------------------------------------- WIFI BOARD TEST ---------------------------------------

WIFI$TEST:				;Initilise the WiFi Board
	LXI	D,RESET$WIFI$MSG	;'Resetting WIFI module.$'
	CALL	PSTRING

	
	
WIFI$MENU$LOOP:
	LXI	D,WIFI$MENU
	CALL	PSTRING
	
	CALL	ZCI
	CPI	ESC
	JZ	MAINLOOP

	CPI	'0'
	JZ	ECHO$TEST$WIFI

	CPI	'1'
	JZ	DO$WIFI$RESET
					
	CPI	'2'
	JZ	AT$CMD$CWMODE$WIFI

	CPI	'3'
	JZ	AT$CMD$GMR$WIFI
					
	CPI	'4'
	JZ	AT$CMD$SET$WIFI

	CPI	'5'
	JZ	AT$CMD$NETWORK$WIFI	;Show networks
	
	CPI	'6'
	JZ	AT$CMD$IP$WIFI		;Show IP address

	LXI	D,BAD$CMD
	CALL	PSTRING
	JMP	WIFI$MENU$LOOP
	
	
;---------------------------------------------------

ECHO$TEST$WIFI:	
	LXI	D,ECHO$WIFI$MSG		;'Echo test of serial port without WIFI card.$'
	CALL	PSTRING
	CALL	ZCRLF

	MVI	C,'>'
	CALL	ZCO

WIFI$LOOP:
	CALL	ZCSTS			;Anything at keyboard
	JZ	WIFI$LOOP1		;No, go back and try WIFI port
	CALL	ZCI
	CPI	ESC
	JZ	WIFI$MENU$LOOP
	MOV	C,A
	CALL	WIFI$CO			;Send character in [C]
	JMP	WIFI$LOOP
	
WIFI$LOOP1:
	CALL	WIFI$CSTS		;Anything at WIFI Port
	JZ	WIFI$LOOP		;No, try console
	CALL	WIFI$CI			;Yes, get the character
	MOV	C,A
	CALL	ZCO			;Show the recieved character
	JMP	WIFI$LOOP		;Go back and try Console port


;--------------------------------------------------------------------------------------------------	
	
DO$WIFI$RESET:				
	LXI	D,RESET$WIFI$MSG	;'Will initilize ESP8266 WiFi card by pulsing RST low.$'
	CALL	PSTRING
	CALL	ZCRLF
	
	OUT	WIFI$RESET$PORT		;Reset the module
	JMP	WIFI$MENU$LOOP

	
	
;---------------------------------------------------

AT$CMD$CWMODE$WIFI:			;Menu #2
	CALL	ZCRLF
	LXI	D,OK$WIFI$MSG0		;'Will send AT+CWMODE=?'
	CALL	PSTRING

	LXI	H,AT$WIFI$MSG2		;AT+CWMODE=?
AT$WIFI2:	
	MOV	A,M
	CPI	'$'
	JZ	WIFI$RD$LOOP
	CALL	SEND$WIFI
	INX	H
	JMP	AT$WIFI2

;---------------------------------------------------

AT$CMD$GMR$WIFI:
	CALL	ZCRLF			;Menu #3
	LXI	D,OK$WIFI$MSG1		;'Will send AT+GMR'
	CALL	PSTRING

	LXI	H,AT$WIFI$MSG3		;AT+GMR
AT$WIFI3:	
	MOV	A,M
	CPI	'$'
	JZ	WIFI$RD$LOOP
	CALL	SEND$WIFI
	INX	H
	JMP	AT$WIFI3


;---------------------------------------------------
;
AT$CMD$SET$WIFI:
	CALL	ZCRLF			;Menu #4
	LXI	D,OK$WIFI$MSG2		;'Will send AT+CWMODE=1'
	CALL	PSTRING

	LXI	H,AT$WIFI$MSG4		;AT+CWMODE=1
AT$WIFI4:	
	MOV	A,M
	CPI	'$'
	JZ	WIFI$RD$LOOP
	CALL	SEND$WIFI
	INX	H
	JMP	AT$WIFI4


;---------------------------------------------------
;
AT$CMD$NETWORK$WIFI:
	CALL	ZCRLF			;Menu #5
	LXI	D,OK$WIFI$MSG3		;'Will send AT+CWLAP'
	CALL	PSTRING

	LXI	H,AT$WIFI$MSG5		;AT+CWLAP
AT$WIFI5:	
	MOV	A,M
	CPI	'$'
	JZ	WIFI$RD$LOOP
	CALL	SEND$WIFI
	INX	H
	JMP	AT$WIFI5


;---------------------------------------------------
;

AT$CMD$IP$WIFI:
	CALL	ZCRLF			;Menu #6
	LXI	D,OK$WIFI$MSG4		;'Will send AT+CIFSR'
	CALL	PSTRING

	LXI	H,AT$WIFI$MSG6		;AT+CIFSR
AT$WIFI6:	
	MOV	A,M
	CPI	'$'
	JZ	WIFI$RD$LOOP
	CALL	SEND$WIFI
	INX	H
	JMP	AT$WIFI6


;----------------------------------------------------

SEND$WIFI:
	MOV	C,A
	CALL	WIFI$CO
	CALL	WIFI$CI
	MOV	C,A
	CALL	ZCO
	RET

WIFI$RD$LOOP:
	CALL	ZCSTS			;Anything at keyboard
	JNZ	WIFI$LOOP2		;No, go back and try WIFI port
	CALL	WIFI$CSTS		;Anything returned
	JZ	WIFI$RD$LOOP
	CALL	WIFI$CI			;Get character
	MOV	C,A
	CALL	ZCO
	JMP	WIFI$RD$LOOP
	
WIFI$LOOP2:	
	CALL	ZCI
	CPI	ESC
	JNZ	WIFI$RD$LOOP
	JMP	WIFI$MENU$LOOP
	
	
;-------------------------------------------
;   WIFI SERIAL PORT STATUS ROUTINE
;----------------------------------------------------
	
WIFI$CSTS:
	IN	WIFI$STATUS$PORT	
	ANI	01H
	RET				;Ret Z if nothing										

;----------------------------------------------------
;   WIFI SERIAL PORT GET CHARACTER ROUTINE
;----------------------------------------------------

WIFI$CI:	
	IN 	WIFI$STATUS$PORT	;Get a character from the USB Port
	ANI	01H
	JZ	WIFI$CI			;Wait until something is there
	IN	WIFI$DATA$PORT
	RET


;----------------------------------------------------
;  WIFI PORT SEND CHARACTER ROUTINE
;----------------------------------------------------

WIFI$CO:
	IN	WIFI$STATUS$PORT	;Print Character, (in [C]), on USB Port
	ANI	00000010B		;Wait until ready
	JNZ	WIFI$CO	
	MOV	A,C				
	OUT	WIFI$DATA$PORT
	RET



;------------------------------------- PRINTER CMD --------------------------------------------------

PRINTER$TEST:
	LXI	D,TEST$PRN$MSG		;'Send test string to printer$'
	CALL	PSTRING

	LXI	H,PRINTER$STRING
	LXI	D,TEST$PRN$MSG		;'Send test string to printer$'
	CALL	PSTRING

	LXI	H,PRINTER$STRING

	MVI	A,CMD$PRINT$STRING	;85H, Send string to printer command
	CALL	DATA$TO$FPGA		;CMD to FPGA Board

PRN$LOOP:
	MOV	A,M
	CALL	DATA$TO$FPGA		;Printer character Data to Super IO FPGA Board
	MOV	A,M
	ORA	A
	JZ	PRN$DONE		;Print up to terminating 0
	MOV	C,A
	CALL	ZCO
	INX	H
	JMP	PRN$LOOP

PRN$DONE:
	CALL	ZCRLF
	JZ	MAINLOOP		
	

;------------------------------------- SPEECH OUTPUT --------------------------------------------------
;
;SPEAK OUTPUT (WILL BE USED TO COMMUNICATE WITH TALKER)
; Note the S100Computers I/O board V-Stamp speech chip will use the initial baud rate of 9600 Baud 

TEST$SPEECH:
	MVI	C,CR				;Flush buffer
	CALL	SPEAKOUT
	CALL	SPEAKOUT
	CALL	SPEAKOUT
	
;TEST$SPEECH1:
;	MVI	C,33H
;	CALL	SPEAKOUT
;	MVI	C,CR
;	CALL	SPEAKOUT
;	JMP	TEST$SPEECH1		
	
	LXI	D,TEST$SPEECH$MSG		;'Send test string to speaker$'
	CALL	PSTRING
	CALL	ZCI
	CALL	ZCRLF
	CALL	ZCRLF
	LXI	H,SPEECH$STRING
	CALL	SPEAK$MSG
	CALL	ZCRLF
	JMP	MAINLOOP

;SPEAKTOMM THIS IS A ROUTINE TO SEND A STRING TO TALKER [HL] AT STRING
SPEAK$MSG:
	MOV	A,M
	CPI	'$'
	JZ	SPEAK1
	MOV	C,A
	CALL	ZCO
	CALL	SPEAKOUT
	INX	H
	JMP	SPEAK$MSG
SPEAK1:	MVI	C,0DH			;MUST END WITH A CR
	CALL	SPEAKOUT
	RET


SPEAKOUT:
	IN	SPEECH$STATUS$PORT	;Print Character, (in [C]), on USB Port
	ANI	00000010B		;Wait until ready
	JNZ	SPEAKOUT	
	MOV	A,C				
	ANI	7FH				
	OUT	SPEECH$DATA$PORT
	RET



;------------------------------------- RTC CMDS --------------------------------------------------

GET$TIME$DATE:
	LXI	D,Read$RTC		;Reading the Time  & Date from the FPGA DC Board RTC.
	CALL	PSTRING

	MVI	C,'@'
	CALL	ZCO
	MVI	A,CMD$GET$TIME		;80H  Get Time CMD 
	CALL	DATA$TO$FPGA		;CMD to FPGA Board

	LXI	D,MSG20			; 'Date = '
	CALL	PSTRING

	CALL	GET$FPGA$TO$S100	;Wait for century (20)
	CALL	HEXOUT

	CALL	GET$FPGA$TO$S100	;Wait for year
	CALL	HEXOUT
	MVI	C,'/'
	CALL	ZCO


	CALL	GET$FPGA$TO$S100	;Wait for month
	CALL	HEXOUT
	MVI	C,'/'
	CALL	ZCO

	CALL	GET$FPGA$TO$S100	;Wait for day
	CALL	HEXOUT

	LXI	D,MSG19			; '  Time= '
	CALL	PSTRING

	CALL	GET$FPGA$TO$S100	;Wait for hour
	CALL	HEXOUT
	MVI	C,':'
	CALL	ZCO
	
	CALL	GET$FPGA$TO$S100	;Wait for minutes
	CALL	HEXOUT
	MVI	C,':'
	CALL	ZCO

	CALL	GET$FPGA$TO$S100	;Wait for seconds
	CALL	HEXOUT
	CALL	ZCRLF

	CALL	GET$FPGA$TO$S100	;Get CMD$CPMPLETE/ERROR FLAG
	CPI	CMD$COMPLETE		;0F0H, Flag returned by DC board to signal the previous CMD was OK
	JZ	MAINLOOP
					;Can add a timeout loop here later for an abort
	LXI	D,CMD$ERROR		;An error was detected with the last command
	CALL	PSTRING
	JP	MAINLOOP


SET$TIME$DATE:
	LXI	D,Set$RTC		;Set the Time & Date on the FPGA DC Board RTC.
	CALL	PSTRING

	MVI	A,CMD$SET$TIME		;81H  Set Time CMD 
	CALL	DATA$TO$FPGA		

	LXI	D,MSG12			;CR,LF,'Enter Year (00-99) '
	CALL	PSTRING
	CALL	GETHEX
	CALL	DATA$TO$FPGA		

	LXI	D,MSG13			;CR,LF,'Enter Month (01-12) '
	CALL	PSTRING
	CALL	GETHEX
	CALL	DATA$TO$FPGA		

	LXI	D,MSG14			;CR,LF,'Enter Date (01-31) '
	CALL	PSTRING
	CALL	GETHEX
	CALL	DATA$TO$FPGA		
	
	LXI	D,MSG15			;CR,LF,'Enter Hours (00-23) '
	CALL	PSTRING
	CALL	GETHEX
	CALL	DATA$TO$FPGA		

	LXI	D,MSG16			;CR,LF,'Enter Minutes (00-59) '
	CALL	PSTRING
	CALL	GETHEX		
	CALL	DATA$TO$FPGA		
	
	LXI	D,MSG17			;CR,LF,'Enter Seconds (00-59) '
	CALL	PSTRING
	CALL	GETHEX
	CALL	DATA$TO$FPGA		;Data to FPGA Board
	
	CALL	ZCRLF
	CALL	GET$FPGA$TO$S100	;Get CMD$CPMPLETE/ERROR FLAG
	CPI	CMD$COMPLETE		;0F0H, Flag returned by DC board to signal the previous CMD was OK
	JZ	MAINLOOP
					;Can add a timeout loop here later for an abort
	LXI	D,CMD$ERROR		;An error was detected with the last command
	CALL	PSTRING
	JP	MAINLOOP
	

;---------------------------------------- SUBROUTINES ---------------------------------------------------

ZCRLF:
	PUSH	PSW
	PUSH	B
	MVI	C,CR
	CALL	ZCO
	MVI	C,LF
	CALL	ZCO
	POP	B
	POP	PSW
	RET

ZEOL:				;CR and clear current line
	MVI	C,CR
	CALL	ZCO
	MVI	C,CLEAR		;Note hardware dependent, (Use 80 spaces if necessary)
	CALL	ZCO
	RET

ZCSTS:
  IF  CPM
	PUSH	B
	PUSH	D
	PUSH	H
	MVI	C,CONST
	CALL	BDOS		;Returns with 1 in [A] if character at keyboard
	POP	H
	POP	D
	POP	B
	CPI	1
	RET
  ELSE	
	IN	0H		;Get Status in [A]
	ANI	02H
	RZ
	MVI	A,01H
	ORA	A
	RET
  ENDIF
	
 
ZCO:				;Write character that is in [C]
  IF  CPM
	PUSH	PSW
	PUSH	B
	PUSH	D
	PUSH	H
	MOV	E,C
	MVI	C,WRCON
	CALL	BDOS
	POP	H
	POP	D
	POP	B
	POP	PSW
	RET
  ELSE	
	PUSH	PSW	
ZCO1:	IN   	0H		;Show Character
	ANI	04H
	JZ	ZCO1
	MOV	A,C
	OUT	1H
	POP	PSW
	RET
  ENDIF

ZCI:				;Return keyboard character in [A]
  IF CPM
	PUSH	B
	PUSH	D
	PUSH	H
	MVI	C,RDCON
	CALL	BDOS
	POP	H
	POP	D
	POP	B
	RET
  ELSE
ZCI1:	IN	0H		;Get Character in [A]
	ANI	02H
	JZ	ZCI1
	IN	01H
	RET
  ENDIF


;	Print a string in [DE] up to '$'

PSTRING:
 IF CPM
	MVI	C,PRINT
	JMP	BDOS		;PRINT MESSAGE, 
 ELSE
	PUSH	B
	PUSH	D
	PUSH	H
	XCHG
PSTRX:	MOV	A,M
	CPI	'$'
	JZ	DONEP
	MOV	C,A
	CALL	ZCO
	INX	H
	JMP	PSTRX
DONEP:	POP	H
	POP	D
	POP	B
	RET
  ENDIF



;	Print a string in [DE] up to '$' on USB Port

USB$STRING:
	PUSH	B
	PUSH	D
	PUSH	H
	XCHG
USB$PSTRX:
	MOV	A,M
	CPI	'$'
	JZ	DONE$USB
	MOV	C,A
	CALL	USB$CO			;Send character in [C]
	INX	H
	JMP	USB$PSTRX
DONE$USB:
	POP	H
	POP	D
	POP	B
	RET


;	Print a string in [DE] up to '$' on RS232 Serial Port

SERIAL$STRING:
	PUSH	B
	PUSH	D
	PUSH	H
	XCHG
SERIAL$PSTRX:
	MOV	A,M
	CPI	'$'
	JZ	DONE$SERIAL
	MOV	C,A
	CALL	SERIAL$CO			;Send character in [C]
	INX	H
	JMP	SERIAL$PSTRX
DONE$SERIAL:
	POP	H
	POP	D
	POP	B
	RET


;------------------------------------------------------------------
; Print a 16 bit number in RAM located @ [HL] 
; (Note Special Low Byte First. Used only for Drive ID)

printparm:
	INX	H		;Index to high byte first
	MOV	a,M
	CALL	HEXOUT
	DCX	H		;Now low byte
	MOV	a,M
	CALL	HEXOUT
	RET

HHEXOUT:				;No registers altered
	CALL	HEXOUT
	PUSH	PSW
	PUSH	B
	MVI	C,'H'
	CALL	ZCO
	POP	B
	POP	PSW
	RET
	
; Print an 8 bit number, located in [A]
HEXOUT:	PUSH	PSW			;No registers altered
	PUSH	B
	PUSH	PSW
	RRC
	RRC
	RRC
	RRC
	CALL	ZCONV
	POP	PSW
	CALL	ZCONV
	POP	B
	POP	PSW
	RET

ZCONV:	ANI	0FH		;HEX to ASCII and print it
	ADI	90H
	DAA
	ACI	40H
	DAA
	MOV	C,A
	CALL	ZCO
	RET

;DISPLAY BIT PATTERN IN [A]
ZBITS:	PUSH	PSW
	PUSH	B
	PUSH	D
	MOV	E,A		
	MVI	B,8
BBBQ2:	
	DB	0CBH,23H	;Z80 Op code for SLA A,E
	MVI	A,18H
	ADC	A
	MOV	C,A
	CALL	ZCO
	DJNZ	BBBQ2
	POP	D
	POP	B
	POP	PSW
	RET

GETCMD:	CALL	ZCI		;GET A CHARACTER, convert to UC, ECHO it
	CPI	ESC
	RZ			;Don't echo an ESC
	CALL	UPPER
  IF NOT CPM
	PUSH	PSW		;Save it
	PUSH	B
 	MOV	C,A
	CALL	ZCO		;Echo it
	POP	B
	POP	PSW		;get it back
 ENDIF
	RET

				;Convert LC to UC
UPPER:	CPI	'a'		;must be >= lowercase a
	RC			; else go back...
	CPI	'z'+1		;must be <= lowercase z
	RNC			; else go back...
	SUI	'a'-'A'		;subtract lowercase bias
	RET

				;ASCII TO BINARY CONVERSION ROUTINE
ASBIN:	SUI	30H 
	CPI	0AH 
	RM
	SUI	07H 
	RET


GETHEX:
	call	ZCI			;GET A CHARACTER, convert to UC, ECHO it
	call	UPPER
	cpI	ESC
	jz	HEXABORT$NO$ECHO
	cpi	'/'			;check 0-9, A-F
	jc	HEXABORT$NO$ECHO
	cpi	'F'+1
	jnc	HEXABORT$NO$ECHO

IF CPM 
ELSE
	PUSH	B
	PUSH	PSW
	MOV	C,A
	CALL	ZCO
	POP	PSW
	POP	B
ENDIF
	call	ASBIN			;Convert to binary
	rlc				;Shift to high nibble
	rlc
	rlc
	rlc
	MOV	b,A			;Store it
	
	call	ZCI			;GET second CHARACTER, convert to UC, ECHO it
	call	UPPER	
	cpi	ESC
	jz	HEXABORT$NO$ECHO
	CPI	CR
	JZ	ONE$DIGIT
	
	cpi	'/'			;check 0-9, A-F
	jc	HEXABORT$NO$ECHO
	cpi	'F'+1
	jnc	HEXABORT$NO$ECHO
IF CPM 
ELSE
	PUSH	B
	PUSH	PSW
	MOV	C,A
	CALL	ZCO
	POP	PSW
	POP	B
ENDIF
	call	ASBIN			;Convert to binary
	ora	B			;add in the first digit
	ora	A			;To return NC
	ret
HEXABORT$NO$ECHO:
	scf				;Set Carry flag
	ret
;
ONE$DIGIT:				;A CR wase ntered after only 1 digit
	MOV	A,B
	RAR				;Shift to high nibble back down
	RAR
	RAR
	RAR
	ANI	0FH
	ORA	A
	RET


;-----------------------------------------------------------------------------------------------------

DATA$TO$FPGA:				;Send CMD/data to FPGA_DC Z80
	PUSH	PSW
DATA$TO$FPGA1:
	IN	STATUS$BUS$PORT	
	ANI	80H
	JRNZ	DATA$TO$FPGA1		;Wait until bit 7 is 0 
	POP	PSW
	OUT	DATA$BUS$PORT		;This will cause the FPGA_DC board to set the S100$RTS bit
					;(Seems to be required for data to arrive valid on FPGA_DC Board)
DATA$TO$FPGA2:
	IN	STATUS$BUS$PORT	
	ANI	80H
	JRNZ	DATA$TO$FPGA2		;Wait until bit 7 is 0 
	RET				;Ret NZ if error
NO$FPGA$DC
	POP	PSW
	RET
	

GET$FPGA$TO$S100:			;Get data from FPGA
	IN	STATUS$BUS$PORT		;Get S100 Status Port - Bit 0, 1 = FPGA data present, 0, no data present
	ANI	01H			;01H, Bit 0
	JZ	GET$FPGA$TO$S100	;wait for DC Board to present data 
	IN	DATA$BUS$PORT		;Return Data in [A], FPGA "hardware" will lower bit 7 of S100 Bus port 80H
	RET


;--------------------------------------------------------------------------------------------------------

SIGN$ON$CPM:	DB	CR,LF,LF,'Super IO Board Test Program (V1.0) '
		DB	'using CPM3 Console BIOS Routines'
		DB	CR,LF,'Note, SW1 bit 7 must be closed to work with this program.',CR,LF,'$'
		
SIGN$ON$Z80:	DB	CR,LF,LF,'Super IO Board Test Program (V1.0) '
		DB	'using the Z80 Monitor for IO'
		DB	CR,LF,'Note, SW1 bit 7 must be closed to work with this program.',CR,LF,'$'
		

MENU$STRING$:	DB  CR,LF
		DB '(D) DFP Sound Card Test    (F) FX Sound Card Test(R)',CR,LF
		DB '(G) Get 8255A Ports        (H) Set 8255A ports',CR,LF
		DB '(K) PS2 Keyboard Test      (L) Get Date & Time',CR,LF
		DB '(P) Printer Test           (Q) RS232 Loop Test',CR,LF
		DB '(R) RS232 Serial Port Test (S) Speech test ',CR,LF
		DB '(T) USB Port Test          (U) Set Date & Time ',CR,LF
		DB '(W) WiFi Card Test         (ESC) Quit',CR,LF,'$'

MSGERR		DB	CR,LF,'Sorry that was not a valid menu option!',CR,LF,LF,'$'
Prompt:		db	CR,LF,LF,'Please enter command > $'

Read$RTC	DB	CR,LF,'Reading the Time & Date from the SUPER IO Board.$'
MSG20:		DB	CR,LF,'Date = $'
MSG19:		DB	'  Time = $'
Set$RTC		DB	CR,LF,'Set the Time & Date on the SUPER IO Board.$'
MSG12:		DB	CR,LF,'Enter Year (00-99) $'
MSG13:		DB	CR,LF,'Enter Month (01-12) $'
MSG14:		DB	CR,LF,'Enter Date (01-31) $'
MSG15:		DB	CR,LF,'Enter Hours (00-23) $'
MSG16:		DB	CR,LF,'Enter Minutes (00-59) $'
MSG17:		DB	CR,LF,'Enter Seconds (00-59) $'

NO$BOARD$MSG	DB	CR,LF,BELL,'Super IO Board not detected.$'
CMD$ERROR	DB	CR,LF,BELL,'An error was detected with the last SUPER_IO Board Command$'

TEST$PS2$MSG	DB	CR,LF,'Test the PS2 Keyboard input. (P16, P24)'
		DB	CR,LF,'Please enter keyboard characters from the IBM-PC PS2 keyboard.'
		DB	CR,LF,'They should appear on your Console IO Port. '
		DB	      'Enter ESC to abort.',CR,LF,LF,'$'

TEST$USB$MSG	DB	CR,LF,'Test the USB Port. (P40)'
		DB	CR,LF,'Please enter keyboard chars FROM THE PC TERMINAL '
		DB            'connected to the USB port.'
		DB	CR,LF,'They should echo back on the PC terminal (and S100 Console). '
		DB	CR,LF,'Enter ESC to abort.',CR,LF,LF,'$'

DONE$USB$MSG	DB	CR,LF,'Test of the USB Port finished.',CR,LF,'$'

LOOP$RS232$MSG	DB	CR,LF,'RS232 loop test. Enter ESC to abort.',CR,LF,LF,'$'

TEST$RS232$MSG	DB	CR,LF,'Test the RS232 Port. (P17, J1)'
		DB	CR,LF,'Please enter keyboard characters from the S100 bus Console'
		DB	CR,LF,'They will be sent to the RS232 Port Rx pin. The loop around '
		DB	CR,LF,'RS232 Port Tx pin will return the character and display it here.'
		DB	CR,LF,'Enter ESC to abort.',CR,LF,LF,'$'
	
DONE$SERIAL$MSG	DB	CR,LF,'Test of the Serial Port finished.',CR,LF,'$'

TEST$PRN$MSG	DB	CR,LF,'Send the following test string to the Printer port:-',CR,LF,'$'

PRINTER$STRING	DB	CR,LF,'This is a test string being sent to the printer '
		DB	      'port on the Super IO Board'
		DB	CR,LF,'Second line, 0123456789,  ABCDEF,  abcdef'
		DB	CR,LF,'Third line,  terminating string',0
		

ADAFRUIT$FX$MENU
		DB	CR,LF,LF,'AdaFruit FX Sound card Menu.',CR,LF,LF
		DB	'(0) Reset the FX Sound Card',CR,LF
		DB	'(1) List All Files',CR,LF
		DB	'(2) Play File #',CR,LF
		DB	'(3) Increase Volume',CR,LF
		DB	'(4) Decrease Volume',CR,LF
		DB	'(5) Pause Playing',CR,LF
		DB	'(6) Resume Playing',CR,LF
		DB	'(7) Stop Playing',CR,LF
		DB	'(8) Play Filename',CR,LF
		DB	CR,LF,'Enter a menu option. ESC to abort to main Menu.',CR,LF,LF,'$'

NO$ADAFRUIT$FX$CARD DB	CR,LF,BELL,'No AdaFruit FX card detected. (Or RST pin in low, try again).',CR,LF,'$'
BAD$CMD		DB	CR,LF,BELL,'Invalid menu option.$'
ENTER$FILE$NO	DB	CR,LF,'Please enter the Track Number (XX+CR):$'

FX$UP$VOLUME	DB	CR,LF,'Volume Increased$'
FX$DOWN$VOLUME	DB	CR,LF,'Volume Decreased$'
FX$PAUSE$MSG	DB	CR,LF,'Pause Playback$'
FX$RESUME$MSG	DB	CR,LF,'Resume Playback$'
FX$STOP$MSG	DB	CR,LF,'Stop Playback$'
FX$ENTER$NAME	DB	CR,LF,'Enter File name (In XXXXXXXX.XXX Format):$'
FX$GOT$NAME	DB	CR,LF,'Will play the following file: $'


DFP$SOUND$MENU
		DB	CR,LF,LF,'DFP SD Card Sound Menu.',CR,LF
		DB	'Read SD card on a PC to display the sound files present',CR,LF,LF
		DB	'(0) Play File #',CR,LF
		DB	'(1) Set Sound Volume',CR,LF
		DB	'(2) Continously play current track',CR,LF
		DB	'(3) Pause Playing',CR,LF
		DB	'(4) Play or Resume playing current track',CR,LF
		DB	'(5) Continously play all tracks',CR,LF
		DB	'(6) Stop Playing',CR,LF
		DB	'(7) Send Byte to Port 8AH',CR,LF
		DB	CR,LF,'Enter a menu option. ESC to abort to main Menu.',CR,LF,LF,'$'

NO$DFP$CARD	DB	CR,LF,BELL,'No DFP Sound Card detected',CR,LF,'$'

DFP$FILE$NUMBER DB	CR,LF,'Please enter the File Number (XX+CR):$'
SENDING$CMD	DB	CR,LF,'Sending the following Command:- $'
GOT$BACK	DB	CR,LF,'The DFP Player returned:- $'
DFP$BYTE$VALUE	DB	CR,LF,'Please enter a value to send to port 8AH (XX+CR):$'

DFP$ENTER$VOLUME DB	CR,LF,'Please enter the desired Volume Number (00-30+CR):$'
DFP$REPEAT$MSG	DB	CR,LF,'Will continously play the current track.$'
DFP$PAUSE$MSG	DB	CR,LF,'Will pause play of the current track.$'
DFP$PLAY$MSG	DB	CR,LF,'Will play of the current track.$'
DFP$PLAY$ALL$MSG DB	CR,LF,'Will continously play all tracks.$'
DFP$RESET$MSG	DB	CR,LF,'Will reset the DFP Player.$'
DFP$QUERY$MSG	DB	CR,LF,'Will query the DFP Player.$'



WIFI$MENU
		DB	CR,LF,LF,'WiFi ESP8266 Card Menu.',CR,LF,LF
		DB	'(0) Simple WiFi port Echo Test',CR,LF
		DB	'(1) Initilize WiFi Card',CR,LF
		DB	'(2) Send AT+CWMODE=? Command, (View Options Mode)',CR,LF
		DB	'(3) Send AT+GMR Command, (Get Firmware Version)',CR,LF
		DB	'(4) Send AT+CWMODE=1 Command, (Set Mode)',CR,LF
		DB	'(5) Send AT+CWLAP Command, (Get Networks)',CR,LF
		DB	'(6) Send AT+CIFSR Command, (Get IP Address)',CR,LF
		DB	CR,LF,'Enter a menu option. ESC to abort to main Menu.',CR,LF,LF,'$'

ECHO$WIFI$MSG	DB	CR,LF,'0.  Echo test of serial port on the WIFI card.'
		DB	CR,LF,'Please enter keyboard characters. (ESC to abort).$'
RESET$WIFI$MSG	DB	CR,LF,'1.  Will initilize ESP8266 WiFi card by pulsing RST low.$'

OK$WIFI$MSG0	DB	'2.  Will send AT+CWMODE=? Command (View Options). '
		DB	CR,LF,'Enter ESC to return to WiFi Menu.',CR,LF,LF,'$'
OK$WIFI$MSG1	DB	'3.  Will send AT+GMR Command (Get Firmware Version).  '
		DB	CR,LF,'Enter ESC to return to WiFi Menu',CR,LF,LF,'$'
OK$WIFI$MSG2	DB	'4.  Will send AT+CWMODE=1 Command (Set Mode).  '
		DB	CR,LF,'Enter ESC to return to WiFi Menu',CR,LF,LF,'$'
OK$WIFI$MSG3	DB	'5.  Will send AT+CWLAP Command (Get Networks). '
		DB	CR,LF,'Enter ESC to return to WiFi Menu',CR,LF,LF,'$'
OK$WIFI$MSG4	DB	'6.  Will send AT+CIFSR Command (Get IP Add.). '
		DB	CR,LF,'Enter ESC to return to WiFi Menu',CR,LF,LF,'$'

AT$WIFI$MSG2	DB	'AT+CWMODE=?',CR,LF,'$'
AT$WIFI$MSG3	DB	'AT+GMR',CR,LF,'$'
AT$WIFI$MSG4	DB	'AT+CWMODE=1',CR,LF,'$'
AT$WIFI$MSG5	DB	'AT+CWLAP',CR,LF,'$'
AT$WIFI$MSG6	DB	'AT+CIFSR',CR,LF,'$'

TEST$SPEECH$MSG		DB	CR,LF,'Sending the following string to '
			DB	'the speaker V-STAMP module.'
			DB	CR,LF,'This is a test. 12345678'
			DB	CR,LF,'Enter CR to start test.$'
SPEECH$STRING		DB	'This is a test. 12345678$'

P$SEND$MSG	DB	CR,LF,'Send data to 8255A ports A, B & C.$'
P$SENDA$MSG	DB	CR,LF,'Enter 8255A Port A (XXH):$'
P$SENDB$MSG	DB	CR,LF,'Enter 8255A Port B (XXH):$'
P$SENDC$MSG	DB	CR,LF,'Enter 8255A Port C (XXH):$'
OUT$RESULT$MSG	DB	CR,LF,LF,'8255A Ports    A           B              C$'
OUT$RESULT1$MSG DB	CR,LF,'           $'
OUT$RESULT2$MSG	DB	'    $'
OUT$RESULT3$MSG	DB	'       $'

P$GET$MSG	DB	CR,LF,'Get data from 8255A ports A, B & C.$'
		
STATUS$COUNT	DW	0H
FX$FILE$NO	DB	0H
FX$BUFFER	DB	'        '	;8 SPACES
FX$BUFFER$EXT	DB	'   '		;3 spaces

DFP$VARIABLE	   DB	0H
DFP$VARIABLE$HIGH  DB	0H
DFP$CURRENT$TRACK  DB	0H

PORT$A$STORE	DB	0H
PORT$B$STORE	DB	0H
PORT$C$STORE	DB	0H
LOOP$COUNT	DB	0H
 


				;DFP Player Commands
FILE$NUMBER$CMD		DB	07EH,0FFH,06H,03H,00H,00H
DFP$VOLUME$CMD		DB	07EH,0FFH,06H,06H,00H,00H
DFP$REPEAT$CMD		DB	07EH,0FFH,06H,08H,00H,00H
DFP$PAUSE$CMD		DB	07EH,0FFH,06H,0EH,00H,00H
DFP$PLAY$CMD		DB	07EH,0FFH,06H,0DH,00H,00H
DFP$RESET$CMD		DB	07EH,0FFH,06H,0CH,00H,00H
DFP$ALL$PLAY$CMD	DB	07EH,0FFH,06H,11H,00H,00H
DFP$QUERY$VOL$CMD	DB	07EH,0FFH,06H,42H,00H,00H

			DB	0


		DS	300H
	
STACK:			DW	0H
			DB	'<--End of SIO_DIAG Code           '
