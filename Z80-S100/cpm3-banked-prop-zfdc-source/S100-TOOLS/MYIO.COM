1 �	� >�ӫ� �i	� ��0ʞ�1�?�2���3�"�4�U�����	� � �i	� ��0�c��þ�1�pþ�2�}@Hþ�3}þ�4�þ�5¤�þ�6±þ�7�� Sþ>ӡxӡ>ӠxӠ2!	� � �	� �  � �	� � ۡ���ۣ�� ������� Oۡ��>.��yӣ��۪��0۬��"� ��"���� O۪�@�O>.��AyӬ�":!��h�	� � � ��h���� O۠�>.��yyӢ���h� �(�>
��h>�O!���>�O!���m	� >2!� D��V  

MYIO A program to configure the S-100 I/O board (V1.2  04/24/2011).
MAIN MENU
0 = Initilize the Zilog 8530 SCC chip(Ports = A0H-A3H)
1 = Set SCC Baud Rate
2 = SCC Loop test.  SCC chip(Ports = A1H & A3H)
3 = DLP-USB Controller/Port Loop test (Data Port = ACH, 8255 Status = AAH))
4 = Send test speech string to V_Stamp chip via SCC chip (Ports = A0H & A2H)
ESC = Return to CP/M

Menu choice ---->$

$The SCC is now initilized to 8 Bits, 1 Stop bit, NP, RTS on, 19200 Baud.

$The SCC must first be initilized to 8 Bits, 1 Stop bit, NP, RTS on, 19200 Baud.

$Select a Baud rate for this SCC (Both A & B Channels)
0 = 600 baud
1 = 1200 baud
2 = 2400 baud
3 = 4800 baud
4 = 9600 baud
5 = 19200 baud

6 = 38400 baud

7 = 76800 baud

Baud Rate number selected --->$Baud rate RESET to 600 baud (Both A & B Channels)
$Baud rate RESET to 1200 baud (Both A & B Channels)
$Baud rate RESET to 2400 baud (Both A & B Channels)
$Baud rate RESET to 4800 baud (Both A & B Channels)
$Baud rate RESET to 9600 baud (Both A & B Channels)
$Baud rate RESET to 19200 baud (Both A & B Channels)
$Baud rate RESET to 38400 baud (Both A & B Channels)
$Baud rate RESET to 76800 baud (Both A & B Channels)
$
Skipped selecting a new BAUD rate for the board current SCC.
$
Invalid menu item
$                                                                 �                                                                                              