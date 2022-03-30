Extracts from email: (from Francis to Steve)


I’m trying to get I2C to work on the front panel 4x20 LCD display.
 
I prefered the I2C interfacing because I wanted to save a slot and limit the costs.
 
I took the routines from your I2C and SC129/LCD example and modified them :
I replaced the “OUT  (kLCDPrt), A” in Alphanumeric_LCD.asm by a “CALL I2C_Write”
I added an I2C open and close around the fLCD_Inst and fLCD_Data routines
I replaced the main example code by the one from the LCD example, so it should be initializing I2C, then sending some hello messages.
I changed the kLCDBitE and kLCDBitRS numbers for E and Rs signals to the ones for the I2C adapter I use (8574 based with Rs on P0, RW on P1 and E on P2).
 
The LCD module I have has a soldered I2C adapter with a 8574 using Hitachi protocol. The same display worked fine using your LCD example on an SC129. I have checked it OK on an Arduino with the LiquidCrystal_LCD library so the bit values for E and Rs should be correct.
 
Banggood : https://www.banggood.com/IIC-I2C-2004-204-20-x-4-Character-LCD-Display-Screen-Module-Blue-p-908616.html?rmmds=myorder&cur_warehouse=CN
 
Francis