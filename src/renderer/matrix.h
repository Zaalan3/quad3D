
//24 bytes
typedef struct { 
	int16_t m00,m01,m02; 
	int16_t m10,m11,m12;
	int16_t m20,m21,m22; 
	int16_t x,y,z;
} translation_matrix_t;


// transforms source vertices and stores them at the destination(Safe for self modification)
void transformVertices(translation_matrix_t* matrix,vertex_t* src,vertex_t* dest,int num); 

// builds a matrix from provided angles
void eulerToMatrix(translation_matrix_t* matrix,uint8_t ax,uint8_t ay,uint8_t az); 

