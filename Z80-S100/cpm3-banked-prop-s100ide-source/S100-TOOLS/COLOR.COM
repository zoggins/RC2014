>��>0�> �1���	��  ���� ��0��@��P��`��p����� ��� ��(> �G��(>�G��(x� �� >�G��  >�Gx�/>@�G��(>�G�� (>�G��@(>�G��(>�Gx����H> ��  !�(��{�_!xƀG�(��z�W�_�!���(!���(!���(!��(!
�(!��(�! > w#|�8�����~�O�O�O�O�O�O�O�O�# ��������x�\�
������G̈́~�s��� � � � ��w�����{�?_��/o{� ����gz��'�'�'�'�oz������gz�`�����g{���x�!���!��(�����	� ���
Walker Systems TV Dazzler II color display test program.
Four bit binary code for each color is displayed to right of color example.
Program runs once to write display and loops with pattern left in SRAM.

All displayed data nibbles have the MSB at the left.

Press joystick 1 button 4 or connect P11 pin 4 to pin 6 to exit
Program exit for CPM can also use cntrl-C on keyboard

joystick button usage:
JS1 SW1: press for bit map display
JS1 SW2: press for 32x32 display
JS1 SW3: press for gray scale display
JS1 SW4: press to exit program
Following apply if JS1 SW1 is pressed:
JS2 SW1: press for bit map color low intensity
JS2 SW2: press for bit map color blue disable
JS2 SW3: press for bit map color green disable
JS2 SW4: press for bit map color red disable
Following apply if JS1 SW1 is not pressed:
P18 jumpers 3-4 and 31-32 must be removed and U18 installed.
JS2 SW1: press to display using alternate color map
JS2 SW2: press to display second page
JS2 SW3 and SW4 are not used in color mode
$<BBB<  "~  ����` >H�H> |���\ ����� ����� "FJR"  ~~~~                                                                                                     