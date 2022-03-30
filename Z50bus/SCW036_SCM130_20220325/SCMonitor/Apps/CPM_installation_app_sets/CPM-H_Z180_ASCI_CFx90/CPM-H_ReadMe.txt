CPM-H Installation

CPM-H is for a CP/M system formed from:
* Z180 processor with 64k+ RAM
* CompactFlash card at address 0x90 (128MB+)
* Z180 ASCI serial port at 0xC9 (115200 baud)
* USB to serial adapter / cable
eg. SC503+SC504


HOW TO PREPARE A COMPACT FLASH CARD FOR CP/M 2.2

To prepare a CompactFlash card for use by CP/M 2.2:
1/ Format the CF card
2/ Write CP/M to the CF card using PutSysPlus
3/ Install DOWNLOAD.COM
4/ Transfer programs that have been packaged to use DOWNLOAD.COM
   For example: pkgMBASIC.TXT

This is achieved with the Small Computer Monitor (SCM) and using the 
SCM Apps includes with this file.

The CompactFlash Format App works on Z80 and Z180 systems, with CF card
at 0x10 or 0x90, and detects card sizes of 16MB and above. CP/M can
only make use of the first 128MB of larger cards.

The Install DOWNLOAD.COM App works on Z80 and Z180 systems, and is not
dependent on the CF card address or CF card size. It runs once CP/M is
installed and relies on CP/M to handle the file saving.

The PutSysPlus App is specific to this specification of system and to
the indicated CF card size. Actually, it is not critical that the card
size is correct as the CP/M system will still work. However, CP/M will
not know how many drive letters are available and may report errors if
invalid drive letters are accessed.

More details can be found at www.scc.me.uk (Small Computer Central)
