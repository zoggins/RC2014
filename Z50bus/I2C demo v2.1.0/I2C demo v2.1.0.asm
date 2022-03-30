; **********************************************************************
; **  I2C demo       v2.1.0  26-Feb-2021        by Stephen C Cousins  **
; **********************************************************************

; This demonstration and test program is deliberately slow so it works 
; with the slowest I2C devices on the fastest processors.

; The program checks for a number of different I2C devices and performs
; some simple I/O operations on them.

; Default I2C addresses      Device     Write   Read     Alternatives
; =====================      ======     =====   ====     ============
; SC138 Memory card          24LC256    0xAE    0xAF     None
; SC401 Prototyping module   ?          ?       ?        ?
; SC402 Memory module        24xxx      0xA0    0xA1     1010 AAA-
; SC403 Digital I/O module   MCP2318    0x40    0x41     0100 AAA-
; SC404 Digital I/O module   MCP2308    0x42    0x43     0100 AAA-
; SC405 Digital I/O module   PCF8574/A  0x74    0x75     0100 AAA- / 0111 AAA-
; SC406 Temperature sensor   TC74 A5    0x9A    0x9B     Alternative chips
; SC407 Switches and lights  PCF8574/A  0x4E/7E 0x4F/7F  0100 AAA- / 0111 AAA-
;
; Notes: 
; PCF8574 address is 0100 AAA-, while PCF8574A address is 0111 AAA-
; TC74 sensor can be supplied from manufacturer with different addresses

; A legacy code example DEMO_BLOCK can be found below showing how to
; write and read a block of memory. This is not used in the current 
; version of this demonstration and test program.


; **********************************************************************
; Constants

; Configure for target I2C bus master hardware (define only one)
; The default device option is for SC126 or compatible, including SC137 
; when set to I/O address 0x0C.
#DEFINE     SC_DEFAULT          ;Default I2C port at I/O address 0x0C
;#DEFINE    SC137@20            ;SC137 I2C module at address 0x20

; I2C device addresses used by this demonstration and test program:
SC138_ADDR  .EQU 0xAE           ;SC402 Memory card (24xxx)
SC401_ADDR  .EQU 0x00           ;SC401 User defined
SC402_ADDR  .EQU 0xA0           ;SC402 Memory card (24xxx)
SC403_ADDR  .EQU 0x40           ;SC403 Digital I/O module (MCP23018)
SC404_ADDR  .EQU 0x42           ;SC404 Digital I/O module (MCP23008)
SC405_ADDR  .EQU 0x74           ;SC405 Digital I/O module (PCF8574A)
SC406_ADDR  .EQU 0x9A           ;SC406 Temperature sensor (TC74)
SC407_ADDR  .EQU 0x7E           ;SC407 Switches and lights (PCF8574A)

; Memory space
CODE        .EQU  0x8000        ;Program code starts here
DATA        .EQU  0x9000        ;Data starts here


; **********************************************************************
; Main program

            .PROC Z80           ;SCWorkshop select processor
            .ORG  CODE          ;Program starts at this address


            LD   DE,@Msg        ;Address of message string
            CALL StrOut         ;Output string
            
            CALL LIST           ;List addresses of I2C devices found

            CALL SC138          ;SC138 Memory card (eg. 24LCxxx)

            CALL SC402          ;SC402 Memory module (eg. 24LCxxx)

            CALL SC403          ;SC403 Digital I/O (MCP23018)

            CALL SC404          ;SC404 Digital I/O (MCP23008)

            CALL SC405          ;SC405 Digital I/O (PCF8574/A)

            CALL SC406          ;SC406 Temperature sensor TC74

            CALL SC407          ;SC4017 Switches and lights module (PCF8574A)

            RET

@Msg:       .DB  "I2C demo/test v2.1.0 by Stephen C Cousins",0x0D,0x0A,0


; **********************************************************************
; List devices found on the I2C bus
;
; Test each I2C device address and reports any that acknowledge

LIST:       LD   DE,@Msg        ;Address of message string
            CALL StrOut         ;Output string
            LD   D,0            ;First I2C device address to test
@LOOP:      PUSH DE             ;Preserve DE
            LD   A,D            ;Get device address to be tested
            CALL @TEST          ;Test if device is present
            POP  DE             ;Restore DE
            JR   NZ,@NEXT       ;Skip if no acknowledge
            LD   A,D            ;Get address of device tested
            CALL HexOut         ;Output as two character hex 
            CALL SpaceOut       ;Output space character
@NEXT:      INC  D              ;Get next write address
            INC  D
            LD   A,D            ;Address of next device to test
            OR   A              ;Have we tested all addresses?
            JR   NZ,@LOOP       ;No, so loop again
            CALL LineOut        ;Output new line
            RET

; Test if device at I2C address A acknowledges
;   On entry: A = I2C device address (8-bit, bit 0 = lo for write)
;   On exit:  Z flagged if device acknowledges
;             NZ flagged if devices does not acknowledge
@TEST:      CALL I2C_Open       ;Open I2C device for write
            RET  NZ             ;Abort if failed to open
            CALL I2C_Close      ;Close I2C device 
            XOR  A              ;Return with Z flagged
            RET

@Msg:       .DB  "I2C devices found at: ",0


; **********************************************************************
; SC138: Memory card (eg. 24LCxxx)
;
; Function:
;   Writes a test byte and read it back
;   Repeat with inverted test byte

SC138:      LD   A,SC138_ADDR   ;I2C device address
            LD   DE,@Msg        ;Point to report string
            CALL Report         ;Z flagged if device found
            RET  NZ             ;Abort if device not found

            LD   A,SC138_ADDR   ;I2C device address
            LD   HL,0x1234      ;Address in I2C memory chip
            CALL MemTest        ;Test this address
            LD   DE,@Pass       ;Point to pass message
            JR   Z,@Show        ;Skip if passed
            LD   DE,@Fail       ;Point to fail message
@Show:      CALL Result         ;Display test result indented
            CALL LineOut        ;Output new line

            RET

@Msg:       .DB  "SC138 Memory card (eg. 24LCxxx)",0
@Pass:      .DB  "Memory test passed",0
@Fail:      .DB  "Memory test failed",0


; **********************************************************************
; SC402: Memory module (eg. 24LCxxx)
;
; Function:
;   Writes a test byte and read it back
;   Repeat with inverted test byte

SC402:      LD   A,SC402_ADDR   ;I2C device address
            LD   DE,@Msg        ;Point to report string
            CALL Report         ;Z flagged if device found
            RET  NZ             ;Abort if device not found

            LD   A,SC402_ADDR   ;I2C device address
            LD   HL,0x1234      ;Address in I2C memory chip
            CALL MemTest        ;Test this address
            LD   DE,@Pass       ;Point to pass message
            JR   Z,@Show        ;Skip if passed
            LD   DE,@Fail       ;Point to fail message
@Show:      CALL Result         ;Display test result indented
            CALL LineOut        ;Output new line

            RET

@Msg:       .DB  "SC402 Memory module (eg. 24LCxxx)",0
@Pass:      .DB  "Memory test passed",0
@Fail:      .DB  "Memory test failed",0


; **********************************************************************
; SC403: Digital I/O (MCP23018)
; SC404: Digital I/O (MCP23008)
;
; Function:
;   Sets device for:
;       Port A bit 0 = output driven low
;       Port A bits 1 to 7 = inputs
;       Enable weak pull up resistors on all I/O bits
;   Read port and display results 
; The I/O bits are now quasi-bidirectional:
;   Bit 0 is an output driven low
;   Bits 1 to 7 are inputs pulled high with weak pull up resistors
; This example only demonstrates very basic operation of this chip

SC403:      LD   A,SC403_ADDR   ;I2C device address
            LD   DE,@Msg        ;Point to report string
            CALL Report         ;Z flagged if device found
            RET  NZ             ;Abort if device not found

            LD   D,SC403_ADDR   ;I2C device address
            JP   MCP23xxx       ;Go test device

@Msg:       .DB  "SC403 Digital I/O Module (MCP23018)",0


SC404:      LD   A,SC404_ADDR   ;I2C device address
            LD   DE,@Msg        ;Point to report string
            CALL Report         ;Z flagged if device found
            RET  NZ             ;Abort if device not found

            LD   D,SC404_ADDR   ;I2C device address
            JP   MCP23xxx       ;Go test device

@Msg:       .DB  "SC404 Digital I/O Module (MCP23008)",0


; Test device
; On entry:   C = I2C device address
MCP23xxx:
            LD   H,0x0A         ;Register number 0 = I/O control register
            LD   L,0x80         ;Register value = Bits 7 = MCP23018 bank 1 mode
            CALL @Write         ;Write value to register

            LD   H,0            ;Register number 0 = Direction selects
            LD   L,0xFE         ;Register value = Bits 0 out, others in
            CALL @Write         ;Write value to register
            LD   B,L            ;Remember quasi-bidirectional outputs
 
;           LD   D,SC404_ADDR   ;I2C device address
            LD   H,6            ;Register number 6 = Pull up selects
            LD   L,0xFF         ;Register value = Bits 0 to 7 ON
            CALL @Write         ;Write value to register

;           LD   D,SC404_ADDR   ;I2C device address
            LD   H,9            ;Register number 9 = GPIO port
            CALL @Read          ;Read value from register
            LD   DE,@Test       ;Address of message string
            
            LD   H,B            ;Quasi-bidirectional outputs
            CALL Result         ;Display test result indented
            CALL LineOut        ;Output new line
 
            RET

; Write value L to register H
@Write:     LD   A,D            ;I2C device address (write)
            CALL I2C_Open       ;Open for write
            RET  NZ             ;Abort if failure
            LD   A,H            ;Register number
            CALL I2C_Write      ;Send register number
            LD   A,L            ;Register value
            CALL I2C_Write      ;Send register value
            CALL I2C_Stop       ;Generate I2C stop
            RET                 ;Yes, I could just JP I2C_Stop !!

; Returns value in  from register H
@Read:      LD   A,D            ;I2C device address (write)
            CALL I2C_Open       ;Open for write
            RET  NZ             ;Abort if failure
            LD   A,H            ;Register number
            CALL I2C_Write      ;Send register number
            LD   A,D            ;I2C device address (write)
            INC  A              ;Increment to read address
            CALL I2C_Open       ;Open for read
            RET  NZ             ;Abort if failure
            CALL I2C_Read       ;Write I2C device's output bits
            RET  NZ             ;Abort if read failed
            LD   L,A
            CALL I2C_Close      ;Close I2C device 
            RET

@Test:      .DB  "Output = $H, Input = $L",0


; **********************************************************************
; SC405: Digital I/O (PCF8574/A)
;
; Function:
;   All outputs are turned off
;   200ms delay
;   Output bit 7 is turned on
;   I/O bits are read and displayed in hex

SC405:      LD   A,SC405_ADDR   ;I2C device address
            LD   DE,@Msg        ;Point to report string
            CALL Report         ;Z flagged if device found
            RET  NZ             ;Abort if device not found

            LD   H,0x00         ;Prepare all bits low
            CALL @Write         ;Write data byte to device
            CALL @Read          ;Read data byte from device
            LD   DE,@Test       ;Address of message string
            CALL Result         ;Display test result indented
            CALL LineOut        ;Output new line

            LD   DE,200         ;Prepare delay time in milliseconds
            CALL API_Delay      ;Delay 

            LD   H,0xFF         ;Prepare all bits high (for use as inputs)
            CALL @Write         ;Write data byte to device
            CALL @Read          ;Read data byte from device
            LD   DE,@Test       ;Address of message string
            CALL Result         ;Display test result indented
            CALL LineOut        ;Output new line

            RET

; Returns value in L
@Read:      LD   A,SC405_ADDR+1 ;I2C address to write to
            CALL I2C_Open       ;Open I2C device for write
            RET  NZ             ;Abort if failed to open
            CALL I2C_Read       ;Write I2C device's output bits
            RET  NZ             ;Abort if read failed
            LD   L,A
            CALL I2C_Close      ;Close I2C device 
            RET

; Output value H
@Write:     LD   A,SC405_ADDR   ;I2C address to write to
            CALL I2C_Open       ;Open I2C device for write
            RET  NZ             ;Abort if failed to open
            LD   A,H            ;Data byte to be written
            CALL I2C_Write      ;Write I2C device's output bits
            RET  NZ             ;Abort if write failed
            CALL I2C_Close      ;Close I2C device 
            RET

@Msg:       .DB  "SC405 Digital I/O Module (PCF8574)",0
@Test:      .DB  "Output = $H, Input = $L",0


; **********************************************************************
; SC406: Temperature sensor TC74
;
; Function:
;   The temperature is read and displayed in hex (degrees celsius)
;   A second reading is displayed in hex

SC406:      LD   A,SC406_ADDR   ;I2C device address
            LD   DE,@Msg        ;Point to report string
            CALL Report         ;Z flagged if device found
            RET  NZ             ;Abort if device not found

            CALL @Setup         ;Setup temperature sensor
            RET  NZ             ;Abort if sensor not found
; Read temperature and output in hex
            LD   DE,200         ;Delay 200ms for temperature
            CALL API_Delay      ;  to be measured (or read status bit)
            CALL @Read          ;Read temperature code
            LD   H,E            ;Get temperature code
; Read again (just because we can!)
            LD   DE,200         ;Delay 200ms for temperature
            CALL API_Delay      ;  to be measured (or read status bit)
            CALL @Read          ;Read temperature code
            LD   L,E            ;Get temperature code
; Read again (just because we can!)
            LD   DE,200         ;Delay 200ms for temperature
            CALL API_Delay      ;  to be measured (or read status bit)
            CALL @Read          ;Read temperature code
            LD   B,E            ;Get temperature code
; Output result
            LD   DE,@Test       ;Point to result string
            CALL Result         ;Display test result indented
            CALL LineOut        ;Output new line
            RET

; Set up temperature sensor TC74 
;   On entry: No parameters required
;             SCL = unknown, SDA = unknown
;   On exit:  If successfully A = 0 and Z flagged
;             If unsuccessfully A = Error and NZ flagged
;             IX IY preserved
@Setup:     LD   A,SC406_ADDR   ;I2C address to write to
            CALL I2C_Open       ;Open for write
            RET  NZ             ;Abort if failure
            LD   A,1            ;Command = Configure
            CALL I2C_Write      ;Send command
            LD   A,0            ;Configure = Normal mode
            CALL I2C_Write      ;Send command
            CALL I2C_Stop       ;Generate I2C stop
            RET

; Read temperature sensor TC74
;   On entry: No parameters required
;             SCL = unknown, SDA = unknown
;   On exit:  If successfully A = 0 and Z flagged
;                E = Temperature code
;             If unsuccessfully A = Error and NZ flagged
;             IX IY preserved
@Read:      LD   A,SC406_ADDR   ;I2C address to write to
            CALL I2C_Open       ;Open for write
            RET  NZ             ;Abort if failure
            LD   A,0            ;Command = Read temperature
            CALL I2C_Write      ;Send command
            LD   A,SC406_ADDR+1 ;I2C address to be read from
            CALL I2C_Open       ;Open for read
            XOR  A              ;Do not acknowledge read
            CALL I2C_Read       ;Read byte from I2C memory
            LD   E,A            ;Store data byte read
            CALL I2C_Stop       ;Generate I2C stop
            RET                 ;Yes, I could just JP I2C_Stop !!

@Msg:       .DB  "SC406 Temperature Sensor Module (TC74)",0
@Test:      .DB  "Temparature 'C (in hex) = $H $L $B",0


; **********************************************************************
; SC407: Switches and lights module (PCF8574A)
;
; Function:
;   All outputs are turned off
;   200ms delay
;   Output bit 7 is turned on
;   I/O bits are read and displayed in hex

SC407:      LD   A,SC407_ADDR   ;I2C device address
            LD   DE,@Msg        ;Point to report string
            CALL Report         ;Z flagged if device found
            RET  NZ             ;Abort if device not found

            LD   H,0x00         ;Prepare all bits low
            CALL @Write         ;Write data byte to device
            CALL @Read          ;Read data byte from device
            LD   DE,@Test       ;Address of message string
            CALL Result         ;Display test result indented
            CALL LineOut        ;Output new line

            LD   DE,200         ;Prepare delay time in milliseconds
            CALL API_Delay      ;Delay 

            LD   H,0xFF         ;Prepare all bits high (for use as inputs)
            CALL @Write         ;Write data byte to device
            CALL @Read          ;Read data byte from device
            LD   DE,@Test       ;Address of message string
            CALL Result         ;Display test result indented
            CALL LineOut        ;Output new line

            RET

; Returns value in L
@Read:      LD   A,SC407_ADDR+1 ;I2C address to write to
            CALL I2C_Open       ;Open I2C device for write
            RET  NZ             ;Abort if failed to open
            CALL I2C_Read       ;Write I2C device's output bits
            RET  NZ             ;Abort if read failed
            LD   L,A
            CALL I2C_Close      ;Close I2C device 
            RET

; Output value H
@Write:     LD   A,SC407_ADDR   ;I2C address to write to
            CALL I2C_Open       ;Open I2C device for write
            RET  NZ             ;Abort if failed to open
            LD   A,H            ;Data byte to be written
            CALL I2C_Write      ;Write I2C device's output bits
            RET  NZ             ;Abort if write failed
            CALL I2C_Close      ;Close I2C device 
            RET

@Msg:       .DB  "SC407 Switches and Lights Module (PCF8574)",0
@Test:      .DB  "Output = $H, Input = $L",0


; **********************************************************************
; Single byte random access read and write to memory chip (ie. 24LC256)
;
; This test writes a test byte to a location in the memory chip, waits a
; while, then reads it back. It then repeats the test with an inverted 
; test byte.

; Random access single byte memory test
;   On entry: A = I2C device address 
;             HL = Address to be tested within I2C memory chip
;   On exit:  If successfully A = 0 and Z flagged
;             If unsuccessfully A = Error and NZ flagged
;             IX IY preserved
MemTest:    LD   D,A            ;I2C device address to test
            LD   E,0x55         ;Byte to be written
            CALL @Test          ;Test this pattern
            RET  NZ             ;Abort if error
            LD   E,0xAA         ;Byte to be written
            CALL @Test          ;Test this pattern
            RET  NZ             ;Abort if error
            XOR  A              ;Ensure A=0 and Z flagged for success
            RET

; Write byte and read it back
;   On entry: E = Byte to be written
;             HL = Address within chip to be tested
;   On exit:  If successfully A = 0 and Z flagged
;             If unsuccessfully A = Error and NZ flagged
;             BC DE HL IX IY preserved
; This routine writes a test byte to a location in the memory chip, 
; waits a while, then reads it back. 
@Test:      CALL @MWr           ;Write to I2C memory
            JR   NZ,@Fail       ;Abort if error
            PUSH DE             ;Preserve DE
            LD   DE,50
            CALL API_Delay      ;Delay 50ms
            POP  DE             ;Restore DE
            CALL @MRd           ;Read from I2C memory
            JR   NZ,@Fail       ;Abort if error
            CP   E              ;Is it correct?
            RET                 ;Return z flagged if test passed
@Fail:      OR   A,0xFF         ;Return NZ flagged as test failed
            RET

; Random access single byte write
;   On entry: D = I2C device address
;             E = Byte to be written
;             HL = Address to be written
;             SCL = unknown, SDA = unknown
;   On exit:  If successfully A = 0 and Z flagged
;             If unsuccessfully A = Error and NZ flagged
;             BC DE HL IX IY preserved
; This routine only tests for I2C failure on initial device open!
@MWr:       LD   A,D            ;I2C address to write to
            CALL I2C_Open       ;Open for write
            RET  NZ             ;Abort if failure
            LD   A,H            ;Address (hi) in memory chip
            CALL I2C_Write      ;Send address hi byte
            LD   A,L            ;Address (lo) in memory chip
            CALL I2C_Write      ;Send address lo byte
            LD   A,E            ;Byte to be written to memory
            CALL I2C_Write      ;Write data byte to memory chip
            CALL I2C_Stop       ;Generate I2C stop
            RET                 ;Yes, I could just JP I2C_Stop !!


; Random access single byte read
;   On entry: D = I2C device address
;             HL = Address to be read
;             SCL = unknown, SDA = unknown
;   On exit:  A = Data byte read from memory
;             If successfully A = 0 and Z flagged
;             If unsuccessfully A = Error and NZ flagged
;             BC DE HL IX IY preserved
; This routine only tests for I2C failure on initial device open!
@MRd:       LD   A,D            ;I2C device address (write)
            CALL I2C_Open       ;Open for write
            RET  NZ             ;Abort if failure
            LD   A,H            ;Address (hi) in memory chip
            CALL I2C_Write      ;Send address hi byte
            LD   A,L            ;Address (lo) in memory chip
            CALL I2C_Write      ;Send address lo byte
            LD   A,D            ;I2C device address (write)
            INC  A              ;Increment to read address
            CALL I2C_Open       ;Open for read
            XOR  A              ;Do not acknowledge read
            CALL I2C_Read       ;Read byte from I2C memory
            PUSH AF             ;Preserve AF
            CALL I2C_Stop       ;Generate I2C stop
            POP  AF             ;Restore AF
            CP   A              ;Z flagged as successful
            RET


; **********************************************************************
; Block access read and write to 24LC256
;
; This demo writes a block of memory to the 24LC256, then reads it back
; to RAM for checking.

I2CA_BLOCK: .EQU 0xAE           ;I2C device addess: 24LC256
TIMEOUT:    .EQU 10000          ;Timeout loop counter

DEMO_BLOCK: LD   HL,0x0000      ;Start of data in ROM
            LD   DE,0x1000      ;Start of data in 24LC256
            LD   BC,0x800       ;Number of bytes to copy
            CALL I2C_MemWr      ;Write a block from ROM to I2C memory
            LD   DE,200
            CALL API_Delay      ;Delay 200ms
            LD   HL,RESULTS     ;Start of data in RAM
            LD   DE,0x1000      ;Start of data in 24LC256
            LD   BC,0x800       ;Number of bytes to copy
            CALL I2C_MemRd      ;Read a block from I2C memory to RAM
            RET


; Copy a block from I2C memory to CPU memory
;   On entry: DE = First address in I2C memory
;             HL = First address in CPU memory
;             BC = Number of bytes to be copied
;             SCL = unknown, SDA = unknown
;   On exit:  If successfully A = 0 and Z flagged
;             If unsuccessfully A = Error and NZ flagged
;             IX IY preserved
I2C_MemRd:  PUSH BC
            LD   BC,TIMEOUT     ;Timeout loop counter
@Repeat:    LD   A,I2CA_BLOCK   ;I2C address to write to
            CALL I2C_Open       ;Open for write
            JR   Z,@Ready       ;If open okay then skip on
            DEC  BC
            LD   A,B
            OR   C              ;Timeout?
            JR   NZ,@Repeat     ;No, so go try again
            POP  BC
            LD   A,ERR_TOUT     ;Error code
            OR   A              ;Error, so NZ flagged
            RET                 ;Return with error
; Device opened okay
@Ready:     POP  BC             ;Restore byte counter
            LD   A,D            ;Address (hi) in I2C memory
            CALL I2C_Write      ;Write address
            LD   A,E            ;Address (lo) in I2C memory
            CALL I2C_Write      ;Write address
            LD   A,I2CA_BLOCK+1 ;I2C device to be read from
            CALL I2C_Open       ;Open for read
            RET  NZ             ;Abort if error
@Read:      DEC  BC             ;Decrement byte counter
            LD   A,B
            OR   C              ;Last byte to be read?
            CALL I2C_Read       ;Read byte with no ack on last byte
            LD   (HL),A         ;Write byte in CPU memory
            INC  HL             ;Increment CPU memory pointer
            LD   A,B
            OR   C              ;Finished?
            JR   NZ,@Read       ;No, so go read next byte
            CALL I2C_Stop       ;Generate I2C stop
            XOR  A              ;Return with success (Z flagged)
            RET


; Copy a block from CPU memory to I2C memory
;   On entry: DE = First address in I2C memory
;             HL = First address in CPU memory
;             BC = Number of bytes to be copied
;             SCL = unknown, SDA = unknown
;   On exit:  If successfully A = 0 and Z flagged
;             If unsuccessfully A = Error and NZ flagged
;             IX IY preserved
; The 24LC64 requires blocks of data to be written in 64 byte (or less)
; pages.
I2C_MemWr:  PUSH BC
            LD   BC,TIMEOUT     ;Timeout loop counter
@Repeat:    LD   A,I2CA_BLOCK   ;I2C address to write to
            CALL I2C_Open       ;Open for write
            JR   Z,@Ready       ;If open okay then skip on
            DEC  BC
            LD   A,B
            OR   C              ;Timeout?
            JR   NZ,@Repeat     ;No, so go try again
            POP  BC
            LD   A,ERR_TOUT     ;Error code
            OR   A              ;Error, so NZ flagged
            RET                 ;Return with error
; Device opened okay
@Ready:     POP  BC             ;Restore byte counter
@Block:     LD   A,D            ;Address (hi) in I2C memory
            CALL I2C_Write      ;Write address
            LD   A,E            ;Address (lo) in I2C memory
            CALL I2C_Write      ;Write address
@Write:     LD   A,(HL)         ;Get data byte from CPU memory
            CALL I2C_Write      ;Read byte from I2C memory
            INC  HL             ;Increment CPU memory pointer
            INC  DE             ;Increment I2C memory pointer
            DEC  BC             ;Decrement byte counter
            LD   A,B
            OR   C              ;Finished?
            JR   Z,@Store       ;Yes, so go store this page
            LD   A,E            ;Get address in I2C memory (lo byte)
            AND  63             ;64 byte page boundary?
            JR   NZ,@Write      ;No, so go write another byte
@Store:     CALL I2C_Stop       ;Generate I2C stop
            LD   A,B
            OR   C              ;Finished?
            JR   NZ,I2C_MemWr   ;No, so go write some more
            RET                 ;Return success A=0 and Z flagged


; **********************************************************************
; Utility functions

; Test if device is present.
;   On entry: A = Address of device on I2C bus (write address)
;   On exit:  Z flagged if device found, NZ if not found
;             IX IY preserved
Test:       CALL I2C_Open       ;Open I2C device for write
            RET  NZ             ;Abort if failed to open
            PUSH AF
            CALL I2C_Close      ;Close I2C device 
            POP  AF
            RET


; Output string at DE with substitutions
;   On entry: A = Address of device on I2C bus (write address)
;             DE = Address of null terminated string
;             H = Value to substitute for $H
;             L = Value to substitute for $L
;             B = Value to substitute for $B
;   On exit:  DE = Address of next location after this string
;             IX IY preserved
String:     LD   A,(DE)         ;Get character from string
            INC  DE             ;Point to next character in string
            OR   A              ;Null ?
            RET  Z              ;Yes, so we're done
            CP   '$'            ;Substitue value?
            JR   Z,@Subst       ;Yes, so go handle substitution
            CALL CharOut        ;Output character to console
            JR   String         ;Go get next character from string
@Subst:     LD   A,(DE)         ;Get character from string
            INC  DE             ;Point to next character in string
            OR   A              ;Null ?
            RET  Z              ;Yes, so we're done
            CP   'H'            ;Register H
            JR   NZ,@NotH       ;No, so skip
            LD   A,H            ;Get value 'H'
            JR   @GotIt         ;Go output it in hex
@NotH:      CP   'L'            ;Register L
            JR   NZ,@NotL       ;No, so skip
            LD   A,L            ;Get value 'L'
            JR   @GotIt         ;Go output it in hex
@NotL:      CP   'B'            ;Register B
            JR   NZ,@NotB       ;No, so skip
            LD   A,B            ;Get value 'L'
            ;JR   @GotIt        ;Go output it in hex
@GotIt:     CALL HexOut         ;Output write address in hex
@NotB:      JR   String         ;Go get next character from string


; Display device report, ie.
;   SC407 Switches and Lights Module at Write=<XX> Read=<XX+1>
;         <demo/test> result
;   On entry: A = Address of device on I2C bus (write address)
;             DE = Address of null terminated string
;   On exit:  AF preserved (Z flagged if device founf)
;             IX IY preserved
Report:     LD   H,A            ;Store device write address
            INC  A              ;Increment to read address
            LD   L,A            ;Store device read address
            CALL String         ;Output start of supplied string (at DE)
            LD   DE,@Address    ;Point to string
            CALL String         ;Output "Write="
            CALL LineOut        ;Output new line
            LD   A,H            ;Get device write address
            CALL Test           ;Test if device is present
            RET  Z              ;Return if device found
            LD   DE,@NotFound   ;Point ot string
            CALL Result         ;Output "<indent>Device not found"
            CALL LineOut        ;Output new line
            RET
@Address:   .DB  " at Write=$H Read=$L",0
@NotFound:  .DB  "Device not found",0


; Display test result
;   On entry: DE = Address of null terminated string
;             H = First value ($H)
;             L = Second value ($L)
;   On exit:  HL IX IY preserved
Result:     PUSH BC
            LD   B,6            ;Size of indent in characters
@Loop:      CALL SpaceOut       ;Output indent (spaces) to console
            DJNZ @Loop          ;Repeat 'B' times
            POP  BC
            JP   String         ;Output result string to console


; Character output to console
;   On entry: A = Character to be output
;   On exit:  BC DE HL IX IY preserved
CharOut:    JP   API_Cout

; New line output to console
;   On entry: No parameters required
;   On exit:  BC DE HL IX IY preserved
LineOut:    JP   API_Lout

; Space character ouput to console
;   On entry: No parameters required
;   On exit:  BC DE HL IX IY preserved
SpaceOut:   LD   A,0x20
            JP   API_Cout

; String output to console
;   On entry: DE = Address of string
;   On exit:  BC DE HL IX IY preserved
StrOut:     JP   API_Sout

; Hex byte output to console
;   On entry: A = Byte to be output in hex
;   On exit:  BC DE HL IX IY preserved
HexOut:     PUSH AF             ;Preserve byte to be output
            RRA                 ;Shift top nibble to
            RRA                 ;  botom four bits..
            RRA
            RRA
            AND  0x0F           ;Mask off unwanted bits
            CALL @Hex           ;Output hi nibble
            POP  AF             ;Restore byte to be output
            AND  0x0F           ;Mask off unwanted bits
; Output nibble as ascii character
@Hex:       CP   0x0A           ;Nibble > 10 ?
            JR   C,@Skip        ;No, so skip
            ADD  A,7            ;Yes, so add 7
@Skip:      ADD  A,0x30         ;Add ASCII '0'
            JP   API_Cout       ;Write character


; **********************************************************************
; Small computer monitor API

; Delay by DE milliseconds (approx)
;   On entry: DE = Delay time in milliseconds
;   On exit:  BC DE HL IX IY preserved
API_Delay:  PUSH BC             ;Preserve registers
            PUSH DE
            PUSH HL
            LD   C,0x0A         ;API 0x0A = Delay by DE milliseconds
            RST  0x30           ;Call API
            POP  HL             ;Restore registers
            POP  DE
            POP  BC
            RET


; Character output to console device
;   On entry: A = Character to be output
;   On exit:  BC DE HL IX IY preserved
API_Cout:   PUSH BC             ;Preserve registers
            PUSH DE
            PUSH HL
            LD   C,0x02         ;API 0x02 = Character output
            RST  0x30           ;Call API
            POP  HL             ;Restore registers
            POP  DE
            POP  BC
            RET


; New line output to console device
;   On entry: No parameters required
;   On exit:  BC DE HL IX IY preserved
API_Lout:   PUSH BC             ;Preserve registers
            PUSH DE
            PUSH HL
            LD   C,0x07         ;API 0x07 = New line output
            RST  0x30           ;Call API
            POP  HL             ;Restore registers
            POP  DE
            POP  BC
            RET


; String output to console device
;   On entry: DE = Address of string
;   On exit:  BC DE HL IX IY preserved
API_Sout:   PUSH BC             ;Preserve registers
            PUSH DE
            PUSH HL
            LD   C,0x06         ;API 0x06 = String output
            RST  0x30           ;Call API
            POP  HL             ;Restore registers
            POP  DE
            POP  BC
            RET


; **********************************************************************
; I2C support functions

; I2C bus open device
;   On entry: A = Device address (bit zero is read flag)
;             SCL = unknown, SDA = unknown
;   On exit:  If successfully A = 0 and Z flagged
;             If unsuccessfully A = Error and NZ flagged
;             BC DE HL IX IY preserved
I2C_Open:   PUSH AF
            CALL I2C_Start      ;Output start condition
            POP  AF
            JR   I2C_Write      ;Write data byte


; I2C bus close device
;   On entry: SCL = unknown, SDA = unknown
;   On exit:  If successfully A=0 and Z flagged
;             If unsuccessfully A=Error and NZ flagged
;             SCL = hi, SDA = hi
;             BC DE HL IX IY preserved
I2C_Close:  JP   I2C_Stop       ;Output stop condition


; **********************************************************************
; **********************************************************************
; I2C bus master driver
; **********************************************************************
; **********************************************************************

; Functions provided are:
;     I2C_Start
;     I2C_Stop
;     I2C_Read
;     I2C_Write
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
;        +-----+-----+-----+-----+-----+-----+-----+-----+     +---+
; SDA    | A 7 | A 6 | A 5 | A 4 | A 3 | A 2 | A 1 | R/W | ACK |   |
;     ---+-----+-----+-----+-----+-----+-----+-----+-----+-----+   +---
;          +-+   +-+   +-+   +-+   +-+   +-+   +-+   +-+   +-+
; SCL      | |   | |   | |   | |   | |   | |   | |   | |   | |
;     -----+ +---+ +---+ +---+ +---+ +---+ +---+ +---+ +---+ +---------
;
;
; Data frame 
; Clock output by master device
; Data output by transmitting device
; Receiving device outputs acknowledge 
;        +-----+-----+-----+-----+-----+-----+-----+-----+     +---+
; SDA    | D 7 | D 6 | D 5 | D 4 | D 3 | D 2 | D 1 | D 0 | ACK |   |
;     ---+-----+-----+-----+-----+-----+-----+-----+-----+-----+   +---
;          +-+   +-+   +-+   +-+   +-+   +-+   +-+   +-+   +-+
; SCL      | |   | |   | |   | |   | |   | |   | |   | |   | |
;     -----+ +---+ +---+ +---+ +---+ +---+ +---+ +---+ +---+ +---------
;


; **********************************************************************
; I2C constants


; I2C bus master interface
; The default device option is for SC126 or compatible
#IFDEF      SC_DEFAULT
#DEFINE     SC126
#ENDIF
#IFDEF      SC126
I2C_PORT:   .EQU 0x0C           ;Host I2C port address
I2C_SDA_WR: .EQU 7              ;Host I2C write SDA bit number
I2C_SDA_RD: .EQU 7              ;Host I2C read SDA bit number
I2C_SCL_WR: .EQU 0              ;Host I2C write SCL bit number
;2C_SCL_RD: .EQU 0              ;Host I2C read SCL bit number (not supported)
I2C_QUIES:  .EQU 0b10001101     ;Host I2C control port quiescent value
#ENDIF
#IFDEF      SC137@20
I2C_PORT:   .EQU 0x20           ;Host I2C port address
I2C_SDA_WR: .EQU 7              ;Host I2C write SDA bit number
I2C_SDA_RD: .EQU 7              ;Host I2C read SDA bit number
I2C_SCL_WR: .EQU 0              ;Host I2C write SCL bit number
I2C_SCL_RD: .EQU 0              ;Host I2C read SCL bit number 
I2C_QUIES:  .EQU 0b10000001     ;Host I2C output port quiescent value
#ENDIF

; I2C support constants
ERR_NONE:   .EQU 0              ;Error = None
ERR_JAM:    .EQU 1              ;Error = Bus jammed [not used]
ERR_NOACK:  .EQU 2              ;Error = No ackonowledge
ERR_TOUT:   .EQU 3              ;Error = Timeout


; **********************************************************************
; Hardware dependent I2C bus functions


; I2C bus transmit frame (address or data)
;   On entry: A = Data byte, or
;                 Address byte (bit zero is read flag)
;             SCL = low, SDA = low
;   On exit:  If successful A=0 and Z flagged
;                SCL = lo, SDA = lo
;             If unsuccessful A=Error and NZ flagged
;                SCL = high, SDA = high, I2C closed
;             BC DE HL IX IY preserved
I2C_Write:  PUSH BC             ;Preserve registers
            PUSH DE
            LD   D,A            ;Store byte to be written
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
            POP  DE             ;Restore registers
            POP  BC
            XOR  A              ;Return success A=0 and Z flagged
            RET
; I2C STOP required as no acknowledge
; On arriving here, SCL = lo, SDA = hi
@NoAck:     CALL I2C_SDA_LO     ;SDA low   (SCL lo, SDA = lo)
            CALL I2C_SCL_HI     ;SCL high  (SCL hi, SDA = lo)
            CALL I2C_SDA_HI     ;SDA low   (SCL hi, SDA = hi)
            POP  DE             ;Restore registers
            POP  BC
            LD   A,ERR_NOACK    ;Return error = No Acknowledge
            OR   A              ;  and NZ flagged
            RET


; I2C bus receive frame (data)
;   On entry: A = Acknowledge flag
;               If A != 0 the read is acknowledged
;             SCL low, SDA low
;   On exit:  If successful A = data byte and Z flagged
;               SCL = low, SDA = low
;             If unsuccessul* A = Error and NZ flagged
;               SCL = low, SDA = low
;             BC DE HL IX IY preserved
; *This function always returns successful
I2C_Read:   PUSH BC             ;Preserve registers
            PUSH DE
            LD   E,A            ;Store acknowledge flag
            LD   B,8            ;8 data bits, 7 first
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
            LD   A,E            ;Get acknowledge flag
            OR   A              ;A = 0? (indicates no acknowledge)
            JR   Z,@NoAck       ;Yes, so skip acknowledge
            CALL I2C_SDA_LO     ;SDA low   (SCL lo, SDA lo)
@NoAck:     CALL I2C_SCL_HI     ;SCL hi    (SCL hi, SDA lo)
            CALL I2C_SCL_LO     ;SCL low   (SCL lo, SDA lo)
            LD   A,D            ;Get data byte received
            POP  DE             ;Restore registers
            POP  BC
            CP   A              ;Return success Z flagged
            RET


; I2C bus start
;   On entry: SCL = unknown, SDA = unknown
;   On exit:  SCL = low, SDA = low
;             A = 0 and Z flagged as we always succeed
;             BC DE HL IX IY preserved
; First ensure SDA and SCL are high
I2C_Start:  CALL I2C_INIT       ;Initialise I2C control port
;           CALL I2C_SCL_HI     ;SCL high  (SCL hi, SDA ??)
;           CALL I2C_SDA_HI     ;SDA high  (SCL hi, SDA hi)
; Generate I2C start condition
            CALL I2C_SDA_LO     ;SDA low   (SCL hi, SDA lo)
            CALL I2C_SCL_LO     ;SCL low   (SCL lo, SDA lo)
            XOR  A              ;Return success A=0 and Z flagged
            RET


; I2C bus stop 
;   On entry: SCL = unknown, SDA = unknown
;   On exit:  SCL = high, SDA = high
;             A = 0 and Z flagged as we always succeed
;             BC DE HL IX IY preserved
; First ensure SDA and SCL are low
I2C_Stop:   CALL I2C_SDA_LO     ;SDA low   (SCL hi, SDA lo)
            CALL I2C_SCL_LO     ;SCL low   (SCL lo, SDA lo)
; Generate stop condition
            CALL I2C_SCL_HI     ;SCL high  (SCL hi, SDA lo)
            CALL I2C_SDA_HI     ;SDA low   (SCL hi, SDA hi)
            XOR  A              ;Return success A=0 and Z flagged
            RET


; **********************************************************************
; I2C bus simple I/O functions
;   On entry: No parameters required
;   On exit:  BC DE HL IX IY preserved

I2C_INIT:   LD   A,I2C_QUIES    ;I2C control port quiescent value
            JR   I2C_WrPort

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

I2C_WrPort: PUSH BC             ;Preserve registers
            LD   B,0            ;Set up BC for 16-bit
            LD   C,I2C_PORT     ;  I/O address of I2C port
            OUT  (C),A          ;Write A to I2C I/O port
            LD   (I2C_RAMCPY),A ;Write A to RAM copy
            POP  BC             ;Restore registers
            RET

I2C_RdPort: PUSH BC             ;Preserve registers
            LD   B,0            ;Set up BC for 16-bit
            LD   C,I2C_PORT     ;  I/O address of I2C port
            IN   A,(C)          ;Read A from I/O port
            POP  BC             ;Restore registers
            RET


; **********************************************************************
; I2C workspace / variables in RAM

            ORG  DATA

I2C_RAMCPY: .DB  0              ;RAM copy of output port

RESULTS:    .DB  0              ;Large block of results can start here

