public _qdRender

extern _qdActiveSprite
extern _qdNumSprites
extern _qdActiveObject
extern _qdNumObjects

extern _setCameraPosition
extern _projectVertices
extern _projectSprites

extern _qdVertexCache
extern _qdFaceBucket
extern _qdFaceCache
extern _qdClearCanvas

extern _currentShader
extern _callShader

extern _ZinvLUT

extern canvas_width
extern canvas_height
extern canvas_offset

; outcodes 
outTop equ 01000b
outBottom equ 0100b
outLeft equ 0010b
outRight equ 0001b 
outOOB equ $FF

;  vars 

; face 
shader equ iy+0
light equ iy+1	
u0 equ iy+2
v0 equ iy+3
vt0 equ iy+4
vt1 equ iy+6
vt2 equ iy+8
vt3 equ iy+10
	
; stack vars 
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

; sprite vars 
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

; face cache vars 
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

txlen equ iy+2 
tylen equ iy+3 
tustart equ iy+6
tvstart equ iy+9
tdelta equ iy+12 

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
	ld bc,1024 
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
	ld b,a 	; b = sprite count
	call _projectSprites
	ld ix,_qdActiveSprite ; ix = pointer to sprite
	ld iy,_qdFaceCache 
spriteloop: 
	exx 
	; skip if sprite depth = $FF 
	ld a,(sdepth) 
	cp a,$FF
	jq Z,skipSprite 
	
	;delta = 2*z 
	or a,a 
	sbc hl,hl 
	ld h,(spriteU) 
	ld (tustart),hl
	ld h,(spriteV) 
	ld (tvstart),hl
	ld h,l 
	
	ld l,a 
	add hl,hl
	ld (tdelta),hl 
	add hl,hl 
	push hl ; depth bucket 
	
	ld (tshader),$80 ; sprite shader
	;clip sxs  
	ld hl,(sxs)
	ld (tx0),l 
	ld de,canvas_offset 
	or a,a 
	sbc.sis hl,de 
	call c,correctU  ; correct ustart and x0 if sxs<offset 
	
	;xlen = min(width+offset,sxe) - sxs 
	ld hl,(sxe) 
	ld de,canvas_width+canvas_offset-1 
	call minHLDE 
	ld a,l 
	sub a,(tx0) 
	
	cp a,1 
	jq nz,.skipOnePixel
.onePixel: 
	pop de 
	jq skipSprite
.skipOnePixel: 
	ld (txlen),a 
	
	;clip sys 
	ld hl,(sys) 
	ld (ty0),l 
	bit 7,h 
	call nz,correctV  ; correct y0 and vstart if sys<0 
	
	;ylen = min(height,sye) - sys 
	ld hl,(sye) 
	ld de,canvas_height-1 
	call minHLDE 
	ld a,l 
	sub a,(ty0) 
	ld (tylen),a 
	
	pop hl ; hl = depth bucket
	push ix 
	ld ix,$E30B80 ; ix = stack vars
	
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
	
	pop ix 
	lea iy,iy+20 ; next face cache entry 
skipSprite:
	exx
	lea ix,ix+19 ; next sprite 
	dec b 
	jq nz,spriteloop
	
	ld ix,$E30B80
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
	cp a,outOOB 
	jq z,skipFace 
	; shader is clipped if TOP|BOTTOM
	ld b,(shader) 
	tst a, outTop + outBottom
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
		
	ld de,512 
	or a,a 
	sbc hl,de 
	jq p,loadFacePointer
	
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
	call _qdClearCanvas 
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
	
;------------------------------------
	
; hl = min(hl,de) (16 bit)
minHLDE: 
	or a,a 
	sbc.sis hl,de 
	jq c,$+4 
	ex de,hl  
	ret 
	add hl,de
	ret 


correctU: 
	ld (tx0),canvas_offset 
	call correctUV 
	ld de,(tustart) 
	add hl,de 
	ld (tustart),hl
	ret 
correctV: 
	ld (ty0),0 
	call correctUV
	ld de,(tvstart) 
	add hl,de 
	ld (tvstart),hl 
	ret 
correctUV:  
	ex de,hl 
	or a,a 
	sbc hl,hl 
	sbc hl,de ; abs(hl) 
	ex de,hl 
	ld bc,(tdelta)
	; fixed de*bc 
	ld h,e 
	ld l,c 
	mlt hl
	ld a,b 
	ld b,d  
	ld d,a 
	mlt de 
	mlt bc
	ld a,h 
	add a,c 
	add a,e 
	ld h,a
	ret 
	