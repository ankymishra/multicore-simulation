#ifndef PAC_SOC_H_INCLUDED
#define PAC_SOC_H_INCLUDED

#define CACHE_DATA 		0
#define ISS_DATA		1
#define M1_DMA_DATA		2
#define M2_DMA_DATA		3
#define SYS_DMA_DATA	4

#define CORE0_ID		0
#define CORE1_ID		1
#define CORE2_ID		2
#define CORE3_ID		3

#define M1_RANGE 0
#define M2_RANGE 1
#define DDR_RANGE 2

#define GEN_INST_CORE_RANGE(x,y,z) ((x << 16) | (y << 8) | (z))
#define GET_INST(x) ((x & 0xFFFF0000) >> 16)
#define GET_CORE(x) ((x & 0xFF00) >> 8)
#define GET_RANGE(x) ((x & 0xFF))

#define CACHE_MISS -1 
#define CACHE_HIT 0

#define CACHE_FLUSH 1
#endif
