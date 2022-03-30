; **********************************************************************
; **  System utility functions                  by Stephen C Cousins  **
; **********************************************************************

; This module provides a group of utility functions
;   ConvertCharToNumber   Convert character to numeric value
;   ConvertCharToUCase    Convert character to upper case


; **********************************************************************
; **  Public functions                                                **
; **********************************************************************

            .CODE


; Utility: Convert character to numberic value
;   On entry: A = ASCII character (0-9 or A-F)
;   On exit:  If character is a valid hex digit:
;               A = Numberic value (0 to 15) and Z flagged
;             If character is not a valid hex digit:
;               A = 0xFF and NZ flagged
;             BC DE HL IX IY I AF' BC' DE' HL' preserved
;             Interrupts not enabled
ConvertCharToNumber:
            CALL ConvertCharToUCase
            CP   '0'            ;Character < '0'?
            JR   C,@Bad         ;Yes, so no hex character
            CP   '9'+1          ;Character <= '9'?
            JR   C,@OK          ;Yes, got hex character
            CP   'A'            ;Character < 'A'
            JR   C,@Bad         ;Yes, so not hex character
            CP   'F'+1          ;Character <= 'F'
            JR   C,@OK          ;No, not hex
; Character is not a hex digit so return 
@Bad:       LD   A,0xFF         ;Return status: not hex character
            OR   A              ;  A = 0xFF and NZ flagged
            RET
; Character is a hex digit so adjust from ASCII to number
@OK:        SUB  '0'            ;Subtract '0'
            CP   0x0A           ;Number < 10 ?
            JR   C,@Finished    ;Yes, so finished
            SUB  0x07           ;Adjust for 'A' to 'F'
@Finished:  CP   A              ;Return A = number (0 to 15) and Z flagged to
            RET                 ;  indicate character is a valid hex digital


; Utility: Convert character to upper case
;   On entry: A = Character in either case
;   On exit:  A = Character in upper case
;             BC DE HL IX IY I AF' BC' DE' HL' preserved
ConvertCharToUCase:
            CP   'a'            ;Character less than 'a'?
            RET  C              ;Yes, so finished
            CP   'z'+1          ;Character greater than 'z'?
            RET  NC             ;Yes, so finished
            SUB  'a'-'A'        ;Convert case
            RET


; **********************************************************************
; **  End of System utility functions                                 **
; **********************************************************************

