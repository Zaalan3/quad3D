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
extern object_t monkey;
extern object_t zelda;
extern object_t grid;

extern vertex_t verts[45];

#define startTimer() timer_1_Counter = 0; \
					timer_Control = TIMER1_ENABLE|TIMER1_CPU|TIMER1_UP;
#define stopTimer() timer_Control = TIMER1_DISABLE; 
#define getTimer() timer_1_Counter

int main(void)
{
	uint8_t ay = 128;
	uint8_t ax = 0; 
	uint8_t az = 0;
	billboard_t spr = {0,20,0,16,0}; 
	
	vertex_t pos = {0,5,40};
	
    initRenderer();
	loadTextureMapCompressed(tileset_compressed);

	activeObject[0] = &grid;
	numObjects = 1;
	gfx_SetPalette(global_palette,32,0); 
	activeSprite[0] = spr;
	numSprites = 1;
	
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
	kb_Scan();
	while(!kb_IsDown(kb_KeyClear)) { 
			
		if(kb_IsDown(kb_KeyLeft)) { 
			pos.x--; 
		} else if(kb_IsDown(kb_KeyRight)) { 
			pos.x++; 
		} 
		
		if(kb_IsDown(kb_KeyUp)) { 
			pos.y++; 
		} else if(kb_IsDown(kb_KeyDown)) { 
			pos.y--; 
		} 
		
		if(kb_IsDown(kb_Key8)) { 
			pos.z--; 
		} else if(kb_IsDown(kb_Key2)) { 
			pos.z++; 
		}
		
		if(kb_IsDown(kb_Key5)) { 
		// TODO: figure out switch statements for non integers 
			if(activeObject[0] == &grid)
				activeObject[0] = &zelda;
			else if(activeObject[0] == &zelda)
				activeObject[0] = &monkey;
			else 
				activeObject[0] = &grid; 
		} 
		
		cameraMatrix.x = pos.x;
		cameraMatrix.y = pos.y;
		cameraMatrix.z = pos.z;
		
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
		
	closeRenderer();
}
