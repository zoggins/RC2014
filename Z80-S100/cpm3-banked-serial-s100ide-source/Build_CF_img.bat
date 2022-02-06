Rem *** Delete previous image ***

del cpm3-banked-serial.img



Rem *** Copy system files from build folder ***

copy cpm3-banked-serial\CPMLDR.COM CPMLDR.COM
copy cpm3-banked-serial\CPM3.SYS CPM3.SYS

Rem *** Copy PCGET and PCPUT from build folder ***
del S100-TOOLS\PCGET.COM
del S100-TOOLS\PCPUT.COM
del S100-TOOLS\MYIO.COM
copy serial-tools\PCPUT.COM S100-TOOLS\
copy serial-tools\PCGET.COM S100-TOOLS\
copy serial-tools\MYIO.COM S100-TOOLS\

Rem *** Make new file system image ***

mkfs.cpm -f s100ide -b LBA0.COM -b CPMLDR.COM -t cpm3-banked-serial.img



Rem *** Copy system files ***

cpmcp -f s100ide cpm3-banked-serial.img cpm3.sys 0:
cpmcp -f s100ide cpm3-banked-serial.img ccp.com 0:
cpmchattr -f s100ide cpm3-banked-serial.img s ccp.com 0:



Rem *** Copy user files ***

cpmcp -f s100ide cpm3-banked-serial.img ./CPM3-BASE/*.* 0:
cpmcp -f s100ide cpm3-banked-serial.img ./S100-TOOLS/*.* 1:
cpmcp -f s100ide cpm3-banked-serial.img ./WS4-FILES/*.* 2:
cpmcp -f s100ide cpm3-banked-serial.img ./BASIC-FILES/*.* 3:
cpmcp -f s100ide cpm3-banked-serial.img ./GAMES/*.* 4:

pause


Rem *** Clean up ***

del CPMLDR.COM
del CPM3.SYS
