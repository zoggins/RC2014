1�	� >�ӫ� ��	� ��0���1�D�2���3�'�4�W�5ʊ�����r	� � ��	� ��0�h�E���1�uy���2@����3����4���5©M���6¶����7�� ���>ӡxӡ>ӠxӠ2�	� � �	� �  � 0	� � ۡ��ۣ�� ������� Oۡ��!>.��yӣ��۠��2ۢ�� ��'���� O۠��Q>.��CyӢ�'۪��e۬��W� ��W���� O۪�@ʄ>.��vyӬ�W:��ʝ	� � � �ʝ���� O۠�¼>.�îyӢ��� �(�>
�Ý>�O!���>�O!����	� >2�� D��V  

MYIO A program to configure the S-100 I/O board (V1.2  04/24/2011).
MAIN MENU
0 = Initilize the Zilog 8530 SCC chip(Ports = A0H-A3H)
1 = Set SCC Baud Rate
2 = SCC Loop test.  SCC chip(Ports = A1H & A3H)
3 = SCC Loop test.  SCC chip(Ports = A0H & A2H)
4 = DLP-USB Controller/Port Loop test (Data Port = ACH, 8255 Status = AAH))
5 = Send test speech string to V_Stamp chip via SCC chip (Ports = A0H & A2H)
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
$                                                                 �                                                                                                                        