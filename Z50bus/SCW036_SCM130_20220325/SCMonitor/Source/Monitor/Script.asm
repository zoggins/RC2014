; **********************************************************************
; **  Script language                           by Stephen C Cousins  **
; **********************************************************************

; Currently just a proof of concept

; The script language is a tokenised interpreter.
;   S = Small
;   C = Computer
;   R = Reduced        or Rapid
;   I = Instruction 
;   P = Program        or Programming
;   T = Text
;
; Line numbers are used to identify locations for editing, nothing more.
; Lines are automatically renumbered each time the code is listed.
; Flow control uses labels rather than line numbers.
;
; The program is stored in lines with this format:
;   Byte   Line length (including this byte), Zero = End of program
;   Word   Line number (displayed in hex)
;   Byte   Line type token: Comment, Label, Statement
;   Bytes  Comment/Label/Statement
;
; Comment lines contain the Comment token followed by a zero
; terminated text string.
;
; Label lines contain the Label token followed by a zero
; terminated text string.
;
; Statement lines contain the statement token followed by a tokenised
; statement.
;
; The script language supports 26 global variables named "A" to "Z",
; each holding an unsigned 16-bit value.
;
; String variables and arrays are not supported. Although PEEK and
; POKE could enable some manipulation of such data.
;
; Script commands are RUN, SCRIPT?? (=LIST), NEW, OLD
;
; Script keywords are:
;   IN, OUT, PEEK, POKE
;   SYS, CALL
;   IF .. THEN .. ELSE .. ENDIF
;   FOR .. NEXT .. EXIT FOR
;   LET
;   GOTO, GOSUB
;   PRINT, INPUT
;   END
;   DELAY
;
; Script operators are:
;   +, -, *, /
;   =, >, <, >=, <=, !=
;   AND, OR
;
; Assignments and comparisons are limited to the most simple of
; statements, such as:
;   LET A = B + 1
;   IF A = 4 THEN
; More complex versions, such as use of parentheses, are not supported
; such as:
;   LET A = (B + 1) * (C + 2)
;   IF  (A + 1) = (B + 2) THEN


; **********************************************************************
; **  Public functions                                                **
; **********************************************************************

            .CODE

; Initialise script module
;   On entry: No parameters required
;   On exit:  HL = iScrLine = Address of start of program
;             BC DE IX IY I AF' BC' DE' HL' preserved
ScrInitialise:
            LD   HL,0x4000
            LD   (iScrStart),HL
            JP   ScrNew


; Script: Command: New
;   On entry: No parameters required
;   On exit:  IX IY I AF' BC' DE' HL' preserved
ScrNew:     LD  HL,(iScrStart)  ;Point to first line of program
            LD  A,(HL)          ;Get length of first line
            OR  A               ;Length > zero? (program exists)
            RET Z               ;No, so abort 
            LD  (iScrOldLen),A  ;Yes, so store old length of line
            XOR A               ;  and clear current program
            LD  (HL),A
            RET


; Script: Command: Old
;   On entry: No parameters required
;   On exit:  IX IY I AF' BC' DE' HL' preserved
ScrOld:     LD  HL,(iScrStart)  ;Point to first line of program
            LD  A,(HL)          ;Get length of first line
            OR  A               ;Length = zero? (no program)
            RET NZ              ;No, abort and don't overwrite
            LD  A,(iScrOldLen)  ;Yes, so get old length of line
            LD  (HL),A          ;  and restore program
            RET


; Script: Command: Script (list)
;   On entry: No parameters required
;   On exit:  IX IY I AF' BC' DE' HL' preserved
ScrList:    CALL ScrSetStart
@Line:      LD   A,(HL)
            OR   A
            RET  Z
; Output current line
;           PUSH HL
            LD   B,A            ;Store line length
            CALL StrInitDefault
            INC  HL
            LD   E,(HL)         ;Get lo byte of line number
            INC  HL
            LD   D,(HL)         ;Get hi byte of line number
            CALL StrWrHexWord
            CALL StrWrSpace
            INC  HL
            LD   A,(HL)
            BIT  7,A
            JR   Z,@Text
; Output token
            RES  7,A
            CALL ScrFindString
            LD   A,(HL)
            AND  0x7F
@Token:     CALL StrWrChar
            INC  HL
            LD   A,(HL)
            BIT  7,A
            JR   NZ,@EndOfLine
            JR   @Token
; Not a token
@Text:      CP   kSemicolon
            JR   Z,@Comment
            CP   kColon
            JR   NZ,@EndOfLine
; Output comment or label
@Comment:   CALL StrWrChar
            INC  HL
            LD   A,(HL)
            OR   A
            JR   NZ,@Comment


;           POP  HL

@EndOfLine: CALL StrWrNewLine
            CALL StrPrint
            CALL ScrNextLine
            JR   @Line


; Script: Edit line
;   On entry: DE = Start of line in input buffer (after line number)
;             HL = Line number
;   On exit:  Script program memory updated
;             IX IY I AF' BC' DE' HL' preserved
ScrEdit:    LD   B,H
            LD   C,L
            CALL ScrSetStart
            CALL CLISkipDelimiter
            LD   A,(DE)
            OR   A              ;Blank line entered?
            JR   Z,@Delete      ;Yes, so go delete line

; Find end of program
@Next:      LD   A,(HL)
            OR   A
            JR   Z,@Append
            CALL ScrNextLine
            JR   @Next
; Append line
@Append:    PUSH DE
            PUSH HL
            CALL ScrTokenise
            POP  HL
            POP  DE
            PUSH HL
;           LD   (HL),3
            INC  HL
            LD   (HL),C
            INC  HL
            LD   (HL),B
            INC  HL
            LD   B,3            ;Initial line length
@Copy:      LD   A,(DE)
            LD   (HL),A
            INC  DE
            INC  HL
            INC  B
            OR   A
            JR   NZ,@Copy
; Line written to program
@Done:      LD   (HL),A         ;Terminate program
            POP  HL
            LD   (HL),B         ;Write length to line
            RET
; Delete line
@Delete:    CALL ScrFindLine
            RET


; **********************************************************************
; **  Private functions                                               **
; **********************************************************************


; Set current line to start of program
;   On entry: No parameters required
;   On exit:  HL = iScrLine = Address of start of first line
;             BC DE IX IY I AF' BC' DE' HL' preserved
ScrSetStart:
            LD   HL,(iScrStart)
            LD   (iScrLine),HL
            RET


; Calculate start address of next line
;   On entry: No parameters required
;   On exit:  HL = iScrLine = Address of start of line
;             BC DE IX IY I AF' BC' DE' HL' preserved
ScrNextLine:
            LD   HL,(iScrLine)  ;Get start of current line
            LD   A,(HL)         ;Get length of line
            ADD  L              ;Add to start of line...
            LD   L,A
            JR   NC,@Done
            INC  H
@Done:      LD   (iScrLine),HL  ;Store start of 'next' line
            RET


; Find address of line BC
;   On entry: BC = Line number to be deleted
;             DE = Start of line in input buffer (after line number)
;             HL = Start of program
;   On exit:  NZ flagged if found
;             HL = iScrLine = Address of start of line
ScrFindLine:
@Next:      LD   A,(HL)         ;Get length of line
            OR   A              ;End of program?
            RET  Z              ;Yes, so return as line not found
            INC  HL             ;Point to line number lo byte
            LD   A,(HL)         ;Get line number lo byte
            CP   C              ;Compare with lo byte of target line
            JR   NZ,@Find       ;Not the same so go try next line
            INC  HL             ;Point to line number hi byte
            LD   A,(HL)         ;Get line number hi byte
            CP   B              ;Compare with hi byte of target line
            JR   Z,@Found       ;Same so we've found the line
@Find:      CALL ScrNextLine    ;Find start of next line
            JR   @Next          ;Loop until done
@Found:     LD   HL,(iScrLine)  ;Get start address of this line
            LD   A,0xFF         ;Found so return NZ
            OR   A
            RET


; Tokenise line
;   On entry: DE = Start of line in input buffer (after line number)
ScrTokenise:
            LD   HL,(iScrStart) ;Point to length of first line
            LD   A,(HL)         ;Get length of first line
            LD   (iScrOldLen),A ;Store, so flagging program exists
            CALL CLISkipDelimiter
            LD   H,D
            LD   L,E
            LD   A,(DE)
            CP   kSemicolon     ;Comment?
            RET  Z              ;Yes, so we're done
            CP   kColon         ;Label?
            RET  Z              ;Yes, so we're done
            PUSH DE
            PUSH HL
            LD   HL,ScrNameList
            CALL SearchStringListNA
            POP  HL
            POP  DE
            JR   Z,@Error
            SET  7,A            ;Turn string number into token
            LD   (HL),A         ;Store token in program memory
            INC  HL
            LD   (HL),0         ;Mark end of tokenised string
            RET
@Error:     RET



; TODO This is virtually identical to DisFindString so share code
; Script: Find start of string A
;   On entry: A = String number
;   On exit:  HL = Start of string
;             AF BC DE IX IY I AF' BC' DE' HL' preserved
; Find string A in bit 7 delimited disassembler string list
ScrFindString:
            PUSH AF
            PUSH BC
            LD   HL,ScrNameList-1 ;Start of string table - 1
            LD   B,A            ;Get string number
@Next:      INC  HL             ;Point to next character
            BIT  7,(HL)         ;Start of new string?
            JR   Z,@Next        ;No, so go get next character
            DJNZ @Next          ;Loop back if not the right string
            POP  BC
            POP  AF
            RET


; **********************************************************************
; **  Constant data                                                   **
; **********************************************************************

; Key word names list
ScrNameList:
            .DB  128+'T',"1"
            .DB  128+'P',"EEK"  ;PEEK
            .DB  128+'T',"2"
            .DB  128            ;List terminator


; **********************************************************************
; **  Private workspace (in RAM)                                      **
; **********************************************************************

            .DATA

iScrStart:  .DW  0              ;Start of script program
iScrLine:   .DW  0              ;Start of current line
iScrOldLen: .DB  0              ;Length to restore program with NEW


; **********************************************************************
; **  End of Script module                                            **
; **********************************************************************


