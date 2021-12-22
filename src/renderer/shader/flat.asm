
extern shaderVloop 
extern canvas_height

;place at end of shader 
macro endShader shader 
	shader.len:=$-shader 
	assert shader.len <= 64 
end macro 


;-----------------------------------
bilerp16_flat: 
repeat 4 
	ld a,h 
	exx 
	ld d,a 
	ld e,h 
	ld a,iyl 
	ld (de),a 
	add hl,sp 
	exx 
	add hl,de 
end repeat 
	djnz bilerp16_flat
	jp shaderVloop
	endShader bilerp16_flat

;-----------------------------------
bilerp16_flat_clipped: 
repeat 4 
	ld a,h 
	exx 
	ld d,a 
	cp a,canvas_height 
	jr nc,$+6 
	ld e,h 
	ld a,iyl 
	ld (de),a 
	add hl,sp 
	exx 
	add hl,de 
end repeat 
	djnz bilerp16_flat_clipped
	jp shaderVloop
	endShader bilerp16_flat_clipped


;-----------------------------------
bilerp32_flat: 
repeat 2 
	ld a,h 
	exx 
	ld d,a 
	ld e,h 
	ld a,iyl 
	ld (de),a 
	inc e 
	ld (de),a 
	inc d
	ld (de),a 
	dec e
	ld (de),a 
	add hl,sp 
	exx 
	add hl,de
end repeat
	djnz bilerp32_flat
	jp shaderVloop 
	endShader bilerp32_flat

;-----------------------------------
bilerp32_flat_clipped: 
repeat 2 
	ld a,h 
	exx 
	cp a,canvas_height
	jr nc,$+13
	ld d,a 
	ld e,h 
	ld a,iyl 
	ld (de),a 
	inc e 
	ld (de),a 
	inc d
	ld (de),a 
	dec e
	ld (de),a 
	add hl,sp 
	exx 
	add hl,de
end repeat
	djnz bilerp32_flat_clipped
	jp shaderVloop 
	endShader bilerp32_flat_clipped

public bilerp16_flat
public bilerp16_flat.len 
public bilerp16_flat_clipped
public bilerp16_flat_clipped.len
public bilerp32_flat
public bilerp32_flat.len
public bilerp32_flat_clipped
public bilerp32_flat_clipped.len