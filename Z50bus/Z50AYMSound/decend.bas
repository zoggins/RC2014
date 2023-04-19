1 REM Output decending tones on channel A
REM ports 0x32 & 0x33 are used by the Z80 Memory Card
REM 10 R=51 : REM &h33
REM 20 D=50 : REM &h32
10 R=67 : REM &h43
20 D=66 : REM &h42
30 OUT R,7   : REM select the mixer register
40 OUT D,254 : REM enable channel A only
41 OUT R,8   : REM channel A volume
42 OUT D,15  : REM set it to maximum Fixed
50 OUT R,0   : REM select channel A pitch
60 FOR N=1 TO 255
70 OUT D,N :  REM set it
80 GOSUB 200
90 NEXT
100 GOTO 50
200 FOR X=1 TO 64
210 NEXT
220 RETURN