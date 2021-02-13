..\sjasm.exe SID.ASM SID.OUT
..\srec_cat.exe SID.OUT -binary  -offset 0xF800 -Output SID.IHEX -Intel -address_length 2