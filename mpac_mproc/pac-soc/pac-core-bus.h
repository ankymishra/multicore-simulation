#ifndef PAC_CORE_BUS_H_INCLUDED
#define PAC_CORE_BUS_H_INCLUDED

#include <systemc.h>
using namespace sc_core;
using namespace sc_dt;
using namespace std;

#include "tlm.h"
#include "tlm_utils/simple_target_socket.h"
#include "tlm_utils/simple_initiator_socket.h"
#include "tlm_utils/peq_with_get.h"

#include "sys/types.h"
#include "sys/stat.h"
#include "fcntl.h"

#include "pac-trans-extension.h"

#include "pac-bus.h"
#include "pac-profiling.h"

#define DBG_CORE_M1_MEM 0
#define DBG_CORE_BIU 1
#define DBG_CORE_ICU 2
#define DBG_CORE_DMU 3
#define DBG_CORE_DMA 4
#define DBG_M2_MEM 5
#define DBG_M2_ICU 6
#define DBG_M2_DMU 7
#define DBG_M2_DMA 8
#define DBG_C2CC_INTERFACE 9
#define DBG_DDR_MEM 10
#define DBG_SYS_DMA 11

extern int fifo_iss_fd[DSPNUM];
extern int soc_core_req_bit_mask[DSPNUM];
extern struct core_profiling_control pcore[DSPNUM];

struct Core_Bus:public sc_core::sc_module, public pac_bus
{
	private:
		int dmu_flag;
		int debug_inst;
		unsigned int m1_bus_base_array[DSPNUM], m1_bus_size_array[DSPNUM];
		unsigned int m2_bus_base, m2_bus_size;
		unsigned int biu_bus_base, biu_bus_size;
		unsigned int sysdma_base, sysdma_size;
		unsigned int c2cc_base, c2cc_size;

		unsigned int core_id;
		unsigned int l1_rd_delay, l2_rd_delay;
		unsigned int m1_rd_delay, m1_wr_delay;
		unsigned int m2_rd_delay, m2_wr_delay;
		unsigned int ddr_rd_delay, ddr_wr_delay;
		struct sim_arg *multi_sim_arg;
		unsigned int i;
		int fifo_fd;
		tlm::tlm_generic_payload trans[4]; 	//sc c1 c2 if
		trans_extension trans_extension_ptr[4];

	public:
		sc_in < bool > clk;
		tlm_utils::simple_initiator_socket < Core_Bus > l2_bus_init_socket;
		tlm_utils::simple_initiator_socket < Core_Bus > d2_bus_init_socket;

		tlm_utils::simple_target_socket < Core_Bus > d1_dcache_targ_socket;		//connect to dma (cache flush)

		tlm_utils::peq_with_get < tlm::tlm_generic_payload > l2_bus_ResponsePEQ;
		tlm_utils::peq_with_get < tlm::tlm_generic_payload > d2_bus_ResponsePEQ;

		SC_HAS_PROCESS(Core_Bus);	
		
	public:
		Core_Bus(sc_module_name _name, unsigned int id, struct sim_arg *arg)
		: sc_core::sc_module(_name)
		, core_id(id)
		, multi_sim_arg(arg)
		, l2_bus_init_socket("l2_bus_init_socket")
		, d2_bus_init_socket("d2_bus_init_socket")
		, l2_bus_ResponsePEQ("l2_bus_ResponsePEQ")
		, d2_bus_ResponsePEQ("d2_bus_ResponsePEQ")
		{
			for (i = 0; i < DSPNUM; i++) {
				m1_bus_base_array[i] = multi_arg(pacdsp[i], core_base);
				m1_bus_size_array[i] = multi_arg(pacdsp[i].m1_mem, dmem_m1_size)
					+ multi_arg(pacdsp[i].res1, res1_size)
					+ multi_arg(pacdsp[i].biu, biu_size)
					+ multi_arg(pacdsp[i].icu, icu_size)
					+ multi_arg(pacdsp[i].dmu, dmu_size)
					+ multi_arg(pacdsp[i].dma, dma_size)
					+ multi_arg(pacdsp[i].res2, res2_size);

			}

			m2_bus_base = multi_arg(m2_mem, dmem_m2_base);
			m2_bus_size = multi_arg(m2_mem, dmem_m2_size)
					+ multi_arg(l2_icu, l2_icu_size)
					+ multi_arg(m2_dmu, m2_dmu_size)
					+ multi_arg(m2_dma, m2_dma_size)
					+ multi_arg(sem, sem_size)
					+ multi_arg(c2cc, c2cc_size);

			biu_bus_base = multi_arg(ddr_mem, ddr_memory_base);
			biu_bus_size = multi_arg(ddr_mem, ddr_memory_size);

			sysdma_base = multi_arg(sys_dma, sys_dma_base);
			sysdma_size = multi_arg(sys_dma, sys_dma_size);

			c2cc_base = multi_arg(c2cc, c2cc_base);
			c2cc_size = multi_arg(c2cc, c2cc_size);

			char buf[128];
			memset(buf, 0, 128);
			sprintf(buf, "%s%d", multi_arg(boot, soc_fifo_name), id);
			mkfifo(buf, 0666);
			fifo_fd = open(buf, O_RDWR);
			if (fifo_fd < 0) {
					perror("SOC open fifo fail");
					exit(-1);
			}

			fifo_iss_fd[id] = fifo_fd;

			l1_rd_delay = multi_arg(pacdsp[id].l1_cache, l1_rd_delay);
			l2_rd_delay = multi_arg(l2_cache, l2_rd_delay);
			
			m1_rd_delay = multi_arg(pacdsp[id].m1_mem, m1_rd_delay);
			m1_wr_delay = multi_arg(pacdsp[id].m1_mem, m1_wr_delay);

			m2_rd_delay = multi_arg(m2_mem, m2_rd_delay);
			m2_wr_delay = multi_arg(m2_mem, m2_wr_delay);

			ddr_rd_delay = multi_arg(ddr_mem, ddr_rd_delay);
			ddr_wr_delay = multi_arg(ddr_mem, ddr_wr_delay);

			l2_bus_init_socket.register_nb_transport_bw(this, &Core_Bus::nb_transport_bw);
			d2_bus_init_socket.register_nb_transport_bw(this, &Core_Bus::nb_transport_bw);
			
			d1_dcache_targ_socket.register_b_transport(this, &Core_Bus::b_transport);

			SC_THREAD(pac_soc_run);
			sensitive << clk.pos();
		}

		~Core_Bus()
		{}

	private:
		void pac_soc_run();
		void dmem_read(unsigned int addr, unsigned char *buf, int len, unsigned int inst_mode);
		void dmem_write(unsigned int addr, unsigned char *buf, int len, unsigned int inst_mode);
		void icache_read(unsigned int addr, unsigned char *buf, int len);
		void icache_write(unsigned int addr, unsigned char *buf, int len);
		void soc_mem_profiling(unsigned int addr, unsigned int len, int core_id, int cmd);
		void soc_profiling(unsigned int addr, unsigned int len, int core_id, int cmd);

	private:
		void compute_cycle(int core_id)
		{
			unsigned int i = 0;
			pcore[core_id].core_data.cycle = (int)(profile_soc_table.profile_core_table[core_id].generic_delay
							+ profile_soc_table.profile_core_table[core_id].inst_delay
							+ profile_soc_table.profile_core_table[core_id].core_delay);

			if (pcore[core_id].core_data.l1_pdata.cache_miss > 0)
					pcore[core_id].core_data.l1_pdata.cycle = l1_rd_delay;

			if (pcore[core_id].core_data.l2_pdata.cache_miss > 0)
					pcore[core_id].core_data.l2_pdata.cycle = l2_rd_delay;

			for (i = 0; i < DSPNUM; i++) {
				if ((pcore[core_id].core_data.m1_pdata[i].rd_count > 0) && (pcore[core_id].core_data.m1_pdata[i].wr_count > 0)) {
						pcore[core_id].core_data.m1_pdata[i].cycle = m1_rd_delay > m1_wr_delay ? m1_rd_delay : m1_wr_delay;
				} else if((pcore[core_id].core_data.m1_pdata[i].rd_count > 0) && (pcore[core_id].core_data.m1_pdata[i].wr_count== 0)) {
						pcore[core_id].core_data.m1_pdata[i].cycle = m1_rd_delay;
				} else if((pcore[core_id].core_data.m1_pdata[i].rd_count== 0) && (pcore[core_id].core_data.m1_pdata[i].wr_count > 0)) {
						pcore[core_id].core_data.m1_pdata[i].cycle = m1_wr_delay;
				}
			}

			if ((pcore[core_id].core_data.m2_pdata.rd_count > 0) && (pcore[core_id].core_data.m2_pdata.wr_count > 0)) {
					pcore[core_id].core_data.m2_pdata.cycle = m2_rd_delay > m2_wr_delay ? m2_rd_delay : m2_wr_delay;
			} else if ((pcore[core_id].core_data.m2_pdata.rd_count > 0) && (pcore[core_id].core_data.m2_pdata.wr_count == 0)) {
					pcore[core_id].core_data.m2_pdata.cycle = m2_rd_delay;
			} else if ((pcore[core_id].core_data.m2_pdata.rd_count == 0) && (pcore[core_id].core_data.m2_pdata.wr_count > 0)) {
					pcore[core_id].core_data.m2_pdata.cycle = m2_wr_delay;
			}

			if ((pcore[core_id].core_data.ddr_pdata.rd_count > 0) && (pcore[core_id].core_data.ddr_pdata.wr_count > 0)) {
					pcore[core_id].core_data.ddr_pdata.cycle = ddr_rd_delay > ddr_wr_delay ? ddr_rd_delay : ddr_wr_delay;
			} else if ((pcore[core_id].core_data.ddr_pdata.rd_count > 0) && (pcore[core_id].core_data.ddr_pdata.wr_count == 0)) {
					pcore[core_id].core_data.ddr_pdata.cycle = ddr_rd_delay;
			} else if ((pcore[core_id].core_data.ddr_pdata.rd_count == 0) && (pcore[core_id].core_data.ddr_pdata.wr_count > 0)) {
					pcore[core_id].core_data.ddr_pdata.cycle = ddr_wr_delay;
			}
		}
		
		void dcache_flush(void)
		{
#ifndef PAC_SOC_PROFILE
			tlm::tlm_generic_payload trans;
			sc_time delay = sc_core::SC_ZERO_TIME;
			trans_extension *trans_ext = new trans_extension;

			trans_ext->flag = ISS_DATA;
			trans.set_command(tlm::TLM_IGNORE_COMMAND);
			trans.set_extension(trans_ext);

			trans.set_response_status(tlm::TLM_INCOMPLETE_RESPONSE);
			d2_bus_init_socket->b_transport(trans, delay);
#endif
		}

		void dbg_dmem_read(unsigned int addr, unsigned char *buf, int len)
		{
			int miss = 0;
				
			miss = dbg_d1cache_read(addr, buf, len);
			if (miss == CACHE_MISS) {
				dbg_d2cache_read(addr, buf, len);
			}
		}

		void dbg_dmem_write(unsigned int addr, unsigned char *buf, int len)
		{
			int miss = 0;
		
			miss = dbg_d1cache_write(addr, buf, len);
			if (miss == CACHE_MISS) {
				dbg_d2cache_write(addr, buf, len);
			}
		}

		int dbg_dmem_reset()
		{
			unsigned int m1_mem_base, m2_mem_base;
			unsigned int biu_base, icu_base;
			unsigned int dmu_base, dma_base;
			unsigned int m2_dmu_base, m2_dma_base;
			unsigned int sys_dma_base;
			unsigned int c2cc_base, ddr_base;
			unsigned int m1_sgr_base, m1_dsr_base;
			unsigned int m2_sgr_base, m2_dsr_base;
			unsigned int m1_stat_base, m2_stat_base;

			unsigned int m1_mem_size, m2_mem_size;
			unsigned int biu_size, icu_size;
			unsigned int dmu_size, dma_size;
			unsigned int m2_dmu_size, m2_dma_size;
			unsigned int sys_dma_size;
			unsigned int c2cc_size, ddr_size;
		
			m1_mem_base = multi_arg(pacdsp[0], core_base);
			m2_mem_base = multi_arg(m2_mem, dmem_m2_base);
			biu_base = multi_arg(pacdsp[0], core_base) + multi_arg(pacdsp[0].biu, biu_offset);
			icu_base = multi_arg(pacdsp[0], core_base) + multi_arg(pacdsp[0].icu, icu_offset);
			dmu_base = multi_arg(pacdsp[0], core_base) + multi_arg(pacdsp[0].dmu, dmu_offset);
			dma_base = multi_arg(pacdsp[0], core_base) + multi_arg(pacdsp[0].dma, dma_offset);
			m2_dmu_base = multi_arg(m2_dmu, m2_dmu_base);
			m2_dma_base = multi_arg(m2_dma, m2_dma_base);
			sys_dma_base = multi_arg(sys_dma, sys_dma_base);
			c2cc_base = multi_arg(c2cc, c2cc_base);
			ddr_base = multi_arg(ddr_mem, ddr_memory_base);
			m1_sgr_base = multi_arg(pacdsp[0], core_base) + multi_arg(pacdsp[0].biu, biu_offset) + 0xC078;
			m1_dsr_base = multi_arg(pacdsp[0], core_base) + multi_arg(pacdsp[0].biu, biu_offset) + 0xC07C;
			m2_sgr_base = multi_arg(m2_dma, m2_dma_base) + 0x78;
			m2_dsr_base = multi_arg(m2_dma, m2_dma_base) + 0x7C;
			m1_stat_base = multi_arg(pacdsp[0], core_base) + multi_arg(pacdsp[0].biu, biu_offset) + 0x8054;
			m2_stat_base = multi_arg(m2_dma, m2_dma_base) + 0x54;
		
			m1_mem_size = multi_arg(pacdsp[0].m1_mem, dmem_m1_size);
			m2_mem_size = multi_arg(m2_mem, dmem_m2_size);
			biu_size = multi_arg(pacdsp[0].biu, biu_size);
			icu_size = multi_arg(pacdsp[0].icu, icu_size);
			dmu_size = multi_arg(pacdsp[0].dmu, dmu_size);
			dma_size = multi_arg(pacdsp[0].dma, dma_size);
			m2_dmu_size = multi_arg(m2_dmu, m2_dmu_size);
			m2_dma_size = multi_arg(m2_dma, m2_dma_size);
			sys_dma_size = multi_arg(sys_dma, sys_dma_size);
			c2cc_size = multi_arg(c2cc, c2cc_size);
			ddr_size = multi_arg(ddr_mem, ddr_memory_size);
		
			icache_write(0x0, 0x0, 0x0);
			unsigned char *buf;
			unsigned int m1_corenum;
			buf = (unsigned char *)malloc(sizeof(char) * (ddr_size - 1));
			memset(buf, 0, sizeof(char) * (ddr_size - 1));

			for (m1_corenum = 0; m1_corenum < 4; m1_corenum++) {
//m1_mem        
				dbg_dmem_write((m1_mem_base + 0x100000 * m1_corenum), (unsigned char *)buf, sizeof(char) * (m1_mem_size - 1));
//biu
				dbg_dmem_write((biu_base + 0x100000 * m1_corenum), (unsigned char *)buf, sizeof(char) * (biu_size - 1));
//icu
				dbg_dmem_write((icu_base + 0x100000 * m1_corenum), (unsigned char *)buf, sizeof(char) * (icu_size - 1));
//dmu
				dbg_dmem_write((dmu_base + 0x100000 * m1_corenum), (unsigned char *)buf, sizeof(char) * (dmu_size - 1));
//dma
				dbg_dmem_write((dma_base + 0x100000 * m1_corenum), (unsigned char *)buf, sizeof(char) * (dma_size - 1));
			}

//sys_dma
			dbg_dmem_write(sys_dma_base, (unsigned char *)buf, sizeof(char) * (sys_dma_size - 1));

//m2_mem
			dbg_dmem_write(m2_mem_base, (unsigned char *)buf, sizeof(char) * (m2_mem_size - 1));

//m2_dmu
			dbg_dmem_write(m2_dmu_base, (unsigned char *)buf, sizeof(char) * (m2_dmu_size - 1));

//m2_dma
			dbg_dmem_write(m2_dma_base, (unsigned char *)buf, sizeof(char) * (m2_dma_size - 1));

//c2cc
			dbg_dmem_write(c2cc_base, (unsigned char *)buf, sizeof(char) * (c2cc_size - 1));

//ddr
			dbg_dmem_write(ddr_base, (unsigned char *)buf, sizeof(char) * (ddr_size - 1));

			
			free(buf);

//m1_sgr&dsr                          
			unsigned int buf0 = 0x00100000;

			unsigned int m1_dmanum = 0;
			for (m1_corenum = 0; m1_corenum < 4; m1_corenum++) {
				for (m1_dmanum = 0; m1_dmanum < 4; m1_dmanum++) {
					dbg_dmem_write((m1_sgr_base + 0x100000 * m1_corenum + 0x40 * m1_dmanum), (unsigned char *)(&buf0),
						   sizeof(char) * 4);
					dbg_dmem_write((m1_dsr_base + 0x100000 * m1_corenum + 0x40 * m1_dmanum), (unsigned char *)(&buf0),
						   sizeof(char) * 4);
				}
			}

//m2_sgr&dsr
			unsigned int m2_dmanum = 0;
			for (m2_dmanum = 0; m2_dmanum < 8; m2_dmanum++) {
				dbg_dmem_write((m2_sgr_base + 0x40 * m2_dmanum), (unsigned char *)(&buf0), sizeof(char) * 4);
				dbg_dmem_write((m2_dsr_base + 0x40 * m2_dmanum), (unsigned char *)(&buf0), sizeof(char) * 4);
	}

//M1_STAT
			unsigned int buf1 = 0x00002222;
			for (m1_corenum = 0; m1_corenum < 4; m1_corenum++) {
				dbg_dmem_write((m1_stat_base + 0x100000 * m1_corenum), (unsigned char *)(&buf1), sizeof(char) * 4);
			}

//M2_STAT                                                                                    
			unsigned int buf2 = 0x22222222;
			dbg_dmem_write(m2_stat_base, (unsigned char *)(&buf2), sizeof(char) * 4);

			return 0;
		}

	private:
		void l2_cache_sync(unsigned int addr, unsigned char *buf, int len)
		{
			tlm::tlm_generic_payload trans;
			sc_time delay = sc_core::SC_ZERO_TIME;

			trans.set_address(addr);
			trans.set_data_ptr(reinterpret_cast < unsigned char *>(buf));
			trans.set_data_length(len);
			trans.set_command(tlm::TLM_WRITE_COMMAND);
			trans.set_response_status(tlm::TLM_INCOMPLETE_RESPONSE);
			l2_bus_init_socket->b_transport(trans, delay);
		}

		void l2_cache_read(unsigned int addr, unsigned char *buf, int len)
		{
			//tlm::tlm_generic_payload *trans = new tlm::tlm_generic_payload();
			//trans_extension *trans_extension_ptr = new trans_extension();

			soc_core_req_bit_mask[core_id] |= 1 << 3;
			trans_extension_ptr[3].flag = CACHE_DATA;
			trans_extension_ptr[3].inst_core_range = GEN_INST_CORE_RANGE(INST_IF, core_id, DDR_RANGE);
			tlm::tlm_phase phase = tlm::BEGIN_REQ;
			sc_time delay = sc_core::SC_ZERO_TIME;

			trans[3].set_command(tlm::TLM_READ_COMMAND);
			trans[3].set_address(addr);
			trans[3].set_data_ptr(reinterpret_cast < unsigned char *>(buf));
			trans[3].set_data_length(len);
			trans[3].set_response_status(tlm::TLM_INCOMPLETE_RESPONSE);
			trans[3].set_extension(&trans_extension_ptr[3]);

			l2_bus_init_socket->nb_transport_fw(trans[3], phase, delay);

#ifndef PAC_SOC_PROFILE
			tlm::tlm_generic_payload *trans_ptr;
			wait(l2_bus_ResponsePEQ.get_event());
			trans_ptr = l2_bus_ResponsePEQ.get_next_transaction();
#endif
		}

		void l2_cache_write(unsigned int addr, unsigned char *buf, int len)
		{
			tlm::tlm_generic_payload trans;
			sc_time delay = sc_core::SC_ZERO_TIME;

			trans.set_address(addr);
			trans.set_data_ptr(reinterpret_cast < unsigned char *>(buf));
			trans.set_data_length(len);
			trans.set_command(tlm::TLM_WRITE_COMMAND);
			trans.set_response_status(tlm::TLM_INCOMPLETE_RESPONSE);
			l2_bus_init_socket->b_transport(trans, delay);
		}
		
		int d1_dcache_read(unsigned int addr, unsigned char *buf, int len, unsigned int inst_mode) 
		{
			return CACHE_MISS;
		}

		void d2_dcache_read(unsigned int addr, unsigned char *buf, int len, unsigned int inst_mode)
		{	
			trans_extension_ptr[inst_mode].flag = ISS_DATA;
			trans_extension_ptr[inst_mode].inst_core_range = GEN_INST_CORE_RANGE(inst_mode, core_id, 0);

			tlm::tlm_phase phase = tlm::BEGIN_REQ;
			sc_time delay = sc_core::SC_ZERO_TIME;
			trans[inst_mode].set_command(tlm::TLM_READ_COMMAND);
			trans[inst_mode].set_address(addr);
			trans[inst_mode].set_data_ptr(reinterpret_cast<unsigned char *>(buf));
			trans[inst_mode].set_data_length(len);
			trans[inst_mode].set_extension(&trans_extension_ptr[inst_mode]);

			d2_bus_init_socket->nb_transport_fw(trans[inst_mode], phase, delay);

#ifndef PAC_SOC_PROFILE
			tlm::tlm_generic_payload *trans_ptr;
			wait(d2_bus_ResponsePEQ.get_event());
			trans_ptr = d2_bus_ResponsePEQ.get_next_transaction();
#endif
		}

		int d1_dcache_write(unsigned int addr, unsigned char *buf, int len, unsigned int inst_mode) 
		{
			return CACHE_MISS;
		}

		void d2_dcache_write(unsigned int addr, unsigned char *buf, int len, unsigned int inst_mode)
		{	
			trans_extension_ptr[inst_mode].flag = ISS_DATA;
			trans_extension_ptr[inst_mode].inst_core_range = GEN_INST_CORE_RANGE(inst_mode, core_id, 0);
			tlm::tlm_phase phase = tlm::BEGIN_REQ;
			sc_time delay = sc_core::SC_ZERO_TIME;

			trans[inst_mode].set_command(tlm::TLM_WRITE_COMMAND);
			trans[inst_mode].set_address(addr);
			trans[inst_mode].set_data_ptr(reinterpret_cast<unsigned char *>(buf));
			trans[inst_mode].set_data_length(len);
			trans[inst_mode].set_extension(&trans_extension_ptr[inst_mode]);

			d2_bus_init_socket->nb_transport_fw(trans[inst_mode], phase, delay);

#ifndef PAC_SOC_PROFILE
			tlm::tlm_generic_payload *trans_ptr;
			wait(d2_bus_ResponsePEQ.get_event());
			trans_ptr = d2_bus_ResponsePEQ.get_next_transaction();
#endif
		}

		int dbg_d1cache_read(unsigned int addr, unsigned char *buf, int len) 
		{
			return CACHE_MISS;
		}

		int dbg_d1cache_write(unsigned int addr, unsigned char *buf, int len) 
		{
			return CACHE_MISS;
		}

		void dbg_d2cache_read(unsigned int addr, unsigned char *buf, int len) 
		{
				sc_time delay = sc_core::SC_ZERO_TIME;
				tlm::tlm_generic_payload trans;
				trans_extension *trans_ext = new trans_extension;

				trans_ext->flag = ISS_DATA;
				trans_ext->inst_core_range = GEN_INST_CORE_RANGE(0, core_id, 0);
				trans.set_command(tlm::TLM_READ_COMMAND);
				trans.set_address(addr);
				trans.set_data_ptr(reinterpret_cast < unsigned char *>(buf));
				trans.set_data_length(len);
				trans.set_extension(trans_ext);
				trans.set_response_status(tlm::TLM_INCOMPLETE_RESPONSE);

				d2_bus_init_socket->b_transport(trans, delay);

//				if (trans.get_response_status() != tlm::TLM_OK_RESPONSE)
//					printf("dbg_dcache_read response error!\n");
		}

		void dbg_d2cache_write(unsigned int addr, unsigned char *buf, int len) 
		{
				tlm::tlm_generic_payload trans;
				sc_time delay = sc_core::SC_ZERO_TIME;
				trans_extension *trans_ext = new trans_extension;
			
				trans_ext->flag = ISS_DATA;
				trans_ext->inst_core_range = GEN_INST_CORE_RANGE(0, core_id, 0);
				trans.set_command(tlm::TLM_WRITE_COMMAND);
				trans.set_address(addr);
				trans.set_data_ptr(reinterpret_cast < unsigned char *>(buf));
				trans.set_data_length(len);
				trans.set_extension(trans_ext);
				trans.set_response_status(tlm::TLM_INCOMPLETE_RESPONSE);

				d2_bus_init_socket->b_transport(trans, delay);
		}

	private:
		void b_transport(tlm::tlm_generic_payload &trans, sc_time &t)
		{

		}

		tlm::tlm_sync_enum nb_transport_bw(tlm::tlm_generic_payload &trans, tlm::tlm_phase &phase, sc_time &delay)
		{

#ifndef PAC_SOC_PROFILE
		//	sc_dt::uint64 addr;
		//	unsigned int len;
			trans_extension *ext_ptr;
			trans.get_extension(ext_ptr);
			if (phase == tlm::BEGIN_RESP) {
				if (ext_ptr->flag == ISS_DATA) {
					d2_bus_ResponsePEQ.notify(trans, delay);
				} else {
					l2_bus_ResponsePEQ.notify(trans, delay);	
				}
			}
			return tlm::TLM_COMPLETED;
#endif
			return tlm::TLM_COMPLETED;
		}
};

#endif
