Compact Flash Test

This program is written as an App for the Small Computer Monitor v1.0
and later.

This program writes test data to compact flash card and verifies it.
For each sector:
* Fill sector+0 with 0x00
* Fill sector+1 with 0xFF
* Fill sector+2 with 0x55
* Fill sector+3 with 0xAA
* Verify all 4 sectors contain the correct data
* Increment sector number
The sector address Sector+n only uses 8-bit addition so the current 
sector test wraps around in blocks of 256 sectors.
Each sector is only written to 4 times during this test, so flash wear
should not be a concern.
The program pauses if an error occurs, giving you the choice to continue
or end the test.

The program implements the recommended status checks and also test for 
errors reported by the Compact Flash card. As a result it should be
reliable. It is also informative if problems are detected.

Compact Flash cards in binary multiples from 1MB to 2TB should be 
correctly identified and described. So 1MB, 2MB, 4MB, 8MB, 16MB, 32MB, 
64MB should be correct, but a 48MB card will likely be reported as 32MB. 
It was much easier to deal with just the binary multiples than all 
possible sizes, so I took the easy way out. My bad!

Compatible with LiNC80, Z50Bus, and RC2014 systems.

The hex file can be download to SCM by using a terminal program's
"Send file" feature to send a .HEX file to SCM.

Typically the program is started with the SCM command "G 8000"


SCC 2022-03-17

