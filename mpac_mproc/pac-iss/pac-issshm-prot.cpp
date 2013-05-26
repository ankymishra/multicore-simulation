#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/mman.h>
#include "unistd.h"
#include "string.h"

#include "pac-shm.h"
#include "mpac-mproc-define.h"
#include "mpac-mproc-sim-arg.h"
#include "pac-socshm-prot.h"

void *soc_shm_setup(int core_id, struct sim_arg *multi_sim_arg)
{
	void *ptr;

	ptr = shm_create(multi_sim_arg->boot.soc_shm_name, MAX_SOC_SHM_INST * PAGE_SIZE * DSPNUM, O_RDWR);
	return ptr;
}

void *jtag_shm_setup(int core_id, struct sim_arg *multi_sim_arg)
{
	void *ptr;
	char iss_shm_name[FILE_NAMESIZE];

	sprintf(iss_shm_name, "%s-%d", multi_sim_arg->boot.iss_shm_name, core_id);
	ptr = shm_create(iss_shm_name, PAGE_SIZE, O_CREAT | O_RDWR | O_TRUNC);
	return ptr;
}
