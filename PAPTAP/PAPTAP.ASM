;NAM PAPTAP
; * HIGH SPEED PAPER TAPE LOADER PROGRAM
; * DEVELOPED BY DR. CHARLES ADAMS
; * TEXAS A&M UNIVERSITY
; *
; * MODIFIED BY CHRISTOPHER MALLERY
; * - Ported to RC2014
; *
 		    ORG		$9000
           
PIOADPORT 	EQU 	0x68			; PIO port A data register
PIOBDPORT 	EQU 	0x69			; PIO port B data register
PIOACPORT 	EQU 	0x6A			; PIO port A control register
PIOBCPORT 	EQU 	0x6B			; PIO port B control register

SERDEV      EQU     0x80            ; SERIAL DEVICE ADDRESS

ENTER       CALL    PIASUP          ; INIT PIA
START       CALL    PIADAT          ; GET 1ST BYTE
            CP      ':'            ; IS IT AN :?
            JP      NZ, START       ; IF NOT, START OVER
            LD      A, 0x00
            LD      (CHKSUM), A
            CALL     GETBYTE        ; GET THE BYTE COUNT
            LD      (NUMBYT), A
            CALL    GETADDR         ; GET ADDRESS AND LOAD IX
            CALL    GETBYTE         ; GET RECORD TYPE
            CP      0x00            ; IF NOT ZERO START OVER
            JP      NZ, START       
LOOP        CALL    GETBYTE        ; READ THE BYTES
            LD      A, (NUMBYT)
            DEC     A
            LD      (NUMBYT), A
            JP      Z, CHKCHK      ; LAST BYTE IS CHECKSUM
            LD      (IX+0), A 
            INC     IX
            JP      LOOP

CHKCHK      CALL    GBNOCHK         ; CHECK THE CHECKSUM
            LD      B, A
            LD      A, (CHKSUM)
            ADD     A, B            
            JP      Z, START        ; GO TO NEXT LINE
            LD      E, '!'               
            LD      B, 0x01
            LD      C, SERDEV       ; FAILED CHECK SUM, SO INTERRUPT
            RST     0x00                   

;*********** PIASUP - PIA SETUP ROUTINE
PIASUP      LD		A, 11001111B	    ; Set PIO B to control mode
			OUT		(PIOBCPORT), A
			LD		A, 11111110B	    ; PB7-PB1 input, PB-0 output
			OUT		(PIOBCPORT), A
            LD      A, 0x00
            OUT     (PIOBDPORT), A      ; ACK = 0
            LD		A, 11001111B	    ; Set PIO A to control mode
			OUT		(PIOACPORT), A
			LD		A, 11111111B	    ; PA7-PA0 input
			OUT		(PIOACPORT), A
            LD      A, 0x01
            OUT     (PIOBDPORT), A      ; ACK = 1
            RET

;*********** PIADAT - GET DATA FROM PIA
PIADAT      LD      A, 0x00             ; ACK = 0
            OUT     (PIOBDPORT), A      
DATLOP      IN      A, (PIOBDPORT)      ; GET RDY ON PORT B
            JP      M, GETDAT           ; DATA PRESENT? (BIT 7 == 1)
            JP      DATLOP              ; NOT YET. KEEP TRYING.
GETDAT      IN      A, (PIOADPORT)      ; YES. GET THE DATA,
            LD      (TMPBYTE), A        ; SAVE IT
            LD      E, A                ; PRINT IT
            LD      B, 0x01
            LD      C, SERDEV
            RST     0x08
            LD      A, 0x01             ; ACK = 1
            OUT     (PIOBDPORT), A
            LD      A, (TMPBYTE)        ; PUT DATA BACK IN REGISTER
            RET                         ; AND LEAVE...

;*********** GETBYTE - READ ASCII HEX BYTE (2 digits)
GETBYTE     CALL    GBNOCHK
            LD      B, A        ; SAVE THE BYTE
            LD      A, (CHKSUM) ; ADD TO CHECKSUM
            ADD     A, B
            LD     (CHKSUM), A
            LD      A, B        ; RESTORE THE BYTE
            RET

GBNOCHK     CALL    A2H         ; GET FIRST CHARACTER TO HEX
            SLA     A           ; MOVE IT UP 4 BITS
            SLA     A
            SLA     A
            SLA     A
            LD      B, A
            CALL    A2H         ; GET SECOND CHARACTER TO HEX
            ADD     A, B        ; ADD THEM TOGETHER
            RET

;*********** GETADDR - READ ADDRESS AND LOAD X
GETADDR     CALL    GETBYTE
            LD      (TMPADDR1), A
            CALL    GETBYTE
            LD      (TMPADDR2), A
            LD      IX, (TMPADDR1)
            RET

;*********** A2H - READ SINGLE ASCII BYTE AND CONVERT TO HEX
A2H         CALL    PIADAT      
            SUB     0x30        
            CP      0x0A
            RET     C
            SUB     0x07
            RET

NUMBYT      DB     1           ; BYTES LEFT TO READ
TMPADDR2    DB     1           ; TEMP ADDRESS POINTER
TMPADDR1    DB     1           
TMPBYTE     DB     1
CHKSUM      DB     1           ; RUNNING CHECKSUM

            END