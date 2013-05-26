#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/mman.h>
#include "unistd.h"
#include "string.h"

#include "mpac-mproc-define.h"
#include "pac-shm.h"
#include "mpac-mproc-sim-arg.h"
#include "pac-socshm-prot.h"
#include "pac-soc.h"

void shm_soc_setup(struct sim_arg *multi_sim_arg)
{
	unsigned int i, core_size = 0, m2_size = 0, ddr_size = 0, sysdma_size = 0;

	//soc_shm_base_ptr = (struct soc_shm_prot *)shm_create(multi_arg(boot, soc_shm_name),
	//							PAGE_SIZE * DSPNUM, O_CREAT | O_RDWR | O_TRUNC);

	soc_shm_base_ptr = (struct soc_shm_prot *)shm_create(multi_arg(boot, soc_shm_name),
								(PAGE_SIZE *  MAX_SOC_SHM_INST * DSPNUM), O_CREAT | O_RDWR | O_TRUNC);

	for (i = 0; i < DSPNUM; i++) {
		core_size += multi_arg(pacdsp[i].m1_mem, dmem_m1_size) + 
			multi_arg(pacdsp[i].res1, res1_size) + multi_arg(pacdsp[i].biu, biu_size) + 
			multi_arg(pacdsp[i].icu, icu_size) + multi_arg(pacdsp[i].dmu,dmu_size) + 
			multi_arg(pacdsp[i].dma, dma_size) + multi_arg(pacdsp[i].res2, res2_size);
	}

	m2_size = multi_arg(m2_mem, dmem_m2_size) + multi_arg(l2_icu, l2_icu_size) + 
				multi_arg(m2_dmu, m2_dmu_size) + multi_arg(m2_dma, m2_dma_size) + 
				multi_arg(sem, sem_size) + multi_arg(c2cc, c2cc_size);

	ddr_size = multi_arg(ddr_mem, ddr_memory_size);
	sysdma_size = multi_arg(sys_dma, sys_dma_size);

	multi_sim_arg->shm_ptr.core_ptr = shm_create(multi_arg(boot, core_shm_name), core_size, O_CREAT | O_RDWR | O_TRUNC);
	multi_sim_arg->shm_ptr.m2_ptr = shm_create(multi_arg(boot, m2_shm_name), m2_size, O_CREAT | O_RDWR | O_TRUNC);
	multi_sim_arg->shm_ptr.ddr_ptr = shm_create(multi_arg(boot, ddr_shm_name), ddr_size, O_CREAT | O_RDWR | O_TRUNC);
	multi_sim_arg->shm_ptr.sysdma_ptr = shm_create(multi_arg(boot, sysdma_shm_name), sysdma_size, O_CREAT | O_RDWR | O_TRUNC);
}

void shm_soc_del(struct sim_arg *multi_sim_arg)
{
	shm_del(multi_arg(boot, soc_shm_name));
	shm_del(multi_arg(boot, core_shm_name));
	shm_del(multi_arg(boot, m2_shm_name));
	shm_del(multi_arg(boot, ddr_shm_name));
	shm_del(multi_arg(boot, sysdma_shm_name));
}
