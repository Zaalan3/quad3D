//Model from monkey.obj

#include "renderer/renderer.h"

face_t faces[499];
vertex_t verts[507];

object_t monkey = {0,0,0,0,0,0,507,499,verts,faces};
face_t faces[499] = { 
	{0,0,0,0,46,0,2,44},
	{0,0,0,0,3,1,47,45},
	{0,0,0,0,44,2,4,42},
	{0,0,0,0,5,3,45,43},
	{0,0,0,0,2,8,6,4},
	{0,0,0,0,7,9,3,5},
	{0,0,0,0,0,10,8,2},
	{0,0,0,0,9,11,1,3},
	{0,0,0,0,10,12,14,8},
	{0,0,0,0,15,13,11,9},
	{0,0,0,0,8,14,16,6},
	{0,0,0,0,17,15,9,7},
	{0,0,0,0,14,20,18,16},
	{0,0,0,0,19,21,15,17},
	{0,0,0,0,12,22,20,14},
	{0,0,0,0,21,23,13,15},
	{0,0,0,0,22,24,26,20},
	{0,0,0,0,27,25,23,21},
	{0,0,0,0,20,26,28,18},
	{0,0,0,0,29,27,21,19},
	{0,0,0,0,26,32,30,28},
	{0,0,0,0,31,33,27,29},
	{0,0,0,0,24,34,32,26},
	{0,0,0,0,33,35,25,27},
	{0,0,0,0,34,36,38,32},
	{0,0,0,0,39,37,35,33},
	{0,0,0,0,32,38,40,30},
	{0,0,0,0,41,39,33,31},
	{0,0,0,0,38,44,42,40},
	{0,0,0,0,43,45,39,41},
	{0,0,0,0,36,46,44,38},
	{0,0,0,0,45,47,37,39},
	{0,0,0,0,46,36,50,48},
	{0,0,0,0,51,37,47,49},
	{0,0,0,0,36,34,52,50},
	{0,0,0,0,53,35,37,51},
	{0,0,0,0,34,24,54,52},
	{0,0,0,0,55,25,35,53},
	{0,0,0,0,24,22,56,54},
	{0,0,0,0,57,23,25,55},
	{0,0,0,0,22,12,58,56},
	{0,0,0,0,59,13,23,57},
	{0,0,0,0,12,10,62,58},
	{0,0,0,0,63,11,13,59},
	{0,0,0,0,10,0,64,62},
	{0,0,0,0,65,1,11,63},
	{0,0,0,0,0,46,48,64},
	{0,0,0,0,49,47,1,65},
	{0,0,0,0,60,64,48,48},
	{0,0,0,0,49,65,61,61},
	{0,0,0,0,62,64,60,60},
	{0,0,0,0,61,65,63,63},
	{0,0,0,0,60,58,62,62},
	{0,0,0,0,63,59,61,61},
	{0,0,0,0,60,56,58,58},
	{0,0,0,0,59,57,61,61},
	{0,0,0,0,60,54,56,56},
	{0,0,0,0,57,55,61,61},
	{0,0,0,0,60,52,54,54},
	{0,0,0,0,55,53,61,61},
	{0,0,0,0,60,50,52,52},
	{0,0,0,0,53,51,61,61},
	{0,0,0,0,60,48,50,50},
	{0,0,0,0,51,49,61,61},
	{0,0,0,0,88,173,175,90},
	{0,0,0,0,175,174,89,90},
	{0,0,0,0,86,171,173,88},
	{0,0,0,0,174,172,87,89},
	{0,0,0,0,84,169,171,86},
	{0,0,0,0,172,170,85,87},
	{0,0,0,0,82,167,169,84},
	{0,0,0,0,170,168,83,85},
	{0,0,0,0,80,165,167,82},
	{0,0,0,0,168,166,81,83},
	{0,0,0,0,78,91,145,163},
	{0,0,0,0,146,92,79,164},
	{0,0,0,0,91,93,147,145},
	{0,0,0,0,148,94,92,146},
	{0,0,0,0,93,95,149,147},
	{0,0,0,0,150,96,94,148},
	{0,0,0,0,95,97,151,149},
	{0,0,0,0,152,98,96,150},
	{0,0,0,0,97,99,153,151},
	{0,0,0,0,154,100,98,152},
	{0,0,0,0,99,101,155,153},
	{0,0,0,0,156,102,100,154},
	{0,0,0,0,101,103,157,155},
	{0,0,0,0,158,104,102,156},
	{0,0,0,0,103,105,159,157},
	{0,0,0,0,160,106,104,158},
	{0,0,0,0,105,107,161,159},
	{0,0,0,0,162,108,106,160},
	{0,0,0,0,107,66,67,161},
	{0,0,0,0,67,66,108,162},
	{0,0,0,0,109,127,159,161},
	{0,0,0,0,160,128,110,162},
	{0,0,0,0,127,178,157,159},
	{0,0,0,0,158,179,128,160},
	{0,0,0,0,125,155,157,178},
	{0,0,0,0,158,156,126,179},
	{0,0,0,0,123,153,155,125},
	{0,0,0,0,156,154,124,126},
	{0,0,0,0,121,151,153,123},
	{0,0,0,0,154,152,122,124},
	{0,0,0,0,119,149,151,121},
	{0,0,0,0,152,150,120,122},
	{0,0,0,0,117,147,149,119},
	{0,0,0,0,150,148,118,120},
	{0,0,0,0,115,145,147,117},
	{0,0,0,0,148,146,116,118},
	{0,0,0,0,113,163,145,115},
	{0,0,0,0,146,164,114,116},
	{0,0,0,0,113,180,176,163},
	{0,0,0,0,176,181,114,164},
	{0,0,0,0,109,161,67,111},
	{0,0,0,0,67,162,110,112},
	{0,0,0,0,111,67,177,182},
	{0,0,0,0,177,67,112,183},
	{0,0,0,0,176,180,182,177},
	{0,0,0,0,183,181,176,177},
	{0,0,0,0,134,136,175,173},
	{0,0,0,0,175,136,135,174},
	{0,0,0,0,132,134,173,171},
	{0,0,0,0,174,135,133,172},
	{0,0,0,0,130,132,171,169},
	{0,0,0,0,172,133,131,170},
	{0,0,0,0,165,186,184,167},
	{0,0,0,0,185,187,166,168},
	{0,0,0,0,130,169,167,184},
	{0,0,0,0,168,170,131,185},
	{0,0,0,0,143,189,188,186},
	{0,0,0,0,188,189,144,187},
	{0,0,0,0,184,186,188,68},
	{0,0,0,0,188,187,185,68},
	{0,0,0,0,129,130,184,68},
	{0,0,0,0,185,131,129,68},
	{0,0,0,0,141,192,190,143},
	{0,0,0,0,191,193,142,144},
	{0,0,0,0,139,194,192,141},
	{0,0,0,0,193,195,140,142},
	{0,0,0,0,138,196,194,139},
	{0,0,0,0,195,197,138,140},
	{0,0,0,0,137,70,196,138},
	{0,0,0,0,197,70,137,138},
	{0,0,0,0,189,143,190,69},
	{0,0,0,0,191,144,189,69},
	{0,0,0,0,69,190,205,207},
	{0,0,0,0,206,191,69,207},
	{0,0,0,0,70,198,199,196},
	{0,0,0,0,200,198,70,197},
	{0,0,0,0,196,199,201,194},
	{0,0,0,0,202,200,197,195},
	{0,0,0,0,194,201,203,192},
	{0,0,0,0,204,202,195,193},
	{0,0,0,0,192,203,205,190},
	{0,0,0,0,206,204,193,191},
	{0,0,0,0,198,203,201,199},
	{0,0,0,0,202,204,198,200},
	{0,0,0,0,198,207,205,203},
	{0,0,0,0,206,207,198,204},
	{0,0,0,0,138,139,163,176},
	{0,0,0,0,164,140,138,176},
	{0,0,0,0,139,141,210,163},
	{0,0,0,0,211,142,140,164},
	{0,0,0,0,141,143,212,210},
	{0,0,0,0,213,144,142,211},
	{0,0,0,0,143,186,165,212},
	{0,0,0,0,166,187,144,213},
	{0,0,0,0,80,208,212,165},
	{0,0,0,0,213,209,81,166},
	{0,0,0,0,208,214,210,212},
	{0,0,0,0,211,215,209,213},
	{0,0,0,0,78,163,210,214},
	{0,0,0,0,211,164,79,215},
	{0,0,0,0,130,129,71,221},
	{0,0,0,0,71,129,131,222},
	{0,0,0,0,132,130,221,219},
	{0,0,0,0,222,131,133,220},
	{0,0,0,0,134,132,219,217},
	{0,0,0,0,220,133,135,218},
	{0,0,0,0,136,134,217,216},
	{0,0,0,0,218,135,136,216},
	{0,0,0,0,216,217,228,230},
	{0,0,0,0,229,218,216,230},
	{0,0,0,0,217,219,226,228},
	{0,0,0,0,227,220,218,229},
	{0,0,0,0,219,221,224,226},
	{0,0,0,0,225,222,220,227},
	{0,0,0,0,221,71,223,224},
	{0,0,0,0,223,71,222,225},
	{0,0,0,0,223,230,228,224},
	{0,0,0,0,229,230,223,225},
	{0,0,0,0,224,228,226,226},
	{0,0,0,0,227,229,225,225},
	{0,0,0,0,182,180,233,231},
	{0,0,0,0,234,181,183,232},
	{0,0,0,0,111,182,231,253},
	{0,0,0,0,232,183,112,254},
	{0,0,0,0,109,111,253,255},
	{0,0,0,0,254,112,110,256},
	{0,0,0,0,180,113,251,233},
	{0,0,0,0,252,114,181,234},
	{0,0,0,0,113,115,249,251},
	{0,0,0,0,250,116,114,252},
	{0,0,0,0,115,117,247,249},
	{0,0,0,0,248,118,116,250},
	{0,0,0,0,117,119,245,247},
	{0,0,0,0,246,120,118,248},
	{0,0,0,0,119,121,243,245},
	{0,0,0,0,244,122,120,246},
	{0,0,0,0,121,123,241,243},
	{0,0,0,0,242,124,122,244},
	{0,0,0,0,123,125,239,241},
	{0,0,0,0,240,126,124,242},
	{0,0,0,0,125,178,235,239},
	{0,0,0,0,236,179,126,240},
	{0,0,0,0,178,127,237,235},
	{0,0,0,0,238,128,179,236},
	{0,0,0,0,127,109,255,237},
	{0,0,0,0,256,110,128,238},
	{0,0,0,0,237,255,257,275},
	{0,0,0,0,258,256,238,276},
	{0,0,0,0,235,237,275,277},
	{0,0,0,0,276,238,236,278},
	{0,0,0,0,239,235,277,273},
	{0,0,0,0,278,236,240,274},
	{0,0,0,0,241,239,273,271},
	{0,0,0,0,274,240,242,272},
	{0,0,0,0,243,241,271,269},
	{0,0,0,0,272,242,244,270},
	{0,0,0,0,245,243,269,267},
	{0,0,0,0,270,244,246,268},
	{0,0,0,0,247,245,267,265},
	{0,0,0,0,268,246,248,266},
	{0,0,0,0,249,247,265,263},
	{0,0,0,0,266,248,250,264},
	{0,0,0,0,251,249,263,261},
	{0,0,0,0,264,250,252,262},
	{0,0,0,0,233,251,261,279},
	{0,0,0,0,262,252,234,280},
	{0,0,0,0,255,253,259,257},
	{0,0,0,0,260,254,256,258},
	{0,0,0,0,253,231,281,259},
	{0,0,0,0,282,232,254,260},
	{0,0,0,0,231,233,279,281},
	{0,0,0,0,280,234,232,282},
	{0,0,0,0,66,107,283,72},
	{0,0,0,0,284,108,66,72},
	{0,0,0,0,107,105,285,283},
	{0,0,0,0,286,106,108,284},
	{0,0,0,0,105,103,287,285},
	{0,0,0,0,288,104,106,286},
	{0,0,0,0,103,101,289,287},
	{0,0,0,0,290,102,104,288},
	{0,0,0,0,101,99,291,289},
	{0,0,0,0,292,100,102,290},
	{0,0,0,0,99,97,293,291},
	{0,0,0,0,294,98,100,292},
	{0,0,0,0,97,95,295,293},
	{0,0,0,0,296,96,98,294},
	{0,0,0,0,95,93,297,295},
	{0,0,0,0,298,94,96,296},
	{0,0,0,0,93,91,299,297},
	{0,0,0,0,300,92,94,298},
	{0,0,0,0,307,308,327,337},
	{0,0,0,0,328,308,307,338},
	{0,0,0,0,306,307,337,335},
	{0,0,0,0,338,307,306,336},
	{0,0,0,0,305,306,335,339},
	{0,0,0,0,336,306,305,340},
	{0,0,0,0,88,90,305,339},
	{0,0,0,0,305,90,89,340},
	{0,0,0,0,86,88,339,333},
	{0,0,0,0,340,89,87,334},
	{0,0,0,0,84,86,333,329},
	{0,0,0,0,334,87,85,330},
	{0,0,0,0,82,84,329,331},
	{0,0,0,0,330,85,83,332},
	{0,0,0,0,329,335,337,331},
	{0,0,0,0,338,336,330,332},
	{0,0,0,0,329,333,339,335},
	{0,0,0,0,340,334,330,336},
	{0,0,0,0,325,331,337,327},
	{0,0,0,0,338,332,326,328},
	{0,0,0,0,80,82,331,325},
	{0,0,0,0,332,83,81,326},
	{0,0,0,0,208,341,343,214},
	{0,0,0,0,344,342,209,215},
	{0,0,0,0,80,325,341,208},
	{0,0,0,0,342,326,81,209},
	{0,0,0,0,78,214,343,345},
	{0,0,0,0,344,215,79,346},
	{0,0,0,0,78,345,299,91},
	{0,0,0,0,300,346,79,92},
	{0,0,0,0,76,323,351,303},
	{0,0,0,0,352,324,76,303},
	{0,0,0,0,303,351,349,77},
	{0,0,0,0,350,352,303,77},
	{0,0,0,0,77,349,347,304},
	{0,0,0,0,348,350,77,304},
	{0,0,0,0,304,347,327,308},
	{0,0,0,0,328,348,304,308},
	{0,0,0,0,325,327,347,341},
	{0,0,0,0,348,328,326,342},
	{0,0,0,0,295,297,317,309},
	{0,0,0,0,318,298,296,310},
	{0,0,0,0,75,315,323,76},
	{0,0,0,0,324,316,75,76},
	{0,0,0,0,301,357,355,302},
	{0,0,0,0,356,358,301,302},
	{0,0,0,0,302,355,353,74},
	{0,0,0,0,354,356,302,74},
	{0,0,0,0,74,353,315,75},
	{0,0,0,0,316,354,74,75},
	{0,0,0,0,291,293,361,363},
	{0,0,0,0,362,294,292,364},
	{0,0,0,0,363,361,367,365},
	{0,0,0,0,368,362,364,366},
	{0,0,0,0,365,367,369,371},
	{0,0,0,0,370,368,366,372},
	{0,0,0,0,371,369,375,373},
	{0,0,0,0,376,370,372,374},
	{0,0,0,0,313,377,373,375},
	{0,0,0,0,374,378,314,376},
	{0,0,0,0,315,353,373,377},
	{0,0,0,0,374,354,316,378},
	{0,0,0,0,353,355,371,373},
	{0,0,0,0,372,356,354,374},
	{0,0,0,0,355,357,365,371},
	{0,0,0,0,366,358,356,372},
	{0,0,0,0,357,359,363,365},
	{0,0,0,0,364,360,358,366},
	{0,0,0,0,289,291,363,359},
	{0,0,0,0,364,292,290,360},
	{0,0,0,0,73,359,357,301},
	{0,0,0,0,358,360,73,301},
	{0,0,0,0,283,285,287,289},
	{0,0,0,0,288,286,284,290},
	{0,0,0,0,283,289,359,73},
	{0,0,0,0,360,290,284,73},
	{0,0,0,0,293,295,309,361},
	{0,0,0,0,310,296,294,362},
	{0,0,0,0,309,311,367,361},
	{0,0,0,0,368,312,310,362},
	{0,0,0,0,311,381,369,367},
	{0,0,0,0,370,382,312,368},
	{0,0,0,0,313,375,369,381},
	{0,0,0,0,370,376,314,382},
	{0,0,0,0,347,349,385,383},
	{0,0,0,0,386,350,348,384},
	{0,0,0,0,317,383,385,319},
	{0,0,0,0,386,384,318,320},
	{0,0,0,0,297,299,383,317},
	{0,0,0,0,384,300,298,318},
	{0,0,0,0,299,343,341,383},
	{0,0,0,0,342,344,300,384},
	{0,0,0,0,341,347,383,383},
	{0,0,0,0,384,348,342,342},
	{0,0,0,0,299,345,343,343},
	{0,0,0,0,344,346,300,300},
	{0,0,0,0,313,321,379,377},
	{0,0,0,0,380,322,314,378},
	{0,0,0,0,315,377,379,323},
	{0,0,0,0,380,378,316,324},
	{0,0,0,0,319,385,379,321},
	{0,0,0,0,380,386,320,322},
	{0,0,0,0,349,351,379,385},
	{0,0,0,0,380,352,350,386},
	{0,0,0,0,323,379,351,351},
	{0,0,0,0,352,380,324,324},
	{0,0,0,0,399,387,413,401},
	{0,0,0,0,414,388,400,402},
	{0,0,0,0,399,401,403,397},
	{0,0,0,0,404,402,400,398},
	{0,0,0,0,397,403,405,395},
	{0,0,0,0,406,404,398,396},
	{0,0,0,0,395,405,407,393},
	{0,0,0,0,408,406,396,394},
	{0,0,0,0,393,407,409,391},
	{0,0,0,0,410,408,394,392},
	{0,0,0,0,391,409,411,389},
	{0,0,0,0,412,410,392,390},
	{0,0,0,0,409,419,417,411},
	{0,0,0,0,418,420,410,412},
	{0,0,0,0,407,421,419,409},
	{0,0,0,0,420,422,408,410},
	{0,0,0,0,405,423,421,407},
	{0,0,0,0,422,424,406,408},
	{0,0,0,0,403,425,423,405},
	{0,0,0,0,424,426,404,406},
	{0,0,0,0,401,427,425,403},
	{0,0,0,0,426,428,402,404},
	{0,0,0,0,401,413,415,427},
	{0,0,0,0,416,414,402,428},
	{0,0,0,0,317,319,443,441},
	{0,0,0,0,444,320,318,442},
	{0,0,0,0,319,389,411,443},
	{0,0,0,0,412,390,320,444},
	{0,0,0,0,309,317,441,311},
	{0,0,0,0,442,318,310,312},
	{0,0,0,0,381,429,413,387},
	{0,0,0,0,414,430,382,388},
	{0,0,0,0,411,417,439,443},
	{0,0,0,0,440,418,412,444},
	{0,0,0,0,437,445,443,439},
	{0,0,0,0,444,446,438,440},
	{0,0,0,0,433,445,437,435},
	{0,0,0,0,438,446,434,436},
	{0,0,0,0,431,447,445,433},
	{0,0,0,0,446,448,432,434},
	{0,0,0,0,429,447,431,449},
	{0,0,0,0,432,448,430,450},
	{0,0,0,0,413,429,449,415},
	{0,0,0,0,450,430,414,416},
	{0,0,0,0,311,447,429,381},
	{0,0,0,0,430,448,312,382},
	{0,0,0,0,311,441,445,447},
	{0,0,0,0,446,442,312,448},
	{0,0,0,0,441,443,445,445},
	{0,0,0,0,446,444,442,442},
	{0,0,0,0,415,449,451,475},
	{0,0,0,0,452,450,416,476},
	{0,0,0,0,449,431,461,451},
	{0,0,0,0,462,432,450,452},
	{0,0,0,0,431,433,459,461},
	{0,0,0,0,460,434,432,462},
	{0,0,0,0,433,435,457,459},
	{0,0,0,0,458,436,434,460},
	{0,0,0,0,435,437,455,457},
	{0,0,0,0,456,438,436,458},
	{0,0,0,0,437,439,453,455},
	{0,0,0,0,454,440,438,456},
	{0,0,0,0,439,417,473,453},
	{0,0,0,0,474,418,440,454},
	{0,0,0,0,427,415,475,463},
	{0,0,0,0,476,416,428,464},
	{0,0,0,0,425,427,463,465},
	{0,0,0,0,464,428,426,466},
	{0,0,0,0,423,425,465,467},
	{0,0,0,0,466,426,424,468},
	{0,0,0,0,421,423,467,469},
	{0,0,0,0,468,424,422,470},
	{0,0,0,0,419,421,469,471},
	{0,0,0,0,470,422,420,472},
	{0,0,0,0,417,419,471,473},
	{0,0,0,0,472,420,418,474},
	{0,0,0,0,457,455,479,477},
	{0,0,0,0,480,456,458,478},
	{0,0,0,0,477,479,481,483},
	{0,0,0,0,482,480,478,484},
	{0,0,0,0,483,481,487,485},
	{0,0,0,0,488,482,484,486},
	{0,0,0,0,485,487,489,491},
	{0,0,0,0,490,488,486,492},
	{0,0,0,0,463,475,485,491},
	{0,0,0,0,486,476,464,492},
	{0,0,0,0,451,483,485,475},
	{0,0,0,0,486,484,452,476},
	{0,0,0,0,451,461,477,483},
	{0,0,0,0,478,462,452,484},
	{0,0,0,0,457,477,461,459},
	{0,0,0,0,462,478,458,460},
	{0,0,0,0,453,473,479,455},
	{0,0,0,0,480,474,454,456},
	{0,0,0,0,471,481,479,473},
	{0,0,0,0,480,482,472,474},
	{0,0,0,0,469,487,481,471},
	{0,0,0,0,482,488,470,472},
	{0,0,0,0,467,489,487,469},
	{0,0,0,0,488,490,468,470},
	{0,0,0,0,465,491,489,467},
	{0,0,0,0,490,492,466,468},
	{0,0,0,0,463,491,465,465},
	{0,0,0,0,466,492,464,464},
	{0,0,0,0,391,389,503,501},
	{0,0,0,0,504,390,392,502},
	{0,0,0,0,393,391,501,499},
	{0,0,0,0,502,392,394,500},
	{0,0,0,0,395,393,499,497},
	{0,0,0,0,500,394,396,498},
	{0,0,0,0,397,395,497,495},
	{0,0,0,0,498,396,398,496},
	{0,0,0,0,399,397,495,493},
	{0,0,0,0,496,398,400,494},
	{0,0,0,0,387,399,493,505},
	{0,0,0,0,494,400,388,506},
	{0,0,0,0,493,501,503,505},
	{0,0,0,0,504,502,494,506},
	{0,0,0,0,493,495,499,501},
	{0,0,0,0,500,496,494,502},
	{0,0,0,0,495,497,499,499},
	{0,0,0,0,500,498,496,496},
	{0,0,0,0,313,381,387,505},
	{0,0,0,0,388,382,314,506},
	{0,0,0,0,313,505,503,321},
	{0,0,0,0,504,506,314,322},
	{0,0,0,0,319,321,503,389},
	{0,0,0,0,504,322,320,390},
	{0,0,0,0,73,284,72,283}
};
vertex_t verts[507] = { 
	{7,3,12},
	{-7,3,12},
	{8,1,11},
	{-8,1,11},
	{9,1,9},
	{-9,1,9},
	{6,0,10},
	{-6,0,10},
	{6,1,11},
	{-6,1,11},
	{6,2,13},
	{-6,2,13},
	{4,3,13},
	{-4,3,13},
	{3,1,12},
	{-3,1,12},
	{2,1,10},
	{-2,1,10},
	{1,4,10},
	{-1,4,10},
	{2,4,12},
	{-2,4,12},
	{4,4,13},
	{-4,4,13},
	{4,5,13},
	{-4,5,13},
	{3,6,12},
	{-3,6,12},
	{3,7,10},
	{-3,7,10},
	{6,8,10},
	{-6,8,10},
	{6,7,11},
	{-6,7,11},
	{6,6,13},
	{-6,6,13},
	{7,5,12},
	{-7,5,12},
	{8,6,11},
	{-8,6,11},
	{9,7,9},
	{-9,7,9},
	{10,4,9},
	{-10,4,9},
	{9,4,11},
	{-9,4,11},
	{7,4,12},
	{-7,4,12},
	{8,4,12},
	{-8,4,12},
	{7,5,13},
	{-7,5,13},
	{6,6,13},
	{-6,6,13},
	{4,5,13},
	{-4,5,13},
	{4,4,13},
	{-4,4,13},
	{4,2,13},
	{-4,2,13},
	{6,4,13},
	{-6,4,13},
	{6,2,13},
	{-6,2,13},
	{7,3,13},
	{-7,3,13},
	{0,7,12},
	{0,6,13},
	{0,-11,12},
	{0,-5,12},
	{0,-3,13},
	{0,-12,12},
	{0,6,10},
	{0,9,9},
	{0,14,-9},
	{0,9,-14},
	{0,1,-13},
	{0,-6,-6},
	{3,-3,9},
	{-3,-3,9},
	{5,-7,9},
	{-5,-7,9},
	{6,-11,9},
	{-6,-11,9},
	{6,-14,9},
	{-6,-14,9},
	{5,-15,8},
	{-5,-15,8},
	{3,-15,9},
	{-3,-15,9},
	{0,-16,9},
	{7,-2,9},
	{-7,-2,9},
	{10,-1,9},
	{-10,-1,9},
	{13,2,7},
	{-13,2,7},
	{14,7,9},
	{-14,7,9},
	{11,8,10},
	{-11,8,10},
	{8,10,11},
	{-8,10,11},
	{5,12,12},
	{-5,12,12},
	{3,12,12},
	{-3,12,12},
	{1,8,12},
	{-1,8,12},
	{3,7,12},
	{-3,7,12},
	{2,5,12},
	{-2,5,12},
	{3,1,12},
	{-3,1,12},
	{6,0,11},
	{-6,0,11},
	{8,1,11},
	{-8,1,11},
	{10,3,10},
	{-10,3,10},
	{10,5,10},
	{-10,5,10},
	{10,6,11},
	{-10,6,11},
	{7,7,12},
	{-7,7,12},
	{4,8,12},
	{-4,8,12},
	{0,-12,12},
	{2,-12,12},
	{-2,-12,12},
	{2,-13,11},
	{-2,-13,11},
	{1,-14,11},
	{-1,-14,11},
	{0,-14,11},
	{0,-3,12},
	{0,-2,12},
	{2,-2,12},
	{-2,-2,12},
	{2,-4,12},
	{-2,-4,12},
	{1,-5,12},
	{-1,-5,12},
	{6,-1,11},
	{-6,-1,11},
	{10,1,10},
	{-10,1,10},
	{12,3,10},
	{-12,3,10},
	{12,6,11},
	{-12,6,11},
	{11,7,11},
	{-11,7,11},
	{7,9,13},
	{-7,9,13},
	{5,10,13},
	{-5,10,13},
	{3,10,14},
	{-3,10,14},
	{2,7,13},
	{-2,7,13},
	{2,-2,13},
	{-2,-2,13},
	{3,-7,11},
	{-3,-7,11},
	{4,-11,11},
	{-4,-11,11},
	{4,-13,11},
	{-4,-13,11},
	{4,-15,10},
	{-4,-15,10},
	{3,-15,10},
	{-3,-15,10},
	{0,-15,10},
	{0,1,12},
	{0,3,12},
	{5,8,12},
	{-5,8,12},
	{3,2,12},
	{-3,2,12},
	{2,3,12},
	{-2,3,12},
	{2,-11,12},
	{-2,-11,12},
	{1,-7,12},
	{-1,-7,12},
	{0,-7,12},
	{0,-5,12},
	{2,-4,12},
	{-2,-4,12},
	{2,-4,13},
	{-2,-4,13},
	{2,-2,12},
	{-2,-2,12},
	{1,-2,13},
	{-1,-2,13},
	{0,-3,13},
	{1,-2,13},
	{-1,-2,13},
	{2,-2,13},
	{-2,-2,13},
	{2,-4,13},
	{-2,-4,13},
	{1,-4,13},
	{-1,-4,13},
	{0,-5,13},
	{4,-5,9},
	{-4,-5,9},
	{3,-4,11},
	{-3,-4,11},
	{3,-5,11},
	{-3,-5,11},
	{4,-4,9},
	{-4,-4,9},
	{0,-14,11},
	{1,-14,11},
	{-1,-14,11},
	{2,-13,11},
	{-2,-13,11},
	{1,-12,12},
	{-1,-12,12},
	{0,-13,11},
	{1,-12,11},
	{-1,-12,11},
	{1,-13,10},
	{-1,-13,10},
	{1,-14,10},
	{-1,-14,10},
	{0,-14,10},
	{3,3,12},
	{-3,3,12},
	{3,2,12},
	{-3,2,12},
	{5,7,12},
	{-5,7,12},
	{4,7,12},
	{-4,7,12},
	{7,6,12},
	{-7,6,12},
	{9,6,11},
	{-9,6,11},
	{9,5,11},
	{-9,5,11},
	{9,3,11},
	{-9,3,11},
	{8,2,11},
	{-8,2,11},
	{6,1,12},
	{-6,1,12},
	{4,2,12},
	{-4,2,12},
	{3,5,12},
	{-3,5,12},
	{3,6,13},
	{-3,6,13},
	{4,6,12},
	{-4,6,12},
	{3,5,12},
	{-3,5,12},
	{4,2,12},
	{-4,2,12},
	{6,1,12},
	{-6,1,12},
	{7,2,11},
	{-7,2,11},
	{9,3,11},
	{-9,3,11},
	{9,4,11},
	{-9,4,11},
	{9,5,11},
	{-9,5,11},
	{7,6,12},
	{-7,6,12},
	{4,6,12},
	{-4,6,12},
	{5,7,12},
	{-5,7,12},
	{3,3,12},
	{-3,3,12},
	{3,4,12},
	{-3,4,12},
	{2,8,10},
	{-2,8,10},
	{3,11,10},
	{-3,11,10},
	{5,11,9},
	{-5,11,9},
	{8,9,9},
	{-8,9,9},
	{11,7,8},
	{-11,7,8},
	{13,6,7},
	{-13,6,7},
	{12,3,6},
	{-12,3,6},
	{10,0,7},
	{-10,0,7},
	{7,-1,7},
	{-7,-1,7},
	{0,14,5},
	{0,16,-1},
	{0,-3,-11},
	{0,-7,3},
	{0,-16,7},
	{0,-13,6},
	{0,-9,5},
	{0,-8,4},
	{14,4,1},
	{-14,4,1},
	{14,5,-1},
	{-14,5,-1},
	{12,4,-7},
	{-12,4,-7},
	{7,7,-11},
	{-7,7,-11},
	{12,-1,1},
	{-12,-1,1},
	{10,-2,-3},
	{-10,-2,-3},
	{10,0,-7},
	{-10,0,-7},
	{5,1,-11},
	{-5,1,-11},
	{4,-6,6},
	{-4,-6,6},
	{3,-7,4},
	{-3,-7,4},
	{5,-11,6},
	{-5,-11,6},
	{4,-8,6},
	{-4,-8,6},
	{5,-15,6},
	{-5,-15,6},
	{2,-12,6},
	{-2,-12,6},
	{2,-9,6},
	{-2,-9,6},
	{3,-15,7},
	{-3,-15,7},
	{4,-4,7},
	{-4,-4,7},
	{3,-4,8},
	{-3,-4,8},
	{3,-3,8},
	{-3,-3,8},
	{3,-6,3},
	{-3,-6,3},
	{5,-5,-4},
	{-5,-5,-4},
	{5,-2,-9},
	{-5,-2,-9},
	{7,14,-6},
	{-7,14,-6},
	{7,15,-1},
	{-7,15,-1},
	{7,14,4},
	{-7,14,4},
	{7,9,7},
	{-7,9,7},
	{12,7,5},
	{-12,7,5},
	{10,7,5},
	{-10,7,5},
	{10,11,1},
	{-10,11,1},
	{13,9,2},
	{-13,9,2},
	{13,10,-2},
	{-13,10,-2},
	{10,12,-3},
	{-10,12,-3},
	{10,11,-7},
	{-10,11,-7},
	{13,9,-6},
	{-13,9,-6},
	{10,5,-9},
	{-10,5,-9},
	{8,0,-9},
	{-8,0,-9},
	{13,5,-3},
	{-13,5,-3},
	{7,-3,2},
	{-7,-3,2},
	{7,-3,-3},
	{-7,-3,-3},
	{14,7,-4},
	{-14,7,-4},
	{12,-2,-2},
	{-12,-2,-2},
	{17,-2,-5},
	{-17,-2,-5},
	{21,1,-7},
	{-21,1,-7},
	{22,5,-7},
	{-22,5,-7},
	{20,8,-7},
	{-20,8,-7},
	{16,8,-5},
	{-16,8,-5},
	{16,7,-5},
	{-16,7,-5},
	{19,7,-6},
	{-19,7,-6},
	{20,5,-6},
	{-20,5,-6},
	{19,1,-6},
	{-19,1,-6},
	{16,-1,-5},
	{-16,-1,-5},
	{13,-1,-2},
	{-13,-1,-2},
	{15,6,-4},
	{-15,6,-4},
	{15,5,-5},
	{-15,5,-5},
	{14,0,-3},
	{-14,0,-3},
	{17,0,-6},
	{-17,0,-6},
	{19,1,-7},
	{-19,1,-7},
	{20,4,-7},
	{-20,4,-7},
	{19,6,-7},
	{-19,6,-7},
	{16,5,-6},
	{-16,5,-6},
	{13,5,-3},
	{-13,5,-3},
	{13,3,-4},
	{-13,3,-4},
	{12,2,-4},
	{-12,2,-4},
	{13,1,-4},
	{-13,1,-4},
	{14,0,-4},
	{-14,0,-4},
	{13,0,-4},
	{-13,0,-4},
	{12,0,-1},
	{-12,0,-1},
	{11,0,-3},
	{-11,0,-3},
	{11,1,-3},
	{-11,1,-3},
	{13,3,-3},
	{-13,3,-3},
	{14,4,-4},
	{-14,4,-4},
	{14,4,-5},
	{-14,4,-5},
	{13,0,-5},
	{-13,0,-5},
	{14,0,-5},
	{-14,0,-5},
	{13,1,-5},
	{-13,1,-5},
	{12,1,-5},
	{-12,1,-5},
	{14,3,-5},
	{-14,3,-5},
	{17,5,-7},
	{-17,5,-7},
	{19,6,-8},
	{-19,6,-8},
	{20,4,-8},
	{-20,4,-8},
	{19,1,-8},
	{-19,1,-8},
	{17,0,-7},
	{-17,0,-7},
	{14,0,-4},
	{-14,0,-4},
	{15,5,-6},
	{-15,5,-6},
	{14,2,-5},
	{-14,2,-5},
	{15,1,-5},
	{-15,1,-5},
	{16,2,-6},
	{-16,2,-6},
	{15,3,-6},
	{-15,3,-6},
	{16,4,-6},
	{-16,4,-6},
	{17,3,-6},
	{-17,3,-6},
	{18,3,-6},
	{-18,3,-6},
	{17,4,-6},
	{-17,4,-6},
	{16,7,-8},
	{-16,7,-8},
	{20,8,-9},
	{-20,8,-9},
	{22,5,-8},
	{-22,5,-8},
	{21,1,-9},
	{-21,1,-9},
	{17,-1,-8},
	{-17,-1,-8},
	{13,-2,-5},
	{-13,-2,-5},
	{14,6,-6},
	{-14,6,-6}
};