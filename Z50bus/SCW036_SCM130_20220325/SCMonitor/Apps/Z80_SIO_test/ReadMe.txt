Z80 SIO module test program for use with SCMonitor (SCM).

This App tests a Z80 SIO that has a loop-back connections, ie:
   SIO module's RTS linked to CTS
   SIO module's TxD linked to RxD

The SIO is assumed to have the register order matching the official
RC2014 SIO module: Control A, Data A, Control B, Data B

Load the program into the target system by sending the hex file from a terminal program.

The code starts at $8000, so is started with the Monitor command "G 8000".

Warning: SCM will not identify the SIO at startup if the loop-back connections are
made. Therefore, it is necessary to start SCM before connecting the loop-back wires.
