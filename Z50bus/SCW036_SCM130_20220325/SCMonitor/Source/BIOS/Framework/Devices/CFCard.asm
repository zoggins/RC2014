; **********************************************************************
; **  Device Driver                             by Stephen C Cousins  **
; **  Hardware:  Generic                                              **
; **  Interface: Compact Flash Card                                   **
; **********************************************************************

; This module is the driver for a Compact Flash card using an 8-bit
; interface direct on the processor bus
;
; Externally definitions required:
;kCFBase: .EQU kCFBase          ;I/O base address

; Memory map
NumSectors: .EQU 24             ;Number of 512 sectors to be loaded
TempStack:  .EQU $8800          ;Temporary stack
LoadAddr:   .EQU $9000          ;CP/M load address
LoadBytes:  .EQU $3000          ;Length = 24 sectors * 512 bytes
LoadNext:   .EQU LoadAddr+LoadBytes
LoadTop:    .EQU LoadNext-1     ;Top of loaded bytes
CPMTop:     .EQU $FFFF          ;Top location used by CP/M


; CF registers
CF_DATA     .EQU kCFBase + 0
CF_FEATURES .EQU kCFBase + 1
CF_ERROR    .EQU kCFBase + 1
CF_SECCOUNT .EQU kCFBase + 2
CF_SECTOR   .EQU kCFBase + 3
CF_CYL_LOW  .EQU kCFBase + 4
CF_CYL_HI   .EQU kCFBase + 5
CF_HEAD     .EQU kCFBase + 6
CF_STATUS   .EQU kCFBase + 7
CF_COMMAND  .EQU kCFBase + 7
CF_LBA0     .EQU kCFBase + 3
CF_LBA1     .EQU kCFBase + 4
CF_LBA2     .EQU kCFBase + 5
CF_LBA3     .EQU kCFBase + 6

;CF Features
CF_8BIT     .EQU 1
CF_NOCACHE  .EQU 082H
;CF Commands
CF_RD_SEC   .EQU 020H
CF_WR_SEC   .EQU 030H
CF_SET_FEAT .EQU 0EFH


            .CODE

; Interface descriptor
            .DB  0              ;Device ID code (not currently used)
            .DW  @String        ;Pointer to device string
            .DW  @CF_Init       ;Pointer to initialisation code
            .DB  0              ;Hardware flags bit mask
            .DW  @CF_Set        ;Point to device settings code
            .DB  0              ;Number of console devices
@String:    .DB  "CF Card "
            .DB  "@ "
            .HEXCHAR kCFBase \ 16
            .HEXCHAR kCFBase & 15
            .DB  kNull


; Initialise
;   On entry: No parameters required
;   On exit:  Z flagged if device is found and initialised
;             AF BC DE HL not specified
;             IX IY I AF' BC' DE' HL' preserved
; If the device is found it is initialised
; The test is repeated with a time-out as the CF card may take
; some time after power-up to start responding
@CF_Init:
; First check if I/O address appears occupied
            LD   C,CF_DATA      ;Digital I/O port address
            IN   C,(C)          ;Read from this port
            IN   A,(CF_DATA)    ;Read again using different instruction
            CP   C              ;Both the same? (bus not floating)
            RET  Z              ;Return Z flagged if found
            LD   C,CF_ERROR     ;Digital I/O port address
            IN   C,(C)          ;Read from this port
            IN   A,(CF_ERROR)   ;Read again using different instruction
            CP   C              ;Both the same? (bus not floating)
            RET                 ;Return Z flagged if found

#IFDEF      NOCHANCE
; This method is better but rather slow as some cards take quite a
; while after a hardware reset before they respond correctly
;           RET  NZ             ;Return NZZ flagged if not found
; Wait for card to be ready
#IF         PROCESSOR = "Z180"
            LD   BC,65000       ;Time-out (18.432MHz clock)
#ELSE
            LD   BC,26000       ;Time-out (7.3728MHz clock)
#ENDIF
@Loop:      LD   A,5            ;Test value for sector count register
            OUT  (CF_SECCOUNT),A  ;Write sector count register
            IN   A,(CF_SECCOUNT)  ;Read sector count register
            CP   5              ;Correct value read back?
            RET  Z              ;Return Z if found, NZ if not
            LD   A,4            ;Delay...
@Delay:     DEC  A
            JR   NZ,@Delay
            DEC  C              ;Test for time-out...
            JR   NZ,@Loop
            DEC  B
            JR   NZ,@Loop
            INC  B              ; Ensure NZ flagged as device not found
            RET
#ENDIF
            

; Device settings
;   On entry: No parameters required
;   On entry: A = Property to set: 1 = Baud rate
;             B = Baud rate code
;             C = Console device number (1 to 6)
;   On exit:  IF successful: (ie. valid device and baud code)
;               A != 0 and NZ flagged
;             BC DE HL not specified
;             IX IY I AF' BC' DE' HL' preserved
@CF_Set:    XOR  A              ;Return failed to set (Z flagged)
            RET


; **********************************************************************
; **  End of driver                                                   **
; **********************************************************************



















