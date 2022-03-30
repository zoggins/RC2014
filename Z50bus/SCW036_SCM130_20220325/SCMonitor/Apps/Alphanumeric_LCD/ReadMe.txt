This program is for the LiNC80 SBC1, RC2014, Z280RC, and Z50Bus.

It is an example of how to connect an alphanumeric LCD module to a
variety of Z80 based retro hardware:
* LiNC80 SBC1 using its on-board Z80 PIO or external I/O port (eg. SC506)
* RC2014 with Z80 PIO module (eg. SC104) or digital I/O port (eg. SC129)
* Z280RC with Z80 PIO module (eg. SC104) or digital I/O port (eg. SC129)
* Z50BUS with Z80 PIO module (eg. SC509) or digital I/O port (eg. SC506)

In this example the display is connected to either:
* a simple digital output "port" such as SC129 or SC506, or
* a Z80 "PIO" (Parallel I/O interface such as SC104 or SC509 

The source code has a constants definition to select the target system
and interface type.

This interfacing method uses 4-bit data mode and uses time delays rather 
than polling the display's ready status. As a result the interface only 
requires 6 simple output lines:

See source code for connection details.

Send the hex file to the target system using a terminal program.

Start the program with the SCMonitor command "G 8000"


Version 0.1 to 0.4 use the "_CodeLibrary" provided with the SCM source code.
Version 0.6 is a standalone program.
Both versions are written to run from SCMonitor.

Hex files are named as follows:
"SCM_" <system name> <connection type> "Alphanumeric_LCD_" "code" <hex code address>
eg. 
SCM_RC2014_PIO_Alphanumeric_LCD_code8000.hex
SCM_RC2014_Port_Alphanumeric_LCD_code8000.hex
