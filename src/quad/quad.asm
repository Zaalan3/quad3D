section .text 

public _qdInit
public _qdClose

public _qdVertexCache 
public _qdFaceBucket
public _qdFaceCache 

public _qdActiveObject
public _qdActiveSprite


extern _gfx_Begin 
extern _gfx_ZeroScreen 
extern _gfx_SwapDraw 
extern _gfx_SetDraw 
extern _gfx_End

extern port_setup
extern port_privilege_unlock
extern port_privilege_lock

extern _shaderRoutine
extern _shaderRoutine_len
extern _shaderRoutine_src

extern _matrixRoutine
extern _matrixRoutine_src
extern _matrixRoutine_len

extern _qdNumObjects
extern _qdNumSprites 

;variable defines 

_qdVertexCache:=$D40000
_qdFaceBucket:=$D40000 + 256*120
_qdFaceCache:=$D50900

_qdActiveObject:=$D50000 
_qdActiveSprite:=$D50400


_qdInit: 
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
	
	di 
	
	; load routines into fastRam 
	ld de,_shaderRoutine
	ld hl,_shaderRoutine_src
	ld bc,_shaderRoutine_len 
	ldir 
	
	ld de,_matrixRoutine
	ld hl,_matrixRoutine_src
	ld bc,_matrixRoutine_len 
	ldir 
	
	; reset global variables
	xor a,a
	ld (_qdNumObjects),a
	ld (_qdNumSprites),a
	
	ret 
	
_qdClose:
	jp _gfx_End
	