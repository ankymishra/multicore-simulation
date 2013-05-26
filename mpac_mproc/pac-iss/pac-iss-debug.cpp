#include "pac-dsp.h"
#include "pac-issshm-prot.h"

#ifdef PAC_2WAY_ICACHE_LINE
#include "sc-pac-if-way.h"
#elif PAC_4WAY_ICACHE_LINE
#include "sc-pac-if-way.h"
#elif PAC_8WAY_ICACHE_LINE
#include "sc-pac-if-way.h"
#else
#include "sc-pac-if-direct.h"
#endif


//#define DEBUG 1
#undef DEBUG
#ifdef DEBUG
#define dprintf(x...) printf(x)
#else
#define dprintf(x...) 
#endif

extern struct profiling_queue_list *g_qlist;

int pac_dsp::pac_dsp_get_id(struct iss_shm_prot *prot)
{
	return 0;
}

int pac_dsp::pac_dsp_init_cmd(struct iss_shm_prot *prot)
{
	int ret;

	dprintf("PAC_DSP_INIT_CMD\r\n");
	be_stoped = 0;
	active_core_stop = 0;
	step_num = -1;
	eStopFlag = STOP_TRAP;
	ro_regs.sim_end = 0;
	pre_breakpc = 0xffffffff;
	sc_pac_memif_ptr_0->dcache_flush(0x0, 0x0, 0x0); //flush d1 d2 cache
	sc_pac_if_ptr->icache_write(0x0, 0x0, 0);	//flush l1 l2 cache
	sc_pac_memif_ptr_0->l2_icache_write(0x0, 0x0, 0x0);
	dbg_soc_reset();

	ret = write(gdb_iss_fifo_wr_fd, ISS_RESPONSE_OK, 1);	
	if (ret == -1)
		return -1;

	return 0;
}

int pac_dsp::pac_dsp_exit_cmd(struct iss_shm_prot *prot)
{
	int ret;
	struct list_head *qlist;
	struct list_head *q;
	struct profiling_queue_list *qlist_pos;

	printf("PAC_DSP_EXIT_CMD\r\n");

	list_for_each_safe(qlist, q, &(g_qlist->queue_list)) {
		qlist_pos = list_entry(qlist, struct profiling_queue_list, queue_list);
		list_del(qlist);
		qlist_pos->ref_count--;
		free(((struct profiling_queue_list *)(qlist_pos))->queue);
		free(qlist_pos);
	}

	prot->flag = ISS_EXIT;
	ret = write(gdb_iss_fifo_wr_fd, ISS_RESPONSE_OK, 1);

	if (ret == -1)
		return -1;

	return 0;
}

int pac_dsp::pac_dsp_write_mem_cmd(struct iss_shm_prot *prot)
{
	int ret;

	dprintf("PAC_DSP_WRITE_MEM_CMD\r\n");
	ret = sc_pac_memif_ptr_0->dbg_dmem_write(prot->cmd.write_mem.addr, prot->buf, prot->cmd.write_mem.len);

	if (ret != -1) {
		ret = write(gdb_iss_fifo_wr_fd, ISS_RESPONSE_OK, 1);
	} else {
		ret = write(gdb_iss_fifo_wr_fd, ISS_RESPONSE_FAIL, 1);
		return -1;
	}

	if (ret == -1)
		return -1;

	return 0;
}

int pac_dsp::pac_dsp_read_mem_cmd(struct iss_shm_prot *prot)
{
	int ret;

	dprintf("PAC_DSP_READ_MEM\r\n");
	ret = sc_pac_memif_ptr_0->dbg_dmem_read(prot->cmd.write_mem.addr, prot->buf, prot->cmd.write_mem.len);

	if (ret != -1) {
		ret = write(gdb_iss_fifo_wr_fd, ISS_RESPONSE_OK, 1);
	} else {
		ret = write(gdb_iss_fifo_wr_fd, ISS_RESPONSE_FAIL, 1);
		return -1;
	}

	if (ret == -1)
		return -1;

	return 0;
}

int pac_dsp::pac_dsp_write_reg_cmd(struct iss_shm_prot *prot)
{
	int ret, regno;

	dprintf("PAC_DSP_WRITE_REG_CMD\r\n");
	regno = (prot->cmd.write_reg.regno) & 0xffffff;
	ret = dbg_write_reg(regno, (reinterpret_cast<unsigned char*>(&prot->cmd.write_reg.value_h)));
	update_fetch_pc();

	if (ret != -1) {
		ret = write(gdb_iss_fifo_wr_fd, ISS_RESPONSE_OK, 1);
	} else {
		ret = write(gdb_iss_fifo_wr_fd, ISS_RESPONSE_FAIL, 1);	
		return -1;
	}

	if (ret == -1)
		return -1;

	return 0;
}

int pac_dsp::pac_dsp_read_reg_cmd(struct iss_shm_prot *prot)
{
	int ret, regno;

	dprintf("PAC_DSP_READ_REG_CMD\r\n");
	regno = (prot->cmd.read_reg.regno) & 0xffffff;
	ret = dbg_read_reg(regno, (reinterpret_cast<unsigned char*>(&prot->cmd.read_reg.value_l)));

	if (ret != -1) {
		ret = write(gdb_iss_fifo_wr_fd, ISS_RESPONSE_OK, 1);
	} else {
		ret = write(gdb_iss_fifo_wr_fd, ISS_RESPONSE_FAIL, 1);
		return -1;
	}

	if (ret == -1)
		return -1;

	return 0;
}

int pac_dsp::pac_dsp_read_all_reg_cmd(struct iss_shm_prot *prot)
{
	int ret;

	dprintf("PAC_DSP_READ_ALL_REG_CMD\r\n");
	ret =  dbg_read_all_reg((struct reg_file *)prot->buf);
	if (ret != -1) {
		ret = write(gdb_iss_fifo_wr_fd, ISS_RESPONSE_OK, 1);
	} else {
		ret = write(gdb_iss_fifo_wr_fd, ISS_RESPONSE_FAIL, 1);
		return -1;
	}

	if (ret == -1)
		return -1;

	return 0;
}

int pac_dsp::pac_dsp_reset_cmd(struct iss_shm_prot *prot)
{
	int ret;

	dprintf("PAC_DSP_RESET_CMD\r\n");
	be_stoped = 0;
	active_core_stop = 0;
	step_num = -1;
	eStopFlag = STOP_TRAP;
	ro_regs.sim_end = 0;
	pre_breakpc = 0xffffffff;
	sc_pac_memif_ptr_0->dcache_flush(0x0, 0x0, 0x0); //flush d1 d2 cache
	sc_pac_if_ptr->icache_write(0x0, 0x0, 0);	//fluash l1 l2 cache
	sc_pac_memif_ptr_0->l2_icache_write(0x0, 0x0, 0x0);
	dbg_soc_reset();

	ret = write(gdb_iss_fifo_wr_fd, ISS_RESPONSE_OK, 1);

	if (ret == -1)
		return -1;

	return 0;
}

int pac_dsp::pac_dsp_stop_cmd(struct iss_shm_prot *prot)
{
	int ret;

	dprintf("PAC_DSP_STOP_CMD\r\n");
	prot->flag = ISS_STOP;
	eStopFlag = STOP_INT;

	ret = write(gdb_iss_fifo_wr_fd, ISS_RESPONSE_OK, 1);

	if (ret == -1)
		return -1;

	return 0;
}

int pac_dsp::pac_dsp_get_stop_reason(struct iss_shm_prot *prot1)
{
	int ret;
	volatile struct iss_shm_prot *prot = prot1;

	dprintf("PAC_DSP_GET_STOP_REASON\r\n");
	prot->cmd.reason.active_core = active_core_stop;
	prot->cmd.reason.reason= eStopFlag;
	prot->cmd.reason.result = ro_regs.RF[4][4];	//cluster 1 D4 change return register D5 or D4

	ret = write(gdb_iss_fifo_wr_fd, ISS_RESPONSE_OK, 1);
	if (ret == -1)
		return -1;

	return 0;
}

// return 1 for continue
int pac_dsp::pac_dsp_run_cmd(struct iss_shm_prot *prot)
{
	int ret;

	dprintf("PAC_DSP_RUN_CMD\r\n");
	if (eStopFlag == STOP_EXIT) {
		printf("have be Trap %d\r\n", core_id);
		active_core_stop = 1;
		be_stoped = 0;
		ret = write(gdb_iss_fifo_wr_fd, ISS_RESPONSE_OK, 1);
		ret = write(gdb_iss_fifo_wr_fd, ISS_RESPONSE_OK, 1);
		if (ret == -1)
				return -1;

		return 0;
	}

	active_core_stop = 0;
	step_num = -1;
	be_stoped = 0;
	eStopFlag = STOP_TRAP;

	ret = write(gdb_iss_fifo_wr_fd, ISS_RESPONSE_OK, 1);
	if (ret == -1)
		return -1;

	return 1;
}

// return 1 for continue
int pac_dsp::pac_dsp_step(int n)
{
	dprintf("PAC_DSP_STEP\r\n");
	step_num = n;
	active_core_stop = 0;
	be_stoped = 0;
	eStopFlag = STOP_TRAP;

	return 1;
}	

int pac_dsp::pac_dsp_insert_wbp_cmd(struct iss_shm_prot *prot)
{
	int ret, type;

	dprintf("PAC_DSP_INSERT_WBP_CMD\r\n");

	type = prot->cmd.insert_wp.type & 0xffffff;
	ret = dbg_insert_wbp(prot->cmd.insert_wp.addr, prot->cmd.insert_wp.len, type);

	if (ret != -1) {
		ret = write(gdb_iss_fifo_wr_fd, ISS_RESPONSE_OK, 1);
	} else {
		ret = write(gdb_iss_fifo_wr_fd, &ISS_RESPONSE_FAIL, 1);
		return -1;
	}

	if (ret == -1)
		return -1;

	return 0;	
}

int pac_dsp::pac_dsp_remove_wbp_cmd(struct iss_shm_prot *prot)
{
	int ret, type;

	dprintf("PAC_DSP_REMOVE_WBP_CMD\r\n");
	type = prot->cmd.insert_wp.type & 0xffffff;

	ret = dbg_remove_wbp(prot->cmd.insert_wp.addr, prot->cmd.remove_wp.len, type);

	if (ret != -1) {
		ret = write(gdb_iss_fifo_wr_fd, ISS_RESPONSE_OK, 1);
	} else {
		ret = write(gdb_iss_fifo_wr_fd, ISS_RESPONSE_FAIL, 1);
		return -1;
	}

	if (ret == -1)
		return -1;

	return 0;
}

int pac_dsp::pac_dsp_insert_bp_cmd(struct iss_shm_prot *prot)
{
	int ret;

	dprintf("PAC_DSP_INSERT_BP_CMD\r\n");

	ret = dbg_insert_bp(prot->cmd.insert_bp.addr);

	if (ret != -1) {
		ret = write(gdb_iss_fifo_wr_fd, ISS_RESPONSE_OK, 1);
	} else {
		ret = write(gdb_iss_fifo_wr_fd, ISS_RESPONSE_FAIL, 1);
		return -1;
	}

	if (ret == -1)
		return -1;

	return 0;
}

int pac_dsp::pac_dsp_remove_bp_cmd(struct iss_shm_prot *prot)
{
	int ret;

	dprintf("PAC_DSP_REMOVE_BP_CMD\r\n");

	ret = dbg_remove_bp(prot->cmd.remove_bp.addr);

	if (ret != -1) {
		ret = write(gdb_iss_fifo_wr_fd, ISS_RESPONSE_OK, 1);
	} else {
		ret = write(gdb_iss_fifo_wr_fd, ISS_RESPONSE_FAIL, 1);
		return -1;
	}

	if (ret == -1)
		return -1;

	return 0;
}

int pac_dsp::pac_dsp_set_pc_addr(struct iss_shm_prot *prot)
{
	int ret;
	long long reg_reset_value = 0;
	long long sr0 = 1;

	dprintf("PAC_DSP_SET_PC_ADDR\r\n");

	for (int j = 0; j < 122; j++) {
		if (j == 107)
			dbg_write_reg(j, reinterpret_cast<unsigned char*>(&sr0));
		else
			dbg_write_reg(j, reinterpret_cast<unsigned char*>(&reg_reset_value));
	}

	fetch_pc = prot->cmd.set_pc.addr;
	dbg_write_reg(116, (reinterpret_cast<unsigned char*>(&prot->cmd.set_pc.addr)));
	update_fetch_pc();

	ret = write(gdb_iss_fifo_wr_fd, ISS_RESPONSE_OK, 1);
	if (ret == -1)
		return -1;

	return 0;
}

int pac_dsp::pac_dsp_stop_other_core(struct iss_shm_prot *prot)
{
	int ret;
	dprintf("PAC_DSP_STOP_OTHER_CORE\r\n");
	be_stoped = 1;
	active_core_stop = 0;
	
	ret = write(gdb_iss_fifo_wr_fd, ISS_RESPONSE_OK, 1);
	if (ret == -1)
		return -1;

	return 1;

}

int pac_dsp::pac_dsp_get_profiling_cont_data(struct iss_shm_prot *prot)
{
	return 0;
}

int pac_dsp::pac_dsp_get_profiling_dma_data(struct iss_shm_prot *prot)
{
	return 0;
}

int pac_dsp::pac_dsp_set_profiling_data(struct iss_shm_prot *prot)
{
	int ret;
	struct profiling_queue *queue;
	unsigned int start_pc, end_pc;
	long long date;
	
	start_pc = prot->cmd.set_profiling_data.start_pc;
	end_pc = prot->cmd.set_profiling_data.end_pc;
	date = prot->cmd.set_profiling_data.date;

	//sprintf(filename, "%s/%lld", getenv("HOME"), date);
	//sprintf(dirname, "%lld",  date);
#if 0
	queue = queue_init(start_pc, end_pc);
#else
	queue = queue_file_init(date, start_pc, end_pc);
#endif

	queue_list_add_tail(queue);

	ret = write(gdb_iss_fifo_wr_fd, ISS_RESPONSE_OK, 1);
	if (ret == -1)
		return -1;

	return 0;
}

int pac_dsp::pac_dsp_get_profiling_data(struct iss_shm_prot *prot)
{
	return 0;
}

int pac_dsp::pac_dsp_get_profiling_head(struct iss_shm_prot *prot)
{
	return 0;
}

// return 1 for continue, 0 process cmd, -1 fail
int pac_dsp::pac_iss_process_gdb_cmd(char c)
{
	int ret = -1;

	switch (c) {
	case GDB_ICE_GET_ID:
		ret = pac_dsp_get_id(iss_shm_base_ptr);
		break;
	case GDB_ICE_INIT:
		ret = pac_dsp_init_cmd(iss_shm_base_ptr);
		break;
	case GDB_ICE_EXIT:
		ret = pac_dsp_exit_cmd(iss_shm_base_ptr);
		break;
	case GDB_ICE_WRITE_MEM:
		ret = pac_dsp_write_mem_cmd(iss_shm_base_ptr);
		break;
	case GDB_ICE_READ_MEM:
		ret = pac_dsp_read_mem_cmd(iss_shm_base_ptr);
		break;
	case GDB_ICE_WRITE_DATA_REG:
		ret = pac_dsp_write_reg_cmd(iss_shm_base_ptr);
		break;
	case GDB_ICE_READ_DATA_REG:
		ret = pac_dsp_read_reg_cmd(iss_shm_base_ptr);
		break;
	case GDB_ICE_READ_ALL_DATA_REG:
		ret = pac_dsp_read_all_reg_cmd(iss_shm_base_ptr);
		break;
	case GDB_ICE_RESET:
		ret = pac_dsp_reset_cmd(iss_shm_base_ptr);
		break;
	case GDB_ICE_RUN:
		ret = pac_dsp_run_cmd(iss_shm_base_ptr);
		break;
	case GDB_ICE_STEP:
		ret = pac_dsp_step(1);
		break;
	case GDB_ICE_STOP:
		ret = pac_dsp_stop_cmd(iss_shm_base_ptr);
		break;
	case GDB_ICE_STOP_REASON:
		ret = pac_dsp_get_stop_reason(iss_shm_base_ptr);
		break;
	case GDB_ICE_INSERT_BP:
		ret = pac_dsp_insert_bp_cmd(iss_shm_base_ptr);
		break;
	case GDB_ICE_REMOVE_BP:
		ret = pac_dsp_remove_bp_cmd(iss_shm_base_ptr);
		break;
	case GDB_ICE_INSERT_HARD_BP:
		break;
	case GDB_ICE_REMOVE_HARD_BP:
		break;
	case GDB_ICE_INSERT_WP:
		ret = pac_dsp_insert_wbp_cmd(iss_shm_base_ptr);
		break;
	case GDB_ICE_REMOVE_WP:
		ret = pac_dsp_remove_wbp_cmd(iss_shm_base_ptr);
		break;
	case GDB_ICE_DUMP_ICE_REGS:
		break;
	case GDB_ICE_KILL:
		break;
	case GDB_ICE_DUMP_DATA_REGS:
		break;
	case GDB_ICE_SET_PC_ADDR:
		ret = pac_dsp_set_pc_addr(iss_shm_base_ptr);
		break;
	case GDB_ICE_STOP_OTHER_CORE:
		ret = pac_dsp_stop_other_core(iss_shm_base_ptr);
		break;
	case GDB_ICE_SET_PROFILING_DATA:
		ret = pac_dsp_set_profiling_data(iss_shm_base_ptr);
		break;
	case GDB_ICE_GET_PROFILING_DATA:
		ret = pac_dsp_get_profiling_data(iss_shm_base_ptr);
		break;
	case GDB_ICE_GET_PROFILING_HEAD:
		ret = pac_dsp_get_profiling_head(iss_shm_base_ptr);
		break;
	case GDB_ICE_GET_PROFILING_DMA_DATA:
		ret = pac_dsp_get_profiling_dma_data(iss_shm_base_ptr);
		break;
	case GDB_ICE_GET_PROFILING_CONTENTION_DATA:
		ret = pac_dsp_get_profiling_cont_data(iss_shm_base_ptr);
		break;
	default:
		dprintf("GET INVALID CMD !! \r\n");
		write(gdb_iss_fifo_wr_fd, ISS_RESPONSE_FAIL, 1);
		break;
	}
	return ret;
}

void pac_dsp::pac_iss_wait()
{
	unsigned char buf[16];
	int len, ret = 0;

	if (IS_ISS_RUN)
		return;

	while (1) {
		len = read(gdb_iss_fifo_rd_fd, buf, 1);

		if (len > 0) {
			ret = pac_iss_process_gdb_cmd(*buf);
		}

		if (ret == -1) {
			printf("pac_iss_wait read fifo fail.\r\n");
			exit(1);
		}
		if (ret == 1)	// run or step
			break;
	}

	SET_ISS_RUN;
}

int pac_dsp::dbg_read_reg(int regno, unsigned char *buf)
{
	return soc_read_reg(regno, buf);
}

int pac_dsp::dbg_write_reg(int regno, unsigned char *buf)
{
	return soc_write_reg(regno, buf);
}

int pac_dsp::dbg_read_all_reg(struct reg_file *buf)
{
	return soc_read_all_reg((unsigned char *) buf);
}

int pac_dsp::dbg_insert_wbp(unsigned int addr, int len, int type)
{
	return insert_wbp(addr, len, type);
}

int pac_dsp::dbg_remove_wbp(unsigned int addr, int len, int type)
{
	return del_wbp(addr, len, type);
}

int pac_dsp::dbg_insert_bp(unsigned int pc)
{
	return insert_bp(pc);
}

int pac_dsp::dbg_remove_bp(unsigned int pc)
{
	return del_bp(pc);
}

int pac_dsp::dbg_reset(void)
{
	sc_pac_memif_ptr_0->memif_reset();
	return pac_soc_reset();
}

int pac_dsp::dbg_soc_reset(void)
{
	return pac_soc_reset();
}

static Pac_Stack bp_stack;
static Sbbp *header;
static Watch_Point *wheader;

int pac_dsp::break_init()
{
	header = NULL;
	wheader = NULL;
	pac_stack_init(&bp_stack, 1024);
	return 0;
}

int pac_dsp::break_uninit()
{
	pac_stack_uninit(&bp_stack);
	return 0;
}

int pac_dsp::get_max_wbp()
{
	return MAX_WATCH_POINT;
}

int pac_dsp::is_wbp_hit(unsigned int addr, int len, int type)
{
	Watch_Point *tmp = wheader;

	while (tmp) {
		if (tmp->addr == addr && tmp->type == type && tmp->len == len)
			return 1;
		tmp = tmp->next;
	}
	return 0;
}

int pac_dsp::insert_wbp(unsigned int addr, int len, int type)
{
	Watch_Point *tmp;

	if (is_wbp_hit(addr, len, type))
		return 0;
	tmp = (Watch_Point *) pac_stack_malloc(&bp_stack, sizeof(Watch_Point), 1);
	if (tmp == NULL)
		return -1;
	tmp->addr = addr;
	tmp->len = len;
	tmp->type = type;
	tmp->next = wheader;
	wheader = tmp;
	return 0;
}

int pac_dsp::del_wbp(unsigned int addr, int len, int type)
{
	Watch_Point **pp = &wheader;
	Watch_Point *tmp = wheader;

	while (tmp) {
		if (tmp->addr == addr && tmp->type == type && tmp->len == len) {
			*pp = tmp->next;
			break;
		}
		pp = &tmp->next;
		tmp = tmp->next;
	}
	return 0;
}

int pac_dsp::is_bp_hit(unsigned int pc)
{
	Sbbp *tmp = header;

	while (tmp) {
		if (tmp->pc == pc)
			return 1;
		tmp = tmp->next;
	}
	return 0;
}

int pac_dsp::insert_bp(unsigned int pc)
{
	Sbbp *tmp;

	if (is_bp_hit(pc))
		return 0;
	tmp = (Sbbp *) pac_stack_malloc(&bp_stack, sizeof(Sbbp), 1);
	if (tmp == NULL)
		return -1;
	tmp->pc = pc;
	tmp->next = header;
	header = tmp;
	return 0;
}

int pac_dsp::del_bp(unsigned int pc)
{
	Sbbp **pp = &header;
	Sbbp *tmp = header;

	while (tmp) {
		if (tmp->pc == pc) {
			*pp = tmp->next;
			break;
		}
		pp = &tmp->next;
		tmp = tmp->next;
	}
	return 0;
}

#define DEFAULT_STACK_SIZE 0x100000

int pac_dsp::pac_stack_init(Pac_Stack * stack, int size)
{
	if (size == 0)
		size = DEFAULT_STACK_SIZE;
	stack->header = (Pac_Chunk *) malloc(size);
	if (stack->header == NULL)
		return -1;
	memset(stack->header, 0, size);
	stack->header->pprev = NULL;
	stack->size = size;
	stack->limit = (&stack->header->mem[0]) + size;
	stack->next_free = &stack->header->mem[0];
	return 0;
}

int pac_dsp::pac_stack_grow(Pac_Stack * stack, int size)
{
	Pac_Chunk *temp;

	if (stack->size < size)
		stack->size = size;
	temp = (Pac_Chunk *) malloc(stack->size);
	if (temp == NULL)
		return -1;
	temp->pprev = stack->header;
	stack->header = temp;
	stack->limit = (char *) (&temp->mem[0]) + stack->size;
	stack->next_free = &stack->header->mem[0];
	return 0;
}

void *pac_dsp::pac_stack_malloc(Pac_Stack * stack, int size, int isgrow)
{
	void *tmp;

	if ((stack->next_free + size) >= stack->limit) {
		if (!(isgrow && (pac_stack_grow(stack, size) == 0)))
			return 0;
	}
	tmp = (void *) stack->next_free;
	stack->next_free += size;
	return tmp;
}

int pac_dsp::pac_stack_uninit(Pac_Stack * stack)
{
	Pac_Chunk *temp;

	temp = stack->header;
	while (temp) {
		stack->header = temp->pprev;
		free((void *) temp);
		temp = stack->header;
	}
	return 0;
}

