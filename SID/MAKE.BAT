..\sjasm.exe SID.ASM SID.OUT
..\srec_cat.exe SID.OUT -binary  -offset 0xF800 -Output SID.IHEX -Intel -address_length 2

..\sjasm.exe SID1.ASM SID1.OUT
..\srec_cat.exe SID1.OUT -binary  -offset 0x0200 -Output SID1.IHEX -Intel -address_length 2

..\sjasm.exe SID2.ASM SID2.OUT
..\srec_cat.exe SID2.OUT -binary  -offset 0x0200 -Output SID2.IHEX -Intel -address_length 2

..\sjasm.exe SID3.ASM SID3.OUT
..\srec_cat.exe SID3.OUT -binary  -offset 0x0200 -Output SID3.IHEX -Intel -address_length 2