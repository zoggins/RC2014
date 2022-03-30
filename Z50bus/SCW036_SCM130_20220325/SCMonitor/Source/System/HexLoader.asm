; **********************************************************************
; **  Hex file loader                           by Stephen C Cousins  **
; **********************************************************************

; This module loads an Intel Hex file from the current input device.
;
; An Intel Hex file is a text file where each line is a record.
;
; A record starts with a colon (':') and ends with CR and/or LF.
;
; The next two characters form a hex byte which is the number of data
; bytes in the record.
;
; The next four characters form a hex word which is the start address 
; for the record's data bytes. High byte first.
;
; The next two characters form a hex byte which describes the type of
; record. 0x00 is a normal data record. 0x01 is an end of file marker.
;
; Then follows the specified number of data bytes, each written as two 
; character hex number.
;
; Finally there is a checksum byte in the form of a two character hex
; number. 
;
; To test the checksum simply add up all bytes in the record, including
; the checksum (but not the colon), and test to see if it is zero.
;
; The checksum is calculated by adding together all bytes in the record
; except the checksum byte and the colon character, ANDing with 0xFF 
; and then subtracting from 0x100. 
;
; Example record:
;   :0300300002337A1E 
; Record Length: 03 (3 bytes of data)
; Address: 0030 (the 3 bytes will be stored at 0030, 0031, and 0032)
; Record Type: 00 (normal data)
; Data: 02, 33, 7A
; Checksum: 1E (03 + 00 + 30 + 00 + 02 + 33 + 7A = E2, 100 - E2 = 1E)
;
; The last line of the file is an end marker with 00 data bytes and 
; record type 01, and so is:
;   :00000001FF
;
; Test file: (loads data 0x03 0x02 0x01 to address 0x4000)
;   :03400000030201B7
;   :00000001FF
;
; Public functions provided
;   HexLoad               Load hex file from the current console input


; **********************************************************************
; **  Public functions                                                **
; **********************************************************************

            .CODE

; HexLoader: Load an intel hex file from the current console input
;   On entry: No parameters required
;   On exit:  IX IY I AF' BC' DE' HL' preserved
HexLoad:    LD   C,0            ;Clear checksum of this whole file
@Line:      CALL InputChar      ;Get first character in record/line
            CP   kSpace         ;Control character?
            JR   C,@Line        ;Yes, so discard it
            CP   kColon         ;Colon?
            RET  NZ             ;No, so return with this character
;           LD   C,0            ;Clear checksum for this line only
; Get number of data bytes in this record
            CALL HexGetByte     ;Get number of data bytes
            LD   B,A            ;Store number of data bytes in record
            ADD  A,C            ;Add to checksum
            LD   C,A
; Get start address for this record
            CALL HexGetByte     ;Get address hi byte
            LD   D,A            ;Store address hi byte
            ADD  A,C            ;Add to checksum
            LD   C,A
            CALL HexGetByte     ;Get address lo byte
            LD   E,A            ;Store address lo byte
            ADD  A,C            ;Add to checksum
            LD   C,A
; Get record type
            CALL HexGetByte     ;Get record type
            LD   H,A            ;Store record type
            ADD  A,C            ;Add to checksum
            LD   C,A
; Input any data bytes in this record
            LD   A,B            ;Get number of bytes in record
            OR   A              ;Zero?
            JR   Z,@Check       ;Yes, so skip..
@Data:      CALL HexGetByte     ;Get data byte
            LD   (DE),A         ;Store data byte in memory
            INC  DE             ;Point to next memory location
            ADD  A,C            ;Add to checksum
            LD   C,A
            DJNZ @Data
; Get checksum byte for this record
@Check:     CALL HexGetByte     ;Get checksum byte
            ADD  A,C            ;Add to checksum
            LD   C,A
; Should now test checksum for this line, but instead keep a checksum 
; for the whole file and test only at the end. This avoids having to 
; store a failure flag (no registers left) whilst still allowing this
; function to flush all lines of the file.
;Test for end of file
            LD   A,H            ;Get record type
            CP   1              ;End of file?
            JR   NZ,@Line       ;No, so repeat for next record
; End of file so test checksum
#IFDEF      IncludeMonitor
            LD   A,C            ;Get checksum
            OR   A              ;It should be zero?
            LD   A,kMsgReady    ;Prepare for checksum ok message
            JR   Z,@Result      ;Skip if checksum ok
            LD   A,kMsgFileEr   ;File error message number
@Result:    CALL OutputMessage  ;Output message #A
            XOR  A              ;Return null character
            LD   A,kNewLine
            LD   A,kReturn
#ENDIF
            RET


; **********************************************************************
; **  Private functions                                               **
; **********************************************************************

; HexLoader: Get byte from two hex characters from current console input
;   On entry: No parameters required
;   On exit:  A = Bytes received
;             BC DE H IX IY I AF' BC' DE' HL' preserved
HexGetByte: CALL InputChar      ;Get character from input device
            CALL ConvertCharToNumber
            RLCA
            RLCA
            RLCA
            RLCA
            LD   L,A            ;Store result hi nibble
            CALL InputChar      ;Get character from input device
            CALL ConvertCharToNumber
            OR   A,L            ;Get result byte
            RET





