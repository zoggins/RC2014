..\..\..\sjasm.exe RAMP.ASM RAMP.BIN
..\..\..\srec_cat.exe RAMP.BIN -binary  -offset 0x0000 -Output RAMP.IHEX -Intel -address_length 2