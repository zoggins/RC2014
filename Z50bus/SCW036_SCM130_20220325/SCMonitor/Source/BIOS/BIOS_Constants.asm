; **********************************************************************
; **  BIOS Constants                            by Stephen C Cousins  **
; **********************************************************************

; **********************************************************************
; BIOS identifier constants 
;
; These provide the ID of the BIOS code. They are generally used in the 
; MANAGER.ASM file statement:  kBiosID:  .EQU BI_xxxx
; In SCM v1.0.0 these values were previously known as the Hardware ID.
;
; Symbol     Value              BIOS name        Description
; ======     =====              =========        ===========
BI_UNKNOWN: .EQU 0              ;unknown         Unknown or Custom hardware
BI_SCW:     .EQU 1              ;Workshop        SC Workshop / simulated 
BI_SCDEV:   .EQU 2              ;SCDevKit        SC Development Kit 01
BI_RC2014:  .EQU 3              ;RC2014          Generic RC2014
BI_SC101:   .EQU 4              ;SC101           Prototype motherboard
BI_SBC1:    .EQU 5              ;LiNC80 SBC1     LiNC80 SBC1 with Z50Bus
BI_TomSBC:  .EQU 6              ;Tom's SBC       Tom Szolyga's SBC rev C
BI_Z280RC:  .EQU 7              ;Z280RC          Bill Shen's Z280RC
BI_SC114:   .EQU 8              ;SC114           Z80 for RC2014 (ie. SC114)
BI_Z80SBC:  .EQU 9              ;Z80SBCRC        Bill Shen's Z80SBC RC
BI_S3:      .EQU 10             ;SC S3           Z80 for RC2014 (eg. SC108)
BI_Z180L:   .EQU 11             ;Z180 legacy     Z180 for RC2014 (eg. SC111)
BI_Z180N:   .EQU 12             ;Z180 native     Z180 for RC2014 (eg. SC111,126)
BI_Z80SC    .EQU 13             ;Z80sc           Z80 generic (eg. SC121)
BI_Z50BUS:  .EQU 14             ;Z50Bus          Z80 generic (eg. SC118)
BI_CPM:     .EQU 15             ;CPM             External OS = CPM
BI_ROMWBW:  .EQU 16             ;RomWBW          External OS = RomWBW
BI_ZORAK:   .EQU 17             ;ZORAk           Steve Markowski's ZORAk
BI_SCZ80:   .EQU 18             ;SCZ80           Small Computer Z80
BI_SCZ180:  .EQU 19             ;SCZ180          Small Computer Z180
BI_Z80PG:   .EQU 20             ;Z80 Playground  John Squires' Z80 Playground


; **********************************************************************
















