
public _callShader 
public _bilerpShader
public _bilerp_len
public _bilerp_src

shaderRoutine:=$E10010 

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
next equ iy+20

macro shaderEntry? shader,length,size 
	emit 3: shader 
	db length
	db size 
end macro 

shaderTable: 
	shaderEntry bilerp16,bilerp16_len,16 
	shaderEntry bilerp16_clipped,bilerp16_clipped_len,16
	shaderEntry bilerp32,bilerp32_len,32 
	shaderEntry bilerp32_clipped,bilerp32_clipped_len,32
	shaderEntry bilerp16_transparent,bilerp16_transparent_len,16 
	shaderEntry bilerp16_transparent_clipped,bilerp16_transparent_clipped_len,16
	shaderEntry bilerp32_transparent,bilerp32_transparent_len,32 
	shaderEntry bilerp32_transparent_clipped,bilerp32_transparent_clipped_len,32 
	
;-----------------------------------
virtual at $E30800
_bilerpShader:

; iy = cached face pointer
_callShader: 
	; load shader to $E10010 
	ld l,(shader) 
	ld h,5 
	mlt hl
	ld de,shaderTable
	add hl,de 
	ld de,(hl) 
	ld bc,3 
	add hl,bc 
	ld c,(hl) 
	inc hl 
	ld a,(hl) 
	ex de,hl 
	ld de,shaderRoutine
	ldir 
	; load variables
	ld (SMCloadSP),sp
	ld c,a		; c = v count 
	srl a 
	srl a 
	ld b,a 		; b = u count
	ld (SMCloadCount),a
	srl a 
	srl a 
	ld (SMCloadLineCount),a 
	ex af,af'
	
	ld hl,(ax) 
	ld (SMCloadAX),hl
	ld hl,(ay) 
	ld (SMCloadAY),hl
	ld hl,(cx) 
	ld a,h 
	ld (SMCloadCXH),a
	ld a,l 
	ld (SMCloadCXL),a
	ld hl,(cy) 
	ld (SMCloadCY),hl

	ld h,(y0) 	; hl = y 
	ld l,0 
	ld.sis sp,hl 	; sps = yi
	ld de,(by)
	exx 
	ld a,(x0) 
	ld ix,0 
	ld ixh,a 
	ld bc,$D48000
	ld a,(v0) 
	add a,b 
	ld b,a 
	ld c,(u0) 
	ld de,$D40000
	ld hl,(bx) 
	ld sp,hl 
	lea hl,ix+0
	
	ld iy,(light)
	exx 
	jp shaderRoutine
	
; hl = y 
; de = dy 
; b = u counter 
; c = v counter 
; hl' = x 
; de' = screen pointer 
; bc' = texture pointer 
; spl = dx 
; sps = yi 
; iyh = u0 
; iyl = light
; ix = xi 


bilerp_vloop: 
	exx 
	ld d,0 
SMCloadCXH:=$-1 
	ld e,0 
SMCloadCXL:=$-1
	add ix,de 
	lea hl,ix+0 
	ex af,af' 
	dec a 
	jr nz,$+5
	ld a,0 
SMCloadLineCount:=$-1 
	inc b 
	ex af,af' 
	ld c,iyh
	exx 
	ld hl,0 
SMCloadAY:=$-3 
	add hl,de 
	ex de,hl 
	ld hl,0 
SMCloadAX:=$-3 
	add hl,sp 
	ld sp,hl 
	ld hl,0 
SMCloadCY:=$-3 
	add.sis hl,sp 
	ld.sis sp,hl 
	ld b,0 
SMCloadCount:=$-1 
	dec c 
	jp nz,shaderRoutine 
	ld sp,0 
SMCloadSP:=$-3 
	ret 
	
assert $ < $E308D0
load _bilerp_data: $-$$ from $$
_bilerp_len := $-$$
end virtual
_bilerp_src:
	db _bilerp_data
	
;-----------------------------------
bilerp16: 
repeat 4 
	ld a,h 
	exx 
	ld d,a 
	ld e,h 
	ld a,(bc) 
	ld (de),a 
	inc c 
	add hl,sp 
	exx 
	add hl,de 
end repeat 
	djnz bilerp16
	jp bilerp_vloop
bilerp16_len:=$-bilerp16
assert bilerp16_len <= 64 

;-----------------------------------
bilerp16_clipped:
repeat 4
	ld a,h 
	exx 
	ld d,a 
	rlca 
	jr c,$+5
	ld e,h 
	ld a,(bc) 
	ld (de),a 
	inc c 
	add hl,sp 
	exx 
	add hl,de 
end repeat
	djnz bilerp16_clipped
	jp bilerp_vloop
bilerp16_clipped_len:=$-bilerp16_clipped
assert bilerp16_clipped_len <= 64

;-----------------------------------
bilerp16_transparent: 
repeat 4
	ld a,h 
	exx 
	ld d,a 
	ld e,h 
	ld a,(bc) 
	or a,a 
	jr Z,$+3
	ld (de),a 
	inc c 
	add hl,sp 
	exx 
	add hl,de 
end repeat
	djnz bilerp16_transparent
	jp bilerp_vloop
bilerp16_transparent_len:=$-bilerp16_transparent
assert bilerp16_transparent_len <= 64 	
;-----------------------------------
bilerp16_transparent_clipped: 
	sla b
.loop:
repeat 2
	ld a,h 
	exx 
	ld d,a 
	rlca 
	jr c,$+8
	ld e,h 
	ld a,(bc) 
	or a,a 
	jr Z,$+3
	ld (de),a 
	inc c 
	add hl,sp 
	exx 
	add hl,de 
end repeat
	djnz bilerp16_transparent_clipped.loop
	jp bilerp_vloop
bilerp16_transparent_clipped_len:=$-bilerp16_transparent_clipped
assert bilerp16_transparent_clipped_len <= 64 

;-----------------------------------
bilerp32: 
repeat 2 
	ld a,h 
	exx 
	ld d,a 
	ld e,h 
	ld a,(bc) 
	ld (de),a 
	add hl,sp 
	exx 
	add hl,de
	ld a,h 
	exx 
	ld d,a 
	ld e,h 
	ld a,(bc) 
	inc c 
	ld (de),a 
	add hl,sp 
	exx 
	add hl,de
end repeat	
	djnz bilerp32
	jp bilerp_vloop 
bilerp32_len:=$-bilerp32
assert bilerp32_len <= 64 

;-----------------------------------
bilerp32_clipped:
repeat 2
	ld a,h 
	exx 
	ld d,a 
	rlca 
	jr c,$+5 
	ld e,h 
	ld a,(bc)
	ld (de),a 
	add hl,sp 
	exx 
	add hl,de 
	ld a,h 
	exx 
	ld d,a 
	rlca 
	jr c,$+5 
	ld e,h 
	ld a,(bc)
	ld (de),a 
	inc c 
	add hl,sp 
	exx 
	add hl,de
end repeat 
	djnz bilerp32_clipped
	jp bilerp_vloop 
bilerp32_clipped_len:=$-bilerp32_clipped
assert bilerp32_clipped_len <= 64 

;-----------------------------------
bilerp32_transparent: 
repeat 2
	ld a,h 
	exx 
	ld d,a 
	ld e,h 
	ld a,(bc)
	or a,a 
	jr Z,$+3
	ld (de),a 
	add hl,sp 
	exx 
	add hl,de
	ld a,h 
	exx 
	ld d,a 
	ld e,h 
	ld a,(bc) 
	inc c 
	or a,a 
	jr Z,$+3
	ld (de),a 
	add hl,sp 
	exx 
	add hl,de
end repeat
	djnz bilerp32_transparent
	jp bilerp_vloop 
bilerp32_transparent_len:=$-bilerp32_transparent
assert bilerp32_transparent_len <= 64 


;-----------------------------------
bilerp32_transparent_clipped:
	sla b
.loop:
	ld a,h 
	exx 
	ld d,a 
	rlca 
	jr c,$+8 
	ld e,h 
	ld a,(bc)
	or a,a 
	jr Z,$+3
	ld (de),a 
	add hl,sp 
	exx 
	add hl,de
	ld a,h 
	exx 
	ld d,a 
	rlca 
	jr c,$+8
	ld e,h 
	ld a,(bc) 
	or a,a 
	jr Z,$+3
	ld (de),a 
	inc c 
	add hl,sp 
	exx 
	add hl,de
	djnz bilerp32_transparent_clipped.loop
	jp bilerp_vloop 
	
bilerp32_transparent_clipped_len:=$-bilerp32_transparent_clipped
assert bilerp32_transparent_clipped_len <= 64 