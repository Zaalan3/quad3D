section .text 

public _sqrtInt
public _fxMul 
public _fxDiv 
public _fxSin 
; for Assembly usage

public _MultiplyHLBC 
public _DivideHLBC 
public _sqrtHL

public _fixedHLmulBC
public _fixedHLdivBC
public _fixedSin

public mulAngle 

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
; signed fixed point division of HL by BC
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
	add hl,hl	; fallthrough to normal division routine
	
;------------------------------------------------
_DivideHLBC:
; Performs signed integer division
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
;Multiplies two signed 8.8 fixed point numbers HL & BC
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
	ld a,l 
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
; returns 4.12 fixed point sine of hl(range 0..1023)
_fxSin: 
	pop bc 
	pop hl 
	push hl 
	push bc
_fixedSin:
	ld a,h 
	and a,00000011b
	ld h,a
	bit 1,h 
	jr nz,.negative 
	bit 0,h 
	jr z,.nosymmetry
	ex de,hl 
	ld hl,512 
	or a,a 
	sbc.sis hl,de 
.nosymmetry:
	ex.sis de,hl
	ld hl,_fixedSinTable
	add hl,de
	add hl,de
	ld hl,(hl) 
	ret 
.negative: 
	res 1,h 
	call _fixedSin
	ex de,hl 
	or a,a 
	sbc hl,hl 
	sbc hl,de 
	ret 
	
; 4.12 fixed multiply hl*bc
mulAngle:
	ex de,hl
	ld l,e 
	ld h,c 
	mlt hl 
	ld a,h 
	
	ld h,d 
	ld l,b 
	mlt hl 
	bit 7,b 
	jr z,$+6  
	or a,a 
	sbc.sis hl,de 
	bit 7,d 
	jr z,$+6 
	or a,a 
	sbc.sis hl,bc 
	
repeat 8 
	add hl,hl
end repeat 
	ld l,a 
	
	ld a,d 
	ld d,b 
	ld b,a 
	mlt de 
	mlt bc 
	add hl,de 
	add hl,bc 
	
repeat 4 
	add hl,hl 
end repeat 
	
	dec sp 
	push hl 
	inc sp 
	pop hl 
	
	ret
	