; **********************************************************************
; **  Compact Flash Format                      by Stephen C Cousins  **
; **********************************************************************
;
; **  Written as a Small Computer Monitor App 
; **  www.scc.me.uk
;
; SCC  2022-03-02 : v1.1.0  CF card I/O address set at runtime
;
; **********************************************************************
;
; Formats a compact flash card for use with CP/M.
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
; Memory map
; **********************************************************************

CodeORG:    .EQU $8000          ;Start of code section
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
#REQUIRES   aInputChar

; Utility functions used
#REQUIRES   uOutputDecWord
#REQUIRES   uOutputHexByte 
#REQUIRES   uFindString

; Compact flash functions used
#REQUIRES   cfDiagnose
#REQUIRES   cfFormat
#REQUIRES   cfInfo
#REQUIRES   cfRead
#REQUIRES   cfSize
#REQUIRES   cfVerifyF
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

; Output program details
            LD   DE,About       ;Pointer to error message
            CALL aOutputText    ;Output "Compact flash card..."
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

; Output card size in MB
            LD   DE,CardSize
            CALL aOutputText    ;Output "Card size: "
            LD   DE,(Buffer+14) ;Number of sectors hi word
            LD   HL,(Buffer+16) ;Number of sectors lo word
            CALL cfSize         ;Get size in DE, units in A
            PUSH AF             ;Preserve units character
            CALL uOutputDecWord ;Output decimal word DE
            CALL aOutputChar    ;Output units character eg. "M"
            LD   A,'B'          ;Get Bytes character
            CALL aOutputChar    ;Output Bytes character "B"
            CALL aOutputNewLine ;Output new line
            POP  AF             ;Restore units character

;           CALL aOutputNewLine ;Output new line

; Output number of drives to format
            CP   'M'            ;Card size in Megabytes?
            JR   NZ,@SetMax     ;No, so set max useful size of 128MB
            LD   A,D            ;Get hi byte of size in MB
            OR   A              ;Zero? (ie. < 256MB)
            JR   Z,@SetSize     ;Yes, so set size to DE megabytes
@SetMax:    LD   E,128          ;Set max useful size of 128MB
@SetSize:   SRL  E              ;Convert size in MB (8 to 128)
            SRL  E              ;  to number of 8 MB 'drives'
            SRL  E
            LD   A,E            ;Get number of logical drives
            LD   (iDrives),A    ;Store number of logical drives
            PUSH DE
            LD   DE,NumDrives   ;Pointer to message
            CALL aOutputText    ;Output "Number of drives..."
            POP  DE
            CALL uOutputDecWord ;Ouput number of logical drives
            CALL aOutputNewLine ;Output new line

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

            LD   DE,Formatting  ;Point to message
            CALL aOutputText    ;Output "Formatting: "
            LD   B,0            ;Current drive (0 to N-1)
@Format:    LD   A,B            ;Get drive number (0 to N-1)
            ADD  'A'            ;Determine drive letter
            CALL aOutputChar    ;Output drive letter
            CALL cfFormat       ;Format logical drive E (1 to N-1)
            JP   NZ,ReportErr   ;Report error and exit program
            INC  B              ;Increment drive number
            LD   A,(iDrives)    ;Get number of logical drive
            CP   B              ;Finished?
            JR   NZ,@Format     ;NO, so go format this drive
            CALL aOutputNewLine ;Output new line

            LD   DE,Verifying   ;Point to message
            CALL aOutputText    ;Output "Verifying: "
            LD   B,0            ;Current drive (0 to N-1)
@Verify:    LD   A,B            ;Get drive number (0 to N-1)
            ADD  'A'            ;Determine drive letter
            CALL aOutputChar    ;Output drive letter
            CALL cfVerifyF      ;Verify logical drive E (1 to N-1)
            JP   NZ,ReportErr   ;Report error and exit program
            INC  B              ;Increment drive number
            LD   A,(iDrives)    ;Get number of logical drive
            CP   B              ;Finished?
            JR   NZ,@Verify     ;NO, so go verify this drive
            CALL aOutputNewLine ;Output new line

            CALL aOutputNewLine ;Output new line

            LD   DE,Complete    ;Point to message
            CALL aOutputText    ;Output "Formatting complete"
            CALL aOutputNewLine ;Output new line

            RET


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

About:      .DB  "Compact Flash card format v1.1 by Stephen C Cousins",0
CardAt:     .DB  "Card at address $",0
CardSize:   .DB  "Card size: ",0
NumDrives:  .DB  "Number of logical drives to format: ",0
Warning:    .DB  "WARNING: Format will erase all data from the card",0
Confirm:    .DB  "Do you wish to continue? (Y/N)",0
Formatting: .DB  "Formatting drives: ",0
Verifying:  .DB  "Verifying drives:  ",0
Complete:   .DB  "Formatting complete",0


; **********************************************************************
; **  Support functions
; **********************************************************************


; **********************************************************************
; **  Includes
; **********************************************************************

#INCLUDE    ..\_CodeLibrary\SCMonitor_API.asm
#INCLUDE    ..\_CodeLibrary\Utilities.asm
#INCLUDE    ..\_CodeLibrary\CompactFlash.asm


; **********************************************************************
; **  Variables
; **********************************************************************

            .DATA               ;Data section

iDrives:    .DB  0              ;Number of logical drives to format

            .END






















