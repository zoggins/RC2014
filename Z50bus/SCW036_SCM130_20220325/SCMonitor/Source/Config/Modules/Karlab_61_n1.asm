; **********************************************************************
; **  Configuration file                        by Stephen C Cousins  **
; **  Module: Karlab_61 #1 (Communication and storage for RC2014)     **
; **********************************************************************

; This card contains a 68B50 ACIA and a Compact Flash interface
; These settings assume the main bus clock is 7.3728 MHz
; ACIA address options: 80, 90, A0, B0

#IFNDEF     INCLUDE_ACIA_n1
kACIA1:     .EQU 0x80           ;Base address of serial ACIA #1
#DEFINE     INCLUDE_ACIA_n1     ;Include ACIA #1 support in this build
#ENDIF

; Compact flash card interface
#IFNDEF     INCLUDE_CFCard
#DEFINE     CFBASE1 0x10        ;Base address for CF card #1
kCFCard:    .EQU 0x10           ;Base address of comact flash card
#DEFINE     INCLUDE_CFCard      ;Include CF Card support in this build
#ENDIF



