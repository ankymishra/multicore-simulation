#include "fcntl.h"
#include "sys/mman.h"

#include "mpac-mproc-define.h"

#include "pac-cfu.h"
#include "pac-cfu-demo.h"
#include "pac-parser.h"

void *sysdma_ptr;
void *ddr_ptr;
void *m2_ptr;
void *core_ptr;

cfu_func cfu_func_sets[CFU_NUM][256];
extern struct sim_arg multi_sim_arg;

static int register_cfu_func(int sr, unsigned char func_id, cfu_func func)
{
	if((sr < 0) || (sr >3) || !func)	// error argument
		return -1;

	if(cfu_func_sets[sr][func_id])	// already register a func
		return -1;

	cfu_func_sets[sr][func_id] = func;
	return 0;
}

int cfu_mem_setup()
{
    unsigned int i, core_size = 0, m2_size = 0, ddr_size = 0, sysdma_size = 0;

        for (i = 0; i < DSPNUM; i++) {
            core_size += MULTI_ARG(pacdsp[i].m1_mem, dmem_m1_size) + MULTI_ARG(pacdsp[i].res1, res1_size) + 
                    MULTI_ARG(pacdsp[i].biu, biu_size) + MULTI_ARG(pacdsp[i].icu, icu_size) + 								MULTI_ARG(pacdsp[i].dmu, dmu_size) + MULTI_ARG(pacdsp[i].dma, dma_size) + 								MULTI_ARG(pacdsp[i].res2, res2_size);
        }   

        m2_size = MULTI_ARG(m2_mem, dmem_m2_size) + MULTI_ARG(l2_icu, l2_icu_size) + MULTI_ARG(m2_dmu, m2_dmu_size) + 
                    MULTI_ARG(m2_dma, m2_dma_size) + MULTI_ARG(sem, sem_size) + MULTI_ARG(c2cc, c2cc_size);

        ddr_size = MULTI_ARG(ddr_mem, ddr_memory_size);
        sysdma_size = MULTI_ARG(sys_dma, sys_dma_size);

        core_ptr = shm_create(MULTI_ARG(boot, core_shm_name), core_size, O_RDWR);
        m2_ptr = shm_create(MULTI_ARG(boot, m2_shm_name), m2_size, O_RDWR);
        ddr_ptr = shm_create(MULTI_ARG(boot, ddr_shm_name), ddr_size, O_RDWR);
        sysdma_ptr = shm_create(MULTI_ARG(boot, sysdma_shm_name), sysdma_size, O_RDWR);
	return 0;
}

void register_cfu_functions(void)
{
    register_cfu_func(SR4, 55, sr4_55_memcpy);
}
