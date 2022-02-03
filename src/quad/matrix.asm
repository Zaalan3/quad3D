public _qdTransformVertices
public _projectVertices
public _projectSprites
public _setCameraPosition

public _matrixRoutine
public _matrixRoutine_len
public _matrixRoutine_src

extern canvas_width
extern canvas_height
extern canvas_offset

extern _qdVertexCache
extern _qdCameraMatrix 

extern _getReciprocal 
extern _MultiplyHLBC
extern _recipTable

extern _qdActiveSprite
extern _qdNumSprites

extern _ZinvLUT

; outcodes 
outTop equ 01000b
outBottom equ 0100b
outLeft equ 0010b
outRight equ 0001b 
outOOB equ $FF

m00 equ iy+0 
m01 equ iy+2
m02 equ iy+4
m10 equ iy+6
m11 equ iy+8
m12 equ iy+10
m20 equ iy+12
m21 equ iy+14
m22 equ iy+16
cx equ iy+18 
cy equ iy+20 
cz equ iy+22

x equ ix+0 
y equ ix+2 
z equ ix+4 

xs equ iy+0
ys equ iy+2 
depth equ iy+4 
outcode equ iy+5
rs1 equ iy+6 
rs2 equ iy+7

; sprite defines 

spriteX equ ix+0 
spriteY equ ix+2
spriteZ equ ix+4 
spriteU equ ix+6
spriteV equ ix+7 
spriteHW equ ix+8 
spriteHH equ ix+9 
sdepth equ ix+10 
sxs equ ix+11 
sxe equ ix+13
sys equ ix+15 
sye equ ix+17 



mulRow:=$E10010 

;ix = vertex 
;iy = matrix row 
;destroys b' & iy 
mulRowPosition_src:
	exx 
	ld b,3 
.loop: 
	exx
	ld de,(ix+0) 
	ld bc,(iy+0) 
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
	add.sis hl,sp
	ld.sis sp,hl
	exx 
	lea ix,ix+2 
	lea iy,iy+2 
	djnz .loop
	lea ix,ix-6
	pop iy
	exx 
	ret 
mulRowPosition_len:= $ - mulRowPosition_src
assert mulRowPosition_len <= 64

mulRowVertex_src: 
	ld b,3 
.loop: 
	ld c,(ix+0) 
	ld de,(iy+0) 
	ld h,e 
	ld l,c 
	mlt hl 
	ld l,h 
	ld h,0 
	bit 7,d 
	jr Z,$+10
	ld a,c 
	neg  
	ld h,a 
	ld e,c 
	mlt de
	add hl,de
	add.sis hl,sp 
	ld.sis sp,hl 
	inc ix 
	lea iy,iy+2 
	djnz .loop 
	lea ix,ix-3 
	pop iy 
	ret 
mulRowVertex_len:= $ - mulRowVertex_src
assert mulRowVertex_len <= 64	

;---------------------------------------------------------	
_setCameraPosition: 
	push ix 
	ld iy,_qdCameraMatrix
	
	;load smc bytes
	ld de,mulRow
	ld hl,mulRowPosition_src
	ld bc,mulRowPosition_len 
	ldir 
	lea hl,m00
	ld (SMCLoadM00),hl
	lea hl,m10
	ld (SMCLoadM10),hl
	lea hl,m20
	ld (SMCLoadM20),hl
	
	ld a,$e3 
	ld mb,a 
	or a,a
	sbc hl,hl 
	ld.sis (SMCLoadX - $e30000),hl 
	ld.sis (SMCLoadY - $e30000),hl 
	ld.sis (SMCLoadZ - $e30000),hl 
	
	ld ix,offx ; calculate M*<-128,-128,-128> for object offsets 
	ld de,-128 
	ld (ix),de 
	ld (ix+2),de 
	ld (ix+4),de 
	call _matrixRow0Multiply
	push hl 
	call _matrixRow1Multiply
	push hl
	call _matrixRow2Multiply
	pop de
	pop bc 
	ld (ix),bc 
	ld (ix+2),de 
	ld (ix+4),hl 
	
	lea ix,cx  ; M*camera position 
	call _matrixRow0Multiply
	ex de,hl
	or a,a 
	sbc hl,hl 
	sbc hl,de 
	push hl 
	call _matrixRow1Multiply
	ex de,hl 
	or a,a 
	sbc hl,hl 
	sbc hl,de 
	push hl 
	call _matrixRow2Multiply
	ex de,hl 
	or a,a 
	sbc hl,hl
	sbc hl,de 
	pop de 
	pop bc 
	ld.sis (SMCLoadX - $e30000),bc
	ld.sis (SMCLoadY - $e30000),de
	ld.sis (SMCLoadZ - $e30000),hl
	ld (tx),bc
	ld (ty),de
	ld (tz),hl
	
	ld a,$d0
	ld mb,a 
	pop ix
	ret

tx: rb 3
ty: rb 3
tz: rb 3

offx: rb 2
offy: rb 2
offz: rb 3

;---------------------------------------------------------
_qdTransformVertices: 
	push ix 
	ld ix,6 
	add ix,sp 
	
	ld iy,(ix+0)
	;load smc bytes
	ld de,mulRow
	ld hl,mulRowVertex_src
	ld bc,mulRowVertex_len
	ldir 
	lea hl,m00
	ld (SMCLoadM00),hl
	lea hl,m10
	ld (SMCLoadM10),hl
	lea hl,m20
	ld (SMCLoadM20),hl
	
	ld a,$e3 
	ld mb,a 
	or a,a
	sbc hl,hl 
	ld.sis (SMCLoadX - $e30000),hl 
	ld.sis (SMCLoadY - $e30000),hl 
	ld.sis (SMCLoadZ - $e30000),hl
	ld a,$d0
	ld mb,a 
	
	ld iy,(ix+6) 
	ld hl,(ix+9) 
	ld ix,(ix+3) 
	ld de,1
.loop:
	exx 
	call _matrixRow0Multiply
	ld (iy+0),l  
	call _matrixRow1Multiply
	ld (iy+1),l 
	call _matrixRow2Multiply
	ld (iy+2),l  
	lea ix,ix+3 ; next vertex 
	lea iy,iy+3 
	exx 
	or a,a 
	sbc hl,de
	jr nz,.loop
	pop ix
	ret 

;---------------------------------------------------------	

	; iy = object pointer
_projectVertices: 
	push iy 
	push bc
	
	lea ix,iy+0
	ld iy,_qdCameraMatrix
	
	; load position multiply routine
	ld de,mulRow
	ld hl,mulRowPosition_src
	ld bc,mulRowPosition_len 
	ldir 
	
	ld a,$e3 
	ld mb,a 
	or a,a
	sbc hl,hl
	ld.sis (SMCLoadX - $e30000),hl
	ld.sis (SMCLoadY - $e30000),hl
	ld.sis (SMCLoadZ - $e30000),hl
	
	; transform object position 
	call _matrixRow0Multiply
	ld de,(tx)
	ld bc,(offx) 
	add hl,de
	add hl,bc
	ld.sis (SMCLoadX - $e30000),hl 
	
	call _matrixRow1Multiply
	ld de,(ty)
	ld bc,(offy)
	add hl,de
	add hl,bc
	ld.sis (SMCLoadY - $e30000),hl
	
	call _matrixRow2Multiply
	ld de,(tz)
	ld bc,(offz)
	add hl,de
	add hl,bc
	ld.sis (SMCLoadZ - $e30000),hl
	ld a,$d0
	ld mb,a 
	
	; load vertex multiply routine
	ld de,mulRow
	ld hl,mulRowVertex_src
	ld bc,mulRowVertex_len
	ldir 
	
	ld de,(ix+6)  ; de = vertex count
	ld ix,(ix+10) ; ix = vertex pointer
	
	ld iy,_qdVertexCache 
	ex.sis de,hl 
	ld de,1
	jp projloop
	
;---------------------------------------------------------	
virtual at $E308E0
_matrixRoutine:

projloop: 	
	exx 
	; get z'
	call _matrixRow2Multiply
	ld (depth),l 
	
	xor a,a 
	cp a,l 
	jq Z,.earlyZ
	cp a,h  
	jq Z,.skipEarlyZ
.earlyZ: 
	ld (outcode),$FF ; out of range 
	jq .skipVert
.skipEarlyZ: 	
	dec l 
	add hl,hl  
	ld de,_ZinvLUT
	add hl,de 
	ld hl,(hl) 
	push hl
	push hl
	
	; height/2 - y'*f/z'
	call _matrixRow1Multiply 
	pop bc 
	call mulHLBC
	ex de,hl
	ld hl,canvas_height/2
	or a,a 
	sbc hl,de
	ld (ys),l 
	ld (ys+1),h 
	
	;offset y value for easier bounds checking
	ld de,canvas_offset
	add hl,de 
	; out of bounds = y<0 or y>255 
	xor a,a 
	cp a,h 
	jr Z,.topY
	pop bc 
	ld (outcode),$FF 
	jr .skipVert
	; top outcode  
.topY: 
	ld h,a 
	ld a,l
	cp a,canvas_offset 
	rl h	; set if x less than canvas offset 
	; bottom outcode 
	cp a,canvas_height+canvas_offset
	ccf 
	ld a,h  
	rla
	ex af,af'
	
	call _matrixRow0Multiply
	; 256/2 + x'*f/z'
	;de*bc
	pop bc 
	call mulHLBC
	ld de,256/2
	add hl,de
	ld (xs),l
	ld (xs+1),h
	
	; out of bounds = x<0 or x>255 
	xor a,a 
	cp a,h 
	jr Z,.leftX
	ld (outcode),$FF 
	jr .skipVert
	; left outcode 
.leftX:
	ex af,af'	
	ld h,a 
	ld a,l
	cp a,canvas_offset
	rl h	; set if x less than 
	; right outcode 
	cp a,canvas_width+canvas_offset
	ccf  ; carry clear if x greater than, so invert carry
	rl h 
	
	ld (outcode),h  
	; copy UV for sprites
	
.skipVert: 
	exx 
	lea ix,ix+3 ; next vertex 
	lea iy,iy+8 ; next cache entry  
	or a,a 
	sbc hl,de 	; count-- 
	jq nz,projloop 
	
	pop bc
	pop iy
	ret
	
;---------------------------------------------------------	
; in: b = sprite count 
_projectSprites: 
	ld ix,_qdActiveSprite ; ix = pointer to current sprite 
	ld iy,_qdVertexCache  ; iy = vertex cache pointer 
	push bc 
	ld c,b 
spriteloop: 
	exx 
	; get z' 
	call _matrixRow2Multiply
	ld (sdepth),l 
	; skip if z<=0
	xor a,a 
	cp a,l 
	jq Z,.skipSprite
	cp a,h  
	jq nz,.skipSprite
	; fetch f/z 
	dec l 
	add hl,hl  
	ld de,_ZinvLUT
	add hl,de 
	ld hl,(hl) ;hl = f/z 
	push hl  
	
	call _matrixRow0Multiply
	; 256/2 + x'*f/z'
	;de*bc
	pop bc 
	push bc 
	call mulHLBC
	ld de,256/2
	add hl,de
	
	;xe = xs + w*f/2z 
	;xs -= (w*f/2z)/2
	pop bc ; bc = f/z * 1/2 
	push bc 
	srl b 
	rr c 
	push hl ; push xs 
	ld a,(spriteHW)
	; bc*a 
	ld h,c 
	ld l,a 
	mlt hl 
	ld l,h 
	ld h,0 
	ld c,a 
	mlt bc 
	add hl,bc 
	ex de,hl 
	pop hl
	add hl,de
	; skip if xe < canvas_offset 
	ld bc,canvas_offset
	or a,a 
	sbc.sis hl,bc 
	jq m,.skipSpritePop
	jq Z,.skipSpritePop
	add hl,bc 
	ld (sxe),hl 	
	or a,a 
	sbc hl,de 
	or a,a 
	sbc hl,de ;hl = xs - (w*f/z)/2 
	; skip if xs >= width+offset 
	ld de,canvas_width+canvas_offset-1 
	or a,a 
	sbc hl,de 
	bit 7,h 
	jq Z,.skipSpritePop
	add hl,de 
	ld (sxs),l
	ld (sxs+1),h
	

	; ys = height/2 - y' 
	call _matrixRow1Multiply 
	pop bc 
	push bc ; bc = f/z
	call mulHLBC
	ex de,hl
	ld hl,canvas_height/2
	or a,a 
	sbc hl,de
	
	;ye = ys + h*f/2z 
	;ys -= (h*f/2z)/2
	pop bc ; bc = f/z * 1/2 
	srl b 
	rr c
	push hl ; push ys 
	ld a,(spriteHH)
	; bc*a 
	ld h,c 
	ld l,a 
	mlt hl 
	ld l,h 
	ld h,0 
	ld c,a 
	mlt bc 
	add hl,bc 
	ex de,hl 
	pop hl
	add hl,de
	; skip if ye <= 0 
	bit 7,h
	jq nz,.skipSprite
	ld (sye),l 	
	ld (sye+1),h 	
	or a,a 
	sbc hl,de 
	or a,a 
	sbc hl,de ;hl = ys - (h*f/z)/2 
	; skip if ys >= height
	ld de,canvas_height
	or a,a 
	sbc hl,de 
	bit 7,h 
	jq Z,.skipSprite
	add hl,de 
	ld (sys),l 
	ld (sys+1),h 
	
.next: 	
	lea ix,ix+19 ; next sprite 
	exx 
	dec c  ; count-- 
	jq nz,spriteloop
	pop bc 
	ret 
	
.skipSpritePop: 
	pop hl 
.skipSprite: 
	ld (sdepth),$FF 
	jq .next 
	

	
	; hl = de*bc (bc is fixed point with bc>0)
mulHLBC:
	ex de,hl
	ld h,d
	ld l,b 
	mlt hl 
	ld a,l 
	bit 7,d 
	jr Z,$+3 
	sub a,c  
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
	
;---------------------------------------------------------
_matrixRow0Multiply:
	push iy
	ld.sis sp,0 
SMCLoadX:= $ - 2 
	ld iy,0
SMCLoadM00:= $ - 3	
	jp mulRow

;---------------------------------------------------------
_matrixRow1Multiply:
	push iy 
	ld.sis sp,0 
SMCLoadY:= $ - 2 
	ld iy,0 
SMCLoadM10:= $ - 3	
	jp mulRow
	
;---------------------------------------------------------
_matrixRow2Multiply:
	push iy 
	ld.sis sp,0 
SMCLoadZ:= $ - 2 
	ld iy,0 
SMCLoadM20:= $ - 3	
	jp mulRow
	
assert $<$E30B00
load _matrixroutine_data: $-$$ from $$
_matrixRoutine_len := $-$$
end virtual
_matrixRoutine_src:
	db _matrixroutine_data
	