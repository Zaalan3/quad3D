//Model from grid.obj
#include "quad/quad.h" 


static const qdVertex verts[45];
static const qdFace faces[32];
qdObject grid = {0,0,0,45,32,verts,faces};
static const qdFace faces[32] = { 
	{SHADER_TEXTURED,0,0,0,0,1,10,9},
	{SHADER_TEXTURED,0,0,0,1,2,11,10},
	{SHADER_TEXTURED,0,0,0,2,3,12,11},
	{SHADER_TEXTURED,0,0,0,3,4,13,12},
	{SHADER_TEXTURED,0,0,0,4,5,14,13},
	{SHADER_TEXTURED,0,0,0,5,6,15,14},
	{SHADER_TEXTURED,0,0,0,6,7,16,15},
	{SHADER_TEXTURED,0,0,0,7,8,17,16},
	{SHADER_TEXTURED,0,0,0,9,10,19,18},
	{SHADER_TEXTURED,0,0,0,10,11,20,19},
	{SHADER_TEXTURED,0,0,0,11,12,21,20},
	{SHADER_TEXTURED,0,0,0,12,13,22,21},
	{SHADER_TEXTURED,0,0,0,13,14,23,22},
	{SHADER_TEXTURED,0,0,0,14,15,24,23},
	{SHADER_TEXTURED,0,0,0,15,16,25,24},
	{SHADER_TEXTURED,0,0,0,16,17,26,25},
	{SHADER_TEXTURED,0,0,0,18,19,28,27},
	{SHADER_TEXTURED,0,0,0,19,20,29,28},
	{SHADER_TEXTURED,0,0,0,20,21,30,29},
	{SHADER_TEXTURED,0,0,0,21,22,31,30},
	{SHADER_TEXTURED,0,0,0,22,23,32,31},
	{SHADER_TEXTURED,0,0,0,23,24,33,32},
	{SHADER_TEXTURED,0,0,0,24,25,34,33},
	{SHADER_TEXTURED,0,0,0,25,26,35,34},
	{SHADER_TEXTURED,0,0,0,27,28,37,36},
	{SHADER_TEXTURED,0,0,0,28,29,38,37},
	{SHADER_TEXTURED,0,0,0,29,30,39,38},
	{SHADER_TEXTURED,0,0,0,30,31,40,39},
	{SHADER_TEXTURED,0,0,0,31,32,41,40},
	{SHADER_TEXTURED,0,0,0,32,33,42,41},
	{SHADER_TEXTURED,0,0,0,33,34,43,42},
	{SHADER_TEXTURED,0,0,0,34,35,44,43}
};
static const qdVertex verts[45] = { 
	{96,128,128},
	{104,128,128},
	{112,128,128},
	{120,128,128},
	{128,128,128},
	{136,128,128},
	{144,128,128},
	{152,128,128},
	{160,128,128},
	{96,128,120},
	{104,128,120},
	{112,128,120},
	{120,128,120},
	{128,128,120},
	{136,128,120},
	{144,128,120},
	{152,128,120},
	{160,128,120},
	{96,128,112},
	{104,128,112},
	{112,128,112},
	{120,128,112},
	{128,128,112},
	{136,128,112},
	{144,128,112},
	{152,128,112},
	{160,128,112},
	{96,128,104},
	{104,128,104},
	{112,128,104},
	{120,128,104},
	{128,128,104},
	{136,128,104},
	{144,128,104},
	{152,128,104},
	{160,128,104},
	{96,128,96},
	{104,128,96},
	{112,128,96},
	{120,128,96},
	{128,128,96},
	{136,128,96},
	{144,128,96},
	{152,128,96},
	{160,128,96}
};
