
#include <graphx.h> 

#include "renderer.h" 

/*-------------variable defines----------------*/ 
// ~24 kb off heap 

// active object list
uint8_t numObjects;
object_t* activeObject[255];

uint8_t numSprites; 
billboard_t activeSprite[255];

// visible faces cache
struct face_cached faceCache[1024]; 

// camera matrix
translation_matrix_t cameraMatrix;

