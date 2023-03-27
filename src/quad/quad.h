#ifndef QUADRENDERER  
#define QUADRENDERER

#include <stdbool.h>
#include <stddef.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <tice.h>
#include <compression.h>

#include "fxmath.h"
#include "def3d.h" 
#include "matrix.h"

/* 
	TODO: proper usage documentation 
	
	Quad3D is a 3D rendering library designed for the TI84+CE. 
	It is designed to be used on top of the GraphX C library. 
	
	Quad3D uses the first 75 KB of VRAM for internal use, and thus double buffering cannot be used in GraphX. 
*/ 

#define loadTextureMapCompressed(y,ptr) zx7_Decompress((void *)0xD48000 + 256*(y),(void *)ptr)

// camera matrix
extern qdMatrix qdCameraMatrix; 

// initializes renderer 
void qdInit(void); 

// resets renderer
void qdClose(void);

// blits the Canvas to the Screen. 
void qdBlitCanvas(uint8_t* buffer); 

// clears the canvas
void qdClearCanvas(void); 

// renders objects and sprites to canvas.
//void qdRender(void);

// render an array of billboard sprites. 
void qdRenderSprites(qdSprite* sprites,uint8_t numSprites); 

// render an object
void qdRenderObject(qdObject* object);

// uses render information to draw screen.
// flushes render caches.
void qdDraw();

#define qdSetCameraAngle(ax,ay,az) qdEulerToMatrix(&qdCameraMatrix,ax,ay,az) 

#define qdSetCameraPosition(a,b,c) qdCameraMatrix.x = a; \
								qdCameraMatrix.y = b; \
								qdCameraMatrix.z = c;
							
// visible faces cache
// filled by render functions
// ~11 kb
extern volatile struct qd_face_cached qdFaceCache[512]; 

// face bucket linked lists
// stores indices for the first face at each distance
// 2 kb 
extern volatile uint16_t qdFaceBucket[1024];

#endif