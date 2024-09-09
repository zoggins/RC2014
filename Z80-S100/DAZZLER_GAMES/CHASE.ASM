; z80dasm 1.1.6
; command line: z80dasm --labels --origin=0x0100 --address CHASE.COM

	org	00100h

l0100h:
	jp l0ae3h		;0100
l0103h:
	jp l0320h		;0103
	push af			;0106
	push bc			;0107
	push de			;0108
	push hl			;0109
	call 0000fh		;010a
	pop hl			;010d
	pop de			;010e
	pop bc			;010f
	pop af			;0110
	ret			;0111
	ld b,a			;0112
	and 070h		;0113
	jp z,000b6h		;0115
	ld a,b			;0118
	and 03fh		;0119
	rlca			;011b
	rlca			;011c
	rla			;011d
	ld e,a			;011e
	ld a,000h		;011f
	rla			;0121
	ld d,a			;0122
	ld a,(hl)			;0123
	push hl			;0124
	ld hl,00117h		;0125
	add hl,de			;0128
	push hl			;0129
	call 00079h		;012a
	pop de			;012d
	call 000a4h		;012e
	pop hl			;0131
	inc (hl)			;0132
	ret nz			;0133
	ld (hl),0f0h		;0134
	ld hl,01800h		;0136
	call 00055h		;0139
	ld hl,01a00h		;013c
	call 00055h		;013f
	ld hl,01c00h		;0142
	call 00048h		;0145
	ld hl,01e00h		;0148
	call 0006dh		;014b
	sub a			;014e
	ld b,0c0h		;014f
	ld (de),a			;0151
	inc de			;0152
	inc b			;0153
	jp nz,0004eh		;0154
	ret			;0157
	call 0006dh		;0158
	ld hl,00240h		;015b
	add hl,de			;015e
	nop			;015f
	ld bc,0ffc0h		;0160
	ld a,(hl)			;0163
	ld (de),a			;0164
	inc hl			;0165
	inc de			;0166
	inc c			;0167
	jp nz,00060h		;0168
	inc b			;016b
	jp nz,00060h		;016c
	ret			;016f
	push hl			;0170
	ld de,00040h		;0171
	add hl,de			;0174
	pop de			;0175
l0176h:
	ld bc,0fe40h		;0176
	jp 00060h		;0179
	ld hl,01800h		;017c
	ld b,a			;017f
	rla			;0180
	jp nc,00085h		;0181
	ld de,l0400h		;0184
	add hl,de			;0187
	rla			;0188
	rla			;0189
	rla			;018a
	rla			;018b
	jp nc,00090h		;018c
	ld de,l0200h		;018f
	add hl,de			;0192
	ld a,b			;0193
	and 070h		;0194
	rlca			;0196
	rla			;0197
	ld e,a			;0198
	ld a,000h		;0199
	rla			;019b
	ld d,a			;019c
	add hl,de			;019d
	ld a,b			;019e
	and 007h		;019f
	rlca			;01a1
	ld d,000h		;01a2
	ld e,a			;01a4
	add hl,de			;01a5
	ret			;01a6
	ld bc,0000fh		;01a7
	call 000aah		;01aa
	call 000adh		;01ad
	ld a,(de)			;01b0
	ld (hl),a			;01b1
	inc hl			;01b2
	inc de			;01b3
	ld a,(de)			;01b4
	ld (hl),a			;01b5
	add hl,bc			;01b6
	inc de			;01b7
	ret			;01b8
	ld a,b			;01b9
	and 07fh		;01ba
	sub 008h		;01bc
	jp z,000d6h		;01be
	dec a			;01c1
	jp z,000dbh		;01c2
	dec a			;01c5
	jp z,000e0h		;01c6
	dec a			;01c9
	jp z,000fah		;01ca
	sub 002h		;01cd
	jp z,000e7h		;01cf
	dec a			;01d2
	ret nz			;01d3
	ld a,0f0h		;01d4
	add a,(hl)			;01d6
	ld (hl),a			;01d7
	ret			;01d8
	ld a,0ffh		;01d9
	add a,(hl)			;01db
	ld (hl),a			;01dc
	ret			;01dd
	ld a,001h		;01de
	add a,(hl)			;01e0
	ld (hl),a			;01e1
	ret			;01e2
	ld a,010h		;01e3
	add a,(hl)			;01e5
	ld (hl),a			;01e6
	jp 00030h		;01e7
	push hl			;01ea
	ld a,0a0h		;01eb
	call 0000fh		;01ed
	pop hl			;01f0
	ld a,(hl)			;01f1
	and 00fh		;01f2
l01f4h:
	jp nz,000e7h		;01f4
	ld a,(hl)			;01f7
	cp 000h		;01f8
	jp 00030h		;01fa
	ld a,000h		;01fd
	ld (hl),a			;01ff
l0200h:
	ld hl,01800h		;0200
	ld de,0f800h		;0203
	ld (hl),a			;0206
	inc hl			;0207
	inc e			;0208
	jp nz,l0103h		;0209
	inc d			;020c
	jp nz,l0103h		;020d
	ret			;0210
	nop			;0211
	nop			;0212
	nop			;0213
	nop			;0214
	nop			;0215
	nop			;0216
	nop			;0217
	nop			;0218
	nop			;0219
	jr c,$+11		;021a
	xor d			;021c
	dec bc			;021d
	ld hl,(03003h)		;021e
	ld bc,00938h		;0221
	jp z,l0a0eh		;0224
	ld a,(bc)			;0227
	ld (bc),a			;0228
	ld (bc),a			;0229
	ld a,(0ca09h)		;022a
	ld b,00ah		;022d
	ld a,(bc)			;022f
	ld (03801h),a		;0230
	add hl,bc			;0233
	ld a,(bc)			;0234
	nop			;0235
	ld a,(bc)			;0236
	ex af,af'			;0237
	jr nc,$+3		;0238
	ld a,(00a04h)		;023a
	ld a,(bc)			;023d
	ld a,(bc)			;023e
	ld b,032h		;023f
	nop			;0241
	ld a,(0ca03h)		;0242
	inc b			;0245
	ld a,(bc)			;0246
	nop			;0247
	ld (03a03h),a		;0248
	inc bc			;024b
	jp z,00a04h		;024c
	nop			;024f
	ld (bc),a			;0250
	nop			;0251
	jr c,l0257h		;0252
	ld a,(bc)			;0254
	inc c			;0255
	ld a,(bc)			;0256
l0257h:
	ld a,(bc)			;0257
	jr nc,$+5		;0258
	ld a,(bc)			;025a
	ld a,(bc)			;025b
	jp z,l0a0eh		;025c
	ld a,(bc)			;025f
	ld (bc),a			;0260
	ld (bc),a			;0261
	or b			;0262
	ld bc,000a0h		;0263
	and b			;0266
	nop			;0267
	jr nc,$+3		;0268
	jr nz,l0273h		;026a
	nop			;026c
	dec b			;026d
	ex af,af'			;026e
	dec b			;026f
	jr nc,l0272h		;0270
l0272h:
	ld a,(bc)			;0272
l0273h:
	ld b,06ah		;0273
	nop			;0275
	ld hl,(00204h)		;0276
	ld (bc),a			;0279
	ld a,(bc)			;027a
	nop			;027b
	ld a,(bc)			;027c
	nop			;027d
	ld a,(bc)			;027e
	nop			;027f
	ld (04a03h),a		;0280
	ld c,0aah		;0283
	ld a,(bc)			;0285
	ld a,(bc)			;0286
	ld a,(bc)			;0287
	ld (bc),a			;0288
	ld (bc),a			;0289
	ld a,(bc)			;028a
	ld a,(bc)			;028b
	sbc a,d			;028c
	ld a,(bc)			;028d
	ld a,(bc)			;028e
	dec bc			;028f
	ld (bc),a			;0290
	ld (bc),a			;0291
	jr c,l029dh		;0292
	ld a,(bc)			;0294
	ld a,(bc)			;0295
	ld a,(bc)			;0296
	ld a,(bc)			;0297
	jr nc,$+3		;0298
	ld a,(0ca09h)		;029a
l029dh:
	ld b,00ah		;029d
	nop			;029f
	ld (bc),a			;02a0
	nop			;02a1
	jr c,l02adh		;02a2
	ld a,(bc)			;02a4
	ld a,(bc)			;02a5
	ld hl,(03006h)		;02a6
	add hl,bc			;02a9
	ld a,(0ca09h)		;02aa
l02adh:
	ld b,02ah		;02ad
	inc b			;02af
	ld (bc),a			;02b0
	ld (bc),a			;02b1
	jr c,l02b7h		;02b2
	jp nz,00004h		;02b4
l02b7h:
	ld a,(bc)			;02b7
	ld (0b201h),a		;02b8
	inc bc			;02bb
	and b			;02bc
	nop			;02bd
	and b			;02be
	nop			;02bf
	jr nz,l02c2h		;02c0
l02c2h:
	ld a,(bc)			;02c2
	ld a,(bc)			;02c3
	ld a,(bc)			;02c4
	ld a,(bc)			;02c5
	ld a,(bc)			;02c6
	ld a,(bc)			;02c7
	jr nc,l02cbh		;02c8
	ld a,(bc)			;02ca
l02cbh:
	ld a,(bc)			;02cb
	ld a,(bc)			;02cc
	ld a,(bc)			;02cd
	ld b,d			;02ce
	ld b,020h		;02cf
	nop			;02d1
	ld a,(bc)			;02d2
	ld a,(bc)			;02d3
	ld a,(bc)			;02d4
	ld a,(bc)			;02d5
	xor d			;02d6
	ld a,(bc)			;02d7
	djnz l02dbh		;02d8
	ld a,(bc)			;02da
l02dbh:
	ld a,(bc)			;02db
	sub b			;02dc
	ld bc,l0918h		;02dd
	ld (bc),a			;02e0
	ld (bc),a			;02e1
	ld a,(bc)			;02e2
	ld a,(bc)			;02e3
	ld b,d			;02e4
	ld b,0a0h		;02e5
	nop			;02e7
	jr nz,l02eah		;02e8
l02eah:
	ld (0800bh),a		;02ea
	ld bc,00018h		;02ed
	ld (07003h),a		;02f0
	ld bc,00050h		;02f3
	ld d,b			;02f6
	nop			;02f7
	jr nc,l02fbh		;02f8
	ex af,af'			;02fa
l02fbh:
	nop			;02fb
	sub b			;02fc
	nop			;02fd
	nop			;02fe
	add hl,bc			;02ff
	nop			;0300
	nop			;0301
	jr nc,$+7		;0302
	nop			;0304
	dec b			;0305
	nop			;0306
	dec b			;0307
	jr nc,l030bh		;0308
	nop			;030a
l030bh:
	nop			;030b
	ld h,b			;030c
	inc b			;030d
	ld (bc),a			;030e
	ld (bc),a			;030f
	nop			;0310
	nop			;0311
	nop			;0312
	nop			;0313
	nop			;0314
	nop			;0315
	nop			;0316
	nop			;0317
	ld (00003h),a		;0318
	nop			;031b
	nop			;031c
	nop			;031d
	nop			;031e
	nop			;031f
l0320h:
	nop			;0320
	nop			;0321
	and b			;0322
	nop			;0323
	and b			;0324
	nop			;0325
	nop			;0326
	nop			;0327
	jr nz,l032ah		;0328
l032ah:
	ld d,b			;032a
	dec b			;032b
l032ch:
	djnz l032fh		;032c
	nop			;032e
l032fh:
	nop			;032f
	nop			;0330
l0331h:
	nop			;0331
	ld d,b			;0332
	dec b			;0333
	ld (hl),d			;0334
	rla			;0335
	ld (hl),d			;0336
	rla			;0337
	djnz l033bh		;0338
	ret po			;033a
l033bh:
	inc c			;033b
	jp po,0e804h		;033c
	ld b,020h		;033f
	nop			;0341
	ld e,d			;0342
	ex af,af'			;0343
	add a,b			;0344
	ld bc,00c18h		;0345
	nop			;0348
	inc bc			;0349
	ld h,b			;034a
	inc b			;034b
	ret nc			;034c
	ld b,02ah		;034d
	inc b			;034f
	jr nc,$+4		;0350
	add a,b			;0352
	ld bc,00010h		;0353
	nop			;0356
	nop			;0357
	nop			;0358
	nop			;0359
	add a,b			;035a
l035bh:
	ld bc,00050h		;035b
	sub b			;035e
	nop			;035f
l0360h:
	nop			;0360
	ld bc,00090h		;0361
	nop			;0364
	dec b			;0365
	add a,b			;0366
	ld bc,00010h		;0367
	add a,b			;036a
	nop			;036b
	jp po,0a206h		;036c
	ld (bc),a			;036f
	nop			;0370
	nop			;0371
	add a,b			;0372
	nop			;0373
	ret pe			;0374
	inc c			;0375
	and b			;0376
	nop			;0377
	nop			;0378
	nop			;0379
	nop			;037a
	nop			;037b
	nop			;037c
	nop			;037d
	ld d,b			;037e
	nop			;037f
	ld (bc),a			;0380
	nop			;0381
	nop			;0382
	nop			;0383
	ret z			;0384
	inc c			;0385
	nop			;0386
	nop			;0387
	nop			;0388
	nop			;0389
	nop			;038a
	nop			;038b
	ex af,af'			;038c
sub_038dh:
	nop			;038d
	ld (bc),a			;038e
	nop			;038f
	nop			;0390
	nop			;0391
	nop			;0392
	ex af,af'			;0393
	add a,b			;0394
	ld bc,00018h		;0395
	nop			;0398
	nop			;0399
	jr c,l03a5h		;039a
	adc a,d			;039c
	dec bc			;039d
	ld a,(de)			;039e
	ld a,(bc)			;039f
	jr nc,l03a3h		;03a0
	ret po			;03a2
l03a3h:
	nop			;03a3
	and b			;03a4
l03a5h:
	nop			;03a5
	and b			;03a6
	nop			;03a7
	jr nc,$+3		;03a8
	jr c,$+11		;03aa
	add a,b			;03ac
	ld b,078h		;03ad
	ex af,af'			;03af
	ld (03203h),a		;03b0
	rlca			;03b3
	jr nz,l03bah		;03b4
	ld b,b			;03b6
	ld a,(bc)			;03b7
	jr nc,l03bbh		;03b8
l03bah:
	add a,b			;03ba
l03bbh:
	dec b			;03bb
	jr $+7		;03bc
	ld (00007h),a		;03be
	ld bc,0013ah		;03c1
	ld (l0808h+1),a		;03c4
	ld a,(bc)			;03c7
	jr nc,l03cbh		;03c8
	ld h,b			;03ca
l03cbh:
	ld bc,l04cah		;03cb
	ld a,(bc)			;03ce
l03cfh:
	ld a,(bc)			;03cf
	jr nc,$+3		;03d0
	ld (0800bh),a		;03d2
	ld bc,00050h		;03d5
	djnz l03dah		;03d8
l03dah:
	jr c,$+11		;03da
	jp nz,l0a06h		;03dc
	ld a,(bc)			;03df
	jr nc,$+3		;03e0
	jr c,l03edh		;03e2
	jp nz,0000eh		;03e4
	ld b,030h		;03e7
	nop			;03e9
	ld d,b			;03ea
	nop			;03eb
	nop			;03ec
l03edh:
	nop			;03ed
	ld b,b			;03ee
sub_03efh:
	nop			;03ef
	djnz l03f2h		;03f0
l03f2h:
	ld d,b			;03f2
	nop			;03f3
	nop			;03f4
	nop			;03f5
	ld d,b			;03f6
	nop			;03f7
	ld (bc),a			;03f8
	nop			;03f9
	add a,b			;03fa
	ld bc,00018h		;03fb
	sub b			;03fe
	nop			;03ff
l0400h:
	nop			;0400
	ld bc,00000h		;0401
	ld (03203h),a		;0404
	inc bc			;0407
	nop			;0408
	nop			;0409
	ld b,d			;040a
	nop			;040b
	jr nz,l0412h		;040c
	ld h,b			;040e
	nop			;040f
	ld (bc),a			;0410
	nop			;0411
l0412h:
	jr c,l041dh		;0412
	nop			;0414
	ld b,020h		;0415
l0417h:
	nop			;0417
	jr nz,l041ah		;0418
l041ah:
	adc a,b			;041a
	adc a,000h		;041b
l041dh:
	ld hl,(0009fh)		;041d
	ld (bc),a			;0420
	ld h,(hl)			;0421
	rlca			;0422
	ld sp,01700h		;0423
	ld hl,l0417h		;0426
	call sub_05d9h		;0429
	call 003b9h		;042c
	call sub_0589h		;042f
	ld b,028h		;0432
	push bc			;0434
	ld hl,01738h		;0435
	call sub_0626h		;0438
	ld bc,01738h		;043b
	ld hl,l0808h		;043e
	ld de,l0820h		;0441
	call 008bdh		;0444
	call 005e8h		;0447
l044ah:
	call sub_038dh		;044a
	jp z,l0320h		;044d
	pop bc			;0450
	dec b			;0451
	jp nz,l0331h		;0452
	call sub_056ch		;0455
	jp nz,l032ch		;0458
	call sub_03efh		;045b
	call sub_0589h		;045e
	ld b,028h		;0461
	push bc			;0463
	ld hl,01739h		;0464
l0467h:
	call sub_0626h		;0467
	ld bc,01739h		;046a
	ld hl,l0820h		;046d
	ld de,l0808h		;0470
	call 008bdh		;0473
	call 005e8h		;0476
	call sub_038dh		;0479
l047ch:
	jp z,l0320h		;047c
	pop bc			;047f
	dec b			;0480
	jp nz,l0360h		;0481
	call sub_056ch		;0484
	jp nz,l035bh		;0487
	call 0039bh		;048a
	jp l032ch		;048d
	in a,(018h)		;0490
	and 008h		;0492
	ret z			;0494
	in a,(018h)		;0495
	rrca			;0497
	rrca			;0498
	rrca			;0499
	rrca			;049a
	and 008h		;049b
	ret			;049d
	ld a,(01727h)		;049e
	ld (l0467h),a		;04a1
	ld a,(01728h)		;04a4
	ld (l0467h+1),a		;04a7
	ld a,(01733h)		;04aa
	ld (00477h),a		;04ad
	ld a,(01734h)		;04b0
	ld (00478h),a		;04b3
	ld hl,l044ah		;04b6
	call sub_05d9h		;04b9
	ld hl,l047ch		;04bc
	call sub_05d9h		;04bf
	ld a,0fah		;04c2
	out (00fh),a		;04c4
	ld a,08ch		;04c6
	out (00eh),a		;04c8
l04cah:
	ld hl,l0599h		;04ca
	ld de,01726h		;04cd
	ld b,012h		;04d0
	ld a,(hl)			;04d2
	ld (de),a			;04d3
	inc de			;04d4
	inc hl			;04d5
	dec b			;04d6
	jp nz,l03cfh		;04d7
	ld b,001h		;04da
	call 00406h		;04dc
	ld a,000h		;04df
	ld (01738h),a		;04e1
	ld (01739h),a		;04e4
	ld a,078h		;04e7
	ld (0173ah),a		;04e9
	call sub_07ebh		;04ec
	jp l087fh		;04ef
	ld a,0fch		;04f2
	out (00fh),a		;04f4
	ld hl,l051ah		;04f6
	call sub_05d9h		;04f9
	ld b,002h		;04fc
	call 00406h		;04fe
	ld a,078h		;0501
	ld (0173ah),a		;0503
	jp l087fh		;0506
	in a,(018h)		;0509
	and b			;050b
	ret z			;050c
	ld a,b			;050d
	rlca			;050e
	rlca			;050f
	rlca			;0510
	rlca			;0511
	ld c,a			;0512
	in a,(018h)		;0513
	and c			;0515
	jp nz,00406h		;0516
	ret			;0519
l051ah:
	dec bc			;051a
	ld b,e			;051b
	ld d,d			;051c
	ld c,a			;051d
	ld c,l			;051e
	ld b,l			;051f
	ld c,l			;0520
	ld b,e			;0521
	ld c,a			;0522
	jr nz,l0569h		;0523
	ld b,c			;0525
	ld e,d			;0526
	ld e,d			;0527
	ld c,h			;0528
	ld b,l			;0529
	ld d,d			;052a
	ld b,e			;052b
	ld d,d			;052c
	ld c,a			;052d
	ld d,e			;052e
	ld d,e			;052f
	jr nz,l0573h		;0530
	ld c,(hl)			;0532
	ld b,h			;0533
	jr nz,l0579h		;0534
	ld c,c			;0536
	ld d,d			;0537
	ld b,e			;0538
	ld c,h			;0539
	ld b,l			;053a
	ld d,(hl)			;053b
	ld l,031h		;053c
	ld l,030h		;053e
	jr nz,l0562h		;0540
	jr nc,l057ch		;0542
	cpl			;0544
	inc sp			;0545
	jr nc,l0577h		;0546
	scf			;0548
	ld (hl),020h		;0549
	dec c			;054b
	nop			;054c
	dec bc			;054d
	ld b,a			;054e
	ld b,c			;054f
	ld c,l			;0550
	ld b,l			;0551
	jr nz,l05a3h		;0552
	ld d,(hl)			;0554
	ld b,l			;0555
	ld d,d			;0556
	jr nz,l0579h		;0557
	jr nz,l057bh		;0559
	jr nz,l057dh		;055b
	jr nz,sub_056ch		;055d
	ld d,b			;055f
	ld c,h			;0560
	ld b,c			;0561
l0562h:
	ld e,c			;0562
	ld b,l			;0563
	ld d,d			;0564
	jr nz,$+51		;0565
	jr nz,l0596h		;0567
l0569h:
	jr nz,l056bh		;0569
l056bh:
	nop			;056b
sub_056ch:
	jr nz,l058eh		;056c
	jr nz,l05c0h		;056e
	ld c,h			;0570
	ld b,c			;0571
	ld e,c			;0572
l0573h:
	ld b,l			;0573
	ld d,d			;0574
l0575h:
	jr nz,l05a9h		;0575
l0577h:
	jr nz,$+47		;0577
l0579h:
	jr nz,l057bh		;0579
l057bh:
	nop			;057b
l057ch:
	dec c			;057c
l057dh:
	dec c			;057d
	nop			;057e
	ld d,b			;057f
	ld d,l			;0580
	ld d,e			;0581
	ld c,b			;0582
	jr nz,l05c7h		;0583
	ld d,l			;0585
	ld d,h			;0586
	ld d,h			;0587
	ld c,a			;0588
sub_0589h:
	ld c,(hl)			;0589
	jr nz,l05dbh		;058a
	ld c,(hl)			;058c
	ld b,l			;058d
l058eh:
	jr nz,l05e4h		;058e
	ld c,a			;0590
	jr nz,$+85		;0591
	ld d,h			;0593
	ld b,c			;0594
	ld d,d			;0595
l0596h:
	ld d,h			;0596
	jr nz,l05e0h		;0597
l0599h:
	ld b,c			;0599
	ld c,l			;059a
	ld b,l			;059b
	ld l,020h		;059c
	jr nz,l05f0h		;059e
	ld c,h			;05a0
	ld b,c			;05a1
	ld e,c			;05a2
l05a3h:
	ld b,l			;05a3
	ld d,d			;05a4
	jr nz,l05d8h		;05a5
	jr nz,$+85		;05a7
l05a9h:
	ld d,h			;05a9
	ld b,c			;05aa
sub_05abh:
	ld d,d			;05ab
	ld d,h			;05ac
	ld d,e			;05ad
	jr nz,l05f2h		;05ae
	ld e,c			;05b0
	jr nz,$+82		;05b1
	ld c,h			;05b3
	ld b,c			;05b4
	ld e,c			;05b5
	ld c,c			;05b6
	ld c,(hl)			;05b7
	ld b,a			;05b8
	jr nz,$+86		;05b9
	ld c,b			;05bb
	ld b,l			;05bc
	jr nz,l05dfh		;05bd
	ld b,e			;05bf
l05c0h:
	ld d,d			;05c0
	ld c,a			;05c1
	ld d,e			;05c2
	ld d,e			;05c3
	ld l,020h		;05c4
l05c6h:
	ld d,h			;05c6
l05c7h:
	ld c,b			;05c7
	ld b,l			;05c8
	jr nz,l060eh		;05c9
	ld d,d			;05cb
	ld c,a			;05cc
	ld d,e			;05cd
	ld d,e			;05ce
	ld b,e			;05cf
	ld c,b			;05d0
	ld b,c			;05d1
sub_05d2h:
	ld d,e			;05d2
	ld b,l			;05d3
	ld d,e			;05d4
l05d5h:
	jr nz,l062bh		;05d5
	ld c,b			;05d7
l05d8h:
	ld b,l			;05d8
sub_05d9h:
	jr nz,l05fbh		;05d9
l05dbh:
	jr nz,l05fdh		;05db
	jr nz,l05ffh		;05dd
l05dfh:
	ld b,e			;05df
l05e0h:
	ld c,c			;05e0
	ld d,d			;05e1
	ld b,e			;05e2
	ld c,h			;05e3
l05e4h:
	ld b,l			;05e4
	ld l,020h		;05e5
	jr nz,l0609h		;05e7
	jr nz,l060bh		;05e9
l05ebh:
	jr nz,l060dh		;05eb
	jr nz,$+34		;05ed
	dec c			;05ef
l05f0h:
	ld d,b			;05f0
	ld d,l			;05f1
l05f2h:
	ld d,e			;05f2
	ld c,b			;05f3
	jr nz,l0638h		;05f4
	ld d,l			;05f6
	ld d,h			;05f7
	ld d,h			;05f8
	ld c,a			;05f9
	ld c,(hl)			;05fa
l05fbh:
	jr nz,l0643h		;05fb
l05fdh:
	ld c,a			;05fd
	ld d,l			;05fe
l05ffh:
	ld d,d			;05ff
	ld b,c			;0600
	ld d,h			;0601
	jr nz,$+67		;0602
	ld c,(hl)			;0604
	ld e,c			;0605
	jr nz,l065ch		;0606
	ld c,c			;0608
l0609h:
	ld c,l			;0609
	ld b,l			;060a
l060bh:
	jr nz,l0661h		;060b
l060dh:
	ld c,a			;060d
l060eh:
	jr nz,l0630h		;060e
	ld b,e			;0610
	ld b,c			;0611
	ld c,(hl)			;0612
	ld b,e			;0613
	ld b,l			;0614
	ld c,h			;0615
	jr nz,l065fh		;0616
	ld b,c			;0618
	ld c,l			;0619
	ld b,l			;061a
	ld l,000h		;061b
	dec bc			;061d
	ld d,b			;061e
	ld d,l			;061f
	ld d,e			;0620
	ld c,b			;0621
	jr nz,$+68		;0622
	ld d,l			;0624
	ld d,h			;0625
sub_0626h:
	ld d,h			;0626
	ld c,a			;0627
	ld c,(hl)			;0628
	jr nz,l067fh		;0629
l062bh:
	ld d,a			;062b
	ld c,a			;062c
	jr nz,$+86		;062d
	ld c,a			;062f
l0630h:
	jr nz,$+69		;0630
	ld c,a			;0632
	ld c,(hl)			;0633
	ld d,h			;0634
l0635h:
	ld l,020h		;0635
	ld b,a			;0637
l0638h:
	ld b,c			;0638
	ld c,l			;0639
	ld b,l			;063a
	ld l,020h		;063b
	jr nz,l068fh		;063d
	ld c,h			;063f
	ld b,c			;0640
	ld e,c			;0641
	ld b,l			;0642
l0643h:
	ld d,d			;0643
	jr nz,$+86		;0644
	ld d,a			;0646
	ld c,a			;0647
	jr nz,$+80		;0648
	ld c,a			;064a
	ld d,a			;064b
	jr nz,$+34		;064c
	ld b,e			;064e
	ld c,a			;064f
	ld c,(hl)			;0650
	ld d,h			;0651
	ld d,d			;0652
l0653h:
	ld c,a			;0653
	ld c,h			;0654
	ld d,e			;0655
	jr nz,l06ach		;0656
	ld c,b			;0658
	ld b,l			;0659
	jr nz,l067ch		;065a
l065ch:
	jr nz,$+34		;065c
	ld b,e			;065e
l065fh:
	ld d,d			;065f
	ld c,a			;0660
l0661h:
	ld d,e			;0661
	ld d,e			;0662
	ld l,020h		;0663
	jr nz,$+34		;0665
	jr nz,l0689h		;0667
	jr nz,$+34		;0669
	jr nz,$+34		;066b
	jr nz,l066fh		;066d
l066fh:
	ld a,(0173ah)		;066f
	dec a			;0672
	ld (0173ah),a		;0673
	inc a			;0676
	ret			;0677
	ld a,(01738h)		;0678
	ld b,a			;067b
l067ch:
	ld hl,01727h		;067c
l067fh:
	call sub_05d2h		;067f
	ld a,(01739h)		;0682
	ld b,a			;0685
sub_0686h:
	ld hl,01733h		;0686
l0689h:
	call sub_05d2h		;0689
	ld a,(0173ah)		;068c
l068fh:
	ld b,a			;068f
	ld hl,0172ch		;0690
	call 005cah		;0693
	ld hl,01726h		;0696
	jp sub_05d9h		;0699
	jr nz,l069eh		;069c
l069eh:
	nop			;069e
	jr nz,l06c1h		;069f
	jr nz,$+38		;06a1
	call c,020a1h		;06a3
	jr nz,l06c8h		;06a6
	jr nz,l06aah		;06a8
l06aah:
	nop			;06aa
	adc a,l			;06ab
l06ach:
	ld c,000h		;06ac
	ld de,0b0b0h		;06ae
	ld c,0b0h		;06b1
	ld a,b			;06b3
	and a			;06b4
	ret z			;06b5
	inc e			;06b6
	ld a,e			;06b7
	cp 0bah		;06b8
	jp nz,l05c6h		;06ba
	ld e,0b0h		;06bd
	inc d			;06bf
	ld a,d			;06c0
l06c1h:
	cp 0bah		;06c1
	jp nz,l05c6h		;06c3
	ld d,0b0h		;06c6
l06c8h:
	inc c			;06c8
	dec b			;06c9
	jp 005b2h		;06ca
	call sub_05abh		;06cd
	ld (hl),c			;06d0
	inc hl			;06d1
	jp l05d5h		;06d2
	call sub_05abh		;06d5
	ld (hl),d			;06d8
	inc hl			;06d9
	ld (hl),e			;06da
	ret			;06db
	ld a,(hl)			;06dc
	and a			;06dd
	ret z			;06de
	push hl			;06df
	ld hl,01700h		;06e0
	call 00003h		;06e3
	pop hl			;06e6
	inc hl			;06e7
	jp sub_05d9h		;06e8
	in a,(0ffh)		;06eb
	inc a			;06ed
	ld hl,l0200h+1		;06ee
	dec h			;06f1
	jp nz,005eeh		;06f2
	dec l			;06f5
	jp nz,005eeh		;06f6
	dec a			;06f9
	jp nz,l05ebh		;06fa
	ret			;06fd
	ld a,000h		;06fe
	ld (01725h),a		;0700
	ld hl,01709h		;0703
	ld b,008h		;0706
	ld c,009h		;0708
	ld d,007h		;070a
	ld (hl),b			;070c
	inc hl			;070d
sub_070eh:
	ld (hl),c			;070e
	inc hl			;070f
	ld a,007h		;0710
	add a,b			;0712
	ld b,a			;0713
l0714h:
	ld a,03ch		;0714
	add a,c			;0716
	ld c,a			;0717
	ld (hl),b			;0718
	inc hl			;0719
	ld (hl),c			;071a
	inc hl			;071b
	ld a,009h		;071c
	add a,b			;071e
	ld b,a			;071f
	ld a,0cch		;0720
	add a,c			;0722
	ld c,a			;0723
	dec d			;0724
	jp nz,l0609h		;0725
	ret			;0728
	push hl			;0729
	ld hl,01709h		;072a
	call 0063ch		;072d
	jp nz,l0635h		;0730
	pop hl			;0733
sub_0734h:
	inc (hl)			;0734
	jp l087fh		;0735
	ld a,(hl)			;0738
	and a			;0739
	jp nz,0062ah		;073a
	pop hl			;073d
	ret			;073e
l073fh:
	ld e,(hl)			;073f
	inc hl			;0740
	push hl			;0741
	ld d,(hl)			;0742
	call 00966h		;0743
	pop hl			;0746
	ret z			;0747
sub_0748h:
	push hl			;0748
	call sub_070eh		;0749
	pop hl			;074c
	inc (hl)			;074d
	ld a,07eh		;074e
	sub d			;0750
	jp nz,l0653h		;0751
	ld (hl),009h		;0754
	ld a,(hl)			;0756
	sub 028h		;0757
	ld d,a			;0759
	cp 009h		;075a
	jp p,l065fh		;075c
	add a,076h		;075f
	ld d,a			;0761
	push hl			;0762
	call 00721h		;0763
	pop hl			;0766
	inc hl			;0767
	sub a			;0768
	inc a			;0769
	ret			;076a
	ld a,(01701h)		;076b
	ld e,a			;076e
	ld a,(01702h)		;076f
	ld d,a			;0772
	call sub_070eh		;0773
	dec d			;0776
	call sub_070eh		;0777
	inc d			;077a
	inc d			;077b
sub_077ch:
	call sub_070eh		;077c
	dec d			;077f
	dec e			;0780
	call sub_070eh		;0781
	inc e			;0784
	inc e			;0785
	jp sub_070eh		;0786
	ld a,(01701h)		;0789
	ld e,a			;078c
	ld a,(01702h)		;078d
	ld d,a			;0790
	call 00721h		;0791
	dec d			;0794
	call 00721h		;0795
	inc d			;0798
	inc d			;0799
	call 00721h		;079a
sub_079dh:
	dec d			;079d
l079eh:
	dec e			;079e
	call 00721h		;079f
	inc e			;07a2
	inc e			;07a3
	jp 00721h		;07a4
	ld a,(01703h)		;07a7
	ld e,a			;07aa
l07abh:
	ld a,(01704h)		;07ab
	ld d,a			;07ae
	dec d			;07af
	call sub_070eh		;07b0
	inc e			;07b3
	call sub_070eh		;07b4
l07b7h:
	inc d			;07b7
	call sub_070eh		;07b8
	inc d			;07bb
	call sub_070eh		;07bc
	dec e			;07bf
	call sub_070eh		;07c0
	dec e			;07c3
l07c4h:
	call sub_070eh		;07c4
	dec d			;07c7
	call sub_070eh		;07c8
	dec d			;07cb
	jp sub_070eh		;07cc
sub_07cfh:
	ld a,(01703h)		;07cf
l07d2h:
	ld e,a			;07d2
	ld a,(01704h)		;07d3
	ld d,a			;07d6
	dec d			;07d7
	call 00721h		;07d8
	inc e			;07db
	call 00721h		;07dc
	inc d			;07df
	call 00721h		;07e0
	inc d			;07e3
	call 00721h		;07e4
	dec e			;07e7
	call 00721h		;07e8
sub_07ebh:
	dec e			;07eb
	call 00721h		;07ec
	dec d			;07ef
	call 00721h		;07f0
	dec d			;07f3
	jp 00721h		;07f4
	ld a,00ch		;07f7
	ld (01701h),a		;07f9
	ld a,00dh		;07fc
	ld (01702h),a		;07fe
l0801h:
	ld a,06ch		;0801
	ld (01703h),a		;0803
	ld a,07bh		;0806
l0808h:
	ld (01704h),a		;0808
	call 00668h		;080b
	jp 006a4h		;080e
	call sub_0748h		;0811
	ld a,001h		;0814
	inc b			;0816
	dec b			;0817
l0818h:
	rlca			;0818
	jp nz,l0714h		;0819
	rrca			;081c
	ld bc,01800h		;081d
l0820h:
	add hl,bc			;0820
	or (hl)			;0821
	ld (hl),a			;0822
	ret			;0823
	call sub_0748h		;0824
	ld a,0feh		;0827
	inc b			;0829
	dec b			;082a
	rlca			;082b
	jp nz,00727h		;082c
	rrca			;082f
	ld bc,01800h		;0830
sub_0833h:
	add hl,bc			;0833
	and (hl)			;0834
	ld (hl),a			;0835
	ret			;0836
	call sub_0748h		;0837
	ld a,b			;083a
	ld bc,01800h		;083b
	add hl,bc			;083e
	ld b,a			;083f
l0840h:
	ld a,(hl)			;0840
	inc b			;0841
l0842h:
	dec b			;0842
	rrca			;0843
	jp nz,l073fh		;0844
	rlca			;0847
	and 001h		;0848
	ret			;084a
	ld a,e			;084b
	and 03ch		;084c
	rrca			;084e
	rrca			;084f
	ld l,a			;0850
	ld a,d			;0851
	and 01eh		;0852
	rlca			;0854
	rlca			;0855
	rlca			;0856
	add a,l			;0857
	ld l,a			;0858
	ld a,d			;0859
	and 040h		;085a
	rlca			;085c
	ld h,a			;085d
	ld a,e			;085e
	and 040h		;085f
	add a,h			;0861
	rlca			;0862
	rlca			;0863
	rlca			;0864
	ld h,a			;0865
	ld a,d			;0866
	and 020h		;0867
	rlca			;0869
	rlca			;086a
	rlca			;086b
	add a,h			;086c
	ld h,a			;086d
	ld a,e			;086e
	and 002h		;086f
l0871h:
	rlca			;0871
	ld b,a			;0872
	ld a,e			;0873
l0874h:
	and 001h		;0874
	add a,b			;0876
	ld b,a			;0877
	ld a,d			;0878
	and 001h		;0879
	rlca			;087b
	add a,b			;087c
l087dh:
	ld b,a			;087d
	ret			;087e
l087fh:
	ld de,00800h		;087f
	ld bc,07901h		;0882
	call sub_079dh		;0885
	ld de,07f00h		;0888
	ld bc,07901h		;088b
	call sub_079dh		;088e
	ld de,l0900h		;0891
	ld bc,l0176h		;0894
	call sub_079dh		;0897
	ld de,l0978h		;089a
	ld bc,l0176h		;089d
	push bc			;08a0
sub_08a1h:
	push bc			;08a1
	call sub_070eh		;08a2
	pop bc			;08a5
	dec b			;08a6
	jp z,l07abh		;08a7
	inc e			;08aa
	jp l079eh		;08ab
l08aeh:
	pop bc			;08ae
	dec c			;08af
	ret z			;08b0
	inc d			;08b1
	ld a,e			;08b2
	sub b			;08b3
	ld e,a			;08b4
	inc e			;08b5
	jp sub_079dh		;08b6
	push bc			;08b9
	push bc			;08ba
	call 00721h		;08bb
	pop bc			;08be
	dec b			;08bf
	jp z,l07c4h		;08c0
	inc e			;08c3
	jp l07b7h		;08c4
	pop bc			;08c7
	dec c			;08c8
	ret z			;08c9
	inc d			;08ca
	ld a,e			;08cb
	sub b			;08cc
	ld e,a			;08cd
	inc e			;08ce
	jp 007b6h		;08cf
	ld de,01000h		;08d2
	push de			;08d5
	ld bc,l0801h		;08d6
	call sub_079dh		;08d9
	pop de			;08dc
	ld a,010h		;08dd
	add a,e			;08df
	ld e,a			;08e0
	jp p,l07d2h		;08e1
	ld e,000h		;08e4
	ld a,008h		;08e6
sub_08e8h:
	add a,d			;08e8
sub_08e9h:
	ld d,a			;08e9
	jp p,l07d2h		;08ea
	ret			;08ed
	in a,(019h)		;08ee
	cpl			;08f0
	inc a			;08f1
	ld (01705h),a		;08f2
l08f5h:
	in a,(01ah)		;08f5
	cpl			;08f7
	inc a			;08f8
	ld (01706h),a		;08f9
	in a,(01bh)		;08fc
	cpl			;08fe
	inc a			;08ff
l0900h:
	ld (01707h),a		;0900
	in a,(01ch)		;0903
	cpl			;0905
	inc a			;0906
	ld (01708h),a		;0907
l090ah:
	ret			;090a
	in a,(019h)		;090b
	ld b,a			;090d
	ld a,(01705h)		;090e
	call sub_0833h		;0911
	ld l,b			;0914
	in a,(01ah)		;0915
l0917h:
	ld b,a			;0917
l0918h:
	ld a,(01706h)		;0918
	call sub_0833h		;091b
	ld a,b			;091e
	cpl			;091f
	inc a			;0920
	ld h,a			;0921
	ret			;0922
	in a,(01bh)		;0923
	ld b,a			;0925
	ld a,(01707h)		;0926
	call sub_0833h		;0929
	ld l,b			;092c
	in a,(01ch)		;092d
	ld b,a			;092f
l0930h:
	ld a,(01708h)		;0930
	jp l0818h		;0933
	add a,b			;0936
	jp p,l0840h		;0937
	ld b,001h		;093a
	dec b			;093c
	add a,019h		;093d
sub_093fh:
	jp m,00839h		;093f
	ret			;0942
	ld b,0ffh		;0943
	inc b			;0945
l0946h:
	sub 019h		;0946
	jp p,l0842h		;0948
	ret			;094b
	ld a,(01704h)		;094c
	ld b,a			;094f
	ld a,(01702h)		;0950
	sub b			;0953
	ld b,a			;0954
	ld a,(01703h)		;0955
	ld c,a			;0958
	ld a,(01701h)		;0959
	sub c			;095c
	cp 003h		;095d
	jp z,l0874h		;095f
	ret p			;0962
l0963h:
	cp 0fdh		;0963
	jp z,l0874h		;0965
	ret m			;0968
	ld a,b			;0969
	cp 003h		;096a
	jp z,l087dh		;096c
	cp 0fdh		;096f
	jp z,l087dh		;0971
	sub a			;0974
	inc a			;0975
	ret			;0976
	ld a,b			;0977
l0978h:
	cp 003h		;0978
	jp p,l0871h		;097a
	cp 0feh		;097d
l097fh:
	ret m			;097f
	sub a			;0980
	ret			;0981
	ld a,00ch		;0982
	out (00eh),a		;0984
	call sub_08a1h		;0986
	ld a,00bh		;0989
	ld hl,01700h		;098b
	call 00003h		;098e
	call sub_077ch		;0991
	call sub_07cfh		;0994
	call l05fbh		;0997
	call 006f4h		;099a
	ld a,08ch		;099d
	out (00eh),a		;099f
	jp l0575h		;09a1
	ld a,040h		;09a4
	ld c,079h		;09a6
	ld de,l01f4h		;09a8
	push af			;09ab
	out (019h),a		;09ac
	out (01bh),a		;09ae
	ld b,c			;09b0
	dec b			;09b1
	jp nz,l08aeh		;09b2
	pop af			;09b5
	cpl			;09b6
	ld b,a			;09b7
	dec de			;09b8
	ld a,d			;09b9
	or e			;09ba
	ret z			;09bb
	ld a,b			;09bc
	jp 008a8h		;09bd
	push bc			;09c0
	push de			;09c1
	push hl			;09c2
	call 006cch		;09c3
sub_09c6h:
	pop hl			;09c6
	ld de,01703h		;09c7
	call sub_08e9h		;09ca
	jp z,008e2h		;09cd
	call 006a4h		;09d0
	call sub_0686h		;09d3
	pop hl			;09d6
	ld de,01701h		;09d7
	call sub_08e9h		;09da
	jp z,008e3h		;09dd
l09e0h:
	call 00668h		;09e0
	pop bc			;09e3
	ret			;09e4
	pop bc			;09e5
	pop hl			;09e6
	inc (hl)			;09e7
	jp l087fh		;09e8
	jp (hl)			;09eb
	push de			;09ec
	call sub_08e8h		;09ed
	pop bc			;09f0
	push bc			;09f1
	ld a,(bc)			;09f2
	ld e,a			;09f3
	inc bc			;09f4
	ld a,(bc)			;09f5
	ld d,a			;09f6
	dec bc			;09f7
	push de			;09f8
	ld a,h			;09f9
	or l			;09fa
	jp z,0093bh		;09fb
	ld a,h			;09fe
	and a			;09ff
	jp z,l090ah		;0a00
	jp m,00908h		;0a03
l0a06h:
	inc d			;0a06
	dec h			;0a07
	jp l090ah		;0a08
	dec d			;0a0b
	inc h			;0a0c
	ld a,l			;0a0d
l0a0eh:
	and a			;0a0e
	jp z,l0918h+1		;0a0f
	jp m,l0917h		;0a12
	inc e			;0a15
	dec l			;0a16
	jp l0918h+1		;0a17
	dec e			;0a1a
	inc l			;0a1b
	ld a,e			;0a1c
	ld (bc),a			;0a1d
	ld a,d			;0a1e
	inc bc			;0a1f
	ld (bc),a			;0a20
	pop bc			;0a21
	push hl			;0a22
	call sub_093fh		;0a23
	jp z,l0930h		;0a26
	pop hl			;0a29
	pop bc			;0a2a
	push bc			;0a2b
	push hl			;0a2c
	ld a,e			;0a2d
	ld (bc),a			;0a2e
	inc bc			;0a2f
	ld a,d			;0a30
	ld (bc),a			;0a31
	dec bc			;0a32
	call 00849h		;0a33
	pop hl			;0a36
	pop bc			;0a37
	push bc			;0a38
	jp nz,l08f5h		;0a39
	pop bc			;0a3c
	ret			;0a3d
	pop bc			;0a3e
	pop bc			;0a3f
	inc a			;0a40
	ret			;0a41
	push de			;0a42
	dec e			;0a43
	dec d			;0a44
	ld hl,00303h		;0a45
	push bc			;0a48
	push de			;0a49
	push hl			;0a4a
	call sub_0734h		;0a4b
	pop hl			;0a4e
	pop de			;0a4f
	jp nz,l0963h		;0a50
	inc d			;0a53
	dec h			;0a54
	jp nz,l0946h		;0a55
	ld h,003h		;0a58
	dec d			;0a5a
	dec d			;0a5b
	dec d			;0a5c
	inc e			;0a5d
	dec l			;0a5e
	jp nz,l0946h		;0a5f
	pop bc			;0a62
	pop de			;0a63
	sub a			;0a64
	ret			;0a65
	pop de			;0a66
	pop bc			;0a67
	ret			;0a68
	ld hl,01704h		;0a69
	call sub_09c6h		;0a6c
	jp nz,l097fh		;0a6f
	push hl			;0a72
	push de			;0a73
	call 006cch		;0a74
	pop de			;0a77
	pop hl			;0a78
	call 00999h		;0a79
	ret z			;0a7c
	push de			;0a7d
	call 006a4h		;0a7e
	pop de			;0a81
	ld hl,01702h		;0a82
	call sub_09c6h		;0a85
	ret nz			;0a88
	push hl			;0a89
	push de			;0a8a
	call sub_0686h		;0a8b
	pop de			;0a8e
	pop hl			;0a8f
	call 00999h		;0a90
	ret z			;0a93
	push de			;0a94
	call 00668h		;0a95
	pop de			;0a98
	and a			;0a99
	inc a			;0a9a
	ret			;0a9b
	push de			;0a9c
	push hl			;0a9d
	dec hl			;0a9e
	ex de,hl			;0a9f
	ld hl,009d4h		;0aa0
	call sub_08e9h		;0aa3
	pop hl			;0aa6
	pop de			;0aa7
	ret z			;0aa8
	call sub_09c6h		;0aa9
	ret nz			;0aac
	push de			;0aad
	push hl			;0aae
	dec hl			;0aaf
	ex de,hl			;0ab0
	ld hl,009d8h		;0ab1
	call sub_08e9h		;0ab4
	pop hl			;0ab7
	pop de			;0ab8
	ret z			;0ab9
	call sub_09c6h		;0aba
	ret nz			;0abd
	push de			;0abe
	dec hl			;0abf
	ex de,hl			;0ac0
	ld hl,009dch		;0ac1
	call sub_08e9h		;0ac4
	pop de			;0ac7
	ret			;0ac8
	ld a,d			;0ac9
	sub (hl)			;0aca
	inc a			;0acb
	ret nz			;0acc
	dec hl			;0acd
	ld a,e			;0ace
	sub (hl)			;0acf
	inc hl			;0ad0
	ret z			;0ad1
	inc a			;0ad2
	ret z			;0ad3
	dec a			;0ad4
	dec a			;0ad5
	ret			;0ad6
	ld hl,l0100h		;0ad7
	ret			;0ada
	ld hl,00003h		;0adb
	ret			;0ade
	ld hl,000fdh		;0adf
	ret			;0ae2
l0ae3h:
	ld hl,l0103h		;0ae3
	ld de,00000h		;0ae6
	ld bc,l09e0h		;0ae9
	ldir		;0aec
	ld a,000h		
	out (018h),a	
	
	ld a,00ch		
	out (00eh),a
	ld hl,1800h
    ld e,l
	ld d,h
	inc	de
	ld (hl),000h
	ld bc,800h
	ldir
	
	jp 00000h		;0aee
