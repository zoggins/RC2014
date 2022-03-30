; **********************************************************************
; **  Device Driver                             by Stephen C Cousins  **
; **  Hardware: SC114, and compatibles                                **
; **  Interface: Serial bit-bang                                      **
; **********************************************************************

; SCM BIOS framework compliant driver for a 9600 baud bit-bang serial
; port type SC1.

; The hardware interface consists of:
; Transmit data output     port <kTxPrt>   bit 0
; Request to send output   port <kRtsPrt>  bit 0
; Receive data input       port <kRxPrt>   bit 7
;
; The serial data format is standard TTL serial:
;
; ---+     +-----+-----+-----+-----+-----+-----+-----+-----+-----+-   1
;    |start|  0  |  1  |  2  |  3  |  4  |  5  |  6  |  7  | stop
;    +-----+-----+-----+-----+-----+-----+-----+-----+-----+          0
;
; At 9600 baud each bit takes 104.167us
; 0.5 bits takes 52.083us, 1.5 bits takes 156.25us

; Externally definitions required:
;kTxPrt:    .EQU 0x28           ;Transmit output is bit zero
;kRtsPrt:   .EQU 0x20           ;/RTS output is bit zero
;kRxPrt:    .EQU 0x28           ;Receive input is bit 7


            .CODE


; **********************************************************************
; SCM BIOS framework interface descriptor

BitBangSerial_SC1:
            .DB  0              ;Device ID code (not currently used)
            .DW  @String        ;Pointer to device string
            .DW  @Init          ;Pointer to initialisation code
            .DB  0b00001000     ;Hardware flags bit mask
            .DW  @Set           ;Point to device settings code
            .DB  1              ;Number of console devices
            .DW  @Rx            ;Pointer to 1st channel input code
            .DW  @Tx            ;Pointer to 1st channel output code
@String:    .DB  "Bit-bang serial @ "
            .HEXCHAR kTxPrt \ 16
            .HEXCHAR kTxPrt & 15
            .DB  kNull


; **********************************************************************

; Initialise 
;   On entry: No parameters required
;   On exit:  Z flagged if device is found and initialised
;             AF BC DE HL not specified
;             IX IY I AF' BC' DE' HL' preserved
; Set Tx output to idle state (high)
@Init:      LD   A, 1           ;Transmit high vlaue
            OUT  (kTxPrt), A    ;Output to transmit data port
            LD   A,(iTemp)      ;Get number of console devices
            OR   A              ;Any console devices?
            JR   NZ,@Done       ;Yes, so skip warning
; No other console devices to flash warning
            LD   DE,200
            CALL HW_Delay       ;Delay 0.2 seconds
            LD   A,1
            OUT  (kPrtLED),A    ;Motherboard LED off
            CALL HW_Delay       ;Delay 0.2 seconds
            XOR  A
            OUT  (kPrtLED),A    ;Motherboard LED on
; Exit with bit-bang port initialised
@Done:      XOR  A              ;Return success (Z flagged)
            RET


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


; Receive byte 
;   On entry: No parameters required
;   On exit:  A = Byte received via bit-bang serial port
;             NZ flagged if character input
;             BC DE HL IX IY I AF' BC' DE' HL' preserved
; The receive input must be on bit 7 of the port kRxPrt
@Rx:        PUSH BC             ;Preserve BC
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


; Device settings
;   On entry: No parameters required
;   On entry: A = Property to set: 1 = Baud rate
;             B = Baud rate code
;             C = Console device number (1 to 6)
;   On exit:  IF successful: (ie. valid device and baud code)
;               A != 0 and NZ flagged
;             BC DE HL not specified
;             IX IY I AF' BC' DE' HL' preserved
@Set:       XOR  A              ;Return failed to set (Z flagged)
            RET


; **********************************************************************
; **  End of driver                                                   **
; **********************************************************************







