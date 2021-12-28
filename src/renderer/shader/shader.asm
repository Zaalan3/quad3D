
public _callShader 
public _shaderRoutine
public _shaderRoutine_len
public _shaderRoutine_src
public _currentShader

extern bilerp16
extern bilerp16.len 
extern bilerp16_clipped
extern bilerp16_clipped.len
extern bilerp32
extern bilerp32.len
extern bilerp32_clipped
extern bilerp32_clipped.len

extern bilerp16_flat
extern bilerp16_flat.len 
extern bilerp16_flat_clipped
extern bilerp16_flat_clipped.len
extern bilerp32_flat
extern bilerp32_flat.len
extern bilerp32_flat_clipped
extern bilerp32_flat_clipped.len

public shaderVloop

extern canvas_height

shaderUloop:=$E10010 

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


;shader macro definitions 

macro shaderEntry? shader,ppl 	; shader = shader name , ppl = pixels per loop
	emit 3: shader 
	db shader.len
	db ppl 	
end macro 

;place at end of shader 
macro endShader shader 
	shader.len:=$-shader 
	assert shader.len <= 64 
end macro 

;-----------------------------------------
; Shader lookup table 

shaderTable: 
	shaderEntry bilerp16,4 
	shaderEntry bilerp16_clipped,4
	shaderEntry bilerp32,8 
	shaderEntry bilerp32_clipped,8

	shaderEntry bilerp16_flat,4 
	shaderEntry bilerp16_flat_clipped,4
	shaderEntry bilerp32_flat,8
	shaderEntry bilerp32_flat_clipped,8
	

;-----------------------------------
; register state after below, consistent for all shaders
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


; iy = cached face pointer
_callShader: 
	; load shader to $E10010 
	ld l,(shader) 
	ld a,$FF 
_currentShader:=$-1 
	sub a,l 
	ld h,5 
	mlt hl
	ld de,shaderTable
	add hl,de 
	or a,a 
	jr nz,loadShader  ; skip shader if already loaded 
	inc hl
	inc hl
	inc hl
	inc hl
	ld a,(hl) 	; fetch ppl for shader again 
	jr cont 
loadShader:
	ld de,(hl) 
	inc hl
	inc hl
	inc hl
	ld bc,0
	ld c,(hl) 
	inc hl 
	ld a,(hl) 
	ex de,hl 
	ld de,shaderUloop
	ldir 	
	
cont:
	; load variables and SMC bytes 
	ld (SMCloadSP),sp	
	ld c,16 
	ld b,a 		; b = u count
	
	ld hl,(ax) 
	ld (SMCloadAX),hl
	ld hl,(ay) 
	ld (SMCloadAY),hl
	
	;fixed point conversion (256*n/16) = 16*n 
	ld hl,(cx) 
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	ld (SMCloadCX),hl  
	ld a,$d4 
	ld (SMCloadCX+2),a 
	
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
	
	ld h,(y0) 	;  sps = yi 
	ld l,0 
	ld.sis sp,hl
	exx 
	ld a,(x0) 	;ix = xi 
	ld ixl,0 
	ld ixh,a 
	
	ld bc,$D48000	;bc = texture ptr 
	ld a,(v0) 
	add a,b 
	ld b,a 
	ld c,(u0) 
	
	ld de,$D40000	;de = screen ptr 
	
	ld hl,(bx) 	; spl = dx
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	ld sp,hl 
	lea hl,ix+0
	
	ld a,(shader) 
	ld (_currentShader),a
	ld a,(light) 
	ld i,a
	
dispatch: 
	exx 
	jp shaderUloop
	
;------------------------------

virtual at $E30880
_shaderRoutine:

; called after each line drawn to update deltas and counters for next line.
; xi += cx 
; x = xi 
; yi += cy
; y = yi 
; dy += ay 
; dx += ax 
shaderVloop: 
	exx 
	ld de,0
SMCloadCX:=$-3
	add ix,de 
	lea hl,ix+0 
	inc b	 ; v++ 
	ld a,c 
	sub a,16 ; reset to u0
	ld c,a 
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
	dec c 
	jp nz,shaderUloop 
	ld sp,0 
SMCloadSP:=$-3 
	ret 
	
	
assert $ < $E308E0
load _shaderRoutine_data: $-$$ from $$
_shaderRoutine_len := $-$$
end virtual
_shaderRoutine_src:
	db _shaderRoutine_data
