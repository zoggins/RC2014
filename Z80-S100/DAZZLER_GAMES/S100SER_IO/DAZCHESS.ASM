; z80dasm 1.1.6
; command line: z80dasm --labels --origin=0x0100 --address DAZCHESS.COM

	org	00100h

LBLOFF:			equ			0103h

CONOUT:		equ		0a3h	; CONSOLE OUT PORT
CONIN:		equ		0a3h	; CONSOLE IN PORT

CONSTATUS:	equ		0a1h	; CONSOLE STATUS PORT
CONCOST:	equ		004h	; SEND STATUS BIT
CONCIST:	equ		001h	; RECV STATUS BIT

	jp l1075h		;0100
l0103h:
	ld sp,l0d82h		;0103
	call 009ach		;0106
	call sub_0e0dh		;0109
	call sub_01dah		;010c
	ld hl,l0b93h		;010f
	call sub_01dah		;0112
	ld hl,00bb9h		;0115
	call sub_01dah		;0118
	call 009ach		;011b
	call sub_05afh		;011e
	ld hl,l0a95h		;0121
	ld (l0a7dh),hl		;0124
	ld hl,l0acbh		;0127
	ld (l0a7dh+2),hl		;012a
	ld hl,l0b01h		;012d
	ld (l0a77h+2),hl		;0130
	ld hl,l0b37h		;0133
	ld (00a7bh),hl		;0136
	xor a			;0139
	ld (l0a74h),a		;013a
	ld (l0a77h+1),a		;013d
	ld (l0a81h+1),a		;0140
	ld (l0a81h),a		;0143
l0146h:
	ld (l0a74h+1),a		;0146
	ld (l0a74h+2),a		;0149
	ld a,010h		;014c
	ld (l0a77h),a		;014e
	ld a,0eeh		;0151
	ld (l0a4dh),a		;0153
	ld (l0a4dh+1),a		;0156
	ld hl,00bf5h		;0159
sub_015ch:
	call sub_0e1ch		;015c
	call 009c9h		;015f
	call 009bfh		;0162
	ld a,b			;0165
	rrca			;0166
	jp nc,0006fh		;0167
	ld a,001h		;016a
	ld (l0a81h+1),a		;016c
	call sub_05c3h		;016f
	call 009ach		;0172
	call 00242h		;0175
	ld sp,l0d82h		;0178
	ld hl,l0de6h		;017b
	ld (l0a57h+2),hl		;017e
	ld hl,02020h		;0181
	ld (l0c20h),hl		;0184
	ld hl,l0c10h		;0187
	call sub_015ch		;018a
	call sub_0320h		;018d
	call 009ach		;0190
	ld hl,00d0ah		;0193
	ld a,(hl)			;0196
	cp 047h		;0197
sub_0199h:
	jp z,000d7h		;0199
	cp 044h		;019c
	jp z,l0342h		;019e
	cp 045h		;01a1
	jp z,l022ch		;01a3
	cp 053h		;01a6
	jp z,l01e1h		;01a8
	cp 04fh		;01ab
sub_01adh:
	jp z,003d1h		;01ad
	cp 052h		;01b0
	jp z,l0220h		;01b2
	cp 041h		;01b5
	jp z,002f1h		;01b7
	cp 04eh		;01ba
	jp z,00305h		;01bc
	call 00168h		;01bf
	ld a,(l0d0fh)		;01c2
	cp 04dh		;01c5
	jp z,00126h		;01c7
	cp 03dh		;01ca
	jp z,l0348h		;01cc
	cp 00dh		;01cf
	jp nz,0012ch		;01d1
	call sub_086dh		;01d4
	call 00242h		;01d7
sub_01dah:
	call sub_047dh		;01da
	ld a,(l0a77h+1)		;01dd
	or a			;01e0
l01e1h:
	jp z,000f4h		;01e1
	ld hl,0204fh		;01e4
	ld (l0c1eh),hl		;01e7
	ld hl,04f20h		;01ea
	ld (l0c1bh),hl		;01ed
	xor a			;01f0
	ld (l0a77h+1),a		;01f1
	jp 00102h		;01f4
	call sub_01adh		;01f7
	call 00397h		;01fa
	ld a,(l0a4dh+2)		;01fd
	cp 0ffh		;0200
	jp z,00138h		;0202
	ld hl,l0c16h		;0205
	call sub_015ch		;0208
	ld a,(l0a81h)		;020b
	cp 0ffh		;020e
	jp z,00317h		;0210
	ld a,(l0a74h)		;0213
	or a			;0216
	jp z,0011dh		;0217
	ld hl,l0caeh		;021a
	call sub_015ch		;021d
l0220h:
	call 009ach		;0220
	call 00242h		;0223
	jp 00075h		;0226
	call sub_086dh		;0229
l022ch:
	jp 00072h		;022c
	ld hl,l0c23h		;022f
	call sub_015ch		;0232
	call 009ach		;0235
	jp 00075h		;0238
	ld hl,00c30h		;023b
	call sub_01dah		;023e
	call 009ach		;0241
	call 00242h		;0244
sub_0247h:
	ld hl,l0c47h		;0247
	call sub_015ch		;024a
	call 009c9h		;024d
l0250h:
	call 009bfh		;0250
	ld a,b			;0253
	cp 059h		;0254
	jp nz,001c8h		;0256
	call 009ach		;0259
	jp 00018h		;025c
	ld a,(hl)			;025f
	cp 00dh		;0260
	ret z			;0262
	ld b,a			;0263
	call 009bfh		;0264
	inc hl			;0267
	jp sub_015ch		;0268
	ld hl,(00d0ah)		;026b
	call sub_0199h		;026e
	ld (l0a50h),a		;0271
	ld hl,(l0d0dh)		;0274
	call sub_0199h		;0277
	ld (l0a51h),a		;027a
	ld (l0a4dh+1),a		;027d
	ld a,(l0a50h)		;0280
	ld hl,l0a0bh+1		;0283
	ld c,01fh		;0286
	cp (hl)			;0288
l0289h:
	jp z,00191h		;0289
	dec hl			;028c
	dec c			;028d
	jp p,00185h		;028e
l0291h:
	jp 0012ch		;0291
	ld a,c			;0294
	ld (l0a4dh),a		;0295
	ld (l0a4dh+2),a		;0298
	ret			;029b
	ld a,l			;029c
	and 00fh		;029d
	rla			;029f
	rla			;02a0
	rla			;02a1
	rla			;02a2
	ld b,a			;02a3
	ld a,h			;02a4
	and 00fh		;02a5
	or b			;02a7
	ld b,a			;02a8
	and 088h		;02a9
	jp nz,0012ch		;02ab
	ld a,b			;02ae
	ret			;02af
	ld a,(l0a50h)		;02b0
	ld b,a			;02b3
	call sub_098fh		;02b4
	ld hl,(009ddh)		;02b7
	ld (l0c1bh),hl		;02ba
	ld a,(l0a51h)		;02bd
	ld b,a			;02c0
	call sub_098fh		;02c1
	ld hl,(009ddh)		;02c4
	ld (l0c1eh),hl		;02c7
	ret			;02ca
	call 009ach		;02cb
	call 009ach		;02ce
	ld hl,l0c5bh		;02d1
	call sub_015ch		;02d4
	call 009ach		;02d7
	jp l0f61h		;02da
l02ddh:
	call sub_015ch		;02dd
	call 009ach		;02e0
	ret			;02e3
	call 009ach		;02e4
	ld hl,l0bdfh		;02e7
	call sub_015ch		;02ea
	call 009c9h		;02ed
	call 009bfh		;02f0
	ld a,b			;02f3
	cp 053h		;02f4
	jp z,00203h		;02f6
	cp 042h		;02f9
	jp z,0020ah		;02fb
	cp 04eh		;02fe
	jp z,00211h		;0300
	jp 0012ch		;0303
	ld b,000h		;0306
	ld c,0ffh		;0308
	jp 00215h		;030a
	ld b,000h		;030d
	ld c,0fbh		;030f
	jp 00215h		;0311
	ld b,008h		;0314
	ld c,0fbh		;0316
	ld a,b			;0318
	ld (l071eh),a		;0319
	ld a,c			;031c
	ld (00861h),a		;031d
sub_0320h:
	jp 00132h		;0320
	call 009ach		;0323
	ld hl,l0c7eh		;0326
	call sub_015ch		;0329
	jp 0013eh		;032c
	call sub_05c3h		;032f
	ld a,(l0a81h+1)		;0332
	or a			;0335
	jp z,0023ah		;0336
	xor a			;0339
	jp 0023ch		;033a
	ld a,001h		;033d
	ld (l0a81h+1),a		;033f
l0342h:
	jp 00072h		;0342
	call sub_0e25h		;0345
l0348h:
	nop			;0348
	nop			;0349
	nop			;034a
	ld d,000h		;034b
	ld hl,l0cb6h		;034d
	call sub_01dah		;0350
l0353h:
	ld a,d			;0353
	or a			;0354
	jp z,0025bh		;0355
	ld hl,l0cd2h		;0358
	nop			;035b
l035ch:
	nop			;035c
	nop			;035d
	ld b,021h		;035e
	call 009bfh		;0360
	ld b,020h		;0363
	call 009bfh		;0365
	ld hl,l0a0bh+1		;0368
	ld c,01fh		;036b
	ld a,(hl)			;036d
	cp d			;036e
	jp z,002b8h		;036f
l0372h:
	dec hl			;0372
	dec c			;0373
	jp p,0026ah		;0374
	ld a,d			;0377
	and 00fh		;0378
	ld e,a			;037a
	ld a,d			;037b
	and 0f0h		;037c
	rrca			;037e
	rrca			;037f
	rrca			;0380
	rrca			;0381
	add a,e			;0382
l0383h:
	rra			;0383
	jp c,l0289h		;0384
	ld b,020h		;0387
	jp l0289h+2		;0389
	ld b,03ah		;038c
	call 009bfh		;038e
	call 009bfh		;0391
	ld b,020h		;0394
	call 009bfh		;0396
	inc d			;0399
	ld a,d			;039a
	and 00fh		;039b
	cp 008h		;039d
	jp nz,00265h		;039f
	ld b,021h		;03a2
	call 009bfh		;03a4
	call 009ach		;03a7
	ld a,d			;03aa
	add a,008h		;03ab
	ld d,a			;03ad
	jp p,l0250h		;03ae
	ld hl,l0ceeh		;03b1
l03b4h:
	call sub_01dah		;03b4
	call 009ach		;03b7
	ret			;03ba
	ld a,c			;03bb
	cp 010h		;03bc
	jp nc,002d3h		;03be
	ld a,(l0a81h+1)		;03c1
	or a			;03c4
	jp nz,002cch		;03c5
	ld a,(l0a81h+2)		;03c8
	ld b,a			;03cb
	jp l02ddh		;03cc
	ld a,(l0a84h)		;03cf
	ld b,a			;03d2
	jp l02ddh		;03d3
	ld a,(l0a81h+1)		;03d6
	or a			;03d9
	jp nz,002c5h		;03da
	jp 002cch		;03dd
	call 009bfh		;03e0
	ld a,c			;03e3
	and 00fh		;03e4
	ld c,a			;03e6
	ld b,000h		;03e7
	ld hl,l0a84h+1		;03e9
	add hl,bc			;03ec
	ld b,(hl)			;03ed
	call 009bfh		;03ee
	jp l0291h		;03f1
	xor a			;03f4
	ld (00245h),a		;03f5
	jp 00072h		;03f8
	nop			;03fb
	nop			;03fc
	nop			;03fd
	nop			;03fe
	nop			;03ff
	nop			;0400
	nop			;0401
	nop			;0402
	nop			;0403
	nop			;0404
l0405h:
	nop			;0405
	nop			;0406
	nop			;0407
	ld a,0c9h		;0408
	ld (00245h),a		;040a
	jp 00132h		;040d
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
	ld hl,l0c96h		;041a
	call sub_015ch		;041d
	jp 0013eh		;0420
	ld hl,00d0ah		;0423
	ld c,000h		;0426
	call 009c9h		;0428
	ld a,b			;042b
	ld (hl),a			;042c
	cp 00dh		;042d
l042fh:
	jp z,0033ch		;042f
	cp 018h		;0432
	jp z,00132h		;0434
	call 009bfh		;0437
	inc hl			;043a
	inc c			;043b
	jp 00325h		;043c
	xor a			;043f
	cp c			;0440
	jp z,00325h		;0441
	ret			;0444
	call sub_0247h		;0445
	jp 00075h		;0448
	call 00168h		;044b
	ld hl,l0a0bh+1		;044e
	ld c,00fh		;0451
l0453h:
	ld a,(l0a50h)		;0453
	cp (hl)			;0456
	jp z,l035ch		;0457
	dec hl			;045a
	dec c			;045b
	jp p,l0353h		;045c
	ld (hl),0cch		;045f
	ld hl,00a8ch		;0461
	ld c,007h		;0464
	ld a,(l0d10h)		;0466
	cp (hl)			;0469
	jp z,l0372h		;046a
l046dh:
	dec hl			;046d
	dec c			;046e
	jp p,00366h		;046f
	jp 0012ch		;0472
	ld hl,009fdh		;0475
	ld b,000h		;0478
	add hl,bc			;047a
	ld a,0cch		;047b
sub_047dh:
	cp (hl)			;047d
	jp z,l0383h		;047e
	dec hl			;0481
	cp (hl)			;0482
	jp nz,0012ch		;0483
	ld a,(l0a51h)		;0486
	ld (hl),a			;0489
	ld a,(l0d11h)		;048a
	cp 04dh		;048d
	jp z,00072h		;048f
	cp 00dh		;0492
	jp z,000d4h		;0494
	jp 0012ch		;0497
	ld a,(l0a51h)		;049a
	and 0f0h		;049d
	cp 070h		;049f
	ret nz			;04a1
	ld a,(l0a4dh+2)		;04a2
	ld c,a			;04a5
	and 008h		;04a6
	ret z			;04a8
	ld hl,l09edh		;04a9
	ld b,000h		;04ac
	add hl,bc			;04ae
	ld a,0cch		;04af
	ld (hl),a			;04b1
	ld hl,l09eeh		;04b2
	ld e,000h		;04b5
sub_04b7h:
	cp (hl)			;04b7
	jp z,003bdh		;04b8
	inc hl			;04bb
	inc e			;04bc
	jp l03b4h		;04bd
	ld a,(l0a51h)		;04c0
	ld (hl),a			;04c3
	ld a,03dh		;04c4
	ld (l0c20h),a		;04c6
	ld hl,l0a84h+2		;04c9
	ld d,000h		;04cc
	add hl,de			;04ce
sub_04cfh:
	ld a,(hl)			;04cf
	ld (l0c21h),a		;04d0
	ret			;04d3
	ld a,(00d0ch)		;04d4
	cp 04fh		;04d7
	jp nz,0012ch		;04d9
	ld a,(l0d0eh)		;04dc
	cp 04fh		;04df
	jp nz,l042fh		;04e1
	ld a,(l0a81h+1)		;04e4
l04e7h:
	or a			;04e7
	jp z,l0405h		;04e8
l04ebh:
	ld a,(009fdh)		;04eb
	cp 074h		;04ee
	jp nz,0012ch		;04f0
	ld a,072h		;04f3
	ld (009fdh),a		;04f5
	ld a,073h		;04f8
	ld (l0a00h),a		;04fa
	ld (l0a4dh+1),a		;04fd
	ld a,013h		;0500
	ld (l0a4dh),a		;0502
	jp 0041fh		;0505
	ld a,(009fdh)		;0508
	cp 073h		;050b
	jp nz,0012ch		;050d
	ld a,075h		;0510
	ld (009fdh),a		;0512
	ld a,074h		;0515
	ld (l0a00h),a		;0517
	ld (l0a4dh+1),a		;051a
	ld a,013h		;051d
	ld (l0a4dh),a		;051f
	ld a,(l0d0fh)		;0522
	cp 04dh		;0525
	jp z,00072h		;0527
	cp 00dh		;052a
	jp z,000d4h		;052c
	jp 0012ch		;052f
	ld a,(l0a81h+1)		;0532
	or a			;0535
l0536h:
	jp z,l0453h		;0536
	ld a,(009fdh)		;0539
	cp 074h		;053c
	jp nz,0012ch		;053e
	ld a,076h		;0541
	ld (009fdh),a		;0543
	ld a,075h		;0546
	ld (l09ffh),a		;0548
	ld (l0a4dh+1),a		;054b
	ld a,012h		;054e
	ld (l0a4dh),a		;0550
	jp l046dh		;0553
l0556h:
	ld a,(009fdh)		;0556
	cp 073h		;0559
	jp nz,0012ch		;055b
	ld a,071h		;055e
	ld (009fdh),a		;0560
	ld a,072h		;0563
	ld (l09ffh),a		;0565
	ld (l0a4dh+1),a		;0568
l056bh:
	ld a,012h		;056b
	ld (l0a4dh),a		;056d
	ld a,(l0d0dh)		;0570
	cp 04dh		;0573
	jp z,00072h		;0575
	cp 00dh		;0578
	jp z,000d4h		;057a
	jp 0012ch		;057d
	ld hl,(l0a74h+1)		;0580
	ld a,l			;0583
	cp 036h		;0584
	jp nc,l056bh		;0586
	call sub_04cfh		;0589
	push af			;058c
	ld hl,(l0a74h+1)		;058d
	inc hl			;0590
	ld (l0a74h+1),hl		;0591
	pop af			;0594
	jp nc,l056bh		;0595
	call 0054fh		;0598
	call sub_04b7h		;059b
	call sub_086dh		;059e
	ld a,(l0a4dh)		;05a1
	cp 000h		;05a4
	ret nz			;05a6
	ld a,002h		;05a7
	ld (l0a4dh),a		;05a9
	ld a,(l0a4dh+1)		;05ac
sub_05afh:
	xor 003h		;05af
	ld (l0a4dh+1),a		;05b1
	ld (l0a77h+1),a		;05b4
l05b7h:
	jp 00498h		;05b7
	ld hl,l09edh		;05ba
	ld a,(l0a4dh)		;05bd
	ld (l0a4dh+2),a		;05c0
sub_05c3h:
	ld c,a			;05c3
	ld b,000h		;05c4
	add hl,bc			;05c6
	ld a,(hl)			;05c7
	ld (l0a50h),a		;05c8
l05cbh:
	ld a,(l0a4dh+1)		;05cb
	ld (l0a51h),a		;05ce
	ret			;05d1
	call 00504h		;05d2
	jp z,l04ebh		;05d5
	call 0051ch		;05d8
	ld hl,l0a77h		;05db
	dec (hl)			;05de
sub_05dfh:
	jp p,l04e7h		;05df
	xor a			;05e2
l05e3h:
	ld h,000h		;05e3
	ld l,0f0h		;05e5
	ld (l0a74h+1),hl		;05e7
	jp c,sub_04cfh		;05ea
	ret			;05ed
l05eeh:
	call 00529h		;05ee
	ld hl,(l0a74h+1)		;05f1
	ex de,hl			;05f4
	ld hl,(l0a77h+2)		;05f5
	add hl,de			;05f8
	ld a,(hl)			;05f9
	ld (l0a4dh),a		;05fa
	ld hl,(00a7bh)		;05fd
	add hl,de			;0600
	ld a,(hl)			;0601
	ld (l0a4dh+1),a		;0602
	scf			;0605
	ret			;0606
	ld hl,(l0a74h+1)		;0607
	ex de,hl			;060a
	ld hl,(l0a7dh)		;060b
	add hl,de			;060e
	ld a,(l0a4dh)		;060f
	cp (hl)			;0612
	jp nz,0051bh		;0613
	ld hl,(l0a7dh+2)		;0616
	add hl,de			;0619
	ld a,(l0a4dh+1)		;061a
	cp (hl)			;061d
l061eh:
	ret			;061e
	ld hl,(l0a74h+1)		;061f
	ld a,l			;0622
	add a,009h		;0623
	ld l,a			;0625
	ld (l0a74h+1),hl		;0626
	cp 036h		;0629
	ret			;062b
l062ch:
	ld hl,(l0a74h+1)		;062c
	push hl			;062f
	ld a,(l0a77h)		;0630
	ld c,a			;0633
	ld a,0ffh		;0634
	ld (l0a77h),a		;0636
	call 0051ch		;0639
	ld hl,l0a77h		;063c
	inc (hl)			;063f
	jp nc,0054ah		;0640
l0643h:
	dec c			;0643
	jp m,0054ah		;0644
	call 00504h		;0647
	jp z,l0536h		;064a
	pop hl			;064d
	ld (l0a74h+1),hl		;064e
	ret			;0651
	ld a,(l071eh)		;0652
	inc a			;0655
l0656h:
	ld d,a			;0656
	ld b,005h		;0657
	ld c,0ffh		;0659
l065bh:
	ld a,0ffh		;065b
	dec a			;065d
	jp nz,0055ah		;065e
	dec c			;0661
	jp nz,l0556h+2		;0662
	dec b			;0665
	jp nz,l0556h		;0666
	dec d			;0669
	jp nz,00554h		;066a
	ret			;066d
	ld a,00ch		;066e
	ld (l0a54h),a		;0670
	ld (l0a50h),a		;0673
	ld c,014h		;0676
l0678h:
	call sub_05dfh		;0678
	ld a,004h		;067b
	ld (l0a54h),a		;067d
	call 005ddh		;0680
	ld a,(l0a50h)		;0683
	cp 00fh		;0686
	jp c,005a3h		;0688
l068bh:
	ld hl,l09edh		;068b
	ld b,000h		;068e
	ld a,(l0a4dh+2)		;0690
	ld (l0a4dh),a		;0693
	ld c,a			;0696
	add hl,bc			;0697
sub_0698h:
	ld a,(hl)			;0698
	ld (l0a50h),a		;0699
	ld a,(l0a51h)		;069c
	ld (l0a4dh+1),a		;069f
	call sub_086dh		;06a2
	ret			;06a5
	ld a,0ffh		;06a6
	ld (l0a4dh+2),a		;06a8
	ld (l0a50h),a		;06ab
	ld (l0a51h),a		;06ae
	ret			;06b1
	ld hl,l0a0dh		;06b2
	ld de,l09edh		;06b5
	ld c,020h		;06b8
	ld a,(hl)			;06ba
	ld (de),a			;06bb
	inc hl			;06bc
	inc de			;06bd
	dec c			;06be
	jp nz,l05b7h		;06bf
	ret			;06c2
	call sub_05afh		;06c3
	call sub_0e00h		;06c6
	ld de,009fdh		;06c9
	ld c,010h		;06cc
	ld a,077h		;06ce
	sub (hl)			;06d0
	ld b,a			;06d1
l06d2h:
	ex de,hl			;06d2
	ld a,077h		;06d3
	sub (hl)			;06d5
	ld (hl),b			;06d6
	ex de,hl			;06d7
	ld (hl),a			;06d8
	inc hl			;06d9
sub_06dah:
	inc de			;06da
	dec c			;06db
	jp nz,l05cbh		;06dc
	ret			;06df
	ld c,010h		;06e0
	ld hl,l0a5dh		;06e2
	xor a			;06e5
	ld (hl),a			;06e6
	inc hl			;06e7
	dec c			;06e8
	jp p,l05e3h		;06e9
	ld a,010h		;06ec
	ld (l0a4dh),a		;06ee
	ld hl,l0a4dh		;06f1
	dec (hl)			;06f4
	ret m			;06f5
	call 00758h		;06f6
	ld a,008h		;06f9
	ld (l0a55h),a		;06fb
	ld a,(l0a4dh)		;06fe
	cp 008h		;0701
	jp p,l0656h		;0703
	cp 006h		;0706
	jp p,l0643h		;0708
	cp 004h		;070b
	jp p,00635h		;070d
	cp 001h		;0710
l0712h:
	jp z,l061eh		;0712
	jp p,00627h		;0715
	call sub_0698h		;0718
	jp nz,00615h		;071b
l071eh:
	jp l05eeh		;071e
	call 006a9h		;0721
	jp nz,l061eh		;0724
	jp l05eeh		;0727
	ld a,004h		;072a
	ld (l0a55h),a		;072c
	call 006a9h		;072f
	jp nz,l062ch		;0732
	jp l05eeh		;0735
	call 006a9h		;0738
	ld a,(l0a55h)		;073b
	cp 004h		;073e
	jp nz,00635h		;0740
	jp l05eeh		;0743
	ld a,010h		;0746
	ld (l0a55h),a		;0748
	call sub_0698h		;074b
	ld a,(l0a55h)		;074e
l0751h:
	cp 008h		;0751
	jp nz,00648h		;0753
	jp l05eeh		;0756
	ld a,006h		;0759
	ld (l0a55h),a		;075b
	call sub_06dah		;075e
	jp m,0066bh		;0761
	ld a,(l0a51h+1)		;0764
sub_0767h:
	or a			;0767
	jp z,0066bh		;0768
	call sub_0793h		;076b
	call 00758h		;076e
	ld hl,l0a55h		;0771
	dec (hl)			;0774
	ld a,(hl)			;0775
	cp 005h		;0776
	jp z,l065bh		;0778
	call sub_06dah		;077b
	jp c,l068bh		;077e
	jp m,l05eeh		;0781
	ld a,(l0a51h+1)		;0784
	or a			;0787
	jp nz,l05eeh		;0788
	call sub_0793h		;078b
	ld a,(l0a4dh+1)		;078e
	and 0f0h		;0791
sub_0793h:
	cp 020h		;0793
	jp z,l0678h		;0795
	jp l05eeh		;0798
	call sub_06dah		;079b
	jp m,006a1h		;079e
	call sub_0793h		;07a1
	call 00758h		;07a4
	ld hl,l0a55h		;07a7
	dec (hl)			;07aa
	ret			;07ab
	call sub_06dah		;07ac
	jp nc,006c0h		;07af
l07b2h:
	push af			;07b2
	pop hl			;07b3
	ld (00a72h),hl		;07b4
	ld a,(l0a51h+1)		;07b7
	or a			;07ba
	jp z,006a9h		;07bb
l07beh:
	ld hl,(00a72h)		;07be
	push hl			;07c1
	pop af			;07c2
	jp m,l06d2h		;07c3
	ld a,(l0a51h+1)		;07c6
	push af			;07c9
	call sub_0793h		;07ca
l07cdh:
	pop af			;07cd
	ld (l0a51h+1),a		;07ce
	or a			;07d1
	jp z,006a9h		;07d2
	call 00758h		;07d5
	ld hl,l0a55h		;07d8
	dec (hl)			;07db
	ret			;07dc
	ld a,(l0a55h)		;07dd
	ld b,000h		;07e0
	ld hl,l0a2ch		;07e2
	ld c,a			;07e5
	add hl,bc			;07e6
	ld a,(l0a4dh+1)		;07e7
	add a,(hl)			;07ea
	ld (l0a4dh+1),a		;07eb
	and 088h		;07ee
	jp nz,l0751h		;07f0
	ld a,(l0a4dh+1)		;07f3
	ld c,01fh		;07f6
	ld hl,l0a0bh+1		;07f8
l07fbh:
	cp (hl)			;07fb
l07fch:
	jp z,00704h		;07fc
	dec hl			;07ff
	dec c			;0800
	jp p,006f8h		;0801
	jp l0712h		;0804
	ld a,c			;0807
	cp 010h		;0808
	jp c,l0751h		;080a
	ld a,001h		;080d
	ld (l0a51h+1),a		;080f
	jp 00716h		;0812
	xor a			;0815
	ld (l0a51h+1),a		;0816
	ld a,(l0a54h)		;0819
	or a			;081c
	jp m,0074fh		;081d
l0820h:
	cp 000h		;0820
	jp p,0074fh		;0822
	push af			;0825
	ld a,(l0a51h+1)		;0826
	push af			;0829
	ld a,0f9h		;082a
	ld (l0a54h),a		;082c
	ld (l0a51h+2),a		;082f
	call sub_086dh		;0832
	call sub_05c3h		;0835
	call 005e9h		;0838
	call 00770h		;083b
	pop af			;083e
	ld (l0a51h+1),a		;083f
	pop af			;0842
	ld (l0a54h),a		;0843
	ld a,(l0a51h+2)		;0846
	or a			;0849
	jp m,0074fh		;084a
	ld a,080h		;084d
	or a			;084f
	scf			;0850
	ret			;0851
	xor a			;0852
	ret			;0853
	xor a			;0854
	ld (l0a51h+1),a		;0855
	cpl			;0858
	or a			;0859
	ret			;085a
l085bh:
	ld hl,l09edh		;085b
	ld b,000h		;085e
	ld a,(l0a4dh)		;0860
	ld c,a			;0863
	add hl,bc			;0864
	ld a,(hl)			;0865
	ld (l0a4dh+1),a		;0866
	ret			;0869
	call sub_086dh		;086a
sub_086dh:
	call sub_05c3h		;086d
	call 005e9h		;0870
	call sub_05c3h		;0873
	ld hl,00000h		;0876
	add hl,sp			;0879
	ld (l0a57h),hl		;087a
	ld hl,(l0a57h+2)		;087d
	ld sp,hl			;0880
l0881h:
	pop de			;0881
	ld hl,l0a55h		;0882
	ld (hl),d			;0885
	ld hl,l0a4dh		;0886
	ld (hl),e			;0889
l088ah:
	pop bc			;088a
	pop hl			;088b
	ld (hl),c			;088c
	pop hl			;088d
	ld (hl),b			;088e
	ld a,b			;088f
	ld (l0a4dh+1),a		;0890
	jp l08a0h		;0893
	ld a,(l0a54h)		;0896
	or a			;0899
	ld d,000h		;089a
	ld e,a			;089c
	jp m,l0820h		;089d
l08a0h:
	ld a,(l0a4dh)		;08a0
	or a			;08a3
	jp z,l07b2h		;08a4
	ld b,a			;08a7
	ld a,008h		;08a8
	cp e			;08aa
	jp nz,l07b2h		;08ab
	ld a,(l0a64h+1)		;08ae
	cp b			;08b1
	jp z,l07fbh		;08b2
	ld hl,l0a60h+2		;08b5
	add hl,de			;08b8
	inc (hl)			;08b9
	ld a,001h		;08ba
	cp b			;08bc
	jp nz,l07beh		;08bd
	inc (hl)			;08c0
	ld a,(l0a51h+1)		;08c1
	or a			;08c4
	jp z,007f2h		;08c5
	ld c,00fh		;08c8
	ld hl,l0a0bh+1		;08ca
	ld a,(l0a4dh+1)		;08cd
	cp (hl)			;08d0
	jp z,007d7h		;08d1
	dec hl			;08d4
	dec c			;08d5
	jp p,l07cdh		;08d6
	halt			;08d9
	ld hl,l0a3dh		;08da
l08ddh:
	ld b,000h		;08dd
	add hl,bc			;08df
	ld a,(hl)			;08e0
	ld hl,l0a63h		;08e1
	add hl,de			;08e4
	cp (hl)			;08e5
	jp c,007ech		;08e6
	ld (hl),a			;08e9
	ld hl,l0a64h+1		;08ea
	add hl,de			;08ed
	ld (hl),c			;08ee
	ld hl,l0a64h		;08ef
	add hl,de			;08f2
	add a,(hl)			;08f3
	ld (hl),a			;08f4
	ld a,e			;08f5
	cp 004h		;08f6
	jp z,l07fch		;08f8
	jp m,00834h		;08fb
	ret			;08fe
	ld a,(l0a67h)		;08ff
	ld (00a5ch),a		;0902
	xor a			;0905
	ld (l0a54h),a		;0906
	call sub_086dh		;0909
	call sub_05c3h		;090c
	call 005ddh		;090f
	call sub_05c3h		;0912
	ld a,008h		;0915
	ld (l0a54h),a		;0917
	call 005e9h		;091a
	call 00773h		;091d
	jp 008ach		;0920
	ld d,0ffh		;0923
	cp 0f9h		;0925
	jp nz,00834h		;0927
	ld a,(009fdh)		;092a
	ld hl,l0a4dh+1		;092d
l0930h:
	cp (hl)			;0930
	ret nz			;0931
	xor a			;0932
	ld (l0a51h+2),a		;0933
	ret			;0936
	ld a,(l0a51h+1)		;0937
	or a			;093a
	ret z			;093b
	ld a,(l0a4dh+1)		;093c
	ld c,007h		;093f
	ld hl,00a04h		;0941
	cp (hl)			;0944
	jp z,0084bh		;0945
	dec hl			;0948
	dec c			;0949
	jp nz,00841h		;094a
	ret			;094d
	ld hl,l0a3dh		;094e
	ld b,000h		;0951
	add hl,bc			;0953
	ld a,(hl)			;0954
	ld hl,l0a60h+1		;0955
	add hl,de			;0958
	cp (hl)			;0959
l095ah:
	jp c,l085bh		;095a
	ld (hl),a			;095d
	dec de			;095e
	ld a,e			;095f
	ld (l0a54h),a		;0960
	cp 0ffh		;0963
	jp z,00868h		;0965
	call sub_0767h		;0968
	ld hl,l0a54h		;096b
	inc (hl)			;096e
	ret			;096f
	ld hl,00000h		;0970
	add hl,sp			;0973
	ld (l0a57h),hl		;0974
	ld hl,(l0a57h+2)		;0977
	ld sp,hl			;097a
	ld a,(l0a4dh+1)		;097b
	ld b,a			;097e
	ld c,01fh		;097f
	ld hl,l0a0bh+1		;0981
	cp (hl)			;0984
	jp z,l088ah		;0985
	dec hl			;0988
	dec c			;0989
	jp p,l0881h		;098a
	ld (hl),0cch		;098d
sub_098fh:
	push hl			;098f
	ld hl,l09edh		;0990
	ld d,000h		;0993
	ld a,(l0a4dh)		;0995
	ld e,a			;0998
	add hl,de			;0999
	push hl			;099a
	ld c,(hl)			;099b
	ld (hl),b			;099c
	push bc			;099d
	ld hl,l0a55h		;099e
	ld d,(hl)			;09a1
sub_09a2h:
	push de			;09a2
	ld hl,00000h		;09a3
	add hl,sp			;09a6
	ld (l0a57h+2),hl		;09a7
	ld hl,(l0a57h)		;09aa
	ld sp,hl			;09ad
	ret			;09ae
	sub a			;09af
	ld a,080h		;09b0
	ld hl,l0a6ah		;09b2
	add a,(hl)			;09b5
	inc hl			;09b6
	add a,(hl)			;09b7
	inc hl			;09b8
	add a,(hl)			;09b9
	ld hl,l0a60h		;09ba
	add a,(hl)			;09bd
	ld hl,l0a5eh		;09be
	add a,(hl)			;09c1
	ld hl,l0a6eh+1		;09c2
	sub (hl)			;09c5
	inc hl			;09c6
	sub (hl)			;09c7
	ld hl,l0a60h+1		;09c8
	sub (hl)			;09cb
	ld hl,l0a5eh+1		;09cc
	sub (hl)			;09cf
	ld hl,l0a5dh		;09d0
	sub (hl)			;09d3
	ld hl,l0a6eh		;09d4
sub_09d7h:
	sub (hl)			;09d7
	ld hl,l0a60h+2		;09d8
	sub (hl)			;09db
	jp nc,l08ddh		;09dc
	sub a			;09df
	rra			;09e0
	add a,040h		;09e1
	ld hl,l0a6bh		;09e3
	add a,(hl)			;09e6
	inc hl			;09e7
	add a,(hl)			;09e8
	ld hl,l0a63h		;09e9
l09ech:
	sub (hl)			;09ec
l09edh:
	rra			;09ed
l09eeh:
	add a,090h		;09ee
	ld hl,00a5ch		;09f0
	add a,(hl)			;09f3
	add a,(hl)			;09f4
	add a,(hl)			;09f5
	add a,(hl)			;09f6
	ld hl,l0a60h		;09f7
	add a,(hl)			;09fa
	ld hl,l0a63h		;09fb
	sub (hl)			;09fe
l09ffh:
	sub (hl)			;09ff
l0a00h:
	inc hl			;0a00
	sub (hl)			;0a01
	sub (hl)			;0a02
	ld hl,l0a5eh+1		;0a03
	sub (hl)			;0a06
	push af			;0a07
	ld a,(l0a4dh+1)		;0a08
l0a0bh:
	cp 033h		;0a0b
l0a0dh:
	jp z,l0930h		;0a0d
	cp 034h		;0a10
	jp z,l0930h		;0a12
	cp 022h		;0a15
	jp z,l0930h		;0a17
	cp 025h		;0a1a
	jp z,l0930h		;0a1c
	ld a,(l0a4dh)		;0a1f
	or a			;0a22
	jp z,00934h		;0a23
	ld hl,l09edh		;0a26
	ld b,000h		;0a29
	ld c,a			;0a2b
l0a2ch:
	add hl,bc			;0a2c
	ld a,(hl)			;0a2d
	cp 010h		;0a2e
	jp p,00934h		;0a30
	pop af			;0a33
	add a,002h		;0a34
	push af			;0a36
	ld a,(l0a63h)		;0a37
	ld hl,l0a3dh		;0a3a
l0a3dh:
	cp (hl)			;0a3d
	jp nz,00943h		;0a3e
	pop af			;0a41
	sub a			;0a42
	jp l095ah+1		;0a43
	ld a,(l0a60h+2)		;0a46
	or a			;0a49
	jp nz,l095ah		;0a4a
l0a4dh:
	ld a,(l0a6bh+2)		;0a4d
l0a50h:
	or a			;0a50
l0a51h:
	jp nz,l095ah		;0a51
l0a54h:
	pop af			;0a54
l0a55h:
	ld a,0ffh		;0a55
l0a57h:
	ld (l0a81h),a		;0a57
	jp l095ah+1		;0a5a
l0a5dh:
	pop af			;0a5d
l0a5eh:
	ld c,004h		;0a5e
l0a60h:
	ld hl,l0a54h		;0a60
l0a63h:
	ld (hl),c			;0a63
l0a64h:
	ld hl,l0a50h		;0a64
l0a67h:
	ld (00a5bh),a		;0a67
l0a6ah:
	cp (hl)			;0a6a
l0a6bh:
	jp c,0098eh		;0a6b
l0a6eh:
	jp z,0098eh		;0a6e
	ld (l0a50h),a		;0a71
l0a74h:
	ld a,(l0a4dh)		;0a74
l0a77h:
	ld (l0a4dh+2),a		;0a77
	ld a,(l0a4dh+1)		;0a7a
l0a7dh:
	ld (l0a51h),a		;0a7d
	xor a			;0a80
l0a81h:
	ld (l0a74h),a		;0a81
l0a84h:
	ld a,(l0a6bh)		;0a84
	ld hl,l0a3dh		;0a87
	cp (hl)			;0a8a
	jp nz,0098eh		;0a8b
	ld (l0a74h),a		;0a8e
	ret			;0a91
	ld hl,009ddh		;0a92
l0a95h:
	ld b,a			;0a95
	rra			;0a96
	rra			;0a97
	rra			;0a98
	rra			;0a99
	call sub_09a2h		;0a9a
	ld (hl),a			;0a9d
	inc hl			;0a9e
	ld a,b			;0a9f
	call sub_09a2h		;0aa0
	ld (hl),a			;0aa3
	ret			;0aa4
	and 00fh		;0aa5
	add a,030h		;0aa7
	cp 03ah		;0aa9
	ret c			;0aab
	add a,007h		;0aac
	ret			;0aae
	ld b,00dh		;0aaf
	call 009bfh		;0ab1
	ld b,00ah		;0ab4
	call 009bfh		;0ab6
	ld b,07fh		;0ab9
	call 009bfh		;0abb
	call 009bfh		;0abe
	ret			;0ac1
	push hl			;0ac2
	push bc			;0ac3
	push de			;0ac4
	call sub_09d7h		;0ac5
	pop de			;0ac8
	pop bc			;0ac9
	pop hl			;0aca
l0acbh:
	ret			;0acb
	push hl			;0acc
	push de			;0acd
	push bc			;0ace
	call 009dah		;0acf
	ld a,b			;0ad2
	pop bc			;0ad3
	pop de			;0ad4
	pop hl			;0ad5
	and 07fh		;0ad6
	ld b,a			;0ad8
	ret			;0ad9
	jp CO-LBLOFF		;0ada
	jp CI-LBLOFF		;0add
	nop			;0ae0
	nop			;0ae1
	nop			;0ae2
	nop			;0ae3
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
	nop			;0af4
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
l0b01h:
	nop			;0b01
	nop			;0b02
	nop			;0b03
	nop			;0b04
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
	inc bc			;0b10
	inc b			;0b11
	nop			;0b12
	rlca			;0b13
	ld (bc),a			;0b14
	dec b			;0b15
	ld bc,01006h		;0b16
	rla			;0b19
	ld de,01216h		;0b1a
	dec d			;0b1d
	inc d			;0b1e
	inc de			;0b1f
	ld (hl),e			;0b20
	ld (hl),h			;0b21
	ld (hl),b			;0b22
	ld (hl),a			;0b23
	ld (hl),d			;0b24
	ld (hl),l			;0b25
	ld (hl),c			;0b26
	halt			;0b27
	ld h,b			;0b28
	ld h,a			;0b29
	ld h,c			;0b2a
	ld h,(hl)			;0b2b
	ld h,d			;0b2c
	ld h,l			;0b2d
	ld h,h			;0b2e
	ld h,e			;0b2f
	ret p			;0b30
	rst 38h			;0b31
	ld bc,01110h		;0b32
	rrca			;0b35
	rst 28h			;0b36
l0b37h:
	pop af			;0b37
	rst 18h			;0b38
	pop hl			;0b39
	xor 0f2h		;0b3a
	ld (de),a			;0b3c
	ld c,01fh		;0b3d
	ld hl,l0a0bh		;0b3f
	ld b,006h		;0b42
	inc b			;0b44
	inc b			;0b45
	inc b			;0b46
	inc b			;0b47
	ld (bc),a			;0b48
	ld (bc),a			;0b49
	ld (bc),a			;0b4a
	ld (bc),a			;0b4b
	ld (bc),a			;0b4c
	ld (bc),a			;0b4d
	ld (bc),a			;0b4e
	ld (bc),a			;0b4f
	nop			;0b50
	nop			;0b51
	nop			;0b52
	nop			;0b53
	nop			;0b54
	nop			;0b55
	nop			;0b56
	nop			;0b57
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
	nop			;0b67
	nop			;0b68
	nop			;0b69
	nop			;0b6a
	nop			;0b6b
	nop			;0b6c
l0b6dh:
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
	nop			;0b78
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
	ld d,a			;0b86
	ld b,d			;0b87
	ld c,e			;0b88
	ld d,c			;0b89
	ld d,d			;0b8a
	ld d,d			;0b8b
	ld b,d			;0b8c
	ld b,d			;0b8d
	ld c,(hl)			;0b8e
	ld c,(hl)			;0b8f
	ld d,b			;0b90
	ld d,b			;0b91
	ld d,b			;0b92
l0b93h:
	ld d,b			;0b93
	ld d,b			;0b94
	ld d,b			;0b95
	ld d,b			;0b96
	ld d,b			;0b97
	xor 01fh		;0b98
	rla			;0b9a
	ld d,016h		;0b9b
	inc d			;0b9d
	ld d,01bh		;0b9e
	ld d,0eeh		;0ba0
	rra			;0ba2
	ld e,016h		;0ba3
	inc d			;0ba5
	ld d,011h		;0ba6
	djnz $+31		;0ba8
	ld e,01dh		;0baa
	ld d,01ah		;0bac
	inc d			;0bae
	ld (de),a			;0baf
	rla			;0bb0
	ld de,01f11h		;0bb1
	ld d,017h		;0bb4
	inc d			;0bb6
	ld (de),a			;0bb7
	ld e,015h		;0bb8
	dec de			;0bba
	ld (de),a			;0bbb
	rra			;0bbc
	ld d,014h		;0bbd
	ld (de),a			;0bbf
	ld e,011h		;0bc0
	inc d			;0bc2
	ld e,017h		;0bc3
	rra			;0bc5
	ld d,014h		;0bc6
	dec e			;0bc8
	ld e,01dh		;0bc9
	rla			;0bcb
	ld (de),a			;0bcc
	dec de			;0bcd
	xor 043h		;0bce
	ld d,l			;0bd0
	ld d,d			;0bd1
	inc sp			;0bd2
	ld h,e			;0bd3
	ld d,h			;0bd4
	ld d,l			;0bd5
	ld h,(hl)			;0bd6
	xor 053h		;0bd7
	ld b,h			;0bd9
	ld d,d			;0bda
	ld h,e			;0bdb
	ld h,h			;0bdc
	ld h,e			;0bdd
	ld (hl),d			;0bde
l0bdfh:
	ld b,l			;0bdf
	ld b,e			;0be0
	ld b,d			;0be1
	ld d,l			;0be2
	ld d,(hl)			;0be3
	ld h,(hl)			;0be4
	ld (hl),l			;0be5
	ld d,d			;0be6
	ld h,d			;0be7
	ld d,d			;0be8
	ld b,h			;0be9
	ld d,l			;0bea
	ld d,d			;0beb
	ld sp,05375h		;0bec
	ld (hl),052h		;0bef
	ld (hl),h			;0bf1
	ld b,h			;0bf2
	ld d,l			;0bf3
	ld sp,04375h		;0bf4
	ld h,h			;0bf7
	ld (05234h),hl		;0bf8
	ld b,h			;0bfb
	ld d,l			;0bfc
	ld b,d			;0bfd
	ld d,d			;0bfe
	ld b,e			;0bff
	ld b,e			;0c00
	ld d,d			;0c01
	ld (hl),l			;0c02
	ld d,d			;0c03
	rrca			;0c04
	ld b,004h		;0c05
	nop			;0c07
	ld c,001h		;0c08
	inc b			;0c0a
	ld c,007h		;0c0b
	rrca			;0c0d
	ld c,007h		;0c0e
l0c10h:
	dec b			;0c10
	rrca			;0c11
	dec b			;0c12
	ld bc,0060ch		;0c13
l0c16h:
	ld b,00fh		;0c16
	dec bc			;0c18
	dec b			;0c19
	inc b			;0c1a
l0c1bh:
	nop			;0c1b
	ld b,006h		;0c1c
l0c1eh:
	inc c			;0c1e
	rrca			;0c1f
l0c20h:
	rlca			;0c20
l0c21h:
	ld b,004h		;0c21
l0c23h:
	nop			;0c23
	ld c,004h		;0c24
	ld bc,l0f07h		;0c26
	rlca			;0c29
	ld b,006h		;0c2a
	inc b			;0c2c
	ld b,00bh		;0c2d
	ld b,000h		;0c2f
	rrca			;0c31
	rlca			;0c32
	inc b			;0c33
	ld b,00fh		;0c34
	inc b			;0c36
	ld b,006h		;0c37
	inc b			;0c39
	inc sp			;0c3a
	ld (l0146h),hl		;0c3b
	inc (hl)			;0c3e
	inc de			;0c3f
	ld d,l			;0c40
	ld b,e			;0c41
	dec h			;0c42
	inc sp			;0c43
	inc (hl)			;0c44
	dec h			;0c45
	ld b,c			;0c46
l0c47h:
	ld b,e			;0c47
	ld h,e			;0c48
	inc d			;0c49
	ld (02522h),a		;0c4a
	inc h			;0c4d
	ld hl,01411h		;0c4e
	ld b,044h		;0c51
	ld d,d			;0c53
	dec (hl)			;0c54
	inc (hl)			;0c55
	ld (04125h),hl		;0c56
	ld b,023h		;0c59
l0c5bh:
	ld d,d			;0c5b
	inc d			;0c5c
	inc bc			;0c5d
	inc (hl)			;0c5e
	ld (04425h),hl		;0c5f
	inc d			;0c62
	inc hl			;0c63
	ld (00611h),hl		;0c64
	inc (hl)			;0c67
	ld (02532h),hl		;0c68
	ld b,e			;0c6b
	ld b,c			;0c6c
	ld b,h			;0c6d
	ld d,d			;0c6e
	ld d,d			;0c6f
	jr nz,$+34		;0c70
	ld b,e			;0c72
	ld d,d			;0c73
	ld c,a			;0c74
	ld c,l			;0c75
	ld b,l			;0c76
	ld c,l			;0c77
	ld b,e			;0c78
	ld c,a			;0c79
	jr nz,l0cc0h		;0c7a
	ld b,c			;0c7c
	ld e,d			;0c7d
l0c7eh:
	ld e,d			;0c7e
	ld c,h			;0c7f
	ld b,l			;0c80
	ld b,e			;0c81
	ld c,b			;0c82
	ld b,l			;0c83
	ld d,e			;0c84
	ld d,e			;0c85
	dec c			;0c86
	jr nz,l0ca9h		;0c87
	jr nz,$+34		;0c89
	jr nz,l0cadh		;0c8b
	jr nz,$+34		;0c8d
	jr nz,$+34		;0c8f
	jr nz,$+34		;0c91
	jr nz,$+34		;0c93
	dec c			;0c95
l0c96h:
	jr z,l0cdbh		;0c96
	add hl,hl			;0c98
	jr nz,l0ccch		;0c99
	add hl,sp			;0c9b
	scf			;0c9c
	scf			;0c9d
	jr nz,l0ccdh		;0c9e
	jr nz,$+79		;0ca0
	ld c,c			;0ca2
	ld b,e			;0ca3
	ld d,d			;0ca4
	ld c,a			;0ca5
	ld d,a			;0ca6
	ld b,c			;0ca7
	ld d,d			;0ca8
l0ca9h:
	ld b,l			;0ca9
	jr nz,l0cf8h		;0caa
	ld d,h			;0cac
l0cadh:
	ld b,h			;0cad
l0caeh:
	ld l,020h		;0cae
	jr nz,l0cd2h		;0cb0
	jr nz,l0cd4h		;0cb2
	jr nz,l0cd6h		;0cb4
l0cb6h:
	jr nz,l0cd8h		;0cb6
	jr nz,l0cdah		;0cb8
	jr nz,l0cc9h		;0cba
	dec l			;0cbc
	dec l			;0cbd
	dec l			;0cbe
	dec l			;0cbf
l0cc0h:
	dec l			;0cc0
	dec l			;0cc1
	dec l			;0cc2
	dec l			;0cc3
	dec l			;0cc4
	dec l			;0cc5
	dec l			;0cc6
	dec l			;0cc7
	dec l			;0cc8
l0cc9h:
	dec l			;0cc9
	dec l			;0cca
	dec l			;0ccb
l0ccch:
	dec l			;0ccc
l0ccdh:
	dec l			;0ccd
	dec l			;0cce
	dec l			;0ccf
	dec l			;0cd0
	dec l			;0cd1
l0cd2h:
	dec l			;0cd2
	dec l			;0cd3
l0cd4h:
	dec l			;0cd4
	dec c			;0cd5
l0cd6h:
	dec l			;0cd6
	dec l			;0cd7
l0cd8h:
	dec l			;0cd8
	dec l			;0cd9
l0cdah:
	dec l			;0cda
l0cdbh:
	dec l			;0cdb
	dec l			;0cdc
	dec l			;0cdd
	dec l			;0cde
	dec l			;0cdf
	dec l			;0ce0
	dec c			;0ce1
	ld d,a			;0ce2
	ld c,b			;0ce3
	ld c,c			;0ce4
	ld b,e			;0ce5
	ld c,b			;0ce6
	jr nz,l0d36h		;0ce7
	ld c,a			;0ce9
	ld b,h			;0cea
	ld b,l			;0ceb
	jr nz,l0d2dh		;0cec
l0ceeh:
	jr nz,l0d18h		;0cee
	ld d,e			;0cf0
	inc l			;0cf1
	ld b,d			;0cf2
	inc l			;0cf3
	ld c,(hl)			;0cf4
	add hl,hl			;0cf5
	jr nz,l0d05h		;0cf6
l0cf8h:
	ld b,h			;0cf8
	ld c,a			;0cf9
	jr nz,$+91		;0cfa
	ld c,a			;0cfc
	ld d,l			;0cfd
	jr nz,$+89		;0cfe
	ld b,c			;0d00
	ld c,(hl)			;0d01
	ld d,h			;0d02
	jr nz,l0d5ch		;0d03
l0d05h:
	ld c,b			;0d05
	ld c,c			;0d06
	ld d,h			;0d07
	ld b,l			;0d08
	jr nz,l0d4ah		;0d09
	jr nz,l0d35h		;0d0b
l0d0dh:
	ld e,c			;0d0d
l0d0eh:
	inc l			;0d0e
l0d0fh:
	ld c,(hl)			;0d0f
l0d10h:
	add hl,hl			;0d10
l0d11h:
	jr nz,l0d20h		;0d11
	ld a,(02020h)		;0d13
	jr nz,l0d38h		;0d16
l0d18h:
	dec c			;0d18
	ld b,h			;0d19
	ld b,e			;0d1a
	jr nz,$+60		;0d1b
	jr nz,l0d1fh		;0d1d
l0d1fh:
	nop			;0d1f
l0d20h:
	dec l			;0d20
	nop			;0d21
	nop			;0d22
	jr nz,l0d45h		;0d23
	dec c			;0d25
	ld c,c			;0d26
	ld c,(hl)			;0d27
	ld d,b			;0d28
	ld d,l			;0d29
	ld d,h			;0d2a
	jr nz,$+71		;0d2b
l0d2dh:
	ld d,d			;0d2d
	ld d,d			;0d2e
	ld c,a			;0d2f
	ld d,d			;0d30
	jr nz,l0d40h		;0d31
	ld b,e			;0d33
	ld c,b			;0d34
l0d35h:
	ld b,l			;0d35
l0d36h:
	ld b,e			;0d36
	ld c,e			;0d37
l0d38h:
	ld c,l			;0d38
	ld b,c			;0d39
	ld d,h			;0d3a
	ld b,l			;0d3b
	jr nz,l0d6bh		;0d3c
	jr nz,l0d99h		;0d3e
l0d40h:
	ld c,a			;0d40
	ld d,l			;0d41
	jr nz,l0d9bh		;0d42
	ld c,c			;0d44
l0d45h:
	ld c,(hl)			;0d45
	ld hl,02020h		;0d46
	dec c			;0d49
l0d4ah:
	ld d,b			;0d4a
	ld c,h			;0d4b
	ld b,c			;0d4c
	ld e,c			;0d4d
	jr nz,l0d91h		;0d4e
	ld b,a			;0d50
	ld b,c			;0d51
	ld c,c			;0d52
	ld c,(hl)			;0d53
	jr nz,l0d95h		;0d54
	jr nz,l0d80h		;0d56
	ld e,c			;0d58
	inc l			;0d59
	ld c,(hl)			;0d5a
	add hl,hl			;0d5b
l0d5ch:
	jr nz,l0d6bh		;0d5c
	ld d,h			;0d5e
	ld c,b			;0d5f
	ld b,c			;0d60
	ld c,(hl)			;0d61
	ld c,e			;0d62
	ld d,e			;0d63
	jr nz,l0dach		;0d64
	ld c,a			;0d66
	ld d,d			;0d67
	jr nz,l0dbeh		;0d68
	ld c,b			;0d6a
l0d6bh:
	ld b,l			;0d6b
	jr nz,l0db5h		;0d6c
	ld b,c			;0d6e
	ld c,l			;0d6f
	ld b,l			;0d70
	ld l,02eh		;0d71
	ld l,020h		;0d73
	ld b,h			;0d75
	ld b,c			;0d76
	ld e,d			;0d77
	ld e,d			;0d78
	ld c,h			;0d79
	ld b,l			;0d7a
	ld b,e			;0d7b
	ld c,b			;0d7c
	ld b,l			;0d7d
	ld d,e			;0d7e
	ld d,e			;0d7f
l0d80h:
	dec c			;0d80
	ld e,c			;0d81
l0d82h:
	ld c,a			;0d82
	ld d,l			;0d83
	jr nz,l0dd8h		;0d84
	ld b,l			;0d86
	ld d,e			;0d87
	ld c,c			;0d88
	ld b,a			;0d89
	ld c,(hl)			;0d8a
	ld b,l			;0d8b
	ld b,h			;0d8c
	jr nz,l0dbch		;0d8d
	jr nz,l0ddah		;0d8f
l0d91h:
	jr nz,l0deah		;0d91
	ld c,c			;0d93
	ld c,(hl)			;0d94
l0d95h:
	ld hl,02020h		;0d95
	dec c			;0d98
l0d99h:
	jr nz,l0dbbh		;0d99
l0d9bh:
	ld b,e			;0d9b
	ld c,b			;0d9c
	ld b,l			;0d9d
	ld b,e			;0d9e
	ld c,e			;0d9f
	ld c,l			;0da0
	ld b,c			;0da1
	ld d,h			;0da2
	ld b,l			;0da3
	jr nz,l0dd3h		;0da4
	jr nz,l0df1h		;0da6
	jr nz,l0e01h		;0da8
	ld c,c			;0daa
	ld c,(hl)			;0dab
l0dach:
	ld hl,02020h		;0dac
	jr nz,l0dbeh		;0daf
	jr nz,l0df6h		;0db1
	ld c,b			;0db3
	ld b,l			;0db4
l0db5h:
	ld b,e			;0db5
	ld c,e			;0db6
	ld hl,02b0dh		;0db7
	dec l			;0dba
l0dbbh:
	dec l			;0dbb
l0dbch:
	dec l			;0dbc
	dec l			;0dbd
l0dbeh:
	dec l			;0dbe
	dec l			;0dbf
	jr nz,l0e06h		;0dc0
	ld b,c			;0dc2
	ld e,d			;0dc3
	ld e,d			;0dc4
	ld c,h			;0dc5
	ld b,l			;0dc6
	ld b,e			;0dc7
	ld c,b			;0dc8
	ld b,l			;0dc9
	ld d,e			;0dca
	ld d,e			;0dcb
	jr nz,l0dfbh		;0dcc
	dec l			;0dce
	dec l			;0dcf
	dec l			;0dd0
	dec l			;0dd1
	dec l			;0dd2
l0dd3h:
	dec hl			;0dd3
	dec c			;0dd4
	ld hl,02020h		;0dd5
l0dd8h:
	jr nz,l0dfah		;0dd8
l0ddah:
	jr nz,l0dfch		;0dda
	jr nz,l0dfeh		;0ddc
	jr nz,sub_0e00h		;0dde
	jr nz,l0e02h		;0de0
	jr nz,$+34		;0de2
	jr nz,l0e06h		;0de4
l0de6h:
	jr nz,l0e08h		;0de6
	jr nz,l0e0ah		;0de8
l0deah:
	jr nz,l0e0ch		;0dea
	jr nz,l0e0eh		;0dec
	jr nz,l0e11h		;0dee
	dec c			;0df0
l0df1h:
	dec hl			;0df1
	dec l			;0df2
	dec l			;0df3
	dec l			;0df4
	dec l			;0df5
l0df6h:
	dec l			;0df6
	dec l			;0df7
	jr nz,l0e3dh		;0df8
l0dfah:
	ld c,b			;0dfa
l0dfbh:
	ld b,c			;0dfb
l0dfch:
	ld c,h			;0dfc
	ld c,h			;0dfd
l0dfeh:
	ld b,l			;0dfe
	ld c,(hl)			;0dff
sub_0e00h:
	ld b,a			;0e00
l0e01h:
	ld b,l			;0e01
l0e02h:
	ld d,d			;0e02
	jr nz,l0e32h		;0e03
	dec l			;0e05
l0e06h:
	dec l			;0e06
	dec l			;0e07
l0e08h:
	dec l			;0e08
	dec l			;0e09
l0e0ah:
	dec l			;0e0a
	dec hl			;0e0b
l0e0ch:
	dec c			;0e0c
sub_0e0dh:
	nop			;0e0d
l0e0eh:
	nop			;0e0e
	nop			;0e0f
	nop			;0e10
l0e11h:
	nop			;0e11
	nop			;0e12
	nop			;0e13
	nop			;0e14
	nop			;0e15
	nop			;0e16
	nop			;0e17
	nop			;0e18
	nop			;0e19
	nop			;0e1a
	nop			;0e1b
sub_0e1ch:
	nop			;0e1c
	nop			;0e1d
	nop			;0e1e
	nop			;0e1f
	nop			;0e20
	nop			;0e21
	nop			;0e22
	nop			;0e23
	nop			;0e24
sub_0e25h:
	nop			;0e25
	nop			;0e26
	nop			;0e27
	nop			;0e28
	nop			;0e29
	nop			;0e2a
	nop			;0e2b
sub_0e2ch:
	nop			;0e2c
	nop			;0e2d
	nop			;0e2e
	nop			;0e2f
	nop			;0e30
	nop			;0e31
l0e32h:
	nop			;0e32
	nop			;0e33
	nop			;0e34
	nop			;0e35
	nop			;0e36
	nop			;0e37
	nop			;0e38
	nop			;0e39
	nop			;0e3a
	nop			;0e3b
	nop			;0e3c
l0e3dh:
	nop			;0e3d
	nop			;0e3e
	nop			;0e3f
	nop			;0e40
	nop			;0e41
	nop			;0e42
	nop			;0e43
l0e44h:
	nop			;0e44
	nop			;0e45
	nop			;0e46
	nop			;0e47
	nop			;0e48
	nop			;0e49
	nop			;0e4a
	nop			;0e4b
	nop			;0e4c
	nop			;0e4d
	nop			;0e4e
	nop			;0e4f
	nop			;0e50
	nop			;0e51
	nop			;0e52
	nop			;0e53
	nop			;0e54
	nop			;0e55
	nop			;0e56
	nop			;0e57
	nop			;0e58
	nop			;0e59
	nop			;0e5a
	nop			;0e5b
	nop			;0e5c
	nop			;0e5d
	nop			;0e5e
sub_0e5fh:
	nop			;0e5f
	nop			;0e60
	nop			;0e61
	nop			;0e62
	nop			;0e63
	nop			;0e64
	nop			;0e65
	nop			;0e66
	nop			;0e67
	nop			;0e68
	nop			;0e69
	nop			;0e6a
	nop			;0e6b
	nop			;0e6c
	nop			;0e6d
	nop			;0e6e
	nop			;0e6f
	nop			;0e70
	nop			;0e71
	nop			;0e72
	nop			;0e73
	nop			;0e74
	nop			;0e75
	nop			;0e76
	nop			;0e77
	nop			;0e78
	nop			;0e79
	nop			;0e7a
	nop			;0e7b
	nop			;0e7c
	nop			;0e7d
	nop			;0e7e
	nop			;0e7f
	nop			;0e80
	nop			;0e81
	nop			;0e82
	dec sp			;0e83
	nop			;0e84
	nop			;0e85
	nop			;0e86
	nop			;0e87
	nop			;0e88
	nop			;0e89
	nop			;0e8a
	nop			;0e8b
	nop			;0e8c
	nop			;0e8d
	nop			;0e8e
	nop			;0e8f
	nop			;0e90
	nop			;0e91
sub_0e92h:
	nop			;0e92
	nop			;0e93
	nop			;0e94
	nop			;0e95
	nop			;0e96
	nop			;0e97
	nop			;0e98
	nop			;0e99
	nop			;0e9a
	nop			;0e9b
	nop			;0e9c
	nop			;0e9d
	nop			;0e9e
	nop			;0e9f
	nop			;0ea0
	nop			;0ea1
	nop			;0ea2
	nop			;0ea3
	nop			;0ea4
	nop			;0ea5
sub_0ea6h:
	nop			;0ea6
	nop			;0ea7
	nop			;0ea8
	nop			;0ea9
	nop			;0eaa
	nop			;0eab
	nop			;0eac
	nop			;0ead
	nop			;0eae
	nop			;0eaf
	nop			;0eb0
	nop			;0eb1
	nop			;0eb2
	nop			;0eb3
	nop			;0eb4
	nop			;0eb5
	nop			;0eb6
	nop			;0eb7
	nop			;0eb8
	nop			;0eb9
	nop			;0eba
	nop			;0ebb
	nop			;0ebc
	nop			;0ebd
	nop			;0ebe
	nop			;0ebf
	nop			;0ec0
	nop			;0ec1
	nop			;0ec2
	nop			;0ec3
	nop			;0ec4
	nop			;0ec5
	nop			;0ec6
	nop			;0ec7
	nop			;0ec8
	nop			;0ec9
	nop			;0eca
	nop			;0ecb
	nop			;0ecc
	nop			;0ecd
	nop			;0ece
	nop			;0ecf
	nop			;0ed0
	nop			;0ed1
	nop			;0ed2
	nop			;0ed3
	nop			;0ed4
	nop			;0ed5
	nop			;0ed6
	nop			;0ed7
	nop			;0ed8
	nop			;0ed9
	nop			;0eda
	nop			;0edb
	nop			;0edc
	nop			;0edd
	nop			;0ede
sub_0edfh:
	nop			;0edf
	nop			;0ee0
	nop			;0ee1
	nop			;0ee2
	nop			;0ee3
	nop			;0ee4
	nop			;0ee5
	nop			;0ee6
	nop			;0ee7
	nop			;0ee8
CO:
	in a,(CONSTATUS)		;0ee9
	and CONCOST		;0eeb
	jp z,CO-LBLOFF		;0eed
	ld a,b			;0ef0
	out (CONOUT),a		;0ef1
	ret			;0ef3
	
CI:
	in a,(CONSTATUS)		;0ef4
	and CONCIST		;0ef6
	jp z,CI-LBLOFF		;0ef8
	in a,(CONIN)		;0efb
	and 07fh		;0efd
	ld b,a			;0eff
	ret			;0f00
	
	nop			;0f01
	nop			;0f02
	push af			;0f03
	ld a,(l0f28h)		;0f04
l0f07h:
	cpl			;0f07
	ld (l0f28h),a		;0f08
	pop af			;0f0b
sub_0f0ch:
	ld hl,l09edh		;0f0c
	ret			;0f0f
	call sub_0e2ch		;0f10
	ld a,08ch		;0f13
	out (00eh),a		;0f15
	ld a,030h		;0f17
	out (00fh),a		;0f19
	ld hl,l0b6dh		;0f1b
	ret			;0f1e
	ld a,0ffh		;0f1f
	ld (l0f28h),a		;0f21
	call sub_015ch		;0f24
	ret			;0f27
l0f28h:
	call sub_0e2ch		;0f28
	call sub_0e5fh		;0f2b
	ret			;0f2e
	ld b,010h		;0f2f
	ld de,01801h		;0f31
	ld hl,01800h		;0f34
l0f37h:
	push bc			;0f37
	ld a,003h		;0f38
	ld b,010h		;0f3a
l0f3ch:
	push bc			;0f3c
	ld b,000h		;0f3d
	ld (hl),033h		;0f3f
	ld c,a			;0f41
	ldir		;0f42
	inc de			;0f44
	inc hl			;0f45
	ld (hl),099h		;0f46
	ld c,a			;0f48
	ldir		;0f49
	inc de			;0f4b
	inc hl			;0f4c
	pop bc			;0f4d
	djnz l0f3ch		;0f4e
	ld a,(l0e3dh)		;0f50
	ld b,a			;0f53
	ld a,(l0e44h)		;0f54
	ld (l0e3dh),a		;0f57
	ld a,b			;0f5a
	ld (l0e44h),a		;0f5b
	pop bc			;0f5e
	djnz l0f37h		;0f5f
l0f61h:
	ret			;0f61
	ld de,l09ech		;0f62
	ld b,002h		;0f65
l0f67h:
	push bc			;0f67
	ld hl,00f25h		;0f68
	ld (l0f28h+1),hl		;0f6b
	ld b,008h		;0f6e
l0f70h:
	push bc			;0f70
	call sub_0e92h		;0f71
	pop bc			;0f74
	djnz l0f70h		;0f75
	ld b,008h		;0f77
l0f79h:
	push bc			;0f79
	call sub_0e92h		;0f7a
	ld bc,0fffah		;0f7d
	ld hl,(l0f28h+1)		;0f80
	add hl,bc			;0f83
	ld (l0f28h+1),hl		;0f84
	pop bc			;0f87
	djnz l0f79h		;0f88
	ld a,(l0f28h)		;0f8a
	cpl			;0f8d
	ld (l0f28h),a		;0f8e
	pop bc			;0f91
	djnz l0f67h		;0f92
	ret			;0f94
	inc de			;0f95
	push de			;0f96
	call sub_0ea6h		;0f97
	ld bc,00006h		;0f9a
	ld hl,(l0f28h+1)		;0f9d
	add hl,bc			;0fa0
	ld (l0f28h+1),hl		;0fa1
	call sub_0edfh		;0fa4
	pop de			;0fa7
	ret			;0fa8
	ex de,hl			;0fa9
	ld a,(hl)			;0faa
	bit 7,a		;0fab
	jr z,l0fbch		;0fad
	pop de			;0faf
	ld bc,00006h		;0fb0
	ld hl,(l0f28h+1)		;0fb3
	add hl,bc			;0fb6
	ld (l0f28h+1),hl		;0fb7
	pop de			;0fba
	ret			;0fbb
l0fbch:
	rrca			;0fbc
	ld b,a			;0fbd
	rlca			;0fbe
	rlca			;0fbf
	rlca			;0fc0
	ld c,a			;0fc1
	rlca			;0fc2
	ld e,a			;0fc3
	rlca			;0fc4
	and 004h		;0fc5
	ld d,a			;0fc7
	ld a,e			;0fc8
	and 001h		;0fc9
	or d			;0fcb
	ld d,a			;0fcc
	ld a,b			;0fcd
	and 002h		;0fce
	or d			;0fd0
	ld d,a			;0fd1
	ld a,018h		;0fd2
	or d			;0fd4
	ld d,a			;0fd5
	ld a,e			;0fd6
	and 080h		;0fd7
	ld e,a			;0fd9
	ld a,c			;0fda
	and 00ch		;0fdb
	or e			;0fdd
	ld e,a			;0fde
	set 4,e		;0fdf
	ret			;0fe1
	ld b,c			;0fe2
l0fe3h:
	bit 5,(hl)		;0fe3
	call nz,00f1ah		;0fe5
	inc de			;0fe8
	bit 4,(hl)		;0fe9
	call nz,sub_0f0ch		;0feb
	bit 3,(hl)		;0fee
	call nz,00f1ah		;0ff0
	inc de			;0ff3
	bit 2,(hl)		;0ff4
	call nz,sub_0f0ch		;0ff6
	bit 1,(hl)		;0ff9
	call nz,00f1ah		;0ffb
	inc de			;0ffe
	bit 0,(hl)		;0fff
	call nz,sub_0f0ch		;1001
	push hl			;1004
	ld hl,0000dh		;1005
	add hl,de			;1008
	ex de,hl			;1009
	pop hl			;100a
	inc hl			;100b
	djnz l0fe3h		;100c
	ret			;100e
	ex de,hl			;100f
	ld a,(hl)			;1010
	and 0f0h		;1011
	ld c,a			;1013
	ld a,(l0f28h)		;1014
	and 00fh		;1017
	or c			;1019
	ld (hl),a			;101a
	ex de,hl			;101b
	ret			;101c
	ex de,hl			;101d
	ld a,(hl)			;101e
	and 00fh		;101f
	ld c,a			;1021
	ld a,(l0f28h)		;1022
	and 0f0h		;1025
	or c			;1027
	ld (hl),a			;1028
	ex de,hl			;1029
	ret			;102a
	rst 38h			;102b
	nop			;102c
	nop			;102d
	inc c			;102e
	ccf			;102f
	inc sp			;1030
	ld hl,01e33h		;1031
	nop			;1034
	dec l			;1035
	ccf			;1036
	dec l			;1037
	ccf			;1038
	ccf			;1039
	dec l			;103a
	ccf			;103b
	ld e,01eh		;103c
	ld e,01eh		;103e
	dec l			;1040
	ccf			;1041
	ld e,01eh		;1042
	ld e,01eh		;1044
	inc c			;1046
	inc e			;1047
	ccf			;1048
	ld e,00ch		;1049
	ccf			;104b
	inc c			;104c
	inc e			;104d
	ccf			;104e
	ld e,00ch		;104f
	ccf			;1051
	ex af,af'			;1052
	ld e,03fh		;1053
	scf			;1055
	rlca			;1056
	rrca			;1057
	ex af,af'			;1058
	ld e,03fh		;1059
	scf			;105b
	rlca			;105c
	rrca			;105d
	nop			;105e
	inc c			;105f
	inc c			;1060
	ld e,03fh		;1061
	ccf			;1063
	xor a			;1064
	out (00eh),a		;1065
	ld hl,0108eh		;1067
	ld de,00000h		;106a
	ld bc,00080h		;106d
	ldir		;1070
	jp 00000h		;1072
l1075h:
	;ld hl,00000h		;1075
	;ld de,0108eh		;1078
	;ld bc,00080h		;107b
	;ldir		;107e
	ld hl,LBLOFF		;1080
	ld de,00000h		;1083
	ld bc,00f72h		;1086
	ldir		;1089
	
	;ZOGGINS
	; Select Page 1 on Dazzler II
	ld a,000h		
	out (018h),a	
	
	; ZOGGINS
	; Set DMA address & clear Screen
	ld a,08ch		
	out (00eh),a
	ld hl,1800h
    ld e,l
	ld d,h
	inc	de
	ld (hl),000h
	ld bc,800h
	ldir
	
	jp 00000h		;108b
