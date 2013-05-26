#ifndef PAC_DSP_H_INCLUDED
#define PAC_DSP_H_INCLUDED

#include <systemc.h>

#include <assert.h>
#include <fcntl.h>
#include <malloc.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <memory.h>
#include <time.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/time.h>
#include <errno.h>

#include "mpac-mproc-define.h"
#include "mpac-mproc-sim-arg.h"
#include "debug-interface.h"
#include "pac-iss.h"

extern struct sim_arg multi_sim_arg;

SC_MODULE(pac_dsp) {
  public:
	sc_in < bool > clk;
	sc_out < bool > if_pin;
	sc_out < bool > ex1_pin;
	sc_out < bool > ex2_pin;
	sc_out < bool > dsp_pin;
	
	int core_id;
	unsigned int be_stoped;
	unsigned int active_core_stop;
	enum STOP_REASON eStopFlag;

	int step_num;
	struct sim_arg *multi_sim_arg;
	int gdb_iss_fifo_rd_fd;
	int gdb_iss_fifo_wr_fd;

#include "pac-dsp-var.h"
#include "pac-exec-var.h"
#include "pac-semihost-var.h"
#include "pac-iss-debug-var.h"

	SC_HAS_PROCESS(pac_dsp);
	pac_dsp(sc_module_name _name, int id, struct sim_arg *arg)
	: core_id(id)
	, multi_sim_arg(arg) {
		char buf[128];
		be_stoped = 0;
		fetch_pc = multi_arg(pacdsp[core_id].core, core_start_pc);
		sprintf(buf, "%s%d", multi_arg(boot, iss_fifo_rd_name), id);	//rd fifo
		mkfifo(buf, 0666);
		gdb_iss_fifo_wr_fd = open(buf, O_RDWR);

		if (gdb_iss_fifo_wr_fd < 0) {
			perror("Open fifo file fail.\r\n");
			exit(-1);
		}

		sprintf(buf, "%s%d", multi_arg(boot, iss_fifo_wr_name), id);	//wr fifo
		mkfifo(buf, 0666);
		gdb_iss_fifo_rd_fd = open(buf, O_RDWR);

		if (gdb_iss_fifo_rd_fd < 0) {
			perror("Open fifo file fail.\r\n");
			exit(-1);
		}
		pac_iss_init(0, fetch_pc);
		SC_THREAD(pac_iss_run);
		sensitive << clk;
	}

	~pac_dsp() {
	}
};

extern pac_dsp *dsp_core;

#endif
