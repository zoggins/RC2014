; **********************************************************************
; **  Device Driver                             by Stephen C Cousins  **
; **  Hardware:  External OS = CPM                                    **
; **  Interface: Terminal                                             **
; **********************************************************************

; The terminal is logically two devices: input and output

            .CODE


; Terminal initialise
;   On entry: No parameters required
;   On exit:  Z flagged if device is found and initialised
;             AF BC DE HL not specified
;             IX IY I AF' BC' DE' HL' preserved
; If the device is found it is initialised
Terminal_Initialise:
            XOR  A              ;Return Z flag as device found
            RET


#IFDEF      NOCHANCE


; Terminal input character
;   On entry: No parameters required
;   On exit:  A = Character input from terminal
;             NZ flagged if character input
;             BC DE HL IX IY I AF' BC' DE' HL' preserved
Terminal_InputChar:
;           LD   A,(iSimWait)   ;Get waiting character
;           OR   A              ;Is there a character?
;           RET  NZ             ;Yes, so return
@Wait:      IN   A,(TermIn)     ;Read from input device
            OR   A              ;Is there a character available?
;           JR   Z,@Wait        ;No, so keep trying
            RET


; Terminal output character
;   On entry: A = Character to be output to the terminal
;   On exit:  If character output successful (eg. device was ready)
;               A = NZ flagged and A != 0
;             If character output failed (eg. device busy)
;               A = Z flagged and A = Character to output
;             BC DE HL IX IY I AF' BC' DE' HL' preserved
Terminal_OutputChar:
            OUT  (TermOut),A    ; Transmit to terminal
;           OUT  (PrintOut),A   ; Transmit to printer
            OR   0xFF           ; Return success A=0xFF and NZ flagged
            RET


#ELSE


; Terminal input character
;   On entry: No parameters required
;   On exit:  A = Character input from terminal
;             NZ flagged if character input
;             BC DE HL IX IY I AF' BC' DE' HL' preserved
Terminal_InputChar:
            PUSH BC
            PUSH DE
            PUSH HL
            LD   C,6
            LD   E,0xFF
            CALL 0x0005
            POP  HL
            POP  DE
            POP  BC
            OR   A              ;Is there a character available?
            RET


; Terminal output character
;   On entry: A = Character to be output to the terminal
;   On exit:  If character output successful (eg. device was ready)
;               A = NZ flagged and A != 0
;             If character output failed (eg. device busy)
;               A = Z flagged and A = Character to output
;             BC DE HL IX IY I AF' BC' DE' HL' preserved
Terminal_OutputChar:
            PUSH BC
            PUSH DE
            PUSH HL
            LD   C,6
            LD   E,A
            CALL 0x0005
            POP  HL
            POP  DE
            POP  BC
            OR   0xFF           ; Return success A=0xFF and NZ flagged
            RET


#ENDIF


; **********************************************************************
; **  Private workspace (in RAM)                                      **
; **********************************************************************

            .DATA


; **********************************************************************
; **  End of driver: Terminal                                         **
; **********************************************************************






