; **********************************************************************
; **  CP/M 2.2 CBIOS, character device support  by Stephen C Cousins  **
; **  Character device = Z80 serial I/O (Device-SIO)                  **
; **********************************************************************

; This module supports two bi-directional devices (serial ports)
; These are called console A and console B
;
; Based on code by Grant Searle (www.searle.wales)

; Receive buffer size and full/empty thresholds
SER_SIZE    .EQU 60
SER_FULL    .EQU 50
SER_EMPTY   .EQU 5

; SIO register 5 value for RTS line HIGH and LOW
RTS_HIGH    .EQU 0xE8
RTS_LOW     .EQU 0xEA

; Optional CTC register addresses
CTCA        .EQU 0x88           ;CTC register for SIO port A baud rate
CTCB        .EQU 0x89           ;CTC register for SIO port B baud rate



kSIOBase    .EQU kCDBase        ;Establish base address

#IF         CDMode = "SC"
SIOA_D      .EQU kSIOBase+0
SIOA_C      .EQU kSIOBase+2
SIOB_D      .EQU kSIOBase+1
SIOB_C      .EQU kSIOBase+3
#ENDIF
#IF         CDMode = "RC"
SIOA_D      .EQU kSIOBase+1
SIOA_C      .EQU kSIOBase+0
SIOB_D      .EQU kSIOBase+3
SIOB_C      .EQU kSIOBase+2
#ENDIF

#DEFINE     SIOA_CTC
#DEFINE     SIOB_CTC


; **********************************************************************
; **  Character device code
; **********************************************************************

            .CODE

; **********************************************************************
; **  Character device - cold boot initialisation
; **********************************************************************

CD_cboot:
; Initialise SIO port A
            LD   C,SIOA_C       ;address of SIO control register
            LD   HL,@SIOData    ;default to divide 64 (no CTC)
#IFDEF      SIOA_CTC
; Crude test for CTC controlling baud rate
; If CTC timer = 1 or 2 then we assume CTC is connected as SIO clock
; This only works for highest few baud rates
            IN   A,(CTCA)       ;read CTC reg for this port
            CP   2              ;CTC present? (timer set to 2)
            JR   Z,@sioA16      ;yes, so skip
            CP   1              ;CTC present? (timer set to 1)
            JR   NZ,@sioAset    ;No, so skip
@sioA16:    LD   HL,@SIODataCTC ;divide 16 (ctc controls baud)
#ENDIF
@sioAset:   CALL @SIO_Setup     ;Initialise port A

; Initialise SIO port B
            LD   C,SIOB_C       ;address of SIO control register
            LD   HL,@SIOData    ;default to divide 64 (no CTC)
#IFDEF      SIOB_CTC
; Crude test for CTC controlling baud rate
; If CTC timer = 1 or 2 then we assume CTC is connected as SIO clock
; This only works for highest few baud rates
            IN   A,(CTCB)       ;read CTC reg for this port
            CP   2              ;CTC present? (timer set to 2)
            JR   Z,@sioB16      ;yes, so skip
            CP   1              ;CTC present? (timer set to 1)
            JR   NZ,@sioBset    ;No, so skip
@sioB16:    LD   HL,@SIODataCTC ;divide 16 (ctc controls baud)
#ENDIF
@sioBset:   ; JR   SIO_Setup    ;Initialise port B


; Write initialisation data to SIO
;   On entry: C = CTC control port I/O address
;             HL = Start address of SIO initialisation data
;   On exit:  DE IX IY I AF' BC' DE' HL' preserved
; Send initialisation data to specified channel
; WARNING: With CTC this code only works for high baud rates
@SIO_Setup: LD   B,@SIODataEnd-@SIOData ;Length of init data
            OTIR                ;Write data to output port C
            RET
; SIO channel initialisation data
; No CTC, SIO divides clock by 64
@SIOData:
;           .DB  0b00000000     ; Wr0 Pointer R0 (not necessary)
            .DB  0b00011000     ; Wr0 Channel reset
            .DB  0b00000100     ; Wr0 Pointer R4
            .DB  0b11000100     ; Wr4 /64, async mode, no parity
            .DB  0b00000001     ; Wr0 Pointer R1
            .DB  0b00011000     ; Wr1 Interrupt on all received chars
            .DB  0b00000010     ; Wr0 Pointer R2
            .DB  intvecLo       ; Wr2 Interrupt vector
            .DB  0b00000011     ; Wr0 Pointer R3
            .DB  0b11100001     ; Wr3 Receive enable, 8 bit 
            .DB  0b00000101     ; Wr0 Pointer R5
            .DB  RTS_LOW        ; Wr5 Transmit enable, 8 bit, flow ctrl
@SIODataEnd:
; With CTC, SIO divides clock by 16
; WARNING: With CTC this code only works for high baud rates
@SIODataCTC:
;           .DB  0b00000000     ; Wr0 Pointer R0 (not necessary)
            .DB  0b00011000     ; Wr0 Channel reset
            .DB  0b00000100     ; Wr0 Pointer R4
            .DB  0b01000100     ; Wr4 /16, async mode, no parity
            .DB  0b00000001     ; Wr0 Pointer R1
            .DB  0b00011000     ; Wr1 Interrupt on all received chars
            .DB  0b00000010     ; Wr0 Pointer R2
            .DB  intvecLo       ; Wr2 Interrupt vector
            .DB  0b00000011     ; Wr0 Pointer R3
            .DB  0b11100001     ; Wr3 Receive enable, 8 bit 
            .DB  0b00000101     ; Wr0 Pointer R5
            .DB  RTS_LOW        ; Wr5 Transmit enable, 8 bit, flow ctrl


; **********************************************************************
; **  Character device interrupt routines
; **********************************************************************

CD_InterruptA:
CD_InterruptB:                  ;Dummy entry: Only one interrupt for SIO
CD_InterruptC:                  ;Dummy entry: Only one interrupt for SIO
CD_InterruptD:                  ;Dummy entry: Only one interrupt for SIO
            PUSH AF
            PUSH HL
; Determine which port has an input character
@serInt:    XOR  A
            OUT  (SIOA_C),A
            IN   A,(SIOA_C)     ;Status byte D2=TX Buff Empty, D0=RX char ready
            RRCA                ;Rotates RX status into Carry Flag
            JR   C,@serIntA
            XOR  A
            OUT  (SIOB_C),A
            IN   A,(SIOB_C)     ;Status byte D2=TX Buff Empty, D0=RX char ready
            RRCA                ;Rotates RX status into Carry Flag
            JR   C,@serIntB
            POP HL
            POP AF
            EI
            RETI

@serIntA:   LD   HL,(serAInPtr)
            INC  HL
            LD   A,L
            CP   serALoAd       ;<SCC> (serABuf+SER_BUFSIZE) & $FF
            JR   NZ,@notAWrap
            LD   HL,serABuf
@notAWrap:  LD   (serAInPtr),HL
            IN   A,(SIOA_D)
            LD   (HL),A
            LD   A,(serABufUsed)
            INC  A
            LD   (serABufUsed),A
            CP   SER_FULL
            JR   C,@serInt
            LD   A,$05
            OUT  (SIOA_C),A
            LD   A,RTS_HIGH
            OUT  (SIOA_C),A
            JR   @serInt

@serIntB:   LD   HL,(serBInPtr)
            INC  HL
            LD   A,L
            CP   serBLoAd       ;<SCC> (serBBuf+SER_BUFSIZE) & $FF
            JR   NZ,@notBWrap
            LD   HL,serBBuf
@notBWrap:  LD   (serBInPtr),HL
            IN   A,(SIOB_D)
            LD   (HL),A
            LD   A,(serBBufUsed)
            INC  A
            LD   (serBBufUsed),A
            CP   SER_FULL
            JR   C,@serInt
            LD   A,$05
            OUT  (SIOB_C),A
            LD   A,RTS_HIGH
            OUT  (SIOB_C),A
            JR   @serInt


; **********************************************************************
; **  Character device i/o routine
; **********************************************************************

; **********************************************************************
; Console status routines: constA, constB
;
; On entry: No parameters
; On exit:  A = 0xFF if character(s) available
;           A = 0x00 if no characters available

CD_constA:  LD   A,(serABufUsed)
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
            LD   A,$05
            OUT  (SIOA_C),A
            LD   A,RTS_LOW
            OUT  (SIOA_C),A
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
            CP   SER_EMPTY
            JR   NC,@rtsB1
            LD   A,$05
            OUT  (SIOB_C),A
            LD   A,RTS_LOW
            OUT  (SIOB_C),A
@rtsB1:     EI
            LD   A,(HL)
            POP  HL
            RET                 ;Char ready in A


; **********************************************************************
; Console output routines: CD_conoutA, CD_conoutB
;
; On entry: C = character to output
; On exit:  No return value

CD_conoutA: XOR  A              ;Wait for SIO A transmit to be ready...
            OUT  (SIOA_C),A
            IN   A,(SIOA_C)     ;Status byte D2=TX Buff Empty, D0=RX char ready
            BIT  2,A            ;Set Zero flag if still transmitting character
            JR   Z,CD_conoutA   ;Loop until SIO flag signals ready
            LD   A,C
            OUT  (SIOA_D),A     ;OUTput the character
            RET

CD_conoutB: XOR  A              ;Wait for SIO A transmit to be ready...
            OUT  (SIOB_C),A
            IN   A,(SIOB_C)     ;Status byte D2=TX Buff Empty, D0=RX char ready
            BIT  2,A            ;Set Zero flag if still transmitting character
            JR   Z,CD_conoutB   ;Loop until SIO flag signals ready
            LD   A,C
            OUT  (SIOB_D),A     ;OUTput the character
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



















