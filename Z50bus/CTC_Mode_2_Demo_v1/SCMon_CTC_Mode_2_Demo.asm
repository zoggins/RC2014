; **********************************************************************
; **  CTC Mode 2 Interrupt Demo                 by Stephen C Cousins  **
; **********************************************************************

; This code demonstrates how to generate a periodic mode 2 interrupt 
; using a Z80 CTC.

; CTC channel 1 is set to generate an interrupt every 5 ms
;   Input clock is 7.3728 MHz
;   Prescaler = 256
;   Timer reload value = 144
;   Interrupt frequency = 7372800 / 256 / 144 = 200 Hz

; The interrupt vector table starts at 0x8200 and are used as follows:
;   0x8200-8201  Interrupt vector for CTC channel 0
;   0x8202-8203  Interrupt vector for CTC channel 1
;   0x8204-8205  Interrupt vector for CTC channel 2
;   0x8206-8207  Interrupt vector for CTC channel 3

            .PROC Z80           ;SCWorkshop select processor

ctc:        .EQU 0x88           ;Base I/O address for CTC

reload:     .EQU 144            ;CTC timer reload value

counter:    .EQU 0x8100         ;Counter in RAM

vectors:    .EQU 0x8200         ;Interrupt vector table in RAM

            .ORG 0x8000         ;Program code starts here

; Initialise interrupt vector table entry for CTC channel 1
            LD   HL,CTC_Int     ;CTC channel 1 interrupt routine
            LD   (vectors+2),HL ;Interrupt vector for CTC channel 1

; Initialise Z80 for interrupt mode 2
            LD   A,vectors\256  ;Get hi byte of int vector table address
            LD   I,A            ;Set Z80's int vector table address (hi)
            IM   2              ;Set interrupt mode 2

; CTC channel control register
;   Bit 7:   Interrupt     1 = Enable   0 = Disable
;   Bit 6:   Mode          1 = Counter  0 = Timer
;   Bit 5:   Prescaler     1 = 256      0 = 16        (timer mode only)
;   Bit 4:   Edge select   1 = Rising   0 = Falling
;   Bit 3:   Time trigger  1 = CLK/TRG  0 = Auto when time const loaded
;   Bit 2:   Time constant 1 = Follows  0 = Continue operation
;   Bit 1:   Reset         1 = Reset    0 = Continue operation
;   Bit 0:   Control/vect  1 = Control  0 = Vector

; CTC interrupt vector register
;   Bit 7-3: Bits 7-3 of int vector address lo byte for chan 0
;   Bit 2-1: Channel identifier  00=chan 0, ... , 11=chan 3
;   Bit 0:   Control/vect    1 = Control  0 = Vector   

; Initialise CTC channel 1 interrupt vector
            LD   A,0b00000000   ;Set int vector for the CTC
            OUT  (ctc),A

; Initialise CTC channel 1 for periodic timer
            LD   A,0b00110101   ;Timer with 256 prescaler
            OUT  (ctc+1),A
            LD   A,reload       ;Time constant = N x prescaler o/p
            OUT  (ctc+1),A

; Enable interrupts from channel 1 periodic timer
            LD   A,0b10110001   ;Timer with 256 prescaler
            OUT  (ctc+1),A

; Enable interrupts and return to SCM command line interpreter
            EI                  ;Enable interrupts
;           RET                 ;Return to Small Computer Monitor

; Test code to output '*' every time counter reaches 1 second
@Wait:      LD   A,(counter)    ;Wait for counter value = 200
            CP   200            ;  which is 200 x 5 ms = 1s
            JR   NZ,@Wait
            XOR  A              ;Reset counter to zero
            LD   (counter),A
            LD   A,'*'          ;Output '*' to terminal
            LD   C,2            ;  using SCM's API function 2
            RST  0x30           ;  RST 30 is call to SCM's API
            JR   @Wait


; CTC interrupt routine
; This routine increments (counter) every time it runs
CTC_Int:    PUSH AF             ;Preserve AF
            LD   A,(counter)    ;Read current counter
            INC  A              ;Increment counter
            LD   (counter),A    ;Store updated counter
            POP  AF             ;Restore AF
            EI                  ;Enable interrupts
            RETI                ;Return from interrupt


