; **********************************************************************
; **  BIOS Frwamework (optional)                by Stephen C Cousins  **
; **********************************************************************

; This is an optional framework for the SCM BIOS.
;
; WARNING: Z80 SIO port A must be an odd numbered console devices
;          Z80 SIO port B must be an even numbered console devices
;          Same for other serial devices with two channels


; **********************************************************************
; Ensure we assemble to code area

            .CODE


; **********************************************************************
; Initialise BIOS and hardware
;   On entry: No parameters required
;   On exit:  AF BC DE HL not specified
;             IX IY I AF' BC' DE' HL' preserved
; Identify and initialise console devices:
;   Console device 1 = Serial Z80 SIO port A
;                   or Serial ACIA number 1
;   Console device 2 = Serial Z80 SIO port B
;   Console device 3 = Serial ACIA number 2
;   Console device 6 = Serial bit-bang port
; Sets up hardware present flags:
;   Bit 0 = ACIA #1 
;   Bit 1 = SIO #1
;   Bit 2 = ACIA #2
;   Bit 3 = Bit-bang serial
;   Bit 4 = CTC #1
;   Bit 5 = SIO #2 
;   Bit 6 = CTC #2
;   Bit 7 = Z180 serial (or other serial device)
F_Init:     XOR   A
            LD   (iHwFlags),A   ;Clear hardware flags
            LD   (iTemp),A      ;Clear console device count
            LD   (iTemp2),A     ;Clear interface counter
            LD   HL,iInterface  ;Clear console device interface
            LD   B,6+2          ;  list and detection flags
@Clear:     LD   (HL),0
            INC  HL
            DJNZ @Clear
            LD   HL,Interfaces  ;Start of supported interfaces list
; HL = Pointer into list of interface device descriptor addresses
@Loop:      LD   E,(HL)         ;Get address of
            INC  HL             ;  interface descriptor...
            LD   D,(HL)
            INC  HL
            LD   A,D            ;End of table?
            OR   E              ;  indicated by address = 0
            RET  Z              ;Yes, so return
; For each interface in the interface list...
; DE = Address of current interface device descriptor
; HL = Pointer into list of interface device descriptor addresses
            PUSH HL             ;Preserve HL
            LD   HL,iTemp2      ;Point to interface counter
            INC  (HL)           ;Increment interface counter
            EX   DE,HL          ;HL = Interface descriptor address
            INC  HL             ;Point to string address lo byte
            INC  HL             ;Point to string address hi byte
; Try to detect and initialise this interface device
            INC  HL             ;Point to init code address lo byte
            LD   E,(HL)         ;Get init code address lo bye
            INC  HL             ;Point to init code address hi byte
            LD   D,(HL)         ;Get init code address hi bye
            PUSH HL             ;Preserve HL (ptr into descriptor)
            CALL @Init          ;Call initialisation code (at DE)
            POP  HL             ;Restore HL (ptr into descriptor)
            JR   NZ,@Next       ;Not found, so skip
; We have detected this interface device hardware and initialised it
; Update hardware flags
            INC  HL             ;Point to hardware flags mask
            LD   A,(iHwFlags)   ;Get current hardware flags
            OR   (HL)           ;Merge with flags for this device
            LD   (iHwFlags),A   ;Store updated hardware flags
; Update interface detected flags
            LD   A,(iTemp2)     ;Get interface counter
            LD   B,A            ;B = Interface counter
            CALL GetMaskDE      ;Get bit mask for this interface 
            LD   A,(iDetect)    ;Merge with interface 
            OR   E              ;  detect flags...
            LD   (iDetect),A
            LD   A,(iDetect+1)
            OR   D
            LD   (iDetect+1),A
; Set up jump table entries for this interface device
            INC  HL             ;Point to settings code lo byte
            INC  HL             ;Point to settings code hi byte
            INC  HL             ;Point to number of channels
            LD   A,(HL)         ;Skip if this interface has
            OR   A              ;  no console channels...
            JR   Z,@Next
            LD   C,(HL)         ;Get number of channels
            INC  HL             ;Point to vector list
@Chan:      LD   A,(iTemp)      ;Get console device count
            CP   6              ;Already have maximum of 6 console devices?
            JR   Z,@Next        ;Yes, so skip setting jump table
            INC  A              ;Increment console device count
            LD   (iTemp),A      ;Store console device count
            ADD  A,A            ;Calculate jump table
            ADD  A,kFnDev1In-2  ;  entry number
            LD   B,2            ;Set up jump table for Rx and Tx
            CALL InitJumps      ;Set up console device vectors, preserves all
            CALL @StoreNum      ;Store interface number, preserves BC, HL
            INC  HL             ;Point to vectors for next
            INC  HL             ;  channel in descriptor
            INC  HL
            INC  HL
            DEC  C              ;Decrement channel count
            JR   NZ,@Chan       ;Go set up next channel
; Go consider next interface device descriptor
@Next:      POP  HL             ;Restore HL
            JR   @Loop

; Jump to initialisation subroutine at address held in DE
@Init:      EX   DE,HL          ;HL = Address of init code
            JP   (HL)           ;Run initialisation code

; Store interface descriptor number for this console device
; iTemp = Console device number 1 to 6
; iTemp2 = Interface descriptor number 1 to N
@StoreNum:  PUSH HL
            LD   HL,iInterface-1  ;Start of console device interface list
            LD   A,(iTemp)      ;Get console device number
            LD   E,A            ;Calculate location in console
            LD   D,0            ;  device interface list...
            ADD  HL,DE
            LD   A,(iTemp2)     ;Get interface descriptor number
            LD   (HL),A         ;Store interface descriptor number
            POP  HL
            RET


; **********************************************************************
; Set baud rate
;   On entry: A = Baud rate code (1 to 12, or two digit eg. 0x96)
;             C = Console device number (1 to 6)
;   On exit:  IF successful: (ie. valid device and baud code)
;               A != 0 and NZ flagged
;             BC DE HL not specified
;             IX IY I AF' BC' DE' HL' preserved
; Baud rate codes can be in either of these formats:
;   1 to 12 (1 = 230400 baud, ... , 12 = 300 baud)
;   Two digit code, such as 0x96 for 9600 baud
F_SetBaud:  CALL @Normalise     ;Convert baud code to 1 to 12 format
            RET  Z              ;Invalid baud rate so return failure
; Test if the device number is valid
; A = B = Baud rate code (1 to 12)
; C = Console device number (1 to 6)
            LD   A,C            ;Verify legitimate device...
            OR   A              ;Device = 0?
            RET  Z              ;Yes, so abort (Z flagged)
            CP   7              ;Device > 6?
            JR   C,@Valid       ;No, so valid devcie
            XOR  A              ;Yes, so abort (Z flagged)
            RET
; Find interface number for this console device
; B = Baud rate code (1 to 12)
; C = Console device number (1 to 6)
@Valid:     LD   HL,iInterface-1  ;Start of interface number list
            LD   A,C            ;Console device number
@Find:      INC  HL             ;Increment pointer to the  >>> TODO use ADD HL,DE
            DEC  A              ;  required interface device number
            JR   NZ,@Find
            LD   A,(HL)         ;Get interface device number
            OR   A              ;Interface assigned?
            RET  Z              ;No, so baud setting has failed
; Find interface descriptor for this interface number
; A = Interface device number (1 to N)
; B = Baud rate code (1 to 12)
; C = Console device number (1 to 6)
            LD   HL,Interfaces-2  ;Start of supported interfaces list
@LoopIS:    INC  HL             ;Point to next descriptor address
            INC  HL
            DEC  A
            JR   NZ,@LoopIS     ;Repeat until required pointer
            LD   E,(HL)         ;Get address of
            INC  HL             ;  interface descriptor...
            LD   D,(HL)
; Find interface settings code address
            LD   HL,6           ;Offset to setting code address
            ADD  HL,DE          ;HL = Address of settings vector
            LD   E,(HL)         ;Get settings code address lo byte
            INC  HL             ;Point to high byte of vector
            LD   D,(HL)         ;Get settings code address hi byte
; Jump to interface code at address in DE
; B = Baud rate code (1 to 12)
; C = Console device number (1 to 6)
            LD   A,1            ;Specify baud rate setting request
            EX   DE,HL          ;HL = Address of settings subroutine
            JP   (HL)           ;Run initialisation code

; Normalise baud rate code
;   On entry: A = Baud rate code (1 to 12, or two digit eg. 0x96)
;   On exit:  IF successful: (ie. valid baud code) 
;               NZ flagged and A != 0
;               A = B = Baud rate code (1 to 12)
;             If unsuccessful: (ie. invalid baud code)
;               Z flagged and A = 0
;               A = B = 0
;             C DE HL IX IY I AF' BC' DE' HL' preserved
; Baud rate codes can be supplied in either of these formats:
;   1 to 12 (1 = 230400 baud, ... , 12 = 300 baud)
;   Two digit code, such as 0x96 for 9600 baud
; This function returns code in the format 1 to 12, or 0 if an 
; invalid baud rate code is specified
@Normalise: PUSH HL
            LD   HL,@BaudRates  ;List of baud rate codes
            LD   B,12           ;Number of table entries
@Search:    CP   (HL)           ;Record for required baud rate?
            JR   Z,@GotIt       ;Yes, so go get time constant
            CP   B              ;Record number = baud rate code?
            JR   Z,@GotIt       ;Yes, so go get time constant
            INC  HL             ;Point to next baud rate code
            DJNZ @Search        ;Repeat until end of table
@GotIt:     POP  HL
            LD   A,B            ;A = B = Baud rate code (1 to 12)
            OR   A              ;  or A = B = 0 for failure
            RET                 ;  NZ flagged  is successful

; Baud rate table 
; Position in table matches value of short baud rate code (1 to 11)
; First column in the table is the long baud rate code
; Second column is the CTC time constant value
@BaudRates: .DB  0x30           ;12 =    300 baud
            .DB  0x60           ;11 =    600 baud
            .DB  0x12           ;10 =   1200 baud
            .DB  0x24           ; 9 =   2400 baud
            .DB  0x48           ; 8 =   4800 baud
            .DB  0x96           ; 7 =   9600 baud
            .DB  0x14           ; 6 =  14400 baud
            .DB  0x19           ; 5 =  19200 baud
            .DB  0x38           ; 4 =  38400 baud
            .DB  0x57           ; 3 =  57600 baud
            .DB  0x11           ; 2 = 115200 baud
            .DB  0x23           ; 1 = 230400 baud


; **********************************************************************
; Output devices message
;   On entry: No parameters required
;   On exit:  AF BC DE HL not specified
;             IX IY I AF' BC' DE' HL' preserved
; List all supported interface devices followed by current console devices
F_MsgDevs:  LD   DE,@sSupport   ;Point to "Supported devices" string
            CALL OutputStr      ;Output string
            LD   HL,Interfaces  ;Start of supported interfaces list
            LD   B,0            ;Interface descriptor count
@Loop:      LD   E,(HL)         ;Get address of
            INC  HL             ;  interface descriptor...
            LD   D,(HL)
            INC  HL
            LD   A,D            ;End of table?
            OR   E              ;  indicated by address = 0
            JR   Z,@Console     ;Yes, so go list console devices
; For each interface in the interface list...
            PUSH HL             ;Preserve HL
            EX   DE,HL          ;HL = Interface descriptor address
            INC  HL             ;Point to string address lo byte
            LD   DE,@sPrefix    ;Point to prefix string
            CALL OutputStr      ;Output prefix string
            LD   E,(HL)         ;Get string address lo bye
            INC  HL             ;Point to string address hi byte
            LD   D,(HL)         ;Get string address hi bye
;           CALL OutputStr      ;Output interface description
            CALL @OutputIS      ;Output interface string
; Append " not detected" or " detected"
            INC  B              ;Increment interface count
            CALL GetMaskDE      ;Get bit mask for interface #B
            LD   A,(iDetect)    ;Test to see if this bit is set
            AND  E              ;  in the interface detect flags...
            JR   NZ,@Detected
            LD   A,(iDetect+1)
            AND  D
            JR   NZ,@Detected
            LD   DE,@sNoDetect  ;Pointer to " not detected" string
            JR   @Output
@Detected:  LD   DE,@sDetected  ;Pointer to " detected" string
@Output     CALL OutputStr      ;Output interface description string
            POP  HL
            JR   @Loop
; List console devices
@Console:   LD   DE,@sConsole   ;Point to "Console devices"
            CALL OutputStr      ;Output string
            LD   C,0            ;Console device number (1 to 6)
@NextDev:   INC  C              ;Increment console device number
            LD   A,C            ;Get consolde device number
            CP   7              ;All done?
            RET  Z              ;Yes, so return
; Get interface number for this console device
            LD   HL,iInterface-1  ;Start of interface number list
            LD   B,C            ;Console device number
@Find:      INC  HL             ;Increment pointer to the
            DJNZ @Find          ;  required interface device number
            LD   A,(HL)         ;Get interface device number
            OR   A              ;Interface assigned?
            JR   Z,@NextDev     ;No, so go try next console device
            LD   B,A            ;Remember interface device number
            LD   A,C            ;Get console device number
            ADD  '0'            ;Convert device number to ASCII char
            CALL OutputChr      ;Output ASCII character
            LD   DE,@sEquals    ;Point to " = "
            CALL OutputStr      ;Output string
; Find interface device #B string and output it
            PUSH BC
            PUSH HL
            LD   HL,Interfaces-2  ;Start of supported interfaces list
; Find address of interface descriptor #B
@LoopIS:    INC  HL             ;Point to next descriptor address
            INC  HL
            DJNZ @LoopIS        ;Repeat until required pointer
            LD   E,(HL)         ;Get address of
            INC  HL             ;  interface descriptor...
            LD   D,(HL)
; Get pointer to interface string
            EX   DE,HL          ;HL = Interface descriptor address
            INC  HL             ;Point to string address lo byte
            LD   E,(HL)         ;Get string address lo bye
            INC  HL             ;Point to string address hi byte
            LD   D,(HL)         ;Get string address hi bye
;           CALL OutputStr      ;Output interface description
            POP  HL
            POP  BC
            CALL @OutputIS      ;Output interface string
            CALL OutputNL       ;Output new line
            JR   @NextDev

; Output interface string for specific interface number
; On entry: DE = Start of interface string
;                eg. "Z80 SIO @ A8", kNull
; On exit:  BC DE HL IX IY I AF' BC' DE' HL' preserved
; The source string (eg. "Z80 SIO @ A8", kNull) is output with the
; '@' character at a fixed column making it more easily readable.
@OutputIS:  PUSH BC
            PUSH DE
            PUSH HL
;           CALL OutputStr      ;Output interface description
            LD   B,17           ;Column for '@' character
@OutputLp:  LD   A,(DE)         ;Get character from string
            CP   '@'            ;Is character = '@' ?
            JR   Z,@OutputAt    ;Yes, so go TAB to position
            CALL OutputChr      ;Output character
            INC  DE             ;Point to next character in string
            DJNZ @OutputLp      ;Any more characters before '@'
            INC  B              ;String too long so output 1 space
; TAB to required position and then output '@' and anything following it
@OutputAt:  LD   A,' '          ;Output spaces to required column
            CALL OutputChr      ;Output space character
            DJNZ @OutputAt      ;Repeat until required position
            LD   A,(DE)         ;Get '@' character from string
@OutputCh:  CALL OutputChr      ;Output character
            INC  DE             ;Point to next character in string
            LD   A,(DE)         ;Get character from string
            OR   A              ;End of string?
            JR   NZ,@OutputCh   ;No, so repeat
            POP  HL
            POP  DE
            POP  BC
            RET
            
@sSupport:  .DB  "Supported devices: ",kNewLine,kNull
@sPrefix:   .DB  "  = ",kNull
@sConsole:  .DB  "Console devices: ",kNewLine,kNull
@sDetected: .DB  "  detected"
@sNoDetect: .DB  kNewLine,kNull
@sEquals:   .DB  " = ",kNull

; Alternative strings that says "detected" or "not detected"
;@sNoDetect:                    .DB  "  not"
;@sDetected:                    .DB  "  detected",kNewLine,kNull


; **********************************************************************
; Support functions

; Get interface detection bit mask for interface number # (1 to 16)
; For interface device 1 the mask will be 0b0000000000000001,
; For interface device 2 the mask will be 0b0000000000000010, etc.
; On entry: B = Interface device number 1 to 16
; On exit:  DE = Bit mask for this interface
;           A BC HL IX IY I AF' BC' DE' HL' preserved
GetMaskDE:  PUSH BC
            LD   DE,0           ;Initial blank bit mask
            SCF                 ;Set carry flag
@Rotate:    RL   E              ;Rotate left
            RL   D
            DJNZ @Rotate
            POP  BC
            RET


; **********************************************************************
; **  Public workspace (in RAM)                                       **
; **********************************************************************

            .DATA

iTemp:      .DB  0              ;Temporary value
iTemp2:     .DB  0              ;Temporary value

; WARNING: iDetect must immediately follow iInterface (HARD CODED)
iInterface: .DW  0,0,0          ;Interface number for each console device
iDetect:    .DW  0              ;Interface detected flags

            .CODE





