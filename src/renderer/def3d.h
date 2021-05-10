#ifndef DEF3D
#define DEF3D  

// type defines 

// 6 bytes
typedef struct { 
	int16_t x; 
	int16_t y; 
	int16_t z;
} vertex_t; 

// 12 bytes 
typedef struct {
	uint8_t shader; 	// shader type 
	uint16_t vt0,vt1,vt2,vt3; 	// vertices of face
	uint8_t u0,v0; // UV coords 
	uint8_t light; // light level + palette
} face_t; 

typedef struct { 
	int16_t x; 
	int16_t y;
	int16_t z;
	uint8_t ax,ay,az;
	uint16_t vertnum;
	uint16_t facenum; 
	vertex_t* vertex;
	face_t* face;
} object_t; 

#define LEFT 0b00001000
#define RIGHT 0b00000100
#define TOP 0b00000010
#define BOTTOM 0b00000001
#define OOB 0xFF

// 6 bytes 
typedef struct { 
	int16_t xs,ys; // screen position
	uint8_t depth; // z 
	uint8_t outcode; // clipping outcode  
} vertex_cached_t; 

// 22 bytes
typedef struct {  
	uint8_t shader; 
	uint8_t light;
	uint8_t u0,v0;	
	int16_t x0,y0;
	int16_t ay,ax,by,bx,cy,cx;
	uint16_t next;
} face_cached_t; 

#endif 
