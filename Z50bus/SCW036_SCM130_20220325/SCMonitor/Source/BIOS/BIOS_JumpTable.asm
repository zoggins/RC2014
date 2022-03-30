; **********************************************************************
; **  BIOS Jump Table                           by Stephen C Cousins  **
; **********************************************************************

            .CODE

; Jump Table
; All hardware specific functions should be accessed through this table
HW_Test:    JP   H_Test         ;Selftest
HW_Init:    JP   H_Init         ;Initialise
HW_GetName: JP   H_GetName      ;Get hardware name message
HW_GetVers: JP   H_GetVers      ;Get version details
HW_SetBaud: JP   H_SetBaud      ;Set baud rate
HW_IdleSet: JP   H_IdleSet      ;Idle event set up
HW_MsgDevs: JP   H_MsgDevs      ;Output devices message
HW_RdRAM:   JP   H_RdRAM        ;Read banked RAM
HW_WrRAM:   JP   H_WrRAM        ;Write banked RAM
HW_CopyROM: JP   H_CopyROM      ;Copy ROM filing system to RAM
HW_ExecROM: JP   H_ExecROM      ;Execute code in ROM filing system
HW_Delay:   JP   H_Delay        ;Delay by DE milliseconds



