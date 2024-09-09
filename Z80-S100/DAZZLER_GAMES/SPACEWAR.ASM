; z80dasm 1.1.6
; command line: z80dasm --labels --origin=0x0100 -a SPACEWAR.COM

	org	00100h

l0100h:
	jp l0ed8h		;0100
l0103h:
	jp l0cc0h		;0103
l0106h:
	nop			;0106
l0107h:
	nop			;0107
l0108h:
	nop			;0108
	nop			;0109
l010ah:
	nop			;010a
l010bh:
	call 00048h		;010b
l010eh:
	jp 0000bh		;010e
l0111h:
	nop			;0111
l0112h:
	nop			;0112
l0113h:
	call 00048h		;0113
l0116h:
	jp 00013h		;0116
	nop			;0119
l011ah:
	nop			;011a
	call 00048h		;011b
l011eh:
	jp 0001bh		;011e
l0121h:
	nop			;0121
l0122h:
	nop			;0122
	call 00048h		;0123
l0126h:
	jp 00023h		;0126
	nop			;0129
l012ah:
	nop			;012a
l012bh:
	call 00048h		;012b
sub_012eh:
	jp 0002bh		;012e
	nop			;0131
	nop			;0132
	call 00048h		;0133
	jp 00033h		;0136
	nop			;0139
	nop			;013a
	call 00048h		;013b
	jp 0003bh		;013e
	ex af,af'			;0141
	nop			;0142
	nop			;0143
	nop			;0144
	nop			;0145
	nop			;0146
	nop			;0147
	nop			;0148
	and 0dfh		;0149
	ld (00044h),hl		;014b
	ld hl,00000h		;014e
	add hl,sp			;0151
	ld (00046h),hl		;0152
l0155h:
	ld sp,00044h		;0155
	push de			;0158
	push bc			;0159
	push af			;015a
	ld sp,hl			;015b
	ret			;015c
	nop			;015d
	nop			;015e
	nop			;015f
	ld d,0a4h		;0160
	ld (bc),a			;0162
	nop			;0163
	jr nc,l0166h		;0164
l0166h:
	ret nz			;0166
	nop			;0167
	nop			;0168
	jr nz,$-8		;0169
	ld d,l			;016b
	ret nz			;016c
	ld c,e			;016d
	or h			;016e
	ret m			;016f
	jr l0155h		;0170
	push de			;0172
	ld e,04dh		;0173
l0175h:
	djnz l0175h		;0175
	rst 28h			;0177
	rst 38h			;0178
	ld a,01ch		;0179
	ld (bc),a			;017b
	ld l,01ch		;017c
	ld (bc),a			;017e
	ld c,(hl)			;017f
	inc e			;0180
	ld (bc),a			;0181
	ld e,01ch		;0182
	ld (bc),a			;0184
	ld e,(hl)			;0185
	inc e			;0186
	ld (bc),a			;0187
	ld c,01ch		;0188
	ld (bc),a			;018a
	ld l,(hl)			;018b
	inc e			;018c
	jr nz,l01ddh		;018d
	inc e			;018f
	jr nz,l01f0h		;0190
	inc e			;0192
	jr nz,$+112		;0193
	inc e			;0195
	jr nz,l01e5h		;0196
	inc e			;0198
	jr nz,l01f8h		;0199
	inc e			;019b
	jr nz,l020bh		;019c
	inc e			;019e
	rst 38h			;019f
	ld e,c			;01a0
	inc e			;01a1
	rst 38h			;01a2
	ld e,c			;01a3
	inc e			;01a4
	jr nz,l01ffh		;01a5
	inc e			;01a7
	djnz l0202h		;01a8
	inc e			;01aa
	rst 38h			;01ab
	nop			;01ac
	nop			;01ad
	nop			;01ae
	nop			;01af
l01b0h:
	nop			;01b0
	nop			;01b1
	nop			;01b2
	nop			;01b3
	ret p			;01b4
	nop			;01b5
	add a,a			;01b6
	nop			;01b7
	jr nz,$-66		;01b8
	ld (bc),a			;01ba
	nop			;01bb
	nop			;01bc
	ret m			;01bd
	ld l,a			;01be
	sub e			;01bf
	dec l			;01c0
	ld d,(hl)			;01c1
	inc b			;01c2
	jp po,0f81ah		;01c3
	rst 38h			;01c6
	inc a			;01c7
	inc e			;01c8
	add a,b			;01c9
	dec hl			;01ca
	inc e			;01cb
	ld b,b			;01cc
	inc a			;01cd
	inc e			;01ce
	ex af,af'			;01cf
	dec de			;01d0
	inc e			;01d1
	jr nz,l01eeh		;01d2
	inc e			;01d4
	djnz $+46		;01d5
	inc e			;01d7
	add a,b			;01d8
	dec sp			;01d9
	inc e			;01da
	add a,b			;01db
	inc l			;01dc
l01ddh:
	inc e			;01dd
	ex af,af'			;01de
	dec a			;01df
	inc e			;01e0
	djnz l0230h		;01e1
	inc e			;01e3
	ex af,af'			;01e4
l01e5h:
	ld c,h			;01e5
	inc e			;01e6
	djnz l0245h		;01e7
	inc e			;01e9
	inc b			;01ea
	ld e,l			;01eb
	inc e			;01ec
	rst 38h			;01ed
l01eeh:
	halt			;01ee
	dec de			;01ef
l01f0h:
	djnz l0268h		;01f0
	dec de			;01f2
	ld b,b			;01f3
	ld h,(hl)			;01f4
	dec de			;01f5
	rst 38h			;01f6
	ld d,(hl)			;01f7
l01f8h:
	dec de			;01f8
	rst 38h			;01f9
	nop			;01fa
	nop			;01fb
	nop			;01fc
	nop			;01fd
	nop			;01fe
l01ffh:
	nop			;01ff
	nop			;0200
l0201h:
	nop			;0201
l0202h:
	or 0f3h		;0202
l0204h:
	ld l,l			;0204
	nop			;0205
	jr nz,$+129		;0206
	ld (bc),a			;0208
	nop			;0209
	nop			;020a
l020bh:
	ret nc			;020b
	ld bc,l0223h		;020c
	ret z			;020f
	ld c,l			;0210
	jp 06f00h		;0211
	sub e			;0214
	dec l			;0215
	ld d,(hl)			;0216
	cp e			;0217
	nop			;0218
	ld l,b			;0219
	inc d			;021a
	cp d			;021b
	ld a,(bc)			;021c
	ld h,c			;021d
	add hl,bc			;021e
	nop			;021f
	nop			;0220
	ld c,0aah		;0221
l0223h:
	djnz $+18		;0223
	nop			;0225
	ld (bc),a			;0226
	ld h,b			;0227
	nop			;0228
	dec b			;0229
	nop			;022a
	nop			;022b
	nop			;022c
	ld bc,03300h		;022d
l0230h:
	ld bc,06d11h		;0230
	nop			;0233
	ld hl,00075h		;0234
	call 00244h		;0237
	ld a,(000b2h)		;023a
l023dh:
	ld d,a			;023d
	ld a,(000b1h)		;023e
	ld e,a			;0241
	ld a,(0006ch)		;0242
l0245h:
	call sub_026ah		;0245
	ld (0006ch),a		;0248
	jp c,l01b0h		;024b
	ld hl,00000h		;024e
	call 002d5h		;0251
	ld h,d			;0254
	ld l,e			;0255
	call 002d5h		;0256
	call 002cbh		;0259
	ld a,d			;025c
	add a,d			;025d
	ld h,a			;025e
	ld a,e			;025f
	add a,e			;0260
	ld l,a			;0261
	call 002d5h		;0262
	call 002cbh		;0265
l0268h:
	ld a,d			;0268
	add a,h			;0269
sub_026ah:
	ld h,a			;026a
	ld a,e			;026b
	add a,l			;026c
	ld l,a			;026d
	call 002d5h		;026e
	call 002cbh		;0271
	xor a			;0274
	sub e			;0275
	ld b,a			;0276
	sub d			;0277
	ld h,a			;0278
	ld a,b			;0279
l027ah:
	add a,d			;027a
	ld l,a			;027b
	call 002d5h		;027c
	ld a,h			;027f
	sub d			;0280
	ld h,a			;0281
l0282h:
	ld a,l			;0282
	sub e			;0283
l0284h:
	ld l,a			;0284
	call 002d5h		;0285
	ld a,h			;0288
	sub d			;0289
	ld h,a			;028a
	ld a,l			;028b
	sub e			;028c
	ld l,a			;028d
	call 002d5h		;028e
	ld a,e			;0291
	sub d			;0292
	ld h,a			;0293
	xor a			;0294
	sub e			;0295
	sub d			;0296
l0297h:
	ld l,a			;0297
	call 002d5h		;0298
	ld a,h			;029b
	sub d			;029c
	ld h,a			;029d
	ld a,l			;029e
	sub e			;029f
	ld l,a			;02a0
	call 002d5h		;02a1
	ld a,h			;02a4
	sub d			;02a5
	ld h,a			;02a6
	ld a,l			;02a7
	sub e			;02a8
	ld l,a			;02a9
	call 002d5h		;02aa
	ld a,(000b8h)		;02ad
	call 002abh		;02b0
	ld hl,(l010eh)		;02b3
	ld a,0ffh		;02b6
	ld (hl),a			;02b8
	ld de,000bbh		;02b9
	ld hl,000c3h		;02bc
	call 00244h		;02bf
	ld a,(l0100h)		;02c2
	ld d,a			;02c5
	ld a,(000ffh)		;02c6
	ld e,a			;02c9
	ld a,(000bah)		;02ca
	call sub_026ah		;02cd
	ld (000bah),a		;02d0
	jp c,l023dh		;02d3
l02d6h:
	ld hl,00000h		;02d6
	call 002d5h		;02d9
	ld h,d			;02dc
	ld l,e			;02dd
	call 002d5h		;02de
	call 002cbh		;02e1
	ld a,d			;02e4
	add a,d			;02e5
l02e6h:
	ld h,a			;02e6
	ld a,e			;02e7
	add a,e			;02e8
	ld l,a			;02e9
	call 002d5h		;02ea
	ld a,d			;02ed
	add a,h			;02ee
	ld h,a			;02ef
	ld a,e			;02f0
	add a,l			;02f1
	ld l,a			;02f2
	call 002d5h		;02f3
	xor a			;02f6
	sub e			;02f7
	ld h,a			;02f8
	ld l,d			;02f9
	call 002d5h		;02fa
	call 002cbh		;02fd
	push hl			;0300
	ld a,h			;0301
l0302h:
	sub d			;0302
	ld h,a			;0303
	ld a,l			;0304
	sub e			;0305
	ld l,a			;0306
	call 002d5h		;0307
	ld a,h			;030a
	sub d			;030b
	ld h,a			;030c
	ld a,l			;030d
	sub e			;030e
	ld l,a			;030f
	call 002d5h		;0310
	ld a,h			;0313
	sub d			;0314
	ld h,a			;0315
	ld a,l			;0316
	sub e			;0317
	ld l,a			;0318
sub_0319h:
	call 002d5h		;0319
	pop hl			;031c
	xor a			;031d
	sub h			;031e
	sub d			;031f
	ld h,a			;0320
	xor a			;0321
	sub l			;0322
	sub e			;0323
	ld l,a			;0324
	call 002d5h		;0325
	ld a,h			;0328
	sub d			;0329
	ld h,a			;032a
	ld a,l			;032b
	sub e			;032c
	ld l,a			;032d
	call 002d5h		;032e
	ld a,h			;0331
	sub d			;0332
	ld h,a			;0333
	ld a,l			;0334
	sub e			;0335
	ld l,a			;0336
	call 002d5h		;0337
	ld a,(l0106h)		;033a
	call 002abh		;033d
	ld hl,(l010eh)		;0340
	ld a,0ffh		;0343
	ld (hl),a			;0345
	ret			;0346
	push hl			;0347
	ld (l010eh),hl		;0348
	ex de,hl			;034b
	ld e,(hl)			;034c
	inc hl			;034d
	ld d,(hl)			;034e
	inc hl			;034f
	ex de,hl			;0350
	ld (l010eh+2),hl		;0351
	ex de,hl			;0354
l0355h:
	ld e,(hl)			;0355
	inc hl			;0356
	ld d,(hl)			;0357
	ex de,hl			;0358
	ld (l0112h),hl		;0359
	pop hl			;035c
	ld a,(hl)			;035d
	xor 0ffh		;035e
	ret z			;0360
	inc hl			;0361
	ld e,(hl)			;0362
	inc hl			;0363
	ld d,(hl)			;0364
	inc hl			;0365
	ex de,hl			;0366
	and (hl)			;0367
	ld (hl),a			;0368
	ex de,hl			;0369
	jp 0025ah		;036a
	cp 001h		;036d
	ret z			;036f
	cp 0f8h		;0370
	jp z,l0282h		;0372
	cp 080h		;0375
	jp nz,l0284h		;0377
	ld a,(0006ah)		;037a
	ld b,a			;037d
	ld hl,00000h		;037e
	call 002d5h		;0381
	ld a,b			;0384
	scf			;0385
	ret			;0386
	cp 002h		;0387
	jp nz,l0297h		;0389
	call sub_0781h		;038c
l038fh:
	and 007h		;038f
	ld a,002h		;0391
	jp nz,l0297h		;0393
	dec a			;0396
	call sub_0b46h		;0397
	dec a			;039a
	jp p,l027ah		;039b
	cp 0f8h		;039e
	jp c,l0282h		;03a0
	ld b,a			;03a3
	ld a,d			;03a4
	rla			;03a5
	ld d,a			;03a6
	and a			;03a7
	ld a,e			;03a8
l03a9h:
	rla			;03a9
	ld e,a			;03aa
	and a			;03ab
	ld a,b			;03ac
	ret			;03ad
	and a			;03ae
l03afh:
	ret z			;03af
	xor a			;03b0
	sub d			;03b1
	add a,a			;03b2
	add a,a			;03b3
	ld h,a			;03b4
	xor a			;03b5
	sub e			;03b6
	add a,a			;03b7
	add a,a			;03b8
	ld l,a			;03b9
	ld a,(l0108h)		;03ba
	and 003h		;03bd
	ld b,a			;03bf
	call 002d5h		;03c0
	dec b			;03c3
	ret m			;03c4
l03c5h:
	ld a,h			;03c5
	sub d			;03c6
	ld h,a			;03c7
	ld a,l			;03c8
	sub e			;03c9
	ld l,a			;03ca
	jp 002bdh		;03cb
	push hl			;03ce
	xor a			;03cf
	sub h			;03d0
l03d1h:
	ld h,a			;03d1
	xor a			;03d2
	sub l			;03d3
	ld l,a			;03d4
l03d5h:
	jp l02d6h		;03d5
	push hl			;03d8
	push de			;03d9
	push bc			;03da
	ld a,h			;03db
	rra			;03dc
	rra			;03dd
sub_03deh:
	inc a			;03de
	rra			;03df
	and 01fh		;03e0
	cp 010h		;03e2
	jp c,l02e6h		;03e4
	or 0e0h		;03e7
	ld h,a			;03e9
	ld a,(l0111h)		;03ea
	add a,h			;03ed
	rra			;03ee
	ld b,a			;03ef
	ld a,l			;03f0
	rra			;03f1
	rra			;03f2
	inc a			;03f3
	rra			;03f4
	and 01fh		;03f5
	cp 010h		;03f7
	jp c,002fbh		;03f9
	or 0e0h		;03fc
	ld l,a			;03fe
	ld a,(l0113h)		;03ff
	add a,l			;0402
	rra			;0403
	ld c,a			;0404
	call sub_0319h		;0405
	ex de,hl			;0408
l0409h:
	ld hl,(l010eh)		;0409
	ld (hl),a			;040c
	inc hl			;040d
	ld (hl),e			;040e
	inc hl			;040f
	ld (hl),d			;0410
	inc hl			;0411
sub_0412h:
	ld (l010eh),hl		;0412
	ex de,hl			;0415
	or (hl)			;0416
	ld (hl),a			;0417
	pop bc			;0418
	pop de			;0419
	pop hl			;041a
	ret			;041b
	ld a,c			;041c
	and 060h		;041d
	add a,040h		;041f
	and 0a0h		;0421
	ld d,a			;0423
	ld a,b			;0424
	and 040h		;0425
	add a,d			;0427
l0428h:
	rlca			;0428
	rlca			;0429
	rlca			;042a
	ld d,a			;042b
	ld a,c			;042c
	and 01eh		;042d
	rlca			;042f
	rlca			;0430
	rlca			;0431
l0432h:
	ld e,a			;0432
	ld a,b			;0433
	and 03ch		;0434
	rrca			;0436
	rrca			;0437
	add a,e			;0438
sub_0439h:
	ld e,a			;0439
	ld a,c			;043a
	rra			;043b
	ld a,b			;043c
	rla			;043d
	and 007h		;043e
	ld c,a			;0440
	ld b,000h		;0441
	ld hl,0034ah		;0443
	add hl,bc			;0446
	ld a,(hl)			;0447
	ld hl,01800h		;0448
	add hl,de			;044b
	ret			;044c
	ld bc,l0204h		;044d
	ex af,af'			;0450
	djnz l0493h		;0451
	jr nz,l03d5h		;0453
	ld hl,01450h		;0455
l0458h:
	ld a,(hl)			;0458
	cp 0ffh		;0459
	ret z			;045b
	inc hl			;045c
l045dh:
	inc hl			;045d
	ld b,(hl)			;045e
	inc hl			;045f
	inc hl			;0460
	ld c,(hl)			;0461
	ld de,00005h		;0462
	add hl,de			;0465
	push hl			;0466
	ld e,(hl)			;0467
	inc hl			;0468
	ld d,(hl)			;0469
	inc hl			;046a
	ld a,(hl)			;046b
	ex de,hl			;046c
	cpl			;046d
	and (hl)			;046e
l046fh:
	ld (hl),a			;046f
	ex de,hl			;0470
	ld de,0fff5h		;0471
	add hl,de			;0474
	ld a,(hl)			;0475
	and a			;0476
	jp z,l038fh		;0477
	ld a,b			;047a
	rra			;047b
	ld b,a			;047c
l047dh:
	ld a,c			;047d
	rra			;047e
	ld c,a			;047f
	call sub_0319h		;0480
	ex de,hl			;0483
	pop hl			;0484
	ld (hl),e			;0485
	inc hl			;0486
	ld (hl),d			;0487
	inc hl			;0488
	ld (hl),a			;0489
	inc hl			;048a
	ex de,hl			;048b
	or (hl)			;048c
	ld (hl),a			;048d
	ex de,hl			;048e
	jp l0355h		;048f
	pop hl			;0492
l0493h:
	ld (hl),000h		;0493
	inc hl			;0495
	ld (hl),000h		;0496
	inc hl			;0498
	ld (hl),000h		;0499
	inc hl			;049b
	jp l0355h		;049c
	ld a,(0006ch)		;049f
	cp 002h		;04a2
	jp c,l03a9h		;04a4
	cp 0f8h		;04a7
	jp c,l03afh		;04a9
	ld hl,0006dh		;04ac
	call sub_03deh		;04af
	ld a,(000bah)		;04b2
	cp 002h		;04b5
	jp c,003bch		;04b7
	cp 0f8h		;04ba
	jp c,003c2h		;04bc
	ld hl,000bbh		;04bf
	call sub_03deh		;04c2
	ld hl,01450h		;04c5
	ld a,(hl)			;04c8
	and a			;04c9
	jp nz,l03d1h		;04ca
	ld de,0000ch		;04cd
	add hl,de			;04d0
	jp l03c5h		;04d1
	cp 0ffh		;04d4
	ret z			;04d6
	inc hl			;04d7
	call sub_03deh		;04d8
	ld de,00008h		;04db
	jp 003cdh		;04de
	call 003e6h		;04e1
	inc hl			;04e4
	call 003e6h		;04e5
	ret			;04e8
	push hl			;04e9
	ld c,(hl)			;04ea
	inc hl			;04eb
	ld b,(hl)			;04ec
	inc hl			;04ed
	inc hl			;04ee
	inc hl			;04ef
	ld a,(hl)			;04f0
	rlca			;04f1
	rlca			;04f2
	rlca			;04f3
	rlca			;04f4
	ld e,a			;04f5
	inc hl			;04f6
	ld a,(hl)			;04f7
	rlca			;04f8
	rlca			;04f9
	rlca			;04fa
	rlca			;04fb
	ld d,a			;04fc
	xor e			;04fd
	and 0f0h		;04fe
	xor e			;0500
	ld e,a			;0501
	ld a,d			;0502
	and 00fh		;0503
	cp 008h		;0505
	jp c,l0409h		;0507
	or 0f0h		;050a
	ld d,a			;050c
	ex de,hl			;050d
	add hl,bc			;050e
	ex de,hl			;050f
	pop hl			;0510
	ld (hl),e			;0511
	inc hl			;0512
	ld (hl),d			;0513
	ret			;0514
	ld a,(0006ch)		;0515
	cp 001h		;0518
	jp nz,l0428h		;051a
	jp l0d0fh		;051d
	ld a,b			;0520
	rlca			;0521
	rlca			;0522
	ld b,a			;0523
	ret			;0524
	ld hl,0006dh		;0525
	call sub_0439h		;0528
	ld a,(000bah)		;052b
	cp 001h		;052e
	ret nz			;0530
	jp l0d70h		;0531
	nop			;0534
	ld hl,000bbh		;0535
	call sub_0439h		;0538
	ret			;053b
	push af			;053c
	ld (l0113h+1),hl		;053d
	ld bc,00047h		;0540
	add hl,bc			;0543
	inc (hl)			;0544
	jp m,00537h		;0545
	ld (hl),000h		;0548
	rra			;054a
	jp nc,00537h		;054b
	ld bc,00001h		;054e
	add hl,bc			;0551
	dec (hl)			;0552
	jp p,l0458h		;0553
	ld (hl),000h		;0556
	jp 00537h		;0558
	ld hl,01450h		;055b
	ld d,03eh		;055e
	ld a,(hl)			;0560
	and a			;0561
	jp z,l047dh		;0562
	cp 0ffh		;0565
	jp z,l046fh		;0567
	ld bc,0000ch		;056a
	add hl,bc			;056d
	dec d			;056e
	jp l045dh		;056f
	and d			;0572
	jp z,00537h		;0573
	ld bc,0000ch		;0576
	add hl,bc			;0579
	ld (hl),0ffh		;057a
	ld bc,0fff4h		;057c
	add hl,bc			;057f
	ld a,(00068h)		;0580
	ld (hl),a			;0583
	ld (l0116h),hl		;0584
	xor a			;0587
	ld bc,00009h		;0588
	add hl,bc			;058b
	ld (hl),a			;058c
	inc hl			;058d
	ld (hl),a			;058e
	inc hl			;058f
	ld (hl),a			;0590
	ld hl,(l0113h+1)		;0591
	ld bc,00045h		;0594
	add hl,bc			;0597
	ld a,(hl)			;0598
	ld hl,(0005ch)		;0599
	ld b,h			;059c
	ld c,l			;059d
	call sub_0735h		;059e
	ex de,hl			;05a1
	ld hl,(l0113h+1)		;05a2
	push de			;05a5
	ld bc,00004h		;05a6
	add hl,bc			;05a9
	ld a,(hl)			;05aa
	add a,e			;05ab
	ld e,a			;05ac
	inc hl			;05ad
	ld a,(hl)			;05ae
	adc a,d			;05af
	ld hl,(l0116h)		;05b0
	ld bc,00005h		;05b3
	add hl,bc			;05b6
	ld (hl),e			;05b7
	inc hl			;05b8
	ld (hl),a			;05b9
l05bah:
	pop hl			;05ba
	ld a,h			;05bb
	and a			;05bc
	jp p,004beh		;05bd
	scf			;05c0
	rra			;05c1
	ld h,a			;05c2
	ld a,l			;05c3
	rra			;05c4
	ld l,a			;05c5
	ex de,hl			;05c6
l05c7h:
	ld hl,(l0113h+1)		;05c7
	ld a,(hl)			;05ca
	add a,e			;05cb
	ld e,a			;05cc
	inc hl			;05cd
	ld a,(hl)			;05ce
	adc a,d			;05cf
	ld hl,(l0116h)		;05d0
	inc hl			;05d3
	ld (hl),e			;05d4
	inc hl			;05d5
	ld (hl),a			;05d6
	ld hl,(l0113h+1)		;05d7
l05dah:
	ld bc,00044h		;05da
	add hl,bc			;05dd
	ld a,(hl)			;05de
	ld hl,(0005ch)		;05df
	ld b,h			;05e2
	ld c,l			;05e3
	call sub_0735h		;05e4
	ex de,hl			;05e7
	ld hl,(l0113h+1)		;05e8
	push de			;05eb
	ld bc,00006h		;05ec
l05efh:
	add hl,bc			;05ef
	ld a,(hl)			;05f0
	add a,e			;05f1
	ld e,a			;05f2
	inc hl			;05f3
	ld a,(hl)			;05f4
	adc a,d			;05f5
	ld hl,(l0116h)		;05f6
	ld bc,00007h		;05f9
	add hl,bc			;05fc
	ld (hl),e			;05fd
	inc hl			;05fe
	ld (hl),a			;05ff
	pop hl			;0600
	ld a,h			;0601
	and a			;0602
	jp p,00504h		;0603
	scf			;0606
	rra			;0607
	ld h,a			;0608
	ld a,l			;0609
	rra			;060a
l060bh:
	ld l,a			;060b
	ex de,hl			;060c
	ld hl,(l0113h+1)		;060d
l0610h:
	inc hl			;0610
	inc hl			;0611
	ld a,(hl)			;0612
	add a,e			;0613
	ld e,a			;0614
	inc hl			;0615
	ld a,(hl)			;0616
	adc a,d			;0617
	ld hl,(l0116h)		;0618
	inc hl			;061b
	inc hl			;061c
	inc hl			;061d
	ld (hl),e			;061e
	inc hl			;061f
	ld (hl),a			;0620
	ld hl,(l0113h+1)		;0621
	ld bc,00047h		;0624
	add hl,bc			;0627
	ld a,(00067h)		;0628
	ld (hl),a			;062b
	ld a,(000b5h)		;062c
	ld b,a			;062f
	ld a,(l0103h)		;0630
	or b			;0633
	jp nz,00537h		;0634
	call sub_0b46h		;0637
	ld hl,(l0113h+1)		;063a
	ld bc,0004bh		;063d
	add hl,bc			;0640
	ld (hl),000h		;0641
	pop af			;0643
	push af			;0644
	and 002h		;0645
	jp z,l05bah		;0647
	ld bc,0fffeh		;064a
	add hl,bc			;064d
	ld e,(hl)			;064e
	inc hl			;064f
	ld d,(hl)			;0650
	ld a,d			;0651
	or e			;0652
	jp z,l05bah		;0653
	dec de			;0656
	ld (hl),d			;0657
	dec hl			;0658
	ld (hl),e			;0659
	ld bc,00002h		;065a
	add hl,bc			;065d
	inc (hl)			;065e
	ld bc,0fffah		;065f
	add hl,bc			;0662
	ld a,(hl)			;0663
	ld hl,(00060h)		;0664
	ld b,h			;0667
	ld c,l			;0668
	call sub_0735h		;0669
	ex de,hl			;066c
	ld e,d			;066d
	ld a,d			;066e
	ld d,000h		;066f
	and a			;0671
	jp p,00574h		;0672
	ld d,0ffh		;0675
	ld hl,(l0113h+1)		;0677
	ld bc,00004h		;067a
	add hl,bc			;067d
	ld a,(hl)			;067e
	inc hl			;067f
	ld h,(hl)			;0680
	ld l,a			;0681
	add hl,de			;0682
	ex de,hl			;0683
	ld hl,(l0113h+1)		;0684
	ld bc,00004h		;0687
	add hl,bc			;068a
	ld (hl),e			;068b
	inc hl			;068c
	ld (hl),d			;068d
	ld bc,0003fh		;068e
	add hl,bc			;0691
	ld a,(hl)			;0692
	ld hl,(00060h)		;0693
	ld b,h			;0696
	ld c,l			;0697
	call sub_0735h		;0698
	ex de,hl			;069b
	ld e,d			;069c
	ld a,d			;069d
	ld d,000h		;069e
	and a			;06a0
	jp p,005a3h		;06a1
	ld d,0ffh		;06a4
	ld hl,(l0113h+1)		;06a6
	ld bc,00006h		;06a9
	add hl,bc			;06ac
	ld a,(hl)			;06ad
	inc hl			;06ae
	ld h,(hl)			;06af
	ld l,a			;06b0
	add hl,de			;06b1
	ex de,hl			;06b2
	ld hl,(l0113h+1)		;06b3
	ld bc,00006h		;06b6
	add hl,bc			;06b9
	ld (hl),e			;06ba
	inc hl			;06bb
	ld (hl),d			;06bc
	ld hl,(l0113h+1)		;06bd
	ld bc,0004ch		;06c0
	add hl,bc			;06c3
	ld a,(hl)			;06c4
	and a			;06c5
	jp z,l05c7h		;06c6
	dec (hl)			;06c9
	pop af			;06ca
	and 00ch		;06cb
	ret z			;06cd
	cp 00ch		;06ce
	jp z,l0610h		;06d0
	cp 008h		;06d3
	jp nz,l05dah		;06d5
	ld a,0ffh		;06d8
	jp l05dah+2		;06da
	ld a,001h		;06dd
	ld hl,(l0113h+1)		;06df
	ld bc,00046h		;06e2
	add hl,bc			;06e5
	add a,(hl)			;06e6
	cp 0ffh		;06e7
	jp z,l060bh		;06e9
	cp 0b4h		;06ec
	jp nz,l05efh		;06ee
	xor a			;06f1
	ld (hl),a			;06f2
	ld c,a			;06f3
	ld b,000h		;06f4
	ld hl,00654h		;06f6
	add hl,bc			;06f9
	ld e,(hl)			;06fa
	ld bc,0002dh		;06fb
	add hl,bc			;06fe
	ld d,(hl)			;06ff
	ld hl,(l0113h+1)		;0700
	ld bc,00045h		;0703
	add hl,bc			;0706
	ld (hl),d			;0707
	ld bc,0ffffh		;0708
	add hl,bc			;070b
	ld (hl),e			;070c
	ret			;070d
	ld a,0b3h		;070e
	jp l05efh		;0710
	ld a,(hl)			;0713
	and a			;0714
	ret nz			;0715
	ld hl,(l0113h+1)		;0716
	dec hl			;0719
	ld a,(00069h)		;071a
	ld (hl),a			;071d
	inc hl			;071e
	inc hl			;071f
	call sub_0781h		;0720
	ld (hl),a			;0723
	inc hl			;0724
	inc hl			;0725
	call sub_0781h		;0726
	ld (hl),a			;0729
	inc hl			;072a
	call sub_0781h		;072b
	ld (hl),a			;072e
	inc hl			;072f
	call sub_0781h		;0730
	and 00fh		;0733
sub_0735h:
	ld (hl),a			;0735
	inc hl			;0736
	call sub_0781h		;0737
	ld (hl),a			;073a
	inc hl			;073b
	call sub_0781h		;073c
	and 00fh		;073f
	ld (hl),a			;0741
	ld bc,0003fh		;0742
	add hl,bc			;0745
	call sub_0781h		;0746
	and 07fh		;0749
	ld (hl),a			;074b
	ld bc,00006h		;074c
l074fh:
	add hl,bc			;074f
	ld a,(0006bh)		;0750
	ld (hl),a			;0753
	jp l05dah		;0754
	nop			;0757
	ld bc,l0201h		;0758
	ld (bc),a			;075b
	inc bc			;075c
	inc bc			;075d
	inc b			;075e
	inc b			;075f
	dec b			;0760
	dec b			;0761
	ld b,007h		;0762
	rlca			;0764
	ex af,af'			;0765
	ex af,af'			;0766
	ex af,af'			;0767
	add hl,bc			;0768
l0769h:
	add hl,bc			;0769
	ld a,(bc)			;076a
	ld a,(bc)			;076b
	dec bc			;076c
sub_076dh:
	dec bc			;076d
	inc c			;076e
	inc c			;076f
	inc c			;0770
	dec c			;0771
	dec c			;0772
	dec c			;0773
l0774h:
	ld c,00eh		;0774
l0776h:
	ld c,00eh		;0776
	rrca			;0778
	rrca			;0779
	rrca			;077a
	rrca			;077b
	rrca			;077c
	djnz l078fh		;077d
	djnz l0791h		;077f
sub_0781h:
	djnz l0793h		;0781
	djnz l0795h		;0783
	djnz l0797h		;0785
	djnz l0799h		;0787
	djnz l079bh		;0789
	djnz l079ch		;078b
	rrca			;078d
	rrca			;078e
l078fh:
	rrca			;078f
sub_0790h:
	rrca			;0790
l0791h:
	ld c,00eh		;0791
l0793h:
	ld c,00eh		;0793
l0795h:
	dec c			;0795
	dec c			;0796
l0797h:
	dec c			;0797
	inc c			;0798
l0799h:
	inc c			;0799
	inc c			;079a
l079bh:
	dec bc			;079b
l079ch:
	dec bc			;079c
	ld a,(bc)			;079d
	ld a,(bc)			;079e
	add hl,bc			;079f
	add hl,bc			;07a0
l07a1h:
	ex af,af'			;07a1
	ex af,af'			;07a2
	ex af,af'			;07a3
	rlca			;07a4
	rlca			;07a5
	ld b,005h		;07a6
	dec b			;07a8
	inc b			;07a9
	inc b			;07aa
	inc bc			;07ab
	inc bc			;07ac
l07adh:
	ld (bc),a			;07ad
	ld (bc),a			;07ae
	ld bc,00001h		;07af
l07b2h:
	rst 38h			;07b2
	rst 38h			;07b3
	cp 0feh		;07b4
	defb 0fdh,0fdh,0fch	;illegal sequence		;07b6
	call m,0fbfbh		;07b9
	jp m,0f9f9h		;07bc
	ret m			;07bf
	ret m			;07c0
	ret m			;07c1
	rst 30h			;07c2
	rst 30h			;07c3
	or 0f6h		;07c4
	push af			;07c6
	push af			;07c7
	call p,0f4f4h		;07c8
	di			;07cb
	di			;07cc
	di			;07cd
	jp p,0f2f2h		;07ce
	jp p,0f1f1h		;07d1
	pop af			;07d4
l07d5h:
	pop af			;07d5
	pop af			;07d6
	ret p			;07d7
	ret p			;07d8
	ret p			;07d9
	ret p			;07da
	ret p			;07db
	ret p			;07dc
	ret p			;07dd
	ret p			;07de
	ret p			;07df
	ret p			;07e0
	ret p			;07e1
	ret p			;07e2
	ret p			;07e3
	ret p			;07e4
	ret p			;07e5
	pop af			;07e6
l07e7h:
	pop af			;07e7
l07e8h:
	pop af			;07e8
	pop af			;07e9
	pop af			;07ea
	jp p,0f2f2h		;07eb
	jp p,0f3f3h		;07ee
	di			;07f1
	call p,0f4f4h		;07f2
	push af			;07f5
	push af			;07f6
l07f7h:
	or 0f6h		;07f7
	rst 30h			;07f9
	rst 30h			;07fa
	ret m			;07fb
	ret m			;07fc
	ret m			;07fd
l07feh:
	ld sp,hl			;07fe
	ld sp,hl			;07ff
	jp m,0fbfbh		;0800
	call m,0fdfch		;0803
	defb 0fdh,0feh,0feh	;illegal sequence		;0806
	rst 38h			;0809
	rst 38h			;080a
	nop			;080b
	ld bc,l0201h		;080c
	ld (bc),a			;080f
	inc bc			;0810
	inc bc			;0811
	inc b			;0812
	inc b			;0813
	dec b			;0814
	dec b			;0815
	ld b,007h		;0816
	rlca			;0818
	ex af,af'			;0819
	ex af,af'			;081a
	ex af,af'			;081b
	add hl,bc			;081c
	add hl,bc			;081d
	ld a,(bc)			;081e
	ld a,(bc)			;081f
	dec bc			;0820
	dec bc			;0821
	inc c			;0822
	inc c			;0823
	inc c			;0824
	dec c			;0825
	dec c			;0826
	dec c			;0827
	ld c,00eh		;0828
	ld c,00eh		;082a
	rrca			;082c
l082dh:
	rrca			;082d
	rrca			;082e
	rrca			;082f
l0830h:
	rrca			;0830
	djnz l0843h		;0831
	djnz l0845h		;0833
l0835h:
	djnz l0847h		;0835
	djnz l0890h		;0837
	ld a,c			;0839
	and 0f8h		;083a
l083ch:
	rrca			;083c
	rrca			;083d
	rrca			;083e
	rra			;083f
	adc a,000h		;0840
	ld c,a			;0842
l0843h:
	ld a,b			;0843
	rrca			;0844
l0845h:
	rrca			;0845
	rrca			;0846
l0847h:
	rrca			;0847
	ld e,a			;0848
	and 00fh		;0849
	cp 008h		;084b
	jp c,l074fh		;084d
	or 0f0h		;0850
	ld b,a			;0852
	ld a,e			;0853
	and 0f0h		;0854
	add a,c			;0856
	ld c,a			;0857
	jp nc,00759h		;0858
l085bh:
	inc b			;085b
	ld a,d			;085c
	and a			;085d
	jp p,l0769h		;085e
sub_0861h:
	cpl			;0861
	inc a			;0862
	ld d,a			;0863
	xor a			;0864
	sub c			;0865
	ld c,a			;0866
	ld a,000h		;0867
	sbc a,b			;0869
	ld b,a			;086a
	ld a,d			;086b
	call sub_076dh		;086c
	ret			;086f
	ld hl,00000h		;0870
	scf			;0873
	jp l0776h		;0874
	add hl,hl			;0877
	and a			;0878
	rla			;0879
	jp nc,l0774h		;087a
	and a			;087d
	ret z			;087e
l087fh:
	add hl,hl			;087f
	add hl,bc			;0880
	jp l0774h+1		;0881
	push hl			;0884
	ld hl,l011eh		;0885
	ld a,(l0108h)		;0888
	xor (hl)			;088b
	rlca			;088c
	rlca			;088d
	rlca			;088e
	add a,(hl)			;088f
l0890h:
	ld (hl),a			;0890
	pop hl			;0891
	ret			;0892
	ld hl,0006ch		;0893
	ld a,(hl)			;0896
	inc hl			;0897
	ex de,hl			;0898
	cp 001h		;0899
	jp m,l07b2h		;089b
	jp c,l07b2h		;089e
	ld hl,01450h		;08a1
	ld a,(hl)			;08a4
	and a			;08a5
	jp nz,l07adh		;08a6
	ld bc,0000ch		;08a9
	add hl,bc			;08ac
l08adh:
	jp l07a1h		;08ad
	cp 0ffh		;08b0
	jp nz,007f0h		;08b2
	ld bc,0006dh		;08b5
	ld a,b			;08b8
	xor d			;08b9
	jp nz,007c5h		;08ba
	ld a,c			;08bd
	xor e			;08be
	jp nz,007c5h		;08bf
	ld hl,000bah		;08c2
	jp l0793h		;08c5
	ld bc,000bbh		;08c8
	ld a,b			;08cb
	xor d			;08cc
	jp nz,l07e7h		;08cd
	ld a,c			;08d0
	xor e			;08d1
	jp nz,l07e7h		;08d2
	ld de,01450h		;08d5
	ld a,(de)			;08d8
	and a			;08d9
	jp z,l07e8h		;08da
	cp 0ffh		;08dd
	jp z,l07feh		;08df
	ld hl,0000ch		;08e2
	add hl,de			;08e5
sub_08e6h:
	inc de			;08e6
	jp l07a1h		;08e7
	dec de			;08ea
	ld hl,0000ch		;08eb
	add hl,de			;08ee
	ex de,hl			;08ef
	jp l07d5h		;08f0
	inc hl			;08f3
	call sub_0861h		;08f4
	jp c,l0843h		;08f7
	ld bc,0000bh		;08fa
	add hl,bc			;08fd
	jp l07a1h		;08fe
	ld a,(0006ch)		;0901
	cp 001h		;0904
	jp m,l082dh		;0906
	jp c,l082dh		;0909
	ld a,(000bah)		;090c
	cp 001h		;090f
	jp m,l082dh		;0911
	jp c,l082dh		;0914
	ld de,0006dh		;0917
	ld hl,000bbh		;091a
	call sub_0861h		;091d
	jp nc,l082dh		;0920
	ld hl,0006ch		;0923
	ld (hl),000h		;0926
	ld hl,000bah		;0928
	ld (hl),000h		;092b
	call sub_0b46h		;092d
	ld hl,01450h		;0930
	ld a,(hl)			;0933
l0934h:
	and a			;0934
	jp nz,l083ch		;0935
	ld bc,0000ch		;0938
	add hl,bc			;093b
	jp l0830h		;093c
	cp 0ffh		;093f
	ret z			;0941
	dec (hl)			;0942
	jp l0835h		;0943
	dec hl			;0946
	ld (hl),000h		;0947
	inc hl			;0949
	ex de,hl			;094a
	dec hl			;094b
	ld (hl),000h		;094c
l094eh:
	inc hl			;094e
	ex de,hl			;094f
	ld a,(0006ch)		;0950
	and a			;0953
	jp z,l085bh		;0954
	ld a,(000bah)		;0957
	and a			;095a
	jp nz,l07f7h		;095b
	call sub_0b46h		;095e
	jp l07f7h		;0961
	push de			;0964
	push hl			;0965
	ld a,(de)			;0966
	sub (hl)			;0967
	inc de			;0968
	inc hl			;0969
	ld a,(de)			;096a
	sbc a,(hl)			;096b
	jp p,0086dh		;096c
	cpl			;096f
	cp 007h		;0970
	jp nc,00887h		;0972
	ld b,a			;0975
	inc de			;0976
	inc hl			;0977
	ld a,(de)			;0978
	sub (hl)			;0979
	inc de			;097a
	inc hl			;097b
	ld a,(de)			;097c
	sbc a,(hl)			;097d
	jp p,l087fh		;097e
	cpl			;0981
	cp 007h		;0982
	jp nc,00887h		;0984
	add a,b			;0987
	cp 009h		;0988
	pop hl			;098a
	pop de			;098b
	ret			;098c
	ld a,(0011ch)		;098d
	and 001h		;0990
	jp nz,008dbh		;0992
	ld hl,(l0116h+2)		;0995
	ld a,(hl)			;0998
	cp 0feh		;0999
	jp z,l08adh		;099b
	cp 0ffh		;099e
	jp z,008b3h		;09a0
	inc hl			;09a3
l09a4h:
	ld e,(hl)			;09a4
	inc hl			;09a5
	ld d,(hl)			;09a6
	inc hl			;09a7
	ex de,hl			;09a8
	cpl			;09a9
	and (hl)			;09aa
	ld (hl),a			;09ab
	ex de,hl			;09ac
	jp 00895h		;09ad
	ld hl,l0abah		;09b0
	jp 008b4h		;09b3
	inc hl			;09b6
	ld (l0116h+2),hl		;09b7
	ld a,(hl)			;09ba
	cp 0feh		;09bb
	jp z,008ceh		;09bd
	cp 0ffh		;09c0
	jp z,008ceh		;09c2
	inc hl			;09c5
	ld e,(hl)			;09c6
	inc hl			;09c7
	ld d,(hl)			;09c8
	inc hl			;09c9
	ex de,hl			;09ca
	or (hl)			;09cb
	ld (hl),a			;09cc
	ex de,hl			;09cd
	jp 008b7h		;09ce
	ld hl,0006ch		;09d1
	call sub_08e6h		;09d4
l09d7h:
	ld hl,000bah		;09d7
	call sub_08e6h		;09da
	ret			;09dd
	ld hl,(l011ah)		;09de
	ld bc,00960h		;09e1
	add hl,bc			;09e4
	ld (l011ah),hl		;09e5
	ret			;09e8
	ld a,(hl)			;09e9
	cp 001h		;09ea
	jp nz,l0a0ch		;09ec
	inc hl			;09ef
	inc hl			;09f0
	ld (l0113h+1),hl		;09f1
	ld a,(hl)			;09f4
	xor 080h		;09f5
	jp p,008f9h		;09f7
	cpl			;09fa
	inc a			;09fb
	ld (l011eh+2),a		;09fc
	ld c,a			;09ff
	ld b,000h		;0a00
	call sub_076dh		;0a02
	push hl			;0a05
	ld hl,(l0113h+1)		;0a06
	inc hl			;0a09
	inc hl			;0a0a
	ld a,(hl)			;0a0b
l0a0ch:
	xor 080h		;0a0c
	jp p,00910h		;0a0e
	cpl			;0a11
	inc a			;0a12
	ld (l0121h),a		;0a13
	ld c,a			;0a16
sub_0a17h:
	ld b,000h		;0a17
	call sub_076dh		;0a19
	pop bc			;0a1c
	add hl,bc			;0a1d
	ld a,h			;0a1e
	and a			;0a1f
	jp z,00929h		;0a20
l0a23h:
	jp p,0092fh		;0a23
	ld hl,07fffh		;0a26
	jp 0092fh		;0a29
	ld a,l			;0a2c
	cp 021h		;0a2d
l0a2fh:
	jp c,009e2h		;0a2f
	ld (l0122h),hl		;0a32
sub_0a35h:
	ld b,008h		;0a35
	add hl,hl			;0a37
	jp c,0093dh		;0a38
	dec b			;0a3b
	add hl,hl			;0a3c
	jp nc,l0934h		;0a3d
	ld hl,(l0122h)		;0a40
	dec b			;0a43
	jp m,l094eh		;0a44
	ld a,h			;0a47
	and a			;0a48
l0a49h:
	rra			;0a49
	ld h,a			;0a4a
	ld a,l			;0a4b
	rra			;0a4c
	ld l,a			;0a4d
	jp 00940h		;0a4e
	inc hl			;0a51
	ld d,002h		;0a52
	ld b,h			;0a54
	ld c,l			;0a55
	push bc			;0a56
	ld hl,(l0122h)		;0a57
	call sub_0a17h		;0a5a
	ld l,a			;0a5d
	ld h,000h		;0a5e
	pop bc			;0a60
	add hl,bc			;0a61
	inc hl			;0a62
	ld a,h			;0a63
	and a			;0a64
	rra			;0a65
l0a66h:
	ld h,a			;0a66
	ld a,l			;0a67
	rra			;0a68
	ld l,a			;0a69
	dec d			;0a6a
	jp nz,00951h		;0a6b
	ld (l0126h),hl		;0a6e
	ld hl,(l0122h)		;0a71
	ld b,h			;0a74
	ld c,l			;0a75
	ld hl,(00062h)		;0a76
	ex de,hl			;0a79
	ld hl,(00064h)		;0a7a
	call sub_0a35h		;0a7d
	ld (00124h),hl		;0a80
	ld a,(l011eh+2)		;0a83
	ld c,a			;0a86
	ld b,000h		;0a87
l0a89h:
	call 00a7bh		;0a89
	ld a,(l0126h)		;0a8c
	ld c,a			;0a8f
	ld a,(l0126h+1)		;0a90
	ld b,a			;0a93
	call sub_0a35h		;0a94
	ex de,hl			;0a97
	ld hl,(l0113h+1)		;0a98
	ld a,(hl)			;0a9b
	and a			;0a9c
l0a9dh:
	jp p,l09a4h		;0a9d
	xor a			;0aa0
	sub e			;0aa1
	ld e,a			;0aa2
	ld a,000h		;0aa3
	sbc a,d			;0aa5
	ld d,a			;0aa6
	inc hl			;0aa7
	inc hl			;0aa8
	inc hl			;0aa9
	ld a,(hl)			;0aaa
	add a,e			;0aab
	ld (hl),a			;0aac
	inc hl			;0aad
	ld a,(hl)			;0aae
	adc a,d			;0aaf
	ld (hl),a			;0ab0
	ld hl,(00124h)		;0ab1
	ld a,(l0121h)		;0ab4
	ld c,a			;0ab7
	ld b,000h		;0ab8
l0abah:
	call 00a7bh		;0aba
	ld a,(l0126h)		;0abd
	ld c,a			;0ac0
	ld a,(l0126h+1)		;0ac1
	ld b,a			;0ac4
	call sub_0a35h		;0ac5
	ex de,hl			;0ac8
	ld hl,(l0113h+1)		;0ac9
	inc hl			;0acc
	inc hl			;0acd
	ld a,(hl)			;0ace
	and a			;0acf
	jp p,l09d7h		;0ad0
	xor a			;0ad3
	sub e			;0ad4
	ld e,a			;0ad5
	ld a,000h		;0ad6
	sbc a,d			;0ad8
	ld d,a			;0ad9
	inc hl			;0ada
	inc hl			;0adb
	inc hl			;0adc
	ld a,(hl)			;0add
	add a,e			;0ade
	ld (hl),a			;0adf
	inc hl			;0ae0
	ld a,(hl)			;0ae1
	adc a,d			;0ae2
	ld (hl),a			;0ae3
	ret			;0ae4
	ld a,(0011ch)		;0ae5
	and 002h		;0ae8
	jp nz,00a01h		;0aea
sub_0aedh:
	ld hl,(l0113h+1)		;0aed
	dec hl			;0af0
	ld a,0ffh		;0af1
	ld (hl),a			;0af3
	inc hl			;0af4
	ld (hl),a			;0af5
	inc hl			;0af6
	ld (hl),a			;0af7
	inc hl			;0af8
	ld (hl),a			;0af9
	inc hl			;0afa
	xor a			;0afb
	ld (hl),a			;0afc
	inc hl			;0afd
	ld (hl),a			;0afe
	inc hl			;0aff
l0b00h:
	ld (hl),a			;0b00
	inc hl			;0b01
	ld (hl),a			;0b02
	ret			;0b03
	ld hl,(l0113h+1)		;0b04
	dec hl			;0b07
	dec hl			;0b08
	ld (hl),000h		;0b09
	call sub_0b46h		;0b0b
	ret			;0b0e
	ld hl,(l011ah)		;0b0f
	ld bc,004b0h		;0b12
	add hl,bc			;0b15
	ld (l011ah),hl		;0b16
	ret			;0b19
	push de			;0b1a
	xor a			;0b1b
	sub b			;0b1c
	ld b,a			;0b1d
	ld a,000h		;0b1e
	sbc a,c			;0b20
	ld c,a			;0b21
	ld a,001h		;0b22
	ld d,h			;0b24
	ld e,l			;0b25
	add hl,bc			;0b26
	jp c,l0a2fh		;0b27
	ld h,d			;0b2a
	ld l,e			;0b2b
	rla			;0b2c
	jp nc,l0a23h		;0b2d
	pop de			;0b30
	ret			;0b31
	rla			;0b32
	jp nc,00a21h		;0b33
	pop de			;0b36
	ret			;0b37
	ld (l012ah),hl		;0b38
	ex de,hl			;0b3b
l0b3ch:
	ld (l0126h+2),hl		;0b3c
	xor a			;0b3f
	sub c			;0b40
	ld c,a			;0b41
	ld a,000h		;0b42
	sbc a,b			;0b44
	ld b,a			;0b45
sub_0b46h:
	ld hl,00001h		;0b46
	ld (l012bh+1),hl		;0b49
	and a			;0b4c
	ld hl,l0126h+2		;0b4d
	ld a,(hl)			;0b50
	rla			;0b51
	ld (hl),a			;0b52
sub_0b53h:
	inc hl			;0b53
	ld a,(hl)			;0b54
	rla			;0b55
	ld (hl),a			;0b56
	inc hl			;0b57
	ld a,(hl)			;0b58
	rla			;0b59
	ld (hl),a			;0b5a
	inc hl			;0b5b
	ld a,(hl)			;0b5c
	rla			;0b5d
	ld (hl),a			;0b5e
	ld hl,(l012ah)		;0b5f
	add hl,bc			;0b62
	jp nc,l0a66h		;0b63
	ld (l012ah),hl		;0b66
	ld hl,l012bh+1		;0b69
	ld a,(hl)			;0b6c
	rla			;0b6d
	ld (hl),a			;0b6e
	inc hl			;0b6f
	ld a,(hl)			;0b70
l0b71h:
	rla			;0b71
	ld (hl),a			;0b72
	jp nc,l0a49h		;0b73
	ld hl,(l012ah)		;0b76
	ex de,hl			;0b79
	ld hl,(l012bh+1)		;0b7a
	ret			;0b7d
	ld (l012bh+1),hl		;0b7e
	ld hl,00000h		;0b81
	ld (l012ah),hl		;0b84
	ld h,080h		;0b87
	ld (l0126h+2),hl		;0b89
	ld hl,l012bh+2		;0b8c
	ld a,(hl)			;0b8f
	rra			;0b90
	ld (hl),a			;0b91
	dec hl			;0b92
	ld a,(hl)			;0b93
	rra			;0b94
	ld (hl),a			;0b95
	jp nc,l0a9dh		;0b96
	ld hl,(l012ah)		;0b99
	add hl,bc			;0b9c
	ld (l012ah),hl		;0b9d
	ld hl,l012bh		;0ba0
	ld a,(hl)			;0ba3
	rra			;0ba4
	ld (hl),a			;0ba5
	dec hl			;0ba6
	ld a,(hl)			;0ba7
	rra			;0ba8
	ld (hl),a			;0ba9
	dec hl			;0baa
	ld a,(hl)			;0bab
	rra			;0bac
	ld (hl),a			;0bad
	dec hl			;0bae
	ld a,(hl)			;0baf
	rra			;0bb0
	ld (hl),a			;0bb1
	jp nc,l0a89h		;0bb2
	ld hl,(l0126h+2)		;0bb5
	ex de,hl			;0bb8
	ld hl,(l012ah)		;0bb9
	ret			;0bbc
	xor b			;0bbd
	rst 38h			;0bbe
	add hl,de			;0bbf
	inc b			;0bc0
	ret po			;0bc1
	dec de			;0bc2
	ex af,af'			;0bc3
	ret p			;0bc4
	dec de			;0bc5
	djnz l0bd7h		;0bc6
	inc e			;0bc8
	jr nz,l0beah		;0bc9
	inc e			;0bcb
	dec d			;0bcc
	nop			;0bcd
	ld e,0ffh		;0bce
	add a,b			;0bd0
	rst 28h			;0bd1
	add hl,de			;0bd2
	ld h,b			;0bd3
	rst 38h			;0bd4
	add hl,de			;0bd5
	ld c,l			;0bd6
l0bd7h:
	ret p			;0bd7
	dec de			;0bd8
	or d			;0bd9
	rrca			;0bda
	inc e			;0bdb
	inc bc			;0bdc
	nop			;0bdd
	ld e,001h		;0bde
	djnz l0c00h		;0be0
	rst 38h			;0be2
	ret nc			;0be3
	rst 38h			;0be4
	add hl,de			;0be5
	rlca			;0be6
	ret p			;0be7
	dec de			;0be8
	ret po			;0be9
l0beah:
	rrca			;0bea
	inc e			;0beb
	dec bc			;0bec
	nop			;0bed
	ld e,0feh		;0bee
	ld a,(0011ch)		;0bf0
	and 004h		;0bf3
	ret nz			;0bf5
	ld hl,(l010bh+1)		;0bf6
	ld bc,00004h		;0bf9
	add hl,bc			;0bfc
	ld (l010bh+1),hl		;0bfd
l0c00h:
	ld hl,00f9fh		;0c00
	ld a,(hl)			;0c03
	cp 0ffh		;0c04
	ret z			;0c06
	push hl			;0c07
	inc hl			;0c08
l0c09h:
	ld e,(hl)			;0c09
	inc hl			;0c0a
	ld d,(hl)			;0c0b
	inc hl			;0c0c
	ex de,hl			;0c0d
	cpl			;0c0e
	and (hl)			;0c0f
	ld (hl),a			;0c10
	ex de,hl			;0c11
	ld e,(hl)			;0c12
	inc hl			;0c13
	ld d,(hl)			;0c14
	inc hl			;0c15
	ld c,(hl)			;0c16
	ld hl,(l010bh+1)		;0c17
	add hl,de			;0c1a
	ld a,h			;0c1b
	rlca			;0c1c
l0c1dh:
	ld d,a			;0c1d
	and 081h		;0c1e
	jp nz,l0b3ch		;0c20
	ld a,l			;0c23
	rlca			;0c24
	and 001h		;0c25
	or d			;0c27
	cpl			;0c28
	ld b,a			;0c29
	call sub_0319h		;0c2a
	ex de,hl			;0c2d
	pop hl			;0c2e
	ld (hl),a			;0c2f
	inc hl			;0c30
	ld (hl),e			;0c31
	inc hl			;0c32
	ld (hl),d			;0c33
	inc hl			;0c34
	ex de,hl			;0c35
	or (hl)			;0c36
	ld (hl),a			;0c37
	ex de,hl			;0c38
	inc hl			;0c39
	inc hl			;0c3a
	inc hl			;0c3b
	jp l0b00h		;0c3c
	pop hl			;0c3f
	ld (hl),000h		;0c40
	ld bc,00006h		;0c42
	add hl,bc			;0c45
	jp l0b00h		;0c46
	push hl			;0c49
	ld hl,(l0108h)		;0c4a
	ld bc,000c8h		;0c4d
	add hl,bc			;0c50
	ld (l010ah),hl		;0c51
	pop hl			;0c54
l0c55h:
	ret			;0c55
	ld a,(0006ch)		;0c56
	cp 001h		;0c59
	jp nz,l0b71h		;0c5b
	ld a,(000bah)		;0c5e
	cp 001h		;0c61
	jp z,00b80h		;0c63
	ld a,(0011dh)		;0c66
	add a,010h		;0c69
	ld (0011dh),a		;0c6b
	cpl			;0c6e
	out (0ffh),a		;0c6f
	jp 00b80h		;0c71
	ld a,(000bah)		;0c74
	cp 001h		;0c77
	jp nz,00b80h		;0c79
	ld a,(0011dh)		;0c7c
	inc a			;0c7f
	jp 00b68h		;0c80
	ld hl,0c000h		;0c83
	ld (000bbh),hl		;0c86
	ld (0006fh),hl		;0c89
	ld hl,04000h		;0c8c
	ld (0006dh),hl		;0c8f
	ld (000bdh),hl		;0c92
	ld hl,00000h		;0c95
	ld (00071h),hl		;0c98
	ld (000bfh),hl		;0c9b
	ld (00073h),hl		;0c9e
	ld (000c1h),hl		;0ca1
	ld a,001h		;0ca4
	ld (0006ch),a		;0ca6
	ld (000bah),a		;0ca9
	ld a,000h		;0cac
l0caeh:
	ld (000b4h),a		;0cae
	ld (l0100h+2),a		;0cb1
	ld (000b2h),a		;0cb4
	ld (l0100h),a		;0cb7
	ld (000b9h),a		;0cba
	ld (l0107h),a		;0cbd
l0cc0h:
	ld (000b8h),a		;0cc0
	ld (l0106h),a		;0cc3
	ld a,0ffh		;0cc6
	ld (01450h),a		;0cc8
	ld (00075h),a		;0ccb
	ld (000c3h),a		;0cce
	ld a,(00066h)		;0cd1
	ld (000b5h),a		;0cd4
	ld (l0103h),a		;0cd7
	ld hl,(0005eh)		;0cda
	ld (000b6h),hl		;0cdd
	ld (l0103h+1),hl		;0ce0
	ld a,087h		;0ce3
	ld (000b3h),a		;0ce5
	ld a,02dh		;0ce8
	ld (l0100h+1),a		;0cea
	ld a,010h		;0ced
	ld (000ffh),a		;0cef
	ld a,0f0h		;0cf2
l0cf4h:
	ld (000b1h),a		;0cf4
	call 00ca8h		;0cf7
	ld hl,00aech		;0cfa
	ld (l0116h+2),hl		;0cfd
	ret			;0d00
	cp 0e0h		;0d01
	ret nc			;0d03
	ld a,b			;0d04
l0d05h:
	or 00ch		;0d05
	ld b,a			;0d07
	ex (sp),hl			;0d08
	add hl,de			;0d09
	ex (sp),hl			;0d0a
	ret			;0d0b
	ld sp,01800h		;0d0c
l0d0fh:
	ld hl,00001h		;0d0f
	ld (l011ah),hl		;0d12
	ld hl,00000h		;0d15
	ld (l0108h),hl		;0d18
	ld b,0c8h		;0d1b
	ld hl,00f9fh		;0d1d
	xor a			;0d20
	ld (hl),a			;0d21
	inc hl			;0d22
	ld (hl),a			;0d23
	inc hl			;0d24
	ld (hl),a			;0d25
	inc hl			;0d26
	call sub_0781h		;0d27
	ld (hl),a			;0d2a
l0d2bh:
	inc hl			;0d2b
	call sub_0781h		;0d2c
	ld (hl),a			;0d2f
	inc hl			;0d30
	call sub_0781h		;0d31
	ld (hl),a			;0d34
	inc hl			;0d35
	ld a,(l0108h)		;0d36
	inc a			;0d39
	ld (l0108h),a		;0d3a
	dec b			;0d3d
	jp nz,l0c1dh		;0d3e
	ld (hl),0ffh		;0d41
	call sub_0b53h		;0d43
	ld a,08ch		;0d46
	out (00eh),a		;0d48
	ld a,06ch		;0d4a
	out (00fh),a		;0d4c
	xor a			;0d4e
	ld (0011dh),a		;0d4f
	cpl			;0d52
	out (0ffh),a		;0d53
	jp 00ca2h		;0d55
	call sub_0412h		;0d58
	call 0039ch		;0d5b
	call sub_0790h		;0d5e
	call sub_012eh		;0d61
l0d64h:
	call 00352h		;0d64
	call 0088ah		;0d67
	ld hl,(l011ah)		;0d6a
	dec hl			;0d6d
	ld a,h			;0d6e
	or l			;0d6f
l0d70h:
	jp nz,00c6ah		;0d70
	ld hl,00001h		;0d73
	ld (l011ah),hl		;0d76
	ld hl,(l0108h)		;0d79
	inc hl			;0d7c
	ld (l0108h),hl		;0d7d
	ld a,(l0108h)		;0d80
	rlca			;0d83
	rlca			;0d84
	rlca			;0d85
	rlca			;0d86
	and 001h		;0d87
	ld a,(01800h)		;0d89
l0d8ch:
	ld a,(l010ah)		;0d8c
	cp l			;0d8f
	jp nz,00c9ah		;0d90
	ld a,(l010bh)		;0d93
	cp h			;0d96
	jp nz,00c9ah		;0d97
	call sub_0b53h		;0d9a
	ld a,(l0108h)		;0d9d
	and 007h		;0da0
	jp nz,00ca5h		;0da2
	call sub_0aedh		;0da5
	jp l0c55h		;0da8
	ld hl,01800h		;0dab
	ld de,02000h		;0dae
l0db1h:
	xor a			;0db1
	ld (hl),a			;0db2
	inc hl			;0db3
	ld a,e			;0db4
	cp l			;0db5
	jp nz,l0caeh		;0db6
	ld a,d			;0db9
l0dbah:
	cp h			;0dba
	jp nz,l0caeh		;0dbb
	ret			;0dbe
	rst 38h			;0dbf
	rst 38h			;0dc0
	rst 38h			;0dc1
	rst 38h			;0dc2
	in a,(01ah)		;0dc3
l0dc5h:
	rlca			;0dc5
	rrca			;0dc6
	rra			;0dc7
	ld (00dd1h),a		;0dc8
	in a,(019h)		;0dcb
	rlca			;0dcd
	rrca			;0dce
	rra			;0dcf
	ld (00dd2h),a		;0dd0
l0dd3h:
	in a,(01ch)		;0dd3
l0dd5h:
	rlca			;0dd5
	rrca			;0dd6
	rra			;0dd7
	ld (l0dd3h),a		;0dd8
	in a,(01bh)		;0ddb
	rlca			;0ddd
	rrca			;0dde
	rra			;0ddf
	ld (l0dd3h+1),a		;0de0
	xor a			;0de3
	ld (0011ch),a		;0de4
	in a,(018h)		;0de7
	and 006h		;0de9
	jp nz,l0cf4h		;0deb
	in a,(018h)		;0dee
	rlca			;0df0
	rlca			;0df1
	rlca			;0df2
	cpl			;0df3
	ld (0011ch),a		;0df4
	in a,(018h)		;0df7
	and 060h		;0df9
	jp nz,l0d05h		;0dfb
	in a,(018h)		;0dfe
	rrca			;0e00
	cpl			;0e01
	ld (0011ch),a		;0e02
	jp 00ce4h		;0e05
	in a,(018h)		;0e08
	and 006h		;0e0a
	jp z,00cebh		;0e0c
	jp l0c09h		;0e0f
	push bc			;0e12
	ld b,000h		;0e13
	ld a,(00dd1h)		;0e15
	ld c,a			;0e18
	in a,(01ah)		;0e19
	rlca			;0e1b
	rrca			;0e1c
	rra			;0e1d
	sub c			;0e1e
	jp m,l0d2bh		;0e1f
	cp 00ah		;0e22
	jp c,00d37h		;0e24
	ld a,b			;0e27
	or 002h		;0e28
	ld b,a			;0e2a
	jp 00d37h		;0e2b
	cp 0e0h		;0e2e
	jp nc,00d37h		;0e30
	ld a,b			;0e33
	or 00ch		;0e34
	ld b,a			;0e36
	jp l0d64h		;0e37
	ld a,(00dd2h)		;0e3a
	ld c,a			;0e3d
	in a,(019h)		;0e3e
	rlca			;0e40
	rrca			;0e41
	rra			;0e42
	sub c			;0e43
	jp m,00d50h		;0e44
	cp 006h		;0e47
	jp c,00d59h		;0e49
	ld a,b			;0e4c
	or 004h		;0e4d
	ld b,a			;0e4f
	jp 00d59h		;0e50
	cp 0fah		;0e53
	jp nc,00d59h		;0e55
	ld a,b			;0e58
	or 008h		;0e59
	ld b,a			;0e5b
	in a,(018h)		;0e5c
	and 001h		;0e5e
	jp nz,l0d64h		;0e60
	ld a,b			;0e63
	or 001h		;0e64
	ld b,a			;0e66
	in a,(018h)		;0e67
	and 006h		;0e69
	ld a,b			;0e6b
	pop bc			;0e6c
	jp z,l0cc0h		;0e6d
	jp 00422h		;0e70
	push bc			;0e73
	ld b,000h		;0e74
	ld a,(l0dd3h)		;0e76
	ld c,a			;0e79
	in a,(01ch)		;0e7a
	rlca			;0e7c
	rrca			;0e7d
	rra			;0e7e
	sub c			;0e7f
	jp m,l0d8ch		;0e80
	cp 00ah		;0e83
	jp c,00d98h		;0e85
	ld a,b			;0e88
	or 002h		;0e89
	ld b,a			;0e8b
	jp 00d98h		;0e8c
	cp 0e0h		;0e8f
	jp nc,00d98h		;0e91
	ld a,b			;0e94
	or 00ch		;0e95
	ld b,a			;0e97
	jp l0dc5h		;0e98
	ld a,(l0dd3h+1)		;0e9b
	ld c,a			;0e9e
	in a,(01bh)		;0e9f
	rlca			;0ea1
	rrca			;0ea2
	rra			;0ea3
	sub c			;0ea4
	jp m,l0db1h		;0ea5
	cp 006h		;0ea8
	jp c,l0dbah		;0eaa
	ld a,b			;0ead
	or 004h		;0eae
	ld b,a			;0eb0
	jp l0dbah		;0eb1
	cp 0fah		;0eb4
	jp nc,l0dbah		;0eb6
	ld a,b			;0eb9
	or 008h		;0eba
	ld b,a			;0ebc
	in a,(018h)		;0ebd
	and 010h		;0ebf
	jp nz,l0dc5h		;0ec1
	ld a,b			;0ec4
	or 001h		;0ec5
	ld b,a			;0ec7
	in a,(018h)		;0ec8
	and 060h		;0eca
	ld a,b			;0ecc
	pop bc			;0ecd
	jp z,l0cc0h		;0ece
	jp l0432h		;0ed1
	ld bc,l0302h		;0ed4
	inc b			;0ed7
l0ed8h:
	ld hl,l0103h		;0ed8
	ld de,00000h		;0edb
	ld bc,l0dd5h		;0ede
	ldir				;0ee1
	
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
	
	jp 00000h		;0ee3
