section .text 

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
extern bilerp8
extern bilerp8.len 
extern bilerp8_clipped
extern bilerp8_clipped.len

extern flat16
extern flat16.len 
extern flat16_clipped
extern flat16_clipped.len
extern flat32
extern flat32.len
extern flat32_clipped
extern flat32_clipped.len
extern flat8
extern flat8.len 
extern flat8_clipped
extern flat8_clipped.len


public shaderVloop
public shaderVloopIncB

extern canvas_height

shaderUloop:=$E10010   ; $E10010 or $E30B00 depending on OS revision

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

xlen equ iy+2 
ylen equ iy+3 
ustart equ iy+6
vstart equ iy+9
delta equ iy+12

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
; shader byte format: 
; 0nnnnhdc 
; n = shader type 
; h = half size 
; d = double pixels 
; c = clipped/unclipped 

shaderTable: 
	shaderEntry bilerp16,4 
	shaderEntry bilerp16_clipped,8
	shaderEntry bilerp32,8 
	shaderEntry bilerp32_clipped,8
	shaderEntry bilerp8,2 
	shaderEntry bilerp8_clipped,4
	rb 10 

	shaderEntry flat16,4 
	shaderEntry flat16_clipped,4
	shaderEntry flat32,8
	shaderEntry flat32_clipped,8
	shaderEntry flat8,2
	shaderEntry flat8_clipped,2
	rb 10 
	
;-----------------------------------------
; bc = texture 
; de = canvas 
; hl = u 
; spl = delta 
; b' = xlen / 2 
; c' = ylen 
; hl' = v 
; ixh = x0 
; ixl = xlen / 2 
; iy = ustart 
; Sprite Shader
spriteRoutine:
.yloop: 
	exx 
	ld b,a  
	inc d 
	ld e,ixh 
	lea hl,iy+0
	exx 
.xloop:
	exx 
repeat 2 
	ld c,h
	ld a,(bc)
	or a,a 
	jr Z,$+3  
	ld (de),a 
	inc e 
	add hl,sp
end repeat 	
	exx 
	djnz .xloop
	ld b,ixl 
	add hl,sp
	ld a,h 
	dec c  
	jr nz,.yloop 
	jp exitShader 
endShader spriteRoutine 
	

;-----------------------------------
;input: 
; iy = pointer to face 
; i = next face in cache
; register state after below
; hl = y 
; de = dy 
; b = u counter 
; c = v counter 
; hl' = x 
; de' = canvas pointer 
; bc' = texture pointer 
; spl = dx 
; sps = yi 
; ix = xi 
; iyl = light 
; iyh = u0
_callShader: 
	; load shader to $E10010 
	ld l,(shader) 
	ld a,$FF 
_currentShader:=$-1
	bit 7,l ; sprite shader = $80+
	jq nz,spriteShader 
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
	ld a,(shader) 
	ld (_currentShader),a 
	bit 2,a 
	jr Z,$+4  
	srl c 
	
	ld ix,_shaderRoutine
	ld hl,(ax) 
	ld (ix + SMCloadAX-_shaderRoutine),hl
	
	ld hl,(ay)
	ld (ix + SMCloadAY-_shaderRoutine),hl
	
	ld hl,(cx) 
	ld (ix + SMCloadCX-_shaderRoutine),hl  
	ld (ix + SMCloadCX+2-_shaderRoutine),$d4
	
	ld hl,(cy) 
	ld (ix + SMCloadCY-_shaderRoutine),hl 
	
	ld de,(by) ; de = dy
	
	ld h,(y0) 	;  sps = yi 
	ld l,0 
	ld.sis sp,hl
	exx  
	
	ld de,$D40000	;de' = screen ptr 
	
	ld hl,(bx) 	; spl = dx
	ld sp,hl 
	
	ld a,(x0) 	;ix = xi
	ld ixl,e 
	ld ixh,a 
	ld l,e		; hl' = x 
	ld h,a 
	
	ld bc,$D48000	;bc' = texture ptr 
	ld a,(v0) 
	add a,b 
	ld b,a 
	ld a,(u0) 	
	ld c,a 
	
	ld a,(light) 
	ld iyl,a
	ld iyh,c 
	
dispatch: 
	exx 
	jp shaderUloop
	
	
; register state after the following: 
; bc = texture 
; de = canvas 
; hl = u 
; spl = delta 
; b' = xlen / 2 
; c' = ylen 
; hl' = v 
; ixh = x0 
; ixl = xlen / 2 
; iy = u0 
spriteShader: 
	cp a,l 
	jq Z,.skipLoad 
	ld a,l 
	ld (_currentShader),a 
	ld hl,spriteRoutine
	ld de,shaderUloop
	ld bc,spriteRoutine.len 
	ldir 
.skipLoad:
	ld (SMCloadSP),sp 
	ld bc,$D40000
	ld de,$D40000 
	ld d,(y0) 
	dec d
	ld e,(x0)
	ld ixh,e 
	ld hl,(delta)
	ld sp,hl 
	exx 
	ld de,(ustart) 
	ld b,(xlen)
	srl b  
	ld ixl,b 
	ld c,(ylen) 
	ld hl,(vstart)
	ld a,$80 
	add a,h 
	ld h,a 
	ld iyl,e 
	ld iyh,d 
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
shaderVloopIncB: 
	exx 
	inc b
	exx 
	
shaderVloop: 
	dec c 
	jr nz,skipExit
exitShader:
	ld sp,0 
	SMCloadSP:=$-3 
	ret 
	
skipExit:
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
	exx
	ld de,0
SMCloadCX:=$-3
	add ix,de 
	lea hl,ix+0 
	inc b	 ; v++ 
	ld c,iyh
	exx   
	jp shaderUloop 	
	
assert $ < $E308E0
load _shaderRoutine_data: $-$$ from $$
_shaderRoutine_len := $-$$
end virtual
_shaderRoutine_src:
	db _shaderRoutine_data
