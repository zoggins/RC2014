..\tniasm.exe OLED.ASM OLED.OUT
..\srec_cat.exe OLED.OUT -binary -offset 0x1000 -Output OLED.IHEX -Intel -address_length 2