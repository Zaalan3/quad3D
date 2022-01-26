 
#include "quad.h" 

/*-------------variable defines----------------*/ 

// active object list
uint8_t qdNumObjects;
qdObject qdActiveObject[64];

uint8_t qdNumSprites; 
qdSprite qdActiveSprite[64];

// camera matrix
qdMatrix qdCameraMatrix;

