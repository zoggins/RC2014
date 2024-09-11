; z80dasm 1.1.6
; command line: z80dasm --labels --origin=0x0100 --address 4DTICTAC.COM

	org	00100h

LBLOFF:		equ		00103h

CONOUT:		equ		0a3h	; CONSOLE OUT PORT
CONIN:		equ		0a3h	; CONSOLE IN PORT

CONSTATUS:	equ		0a1h	; CONSOLE STATUS PORT
CONCOST:	equ		004h	; SEND STATUS BIT
CONCIST:	equ		001h	; RECV STATUS BIT

	jp init		;0100
l0103h:
	di			;0103
	ld sp,007ffh		;0104
	ld a,084h		;0107
	out (00eh),a		;0109
	ld a,010h		;010b
l010dh:
	out (00fh),a		;010d
	ld hl,005e4h		;010f
	call sub_05bdh		;0112
	call 004e7h		;0115
	push af			;0118
	ld a,0ffh		;0119
	out (0ffh),a		;011b
	ld hl,00800h		;011d
	ld d,004h		;0120
	ld b,010h		;0122
	ld c,004h		;0124
	ld a,040h		;0126
	ld (hl),a			;0128
	inc hl			;0129
	ld (hl),a			;012a
	inc hl			;012b
	ld (hl),a			;012c
	inc hl			;012d
	dec c			;012e
	jp z,00035h		;012f
	ld (hl),000h		;0132
	inc hl			;0134
	jp 00023h		;0135
	ld a,000h		;0138
	ld (hl),a			;013a
	dec b			;013b
	jp z,0006eh		;013c
	inc hl			;013f
	ld c,010h		;0140
	dec d			;0142
	jp z,0005dh		;0143
	ld c,004h		;0146
	ld a,044h		;0148
	ld (hl),a			;014a
	inc hl			;014b
	ld (hl),a			;014c
	inc hl			;014d
	ld (hl),a			;014e
l014fh:
	inc hl			;014f
	dec c			;0150
	jp z,00057h		;0151
	ld (hl),004h		;0154
	inc hl			;0156
	jp 00045h		;0157
	ld (hl),004h		;015a
	inc hl			;015c
	jp 00021h		;015d
	ld a,000h		;0160
	dec c			;0162
	ld d,004h		;0163
l0165h:
	ld (hl),a			;0165
	inc hl			;0166
	dec c			;0167
	jp nz,00062h		;0168
	ld (hl),000h		;016b
	inc hl			;016d
	jp 00021h		;016e
	ld a,010h		;0171
	inc hl			;0173
	ld (hl),000h		;0174
	dec a			;0176
	jp nz,00070h		;0177
	pop af			;017a
l017bh:
	jp m,000e7h		;017b
	xor a			;017e
	out (0ffh),a		;017f
	ld hl,l0627h		;0181
	call sub_05bdh		;0184
	call sub_050dh		;0187
	ld b,a			;018a
	jp 000a1h		;018b
	ex (sp),hl			;018e
l018fh:
	ex (sp),hl			;018f
	ex (sp),hl			;0190
	ex (sp),hl			;0191
	jp nz,0008ah		;0192
	in a,(0ffh)		;0195
	cp c			;0197
	jp z,00092h		;0198
	cp b			;019b
	jp z,000a1h		;019c
	ld b,c			;019f
	ld c,a			;01a0
	jp 00088h		;01a1
	ld hl,00800h		;01a4
	and 00fh		;01a7
	ld l,a			;01a9
	ld a,b			;01aa
	and 0f0h		;01ab
	rla			;01ad
	jp nc,000afh		;01ae
	inc h			;01b1
	add a,l			;01b2
	ld l,a			;01b3
	ld a,(hl)			;01b4
	and 00fh		;01b5
	cp 000h		;01b7
	jp z,000c0h		;01b9
	jp l054ah		;01bc
	rst 38h			;01bf
	jp 0007eh		;01c0
	ld a,b			;01c3
	out (0ffh),a		;01c4
	ld a,(hl)			;01c6
	and 0f0h		;01c7
	add a,00eh		;01c9
	ld (hl),a			;01cb
	call CI-LBLOFF		;01cc
	cp 00dh		;01cf
	jp nz,000deh		;01d1
	call 005a5h		;01d4
l01d7h:
	nop			;01d7
	ld a,(hl)			;01d8
	and 0f0h		;01d9
	add a,00ch		;01db
	ld (hl),a			;01dd
	jp 000e7h		;01de
	ld a,(hl)			;01e1
	and 0f0h		;01e2
	add a,000h		;01e4
	ld (hl),a			;01e6
	jp 0055ah		;01e7
	ld hl,00a00h		;01ea
	ld (hl),000h		;01ed
	inc hl			;01ef
	ld a,h			;01f0
	and 002h		;01f1
	jp nz,000eah		;01f3
l01f6h:
	xor a			;01f6
	ld bc,00000h		;01f7
	ld de,00000h		;01fa
	ld hl,00800h		;01fd
l0200h:
	call sub_02bah		;0200
	ld d,000h		;0203
	ld b,0a0h		;0205
	ld c,000h		;0207
	ld a,0feh		;0209
	ld e,000h		;020b
	call sub_0252h		;020d
l0210h:
	call sub_02dah		;0210
	call sub_0292h		;0213
	jp l010dh		;0216
	ld d,060h		;0219
	ld b,060h		;021b
	ld c,000h		;021d
	ld a,0feh		;021f
	ld e,000h		;0221
	call sub_0252h		;0223
	call sub_02dah		;0226
	call sub_0292h		;0229
	jp 00123h		;022c
	ld d,000h		;022f
	ld b,080h		;0231
	ld c,023h		;0233
	ld a,0feh		;0235
	ld e,000h		;0237
	call sub_0252h		;0239
	call sub_02dah		;023c
	call sub_0292h		;023f
	jp 00139h		;0242
	ld d,000h		;0245
	ld b,020h		;0247
	ld c,083h		;0249
	ld a,0feh		;024b
	ld e,000h		;024d
	call sub_0252h		;024f
sub_0252h:
	call sub_02ceh		;0252
	call sub_0292h		;0255
	jp l014fh		;0258
	ld d,060h		;025b
	ld b,0e0h		;025d
	ld c,083h		;025f
	ld a,0feh		;0261
	ld e,000h		;0263
	call sub_0252h		;0265
	call sub_02d4h		;0268
	call sub_0292h		;026b
	jp l0165h		;026e
	ld d,000h		;0271
	ld b,000h		;0273
	ld c,02fh		;0275
	ld a,0feh		;0277
l0279h:
	ld e,000h		;0279
	call sub_0252h		;027b
	call sub_02d4h		;027e
	call sub_0292h		;0281
	jp l017bh		;0284
	call sub_02c5h		;0287
	dec d			;028a
	jp m,001e0h		;028b
	dec d			;028e
	jp p,001afh		;028f
sub_0292h:
	ld h,b			;0292
	ld l,c			;0293
	ld a,(hl)			;0294
	and 0f0h		;0295
	add a,009h		;0297
	ld (hl),a			;0299
	call 0019dh		;029a
	jp 0007eh		;029d
	ld a,h			;02a0
	and 001h		;02a1
	rrca			;02a3
	ld c,a			;02a4
	ld a,l			;02a5
	and 0e0h		;02a6
	rrca			;02a8
	add a,c			;02a9
	ld c,a			;02aa
	ld a,l			;02ab
l02ach:
	and 00fh		;02ac
	add a,c			;02ae
	jp 00563h		;02af
	ld h,b			;02b2
	ld l,c			;02b3
	call 0019dh		;02b4
	ld bc,00020h		;02b7
sub_02bah:
	ld hl,00800h		;02ba
	ld a,(hl)			;02bd
	and 00fh		;02be
	cp 00eh		;02c0
	jp z,l01d7h		;02c2
sub_02c5h:
	inc l			;02c5
	ld a,l			;02c6
	and 010h		;02c7
	jp z,001bah		;02c9
	add hl,bc			;02cc
	ld a,l			;02cd
sub_02ceh:
	and 0e0h		;02ce
	ld l,a			;02d0
	ld a,h			;02d1
	and 002h		;02d2
sub_02d4h:
	jp z,001bah		;02d4
	jp 0057ah		;02d7
sub_02dah:
	ld a,(hl)			;02da
	and 0f0h		;02db
	add a,00fh		;02dd
	ld (hl),a			;02df
	jp 001c2h		;02e0
	ld bc,00020h		;02e3
	ld hl,00a00h		;02e6
	ld de,00a00h		;02e9
	ex de,hl			;02ec
	ld a,(hl)			;02ed
	ex de,hl			;02ee
	sub (hl)			;02ef
	jp nc,l01f6h		;02f0
	ld a,(hl)			;02f3
	ld d,h			;02f4
	ld e,l			;02f5
	jp 0021eh		;02f6
	jp nz,0021eh		;02f9
	ld a,010h		;02fc
	add a,l			;02fe
	ld l,a			;02ff
l0300h:
	ld a,010h		;0300
	add a,e			;0302
	ld e,a			;0303
	ld a,(hl)			;0304
	ex de,hl			;0305
	cp (hl)			;0306
	jp m,00214h		;0307
	jp z,00214h		;030a
	ld a,0f0h		;030d
	add a,e			;030f
	ld e,a			;0310
	ld h,d			;0311
	ld l,e			;0312
	ld a,(hl)			;0313
	jp 0021eh		;0314
	ld a,0f0h		;0317
	add a,e			;0319
	ld e,a			;031a
	ld a,0f0h		;031b
	add a,l			;031d
	ld l,a			;031e
	ld a,(hl)			;031f
	ex de,hl			;0320
	inc l			;0321
	ld a,l			;0322
	and 010h		;0323
	jp z,001e9h		;0325
	add hl,bc			;0328
	ld a,l			;0329
	and 0e0h		;032a
l032ch:
	ld l,a			;032c
	ld a,h			;032d
	and 002h		;032e
	jp nz,001e9h		;0330
	ld a,d			;0333
	and 0fdh		;0334
	ld b,a			;0336
	ld c,e			;0337
	ld h,d			;0338
	ld l,e			;0339
	ld a,(hl)			;033a
	cp 000h		;033b
	jp nz,l018fh		;033d
	ld a,010h		;0340
l0342h:
	add a,l			;0342
	ld l,a			;0343
	ld a,(hl)			;0344
	cp 000h		;0345
	jp nz,l018fh		;0347
	ld h,b			;034a
l034bh:
	ld l,c			;034b
	ld a,(hl)			;034c
	and 0f0h		;034d
	add a,00fh		;034f
	ld (hl),a			;0351
	jp l0583h		;0352
	inc sp			;0355
	inc sp			;0356
	pop hl			;0357
l0358h:
	and h			;0358
	ld h,a			;0359
	ld a,l			;035a
	and e			;035b
	add a,d			;035c
	ld l,a			;035d
	ld a,e			;035e
	pop de			;035f
	push hl			;0360
	ld hl,00008h		;0361
	add hl,de			;0364
	ex de,hl			;0365
	pop hl			;0366
	and e			;0367
	add a,b			;0368
	ld e,a			;0369
	ld a,c			;036a
	pop bc			;036b
	ex (sp),hl			;036c
	push bc			;036d
l036eh:
	ld c,a			;036e
	and 00fh		;036f
	ld b,a			;0371
	inc b			;0372
	ld a,c			;0373
	and 050h		;0374
	jp nz,00288h		;0376
	ld a,c			;0379
	and 0f0h		;037a
	ld l,a			;037c
	ld a,h			;037d
	ld h,b			;037e
	pop bc			;037f
	ex (sp),hl			;0380
	push hl			;0381
	push de			;0382
	push bc			;0383
l0384h:
	dec sp			;0384
	dec sp			;0385
	pop hl			;0386
	pop de			;0387
	pop de			;0388
	ex (sp),hl			;0389
	ret			;038a
	ld a,c			;038b
	and 0f0h		;038c
	rrca			;038e
	rrca			;038f
	rrca			;0390
	rrca			;0391
	jp l0279h		;0392
	inc sp			;0395
	inc sp			;0396
	ex de,hl			;0397
	ex (sp),hl			;0398
	dec h			;0399
l039ah:
	jp z,l02ach		;039a
	dec sp			;039d
	dec sp			;039e
	push af			;039f
	ex de,hl			;03a0
	ld a,d			;03a1
	ld d,000h		;03a2
	add hl,de			;03a4
	ld d,a			;03a5
	ex de,hl			;03a6
sub_03a7h:
	pop af			;03a7
	inc sp			;03a8
	inc sp			;03a9
	ex (sp),hl			;03aa
	ex de,hl			;03ab
l03ach:
	dec sp			;03ac
	dec sp			;03ad
	ret			;03ae
	ld h,b			;03af
	ld l,c			;03b0
	pop bc			;03b1
	push af			;03b2
	dec sp			;03b3
	dec sp			;03b4
	ex (sp),hl			;03b5
	push bc			;03b6
	push de			;03b7
	inc hl			;03b8
	inc hl			;03b9
	inc hl			;03ba
l03bbh:
	push hl			;03bb
	ret			;03bc
	push bc			;03bd
	inc sp			;03be
	inc sp			;03bf
	pop bc			;03c0
	push af			;03c1
	dec sp			;03c2
	dec sp			;03c3
l03c4h:
	push de			;03c4
l03c5h:
	push hl			;03c5
	push bc			;03c6
	ret			;03c7
	pop hl			;03c8
	pop af			;03c9
	pop de			;03ca
	pop bc			;03cb
	ex (sp),hl			;03cc
	push af			;03cd
	ex (sp),hl			;03ce
	pop af			;03cf
	ret			;03d0
	call sub_02bah		;03d1
l03d4h:
	jp 00335h		;03d4
	call sub_02bah		;03d7
	jp l034bh		;03da
	call sub_02bah		;03dd
	ld d,003h		;03e0
	ld b,0ffh		;03e2
	ld c,043h		;03e4
	ld a,0ffh		;03e6
	ld e,0f0h		;03e8
	call sub_0252h		;03ea
	call sub_03a7h		;03ed
	call sub_0292h		;03f0
	jp 002eah		;03f3
	ld d,00ch		;03f6
	ld b,0fch		;03f8
	ld c,013h		;03fa
	ld a,0ffh		;03fc
	ld e,0f0h		;03fe
	call sub_0252h		;0400
	call sub_03a7h		;0403
	call sub_0292h		;0406
	jp l0300h		;0409
	ld d,00ch		;040c
	ld b,0fdh		;040e
	ld c,000h		;0410
	ld a,0ffh		;0412
	ld e,0f0h		;0414
	call sub_0252h		;0416
	call sub_03a7h		;0419
	call sub_0292h		;041c
l041fh:
	jp 00316h		;041f
l0422h:
	ld d,00fh		;0422
	ld b,0fbh		;0424
	ld c,000h		;0426
	ld a,0ffh		;0428
	ld e,0f0h		;042a
	call sub_0252h		;042c
	call sub_03a7h		;042f
l0432h:
	call sub_0292h		;0432
	jp l032ch		;0435
	ld d,000h		;0438
l043ah:
	ld b,000h		;043a
	ld c,01fh		;043c
	ld a,0ffh		;043e
	ld e,0f0h		;0440
	call sub_0252h		;0442
	call sub_03a7h		;0445
	call sub_0292h		;0448
	jp l0342h		;044b
	ld d,000h		;044e
	ld b,004h		;0450
	ld c,013h		;0452
	ld a,0ffh		;0454
	ld e,0f0h		;0456
	call sub_0252h		;0458
	call sub_03a7h		;045b
	call sub_0292h		;045e
	jp l0358h		;0461
	ld d,000h		;0464
	ld b,001h		;0466
	ld c,043h		;0468
	ld a,0ffh		;046a
	ld e,0f0h		;046c
	call sub_0252h		;046e
	call sub_03a7h		;0471
	call sub_0292h		;0474
	jp l036eh		;0477
	ld d,000h		;047a
	ld b,005h		;047c
	ld c,000h		;047e
	ld a,0ffh		;0480
	ld e,0f0h		;0482
	call sub_0252h		;0484
	call sub_03a7h		;0487
	call sub_0292h		;048a
	jp l0384h		;048d
	ld d,003h		;0490
	ld b,003h		;0492
l0494h:
	ld c,000h		;0494
	ld a,0ffh		;0496
	ld e,0f0h		;0498
	call sub_0252h		;049a
	call sub_03a7h		;049d
	call sub_0292h		;04a0
	jp l039ah		;04a3
	call sub_02c5h		;04a6
	ret			;04a9
	push bc			;04aa
	push hl			;04ab
	ld bc,00004h		;04ac
	ld a,(hl)			;04af
	and 00fh		;04b0
	cp 009h		;04b2
	jp nz,l03bbh		;04b4
l04b7h:
	ld a,b			;04b7
	add a,010h		;04b8
	ld b,a			;04ba
	jp l03c5h		;04bb
	cp 00ch		;04be
	jp nz,l03c4h		;04c0
	inc b			;04c3
	jp l03c5h		;04c4
	push hl			;04c7
	dec c			;04c8
	jp z,003dfh		;04c9
	ld a,e			;04cc
	and 0c0h		;04cd
	cp 0c0h		;04cf
	jp z,003d9h		;04d1
	ld a,d			;04d4
	ld d,000h		;04d5
	add hl,de			;04d7
	ld d,a			;04d8
l04d9h:
	jp l03ach		;04d9
	ld a,d			;04dc
	ld d,0ffh		;04dd
	jp l03d4h		;04df
	ld a,b			;04e2
	cp 000h		;04e3
	jp z,l0422h		;04e5
	cp 001h		;04e8
	jp z,l0432h		;04ea
	cp 010h		;04ed
	jp z,l0432h		;04ef
	cp 002h		;04f2
	jp z,l043ah		;04f4
	cp 020h		;04f7
	jp z,00467h		;04f9
	cp 003h		;04fc
	jp z,l0494h		;04fe
	cp 030h		;0501
	jp z,004a4h		;0503
	cp 004h		;0506
	jp z,004cah		;0508
	and 0f0h		;050b
sub_050dh:
	rrca			;050d
	rrca			;050e
	rrca			;050f
	rrca			;0510
	add a,b			;0511
	and 00fh		;0512
	cp 004h		;0514
	jp z,l041fh		;0516
	cpl			;0519
	inc a			;051a
	add a,004h		;051b
	pop bc			;051d
	dec a			;051e
	jp nz,0041ah		;051f
	pop hl			;0522
	pop bc			;0523
	ret			;0524
	ld bc,l0210h		;0525
	ld a,004h		;0528
	ex (sp),hl			;052a
l052bh:
	add hl,bc			;052b
	inc (hl)			;052c
	pop hl			;052d
	dec a			;052e
	jp z,l041fh		;052f
	jp 00427h		;0532
	ld a,003h		;0535
	ld bc,l0200h		;0537
	jp 00427h		;053a
sub_053dh:
	ex (sp),hl			;053d
	ld bc,l0200h		;053e
	add hl,bc			;0541
	ld a,(hl)			;0542
	and 030h		;0543
	cp 030h		;0545
	jp nz,0044ch		;0547
l054ah:
	pop hl			;054a
	pop bc			;054b
	jp l041fh		;054c
	ld a,010h		;054f
	add a,(hl)			;0551
	ld (hl),a			;0552
l0553h:
	pop hl			;0553
	ex (sp),hl			;0554
	add hl,bc			;0555
	ld a,(hl)			;0556
	and 030h		;0557
	cp 030h		;0559
	jp nz,0045fh		;055b
	pop hl			;055e
	jp l041fh		;055f
	ld a,010h		;0562
	add a,(hl)			;0564
	ld (hl),a			;0565
	pop hl			;0566
	jp l041fh		;0567
	ex (sp),hl			;056a
	ld bc,l0200h		;056b
	add hl,bc			;056e
	ld a,(hl)			;056f
	and 0c0h		;0570
	cp 0c0h		;0572
	jp nz,00479h		;0574
	pop hl			;0577
	pop bc			;0578
	jp l041fh		;0579
	ld a,040h		;057c
	add a,(hl)			;057e
	ld (hl),a			;057f
	pop hl			;0580
	ex (sp),hl			;0581
	add hl,bc			;0582
l0583h:
	ld a,(hl)			;0583
	and 0c0h		;0584
	cp 0c0h		;0586
	jp nz,0048ch		;0588
	pop hl			;058b
l058ch:
	jp l041fh		;058c
	ld a,040h		;058f
	add a,(hl)			;0591
	ld (hl),a			;0592
	pop hl			;0593
	jp l041fh		;0594
	ld a,d			;0597
	cp 001h		;0598
	jp m,0049eh		;059a
	pop bc			;059d
l059eh:
	jp l041fh		;059e
	pop bc			;05a1
sub_05a2h:
	pop hl			;05a2
	pop af			;05a3
	ld d,001h		;05a4
	ret			;05a6
	pop bc			;05a7
	pop hl			;05a8
	pop af			;05a9
	push bc			;05aa
	push hl			;05ab
	ld b,004h		;05ac
	ld a,e			;05ae
sub_05afh:
	ld d,000h		;05af
	and 0c0h		;05b1
	cp 0c0h		;05b3
	jp nz,l04b7h		;05b5
l05b8h:
	ld d,0ffh		;05b8
	ld a,(hl)			;05ba
	and 0f0h		;05bb
sub_05bdh:
	add a,00eh		;05bd
	ld (hl),a			;05bf
	dec b			;05c0
	jp z,004c5h		;05c1
	add hl,de			;05c4
	jp l04b7h		;05c5
l05c8h:
	ld d,002h		;05c8
	jp l041fh		;05ca
	pop hl			;05cd
	ld b,004h		;05ce
	ld a,e			;05d0
	ld d,000h		;05d1
sub_05d3h:
	and 0c0h		;05d3
	cp 0c0h		;05d5
	jp nz,l04d9h		;05d7
	ld d,0ffh		;05da
	ld a,(hl)			;05dc
	and 0f0h		;05dd
	add a,00ah		;05df
	ld (hl),a			;05e1
	dec b			;05e2
	jp z,l058ch		;05e3
	add hl,de			;05e6
	jp l04d9h		;05e7
	ld hl,l0607h		;05ea
	call sub_05bdh		;05ed
	call CI-LBLOFF		;05f0
	cp 059h		;05f3
	jp z,004fdh		;05f5
	call sub_05a2h		;05f8
	call 00504h		;05fb
	sub a			;05fe
	ret			;05ff
	call sub_05a2h		;0600
	ld a,080h		;0603
	and a			;0605
	ret			;0606
l0607h:
	push hl			;0607
	ld hl,l061ah		;0608
	call sub_05bdh		;060b
	pop hl			;060e
	ret			;060f
	call CI-LBLOFF		;0610
	call sub_053dh		;0613
	jp c,00526h		;0616
	rla			;0619
l061ah:
	rla			;061a
	rla			;061b
	rla			;061c
	ld b,a			;061d
	call CI-LBLOFF		;061e
	call sub_053dh		;0621
	jp c,l052bh		;0624
l0627h:
	add a,b			;0627
	ret			;0628
	ld a,020h		;0629
	call 005c7h		;062b
	ld hl,0064eh		;062e
	call sub_05bdh		;0631
	call 00504h		;0634
	ld hl,l0627h		;0637
	call sub_05bdh		;063a
	jp sub_050dh		;063d
	sub 030h		;0640
	ret c			;0642
	cp 00ah		;0643
	ccf			;0645
	ret nc			;0646
	sub 007h		;0647
	cp 010h		;0649
	ccf			;064b
	ret			;064c
	ld hl,00635h		;064d
	call sub_05bdh		;0650
	call 00504h		;0653
	ld a,b			;0656
	cpl			;0657
	out (0ffh),a		;0658
	jp 0007eh		;065a
	call 005a5h		;065d
	call 00504h		;0660
	jp l0553h		;0663
	ld b,a			;0666
	ld hl,00664h		;0667
	call sub_05bdh		;066a
	ld a,b			;066d
	rra			;066e
l066fh:
	rra			;066f
	rra			;0670
	rra			;0671
	call sub_05afh		;0672
	ld a,b			;0675
	call sub_05afh		;0676
	ld a,b			;0679
	out (0ffh),a		;067a
	ret			;067c
	ld hl,l066fh		;067d
	call sub_05bdh		;0680
	jp 00595h		;0683
	ld hl,l0695h		;0686
	call sub_05bdh		;0689
	jp 00595h		;068c
	ld hl,006a6h		;068f
	call sub_05bdh		;0692
l0695h:
	jp 00595h		;0695
	ld hl,l059eh		;0698
	call sub_05bdh		;069b
	jp 00000h		;069e
	rlca			;06a1
	rlca			;06a2
	rlca			;06a3
	nop			;06a4
	call 005a5h		;06a5
	ld a,00dh		;06a8
	call 005c7h		;06aa
	ld a,00ah		;06ad
	jp 005c7h		;06af
	and 00fh		;06b2
	cp 00ah		;06b4
	jp c,l05b8h		;06b6
	add a,007h		;06b9
	add a,030h		;06bb
	jp 005c7h		;06bd
	ld a,(hl)			;06c0
	and a			;06c1
	ret z			;06c2
	call 005c7h		;06c3
	inc hl			;06c6
l06c7h:
	jp sub_05bdh		;06c7
	push af			;06ca
CO:
	in a,(CONSTATUS)		;06cb
	and CONCOST		;06cd
	jp z,CO-LBLOFF	;06cf
	pop af			;06d2
	out (CONOUT),a		;06d3
	ret			;06d5
	
CI:
	in a,(CONSTATUS)		;06d6
	and CONCIST		;06d8
	jp z,CI-LBLOFF		;06da
	in a,(CONIN)		;06dd
	and 07fh		;06df
	cp 020h		;06e1
	ret c			;06e3
	
	jp 005c7h		;06e4
	dec c			;06e7
	ld a,(bc)			;06e8
	dec c			;06e9
	ld a,(bc)			;06ea
	ld b,(hl)			;06eb
	ld c,a			;06ec
	ld d,l			;06ed
	ld d,d			;06ee
	jr nz,$+70		;06ef
	ld c,c			;06f1
	ld c,l			;06f2
	ld b,l			;06f3
	ld c,(hl)			;06f4
	ld d,e			;06f5
	ld c,c			;06f6
	ld c,a			;06f7
	ld c,(hl)			;06f8
	ld b,c			;06f9
	ld c,h			;06fa
	jr nz,l0751h		;06fb
	ld c,c			;06fd
	ld b,e			;06fe
	dec l			;06ff
	ld d,h			;0700
	ld b,c			;0701
	ld b,e			;0702
	dec l			;0703
	ld d,h			;0704
	ld c,a			;0705
	ld b,l			;0706
	dec c			;0707
	ld a,(bc)			;0708
	nop			;0709
	ld c,l			;070a
	ld b,c			;070b
	ld e,c			;070c
	jr nz,l0758h		;070d
	jr nz,l0761h		;070f
	ld c,h			;0711
	ld b,c			;0712
	ld e,c			;0713
	jr nz,l075ch		;0714
	ld c,c			;0716
	ld d,d			;0717
	ld d,e			;0718
	ld d,h			;0719
	ccf			;071a
	jr nz,l071dh		;071b
l071dh:
	jr nz,l073fh		;071d
	jr nz,l0741h		;071f
	jr nz,l0743h		;0721
	jr nz,$+34		;0723
	jr nz,l0747h		;0725
	jr nz,$+34		;0727
	nop			;0729
	jr nz,l0785h		;072a
	ld c,a			;072c
	ld d,l			;072d
	ld d,d			;072e
	jr nz,l077eh		;072f
	ld c,a			;0731
	ld d,(hl)			;0732
	ld b,l			;0733
	jr nz,l0763h		;0734
	jr nz,l0738h		;0736
l0738h:
	jr nz,l075ah		;0738
	jr nz,l075ch		;073a
	jr nz,l075eh		;073c
	ld d,e			;073e
l073fh:
	ld d,c			;073f
	ld d,l			;0740
l0741h:
	ld b,c			;0741
	ld d,d			;0742
l0743h:
	ld b,l			;0743
	jr nz,l0794h		;0744
	ld c,a			;0746
l0747h:
	ld d,h			;0747
	jr nz,l078ch		;0748
	ld c,h			;074a
	ld b,c			;074b
	ld c,(hl)			;074c
	ld c,e			;074d
	dec c			;074e
	ld a,(bc)			;074f
	nop			;0750
l0751h:
	jr nz,l0773h		;0751
	jr nz,l0775h		;0753
	jr nz,l0777h		;0755
	ld c,c			;0757
l0758h:
	ld c,h			;0758
	ld c,h			;0759
l075ah:
	ld b,l			;075a
	ld b,a			;075b
l075ch:
	ld b,c			;075c
	ld c,h			;075d
l075eh:
	jr nz,l07a5h		;075e
	ld c,(hl)			;0760
l0761h:
	ld d,h			;0761
	ld d,d			;0762
l0763h:
	ld e,c			;0763
	dec c			;0764
	ld a,(bc)			;0765
	nop			;0766
	ld c,l			;0767
	ld e,c			;0768
	jr nz,l07b8h		;0769
	ld c,a			;076b
	ld d,(hl)			;076c
	ld b,l			;076d
	jr nz,l079dh		;076e
	jr nz,l0772h		;0770
l0772h:
	dec c			;0772
l0773h:
	ld a,(bc)			;0773
	dec c			;0774
l0775h:
	ld a,(bc)			;0775
	ld c,c			;0776
l0777h:
	jr nz,l07d0h		;0777
	ld c,c			;0779
	ld c,(hl)			;077a
	ld hl,02121h		;077b
l077eh:
	jr nz,l07c2h		;077e
	ld b,l			;0780
	ld d,h			;0781
	ld d,h			;0782
	ld b,l			;0783
	ld d,d			;0784
l0785h:
	jr nz,l07d3h		;0785
	ld d,l			;0787
	ld b,e			;0788
	ld c,e			;0789
	jr nz,$+80		;078a
l078ch:
	ld b,l			;078c
	ld e,b			;078d
	ld d,h			;078e
	jr nz,$+86		;078f
	ld c,c			;0791
	ld c,l			;0792
	ld b,l			;0793
l0794h:
	ld l,00dh		;0794
	ld a,(bc)			;0796
	nop			;0797
	dec c			;0798
	ld a,(bc)			;0799
	dec c			;079a
	ld a,(bc)			;079b
	ld c,c			;079c
l079dh:
	ld d,h			;079d
	daa			;079e
	ld d,e			;079f
	jr nz,$+67		;07a0
	jr nz,$+86		;07a2
	ld c,c			;07a4
l07a5h:
	ld b,l			;07a5
	dec c			;07a6
	ld a,(bc)			;07a7
	nop			;07a8
	dec c			;07a9
	ld a,(bc)			;07aa
	dec c			;07ab
	ld a,(bc)			;07ac
	ld b,e			;07ad
	ld c,a			;07ae
	ld c,(hl)			;07af
	ld b,a			;07b0
	ld d,d			;07b1
	ld b,c			;07b2
	ld b,h			;07b3
	ld d,l			;07b4
	ld c,h			;07b5
	ld b,c			;07b6
	ld d,h			;07b7
l07b8h:
	ld c,c			;07b8
	ld c,a			;07b9
	ld c,(hl)			;07ba
	ld d,e			;07bb
	jr nz,$+47		;07bc
	jr nz,$+91		;07be
	ld c,a			;07c0
	ld d,l			;07c1
l07c2h:
	jr nz,$+89		;07c2
	ld c,c			;07c4
	ld c,(hl)			;07c5
	ld l,00dh		;07c6
	ld a,(bc)			;07c8
	nop			;07c9
l07cah:
	ld hl,l0103h		;07ca
	ld de,00000h		;07cd
l07d0h:
	ld bc,l06c7h		;07d0
l07d3h:
	ldir		;07d3
	jp 00000h		;07d5
init:
	; ZOGGINS
	; Select Page 1 on Dazzler II
	ld a,000h		
	out (018h),a	
	
	; ZOGGINS
	; Set DMA address & clear Screen
	ld a,004h		
	out (00eh),a
	ld hl,800h
    ld e,l
	ld d,h
	inc	de
	ld (hl),000h
	ld bc,800h
	ldir
	
	jp l07cah		;0100
