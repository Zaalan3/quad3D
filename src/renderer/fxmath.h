#ifndef FXMATH
#define FXMATH

//https://www.cemetech.net/forum/viewtopic.php?p=253204
int sqrtInt(int x); 
 
// fixed 8.8 -> 8.8 operations 
int fxMul(int x,int y); 

int fxDiv(int num,int dem); 

// angle in 360 degrees/256 (1.40625)  
int fxSin(uint8_t angle); 

#define fxCos(a) fxSin(a+64)  

// returns 0.16 reciprocal of an unsigned number
int fxGetRecip(int x); 

// multiplies signed 16 bit i with unsigned reciprocal
int fxMulRecip(int i,int recip);

#endif