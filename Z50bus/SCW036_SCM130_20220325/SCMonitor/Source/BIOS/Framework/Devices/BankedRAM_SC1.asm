; **********************************************************************
; **  Device Driver                             by Stephen C Cousins  **
; **  Hardware: SC114, and compatibles                                **
; **  Interface: Banked RAM                                           **
; **********************************************************************

; SCM BIOS framework compliant driver for banked RAM type SC1.
; Two 64k banks are supported: primary and secondary. No shared memory!

; The hardware interface consists of:
; Bank select bit          port <kBankPrt> bit 0
; When high this bit selects the secondary RAM bank
;
; Externally definitions required:
;kBankPrt:  .EQU 0x30           ;Bit 0 high selects secondary RAM bank 


            .CODE


; **********************************************************************
; Read from banked RAM
;   On entry: DE = Address in secondary bank
;   On exit:  A = Byte read from RAM
;             F BC DE HL not specified
;             IX IY I AF' BC' DE' HL' preserved
H_RdRAM:    LD   C,kBankPrt     ;Bank select port address
            LD   B,1            ;Make B=1
            OUT  (C),B          ;Select secondary RAM bank
            LD   A,(DE)         ;Read from RAM
            DEC  B              ;Make B=0
            OUT  (C),B          ;Select primary RAM bank
            RET


; **********************************************************************
; Write to banked RAM
;   On entry: A = Byte to be written to RAM
;             DE = Address in secondary bank
;   On exit:  AF BC DE HL not specified
;             IX IY I AF' BC' DE' HL' preserved
H_WrRAM:    LD   C,kBankPrt     ;Bank select port address
            LD   B,1            ;Make B=1
            OUT  (C),B          ;Select secondary RAM bank
            LD   (DE),A         ;Write to RAM
            DEC  B              ;Make B=0
            OUT  (C),B          ;Select primary RAM bank
            RET


; **********************************************************************
; **  End of device driver                                            **
; **********************************************************************

