20 REM == poke at 0xF800 ==
30 let mb=&HF800
100 print "Poking in the program...";
110 read op
120 if op = 999 then goto 160
130 poke mb, op
140 let mb = mb + 1
150 goto 110
160 print "...Done!"
200 REM == JP start address (c3 00 f8) jp f800 ==
210 mb = &H2293
220 poke mb, &HC3
230 poke mb+1, &H00
240 poke mb+2, &HF8
250 print "Calling usr()..."
251 LET R = 3   : REM SID Register 0x03
252 LET D = 234 : REM Hex 0xEA
253 LET I = 64  : REM 60Hz Interrupt 0x40
254 IF D > 127 THEN D = D - 256
260 print usr((D * 256) + R + I)
270 end

REM 8999 REM == This is Extract Data ==  
REM 9000 DATA 205, 241, 11
REM 9001 DATA 66
REM 9005 DATA 62, 0
REM 9006 DATA 195, 103, 19
REM 9007 DATA 999

8999 REM == This is Extract Register ==  
9000 REM == program ==
9001 DATA 205, 241, 11
9002 DATA 123
9003 DATA 230, 15
9004 DATA 71
9005 DATA 62, 0
9006 DATA 195, 103, 19
9007 DATA 999

REM 8999 REM == This is Extract Interrupt==  
REM 9000 REM == program ==
REM 9001 DATA 205, 241, 11
REM 9002 DATA 123
REM 9003 DATA 230, 96
REM 9004 DATA 71
REM 9005 DATA 62, 0
REM 9006 DATA 195, 103, 19
REM 9007 DATA 999

