; **********************************************************************
; **  Device Driver                             by Stephen C Cousins  **
; **  Hardware:  Generic                                              **
; **  Interface: Serial 6850 ACIA                                     **
; **********************************************************************

; This module is the driver for a serial I/O interface based on the 
; 6850 Asynchronous Communications Interface Adapter (ACIA)
;
; Control registers (read and write)
; Bit   Control write              Control read
;  0    Counter divide select 1    Receive data register full
;  1    Counter divide select 2    Transmit data register empty
;  2    Word select 1              Data carrier detect (/DCD) input
;  3    Word seelct 2              Clear to send (/CTS) input
;  4    Word select 3              Framing error
;  5    Transmit contol 1          Receiver overrun
;  6    Transmit control 2         Parity error
;  7    Receive interrupt enable   Interrupt request
;
; Control register write
; Bit   7   6   5   4   3   2   1   0
;       |   |   |   |   |   |   |   |
;       |   |   |   |   |   |   0   0     Clock divide 1
;       |   |   |   |   |   |   0   1     Clock divide 16
; >     |   |   |   |   |   |   1   0  >  Clock divide 64
;       |   |   |   |   |   |   1   1     Master reset
;       |   |   |   |   |   |
;       |   |   |   0   0   0     7 data bits, even parity, 2 stop bits
;       |   |   |   0   0   1     7 data bits, odd parity,  2 stop bits
;       |   |   |   0   1   0     7 data bits, even parity, 1 stop bit
;       |   |   |   0   1   1     7 data bits, odd parity,  1 stop bit
;       |   |   |   1   0   0     8 data bits, no parity,   2 stop bits
;       |   |   |   1   0   1  >  8 data bits, no parity,   1 stop bit
;       |   |   |   1   1   0     8 data bits, even parity, 1 stop bit
;       |   |   |   1   1   1     8 data bits, odd parity,  1 stop bit
;       |   |   |
;       |   0   0  >  /RTS = low (ready), tx interrupt disabled
;       |   0   1     /RTS = low (ready), tx interrupt enabled
;       |   1   0     /RTS = high (not ready), tx interrupt disabled 
;       |   1   1     /RTS = low, tx break, tx interrupt disabled
;       |
;       0  >  Receive interrupt disabled
;       1     Receive interrupt enabled
;
; Control register read
; Bit   7   6   5   4   3   2   1   0
;       |   |   |   |   |   |   |   |
;       |   |   |   |   |   |   |   +-------  Receive data register full
;       |   |   |   |   |   |   +-------  Transmit data register empty
;       |   |   |   |   |   +-------  Data carrier detect (/DCD)
;       |   |   |   |   +-------  Clear to send (/CTS)
;       |   |   |   +-------  Framing error
;       |   |   +-------  Receiver overrun 
;       |   +-------  Parity error
;       +-------  Interrupt request

; Externally definitions required:
;kACIABase: .EQU kACIA2         ;I/O base address
;kACIACont: .EQU kACIABase+0    ;I/O address of control register
;kACIAData: .EQU kACIABase+1    ;I/O address of data register

; Hard coded constants don't use EQUs so this file can be included 
; without breaking the use of only local labels (@<label>)
;
; Control register values
;kACIA1Rst: .EQU 0b00000011     ;Master reset
;kACIA1Ini: .EQU 0b00010110     ;No int, RTS low, 8+1, /64
;
; Status (control) register bit numbers
;kACIARxRdy: .EQU 0             ;Receive data available bit number
;kACIATxRdy: .EQU 1             ;Transmit data empty bit number
;
; Device detection, test 1
; This test just reads from the devices' status (control) register
; and looks for register bits in known states:
; /CTS input bit = low
; /DCD input bit = low
; WARNING
; Sometimes at power up the Tx data reg empty bit is zero, but
; recovers after device initialised. So test 1 excludes this bit.
;kACIAMsk1: .EQU  0b00001100    ;Mask for known bits in control reg
;kACIATst1: .EQU  0b00000000    ;Test value following masking
;
; Device detection, test 2
; This test just reads from the devices' status (control) register
; and looks for register bits in known states:
; /CTS input bit = low
; /DCD input bit = low
; Transmit data register empty bit = high
;kACIAMsk2: .EQU  0b00001110    ;Mask for known bits in control reg
;kACIATst2: .EQU  0b00000010    ;Test value following masking


            .CODE

; Interface descriptor
            .DB  0              ;Device ID code (not currently used)
            .DW  @String        ;Pointer to device string
            .DW  @ACIA_Init     ;Pointer to initialisation code
            .DB  kACIAFlags     ;Hardware flags bit mask
            .DW  @ACIA_Set      ;Point to device settings code
            .DB  1              ;Number of console devices
            .DW  @ACIA_RxA      ;Pointer to 1st channel input code
            .DW  @ACIA_TxA      ;Pointer to 1st channel output code
@String:    .DB  "ACIA "
            .DB  "@ "
            .HEXCHAR kACIABase \ 16
            .HEXCHAR kACIABase & 15
            .DB  kNull


; Initialise
;   On entry: No parameters required
;   On exit:  Z flagged if device is found and initialised
;             AF BC DE HL not specified
;             IX IY I AF' BC' DE' HL' preserved
; If the device is found it is initialised
@ACIA_Init:
; First look to see if the device is present
; Test 1, just read from chip, do not write anything
            LD   C,kACIACont    ;Get base address of ACIA
            IN   A,(C)          ;Read status (control) register
            AND  0b00001100     ;Mask for known bits in control reg
            CP   0b00000000     ;and check for known values
            RET  NZ             ;If not found return with NZ flag
; Attempt to initialise the chip
            LD   A,0b00000011   ;Master reset
            OUT  (C),A          ;Write to ACIA control register
            LD   A,0b00010110   ;No int, RTS low, 8+1, /64
            OUT  (C),A          ;Write to ACIA control register
; Test 2, perform tests on chip following initialisation
            IN   A,(C)          ;Read status (control) register
            AND  0b00001110     ;Mask for known bits in control reg
            CP   0b00000010     ;Test value following masking
;           RET  NZ             ;Return not found NZ flagged
            RET                 ;Return Z if found, NZ if not


; Input character
;   On entry: No parameters required
;   On exit:  A = Character input from the device
;             NZ flagged if a character has been found
;             BC DE HL IX IY I AF' BC' DE' HL' preserved
@ACIA_RxA:
            IN   A,(kACIACont)  ;Address of status register
            BIT  0,A            ;Receive byte available
            RET  Z              ;Return Z if no character
            IN   A,(kACIAData)  ;Read data byte
            RET                 ;NZ flagged if character input


; Output character
;   On entry: A = Character to be output to the device
;   On exit:  If character output successful (eg. device was ready)
;               NZ flagged and A != 0
;             If character output failed (eg. device busy)
;               Z flagged and A = Character to output
;             BC DE HL IX IY I AF' BC' DE' HL' preserved
@ACIA_TxA:
            PUSH BC
            LD   C,kACIACont    ;ACIA control register
            IN   B,(C)          ;Read ACIA control register
            BIT  1,B            ;Transmit register full?
            POP  BC
            RET  Z              ;Return Z as character not output
            OUT  (kACIAData),A  ;Write data byte
            OR   0xFF           ;Return success A=0xFF and NZ flagged
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
@ACIA_Set:  XOR  A              ;Return failed to set (Z flagged)
            RET


; **********************************************************************
; **  End of driver                                                   **
; **********************************************************************














