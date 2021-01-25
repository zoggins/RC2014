..\sjasm.exe PAPTAP.ASM PAPTAP.OUT
..\srec_cat.exe PAPTAP.OUT -binary  -offset 0x9000 -Output PAPTAP.IHEX -Intel -address_length 2