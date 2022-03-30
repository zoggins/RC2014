; **********************************************************************
; **  Included BIOS support for common RC2014 bus modules             **
; **********************************************************************

#INCLUDE    Config\Modules\SC110.asm  ;Serial module (SIO/2 and CTC)
#INCLUDE    Config\Modules\SC102_n1.asm ;Z80 CTC module #1
#INCLUDE    Config\Modules\SC102_n2.asm ;Z80 CTC module #2
#INCLUDE    Config\Modules\SC104_n1.asm ;Z80 SIO/2 module #1
#INCLUDE    Config\Modules\SC104_n2.asm ;Z80 SIO/2 module #2
#INCLUDE    Config\Modules\SC132_n1.asm ;Z80 SIO/0 module #1
#INCLUDE    Config\Modules\SC132_n2.asm ;Z80 SIO/0 module #2
#INCLUDE    Config\Modules\SC129.asm  ;Digital I/O 

#INCLUDE    Config\Modules\Karlab_33_n1.asm ;ACIA module #1
#INCLUDE    Config\Modules\Karlab_33_n2.asm ;ACIA module #2
#INCLUDE    Config\Modules\Karlab_61_n1.asm ;ACIA + Compact Flash module #1
#INCLUDE    Config\Modules\Karlab_61_n2.asm ;ACIA + Compact Flash module #2

#INCLUDE    Config\Modules\RC2014_ACIA.asm  ;RC2014 ACIA module
#INCLUDE    Config\Modules\RC2014_CFCard.asm  ;RC2014 ACIA module
#INCLUDE    Config\Modules\RC2014_SIO.asm ;RC2014 Z80 SIO module

;#INCLUDE   Config\Modules\ZORAk_ZSC_n1.asm ;ZORAk System Console #1 (Zilog SCC)
;#INCLUDE   Config\Modules\ZORAk_ZSC_n2.asm ;ZORAk System Console #2 (Zilog SCC)

#DEFINE     CFBASE1 0x10        ;Base address for CF card #1






