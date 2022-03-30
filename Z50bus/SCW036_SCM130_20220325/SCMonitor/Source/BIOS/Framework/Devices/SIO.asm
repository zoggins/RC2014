; **********************************************************************
; **  Device Driver                             by Stephen C Cousins  **
; **  Hardware:  Generic                                              **
; **  Interface: Serial Z80 SIO                                       **
; **********************************************************************

; This SCM BIOS framework compliant driver for a Z80 SIO (serial port)

; WARNING: SIO port A must be an odd numbered console devices
;          SIO port B must be an even numbered console devices
;
; SIO too complex to reproduce technical info here. See SIO datasheet

; Externally definitions required:
;kSIOBase:   .EQU 0x80           ;Base address of serial Z80 SIO
;kSIOACont:  .EQU kSIOBase+2     ;I/O address of control register A
;kSIOAData:  .EQU kSIOBase+0     ;I/O address of data register A
;kSIOBCont:  .EQU kSIOBase+3     ;I/O address of control register B
;kSIOBData:  .EQU kSIOBase+1     ;I/O address of data register B
;kSIOFlags:  .EQU 0b00000010     ;Hardware flags = SIO #1
;#DEFINE    SIO_TYPE "(rc) "     ;SIO addressing order etc.


            .CODE


; **********************************************************************
; SCM BIOS framework interface descriptor

            .DB  0              ;Device ID code (not currently used)
            .DW  @String        ;Pointer to device string
            .DW  @SIO_Init      ;Pointer to initialisation code
            .DB  kSIOFlags      ;Hardware flags bit mask
            .DW  @SIO_Set       ;Point to device settings code
            .DB  2              ;Number of console devices
            .DW  @SIO_RxA       ;Pointer to 1st channel input code
            .DW  @SIO_TxA       ;Pointer to 1st channel output code
            .DW  @SIO_RxB       ;Pointer to 2nd channel input code
            .DW  @SIO_TxB       ;Pointer to 2nd channel output code
@String:    .DB  "Z80 SIO "
            #DB  SIO_TYPE
            .DB  "@ "
            .HEXCHAR kSIOBase \ 16
            .HEXCHAR kSIOBase & 15
            .DB  kNull


; **********************************************************************
; Initialise
;   On entry: No parameters required
;   On exit:  Z flagged if device is found and initialised
;             AF BC DE HL not specified
;             IX IY I AF' BC' DE' HL' preserved
; If the device is found it is initialised
@SIO_Init:
; First look to see if the device is present
            IN   A,(kSIOACont)  ;Read status (control) register A
            ;AND  0b00101100    ;Mask for known bits in control reg
            ;CP   0b00101100    ;Test value following masking
            CP   0b01101100     ;Test value following masking
            RET  NZ             ;Return not found NZ flagged
            IN   A,(kSIOBCont)  ;Read status (control) register B
            ;AND  0b00101100    ;Mask for known bits in control reg
            ;CP   0b00101100    ;Test value following masking
            CP   0b01101100     ;Test value following masking
            RET  NZ             ;Return not found NZ flagged
; Device present, so initialise it
            LD   C,kSIOACont    ;SIO channel A control port
            CALL SIO_Set64      ;Initialise chan A with divider = 64
            LD   C,kSIOBCont    ;SIO channel B control port
            JP   SIO_Set64      ;Initialise chan B with divider = 64


; **********************************************************************
; Input character
;   On entry: No parameters required
;   On exit:  A = Character input from the device
;             NZ flagged if character input
;             BC DE HL IX IY I AF' BC' DE' HL' preserved
@SIO_RxA:
            IN   A,(kSIOACont)  ;Address of status register
            BIT  0,A            ;Receive byte available
            RET  Z              ;Return Z if no character
            IN   A,(kSIOAData)  ;Read data byte
            RET
@SIO_RxB:
            IN   A,(kSIOBCont)  ;Address of status register
            BIT  0,A            ;Receive byte available
            RET  Z              ;Return Z if no character
            IN   A,(kSIOBData)  ;Read data byte
            RET


; **********************************************************************
; Output character
;   On entry: A = Character to be output to the device
;   On exit:  If character output successful (eg. device was ready)
;               NZ flagged and A != 0
;             If character output failed (eg. device busy)
;               Z flagged and A = Character to output
;             BC DE HL IX IY I AF' BC' DE' HL' preserved
@SIO_TxA:
            PUSH BC
            LD   C,kSIOACont    ;SIO control register
            IN   B,(C)          ;Read SIO control register
            BIT  2,B            ;Transmit register full?
            POP  BC
            RET  Z              ;Return Z as character not output
            OUT  (kSIOAData),A  ;Write data byte
            OR   0xFF           ;Return success A=0xFF and NZ flagged
            RET
@SIO_TxB:
            PUSH BC
            LD   C,kSIOBCont    ;SIO control register
            IN   B,(C)          ;Read SIO control register
            BIT  2,B            ;Transmit register full?
            POP  BC
            RET  Z              ;Return Z as character not output
            OUT  (kSIOBData),A  ;Write data byte
            OR   0xFF           ;Return success A=0xFF and NZ flagged
            RET


; **********************************************************************
; Device settings
;   On entry: A = Property to set: 1 = Baud rate
;             B = Baud rate code (1 to 12)
;             C = Console device number (1 to 6)
;   On exit:  IF successful: (ie. valid device and baud code)
;               A != 0 and NZ flagged
;             BC DE HL not specified
;             IX IY I AF' BC' DE' HL' preserved
; The baud rate can only be set of there is a CTC channel linked to
; this consolde device.
; WARNING: We assume serial port A is an odd numbered console device
;          and serial port B is an even numbered console device
@SIO_Set:   CP   1              ;Baud rate request?
            JR   NZ,@SetFail    ;No, so failed setting
; Determine which serial port is being set
; B = Baud rate code (1 to 12)
; C = Console device number (1 to 6)
; Look to see if there is a CTC
            LD   A,(iHwFlags)   ;Get current hardware flags
            AND  0b01010000     ;Mask for CTC #1 or #2 hardware
            JR   Z,@SetFail     ;No CTC so failed to set baud rate
; Determine which serial port is being set
; B = Baud rate code (1 to 12)
; C = Console device number (1 to 6)
            LD   A,C            ;Get console device number (1 to 6)
            AND  1              ;SIO port A ?            *** WARNING ***
            LD   A,kSIOACTC     ;CTC register address for port A
            JR   NZ,@SIO_Setup  ;Yes, port A, so skip
            LD   A,kSIOBCTC     ;CTC register address for port B
; Check if this SIO port has a linked CTC channel
; A = CTC channel register address (zero if no linked CTC channel)
; B = Baud rate code (1 to 12)
; C = Console device number (1 to 6)
@SIO_Setup: OR   A              ;Is the CTC register > 0 ?
            JR   Z,@SetFail     ;No, so failed to set baud rate
            PUSH BC
            LD   C,A            ;CTC register address 
            CALL CTC_Baud       ;Set CTC interface baud rate
            POP  BC
; C = Console device number (1 to 6)
; D = Requested SIO divider (16 or 64) - as returned from CTC setting
            LD   A,C            ;Get console device number (1 to 6)
            LD   C,kSIOACont    ;SIO port A control reg  *** WARNING ***
            AND  1              ;SIO port A ?            *** WARNING ***
            JR   NZ,@GotIt      ;Yes, so we have the correct control reg
            LD   C,kSIOBCont    ;SIO port B control reg  *** WARNING ***
; B = Requested SIO divider (16 or 32) - as returned from CTC setting
; C = SIO control register address
@GotIt:     LD   A,D            ;Get requested SIO divider (16 or 64)
            CP   16             ;Divide by 16 requested?
            PUSH AF             ;Preserved Z flag
            CALL Z,SIO_Set16    ;Yes, so set SIO to divide by 16
            POP  AF             ;Restore Z flag
            CALL NZ,SIO_Set64   ;No, so set SIO to divide by 64
            OR   A,0xFF         ;Return success (NZ flagged)
            RET
@SetFail:   XOR  A              ;Return failed (Z flagged)
            RET


; **********************************************************************
; Only include the SIO initialisation code once
#IFNDEF     SIO_INIT
#DEFINE     SIO_INIT
; Write initialisation data to SIO
;   On entry: C = CTC control port I/O address
;   On exit:  DE IX IY I AF' BC' DE' HL' preserved
; Send initialisation data to specified channel
SIO_Set64:  LD   HL,SIOData64   ;Point to initialisation data
            JR   SIO_Setup
SIO_Set16:  LD   HL,SIOData16   ;Point to initialisation data
SIO_Setup:  LD   B,SIOData64End-SIOData64 ;Length of init data
            OTIR                ;Write data to output port C
            RET
; SIO channel initialisation data
SIOData64:  .DB  0b00011000     ; Wr0 Channel reset
;           .DB  0b00000010     ; Wr0 Pointer R2
;           .DB  0x00           ; Wr2 Int vector
            .DB  0b00010100     ; Wr0 Pointer R4 + reset ex st int
            .DB  0b11000100     ; Wr4 /64, async mode, no parity
            .DB  0b00000011     ; Wr0 Pointer R3
            .DB  0b11000001     ; Wr3 Receive enable, 8 bit 
            .DB  0b00000101     ; Wr0 Pointer R5
;           .DB  0b01101000     ; Wr5 Transmit enable, 8 bit 
            .DB  0b11101010     ; Wr5 Transmit enable, 8 bit, flow ctrl
            .DB  0b00010001     ; Wr0 Pointer R1 + reset ex st int
            .DB  0b00000000     ; Wr1 No Tx interrupts
SIOData64End:
SIOData16:  .DB  0b00011000     ; Wr0 Channel reset
;           .DB  0b00000010     ; Wr0 Pointer R2
;           .DB  0x00           ; Wr2 Int vector
            .DB  0b00010100     ; Wr0 Pointer R4 + reset ex st int
            .DB  0b01000100     ; Wr4 /16, async mode, no parity
            .DB  0b00000011     ; Wr0 Pointer R3
            .DB  0b11000001     ; Wr3 Receive enable, 8 bit 
            .DB  0b00000101     ; Wr0 Pointer R5
;           .DB  0b01101000     ; Wr5 Transmit enable, 8 bit 
            .DB  0b11101010     ; Wr5 Transmit enable, 8 bit, flow ctrl
            .DB  0b00010001     ; Wr0 Pointer R1 + reset ex st int
            .DB  0b00000000     ; Wr1 No Tx interrupts
#ENDIF


; **********************************************************************
; **  End of driver                                                   **
; **********************************************************************







