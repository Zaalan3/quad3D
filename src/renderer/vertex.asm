public _transformVertices
public _projectVertices
public _setCameraPosition

public _matrixRoutine
public _matrixroutine_len
public _matrixroutine_src

extern canvas_width
extern canvas_height

extern _vertexCache
extern _cameraMatrix 

extern _getReciprocal 
extern _MultiplyHLBC
extern _recipTable


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


_setCameraPosition: 
	push ix 
	ld ix,6 
	add ix,sp 
	ld ix,(ix+0)
	ld iy,_cameraMatrix
	call _loadMatrix
	or a,a 
	sbc hl,hl 
	ld (SMCLoadX),hl 
	ld (SMCLoadY),hl 
	ld (SMCLoadZ),hl 
	call _matrixRow0Multiply
	ex de,hl 
	or a,a 
	sbc hl,hl 
	sbc hl,de 
	ld (cx),hl 
	call _matrixRow1Multiply
	ex de,hl 
	or a,a 
	sbc hl,hl 
	sbc hl,de
	ld (cy),hl
	call _matrixRow2Multiply
	ex de,hl 
	or a,a 
	sbc hl,hl 
	sbc hl,de
	ld (cz),l 
	ld (cz+1),h
	pop ix
	ret

_transformVertices: 
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
	ld bc,(ix+9) 
	ld ix,(ix+3) 
	
loop:
	exx 
	call _matrixRow0Multiply
	ld (iy+0),hl 
	call _matrixRow1Multiply
	ld (iy+2),hl 
	call _matrixRow2Multiply
	ld (iy+4),l 
	ld (iy+5),h 
	lea ix,ix+6 
	lea iy,iy+6 
	exx 
	dec bc 
	or a,a 
	sbc hl,hl 
	sbc hl,bc 
	jr nz,loop
	pop ix
	ret 
	

_projectVertices: 
	pop hl 
	pop bc ; vertex count
	pop iy 
	push iy
	push bc 
	push hl 
	push ix
	lea ix,iy+0 ; ix = vertex pointer  
	ld iy,_cameraMatrix ; iy = camera pointer
	call _loadMatrix
	ld hl,(cx) 
	ld (SMCLoadX),hl 
	ld hl,(cy) 
	ld (SMCLoadY),hl
	ld hl,(cz) 
	ld (SMCLoadZ),hl
	ld iy,_vertexCache 
	
projloop: 	
	exx 
	call _matrixRow2Multiply
	ld (depth),l 
	
	ld a,h 
	or a,a 
	jr Z,$+10 ; skip if z out of range
	ld (outcode),$FF ; out of range 
	jq skipVert
	
	ld a,l 
	or a,a ; skip if zero
	jr nz,$+10 
	ld (outcode),$FF ; out of range 
	jq skipVert
	
	dec hl 
	add hl,hl
	ld de,_recipTable
	add hl,de 
	ld de,(hl) 
	ex.sis de,hl
	; focal length = 128
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	push hl 
	inc sp 
	pop hl 
	dec sp 
	push hl
	push hl
	
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
	ex de,hl
	ld hl,256/2
	add hl,de
	ld (xs),hl
	
	xor a,a 
	cp a,h 
	jr Z,$+11
	ld (outcode),$FF 
	pop bc 
	jq skipVert
	; left outcode 
	ld h,a 
	cp a,256-canvas_width
	rl h 	; set if x less than 
	; right outcode 
	cp a,canvas_width 
	ccf 
	rl h 
	ld a,h 
	ex af,af' 
	
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
	
	;top outcode 
	ex af,af' 
	ld b,h 
	rl b 
	rla 
	;bottom outcode 
	ld de,canvas_height
	or a,a 
	sbc hl,de 
	jp m,$+6
	scf 
	rla 
	
	ld (outcode),a 
	
skipVert: 
	exx 
	lea ix,ix+6 
	lea iy,iy+6 
	dec bc 
	or a,a 
	sbc hl,hl 
	sbc hl,bc 
	jp nz,projloop 
	
	pop ix 
	ret
	
	
virtual at $E30880
_matrixRoutine:	
; loads matrix smc bytes ( except translation column )
; HL = matrix pointer
_loadMatrix: 
	ld hl,(m00)
	ld (SMCloadM00),hl
	ld hl,(m01)
	ld (SMCloadM01),hl
	ld hl,(m02)
	ld (SMCloadM02),hl
	ld hl,(m10)
	ld (SMCloadM10),hl
	ld hl,(m11)
	ld (SMCloadM11),hl
	ld hl,(m12)
	ld (SMCloadM12),hl
	ld hl,(m20)
	ld (SMCloadM20),hl
	ld hl,(m21)
	ld (SMCloadM21),hl
	ld hl,(m22)
	ld (SMCloadM22),hl
	ret 	
;---------------------------------------------------------
	; matrix row 0 multiply
	; hl = result
	; sp = matrix pointer
	; ix = vector pointer
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
	ld de,0 
SMCLoadX:=$-3 
	add.sis hl,de 
	ret 


;---------------------------------------------------------
	; matrix row 1 multiply
	; hl = result
	; sp = matrix pointer
	; ix = vector pointer
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
	ld de,0 
SMCLoadY:=$-3 
	add.sis hl,de
	ret 
	
;---------------------------------------------------------
	; matrix row 2 multiply
	; hl = result
	; sp = matrix pointer
	; ix = vector pointer
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
	ld de,0 
SMCLoadZ:=$-3 
	add.sis hl,de
	ret 
	
assert $<$E30BFF
load _matrixroutine_data: $-$$ from $$
_matrixroutine_len := $-$$
end virtual
_matrixroutine_src:
	db _matrixroutine_data