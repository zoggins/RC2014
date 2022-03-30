; **********************************************************************
; **  Monitor string support                    by Stephen C Cousins  **
; **********************************************************************

; Public functions provided
;   StrWrHexNibble        Write nibble to buffer as 1 hex character
;   StrWrHexByte          Write byte to buffer as 2 hex characters
;   StrWrHexWord          Write word to buffer as 4 hex characters
;   StrWrAddress          Write address, colon, space to buffer


; **********************************************************************
; **  Public functions                                                **
; **********************************************************************

            .CODE

; String: Append specified zero (null) terminated string
;   On entry: DE = Start of string to be appended
;   On exit:  AF BC DE HL IX IY I AF' BC' DE' HL' preserved
; Appends specified zero (null) terminated string to current string 
; buffer. The string does not have the usual length prefix but 
; instead is terminated with a zero (null).
StrAppendZ:
            PUSH AF
            PUSH DE
@Next:      LD   A,(DE)         ;Get length of specified string
            OR   A              ;Null string?
            JR   Z,@Done        ;Yes, so we're done
            CALL StrWrChar      ;Write character to current string
            INC  DE             ;Point to next character
            JR   @Next          ;Loop back if more character
@Done:      POP  DE
            POP  AF
            RET


; String: Convert string to upper case
;   On entry: No parameters required
;   On exit:  AF BC DE HL IX IY I AF' BC' DE' HL' preserved
StrConvUpper:
            PUSH AF
            PUSH HL
            LD   HL,(iStrStart) ;Get start of current string buffer
            LD   A,(HL)         ;Get length of string
            OR   A              ;Null string?
            JR   Z,@Done        ;Yes, so we're done here
            PUSH BC
            LD   B,A            ;Store length of string
@Loop:      INC  HL             ;Point to next character in string
            LD   A,(HL)         ;Get character from string
            CALL ConvertCharToUCase
            LD   (HL),A         ;Write upper case char to string
            DJNZ @Loop          ;Loop until end of string
            POP  BC
@Done:      POP  HL
            POP  AF
            RET


; String: Write ascii character to string buffer
;   On entry: A = ASCII character
;   On exit:  AF BC DE HL IX IY I AF' BC' DE' HL' preserved
; If the character is not printable then a dot is written instead
StrWrAsciiChar:
            PUSH AF
            CALL ConvertByteToAscii
            CALL StrWrChar      ;Write character or a dot
            POP  AF
            RET


; String: Write hex nibble to string buffer
;   On entry: A = Hex nibble
;   On exit:  AF BC DE HL IX IY I AF' BC' DE' HL' preserved
StrWrHexNibble:
            PUSH AF
            AND  0x0F           ;Mask off nibble
            CP   0x0A           ;Nibble > 10 ?
            JR   C,@Skip        ;No, so skip
            ADD  A,7            ;Yes, so add 7
@Skip:      ADD  A,0x30         ;Add ASCII '0'
            CALL StrWrChar      ;Write character
            POP  AF
            RET


; String: Write hex byte to string buffer
;   On entry: A = Hex byte
;   On exit:  AF BC DE HL IX IY I AF' BC' DE' HL' preserved
StrWrHexByte:
            PUSH AF
            PUSH DE
            CALL ConvertByteToNibbles
            LD   A,D
            CALL StrWrHexNibble
            LD   A,E
            CALL StrWrHexNibble
            POP  DE
            POP  AF
            RET


; String: Write hex word to string buffer
;   On entry: DE = Hex word
;   On exit:  AF BC DE HL IX IY I AF' BC' DE' HL' preserved
StrWrHexWord:
            PUSH AF
            LD   A,D            ;Get hi byte
            CALL StrWrHexByte   ;Write as two hex digits
            LD   A,E            ;Get lo byte
            CALL StrWrHexByte   ;Write as two hex digits
            POP  AF
            RET


; String: Write address, colon, space to string buffer
;   On entry: DE = Address
;   On exit:  AF BC DE HL IX IY I AF' BC' DE' HL' preserved
; Example output: "1234: "
StrWrAddress:
            PUSH AF
            CALL StrWrHexWord   ;Write start address of this line
            LD   A,':'
            CALL StrWrChar      ;Write colon
            CALL StrWrSpace     ;Write space
            POP  AF
            RET





