Small Computer Workshop (SCWorkshop.exe) plus SCMonitor
=======================================================

This software is designed to aid development of 8-bit retro computers.

It provides an integrated development environment complete with editor,
assembler and simulator.

WARNING: This software is completely free. It comes with absolutely no
warranty. Currently this program is far from complete and polished. It
contains many bugs and quirks.

It has been released 'early' primarily to allow users to modify the 
Small Computer Monitor program, which was created with this system.

Sorry, I don't normally release software with so many issues and without 
documentation. The decision to release this program now is motivated
by user requests rather than being planned. That's my excuse anyway!

I have only run this program on Windows 10, but it should run on much 
older versions of Windows.

Documentation for the Small Computer Monitor can be found at:
www.scc.me.uk

Bugs
====

The most annoying bugs relate to the text editor, which does quite a
few odd things. But after a while you get used to it!

If you get Error 13 at start up it is probably due to your international 
settings having a decimal character other than a period (“.”). The work 
around is to change the Clock value in Definition.txt to an integer. 
There is a Definition.txt file for each ‘Computer’ type in the Resources 
folder.

Limitations
===========

The Z80 simulator is not complete. For example, it does not generate 
a parity flag. However, the commonly used features are supported. 
Some software will not run in the simulator because of this limitation.

Tips
====

The program does not need to be installed, just run SCWorkshop.exe.

Source files, which are part of the Small Computer Monitor, should be 
saved in the SCMonitor folder. Source files for other projects should
not be saved there as trying to assemble any file in this folder 
results in assembly of the Monitor program.

The output of the assembler is stored in the folder "Output". Files 
from the previous assembly will be overwritten.

Some of the simulation views only update if there is time. A well
specified computer should manage rapid updates when in "Jog" mode.
In "Run" mode there is no attempt to update most views, regardless
of the computer's performance.

Files and Folders
=================

Folder: Output
The assembler output files are written here.

Folder: SCMonitor
Small Computer Monitor source, object files, documentation, examples 
and other support files.

Folder: SCWorkshopProjects
Sample projects for use with SCWorkshop.

Folder: SCWorkshopResources
Support files for the Small Computer Workshop software.

Folder: Third-party-contributions
Various contributions for the retro computer community.

File: msvbvm60.dll
Support file for the Small Computer Workshop software.

File: SCWorkshop.exe
Main executable for the Small Computer Workshop software.




