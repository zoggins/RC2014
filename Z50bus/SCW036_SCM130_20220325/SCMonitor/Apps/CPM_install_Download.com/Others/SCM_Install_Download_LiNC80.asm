; **********************************************************************
; **  LiNC80-friendly Wrapper for DOWNLOAD2.HEX      by Jon Langseth  **
; **********************************************************************
;
; Grant Searle's DOWNLOAD2.HEX contains the useful DOWNLOAD.COM transient
; for CP/M, designed to be loaded with his "relocator" placed at FFE8.
; Unfortunately, that loader does not work well in the LiNC80 with SCMon,
; and to retain compatibility with Grant Searle's Loader, I have no wish
; to patch it to work with SCMon. Because of that, I made this replacement.
;
; This code is designed to be built using SCWorkshop (see http://scc.me.uk)
; It loads DOWNLOAD2.HEX automagically to $4100-> and provides a simple
; memory relocator on $8000->
;
; To use, boot into SCMon and paste in the compiled HEX file
; Then execute the relocator using the "G8000" command. When you are
; returned to the monitor, boot to CP/M using the CPM command, and
; save the binary data using "SAVE 2 DOWNLOAD.COM"

            .PROC Z80           ;Select Z80 processor
            .HEXBYTES 0x18      ;Intel Hex output format

SrcAdr      .EQU $4100
SrcLen      .EQU $1000
TPA         .EQU $0100

CodeORG     .EQU $8000

iConfigCpy  .EQU $FFF0
iConfigPre  .EQU $FFF1

kConfigReg  .EQU $38

            ; Source the original DOWNLOAD2.HEX
            .ORG SrcAdr
            
#INSERTHEX  Includes/DOWNLOAD2.hex

            ; The "FFE8-replacement":
            .ORG CodeORG
            
            ; Output a startup message
            LD   DE,MsgStarting
            LD   C,6            ; Use SCMon API 0x06
            CALL 0x30           ;  = Output string

            ; AFAIK, we decided to not include a ConfReg API handler
            ; So, at least for now, use hard coded behaviour to disable ROM:
            LD   A,(iConfigCpy) ;Get current config byte
            LD   (iConfigPre),A ;Store as 'previous' config byte
            
            LD   A,$01
            LD   (iConfigCpy),A ;Store new value to shadow copy
            OUT  (kConfigReg),A ;Set the config register

            ; Do the copy. It's a simple LDIR of SrcLen bytes from SrcAdr to TPA
            LD   HL, SrcAdr
            LD   DE, TPA
            LD   BC, SrcLen
            LDIR   
            
            ; Load the original config register content from the shadow register
            LD   A,(iConfigPre) ;Get previous config byte
            LD   (iConfigCpy),A ;Store as current config byte
            OUT  (kConfigReg),A ;Set the config register

            ; Signoff message, we're done.
            LD   DE,MsgDone
            LD   C,6
            CALL 0x30

            RET
            
MsgStarting:
        .DB "Disabling ROM and copying data to RAM",0x0D,0x0A,0
MsgDone:
        .DB "Done copying data from $4100 to $0100. ROM restored.",0x0D,0x0A,"Boot to CPM and run SAVE 2 DOWNLOAD.COM",0x0D,0x0A,0