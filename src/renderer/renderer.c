
#include <graphx.h> 

#include "renderer.h" 

/*-------------variable defines----------------*/ 

// active object list
uint8_t numObjects;
object_t* activeObject[64];

// processed vertices
vertex_cached_t vertexCache[512]; 

// visible faces cache
uint24_t numFaces; 
face_cached_t faceCache[1024]; 


/*-------------C functions----------------*/  


void closeRenderer() {  
	gfx_End();
} 
