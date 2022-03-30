; **********************************************************************
; **  Breakpoint Support                        by Stephen C Cousins  **
; **********************************************************************

; This module provides breakpoint and single stepping support.
;
; Limitations of breakpoints and single step:
;
; You can't set breakpoints in read only memory. As a result you can't
; single step through code in read only memory.
;
; Single stepping code in the monitor itself is problematic so it is
; prevented. To achieve this any instruction trying to call or jump
; into the monitor is not stepped, but instead the instruction after
; is trapped. As a result calls into the monitor are stepped over.
; To achieve this for the monitor's API etc we also step over calls 
; and jumps to the address range 0x0000 to 0x00FF.
;
; An instruction that jumps to itself will never run if you attempt to
; single step it. For examples:
;   Loop:  JP Loop
;   Loop:  DJNZ Loop
; Single step does not run the instruction as a breakproint is set there
; each time you try to step. The only case this is likely to be an issue
; is where DJNZ loops back to itself to create a short delay.
;
; Public functions provided:
;   BPInitialise          Initialise the breakpoint module
;   BPHandler             Code executed when breakpoint encountered
;   BPReqSet              Clear set the requested breakpoint address
;   BPReqClr              Clear the requested breakpoint address
;   BPGo                  Breakpoint: Jump here for Go command
;   BPStep                Breakpoint: Jump here for Step command
;   BPIsInMonitor         Is address in monitor code?


; **********************************************************************
; **  Constants                                                       **
; **********************************************************************

#IFNDEF     BREAKPOINT
#DEFINE     BREAKPOINT 28       ;Breakpoint restart (08|10|18|20|28|30)
#ENDIF

#IF         BREAKPOINT = "08"
kBPOpcode:  .EQU 0xCF           ;Breakpoint restart = RST 0x08
kBPAddress: .EQU 0x08           ;Breakpoint restart address = 0x0008
#ENDIF
#IF         BREAKPOINT = "10"
kBPOpcode:  .EQU 0xD7           ;Breakpoint restart = RST 0x10
kBPAddress: .EQU 0x10           ;Breakpoint restart address = 0x0010
#ENDIF
#IF         BREAKPOINT = "18"
kBPOpcode:  .EQU 0xDF           ;Breakpoint restart = RST 0x18
kBPAddress: .EQU 0x18           ;Breakpoint restart address = 0x0018
#ENDIF
#IF         BREAKPOINT = "20"
kBPOpcode:  .EQU 0xE7           ;Breakpoint restart = RST 0x20
kBPAddress: .EQU 0x20           ;Breakpoint restart address = 0x0020
#ENDIF
#IF         BREAKPOINT = "28"
kBPOpcode:  .EQU 0xEF           ;Breakpoint restart = RST 0x28
kBPAddress: .EQU 0x28           ;Breakpoint restart address = 0x0028
#ENDIF
#IF         BREAKPOINT = "30"
kBPOpcode:  .EQU 0xF7           ;Breakpoint restart = RST 0x30
kBPAddress: .EQU 0x30           ;Breakpoint restart address = 0x0030
#ENDIF


; **********************************************************************
; **  Public functions                                                **
; **********************************************************************

            .CODE

; Breakpoint: Initialise this module
;   On entry: No parameters required
;   On exit:  BC IX IY I AF' BC' DE' HL' preserved
BPInitialise:
            CALL BPClear        ;Clear breakpoint from memory
            CALL BPReqClr       ;Clear requested breakpoint address
            LD   HL,kBPAddress  ;Address of breakpoint restart
#IFDEF      ROM_ONLY
            .DW  0,0,0,0        ;Padding to other code does not move
            .DB  0
#ELSE
            LD   (HL),0xC3      ;Write JP instruction at restart
            INC  HL             ;Increment address pointer
            LD   DE,BPHandler   ;Write address of breakpoint handler
            LD   (HL),E         ;  at restart...
            INC  HL             ;  Should use LD (HL),BPHandler/256 etc
            LD   (HL),D         ;  but homebrew assembler fails at that
#ENDIF
            RET                 ;  TODO fix the assembler!


; Breakpoint: Breakpoint handler
; Directed here when suitable breakpoint is encountered
BPHandler:
; Store state of processor
            LD   (iBC),BC       ;Store BC
            LD   (iDE),DE       ;Store DE
            LD   (iHL),HL       ;Store HL
            LD   (iIX),IX       ;Store IX
            LD   (iIY),IY       ;Store IY
            POP  HL             ;Get address of breakpoint + 1
            DEC  HL             ;Adjust to address of breakpoint
            LD   (iPC),HL       ;Store address of breakpoint
            LD   (iSP),SP       ;Store stack pointer at breakpoint
            EX   (SP),HL
            LD   (iCSP),HL      ;Store contents of SP
            EX   (SP),HL
            PUSH AF             ;Copy AF to HL...
            POP  HL             ;  and store AF value
            LD   (iAF),HL       ;Store AF
            LD   A,I
            LD   (iIR+1),A      ;Store I register
            LD   A,R
            LD   (iIR),A        ;Store R register
; Stack pointer now same value as it was before the breakpoint's restart
; What caused this breakpoint?
            LD   HL,(iPC)       ;Did breakpoint restart occur at
            LD   A,L            ;  the current breakpoint?
            LD   D,H            ;  ie. PC=BP 
            LD   HL,(iBPAddr)
            CP   L              ;LSBytes equal
            JR   NZ,@Trap       ;No, so TRAP
            LD   A,D
            CP   H              ;MSBytes equal
            JR   NZ,@Trap       ;No, so TRAP
; A Restart 28 instruction was encountered at the breakpoint addr
            CALL BPClear
            LD   A,(iBPType)    ;Get breakpoint type
            OR   A              ;Type 0 = Once?
            JR   NZ,@Reg        ;No, so may be single stepping
            LD   DE,szBreak     ;Point to message "Breakpoint"
            JR   @Msg
; A Restart 28 instruction was encountered but not the breakpoint
@Trap:      LD   DE,szTrap      ;Point to message "Trap"
@Msg:       CALL OutputZString  ;Output message
; Output register values as they were at the breakpoint
@Reg:       CALL WrRegister1    ;Build primary register line
            CALL StrPrint       ;Output primary register line
            ;CALL WrRegister2   ;Build secondary register line
            ;CALL StrPrint      ;Output secondary register line
#IFDEF      IncludeDisassemble
; Disassemble this instruction and output it
; Stack pointer now same value as it was before the breakpoint's restart
            LD   A,(iBPType)    ;Get breakpoint type
            OR   A              ;Type 0 = Once?
            JP   Z,WarmStart    ;Yes, so do not set another breakpoint
; Single step mode, so wait for user key press
            CALL InputMore      ;Print more?
            JP   NZ,WarmStart   ;No, so exit
; Prepare to step next instruction
            LD   HL,(iPC)       ;Get current address
            CALL DisWrInstruction ;Disassemble instruction
            LD   D,H            ;Store address of next instruction
            LD   E,L            ;  (the one immediately after this)
            CALL StrWrNewLine   ;Write new line to string buffer
            CALL StrPrint       ;Print to output device
            CALL DisGetNextAddress  ;Get PC after executing this inst
; Catch jumps and calls into the monitor code and bottom 256 bytes
; as we can't step reliably through code in the monitor itself
; Also we trap the end of user program when it returns to monitor
;           LD   A,H            ;Get hi byte of address of next inst
;           OR   A              ;Is next inst in bottom 256 bytes?
;           JR   Z,@StepOver    ;Yes, so step over this instruction
            CALL BPIsInMonitor  ;Next instruction within monitor code?
            JR   Z,@StepOver    ;Yes, so step over this instruction
; Attempt to follow this instruction (ie. follow jumps etc)
            CALL BPSet          ;Attempt to set breakpoint here
            JR   Z,@SetOK       ;Set ok (ie in RAM) so skip
; Attempt to step over this instruction (ie. don't follow jumps etc)
; as we can't step through ROM code or reliably through monitor code
@StepOver:  LD   H,D            ;Get address after this instruction
            LD   L,E            ;  as we can't step into ROM
            LD   DE,szOver
            CALL OutputZString  ;Output "Stepping over..."
            CALL BPSet          ;Attempt to set breakpoint here
            RET  NZ             ;Abort as failed so set (not in RAM)
; Brakpoint set for next step ok
@SetOK:
#ELSE
; No disassembler so just display address and hex bytes
; Stack pointer now same value as it was before the breakpoint's restart
            CALL StrInitDefault ;Initialise default string buffer
            LD   DE,(iPC)       ;Get current address
            CALL StrWrHexWord   ;Display breakpoint address
            LD   A,':'
            CALL StrWrChar      ;Print ':'
            LD   A,4            ;Get length of instruction 
            LD   B,A
            LD   L,A
@Loop:      CALL StrWrSpace
            LD   A,(DE)         ;Read byte at PC
            CALL StrWrHexByte
            INC  DE
            DJNZ @Loop
            LD   A,5            ;TAB cursor..
            SUB  L
            LD   L,A
            ADD  L
            ADD  L
            CALL StrWrSpaces    ;Display A spaces
            LD   A,'?'
            CALL StrWrChar      ;Print '?' (no disassembly)
            CALL StrWrNewLine
            CALL StrPrint       ;Print to output device
            RET
#ENDIF
; Restore state of processor
; Stack pointer now same value as it was before the breakpoint's restart
BPRestore:  LD   A,(iIR+1)      ;Get value or I register
            LD   I,A            ;Retore I register
;           LD   A,(iIR)        ;Don't restore R as it is free 
;           LD   R,A            ;  running refresh counter
            LD   HL,(iAF)       ;Get value of AF registers
            PUSH HL
            POP  AF             ;Restore AF
            LD   SP,(iSP)       ;Restore SP
            LD   HL,(iPC)       ;Get value of PC register
            PUSH HL             ;Put continuation address on stack
            LD   IY,(iIY)       ;Restore IY
            LD   IX,(iIX)       ;Restore IX
            LD   HL,(iHL)       ;Restore HL
            LD   DE,(iDE)       ;Restore DE
            LD   BC,(iBC)       ;Restore BC
            RET                 ;Return to continuation address


; Clear or set the requested breakpoint address
; This does not actually set or clear the breakpoint in memory
; The actually breakpoint is manipulated at reset, Go or Step
;   On entry: HL = Breakpoint address required
;   On exit:  BC DE IX IY I AF' BC' DE' HL' preserved
BPReqClr:   LD   HL,0           ;Address zero indicates no BP request
            JR   BPWrAddr       ;Go clear the breakpoint request
;   On entry: HL = Breakpoint address required
;   On exit:  If successful NZ flagged
;             It can fail (Z flagged) if address is in monitor code
;             BC DE IX IY I AF' BC' DE' HL' preserved
BPReqSet:   CALL BPIsInMonitor  ;Is address HL in monitor code are
            RET  Z              ;Yes, so return with Z flagged
BPWrAddr:   LD   (iBPReq),HL    ;Store as requested BP address
            RET                 ;Return NZ for successfully Set 


; Breakpoint: Jump here for Go command
BPGo:       XOR  A              ;Set for breakpoint mode
            LD   (iBPType),A    ;  not single step mode
            LD   HL,(iBPReq)    ;Get requested breakpoint address
            CALL BPSet          ;Set the requested breakpoint 
            JP   BPRestore      ;Restore registers from variables


; Breakpoint: Jump here for Step command
BPStep:     LD   A,1            ;Set for single step mode
            LD   (iBPType),A    ;  not breakpoint mode
            LD   HL,(iPC)       ;Get next instruction address
            CALL BPSet          ;Set the requested breakpoint 
            JP   BPRestore      ;Restore registers from variables


; **********************************************************************
; **  Private functions                                               **
; **********************************************************************


; Breakpoint: Set breakpoint
;   On entry: HL = Address of breakpoint
;   On exit:  If successful A = 0 and Z flagged
;               otherwise A != 0 and NZ flagged
;             BC DE HL IX IY I AF' BC' DE' HL' preserved
; Failure can occur when trying to set breakpoint to address which is 
; not RAM.
BPSet:      CALL BPClear        ;Ensure previous breakpoint removed
            LD   A,H            ;Check if requested address is 0x0000
            OR   L              ;  and if so abort as nothing to do
            RET  Z
            LD   A,(HL)         ;Get contents of breakpoint address
            LD   (iBPData),A    ;Store as breakpoint data
            LD   (HL),kBPOpcode ;Write breakpoint opcode to address
            LD   A,(HL)         ;Read back to see if in RAM
            CP   kBPOpcode      ;Is it the breakpoint opcode?
            JR   NZ,@Failure    ;No, so failed to set
            LD   (iBPAddr),HL   ;Store requested breakpoint address
            XOR  A              ;Return success A = 0 and Z flagged
            RET
@Failure:   LD   A,0xFF         ;Return failure A != 0 and NZ flagged
            OR   A
            RET


; Breakpoint: Clear breakpoint
;   On entry: No parameters required
;   On exit:  AF BC DE HL IX IY I AF' BC' DE' HL' preserved
BPClear:    PUSH AF
            PUSH HL
            LD   HL,(iBPAddr)   ;Get current breakpoint address
            LD   A,L            ;Test if breakpoint address is 0xFFFF
            AND  H              ;If it is 0xFFFF then breakpoint is not set
            CP   0xFF           ;Breakpoint set?
            JR   Z,@ClrData     ;No, so skip breakpoint clear
            LD   A,(HL)         ;Test if breakpoint contains breakpoint opcode
            CP   kBPOpcode      ;If it is then breakpoint is not set
            JR   NZ,@ClrAddr    ;No, so skip breakpoint clear
; Breakpoint is currently set, so restore memory contents and clear BP
            LD   A,(iBPData)    ;Restore original contents of memory at current
            LD   (HL),A         ;  breakpoint address to remove breakpoint opcode
@ClrAddr:   LD   HL,0xFFFF      ;Get value indicating break address is not set
            LD   (iBPAddr),HL   ;Store as breakpoint address to incicate not set
@ClrData:   LD   A,kBPOpcode    ;Get value indicating break data is not set
            LD   (iBPData),A    ;Store as breakpoint data to incicate not set
            POP HL
            POP AF
            RET


; Breakpoint: Is address in monitor code space?
;   On entry: HL = Memory address to be tested
;   On exit:  If address is in monitor code Z flagged
;               otherwise NZ flagged
;             BC DE HL IX IY I AF' BC' DE' HL' preserved
; Only test the most significant byte of the address. This is fine
; for the start of the monitor code which is assumed to be on a 256
; byte boundary. But the end of the monitor code will be treated as
; entending to the end of the 256 byte boundry it is in.
BPIsInMonitor:
            LD   A,H            ;Get hi byte of address to be tested
            OR   A              ;Is it 0x00? (address 0x0000 to 0x00FF
            RET  Z              ;Yes, so return Z
; H is not 0x00
            LD   A,(kaCodeEnd)  ;CodeEnd\256
            CP   H              ;Compare with hi byte of address
;           RET  Z              ;Return Z if H = monitor end
            RET  C              ;Return NZ if > monitor end
; H is now known to be less than or equal to monitor end address
            LD   A,(kaCodeBeg)  ;CodeBegin\256
            CP   H              ;Compare with hi byte of address
            RET  Z              ;Return Z if H = monitor start
            RET  NC             ;Return NZ if H < monitor start
; H is now known to be greater than monitor start (also H <= end)
            XOR  A              ;Return Z as address in monitor code
            RET


; **********************************************************************
; **  Constant data                                                   **
; **********************************************************************

szBreak:    .DB  "Breakpoint",kNewLine,kNull
szTrap:     .DB  "Trap",kNewLine,kNull
szOver:     .DB  "Stepping over code in ROM or in monitor",kNewLine,kNull


; **********************************************************************
; **  Private workspace (in RAM)                                      **
; **********************************************************************

            .DATA

iBPAddr:    .DW  0x0000         ;Breakpoint address
iBPData:    .DB  0x00           ;Breakpoint data (contents of BP address)
iBPType:    .DB  0x00           ;Breakpoint type: 0=Once, 1=Step
iBPReq:     .DW  0x0000         ;Breakpoint address request


; To set a breakpoint or single step break, call xxx 
; This address is held in iBPReq.
; When a program run or continue is required...


; Instructions which can change flow of code (ie. alter PC)
;   DJNZ d          10 nn      0001 0000
;   JR   d          18 nn      0001 1000
;   JR   c,  d      xx nn      001c c000
;   JP   nn         C3 nn nn   1100 0011
;   JP   cc, nn     xx nn nn   11cc c010
;   JP   HL         E9         1110 1001
;   JP   IX         DD E9      1110 1001
;   JP   IY         FD E9      1110 1001
;   CALL nn         CD nn nn   1100 1101
;   CALL cc, nn     xx nn nn   11cc c100
;   RET             C9         1100 1001
;   RET  cc         xx         11cc c000
;   RETI            ED 4D      0100 1101
;   RETN            ED 45      0100 0101
;   RST  aa         xx         11tt t111
; Also an interrupt or reset signal changes PC


; **********************************************************************
; **  End of Breakpoint module                                        **
; **********************************************************************















