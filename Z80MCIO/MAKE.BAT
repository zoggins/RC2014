..\sjasm.exe Z80MCIO.ASM Z80MCIO.OUT
..\srec_cat.exe Z80MCIO.OUT -binary  -offset 0x8000 -Output Z80MCIO.IHEX -Intel -address_length 2
echo :00000001FF>> Z80MCIO.IHEX
echo :00000001FF>> Z80MCIO.IHEX