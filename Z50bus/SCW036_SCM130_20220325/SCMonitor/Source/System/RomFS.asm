; **********************************************************************
; **  ROM Filing System module                  by Stephen C Cousins  **
; **********************************************************************
;
; This module provides a simple read only filing system designed to
; allow code and data to be stored in ROM, including banked ROM.

; For a system with multiple ROM banks, each 16k bytes long and 
; starting at address 0x0000, the first reference is 0x3FF0, the second 
; at 0x3FE0, and so on.
;
; WARNING: Supports a maximum of 15 files in each ROM bank
;
; Each file reference contains the following bytes:
; Offset    Description
; +0x00     Reference identifier byte 0x55
; +0x01     Reference identifier byte 0xAA
; +0x02     File name, 8 characters, padded with trailing spaces
; +0x0A     File type and flags (see below)
; +0x0B     File destination (see below)
; +0x0C     File start address, 16-bit, low byte first
; +0x0E     File length, 16-bit, low byte first
;
; The file name contains eight ASCII characters. File names shorter than 
; eight characters long have the unused trailing bytes filled with ASCII 
; spaces (0x20). The file name can contain characters A to Z, a to z, 0 
; to 9, underscore, but no spaces other than the trailing bytes.
; File names must be at least two characters long so they do not 
; conflict with single letter monitor commands.
;
; File types and flags:
;  +-------+-------+-------+-------+-------------------------------+
;  | Auto  | Move  | 0     | 0     | File type (0 to 15)           |
;  +-------+-------+-------+-------+-------+-------+-------+-------+
;  | Bit 7 | Bit 6 | Bit 5 | Bit 4 | Bit 3 | Bit 2 | Bit 1 | Bit 0 |
;  +-------+-------+-------+-------+-------+-------+-------+-------+
;  File flags:                       File types:
;  Bit 7 = Auto run                  0 = .DAT  Unspecified
;  Bit 6 = Move* to RAM and run      1 = .COM  Monitor command
;  Bit 5 = Reserved (zero)           2 = .EXE  Executable
;  Bit 4 = Reserved (zero)           3 = .HLP  Help
;  * = see 'destination'             4 = .TXT  Text
;
; Type 0 files: (Unspecified)
; The contents of these files is ignored by the Monitor.
;
; Type 1 files: (Monitor commands)
; These are commands that can be issued from the Monitor and require 
; the Monitor in order to function.
; These files can not be executed from other ROM banks.
;
; Type 2 files: (Executable)
; These are commands that can be issued by the Monitor but do no
; require the Monitor to function.
; These files can not be executed from other ROM banks.
; Type 2 files can also be bootable ROMs which make no use of the 
; Monitor.
;
; Type 3 files: (Help)
; These are simple text files, which are output at the end of the 
; Monitor own help text.
; Typically these are used to describe executable code (type 1 or 2)
; which can be run from the Monitor's command line.
; Help text should be kept short, being made up of one or more lines
; each terminated with CR (0x0D) and LF (0x0A). The end of the help
; text is terminated with a Null (0x00).
;
; Type 4 files: (Text)
; Not currently used by the Monitor
;
; The destination byte, if required, is the hi byte of the address
; to which the file is copied. If the 'move' flag is not set then this
; byte should be 0x00.
;
; The start word is the address is the absolute address in the CPU's
; memory map when the host ROM bank is paged in. 
; To allow easy testing the Monitor removes 'bank select' bits from
; the address. For example, an address from start of 32K ROM of 0x7000
; is treated as 0x3000, as this is the address it will be once paged
; into the CPU's memory map.
;
; The file length is only currently used for files that need to be 
; copied to RAM. However, all files should include this to support
; future uses which may rely on knowing the length of any file.
;
; Example file reference:
;           .DW  0xAA55         ;Identifier
;           .DB  "TEST    "     ;File name ("TEST.COM")
;           .DB  0x41           ;File type 2 = Command, moved to RAM
;           .DB  0xF0           ;Move code to 0xF000 to run it
;           .DW  CmdTest        ;Start address
;           .DW  CmdTestEnd-CmdTest ;Length


; **********************************************************************
; **  Constants                                                       **
; **********************************************************************

; Fixed address to allow external code to use this data
kTrFileRe2: .EQU 0xFFD0         ;Transient file reference
kTrFileRef: .EQU 0xFFE0         ;Transient file reference


; **********************************************************************
; **  Public functions                                                **
; **********************************************************************

            .CODE

; Initialise the ROM filing system
;   On entry: No parameters required
;   On exit:  IX IY I AF' BC' DE' HL' preserved
RomInitialise:
            ;CALL RomPageInit   ;Initialise ROM paging, done in BIOS
            XOR  A
            LD   (iRomMap),A    ;Clear echoed bank flags
            CALL RomEcho        ;Mask out ROM banks which are echos
; Auto run any suitably flagged files
            CALL RomSearchInit
@Loop:      CALL RomSearchNext
            RET  NZ
            LD   A,(kTrFileRef+0x0A)
            BIT  7,A            ;Autorun?
            CALL NZ,RomRun      ;Execute this file
            JR   @Loop


; Determine which ROM banks are real and which are echos
;   On entry: No parameters required
;   On exit:  IX IY I AF' BC' DE' HL' preserved
; This table shows the possible ROM banks and any echoed copies
;  +--------------------+-----------+-----------+-----------+-----------+
;  | Configuration reg  | 64k EPROM | 32k EPROM | 32k EEPRM | 16k EPROM |
;  | ROM Bank selection | A15=ROS1  | A15=n/a   | A15=n/a   | A15=n/a   |
;  |          ROS1 ROS0 | A14=ROS0  | A14=ROS0  | A14=ROS1  | A14=n/a   |
;  +--------------------+-----------+-----------+-----------+-----------+
;  | Bank 0     0    0  |  Bank 0   |  Bank 0   |  Bank 0   |  Bank 0   |
;  | Bank 1     0    1  |  Bank 1   |  Bank 1   |  Echo 0 - |  Echo 0 - |
;  | Bank 2     1    0  |  Bank 2   |  Echo 0 - |  Bank 1   |  Echo 0 - |
;  | Bank 3     1    1  |  Bank 3   |  Echo 1 - |  Echo 1 - |  Echo 0 - |
;  +--------------------+-----------+-----------+-----------+-----------+
; To eliminate bank echos:
; If bank 0 = bank 1 then bank 1 is echo and bank 3 is echo
; If bank 0 = bank 2 then bank 2 is echo and bank 3 is echo
RomEcho:    LD   A,0            ;Bank zero
            LD   L,0xF0         ;First reference in bank
            CALL RomGetRef      ;Read reference to RAM
            LD   HL,kTrFileRef  ;Copy file reference to
            LD   DE,kTrFileRe2  ;  second reference buffer
            LD   BC,16          ;Length of file reference
            LDIR                ;Copy (HL) to (DE) and repeat x BC
            LD   A,1            ;Bank one
            LD   L,0xF0         ;First reference in bank
            CALL RomGetRef      ;Read reference to RAM
            CALL @RomComp       ;Compare banks
            JR   NZ,@Test2      ;Not the same so skip
            LD   A,0b00001010   ;Banks 1 and 3 are echos
            LD   (iRomMap),A    ;Store echoed bank flags
@Test2:     LD   A,2            ;Bank two
            LD   L,0xF0         ;First reference in bank
            CALL RomGetRef      ;Read reference to RAM
            CALL @RomComp       ;Compare banks
            RET  NZ             ;Not the same so finished
            LD   A,(iRomMap)    ;Get echoed flag bits so far
            OR   0b00001100     ;Banks 2 and 3 are echos
            LD   (iRomMap),A    ;Store echoed bank flags
            RET
; Compare file reference from two banks to check for ROM echo
@RomComp:   LD   B,16           ;Compare 16 bytes
            LD   HL,kTrFileRef  ;First file reference
            LD   DE,kTrFileRe2  ;Second file reference
@Loop:      LD   A,(DE)         ;Compare byte from each...
            CP   (HL)
            RET  NZ             ;Not the same so return NZ flagged
            INC  HL
            INC  DE
            DJNZ @Loop          ;Repeat for all 16 bytes
            RET                 ;Same so return Z flagged


; Initialise file reference search
;   On entry: No parameters required
;   On exit:  iRomBank and iRomRefLo are the 'previous' reference
;             BC DE HL IX IY I AF' BC' DE' HL' preserved
; First call RomSearchInit to initialise a file reference search
; Then repeatedly call RomSearchNext to read file references
RomSearchInit:
            XOR  A
            LD   (iRomBank),A   ;Start with bank zero
            LD   (iRomRefLo),A  ;Start with first reference
            RET


; Get next file reference from ROM
;   On entry: iRomBank and iRomRefLo are the previous reference
;   On exit:  iRomBank and iRomRefLo are the current reference
;             If a valid reference found Z is flagged
;             DE IX IY I AF' BC' DE' HL' preserved
; First call RomSearchInit to initialise a file reference search
; Then repeatedly call RomSearchNext to read file references
RomSearchNext:
            LD   HL,iRomRefLo   ;Point to lo byte of ref address
            LD   A,(HL)         ;Get current reference address lo
            SUB  16             ;Move down to next reference
            LD   (HL),A         ;Update current reference address lo
; Get current file reference
            LD   L,A            ;Store current reference lo byte
            LD   A,(iRomBank)   ;Get current ROM bank
            PUSH DE
            CALL RomGetRef      ;Get the file reference
            POP  DE
            LD   HL,(kTrFileRef)  ;Get reference identifier
            LD   A,L            ;For valid ref L = 0x55
            XOR  H              ;For valid ref H = 0xAA
            INC  A              ;Valid file?
            RET  Z              ;Yes, so return with Z flagged
; Select next ROM bank
@NextBank:  LD   A,(iRomBank)   ;Get current ROM bank
            INC  A              ;Point to next ROM bank
            LD   B,A            ;Remember ROM bank for later
            LD   (iRomBank),A   ;Store new ROM bank
            AND  A,kROMBanks    ;Finished all ROM banks?
            RET  NZ             ;Yes, so end with NZ flagged
            LD   C,0x01         ;Prepare bit mask for this bank
@Rotate:    RLC  C              ;Rotate bit mask 'B' times
            DJNZ @Rotate        ;  Bit 1 set for bank 1 etc
            LD   A,(iRomMap)    ;Bit maps of ROM bank echos
            AND  C              ;Test if current bank is an echo
            JR   NZ,@NextBank   ;Skip this bank if it is an echo
            XOR  A              ;First reference in ROM
            LD   (iRomRefLo),A  ;Store new reference address
            JR   RomSearchNext  ;Go consider next file reference


; Get pointer to current position in command line string
;   On entry: No parameters required
;   On exit:  DE = Address of string typically in command line
;             AF BC HL IX IY I AF' BC' DE' HL' preserved
; This function is called by the API
; Used by monitor command files to read command parameters
RomGetPtr:  LD   DE,(iRomTemp)  ;Get pointer to command line 
            RET


; Execute file in ROM matching named pointed to be DE
;   On entry: DE = Address of string typically in command line
;   On exit:  If command executed A = 0x00 and Z flagged
;             IX IY I AF' BC' DE' HL' preserved
RomExFile:  LD   (iRomTemp),DE  ;Store start of command string
            CALL RomSearchInit
@NextFile:  CALL RomSearchNext  ;Find next file reference
            RET  NZ             ;End of ROM files so exit
            LD   A,(kTrFileRef+0x0A)  ;Get type
            AND  0x0F           ;Remove flag bits
            CP   1              ;Monitor command?
            JR   Z,@GotFile     ;Yes, so go check name
            CP   2              ;Executable code?
            JR   NZ,@NextFile   ;No, so go look for next file
; Found executable file so see if the file name is a match
@GotFile:   LD   DE,(iRomTemp)  ;Get start of command string
            LD   HL,kTrFileRef+2  ;Get pointer to file name
            LD   B,8            ;Maximum length
@Compare:   LD   A,(HL)         ;Character from ROM
            CP   kSpace         ;Space?
            JR   Z,@Check       ;Yes, so possible match
            CALL ConvertCharToUCase
            LD   C,A            ;Store char from ROM in UCase
            LD   A,(DE)         ;Get char from command name
            CP   kSpace+1       ;<= Space?
            JR   C,@NextFile    ;Yes, so too short
            CALL ConvertCharToUCase
            CP   C              ;Matching character?
            JR   NZ,@NextFile   ;No, so no match
            INC  HL             ;Point ot next char in ROM
            INC  DE             ;Point ot next char in command
            DJNZ @Compare       ;Loop until max characters
            JR   RomRun         ;Match, so run the file
; Check we are also at end of command name
@Check:     LD   A,(DE)         ;Get char from command name
            CP   kSpace+1       ;<= Space?
            JR   NC,@NextFile   ;Yes, so too long
            LD   (iRomTemp),DE  ;Update sommand line pointer
            ;JR   RomRun        ;Match, so run the file
;
; Found file so execute it
; WARNING: Call here RomInitialise for autorun function
RomRun:     LD   A,(kTrFileRef+0x0A)  ;Get file type
            BIT  6,A            ;Move code first
            JR   NZ,@Move       ;No, so go move code
; Execute direct from ROM
            LD   A,(iRomBank)   ;Get code's ROM bank
            LD   DE,(kTrFileRef+0x0C) ;Get start address
            CALL HW_ExecROM     ;Run the executable
@Return:    XOR  A              ;Executed file, so return
            RET                 ;  A=0 and Z flagged
; Move code to RAM before running it
@Move:      LD   HL,(kTrFileRef+0x0C) ;Get start address
            LD   BC,(kTrFileRef+0x0E) ;Get length address
            LD   A,(kTrFileRef+0x0B)  ;Get destination MSB
            LD   D,A            ;Set destination MSB
            LD   E,0            ;Set destination LSB to zero
            LD   A,(iRomBank)   ;get code's ROM bank
            CALL HW_CopyROM     ;Move code to RAM
            LD   A,(kTrFileRef+0x0B)  ;Get destination MSB
            LD   H,A            ;Set destination MSB
            LD   L,0            ;Set destination LSB to zero
            LD   BC,@Return     ;Get return address
            PUSH BC             ;Push return address onto stack
            JP   (HL)           ;Execute at start address


; Get help from current file reference
;   On entry: File reference must be in RAM
;   On exit:  DE = Pointer to start of Help string
;             IX IY I AF' BC' DE' HL' preserved
RomGetHlp:  LD   HL,(kTrFileRef+0x0C) ;Get start address
            LD   BC,(kTrFileRef+0x0E) ;Get length address
            LD   DE,kStrBuffer  ;Copy help to string buffer
            LD   A,(iRomBank)   ;get code's ROM bank
            CALL HW_CopyROM     ;Move code to RAM
            LD   DE,kStrBuffer  ;Copy help to string buffer
            RET


; Get pointer to file name
;   On entry: File reference must be in RAM
;   On exit:  DE = Pointer to start of Help string
;             BC HL IX IY I AF' BC' DE' HL' preserved
; Returns a string with length as first byte and no Null terminator
RomGetName: LD   A,8            ;Length of file name
            LD   DE,kTrFileRef+1  ;Location in file reference
            LD   (DE),A         ;Store length as start of name
            RET


; Get file type 
;   On entry: File reference must be in RAM
;   On exit:  A = File type and flags for current file reference
;             BC DE HL IX IY I AF' BC' DE' HL' preserved
RomGetType: LD   A,(kTrFileRef+10)
            RET


; Get file info 
;   On entry: File reference must be in RAM
;   On exit:  DE = File's start address in the ROM
;             BC = File's length
;             AF HL IX IY I AF' BC' DE' HL' preserved
RomGetInfo: LD   DE,(kTrFileRef+0x0C) ;Start address
            LD   BC,(kTrFileRef+0x0E) ;File length
            RET


; Get file reference from ROM
;   On entry: A = ROM bank number (0 to 3)
;             L = Lo byte of file reference address
;   On exit:  IX IY I AF' BC' DE' HL' preserved
; A file reference is copied from ROM to a fixed location in RAM
RomGetRef:  LD   A,(kaRomTop)   ;Hi byte of reference address (kROMTop)
            LD   H,A            ;Store hi byte of reference address
            LD   DE,kTrFileRef  ;Transient storage for reference
            LD   BC,16          ;Length of file reference
            PUSH HL             ;preserve reference address
            CALL HW_CopyROM     ;Go copy ref from ROM to RAM
            POP  HL             ;Restore reference address
; Ensure start address is the absolute address in the memory map
            LD   A,(kTrFileRef+0x0D)  ;Get start address hi byte
            AND  H              ;Mask with top of ROM (ref. address)
            LD   (kTrFileRef+0x0D),A  ;Store start address hi byte
            RET


; **********************************************************************
; **  Private workspace (in RAM)                                      **
; **********************************************************************

            .DATA

iRomBank:   .DB  0x00
iRomRefLo:  .DB  0x00
iRomMap:    .DB  0x00           ;One bit for each bank, 1=Echo
iRomTemp:   .DW  0x0000

; **********************************************************************
; **  End of ROM Filing System module                                 **
; **********************************************************************









