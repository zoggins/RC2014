; **********************************************************************
; **  Application Programming Interface (API)   by Stephen C Cousins  **
; **********************************************************************

; This module provides a means of external software accessing some of
; the features of the Small Computer Monitor.
;
; API functions are accessed by:
; Loading C register with the function number
; Loading registers as required by the selected function
; Calling address 0x0030 (either with CALL or RST instruction)
;
; Public functions provided:
;   APIHandler            API main entry point


; **********************************************************************
; **  Public functions                                                **
; **********************************************************************

            .CODE

; API: Main entry point
;   On entry: C = Function number
;             A, DE = Parameters (as specified by function)
;   On exit:  AF,BC,DE,HL = Return values (as specified by function)
;             IX IY I AF' BC' DE' HL' preserved
; This handler modifies: F, B, HL but preserves A, C, DE
; Other registers depend on API function called
APIHandler: LD   HL,APITable    ;Start of function address table
            LD   B,A            ;Preserve A
            LD   A,C            ;Get function number
            CP   kAPILast+1     ;Supported function?
            RET  NC             ;No, so abort
            LD   A,B            ;Restore A
            LD   B,0
            ADD  HL,BC          ;Calculate table pointer..
            ADD  HL,BC
            LD   B,(HL)         ;Read function address from table..
            INC  HL
            LD   H,(HL)
            LD   L,B
            JP   (HL)           ;Jump to function address


; API: Function address table
; This table contains a list of addresses, one for each API function. 
; Each is the address of the subroutine for the relevant function.
APITable:   .DW  SysReset       ; 0x00 = System reset
            .DW  InputChar      ; 0x01 = Input character
            .DW  OutputChar     ; 0x02 = Output character
            .DW  InputStatus    ; 0x03 = Input status
            .DW  InputLineTo    ; 0x04 = Input line
            .DW  InputLine      ; 0x05 = Input line default
            .DW  OutputZString  ; 0x06 = Output line
            .DW  OutputNewLine  ; 0x07 = Output new line
            .DW  GetVersion     ; 0x08 = Get version details
            .DW  ClaimJump      ; 0x09 = Claim jump table entry
            .DW  HW_Delay       ; 0x0A = Delay in milliseconds
            .DW  OutputMessage  ; 0x0B = Output system message
            .DW  ReadJump       ; 0x0C = Read jump table entry
            .DW  SelConDev      ; 0x0D = Select console in/out device
            .DW  SelConDevI     ; 0x0E = Select console input device
            .DW  SelConDevO     ; 0x0F = Select console output device
            .DW  DevInput       ; 0x10 = Input from specified device
            .DW  DevOutput      ; 0x11 = Output to specifiec device
            .DW  JpIdle         ; 0x12 = Poll idle events
            .DW  IdleConfig     ; 0x13 = Configure idle events
            .DW  IdleTimer1     ; 0x14 = Timer 1 control
            .DW  IdleTimer2     ; 0x15 = Timer 2 control
            .DW  IdleTimer3     ; 0x16 = Timer 3 control
            .DW  PrtOInit       ; 0x17 = Output port initialise
            .DW  PrtOWr         ; 0x18 = Write to output port
            .DW  PrtORd         ; 0x19 = Read from output port
            .DW  PrtOTst        ; 0x1A = Test output port bit
            .DW  PrtOSet        ; 0x1B = Set output port bit
            .DW  PrtOClr        ; 0x1C = Clear output port bit
            .DW  PrtOInv        ; 0x1D = Invert output port bit
            .DW  PrtIInit       ; 0x1E = Input port initialise
            .DW  PrtIRd         ; 0x1F = Read from input port
            .DW  PrtITst        ; 0x20 = Test input port bit
            .DW  SetBaud        ; 0x21 = Set baud rate
            .DW  M_Execute      ; 0x22 = Execute command line
            .DW  RomGetPtr      ; 0x23 = Get pointer to command line
            .DW  M_SkipDeli     ; 0x24 = Skip delimiter
            .DW  M_SkipNone     ; 0x25 = Skip non-delimiter
            .DW  M_GetHexPa     ; 0x26 = Get hex parameter
            .DW  GetConDev      ; 0x27 = Get console in/out devices
            .DW  GetMemTop      ; 0x28 = Get top of free memory
            .DW  SetMemTop      ; 0x29 = Set top of free memory
            .DW  HW_RdRAM       ; 0x2A = Read banked RAM
            .DW  HW_WrRAM       ; 0x2B = Write banked RAM

kAPILast:   .EQU 0x2B           ;Last API function number


; Dummy entry points for unsupported features
#IFNDEF     IncludeRomFS
RomGetPtr:  ; 0x23 = Get pointer to command line
#ENDIF
#IFNDEF     IncludeMonitor
M_Execute:  ; 0x22 = Execute command line
M_SkipDeli: ; 0x24 = Skip delimiter
M_SkipNone: ; 0x25 = Skip non-delimiter
M_GetHexPa: ; 0x26 = Get hex parameter
#ENDIF
            RET


; **********************************************************************
; **  End of Application Programming Interface (API) module           **
; **********************************************************************



















