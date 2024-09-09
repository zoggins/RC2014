; z80dasm 1.1.6
; command line: z80dasm --labels --origin=0x0100 -a MARTINI.COM

	org	00100h

sub_0100h:
	jp init			;0100
l0103h:
	jp 00200h		;0103
	rra			;0106
	rra			;0107
	nop			;0108
	xor d			;0109
	nop			;010a
	ex af,af'			;010b
	rst 38h			;010c
	nop			;010d
l010eh:
	nop			;010e
	nop			;010f
	nop			;0110
	sub (hl)			;0111
	ld e,02eh		;0112
	nop			;0114
	ld h,a			;0115
	jp 00019h		;0116
l0119h:
	ld h,000h		;0119
	ld l,a			;011b
	ld (00009h),hl		;011c
	ld hl,(00003h)		;011f
	ld b,h			;0122
	ld c,l			;0123
	jp l01d2h		;0124
	nop			;0127
	nop			;0128
	nop			;0129
	nop			;012a
	ld hl,00001h		;012b
	ret			;012e
	nop			;012f
	nop			;0130
	nop			;0131
	nop			;0132
	ld a,001h		;0133
	ld (0000dh),a		;0135
sub_0138h:
	jp l01e4h		;0138
	jp 00038h		;013b
	nop			;013e
	nop			;013f
	nop			;0140
	nop			;0141
	nop			;0142
	push hl			;0143
	call 00080h		;0144
	pop hl			;0147
l0148h:
	ret			;0148
	nop			;0149
	nop			;014a
	nop			;014b
	nop			;014c
	nop			;014d
	nop			;014e
	nop			;014f
	nop			;0150
	nop			;0151
	nop			;0152
	nop			;0153
	nop			;0154
	nop			;0155
	nop			;0156
	nop			;0157
l0158h:
	nop			;0158
	nop			;0159
	nop			;015a
	jp 000c1h		;015b
	cp 000h		;015e
l0160h:
	jp nz,00063h		;0160
	call 00080h		;0163
	ld de,0c800h		;0166
	in a,(000h)		;0169
	and 040h		;016b
	jp nz,00180h		;016d
	ld a,(0000bh)		;0170
	cp 000h		;0173
	jp nz,00066h		;0175
	inc de			;0178
	ld a,d			;0179
	cp 000h		;017a
	jp nz,00066h		;017c
	jp 00058h		;017f
	nop			;0182
	ld hl,(00003h)		;0183
	ld a,l			;0186
	sub 002h		;0187
	nop			;0189
l018ah:
	nop			;018a
	nop			;018b
	ld c,a			;018c
	ld b,h			;018d
	call 000b8h		;018e
	ld a,c			;0191
	add a,004h		;0192
	nop			;0194
	nop			;0195
	nop			;0196
l0197h:
	ld c,a			;0197
	call 000b8h		;0198
	ld hl,(00003h)		;019b
	ld a,h			;019e
	sub 002h		;019f
	nop			;01a1
	nop			;01a2
	nop			;01a3
	ld b,a			;01a4
	ld c,l			;01a5
	call 000b8h		;01a6
	ld a,b			;01a9
l01aah:
	add a,004h		;01aa
	nop			;01ac
	nop			;01ad
	nop			;01ae
	ld b,a			;01af
	call 000b8h		;01b0
	ld a,(00006h)		;01b3
	rrca			;01b6
	ld (00006h),a		;01b7
	ret			;01ba
	call 000e8h		;01bb
	xor 00fh		;01be
l01c0h:
	call sub_0138h		;01c0
	ret			;01c3
	ld a,(0000dh)		;01c4
	cp 001h		;01c7
	jp z,l03b5h		;01c9
	ld a,(0000ch)		;01cc
	jp 0005bh		;01cf
l01d2h:
	nop			;01d2
	nop			;01d3
	nop			;01d4
	nop			;01d5
	nop			;01d6
	nop			;01d7
	nop			;01d8
	nop			;01d9
	nop			;01da
	nop			;01db
	nop			;01dc
	nop			;01dd
	nop			;01de
	nop			;01df
	nop			;01e0
	nop			;01e1
	nop			;01e2
	nop			;01e3
l01e4h:
	nop			;01e4
	nop			;01e5
	nop			;01e6
	nop			;01e7
	nop			;01e8
	nop			;01e9
l01eah:
	nop			;01ea
	call sub_0100h		;01eb
	ld a,(hl)			;01ee
	jp c,000f2h		;01ef
	and 00fh		;01f2
	ret			;01f4
	and 0f0h		;01f5
	rlca			;01f7
	rlca			;01f8
	rlca			;01f9
	rlca			;01fa
	ret			;01fb
	ld bc,sub_0100h+1		;01fc
	ld bc,sub_0100h+1		;01ff
	ld bc,00021h		;0202
	djnz l027fh		;0205
	rla			;0207
	rla			;0208
	rla			;0209
	jp nc,l010eh		;020a
	ld de,00200h		;020d
	add hl,de			;0210
	ld a,c			;0211
	rla			;0212
	rla			;0213
	rla			;0214
	jp nc,l0119h		;0215
	ld de,00400h		;0218
	add hl,de			;021b
	ld a,c			;021c
	and 01fh		;021d
	rlca			;021f
l0220h:
	rlca			;0220
	rlca			;0221
	rla			;0222
	ld e,a			;0223
	ld a,000h		;0224
	rla			;0226
	ld d,a			;0227
	add hl,de			;0228
	ld a,b			;0229
	rra			;022a
	push af			;022b
	nop			;022c
	and 00fh		;022d
	ld e,a			;022f
sub_0230h:
	ld d,000h		;0230
	add hl,de			;0232
l0233h:
	pop af			;0233
	ret			;0234
	nop			;0235
	nop			;0236
	nop			;0237
l0238h:
	nop			;0238
	nop			;0239
	nop			;023a
	and 00fh		;023b
	push af			;023d
	call sub_0100h		;023e
	pop de			;0241
	jp c,l0148h		;0242
	ld a,(hl)			;0245
l0246h:
	and 0f0h		;0246
	add a,d			;0248
	ld (hl),a			;0249
	ret			;024a
	ld a,d			;024b
	rlca			;024c
	rlca			;024d
	rlca			;024e
	rlca			;024f
	ld d,a			;0250
	ld a,(hl)			;0251
	and 00fh		;0252
l0254h:
	add a,d			;0254
	ld (hl),a			;0255
	ret			;0256
	nop			;0257
	nop			;0258
	nop			;0259
	nop			;025a
	ld a,000h		;025b
	ld (00008h),a		;025d
	jp l01c0h		;0260
	ld a,008h		;0263
	ld (00008h),a		;0265
l0268h:
	jp l01c0h		;0268
	ld hl,01000h		;026b
	xor a			;026e
	ld (hl),a			;026f
	inc hl			;0270
	ld a,h			;0271
	cp 018h		;0272
	jp nz,0527fh		;0274
	ld b,a			;0277
	ld e,c			;0278
	ld b,d			;0279
	ld d,b			;027a
	ld b,e			;027b
	ld d,a			;027c
	rst 38h			;027d
	nop			;027e
l027fh:
	nop			;027f
	nop			;0280
	nop			;0281
	nop			;0282
	ld a,(00006h)		;0283
	rrca			;0286
	call c,00080h		;0287
	call 003d1h		;028a
	ld a,b			;028d
	cp 020h		;028e
	jp z,l01c0h		;0290
	ld hl,00172h		;0293
	nop			;0296
	ld de,0ffffh		;0297
	inc e			;029a
	ld a,b			;029b
	nop			;029c
	nop			;029d
	nop			;029e
	cp (hl)			;029f
	jp z,l01aah		;02a0
	ld a,(hl)			;02a3
	cp 0ffh		;02a4
	jp z,00240h		;02a6
	inc hl			;02a9
	jp l0197h		;02aa
	ld a,e			;02ad
	nop			;02ae
	nop			;02af
	nop			;02b0
	nop			;02b1
	nop			;02b2
	ld (00007h),a		;02b3
	nop			;02b6
	nop			;02b7
	nop			;02b8
	nop			;02b9
	nop			;02ba
	nop			;02bb
	nop			;02bc
	nop			;02bd
	nop			;02be
	nop			;02bf
	nop			;02c0
	nop			;02c1
	nop			;02c2
sub_02c3h:
	ld hl,(00003h)		;02c3
l02c6h:
	ld b,h			;02c6
	ld c,l			;02c7
	nop			;02c8
	ld hl,(00007h)		;02c9
	ld a,h			;02cc
	add a,l			;02cd
	nop			;02ce
	nop			;02cf
	nop			;02d0
	nop			;02d1
	call sub_0138h		;02d2
	ld hl,(00009h)		;02d5
	ld a,h			;02d8
	add a,b			;02d9
	ld h,a			;02da
	ld a,l			;02db
l02dch:
	add a,c			;02dc
	ld l,a			;02dd
	ld (00003h),hl		;02de
	call sub_02c3h		;02e1
	jp 00058h		;02e4
	ld de,000c0h		;02e7
	ld a,0feh		;02ea
l02ech:
	ld d,a			;02ec
	inc de			;02ed
	ld a,d			;02ee
	cp 0ffh		;02ef
	ret z			;02f1
l02f2h:
	jp l01eah		;02f2
	ld a,a			;02f5
	ld d,d			;02f6
	ld b,a			;02f7
	ld e,c			;02f8
	ld b,d			;02f9
	ld d,b			;02fa
	ld b,e			;02fb
	ld d,a			;02fc
	ld l,02ch		;02fd
	ld c,l			;02ff
	ld c,(hl)			;0300
	cpl			;0301
	dec de			;0302
	ld sp,00fffh		;0303
	ld a,088h		;0306
	out (00eh),a		;0308
	ld a,030h		;030a
	out (00fh),a		;030c
	ld hl,01f1fh		;030e
	ld (00003h),hl		;0311
	ld hl,0aa00h		;0314
	ld (00005h),hl		;0317
	ld hl,01800h		;031a
	ld (0000eh),hl		;031d
	ld hl,00009h		;0320
	xor a			;0323
	ld (hl),a			;0324
	inc hl			;0325
	ld a,l			;0326
	cp 00dh		;0327
	jp nz,l0220h		;0329
	call sub_0230h		;032c
	jp 00058h		;032f
	nop			;0332
	ld hl,01000h		;0333
	xor a			;0336
	ld (hl),a			;0337
	inc hl			;0338
	ld a,h			;0339
	cp 020h		;033a
	jp nz,l0233h		;033c
	ret			;033f
	nop			;0340
	nop			;0341
	nop			;0342
	ld hl,l0268h		;0343
	ld de,01580h		;0346
	ld a,b			;0349
	cp (hl)			;034a
	jp z,l0254h		;034b
	inc hl			;034e
	dec d			;034f
	jp z,00058h		;0350
	inc e			;0353
	jp l0246h		;0354
	ld l,e			;0357
	ld l,(hl)			;0358
	inc h			;0359
	jp (hl)			;035a
	nop			;035b
	ld hl,(00003h)		;035c
	ld b,h			;035f
	ld c,l			;0360
	jp l01d2h		;0361
sub_0364h:
	jp sub_0100h		;0364
l0367h:
	nop			;0367
	nop			;0368
	nop			;0369
	nop			;036a
	ld l,02ch		;036b
	ld c,l			;036d
	ld c,(hl)			;036e
	cpl			;036f
l0370h:
	ld de,03e3bh		;0370
l0373h:
	inc a			;0373
	ld e,l			;0374
	ld e,(hl)			;0375
	ld c,h			;0376
	ld c,b			;0377
	inc bc			;0378
	ld (bc),a			;0379
	djnz $+66		;037a
	dec de			;037c
	ld (de),a			;037d
	inc de			;037e
	nop			;037f
sub_0380h:
	nop			;0380
	nop			;0381
	nop			;0382
	nop			;0383
	dec b			;0384
	ld a,(bc)			;0385
	rrca			;0386
	inc d			;0387
	dec e			;0388
	defb 0edh;next byte illegal after ed		;0389
	inc hl			;038a
	dec hl			;038b
	inc sp			;038c
	dec sp			;038d
	ld b,e			;038e
	ld b,(hl)			;038f
	ld d,b			;0390
l0391h:
	ld e,d			;0391
	ret nz			;0392
	adc a,e			;0393
	sbc a,b			;0394
	xor a			;0395
	xor b			;0396
	and l			;0397
	nop			;0398
	nop			;0399
	nop			;039a
	nop			;039b
	rlca			;039c
	nop			;039d
	nop			;039e
	nop			;039f
	nop			;03a0
	nop			;03a1
	nop			;03a2
	nop			;03a3
	nop			;03a4
	nop			;03a5
	nop			;03a6
	nop			;03a7
	nop			;03a8
	nop			;03a9
	nop			;03aa
	ld (hl),b			;03ab
	ld bc,00050h		;03ac
	ld d,b			;03af
	nop			;03b0
	jr nc,l03b4h		;03b1
	ex af,af'			;03b3
l03b4h:
	nop			;03b4
l03b5h:
	sub b			;03b5
	nop			;03b6
	nop			;03b7
	add hl,bc			;03b8
	nop			;03b9
	nop			;03ba
l03bbh:
	jr nc,$+7		;03bb
	nop			;03bd
	dec b			;03be
	nop			;03bf
	dec b			;03c0
	jr nc,l03c4h		;03c1
l03c3h:
	nop			;03c3
l03c4h:
	nop			;03c4
	ld h,b			;03c5
	ld hl,(00003h)		;03c6
	ld a,h			;03c9
	and 0c0h		;03ca
	jp z,l02dch		;03cc
	rla			;03cf
	jp nc,002d6h		;03d0
	ld h,03fh		;03d3
	dec l			;03d5
	jp l02dch		;03d6
l03d9h:
	ld h,000h		;03d9
l03dbh:
	inc l			;03db
	nop			;03dc
	nop			;03dd
	nop			;03de
	ld a,l			;03df
	and 0c0h		;03e0
	jp z,l02f2h		;03e2
	rla			;03e5
	jp nc,l02ech		;03e6
	ld l,03fh		;03e9
	dec h			;03eb
	jp l02c6h		;03ec
l03efh:
	ld l,000h		;03ef
	inc h			;03f1
	jp l02c6h		;03f2
	ld (00003h),hl		;03f5
	ret			;03f8
	add a,002h		;03f9
	ld l,03fh		;03fb
	dec h			;03fd
	jp l02c6h		;03fe
	nop			;0401
	nop			;0402
	ld a,001h		;0403
	jp 00010h		;0405
	ld a,0ffh		;0408
	jp 00010h		;040a
	ld a,001h		;040d
	jp 00016h		;040f
	ld a,0ffh		;0412
	jp 00016h		;0414
	ld hl,00000h		;0417
	ld (00009h),hl		;041a
	jp l01c0h		;041d
	jp 00000h		;0420
	nop			;0423
	nop			;0424
l0425h:
	nop			;0425
	ld a,001h		;0426
	ld (0000ah),a		;0428
	jp 00058h		;042b
	ld a,0ffh		;042e
	ld (0000ah),a		;0430
	jp 00058h		;0433
	ld a,001h		;0436
	ld (00009h),a		;0438
	jp 00058h		;043b
	ld a,0ffh		;043e
	ld (00009h),a		;0440
	jp 00058h		;0443
	jp l0158h		;0446
	jp l0160h		;0449
	nop			;044c
	nop			;044d
	nop			;044e
	nop			;044f
	nop			;0450
	nop			;0451
	nop			;0452
	ld a,(0000ch)		;0453
	cpl			;0456
	ld (0000ch),a		;0457
	jp 00058h		;045a
	ld a,(0000bh)		;045d
	cpl			;0460
	ld (0000bh),a		;0461
	jp 00058h		;0464
	ld d,020h		;0467
	rst 28h			;0469
	call sub_0380h		;046a
	dec d			;046d
	jp nz,l0367h		;046e
	nop			;0471
	ret			;0472
	ld hl,01800h		;0473
	nop			;0476
	call sub_0380h		;0477
	cp 013h		;047a
	jp z,l0391h		;047c
	inc hl			;047f
	jp l0373h		;0480
	in a,(000h)		;0483
	and 080h		;0485
	jp z,sub_0380h		;0487
	ld a,(hl)			;048a
	out (001h),a		;048b
	ret			;048d
	call sub_0364h		;048e
	jp l0370h		;0491
	call sub_0364h		;0494
	jp 00058h		;0497
	nop			;049a
	ld a,018h		;049b
	ld (l0238h),a		;049d
	call sub_0230h		;04a0
	ld a,020h		;04a3
	ld (l0238h),a		;04a5
	jp 00058h		;04a8
	xor a			;04ab
	ld (0000dh),a		;04ac
	jp 00432h		;04af
	ld hl,017ffh		;04b2
	ld (0000eh),hl		;04b5
	rst 30h			;04b8
	nop			;04b9
	nop			;04ba
	jp 00406h		;04bb
	inc hl			;04be
	ld b,(hl)			;04bf
	jp 00400h		;04c0
	ld hl,00000h		;04c3
	in a,(000h)		;04c6
	and 080h		;04c8
	jp z,l03c3h		;04ca
	ld a,(hl)			;04cd
	out (001h),a		;04ce
	inc hl			;04d0
	jp l03c3h		;04d1
	ld hl,l03efh		;04d4
	in a,(001h)		;04d7
	and 07fh		;04d9
	ld b,a			;04db
	inc hl			;04dc
	ld a,b			;04dd
	cp (hl)			;04de
	ret z			;04df
	ld a,(hl)			;04e0
	cp 0ffh		;04e1
	jp nz,l03d9h		;04e3
	ld a,b			;04e6
	ld hl,(0000eh)		;04e7
	ld (hl),a			;04ea
	inc hl			;04eb
	ld (0000eh),hl		;04ec
	ret			;04ef
	jp 0001ch		;04f0
	inc bc			;04f3
	ld (bc),a			;04f4
	djnz l0537h		;04f5
	ld de,0ff00h		;04f7
	nop			;04fa
	nop			;04fb
	nop			;04fc
	nop			;04fd
	nop			;04fe
	nop			;04ff
	nop			;0500
	nop			;0501
	nop			;0502
	ld (0000eh),hl		;0503
	jp l018ah		;0506
	ld hl,(0000eh)		;0509
	in a,(001h)		;050c
	cp 011h		;050e
	jp nz,00418h		;0510
	ld a,000h		;0513
	ld (0000dh),a		;0515
	jp 00000h		;0518
	cp 09ah		;051b
	jp nz,l0425h		;051d
	ld a,000h		;0520
	ld (0000dh),a		;0522
	jp 00058h		;0525
	cp 018h		;0528
	jp nz,l03bbh		;052a
	ld a,0a8h		;052d
	ld (00292h),a		;052f
	jp l03bbh		;0532
	ld a,0afh		;0535
l0537h:
	ld (00292h),a		;0537
	jp 00058h		;053a
	rlca			;053d
	rlca			;053e
	rlca			;053f
	rlca			;0540
	rlca			;0541
	rlca			;0542
	nop			;0543
	nop			;0544
	nop			;0545
	nop			;0546
	nop			;0547
	nop			;0548
	nop			;0549
	nop			;054a
	nop			;054b
	nop			;054c
	nop			;054d
	nop			;054e
	nop			;054f
	nop			;0550
	nop			;0551
	nop			;0552
	nop			;0553
	nop			;0554
	nop			;0555
	nop			;0556
	nop			;0557
	dec c			;0558
	dec c			;0559
	dec c			;055a
	dec c			;055b
	dec c			;055c
	dec c			;055d
	dec c			;055e
	dec c			;055f
	dec c			;0560
	dec c			;0561
	dec c			;0562
	dec c			;0563
	dec c			;0564
	dec c			;0565
	dec c			;0566
	dec c			;0567
l0568h:
	ld hl,l0103h		;0568
	ld de,00000h		;056b
	ld bc,00465h		;056e
	ldir		;0571
	ld hl,01000h		;0573
	ld a,000h		;0576
	ld (hl),a			;0578
	ld de,01001h		;0579
	ld bc,l0800h		;057c
	ldir		;057f
	ld hl,l05b0h		;0581
	ld de,01800h		;0584
	ld bc,00697h		;0587
	ldir		;058a
	di			;058c
	ld bc,0121fh		;058d
	ld de,00054h		;0590
	ld hl,l03efh+1		;0593
	ld sp,00ffdh		;0596
	ld a,088h		;0599
	out (00eh),a		;059b
	ld a,030h		;059d
	out (00fh),a		;059f
	ld a,08ah		;05a1
	ld (00ffdh),a		;05a3
	ld a,001h		;05a6
	ld (00ffeh),a		;05a8
	ld a,012h		;05ab
	jp l03dbh		;05ad
l05b0h:
	inc l			;05b0
	inc l			;05b1
	inc l			;05b2
	inc l			;05b3
	inc l			;05b4
	inc l			;05b5
	inc l			;05b6
	inc l			;05b7
	inc l			;05b8
	inc l			;05b9
	inc l			;05ba
	inc l			;05bb
	inc l			;05bc
	inc l			;05bd
	inc l			;05be
	inc l			;05bf
	inc l			;05c0
	inc l			;05c1
	ld c,l			;05c2
	ld c,l			;05c3
	ld c,l			;05c4
	ld c,l			;05c5
	ld c,l			;05c6
	ld c,l			;05c7
	ld c,l			;05c8
	ld c,l			;05c9
	ld c,l			;05ca
	ld c,l			;05cb
	inc l			;05cc
	ld b,d			;05cd
	jr nz,l05f0h		;05ce
	jr nz,l05f2h		;05d0
	jr nz,$+34		;05d2
	ld l,020h		;05d4
	jr nz,$+34		;05d6
	jr nz,$+34		;05d8
	jr nz,$+34		;05da
	jr nz,l05feh		;05dc
	inc l			;05de
	inc l			;05df
	inc l			;05e0
	inc l			;05e1
	inc l			;05e2
	ld c,(hl)			;05e3
	jr nz,l0606h		;05e4
	jr nz,$+34		;05e6
	jr nz,$+34		;05e8
	jr nz,$+34		;05ea
	jr nz,$+34		;05ec
	jr nz,$+34		;05ee
l05f0h:
	jr nz,$+62		;05f0
l05f2h:
	ld e,(hl)			;05f2
	jr nz,l0615h		;05f3
	jr nz,l0617h		;05f5
	jr nz,l0619h		;05f7
	jr nz,l061bh		;05f9
	jr nz,l063bh		;05fb
	ld e,l			;05fd
l05feh:
	dec sp			;05fe
	dec sp			;05ff
	dec sp			;0600
	dec sp			;0601
	dec sp			;0602
	dec sp			;0603
	dec sp			;0604
	dec sp			;0605
l0606h:
	dec sp			;0606
	ld a,05eh		;0607
	jr nz,l062bh		;0609
	jr nz,l062dh		;060b
	jr nz,l062fh		;060d
	jr nz,l0631h		;060f
	jr nz,l0633h		;0611
	inc l			;0613
	inc l			;0614
l0615h:
	inc l			;0615
	inc l			;0616
l0617h:
	inc l			;0617
	inc l			;0618
l0619h:
	inc l			;0619
	inc l			;061a
l061bh:
	inc l			;061b
	inc l			;061c
	inc l			;061d
	inc l			;061e
	inc l			;061f
	inc l			;0620
	inc l			;0621
	inc l			;0622
	inc l			;0623
	inc l			;0624
	ld c,l			;0625
	inc l			;0626
	jr nz,l0657h		;0627
	ld l,02eh		;0629
l062bh:
	ld l,02eh		;062b
l062dh:
	ld l,02eh		;062d
l062fh:
	ld l,02eh		;062f
l0631h:
	ld l,02eh		;0631
l0633h:
	ld l,02eh		;0633
	ld l,02eh		;0635
	ld c,(hl)			;0637
	ld c,(hl)			;0638
	ld b,a			;0639
	ld b,a			;063a
l063bh:
	ld l,020h		;063b
	jr nz,l065fh		;063d
	jr nz,l0661h		;063f
	jr nz,l0663h		;0641
	jr nz,l0665h		;0643
	jr nz,l0694h		;0645
	jr nz,$+48		;0647
	jr nz,l0698h		;0649
	jr nz,$+48		;064b
	jr nz,l066fh		;064d
	jr nz,l0671h		;064f
	jr nz,l0673h		;0651
	jr nz,l0675h		;0653
	jr nz,$+34		;0655
l0657h:
	jr nz,$+34		;0657
	jr nz,$+34		;0659
	jr nz,$+34		;065b
	jr nz,$+34		;065d
l065fh:
	jr nz,$+34		;065f
l0661h:
	jr nz,$+34		;0661
l0663h:
	jr nz,$+34		;0663
l0665h:
	jr nz,$+80		;0665
	jr nz,$+34		;0667
	jr nz,$+34		;0669
	jr nz,$+34		;066b
	jr nz,$+34		;066d
l066fh:
	jr nz,$+34		;066f
l0671h:
	jr nz,$+34		;0671
l0673h:
	jr nz,$+34		;0673
l0675h:
	inc l			;0675
	jr nz,l0698h		;0676
	jr nz,l069ah		;0678
	jr nz,l069ch		;067a
	jr nz,l069eh		;067c
	jr nz,l06a0h		;067e
	jr nz,l06a2h		;0680
	jr nz,$+34		;0682
	jr nz,$+34		;0684
	jr nz,l06a8h		;0686
	jr nz,l06aah		;0688
	jr nz,l06ach		;068a
	jr nz,$+79		;068c
	jr nz,l06bch		;068e
	jr nz,$+79		;0690
	jr nz,l06c0h		;0692
l0694h:
	jr nz,$+79		;0694
	jr nz,l06c4h		;0696
l0698h:
	jr nz,l06bah		;0698
l069ah:
	jr nz,l06bch		;069a
l069ch:
	jr nz,l06beh		;069c
l069eh:
	jr nz,l06c0h		;069e
l06a0h:
	jr nz,l06c2h		;06a0
l06a2h:
	ld c,(hl)			;06a2
	jr nz,$+34		;06a3
	ld a,05dh		;06a5
	dec sp			;06a7
l06a8h:
	dec sp			;06a8
	dec sp			;06a9
l06aah:
	dec sp			;06aa
	dec sp			;06ab
l06ach:
	dec sp			;06ac
	dec sp			;06ad
	dec sp			;06ae
	dec sp			;06af
	dec sp			;06b0
	dec sp			;06b1
	ld l,02eh		;06b2
	ld l,02bh		;06b4
	ld a,050h		;06b6
	jr nz,l06dah		;06b8
l06bah:
	jr nz,l06dch		;06ba
l06bch:
	jr nz,l06deh		;06bc
l06beh:
	jr nz,l06e0h		;06be
l06c0h:
	jr nz,l06e2h		;06c0
l06c2h:
	jr nz,l06e4h		;06c2
l06c4h:
	jr nz,l06e6h		;06c4
	jr nz,l06e8h		;06c6
	jr nz,l06eah		;06c8
	jr nz,l06ech		;06ca
	jr nz,$+34		;06cc
	jr nz,$+34		;06ce
	ld c,(hl)			;06d0
	inc l			;06d1
	jr nz,$+34		;06d2
	jr nz,$+34		;06d4
	jr nz,$+34		;06d6
	jr nz,$+34		;06d8
l06dah:
	jr nz,$+34		;06da
l06dch:
	jr nz,$+34		;06dc
l06deh:
	jr nz,$+34		;06de
l06e0h:
	jr nz,$+34		;06e0
l06e2h:
	jr nz,$+34		;06e2
l06e4h:
	jr nz,$+34		;06e4
l06e6h:
	jr nz,$+34		;06e6
l06e8h:
	jr nz,l070ah		;06e8
l06eah:
	jr nz,l070ch		;06ea
l06ech:
	ld c,(hl)			;06ec
	ld l,020h		;06ed
	jr nz,$+34		;06ef
	jr nz,$+34		;06f1
	jr nz,$+34		;06f3
	jr nz,$+34		;06f5
	jr nz,$+34		;06f7
	jr nz,$+34		;06f9
	jr nz,$+34		;06fb
	jr nz,$+34		;06fd
	jr nz,$+34		;06ff
	jr nz,$+34		;0701
	jr nz,l0725h		;0703
	jr nz,l0727h		;0705
	jr nz,l0757h		;0707
	inc l			;0709
l070ah:
	jr nz,$+34		;070a
l070ch:
	jr nz,$+34		;070c
	jr nz,$+34		;070e
	jr nz,$+34		;0710
	jr nz,$+34		;0712
	jr nz,$+34		;0714
	jr nz,$+34		;0716
	jr nz,$+34		;0718
	jr nz,$+34		;071a
	jr nz,$+34		;071c
	jr nz,$+34		;071e
	jr nz,$+34		;0720
	jr nz,$+34		;0722
	ld c,l			;0724
l0725h:
	jr nz,l0775h		;0725
l0727h:
	ld c,(hl)			;0727
	jr nz,l0777h		;0728
	inc l			;072a
	jr nz,l075bh		;072b
	ld l,02eh		;072d
	ld l,02eh		;072f
	ld l,02eh		;0731
	ld l,02eh		;0733
	ld l,02eh		;0735
	ld l,02eh		;0737
	ld l,02eh		;0739
	ld l,02eh		;073b
	ld l,02eh		;073d
	ld l,02eh		;073f
	ld l,02eh		;0741
	ld l,02eh		;0743
	ld l,02eh		;0745
	ld l,02eh		;0747
	ld c,(hl)			;0749
	inc l			;074a
	jr nz,l076dh		;074b
	jr nz,l076fh		;074d
	jr nz,l0771h		;074f
	jr nz,l0773h		;0751
	jr nz,l0775h		;0753
	jr nz,l0777h		;0755
l0757h:
	jr nz,l0779h		;0757
	jr nz,l077bh		;0759
l075bh:
	jr nz,l077dh		;075b
	jr nz,l077fh		;075d
	jr nz,l0781h		;075f
	jr nz,l0783h		;0761
	jr nz,l0785h		;0763
	jr nz,l0787h		;0765
	jr nz,l0789h		;0767
	jr nz,l078bh		;0769
	jr nz,l078dh		;076b
l076dh:
	jr nz,l078fh		;076d
l076fh:
	jr nz,l0791h		;076f
l0771h:
	ld l,02eh		;0771
l0773h:
	ld l,02eh		;0773
l0775h:
	ld l,02eh		;0775
l0777h:
	ld l,02eh		;0777
l0779h:
	ld l,02eh		;0779
l077bh:
	ld l,02eh		;077b
l077dh:
	ld l,02eh		;077d
l077fh:
	ld l,02eh		;077f
l0781h:
	ld l,02eh		;0781
l0783h:
	ld l,02eh		;0783
l0785h:
	ld l,02eh		;0785
l0787h:
	ld l,02eh		;0787
l0789h:
	ld l,02eh		;0789
l078bh:
	ld l,02eh		;078b
l078dh:
	ld l,02eh		;078d
l078fh:
	ld l,02eh		;078f
l0791h:
	ld l,02eh		;0791
	ld l,02eh		;0793
	ld l,02eh		;0795
	ld l,04eh		;0797
	inc l			;0799
	jr nz,l07bch		;079a
	jr nz,l07beh		;079c
	jr nz,l07c0h		;079e
	jr nz,$+34		;07a0
	jr nz,$+34		;07a2
	jr nz,$+34		;07a4
	jr nz,$+34		;07a6
	jr nz,$+34		;07a8
	jr nz,$+34		;07aa
	jr nz,$+34		;07ac
	jr nz,$+34		;07ae
	jr nz,$+34		;07b0
	jr nz,$+34		;07b2
	jr nz,$+34		;07b4
	jr nz,$+34		;07b6
	jr nz,$+34		;07b8
	jr nz,$+34		;07ba
l07bch:
	jr nz,$+34		;07bc
l07beh:
	jr nz,$+34		;07be
l07c0h:
	ld c,(hl)			;07c0
	ld l,020h		;07c1
	jr nz,l07e5h		;07c3
	jr nz,l07e7h		;07c5
	jr nz,l07e9h		;07c7
	jr nz,$+34		;07c9
	jr nz,$+34		;07cb
	jr nz,$+34		;07cd
	jr nz,$+34		;07cf
	jr nz,$+34		;07d1
	jr nz,$+34		;07d3
	jr nz,$+34		;07d5
	jr nz,$+34		;07d7
	jr nz,$+34		;07d9
	jr nz,$+34		;07db
	jr nz,$+34		;07dd
	jr nz,$+34		;07df
	jr nz,$+34		;07e1
	jr nz,$+34		;07e3
l07e5h:
	jr nz,$+34		;07e5
l07e7h:
	jr nz,l0837h		;07e7
l07e9h:
	inc l			;07e9
	jr nz,l080ch		;07ea
	jr nz,l080eh		;07ec
	jr nz,l0810h		;07ee
	jr nz,l0812h		;07f0
	jr nz,$+34		;07f2
	jr nz,$+34		;07f4
	jr nz,l0818h		;07f6
	jr nz,l081ah		;07f8
	jr nz,$+34		;07fa
	jr nz,$+34		;07fc
	jr nz,$+34		;07fe
l0800h:
	jr nz,$+34		;0800
	jr nz,$+34		;0802
	jr nz,$+34		;0804
	jr nz,$+34		;0806
	jr nz,$+34		;0808
	jr nz,$+34		;080a
l080ch:
	jr nz,$+34		;080c
l080eh:
	jr nz,$+34		;080e
l0810h:
	jr nz,l0832h		;0810
l0812h:
	ld c,l			;0812
	jr nz,$+46		;0813
	jr nz,l0837h		;0815
	ld c,l			;0817
l0818h:
	jr nz,l083ah		;0818
l081ah:
	inc l			;081a
	jr nz,$+79		;081b
	jr nz,l084bh		;081d
	jr nz,$+79		;081f
	jr nz,$+34		;0821
	jr nz,$+34		;0823
	jr nz,l0855h		;0825
	jr nz,$+79		;0827
	jr nz,l0859h		;0829
	jr nz,$+79		;082b
	jr nz,l087dh		;082d
	jr nz,l0851h		;082f
	ld c,l			;0831
l0832h:
	ld l,020h		;0832
	ld c,(hl)			;0834
	jr nz,$+79		;0835
l0837h:
	inc l			;0837
	jr nz,$+34		;0838
l083ah:
	jr nz,$+46		;083a
	inc l			;083c
	ld c,(hl)			;083d
	ld l,020h		;083e
	jr nz,$+34		;0840
	jr nz,$+34		;0842
	jr nz,$+34		;0844
	ld a,05eh		;0846
	dec sp			;0848
	dec sp			;0849
	dec sp			;084a
l084bh:
	dec sp			;084b
	dec sp			;084c
	dec sp			;084d
	dec sp			;084e
	dec sp			;084f
	dec sp			;0850
l0851h:
	dec sp			;0851
	dec sp			;0852
	dec sp			;0853
	dec sp			;0854
l0855h:
	ld l,02eh		;0855
	ld l,02eh		;0857
l0859h:
	ld l,02eh		;0859
	ld l,02eh		;085b
	ld l,02eh		;085d
	ld l,02eh		;085f
	ld l,02eh		;0861
	ld l,02eh		;0863
	ld l,02eh		;0865
	ld l,02eh		;0867
	ld l,02eh		;0869
	ld l,02eh		;086b
	ld l,02eh		;086d
	ld l,02ch		;086f
	ld a,a			;0871
	ld c,l			;0872
	jr nz,l0895h		;0873
	jr nz,l0897h		;0875
	ld c,(hl)			;0877
	ld d,b			;0878
	jr nz,l089bh		;0879
	jr nz,l08abh		;087b
l087dh:
	inc l			;087d
	ld a,a			;087e
	jr nz,l08a1h		;087f
	jr nz,l08a3h		;0881
	jr nz,l08a5h		;0883
	jr nz,$+34		;0885
	jr nz,l08a9h		;0887
	jr nz,l08abh		;0889
	jr nz,l08adh		;088b
	jr nz,l08afh		;088d
	jr nz,l08b1h		;088f
	jr nz,l08b3h		;0891
	jr nz,l08b5h		;0893
l0895h:
	jr nz,l08b7h		;0895
l0897h:
	jr nz,l08b9h		;0897
	jr nz,l08bbh		;0899
l089bh:
	jr nz,l08bdh		;089b
	jr nz,l08bfh		;089d
	jr nz,l08c1h		;089f
l08a1h:
	jr nz,l08c3h		;08a1
l08a3h:
	jr nz,l08c5h		;08a3
l08a5h:
	ld c,l			;08a5
	ld l,020h		;08a6
	inc l			;08a8
l08a9h:
	ld d,b			;08a9
	ld c,l			;08aa
l08abh:
	ld c,l			;08ab
	ld c,l			;08ac
l08adh:
	ld c,l			;08ad
	ld c,l			;08ae
l08afh:
	ld c,l			;08af
	ld c,l			;08b0
l08b1h:
	ld c,l			;08b1
	ld c,l			;08b2
l08b3h:
	ld c,l			;08b3
	ld c,l			;08b4
l08b5h:
	ld c,(hl)			;08b5
	ld c,(hl)			;08b6
l08b7h:
	ld c,l			;08b7
	ld c,l			;08b8
l08b9h:
	inc l			;08b9
	inc l			;08ba
l08bbh:
	inc l			;08bb
	inc l			;08bc
l08bdh:
	inc l			;08bd
	inc l			;08be
l08bfh:
	inc l			;08bf
	inc l			;08c0
l08c1h:
	ld l,020h		;08c1
l08c3h:
	jr nz,l08e5h		;08c3
l08c5h:
	jr nz,$+34		;08c5
	jr nz,$+34		;08c7
	jr nz,$+34		;08c9
	ld l,02eh		;08cb
	ld c,(hl)			;08cd
	inc l			;08ce
	inc l			;08cf
	jr nz,l08f2h		;08d0
	jr nz,l08f4h		;08d2
	jr nz,l08f6h		;08d4
	jr nz,l08f8h		;08d6
	jr nz,l08fah		;08d8
	jr nz,l091ah		;08da
	ld e,(hl)			;08dc
	dec sp			;08dd
	dec sp			;08de
	dec sp			;08df
	dec sp			;08e0
	dec sp			;08e1
	dec sp			;08e2
	dec sp			;08e3
	dec sp			;08e4
l08e5h:
	dec sp			;08e5
	ld l,02eh		;08e6
	ld l,02eh		;08e8
	ld l,02eh		;08ea
	ld l,02eh		;08ec
	ld l,02eh		;08ee
	ld l,02eh		;08f0
l08f2h:
	ld l,02eh		;08f2
l08f4h:
	ld l,02eh		;08f4
l08f6h:
	ld l,02eh		;08f6
l08f8h:
	ld l,02eh		;08f8
l08fah:
	ld l,02eh		;08fa
	ld l,02eh		;08fc
	ld l,02eh		;08fe
	ld l,02eh		;0900
	ld l,02eh		;0902
	ld l,02eh		;0904
	ld l,02eh		;0906
	ld l,02eh		;0908
	ld l,02eh		;090a
	ld l,02eh		;090c
	ld l,04eh		;090e
	inc l			;0910
	ld a,a			;0911
	jr nz,l0934h		;0912
	jr nz,l0936h		;0914
	jr nz,l0938h		;0916
	jr nz,l093ah		;0918
l091ah:
	jr nz,l093ch		;091a
	jr nz,l093eh		;091c
	jr nz,l0940h		;091e
	jr nz,l0942h		;0920
	jr nz,l0944h		;0922
	jr nz,l0946h		;0924
	jr nz,l0948h		;0926
	jr nz,l094ah		;0928
	jr nz,l094ch		;092a
	jr nz,l094eh		;092c
	jr nz,l0950h		;092e
	jr nz,l0952h		;0930
	jr nz,l0954h		;0932
l0934h:
	jr nz,l0956h		;0934
l0936h:
	jr nz,l0958h		;0936
l0938h:
	jr nz,l095ah		;0938
l093ah:
	jr nz,l095ch		;093a
l093ch:
	ld l,02eh		;093c
l093eh:
	ld l,02eh		;093e
l0940h:
	ld c,l			;0940
	inc l			;0941
l0942h:
	jr nz,$+34		;0942
l0944h:
	jr nz,l0966h		;0944
l0946h:
	ld l,02eh		;0946
l0948h:
	ld l,02eh		;0948
l094ah:
	ld l,02eh		;094a
l094ch:
	ld c,l			;094c
	ld c,l			;094d
l094eh:
	inc l			;094e
	ld d,b			;094f
l0950h:
	ld d,b			;0950
	ld d,b			;0951
l0952h:
	ld d,b			;0952
	ld c,l			;0953
l0954h:
	ld c,l			;0954
	ld c,l			;0955
l0956h:
	ld c,l			;0956
	ld c,l			;0957
l0958h:
	ld c,l			;0958
	ld c,l			;0959
l095ah:
	ld l,02eh		;095a
l095ch:
	ld l,02eh		;095c
	ld l,02eh		;095e
	ld c,(hl)			;0960
	inc l			;0961
	ld d,b			;0962
	ld l,02eh		;0963
	ld d,b			;0965
l0966h:
	inc l			;0966
	inc l			;0967
	jr nz,$+34		;0968
	jr nz,$+34		;096a
	jr nz,$+34		;096c
	jr nz,$+34		;096e
	jr nz,$+34		;0970
	jr nz,$+34		;0972
	inc l			;0974
	inc l			;0975
	ld c,(hl)			;0976
	ld l,02eh		;0977
	jr nz,l099bh		;0979
	jr nz,l099dh		;097b
	jr nz,l099fh		;097d
	jr nz,l09a1h		;097f
	jr nz,l09a3h		;0981
	jr nz,l09a5h		;0983
	jr nz,l09a7h		;0985
	jr nz,l09b7h		;0987
	ld l,02eh		;0989
	ld l,02eh		;098b
	ld l,02eh		;098d
	ld l,02eh		;098f
	ld l,02eh		;0991
	ld l,02eh		;0993
	ld l,02eh		;0995
	ld l,02eh		;0997
	ld l,02eh		;0999
l099bh:
	ld l,02eh		;099b
l099dh:
	ld l,02eh		;099d
l099fh:
	ld l,02eh		;099f
l09a1h:
	ld l,02eh		;09a1
l09a3h:
	ld l,02eh		;09a3
l09a5h:
	ld l,02eh		;09a5
l09a7h:
	ld l,02eh		;09a7
	ld l,02eh		;09a9
	ld c,(hl)			;09ab
	ld c,(hl)			;09ac
	ld c,(hl)			;09ad
	ld c,(hl)			;09ae
	ld c,(hl)			;09af
	ld c,(hl)			;09b0
	ld c,(hl)			;09b1
	ld l,02ch		;09b2
	ld a,a			;09b4
	jr nz,l09d7h		;09b5
l09b7h:
	jr nz,l09d9h		;09b7
	jr nz,l09dbh		;09b9
	jr nz,l09ddh		;09bb
	jr nz,l09dfh		;09bd
	jr nz,l09e1h		;09bf
	jr nz,l09e3h		;09c1
	jr nz,l09e5h		;09c3
	jr nz,l09e7h		;09c5
	jr nz,l09e9h		;09c7
	jr nz,l09ebh		;09c9
	jr nz,l09edh		;09cb
	jr nz,l09efh		;09cd
	jr nz,l09f1h		;09cf
	jr nz,l09f3h		;09d1
	jr nz,l09f5h		;09d3
	jr nz,l09f7h		;09d5
l09d7h:
	jr nz,l09f9h		;09d7
l09d9h:
	jr nz,l09fbh		;09d9
l09dbh:
	jr nz,l0a0bh		;09db
l09ddh:
	ld l,02eh		;09dd
l09dfh:
	ld l,02eh		;09df
l09e1h:
	ld l,02eh		;09e1
l09e3h:
	ld l,02eh		;09e3
l09e5h:
	ld l,02eh		;09e5
l09e7h:
	ld l,02eh		;09e7
l09e9h:
	ld l,02eh		;09e9
l09ebh:
	ld l,02eh		;09eb
l09edh:
	ld l,02eh		;09ed
l09efh:
	ld l,02eh		;09ef
l09f1h:
	ld l,02eh		;09f1
l09f3h:
	ld l,02eh		;09f3
l09f5h:
	ld l,02eh		;09f5
l09f7h:
	ld l,02eh		;09f7
l09f9h:
	ld l,02eh		;09f9
l09fbh:
	ld l,02eh		;09fb
	ld l,02eh		;09fd
	ld l,02eh		;09ff
	ld l,02eh		;0a01
	ld l,02eh		;0a03
	ld c,l			;0a05
	inc l			;0a06
	jr nz,l0a29h		;0a07
	jr nz,l0a2bh		;0a09
l0a0bh:
	jr nz,l0a2dh		;0a0b
	jr nz,l0a2fh		;0a0d
	jr nz,l0a31h		;0a0f
	jr nz,l0a33h		;0a11
	jr nz,l0a35h		;0a13
	jr nz,$+34		;0a15
	jr nz,$+34		;0a17
	jr nz,l0a3bh		;0a19
	jr nz,l0a3dh		;0a1b
	jr nz,l0a3fh		;0a1d
	jr nz,l0a41h		;0a1f
	jr nz,l0a43h		;0a21
	jr nz,l0a45h		;0a23
	jr nz,l0a47h		;0a25
	jr nz,$+34		;0a27
l0a29h:
	jr nz,$+34		;0a29
l0a2bh:
	jr nz,$+34		;0a2b
l0a2dh:
	ld c,l			;0a2d
	inc l			;0a2e
l0a2fh:
	jr nz,$+34		;0a2f
l0a31h:
	jr nz,$+34		;0a31
l0a33h:
	jr nz,l0a63h		;0a33
l0a35h:
	ld c,(hl)			;0a35
	jr nz,l0a85h		;0a36
	jr nz,l0a5ah		;0a38
	inc l			;0a3a
l0a3bh:
	jr nz,l0a8ah		;0a3b
l0a3dh:
	jr nz,l0a6bh		;0a3d
l0a3fh:
	jr nz,l0a8eh		;0a3f
l0a41h:
	jr nz,l0a91h		;0a41
l0a43h:
	inc l			;0a43
	inc l			;0a44
l0a45h:
	inc l			;0a45
	inc l			;0a46
l0a47h:
	inc l			;0a47
	ld l,050h		;0a48
	jr nz,l0a6ch		;0a4a
	jr nz,l0a6eh		;0a4c
	jr nz,l0a70h		;0a4e
	jr nz,l0a72h		;0a50
	jr nz,l0a74h		;0a52
	jr nz,l0a76h		;0a54
	jr nz,l0a78h		;0a56
	jr nz,l0a7ah		;0a58
l0a5ah:
	inc l			;0a5a
	inc l			;0a5b
	inc l			;0a5c
	inc l			;0a5d
	inc l			;0a5e
	inc l			;0a5f
	inc l			;0a60
	inc l			;0a61
	inc l			;0a62
l0a63h:
	inc l			;0a63
	inc l			;0a64
	ld c,(hl)			;0a65
	ld d,a			;0a66
	ld c,(hl)			;0a67
	ld c,(hl)			;0a68
	ld c,(hl)			;0a69
	inc l			;0a6a
l0a6bh:
	ld d,a			;0a6b
l0a6ch:
	ld c,(hl)			;0a6c
	ld c,(hl)			;0a6d
l0a6eh:
	ld c,(hl)			;0a6e
	ld c,(hl)			;0a6f
l0a70h:
	ld d,a			;0a70
	inc l			;0a71
l0a72h:
	inc l			;0a72
	inc l			;0a73
l0a74h:
	inc l			;0a74
	ld c,(hl)			;0a75
l0a76h:
	ld c,(hl)			;0a76
	ld c,(hl)			;0a77
l0a78h:
	ld d,a			;0a78
	ld c,l			;0a79
l0a7ah:
	ld c,l			;0a7a
	ld c,l			;0a7b
	ld c,l			;0a7c
	ld c,l			;0a7d
	ld c,l			;0a7e
	ld c,l			;0a7f
	ld c,l			;0a80
	ld c,l			;0a81
	ld c,l			;0a82
	ld c,l			;0a83
	ld c,l			;0a84
l0a85h:
	ld c,l			;0a85
	ld c,l			;0a86
	ld c,l			;0a87
	ld c,l			;0a88
	ld c,l			;0a89
l0a8ah:
	ld c,l			;0a8a
	ld c,l			;0a8b
	ld c,l			;0a8c
	ld c,l			;0a8d
l0a8eh:
	ld c,l			;0a8e
	ld l,02eh		;0a8f
l0a91h:
	ld l,02eh		;0a91
	ld l,02eh		;0a93
	ld l,02eh		;0a95
	ld c,(hl)			;0a97
	ld c,(hl)			;0a98
	ld l,052h		;0a99
	inc l			;0a9b
	inc l			;0a9c
	ld d,d			;0a9d
	ld d,d			;0a9e
	ld c,(hl)			;0a9f
	ld l,020h		;0aa0
	jr nz,$+34		;0aa2
	ld c,(hl)			;0aa4
	inc l			;0aa5
	jr nz,$+34		;0aa6
	jr nz,$+80		;0aa8
	ld b,a			;0aaa
	inc l			;0aab
	ld b,a			;0aac
	ld c,(hl)			;0aad
	ld b,a			;0aae
	ld l,02eh		;0aaf
	ld c,(hl)			;0ab1
	ld a,a			;0ab2
	jr nz,l0ad5h		;0ab3
	jr nz,l0ae3h		;0ab5
	inc l			;0ab7
	ld l,020h		;0ab8
	inc l			;0aba
	inc l			;0abb
	ld c,(hl)			;0abc
	jr nz,l0adfh		;0abd
	jr nz,l0ae1h		;0abf
	jr nz,l0ae3h		;0ac1
	jr nz,l0af1h		;0ac3
	jr nz,l0ae7h		;0ac5
	jr nz,l0ae9h		;0ac7
	jr nz,l0b18h		;0ac9
	ld c,l			;0acb
	ld c,l			;0acc
	ld c,l			;0acd
	ld c,l			;0ace
	ld c,l			;0acf
	ld c,l			;0ad0
	ld c,l			;0ad1
	ld c,l			;0ad2
	ld c,l			;0ad3
	ld c,l			;0ad4
l0ad5h:
	ld c,l			;0ad5
	ld c,l			;0ad6
	ld l,02eh		;0ad7
	jr nz,l0afbh		;0ad9
	jr nz,l0afdh		;0adb
	jr nz,l0affh		;0add
l0adfh:
	jr nz,l0b01h		;0adf
l0ae1h:
	jr nz,l0b03h		;0ae1
l0ae3h:
	jr nz,l0b05h		;0ae3
	jr nz,l0b07h		;0ae5
l0ae7h:
	jr nz,l0b09h		;0ae7
l0ae9h:
	ld c,l			;0ae9
	inc l			;0aea
	ld c,(hl)			;0aeb
	ld l,020h		;0aec
	ld c,l			;0aee
	inc l			;0aef
	inc l			;0af0
l0af1h:
	jr nz,l0b13h		;0af1
	jr nz,l0b15h		;0af3
	jr nz,l0b17h		;0af5
	jr nz,l0b19h		;0af7
	jr nz,l0b1bh		;0af9
l0afbh:
	jr nz,l0b29h		;0afb
l0afdh:
	jr nz,l0b1fh		;0afd
l0affh:
	jr nz,l0b2fh		;0aff
l0b01h:
	ld l,02eh		;0b01
l0b03h:
	ld l,02eh		;0b03
l0b05h:
	ld l,02eh		;0b05
l0b07h:
	ld l,02eh		;0b07
l0b09h:
	ld d,a			;0b09
	inc l			;0b0a
	ld c,(hl)			;0b0b
	ld c,(hl)			;0b0c
	dec sp			;0b0d
	dec sp			;0b0e
	dec sp			;0b0f
	inc l			;0b10
	inc l			;0b11
	dec hl			;0b12
l0b13h:
	dec hl			;0b13
	dec hl			;0b14
l0b15h:
	dec hl			;0b15
	dec hl			;0b16
l0b17h:
	dec hl			;0b17
l0b18h:
	dec hl			;0b18
l0b19h:
	dec hl			;0b19
	dec hl			;0b1a
l0b1bh:
	dec hl			;0b1b
	dec hl			;0b1c
	dec hl			;0b1d
	dec hl			;0b1e
l0b1fh:
	dec hl			;0b1f
	ld d,a			;0b20
	ld c,(hl)			;0b21
	ld c,(hl)			;0b22
	ld c,(hl)			;0b23
	inc l			;0b24
	inc l			;0b25
	dec hl			;0b26
	dec hl			;0b27
	dec hl			;0b28
l0b29h:
	dec hl			;0b29
	dec hl			;0b2a
	dec hl			;0b2b
	dec hl			;0b2c
	dec hl			;0b2d
	dec hl			;0b2e
l0b2fh:
	dec hl			;0b2f
	dec hl			;0b30
	dec hl			;0b31
	dec hl			;0b32
	dec hl			;0b33
	dec hl			;0b34
	dec hl			;0b35
	dec hl			;0b36
	dec hl			;0b37
	dec hl			;0b38
	dec hl			;0b39
	dec hl			;0b3a
	dec hl			;0b3b
	dec hl			;0b3c
	ld d,a			;0b3d
	ld c,(hl)			;0b3e
	ld c,(hl)			;0b3f
	ld c,(hl)			;0b40
	dec hl			;0b41
	dec hl			;0b42
	dec hl			;0b43
	dec hl			;0b44
	dec hl			;0b45
	dec hl			;0b46
	dec hl			;0b47
	dec hl			;0b48
	dec hl			;0b49
	dec hl			;0b4a
	ld hl,(02b2bh)		;0b4b
	dec hl			;0b4e
	dec hl			;0b4f
	dec hl			;0b50
	dec hl			;0b51
	dec hl			;0b52
	dec hl			;0b53
	dec hl			;0b54
	dec hl			;0b55
	dec hl			;0b56
	dec hl			;0b57
	ld d,a			;0b58
	ld c,(hl)			;0b59
	ld c,(hl)			;0b5a
	ld c,(hl)			;0b5b
	inc l			;0b5c
	dec hl			;0b5d
	dec hl			;0b5e
	dec hl			;0b5f
	dec hl			;0b60
	dec hl			;0b61
	dec hl			;0b62
	dec hl			;0b63
	dec hl			;0b64
	dec hl			;0b65
	dec hl			;0b66
	dec hl			;0b67
	dec hl			;0b68
	dec hl			;0b69
	dec hl			;0b6a
	dec hl			;0b6b
	dec hl			;0b6c
	dec hl			;0b6d
	dec hl			;0b6e
	dec hl			;0b6f
	dec hl			;0b70
	dec hl			;0b71
	dec hl			;0b72
	dec hl			;0b73
	dec hl			;0b74
	dec hl			;0b75
	dec hl			;0b76
	ld d,a			;0b77
	ld c,l			;0b78
	ld c,l			;0b79
	ld c,l			;0b7a
	ld c,l			;0b7b
	ld c,l			;0b7c
	ld c,l			;0b7d
	ld c,l			;0b7e
	ld c,l			;0b7f
	ld c,l			;0b80
	ld c,l			;0b81
	ld c,l			;0b82
	ld c,l			;0b83
	ld c,l			;0b84
	ld c,l			;0b85
	ld c,l			;0b86
	ld c,l			;0b87
	ld l,07fh		;0b88
	ld a,a			;0b8a
	ld a,a			;0b8b
	ld l,07fh		;0b8c
	ld a,a			;0b8e
	ld a,a			;0b8f
	ld a,a			;0b90
	ld a,a			;0b91
	ld a,a			;0b92
	ld a,a			;0b93
	ld a,a			;0b94
	ld a,a			;0b95
	inc l			;0b96
	inc l			;0b97
	inc l			;0b98
	inc l			;0b99
	inc l			;0b9a
	inc l			;0b9b
	ld c,(hl)			;0b9c
	jr nz,l0bbfh		;0b9d
	jr nz,l0bc1h		;0b9f
	jr nz,l0bcfh		;0ba1
	inc l			;0ba3
	dec hl			;0ba4
	dec hl			;0ba5
	dec hl			;0ba6
	dec hl			;0ba7
	dec hl			;0ba8
	dec hl			;0ba9
	dec hl			;0baa
	dec hl			;0bab
	dec hl			;0bac
	dec hl			;0bad
	dec hl			;0bae
	ld a,a			;0baf
	ld a,a			;0bb0
	ld a,a			;0bb1
	ld c,(hl)			;0bb2
	jr nz,l0bd5h		;0bb3
	jr nz,l0bd7h		;0bb5
	jr nz,l0be5h		;0bb7
	dec hl			;0bb9
	dec hl			;0bba
	dec hl			;0bbb
	dec hl			;0bbc
	dec hl			;0bbd
	dec hl			;0bbe
l0bbfh:
	dec hl			;0bbf
	dec hl			;0bc0
l0bc1h:
	dec hl			;0bc1
	dec hl			;0bc2
	dec hl			;0bc3
	dec hl			;0bc4
	dec hl			;0bc5
	jr nz,l0be8h		;0bc6
	ld l,04eh		;0bc8
	jr nz,l0bech		;0bca
	jr nz,l0bf9h		;0bcc
	dec hl			;0bce
l0bcfh:
	dec hl			;0bcf
	dec hl			;0bd0
	dec hl			;0bd1
	dec hl			;0bd2
	dec hl			;0bd3
	dec hl			;0bd4
l0bd5h:
	dec hl			;0bd5
	dec hl			;0bd6
l0bd7h:
	dec hl			;0bd7
	dec hl			;0bd8
	dec hl			;0bd9
	jr nz,l0c29h		;0bda
	ld c,l			;0bdc
	ld c,l			;0bdd
	ld c,l			;0bde
	ld c,l			;0bdf
	ld c,l			;0be0
	ld c,l			;0be1
	ld c,l			;0be2
	ld c,l			;0be3
	ld c,l			;0be4
l0be5h:
	ld c,l			;0be5
	ld c,l			;0be6
	ld c,l			;0be7
l0be8h:
	ld c,l			;0be8
	ld c,l			;0be9
	ld c,l			;0bea
	ld c,l			;0beb
l0bech:
	ld c,l			;0bec
	ld l,07fh		;0bed
	ld a,a			;0bef
	ld a,a			;0bf0
	ld l,07fh		;0bf1
	ld a,a			;0bf3
	ld a,a			;0bf4
	ld a,a			;0bf5
	ld a,a			;0bf6
	ld a,a			;0bf7
	ld a,a			;0bf8
l0bf9h:
	ld c,l			;0bf9
	inc l			;0bfa
	inc l			;0bfb
	ld a,a			;0bfc
	ld a,a			;0bfd
	ld a,a			;0bfe
	inc l			;0bff
	inc l			;0c00
	inc l			;0c01
	inc l			;0c02
	ld a,a			;0c03
	ld a,a			;0c04
	ld l,02eh		;0c05
	ld l,020h		;0c07
	inc l			;0c09
	inc l			;0c0a
	ld c,l			;0c0b
	ld c,l			;0c0c
	ld c,(hl)			;0c0d
	inc l			;0c0e
	inc l			;0c0f
	ld l,02eh		;0c10
	jr nz,$+34		;0c12
	ld l,02eh		;0c14
	ld l,02eh		;0c16
	jr nz,l0c46h		;0c18
	jr nz,$+34		;0c1a
	ld l,04dh		;0c1c
	jr nz,$+46		;0c1e
	inc l			;0c20
	inc l			;0c21
	inc l			;0c22
	ld c,(hl)			;0c23
	jr nz,$+79		;0c24
	ld c,l			;0c26
	ld l,020h		;0c27
l0c29h:
	jr nz,$+34		;0c29
	ld l,02eh		;0c2b
	ld l,02eh		;0c2d
	ld l,02eh		;0c2f
	ld l,02eh		;0c31
	ld l,02eh		;0c33
	ld l,02eh		;0c35
	ld l,02eh		;0c37
	ld l,02eh		;0c39
	ld l,02eh		;0c3b
	ld c,l			;0c3d
	ld c,l			;0c3e
	ld c,l			;0c3f
	ld c,l			;0c40
	ld c,l			;0c41
	ld c,l			;0c42
	ld l,04dh		;0c43
	ld c,(hl)			;0c45
l0c46h:
	ld (de),a			;0c46
init:
	; ZOGGINS
	; Select Page 1 on Dazzler II
	ld a,000h		
	out (018h),a	
	
	; ZOGGINS
	; Set DMA address
	ld a,008h		
	out (00eh),a
	
	jp l0568h		;0100