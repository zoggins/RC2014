; **********************************************************************
; **  Configuration file                        by Stephen C Cousins  **
; **  Module: RC2014 CFCard (Compact flash interface module )         **
; **********************************************************************

; This card contains a compact flash interface

#IFNDEF     INCLUDE_CFCard
#DEFINE     CFBASE1 0x10        ;Base address for CF card #1
kCFCard:    .EQU 0x10           ;Base address of comact flash card
#DEFINE     INCLUDE_CFCard      ;Include CF Card support in this build
#ENDIF





