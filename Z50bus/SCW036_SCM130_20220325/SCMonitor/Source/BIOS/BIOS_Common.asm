; **********************************************************************
; **  BIOS Common Code                          by Stephen C Cousins  **
; **********************************************************************

; This file provides common BIOS functions and support functions to 
; avoid duplication.
;
; Common BIOS functions:
;   H_GetName                   ;Get hardware name message
;   H_GetVers                   ;Get versions details
;   H_Delay                     ;Delay by DE milliseconds
;
; Common API function shims:
;   InitJump & InitJumps        ;Initialise jump table entry/entires
;   MonPrtOSet                  ;Set output port bit
;   OutputStr                   ;Outoput null terminated string
;   OutputNL                    ;Output new line
;   OutputChar                  ;Output character
;
; Static strings:
;   szShrtName & szLongName
;
; Data:
;   iHwFlags                    ;Hardware flags byte


; **********************************************************************
; **  Public functions                                                **
; **********************************************************************

            .DATA

            .ORG  kBiosData     ;Establish workspace/data area

            .CODE


; **********************************************************************
; Get BIOS name string
;   On entry: No parameters required
;   On exit:  DE = Pointer to BIOS name name string
;             AF BC HL IX IY I AF' BC' DE' HL' preserved
H_GetName:  LD  DE,szBName
            RET


; **********************************************************************
; Get BIOS version details
;   On entry: No parameters required
;   On exit:  D,E,A = Bios code version (Major, Minor, Revision)
;             H,L = Target hardware ID (H) and flags (L)
;             F not specified
;             BC IX IY I AF' BC' DE' HL' preserved
H_GetVers:  LD  H,kBiosID       ;H = BIOS / hardware ID
            LD  A,(iHwFlags)    ;Get hardware option flags
            LD  L,A             ;L = Hardware option flags
            LD  D,kBiosMajor    ;D = Major version number
            LD  E,kBiosMinor    ;E = Minor version number
            LD  A,kBiosRevis    ;A = Revision number
            RET


; **********************************************************************
; Delay by DE milliseconds
;   On entry: DE = Delay time in milliseconds
;   On exit:  AF BC DE HL IX IY I AF' BC' DE' HL' preserved
; Delay loops = ( CPU_clock_Hz - Overhead_each_1ms ) / Loop_cycles
; Tcycle calculations assume no wait states added
; Actual measurements on SC126 showed timer running 2.5% slow so 
; kDelayLP set to 21 instead of 20. Yet to work out why!
#IF         PROCESSOR = "Z80"
kDelayOH:   .EQU 36             ;Overhead for each 1ms in Tcycles
kDelayLP:   .EQU 26             ;Inner loop time in Tcycles
#ENDIF
#IF         PROCESSOR = "Z180"
kDelayOH:   .EQU 29             ;Overhead for each 1ms in Tcycles
kDelayLP:   .EQU 21             ;Inner loop time in Tcycles (20 in theory!)
#ENDIF
kDelayTA:   .EQU kCPUClock / 1000 ;CPU clock cycles per millisecond
kDelayTB:   .EQU kDelayTA - kDelayOH  ;Cycles required for inner loop
kDelayCnt:  .EQU kDelayTB / kDelayLP  ;Loop counter for inner loop
; 
;                               Z80      Z180     Tcycles
H_Delay:    PUSH AF
            PUSH BC
            PUSH DE
; 1 ms loop, DE times...        ;[=36]   [=29]    Overhead for each 1ms
@LoopDE:    LD   BC,kDelayCnt   ;[10]    [9]
; Inner loop, BC times...       ;[=26]   [=20]    Loop time in Tcycles
@LoopBC:    DEC  BC             ;[6]     [4]
            LD   A,C            ;[4]     [4]
            OR   B              ;[4]     [4]
            JP   NZ,@LoopBC     ;[12/7]  [8/6] 
; Have we looped once for each millisecond requested?
            DEC  DE             ;[6]     [4]
            LD   A,E            ;[4]     [4]
            OR   D              ;[4]     [4]
            JR   NZ,@LoopDE     ;[12/7]  [8/6]
            POP  DE
            POP  BC
            POP  AF
            RET


; **********************************************************************
; **  API functions shims                                             **
; **********************************************************************


; **********************************************************************
; Initialise jump table entries
;   On entry: A = First jump table entry to initialise
;             B = Number of entries to be initialised (InitJumps only)
;             HL = Pointer to list of vectors
;   On exit:  AF BC* DE HL IX IY I AF' BC' DE' HL' preserved
;             * Call to InitJump returns with B=1
InitJump:   LD   B,1            ;Initial one jump table entry
InitJumps:  PUSH AF
            PUSH BC
            PUSH DE
            PUSH HL
            LD   C,A            ;Table entry number
            LD   A,B            ;Get number of table entries
            OR   A              ;Zero ?
            JR   Z,@Exit        ;Yes, so abort
@Next:      LD   E,(HL)         ;Get lo byte of vector
            INC  HL             ;Point to hi byte of vector
            LD   D,(HL)         ;Get lo byte of vector
            INC  HL             ;Point to next vector
            LD   A,C            ;Table entry 
            PUSH BC
            PUSH HL
            LD   C,9            ;API 0x09 = Claim jump table entry
            ;RST  0x30          ;Call API 
            CALL JpAPI          ;Call API
            POP  HL
            POP  BC
            INC  C              ;Increment entry number
            DJNZ @Next          ;Repeat until done
@Exit:      POP  HL
            POP  DE
            POP  BC
            POP  AF
            RET


; **********************************************************************
; Set output port bit
;   On entry: A = Bit number to set
;   On exit:  AF BC DE HL IX IY I AF' BC' DE' HL' preserved
MonPrtOSet: PUSH AF
            PUSH BC
            PUSH DE
            PUSH HL
            LD   C,0x1B         ;API 0x1B = Set output port bit
            ;RST  0x30          ;CALL API
            CALL JpAPI          ;Call API
            POP  HL
            POP  DE
            POP  BC
            POP  AF
            RET


; **********************************************************************
; Output a zero (null) terminated string
;   On entry: DE= Start address of string
;   On exit:  DE= Address after null
;             AF BC HL IX IY I AF' BC' DE' HL' preserved
OutputStr:  PUSH AF
            PUSH BC
            PUSH HL
            LD   C,6            ;API 0x06 = Output a string
            ;RST  0x30          ;Call API
            CALL JpAPI          ;Call API
            POP  HL
            POP  BC
            POP  AF
            RET


; **********************************************************************
; Output new line
;   On entry: No parameters required
;   On exit:  AF BC DE HL IX IY I AF' BC' DE' HL' preserved
OutputNL:   PUSH AF
            PUSH BC
            PUSH DE
            PUSH HL
            LD   C,7            ;API 0x07 = Output new line
            ;RST  0x30          ;Call API
            CALL JpAPI          ;Call API
            POP  HL
            POP  DE
            POP  BC
            POP  AF
            RET


; **********************************************************************
; Output character
;   On entry: A = Character to be output
;   On exit:  AF BC DE HL IX IY I AF' BC' DE' HL' preserved
OutputChr:  PUSH AF
            PUSH BC
            PUSH DE
            PUSH HL
            LD   C,2            ;API 0x02 = Output character
            ;RST  0x30          ;Call API
            CALL JpAPI          ;Call API
            POP  HL
            POP  DE
            POP  BC
            POP  AF
            RET


; **********************************************************************
; **  Static strings                                                  **
; **********************************************************************

; BIOS name string (used in Monitor's help text. eg: xyz BIOS 1.2.3)
szBName:    #DB  BNAME
            .DB  kNull


; **********************************************************************
; **  Workspace (in RAM)                                              **
; **********************************************************************

            .DATA

; Hardware flags (for Z80/Z180 from SCM v1.1)
;   Bit 0 = ACIA #1 
;   Bit 1 = SIO #1
;   Bit 2 = ACIA #2
;   Bit 3 = Bit-bang serial
;   Bit 4 = CTC #1
;   Bit 5 = SIO #2 
;   Bit 6 = CTC #2
;   Bit 7 = Z180 serial
iHwFlags:   .DB  0x00           ;Hardware flags

            .CODE


































