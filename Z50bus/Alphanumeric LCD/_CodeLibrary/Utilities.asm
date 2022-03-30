; **********************************************************************
; **  Common utility functions                  by Stephen C Cousins  **
; **********************************************************************
;
; **  Written as a module to be included in Small Computer Monitor Apps
; **  Version 0.2 SCC 2018-05-15 
; **  www.scc.me.uk
;
; **********************************************************************
;
; This module provides some common utility functions 
;
; **********************************************************************
;
; To include the code for any given function provided by this module, 
; add the appropriate #REQUIRES <FunctionName> statement at the top of 
; the parent source file.
; For example:  #REQUIRES   uHexPrefix
;
; Also #INCLUDE this file at some point after the #REQUIRES statements
; in the parent source file.
; For example:  #INCLUDE    ..\_CodeLibrary\Utilities.asm
;
; These are the function names provided by this module:
; uOutputNewLine                ;Output new line (eg. CR+LF)
; uOutputText                   ;Output null terminated string
; uOutputHexPref                ;Output hexadecimal prefix (eg. '$')
; uByteToNibbles                ;Convert byte (A) to two nibbles (DE)
; uOutputHexNib                 ;Output hexadecimal nibble
; uOutputHexByte                ;Output hexadecimal byte
; uOutputHexWord                ;Output hexadecimal word
; uOutputDecWord                ;Output decimal word no leading spaces
; uFindString                   ;Fins null terminated string in list
;
; **********************************************************************
;
; Requires SCMonAPI.asm to also be included in the project
;
#REQUIRES   aOutputChar


; **********************************************************************
; **  Constants
; **********************************************************************

; none


; **********************************************************************
; **  Program code
; **********************************************************************

            .CODE               ;Code section


; **********************************************************************
; **  Common support functions
; **********************************************************************

#IFREQUIRED uOutputNewLine
; Output new line
;   On entry: No parameters required
;   On exit:  AF BC DE HL IX IY I AF' BC' DE' HL' preserved
uOutputNewLine:
            PUSH AF
            LD   A,kReturn      ;Prepare to output carriage return
            CALL aOutputChar
            LD   A,kLinefeed    ;Prepare to output line feed
            CALL aOutputChar
            POP  AF
            RET
#ENDIF


#IFREQUIRED uOutputText
; Output text string (null terminated)
;   On entry: DE = Pointer to start of null terminated string
;   On exit:  AF BC DE HL IX IY I AF' BC' DE' HL' preserved
uOutputText:
            PUSH AF
            PUSH DE
@Loop:      LD   A,(DE)         ;Get character from string
            OR   A              ;End marker (null)?
            JR   Z,@Finished    ;Yes, so finished
            CALL aOutputChar
            INC  DE             ;Point to next character in string
            JR   @Loop          ;Go consider next character
@Finished:  POP  DE
            POP  AF
            RET
#ENDIF


#IFREQUIRED uOutputHexPref
; Output hex prefix (eg. dollar)
;   On entry: No parameters required
;   On exit:  AF BC DE HL IX IY I AF' BC' DE' HL' preserved
uOutputHexPref:
            PUSH AF
            LD   A,'$'          ;Prepare to output '$'
            CALL aOutputChar
            POP  AF
            RET
#ENDIF


#IFREQUIRED uOutputHexWord
; Output hexadecimal word (0000 to FFFF)
;   On entry: DE = Unsigned 16-bit number to be output in hexadecimal
;   On exit:  AF BC DE HL IX IY I AF' BC' DE' HL' preserved
uOutputHexWord:
            PUSH AF
            LD   A,D
            CALL uOutputHexByte ;Output most significant byte
            LD   A,E
            CALL uOutputHexByte ;Output least significant byte
            POP  AF
            RET
; Ensure necessary functions are included
#REQUIRES   uOutputHexByte
#ENDIF


#IFREQUIRED uOutputHexByte
; Output hexadecimal byte (00 to FF)
;   On entry: A = Unsigned 8-bit number to be output in hexadecimal
;   On exit:  AF BC DE HL IX IY I AF' BC' DE' HL' preserved
uOutputHexByte:
            PUSH AF
            PUSH DE
            CALL uByteToNibbles
            LD   A,D
            CALL uOutputHexNib  ;Output most significant nibble
            LD   A,E
            CALL uOutputHexNib  ;Output least significant nibble
            POP  DE
            POP  AF
            RET
; Ensure necessary functions are included
#REQUIRES   uByteToNibbles
#REQUIRES   uOutputHexNib
#ENDIF


#IFREQUIRED uOutputHexNib
; Output hexadecimal nibble (0 to F)
;   On entry: A = Unsigned 4-bit number to be output in hexadecimal
;   On exit:  AF BC DE HL IX IY I AF' BC' DE' HL' preserved
uOutputHexNib:
            PUSH AF
            AND  0x0F           ;Mask off nibble
            CP   0x0A           ;Nibble > 10 ?
            JR   C,@Skip        ;No, so skip
            ADD  A,7            ;Yes, so add 7
@Skip:      ADD  A,0x30         ;Add ASCII '0'
            CALL aOutputChar    ;Output hex nibble character
            POP  AF
            RET
#ENDIF


#IFREQUIRED uByteToNibbles
; Convert byte (A) to nibbles (DE)
;   On entry: A = Byte to be converted into nibbler
;             D = Most significant nibble (0 to F)
;             E = Least significant nibble (0 to F)
;   On exit:  AF BC HL IX IY I AF' BC' DE' HL' preserved
uByteToNibbles:
            PUSH AF
            LD   E,A            ;Get byte to convert
            RRA                 ;Shift top nibble to
            RRA                 ;  botom four bits..
            RRA
            RRA
            AND  0x0F           ;Mask off unwanted bits
            LD   D,A            ;Store top nibble
            LD   A,E            ;Get byte to convert
            AND  0x0F           ;Mask off unwanted bits
            LD   E,A            ;Store bottom nibble
            POP  AF
            RET
#ENDIF


#IFREQUIRED uOutputDecWord
; Output decimal word (0 to 65535)
;   On entry: DE = Unsigned 16-bit number to be output in decimal
;   On exit:  AF BC DE HL IX IY I AF' BC' DE' HL' preserved
; No leading zero / spaces are output
uOutputDecWord:
            PUSH AF
            PUSH BC
            PUSH DE
            PUSH HL
            EX   DE,HL          ;HL = number to output
            LD   B,1            ;Set leading zero flag 
            LD   DE,0xD8F0      ;-10000
            call @Digit
            LD   DE,0xFC18      ;-1000
            call @Digit
            LD   DE,0xFF9C      ;-100
            call @Digit
            LD   E,0xF6         ;-10
            call @Digit
            LD   E,0xFF         ;-1
            CALL @Digit
            DJNZ @Done          ;Skip if a number has been output 
            LD   A,'0'          ;Otherwise number must be zero
            CALL @Output        ;Output '0'
@Done:      POP  HL
            POP  DE
            POP  BC
            POP  AF
            RET
; Process one digit
@Digit:     LD   A,'0'-1        ;A = Character '0' - 1
@Loop:      INC  A              ;A = A + 1 (eg. Character '0')
            ADD  HL,DE          ;Add supplied digit value
            JR   C,@Loop        ;Repeat until counted this digit
            SBC  HL,DE          ;Adjust remainder
            DJNZ @Output        ;Output if not leading zero
            CP   '0'            ;Leading zero?
            JR   NZ,@Output     ;No, so output it
            INC  B              ;Set leading zero flag
            RET                 ;Abort output of leading zero
@Output:    CALL aOutputChar    ;Output character
            RET
#ENDIF


#IFREQUIRED uFindString
; Locate string in list
;   On entry: A = String number (0 to N)
;             DE = Start of string list
;   On exit:  DE = Address of start of null terminated string
;             BC HL IX IY I AF' BC' DE' HL' preserved
; If string not found the DE points to a null list terminator
; Each string in the list is null terminated. eg:
;           .TEXT "String 1",0
;           .TEXT "String 2",0
;           .DB 0               ;End marker
uFindString:
            OR   A              ;Are we looking for string zero?
            RET  Z              ;Yes, so exit
            PUSH BC
            LD   B,A            ;Store string number
@Next:      LD   A,(DE)         ;Get first character from string
            OR   A              ;End of string list?
            JR   Z,@Exit        ;Yes, so abort
@Char:      LD   A,(DE)         ;Get character from string
            INC  DE             ;Point to next character in string
            OR   A              ;Null terminator?
            JR   NZ,@Char       ;No, so go try next character
            DJNZ @Next          ;Repeat if not the right string
@Exit:      POP  BC
            RET
#ENDIF


; **********************************************************************
; **  Variables
; **********************************************************************

            .DATA               ;Data section

; No variables used










