; **********************************************************************
; **  CP/M 2.2 CBIOS, console device support    by Stephen C Cousins  **
; **  Console device = Serial ACIA 68B50 (ConsoleDevice-ACIA)         **
; **********************************************************************

; This module supports two bi-directional devices (serial ports)
; These are called console A and console B
; However, as there is only one physical port they are both the same
;
; Based on code by Grant Searle (www.searle.wales)

; Receive buffer size and full/empty thresholds
SER_SIZE    .EQU 60
SER_FULL    .EQU 50
SER_EMPTY   .EQU 5

; ACIA control register values for RTS line HIGH and LOW
RTS_HIGH    .EQU 0xD6
RTS_LOW     .EQU 0x96

; ACIA I/O addresses
kACIABase   .EQU kCDBase
ACIA1_C     .EQU kACIABase+0
ACIA1_D     .EQU kACIABase+1
;ACIA2_D    .EQU kSIOBase+1
;ACIA2_C    .EQU kSIOBase+3

; Override default interrupt mode
#DEFINE     INTERRUPT_MODE_1

; **********************************************************************
; **  Console device code
; **********************************************************************

            .CODE

; **********************************************************************
; **  Console device - cold boot initialisation
; **********************************************************************

CD_cboot:
            LD   A,RTS_LOW      ;Initialise ACIA
            OUT  (ACIA1_C),A    ;  ensuring RTS is low

            RET


; **********************************************************************
; **  Console device interrupt routines
; **********************************************************************


CD_Interrupt:
@serIntA:   PUSH AF
            PUSH HL
            IN   A,(ACIA1_C)    ;Read ACIA control register
            AND  0x01           ;Receive buffer full?
            JR   Z,@rts0        ;No, so skip
            LD   HL,(serAInPtr)
            INC  HL
            LD   A,L
            CP   serALoAd       ;<SCC> (serABuf+SER_BUFSIZE) & $FF
            JR   NZ,@notAWrap
            LD   HL,serABuf
@notAWrap:  LD   (serAInPtr),HL
; Check status of receive
;           ...                 ;Test for errors
;           JR   Z,@NoErr
; Error detected, so clear the error
;           ...                 ;Clear all errors
; Read the data register
@NoErr:     IN   A,(ACIA1_D)    ;Get character received
            LD   (HL),A         ;Store in buffer
            LD   A,(serABufUsed)
            INC  A              ;Increment character count
            LD   (serABufUsed),A
            CP   SER_FULL       ;Test if buffer nearly
            JR   C,@rts0
            LD   A,RTS_HIGH     ;Buffer nearly full so
            OUT  (ACIA1_C), A   ;  set RTS high
@rts0:      POP HL
            POP AF
            EI
            RETI

; Dummy mode 2 interrupt routines (not supported)
CD_InterruptA:
CD_InterruptB:
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

CD_coninA:  
CD_coninB:
            PUSH HL
@awaitChar: LD   A,(serABufUsed)
            OR   A              ;Is buffer empty?
            JR   Z,@awaitChar   ;Yes, so wait
            LD   HL,(serARdPtr)
            INC  HL
            LD   A,L
            CP   serALoAd       ;<SCC> (serBBuf+SER_BUFSIZE) & $FF
            JR   NZ,@notRdWrap
            LD   HL,serABuf
@notRdWrap: DI
            LD   (serARdPtr),HL
            LD   A,(serABufUsed)
            DEC  A
            LD   (serABufUsed),A
            CP   SER_EMPTY      ;Test if buffer nearly empty
            JR   NC,@rts1
            LD   A,RTS_LOW      ;Buffer nearly empty
            OUT  (ACIA1_C), A   ;  so ensure RTS is low
@rts1:      LD   A,(HL)
            EI
            POP  HL
            RET                 ;Char ready in A


; **********************************************************************
; Console output routines: CD_conoutA, CD_conoutB
;
; On entry: C = character to output
; On exit:  No return value

CD_conoutA:
CD_conoutB:
@Wait:      IN   A,(ACIA1_C)    ;Read control register (status)       
            BIT  1,A            ;Test of transmit buffer empty       
            JR   Z,@Wait        ;Not empty, so wait
            LD   A,C            ;Get character to output
            OUT  (ACIA1_D),A    ;Output the character
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






