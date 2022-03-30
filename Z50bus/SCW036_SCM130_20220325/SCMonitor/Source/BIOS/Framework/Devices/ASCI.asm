; **********************************************************************
; **  Device Driver                             by Stephen C Cousins  **
; **  Hardware:  Generic                                              **
; **  Interface: Serial Z180 ASCI                                     **
; **********************************************************************

; This SCM BIOS framework compliant driver for the Z180's ASCI (asynch-
; ronous serial communications interface)

; WARNING: ASCI port A must be an odd numbered console devices
;          ASCI port B must be an even numbered console devices
;
; ASCI too complex to reproduce technical info here. See ASCI datasheet

; Externally definitions required:
;kASCIBase: .SET CNTLA0         ;I/O base address
;kASCIACoA: .SET kASCIBase+0    ;I/O address of chan A control register A
;kASCIACoB: .SET kASCIBase+2    ;I/O address of chan A control register B
;kASCIASta: .SET kASCIBase+4    ;I/O address of chan A status register
;kASCIATxd: .SET kASCIBase+6    ;I/O address of chan A tx data register
;kASCIARxd: .SET kASCIBase+8    ;I/O address of chan A rx data register
;kASCIBCoA: .SET kASCIBase+1    ;I/O address of chan B control register A
;kASCIBCoB: .SET kASCIBase+3    ;I/O address of chan B control register B
;kASCIBSta: .SET kASCIBase+5    ;I/O address of chan B status register
;kASCIBTxd: .SET kASCIBase+7    ;I/O address of chan B tx data register
;kASCIBRxd: .SET kASCIBase+9    ;I/O address of chan B rx data register


            .CODE


; **********************************************************************
; SCM BIOS framework interface descriptor

            .DB  0              ;Device ID code (not currently used)
            .DW  @String        ;Pointer to device string
            .DW  @ASCI_Init     ;Pointer to initialisation code
            .DB  kASCIFlag      ;Hardware flags bit mask
            .DW  @ASCI_Set      ;Point to device settings code
            .DB  2              ;Number of console devices
            .DW  @ASCI_RxA      ;Pointer to 1st channel input code
            .DW  @ASCI_TxA      ;Pointer to 1st channel output code
            .DW  @ASCI_RxB      ;Pointer to 2nd channel input code
            .DW  @ASCI_TxB      ;Pointer to 2nd channel output code
@String:    .DB  "Z180 ASCI "
            .DB  "@ "
            .HEXCHAR kASCIBase \ 16
            .HEXCHAR kASCIBase & 15
            .DB  kNull


; **********************************************************************
; Initialise
;   On entry: No parameters required
;   On exit:  Z flagged if device is found and initialised
;             AF BC DE HL not specified
;             IX IY I AF' BC' DE' HL' preserved
; If the device is found it is initialised
@ASCI_Init:
#IF         PROCESSOR = "Z180"
            XOR  A              ;Set Z flag (success)
            RET                 ;  and return
#ELSE
            OR   0xFF           ;Set NZ flag (failure)
            RET                 ;  and return
#ENDIF


; **********************************************************************
; Input character
;   On entry: No parameters required
;   On exit:  A = Character input from the device
;             NZ flagged if a character has been found
;             BC DE HL IX IY I AF' BC' DE' HL' preserved
@ASCI_RxA:
            IN0  A,(kASCIASta)  ;Read serial port status register
            BIT  ST_RDRF,A      ;Receive register full?
            RET  Z              ;Return Z as no character available
            IN0  A,(kASCIARxd)  ;Read data byte
            RET
@ASCI_RxB:
            IN0  A,(kASCIBSta)  ;Read serial port status register
            BIT  ST_RDRF,A      ;Receive register full?
            RET  Z              ;Return Z as no character available
            IN0  A,(kASCIBRxd)  ;Read data byte
            RET


; **********************************************************************
; Output character
;   On entry: A = Character to be output to the device
;   On exit:  If character output successful (eg. device was ready)
;               NZ flagged and A != 0
;             If character output failed (eg. device busy)
;               Z flagged and A = Character to output
;             BC DE HL IX IY I AF' BC' DE' HL' preserved
@ASCI_TxA:
            PUSH BC             ;Preserve BC
            IN0  B,(kASCIASta)  ;Read serial port status register
            BIT  ST_TDRE,B      ;Transmit register empty?
            POP  BC             ;Restore BC
            RET  Z              ;Return Z as character not output
            OUT0 (kASCIATxd), A ;Write byte to serial port
            OR   0xFF           ;Return success A=0xFF and NZ flagged
            RET
@ASCI_TxB:
            PUSH BC             ;Preserve BC
            IN0  B,(kASCIBSta)  ;Read serial port status register
            BIT  ST_TDRE,B      ;Transmit register empty?
            POP  BC             ;Restore BC
            RET  Z              ;Return Z as character not output
            OUT0 (kASCIBTxd), A ;Write byte to serial port
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
@ASCI_Set:  CP   1              ;Baud rate?
            JR   NZ,@Failed     ;No, so go return failure
; WARNING: We assume serial port A is an odd numbered console device
;          and serial port B is an even numbered console device
; Determine which serial port is being set
; B = Baud rate code (1 to 12)
; C = Console device number (1 to 6)
            LD   A,B            ;Get baud rate code
; Search for baud rate in table
; A = Baud rate code  (not verified)
; C = Console device number (1 to 6)  (not verified)
            LD   HL,@BaudTable  ;Start of baud rate table
            LD   B,13           ;Number of table entries
@Search:    CP   (HL)           ;Record for required baud rate?
            JR   Z,@Found       ;Yes, so go get time constant
            CP   B              ;Record number = baud rate code?
            JR   Z,@Found       ;Yes, so go get time constant
            INC  HL             ;Point to next record
            DJNZ @Search        ;Repeat until end of table
@Failed:    XOR  A              ;Return failure (A=0 and Z flagged)
            RET                 ;Abort as invalid baud rate
; Found location in table
; B = Baud code (1 to 13)  (verified)
; C = Console device number (1 to 6)  (not verified)
; (HL) = Serial hardware settings  (verified)
@Found:     LD   HL,@SettingsTable-1
            LD   E,B            ;Get baud rate code (1 to 13)
            LD   D,0
            ADD  HL,DE          ;Calculate address in table
            XOR  A              ;Clear in case of unsupported rate
            BIT  7,(HL)         ;Supported rate?
            RET  Z              ;No, so failure (A=0 and Z flagged)
; B = Baud code (1 to 13)  (verified)
; C = Console device number (1 to 6)  (not verified)
; (HL) = Serial hardware CNTLB# register value
            LD   A,C            ;Get console device number (1 to 6)
            AND  1              ;SIO port A (odd number) ?   *** WARNING ***
            LD   A,(HL)         ;Get register value
            JR   Z,@PortB       ;No, not port A, so skip
            OUT0 (kASCIACoB),A  ;Set port A baud rate
            JR   @BaudSet       ;Go return success
@PortB:     OUT0 (kASCIBCoB),A  ;Set port B baud rate
@BaudSet:   OR   0xFF           ;Return success (A=0xFF and NZ flagged)
            RET
;
; Baud rate table 
; Position in table matches value of short baud rate code (1 to 13)
; The table data bytes is the long baud rate code (eg. 0x96 for 9600)
@BaudTable: .DB  0x15           ;13 =    150
            .DB  0x30           ;12 =    300
            .DB  0x60           ;11 =    600
            .DB  0x12           ;10 =   1200
            .DB  0x24           ; 9 =   2400
            .DB  0x48           ; 8 =   4800
            .DB  0x96           ; 7 =   9600
            .DB  0x14           ; 6 =  14400
            .DB  0x19           ; 5 =  19200
            .DB  0x38           ; 4 =  38400
            .DB  0x57           ; 3 =  57600
            .DB  0x11           ; 2 = 115200
            .DB  0x23           ; 1 = 230400
;
; Serial hardware register settings table
; Settings to generate supported baud rates:
;  +----------+-------------+-----------+-----------+-------------+
;  |  Serial  |  Baud rate  | Sampling  | Prescaler |   Baudrate  |
;  |    Baud  |       code  |  Divider  |   Divider |    Divider  |
;  +----------+-------------+-----------+-----------+-------------+
;  |  230400* |  1 or 0x23  |       16  |       10  |        n/a  |
;  |  115200  |  2 or 0x11  |       16  |       10  |          1  |
;  |   57600  |  3 or 0x57  |       16  |       10  |          2  |
;  |   38400  |  4 or 0x38  |       16  |       30  |          1  |
;  |   19200  |  5 or 0x19  |       16  |       30  |          2  |
;  |   14400  |  6 or 0x14  |       16  |       10  |          8  |
;  |    9600  |  7 or 0x96  |       64  |       30  |          1  |
;  |    4800  |  8 or 0x48  |       64  |       30  |          2  |
;  |    2400  |  9 or 0x24  |       64  |       30  |          4  |
;  |    1200  | 10 or 0x12  |       64  |       30  |          8  |
;  |     600  | 11 or 0x60  |       64  |       30  |         16  |
;  |     300  | 12 or 0x30  |       64  |       30  |         32  |
;  |     150  | 13 or 0x15  |       64  |       30  |         64  |
;  +----------+-------------+-----------+-----------+-------------+
; The table data bytes are the Z180's CNTLB# register value:
;   bit 5 = prescaler, 0 = /10, 1 = /30
;   bit 3 = sampling divider, 0 = /16, 1 = /64
;   bits 0 to 2 = baud rate divider 0 = /1, 1 = /2, ... 6 = /64
;   bit 7 is set for supported baud rates
@Sam16      .EQU 0 + 128
@Sam64      .EQU 8 + 128
@Pre10      .EQU 0
@Pre30      .EQU 32
@Div1       .EQU 0
@Div2       .EQU 1
@Div4       .EQU 2
@Div8       .EQU 3
@Div16      .EQU 4
@Div32      .EQU 5
@Div64      .EQU 6
@SettingsTable:                 ;Code,  Baud,  Sample, Prescal, BRDivide
            .DB  0              ; 1 = 230400 (not supported)
            .DB  @Sam16 + @Pre10 + @Div1  ; 2 = 115200
            .DB  @Sam16 + @Pre10 + @Div2  ; 3 =  57600
            .DB  @Sam16 + @Pre30 + @Div1  ; 4 =  38400
            .DB  @Sam16 + @Pre30 + @Div2  ; 5 =  19200
            .DB  @Sam16 + @Pre10 + @Div8  ; 6 =  14400
            .DB  @Sam64 + @Pre30 + @Div1  ; 7 =   9600
            .DB  @Sam64 + @Pre30 + @Div2  ; 8 =   4800
            .DB  @Sam64 + @Pre30 + @Div4  ; 9 =   2400
            .DB  @Sam64 + @Pre30 + @Div8  ;10 =   1200
            .DB  @Sam64 + @Pre30 + @Div16 ;11 =    600
            .DB  @Sam64 + @Pre30 + @Div32 ;12 =    300
            .DB  @Sam64 + @Pre30 + @Div64 ;13 =    150


; **********************************************************************
; **  Z180's internal baud rate generator

; Common baud rates:
; 115200, 57600, 38400, 19200, 9600, 4800, 2400, 1200, 600, 300
;
; Baud rate = PHI/(baud rate divider x prescaler x sampling divider)
;   PHI = CPU clock input / 1 = 18.432/1 MHz = 18.432 MHz
;   Baud rate divider (1,2,4,8,16,32,or 64) = 1
;   Prescaler (10 or 30) = 10
;   Sampling divide rate (16 or 64) = 16
; Baud rate = 18,432,00 / ( 1 x 10 x 16) = 18432000 / 160 = 115200 baud
;
; Possible baud rates and dividers based on 18.432 MHz clock:
;  +----------+-----------+-----------+-----------+-------------+
;  |  Serial  |    Total  | Sampling  | Prescaler |   Baudrate  |
;  |    Baud  |  Divider  |  Divider  |   Divider |    Divider  |
;  +----------+-----------+-----------+-----------+-------------+
;  |  230400* |       80  |       16  |       10  |        n/a  |
;  |  115200  |      160  |       16  |       10  |          1  |
;  |   57600  |      320  |       16  |       10  |          2  |
;  |   38400  |      480  |       16  |       30  |          1  |
;  |   19200  |      960  |       16  |       30  |          2  |
;  |   14400  |     1280  |       16  |       10  |          8  |
;  |    9600  |     1920  |       16  |       30  |          4  |
;  |    4800  |     3840  |       16  |       30  |          8  |
;  |    2400  |     7680  |       16  |       30  |         16  |
;  |    1200  |    15360  |       16  |       30  |         32  |
;  |     600  |    30720  |       16  |       30  |         64  |
;  |     300* |    61440  |       16  |       30  |        n/a  |
;  +----------+-----------+-----------+-----------+-------------+
;  |   19200* |      960  |       64  |       30  |        n/a  |
;  |   14400  |     1280  |       64  |       10  |          2  |
;  |    9600  |     1920  |       64  |       30  |          1  |
;  |    4800  |     3840  |       64  |       30  |          2  |
;  |    2400  |     7680  |       64  |       30  |          4  |
;  |    1200  |    15360  |       64  |       30  |          8  |
;  |     600  |    30720  |       64  |       30  |         16  |
;  |     300  |    61440  |       64  |       30  |         32  |
;  |     150  |   122880  |       64  |       30  |         64  |
;  +----------+-----------+-----------+-----------+-------------+
; * = Can not be generated baud rate in this configuration.
;
; We use the following:
;  +----------+-----------+-----------+-----------+-------------+
;  |  115200  |      160  |       16  |       10  |          1  |
;  |   57600  |      320  |       16  |       10  |          2  |
;  |   38400  |      480  |       16  |       30  |          1  |
;  |   19200  |      960  |       16  |       30  |          2  |
;  |   14400  |     1280  |       16  |       10  |          8  |
;  +----------+-----------+-----------+-----------+-------------+
;  |    9600  |     1920  |       64  |       30  |          1  |
;  |    4800  |     3840  |       64  |       30  |          2  |
;  |    2400  |     7680  |       64  |       30  |          4  |
;  |    1200  |    15360  |       64  |       30  |          8  |
;  |     600  |    30720  |       64  |       30  |         16  |
;  |     300  |    61440  |       64  |       30  |         32  |
;  |     150  |   122880  |       64  |       30  |         64  |
;  +----------+-----------+-----------+-----------+-------------+


; **********************************************************************
; **  End of driver                                                   **
; **********************************************************************










