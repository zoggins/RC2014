; **********************************************************************
; **  Compact Flash support                     by Stephen C Cousins  **
; **********************************************************************

#IFDEF      GENERIC
#INCLUDE    ..\_CodeLibrary\CompactFlash_Generic.asm
#ENDIF

#IFDEF      Z280RC
#INCLUDE    ..\_CodeLibrary\CompactFlash_Z280RC.asm
#ENDIF


