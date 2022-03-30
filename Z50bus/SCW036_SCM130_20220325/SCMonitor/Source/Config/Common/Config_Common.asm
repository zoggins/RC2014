; **********************************************************************
; **  Configuration Common Code                 by Stephen C Cousins  **
; **********************************************************************

; Common configuration functions:
;   H_GetName                   ;Get config name and date
;   H_GetInfo                   ;Get config  details


; **********************************************************************
; **  Public functions                                                **
; **********************************************************************

            .CODE

; **********************************************************************
; Get configuration name and date
;   On entry: No parameters required
;   On exit:  DE = Pointer to configuration name string
;             HL = Pointer to build date string
;             AF BC not specified
;             IX IY I AF' BC' DE' HL' preserved
C_GetName:  LD  DE,szCName      ;Configuration name
            LD  HL,szCDate      ;Configuration date
            RET


; **********************************************************************
; Get configuration details
;   On entry: No parameters required
;   On exit:  A = Hardware identifier (if known)
;             B,C = Configuration code (Major, Minor)
;             DE HL IX IY I AF' BC' DE' HL' preserved
C_GetInfo:  LD  A,kConfHardw    ;A = Hardware identifier
            LD  B,kConfMajor    ;B = Major configuration
            LD  C,kConfMinor    ;C = Minor configuration 
            RET


; **********************************************************************
; Static strings
;
; Fixed space allocated so the BIOS jump table is in the same place for
; all builds of a given system and monitor combination. This has the 
; advantage of the system and monitor code being the same binary image,
; except for the few default setting bytes starting at 0x0040.

szCDate:    #DB  CDATE          ; Build date. eg: "20190627"
            .DB  kNull

            .ORG szCDate + 9    ;Fixed space allocated for date

szCName:    #DB  CNAME          ; Configuration name. eg: "SC126"
            .DB  kNull

            .ORG szCName + 12   ;Fixed space allocated for name


; **********************************************************************

