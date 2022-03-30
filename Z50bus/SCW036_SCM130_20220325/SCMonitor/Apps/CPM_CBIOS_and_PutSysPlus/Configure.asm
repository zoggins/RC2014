; **********************************************************************
; **  CP/M 2.2 CBIOS                            by Stephen C Cousins  **
; **  Configuration options                                           **
; **********************************************************************

; The configuration file establishes these options via #DEFINEs:
; SSType        n/a   | CPM-A | CPM-B | ... 
; MPType        Z80   | Z180
; MPBase        n/a   | 0x00  | 0x40  | 0x80  | 0xC0
; SDBase        0x10  | 0x90
; SDSize        64MB  | 128MB
; CDType        BB96  | SIO   | ACIA  | ASCI    
; CDBase        0x00  | 0x40  | 0x80  | ...
; CDMode        n/a   | RC    | SC    
; And establishes values via .EQUs:
; kSSType       0     | 1     | 2     | ...
; kMPType       0     | 1    
; kMPBase       0     | 0x00  | 0x40  | 0x80  | 0xC0 
; kSDBase       0x10  | 0x90
; kSDSize       64    | 128 
; kCDType       1     | 2     | 3     | 4
; kCDBase       0x00  | 0x40  | 0x80  | ...
; kCDMode       0     | 1     | 2    

; Standard systems
; SSType  MPType  CFType  CFBase  SDType  SDBase  SDSize
; CPM-A   Z80     BB9600  0x28    CF      0x10    128MB
; CPM-B   Z80     SIO     0x80    CF      0x10    128MB
; CPM-C   Z80     ACIA    0x80    CF      0x10    128MB
; CPM-D   Z180    ASCI    0xC0    CF      0x10    128MB
; CPM-E   Z80     BB9600  0x28    CF      0x90    128MB
; CPM-F   Z80     SIO     0x80    CF      0x90    128MB
; CPM-G   Z80     ACIA    0xA2    CF      0x90    128MB
; CPM-H   Z180    ASCI    0xC0    CF      0x90    128MB

; Date appears in CP/M startup message
#DEFINE     DATE                "2022-03-23"

; Define a standard system to override all other #DEFINEs below
; Standard system type:         n/a   | CPM-A | CPM-B | ...                                SC582 |
#DEFINE     SSType              CPM-A

; Micro processor type:         Z80 | Z180
#DEFINE     MPType              Z180

; Micro processor base address: n/a | 0x00 | 0x40 | 0x80 | 0xC0
#DEFINE     MPBase              0x40

; Storage device types:         CF
#DEFINE     SDType              CF

; Storage device base address:  0x10 | 0x90
#DEFINE     SDBase              0x90

; Storage device size:          64MB | 128MB
#DEFINE     SDSize              128MB

; Console device type:          ACIA | ASCI | SIO
#DEFINE     CDType              ASCI

; Console device base address:  0x00 | 0x80
#DEFINE     CDBase              0xC0 

; Console device mode:          n/a | RC | SC
#DEFINE     CDMode              n/a


; **********************************************************************
; **  Standard system configurations
; **********************************************************************

#IF         SSType = "n/a"

; Use above #DEFINEs

#ELSE

; Clear above #DEFINEs
#UNDEFINE   MPType
#UNDEFINE   MPBase
#UNDEFINE   SDType
#UNDEFINE   SDBase
#UNDEFINE   SDSize
#UNDEFINE   CDType
#UNDEFINE   CDBase
#UNDEFINE   CDMode

; Set defaults for specified standard system
#IF         SSType = "CPM-A"
#DEFINE     MPType Z80
#DEFINE     MPBase n/a
#DEFINE     SDType CF
#DEFINE     SDBase 0x10
#DEFINE     SDSize 128MB
#DEFINE     CDType BB96
#DEFINE     CDBase 0x28
#DEFINE     CDMode n/a
#ENDIF
#IF         SSType = "CPM-B"
#DEFINE     MPType Z80
#DEFINE     MPBase n/a
#DEFINE     SDType CF
#DEFINE     SDBase 0x10
#DEFINE     SDSize 128MB
#DEFINE     CDType SIO
#DEFINE     CDBase 0x80
#DEFINE     CDMode RC
#ENDIF
#IF         SSType = "CPM-C"
#DEFINE     MPType Z80
#DEFINE     MPBase n/a
#DEFINE     SDType CF
#DEFINE     SDBase 0x10
#DEFINE     SDSize 128MB
#DEFINE     CDType ACIA
#DEFINE     CDBase 0x80
#DEFINE     CDMode n/a
#ENDIF
#IF         SSType = "CPM-D"
#DEFINE     MPType Z180
#DEFINE     MPBase 0xC0
#DEFINE     SDType CF
#DEFINE     SDBase 0x10
#DEFINE     SDSize 128MB
#DEFINE     CDType ASCI
#DEFINE     CDBase 0xC0
#DEFINE     CDMode n/a
#ENDIF
#IF         SSType = "CPM-E"
#DEFINE     MPType Z80
#DEFINE     MPBase n/a
#DEFINE     SDType CF
#DEFINE     SDBase 0x90
#DEFINE     SDSize 128MB
#DEFINE     CDType BB96
#DEFINE     CDBase 0x28
#DEFINE     CDMode n/a
#ENDIF
#IF         SSType = "CPM-F"
#DEFINE     MPType Z80
#DEFINE     MPBase n/a
#DEFINE     SDType CF
#DEFINE     SDBase 0x90
#DEFINE     SDSize 128MB
#DEFINE     CDType SIO
#DEFINE     CDBase 0x80
#DEFINE     CDMode SC
#ENDIF
#IF         SSType = "CPM-G"
#DEFINE     MPType Z80
#DEFINE     MPBase n/a
#DEFINE     SDType CF
#DEFINE     SDBase 0x90
#DEFINE     SDSize 128MB
#DEFINE     CDType ACIA
#DEFINE     CDBase 0xA2
#DEFINE     CDMode n/a
#ENDIF
#IF         SSType = "CPM-H"
#DEFINE     MPType Z180
#DEFINE     MPBase 0xC0
#DEFINE     SDType CF
#DEFINE     SDBase 0x90
#DEFINE     SDSize 128MB
#DEFINE     CDType ASCI
#DEFINE     CDBase 0xC0
#DEFINE     CDMode n/a
#ENDIF

; Catch-all defaults
#IFNDEF     MPType
#DEFINE     MPType Z80
kBIOS       .EQU 'Z'
#ENDIF
#IFNDEF     MPBase
#DEFINE     MPBase n/a
#ENDIF
#IFNDEF     SDType
#DEFINE     SDType CF
#ENDIF
#IFNDEF     SDBase
#DEFINE     SDBase 0x10
#ENDIF
#IFNDEF     SDSize
#DEFINE     SDSize 128MB
#ENDIF
#IFNDEF     CDType
#DEFINE     CDType SIO
#ENDIF
#IFNDEF     CDBase
#DEFINE     CDBase 0x80
#ENDIF
#IFNDEF     CDMode
#DEFINE     CDMode SC
#ENDIF

#ENDIF


; **********************************************************************
; **  Process above #DEFINE values
; **********************************************************************

kTest:      .EQU 0              ;Use this to test for valid DEFINEs

; Test statndard system type values
#IF         SSType = "n/a"
kSSType:    .EQU 0
#ENDIF
#IF         SSType = "CPM-A"
kSSType:    .EQU 1
kBIOS       .EQU 'A'
#ENDIF
#IF         SSType = "CPM-B"
kSSType:    .EQU 2
kBIOS       .EQU 'B'
#ENDIF
#IF         SSType = "CPM-C"
kSSType:    .EQU 3
kBIOS       .EQU 'C'
#ENDIF
#IF         SSType = "CPM-D"
kSSType:    .EQU 4
kBIOS       .EQU 'D'
#ENDIF
#IF         SSType = "CPM-E"
kSSType:    .EQU 5
kBIOS       .EQU 'E'
#ENDIF
#IF         SSType = "CPM-F"
kSSType:    .EQU 6
kBIOS       .EQU 'F'
#ENDIF
#IF         SSType = "CPM-G"
kSSType:    .EQU 7
kBIOS       .EQU 'G'
#ENDIF
#IF         SSType = "CPM-H"
kSSType:    .EQU 8
kBIOS       .EQU 'H'
#ENDIF
kTest:      .SET kSSType

; Test micro processor type values
#IF         MPType = "Z80"
kMPType:    .EQU 0
#ENDIF
#IF         MPType = "Z180"
kMPType:    .EQU 1
#ENDIF
kTest:      .SET kMPType

; Test micro processor base address values
#IF         MPBase = "n/a"
kMPBase:    .EQU 0
#ENDIF
#IF         MPBase = "0x00"
kMPBase:    .EQU 0x00
#ENDIF
#IF         MPBase = "0x40"
kMPBase:    .EQU 0x40
#ENDIF
#IF         MPBase = "0x80"
kMPBase:    .EQU 0x80
#ENDIF
#IF         MPBase = "0xC0"
kMPBase:    .EQU 0xC0
#ENDIF
kTest:      .SET kMPBase

; Test storage device base address
#IF         SDBase = "0x10"
kSDBase:    .EQU 0x10
#ENDIF
#IF         SDBase = "0x90"
kSDBase:    .EQU 0x90
#ENDIF
kTest:      .SET kSDBase

; Test storage device size
#IF         SDSize = "64MB"
kSDSize:    .EQU 64
#ENDIF
#IF         SDSize = "128MB"
kSDSize:    .EQU 128
#ENDIF
kTest:      .SET kSDSize

; Test console device type
#IF         CDType = "BB96"
kCDType:    .EQU 1
#ENDIF
#IF         CDType = "SIO"
kCDType:    .EQU 2
#ENDIF
#IF         CDType = "ACIA"
kCDType:    .EQU 3
#ENDIF
#IF         CDType = "ASCI"
kCDType:    .EQU 4
#ENDIF
kTest:      .SET kCDType

; Test console device base address
#IF         CDBase = "0x00"
kCDBase:    .EQU 0x00
#ENDIF
#IF         CDBase = "0x28"
kCDBase:    .EQU 0x28
#ENDIF
#IF         CDBase = "0x40"
kCDBase:    .EQU 0x00
#ENDIF
#IF         CDBase = "0x80"
kCDBase:    .EQU 0x80
#ENDIF
#IF         CDBase = "0xA2"
kCDBase:    .EQU 0xA2
#ENDIF
#IF         CDBase = "0xC0"
kCDBase:    .EQU 0x80
#ENDIF
kTest:      .SET kCDBase

; Test console device mode
#IF         CDMode = "n/a"
kCDMode:    .EQU 0
#ENDIF
#IF         CDMode = "RC"
kCDMode:    .EQU 1
#ENDIF
#IF         CDMode = "SC"
kCDMode:    .EQU 2
#ENDIF
kTest:      .SET kCDMode


