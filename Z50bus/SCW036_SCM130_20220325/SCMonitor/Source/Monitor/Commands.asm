; **********************************************************************
; **  Command Line Interpreter                  by Stephen C Cousins  **
; **********************************************************************

; This module provides the monitor's Command Line Interpreter (CLI)
; including the commands themselves.
;
; Public functions provided:
;   CLILoop               Command Line Interpreter main loop
;   CLIExecute            Offer string to command line interpreter
;   CLISkipNonDeli        Skip non-deliminaters in input line
;   CLISkipDelim          Skip deliminaters in input line
;   CLIGetHexParam        Get hex word/byte from input line


; **********************************************************************
; **  Constants                                                       **
; **********************************************************************

; Prompt character
kPrompt:    .EQU '*'            ;Prompt character

; Error reporting flags
kReportBad: .EQU 1              ;Report bad hex parameter
kReportMis: .EQU 2              ;Report missing parameter
kReportAny: .EQU 3              ;Report any error


; **********************************************************************
; **  Public functions                                                **
; **********************************************************************

            .CODE

; Command Line Interpreter: Main loop
CLILoop:    CALL StrInitDefault ;Initialise default string buffer
            LD   A,kPrompt      ;Get prompt character
            CALL OutputChar     ;Output a prompt character
#IFDEF      IncludeMiniTerm
            XOR  A              ;Flag command as
            LD   (iMiniTerm),A  ;  not from mini terminal
#ENDIF
#IFDEF      IncludeHexLoader
; Trap colon character and input intel hex record(s)
@Preview:   CALL InputPreview   ;Preview first character in line
            CP   kColon         ;Start of Intel Hex record/line?
            JR   NZ,@NotHex     ;No, so skip..
            CALL HexLoad        ;Load Intel Hex record
            CALL InputInsert    ;Insert returned character as waiting
            JR   @Preview       ;Go preview start of next line..
@NotHex:
#IFDEF      IncludeMiniTerm
; WARNING this should be outside IncludeHexLoader
            CP   '-'
            JR   NZ,@NotMini
            LD   (iMiniTerm),A
            XOR   A
            CALL InputInsert    ;Insert returned character as waiting
            JR   @Preview       ;Go preview start of next line..
@NotMini:
#ENDIF
#ENDIF
; Input line and execute it
            CALL InputLine      ;Input a text line
            CALL CLIExecute     ;Execute command line
            JR   CLILoop        ;Go get next line


; Offer string to command line interpreter
;  On entry:  DE = Start of command string terminated in Null
;  On exit:   If command handled (blank line or executed command):
;               A = 0x00 and Z flagged
;             If command not handled:
;               A = 0xFF and NZ flagged
;             No register contents preserved
; If found the command is executed before return. HL points to
; start of parameter string when command code entered.
CLIExecute:
            ;EI
@Leading:   LD   A,(DE)         ;Skip leading spaces...
            CP   kSpace         ;Space character?
            JR   NZ,@NotSpace   ;No, so continue to next char
            INC  DE             ;Increment string pointer
            JR   @Leading       ;Go consider next character
@NotSpace:  CP   kNull          ;Blank line?
            RET  Z              ;Yes, so exit with A=0x00 and Z flagged
; Optionally include scripting
#IFDEF      IncludeScripting
; Scripting lines start with a numeric character
            CALL IsCharNumeric  ;Numeric character
            JR   NC,@NotNum     ;No, so skip..
            CALL CLIGetHexParam
            CALL ScrEdit        ;Send line to scripting editor
            JR   @Return
@NotNum:
#ENDIF
; Offer command string to system command line interpreter
; DE = Start of command string
            LD   HL,CmdNameList
            LD   BC,CmdAddressList
            CALL SearchStringList
;           JR   Z,@Error       ;Not found so return error
            JR   Z,@NotFound    ;Not found so try single letter
; Execute command
            LD   BC,@Return     ;Get return address
            PUSH BC             ;Push return address onto stack
            JP   (HL)           ;Execute address from table
@NotFound
; Try looking for command in ROM filing system
#IFDEF      IncludeRomFS
            PUSH DE
            CALL RomExFile      ;Execute ROM file named at DE
            POP  DE
            RET  Z              ;Exit if command executed
#ENDIF
; Try inserting space after first character in command string
; to allow single letter commands to be entered without space
; DE = Start of command string
            LD   H,D            ;Get start of command string..
            LD   L,E
            INC  HL             ;Skip first character in string
            LD   C,kSpace       ;Insert space
@Shift:     LD   A,(HL)         ;Get current character
            LD   (HL),C         ;Write new character
            LD   C,A            ;Store previous character
            LD   A,(HL)         ;Get character just written
            INC  HL             ;Point to next character
            OR   A              ;Null terminator?
            JR   NZ,@Shift      ;No, so repeat
            LD   HL,CmdNameList
            LD   BC,CmdAddressList
            CALL SearchStringList
            JR   Z,@Error       ;Not found so return error
; Execute single letter command
            LD   BC,@Return     ;Get return address
            PUSH BC             ;Push return address onto stack
            JP   (HL)           ;Execute address from table
; Return here after executing the command
@Return:    XOR  A              ;Return A = 0x00 and Z flagged
            RET
; Bad command
@Error:     LD   A,kMsgBadCmd   ;Message = Bad command
            CALL OutputMessage  ;Output message
            LD   A,0xFF         ;No match found, so return:
            OR   A              ;  A = 0xFF and NZ flagged
            RET


; Skip non-deliminaters in input line
;   On entry: DE = Start address in input line
;   On exit:  A = Character at returned address
;             DE = Address of first non-delimiter character
;             BC HL IX IY preserved
; Delimiters are spaces or tabs (actually any control character other than null)
; Input line must be null terminated
; The return address can be that of the null terminator
CLISkipNonDeli:
@Loop:      LD   A,(DE)         ;Get character from input line
            OR   A              ;End of line (null)?
            RET  Z              ;Yes, so exit
            CP   kSpace+1       ;Character > space?
            RET   C             ;No, so exit
            INC  DE             ;No, so non-delimiter
            JR   @Loop          ;  and go try next character


; Skip deliminaters in input line
;   On entry: DE = Start address in input line
;   On exit:  If end of line (null) found:
;               A = Zero and Z flagged
;               DE = Address of null character
;             If non-delimiter character found:
;               A = Character found and NZ flagged
;               DE = Address of first non-delimiter character
;             BC HL IX IY preserved
; Delimiters are spaces or tabs (actually any control character other than null)
; Input line must be null terminated
; The return address can be that of the null terminator
CLISkipDelim:
@Loop:      LD   A,(DE)         ;Get character from input line
            OR   A              ;End of line (null)?
            RET  Z              ;Yes, so exit
            CP   kSpace+1       ;Character > space?
            RET  NC             ;Yes, so exit
            INC  DE             ;No, so skip delimiter
            JR   @Loop          ;  and go try next character


; Get hex word/byte from input line
;   On entry: A = Error reporting flags kReportXXX
;             DE = Location of parameter in input line
;             HL = Default value returned if no parameter found
;   On exit:  If a valid hex parameter:
;               A = 0x00 and Z flagged and C flagged
;               DE = Location after parameter in input line
;               HL = Hex byte/word from input line
;               Carry flagged if no parameter found
;             If no parameter if found:
;               A = 0x00 and Z flagged and NC flagged
;               DE = Location after parameter in input line
;               HL = Hex byte/word from input line
;               Carry flagged if no parameter found
;               An error message is may be shown
;             If an invalid hex parameter is found
;               A = 0xFF and NZ flagged and NC flagged
;               DE = Location after any valid characters
;               HL = Unspecified
;               An error message is may be shown
;             BC IX IY preserved
; If a non-hex character is encountered before a delimiter or null an error
; is reported.
; The hex conversion duplicates that in ConvertStringToNumber but we
; can't use that function here for hex as it requires leading numeric
; character ('0' to '9') for hex numbers:
; ... this is to stop the assembler getting confused between
; ... register names and constants which could be fixed by
; ... re-ordering the (dis)assebmer's instruction table
CLIGetHexParam:
            PUSH BC             ;Preserve BC
            LD   C,A            ;Store error report flags
            CALL CLISkipDelim   ;Skip deliminater
            OR   A              ;End of line (null)? This clears carry flag
            JR   Z,@None        ;Yes, so exit as no parameter found
            CALL IsCharHex      ;Is first character hexadecimal ?
            JR   NC,@Other      ;No, so invalid hex character
            LD   HL,0           ;Clear result (from supplied default)
@Loop:      LD   A,(DE)         ;Get character from input line
;           OR   A              ;End of line (null)? This clears carry flag
;           JR   Z,@None        ;Yes, so exit as ????with A = 0x00 and Z flagged
            CP   kSpace+1       ;Character > space?
            JR   C,@Found       ;No, so go end with delimiter
            CALL ConvertCharToUCase
            CALL ConvertCharToNumber
            JR   NZ,@Bad        ;Bad hex parameter
            SLA  L              ;Rotate new nibble
            RL   H              ;  into 16 bit result...
            SLA  L
            RL   H
            SLA  L
            RL   H
            SLA  L
            RL   H
            OR   L
            LD   L,A
            INC  DE
            JR   @Loop
; Try all other format not starting with hex character
@Other:     CALL ConvertStringToNumber
            JR   Z,@Found
            JR   @Bad
; Valid hex parameter found
@Found:     POP  BC             ;Retore BC
            XOR  A              ;Return with A = 0x00
            SCF                 ;  and Z flagged (= no bad hex)
            RET                 ;  and C flagged (= no error)
; Parameter error: no parameter found
@None:      LD   A,C            ;Get error report flags
            AND  kReportMis     ;Missing parameter report flag?
            CALL NZ,@Error      ;Yes, so report error
            POP  BC             ;Retore BC
            XOR  A              ;Return with A = 0x00
            ;  and Z flagged (= no bad hex)
            RET                 ;  and NC flagged (= error)
; Parameter error: non-hex digit found
@Bad:       LD   A,C            ;Get error report flags
            AND  kReportBad     ;Bad parameter report flag?
            CALL NZ,@Error      ;Yes, so report error
            POP  BC             ;Retore BC
            LD   A,0xFF         ;;Return with A = 0xFF 
            OR   A              ;  and NZ flagged (= bad hex)
            RET                 ;  and NC flagged (= error)
; Report error
@Error:     ;PUSH DE
            CALL CLIBadParam
            ;POP  DE
            INC  DE
            RET


; **********************************************************************
; **  Private functions                                               **
; **********************************************************************


; Output bad parameter error message
CLIBadParam:
            PUSH AF
            LD   A,kMsgBadPar   ;Message = Bad parameter
            CALL OutputMessage  ;Output message
            POP  AF
            RET


; Returns NZ if mini-terminal mode
#IFDEF      IncludeMiniTerm
IsMiniTerm: LD   A,(iMiniTerm)  ;Get mini-terminal mode flag
            OR   A              ;Return NZ in mini-terminal mode
            RET
#ELSE
IsMiniTerm: XOR  A              ;Return Z as no mini-terminal mode
            RET
#ENDIF


; **********************************************************************
; **  Commands                                                        **
; **********************************************************************


; Command: API <fn> [<A>] [<DE>]
CmdAPI:     LD   A,kReportAny   ;Report any error
            CALL CLIGetHexParam ;Get function number
            RET  NC             ;Abort if any error
            LD   C,L            ;Store function number
            LD   A,kReportBad   ;Only report bad hex parameter
            CALL CLIGetHexParam ;Get value for A register
;           JR   NC             ;Abort if any error
            LD   B,L            ;Store value for A register
            LD   A,kReportBad   ;Only report bad hex parameter
            CALL CLIGetHexParam ;Get value for DE registers
;           RET  NC             ;Abort if any error
            EX   DE,HL          ;Prepare DE register value
            LD   A,B            ;Prepare A register
@Call:      ;RST  $30           ;Call API function C
            CALL JpAPI          ;Call API function C
            CALL StrWrHexByte   ;Write hex byte to string
            CALL StrWrSpace     ;Write space to string
            CALL StrWrHexWord   ;Write hex word to string
            CALL StrWrNewLine   ;Write new line to string
            JP   StrPrint       ;Output string


; Command: Assembler: A [<start address>]
#IFDEF      IncludeAssembler
CmdAssemble:
            LD   HL,(iParam1)   ;Default parameter
            LD   A,kReportBad   ;Only report bad hex parameter
            CALL CLIGetHexParam
            RET  NZ             ;Abort if bad hex in parameter
; Start new line. HL = Current memory location, DE = Not specified
@NextLine:  LD   (iParam1),HL   ;Update default parameter
            CALL WrInstruction
            CALL StrPrint
; Input line. HL = Next memory location, DE = Not specified
            CALL InputLine      ;Input text line
            JR   NZ,@GotLine    ;Skip if line is not a null string
            CP   kEscape        ;Escaped from input line?
            RET  Z              ;Yes, so abort
            JR   @NextLine      ;No, so go to next line
; Got line to process. HL = Not specified, DE = Start of line
@GotLine:   LD   HL,(iParam1)   ;Get address for this instruction
            LD   A,(DE)         ;Get character from input line
;           OR   A              ;End of line?
;           JR   Z,@NextLine    ;Yes, so go to next location
            CP   '.'            ;End modify?
            RET  Z              ;Yes, so exit
;           CP   '"'            ;String? (quote character)
;           JR   Z,@String      ;Yes...
;           CP   '^'            ;Back one address?
;           JR   Z,@Back        ;Yes...
; New assembler instruction
            CALL Assemble       ;Assemble string in input buffer
            JR   Z,@Error
            LD   HL,(iParam1)
            CALL StrInitDefault ;Initiase default string buffer
            CALL DisWrInstruction ;Full disassembly to string buffer
            CALL StrWrNewLine
            CALL StrPrint       ;Print to output device
            JR   @NextLine
; Report error
@Error:     OR   A              ;Error 0 = unspecifed
            JR   NZ,@ErrOut     ;No, so skip
            LD   A,kMsgSyntax   ;Message = Syntax error
@ErrOut:    CALL OutputMessage  ;Output message
            LD   HL,(iParam1)
            JR   @NextLine
#ENDIF


; Command: Baud rate: Baud <device> <rate-code>
#IFDEF      IncludeBaud
CmdBaud:    LD   A,kReportAny   ;Report bad or missing hex parameter
            CALL CLIGetHexParam
            RET  NC             ;Abort if bad hex in parameter
            LD   C,L            ;Store device number (1 to 6, or A to B)
            LD   A,kReportAny   ;Report bad or missing hex parameter
            CALL CLIGetHexParam
            RET  NC             ;Abort if bad hex in parameter
            LD   A,C            ;Get requested device identifier
            LD   E,L            ;Get requested baud rate code
            CALL SetBaud        ;Set device (A) to baud rate (E) 
            JP   Z,CLIBadParam  ;Failed, so raise error
            RET
#ENDIF


; Command: Breakpoint: B [<address>]
#IFDEF      IncludeBreakpoint
CmdBP:      LD   HL,(iParam1)   ;Default parameter
            LD   A,kReportBad   ;Only report bad hex parameter
            CALL CLIGetHexParam
            RET  NZ             ;Abort if bad hex in parameter
            JR   C,@Set         ;If address given then set breakpoint
            CALL BPReqClr       ;No address, so clear requested address
            LD   A,kMsgBPClr    ;String = Breakpoint cleared
            JR   @Result        ;Go output message
@Set:       CALL BPReqSet       ;Attempt to set breakpoint
            LD   A,kMsgBPSet    ;String = Breakpoint set
            JR   NZ,@Result     ;Skip if breakpiont set ok
            LD   A,kMsgBPFail   ;String = Breakpoint setting failed
@Result:    JP   OutputMessage  ;Output message A
#ENDIF


; Command: Console <device>
CmdConsole: LD   A,kReportAny   ;Report bad or missing hex parameter
            CALL CLIGetHexParam
            RET  NC             ;Abort if bad hex in parameter
            LD   A,L            ;Get requested device number
            OR   A              ;Device = 0?
            JP   Z,CLIBadParam  ;Yes, then error
            CP   0x0A           ;Identifier is a hex letter?
            JR   C,@GotNum      ;No, so skip
            SUB  0x09           ;Convert 0x0A/B to 0x01/2
@GotNum:    CP   7              ;Device >= 7?
            JP   NC,CLIBadParam ;Yes, then error
            CALL SelConDev      ;Select console device
            RET


; Command: Devices
CmdDevices: ;LD   A,kMsgDevice  ;="Devices:"
            ;CALL OutputMessage ;Output message
            JP   HW_MsgDevs     ;Output device list


; Command: Directory: DIR
#IFDEF      IncludeRomFS
CmdDir:     CALL RomSearchInit  ;Initialise ROM file search
@Loop:      CALL RomSearchNext  ;Search for next file reference
            RET  NZ             ;None found so abort
            CALL RomGetName     ;Get pointer to file name
            CALL StrPrintDE     ;Print file name
            LD   A,kPeriod      ;Get period character ('.')
            CALL OutputChar     ;Output character
            CALL RomGetType     ;Get file type
            AND  0x0F           ;Remove file flags from type
            ADD  A              ;A = 2 x File type
            ADD  A              ;A = 4 x File type
            LD   L,A            ;Store as HL
            LD   H,0
            LD   DE,@Extns      ;Get start of extension strings
            ADD  HL,DE          ;Add offset for this file type
            EX   DE,HL
            CALL OutputZString  ;Output file extension
            CALL OutputNewLine  ;Output new line
            JR   @Loop
@Extns:     .DB  "DAT",0        ;Type 0 = Unspecified
            .DB  "COM",0        ;Type 1 = Monitor command
            .DB  "EXE",0        ;Type 2 = Executable
            .DB  "HLP",0        ;Type 3 = Help
            .DB  "TXT",0        ;Type 4 = Text
            .DB  "???",0        ;Type 5 = Unknown
#ENDIF


; Command: Disassemble: D [<start address>]
#IFDEF      IncludeDisassemble
CmdDisassemble:
CmdList:
            LD   HL,(iParam1)   ;Default parameter
            LD   A,kReportBad   ;Only report bad hex parameter
            CALL CLIGetHexParam
            RET  NZ             ;Abort if bad hex in parameter
@More:      LD   D,20           ;Number of instructions to list
@Instruct:  CALL DisWrInstruction ;Full disassembly to string buffer
            CALL StrWrNewLine   ;Write new line to string buffer
            CALL StrPrint       ;Print to output device
            DEC  D              ;Any more instruction to write?
            JR   NZ,@Instruct   ;Yes, so go write next one
            LD   (iParam1),HL   ;Update default parameter
            CALL InputMore      ;Print more?
            JR   Z,@More        ;Yes, so repeat
            RET
#ENDIF


; Command: Edit memory: E [<start address>]
CmdEdit:    LD   HL,(iParam1)   ;Default start address
            LD   A,kReportBad   ;Only report bad hex parameter
            CALL CLIGetHexParam
            RET  NZ             ;Abort if bad hex in parameter
; Start new line. HL = Current memory location, DE = Not specified
@NextLine:  LD   (iParam1),HL   ;Store current address
            CALL IsMiniTerm     ;Is this command in mini-terminal mode?
            JR   NZ,@Mini       ;Yes, so skip
; Normal terminal mode
            CALL WrInstruction  ;Write disassembled instruction string
            CALL StrPrint       ;Output disassembled instruction
            CALL InputLine      ;Input text line
            JR   @Inputed
; Mini-terminal mode
@Mini:      CALL StrInitDefault ;Initialise default string buffer
            LD   D,H            ;Get current address
            LD   E,L
            INC  HL             ;Prepare return address
            CALL StrWrHexWord   ;Write memory address string
            CALL StrWrSpace     ;Write space to string
            CALL StrPrint       ;Print string
            CALL StrInitDefault ;Initialise default string buffer
            LD   A,(DE)         ;Read byte from memory
            CALL StrWrHexByte   ;Write hex byte to string buffer
            ;CALL InputLineEdit ;Edit input line
            LD   DE,kInputBuff  ;Start of system line buffer
            CALL StrCopyToZ     ;Copy current string to input buffer
            LD   A,kInputSize-1 ;Length of system line buffer
            CALL InputLineNow   ;Input line

; Input line. HL = Next memory location, DE = Not specified
            ;CALL InputLine     ;Input text line
@Inputed:   JR   NZ,@GotLine    ;Skip if line is not a null string
            CP   kEscape        ;Escaped from input line?
            RET  Z              ;Yes, so abort
            JR   @NextLine      ;No, so go to next line
; Got line to process. HL = Not specified, DE = Start of line
@GotLine:   LD   HL,(iParam1)   ;Get address for this instruction
@NextParam: LD   A,(DE)         ;Get character from input line
            OR   A              ;End of line?
            JR   Z,@NextLine    ;Yes, so go to next location
            CP   '.'            ;End modify?
            RET  Z              ;Yes, so exit
            CP   '"'            ;String? (quote character)
            JR   Z,@String      ;Yes...
            CP   '^'            ;Back one address?
            JR   Z,@Back        ;Yes...
; New memory data is a hex value
            PUSH HL             ;Remember current memory location
            LD   L,A            ;Set default value to current contents
            LD   A,kReportBad   ;Only report bad hex parameter
            CALL CLIGetHexParam
            LD   A,L            ;Get parameter value (lo byte only)
            POP  HL             ;Restore current location
            JR   NZ,@NextLine   ;If bad hex parameter start next line
            JR   NC,@NextLine   ;If no parameter then start next line
            LD   (HL),A         ;Store new byte at current location
            INC  HL             ;Increment memory location
;           LD   (iParam1),HL   ;Update memory location
            JR   @NextParam
; New memory data is a string
@String:    INC  DE             ;Increment pointer to input line
            LD   A,(DE)         ;Get character from input line
            OR   A              ;End of string?
            JR   Z,@NextLine    ;Yes, next line
            LD   (HL),A         ;Store new byte at current location
            INC  HL             ;Increment memory location
            JR   @String
; Back one location
@Back:      DEC  HL             ;Back one memory location
            JR   @NextLine


; Command: Flag: F [<name>]
CmdFlag:    CALL CLISkipDelim   ;Skip deliminater
            JR   Z,@Results     ;No flag specified so display flags
; Flag name specified so set or clear flag
            LD   HL,FlagNames
            LD   BC,FlagLogic
            CALL SearchStringList
            JP   Z,CLIBadParam  ;Report error if flag name not found
            LD   A,(iAF)        ;Get flags register
            AND  L              ;AND with value from list
            OR   H              ;OR with value form list
            LD   (iAF),A        ;Get flags register
@Results:   CALL WrRegister1    ;Write registers line 1 to buffer
            JP   StrPrint       ;Output registers (inc flags)


; Command: Fill <start> <end> <data>
CmdFill:    LD   A,kReportAny   ;Report any error
            CALL CLIGetHexParam ;Start address
            RET  NC             ;Abort if any error
            LD   (iParam1),HL   ;Store start address
            LD   A,kReportAny   ;Report any error
            CALL CLIGetHexParam ;End address
            RET  NC             ;Abort if any error
            LD   B,H            ;Store last address
            LD   C,L
            LD   A,kReportAny   ;Report any error
            CALL CLIGetHexParam ;Data byte
            RET  NC             ;Abort if any error
            LD   E,L            ;Store data byte
            LD   HL,(iParam1)   ;Get start address
            DEC  HL
@Loop:      INC  HL             ;Point to next address to fill
            LD   (HL),E         ;Write date byte to memory
            LD   A,L            ;Lo byte of current address
            CP   C              ;Same as last address to fill?
            JR   NZ,@Loop       ;No, so continue
            LD   A,H            ;Hi byte of current address
            CP   B              ;Same as last address to fill?
            JR   NZ,@Loop       ;No, so continue
            RET


; Command: Go: G [<start address>]
CmdGo:      LD   A,kReportBad   ;Only report bad hex parameter
            CALL CLIGetHexParam
            RET  NZ             ;Abort if bad hex in parameter
            JR   NC,@Restore    ;Skip if no address parameter
            LD   (iPC),HL       ;Store supplied address as PC
            LD   HL,kSPUsr      ;Get top of user stack
            LD   DE,WarmStart   ;Get return address
            DEC  HL             ;  and 'push' it onto
            LD   (HL),D         ;  user stack
            DEC  HL
            LD   (HL),E
            LD   (iSP),HL       ;Store as user stack pointer
#IFDEF      IncludeBreakpoint
@Restore:   JP   BPGo           ;Execute using stored register values
#ELSE
@Restore:   LD   HL,(iPC)       ;Get execution address
            JP   (HL)           ;Run from this address
#ENDIF


; Command: Help: HELP or ?
#IFDEF      IncludeHelp
CmdHelp:    LD   A,kMsgAbout    ;Message = about text
            CALL OutputMessage  ;Output message
            CALL OutputNewLine  ;Output new line
            LD   A,kMsgHelp     ;Message = help text
            ;JP   OutputMessage ;Output message
            CALL OutputMessage  ;Output message
; Look for ROM filing system help extensions
#IFDEF      IncludeRomFS
            CALL RomSearchInit
@Loop:      CALL RomSearchNext
            RET  NZ
            CALL RomGetType
            CP   3
            JR   NZ,@Loop
            CALL RomGetHlp
            CALL OutputZString
            JR   @Loop
#ELSE
            RET
#ENDIF
#ENDIF


; Command: Input: I <port address>
CmdIn:      LD   A,kReportAny   ;Report any error
            CALL CLIGetHexParam
            RET  NC             ;Abort if any error
            LD   C,L
            LD   B,H
            IN   A,(C)          ;Input from specified port
            CALL StrWrHexByte   ;Write hex byte to string
            CALL StrWrNewLine   ;Write new line to string
            JP   StrPrint       ;Output string


; Command: Memory display: M [<start address>]
CmdMemory:  LD   HL,(iParam1)   ;Default parameter
            LD   A,kReportBad   ;Only report bad hex parameter
            CALL CLIGetHexParam
            RET  NZ             ;Abort if bad hex in parameter
@More:      LD   D,H
            LD   E,L
            LD   C,8            ;Number of lines of hex dump
@Line:      CALL WrMemoryDump   ;Build string of one line of dump
            CALL StrPrint       ;Print to output device
            DEC  C              ;End of dump?
            JR   NZ,@Line       ;No, so loop back for another line
            LD   H,D
            LD   L,E
            LD   (iParam1),HL   ;Update default parameter
            CALL InputMore      ;Print more?
            JR   Z,@More        ;Yes, so repeat
            RET


; Command: New script: NEW
#IFDEF      IncludeScripting
CmdNew:     JP   ScrNew         ;Script, new command
#ENDIF


; Command: Old script: OLD
#IFDEF      IncludeScripting
CmdOld:     JP   ScrOld         ;Script, old command
#ENDIF


; Command: Output: O <port address> <port data>
CmdOut:     LD   A,kReportAny   ;Report any error
            CALL CLIGetHexParam
            RET  NC             ;Abort if any error
            LD   C,L
            LD   B,H
            LD   A,kReportAny   ;Report any error
            CALL CLIGetHexParam
            RET  NC             ;Abort if any error
            LD   A,L
            OUT  (C),A
            RET


; Command: Registers: R [<name>]
CmdRegisters:
            CALL CLISkipDelim   ;Skip deliminater
            JR   NZ,@Param      ;Go handle parameter
; No parameters, so just output register values
@Show:      CALL WrRegister1
            CALL StrPrint
            CALL WrRegister2
            JP   StrPrint
; Handle parameter
@Param:     PUSH DE             ;Preserve start address of parameter
            LD   HL,RegisterNames
            LD   BC,RegisterAddresses
            CALL SearchStringList
            POP  DE             ;Restore start address of parameter
            JP   Z,CLIBadParam  ;Report error if reg name not found
; Edit specified register's value
            CALL StrInitDefault ;Initialise default string buffer
            LD   C,0            ;Length of register name
@NextChar:  LD   A,(DE)         ;Get character of register name
            CP   kSpace-1       ;End of register name?
            JR   C,@Colon       ;Yes, so write colon
            CALL ConvertCharToUCase
            CALL StrWrChar      ;Write character to string buffer
            INC  C              ;Count characters in name
            INC  DE             ;Increment to next char of name
            JR   @NextChar      ;  and go get next character
@Colon:     LD   A,':'          ;Get colon character
            CALL StrWrChar      ;Write colon to string buffer
            CALL StrWrSpace     ;Write space to string buffer
            LD   E,(HL)         ;Get register contents
            INC  HL
            LD   D,(HL)
            DEC  HL
            LD   A,C            ;Length of register name
            CP   1              ;One character long?
            JR   NZ,@Word
            LD   A,E            ;Get lo byte 
            CALL StrWrHexByte   ;Write hex byte value of register
            JR   @Space
@Word:      CALL StrWrHexWord   ;Write hex word value of register
@Space:     LD   A,2
            CALL StrWrSpaces    ;Write 2 spaces to string buffer
            CALL StrPrint       ;Print current string ot output device
; Input line. HL = Memory location of register
            CALL InputLine      ;Input text line
            RET  Z              ;No input, so we're done
; Extract new register value from input buffer
            PUSH HL             ;Preserve memory location
            LD   A,kReportAny   ;Report any error
            CALL CLIGetHexParam
            LD   E,L            ;Get hex value input
            LD   D,H
            POP  HL             ;Restore memory location
            RET  NC             ;If any error then we're done
            LD   (HL),E         ;Store lo byte at register location
            LD   A,C            ;Length of register name
            CP   1              ;One character long?
            RET  Z              ;Yes, so we're done
            INC  HL             ;Increment memory location
            LD   (HL),D         ;Store hi byte at register location
            RET


; Command: Reset: RESET
CmdReset:   .EQU ColdStart      ;Command reset = Cold start system
            DI                  ;Disable interrupts
            JP   ColdStart      ;Run as if hardware reset


; Command: Script list: SCRIPT
#IFDEF      IncludeScripting
CmdScript:  JP   ScrList
#ENDIF


; Command: Step: S [<start address>]
#IFDEF      IncludeDisassemble
#IFDEF      IncludeBreakpoint
CmdStep:    LD   A,kReportBad   ;Only report bad hex parameter
            CALL CLIGetHexParam
            RET  NZ             ;Abort if bad hex in parameter
            JR   NC,@Restore    ;Skip if no address parameter
            LD   (iPC),HL       ;Store supplied address as PC
            LD   HL,kSPUsr      ;Get top of user stack
            LD   DE,WarmStart   ;Get return address
            DEC  HL             ;  and 'push' it onto
            LD   (HL),D         ;  user stack
            DEC  HL
            LD   (HL),E
            LD   (iSP),HL       ;Store as user stack pointer
@Restore:   JP   BPStep         ;Execute using stored register values
#ENDIF
#ENDIF


; Trap optional features that have not been included in this build
#IFNDEF     IncludeAssembler
CmdAssemble:
#ENDIF
#IFNDEF     IncludeBaud
CmdBaud:
#ENDIF
#IFNDEF     IncludeBreakpoint
CmdBP:
CmdStep:
#ENDIF
#IFNDEF     IncludeDisassemble
CmdDisassemble:
CmdList:
#ENDIF
#IFNDEF     IncludeRomFS
CmdDir:
#ENDIF
#IFNDEF     IncludeScripting
CmdNew:
CmdOld:
CmdScript:
#ENDIF
#IFNDEF     IncludeHelp
CmdHelp:
#ENDIF
            LD   A,kMsgNotAv    ;Message = Feature no included
            JP   OutputMessage  ;Output message


; **********************************************************************
; **  Constant data                                                   **
; **********************************************************************


; Command summary
; Char/Cmd,  Description     ? Other possible commands
;  :         Download intel hex record
;  ?         Help
;  A         Assemble        ?
;  B         Breakpoint      ?
;  C                         ? Compare, Copy, CPM
;  CONSOLE   Console select  ?
;  D         Disassemble     ? Dump, Display
;  DEVICES   Device list     ?
;  DIR       Directory list  ?
;  E         Edit memory     ? Execute
;  F         Flags           ? 
;  FILL      Fill memory     ?
;  G         Go              ?
;  H                         ?
;  HELP      Help            ?
;  I         Input from port ?
;  J                         ? Jump
;  K                         ? 
;  L                         ? Load, List 
;  M         Memory          ? Modify, Move
;  N                         ? Next, New
;  NEW       New script      ?
;  O         Output to port  ? Old
;  OLD       Old srcipt      ?
;  P                         ?
;  Q                         ?
;  R         Registers       ? 
;  RESET     Reset           ?
;  ROM       Directory list  ?
;  S         Step            ? Save, Script
;  SCRIPT    Script          ?
;  T                         ? Transfer
;  U                         ?
;  V                         ? Verify
;  W                         ?
;  X                         ?
;  Y                         ?
;  Z                         ?

; Command summary for mini-terminal
;  B         Breakpoint
;  E         Edit memory     (mini version -E)
;  F         Flags           (mini version needed)
;  G         Go
;  I         Input from port (mini version needed)
;  O         Output to port 
;  R         Registers       (mini version needed)
; Problems to sort: Console, Fill (if it is worth it)

; Command name list
; If list search allows abbreviations then the first match will be accepted
CmdNameList:
; Single character commands
            .DB  128+'?'        ;?        Help
            .DB  128+'A'        ;A        Assemble
            .DB  128+'B'        ;B        Breakpoint
            .DB  128+'D'        ;D        Disassemble
            .DB  128+'E'        ;E        Edit memory
            .DB  128+'F'        ;F        Flag
            .DB  128+'G'        ;G        Go
            .DB  128+'I'        ;I        Input from port
            .DB  128+'M'        ;M        Memory display
            .DB  128+'O'        ;O        Output to port
            .DB  128+'R'        ;R        Registers
            .DB  128+'S'        ;S        Step
; Full word commands
            .DB  128+'A',"PI"   ;API      API call
            .DB  128+'B',"AUD"  ;BAUD     Set baud rate
            .DB  128+'C',"ONSOLE" ;CONSOLE  Set console device
            .DB  128+'D',"EVICES" ;DEVICES  Devices list
            .DB  128+'D',"IR"   ;DIR      Directory
            .DB  128+'F',"ILL"  ;FILL     Fill memory
            .DB  128+'H',"ELP"  ;HELP     Help
            .DB  128+'R',"ESET" ;RESET    Reset
            .DB  128+'R',"OM"   ;ROM      Directory
; Optional commands
#IFDEF      IncludeScripting
            .DB  128+'N',"EW"   ;NEW      New (for script)
            .DB  128+'O',"LD"   ;OLD      Old (for script)
            .DB  128+'S',"CRIPT"  ;SCRIPT  Script (list program)
#ENDIF
            .DB  128            ;List terminator

; Command address list
CmdAddressList:
; Single character commands
            .DW  CmdHelp        ;?        Help
            .DW  CmdAssemble    ;A        Assemble
            .DW  CmdBP          ;B        Breakpoint
            .DW  CmdDisassemble ;D        Disassemble
            .DW  CmdEdit        ;E        Edit memory
            .DW  CmdFlag        ;F        Flag
            .DW  CmdGo          ;G        Go
            .DW  CmdIn          ;I        In
            .DW  CmdMemory      ;M        Memory display
            .DW  CmdOut         ;O        Out
            .DW  CmdRegisters   ;R        Registers
            .DW  CmdStep        ;S        Step
; Full word commands
            .DW  CmdAPI         ;API      API call
            .DW  CmdBaud        ;BAUD     Set baud rate
            .DW  CmdConsole     ;CONSOLE  Set console device
            .DW  CmdDevices     ;DEVICES  Devices list
            .DW  CmdDir         ;DIR      Directory
            .DW  CmdFill        ;FILL     Fill memory
            .DW  CmdHelp        ;HELP     Help
            .DW  CmdReset       ;RESET    Reset
            .DW  CmdDir         ;ROM      Directory
; Optional commands
#IFDEF      IncludeScripting
            .DW  CmdNew         ;NEW      New
            .DW  CmdOld         ;OLD      Old
            .DW  CmdScript      ;SCRIPT   Script 
#ENDIF


; Register name list (bit 7 delimited)
RegisterNames:
            .DB  128+'P','C'    ;PC
            .DB  128+'S','P'    ;SP
            .DB  128+'(',")"    ;()
            .DB  128+'(',"SP)"  ;(SP)
            .DB  128+'A','F'    ;AF
            .DB  128+'B','C'    ;BC
            .DB  128+'D','E'    ;DE
            .DB  128+'H','L'    ;HL
            .DB  128+'I','X'    ;IX
            .DB  128+'I','Y'    ;IY
            .DB  128+'A',"F'"   ;AF'
            .DB  128+'B',"C'"   ;BC'
            .DB  128+'D',"E'"   ;DE'
            .DB  128+'H',"L'"   ;HL'
            .DB  128+'A'        ;A
            .DB  128+'F'        ;F
            .DB  128+'B'        ;B
            .DB  128+'C'        ;C
            .DB  128+'D'        ;D
            .DB  128+'E'        ;E
            .DB  128+'H'        ;H
            .DB  128+'L'        ;L
            .DB  128+'I'        ;I
            .DB  128            ;List terminator
; Register address list
RegisterAddresses:
            .DW  iPC            ;PC
            .DW  iSP            ;SP
            .DW  iCSP           ;()
            .DW  iCSP           ;(SP)
            .DW  iAF            ;AF
            .DW  iBC            ;BC
            .DW  iDE            ;DE
            .DW  iHL            ;HL
            .DW  iIX            ;IX
            .DW  iIY            ;IY
            .DW  iAF2           ;AF'
            .DW  iBC2           ;BC'
            .DW  iDE2           ;DE'
            .DW  iHL2           ;HL'
            .DW  iAF+1          ;A
            .DW  iAF            ;F
            .DW  iBC+1          ;B
            .DW  iBC            ;C
            .DW  iDE+1          ;D
            .DW  iDE            ;E
            .DW  iHL+1          ;H
            .DW  iHL            ;L
            .DW  iIR+1          ;H


; Flag names list (bit 7 delimited)
FlagNames:  .DB  128+'S'        ;S    Bit 7, Flag S set to 1 (negative/minus)
            .DB  128+'N','S'    ;NS   Bit 7, Flag S cleared to 0 (positive)
            .DB  128+'M'        ;M    Bit 7, Flag S set to 1 (negative/minus)
            .DB  128+'P'        ;P    Bit 7, Flag S cleared to 0 (positive)
            .DB  128+'Z'        ;Z    Bit 6, Flag Z set to 1 (zero)
            .DB  128+'N','Z'    ;NZ   Bit 6, Flag Z cleared to 0 (not zero)
            .DB  128+'H'        ;H    Bit 4, Flag H set to 1 (half carry)
            .DB  128+'N','H'    ;NH   4it 4, Flag H cleared to 0 (not half carry)
            .DB  128+'P','A'    ;Pa   Bit 2, Flag P/V set to 1 (even parity or overflow)
            .DB  128+'N','P'    ;NP   Bit 2, Flag P/V set to 0 (odd parity or no overflow)
            .DB  128+'P','E'    ;PE   Bit 2, Flag P/V set to 1 (even parity or overflow)
            .DB  128+'P','O'    ;Po   Bit 2, Flag P/V set to 0 (odd parity or no overflow)
            .DB  128+'N'        ;N    Bit 1, Flag N set to 1 (subtract)
            .DB  128+'N','N'    ;NN   Bit 1, Flag N cleared to 0 (add)
            .DB  128+'C'        ;C    Bit 0, Flag C set to 1 (carry)
            .DB  128+'N','C'    ;NC   Bit 0, Flag C cleared to 0 (not carry)
            .DB  128            ;List terminator
; Flag manipulation list 
; Lo byte is ANDed with flags register, then Hi byte is ORed with flags register
; Yes, we could drive this from one byte but we are using the existing list handlers
; which need words, so might as well specify both AND and OR values!
FlagLogic:  .DB  0x7F,0x80      ;S    Bit 7, Flag S set to 1 (negative/minus)
            .DB  0x7F,0x00      ;NS   Bit 7, Flag S cleared to 0 (positive)
            .DB  0x7F,0x80      ;M    Bit 7, Flag S set to 1 (negative/minus)
            .DB  0x7F,0x00      ;P    Bit 7, Flag S cleared to 0 (positive)
            .DB  0xBF,0x40      ;Z    Bit 6, Flag Z set to 1 (zero)
            .DB  0xBF,0x00      ;NZ   Bit 6, Flag Z cleared to 0 (not zero)
            .DB  0xEF,0x10      ;H    Bit 4, Flag H set to 1 (half carry)
            .DB  0xEF,0x00      ;NH   4it 4, Flag H cleared to 0 (not half carry)
            .DB  0xFB,0x04      ;Pa   Bit 2, Flag P/V set to 1 (even parity or overflow)
            .DB  0xFB,0x00      ;NP   Bit 2, Flag P/V set to 0 (odd parity or no overflow)
            .DB  0xFB,0x04      ;PE   Bit 2, Flag P/V set to 1 (even parity or overflow)
            .DB  0xFB,0x00      ;Po   Bit 2, Flag P/V set to 0 (odd parity or no overflow)
            .DB  0xFD,0x02      ;N    Bit 1, Flag N set to 1 (subtract)
            .DB  0xFD,0x00      ;NN   Bit 1, Flag N cleared to 0 (add)
            .DB  0xFE,0x01      ;C    Bit 0, Flag C set to 1 (carry)
            .DB  0xFE,0x00      ;NC   Bit 0, Flag C cleared to 0 (not carry)


; **********************************************************************
; **  Private workspace (in RAM)                                      **
; **********************************************************************

            .DATA

iParam1:    .DW  0x0000         ;CLI parameter 1

#IFDEF      IncludeMiniTerm
iMiniTerm:  .DB  0x00           ;Mini terminal flag
#ENDIF

            .CODE

; **********************************************************************
; **  End of Command Line Interpreter                                 **
; **********************************************************************













