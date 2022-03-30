; **********************************************************************
; **  Device Driver                             by Stephen C Cousins  **
; **  Hardware:  External OS = RomWBW                                 **
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


; Terminal input character
;   On entry: No parameters required
;   On exit:  A = Character input from terminal
;             NZ flagged if character input
;             BC DE HL IX IY I AF' BC' DE' HL' preserved
Terminal_InputChar:
            PUSH BC
            PUSH DE
            PUSH HL
            LD   B,2            ;HBIOS fn 2 = CIOIST (char input status)
            LD   C,0            ;Unit number 0 = first serial port
            RST  8              ;Call HBIOS
            OR   A              ;Any characters available
            JR   Z,@Exit        ;No, so exit
            LD   B,0            ;HBIOS fn 0 = CIOIN (char input)
            LD   C,0            ;Unit number 0 = first serial port
            RST  8              ;Call HBIOS
            LD   A,E            ;Character received
@Exit:      POP  HL
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
            LD   B,1            ;HBIOS fn 1 = CIOOUT (char output)
            LD   C,0            ;Unit number 0 = first serial port
            LD   E,A            ;Character to output
            RST  8              ;Call HBIOS
            POP  HL
            POP  DE
            POP  BC
            OR   0xFF           ; Return success A=0xFF and NZ flagged
            RET


; **********************************************************************
; **  Private workspace (in RAM)                                      **
; **********************************************************************

            .DATA


; **********************************************************************
; **  End of driver: Terminal                                         **
; **********************************************************************








