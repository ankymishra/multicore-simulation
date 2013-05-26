#include "stdio.h"
#include "stdlib.h"
#include "string.h"
#include "sys/stat.h"
#include "sys/types.h"
#include "unistd.h"

#include "pac-profiling.h"
#define MAX_INST_PROFILE_NUM 2*1024*1024

struct profiling_queue_list *g_qlist;

void profile_init()
{
	g_qlist = (struct profiling_queue_list *)malloc(sizeof(struct profiling_queue_list));
	//printf("==== malloc g_qlist 0x%08x ====\r\n", g_qlist);
	g_qlist->ref_count = 1;
	if (g_qlist == NULL) {
		printf("can't malloc global queue list\r\n");
		exit(-1);
	}

	g_qlist->queue = (struct profiling_queue *) malloc(sizeof(struct profiling_queue));
	//printf("==== malloc g_qlist queue 0x%08x ====\r\n", g_qlist->queue);
	g_qlist->queue->ref_count = 1;
	if ((g_qlist->queue) == NULL) {
		printf("can't malloc global queue\r\\n");
		exit(-1);
	}
	INIT_LIST_HEAD(&(g_qlist->queue_list));
}

struct profiling_queue *queue_init(unsigned int start_pc, unsigned int end_pc)
{
	struct profiling_queue *pq = (struct profiling_queue *)malloc(sizeof(profiling_queue));
	//printf("queue init 0x%08x\r\n",pq);
	if (pq == NULL) {
		printf("can't malloc profiling queue \r\n");
		exit(-1);
	}
	pq->start_pc = start_pc;
	pq->end_pc = end_pc;

	pq->dlist = (struct data_list *)malloc(sizeof(struct data_list));
	pq->ref_count = 1;
	//printf("queue data_list 0x%08x\r\n",pq->dlist);
	if (pq->dlist == NULL) {
		printf("can't malloc profiling queue data_list\r\n");
		exit(-1);
	}

	INIT_LIST_HEAD(&(pq->dlist->list));

	return pq;
}

void queue_uninit(void)
{
	char buf[128];
	char log_buf[128];
	FILE *fp;
	struct list_head *qlist;
	struct list_head *q;
	struct profiling_queue_list *qlist_pos;

	memset(buf, '\n', sizeof(buf));

	list_for_each_safe(qlist, q, &(g_qlist->queue_list)) {
		qlist_pos = list_entry(qlist, struct profiling_queue_list, queue_list);
		if ((((struct profiling_queue_list *)(qlist_pos))->queue)->inst_num != 0)
			sprintf(buf, "%s/%lld.profile/%lld_%lld.profile",getenv("HOME"), 
						(((struct profiling_queue_list *)(qlist_pos))->queue)->date, 
						(((struct profiling_queue_list *)(qlist_pos))->queue)->date, 
						(((struct profiling_queue_list *)(qlist_pos))->queue)->file_num);

		sprintf(log_buf, "%s/%lld.profile/%lld.log",getenv("HOME"), 
					(((struct profiling_queue_list *)(qlist_pos))->queue)->date, 
					(((struct profiling_queue_list *)(qlist_pos))->queue)->date);

		fp = fopen(log_buf, "a+");
		if (fp == NULL) {
			printf("can't open profile file %s\r\n", log_buf);
			exit(-1);
		}

		(((struct profiling_queue_list *)(qlist_pos))->queue)->inst_num = 0;
		(((struct profiling_queue_list *)(qlist_pos))->queue)->file_num = 0;
		fprintf(fp, "%s\n", buf);
		fclose(fp);



		//free(((struct profiling_queue_list *)(qlist_pos))->queue);
		//free(qlist_pos);
	}
}

struct profiling_queue *queue_file_init(long long date, unsigned int start_pc, unsigned int end_pc)
{
	int ret;
	struct profiling_queue *pq = (struct profiling_queue *)malloc(sizeof(profiling_queue));
	char buf[128];
	char dir_buf[128];
	FILE *fp;

	//printf("==== queue init 0x%08x ====\r\n",pq);
	if (pq == NULL) {
		printf("can't malloc profiling queue \r\n");
		exit(-1);
	}
	pq->start_pc = start_pc;
	pq->end_pc = end_pc;
	pq->date = date;
	sprintf(dir_buf, "%s/%lld.profile", getenv("HOME"), date);
	
#if 0
	fopen(filename, "wb+");
#else
	ret = mkdir(dir_buf, 0775);
	if (ret == -1) {
		printf("error to create profile directory, it's exist\r\n");
		exit(-1);
	}
#endif
	pq->file_num = 0;
	sprintf(buf, "%s/%lld.profile/%lld.log",getenv("HOME"), pq->date, pq->date);

	fp = fopen(buf, "w+");
	if (fp == NULL) {
		printf("error to create profile file\r\n");
		exit(-1);
	}
	fclose(fp);

	sprintf(buf, "%s/%lld.profile/%lld_%lld.profile",getenv("HOME"), pq->date, pq->date, pq->file_num);

	fp = fopen(buf, "wb+");
	if (fp == NULL) {
		printf("error to create profile file\r\n");
		exit(-1);
	}

#if 0
	fprintf(fp, "%s","-----------------------------------------------------------");
	fprintf(fp, "%s\n\n","-----------------------------------------------------------");

	fprintf(fp, "%s\n\n", "Profile result");

	fprintf(fp, "%s", "pc(address)    l1_cacheMiss    l1_cacheMiss");
	fprintf(fp, "%s", "    m1_data_0(r  w)    m1_data_1(r  w)");
	fprintf(fp, "%s", "    m1_data_2(r  w)    m1_data_3(r  w)");
	fprintf(fp, "%s", "    m2_data(r  w)");
	fprintf(fp, "%s\n\n","    ddr_data(r  w)");

	fprintf(fp, "%s","-----------------------------------------------------------");
	fprintf(fp, "%s\n\n","-----------------------------------------------------------");
#endif

	fclose(fp);
	return pq;
}

void queue_list_add_tail(struct profiling_queue *pq)
{
	struct profiling_queue_list *qlist;
	qlist = (struct profiling_queue_list *)malloc(sizeof(struct profiling_queue_list));
	//printf("==== new queue list 0x%08x ====\r\n",qlist);
	if (qlist == NULL) {
		printf("can't malloc profiling queue list\r\n");
		exit(-1);
	}

	INIT_LIST_HEAD(&(qlist->queue_list));
	qlist->queue = pq;
	list_add_tail(&(qlist->queue_list), &(g_qlist->queue_list));
	g_qlist->ref_count++;
	//printf("global queue ref_count %d\r\n", g_qlist->ref_count);
}

void queue_data_dump_file(struct profiling_queue *pq, struct core_profiling_data *core_pdata, int flag)
{
	FILE *fp;
	char buf[128];

	memset(buf, '\n', sizeof(buf));
	sprintf(buf, "%s/%lld.profile/%lld_%lld.profile",getenv("HOME"), pq->date, pq->date, pq->file_num);

	fp = fopen(buf, "ab+");
	if (fp == NULL) {
		printf("can't open profile file %s\r\n", buf);
		exit(-1);
	}
	
#if 0
	fprintf(fp, "0x%08x    %d    %d    %d  %d    %d  %d    %d  %d    %d  %d    %d  %d    %d  %d\r\n", 
			core_pdata->pc, core_pdata->l1_pdata.cache_miss,
			core_pdata->l2_pdata.cache_miss, core_pdata->m1_pdata[0].rd_count, core_pdata->m1_pdata[0].wr_count,
			core_pdata->m1_pdata[1].rd_count, core_pdata->m1_pdata[1].wr_count,core_pdata->m1_pdata[2].rd_count, 
			core_pdata->m1_pdata[2].wr_count,core_pdata->m1_pdata[3].rd_count, core_pdata->m1_pdata[3].wr_count,
			core_pdata->m2_pdata.rd_count, core_pdata->m2_pdata.wr_count, core_pdata->ddr_pdata.rd_count, 
			core_pdata->ddr_pdata.wr_count);
	
	if (flag == 1) {
		fprintf(fp, "\n%s","-----------------------------------------------------------");
		fprintf(fp, "%s","-----------------------------------------------------------\n");
	}
#endif
	
	fwrite(core_pdata, sizeof(struct core_profiling_data), 1, fp);
	fclose(fp);

	pq->inst_num++;

	if (pq->inst_num == MAX_INST_PROFILE_NUM) {
		pq->inst_num = 0;
		pq->file_num++;

		char log_buf[128];

		sprintf(log_buf, "%s/%lld.profile/%lld.log",getenv("HOME"), pq->date, pq->date);

		fp = fopen(log_buf, "a+");
		if (fp == NULL) {
			printf("can't open profile file %s\r\n", log_buf);
			exit(-1);
		}

		fprintf(fp, "%s\n", buf);
		fclose(fp);
	}
}

void queue_data_add_tail(struct profiling_queue *pq, struct core_profiling_data *core_pdata)
{
	struct data_list *p;
	p = (struct data_list *)malloc(sizeof(struct data_list));
	//printf("new data 0x%08x\r\n",p);
	if (p == NULL) {
		printf("can't malloc profiling list\r\n");
		exit(-1);
	}

	INIT_LIST_HEAD(&(p->list));
	memcpy(&(p->core_pdata), core_pdata, sizeof(struct core_profiling_data));
	list_add_tail(&(p->list), &(pq->dlist->list));
	pq->ref_count++;
	//printf("queue data list ref_count %d\r\n",pq->ref_count);
}

#if 0
void all_queue_report(void)
{
	struct list_head *qlist;
	struct list_head *dlist;
	struct list_head *d, *q;
	struct data_list *pos;
	struct profiling_queue_list *qlist_pos;
	list_for_each_safe(qlist, q, &(g_qlist->queue_list)) {
		qlist_pos = list_entry(qlist, struct profiling_queue_list, queue_list);
		//printf("report profiling queue start_pc 0x%08x, end_pc 0x%08x\r\n",qlist_pos->queue->start_pc, qlist_pos->queue->end_pc);
		list_for_each_safe(dlist, d, &(qlist_pos->queue->dlist->list)) {
			pos = list_entry(dlist, struct data_list, list);
#if 0
			printf("\treport profiling queue pc 0x%08x\r\n",pos->core_pdata.pc);		
			printf("\treport profiling queue l1_cache_miss %lld\r\n",pos->core_pdata.l1_pdata.cache_miss);		
			printf("\treport profiling queue l2_cache_miss %lld\r\n",pos->core_pdata.l2_pdata.cache_miss);		

			for (int i= 0; i < DSPNUM; i++) {
				printf("\treport profiling queue [CORE%d] read m1 count %lld\r\n",i, pos->core_pdata.m1_pdata[i].rd_count);		
				printf("\treport profiling queue [CORE%d] write count %lld\r\n",i, pos->core_pdata.m1_pdata[i].wr_count);
			}

			printf("\treport profiling queue m2 read count %lld\r\n",pos->core_pdata.m2_pdata.rd_count);		
			printf("\treport profiling queue m2 write count %lld\r\n",pos->core_pdata.m2_pdata.wr_count);		
			printf("\treport profiling queue ddr read count %lld\r\n",pos->core_pdata.ddr_pdata.rd_count);		
			printf("\treport profiling queue ddr write count %lld\r\n",pos->core_pdata.ddr_pdata.wr_count);		
#endif
			//printf("free data_list 0x%08x\r\n",pos);
			list_del(&(pos->list));
			free(pos);
		}

		//printf("free data_list 0x%08x\r\n",dlist);
		list_del(dlist);
		free(dlist);
#if 0
		printf("report profiling queue M1_DMA write M1 count %lld\r\n",
				qlist_pos->queue->dma_pdata[PROFILING_M1_DMA].wr_count[TO_M1]);
		printf("report profiling queue M1_DMA write M2 count %lld\r\n",
				qlist_pos->queue->dma_pdata[PROFILING_M1_DMA].wr_count[TO_M2]);
		printf("report profiling queue M1_DMA write DDR count %lld\r\n",
				qlist_pos->queue->dma_pdata[PROFILING_M1_DMA].wr_count[TO_DDR]);	

		printf("report profiling queue M2_DMA write M1 count %lld\r\n",
				qlist_pos->queue->dma_pdata[PROFILING_M2_DMA].wr_count[TO_M1]);
		printf("report profiling queue M2_DMA write M2 count %lld\r\n",
				qlist_pos->queue->dma_pdata[PROFILING_M2_DMA].wr_count[TO_M2]);
		printf("report profiling queue M2_DMA write DDR count %lld\r\n",
				qlist_pos->queue->dma_pdata[PROFILING_M2_DMA].wr_count[TO_DDR]);

		printf("report profiling queue SYS_DMA write M1 count %lld\r\n",
				qlist_pos->queue->dma_pdata[PROFILING_SYS_DMA].wr_count[TO_M1]);
		printf("report profiling queue SYS_DMA write M2 count %lld\r\n",
				qlist_pos->queue->dma_pdata[PROFILING_SYS_DMA].wr_count[TO_M2]);
		printf("report profiling queue SYS_DMA write DDR count %lld\r\n",
				qlist_pos->queue->dma_pdata[PROFILING_SYS_DMA].wr_count[TO_DDR]);
#endif
		//printf("free queue 0x%08x\r\n",((struct profiling_queue_list *)(qlist_pos))->queue);
		free(((struct profiling_queue_list *)(qlist_pos))->queue);
		//printf("free queue_list 0x%08x\r\n",qlist_pos);
		free(qlist_pos);
	}
	//printf("free queue 0x%08x\r\n",((struct profiling_queue_list *)(qlist))->queue);
	free(((struct profiling_queue_list *)(qlist))->queue);
	//printf("free queue_list 0x%08x\r\n",qlist);
	free(qlist);
}
#endif
