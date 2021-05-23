
#include <graphx.h> 

#include "renderer.h" 

/*-------------variable defines----------------*/ 

// active object list
uint8_t numObjects;
object_t* activeObject[64];

// processed vertices
vertex_cached_t vertexCache[512]; 

// visible faces cache
face_cached_t faceCache[1024]; 

// face bucket linked list
// stores first face for each distance 
uint16_t faceBucket[1024];

// camera matrix
translation_matrix_t cameraMatrix;

