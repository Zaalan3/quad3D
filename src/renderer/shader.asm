
public _callShader 
public _bilerpShader
public _bilerp_len
public _bilerp_src
public _currentShader

extern canvas_height

shaderRoutine:=$E10010 

shader equ iy+0
light equ iy+1	
u0 equ iy+2
v0 equ iy+3
x0 equ iy+4
y0 equ iy+5
ay equ iy+6
ax equ iy+8
by equ iy+10
bx equ iy+12
cy equ iy+14
cx equ iy+16
next equ iy+18

macro shaderEntry? shader,length,size 
	emit 3: shader 
	db length
	db size 
end macro 

shaderTable: 
	shaderEntry bilerp16,bilerp16_len,4 
	shaderEntry bilerp16_clipped,bilerp16_clipped_len,4
	shaderEntry bilerp32,bilerp32_len,8 
	shaderEntry bilerp32_clipped,bilerp32_clipped_len,8
	
	shaderEntry bilerp16_transparent,bilerp16_transparent_len,4 
	shaderEntry bilerp16_transparent_clipped,bilerp16_transparent_clipped_len,8
	shaderEntry bilerp32_transparent,bilerp32_transparent_len,8 
	shaderEntry bilerp32_transparent_clipped,bilerp32_transparent_clipped_len,8
	
	shaderEntry bilerp16_flat,bilerp16_flat_len,4 
	shaderEntry bilerp16_flat_clipped,bilerp16_flat_clipped_len,4
	shaderEntry bilerp32_flat,bilerp32_flat_len,8
	shaderEntry bilerp32_flat_clipped,bilerp32_flat_clipped_len,8
	
_currentShader: 
	db $FF
	
;-----------------------------------
virtual at $E30800
_bilerpShader:

; iy = cached face pointer
_callShader: 
	; load shader to $E10010 
	ld l,(shader) 
	ld a,(_currentShader)
	sub a,l 
	ld h,5 
	mlt hl
	ld de,shaderTable
	add hl,de 
	or a,a 
	jr nz,loadShader 
	ld bc,4 
	add hl,bc 
	ld a,(hl) 
	jr cont 
loadShader:
	ld de,(hl) 
	ld bc,3 
	add hl,bc 
	ld c,(hl) 
	inc hl 
	ld a,(hl) 
	ex de,hl 
	ld de,shaderRoutine
	ldir 	
cont:
	; load variables
	ld (SMCloadSP),sp
	ld c,16 
	ld b,a 		; b = u count
	ld (SMCloadCount),a
	
	ld hl,(ax) 
	ld (SMCloadAX),hl
	ld hl,(ay) 
	ld (SMCloadAY),hl
	ld hl,(cx) 
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	ld a,h 
	ld (SMCloadCXH),a
	ld a,l 
	ld (SMCloadCXL),a
	ld hl,(cy) 
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	ld (SMCloadCY),hl

	ld hl,(by)
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	ex de,hl ; de = dy
	
	ld h,(y0) 	; hl = y 
	ld l,0 
	ld.sis sp,hl 	; sps = yi
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
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	ld sp,hl 
	lea hl,ix+0
	
	ld a,(shader) 
	ld (_currentShader),a
	
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
	inc b
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
	
	
assert $ < $E308E0
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
	cp a,canvas_height
	jr nc,$+5
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
repeat 2
	ld a,h 
	exx 
	ld d,a 
	cp a,canvas_height 
	jr nc,$+8
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
	djnz bilerp16_transparent_clipped
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
	inc e 
	ld (de),a 
	inc d
	ld (de),a 
	dec e
	ld (de),a 
	inc c
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
	cp a,canvas_height 
	jr nc,$+12
	ld d,a
	ld e,h 
	ld a,(bc)
	ld (de),a 
	inc e 
	ld (de),a 
	inc d
	ld (de),a 
	dec e
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
	jr Z,$+9
	ld (de),a 
	inc e 
	ld (de),a 
	inc d
	ld (de),a 
	dec e
	ld (de),a 
	inc c
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
repeat 2
	ld a,h 
	exx 
	cp a,canvas_height 
	jr nc,$+15
	ld d,a 
	ld e,h 
	ld a,(bc)
	or a,a 
	jr Z,$+9
	ld (de),a 
	inc e 
	ld (de),a 
	inc d
	ld (de),a 
	dec e
	ld (de),a 
	inc c
	add hl,sp 
	exx 
	add hl,de
end repeat
	djnz bilerp32_transparent_clipped
	jp bilerp_vloop 
	
bilerp32_transparent_clipped_len:=$-bilerp32_transparent_clipped
assert bilerp32_transparent_clipped_len <= 64 

;-----------------------------------
bilerp16_flat: 
repeat 4 
	ld a,h 
	exx 
	ld d,a 
	ld e,h 
	ld a,iyl 
	ld (de),a 
	add hl,sp 
	exx 
	add hl,de 
end repeat 
	djnz bilerp16_flat
	jp bilerp_vloop
bilerp16_flat_len:=$-bilerp16_flat
assert bilerp16_flat_len <= 64 

;-----------------------------------
bilerp16_flat_clipped: 
repeat 4 
	ld a,h 
	exx 
	ld d,a 
	cp a,canvas_height 
	jr nc,$+6 
	ld e,h 
	ld a,iyl 
	ld (de),a 
	add hl,sp 
	exx 
	add hl,de 
end repeat 
	djnz bilerp16_flat_clipped
	jp bilerp_vloop
bilerp16_flat_clipped_len:=$-bilerp16_flat_clipped
assert bilerp16_flat_clipped_len <= 64 

;-----------------------------------
bilerp32_flat: 
repeat 2 
	ld a,h 
	exx 
	ld d,a 
	ld e,h 
	ld a,iyl 
	ld (de),a 
	inc e 
	ld (de),a 
	inc d
	ld (de),a 
	dec e
	ld (de),a 
	add hl,sp 
	exx 
	add hl,de
end repeat
	djnz bilerp32_flat
	jp bilerp_vloop 
bilerp32_flat_len:=$-bilerp32_flat
assert bilerp32_flat_len <= 64

;-----------------------------------
bilerp32_flat_clipped: 
repeat 2 
	ld a,h 
	exx 
	cp a,canvas_height
	jr nc,$+13
	ld d,a 
	ld e,h 
	ld a,iyl 
	ld (de),a 
	inc e 
	ld (de),a 
	inc d
	ld (de),a 
	dec e
	ld (de),a 
	add hl,sp 
	exx 
	add hl,de
end repeat
	djnz bilerp32_flat_clipped
	jp bilerp_vloop 
bilerp32_flat_clipped_len:=$-bilerp32_flat_clipped
assert bilerp32_flat_clipped_len <= 64