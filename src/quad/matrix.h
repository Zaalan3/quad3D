
//24 bytes
// 4.12 fixed point matrix with a 16 bit position
typedef struct { 
	int16_t m00,m01,m02; 
	int16_t m10,m11,m12;
	int16_t m20,m21,m22; 
	int16_t x,y,z;
} qdMatrix;


// transforms source vertices and stores them at the destination(Safe for self modification)
void qdTransformVertices(qdMatrix* matrix,qdVertex* src,qdVertex* dest,int num); 

// builds a matrix from provided angles
void qdEulerToMatrix(qdMatrix* matrix,uint16_t ax,uint16_t ay,uint16_t az); 

