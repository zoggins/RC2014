; **********************************************************************
; **  Configuration file                        by Stephen C Cousins  **
; **  Module: ZORAk_ZSC #1 (ZORAk System Console for RC2014 bus)      **
; **********************************************************************

; This card contains a Zilog Z85C50 SCC
; These settings assume the main bus clock is 7.3728 MHz

#IFNDEF     INCLUDE_SCC_n1
kSCC1:      .EQU 0x00           ;Base address of ZORAk_ZSC #1
#DEFINE     INCLUDE_SCC_n1      ;Include SCC #1 support in this build
#ENDIF





