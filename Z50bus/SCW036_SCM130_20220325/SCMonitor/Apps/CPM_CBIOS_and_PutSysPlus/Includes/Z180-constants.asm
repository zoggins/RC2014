
; Defined externally
;kZ180:     .EQU 0xC0           ;Z180 internal register base address

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
ASCI0:      .EQU kZ180 + 0x12   ;ASCI Extension Control Register 0
ASCI1:      .EQU kZ180 + 0x13   ;ASCI Extension Control Register 1
ASTC0L:     .EQU kZ180 + 0x1A   ;ASCI Time Constant Register ch 0 Low
ASTC0H:     .EQU kZ180 + 0x1B   ;ASCI Time Constant Register ch 0 High
ASTC1L:     .EQU kZ180 + 0x1C   ;ASCI Time Constant Register ch 1 Low
ASTC1H:     .EQU kZ180 + 0x1D   ;ASCI Time Constant Register ch 1 High
CMR:        .EQU kZ180 + 0x1E   ;Clock Multiplier Register
CCR         .EQU kZ180 + 0x1F   ;CPU Control Register
DCNTL:      .EQU kZ180 + 0x32   ;DMA/WAIT Control Register
IL:         .EQU kZ180 + 0x33   ;Interrupt Vector Register
ITC:        .EQU kZ180 + 0x34   ;INT/TRAP Control Register
CBR:        .EQU kZ180 + 0x38   ;MMU Control Base Register
BBR:        .EQU kZ180 + 0x39   ;MMU Bank Base Register
CBAR:       .EQU kZ180 + 0x3A   ;MMU Common/Bank Register
OMCR:       .EQU kZ180 + 0x3E   ;Operation Mode Control Register
ICR:        .EQU kZ180 + 0x3F   ;I/O Control Register



kASCIBase:  .SET kZ180          ;I/O base address

kASCIACoA:  .SET kASCIBase+0    ;I/O address of chan A control register A
kASCIACoB:  .SET kASCIBase+2    ;I/O address of chan A control register B
kASCIASta:  .SET kASCIBase+4    ;I/O address of chan A status register
kASCIATxd:  .SET kASCIBase+6    ;I/O address of chan A tx data register
kASCIARxd:  .SET kASCIBase+8    ;I/O address of chan A rx data register

kASCIBCoA:  .SET kASCIBase+1    ;I/O address of chan B control register A
kASCIBCoB:  .SET kASCIBase+3    ;I/O address of chan B control register B
kASCIBSta:  .SET kASCIBase+5    ;I/O address of chan B status register
kASCIBTxd:  .SET kASCIBase+7    ;I/O address of chan B tx data register
kASCIBRxd:  .SET kASCIBase+9    ;I/O address of chan B rx data register

; **********************************************************************
; Serial status register bits

ST_RDRF:    .EQU 7              ;Receive data register Full
ST_TDRE:    .EQU 1              ;Transmit data register empty




