; z80dasm 1.1.6
; command line: z80dasm --labels --origin=0x0100 --address LIFE.COM

	org	00100h

	jp l0398h		;0100
l0103h:
	jp 00003h		;0103
	ld sp,00800h		;0106
	call sub_016ah		;0109
	call 00192h		;010c
	call 00027h		;010f
	in a,(001h)		;0112
	and 07fh		;0114
	cp 046h		;0116
	jp z,0000fh		;0118
	call 0003ch		;011b
	in a,(001h)		;011e
	and 07fh		;0120
	cp 018h		;0122
	jp z,00009h		;0124
l0127h:
	jp 0000ch		;0127
	ld bc,00000h		;012a
	call 0007eh		;012d
	ld a,040h		;0130
	inc c			;0132
	cp c			;0133
	jp nz,0002ah		;0134
	ld c,000h		;0137
	inc b			;0139
	cp b			;013a
	jp nz,0002ah		;013b
	ret			;013e
l013fh:
	ld bc,00000h		;013f
	call 000e3h		;0142
	cp 009h		;0145
	jp nz,0004fh		;0147
	ld a,000h		;014a
	call 000f4h		;014c
	jp 00059h		;014f
	cp 00ah		;0152
	jp nz,00059h		;0154
	ld a,00ch		;0157
	call 000f4h		;0159
	ld a,040h		;015c
l015eh:
	inc c			;015e
	cp c			;015f
	jp nz,0003fh		;0160
	ld c,000h		;0163
	inc b			;0165
	cp b			;0166
	jp nz,0003fh		;0167
sub_016ah:
	ret			;016a
	ld hl,00800h		;016b
	ld de,0f800h		;016e
	ld b,000h		;0171
	ld a,000h		;0173
	cp d			;0175
	jp nz,00078h		;0176
	cp e			;0179
	ret z			;017a
	ld (hl),b			;017b
	inc de			;017c
	inc hl			;017d
	jp 00072h		;017e
	push bc			;0181
	ld a,000h		;0182
	cp c			;0184
	jp nz,00096h		;0185
	dec c			;0188
	call 000c6h		;0189
	ld (l0272h),a		;018c
	pop bc			;018f
	push bc			;0190
	call 000c6h		;0191
	ld (l0272h+1),a		;0194
	pop bc			;0197
	push bc			;0198
	inc c			;0199
	call 000c6h		;019a
	ld hl,l0272h+1		;019d
	ld b,(hl)			;01a0
	ld (hl),a			;01a1
	add a,b			;01a2
	dec hl			;01a3
	ld c,(hl)			;01a4
	ld (hl),b			;01a5
	add a,c			;01a6
	ld d,a			;01a7
	pop bc			;01a8
	ret z			;01a9
l01aah:
	push de			;01aa
	call 000e3h		;01ab
	pop de			;01ae
	cp 000h		;01af
	jp z,000bdh		;01b1
	ld a,d			;01b4
	cp 003h		;01b5
	ret z			;01b7
	cp 004h		;01b8
	ret z			;01ba
	ld a,009h		;01bb
	jp 000f4h		;01bd
	ld a,d			;01c0
	cp 003h		;01c1
l01c3h:
	ret nz			;01c3
	ld a,00ah		;01c4
	jp 000f4h		;01c6
	dec b			;01c9
	ld d,000h		;01ca
	call 000d6h		;01cc
l01cfh:
	inc b			;01cf
	call 000d6h		;01d0
	inc b			;01d3
	call 000d6h		;01d4
	ld a,d			;01d7
	ret			;01d8
	push de			;01d9
	call 000e3h		;01da
	pop de			;01dd
	cp 000h		;01de
	ret z			;01e0
	cp 00ah		;01e1
	ret z			;01e3
	inc d			;01e4
	ret			;01e5
	call 00110h		;01e6
	ld a,(hl)			;01e9
	jp c,000edh		;01ea
	and 00fh		;01ed
	ret			;01ef
	and 0f0h		;01f0
	rlca			;01f2
	rlca			;01f3
	rlca			;01f4
	rlca			;01f5
	ret			;01f6
	and 00fh		;01f7
	push af			;01f9
	call 00110h		;01fa
	pop de			;01fd
	jp c,l0103h+1		;01fe
	ld a,(hl)			;0201
	and 0f0h		;0202
	add a,d			;0204
	ld (hl),a			;0205
	ret			;0206
l0207h:
	ld a,d			;0207
	rlca			;0208
	rlca			;0209
	rlca			;020a
	rlca			;020b
	ld d,a			;020c
	ld a,(hl)			;020d
	and 00fh		;020e
	add a,d			;0210
	ld (hl),a			;0211
	ret			;0212
	ld hl,00800h		;0213
	ld a,b			;0216
	and 020h		;0217
sub_0219h:
	jp z,0011dh		;0219
	ld de,00200h		;021c
	add hl,de			;021f
	ld a,c			;0220
	and 020h		;0221
	jp z,l0127h		;0223
	ld de,00400h		;0226
	add hl,de			;0229
	ld a,c			;022a
	and 01fh		;022b
	rlca			;022d
	rlca			;022e
	rlca			;022f
	rla			;0230
l0231h:
	ld e,a			;0231
	ld a,000h		;0232
	rla			;0234
	ld d,a			;0235
	add hl,de			;0236
l0237h:
	ld a,b			;0237
	rra			;0238
	push af			;0239
	and 00fh		;023a
	ld e,a			;023c
	ld d,000h		;023d
l023fh:
	add hl,de			;023f
	pop af			;0240
sub_0241h:
	ret			;0241
	in a,(000h)		;0242
	and 040h		;0244
	nop			;0246
	nop			;0247
	nop			;0248
	nop			;0249
	nop			;024a
	nop			;024b
	ret nz			;024c
	inc c			;024d
	jp nz,l013fh		;024e
	inc b			;0251
	jp nz,l013fh		;0252
	ret			;0255
	in a,(000h)		;0256
	and 080h		;0258
	jp z,00153h		;025a
	ld a,b			;025d
	out (001h),a		;025e
	ret			;0260
	ld b,(hl)			;0261
	ld a,000h		;0262
	cp b			;0264
l0265h:
	ret z			;0265
	call 00153h		;0266
	inc hl			;0269
	jp l015eh		;026a
	call 00068h		;026d
	ld a,084h		;0270
l0272h:
	out (00eh),a		;0272
l0274h:
	ld a,0b0h		;0274
	out (00fh),a		;0276
	ld hl,l0274h		;0278
	call l015eh		;027b
	call l013fh		;027e
	ret			;0281
	nop			;0282
	nop			;0283
	in a,(001h)		;0284
	ld b,a			;0286
	call 00153h		;0287
	and 07fh		;028a
	cp 059h		;028c
	ret nz			;028e
	ld hl,00299h		;028f
	jp l015eh		;0292
l0295h:
	call 00068h		;0295
	ld hl,l0231h		;0298
	ld (l0295h),hl		;029b
	ld hl,l023fh		;029e
	ld (l0295h+2),hl		;02a1
	ld hl,00285h		;02a4
	call l015eh		;02a7
	ld bc,00000h		;02aa
	call sub_0241h		;02ad
	ld hl,l01cfh		;02b0
	and 07fh		;02b3
	ld d,a			;02b5
	sub a			;02b6
	cp (hl)			;02b7
	jp z,l01aah		;02b8
	ld a,d			;02bb
	cp (hl)			;02bc
	jp z,l01c3h		;02bd
	inc hl			;02c0
	inc hl			;02c1
	inc hl			;02c2
	jp 001b3h		;02c3
	inc hl			;02c6
	ld e,(hl)			;02c7
	inc hl			;02c8
	ld d,(hl)			;02c9
	ex de,hl			;02ca
	call 001ceh		;02cb
	jp l01aah		;02ce
	jp (hl)			;02d1
	ld b,h			;02d2
	dec b			;02d3
	ld (bc),a			;02d4
	ld b,l			;02d5
	inc d			;02d6
	ld (bc),a			;02d7
	ld b,e			;02d8
	ld a,(bc)			;02d9
	ld (bc),a			;02da
	ld b,a			;02db
	ei			;02dc
	ld bc,03741h		;02dd
	ld (bc),a			;02e0
	ld bc,l0237h		;02e1
	ld d,e			;02e4
	inc a			;02e5
	ld (bc),a			;02e6
	inc de			;02e7
	inc a			;02e8
	ld (bc),a			;02e9
	ld e,d			;02ea
	ld (01a02h),a		;02eb
	ld (05702h),a		;02ee
	dec l			;02f1
	ld (bc),a			;02f2
	rla			;02f3
	dec l			;02f4
	ld (bc),a			;02f5
	ld d,c			;02f6
	defb 0fdh,001h,00dh	;illegal sequence		;02f7
	ld bc,00002h		;02fa
	nop			;02fd
	pop bc			;02fe
	ret			;02ff
	ld bc,00000h		;0300
	ret			;0303
	ld b,000h		;0304
	inc c			;0306
	ret			;0307
	ld a,00fh		;0308
	call 000f4h		;030a
	ld hl,(l0295h)		;030d
	call 001ceh		;0310
	ld hl,(l0295h+2)		;0313
	jp (hl)			;0316
	ld a,000h		;0317
	jp l0207h		;0319
	ld hl,l0231h		;031c
	and 040h		;031f
	jp nz,00224h		;0321
	ld hl,(l0295h+2)		;0324
	ld (l0295h),hl		;0327
	pop hl			;032a
	ld (l0295h+2),hl		;032b
	ret z			;032e
	jp (hl)			;032f
	call sub_0219h		;0330
	dec c			;0333
	ret			;0334
	call sub_0219h		;0335
	inc c			;0338
	ret			;0339
	call sub_0219h		;033a
	dec b			;033d
	ret			;033e
	call sub_0219h		;033f
	inc b			;0342
	ret			;0343
	call 000e3h		;0344
	push af			;0347
	push bc			;0348
	ld a,00ch		;0349
	call 000f4h		;034b
	ld bc,00000h		;034e
	call l013fh		;0351
	jp nz,0026eh		;0354
	pop bc			;0357
	push bc			;0358
	ld a,000h		;0359
	call 000f4h		;035b
	ld bc,00000h		;035e
	call l013fh		;0361
	pop bc			;0364
	jp z,00245h		;0365
	pop af			;0368
	call 000f4h		;0369
	in a,(001h)		;036c
	out (001h),a		;036e
	ret			;0370
	pop bc			;0371
	jp l0265h		;0372
	nop			;0375
	nop			;0376
	dec c			;0377
	ld a,(bc)			;0378
	ld a,(bc)			;0379
	ld c,h			;037a
	ld c,c			;037b
	ld b,(hl)			;037c
	ld b,l			;037d
	jr nz,$+34		;037e
	jr nz,$+88		;0380
	ld l,020h		;0382
	ld (0312eh),a		;0384
	nop			;0387
	dec c			;0388
	ld a,(bc)			;0389
	ld a,(bc)			;038a
	ld b,l			;038b
	ld c,(hl)			;038c
	ld d,h			;038d
	ld b,l			;038e
	ld d,d			;038f
	jr nz,$+70		;0390
	ld b,c			;0392
	ld d,h			;0393
	ld b,c			;0394
	dec c			;0395
	ld a,(bc)			;0396
	nop			;0397
l0398h:
	ld hl,l0103h		;0398
	ld de,00000h		;039b
	ld bc,l0295h		;039e
	ldir		;03a1
	ld a,000h		
	out (018h),a
	
	ld a,004h		
	out (00eh),a
	ld hl,800h
    ld e,l
	ld d,h
	inc	de
	ld (hl),000h
	ld bc,800h
	ldir
	
	jp 00000h		;03a3
