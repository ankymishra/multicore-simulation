#include "mpac-mproc-define.h"
#include "pac-socshm-prot.h"
#include "pac-soc.h"
#include "pac-parser.h"

#ifdef PAC_2WAY_ICACHE_LINE
#include "pac-l2-way-bus.h"
#elif PAC_4WAY_ICACHE_LINE
#include "pac-l2-way-bus.h"
#elif PAC_8WAY_ICACHE_LINE
#include "pac-l2-way-bus.h"
#else
#include "pac-l2-direct-bus.h"
#endif

#include "pac-core-bus.h"
#include "pac-m1-bus.h"
#include "pac-m2-bus.h"
#include "pac-biu-bus.h"
#include "pac-dma-bus.h"
#include "pac-dmu-bus.h"
#include "pac-d2-bus.h"

#include "getopt.h"
#include "sys/shm.h"
#include "sys/types.h"


#ifdef C2CC
#include "c2cc-wrap.h"
#include "pac-c2cc-bus.h"
#endif

Core_Bus *dsp[DSPNUM];

static struct option long_options[] = {
	{"exec", required_argument, NULL, 'x'},
	{"help", no_argument, NULL, 'h'},
	{NULL, no_argument, NULL, 0}
};

static void show_help()
{
	printf("example: ./pac-soc-run -x sim.ini \r\n");
	printf("Argument:\r\n");
	printf("-x --exec	execve *.ini file\r\n");
	printf("-h --help	help\r\n");
	exit(0);
}

struct sim_arg multi_sim_arg;

int sc_main(int argc, char *argv[])
{
	int opt, option_index;
	char *filename = NULL;

	if (argc < 2) {
		show_help();
		exit(-1);
	}

	soc_sim_setup(&multi_sim_arg);	

	while ((opt = getopt_long(argc, argv, "hx:", long_options, &option_index)) != -1) {
		switch (opt) {
		case 'x':
			filename = optarg;
			soc_sim_parser(filename, &multi_sim_arg);
			break;
		case 'h':
			show_help();
			break;
		default:
			printf("Invalid Argument \r\n");
			exit(-1);
		}
	}

	if (filename == NULL) {
		printf("No sim.ini file .\r\n");
		exit(-1);
	}
	sc_clock clk("clk", 1, SC_NS);

	shm_soc_setup(&multi_sim_arg);
	
	D2_Bus d2_bus("d2_bus", &multi_sim_arg);
	Biu_Bus biu_bus("biu_bus", &multi_sim_arg);
	Dmu_Bus dmu_bus("dmu_bus", &multi_sim_arg);
	Dma_Bus dma_bus("dma_bus", &multi_sim_arg);
	M2_Bus m2_bus("m2_bus", &multi_sim_arg);
	L2_Bus l2_bus("l2_bus", &multi_sim_arg);

#ifdef C2CC
	C2CC_Bus c2cc_bus("c2cc_bus", &multi_sim_arg);
#if DSPNUM >= 1
	C2CC_Wrap c2cc_wrap0("c2cc_wrap0", CORE0_ID, &multi_sim_arg);
	c2cc_wrap0.clk(clk);
	c2cc_wrap0.tx_init_socket(c2cc_bus.targ_socket[CORE0_ID]);
	c2cc_wrap0.rx_targ_socket(c2cc_bus.init_socket[CORE0_ID]);
#endif

#if DSPNUM >= 2
	C2CC_Wrap c2cc_wrap1("c2cc_wrap1", CORE1_ID, &multi_sim_arg);
	c2cc_wrap1.clk(clk);
	c2cc_wrap1.tx_init_socket(c2cc_bus.targ_socket[CORE1_ID]);
	c2cc_wrap1.rx_targ_socket(c2cc_bus.init_socket[CORE1_ID]);
#endif

#if DSPNUM >= 3
	C2CC_Wrap c2cc_wrap2("c2cc_wrap2", CORE2_ID, &multi_sim_arg);
	c2cc_wrap2.clk(clk);
	c2cc_wrap2.tx_init_socket(c2cc_bus.targ_socket[CORE2_ID]);
	c2cc_wrap2.rx_targ_socket(c2cc_bus.init_socket[CORE2_ID]);
#endif

#if DSPNUM >= 4
	C2CC_Wrap c2cc_wrap3("c2cc_wrap3", CORE3_ID, &multi_sim_arg);
	c2cc_wrap3.clk(clk);
	c2cc_wrap3.tx_init_socket(c2cc_bus.targ_socket[CORE3_ID]);
	c2cc_wrap3.rx_targ_socket(c2cc_bus.init_socket[CORE3_ID]);
#endif
#endif

#if DSPNUM >= 1
	M1_Bus dsp0_m1_bus("dsp0_m1_bus", CORE0_ID, &multi_sim_arg);	
	dsp0_m1_bus.dma_bus_init_socket(dma_bus.dma_targ_socket_tagged[CORE0_ID]); 				//M1_Bus connect to Dma_Bus

	Core_Bus dsp0("dsp0", CORE0_ID, &multi_sim_arg);
	dma_bus.dma_d1_dcache_init_socket_tagged[CORE0_ID](dsp0.d1_dcache_targ_socket);
	dsp0.l2_bus_init_socket(l2_bus.l2_bus_targ_socket_tagged[CORE0_ID]); 					//connect to L2_Bus
	dsp0.d2_bus_init_socket(d2_bus.d2_bus_targ_socket_tagged[CORE0_ID]);
	d2_bus.m1_bus_init_socket_tagged[CORE0_ID](dsp0_m1_bus.m1_bus_targ_socket_tagged[0]);
	d2_bus.m2_bus_init_socket_tagged[CORE0_ID](m2_bus.m2_bus_targ_socket_tagged[CORE0_ID]);
	d2_bus.biu_bus_init_socket_tagged[CORE0_ID](biu_bus.biu_bus_targ_socket_tagged[CORE0_ID]);
	d2_bus.dmu_bus_init_socket_tagged[CORE0_ID](dmu_bus.dmu_bus_targ_socket_tagged[CORE0_ID]);

	dma_bus.dma_init_socket_tagged[CORE0_ID](dsp0_m1_bus.m1_bus_targ_socket_tagged[1]); 	//Dma_Bus connect to M1_Bus dma
	dmu_bus.m1_dmu_init_socket_tagged[CORE0_ID](dsp0_m1_bus.m1_bus_targ_socket_tagged[2]); 	//Dmu_Bus connect to M1_Bus dmu

	dsp0.clk(clk);

	dsp[CORE0_ID] = &dsp0;
#ifdef C2CC
	dsp0_m1_bus.c2cc_init_socket(c2cc_wrap0.tx_targ_socket); 								//connect to c2cc_wrap
#endif
#endif

#if DSPNUM >= 2
	M1_Bus dsp1_m1_bus("dsp1_m1_bus", CORE1_ID, &multi_sim_arg);	
	dsp1_m1_bus.dma_bus_init_socket(dma_bus.dma_targ_socket_tagged[CORE1_ID]); 				//M1_Bus connect to Dma_Bus

	Core_Bus dsp1("dsp1", CORE1_ID, &multi_sim_arg);
	dma_bus.dma_d1_dcache_init_socket_tagged[CORE1_ID](dsp1.d1_dcache_targ_socket);
	dsp1.l2_bus_init_socket(l2_bus.l2_bus_targ_socket_tagged[CORE1_ID]); 					//connect to L2_Bus
	dsp1.d2_bus_init_socket(d2_bus.d2_bus_targ_socket_tagged[CORE1_ID]);
	d2_bus.m1_bus_init_socket_tagged[CORE1_ID](dsp1_m1_bus.m1_bus_targ_socket_tagged[0]);
	d2_bus.m2_bus_init_socket_tagged[CORE1_ID](m2_bus.m2_bus_targ_socket_tagged[CORE1_ID]);
	d2_bus.biu_bus_init_socket_tagged[CORE1_ID](biu_bus.biu_bus_targ_socket_tagged[CORE1_ID]);
	d2_bus.dmu_bus_init_socket_tagged[CORE1_ID](dmu_bus.dmu_bus_targ_socket_tagged[CORE1_ID]);

	dma_bus.dma_init_socket_tagged[CORE1_ID](dsp1_m1_bus.m1_bus_targ_socket_tagged[1]); 	//Dma_Bus connect to M1_Bus dma
	dmu_bus.m1_dmu_init_socket_tagged[CORE1_ID](dsp1_m1_bus.m1_bus_targ_socket_tagged[2]); 	//Dmu_Bus connect to M1_Bus dmu

	dsp1.clk(clk);

	dsp[CORE1_ID] = &dsp1;
#ifdef C2CC
	dsp1_m1_bus.c2cc_init_socket(c2cc_wrap1.tx_targ_socket); 								//connect to c2cc_wrap
#endif
#endif

#if DSPNUM >= 3
	M1_Bus dsp2_m1_bus("dsp2_m1_bus", CORE2_ID, &multi_sim_arg);	
	dsp2_m1_bus.dma_bus_init_socket(dma_bus.dma_targ_socket_tagged[CORE2_ID]); 				//M1_Bus connect to Dma_Bus

	Core_Bus dsp2("dsp2", CORE2_ID, &multi_sim_arg);
	dma_bus.dma_d1_dcache_init_socket_tagged[CORE2_ID](dsp2.d1_dcache_targ_socket);
	dsp2.l2_bus_init_socket(l2_bus.l2_bus_targ_socket_tagged[CORE2_ID]); 					//connect to L2_Bus
	dsp2.d2_bus_init_socket(d2_bus.d2_bus_targ_socket_tagged[CORE2_ID]);
	d2_bus.m1_bus_init_socket_tagged[CORE2_ID](dsp2_m1_bus.m1_bus_targ_socket_tagged[0]);
	d2_bus.m2_bus_init_socket_tagged[CORE2_ID](m2_bus.m2_bus_targ_socket_tagged[CORE2_ID]);
	d2_bus.biu_bus_init_socket_tagged[CORE2_ID](biu_bus.biu_bus_targ_socket_tagged[CORE2_ID]);
	d2_bus.dmu_bus_init_socket_tagged[CORE2_ID](dmu_bus.dmu_bus_targ_socket_tagged[CORE2_ID]);

	dma_bus.dma_init_socket_tagged[CORE2_ID](dsp2_m1_bus.m1_bus_targ_socket_tagged[1]); 	//Dma_Bus connect to M1_Bus dma
	dmu_bus.m1_dmu_init_socket_tagged[CORE2_ID](dsp2_m1_bus.m1_bus_targ_socket_tagged[2]); 	//Dmu_Bus connect to M1_Bus dmu

	dsp2.clk(clk);

	dsp[CORE2_ID] = &dsp2;
#ifdef C2CC
	dsp2_m1_bus.c2cc_init_socket(c2cc_wrap2.tx_targ_socket); 								//connect to c2cc_wrap
#endif
#endif

#if DSPNUM >= 4
	M1_Bus dsp3_m1_bus("dsp3_m1_bus", CORE3_ID, &multi_sim_arg);	
	dsp3_m1_bus.dma_bus_init_socket(dma_bus.dma_targ_socket_tagged[CORE3_ID]); 				//M1_Bus connect to Dma_Bus

	Core_Bus dsp3("dsp3", CORE3_ID, &multi_sim_arg);
	dma_bus.dma_d1_dcache_init_socket_tagged[CORE3_ID](dsp3.d1_dcache_targ_socket);
	dsp3.l2_bus_init_socket(l2_bus.l2_bus_targ_socket_tagged[CORE3_ID]); 					//connect to L2_Bus
	dsp3.d2_bus_init_socket(d2_bus.d2_bus_targ_socket_tagged[CORE3_ID]);
	d2_bus.m1_bus_init_socket_tagged[CORE3_ID](dsp3_m1_bus.m1_bus_targ_socket_tagged[0]);
	d2_bus.m2_bus_init_socket_tagged[CORE3_ID](m2_bus.m2_bus_targ_socket_tagged[CORE3_ID]);
	d2_bus.biu_bus_init_socket_tagged[CORE3_ID](biu_bus.biu_bus_targ_socket_tagged[CORE3_ID]);
	d2_bus.dmu_bus_init_socket_tagged[CORE3_ID](dmu_bus.dmu_bus_targ_socket_tagged[CORE3_ID]);

	dma_bus.dma_init_socket_tagged[CORE3_ID](dsp3_m1_bus.m1_bus_targ_socket_tagged[1]); 	//Dma_Bus connect to M1_Bus dma
	dmu_bus.m1_dmu_init_socket_tagged[CORE3_ID](dsp3_m1_bus.m1_bus_targ_socket_tagged[2]); 	//Dmu_Bus connect to M1_Bus dmu

	dsp3.clk(clk);

	dsp[CORE3_ID] = &dsp3;
#ifdef C2CC
	dsp3_m1_bus.c2cc_init_socket(c2cc_wrap3.tx_targ_socket); 								//connect to c2cc_wrap
#endif
#endif

	dma_bus.dma_d2_dcache_init_socket(d2_bus.d2_bus_targ_socket_tagged[DSPNUM]);	
	l2_bus.ddr_mem_init_socket(biu_bus.biu_bus_targ_socket_tagged[DSPNUM]); 				//connect Biu_Bus
	m2_bus.dma_bus_init_socket(dma_bus.dma_targ_socket_tagged[DSPNUM]); 					//M2_Bus connect to Dma_Bus
	biu_bus.dma_bus_init_socket(dma_bus.dma_targ_socket_tagged[DSPNUM + 1]); 				//Biu_Bus connect to Dma_Bus

	dma_bus.dma_init_socket_tagged[DSPNUM](m2_bus.m2_bus_targ_socket_tagged[DSPNUM]);
	dma_bus.dma_init_socket_tagged[DSPNUM + 1](biu_bus.biu_bus_targ_socket_tagged[DSPNUM+1]);

	if (MULTI_ARG(boot, share_mode)) {
		void *soc_pthread(void *);
		pthread_t th;

		printf("startup soc_pthread, Now use not direct mode.\r\n");
		if (pthread_create(&th, NULL, soc_pthread, NULL) < 0) {
			printf("can not create soc pthread.\r\n");
			exit(-1);
		}
	}

	sc_start();
	shm_soc_del(&multi_sim_arg);
	soc_sim_del(&multi_sim_arg);
	return 0;

}
