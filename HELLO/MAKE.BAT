..\sjasm.exe HELLO.ASM HELLO.OUT
..\srec_cat.exe HELLO.OUT -binary  -offset 0x0200 -Output HELLO.IHEX -Intel -address_length 2