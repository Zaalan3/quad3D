section .text 
	
extern shaderVloop 
extern shaderVloopIncB 
extern canvas_height

;place at end of shader 
macro endShader shader 
	shader.len:=$-shader 
	assert shader.len <= 64 
end macro 



;-----------------------------------
bilerp16: 
repeat 4 
	ld a,h 
	exx 
	ld d,a 
	ld e,h 
	ld a,(bc) 
	and a,iyl
	ld (de),a 
	inc c 
	add hl,sp 
	exx 
	add hl,de 
end repeat 
	djnz bilerp16
	ld b,4
	jp shaderVloop
	endShader bilerp16

;-----------------------------------
bilerp16_clipped:
repeat 2
	ld a,h 
	exx 
	ld d,a 
	cp a,canvas_height
	jr nc,$+7
	ld e,h 
	ld a,(bc) 
	and a,iyl
	ld (de),a 
	inc c 
	add hl,sp 
	exx 
	add hl,de 
end repeat
	djnz bilerp16_clipped
	ld b,8
	jp shaderVloop
	endShader bilerp16_clipped

;-----------------------------------
bilerp32: 
repeat 2 
	ld a,h 
	exx 
	ld d,a 
	ld e,h 
	ld a,(bc)
	and a,iyl	
	ld (de),a 
	inc e 
	ld (de),a 
	inc d
	ld (de),a 
	dec e
	ld (de),a 
	inc c
	add hl,sp 
	exx 
	add hl,de
end repeat
	djnz bilerp32
	ld b,8
	jp shaderVloop 
endShader bilerp32

;-----------------------------------
bilerp32_clipped:
repeat 2
	ld a,h 
	exx 
	cp a,canvas_height-1
	jr nc,$+14
	ld d,a
	ld e,h 
	ld a,(bc)
	and a,iyl
	ld (de),a 
	inc e 
	ld (de),a 
	inc d
	ld (de),a 
	dec e
	ld (de),a
	inc c
	add hl,sp 
	exx 
	add hl,de 
end repeat 
	djnz bilerp32_clipped
	ld b,8
	jp shaderVloop 
	endShader bilerp32_clipped
	
;-----------------------------------
bilerp8: 
repeat 4 
	ld a,h 
	exx 
	ld d,a 
	ld e,h 
	ld a,(bc) 
	and a,iyl
	ld (de),a 
	inc c 
	inc c 
	add hl,sp 
	exx 
	add hl,de 
end repeat 
	djnz bilerp8
	ld b,2 
	jp shaderVloopIncB
	endShader bilerp8 
	
;-----------------------------------
bilerp8_clipped:
repeat 2
	ld a,h 
	exx 
	ld d,a 
	cp a,canvas_height
	jr nc,$+7
	ld e,h 
	ld a,(bc) 
	and a,iyl
	ld (de),a 
	inc c 
	inc c
	add hl,sp 
	exx 
	add hl,de 
end repeat
	djnz bilerp8_clipped
	ld b,4 
	jp shaderVloopIncB
	endShader bilerp8_clipped
	
	

public bilerp16
public bilerp16.len 
public bilerp16_clipped
public bilerp16_clipped.len
public bilerp32
public bilerp32.len
public bilerp32_clipped
public bilerp32_clipped.len
public bilerp8
public bilerp8.len 
public bilerp8_clipped
public bilerp8_clipped.len