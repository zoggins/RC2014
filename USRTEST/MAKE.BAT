..\sjasm.exe USRTEST.ASM USRTEST.OUT
..\srec_cat.exe USRTEST.OUT -binary  -offset 0x0200 -Output USRTEST.IHEX -Intel -address_length 2