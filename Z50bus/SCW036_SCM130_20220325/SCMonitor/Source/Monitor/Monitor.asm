; **********************************************************************
; **  Monitor essentials                        by Stephen C Cousins  **
; **********************************************************************

; This module provides the following:
;   Defines monitor's global workspace / variables
;   Defines monitor's constant message data
;   Function to output monitor messages
;
; Public functions provided:
;   MonInit               Initialise monitor
;   MonGetVers            Get monitor version number
;   MonOutputMsg          Output monitor messages


; **********************************************************************
; **  Constants                                                       **
; **********************************************************************

; Message numbers
kMsgMonFst  .EQU 0x20           ;First monitor message
kMsgBadCmd: .EQU kMsgMonFst+0   ;Bad commandr
kMsgBadPar: .EQU kMsgMonFst+1   ;Bad parameter
kMsgSyntax: .EQU kMsgMonFst+2   ;Syntax error
kMsgBPSet:  .EQU kMsgMonFst+3   ;Breakpoint set
kMsgBPClr:  .EQU kMsgMonFst+4   ;Breakpoint cleared
kMsgBPFail: .EQU kMsgMonFst+5   ;Unable to set breakpoint here
kMsgHelp:   .EQU kMsgMonFst+6   ;Help text
kMsgNotAv:  .EQU kMsgMonFst+7   ;Feature not included
kMsgMReady: .EQU kMsgMonFst+8   ;Ready
kMsgMFileE: .EQU kMsgMonFst+9   ;File error
kMsgMonLst: .EQU kMsgMFileE     ;Last monitor message


; **********************************************************************
; **  Public functions                                                **
; **********************************************************************

            .DATA

            .ORG  kMonData      ;Establish workspace/data area

            .CODE

; Entry points
M_MonInit:  JP   MonInit
M_CLILoop:  JP   CLILoop
M_OutputMs: JP   MonOutputMsg
M_GetVers:  JP   MonGetVers
M_Execute:  JP   CLIExecute
M_SkipDeli: JP   CLISkipDelim
M_SkipNone: JP   CLISkipNonDeli
M_GetHexPa: JP   CLIGetHexParam

#IFNDEF     IncludeCommands
CLILoop:
CLIExecute:
CLISkipDelim:
CLISkipNonDeli:
CLIGetHexParam:
            RET
#ENDIF


; Monitor: Initialise monitor
MonInit:
; Claim breakpoint handler
            LD   A,5
            LD   DE,BPHandler
            LD   C,9
            ;RST  0x30          ;Call API
            CALL JpAPI          ;Call API

#IFDEF      IncludeBreakpoint
            CALL BPInitialise   ;Initialise breakpoint module
#ENDIF

            RET

; Hardware: Get version details
;   On entry: No parameters required
;   On exit:  D,E and A = Bios code version
;               D = kBiosMajor
;               E = kBiosMinor
;               A = kBiosRevis(ion)
;             IX IY I AF' BC' DE' HL' preserved
MonGetVers: LD  D,kMonMajor     ;D = Major version number
            LD  E,kMonMinor     ;E = Minor version number
            LD  A,kMonRevis     ;A = Revision number
            RET


; Monitor: Output message
;  On entry:  A = Message number (1 to n)
;   On exit:  If message output by monitor A = 0
;             otherwise A = Message number
;             BC IX IY I AF' BC' DE' HL' preserved
MonOutputMsg:
; Monitor message?
            CP   kMsgMonFst     ;Valid system message number?
            RET  C              ;No, so abort
            CP   kMsgMonLst+1   ;Valid system message number?
            RET  NC             ;No, so abort
            SUB  kMsgMonFst     ;Adjust message number to 0 to n
            LD   E,A            ;Get message number
            LD   D,0
            LD   HL,MsgTabMon   ;Get start of message table
            ADD  HL,DE          ;Calculate location in table
            ADD  HL,DE
            LD   A,(HL)         ;Get address from table...
            INC  HL
            LD   D,(HL)
            LD   E,A
            CALL OutputZString  ;Output message as DE
            XOR  A              ;Flag message output by monitor
            RET

; **********************************************************************
; **  Constant data                                                   **
; **********************************************************************

; Register and flag strings
; Terminate register name strings with '-' (for flags) or a null
; These strings must match the order the registers are stored in RAM
sRegisters: .DB  "PC:,AF:,BC:,DE:,HL:,IX:,IY:,Flags:-"
sRegister2: .DB  "SP:,AF',BC',DE',HL',(S),IR:,Flags'-"
sFlags:     .DB  "SZ-H-PNC"


; Message strings (zero terminated)
szBadCmd:   .DB  "Bad command",kNewLine,kNull
szBadParam: .DB  "Bad parameter",kNewLine,kNull
szAsmError: .DB  "Syntax error",kNewLine,kNull
szBPSet:    .DB  "Breakpoint set",kNewLine,kNull
szBPClear:  .DB  "Breakpoint cleared",kNewLine,kNull
szBPFail:   .DB  "Unable to set breakpoint here",kNewLine,kNull
szNotAvail: .DB  "Feature not included",kNewLine,kNull
szMReady:   .DB  "Ready",kNewLine,kNull
szMFileErr: .DB  "File error",kNewLine,kNull

szCmdHelp:
#IFDEF      IncludeHelp
            .DB  "Monitor commands:",kNewLine
; Single character commands         20        30        40        50        60        70        80
;                 12345678901234567890123456789012345678901234567890123456789012345678901234567890
            .DB  "A [<address>]  = Assemble        |  D [<address>]   = Disassemble",kNewLine
            .DB  "M [<address>]  = Memory display  |  E [<address>]   = Edit memory",kNewLine
            .DB  "R [<name>]     = Registers/edit  |  F [<name>]      = Flags/edit",kNewLine 
            .DB  "B [<address>]  = Breakpoint      |  S [<address>]   = Single step",kNewLine
            .DB  "I <port>       = Input from port |  O <port> <data> = Output to port",kNewLine
            .DB  "G [<address>]  = Go to program",kNewLine
; Full word commands
            .DB  "BAUD <device> <rate>             |  CONSOLE <device>",kNewLine
            .DB  "FILL <start> <end> <byte>        |  API <function> [<A>] [<DE>]",kNewLine
            .DB  "DEVICES, DIR, HELP, RESET",kNewLine
; Optional commands
#IFDEF      IncludeScripting
            .DB  "Scripting commands:",kNewLine
            .DB  "RUN, SCRIPT (list), OLD, NEW",kNewLine
#ENDIF
;           .DB  kNewLine
#ENDIF
            .DB  kNull


; Message table
MsgTabMon:  .DW  szBadCmd
            .DW  szBadParam
            .DW  szAsmError
            .DW  szBPSet
            .DW  szBPClear
            .DW  szBPFail
            .DW  szCmdHelp
            .DW  szNotAvail
            .DW  szMReady
            .DW  szMFileErr

; **********************************************************************
; **  Global workspace                                                **
; **********************************************************************

            .DATA

iRegisters:
; Order is hard coded so do not change (see strings above)
iPC:        .DW  0x0001         ;Register pair PC (Program Counter)
iAF:        .DW  0x0002         ;Register pair AF
iBC:        .DW  0x0003         ;Register pair BC
iDE:        .DW  0x0004         ;Register pair DE
iHL:        .DW  0x0005         ;Register pair HL
iIX:        .DW  0x0006         ;Register pair IX
iIY:        .DW  0x0007         ;Register pair IY

iRegister2:
; Order is hard coded so do not change (see strings above)
iSP:        .DW  0x0011         ;Register pair SP (Stack Pointer)
iAF2:       .DW  0x0012         ;Register pair AF'
iBC2:       .DW  0x0013         ;Register pair BC'
iDE2:       .DW  0x0014         ;Register pair DE'
iHL2:       .DW  0x0015         ;Register pair HL'
iCSP:       .DW  0x0016         ;Register pair (SP)
iIR:        .DW  0x0017         ;Register pair IR






