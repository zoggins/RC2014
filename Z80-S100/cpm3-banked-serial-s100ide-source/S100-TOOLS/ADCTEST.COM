>��>0�> �1����	͝��@ ���@(� �  !����!���������y�r!����!���������y�r!����!���������y�r!����!���������yz�W�_!���!��������y͎�! > w#|�8��{�_����~���������������# ��������x��
������G�0~���� � � � ��w�����{�?_��/o{� ����gz��'�'�'�'�oz������gz� �����g{���z�W�_��!�چ!����{���	�  ���  ���	� ���
Cromemco Dazzler ADC and switch test program. 
Exit by pushing switches 1 & 4 on either joystick

To set ADC zero on TV Dazzler, short P11 pins 7 and 8,CR,LFusing a jumper plug and adjust RV1 so the top row 1X is all zeros
Ignore the other three rows because the inputs are floating.
Then plug in the joysticks with power off and adjust the X zero
and Y zero in the joystick box for all zeros on the associated readout line.
The bottom row bits should become zeros each time
the associated push button is pressed
All displayed data bytes have the MSB at the left

$|���|  B�  F���b �((� �00� ����` ����l                                                                                                                