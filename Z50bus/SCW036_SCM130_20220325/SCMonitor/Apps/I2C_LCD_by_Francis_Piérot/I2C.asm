; **********************************************************************
; **  I2C control functions                     by Stephen C Cousins  **
; **********************************************************************
;
; This code has delays between all I/O operations to ensure it works
; with the slowest I2C devices
;
; I2C transfer sequence
;   +-------+  +---------+  +---------+     +---------+  +-------+
;   | Start |  | Address |  | Data    | ... | Data    |  | Stop  |
;   |       |  | frame   |  | frame 1 |     | frame N |  |       |
;   +-------+  +---------+  +---------+     +---------+  +-------+
;
;
; Start condition                     Stop condition
; Output by master device             Output by master device
;       ----+                                      +----
; SDA       |                         SDA          |
;           +-------                        -------+
;       -------+                                +-------
; SCL          |                      SCL       |
;              +----                        ----+
;
;
; Address frame
; Clock and data output from master device
; Receiving device outputs acknowledge 
; For 8574T  the address of LCD I2C is 0 1 0 0 A2 A1 A0 (20 to 27)
; For 8574TA it's 0 1 1 1 A2 A1 A0 (38 to 3F)
; These bits go into A7 to A1 and are followed by a 0 for R/W
;          +-----+-----+-----+-----+-----+-----+-----+-----+     +---+
; SDA      | A 7 | A 6 | A 5 | A 4 | A 3 | A 2 | A 1 | R/W | ACK |   |
;       ---+-----+-----+-----+-----+-----+-----+-----+-----+-----+   +---
;            +-+   +-+   +-+   +-+   +-+   +-+   +-+   +-+   +-+
; SCL        | |   | |   | |   | |   | |   | |   | |   | |   | |
;       -----+ +---+ +---+ +---+ +---+ +---+ +---+ +---+ +---+ +---------
;
;
; Data frame 
; Clock output by master device
; Data output by transmitting device
; Receiving device outputs acknowledge 
; D7 to D4 are for the 4-bit nibbles of data (send in 2 successive data frames)
; D3 is for backlight control
; D2 is E (start data read/write)
; D1 is R/W (Write when 0)
; D0 is Rs : register select 0=instruction, 1=data
;          +-----+-----+-----+-----+-----+-----+-----+-----+     +---+
; SDA      | D 7 | D 6 | D 5 | D 4 | D 3 | D 2 | D 1 | D 0 | ACK |   |
;       ---+-----+-----+-----+-----+-----+-----+-----+-----+-----+   +---
;            +-+   +-+   +-+   +-+   +-+   +-+   +-+   +-+   +-+
; SCL        | |   | |   | |   | |   | |   | |   | |   | |   | |
;       -----+ +---+ +---+ +---+ +---+ +---+ +---+ +---+ +---+ +---------
;
;
;
; I2C_PORT must be defined before including this file:
; I2C_PORT:   .EQU 0x0C           ;Host I2C port address (SC126)
;
; I2C_Open    Starts I2C sequence with adress frame (device address << 1 in A)
; I2C_Close   Ends sequence
; I2C_Write   Transmit frame (data or instruction)
; I2C_Read    Receive data frame
;**********************************************************************************************

; Org for the code segment must be set by includer
            .CODE

; I2C bus open device
;   On entry: A = Device address (bit zero is read flag)
;             SCL = unknown, SDA = unknown
;   On exit:  If successfully A = 0 and Z flagged
;             If successfully A = Error and NZ flagged
;             SCL = lo, SDA = lo
;             HL IX IY preserved
; Possible errors:  1 = Bus jammed (not implemented)
I2C_Open:   PUSH AF
            CALL I2C_Start      ;Output start condition
            POP  AF
            JR   I2C_Write      ;Write data byte


; I2C bus close device
;   On entry: SCL = unknown, SDA = unknown
;   On exit:  If successfully A=0 and Z flagged
;             If successfully A=Error and NZ flagged
;             SCL = hi, SDA = hi
;             HL IX IY preserved
; Possible errors:  1 = Bus jammed ??????????
I2C_Close:  JR   I2C_Stop       ;Output stop condition


; I2C bus transmit frame (address or data)
;   On entry: A = Data byte, or
;                 Address byte (bit zero is read flag)
;             SCL = low, SDA = low
;   On exit:  If successful A=0 and Z flagged
;                SCL = lo, SDA = lo
;             If unsuccessful A=Error and NZ flagged
;                SCL = high, SDA = high, I2C closed
;             HL IX IY preserved
I2C_Write:  LD   D,A            ;Store byte to be written
            LD   B,8            ;8 data bits, bit 7 first
@Wr_Loop:   RL   D              ;Test M.S.Bit
            JR   C,@Bit_Hi      ;High, so skip
            CALL I2C_SDA_LO     ;SDA low   (SCL lo, SDA = data bit)
            JR   @Bit_Clk
@Bit_Hi:    CALL I2C_SDA_HI     ;SDA high  (SCL lo, SDA = data bit)
@Bit_Clk:   CALL I2C_SCL_HI     ;SCL high  (SCL hi, SDA = data bit)
            CALL I2C_SCL_LO     ;SCL low   (SCL lo, SDA = data bit)
            DJNZ @Wr_Loop
; Test for acknowledge from slave (receiver)
; On arriving here, SCL = lo, SDA = data bit
            CALL I2C_SDA_HI     ;SDA high  (SCL lo, SDA hi/ack)
            CALL I2C_SCL_HI     ;SCL high  (SCL hi, SDA hi/ack)
            CALL I2C_RdPort     ;Read SDA input
            LD   B,A
            CALL I2C_SCL_LO     ;SCL low   (SCL lo, SDA = hi)
            BIT  I2C_SDA_RD,B
            JR   NZ,@NoAck      ;Skip if no acknowledge
            XOR  A              ;Return success A=0 and Z flagged
            RET
; I2C STOP required as no acknowledge
; On arriving here, SCL = lo, SDA = hi
@NoAck:     CALL I2C_SDA_LO     ;SDA low   (SCL lo, SDA = lo)
            CALL I2C_SCL_HI     ;SCL high  (SCL hi, SDA = lo)
            CALL I2C_SDA_HI     ;SDA low   (SCL hi, SDA = hi)
            LD   A,2            ;Return error 2 - No Ack
            OR   A              ;  and NZ flagged
            RET


; I2C bus receive frame (data)
;   On entry: SCL low, SDA low
;   On exit:  If successful A = data byte and Z flagged
;               SCL = low, SDA = low
;             If unsuccessul A = Error and NZ flagged
;               SCL = low, SDA = low ??? no failures supported
;             HL IX IY preserved
I2C_Read:   LD   B,8            ;8 data bits, 7 first
            CALL I2C_SDA_HI     ;SDA high  (SCL lo, SDA hi/input)
@Rd_Loop:   CALL I2C_SCL_HI     ;SCL high  (SCL hi, SDA hi/input)
            CALL I2C_RdPort     ;Read SDA input bit
            SCF                 ;Set carry flag
            BIT  I2C_SDA_RD,A   ;SDA input high?
            JR   NZ,@Rotate     ;Yes, skip with carry flag set
            CCF                 ;Clear carry flag
@Rotate:    RL   D              ;Rotate result into D
            CALL I2C_SCL_LO     ;SCL low   (SCL lo, SDA hi/input)
            DJNZ @Rd_Loop       ;Repeat for all 8 bits
; Acknowledge input byte
; On arriving here, SCL = lo, SDA = hi/input
            CALL I2C_SDA_LO     ;SDA low   (SCL lo, SDA lo)
            CALL I2C_SCL_HI     ;SCL hi    (SCL hi, SDA lo)
            CALL I2C_SCL_LO     ;SCL low   (SCL lo, SDA lo)
            LD   A,D            ;Get data byte received
            CP   A              ;Return success Z flagged
            RET


; I2C bus start
;   On entry: SCL = unknown, SDA = unknown
;   On exit:  SCL = low, SDA = low
;             BC DE HL IX IY preserved
; First ensure SDA and SCL are high
I2C_Start:  CALL I2C_SCL_HI     ;SCL high  (SCL hi, SDA ??)
            CALL I2C_SDA_HI     ;SDA high  (SCL hi, SDA hi)
; Generate I2C start condition
            CALL I2C_SDA_LO     ;SDA low   (SCL hi, SDA lo)
            CALL I2C_SCL_LO     ;SCL low   (SCL lo, SDA lo)
            RET


; I2C bus stop 
;   On entry: SCL = unknown, SDA = unknown
;   On exit:  SCL = high, SDA = high
;             BC DE HL IX IY preserved
; First ensure SDA and SCL are low
I2C_Stop:   CALL I2C_SDA_LO     ;SDA low   (SCL hi, SDA lo)
            CALL I2C_SCL_LO     ;SCL low   (SCL lo, SDA lo)
; Generate stop condition
            CALL I2C_SCL_HI     ;SCL high  (SCL hi, SDA lo)
            CALL I2C_SDA_HI     ;SDA low   (SCL hi, SDA hi)
            RET


; **********************************************************************
; I2C bus simple I/O functions
;   On entry: No parameters required
;   On exit:  BC DE HL IX IY preserved

I2C_SCL_HI: LD   A,(I2C_RAMCPY)
            SET  I2C_SCL_WR,A
            JR   I2C_WrPort

I2C_SCL_LO: LD   A,(I2C_RAMCPY)
            RES  I2C_SCL_WR,A
            JR   I2C_WrPort

I2C_SDA_HI: LD   A,(I2C_RAMCPY)
            SET  I2C_SDA_WR,A
            JR   I2C_WrPort

I2C_SDA_LO: LD   A,(I2C_RAMCPY)
            RES  I2C_SDA_WR,A
            ;JR   I2C_WrPort

; **********************************************************************
; I2C bus write
;   On entry: A byte to send
;   On exit:  BC DE HL IX IY preserved
I2C_WrPort: PUSH BC
            LD   B,0            ;Set up BC for 16-bit
            LD   C,I2C_PORT     ;  I/O address of I2C port
            OUT  (C),A          ;Write A to I2C I/O port
            LD   (I2C_RAMCPY),A ;Write A to RAM copy
            POP  BC
            RET

; **********************************************************************
; I2C bus read
;   On entry: No parameters required
;   On exit:  BC DE HL IX IY preserved, A byte read
I2C_RdPort: PUSH BC
            LD   B,0            ;Set up BC for 16-bit
            LD   C,I2C_PORT     ;  I/O address of I2C port
            IN   A,(C)          ;Read A from I/O port
            POP  BC
            RET


; **********************************************************************
; Workspace / variable in RAM
            .DATA
I2C_RAMCPY: .DB  0