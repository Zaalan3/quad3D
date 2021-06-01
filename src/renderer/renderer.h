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
extern translation_matrix_t cameraMatrix; 

// active object list
extern uint8_t numObjects;
extern object_t* activeObject[64];

// processed vertices
// 8 kb
extern vertex_cached_t vertexCache[1024]; 

// visible faces cache
// 22 kb on heap
extern face_cached_t faceCache[1024]; 

// face bucket linked list
// stores first face for each distance
// 2 kb 
extern uint16_t faceBucket[1024];

// initializes renderer
void initRenderer(void); 

// resets renderer
void closeRenderer(void);

// blits the Canvas to the Screen. 
void blitCanvas(void); 

// clears the canvas
void clearCanvas(void); 

// renders objects to canvas
void renderObjects(void);

#define setCameraAngle(ax,ay,az) eulerToMatrix(&cameraMatrix,ax,ay,az) 

// sets the camera's position 
void setCameraPosition(vertex_t* position); 


#endif