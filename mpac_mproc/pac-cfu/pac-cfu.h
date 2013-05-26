#ifndef  PAC_CFU_H

#define SR4		0
#define SR5		1
#define SR6		2
#define SR7		3

#define CFU_NUM		4
#define CFU_BUFSIZE		0x1000

#define CFU_FUNC_START  	0x8000

#define CFU_FLAG_OFFSET		0x0800
#define CFU_RSP_OFFSET		0x0810

#define CFU_ERRHIST0		0x0840
#define CFU_ERRHIST1		0x0842
#define CFU_ERRHIST2		0x0844
#define CFU_ERRHIST3		0x0846
#define CFU_ERRHIST4		0x0848
#define CFU_ERRHIST5		0x084a
#define CFU_ERRHIST6		0x084c
#define CFU_ERRHIST7		0x084e
#define CFU_ERRCNT		0x0850

#define CFU_ERR_START		0x0852
#define CFU_ERR_END		0x0854

typedef unsigned short (*cfu_func)(unsigned char func_id, unsigned short * cfu_base);
void register_cfu_functions(void);
int cfu_mem_setup(void);

extern void *sysdma_ptr;
extern void *ddr_ptr;
extern void *m2_ptr;
extern void *core_ptr;
extern cfu_func cfu_func_sets[CFU_NUM][256];

#endif
