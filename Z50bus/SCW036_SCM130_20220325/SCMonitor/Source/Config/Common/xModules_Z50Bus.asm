; **********************************************************************
; **  Included BIOS support for common Z50Bus modules                 **
; **********************************************************************

; Support for SC521 is included in support for SC511

#INCLUDE    Config\Modules\SC504.asm  ;Compact flash interface card
;INCLUDE    Config\Modules\SC505.asm  ;RTC (DS1302) and I2C bus master card
#INCLUDE    Config\Modules\SC506.asm  ;Digital I/O card
;INCLUDE    Config\Modules\SC509.asm  ;Parallel (Z80 PIO) card
#INCLUDE    Config\Modules\SC511_n1.asm ;Serial (Z80 SIO) and timer (Z80 CTC) card #1
#INCLUDE    Config\Modules\SC511_n2.asm ;Serial (Z80 SIO) and timer (Z80 CTC) card #1
;INCLUDE    Config\Modules\SC514.asm  ;Counter/timer (Z80 CTC) card
#INCLUDE    Config\Modules\SC520_n1.asm ;Serial (68B50 ACIA) card #1 
#INCLUDE    Config\Modules\SC520_n2.asm ;Serial (68B50 ACIA) card #2
;INCLUDE    Config\Modules\SC521_n1.asm ;Serial (Z80 SIO) #1 - see SC511
;INCLUDE    Config\Modules\SC521_n2.asm ;Serial card #2 (Z80 SIO) - see SC511

#INCLUDE    Config\Modules\SC125_n1.asm ;Serial (Z80 SIO) and timer (Z80 CTC) card #1
#INCLUDE    Config\Modules\SC125_n2.asm ;Serial (Z80 SIO) and timer (Z80 CTC) card #2
#INCLUDE    Config\Modules\SC127.asm  ;Compact flash interface card
#INCLUDE    Config\Modules\SC129.asm  ;Digital I/O  card

#DEFINE     CFBASE1 0x90              ;Base address for CF card #1




