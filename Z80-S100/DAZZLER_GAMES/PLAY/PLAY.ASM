; z80dasm 1.1.6
; command line: z80dasm --labels --origin=0x100 PLAY.COM

	org	00100h

	jp l0103h
l0103h:
	ld de,l02f0h
	call sub_0267h
	ld de,l02d1h
	ld c,00fh
	call 00005h
	inc a	
	jr z,l018bh
	ld hl,(l055eh)
	inc h	
	ld l,000h
	ld a,081h
	sub h	
	ld (l055bh),a
	call sub_0286h
	ld (l055ch),hl
	ld de,00080h
	ld c,01ah
	call 00005h
	ld a,(0005dh)
	cp 020h
	jr nz,l013eh
l0135h:
	ld de,l0342h
	call sub_0267h
	call sub_0279h
l013eh:
	ld de,0005ch
	ld c,00fh
	call 00005h
	inc a	
	jr z,l0190h
	ld hl,(l055ch)
	call sub_0286h
	ld de,(00006h)
	and a	
	sbc hl,de
	ld de,l0517h
	jr nc,l0185h
l015bh:
	ld de,l036eh
	call sub_029bh
	call z,sub_0198h
	ld de,l039eh
	call sub_02abh
	ld b,a	
l016bh:
	push bc	
	call 00562h
	pop bc	
	djnz l016bh
	ld de,l034eh
	call sub_029bh
	jr z,l015bh
	ld de,l0363h
	call sub_029bh
	jr z,l0135h
	ld de,l054bh
l0185h:
	call sub_0267h
	jp 00000h
l018bh:
	ld de,l0537h
	jr l0185h
l0190h:
	ld de,l0506h
	call sub_0267h
	jr l0135h
sub_0198h:
	ld ix,(l055ch)
	ld de,l0405h
	ld a,(ix+00ah)
	and 07fh
	call sub_022eh
	ld de,l0421h
	ld a,(ix+00bh)
	and 07fh
	call sub_022eh
	ld de,l043dh
	ld a,(ix+00ch)
	and 07fh
	call sub_022eh
	ld de,l0459h
	ld a,(ix+00dh)
	and 07fh
	call sub_022eh
	ld de,l03b6h
	call sub_029bh
	jr nz,l01dbh
	ld de,l0475h
	call sub_02abh
	or 080h
	ld (ix+00ah),a
l01dbh:
	ld de,l03c6h
	call sub_029bh
	jr nz,l01eeh
	ld de,l048dh
	call sub_02abh
	or 080h
	ld (ix+00bh),a
l01eeh:
	ld de,l03d6h
	call sub_029bh
	jr nz,l0201h
	ld de,l04a5h
	call sub_02abh
	or 080h
	ld (ix+00ch),a
l0201h:
	ld de,l03e6h
	call sub_029bh
	jr nz,l0214h
	ld de,l04bdh
	call sub_02abh
	or 080h
	ld (ix+00dh),a
l0214h:
	ld de,l04d5h
	ld a,(ix+00eh)
	call sub_022eh
	ld de,l03f6h
	call sub_029bh
	ret nz	
	ld de,l04f0h
	call sub_02abh
	ld (ix+00eh),a
	ret	
sub_022eh:
	call sub_0267h
	ld hl,l02cdh
	ld (hl),000h
	ld hl,l02ceh
	ld c,002h
	ld e,(hl)	
l023ch:
	ld d,000h
l023eh:
	inc d	
	sub e	
	jr nc,l023eh
	add a,e	
	ld b,a	
	dec d	
	jr nz,l024dh
	ld a,(l02cdh)
	and a	
	jr z,l0257h
l024dh:
	ld a,d	
	add a,030h
	ld (l02cdh),a
	ld e,a	
	call 00005h
l0257h:
	inc hl	
	ld a,(hl)	
	and a	
	ld e,a	
	ld a,b	
	jr nz,l023ch
	add a,030h
	ld e,a	
	call 00005h
l0264h:
	ld de,l0514h
sub_0267h:
	ld c,009h
	jp 00005h
sub_026ch:
	ld hl,00080h
	ld (hl),l	
	ld c,00ah
	ex de,hl	
	call 00005h
	ex de,hl	
	jr l0264h
sub_0279h:
	call sub_026ch
	inc hl	
	inc hl	
	ld de,0005ch
	ld c,086h
	jp 00005h
sub_0286h:
	push de	
	ex de,hl	
	ld c,01ah
	call 00005h
	ld hl,00080h
	add hl,de	
	pop de	
	ld c,014h
	call 00005h
	and a	
	jr z,sub_0286h
	ret	
sub_029bh:
	call sub_0267h
	ld c,001h
	call 00005h
	call l0264h
	and 05fh
	cp 059h
	ret	
sub_02abh:
	call sub_0267h
	call sub_026ch
	inc hl	
	inc hl	
	sub a	
l02b4h:
	ld c,a	
	ld a,(hl)	
	sub 030h
	jr c,l02c8h
	cp 03ah
	jr nc,l02c8h
	ld b,a	
	ld a,c	
	add a,a	
	add a,a	
	add a,c	
	add a,a	
	add a,b	
	inc hl	
	jr l02b4h
l02c8h:
	ld a,c	
	and a	
	ret nz	
	inc a	
	ret	
l02cdh:
	nop	
l02ceh:
	ld h,h	
	ld a,(bc)	
	nop	
l02d1h:
	nop	
	ld d,(hl)	
	ld c,a	
	ld c,c	
	ld b,e	
	ld b,l	
	ld d,e	
	jr nz,l02fah
	ld c,l	
	ld d,l	
	ld d,e	
	nop	
	nop	
	nop	
	ld a,009h
	jr l031ah
	call 02019h
	ld a,(03f3ch)
	add a,002h
	cp d	
	call nz,023ech
l02f0h:
	ld c,l	
	ld (hl),l	
	ld (hl),e	
	ld l,c	
	ld h,e	
	jr nz,$+82
	ld l,h	
	ld h,c	
	ld a,c	
l02fah:
	ld h,l	
	ld (hl),d	
	inc l	
	jr nz,$+120
	ld h,l	
	ld (hl),d	
	ld (hl),e	
	ld l,c	
	ld l,a	
	ld l,(hl)	
	jr nz,l0337h
	jr nc,l0337h
	jr nc,l033dh
	dec c	
	ld a,(bc)	
	ld a,(bc)	
	ld d,a	
	ld h,l	
	ld l,h	
	ld h,e	
	ld l,a	
	ld l,l	
	ld h,l	
	jr nz,l038bh
	ld l,a	
	jr nz,l038eh
l031ah:
	ld l,b	
	ld h,l	
	jr nz,$+89
	ld l,a	
	ld l,(hl)	
	ld h,h	
	ld h,l	
	ld (hl),d	
	ld h,(hl)	
	ld (hl),l	
	ld l,h	
	jr nz,l037fh
	ld l,a	
	ld (hl),d	
	ld l,h	
	ld h,h	
	jr nz,$+113
	ld h,(hl)	
	jr nz,l0374h
	ld c,a	
	ld c,l	
	ld d,b	
	ld d,l	
	ld d,h	
	ld b,l	
l0337h:
	ld d,d	
	jr nz,l0387h
	ld d,l	
	ld d,e	
	ld c,c	
l033dh:
	ld b,e	
	dec c	
	ld a,(bc)	
	ld a,(bc)	
	inc h	
l0342h:
	ld d,e	
	ld l,a	
	ld l,(hl)	
	ld h,a	
	jr nz,l03aeh
	ld l,c	
	ld l,h	
	ld h,l	
	ccf	
	jr nz,l0372h
l034eh:
	ld d,b	
	ld l,h	
	ld h,c	
	ld a,c	
	jr nz,$+107
	ld (hl),h	
	jr nz,l03b8h
	ld h,a	
	ld h,c	
	ld l,c	
	ld l,(hl)	
	inc l	
	jr nz,l03b1h
	ld h,c	
	ld l,l	
	ccf	
	jr nz,l0387h
l0363h:
	ld c,(hl)	
	ld h,l	
	ld (hl),a	
	jr nz,l03dbh
	ld l,a	
	ld l,(hl)	
	ld h,a	
	ccf	
	jr nz,l0392h
l036eh:
	ld b,h	
	ld l,a	
	jr nz,l03ebh
l0372h:
	ld l,a	
	ld (hl),l	
l0374h:
	jr nz,$+121
	ld h,c	
	ld l,(hl)	
	ld (hl),h	
	jr nz,l03efh
	ld l,a	
	jr nz,l03e1h
	ld l,b	
l037fh:
	ld h,c	
	ld l,(hl)	
	ld h,a	
	ld h,l	
	jr nz,l03f9h
	ld l,b	
	ld h,l	
l0387h:
	jr nz,l03fch
	ld (hl),h	
	ld h,c	
l038bh:
	ld (hl),d	
	ld (hl),h	
	ld l,c	
l038eh:
	ld l,(hl)	
	ld h,a	
	jr nz,l0402h
l0392h:
	ld h,c	
	ld (hl),d	
	ld h,c	
	ld l,l	
	ld h,l	
	ld (hl),h	
	ld h,l	
	ld (hl),d	
	ld (hl),e	
	ccf	
	jr nz,$+38
l039eh:
	ld c,b	
	ld l,a	
	ld (hl),a	
	jr nz,l0410h
	ld h,c	
	ld l,(hl)	
	ld a,c	
	jr nz,l041ah
	ld h,l	
	ld (hl),b	
	ld h,l	
	ld (hl),h	
	ld l,c	
	ld (hl),h	
l03aeh:
	ld l,c	
	ld l,a	
	ld l,(hl)	
l03b1h:
	ld (hl),e	
	jr nz,l03f3h
	jr nz,l03dah
l03b6h:
	ld b,e	
	ld l,b	
l03b8h:
	ld h,c	
	ld l,(hl)	
	ld h,a	
	ld h,l	
	jr nz,l040eh
	ld h,c	
	ld (hl),d	
	ld (hl),h	
	jr nz,l03f4h
	ccf	
	jr nz,l03eah
l03c6h:
	ld b,e	
	ld l,b	
	ld h,c	
	ld l,(hl)	
	ld h,a	
	ld h,l	
	jr nz,l041eh
	ld h,c	
	ld (hl),d	
	ld (hl),h	
	jr nz,l0405h
	ccf	
	jr nz,l03fah
l03d6h:
	ld b,e	
	ld l,b	
	ld h,c	
	ld l,(hl)	
l03dah:
	ld h,a	
l03dbh:
	ld h,l	
	jr nz,l042eh
	ld h,c	
	ld (hl),d	
	ld (hl),h	
l03e1h:
	jr nz,$+53
	ccf	
	jr nz,l040ah
l03e6h:
	ld b,e	
	ld l,b	
	ld h,c	
	ld l,(hl)	
l03eah:
	ld h,a	
l03ebh:
	ld h,l	
	jr nz,l043eh
	ld h,c	
l03efh:
	ld (hl),d	
	ld (hl),h	
	jr nz,l0427h
l03f3h:
	ccf	
l03f4h:
	jr nz,l041ah
l03f6h:
	ld b,e	
	ld l,b	
	ld h,c	
l03f9h:
	ld l,(hl)	
l03fah:
	ld h,a	
	ld h,l	
l03fch:
	jr nz,l0472h
	ld h,l	
	ld l,l	
	ld (hl),b	
	ld l,a	
l0402h:
	ccf	
	jr nz,$+38
l0405h:
	ld d,b	
	ld (hl),d	
	ld h,l	
	ld (hl),e	
	ld h,l	
l040ah:
	ld l,(hl)	
	ld (hl),h	
	jr nz,l0484h
l040eh:
	ld l,a	
	ld l,c	
l0410h:
	ld h,e	
	ld h,l	
	jr nz,$+113
	ld h,(hl)	
	jr nz,$+82
	ld h,c	
	ld (hl),d	
	ld (hl),h	
l041ah:
	jr nz,l044dh
	jr nz,l0487h
l041eh:
	ld (hl),e	
	jr nz,$+38
l0421h:
	ld d,b	
	ld (hl),d	
	ld h,l	
	ld (hl),e	
	ld h,l	
	ld l,(hl)	
l0427h:
	ld (hl),h	
	jr nz,$+120
	ld l,a	
	ld l,c	
	ld h,e	
	ld h,l	
l042eh:
	jr nz,l049fh
	ld h,(hl)	
	jr nz,$+82
	ld h,c	
	ld (hl),d	
	ld (hl),h	
	jr nz,$+52
	jr nz,l04a3h
	ld (hl),e	
	jr nz,$+38
l043dh:
	ld d,b	
l043eh:
	ld (hl),d	
	ld h,l	
	ld (hl),e	
	ld h,l	
	ld l,(hl)	
	ld (hl),h	
	jr nz,$+120
	ld l,a	
	ld l,c	
	ld h,e	
	ld h,l	
	jr nz,l04bbh
	ld h,(hl)	
l044dh:
	jr nz,l049fh
	ld h,c	
	ld (hl),d	
	ld (hl),h	
	jr nz,l0487h
	jr nz,l04bfh
	ld (hl),e	
	jr nz,l047dh
l0459h:
	ld d,b	
	ld (hl),d	
	ld h,l	
	ld (hl),e	
	ld h,l	
	ld l,(hl)	
	ld (hl),h	
	jr nz,l04d8h
	ld l,a	
	ld l,c	
	ld h,e	
	ld h,l	
	jr nz,l04d7h
	ld h,(hl)	
	jr nz,l04bbh
	ld h,c	
	ld (hl),d	
	ld (hl),h	
	jr nz,$+54
	jr nz,l04dbh
l0472h:
	ld (hl),e	
	jr nz,l0499h
l0475h:
	ld c,(hl)	
	ld h,l	
	ld (hl),a	
	jr nz,l04f0h
	ld l,a	
	ld l,c	
	ld h,e	
l047dh:
	ld h,l	
	jr nz,$+104
	ld l,a	
	ld (hl),d	
	jr nz,$+82
l0484h:
	ld h,c	
	ld (hl),d	
	ld (hl),h	
l0487h:
	jr nz,$+51
	jr nz,l04cah
	jr nz,l04b1h
l048dh:
	ld c,(hl)	
	ld h,l	
	ld (hl),a	
	jr nz,l0508h
	ld l,a	
	ld l,c	
	ld h,e	
	ld h,l	
	jr nz,l04feh
	ld l,a	
l0499h:
	ld (hl),d	
	jr nz,$+82
	ld h,c	
	ld (hl),d	
	ld (hl),h	
l049fh:
	jr nz,l04d3h
	jr nz,l04e2h
l04a3h:
	jr nz,l04c9h
l04a5h:
	ld c,(hl)	
	ld h,l	
	ld (hl),a	
	jr nz,l0520h
	ld l,a	
	ld l,c	
	ld h,e	
	ld h,l	
	jr nz,l0516h
	ld l,a	
l04b1h:
	ld (hl),d	
	jr nz,l0504h
	ld h,c	
	ld (hl),d	
	ld (hl),h	
	jr nz,$+53
	jr nz,l04fah
l04bbh:
	jr nz,l04e1h
l04bdh:
	ld c,(hl)	
	ld h,l	
l04bfh:
	ld (hl),a	
	jr nz,l0538h
	ld l,a	
	ld l,c	
	ld h,e	
	ld h,l	
	jr nz,l052eh
	ld l,a	
l04c9h:
	ld (hl),d	
l04cah:
	jr nz,$+82
	ld h,c	
	ld (hl),d	
	ld (hl),h	
	jr nz,$+54
	jr nz,l0512h
l04d3h:
	jr nz,l04f9h
l04d5h:
	ld d,b	
	ld (hl),d	
l04d7h:
	ld h,l	
l04d8h:
	ld (hl),e	
	ld h,l	
	ld l,(hl)	
l04dbh:
	ld (hl),h	
	jr nz,$+117
	ld (hl),h	
	ld h,c	
	ld (hl),d	
l04e1h:
	ld (hl),h	
l04e2h:
	ld l,c	
	ld l,(hl)	
	ld h,a	
	jr nz,l055bh
	ld h,l	
	ld l,l	
	ld (hl),b	
	ld l,a	
	jr nz,l0556h
	ld (hl),e	
	jr nz,l0514h
l04f0h:
	ld c,(hl)	
	ld h,l	
	ld (hl),a	
	jr nz,$+117
	ld (hl),h	
	ld h,c	
	ld (hl),d	
	ld (hl),h	
l04f9h:
	ld l,c	
l04fah:
	ld l,(hl)	
	ld h,a	
	jr nz,l0572h
l04feh:
	ld h,l	
	ld l,l	
	ld (hl),b	
	ld l,a	
	jr nz,l0543h
l0504h:
	jr nz,l052ah
l0506h:
	ld b,(hl)	
	ld l,c	
l0508h:
	ld l,h	
	ld h,l	
	jr nz,l057ah
	ld l,a	
	ld (hl),h	
	jr nz,$+104
	ld l,a	
	ld (hl),l	
l0512h:
	ld l,(hl)	
	ld h,h	
l0514h:
	dec c	
	ld a,(bc)	
l0516h:
	inc h	
l0517h:
	ld d,e	
	ld l,a	
	ld l,(hl)	
	ld h,a	
	jr nz,l0583h
	ld l,c	
	ld l,h	
	ld h,l	
l0520h:
	jr nz,$+107
	ld (hl),e	
	jr nz,$+118
	ld l,a	
	ld l,a	
	jr nz,$+110
	ld l,a	
l052ah:
	ld l,(hl)	
	ld h,a	
	jr nz,$+118
l052eh:
	ld l,a	
	jr nz,l05a1h
	ld l,h	
	ld h,c	
	ld a,c	
	dec c	
	ld a,(bc)	
	inc h	
l0537h:
	ld b,e	
l0538h:
	ld h,c	
	ld l,(hl)	
	daa	
	ld (hl),h	
	jr nz,l05aah
	ld l,a	
	ld h,c	
	ld h,h	
	jr nz,$+120
l0543h:
	ld l,a	
	ld l,c	
	ld h,e	
	ld h,l	
	ld (hl),e	
	dec c	
	ld a,(bc)	
	inc h	
l054bh:
	ld a,(bc)	
	daa	
	ld b,d	
	ld a,c	
	ld h,l	
l0550h:
	jr nz,$+104
	ld l,a	
	ld (hl),d	
	jr nz,l05c4h
l0556h:
	ld l,a	
	ld (hl),a	
	dec c	
l0559h:
	ld a,(bc)	
	inc h	
l055bh:
	rla	
l055ch:
	jr nc,l0559h
l055eh:
	inc hl	
	ld b,0e1h
	jr l0550h
	ld (hl),e	
	ld h,b	
	dec b	
	ld a,(l055bh)
	ld (005b0h),a
	ld (005b6h),a
	ld (005bdh),a
l0572h:
	ld (005c3h),a
	ld sp,(l055ch)
l0579h:
	pop bc	
l057ah:
	xor a	
	or c	
	jp nz,l0584h
	ld sp,(00560h)
l0583h:
	ret	
l0584h:
	rr b
	jp nc,l058dh
	pop hl	
	ld (005e0h),hl
l058dh:
	rr b
	jp nc,l0596h
	pop hl	
	ld (005eeh),hl
l0596h:
	rr b
	jp nc,l059fh
	pop hl	
	ld (005feh),hl
l059fh:
	rr b
l05a1h:
	jp nc,l05a8h
	pop hl	
	ld (0060ch),hl
l05a8h:
	rr b
l05aah:
	jp nc,l05c7h
	pop hl	
	ld a,l	
	sub 000h
	ld (005e8h),a
	ld a,h	
	sub 000h
	ld (005f6h),a
	pop hl	
	ld a,l	
	sub 000h
	ld (00606h),a
	ld a,h	
	sub 000h
l05c4h:
	ld (00614h),a
l05c7h:
	rr b
	jp nc,l05d1h
	pop hl	
	ld a,l	
	ld (l05dah+1),a
l05d1h:
	jp l05dah
l05d4h:
	nop	
	ld a,000h
	jp l05dch
l05dah:
	ld b,000h
l05dch:
	ld hl,00000h
	ld de,00000h
	add hl,de	
	ld (l05dch+1),hl
	ld l,h	
	ld h,000h
	ld a,(hl)	
	ld hl,00000h
	ld de,00000h
	add hl,de	
	ld (005ebh),hl
	ld l,h	
	ld h,000h
	add a,(hl)	
	out (019h),a
	ld hl,00000h
	ld de,00000h
	add hl,de	
	ld (005fbh),hl
	ld l,h	
	ld h,000h
	ld a,(hl)	
	ld hl,00000h
	ld de,00000h
	add hl,de	
	ld (00609h),hl
	ld l,h	
	ld h,000h
	add a,(hl)	
	out (01bh),a
	dec b	
	jp nz,l05d4h
	dec c	
	jp nz,l05dah
	jp l0579h
	dec b	
	pop hl	
	ld (0060ch),hl
	rr b
	jp nc,l05c7h
	pop hl	
	ld a,l	
	sub 000h
	ld (005e8h),a
	ld a,h	
	sub 000h
	ld (005f6h),a
	pop hl	
	ld a,l	
	sub 000h
	ld (00606h),a
	ld a,h	
	sub 000h
	ld (00614h),a
	rr b
	jp nc,l05d1h
	pop hl	
	ld a,l	
	ld (l05dah+1),a
	jp l05dah
	nop	
	ld a,000h
	jp l05dch
	ld b,000h
	ld hl,00000h
	ld de,00000h
	add hl,de	
	ld (l05dch+1),hl
	ld l,h	
	ld h,000h
	ld a,(hl)	
	ld hl,00000h
	ld de,00000h
	add hl,de	
	ld (005ebh),hl
	ld l,h	
	ld h,000h
	add a,(hl)	
	out (019h),a
	ld hl,00000h
	ld de,00000h
