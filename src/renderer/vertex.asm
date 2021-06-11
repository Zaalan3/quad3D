public _transformVertices
public _projectVertices
public _projectSprites
public _setCameraPosition

public _matrixRoutine
public _matrixroutine_len
public _matrixroutine_src

public _matrixRow0Multiply
public _matrixRow1Multiply
public _matrixRow2Multiply

public _ZinvLUT

extern canvas_width
extern canvas_height

extern _vertexCache
extern _cameraMatrix 

extern _getReciprocal 
extern _MultiplyHLBC
extern _recipTable

extern _activeSprite
extern _numSprites

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
	ld iy,_cameraMatrix
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
	pop ix
	ret

	
;---------------------------------------------------------
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
	ld hl,(ix+9) 
	ld ix,(ix+3) 
	ld bc,1
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
	or a,a 
	sbc hl,bc
	jr nz,loop
	pop ix
	ret 

; projects sprite vertices
_projectSprites: 
	push iy 
	push bc 
	ld a,8
	ld (SMCSizeVertex),a
	
	ld ix,_activeSprite 
	ld iy,_cameraMatrix
; half size of a sprite, displacement of topleft corner from sprite center(in local space)
	ld de,8 
	ld hl,(cx)
	or a,a 
	sbc.sis hl,de 
	ld (SMCLoadX),hl
	ld hl,(cy) 
	add hl,de 
	ld (SMCLoadY),hl
	ld hl,(cz) 
	ld (SMCLoadZ),hl
	
	ld iy,_vertexCache
	or a,a 
	sbc hl,hl 
	ld a,(_numSprites)
	ld l,a
	ld de,1
	jp projloop
	
_projectVertices: 
	push iy 
	push bc
	
	ld a,6 
	ld (SMCSizeVertex),a
	lea ix,iy+0
	ld iy,_cameraMatrix
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
	
	ld de,(ix+9)  ; de = vertex count
	ld ix,(ix+13) ; ix = vertex pointer
	
	ld iy,_vertexCache 
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
	
	dec l 
	add hl,hl  
	ld de,_ZinvLUT
	add hl,de 
	ld hl,(hl) 
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
	jr Z,$+9
	ld (outcode),$FF 
	pop bc 
	jr skipVert
	; left outcode 
	ld h,a 
	ld a,l
	cp a,48
	rl h	; set if x less than 
	; right outcode 
	cp a,canvas_width+48
	ccf 
	ld a,h  
	rla
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
	add.sis hl,hl
	ccf 
	rla 
	
	ld (outcode),a 
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
	
load _matrixroutine_data: $-$$ from $$
_matrixroutine_len := $-$$
end virtual
_matrixroutine_src:
	db _matrixroutine_data
	
	
_ZinvLUT:
	dw 32767
	dw 16384
	dw 10922
	dw 8192
	dw 6553
	dw 5461
	dw 4681
	dw 4096
	dw 3640
	dw 3276
	dw 2978
	dw 2730
	dw 2520
	dw 2340
	dw 2184
	dw 2048
	dw 1927
	dw 1820
	dw 1724
	dw 1638
	dw 1560
	dw 1489
	dw 1424
	dw 1365
	dw 1310
	dw 1260
	dw 1213
	dw 1170
	dw 1129
	dw 1092
	dw 1057
	dw 1024
	dw 992
	dw 963
	dw 936
	dw 910
	dw 885
	dw 862
	dw 840
	dw 819
	dw 799
	dw 780
	dw 762
	dw 744
	dw 728
	dw 712
	dw 697
	dw 682
	dw 668
	dw 655
	dw 642
	dw 630
	dw 618
	dw 606
	dw 595
	dw 585
	dw 574
	dw 564
	dw 555
	dw 546
	dw 537
	dw 528
	dw 520
	dw 512
	dw 504
	dw 496
	dw 489
	dw 481
	dw 474
	dw 468
	dw 461
	dw 455
	dw 448
	dw 442
	dw 436
	dw 431
	dw 425
	dw 420
	dw 414
	dw 409
	dw 404
	dw 399
	dw 394
	dw 390
	dw 385
	dw 381
	dw 376
	dw 372
	dw 368
	dw 364
	dw 360
	dw 356
	dw 352
	dw 348
	dw 344
	dw 341
	dw 337
	dw 334
	dw 330
	dw 327
	dw 324
	dw 321
	dw 318
	dw 315
	dw 312
	dw 309
	dw 306
	dw 303
	dw 300
	dw 297
	dw 295
	dw 292
	dw 289
	dw 287
	dw 284
	dw 282
	dw 280
	dw 277
	dw 275
	dw 273
	dw 270
	dw 268
	dw 266
	dw 264
	dw 262
	dw 260
	dw 258
	dw 256
	dw 254
	dw 252
	dw 250
	dw 248
	dw 246
	dw 244
	dw 242
	dw 240
	dw 239
	dw 237
	dw 235
	dw 234
	dw 232
	dw 230
	dw 229
	dw 227
	dw 225
	dw 224
	dw 222
	dw 221
	dw 219
	dw 218
	dw 217
	dw 215
	dw 214
	dw 212
	dw 211
	dw 210
	dw 208
	dw 207
	dw 206
	dw 204
	dw 203
	dw 202
	dw 201
	dw 199
	dw 198
	dw 197
	dw 196
	dw 195
	dw 193
	dw 192
	dw 191
	dw 190
	dw 189
	dw 188
	dw 187
	dw 186
	dw 185
	dw 184
	dw 183
	dw 182
	dw 181
	dw 180
	dw 179
	dw 178
	dw 177
	dw 176
	dw 175
	dw 174
	dw 173
	dw 172
	dw 171
	dw 170
	dw 169
	dw 168
	dw 168
	dw 167
	dw 166
	dw 165
	dw 164
	dw 163
	dw 163
	dw 162
	dw 161
	dw 160
	dw 159
	dw 159
	dw 158
	dw 157
	dw 156
	dw 156
	dw 155
	dw 154
	dw 153
	dw 153
	dw 152
	dw 151
	dw 151
	dw 150
	dw 149
	dw 148
	dw 148
	dw 147
	dw 146
	dw 146
	dw 145
	dw 144
	dw 144
	dw 143
	dw 143
	dw 142
	dw 141
	dw 141
	dw 140
	dw 140
	dw 139
	dw 138
	dw 138
	dw 137
	dw 137
	dw 136
	dw 135
	dw 135
	dw 134
	dw 134
	dw 133
	dw 133
	dw 132
	dw 132
	dw 131
	dw 131
	dw 130
	dw 130
	dw 129
	dw 129
	dw 128
 
	