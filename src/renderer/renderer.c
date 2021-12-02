
#include <graphx.h> 

#include "renderer.h" 

/*-------------variable defines----------------*/ 
// ~24 kb off heap 

// active object list
uint8_t qdNumObjects;
qdObject* qdActiveObject[64];

uint8_t qdNumSprites; 
qdSprite qdActiveSprite[64];

// visible faces cache
struct qd_face_cached qdFaceCache[1024]; 

// camera matrix
qdMatrix qdCameraMatrix;

