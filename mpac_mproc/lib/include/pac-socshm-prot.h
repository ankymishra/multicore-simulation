#ifndef PAC_SOCSHM_PROT_H_INCLUDED
#define PAC_SOCSHM_PROT_H_INCLUDED

//#define PAGE_SIZE	4096

//#define PROT_BUFSIZE	(PAGE_SIZE - 32)

#define		IDLE				0
#define		REQUEST				1
#define		RESPONSE			2
#define		RESPONSE_OK			3

#define		DMEM_READ			10
#define		DMEM_WRITE			11
#define		DMEM_SEMIHOST_READ	12
#define		ICACHE_READ			13
#define		ICACHE_WRITE		14
#define     DCACHE_FLUSH        15
#define     CORE_START_PROFILING	16
#define     CORE_STOP_PROFILING		17

#define		DBG_DMEM_READ	20	
#define		DBG_DMEM_WRITE	21
#define		DBG_RESET		22
#define		DBG_START_PROFILING	23
#define 	DBG_STOP_PROFILING	24
#define		DBG_GET_DMA_PROFILING_DATA	25
#define		DBG_GET_CONTENTION_PROFILING_DATA	26


#define MAX_SOC_SHM_INST 4

#define INST_SC 0
#define INST_C1 1
#define INST_C2 2
#define INST_IF 3

#define INST_DMU_SC 4
#define INST_DMU_C1 5
#define INST_DMU_C2 6


struct soc_shm_prot {
	int futex;
	int d0;
	int d1;
	int d2;
	
// 0 idle
// 1 request
// 2 response
	volatile int flag;
	volatile int ls_flag;
	volatile int inst_mode;
// 10 dmem_read
// 11 dmem_write
// 12 dmem_semihost_read
// 13 icache_read
// 14 icache_write
// 15 dbg_dmem_read
// 16 dbg_dmem_write
	volatile int cmd;

	volatile unsigned int addr;
	volatile unsigned int len;
	volatile unsigned char buf[PROT_BUFSIZE];
};


extern struct soc_shm_prot *soc_shm_base_ptr;
extern void shm_soc_setup(struct sim_arg *multi_sim_arg);
extern void shm_soc_del(struct sim_arg *multi_sim_arg);

#endif
