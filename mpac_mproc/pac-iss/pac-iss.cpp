#include <systemc.h>
#include "stdio.h"
#include "stdlib.h"
#include "getopt.h"

#include "pac-dsp.h"
#include "pac-parser.h"
#include "pac-issshm-prot.h"
#include "pac-socshm-prot.h"

#include "sc-pac-memif.h"

#ifdef PAC_2WAY_ICACHE_LINE
#include "sc-pac-if-way.h"
#elif PAC_4WAY_ICACHE_LINE
#include "sc-pac-if-way.h"
#elif PAC_8WAY_ICACHE_LINE
#include "sc-pac-if-way.h"
#else
#include "sc-pac-if-direct.h"
#endif

#include "sc-pac-monitor.h"
#include "sc-pac-ex1.h"
#include "sc-pac-ex2.h"
#include "sc-pac-ex3.h"

#include "pac-qemu.h"
pac_dsp *dsp_core;
SC_pac_if *sc_pac_if_ptr;
SC_pac_ex1 *sc_pac_ex1_ptr;

SC_pac_ex2 *sc_pac_ex2_ptr0;
SC_pac_ex2 *sc_pac_ex2_ptr1;
SC_pac_ex2 *sc_pac_ex2_ptr2;

SC_pac_ex3 *sc_pac_ex3_ptr;

SC_pac_memif *sc_pac_memif_ptr_0;
//SC_pac_memif *sc_pac_memif_ptr_3;

struct sim_arg multi_sim_arg;

struct iss_shm_prot *iss_shm_base_ptr;
struct soc_shm_prot *soc_shm_base_ptr;

static struct option long_options[] = {
	{"exec", required_argument, NULL, 'x'},
	{"profile", no_argument, NULL, 'p'},
	{"qemu", no_argument, NULL, 'q'},
	{"server", no_argument, NULL, 's'},
	{"core", required_argument, NULL, 'a'},
	{"tic", required_argument, NULL, 'b'},
	{"cfu", no_argument, NULL, 'c'},
	{"reset", no_argument, NULL, 'r'},
	{"from", required_argument, NULL, 'f'},
	{"dump", required_argument, NULL, 'd'},
	{"len", required_argument, NULL, 'l'},
	{"help", no_argument, NULL, 'h'},
	{"yuv", no_argument, NULL, 't'},
	{"port", no_argument, NULL, 'n'},
	{NULL, no_argument, NULL, 0}
};

static void show_help()
{
	printf("example: ./mpaciss-run-sc -x sim.ini -p -s\r\n");
	printf("Argument:\r\n");
	printf("-x --exec		execve *.ini file\r\n");
	printf("-t --semihost		use semihost in local or remot\r\n");
	printf("-p --profile		run with profiling\r\n");
	printf("-s --server		run with gdbserver\r\n");
	printf("-f --from		dump memory address\r\n");
	printf("-l --len		dump memory length\r\n");
	printf("-c --cfu                use cfu-shm\r\n");
	printf("-r --reset              reset cache only\r\n");
	printf("-y --yuv 		dump memory in yuv mode\r\n");
	printf("-o --port		gdbserverr connect port\r\n");
	printf("--help			help\r\n");
	printf("--core	  xxx.bin	run TestPattern mode with xxx.bin\r\n");
	printf("--tic	  xxx.tic.c	run TestPattern mode with xxx.tic.c\r\n");
	printf("-d --dump xxx.dump	dump memory to xxx.dump in hex mode\r\n");
	exit(0);
}

//from pac-ctrl-var.h
int cluster_idx;
int state_pipe_empty;
int statetmp;
int state_machine;

//from pac-exec-var.h
unsigned int regT1;
unsigned int regT2;
unsigned int regT1Type;
unsigned int regT2Type;
unsigned char regTFlag;
unsigned char regTBDR1;
unsigned char regTBDR2;
unsigned char regTBDT;

unsigned short cfu_resp;
unsigned int branch_Reg_P;

// Register File
RF_t ro_regs;
RF_t global_regs;

int WB_IDX;
inst_packet exec_table[8];
write_log pipeline_logtab[8];

//from pac-fetch-var.h
int branch_occur;
unsigned int fetch_pc;
unsigned int branch_target;
Inst_Package_more pac_packet;

//from pac-semihost-var.h
FILE *fp_buf[FP_MAX];
int fp_free;
int fp_count;
unsigned int pre_breakpc;

//for all module event
int if_event_step = 0;
sc_event ex3_event;

//for  module response to ctrl module event
sc_event if_resp_event;
sc_event ex1_resp_event;

int ex2_step_count; 	// max = 3
sc_event ex2_resp_event;
sc_event ex3_resp_event;

int mod_count = 0;	// max = 5
sc_event mod_resp_event;

int memif_req_count;	// max = 4
sc_event monitor_req_event, monitor_resp_event; // use to wake/wait monitor thread

int dbg_step_flag = 0;

int sc_main(int argc, char *argv[])
{
	int core_id;
	int opt, option_index;
	int run_pattern = 0, cfu_mode = 0, qemu_mode = 0;
	char *filename = NULL;

	sc_signal < bool > if_connect_pin;
	sc_signal < bool > ex1_connect_pin;
	sc_signal < bool > ex2_connect_pin;
	sc_signal < bool > dsp_connect_pin;		// dsp ctrl pin

	core_id = atoi(argv[1]);
	printf("core_id = %d.\r\n", core_id);

	iss_sim_setup(core_id);	

	while ((opt = getopt_long(argc, argv, "ythpsf:l:d:x:n:crq", long_options, &option_index)) != -1) {
		switch (opt) {
		case 'q':
			qemu_mode = 1;
			break;
		case 'c':
			cfu_mode = 1;
			break;
		case 'r':
			run_pattern = 1;
			break;
		case 'a':
			strcpy((char *) multi_sim_arg.pacdsp[core_id].core.core_bin,
				   optarg);
			break;
		case 'b':
			strcpy((char *) multi_sim_arg.pacdsp[core_id].core.core_tic,
				   optarg);
			break;
		case 'x':
			filename = optarg;
			iss_sim_parser(core_id, filename, &multi_sim_arg);
			if (filename == NULL) {
				printf("No sim.ini file .\r\n");
				exit(-1);
			} else
				break;
		case 't':
			MULTI_ARG(boot, use_semihost) = 1;
		case 'p':
			MULTI_ARG(boot, use_profiling) = 1;
			break;
		case 's':
			MULTI_ARG(boot, use_gdbserver) = 1;
			break;
		case 'h':
			show_help();
			break;
		case 'd':
			MULTI_ARG(dump, dump_file) = optarg;
			strcpy((char *) multi_sim_arg.dump.dump_file, optarg);
			break;
		case 'f':
			MULTI_ARG(dump, dump_addr) = strtol(optarg, NULL, 16);
			break;
		case 'l':
			MULTI_ARG(dump, dump_len) = atoi(optarg);
			break;
		case 'y':
			MULTI_ARG(dump, dump_mode) = 1;
			break;
		case 'n':
			MULTI_ARG(boot, gdbserver_port) = atoi(optarg);
			break;
		default:
			printf("Invalid Argument \r\n");
			exit(-1);
		}
	}

	iss_shm_base_ptr = (struct iss_shm_prot *) jtag_shm_setup(core_id, &multi_sim_arg);
	soc_shm_base_ptr = (struct soc_shm_prot *) soc_shm_setup(core_id, &multi_sim_arg) + core_id * MAX_SOC_SHM_INST;

#define SC_EX2_MEMIF	0
#define C1_EX2_MEMIF	1
#define C2_EX2_MEMIF	2
#define IF_MEMIF	3
// init 3 memif
	SC_pac_memif sc_pac_memif_0("pac_memif_0", core_id, SC_EX2_MEMIF,  &multi_sim_arg);
	sc_pac_memif_ptr_0 = &sc_pac_memif_0;

// init if, use memif_3
	SC_pac_if sc_pac_if("pac_if", core_id, &multi_sim_arg);
	sc_pac_if_ptr = &sc_pac_if;
	sc_pac_if.if_pin(if_connect_pin);
	sc_pac_if.dsp_pin(dsp_connect_pin);

// init ex1/ex2/ex3
	SC_pac_ex1 sc_pac_ex1("pac_ex1");
	sc_pac_ex1_ptr = &sc_pac_ex1;
	sc_pac_ex1.ex1_pin(ex1_connect_pin);
	sc_pac_ex1.dsp_pin(dsp_connect_pin);

	//use memif_0
	SC_pac_ex2 sc_pac_ex2_0("pac_ex2_0", 0);
	sc_pac_ex2_ptr0 = &sc_pac_ex2_0;
	
	// use memif_1
	SC_pac_ex2 sc_pac_ex2_1("pac_ex2_1", 1);
	sc_pac_ex2_ptr1 = &sc_pac_ex2_1;

	// use memif_2
	SC_pac_ex2 sc_pac_ex2_2("pac_ex2_2", 2);
	sc_pac_ex2_ptr2 = &sc_pac_ex2_2;

	SC_pac_ex3 sc_pac_ex3("pac_ex3");
	sc_pac_ex3_ptr = &sc_pac_ex3;

	SC_pac_monitor sc_pac_monitor("pac_monitor");

//init dsp core iss
	sc_clock clk("clk", 1, SC_NS);
	pac_dsp dsp("pac_dsp", core_id, &multi_sim_arg);
	dsp_core = &dsp;
	dsp.clk(clk);

	dsp.if_pin(if_connect_pin);
	dsp.ex1_pin(ex1_connect_pin);
	dsp.ex2_pin(ex2_connect_pin);
	dsp.dsp_pin(dsp_connect_pin);

	sc_pac_ex2_0.dsp_pin(dsp_connect_pin);
	sc_pac_ex2_0.ex2_pin(ex2_connect_pin);

	sc_pac_ex2_1.dsp_pin(dsp_connect_pin);
	sc_pac_ex2_1.ex2_pin(ex2_connect_pin);

	sc_pac_ex2_2.dsp_pin(dsp_connect_pin);
	sc_pac_ex2_2.ex2_pin(ex2_connect_pin);
	
	if (run_pattern == 1) {
		sc_pac_if_ptr->icache_write(0x0, 0x0, 0x0);
		sc_pac_memif_ptr_0->l2_icache_write(0x0, 0x0, 0x0);
		sc_pac_memif_ptr_0->dcache_flush(0x0, 0x0, 0x0);
	} else {
		dsp_core->dbg_reset();
	}

	if (cfu_mode) {
		sc_pac_memif_ptr_0->cfu_init(MULTI_ARG(boot, cfu_shm_name));
	}

	if (qemu_mode) {
		struct arm_pac_type arm_pac;
		do {
			sleep(1);
			sc_pac_memif_ptr_0->dbg_dmem_read(MULTI_ARG(boot, qemu_addr), (unsigned char *)&arm_pac, sizeof(struct arm_pac_type));
		} while (arm_pac.arm_pac_core[core_id].flag != 1);
		
		dsp_core->dbg_write_reg(116, (unsigned char *)&arm_pac.arm_pac_core[core_id].start_pc);
		dsp_core->update_fetch_pc();
	}

	iss_tic_setup(core_id);
	download_binary(core_id);
	profile_init();

	if (MULTI_ARG(boot, use_gdbserver)) {
		printf("core %d wait for JTAG reconnect\r\n", core_id);
		iss_shm_base_ptr->flag = ISS_STOP;
	} else {
		iss_shm_base_ptr->flag = ISS_RUN;
	}

	sc_start();

	printf("sim end.\r\n");

	if (run_pattern == 1) {
		sc_pac_memif_ptr_0->dcache_flush(0x0, 0x0, 0x0);
	}

	iss_tic_compare();
	iss_sim_del(core_id);
	return 0;
}
