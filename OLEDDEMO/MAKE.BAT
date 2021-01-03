..\tniasm.exe OLEDDEMO.ASM OLEDDEMO.OUT
..\srec_cat.exe OLEDDEMO.OUT -binary  -offset 0x0200 -Output OLEDDEMO.IHEX -Intel -address_length 2