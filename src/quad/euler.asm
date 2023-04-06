section .text 

public _qdEulerToMatrix 

extern mulAngle
extern _fixedSin
extern __frameset
 
matrix equ ix+6 
ax equ ix+9 
ay equ ix+12 
az equ ix+15 

s1 equ ix-3
c1 equ ix-6
s2 equ ix-9
c2 equ ix-12
s3 equ ix-15
c3 equ ix-18

m00 equ iy+0 
m01 equ iy+2
m02 equ iy+4
m10 equ iy+6
m11 equ iy+8
m12 equ iy+10
m20 equ iy+12
m21 equ iy+14
m22 equ iy+16
x equ iy+18 
y equ iy+20 
z equ iy+22


_qdEulerToMatrix:
	ld hl,-18
	call __frameset 
	ld iy,(matrix) 
	
	ld hl,(ay)
	call _fixedSin
	ld (s1),hl
	ld hl,(ay)
	ld de,256 
	add hl,de
	call _fixedSin 
	ld (c1),hl 
	
	ld hl,(ax) 
	call _fixedSin
	ld (s2),hl 
	ld (m21),hl
	ld hl,(ax) 
	ld de,256 
	add hl,de 
	call _fixedSin 
	ld (c2),hl 
	
	ld hl,(az)
	call _fixedSin
	ld (s3),hl 
	ld hl,(az)
	ld de,256 
	add hl,de
	call _fixedSin 
	ld (c3),hl 
	
	ld bc,(c1) 
	call mulAngle
	push hl 
	ld hl,(s1) 
	ld bc,(s2) 
	call mulAngle
	ld bc,(s3)
	call mulAngle
	ex de,hl 
	pop hl 
	or a,a 
	sbc hl,de
	ld (m00),hl 
	
	ld hl,(c2) 
	ld bc,(s3) 
	call mulAngle
	ex de,hl 
	or a,a 
	sbc hl,hl
	sbc hl,de 
	ld (m01),hl 
	
	ld hl,(s1)
	ld bc,(c3) 
	call mulAngle
	push hl 
	ld hl,(c1) 
	ld bc,(s2) 
	call mulAngle
	ld bc,(s3)
	call mulAngle
	pop de 
	add hl,de 
	ld (m02),hl 

	ld hl,(s3)
	ld bc,(c1) 
	call mulAngle
	push hl 
	ld hl,(c3) 
	ld bc,(s2) 
	call mulAngle
	ld bc,(s1)
	call mulAngle
	pop de 
	add hl,de 
	ld (m10),hl 
	
	ld hl,(c2) 
	ld bc,(c3) 
	call mulAngle 
	ld (m11),hl 
	
	ld hl,(s1)
	ld bc,(s3) 
	call mulAngle
	push hl 
	ld hl,(c1) 
	ld bc,(s2) 
	call mulAngle
	ld bc,(c3)
	call mulAngle
	ex de,hl 
	pop hl 
	or a,a 
	sbc hl,de 
	ld (m12),hl 
	
	ld hl,(c2) 
	ld bc,(s1) 
	call mulAngle
	ex de,hl 
	or a,a 
	sbc hl,hl 
	sbc hl,de 
	ld (m20),l 
	ld (m20+1),h

	ld hl,(c2) 
	ld bc,(c1) 
	call mulAngle 
	ld (m22),l 
	ld (m22+1),h
	
	ld sp,ix 
	pop ix 
	ret
 