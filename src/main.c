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

#include "quad/quad.h" 
#include "gfx/gfx.h"

extern qdObject grid;
extern qdObject monkey;  
extern qdObject zelda;

qdVertex tempVerts[550]; 

int main(void)
{
	uint8_t ay = 128;
	uint8_t ax = 0; 
	uint8_t az = 0;
	
	uint8_t ty = 0;
	
	qdMatrix tempMatrix = {0};
	
	bool last5 = false;
	
	qdSprite spr = {0,20,-30,0,0,8,8}; 
	qdSprite spr2 = {20,20,-30,16,0,8,8}; 
	qdObject* currentModel = &grid; 
	
	qdSetCameraPosition(0,16,40); 
	
    qdInit();
	loadTextureMapCompressed(tileset_compressed);
	gfx_SetPalette(global_palette,sizeof_global_palette,0);
	
	qdActiveObject[0] = grid;
	qdActiveObject[0].vertex = tempVerts;
	qdNumObjects = 1;
	qdActiveSprite[0] = spr;
	qdActiveSprite[1] = spr2; 
	qdNumSprites = 0;
		
	gfx_SetColor(0xFF); 
	
	// white box to show bounds of rendering area 
	gfx_HorizLine(80,59,160);
	gfx_HorizLine(80,180,160);
	gfx_VertLine(79,60,120);
	gfx_VertLine(240,60,120);
	gfx_SetTextBGColor(0x00);
	gfx_SetTextFGColor(0xFF);
	gfx_SetTextTransparentColor(0xFE);
	gfx_SetColor(0xFF);
	
	
	// model showcase loop 
	kb_SetMode(MODE_3_CONTINUOUS);
	while(!kb_IsDown(kb_KeyClear)) {
		
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
		
		
		if(kb_IsDown(kb_Key5) && !last5) { 
			qdNumSprites = 0;
			
			if(currentModel == &grid) { 
				qdActiveObject[0] = zelda;
				qdActiveObject[0].vertex = tempVerts;
				currentModel = &zelda;
			} else if(currentModel == &zelda) { 
				qdActiveObject[0] = monkey;
				qdActiveObject[0].vertex = tempVerts;
				currentModel = &monkey;
			} else { 
				qdActiveObject[0] = grid;
				qdActiveObject[0].vertex = tempVerts;
				currentModel = &grid;
				qdNumSprites = 2; 
			} 
			
			last5 = true;
		} else if ( !kb_IsDown(kb_Key5) ) { 
			last5 = false; 
		} 
		
		qdEulerToMatrix(&tempMatrix,0,ty,0);
		ty += 2;
		
		timer_Set(1,0); 
		timer_Enable(1,TIMER_CPU,TIMER_NOINT,TIMER_UP);
		
		qdTransformVertices(&tempMatrix,currentModel->vertex,tempVerts,qdActiveObject[0].numVerts);
		
		timer_Disable(1); 
		int time1 = timer_Get(1);
		
		qdSetCameraAngle(ax,ay,az);

		timer_Set(1,0); 
		timer_Enable(1,TIMER_CPU,TIMER_NOINT,TIMER_UP); 
		qdRender(); 
		timer_Disable(1); 
		int time2 = timer_Get(1); 
		
		gfx_Wait();
		qdBlitCanvas(&gfx_vbuffer[60][80]);
		
		gfx_SetTextXY(1,0);
		gfx_PrintUInt(time2,8);
		gfx_SetTextXY(70,0); 
		gfx_PrintUInt(qdActiveObject[0].numVerts,3);
		gfx_SetTextXY(280,0);
		gfx_PrintUInt(ay,3);
		gfx_SetTextXY(0,16);
		gfx_PrintUInt(time1,8);

	} 
		
	qdClose();
}
