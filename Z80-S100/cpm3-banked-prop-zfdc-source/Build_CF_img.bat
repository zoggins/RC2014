Rem *** Delete previous image ***

del cpm3-banked-prop-zdfc.img

Rem *** Copy system files from build folder ***

copy ZSYSGEN\CPMLDR.COM CPMLDR.COM
copy "ABCD Floppys Banked CPM3"\CPM3.SYS CPM3.SYS

Rem *** Make new file system image ***

mkfs.cpm -f ibm-3740 -b CPMLDR.COM -t cpm3-banked-prop-zdfc.img



Rem *** Copy system files ***

cpmcp -f ibm-3740 cpm3-banked-prop-zdfc.img cpm3.sys 0:
cpmcp -f ibm-3740 cpm3-banked-prop-zdfc.img ccp.com 0:
cpmchattr -f ibm-3740 cpm3-banked-prop-zdfc.img s ccp.com 0:



Rem *** Copy user files ***

REM cpmcp -f s100ide cpm3-banked-prop.img ./CPM3-BASE/*.* 0:
REM cpmcp -f s100ide cpm3-banked-prop.img ./S100-TOOLS/*.* 1:
REM cpmcp -f s100ide cpm3-banked-prop.img ./WS4-FILES/*.* 2:
REM cpmcp -f s100ide cpm3-banked-prop.img ./BASIC-FILES/*.* 3:
REM cpmcp -f s100ide cpm3-banked-prop.img ./GAMES/*.* 4:

pause


Rem *** Clean up ***

del CPMLDR.COM
del CPM3.SYS
