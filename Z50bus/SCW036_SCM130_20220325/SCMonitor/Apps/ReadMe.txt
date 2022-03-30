Small Computer Monitor Apps
===========================

This folder contains source and hex files for SCMonitor Apps.

SCMonitor Apps are programs that are written to work with SCMonitor.

These programs can be downloaded into memory and executed, or can be included in a 
ROM using SCMonitor's ROM filing system.


To download a program to SCMonitor
==================================

It is assumed the program's code (HEX file) is 'sent' from a terminal program to
the target system running the Small Computer Monitor.

The exact method to do this depends on the terminal program used.

When using TeraTerm: 

Select File menu, Send file

Select the hex file you want to send to the Monitor. eg. "SCMon_MemTest_code8000.hex"

A small program will download to the Monitor in a fraction of a second and the 
Monitor should print "Ready". A larger program may take 2 seconds. It could be 
longer if the terminal has been set to add delays between each character or line.

Then type "G 8000" to start the program you have downloaded. The require start 
address will usually be indicated in the file name.

The terminal session should look something like this:

Small Computer Monitor
*Ready

*
*g8000
<output of program will appear here>


The file send dialog does not show on the terminal session above, but happened 
between "Small Computer Monitor" and "Ready" in this example.
