..\sjasm.exe PIODEMO.ASM PIODEMO.OUT
..\srec_cat.exe PIODEMO.OUT -binary  -offset 0x0200 -Output PIODEMO.IHEX -Intel -address_length 2