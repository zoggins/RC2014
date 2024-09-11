; z80dasm 1.1.6
; command line: z80dasm --labels --origin=0x0100 --address DOODLE.COM

	org	00100h

	jp l0181h		;0100
l0103h:
	ld a,084h		;0103
	out (00eh),a		;0105
	ld a,030h		;0107
	out (00fh),a		;0109
	in a,(018h)		;010b
	cpl			;010d
	or 010h		;010e
	rra			;0110
	ld b,a			;0111
	jp c,00266h		;0112
	in a,(019h)		;0115
	add a,040h		;0117
	jp p,0021bh		;0119
	ld b,000h		;011c
	rra			;011e
	ld e,a			;011f
	in a,(01ah)		;0120
	add a,040h		;0122
	jp p,00226h		;0124
	ld b,000h		;0127
	rra			;0129
	cpl			;012a
	ld d,a			;012b
	nop			;012c
	nop			;012d
	nop			;012e
	and 03fh		;012f
	ld h,a			;0131
	and 020h		;0132
	add a,h			;0134
	ld h,a			;0135
	ld a,e			;0136
	and 020h		;0137
	or h			;0139
	rrca			;013a
	rrca			;013b
	rrca			;013c
	rrca			;013d
	ld h,a			;013e
	ld a,e			;013f
	rrca			;0140
	and 00fh		;0141
	ld l,a			;0143
	ld a,h			;0144
	and 0f0h		;0145
	or l			;0147
	ld l,a			;0148
	ld a,h			;0149
	and 007h		;014a
	or 008h		;014c
	ld h,a			;014e
	ld c,(hl)			;014f
	ld a,e			;0150
	rrca			;0151
	jp c,0025ah		;0152
	ld a,00fh		;0155
	and b			;0157
	or c			;0158
	ld (hl),a			;0159
	jp 00204h		;015a
	ld a,00fh		;015d
	and b			;015f
	rlca			;0160
	rlca			;0161
	rlca			;0162
	rlca			;0163
	or c			;0164
	ld (hl),a			;0165
	jp 00204h		;0166
	ld hl,00800h		;0169
	ld a,00fh		;016c
	and b			;016e
	ld c,a			;016f
	rlca			;0170
	rlca			;0171
	rlca			;0172
	rlca			;0173
	or c			;0174
	ld c,a			;0175
	ld (hl),c			;0176
	inc hl			;0177
	ld a,h			;0178
	cp 010h		;0179
	jp nc,00204h		;017b
	jp 00273h		;017e
l0181h:
	ld hl,l0103h		;0181
	ld de,00200h		;0184
	ld bc,0007eh		;0187
	ldir		;018a
	ld a,000h		
	out (018h),a
	jp 00200h		;018c
