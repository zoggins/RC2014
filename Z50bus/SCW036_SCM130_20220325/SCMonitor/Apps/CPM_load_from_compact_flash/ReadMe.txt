CP/M loader 

This app loads CP/M from a compact flash card.

It runs from SCMonitor, but once loaded uses all its own hardware drivers.

Hardware must provide paging out of ROM so RAM is available at the bottom of memory.

Based on code by Grant Searle's.


Files:


SCMon_CPM_loader_Z80.asm
Source code for Z80 CP/M loader app, with code starting at $8000.

SCMon_CPM_loader_Z80_0x10_code8000.hex
Assembled code for Z80 CP/M loader with CF card base address 0x10.

SCMon_CPM_loader_Z80_0x90_code8000.hex
Assembled code for Z80 CP/M loader with CF card base address 0x90.


SCMon_CPM_loader_Z180.asm
Source code for Z180 CP/M loader app, with code starting at $8000.

SCMon_CPM_loader_Z180x00_0x10_code8000.hex
Assembled code for Z180 CP/M loader with Z180 registers at 0x00 and CF card base address 0x10.

SCMon_CPM_loader_Z180x40_0x10_code8000.hex
Assembled code for Z180 CP/M loader with Z180 registers at 0x40 and CF card base address 0x10.

SCMon_CPM_loader_Z180xC0_0x10_code8000.hex
Assembled code for Z180 CP/M loader with Z180 registers at 0xC0 and CF card base address 0x10.
This version is for SC111 Z180 CPU module or compatible, and SC126 or compatible

SCMon_CPM_loader_Z180xC0_0x90_code8000.hex
Assembled code for Z180 CP/M loader with Z180 registers at 0xC0 and CF card base address 0x90.
This version is for SC500 series or compatible


Origins:

Grant's original - monitor.asm
Grant Searle's boot monitor source code.

Grant's original - MONITOR.HEX
Grant Searles boot monitor, assembled.

