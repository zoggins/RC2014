; **********************************************************************
; **  Device Driver                             by Stephen C Cousins  **
; **  Hardware:  SCWorkshop simulator                                 **
; **  Interface: Terminal                                             **
; **********************************************************************

; This module is the driver for a simulated terminal with an extemely
; simplifed interface.
; The terminal is logically two devices: input and output

            .CODE


; Simulated terminal initialise
;   On entry: No parameters required
;   On exit:  Z flagged if device is found and initialised
;             AF BC DE HL not specified
;             IX IY I AF' BC' DE' HL' preserved
; If the device is found it is initialised
Simulated_Terminal_Initialise:
            XOR  A              ;Return Z flag as device found
;           LD   (iSimWait),A   ;Clear character waiting
            RET


; Simulated terminal input character
;   On entry: No parameters required
;   On exit:  A = Character input from terminal
;             NZ flagged if character input
;             BC DE HL IX IY I AF' BC' DE' HL' preserved
Simulated_Terminal_InputChar:
;           LD   A,(iSimWait)   ;Get waiting character
;           OR   A              ;Is there a character?
;           RET  NZ             ;Yes, so return
@Wait:      IN   A,(TermIn)     ;Read from input device
            OR   A              ;Is there a character available?
;           JR   Z,@Wait        ;No, so keep trying
            RET


; Simulated terminal output character
;   On entry: A = Character to be output to the terminal
;   On exit:  If character output successful (eg. device was ready)
;               A = NZ flagged and A != 0
;             If character output failed (eg. device busy)
;               A = Z flagged and A = Character to output
;             BC DE HL IX IY I AF' BC' DE' HL' preserved
Simulated_Terminal_OutputChar:
            OUT  (TermOut),A    ; Transmit to terminal
;           OUT  (PrintOut),A   ; Transmit to printer
            OR   0xFF           ; Return success A=0xFF and NZ flagged
            RET


; Simulated terminal input status
;   On entry: No parameters required
;   On exit:  NZ flagged if an input character is available
;             BC DE HL IX IY I AF' BC' DE' HL' preserved
; This function does not wait until a character is available
;Simulated_Terminal_InputStatus:
;           IN   A,(TermIn)     ;Read from input device
;           OR   A              ;Is there a character available?
;           RET  Z              ;No, so return
;           LD   (iSimWait),A   ;Store for input
;           RET


; Simulated terminal output status
;   On entry: No parameters required
;   On exit:  NZ flagged if ready for an output character
;             BC DE HL IX IY I AF' BC' DE' HL' preserved
; This function does not wait until a character is available
;Simulated_Terminal_OutputStatus:
;           OR   0xFF           ;Flag NZ
;           RET


; **********************************************************************
; **  Private workspace (in RAM)                                      **
; **********************************************************************

            .DATA

;iSimWait:  .DB  0x00           ;Simulated input character waiting


; **********************************************************************
; **  End of driver: SCWorkshop simulator, Terminal                   **
; **********************************************************************


