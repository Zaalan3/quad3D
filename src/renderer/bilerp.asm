public _bilerp32
public _bilerpShader
public _bilerp_len
public _bilerp_src

extern canvas_height
extern canvas_width 

shader equ iy+0
light equ iy+1	
u0 equ iy+2
v0 equ iy+3
x0 equ iy+4
y0 equ iy+6
ay equ iy+8
ax equ iy+10
by equ iy+12
bx equ iy+14
cy equ iy+16
cx equ iy+18
	
_bilerp32: 
	pop hl 
	pop iy 
	push iy 
	push hl 
	
	ld hl,(ax) 
	ld (SMCloadAX),hl
	ld hl,(ay) 
	ld (SMCloadAY),hl
	ld hl,(cx) 
	ld (SMCloadCX),hl
	ld hl,(cy) 
	ld (SMCloadCY),hl
	
	ld a,(u0) 
	ld (SMCloadU),a 
	ld hl,$D40000 
	ld l,a 
	ld a,(v0) 
	add a,$80
	ld h,a
	ld de,$D40000 
	ld bc,$8FF 
	exx 
	
	ld de,(by) 
	ld bc,(bx) 
	ld hl,(x0) 
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	
	push hl
	push hl 
	ld hl,(y0) 
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	pop iy 

	push hl 	
	exx
	jp _bilerpShader
	
	
virtual at $E30800
_bilerpShader:
	ld a,32 
vloop:
	ex af,af'
	;TODO: rewrite uloop to use hl' instead of iy
uloop: 
repeat 4 
	exx 
	add hl,de 
	add iy,bc
	ld a,h
	exx  
	ld d,a
	rlca 
	jr c,$+6
	ld e,iyh
	ld a,(hl) 
	ld (de),a 
	inc hl 
end repeat
	djnz uloop 
	exx 
	
	ld hl,0
SMCloadAY:=$-3 
	add hl,de 
	ex de,hl 
	
	ld hl,0
SMCloadAX:=$-3 	
	add hl,bc 
	push hl 
	pop bc 
	
	pop hl 
	pop iy 
	push de 
	ld de,0 
SMCloadCY:=$-3 
	add hl,de 
	ld de,0 
SMCloadCX:=$-3 
	add iy,de
	pop de 
	push iy 
	push hl  
	exx 
	ld bc,$8FF
	ld l,0
SMCloadU:=$-1 
	inc h 
	ex af,af' 
	dec a 
	jp nz,vloop
	
	pop hl 
	pop hl  
	ret 
	
assert $ < $E30940
load _bilerp_data: $-$$ from $$
_bilerp_len := $-$$
end virtual
_bilerp_src:
	db _bilerp_data