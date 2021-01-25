; Hello World for RomWBW

		ORG			0x0200

SERDEV  EQU     0x80            ; SERIAL DEVICE ADDRESS

        LD      IX, STRING
LOOP    LD      A, (IX+0)
        CP      0x00
        JP      Z, EXIT
        LD      E, A           
        LD      B, 0x01
        LD      C, SERDEV
        RST     0x08
        INC     IX
        JP     LOOP     
EXIT    RST     0x0

STRING:      DB 10, 13, 'H', 'e', 'l', 'l', 'o', ' ', 'W', 'o', 'r', 'l', 'd', '!', 10, 13, 0

        END