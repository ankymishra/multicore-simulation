#ifndef _PAC_ISSSHM_PROT_H_INCLUDED
#define _PAC_ISSSHM_PROT_H_INCLUDED

#include "debug-interface.h"

#define ISS_STOP	0
#define	ISS_RUN		1
#define	ISS_EXIT	2

struct iss_shm_prot {
// 0 run, 1 stop, 2 exit

	int flag;
	struct pac_soc_cmd cmd;		// max 1 + 4 long
	unsigned char buf[PROT_BUFSIZE];
};

#define SET_ISS_STOP	iss_shm_base_ptr->flag = ISS_STOP
#define SET_ISS_RUN	iss_shm_base_ptr->flag = ISS_RUN
#define IS_ISS_RUN	(iss_shm_base_ptr->flag == ISS_RUN)

extern struct soc_shm_prot *soc_shm_base_ptr;
extern struct iss_shm_prot *iss_shm_base_ptr;

extern void *soc_shm_setup(int core_id, struct sim_arg *multi_sim_arg);
extern void *jtag_shm_setup(int core_id, struct sim_arg *multis_sim_arg);

#endif
