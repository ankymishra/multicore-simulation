#ifndef MPAC_MPROC_SIM_ARG_H_INCLUDED
#define MPAC_MPROC_SIM_ARG_H_INCLUDED

#include "pac-shm.h"

#define MULTI_ARG(LABLE, ARG)	(multi_sim_arg.LABLE.ARG)
#define multi_arg(LABLE, ARG)	(multi_sim_arg->LABLE.ARG)

struct core_arg {
	char *core_bin;
	char *core_tic;
	unsigned int core_load_addr;
	unsigned int core_start_pc;
};

struct core_m1_arg {
	unsigned int dmem_m1_offset;
	unsigned int dmem_m1_size;
	unsigned int dmem_m1_bank_size;
	unsigned int m1_rd_delay;
	unsigned int m1_wr_delay;
	unsigned int m1_rd_cont_delay;
	unsigned int m1_wr_cont_delay;
};

struct core_biu_arg {
	unsigned int biu_offset;
	unsigned int biu_size;
	unsigned int biu_rd_delay;
	unsigned int biu_wr_delay;
};

struct core_icu_arg {
	unsigned int icu_offset;
	unsigned int icu_size;
	unsigned int icu_rd_delay;
	unsigned int icu_wr_delay;
};

struct core_dmu_arg {
	unsigned int dmu_offset;
	unsigned int dmu_size;
	unsigned int dmu_rd_delay;
	unsigned int dmu_wr_delay;
};

struct core_dma_arg {
	unsigned int dma_offset;
	unsigned int dma_size;
	unsigned int dma_rd_delay;
	unsigned int dma_wr_delay;
};

struct core_l1_arg {
	unsigned int l1_cache_type;
	unsigned int l1_cache_size;
	unsigned int l1_cache_line_size;
	unsigned int l1_rd_delay;
};

struct core_d1_arg {
	unsigned int d1_cache_type;
	unsigned int d1_cache_size;
	unsigned int d1_cache_line_size;
	unsigned int d1_rd_delay;
	unsigned int d1_wr_delay;
};

struct res1_arg {
	unsigned int res1_offset;
	unsigned int res1_size;
};

struct core_res2_arg {
	unsigned int res2_offset;
	unsigned int res2_size;
};
struct pacdsp_arg {
	unsigned int core_base;
	struct core_arg core;
	struct core_m1_arg m1_mem;
	struct res1_arg res1;
	struct core_l1_arg l1_cache;
	struct core_d1_arg d1_cache;
	struct core_biu_arg biu;
	struct core_icu_arg icu;
	struct core_dmu_arg dmu;
	struct core_dma_arg dma;
	struct core_res2_arg res2;
};

struct m2_arg {
	unsigned int dmem_m2_base;
	unsigned int dmem_m2_size;
	unsigned int dmem_m2_bank_size;
	unsigned int m2_rd_delay;
	unsigned int m2_wr_delay;
	unsigned int m2_rd_cont_delay;
	unsigned int m2_wr_cont_delay;
};

struct l2_arg {
	unsigned int l2_cache_type;
	unsigned int l2_cache_size;
	unsigned int l2_cache_line_size;
	unsigned int l2_rd_delay;
};

struct d2_arg {
	unsigned int d2_cache_type;
	unsigned int d2_cache_size;
	unsigned int d2_cache_line_size;
	unsigned int d2_rd_delay;
	unsigned int d2_wr_delay;
};

struct l2_icu_arg {
	unsigned int l2_icu_base;
	unsigned int l2_icu_size;
	unsigned int l2_icu_rd_delay;
	unsigned int l2_icu_wr_delay;
};

struct m2_dmu_arg {
	unsigned int m2_dmu_base;
	unsigned int m2_dmu_size;
	unsigned int m2_dmu_rd_delay;
	unsigned int m2_dmu_wr_delay;
};

struct m2_dma_arg {
	unsigned int m2_dma_base;
	unsigned int m2_dma_size;
	unsigned int m2_dma_rd_delay;
	unsigned int m2_dma_wr_delay;
};

struct sem_arg {
	unsigned int sem_base;
	unsigned int sem_size;
	unsigned int sem_rd_delay;
	unsigned int sem_wr_delay;
};

struct c2cc_arg {
	unsigned int c2cc_base;
	unsigned int c2cc_size;
	unsigned int c2cc_rd_delay;
	unsigned int c2cc_wr_delay;
};

struct ddr_arg {
	unsigned int ddr_memory_base;
	unsigned int ddr_memory_size;
	unsigned int ddr_memory_bank_size;
	unsigned int ddr_shm_base;
	unsigned int ddr_shm_size;
	unsigned int ddr_rd_delay;
	unsigned int ddr_wr_delay;
	unsigned int ddr_rd_cont_delay;
	unsigned int ddr_wr_cont_delay;
};

struct sys_dma_arg {
	unsigned int sys_dma_base;
	unsigned int sys_dma_size;
	unsigned int sys_dma_rd_delay;
	unsigned int sys_dma_wr_delay;
};

struct biu_arg {
	unsigned int biu_rd_delay;
	unsigned int biu_wr_delay;
};

struct dump_info {
	char *dump_file;
	int dump_mode;
	unsigned int dump_addr;
	int dump_len;
};

struct boot_opt {
	int use_gdbserver;
	unsigned int qemu_addr;
	int use_profiling;
	int use_semihost;
	int gdbserver_port;
	int share_mode;
	int cfu_mode;
	char *cfu_shm_name;
	char *soc_shm_name;
	char *iss_shm_name;
	char *core_shm_name;
	char *m2_shm_name;
	char *ddr_shm_name;
	char *sysdma_shm_name;
	char *soc_fifo_name;
	char *iss_fifo_rd_name;
	char *iss_fifo_wr_name;
};
 
struct other_opt {
	int sim_time_unit;
};

struct sim_arg {
	struct pacdsp_arg pacdsp[DSPNUM];
	struct m2_arg m2_mem;
	struct l2_arg l2_cache;
	struct d2_arg d2_cache;
	struct l2_icu_arg l2_icu;
	struct m2_dmu_arg m2_dmu;
	struct m2_dma_arg m2_dma;
	struct sem_arg sem;
	struct c2cc_arg c2cc;
	struct ddr_arg ddr_mem;
	struct biu_arg biu;
	struct sys_dma_arg sys_dma;
	struct dump_info dump;
	struct boot_opt boot;
	struct other_opt other;
	struct shm_type shm_ptr;
};

#endif
