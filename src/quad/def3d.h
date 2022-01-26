#ifndef DEF3D
#define DEF3D  

// type defines 

// 3 bytes
typedef struct { 
	uint8_t x; 
	uint8_t y; 
	uint8_t z;
} qdVertex; 

#define	SHADER_TEXTURED 0
#define SHADER_FLAT 4
 
// 12 bytes 
typedef struct {
	uint8_t shader; 	// shader type 
	uint8_t light; // light level + palette
	uint8_t u0,v0; // UV coords 
	uint16_t vt0,vt1,vt2,vt3; 	// vertices of face
} qdFace; 

// 16 bytes
typedef struct { 
	int16_t x; 
	int16_t y;
	int16_t z;
	uint16_t vertnum;
	uint16_t facenum; 
	qdVertex* vertex;
	qdFace* face;
} qdObject; 


#define spriteSize(n) (n>>2)
// 19 bytes 
typedef struct { 
	int16_t x,y,z; // world position 
	uint8_t u,v;  // texture uv
	uint8_t hw,hh;  // half width/height.
	uint8_t depth; // screen position and depth
	int16_t xs,xe;
	int16_t ys,ye;
} qdSprite; 


// 20 bytes
struct qd_face_cached {  
	uint8_t shader; 
	uint8_t light;
	uint8_t u0,v0;	
	int8_t x0,y0;
	int16_t ay,ax,by,bx,cy,cx;
	uint16_t next;
}; 

#endif 
