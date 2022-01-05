public _qdRender

extern _qdActiveSprite
extern _qdNumSprites
extern _qdActiveObject
extern _qdNumObjects
extern _projectVertices
extern _projectSprites
extern _qdVertexCache
extern _qdFaceBucket
extern _qdFaceCache
extern _callShader
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
facePointer equ ix+12 

x0 equ ix+15
y0 equ ix+17
depth0 equ ix+19 
outcode0 equ ix+20
x1 equ ix+21
y1 equ ix+23
depth1 equ ix+25
outcode1 equ ix+26
x2 equ ix+27
y2 equ ix+29
depth2 equ ix+31
outcode2 equ ix+32
x3 equ ix+33
y3 equ ix+35
depth3 equ ix+37
outcode3 equ ix+38 

spriteX equ ix+15 
spriteY equ ix+17
spriteDepth equ ix+19 
spriteOutcode equ ix+20  
spriteU equ ix+21
spriteV equ ix+22

tshader equ iy+0
tlight equ iy+1
tu0 equ iy+2
tv0 equ iy+3
tx0 equ iy+4
ty0 equ iy+5
tay equ iy+6
tax equ iy+8
tby equ iy+10
tbx equ iy+12
tcy equ iy+14
tcx equ iy+16
tnext equ iy+18

_qdRender: 
	or a,a 
	sbc hl,hl 
	add hl,sp
	ld sp,$E30BFC 
	push hl
	push ix
	ld ix,$E30B80
	 
	; init face buckets 
	ld hl,_qdFaceBucket
	ld de,_qdFaceBucket+1 
	ld (hl),$FF 
	ld bc,2047 
	ldir 
	; init variables 
	ld (numFaces),bc 
	ld (bucketMax),bc 
	ld bc,1024
	ld (bucketMin),bc 
	ld bc,_qdFaceCache 
	ld (cachePointer),bc
	
	; load camera matrix
	call _setCameraPosition
	
; process sprites 
processSprites:
	ld a,(_qdNumSprites) 
	or a,a 
	jq Z,processObjects 
	ld b,a 
	ld iy,_qdVertexCache	
	call _projectSprites
	ld ix,$E30B80
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
	tst a,0101b 	; skip if vertex below or to the right offscreen 
	jq nz,skipSprite 
findWidth:
	; compute width and height
	or a,a 
	sbc hl,hl 
	ld l,(spriteDepth) 
	add hl,hl 
	ld de,_ZinvLUT
	add hl,de 
	ld hl,(hl) 
	; de = size = 4*f/z
	xor a,a 
	add hl,hl
	add.sis hl,hl
	rla 
	ld l,h 
	ld h,a 
	ex de,hl 
	
	; skip sprite if y+size<0  
	ld hl,(spriteY) 
	add hl,de 
	rl h 
	jq c,skipSprite
	xor a,a	; textured shader
	ld hl,-17 ;if size > 16  
	add hl,de 
	jr c,$+4 
	add a,2 
	ld (tshader),a 
; set face entry 
	ld (tbx),de 
	ld (tcy),de 
	
	ld hl,(spriteU) 
	ld (tu0),hl 
	ld h,(spriteY)  
	ld l,(spriteX) 
	ld (tx0),hl
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
	ld hl,_qdFaceBucket
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
	lea iy,iy+20 
	
skipSprite:
	exx
	dec b 
	jq nz,spriteloop
	
	ld (cachePointer),iy
;----------------------------------------
; process 3D objects 
processObjects:
	ld a,(_qdNumObjects)
	or a,a 
	jq Z,return
	ld b,a
	ld iy,_qdActiveObject 
	
	ld hl,-3 
	add hl,sp 
	ld (StoreSP),hl
objectloop: 
	pea iy+3 
	ld iy,(iy)
	call _projectVertices
cacheFaces: 
	ld de,(iy+8) ;face count
	ld iy,(iy+13) ; face pointer 
	ld ix,$E30B80
	ld hl,1 
	ex.sis hl,de
faceloop:
	exx 
	; fetch vertices 
	ld hl,(vt0) 
	add hl,hl
	add hl,hl 
	add.sis hl,hl
	ld sp,_qdVertexCache
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
	and a,00001100b  
	jr Z,$+3
	inc b 
	
	; copy light,u0 & v0,x0 & y0 
	ld hl,(light)
	ld (facePointer),iy 
	ld iy,(cachePointer)
	
	ld (tlight),hl 
	ld (tshader),b 
	
	; area = (x2-x0)*(y1-y3) + (y2-y0)*(x3-x1)
	ld hl,(x2) 
	ld de,(x0) 
	or a,a 
	sbc hl,de 
	ex de,hl
	ld hl,(y1) 
	ld bc,(y3) 
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
	ld hl,(x3) 
	ld bc,(x1) 
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
	bit 7,h 
	jq nz,loadFacePointer
	
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
	ld hl,_qdFaceBucket
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
	
	ld a,(x0)
	ld (tx0),a
	ld a,(y0) 
	ld (ty0),a
	
	; cy = y1 - y0 
	ld hl,(y1) 
	ld b,h 
	ld c,l 
	ld de,(y0)
	or a,a 
	sbc hl,de 
	ld (tcy),hl 
	; by = y3 - y0 
	ld hl,(y3) 
	or a,a 
	sbc hl,de 
	ld (tby),hl 
	; ay = y0 - y1 - y3 + y2 = y2 - by - y1 
	ex de,hl 
	ld hl,(y2) 
	or a,a 
	sbc hl,de 
	or a,a 
	sbc hl,bc 
	ld (tay),hl
	
	;cx = x1 - x0 
	ld hl,(x1) 
	ld b,h 
	ld c,l 
	ld de,(x0)
	or a,a 
	sbc hl,de 
	ld (tcx),l 
	ld (tcx+1),h
	;bx = x3 - x0 
	ld hl,(x3) 
	or a,a 
	sbc hl,de 
	ld (tbx),l 
	ld (tbx+1),h 
	; ax = x0 - x1 - x3 + x2 = x2 - bx - x1 
	ex de,hl 
	ld hl,(x2) 
	or a,a 
	sbc hl,de 
	or a,a 
	sbc hl,bc 
	ld (tax),l
	ld (tax+1),h 
	
	
	;next face cache entry
	lea iy,iy+20 
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
		
; iterates through face buckets and renders faces
renderFaces: 
	ld a,$FF 
	ld (_currentShader),a
	ld hl,(bucketMax)
	ld de,(bucketMin)
	or a,a 
	sbc hl,de 
	jq m,return
	push hl 
	add hl,de 
	ex de,hl
	ld ix,_qdFaceBucket
	add ix,de 
	add ix,de
	
	ld de,(ix+0)
	push ix-2 
bucketloop:
	bit 7,d 
	jr nz,skipbucket
	; de*20
	ld h,d 
	ld l,e 
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	ex de,hl 
	add hl,hl
	add hl,hl 
	add hl,de
	ex.sis de,hl	; clears uDE
	
	ld iy,_qdFaceCache
	add iy,de 
	ld de,(iy+18) 
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
	pop hl 
	ld sp,hl
	ret 
	
	

	