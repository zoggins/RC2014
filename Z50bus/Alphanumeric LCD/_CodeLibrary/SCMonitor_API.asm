; **********************************************************************
; **  Small Computer Monitor API                by Stephen C Cousins  **
; **********************************************************************
;
; **  Written as a module to be included in Small Computer Monitor Apps
; **  Version 0.2 SCC 2018-05-15 
; **  www.scc.me.uk
;
; **********************************************************************
;
; This module provides shims for SCMonitor API functions
;
; **********************************************************************
;
; To include the code for any given function provided by this module, 
; add the appropriate #REQUIRES <FunctionName> statement at the top of 
; the parent source file.
; For example:  #REQUIRES   aSystemReset
;
; Also #INCLUDE this file at some point after the #REQUIRES statements
; in the parent source file.
; For example:  #INCLUDE    ..\_CodeLibrary\SCMonAPI.asm
;
; To call an API function via these shims, use the #REQUIRES operand 
; (see list below), but without the leading "_".
; For example:  CALL aSystemReset
;
; These are the function names provided by this module:
; aSystemReset                  API 0x00: System reset
; aInputChar                    API 0x01: Input character from console
; aOutputChar                   API 0x02: Output character to console
; aInputStatus                  API 0x03: Get console input status
; aInputLineTo                  API 0x04: Input line to specified address
; aInputLineDef                 API 0x05: Input line to default address
; aOutputText                   API 0x06: Output null terminated string
; aOutputNewLine                API 0x07: Output new line (eg. CR+LF)
; aGetVersion                   API 0x08: Get version details
; aClaimJumpTab                 API 0x09: Claim jump table entry
; aDelayInMS                    API 0x0A: Delay in milliseconds
; aOutputSysMsg                 API 0x0B: Output system message
; aReadJumpTab                  API 0x0C: Read jump table entry
; aSelectConDev                 API 0x0D: Select console I/O device
; aSelectConIn                  API 0x0E: Select console input device
; aSelectConOut                 API 0x0F: Select console output device
; aInputFromDev                 API 0x10: Input from specified device
; aOutputToDev                  API 0x11: Output to specified device
; aPollEvents                   API 0x12: Poll idle events
; aConfigEvents                 API 0x13: Configure idle events
; aSet1msTimer                  API 0x14: Set up 1 ms timer 1
; aSet10msTimer                 API 0x15: Set up 10 ms timer 2
; aSet100msTimer                API 0x16: Set up 100 ms timer 3
; aInitOutPort                  API 0x17: Initialise output port
; aWriteOutPort                 API 0x18: Write to output port
; aReadOutPort                  API 0x19: Read from output port
; aTestOutBit                   API 0x1A: Test output port bit
; aSetOutBit                    API 0x1B: Set output port bit
; aClearOutBit                  API 0x1C: Clear output port bit
; aInvertOutBit                 API 0x1D: Invert output port bit
; aInitInPort                   API 0x1E: Initialise input port
; aReadInPort                   API 0x1F: Read from input port
; aTestInBit                    API 0x20: Test input port bit
; aSetBaudRate                  API 0x21: Set baud rate
; aExecuteCL                    API 0x22: Execute command line string
; aGetPtrToCL                   API 0x23: Get pointer to command line
; aSkipDelim                    API 0x24: Skip delimiter in line
; aSkipNonDelim                 API 0x25: Skip non-delimiter in line
; aGetHexParam                  API 0x26: Get hex parameter from line
; aGetConDevices                API 0x27: Get console device numbers
; aGetTopOfMem                  API 0x28: Get top of free memory
; aSetTopOfMem                  API 0x29: Set top of free memory


; **********************************************************************
; **  Constants
; **********************************************************************

; Character constants
kNull       .EQU 0              ;Null character/byte (0x00)
kNewLine    .EQU 5              ;New line character (0x05)
kBackspace: .EQU 8              ;Backspace character (0x08)
kLinefeed:  .EQU 10             ;Line feed character (0x0A)
kLF:        .EQU 10             ;Line feed character (0x0A)
kReturn:    .EQU 13             ;Return character (0x0D)
kCR:        .EQU 13             ;Return character (0x0D)
kEscape:    .EQU 27             ;Escape character (0x1B)
kSpace:     .EQU 32             ;Space character (0x20)
kQuote:     .EQU 34             ;Quotation mark (0x22)
kApostroph: .EQU 39             ;Apostrophe character (0x27)
kComma:     .EQU 44             ;Comma character (0x2C)
kPeriod:    .EQU 46             ;Period character (0x2E)
kColon:     .EQU 58             ;Colon character (0x3A)
kSemicolon: .EQU 59             ;Semicolon character (0x3B)
kDelete:    .EQU 127            ;Delete character (0x7F)

; Other constants are embedded with their API functions below


; **********************************************************************
; **  Program code
; **********************************************************************

            .CODE               ;Code section


; **********************************************************************
; **  SC Monitor API functions
; **********************************************************************


#IFREQUIRED aSystemReset
; API 0x00: System reset
;  On entry:  A = Reset type: 
;               0 = Cold start monitor
;               1 = Warm start monitor
;   On exit:  System resets
aSystemReset:
            LD   C,0x00         ;API 0x00
            RST  0x30           ;  = System reset
#ENDIF


#IFREQUIRED aInputChar
; API 0x01: Input character 
;   On entry: No parameters required
;   On exit:  A = Character input from current console device
;             BC DE HL IX IY I AF' BC' DE' HL' preserved
; Function does not return until a character has been received
aInputChar:
            PUSH BC
            PUSH DE
            PUSH HL
            LD   C,0x01         ;API 0x01
            RST  0x30           ;  = Input character
            POP  HL
            POP  DE
            POP  BC
            RET
#ENDIF


#IFREQUIRED aOutputChar
; API 0x02: Output character 
;   On entry: A = Character to be output to the current console device
;   On exit:  AF BC DE HL IX IY I AF' BC' DE' HL' preserved
aOutputChar:
            PUSH AF
            PUSH BC
            PUSH DE
            PUSH HL
            LD   C,0x02         ;API 0x02
            RST  0x30           ;  = Output character
            POP  HL
            POP  DE
            POP  BC
            POP  AF
            RET
#ENDIF


#IFREQUIRED aInputStatus
; API 0x03: Get character input status 
;   On entry: No parameters required
;   On exit:  NZ if character available
;             BC DE HL IX IY I AF' BC' DE' HL' preserved
aInputStatus:
            PUSH BC
            PUSH DE
            PUSH HL
            LD   C,0x03         ;API 0x03
            RST  0x30           ;  = Character input status
            POP  HL
            POP  DE
            POP  BC
            RET
#ENDIF


#IFREQUIRED aInputLineTo
; API 0x04: Input line to specified buffer
;   On entry: DE = Start of buffer
;             A = Size of input buffer in bytes
;   On exit:  A = Number of characters in input buffer
;             Z flagged if no characters in bufffer ???
;             BC DE HL IX IY I AF' BC' DE' HL' preserved
;             Interrupts enabled during this call ???
; Maximum buffer length 255 bytes.
; The buffer length includes the string termination character (null).
; The number of characters returned does not include the null terminator.
aInputLineTo:
            PUSH BC
            PUSH DE
            PUSH HL
            LD   C,0x04         ;API 0x04
            RST  0x30           ;  = Input line
            POP  HL
            POP  DE
            POP  BC
            RET
#ENDIF


#IFREQUIRED aInputLineDef
; API 0x05: Input line to default buffer
;   On entry: No parameters required
;   On exit:  DE = Start location of buffer
;             A = Number of characters in buffer
;             Z flagged if no characters in bufffer
;             BC HL IX IY I AF' BC' DE' HL' preserved
;             Interrupts enabled during this call ???
; The number of characters returned does not include the null terminator.
; DE points to a null terminated string to be edited
aInputLineDef:
            PUSH BC
            PUSH HL
            LD   C,0x05         ;API 0x05
            RST  0x30           ;  = Input line default
            POP  HL
            POP  BC
            RET
#ENDIF


#IFREQUIRED aOutputText
; API 0x06: Output text string (null terminated)
;   On entry: DE = Pointer to start of null terminated string
;   On exit:  AF BC DE HL IX IY I AF' BC' DE' HL' preserved
aOutputText:
            PUSH AF
            PUSH BC
            PUSH DE
            PUSH HL
            LD   C,0x06         ;API 0x06
            RST  0x30           ;  = Output string
            POP  HL
            POP  DE
            POP  BC
            POP  AF
            RET
#ENDIF


#IFREQUIRED aOutputNewLine
; API 0x07: Output new line
;   On entry: No parameters required
;   On exit:  AF BC DE HL IX IY I AF' BC' DE' HL' preserved
aOutputNewLine:
            PUSH AF
            PUSH BC
            PUSH DE
            PUSH HL
            LD   C,0x07         ;API 0x07
            RST  0x30           ;  = Output new line
            POP  HL
            POP  DE
            POP  BC
            POP  AF
            RET
#ENDIF


#IFREQUIRED aGetVersion
; API 0x08: Get version details
;   On entry: No parameters required
;   On exit:  D,E and A = Monitor code version
;               D = kVersMajor
;               E = kVersMinor
;               A = kVersRevis(ion)
;             B,C = Configuration ID
;               B = kConfMajor ('R'=RC2014, 'L'=LiNC80, etc)
;               C = kConfMinor (sub-type '1', '2', etc)
;             H,L = Target hardware ID
;               H = kHardID (1=Simulator, 2=,SCDevKt, 3=RC2014, etc)
;               L = Hardware option flags (hardware specific)
;             IX IY I AF' BC' DE' HL' preserved
aGetVersion:
            LD   C,0x08         ;API 0x08
            RST  0x30           ;  = Get version details
            RET
#ENDIF


#IFREQUIRED aClaimJumpTab
; API 0x09: Claim/write jump table entry
;   On entry: A = Entry number (0 to n)
;             DE = Address of function
;   On exit:  No parameters returned
;             AF BC DE HL IX IY I AF' BC' DE' HL' preserved
; Some system functions, such as console in and console out, are 
; redirected through a jump table. By claiming a jump table entry the
; function can be handled by any required code. This might allow
; swapping output to a different device, such as a printer.
aClaimJumpTab:
            PUSH AF
            PUSH BC
            PUSH DE
            PUSH HL
            LD   C,0x09         ;API 0x09
            RST  0x30           ;  = Claim jump table entry
            POP  HL
            POP  DE
            POP  BC
            POP  AF
            RET
; Jump table entry numbers
kFnNMI:     .EQU 0x00           ;Fn 0x00: non-maskable interrupt handler
kFnRST08:   .EQU 0x01           ;Fn 0x01: restart 08 handler
kFnRST10:   .EQU 0x02           ;Fn 0x02: restart 10 handler
kFnRST18:   .EQU 0x03           ;Fn 0x03: restart 18 handler
kFnRST20:   .EQU 0x04           ;Fn 0x04: restart 20 handler
kFnRST28:   .EQU 0x05           ;Fn 0x05: restart 18 breakpoint
kFnRST30:   .EQU 0x06           ;Fn 0x06: restart 30 API handler
kFnINT:     .EQU 0x07           ;Fn 0x07: restart 38 interrupt handler
kFnConIn:   .EQU 0x08           ;Fn 0x08: console input character
kFnConOut:  .EQU 0x09           ;Fn 0x09: console output character
;FnConISta: .EQU 0x0A           ;Fn 0x0A: console get input status
;FnConOSta: .EQU 0x0B           ;Fn 0x0B: console get output status
kFnIdle:    .EQU 0x0C           ;Fn 0x0C: Jump to idle handler
kFnTimer1:  .EQU 0x0D           ;Fn 0x0D: Jump to timer 1 handler
kFnTimer2:  .EQU 0x0E           ;Fn 0x0E: Jump to timer 2 handler
kFnTimer3:  .EQU 0x0F           ;Fn 0x0F: Jump to timer 3 handler
kFnDev1In:  .EQU 0x10           ;Fn 0x10: device 1 input
kFnDev1Out: .EQU 0x11           ;Fn 0x11: device 1 output
kFnDev2In:  .EQU 0x12           ;Fn 0x12: device 2 input
FnDev2Out:  .EQU 0x13           ;Fn 0x13: device 2 output
kFnDev3In:  .EQU 0x14           ;Fn 0x14: device 3 input
FnDev3Out:  .EQU 0x15           ;Fn 0x15: device 3 output
FnDev4In:   .EQU 0x16           ;Fn 0x16: device 4 input
FnDev4Out:  .EQU 0x17           ;Fn 0x17: device 4 output
FnDev5In:   .EQU 0x18           ;Fn 0x18: device 5 input
FnDev5Out:  .EQU 0x19           ;Fn 0x19: device 5 output
FnDev6In:   .EQU 0x1A           ;Fn 0x1A: device 6 input
FnDev6Out:  .EQU 0x1B           ;Fn 0x1B: device 6 output
#ENDIF


#IFREQUIRED aDelayInMS
; API 0x0A: Delay in milliseconds
;   On entry: A = Number of milliseconds delay
;   On exit:  AF BC DE HL IX IY I AF' BC' DE' HL' preserved
aDelayInMS
            PUSH AF
            PUSH BC
            PUSH DE
            PUSH HL
            LD   D,0
            LD   E,A
            LD   C, 0x0A        ;API 0x0A
            RST  0x30           ;  = Delay in milliseconds
            POP  HL
            POP  DE
            POP  BC
            POP  AF
            RET
#ENDIF


#IFREQUIRED aOutputSysMsg
; API 0x0B: Output system message
;  On entry:  A = Message number (0 to n)
;  On exit:   AF BC DE HL IX IY I AF' BC' DE' HL' preserved
aOutputSysMsg
            PUSH AF
            PUSH BC
            PUSH DE
            PUSH HL
            LD   C,0x0B         ;API 0x0B
            RST  0x30           ;  = Output system message
            POP  HL
            POP  DE
            POP  BC
            POP  AF
            RET
; Message numbers
kMsgNull:   .EQU 0x00           ;Null message
kMsgProdID: .EQU 0x01           ;"Small Computer Monitor "
kMsgDevice: .EQU 0x02           ;"Devices detected:"
kMsgAbout:  .EQU 0x03           ;About SCMonitor inc version
kMsgDevLst: .EQU 0x04           ;Device list
kMsgMonFst  .EQU 0x20           ;First monitor message
kMsgBadCmd: .EQU kMsgMonFst+0   ;"Bad command"
kMsgBadPar: .EQU kMsgMonFst+1   ;"Bad parameter"
kMsgSyntax: .EQU kMsgMonFst+2   ;"Syntax error"
kMsgBPSet:  .EQU kMsgMonFst+3   ;"Breakpoint set"
kMsgBPClr:  .EQU kMsgMonFst+4   ;"Breakpoint cleared"
kMsgBPFail: .EQU kMsgMonFst+5   ;"Unable to set breakpoint here"
kMsgHelp:   .EQU kMsgMonFst+6   ;Help text
kMsgNotAv:  .EQU kMsgMonFst+7   ;"Feature not included"
kMsgReady:  .EQU kMsgMonFst+8   ;"Ready"
kMsgFileEr: .EQU kMsgMonFst+9   ;"File error"
#ENDIF


#IFREQUIRED aReadJumpTab
; API 0x0C: Read system jump table entry
;   On entry: A = Entry number (0 to n)
;   On exit:  DE = Address of function
;             AF BC HL IX IY I AF' BC' DE' HL' preserved
; Some system functions, such as console in and console out, are 
; redirected through a jump table. By claiming a jump table entry the
; function can be handled by any required code. This might allow
; swapping output to a different device, such as a printer.
aReadJumpTab
            PUSH AF
            PUSH BC
            PUSH HL
            LD   C,0x0C         ;API 0x0C
            RST  0x30           ;  = Read jump table entry
            POP  HL
            POP  BC
            POP  AF
            RET
; Jump table entry numbers defined in aClaimJumpTab (above)
#ENDIF


#IFREQUIRED aSelectConDev
; API 0x0D: Select console I/O device
;   On entry: A = New console device number (1 to n)
;   On exit:  AF BC DE HL IX IY I AF' BC' DE' HL' preserved
; Select both input and output device
aSelectConDev:
            PUSH AF
            PUSH BC
            PUSH DE
            PUSH HL
            LD   C,0x0D         ;API 0x0D
            RST  0x30           ;  = Select console I/O device
            POP  HL
            POP  DE
            POP  BC
            POP  AF
            RET
#ENDIF


#IFREQUIRED aSelectConIn
; API 0x0E: Select console input device
;   On entry: A = New console device number (1 to n)
;   On exit:  AF BC DE HL IX IY I AF' BC' DE' HL' preserved
; Select input device only
aSelectConIn:
            PUSH AF
            PUSH BC
            PUSH DE
            PUSH HL
            LD   C,0x0E         ;API 0x0E
            RST  0x30           ;  = Select console input device
            POP  HL
            POP  DE
            POP  BC
            POP  AF
            RET
#ENDIF


#IFREQUIRED aSelectConOut
; API 0x0F: Select console output device
;   On entry: A = New console device number (1 to n)
;   On exit:  AF BC DE HL IX IY I AF' BC' DE' HL' preserved
; Select output device only
aSelectConOut:                  
            PUSH AF
            PUSH BC
            PUSH DE
            PUSH HL
            LD   C,0x0F         ;API 0x0F
            RST  0x30           ;  = Select console output device
            POP  HL
            POP  DE
            POP  BC
            POP  AF
            RET
#ENDIF


#IFREQUIRED aInputFromDev
; API 0x10: Input from specified console device
;   On entry: E = Console device number (1 to n)
;   On exit:  A = Character input 9if there is one ready)
;             NZ flagged if character has been input
;             BC DE HL IX IY I AF' BC' DE' HL' preserved
aInputFromDev:
            PUSH BC
            PUSH DE
            PUSH HL
            LD   C,0x10         ;API 0x10
            RST  0x30           ;  = Input from specified device
            POP  HL
            POP  DE
            POP  BC
            RET
#ENDIF


#IFREQUIRED aOutputToDev
; API 0x11: Output to specified console device
;   On entry: A = Character to be output
;             E = Console device number (1 to n)
;   On exit:  AF BC DE HL IX IY I AF' BC' DE' HL' preserved
aOutputToDev:
            PUSH AF
            PUSH BC
            PUSH DE
            PUSH HL
            LD   C,0x11         ;API 0x11
            RST  0x30           ;  = Output to specified device
            POP  HL
            POP  DE
            POP  BC
            POP  AF
            RET
#ENDIF


#IFREQUIRED aPollEvents
; API 0x12: Poll idle events
;   On entry: No parameters required
;   On exit:  AF BC DE HL IX IY I AF' BC' DE' HL' preserved
aPollEvents:
            PUSH AF
            PUSH BC
            PUSH DE
            PUSH HL
            LD   C,0x12         ;API 0x12
            RST  0x30           ;  = Poll idle events
            POP  HL
            POP  DE
            POP  BC
            POP  AF
            RET
#ENDIF


#IFREQUIRED aConfigEvents
; API 0x13: Configure idle events
;   On entry: A = Configuration:
;                 0 = Off (just execute RET instruction)
;                 1 = Software generated timer events
;                 2+ = Future expansion
;   On exit:  AF BC DE HL IX IY I AF' BC' DE' HL' preserved
aConfigEvents
            PUSH AF
            PUSH BC
            PUSH DE
            PUSH HL
            LD   C,0x13         ;API 0x13
            RST  0x30           ;  = Configure idle events
            POP  HL
            POP  DE
            POP  BC
            POP  AF
            RET
#ENDIF


#IFREQUIRED aSet1msTimer
; API 0x14: Set up 1 ms timer (timer 1)
;   On entry: A = Time period in units of 1 ms
;             DE = Address of timer event handler
;   On exit:  AF BC DE HL IX IY I AF' BC' DE' HL' preserved
aSet1msTimer:
            PUSH AF
            PUSH BC
            PUSH DE
            PUSH HL
            LD   C,0x14         ;API 0x14
            RST  0x30           ;  = Set up 1 ms timer 1
            POP  HL
            POP  DE
            POP  BC
            POP  AF
            RET
#ENDIF


#IFREQUIRED aSet10msTimer
; API 0x15: Set up 10 ms timer (timer 2)
;   On entry: A = Time period in units of 10 ms
;             DE = Address of timer event handler
;   On exit:  AF BC DE HL IX IY I AF' BC' DE' HL' preserved
aSet10msTimer:
            PUSH AF
            PUSH BC
            PUSH DE
            PUSH HL
            LD   C,0x15         ;API 0x15
            RST  0x30           ;  = Set up 10 ms timer 2
            POP  HL
            POP  DE
            POP  BC
            POP  AF
            RET
#ENDIF


#IFREQUIRED aSet100msTimer
; API 0x16: Set up 100 ms timer (timer 3)
;   On entry: A = Time period in units of 100 ms
;             DE = Address of timer event handler
;   On exit:  AF BC DE HL IX IY I AF' BC' DE' HL' preserved
aSet100msTimer:
            PUSH AF
            PUSH BC
            PUSH DE
            PUSH HL
            LD   C,0x16         ;API 0x16
            RST  0x30           ;  = Set up 100 ms timer 3
            POP  HL
            POP  DE
            POP  BC
            POP  AF
            RET
#ENDIF


#IFREQUIRED aInitOutPort
; API 0x17: Initialise output port
;   On entry: A = Output port address
;   On exit:  A = Output port data byte (which will be zero)
;             BC DE HL IX IY I AF' BC' DE' HL' preserved
aInitOutPort:
            PUSH BC
            PUSH DE
            PUSH HL
            LD   C,0x17         ;API 0x17
            RST  0x30           ;  = Initialise output port
            POP  HL
            POP  DE
            POP  BC
            RET
#ENDIF


#IFREQUIRED aWriteOutPort
; API 0x18: Write output port data
;   On entry: A = Output data byte
;   On exit:  A = Output port data
;             BC DE HL IX IY I AF' BC' DE' HL' preserved
aWriteOutPort:
            PUSH BC
            PUSH DE
            PUSH HL
            LD   C,0x18         ;API 0x18
            RST  0x30           ;  = Write output port data
            POP  HL
            POP  DE
            POP  BC
            RET
#ENDIF


#IFREQUIRED aReadOutPort
; API 0x19: Read output port data
;   On entry: no parameters required
;   On exit:  A = Output port data
;             BC DE HL IX IY I AF' BC' DE' HL' preserved
aReadOutPort:
            PUSH BC
            PUSH DE
            PUSH HL
            LD   C,0x19         ;API 0x19
            RST  0x30           ;  = Read output port data
            POP  HL
            POP  DE
            POP  BC
            RET
#ENDIF


#IFREQUIRED aTestOutBit
; API 0x1A: Test output port bit
;   On entry: A = Bit number 0 to 7
;   On exit:  A = 0 and Z flagged if bit low
;             A !=0 and NZ flagged if bit high
;             BC DE HL IX IY I AF' BC' DE' HL' preserved
aTestOutBit:
            PUSH BC
            PUSH DE
            PUSH HL
            LD   C,0x1A         ;API 0x1A
            RST  0x30           ;  = Test output port bit
            POP  HL
            POP  DE
            POP  BC
            RET
#ENDIF


#IFREQUIRED aSetOutputPortBit
; API 0x1B: Set output port bit
;   On entry: A = Bit number 0 to 7
;   On exit:  A = Output port data
;             BC DE HL IX IY I AF' BC' DE' HL' preserved
aSetOutBit:
            PUSH BC
            PUSH DE
            PUSH HL
            LD   C,0x1B         ;API 0x1B
            RST  0x30           ;  = Set output port bit
            POP  HL
            POP  DE
            POP  BC
            RET
#ENDIF


#IFREQUIRED aClearOutputPortBit
; API 0x1C: Clear output port bit
;   On entry: A = Bit number 0 to 7
;   On exit:  A = Output port data
;             BC DE HL IX IY I AF' BC' DE' HL' preserved
aClearOutBit:
            PUSH BC
            PUSH DE
            PUSH HL
            LD   C,0x1C         ;API 0x1C
            RST  0x30           ;  = Clear output port bit
            POP  HL
            POP  DE
            POP  BC
            RET
#ENDIF


#IFREQUIRED aInvertOutBit
; API 0x1D: Invert output port bit
;   On entry: A = Bit number 0 to 7
;   On exit:  A = Output port data
;             BC DE HL IX IY I AF' BC' DE' HL' preserved
aInvertOutBit:
            PUSH BC
            PUSH DE
            PUSH HL
            LD   C,0x1D         ;API 0x1D
            RST  0x30           ;  = Invert output port bit
            POP  HL
            POP  DE
            POP  BC
            RET
#ENDIF


#IFREQUIRED aInitInPort
; API 0x1E: Initialise input port
;   On entry: A = Input port address
;   On exit:  A = Input port data byte 
;             BC DE HL IX IY I AF' BC' DE' HL' preserved
aInitInPort:
            PUSH BC
            PUSH DE
            PUSH HL
            LD   C,0x1E         ;API 0x1E
            RST  0x30           ;  = Initialise input port
            POP  HL
            POP  DE
            POP  BC
            RET
#ENDIF


#IFREQUIRED aReadInPort
; API 0x1F: Read input port data
;   On entry: no parameters required
;   On exit:  A = Input port data
;             BC DE HL IX IY I AF' BC' DE' HL' preserved
aReadInPort:
            PUSH BC
            PUSH DE
            PUSH HL
            LD   C,0x1F         ;API 0x1F
            RST  0x30           ;  = Read intput port data
            POP  HL
            POP  DE
            POP  BC
            RET
#ENDIF


#IFREQUIRED aTestInBit
; API 0x20: Test input port bit
;   On entry: A = Bit number 0 to 7
;   On exit:  A = 0 and Z flagged if bit low
;             A !=0 and NZ flagged if bit high
;             BC DE HL IX IY I AF' BC' DE' HL' preserved
aTestInBit:
            PUSH BC
            PUSH DE
            PUSH HL
            LD   C,0x20         ;API 0x20
            RST  0x30           ;  = Test input port bit
            POP  HL
            POP  DE
            POP  BC
            RET
#ENDIF


#IFREQUIRED aSetBaudRate
; API 0x21: Set baud rate
;  On entry:  A = Device identifier (0x01 to 0x06, or 0x0A to 0x0B)
;             E = Baud rate code 
;   On exit:  IF successful: (ie. valid device and baud code)
;               A != 0 and NZ flagged
;             BC DE HL IX IY I AF' BC' DE' HL' preserved
aSetBaudRate:
            PUSH BC
            PUSH DE
            PUSH HL
            LD   C,0x21         ;API 0x21
            RST  0x30           ;  = Set baud rate
            POP  HL
            POP  DE
            POP  BC
            RET
#ENDIF


#IFREQUIRED aExecuteCL
; API 0x22: Execute command line
;  On entry:  DE = Start of command string terminated in Null
;  On exit:   If command handled (blank line or executed command):
;               A = 0x00 and Z flagged
;             If command not handled:
;               A = 0xFF and NZ flagged
;             No register contents preserved
; Offer string to command line interpreter
; If found the command is executed before return. HL points to
; start of parameter string when command code entered.
aExecuteCL:
            LD   C,0x22         ;API 0x22
            RST  0x30           ;  = Execute command line
            RET
#ENDIF


#IFREQUIRED aGetPtrToCL
; API 0x23: Get pointer to current position in command line string
;   On entry: No parameters required
;   On exit:  DE = Address of string typically in command line
;             AF BC HL IX IY I AF' BC' DE' HL' preserved
; Used by monitor command files to read command parameters
aGetPtrToCL:
            PUSH AF
            PUSH BC
            PUSH HL
            LD   C,0x23         ;API 0x23
            RST  0x30           ;  = Get pointer to command line
            POP  HL
            POP  BC
            POP  AF
            RET
#ENDIF


#IFREQUIRED aSkipDelim
; API 0x24: Skip deliminaters in command line
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
aSkipDelim:
            PUSH BC
            PUSH HL
            LD   C,0x24         ;API 0x24
            RST  0x30           ;  = Skip delimiter in command line
            POP  HL
            POP  BC
            RET
#ENDIF


#IFREQUIRED aSkipNonDelim
; API 0x25: Skip non-deliminaters in input line
;   On entry: DE = Start address in input line
;   On exit:  A = Character at returned address
;             DE = Address of first non-delimiter character
;             BC HL IX IY preserved
; Delimiters are spaces or tabs (actually any control character other than null)
; Input line must be null terminated
; The return address can be that of the null terminator
aSkipNonDelim:
            PUSH BC
            PUSH HL
            LD   C,0x25         ;API 0x25
            RST  0x30           ;  = Skip delimiter in command line
            POP  HL
            POP  BC
            RET
#ENDIF


#IFREQUIRED aGetHexParam
; API 0x26: Get hex word/byte from input line
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
; If a non-hex character is encountered before a delimiter or null an 
; error is reported.
aGetHexParam:
            PUSH BC
            LD   C,0x26         ;API 0x26
            RST  0x30           ;  = Get hex parameter from input line
            POP  BC
            RET
#ENDIF


#IFREQUIRED aGetConDevices
; API 0x27: Get current console device numbers
;   On entry: No parameters required
;   On exit:  D = Current console output device number
;             E = Current console input device number
;   On exit:  AF BC HL IX IY I AF' BC' DE' HL' preserved
aGetConDevices:
            PUSH AF
            PUSH BC
            PUSH HL
            LD   C,0x27         ;API 0x27
            RST  0x30           ;  = Get current console device numbers
            POP  HL
            POP  BC
            POP  AF
            RET
#ENDIF


#IFREQUIRED aGetTopOfMem
; API 0x28: Get top of free memory
;   On entry: No parameters required
;   On exit:  DE = Top of free memory
;             AF BC HL IX IY I AF' BC' DE' HL' preserved
aGetTopOfMem:
            PUSH AF
            PUSH BC
            PUSH HL
            LD   C,0x28         ;API 0x28
            RST  0x30           ;  = Get top of free memory
            POP  HL
            POP  BC
            POP  AF
            RET
#ENDIF


#IFREQUIRED aSetTopOfMem
; API 0x29: Set top of free memory
;   On entry: DE = Top of free memory
;   On exit:  AF BC DE HL IX IY I AF' BC' DE' HL' preserved
aSetTopOfMem:
            PUSH AF
            PUSH BC
            PUSH DE
            PUSH HL
            LD   C,0x29         ;API 0x29
            RST  0x30           ;  = Set top of free memory
            POP  HL
            POP  BC
            POP  DE
            POP  AF
            RET
#ENDIF


; **********************************************************************
; **  Variables
; **********************************************************************

            .DATA               ;Data section

; No variables used













