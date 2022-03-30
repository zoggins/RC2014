; **********************************************************************
; **  Device Driver                             by Stephen C Cousins  **
; **  Hardware:  Generic                                              **
; **  Interface: Serial Z85C30 SCC                                    **
; **********************************************************************

; This SCM BIOS framework compliant driver for a 85C30 SCC (serial 
; communications controller)

; WARNING: SCC port A must be an odd numbered console devices
;          SCC port B must be an even numbered console devices
;
; SCC too complex to reproduce technical info here. See SCC datasheet

; Externally definitions required:
;kSCCBase:  .EQU kSCC1         ;I/O base address
;kSCCBCont: .SET kSCCBase+0     ;I/O address of control register B
;kSCCACont: .SET kSCCBase+1     ;I/O address of control register A
;kSCCBData: .SET kSCCBase+2     ;I/O address of data register B
;kSCCAData: .SET kSCCBase+3     ;I/O address of data register A


            .CODE


; **********************************************************************
; SCM BIOS framework interface descriptor

            .DB  0              ;Device ID code (not currently used)
            .DW  @String        ;Pointer to device string
            .DW  @SCC_Init      ;Pointer to initialisation code
            .DB  kSCCFlags      ;Hardware flags bit mask
            .DW  @SCC_Set       ;Point to device settings code
            .DB  2              ;Number of console devices
            .DW  @SCC_RxA       ;Pointer to 1st channel input code
            .DW  @SCC_TxA       ;Pointer to 1st channel output code
            .DW  @SCC_RxB       ;Pointer to 2nd channel input code
            .DW  @SCC_TxB       ;Pointer to 2nd channel output code
@String:    .DB  "SCC "
            .DB  "@ "
            .HEXCHAR kSCCBase \ 16
            .HEXCHAR kSCCBase & 15
            .DB  kNull


; **********************************************************************
; Initialise
;   On entry: No parameters required
;   On exit:  Z flagged if device is found and initialised
;             AF BC DE HL not specified
;             IX IY I AF' BC' DE' HL' preserved
; If the device is found it is initialised
@SCC_Init:
; First look to see if the device is present
; Test 1, just read from chip, do not write anything
            IN   A,(kSCCACont)  ;Read status (control) register A
            AND  0x7A
            CP   0x78
            RET  NZ
            IN   A,(kSCCBCont)  ;Read status (control) register B
            AND  0x7A
            CP   0x78
            RET  NZ
; Reset the Serial Communications Controller
            LD   A,9
            OUT  (kSCCACont),A  ;Select register 9
            LD   A,0b11000000
            OUT  (kSCCACont),A  ;Issue reset command
; Initialise both ports (excluding baud rate setting)
            LD   C,kSCCACont    ;Serial port A control register
            CALL SCC_Setup      ;Set up serial port A
            LD   C,kSCCBCont    ;Serial port B control register    
            CALL SCC_Setup      ;Set up serial port B
            XOR  A              ;Set Z flag (success)
            RET                 ;  and return


; **********************************************************************
; Input character
;   On entry: No parameters required
;   On exit:  A = Character input from the device
;             NZ flagged if a character has been found
;             BC DE HL IX IY I AF' BC' DE' HL' preserved
@SCC_RxA:
            IN   A,(kSCCACont)  ;Address of status register
            BIT  0,A            ;Receive byte available
            RET  Z              ;Return Z if no character
            IN   A,(kSCCAData)  ;Read data byte
            RET
@SCC_RxB:
            IN   A,(kSCCBCont)  ;Address of status register
            BIT  0,A            ;Receive byte available
            RET  Z              ;Return Z if no character
            IN   A,(kSCCBData)  ;Read data byte
            RET


; **********************************************************************
; Output character
;   On entry: A = Character to be output to the device
;   On exit:  If character output successful (eg. device was ready)
;               NZ flagged and A != 0
;             If character output failed (eg. device busy)
;               Z flagged and A = Character to output
;             BC DE HL IX IY I AF' BC' DE' HL' preserved
@SCC_TxA:
            PUSH BC
            LD   C,kSCCACont    ;ACIA control register
            IN   B,(C)          ;Read ACIA control register
            BIT  2,B            ;Transmit register full?
            POP  BC
            RET  Z              ;Return Z as character not output
            OUT  (kSCCAData),A  ;Write data byte
            OR   0xFF           ;Return success A=0xFF and NZ flagged
            RET
@SCC_TxB:
            PUSH BC
            LD   C,kSCCBCont    ;ACIA control register
            IN   B,(C)          ;Read ACIA control register
            BIT  2,B            ;Transmit register full?
            POP  BC
            RET  Z              ;Return Z as character not output
            OUT  (kSCCBData),A  ;Write data byte
            OR   0xFF           ;Return success A=0xFF and NZ flagged
            RET


; **********************************************************************
; Device settings
;   On entry: No parameters required
;   On entry: A = Property to set: 1 = Baud rate
;             B = Baud rate code (1 to 12)
;             C = Console device number (1 to 6)
;   On exit:  IF successful: (ie. valid device and baud code)
;               A != 0 and NZ flagged
;             BC DE HL not specified
;             IX IY I AF' BC' DE' HL' preserved
; Baud rate codes are 1 to 12 (1 = 230400 baud, ... , 12 = 300 baud)
@SCC_Set:   CP   1              ;Baud rate?
            JR   NZ,@Failed     ;No, so go return failure
; WARNING: We assume serial port A is an odd numbered console device
;          and serial port B is an even numbered console device
; Determine which serial port is being set
; B = Baud rate code (1 to 12)
; C = Console device number (1 to 6)
            LD   A,C            ;Get console device number (1 to 6)
            AND  1              ;SCC port A ?            *** WARNING ***
            LD   A,kSCCACont    ;Control register address for port A
            JR   NZ,@GotReg     ;Yes, port A, so skip
            LD   A,kSCCBCont    ;Control register address for port B
; Look up time constant for this baud rate
; A = Control register address
; B = Baud rate code (1 to 12)
; C = Console device number (1 to 6)
@GotReg:    LD   C,A            ;Control register address
            LD   HL,@TimeCon-2  ;Start of time constant list (-2)
@Step:      INC  HL             ;Increment pointer
            INC  HL             ;  to next time constant value
            DJNZ @Step          ;Repeat until found
            LD   E,(HL)         ;Get time constant lo byte
            INC  HL
            LD   D,(HL)         ;Get time constant hi byte
; Set device's time constant
; C = Control register address
; DE = Time constant
            LD   A,12           ;Select register 12
            OUT  (C),A          ;  = Time constant lo byte
            OUT  (C),E          ;Set time constant lo byte
            LD   A,13           ;Select register 13
            OUT  (C),A          ;  = Time constant hi byte
            OUT  (C),D          ;Set time constant hi byte
            OR   0xFF           ;Return success (A=0xFF and NZ flagged)
            RET
@Failed:    XOR  A              ;Return failure (A=0 and Z flagged)
            RET                 ;Abort as invalid baud rate

; Time constant table
; The baud rate clock is generated by setting the time constant
; which is calculated as:
;                      <clock frequency>
; Time constant = ------------------------------  - 2
;                 2 x <clock mode> x <baud rate>
; Clock mode is 1, 16, 32, or 64. We use 1.
; The system clock frequency is 7.3728 MHz.
; This gives the simplified calculation:
;                   3686400
; Time constant = -----------  - 2
;                 <baud rate>
;  +----------+--------------+---------------+---------------+
;  |  Serial  |   Baud rate  | Time constant | Time constant |
;  |    Baud  |        code  |          + 2  |  to be setup  |
;  +----------+--------------+---------------+---------------+
;  |  230400  |   1 or 0x23  |           16  |           14  |
;  |  115200  |   2 or 0x11  |           32  |           30  |
;  |   57600  |   3 or 0x57  |           64  |           62  |
;  |   38400  |   4 or 0x38  |           96  |           94  |
;  |   19200  |   5 or 0x19  |          192  |          190  |
;  |   14400  |   6 or 0x14  |          256  |          254  |
;  |    9600  |   7 or 0x96  |          384  |          382  |
;  |    4800  |   8 or 0x48  |          768  |          766  |
;  |    2400  |   9 or 0x24  |         1536  |         1534  |
;  |    1200  |  10 or 0x12  |         3072  |         3070  |
;  |     600  |  11 or 0x60  |         6144  |         6142  |
;  |     300  |  12 or 0x30  |        12288  |        12286  |
;  +----------+--------------+---------------+---------------+
@TimeCon:   .DW  14             ; 1 = 230400 baud
            .DW  30             ; 2 = 115200 baud
            .DW  62             ; 3 =  57600 baud
            .DW  94             ; 4 =  38400 baud
            .DW  190            ; 5 =  19200 baud
            .DW  254            ; 6 =  14400 baud
            .DW  382            ; 7 =   9600 baud
            .DW  766            ; 8 =   4800 baud
            .DW  1534           ; 9 =   2400 baud
            .DW  3070           ;10 =   1200 baud
            .DW  6142           ;11 =    600 baud
            .DW  12286          ;12 =    300 baud


; **********************************************************************
; Only include the SIO initialisation code once
#IFNDEF     SCC_INIT
#DEFINE     SCC_INIT
; Write initialisation data to SCC
;   On entry: C = Control register I/O address
;   On exit:  DE IX IY I AF' BC' DE' HL' preserved
; Send initialisation data to specified channel
SCC_Setup:  LD   HL,SCCIniData  ;Point to initialisation data
            LD   B,SCCIniDataEnd-SCCIniData ;Length of init data
            OTIR                ;Write data to output port C
            RET
; SCC channel initialisation data
SCCIniData: .DB   0,0b00000000  ; Wr 0  Pointer to R0 + clear other bits
;           .DB   9,0b11000000  ; Wr 9  Hardware reset (both channels)
            .DB   9,0b00000000  ; Wr 9  Clear hardware reset
            .DB   4,0b00000100  ; Wr 4  /1, async, no parity, 1 stop 
            .DB   1,0b00000000  ; Wr 1  No DMA, no interrupts
;           .DB   2,0x00        ; Wr 2  Interrupt vector = 0x00
            .DB   3,0b1100000   ; Wr 3  Disable Rx, 8 bit 
            .DB   5,0b01100000  ; Wr 5  Disable Tx, 8 bit 
;           .DB   9,0b00000001  ; Wr 9  Status low, no interrupts
            .DB  10,0b00000000  ; Wr10  NRZ encoding
            .DB  11,0b01010110  ; Wr11  No Xtal, Use BRG, TRxC o/p
;           .DB  12,30          ; Wr12  Time constant lo = 30
;           .DB  13,0           ; Wr12  Time constant hi = 0
            .DB  14,0b00000011  ; Wr14  Enable BRG
            .DB  15,0b00000000  ; Wr15  Clear interrupt enables
            .DB  10,0b00010000  ; Wr10  Reset interrupts
            .DB   3,0b11000001  ; Wr 3  Enable Rx, 8 bit 
            .DB   5,0b11101000  ; Wr 5  Enable Tx, 8 bit    >>>>68
SCCIniDataEnd:
#ENDIF


; **********************************************************************
; **  End of driver                                                   **
; **********************************************************************






