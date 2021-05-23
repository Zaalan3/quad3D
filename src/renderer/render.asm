public _renderObjects

extern _activeObject
extern _numObjects
extern _projectVertices
extern _vertexCache
extern _faceBucket
extern _faceCache
extern _callShader

shader equ iy+0
light equ iy+1	
u0 equ iy+2
v0 equ iy+3
vt0 equ iy+4
vt1 equ iy+6
vt2 equ iy+8
vt3 equ iy+10
	
numFaces equ ix+0 
facePointer equ ix+3 
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

tshader equ ix+36
tlight equ ix+37
tu0 equ ix+38
tv0 equ ix+39
tx0 equ ix+40
ty0 equ ix+42
tay equ ix+44
tax equ ix+46 
tby equ ix+48
tbx equ ix+50
tcy equ ix+52
tcx equ ix+54
tnext equ ix+56 

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
	ld (facePointer),bc
	
	ld a,(_numObjects)
	or a,a 
	jq Z,return
	ld b,a
	ld iy,_activeObject 
	
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
	ld d,h 
	ld e,l 
	add hl,hl
	add.sis hl,de 
	ld de,_vertexCache
	add hl,de 
	lea de,x0 
	ld bc,6 
	ldir 
	
	ld hl,(vt1) 
	add hl,hl
	ld b,h 
	ld c,l 
	add hl,hl
	add.sis hl,bc 
	ld bc,_vertexCache
	add hl,bc 
	ld bc,6 
	ldir
	
	ld hl,(vt2) 
	add hl,hl
	ld b,h 
	ld c,l 
	add hl,hl
	add.sis hl,bc 
	ld bc,_vertexCache
	add hl,bc 
	ld bc,6 
	ldir
	
	ld hl,(vt3) 
	add hl,hl
	ld b,h 
	ld c,l 
	add hl,hl
	add.sis hl,bc 
	ld bc,_vertexCache
	add hl,bc 
	ld bc,6 
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
	ld b,0 
	and a,3 
	jr Z,$+3
	inc b 
	ld (tshader),b 
	
	
	; by = y3 - y0 
	ld hl,(y3) 
	ld de,(y0) 
	or a,a 
	sbc.sis hl,de 
	ld (tby),hl 
	
	;bx = x3 - x0 
	ld hl,(x3) 
	ld de,(x0) 
	or a,a 
	sbc.sis hl,de 
	ld (tbx),hl
	
	; cy = y1 - y0 
	ld hl,(y1) 
	ld de,(y0) 
	or a,a 
	sbc.sis hl,de 
	ld (tcy),hl 
	
	;cx = x1 - x0 
	ld hl,(x1) 
	ld de,(x0) 
	or a,a 
	sbc.sis hl,de 
	ld (tcx),hl
	
	; area = (x2-x0)*(cy-by) + (y2-y0)*(bx-cx)
	ld hl,(x2) 
	or a,a 
	sbc.sis hl,de 
	ld b,h 
	ld c,l 
	ld hl,(tcy) 
	ld de,(tby) 
	or a,a 
	sbc.sis hl,de
	; de = hl*bc 
	ld d,l 
	ld e,c 
	ld l,c 
	ld c,d  
	mlt hl 
	mlt bc 
	mlt de 
	ld a,d 
	add a,l 
	add a,c 
	ld d,a 
	push de 
	
	ld hl,(y2)
	ld de,(y0) 
	or a,a 
	sbc.sis hl,de 
	ld b,h 
	ld c,l 
	ld hl,(tbx) 
	ld de,(tcx) 
	or a,a 
	sbc.sis hl,de
	ld d,l 
	ld e,c 
	ld l,c 
	ld c,d  
	mlt hl 
	mlt bc 
	mlt de 
	ld a,d 
	add a,l 
	add a,c 
	ld d,a
	pop hl 
	add hl,de
	; skip if area >= 0 
	bit 7,h 
	jq z,skipFace 
	push hl
	
	; ay = y0 - y1 - y3 + y2 = y2 - by - y1 
	ld hl,(y2) 
	ld de,(tby)
	or a,a 
	sbc.sis hl,de 
	ld de,(y1) 
	or a,a 
	sbc.sis hl,de 
	ld (tay),hl
	
	; ax = x0 - x1 - x3 + x2 = x2 - bx - x1 
	ld hl,(x2) 
	ld de,(tbx)
	or a,a 
	sbc.sis hl,de 
	ld de,(x1) 
	or a,a 
	sbc.sis hl,de 
	ld (tax),l 
	ld (tax+1),h
	
	; copy light,u0 & v0,x0 & y0 
	ld hl,(light) 
	ld (tlight),hl 
	ld hl,(x0) 
	ld (tx0),hl 
	ld a,(y0+1) 
	ld (ty0+1),a
	
	; find sum of distances (8.2 average)  
	or a,a 
	sbc hl,hl 
	ld de,0 
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
	
	; if area >= -512 then use 16x16 shader
	pop bc
	ld hl,512 
	add.sis hl,bc 
	rl h 
	jq nc,shader16 
_shader32: 
	ld hl,(tax) 
	sra h 
	rr l 
	sra h 
	rr l 
	ld (tax),l 
	ld (tax+1),h 
	ld hl,(tay) 
	sra h 
	rr l 
	sra h 
	rr l 
	ld (tay),l 
	ld (tay+1),h 
	
	ld hl,(tbx) 
	add hl,hl
	add hl,hl
	add hl,hl
	ld (tbx),l 
	ld (tbx+1),h 
	
	ld hl,(tby) 
	add hl,hl
	add hl,hl
	add hl,hl
	ld (tby),l 
	ld (tby+1),h 
	
	ld hl,(tcx) 
	add hl,hl
	add hl,hl
	add hl,hl
	ld (tcx),l 
	ld (tcx+1),h 
	
	ld hl,(tcy) 
	add hl,hl
	add hl,hl
	add hl,hl
	ld (tcy),l 
	ld (tcy+1),h
	
	jq copyFace 
shader16: 
	ld a,2 
	add a,(tshader) 
	ld (tshader),a 
	
	ld hl,(tbx) 
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	ld (tbx),l 
	ld (tbx+1),h 
	
	ld hl,(tby) 
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	ld (tby),l 
	ld (tby+1),h 
	
	ld hl,(tcx) 
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	ld (tcx),l 
	ld (tcx+1),h 
	
	ld hl,(tcy) 
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	ld (tcy),l 
	ld (tcy+1),h
	
copyFace: 
	; copy face to cache 
	ld de,(facePointer)
	lea hl,tshader 
	ld bc,22 
	ldir 
	ld (facePointer),de 
	
skipFace: 
	exx 
	lea iy,iy+12 
	or a,a 
	sbc hl,de 
	jq nz,faceloop 
	pop iy 
	dec b 
	jq nz,objectloop
	
; iterates through face buckets and renders faces
renderFaces: 
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
	
	

	