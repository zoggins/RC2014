; z80dasm 1.1.6
; command line: z80dasm --address --labels --origin=0x100 AMBUSH.COM

	org	00100h

l0100h:
	jp init		;0100
;	jp l010eh		;0100
	ld de,l0100h		;0103
	ld bc,00c00h		;0106
	ldir		;0109
	jp l010eh		;010b
l010eh:
	ld sp,00d1eh		;010e
	call sub_050fh		;0111
l0114h:
	in a,(00eh)		;0114
	rla			;0116
	rla			;0117
	jr c,l0114h		;0118
	call sub_02f4h		;011a
l011dh:
	in a,(00eh)		;011d
	rla			;011f
l0120h:
	rla			;0120
	jr nc,l011dh		;0121
	call sub_02c3h		;0123
	call sub_034ah		;0126
	ld a,(l0831h)		;0129
	rra			;012c
	jr nc,l013eh		;012d
l012fh:
	in a,(00eh)		;012f
	rla			;0131
	rla			;0132
	jr c,l012fh		;0133
	call sub_02f4h		;0135
l0138h:
	in a,(00eh)		;0138
	rla			;013a
	rla			;013b
	jr nc,l0138h		;013c
l013eh:
	call sub_0146h		;013e
	call sub_064eh		;0141
	jr l0114h		;0144
sub_0146h:
	ld b,002h		;0146
	ld hl,(l0812h)		;0148
	xor a			;014b
sub_014ch:
	cp h			;014c
	jr z,l01b0h		;014d
	ld a,(hl)			;014f
	ld d,05ah		;0150
	cp d			;0152
	jr z,l015dh		;0153
	ld d,0f0h		;0155
	and d			;0157
	cp d			;0158
	jr z,l015dh		;0159
	ld d,00fh		;015b
l015dh:
	ld a,d			;015d
	xor (hl)			;015e
	ld (hl),a			;015f
	ld de,(l080bh)		;0160
l0164h:
	ld a,e			;0164
	add a,d			;0165
	ld e,a			;0166
	jr nc,l017eh		;0167
	ld a,l			;0169
	and 00fh		;016a
	bit 1,h		;016c
	jr z,l0178h		;016e
	cp 00fh		;0170
	jp z,l02bch		;0172
	inc l			;0175
	jr l017eh		;0176
l0178h:
	cp 000h		;0178
	jp z,l02bch		;017a
	dec l			;017d
l017eh:
	ld a,0f0h		;017e
	and l			;0180
	jr nz,l018eh		;0181
	bit 0,h		;0183
	jr nz,l018eh		;0185
	bit 2,h		;0187
	jp z,l02bch		;0189
	dec h			;018c
	dec h			;018d
l018eh:
	ld a,l			;018e
	sub 010h		;018f
	ld l,a			;0191
	ld a,h			;0192
	sbc a,000h		;0193
	ld h,a			;0195
	xor a			;0196
	or (hl)			;0197
	jr nz,l01e0h		;0198
l019ah:
	djnz l0164h		;019a
l019ch:
	ld a,05ah		;019c
	ld (hl),a			;019e
	ld (l080bh),de		;019f
	ld (l0812h),hl		;01a3
	nop			;01a6
	ld hl,00c72h		;01a7
	ld bc,l091bh		;01aa
	otir		;01ad
	ret			;01af
l01b0h:
	ld hl,027f0h		;01b0
	ld a,(00836h)		;01b3
	dec a			;01b6
	ld (00836h),a		;01b7
	jp nz,l072eh		;01ba
	in a,(018h)		;01bd
	bit 4,a		;01bf
	jr z,l01cbh		;01c1
	ld a,001h		;01c3
	ld (00836h),a		;01c5
	jp l072eh		;01c8
l01cbh:
	ld a,018h		;01cb
	ld (00836h),a		;01cd
	in a,(01bh)		;01d0
	bit 7,a		;01d2
	jr z,l01dah		;01d4
	cpl			;01d6
	ld hl,025ffh		;01d7
l01dah:
	ld d,a			;01da
	ld e,001h		;01db
	inc e			;01dd
	jr l019ch		;01de
l01e0h:
	bit 2,h		;01e0
	jr nz,l019ah		;01e2
	push hl			;01e4
	ld hl,00c72h		;01e5
	ld bc,02819h		;01e8
	otir		;01eb
	ld b,004h		;01ed
l01efh:
	dec ix		;01ef
	ld a,002h		;01f1
	cp (ix+000h)		;01f3
	jp z,l02b5h		;01f6
	pop hl			;01f9
	push hl			;01fa
	bit 1,h		;01fb
	jr z,l0201h		;01fd
	dec h			;01ff
	dec h			;0200
l0201h:
	ld a,(ix+019h)		;0201
	cp h			;0204
	jr z,l020dh		;0205
	inc h			;0207
	inc h			;0208
	cp h			;0209
	jp nz,l02b5h		;020a
l020dh:
	ld a,080h		;020d
	and l			;020f
	ld c,a			;0210
	ld a,080h		;0211
	and (ix+014h)		;0213
	cp c			;0216
	jp nz,l02b5h		;0217
	ld a,070h		;021a
	and l			;021c
	cp 070h		;021d
	jp z,l02b9h		;021f
	ld d,a			;0222
	ld a,003h		;0223
	and (ix+000h)		;0225
	dec a			;0228
	jr z,l023bh		;0229
	ld e,a			;022b
	ld a,060h		;022c
	cp d			;022e
	jp z,l02b9h		;022f
	inc e			;0232
	jr z,l023bh		;0233
	ld a,050h		;0235
	cp d			;0237
	jp z,l02b9h		;0238
l023bh:
	pop hl			;023b
	push hl			;023c
	ld a,l			;023d
	and 00fh		;023e
	bit 1,h		;0240
	jr z,l0246h		;0242
	add a,010h		;0244
l0246h:
	ld c,a			;0246
	ld a,(ix+014h)		;0247
	and 00fh		;024a
	bit 1,(ix+019h)		;024c
	jr z,l0254h		;0250
	add a,010h		;0252
l0254h:
	sub c			;0254
	bit 7,(ix+000h)		;0255
	jr nz,l025dh		;0259
	neg		;025b
l025dh:
	or a			;025d
	jp m,l02b9h		;025e
	sub 007h		;0261
	jp p,l02b9h		;0263
	ld a,007h		;0266
	and (ix+000h)		;0268
	ld b,a			;026b
	jr nz,l0273h		;026c
	ld a,073h		;026e
	ld (00836h),a		;0270
l0273h:
	ld a,(l080eh)		;0273
	add a,b			;0276
	daa			;0277
	ld (l080eh),a		;0278
	ld a,(l080fh)		;027b
	adc a,000h		;027e
	daa			;0280
	ld (l080fh),a		;0281
	ld de,(l080eh)		;0284
	call sub_05fbh		;0288
	ld de,027b4h		;028b
	call sub_0622h		;028e
	ld a,(l080eh)		;0291
	add a,07bh		;0294
	jr nc,l02a6h		;0296
	ld a,001h		;0298
	ld (l083bh),a		;029a
	ld bc,l0b1eh		;029d
	ld de,024e2h		;02a0
	call sub_0622h		;02a3
l02a6h:
	ld a,00eh		;02a6
	ld (ix+00fh),a		;02a8
	set 6,(ix+000h)		;02ab
	pop hl			;02af
	call sub_0751h		;02b0
	jr l02bch		;02b3
l02b5h:
	dec b			;02b5
	jp nz,l01efh		;02b6
l02b9h:
	pop hl			;02b9
	xor a			;02ba
	ld (hl),a			;02bb
l02bch:
	xor a			;02bc
	ld (l0813h),a		;02bd
	jp l072eh		;02c0
sub_02c3h:
	ld a,(00836h)		;02c3
	cp 019h		;02c6
	jp m,sub_0146h		;02c8
	jr z,l02e2h		;02cb
	cp 071h		;02cd
	ret m			;02cf
	ld bc,l0b22h		;02d0
	ld de,02434h		;02d3
	call sub_0622h		;02d6
	ld bc,l0b29h		;02d9
	ld de,02630h		;02dc
	jp sub_0622h		;02df
l02e2h:
	ld bc,l0b31h		;02e2
	ld de,02434h		;02e5
	call sub_0622h		;02e8
	ld bc,l0b31h		;02eb
	ld de,02630h		;02ee
	jp sub_0622h		;02f1
sub_02f4h:
	ld a,(l0831h)		;02f4
	rra			;02f7
	jr nc,l0306h		;02f8
	;ld a,(l0825h)		;02fa
	ld a,(l0824h)
	out (00eh),a		;02fd
	;ld a,(l0826h)		;02ff
	ld a,(l0827h)		;02ff
	out (00fh),a		;0302
	jr l0310h		;0304
l0306h:
	ld a,(l0824h)		;0306
	out (00eh),a		;0309
	ld a,(l0827h)		;030b
	out (00fh),a		;030e
l0310h:
	ld a,(l0831h)		;0310
	dec a			;0313
	ld (l0831h),a		;0314
	ret p			;0317
	ld a,03eh		;0318
	ld (l0831h),a		;031a
	ld a,(l0810h)		;031d
	sub 001h		;0320
	daa			;0322
	ld (l0810h),a		;0323
sub_0326h:
	ld de,(l0810h)		;0326
	push de			;032a
	call sub_05e8h		;032b
	ld de,025b1h		;032e
	call sub_0622h		;0331
	pop bc			;0334
	dec c			;0335
	ret p			;0336
	ld a,060h		;0337
	ld (l0810h),a		;0339
	dec b			;033c
	ld a,b			;033d
	ld (l0811h),a		;033e
	ret p			;0341
	ld a,(l083bh)		;0342
	and b			;0345
	ret nz			;0346
	jp l010eh		;0347
sub_034ah:
	ld ix,l0828h		;034a
l034eh:
	ld a,(ix+000h)		;034e
	cp 004h		;0351
	ret z			;0353
	cp 006h		;0354
	jr z,l037fh		;0356
	cp 002h		;0358
	jr nz,l0371h		;035a
	dec (ix+005h)		;035c
	jr nz,l0366h		;035f
	ld a,006h		;0361
	ld (ix+000h),a		;0363
l0366h:
	inc ix		;0366
	in a,(00eh)		;0368
	rla			;036a
	rla			;036b
	call nc,sub_02f4h		;036c
	jr l034eh		;036f
l0371h:
	ld a,(ix+005h)		;0371
	add a,(ix+00ah)		;0374
	ld (ix+005h),a		;0377
	call nc,sub_03bbh		;037a
	jr l0366h		;037d
l037fh:
	ld hl,(l0822h)		;037f
	ld a,r		;0382
	and 00fh		;0384
	rlca			;0386
	rlca			;0387
	ld c,a			;0388
	ld b,000h		;0389
	add hl,bc			;038b
	ld a,(hl)			;038c
	ld (ix+000h),a		;038d
	inc hl			;0390
	ld a,(hl)			;0391
	ld (ix+00ah),a		;0392
	inc hl			;0395
	ld e,(hl)			;0396
	inc hl			;0397
	ld d,(hl)			;0398
	ld h,(ix+019h)		;0399
	ld l,(ix+014h)		;039c
	ex de,hl			;039f
	bit 7,(ix+000h)		;03a0
	call z,sub_04a9h		;03a4
	jr z,l0371h		;03a7
	set 1,(ix+019h)		;03a9
	set 1,d		;03ad
	ld a,00fh		;03af
	add a,e			;03b1
	ld (ix+014h),a		;03b2
	ld e,a			;03b5
	call sub_04dbh		;03b6
	jr l0371h		;03b9
sub_03bbh:
	bit 6,(ix+000h)		;03bb
	ret nz			;03bf
	ld b,005h		;03c0
	ld c,(ix+000h)		;03c2
	bit 3,c		;03c5
	jr nz,l03f3h		;03c7
	bit 1,c		;03c9
	jr nz,l03d3h		;03cb
	inc b			;03cd
	bit 0,c		;03ce
	jr z,l03d3h		;03d0
	inc b			;03d2
l03d3h:
	ld h,(ix+019h)		;03d3
	ld l,(ix+014h)		;03d6
l03d9h:
	bit 7,c		;03d9
	call z,sub_0433h		;03db
	bit 7,c		;03de
	call nz,sub_046eh		;03e0
	ld a,010h		;03e3
	add a,l			;03e5
	ld l,a			;03e6
	djnz l03d9h		;03e7
	ld a,(ix+00fh)		;03e9
	inc a			;03ec
	ld (ix+00fh),a		;03ed
	and 003h		;03f0
	ret nz			;03f2
l03f3h:
	ld h,(ix+019h)		;03f3
	ld l,(ix+014h)		;03f6
	bit 7,c		;03f9
	jr z,l040fh		;03fb
	ld a,00fh		;03fd
l03ffh:
	and l			;03ff
	jr nz,l040ch		;0400
	bit 1,h		;0402
	jr z,l0428h		;0404
	dec h			;0406
	dec h			;0407
	ld a,010h		;0408
	add a,l			;040a
	ld l,a			;040b
l040ch:
	dec hl			;040c
	jr l041fh		;040d
l040fh:
	inc hl			;040f
	ld a,00fh		;0410
	and l			;0412
	jr nz,l041fh		;0413
	ld a,l			;0415
	sub 010h		;0416
	ld l,a			;0418
	bit 1,h		;0419
	jr nz,l0426h		;041b
	inc h			;041d
	inc h			;041e
l041fh:
	ld (ix+019h),h		;041f
	ld (ix+014h),l		;0422
	ret			;0425
l0426h:
	dec h			;0426
	dec h			;0427
l0428h:
	xor a			;0428
	ld (ix+00fh),a		;0429
	ld a,002h		;042c
	ld (ix+000h),a		;042e
	jr l041fh		;0431
sub_0433h:
	push hl			;0433
	exx			;0434
	pop hl			;0435
	ld b,007h		;0436
	bit 1,(ix+000h)		;0438
	jr z,l0446h		;043c
	dec b			;043e
	bit 2,(ix+000h)		;043f
	jr z,l0446h		;0443
	dec b			;0445
l0446h:
	ld c,000h		;0446
l0448h:
	ld e,(hl)			;0448
	ld a,00ah		;0449
	and e			;044b
sub_044ch:
	or c			;044c
	rlca			;044d
	rlca			;044e
	ld c,a			;044f
	ld a,055h		;0450
	and e			;0452
	or c			;0453
	rlca			;0454
	ld (hl),a			;0455
	ld a,0a0h		;0456
	and e			;0458
	ld c,a			;0459
	inc hl			;045a
	ld a,00fh		;045b
	and l			;045d
	jr nz,l046ah		;045e
	ld a,l			;0460
	sub 010h		;0461
	ld l,a			;0463
	bit 1,h		;0464
	jr nz,l046ch		;0466
	inc h			;0468
	inc h			;0469
l046ah:
	djnz l0448h		;046a
l046ch:
	exx			;046c
	ret			;046d
sub_046eh:
	push hl			;046e
	exx			;046f
	pop hl			;0470
	ld b,007h		;0471
	bit 1,(ix+000h)		;0473
	jr z,l0481h		;0477
	dec b			;0479
	bit 2,(ix+000h)		;047a
	jr z,l0481h		;047e
	dec b			;0480
l0481h:
	ld c,000h		;0481
l0483h:
	ld e,(hl)			;0483
	ld a,050h		;0484
	and e			;0486
	or c			;0487
	rrca			;0488
	rrca			;0489
	ld c,a			;048a
	ld a,0aah		;048b
	and e			;048d
	or c			;048e
	rrca			;048f
	ld (hl),a			;0490
	ld a,005h		;0491
	and e			;0493
	ld c,a			;0494
	ld a,00fh		;0495
	and l			;0497
	jr nz,l04a4h		;0498
	bit 1,h		;049a
	jr z,l04a7h		;049c
	dec h			;049e
	dec h			;049f
	ld a,010h		;04a0
	add a,l			;04a2
	ld l,a			;04a3
l04a4h:
	dec hl			;04a4
	djnz l0483h		;04a5
l04a7h:
	exx			;04a7
	ret			;04a8
sub_04a9h:
	ld a,e			;04a9
	ld b,(hl)			;04aa
l04abh:
	push de			;04ab
	add a,010h		;04ac
	ld e,a			;04ae
	djnz l04abh		;04af
	ld a,(hl)			;04b1
	exx			;04b2
	ld b,a			;04b3
	exx			;04b4
	inc hl			;04b5
	ld c,(hl)			;04b6
	inc hl			;04b7
l04b8h:
	ld b,c			;04b8
	pop de			;04b9
l04bah:
	ldi		;04ba
	inc c			;04bc
	ld a,e			;04bd
	and 00fh		;04be
	jr nz,l04cch		;04c0
	bit 1,d		;04c2
	jr nz,l04d4h		;04c4
	inc d			;04c6
	inc d			;04c7
	ld a,e			;04c8
	sub 010h		;04c9
	ld e,a			;04cb
l04cch:
	djnz l04bah		;04cc
l04ceh:
	exx			;04ce
	dec b			;04cf
	exx			;04d0
	jr nz,l04b8h		;04d1
	ret			;04d3
l04d4h:
	djnz l04d8h		;04d4
	jr l04ceh		;04d6
l04d8h:
	inc hl			;04d8
	jr l04d4h		;04d9
sub_04dbh:
	ld a,e			;04db
	ld b,(hl)			;04dc
l04ddh:
	push de			;04dd
	add a,010h		;04de
	ld e,a			;04e0
	djnz l04ddh		;04e1
	ld a,(hl)			;04e3
	exx			;04e4
	ld b,a			;04e5
	exx			;04e6
	inc hl			;04e7
	ld c,(hl)			;04e8
	inc hl			;04e9
l04eah:
	ld b,c			;04ea
	pop de			;04eb
l04ech:
	ldi		;04ec
	inc c			;04ee
	dec de			;04ef
	ld a,e			;04f0
	and 00fh		;04f1
	jr nz,l04ffh		;04f3
	bit 1,d		;04f5
	jr z,l0508h		;04f7
	dec d			;04f9
	dec d			;04fa
	ld a,e			;04fb
	add a,010h		;04fc
	ld e,a			;04fe
l04ffh:
	dec de			;04ff
sub_0500h:
	djnz l04ech		;0500
l0502h:
	exx			;0502
	dec b			;0503
	exx			;0504
	jr nz,l04eah		;0505
	ret			;0507
l0508h:
	djnz l050ch		;0508
	jr l0502h		;050a
l050ch:
	inc hl			;050c
	jr l0508h		;050d
sub_050fh:
	ld de,02001h		;050f
	ld hl,02000h		;0512
	ld bc,l07ffh		;0515
	xor a			;0518
	ld (hl),a			;0519
	ldir		;051a
sub_051ch:
	ld de,(l080eh)		;051c
	call sub_05fbh		;0520
	ld de,027b4h		;0523
	call sub_0622h		;0526
	ld de,(l0800h)		;0529
	call sub_05fbh		;052d
	ld de,022e4h		;0530
	call sub_0622h		;0533
	ld bc,l0b41h		;0536
	ld de,02207h		;0539
	call sub_0622h		;053c
	ld bc,l0b13h		;053f
	ld de,02276h		;0542
	call sub_0622h		;0545
	ld hl,(l07feh)		;0548
	ld bc,(l080eh)		;054b
	ld (l0800h),bc		;054f
	xor a			;0553
	sbc hl,bc		;0554
	or h			;0556
	jp p,l055eh		;0557
	ld (l07feh),bc		;055a
l055eh:
	ld de,(l07feh)		;055e
	call sub_05fbh		;0562
	ld de,020e0h		;0565
	call sub_0622h		;0568
	ld bc,l0b39h		;056b
	ld de,02000h		;056e
	call sub_0622h		;0571
	ld bc,l0b13h		;0574
	ld de,02072h		;0577
	call sub_0622h		;057a
	ld bc,l0b19h		;057d
	ld de,02541h		;0580
	call sub_0622h		;0583
	ld bc,l0b13h		;0586
	ld de,02746h		;0589
	call sub_0622h		;058c
	ld hl,l0ca6h		;058f
	ld de,l080eh		;0592
	ld bc,00037h		;0595
	ldir		;0598
	call sub_0326h		;059a
	ld a,090h		;059d
	out (00eh),a		;059f
	ld a,07ah		;05a1
	out (00fh),a		;05a3
l05a5h:
	call l072eh		;05a5
	in a,(018h)		;05a8
	bit 4,a		;05aa
	jr z,l05dch		;05ac
	bit 5,a		;05ae
	jr nz,l05b5h		;05b0
	ld (l080dh),a		;05b2
l05b5h:
	bit 6,a		;05b5
	jr nz,l05c3h		;05b7
	xor a			;05b9
	ld (l080dh),a		;05ba
	ld hl,(l0820h)		;05bd
	ld (hl),a			;05c0
	in a,(018h)		;05c1
l05c3h:
	rla			;05c3
	jr c,l05a5h		;05c4
	ld de,02001h		;05c6
	ld hl,02000h		;05c9
	ld bc,l03ffh		;05cc
	xor a			;05cf
	ld (hl),a			;05d0
	ldir		;05d1
	ld bc,l0b33h		;05d3
	ld de,027b4h		;05d6
	jp sub_0622h		;05d9
l05dch:
	bit 6,a		;05dc
	jr nz,l05b5h		;05de
	ld hl,l0aa3h		;05e0
	ld (l0822h),hl		;05e3
	jr l05b5h		;05e6
sub_05e8h:
	ld de,(l0810h)		;05e8
	ld a,00fh		;05ec
	and d			;05ee
	or 0b0h		;05ef
	rrca			;05f1
	rrca			;05f2
	rrca			;05f3
	rrca			;05f4
	ld d,a			;05f5
	ld hl,l081bh		;05f6
	jr l05feh		;05f9
sub_05fbh:
	ld hl,l0814h		;05fb
l05feh:
	exx			;05fe
	ld b,00ah		;05ff
	exx			;0601
	push hl			;0602
	ld c,002h		;0603
l0605h:
	ld b,002h		;0605
l0607h:
	ld a,d			;0607
	rrca			;0608
	rrca			;0609
	rrca			;060a
	rrca			;060b
	ld d,a			;060c
	and 00fh		;060d
	exx			;060f
	jr z,l0616h		;0610
	ld b,000h		;0612
	jr l0617h		;0614
l0616h:
	ld a,b			;0616
l0617h:
	exx			;0617
	ld (hl),a			;0618
	inc hl			;0619
	djnz l0607h		;061a
	ld d,e			;061c
	dec c			;061d
	jr nz,l0605h		;061e
	pop bc			;0620
l0621h:
	ret			;0621
sub_0622h:
	ld a,(bc)			;0622
	rlca			;0623
	ret c			;0624
	push bc			;0625
	ld h,000h		;0626
	ld l,a			;0628
	push hl			;0629
	add hl,hl			;062a
	add hl,hl			;062b
	pop bc			;062c
	add hl,bc			;062d
	ld bc,l0b46h		;062e
	add hl,bc			;0631
	pop bc			;0632
	push hl			;0633
	push de			;0634
	exx			;0635
	pop de			;0636
	pop hl			;0637
	ld b,000h		;0638
	ld a,005h		;063a
l063ch:
	ld c,010h		;063c
	ldi		;063e
	ldi		;0640
	ex de,hl			;0642
	add hl,bc			;0643
	ex de,hl			;0644
	dec a			;0645
	jr nz,l063ch		;0646
	exx			;0648
	inc de			;0649
	inc de			;064a
	inc bc			;064b
	jr sub_0622h		;064c
sub_064eh:
	ld ix,l0828h		;064e
l0652h:
	ld a,(ix+000h)		;0652
	cp 004h		;0655
	ret z			;0657
	bit 6,a		;0658
	jr z,l06bdh		;065a
	dec (ix+00fh)		;065c
	jr z,l068fh		;065f
	ld hl,l0c7eh		;0661
	ld bc,02819h		;0664
	otir		;0667
	ld a,(ix+00fh)		;0669
	cp 00ah		;066c
	jr z,l067ah		;066e
	cp 005h		;0670
	jr z,l0681h		;0672
	cp 002h		;0674
	jr z,l0688h		;0676
	jr l06b9h		;0678
l067ah:
	ld a,079h		;067a
	ld (l0827h),a		;067c
	jr l06b9h		;067f
l0681h:
	ld a,071h		;0681
	ld (l0827h),a		;0683
	jr l06b9h		;0686
l0688h:
	ld a,030h		;0688
	ld (l0827h),a		;068a
	jr l06b9h		;068d
l068fh:
	ld hl,(l0807h)		;068f
	ld d,(ix+019h)		;0692
	ld c,a			;0695
	ld a,(ix+014h)		;0696
	add a,000h		;0699
	bit 0,c		;069b
	jr z,l06a1h		;069d
	add a,030h		;069f
l06a1h:
	ld e,a			;06a1
	bit 7,c		;06a2
	call z,sub_04a9h		;06a4
	call nz,sub_04dbh		;06a7
	ld a,07ah		;06aa
	ld (l0827h),a		;06ac
	ld a,090h		;06af
	ld (l0824h),a		;06b1
	ld c,008h		;06b4
l06b6h:
	ld (ix+000h),c		;06b6
l06b9h:
	inc ix		;06b9
	jr l0652h		;06bb
l06bdh:
	and 007h		;06bd
	cp 007h		;06bf
	jr nz,l06ceh		;06c1
	call sub_03bbh		;06c3
	ld hl,l0c83h		;06c6
	ld bc,l0919h		;06c9
	otir		;06cc
l06ceh:
	ld c,(ix+000h)		;06ce
	bit 5,c		;06d1
	jr z,l06b9h		;06d3
	ld a,r		;06d5
	and 007h		;06d7
	jr nz,l06b9h		;06d9
	ld a,(ix+00fh)		;06db
	cp 012h		;06de
	jp m,l06b9h		;06e0
	and 007h		;06e3
	jr nz,l06b9h		;06e5
	ld b,005h		;06e7
	bit 1,(ix+000h)		;06e9
	jr z,l06f7h		;06ed
	dec b			;06ef
	bit 2,(ix+000h)		;06f0
	jr z,l06f7h		;06f4
	dec b			;06f6
l06f7h:
	ld hl,l0802h		;06f7
	ld (hl),b			;06fa
	ld b,(ix+014h)		;06fb
	ld a,00fh		;06fe
l0700h:
	and b			;0700
	bit 7,c		;0701
	jr z,l0713h		;0703
	cp 006h		;0705
	jp m,l06b9h		;0707
	ld a,b			;070a
	sub (hl)			;070b
	ld (ix+014h),a		;070c
	res 7,c		;070f
	jr l071fh		;0711
l0713h:
	cp 009h		;0713
	jp p,l06b9h		;0715
	ld a,b			;0718
	add a,(hl)			;0719
	ld (ix+014h),a		;071a
	set 7,c		;071d
l071fh:
	ld a,008h		;071f
	ld (ix+00fh),a		;0721
	bit 4,c		;0724
	set 4,c		;0726
	jr z,l06b6h		;0728
	res 5,c		;072a
	jr l06b6h		;072c
l072eh:
	ld a,(l080dh)		;072e
	and a			;0731
	ret z			;0732
	ld hl,(l0820h)		;0733
	xor a			;0736
	ld (hl),a			;0737
	ld hl,02400h		;0738
	in a,(01bh)		;073b
	bit 7,a		;073d
	jr nz,l0743h		;073f
	set 1,h		;0741
l0743h:
	and 078h		;0743
	rrca			;0745
	rrca			;0746
	rrca			;0747
	add a,l			;0748
	ld l,a			;0749
	ld a,0a5h		;074a
	ld (hl),a			;074c
	ld (l0820h),hl		;074d
	ret			;0750
sub_0751h:
;	ld a,094h		;0751
	ld a,090h
	ld (l0824h),a		;0753
	ld a,030h		;0756
	ld (l0827h),a		;0758
	ld hl,02800h		;075b
	ld de,02801h		;075e
	ld bc,l07ffh		;0761
	xor a			;0764
	ld (hl),a			;0765
	ldir		;0766
	ld d,(ix+019h)		;0768
	ld e,(ix+014h)		;076b
	push de			;076e
	ld c,(ix+000h)		;076f
	bit 4,c		;0772
	jr z,l07bch		;0774
	bit 5,c		;0776
	jr z,l07bch		;0778
	ld a,0f0h		;077a
	and e			;077c
	ld b,a			;077d
	xor e			;077e
	add a,006h		;077f
	bit 7,c		;0781
	jr z,l0787h		;0783
	sub 00ch		;0785
l0787h:
	bit 4,a		;0787
	jr z,l07a7h		;0789
	and 00fh		;078b
	bit 7,c		;078d
	jr z,l07a1h		;078f
	bit 1,d		;0791
	jr z,l0799h		;0793
	dec d			;0795
	dec d			;0796
	jr l07a7h		;0797
l0799h:
	ld a,000h		;0799
	jr l07a7h		;079b
l079dh:
	ld a,00fh		;079d
	jr l07a7h		;079f
l07a1h:
	bit 1,d		;07a1
	jr nz,l079dh		;07a3
	inc d			;07a5
	inc d			;07a6
l07a7h:
	or b			;07a7
	ld e,a			;07a8
	pop af			;07a9
	push de			;07aa
	ld (ix+019h),d		;07ab
	ld (ix+014h),e		;07ae
	bit 7,c		;07b1
	set 7,c		;07b3
	jr z,l07b9h		;07b5
	res 7,c		;07b7
l07b9h:
	ld (ix+000h),c		;07b9
l07bch:
	ld hl,0094bh		;07bc
	bit 7,c		;07bf
	call z,sub_04a9h		;07c1
	call nz,sub_04dbh		;07c4
	ld a,007h		;07c7
	and (ix+000h)		;07c9
	cp 007h		;07cc
	jr nz,l07d2h		;07ce
	ld a,002h		;07d0
l07d2h:
	ld l,a			;07d2
	add a,a			;07d3
	add a,l			;07d4
	add a,a			;07d5
	bit 7,(ix+000h)		;07d6
	jr z,l07deh		;07da
	add a,018h		;07dc
l07deh:
	ld b,000h		;07de
	ld c,a			;07e0
	ld hl,(l0802h+1)		;07e1
	add hl,bc			;07e4
	ld c,006h		;07e5
	ld de,l0805h		;07e7
	ldir		;07ea
	ld hl,(l0805h)		;07ec
	pop de			;07ef
	ld a,008h		;07f0
	add a,d			;07f2
	ld d,a			;07f3
	bit 7,(ix+000h)		;07f4
	jp z,sub_04a9h		;07f8
	jp sub_04dbh		;07fb
l07feh:
	add a,h			;07fe
l07ffh:
	nop			;07ff
l0800h:
	ld h,(hl)			;0800
	nop			;0801
l0802h:
	cp 0e3h		;0802
	ld a,(bc)			;0804
l0805h:
	ld c,e			;0805
	add hl,bc			;0806
l0807h:
	ld c,e			;0807
	add hl,bc			;0808
	ld c,e			;0809
	add hl,bc			;080a
l080bh:
	ex de,hl			;080b
	ld d,e			;080c
l080dh:
	nop			;080d
l080eh:
	nop			;080e
l080fh:
	nop			;080f
l0810h:
	nop			;0810
l0811h:
	ld (bc),a			;0811
l0812h:
	nop			;0812
l0813h:
	nop			;0813
l0814h:
	inc bc			;0814
	ld hl,00001h		;0815
	nop			;0818
	nop			;0819
	add a,b			;081a
l081bh:
	ld h,057h		;081b
	pop de			;081d
	jr nc,$-126		;081e
l0820h:
	nop			;0820
	inc h			;0821
l0822h:
	ld h,e			;0822
	ld a,(bc)			;0823
l0824h:
	sub b			;0824
l0825h:
	sub b			;0825
l0826h:
	ld a,d			;0826
l0827h:
	ld a,d			;0827
l0828h:
	ld (bc),a			;0828
	ld b,002h		;0829
	ld (bc),a			;082b
	inc b			;082c
	ld (de),a			;082d
	nop			;082e
	ld b,(hl)			;082f
	ld a,l			;0830
l0831h:
	ld bc,0ebcdh		;0831
	ld d,e			;0834
	jp c,00001h		;0835
	nop			;0838
	nop			;0839
	nop			;083a
l083bh:
	nop			;083b
	nop			;083c
	add a,b			;083d
	nop			;083e
	add a,b			;083f
	nop			;0840
	jr nz,l0863h		;0841
	ld hl,00521h		;0843
	inc b			;0846
	or b			;0847
	rlca			;0848
	or b			;0849
	rlca			;084a
	cp d			;084b
	sub 09eh		;084c
	ld d,a			;084e
	ret po			;084f
	ld e,a			;0850
	rst 38h			;0851
	dec c			;0852
	nop			;0853
	ret po			;0854
	ld c,l			;0855
	dec b			;0856
	nop			;0857
	add a,b			;0858
	inc b			;0859
	nop			;085a
l085bh:
	dec b			;085b
	dec b			;085c
	or b			;085d
	daa			;085e
	inc sp			;085f
	or c			;0860
	rlca			;0861
	sbc a,d			;0862
l0863h:
	or 0ffh		;0863
	sbc a,h			;0865
	ld d,(hl)			;0866
	jp m,00d0dh		;0867
	rst 38h			;086a
	ld e,a			;086b
	ret nz			;086c
	inc b			;086d
	inc b			;086e
	dec c			;086f
	nop			;0870
	nop			;0871
	nop			;0872
	nop			;0873
	dec b			;0874
	nop			;0875
	rlca			;0876
	ld b,020h		;0877
	rst 38h			;0879
	rst 38h			;087a
	rst 38h			;087b
	rst 38h			;087c
	rlca			;087d
	jp nc,0b9f8h		;087e
	ld h,a			;0881
	ld c,a			;0882
	ld a,(hl)			;0883
	jp m,0bbfbh		;0884
	ld (hl),a			;0887
	ld a,a			;0888
	rst 18h			;0889
	ret po			;088a
	rst 38h			;088b
	rst 38h			;088c
	rst 38h			;088d
	rst 38h			;088e
	dec c			;088f
	nop			;0890
	jr nz,$+1		;0891
	ld bc,00000h		;0893
	nop			;0896
	jp m,03fffh		;0897
	inc sp			;089a
	nop			;089b
	nop			;089c
	add a,b			;089d
	rst 38h			;089e
	inc b			;089f
	nop			;08a0
	nop			;08a1
	ld b,006h		;08a2
	nop			;08a4
	ld a,e			;08a5
	nop			;08a6
	nop			;08a7
	jp p,0fa01h		;08a8
	ld l,c			;08ab
	rst 38h			;08ac
	rst 38h			;08ad
	rst 0			;08ae
	ld a,e			;08af
	jp m,0ffffh		;08b0
	rst 38h			;08b3
	rst 38h			;08b4
	rst 38h			;08b5
	jp m,05e3dh		;08b6
	xor l			;08b9
	rst 38h			;08ba
	rst 18h			;08bb
	jp m,05af5h		;08bc
	xor e			;08bf
	ld e,a			;08c0
	nop			;08c1
	jp m,0ffffh		;08c2
	rst 38h			;08c5
	ld e,a			;08c6
	nop			;08c7
l08c8h:
	dec b			;08c8
	inc b			;08c9
	rlca			;08ca
	or b			;08cb
	rlca			;08cc
	or b			;08cd
	ld d,a			;08ce
	sbc a,(hl)			;08cf
	sub 0bah		;08d0
	dec c			;08d2
	jp m,0e0ffh		;08d3
	nop			;08d6
	dec c			;08d7
	ret pe			;08d8
	and b			;08d9
	nop			;08da
	inc b			;08db
	add a,b			;08dc
	nop			;08dd
l08deh:
	dec b			;08de
	dec b			;08df
	rlca			;08e0
	or c			;08e1
	inc sp			;08e2
	daa			;08e3
	or b			;08e4
	ld d,(hl)			;08e5
	sbc a,a			;08e6
	rst 38h			;08e7
	add a,09ah		;08e8
	ld e,a			;08ea
	ret po			;08eb
	ret po			;08ec
	rst 38h			;08ed
	jp m,0800ch		;08ee
	add a,b			;08f1
	ret po			;08f2
	nop			;08f3
	nop			;08f4
	nop			;08f5
	nop			;08f6
	and b			;08f7
	nop			;08f8
	rlca			;08f9
	ld b,001h		;08fa
	rst 38h			;08fc
	rst 38h			;08fd
	rst 38h			;08fe
	rst 38h			;08ff
	or b			;0900
	ld e,04fh		;0901
	ld h,a			;0903
	cp c			;0904
	ret m			;0905
	in a,(05fh)		;0906
	ld a,a			;0908
	ld (hl),a			;0909
	cp e			;090a
	ei			;090b
	cp 00dh		;090c
	rst 38h			;090e
	rst 38h			;090f
	rst 38h			;0910
	rst 38h			;0911
	ret po			;0912
	nop			;0913
	ld bc,020ffh		;0914
	nop			;0917
	nop			;0918
l0919h:
	nop			;0919
	ld e,a			;091a
l091bh:
	rst 38h			;091b
	di			;091c
	inc sp			;091d
l091eh:
	nop			;091e
	nop			;091f
	inc b			;0920
	rst 38h			;0921
	add a,b			;0922
	nop			;0923
	nop			;0924
	ld b,006h		;0925
	nop			;0927
	ld a,e			;0928
	nop			;0929
	nop			;092a
	rra			;092b
	jr nz,l098dh		;092c
	ld l,c			;092e
	rst 38h			;092f
	rst 38h			;0930
	cp h			;0931
	ld a,e			;0932
	ld e,a			;0933
	rst 38h			;0934
	rst 38h			;0935
	rst 38h			;0936
	rst 38h			;0937
	rst 38h			;0938
	ld e,a			;0939
	xor l			;093a
	ld e,(hl)			;093b
	dec a			;093c
	rst 38h			;093d
	cp 05fh		;093e
	xor e			;0940
	ld e,d			;0941
	push af			;0942
	jp m,05f00h		;0943
	rst 38h			;0946
	rst 38h			;0947
	rst 38h			;0948
	jp m,l0800h		;0949
	rlca			;094c
	nop			;094d
	nop			;094e
	nop			;094f
	nop			;0950
	nop			;0951
	nop			;0952
	nop			;0953
	nop			;0954
	nop			;0955
	nop			;0956
	nop			;0957
	nop			;0958
	nop			;0959
	nop			;095a
	nop			;095b
	nop			;095c
	nop			;095d
	nop			;095e
	nop			;095f
	nop			;0960
	nop			;0961
	nop			;0962
	nop			;0963
	nop			;0964
	nop			;0965
	nop			;0966
	nop			;0967
	nop			;0968
	nop			;0969
	nop			;096a
	nop			;096b
	nop			;096c
	nop			;096d
	nop			;096e
	nop			;096f
	nop			;0970
	nop			;0971
	nop			;0972
	nop			;0973
	nop			;0974
	nop			;0975
	nop			;0976
	nop			;0977
	nop			;0978
	nop			;0979
	nop			;097a
	nop			;097b
	nop			;097c
	nop			;097d
	nop			;097e
	nop			;097f
	nop			;0980
	nop			;0981
	nop			;0982
	nop			;0983
	nop			;0984
	rlca			;0985
	dec b			;0986
	nop			;0987
	nop			;0988
	jp 0003ch		;0989
	nop			;098c
l098dh:
	sub b			;098d
	ld (bc),a			;098e
	djnz l0997h		;098f
	nop			;0991
	ld b,d			;0992
	jr c,l09d8h		;0993
	jr l0997h		;0995
l0997h:
	ld a,(bc)			;0997
	jr nz,l099bh		;0998
	ld d,b			;099a
l099bh:
	nop			;099b
	jr l091eh		;099c
	inc b			;099e
	ld b,d			;099f
	nop			;09a0
	ld h,b			;09a1
	ld c,b			;09a2
	ld c,b			;09a3
	add hl,bc			;09a4
	nop			;09a5
	nop			;09a6
	inc a			;09a7
	jp l0700h		;09a8
	dec b			;09ab
	nop			;09ac
	nop			;09ad
	inc a			;09ae
	jp 00000h		;09af
	ld b,010h		;09b2
	ld (bc),a			;09b4
	sub b			;09b5
	nop			;09b6
	jr l09fch		;09b7
	jr c,l09fdh		;09b9
	nop			;09bb
	ld d,b			;09bc
	ld bc,00a20h		;09bd
	nop			;09c0
	ld b,d			;09c1
	inc b			;09c2
	add a,b			;09c3
	jr l09c6h		;09c4
l09c6h:
	add hl,bc			;09c6
	ld c,b			;09c7
	ld c,b			;09c8
	ld h,b			;09c9
	nop			;09ca
	nop			;09cb
	jp 0003ch		;09cc
	inc b			;09cf
	ld b,0e8h		;09d0
	inc c			;09d2
	sub b			;09d3
	ld b,020h		;09d4
	inc e			;09d6
	and b			;09d7
l09d8h:
	nop			;09d8
	ld a,(bc)			;09d9
	ld d,b			;09da
	ld d,b			;09db
	and b			;09dc
	and b			;09dd
	nop			;09de
	ld a,(bc)			;09df
	ld d,b			;09e0
	ld d,b			;09e1
	and b			;09e2
	ret po			;09e3
	nop			;09e4
	ld h,b			;09e5
	add hl,bc			;09e6
	add a,b			;09e7
	ld b,e			;09e8
	inc b			;09e9
	ld b,01ch		;09ea
	jr nz,l09f4h		;09ec
	sub b			;09ee
	inc c			;09ef
	ret pe			;09f0
	and b			;09f1
	ld d,b			;09f2
	ld d,b			;09f3
l09f4h:
	ld a,(bc)			;09f4
	nop			;09f5
	and b			;09f6
	and b			;09f7
	ld d,b			;09f8
	ld d,b			;09f9
	ld a,(bc)			;09fa
	nop			;09fb
l09fch:
	and b			;09fc
l09fdh:
	ld b,e			;09fd
	add a,b			;09fe
	add hl,bc			;09ff
	ld h,b			;0a00
	nop			;0a01
	ret po			;0a02
	inc bc			;0a03
	inc b			;0a04
	ld (l0120h),a		;0a05
	inc bc			;0a08
	jr nc,$+86		;0a09
	xor d			;0a0b
	ld d,b			;0a0c
	ld (08964h),a		;0a0d
	ld b,e			;0a10
	inc bc			;0a11
	inc b			;0a12
	inc bc			;0a13
	ld bc,03220h		;0a14
	ld d,b			;0a17
	xor d			;0a18
	ld d,h			;0a19
	jr nc,$+69		;0a1a
	adc a,c			;0a1c
	ld h,h			;0a1d
	ld (00403h),a		;0a1e
	djnz l0a43h		;0a21
	ld bc,06003h		;0a23
	ld d,b			;0a26
	xor d			;0a27
	ld d,b			;0a28
	ld (08965h),a		;0a29
	ld b,e			;0a2c
	inc bc			;0a2d
	inc b			;0a2e
	inc bc			;0a2f
	ld bc,01020h		;0a30
	ld d,b			;0a33
	xor d			;0a34
	ld d,b			;0a35
	ld h,b			;0a36
	ld b,e			;0a37
	adc a,c			;0a38
	ld h,l			;0a39
	ld (00604h),a		;0a3a
	nop			;0a3d
	ld h,b			;0a3e
	ld h,(hl)			;0a3f
	ld h,(hl)			;0a40
	ld b,000h		;0a41
l0a43h:
	sub b			;0a43
	sbc a,c			;0a44
	nop			;0a45
	add hl,bc			;0a46
	sbc a,c			;0a47
	add hl,bc			;0a48
	sub b			;0a49
	sbc a,c			;0a4a
	add hl,bc			;0a4b
	nop			;0a4c
	sbc a,c			;0a4d
	add hl,bc			;0a4e
	nop			;0a4f
	ld h,b			;0a50
	ld h,(hl)			;0a51
	ld h,(hl)			;0a52
	ld b,000h		;0a53
	inc bc			;0a55
	inc b			;0a56
	nop			;0a57
	sbc a,c			;0a58
	sbc a,c			;0a59
	nop			;0a5a
	ld h,b			;0a5b
	add hl,bc			;0a5c
	sub b			;0a5d
	ld b,000h		;0a5e
	sbc a,c			;0a60
	sbc a,c			;0a61
	nop			;0a62
	rlca			;0a63
	ld bc,00845h		;0a64
	inc bc			;0a67
	ld bc,l085bh		;0a68
	ld bc,07637h		;0a6b
	ex af,af'			;0a6e
	nop			;0a6f
	ld b,c			;0a70
	and d			;0a71
	ex af,af'			;0a72
	add a,a			;0a73
	ld bc,l08c8h		;0a74
	add a,e			;0a77
	ld bc,l08deh		;0a78
	add a,c			;0a7b
	scf			;0a7c
	ld sp,hl			;0a7d
	ex af,af'			;0a7e
	add a,b			;0a7f
	ld b,c			;0a80
	dec h			;0a81
	add hl,bc			;0a82
	rlca			;0a83
	ld bc,00845h		;0a84
	inc hl			;0a87
	ld bc,l085bh		;0a88
	ld hl,07634h		;0a8b
	ex af,af'			;0a8e
	jr nz,$+57		;0a8f
	and d			;0a91
	ex af,af'			;0a92
	add a,a			;0a93
	ld bc,l08c8h		;0a94
	and e			;0a97
	ld bc,l08deh		;0a98
	and c			;0a9b
	scf			;0a9c
	ld sp,hl			;0a9d
	ex af,af'			;0a9e
	and b			;0a9f
	ld b,c			;0aa0
	dec h			;0aa1
	add hl,bc			;0aa2
l0aa3h:
	rlca			;0aa3
	ld bc,00845h		;0aa4
	add a,a			;0aa7
	ld bc,l08c8h		;0aa8
	and a			;0aab
	ld bc,l08c8h		;0aac
	daa			;0aaf
	ld bc,00845h		;0ab0
	inc hl			;0ab3
	ld bc,l085bh		;0ab4
	and e			;0ab7
	ld bc,l08deh		;0ab8
l0abbh:
	ld hl,07620h		;0abb
	ex af,af'			;0abe
	and c			;0abf
	jr z,l0abbh		;0ac0
	ex af,af'			;0ac2
	and c			;0ac3
	inc h			;0ac4
	ld sp,hl			;0ac5
	ex af,af'			;0ac6
	ld hl,07624h		;0ac7
	ex af,af'			;0aca
	jr nz,l0afdh		;0acb
	and d			;0acd
	ex af,af'			;0ace
	and b			;0acf
	jr nc,l0af7h		;0ad0
	add hl,bc			;0ad2
	ld hl,07620h		;0ad3
	ex af,af'			;0ad6
l0ad7h:
	rlca			;0ad7
	ld bc,00845h		;0ad8
	and c			;0adb
	jr nz,l0ad7h		;0adc
	ex af,af'			;0ade
	and a			;0adf
	ld bc,l08c8h		;0ae0
	and d			;0ae3
	ex af,af'			;0ae4
	add a,l			;0ae5
	add hl,bc			;0ae6
	dec sp			;0ae7
	ld a,(bc)			;0ae8
	halt			;0ae9
	ex af,af'			;0aea
	rst 8			;0aeb
	add hl,bc			;0aec
	dec sp			;0aed
	ld a,(bc)			;0aee
	ld b,l			;0aef
	ex af,af'			;0af0
	rra			;0af1
	ld a,(bc)			;0af2
	ld d,l			;0af3
	ld a,(bc)			;0af4
	ld e,e			;0af5
	ex af,af'			;0af6
l0af7h:
	inc bc			;0af7
	ld a,(bc)			;0af8
	ld d,l			;0af9
	ld a,(bc)			;0afa
	dec h			;0afb
	add hl,bc			;0afc
l0afdh:
	xor d			;0afd
	add hl,bc			;0afe
	dec sp			;0aff
	ld a,(bc)			;0b00
	ld sp,hl			;0b01
	ex af,af'			;0b02
	jp (hl)			;0b03
	add hl,bc			;0b04
	dec sp			;0b05
	ld a,(bc)			;0b06
	ret z			;0b07
	ex af,af'			;0b08
	dec l			;0b09
	ld a,(bc)			;0b0a
	ld d,l			;0b0b
	ld a,(bc)			;0b0c
	sbc a,008h		;0b0d
	ld de,0550ah		;0b0f
	ld a,(bc)			;0b12
l0b13h:
	djnz l0b26h		;0b13
	nop			;0b15
	ld (de),a			;0b16
	inc de			;0b17
	add a,b			;0b18
l0b19h:
	inc c			;0b19
	dec c			;0b1a
	ld c,013h		;0b1b
	add a,b			;0b1d
l0b1eh:
	inc d			;0b1e
	dec d			;0b1f
	ld d,080h		;0b20
l0b22h:
	inc bc			;0b22
	ld a,(bc)			;0b23
	djnz l0b39h		;0b24
l0b26h:
	ld de,0800ah		;0b26
l0b29h:
	rla			;0b29
	inc de			;0b2a
	jr l0b46h		;0b2b
	ld a,(de)			;0b2d
	inc c			;0b2e
	dec de			;0b2f
	add a,b			;0b30
l0b31h:
	ld a,(bc)			;0b31
	ld a,(bc)			;0b32
l0b33h:
	ld a,(bc)			;0b33
	ld a,(bc)			;0b34
	ld a,(bc)			;0b35
	ld a,(bc)			;0b36
	ld a,(bc)			;0b37
	add a,b			;0b38
l0b39h:
	inc e			;0b39
	dec c			;0b3a
	dec e			;0b3b
	inc e			;0b3c
	inc de			;0b3d
	djnz l0b4ch		;0b3e
	add a,b			;0b40
l0b41h:
	ld a,(de)			;0b41
	add hl,de			;0b42
	djnz l0b51h		;0b43
	add a,b			;0b45
l0b46h:
	ret nz			;0b46
	inc b			;0b47
	ld b,042h		;0b48
	dec b			;0b4a
	ld d,b			;0b4b
l0b4ch:
	dec b			;0b4c
	ld d,b			;0b4d
	jp nz,08006h		;0b4e
l0b51h:
	nop			;0b51
	or b			;0b52
	nop			;0b53
	and b			;0b54
	nop			;0b55
	and b			;0b56
	nop			;0b57
	and b			;0b58
	nop			;0b59
	ret z			;0b5a
	inc c			;0b5b
	ld bc,08050h		;0b5c
	ld b,018h		;0b5f
	nop			;0b61
	call 0c84ch		;0b62
	inc c			;0b65
	ld bc,08050h		;0b66
	inc e			;0b69
	nop			;0b6a
	ld d,b			;0b6b
	ret			;0b6c
	inc e			;0b6d
	nop			;0b6e
	ex af,af'			;0b6f
	add a,b			;0b70
	dec bc			;0b71
	jr $+12		;0b72
	inc sp			;0b74
	dec de			;0b75
	nop			;0b76
	ld a,(bc)			;0b77
	call z,0054ch		;0b78
	nop			;0b7b
	call 0000ch		;0b7c
	ld d,b			;0b7f
	ret			;0b80
	inc e			;0b81
	ret z			;0b82
	inc c			;0b83
	dec b			;0b84
	nop			;0b85
	call l050ch		;0b86
	ld d,b			;0b89
	ret			;0b8a
	inc e			;0b8b
	call z,sub_014ch		;0b8c
	jr $-126		;0b8f
	ld bc,00050h		;0b91
	ld d,b			;0b94
	nop			;0b95
	ret z			;0b96
	inc c			;0b97
	dec b			;0b98
	ld d,b			;0b99
	ret			;0b9a
	inc e			;0b9b
	dec b			;0b9c
	ld d,b			;0b9d
	ret			;0b9e
	inc e			;0b9f
	ret z			;0ba0
	inc c			;0ba1
	dec b			;0ba2
	ld d,b			;0ba3
	ret			;0ba4
	ld e,h			;0ba5
	nop			;0ba6
	ld d,b			;0ba7
	ret z			;0ba8
	inc e			;0ba9
	nop			;0baa
	nop			;0bab
	nop			;0bac
	nop			;0bad
	nop			;0bae
	nop			;0baf
	nop			;0bb0
	nop			;0bb1
	nop			;0bb2
	nop			;0bb3
l0bb4h:
	nop			;0bb4
	nop			;0bb5
	ret p			;0bb6
	nop			;0bb7
	nop			;0bb8
	nop			;0bb9
	ret p			;0bba
	nop			;0bbb
	nop			;0bbc
	nop			;0bbd
	call z,0a04ch		;0bbe
	nop			;0bc1
	and b			;0bc2
	nop			;0bc3
	and b			;0bc4
	nop			;0bc5
	and b			;0bc6
	nop			;0bc7
	ret z			;0bc8
	inc c			;0bc9
	and b			;0bca
	nop			;0bcb
	and b			;0bcc
	nop			;0bcd
	and b			;0bce
	nop			;0bcf
	ret pe			;0bd0
	inc c			;0bd1
	inc b			;0bd2
	ld b,b			;0bd3
	ld b,a			;0bd4
	ld d,(hl)			;0bd5
	and l			;0bd6
	ld d,b			;0bd7
	dec b			;0bd8
	ld d,b			;0bd9
	dec b			;0bda
	ld d,b			;0bdb
	scf			;0bdc
	nop			;0bdd
	rla			;0bde
	nop			;0bdf
	or e			;0be0
	add a,b			;0be1
	nop			;0be2
	add hl,de			;0be3
	add a,b			;0be4
	sub c			;0be5
	ret z			;0be6
	inc c			;0be7
	dec b			;0be8
l0be9h:
	djnz l0bb4h		;0be9
	inc c			;0beb
	nop			;0bec
	ld d,b			;0bed
	ret			;0bee
	inc e			;0bef
	ret nz			;0bf0
	inc c			;0bf1
	ld b,010h		;0bf2
	dec b			;0bf4
	nop			;0bf5
	dec b			;0bf6
	nop			;0bf7
	jp nz,0cc1ch		;0bf8
	inc c			;0bfb
	dec b			;0bfc
	ld d,b			;0bfd
	call 0251ch		;0bfe
	inc b			;0c01
	dec b			;0c02
	ld b,d			;0c03
	call z,0054ch		;0c04
	nop			;0c07
	call sub_0500h		;0c08
	nop			;0c0b
	call 0004ch		;0c0c
	nop			;0c0f
	nop			;0c10
	nop			;0c11
	ld c,h			;0c12
	ret nz			;0c13
	ld l,l			;0c14
	ld a,(bc)			;0c15
	ld l,l			;0c16
	jp nz,00000h		;0c17
	nop			;0c1a
	nop			;0c1b
	ld b,b			;0c1c
	adc a,b			;0c1d
	ld (hl),l			;0c1e
	xor (hl)			;0c1f
	ld d,c			;0c20
	dec hl			;0c21
	nop			;0c22
	nop			;0c23
	nop			;0c24
	nop			;0c25
	ld b,b			;0c26
	ret z			;0c27
	ld d,b			;0c28
	ld c,c			;0c29
	inc e			;0c2a
	ld l,h			;0c2b
	call z,l050ch		;0c2c
	ld d,b			;0c2f
	call sub_051ch		;0c30
	nop			;0c33
	dec b			;0c34
	nop			;0c35
	inc b			;0c36
	ld b,b			;0c37
	ld b,a			;0c38
	ld d,b			;0c39
	dec h			;0c3a
	ld d,h			;0c3b
	dec b			;0c3c
	ld d,d			;0c3d
	dec b			;0c3e
	ld d,b			;0c3f
	ret nz			;0c40
	inc b			;0c41
	ld b,042h		;0c42
	dec b			;0c44
	ld d,b			;0c45
	scf			;0c46
	ld d,e			;0c47
	dec b			;0c48
	ld d,b			;0c49
	inc b			;0c4a
	nop			;0c4b
	dec b			;0c4c
	nop			;0c4d
	dec b			;0c4e
	nop			;0c4f
	dec b			;0c50
	nop			;0c51
	call sub_044ch		;0c52
	ld b,b			;0c55
	add hl,bc			;0c56
	jr l0be9h		;0c57
	ld bc,000a0h		;0c59
	and b			;0c5c
	nop			;0c5d
	inc b			;0c5e
	ld b,b			;0c5f
	dec b			;0c60
	ld d,b			;0c61
	call 0055ch		;0c62
	ld d,b			;0c65
	dec b			;0c66
	ld d,b			;0c67
	ret nz			;0c68
	inc c			;0c69
	ld b,010h		;0c6a
	dec b			;0c6c
	nop			;0c6d
	dec h			;0c6e
	ld d,e			;0c6f
	jp nz,0001ch		;0c70
	ccf			;0c73
	ld a,a			;0c74
	ccf			;0c75
	nop			;0c76
	ret nz			;0c77
	add a,b			;0c78
	ret nz			;0c79
	nop			;0c7a
	ccf			;0c7b
	ld a,a			;0c7c
	ccf			;0c7d
l0c7eh:
	nop			;0c7e
	ret nz			;0c7f
	add a,b			;0c80
	ret nz			;0c81
	nop			;0c82
l0c83h:
	nop			;0c83
	ccf			;0c84
	ld e,a			;0c85
	ld a,a			;0c86
	ld e,a			;0c87
	ccf			;0c88
	nop			;0c89
	ret nz			;0c8a
	add a,b			;0c8b
	nop			;0c8c
	ccf			;0c8d
	ld e,a			;0c8e
	ld a,a			;0c8f
	ld e,a			;0c90
	ccf			;0c91
	nop			;0c92
	ret nz			;0c93
	add a,b			;0c94
	nop			;0c95
	ld e,a			;0c96
	ld a,a			;0c97
	ld e,a			;0c98
	nop			;0c99
	ret nz			;0c9a
	add a,b			;0c9b
	nop			;0c9c
	ld c,a			;0c9d
	ld a,a			;0c9e
	ld c,a			;0c9f
	ret nz			;0ca0
	add a,b			;0ca1
	ld a,a			;0ca2
	add a,b			;0ca3
	ld a,a			;0ca4
	add a,b			;0ca5
l0ca6h:
	nop			;0ca6
	nop			;0ca7
	nop			;0ca8
	ld (bc),a			;0ca9
	nop			;0caa
	nop			;0cab
	jr nz,l0cb3h		;0cac
	call 000c3h		;0cae
	nop			;0cb1
	add a,b			;0cb2
l0cb3h:
	inc a			;0cb3
	ld (05ac2h),a		;0cb4
	add a,b			;0cb7
	nop			;0cb8
	inc h			;0cb9
	ld h,e			;0cba
	ld a,(bc)			;0cbb
	sub b			;0cbc
	sub b			;0cbd
	ld a,d			;0cbe
	ld a,d			;0cbf
	ld (bc),a			;0cc0
	ld b,002h		;0cc1
	ld (bc),a			;0cc3
	inc b			;0cc4
	ld (de),a			;0cc5
	nop			;0cc6
	ld b,(hl)			;0cc7
	ld a,l			;0cc8
	ld bc,0cd14h		;0cc9
	nop			;0ccc
	ld d,c			;0ccd
	ld bc,00000h		;0cce
	nop			;0cd1
	nop			;0cd2
	nop			;0cd3
	nop			;0cd4
	add a,b			;0cd5
	nop			;0cd6
	add a,b			;0cd7
	nop			;0cd8
	jr nz,l0cfbh		;0cd9
	ld hl,l0621h		;0cdb
	defb 0fdh,05ah,0dah	;illegal sequence		;0cde
	call po,0ed51h		;0ce1
	ld e,e			;0ce4
	ld b,000h		;0ce5
	call 05afdh		;0ce7
	jp nc,051e4h		;0cea
	ld de,(05b27h)		;0ced
	call 05afdh		;0cf1
	jr c,l0cf9h		;0cf4
	ld (05b27h),hl		;0cf6
l0cf9h:
	pop de			;0cf9
	pop af			;0cfa
l0cfbh:
	ld (hl),a			;0cfb
	ret			;0cfc
	push hl			;0cfd
	and a			;0cfe
	defb 0edh		;0cff
init:
	ld a,000h
	out (018h),a
	jp l010eh		;0100
