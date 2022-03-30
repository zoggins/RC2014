Memory test program for use with SCMonitor.

This memory test is for systems with a full 64K of RAM and a mechanism
to page out the ROM.

The test repeats until the Escape key is pressed or a failure is detected.

Load the program into the target system by sending the hex file from a terminal program.

The code starts at $8000, so is started with the Monitor command "G 8000".

If a failure is detected, the memory location is written to address $8070/1.


There are several versions of the .HEX file:
SCM_MemTest_Z80_code8000.hex
SCM_MemTest_Z180_code8000.hex

Filename format: 
"SCM_MemTest"_<processor(s)>_<code-start-address>

The filename indicates the hardware it is designed for:
The processor or system is either Z80, Z180
The code loads and runs from the indicates code address
