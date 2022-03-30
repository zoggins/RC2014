; **********************************************************************
; **  Compact Flash CP/M Boot Loader            by Stephen C Cousins  **
; **********************************************************************

; This version is for the Z180 CPU with a simple linear physical memory 
; map:
;    0x00000 to 0x7FFFF = ROM
;    0x80000 to 0xFFFFF = RAM
;
; After SCM initialises the 64k logical memory to physical memory map
; is:
;    Common(0) 0x0000 to 0x0000 -> 0x00000 to 0x00000 (ROM)
;    Bank      0x0000 to 0x7FFF -> 0x00000 to 0x07FFF (ROM)
;    Common(1) 0x8000 to 0xFFFF -> 0x88000 to 0x8FFFF (RAM) *
;
; To run CP/M the ROM section must be replaced with RAM, giving the 64k 
; logical memory to physical memory map:  
;    Common(0) 0x0000 to 0x0000 -> 0x00000 to 0x00000 (ROM)
;    Bank      0x0000 to 0x7FFF -> 0x80000 to 0x87FFF (RAM)
;    Common(1) 0x8000 to 0xFFFF -> 0x88000 to 0x8FFFF (RAM) *
;
; * = Changed from 0xF8000->0xFFFFF to 0x88000->0x8FFFF at 2022-02-18

; Based on code by Grant Searle. 
; http://searle.hostei.com/grant/index.html

; Options to build any one of these:
;   SCMon_CPM_loader_Z180_<reg_base>_<cf_base>_code<address>
;      reg_base = Z180 internal register base ( typically 0x00 | 0xC0 )
;      cf_base  = Compact flash card base address ( typically 0x10 | 0x90 )
; eg.
;   SCMon_CPM_loader_Z180_0x00_0x10_code8000
;   SCMon_CPM_loader_Z180_0xC0_0x90_code8000
kZ180Base:  .EQU 0x00           ;Z180 register base address ( 0x00 | 0xC0 )
kCFBase:    .EQU 0x90           ;CF card base address ( 0x10 | 0x90 )


            .PROC Z180

; Memory map
NumSectors: .EQU 24             ;Number of 512 sectors to be loaded
CodeORG:    .EQU $8000          ;Loader code runs here
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


            .ORG  CodeORG

; Test if compact flash present
            LD   A,5            ;Tets value for sector count register
            OUT  (CF_SECCOUNT),A  ;Write sector count register
            IN   A,(CF_SECCOUNT)  ;Read sector count register
            CP   5              ;Correct value read back?
            JR   Z,@Present     ;Yes, compact flash is present
            LD   DE,MsgNotFound ;Pointer to error message
            LD   C,6            ;API 0x06
            RST  0x30           ;  = Output string
            JP   0x0014         ;Warm start monitor
@Present:
; Load CP/M
            CALL Wait           ;Wait for compact flash to be ready
            LD   A,CF_8BIT      ;Set IDE to be 8bit
            OUT  (CF_FEATURES),A  ;Store feature code
            LD   A,CF_SET_FEAT  ;Get set features command
            OUT  (CF_COMMAND),A ;Perform set features
            CALL Wait           ;Wait for compact flash to be ready
            LD   A,CF_NOCACHE   ;Set no write cache
            OUT  (CF_FEATURES),A  ;Store feature code
            LD   A,CF_SET_FEAT  ;Get set features command
            OUT  (CF_COMMAND),A ;Perform set features
            CALL Wait           ;Wait for compact flash to be ready
            LD   B,NumSectors   ;Number of physical sectors
            LD   C,0            ;First sector number
            LD   HL,LoadAddr    ;Code from compact flash loads here
; Read sectors where one sector is 4 x 128 byte blocks = 512 bytes
ReadSects:  LD   A,C            ;Get sector number
            OUT  (CF_LBA0),A    ;Set sector number
            XOR  A              ;Set up LBA parameters...
            OUT  (CF_LBA1),A
            OUT  (CF_LBA2),A
            LD   A,0E0H
            OUT  (CF_LBA3),A
            LD   A,1            ;Get number if sectors to read
            OUT  (CF_SECCOUNT),A  ;Store sector count
            LD   A,CF_RD_SEC    ;Get read sectors command
            OUT  (CF_COMMAND),A ;Perform sector(s) read
            CALL Wait           ;Wait for compact flash to be ready
@TstReady:  IN   A,(CF_STATUS)  ;Read status register
            BIT  3,A            ;Test DRQ flag
            JR   Z,@TstReady    ;Low so not ready
            LD   E,4            ;1 sector = 4 x 128 byte blocks
            PUSH BC             ;Preserve sector number and count
            LD   C,CF_DATA      ;Compact flash data register
ReadBlock:  LD   B,128          ;Block size
            INIR                ;(HL)=(C), HL=HL+1, B=B-1, repeat
            DEC  E              ;Decrement block counter
            JR   NZ,ReadBlock   ;Repeat until all blocks read
            POP  BC             ;Preserve sector number and count
            INC  C              ;Increment sector number
            DJNZ ReadSects      ;Repeat for all required sectors
; CP/M now loaded into temporary buffer in RAM
; Determine current console device
            LD   C,0x27         ;API 0x27 = Get current console
            RST  0x30           ;  = I/O devices (1 to 6) in DE
; SCMonitor functions must no longer be used
            DI                  ;Disable interrupts
            LD   SP,TempStack   ;Temporary stack
; Page out the ROM so we now have full 64k bytes of RAM available
; Writing to usual shadow copy is useless as CP/M overwrites it
;           LD   A,$01          ;Value to page out ROM
;           LD   (0xFFF0),A     ;Store shadow copy of paging register
;           OUT  ($38),A        ;Write to page register
            PUSH DE
            CALL MMU_RAM        ;Page ROM out, RAM in
            POP  DE
; Write jump instruction at mode 1 interrupt address to fix an issue
; with RC2014 cbios for 68B50, where the BIOS assumes this intruction is
; already in RAM. If it is not, the BIOS dispays "A>" then hangs.
            LD   A,0xC3         ;Instruction op-code = "JP nn"
            LD   (0x0038),A     ;Write to interrupt mode 1 address
; Set up CP/M iobyte as RC2014 BIOS fails to do this due to paging issue
; whereby ROM is paged back in at the time it attempts to write to iobyte
; Currently D = 1 for port A, 2 for port B
; CP/M iobyte must be 0 = port B, 1 = port A
            LD   A,D            ;Get console device (1 = port A, 2 = port B)
            CP   1              ;Port A?
            JR   Z,@iobyte      ;Yes, so skip
            XOR  A              ;A = 0 for port B
@iobyte:    LD   (0x0003),A     ;Store iobyte (1 = port A, 0 = port B)
; Push SIO port number (0 = port A, 1 = port B) so that any CBIOS
; that correctly sets iobyte still works
            LD   A,D            ;Get console device (1 = port A, 2 = port B)
            DEC  A              ;Adjust to 0 = port A, 1 = port B
            PUSH AF             ;Store console device number on stack
; Move CP/M to top of memory, overwriting SCMonitor workspace
            LD   HL,LoadTop     ;Top of bytes loaded
            LD   DE,CPMTop      ;Top of CP/M's memory
            LD   BC,LoadBytes   ;Number of bytes loaded
            LDDR                ;Move loaded bytes
; Start CP/M using entry at top of BIOS
            LD   HL,($FFFE)     ;Get start up address
            jp   (HL)           ;Run code downloaded from compact flash


; Wait until compact flash is ready
Wait:
@TstBusy:   IN   A,(CF_STATUS)  ;Read status register
            BIT  7,A            ;Test Busy flag
            JR   NZ,@TstBusy    ;High so busy
@TstReady:  IN   A,(CF_STATUS)  ;Read status register
            BIT  6,A            ;Test Ready flag
;           JR   Z,@TstReady    ;Low so not ready
            JR   Z,@TstBusy     ;Low so not ready
            RET

; Error message
MsgNotFound:
            .DB  "Compact flash not present",0x0D,0x0A,0



; **********************************************************************
; Memory Management Unit (MMU)
;
kZ180:      .EQU kZ180Base      ;Z180 internal register base address
CBR:        .EQU kZ180 + 0x38   ;MMU Control Base Register
BBR:        .EQU kZ180 + 0x39   ;MMU Bank Base Register
CBAR:       .EQU kZ180 + 0x3A   ;MMU Common/Bank Register

; Page RAM into logical memory (0x0000 to 0x7FFF)
;
; Set up logical (64k) memory to physical (1M) memory mapping
; such that the bottom 32k bytes of logical memory is the bottom 32k
; bytes of the physical RAM, and the top 32k bytes of logical 
; memory is the top 32k bytes of the physical RAM.
;    Common(0) 0x0000 to 0x0000 -> 0x00000 to 0x00000 (ROM)
;    Bank      0x0000 to 0x7FFF -> 0x80000 to 0x87FFF (RAM)
;    Common(1) 0x8000 to 0xFFFF -> 0x88000 to 0x8FFFF (RAM)
; 
; This is achieved by setting the registers as follows:
;    CBAR = CA.BA = 0x8.0x0 = 0x80
;    BBR  = (physical address)/0x1000 - BA = 0x80 - 0x0 = 0x80
;    CBR  = (physical address)/0x1000 - BA = 0x88 - 0x8 = 0x80
MMU_RAM:    LD   A, 0x80        ;Physical memory base address:
            OUT0 (BBR), A       ;  Bank Base   = 0x80000 to 0x87FFF
;           LD   A, 0x80        ;Physical memory base address:
            OUT0 (CBR), A       ;  Common Base = 0x88000 to 0x8FFFF
;           LD   A, 0x80        ;Logical memory base addresses:
            OUT0 (CBAR), A      ;  Bank   = 0x0000 to 0x7FFF
            RET                 ;  Common = 0x8000 to 0xFFFF













