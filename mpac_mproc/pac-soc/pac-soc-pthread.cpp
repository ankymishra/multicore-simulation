#include "mpac-mproc-define.h"
#include "pac-parser.h"
#include "pac-socshm-prot.h"
#include "pac-socshm-prot.h"
#include "pac-soc.h"
#include "unistd.h"


extern int fifo_iss_fd[DSPNUM];

void *soc_pthread(void *d)
{
	int i = 0;
	struct soc_shm_prot *ptr;

	while (1) {
#ifndef PAC_SOC_PROFILE
		ptr = soc_shm_base_ptr + (i);
#else
		ptr = soc_shm_base_ptr + (i*MAX_SOC_SHM_INST);
#endif
		if (ptr->flag == RESPONSE) {
			ptr->flag = RESPONSE_OK;
			write(fifo_iss_fd[i], "a", 1);
		}

		i++;
		if (i == 4) {
			ptr = soc_shm_base_ptr;
			i = 0;
		}
	}
	return NULL;
}
