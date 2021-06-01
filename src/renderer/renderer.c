
#include <graphx.h> 

#include "renderer.h" 

/*-------------variable defines----------------*/ 
// ~24 kb off heap 

// active object list
uint8_t numObjects;
object_t* activeObject[64];

// visible faces cache
face_cached_t faceCache[1024]; 

// camera matrix
translation_matrix_t cameraMatrix;

