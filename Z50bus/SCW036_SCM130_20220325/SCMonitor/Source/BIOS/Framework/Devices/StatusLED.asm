; **********************************************************************
; **  Device Driver                             by Stephen C Cousins  **
; **  Hardware:  Generic                                              **
; **  Interface: Status LED                                           **
; **********************************************************************

; This module is the driver for a single LED diagnostic indicator
;
; Externally definitions required:
;kStatBase: .EQU kPrtLED          ;I/O base address


            .CODE

; Interface descriptor
            .DB  0              ;Device ID code (not currently used)
            .DW  @String        ;Pointer to device string
            .DW  @Init          ;Pointer to initialisation code
            .DB  0              ;Hardware flags bit mask
            .DW  @Setting       ;Point to device settings code
            .DB  0              ;Number of console devices
@String:    .DB  "Status LED "
            .DB  "@ "
            .HEXCHAR kStatBase \ 16
            .HEXCHAR kStatBase & 15
            .DB  kNull


; Initialise
;   On entry: No parameters required
;   On exit:  Z flagged if device is found and initialised
;             AF BC DE HL not specified
;             IX IY I AF' BC' DE' HL' preserved
; If the device is found it is initialised
@Init:      XOR  A              ;Always return device detected 
            RET                 ;Return Z if found, NZ if not


; Device settings
;   On entry: No parameters required
;   On entry: A = Property to set: 1 = Baud rate
;             B = Baud rate code
;             C = Console device number (1 to 6)
;   On exit:  IF successful: (ie. valid device and baud code)
;               A != 0 and NZ flagged
;             BC DE HL not specified
;             IX IY I AF' BC' DE' HL' preserved
@Setting:   XOR  A              ;Return failed to set (Z flagged)
            RET


; **********************************************************************
; **  End of driver                                                   **
; **********************************************************************

