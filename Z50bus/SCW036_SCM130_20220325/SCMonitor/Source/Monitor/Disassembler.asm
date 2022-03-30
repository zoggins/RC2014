; **********************************************************************
; **  Disassembler support                      by Stephen C Cousins  **
; **********************************************************************

; This module provides instruction disassembly support. There are two
; main public functions which disassemble an instruction and provide the
; result as a string in the current string buffer. These are:
;
; Function: DisWrInstruction
; This returns a string in the format: Address: Opcodes  Mnemonic
; eg.   0300: CD FB 01       CALL 0x1FB
; It also returns the length of the instruction in bytes and the 
; address of the next instruction.
;
; Function: DisWrMnemonic
; This returns a string in the format: Mnemonic only
; eg.   CALL 0x1FB
; It also returns the length of the instruction in bytes.
;
; This module also provides the public helper function:
;
; Function: DisGetNextAddress
; Returns address of next instruction to be executed. This is used by 
; the single stepping feature. It takes into account flags to determine
; outcome of conditional instructions.
;
; Further documentation and notes are at the end of this file.
;
; Public functions provided
;   DisWrInstruction      Returns string if full details
;   DisWrMnemonic         Returns string of mnemonic only
;   DisGetNextAddress     Returns address of next instruction
; Private support function (not intended to be called from outside)
;   DisWrOperand          Process suppied operand
;   DisGetOpcode          Get instruction opcode
;   DisWrChar             Write a character to the buffer with filters
;   DisWrString           Write a string to the buffer with filters


; **********************************************************************
; **  Constants                                                       **
; **********************************************************************

kDisBrack:  .EQU 5              ;Bracket flag
kDisImmed:  .EQU 4              ;Immediate value flag
kDisWord:   .EQU 3              ;Immediate value is word (not byte) flag
kDisLength: .EQU 2              ;Substite two characters (not one) flag
kDisMask:   .EQU 0x03           ;Mask type 0=0x07,1=0x18,2=0x30,3=0x38
; Should create EQUates for all numeric values used below. It's the law!


; **********************************************************************
; **  Public functions                                                **
; **********************************************************************

            .CODE

; Disassembler: Write full disassembly to string buffer
;   On entry: HL = Start of instruction to be disassembled
;   On exit:  Address, opcodes and mnemonic in current string buffer
;             iDisIndex variable used
;             A = Length of instruction in bytes
;             HL = Start address of next instruction
;             BC DE IX IY I AF' BC' DE' HL' preserved
DisWrInstruction:
            PUSH BC
            PUSH DE
            LD   A,20           ;Select string for mnemonic...
            LD   DE,kStrBuffer+80 ;Length 20 at end of default string
            CALL StrInitialise  ;Initialise string for mnemonic
            CALL DisWrMnemonic  ;Disassemble to mnemonic string
            LD   C,A            ;Store length of instruction in bytes
;           XOR  A              ;CLear A to zero
            CALL StrInitDefault ;Select default string for opcodes
            LD   D,H            ;Get start of instruction..
            LD   E,L
            CALL StrWrAddress   ;Write address, colon and space
            LD   B,C            ;Get length of instruction
@Opcode:    LD   A,(HL)         ;Get instruction opcode
            CALL StrWrHexByte   ;Write as hex byte
            CALL StrWrSpace     ;Write space
            INC  HL             ;Point to next byte 
            DJNZ @Opcode        ;Loop until all hex bytes written
            LD   A,19           ;Column number
            CALL StrWrPadding   ;Pad with spaces to specified column
            LD   B,C            ;Get length of instruction
@Ascii:     LD   A,(DE)         ;Get instruction opcode
            CALL StrWrAsciiChar ;Write as ASCII character
            INC  DE             ;Point to next byte 
            DJNZ @Ascii         ;Loop until all characters written
            LD   A,25           ;Column number
            CALL StrWrPadding   ;Pad with spaces to specified column
@Mnemonic:  LD   DE,kStrBuffer+80
            CALL StrAppend      ;Append disassembly string
;           CALL StrWrNewLine   ;Write new line to string buffer
            LD   A,C            ;Get length of instruction in bytes
            POP  DE
            POP  BC
            RET


; Disassembler: Write mnemonic only to string buffer
;   On entry: HL = Start of instruction to be disassembled
;   On exit:  Mnemonic is written to current string buffer
;             iDisIndex variable used
;             A = Length of instruction in bytes
;             BC DE HL IX IY I AF' BC' DE' HL' preserved
DisWrMnemonic:
            PUSH BC
            PUSH DE
            PUSH HL
            PUSH IX
            PUSH IY
; Prepare to disassemble 
; HL = Address of current instruction
            PUSH HL             ;Copy start address of instruction
            POP  IY             ;  to IY 
            LD   IX,DisInst     ;Start of instruction table
            XOR  A
            LD   (iDisIndex),A  ;Clear index instruction opcode
            LD   E,A            ;Clear prefix for extended instructions
            LD   D,(HL)         ;Instruction's primary opcode 
            LD   B,A            ;Offset to instruction's primary opcode
; Check for index register instruction (IX or IY)
            LD   A,D            ;Could have been written LD A,(IY+0)
            CP   0xDD           ;IX instruction?
            JR   Z,@Index       ;Yes, so skip
            CP   0xFD           ;IY instruction?
            JR   NZ,@NotIndex   ;No, so skip
@Index:     LD   (iDisIndex),A  ;Store index instruction opcode
            INC  B              ;Increment offset to primary opcode
            LD   A,(IY+1)       ;Get next opcode byte
@NotIndex:
; Check for extended instruction
            CP   0xCB           ;Extended instruction?
            JR   Z,@Extend      ;Yes, so skip
            CP   0xED           ;Extended instruction?
            JR   NZ,@NotExtend  ;No, so skip
@Extend:    LD   E,A            ;Store prefix for extended instructions
            INC  B              ;Increment offset to primary opcode
            LD   A,(iDisIndex)  ;Get index instruction opcode
            OR   A              ;Is this an index instruction?
            LD   A,B            ;Prepare to read primary opcode
            JR   Z,@ExNoIndx    ;No, so skip
            INC  A              ;Yes, skip index displacement byte
@ExNoIndx:  CALL DisGetOpcode   ;Get primary opcode
@NotExtend: LD   D,A            ;Remember instruction's primary opcode
            LD   (iDisOpcode),A ;Store primary opcode
; Locate instruction table entry for current instruction (pointer to by HL)
; BASIC: (i And iMask(n)) = (iValue(n) And iMask(n)) ?
@Table:     LD   A,(IX+0)       ;Get opcode value from table
            AND  (IX+1)         ;AND with opcode mask from table
            LD   C,A            ;Store Value AND Mask
            LD   A,(IX+1)       ;Get opcode mask from table
            AND  D              ;AND with instruction being disassembled
            CP   C              ;Is this the correct table entry?
            JR   NZ,@NotFound   ;No, so this is not the correct table
; BASIC: ... AND (p = iPrecode(n)) ?
            XOR  A              ;Default precode for comparison = 0x00
            BIT  7,(IX+3)       ;Precode (index or extended)?
            JR   Z,@GotPrCode   ;No, so skip
            LD   A,0xCB         ;Default precode for comparison = 0xCB
            BIT  6,(IX+3)       ;Precode = 0xED?
            JR   Z,@GotPrCode   ;No, so skip
            LD   A,0xED         ;Yes, so precode for comparison = 0xED
@GotPrCode: CP   E              ;Compare table precode with instruction
            JR   Z,@Found       ;Yes, so this is the correct table
@NotFound:  PUSH BC             ;Preserve BC
            LD   BC,5           ;No, so try next table entry
            ADD  IX,BC          ;Point to next table entry
            POP  BC             ;Restore BC
            JR   @Table
; We now have the correct instruction table entry (pointer to by IX)
; BASIC: (p = iPrecode(n)) And (i And iMask(n)) = (iValue(n) And iMask(n))
@Found:     LD   A,(IX+2)       ;Get operation string number
            LD   (iDisOpStr),A  ;Store operation string number
            CALL DisWrString    ;Write operation string
            CALL StrWrSpace
; BASIC: Operand sString(iOperand1(n)), t
            LD   A,(IX+3)       ;Get operand #1 string number
            LD   (iDisOp1Str),A ;Store opcode #1 string number
            LD   C,D            ;Get primary opcode value
            CALL DisWrOperand
; BASIC: Operand sString(iOperand2(n)), t
            LD   A,(IX+4)       ;Get operand #2 string number
            DEC  A              ;Is is 1? (null string)
            JR   Z,@NoOp2       ;Yes, so skip this operand
            LD   A,','          ;Get comma character
            CALL StrWrChar      ;Write comma to string
            LD   A,(IX+4)       ;Get operand #2 string number
            LD   C,D            ;Get primary opcode value
            CALL DisWrOperand
@NoOp2:
; If relative jump show absolute address in brackets
            LD   A,(iDisOpStr)  ;Get operation string number
            CP   kDisJR         ;JR instruction?
            JR   Z,@Rel         ;Yes, so skip
            CP   kDisDJNZ       ;DJNZ instruction?
            JR   NZ,@NotRel     ;No so skip
@Rel:       LD   DE,szDisTo     ;String = "  (to "
            CALL StrAppendZ     ;Append zero terminated string
            PUSH IY             ;Push address of instruction
            POP  HL             ;POP address of instruction
            INC  HL             ;Increment to
            INC  HL             ;  end of the JR/DJNZ instruction
            LD   A,(iDisImmed)  ;Get immediate value from instruction
            LD   E,A            ;Get displacement lo (signed byte)
            LD   D,0            ;Default to hi byte = zero
            BIT  7,A            ;Displacement negative?
            JR   Z,@JRadd       ;No, so skip
            DEC  D              ;Yes, so set hi byte to 0xFF
@JRadd:     ADD  HL,DE          ;Add signed 16-bit displacement
            LD   D,H            ;Get destination address hi byte
            LD   E,L            ;Get destination address lo byte
            CALL WrHexPrefix    ;Write hex prefix to string
            CALL StrWrHexWord   ;Write hex word to string
            LD   A,')'          ;Get close bracket character
            CALL StrWrChar      ;Write close bracket to string
@NotRel:
; Finish building mnemonic string
            LD   A,B            ;Get offset into instruction
            INC  A              ;Increment to give instruction length
            POP  IY
            POP  IX
            POP  HL
            POP  DE
            POP  BC
            RET


; Disassembler: Get address of next instruction
;   On entry: HL = Next address ignoring flow control instructions
;             Next instruction
;   On exit:  HL = Next address after consider flow instructions
;             AF BC DE IX IY I AF' BC' DE' HL' preserved
; Just prior to this function the next instruction must have been
; disassembled so instruction details are available in iDisXXXX
; workspace. Also breakpoint register values must be in workspace.
DisGetNextAddress:
            PUSH AF
            PUSH BC
            PUSH DE
; Determine if last instruction may have changed program flow
            LD   A,(iDisOpStr)  ;Get operation string number
            CP   kDisFlowF      ;Compare with first flow control instr
            JR   C,@Done2       ;Not a flow instruction so we're done
            CP   kDisFlowL+1    ;Compare with first flow control instr
            JR   NC,@Done2      ;Not a flow instruction so we're done
; The current instruction is a flow controlling instruction eg. CALL
; Consider if the instruction is conditional or not by looking at
; operand 1 string number to see if it is the operand substitution
; string "c" or "cc" (for conditions NZ,Z,NC,C,PO,PE,P,M)
            LD   A,(iDisOp1Str) ;Get operand 1 string number
            LD   B,kDisMskC     ;Prepare condition 'c' mask
            CP   kDisSubC       ;Is operand 'c'? eg. 'Z' in 'JR Z,addr'
            JR   Z,@Condition   ;Yes, so go handle condition
            LD   B,kDisMskCC    ;Prepare condition 'cc' mask
            CP   kDisSubCC      ;Is operand 'cc'? eg. 'PE' in 'JP PE,addr'
            JR   NZ,@NoCond     ;No, so skip condition evaluation
; Evaluate condition. B is the conditions bit mask
@Condition: LD   A,(iDisOpcode) ;Get instruction's primary opcode
            AND  B              ;Mask to give condition bits, Cy=0
            RRA                 ;Shift condition bits to bits 0 to 1
            RRA                 ;  to give offset in table
            RRA                 ;  for each coded condition
            RRA                 ;  plus flag state in Carry
            LD   B,A            ;Set up table loop counter
; Condition table contains one byte for each flag condition:
; 0=NZ/Z, 1=NC/C,2=PO/PE, 3=P/M and C set for Z, C, PE and M
; The values in the table are bit masks for the flags register
; which is ORed with Flags register to test if flag is set, and 
; then exclusively ORed with flags register to test if not set.
            PUSH HL
            LD   HL,DisConTab-1 ;Point to start of condition table -1
            INC  B              ;Increment loop counter
@IncPtr:    INC  HL             ;Inc pointer into condition table
            DJNZ @IncPtr        ;Go inc again until we are there
            LD   A,(iAF)        ;Get flags register value
            JR   C,@ConTest     ;Looking for flag low?
            XOR  (HL)           ;Yes, so invert required flag bit
@ConTest:   AND   (HL)          ;Mask required flag bit (clears Cy)
            POP  HL
            JR   Z,@Done        ;We're done if condition not met
; Determine address after executing the flow controlling instruction
; when the condition is met (if there is a condition)
@NoCond:    LD   A,(iDisOpStr)  ;Get operation string number
            CP   kDisCALL       ;Instruction = "CALL"
            JR   Z,@CALL
            CP   kDisDJNZ       ;Instruction = "DJNZ"
            JR   Z,@DJNZ
            CP   kDisJP         ;Instruction = "JP"
            JR   Z,@JP
            CP   kDisJR         ;Instruction = "JR"
            JR   Z,@JR
            CP   kDisRST        ;Instruction = "RST"
            JR   Z,@RST
; Instruction: RET or RET cc or RETI or RETN
@RET:       LD   HL,(iSP)       ;Get stack pointer at breakpoint
            JR   @JP2           ;Go to addess pointed to by HL
; Instruction: DJNZ n
@DJNZ:      LD   A,(iBC+1)      ;Get register B value
            DEC   A             ;Will B reach zero?
            JR   Z,@Done        ;Yes, so we're done
;           JR   @JR            ;No, so go treat as JR instruction
; Instruction: JR n or JR c,n
@JR:        LD   A,(iDisImmed)  ;Get immediate value from instruction
            LD   E,A            ;Get displacement lo (signed byte)
            LD   D,0            ;Default to hi byte = zero
            BIT  7,A            ;Displacement negative?
            JR   Z,@JRadd       ;No, so skip
            DEC  D              ;Yes, so set hi byte to 0xFF
@JRadd:     ADD  HL,DE          ;Add signed 16-bit displacement
@Done2:     JR   @Done
; Instruction: JP nn or JP cc,nn or JP HL or JP IX or JP IY
@JP:        LD   A,(iDisOp1Str) ;Get operand 1 string number
            CP   kDisSubCC      ;Is operand 'cc'? eg. 'PE' in 'JP PE,addr'
            JR   Z,@GOTOnn      ;Yes, so goto address nn
            CP   kDisSubNN      ;Instruction = JP nn ?
            JR   Z,@GOTOnn      ;Yes, so goto address nn
; Instruction: JP HL or JP IX or JP IY
            LD   HL,iHL         ;Point to register storage for HL
            LD   A,(iDisIndex)  ;Index register instruction?
            OR   A              ;No, so go JP 
            JR   Z,@JP2
            INC  HL             ;Point to register storage for IX
            INC  HL
            CP   0xDD           ;Instruction = JP IX
            JR   Z,@JP2
            INC  HL             ;Point to register storage for IX
            INC  HL
; Go to the address pointed to by HL
@JP2:       LD   A,(HL)         ;Get lo byte of new address
            INC  HL             ;Point to hi byte
            LD   H,(HL)         ;Get hi byte of new address
            LD   L,A            ;Get lo byte of newreturn address
            JR   @Done
; Instruction: RST n
@RST:       LD   A,(iDisOpcode) ;Get primary opcode
            AND  A,kDisMskRST   ;Mask off unwanted bits
            LD   L,A            ;Store as lo byte of new address
            LD   H,0            ;Clear hi byte of new address
            JR   @Done
; Instruction: CALL nn or CALL cc,nn
@CALL:      ;JR  @JP            ;Treat as JP instruction
; Instruction: CALL nn or CALL cc,nn or JP nn pr JP cc,nn
@GOTOnn:    LD   HL,(iDisImmed) ;Get immediate value from instruction
;           JR   @Done
@Done:      POP  DE
            POP  BC
            POP  AF
            RET


; **********************************************************************
; **  Private functions                                               **
; **********************************************************************


; Disassembler: Write operand to buffer
;   On entry: A = Operand string number
;             B = Offset to opcode from start of instruction
;             C = Primary op-code
;             IY = Start address of instruction
;   On exit:  A = Unspecified
;             B = Updated offset to opcode from start of instruction
;             C = Not specified
;             DE HL IX IY I AF' BC' DE' HL' preserved
DisWrOperand:
            AND  kDisOpMask     ;Mask off flag bits
            CP   kDisSubsL+1    ;Substitution operand string?
            JP   NC,DisWrString ;No, so just write string
@DisSubStr: PUSH DE
            PUSH HL
; Calculate operand table location for this operand and get details
            LD   HL,DisOperandTable-2
            ADD  A,A            ;Two bytes per entry
            ADD  A,L            ;Add to start of table
            LD   L,A            ;Store updated lo byte
            JR   NC,@NoOverFlo  ;Skip if no overflow
            INC  H              ;Overflow so increment hi byte
@NoOverFlo: LD   E,(HL)         ;Get substitution string number
            INC  HL             ;Point to BIILMM bits
            LD   D,(HL)         ;Get BIILMM function bits
            PUSH DE             ;So we can use E for scratch reg
; Process this operand as detailed in DE, left bracket?
            BIT  kDisBrack,D    ;Bracket flagged?
            JR   Z,@NoBracL     ;No, so skip
            LD   A,'('          ;Get left bracket character
            CALL StrWrChar      ;Print left bracket
@NoBracL:   
; Process this operand as detailed in DE, immediate value?
            BIT  kDisImmed,D    ;Immediate value flagged?
            JR   Z,@NoImmedia   ;No, so skip
            CALL WrHexPrefix    ;Print "0x" (or whatever we use)
            INC  B              ;Increment offset to lo byte
            LD   A,B            ;Offset to instruction byte
            CALL DisGetOpcode   ;Get lo byte of immediate value
            LD   (iDisImmed),A  ;Store lo byte of immediate value
            LD   E,A            ;Store lo byte of immediate value
            BIT  kDisWord,D     ;Immediate value is a word?
            JR   Z,@ImmedLo     ;No, so skip
            INC  B              ;Increment offset to hi byte
            LD   A,B            ;Offset to instruction byte
            CALL DisGetOpcode   ;Get hi byte of immediate value
            LD   (iDisImmed+1),A  ;Store hi byte of immediate value
            CALL StrWrHexByte   ;Print hi byte of immediate value
@ImmedLo:   LD   A,E            ;Restore lo byte of immediate value
            CALL StrWrHexByte   ;Print lo byte of immediate value
@NoImmedia:
; Process this operand as detailed in DE, right bracket?
            BIT  kDisBrack,D    ;Bracket flagged?
            JR   Z,@NoBracR     ;No, so skip
            LD   A,')'          ;Get right bracket character
            CALL StrWrChar      ;Print right bracket
@NoBracR:   
; Process this operand as detailed in DE, substitution string?
            POP  DE             ;Restore details
            LD   A,E            ;Get substitution string number
            OR   A              ;String specified?
            JR   Z,@SubEnd      ;No, so skip
            LD   A,D            ;Get BIILMM function bits
            AND  A,kDisMask     ;Separate mask type bits
            LD   HL,DisMaskTable  ;Point to table of mask bits
            ADD  A,L            ;Add to start of table
            LD   L,A            ;Store updated lo byte
            JR   NC,@NoOFlow    ;Skip if no overflow
            INC  H              ;Overflow so increment hi byte
@NoOFlow:   LD   A,(HL)         ;Get bit mask
            AND  A,C            ;Mask primary opcode
            LD   C,A            ;Store masked primary opcode
            LD   A,(HL)         ;Get bit mask
; Now shift primary opcode (masked) to right the number of
; times it takes to shift mask byte right before bit 1 is set
@SubsShift: SRL  A              ;Shift mask right
            JR   C,@DoneShift   ;Bit 1 was set so we're done
            SRL  C              ;Shift primary opcode (masked) right
            JR   @SubsShift     ;Go repeat..
@DoneShift: BIT  kDisLength,D   ;Length bit flagged?
            JR   Z,@Single      ;No, so skip
            SLA  C              ;Double value for two bytes
; C is now the offset into the substitute string
@Single:    LD   A,E            ;Substitute string number
            LD   HL,DisString   ;Start of string list
            CALL FindStringInList ;Get start of string (=HL)
            LD   A,C            ;Offset into string
            ADD  A,L            ;Add to start of string
            LD   L,A            ;Store updated lo byte
            JR   NC,@NoOver     ;Skip if no overflow
            INC  H              ;Overflow so increment hi byte
@NoOver:    LD   A,(HL)         ;Get substitute character
            CP   '*'            ;Code for 2 byte HL/IX/IY string
            JR   NZ,@NotStar    ;No, so skip
            LD   A,24           ;String = "HL"
            CALL DisWrString    ;Print string with substitutions
            JR   @SubEnd
@NotStar:   CALL DisWrChar      ;Print character with filters
            BIT  kDisLength,D   ;Length bit flagged?
            JR   Z,@SubEnd      ;No, so skip
            INC  HL             ;Point to second substitute character
            LD   A,(HL)         ;Get substitute character
            CP   '.'            ;Do not print '.' character
            CALL NZ,DisWrChar   ;Print character with filters
@SubEnd:    POP  HL
            POP  DE
            RET


; Disassembler: Get instruction opcode
;   On entry: A = Offset from start of instruction
;             IY = Start of instruction
;   On exit:  A = Opcode
;             BC DE HL IX IY I AF' BC' DE' HL' preserved
DisGetOpcode:
            PUSH BC
            PUSH IY
            LD   C,A            ;Offset from start of instruction
            LD   B,0            ;Clear hi byte ready for addition
            ADD  IY,BC          ;Calculate location of opcode
            LD   A,(IY+0)       ;Get opcode from memory
            POP  IY
            POP  BC
            RET


; Disassembler: Write character to string buffer
;   On entry: A = Character to write
;   On exit:  AF BC DE HL IX IY I AF' BC' DE' HL' preserved
; This version of write character removes bit 7 (the new string flag)
; and replaces "-" with "(HL)"
DisWrChar:
            PUSH AF
            AND  A,0x7F         ;Mask off bit 7 (string start bit)
            CP   '-'            ;Code for "(HL)" ?
            JR   Z,@SubHL       ;Yes, so go write "(HL)" instead
            CALL StrWrChar      ;Print character
            JR   @Done
@SubHL:     LD   A,21           ;String number for "(HL)"
            CALL DisWrString    ;Write "(HL)" instead of "-"
@Done:      POP  AF
            RET                 ;JP instead to save byte


; Write disassembler string
;   On entry: A = Disassembler data string number
;             B = Offset to current opcode from start of instruction
;             IY = Start address for current instruction
;             (iDisIndex) = Index instruction opcode or zero
;   On exit:  AF C DE HL IX IY I AF' BC' DE' HL' preserved
;             B is incremented if (IX/IY+d) is substituted
; This version of write string removes bit 7 (the new string flag)
; If iDisTmp1 (the current index instruction opcode) is 0xDD or 0xFD, 
; is not zero then strings are replaced: 
;   HL is replaced with IX or IY
;   (HL) is replaced with (IX + d) or (IY + d) except for JP instruction
;   where is is just replaced by (IX) or (IY)
DisWrString:
            PUSH AF
            PUSH HL
            LD   L,A            ;Store string number
            CP   kDisBracHL     ;String = (HL) ?
            JR   Z,@Subs        ;Yes, so go do substitution
            CP   kDisHL         ;String = HL ?
            JR   NZ,@GotString  ;No, so just write the string
; Substitute IX/IY in HL string or (IX/IY+d) in (HL) string
@Subs:      LD   A,(iDisIndex)  ;Get index instruction opcode
            OR   A              ;Index instruction?
            JR   Z,@GotString   ;No, so skip substitutions
            INC  L              ;Increment to IX string number
            CP   0xDD           ;IX instruction?
            JR   Z,@GotString   ;Yes, so go write it
            INC  L              ;Increment to IY string
@GotString: LD   A,L            ;Get string number
            LD   HL,DisString   ;Start of string list
            CALL FindStringInList ;Find start of string A
; HL now points to disassembler string
@Char:      LD   A,(HL)         ;Get character from string
            AND  0x7F           ;Mask off string start bit
            CP   '+'            ;Is it a '+' sign (displacement) ?
            JR   Z,@Plus        ;No, so skip to next character
            CALL StrWrChar      ;Write character
            JR   @Next          ;No, so skip to next character
; Encountered a plus sign so expecting to show a displacement
@Plus:      LD   A,(iDisOpStr)  ;Get instruction string
            CP   kDisJP         ;JP instruction?
            JR   NZ,@Displace   ;No, so go show displacement
            LD   A,')'          ;Yes, so just terminate with ')'
            CALL StrWrChar      ;Write close bracket character
            JR   @End
; Show displacement in (IX+...) and (IY+...) instructions
@Displace:  LD   A,'+'
            CALL StrWrChar      ;Write plus character
            CALL WrHexPrefix
            LD   A,(IY+2)       ;Get index instruction displacement
            CALL StrWrHexByte   ;Write displacement in hex
            LD   A,')'
            CALL StrWrChar      ;Write close bracket character
            INC  B              ;Increment opcode offset
; Consider next character in disassembler string
@Next:      INC  HL             ;Point to next character
            BIT  7,(HL)         ;Start of new string?
            JR   Z,@Char        ;No, so go get next character
@End:       POP  HL
            POP  AF
            RET


; **********************************************************************
; **  Constant data                                                   **
; **********************************************************************


; Strings
szDisTo:    .DB  "  (to ",kNull


; Operand table:
;   Index into table is the operand string number 1 to 13)
;   Contents: Substitution string number, function bits BIILMM
;
; Op  String  Offset  Bracket  Immediate  Substitue     subsLen  subsMask  ->  BIILMM
;  1  =""     +0      No       No   (00)  No                n/a  n/a           000000
;  2  ="n"    +1      No       Byte (10)  No                n/a  n/a           010000
;  3  ="(n)"  +1      Yes      Byte (10)  No                n/a  n/a           110000
;  4  ="nn"   +2      No       Word (11)  No                n/a  n/a           011000
;  5  ="(nn)" +2      Yes      Word (11)  No                n/a  n/a           111000
;  6  ="r"    +0      No       No   (00)  "BCDEHL-A"          1  0x38 (11)     000011
;  7  ="r2"   +0      No       No   (00)  "BCDEHL-A"          1  0x07 (00)     000000
;  8  ="dd"   +0      No       No   (00)  "BCDEHLSP"          2  0x30 (10)     000110
;  9  ="qq"   +0      No       No   (00)  "BCDEHLAF"          2  0x30 (10)     000110
; 10  ="c"    +0      No       No   (00)  "NZZ NCC "          2  0x18 (01)     000101
; 11  ="cc"   +0      No       No   (00)  "NZZ NCC POPEP M "  2  0x38 (11)     000111
; 12  ="t"    +0      No       No   (00)  "0008101820283038"  2  0x38 (11)     000111
; 13  ="b"    +0      No       No   (00)  "01234567"          1  0x38 (11)     000011
; Each table entry is coded with the string number plus a byte containing BIILMM bits
; Length bit is hi for strings with two character substitutions
DisOperandTable:
            .DB  0x00,0x00      ;0b000000 ;Operand  1 = ""
            .DB  0x00,0x10      ;0b010000 ;Operand  2 = "n"
            .DB  0x00,0x30      ;0b110000 ;Operand  3 = "(n)"
            .DB  0x00,0x18      ;0b011000 ;Operand  4 = "nn"
            .DB  0x00,0x38      ;0b111000 ;Operand  5 = "(nn)"
            .DB  0x0E,0x03      ;0b000011 ;Operand  6 = "r"
            .DB  0x0E,0x00      ;0b000000 ;Operand  7 = "r2"
            .DB  0x0F,0x06      ;0b000110 ;Operand  8 = "dd"
            .DB  0x10,0x06      ;0b000110 ;Operand  9 = "qq"
            .DB  0x11,0x05      ;0b000101 ;Operand 10 = "c"
            .DB  0x12,0x07      ;0b000111 ;Operand 11 = "cc"
            .DB  0x13,0x07      ;0b000111 ;Operand 12 = "t"
            .DB  0x14,0x03      ;0b000011 ;Operand 13 = "b"

; Mask table
; These are the masks used to separate token values such as register "BCDEHL-A"
; The index into the table is coded in the two mask bits from the above table.
DisMaskTable:
            .DB  0x07           ;Mask type 0
            .DB  0x18           ;Mask type 1
            .DB  0x30           ;Mask type 2
            .DB  0x38           ;Mask type 3


; Condition mask table
; The condition mask table contains one byte for each condition flag:
; NZ,Z,NC,C,PO,PE,P,M where offset into table is 0 for Z/NZ, 1 for C/NC, etc
; The value of each table entry is a bit mask, which when exclusively for the flags register
            ;SZ-H-PNC   Condition, Flag, Description
DisConTab:  .DB  0x40           ;xZxxxxxx   NZ,        Z=0,  Not Zero
            .DB  0x01           ;xxxxxxxC   NC,        C=0,  No Carry
            .DB  0x04           ;xxxxxxxC   PO,        P=0,  Parity Odd
            .DB  0x80           ;xxxxxxxC   PO,        S=0,  Positive


; Include the data tables  DisString: and DisInst:
;
; Disassembler string table: (DisString)
; This contains many string which are not null terminated and have no length 
; value. Instead they are tightly packed with the start of each string 
; indicated by the first character having bit 7 set.
;
; Instruction table: (DisInst)
; The instruction table definition of the processor's instruction set.
; Each instruction is described by 5 bytes:
;    Byte 0:  Opcode value
;    Byte 1:  Opcode mask
;    Byte 2:  Operation string number
;    Byte 3:  Operand #1 string number, plus bits 6-7 define precode
;    Byte 4:  Operand #2 string number
; The precode values code in bits 6-7 are:
;    00xx xxxx = No precode
;    10xx xxxx = Precode 0xCB
;    11xx xxxx = Precode 0xED
; Precodes are used by the processor's extended instructions
#INCLUDE    Monitor\DisData.asm


; **********************************************************************
; **  Private workspace (in RAM)                                      **
; **********************************************************************

            .DATA

iDisIndex:  .DB  0x00           ;Index instruction opcode
iDisOpStr:  .DB  0x00           ;Operation string number
iDisOp1Str: .DB  0x00           ;Operand 1 string number
iDisOpcode: .DB  0x00           ;Primary instruction opcode
iDisImmed:  .DW  0x0000         ;Immediate value


; Disassembler: How it works...
; Solution is to use data table to define functions for each operand (see below)
; Decoding table: where the table entry is determined by the operand string number
; String numbers 0 to 12:
;   If bracket flagged print "("
;   If immediate byte flagged print hex byte at PC+Offset+1, Offset += 1
;   If immediate word flagged print word byte at PC+Offset+1 and PC+Offset+2, Offset += 2
;   If bracket flagged print ")"
;   If substitution string specified: (non-zero value)
;     n = opcode and SubsMask
;     n = n >> x, where x is the number of right shifts of the mask til bit 0 is a 1
;     If subsLen is 2 then n = n << 1
;     c =  character at (start of Substitution String + n + 0)
;     if = "-" then print "(HL)" else print character c
;     If SubsLen = 2 then
;       print character at (start of Substitution String + n + 1)
;     Endif
;   End if


; Single stepping
; Instructions which can change flow of code (ie. alter PC)
;   DJNZ d          10 nn      0001 0000
;   JR   d          18 nn      0001 1000
;   JR   c,  d      xx nn      001c c000
;   JP   nn         C3 nn nn   1100 0011
;   JP   cc, nn     xx nn nn   11cc c010
;   JP   HL         E9         1110 1001
;   JP   IX         DD E9      1110 1001
;   JP   IY         FD E9      1110 1001
;   CALL nn         CD nn nn   1100 1101
;   CALL cc, nn     xx nn nn   11cc c100
;   RET             C9         1100 1001
;   RET  cc         xx         11cc c000
;   RETI            ED 4D      0100 1101
;   RETN            ED 45      0100 0101
;   RST  aa         xx         11tt t111
; Also an interrupt or reset signal changes PC
; The above instructions are trapped after disassembly and the next instruction
; determined. The breakpoint is then placed here to allow single stepping.


; **********************************************************************
; **  End of Disassembler support module                              **
; **********************************************************************





