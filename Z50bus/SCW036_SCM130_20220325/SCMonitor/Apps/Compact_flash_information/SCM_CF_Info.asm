; **********************************************************************
; **  Compact Flash Information                 by Stephen C Cousins  **
; **********************************************************************
;
; **  Written as a Small Computer Monitor App 
; **  www.scc.me.uk
;
; SCC  2018-06-02 : v0.4.1  Stable version
; SCC  2022-02-11 : v0.5.0  Added support for CF card at address CF_BASE
; SCC  2022-03-02 : v1.0.0  Minor tidy of source for v1.0 release
;
; **********************************************************************
;
; This App reads compact flash card identification information and 
; displays some of it.
;
; **********************************************************************

            .PROC Z80           ;SCWorkshop select processor
            .HEXBYTES 0x18      ;SCWorkshop Intel Hex output format

; Define target system
#DEFINE     GENERIC
;#DEFINE    Z280RC

; Define target's possible CF card addresses
CF_BASE1    .EQU 0x10           ;Base address = 0x10 (default for RC2014 and LiNC80)
CF_BASE2    .EQU 0x90           ;Base address = 0x90 (default for Z50Bus)
;CF_BASE    .EQU 0xC0           ;Base address = 0xC0 (default for Z280RC)


; **********************************************************************
; **  Memory map
; **********************************************************************

CodeORG:    .EQU $8000          ;Loader code runs here
DataORG:    .EQU $9000          ;Start of data section
Buffer:     .EQU $9100          ;Data load address


; **********************************************************************
; **  Constants
; **********************************************************************

; none


; **********************************************************************
; **  Code library usage
; **********************************************************************

; SCMonAPI functions used
#REQUIRES   aOutputText
#REQUIRES   aOutputNewLine
#REQUIRES   aOutputChar

; Utility functions used
#REQUIRES   uOutputHexPref
#REQUIRES   uOutputHexByte
#REQUIRES   uOutputHexWord
#REQUIRES   uOutputDecWord
#REQUIRES   uFindString

; Compact flash functions used
#REQUIRES   cfDiagnose
#REQUIRES   cfInfo
#REQUIRES   cfRead
#REQUIRES   cfSize
; All other compact flash functions are included by default


; **********************************************************************
; **  Establish memory sections
; **********************************************************************

            .DATA
            .ORG  DataORG       ;Establish start of data section

            .CODE
            .ORG  CodeORG       ;Establish start of code section


; **********************************************************************
; **  Main program code
; **********************************************************************

; Initialise
            CALL cfInit         ;Initialise Compact Flash functions

; Output program details
            LD   DE,About       ;Text: "Compact flash card info..."
            CALL aOutputText
            CALL aOutputNewLine ;Output new line

            CALL aOutputNewLine ;Output new line

; Test if compact flash present at first address
            LD   L,CF_BASE1
            CALL @CardAdd
            JR   NZ,@Err1       ;Device not found so go try next address
            CALL cfTstPres      ;Test if compact flash card is present
            JR   Z,@Start       ;Present, so go format it
@Err1:      CALL ReportErr2     ;Report error and exit program
            CALL aOutputNewLine ;Output new line

; Test if compact flash present at second address
            LD   L,CF_BASE2
            CALL @CardAdd
            JR   NZ,@Err2       ;Device not found so go try next address
            CALL cfTstPres      ;Test if compact flash card is present
            JR   Z,@Start       ;Present, so go format it
@Err2:      JP   ReportErr2     ;Report error and exit program

; Output card address and try to initialise cf code for specified adddress
@CardAdd:   LD   DE,CardAt
            CALL aOutputText    ;Output "Card at address "
            LD   A,L
            CALL uOutputHexByte ;Output address in hex
            LD   A,':'
            CALL aOutputChar    ;Output ':'
            LD   A,' '
            CALL aOutputChar    ;Output ' '
            LD   A,L            ;First try this device address
            JP  cfInit          ;Initialise Compact Flash / functions
;           CALL cfInit         ;Initialise Compact Flash / functions
;           RET

@Start:     CALL aOutputNewLine ;Output new line

; Get Compact flash identification info
            LD   HL,Buffer      ;Destination address for data read
            CALL cfInfo         ;Read CF identification info
            JP   NZ,ReportErr   ;Report error and exit program

; Display results -> Number of sectors on card
            LD   DE,NumSectors  ;Test: "Number of sectors on card: "
            CALL aOutputText
            CALL uOutputHexPref ;Output '$' (or whatever)
            LD   DE,(Buffer+14)
            CALL uOutputHexWord ;Output most significant word
            LD   DE,(Buffer+16)
            CALL uOutputHexWord ;Output least significant word
            CALL aOutputNewLine ;Output new line

; Display results -> Card size 
            LD   DE,CardSize    ;Text: "Card size: "
            CALL aOutputText
            LD   DE,(Buffer+14) ;Number of sectors hi word
            LD   HL,(Buffer+16) ;Number of sectors lo word
            CALL cfSize         ;Get size in DE, units in A
            CALL uOutputDecWord ;Output decimal word DE
            CALL aOutputChar
            LD   A,'B'          ;Get Bytes character
            CALL aOutputChar
            CALL aOutputNewLine ;Output new line

            CALL aOutputNewLine ;Output new line

; Display results -> Model details
            LD   DE,Model       ;Text: "Card model: "
            CALL aOutputText
            LD   A,20           ;Number of character pairs
            LD   DE,Buffer+54   ;Start of text
            CALL TextSwap       ;Output model text
            CALL aOutputNewLine ;Output new line

; Display results -> Serial number
            LD   DE,Serial      ;Text: "Serial number: "
            CALL aOutputText
            LD   A,20           ;Number of characters
            LD   DE,Buffer+20   ;Start of text
            CALL Text           ;Output model text
            CALL aOutputNewLine ;Output new line

; Display results -> Firmware version
            LD   DE,Version     ;Text: "Firmware version: "
            CALL aOutputText
            LD   A,4            ;Number of character pairs
            LD   DE,Buffer+46   ;Start of text
            CALL TextSwap       ;Output model text
            CALL aOutputNewLine ;Output new line

            CALL aOutputNewLine ;Output new line

; Display results -> Default number of cylinders
            LD   DE,Cylinders   ;Text: "... cylinders: "
            LD   HL,Buffer+2    ;Location of data word
            CALL Parameter      ;Output parameter

; Display results -> Default number of heads
            LD   DE,Heads       ;Text: "... headss: "
            LD   HL,Buffer+6    ;Location of data word
            CALL Parameter      ;Output parameter

; Display results -> Default number of sectors per track
            LD   DE,Sectors     ;Text: "... sectors: "
            LD   HL,Buffer+12   ;Location of data word
            CALL Parameter      ;Output parameter

#IFDEF      NOCHANCE
; Display results -> Number of unformated bytes per sector
; Code excluded as this value is now considered obsolete
; and does not always return sensible numbers
            LD   DE,Bytes       ;Location of message
            LD   HL,Buffer+10   ;Location of data word
            CALL Parameter      ;Output parameter
#ENDIF

            CALL aOutputNewLine ;Output new line

; Display results -> Compact Flash diagnostic test result
            LD   DE,Diagnose
            CALL aOutputText    ;Output "Diagnostic... "
            CALL cfDiagnose     ;Run diagnostics and return error code
            JR   NZ,@Failed     ;Did diagnostic pass?
            LD   DE,Passed      ;Passed ...
            CALL aOutputText    ;Output "Passed... "
            JR   @EndDiag
@Failed:    LD   DE,Failed      ;Failed ...
            CALL aOutputText    ;Output "Failed... "
            CALL uOutputHexPref ;Output hex prefix
            CALL uOutputHexByte ;Output result as hex byte
@EndDiag:   CALL aOutputNewLine ;Output new line

            RET

ReportErr:  CALL aOutputNewLine
ReportErr2: CALL cfGetError     ;Get error number
            LD   DE,cfErrMsgs   ;Point to list of error messages
            CALL uFindString    ;Find error message string
            CALL aOutputText    ;Output message at DE
            CALL aOutputNewLine ;Output new line
            RET


; **********************************************************************
; **  Messages
; **********************************************************************

About:      .DB  "Compact flash card information v1.1 by Stephen C Cousins",0
NumSectors: .DB  "Number of sectors on card: ",0
CardAt:     .DB  "Card at address $",0
CardSize:   .DB  "Card size: ",0
Model:      .DB  "Card model:       ",0
Serial:     .DB  "Serial number:    ",0
Version:    .DB  "Firmware version: ",0
Cylinders:  .DB  "Default number of cylinders:  ",0
Heads:      .DB  "Default number of heads:      ",0
Sectors:    .DB  "Default sectors per track:    ",0
Diagnose:   .DB  "Card's self diagnostic test ",0
Passed:     .DB  "passed",0
Failed:     .DB  "failed: code ",0


; **********************************************************************
; **  Support functions
; **********************************************************************

; Output parameter (string plus hex word)
Parameter:  PUSH HL
            CALL aOutputText
            CALL uOutputHexPref ;Output '$' (or whatever)
            POP  HL
            LD   E,(HL)         ;Get parameter address...
            INC  HL
            LD   D,(HL)
            CALL uOutputHexWord ;Output hex parameter value
            CALL aOutputNewLine ;Output new line
            RET


; Output text (at DE) length (A)
Text:       PUSH AF
            PUSH BC
            PUSH DE
            LD   B,A            ;Number of characters 
            LD   A,kQuote       ;Quotation mark
            CALL aOutputChar
@Loop:      LD   A,(DE)         ;Get character from text
            CALL aOutputChar
            INC  DE             ;Point to next character
            DJNZ @Loop
            LD   A,kQuote       ;Quotation mark
            CALL aOutputChar
            POP  DE
            POP  BC
            POP  AF
            RET


; Output text (at DE) number of character pairs (A)
; Character order swapped in each word
TextSwap:   PUSH AF
            PUSH BC
            PUSH DE
            LD   B,A            ;Number of characters 
            LD   A,kQuote       ;Quotation mark
            CALL aOutputChar
@Loop:      INC  DE
            LD   A,(DE)         ;Get first CharOut of pair
            DEC  DE
            CALL aOutputChar
            LD   A,(DE)         ;Get second character of pair
            CALL aOutputChar
            INC  DE             ;Point to next character pair
            INC  DE
            DJNZ @Loop
            LD   A,kQuote       ;Quotation mark
            CALL aOutputChar
            POP  DE
            POP  BC
            POP  AF
            RET


; **********************************************************************
; **  Includes
; **********************************************************************

#INCLUDE    ..\_CodeLibrary\SCMonitor_API.asm
#INCLUDE    ..\_CodeLibrary\Utilities.asm
#INCLUDE    ..\_CodeLibrary\CompactFlash.asm


; **********************************************************************
; **  Variables
; **********************************************************************

            .DATA

; No variables used

            .END









