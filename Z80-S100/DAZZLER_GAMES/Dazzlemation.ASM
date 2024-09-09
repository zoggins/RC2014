; Hand disassembly of the Dazzlemation memory image provided in the
; original 14 page Dazzlemation manual.
;
; This code was originally conceived and composed by:
;
; --------------------------------------------------------------------
; -----------------------Steve Dompier--------------------------------
; --------------------------------------------------------------------
;
; This disassembly, analysis and documation of the memory image was
; produced by Bill Sudbrink in April 2016.
;
; When assembled with the CP/M 2.2 assembler program, this file will
; produce the memory image printed in the manual.

; port to read the front panel switches
SWITPORT	EQU	0FFH

; THESE VALUES ARE ORIGINAL AND WORK WITH THE CONSOLE PORT ON A CROMEMCO
; FDC SERIES FLOPPY CONTROLLER:
; port to read and write bytes to and from the console serial port

DATAPORT	EQU	01H
				; port to check the status of the console serial port
STATPORT	EQU	00H
STATRXOK	EQU	40H
STATTXOK	EQU	80H

; THESE VALUES WORK WITH A MITS 2-SIO SERIAL CARD CONFIGURED FOR MITS
; PROM MONITOR
; DATAPORT	EQU	11H
; STATPORT	EQU	10H
; STATRXOK	EQU	01H
; STATTXOK	EQU	02H


; The original console device was apparently intended to be a teletype
; with an even parity keyboard.  In that case, crtl-Z comes in as:
CTRLZ	EQU	9AH

; If you want the original image, use the above.  If you want control Z
; to work, use:
; CTRLZ	EQU	1AH


	ORG 0

	JMP START

; DATA

COORDS:				; cursor X,Y coordinates
	DB	1FH		; initialized to (0x1f, 0x1f) and set again in start to position
	DB	1FH		;   the cursor at the middle of the screen
CUSORDAT:			; two byte data initialized to 0x00aa and set again in start
	DB	00H		; this byte apparently unused
CURONSCR:			; rotated to indicate cursor status.
	DB	0AAH		; when low bit is set, cursor is on screen.  binary value 10101010
COLOR:
	DB	05H		; color value to paint, combined with intensity
INTENS:
	DB	08H		; intensity control byte, combined with color
YCURMOT:
	DB	00H		; Y cursor motion
XCURMOT:
	DB	00H		; X cursor motion
CFLSHFLG:
	DB	00H		; stop cursor flash flag... non-sero if cursor not flashing
CUROFFFLG:
	DB	00H		; cursor off flag (non-zero if cursor is off)
RUNFLG:
	DB	00H		; animation run flag... one - run, anything else - stop
CMDBUFP: 			; command buffer pointer
	DB	00H		; pointer to 0x1800.  command characters stored there
	DB	18H		; incremented as characters are stored.

; functions

; jumped to by dot and comma functions
XSETMOTION:
	MVI	L,00H		; no Y
	MOV	H,A		; only X
	JMP	STORMOTNMOV	; jump to store motion and move the cursor

; jumped to by M and N functions
YSETMOTION:
	MVI	H,00H		; no X
	MOV L,A			; only Y

; store the new motion and move the cursor
STORMOTNMOV:
	SHLD	YCURMOT		; store cursor motion
MOVNOSTORE:			; jump here from semi-colon function
	LHLD COORDS		; cursor coordinates in HL
	MOV B,H	; move to BC
	MOV C,L
	JMP ADJCUR

; seems dead
	DB	00H, 00H, 00H, 00H

; point HL to 0x0001 (called via rst 5)
	LXI	H,0001H
	RET

; seems dead
	DB	00H, 00H, 00H, 00H

; set run flag (called via rst 6)
	MVI	A,01H
	STA	RUNFLG
	JMP SWTDLY

; go into tight loop (called via rst 7) seems dead
TGHTLOOP:
	JMP	TGHTLOOP

; seems dead
	DB	00H, 00H, 00H, 00H, 00H

; toggle cursor while preserve HL... seems to be dead (never called)
	PUSH	H
	CALL	TGLCURSOR
	POP	H
	RET

; seems dead
	DB	00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H
	DB	00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H
	DB	00H, 00H

PROCESS:
	JMP	CHECKRUN
NOTRUNNING:
	CPI	00H		; we jump back here if the run flag (RUNFLG) is not 1...
				; Register A contains cursor off flag (CUROFFFLG)
	JNZ SKIPCUR		; skip cursor call if cursor off flag is non-zero
	CALL	TGLCURSOR
SKIPCUR:
	LXI	D,0C800H	; DE used as loop count.  loop until wrap to zero, 37ff times
NOFLSHLOOP:
	IN	STATPORT	; check data port status
	ANI	STATRXOK	; is a byte available?
	JNZ	GETKEY		; jump if byte available
	LDA	CFLSHFLG	; test cursor flash flag
	CPI	00H		; for zero
	JNZ	NOFLSHLOOP	; tight loop if not flashing (noflshloop)
	INX	D		; increment counter
	MOV	A,D		; see if we wrapped
	CPI	00H
	JNZ NOFLSHLOOP		; loop back to test for byte available
	JMP	PROCESS		; loop back to start which flashes cursor

; seems dead
	DB	00H

; toggle cursor routine... put a 'T' around the cursor position...
; uses XOR so every other call "turns off" the cursor
TGLCURSOR:
	LHLD	COORDS		; cursor X,Y into HL
	MOV	A,L		; Y in a
	SUI	02H		; decrement by 2
	NOP
	NOP
	NOP
	MOV	C,A		; move to C 
	MOV	B,H		; X to B ... BC cursor X,Y with Y adjusted by two
	CALL	XORPIXVAL
	MOV	A,C
	ADI	04H		; adjust Y again - line 383
	NOP
	NOP
	NOP
	MOV	C,A
	CALL	XORPIXVAL
	LHLD	COORDS		; get original cursor again
	MOV	A,H
	SUI	02H		; adjust X
	NOP
	NOP
	NOP
	MOV	B,A
	MOV	C,L		; reload Y
	CALL	XORPIXVAL
	MOV	A,B
	ADI	04H		; adjust X again
	NOP
	NOP
	NOP
	MOV	B,A
	CALL	XORPIXVAL
	LDA	CURONSCR	; rotate cursor status byte
	RRC
	STA	CURONSCR
	RET

; xor a pixel with 0x0f
XORPIXVAL:
	CALL	GETPIXVAL
	XRI	0FH		; xor it with 0x0f to make it flash
	CALL	SETPIXVAL
	RET

; test run flag and return cursor flag in A if not running
CHECKRUN:
	LDA	RUNFLG		; get the run flag
	CPI	01H		; test against one
	JZ	RUNNING		; if one, we're running
	LDA	CUROFFFLG	; get the cursor flag
	JMP	NOTRUNNING

; seems dead
	DB	00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H
	DB	00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H
	DB	00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H
	DB	00H

; get pixel value at X,Y into A, coordinates come in in BC
GETPIXVAL:
	CALL	GETPIXADDR	; convert pixel coordinate in BC to HL pointer into dazzler buffer
						; carry bit indicates which four bits of byte to use
	MOV	A,M		; get both pixels
	JC	GETHIGH		; if carry, get the high bits
	ANI	0FH		; mask off high bits
	RET
GETHIGH:
	ANI	0F0H		; mask off low bits
	RLC			; rotate the high bits low
	RLC
	RLC
	RLC
	RET

; seven bytes of 0x01 seems dead
	DB	01H, 01H, 01H, 01H, 01H, 01H, 01H

; convert X,Y coordinates in BC to HL pointer into dazzler buffer at 0x1000
; carry bit indicates which half-byte to use
; does not change B or C
GETPIXADDR:
	LXI	H,1000H		; HL point to start of buffer
	MOV	A,B		; get X
	RAL
	RAL
	RAL
	JNC	SKP200		; see if X is 20 or greater
	LXI	D,0200H		; if it is...
	DAD	D		; increment HL by 0x0200
SKP200:
	MOV	A,C		; get Y
	RAL
	RAL
	RAL
	JNC	SKP400		; see if Y is 20 or greater
	LXI	D,0400H		; if it is...
	DAD	D		; increment HL by 0x0400
SKP400:
	MOV	A,C		; get Y again
	ANI	1FH		; clear out high three bits
	RLC
	RLC
	RLC			; low three bits are now zero
	RAL			; all four low bits are now zero
	MOV	E,A		; store Y in E
	MVI	A,00H		; preserved carry bit so that ...
	RAL			; a is now one
	MOV	D,A		; DE is now 0x01?0 with ? being the four bits preserved from C above
	DAD	D		; add it to HL - carry should always be clear
	MOV	A,B		; get X again
	RAR			; divide by two with even/odd bit in carry (high or low half-byte)
	PUSH	PSW
	NOP
	ANI	0FH		; low four bits of X/2
	MOV	E,A
	MVI	D,00H
	DAD	D		; I'm sure this must work, but I need to sit down with pencil and paper...
	POP	PSW
	RET

; seems dead
	DB	00H, 00H, 00H, 00H, 00H, 00H

; SETPIXVAL ... pixel value in A and coordinates in BC
SETPIXVAL:
	ANI	0FH		; everybody does this... but just to be sure, I guess
	PUSH	PSW		; pushes A and flags
	CALL	GETPIXADDR
	POP	D		; pops D and E (presumably A is now in D)
	JC	SPTOP4		; if carry, set the top four bits
; pixel value in low four bits...
	MOV	A,M		; get current value (two pixels)
	ANI	0F0H		; clear old value
	ADD	D		; add new value
	MOV	M,A		; set new value
	RET
; pixel value in top four bits...
SPTOP4:
	MOV	A,D		; shift new value where we need it
	RLC
	RLC
	RLC
	RLC
	MOV	D,A
	MOV	A,M		; get current value (two pixels)
	ANI	0FH		; clear old value - line 575 ok
	ADD	D		; add new value
	MOV	M,A		; set new value
	RET

; seems dead
	DB	00H, 00H, 00H, 00H

; L function continued
LOWINT:
	MVI	A,00H		; clear intensity
	STA	INTENS
	JMP	DOCURRENT

; H function continued
HIGHINT:
	MVI	A,08H		; set intensity
	STA	INTENS
	JMP	DOCURRENT

; seems dead
	LXI	H,1000H
	XRA	A
	MOV	M,A
	INX	H
	MOV	A,H
	CPI	18H
	DB	0C2H

; color key decode table, referenced below
CLRKEYTBL:
	DB	7FH		; <DEL>, <RUBOUT> - black
	DB	52H		; R               - red
	DB	47H		; G               - green
	DB	59H		; Y               - yellow (red and green)
	DB	42H		; B               - blue
	DB	50H		; P               - purple (red and blue)
	DB	43H		; C               - cyan (green and blue)
	DB	57H		; W               - white (red, green and blue)
	DB	0FFH		; end of table

; seems dead
	DB	00H, 00H, 00H, 00H, 00H

; called if RX data is available on the console port
GETKEY:
	LDA	CURONSCR
	RRC
	CC	TGLCURSOR	; if the cursor is on screen, clear it
	CALL	GETPORTBYTE	; get the keystroke and store it if not "special"

; the recording runner jumps in here with a recorded character
PROCCHAR:
	MOV	A,B		; incoming keystroke in B, move it to A
	CPI	20H		; check for space character
	JZ	DOCURRENT	; if space key, repeat last action
	LXI	H,CLRKEYTBL	; see if the incoming character is a color key
	NOP
	LXI	D,0FFFFH
PCLOOP1:
	INR	E		; first time, E to 0x00
	MOV	A,B		; get keystroke into A
	NOP
	NOP
	NOP
	CMP	M		; check if it is in the color table
	JZ	COLORKEY	; if it is in the table, decode the color
	MOV	A,M
	CPI	0FFH		; check for end of table
	JZ	FUNCCHAR	; if end of table, did not find the key, check for function key
	INX	H		; not end of table, check next
	JMP	PCLOOP1

; keystroke interpreted as color
COLORKEY:
	MOV	A,E		; get table index in A
	NOP			; no ops for timing maybe?
	NOP
	NOP
	NOP
	NOP
	STA	COLOR		; store table index in color
	NOP			; more nop timing?
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
; drop into DOCURRENT, below

; called after <H key>, <L key> and </ key> processing
; or if keystroke detected available on port
; set the current color at the current cursor coordinates and fall
; through to move the cursor coordinates using the current motion
; XY (lotsa current)
DOCURRENT:
	LHLD	COORDS		; cursor X,Y in HL
	MOV	B,H		; cursor X,Y in BC
	MOV	C,L
	NOP
	LHLD	COLOR		; color and intensity in HL
	MOV	A,H		; combine
	ADD	L
	NOP			; more timing?
	NOP
	NOP
	NOP
	CALL	SETPIXVAL
; drop into ADJCUR, below

; motion functions (N, M, dot and comma) jump here
; adjust the cursor position currently in BC with the current motion values and then store it
ADJCUR:
	LHLD	YCURMOT		; load the current X and Y motion values
	MOV	A,H		; adjust cursor coordinates
	ADD	B
	MOV	H,A
	MOV	A,L
	ADD	C
	MOV	L,A
	SHLD	COORDS		; store new cursor position
	CALL	CHKCURPOS	; check for coordinates out of bounds, wrap them
	JMP	PROCESS		; go back for another RX byte or command buffer byte

; jumped to by rst 6 (set run flag)
; delays via sense switches
SWTDLY:
	LXI	D,0000H
	IN	SWITPORT	; get sense switches
	MOV	D,A		; the more switches, the shorter the delay (or do sense switches give zero bits when on?)
DLYLOOP1:
	INX	D
	MOV	A,D
	CPI	0FFH		; test for end of delay
	RZ			; return if end of delay (returning from rst 6)
	JMP	DLYLOOP1

; looks like another keystroke decode table, but seems dead
	DB	7FH
	DB	52H
	DB	47H
	DB	59H
	DB	42H
	DB	50H
	DB	43H
	DB	57H
	DB	2EH
	DB	2CH
	DB	4DH
	DB	4EH
	DB	2FH
	DB	1BH

; initialize things and then jump to keystroke processing
START:
	LXI	SP,0FFFH	; stack down from 0x0fff
	MVI	A,88H		; dazzler setup, on, start address 0x1000
	OUT	0EH
	MVI	A,30H		; dazzler setup, format 2K color (64x64)
	OUT	0FH
	LXI	H,1F1FH		; set cursor to middle of the screen (0x1f,0x1f)
	SHLD	COORDS
	LXI	H,0AA00H	; set blink control
	SHLD	CUSORDAT
	LXI	H,1800H		; initialize command buffer pointer to 0x1800
	SHLD	CMDBUFP
	LXI	H,YCURMOT	; zero bytes from YCURMOT to CUROFFFLG
STCLRLOOP:
	XRA	A		; zero A
	MOV	M,A		; put a zero at HL
	INX	H		; increment HL
	MOV	A,L		; test L for...
	CPI	0DH		; 0x0D (RUNFLG) ... doesn't actually clear RUNFLG, why not?
	JNZ	STCLRLOOP
	CALL	CLEARBUF
	JMP	PROCESS		; start looking for keystrokes
	NOP

; clear the buffer starting at 0x1000... may clear all the way up
; to 0x1FFF or may be hacked to stop at 0x17FF
CLEARBUF:
	LXI	H,1000H
CLRBUFLOOP:
	XRA	A		; zero out A
	MOV	M,A		; move zero to [HL]
	INX	H		; increment HL
	MOV	A,H		; compare high address...
CLRBUFCMP:			; NOTE: this label is used to hack end point by the code below
	CPI	20H		; compare high address to 0x20 (or may be hacked to 0x18
	JNZ	CLRBUFLOOP
	RET

; seems dead
	DB	00H, 00H, 00H

; interpret character in B, not color key, look for function characters
FUNCCHAR:
	LXI	H,JUMPMTCHTBL	; point to character match table
	LXI	D,1580H		; DE set to 0x1580 D is the table length
				;                  E is address table low address byte
CHKNXT:
	MOV	A,B		; get character
	CMP	m		; compare to table
	JZ	TBLMATCH	; got a match? yes? jump to TBLMATCH
	INX	H		; no? try the next one
	DCR	D		; keep track of the count
	JZ	PROCESS		; out of table entries? jump back to get another key
	INR	E		; increment address table low address byte
	JMP	CHKNXT		; check next entry

TBLMATCH:
	MOV	L,E		; get low byte of function address
	MOV	L,M
	INR	H		; function address high byte is always 0x03
	PCHL			; jump to function

; seems dead
	NOP
	LHLD	COORDS
	MOV	B,H
	MOV	C,L
	JMP	ADJCUR

; seems dead
	JMP	GETPIXADDR
	NOP
	NOP
	NOP
	NOP

; start of jump table compare targets. 0x15 in length (21 decimal)
JUMPMTCHTBL:
	DB	2EH		; dot, period
	DB	2CH		; comma
	DB	4DH		; M
	DB	4EH		; N
	DB	2FH		; /
	DB	11H		; <DC1><ctrl-Q>
	DB	3BH		; <semi-colon>
	DB	3EH		; <greater than>
	DB	3CH		; <less than>
	DB	5DH		; <right square bracket>
	DB	5EH		; <caret>
	DB	4CH		; L
	DB	48H		; H
	DB	03H		; <ETX><ctrl-C>
	DB	02H		; <STX><ctrl-B>
	DB	10H		; <DLE><ctrl-P>
	DB	40H		; <at sign>
	DB	1BH		; <escape>
	DB	12H		; <DC2><ctrl-R>
	DB	13H		; <DC3><ctrl-S>
	DB	00H		; <NUL> ?? test against null ??
; left over/unused
	DB	00H, 00H, 00H

; low bytes for target function addresses
FUNCLADDR:			; label is never directly addressed, accessed by math above
	DB	00H		; dot function at 0x0300
	DB	05H		; comma function at 0x0305
	DB	0AH		; M function at 0x030a
	DB	0FH		; N function at 0x030f
	DB	14H		; / function at 0x0314
	DB	1DH		; <DC1><ctrl-Q> function at 0x031d
	DB	0EDH		; <semi-colon> function at 0x03ed
	DB	23H		; <greater than> function at 0x0323
	DB	2BH		; <less than> function at 0x032b
	DB	33H		; <right square bracket> function at 0x0333
	DB	3BH		; <caret> function at 0x033b
	DB	43H		; L function at 0x0343
	DB	46H		; H function at 0x0346
	DB	50H		; <ETX><ctrl-C> function at 0x0350
	DB	5AH		; <STX><ctrl-B> function at 0x035a
	DB	0C0H		; <DLE><ctrl-P> function at 0x03c0
	DB	8BH		; <at sign> function at 0x038b
	DB	98H		; <escape> function at 0x0398
RUNTBLENT:			; this byte is modified by code below
	DB	0AFH		; <DC2><ctrl-R> function at 0x03af
	DB	0A8H		; <DC3><ctrl-S> function at 0x03a8
	DB	0A5H		; <NUL> function at 0x03a5
				; left over/unused... seems dead
	DB	00H, 00H, 00H, 00H, 07H, 00H, 00H, 00H
	DB	00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H
	DB	00H, 00H, 00H, 70H, 01H, 50H, 00H, 50H
	DB	00H, 30H, 01H, 08H, 00H, 90H, 00H, 00H
	DB	09H, 00H, 00H, 30H, 05H, 00H, 05H, 00H
	DB	05H, 30H, 01H, 00H, 00H, 60H

; check the cursor position for wrapping
; called from adjcur
CHKCURPOS:
	LHLD	COORDS		; load cursor X,Y into HL
RECHECK:			; jumps here to recheck after a top/bottom wrap
	MOV	A,H		; get X
	ANI	0C0H		; see if X wrapped (range is 0 to 63... 0x00 to 0x3f)
	JZ	CHECKY		; no wrap? then jump to check Y
	RAL			; see if we wrapped left or right
	JNC	WRPRIGHT	; did we wrap left? no? then jump to wrap right handling
	MVI	H,3FH		; we wrapped off of the left so go to right (63 or 0x3f)
	DCR	L		; decrease Y (go up a line)
	JMP	CHECKY
WRPRIGHT:			; we srapped off of the right side so...
	MVI	H,00H		; move to left side, X=0
	INR	L		; down a line, increase Y
	NOP
	NOP
	NOP
CHECKY:				; X is correct when we get here, check Y now
	MOV	A,L		; get Y
	ANI	0C0H		; see if Y wrapped (range is 0 to 63... 0x00 to 0x3f)
	JZ	CHKDONE		; no wrap? store it and done
	RAL			; see if we wrapped top or bottom
	JNC	WRPBTM		; did we wrap top? no? then jump to bottom wrap handling
	MVI	L,3FH		; we wrapped off of the top, so go to the bottom
	DCR	H		; and move one left
	JMP	RECHECK
WRPBTM:
	MVI	L,00H		; we wrapped off of the bottom, so go to the top
	INR	H		; and move one right
	JMP	RECHECK
CHKDONE:
	SHLD	COORDS		; coordinates ok, store them and...
	RET	; return

; seems dead
	ADI	02H
	MVI	L,3FH
	DCR	H
	JMP	RECHECK
	NOP
	NOP

; FUNCTION TABLE TARGETS
; NOTE that the addresses that these functions end up at must match the
; jump table above.  Gotta figure out how to fill that table from labels...

; dot function
	MVI	A,01H
	JMP	XSETMOTION

; comma function
	MVI	A,0FFH
	JMP	XSETMOTION

; M function
	MVI	A,01H
	JMP	YSETMOTION

; N function
	MVI	A,0FFH
	JMP	YSETMOTION

; / function (clears cursor motion)
	LXI	H,0000H
	SHLD	YCURMOT		; zero out X and Y motion
	JMP	DOCURRENT

; <DC1><ctrl-Q> function
	JMP	0000H		; restart the whole thing

; seems dead
	DB	00H, 00H, 00H

; the "store" functions, when combined with another motion
; key, result in diagonal motion.

; <greater than> function (store right)
	MVI	A,01H
	STA	XCURMOT
	JMP	PROCESS

; <less than> function (store left)
	MVI	A,0FFH
	STA	XCURMOT
	JMP	PROCESS

; <right square bracket> (<shift-M on TTY) function (store down)
	MVI	A,01H
	STA	YCURMOT
	JMP	PROCESS

; <caret> (<shift-N> on TTY) function (store up)
	MVI	A,0FFH
	STA	YCURMOT
	JMP	PROCESS

; L function (low intensity)
	JMP	LOWINT

; H function (high intensity)
	JMP	HIGHINT

; seems dead
	DB	00H, 00H, 00H, 00H, 00H, 00H, 00H

; <ETX><ctrl-C> function (toggle hide cursor)
	LDA	CUROFFFLG
	CMA
	STA	CUROFFFLG
	JMP	PROCESS

; <STX><ctrl-B> function (toggle cursor flashing)
	LDA	CFLSHFLG
	CMA
	STA	CFLSHFLG
	JMP	PROCESS

; output 0x20 characters stored at 0x0001 (zero or NUL bytes)
; used by <at sign><SHIFT-P> (punch animation)
NULOUT:
	MVI	D,20H
	RST	5		; sets HL to 0x0001
NOLOOP:
	CALL	CHAROUT
	DCR	D
	JNZ	NOLOOP
	NOP
	RET

; continuation of <at sign>
BUFOUT:
	LXI	H,1800H		; output characters stored at 0x1800 until...
BOLOOP1:
	NOP
	CALL	CHAROUT
	CPI	13H
	JZ	OUTDONE		; you hit 0x13, the stop character <ctrl-S>
	INX	H
	JMP	BOLOOP1

; output one character pointed to by HL when the port is ready
; character is left in A, HL NOT MODIFIED
; used by <at sign>
CHAROUT:
	IN	STATPORT	; port status
	ANI	STATTXOK	; ready bit
	JZ	CHAROUT		; loop until port is ready
	MOV	A,M		; get the character
	OUT	01H
	RET

; <at sign> (or <SHIFT-P> on a teletype) function entry point (punch animation)
	CALL	NULOUT
	JMP	BUFOUT

; finish up of <at sign>
OUTDONE:
	CALL	NULOUT
	JMP	PROCESS
	NOP

; <escape> function (clear the screen only)
; NOTE: this hacks the end test in the CLEARBUF function to make it stop before the command buffer
	MVI	A,18H		; stop at high address 0x18 instead of 0x20
	STA	CLRBUFCMP+1
	CALL CLEARBUF
	MVI	A,20H		; restore to 0x20
	STA	CLRBUFCMP+1

; <escape> drops into <NUL> (or <NUL> jumps into <escape>)
; <NUL> function
	JMP	PROCESS

; <DC3><ctrl-S> function (stop animation)
	XRA	A		; clear run flag
	STA	RUNFLG
	JMP	JTBLUNHACK

; <DC2><ctrl-R> function (start animation)
	LXI	H,17FFH		; one before the command buffer start
	SHLD	CMDBUFP

; if run flag (0x000d) is one, we come here
RUNNING:
	RST	6		; call set run flag and delay via sense switches
	NOP
	NOP
	JMP	MORERUN

RUN2:
	INX	H		; increment command pointer in HL
	MOV	B,M		; put recorded character in b
	JMP	INSRT1

; <DLE><ctrl-P> function (output everything starting at zero  --LOOK OUT-- get ready to reset)
	LXI	H,0000H
CPWAIT:
	IN	STATPORT	; port status
	ANI	STATTXOK	; ready bit
	JZ	CPWAIT
	MOV	A,M
	OUT	01H
	INX	H
	JMP	CPWAIT

; get a character
GETPORTBYTE:
	LXI	H,GPBTABLE	; data area below...
	IN	DATAPORT	; get the character
	ANI	7FH		; clear the high bit
	MOV	B,A		; move it to b
GPBLOOP:
	INX	H		; increment the data pointer
	MOV	A,B
	CMP	M
	RZ			; if it is a character in our table, return right here don't store it
	MOV	A,M		; get the table value so we can... - line 1229 ok
	CPI	0FFH		; check for the end of the table
	JNZ	GPBLOOP		; not the end? loop back and check the next value
	MOV	A,B		; if we're here, it's not in the table...
	LHLD	CMDBUFP		; store it to the command buffer pointer
	MOV	M,A
	INX	H		; increment the pointer
	SHLD	CMDBUFP		; store the incremented pointer (cmdbufp)
	RET

; <semi-colon> function (just move in the same direction, no pixel change)
	JMP	MOVNOSTORE

; compare table (don't store these bytes)
GPBTABLE:
	DB	03H
	DB	02H
	DB	10H
	DB	40H
	DB	11H
	DB	00H
	DB	0FFH		; end of table marker (see above)

; seems dead
	DB	00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H
	DB	00H

INSRT1:
	SHLD	CMDBUFP		; store HL to cmdbufp
	JMP	PROCCHAR

MORERUN:
	LHLD	CMDBUFP	; command buffer pointer in HL (cmdbufp)
	IN	DATAPORT	; just get a character, regardless of port status
	CPI	11H		; see if we got a <DC1><ctrl-Q>
	JNZ	CHECKCZ		; no? check for next special character
	MVI	A,00H		; clear the run flag
	STA	RUNFLG
	JMP	0000H		; reset everything and start over
CHECKCZ:
	CPI	CTRLZ		; see if we got a 0x1A <ctrl-Z>?
				; written assuming an even parity TTY so high bit is set
	JNZ	CHECK18		; no, jump to check18
	MVI	A,00H		; clear the run flag
	STA	RUNFLG
	JMP	PROCESS		; jump back to keystroke loop
CHECK18:
	CPI	18H		; see if we got a <CAN> (cancel) <ctrl-X>
	JNZ	RUN2		; no? keep going
; make <ctrl-R> action function same as <ctrl-S>
JTBLHACK:
	MVI	A,0A8H		; change run function to stop function
	STA	RUNTBLENT	; modify jump table for <ctrl-R>
	JMP	RUN2

; restore <ctrl-R> action function
JTBLUNHACK:
	MVI	A,0AFH		; change run function back to run function
	STA	RUNTBLENT	; modify jump table for <ctrl-R>
	JMP	PROCESS		; go back to keystroke loop

; seems dead
	DB	07H, 07H, 07H, 07H, 07H, 07H
	DB	00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H
	DB	00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H
	DB	00H, 00H, 00H, 00H, 00H
	DB	0DH, 0DH, 0DH, 0DH, 0DH, 0DH, 0DH, 0DH
	DB	0DH, 0DH, 0DH, 0DH, 0DH, 0DH, 0DH, 0DH





