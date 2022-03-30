; **********************************************************************
; **  Compact Flash Test                        by Stephen C Cousins  **
; **********************************************************************
;
; **  Written as a Small Computer Monitor App 
; **  www.scc.me.uk
;
; SCC  2018-06-02 : v0.4.1  Stable version
; SCC  2022-02-11 : v0.5.0  Added support for CF card at address CF_BASE
; SCC  2022-03-02 : v1.0.0  Minor tidy of source for v1.0 release
; SCC  2022-03-02 : v1.1.0  CF card I/O address set at runtime
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
DataORG:    .EQU $8F00          ;Start of data section
Buffer:     .EQU $9000          ;Data load address


; **********************************************************************
; **  Constants
; **********************************************************************

; none


; **********************************************************************
; **  Code library usage
; **********************************************************************

; SCMonitor API functions used
#REQUIRES   aOutputText
#REQUIRES   aOutputNewLine
#REQUIRES   aOutputChar
#REQUIRES   aInputChar
#REQUIRES   aInputStatus

; Utility functions used
#REQUIRES   uOutputHexPref
#REQUIRES   uOutputHexByte
#REQUIRES   uOutputHexWord
#REQUIRES   uOutputDecWord
#REQUIRES   uFindString

; Compact flash functions used
#REQUIRES   cfDiagnose
;#REQUIRES  cfFormat
#REQUIRES   cfInfo
#REQUIRES   cfRead
#REQUIRES   cfSize
#REQUIRES   cfVerify
;#REQUIRES  cfVerifyF
#REQUIRES   cfWrite
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
            LD   DE,About       ;Pointer to error message
            CALL aOutputText    ;Output "Compact flash card test..."
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
            LD   DE,NumSectors
            CALL aOutputText    ;Output "Number of sectors on card: "
            CALL uOutputHexPref ;Output '$' prefix (or whatever)
            LD   DE,(Buffer+14)
            LD   (iSize+2),DE   ;Store as card size MSW
            CALL uOutputHexWord ;Output most significant word
            LD   DE,(Buffer+16)
            LD   (iSize+0),DE   ;Store as card size LSW
            CALL uOutputHexWord ;Output least significant word
            CALL aOutputNewLine

; Adjust end sector number which needs to be 3 less than total as we 
; test in batches of 4 sectors
            XOR  A              ;Clear carry flag
            LD   HL,(iSize+0)
            LD   DE,3
            SBC  HL,DE          ;Subtract 3
            LD   (iSize+0),HL
            LD   HL,(iSize+2)
            LD   DE,0
            SBC  HL,DE          ;Subtract carry flag
            LD   (iSize+2),HL

; Display results -> Card size 
            LD   DE,CardSize
            CALL aOutputText    ;Output "Card size: "
            LD   DE,(Buffer+14) ;Number of sectors hi word
            LD   HL,(Buffer+16) ;Number of sectors lo word
            CALL cfSize         ;Get size in DE, units in A
            CALL uOutputDecWord ;Output decimal word DE
            CALL aOutputChar    ;Output units character eg. "M"
            LD   A,'B'          ;Get Bytes character
            CALL aOutputChar    ;Output Bytes character "B"
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
            CALL uOutputHexPref ;Output hext prefix
            CALL uOutputHexByte ;Output result as hex byte
@EndDiag:   CALL aOutputNewLine ;Output new line

            CALL aOutputNewLine ;Output new line

; Warning and confirm
            LD   DE,Warning     ;Pointer to message
            CALL aOutputText    ;Output "WARNING:..."
            CALL aOutputNewLine
@Wait:      LD   DE,Confirm     ;Pointer to message
            CALL aOutputText    ;Output "Are you sure..."
            CALL aInputChar     ;Get key
            CALL aOutputNewLine ;Output new line
            AND  0b01011111     ;Convert lower case to upper case
            CP   'N'
            RET  Z              ;Abort if key = 'N'
            CP   'Y'
            JR   NZ,@Wait       ;If not 'Y' ask again

            CALL aOutputNewLine ;Output new line


; Test compact flash card
; For each sector:
; Fill sector+0 with 0x00
; Fill sector+1 with 0xFF
; Fill sector+2 with 0x55
; Fill sector+3 with 0xAA
; Verify all 4 sectors contain the correct data
; Increment sector number
; The sector address Sector+n only uses 8-bit addition so the
; current sector test wraps around in blocks of 256 sectors
Test:       XOR A               ;Start at sector zero
            LD  (iSector+0),A
            LD  (iSector+1),A
            LD  (iSector+2),A
            LD  (iSector+3),A
; Test current sector
@Loop:      XOR  A
            LD   (iErrNum),A    ;Clear error number
            LD   (iFailCnt),A   ;Clear failure counter
; Output current sector number
            LD   DE,Sector
            CALL aOutputText    ;Output "Sector being tested: "
            CALL uOutputHexPref ;Output '$' (or whatever)
            LD   DE,(iSector+2)
            CALL uOutputHexWord ;Output most significant word
            LD   DE,(iSector+0)
            CALL uOutputHexWord ;Output least significant word
            LD   A,kSpace
            CALL aOutputChar    ;Output a space
; Prepare start sector number (DEB) for writing
            LD   A,(iSector+0)
            LD   B,A
            LD   DE,(iSector+1)
; Fill sector+0 with 0x00
            LD   A,0x00
            CALL Write          ;Write sector
            JR   NZ,@Fail
; Fill sector+1 with 0xFF
            INC  B
            LD   A,0xFF
            CALL Write          ;Write sector
            JR   NZ,@Fail
; Fill sector+2 with 0x55
            INC  B
            LD   A,0x55
            CALL Write          ;Write sector
            JR   NZ,@Fail
; Fill sector+3 with 0xAA 
            INC  B
            LD   A,0xAA
            CALL Write          ;Write sector
            JR   NZ,@Fail
; Prepare start sector number (DEB) for verify
@VeriTest:  LD   A,(iSector+0)
            LD   B,A
            LD   DE,(iSector+1)
; Verify sector+0
            LD   A,0x00
            CALL Verify         ;Verify sector
            JR   NZ,@Fail
; Verify sector+1
            INC  B
            LD   A,0xFF
            CALL Verify         ;Verify sector
            JR   NZ,@Fail
; Verify sector+2
            INC  B
            LD   A,0x55
            CALL Verify         ;Verify sector
            JR   NZ,@Fail
; Verify sector+3
            INC  B
            LD   A,0xAA
            CALL Verify         ;Verify sector
            JR   NZ,@Fail
; Sector test passed
            LD   DE,Passed      ;Passed ...
            CALL aOutputText    ;Output "Passed... "
            CALL aOutputNewLine ;Output new line
; Test for character input
            CALL aInputStatus   ;Character input status?
            RET  NZ             ;Abort if character available
; Increment sector number
@Next:      LD   HL,iSector     ;Point to current sector number
            INC  (HL)           ;Increment...
            JR   NZ,@TstEnd
            INC  HL
            INC  (HL)
            JR   NZ,@TstEnd
            INC  HL
            INC  (HL)
            JR   NZ,@TstEnd
            INC  HL
            INC  (HL)
; Test complete? (ie. reached end of card)
@TstEnd:    LD   HL,iSector     ;Point to current sector number
            LD   DE,iSize       ;Point to card size in sectors
            LD   B,3            ;Number of bytes to compare
@Compare:   LD   A,(DE)         ;Get byte from card size in sectors
            CP   (HL)           ;Compare to current sector number
            JP   NZ,@Loop       ;Not zero, so go test next sector
            INC  HL             ;Increment to next byte
            INC  DE             ;Increment to next byte
            DJNZ @Compare       ;Repeat until all bytes compared
; Test completed
@Finished:  LD   DE,Complete    ;Test complete ...
            CALL aOutputText    ;Output "Test complete... "
            CALL aOutputNewLine ;Output new line
            RET
; Failed a test
@Fail:      LD   (iErrNum),A    ;Store error number
            LD   DE,Failed      ;Pointer to message
            CALL aOutputText    ;Output "Failed... "
            CALL uOutputHexPref ;Output hex prefix
            CALL uOutputHexByte ;Output result as hex byte
            CALL ReportErr      ;Output descriptive error msg
            LD   HL,iFailCnt    ;Point to failure counter
            INC  (HL)           ;Increment failure counter
; Check for verify error
            ;LD   A,(HL)        ;Get error counter
            ;CP   1             ;First error
            ;JR   NZ,@Wait      ;No, so do not retry
            CALL cfGetError     ;Get error number
            CP   CF_Verify      ;Verify error?
            JR   NZ,@NotVeri    ;Yes, so repeat the verify
; Verify error
@AskV:      LD   DE,RetryV      ;Pointer to message
            CALL aOutputText    ;Output "Retry verify..."
            CALL aInputChar     ;Get key
            CALL aOutputNewLine ;Output new line
            AND  0b01011111     ;Convert lower case to upper case
            CP   'N'
            JR   Z,@Wait        ;Skip if key = 'N' 
            CP   'Y'
            JR   NZ,@AskV       ;If not 'Y' ask again
            CALL aOutputNewLine ;Output new line
            JP   @VeriTest
@NotVeri:
; Wait for Continue Y/N
@Wait:      LD   DE,Confirm     ;Pointer to message
            CALL aOutputText    ;Output "Are you sure..."
            CALL aInputChar     ;Get key
            CALL aOutputNewLine ;Output new line
            AND  0b01011111     ;Convert lower case to upper case
            CP   'N'
            RET  Z              ;Abort if key = 'N'
            CP   'Y'
            JR   NZ,@Wait       ;If not 'Y' ask again
            CALL aOutputNewLine ;Output new line
            JP   @Next


ReportErr:  CALL aOutputNewLine ;Output new line
ReportErr2: CALL cfGetError     ;Get error number
            LD   DE,cfErrMsgs   ;Point to list of error messages
            CALL uFindString    ;Find error message string
            CALL aOutputText    ;Output message at DE
            CALL aOutputNewLine ;Output new line
            RET


; **********************************************************************
; **  Messages
; **********************************************************************

About:      .DB  "Compact flash card test v1.1 by Stephen C Cousins",0
CardAt:     .DB  "Card at address $",0
Warning:    .DB  "WARNING: This will erase all data from the card",0
Confirm:    .DB  "Do you wish to continue? (Y/N)",0
NumSectors: .DB  "Number of sectors on card: ",0
CardSize:   .DB  "Card size: ",0
Diagnose:   .DB  "Card's self diagnostic test ",0
Passed:     .DB  "passed",0
Failed:     .DB  "failed: code ",0
Sector:     .DB  "Sector: ",0
RetryV:     .DB  "Do you wish to retry the verify? (Y/N)",0
Complete:   .DB  "Test complete",0


; **********************************************************************
; **  Support functions
; **********************************************************************


; Write test sector
;   On entry: A = Data byte to fill the sector buffer with
;             DEB = Sector number to write
;             HL = Source address for write sector data
;   On exit:  A = Error number (0 if no error)
;             Z flagged if no error
;             BC DE HL IX IY I AF' BC' DE' HL' preserved
Write:      CALL PrepData       ;Prepare test data
            PUSH HL
            LD   C,1            ;Write one sector
            LD   HL,Buffer      ;Pointer to data
            CALL cfWrite        ;Write data to sector
            POP  HL
            RET


; Verify test sector
;   On entry: A = Data byte to fill the sector buffer with
;             DEB = Sector number to verify
;             HL = Source address for write sector data
;   On exit:  A = Error number (0 if no error)
;             Z flagged if no error
;             BC DE HL IX IY I AF' BC' DE' HL' preserved
Verify:     CALL PrepData       ;Prepare test data
            PUSH HL
            LD   C,1            ;Verify one sector
            LD   HL,Buffer      ;Pointer to data
            CALL cfVerify       ;Verify sector 
            POP  HL
            RET


; Prepare test data
;   On entry: A = Data byte to fill the sector buffer with
;   On exit:  A BC DE HL IX IY I AF' BC' DE' HL' preserved
PrepData:   PUSH BC
            PUSH HL
            LD   HL,Buffer
            LD   B,0
@Loop:      LD   (HL),A
            INC  HL
            LD   (HL),A
            INC  HL
            DJNZ @Loop
            POP  HL
            POP BC
            RET


; Output parameter (string plus hex word)
Parameter:  PUSH HL
            CALL aOutputText    ;Output message
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
            CALL aOutputChar    ;Output quote mark
@Loop:      LD   A,(DE)         ;Get character from text
            CALL aOutputChar    ;Ouptut character
            INC  DE             ;Point to next character
            DJNZ @Loop
            LD   A,kQuote       ;Quotation mark
            CALL aOutputChar    ;Output quote mark
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
            CALL aOutputChar    ;Output quote mark
@Loop:      INC  DE
            LD   A,(DE)         ;Get first CharOut of pair
            DEC  DE
            CALL aOutputChar    ;Ouptut CharOutr
            LD   A,(DE)         ;Get second character of pair
            CALL aOutputChar    ;Ouptut CharOutr
            INC  DE             ;Point to next character pair
            INC  DE
            DJNZ @Loop
            LD   A,kQuote       ;Quotation mark
            CALL aOutputChar    ;Output quote mark
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

iSector:    .DS  4              ;Current sector number
iSize:      .DS  4              ;Card size in sectors 
iErrNum:    .DS  1              ;Current error number
iFailCnt:   .DS  1              ;Failure count at current sector

            .END











