; z80dasm 1.1.6
; command line: z80dasm --labels --origin=0x0100 -a DOGFIGHT.COM

	org	00100h

l0100h:
	jp l0ff1h		;0100
l0103h:
	nop			;0103
	ld sp,01800h		;0104
	ld a,(l0ee4h)		;0107
	ld (l0ee5h),a		;010a
	xor a			;010d
	call 00918h		;010e
	ld a,d			;0111
	ld (l0ee5h),a		;0112
	xor a			;0115
	call 00918h		;0116
	call sub_028eh		;0119
	rla			;011c
	ld d,a			;011d
	ld e,000h		;011e
	ld hl,l0d23h		;0120
	ld bc,00190h		;0123
	call 00b93h		;0126
	ld bc,00190h		;0129
	call 00b93h		;012c
	ld b,003h		;012f
	jr l0136h		;0131
	rst 38h			;0133
	rst 38h			;0134
	rst 38h			;0135
l0136h:
	push bc			;0136
	call sub_0b88h		;0137
	pop bc			;013a
	djnz l0136h		;013b
l013dh:
	in a,(018h)		;013d
	cpl			;013f
	and a			;0140
	jr nz,l013dh		;0141
	call 00918h		;0143
	call 002c3h		;0146
	call 002a0h		;0149
	call 0043ah		;014c
	call 003c0h		;014f
	ld a,(l0ee7h)		;0152
	ld ix,l0ef3h		;0155
	ld b,a			;0159
	rlca			;015a
	rlca			;015b
	and 003h		;015c
	call sub_0728h		;015e
	ld ix,l0ee7h+1		;0161
	ld a,b			;0165
	rrca			;0166
	rrca			;0167
	and 003h		;0168
	call sub_0728h		;016a
	call 006e5h		;016d
	call l049ch+1		;0170
	call sub_073eh		;0173
	call sub_08d9h		;0176
	ld ix,l0ef3h		;0179
	call 006e5h		;017d
	call l049ch+1		;0180
	call sub_073eh		;0183
	call sub_08d9h		;0186
	ld b,00ah		;0189
	ld ix,l0f32h		;018b
	ld iy,l0ef3h		;018f
	ld a,005h		;0193
	cp b			;0195
	jr nz,l019ch		;0196
	ld iy,l0ee7h+1		;0198
l019ch:
	ld h,(ix+006h)		;019c
	ld l,(ix+007h)		;019f
	ld a,(ix+008h)		;01a2
	or 080h		;01a5
	ld (000a8h),a		;01a7
	rlc b		;01aa
	ld a,030h		;01ac
	cp (ix+005h)		;01ae
	jr z,l01feh		;01b1
	inc (ix+005h)		;01b3
	push ix		;01b6
	pop hl			;01b8
	inc hl			;01b9
	inc hl			;01ba
	call 0038dh		;01bb
	ld (l0f0eh),a		;01be
	ld a,(ix+000h)		;01c1
	ld (l0f0dh),a		;01c4
	push bc			;01c7
	ld c,000h		;01c8
	ld d,c			;01ca
	call 008abh		;01cb
	ld (ix+006h),b		;01ce
	ld (ix+007h),c		;01d1
	push bc			;01d4
	xor a			;01d5
	ld b,(ix+000h)		;01d6
	ld c,(ix+001h)		;01d9
	rr b		;01dc
	rr b		;01de
	rla			;01e0
	rr c		;01e1
	rla			;01e3
	rl b		;01e4
	rla			;01e6
	rla			;01e7
	rla			;01e8
	rla			;01e9
	or 006h		;01ea
	ld (ix+008h),a		;01ec
	pop hl			;01ef
l01f0h:
	call 00316h		;01f0
	ld a,(ix+008h)		;01f3
	or 0c0h		;01f6
	ld (000f9h),a		;01f8
	rlc b		;01fb
	pop bc			;01fd
l01feh:
	ld de,00009h		;01fe
	add ix,de		;0201
	djnz l0207h		;0203
	jr l020ah		;0205
l0207h:
	jp 00090h		;0207
l020ah:
	ld a,(l0ee7h)		;020a
	ld e,a			;020d
	ld a,(l0f03h)		;020e
	cp 00ah		;0211
	jr nz,l0230h		;0213
	bit 0,e		;0215
	jr z,l0234h		;0217
	ld a,(l0f05h)		;0219
	ld iy,l0ee7h+1		;021c
	ld ix,l0f32h		;0220
	call 0033dh		;0224
	ld (l0f05h),a		;0227
	xor a			;022a
	ld (l0f03h),a		;022b
	jr l0234h		;022e
l0230h:
	inc a			;0230
	ld (l0f03h),a		;0231
l0234h:
	ld a,(l0f04h)		;0234
	cp 00ah		;0237
	jr nz,l0256h		;0239
	bit 4,e		;023b
	jr z,l025ah		;023d
	ld ix,l0f5fh		;023f
	ld a,(l0f06h)		;0243
	ld iy,l0ef3h		;0246
	call 0033dh		;024a
	ld (l0f06h),a		;024d
	xor a			;0250
	ld (l0f04h),a		;0251
	jr l025ah		;0254
l0256h:
	inc a			;0256
	ld (l0f04h),a		;0257
l025ah:
	ld hl,l0ee6h		;025a
	bit 2,(hl)		;025d
	jr z,l0269h		;025f
	xor a			;0261
	call 00918h		;0262
	res 2,(hl)		;0265
	set 6,(hl)		;0267
l0269h:
	ld a,(l0ee7h+1)		;0269
	bit 7,a		;026c
	jr z,$+26		;026e
	bit 4,(hl)		;0270
	jr nz,$+22		;0272
	set 6,(hl)		;0274
	set 4,(hl)		;0276
	set 2,(hl)		;0278
	ld (l0f21h),a		;027a
	ld a,(l0ee9h)		;027d
	ld (l0f22h),a		;0280
	call 0090bh		;0283
	xor a			;0286
	call 00b9ch		;0287
	bit 3,(hl)		;028a
	jr z,l0296h		;028c
sub_028eh:
	xor a			;028e
	call 00918h		;028f
	res 3,(hl)		;0292
	set 6,(hl)		;0294
l0296h:
	ld a,(l0ef3h)		;0296
	bit 7,a		;0299
	jr z,$+26		;029b
	bit 5,(hl)		;029d
	jr nz,$+22		;029f
	set 6,(hl)		;02a1
	set 5,(hl)		;02a3
	set 3,(hl)		;02a5
	ld (l0f23h),a		;02a7
sub_02aah:
	ld a,(l0ef4h)		;02aa
	ld (l0f24h),a		;02ad
	call 008feh		;02b0
	inc a			;02b3
	call 00b9ch		;02b4
	ld de,00000h		;02b7
	ld hl,l0ee6h		;02ba
	ld a,d			;02bd
	ld (l0f1fh),a		;02be
	ld a,(l0f25h)		;02c1
	ld b,a			;02c4
	ld a,(l0efdh)		;02c5
	cp b			;02c8
	jr c,l02d1h		;02c9
	ld a,(l0ef2h)		;02cb
	call l0230h		;02ce
l02d1h:
	ld b,a			;02d1
	ld a,(l0f28h)		;02d2
	cp b			;02d5
	jr nc,l02e0h		;02d6
	inc a			;02d8
	ld (l0f28h),a		;02d9
	set 1,(hl)		;02dc
	jr l02e7h		;02de
l02e0h:
	ld c,a			;02e0
	ld a,(hl)			;02e1
	and 040h		;02e2
	jr z,l02eah		;02e4
	ld a,c			;02e6
l02e7h:
	call sub_0b34h		;02e7
l02eah:
	ld de,l0100h		;02ea
	ld hl,l0ee6h		;02ed
	ld a,d			;02f0
	ld (l0f1fh),a		;02f1
	ld a,(l0f25h)		;02f4
	ld b,a			;02f7
	ld a,(l0ef2h)		;02f8
	cp b			;02fb
	jr c,l0304h		;02fc
	ld a,(l0efdh)		;02fe
	call l0230h		;0301
l0304h:
	ld b,a			;0304
	ld a,(l0f29h)		;0305
	cp b			;0308
	jr nc,l0313h		;0309
	inc a			;030b
	ld (l0f29h),a		;030c
	set 1,(hl)		;030f
	jr l031ch		;0311
l0313h:
	ld c,a			;0313
	ld a,(hl)			;0314
	and 040h		;0315
	jr z,l031fh		;0317
	res 6,(hl)		;0319
	ld a,c			;031b
l031ch:
	call sub_0b34h		;031c
l031fh:
	ld a,(l0ee6h)		;031f
	ld c,a			;0322
	and 003h		;0323
	jr z,l032ah		;0325
	call sub_02aah		;0327
l032ah:
	ld a,c			;032a
	and 0bch		;032b
	ld (l0ee6h),a		;032d
	jp 00049h		;0330
	sub b			;0333
	neg		;0334
	cp 002h		;0336
	jr nc,l0341h		;0338
	ld a,b			;033a
	inc a			;033b
	ld (l0f25h),a		;033c
	dec a			;033f
	ret			;0340
l0341h:
	pop hl			;0341
	neg		;0342
	add a,b			;0344
	ld (l0f02h),a		;0345
	call sub_028eh		;0348
	xor a			;034b
	call 00918h		;034c
	ld e,a			;034f
	ld a,(l0ee5h)		;0350
	ld d,a			;0353
	ld hl,00e03h		;0354
	ld bc,00190h		;0357
	call 00b93h		;035a
	ld bc,00190h		;035d
	call 00b93h		;0360
	ld a,(l0f1fh)		;0363
	xor 001h		;0366
	ld d,a			;0368
	ld a,(l0f02h)		;0369
	call sub_0b34h		;036c
l036fh:
	ld a,(l0f1fh)		;036f
	ld d,a			;0372
	ld e,b			;0373
	ld a,(l0f25h)		;0374
	call sub_0b34h		;0377
	call sub_0b88h		;037a
	ld a,(l0f1fh)		;037d
sub_0380h:
	ld d,a			;0380
	ld a,0aah		;0381
	call sub_0b42h		;0383
	call sub_0b88h		;0386
	in a,(018h)		;0389
	and a			;038b
	jr nz,l036fh		;038c
	jp 00001h		;038e
	exx			;0391
	ld c,00eh		;0392
	ld e,06fh		;0394
	ld l,030h		;0396
	ld a,(l0ee4h)		;0398
	rrca			;039b
	or 080h		;039c
	ld d,a			;039e
	add a,004h		;039f
	ld h,a			;03a1
	exx			;03a2
	exx			;03a3
	out (c),h		;03a4
	inc c			;03a6
	out (c),l		;03a7
	dec c			;03a9
	ex de,hl			;03aa
	exx			;03ab
	ret			;03ac
	ld b,060h		;03ad
l03afh:
	in a,(00eh)		;03af
	and 040h		;03b1
	jr z,l03afh		;03b3
	ld a,0bfh		;03b5
l03b7h:
	dec a			;03b7
	jr nz,l03b7h		;03b8
	call 002a0h		;03ba
l03bdh:
	in a,(00eh)		;03bd
	and 040h		;03bf
	jr nz,l03bdh		;03c1
	djnz l03afh		;03c3
	ret			;03c5
	ld a,015h		;03c6
	ld (l0f25h),a		;03c8
	ld a,080h		;03cb
	ld (l0ee9h),a		;03cd
	ld (l0ef4h),a		;03d0
	ld a,030h		;03d3
	ld bc,00a06h		;03d5
	ld de,00006h		;03d8
	ld hl,l0f37h		;03db
l03deh:
	ld (hl),a			;03de
	inc hl			;03df
	push af			;03e0
	xor a			;03e1
	ld (hl),a			;03e2
	inc hl			;03e3
	ld (hl),a			;03e4
	pop af			;03e5
	inc hl			;03e6
	ld (hl),c			;03e7
	add hl,de			;03e8
	djnz l03deh		;03e9
	ld hl,l0f03h		;03eb
	ld a,00ah		;03ee
	ld (hl),a			;03f0
	inc hl			;03f1
	ld (hl),a			;03f2
	inc hl			;03f3
	xor a			;03f4
	ld (l0f2ah),a		;03f5
	ld (l0f2bh),a		;03f8
	ld (l0f02h),a		;03fb
	ld (l0efdh),a		;03fe
	ld (l0ef2h),a		;0401
	ld (l0f28h),a		;0404
	ld (l0f29h),a		;0407
	ld b,004h		;040a
l040ch:
	ld (hl),a			;040c
	inc hl			;040d
	djnz l040ch		;040e
	ld a,040h		;0410
	ld (l0ee6h),a		;0412
	ld (l0f27h),a		;0415
	ret			;0418
	ld a,(iy+000h)		;0419
	ld (l0f0dh),a		;041c
	ld a,(iy+001h)		;041f
	ld (l0f0eh),a		;0422
	ld c,000h		;0425
	ld d,c			;0427
	push hl			;0428
	call 008abh		;0429
	pop hl			;042c
	ld a,c			;042d
	cp l			;042e
	ret nz			;042f
	ld a,b			;0430
	cp h			;0431
	ret nz			;0432
	set 7,(iy+000h)		;0433
	ld (iy+007h),060h		;0437
	ld (iy+005h),000h		;043b
	ret			;043f
	ld c,a			;0440
	xor a			;0441
	ld b,a			;0442
	add ix,bc		;0443
	push bc			;0445
	ld (ix+005h),b		;0446
	ld a,(iy+000h)		;0449
	ld (ix+000h),a		;044c
	ld a,(iy+001h)		;044f
	and 07fh		;0452
	ld (ix+001h),a		;0454
	ld a,(iy+007h)		;0457
	call 005edh		;045a
	ld a,c			;045d
	call sub_0380h		;045e
	neg		;0461
	ld (ix+004h),a		;0463
	ld a,b			;0466
	call sub_0380h		;0467
	bit 0,(iy+002h)		;046a
	jr z,l0472h		;046e
	neg		;0470
l0472h:
	ld (ix+003h),a		;0472
	ld (ix+008h),006h		;0475
	pop bc			;0479
	ld a,009h		;047a
	add a,c			;047c
	cp 02dh		;047d
	jr nz,l0482h		;047f
	xor a			;0481
l0482h:
	ret			;0482
	rrca			;0483
	rrca			;0484
	rrca			;0485
	bit 4,a		;0486
	jr z,l048dh		;0488
	or 0e0h		;048a
sub_048ch:
	ret			;048c
l048dh:
	and 01fh		;048d
	ret			;048f
	xor a			;0490
	rld		;0491
	add a,(ix+003h)		;0493
	rrd		;0496
	sra a		;0498
	sra a		;049a
l049ch:
	sra a		;049c
	sra a		;049e
	add a,(ix+000h)		;04a0
	ld (ix+000h),a		;04a3
	xor a			;04a6
	rrd		;04a7
	add a,(ix+004h)		;04a9
	rld		;04ac
	sra a		;04ae
	sra a		;04b0
	sra a		;04b2
	sra a		;04b4
	add a,(ix+001h)		;04b6
	inc hl			;04b9
	inc hl			;04ba
	inc hl			;04bb
	ld (ix+001h),a		;04bc
	ret p			;04bf
	ld (hl),030h		;04c0
	ret			;04c2
l04c3h:
	ld a,(l0ee7h+1)		;04c3
	ld b,a			;04c6
	ld a,(l0ef3h)		;04c7
	ld c,a			;04ca
	in a,(018h)		;04cb
	cpl			;04cd
	bit 7,c		;04ce
	jr z,l04d4h		;04d0
	and 00fh		;04d2
l04d4h:
	bit 7,b		;04d4
	jr z,l04dah		;04d6
	and 0f0h		;04d8
l04dah:
	ld (l0ee7h),a		;04da
	ld d,a			;04dd
	in a,(01ah)		;04de
	neg		;04e0
	bit 7,b		;04e2
	jr z,l04e7h		;04e4
	xor a			;04e6
l04e7h:
	ld (l0ef0h),a		;04e7
	in a,(01ch)		;04ea
	neg		;04ec
	bit 7,c		;04ee
	jr z,l04f3h		;04f0
	xor a			;04f2
l04f3h:
	ld (00efbh),a		;04f3
	ld a,(l0f2ah)		;04f6
	cp 040h		;04f9
	jr nz,l0515h		;04fb
l04fdh:
	ld a,(l0eefh)		;04fd
	ld b,a			;0500
	ld a,(l0eeah)		;0501
	and 001h		;0504
	bit 1,d		;0506
	ld e,03fh		;0508
	call nz,006d8h		;050a
	ld (l0eeah),a		;050d
	ld a,b			;0510
	ld (l0eefh),a		;0511
	ld a,e			;0514
l0515h:
	inc a			;0515
	ld (l0f2ah),a		;0516
	ld a,(l0f2bh)		;0519
	cp 040h		;051c
	jr nz,l0538h		;051e
	ld a,(00efah)		;0520
	ld b,a			;0523
	ld a,(l0ef5h)		;0524
	and 001h		;0527
	ld e,03fh		;0529
	bit 5,d		;052b
	call nz,006d8h		;052d
	ld (l0ef5h),a		;0530
	ld a,b			;0533
	ld (00efah),a		;0534
	ld a,e			;0537
l0538h:
	inc a			;0538
	ld (l0f2bh),a		;0539
	ret			;053c
	in a,(018h)		;053d
	and a			;053f
	jr nz,l0559h		;0540
	in a,(019h)		;0542
	and 0c0h		;0544
	cp 080h		;0546
	jr nz,l0559h		;0548
	in a,(01bh)		;054a
	and 0c0h		;054c
	cp 080h		;054e
	jr nz,l0559h		;0550
	ld a,(l0f27h)		;0552
	dec a			;0555
	ld (l0f27h),a		;0556
l0559h:
	jp z,00001h		;0559
	ld ix,l0ee6h		;055c
	ld hl,l0ee7h+1		;0560
	bit 7,(hl)		;0563
	jr nz,l056bh		;0565
	res 4,(ix+000h)		;0567
l056bh:
	ld a,(l0ee9h)		;056b
	and a			;056e
	jp p,00476h		;056f
	ld a,006h		;0572
	ld e,000h		;0574
	call sub_048ch		;0576
	ld hl,l0ef3h		;0579
l057ch:
	bit 7,(hl)		;057c
	jr nz,l0584h		;057e
	res 5,(ix+000h)		;0580
l0584h:
	ld a,(l0ef4h)		;0584
	and a			;0587
	jp p,l049ch		;0588
	ld a,079h		;058b
	ld e,001h		;058d
	ld (hl),a			;058f
	inc hl			;0590
	ld bc,l057ch		;0591
	ld (hl),c			;0594
	inc hl			;0595
	ld (hl),e			;0596
	xor a			;0597
	ld (l0f02h),a		;0598
l059bh:
	inc hl			;059b
	ld (hl),a			;059c
	djnz l059bh		;059d
	ret			;059f
	ld hl,l0efeh		;05a0
	ld iy,l0efeh		;05a3
	xor a			;05a7
	ld (l0effh),a		;05a8
	ld a,(ix+005h)		;05ab
	and a			;05ae
	jp p,004b1h		;05af
	neg		;05b2
	ld d,a			;05b4
	sla a		;05b5
	ld c,a			;05b7
	call sub_061eh		;05b8
	ld e,a			;05bb
	ld a,(ix+006h)		;05bc
	ld b,a			;05bf
	and a			;05c0
	jp p,l04c3h		;05c1
	neg		;05c4
	ld d,a			;05c6
	sla a		;05c7
	ld c,a			;05c9
	call sub_061eh		;05ca
	add a,e			;05cd
	call pe,sub_05e4h		;05ce
	ld (hl),a			;05d1
	ld c,(ix+005h)		;05d2
	call sub_0646h		;05d5
	call 005edh		;05d8
	ld e,d			;05db
	push bc			;05dc
	ld a,(ix+007h)		;05dd
	call 005edh		;05e0
	push bc			;05e3
sub_05e4h:
	ld a,d			;05e4
	sub e			;05e5
	call 005edh		;05e6
	and a			;05e9
l05eah:
	ld e,(hl)			;05ea
	jp m,l04fdh		;05eb
	ld d,a			;05ee
	ld c,01ch		;05ef
	call sub_061eh		;05f1
	sla a		;05f4
	ld c,a			;05f6
	ld d,e			;05f7
	call sub_061eh		;05f8
l05fbh:
	sla a		;05fb
	ld (l0effh),a		;05fd
	ld c,012h		;0600
	ld d,e			;0602
l0603h:
	call sub_061eh		;0603
	sla a		;0606
	ld (l0f00h),a		;0608
	pop de			;060b
	ld b,d			;060c
	ld c,(iy+001h)		;060d
	call sub_061eh		;0610
	ld (hl),a			;0613
	ld c,(ix+009h)		;0614
	ld d,b			;0617
	call sub_061eh		;0618
	ld (l0f01h),a		;061b
sub_061eh:
	ld d,e			;061e
	call sub_061eh		;061f
	add a,(hl)			;0622
	call pe,sub_05e4h		;0623
	ld (hl),a			;0626
	ld d,e			;0627
	ld c,(iy+001h)		;0628
	call sub_061eh		;062b
	neg		;062e
	add a,(iy+003h)		;0630
	call pe,sub_05e4h		;0633
	ld (l0f01h),a		;0636
	pop de			;0639
	ld c,(iy+002h)		;063a
	ld b,c			;063d
	call sub_061eh		;063e
	neg		;0641
	add a,(iy+003h)		;0643
sub_0646h:
	call pe,sub_05e4h		;0646
	add a,(ix+005h)		;0649
	call pe,sub_05e4h		;064c
	ld (ix+005h),a		;064f
	ld d,e			;0652
	ld c,b			;0653
	call sub_061eh		;0654
	neg		;0657
l0659h:
	add a,(hl)			;0659
	call pe,sub_05e4h		;065a
	sub 001h		;065d
	call pe,sub_05e4h		;065f
	ld b,a			;0662
	xor a			;0663
	cp (ix+006h)		;0664
	jr nz,l067ah		;0667
	ld a,(ix+001h)		;0669
	cp 07ch		;066c
	jr nz,l067ah		;066e
	bit 7,b		;0670
	jr z,l067ah		;0672
	res 7,(ix+000h)		;0674
	ld b,000h		;0678
l067ah:
	ld a,b			;067a
	add a,(ix+006h)		;067b
	call pe,sub_05e4h		;067e
	ld (ix+006h),a		;0681
l0684h:
	ld a,(ix+005h)		;0684
	bit 0,(ix+002h)		;0687
	jr z,l068fh		;068b
	neg		;068d
l068fh:
	ld c,a			;068f
	ld b,000h		;0690
	ld h,(ix+000h)		;0692
	ld l,(ix+003h)		;0695
	rl h		;0698
	rra			;069a
	rr h		;069b
	bit 7,c		;069d
	jr z,l06a3h		;069f
	ld b,0ffh		;06a1
l06a3h:
	add hl,bc			;06a3
	or 07fh		;06a4
	ld b,a			;06a6
sub_06a7h:
	ld a,h			;06a7
	or 080h		;06a8
	and b			;06aa
	ld (ix+000h),a		;06ab
	ld (ix+003h),l		;06ae
	ld b,0ffh		;06b1
	ld h,(ix+001h)		;06b3
	ld l,(ix+004h)		;06b6
	ld a,(ix+006h)		;06b9
	neg		;06bc
	ld c,a			;06be
	bit 7,c		;06bf
	jr nz,l06c5h		;06c1
	ld b,000h		;06c3
l06c5h:
	rl h		;06c5
	rra			;06c7
	and a			;06c8
	rr h		;06c9
	adc hl,bc		;06cb
	jp p,005d6h		;06cd
	set 7,a		;06d0
	bit 0,b		;06d2
	jr nz,l06d9h		;06d4
	inc (ix+00ah)		;06d6
l06d9h:
	or 07fh		;06d9
	ld b,a			;06db
	ld a,h			;06dc
	or 080h		;06dd
	and b			;06df
	ld (ix+001h),a		;06e0
	ld (ix+004h),l		;06e3
	ret			;06e6
	jp p,l05eah		;06e7
	ld a,07fh		;06ea
	ret			;06ec
	ld a,081h		;06ed
	ret			;06ef
	push ix		;06f0
	ld ix,l0bb7h		;06f2
	ld d,a			;06f6
	and 03fh		;06f7
	ld (l05fbh),a		;06f9
	ld c,(ix+000h)		;06fc
	xor 020h		;06ff
	ld (l0603h),a		;0701
l0704h:
	ld b,(ix+000h)		;0704
	pop ix		;0707
	ld a,c			;0709
	bit 6,d		;070a
	jr z,l0719h		;070c
	neg		;070e
	ld c,a			;0710
	ld a,b			;0711
	bit 5,d		;0712
	ret nz			;0714
	neg		;0715
	ld b,a			;0717
	ret			;0718
l0719h:
	ld a,b			;0719
	bit 5,d		;071a
	ret z			;071c
	neg		;071d
	ld b,a			;071f
	ret			;0720
	push bc			;0721
	res 7,(iy+004h)		;0722
	ld a,d			;0726
	and a			;0727
sub_0728h:
	jp p,0062fh		;0728
	neg		;072b
	ld d,a			;072d
	set 7,(iy+004h)		;072e
	xor a			;0732
	ld b,008h		;0733
l0735h:
	srl a		;0735
	srl c		;0737
	jr nc,l073ch		;0739
	add a,d			;073b
l073ch:
	djnz l0735h		;073c
sub_073eh:
	srl a		;073e
	bit 7,(iy+004h)		;0740
	pop bc			;0744
	ret z			;0745
	neg		;0746
	ret			;0748
	push bc			;0749
	ld a,b			;074a
	and a			;074b
	jp z,00694h		;074c
	jp p,00651h		;074f
	neg		;0752
	ld d,a			;0754
	ld a,c			;0755
	and a			;0756
	jp p,l0659h		;0757
	neg		;075a
	ld c,a			;075c
	xor a			;075d
	ld b,008h		;075e
	sla d		;0760
	sub c			;0762
l0763h:
	jp m,0066ah		;0763
	scf			;0766
	rl d		;0767
	rla			;0769
	sub c			;076a
	jr l0772h		;076b
	and a			;076d
	rl d		;076e
	rla			;0770
	add a,c			;0771
l0772h:
	djnz l0763h		;0772
	push af			;0774
	and 0f0h		;0775
	jr nz,l0792h		;0777
	pop af			;0779
	ld b,004h		;077a
l077ch:
	jp m,l0684h		;077c
	scf			;077f
	rl d		;0780
	sla a		;0782
	sub c			;0784
	jr l078dh		;0785
	and a			;0787
	rl d		;0788
	sla a		;078a
	add a,c			;078c
l078dh:
	djnz l077ch		;078d
	ld a,d			;078f
	jr l0798h		;0790
l0792h:
	pop af			;0792
	ld a,0ffh		;0793
	jr l0798h		;0795
	xor a			;0797
l0798h:
	push hl			;0798
	call sub_06a7h		;0799
	pop hl			;079c
	pop bc			;079d
	bit 7,c		;079e
	jr z,l07a4h		;07a0
	or 020h		;07a2
l07a4h:
	bit 7,b		;07a4
	ret z			;07a6
	xor 060h		;07a7
	ret			;07a9
	ld hl,l0bf7h		;07aa
	cp 0dah		;07ad
	jr c,l07b3h		;07af
	ld a,(hl)			;07b1
	ret			;07b2
l07b3h:
	inc hl			;07b3
	cp 082h		;07b4
	jr c,l07bah		;07b6
	ld a,(hl)			;07b8
	ret			;07b9
l07bah:
	inc hl			;07ba
	cp 05dh		;07bb
	jr c,l07c1h		;07bd
	ld a,(hl)			;07bf
	ret			;07c0
l07c1h:
	inc hl			;07c1
	cp 048h		;07c2
	jr c,l07c8h		;07c4
	ld a,(hl)			;07c6
	ret			;07c7
l07c8h:
	inc hl			;07c8
	cp 03ah		;07c9
	jr c,l07cfh		;07cb
	ld a,(hl)			;07cd
	ret			;07ce
l07cfh:
	inc hl			;07cf
	cp 031h		;07d0
	jr c,l07d6h		;07d2
	ld a,(hl)			;07d4
	ret			;07d5
l07d6h:
	inc hl			;07d6
	add a,l			;07d7
	ld l,a			;07d8
	ld a,(hl)			;07d9
	ret			;07da
	xor 001h		;07db
	ld c,a			;07dd
	ld a,040h		;07de
	sub b			;07e0
	and 07fh		;07e1
	ld b,a			;07e3
	ld a,c			;07e4
	ld e,0ffh		;07e5
	ret			;07e7
	ld a,(l0f02h)		;07e8
	and 00fh		;07eb
	inc a			;07ed
	cp 005h		;07ee
	ld (l0f02h),a		;07f0
	jr nz,l080ch		;07f3
	xor a			;07f5
	ld (l0f02h),a		;07f6
	ld a,(ix+008h)		;07f9
	and a			;07fc
sub_07fdh:
	rlca			;07fd
	rlca			;07fe
l07ffh:
	rlca			;07ff
	jp m,l0704h		;0800
	and 003h		;0803
	jr l080dh		;0805
	or 0f8h		;0807
	inc a			;0809
	jr l080dh		;080a
l080ch:
	xor a			;080c
l080dh:
	add a,(ix+007h)		;080d
	ld (ix+007h),a		;0810
	add a,018h		;0813
	ld b,a			;0815
	rrca			;0816
	rrca			;0817
	and 00ch		;0818
	rlc b		;081a
	rlc b		;081c
	jr nc,l0822h		;081e
sub_0820h:
	or 002h		;0820
l0822h:
	ld b,a			;0822
	ld a,(ix+002h)		;0823
	or b			;0826
	ld (ix+002h),a		;0827
	ret			;082a
	ld (ix+009h),000h		;082b
	ret z			;082f
	dec a			;0830
	ld (ix+009h),009h		;0831
	ret z			;0835
	dec a			;0836
	ld (ix+009h),005h		;0837
	ret z			;083b
	ld (ix+009h),020h		;083c
	ret			;0840
	ld hl,l0c2eh		;0841
	ld a,(ix+002h)		;0844
	and 00fh		;0847
	ld (l0f0fh),a		;0849
	add a,l			;084c
	ld l,a			;084d
	ld a,000h		;084e
	adc a,h			;0850
	ld h,a			;0851
sub_0852h:
	xor a			;0852
	ld b,(ix+000h)		;0853
	rld		;0856
	ld c,a			;0858
	and a			;0859
	jr z,l085eh		;085a
	or 0f0h		;085c
l085eh:
	add a,b			;085e
	ld (l0f09h),a		;085f
	ld a,c			;0862
	rrd		;0863
	xor a			;0865
	rrd		;0866
	ld c,a			;0868
	ld b,(ix+001h)		;0869
	bit 3,a		;086c
	jr z,l0872h		;086e
	or 0f0h		;0870
l0872h:
	add a,b			;0872
	ld (l0f0ah),a		;0873
	ld a,c			;0876
sub_0877h:
	rld		;0877
	ld hl,l0f0bh		;0879
	ld de,l0f0dh		;087c
	ldi		;087f
	ldi		;0881
	xor a			;0883
l0884h:
	ld hl,l0f2ch		;0884
	ld (hl),a			;0887
	inc hl			;0888
	ex de,hl			;0889
	ld hl,l0f2ch		;088a
	ld bc,00005h		;088d
	ldir		;0890
	call sub_07fdh		;0892
	ld hl,l0f07h		;0895
	ld de,l0f0bh		;0898
	ldi		;089b
sub_089dh:
	ldi		;089d
	ldi		;089f
	ldd		;08a1
	ld de,l0f07h		;08a3
	ldi		;08a6
	ldi		;08a8
	ld a,(l0f0fh)		;08aa
	and 00ch		;08ad
	ld bc,00c3fh		;08af
	jr z,l08c5h		;08b2
	sub 004h		;08b4
	ld bc,l0c45h		;08b6
	jr z,l08c5h		;08b9
	sub 004h		;08bb
	ld bc,l0c4bh		;08bd
	jr z,l08c5h		;08c0
	ld bc,00c51h		;08c2
l08c5h:
	ld hl,l0f0eh		;08c5
	bit 0,(hl)		;08c8
	jr z,l08cdh		;08ca
	dec bc			;08cc
l08cdh:
	ld (l0f10h),bc		;08cd
	ld a,(l0f0fh)		;08d1
	and 003h		;08d4
	call z,sub_0852h		;08d6
sub_08d9h:
	jr z,l08eah		;08d9
	dec a			;08db
	call z,l085eh		;08dc
	jr z,l08eah		;08df
	dec a			;08e1
	call z,sub_0877h		;08e2
	jr z,l08eah		;08e5
	call 00864h		;08e7
l08eah:
	ld a,(l0f0dh)		;08ea
	and 003h		;08ed
	jr z,l0900h		;08ef
	call sub_089dh		;08f1
	dec a			;08f4
	jr z,l0900h		;08f5
	call sub_089dh		;08f7
	dec a			;08fa
	jr z,l0900h		;08fb
	call sub_089dh		;08fd
l0900h:
	ld c,000h		;0900
	ld d,c			;0902
	call 008abh		;0903
	ld hl,l0f2ch		;0906
	call sub_0820h		;0909
	ld c,000h		;090c
	ld d,002h		;090e
	call 008abh		;0910
	ld hl,l0f2eh		;0913
	call sub_0820h		;0916
	ld c,000h		;0919
	ld d,004h		;091b
	call 008abh		;091d
	ld hl,l0f30h		;0920
	push de			;0923
	ld d,(hl)			;0924
	inc hl			;0925
	ld e,(hl)			;0926
	call 00839h		;0927
	ld (bc),a			;092a
	call 00839h		;092b
	ld (l0f12h),a		;092e
	ld c,004h		;0931
	pop de			;0933
	call 008abh		;0934
	ld a,(l0f12h)		;0937
	ld (bc),a			;093a
	ret			;093b
	rl d		;093c
	rra			;093e
	rl d		;093f
	rra			;0941
	rl e		;0942
	rra			;0944
	rl e		;0945
	rra			;0947
	rl d		;0948
	rra			;094a
	rl d		;094b
	rra			;094d
	rl e		;094e
	rra			;0950
	rl e		;0951
	rra			;0953
	ret			;0954
	ld hl,(l0f10h)		;0955
	ld bc,00006h		;0958
	ld de,l0f2ch		;095b
	ldir		;095e
	ret			;0960
	call sub_0852h		;0961
	jp 0087ah		;0964
	ld hl,(l0f10h)		;0967
	ld bc,00006h		;096a
	ld de,l0f2ch		;096d
	add hl,bc			;0970
	dec hl			;0971
	ldi		;0972
	dec hl			;0974
	dec hl			;0975
	jp pe,0086fh		;0976
	ret			;0979
	call 00864h		;097a
	push af			;097d
	ld bc,00006h		;097e
	ld de,l0f2ch		;0981
	ld hl,l0f2ch		;0984
	xor a			;0987
	ld b,(hl)			;0988
	ex af,af'			;0989
	ld a,008h		;098a
l098ch:
	ex af,af'			;098c
	rl b		;098d
	rra			;098f
	ex af,af'			;0990
	dec a			;0991
	jr nz,l098ch		;0992
	ex af,af'			;0994
	rlca			;0995
	rlca			;0996
	rlca			;0997
	ld (hl),a			;0998
	ldi		;0999
	jp pe,l0884h		;099b
	pop af			;099e
	ret			;099f
	push af			;09a0
	ld b,006h		;09a1
	ld hl,l0f2ch		;09a3
l09a6h:
	ld a,(hl)			;09a6
	rrca			;09a7
	ld (hl),a			;09a8
	inc hl			;09a9
	djnz l09a6h		;09aa
	pop af			;09ac
	ret			;09ad
	ld hl,l0ee4h		;09ae
	ld b,(hl)			;09b1
	ld a,(l0f0dh)		;09b2
	add a,c			;09b5
	rrca			;09b6
	rrca			;09b7
	ld e,a			;09b8
	and 00fh		;09b9
	ld c,a			;09bb
	ld a,e			;09bc
	rrca			;09bd
	rrca			;09be
	rrca			;09bf
	and 002h		;09c0
	or b			;09c2
	ld b,a			;09c3
	ld a,(l0f0eh)		;09c4
	add a,d			;09c7
	rlca			;09c8
	rlca			;09c9
	rlca			;09ca
	ld e,a			;09cb
	and 0f0h		;09cc
	or c			;09ce
	ld c,a			;09cf
	ld a,e			;09d0
	and 001h		;09d1
	or b			;09d3
	ld b,a			;09d4
	ld a,e			;09d5
	rlca			;09d6
	and 004h		;09d7
	or b			;09d9
	ld b,a			;09da
	ret			;09db
	ld a,(l0ee4h)		;09dc
	ld hl,005f0h		;09df
	add a,h			;09e2
	ld h,a			;09e3
	ld a,(l0ee3h)		;09e4
	ld (hl),a			;09e7
	ld d,h			;09e8
	ld e,l			;09e9
	inc de			;09ea
	ld bc,0000fh		;09eb
	ldir		;09ee
	ld hl,l01f0h		;09f0
	add hl,de			;09f3
	ex de,hl			;09f4
	dec hl			;09f5
	ldi		;09f6
	ld h,d			;09f8
	ld l,e			;09f9
	dec hl			;09fa
	ld bc,0000fh		;09fb
	ldir		;09fe
	ret			;0a00
	ld a,(l0f24h)		;0a01
	ld (l0f20h),a		;0a04
	ld a,(l0f23h)		;0a07
	call 00918h		;0a0a
	ret			;0a0d
	ld a,(l0f22h)		;0a0e
	ld (l0f20h),a		;0a11
	ld a,(l0f21h)		;0a14
	call 00918h		;0a17
	ret			;0a1a
	push bc			;0a1b
	push hl			;0a1c
	bit 7,a		;0a1d
	jp z,l0b22h		;0a1f
	set 0,(hl)		;0a22
	res 7,a		;0a24
	sub 00ah		;0a26
	jr nc,l0a46h		;0a28
	sra a		;0a2a
	sra a		;0a2c
	ld b,a			;0a2e
	cpl			;0a2f
	inc a			;0a30
	ld (l0f1fh),a		;0a31
sub_0a34h:
	ld a,b			;0a34
	add a,006h		;0a35
	ld (l0f17h),a		;0a37
	ld (l0f19h),a		;0a3a
	xor a			;0a3d
	ld (l0f0dh),a		;0a3e
	ld (l0f13h),a		;0a41
	jr l0a57h		;0a44
l0a46h:
	ld (l0f0dh),a		;0a46
	rrca			;0a49
	rrca			;0a4a
	and 00fh		;0a4b
	ld (l0f13h),a		;0a4d
	call sub_0a34h		;0a50
	xor a			;0a53
	ld (l0f1fh),a		;0a54
l0a57h:
	ld a,(l0f20h)		;0a57
	res 7,a		;0a5a
sub_0a5ch:
	sub 00ch		;0a5c
	jr nc,l0a84h		;0a5e
	sra a		;0a60
	ld b,a			;0a62
	cpl			;0a63
	inc a			;0a64
sub_0a65h:
	ld c,a			;0a65
	rlca			;0a66
	rlca			;0a67
	add a,c			;0a68
	add a,c			;0a69
	ld c,a			;0a6a
	ld a,(l0f1fh)		;0a6b
	add a,c			;0a6e
	ld (l0f1fh),a		;0a6f
	ld a,b			;0a72
	add a,00ch		;0a73
	ld (l0f18h),a		;0a75
	ld (l0f1ah),a		;0a78
	xor a			;0a7b
	ld (l0f0eh),a		;0a7c
	ld (l0f13h+1),a		;0a7f
	jr l0a90h		;0a82
l0a84h:
	ld (l0f0eh),a		;0a84
	rrca			;0a87
	and 01fh		;0a88
	ld (l0f13h+1),a		;0a8a
	call l0a46h+2		;0a8d
l0a90h:
	ld a,(l0f0eh)		;0a90
	bit 6,a		;0a93
	jr nz,l0b12h		;0a95
	ld a,(l0f0dh)		;0a97
	bit 6,a		;0a9a
	jr nz,l0afah		;0a9c
	call sub_0a5ch		;0a9e
	ld a,(l0f18h)		;0aa1
	sub 00ch		;0aa4
	jr z,l0ad7h		;0aa6
	ld a,(l0f17h)		;0aa8
	sub 006h		;0aab
	jr z,l0aech		;0aad
	ld a,(l0f0dh)		;0aaf
	cp 02ch		;0ab2
	jr nc,l0abfh		;0ab4
	ld a,(l0f0eh)		;0ab6
	cp 02ah		;0ab9
	jr nc,l0af2h		;0abb
	jr sub_0b34h		;0abd
l0abfh:
	ld a,(l0f0eh)		;0abf
	cp 02ah		;0ac2
	jr c,l0ae4h		;0ac4
	call 00ae9h		;0ac6
	call sub_0a65h		;0ac9
	call sub_0af5h		;0acc
	call 00ad4h		;0acf
	call 00a74h		;0ad2
	jr sub_0b34h		;0ad5
l0ad7h:
	ld a,(l0f1fh)		;0ad7
	and a			;0ada
	jr nz,sub_0b34h		;0adb
	ld a,(l0f17h)		;0add
	sub 006h		;0ae0
	jr z,sub_0b34h		;0ae2
l0ae4h:
	call 00ae9h		;0ae4
	call sub_0a65h		;0ae7
	jr sub_0b34h		;0aea
l0aech:
	ld a,(l0f1fh)		;0aec
	and a			;0aef
	jr nz,sub_0b34h		;0af0
l0af2h:
	call sub_0af5h		;0af2
sub_0af5h:
	call 00a74h		;0af5
	jr sub_0b34h		;0af8
l0afah:
	call sub_0a5ch		;0afa
	ld a,(l0f1fh)		;0afd
	and a			;0b00
	jr nz,sub_0b34h		;0b01
	ld a,(l0f18h)		;0b03
sub_0b06h:
	sub 00ch		;0b06
	jr z,sub_0b34h		;0b08
	call sub_0af5h		;0b0a
	call 00a74h		;0b0d
	jr sub_0b34h		;0b10
l0b12h:
	ld a,(l0f0dh)		;0b12
	bit 6,a		;0b15
	jr nz,l0b31h		;0b17
	call sub_0a5ch		;0b19
	ld a,(l0f1fh)		;0b1c
	and a			;0b1f
	jr nz,sub_0b34h		;0b20
l0b22h:
	ld a,(l0f17h)		;0b22
	sub 006h		;0b25
	jr z,sub_0b34h		;0b27
	call 00ae9h		;0b29
	call sub_0a65h		;0b2c
	jr sub_0b34h		;0b2f
l0b31h:
	call sub_0a5ch		;0b31
sub_0b34h:
	jp l0b31h		;0b34
	ld a,(l0f13h)		;0b37
	sub 010h		;0b3a
	neg		;0b3c
	cp 006h		;0b3e
	jr c,l0b44h		;0b40
sub_0b42h:
	ld a,006h		;0b42
l0b44h:
	ld (l0f17h),a		;0b44
	ld (l0f19h),a		;0b47
	ret			;0b4a
	ld a,(l0f13h+1)		;0b4b
	sub 020h		;0b4e
	neg		;0b50
	cp 00ch		;0b52
	jr c,l0b58h		;0b54
	ld a,00ch		;0b56
l0b58h:
	ld (l0f18h),a		;0b58
	ld (l0f1ah),a		;0b5b
	ret			;0b5e
	xor a			;0b5f
	ld (l0f13h+2),a		;0b60
	ld (l0f16h),a		;0b63
	jr l0b84h		;0b66
	ld a,(l0f18h)		;0b68
	ld (l0f1ah),a		;0b6b
	call l0b12h+2		;0b6e
	xor a			;0b71
	ld (l0f16h),a		;0b72
	jr l0b84h		;0b75
	call sub_0b06h		;0b77
	ld a,(l0f17h)		;0b7a
	ld (l0f19h),a		;0b7d
	xor a			;0b80
	ld (l0f13h+2),a		;0b81
l0b84h:
	ld a,(l0f13h+2)		;0b84
	rlca			;0b87
sub_0b88h:
	rlca			;0b88
	ld c,a			;0b89
	ld a,(l0f16h)		;0b8a
	rlca			;0b8d
	ld d,a			;0b8e
	ld hl,l0ee5h		;0b8f
	call 008aeh		;0b92
	ld h,b			;0b95
	ld l,c			;0b96
	ld (l0f1bh),hl		;0b97
	ex de,hl			;0b9a
	ld hl,l0c57h		;0b9b
	ld a,(l0f1fh)		;0b9e
	sub 006h		;0ba1
	jp p,00aa7h		;0ba3
	ld b,0ffh		;0ba6
	jr l0bach		;0ba8
	ld b,000h		;0baa
l0bach:
	ld c,a			;0bac
	add hl,bc			;0bad
	ld (l0f1dh),hl		;0bae
l0bb1h:
	ld bc,00006h		;0bb1
	ld hl,(l0f1dh)		;0bb4
l0bb7h:
	add hl,bc			;0bb7
	ld (l0f1dh),hl		;0bb8
	ld a,(l0f19h)		;0bbb
	ld c,a			;0bbe
	ldir		;0bbf
	ld bc,00010h		;0bc1
	ld hl,(l0f1bh)		;0bc4
	add hl,bc			;0bc7
	ld (l0f1bh),hl		;0bc8
	ex de,hl			;0bcb
	ld a,(l0f1ah)		;0bcc
	sub 001h		;0bcf
	ret z			;0bd1
	ld (l0f1ah),a		;0bd2
	jr l0bb1h		;0bd5
	call sub_0b06h		;0bd7
	call l0b12h+2		;0bda
	call 00a81h		;0bdd
	ld a,(l0f17h)		;0be0
	ld b,a			;0be3
	ld a,(l0f1fh)		;0be4
	sub b			;0be7
	ld (l0f1fh),a		;0be8
	ret			;0beb
	ld a,(l0f17h)		;0bec
	ld b,a			;0bef
	ld a,(l0f1fh)		;0bf0
	add a,b			;0bf3
	ld (l0f1fh),a		;0bf4
l0bf7h:
	ret			;0bf7
	ld a,(l0f18h)		;0bf8
	ld b,a			;0bfb
	rlca			;0bfc
	rlca			;0bfd
	add a,b			;0bfe
	add a,b			;0bff
	ld c,a			;0c00
	ld a,(l0f1fh)		;0c01
	add a,c			;0c04
	ld (l0f1fh),a		;0c05
	ret			;0c08
	ld a,(l0f18h)		;0c09
	ld (l0f16h),a		;0c0c
	ld b,a			;0c0f
	ld a,00ch		;0c10
	sub b			;0c12
	ld (l0f1ah),a		;0c13
	ret			;0c16
	ld a,(l0f17h)		;0c17
	ld (l0f13h+2),a		;0c1a
	ld b,a			;0c1d
	ld a,006h		;0c1e
	sub b			;0c20
	ld (l0f19h),a		;0c21
	ret			;0c24
	ld a,(l0ee5h)		;0c25
	ld h,a			;0c28
	xor a			;0c29
	ld l,a			;0c2a
	ld (hl),a			;0c2b
	ld d,h			;0c2c
	ld e,l			;0c2d
l0c2eh:
	inc de			;0c2e
	ld bc,l07ffh		;0c2f
	ldir		;0c32
	pop hl			;0c34
	pop bc			;0c35
	ret			;0c36
	ld c,00ah		;0c37
l0c39h:
	cp c			;0c39
	jr c,l0c40h		;0c3a
	sub c			;0c3c
	inc e			;0c3d
	jr l0c39h		;0c3e
l0c40h:
	rlca			;0c40
	rlca			;0c41
	rlca			;0c42
	rlca			;0c43
	or e			;0c44
l0c45h:
	ld c,a			;0c45
	and 0f0h		;0c46
	rrca			;0c48
	ld b,a			;0c49
	rrca			;0c4a
l0c4bh:
	add a,b			;0c4b
	ld (l0f26h),a		;0c4c
	ld a,c			;0c4f
	and 00fh		;0c50
	rlca			;0c52
	rlca			;0c53
	ld b,a			;0c54
	rlca			;0c55
	add a,b			;0c56
l0c57h:
	ld c,a			;0c57
	ld hl,00000h		;0c58
	ld b,h			;0c5b
	ld e,h			;0c5c
	bit 0,d		;0c5d
	jr z,l0c64h		;0c5f
	ld hl,l020ah+1		;0c61
l0c64h:
	ld a,(l0ee5h)		;0c64
	ld d,a			;0c67
	call 00b6fh		;0c68
	ld a,(l0f26h)		;0c6b
	ld c,a			;0c6e
	ld hl,0ffa3h		;0c6f
	add hl,de			;0c72
	ex de,hl			;0c73
	ld hl,l0c9fh		;0c74
	add hl,bc			;0c77
	ld b,006h		;0c78
	ld a,002h		;0c7a
l0c7ch:
	push bc			;0c7c
	ld b,000h		;0c7d
	ld c,a			;0c7f
	ldir		;0c80
	ex de,hl			;0c82
	ld c,00eh		;0c83
	add hl,bc			;0c85
	ex de,hl			;0c86
	pop bc			;0c87
	djnz l0c7ch		;0c88
	ret			;0c8a
	ld bc,0ffffh		;0c8b
l0c8eh:
	ld a,c			;0c8e
l0c8fh:
	dec a			;0c8f
	jr nz,l0c8fh		;0c90
	djnz l0c8eh		;0c92
	ld e,a			;0c94
	ret			;0c95
	ex de,hl			;0c96
	add hl,bc			;0c97
	ex de,hl			;0c98
	ld bc,00070h		;0c99
	ldir		;0c9c
	ret			;0c9e
l0c9fh:
	push bc			;0c9f
	ld bc,0f019h		;0ca0
	jr z,l0ca7h		;0ca3
	inc c			;0ca5
	inc c			;0ca6
l0ca7h:
	ld a,07fh		;0ca7
	ld e,040h		;0ca9
l0cabh:
	ld d,e			;0cab
l0cach:
	dec d			;0cac
	jr nz,l0cach		;0cad
	out (c),a		;0caf
	cpl			;0cb1
	inc e			;0cb2
	djnz l0cabh		;0cb3
	xor a			;0cb5
	out (c),a		;0cb6
	pop bc			;0cb8
	ret			;0cb9
	nop			;0cba
	ld b,00ch		;0cbb
	inc de			;0cbd
	add hl,de			;0cbe
	ld e,025h		;0cbf
	dec hl			;0cc1
	ld sp,03c36h		;0cc2
	ld b,d			;0cc5
	ld b,a			;0cc6
	ld c,h			;0cc7
	ld d,c			;0cc8
	ld d,(hl)			;0cc9
	ld e,d			;0cca
	ld e,a			;0ccb
sub_0ccch:
	ld h,e			;0ccc
	ld h,a			;0ccd
	ld l,d			;0cce
	ld l,(hl)			;0ccf
	ld (hl),c			;0cd0
	ld (hl),e			;0cd1
	halt			;0cd2
	ld a,b			;0cd3
	ld a,d			;0cd4
	ld a,h			;0cd5
	ld a,l			;0cd6
	ld a,a			;0cd7
	ld a,a			;0cd8
	ld a,a			;0cd9
	ld a,a			;0cda
	ld a,a			;0cdb
	ld a,a			;0cdc
	ld a,a			;0cdd
	ld a,l			;0cde
	ld a,h			;0cdf
	ld a,d			;0ce0
	ld a,b			;0ce1
	halt			;0ce2
	ld (hl),e			;0ce3
	ld (hl),c			;0ce4
	ld l,(hl)			;0ce5
	ld l,d			;0ce6
	ld h,a			;0ce7
	ld h,e			;0ce8
	ld e,a			;0ce9
	ld e,d			;0cea
	ld d,(hl)			;0ceb
	ld d,c			;0cec
	ld c,h			;0ced
	ld b,a			;0cee
	ld b,d			;0cef
	inc a			;0cf0
	ld (hl),031h		;0cf1
	dec hl			;0cf3
	dec h			;0cf4
	ld e,019h		;0cf5
	inc de			;0cf7
	inc c			;0cf8
	ld b,01fh		;0cf9
	ld e,01dh		;0cfb
	inc e			;0cfd
	dec de			;0cfe
	ld a,(de)			;0cff
	nop			;0d00
	ld bc,00403h		;0d01
	dec b			;0d04
	ld b,007h		;0d05
	ex af,af'			;0d07
	add hl,bc			;0d08
	ld a,(bc)			;0d09
	dec bc			;0d0a
	inc c			;0d0b
	dec c			;0d0c
	ld c,00fh		;0d0d
	rrca			;0d0f
	djnz l0d23h		;0d10
	ld de,01212h		;0d12
	inc de			;0d15
	inc de			;0d16
	inc d			;0d17
	inc d			;0d18
	inc d			;0d19
	dec d			;0d1a
	dec d			;0d1b
	dec d			;0d1c
	ld d,016h		;0d1d
	ld d,017h		;0d1f
	rla			;0d21
	rla			;0d22
l0d23h:
	rla			;0d23
	rla			;0d24
	jr l0d3fh		;0d25
	jr $+26		;0d27
	jr l0d44h		;0d29
	add hl,de			;0d2b
	add hl,de			;0d2c
	add hl,de			;0d2d
	add hl,de			;0d2e
	add hl,de			;0d2f
	add hl,de			;0d30
	call z,0010ch		;0d31
	pop bc			;0d34
	adc a,00eh		;0d35
	rrca			;0d37
	rst 8			;0d38
l0d39h:
	ret nz			;0d39
	nop			;0d3a
	dec c			;0d3b
	call 0e0e0h		;0d3c
l0d3fh:
	defb 0edh;next byte illegal after ed		;0d3f
	in b,(c)		;0d40
	add a,b			;0d42
	ld d,b			;0d43
l0d44h:
	jr c,l0d56h		;0d44
	jr z,l0d48h		;0d46
l0d48h:
	add a,b			;0d48
	or b			;0d49
	ret m			;0d4a
	djnz l0d4dh		;0d4b
l0d4dh:
	nop			;0d4d
	jr z,$+114		;0d4e
	jr z,l0d92h		;0d50
	add a,b			;0d52
	nop			;0d53
	jr nz,$+114		;0d54
l0d56h:
	ld h,b			;0d56
	jr nz,l0d39h		;0d57
	nop			;0d59
	nop			;0d5a
	nop			;0d5b
	or b			;0d5c
	nop			;0d5d
	dec bc			;0d5e
	nop			;0d5f
	or b			;0d60
	nop			;0d61
	cp e			;0d62
	or b			;0d63
	dec bc			;0d64
	dec bc			;0d65
	or b			;0d66
	dec bc			;0d67
	or b			;0d68
	or b			;0d69
	or b			;0d6a
	dec bc			;0d6b
	nop			;0d6c
	cp e			;0d6d
	sub b			;0d6e
	cp c			;0d6f
	or b			;0d70
	nop			;0d71
	nop			;0d72
	or b			;0d73
	sbc a,c			;0d74
	sbc a,c			;0d75
	cp e			;0d76
	nop			;0d77
	or b			;0d78
	sbc a,e			;0d79
	sbc a,c			;0d7a
	sbc a,c			;0d7b
	add hl,bc			;0d7c
	cp e			;0d7d
	cp e			;0d7e
	sub b			;0d7f
	ld sp,hl			;0d80
	sbc a,a			;0d81
	cp c			;0d82
	dec bc			;0d83
	nop			;0d84
	sub b			;0d85
	sbc a,c			;0d86
	sbc a,c			;0d87
	add hl,bc			;0d88
	cp e			;0d89
	or b			;0d8a
	cp e			;0d8b
	sbc a,c			;0d8c
	sbc a,c			;0d8d
	nop			;0d8e
	nop			;0d8f
	or b			;0d90
	or b			;0d91
l0d92h:
	sbc a,e			;0d92
	cp c			;0d93
	cp e			;0d94
	nop			;0d95
	cp e			;0d96
	or b			;0d97
	or b			;0d98
	nop			;0d99
	cp e			;0d9a
	dec bc			;0d9b
	nop			;0d9c
	cp e			;0d9d
	or b			;0d9e
	dec bc			;0d9f
	nop			;0da0
	dec bc			;0da1
	call z,sub_0ccch		;0da2
	ret nz			;0da5
	inc c			;0da6
	ret nz			;0da7
	inc c			;0da8
	ret nz			;0da9
	inc c			;0daa
	ret nz			;0dab
	call z,000cch		;0dac
	inc c			;0daf
	nop			;0db0
	inc c			;0db1
	nop			;0db2
	inc c			;0db3
	nop			;0db4
	inc c			;0db5
	nop			;0db6
	inc c			;0db7
	nop			;0db8
	inc c			;0db9
	call z,000cch		;0dba
	ret nz			;0dbd
	call z,sub_0ccch		;0dbe
	nop			;0dc1
	inc c			;0dc2
	nop			;0dc3
	call z,0cccch		;0dc4
	call z,0c000h		;0dc7
	call z,000cch		;0dca
	ret nz			;0dcd
	nop			;0dce
	ret nz			;0dcf
	call z,sub_0ccch		;0dd0
	inc c			;0dd3
	inc c			;0dd4
	inc c			;0dd5
	inc c			;0dd6
	inc c			;0dd7
	call z,000cch		;0dd8
	inc c			;0ddb
	nop			;0ddc
	inc c			;0ddd
	call z,sub_0ccch		;0dde
	nop			;0de1
	call z,000cch		;0de2
	ret nz			;0de5
	nop			;0de6
	ret nz			;0de7
	call z,0cccch		;0de8
	call z,0000ch		;0deb
	inc c			;0dee
	nop			;0def
	call z,sub_0ccch		;0df0
	ret nz			;0df3
	call z,0cccch		;0df4
	call z,0c000h		;0df7
	nop			;0dfa
	ret nz			;0dfb
	nop			;0dfc
	ret nz			;0dfd
	nop			;0dfe
	ret nz			;0dff
	nop			;0e00
	ret nz			;0e01
	call z,sub_0ccch		;0e02
	ret nz			;0e05
	call z,sub_0ccch		;0e06
	ret nz			;0e09
	inc c			;0e0a
	ret nz			;0e0b
	call z,0cccch		;0e0c
	call z,0c00ch		;0e0f
	inc c			;0e12
	ret nz			;0e13
	call z,000cch		;0e14
	ret nz			;0e17
	call z,000cch		;0e18
	nop			;0e1b
	nop			;0e1c
	nop			;0e1d
	nop			;0e1e
	nop			;0e1f
	nop			;0e20
	nop			;0e21
	nop			;0e22
	nop			;0e23
	nop			;0e24
	nop			;0e25
	or b			;0e26
	cp e			;0e27
	cp e			;0e28
	nop			;0e29
	and b			;0e2a
	xor d			;0e2b
	xor d			;0e2c
	ld a,(bc)			;0e2d
	ret nz			;0e2e
	call z,sub_0ccch		;0e2f
	sub b			;0e32
	sbc a,c			;0e33
	sbc a,c			;0e34
	add hl,bc			;0e35
	or b			;0e36
	dec bc			;0e37
	or b			;0e38
	dec bc			;0e39
	and b			;0e3a
	ld a,(bc)			;0e3b
	and b			;0e3c
	ld a,(bc)			;0e3d
	ret nz			;0e3e
	inc c			;0e3f
	nop			;0e40
	nop			;0e41
	sub b			;0e42
	add hl,bc			;0e43
	nop			;0e44
	nop			;0e45
	or b			;0e46
	dec bc			;0e47
	or b			;0e48
	dec bc			;0e49
	and b			;0e4a
	ld a,(bc)			;0e4b
	and b			;0e4c
	ld a,(bc)			;0e4d
	ret nz			;0e4e
	inc c			;0e4f
	nop			;0e50
	nop			;0e51
	sub b			;0e52
	add hl,bc			;0e53
	nop			;0e54
	nop			;0e55
	or b			;0e56
	dec bc			;0e57
	or b			;0e58
	dec bc			;0e59
	and b			;0e5a
	ld a,(bc)			;0e5b
	and b			;0e5c
	ld a,(bc)			;0e5d
	ret nz			;0e5e
	inc c			;0e5f
	call z,0900ch		;0e60
	sbc a,c			;0e63
	add hl,bc			;0e64
	nop			;0e65
	or b			;0e66
	dec bc			;0e67
	or b			;0e68
	dec bc			;0e69
	and b			;0e6a
	ld a,(bc)			;0e6b
	and b			;0e6c
	ld a,(bc)			;0e6d
	ret nz			;0e6e
	inc c			;0e6f
	ret nz			;0e70
	inc c			;0e71
	sub b			;0e72
	add hl,bc			;0e73
	nop			;0e74
	nop			;0e75
	or b			;0e76
	dec bc			;0e77
	or b			;0e78
	dec bc			;0e79
	and b			;0e7a
	ld a,(bc)			;0e7b
	and b			;0e7c
	ld a,(bc)			;0e7d
	ret nz			;0e7e
	inc c			;0e7f
	ret nz			;0e80
	inc c			;0e81
	sub b			;0e82
	add hl,bc			;0e83
	nop			;0e84
	nop			;0e85
	or b			;0e86
	cp e			;0e87
	cp e			;0e88
	nop			;0e89
	and b			;0e8a
	xor d			;0e8b
	xor d			;0e8c
	ld a,(bc)			;0e8d
	ret nz			;0e8e
	call z,sub_0ccch		;0e8f
	sub b			;0e92
	add hl,bc			;0e93
	nop			;0e94
	nop			;0e95
	ret po			;0e96
	ld c,0c0h		;0e97
	call z,sub_0ccch		;0e99
	ret nc			;0e9c
	dec c			;0e9d
	ret nc			;0e9e
	dec c			;0e9f
	or b			;0ea0
	cp e			;0ea1
	cp e			;0ea2
	dec bc			;0ea3
	ret p			;0ea4
	rrca			;0ea5
	ret po			;0ea6
	ld c,0c0h		;0ea7
	inc c			;0ea9
	nop			;0eaa
	nop			;0eab
	ret nc			;0eac
	dec c			;0ead
	ret nc			;0eae
	dec c			;0eaf
	nop			;0eb0
	or b			;0eb1
	dec bc			;0eb2
	nop			;0eb3
	ret p			;0eb4
	rrca			;0eb5
	ret po			;0eb6
	ld c,0c0h		;0eb7
	inc c			;0eb9
	nop			;0eba
	nop			;0ebb
	ret nc			;0ebc
	dec c			;0ebd
	ret nc			;0ebe
	dec c			;0ebf
	nop			;0ec0
	or b			;0ec1
	dec bc			;0ec2
	nop			;0ec3
	ret p			;0ec4
	rrca			;0ec5
	ret po			;0ec6
	ld c,0c0h		;0ec7
	inc c			;0ec9
	call z,0d00ch		;0eca
	defb 0ddh,0ddh,00dh	;illegal sequence		;0ecd
	nop			;0ed0
	or b			;0ed1
	dec bc			;0ed2
	nop			;0ed3
	ret p			;0ed4
	rrca			;0ed5
	ret po			;0ed6
	ld c,0c0h		;0ed7
	inc c			;0ed9
	ret nz			;0eda
	inc c			;0edb
	ret nc			;0edc
	dec c			;0edd
	ret nc			;0ede
	dec c			;0edf
	nop			;0ee0
	or b			;0ee1
	dec bc			;0ee2
l0ee3h:
	nop			;0ee3
l0ee4h:
	ret p			;0ee4
l0ee5h:
	rrca			;0ee5
l0ee6h:
	ret po			;0ee6
l0ee7h:
	ld c,0c0h		;0ee7
l0ee9h:
	inc c			;0ee9
l0eeah:
	ret nz			;0eea
	inc c			;0eeb
	ret nc			;0eec
	dec c			;0eed
l0eeeh:
	ret nc			;0eee
l0eefh:
	dec c			;0eef
l0ef0h:
	nop			;0ef0
	or b			;0ef1
l0ef2h:
	dec bc			;0ef2
l0ef3h:
	nop			;0ef3
l0ef4h:
	nop			;0ef4
l0ef5h:
	nop			;0ef5
	ret po			;0ef6
	ld c,0c0h		;0ef7
	call z,sub_0ccch		;0ef9
	ret nc			;0efc
l0efdh:
	dec c			;0efd
l0efeh:
	ret nc			;0efe
l0effh:
	dec c			;0eff
l0f00h:
	nop			;0f00
l0f01h:
	or b			;0f01
l0f02h:
	dec bc			;0f02
l0f03h:
	nop			;0f03
l0f04h:
	ret p			;0f04
l0f05h:
	rrca			;0f05
l0f06h:
	sub b			;0f06
l0f07h:
	sbc a,c			;0f07
	sbc a,c			;0f08
l0f09h:
	add hl,bc			;0f09
l0f0ah:
	nop			;0f0a
l0f0bh:
	xor d			;0f0b
	nop			;0f0c
l0f0dh:
	or b			;0f0d
l0f0eh:
	dec bc			;0f0e
l0f0fh:
	nop			;0f0f
l0f10h:
	nop			;0f10
	cp e			;0f11
l0f12h:
	ret nc			;0f12
l0f13h:
	defb 0ddh,0ddh,00dh	;illegal sequence		;0f13
l0f16h:
	sub b			;0f16
l0f17h:
	add hl,bc			;0f17
l0f18h:
	nop			;0f18
l0f19h:
	nop			;0f19
l0f1ah:
	and b			;0f1a
l0f1bh:
	xor d			;0f1b
	ld a,(bc)			;0f1c
l0f1dh:
	or b			;0f1d
	cp e			;0f1e
l0f1fh:
	nop			;0f1f
l0f20h:
	or b			;0f20
l0f21h:
	cp e			;0f21
l0f22h:
	ret nc			;0f22
l0f23h:
	dec c			;0f23
l0f24h:
	nop			;0f24
l0f25h:
	nop			;0f25
l0f26h:
	sub b			;0f26
l0f27h:
	add hl,bc			;0f27
l0f28h:
	nop			;0f28
l0f29h:
	nop			;0f29
l0f2ah:
	xor d			;0f2a
l0f2bh:
	nop			;0f2b
l0f2ch:
	xor d			;0f2c
	or b			;0f2d
l0f2eh:
	cp e			;0f2e
	dec bc			;0f2f
l0f30h:
	cp e			;0f30
	cp e			;0f31
l0f32h:
	ret nc			;0f32
	dec c			;0f33
	nop			;0f34
	nop			;0f35
	sub b			;0f36
l0f37h:
	add hl,bc			;0f37
	sbc a,c			;0f38
	add hl,bc			;0f39
	xor d			;0f3a
	nop			;0f3b
	xor d			;0f3c
	or b			;0f3d
	dec bc			;0f3e
	cp e			;0f3f
	dec bc			;0f40
	cp e			;0f41
	ret nc			;0f42
	defb 0ddh,00dh,000h	;illegal sequence		;0f43
	sub b			;0f46
	add hl,bc			;0f47
	sub b			;0f48
	add hl,bc			;0f49
	xor d			;0f4a
	xor d			;0f4b
	xor d			;0f4c
	or b			;0f4d
	dec bc			;0f4e
	or b			;0f4f
	nop			;0f50
	cp e			;0f51
	ret nc			;0f52
	dec c			;0f53
	nop			;0f54
	nop			;0f55
	sub b			;0f56
	add hl,bc			;0f57
	sub b			;0f58
	add hl,bc			;0f59
	xor d			;0f5a
	nop			;0f5b
	xor d			;0f5c
	or b			;0f5d
	dec bc			;0f5e
l0f5fh:
	nop			;0f5f
	nop			;0f60
	cp e			;0f61
	ret nc			;0f62
	dec c			;0f63
	nop			;0f64
	nop			;0f65
	sub b			;0f66
	sbc a,c			;0f67
	sbc a,c			;0f68
	add hl,bc			;0f69
	xor d			;0f6a
	nop			;0f6b
	xor d			;0f6c
	or b			;0f6d
	dec bc			;0f6e
	nop			;0f6f
	nop			;0f70
	cp e			;0f71
	ret nc			;0f72
	defb 0ddh,0ddh,00dh	;illegal sequence		;0f73
	nop			;0f76
	ret po			;0f77
	xor 0eeh		;0f78
	ld c,0cch		;0f7a
	nop			;0f7c
	call z,0fff0h		;0f7d
	rst 38h			;0f80
	rrca			;0f81
	sbc a,c			;0f82
	sbc a,c			;0f83
	sbc a,c			;0f84
	nop			;0f85
	nop			;0f86
	ret po			;0f87
	ld c,0e0h		;0f88
	ld c,0cch		;0f8a
	nop			;0f8c
	call z,sub_0ff0h		;0f8d
	nop			;0f90
	nop			;0f91
	sbc a,c			;0f92
	nop			;0f93
	sbc a,c			;0f94
	nop			;0f95
	nop			;0f96
	ret po			;0f97
	ld c,0e0h		;0f98
	ld c,0cch		;0f9a
	nop			;0f9c
	call z,sub_0ff0h		;0f9d
	nop			;0fa0
	nop			;0fa1
	sbc a,c			;0fa2
	nop			;0fa3
	sbc a,c			;0fa4
	nop			;0fa5
	nop			;0fa6
	ret po			;0fa7
	ld c,0e0h		;0fa8
	ld c,0cch		;0faa
	nop			;0fac
	call z,0fff0h		;0fad
	rrca			;0fb0
	nop			;0fb1
	sbc a,c			;0fb2
	sbc a,c			;0fb3
	sbc a,c			;0fb4
	nop			;0fb5
	nop			;0fb6
	ret po			;0fb7
	ld c,0e0h		;0fb8
	ld c,0cch		;0fba
	nop			;0fbc
	call z,sub_0ff0h		;0fbd
	nop			;0fc0
	nop			;0fc1
	sbc a,c			;0fc2
	sub b			;0fc3
	add hl,bc			;0fc4
	nop			;0fc5
	nop			;0fc6
	ret po			;0fc7
	ld c,0e0h		;0fc8
	ld c,0c0h		;0fca
	call z,0f00ch		;0fcc
	rrca			;0fcf
	nop			;0fd0
	nop			;0fd1
	sbc a,c			;0fd2
	sub b			;0fd3
	sbc a,c			;0fd4
	nop			;0fd5
	nop			;0fd6
	ret po			;0fd7
	xor 0eeh		;0fd8
	ld c,000h		;0fda
	call z,0f000h		;0fdc
	rst 38h			;0fdf
	rst 38h			;0fe0
	rrca			;0fe1
	sbc a,c			;0fe2
	nop			;0fe3
	sbc a,c			;0fe4
	nop			;0fe5
	call z,00018h		;0fe6
	nop			;0fe9
	nop			;0fea
	nop			;0feb
	nop			;0fec
	nop			;0fed
	nop			;0fee
	nop			;0fef
sub_0ff0h:
	nop			;0ff0
l0ff1h:
	ld hl,l0103h		;0ff1
	ld de,00000h		;0ff4
	ld bc,l0eeeh		;0ff7
	ldir		;0ffa
	ld a,000h		
	out (018h),a	
	ld a,0F0h		
	out (00eh),a
	jp 00000h		;0ffc
