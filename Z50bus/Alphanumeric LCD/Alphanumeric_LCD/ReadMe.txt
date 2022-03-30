This program is for the LiNC80 SBC1, RC2014 and Z280RC.

It is an example of how to connect an alphanumeric LCD module to:
* LiNC80 SBC1 using its on-board Z80 PIO
* RC2014 with Z80 PIO module SC104
* Z280RC with Z80 PIO module SC104
* SC129 digital I/O for RC2014 and compatibles

The source code has a constant definition to select the target system.

In this example the display is connected to either a simple digital output
port (such as SC129) or to a Z80 PIO (Parallel I/O interface). 

This interfacing method uses 4-bit data mode and uses time delays rather 
than polling the display's ready status. As a result the interface only 
requires 6 simple output lines:

See source code for connection details.

Send the hex file to the target system using a terminal program.

Start the program with the SCMonitor command "G 8000"
