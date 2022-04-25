1 REM Output ascending and descending "siren" using all three channels
2 REM Addresses 0x32 (data) and 0x33 (register) = 50, 51 decimal:
3 REM Mixer value for A+B+C Tone, no Noise, IO as OUT = 248 decimal/0xFE hex
REM ports 0x32 & 0x33 are used by the Z80 Memory Card
REM 10 R=51 : REM &h33
REM 20 D=50 : REM &h32
10 R=67 : REM &h43
20 D=66 : REM &h42
30 OUT R,  7
40 OUT D,248
41 OUT R,  8
42 OUT D, 15
43 OUT R,  9
44 OUT D, 15
45 OUT R, 10
46 OUT D, 15
50 FOR N = 32 TO 250
55 M = 251 - N
56 O = ABS(M-N)
60 OUT R,  0
61 OUT D,  N
62 OUT R,  2
63 OUT D,  M
64 OUT R,  4
65 OUT D,  O
70 GOSUB 200
80 NEXT
90 GOTO 50
200 FOR X=1 TO 64
210 NEXT
220 RETURN