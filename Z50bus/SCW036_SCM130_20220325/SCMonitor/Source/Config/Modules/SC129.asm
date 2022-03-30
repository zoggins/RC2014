; **********************************************************************
; **  Configuration file                        by Stephen C Cousins  **
; **  Module: Digital I/O module                                      **
; **********************************************************************

; This module provides an 8-bit input port and an 8-bit output port
; All 8 inputs and all 8 outputs have LED indicators

; Module used for general digital I/O
#IFNDEF     INCLUDE_DigIO
kDigIO:     .EQU 0x00           ;Base address of digital IO port
#DEFINE     INCLUDE_DigIO       ;Include digital I/O in this build
#ENDIF

; Module used for diagnostic LEDs
#IFNDEF     INCLUDE_DiagLEDs
#IFNDEF     DiagLEDs_DETECTED
#DEFINE     DiagLEDs_DETECTED TESTABLE  ;ALWAYS | NEVER | TESTABLE
#ENDIF
kDiagLEDs:  .EQU 0x00           ;Base address of diagnostic LEDs
#DEFINE     INCLUDE_DiagLEDs    ;Include diagnostic LEDs in this build
#ENDIF




