; **********************************************************************
; **  RC2014 Download.com installer             by Stephen C Cousins  **
; **********************************************************************

; The program aids installation of Download.com on to a RC2014 CP/M
; system.

            .PROC Z80           ;SCWorkshop select processor

            .ORG 0x8000

; Page ROM out of memory
            LD   A,1
            OUT  (0x38),A

; Move downlaod.com program code to 0x0100 
            LD   HL,Program
            LD   DE,0x0100
            LD   BC,ProgramEnd-Program
            LDIR   

; Page ROM back into memory
            LD   A,0
            OUT  (0x38),A

; Display instructions
            LD   DE,Message
            LD   C,6            ;API 0x06
            RST  0x30           ;  = Output string

            RET

Message:    .DB  "Download.com is ready to be saved.",0x0D,0x0A
            .DB  "Start CP/M and enter SAVE 2 DOWNLOAD.COM",0x0D,0x0A
            .DB  0

Program:
#INSERTHEX  Includes/DOWNLOAD2.hex
ProgramEnd:

            .END

