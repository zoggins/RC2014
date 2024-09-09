; z80dasm 1.1.6
; command line: z80dasm --labels --origin=0x100 TANKWAR.COM

	org	00100h

l0100h:
	jp l0d03h
l0103h:
	ld sp,01800h
	ld bc,l08ffh
	ld hl,l0c00h
	call sub_0553h
	ld hl,l0658h
	ld de,01418h
	ld bc,00018h
l0118h:
	ldir
	ld hl,l0658h
	ld de,0146fh
	ld c,018h
	ldir
	ld hl,l0670h
	ld de,01446h
	ld c,024h
	ldir
	ld hl,l0670h
	ld de,0149dh
l0134h:
	ld c,00ch
	ldir
	ld hl,l0694h
	ld de,014a9h
	ld c,018h
	ldir
	ld hl,l06ach
	ld de,014d7h
	ld c,00ch
	ldir
	ld hl,l0700h
l014fh:
	ld de,00c80h
	ld bc,l0100h
	ldir
	ld a,010h
	call 0055bh
	in a,(018h)
	and 088h
	jp nz,00059h
l0163h:
	; ZOGGINS
	; I think this was used to disable the display, but
	; it also change the DMA address.  However, it doesn't 
	; appear necessary.
	;xor a	
	;out (00eh),a
	nop
	nop
	nop
	ld bc,l01f3h+1
	ld hl,l0c00h
	call sub_0553h
	ld a,0ffh
	ld hl,l0612h
	inc hl	
	ld (0146eh),a
	ld a,(hl)	
	or a	
	jp z,00092h
	ld b,a	
	inc hl	
	ld c,(hl)	
	inc hl	
	call sub_048ah
	ld a,(0146eh)
	xor 00fh
	ld (de),a	
	inc c	
	ld a,c	
	cp (hl)	
	ld a,000h
	jp z,00071h
	jp 0007eh
	ld hl,005d8h
	inc hl	
	ld a,(hl)	
	or a	
	jp z,000aeh
	ld b,a	
	inc hl	
	ld c,(hl)	
	inc hl	
	call sub_048ah
	ld a,0ffh
	ld (de),a	
	inc b	
	ld a,b	
	cp (hl)	
	jp z,00095h
	jp 0009fh
	ld bc,0fcf1h
	ld hl,l0405h
	call sub_048ah
	ld a,009h
	ld (de),a	
	inc b	
	inc b	
	inc b	
	dec h	
	jp nz,000b4h
	ld h,004h
	ld a,0f4h
	add a,b	
	ld b,a	
	ld a,006h
	add a,c	
	ld c,a	
	dec l	
	jp nz,000b4h
	ld de,l0800h
	ld hl,0046dh
	ld bc,0f4edh
	call sub_0445h
	ld de,l0b00h
	ld hl,0046dh
	ld bc,l0513h
	call sub_0445h
	ld a,06fh
	call 0055bh
	in a,(018h)
	and 066h
l01f3h:
	jp z,00000h
	ld a,(0143dh)
	cp 090h
	jp nc,000ech
	ld b,000h
	ld a,(01447h)
	ld c,a	
	in a,(c)
	and 0c0h
	ld hl,(01418h)
	jp po,00110h
	ld h,000h
	jp 0011eh
	jp p,00117h
	ld h,00fh
	ld b,080h
	ld a,03fh
	cp h	
	jp z,0011eh
	inc h	
	ld a,(01446h)
	ld c,a	
	in a,(c)
	and 0c0h
	ld de,00000h
	jp pe,0013dh
	ld a,001h
	jp p,l0134h
	ld a,0ffh
	ld e,a	
	add a,l	
	ld l,a	
	xor e	
l023ah:
	and 00fh
	jp nz,0013dh
	inc d	
	ld (01400h),hl
	ld a,h	
	and 030h
	ld h,a	
	or d	
	jp nz,l0163h
	ld hl,0141ah
	ld de,01402h
	ld bc,00016h
	ldir
	ld de,003ffh
	dec e	
	jp nz,00156h
	ld e,0ffh
	dec d	
	jp nz,00156h
	jp l01f3h
	ld a,l	
	xor b	
	ld c,a	
	ld b,h	
	push bc	
	ld hl,(0142ah)
	call sub_052fh
	ld (01412h),hl
	ld a,h	
	sra a
	sra a
	ld (01417h),a
	pop bc	
	ld a,0c0h
	add a,c	
	ld c,a	
	ld hl,(0142ch)
l0284h:
	call sub_052fh
	ld (01414h),hl
	ld a,h	
	sra a
	ld (01416h),a
	ld a,(01413h)
	call 004d3h
	ld hl,(01450h)
	ex de,hl	
	ld a,(01400h)
	and 0f0h
	ld l,a	
	ld a,(01415h)
	and 001h
	rlca	
	rlca	
	rlca	
l02a8h:
	add a,l	
	ld l,a	
	ld h,000h
	add hl,hl	
	add hl,de	
	ld de,01402h
	call 00479h
	ld hl,(0142eh)
	ld de,0141ah
	ld b,h	
l02bbh:
	ld c,l	
	ld hl,0046dh
	call sub_0445h
	ld hl,(01416h)
	ld de,01402h
	ld b,h	
	ld c,l	
	ld hl,00472h
	call sub_0445h
	and a	
	jp nz,001e5h
	ld h,b	
	ld l,c	
	ld (01439h),hl
	ld hl,01418h
	ld de,01400h
	ld bc,00018h
	ldir
	xor a	
l02e5h:
	ld (01401h),a
	ld hl,(01416h)
	ld b,h	
	ld c,l	
	ld hl,0046dh
	ld de,01402h
	call sub_0445h
	ld a,(0143fh)
	or a	
	jp m,002f1h
	jp nz,l023ah
	in a,(018h)
	ld b,a	
l0303h:
	ld a,(01448h)
	and b	
	jp nz,0032ah
	ld a,004h
	ld (0143fh),a
	ld a,(01400h)
	ld (01430h),a
	and 0f0h
	rrca	
	rrca	
	rrca	
	rrca	
	ld c,a	
	ld b,000h
	ld hl,00644h
	add hl,bc	
	ld a,(0142dh)
	add a,(hl)	
	ld (01434h),a
	ld c,004h
	add hl,bc	
	ld a,(0142bh)
	add a,(hl)	
	ld (01432h),a
	xor a	
	ld (01442h),a
	call 00566h
	jp 0032ah
	ld a,(01430h)
	ld c,a	
	ld b,0a0h
	push bc	
	ld hl,(01431h)
	call sub_052fh
	ld (01431h),hl
	pop bc	
	ld a,0c0h
	add a,c	
	ld c,a	
	ld hl,(01433h)
	call sub_052fh
	ld (01433h),hl
	ld a,h	
	sra a
	ld c,a	
	dec a	
	ld (01435h),a
	ld a,(01432h)
	sra a
	sra a
	ld b,a	
	dec a	
	ld (01436h),a
	call sub_048ah
	ex de,hl	
	ld (01443h),hl
	ld a,(01432h)
	call 004d3h
	ld a,(01434h)
	cpl	
	and 001h
	jp nz,l0284h
	ld a,004h
	call 004eeh
	ld (01445h),a
	ld hl,(01440h)
	ld a,(01442h)
	xor (hl)	
	ld (hl),a	
	ld hl,(01443h)
	ld a,(01445h)
	ld (01440h),hl
	ld (01442h),a
	and (hl)	
	jp z,l02a8h
	ld a,(hl)	
	cp 009h
	jp nz,l02bbh
	ld a,(0143fh)
	add a,004h
l03b0h:
	ld (0143fh),a
l03b3h:
	jp m,l02e5h
	ld a,(01445h)
	xor (hl)	
	ld (hl),a	
	jp 0032ah
	ld a,080h
	ld (0143fh),a
	ld hl,(0146ah)
	ex de,hl	
	ld a,(01434h)
	sub e	
l03cbh:
	jp m,l02e5h
	cp 009h
	jp p,l02e5h
	ld a,(01432h)
	sub d	
	jp m,l02e5h
	cp 009h
	jp p,l02e5h
	ld a,(0143dh)
	add a,002h
	daa	
	ld (0143dh),a
	ld hl,00593h
	ld (01437h),hl
	call 00566h
	jp 0032ah
	ld a,(0143fh)
	add a,004h
	ld (0143fh),a
	and 01fh
	jp nz,0032ah
	ld hl,(01437h)
l0404h:
	ex de,hl	
l0405h:
	ld hl,(01435h)
	ld b,h	
	ld c,l	
	ld hl,0046dh
	call sub_0445h
	ld a,(0143fh)
	or a	
	jp z,0032ah
	ld hl,(01437h)
	ld de,0000ah
	add hl,de	
	ld (01437h),hl
sub_0421h:
	ex de,hl	
	ld hl,(01435h)
	ld b,h	
	ld c,l	
	ld hl,0046dh
	call sub_0445h
	ld a,(01413h)
	ld (0146bh),a
	ld a,(01415h)
	ld (0146ah),a
	ld de,01455h
	ld bc,0fcf1h
	ld hl,l0404h
	ld a,(de)	
	cp 002h
sub_0445h:
	jp z,l03cbh
	push hl	
	push de	
	push bc	
	or a	
	jp m,0037ah
	jp nz,l03b3h
	ld a,(01439h)
	cp c	
	jp nz,l03b3h
	ld a,(0143ah)
	cp b	
	jp nz,l03b3h
	ld a,080h
	ld (de),a	
	ld a,001h
	ld (0146dh),a
	ld hl,00593h
	ld (0143bh),hl
	pop bc	
	push bc	
	call sub_048ah
	ld a,(de)	
	xor 009h
	ld (de),a	
	call 00566h
	jp l03b3h
	ld a,(de)	
	add a,002h
	ld (de),a	
	and 01fh
	jp nz,l03b3h
	pop bc	
	push bc	
l0488h:
	dec b	
	dec c	
sub_048ah:
	ld hl,(0143bh)
	ex de,hl	
	ld hl,0046dh
	call sub_0445h
	pop bc	
	pop de	
	push de	
	push bc	
	ld a,(de)	
l0499h:
	or a	
	jp z,l03b0h
	ld hl,(0143bh)
l04a0h:
	ld de,0000ah
	add hl,de	
	ld (0143bh),hl
	ex de,hl	
	dec b	
	dec c	
	ld hl,0046dh
	call sub_0445h
	jp l03b3h
	add a,004h
	ld (de),a	
	pop bc	
	pop de	
	pop hl	
	inc de	
	ld a,b	
	add a,003h
	ld b,a	
	dec h	
	jp nz,0033fh
l04c2h:
	ld h,l	
	ld a,b	
	sub 00ch
	ld b,a	
	ld a,c	
	add a,006h
	ld c,a	
	jp 0033fh
	ld a,(01449h)
	ld b,a	
	ld a,(0146ch)
	ld c,a	
	ld a,(0143dh)
	add a,c	
	daa	
	ld (0143dh),a
	ld c,0e2h
	and 0f0h
	rlca	
	rlca	
	rlca	
	rlca	
l04e6h:
	call sub_0421h
	ld c,0e2h
	inc b	
	ld a,(0143dh)
	and 00fh
	call sub_0421h
	ld a,(0146dh)
	ld (0146ch),a
	xor a	
	ld (0146dh),a
	ld hl,(0144eh)
	ld de,01430h
	ex de,hl	
	ld bc,00016h
	ldir
	ld de,01400h
	ld bc,00018h
	ld hl,(0144ch)
l0513h:
	ex de,hl	
	ldir
	ld hl,(0144ah)
	ld de,01418h
	ld bc,0003ah
	ldir
	jp 000ech
	ld e,a	
	ld d,000h
	ld hl,l05bbh
	add hl,de	
	add hl,de	
	add hl,de	
	push hl	
	ld a,b	
sub_052fh:
	or a	
	ld hl,00003h
	jp m,00435h
	ld h,0ffh
	ex (sp),hl	
	call sub_048ah
	ld a,(hl)	
	inc hl	
	ex (sp),hl	
l053fh:
	xor h	
	ld (de),a	
	inc c	
l0542h:
	dec l	
	jp nz,00435h
	pop hl	
	ret	
	ld (01453h),hl
l054bh:
	ex de,hl	
	ld de,l0303h
	push de	
	ex (sp),hl	
	ex (sp),hl	
	ld a,(hl)	
sub_0553h:
	cp 099h
	jp nz,00457h
	pop de	
	ret	
	call sub_048ah
	ld a,(de)	
	jp 01452h
	inc hl	
	ex (sp),hl	
	inc b	
	dec h	
	jp nz,0044eh
	ld h,l	
	ld a,b	
	sub h	
	ld b,a	
l056ch:
	inc c	
l056dh:
	jp 0044eh
	xor (hl)	
	ld (de),a	
	jp 0045eh
	and (hl)	
	jp z,0045eh
	pop de	
	xor a	
	ret	
	ld a,(hl)	
	cp 099h
	jp z,l0488h
	call 004eeh
	ld (de),a	
	inc de	
	inc hl	
	jp 00479h
	ld (de),a	
	ret	
	push hl	
	ld a,0f0h
	cp b	
	jp m,00492h
	ld b,a	
	ld a,0e0h
	cp c	
	jp m,l0499h
	ld c,a	
	ld a,01fh
	cp c	
	jp p,l04a0h
	ld c,a	
	ld a,b	
	or c	
	ld de,l0600h
	ld h,000h
	jp p,l04c2h
	ld a,b	
	and c	
	ld de,00110h
	ld h,0ffh
	jp m,l04c2h
	or b	
	ld de,00310h
l05bbh:
	ld h,000h
	jp m,l04c2h
	ld de,00400h
	ld h,0ffh
	ld l,c	
	add hl,hl	
	add hl,hl	
	add hl,hl	
	add hl,hl	
	add hl,de	
	ld e,b	
	ld d,000h
	add hl,de	
l05cfh:
	ld de,l0c00h
	add hl,de	
	ex de,hl	
	pop hl	
	ret	
	exx	
	and 003h
	rlca	
	ld e,a	
	ld d,000h
	ld hl,l04e6h
	add hl,de	
	ld e,(hl)	
	inc hl	
	ld d,(hl)	
	ex de,hl	
	ld d,000h
	exx	
	ret	
	dec b	
	dec b	
	jp p,l0804h
	dec b	
	add hl,de	
	dec b	
	exx	
	jp (hl)	
	exx	
	ret	
	rlca	
	ld b,a	
	and 0aah
	ld c,a	
	ld a,b	
	rlca	
	rlca	
	ld b,a	
	and 050h
l0600h:
	or c	
	or d	
	ld c,a	
	ld a,b	
	and 005h
	ld d,a	
	ld a,c	
	jp 004f0h
	rlca	
	rlca	
	rlca	
	rlca	
	ld b,a	
	and 0f0h
l0612h:
	or d	
	ld c,a	
	ld a,b	
	and 00fh
	ld d,a	
	ld a,c	
	jp 004f0h
	rrca	
	ld b,a	
	and 055h
	ld c,a	
	ld a,b	
	rrca	
	rrca	
	ld b,a	
	and 0a0h
	or d	
	ld e,a	
	ld a,b	
	and 00ah
	or c	
	ld d,a	
	ld a,e	
	jp 004f0h
	ex de,hl	
	ld hl,00581h
	ld a,c	
	and 0f0h
	rrca	
	rrca	
	rrca	
	cp 012h
	jp m,l0542h
	xor 01eh
	add a,002h
	ld c,a	
	ld a,b	
	ld b,000h
	add hl,bc	
	ld c,(hl)	
	inc hl	
	ld b,(hl)	
	ex de,hl	
	or a	
	ret z	
	add hl,bc	
	sub 010h
	jp l054bh
	ld e,l	
	ld d,h	
l0658h:
	ld (hl),000h
	inc de	
	ldir
	ret	
	out (00fh),a
	ld hl,l0c00h
	ld a,h	
	scf	
	rra	
	out (00eh),a
	ret	
	ld d,0a0h
	ld b,020h
	ld a,07fh
	ld c,b	
l0670h:
	dec c	
	jp nz,l056dh
	out (019h),a
	out (01bh),a
	cpl	
	inc b	
	dec d	
	jp nz,l056ch
	xor a	
	out (019h),a
	out (01bh),a
	ret	
	dec hl	
	nop	
	daa	
	nop	
	ld e,000h
	djnz l068ch
l068ch:
	nop	
	nop	
	ret p	
	rst 38h	
	jp po,0d9ffh
	rst 38h	
l0694h:
	sub 0ffh
	sbc a,c	
	nop	
	nop	
	nop	
	nop	
	nop	
	nop	
	nop	
	nop	
	nop	
	add a,b	
	inc c	
	nop	
	and b	
	ld c,000h
	nop	
	nop	
	nop	
	sbc a,c	
	ld h,b	
	ld b,e	
l06ach:
	nop	
	ld d,b	
	ld d,c	
	nop	
	jr nz,$+5
	nop	
	sbc a,c	
	djnz $+19
	nop	
	djnz l06c9h
	nop	
	djnz $+19
	nop	
	sbc a,c	
	cp d	
	xor d	
	ld (0a0a0h),a
	jr nz,$-76
	ld a,(0b232h)
	or d	
l06c9h:
	ld (0b28ah),a
	jr nz,l0708h
	or d	
	ld (0ba3ah),a
	ld (0a0b2h),a
	jr nz,$-68
	cp d	
	ld (0b2bah),a
	ld (0e0f4h),a
	djnz $-14
	and 0f4h
	call p,0f7ebh
	jp m,0fee8h
	ret p	
	ld sp,hl	
	di	
	di	
	ld (bc),a	
	or 0f3h
l06efh:
	ld (de),a	
	rst 30h	
	ret p	
	rra	
	djnz l06efh
	ld de,004fch
	ret pe	
	rlca	
	rlca	
	rst 30h	
	ld a,(bc)	
	rlca	
	ld (bc),a	
	dec c	
l0700h:
	inc b	
	ld de,l0b07h
	inc de	
	ld c,00ch
	pop hl	
l0708h:
	djnz l0716h
	jp po,l0c10h
	ex (sp),hl	
	djnz l071ch
	call po,l0c10h
	push hl	
	djnz l0716h
l0716h:
	rrca	
	ret po	
	jr nz,l0724h
	di	
	ld sp,hl	
l071ch:
	rlca	
	ret pe	
	xor 007h
	ret m	
	defb 0fdh,007h,00ch	;illegal sequence
l0724h:
	ld (de),a	
	inc b	
	ld de,l0118h
l0729h:
	pop hl	
	call pe,01901h
	jr nz,l0729h
	ret pe	
	call pe,0fefah
	dec b	
	jp m,0120bh
	rst 30h	
	ex de,hl	
	di	
	or 0fch
	inc bc	
	push af	
	inc e	
	jr nz,$-14
	and 020h
	call p,0e7e1h
	nop	
	ld (bc),a	
	ld (bc),a	
	rlca	
	ex af,af'	
	rlca	
	ex af,af'	
	rlca	
	inc bc	
	ld (bc),a	
	inc bc	
	ld bc,00000h
	nop	
	ld bc,00202h
	ld (bc),a	
	rlca	
	ex af,af'	
	nop	
	nop	
	ei	
	add a,a	
	nop	
	jp m,000b7h
	inc sp	
	inc bc	
	nop	
	sbc a,c	
	nop	
	nop	
	nop	
	nop	
	nop	
	nop	
	nop	
	ret nc	
	nop	
	jp c,0f4edh
	add hl,de	
	ld a,(de)	
	ld bc,0a9f1h
	inc d	
	ld l,a	
	inc d	
	add a,a	
	inc d	
	nop	
	ex af,af'	
	jp 00000h
	nop	
	nop	
	nop	
	nop	
	nop	
	nop	
	nop	
	nop	
	nop	
	nop	
	nop	
	nop	
	nop	
	nop	
	nop	
	nop	
	nop	
	nop	
	nop	
	nop	
	ld (bc),a	
	add a,b	
	nop	
	or h	
	ld (hl),a	
	nop	
	or a	
	ld d,h	
	nop	
	jr nc,l07d4h
	nop	
	sbc a,c	
	nop	
	nop	
	nop	
	nop	
	nop	
	nop	
	nop	
	inc d	
	nop	
	ld h,013h
	dec b	
	dec de	
	inc e	
	djnz l07c0h
	ld l,a	
	inc d	
	xor c	
	inc d	
	pop bc	
	inc d	
	nop	
	ld a,(bc)	
	add hl,sp	
	nop	
	add hl,sp	
	nop	
	add hl,sp	
l07c0h:
	nop	
	add hl,sp	
	nop	
	add hl,sp	
	nop	
	add hl,sp	
	nop	
	add hl,sp	
	nop	
	add hl,sp	
	nop	
	add hl,sp	
	nop	
	add hl,sp	
	nop	
	add hl,sp	
	nop	
	add hl,sp	
	nop	
	add hl,sp	
l07d4h:
	nop	
	add hl,sp	
	nop	
	add hl,sp	
	nop	
	add hl,sp	
	nop	
	add hl,sp	
	nop	
	add hl,sp	
	nop	
	add hl,sp	
	nop	
	add hl,sp	
	nop	
	add hl,sp	
	nop	
	add hl,sp	
	nop	
	add hl,sp	
	nop	
	add hl,sp	
	nop	
	add hl,sp	
	nop	
	add hl,sp	
	nop	
	add hl,sp	
	nop	
	add hl,sp	
	nop	
	add hl,sp	
	nop	
	add hl,sp	
	nop	
	add hl,sp	
	nop	
	add hl,sp	
	nop	
	add hl,sp	
	nop	
	add hl,sp	
	nop	
	add hl,sp	
l0800h:
	nop	
	add hl,sp	
	nop	
	ret nz	
l0804h:
	call z,sub_0ccch
	or b	
	cp e	
	cp e	
	dec bc	
	ret p	
	rrca	
	ret p	
	rrca	
	and b	
	ld a,(bc)	
	and b	
	ld a,(bc)	
	ret nz	
	call z,sub_0ccch
	or b	
	cp e	
	cp e	
	dec bc	
	ret p	
	rst 38h	
	ret p	
	rrca	
	and b	
	ld a,(bc)	
	xor d	
	ld a,(bc)	
	nop	
	ret nz	
	inc c	
	nop	
	or b	
	dec bc	
	or b	
	dec bc	
	ret p	
	rst 38h	
	ret p	
	rrca	
	and b	
	ld a,(bc)	
	xor d	
	nop	
	nop	
	ret nz	
	inc c	
	nop	
	or b	
	dec bc	
	or b	
	dec bc	
	ret p	
	rst 38h	
	rst 38h	
	rrca	
	and b	
	xor d	
	ld a,(bc)	
	nop	
	nop	
	ret nz	
	inc c	
	nop	
	or b	
	cp e	
	cp e	
	dec bc	
	ret p	
	rst 38h	
	rst 38h	
	rrca	
	and b	
	xor d	
	ld a,(bc)	
	nop	
	nop	
	ret nz	
	inc c	
	nop	
	or b	
	cp e	
	cp e	
	dec bc	
	ret p	
	rrca	
	rst 38h	
	rrca	
	and b	
	ld a,(bc)	
	xor d	
	nop	
	nop	
	ret nz	
	inc c	
	nop	
	or b	
	dec bc	
	or b	
	dec bc	
	ret p	
	rrca	
	rst 38h	
	rrca	
	and b	
	ld a,(bc)	
	xor d	
	ld a,(bc)	
	nop	
	ret nz	
	inc c	
	nop	
	or b	
	dec bc	
	or b	
	dec bc	
	ret p	
	rrca	
	ret p	
	rrca	
	and b	
	ld a,(bc)	
	and b	
	ld a,(bc)	
	nop	
	nop	
	nop	
	nop	
	nop	
	nop	
	nop	
	nop	
	nop	
	nop	
	nop	
	nop	
	nop	
	nop	
	nop	
	nop	
	nop	
	sbc a,c	
	nop	
	nop	
	sbc a,c	
	nop	
	sbc a,c	
	sbc a,c	
	sbc a,c	
	sbc a,c	
	nop	
	sbc a,c	
	sbc a,c	
	sbc a,c	
	sbc a,c	
	nop	
	nop	
	sbc a,c	
	sub b	
	add hl,bc	
	sbc a,c	
	nop	
	sbc a,c	
	sbc a,c	
	sbc a,c	
	sbc a,c	
	nop	
	sbc a,c	
	sbc a,c	
	sbc a,c	
	sbc a,c	
	nop	
	nop	
	sbc a,c	
	sub b	
	add hl,bc	
	sbc a,c	
	nop	
	sbc a,c	
	nop	
	nop	
	sbc a,c	
	nop	
	sbc a,c	
	nop	
	nop	
	sbc a,c	
	nop	
	nop	
	sbc a,c	
	sbc a,c	
	sbc a,c	
	sbc a,c	
	nop	
	sbc a,c	
	sbc a,c	
	sbc a,c	
	sbc a,c	
	nop	
	sbc a,c	
	sbc a,c	
	sbc a,c	
	sbc a,c	
	nop	
	nop	
	sub b	
	sbc a,c	
	sbc a,c	
	add hl,bc	
	nop	
	sbc a,c	
	sbc a,c	
	sbc a,c	
	sbc a,c	
	nop	
	sbc a,c	
	nop	
	sbc a,c	
	nop	
	nop	
l08e3h:
	nop	
	sub b	
	add hl,bc	
	sub b	
	add hl,bc	
	nop	
	sbc a,c	
	nop	
	nop	
	sbc a,c	
	nop	
	sbc a,c	
	nop	
	sbc a,c	
	sbc a,c	
	nop	
	nop	
	sub b	
	add hl,bc	
	sub b	
	add hl,bc	
	nop	
	sbc a,c	
	nop	
	nop	
	sbc a,c	
	nop	
	sbc a,c	
l08ffh:
	nop	
	sub b	
	sbc a,c	
	nop	
	ei	
	add a,a	
	nop	
	jp m,000b7h
	inc sp	
	inc bc	
	nop	
	sbc a,c	
	nop	
	nop	
	nop	
	nop	
	nop	
	nop	
	call z,0000ch
	jp m,000edh
	cp 02dh
	nop	
	sbc a,c	
	nop	
	nop	
	nop	
	nop	
	nop	
	nop	
	jp p,0004ch
	jp m,l05cfh
	or e	
	dec l	
	nop	
	sbc a,c	
	rst 38h	
	rst 38h	
	rst 38h	
	rst 38h	
	rst 38h	
	rst 38h	
	ret z	
	nop	
	nop	
	ret m	
	rra	
	inc b	
	cp 0b7h
	ld bc,00320h
	nop	
	sbc a,c	
	rst 38h	
	rst 38h	
	rst 38h	
	and b	
	inc b	
	nop	
	call m,0004fh
	jp p,0003fh
	jr nz,l08e3h
	ld bc,01000h
	nop	
	sbc a,c	
	add a,b	
	nop	
	nop	
	ret po	
	dec c	
	nop	
	ei	
	rst 18h	
	nop	
	or b	
	ld b,a	
	inc b	
	nop	
	ld h,c	
	nop	
	sbc a,c	
	call nz,00005h
	rst 38h	
	dec c	
	nop	
	jp m,0000bh
	and d	
	inc b	
	nop	
	jr nc,l0971h
l0971h:
	sbc a,c	
	rst 38h	
	nop	
	inc b	
	nop	
	defb 0fdh,005h,000h	;illegal sequence
	ei	
	rrca	
	nop	
	cp d	
	ld (bc),a	
	nop	
	ret po	
	ld bc,09900h
	call 00005h
	rst 38h	
	dec b	
	nop	
	ld (hl),a	
	dec b	
	nop	
	ret c	
	nop	
	sbc a,c	
	rst 38h	
	rst 38h	
	rst 38h	
	rst 38h	
	inc b	
	inc b	
	nop	
	rst 38h	
	dec b	
	nop	
	rst 38h	
	dec b	
	nop	
	ld d,c	
	ld bc,03200h
	nop	
	sbc a,c	
	rst 38h	
	jp z,00008h
	cp 00fh
	nop	
	rst 30h	
	dec b	
	nop	
	ld e,b	
	ld bc,03000h
	nop	
	sbc a,c	
	rst 38h	
	ex af,af'	
	nop	
	nop	
	jp m,0000eh
	rst 38h	
	rlca	
	nop	
	ld (hl),c	
	dec b	
	nop	
	jp nc,09900h
	rst 38h	
	nop	
	ld c,000h
	ret po	
	rst 18h	
	inc b	
	or d	
	ld a,a	
	nop	
	add hl,de	
	rlca	
	nop	
	djnz l09d1h
l09d1h:
	sbc a,c	
	rst 38h	
	nop	
	ex af,af'	
	nop	
	add a,b	
	ld c,a	
	nop	
	ret m	
	rst 38h	
	ld bc,01f64h
	nop	
	ld b,d	
	ld bc,09900h
	ret nz	
	ld a,(hl)	
	nop	
	defb 0edh;next byte illegal after ed
	rst 38h	
	nop	
	add a,d	
	ccf	
	ld bc,09900h
	rst 38h	
	rst 38h	
	rst 38h	
	rst 38h	
	rst 38h	
	nop	
l09f4h:
	ret z	
	nop	
	or h	
	rst 18h	
	nop	
	dec sp	
	rst 38h	
	inc b	
	jr nz,l0a01h
	nop	
	sbc a,c	
	rst 38h	
l0a01h:
	rst 38h	
	rst 38h	
	or h	
	ld a,a	
	nop	
l0a06h:
	or a	
	ld e,a	
	nop	
	jr nc,$+53
	nop	
	sbc a,c	
	rst 38h	
	rst 38h	
	rst 38h	
	rst 38h	
	rst 38h	
	rst 38h	
	ret nz	
	call z,0ed00h
	ld e,a	
	nop	
	pop hl	
	rst 18h	
	nop	
	sbc a,c	
	rst 38h	
	rst 38h	
	rst 38h	
	rst 38h	
	rst 38h	
	rst 38h	
	jr z,l09f4h
	inc b	
	or a	
	rst 38h	
	nop	
	jr nc,l0a06h
	nop	
	sbc a,c	
	rst 38h	
	rst 38h	
	rst 38h	
	rst 38h	
	rst 38h	
	rst 38h	
	add a,b	
	inc c	
	nop	
	adc a,0ffh
	ld bc,07fe1h
	nop	
	nop	
	ld (09900h),a
	rst 38h	
	rst 38h	
	rst 38h	
	jr l0a49h
	nop	
	sub c	
	ld c,a	
	nop	
l0a49h:
	jp p,004ffh
	jr nz,$+33
	nop	
	nop	
	ld (bc),a	
	nop	
	sbc a,c	
	ld b,b	
	nop	
	nop	
	ld b,(hl)	
	dec c	
	nop	
	ret pe	
	rst 18h	
	nop	
	or b	
	ld a,a	
	ld bc,l0b00h
	nop	
	sbc a,c	
	ld a,b	
	nop	
	nop	
	call nc,00005h
	rst 38h	
	dec c	
	nop	
	jp m,0000bh
	ld (bc),a	
	nop	
	sbc a,c	
	rst 38h	
	ret nz	
	nop	
	nop	
	ld d,d	
	inc b	
	nop	
	defb 0fdh,005h,000h	;illegal sequence
	ei	
	rrca	
	nop	
	ld a,(00002h)
	sbc a,c	
	ld (hl),d	
	nop	
	nop	
	defb 0ddh,005h,000h	;illegal sequence
	rst 38h	
	dec b	
	nop	
	scf	
	dec b	
	nop	
	sbc a,c	
	rst 38h	
	rst 38h	
	rst 38h	
	ret z	
	nop	
	nop	
	ld d,h	
	inc b	
	nop	
	rst 38h	
	dec b	
	nop	
	rst 38h	
	dec b	
	nop	
	ld bc,00001h
	sbc a,c	
	or b	
	inc b	
	nop	
	jp pe,00008h
	cp 00fh
	nop	
	rst 30h	
	dec b	
	nop	
	nop	
	ld bc,09900h
	ret nz	
	nop	
	nop	
	xor b	
	ld bc,0fa00h
	ld c,000h
	rst 38h	
	rlca	
	nop	
	ld sp,00005h
	sbc a,c	
	nop	
	sub h	
	nop	
	ret po	
	dec e	
	ld bc,07ffeh
	nop	
	or b	
	rlca	
	nop	
	jr nz,l0ad1h
l0ad1h:
	sbc a,c	
	rst 38h	
	nop	
	ld b,b	
	nop	
	add a,b	
	ld h,l	
	inc b	
	ret m	
	rst 8	
	nop	
	di	
	rra	
	nop	
	and b	
	ld bc,09900h
l0ae3h:
	call pe,00087h
	jp m,l053fh
	ret m	
	inc de	
	nop	
	sbc a,c	
	rst 38h	
	rst 38h	
	rst 38h	
	rst 38h	
	rst 38h	
	rst 38h	
	add a,b	
	inc c	
	nop	
	ei	
	defb 0edh;next byte illegal after ed
	inc b	
	jp p,l014fh
	ld (09900h),a
	rst 38h	
l0b00h:
	rst 38h	
	rst 38h	
	rst 38h	
	cp e	
	add a,a	
	nop	
	adc a,d	
l0b07h:
	or a	
	nop	
	inc sp	
	inc bc	
	nop	
	sbc a,c	
	nop	
	nop	
	nop	
	nop	
	nop	
	nop	
	call z,0000ch
	ld hl,(000edh)
	xor 02dh
	nop	
	sbc a,c	
	nop	
	nop	
	nop	
	nop	
	nop	
	nop	
	jp p,0004ch
	ld a,(de)	
	adc a,005h
	or e	
	dec l	
	nop	
	sbc a,c	
	rst 38h	
	rst 38h	
	rst 38h	
	rst 38h	
	rst 38h	
	rst 38h	
	ret z	
	nop	
	nop	
	ld a,b	
	dec de	
	inc b	
	adc a,0b7h
	ld bc,00320h
	nop	
	sbc a,c	
	rst 38h	
	rst 38h	
	rst 38h	
	and b	
	inc b	
	nop	
	call m,0004bh
	jp nc,0003eh
	jr nz,l0ae3h
	ld bc,01000h
	nop	
	sbc a,c	
	add a,b	
	nop	
	nop	
	ret po	
	dec c	
	nop	
	ld a,e	
	jp c,0b000h
	ld b,a	
	inc b	
	nop	
	ld h,c	
	nop	
	sbc a,c	
	call nz,00005h
	rra	
	dec c	
	nop	
	jp pe,0000bh
	and d	
	inc b	
	nop	
	jr nc,l0b71h
l0b71h:
	sbc a,c	
	rst 38h	
	nop	
	inc b	
	nop	
	ld a,l	
	dec b	
	nop	
	adc a,e	
	rrca	
	nop	
	cp d	
	ld (bc),a	
	nop	
	ret po	
	ld bc,09900h
	call 00005h
	adc a,l	
	dec b	
	nop	
	ld (hl),a	
	dec b	
	nop	
	ret c	
	nop	
	sbc a,c	
	rst 38h	
	rst 38h	
	rst 38h	
	rst 38h	
	inc b	
	inc b	
	nop	
	scf	
	dec b	
	nop	
	rst 28h	
	dec b	
	nop	
	ld d,c	
	ld bc,03200h
	nop	
	sbc a,c	
	rst 38h	
	jp z,00008h
	ld l,00fh
	nop	
	rst 10h	
	dec b	
	nop	
	ld e,b	
	ld bc,03000h
	nop	
	sbc a,c	
	rst 38h	
	ex af,af'	
	nop	
	nop	
	cp d	
	ld c,000h
	ld c,a	
	rlca	
	nop	
	ld (hl),c	
	dec b	
	nop	
	jp nc,09900h
	rst 38h	
	nop	
	ld c,000h
	ret po	
	in a,(004h)
	or d	
	ld a,h	
	nop	
	add hl,de	
	rlca	
	nop	
	djnz l0bd1h
l0bd1h:
	sbc a,c	
	rst 38h	
	nop	
	ex af,af'	
	nop	
	add a,b	
	ld c,a	
	nop	
	ret m	
	jp p,06401h
	rra	
	nop	
	ld b,d	
	ld bc,09900h
	ret nz	
	ld a,(hl)	
	nop	
	defb 0edh;next byte illegal after ed
	or h	
	nop	
	add a,d	
	ccf	
	ld bc,09900h
	rst 38h	
	rst 38h	
	rst 38h	
	rst 38h	
	rst 38h	
	nop	
l0bf4h:
	ret z	
	nop	
	or h	
	out (000h),a
	dec sp	
	defb 0edh;next byte illegal after ed
	inc b	
	jr nz,l0c01h
	nop	
	sbc a,c	
l0c00h:
	rst 38h	
l0c01h:
	rst 38h	
	rst 38h	
	or h	
	ld (hl),a	
	nop	
l0c06h:
	or a	
	ld d,h	
	nop	
	jr nc,$+53
	nop	
	sbc a,c	
	rst 38h	
	rst 38h	
	rst 38h	
l0c10h:
	rst 38h	
	rst 38h	
	rst 38h	
	ret nz	
	call z,0ed00h
	ld d,c	
	nop	
	pop hl	
	defb 0ddh,000h,099h	;illegal sequence
	rst 38h	
	rst 38h	
	rst 38h	
	rst 38h	
	rst 38h	
	rst 38h	
	jr z,l0bf4h
	inc b	
	or a	
	pop hl	
	nop	
	jr nc,l0c06h
	nop	
	sbc a,c	
	rst 38h	
	rst 38h	
	rst 38h	
	rst 38h	
	rst 38h	
	rst 38h	
	add a,b	
	inc c	
	nop	
	adc a,0b7h
	ld bc,07ce1h
	nop	
	nop	
	ld (09900h),a
	rst 38h	
	rst 38h	
	rst 38h	
	jr l0c49h
	nop	
	sub c	
	ld c,a	
	nop	
l0c49h:
	jp p,004f8h
	jr nz,$+33
	nop	
	nop	
	ld (bc),a	
	nop	
	sbc a,c	
	ld b,b	
	nop	
	nop	
	ld b,(hl)	
	dec c	
	nop	
	ret pe	
	out (000h),a
	or b	
	ld a,(hl)	
	ld bc,l0b00h
	nop	
	sbc a,c	
	ld a,b	
	nop	
	nop	
	call nc,00005h
	rra	
	dec c	
	nop	
	jp pe,0000bh
	ld (bc),a	
	nop	
	sbc a,c	
	rst 38h	
	ret nz	
	nop	
	nop	
	ld d,d	
	inc b	
	nop	
	ld a,l	
	dec b	
	nop	
	adc a,e	
	rrca	
	nop	
	ld a,(00002h)
	sbc a,c	
	ld (hl),d	
	nop	
	nop	
	defb 0ddh,005h,000h	;illegal sequence
	daa	
	dec b	
	nop	
	scf	
	dec b	
	nop	
	sbc a,c	
	rst 38h	
	rst 38h	
	rst 38h	
	ret z	
	nop	
	nop	
	ld d,h	
	inc b	
	nop	
	cp a	
	dec b	
	nop	
	call 00005h
	ld bc,00001h
	sbc a,c	
	or b	
	inc b	
	nop	
	jp pe,00008h
	ld l,00fh
	nop	
	rst 10h	
	dec b	
	nop	
	nop	
	ld bc,09900h
	ret nz	
	nop	
	nop	
	xor b	
	ld bc,0ba00h
	ld c,000h
	ld c,a	
	rlca	
	nop	
	ld sp,00005h
	sbc a,c	
	nop	
	sub h	
	nop	
	ret po	
	dec e	
	ld bc,07adeh
	nop	
sub_0ccch:
	or b	
	rlca	
	nop	
	jr nz,l0cd1h
l0cd1h:
	sbc a,c	
	rst 38h	
	nop	
	ld b,b	
	nop	
	add a,b	
	ld h,l	
	inc b	
	ld a,b	
	rlc b
	di	
	ld e,000h
	and b	
	ld bc,09900h
	call pe,00087h
	ld c,d	
	dec sp	
	dec b	
	ret m	
	inc de	
	nop	
	sbc a,c	
	rst 38h	
	rst 38h	
	rst 38h	
	rst 38h	
	rst 38h	
	rst 38h	
	add a,b	
	inc c	
	nop	
	dec sp	
	defb 0edh;next byte illegal after ed
	inc b	
	jp nc,0014eh
	ld (09900h),a
	rst 38h	
	rst 38h	
	rst 38h	
	rst 38h	
l0d03h:
	ld hl,l0103h
	ld de,00000h
	ld bc,l0c00h
	ldir

	; ZOGGINS
	; Set DMA address
	ld hl,l0c00h
	ld a,h
	scf
	rra
	out (00eh),a

	jp 00000h
