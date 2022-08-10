section .text 

public _qdBlitCanvas
public _qdClearCanvas

public canvas
public canvas_width
public canvas_height
public canvas_offset

canvas:=$D40000
canvas_width:=160 
canvas_height:=120 
canvas_offset:=48

screen:=$D52C00 

gfxFillScreenFastCode:=$E30800 

;coopts gfx_FillScreen fast code @ e30800
_qdClearCanvas:
	ld iy,0 
	add iy,sp 
	ld hl,canvas + 345*89
	ld sp,hl
	or a,a 
	sbc hl,hl 
	ex de,hl 
	ld b,89 
	call gfxFillScreenFastCode
	ld sp,iy 
	ret
	
_qdBlitCanvas:
	ld hl,canvas+canvas_offset
	ld bc,0
	exx 
	ld hl,screen + 60*320 + 80 
	ld de,320
	ld b,canvas_height
.loop: 
	push hl 
	add hl,de 
	exx 
	pop de 
	ld c,canvas_width 
	ldir 
	inc h 
	ld l,canvas_offset
	exx 
	djnz .loop 
	ret 