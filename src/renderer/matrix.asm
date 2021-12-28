public _qdTransformVertices
public _projectVertices
public _projectSprites
public _setCameraPosition

public _matrixRoutine
public _matrixRoutine_len
public _matrixRoutine_src

public _matrixRow0Multiply
public _matrixRow1Multiply
public _matrixRow2Multiply

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

; loads matrix smc bytes ( except translation column )
; IY = matrix pointer
_loadMatrix: 
	ld b,$93 	; sub a,e 
	ld c,0 		; nop 
	
	ld hl,(m00)
	ld (SMCloadM00),hl
	bit 7,h 
	jr Z,$+5
	ld a,b 
	jr $+3 
	ld a,c 
	ld (SMCsignM00),a 
	
	ld hl,(m01)
	ld (SMCloadM01),hl
	bit 7,h 
	jr Z,$+5
	ld a,b 
	jr $+3 
	ld a,c 
	ld (SMCsignM01),a 
	
	ld hl,(m02)
	ld (SMCloadM02),hl
	bit 7,h 
	jr Z,$+5
	ld a,b 
	jr $+3 
	ld a,c 
	ld (SMCsignM02),a 
	
	ld hl,(m10)
	ld (SMCloadM10),hl
	bit 7,h 
	jr Z,$+5
	ld a,b 
	jr $+3 
	ld a,c 
	ld (SMCsignM10),a 
	
	ld hl,(m11)
	ld (SMCloadM11),hl
	bit 7,h 
	jr Z,$+5
	ld a,b 
	jr $+3 
	ld a,c 
	ld (SMCsignM11),a 
	
	ld hl,(m12)
	ld (SMCloadM12),hl
	bit 7,h 
	jr Z,$+5
	ld a,b 
	jr $+3 
	ld a,c 
	ld (SMCsignM12),a 
	
	ld hl,(m20)
	ld (SMCloadM20),hl
	bit 7,h 
	jr Z,$+5
	ld a,b 
	jr $+3 
	ld a,c 
	ld (SMCsignM20),a 
	
	ld hl,(m21)
	ld (SMCloadM21),hl
	bit 7,h 
	jr Z,$+5
	ld a,b 
	jr $+3 
	ld a,c 
	ld (SMCsignM21),a
	
	ld hl,(m22)
	ld (SMCloadM22),hl
	bit 7,h 
	jr Z,$+5
	ld a,b 
	jr $+3 
	ld a,c 
	ld (SMCsignM22),a 
	
	ret
	
;---------------------------------------------------------	
_setCameraPosition: 
	push ix 
	ld iy,_qdCameraMatrix
	call _loadMatrix
	lea ix,cx	; offset of camera position
	or a,a 
	sbc hl,hl 
	ld (SMCLoadX),hl 
	ld (SMCLoadY),hl 
	ld (SMCLoadZ),hl 
	; translate object position
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
	ld (cx),bc 
	ld (cy),de
	ld (cz),l 
	ld (cz+1),h
	ld (SMCLoadX),bc
	ld (SMCLoadY),de
	ld (SMCLoadZ),hl
	pop ix
	ret

	
;---------------------------------------------------------
_qdTransformVertices: 
	push ix 
	ld ix,6 
	add ix,sp 
	
	ld iy,(ix+0)
	call _loadMatrix
	ld hl,(cx) 
	ld (SMCLoadX),hl 
	ld hl,(cy) 
	ld (SMCLoadY),hl
	ld hl,(cz) 
	ld (SMCLoadZ),hl
	
	ld iy,(ix+6) 
	ld hl,(ix+9) 
	ld ix,(ix+3) 
	ld bc,1
loop:
	exx 
	call _matrixRow0Multiply
	push hl  
	call _matrixRow1Multiply
	push hl  
	call _matrixRow2Multiply
	pop de 
	pop bc 
	ld (iy+0),bc 
	ld (iy+2),de 
	ld (iy+4),l 
	ld (iy+5),h 
	lea ix,ix+6 
	lea iy,iy+6 
	exx 
	or a,a 
	sbc hl,bc
	jr nz,loop
	pop ix
	ret 

;---------------------------------------------------------
; projects sprite vertices
_projectSprites: 
	push iy 
	push bc 
	ld a,8
	ld (SMCSizeVertex),a ; billboard size different then regular vertex
	
	ld ix,_qdActiveSprite 	
	ld iy,_qdVertexCache
	or a,a 
	sbc hl,hl 
	ld a,(_qdNumSprites)
	ld l,a
	ld de,1
	jp projloop
	
_projectVertices: 
	push iy 
	push bc
	
	ld a,6 
	ld (SMCSizeVertex),a
	lea ix,iy+0
	ld iy,_qdCameraMatrix
	or a,a 
	sbc hl,hl
	ld (SMCLoadX),hl
	ld (SMCLoadY),hl
	ld (SMCLoadZ),hl
	call _matrixRow0Multiply
	ld de,(cx) 
	add hl,de
	ld (SMCLoadX),hl 
	call _matrixRow1Multiply
	ld de,(cy)
	add hl,de
	ld (SMCLoadY),hl
	call _matrixRow2Multiply
	ld de,(cz)
	add hl,de
	ld (SMCLoadZ),hl
	
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
	call _matrixRow2Multiply
	ld (depth),l 
	 
	bit 7,l 
	jq Z,skipEarlyZ
earlyZ:
	ld (outcode),$FF ; out of range 
	jq skipVert
skipEarlyZ: 	
	add hl,de
	dec l 
	add hl,hl  
	ld de,_ZinvLUT
	add hl,de 
	ld hl,(hl) 
	push hl
	push hl
	
	; height/2 - y'*f/z'
	call _matrixRow1Multiply 
	ex de,hl 
	pop bc 
	;de*bc 
	ld h,e 
	ld l,c 
	mlt hl 
	ld a,h 
	ld h,d 
	ld l,b 
	mlt hl  
	bit 7,d 
	jr Z,$+5
	or a,a 
	sbc hl,bc 
	ld h,l
	ld l,a 
	ld a,b 
	ld b,d 
	ld d,a 
	mlt de 
	mlt bc 
	add hl,de 
	add hl,bc
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
	jr Z,topY
	pop bc 
	ld (outcode),$FF 
	jr skipVert
	; top outcode  
topY: 
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
	ex de,hl
	pop bc 
	ld h,e 
	ld l,c 
	mlt hl 
	ld a,h 
	ld h,d 
	ld l,b 
	mlt hl  
	bit 7,d 
	jr Z,$+5
	or a,a 
	sbc hl,bc 
	ld h,l
	ld l,a 
	ld a,b 
	ld b,d 
	ld d,a 
	mlt de 
	mlt bc 
	add hl,de 
	add hl,bc
	ld de,256/2
	add hl,de
	ld (xs),l
	ld (xs+1),h
	
	; out of bounds = x<0 or x>255 
	xor a,a 
	cp a,h 
	jr Z,leftX
	ld (outcode),$FF 
	jr skipVert
	; left outcode 
leftX:
	ex af,af'	
	ld h,a 
	ld a,l
	cp a,canvas_offset
	rl h	; set if x less than 
	; right outcode 
	cp a,canvas_width+canvas_offset
	ccf  
	rl h 
	
	ld (outcode),h  
	; copy UV for sprites
	ld hl,(ix+6) 
	ld (iy+6),hl
	
skipVert: 
	exx 
	lea ix,ix+6 
SMCSizeVertex:=$-1
	lea iy,iy+8 
	or a,a 
	sbc hl,de 
	jq nz,projloop 
	
	pop bc
	pop iy
	ret
	


;---------------------------------------------------------
_matrixRow0Multiply:
	ld de,(x)
	ld bc,0 
SMCloadM00:=$-3
	ld h,d 
	ld l,b 
	mlt hl
	ld a,l 
	bit 7,d 
	jr Z,$+3 
	sub a,c  
	sub a,e
SMCsignM00:=$-1
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
	ld.sis sp,hl
	
	ld de,(y)
	ld bc,0 
SMCloadM01:=$-3
	ld h,d 
	ld l,b 
	mlt hl
	ld a,l 
	bit 7,d 
	jr Z,$+3 
	sub a,c  
	sub a,e
SMCsignM01:=$-1
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
	
	ld de,(z)
	ld bc,0 
SMCloadM02:=$-3
	ld h,d 
	ld l,b 
	mlt hl
	ld a,l 
	bit 7,d 
	jr Z,$+3 
	sub a,c  
	sub a,e
SMCsignM02:=$-1
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
	ld de,0 
SMCLoadX:=$-3 
	add.sis hl,de 
	ret 


;---------------------------------------------------------
_matrixRow1Multiply:
	ld de,(x)
	ld bc,0 
SMCloadM10:=$-3
	ld h,d 
	ld l,b 
	mlt hl
	ld a,l 
	bit 7,d 
	jr Z,$+3 
	sub a,c  
	sub a,e
SMCsignM10:=$-1
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
	ld.sis sp,hl
	
	ld de,(y)
	ld bc,0 
SMCloadM11:=$-3
	ld h,d 
	ld l,b 
	mlt hl
	ld a,l 
	bit 7,d 
	jr Z,$+3 
	sub a,c  
	sub a,e
SMCsignM11:=$-1
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
	
	ld de,(z)
	ld bc,0 
SMCloadM12:=$-3
	ld h,d 
	ld l,b 
	mlt hl
	ld a,l 
	bit 7,d 
	jr Z,$+3 
	sub a,c  
	sub a,e
SMCsignM12:=$-1
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
	ld de,0 
SMCLoadY:=$-3 
	add.sis hl,de
	ret 
	
;---------------------------------------------------------
_matrixRow2Multiply:
	ld de,(x)
	ld bc,0 
SMCloadM20:=$-3
	ld h,d 
	ld l,b 
	mlt hl
	ld a,l 
	bit 7,d 
	jr Z,$+3 
	sub a,c  
	sub a,e
SMCsignM20:=$-1
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
	ld.sis sp,hl 
	
	ld de,(y)
	ld bc,0 
SMCloadM21:=$-3
	ld h,d 
	ld l,b 
	mlt hl
	ld a,l 
	bit 7,d 
	jr Z,$+3 
	sub a,c  
	sub a,e
SMCsignM21:=$-1
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
	
	ld de,(z)
	ld bc,0 
SMCloadM22:=$-3
	ld h,d 
	ld l,b 
	mlt hl
	ld a,l 
	bit 7,d 
	jr Z,$+3 
	sub a,c  
	sub a,e
SMCsignM22:=$-1
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
	ld de,0 
SMCLoadZ:=$-3 
	add.sis hl,de
	ret 
	
assert $<$E30B30
load _matrixroutine_data: $-$$ from $$
_matrixRoutine_len := $-$$
end virtual
_matrixRoutine_src:
	db _matrixroutine_data
	