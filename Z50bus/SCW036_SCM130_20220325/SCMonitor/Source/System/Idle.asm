; **********************************************************************
; **  Idle events                               by Stephen C Cousins  **
; **********************************************************************

; This module handles the idle events.
;
; When the processor is not busy it repeatedly calls the idle handler.
; By default this is just a return instruction, but the system can be 
; configured to call IdlePoll instead. See API function 0x13.
;
; IdlePoll tries to emulate a timer interrupt and issues timer events
; at specified multiples 1 ms, 10 ms or 100 ms. Due to the lack of 
; hardware timer as standard in a typical small computer system (such 
; as RC2014) this function does not produce accurately timed events.
; Systems with a hardware timer, such as LiNC80, sync the idle events
; to the timer for better accuracy.
;
; Timer events are issued via the jump table to allow them to be
; directed anywhere required. Events are NOT issued from within an
; interrupt routine, but are simply subroutine calls made from within 
; system functions like Console Input. 
;
; Timer event handlers must preserve all registers except AF and HL,
; which are already preserved on the stack.
;
;
; Public functions provided
;   IdleConfig            Configure idle event handler
;   IdlePoll              Poll idle events
;   IdleTimer1            Set up Timer 1 event in multiples of 1 ms
;   IdleTimer2            Set up Timer 1 event in multiples of 10 ms
;   IdleTimer3            Set up Timer 1 event in multiples of 100 ms


; **********************************************************************
; **  Public functions                                                **
; **********************************************************************

            .CODE

; Idle: Configure idle events
;   On entry: A = Configuration:
;                 0 = Off (just execute RET instruction)
;                 1 = Software generated timer events
;                 2+ = Future expansion
;   On exit:  IX IY I AF' BC' DE' HL' preserved
IdleConfig: PUSH AF
            LD   A,1            ;Set timers to roll over soon
            LD   (iIdleT1),A
            LD   (iIdleT2),A
            LD   (iIdleT3),A
            POP  AF
            JP   HW_IdleSet     ;Pass to BIOS


; Idle: Poll idle events
;   On entry: No parameters required
;   On exit:  AF BC DE HL IX IY I AF' BC' DE' HL' preserved
; Registers must be preserved by this function
IdlePoll:   PUSH AF
            CALL JpIdle         ;Poll timer
            JR   NZ,@Event1ms   ;Skip if 1ms event to process
            POP  AF             ;  otherwise exit now
            RET
; 1 ms tick (we arrive here approximately 1000 times each second)
@Event1ms:  PUSH BC             ;Preserve BC
            PUSH DE             ;Preserve DE
            PUSH HL             ;Preserve HL
            LD   HL,iIdleT1     ;Point to timer 1
            DEC  (HL)           ;Decrement timer 1
            JR   NZ,@IdleT1end  ;Skip if not zero
            LD   A,(iIdleP1)    ;Get period for timer 1
            LD   (HL),A         ;Reset timer 1
            CALL JpTimer1       ;Call n x 1 ms timer event handler
@IdleT1end: LD   HL,iIdleMS     ;Point to millisecond counter
            DEC  (HL)           ;Decrement millisecond counter
            JR   NZ,@IdleExit   ;Not zero so exit
; 10 ms tick (we arrive here approximately 100 times each second)
            LD   (HL),10        ;Reset millisecond counter to 10
            LD   HL,iIdleT2     ;Point to timer 2
            DEC  (HL)           ;Decrement timer 2
            JR   NZ,@IdleT2end  ;Skip if not zero
            LD   A,(iIdleP2)    ;Get period for timer 2
            LD   (HL),A         ;Reset timer 2
            CALL JpTimer2       ;Call n x 10 ms timer event handler
@IdleT2end: LD   HL,iIdleCS     ;Point to centisecond counter
            DEC  (HL)           ;Decrement centisecond counter
            JR   NZ,@IdleExit   ;Not zero so exit
; 100 ms tick (we arrive here approximately 10 times each second)
            LD   (HL),10        ;Reset centisecond counter to 10
            LD   HL,iIdleT3     ;Point to timer 3
            DEC  (HL)           ;Decrement timer 3
            JR   NZ,@IdleExit   ;Skip if not zero
            LD   A,(iIdleP3)    ;Get period for timer 3
            LD   (HL),A         ;Reset timer 3
            CALL JpTimer3       ;Call n x 100 ms timer event handler
@IdleExit:  POP  HL             ;Restore HL
            POP  DE             ;Restore DE
            POP  BC             ;Restore BC
            POP  AF
            RET


; Idle: Set up timer 1 / 2 / 3
;   On entry: A = Time period in units of 1 ms / 10 ms / 100 ms
;             DE = Address of timer event handler
;   On exit:  AF BC DE HL IX IY I AF' BC' DE' HL' preserved
IdleTimer1: LD   C,1            ;Timer 1 (resolution 1 ms) 
            JR   IdleSetUp
IdleTimer2: LD   C,2            ;Timer 2 (resolution 10 ms) 
            JR   IdleSetUp
IdleTimer3: LD   C,3            ;Timer 3 (resolution 100 ms) 
; Set up timer number C (1 to 3)
IdleSetUp:  LD   B,0
            LD   HL,iIdleT1-2   ;Start of timer and period data
            ADD  HL,BC          ;Calculate address of timer data
            ADD  HL,BC          ;  which take two bytes each
            LD   (HL),A         ;Store timer value
            INC  HL             ;Point to period value
            LD   (HL),A         ;Store period value
            LD   A,C            ;Get timer number
            ADD  A,kFnTimer1-1  ;Calculate jump table entry number
            JP   ClaimJump      ;Write handler address to jump table


; **********************************************************************
; **  Private functions                                               **
; **********************************************************************


; **********************************************************************
; **  Private workspace (in RAM)                                      **
; **********************************************************************

            .DATA

; Cycle counting variables
iIdleMS:    .DB  0              ;Millisecond counter
iIdleCS:    .DB  0              ;Centisecond counter

; Periods and timers
; Each timer has a period value and a count down timer value
; WARNING: Do not change order as hard coded (above)
iIdleT1:    .DB  0              ;Timer 1 (resolution = 1 ms)
iIdleP1:    .DB  0              ;Period 1 (resolution = 1 ms)
iIdleT2:    .DB  0              ;Timer 2 (resolution = 10 ms)
iIdleP2:    .DB  0              ;Period 2 (resolution = 10 ms)
iIdleT3:    .DB  0              ;Timer 3 (resolution = 100 ms)
iIdleP3:    .DB  0              ;Period 3 (resolution = 100 ms)


; **********************************************************************
; **  End of Idle events module                                       **
; **********************************************************************











