Memory fill program for use with SCMonitor.

This programs fills the full 64K of RAM with a specified byte, except for the few
bytes taken up by this code. The ROM is paged out so that lower RAM can be written to.

Load the program into the target system by sending the hex file from a terminal program.

The code starts at $8000, so is started with the Monitor command "G 8000".

