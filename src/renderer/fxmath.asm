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

extern _fixedSinTable


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
	ld h,d 
	ld l,b 
	mlt hl 
	ld a,h 
	bit 7,d 
	jr Z,$+3 
	sub a,c
	bit 7,b 
	jr Z,$+3 
	sub a,e 
	ld h,e 
	ld l,c 
	mlt hl
	ld l,h  
	ld h,a 
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
	rla  
	ret nc		; return if angle is positive, so it doesn't need to be negated
	ex de,hl 
	or a,a
	sbc hl,hl 
	sbc hl,de 
	ret 
	
	
	
	