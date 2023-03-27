section .text 

public _qdInit
public _qdClose

public _qdVertexCache 
public _qdFaceBucket
public _qdFaceCache 
public _qdCameraMatrix

;variable defines 
_qdFaceBucket:=$D40000 + 256*120
_qdVertexCache:=$D48000 + 256*96
_qdCameraMatrix:=$D50000 	; 24 bytes
_qdFaceCache:=$D50000 + 44	; 20 bytes per entry

_qdInit: 
	; initialize screen 
	; sets screen buffer to $D52C00. $D40000 reserved for canvas and texture page( so no double buffering by default)
	; note: possible to double buffer if using 160x240 interlace trick
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
	
	; unlock ports for SHA256 scratch area at $E10010
	call port_setup 
	call port_unlock 
	
	; load routines into fastRam 
	ld de,_shaderRoutine
	ld hl,_shaderRoutine_src
	ld bc,_shaderRoutine_len 
	ldir 
	
	ld de,_matrixRoutine
	ld hl,_matrixRoutine_src
	ld bc,_matrixRoutine_len 
	ldir 

	call _qdResetCache
	ret 
	
_qdClose:
	call port_lock
	jp _gfx_End
	
	

extern _gfx_Begin 
extern _gfx_ZeroScreen 
extern _gfx_SwapDraw 
extern _gfx_SetDraw 
extern _gfx_End

extern port_setup 
extern port_unlock 
extern port_lock 

extern _shaderRoutine
extern _shaderRoutine_len
extern _shaderRoutine_src

extern _matrixRoutine
extern _matrixRoutine_src
extern _matrixRoutine_len

extern _qdResetCache

	