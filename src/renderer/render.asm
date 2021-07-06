public _renderObjects

public _renderFaces
public _renderFaces_src
public _renderFaces_len

extern _activeSprite
extern _numSprites
extern _activeObject
extern _numObjects
extern _projectVertices
extern _projectSprites
extern _vertexCache
extern _faceBucket
extern _faceCache
extern _callShader
extern _clearCanvas
extern _setCameraPosition
extern _currentShader

extern _ZinvLUT

shader equ iy+0
light equ iy+1	
u0 equ iy+2
v0 equ iy+3
vt0 equ iy+4
vt1 equ iy+6
vt2 equ iy+8
vt3 equ iy+10
	
numFaces equ ix+0 
cachePointer equ ix+3 
bucketMin equ ix+6 
bucketMax equ ix+9

x0 equ ix+12
y0 equ ix+14
depth0 equ ix+16 
outcode0 equ ix+17
x1 equ ix+18
y1 equ ix+20
depth1 equ ix+22
outcode1 equ ix+23
x2 equ ix+24
y2 equ ix+26
depth2 equ ix+28
outcode2 equ ix+29
x3 equ ix+30 
y3 equ ix+32
depth3 equ ix+34
outcode3 equ ix+35 

facePointer equ ix+36

spriteX equ ix+39 
spriteY equ ix+41
spriteDepth equ ix+43 
spriteOutcode equ ix+44  
spriteU equ ix+45
spriteV equ ix+46

tshader equ iy+0
tlight equ iy+1
tu0 equ iy+2
tv0 equ iy+3
tx0 equ iy+4
ty0 equ iy+6
tay equ iy+8
tax equ iy+10
tby equ iy+12
tbx equ iy+14
tcy equ iy+16
tcx equ iy+18
tnext equ iy+20

_renderObjects: 
	push ix
	ld ix,$E10010
	; init face buckets 
	ld hl,_faceBucket
	ld de,_faceBucket+1 
	ld (hl),$FF 
	ld bc,2047 
	ldir 
	; init variables 
	ld (numFaces),bc 
	ld (bucketMax),bc 
	ld bc,1024
	ld (bucketMin),bc 
	ld bc,_faceCache 
	ld (cachePointer),bc
	
	; load camera matrix
	call _setCameraPosition
	
; process sprites 
processSprites:
	ld a,(_numSprites) 
	or a,a 
	jq Z,processObjects 
	ld b,a 
	ld iy,_vertexCache	
	call _projectSprites
	ld ix,$E10010
	ld (facePointer),iy 
	ld iy,(cachePointer)
spriteloop: 
	exx 
	ld hl,(facePointer)
	lea de,spriteX 
	ld bc,8 
	ldir 
	ld (facePointer),hl 
	
	ld a,(spriteOutcode) 
	cp a,$FF 	; skip if out of bounds 
	jq Z,skipSprite 
	tst a,0101b 	; skip if vertex is to the right of or below the screen
	jq nz,skipSprite 
	and a,0010b 
	jr Z,findWidth  
	inc b 
	ld hl,(spriteY) 
	ld de,16 
	add.sis hl,de
	jq nc,skipSprite
findWidth:
; compute width and height
	or a,a 
	sbc hl,hl 
	ld l,(spriteDepth) 
	add hl,hl 
	ld de,_ZinvLUT
	add hl,de 
	ld e,(hl)
	inc hl 
	ld d,(hl) 
	ex.sis de,hl
	; size = 8*f/z
	add hl,hl
	add hl,hl
	add hl,hl
	push hl 
	inc sp 
	pop hl 
	dec sp 
	ex de,hl 
	ld hl,(spriteY) 
	add.sis hl,de 
	xor a,a
	cp a,h 
	ld a,b 
	jr z,$+4 
	or a,1
	ld hl,-17 ;if size > 16  
	add hl,de 
	jr c,$+4 
	add a,2 
	add a,4 
	ld (tshader),a 
; set face entry 
	ld (tbx),de 
	ld (tcy),de 
	
	ld hl,(spriteU) 
	ld (tu0),hl 
	ld hl,(spriteX) 
	ld (tx0),hl 
	ld a,(spriteY+1) 
	ld (ty0+1),a
	xor a,a 
	sbc hl,hl 
	ld (tay),hl 
	ld (tax+1),hl 
	ld (tby+1),a 
	ld (tcx),hl
	
	; find depth bucket 
	ld l,(spriteDepth) 
	add hl,hl 
	add hl,hl
	; update min and max buckets 
	ex de,hl 
	ld hl,(bucketMax) 
	or a,a 
	sbc hl,de 
	jr nc,$+5 
	ld (bucketMax),de 
	
	ld hl,(bucketMin) 
	or a,a 
	sbc hl,de 
	jr c,$+5 
	ld (bucketMin),de 
	; update this face's bucket
	ld hl,_faceBucket
	add hl,de
	add hl,de
	ld de,(hl) 
	ld (tnext),de 
	ld de,(numFaces) 
	ld (hl),e 
	inc hl 
	ld (hl),d 
	inc de 	
	ld (numFaces),de
	
	; next face 
	lea iy,iy+22 
	
skipSprite:
	exx
	dec b 
	jq nz,spriteloop
	
	ld (cachePointer),iy
;----------------------------------------
; process 3D objects 
processObjects:
	ld a,(_numObjects)
	or a,a 
	jq Z,return
	ld b,a
	ld iy,_activeObject 
	
	ld hl,-3 
	add hl,sp 
	ld (StoreSP),hl
objectloop: 
	pea iy+3 
	ld iy,(iy)
	call _projectVertices
cacheFaces: 
	ld de,(iy+11) ;face count
	ld iy,(iy+16) ; face pointer 
	ld ix,$E10010
	ld hl,1 
	ex.sis hl,de
faceloop:
	exx 
	; fetch vertices 
	ld hl,(vt0) 
	add hl,hl
	add hl,hl 
	add.sis hl,hl
	ld sp,_vertexCache
	add hl,sp 
	lea de,x0 
	ld bc,6 
	ldir 
	
	ld hl,(vt1) 
	add hl,hl
	add hl,hl 
	add.sis hl,hl
	add hl,sp 
	ld c,6 
	ldir
	
	ld hl,(vt2) 
	add hl,hl
	add hl,hl 
	add.sis hl,hl 
	add hl,sp 
	ld c,6 
	ldir
	
	ld hl,(vt3) 
	add hl,hl
	add hl,hl 
	add.sis hl,hl 
	add hl,sp
	ld c,6 
	ldir
	
	; load outcodes 
	ld b,(outcode0)
	ld c,(outcode1)
	ld d,(outcode2)
	ld e,(outcode3)
	; skip face if (out0&out1&out2&out3) != 0 
	ld a,b 
	and a,c 
	and a,d 
	and a,e 
	jq nz,skipFace 
	; skip face if (out0|out1|out2|out3) = $FF 
	ld a,b 
	or a,c 
	or a,d 
	or a,e 
	cp a,$FF 
	jq z,skipFace 
	; shader is clipped if BOTTOM|TOP
	ld b,(shader) 
	and a,3 
	jr Z,$+3
	inc b 
	
	; swap iy 
	ld hl,(light)
	ld (facePointer),iy 
	ld iy,(cachePointer)
	
	ld (tshader),b 
	; copy light,u0 & v0,x0 & y0 
	ld (tlight),hl 
	
	; by = y3 - y0 
	ld hl,(y3) 
	ld de,(y0) 
	or a,a 
	sbc hl,de 
	ld (tby),hl 
	
	; cy = y1 - y0 
	ld hl,(y1) 
	or a,a 
	sbc hl,de 
	ld (tcy),hl 
	
	;bx = x3 - x0 
	ld hl,(x3) 
	ld de,(x0) 
	or a,a 
	sbc hl,de 
	ld (tbx),l
	ld (tbx+1),h
	
	;cx = x1 - x0 
	ld hl,(x1) 
	or a,a 
	sbc hl,de 
	ld (tcx),hl
			
	; area = (x2-x0)*(cy-by) + (y2-y0)*(bx-cx)
	ld hl,(x2) 
	or a,a 
	sbc hl,de 
	ex de,hl
	ld hl,(tcy) 
	ld bc,(tby) 
	or a,a 
	sbc hl,bc
	;hl*de 
	ld b,l 
	ld c,e 
	ld l,e 
	ld e,b  
	mlt hl 
	mlt bc 
	mlt de 
	ld a,b 
	add a,l 
	add a,e 
	ld h,a 
	ld l,c 
	ld sp,hl  
	
	ld hl,(y2) 
	ld de,(y0)
	or a,a 
	sbc hl,de 
	ex de,hl
	ld hl,(tbx) 
	ld bc,(tcx) 
	or a,a 
	sbc hl,bc
	;hl*de 
	ld b,l 
	ld c,e 
	ld l,e 
	ld e,b  
	mlt hl 
	mlt bc 
	mlt de 
	ld a,b 
	add a,l 
	add a,e 
	ld h,a 
	ld l,c 
	add hl,sp 
	; skip if area >= 0 
	bit 7,h 
	jq z,loadFacePointer 
	
	; if area<-512  then use chunky shader
	ld de,512 
	add.sis hl,de 
	jq c,$+6 
	set 1,(tshader)
	
	; ay = y0 - y1 - y3 + y2 = y2 - by - y1 
	ld hl,(y2) 
	ld de,(tby)
	or a,a 
	sbc hl,de 
	ld de,(y1) 
	or a,a 
	sbc hl,de 
	ld (tay),hl
	
	; ax = x0 - x1 - x3 + x2 = x2 - bx - x1 
	ld hl,(x2) 
	ld de,(tbx)
	or a,a 
	sbc hl,de 
	ld de,(x1) 
	or a,a 
	sbc hl,de 
	ld (tax),l 
	ld (tax+1),h
	
	; find sum of distances (8.2 average)  
	or a,a 
	sbc hl,hl 
	ex de,hl 
	or a,a 
	sbc hl,hl
	ld l,(depth0) 
	ld e,(depth1) 
	add hl,de 
	ld e,(depth2) 
	add hl,de 
	ld e,(depth3) 
	add hl,de 
	dec hl	

	; update min and max buckets 
	ex de,hl
	ld hl,(bucketMax) 
	or a,a 
	sbc hl,de 
	jr nc,$+5 
	ld (bucketMax),de 
	
	ld hl,(bucketMin) 
	or a,a 
	sbc hl,de 
	jr c,$+5 
	ld (bucketMin),de 
	; update this face's bucket
	ld hl,_faceBucket
	add hl,de
	add hl,de
	ld bc,(hl) 
	ld (tnext),bc 
	ld de,(numFaces) 
	ld (hl),e 
	inc hl 
	ld (hl),d 
	inc de 	
	ld (numFaces),de
	
	ld hl,(x0) 
	ld (tx0),hl 
	ld a,(y0+1) 
	ld (ty0+1),a
	
	lea iy,iy+22 
	ld (cachePointer),iy 
loadFacePointer: 
	ld iy,(facePointer) 
skipFace: 
	lea iy,iy+12 
	exx 
	or a,a 
	sbc hl,de 
	jq nz,faceloop 
	ld sp,0
StoreSP:=$-3 
	pop iy 
	dec b 
	jq nz,objectloop
	jp _renderFaces
	
virtual at $E30B00
; iterates through face buckets and renders faces
_renderFaces: 
	ld a,$FF 
	ld (_currentShader),a
	ld hl,(bucketMax) 
	ld de,(bucketMin) 
	or a,a 
	sbc hl,de 
	jq c,return
	push hl 
	add hl,de 
	ex de,hl
	ld ix,_faceBucket
	add ix,de 
	add ix,de
	
	ld de,(ix+0)
	push ix-2 
bucketloop:
	bit 7,d 
	jr nz,skipbucket 
	ld h,22 
	ld l,d 
	ld d,h 
	mlt hl 
	mlt de 
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,de 
	ld iy,_faceCache
	add iy,de 
	ld de,(iy+20) 
	push de 
	call _callShader 
	pop de 
	jq bucketloop

skipbucket:
	
	pop ix 
	pop hl 
	ld de,(ix+0)
	
	ld bc,1 
	or a,a 
	sbc hl,bc 
	push hl 
	pea ix-2 
	jq p,bucketloop
	
	pop hl
	pop hl
return:
	pop ix 
	ret 
	
assert $<$E30B80
load _renderFaces_data: $-$$ from $$
_renderFaces_len := $-$$
end virtual
_renderFaces_src:
	db _renderFaces_data
	

	