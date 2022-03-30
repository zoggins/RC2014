; **********************************************************************
; **  Z80 SIO Test                              by Stephen C Cousins  **
; **********************************************************************
;
; **  Written as a Small Computer Monitor App 
; **  Version 1.0.0 SCC 2020-03-17
; **  www.scc.me.uk
;
; **********************************************************************
;
; This App tests a Z80 SIO that has a loop-back connections, ie:
;   SIO module's RTS linked to CTS
;   SIO module's TxD linked to RxD
;
; The SIO is assumed to have the register order matching the official
; RC2014 SIO module: Control A, Data A, Control B, Data B
;
; **********************************************************************

            .PROC Z80           ;SCWorkshop select processor
            .HEXBYTES 0x18      ;SCWorkshop Intel Hex output format


; **********************************************************************
; **  Memory map
; **********************************************************************

CodeORG:    .EQU 0x8000         ;Code starts here
DataORG:    .EQU 0x9000         ;Data starts here


; **********************************************************************
; **  Constants
; **********************************************************************

;kSIO:      .EQU 0x80           ;SIO #1 base address
kSIO:       .EQU 0x84           ;SIO #2 base address

kSIOACont:  .EQU kSIO+0         ;I/O address of control register A
kSIOAData:  .EQU kSIO+1         ;I/O address of data register A
kSIOBCont:  .EQU kSIO+2         ;I/O address of control register B
kSIOBData:  .EQU kSIO+3         ;I/O address of data register B

; Status (control) register bit numbers
kSIORxRdy:  .EQU 0              ;Receive data available bit number
kSIOTxRdy:  .EQU 2              ;Transmit data empty bit number
kSIOCts:    .EQU 5              ;Clear to send input bit number



; **********************************************************************
; **  Establish memory sections
; **********************************************************************

            .DATA
            .ORG  DataORG       ;Establish start of data section

            .CODE
            .ORG  CodeORG       ;Establish start of code section


; **********************************************************************
; **  Main program code
; **********************************************************************

; Output program details
            LD   DE,mAbout      ;Pointer to error message
            CALL aOutputText    ;Output "Z80 SIO test..."
            CALL aOutputNewLine ;Output new line
; Initialise SIO
            LD   C,kSIOACont
            CALL SIO_Set64      ;Init port A with divider = 64
            LD   C,kSIOBCont
            CALL SIO_Set64      ;Init port B with divider = 64

; **********************************************************************

; Port A: Data test
            LD   DE,mDataA      ;Pointer to test message
            CALL aOutputText    ;Output "Port A data test"

; Port A: Flush input
FlushA:     IN   A,(kSIOAData)  ;Read data byte
            IN   A,(kSIOACont)  ;Address of status register
            BIT  kSIORxRdy,A    ;Receive byte available
            JR   NZ,FlushA      ;Repeat until no more characters
; Port A: Transmit character
            LD   A,0x55         ;Test character
            OUT  (kSIOAData),A  ;Send character
; Wait 10 ms
            LD   A,10
            CALL aDelayInMS
; Port A: Receive character
            IN   A,(kSIOAData)  ;Read data byte
            CP   0x55           ;Correct character?
            JR   NZ,FailDataA   ;Skip if okay
; Port A: Transmit character
            LD   A,0xAA         ;Test character
            OUT  (kSIOAData),A  ;Send character
; Wait 10 ms
            LD   A,10
            CALL aDelayInMS
; Port B: Receive character
            IN   A,(kSIOAData)  ;Read data byte
            CP   0xAA           ;Correct character?
            JR   NZ,FailDataA   ;Skip if okay
; Port B: Pass
            LD   DE,mPass       ;Pointer to message: Pass
            JR   MsgDataA
; Port B: Fail
FailDataA:  LD   DE,mFail       ;Pointer to message: Fail
MsgDataA:   CALL aOutputText    ;Output port A data result
            CALL aOutputNewLine ;Output new line

; **********************************************************************

; Port B: Data test
            LD   DE,mDataB      ;Pointer to test message
            CALL aOutputText    ;Output "Port B data test"
; Port B: Flush input
FlushB:     IN   A,(kSIOBData)  ;Read data byte
            IN   A,(kSIOBCont)  ;Address of status register
            BIT  kSIORxRdy,A    ;Receive byte available
            JR   NZ,FlushB      ;Repeat until no more characters
; Port B: Transmit character
            LD   A,0x55         ;Test character
            OUT  (kSIOBData),A  ;Send character
; Wait 10 ms
            LD   A,10
            CALL aDelayInMS
; Port B: Receive character
            IN   A,(kSIOBData)  ;Read data byte
            CP   0x55           ;Correct character?
            JR   NZ,FailDataB   ;Skip if okay
; Port B: Transmit character
            LD   A,0xAA         ;Test character
            OUT  (kSIOBData),A  ;Send character
; Wait 10 ms
            LD   A,10
            CALL aDelayInMS
; Port B: Receive character
            IN   A,(kSIOBData)  ;Read data byte
            CP   0xAA           ;Correct character?
            JR   NZ,FailDataB   ;Skip if okay
; Port B: Pass
            LD   DE,mPass       ;Pointer to message: Pass
            JR   MsgDataB
; Port B: Fail
FailDataB:  LD   DE,mFail       ;Pointer to message: Fail
MsgDataB:   CALL aOutputText    ;Output port A data result
            CALL aOutputNewLine ;Output new line


; **********************************************************************

; Port A: Flow control test
            LD   DE,mFlowA      ;Pointer to test message
            CALL aOutputText    ;Output "Port A flow control test"
; Port A: RTS bit high
            LD   A,5
            OUT  (kSIOACont),A  ;Select register 5
            LD   A,0b11101010
            OUT  (kSIOACont),A  ;RTS bit high
            LD   A,0x10
            OUT  (kSIOACont),A  ;Reset ext/status (update from CTS etc)
            IN   A,(kSIOACont)
            BIT  kSIOCts,A      ;CTS bit high?
            JR   Z,FailFlowA    ;No, so fail
; Port A: RTS bit high
            LD   A,5
            OUT  (kSIOACont),A  ;Select register 5
            LD   A,0b11101000
            OUT  (kSIOACont),A  ;RTS bit low
            LD   A,0x10
            OUT  (kSIOACont),A  ;Reset ext/status (update from CTS etc)
            IN   A,(kSIOACont)
            BIT  kSIOCts,A      ;CTS bit low?
            JR   NZ,FailFlowA   ;No, so fail
; Port A: Pass
            LD   DE,mPass       ;Pointer to message: Pass
            JR   MsgFlowA
; Port A: Fail
FailFlowA:  LD   DE,mFail       ;Pointer to message: Fail
MsgFlowA:   CALL aOutputText    ;Output port A flow control result
            CALL aOutputNewLine ;Output new line

; **********************************************************************

; Port B: Flow control test
            LD   DE,mFlowB      ;Pointer to test message
            CALL aOutputText    ;Output "Port B flow control test"
; Port B: RTS bit high
            LD   A,5
            OUT  (kSIOBCont),A  ;Select register 5
            LD   A,0b11101010
            OUT  (kSIOBCont),A  ;RTS bit high
            LD   A,0x10
            OUT  (kSIOBCont),A  ;Reset ext/status (update from CTS etc)
            IN   A,(kSIOBCont)
            BIT  kSIOCts,A      ;CTS bit high?
            JR   Z,FailFlowB    ;No, so fail
; Port B: RTS bit high
            LD   A,5
            OUT  (kSIOBCont),A  ;Select register 5
            LD   A,0b11101000
            OUT  (kSIOBCont),A  ;RTS bit low
            LD   A,0x10
            OUT  (kSIOBCont),A  ;Reset ext/status (update from CTS etc)
            IN   A,(kSIOBCont)
            BIT  kSIOCts,A      ;CTS bit low?
            JR   NZ,FailFlowB   ;No, so fail
; Port B: Pass
            LD   DE,mPass       ;Pointer to message: Pass
            JR   MsgFlowB
; Port B: Fail
FailFlowB:  LD   DE,mFail       ;Pointer to message: Fail
MsgFlowB:   CALL aOutputText    ;Output port B flow control result
            CALL aOutputNewLine ;Output new line


; **********************************************************************

@Finished:  LD   DE,mComplete   ;Test complete ...
            CALL aOutputText    ;Output "Test complete... "
            CALL aOutputNewLine ;Output new line
            RET


; **********************************************************************
; **  Messages
; **********************************************************************

mAbout:     .DB  "Z80 SIO test v1.0 by Stephen C Cousins",0x0D,0x0A
            .DB  "Loop-back connections required:",0x0D,0x0A
            .DB  "- SIO module's RTS linked to CTS",0x0D,0x0A
            .DB  "- SIO module's TxD linked to RxD",0x0D,0x0A
            .DB  0
mDataA:     .DB  "Port A txd/rxd test: ",0
mDataB:     .DB  "Port B txd/rxd test: ",0
mFlowA:     .DB  "Port A rts/cts test: ",0
mFlowB:     .DB  "Port B rts/cts test: ",0
mPass:      .DB  "Pass",0
mFail:      .DB  "Fail",0
mComplete:  .DB  "Test complete",0


; **********************************************************************
; **  Support functions
; **********************************************************************

; Z80 SIO initialisation
;   On entry: C = Control register address
;   On exit:  DE IX IY I AF' BC' DE' HL' preserved
; Send initialisation data to specified channel
Z80_SIO_IniSend:
SIO_Set64:  LD   HL,SIO_Data64  ;Point to initialisation data
            JR   SIO_Init
SIO_Set16:  LD   HL,SIO_Data16  ;Point to initialisation data
SIO_Init:
;           Old code: C = Device number (0 or 1, for SIO A or B)
;           LD   A,kSIOAConT1   ;Get SIO control reg base address
;           ADD  A,C            ;Add console device number (0 or 1)
;           LD   C,A            ;Store SIO channel register address
            LD   B,SIO_Data64End-SIO_Data64 ;Length of init data
            OTIR                ;Write data to output port C
            RET
; SIO channel initialisation data
SIO_Data64: .DB  0b00011000     ; Wr0 Channel reset
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
SIO_Data64End:
SIO_Data16: .DB  0b00011000     ; Wr0 Channel reset
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


; **********************************************************************
; **  Small Computer Monitor API
; **********************************************************************

; API 0x06: Output text string (null terminated)
;   On entry: DE = Pointer to start of null terminated string
;   On exit:  AF BC DE HL IX IY I AF' BC' DE' HL' preserved
aOutputText:
            PUSH AF
            PUSH BC
            PUSH DE
            PUSH HL
            LD   C,0x06         ;API 0x06
            RST  0x30           ;  = Output string
            POP  HL
            POP  DE
            POP  BC
            POP  AF
            RET


; API 0x07: Output new line
;   On entry: No parameters required
;   On exit:  AF BC DE HL IX IY I AF' BC' DE' HL' preserved
aOutputNewLine:
            PUSH AF
            PUSH BC
            PUSH DE
            PUSH HL
            LD   C,0x07         ;API 0x07
            RST  0x30           ;  = Output new line
            POP  HL
            POP  DE
            POP  BC
            POP  AF
            RET


; API 0x0A: Delay in milliseconds
;   On entry: A = Number of milliseconds delay
;   On exit:  AF BC DE HL IX IY I AF' BC' DE' HL' preserved
aDelayInMS
            PUSH AF
            PUSH BC
            PUSH DE
            PUSH HL
            LD   D,0
            LD   E,A
            LD   C, 0x0A        ;API 0x0A
            RST  0x30           ;  = Delay in milliseconds
            POP  HL
            POP  DE
            POP  BC
            POP  AF
            RET


; **********************************************************************
; **  Variables
; **********************************************************************

            .DATA

; none!

            .END



