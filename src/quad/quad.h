#ifndef renderer_3d_define 
#define renderer_3d_define

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

#define loadTextureMapCompressed(ptr) zx7_Decompress((void *)0xD48000,(void *)ptr)

// camera matrix
extern qdMatrix qdCameraMatrix; 

// active object list
extern uint8_t qdNumObjects;
extern qdObject qdActiveObject[64];

extern uint8_t qdNumSprites; 
extern qdSprite qdActiveSprite[64];

// visible faces cache
// 10 kb
extern volatile struct qd_face_cached qdFaceCache[512]; 

// face bucket linked lists
// stores indices for the first face at each distance
// 2 kb 
extern volatile uint16_t qdFaceBucket[1024];

// initializes renderer 
void qdInit(void); 

// resets renderer
void qdClose(void);

// blits the Canvas to the Screen. 
void qdBlitCanvas(void); 

// clears the canvas
void qdClearCanvas(void); 

// renders objects and sprites to canvas.
void qdRender(void);

#define qdSetCameraAngle(ax,ay,az) qdEulerToMatrix(&qdCameraMatrix,ax,ay,az) 

#define qdSetCameraPosition(a,b,c) qdCameraMatrix.x = a; \
								qdCameraMatrix.y = b; \
								qdCameraMatrix.z = c;

#endif