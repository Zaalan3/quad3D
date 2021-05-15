
#include "renderer.h" 
#include <graphx.h>

translation_matrix_t cameraMatrix;

extern void projectVertices(int num,vertex_t* verts);

extern void callShader(face_cached_t* f);

#define LEFT 0b00001000
#define RIGHT 0b00000100
#define TOP 0b00000010
#define BOTTOM 0b00000001
#define OOB 0xFF

void renderObjects() {
	memset((void *)faceBucket,0xFF,sizeof(faceBucket)); 
	numFaces = 0; 
	uint24_t bucketMax = 0;
	uint24_t bucketMin = 1024;
	for(uint8_t object=0;object<numObjects;object++) { 
		object_t* obj = activeObject[object];
		bool clipped = false;
		projectVertices(obj->vertnum,obj->vertex);
	
		for(int i = 0; i<obj->facenum;i++) { 
			vertex_cached_t vt0,vt1,vt2,vt3; 
			vt0 = vertexCache[obj->face[i].vt0]; 
			vt1 = vertexCache[obj->face[i].vt1]; 
			vt2 = vertexCache[obj->face[i].vt2]; 
			vt3 = vertexCache[obj->face[i].vt3];
				
			uint8_t combinedcode = vt0.outcode|vt1.outcode|vt2.outcode|vt3.outcode;
			if (combinedcode == OOB)
				continue;
			else if(combinedcode&0b0011)	// if any point is above or below the screen
				clipped = true; 
			
			if ((vt0.outcode&vt1.outcode&vt2.outcode&vt3.outcode)) 
				continue;
			
			int bx = vt3.xs - vt0.xs; 
			int by = vt3.ys - vt0.ys;
			int cx = vt1.xs - vt0.xs;
			int cy = vt1.ys - vt0.ys;
			int dx = vt2.xs - vt0.xs;
			int dy = vt2.ys - vt0.ys;
			
			int area = dx*(cy-by) + dy*(bx - cx);
			if(area > 0) 
				continue;
			
			area = 0 - area;
			int tax = vt0.xs - vt1.xs - vt3.xs + vt2.xs;
			int tay = vt0.ys - vt1.ys - vt3.ys + vt2.ys;
			// sum of distances. Allows for better bucketing (think of it like an 8.2 depth average)
			uint24_t dsum = vt0.depth + vt1.depth + vt2.depth + vt3.depth - 1;
			
			uint24_t index = numFaces++;
			
			if(area <= 512) {
				faceCache[index].shader = (clipped)?CLIPPED_16:UNCLIPPED_16;
				faceCache[index].ax = tax; 
				faceCache[index].ay = tay; 
				faceCache[index].bx = bx*16; 
				faceCache[index].by = by*16; 
				faceCache[index].cx = cx*16; 
				faceCache[index].cy = cy*16; 
			} else { 
				faceCache[index].shader = (clipped)?CLIPPED_32:UNCLIPPED_32;
				faceCache[index].light = obj->face[i].light; 
				faceCache[index].ax = tax/4; 
				faceCache[index].ay = tay/4; 
				faceCache[index].bx = bx*8; 
				faceCache[index].by = by*8; 
				faceCache[index].cx = cx*8; 
				faceCache[index].cy = cy*8;
			} 
			faceCache[index].light = obj->face[i].light; 
			faceCache[index].v0 = obj->face[i].v0;	
			faceCache[index].u0 = obj->face[i].u0;
			faceCache[index].x0 = vt0.xs; 
			faceCache[index].y0 = vt0.ys;
			faceCache[index].next = faceBucket[dsum]; 
			faceBucket[dsum] = index;
			
			if(bucketMin>dsum)
				bucketMin=dsum; 
			if(bucketMax<dsum) 
				bucketMax=dsum;
		}
	} 
	
	uint16_t* bucket = &faceBucket[bucketMax]; 
	
	if(bucketMin>bucketMax) return; 
	
	for(uint24_t j = 0; j <= bucketMax - bucketMin; j++) {
		uint16_t index = *bucket;
		
		while(index!=0xFFFF) { 
			callShader(&faceCache[index]); 
			index = faceCache[index].next;  
		}
		
		bucket--;
	} 
	
} 