; **********************************************************************
; **  CP/M 2.2 CBIOS, console device support    by Stephen C Cousins  **
; **  Console device = Bit-bang 9600 serial I/O (ConsoleDevice-BB96)  **
; **********************************************************************

; This module supports two bi-directional devices (serial ports)
; These are called console A and console B
; However, as there is only one physical port they are both the same
;
; Based on code by Grant Searle

; Receive buffer size and full/empty thresholds
;SER_SIZE   .EQU 60
;SER_FULL   .EQU 50
;SER_EMPTY  .EQU 5

; SIO register 5 value for RTS line HIGH and LOW
;RTS_HIGH   .EQU 0b01110100
;RTS_LOW    .EQU 0b01100100

kTxPrt:     .EQU 0x28           ;Transmit output is bit zero
kRtsPrt:    .EQU 0x20           ;/RTS output is bit zero
kRxPrt:     .EQU 0x28           ;Receive input is bit 7

; **********************************************************************
; **  Console device code
; **********************************************************************

            .CODE

; **********************************************************************
; **  Console device - cold boot initialisation
; **********************************************************************

CD_cboot:
; Start of Bit-Bang serial (9600 baud) initialisation
            LD   A, 1           ;Transmit high vlaue
            OUT  (kTxPrt), A    ;Output to transmit data port

            RET


; **********************************************************************
; **  Console device interrupt routines
; **********************************************************************

; Dummy interrupt routines (not supported)
CD_InterruptA:
CD_InterruptB:
CD_InterruptC:
CD_InterruptD:
            EI
            RETI


; **********************************************************************
; **  Console device i/o routine
; **********************************************************************

; **********************************************************************
; Console status routines: constA, constB
;
; On entry: No parameters
; On exit:  A = 0xFF if character(s) available
;           A = 0x00 if no characters available

CD_constA:  
CD_constB:
            LD   A,(BBRxByte)   ;Get character waiting
            OR   A              ;Is there a character waiting?
            JR   NZ,@YesRx      ;Yes, so skip...
            CALL Rx             ;Go test for a serial receive
            JR   Z,@NoRx        ;NZ flagged if received, A = Char
            LD   (BBRxByte),A   ;Store character received
@YesRx:     LD   A,0xFF         ;Return status = Char available
            RET
@NoRx:      LD   A,0            ;Return status = Char not available
            RET


; Receive byte 
;   On entry: No parameters required
;   On exit:  A = Byte received via bit-bang serial port
;             NZ flagged if character input
;             BC DE HL IX IY I AF' BC' DE' HL' preserved
; The receive input must be on bit 7 of the port kRxPrt
Rx:         PUSH BC             ;Preserve BC
            XOR  A              ;Enable RTS line so
            OUT  (kRtsPrt), A   ;  terminal can send a character
            LD   B, 10
@RxDelay:   DJNZ @RxDelay       ;Wait a while
            INC  A              ;Disable RTS line so
            OUT  (kRtsPrt), A   ;  terminal will not send a character
@RxWait:    IN   A, (kRxPrt)    ;Read receive port [11]
            AND  0x80           ;Test receive input [7]
            JR   Z, @RxBegin    ;Abort if no start bit [12/7]
            DJNZ @RxWait        ;Timeout?
            POP  BC             ;Restore BC
            XOR  A              ;Return Z as no character received
            RET
@RxBegin:   PUSH DE             ;Preserve DE
            LD   E, 8           ;Prepare bit counter
            LD   B, 82          ;Delay 1.5 bits [7]
@RxBit:     DJNZ @RxBit         ;Loop until end of delay [13/8]
            IN   A, (kRxPrt)    ;Read receive port [11]
            AND  0x80           ;Mask data bit and clear carry [7]
            RR   C              ;Rotate result byte right [8]
            OR   C              ;OR input bit with result byte [4]
            LD   C, A           ;Store current result byte [4]
            LD   B, 55          ;Delay 1 bit [7]
            DEC  E              ;Decrement bit counter [4]
            JR   NZ, @RxBit     ;Repeat until zero [12/7]
@RxStop:    DJNZ @RxStop        ;Wait for stop bit
            OR   0xFF           ;Return NZ as character received
            LD   A, C           ;Return byte received
            POP  DE             ;Restore DE
            POP  BC             ;Restore BC
            RET

BBRxByte:   DB  0               ;Character waiting (received)


; **********************************************************************
; Console input routines: coninA, coninB
;
; On entry: No parameters
; On exit:  A = character input

CD_coninA:
CD_coninB:
            PUSH HL
            LD   HL,BBRxByte    ;Address of character waiting
            LD   A,(HL)         ;Get character waiting
            LD   (HL),0         ;Clear character waiting
            OR   A              ;Is there a character waiting?
@Wait:      CALL Z,Rx           ;No, so go check for new character
            JR   Z,@Wait        ;No new character so keep looking
            POP  HL
            RET


; **********************************************************************
; Console output routines: CD_conoutA, CD_conoutB
;
; On entry: C = character to output
; On exit:  No return value

CD_conoutA:
CD_conoutB:
            LD   A,C            ;Get character to be output

; Transmit byte 
;   On entry: A = Byte to be transmitted via bit-bang serial port
;   On exit:  If character output successful (eg. device was ready)
;               NZ flagged and A != 0
;             BC DE HL IX IY I AF' BC' DE' HL' preserved
@Tx:        PUSH BC             ;Preserve BC
            LD   C, A           ;Store character to be transmitted
            XOR  A
            OUT  (kTxPrt), A    ;Begin start bit
            OUT  (kTxPrt), A    ;Just here to add a little extra delay
            LD   A, C           ;Restore character to be transmitted
            LD   C, 10          ;Bit count including stop
@TxBit:     LD   B, 56          ;Delay time [7]
@TxDelay:   DJNZ @TxDelay       ;Loop until end of delay [13/8]
            NOP                 ;Tweak delay time [4]
            OUT  (kTxPrt), A    ;Output current bit [11]
            SCF                 ;Ensure stop bit is logic 1 [4]
            RRA                 ;Rotate right through carry [4]
            DEC  C              ;Decrement bit count [4]
            JR   NZ,@TxBit      ;Repeat until zero [12/7]
            OR   0xFF           ;Return success A !=0 and flag NZ
            POP  BC             ;Restore BC
            RET


; **********************************************************************
; **  Data storage
; **********************************************************************

            .DATA



