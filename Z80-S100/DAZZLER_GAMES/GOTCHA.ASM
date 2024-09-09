; z80dasm 1.1.6
; command line: z80dasm --address --labels --origin=0x100 GOTCHA.COM

	org	00100h

l0100h:
	jp l0412h		;0100
l0103h:
	di			;0103
sub_0104h:
	ld sp,l035bh		;0104
	call 000beh		;0107
	call sub_02fbh		;010a
	ld hl,(l0314h)		;010d
	ex de,hl			;0110
	ld a,009h		;0111
	ld (l031ah),a		;0113
	ld a,(l0318h)		;0116
	call 00216h		;0119
l011ch:
	ex de,hl			;011c
	ld (l0314h),hl		;011d
	ex de,hl			;0120
	ld bc,00000h		;0121
	jp z,0002dh		;0124
	push bc			;0127
l0128h:
	ld a,00fh		;0128
	call sub_01cbh		;012a
	pop bc			;012d
	ld b,001h		;012e
	push bc			;0130
	ld hl,(00316h)		;0131
	ex de,hl			;0134
	ld a,00ch		;0135
	ld (l031ah),a		;0137
	ld a,(l0319h)		;013a
l013dh:
	call 00216h		;013d
	ex de,hl			;0140
	ld (00316h),hl		;0141
	ex de,hl			;0144
	pop bc			;0145
	jp z,0004fh		;0146
	push bc			;0149
	ld a,00fh		;014a
	call sub_01cbh		;014c
	pop bc			;014f
	ld c,001h		;0150
	ld a,b			;0152
	and a			;0153
	jp nz,00069h		;0154
	ld a,c			;0157
	and a			;0158
	jp z,0009ah		;0159
	call 000a6h		;015c
	jp z,0007bh		;015f
	ld hl,l0312h		;0162
	inc (hl)			;0165
	call sub_0104h		;0166
	jp 0007bh		;0169
	ld a,c			;016c
sub_016dh:
	and a			;016d
	jp nz,0007bh		;016e
	call 000a6h		;0171
	jp z,0007bh		;0174
	ld hl,l0312h+1		;0177
	inc (hl)			;017a
	call 000f6h		;017b
	call 000b3h		;017e
l0181h:
	ld a,(l0312h)		;0181
	cp 009h		;0184
	jp z,0008eh		;0186
	ld a,(l0312h+1)		;0189
	cp 009h		;018c
	jp nz,00094h		;018e
	call sub_02fbh		;0191
	call 000beh		;0194
	call 000d1h		;0197
	jp 0000ah		;019a
	call 002d2h		;019d
	call sub_023ch		;01a0
	call sub_0255h		;01a3
	jp 0000ah		;01a6
	ld hl,(l0314h)		;01a9
	ex de,hl			;01ac
	ld hl,(00316h)		;01ad
	ld a,d			;01b0
	cp h			;01b1
	ret nz			;01b2
	ld a,e			;01b3
	cp l			;01b4
	ret			;01b5
	ld hl,000b9h		;01b6
	jp l02aeh		;01b9
	ld b,b			;01bc
sub_01bdh:
	ld a,b			;01bd
	call p,00001h		;01be
	ld a,090h		;01c1
	out (00fh),a		;01c3
	ld a,082h		;01c5
	out (00eh),a		;01c7
	ld a,000h		;01c9
sub_01cbh:
	ld (l0312h),a		;01cb
	ld (l0312h+1),a		;01ce
	call 001fdh		;01d1
	ld hl,l0309h		;01d4
	ld (l0314h),hl		;01d7
	ld hl,01c1ch		;01da
	ld (00316h),hl		;01dd
	ld a,002h		;01e0
	ld (l0318h),a		;01e2
	ld a,001h		;01e5
	ld (l0319h),a		;01e7
	ld hl,l0400h		;01ea
	ld bc,00200h		;01ed
	call 001eeh		;01f0
	call sub_016dh		;01f3
	call sub_0104h		;01f6
	ld de,01c00h		;01f9
	ld a,00ch		;01fc
	ld (l031ah),a		;01fe
	ld a,(l0312h+1)		;0201
	jp 0010fh		;0204
	ld de,l0100h		;0207
	ld a,009h		;020a
	ld (l031ah),a		;020c
	ld a,(l0312h)		;020f
	ld hl,l013dh		;0212
	and 00fh		;0215
	ld b,a			;0217
	add a,a			;0218
	add a,b			;0219
	call 001f8h		;021a
	ld c,003h		;021d
	ld b,005h		;021f
	ld a,(hl)			;0221
	rla			;0222
	push af			;0223
	ld a,(l031ah)		;0224
	jp c,l0128h		;0227
l022ah:
	sub a			;022a
	call sub_01cbh		;022b
l022eh:
	pop af			;022e
l022fh:
	inc e			;022f
	dec b			;0230
	jp nz,0011fh		;0231
	dec e			;0234
	dec e			;0235
	dec e			;0236
	dec e			;0237
	dec e			;0238
	inc d			;0239
	inc hl			;023a
	dec c			;023b
sub_023ch:
	jp nz,l011ch		;023c
	ret			;023f
	ret m			;0240
	adc a,b			;0241
	ret m			;0242
	nop			;0243
	nop			;0244
	ret m			;0245
	cp b			;0246
l0247h:
	xor b			;0247
	ret pe			;0248
	xor b			;0249
	xor b			;024a
	ret m			;024b
	ret po			;024c
	jr nz,l0247h		;024d
	ret pe			;024f
	xor b			;0250
	cp b			;0251
	ret m			;0252
	xor b			;0253
	cp b			;0254
sub_0255h:
	add a,b			;0255
	add a,b			;0256
	ret m			;0257
	ret m			;0258
	xor b			;0259
	ret m			;025a
	ret po			;025b
	and b			;025c
	ret m			;025d
	ret m			;025e
	and b			;025f
	ret m			;0260
	ret m			;0261
	jr z,$+58		;0262
	ret m			;0264
	adc a,b			;0265
	adc a,b			;0266
	jr c,l0291h		;0267
	ret m			;0269
	ret m			;026a
	xor b			;026b
	xor b			;026c
	ret m			;026d
sub_026eh:
	and b			;026e
	and b			;026f
	ld de,00006h		;0270
	ld b,020h		;0273
	ld a,00ah		;0275
	call sub_01cbh		;0277
	inc d			;027a
	dec b			;027b
l027ch:
	jp nz,00172h		;027c
	ld de,0001fh		;027f
	ld b,020h		;0282
	ld a,00ah		;0284
	call sub_01cbh		;0286
	inc d			;0289
	dec b			;028a
	jp nz,l0181h		;028b
	ld de,00007h		;028e
l0291h:
	ld b,018h		;0291
	ld a,00ah		;0293
	call sub_01cbh		;0295
l0298h:
	inc e			;0298
	dec b			;0299
	jp nz,00190h		;029a
	ld de,01f07h		;029d
	ld b,018h		;02a0
	ld a,00ah		;02a2
	call sub_01cbh		;02a4
	inc e			;02a7
	dec b			;02a8
	jp nz,0019fh		;02a9
l02ach:
	ret			;02ac
	ld l,e			;02ad
l02aeh:
	ld h,000h		;02ae
	add hl,hl			;02b0
	add hl,hl			;02b1
	add hl,hl			;02b2
	add hl,hl			;02b3
	ld a,d			;02b4
	rra			;02b5
	push af			;02b6
	call 001f8h		;02b7
	ld bc,l0400h		;02ba
	add hl,bc			;02bd
	pop af			;02be
sub_02bfh:
	ret			;02bf
	call 001aah		;02c0
	ld a,(hl)			;02c3
	jp nc,001c8h		;02c4
l02c7h:
	rra			;02c7
	rra			;02c8
	rra			;02c9
	rra			;02ca
	and 00fh		;02cb
	ret			;02cd
	push hl			;02ce
	push bc			;02cf
	push af			;02d0
	call 001aah		;02d1
	pop bc			;02d4
	ld a,b			;02d5
	jp nc,001e3h		;02d6
	rla			;02d9
	rla			;02da
	rla			;02db
	rla			;02dc
	and 0f0h		;02dd
l02dfh:
	ld b,a			;02df
	ld a,(hl)			;02e0
	and 00fh		;02e1
	jp 001e9h		;02e3
l02e6h:
	and 00fh		;02e6
	ld b,a			;02e8
	ld a,(hl)			;02e9
	and 0f0h		;02ea
	or b			;02ec
	ld (hl),a			;02ed
	pop bc			;02ee
	pop hl			;02ef
	ret			;02f0
	ld a,b			;02f1
	or c			;02f2
	ret z			;02f3
	sub a			;02f4
	ld (hl),a			;02f5
	inc hl			;02f6
	dec bc			;02f7
	jp 001eeh		;02f8
sub_02fbh:
	add a,l			;02fb
	ld l,a			;02fc
	ret nc			;02fd
	inc h			;02fe
	ret			;02ff
	in a,(01ah)		;0300
	cpl			;0302
	ld (l030eh),a		;0303
	in a,(019h)		;0306
	cpl			;0308
l0309h:
	ld (l030fh),a		;0309
	in a,(01ch)		;030c
l030eh:
	cpl			;030e
l030fh:
	ld (l030fh+1),a		;030f
l0312h:
	in a,(01bh)		;0312
l0314h:
	cpl			;0314
	ld (l030fh+2),a		;0315
l0318h:
	ret			;0318
l0319h:
	dec a			;0319
l031ah:
	jp z,00226h		;031a
	dec a			;031d
	jp z,l022ah		;031e
	dec a			;0321
	jp z,l022eh		;0322
	dec d			;0325
	jp l022fh		;0326
	dec e			;0329
	jp l022fh		;032a
	inc e			;032d
	jp l022fh		;032e
	inc d			;0331
	call sub_01bdh		;0332
	and a			;0335
	ret nz			;0336
	ld a,(l031ah)		;0337
	call sub_01cbh		;033a
	sub a			;033d
	ret			;033e
	ld a,(l030eh)		;033f
	ld b,a			;0342
	in a,(01ah)		;0343
	add a,b			;0345
	ld b,a			;0346
	ld a,(l030fh)		;0347
	ld c,a			;034a
	in a,(019h)		;034b
	add a,c			;034d
	ld c,a			;034e
	call sub_026eh		;034f
	and a			;0352
	ret z			;0353
	ld (l0318h),a		;0354
	ret			;0357
	ld a,(l030fh+1)		;0358
l035bh:
	ld b,a			;035b
	in a,(01ch)		;035c
	add a,b			;035e
	ld b,a			;035f
	ld a,(l030fh+2)		;0360
	ld c,a			;0363
	in a,(01bh)		;0364
	add a,c			;0366
	ld c,a			;0367
	call sub_026eh		;0368
	and a			;036b
	ret z			;036c
	ld (l0319h),a		;036d
	ret			;0370
	ld a,b			;0371
	and a			;0372
	jp m,00278h		;0373
	ld d,001h		;0376
	jp l027ch		;0378
	ld d,002h		;037b
	cpl			;037d
	ld b,a			;037e
	cp 040h		;037f
	jp nc,00283h		;0381
	ld d,000h		;0384
	ld a,c			;0386
	and a			;0387
	jp m,0028dh		;0388
	ld e,003h		;038b
	jp l0291h		;038d
	ld e,004h		;0390
	cpl			;0392
	ld c,a			;0393
	cp 040h		;0394
	jp nc,l0298h		;0396
	ld e,000h		;0399
	ld a,d			;039b
	sub e			;039c
	ret z			;039d
	ld a,d			;039e
	and a			;039f
	jp z,002aah		;03a0
	ld a,e			;03a3
	and a			;03a4
	jp z,l02ach		;03a5
	ld a,b			;03a8
	cp c			;03a9
	jp c,002aah		;03aa
	ld a,e			;03ad
	ret			;03ae
	ld a,d			;03af
	ret			;03b0
	ld a,(hl)			;03b1
	and a			;03b2
	ret z			;03b3
	ld b,a			;03b4
	inc hl			;03b5
	ld c,(hl)			;03b6
	inc hl			;03b7
	ld e,(hl)			;03b8
	inc hl			;03b9
	ld d,(hl)			;03ba
	inc hl			;03bb
	call sub_02bfh		;03bc
	jp l02aeh		;03bf
	ld a,b			;03c2
	cpl			;03c3
	ld b,a			;03c4
	out (019h),a		;03c5
	out (01bh),a		;03c7
	ld a,c			;03c9
	dec a			;03ca
	jp nz,l02c7h		;03cb
	dec de			;03ce
	ld a,d			;03cf
	or e			;03d0
	jp nz,sub_02bfh		;03d1
	ret			;03d4
	in a,(018h)		;03d5
	and 022h		;03d7
	cp 022h		;03d9
	ld b,01eh		;03db
	jp z,l02dfh		;03dd
	ld b,00fh		;03e0
delay:
	in a,(00eh)		;03e2
	;cp 03fh		;03e4
	and 040h
	jp nz,02dfh		;03e6
dly300:
	in a,(00eh)		;03e9
	and 040h
	;cp 03fh		;03eb
	jp z,02e6h		;03ed
	dec b			;03f0
	jp nz,02dfh		;03f1
	in a,(018h)		;03f4
	and 044h		;03f6
	cp 044h		;03f8
	jp nz,l0309h+2		;03fa
	ret			;03fd
	in a,(018h)		;03fe
l0400h:
	and 011h		;0400
	cp 011h		;0402
	ret nz			;0404
	in a,(018h)		;0405
	and 044h		;0407
	cp 044h		;0409
	jp z,sub_02fbh		;040b
	jp 00000h		;040e
	ret			;0411
l0412h:
	ld a,000h		;0412
	out (018h),a		;0414
	ld hl,l0103h		;0416
	ld de,00000h		;0419
	ld bc,l030fh		;041c
	ldir		;041f
	jp 00000h		;0421
