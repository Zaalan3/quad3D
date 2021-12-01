//Model from zelda.obj
#include "renderer/renderer.h"

static face_t faces[349];
static vertex_t verts[824];

object_t zelda = {0,0,0,824,349,verts,faces};
static face_t faces[349] = { 
	{0,0,0,0,11,13,12,10},
	{0,0,0,0,15,17,16,14},
	{0,0,0,0,13,15,14,12},
	{0,0,0,0,17,19,18,16},
	{0,0,0,0,5,7,6,4},
	{0,0,0,0,3,5,4,2},
	{0,0,0,0,20,21,22,22},
	{0,0,0,0,21,23,22,22},
	{0,0,0,0,22,23,24,24},
	{0,0,0,0,25,26,27,27},
	{0,0,0,0,26,28,27,27},
	{0,0,0,0,27,28,29,29},
	{0,0,0,0,30,31,32,32},
	{0,0,0,0,31,33,32,32},
	{0,0,0,0,32,33,34,34},
	{0,0,0,0,35,36,37,37},
	{0,0,0,0,36,38,37,37},
	{0,0,0,0,37,38,39,39},
	{0,0,0,0,40,41,42,42},
	{0,0,0,0,43,44,45,45},
	{0,0,0,0,46,47,48,48},
	{0,0,0,0,49,50,51,51},
	{0,0,0,0,1,3,2,0},
	{0,0,0,0,7,9,8,6},
	{0,0,0,0,53,55,54,52},
	{0,0,0,0,57,59,58,56},
	{0,0,0,0,61,63,62,60},
	{0,0,0,0,65,67,66,64},
	{0,0,0,0,68,69,70,70},
	{0,0,0,0,69,71,70,70},
	{0,0,0,0,70,71,72,72},
	{0,0,0,0,73,74,75,75},
	{0,0,0,0,700,702,701,699},
	{0,0,0,0,276,278,277,275},
	{0,0,0,0,560,562,561,559},
	{0,0,0,0,592,594,593,591},
	{0,0,0,0,564,566,565,563},
	{0,0,0,0,78,79,80,80},
	{0,0,0,0,79,81,80,80},
	{0,0,0,0,327,329,328,326},
	{0,0,0,0,82,83,84,84},
	{0,0,0,0,83,85,84,84},
	{0,0,0,0,576,578,577,575},
	{0,0,0,0,387,389,388,386},
	{0,0,0,0,640,642,641,639},
	{0,0,0,0,92,93,94,94},
	{0,0,0,0,95,97,96,96},
	{0,0,0,0,96,97,98,98},
	{0,0,0,0,97,99,98,98},
	{0,0,0,0,632,634,633,631},
	{0,0,0,0,100,101,102,102},
	{0,0,0,0,101,103,102,102},
	{0,0,0,0,102,103,104,104},
	{0,0,0,0,183,185,184,182},
	{0,0,0,0,704,706,705,703},
	{0,0,0,0,112,113,111,110},
	{0,0,0,0,112,114,113,113},
	{0,0,0,0,113,114,115,115},
	{0,0,0,0,114,116,115,115},
	{0,0,0,0,193,195,194,192},
	{0,0,0,0,117,118,119,119},
	{0,0,0,0,118,120,119,119},
	{0,0,0,0,119,120,121,121},
	{0,0,0,0,122,123,124,124},
	{0,0,0,0,123,125,124,124},
	{0,0,0,0,372,374,373,371},
	{0,0,0,0,536,538,537,535},
	{0,0,0,0,128,129,130,130},
	{0,0,0,0,129,131,130,130},
	{0,0,0,0,150,152,151,149},
	{0,0,0,0,134,135,136,136},
	{0,0,0,0,135,137,136,136},
	{0,0,0,0,136,137,138,138},
	{0,0,0,0,397,399,398,396},
	{0,0,0,0,177,178,176,175},
	{0,0,0,0,198,200,199,197},
	{0,0,0,0,145,146,147,147},
	{0,0,0,0,708,710,709,707},
	{0,0,0,0,148,150,149,149},
	{0,0,0,0,151,152,153,153},
	{0,0,0,0,235,236,234,233},
	{0,0,0,0,156,157,158,158},
	{0,0,0,0,157,159,158,158},
	{0,0,0,0,158,159,160,160},
	{0,0,0,0,159,161,160,160},
	{0,0,0,0,160,161,162,162},
	{0,0,0,0,161,163,162,162},
	{0,0,0,0,162,163,164,164},
	{0,0,0,0,165,166,167,167},
	{0,0,0,0,676,678,677,675},
	{0,0,0,0,168,170,169,169},
	{0,0,0,0,392,394,393,391},
	{0,0,0,0,171,172,173,173},
	{0,0,0,0,174,175,176,176},
	{0,0,0,0,258,260,259,257},
	{0,0,0,0,177,179,178,178},
	{0,0,0,0,352,354,353,351},
	{0,0,0,0,184,185,186,186},
	{0,0,0,0,81,83,82,80},
	{0,0,0,0,187,189,188,188},
	{0,0,0,0,190,191,192,192},
	{0,0,0,0,191,193,192,192},
	{0,0,0,0,205,207,206,204},
	{0,0,0,0,194,195,196,196},
	{0,0,0,0,672,674,673,671},
	{0,0,0,0,199,200,201,201},
	{0,0,0,0,200,202,201,201},
	{0,0,0,0,201,202,203,203},
	{0,0,0,0,453,454,452,451},
	{0,0,0,0,206,207,208,208},
	{0,0,0,0,524,526,525,523},
	{0,0,0,0,211,212,213,213},
	{0,0,0,0,221,222,220,219},
	{0,0,0,0,309,310,308,307},
	{0,0,0,0,218,219,220,220},
	{0,0,0,0,139,140,138,137},
	{0,0,0,0,221,223,222,222},
	{0,0,0,0,222,223,224,224},
	{0,0,0,0,225,226,227,227},
	{0,0,0,0,226,228,227,227},
	{0,0,0,0,227,228,229,229},
	{0,0,0,0,228,230,229,229},
	{0,0,0,0,229,230,231,231},
	{0,0,0,0,232,233,234,234},
	{0,0,0,0,456,458,457,455},
	{0,0,0,0,540,542,541,539},
	{0,0,0,0,402,404,405,403},
	{0,0,0,0,95,96,94,93},
	{0,0,0,0,246,248,247,245},
	{0,0,0,0,251,252,253,253},
	{0,0,0,0,252,254,253,253},
	{0,0,0,0,339,340,338,337},
	{0,0,0,0,266,267,265,264},
	{0,0,0,0,259,260,261,261},
	{0,0,0,0,260,262,261,261},
	{0,0,0,0,263,264,265,265},
	{0,0,0,0,187,188,186,185},
	{0,0,0,0,266,268,267,267},
	{0,0,0,0,269,270,271,271},
	{0,0,0,0,270,272,271,271},
	{0,0,0,0,271,272,273,273},
	{0,0,0,0,272,274,273,273},
	{0,0,0,0,168,169,167,166},
	{0,0,0,0,277,278,279,279},
	{0,0,0,0,278,280,279,279},
	{0,0,0,0,283,284,285,285},
	{0,0,0,0,286,287,288,288},
	{0,0,0,0,287,289,288,288},
	{0,0,0,0,288,289,290,290},
	{0,0,0,0,616,618,617,615},
	{0,0,0,0,293,294,295,295},
	{0,0,0,0,296,297,298,298},
	{0,0,0,0,544,546,545,543},
	{0,0,0,0,301,302,303,303},
	{0,0,0,0,572,574,573,571},
	{0,0,0,0,306,307,308,308},
	{0,0,0,0,480,482,481,479},
	{0,0,0,0,311,312,313,313},
	{0,0,0,0,312,314,313,313},
	{0,0,0,0,313,314,315,315},
	{0,0,0,0,316,317,318,318},
	{0,0,0,0,216,217,215,214},
	{0,0,0,0,321,322,323,323},
	{0,0,0,0,125,127,126,124},
	{0,0,0,0,254,256,255,253},
	{0,0,0,0,328,329,330,330},
	{0,0,0,0,331,332,333,333},
	{0,0,0,0,332,334,333,333},
	{0,0,0,0,333,334,335,335},
	{0,0,0,0,336,337,338,338},
	{0,0,0,0,131,133,132,130},
	{0,0,0,0,341,342,343,343},
	{0,0,0,0,342,344,343,343},
	{0,0,0,0,343,344,345,345},
	{0,0,0,0,346,347,348,348},
	{0,0,0,0,347,349,348,348},
	{0,0,0,0,348,349,350,350},
	{0,0,0,0,464,466,465,463},
	{0,0,0,0,353,354,355,355},
	{0,0,0,0,356,357,358,358},
	{0,0,0,0,357,359,358,358},
	{0,0,0,0,358,359,360,360},
	{0,0,0,0,361,362,363,363},
	{0,0,0,0,362,364,363,363},
	{0,0,0,0,363,364,365,365},
	{0,0,0,0,366,367,368,368},
	{0,0,0,0,179,181,180,178},
	{0,0,0,0,656,658,657,655},
	{0,0,0,0,373,374,375,375},
	{0,0,0,0,141,142,140,139},
	{0,0,0,0,378,379,380,380},
	{0,0,0,0,381,382,383,383},
	{0,0,0,0,382,384,383,383},
	{0,0,0,0,383,384,385,385},
	{0,0,0,0,620,622,621,619},
	{0,0,0,0,388,389,390,390},
	{0,0,0,0,429,430,428,427},
	{0,0,0,0,393,394,395,395},
	{0,0,0,0,584,586,585,583},
	{0,0,0,0,398,399,400,400},
	{0,0,0,0,237,238,236,235},
	{0,0,0,0,588,590,589,587},
	{0,0,0,0,406,407,408,408},
	{0,0,0,0,407,409,408,408},
	{0,0,0,0,408,409,410,410},
	{0,0,0,0,411,412,413,413},
	{0,0,0,0,412,414,413,413},
	{0,0,0,0,413,414,415,415},
	{0,0,0,0,416,417,418,418},
	{0,0,0,0,417,419,418,418},
	{0,0,0,0,418,419,420,420},
	{0,0,0,0,421,422,423,423},
	{0,0,0,0,422,424,423,423},
	{0,0,0,0,423,424,425,425},
	{0,0,0,0,426,427,428,428},
	{0,0,0,0,77,79,78,76},
	{0,0,0,0,431,432,433,433},
	{0,0,0,0,432,434,433,433},
	{0,0,0,0,433,434,435,435},
	{0,0,0,0,436,437,438,438},
	{0,0,0,0,437,439,438,438},
	{0,0,0,0,438,439,440,440},
	{0,0,0,0,299,300,298,297},
	{0,0,0,0,116,118,117,115},
	{0,0,0,0,445,446,447,447},
	{0,0,0,0,446,448,447,447},
	{0,0,0,0,447,448,449,449},
	{0,0,0,0,450,451,452,452},
	{0,0,0,0,680,682,681,679},
	{0,0,0,0,716,718,717,715},
	{0,0,0,0,468,470,469,467},
	{0,0,0,0,628,630,629,627},
	{0,0,0,0,472,474,473,471},
	{0,0,0,0,624,626,625,623},
	{0,0,0,0,475,476,477,477},
	{0,0,0,0,476,478,477,477},
	{0,0,0,0,282,284,283,281},
	{0,0,0,0,648,650,649,647},
	{0,0,0,0,487,488,489,489},
	{0,0,0,0,488,490,489,489},
	{0,0,0,0,491,492,493,493},
	{0,0,0,0,492,494,493,493},
	{0,0,0,0,495,496,497,497},
	{0,0,0,0,496,498,497,497},
	{0,0,0,0,499,500,501,501},
	{0,0,0,0,500,502,501,501},
	{0,0,0,0,507,508,509,509},
	{0,0,0,0,508,510,509,509},
	{0,0,0,0,504,506,505,503},
	{0,0,0,0,515,516,517,517},
	{0,0,0,0,516,518,517,517},
	{0,0,0,0,519,520,521,521},
	{0,0,0,0,520,522,521,521},
	{0,0,0,0,148,149,147,146},
	{0,0,0,0,527,528,529,529},
	{0,0,0,0,528,530,529,529},
	{0,0,0,0,531,532,533,533},
	{0,0,0,0,532,534,533,533},
	{0,0,0,0,324,325,323,322},
	{0,0,0,0,304,305,303,302},
	{0,0,0,0,240,243,244,242},
	{0,0,0,0,556,558,557,555},
	{0,0,0,0,551,552,553,553},
	{0,0,0,0,552,554,553,553},
	{0,0,0,0,89,91,90,88},
	{0,0,0,0,154,155,153,152},
	{0,0,0,0,484,486,485,483},
	{0,0,0,0,567,568,569,569},
	{0,0,0,0,568,570,569,569},
	{0,0,0,0,106,104,103,105},
	{0,0,0,0,319,320,318,317},
	{0,0,0,0,579,580,581,581},
	{0,0,0,0,580,582,581,581},
	{0,0,0,0,127,129,128,126},
	{0,0,0,0,443,444,441,442},
	{0,0,0,0,143,144,142,141},
	{0,0,0,0,595,596,597,597},
	{0,0,0,0,596,598,597,597},
	{0,0,0,0,599,600,601,601},
	{0,0,0,0,600,602,601,601},
	{0,0,0,0,603,604,605,605},
	{0,0,0,0,604,606,605,605},
	{0,0,0,0,170,172,171,169},
	{0,0,0,0,611,612,613,613},
	{0,0,0,0,612,614,613,613},
	{0,0,0,0,608,610,609,607},
	{0,0,0,0,512,514,513,511},
	{0,0,0,0,99,101,100,98},
	{0,0,0,0,692,694,693,691},
	{0,0,0,0,635,636,637,637},
	{0,0,0,0,636,638,637,637},
	{0,0,0,0,248,250,249,247},
	{0,0,0,0,643,644,645,645},
	{0,0,0,0,644,646,645,645},
	{0,0,0,0,85,87,86,84},
	{0,0,0,0,651,652,653,653},
	{0,0,0,0,652,654,653,653},
	{0,0,0,0,292,294,293,291},
	{0,0,0,0,659,660,661,661},
	{0,0,0,0,660,662,661,661},
	{0,0,0,0,663,664,665,665},
	{0,0,0,0,664,666,665,665},
	{0,0,0,0,667,668,669,669},
	{0,0,0,0,668,670,669,669},
	{0,0,0,0,214,215,213,212},
	{0,0,0,0,369,370,368,367},
	{0,0,0,0,687,688,689,689},
	{0,0,0,0,688,690,689,689},
	{0,0,0,0,696,698,697,695},
	{0,0,0,0,209,210,208,207},
	{0,0,0,0,712,714,713,711},
	{0,0,0,0,377,379,378,376},
	{0,0,0,0,720,722,721,719},
	{0,0,0,0,460,462,461,459},
	{0,0,0,0,723,724,725,726},
	{0,0,0,0,727,728,729,730},
	{0,0,0,0,731,732,733,733},
	{0,0,0,0,734,735,736,736},
	{0,0,0,0,737,738,739,739},
	{0,0,0,0,740,741,742,742},
	{0,0,0,0,743,744,745,745},
	{0,0,0,0,746,747,748,748},
	{0,0,0,0,749,750,751,751},
	{0,0,0,0,752,753,754,754},
	{0,0,0,0,755,756,757,757},
	{0,0,0,0,758,759,760,760},
	{0,0,0,0,761,762,763,763},
	{0,0,0,0,764,765,766,766},
	{0,0,0,0,767,768,769,769},
	{0,0,0,0,770,771,772,772},
	{0,0,0,0,773,774,775,775},
	{0,0,0,0,776,777,778,778},
	{0,0,0,0,779,780,781,781},
	{0,0,0,0,782,783,784,784},
	{0,0,0,0,785,786,787,787},
	{0,0,0,0,788,789,790,790},
	{0,0,0,0,791,792,793,793},
	{0,0,0,0,794,795,796,796},
	{0,0,0,0,797,798,799,799},
	{0,0,0,0,800,801,802,802},
	{0,0,0,0,803,804,805,805},
	{0,0,0,0,806,807,808,808},
	{0,0,0,0,809,810,811,811},
	{0,0,0,0,812,813,814,814},
	{0,0,0,0,815,816,817,817},
	{0,0,0,0,818,819,820,820},
	{0,0,0,0,821,822,823,823},
	{0,0,0,0,684,686,685,683},
	{0,0,0,0,548,550,549,547}
};
static vertex_t verts[824] = { 
	{-8,13,-1},
	{-8,13,-1},
	{-8,13,0},
	{-8,14,0},
	{-8,13,1},
	{-8,13,1},
	{-8,12,0},
	{-8,12,0},
	{-8,13,-1},
	{-8,13,-1},
	{8,13,0},
	{8,14,0},
	{8,13,-1},
	{8,13,-1},
	{8,12,0},
	{8,12,0},
	{8,13,1},
	{8,13,1},
	{8,13,0},
	{8,14,0},
	{-8,14,0},
	{-8,13,-1},
	{-10,13,0},
	{-8,12,0},
	{-8,13,1},
	{-8,13,-1},
	{-8,13,0},
	{-6,13,0},
	{-8,13,1},
	{-8,12,0},
	{8,13,-1},
	{8,14,0},
	{10,13,0},
	{8,13,1},
	{8,12,0},
	{8,13,0},
	{8,13,-1},
	{6,13,0},
	{8,12,0},
	{8,13,1},
	{-8,14,0},
	{-10,13,0},
	{-8,13,1},
	{-8,12,0},
	{-8,13,-1},
	{-6,13,0},
	{8,12,0},
	{8,13,-1},
	{10,13,0},
	{8,13,1},
	{8,13,0},
	{6,13,0},
	{3,17,3},
	{4,19,3},
	{0,17,4},
	{0,19,4},
	{0,19,4},
	{-4,19,3},
	{0,17,4},
	{-3,17,3},
	{0,19,4},
	{3,18,3},
	{0,21,3},
	{3,21,2},
	{0,19,4},
	{0,21,3},
	{-3,18,3},
	{-3,21,2},
	{-3,16,3},
	{-2,15,3},
	{0,16,4},
	{0,14,3},
	{2,15,3},
	{0,16,4},
	{2,15,3},
	{3,16,3},
	{-1,14,-1},
	{-1,13,-2},
	{-1,14,0},
	{-2,14,0},
	{-1,14,1},
	{-1,13,2},
	{1,14,1},
	{1,13,2},
	{1,14,0},
	{2,14,0},
	{1,14,-1},
	{1,13,-2},
	{-2,2,2},
	{2,2,2},
	{-2,5,2},
	{2,5,2},
	{-8,13,0},
	{-8,13,1},
	{-6,13,1},
	{-8,12,0},
	{-5,12,0},
	{-5,13,-1},
	{-5,13,-1},
	{-5,13,0},
	{-2,13,-1},
	{-3,14,0},
	{-2,13,0},
	{-2,13,1},
	{-2,12,0},
	{-4,13,1},
	{-5,12,0},
	{-6,13,1},
	{8,13,1},
	{8,13,0},
	{6,13,1},
	{4,13,1},
	{3,14,0},
	{2,13,1},
	{2,13,0},
	{2,12,0},
	{2,13,-1},
	{5,12,0},
	{5,13,-1},
	{5,13,-1},
	{5,13,0},
	{8,13,0},
	{-2,15,-1},
	{-4,18,-2},
	{-3,13,-3},
	{-3,14,-4},
	{-3,11,-4},
	{0,13,-6},
	{0,9,-4},
	{3,11,-4},
	{4,13,-3},
	{3,14,-4},
	{4,18,-2},
	{3,17,-4},
	{-2,8,0},
	{-1,9,-1},
	{-1,8,-2},
	{0,8,-2},
	{0,6,-2},
	{1,8,-2},
	{2,6,-2},
	{3,7,0},
	{3,6,0},
	{2,7,2},
	{2,5,2},
	{1,13,2},
	{3,13,1},
	{2,14,1},
	{3,14,-1},
	{2,14,-1},
	{2,14,-2},
	{0,15,-1},
	{0,14,-2},
	{-2,14,-2},
	{0,13,-2},
	{-2,13,-2},
	{-4,18,1},
	{-4,18,0},
	{-4,16,0},
	{-4,16,0},
	{-4,16,-1},
	{-4,13,0},
	{-4,15,0},
	{-4,15,0},
	{-4,15,1},
	{-4,20,0},
	{-3,21,2},
	{-3,22,-1},
	{0,22,2},
	{0,22,-1},
	{3,22,-1},
	{1,22,-3},
	{3,20,-3},
	{0,20,-5},
	{-2,8,0},
	{-1,8,-2},
	{-3,7,0},
	{-2,6,-2},
	{-3,6,0},
	{-3,4,0},
	{-2,5,2},
	{-2,3,2},
	{-4,18,0},
	{-4,20,0},
	{-4,18,-2},
	{-3,20,-3},
	{-3,17,-4},
	{0,20,-5},
	{0,17,-5},
	{3,17,-4},
	{4,18,-2},
	{3,16,0},
	{2,15,-1},
	{2,15,1},
	{0,15,-1},
	{0,14,1},
	{-2,15,1},
	{1,12,2},
	{1,13,2},
	{-1,12,2},
	{-1,13,2},
	{-3,13,0},
	{-2,14,0},
	{-1,13,-2},
	{-1,13,-2},
	{-1,11,-2},
	{-3,13,0},
	{-2,11,0},
	{-2,11,1},
	{-2,8,0},
	{-1,9,2},
	{2,14,0},
	{1,13,2},
	{3,13,0},
	{1,12,2},
	{2,11,1},
	{1,9,2},
	{2,8,0},
	{-4,18,-2},
	{-3,17,-4},
	{-3,14,-4},
	{0,17,-5},
	{0,13,-6},
	{3,14,-4},
	{3,11,-4},
	{4,18,0},
	{4,18,1},
	{4,16,0},
	{4,15,1},
	{4,15,0},
	{4,15,0},
	{4,13,0},
	{-8,12,0},
	{-8,13,-1},
	{-5,13,-1},
	{-8,13,0},
	{-5,13,0},
	{-6,13,1},
	{-4,13,1},
	{2,13,1},
	{2,12,0},
	{4,13,1},
	{6,13,1},
	{8,12,0},
	{8,13,1},
	{1,9,-1},
	{-1,9,-1},
	{1,11,-2},
	{-1,11,-2},
	{1,13,-2},
	{-1,13,-2},
	{-1,8,-2},
	{0,6,-2},
	{-2,6,-2},
	{0,5,-3},
	{-2,3,-5},
	{0,3,-5},
	{2,15,1},
	{3,16,0},
	{3,16,3},
	{4,18,1},
	{3,18,3},
	{3,21,2},
	{2,3,-5},
	{2,6,-2},
	{3,3,-3},
	{3,4,0},
	{4,2,0},
	{2,3,2},
	{4,18,0},
	{4,16,0},
	{4,16,0},
	{4,16,-1},
	{4,13,0},
	{4,15,0},
	{-4,20,0},
	{-3,22,-1},
	{-3,20,-3},
	{-1,22,-3},
	{0,20,-5},
	{1,22,-3},
	{3,21,2},
	{3,21,1},
	{2,21,2},
	{2,22,1},
	{2,22,2},
	{-4,0,0},
	{-5,0,-4},
	{0,1,-1},
	{-3,0,-6},
	{0,0,-8},
	{1,14,1},
	{1,14,1},
	{1,14,1},
	{0,14,1},
	{1,14,1},
	{-1,20,3},
	{-1,21,3},
	{-2,21,3},
	{-2,21,2},
	{-3,21,2},
	{3,16,0},
	{4,18,0},
	{4,18,1},
	{4,20,0},
	{3,21,2},
	{-3,21,2},
	{-2,21,2},
	{-2,21,2},
	{-2,22,2},
	{-2,22,1},
	{-4,20,1},
	{-4,22,0},
	{-4,20,0},
	{-4,20,0},
	{-4,19,0},
	{-1,14,1},
	{-1,14,1},
	{-1,14,1},
	{-1,14,1},
	{-1,14,1},
	{2,20,3},
	{3,20,3},
	{2,21,3},
	{3,21,2},
	{2,21,2},
	{-2,14,-1},
	{-3,14,-1},
	{-2,14,1},
	{-3,13,1},
	{-1,13,2},
	{4,13,0},
	{4,15,0},
	{4,16,0},
	{4,15,1},
	{4,18,1},
	{0,6,-2},
	{2,6,-2},
	{0,5,-3},
	{2,3,-5},
	{0,3,-5},
	{1,13,2},
	{2,14,1},
	{1,14,0},
	{2,14,-1},
	{0,15,-1},
	{0,15,-1},
	{-2,14,-1},
	{-1,14,0},
	{-2,14,1},
	{-1,13,2},
	{-2,8,1},
	{-2,9,1},
	{-2,8,0},
	{-2,9,0},
	{-2,9,-1},
	{-2,13,-2},
	{-3,14,-1},
	{-2,14,-2},
	{-2,14,-1},
	{0,15,-1},
	{-3,14,-1},
	{-2,13,-2},
	{0,12,-2},
	{0,13,-2},
	{2,13,-2},
	{2,6,-2},
	{3,6,0},
	{3,4,0},
	{2,5,2},
	{2,3,2},
	{1,8,2},
	{1,9,2},
	{0,8,3},
	{0,9,2},
	{-1,9,2},
	{1,12,2},
	{1,13,2},
	{0,12,3},
	{-1,13,2},
	{-1,12,2},
	{-4,16,-1},
	{-4,15,0},
	{-4,16,0},
	{-4,15,1},
	{-4,18,1},
	{1,9,-2},
	{1,7,-2},
	{0,8,-2},
	{0,8,-2},
	{-1,7,-2},
	{-1,14,1},
	{-1,14,1},
	{-1,14,1},
	{0,14,1},
	{-1,14,1},
	{-3,16,0},
	{-3,16,3},
	{-4,18,1},
	{-3,18,3},
	{-3,21,2},
	{0,14,1},
	{-1,14,1},
	{0,14,1},
	{0,13,1},
	{0,13,2},
	{3,13,0},
	{2,11,1},
	{2,11,0},
	{2,8,0},
	{1,11,-2},
	{5,18,-1},
	{5,20,-2},
	{5,19,0},
	{4,19,0},
	{4,18,0},
	{4,20,0},
	{4,22,0},
	{4,20,0},
	{4,20,1},
	{4,19,1},
	{-5,20,-2},
	{-5,18,-1},
	{-5,19,0},
	{-4,18,0},
	{-4,19,0},
	{1,21,3},
	{0,21,3},
	{0,20,4},
	{-1,21,3},
	{-1,20,3},
	{0,15,-1},
	{-2,15,1},
	{-2,15,-1},
	{-3,16,0},
	{-4,18,-2},
	{1,14,1},
	{0,14,1},
	{0,14,1},
	{0,14,1},
	{0,14,1},
	{-2,3,2},
	{-4,2,0},
	{-4,0,0},
	{-2,0,2},
	{1,14,0},
	{1,14,-1},
	{0,18,0},
	{-1,14,-1},
	{-1,14,0},
	{2,13,0},
	{3,14,0},
	{2,13,-1},
	{5,13,0},
	{5,13,-1},
	{-1,7,2},
	{-1,9,2},
	{-2,7,1},
	{-2,9,1},
	{2,8,-1},
	{2,9,-1},
	{2,8,0},
	{2,9,0},
	{2,8,1},
	{2,8,0},
	{2,9,1},
	{2,9,0},
	{-2,7,-2},
	{-2,9,-1},
	{-1,7,-2},
	{-1,9,-2},
	{2,7,-2},
	{1,7,-2},
	{2,9,-1},
	{1,9,-2},
	{0,14,3},
	{-2,15,3},
	{-2,15,1},
	{-3,16,3},
	{-3,21,2},
	{-2,21,2},
	{-3,21,1},
	{-2,22,1},
	{-2,20,3},
	{-2,21,3},
	{-3,20,3},
	{-3,21,2},
	{-4,13,0},
	{-4,16,0},
	{-4,15,0},
	{-4,15,1},
	{2,21,2},
	{1,21,3},
	{2,21,3},
	{1,20,3},
	{0,16,3},
	{0,16,3},
	{0,17,4},
	{0,16,3},
	{0,16,3},
	{0,17,4},
	{0,17,4},
	{0,16,3},
	{-3,16,3},
	{0,16,4},
	{-3,18,3},
	{0,19,4},
	{-3,16,0},
	{-7,19,-2},
	{-4,18,-2},
	{-4,18,0},
	{0,19,4},
	{0,16,4},
	{3,18,3},
	{3,16,3},
	{3,16,0},
	{4,18,-2},
	{7,19,-2},
	{4,18,0},
	{0,20,-5},
	{3,20,-3},
	{3,17,-4},
	{4,18,-2},
	{4,18,0},
	{4,18,-2},
	{4,20,0},
	{3,20,-3},
	{3,16,3},
	{2,15,3},
	{2,15,1},
	{0,14,3},
	{3,21,2},
	{2,21,2},
	{2,21,2},
	{2,22,2},
	{2,3,2},
	{2,2,2},
	{4,2,0},
	{4,0,0},
	{2,15,-1},
	{0,15,-1},
	{4,13,-3},
	{0,9,-4},
	{0,9,-4},
	{0,15,-1},
	{-3,13,-3},
	{-2,15,-1},
	{-3,14,-1},
	{0,12,-2},
	{-3,13,1},
	{-1,13,2},
	{-1,13,2},
	{0,12,-2},
	{0,12,0},
	{1,13,2},
	{1,13,2},
	{0,12,-2},
	{3,13,1},
	{3,14,-1},
	{0,14,-2},
	{2,14,-2},
	{0,13,-2},
	{2,13,-2},
	{2,14,0},
	{3,13,0},
	{1,13,-2},
	{1,11,-2},
	{2,15,1},
	{0,14,3},
	{0,14,1},
	{-2,15,1},
	{0,13,2},
	{0,13,1},
	{0,14,1},
	{1,14,1},
	{1,14,1},
	{1,14,1},
	{1,14,1},
	{1,14,1},
	{1,14,0},
	{0,18,0},
	{1,14,1},
	{-1,14,1},
	{-1,9,-1},
	{1,9,-1},
	{0,8,-2},
	{1,8,-2},
	{1,9,-1},
	{2,8,0},
	{1,8,-2},
	{3,7,0},
	{-2,5,2},
	{-2,7,2},
	{-3,6,0},
	{-3,7,0},
	{-2,3,2},
	{-3,4,0},
	{-4,2,0},
	{-3,3,-3},
	{0,12,2},
	{2,12,2},
	{1,13,2},
	{2,13,2},
	{-2,13,2},
	{-2,12,2},
	{-1,13,2},
	{0,12,2},
	{1,14,0},
	{0,15,-1},
	{1,13,2},
	{0,12,0},
	{1,8,2},
	{0,8,3},
	{0,7,2},
	{-1,8,2},
	{0,12,0},
	{0,15,-1},
	{-1,13,2},
	{-1,14,0},
	{-3,13,0},
	{-2,11,1},
	{-1,12,2},
	{-1,9,2},
	{1,9,2},
	{1,12,2},
	{-1,9,2},
	{-1,12,2},
	{-2,7,2},
	{-1,9,2},
	{-3,7,0},
	{-2,8,0},
	{2,8,0},
	{1,9,2},
	{3,7,0},
	{2,7,2},
	{-3,16,0},
	{-4,18,1},
	{-4,18,0},
	{-4,20,0},
	{-2,5,2},
	{2,5,2},
	{-2,7,2},
	{2,7,2},
	{-2,0,2},
	{0,1,-1},
	{2,0,2},
	{4,0,0},
	{-3,22,-1},
	{0,22,-1},
	{-1,22,-3},
	{1,22,-3},
	{3,20,-3},
	{3,22,-1},
	{4,20,0},
	{3,21,2},
	{3,22,-1},
	{0,22,2},
	{3,21,2},
	{0,21,3},
	{-3,4,0},
	{-2,6,-2},
	{-3,3,-3},
	{-2,3,-5},
	{-4,20,1},
	{-4,20,0},
	{-4,19,1},
	{-4,19,0},
	{4,0,0},
	{0,1,-1},
	{5,0,-4},
	{3,0,-6},
	{3,3,-3},
	{4,2,0},
	{5,0,-4},
	{4,0,0},
	{4,20,0},
	{4,20,0},
	{4,19,0},
	{4,19,1},
	{-4,0,0},
	{-4,2,0},
	{-5,0,-4},
	{-3,3,-3},
	{-2,0,2},
	{2,0,2},
	{-2,2,2},
	{2,2,2},
	{1,21,3},
	{0,20,4},
	{1,20,3},
	{0,19,4},
	{-2,3,-5},
	{-3,0,-6},
	{-3,3,-3},
	{-5,0,-4},
	{2,3,-5},
	{3,3,-3},
	{3,0,-6},
	{5,0,-4},
	{-5,13,-1},
	{-2,13,-1},
	{-5,12,0},
	{-2,12,0},
	{-5,13,0},
	{-4,13,1},
	{-3,14,0},
	{-2,13,1},
	{-3,0,-6},
	{-2,3,-5},
	{0,0,-8},
	{0,3,-5},
	{3,0,-6},
	{0,0,-8},
	{2,3,-5},
	{0,3,-5},
	{2,9,1},
	{1,9,2},
	{2,7,1},
	{1,7,2},
	{5,12,0},
	{5,13,-1},
	{8,12,0},
	{8,13,-1},
	{1,9,2},
	{-1,9,2},
	{-2,7,2},
	{2,7,2},
	{1,13,-2},
	{-1,13,-2},
	{-1,14,-1},
	{1,14,-1},
	{4,15,0},
	{4,16,-1},
	{4,16,0},
	{0,1,-1},
	{0,0,-8},
	{3,0,-6},
	{4,0,0},
	{2,2,2},
	{2,0,2},
	{-4,18,1},
	{-3,21,2},
	{-4,20,0},
	{0,9,-4},
	{-3,13,-3},
	{-3,11,-4},
	{1,14,1},
	{1,14,1},
	{1,14,1},
	{-4,0,0},
	{0,1,-1},
	{-2,0,2},
	{2,15,-1},
	{4,13,-3},
	{4,18,-2},
	{0,18,0},
	{-1,14,0},
	{-1,14,1},
	{0,21,3},
	{0,22,2},
	{-3,21,2},
	{1,9,-1},
	{1,11,-2},
	{2,8,0},
	{0,17,-5},
	{3,17,-4},
	{3,14,-4},
	{-4,16,0},
	{-4,18,1},
	{-4,15,1},
	{4,18,0},
	{5,18,-1},
	{5,19,0},
	{-2,11,0},
	{-1,11,-2},
	{-2,8,0},
	{-1,9,-1},
	{-2,8,0},
	{-1,11,-2},
	{2,13,-2},
	{2,14,-2},
	{3,14,-1},
	{-4,19,0},
	{-5,20,-2},
	{-5,19,0},
	{3,14,-1},
	{0,12,-2},
	{2,13,-2},
	{-3,16,0},
	{-2,15,1},
	{-3,16,3},
	{-1,20,3},
	{0,19,4},
	{0,20,4},
	{-1,7,-2},
	{-1,9,-2},
	{0,8,-2},
	{4,16,0},
	{4,18,1},
	{4,18,0},
	{7,19,-2},
	{4,18,0},
	{3,16,0},
	{-4,16,0},
	{-4,18,0},
	{-4,18,1},
	{-2,13,-1},
	{-2,13,0},
	{-2,12,0},
	{1,11,-2},
	{3,13,0},
	{2,11,0},
	{0,8,3},
	{-1,9,2},
	{-1,8,2},
	{-7,19,-2},
	{-3,16,0},
	{-4,18,0},
	{-2,9,-1},
	{-2,8,-1},
	{-2,8,0},
	{5,13,-1},
	{8,13,0},
	{8,13,-1}
};
