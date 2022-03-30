; **********************************************************************
; **  CP/M 2.2 CBIOS, console device support    by Stephen C Cousins  **
; **  Console device = Z180 serial I/O (ConsoleDevice-ASCI)           **
; **********************************************************************

; This module supports two bi-directional devices (serial ports)
; These are called console A and console B
;
; Based on code by Grant Searle (www.searle.wales)

; Receive buffer size and full/empty thresholds
SER_SIZE    .EQU 60
SER_FULL    .EQU 50
SER_EMPTY   .EQU 5

; CNTLA0/1 register value for RTS line HIGH (busy) and LOW (ready)
RTS_HIGH    .EQU 0b01110100
RTS_LOW     .EQU 0b01100100


; **********************************************************************
; **  Console device code
; **********************************************************************

            .CODE

; **********************************************************************
; **  Console device - cold boot initialisation
; **********************************************************************

CD_cboot:
; Serial port A is the 9th entry in the interrupt vector table
; Serial port B is the 10th entry in the interrupt vector table
; The least significant 5 bits of the vector address are therefore:
;   Port A = 10000
;   Port B = 10010
            LD   A,intvecLo
            OUT0 (IL),A         ;Set bits 7 to 5 of the vector table

;           LD  A,1
;           OUT0 (ITC),A         ;Enable external interrupt sources

; Control Register A for channel 0 (CNTLA0)
;   Bit 7 = 0    Multiprocessor Mode Enable (MPE)
;   Bit 6 = 1    Receiver Enable (RE)
;   Bit 5 = 1    Transmitter Enable (TE)
;   Bit 4 = 0    Request to Send Output (RTS0) (0 = Low, 1 = High)
;   Bit 3 = 0    Multiprocessor Bit Receive/Error Flag (MPBR) (0 = Reset)
;   Bit 2 = 1    Data Format (0 = 7-bit, 1 = 8-bit)
;   Bit 1 = 0    Parity (0 = No Parity, 1 = Parity Enabled)
;   Bit 0 = 0    Stop Bits (0 = 1 Stop Bit, 1 = 2 Stop Bits)
;           LD   A, 0b01100100
            LD   A, RTS_LOW
            OUT0 (CNTLA0), A
            OUT0 (CNTLA1), A

; Control Register B for channel 0 (CNTLB0)
;   Bit 7 = 0    Multiprocessor Bit Transmit (MPBT)
;   Bit 6 = 0    Multiprocessor Mode (MP)
;   Bit 5 = 0    Clear to Send/Prescale (CTC/PS) (0 = PHI/10, 1 = PHI/30)
;   Bit 4 = 0    Parity Even Odd (PEO) (0 = Even, 1 = Odd)
;   Bit 3 = 0    Divide Ratio (DR) (0 = divide 16, 1 = divide 64)
;   Bit 2 = 000  Source/Speed Select (SS2-SS0)
;    to 0        (0 = /1, 1 = /2, .. 6 = /64, 7 = External clock)
; Assume already set up by SCM
;           LD   A, 0b00000000
;           OUT0 (CNTLB0), A
;           OUT0 (CNTLB1), A

; Extension Control Register (ASCI0, ASCI1) [Z8S180/L180-class processors only)
;   Bit 7 = 0    Reserved
;   Bit 6 = 1    DCD0 Disable (0 = DCD0 Auto-enable Rx, 1 = Advisory)
;   Bit 5 = 1    CTS0 Disable (0 = CTS0 Auto-enable Tx, 1 = Advisory)
;   Bit 4 = 0    X1 Bit Clock (0 = CKA0/16 or 64, 1 = CKA0 is bit clock)
;   Bit 3 = 0    BRG0 Mode (0 = As S180, 1 = Enable 16-BRG counter)
;   Bit 2 = 0    Break Feature (0 = Enabled, 1 = Disabled)
;   Bit 1 = 0    Break Detect (0 = On, 1 = Off)
;   Bit 0 = 0    Send Break (0 = Normal transmit, 1 = Drive TXA Low)
; Assume already set up by SCM
;           LD   A, 0b01100000
;           OUT0 (ASCI0), A
;           OUT0 (ASCI1), A

; ASCI Status Register (STAT0, STAT1)
;   Bit 7 = 0    Read data register full (1 = Full, 0 = Empty)
;   Bit 6 = 0    Overrun Error (1 = Error, 0 = No error)
;   Bit 5 = 0    Parity Error (1 = Error, 0 = No error)
;   Bit 4 = 0    Framing Error (1 = Error, 0 = No error)
;   Bit 3 = 1    Receive Interrupt Enable (1 = Enabled, 0 = Disabled)
;   Bit 2 = 0    STAT0: Data Carrier Detect (1 = DCD pin Hi, 0 = DCD pin Lo)
;                STAT1: Clear To Send Pin Function (1 = CTS1, 0 = RXS)
;   Bit 1 = 0    Transmit Data Register Empty (1 = Empty, 0 = Full)
;   Bit 0 = 0    Transmit Interrupt Enable (1 = Enabled, 0 = Disabled)
            LD   A, 0b00001000
            OUT0 (STAT0), A
            OUT0 (STAT1), A

            RET


; **********************************************************************
; **  Console device interrupt routines
; **********************************************************************

CD_InterruptA:
            PUSH AF
            PUSH HL
@Test:      IN0  A,(STAT0)      ;Check status of receive
            AND  0x70           ;Mask error bits
            JR   NZ,@Error
            IN0  A,(STAT0)      ;Check status of receive
            RLA                 ;Character available?
            JR   C,@Read        ;Yes, so go read character
@Exit:      POP HL              ;No, so exit interrupt handler
            POP AF
            EI
            RETI
@Read:      LD   HL,(serAInPtr)
            INC  HL
            LD   A,L
            CP   serALoAd       ;<SCC> (serABuf+SER_BUFSIZE) & $FF
            JR   NZ,@notAWrap
            LD   HL,serABuf
@notAWrap:  LD   (serAInPtr),HL
            IN0  A,(RDR0)       ;Read the data register
            LD   (HL),A         ;Store in buffer
            LD   A,(serABufUsed)
            INC  A
            LD   (serABufUsed),A
            CP   SER_FULL
            JR   C,@Test
            LD   A,RTS_HIGH     ;Buffer nearly full
            OUT0 (CNTLA0), A    ;  so set RTS to disable 
            JR   @Test
@Error:     IN0  A,(CNTLA0)     ;Error detected
;           SET  3,A            ;Clear all errors ??????
            RES  3,A            ;Clear all errors
            OUT0 (CNTLA0),A
            JR   @Test

CD_InterruptB:
            PUSH AF
            PUSH HL
@Test:      IN0  A,(STAT1)      ;Check status of receive
            AND  0x70           ;Mask error bits
            JR   NZ,@Error
            IN0  A,(STAT1)      ;Check status of receive
            RLA                 ;Character available?
            JR   C,@Read        ;Yes, so go read character
@Exit:      POP HL              ;No, so exit interrupt handler
            POP AF
            EI
            RETI
@Read:      LD   HL,(serBInPtr)
            INC  HL
            LD   A,L
            CP   serBLoAd       ;<SCC> (serBBuf+SER_BUFSIZE) & $FF
            JR   NZ,@notBWrap
            LD   HL,serBBuf
@notBWrap:  LD   (serBInPtr),HL
            IN0  A,(RDR1)
            LD   (HL),A         ;Store in buffer
            LD   A,(serBBufUsed)
            INC  A
            LD   (serBBufUsed),A
;           CP   SER_FULL
;           JR   C,@Test
;           LD   A,RTS_HIGH
;           OUT0 (CNTLA1), A
            JR   @Test
@Error:     IN0  A,(CNTLA1)
;           SET  3,A            ;Clear all errors ??????
            RES  3,A            ;Clear all errors
            OUT0 (CNTLA1),A
            JR   @Test


; Dummy interrupt routines (not supported)
CD_InterruptC:
CD_InterruptD:


; **********************************************************************
; **  Console device i/o routine
; **********************************************************************

; **********************************************************************
; Console status routines: constA, constB
;
; On entry: No parameters
; On exit:  A = 0xFF if character(s) available
;           A = 0x00 if no characters available

CD_constA:  LD   A,(serABufUsed)
            OUT (0x0D),A
            JR   CD_constX

CD_constB:  LD   A,(serBBufUsed)

CD_constX:  OR   A
            RET  Z              ;Return A=0x00 (empty)
            LD   A,0xFF         ;Return A=0xFF (char available)
            RET


; **********************************************************************
; Console input routines: coninA, coninB
;
; On entry: No parameters
; On exit:  A = character input

CD_coninA:  PUSH HL
@awaitChar: LD   A,(serABufUsed)
            OUT (0x0D),A
            OR   A
            JR   Z,@awaitChar
            LD   HL,(serARdPtr)
            INC  HL
            LD   A,L
            CP   serALoAd       ;<SCC> (serABuf+SER_BUFSIZE) & $FF
            JR   NZ,@notRdWrap
            LD   HL,serABuf
@notRdWrap: LD   (serARdPtr),HL
            DI
            LD   A,(serABufUsed)
            DEC  A
            LD   (serABufUsed),A
            CP   SER_EMPTY
            JR   NC,@rtsA1
            LD   A,RTS_LOW
            OUT0 (CNTLA0), A
@rtsA1:     EI
            LD   A,(HL)
            POP  HL
            RET                 ;Char ready in A

CD_coninB:  PUSH HL
@awaitChar: LD   A,(serBBufUsed)
            OR   A
            JR   Z,@awaitChar
            LD   HL,(serBRdPtr)
            INC  HL
            LD   A,L
            CP   serBLoAd       ;<SCC> (serBBuf+SER_BUFSIZE) & $FF
            JR   NZ,@notRdWrap
            LD   HL,serBBuf
@notRdWrap: LD   (serBRdPtr),HL
            DI
            LD   A,(serBBufUsed)
            DEC  A
            LD   (serBBufUsed),A
;           CP   SER_EMPTY
;           JR   NC,@rtsB1
;           LD   A,RTS_LOW
;           OUT0 (CNTLA1), A
@rtsB1:     EI
            LD   A,(HL)
            POP  HL
            RET                 ;Char ready in A


; **********************************************************************
; Console output routines: CD_conoutA, CD_conoutB
;
; On entry: C = character to output
; On exit:  No return value

CD_conoutA: IN0  A,(STAT0)      ;Read serial port status register
            BIT  ST_TDRE,A      ;Transmit register empty?
            JR   Z,CD_conoutA   ;No, so keep waiting
            OUT0 (TDR0), C      ;Write byte to serial port
            RET

CD_conoutB: IN0  A,(STAT1)      ;Read serial port status register
            BIT  ST_TDRE,A      ;Transmit register empty?
            JR   Z,CD_conoutB   ;No, so keep waiting
            OUT0 (TDR1), C      ;Write byte to serial port
            RET


; **********************************************************************
; **  Data storage
; **********************************************************************

            .DATA

serABuf:    .ds  SER_SIZE       ;SIO A receive buffer
serAInPtr   .DW  serABuf
serARdPtr   .DW  serABuf
serABufUsed .DB  0
serBBuf:    .ds  SER_SIZE       ;SIO B receive buffer
serBInPtr   .DW  serBBuf
serBRdPtr   .DW  serBBuf
serBBufUsed .DB  0


;=================================================================================
; Fix for limitations in SCWorkshop assembler <SCC>

serATmp:    .EQU serABuf+SER_SIZE
serALoAd:   .EQU serATmp & $FF

serBTmp:    .EQU serBBuf+SER_SIZE
serBLoAd:   .EQU serBTmp & $FF





