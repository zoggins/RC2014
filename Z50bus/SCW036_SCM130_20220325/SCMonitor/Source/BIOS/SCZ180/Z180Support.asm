; **********************************************************************
; **  Z180 Support                              by Stephen C Cousins  **
; **  BIOS: SCZ180                                                    **
; **********************************************************************


; **********************************************************************
; **  Z180 register constants
; **********************************************************************

kZ180:      .EQU kZ180Base      ;Z180 internal register base address

CNTLA0:     .EQU kZ180 + 0x00   ;ASCI Channel Control Register A chan 0
CNTLA1:     .EQU kZ180 + 0x01   ;ASCI Channel Control Register A chan 1
CNTLB0:     .EQU kZ180 + 0x02   ;ASCI Channel Control Register B chan 0
CNTLB1:     .EQU kZ180 + 0x03   ;ASCI Channel Control Register B chan 1
STAT0:      .EQU kZ180 + 0x04   ;ASCI Status Register channel 0
STAT1:      .EQU kZ180 + 0x05   ;ASCI Status Register channel 1
TDR0:       .EQU kZ180 + 0x06   ;ASCI Transmit Data Register channel 0
TDR1:       .EQU kZ180 + 0x07   ;ASCI Transmit Data Register channel 1
RDR0:       .EQU kZ180 + 0x08   ;ASCI Receive Register channel 0
RDR1:       .EQU kZ180 + 0x09   ;ASCI Receive Register channel 1
CNTR:       .EQU kZ180 + 0x0A   ;CSI/O Contol/Status Register
TRDR:       .EQU kZ180 + 0x0B   ;CSI/O Transmit/Receive Data Register
TMDR0L:     .EQU kZ180 + 0x0C   ;Timer Data Register Channel 0 Low
TMDR0H:     .EQU kZ180 + 0x0D   ;Timer Data Register Channel 0 High
RLDR0L:     .EQU kZ180 + 0x0E   ;Timer Reload Register Channel 0 Low
RLDR0H:     .EQU kZ180 + 0x0F   ;Timer Reload Register Channel 0 High
TCR:        .EQU kZ180 + 0x10   ;Timer Control Register

ASCI0:      .EQU kZ180 + 0x12   ; ASCI Extension Control Register 0
ASCI1:      .EQU kZ180 + 0x13   ; ASCI Extension Control Register 1
TMDR1L:     .EQU kZ180 + 0x14   ;Timer Data Register Channel 1 Low
TMDR1H:     .EQU kZ180 + 0x15   ;Timer Data Register Channel 1 High
RLDR1L:     .EQU kZ180 + 0x16   ;Timer Reload Register Channel 1 Low
RLDR1H:     .EQU kZ180 + 0x17   ;Timer Reload Register Channel 1 High
FRC:        .EQU kZ180 + 0x18   ;Free Running Counter (read only)

ASTC0L:     .EQU kZ180 + 0x1A   ;ASCI Time Constant Register ch 0 Low
ASTC0H:     .EQU kZ180 + 0x1B   ;ASCI Time Constant Register ch 0 High
ASTC1L:     .EQU kZ180 + 0x1C   ;ASCI Time Constant Register ch 1 Low
ASTC1H:     .EQU kZ180 + 0x1D   ;ASCI Time Constant Register ch 1 High
CMR:        .EQU kZ180 + 0x1E   ;Clock Multiplier Register
CCR         .EQU kZ180 + 0x1F   ;CPU Control Register
SAR0L:      .EQU kZ180 + 0x20   ;DMA Source Address Register ch 0 Low
SAR0H:      .EQU kZ180 + 0x21   ;DMA Source Address Register ch 0 High
SAR0B:      .EQU kZ180 + 0x22   ;DMA Source Address Register ch 0 B
DAR0L:      .EQU kZ180 + 0x23   ;DMA Destination Address Reg ch 0 Low
DAR0H:      .EQU kZ180 + 0x24   ;DMA Destination Address Reg ch 0 High
DAR0B:      .EQU kZ180 + 0x25   ;DMA Destination Address Reg ch 0 B
BCR0L:      .EQU kZ180 + 0x26   ;DMA Byte Count Register channel 0 Low
BCR0H:      .EQU kZ180 + 0x27   ;DMA Byte Count Register channel 0 High
MAR1L:      .EQU kZ180 + 0x28   ;DMA Memory Address Register ch 1 Low
MAR1H:      .EQU kZ180 + 0x29   ;DMA Memory Address Register ch 1 High
MAR1B:      .EQU kZ180 + 0x2A   ;DMA Memory Address Register ch 1 B
IAR1L:      .EQU kZ180 + 0x2B   ;DMA I/O Address Register channel 1 Low
IAR1H:      .EQU kZ180 + 0x2C   ;DMA I/O Address Register channel 1 High
IAR1B:      .EQU kZ180 + 0x2D   ;DMA I/O Address Register channel 1 B
BCR1L:      .EQU kZ180 + 0x2E   ;DMA Byte Count Register channel 1 Low
BCR1H:      .EQU kZ180 + 0x2F   ;DMA Byte Count Register channel 1 High
DSTAT:      .EQU kZ180 + 0x30   ;DMA Status Register
DMODE:      .EQU kZ180 + 0x31   ;DMA Mode Register
DCNTL:      .EQU kZ180 + 0x32   ;DMA/WAIT Control Register
IL:         .EQU kZ180 + 0x33   ;Interrupt Vector Register
ITC:        .EQU kZ180 + 0x34   ;INT/TRAP Control Register

RCR:        .EQU kZ180 + 0x36   ;Refresh Control Register

CBR:        .EQU kZ180 + 0x38   ;MMU Control Base Register
BBR:        .EQU kZ180 + 0x39   ;MMU Bank Base Register
CBAR:       .EQU kZ180 + 0x3A   ;MMU Common/Bank Register

OMCR:       .EQU kZ180 + 0x3E   ;Operation Mode Control Register
ICR:        .EQU kZ180 + 0x3F   ;I/O Control Register

; **********************************************************************
; Serial status register bits

ST_RDRF:    .EQU 7              ;Receive data register Full
ST_TDRE:    .EQU 1              ;Transmit data register empty


; **********************************************************************
; **  Public functions                                                **
; **********************************************************************

            .CODE

Z180Init:   

; ALREADY DONE DURING SELF TEST
; Position Z180 internal I/O at 0xC0 to 0xFF
            ;LD   A,0xC0        ;Start of Z180 internal I/O
            ;OUT0 (ICR),A

; ALREADY DONE DURING SELF TEST
; Initialise Memory Management Unit (MMU)
; Initialise logical (64k) memory to physical (1M) memory mapping
; such that the bottom 32k bytes of logical memory is the bottom 32k
; bytes of the physical Flash ROM, and the top 32k bytes of logical 
; memory is the near the bottom of the physical RAM. This arrangement
; means when 64k of logical RAM is required it occupies the bottom 
; 64k of physical RAM.
;    Common(0) 0x0000 to 0x0000 -> 0x00000 to 0x00000 (ROM)
;    Bank      0x0000 to 0x7FFF -> 0x00000 to 0x07FFF (ROM)
;    Common(1) 0x8000 to 0xFFFF -> 0x88000 to 0x8FFFF (RAM) *
; This is achieved by setting the registers as follows:
;    CBAR = CA.BA = 0x8.0x0 = 0x80
;    BBR  = (physical address)/0x1000 - BA = 0x00 - 0x0 = 0x00
;    CBR  = (physical address)/0x1000 - BA = 0x88 - 0x8 = 0x80
;           LD   A, 0x00        ;Physical memory base address:
;           OUT0 (BBR), A       ;  Bank Base   = 0x00000 to 0x07FFF
;           LD   A, 0x80        ;Physical memory base address:
;           OUT0 (CBR), A       ;  Common Base = 0x88000 to 0x8FFFF
;           LD   A, 0x80        ;Logical memory base addresses:
;           OUT0 (CBAR), A      ;  Bank = 0x0000, Common = 0x8000

; Initialise Z180 serial port 0
;
; Baud rate = PHI/(baud rate divider x prescaler x sampling divider)
;   PHI = CPU clock input / 1 = 18.432/1 MHz = 18.432 MHz
;   Baud rate divider (1,2,4,8,16,32,or 64) = 1
;   Prescaler (10 or 30) = 10
;   Sampling divide rate (16 or 64) = 16
; Baud rate = 18,432,00 / ( 1 x 10 x 16) = 18432000 / 160 = 115200 baud
;
; ASCI Control Register A for channel 0 (CNTLA0, CNTLA1)
;   Bit 7 = 0    Multiprocessor Mode Enable (MPE)
;   Bit 6 = 1    Receiver Enable (RE)
;   Bit 5 = 1    Transmitter Enable (TE)
;   Bit 4 = 0    Request to Send Output (RTS0) (0 = Low, 1 = High)
;   Bit 3 = 0    Multiprocessor Bit Receive/Error Flag (MPBR) (0 = Reset)
;   Bit 2 = 1    Data Format (0 = 7-bit, 1 = 8-bit)
;   Bit 1 = 0    Parity (0 = No Parity, 1 = Parity Enabled)
;   Bit 0 = 0    Stop Bits (0 = 1 Stop Bit, 1 = 2 Stop Bits)
            LD   A, 0b01100100
            OUT0 (CNTLA0), A
; And the same for channel 1 
            OUT0 (CNTLA1), A

; ASCI Control Register B for channel 0 (CNTLB0, CNTLB1)
;   Bit 7 = 0    Multiprocessor Bit Transmit (MPBT)
;   Bit 6 = 0    Multiprocessor Mode (MP)
;   Bit 5 = 0    Clear to Send/Prescale (CTC/PS) (0 = PHI/10, 1 = PHI/30)
;   Bit 4 = 0    Parity Even Odd (PEO) (0 = Even, 1 = Odd)
;   Bit 3 = 0    Divide Ratio (DR) (0 = divide 16, 1 = divide 64)
;   Bit 2 = 000  Source/Speed Select (SS2-SS0)
;    to 0        (0 = /1, 1 = /2, .. 6 = /64, 7 = External clock)
            LD   A, 0b00000000
            OUT0 (CNTLB0), A
; And the same for channel 1 
            OUT0 (CNTLB1), A

; ASCI Status Register (STAT0, STAT1)
;   Bit 7 = 0    Read data register full (1 = Full, 0 = Empty)
;   Bit 6 = 0    Overrun Error (1 = Error, 0 = No error)
;   Bit 5 = 0    Parity Error (1 = Error, 0 = No error)
;   Bit 4 = 0    Framing Error (1 = Error, 0 = No error)
;   Bit 3 = 0    Receive Interrupt Enable (1 = Enabled, 0 = Disabled)
;   Bit 2 = 0    Data Carrier Detect (1 = DCD pin Hi, 0 = DCD pin Lo)
;   Bit 1 = 0    Clear To Send (1 = Selects CTS, 0 = Selects RXS)
;   Bit 0 = 0    Transmit Data Register Empty (1 = Empty, 0 = Full)

; ASCI Extension Control Register (ASCI0, ASCI1) [Z8S180/L180-class processors only)
;   Bit 7 = 0    Reserved
;   Bit 6 = 1    DCD0 Disable (0 = DCD0 Auto-enable Rx, 1 = Advisory)
;   Bit 5 = 1    CTS0 Disable (0 = CTS0 Auto-enable Tx, 1 = Advisory)
;   Bit 4 = 0    X1 Bit Clock (0 = CKA0/16 or 64, 1 = CKA0 is bit clock)
;   Bit 3 = 0    BRG0 Mode (0 = As S180, 1 = Enable 16-BRG counter)
;   Bit 2 = 0    Break Feature (0 = Enabled, 1 = Disabled)
;   Bit 1 = 0    Break Detect (0 = On, 1 = Off)
;   Bit 0 = 0    Send Break (0 = Normal transmit, 1 = Drive TXA Low)
            LD   A, 0b01100000
            OUT0 (ASCI0), A
; And the same for channel 1 
            OUT0 (ASCI1), A

; Refresh Control Register (RCR)
;   Bit 7 = 0    Refresh Enable (REFE) (0 = Disabled, 1 = Enabled)
;   Bit 6 = 0    Refresh Wait (REFW) (0 = 2 clocksm 3 = 3 clocks)
;   Bit 1-0 = 0  Cycle Interval (CYC1-0) 
            LD   A, 0b00000000
            OUT0 (RCR), A       ;Turn off memory refresh

; DMA/WAIT Control Register (DCNTL)
;   Bit 7-6 = 00 Memory Wait Insertion (MWI1-0) (0 to 3 wait states)
;   Bit 5-4 = 11 I/O Wait Insertion (IWI1-0) (0 to 3 wait states) 
;   Bit 3 = 0    DMA Request Sense ch 1 (DMS1) (0 = Level, 1 = Edge)
;   Bit 2 = 0    DMA Request Sense ch 0 (DMS0) (0 = Level, 1 = Edge)
;   Bit 1 = 0    DMA Channel 1 Mode (DIM1) (0 = Mem to I/O, 1 = I/O to Mem)
;   Bit 0 = 0    DMA Channel 0 Mode (DIM0) (0 = MARI+1, 1 = MARI-1)
;   Bit 3-2 = 00 DMA Request Sense (DMS1-0) (0 = Level, 1 = Edge)
            LD   A, 0b00110000
            OUT0 (DCNTL), A     ;Maximum wait states for I/O and Memory

; Operating Mode Control Register (OMCR)
;   Bit 7 = 0    M1 Enable (M1E) (1 = Default, 0 = Z80 compatibility mode)
;   Bit 6 = 0    M1 Temporary Enable (M1TE) (1 = Default, 0 = Z80 mode)
;   Bit 5 = 0    I/O Compatibility (IOC) (1 = Default, 0 = Z80 mode)
;   Bits 4-0 = 0 Reserved
            LD   A, 0b00000000
            OUT0 (OMCR), A      ;Select Z80 compatibility mode

; CPU Control Register (CCR)
;   Bit 7 = 1    CPU Clock Divide (0 = Divide 2, 1 = Divide 1)
;   Bit 6+3 = 0  Standy/Idle Mode (00 = No Standby, 01 = ...)
;   Bit 5 = 0    Bus Request Exit (0 = Ignore in standby, 1 = Exit on BR)
;   Bit 4 = 0    PHI Clock Drive (0 = Standard, 1 = 33%)
;   Bit 3+6 = 0  Standy/Idle Mode (00 = No Standby, 01 = ...)
;   Bit 2 = 0    External I/O Drive (0 = Standard, 1 = 33%)
;   Bit 1 = 0    Control Signal Drive (0 = Standard, 1 = 33%)
;   Bit 0 = 0    Address and Data Drive (0 = Standard, 1 = 33%)
            LD   A, 0b10000000
            OUT0 (CCR), A

; Set reload registers for 1ms timer
; Timer input clock is PHI/20 = 18,432,000MHz/20 = 921.6kHz
; Relead time to give 1ms timer is 921.6 (0x039A when rounded up)
            LD   A,0x9A
            OUT0 (RLDR0L),A
            LD   A,0x03
            OUT0 (RLDR0H),A

; Timer Control Register
;   Bit 7 = 0    Timer 1 interrupt flag
;   Bit 6 = 0    Timer 0 interrupt flag
;   Bit 5 = 0    Timer 1 interrupt enable
;   Bit 4 = 0    Timer 0 interrupt enable
;   Bit 3-2 = 00 Inhibit timer output on A18/Tout
;   Bit 1 = 0    Timer 1 down count enable
;   Bit 0 = 1    Timer 0 down count enable
            LD   A,0b00000001
            OUT0 (TCR),A

            RET


; **********************************************************************
; **  Z180's internal timer 0

; Poll timer
;   On entry: No parameters required
;   On exit:  If 1ms event to be processed NZ flagged and A != 0
;             BC DE HL IX IY I AF' BC' DE' HL' preserved
; This function polls a hardware timer and returns a flag is a
; 1ms event needs processing.
H_PollT2:   IN0  A,(TMDR0H)
            IN0  A,(TCR)
            AND  A,0x40
            RET


; **********************************************************************
; **  Public workspace (in RAM)                                       **
; **********************************************************************

;           .DATA

;           .CODE








