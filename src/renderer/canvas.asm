
public _qdBlitCanvas
public _qdClearCanvas

public _qdVertexCache 
public _qdFaceBucket

public canvas
public canvas_width
public canvas_height

canvas:=$D40000
canvas_width:=160 
canvas_height:=120 
canvas_offset:=48

screen:=$D52C00 

_qdFaceBucket:=$D52000
_qdVertexCache:=$D50000

_qdClearCanvas: 
	ld iy,0 
	add iy,sp 
	ld hl,canvas+canvas_width+canvas_offset
	ld de,0
	ld b,120
loop: 
	ld sp,hl
repeat 54 
	push de 
end repeat 
	inc h 
	djnz loop
	ld sp,iy
	ret 
	
_qdBlitCanvas:
	ld hl,canvas+canvas_offset
	exx 
	ld hl,screen + 60*320 + 80 
	ld de,320
	ld b,canvas_height
bloop: 
	push hl 
	add hl,de 
	exx 
	pop de 
	ld bc,canvas_width 
	ldir 
	inc h 
	ld l,canvas_offset
	exx 
	djnz bloop 
	ret 