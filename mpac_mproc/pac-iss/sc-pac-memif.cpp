#include "pac-iss.h"

#ifdef PAC_2WAY_ICACHE_LINE
#include "sc-pac-if-way.h"
#elif PAC_4WAY_ICACHE_LINE
#include "sc-pac-if-way.h"
#elif PAC_8WAY_ICACHE_LINE
#include "sc-pac-if-way.h"
#else
#include "sc-pac-if-direct.h"
#endif


#include "sc-pac-memif.h"
#include "pac-socshm-prot.h"

extern struct soc_shm_prot *soc_shm_base_ptr;

void SC_pac_memif::idle(volatile int *flag)
{
	while (*flag != RESPONSE) {}
}

void SC_pac_memif::l2_icache_write(unsigned int addr, unsigned char *buf, int len)
{
	struct soc_shm_prot *base_ptr = soc_shm_base_ptr;
	base_ptr->addr = addr;
	base_ptr->len = (unsigned int) len;
	base_ptr->cmd = ICACHE_WRITE;
	base_ptr->flag = REQUEST;
	base_ptr->futex = 0x11;
	base_ptr->ls_flag = 4;

	idle(&base_ptr->flag);
	base_ptr->flag = IDLE;
}

void SC_pac_memif::dcache_flush(unsigned int addr, unsigned char *buf, int len)
{
	struct soc_shm_prot *base_ptr = soc_shm_base_ptr;
	base_ptr->addr = addr;
	base_ptr->len = len;
	base_ptr->cmd = DCACHE_FLUSH;
	base_ptr->flag = REQUEST;
	base_ptr->futex = 0x11;
	base_ptr->ls_flag = 4;

	idle(&base_ptr->flag);
	base_ptr->flag = IDLE;
}

void SC_pac_memif::memif_reset()
{
	struct soc_shm_prot *base_ptr = soc_shm_base_ptr;

	sc_pac_if_ptr->icache_write(0x0, 0x0, 0x0);
	dcache_flush(0x0, 0x0, 0x0);
	l2_icache_write(0x0, 0x0, 0x0);

	base_ptr->cmd = DBG_RESET;
	base_ptr->flag = REQUEST;
	base_ptr->ls_flag = 4;

	if (!multi_arg(boot, share_mode)) {
		idle(&base_ptr->flag);
	} else {
		int dummy_space, i;

		i = read(iss_soc_fifo_fd, &dummy_space, 1);
	}

	base_ptr->flag = IDLE;
}

int SC_pac_memif::dbg_dmem_read(unsigned int addr, unsigned char *buf, int len)
{
	struct soc_shm_prot *base_ptr = soc_shm_base_ptr;

//  printf("SC_pac_memif::dbg_dmem_read addr = 0x%08x.\r\n", (int)addr);
	base_ptr->addr = addr;
	base_ptr->len = (unsigned int) len;
	base_ptr->cmd = DBG_DMEM_READ;
	base_ptr->flag = REQUEST;
	base_ptr->ls_flag = 4;

	if (!multi_arg(boot, share_mode)) {
		idle(&base_ptr->flag);
	} else {
		int dummy_space, i;

		i = read(iss_soc_fifo_fd, &dummy_space, 1);
	}

	memcpy((unsigned char *) buf, (unsigned char *) base_ptr->buf, len);
	base_ptr->flag = IDLE;
	return 0;
}

int SC_pac_memif::dbg_dmem_write(unsigned int addr, unsigned char *buf, int len)
{
	struct soc_shm_prot *base_ptr = soc_shm_base_ptr;

//  printf("SC_pac_memif::dbg_dmem_write addr = 0x%08x.\r\n", (int)addr);
	base_ptr->addr = addr;
	base_ptr->len = (unsigned int) len;
	memcpy((unsigned char *) base_ptr->buf, (unsigned char *) buf, len);
	base_ptr->cmd = DBG_DMEM_WRITE;
	base_ptr->flag = REQUEST;
	base_ptr->ls_flag = 4;

	if (!multi_arg(boot, share_mode)) {
		idle(&base_ptr->flag);
	} else {
		int dummy_space, i;

		i = read(iss_soc_fifo_fd, &dummy_space, 1);
	}

	base_ptr->flag = IDLE;
	return 0;
}

void SC_pac_memif::dbg_start_profiling(unsigned int pc)
{
	struct soc_shm_prot *base_ptr = soc_shm_base_ptr;

	struct list_head *list;
	struct profiling_queue_list *qlist_pos;

	list_for_each(list, &(g_qlist->queue_list)) {
		qlist_pos = list_entry(list, struct profiling_queue_list, queue_list);

		if ((qlist_pos->queue->start_pc == pc)
			|| (qlist_pos->queue->flag == 1)) {
//dma rd/wr count
//			if (qlist_pos->queue->flag != 1) {
//				base_ptr->cmd = DBG_GET_DMA_PROFILING_DATA;
//				base_ptr->flag = REQUEST;
//				base_ptr->futex = 0x11;
//				if (!multi_arg(boot, share_mode)) {
//					idle(&base_ptr->flag);
//				} else {
//					int dummy_space, i;
//
//					i = read(iss_soc_fifo_fd, &dummy_space, 1);
//				}
//				memcpy(qlist_pos->queue->dma_pdata[0],
//					   (unsigned char *) base_ptr->buf,
//					   3 * sizeof(struct dma_profiling_data));
//			}
//contention count
//			if (qlist_pos->queue->flag != 1) {
//				base_ptr->cmd = DBG_GET_CONTENTION_PROFILING_DATA;
//				base_ptr->flag = REQUEST;
//				base_ptr->futex = 0x11;
//				if (!multi_arg(boot, share_mode)) {
//					idle(&base_ptr->flag);
//				} else {
//					int dummy_space, i;
//
//					i = read(iss_soc_fifo_fd, &dummy_space, 1);
//				}
//				memcpy(&(qlist_pos)->queue->cont_pdata[0],
//					   (unsigned char *) base_ptr->buf,
//					   sizeof(struct contention_profiling_data));
//			}
//mem rd/wr count, cache miss
			qlist_pos->queue->flag = 1;
			base_ptr->cmd = DBG_START_PROFILING;
			base_ptr->flag = REQUEST;
			base_ptr->futex = 0x11;
			base_ptr->ls_flag = 4;

			if (!multi_arg(boot, share_mode)) {
				idle(&base_ptr->flag);
			} else {
				int dummy_space, i;

				i = read(iss_soc_fifo_fd, &dummy_space, 1);
			}
			//break;
		}
	}
	base_ptr->flag = IDLE;
}

void SC_pac_memif::dbg_stop_profiling(unsigned int pc)
{
	struct soc_shm_prot *base_ptr = soc_shm_base_ptr;
	struct list_head *list;
	struct list_head *q;
	struct profiling_queue_list *qlist_pos;
	struct core_profiling_data core_pdata;

	//list_for_each(list,  &(g_qlist->queue_list)) {
	list_for_each_safe(list, q, &(g_qlist->queue_list)) {
		qlist_pos = list_entry(list, struct profiling_queue_list, queue_list);

		if (qlist_pos->queue->end_pc == pc) {
//dma rd/wr count
//			base_ptr->cmd = DBG_GET_DMA_PROFILING_DATA;
//			base_ptr->flag = REQUEST;
//			base_ptr->futex = 0x11;
//			if (!multi_arg(boot, share_mode)) {
//				idle(&base_ptr->flag);
//			} else {
//				int dummy_space, i;

//				i = read(iss_soc_fifo_fd, &dummy_space, 1);
//			}
//			memcpy(qlist_pos->queue->dma_pdata[1],
//				   (unsigned char *) base_ptr->buf,
//				   3 * sizeof(struct dma_profiling_data));
//contention count
//			base_ptr->cmd = DBG_GET_CONTENTION_PROFILING_DATA;
//			base_ptr->flag = REQUEST;
//			base_ptr->futex = 0x11;
//			if (!multi_arg(boot, share_mode)) {
//				idle(&base_ptr->flag);
//			} else {
//				int dummy_space, i;
//
//				i = read(iss_soc_fifo_fd, &dummy_space, 1);
//			}
//			memcpy(&(qlist_pos)->queue->cont_pdata[1],
//				   (unsigned char *) base_ptr->buf,
//				   sizeof(struct contention_profiling_data));
//mem rd/wr count, cache miss 
			qlist_pos->queue->flag = 0;
			base_ptr->cmd = DBG_STOP_PROFILING;
			base_ptr->flag = REQUEST;
			base_ptr->futex = 0x11;
			base_ptr->ls_flag = 4;

			if (!multi_arg(boot, share_mode)) {
				idle(&base_ptr->flag);
			} else {
				int dummy_space, i;

				i = read(iss_soc_fifo_fd, &dummy_space, 1);
			}
			memcpy(&core_pdata, (unsigned char *) base_ptr->buf,
				   sizeof(core_profiling_data));
			core_pdata.pc = pc;
#if 0
			queue_data_add_tail(qlist_pos->queue, &core_pdata);
#else
			//list_del(&(qlist_pos)->queue_list);
			queue_data_dump_file(qlist_pos->queue, &core_pdata, 1);
			//printf("==== free queue 0x%08x ====\r\n",qlist_pos->queue);
			//free(qlist_pos->queue);
			//printf("==== free queue_list 0x%08x ====\r\n", qlist_pos);
			//free(qlist_pos);
#endif

		} else if (qlist_pos->queue->flag == 1) {
			base_ptr->cmd = DBG_STOP_PROFILING;
			base_ptr->flag = REQUEST;
			base_ptr->futex = 0x11;
			base_ptr->ls_flag = 4;

			if (!multi_arg(boot, share_mode)) {
				idle(&base_ptr->flag);
			} else {
				int dummy_space, i;

				i = read(iss_soc_fifo_fd, &dummy_space, 1);
			}
			memcpy(&core_pdata, (unsigned char *) base_ptr->buf,
				   sizeof(core_profiling_data));
			core_pdata.pc = pc;
#if 0
			queue_data_add_tail(qlist_pos->queue, &core_pdata);
#else
			queue_data_dump_file(qlist_pos->queue, &core_pdata, 0);
#endif
		}
	}
	base_ptr->flag = IDLE;
}

#define CFU_MEM_READ	0x1
#define CFU_MEM_WRITE	0x2
#define CFU_CMD_NORMAL	0x0
#define CFU_CMD_RESET	0x3

#define CFU_REG_RSP_SUCC				0x0
#define CFU_REG_RSP_WRITE_FORBIDDEN			0x1
#define CFU_REG_RSP_RW_ONLY				0x2
#define CFU_REG_UNDEF_REGION				0x3

#define CFU_CMD_FUNC_READY				0x0
#define CFU_CMD_FUNC_BUSY				0x20
#define CFU_CMD_FUNC_PAUSE				0x21
#define CFU_CMD_FUNC_KILLED				0x22
#define CFU_CMD_UNDEF_CMD				0x10
#define CFU_CMD_UNDEF_FUNC_ID				0x11

void SC_pac_memif::cfu_err_list_clear(void)
{
	//clear err history list
	unsigned int i;
	unsigned int addr;

	for (i = 0; i < CFU_NUM; i++) {
		for (addr = CFU_ERRHIST0; addr < CFU_ERRCNT; i += 2) {
			*(cfu_ptr + i * CFU_BUFSIZE + addr) = 0x0;
		}
	}
}

int SC_pac_memif::cfu_mem_access(unsigned char sr_num, unsigned int data)
{
	unsigned int action = ((data >> 28) & 0x3);
	unsigned int cmd = data >> 30;
	unsigned int addr = ((data >> 16) & 0xfff);

	if (action == 0x3)
		cfu_err_list_clear();

	if (addr >= 0x1000) {
		printf("addr  0x%08x didn't in cfu region\r\n", addr);
		cfu_resp = CFU_REG_UNDEF_REGION;
		return -1;
	}

	if (cmd == CFU_MEM_READ) {
		cfu_resp = *(cfu_ptr + (sr_num - 4) * CFU_BUFSIZE + addr);
	} else {
		*(cfu_ptr + (sr_num - 4) * CFU_BUFSIZE + addr) = data & 0xffff;
		cfu_resp = CFU_REG_RSP_SUCC;
	}

	return 0;
}

int SC_pac_memif::cfu_ctrl_cmd(unsigned char sr_num, unsigned int data)
{
	unsigned int action = ((data >> 28) & 0x3);
	unsigned int func_id = (data & 0xff);

	if (action > 0x3) {
		printf("cfu didn't define this cmd 0x%08x\r\n", action);
		cfu_resp = CFU_CMD_UNDEF_CMD;
		return -1;
	} else if (func_id > 0xff) {
		printf("cfu didn't define this func id %d\r\n", func_id);
		cfu_resp = CFU_CMD_UNDEF_FUNC_ID;
		return -1;
	}

	if (action == 0) {
		*(cfu_ptr + CFU_FLAG_OFFSET + (sr_num - 4) * CFU_BUFSIZE) =
			CFU_FUNC_START | func_id;
		while (*(cfu_ptr + CFU_FLAG_OFFSET + (sr_num - 4) * CFU_BUFSIZE) !=
			   0);
	}

	return 0;
}

void SC_pac_memif::cfu_reset()
{
}

void SC_pac_memif::cfu_module(unsigned char sr_num, unsigned int data)
{
	int ret = -1;
	unsigned char cmd = data >> 30;

	switch (cmd) {
	case CFU_MEM_READ:
	case CFU_MEM_WRITE:
		ret = cfu_mem_access(sr_num, data);
		break;
	case CFU_CMD_NORMAL:
		ret = cfu_ctrl_cmd(sr_num, data);
		break;
	case CFU_CMD_RESET:
		cfu_reset();
		break;
	default:
		printf("error CFU CMD %d\r\n", data);
	}

	if (ret == -1)
		printf("error in cfu module\r\n");

}

void SC_pac_memif::cfu_init(char *filename)
{
	cfu_ptr =
		(unsigned short *) shm_create(filename, (CFU_NUM * CFU_BUFSIZE * 2),
									  O_RDWR);
}
