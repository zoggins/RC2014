; z80dasm 1.1.6
; command line: z80dasm --labels --origin=0x0100 --address TRACK.COM

	org	00100h

l0100h:
	jp l0381h		;0100
l0103h:
	ld sp,00800h		;0103
	ld a,084h		;0106
	out (00eh),a		;0108
	ld a,030h		;010a
	out (00fh),a		;010c
	ld b,00ah		;010e
	jp l0266h		;0110
	nop			;0113
	ld b,007h		;0114
	ld de,00000h		;0116
	call sub_0229h		;0119
	inc e			;011c
	ld a,e			;011d
	cp 03fh		;011e
	jp nz,00016h		;0120
	call sub_0229h		;0123
	inc d			;0126
	ld a,d			;0127
	cp 03fh		;0128
	jp nz,00020h		;012a
	call sub_0229h		;012d
	dec e			;0130
	ld a,e			;0131
	cp 010h		;0132
	jp nz,0002ah		;0134
	call sub_0229h		;0137
	dec d			;013a
	ld a,d			;013b
	cp 010h		;013c
	jp nz,00034h		;013e
	call sub_0229h		;0141
	inc e			;0144
	ld a,e			;0145
	cp 026h		;0146
	jp nz,0003eh		;0148
	call sub_0229h		;014b
	inc d			;014e
	ld a,d			;014f
	cp 026h		;0150
	jp nz,00048h		;0152
	call sub_0229h		;0155
	dec e			;0158
	ld a,e			;0159
	cp 019h		;015a
	jp nz,00052h		;015c
	call sub_0229h		;015f
	dec d			;0162
	ld a,d			;0163
	cp 01ah		;0164
	jp nz,0005ch		;0166
	call sub_0229h		;0169
	inc e			;016c
	ld a,e			;016d
	cp 023h		;016e
	jp nz,00066h		;0170
	call sub_0229h		;0173
	inc d			;0176
	ld a,d			;0177
	cp 023h		;0178
	jp nz,00070h		;017a
	call sub_0229h		;017d
	dec e			;0180
	ld a,e			;0181
	cp 01bh		;0182
	jp nz,0007ah		;0184
	call sub_0229h		;0187
	dec d			;018a
	ld a,d			;018b
	cp 01ch		;018c
	jp nz,00084h		;018e
	jp l0200h		;0191
	dec b			;0194
	ld a,080h		;0195
	add a,e			;0197
	ld e,a			;0198
	ld a,000h		;0199
	adc a,d			;019b
	ld d,a			;019c
	ld a,b			;019d
	and 00fh		;019e
	jp nz,00073h		;01a0
	ld hl,00000h		;01a3
	add hl,sp			;01a6
	ld a,h			;01a7
	add a,020h		;01a8
	ld h,a			;01aa
	jp nc,000ach		;01ab
	inc hl			;01ae
	ld sp,hl			;01af
	ld a,l			;01b0
	cp 080h		;01b1
	jp c,00047h		;01b3
	jp 00038h		;01b6
	rrca			;01b9
	rrca			;01ba
	rrca			;01bb
	rrca			;01bc
	ld c,a			;01bd
	ld a,(de)			;01be
	inc c			;01bf
l01c0h:
	rrca			;01c0
	dec c			;01c1
	jp nz,0007dh		;01c2
	jp nc,00091h		;01c5
	ld a,b			;01c8
	and 010h		;01c9
	ld a,010h		;01cb
	jp nz,0008fh		;01cd
	ld a,001h		;01d0
	add a,(hl)			;01d2
	ld a,a			;01d3
	dec b			;01d4
	nop			;01d5
	ld sp,hl			;01d6
	nop			;01d7
	jp p,0fb00h		;01d8
	inc b			;01db
	rst 38h			;01dc
	nop			;01dd
	rst 38h			;01de
	nop			;01df
	rst 38h			;01e0
	nop			;01e1
l01e2h:
	rst 38h			;01e2
	jr nz,l01e2h		;01e3
	nop			;01e5
	ret p			;01e6
	nop			;01e7
	ret m			;01e8
	nop			;01e9
	ld sp,hl			;01ea
	inc h			;01eb
	rst 38h			;01ec
	nop			;01ed
	rst 38h			;01ee
	nop			;01ef
	rst 38h			;01f0
	nop			;01f1
	rst 38h			;01f2
	inc h			;01f3
	jp p,0e100h		;01f4
	nop			;01f7
	ld sp,hl			;01f8
	nop			;01f9
	di			;01fa
	inc h			;01fb
	rst 38h			;01fc
	ld (hl),e			;01fd
	rst 38h			;01fe
	nop			;01ff
l0200h:
	rst 38h			;0200
	nop			;0201
	cp 04fh		;0202
	ld a,b			;0204
	cp 000h		;0205
	jp z,l0200h		;0207
l020ah:
	ld a,e			;020a
	rrca			;020b
	jp c,00117h		;020c
	ld a,c			;020f
	and 00fh		;0210
	cp 00fh		;0212
	jp z,l01c0h		;0214
	jp l0200h		;0217
	ld a,c			;021a
	and 0f0h		;021b
	cp 0f0h		;021d
	jp z,l01c0h		;021f
	jp l0200h		;0222
	cp d			;0225
l0226h:
	jp c,00112h		;0226
sub_0229h:
	jp l0100h		;0229
	ei			;022c
	nop			;022d
	rst 38h			;022e
	nop			;022f
	defb 0fdh,000h,0ffh	;illegal sequence		;0230
	nop			;0233
	adc a,a			;0234
	nop			;0235
	ld l,a			;0236
	nop			;0237
	rst 38h			;0238
	nop			;0239
	sbc a,a			;023a
	nop			;023b
	cp 000h		;023c
	defb 0fdh,000h,0f7h	;illegal sequence		;023e
	nop			;0241
	rst 38h			;0242
	nop			;0243
	ld e,a			;0244
	nop			;0245
	rst 8			;0246
	nop			;0247
	rst 18h			;0248
	nop			;0249
	rst 18h			;024a
	nop			;024b
	rst 38h			;024c
	nop			;024d
	rst 30h			;024e
	nop			;024f
	rst 38h			;0250
	nop			;0251
	rst 38h			;0252
	nop			;0253
	xor a			;0254
	nop			;0255
	ld a,a			;0256
	nop			;0257
	xor a			;0258
	nop			;0259
l025ah:
	rst 8			;025a
l025bh:
	jr nz,l025bh		;025b
	nop			;025d
	rst 38h			;025e
	nop			;025f
	rst 38h			;0260
	nop			;0261
	jp m,06f00h		;0262
	nop			;0265
l0266h:
	rst 28h			;0266
	nop			;0267
	ld e,a			;0268
	nop			;0269
	cp a			;026a
	nop			;026b
	rst 38h			;026c
	nop			;026d
	defb 0fdh,000h,0ffh	;illegal sequence		;026e
	nop			;0271
	rst 38h			;0272
l0273h:
	nop			;0273
	rst 28h			;0274
	nop			;0275
	rra			;0276
	nop			;0277
	ld a,a			;0278
	nop			;0279
	rst 38h			;027a
	nop			;027b
	rst 38h			;027c
	nop			;027d
l027eh:
	rst 38h			;027e
	nop			;027f
	rst 38h			;0280
	nop			;0281
	rst 38h			;0282
	nop			;0283
	ld l,a			;0284
	nop			;0285
	cp a			;0286
	nop			;0287
	sbc a,a			;0288
	nop			;0289
	sbc a,a			;028a
	nop			;028b
	rst 38h			;028c
	nop			;028d
	rst 38h			;028e
	nop			;028f
	rst 38h			;0290
	nop			;0291
	rst 38h			;0292
	nop			;0293
	cp l			;0294
	inc b			;0295
	sbc a,a			;0296
	nop			;0297
	rrca			;0298
	nop			;0299
	rst 18h			;029a
	jr nz,$+1		;029b
	nop			;029d
	rst 38h			;029e
	nop			;029f
	rst 38h			;02a0
	nop			;02a1
	rst 38h			;02a2
	inc b			;02a3
	adc a,a			;02a4
	nop			;02a5
	ld e,a			;02a6
	nop			;02a7
	ld a,a			;02a8
	nop			;02a9
	rst 38h			;02aa
	jr nz,$+1		;02ab
	nop			;02ad
	rst 38h			;02ae
	nop			;02af
	rst 38h			;02b0
	nop			;02b1
	rst 38h			;02b2
	inc b			;02b3
	xor a			;02b4
	nop			;02b5
	adc a,l			;02b6
	nop			;02b7
	rst 38h			;02b8
	nop			;02b9
	rst 18h			;02ba
	nop			;02bb
	rst 38h			;02bc
	sbc a,a			;02bd
	rst 38h			;02be
	nop			;02bf
	rst 38h			;02c0
	nop			;02c1
	ld a,a			;02c2
	ld a,e			;02c3
	rrca			;02c4
	ld a,(hl)			;02c5
	jp c,001cch		;02c6
	sub 006h		;02c9
	ld (hl),a			;02cb
	jp 001cfh		;02cc
	sub 060h		;02cf
	ld (hl),a			;02d1
	ld a,c			;02d2
	add a,008h		;02d3
	out (019h),a		;02d5
	ld c,a			;02d7
	in a,(018h)		;02d8
	rrca			;02da
	jp c,001cfh		;02db
	jp 00000h		;02de
	nop			;02e1
	ld a,a			;02e2
	inc b			;02e3
	rst 38h			;02e4
	nop			;02e5
	rst 18h			;02e6
	nop			;02e7
	cpl			;02e8
	nop			;02e9
	ld e,a			;02ea
	nop			;02eb
	rst 38h			;02ec
	nop			;02ed
	rst 38h			;02ee
	nop			;02ef
	rst 38h			;02f0
	nop			;02f1
	rst 38h			;02f2
	inc b			;02f3
	cp a			;02f4
	nop			;02f5
	rst 18h			;02f6
	nop			;02f7
	rst 38h			;02f8
	nop			;02f9
	rst 18h			;02fa
	inc h			;02fb
	rst 38h			;02fc
	nop			;02fd
	rst 38h			;02fe
	nop			;02ff
	rst 38h			;0300
	nop			;0301
	rst 38h			;0302
	ld b,009h		;0303
	in a,(019h)		;0305
	add a,040h		;0307
	jp p,l020ah		;0309
	ld b,000h		;030c
	rra			;030e
	ld e,a			;030f
	in a,(01ah)		;0310
	add a,040h		;0312
	jp p,00215h		;0314
	ld b,000h		;0317
	rra			;0319
	cpl			;031a
	ld d,a			;031b
	call sub_0229h		;031c
	jp l0100h		;031f
	add a,040h		;0322
	jp p,l0226h		;0324
	ld b,000h		;0327
	rra			;0329
	cpl			;032a
	ld d,a			;032b
	ld a,d			;032c
	nop			;032d
	nop			;032e
	and 03fh		;032f
	ld h,a			;0331
	and 020h		;0332
	add a,h			;0334
	ld h,a			;0335
	ld a,e			;0336
	and 020h		;0337
	or h			;0339
	rrca			;033a
	rrca			;033b
	rrca			;033c
	rrca			;033d
	ld h,a			;033e
	ld a,e			;033f
	rrca			;0340
	and 00fh		;0341
	ld l,a			;0343
	ld a,h			;0344
	and 0f0h		;0345
	or l			;0347
	ld l,a			;0348
	ld a,h			;0349
	and 007h		;034a
	or 008h		;034c
	ld h,a			;034e
	ld c,(hl)			;034f
	ld a,e			;0350
	rrca			;0351
	jp c,l025ah		;0352
	ld a,00fh		;0355
	and b			;0357
	or c			;0358
	ld (hl),a			;0359
	ret			;035a
	inc b			;035b
	ld (bc),a			;035c
	ld a,00fh		;035d
	and b			;035f
	rlca			;0360
	rlca			;0361
	rlca			;0362
	rlca			;0363
	or c			;0364
	ld (hl),a			;0365
	ret			;0366
	inc b			;0367
	ld (bc),a			;0368
	ld hl,00800h		;0369
	ld a,00fh		;036c
	and b			;036e
	ld c,a			;036f
	rlca			;0370
	rlca			;0371
	rlca			;0372
	rlca			;0373
	or c			;0374
	ld c,a			;0375
	ld (hl),c			;0376
	inc hl			;0377
	ld a,h			;0378
	cp 010h		;0379
	jp nc,00011h		;037b
	jp l0273h		;037e
l0381h:
	ld hl,l0103h		;0381
	ld de,00000h		;0384
	ld bc,l027eh		;0387
	ldir		;038a
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
	
	jp 00000h		;038c
