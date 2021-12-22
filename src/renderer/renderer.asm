public _qdInit
public _qdClose

extern _gfx_Begin 
extern _gfx_ZeroScreen 
extern _gfx_SwapDraw 
extern _gfx_SetDraw 
extern _gfx_End

extern port_setup
extern port_privilege_unlock
extern port_privilege_lock

extern _qdNumObjects
extern _qdNumSprites

extern _shaderRoutine
extern _shaderRoutine_len
extern _shaderRoutine_src

extern _matrixRoutine
extern _matrixRoutine_src
extern _matrixRoutine_len

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
	push ix 
	; unlock ports
	call port_setup 
	call port_privilege_unlock 
	pop ix 
	
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
	push ix 
	call port_privilege_lock 
	pop ix 
	jp _gfx_End
	