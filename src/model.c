#include "renderer/renderer.h" 

qdVertex squareVerts[8] = { 
	{4,4,-4},
	{4,-4,-4},
	{4,4,4},
	{4,-4,4},
	{-4,4,-4},
	{-4,-4,-4},
	{-4,4,4},
	{-4,-4,4},
}; 

qdFace squareFaces[6] = { 
	{0,0,16,0,0,4,6,2},
	{0,0,16,0,3,2,6,7},
	{0,0,16,0,7,6,4,5},
	{0,0,16,0,5,1,3,7},
	{0,0,16,0,1,0,2,3},
	{0,0,16,0,5,4,0,1},
};


qdObject squareModel = {80,0,80,8,6,squareVerts,squareFaces}; 