; **********************************************************************
; **  String support                            by Stephen C Cousins  **
; **********************************************************************

; This module provides a group of functions to handle strings. Strings
; are build in buffers using various functions, such as StrWrChar,
; which writes the specified character to the end of the currently 
; selected string. The string can then be 'printed' to the current 
; output device with the StrPrint function.
;
; Ensure StrInitialise or StrInitDefault is called before any other 
; string function as these finctions select and initialise a string 
; buffer.
;
; Strings are stored in buffers where the first byte of the buffer
; contains the string length. A value of zero therefore indicates
; an empty (or null) string. 
;
; Public functions provided
;   StrAppend             Append specified string to current buffer
;   StrAppendZ            Append specified zero terminated string
;   StrClear              Clear the current string buffer
;   StrConvUpper          Convert string to upper case
;   StrCopyToZ            Copy to zero (null) terminated string
;   StrGetLength          Get length of string in current string buffer
;   StrInitDefault        Initialise and select the default buffer
;   StrInitialise         Initialise default or supplied string buffer
;   StrPrint              Print string in current string buffer
;   StrPrintDE            Print string in string buffer at DE
;   StrWrAsciiChar        Write ascii character to string buffer
;   StrWrBackspace        Write backspace to string buffer
;   StrWrBinaryWord       TODO write binary byte
;   StrWrChar             Write character to string buffer
;   StrWrDecByte          TODO write decimal byte
;   StrWrDecWord          TODO write decimal word
;   StrWrNewLine          Write new line to string buffer
;   StrWrPadding          Write padding (spaces) to specified length
;   StrWrSpace            Write space character to string buffer
;   StrWrSpaces           Write specified spaces to string buffer
; Unless otherwise stated these functions have no return values and 
; preserved the registers: AF BC DE HL IX IY I AF' BC' DE' HL'


; **********************************************************************
; **  Public functions                                                **
; **********************************************************************

            .CODE

; String: Append specified string to current string buffer
;   On entry: DE = Start of string to be appended
;   On exit:  AF BC DE HL IX IY I AF' BC' DE' HL' preserved
StrAppend:
            PUSH AF
            PUSH BC
            PUSH DE
            LD   A,(DE)         ;Get length of specified string
            OR   A              ;Null string?
            JR   Z,@Done        ;Yes, so we're done
            LD   B,A            ;Store length of string
@Next:      INC  DE             ;Point to next character to append
            LD   A,(DE)         ;Get character from specified string
            CALL StrWrChar      ;Write character to current string
            DJNZ @Next          ;Loop back if more character
@Done:      POP  DE
            POP  BC
            POP  AF
            RET


; String: Clear string in current string buffer
;   On entry: No parameters required
;   On exit:  AF BC DE HL IX IY I AF' BC' DE' HL' preserved
StrClear:
            PUSH HL
            LD   HL,(iStrStart) ;Get start of current string buffer
            LD   (HL),0         ;Initialise string with length zero
            POP  HL
            RET


; String: Copy to zero (null) terminated string
;   On entry: DE = Location to store Z string
;   On exit:  AF BC DE HL IX IY I AF' BC' DE' HL' preserved
StrCopyToZ:
            PUSH AF
            PUSH DE
            PUSH HL
            LD   HL,(iStrStart) ;Get start of current string buffer
            LD   A,(HL)         ;Get length of string
            OR   A              ;Null string?
            JR   Z,@Done        ;Yes, so we're done here
            INC  HL             ;Point to first character in string
            PUSH BC
            LD   C,A            ;Store length of string
            LD   B,0
            LDIR                ;Copy string from HL to DE
            POP  BC
@Done:      XOR  A
            LD   (DE),A         ;Terminate string with null
            POP  HL
            POP  DE
            POP  AF
            RET


; String: Get length of string in current string buffer
;   On entry: No parameters required
;   On exit:  A = Length in characters
;             BC DE HL IX IY I AF' BC' DE' HL' preserved
StrGetLength:
            PUSH HL
            LD   HL,(iStrStart) ;Get start of current string buffer
            LD   A,(HL)         ;Get length of string in buffer
            POP  HL
            RET


; String: Initialise and select default string buffer
;   On entry: No parameters required
;   On exit:  AF BC DE HL IX IY I AF' BC' DE' HL' preserved
StrInitDefault:
            PUSH AF
            XOR  A              ;Select default string buffer (0)
            CALL StrInitialise  ;Select and initialise buffer
            POP  AF
            RET


; String: Initialise default or supplied string buffer
;   On entry: A = Size of buffer or zero to restore defaults
;             DE = Start address of string buffer
;   On exit:  AF BC DE HL IX IY I AF' BC' DE' HL' preserved
; Size includes the string's length byte so needs to be one byte
; longer than the largest string it can hold.
StrInitialise:
            PUSH AF
            PUSH DE
            OR   A              ;Buffer length zero?
            JR   NZ,@Init       ;No, so go use supplied values
            LD   DE,kStrBuffer  ;Get start of default buffer
            LD   A,kStrSize     ;Get size of default buffer
@Init:      LD   (iStrStart),DE ;Store start of string buffer
            LD   (iStrSize),A   ;Store size of string buffer
            XOR  A              ;Prepare for length zero
            LD   (DE),A         ;Initialise string with length zero
            POP  DE
            POP  AF
            RET


; String: Print string in current string buffer
;   On entry: No parameters required
;   On exit:  AF BC DE HL IX IY I AF' BC' DE' HL' preserved
; The string is printed to the current output device
; Supports \n for new line
StrPrint:
            PUSH DE
            LD   DE,(iStrStart) ;Get start of current string buffer
            CALL StrPrintDE     ;Print string at DE
@Done:      POP  DE
            RET


; String: Print string in current string buffer
;   On entry: DE = Address of string
;   On exit:  AF BC DE HL IX IY I AF' BC' DE' HL' preserved
; The string is printed to the current output device
StrPrintDE:
            PUSH AF
            PUSH BC
            PUSH DE
            LD   A,(DE)         ;Get length of specified string
            OR   A              ;Null string?
            JR   Z,@Done        ;Yes, so we're done
            LD   B,A            ;Store length of string
@Next:      INC  DE             ;Point to next character to append
            LD   A,(DE)         ;Get character from specified string
            CALL OutputChar     ;Output character to output device
            DJNZ @Next          ;Loop back if more character
@Done:      POP  DE
            POP  BC
            POP  AF
            RET



#IFDEF      kIncludeUnusedCode
; String: Write backspace to string buffer
;   On entry: No parameters required
;   On exit:  AF BC DE HL IX IY I AF' BC' DE' HL' preserved
; Writeing backspace deletes the last character in the buffer
StrWrBackspace:
            PUSH AF
            PUSH HL
            LD   HL,(iStrStart) ;Pointer to start of string buffer
            LD   A,(HL)         ;Get length of string in buffer
            OR   A              ;Null terminator?
            JR   Z,@Skip        ;Yes, so skip as null string
            DEC  HL             ;Decrement string length
@Skip:      POP  HL
            POP  AF
            RET
#ENDIF


; String: Write character
;   On entry: A = Character to write to string buffer
;   On exit:  AF BC DE HL IX IY I AF' BC' DE' HL' preserved
; The specified character is writted to the string buffer and a null
; terminator added.
StrWrChar:
            PUSH AF
            PUSH DE
            PUSH HL
            LD   E,A            ;Store character to write
            LD   HL,(iStrStart) ;Start of current string buffer
            LD   A,(HL)         ;Get length of string in buffer
; TODO >>>>> Trap strings too long for the buffer
            INC  (HL)           ;Increment string length
            INC  A              ;Inc to skip length byte
            ADD  A,L            ;Add A to start of buffer...
            LD   L,A            ;  to get address for next character
            JR   NC,@Store
            INC  H
@Store:     LD   (HL),E         ;Store character in buffer
            POP  HL
            POP  DE
            POP  AF
            RET


; String: Write new line to string buffer
;   On entry: No parameters
;   On exit:  AF BC DE HL IX IY I AF' BC' DE' HL' preserved
StrWrNewLine:
            PUSH AF
            LD   A,kNewLine     ;Get new line character
            CALL StrWrChar      ;Write character to string
            POP  AF
            RET


; String:  Write padding (spaces) to specified length
;   On entry: A = Required length of string
;   On exit:  AF BC DE HL IX IY I AF' BC' DE' HL' preserved
StrWrPadding:
            PUSH AF
            PUSH BC
            PUSH HL
            LD   B,A
            LD   HL,(iStrStart) ;Get start of current string buffer
            SUB  (HL)           ;Compare required length to current
            JR   C,@End         ;End now if already too long
            JR   Z,@End         ;End now if already required length
            CALL StrWrSpaces    ;Write required number of spaces
@End:       POP  HL
            POP  BC
            POP  AF
            RET


; String: Write space character to string buffer
;   On entry: No parameters
;   On exit:  AF BC DE HL IX IY I AF' BC' DE' HL' preserved
StrWrSpace:
            PUSH AF
            LD   A,kSpace       ;Space character
            CALL StrWrChar      ;Write space character
            POP  AF
            RET


; String: Write spaces to string buffer
;   On entry: A = Number of spaces to write
;   On exit:  AF BC DE HL IX IY I AF' BC' DE' HL' preserved
StrWrSpaces:
            PUSH AF
@Loop:      CALL StrWrSpace     ;Print one space character
            DEC  A              ;Written all required spaces?
            JR   NZ,@Loop       ;No, so go write another
            POP  AF
            RET


; **********************************************************************
; **  Private workspace (in RAM)                                      **
; **********************************************************************

            .DATA

iStrStart:  .DW  0x0000         ;Start of current string buffer
iStrSize:   .DB  0x00           ;Size of current string buffer (0 to Len-1)


; **********************************************************************
; **  End of String support module                                    **
; **********************************************************************





