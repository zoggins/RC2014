; **********************************************************************
; **  Compact Flash support                     by Stephen C Cousins  **
; **  Modifications for Z280RC by Bill Shen <hcs>                     **
; **********************************************************************
;
; **  Written as a module to be included in Small Computer Monitor Apps
; **  Version 0.4 SCC 2018-05-20
; **  www.scc.me.uk
;
; **********************************************************************
;
; This module provides support for Compact Flash cards
;
; Originally based on code by Grant Searle but not recognisable now
;
; **********************************************************************
;
; To include the code for any given function, add the appropriate 
; #DEFINE (see list below) at the top of the parent source file.
; For example:  #DEFINE     Include_cfRdInfo
;
; Also #INCLUDE this file at some point after the #DEFINEs in the parent
; source file.
; For example:  #INCLUDE    ..\_CodeLibrary\CompactFlash.asm
;
; To call a utility function via these shims, use the #DEFINE operand 
; (see list below), but without the leading "Include_".
; For example:  CALL cfRdInfo
;
; These are the function names provided by this module:
; cfDiagnose                    Read card diagnostic info
; cfFormat                      Format logical drive for use by CP/M
; cfInfo                        Read card identification info
; cfRead                        Read one or more sectors
; cfSize                        Convert number of sectors to size info
; cfVerify                      Verify one or more sectors
; cfVerifyF                     Verify format of drive for use by CP/M
; cfWrite                       Write one or more sectors
; All other functions are included by default
;
; **********************************************************************
;
; Requires SCMonAPI.asm to also be included in the project
;

; **********************************************************************
; **  Constants
; **********************************************************************

; CF registers
CF_BASE     .EQU $C0            ;hcs Z280RC CF base
;hcs CF_DATA     .EQU CF_BASE+0
;hcs CF_FEATURE  .EQU CF_BASE+1
;hcs CF_ERROR    .EQU CF_BASE+1
;hcs CF_SEC_CNT  .EQU CF_BASE+2
;hcs CF_SECTOR   .EQU CF_BASE+3
;hcs CF_CYL_LOW  .EQU CF_BASE+4
;hcs CF_CYL_HI   .EQU CF_BASE+5
;hcs CF_HEAD     .EQU CF_BASE+6
;hcs CF_STATUS   .EQU CF_BASE+7
;hcs CF_COMMAND  .EQU CF_BASE+7
;hcs CF_LBA0     .EQU CF_BASE+3
;hcs CF_LBA1     .EQU CF_BASE+4
;hcs CF_LBA2     .EQU CF_BASE+5
;hcs CF_LBA3     .EQU CF_BASE+6

CF_DATA     .EQU CF_BASE+0      ;hcs
CF_FEATURE  .EQU CF_BASE+3      ;hcs
CF_ERROR    .EQU CF_BASE+3      ;hcs
CF_SEC_CNT  .EQU CF_BASE+5      ;hcs
CF_SECTOR   .EQU CF_BASE+7      ;hcs
CF_CYL_LOW  .EQU CF_BASE+9      ;hcs
CF_CYL_HI   .EQU CF_BASE+$B     ;hcs
CF_HEAD     .EQU CF_BASE+$D     ;hcs
CF_STATUS   .EQU CF_BASE+$F     ;hcs
CF_COMMAND  .EQU CF_BASE+$F     ;hcs
CF_LBA0     .EQU CF_BASE+7      ;hcs
CF_LBA1     .EQU CF_BASE+9      ;hcs
CF_LBA2     .EQU CF_BASE+$B     ;hcs
CF_LBA3     .EQU CF_BASE+$D     ;hcs

; CF Features
CF_8BIT     .EQU 1
CF_NOCACHE  .EQU 082H           ;???

; CF Commands
CF_RD_SEC   .EQU 020H
CF_WR_SEC   .EQU 030H
CF_DIAGNOSE .EQU 090H
CF_IDENTIFY .EQU 0ECH
CF_SET_FEAT .EQU 0EFH

; CF Error numbers
CF_NoErr    .EQU 0              ;No error
CF_NotPres  .EQU 1              ;Compact flash card not present
CF_Timeout  .EQU 2              ;Compact flash time out error
CF_ErrFlag  .EQU 3              ;Compact flash set its error flag
CF_Verify   .EQU 4              ;Compact flash verify error
CF_Correct  .EQU 5              ;Compact flash reports correctable error
CF_Write    .EQU 6              ;Compact flash reports a write fault


; **********************************************************************
; **  Program code
; **********************************************************************

            .CODE               ;Code section


; **********************************************************************
; **  Customisation
; **********************************************************************

; Compact Flash: Select compact flash for access 
;   On entry: No parameters required
;   On exit:  AF BC DE HL IX IY I AF' BC' DE' HL' preserved
; This is called at the start of all compact flash accesses
cfSelect:
; init page i/o reg to point to CF  
            push bc             ;hcs save register
            push hl             ;hcs
            ld c,08h            ;hcs reg c points to I/O page register
            ld l,0              ;hcs set I/O page register to 0
            db 0edh,6eh         ;hcs this is the op code for LDCTL (C),HL
;hcs        ldctl (c),hl        ; write to I/O page register
            pop hl              ;hcs restore reg
            pop bc              ;hcs
            ret                 ;hcs

; Compact Flash: Deselect compact flash for access 
;   On entry: No parameters required
;   On exit:  AF BC DE HL IX IY I AF' BC' DE' HL' preserved
; This is called at the end of all compact flash accesses
cfDeselect:
; init page i/o reg to point to UART
            push bc             ;hcs save register
            push hl             ;hcs
            ld c,08h            ;hcs reg c points to I/O page register
            ld l,0feh           ;hcs set I/O page register to 0xFE
            db 0edh,6eh         ;hcs this is the op code for LDCTL (C),HL
;           ldctl (c),hl        ; write to I/O page register
            pop hl              ;hcs restore reg
            pop bc              ;hcs
            ret                 ;hcs


; **********************************************************************
; **  Public functions (and error messages)
; **********************************************************************


; **********************************************************************
; Compact Flash: Error messages
cfErrMsgs:  .TEXT "No error",0
            .TEXT "Compact flash card not present",0
            .TEXT "Time-out error",0
            .TEXT "Compact flash card reported an error",0
            .TEXT "Verify error detected comparing data read back",0
            .TEXT "Compact flash card reports a correctable error",0
            .TEXT "Compact flash card reports a write fault",0
            .DB 0


; **********************************************************************
; Compact Flash: Initialise functions 
;   On entry: No parameters required
;   On exit:  BC DE HL IX IY I AF' BC' DE' HL' preserved
cfInit:     XOR  A
            LD   (iErrorNum),A  ;Clear error number
            RET


; **********************************************************************
; Compact Flash: Get error number
;   On entry: No parameters required
;   On exit:  A = Error number or zero if no error
;             Z flagged if no error
;             BC DE HL IX IY I AF' BC' DE' HL' preserved
cfGetError: LD   A,(iErrorNum)  ;Get error number
            OR   A              ;Z flagged if no error
            RET


; **********************************************************************
; Compact Flash: test if card is present
;   On entry: No parameters required
;   On exit:  A = Error number (0 if successful)
;             Z flagged if no error
;             BC DE HL IX IY I AF' BC' DE' HL' preserved
cfTstPres:  CALL cfPrep         ;Prepare compact flash card
            JR   NZ,@NotPres    ;Abort if error
            ;XOR  A
            ;LD   (iErrorNum),A ;Clear error number
            LD   A,5            ;Test value for sector count register
            OUT  (CF_SEC_CNT),A ;Write sector count register
            IN   A,(CF_SEC_CNT) ;Read sector count register
            CP   5              ;Correct value read back?
            JR   Z,@Present     ;Yes, compact flash is present
@NotPres:   LD   A,CF_NotPres
            LD   (iErrorNum),A  ;Overwrite any existing error number
            CALL cfSetErr       ;Error = card not present
@Present:   JP   cfGetErr       ;Return current error number


#IFREQUIRED cfDiagnose
; **********************************************************************
; Compact Flash: Read card diagnostic info
;   On entry: No parameter required
;   On exit:  A = Error number (0 if no error)
;             Z flagged if no error
;             BC DE HL IX IY I AF' BC' DE' HL' preserved
cfDiagnose: CALL cfPrep         ;Prepare compact flash card
            JP   NZ,cfGetErr    ;Abort if error
            LD   A,0E0H
            OUT  (CF_LBA3),A
            LD   A,CF_DIAGNOSE
            OUT  (CF_COMMAND),A ;Perform diagnostic tests
            CALL cfWaitRdy      ;Wait for compact flash to be ready
            JP   NZ,cfGetErr    ;Error, so abort
            IN   A,(CF_ERROR)   ;Read error details
            CP   1              ;Error?
            JP   NZ,cfSetErr    ;Yes, so set error
            JP   cfGetErr       ;No, so exit
#ENDIF


#IFREQUIRED cfInfo
; **********************************************************************
; Compact Flash: Read card identification info
;   On entry: HL = Destination address
;   On exit:  A = Error number (0 if no error)
;             Z flagged if no error
;             HL = Destination for next read
;             BC DE IX IY I AF' BC' DE' HL' preserved
cfInfo:     CALL cfPrep         ;Prepare compact flash card
            JP   NZ,cfGetErr    ;Abort if error
            LD   BC,1           ;Set to read one sector
            LD   DE,0           ;  starting at sector 0x000000 *note
            LD   A,CF_IDENTIFY  ;Get read identification command
            ;JP   cfRdSec       ;Read from compact flash
            CALL cfRdSec        ;Read from compact flash
; Byte swap needed for Z280RC
            push af
            push hl             ;hcs save the pointer to sector data
            push bc             ;hcs save reg
            ld bc,200h          ;hcs subtract 0x200 from hl
            sbc hl,bc           ;hcs
            pop bc              ;hcs restore bc reg
            CALL cfByteSwap     ;hcs swap the byte order
            pop hl              ;hcs restore the pointer to sector data
            pop af
            RET
; * Setting the start sector is unnecessary for this command
#REQUIRES   cfRdSec
#REQUIRES   cfByteSwap
#ENDIF


#IFREQUIRED cfRead
; **********************************************************************
; Compact Flash: Read sectors
;   On entry: C = Number of sectors to read
;             DEB = First sector number to read
;             HL = Destination address
;   On exit:  A = Error number (0 if no error)
;             Z flagged if no error
;             HL = Destination for next read
;             BC DE IX IY I AF' BC' DE' HL' preserved
cfRead:     CALL cfPrep         ;Prepare compact flash card
            JP   NZ,cfGetErr    ;Abort if error
            LD   A,CF_RD_SEC    ;Get read sectors command
            JP   cfRdSec        ;Read from compact flash
#REQUIRES   cfRdSec
#ENDIF


#IFREQUIRED cfWrite
; **********************************************************************
; Compact Flash: Write sectors
;   On entry: C = Number of sectors to write
;             DEB = First sector number to write
;             HL = Source address for write sector data
;   On exit:  A = Error number (0 if no error)
;             Z flagged if no error
;             HL = Source address for next sector write
;             BC DE IX IY I AF' BC' DE' HL' preserved
cfWrite:    CALL cfPrep         ;Prepare compact flash card
            JP   NZ,cfGetErr    ;Abort if error
            JP   cfWrSec        ;Write to compact flash
#REQUIRES   cfWrSec
#ENDIF



#IFREQUIRED cfVerify
; **********************************************************************
; Compact Flash: Verify one or more sectors
;   On entry: C = Number of sectors to verify
;             DEB = First sector number to verify
;             HL = Source address for verify sector data
;   On exit:  A = Error number (0 if no error)
;             Z flagged if no error
;             HL = Source address for next sector verify
;             BC DE IX IY I AF' BC' DE' HL' preserved
; Each sector is 512 bytes long
cfVerify:   CALL cfPrep         ;Prepare compact flash card
            JP   NZ,cfGetErr    ;Abort if error
            JP   cfVerSec       ;Verify one or more sectors
#REQUIRES   cfVerSec
#ENDIF


#IFREQUIRED cfFormat
; **********************************************************************
; Compact Flash: Format logical drive for use by CP/M
;   On entry: B = Logical drive number to format (0 to N)
;   On exit:  A = Error number (0 if no error)
;             Z flagged if no error
;   On exit:  BC DE HL IX IY I AF' BC' DE' HL' preserved
; The directory contains:
;   512 file entries per logical drive
;    32 bytes per file entry
;    16 file entries per sector (512 byte sectors)
;    32 sectors per logical drive's directory
cfFormat:   CALL cfPrep         ;Prepare compact flash card
            JP   NZ,cfGetErr    ;Abort if error
            JP   cfForDrv       ;Format drive
#REQUIRES   cfForDrv
#ENDIF


#IFREQUIRED cfVerifyF
; **********************************************************************
; Compact Flash: Verify format of logical drive after format for CP/M
;   On entry: B = Logical drive number to format (0 to N)
;   On exit:  A = Error number (0 if no error)
;             Z flagged if no error
;   On exit:  BC DE HL IX IY I AF' BC' DE' HL' preserved
; The directory contains:
;   512 file entries per logical drive
;    32 bytes per file entry
;    16 file entries per sector (512 byte sectors)
;    32 sectors per logical drive's directory
cfVerifyF:  CALL cfPrep         ;Prepare compact flash card
            JP   NZ,cfGetErr    ;Abort if error
            JP   cfVerDrv       ;Verify drive
#REQUIRES   cfVerDrv
#ENDIF


#IFREQUIRED cfSize
; **********************************************************************
; Compact Flash: Convert number of sectors to size info
;   On entry: DEHL = Number of 512 byte sectors
;   On exit:  DE = Size in decimal 
;             A = Units character 'M', 'G' or 'T'
;             BC HL IX IY I AF' BC' DE' HL' preserved
; Shift 32-bit number of sectors to the left until overflow in to bit 32
; The number of shifts required provides offset into table of size info
cfSize:     PUSH BC
            PUSH HL
            LD   C,0xFF         ;Shift count starts as -1
@Shift:     INC  C              ;Increment count
            RL   L              ;Shift left DEHL...
            RL   H
            RL   E
            RL   D
            JR   NC,@Shift      ;Repeat until overflow
            LD   B,0
            LD   HL,@TabSize    ;Locate size in decimal...
            ADD  HL,BC
            ADD  HL,BC
            LD   E,(HL)         ;DE = Size in decimal...
            INC  HL
            LD   D,(HL)
            LD   HL,@TabUnit    ;Locate unit character...
            ADD  HL,BC
            LD   A,(HL)         ;A = Units character
            POP  HL
            POP  BC
            RET

@TabSize:   .DW 2,1,512,256,128,64,32,16,8,4,2,1,512,256,128,64,32,16,8,4,2,1
@TabUnit:   .DB "TTGGGGGGGGGGMMMMMMMMMM"
#ENDIF


; **********************************************************************
; **  Private functions (not called directly by Apps)
; **********************************************************************


; **********************************************************************
; Compact Flash: Prepare Compact Flash
;   On entry: No parameters required
;   On exit:  A = Error number (0 if no error)
;             Z flagged if no error
;             BC DE HL IX IY I AF' BC' DE' HL' preserved
; Set compact flash for 8-bit IDE and no cache
; Ignore errors until compact flash is prepared
cfPrep:     CALL cfSelect       ;Select compact flash access
            CALL cfWaitRdy1     ;Wait for compact flash to be ready
            ;JR   NZ,cfGetErr   ;Abort if we get an error
            XOR  A
            LD   (iErrorNum),A  ;Clear error number
            LD   (iErrorVer),A  ;Clear verify error flag
            LD   A,0E0H
            OUT  (CF_LBA3),A
;hcs            LD   A,CF_8BIT
;hcs            OUT  (CF_FEATURE),A ;Store feature code
;hcs            LD   A,CF_SET_FEAT  ;Get set features command
;hcs            OUT  (CF_COMMAND),A ;Perform set features
;hcs            CALL cfWaitRdy      ;Wait for compact flash to be ready
;hcs            JR   NZ,cfGetErr    ;Abort if we get an error
            ;LD   A,CF_NOCACHE  ;Set no write cache
            ;OUT  (CF_FEATURE),A  ;Store feature code
            ;LD   A,CF_SET_FEAT ;Get set features command
            ;OUT  (CF_COMMAND),A  ;Perform set features
            ;CALL cfWaitRdy     ;Wait for compact flash to be ready
            ;JR   NZ,cfGetErr   ;Abort if time out
            ;XOR  A
            ;LD   (iErrorNum),A ;Clear error number
            ;LD   (iErrorVer),A ;Clear verify error flag
            RET


; **********************************************************************
; Compact Flash: Set error number
;   On entry: A = Error number or zero if no error
;   On exit:  BC DE HL IX IY I AF' BC' DE' HL' preserved
; Any existing error number is not overwritten 
cfSetErr:   PUSH AF
            LD   A,(iErrorNum)  ;Get error number
            OR   A              ;Any error so far
            JR   NZ,@Abort      ;Do not overwrite existing error
            POP  AF
            LD   (iErrorNum),A  ;Store new error number
            JR   @Done
@Abort:     POP  AF
@Done:      JP   cfGetErr       ;Return current error number


; **********************************************************************
; Compact Flash: Get error number
;   On entry: No parameters required
;   On exit:  A = Error number or zero if no error
;             Z flagged if no error
;             BC DE HL IX IY I AF' BC' DE' HL' preserved
cfGetErr:   CALL cfDeselect     ;Deselect compact flash access
            LD   A,(iErrorNum)  ;Get error number
            OR   A              ;Z flagged if no error
            RET


; **********************************************************************
; Compact Flash: Wait for compact flash to be ready
;   On entry: No parameters required
;   On exit:  A = Error number (0 if no error)
;             Z flagged if no error
;             BC DE HL IX IY I AF' BC' DE' HL' preserved
cfWaitRdy:  ;hcs diagnostic
            in a,(CF_STATUS)    ;hcs diagnostic
            and 80h             ;hcs diagnostic chk busy
            jp nz,cfWaitRdy     ;hcs diagnostic
            in a,(CF_STATUS)    ;hcs diagnostic 
            bit 6,a             ;hcs diagnostic test ready flag
            jp z,cfWaitRdy
            xor a               ;hcs diagnostic
            ret                 ;hcs diagnostic
cfWaitRdy1: PUSH DE
            LD   DE,0           ;Time out counter
@Test:      DEC  DE             ;Decrement timer
            LD   A,E            ;Time out?
            OR   D
            JR   Z,@Timeout     ;Yes, so error
            JR   @Delay1        ;Delay to extend time-out
@Delay1:    JR   @Delay2        ;Delay to extend time-out
@Delay2:    JR   @Delay3        ;Delay to extend time-out
@Delay3:    IN   A,(CF_STATUS)  ;Read status register
            BIT  7,A            ;Test Busy flag
            JR   NZ,@Test       ;High so busy
            IN   A,(CF_STATUS)  ;Read status register
            BIT  6,A            ;Test Ready flag
            JR   Z,@Test        ;Low so not ready
            POP  DE
            JP   cfTstErr       ;Go test for errors
@Timeout:   POP  DE
            LD   A,CF_Timeout   ;Return time out error
            JP   cfSetErr       ;Store any error


; **********************************************************************
; Compact Flash: Wait for compact flash DRQ flag
;   On entry: No parameters required
;   On exit:  A = Error number (0 if no error)
;             Z flagged if no error
;             BC DE HL IX IY I AF' BC' DE' HL' preserved
cfWaitDRQ:  ;hcs diagnostic
            in a,(CF_STATUS)    ;hcs diagnostic
            and 8               ;hcs diagnostic
            jp z,cfWaitDRQ      ;hcs diagnostic
            xor a               ;hcs diagnostic
            ret                 ;hcs diagnostic
;hcs cfWaitDRQ:  PUSH DE
            LD   DE,0           ;Time out counter
@Test:      DEC  DE             ;Decrement timer
            LD   A,E            ;Time out?
            OR   D
            JR   Z,@Timeout     ;Yes, so error
            JR   @Delay1        ;Delay to extend time-out
@Delay1:    JR   @Delay2        ;Delay to extend time-out
@Delay2:    JR   @Delay3        ;Delay to extend time-out
@Delay3:    IN   A,(CF_STATUS)  ;Read status register
            BIT  3,A            ;Test DRQ flag
            JR   Z,@Test        ;Low so not ready
            POP  DE
            JP   cfTstErr       ;Go test for errors
@Timeout:   POP  DE
            LD   A,CF_Timeout   ;Return time out error
            JP   cfSetErr       ;Store any error


; **********************************************************************
; Compact Flash: Test for compact flash error
;   On entry: No parameters required
;   On exit:  A = Error number (0 if no error)
;             Z flagged if no error
;             BC DE HL IX IY I AF' BC' DE' HL' preserved
cfTstErr:   IN   A,(CF_STATUS)  ;Read status register
            AND  0b00100101     ;General error or write error or correctable
            JR   Z,@Success     ;No, so successful
            BIT  2,A            ;Correctable error?
            JR   NZ,@ErCorrect  ;Yes, so report it
            BIT  5,A            ;Write fault?
            JR   NZ,@ErWrite    ;Yes, so report it
            IN   A,(CF_ERROR)   ;Read error details
            LD   (iErrorReg),A  ;Store error details
            LD   A,CF_ErrFlag   ;Return error number
            JP   cfSetErr       ;Store any error
@Success:   LD   A,(iErrorVer)  ;Get verify error flag
            OR   A              ;Any verify errors?
            JR   NZ,@ErVerify   ;Yes, so report it
            JP   cfGetErr       ;Return error status
@ErCorrect: LD   A,CF_Correct   ;Compact flash reports correctable error
            JP   cfSetErr       ;Store error
@ErWrite:   LD   A,CF_Write     ;Compact flash reports a write fault
            JP   cfSetErr       ;Store error
@ErVerify:  LD   A,CF_Verify    ;Verify error detected when comparing
            JP   cfSetErr       ;Store error


; **********************************************************************
; Compact Flash: Set command
;   On entry: A = Command (ie. CF_xxx)
;             C = Number of sectors to access
;             DEB = First sector number to read
;   On exit:  A = Error number (0 if no error)
;             Z flagged if no error
;             BC DE IX IY I AF' BC' DE' HL' preserved
; Each sector is 512 bytes long
cfSetCmd:   PUSH AF
            LD   A,B            ;Set up LBA parameters...
            OUT  (CF_LBA0),A
            LD   A,E
            OUT  (CF_LBA1),A
            LD   A,D
            OUT  (CF_LBA2),A
            LD   A,0E0H
            OUT  (CF_LBA3),A
            LD   A,C            ;Get number of sectors to access
            OUT  (CF_SEC_CNT),A ;Set sector count
            POP  AF
            OUT  (CF_COMMAND),A ;Set command
            JP   cfWaitRdy      ;Wait for compact flash to be ready


#IFREQUIRED cfRdSec
; **********************************************************************
; Compact Flash: Read one or more sectors
;   On entry: A = Command ie. CF_RD_SEC or CF_IDENTIFY
;             C = Number of sectors to read
;             DEB = First sector number to read
;             HL = Destination address for read sector data
;   On exit:  A = Error number (0 if no error)
;             Z flagged if no error
;             HL = Destination address for next sector read
;             BC DE IX IY I AF' BC' DE' HL' preserved
; Each sector is 512 bytes long
cfRdSec:    PUSH BC
            PUSH DE
            CALL cfSetCmd       ;Set command: A=Cmd, C=Sectors, DEB=LBAsect
            JR   NZ,@Abort      ;Abort if time out
            LD   B,C            ;Number of sectors to read
; Wait for compact flash before reading data
@Sector:    CALL cfWaitDRQ      ;Wait for compact flash DRQ flag
            JR   NZ,@Abort      ;Abort if time out
;hcs            PUSH BC
;hcs            LD   C,4            ;One sector = 4 x 128 byte blocks
;hcs@Block:     LD   B,128          ;One block = 128 bytes
;hcs@Byte:      IN   A,(CF_DATA)    ;Read data byte from compact flash
;hcs            NOP
;hcs            NOP
;hcs            LD   (HL),A         ;Store data byte read
;hcs            INC  HL             ;Point ot next byte
;hcs            DJNZ @Byte          ;Repeat for all 128 bytes in block
;hcs            DEC  C
;hcs            JR   NZ,@Block      ;Repeat for all 4 blocks
;hcs            POP  BC
;hcs            DJNZ @Sector        ;Repeat for all required sectors
;hcs discard         push hl           ;hcs save the hl reg before sector read
            ld c,CF_DATA        ;hcs reg C points to CF data reg
            ld b,0h             ;hcs sector has 256 16-bit data
            db 0edh,92h         ;hcs op code for inirw input word and increment

;hcs        inirw
;hcs discard         ex (sp),hl        ;hcs swap before & after values of HL
;hcs discard         call byteswap     ;hcs swap byte
;hcs discard         pop hl            ;hcs restore the after value of HL
; Read complete, now check for errors
            CALL cfWaitRdy      ;Wait for compact flash to be ready

@Abort:     POP  DE
            POP  BC
            JP   cfGetErr       ;Return error number
#ENDIF

; Alternative faster transfer method (read version shown)
;@Sector:   CALL cfWaitDRQ      ;Wait for compact flash DRQ flag
;           JR   NZ,@Abort      ;Abort if time out
;           PUSH BC             ;Preserve sector number and count
;           LD   E,4            ;1 sector = 4 x 128 byte blocks
;           LD   C,CF_DATA      ;Compact flash data register
;@Block:    LD   B,128          ;Block size
;           INIR                ;(HL)=(C), HL=HL+1, B=B-1, repeat
;           DEC  E              ;Decrement block counter
;           JR   NZ,@Block      ;Repeat until all blocks read
;           POP  BC             ;Preserve sector number and count
;           DJNZ @Sector        ;Repeat for all required sectors
#IFREQUIRED cfByteSwap
;hcs do byte swap
cfByteSwap: ;hcs 
            push ix             ;hcs save reg
            push bc             ;hcs save reg
            push de             ;hcs save reg
            push hl             ;hcs copy HL to IX
            pop ix              ;hcs 
            ld b,0h             ;hcs counter
@byteswap1: ;hcs
            ld d,(IX+0)         ;hcs swap the MSB and LSB byte
            ld e,(IX+1)         ;hcs this is awkward, better algorithm needed
            ld (IX+0),e         ;hcs
            inc ix              ;hcs
            ld (IX+0),d         ;hcs
            inc ix              ;hcs
            djnz @byteswap1     ;hcs do this 256 times
            pop de              ;hcs restore reg
            pop bc              ;hcs restore reg
            pop ix              ;hcs restore reg
            ret                 ;hcs
#ENDIF

#IFREQUIRED cfWrSec
; **********************************************************************
; Compact Flash: Write one or more sectors
;   On entry: C = Number of sectors to write
;             DEB = First sector number to write
;             HL = Source address for write sector data
;   On exit:  A = Error number (0 if no error)
;             Z flagged if no error
;             HL = Source address for next sector write
;             BC DE IX IY I AF' BC' DE' HL' preserved
; Each sector is 512 bytes long
cfWrSec:    PUSH BC
            PUSH HL
            LD   A,CF_WR_SEC
            CALL cfSetCmd       ;Set command: A=Cmd, C=Sectors, DEB=LBAsect
            JR   NZ,@Abort      ;Abort if time out
            LD   B,C            ;Number of sectors to read
; Wait for compact flash before writing data
@Sector:    CALL cfWaitDRQ      ;Wait for compact flash DRQ flag
            JR   NZ,@Abort      ;Abort if time out
;hcs            PUSH BC
;hcs            LD   C,4            ;One sector = 4 x 128 byte blocks
;hcs@Block:     LD   B,128          ;One block = 128 bytes
;hcs@Byte:      LD   A,(HL)         ;Get data byte to be written
;hcs            NOP
;hcs            NOP
;hcs            OUT  (CF_DATA),A    ;Write data byte to compact flash
;hcs            INC  HL             ;Point ot next byte
;hcs            DJNZ @Byte          ;Repeat for all 128 bytes in block
;hcs            DEC  C
;hcs            JR   NZ,@Block      ;Repeat for all 4 blocks
;hcs            POP  BC
;hcs            DJNZ @Sector        ;Repeat for all required sectors
            ld b,0h             ;hcs sector has 256 16-bit data
            ld c,CF_DATA        ;hcs reg C points to CF data reg
            db 0edh,93h         ;hcs op code for otirw output word and increment
;hcs        otirw

; Write complete, now check for errors
            CALL cfWaitRdy      ;Wait for compact flash to be ready
@Abort:     POP  HL
            POP  BC
            JP   cfGetErr       ;Return error number
#ENDIF

; Alternative faster transfer method (read version shown)
;           PUSH BC             ;Preserve sector number and count
;           LD   E,4            ;1 sector = 4 x 128 byte blocks
;           LD   C,CF_DATA      ;Compact flash data register
;@Block:    LD   B,128          ;Block size
;           INIR                ;(HL)=(C), HL=HL+1, B=B-1, repeat
;           DEC  E              ;Decrement block counter
;           JR   NZ,@Block      ;Repeat until all blocks read
;           POP  BC             ;Preserve sector number and count
;           DJNZ @Sector        ;Repeat for all required sectors


#IFREQUIRED cfVerSec
; **********************************************************************
; Compact Flash: Verify one or more sectors
;   On entry: C = Number of sectors to verify
;             DEB = First sector number to verify
;             HL = Source address for verify sector data
;   On exit:  A = Error number (0 if no error)
;             Z flagged if no error
;             HL = Source address for next sector verify
;             BC DE IX IY I AF' BC' DE' HL' preserved
; Each sector is 512 bytes long
cfVerSec:   PUSH BC
            PUSH DE
            XOR  A
            LD   (iErrorVer),A  ;Clear verify error flag
            LD   A,CF_RD_SEC
            CALL cfSetCmd       ;Set command: A=Cmd, C=Sectors, DEB=LBAsect
            JR   NZ,@Abort      ;Abort if time out
            LD   B,C            ;Number of sectors to verify
; Wait for compact flash before reading data
@Sector:    CALL cfWaitDRQ      ;Wait for compact flash DRQ flag
            JR   NZ,@Abort      ;Abort if time out
            PUSH BC
            LD   C,4            ;One sector = 4 x 128 byte blocks
@Block:     LD   B,128          ;One block = 128 bytes
@Byte:      IN   A,(CF_DATA)    ;Get byte from compact flash
            CP   (HL)           ;Compare with source byte
            CALL NZ,@ErrorV     ;If compare failed then flag error 
            INC  HL             ;Point ot next byte
            DJNZ @Byte          ;Repeat for all 128 bytes in block
            DEC  C
            JR   NZ,@Block      ;Repeat for all 4 blocks
            POP  BC
            DJNZ @Sector        ;Repeat for all required sectors
; Verify complete, now check for errors
            CALL cfWaitRdy      ;Wait for compact flash to be ready
@Abort:     POP  DE
            POP  BC
            JP   cfGetErr       ;Return error number
; Store verify error flag
@ErrorV:    LD   A,0xFF
            LD   (iErrorVer),A
            RET
#ENDIF


#IFREQUIRED cfForDrv
; **********************************************************************
; Compact Flash: Format logical drive for use by CP/M
;   On entry: B = Logical drive number to format (0 to N)
;   On exit:  A = Error number (0 if no error)
;             Z flagged if no error
;   On exit:  BC DE HL IX IY I AF' BC' DE' HL' preserved
; The directory contains:
;   512 file entries per logical drive
;    32 bytes per file entry
;    16 file entries per sector (512 byte sectors)
;    32 sectors per logical drive's directory
cfForDrv:   PUSH BC
            PUSH DE
            PUSH HL
            LD   HL,0           ;Start sector = HLA
            LD   A,B            ;Get drive number 0 to N
            OR   A              ;Drive 0?
            LD   A,32           ;Drive 0 has reserved track so
            JR   Z,@Format      ;  directory starts at sector 32
            LD   DE,$0040       ;HL increment
@Calc:      ADD  HL,DE          ;Calculate start sector...
            DJNZ @Calc
            XOR  A              ;Start sector = HLA
; Start sector is now HLA (LBA2=H, LBA1=L, LBA0=A)
@Format:    LD   B,A            ;Sector number least significant byte
            EX   DE,HL          ;Sector number most significant bytes
            LD   C,32           ;Prepare to write 32 sectors
            LD   A,CF_WR_SEC
            CALL cfSetCmd       ;Set command: A=Cmd, C=Sectors, DEB=LBAsect
            JR   NZ,@Abort      ;Abort if error
            LD   E,32           ;Prepare to write 32 sectors
@Sector:    CALL cfWaitDRQ      ;Wait for compact flash DRQ flag
            JR   NZ,@Abort      ;Abort if error
            LD   C,16           ;One sector = 16 x 32 byte file entries
@File:      LD   HL,cfDirData   ;Point to directory data for a file
            LD   B,32           ;One file entry = 32 bytes
@WrByte:    LD   A,(HL)         ;Get byte of directory data
            NOP
            NOP
            OUT  (CF_DATA),A    ;Write byte to compact flash
            INC  HL             ;Point to next byte
            DJNZ @WrByte        ;Repeat for all bytes in block
            DEC  C
            JR   NZ,@File       ;Repeat for all file entries in sector
            DEC  E
            JR   NZ,@Sector     ;Repeat for all sectors
            CALL cfWaitRdy      ;Wait for compact flash to be ready
@Abort:     POP  HL
            POP  DE
            POP  BC
            JP   cfGetErr       ;Return error number
#REQUIRES   cfDirData
#ENDIF


#IFREQUIRED cfVerDrv
; **********************************************************************
; Compact Flash: Verify format of logical drive after format for CP/M
;   On entry: B = Logical drive number to format (0 to N)
;   On exit:  A = Error number (0 if no error)
;             Z flagged if no error
;   On exit:  BC DE HL IX IY I AF' BC' DE' HL' preserved
; The directory contains:
;   512 file entries per logical drive
;    32 bytes per file entry
;    16 file entries per sector (512 byte sectors)
;    32 sectors per logical drive's directory
cfVerDrv:   PUSH BC
            PUSH DE
            PUSH HL
            XOR  A
            LD   (iErrorVer),A  ;Clear verify error flag
            LD   HL,0           ;Start sector = HLA
            LD   A,B            ;Get drive number 0 to N
            OR   A              ;Drive 0?
            LD   A,32           ;Drive 0 has reserved track so
            JR   Z,@Verify      ;  directory starts at sector 32
            LD   DE,$0040       ;HL increment
@Calc:      ADD  HL,DE          ;Calculate start sector...
            DJNZ @Calc
            XOR  A              ;Start sector = HLA
; Start sector is now HLA (LBA2=H, LBA1=L, LBA0=A)
@Verify:    LD   B,A            ;Sector number least significant byte
            EX   DE,HL          ;Sector number most significant bytes
            LD   C,32           ;Prepare to write 32 sectors
            LD   A,CF_RD_SEC
            CALL cfSetCmd       ;Set command: A=Cmd, C=Sectors, DEB=LBAsect
            JR   NZ,@Abort      ;Abort if error
            LD   E,32           ;Prepare to write 32 sectors
@Sector:    CALL cfWaitDRQ      ;Wait for compact flash DRQ flag
            JR   NZ,@Abort      ;Abort if error
            LD   C,16           ;One sector = 16 x 32 byte file entries
@File:      LD   HL,cfDirData   ;Point to directory data for a file
            LD   B,32           ;One file entry = 32 bytes
@Byte:      IN   A,(CF_DATA)    ;Get byte from compact flash
            CP   (HL)           ;Compare with source directory data
            CALL NZ,@ErrorV     ;If compare failed then flag error 
            INC  HL             ;Point to next byte
            DJNZ @Byte          ;Repeat for all bytes in block
            DEC  C
            JR   NZ,@File       ;Repeat for all file entries in sector
            DEC  E
            JR   NZ,@Sector     ;Repeat for all sectors
            CALL cfWaitRdy      ;Wait for compact flash to be ready
@Abort:     POP  HL
            POP  DE
            POP  BC
            JP   cfGetErr       ;Return error number
; Store verify error flag
@ErrorV:    LD   A,0xFF
            LD   (iErrorVer),A
            RET
#REQUIRES   cfDirData
#ENDIF


#IFREQUIRED cfDirData
; Directory data for each file
cfDirData:  .DB $E5,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$00,$00,$00,$00
            .DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
#ENDIF


; **********************************************************************
; **  Variables
; **********************************************************************

            .DATA               ;Data section

iErrorNum:  .DB  0              ;Error number
iErrorReg:  .DB  0              ;Error register
iErrorVer:  .DB  0              ;Verify error flag





