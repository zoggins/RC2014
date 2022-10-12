; **********************************************************************
; **  Small Computer Monitor (SCM)    v1.3.0    by Stephen C Cousins  **
; **                                                                  **
; **  Developed with Small Computer Workshop (IDE)     www.scc.me.uk  **
; **********************************************************************

; **********************************************************************
; Options (comment out any that are not required)

#DEFINE     xBUILD_AS_COM_FILE  ;Build as CP/M style .COM file (not as ROM)

; **********************************************************************
; Only one build configuration can be defined so comment out the others

; Tested with this version of SCM code
;#INCLUDE   Config\config_F1_SC516_118.asm  ;F1, "Z50Bus/Z80",  as SC516 & SC118
#INCLUDE   Config\config_F2_SC519.asm         ;F2, "Z50Bus/Z80",  as SC519+518
;#INCLUDE   Config\config_F3_SC503_140.asm     ;F3, "Z50Bus/Z180", as SC503 & SC140
;#INCLUDE   Config\config_S2_SC114.asm         ;S2, "RC/Z80",      as SC114
;#INCLUDE   Config\config_S3_SC108.asm         ;S3, "RC/Z80",      as SC108
;#INCLUDE   Config\config_S5_SC111_119.asm     ;S5, "RC/Z180",     as SC111+119, native mode
;#INCLUDE   Config\config_S6_SC126.asm  ;S6, "SC126",       SC126 Z180 SBC / motherboard
;#INCLUDE   Config\config_W1_SCWorkshop.asm ;W1, "SCWorkshop",  SCW simulated hardware

; Not tested with this version of SCM code (see earlier release version)
;#INCLUDE   Config\config_C1_SC121.asm         ;Z80 Processor for Z80sc (SC121)             NOT TESTED
;#INCLUDE   Config\config_E1_CPM.asm           ;External OS = CP/M                          NEEDS WORK
;#INCLUDE   Config\config_E2_RomWBW.asm        ;External OS = RomWBW                        NEEDS WORK
;#INCLUDE   Config\config_J1_ColecoVision.asm  ;ColecoVision games debug on SC126           NOT TESTED
;#INCLUDE   Config\config_S4_SC111.asm         ;S4, "RC/Z180",     as SC111, legacy mode (Z80 replacement)
;#INCLUDE   Config\config_S?_SC130.asm         ;Z180 SBC/Motherboard for RC2014 (SC130)     TO DO
;#INCLUDE   Config\config_S?_SC131.asm         ;Z180 pocket-sized RomWBW computer (SC131)   NOT TESTED
;#INCLUDE   Config\config_Z8_ZORAk.asm         ;Steve Markowski's ZORAk system              CURRENTLY BROKEN

; Personal configurations
;#INCLUDE   Config\config_MySC126.asm          ;SC126 Z80 SBC/Motherboard for RC2014





















