#include "mpac-mproc-define.h"
#include "pac-socshm-prot.h"
#include "pac-soc.h"
#include "pac-parser.h"
#include "pac-core-bus.h"
#include "pac-socshm-prot.h"

#include "stdio.h"
#include "pac-profiling.h"

//#define DEBUG 1
#undef DEBUG
#ifdef DEBUG
#define dprintf(x...) printf(x)
#else
#define dprintf(x...) 
#endif

struct soc_shm_prot *soc_shm_base_ptr;
struct core_profiling_control pcore[DSPNUM];
int fifo_iss_fd[DSPNUM];

void Core_Bus::icache_read(unsigned int addr, unsigned char *buf, int len)
{
	l2_cache_read(addr, buf, len);
}

void Core_Bus::icache_write(unsigned int addr, unsigned char *buf, int len)
{
	l2_cache_write(addr, buf, len);
}

void Core_Bus::dmem_read(unsigned int addr, unsigned char *buf, int len, unsigned int inst_mode)
{
	int miss = 0;

#if 1
	if (((addr >= m1_bus_base_array[core_id]) && ((addr + len) < (m1_bus_base_array[core_id] + m1_bus_size_array[core_id])))
					|| ((addr >= c2cc_base) && (addr < c2cc_base + c2cc_size))) {
	} else if ((addr >= m2_bus_base) && ((addr + len) < (m2_bus_base + m2_bus_size))){

	} else if (((addr >= biu_bus_base) && ((addr + len) < (biu_bus_base + biu_bus_size)))
					|| ((addr >= sysdma_base) && ((addr + len) < (sysdma_base + sysdma_size)))){
	} else {
			for (i = 0; i < DSPNUM; i++) {
				if ((addr >= m1_bus_base_array[i]) && ((addr + len) < (m1_bus_base_array[i] + m1_bus_size_array[i]))) {
					dmu_flag |= 1 << i;
					break;
				}
			}
			if (i == DSPNUM) {
				printf("No read mem address(0x%08x) in simualtor\r\n",addr);
				debug_inst |= 1 << core_id;
			}
	}

#endif

	miss = d1_dcache_read(addr, buf, len, inst_mode);
	if(miss == CACHE_MISS) {
		d2_dcache_read(addr, buf, len, inst_mode);
	}
}


void Core_Bus::dmem_write(unsigned int addr, unsigned char *buf, int len, unsigned int inst_mode)
{
	int miss = 0;
	if (addr == 0x00000000)
		printf("Bingo\r\n");
#if 1
	if (((addr >= m1_bus_base_array[core_id]) && ((addr + len) < (m1_bus_base_array[core_id] + m1_bus_size_array[core_id])))
					|| ((addr >= c2cc_base) && (addr < c2cc_base + c2cc_size))) {
	} else if ((addr >= m2_bus_base) && ((addr + len) < (m2_bus_base + m2_bus_size))){

	} else if (((addr >= biu_bus_base) && ((addr + len) < (biu_bus_base + biu_bus_size)))
					|| ((addr >= sysdma_base) && ((addr + len) < (sysdma_base + sysdma_size)))){
	} else {
			for (i = 0; i < DSPNUM; i++) {
				if ((addr >= m1_bus_base_array[i]) && ((addr + len) < (m1_bus_base_array[i] + m1_bus_size_array[i]))) {
					dmu_flag |= 1 << i;
					break;
				}
			}
			if (i == DSPNUM) {
				printf("No read mem address(0x%08x) in simualtor\r\n",addr);
				debug_inst |= 1 << core_id;
			}
	}

#endif

	miss = d1_dcache_write(addr, buf, len, inst_mode);
	if(miss == CACHE_MISS) {
		d2_dcache_write(addr, buf, len, inst_mode);
	}
}

void Core_Bus::soc_mem_profiling(unsigned int addr, unsigned int len, int core_id, int cmd)
{
	int i;
	unsigned int core_base[DSPNUM], core_size[DSPNUM];
	unsigned int m2_base, m2_size;
	unsigned int ddr_base, ddr_size;
	unsigned int sysdma_base, sysdma_size;

	for (i = 0; i < DSPNUM; i++) {
		core_base[i] = multi_arg(pacdsp[i], core_base);
		core_size[i] = multi_arg(pacdsp[i].m1_mem, dmem_m1_size) + multi_arg(pacdsp[i].res1, res1_size) + 
			multi_arg(pacdsp[i].biu, biu_size + multi_arg(pacdsp[i].icu, icu_size) + 
				multi_arg(pacdsp[i].dmu, dmu_size) + multi_arg(pacdsp[i].dma, dma_size) +
			 		multi_arg(pacdsp[i].res2, res2_size));
	}
	
	m2_base = multi_arg(m2_mem, dmem_m2_base);
	m2_size = multi_arg(m2_mem, dmem_m2_size) +  multi_arg(l2_icu, l2_icu_size) + 
			multi_arg(m2_dmu, m2_dmu_size) + multi_arg(m2_dma, m2_dma_size) + 
				multi_arg(sem, sem_size) + multi_arg(c2cc, c2cc_size);
	
	ddr_base = multi_arg(ddr_mem, ddr_memory_base);
	ddr_size = multi_arg(ddr_mem, ddr_memory_size);

	sysdma_base = multi_arg(sys_dma, sys_dma_base);
	sysdma_size = multi_arg(sys_dma, sys_dma_size);

	if (cmd == tlm::TLM_READ_COMMAND) {		//READ MEM
		for(i = 0; i < DSPNUM; i++) {
			if ((addr >= core_base[i]) && ((addr + len) < (core_base[i] + core_size[i]))) {
				pcore[core_id].core_data.m1_pdata[i].rd_count++;
				break;
			}
		}

		if ((addr >= m2_base) && ((addr + len) < (m2_base + m2_size))) {
			pcore[core_id].core_data.m2_pdata.rd_count++;
		} else if ((addr >= ddr_base) && ((addr + len) < (ddr_base + ddr_size))) {
			pcore[core_id].core_data.ddr_pdata.rd_count++;
		} else if ((addr >= sysdma_base) && ((addr + len) < (sysdma_base + sysdma_size))) {
			pcore[core_id].core_data.ddr_pdata.rd_count++;
		}
	} else {
		for(i = 0; i < DSPNUM; i++) {
			if ((addr >= core_base[i]) && ((addr + len) < (core_base[i] + core_size[i]))) {
				pcore[core_id].core_data.m1_pdata[i].wr_count++;
				break;
			}
		}

		if ((addr >= m2_base) && ((addr + len) < (m2_base + m2_size))) {
			pcore[core_id].core_data.m2_pdata.wr_count++;
		} else if ((addr >= ddr_base) && ((addr + len) < (ddr_base + ddr_size))) {
			pcore[core_id].core_data.ddr_pdata.wr_count++;
		} else if ((addr >= sysdma_base) && ((addr + len) < (sysdma_base + sysdma_size))) {
			pcore[core_id].core_data.ddr_pdata.wr_count++;
		}
	}
}

void Core_Bus::soc_profiling(unsigned int addr, unsigned int len, int core_id, int cmd)
{
	switch (cmd) {
	case DMEM_READ:
		soc_mem_profiling(addr, len, core_id, tlm::TLM_READ_COMMAND);
		break;
	case DMEM_WRITE:
		soc_mem_profiling(addr, len, core_id, tlm::TLM_WRITE_COMMAND);
		break;
	case ICACHE_READ:
		pcore[core_id].core_data.l1_pdata.cache_miss++;
		break;
	default:
		printf("invalid profiling cmd\r\n");
		break;
	}
}

sc_core::sc_event soc_core_req_event[DSPNUM]; // 4 core request event
sc_core::sc_event soc_core_resp_event[DSPNUM]; // core finish response event
int soc_core_req_bit_mask[DSPNUM]; //m1 m2 ddr finish bit mask

void Core_Bus::pac_soc_run()
{
	unsigned int inst_mode = 0;
	volatile struct soc_shm_prot *core_ptr = soc_shm_base_ptr + (core_id * MAX_SOC_SHM_INST);
	volatile struct soc_shm_prot *inst_ptr;
	int d2_wait[DSPNUM];

	while (1) {
		wait();

		if (core_ptr->ls_flag != 0x4)
			continue;

		debug_inst = 1;
		dprintf("core%d%s start \r\n",core_id, __func__);
		soc_core_req_bit_mask[core_id] = 0x10000000; //soc_core_req_bit_mask 31bit = 1, mean iss have request

		for (inst_mode = 0; inst_mode < MAX_SOC_SHM_INST; inst_mode++) {
			inst_ptr = core_ptr + inst_mode;
			
			if (inst_ptr->flag != REQUEST)
				continue;

			switch (inst_ptr->cmd) {

			case DBG_START_PROFILING:
				dprintf("core%d start profiling\r\n", core_id);
				memset(&(pcore[core_id].core_data), 0, sizeof(struct core_profiling_data));
				pcore[core_id].flag = 1;
				break;
			case DBG_STOP_PROFILING:
				dprintf("core%d stop profiling\r\n", core_id);
				compute_cycle(core_id);
				memcpy((unsigned char *)inst_ptr->buf, &(pcore[core_id].core_data), sizeof(struct core_profiling_data));
				clear_self_soc_profile_table(core_id);
				pcore[core_id].flag = 0;
				break;
			case DBG_GET_DMA_PROFILING_DATA:
				break;
			case DBG_GET_CONTENTION_PROFILING_DATA:
				break;
			case DMEM_READ:
				dprintf("core%d dmem_read addr = 0x%08x, len = 0x%08x\r\n",core_id, (unsigned int)inst_ptr->addr, (int)inst_ptr->len);
				if (pcore[core_id].flag) {
					soc_profiling((unsigned int)inst_ptr->addr, (unsigned int)inst_ptr->len, core_id, DMEM_READ);
				}

				debug_inst = 0;
				dmem_read((unsigned int)inst_ptr->addr, (unsigned char *)inst_ptr->buf, (int)inst_ptr->len, inst_mode);
				break;
			case DMEM_WRITE:
				dprintf("core%d dmem_write addr = 0x%08x, len = 0x%08x\r\n",core_id, (unsigned int)inst_ptr->addr, (int)inst_ptr->len);
				if (pcore[core_id].flag) {
					soc_profiling((unsigned int)inst_ptr->addr, (unsigned int)inst_ptr->len, core_id, DMEM_WRITE);
				}

				debug_inst = 0;
				dmem_write((unsigned int)inst_ptr->addr, (unsigned char *)inst_ptr->buf, (int)inst_ptr->len, inst_mode);
				break;
			case ICACHE_READ:
				dprintf("core%d icache_read addr = 0x%08x, len = 0x%08x\r\n",core_id, (unsigned int)inst_ptr->addr, (int)inst_ptr->len);
				if (pcore[core_id].flag) {
					soc_profiling((unsigned int)inst_ptr->addr, (unsigned int)inst_ptr->len, core_id, ICACHE_READ);
				}

				debug_inst = 0;
				d2_wait[core_id] = 0;
				profile_soc_table.profile_core_table[core_id].generic_delay =
						profile_soc_table.profile_core_table[core_id].generic_delay > l1_rd_delay ? 
						profile_soc_table.profile_core_table[core_id].generic_delay: l1_rd_delay; 

				icache_read((unsigned int)inst_ptr->addr, (unsigned char *)inst_ptr->buf, (int)inst_ptr->len);
				break;
			case ICACHE_WRITE:
				dprintf("core%d icache_write addr = 0x%08x, len = 0x%08x\r\n",core_id, (unsigned int)inst_ptr->addr, (int)inst_ptr->len);
				icache_write((unsigned int)inst_ptr->addr, (unsigned char *)inst_ptr->buf, (int)inst_ptr->len);
				break;
			case DCACHE_FLUSH:
				dprintf("core%d dcache_flush\r\n",core_id);
				dcache_flush();
				break;
			case DBG_DMEM_READ:
				dprintf("core%d dbg_dmem_read addr = 0x%08x, len = 0x%08x\r\n",core_id, (unsigned int)inst_ptr->addr, (int)inst_ptr->len);
				dbg_dmem_read((unsigned int)inst_ptr->addr, (unsigned char *)inst_ptr->buf, (int)inst_ptr->len);
				break;
			case DBG_DMEM_WRITE:
				dprintf("core%d dbg_dmem_write addr = 0x%08x, len = 0x%08x\r\n",core_id, (unsigned int)inst_ptr->addr, (int)inst_ptr->len);
				dbg_dmem_write((unsigned int)inst_ptr->addr, (unsigned char *)inst_ptr->buf, (int)inst_ptr->len);
				break;
			case DBG_RESET:
				dprintf("core%d dbg_dmem_reset\r\n", core_id);
				dbg_dmem_reset();
				break;
			default:
				printf("core%d soc get invalid cmd.\r\n", core_id);
				inst_ptr->flag = 0;
				continue;
			}

#ifdef PAC_SOC_PROFILE
			inst_ptr->flag = RESPONSE;
#endif
		}
#ifdef PAC_SOC_PROFILE

		if (debug_inst == 0) {
			wait(sc_core::SC_ZERO_TIME);
			wait(sc_core::SC_ZERO_TIME);
			wait(sc_core::SC_ZERO_TIME);
			wait(sc_core::SC_ZERO_TIME);

			if (dmu_flag & (1 << CORE0_ID)) {
				soc_core_req_event[CORE0_ID].notify();
			}


			if (dmu_flag & (1 << CORE1_ID)) {
				soc_core_req_event[CORE1_ID].notify();
			}
			
			if (dmu_flag & (1 << CORE2_ID)) {
				soc_core_req_event[CORE2_ID].notify();
			}

			if (dmu_flag & (1 << CORE3_ID)) {
				soc_core_req_event[CORE3_ID].notify();
			}

			soc_core_req_event[core_id].notify();
			wait(soc_core_resp_event[core_id]);
			wait(sc_core::SC_ZERO_TIME);
		}

		soc_core_req_bit_mask[core_id] = 0;
		dmu_flag = 0;
		core_ptr->ls_flag = 0;		
		core_ptr->flag = RESPONSE;
		if (pcore[core_id].flag == 0 ) {
			clear_self_soc_profile_table(core_id);
		}
		dprintf("core%d%s finish\r\n",core_id,  __func__);

#else
		soc_core_req_bit_mask[0] = 0;
		core_ptr->ls_flag = 0;		

		core_ptr->flag = RESPONSE;
		//dprintf("%s finish\r\n", __func__);
#endif


	}

	sc_stop();
}
