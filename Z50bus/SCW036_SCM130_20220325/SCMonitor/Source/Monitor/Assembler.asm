; **********************************************************************
; **  Assembler support                         by Stephen C Cousins  **
; **********************************************************************

; This module provides in-line assembly for a single instruction. It
; provides one public function which assembles the supplied string:
;
; Function: Assemble
; This takes the string pointed to by DE (eg. "LD A,2") and writes
; the instruction's opcodes to the address pointed to by HL.
;
; This module requires the Disassembler support module to be included
; as it makes heavy use of its functions and data.
;
; Assembly method:
; Try each possible instruction in the DistInst list.
; To save time the following are cached first:
;   Operation string number
;   Location of start of each operand string
;   Each operand string is null terminated


; **********************************************************************
; **  Public functions                                                **
; **********************************************************************

            .CODE

; Assemble instruction in input buffer
;   On entry: DE = Start location of buffer
;             HL = Address to store opcodes
;   On exit:  If instruction is valid:
;               Opcodes written to memory
;               A = Length of instruction in bytes and NZ flagged
;               HL = Address of next instruction
;             If invalid instruction:
;               Opcodes not written to memory
;               A = Error messgae number and Z flagged
;                   0 = Unspecified error, so report 'Syntax error'
;             IY I AF' BC' DE' HL' preserved
Assemble:   CALL InputBufConvUpper  ;Convert input string to upper case
            PUSH HL             ;Preserve address of opcodes
            LD   B,1            ;Length of instruction
; Get operation string number
            LD   HL,DisString+1 ;Skip string 1 (blank string)
;           CALL SearchStringListNA
            CALL SearchStringList
            JR   Z,@Error       ;Not found so error
            INC  A              ;Adjust as first string skipped
            LD   (iAsmOper),A   ;Store operation string number
; Get operand 1 string start address
            CALL AsmSkipOverDelimiter
            LD   (iAsmOp1),DE   ;Store operand 1 start address
            CALL AsmSkipToDelimiter
            LD   H,D            ;Remember start of delimiter
            LD   L,E
; Get operand 2 string start address
            CALL AsmSkipOverDelimiter
            LD   (iAsmOp2),DE   ;Store operand 2 start address
            CALL AsmSkipToDelimiter
; Terminate operands and set default index instruction
            XOR  A
            LD   (HL),A         ;Terminate operand 1 with null
            LD   (DE),A         ;Terminate operand 2 with null
            LD   (iAsmIndex),A  ;Default to no index instruction
            LD   (iAsmDisFl),A  ;Clear displacement flag
; Substitute HL for IX and IY
            LD   HL,(iAsmOp1)   ;Start of operand 1 string
            CALL AsmSubsIndex   ;Substitute HL for IX/IY in operand 1
            LD   HL,(iAsmOp2)   ;Start of operand 2 string
            CALL AsmSubsIndex   ;Substitute HL for IX/IY in operand 1
; Try each instruction in the instruction list
            LD   IX,DisInst     ;Start of instruction list
@Next:      XOR  A              ;Clear A
            LD   (iAsmPri),A    ;Clear primary opcode special bits
            LD   (iAsmLenIm),A  ;Clear length of immediate value
            CALL AsmTestInstruction
            JR   Z,@Found       ;Instruction found in table so skip
            PUSH BC             ;Preserve BC
            LD   B,5            ;Move IX to start of next
@Inc:       INC  IX             ;  table entry by adding 5
            DJNZ @Inc
            POP  BC             ;Restore BC
            LD   A,(IX+1)       ;Get instruction bit mask
            OR   A              ;Bit mask zero? (marks end of table)
            JR   NZ,@Next       ;No, so go try this instrucion
; Operation string not found in table
@Error:     POP  HL             ;Restore address of opcodes
            XOR  A              ;Return error A=0 and Z flagged
            RET
; Found instruction, so write opcodes to memory
; If there is an index instruction with displacement the displacement
; value is always the third opcode of the instruction
@Found:     POP  HL             ;Restore address of opcodes
            LD   C,0            ;Clear opcode counter
; Index instruction prefix
            LD   A,(iAsmIndex)  ;Get index instuction opcode
            OR   A              ;Zero? (not an index instruction)
            JR   Z,@NoIndex     ;Yes, so skip
            LD   (HL),A         ;Store index instruction opcode
            INC  HL             ;Increment opcode pointer
            INC  C              ;Increment opcode counter
@NoIndex:
; Extended instruction prefix
            BIT  7,(IX+3)       ;Extended instruction?
            JR   Z,@NoExtn      ;No, so skip
            LD   A,0xCB         ;Default prefix = 0xCB
            BIT  6,(IX+3)       ;Is Prefix = 0xED?
            JR   Z,@GotPrefix   ;No, so skip
            LD   A,0xED         ;Prefix = 0xED
@GotPrefix: LD   (HL),A         ;Store extended instruction opcode
            INC  HL             ;Increment opcode pointer
            INC  C              ;Increment opcode counter
@NoExtn:
; Index instruction displacement
            CALL @Displace      ;Optionally put displacement here
; Primary opcode
            LD   A,(iAsmPri)    ;Get extra bits for primary opcode
            OR   (IX+0)         ;Include primary opcode from table
            LD   (HL),A         ;Store primary opcode in memory
            INC  HL             ;Increment opcode pointer
            INC  C              ;Increment opcode counter
; Index instruction displacement
            CALL @Displace      ;Optionally put displacement here
; Immediate value
            LD   A,(iAsmLenIm)  ;Get length of immediate value
            OR   A              ;Zero? (no immediate value)
            JR   Z,@NoImmed     ;Yes, so skip
            LD   B,A            ;Remember length of immediate value
; Is immediate value a relative jump?
            LD   A,(iAsmOper)   ;Get operation number
            CP   kDisJR         ;JR instruction ?
            JR   Z,@RelJp       ;Yes, so skip
            CP   kDisDJNZ       ;DJNZ instruction ?
            JR   NZ,@GetImmed   ;No, so skip
; Immediate value is a relative jump
@RelJp:     PUSH HL             ;Preserve current opcode pointer
            LD   D,H            ;Get current address..
            LD   E,L
            INC  DE             ;Increment to end of instruction
            LD   HL,(iAsmImmed) ;Get destination address..
            LD   A,H            ;If the value entered is a single 
            OR   A              ;  byte we skip the calculation
            LD   A,L            ;  and just use value supplied
            JR   Z,@RelStore
            OR   A              ;Clear carry flag
            SBC  HL,DE          ;Calculate relative jump
; Trap jump which is too bog
            JR   C,@RelJpNeg    ;Skip if negative displacement
            LD   A,H            ;Get hi byte of displacement
            OR   A              ;0x00 ?
            JR   NZ,@RelTooBig  ;No, so too big
            BIT  7,L            ;Test if < 128
            JR   Z,@RelJpOK     ;Skip if within range
            JR   @RelTooBig     ;Displacement too big
@RelJpNeg:  LD   A,H            ;Get hi byte of displacement
            INC  A              ;0xFF ?
            JR   NZ,@RelTooBig  ;No, so too big
            BIT  7,L            ;Test if > -128
            JR   NZ,@RelJpOK    ;Skip if within range
@RelTooBig: POP  HL             ;Restore opcode pointer
            JR   @TooBig        ;Return with error
@RelJpOK:   LD   A,L            ;Get relative jump
@RelStore:  POP  HL             ;Restore opcode pointer
            LD   (HL),A         ;Store relative jump in memory
            INC  HL             ;Point to next opcode address
            JR   @NoImmed
; Immediate value is not a relative jump
; B = Length of immediate value in bytes (ie. 1 or 2)
@GetImmed:  LD   A,B            ;Get length of immediate value
            CP   2              ;Two byte value?
            JR   Z,@WrImmed     ;Yes, so skip test for too big
            LD   A,(iAsmImmed+1)  ;Get hi byte of immediate value
            OR   A              ;Zero?
            JR   NZ,@TooBig     ;No, so value is too big
@WrImmed:   LD   DE,iAsmImmed   ;Get address of immediate value
@WrImLoop:  LD   A,(DE)         ;Get byte of immediate value
            LD   (HL),A         ;Write to memory
            INC  DE             ;Point to next byte of immediate value
            INC  HL             ;Increment opcode pointer
            INC  C              ;Increment opcode counter
            DJNZ @WrImLoop      ;Loop until immediate is finished
@NoImmed:
; Return with length of instruction or failure flag
            LD   A,C            ;Return success A>0 and NZ flagged
            OR   A              ;  or error A=0 and Z flagged
            RET
; Return with failure flagged (immediate value to big)
@TooBig:    XOR  A              ;Return error A=0 and Z flagged
            LD   A,kMsgBadPar
            CP   A
            RET
; Consider if displacement opcode should be stored here
@Displace:  LD   A,C            ;Get opcode counter
            CP   2              ;Opcode byte 2?
            RET  NZ             ;No, so return
            LD   A,(iAsmDisFl)  ;Get opcode displacement flag
            OR   A              ;Zero? (no displacement)
            RET  Z              ;Yes, so return
            LD   A,(iAsmDisp)   ;Get displacement value
            LD   (HL),A         ;Store as opcode
            INC  HL             ;Increment opcode pointer
            INC  C              ;Increment opcode counter
            XOR  A              ;Clear A
            LD   (iAsmDisFl),A  ;Clear displacement flag
            RET                 ;  as we've handled it


; **********************************************************************
; **  Private functions                                               **
; **********************************************************************


; Substitue index instruction (where appropriate)
;   On entry: HL = Start of operand string
;   On exit:  Operand string modified (where appropriate)
;             iAsmPri, iAsmImmed, iAsmLenIm updated
;             B IX IY I AF' BC' DE' HL' preserved
; Substitute "HL" for "IX" or "IY"
; Substitute "(HL)" for "(IX+d)" or "(IY+d)", and store displacement
;   except for JP instruction which does not have a displacement
; Substitute "-" for "(HL)" and thus also "(IX+d)" and "(IY+d)"
AsmSubsIndex:
            LD   D,H            ;Remember start of operand..
            LD   E,L
; Is the operand string "(HL)" ?
            LD   A,(HL)         ;Get first character
            CP   '('            ;Is it '(' ?
            JR   NZ,@NoBrac     ;No, so skip
            INC  HL             ;Point to second character
            LD   A,(HL)         ;Get second character
            CP   'H'            ;Is it 'H' ?
            JR   NZ,@NoBrac     ;No, so skip
            INC  HL             ;Point to third character
            LD   A,(HL)         ;Get third character
            CP   'L'            ;Is it 'L' ?
            JR   NZ,@NoBrac     ;No, so skip
            INC  HL             ;Point to fourth character
            LD   A,(HL)         ;Get fourth character
            CP   ')'            ;Is it ')' ?
            JR   Z,@SubMinus    ;Yes, so we found "(HL)"
; Not "(HL)" so check for "IX", "IY" (can have leading bracket)
@NoBrac:    CP   'I'            ;Operand character = 'I' ?
            RET   NZ            ;No, so exit
            INC  HL             ;Point to next character
;           PUSH BC
            LD   C,0            ;Default to no index
            LD   A,(HL)         ;Get next character
            CP   'X'            ;Operand character = 'X' ?
            JR   NZ,@NotIndX    ;No, so not index register X
            LD   C,0xDD         ;Store IX opcode
@NotIndX:   CP   'Y'            ;Operand character = 'Y' ?
            JR   NZ,@NotIndY    ;No, so not index register Y
            LD   C,0xFD         ;Store IX opcode
@NotIndY:   LD   A,C            ;Get index opcode (if there is one)
;           POP  BC
            OR   A              ;Is this an index instruction?
            RET  Z              ;No, so exit
; We found IX or IY, so replace with "HL"
            LD   (iAsmIndex),A  ;Store index opcode
            DEC  HL             ;Point to previous character ('I')
            LD   (HL),'H'       ;Replace with 'H'
            INC  HL             ;Point to next character
            LD   (HL),'L'       ;Replace with 'L'
; Now look for <+displacement> eg. "(IX+12)"
; Replacing with "-" and storing displacement value
            LD   A,(iAsmOper)   ;Get instruction number
            CP   kDisJP         ;JP instruction?
            RET  Z              ;Yes, so abort as no displacement
            INC  HL             ;Point to next character
            LD   A,(HL)         ;Get next character
            CP   '+'            ;Displacement to follow?
            RET  NZ             ;No, so exit
; We are not bothering to raise an error for bad syntax here
; as it gets trapped later.
            PUSH DE             ;Preserve start of operand string
            INC  HL             ;Point to displacement string
            LD   D,H            ;Get address hi byte of string
            LD   E,L            ;Get address lo byte of string
            CALL ConvertStringToNumber
            LD   A,L            ;Get lo byte of number
            LD   (iAsmDisp),A   ;Store as displacement
            LD   A,0xFF         ;Get value to use as flag
            LD   (iAsmDisFl),A  ;Flag displacement present
            POP  DE             ;Restore start of operand string
; Store "-" in string instead of "(HL)" or "(IX+d)" or "(IY+d)"
; Except for JP (HL) or (IX) or (IY)
@SubMinus:  LD   A,(iAsmOper)   ;Get instruction number
            CP   kDisJP         ;JP instruction?
            RET  Z              ;Yes, so abort
            LD   H,D            ;Restore to start of operand..
            LD   L,E
            LD   (HL),'-'       ;Replace operand string with "-"
            INC  HL
            LD   (HL),0         ;Terminate operand string
@NotInd:    RET


; Skip over delimiter
;   On entry: DE = Start of target string
;   On exit:  DE = Address of first non-delimiter or null
;             If null found then A=0 and Z flagged
;             If other non-delimiter found then A>0 and NZ flagged
;             BC HL IX IY I AF' BC' DE' HL' preserved
; A delimiter is a space, a comma or any control character other than null.
; The address returned can be that of the string's null terminator.
AsmSkipOverDelimiter:
@Loop:      LD   A,(DE)         ;Get character from input line
            OR   A              ;End of line (null)?
            RET  Z              ;Yes, so return with Z flagged
            CP   ','            ;Comma?
            JR   Z,@Next        ;Yes, so skip
            CP   kSpace+1       ;Character > space?
            JR   NC,@Other      ;Yes, so skip
@Next:      INC  DE             ;No, so skip delimiter
            JR   @Loop          ;  and go try next character
@Other:     OR   A              ;Return NZ as non-delimiter other
            RET                 ;  than null


; Skip to delimiter
;   On entry: DE = Start of target string
;   On exit:  DE = Address of first delimiter or null
;             If null found then A=0 and Z flagged
;             If delimiter found then A>0 but Z flag unknown
;             A=0 and Z flagged if non-delimter is not found
;             BC HL IX IY I AF' BC' DE' HL' preserved
; A delimiter is a space, a comma or any control character other than null.
; The address returned can be that of the string's null terminator.
AsmSkipToDelimiter:
@Loop:      LD   A,(DE)         ;Get character from input line
            OR   A              ;End of line (null)?
            RET  Z              ;Yes, so return with Z flagged
            CP   ','            ;Comma?
            RET  Z              ;Yes, so return with Z flagged
            CP   kSpace+1       ;Character > space?
            RET  C              ;No, so return with NZ flagged
@Next:      INC  DE             ;Yes, so skip non-delimiter
            JR   @Loop          ;  and go try next character


; Test if instruction matches table entry
;   On entry: IX = Instruction table entry address
;             iAsmOper = Operation string number
;             iAsmOp1 = Pointer to start of operand 1 string
;             iAsmOp2 = Pointer to start of operand 2 string
;   On exit:  If match found A = 0 and Z flagged
;             BC HL IX IY I AF' BC' DE' HL' preserved
;   Calls AsmTestOperand:
;             iAsmPri, iAsmImmed, iAsmLenIm updated
AsmTestInstruction:
            LD   A,(iAsmOper)   ;Get operation string number
            CP   (IX+2)         ;Compare with table
            RET  NZ             ;Failed so return NZ
            LD   DE,(iAsmOp1)   ;Get address of operand 1 string
            LD   A,(IX+3)       ;Get operand 1 string number
            AND  0x3F           ;Mask away unwanted bits
            CALL AsmTestOperand ;Test this operand
            RET  NZ             ;Failed so return NZ
            LD   DE,(iAsmOp2)   ;Get address of operand 2 string
            LD   A,(IX+4)       ;Get operand 2 string number
            AND  0x3F           ;Mask away unwabted bits
            CALL AsmTestOperand ;Test this operand
            RET  NZ             ;Failed so return NZ
;           LD   (iAsmOp2),HL   ;Store result of operand 2
; Succeeded in finding instruction in table
@Success:   XOR  A              ;Success so return Z
            RET


; Test if operand matches table entry
;   On entry: A = Operand string number from table
;             DE = Start of target operand string
;             IX = Instruction table entry address
;             iAsmOper = Operation string number
;             iAsmOp1 = Pointer to start of operand 1 string
;             iAsmOp2 = Pointer to start of operand 2 string
;   On exit:  If match found A = 0 and Z flagged
;             BC HL IX IY I AF' BC' DE' HL' preserved
;             iAsmPri, iAsmImmed, iAsmLenIm updated
AsmTestOperand:
            LD   C,A            ;Store string number from table
            CP   kDisSubsL+1    ;Is operand a substitution string?
            JR   C,@Subs        ;Yes, so skip
; Operand is a constant string which should be in string list
            LD   HL,DisString+1 ;Skip string 1 (blank string)
;           CALL SearchStringListNA
            CALL SearchStringList
            JR   Z,@Failure     ;Not found so failure
            INC  A              ;Adjust for first string number
            CP   C              ;Do strings match?
            JR   Z,@Success     ;Yes, so we've found it
            JR   @Failure       ;No, so go return failure
; Operand in table is a substitution string
@Subs:      CP   1              ;String 1 = ""
            JR   NZ,@NotNull
            LD   A,(DE)         ;Get operand's first character
            OR   A              ;Null
            RET  Z              ;Yes, so return success
@NotNull:
; Calculate operand table location for this operand and get details
            LD   HL,DisOperandTable-2
            ADD  A,A            ;Two bytes per entry
            ADD  A,L            ;Add to start of table
            LD   L,A            ;Store updated lo byte
            JR   NC,@NoOverFlo  ;Skip if no overflow
            INC  H              ;Overflow so increment hi byte
@NoOverFlo: LD   C,(HL)         ;Get substitution string number
            INC  HL             ;Point to BIILMM bits
            LD   B,(HL)         ;Get BIILMM function bits
;           PUSH DE             ;So we can use E for scratch reg
; Process this operand as detailed in DE, left bracket?
            BIT  kDisBrack,B    ;Bracket flagged?
            JR   Z,@NoBracL     ;No, so skip
            LD   A,(DE)         ;Get char from target string
            INC  DE             ;Point to next char in target
            CP   A,'('          ;Is it a left bracket character?
            JR   NZ,@Failure
@NoBracL:   
; Process this operand as detailed in BC, immediate value?
            BIT  kDisImmed,B    ;Immediate value flagged?
            JR   Z,@NoImmedia   ;No, so skip
            CALL ConvertStringToNumber
            JR   NZ,@Failure
            LD   (iAsmImmed),HL ;Store immediate value
            LD   A,1
            BIT  kDisWord,B     ;Immediate value is a word?
            JR   Z,@ImmedLo     ;No, so skip
            INC  A              ;Increment offset to hi byte
@ImmedLo:   LD   (iAsmLenIm),A  ;Store length of immediate value
@NoImmedia:
; Process this operand as detailed in DE, right bracket?
            BIT  kDisBrack,B    ;Bracket flagged?
            JR   Z,@NoBracR     ;No, so skip
            LD   A,(DE)         ;Get char from target string
            INC  DE             ;Point to next char in target
            CP   A,')'          ;Is it a left bracket character?
            JR   NZ,@Failure
@NoBracR:   
; Process this operand as detailed in DE, substitution string?
            LD   A,C            ;Get substitution string number?
            OR   A              ;Substitution string?
            JR   Z,@Success     ;No, so we've finished
; A = Substitution string number eg. "CDEHL-A"
; Find the substitution string and search it for target string
            LD   HL,DisString   ;Start of disassembler's string list
            CALL FindStringInList ;Set HL=Start of substitution string
            CALL @Instring      ;Look for target in subs string
            JR   NZ,@Failure
; C = Target string's position in substitution string (0 to 3)
; B = Function bits BIILMM from DisOperandTable
; Convert position to bit pattern for instruction opcode
; Do this by shifting bits right as many times as it takes to shift
; right the mask, from masktable, to get a one in the carry flag.
            LD   A,B            ;Get BIILMM function bits
            AND  A,kDisMask     ;Separate mask type bits
            LD   HL,DisMaskTable  ;Point to table of mask bits
            ADD  A,L            ;Add to start of table
            LD   L,A            ;Store updated lo byte
            JR   NC,@NoOFlow    ;Skip if no overflow
            INC  H              ;Overflow so increment hi byte
@NoOFlow:   LD   B,(HL)         ;Get bit mask from mask table
            LD   A,C            ;Get position in string
@SubsShift: SRL  B              ;Shift mask right
            JR   C,@DoneShift   ;If bit 1 was set then we're done
            RLCA                ;Shift position/opcode bits left
            JR   @SubsShift     ;Go repeat..
@DoneShift: LD   HL,iAsmPri     ;Point to primary opcode bits
            OR   (HL)           ;Include new bits
            LD   (HL),A         ;Store primary opcode bits
            JR   @Success
; Failed to find operand in table etc
@Failure:   LD   A,0xFF
            OR   A              ;Failure so return NZ
            RET
; Succeeded in finding operand in table
@Success:   XOR  A              ;Success so return Z
            RET


; Instring function
;   On entry: A = Substitution string number
;             DE = Start of target string (1 or 2 characters)
;             HL = Start of substitution string
;   On exit:  If match found Z flagged, and
;               C = Position in substitution string (0 to 3)
;             B IX IY I AF' BC' DE' HL' preserved
; Subroutine to look for target string (DE) is substitution string (HL)
; Substitution string may be something like this: "BCDEHL-A"
; Target string may be something like "BC"<null>
; Substitution strings are delimited by first character having bit 7 set
; Target strings can be one or two characters long and null terminated
@Instring:  
; Special handling for RST instruction
            CP   0x13           ;Substution of RST address?
            JR   NZ,@InStNotRST ;Skip if not RST instruction
            PUSH HL
            CALL ConvertStringToNumber  ;Convert string at DE
            LD   A,L            ;Get operand
            CALL ConvertByteToNibbles
            LD   A,D            ;Get MSByte of operand
            OR   '0'            ;Convert to ASCII
            LD   (kStrBuffer+$70),A ;Store in temporary space
            LD   A,E            ;Get MSByte of operand
            OR   '0'            ;Convert to ASCII
            LD   (kStrBuffer+$71),A ;Store in temporary space
            XOR  A              ;Clear A as string terminator
            LD   (kStrBuffer+$72),A ;StoreRST 00 in temporary space
            LD   DE,kStrBuffer+$70
            POP  HL
@InStNotRST:
; Handle standard formats
            LD   C,0xFF         ;Count poisition in subs string
            BIT  kDisLength,B   ;Two character substitution
            JR   NZ,@Instr2     ;Yes, so go..
; Single byte target string
@NextS1:    INC  C              ;Count position in subs string
            LD   A,(DE)         ;Get character from target string
            XOR  (HL)           ;Compare with char from subs string
            AND  0x7F           ;Mask off start of string bit
            JR   Z,@InstrOK     ;Skip if characters match
            INC  HL             ;Try next character in subs string
            BIT  7,(HL)         ;End of substitution string?
            JR   Z,@NextS1      ;No, so try next character
            RET                 ;Return failure (NZ flagged)
; Two byte target string
@Instr2:    INC  C              ;Count position in subs string
            LD   A,(DE)         ;Get character from target string
            CP   'H'            ;Substitute '*' for 'H'...
            JR   NZ,@NotH
            LD   A,'*'
@NotH:      XOR  (HL)           ;Compare with char from subs string
            AND  0x7F           ;Mask off start of string bit
            INC  HL             ;Prepare to try next char in subs
            JR   NZ,@InstrN1    ;Skip if chars don't match
            INC  DE             ;Compare with second char in target
            LD   A,(DE)         ;Get character from target string
            CP   'L'            ;Substitute '*' for 'L'...
            JR   NZ,@NotL
            LD   A,'*'
@NotL:      XOR  (HL)           ;Compare with char from subs string
            JR   Z,@InstrOK     ;Characters match so go..
            DEC  DE             ;Compare with first char in target
            LD   A,(HL)         ;Check if subs is a null character
            CP   '.'            ;  represented by a '.'
            JR   Z,@InstrOK     ;Yes, so go..
@InstrN1:   INC  HL             ;Point to next pair in subs string
@InstrNext: BIT  7,(HL)         ;End of substitution string?
            JR   Z,@Instr2      ;No, so try next character
            RET                 ;Return failure (NZ flagged)
; Strings match so check there are no more chars in target string
@InstrOK:   INC  DE             ;Check next char in target is null
            LD   A,(DE)         ;Get character from target string
            OR   A              ;Null?
            RET                 ;Yes, so return success(Z)/failure(NZ)


; **********************************************************************
; **  Private workspace (in RAM)                                      **
; **********************************************************************

            .DATA

iAsmOper:   .DB  0              ;Instruction operation number
iAsmOp1:    .DW  0              ;Instruction operand 1 number
iAsmOp2:    .DW  0              ;Instruction operand 2 number
iAsmIndex:  .DB  0              ;Index instruction opcode
iAsmPri:    .DB  0              ;Primary opcode
iAsmImmed:  .DW  0              ;Immediate value
iAsmLenIm:  .DB  0              ;Length of immedaite value
iAsmDisp:   .DB  0              ;Displacement value
iAsmDisFl:  .DB  0              ;Displacement flag


; **********************************************************************
; **  End of Assembler support module                                 **
; **********************************************************************

