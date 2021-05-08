#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include <tice.h>
#include <compression.h>
/* Standard headers (recommended) */
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <graphx.h>
#include <keypadc.h>

#include "renderer/renderer.h" 
#include "gfx/gfx.h"

extern object_t squareModel;

#define startTimer() timer_1_Counter = 0; \
					timer_Control = TIMER1_ENABLE|TIMER1_CPU|TIMER1_UP;
#define stopTimer() timer_Control = TIMER1_DISABLE; 
#define getTimer() timer_1_Counter

int main(void)
{
	uint8_t ay = 90;
	uint8_t ax = 0; 
	uint8_t az = 0;
	vertex_t pos = {64,0,64};
	vertex_t* rotatedVerts; 
	translation_matrix_t tempMatrix; 
	
    initRenderer();
	gfx_SetPalette(global_palette,sizeof_global_palette,0); 
	loadTextureMapCompressed(tileset_compressed);	

	rotatedVerts = (vertex_t *)malloc(sizeof(vertex_t)*squareModel.vertnum); 
	eulerToMatrix(&tempMatrix,30,50,100); 
	tempMatrix.x = 0;
	tempMatrix.y = 0;
	tempMatrix.z = 0;
	transformVertices(&tempMatrix,squareModel.vertex,rotatedVerts,squareModel.vertnum); 
	squareModel.vertex = rotatedVerts; 
	
	activeObject[0] = &squareModel;
	numObjects = 1;
	
	gfx_SetColor(0xFF); 
	
	gfx_HorizLine(80,59,160);
	gfx_HorizLine(80,180,160);
	gfx_VertLine(79,60,120);
	gfx_VertLine(240,60,120);
	gfx_SetTextBGColor(0x00);
	gfx_SetTextFGColor(0xFF);
	gfx_SetTextTransparentColor(0xFE);
	gfx_SetColor(0xFF);
	
	
	setCameraAngle(ax,ay,az);
	setCameraPosition(&pos);
	kb_Scan();
	while(!kb_IsDown(kb_KeyClear)) { 
			
		if(kb_IsDown(kb_KeyLeft)) { 
			pos.x--; 
		} else if(kb_IsDown(kb_KeyRight)) { 
			pos.x++; 
		} 
		
		if(kb_IsDown(kb_KeyUp)) { 
			pos.z--; 
		} else if(kb_IsDown(kb_KeyDown)) { 
			pos.z++; 
		} 
		
		setCameraPosition(&pos);
		clearCanvas();
		startTimer(); 
		renderObjects(); 
		stopTimer();
		gfx_Wait();
		blitCanvas();
		
		gfx_SetTextXY(0,0);
		gfx_PrintUInt(getTimer(),6);

		kb_Scan(); 
	} 
	
	free(rotatedVerts);
	
	closeRenderer();
}
