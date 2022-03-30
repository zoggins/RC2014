; **********************************************************************
; **  Device Driver                             by Stephen C Cousins  **
; **  Hardware:  Generic                                              **
; **  Interface: Z80 CTC                                              **
; **********************************************************************

; This SCM BIOS framework compliant driver for a Z80 CTC (counter timer)

; CTC addressing: 
;   CTC CS0 line = A0, CTC CS1 line = A1, Base address = kCTC_n1
; BaseAddress+0   Channel 0 (read and write)
; BaseAddress+1   Channel 1 (read and write)
; BaseAddress+2   Channel 2 (read and write)
; BaseAddress+3   Channel 3 (read and write)
;
; Channel control register:
; Bit 7 = Interrupt: 1 = enable, 0 = disable
; Bit 6 = Mode: 1 = counter, 0 = timer
; Bit 5 = Prescaler (timer mode only): 1 = 256, 0 = 16
; Bit 4 = Edge selection: 1 = rising, 0 = falling
; Bit 3 = Time trigger (timer mode only): 1 = input, 0 = auto
; Bit 2 = Time constant: 1 = value follow, 0 = does not
; Bit 1 = Reset: 1 = software reset, 0 = continue
; Bit 0 = Control/vestor: 1 = control, 0 = vector

; Externally definitions required:
;kDevBase:  .EQU 0x88           ;Base address of Z80 CTC
;kDevFlags: .SET 0b00010000     ;Hardware flags = CTC #1
;kDevTick:  .SET 3              ;Channel (0 to 3) for 200Hz tick


            .CODE


; **********************************************************************
; SCM BIOS framework interface descriptor

            .DB  0              ;Device ID code (not currently used)
            .DW  @String        ;Pointer to device string
            .DW  @CTC_Init      ;Pointer to initialisation code
            .DB  kDevFlags      ;Hardware flags bit mask
            .DW  @CTC_Set       ;Point to device settings code
            .DB  0              ;Number of console devices
@String:    .DB  "Z80 CTC "
            .DB  "@ "
            .HEXCHAR kDevBase \ 16
            .HEXCHAR kDevBase & 15
            .DB  kNull


; **********************************************************************

; CTC initialise
;   On entry: No parameters required
;   On exit:  Z flagged if device is found and initialised
;             AF BC DE HL not specified
;             IX IY I AF' BC' DE' HL' preserved
; If the device is found it is initialised
@CTC_Init:  CALL @CTC_Test      ;Returns NZ if CTC found
            JR   NZ,@Found      ;Skip of found
; Device has not been detected
            OR   A,0xFF         ;Return not found (NZ flagged)
            RET
; Device has been detected so initialise it
; Set specified channel to generate a 200 Hz clock tick
@Found:
#IFDEF      CTC_CLK_7372800
; Generate 200 Hz clock tick from CPU clock of 7.3728 MHz
; This uses timer mode to select the CPU clock as the source
; Channel at <kDevTick> is set for 200Hz interval, interrupt not enabled
            LD   A,0b00110101   ;Timer: 7372800Hz/256 = 28800Hz
            OUT  (kDevTick),A   ;Write channel's control register
            LD   A,144          ;28800Hz/144 = 200 Hz
            OUT  (kDevTick),A   ;Write channel's time base
#ENDIF
#IFDEF      CTC_CLK_1843200
; Generate 200 Hz clock tick from local oscillator of 1.8432 MHz
; This uses counter mode to select the local oscillator as the source
; Two channels must be daisy chained to get 200Hz from 1.8432MHz as
; counter mode does not have a prescaler
; Channel at <kDevTick> is set for 28800Hz interval, interrupt not enabled
; Channel at <kDevTick+1> is set for 200Hz interval, interrupt not enabled
            LD   A,0b01110101   ;Count: 1843200Hz/1 = 1843200Hz
            OUT  (kDevTick),A   ;Write channel's control register
            LD   A,64           ;Count: 1843200Hz/64 = 28800 Hz
            OUT  (kDevTick),A   ;Write channel's time base
            LD   A,0b01110101   ;Count: 28800Hz/144 = 200 Hz
            OUT  (kDevTick+1),A ;Write channel's control register
            LD   A,144          ;Count: 28800Hz/144 = 200 Hz
            OUT  (kDevTick+1),A ;Write channel's time base
#ENDIF
            XOR  A              ;Return Z flag as device found
            RET


; This routine tests in a CTC is present at the address kDevBase
; The test sets CTC channel 3 for fast counting and checks the 
; counter changes within a limited time
; Returns NZ is CTC is present
@CTC_Test:  LD   C,kDevBase+3   ;Channel 3's address
            LD   A,0b0010101    ;Timer: 7372800Hz/16 = 460kHz (2.2us)
            OUT  (C),A          ;Write to channel's control register
;           LD   A,<n>          ;460kHz/n = ? (n > 10 or so will do)
            OUT  (C),A          ;Write to channel's time base
            IN   A,(C)          ;Get 1st timer value
            LD   B,20           ;Delay
@Wait:      DJNZ @Wait          ;  by 10us or so
            LD   B,A            ;Store 1st timer value
            IN   A,(C)          ;Get 2nd timer value
            CP   B              ;Same? (same = no count occured)
            RET                 ;Return NZ if count changed


; Device settings
;   On entry: A = Property to set: 1 = Baud rate
;             B = Baud rate code
;             C = Console device number
;   On exit:  IF successful: (ie. valid device and baud code)
;               A != 0 and NZ flagged
;             BC DE HL not specified
;             IX IY I AF' BC' DE' HL' preserved
@CTC_Set:   XOR  A              ;Return failure as no setting supported
            RET


; **********************************************************************
; Only include the CTC baud rate setting code once
#IFNDEF     CTC_BAUD
#DEFINE     CTC_BAUD
; Set CTC to generate baud rate clock for SIO
;   On entry: B = Baud rate code (1 to 12)
;             C = CTC register address
;   On exit:  IF successful: (ie. valid device and baud code)
;               A != 0 and NZ flagged
;               D = Requested SIO divider (16 or 64)
;             BC DE HL not specified
;             IX IY I AF' BC' DE' HL' preserved
; Search for baud rate in table
; B = Baud rate code  (1 to 12)
; C = CTC register address
CTC_Baud:   LD   HL,@TimeCon-1  ;Start of time constant list (-1)
            LD   E,B            ;Baud rate code (1 to 12)
            LD   D,0
            ADD  HL,DE          ;Calculate table location
; Found location in table
; B = Baud code (1 to 12)
; C = CTC register address
; (HL) = Time constant value for CTC
@GotIt:     LD   A,0x55         ;Control register for baud rates
            OUT  (C),A          ;Write to CTC control register
            LD   A,(HL)         ;Get time constant
            OUT  (C),A          ;Write to time constant register
            LD   A,B            ;Get baud rate code (1 to 11)
            CP   7              ;Less than 7? (= baud rate > 9600)
            LD   D,64           ;Return SIO divide by 64 request
            JR   NC,@Return     ;No, so skip with divide 64 request
            LD   D,16           ;Return SIO divide by 16 request
@Return:    OR   0xFF           ;Return success (A=0xFF and NZ flagged)
            RET

; Time constant table (7.3728 MHz)
;  +----------+--------------+---------------+---------------+
;  |  Serial  |   Baud rate  |  CTC setting  |  CTC setting  |
;  |    Baud  |        code  |   SIO div 16  |   SIO div 64  |
;  +----------+--------------+---------------+---------------+
;  |  230400  |   1 or 0x23  |            1  |               |
;  |  115200  |   2 or 0x11  |            2  |               |
;  |   57600  |   3 or 0x57  |            4  |               |
;  |   38400  |   4 or 0x38  |            6  |               |
;  |   19200  |   5 or 0x19  |           12  |               |
;  |   14400  |   6 or 0x14  |           16  |               |
;  |    9600  |   7 or 0x96  |               |            6  |
;  |    4800  |   8 or 0x48  |               |           12  |
;  |    2400  |   9 or 0x24  |               |           24  |
;  |    1200  |  10 or 0x12  |               |           48  |
;  |     600  |  11 or 0x60  |               |           96  |
;  |     300  |  12 or 0x30  |               |          192  |
;  +----------+--------------+---------------+---------------+
#IFDEF      CTC_CLK_7372800
@TimeCon:   .DB  1              ; 1 = 230400 baud
            .DB  2              ; 2 = 115200 baud
            .DB  4              ; 3 =  57600 baud
            .DB  6              ; 4 =  38400 baud
            .DB  12             ; 5 =  19200 baud
            .DB  16             ; 6 =  14400 baud
            .DB  6              ; 7 =   9600 baud
            .DB  12             ; 8 =   4800 baud
            .DB  24             ; 9 =   2400 baud
            .DB  48             ;10 =   1200 baud
            .DB  96             ;11 =    600 baud
            .DB  192            ;12 =    300 baud
#ENDIF
#IFDEF      CTC_CLK_1843200
@TimeCon:   .DB  1              ; 1 = 230400 baud  n/a
            .DB  1              ; 2 = 115200 baud
            .DB  2              ; 3 =  57600 baud
            .DB  3              ; 4 =  38400 baud
            .DB  6              ; 5 =  19200 baud
            .DB  8              ; 6 =  14400 baud
            .DB  3              ; 7 =   9600 baud
            .DB  6              ; 8 =   4800 baud
            .DB  12             ; 9 =   2400 baud
            .DB  24             ;10 =   1200 baud
            .DB  48             ;11 =    600 baud
            .DB  96             ;12 =    300 baud
            ;.DB  0x15, 192      ;13 =    150 baud
#ENDIF
#ENDIF


; **********************************************************************
; **  End of driver                                                   **
; **********************************************************************










