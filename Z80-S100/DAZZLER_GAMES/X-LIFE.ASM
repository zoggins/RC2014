; z80dasm 1.1.6
; command line: z80dasm --labels --origin=0x0100 --address X-LIFE.COM

	org	00100h

	jp init		;0100
l0103h:
	jp 00003h		;0103
	ld sp,l0800h		;0106
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
	ld hl,l0800h		;016b
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
	ld hl,l0800h		;0213
	ld a,b			;0216
	and 020h		;0217
sub_0219h:
	jp z,0011dh		;0219
	ld de,00200h		;021c
	add hl,de			;021f
	ld a,c			;0220
	and 020h		;0221
	jp z,l0127h		;0223
	ld de,l0400h		;0226
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
	jr nz,l03d8h		;0380
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
	jr nz,l03d6h		;0390
	ld b,c			;0392
	ld d,h			;0393
	ld b,c			;0394
	dec c			;0395
	ld a,(bc)			;0396
	nop			;0397
	ld sp,03002h		;0398
	ld (bc),a			;039b
l039ch:
	ld hl,l0103h		;039c
	ld de,00000h		;039f
	ld bc,00299h		;03a2
	ldir		;03a5
	ld hl,l03c9h		;03a7
	ld de,01000h		;03aa
	ld bc,l0803h		;03ad
	ldir		;03b0
	ld hl,01000h		;03b2
	ld de,l07feh		;03b5
	ld bc,l0803h		;03b8
	ldir		;03bb
	ld a,084h		;03bd
	out (00eh),a		;03bf
	ld a,0b0h		;03c1
	out (00fh),a		;03c3
	ld sp,l07feh		;03c5
	ret			;03c8
l03c9h:
	inc c			;03c9
	nop			;03ca
	rrca			;03cb
	nop			;03cc
	nop			;03cd
	nop			;03ce
	nop			;03cf
	nop			;03d0
	nop			;03d1
	nop			;03d2
	nop			;03d3
	nop			;03d4
	nop			;03d5
l03d6h:
	nop			;03d6
	nop			;03d7
l03d8h:
	nop			;03d8
	nop			;03d9
	nop			;03da
	ret p			;03db
	nop			;03dc
	nop			;03dd
	nop			;03de
	nop			;03df
	nop			;03e0
	nop			;03e1
	nop			;03e2
	nop			;03e3
	nop			;03e4
	nop			;03e5
	nop			;03e6
	nop			;03e7
	nop			;03e8
	nop			;03e9
	nop			;03ea
	nop			;03eb
	rrca			;03ec
	nop			;03ed
	nop			;03ee
	nop			;03ef
	nop			;03f0
	nop			;03f1
	nop			;03f2
	nop			;03f3
	nop			;03f4
	nop			;03f5
	nop			;03f6
	nop			;03f7
	nop			;03f8
	nop			;03f9
	nop			;03fa
	nop			;03fb
	ret p			;03fc
	nop			;03fd
	nop			;03fe
	nop			;03ff
l0400h:
	nop			;0400
	nop			;0401
	nop			;0402
	nop			;0403
	nop			;0404
	nop			;0405
	nop			;0406
	nop			;0407
	nop			;0408
	nop			;0409
	nop			;040a
	nop			;040b
	nop			;040c
	rrca			;040d
	nop			;040e
	nop			;040f
	nop			;0410
	nop			;0411
	nop			;0412
	nop			;0413
	nop			;0414
	nop			;0415
	nop			;0416
	nop			;0417
	nop			;0418
	nop			;0419
	nop			;041a
	nop			;041b
	nop			;041c
	ret p			;041d
	nop			;041e
	nop			;041f
	nop			;0420
	nop			;0421
	nop			;0422
	nop			;0423
	nop			;0424
	nop			;0425
	nop			;0426
	nop			;0427
	nop			;0428
	nop			;0429
	nop			;042a
	nop			;042b
	nop			;042c
	nop			;042d
	rrca			;042e
	nop			;042f
	nop			;0430
	nop			;0431
	nop			;0432
	nop			;0433
	nop			;0434
	nop			;0435
	nop			;0436
	nop			;0437
	nop			;0438
	nop			;0439
	nop			;043a
	nop			;043b
	nop			;043c
	nop			;043d
	ret p			;043e
	nop			;043f
	nop			;0440
	nop			;0441
	nop			;0442
	nop			;0443
	nop			;0444
	nop			;0445
	nop			;0446
	nop			;0447
	nop			;0448
	nop			;0449
	nop			;044a
	nop			;044b
	nop			;044c
	nop			;044d
	nop			;044e
	rrca			;044f
	nop			;0450
	nop			;0451
	nop			;0452
	nop			;0453
	nop			;0454
	nop			;0455
	nop			;0456
	nop			;0457
	nop			;0458
	nop			;0459
	nop			;045a
	nop			;045b
	nop			;045c
	nop			;045d
	nop			;045e
	ret p			;045f
	nop			;0460
	nop			;0461
	nop			;0462
	nop			;0463
	nop			;0464
	nop			;0465
	nop			;0466
	nop			;0467
	nop			;0468
	nop			;0469
	nop			;046a
	nop			;046b
	nop			;046c
	nop			;046d
	nop			;046e
	nop			;046f
	rrca			;0470
	nop			;0471
	nop			;0472
	nop			;0473
	nop			;0474
	nop			;0475
	nop			;0476
	nop			;0477
	nop			;0478
	nop			;0479
	nop			;047a
	nop			;047b
	nop			;047c
	nop			;047d
	nop			;047e
	nop			;047f
	ret p			;0480
	nop			;0481
	nop			;0482
	nop			;0483
	nop			;0484
	nop			;0485
	nop			;0486
	nop			;0487
	nop			;0488
	nop			;0489
	nop			;048a
	nop			;048b
	nop			;048c
	nop			;048d
	nop			;048e
	nop			;048f
	nop			;0490
	rrca			;0491
	nop			;0492
	nop			;0493
	nop			;0494
	nop			;0495
	nop			;0496
	nop			;0497
	nop			;0498
	nop			;0499
	nop			;049a
	nop			;049b
	nop			;049c
	nop			;049d
	nop			;049e
	nop			;049f
	nop			;04a0
	ret p			;04a1
	nop			;04a2
	nop			;04a3
	nop			;04a4
	nop			;04a5
	nop			;04a6
	nop			;04a7
	nop			;04a8
	nop			;04a9
	nop			;04aa
	nop			;04ab
	nop			;04ac
	nop			;04ad
	nop			;04ae
	nop			;04af
	nop			;04b0
	nop			;04b1
	rrca			;04b2
	nop			;04b3
	nop			;04b4
	nop			;04b5
	nop			;04b6
	nop			;04b7
	nop			;04b8
	nop			;04b9
	nop			;04ba
	nop			;04bb
	nop			;04bc
	nop			;04bd
	nop			;04be
	nop			;04bf
	nop			;04c0
	nop			;04c1
	ret p			;04c2
	nop			;04c3
	nop			;04c4
	nop			;04c5
	nop			;04c6
	nop			;04c7
	nop			;04c8
	nop			;04c9
	nop			;04ca
	nop			;04cb
	nop			;04cc
	nop			;04cd
	nop			;04ce
	nop			;04cf
	nop			;04d0
	nop			;04d1
	nop			;04d2
	rrca			;04d3
	nop			;04d4
	nop			;04d5
	nop			;04d6
	nop			;04d7
	nop			;04d8
	nop			;04d9
	nop			;04da
	nop			;04db
	nop			;04dc
	nop			;04dd
	nop			;04de
	nop			;04df
	nop			;04e0
	nop			;04e1
	nop			;04e2
	ret p			;04e3
	nop			;04e4
	nop			;04e5
	nop			;04e6
	nop			;04e7
	nop			;04e8
	nop			;04e9
	nop			;04ea
	nop			;04eb
	nop			;04ec
	nop			;04ed
	nop			;04ee
	nop			;04ef
	nop			;04f0
	nop			;04f1
	nop			;04f2
	nop			;04f3
	rrca			;04f4
	nop			;04f5
	nop			;04f6
	nop			;04f7
	nop			;04f8
	nop			;04f9
	nop			;04fa
	nop			;04fb
	nop			;04fc
	nop			;04fd
	nop			;04fe
	nop			;04ff
	nop			;0500
	nop			;0501
	nop			;0502
	nop			;0503
	ret p			;0504
	nop			;0505
	nop			;0506
	nop			;0507
	nop			;0508
	nop			;0509
	nop			;050a
	nop			;050b
	nop			;050c
	nop			;050d
	nop			;050e
	nop			;050f
	nop			;0510
	nop			;0511
	nop			;0512
	nop			;0513
	nop			;0514
	rrca			;0515
	nop			;0516
	nop			;0517
	nop			;0518
	nop			;0519
	nop			;051a
	nop			;051b
	nop			;051c
	nop			;051d
	nop			;051e
	nop			;051f
	nop			;0520
	nop			;0521
	nop			;0522
	nop			;0523
	nop			;0524
	ret p			;0525
	nop			;0526
	nop			;0527
	nop			;0528
	nop			;0529
	nop			;052a
	nop			;052b
	nop			;052c
	nop			;052d
	nop			;052e
	nop			;052f
	nop			;0530
	nop			;0531
	nop			;0532
	nop			;0533
	nop			;0534
	nop			;0535
	rrca			;0536
	nop			;0537
	nop			;0538
	nop			;0539
	nop			;053a
	nop			;053b
	nop			;053c
	nop			;053d
	nop			;053e
	nop			;053f
	nop			;0540
	nop			;0541
	nop			;0542
	nop			;0543
	nop			;0544
	nop			;0545
	ret p			;0546
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
	rrca			;0557
	nop			;0558
	nop			;0559
	nop			;055a
	nop			;055b
	nop			;055c
	nop			;055d
	nop			;055e
	nop			;055f
	nop			;0560
	nop			;0561
	nop			;0562
	nop			;0563
	nop			;0564
	nop			;0565
	nop			;0566
	ret p			;0567
	nop			;0568
	nop			;0569
	nop			;056a
	nop			;056b
	nop			;056c
	nop			;056d
	nop			;056e
	nop			;056f
	nop			;0570
	nop			;0571
	nop			;0572
	nop			;0573
	nop			;0574
	nop			;0575
	nop			;0576
	nop			;0577
	rrca			;0578
	nop			;0579
	nop			;057a
	nop			;057b
	nop			;057c
	nop			;057d
	nop			;057e
	nop			;057f
	nop			;0580
	nop			;0581
	nop			;0582
	nop			;0583
	nop			;0584
	nop			;0585
	nop			;0586
	nop			;0587
	ret p			;0588
	nop			;0589
	nop			;058a
	nop			;058b
	nop			;058c
	nop			;058d
	nop			;058e
	nop			;058f
	nop			;0590
	nop			;0591
	nop			;0592
	nop			;0593
	nop			;0594
	nop			;0595
	nop			;0596
	nop			;0597
	nop			;0598
	rrca			;0599
	nop			;059a
	nop			;059b
	nop			;059c
	nop			;059d
	nop			;059e
	nop			;059f
	nop			;05a0
	nop			;05a1
	nop			;05a2
	nop			;05a3
	nop			;05a4
	nop			;05a5
	nop			;05a6
	nop			;05a7
	nop			;05a8
	ret p			;05a9
	nop			;05aa
	nop			;05ab
	nop			;05ac
	nop			;05ad
	nop			;05ae
	nop			;05af
	nop			;05b0
	nop			;05b1
	nop			;05b2
	nop			;05b3
	nop			;05b4
	nop			;05b5
	nop			;05b6
	nop			;05b7
	nop			;05b8
	nop			;05b9
	rrca			;05ba
	nop			;05bb
	nop			;05bc
	nop			;05bd
	nop			;05be
	nop			;05bf
	nop			;05c0
	nop			;05c1
	nop			;05c2
	nop			;05c3
	nop			;05c4
	nop			;05c5
	nop			;05c6
	nop			;05c7
	nop			;05c8
	nop			;05c9
	ret p			;05ca
	nop			;05cb
	nop			;05cc
	nop			;05cd
	nop			;05ce
	nop			;05cf
	nop			;05d0
	nop			;05d1
	nop			;05d2
	nop			;05d3
	nop			;05d4
	nop			;05d5
	nop			;05d6
	nop			;05d7
	nop			;05d8
	nop			;05d9
	ret p			;05da
	nop			;05db
	nop			;05dc
	nop			;05dd
	nop			;05de
	nop			;05df
	nop			;05e0
	nop			;05e1
	nop			;05e2
	nop			;05e3
	nop			;05e4
	nop			;05e5
	nop			;05e6
	nop			;05e7
	nop			;05e8
	nop			;05e9
	rrca			;05ea
	nop			;05eb
	nop			;05ec
	nop			;05ed
	nop			;05ee
	nop			;05ef
	nop			;05f0
	nop			;05f1
	nop			;05f2
	nop			;05f3
	nop			;05f4
	nop			;05f5
	nop			;05f6
	nop			;05f7
	nop			;05f8
	ret p			;05f9
	nop			;05fa
	nop			;05fb
	nop			;05fc
	nop			;05fd
	nop			;05fe
	nop			;05ff
	nop			;0600
	nop			;0601
	nop			;0602
	nop			;0603
	nop			;0604
	nop			;0605
	nop			;0606
	nop			;0607
	nop			;0608
	rrca			;0609
	nop			;060a
	nop			;060b
	nop			;060c
	nop			;060d
	nop			;060e
	nop			;060f
	nop			;0610
	nop			;0611
	nop			;0612
	nop			;0613
	nop			;0614
	nop			;0615
	nop			;0616
	nop			;0617
	ret p			;0618
	nop			;0619
	nop			;061a
	nop			;061b
	nop			;061c
	nop			;061d
	nop			;061e
	nop			;061f
	nop			;0620
	nop			;0621
	nop			;0622
	nop			;0623
	nop			;0624
	nop			;0625
	nop			;0626
	nop			;0627
	rrca			;0628
	nop			;0629
	nop			;062a
	nop			;062b
	nop			;062c
	nop			;062d
	nop			;062e
	nop			;062f
	nop			;0630
	nop			;0631
	nop			;0632
	nop			;0633
	nop			;0634
	nop			;0635
	nop			;0636
	ret p			;0637
	nop			;0638
	nop			;0639
	nop			;063a
	nop			;063b
	nop			;063c
	nop			;063d
	nop			;063e
	nop			;063f
	nop			;0640
	nop			;0641
	nop			;0642
	nop			;0643
	nop			;0644
	nop			;0645
	nop			;0646
	rrca			;0647
	nop			;0648
	nop			;0649
	nop			;064a
	nop			;064b
	nop			;064c
	nop			;064d
	nop			;064e
	nop			;064f
	nop			;0650
	nop			;0651
	nop			;0652
	nop			;0653
	nop			;0654
	nop			;0655
	ret p			;0656
	nop			;0657
	nop			;0658
	nop			;0659
	nop			;065a
	nop			;065b
	nop			;065c
	nop			;065d
	nop			;065e
	nop			;065f
	nop			;0660
	nop			;0661
	nop			;0662
	nop			;0663
	nop			;0664
	nop			;0665
	rrca			;0666
	nop			;0667
	nop			;0668
	nop			;0669
	nop			;066a
	nop			;066b
	nop			;066c
	nop			;066d
	nop			;066e
	nop			;066f
	nop			;0670
	nop			;0671
	nop			;0672
	nop			;0673
	nop			;0674
	ret p			;0675
	nop			;0676
	nop			;0677
	nop			;0678
	nop			;0679
	nop			;067a
	nop			;067b
	nop			;067c
	nop			;067d
	nop			;067e
	nop			;067f
	nop			;0680
	nop			;0681
	nop			;0682
	nop			;0683
	nop			;0684
	rrca			;0685
	nop			;0686
	nop			;0687
	nop			;0688
	nop			;0689
	nop			;068a
	nop			;068b
	nop			;068c
	nop			;068d
	nop			;068e
	nop			;068f
	nop			;0690
	nop			;0691
	nop			;0692
	nop			;0693
	ret p			;0694
	nop			;0695
	nop			;0696
	nop			;0697
	nop			;0698
	nop			;0699
	nop			;069a
	nop			;069b
	nop			;069c
	nop			;069d
	nop			;069e
	nop			;069f
	nop			;06a0
	nop			;06a1
	nop			;06a2
	nop			;06a3
	rrca			;06a4
	nop			;06a5
	nop			;06a6
	nop			;06a7
	nop			;06a8
	nop			;06a9
	nop			;06aa
	nop			;06ab
	nop			;06ac
	nop			;06ad
	nop			;06ae
	nop			;06af
	nop			;06b0
	nop			;06b1
	nop			;06b2
	ret p			;06b3
	nop			;06b4
	nop			;06b5
	nop			;06b6
	nop			;06b7
	nop			;06b8
	nop			;06b9
	nop			;06ba
	nop			;06bb
	nop			;06bc
	nop			;06bd
	nop			;06be
	nop			;06bf
	nop			;06c0
	nop			;06c1
	nop			;06c2
	rrca			;06c3
	nop			;06c4
	nop			;06c5
	nop			;06c6
	nop			;06c7
	nop			;06c8
	nop			;06c9
	nop			;06ca
	nop			;06cb
	nop			;06cc
	nop			;06cd
	nop			;06ce
	nop			;06cf
	nop			;06d0
	nop			;06d1
	ret p			;06d2
	nop			;06d3
	nop			;06d4
	nop			;06d5
	nop			;06d6
	nop			;06d7
	nop			;06d8
	nop			;06d9
	nop			;06da
	nop			;06db
	nop			;06dc
	nop			;06dd
	nop			;06de
	nop			;06df
	nop			;06e0
	nop			;06e1
	rrca			;06e2
	nop			;06e3
	nop			;06e4
	nop			;06e5
	nop			;06e6
	nop			;06e7
	nop			;06e8
	nop			;06e9
	nop			;06ea
	nop			;06eb
	nop			;06ec
	nop			;06ed
	nop			;06ee
	nop			;06ef
	nop			;06f0
	ret p			;06f1
	nop			;06f2
	nop			;06f3
	nop			;06f4
	nop			;06f5
	nop			;06f6
	nop			;06f7
	nop			;06f8
	nop			;06f9
	nop			;06fa
	nop			;06fb
	nop			;06fc
	nop			;06fd
	nop			;06fe
	nop			;06ff
	nop			;0700
	rrca			;0701
	nop			;0702
	nop			;0703
	nop			;0704
	nop			;0705
	nop			;0706
	nop			;0707
	nop			;0708
	nop			;0709
	nop			;070a
	nop			;070b
	nop			;070c
	nop			;070d
	nop			;070e
	nop			;070f
	ret p			;0710
	nop			;0711
	nop			;0712
	nop			;0713
	nop			;0714
	nop			;0715
	nop			;0716
	nop			;0717
	nop			;0718
	nop			;0719
	nop			;071a
	nop			;071b
	nop			;071c
	nop			;071d
	nop			;071e
	nop			;071f
	rrca			;0720
	nop			;0721
	nop			;0722
	nop			;0723
	nop			;0724
	nop			;0725
	nop			;0726
	nop			;0727
	nop			;0728
	nop			;0729
	nop			;072a
	nop			;072b
	nop			;072c
	nop			;072d
	nop			;072e
	ret p			;072f
	nop			;0730
	nop			;0731
	nop			;0732
	nop			;0733
	nop			;0734
	nop			;0735
	nop			;0736
	nop			;0737
	nop			;0738
	nop			;0739
	nop			;073a
	nop			;073b
	nop			;073c
	nop			;073d
	nop			;073e
	rrca			;073f
	nop			;0740
	nop			;0741
	nop			;0742
	nop			;0743
	nop			;0744
	nop			;0745
	nop			;0746
	nop			;0747
	nop			;0748
	nop			;0749
	nop			;074a
	nop			;074b
	nop			;074c
	nop			;074d
	ret p			;074e
	nop			;074f
	nop			;0750
	nop			;0751
	nop			;0752
	nop			;0753
	nop			;0754
	nop			;0755
	nop			;0756
	nop			;0757
	nop			;0758
	nop			;0759
	nop			;075a
	nop			;075b
	nop			;075c
	nop			;075d
	rrca			;075e
	nop			;075f
	nop			;0760
	nop			;0761
	nop			;0762
	nop			;0763
	nop			;0764
	nop			;0765
	nop			;0766
	nop			;0767
	nop			;0768
	nop			;0769
	nop			;076a
	nop			;076b
	nop			;076c
	ret p			;076d
	nop			;076e
	nop			;076f
	nop			;0770
	nop			;0771
	nop			;0772
	nop			;0773
	nop			;0774
	nop			;0775
	nop			;0776
	nop			;0777
	nop			;0778
	nop			;0779
	nop			;077a
	nop			;077b
	nop			;077c
	rrca			;077d
	nop			;077e
	nop			;077f
	nop			;0780
	nop			;0781
	nop			;0782
	nop			;0783
	nop			;0784
	nop			;0785
	nop			;0786
	nop			;0787
	nop			;0788
	nop			;0789
	nop			;078a
	nop			;078b
	ret p			;078c
	nop			;078d
	nop			;078e
	nop			;078f
	nop			;0790
	nop			;0791
	nop			;0792
	nop			;0793
	nop			;0794
	nop			;0795
	nop			;0796
	nop			;0797
	nop			;0798
	nop			;0799
	nop			;079a
	nop			;079b
	rrca			;079c
	nop			;079d
	nop			;079e
	nop			;079f
	nop			;07a0
	nop			;07a1
	nop			;07a2
	nop			;07a3
	nop			;07a4
	nop			;07a5
	nop			;07a6
	nop			;07a7
	nop			;07a8
	nop			;07a9
	nop			;07aa
	ret p			;07ab
	nop			;07ac
	nop			;07ad
	nop			;07ae
	nop			;07af
	nop			;07b0
	nop			;07b1
	nop			;07b2
	nop			;07b3
	nop			;07b4
	nop			;07b5
	nop			;07b6
	nop			;07b7
	nop			;07b8
	nop			;07b9
	nop			;07ba
	rrca			;07bb
	nop			;07bc
	nop			;07bd
	nop			;07be
	nop			;07bf
	nop			;07c0
	nop			;07c1
	nop			;07c2
	nop			;07c3
	nop			;07c4
	nop			;07c5
	nop			;07c6
	nop			;07c7
	nop			;07c8
	nop			;07c9
	nop			;07ca
	nop			;07cb
	nop			;07cc
	nop			;07cd
	nop			;07ce
	nop			;07cf
	nop			;07d0
	nop			;07d1
	nop			;07d2
	nop			;07d3
	nop			;07d4
	nop			;07d5
	nop			;07d6
	nop			;07d7
	nop			;07d8
	nop			;07d9
	ret p			;07da
	nop			;07db
	nop			;07dc
	nop			;07dd
	nop			;07de
	nop			;07df
	nop			;07e0
	nop			;07e1
	nop			;07e2
	nop			;07e3
	nop			;07e4
	nop			;07e5
	nop			;07e6
	nop			;07e7
	nop			;07e8
	nop			;07e9
	rrca			;07ea
	nop			;07eb
	nop			;07ec
	nop			;07ed
	nop			;07ee
	nop			;07ef
	nop			;07f0
	nop			;07f1
	nop			;07f2
	nop			;07f3
	nop			;07f4
	nop			;07f5
	nop			;07f6
	nop			;07f7
	nop			;07f8
	ret p			;07f9
	nop			;07fa
	nop			;07fb
	nop			;07fc
	nop			;07fd
l07feh:
	nop			;07fe
	nop			;07ff
l0800h:
	nop			;0800
	nop			;0801
	nop			;0802
l0803h:
	nop			;0803
	nop			;0804
	nop			;0805
	nop			;0806
	nop			;0807
	nop			;0808
	rrca			;0809
	nop			;080a
	nop			;080b
	nop			;080c
	nop			;080d
	nop			;080e
	nop			;080f
	nop			;0810
	nop			;0811
	nop			;0812
	nop			;0813
	nop			;0814
	nop			;0815
	nop			;0816
	nop			;0817
	ret p			;0818
	nop			;0819
	nop			;081a
	nop			;081b
	nop			;081c
	nop			;081d
	nop			;081e
	nop			;081f
	nop			;0820
	nop			;0821
	nop			;0822
	nop			;0823
	nop			;0824
	nop			;0825
	nop			;0826
	nop			;0827
	rrca			;0828
	nop			;0829
	nop			;082a
	nop			;082b
	nop			;082c
	nop			;082d
	nop			;082e
	nop			;082f
	nop			;0830
	nop			;0831
	nop			;0832
	nop			;0833
	nop			;0834
	nop			;0835
	nop			;0836
	ret p			;0837
	nop			;0838
	nop			;0839
	nop			;083a
	nop			;083b
	nop			;083c
	nop			;083d
	nop			;083e
	nop			;083f
	nop			;0840
	nop			;0841
	nop			;0842
	nop			;0843
	nop			;0844
	nop			;0845
	nop			;0846
	rrca			;0847
	nop			;0848
	nop			;0849
	nop			;084a
	nop			;084b
	nop			;084c
	nop			;084d
	nop			;084e
	nop			;084f
	nop			;0850
	nop			;0851
	nop			;0852
	nop			;0853
	nop			;0854
	nop			;0855
	ret p			;0856
	nop			;0857
	nop			;0858
	nop			;0859
	nop			;085a
	nop			;085b
	nop			;085c
	nop			;085d
	nop			;085e
	nop			;085f
	nop			;0860
	nop			;0861
	nop			;0862
	nop			;0863
	nop			;0864
	nop			;0865
	rrca			;0866
	nop			;0867
	nop			;0868
	nop			;0869
	nop			;086a
	nop			;086b
	nop			;086c
	nop			;086d
	nop			;086e
	nop			;086f
	nop			;0870
	nop			;0871
	nop			;0872
	nop			;0873
	nop			;0874
	ret p			;0875
	nop			;0876
	nop			;0877
	nop			;0878
	nop			;0879
	nop			;087a
	nop			;087b
	nop			;087c
	nop			;087d
	nop			;087e
	nop			;087f
	nop			;0880
	nop			;0881
	nop			;0882
	nop			;0883
	nop			;0884
	rrca			;0885
	nop			;0886
	nop			;0887
	nop			;0888
	nop			;0889
	nop			;088a
	nop			;088b
	nop			;088c
	nop			;088d
	nop			;088e
	nop			;088f
	nop			;0890
	nop			;0891
	nop			;0892
	nop			;0893
	ret p			;0894
	nop			;0895
	nop			;0896
	nop			;0897
	nop			;0898
	nop			;0899
	nop			;089a
	nop			;089b
	nop			;089c
	nop			;089d
	nop			;089e
	nop			;089f
	nop			;08a0
	nop			;08a1
	nop			;08a2
	nop			;08a3
	rrca			;08a4
	nop			;08a5
	nop			;08a6
	nop			;08a7
	nop			;08a8
	nop			;08a9
	nop			;08aa
	nop			;08ab
	nop			;08ac
	nop			;08ad
	nop			;08ae
	nop			;08af
	nop			;08b0
	nop			;08b1
	nop			;08b2
	ret p			;08b3
	nop			;08b4
	nop			;08b5
	nop			;08b6
	nop			;08b7
	nop			;08b8
	nop			;08b9
	nop			;08ba
	nop			;08bb
	nop			;08bc
	nop			;08bd
	nop			;08be
	nop			;08bf
	nop			;08c0
	nop			;08c1
	nop			;08c2
	rrca			;08c3
	nop			;08c4
	nop			;08c5
	nop			;08c6
	nop			;08c7
	nop			;08c8
	nop			;08c9
	nop			;08ca
	nop			;08cb
	nop			;08cc
	nop			;08cd
	nop			;08ce
	nop			;08cf
	nop			;08d0
	nop			;08d1
	ret p			;08d2
	nop			;08d3
	nop			;08d4
	nop			;08d5
	nop			;08d6
	nop			;08d7
	nop			;08d8
	nop			;08d9
	nop			;08da
	nop			;08db
	nop			;08dc
	nop			;08dd
	nop			;08de
	nop			;08df
	nop			;08e0
	nop			;08e1
	rrca			;08e2
	nop			;08e3
	nop			;08e4
	nop			;08e5
	nop			;08e6
	nop			;08e7
	nop			;08e8
	nop			;08e9
	nop			;08ea
	nop			;08eb
	nop			;08ec
	nop			;08ed
	nop			;08ee
	nop			;08ef
	nop			;08f0
	ret p			;08f1
	nop			;08f2
	nop			;08f3
	nop			;08f4
	nop			;08f5
	nop			;08f6
	nop			;08f7
	nop			;08f8
	nop			;08f9
	nop			;08fa
	nop			;08fb
	nop			;08fc
	nop			;08fd
	nop			;08fe
	nop			;08ff
	nop			;0900
	rrca			;0901
	nop			;0902
	nop			;0903
	nop			;0904
	nop			;0905
	nop			;0906
	nop			;0907
	nop			;0908
	nop			;0909
	nop			;090a
	nop			;090b
	nop			;090c
	nop			;090d
	nop			;090e
	nop			;090f
	ret p			;0910
	nop			;0911
	nop			;0912
	nop			;0913
	nop			;0914
	nop			;0915
	nop			;0916
	nop			;0917
	nop			;0918
	nop			;0919
	nop			;091a
	nop			;091b
	nop			;091c
	nop			;091d
	nop			;091e
	nop			;091f
	rrca			;0920
	nop			;0921
	nop			;0922
	nop			;0923
	nop			;0924
	nop			;0925
	nop			;0926
	nop			;0927
	nop			;0928
	nop			;0929
	nop			;092a
	nop			;092b
	nop			;092c
	nop			;092d
	nop			;092e
	ret p			;092f
	nop			;0930
	nop			;0931
	nop			;0932
	nop			;0933
	nop			;0934
	nop			;0935
	nop			;0936
	nop			;0937
	nop			;0938
	nop			;0939
	nop			;093a
	nop			;093b
	nop			;093c
	nop			;093d
	nop			;093e
	rrca			;093f
	nop			;0940
	nop			;0941
	nop			;0942
	nop			;0943
	nop			;0944
	nop			;0945
	nop			;0946
	nop			;0947
	nop			;0948
	nop			;0949
	nop			;094a
	nop			;094b
	nop			;094c
	nop			;094d
	ret p			;094e
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
	rrca			;095e
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
	ret p			;096d
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
	rrca			;097d
	nop			;097e
	nop			;097f
	nop			;0980
	nop			;0981
	nop			;0982
	nop			;0983
	nop			;0984
	nop			;0985
	nop			;0986
	nop			;0987
	nop			;0988
	nop			;0989
	nop			;098a
	nop			;098b
	ret p			;098c
	nop			;098d
	nop			;098e
	nop			;098f
	nop			;0990
	nop			;0991
	nop			;0992
	nop			;0993
	nop			;0994
	nop			;0995
	nop			;0996
	nop			;0997
	nop			;0998
	nop			;0999
	nop			;099a
	nop			;099b
	rrca			;099c
	nop			;099d
	nop			;099e
	nop			;099f
	nop			;09a0
	nop			;09a1
	nop			;09a2
	nop			;09a3
	nop			;09a4
	nop			;09a5
	nop			;09a6
	nop			;09a7
	nop			;09a8
	nop			;09a9
	nop			;09aa
	ret p			;09ab
	nop			;09ac
	nop			;09ad
	nop			;09ae
	nop			;09af
	nop			;09b0
	nop			;09b1
	nop			;09b2
	nop			;09b3
	nop			;09b4
	nop			;09b5
	nop			;09b6
	nop			;09b7
	nop			;09b8
	nop			;09b9
	nop			;09ba
	rrca			;09bb
	nop			;09bc
	nop			;09bd
	nop			;09be
	nop			;09bf
	nop			;09c0
	nop			;09c1
	nop			;09c2
	nop			;09c3
	nop			;09c4
	nop			;09c5
	nop			;09c6
	nop			;09c7
	nop			;09c8
	nop			;09c9
	nop			;09ca
	rrca			;09cb
	nop			;09cc
	nop			;09cd
	nop			;09ce
	nop			;09cf
	nop			;09d0
	nop			;09d1
	nop			;09d2
	nop			;09d3
	nop			;09d4
	nop			;09d5
	nop			;09d6
	nop			;09d7
	nop			;09d8
	nop			;09d9
	nop			;09da
	ret p			;09db
	nop			;09dc
	nop			;09dd
	nop			;09de
	nop			;09df
	nop			;09e0
	nop			;09e1
	nop			;09e2
	nop			;09e3
	nop			;09e4
	nop			;09e5
	nop			;09e6
	nop			;09e7
	nop			;09e8
	nop			;09e9
	nop			;09ea
	nop			;09eb
	rrca			;09ec
	nop			;09ed
	nop			;09ee
	nop			;09ef
	nop			;09f0
	nop			;09f1
	nop			;09f2
	nop			;09f3
	nop			;09f4
	nop			;09f5
	nop			;09f6
	nop			;09f7
	nop			;09f8
	nop			;09f9
	nop			;09fa
	nop			;09fb
	ret p			;09fc
	nop			;09fd
	nop			;09fe
	nop			;09ff
	nop			;0a00
	nop			;0a01
	nop			;0a02
	nop			;0a03
	nop			;0a04
	nop			;0a05
	nop			;0a06
	nop			;0a07
	nop			;0a08
	nop			;0a09
	nop			;0a0a
	nop			;0a0b
	nop			;0a0c
	rrca			;0a0d
	nop			;0a0e
	nop			;0a0f
	nop			;0a10
	nop			;0a11
	nop			;0a12
	nop			;0a13
	nop			;0a14
	nop			;0a15
	nop			;0a16
	nop			;0a17
	nop			;0a18
	nop			;0a19
	nop			;0a1a
	nop			;0a1b
	nop			;0a1c
	ret p			;0a1d
	nop			;0a1e
	nop			;0a1f
	nop			;0a20
	nop			;0a21
	nop			;0a22
	nop			;0a23
	nop			;0a24
	nop			;0a25
	nop			;0a26
	nop			;0a27
	nop			;0a28
	nop			;0a29
	nop			;0a2a
	nop			;0a2b
	nop			;0a2c
	nop			;0a2d
	rrca			;0a2e
	nop			;0a2f
	nop			;0a30
	nop			;0a31
	nop			;0a32
	nop			;0a33
	nop			;0a34
	nop			;0a35
	nop			;0a36
	nop			;0a37
	nop			;0a38
	nop			;0a39
	nop			;0a3a
	nop			;0a3b
	nop			;0a3c
	nop			;0a3d
	ret p			;0a3e
	nop			;0a3f
	nop			;0a40
	nop			;0a41
	nop			;0a42
	nop			;0a43
	nop			;0a44
	nop			;0a45
	nop			;0a46
	nop			;0a47
	nop			;0a48
	nop			;0a49
	nop			;0a4a
	nop			;0a4b
	nop			;0a4c
	nop			;0a4d
	nop			;0a4e
	rrca			;0a4f
	nop			;0a50
	nop			;0a51
	nop			;0a52
	nop			;0a53
	nop			;0a54
	nop			;0a55
	nop			;0a56
	nop			;0a57
	nop			;0a58
	nop			;0a59
	nop			;0a5a
	nop			;0a5b
	nop			;0a5c
	nop			;0a5d
	nop			;0a5e
	ret p			;0a5f
	nop			;0a60
	nop			;0a61
	nop			;0a62
	nop			;0a63
	nop			;0a64
	nop			;0a65
	nop			;0a66
	nop			;0a67
	nop			;0a68
	nop			;0a69
	nop			;0a6a
	nop			;0a6b
	nop			;0a6c
	nop			;0a6d
	nop			;0a6e
	nop			;0a6f
	rrca			;0a70
	nop			;0a71
	nop			;0a72
	nop			;0a73
	nop			;0a74
	nop			;0a75
	nop			;0a76
	nop			;0a77
	nop			;0a78
	nop			;0a79
	nop			;0a7a
	nop			;0a7b
	nop			;0a7c
	nop			;0a7d
	nop			;0a7e
	nop			;0a7f
	ret p			;0a80
	nop			;0a81
	nop			;0a82
	nop			;0a83
	nop			;0a84
	nop			;0a85
	nop			;0a86
	nop			;0a87
	nop			;0a88
	nop			;0a89
	nop			;0a8a
	nop			;0a8b
	nop			;0a8c
	nop			;0a8d
	nop			;0a8e
	nop			;0a8f
	nop			;0a90
	rrca			;0a91
	nop			;0a92
	nop			;0a93
	nop			;0a94
	nop			;0a95
	nop			;0a96
	nop			;0a97
	nop			;0a98
	nop			;0a99
	nop			;0a9a
	nop			;0a9b
	nop			;0a9c
	nop			;0a9d
	nop			;0a9e
	nop			;0a9f
	nop			;0aa0
	ret p			;0aa1
	nop			;0aa2
	nop			;0aa3
	nop			;0aa4
	nop			;0aa5
	nop			;0aa6
	nop			;0aa7
	nop			;0aa8
	nop			;0aa9
	nop			;0aaa
	nop			;0aab
	nop			;0aac
	nop			;0aad
	nop			;0aae
	nop			;0aaf
	nop			;0ab0
	nop			;0ab1
	rrca			;0ab2
	nop			;0ab3
	nop			;0ab4
	nop			;0ab5
	nop			;0ab6
	nop			;0ab7
	nop			;0ab8
	nop			;0ab9
	nop			;0aba
	nop			;0abb
	nop			;0abc
	nop			;0abd
	nop			;0abe
	nop			;0abf
	nop			;0ac0
	nop			;0ac1
	ret p			;0ac2
	nop			;0ac3
	nop			;0ac4
	nop			;0ac5
	nop			;0ac6
	nop			;0ac7
	nop			;0ac8
	nop			;0ac9
	nop			;0aca
	nop			;0acb
	nop			;0acc
	nop			;0acd
	nop			;0ace
	nop			;0acf
	nop			;0ad0
	nop			;0ad1
	nop			;0ad2
	rrca			;0ad3
	nop			;0ad4
	nop			;0ad5
	nop			;0ad6
	nop			;0ad7
	nop			;0ad8
	nop			;0ad9
	nop			;0ada
	nop			;0adb
	nop			;0adc
	nop			;0add
	nop			;0ade
	nop			;0adf
	nop			;0ae0
	nop			;0ae1
	nop			;0ae2
	ret p			;0ae3
	nop			;0ae4
	nop			;0ae5
	nop			;0ae6
	nop			;0ae7
	nop			;0ae8
	nop			;0ae9
	nop			;0aea
	nop			;0aeb
	nop			;0aec
	nop			;0aed
	nop			;0aee
	nop			;0aef
	nop			;0af0
	nop			;0af1
	nop			;0af2
	nop			;0af3
	rrca			;0af4
	nop			;0af5
	nop			;0af6
	nop			;0af7
	nop			;0af8
	nop			;0af9
	nop			;0afa
	nop			;0afb
	nop			;0afc
	nop			;0afd
	nop			;0afe
	nop			;0aff
	nop			;0b00
	nop			;0b01
	nop			;0b02
	nop			;0b03
	ret p			;0b04
	nop			;0b05
	nop			;0b06
	nop			;0b07
	nop			;0b08
	nop			;0b09
	nop			;0b0a
	nop			;0b0b
	nop			;0b0c
	nop			;0b0d
	nop			;0b0e
	nop			;0b0f
	nop			;0b10
	nop			;0b11
	nop			;0b12
	nop			;0b13
	nop			;0b14
	rrca			;0b15
	nop			;0b16
	nop			;0b17
	nop			;0b18
	nop			;0b19
	nop			;0b1a
	nop			;0b1b
	nop			;0b1c
	nop			;0b1d
	nop			;0b1e
	nop			;0b1f
	nop			;0b20
	nop			;0b21
	nop			;0b22
	nop			;0b23
	nop			;0b24
	ret p			;0b25
	nop			;0b26
	nop			;0b27
	nop			;0b28
	nop			;0b29
	nop			;0b2a
	nop			;0b2b
	nop			;0b2c
	nop			;0b2d
	nop			;0b2e
	nop			;0b2f
	nop			;0b30
	nop			;0b31
	nop			;0b32
	nop			;0b33
	nop			;0b34
	nop			;0b35
	rrca			;0b36
	nop			;0b37
	nop			;0b38
	nop			;0b39
	nop			;0b3a
	nop			;0b3b
	nop			;0b3c
	nop			;0b3d
	nop			;0b3e
	nop			;0b3f
	nop			;0b40
	nop			;0b41
	nop			;0b42
	nop			;0b43
	nop			;0b44
	nop			;0b45
	ret p			;0b46
	nop			;0b47
	nop			;0b48
	nop			;0b49
	nop			;0b4a
	nop			;0b4b
	nop			;0b4c
	nop			;0b4d
	nop			;0b4e
	nop			;0b4f
	nop			;0b50
	nop			;0b51
	nop			;0b52
	nop			;0b53
	nop			;0b54
	nop			;0b55
	nop			;0b56
	rrca			;0b57
	nop			;0b58
	nop			;0b59
	nop			;0b5a
	nop			;0b5b
	nop			;0b5c
	nop			;0b5d
	nop			;0b5e
	nop			;0b5f
	nop			;0b60
	nop			;0b61
	nop			;0b62
	nop			;0b63
	nop			;0b64
	nop			;0b65
	nop			;0b66
	ret p			;0b67
	nop			;0b68
	nop			;0b69
	nop			;0b6a
	nop			;0b6b
	nop			;0b6c
	nop			;0b6d
	nop			;0b6e
	nop			;0b6f
	nop			;0b70
	nop			;0b71
	nop			;0b72
	nop			;0b73
	nop			;0b74
	nop			;0b75
	nop			;0b76
	nop			;0b77
	rrca			;0b78
	nop			;0b79
	nop			;0b7a
	nop			;0b7b
	nop			;0b7c
	nop			;0b7d
	nop			;0b7e
	nop			;0b7f
	nop			;0b80
	nop			;0b81
	nop			;0b82
	nop			;0b83
	nop			;0b84
	nop			;0b85
	nop			;0b86
	nop			;0b87
	ret p			;0b88
	nop			;0b89
	nop			;0b8a
	nop			;0b8b
	nop			;0b8c
	nop			;0b8d
	nop			;0b8e
	nop			;0b8f
	nop			;0b90
	nop			;0b91
	nop			;0b92
	nop			;0b93
	nop			;0b94
	nop			;0b95
	nop			;0b96
	nop			;0b97
	nop			;0b98
	rrca			;0b99
	nop			;0b9a
	nop			;0b9b
	nop			;0b9c
	nop			;0b9d
	nop			;0b9e
	nop			;0b9f
	nop			;0ba0
	nop			;0ba1
	nop			;0ba2
	nop			;0ba3
	nop			;0ba4
	nop			;0ba5
	nop			;0ba6
	nop			;0ba7
	nop			;0ba8
	ret p			;0ba9
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
	nop			;0bb4
	nop			;0bb5
	nop			;0bb6
	nop			;0bb7
	nop			;0bb8
	nop			;0bb9
	rrca			;0bba
	nop			;0bbb
	nop			;0bbc
	nop			;0bbd
	nop			;0bbe
	nop			;0bbf
	nop			;0bc0
	nop			;0bc1
	nop			;0bc2
	nop			;0bc3
	nop			;0bc4
	nop			;0bc5
	nop			;0bc6
	nop			;0bc7
	nop			;0bc8
	nop			;0bc9
	ret p			;0bca
init:
	ld a,000h		
	out (018h),a	
	
	ld a,004h		
	out (00eh),a
	
	jp l039ch		;0100
