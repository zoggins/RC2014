; **********************************************************************
; **  Configuration file                        by Stephen C Cousins  **
; **  Module: ZORAk_ZSC #2 (ZORAk System Console for RC2014 bus)      **
; **********************************************************************

; This card contains a Zilog Z85C50 SCC
; These settings assume the main bus clock is 7.3728 MHz

#IFNDEF     INCLUDE_SCC_n2
kSCC2:      .EQU 0x20           ;Base address of ZORAk_ZSC #2
#DEFINE     INCLUDE_SCC_n2      ;Include SCC #2 support in this build
#ENDIF





