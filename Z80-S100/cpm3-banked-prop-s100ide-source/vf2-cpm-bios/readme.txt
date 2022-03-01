Description of Supplied Files - 12/19/03 Bruce Jones
01/29/05 Scipione
updated 2/3/2005 herb johnson
see documentation disk/files for docs.

ASM Source Files

All ASM source files are supplied in TDL Z80 dialect. See the doc section on Source File 
Assembly for details.

V2BIOS.ASM	The CP/M BIOS
V2BOOT1.ASM	bootstrap for drive 0, or A as default
V2BOOT2.ASM	bootstrap for drive 1, or B as default
V2BOOT3.ASM	bootstrap for drive 2, or C as default
V2BOOT4.ASM	bootstrap for drive 3, or D as default
V2BOOTX.ASM     minimal bootstrap sample
V2BOOTX5.ASM    minimal bootstrap sample for mini-floppy
V2COPY.ASM	disk to disk copy, works only with V2BIOS resident
V2FORMAT.ASM	diskette formats
V2SASG.ASM	stand alone Sysgen for V2BIOS type system tracks
V2SASG5.ASM	stand alone Sysgen for V2BIOS type system tracks, mini-floppy
V2SYSGEN.ASM	requires V2BIOS resident 
V2LOADR1.ASM	Image independent system track loader	
V2LOADR2.ASM	Location dependant system track loader
V2LD2001.ASM	SBC-200 use like V2LOADR1, but switches off SBC-200 RAM/ROM 	
V2LD2002.ASM	SBC-200 use like V2LOADR2, but switches off SBC-200 RAM/ROM

HEX - BIOS and Sysgen

V2BIOS32.HEX	32K CP/M V2BIOS
V2BIOS48.HEX	48K CP/M V2BIOS
V2BIOS64.HEX	64K CP/M V2BIOS
V2SASG.HEX	stand alone Sysgen		

COM - Utility

V2BOOT1.COM	Executable bootstrap for drive 0, or A as default
V2BOOT2.COM	Executable bootstrap for drive 0, or A as default
V2BOOT3.COM	Executable bootstrap for drive 0, or A as default
V2BOOT4.COM	Executable bootstrap for drive 0, or A as default
V2FORMAT.COM	Diskette Formats
V2SYSGEN.COM	Executable BIOS dependant Sysgen
V2COPY.COM	disk to disk copy, works only with V2BIOS resident

COM - CP/M Ready to Patch and Sysgen Image Files

CPM32.COM or CPMSB32	32K CP/M with drive 0 as A
CPM48.COM or CPMSB48	48K CP/M with drive 0 as A
CPM64.COM or CPMSB64	64K CP/M with drive 0 as A
CPM48B.COM or CPMSB48B	48K CP/M with drive 1 as A
CPM48C.COM or CPMSB48C	48K CP/M with drive 2 as A
CPM48D.COM or CPMSB48D	48K CP/M with drive 3 as A
CPM48M.COM	48K CP/M maps drive D: to drive B: for mini-floppy use
CPM48MF.COM	48K CP/M Drive A: is a mini-floppy

All images are set to use the SBC-200 USART for console I/O. The USART must already be initialized for some baud rate used by your console. The "SB" images have loaders that switch off the onboard SBC-200 RAM/ROM. With CPM48M you can use drives A, B & C for 8" use, then connect a mini-floppy as second drive and access it as D:.

Other

V2MPMLDR.ASM	MP/M System Loader
V2XIOS60.ASM	XIOS source, MP/M 1.1 or 2.1
V2XIOS60.HEX	HEX version of source, DRI MP/M format 

(See docs for info on these MP/M programs, but they are primarily here as examples.)

SBC200.ASM      SD Systems SBC200 ROM monitor
VDB.ASM         SD Systems VDB 2480 ROM
 
(for use with SDS hardware)

ZASM.COM        Xitan/TDL assembler V2.21 (Technical Design Labs)
DUF04.COM	disk utility V1.04, (C) 1984 Continuum Microsystems Ltd
ALLOC.COM	allocation utility, 1982 by Ward C.
XSUB.COM	extended SUB utility of CP/M 2.2

(development utilities for this code)

Documentation

DIR.TXT		MS-DOS "dir" of these files
DUF.TXT		docs for DUF04
GETSTART.TXT	docs for BIOS, FORMAT and other programs
README.TXT	this document

Commentaries, code by others

SCIPIONE.TXT	2Mhz Z80 code "unrolling" the read/write loop
		written by Fred Scipione Jan 2005
There is a seperate documentation distribution disk (directory) with docs
in PDF and DOC (Word) format.
