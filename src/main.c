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

qdObject active;
qdVertex tempVerts[550];

qdSprite spr = {0,20,-30,0,0,spriteSize(16),spriteSize(16)}; 
qdSprite spr2 = {20,20,-30,16,0,spriteSize(32),spriteSize(16)}; 

int main(void)
{
	uint16_t ay = 512;
	uint16_t ax = 0; 
	uint16_t az = 0;
	
	uint16_t ty = 0;
	uint8_t upTimer = 0;
	qdMatrix tempMatrix = {0};	
	bool last5 = false;
	
	active = grid;
	active.vertex = tempVerts;
	qdSprite sprites[2] = {spr,spr2};
	qdObject* currentModel = &grid; 
		
    qdInit();
	loadTextureMapCompressed(0,tileset_compressed);
	gfx_SetPalette(global_palette,sizeof_global_palette,0);
	
	qdSetCameraPosition(0,16,40);
		
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
		
		
		if(kb_IsDown(kb_Key5) && !last5) { 
			
			if(currentModel == &grid) { 
				active = zelda;
				active.vertex = tempVerts;
				currentModel = &zelda;
			} else if(currentModel == &zelda) { 
				active = monkey;
				active.vertex = tempVerts;
				currentModel = &monkey;
			} else { 
				active = grid;
				active.vertex = tempVerts;
				currentModel = &grid;
			} 
			
			last5 = true;
		} else if ( !kb_IsDown(kb_Key5) ) { 
			last5 = false; 
		} 
		
		
		qdEulerToMatrix(&tempMatrix,0,ty,0);
		ty += 8;
		
		timer_Set(1,0); 
		timer_Enable(1,TIMER_CPU,TIMER_NOINT,TIMER_UP);
		
		qdTransformVertices(&tempMatrix,currentModel->vertex,tempVerts,active.numVerts);
		
		timer_Disable(1); 
		int time1 = timer_Get(1);
		
		
		if(upTimer++ == 60) { 
			if (active.uOffset == 32)
				active.uOffset = 0; 
			else 
				active.uOffset += 16;
			
			upTimer = 0;
		} 
		
		qdClearCanvas(); 
		
		timer_Set(1,0); 
		timer_Enable(1,TIMER_CPU,TIMER_NOINT,TIMER_UP);
		qdRenderObject(&active);
		qdRenderSprites(sprites,2);
		gfx_SetTextXY(100,0);
		gfx_PrintUInt(*((uint24_t*)0xE30B80),3); // # faces drawn
		qdDraw(); 
		
		timer_Disable(1); 
		int time2 = timer_Get(1); 
		
		gfx_Wait();
		qdBlitCanvas(&gfx_vbuffer[60][80]);
		
		gfx_SetTextXY(1,0);
		gfx_PrintUInt(time2,8);
		gfx_SetTextXY(70,0); 
		gfx_PrintUInt(active.numVerts,3);
		gfx_SetTextXY(280,0);
		gfx_PrintUInt(ay,3);
		gfx_SetTextXY(0,16);
		gfx_PrintUInt(time1,8);

	} 
		
	qdClose();
}
