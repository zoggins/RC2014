; **********************************************************************
; **  Console support (input and output)        by Stephen C Cousins  **
; **********************************************************************

; This module handles console input and output. The console is normally
; a serial terminal or terminal emulation program.
;
; Public functions provided
;   ConInitialise         Initialise console module
;   InputInsert           Insert character to character waiting buffer
;   InputMore             Ask if user wants to output more
;   InputPreview          Await one character but leave it to be input
;   InputChar             Input character from console input device
;   InputBufConvUpper     Convert contents of input buffer to upper case
;   InputLineEdit         Input line where existing line is replaced
;   InputLine             Input line to system line buffer
;   InputLineTo           Input line to specified line buffer
;   InputStatus           Check if input character is available
;   OutputChar            Output character to console output device
;   OutputNewLine         Output new line character(s)
;   OutputZString         Output a zero (null) terminated string


; **********************************************************************
; **  Public functions                                                **
; **********************************************************************

            .CODE

; Console: Initialise console module
;   On entry: No parameters required
;   On exit:  BC DE HL IX IY I AF' BC' DE' HL' preserved
ConInitialise:
            XOR  A
            LD   (iConInChar),A
            RET


; **********************************************************************
; **  Input form console / input device, typically a terminal         **
; **********************************************************************


; Console input: Insert character into character waiting buffer
;   On entry: A = ASCII character
;   On exit:  A BC DE HL IX IY I AF' BC' DE' HL' preserved
InputInsert:
            LD   (iConInChar),A ;Store as character waiting
            RET


; Console input: Ask if user wants to output more
;   On entry: No parameters required
;   On exit:  A = ASCII character
;             BC DE HL IX IY I AF' BC' DE' HL' preserved
; No prompt is given, it just waits until character is available. 
; If the character is the request for 'more' character (eg. Return) the 
; routine exits with the character in A and the Z flag set. 
; If the character is Escape then the routine exits with A = 0 and
; NZ flagged.
; Otherwise the character is stored in iConInChar and will be picked up 
; on next call to InputGetWaiting.
InputMore:  CALL IdlePoll       ;Process idle events
            CALL JpConIn        ;Wait for input character
            JR   Z,InputMore    ;Repeat until we get a character
            CP   kLinefeed      ;More (linefeed) ?
            JR   Z,InputMore    ;Ignore line feed
;           RET  Z              ;Yes, so return with Z flagged
            CP   kReturn        ;More (carriage return) ? 
            RET  Z              ;Yes, so return with Z flagged
            CP   kEscape        ;Escape character ?
            JR   Z,@Escape      ;Yes, so skip
            LD   (iConInChar),A ;Store as character waiting
            RET                 ;  and return with NZ flagged
@Escape:    XOR  A              ;Clear A
            CP   1              ;Flag NZ as not a request for more
            RET


; Console input: Await one character but leave it waiting to be input
;   On entry: No parameters required
;   On exit:  A = ASCII character
;             BC DE HL IX IY I AF' BC' DE' HL' preserved
InputPreview:
            LD   A,(iConInChar) ;Read from character waiting buffer
            OR   A              ;Is there a character waiting?
            RET  NZ             ;If character is waiting then return it
@Wait:      CALL JpConIn        ;Wait for input character
            JR   NZ,@GotOne     ;Skip if we get a character
            CALL IdlePoll       ;Process idle events
            JR   @Wait          ;Repeat until we get a character
@GotOne:    LD   (iConInChar),A ;Store as character waiting
            RET


; Console input: Input character from console input device
;   On entry: No parameters required
;   On exit:  A = ASCII character
;             BC DE HL IX IY I AF' BC' DE' HL' preserved
; Waits until character is available
InputChar:
            LD   A,(iConInChar) ;Read from character waiting buffer
            OR   A              ;Is there a character waiting?
            JR   Z,@Input       ;No, so go get new character..
; Return character which is waiting to be read
            PUSH AF             ;Preserve character
            XOR  A              ;Flush waiting buffer by
            LD   (iConInChar),A ;  storing zero in to
            POP  AF             ;Restore character 
            RET
; Get new character from console input device
@Input:     CALL JpConIn        ;Look for input character
            RET  NZ             ;Exit if we have a character
            CALL IdlePoll       ;Process idle events
            JR   @Input         ;No character so keep looking


; Console input: Check if input character is available
;   On entry: No parameters required
;   On exit:  NZ flagged if character is available
;             BC DE HL IX IY I AF' BC' DE' HL' preserved
; Does not wait for a character to become available
InputStatus:
            LD   A,(iConInChar) ;Read from character waiting buffer
            OR   A              ;Is there a character waiting?
            RET  NZ             ;If character is waiting return
            CALL JpConIn        ;Look for input character
            RET  Z              ;No character to exit
            LD   (iConInChar),A ;Store character to read later
            RET


; Console input: Convert contents of input buffer to upper case
;   On entry: No parameters required
;   On exit:  AF BC DE HL IX IY I AF' BC' DE' HL' preserved
; One exception is the character following an apostrophe
InputBufConvUpper:
            PUSH AF
            PUSH HL
            LD   HL,(iConInBuf) ;Get start of current input buffer
@Loop:      LD   A,(HL)         ;Get character from input buffer
            OR   A              ;Null string?
            JR   Z,@Done        ;Yes, so we're done here
; Do not convert character immediately following an apostrophe
            CP   kApostroph     ;Apostrophe?
            JR   NZ,@NotApos    ;No, so skip
            INC  HL             ;Skip apostrophe
            LD   A,(HL)         ;Get character from input buffer
            OR   A              ;Null string?
            JR   Z,@Done        ;Yes, so we're done here
            JR   @Next          ;Go to next character
@NotApos:
; Convert this character to upper case
            CALL ConvertCharToUCase
            LD   (HL),A         ;Write upper case char to string
@Next:      INC  HL             ;Point ot next character in string
            JR   @Loop          ;Loop until end of string
@Done:      POP  HL
            POP  AF
            RET


; Console input: Input line to system line buffer
;   On entry: No parameters required
;   On exit:  DE = Start location of buffer
;             A = Number of characters in buffer
;             Z flagged if no characters in bufffer
;             BC HL IX IY I AF' BC' DE' HL' preserved
;             Interrupts enabled during this call ???
; The number of characters returned does not include the null terminator.
InputLine:  LD   DE,kInputBuff  ;Start of system line buffer
            XOR  A
            LD   (DE),A         ;Clear input buffer
            LD   A,kInputSize-1 ;Length of system line buffer
            JP   InputLineNow   ;Input line
;           CALL InputLineNow   ;Input line
;           RET


#IFDEF      NOCHANCE
; Console input: Edit line in default string buffer
;   On entry: No parameters required
;   On exit:  DE = Start location of buffer
;             A = Number of characters in buffer
;             Z flagged if no characters in bufffer
;             BC HL IX IY I AF' BC' DE' HL' preserved
;             Interrupts enabled during this call ???
; The number of characters returned does not include the null terminator.
; DE points to a null terminated string to be edited
InputLineEdit:
            LD   DE,kInputBuff  ;Start of system line buffer
            CALL StrCopyToZ     ;Copy current string to input buffer
            LD   A,kInputSize-1 ;Length of system line buffer
            JP   InputLineNow   ;Input line
;           CALL InputLineNow   ;Input line
;           RET
#ENDIF


; Console input: Input line to user defined buffer
;   On entry: DE = Start of buffer
;             A = Size of input buffer in bytes
;   On exit:  A = Number of characters in input buffer
;             Z flagged if no characters in bufffer ???
;             BC DE HL IX IY I AF' BC' DE' HL' preserved
;             Interrupts enabled during this call ???
; Maximum buffer length 255 bytes.
; The buffer length includes the string termination character (null).
; The number of characters returned does not include the null terminator.
InputLineTo:
            PUSH AF
            XOR  A
            LD   (DE),A         ;Clear input buffer
            POP  AF
;           JP   InputLineNow   ;Input line


; Console input: Input or edit line at specified location 
;   On entry: DE = Start of buffer
;             A = Size of input buffer in bytes
;   On exit:  A = Number of characters in input buffer
;             Z flagged if no characters in bufffer ???
;             BC DE HL IX IY I AF' BC' DE' HL' preserved
;             Interrupts enabled during this call ???
; Maximum buffer length 255 bytes.
; The buffer length includes the string termination character (null).
; The number of characters returned does not include the null terminator.
InputLineNow:
            PUSH DE
            PUSH HL
            LD (iConInBuf),DE   ;Store start of buffer
            LD   L,A            ;Store end address of buffer lo byte
            DEC  L              ;Allow space for return character
            LD   H,E            ;Store start address of buffer lo byte
            ;XOR  A
            ;LD   (DE),A        ;Clear input buffer
; Check if we are overtyping an existing string
            LD   A,(DE)         ;Get first character in buffer
            OR   A              ;Null (zero)?
            JR   Z,@Input       ;Yes, so skip
; Output current string in buffer
@Loop1:     CALL OutputChar     ;Output character
            INC  DE             ;Point to next character
            LD   A,(DE)         ;Get character from buffer
            OR   A              ;Null (zero)?
            JR   NZ,@Loop1      ;No, so go output it
; Backspace to start of string
@Loop2:     LD   A,kBackspace   ;ASCII backspace
            CALL OutputChar     ;Output backspace
            DEC  DE             ;Back one character
            LD   A,E            ;Get start address of buffer lo byte
            CP   H              ;Start of buffer?
            JR   NZ,@Loop2      ;No, so go backspace again
; Input line to buffer
@Input:     CALL InputChar      ;Wait for input character
            BIT  7,A            ;Reject if bit 7 set
            JR   NZ,@Input
            CP   kEscape        ;Test if Escape character
            JR   Z,@Escape
            CP   kBackspace     ;Test if Delete character
            JR   Z,@Backspace
            CP   kReturn        ;Test if carriage return
            JR   Z,@Return
            CP   kSpace         ;Reject if control char
            JR   C,@Input
; Normal character (ASCII 32 to 126), consider edit mode
; If start of line and in edit mode, erase the line
            PUSH AF
            LD   A,E            ;Get start address of buffer lo byte
            CP   H              ;Start of buffer?
            JR   NZ,@EndErase   ;No, so skip
            LD   A,(DE)         ;Get first character in line
            OR   A              ;Anything to edit?
            JR   Z,@EndErase    ;No, so skip
; Erase string being edited
@Loop3:     LD   A,kSpace       ;ASCII space
            CALL OutputChar     ;Erase character from terminal
            XOR  A
            LD   (DE),A         ;Erase character from buffer
            INC  DE             ;Point to next character
            LD   A,(DE)         ;Get character from buffer
            OR   A              ;Null (zero)?
            JR   NZ,@Loop3      ;No, so go output it
@Loop4:     LD   A,kBackspace   ;ASCII backspace
            CALL OutputChar     ;Output backspace
            DEC  DE             ;Back one character
            LD   A,E            ;Get start address of buffer lo byte
            CP   H              ;Start of buffer?
            JR   NZ,@Loop4      ;No, so go backspace again
@EndErase:  POP  AF
; Normal character (ASCII 32 to 126), write to buffer
            LD   (DE),A         ;Store character in buffer
            LD   A,E            ;Get current address lo byte
            CP   L              ;Buffer full?
            JR   Z,@Input       ;Yes, so don't increment pointer
            LD   A,(DE)         ;No, so..
            CALL OutputChar     ;  echo character just input
            INC  DE             ;  and increment buffer pointer
            JR   @Input
; Escape character
@Escape:    CALL OutputNewLine  ;Output new line character(s)
            LD   A,kEscape
            CP   A              ;Set zero flag but with A = kEscape
            JR   @Exit
; Delete character
@Backspace: LD   A,E            ;Get start address of buffer lo byte
            CP   H              ;Start of buffer?
            JR   Z,@Input       ;Yes, so nothing to delete
            LD   A,kBackspace   ;ASCII backspace
            CALL OutputChar     ;Output backspace
            LD   A,kSpace       ;ASCII space
            CALL OutputChar     ;Output space
            LD   A,kBackspace   ;ASCII backspace
            CALL OutputChar     ;Output backspace
            DEC  DE             ;Decrement buffer pointer
            XOR  A
            LD   (DE),A         ;Mark end of string with null
            JR   @Input
; Carriage return
@Return:    XOR  A              ;Clear A to a null character (zero)
            LD   (DE),A         ;Store null to terminate string in buffer
            CALL OutputNewLine  ;Output new line character(s)
            LD   A,E            ;Calculate number of characters
            SUB  A,H            ;  in input buffer
@Exit:      POP  HL
            POP  DE
            RET


; **********************************************************************
; **  Output to console / output device, typically a terminal         **
; **********************************************************************


; Console output: Output character to console output device
;   On entry: A = Character to output
;   On exit:  AF BC DE HL IX IY I AF' BC' DE' HL' preserved
; This is the only place the actual new line codes (eg. CR/LF) are used
OutputChar:
            PUSH AF
            CP   kNewLine       ;New line character?
            JR   NZ,@NotNL      ;No, so skip
            LD   A,kReturn      ;Yes, so output physical new line
@Wait1:     CALL JpConOut       ;  to console..
            JR   Z,@Wait1
            LD   A,kLinefeed
@NotNL:
@Wait2:     CALL JpConOut       ;Output character to console
            JR   Z,@Wait2
@Exit:      POP  AF
            RET


; Console output: Output new line character(s)
;   On entry: No parameters
;   On exit:  A BC DE HL IX IY I AF' BC' DE' HL' preserved
; This is the only place the actual new line codes (eg. CR/LF) are used
OutputNewLine:
            PUSH AF
            LD   A,kNewLine     ;Get new line character
            CALL OutputChar     ;Output carriage return character
            POP  AF
            RET


; Console output: Output a zero (null) terminated string
;   On entry: DE= Start address of string
;   On exit:  DE= Address after null
;             AF BC HL IX IY I AF' BC' DE' HL' preserved
;             Interrupts enabled during this call
; Supports \n for new line
OutputZString:
            PUSH AF
@Next:      LD   A,(DE)         ;Get character from string
            INC  DE             ;Point to next character
            OR   A              ;Null terminator?
            JR   Z,@Finished    ;Yes, so we've finished
            CALL OutputChar     ;Output character
            JR   @Next          ;Go process next character
@Finished:  POP  AF
            RET


; **********************************************************************
; **  Private functions                                                **
; **********************************************************************


#IFNDEF     IncludeUtilities
; This function is normal provided by the Utilities module, but if this 
; build does not include Utilities then assemble the function here.
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


; **********************************************************************
; **  Private workspace (in RAM)                                      **
; **********************************************************************

            .DATA

iConInChar: .DB  0x00           ;Console input character waiting
iConInBuf:  .DW  0x0000         ;Console input buffer start


; **********************************************************************
; **  End of Console support module                                   **
; **********************************************************************













