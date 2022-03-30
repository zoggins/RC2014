; **********************************************************************
; **  Monitor utility functions                 by Stephen C Cousins  **
; **********************************************************************

; This module provides a group of utility functions
;   ConvertBCDToBinary    Convert BCD to binary
;   ConvertBinaryToBCD    Convert binary to BCD
;   ConvertByteToAscii    Convert byte to ASCII character
;   ConvertByteToNibbles  Convert byte to nibbles
;   ConvertStringToNumber Convert hex or decimal string to number
;   FindStringInList      Find start of string in bit 7 delimited list
;   IsCharHex             Is character hexadecimal (0 to 9, A to F)
;   IsCharNumeric         Is character numeric (0 to 9)
;   SearchStringList      Find number of string in bit 7 delimited list
;   SearchStringListNA    Find number of string in bit 7 delimited list
;   WrHexPrefix           Write hex prefix to current string buffer
;   WrInstruction         Write disassembled instruction to buffer
;   WrMemoryDump          Write memory dump line to string buffer
;   WrRegister1           Write registers line 1 to string buffer
;   WrRegister2           Write registers line 2 to string buffer


; **********************************************************************
; **  Public functions                                                **
; **********************************************************************

            .CODE


#IFDEF      kIncludeUnusedCode
; Utility: Convert BCD to binary
;   On entry: A = BCD byte
;   On exit:  A = Binary byte
;             BC DE HL IX IY I AF' BC' DE' HL' preserved
;             Interrupts not enabled
; Method: Determine the value in the top nibble of the supplied BCD
; number, then subtract 6 from the BCD number that many times. 
; So for a BCD number of 45 (hex value 0x45), subtract 4 x 6 from 
; 0x45 = 0x45 - (4 * 6) = 0x45 - 24 = 69 - 24 = 45 = 0x2D
ConvertBCDToBinary:
            PUSH BC
            LD   C,A            ;Store BCD number
            SRL  A              ;Shift top nibble to
            SRL  A              ;  bottom nibble and
            SRL  A              ;  clear top nibble
            SRL  A              ;  so 45 BCD =>  4
            LD   B,A            ;Store shifted value as counter
            OR   A              ;Set zero flag if result is zero
            LD   A,C            ;Get original BCD number
            JR   Z,@ZJB         ;Skip if shifted value is zero
@ZJA:       SUB  6              ;Subtract 6 from BCD number
            DJNZ @ZJA           ;Repeat until counter is zero
@ZJB:       POP  BC
            RET
#ENDIF


#IFDEF      kIncludeUnusedCode
; Utility: Convert binary to BCD 
;   On entry: A = Binary byte
;   On exit:  A = BCD byte
;             BC DE HL IX IY I AF' BC' DE' HL' preserved
;             Interrupts not enabled
; Values > 99 decimal roll over, so 129 is returned as 29
ConvertBinaryToBCD:
            PUSH BC
            LD   C,0            ;Build result in C
@ZAB:       CP   10             ;Remaining value > 9?
            JR   C,@ZAA         ;No, so finish loop
            SUB  10             ;Subtract 10 from remainder
            LD   B,A            ;Store remaining value
            LD   A,C            ;Get result so far
            ADD  0x10           ;Add 0x10 (10 in BCD)
            CP   0xA0           ;Result > 0x90? (90 in BCD)
            JR   C,@ZAC         ;No, so skip
            XOR  A              ;Yes, so clear result to 0
@ZAC:       LD   C,A            ;Store result so far
            LD   A,B            ;Get remaining value
            JR   @ZAB           ;Loop round again
@ZAA:       ADD  A,C            ;Add remainder to result
            POP  BC
            RET
#ENDIF


; Utility: Convert byte to ascii character
;   On entry: A = Byte
;   On exit:  A = ASCII character
;             BC DE HL IX IY I AF' BC' DE' HL' preserved
;             Interrupts enabled during this call
; If not printable then a dot is output instead.
ConvertByteToAscii:
            CP   32             ;<SPACE?
            JR   C,@ZGW
            CP   0x7F           ;>&7F?
            JR   C,@ZGX
@ZGW:       LD   A,'.'
@ZGX:       RET


; Utility: Convert byte to nibbles
;   On entry: A = Hex byte
;   On exit:  D = Most significant nibble
;             E = Least significant nibble
;             A BC HL IX IY I AF' BC' DE' HL' preserved
;             Interrupts not enabled
ConvertByteToNibbles:
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


#IFDEF      kIncludeUnusedCode
; Utility: Convert character to lower case
;   On entry: A = Character in either case
;   On exit:  A = Character in lower case
;             BC DE HL IX IY I AF' BC' DE' HL' preserved
ConvertCharToLCase:
            CP   'A'            ;Character less than 'A'?
            RET  C              ;Yes, so finished
            CP   'Z'+1          ;Character greater than 'Z'?
            RET  NC             ;Yes, so finished
            ADD  'a'-'A'        ;Convert case
            RET
#ENDIF


#IFDEF      kIncludeUnusedCode
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
#ENDIF


; Utility: Convert hexadecimal or decimal text to number
;   On entry: DE = Pointer to start of ASCII string
;   On exit:  If valid number found:
;               A = 0 and Z flagged
;               HL = Number found
;             If valid number not found:
;               A != 0 and NZ flagged
;               HL = Not specified
;             DE = Not specified
;             HL = Number
;             BC DE IX IY I AF' BC' DE' HL' preserved
; Hexadecmal numbers can be prefixed with either "$" or "0x"
; Decimal numbers must be prefixed with "+"
; A number without a prefix is assumed to be hexadecimal
; Hexadecimal number without a prefix must start with "0" to "9"
; ... this is to stop the assembler getting confused between
; ... register names and constants which could be fixed by
; ... re-ordering the (dis)assebmer's instruction table
; Numbers can be terminated with ")", space, null or control code
; Negative numbers, preceded with "-", are not supported
; Text must be terminated with ')', space or control char.
ConvertStringToNumber:
            PUSH BC
            LD   HL,0           ;Build result here
            LD   A,(DE)         ;Get character from string
            CP   '+'            ;Does string start with '+' ?
            JR   Z,@Decimal     ;Yes, so its decimal
            CP   '$'            ;Does string start with '$' ?
            JR   Z,@Hdecimal    ;Yes, so its hexadecimal
            CP   kApostroph     ;Does string start with apostrophe?
            JR   Z,@Char        ;Yes, so its a character
            CP   '"'            ;Does string start with '"' ?
            JR   Z,@Char        ;Yes, so its a character
;;          CALL IsCharNumeric  ;Is first character '0' to '9' ?
;;          JR   NC,@Failure    ;No, so invalid number
;           CALL IsCharHex      ;Is first character hexadecimal ?
;           JR   NC,@Failure    ;No, so invalid hex character
            CP   '0'            ;Is first character '0' ?
            JR   NZ,@HexNext    ;No, so default to hexadecimal
;           JR   NZ,@DecNext    ;No, so default to decimal
            INC  DE             ;Point to next character in string
            LD   A,(DE)         ;Get character from string
            CALL ConvertCharToUCase
            CP   'X'            ;Is second character 'x' ?
            JR   NZ,@HexNext    ;No, so must be default format
;           JR   NZ,@DecNext    ;No, so must be default format
; Hexadecimal number...
@Hdecimal:  INC  DE             ;Point to next character in string
@HexNext:   LD   A,(DE)         ;Get character from string
            CP   ')'            ;Terminated with a bracket?
            JR   Z,@Success     ;yes, so success
            CP   A,kSpace+1     ;Space or control character?
            JR   C,@Success     ;Yes, so successld hl
            CALL ConvertCharToNumber  ;Convert character to number
            JR   NZ,@Failure    ;Return if failure (NZ flagged)
            INC  DE             ;Point to next character in string
            ADD  HL,HL          ;Current result = 16 * current result..
            ADD  HL,HL
            ADD  HL,HL
            ADD  HL,HL
            OR   A,L            ;Add new number (0 to 15)..
            LD   L,A
            JR   @HexNext
; Decimal number...
@Decimal:   INC  DE             ;Point to next character in string
@DecNext:   LD   A,(DE)         ;Get character from string
            CP   ')'            ;Terminated with a bracket?
            JR   Z,@Success     ;yes, so success
            CP   A,kSpace+1     ;Space or control character?
            JR   C,@Success     ;Yes, so success
            CALL IsCharNumeric  ;Is first character '0' to '9' ?
            JR   NC,@Failure    ;No, so invalid number
            CALL ConvertCharToNumber  ;Convert character to number
            JR   NZ,@Failure    ;Return if failure (NZ flagged)
            INC  DE             ;Point to next character in string
            PUSH DE
            LD   B,9            ;Current result = 10 * current result..
            LD   D,H
            LD   E,L
@DecLoop:   ADD  HL,DE          ;Add result to itself 9 times
            DJNZ @DecLoop
            POP  DE
            ADD  A,L            ;Add new number (0 to 15)..
            LD   L,A
            JR   NC,@DecNext
            INC  H
            JR   @DecNext
; Character...
@Char:      INC  DE             ;Point to next character in string
            LD   A,(DE)         ;Get ASCII character
            LD   L,A            ;Store ASCII value as result
            LD   H,0
;           JR   @Success
; Return result...
@Success:   POP  BC
            XOR  A              ;Return success with A = 0 and Z flagged
            RET
@Failure:   POP  BC
            LD   A,0xFF         ;Return failure with A != 0
            OR   A              ;  and NZ flagged
            RET


; Utility: Find start of specified string in bit 7 delimited list
;   On entry: A = String number
;             HL = Start of string list
;   On exit:  HL = Start of string
;             AF BC DE IX IY I AF' BC' DE' HL' preserved
; Find string A in bit 7 delimited string list
FindStringInList:
            PUSH AF
            PUSH BC
            DEC  HL             ;Point to address before string list
            LD   B,A            ;Get string number
@Next:      INC  HL             ;Point to next character
            BIT  7,(HL)         ;Start of new string?
            JR   Z,@Next        ;No, so go get next character
            DJNZ @Next          ;Loop back if not the right string
            POP  BC
            POP  AF
            RET


; Utility: Is character hexadecimal?
;   On entry: A = ASCII character
;   On exit:  Carry flag set if character is hexadecimal (0 to 9, A to F)
;             A BC DE HL IX IY I AF' BC' DE' HL' preserved
IsCharHex:  CP   '0'            ;Less than '0'?
            JR   C,@Not         ;Yes, so go return NOT hex
            CP   '9'+1          ;Less than or equal to '9'?
            RET  C              ;Yes, so numeric (C flagged)
            CALL ConvertCharToUCase
            CP   'A'            ;Less than 'A'
            JR   C,@Not         ;Yes, so go return NOT hex
            CP   'F'+1          ;Less than or equal to 'F'?
            RET  C              ;Yes, so hexadecimal (C flagged)
@Not:       OR   A              ;No, so NOT numeric (NC flagged)
            RET


; Utility: Is character numeric?
;   On entry: A = ASCII character
;   On exit:  Carry flag set if character is numeric (0 to 9)
;             A BC DE HL IX IY I AF' BC' DE' HL' preserved
IsCharNumeric:
            CP   '0'            ;Less than '0'?
            JR   C,@Not         ;Yes, so go return NOT numeric
            CP   '9'+1          ;Less than or equal to '9'?
            RET  C              ;Yes, so numeric (C flagged)
@Not:       OR   A              ;No, so NOT numeric (NC flagged)
            RET

; Utility: Find number of matching string in bit 7 delimited string list
;   On entry: BC = Start of address list
;             DE = Start of target string
;             HL = Start of bit 7 delimited string list
;   On exit:  If string found in list:
;               A = String number in list (1 to 127) and NZ flagged
;               DE = Next address after target string
;               HL = Address from address list
;             If string not found in list:
;               A = 0 and Z flagged
;               DE = Start of target string (preserved)
;               HL = Not specified
;             BC IX IY I AF' BC' DE' HL' preserved
; Target string can be terminated with and control character or a space.
SearchStringList:
            PUSH BC             ;Preserve start of address table
            LD   B,0            ;String counter
            PUSH DE             ;Preserve start of target string
; Find start of next string in list
@NextStr:   INC  B              ;Increment string count
            POP  DE             ;Restore start of target string
            PUSH DE             ;Preserve start of target string
@NextChar:  BIT  7,(HL)         ;Start of new string?
            JR   NZ,@CompNext   ;Yes, so go compare characters
            INC  HL             ;No, so point to next character
            JR   @NextChar      ;  and go consider it
; Compare target string (at DE) with string from list (at HL)
@CompNext:  LD   A,(HL)         ;Get character from list
            CP   0x80           ;End of list?
            JR   Z,@Failed      ;Yes, so failed to find string
@CompChar:  LD   A,(HL)         ;Get character from list string
            AND  0x7F           ;Mask off bit 7 start flag
            LD   C,A            ;Store upper case char from list
            LD   A,(DE)         ;Get character from target string
            INC  HL             ;Point to next character in list
            INC  DE             ;Point to next character in target
            CALL ConvertCharToUCase
            CP   C              ;Match with list character?
            JR   NZ,@NextStr    ;No, so go try next list string
; Strings matching so far so check for end of both
            LD   A,(DE)         ;Get character from target
;           CP   kSpace+1       ;End if target string?
;           JR   C,@Abbrev      ;Yes, so go (allow abbreviations)
            CP   kSpace+1       ;End of target string?
            JR   C,@EndT        ;Yes, so go check end of list str
            BIT  7,(HL)         ;End of string in list?
            JR   Z,@CompChar    ;No, so go compare next character
            JR   @NextStr       ;Yes, so go try next string
; End of target string found
@EndT:      BIT  7,(HL)         ;End of string in list as well?
            JR   Z,@NextStr     ;No, so go try next string
; Found target string in string list
; So get address from address list
;@Abbrev:
            POP  HL             ;Restore start of target string
            POP  HL             ;Restore start of address table
            PUSH HL             ;Preserve start of address table
            DEC  HL             ;Point to start address -2
            DEC  HL
            LD   C,B            ;Get string number (1 to N)
@Loop:      INC  HL
            INC  HL
            DJNZ @Loop
            LD   B,(HL)         ;Get address from table
            INC  HL
            LD   H,(HL)
            LD   L,B
            LD   A,C            ;Return number of this string in list
            JR   @Exit
; Failed to find target string in string list
@Failed:    POP  BC             ;Restore start of target string
            XOR  A              ;Return zero if failed to find string
@Exit:      OR   A              ;Return Z flag if not found
            POP  BC             ;Restore start of address table
            RET


; Utility: Find number of matching string in bit 7 delimited string list
;   On entry: DE = Start of target string
;             HL = Start of bit 7 delimited string list
;   On exit:  If string found in list:
;               A = String number in list (1 to 127) and NZ flagged
;               DE = Next address after target string
;               HL = Address from address list
;             If string not found in list:
;               A = 0 and Z flagged
;               DE = Not specified
;               HL = Not specified
;             BC IX IY I AF' BC' DE' HL' preserved
; Target string can be terminated with and control character or a space.
; This version of the search function is for use where there is no 
; associated address table. A dummy address table is set up here such
; that the main search function has somewhere harmless to pick up an
; address word (which is just whatever is in memory at the time).
SearchStringListNA:
            PUSH BC             ;Preserve start of address table
            LD   BC,SearchStringListNA  ;Dummy address
            CALL SearchStringList
            POP  BC
            RET


; Utility: Write hex prefix (eg. "0x") to current string buffer
;   On entry: No parameters required
;   On exit:  AF BC DE HL IX IY I AF' BC' DE' HL' preserved
WrHexPrefix:
            PUSH AF
            LD   A,'$'
            CALL StrWrChar      ;Write '$'
;           LD   A,'0'
;           CALL StrWrChar      ;Write '0'
;           LD   A,'x'
;           CALL StrWrChar      ;Write 'x'
            POP  AF
            RET


; Utility: Disassemble instruction and write to default string
;   On entry: HL = Start of instruction to be disassembled
;   On exit:  HL = Address after this instruction
;                  or start address + 1 if no disassembler
;             BC IX IY I AF' BC' DE' HL' preserved
; If the disassembler is not included the address and hex opcode bytes
; are output instead.
WrInstruction:
#IFDEF      IncludeDisassemble
; Disassembler available so display address, opcode bytes and mnemonic
            CALL DisWrInstruction
            LD   A,47           ;Column number
            CALL StrWrPadding   ;Pad with spaces to specified column
#ELSE
; No disassembler so just display address and hex opcode bytes
            CALL StrInitDefault ;Initialise default string buffer
            LD   D,H            ;Get current address
            LD   E,L
            INC  HL             ;Prepare return address
            CALL StrWrHexWord   ;Display breakpoint address
            LD   A,':'
            CALL StrWrChar      ;Print ':'
;           LD   A,(DE)         ;Get op-code at PC
            LD   A,4            ;Get length of instruction TODO
            LD   B,A
@ZAO:       CALL StrWrSpace
            LD   A,(DE)         ;Read byte at PC
            CALL StrWrHexByte
            INC  DE
            DJNZ @ZAO
;           LD   A,'?'
;           CALL StrWrChar      ;Print '?' (no disassembly)
            LD   A,25           ;Column number
            CALL StrWrPadding   ;Pad with spaces to specified column
#ENDIF
; With or without disassembler, terminate instruction line
            LD   A,'>'
            CALL StrWrChar      ;Write '>' to string
            JP   StrWrSpace     ;Write space to string


; Utility: Write memory dump line to default string buffer
;   On entry: DE = Start location
;   On exit:  DE = Next address after dump
;             AF BC HL IX IY I AF' BC' DE' HL' preserved
WrMemoryDump:
            PUSH AF
            PUSH BC
; Write once line of memory dump
; Write memory contents in hex 
@Line:      PUSH DE             ;Store start address of this line
            CALL StrInitDefault ;Initialise default string buffer
            CALL StrWrAddress   ;Write address, colon, space
            LD   B,16           ;Write 16 hex bytes...
@Hex:       CALL StrWrSpace     ;Write space to string buffer
            LD   A,(DE)         ;Get byte from memory
            CALL StrWrHexByte   ;Write hex byte to string buffer
            INC  DE             ;Point to next memory location
            LD   A,E            ;Add extra space after 8 bytes...
            AND   7             ;Test for byte 8
            CALL Z,StrWrSpace   ;Tes, so write space to string
            DJNZ @Hex           ;Repeat until all done
            POP  DE             ;Get start address of this line
            CALL StrWrSpace     ;Write spaces
            LD   B,16           ;Write 16 ascii characters...
; Write memory contents in ASCII
@Ascii:     LD   A,(DE)         ;Get byte from memory
            CALL StrWrAsciiChar ;Convert to ASCII character or dot
            INC  DE             ;Point to next memory location
            DJNZ @Ascii         ;Repeat until all done
            CALL StrWrNewLine   ;Write new line to string buffer
            POP  BC
            POP  AF
            RET


#IFDEF      IncludeMonitor
; Utility: Write register values and flags to default string bufffer
;   On entry: No parameters
;   On exit:  IX IY I AF' BC' DE' HL' I AF' BC' DE' HL' preserved
WrRegister1:
            LD   DE,sRegisters  ;Register strings (line 1)
            LD   HL,iRegisters  ;Register values
            LD   BC,iAF         ;Flags value
            JR   WrRegister     ;Go write registers
WrRegister2:
            LD   DE,sRegister2  ;Register strings (line 2)
            LD   HL,iRegister2  ;Register values
            LD   BC,iAF2        ;Flags value
; Write register details in BC, DE and HL, to string buffer
WrRegister: CALL StrInitDefault ;Initialise default string buffer
@Name:      LD   A,(DE)         ;Get character of register name
            INC  DE             ;Point to next character of name
            CP   ','            ;Character is comma?
            JR   Z,@Value       ;Yes, so go write value
            CP   '-'            ;Character is '-'?
            JR   Z,@WriteFlag   ;Yes, so go write flags
            OR   A              ;Null terminator?
            JR   Z,@WriteEOL    ;Yes, so we've finished
            CALL StrWrChar      ;Write character of register name
            JR   @Name          ;Loop back for next character
; Write register values in hex
@Value:     PUSH DE
            LD   E,(HL)         ;Get lo byte of register value
            INC  HL
            LD   D,(HL)         ;Get hi byte of register value
            INC  HL
            CALL StrWrHexWord   ;Write register value
            POP  DE
            CALL StrWrSpace
            JR   @Name          ;Loop back for next register
; Write flags
@WriteFlag: LD   D,B            ;Get address of flags register
            LD   E,C
            LD   C,0x80         ;Initialise flag bit mask
            LD   HL,sFlags      ;Point to flags string
@NextFlag:  LD   A,(HL)         ;Get flag character
            CP   '-'            ;Flag bit used?
            JR   Z,@ZBU         ;No, so skip
            LD   A,(DE)         ;Get flags register
            AND  C              ;Test with bit mask C
            JR   Z,@ZBT         ;Flag not set, so skip
            LD   A,(HL)         ;Flag set, so get flag char
            JR   @ZBU
@ZBT:       LD   A,'-'          ;Flag not set, so use '-' char
@ZBU:       CALL StrWrChar      ;Write flag character or '-'
            INC  HL             ;Prepare for next flag
            SRL  C              ;Shift flag bit mask
            JR   NC,@NextFlag   ;No carry, so loop to next bit
; Write end of line
@WriteEOL:  CALL StrWrNewLine   ;New line
            RET
#ENDIF

; **********************************************************************
; **  End of Utility functions module                                 **
; **********************************************************************





