; **********************************************************************
; **  CP/M 2.2 CBIOS, storage device support    by Stephen C Cousins  **
; **  Storage device = CompactFlash (Device-CF)                       **
; **********************************************************************

; Based on code by Grant Searle


#IF         SDSize = "64MB"
#DEFINE     SIZE64
#ENDIF
#IF         SDSize = "128MB"
#DEFINE     SIZE128
#ENDIF

kCFBase     .EQU kSDBase

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
CF_READ_SEC .EQU 020H
CF_WRITE_SEC                    .EQU 030H
CF_SET_FEAT .EQU  0EFH

blksiz      .equ 4096           ;CP/M allocation size
hstsiz      .equ 512            ;host disk sector size
hstspt      .equ 32             ;host disk sectors/trk
hstblk      .equ hstsiz/128     ;CP/M sects/host buff
cpmspt      .equ hstblk * hstspt  ;CP/M sectors/track
secmsk      .equ hstblk-1       ;sector mask
            ;compute sector mask
;secshf                         .equ  2   ;log2(hstblk)

wrall       .equ 0              ;write to allocated
wrdir       .equ 1              ;write to directory
wrual       .equ 2              ;write to unallocated


            .CODE

; **********************************************************************
; **  Storage device - Cold boot initialisation
; **********************************************************************

SD_cboot:   CALL cfWait
            LD  A,CF_8BIT       ; Set IDE to be 8bit
            OUT (CF_FEATURES),A
            LD A,CF_SET_FEAT
            OUT (CF_COMMAND),A

            CALL cfWait
            LD  A,CF_NOCACHE    ; No write cache
            OUT (CF_FEATURES),A
            LD A,CF_SET_FEAT
            OUT (CF_COMMAND),A

            JR   SD_xboot       ;Common ending to cold and warm boot


; **********************************************************************
; **  Storage device - Warm boot initialisation
; **********************************************************************
; Load CCP from CompactFlash

SD_wboot:   LD   B,11           ;Number of sectors to reload
            XOR  A
            LD   (hstsec),A     ;Clear hstsec
            LD   HL,ccp         ;Start of CCP in memory
@rdSectors: CALL cfWait
            LD   A,(hstsec)
            OUT  (CF_LBA0),A    ;Select sector
            XOR  A
            OUT  (CF_LBA1),A
            OUT  (CF_LBA2),A
            LD   A,0E0H
            OUT  (CF_LBA3),A
            LD   A,1
            OUT  (CF_SECCOUNT),A
            PUSH  BC            ;Preserve BC
            CALL cfWait
            LD   A,CF_READ_SEC
            OUT  (CF_COMMAND),A
            CALL cfWait
; Read 512 bytes
            LD   C,4            ;Number of 128 byte blocks
@rd4secs:   LD   B,128          ;Number of bytes in block
@rd512byt:  IN   A,(CF_DATA)
            LD   (HL),A
            iNC  HL
            DEC  B
            JR   NZ,@rd512byt
            DEC  C
            JR   NZ,@rd4secs

            POP  BC             ;Restore BC
            LD   A,(hstsec)
            INC  A              ;Inc sectore number
            LD   (hstsec),A
            DJNZ @rdSectors

;           JR   CF_xboot       ;Fall through to CF_xboot


; **********************************************************************
; **  Storage device - Common to cold and warm boot
; **********************************************************************

SD_xboot:   XOR  A              ;Make A=0
            LD   (hstact),A     ;Host buffer inactive
            LD   (unacnt),A     ;Clear unalloc count
            RET


; **********************************************************************
; **  Disk parameter headers for disk 0 to 15
; **********************************************************************
; <JL> Added IFDEF/ELSE block to select 64/128 MB

dpbase:     .DW 0000h,0000h,0000h,0000h,dirbuf,dpb0,0000h,alv00
            .DW 0000h,0000h,0000h,0000h,dirbuf,dpb,0000h,alv01
            .DW 0000h,0000h,0000h,0000h,dirbuf,dpb,0000h,alv02
            .DW 0000h,0000h,0000h,0000h,dirbuf,dpb,0000h,alv03
            .DW 0000h,0000h,0000h,0000h,dirbuf,dpb,0000h,alv04
            .DW 0000h,0000h,0000h,0000h,dirbuf,dpb,0000h,alv05
            .DW 0000h,0000h,0000h,0000h,dirbuf,dpb,0000h,alv06
#IFDEF      SIZE64
            .DW 0000h,0000h,0000h,0000h,dirbuf,dpbLast,0000h,alv07
#ELSE
            .DW 0000h,0000h,0000h,0000h,dirbuf,dpb,0000h,alv07
            .DW 0000h,0000h,0000h,0000h,dirbuf,dpb,0000h,alv08
            .DW 0000h,0000h,0000h,0000h,dirbuf,dpb,0000h,alv09
            .DW 0000h,0000h,0000h,0000h,dirbuf,dpb,0000h,alv10
            .DW 0000h,0000h,0000h,0000h,dirbuf,dpb,0000h,alv11
            .DW 0000h,0000h,0000h,0000h,dirbuf,dpb,0000h,alv12
            .DW 0000h,0000h,0000h,0000h,dirbuf,dpb,0000h,alv13
            .DW 0000h,0000h,0000h,0000h,dirbuf,dpb,0000h,alv14
            .DW 0000h,0000h,0000h,0000h,dirbuf,dpbLast,0000h,alv15
#ENDIF
            
; First drive has a reserved track for CP/M
dpb0:       .DW 128             ;SPT - sectors per track
            .DB 5               ;BSH - block shift factor
            .DB 31              ;BLM - block mask
            .DB 1               ;EXM - Extent mask
            .DW 2043            ; (2047-4) DSM - Storage size (blocks - 1)
            .DW 511             ;DRM - Number of directory entries - 1
            .DB 240             ;AL0 - 1 bit set per directory block
            .DB 0               ;AL1 -            "
            .DW 0               ;CKS - DIR check vector size (DRM+1)/4 (0=fixed disk)
            .DW 1               ;OFF - Reserved tracks

dpb:        .DW 128             ;SPT - sectors per track
            .DB 5               ;BSH - block shift factor
            .DB 31              ;BLM - block mask
            .DB 1               ;EXM - Extent mask
            .DW 2047            ;DSM - Storage size (blocks - 1)
            .DW 511             ;DRM - Number of directory entries - 1
            .DB 240             ;AL0 - 1 bit set per directory block
            .DB 0               ;AL1 -            "
            .DW 0               ;CKS - DIR check vector size (DRM+1)/4 (0=fixed disk)
            .DW 0               ;OFF - Reserved tracks

; Last drive is smaller because CF is never full 64MB or 128MB
; <JL> Added IFDEF/ELSE block to select 64/128 MB
dpbLast:    .DW 128             ;SPT - sectors per track
            .DB 5               ;BSH - block shift factor
            .DB 31              ;BLM - block mask
            .DB 1               ;EXM - Extent mask
#IFDEF      SIZE64
            .DW 1279            ;DSM - Storage size (blocks - 1)  ; 1279 = 5MB (for 64MB card)
#ELSE
            .DW 511             ;DSM - Storage size (blocks - 1)  ; 511 = 2MB (for 128MB card)
#ENDIF
            .DW 511             ;DRM - Number of directory entries - 1
            .DB 240             ;AL0 - 1 bit set per directory block
            .DB 0               ;AL1 -            "
            .DW 0               ;CKS - DIR check vector size (DRM+1)/4 (0=fixed disk)
            .DW 0               ;OFF - Reserved tracks


; **********************************************************************
; **  Disk processing entry points
; **********************************************************************

; **********************************************************************
; BIOS fn 8, Home disk

SD_home:    LD   A,(hstwrt)     ;check for pending write
            OR   A
            JR   NZ,@homed
            LD   (hstact),A     ;clear host active flag
@homed:     LD   BC,0000h
; =====>    JP   SD_settrk      ;Drop through to SD_settrk


; **********************************************************************
; BIOS fn 10, Set track
; Set track passed from BDOS in register BC

SD_settrk:  LD  (sektrk),BC
            RET


; **********************************************************************
; BIOS fn 9, Select disk

SD_seldsk:  LD   HL,$0000
            LD   A,C
; <JL> Added IFDEF/ELSE block to select 64/128 MB
#IFDEF      SIZE64
            CP   8              ; 8 for 64MB disk, 16 for 128MB disk
#ELSE
            CP   16             ; 16 for 128MB disk, 8 for 64MB disk
#ENDIF
            JR   C,chgdsk       ; if invalid drive will give BDOS error
            LD   A,(userdrv)    ; so set the drive back to a:
            CP   C              ; If the default disk is not the same as the
            RET  NZ             ; selected drive then return, 
            XOR  A              ; else reset default back to a:
            LD   (userdrv),A    ; otherwise will be stuck in a loop
            LD   (sekdsk),A
            RET

chgdsk:     LD   (sekdsk),A
            RLC  A              ;*2
            RLC  A              ;*4
            RLC  A              ;*8
            RLC  A              ;*16
            LD   HL,dpbase
            LD   B,0
            LD   C,A 
            ADD  HL,BC
            RET


; **********************************************************************
; BIOS fn 11, Set sector
; Set sector passed from BDOS in register BC

SD_setsec:  LD   (seksec),BC
            RET


; **********************************************************************
; BIOS fn 12, Set DMA address
; Set DMA Address given by registers BC

SD_setdma:  LD   (dmaAddr),BC
            RET


; **********************************************************************
; BIOS fn 16, Sector translate

SD_sectran: PUSH BC
            POP  HL
            RET


; **********************************************************************
; BIOS fn 13, Read 128 byte sector

SD_read:    XOR  A              ;A=0
            LD   (unacnt),A
            INC  A              ;A=1
            LD   (readop),A     ;read operation
            LD   (rsflag),A     ;must read data
            LD   A,wrual
            LD   (wrtype),A     ;treat as unalloc
            JP   rwoper         ;to perform the read


; **********************************************************************
; BIOS fn 14, Write 128 byte sector

SD_write:   XOR  A              ;A=0
            LD   (readop),A     ;not a read operation
            LD   A,C            ;write type in c
            LD   (wrtype),A
            CP   wrual          ;write unallocated?
            JR   NZ,@chkuna     ;check for unalloc
;
;                               write to unallocated, set parameters
            LD   A,blksiz/128   ;next unalloc recs
            LD   (unacnt),A
            LD   A,(sekdsk)     ;disk to seek
            LD   (unadsk),A     ;unadsk = sekdsk
            LD   HL,(sektrk)
            LD   (unatrk),HL    ;unatrk = sectrk
            LD   A,(seksec)
            LD   (unasec),A     ;unasec = seksec
;
@chkuna:    ;check for write to unallocated sector
            LD   A,(unacnt)     ;any unalloc remain?
            OR   A 
            JR   Z,@alloc       ;skip if not
;
;                               more unallocated records remain
            DEC  A              ;unacnt = unacnt-1
            LD   (unacnt),A
            LD   A,(sekdsk)     ;same disk?
            LD   HL,unadsk
            CP   (HL)           ;sekdsk = unadsk?
            JR   NZ,@alloc      ;skip if not
;
;                               disks are the same
            LD   HL,unatrk
            CALL sektrkcmp      ;sektrk = unatrk?
            JR   NZ,@alloc      ;skip if not
;
;                               tracks are the same
            LD   A,(seksec)     ;same sector?
            LD   HL,unasec
            CP   (HL)           ;seksec = unasec?
            JR   NZ,@alloc      ;skip if not
;
;                               match, move to next sector for future ref
            INC  (HL)           ;unasec = unasec+1
            LD   A,(HL)         ;end of track?
            CP   cpmspt         ;count CP/M sectors
            JR   C,@noovf       ;skip if no overflow
;
;                               overflow to next track
            LD   (HL),0         ;unasec = 0
            LD   HL,(unatrk)
            INC  HL
            LD   (unatrk),HL    ;unatrk = unatrk+1
;
@noovf:     ;match found, mark as unnecessary read
            XOR A               ;A=0
            LD  (rsflag),A      ;rsflag = 0
            JR  rwoper          ;to perform the write
;
@alloc:     ;not an unallocated record, requires pre-read
            XOR  A              ;A=0
            LD   (unacnt),A     ;unacnt = 0
            INC  A              ;A=1
            LD   (rsflag),A     ;rsflag = 1
; =====>    JP   rwoper         ;Drop through to rwoper


; **********************************************************************
; **  Enter here to perform the read/write
; **********************************************************************

rwoper:     xor a               ;zero to accum
            ld (erflag),a       ;no errors (yet)
            ld a,(seksec)       ;compute host sector
            or a                ;carry = 0
            rra                 ;shift right
            or a                ;carry = 0
            rra                 ;shift right
            ld (sekhst),a       ;host sector to seek
;
;                               active host sector?
            ld hl,hstact        ;host active flag
            ld a,(hl)
            ld (hl),1           ;always becomes 1
            or a                ;was it already?
            jr z,filhst         ;fill host if not
;
;                               host buffer active, same as seek buffer?
            ld a,(sekdsk)
            ld hl,hstdsk        ;same disk?
            cp (hl)             ;sekdsk = hstdsk?
            jr nz,nomatch
;
;                               same disk, same track?
            ld hl,hsttrk
            call sektrkcmp      ;sektrk = hsttrk?
            jr nz,nomatch
;
;                               same disk, same track, same buffer?
            ld a,(sekhst)
            ld hl,hstsec        ;sekhst = hstsec?
            cp (hl)
            jr z,match          ;skip if match
;
nomatch     ;proper disk, but not correct sector
            ld a,(hstwrt)       ;host written?
            or a
            call nz,writehst    ;clear host buff
;
filhst:
            ;may have to fill the host buffer
            ld a,(sekdsk)
            ld (hstdsk),a
            ld hl,(sektrk)
            ld (hsttrk),hl
            ld a,(sekhst)
            ld (hstsec),a
            ld a,(rsflag)       ;need to read?
            or a
            call nz,readhst     ;yes, if 1
            xor a               ;0 to accum
            ld (hstwrt),a       ;no pending write
;
match:      ;copy data to or from buffer
            ld a,(seksec)       ;mask buffer number
            and secmsk          ;least signif bits
            ld l,a              ;ready to shift
            ld h,0              ;double count
            add hl,hl
            add hl,hl
            add hl,hl
            add hl,hl
            add hl,hl
            add hl,hl
            add hl,hl
;                               hl has relative host buffer address
            ld de,hstbuf
            add hl,de           ;hl = host address
            ex de,hl            ;now in DE
            ld hl,(dmaAddr)     ;get/put CP/M data
            ld c,128            ;length of move
            ld a,(readop)       ;which way?
            or a
            jr nz,rwmove        ;skip if read
;
;           write operation, mark and switch direction
            ld a,1
            ld (hstwrt),a       ;hstwrt = 1
            ex de,hl            ;source/dest swap
;
rwmove:     ;C initially 128, DE is source, HL is dest
            ld a,(de)           ;source character
            inc de
            ld (hl),a           ;to dest
            inc hl
            dec c               ;loop 128 times
            jr nz,rwmove
;
;                               data has been moved to/from host buffer
            ld a,(wrtype)       ;write type
            cp wrdir            ;to directory?
            ld a,(erflag)       ;in case of errors
            ret nz              ;no further processing
;
;                               clear host buffer for directory write
            or a                ;errors?
            ret nz              ;skip if so
            xor a               ;0 to accum
            ld (hstwrt),a       ;buffer written
            call writehst
            ld a,(erflag)
            ret


; **********************************************************************
; **  Utility subroutine for 16-bit compare
; **********************************************************************

sektrkcmp:  ;HL = .unatrk or .hsttrk, compare with sektrk
            ex de,hl
            ld hl,sektrk
            ld a,(de)           ;low byte compare
            cp (HL)             ;same?
            ret nz              ;return if not
;                               low bytes equal, test high 1s
            inc de
            inc hl
            ld a,(de)
            cp (hl)             ;sets flags
            ret


; **********************************************************************
; **  Convert track/head/sector into LBA for physical access to the disk
; **********************************************************************

setLBAaddr: LD HL,(hsttrk)
            RLC L
            RLC L
            RLC L
            RLC L
            RLC L
            LD A,L
            AND 0E0H
            LD L,A
            LD A,(hstsec)
            ADD A,L
            LD (lba0),A

            LD HL,(hsttrk)
            RRC L
            RRC L
            RRC L
            LD A,L
            AND 01FH
            LD L,A
            RLC H
            RLC H
            RLC H
            RLC H
            RLC H
            LD A,H
            AND 020H
            LD H,A
            LD A,(hstdsk)
            RLC a
            RLC a
            RLC a
            RLC a
            RLC a
            RLC a
            AND 0C0H
            ADD A,H
            ADD A,L
            LD (lba1),A
            
            LD A,(hstdsk)
            RRC A
            RRC A
            AND 03H
            LD (lba2),A

; LBA Mode using drive 0 = E0
            LD a,0E0H
            LD (lba3),A

            LD A,(lba0)
            OUT  (CF_LBA0),A

            LD A,(lba1)
            OUT  (CF_LBA1),A

            LD A,(lba2)
            OUT  (CF_LBA2),A

            LD A,(lba3)
            OUT  (CF_LBA3),A

            LD  A,1
            OUT  (CF_SECCOUNT),A

            RET    


; **********************************************************************
; ** Storage device - Read physical sector from host 
; **********************************************************************

readhst:    PUSH AF
            PUSH BC
            PUSH HL
            CALL cfWait
            CALL setLBAaddr
            LD   A,CF_READ_SEC
            OUT  (CF_COMMAND),A
            CALL cfWait
            LD   C,4
            LD   HL,hstbuf
rd4secs:    LD   b,128
rdByte:     IN   A,(CF_DATA)
            LD   (HL),A
            INC  HL
            DEC  B
            JR   NZ, rdByte
            DEC  C
            JR   NZ,rd4secs
            POP  HL
            POP  BC
            POP  AF
            XOR  A
            LD   (erflag),A
            RET


; **********************************************************************
; ** Storage device - Write physical sector to host 
; **********************************************************************

writehst:   PUSH AF
            PUSH BC
            PUSH HL
            CALL cfWait
            CALL setLBAaddr
            LD   A,CF_WRITE_SEC
            OUT  (CF_COMMAND),A
            CALL cfWait
            LD   C,4
            LD   HL,hstbuf
wr4secs:    LD   B,128
wrByte:     LD   A,(HL)
            OUT  (CF_DATA),A
            INC  HL
            DEC  B
            JR   NZ, wrByte
            DEC  C
            JR   NZ,wr4secs
            POP  HL
            POP  BC
            POP  AF
            XOR  A
            LD   (erflag),A
            RET


; **********************************************************************
; ** Storage device - Wait until ready 
; **********************************************************************

#IFDEF      GrantsOriginal
cfWait:
            PUSH AF
@cfWait1:   IN   A,(CF_STATUS)
            AND  080H
            CP   080H
            JR   Z,@cfWait1
            POP  AF
            RET
#ELSE
cfWait:     PUSH AF
@TstBusy:   IN   A,(CF_STATUS)  ;Read status register
            BIT  7,A            ;Test Busy flag
            JR   NZ,@TstBusy    ;High so busy
@TstReady:  IN   A,(CF_STATUS)  ;Read status register
            BIT  6,A            ;Test Ready flag
            JR   Z,@TstBusy     ;Low so not ready
            POP  AF
            RET
#ENDIF


; **********************************************************************
; **  Data storage
; **********************************************************************

            .DATA

dirbuf:     .ds 128             ;scratch directory area
alv00:      .ds 257             ;allocation vector 0
alv01:      .ds 257             ;allocation vector 1
alv02:      .ds 257             ;allocation vector 2
alv03:      .ds 257             ;allocation vector 3
alv04:      .ds 257             ;allocation vector 4
alv05:      .ds 257             ;allocation vector 5
alv06:      .ds 257             ;allocation vector 6
alv07:      .ds 257             ;allocation vector 7
; <JL> Added IFDEF block to select 64/128 MB
#IFDEF      SIZE128
alv08:      .ds 257             ;allocation vector 8
alv09:      .ds 257             ;allocation vector 9
alv10:      .ds 257             ;allocation vector 10
alv11:      .ds 257             ;allocation vector 11
alv12:      .ds 257             ;allocation vector 12
alv13:      .ds 257             ;allocation vector 13
alv14:      .ds 257             ;allocation vector 14
alv15:      .ds 257             ;allocation vector 15
#ENDIF

lba0        .DB 00h
lba1        .DB 00h
lba2        .DB 00h
lba3        .DB 00h

sekdsk:     .ds 1               ;seek disk number
sektrk:     .ds 2               ;seek track number
seksec:     .ds 2               ;seek sector number
;
hstdsk:     .ds 1               ;host disk number
hsttrk:     .ds 2               ;host track number
hstsec:     .ds 1               ;host sector number
;
sekhst:     .ds 1               ;seek shr secshf
hstact:     .ds 1               ;host active flag
hstwrt:     .ds 1               ;host written flag
;
unacnt:     .ds 1               ;unalloc rec cnt
unadsk:     .ds 1               ;last unalloc disk
unatrk:     .ds 2               ;last unalloc track
unasec:     .ds 1               ;last unalloc sector
;
erflag:     .ds 1               ;error reporting
rsflag:     .ds 1               ;read sector flag
readop:     .ds 1               ;1 if read operation
wrtype:     .ds 1               ;write operation type
dmaAddr:    .ds 2               ;last dma address
hstbuf:     .ds 512             ;host buffer

hstBufEnd:  .EQU $








