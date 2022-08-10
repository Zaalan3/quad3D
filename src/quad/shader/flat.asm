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
flat16: 
	ld a,h 
	exx 
	ld d,a 
	ld e,h 
	ld b,iyl 
	ld a,b 
	ld (de),a 
	add hl,sp 
	exx 
	add hl,de
repeat 3 
	ld a,h 
	exx 
	ld d,a 
	ld e,h 
	ld a,b 
	ld (de),a 
	add hl,sp 
	exx 
	add hl,de 
end repeat 
	djnz flat16
	ld b,4
	jp shaderVloop
	endShader flat16

;-----------------------------------
flat16_clipped:
	ld a,h 
	exx 
	ld d,a 
	cp a,canvas_height
	jr nc,$+7 
	ld e,h
	ld b,iyl 
	ld a,b 
	ld (de),a 
	add hl,sp 
	exx 
	add hl,de 
repeat 3  
	ld a,h 
	exx 
	ld d,a 
	cp a,canvas_height
	jr nc,$+5  
	ld e,h 
	ld a,b 
	ld (de),a 
	add hl,sp 
	exx 
	add hl,de 
end repeat  
	djnz flat16_clipped
	ld b,4
	jp shaderVloop
	endShader flat16_clipped


;-----------------------------------
flat32: 
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
	djnz flat32
	ld b,8
	jp shaderVloop 
	endShader flat32

;-----------------------------------
flat32_clipped: 
repeat 2 
	ld a,h 
	exx 
	cp a,canvas_height-1 
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
	djnz flat32_clipped
	ld b,8
	jp shaderVloop 
	endShader flat32_clipped
	
;-----------------------------------
flat8:
	ld a,h 
	exx 
	ld d,a 
	ld e,h 
	ld b,iyl
	ld a,b
	ld (de),a 
	add hl,sp 
	exx 
	add hl,de
repeat 3 
	ld a,h 
	exx 
	ld d,a 
	ld e,h 
	ld a,b
	ld (de),a 
	add hl,sp 
	exx 
	add hl,de 
end repeat 
	djnz flat8
	ld b,2 
	jp shaderVloopIncB
	endShader flat8	
	
;-----------------------------------
flat8_clipped: 
	ld a,h 
	exx 
	ld d,a 
	cp a,canvas_height 
	jr nc,$+7 
	ld e,h 
	ld b,iyl 
	ld a,b 
	ld (de),a 
	add hl,sp 
	exx 
	add hl,de
repeat 3  
	ld a,h 
	exx 
	ld d,a 
	cp a,canvas_height 
	jr nc,$+5 
	ld e,h 
	ld a,b 
	ld (de),a 
	add hl,sp 
	exx 
	add hl,de 
end repeat 
	djnz flat8_clipped
	ld b,2 
	jp shaderVloopIncB
	endShader flat8_clipped	

public flat16
public flat16.len 
public flat16_clipped
public flat16_clipped.len
public flat32
public flat32.len
public flat32_clipped
public flat32_clipped.len
public flat8
public flat8.len 
public flat8_clipped
public flat8_clipped.len