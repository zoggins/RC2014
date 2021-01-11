..\sjasm.exe IODEMO.ASM IODEMO.OUT
..\srec_cat.exe IODEMO.OUT -binary  -offset 0x0200 -Output IODEMO.IHEX -Intel -address_length 2