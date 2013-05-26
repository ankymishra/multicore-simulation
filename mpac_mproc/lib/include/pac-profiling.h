#ifndef _PAC_PROFILING_H
#define _PAC_PROFILING_H
/*
	M1 DMA				dma_pdata[0]
		wr_count[0]		M1->M1
		wr_count[1]		M1->M2
		wr_count[2]		M1->DDR

	M2 DMA				dma_pdata[1]
		wr_count[0]		M2->M1
		wr_count[1]		M2->M2
		wr_count[2]		M2->DDR

	SYS DMA				dma_pdata[2]
		wr_count[0]		DDR->M1
		wr_count[1]		DDR->M2
		wr_count[2]		DDR->DDR

*/
#include "pac-list.h"
#include "mpac-mproc-define.h"

#define PROFILING_M1_DMA		0
#define PROFILING_M2_DMA		1
#define PROFILING_SYS_DMA		2

#define TO_M1		0
#define TO_M2 		1
#define TO_DDR		2

//structs it's for pac-iss and gdb
struct dma_profiling_data {
	long long wr_count[3];
};

struct mem_profiling_data {
	int rd_count;
	int wr_count;
	int cycle;
};

struct cache_profiling_data {
	int cache_miss;
	int cycle;
};

struct core_profiling_data {
	unsigned int pc;
	//double cycle;
	int cycle;
	struct cache_profiling_data l1_pdata;
	struct cache_profiling_data l2_pdata;
	struct mem_profiling_data m1_pdata[DSPNUM];
	struct mem_profiling_data m2_pdata;
	struct mem_profiling_data ddr_pdata;
};

struct data_list {
	struct list_head list;
	struct core_profiling_data core_pdata;
};

struct mem_contention {
	long long rw_cont;
};

struct cache_contention {
	long long rw_cont;
};

struct contention_profiling_data {
	struct mem_contention m2_cont;
	struct mem_contention ddr_cont;
	struct cache_contention l2_cont;
};

struct profiling_queue {
	unsigned int flag;										//1 is start profiling, 0 is end
	unsigned int ref_count;
	unsigned int start_pc, end_pc;
	unsigned long long file_num;
	unsigned long long inst_num;
	long long date;
	struct dma_profiling_data dma_pdata[2][3];				//dma_pdata[0]:start dma_pdata[1] end, the real data will be sub
															//dma_pdata[][0]:M1 dma_pdata[][1]:M2 dma_pdata[][2]:SYS_DMA 
	struct contention_profiling_data cont_pdata[2]; 		//contention_pdata[0]:start contention_pdata[1] end
	struct data_list *dlist;
};

struct profiling_queue_list {
	struct list_head queue_list;
	struct profiling_queue *queue;
	unsigned int ref_count;
};

//structs it's for pac-soc
struct core_profiling_control {
    unsigned int flag;  
    struct core_profiling_data core_data;
};

struct dma_profiling_control {
    unsigned int flag;
    struct dma_profiling_data dma_data[3];
};

struct contention_profiling_control {
	unsigned int flag;
	struct contention_profiling_data cont_data;
};

extern void profile_init(void);
extern struct profiling_queue *queue_init(unsigned int start_pc, unsigned int end_pc);
extern struct profiling_queue *queue_file_init(long long date, unsigned int start_pc, unsigned int end_pc);
extern void queue_list_add_tail(struct profiling_queue *pq);
extern void queue_data_add_tail(struct profiling_queue *pq, struct core_profiling_data *core_pdata);
extern void queue_data_dump_file(struct profiling_queue *pq, struct core_profiling_data *core_pdata, int flag);
extern void all_queue_report(void);
extern void queue_uninit(void);

extern struct profiling_queue_list *g_qlist;
#endif
