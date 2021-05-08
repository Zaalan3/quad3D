public _sqrtInt
public _fxMul 
public _fxDiv 
public _fxSin 
public _fxGetRecip
public _mulRecip
; for Assembly usage

public _MultiplyHLBC 
public _DivideHLBC 
public _sqrtHL

public _fixedHLmulBC
public _fixedHLdivBC
public _fixedSin
public _getReciprocal
public _mulReciprocal

extern _fixedSinTable
extern _recipTable
extern _recipTable2


;------------------------------------------------
_MultiplyHLBC:
; Performs (un)signed integer multiplication
; Inputs:
;  HL : Operand 1
;  BC : Operand 2
; Outputs:
;  HL = HL*BC
	push iy
	push	hl
	push	bc
	push	hl
	ld	iy,0
	ld	d,l
	ld	e,b
	mlt	de
	add	iy,de
	ld	d,c
	ld	e,h
	mlt	de
	add	iy,de
	ld	d,c
	ld	e,l
	mlt	de
	ld	c,h
	mlt	bc
	ld	a,c
	inc	sp
	inc	sp
	pop	hl
	mlt	hl
	add	a,l
	pop	hl
	inc	sp
	mlt	hl
	add	a,l
	ld	b,a
	ld	c,0
	lea	hl,iy+0
	add	hl,bc
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,de
	pop iy
	ret

;------------------------------------------------
_DivideHLBC:
; Performs signed interger division
; Inputs:
;  HL : Operand 1
;  BC : Operand 2
; Outputs:
;  HL = HL/BC
	ex	de,hl
	xor	a,a
	sbc	hl,hl
	sbc	hl,bc
	jp	p,.next0
	push	hl
	pop	bc
	inc	a
.next0:
	or	a,a
	sbc	hl,hl
	sbc	hl,de
	jp	m,.next1
	ex	de,hl
	inc	a
.next1:
	add	hl,de
	rra

repeat 24 
	ex	de,hl
	adc	hl,hl
	ex	de,hl
	adc	hl,hl
	add	hl,bc
	jr	c,$+4
	sbc	hl,bc
end repeat 

	ex	de,hl
	adc	hl,hl
	ret	c
	ex	de,hl
	sbc	hl,hl
	sbc	hl,de
	ret
	
	
;------------------------------------------------
;https://www.cemetech.net/forum/viewtopic.php?p=253204
; uhl = sqrt(uhl)
_sqrtInt: 
	pop bc 
	pop hl 
	push hl 
	push bc 
_sqrtHL:
	dec     sp      ; (sp) = ?
	push    hl      ; (sp) = ?uhl
	dec     sp      ; (sp) = ?uhl?
	pop     iy      ; (sp) = ?u, uiy = hl?
	dec     sp      ; (sp) = ?u?
	pop     af      ; af = u?
	or      a,a
	sbc     hl,hl
	ex      de,hl   ; de = 0
	sbc     hl,hl   ; hl = 0
	ld      bc,0C40h ; b = 12, c = 0x40
Sqrt24Loop:
	sub     a,c
	sbc     hl,de
	jr      nc,Sqrt24Skip
	add     a,c
	adc     hl,de
Sqrt24Skip:
	ccf
	rl      e
	rl      d
	add     iy,iy
	rla
	adc     hl,hl
	add     iy,iy
	rla
	adc     hl,hl
	djnz    Sqrt24Loop
	ex      de,hl
	ret
	
	
;------------------------------------------------	
;Multiplies two 8.8 fixed point numbers HL & BC
_fxMul: 
	pop de 
	pop hl 
	pop bc 
	push bc
	push hl
	push de
_fixedHLmulBC:
	ex de,hl
	ld h,e 
	ld l,c 
	mlt hl 
	ld a,h 
	ld h,d 
	ld l,b 
	mlt hl  
	bit 7,b 
	jr Z,$+5
	or a,a 
	sbc hl,de 
	bit 7,d
	jr Z,$+5 
	or a,a 
	sbc hl,bc 
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	ld l,a 
	ld a,b 
	ld b,d 
	ld d,a 
	mlt de 
	mlt bc 
	add hl,de 
	add hl,bc 
	ret 


;------------------------------------------------
; fixed point division of HL by BC
_fxDiv: 
	pop de 
	pop hl 
	pop bc 
	push bc
	push hl
	push de
_fixedHLdivBC: 
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	ex	de,hl
	xor	a,a
	sbc	hl,hl
	sbc	hl,bc
	jp	p,next0
	push	hl
	pop	bc
	inc	a
next0:
	or	a,a
	sbc	hl,hl
	sbc	hl,de
	jp	m,next1
	ex	de,hl
	inc	a
next1:
	add	hl,de
	rra
loop:

repeat 24 
	ex	de,hl
	adc	hl,hl
	ex	de,hl
	adc	hl,hl
	add	hl,bc
	jr	c,$+4
	sbc	hl,bc
end repeat
 
	ex	de,hl
	adc	hl,hl
	ret	c
	ex	de,hl
	sbc	hl,hl
	sbc	hl,de
	ret

;------------------------------------------------
; returns fixed point sine of l
_fxSin: 
	pop bc 
	pop hl 
	push hl 
	push bc
_fixedSin: 
	ld a,l 	
	or a,a 
	sbc hl,hl 
	ld l,a 
	res 7,l
	ld bc,_fixedSinTable
	add hl,bc
	ld b,(hl)
	or a,a 
	sbc hl,hl
	ld l,b
	add hl,hl
	rla  
	ret nc		; return if angle is positive, so it doesn't need to be negated
	ex de,hl 
	or a,a
	sbc hl,hl 
	sbc hl,de 
	ret 
	
;------------------------------------------------
; returns the 0.16 reciprocal of 16-bit integer in HL 
_fxGetRecip: 
	pop bc
	pop hl 
	push hl 
	push bc
_getReciprocal:
	dec hl
	ld a,h 
	tst a,0F0h 
	jr nz,recipdiv ; do simple division if value is higher 0x0FFF 
	tst a,0Fh 
	jr nz,recip2	; for hl>256
	add hl,hl 
	ld de,_recipTable 
	add hl,de 
	ld de,(hl) 
	ex.sis de,hl
	ret 
recip2: 
	ld de,256
	or a,a 
	sbc hl,de 
	ld de,_recipTable2
	add hl,de 
	ld a,(hl) 
	or a,a 
	sbc hl,hl 
	ld l,a 
	ret 

recipdiv: 
	ex hl,de 
	xor a,a 
	ld hl,65536
rloop: 
	inc a 
	or a,a 
	sbc hl,de 
	jr nc,rloop
	dec a 
	or a,a 
	sbc hl,hl 
	ld l,a 
	ret 
	
	
;------------------------------------------
; multiplies signed 16-bit HL with 0.16 bit BC , 16 bit result in HL
_fxMulRecip: 
	pop de 
	pop hl 
	pop bc 
	push bc 
	push hl 
	push de
_mulReciprocal: 
	ld a,h 
	bit 7,h 
	jr z,$+8
	ex de,hl 
	or a,a 
	sbc hl,hl 
	sbc hl,de 
	
	ex af,af'
	ld d,b 
	ld e,l 
	ld l,b 
	ld b,h 
	mlt hl 
	mlt de 
	mlt bc 
	ld a,l 
	add a,b 
	jr nc,$+3 
	inc h 
	
	add a,d 
	jr nc,$+3 
	inc h 
	
	ld l,a 
	ex af,af' 
	rlca 
	ret nc 
	
	ex de,hl 
	or a,a 
	sbc hl,hl 
	sbc hl,de 
	ret 