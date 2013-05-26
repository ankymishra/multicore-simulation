#ifndef SC_PAC_MEMIF_H_INCLUDED
#define SC_PAC_MEMIF_H_INCLUDED

#include "systemc"
#include "fcntl.h"
using namespace sc_core;

#include "mpac-mproc-define.h"
#include "pac-shm.h"
#include "mpac-mproc-sim-arg.h"

#ifdef PAC_2WAY_ICACHE_LINE
#include "sc-pac-memif-def-way.h"
#elif PAC_4WAY_ICACHE_LINE
#include "sc-pac-memif-def-way.h"
#elif PAC_8WAY_ICACHE_LINE
#include "sc-pac-memif-def-way.h"
#else
#include "sc-pac-memif-def-direct.h"
#endif

#include "pac-cfu.h"
#include "pac-profiling.h"

SC_MODULE(SC_pac_memif)
{
public:
	int iss_soc_fifo_fd;

	int core_id;
	int mod_id;
	struct sim_arg *multi_sim_arg;
	volatile unsigned short *cfu_ptr;

	SC_pac_memif(sc_module_name _name, int id, int mod_id, struct sim_arg *arg)
	: core_id(id)
	, mod_id(mod_id)
	, multi_sim_arg(arg) {
		char buf[128];

// open iss_soc fifo
		memset(buf, 0, 128);
		sprintf(buf, "%s%d", multi_arg(boot, soc_fifo_name), id);
		iss_soc_fifo_fd = open(buf, O_RDWR);

		if (iss_soc_fifo_fd < 0) {
			perror("Open fifo file fail.\r\n");
			exit(-1);
		}
	}

	void idle(volatile int *flag);

	void memif_reset();
	void dcache_flush(unsigned int addr, unsigned char *buf, int len);
	void l2_icache_write(unsigned int addr, unsigned char *buf, int len);

	void cfu_init(char *filename);
	void cfu_reset(void);
	void cfu_module(unsigned char sr_num, unsigned int data);
	int  cfu_mem_access(unsigned char sr_num, unsigned int data);
	int  cfu_ctrl_cmd(unsigned char sr_num, unsigned int data);
	void cfu_err_list_clear(void);

	void dbg_start_profiling(unsigned int pc);
	void dbg_stop_profiling(unsigned int pc);
	int  dbg_dmem_read(unsigned int addr, unsigned char *udata, int size);
	int  dbg_dmem_write(unsigned int addr, unsigned char *udata, int size);
};

extern SC_pac_memif *sc_pac_memif_ptr_0;

#endif

