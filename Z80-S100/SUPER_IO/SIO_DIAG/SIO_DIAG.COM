1�!������x������%��
�e� �\\\a\��\\�
\\\�	5�	�}
\R\\\���eF������%ͽ�A�\�[�\O���
�@!(��o~#fo�:����ʠ����e�O�à����4��
��������4�e������4�eO���������(���y��)��(���(���)�����O��e�y͋O������J��
�X���X��J�e͋��i��J�eO��y͆�p�Aۈ��yy�Ӊ�ۈ��ۈ�ʋۉ��> �.>��.�/�®���e��ʥ�6ʵ�;O��
µ���>����e�0��1�#�2�_�3���4��5�B�6�_�7�|�8ʙ3���> �.�P> �.�P��1���
��
L�E�E
�E!  "�*�+"�}����6�C�;O��=2���
��
K���2���
#�E:���0O�E:���0O�E�E
�E! �"�*�+"�}����6ʨ�;O�â3�t���
+�E�E
�E! �"�*�+"�}����6���;O���4�����
-�E�E
�E! �"�*�+"�}����6�&�;O�� 5���=�E�E
�E��6���>�E�E
�E��7���q�E�E
�E��8���
��
��������P�E!��PN#�E��E
�E!  "�*�+"�}����6���;O���!�> w#�!�	�ͽO�.��w#��!��ͽO�w#�>$w��.���.��;�/��.��Ey�/���>( �V=�T����*��m{����g�>����eO��0ʿ�1���2��3�)�4�H�5�g�6ʇ�7���8ʦ3��rK���2�2���!�����
��
�r7���2���!�����
��
�rl��2���:�2�!�����
��
�r���2���!�����
��
�r���2���!�����
��
�r��>2���!�����
��
�r��2���!�����
��
�r"�>�2�>�2���!��1��
͊�x���
��
�r����*��
��
�rN͔�x#N͔�x#N͔�x#N͔�x#N͔�x#N͔�x:�O͔�x�͔�x�N͔�x#N͔�x#N͔�x#N͔�x#N͔�x ͔�x ͔�x:�O͔�x:�O͔�x�͔�x��*���*�ʊ�+��*�y�+���>�ӏ����2�ӌ���2�Ӎ$���2�ӎ@�o�:�͖}�:�͖��:�͖��
��
�e��>�ӏی2�ۍ2�ێ2�@�o�:�͖}�:�͖��:�͖��
��
�e�?����e�0ʒ�1���2���3���4�	�5�	�6�7	3��X����
>���
ʵ���XO͌	à�}	ʠ͂	O�à���
���X��
O�!~�$�\	�P	#����
��!~�$�\	�P	#����
�!~�$�\	�P	#�	��
Y�!'~�$�\	�P	#�*	��
��!2~�$�\	�P	#�C	O͌	͂	O����
�r	�}	�\	͂	O��\	���\	�X�,���,�ʂ	�-��,�	y�-��!H�!H>��%~�%~�ʿ	O�#î	��
�e�
�
�
=����
��
!���	��
�e~�$��	O��
#��	�
�ۊ��
y�Ӌ���@�>��%��8�x�8�x/��8�x/��8�x��8�x:��8�x:��8�x��
�8���e���e#�>��%P����%f����%}����%�����%�����%�����%��
�8���e���e���
�������� ��>���� ��y���� ��������~�$�0O�#�"��������~�$�FO��#�8��������~�$�\O�y#�N����#~�x+~�x��x��H�������͉�͉����Ɛ'�@'O�����_�#>�O���������ͽ��O�����a��{�� ��0�
����ͽ���/��G���O�����G�ͽ�����/��G���O���������x������� ������� ��������8���

Super IO Board Test Program (V1.0) using CPM3 Console BIOS Routines
Note, SW1 bit 7 must be closed to work with this program.
$

Super IO Board Test Program (V1.0) using the Z80 Monitor for IO
Note, SW1 bit 7 must be closed to work with this program.
$
(D) DFP Sound Card Test    (F) FX Sound Card Test(R)
(G) Get 8255A Ports        (H) Set 8255A ports
(K) PS2 Keyboard Test      (L) Get Date & Time
(P) Printer Test           (Q) RS232 Loop Test
(R) RS232 Serial Port Test (S) Speech test 
(T) USB Port Test          (U) Set Date & Time 
(W) WiFi Card Test         (ESC) Quit
$
Sorry that was not a valid menu option!

$

Please enter command > $
Reading the Time & Date from the SUPER IO Board.$
Date = $  Time = $
Set the Time & Date on the SUPER IO Board.$
Enter Year (00-99) $
Enter Month (01-12) $
Enter Date (01-31) $
Enter Hours (00-23) $
Enter Minutes (00-59) $
Enter Seconds (00-59) $
Super IO Board not detected.$
An error was detected with the last SUPER_IO Board Command$
Test the PS2 Keyboard input. (P16, P24)
Please enter keyboard characters from the IBM-PC PS2 keyboard.
They should appear on your Console IO Port. Enter ESC to abort.

$
Test the USB Port. (P40)
Please enter keyboard chars FROM THE PC TERMINAL connected to the USB port.
They should echo back on the PC terminal (and S100 Console). 
Enter ESC to abort.

$
Test of the USB Port finished.
$
RS232 loop test. Enter ESC to abort.

$
Test the RS232 Port. (P17, J1)
Please enter keyboard characters from the S100 bus Console
They will be sent to the RS232 Port Rx pin. The loop around 
RS232 Port Tx pin will return the character and display it here.
Enter ESC to abort.

$
Test of the Serial Port finished.
$
Send the following test string to the Printer port:-
$
This is a test string being sent to the printer port on the Super IO Board
Second line, 0123456789,  ABCDEF,  abcdef
Third line,  terminating string 

AdaFruit FX Sound card Menu.

(0) Reset the FX Sound Card
(1) List All Files
(2) Play File #
(3) Increase Volume
(4) Decrease Volume
(5) Pause Playing
(6) Resume Playing
(7) Stop Playing
(8) Play Filename

Enter a menu option. ESC to abort to main Menu.

$
No AdaFruit FX card detected. (Or RST pin in low, try again).
$
Invalid menu option.$
Please enter the Track Number (XX+CR):$
Volume Increased$
Volume Decreased$
Pause Playback$
Resume Playback$
Stop Playback$
Enter File name (In XXXXXXXX.XXX Format):$
Will play the following file: $

DFP SD Card Sound Menu.
Read SD card on a PC to display the sound files present

(0) Play File #
(1) Set Sound Volume
(2) Continously play current track
(3) Pause Playing
(4) Play or Resume playing current track
(5) Continously play all tracks
(6) Stop Playing
(7) Send Byte to Port 8AH

Enter a menu option. ESC to abort to main Menu.

$
No DFP Sound Card detected
$
Please enter the File Number (XX+CR):$
Sending the following Command:- $
The DFP Player returned:- $
Please enter a value to send to port 8AH (XX+CR):$
Please enter the desired Volume Number (00-30+CR):$
Will continously play the current track.$
Will pause play of the current track.$
Will play of the current track.$
Will continously play all tracks.$
Will reset the DFP Player.$
Will query the DFP Player.$

WiFi ESP8266 Card Menu.

(0) Simple WiFi port Echo Test
(1) Initilize WiFi Card
(2) Send AT+CWMODE=? Command, (View Options Mode)
(3) Send AT+GMR Command, (Get Firmware Version)
(4) Send AT+CWMODE=1 Command, (Set Mode)
(5) Send AT+CWLAP Command, (Get Networks)
(6) Send AT+CIFSR Command, (Get IP Address)

Enter a menu option. ESC to abort to main Menu.

$
0.  Echo test of serial port on the WIFI card.
Please enter keyboard characters. (ESC to abort).$
1.  Will initilize ESP8266 WiFi card by pulsing RST low.$2.  Will send AT+CWMODE=? Command (View Options). 
Enter ESC to return to WiFi Menu.

$3.  Will send AT+GMR Command (Get Firmware Version).  
Enter ESC to return to WiFi Menu

$4.  Will send AT+CWMODE=1 Command (Set Mode).  
Enter ESC to return to WiFi Menu

$5.  Will send AT+CWLAP Command (Get Networks). 
Enter ESC to return to WiFi Menu

$6.  Will send AT+CIFSR Command (Get IP Add.). 
Enter ESC to return to WiFi Menu

$AT+CWMODE=?
$AT+GMR
$AT+CWMODE=1
$AT+CWLAP
$AT+CIFSR
$
Sending the following string to the speaker V-STAMP module.
This is a test. 12345678
Enter CR to start test.$This is a test. 12345678$
Send data to 8255A ports A, B & C.$
Enter 8255A Port A (XXH):$
Enter 8255A Port B (XXH):$
Enter 8255A Port C (XXH):$

8255A Ports    A           B              C$
           $    $       $
Get data from 8255A ports A, B & C.$                     ~�  ~�  ~�  ~�  ~�  ~�  ~�  ~�B                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     <--End of SIO_DIAG Code                                                                                                                 