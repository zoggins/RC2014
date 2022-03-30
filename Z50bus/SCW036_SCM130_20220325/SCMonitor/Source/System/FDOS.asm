; **********************************************************************
; **  Limited CP/M style FDOS support           by Stephen C Cousins  **
; **********************************************************************

; Currently this is just a proff of concept!

            .CODE

; FDOS: Main entry point
;   On entry: C = Function number
;             DE = Parameter (as specified by function)
;   On exit:  A = Single byte value (as specified by function)
;             HL = Double byte value (as specified by function)
;             IX IY I AF' BC' DE' HL' preserved
; For compatibility functions return with A=L and B=H.
; Unsupported or out of range functions return A,B,H and L = zero.
FDOS:       LD   HL,FDOSTable   ;Start of function address table
;           LD   B,A            ;Preserve A
            LD   A,C            ;Get function number
            CP   kFDOSLast+1    ;Supported function?
            JR   NC,FDOSExit    ;No, so go..
;           LD   A,B            ;Restore A
            LD   B,0
            ADD  HL,BC          ;Calculate table pointer..
            ADD  HL,BC
            LD   B,(HL)         ;Read function address from table..
            INC  HL
            LD   H,(HL)
            LD   L,B
            JP   (HL)           ;Jump to function address
; Exit for unsupported or out of range functions
FDOSExit:   XOR  A              ;A=0
            LD   B,A            ;B=0
            LD   H,A            ;H=0
            LD   L,A            ;L=0
            RET


; FDOS: Function 1: Console input
;   On entry: No parameters required
;   On exit:  A = ASCII character from input
;             IX IY I AF' BC' DE' HL' preserved
; WARNING: Only partially implemented
FDOSConIn:  JP   InputChar


; FDOS: Function 2: Console output
;   On entry: E = ASCII character to be output
;   On exit:  IX IY I AF' BC' DE' HL' preserved
; WARNING: Only partially implemented
FDOSConOut: LD   A,E
            JP   OutputChar


; FDOS: Function address table
; This table contains a list of addresses, one for each FDOS function. 
; Each is the address of the subroutine for the relevant function.
FDOSTable:  .DW  Reset          ;  0 = System reset
            .DW  FDOSConIn      ;  1 = Console input
            .DW  FDOSConOut     ;  2 = Console output
;           .DW  FDOSExit       ;  3 = Reader input
;           .DW  FDOSExit       ;  4 = Punch output
;           .DW  FDOSExit       ;  5 = List output
;           .DW  FDOSExit       ;  6 = Direct console I/O
;           .DW  FDOSExit       ;  7 = Get I/O byte
;           .DW  FDOSExit       ;  8 = Set I/O byte
;           .DW  FDOSExit       ;  9 = Read string
;           .DW  FDOSExit       ; 10 = Read console buffer
;           .DW  FDOSExit       ; 11 = Get console status
;           .DW  FDOSExit       ; 12 = Return version number
;           .DW  FDOSExit       ; 13 = Reset disk system
;           .DW  FDOSExit       ; 14 = Select disk
;           .DW  FDOSExit       ; 15 = Open file
;           .DW  FDOSExit       ; 16 = Close file
;           .DW  FDOSExit       ; 17 = Search for first
;           .DW  FDOSExit       ; 18 = Search for next
;           .DW  FDOSExit       ; 19 = Delete file
;           .DW  FDOSExit       ; 20 = Read sequential
;           .DW  FDOSExit       ; 21 = Write sequential
;           .DW  FDOSExit       ; 22 = Make file
;           .DW  FDOSExit       ; 23 = Rename file
;           .DW  FDOSExit       ; 24 = Return login vector
;           .DW  FDOSExit       ; 25 = Return current disk
;           .DW  FDOSExit       ; 26 = Set DMA address
;           .DW  FDOSExit       ; 27 = Get addr (alloc)
;           .DW  FDOSExit       ; 28 = Write protect disk
;           .DW  FDOSExit       ; 29 = Get R/O vector
;           .DW  FDOSExit       ; 30 = Set file attributes
;           .DW  FDOSExit       ; 31 = Get addr (disk params)
;           .DW  FDOSExit       ; 32 = Set/get user code
;           .DW  FDOSExit       ; 33 = Read random
;           .DW  FDOSExit       ; 34 = Write random
;           .DW  FDOSExit       ; 35 = Compute file size
;           .DW  FDOSExit       ; 36 = Set random record
;           .DW  FDOSExit       ; 37 = Reset drive
;           .DW  FDOSExit       ; 38 = Unspecified
;           .DW  FDOSExit       ; 39 = Unspecified
;           .DW  FDOSExit       ; 40 = Write random with zero fill

kFDOSLast:  .EQU 2              ;Last FDOS function number


; **********************************************************************
; **  End of CP/M style FDOS support module                           **
; **********************************************************************

