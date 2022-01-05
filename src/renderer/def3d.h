#ifndef DEF3D
#define DEF3D  

// type defines 

// 6 bytes
typedef struct { 
	int16_t x; 
	int16_t y; 
	int16_t z;
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


// 16 bytes 
typedef struct { 
	int16_t x,y,z; // world position 
	uint8_t u,v,w,h; // texture uv and width/height 
	int16_t xs,ys; // screen position 
	uint8_t depth; // z 
	uint8_t outcode; // clipping outcode
} qdSprite; 

#define TOP 0b00001000
#define BOTTOM 0b00000100
#define LEFT 0b00000010
#define RIGHT 0b00000001 
#define OOB 0xFF

// 8 bytes 
struct qd_vertex_cached { 
	int16_t xs,ys; // screen position
	uint8_t depth; // z 
	uint8_t outcode; // clipping outcode  
	uint8_t rs0,rs1; // reserved
} ; 


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
