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

extern qdObject grid;
extern qdObject monkey;  
extern qdObject zelda;  

#define startTimer() timer_1_Counter = 0; \
					timer_Control = TIMER1_ENABLE|TIMER1_CPU|TIMER1_UP;
#define stopTimer() timer_Control = TIMER1_DISABLE; 
#define getTimer() timer_1_Counter

int main(void)
{
	uint8_t ay = 128;
	uint8_t ax = 0; 
	uint8_t az = 0;
	qdSprite spr = {0,20,-30,0,0,8,8}; 
	qdSprite spr2 = {50,20,-30,16,0,8,8}; 

	qdCameraMatrix.x = 0;
	qdCameraMatrix.y = 4;
	qdCameraMatrix.z = 22;
	
    qdInit();
	loadTextureMapCompressed(tileset_compressed);
	gfx_SetPalette(global_palette,32,0);
	
	qdActiveObject[0] = &grid;
	//qdActiveObject[1] = &zelda;
	qdNumObjects = 1;
	qdActiveSprite[0] = spr;
	qdActiveSprite[1] = spr2; 
	
	qdNumSprites = 2;
	
	gfx_SetColor(0xFF); 
	
	gfx_HorizLine(80,59,160);
	gfx_HorizLine(80,180,160);
	gfx_VertLine(79,60,120);
	gfx_VertLine(240,60,120);
	gfx_SetTextBGColor(0x00);
	gfx_SetTextFGColor(0xFF);
	gfx_SetTextTransparentColor(0xFE);
	gfx_SetColor(0xFF);
	
	
	
	kb_SetMode(MODE_3_CONTINUOUS);
	while(!kb_IsDown(kb_KeyClear)) { 
		qdSetCameraAngle(ax,ay,az);
		
		if(kb_IsDown(kb_Key4)) { 
			qdCameraMatrix.x--; 
		} else if(kb_IsDown(kb_Key6)) { 
			qdCameraMatrix.x++; 
		} 
		
		if(kb_IsDown(kb_KeyUp)) { 
			qdCameraMatrix.y++; 
		} else if(kb_IsDown(kb_KeyDown)) { 
			qdCameraMatrix.y--; 
		} 
		
		if(kb_IsDown(kb_Key8)) { 
			qdCameraMatrix.z--; 
		} else if(kb_IsDown(kb_Key2)) { 
			qdCameraMatrix.z++; 
		}
		
		if(kb_IsDown(kb_KeyLeft)) { 
			ay+=3; 
		} else if(kb_IsDown(kb_KeyRight)) { 
			ay-=3; 
		} 
		
		/*
		if(kb_IsDown(kb_Key5)) { 
		// TODO: figure out switch statements for non integers 
			if(qdActiveObject[1] == &zelda)
				qdActiveObject[1] = &monkey;
			else 
				qdActiveObject[1] = &zelda; 
		}  
		*/ 
		
		startTimer(); 
		qdRender(); 
		stopTimer();
		int time = getTimer(); 
		
		gfx_Wait();
		qdBlitCanvas();
		
		gfx_SetTextXY(0,0);
		gfx_PrintUInt(time,8);
		gfx_PrintChar(' '); 
		gfx_PrintUInt(ax,3);
		gfx_PrintChar(' '); 
		gfx_PrintUInt(ay,3);
		gfx_PrintChar(' '); 
		gfx_PrintUInt(az,3);

	} 
		
	qdClose();
}
