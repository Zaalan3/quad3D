public _initRenderer

extern _gfx_Begin 
extern _gfx_ZeroScreen 
extern _gfx_SwapDraw 
extern _gfx_SetDraw 

extern _numFaces 
extern _numObjects

extern _bilerpShader
extern _bilerp_len
extern _bilerp_src

extern _matrixRoutine
extern _matrixroutine_src
extern _matrixroutine_len

_initRenderer: 
	; initialize screen 
	; sets screen buffer to $D52C00. $D40000 reserved for canvas and texture page( so no double buffering ) 
	call	_gfx_Begin
	call	_gfx_ZeroScreen
	call	_gfx_SwapDraw
	call	_gfx_ZeroScreen
	call	_gfx_SwapDraw
	or	a, a
	sbc	hl, hl
	push	hl
	call	_gfx_SetDraw
	pop bc
	
	; load routines into fastRam 
	ld de,_bilerpShader
	ld hl,_bilerp_src
	ld bc,_bilerp_len 
	ldir 
	
	ld de,_matrixRoutine
	ld hl,_matrixroutine_src
	ld bc,_matrixroutine_len 
	ldir 
	
	; reset global variables
	or a,a 
	sbc hl,hl 
	ld (_numFaces),hl 
	ld a,h 
	ld (_numObjects),a
	
	di 
	ret 
