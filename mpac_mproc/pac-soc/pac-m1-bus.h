#ifndef PAC_M1_BUS_H_INCLUDED
#define PAC_M1_BUS_H_INCLUDED

#include <systemc.h>
using namespace sc_core;
using namespace sc_dt;
using namespace std;

#include "tlm.h"
#include "tlm_utils/simple_target_socket.h"
#include "tlm_utils/simple_initiator_socket.h"
#include "tlm_utils/peq_with_get.h"

#include "pac-trans-extension.h"
#include "pac-bus.h"
#include "m1-dma-def.h"
#include "dma.h"

/* M1 subsystem	mmap space define */
// M1 (Data Memory)     0x24?00000  0x40000
// RES1             0x24?40000  0x10000
// BIU              0x24?50000  0x04000
// ICU              0x24?54000  0x04000
// DMU              0x24?58000  0x04000
// DMA              0x24?5c000  0x04000
// RES2             0x24?60000  0xa0000

#define	M1_MEM 	0
#define M1_RES1 	1
#define	M1_BIU 	2
#define M1_ICU 	3
#define	M1_DMU 	4
#define M1_DMA 	5
#define M1_RES2 	6

extern sc_core::sc_event soc_core_req_event[DSPNUM]; // 4 core request event
extern int soc_core_req_bit_mask[DSPNUM]; //m1 m2 ddr finish bit mask

class M1_Section_Desc {
	public:
		M1_Section_Desc(unsigned int start_address, int length, int flag, unsigned char *p)
			:start_address(start_address)
			, length(length)
			, flag(flag)
			, p(p) 
		{
		}

		~M1_Section_Desc()
		{
		}

		unsigned int start_address;
		unsigned int length;
		int flag;					// 0 res space
		unsigned char *p;

		// 1 = valid, 0 = invalid
		int addr_valid(unsigned int start, unsigned int len) {
			if ((start >= start_address) && ((start + len) < (start_address + length))) {
				if ((start + len) <= start_address)
					return false;

				return true;
			}
			return false;
		}
};

#ifndef PAC_SOC_PROFILE
struct M1_Bus:public sc_core::sc_module, public pac_bus
{
	private:
		unsigned int core_id;
		struct sim_arg *multi_sim_arg;

		unsigned int *biu_regs;
		unsigned int *icu_regs;
		unsigned int *dmu_regs;
		unsigned int *dma_regs;
		unsigned char *dmem_m1_mem;

		unsigned int m1_mem_base, m1_mem_size;
		unsigned int m1_mem_bank_size, m1_mem_bank_num;
		unsigned int m1_biu_base, m1_biu_size;
		unsigned int m1_icu_base, m1_icu_size;
		unsigned int m1_dmu_base, m1_dmu_size;
		unsigned int m1_dma_base, m1_dma_size;
		unsigned int m1_res1_base, m1_res1_size;
		unsigned int m1_res2_base, m1_res2_size;

		unsigned int c2cc_base;
		unsigned int c2cc_size;
		unsigned int core_size;
		M1_Section_Desc *m1_section_desc[8];

	public:
		tlm_utils::simple_target_socket_tagged < M1_Bus > m1_bus_targ_socket_tagged[3];		// connect to core_bus dma_bus dmu_bus
#ifdef C2CC
		tlm_utils::simple_initiator_socket < M1_Bus > c2cc_init_socket;						// connect to c2cc
#endif
		tlm_utils::simple_initiator_socket < M1_Bus > dma_bus_init_socket; 					// connect to dma_bus

		sc_core::sc_event m1_dma_Request;

		tlm_utils::peq_with_get < tlm::tlm_generic_payload > m1_mem_RequestPEQ;
		//tlm_utils::peq_with_get < tlm::tlm_generic_payload > m2_mem_ResponsePEQ;
		tlm_utils::peq_with_get < tlm::tlm_generic_payload > m1_dma_ResponsePEQ;
		tlm_utils::peq_with_get < tlm::tlm_generic_payload > m1_dmu_ResponsePEQ;
	
		SC_HAS_PROCESS(M1_Bus);

	public:
		M1_Bus(sc_module_name _name, unsigned int id, struct sim_arg *arg)
		:sc_core::sc_module(_name)
		, core_id(id)
		, multi_sim_arg(arg)
#ifdef C2CC
		, c2cc_init_socket("c2cc_init_socket")
#endif
		, dma_bus_init_socket("dma_bus_init_socket")
		, m1_mem_RequestPEQ("m1_mem_RequestPEQ")
		//, m1_mem_ResponsePEQ("m1_mem_ResponsetPEQ")
		, m1_dma_ResponsePEQ("m1_dma_ResponsePEQ")
		, m1_dmu_ResponsePEQ("m1_dmu_ResponsePEQ")
		{
			m1_mem_base = multi_arg(pacdsp[core_id], core_base)
					+ multi_arg(pacdsp[core_id].m1_mem, dmem_m1_offset);

			m1_biu_base = multi_arg(pacdsp[core_id], core_base)
					+ multi_arg(pacdsp[core_id].biu, biu_offset);

			m1_icu_base = multi_arg(pacdsp[core_id], core_base)
					+ multi_arg(pacdsp[core_id].icu, icu_offset);

			m1_dmu_base = multi_arg(pacdsp[core_id], core_base)
					+ multi_arg(pacdsp[core_id].dmu, dmu_offset);

			m1_dma_base = multi_arg(pacdsp[core_id], core_base)
					+ multi_arg(pacdsp[core_id].dma, dma_offset);

			m1_res1_base = multi_arg(pacdsp[core_id], core_base)
					+ multi_arg(pacdsp[core_id].res1, res1_offset);

			m1_res2_base = multi_arg(pacdsp[core_id], core_base)
					+ multi_arg(pacdsp[core_id].res2, res2_offset);

			m1_mem_size = multi_arg(pacdsp[core_id].m1_mem, dmem_m1_size);
			m1_mem_bank_size = multi_arg(pacdsp[core_id].m1_mem, dmem_m1_bank_size);
			m1_mem_bank_num = m1_mem_size/m1_mem_bank_size;

			m1_biu_size = multi_arg(pacdsp[core_id].biu, biu_size);
			m1_icu_size = multi_arg(pacdsp[core_id].icu, icu_size);
			m1_dmu_size = multi_arg(pacdsp[core_id].dmu, dmu_size);
			m1_dma_size = multi_arg(pacdsp[core_id].dma, dma_size);
			m1_res1_size = multi_arg(pacdsp[core_id].res1, res1_size);
			m1_res2_size = multi_arg(pacdsp[core_id].res2, res2_size);

			core_size = m1_mem_size + m1_biu_size + m1_icu_size + m1_dmu_size
					+ m1_dma_size + m1_res1_size + m1_res2_size;

			c2cc_base = multi_arg(c2cc, c2cc_base);
			c2cc_size = multi_arg(c2cc, c2cc_size);

			dmem_m1_mem = (unsigned char *)multi_arg(shm_ptr, core_ptr)
					+ multi_arg(pacdsp[core_id].m1_mem, dmem_m1_offset) + core_id * core_size;

			biu_regs = (unsigned int *)multi_arg(shm_ptr, core_ptr)
					+ (multi_arg(pacdsp[core_id].biu, biu_offset) + core_id * core_size) / 4;

			icu_regs = (unsigned int *)multi_arg(shm_ptr, core_ptr)
					+ (multi_arg(pacdsp[core_id].icu, icu_offset) + core_id * core_size) / 4;

			dmu_regs = (unsigned int *)multi_arg(shm_ptr, core_ptr)
					+ (multi_arg(pacdsp[core_id].dmu, dmu_offset) + core_id * core_size) / 4;

			dma_regs = (unsigned int *)multi_arg(shm_ptr, core_ptr)
					+ (multi_arg(pacdsp[core_id].dma, dma_offset) + core_id * core_size) / 4;

			memset(dmem_m1_mem, 0, m1_mem_size);
			memset(biu_regs, 0, m1_biu_size / 4);
			memset(icu_regs, 0, m1_icu_size / 4);
			memset(dmu_regs, 0, m1_dmu_size / 4);
			memset(dma_regs, 0, m1_dma_size / 4);

			dmu_regs[DMU_DMASTAT >> 2] = 0x2222;	//DMA status Reg default is done

			unsigned int m1_dmanum = 0;
			for (m1_dmanum = 0; m1_dmanum < 4; m1_dmanum++) {
				dma_regs[(M1_DMASGR0 + 0x40 * m1_dmanum) >> 2] = 0x10000;
				dma_regs[(M1_DMADSR0 + 0x40 * m1_dmanum) >> 2] = 0x10000;
			}

			m1_section_desc[M1_MEM] = new M1_Section_Desc(m1_mem_base, m1_mem_size, 1, (unsigned char *)dmem_m1_mem);
			m1_section_desc[M1_RES1] = new M1_Section_Desc(m1_res1_base, m1_res1_size, 0, (unsigned char *)NULL);
			m1_section_desc[M1_BIU] = new M1_Section_Desc(m1_biu_base, m1_biu_size, 1, (unsigned char *)biu_regs);
			m1_section_desc[M1_ICU] = new M1_Section_Desc(m1_icu_base, m1_icu_size, 1, (unsigned char *)icu_regs);
			m1_section_desc[M1_DMU] = new M1_Section_Desc(m1_dmu_base, m1_dmu_size, 1, (unsigned char *)dmu_regs);
			m1_section_desc[M1_DMA] = new M1_Section_Desc(m1_dma_base, m1_dma_size, 1, (unsigned char *)dma_regs);
			m1_section_desc[M1_RES2] = new M1_Section_Desc(m1_res2_base, m1_res2_size, 0, (unsigned char *)NULL);

			m1_bus_targ_socket_tagged[0].register_nb_transport_fw(this, &M1_Bus::nb_transport_fw, 0); //connect to core_bus
			m1_bus_targ_socket_tagged[0].register_b_transport(this, &M1_Bus::b_transport, 0);

			m1_bus_targ_socket_tagged[1].register_nb_transport_fw(this, &M1_Bus::nb_transport_fw, 1); //connect to dma_bus
			dma_bus_init_socket.register_nb_transport_bw(this, &M1_Bus::dma_nb_transport_bw);

			m1_bus_targ_socket_tagged[2].register_nb_transport_fw(this, &M1_Bus::nb_transport_fw, 2);
			m1_bus_targ_socket_tagged[2].register_b_transport(this, &M1_Bus::b_transport, 2);

			SC_THREAD(M1_Bus_Request_Thread);
			//SC_THREAD(M1_Bus_Response_Thread);
			SC_THREAD(M1_Dma_Request_Thread);
			SC_THREAD(M1_Dma_Response_Thread);
		}

		~M1_Bus()
		{
			delete m1_section_desc[M1_MEM];
			delete m1_section_desc[M1_RES1];
			delete m1_section_desc[M1_BIU];
			delete m1_section_desc[M1_ICU];
			delete m1_section_desc[M1_DMU];
			delete m1_section_desc[M1_DMA];
			delete m1_section_desc[M1_RES2];
		}

	private:

		void M1_Bus_Request_Thread()
		{
			trans_extension *ext_ptr;
			tlm::tlm_generic_payload *trans_ptr;
			tlm::tlm_phase phase = tlm::BEGIN_REQ;
			sc_core::sc_time t = sc_core::SC_ZERO_TIME;
			sc_dt::uint64 addr;
			unsigned int len;

			while(true) {
				wait(m1_mem_RequestPEQ.get_event());
				wait(sc_core::SC_ZERO_TIME);
				while(true) {
					trans_ptr = m1_mem_RequestPEQ.get_next_transaction(); 
					if (trans_ptr == NULL) {
							break;
					} else {
						addr = trans_ptr->get_address();
						len = trans_ptr->get_data_length();
						trans_ptr->get_extension(ext_ptr);

						if (addr_valid(addr, len)) {	// internel m1 mem space
							Dmem_m1_access(trans_ptr);
						} 
#ifdef C2CC
						else if ((addr >= c2cc_base) && (addr + len) < (c2cc_base + c2cc_size)) { //internal c2cc mem space
							c2cc_init_socket->nb_transport_fw(*trans_ptr, phase, t);
						}
#endif

					}
					tlm::tlm_phase phase = tlm::BEGIN_RESP;
					PendingTransactionsIterator it = mPendingTransactions.find(trans_ptr);
					m1_bus_targ_socket_tagged[it->second.from]->nb_transport_bw(*trans_ptr, phase, t);
					mPendingTransactions.erase(it);
				}
			}
		}

		//void M1_Bus_Response_Thread()
		//{
		//	tlm::tlm_sync_enum ret;
		//	tlm::tlm_generic_payload * trans_ptr;
		//	tlm::tlm_phase phase = tlm::BEGIN_RESP;
		//	sc_core::sc_time t = sc_core::SC_ZERO_TIME;

		//	while (true) {
		//		wait(m1_mem_ResponsePEQ.get_event());
		//		trans_ptr = m1_mem_ResponsePEQ.get_next_transaction();
		//		PendingTransactionsIterator it = mPendingTransactions.find(trans_ptr);
		//		ret = m1_bus_targ_socket->nb_transport_bw(*trans_ptr, phase, t);
		//		mPendingTransactions.erase(it);
		//	}
		//}


		tlm::tlm_sync_enum nb_transport_fw(int id, tlm::tlm_generic_payload & trans, 
						tlm::tlm_phase & phase, sc_core::sc_time & t)
		{

			if (phase == tlm::BEGIN_REQ) {
				addPendingTransaction(trans, 0, id);
				m1_mem_RequestPEQ.notify(trans, t);
			}

			return tlm::TLM_ACCEPTED;
		}

		//tlm::tlm_sync_enum nb_transport_bw(tlm::tlm_generic_payload & trans,
		//				tlm::tlm_phase & phase, sc_time & delay)
		//{
		//	if (phase == tlm::BEGIN_RESP) {
		//		m1_mem_ResponsePEQ.notfiy(trans, delay);
		//	}
		//	return tlm::TLM_COMPLETED;
		//}

		void b_transport(int id, tlm::tlm_generic_payload & trans, sc_time & delay)
		{
			unsigned int range = 100;
			tlm::tlm_command cmd = trans.get_command();
			sc_dt::uint64 addr = trans.get_address();
			unsigned char *ptr = trans.get_data_ptr();
			unsigned int len = trans.get_data_length();

			if (addr_valid(addr, len)) {										// internel m1 mem space
				if (cmd == tlm::TLM_READ_COMMAND) {
					if (m1_section_desc[M1_MEM]->addr_valid(addr, len))			// local m1 mem space
						memcpy(ptr, &dmem_m1_mem[addr - m1_mem_base], len);

					if (m1_section_desc[M1_RES1]->addr_valid(addr, len))		// local res1 mem space
						range = M1_RES1;

					if (m1_section_desc[M1_BIU]->addr_valid(addr, len))			// local biu mem space
						memcpy(ptr, (unsigned char *)&biu_regs[(addr - m1_section_desc[M1_BIU]->start_address) >> 2], len);

					if (m1_section_desc[M1_ICU]->addr_valid(addr, len))			// local icu mem space
						memcpy(ptr, (unsigned char *)&icu_regs[(addr - m1_section_desc[M1_ICU]->start_address) >> 2], len);

					if (m1_section_desc[M1_DMU]->addr_valid(addr, len))			// local dmu mem space
						memcpy(ptr, (unsigned char *)&dmu_regs[(addr - m1_section_desc[M1_DMU]->start_address) >> 2], len);

					if (m1_section_desc[M1_DMA]->addr_valid(addr, len))			// local dma mem space
						memcpy(ptr, (unsigned char *)&dma_regs[(addr - m1_section_desc[M1_DMA]->start_address) >> 2], len);

					if (m1_section_desc[M1_RES2]->addr_valid(addr, len))		// local res2 mem space
						range = M1_RES2;
				} else {
					if (m1_section_desc[M1_MEM]->addr_valid(addr, len))			// local m1 mem space
						memcpy(&dmem_m1_mem[addr - m1_mem_base], ptr, len);

					if (m1_section_desc[M1_RES1]->addr_valid(addr, len))		// local res1 mem space
						range = M1_RES1;

					if (m1_section_desc[M1_BIU]->addr_valid(addr, len))			// local biu mem space
						memcpy((unsigned char *)&biu_regs[(addr - m1_section_desc[M1_BIU]->start_address) >> 2], ptr, len);

					if (m1_section_desc[M1_ICU]->addr_valid(addr, len))			// local icu mem space
						memcpy((unsigned char *)&icu_regs[(addr - m1_section_desc[M1_ICU]->start_address) >> 2], ptr, len);

					if (m1_section_desc[M1_DMU]->addr_valid(addr, len))			// local dmu mem space
						memcpy((unsigned char *)&dmu_regs[(addr - m1_section_desc[M1_DMU]->start_address) >> 2], ptr, len);

					if (m1_section_desc[M1_DMA]->addr_valid(addr, len)) {		// local dma mem space
						memcpy((unsigned char *)&dma_regs[(addr - m1_section_desc[M1_DMA]->start_address) >> 2], ptr, len);
					}

					if (m1_section_desc[M1_RES2]->addr_valid(addr, len))		// local res2 mem space
						range = M1_RES2;
				}
				trans.set_response_status(tlm::TLM_OK_RESPONSE);
			}
#ifdef C2CC
			else if ((addr >= (c2cc_base + core_id * 0x1000))					// c2cc space
				 && ((addr + len) < (c2cc_base + (core_id + 1) * 0x1000))) {
				c2cc_init_socket->b_transport(trans, delay);
			}
#endif
		}

		
		tlm::tlm_sync_enum dma_nb_transport_bw(tlm::tlm_generic_payload & trans,
						tlm::tlm_phase & phase, sc_time & delay)
		{
			if (phase == tlm::BEGIN_RESP)
					m1_dma_ResponsePEQ.notify(trans, delay);

			return tlm::TLM_COMPLETED;
		}

		void M1_Dma_Request_Thread()
		{
			unsigned int dmaen;
			unsigned int len;
			int ret;
			int m1_dmanum;

			while (true) {
				wait(m1_dma_Request);

				while (true) {
					dmaen = 0;
					len = 0;
					for (m1_dmanum = 0; m1_dmanum < 4; m1_dmanum++) {
						if (dma_regs[(M1_DMACLR0 + 0x40 * m1_dmanum) >> 2] & 0x1) {
							dmu_regs[DMU_DMASTAT >> 2] = (dmu_regs[DMU_DMASTAT >> 2] & ~(0xF << m1_dmanum * 4));
							dma_regs[(M1_DMACLR0 + 0x40 * m1_dmanum) >> 2] = 0;
						}
						dmaen = (dma_regs[(M1_DMAEN0 + 0x40 * m1_dmanum) >> 2] & 0x1);
						len = (dma_regs[(M1_DMACTL0 + 0x40 * m1_dmanum) >> 2] & 0xfffff000) >> 12;
						if ((dmaen == DMAEN_ENABLE) && ((dmu_regs[DMU_DMASTAT >> 2] & (0x1 << m1_dmanum * 4)) == 0)) {
							break;
						}
					}

					if ((dmaen != DMAEN_ENABLE))
						break;

					tlm::tlm_generic_payload * trans = new tlm::tlm_generic_payload();
					tlm::tlm_phase phase = tlm::BEGIN_REQ;
					sc_core::sc_time delay = sc_core::SC_ZERO_TIME;
					dma_regs[(M1_DMAEN0 + 0x40 * m1_dmanum) >> 2] = DMAEN_WORKING;

					ret = m1_dma_process(*trans, m1_dmanum);

					if (ret) {
						dmu_regs[DMU_DMASTAT >> 2] |= 0x3 << (m1_dmanum * 4);
						dma_regs[(M1_DMAEN0 + 0x40 * m1_dmanum) >> 2] = DMAEN_IDLE;
					}
				}
			}
		}

		void M1_Dma_Response_Thread()
		{
			tlm::tlm_generic_payload * trans_ptr;
			tlm::tlm_phase phase = tlm::BEGIN_REQ;
			sc_core::sc_time delay = sc_core::SC_ZERO_TIME;
			dma_extension *ext_ptr;
			sc_dt::uint64 addr;
			unsigned int *p;

			while (true) {
				wait(m1_dma_ResponsePEQ.get_event());

				while(true) {
					trans_ptr = m1_dma_ResponsePEQ.get_next_transaction();
					if (trans_ptr == NULL)
							break;
					trans_ptr->get_extension(ext_ptr);
	
					if (trans_ptr->get_response_status() != tlm::TLM_OK_RESPONSE)
						dmu_regs[DMU_DMASTAT >> 2] |= 0x3 << (ext_ptr->ch_num * 4);
	
					if (dma_regs[(M1_DMACTL0 + 0x40 * ext_ptr->ch_num) >> 2] & 0x800) {
						addr = dma_regs[(M1_DMALLST0 + 0x40 * ext_ptr->ch_num) >> 2] & 0xfffff;
						if (addr >= m1_mem_size) {
							dmu_regs[DMU_DMASTAT >> 2] |= 0x7 << (ext_ptr->ch_num * 4);
							dma_regs[(M1_DMAEN0 + 0x40 * ext_ptr->ch_num) >> 2] = DMAEN_IDLE;
							delete trans_ptr;
							continue;
						}

						p = (unsigned int *)&dmem_m1_mem[addr];
						unsigned int m1_dma_llst = dma_regs[(M1_DMALLST0 + 0x40 * ext_ptr->ch_num) >> 2];
//it's for M1 spec 1.4
						if (m1_dma_llst & 0x80000000)
							dma_regs[(M1_DMASAR0 + 0x40 * ext_ptr->ch_num) >> 2] = *p++;
	
						if (m1_dma_llst & 0x40000000)
							dma_regs[(M1_DMADAR0 + 0x40 * ext_ptr->ch_num) >> 2] = *p++;
	
						if (m1_dma_llst & 0x20000000)
							dma_regs[(M1_DMASGR0 + 0x40 * ext_ptr->ch_num) >> 2] = *p++;
	
						if (m1_dma_llst & 0x10000000)
							dma_regs[(M1_DMADSR0 + 0x40 * ext_ptr->ch_num) >> 2] = *p++;
	
						if (m1_dma_llst & 0x8000000)
							dma_regs[(M1_DMACTL0 + 0x40 * ext_ptr->ch_num) >> 2] = *p++;

						if (m1_dma_llst & 0x4000000)
							dma_regs[(M1_DMALLST0 + 0x40 * ext_ptr->ch_num) >> 2] = *p;
	
						if (m1_dma_llst & 0x2000000)
							dma_regs[(M1_DMAPDCTL0 + 0x40 * ext_ptr->ch_num) >> 2] = *p++;
	
						if (m1_dma_llst & 0x1000000)
							dma_regs[(M1_DMASHAPE0 + 0x40 * ext_ptr->ch_num) >> 2] = *p++;
	
						if (m1_dma_llst & 0x800000)
							dma_regs[(M1_DMARES0 + 0x40 * ext_ptr->ch_num) >> 2] = *p++;
	
						dma_regs[(M1_DMAEN0 + 0x40 * ext_ptr->ch_num) >> 2] = DMAEN_ENABLE;
						dmu_regs[DMU_DMASTAT >> 2] &= ~(0x1 << (ext_ptr->ch_num * 4));
						m1_dma_Request.notify();
					} else {
						dma_regs[(M1_DMAEN0 + 0x40 * ext_ptr->ch_num) >> 2] = DMAEN_IDLE;
						dmu_regs[DMU_DMASTAT >> 2] &= ~(0x1 << (ext_ptr->ch_num * 4));
						dmu_regs[DMU_DMASTAT >> 2] |= 0x2 << (ext_ptr->ch_num * 4);
					}
		
					delete trans_ptr;
				}
			}
		}

		int Dmem_m1_access(tlm::tlm_generic_payload *trans_ptr) 
		{
			unsigned int range = 100;
			unsigned int m1_dmanum;
			sc_core::sc_time t = sc_core::SC_ZERO_TIME;
			dma_extension *ext_ptr;

			tlm::tlm_command cmd = trans_ptr->get_command();
			sc_dt::uint64 addr = trans_ptr->get_address();
			unsigned char *ptr = trans_ptr->get_data_ptr();
			unsigned int len = trans_ptr->get_data_length();

			trans_ptr->get_extension(ext_ptr);
			if (!ext_ptr) {
				if (cmd == tlm::TLM_READ_COMMAND) {
					if (m1_section_desc[M1_MEM]->addr_valid(addr, len))			// local m1 mem space
						memcpy(ptr, &dmem_m1_mem[addr - m1_mem_base], len);

					if (m1_section_desc[M1_RES1]->addr_valid(addr, len))		// local res1 mem space
						range = M1_RES1;

					if (m1_section_desc[M1_BIU]->addr_valid(addr, len))			// local biu mem space
						memcpy(ptr, (unsigned char *)&biu_regs[(addr - m1_section_desc[M1_BIU]->start_address) >> 2], len);

					if (m1_section_desc[M1_ICU]->addr_valid(addr, len))			// local icu mem space
						memcpy(ptr, (unsigned char *)&icu_regs[(addr - m1_section_desc[M1_ICU]->start_address) >> 2], len);

					if (m1_section_desc[M1_DMU]->addr_valid(addr, len))			// local dmu mem space
						memcpy(ptr, (unsigned char *)&dmu_regs[(addr - m1_section_desc[M1_DMU]->start_address) >> 2], len);

					if (m1_section_desc[M1_DMA]->addr_valid(addr, len))			// local dma mem space
						memcpy(ptr, (unsigned char *)&dma_regs[(addr - m1_section_desc[M1_DMA]->start_address) >> 2], len);

					if (m1_section_desc[M1_RES2]->addr_valid(addr, len))		// local res2 mem space
						range = M1_RES2;
				} else {
					if (m1_section_desc[M1_MEM]->addr_valid(addr, len))			// local m1 mem space
						memcpy(&dmem_m1_mem[addr - m1_mem_base], ptr, len);

					if (m1_section_desc[M1_RES1]->addr_valid(addr, len))		// local res1 mem space
						range = M1_RES1;

					if (m1_section_desc[M1_BIU]->addr_valid(addr, len))			// local biu mem space
						memcpy((unsigned char *)&biu_regs[(addr - m1_section_desc[M1_BIU]->start_address) >> 2], ptr, len);

					if (m1_section_desc[M1_ICU]->addr_valid(addr, len))			// local icu mem space
						memcpy((unsigned char *)&icu_regs[(addr - m1_section_desc[M1_ICU]->start_address) >> 2], ptr, len);

					if (m1_section_desc[M1_DMU]->addr_valid(addr, len))			// local dmu mem space
						memcpy((unsigned char *)&dmu_regs[(addr - m1_section_desc[M1_DMU]->start_address) >> 2], ptr, len);

					if (m1_section_desc[M1_DMA]->addr_valid(addr, len)) {		// local dma mem space
						memcpy((unsigned char *)&dma_regs[(addr - m1_section_desc[M1_DMA]->start_address) >> 2], ptr, len);
						for (m1_dmanum = 0; m1_dmanum < 4; m1_dmanum++) {
							if (addr == M1_DMAEN0 + m1_section_desc[M1_DMA]->start_address + 0x40 * m1_dmanum) {
								*ptr = 1;
								memcpy((unsigned char *)&dma_regs[(addr - m1_section_desc[M1_DMA]->start_address) >> 2], ptr, len);
								m1_dma_Request.notify();
								break;
							}
						}
					}

					if (m1_section_desc[M1_RES2]->addr_valid(addr, len))		// local res2 mem space
						range = M1_RES2;
				}
			} else
				dma_operation(trans_ptr, t);
			return true;
		}

		// 1 = valid, 0 = invalid
		int addr_valid(unsigned int start, unsigned int len)
		{
			if ((start >= m1_mem_base) && ((start + len) < (m1_mem_base + m1_mem_size))) {
				if ((start + len) > m1_mem_base)
					return true;
			}

			if ((start >= m1_res1_base) && ((start + len) < (m1_res1_base + m1_res1_size))) {
				if ((start + len) > m1_res1_base)
					return true;
			}

			if ((start >= m1_biu_base) && ((start + len) < (m1_biu_base + m1_biu_size))) {
				if ((start + len) > m1_biu_base)
					return true;
			}

			if ((start >= m1_icu_base) && ((start + len) < (m1_icu_base + m1_icu_size))) {
				if ((start + len) > m1_icu_base)
					return true;
			}

			if ((start >= m1_dmu_base) && ((start + len) < (m1_dmu_base + m1_dmu_size))) {
				if ((start + len) > m1_dmu_base)
					return true;
			}

			if ((start >= m1_dma_base) && ((start + len) < (m1_dma_base + m1_dma_size))) {
				if ((start + len) > m1_dma_base)
					return true;
			}

			if ((start >= m1_res2_base) && ((start + len) < (m1_res2_base + m1_res2_size))) {
				if ((start + len) > m1_res2_base)
					return true;
			}

			return false;
		}

	private:
		void addPendingTransaction(tlm::tlm_generic_payload & trans, int to, int initiatorId)
		{
			const ConnectionInfo info = { initiatorId, to };
			assert(mPendingTransactions.find(&trans) == mPendingTransactions.end());
			mPendingTransactions[&trans] = info;
		}

		struct ConnectionInfo {
			int from;
			int to;
		};

		typedef std::map < tlm::tlm_generic_payload *, ConnectionInfo > PendingTransactions;
		typedef PendingTransactions::iterator PendingTransactionsIterator;

		PendingTransactions mPendingTransactions;

// dma out
		int m1_dma_process(tlm::tlm_generic_payload &trans, unsigned int m1_dmanum);
		int m1_dma_int2ext(tlm::tlm_generic_payload &trans, unsigned int m1_dmanum);
		int m1_dma_shape(tlm::tlm_generic_payload &trans, unsigned int m1_dmanum);
		int m1_dma_fifo(tlm::tlm_generic_payload &trans, unsigned int m1_dmanum);
		int m1_dma_sc(tlm::tlm_generic_payload &trans, unsigned int m1_dmanum);

//dma in
		void dma_operation(tlm::tlm_generic_payload *trans_ptr, sc_core::sc_time &delay);
		void extend_memcpy(unsigned char *dst, unsigned char *src, unsigned int len);
		void zone_memcpy_x0y0(tlm::tlm_generic_payload *trans_ptr);
		void zone_memcpy_x0y1(tlm::tlm_generic_payload *trans_ptr);
		void zone_memcpy_x1y0(tlm::tlm_generic_payload *trans_ptr);
		void zone_memcpy_x1y1(tlm::tlm_generic_payload *trans_ptr);
		void zone_memcpy_x0(tlm::tlm_generic_payload *trans_ptr);
		void zone_memcpy_x1(tlm::tlm_generic_payload *trans_ptr);
		void zone_memcpy_y0(tlm::tlm_generic_payload *trans_ptr);
		void zone_memcpy_y1(tlm::tlm_generic_payload *trans_ptr);
		void zone_memcpy_direct(tlm::tlm_generic_payload *trans_ptr);
		void dma_shape_operation(tlm::tlm_generic_payload *trans_ptr, sc_core::sc_time &delay);
		void padding_operation_x0y0(tlm::tlm_generic_payload *trans_ptr, sc_core::sc_time &delay);
		void padding_operation_x0y1(tlm::tlm_generic_payload *trans_ptr, sc_core::sc_time &delay);
		void padding_operation_x1y0(tlm::tlm_generic_payload *trans_ptr, sc_core::sc_time &delay);
		void padding_operation_x1y1(tlm::tlm_generic_payload *trans_ptr, sc_core::sc_time &delay);
		void padding_operation_x0(tlm::tlm_generic_payload *trans_ptr, sc_core::sc_time &delay);
		void padding_operation_x1(tlm::tlm_generic_payload *trans_ptr, sc_core::sc_time &delay);
		void padding_operation_y0(tlm::tlm_generic_payload *trans_ptr, sc_core::sc_time &delay);
		void padding_operation_y1(tlm::tlm_generic_payload *trans_ptr, sc_core::sc_time &delay);
		void dma_direct_operation(tlm::tlm_generic_payload *trans_ptr, sc_core::sc_time &delay);
		void dma_sc_operation(tlm::tlm_generic_payload *trans_ptr, sc_core::sc_time &delay);
		void dma_fifo_operation(tlm::tlm_generic_payload *trans_ptr, sc_core::sc_time &delay);

#else //IN PAC_SOC_PROFILE

struct M1_Bus:public sc_core::sc_module, public pac_bus
{
	private:
		unsigned int core_id;
		struct sim_arg *multi_sim_arg;

		unsigned int *biu_regs;
		unsigned int *icu_regs;
		unsigned int *dmu_regs;
		unsigned int *dma_regs;
		unsigned char *dmem_m1_mem;

		unsigned int m1_mem_base, m1_mem_size;
		unsigned int m1_mem_bank_size, m1_mem_bank_num;
		unsigned int m1_biu_base, m1_biu_size;
		unsigned int m1_icu_base, m1_icu_size;
		unsigned int m1_dmu_base, m1_dmu_size;
		unsigned int m1_dma_base, m1_dma_size;
		unsigned int m1_res1_base, m1_res1_size;
		unsigned int m1_res2_base, m1_res2_size;

		unsigned int c2cc_base;
		unsigned int c2cc_size;
		unsigned int core_size;
		M1_Section_Desc *m1_section_desc[8];

	public:
		tlm_utils::simple_target_socket_tagged < M1_Bus > m1_bus_targ_socket_tagged[3];		// connect to core_bus dma_bus dmu_bus
#ifdef C2CC
		tlm_utils::simple_initiator_socket < M1_Bus > c2cc_init_socket;						// connect to c2cc
#endif
		tlm_utils::simple_initiator_socket < M1_Bus > dma_bus_init_socket; 					// connect to dma_bus

		sc_core::sc_event m1_dma_Request;

		tlm_utils::peq_with_get < tlm::tlm_generic_payload > m1_mem_RequestPEQ;
		tlm_utils::peq_with_get < tlm::tlm_generic_payload > m1_mem_RequestPEQ_Dma;
		//tlm_utils::peq_with_get < tlm::tlm_generic_payload > m2_mem_ResponsePEQ;
		tlm_utils::peq_with_get < tlm::tlm_generic_payload > m1_dma_ResponsePEQ;
		tlm_utils::peq_with_get < tlm::tlm_generic_payload > m1_dmu_ResponsePEQ;
	
		SC_HAS_PROCESS(M1_Bus);

	public:
		M1_Bus(sc_module_name _name, unsigned int id, struct sim_arg *arg)
		:sc_core::sc_module(_name)
		, core_id(id)
		, multi_sim_arg(arg)
#ifdef C2CC
		, c2cc_init_socket("c2cc_init_socket")
#endif
		, dma_bus_init_socket("dma_bus_init_socket")
		, m1_mem_RequestPEQ("m1_mem_RequestPEQ")
		, m1_mem_RequestPEQ_Dma("m1_mem_RequestPEQ_Dma")
		//, m1_mem_ResponsePEQ("m1_mem_ResponsetPEQ")
		, m1_dma_ResponsePEQ("m1_dma_ResponsePEQ")
		, m1_dmu_ResponsePEQ("m1_dmu_ResponsePEQ")
		{
			m1_mem_base = multi_arg(pacdsp[core_id], core_base)
					+ multi_arg(pacdsp[core_id].m1_mem, dmem_m1_offset);

			m1_biu_base = multi_arg(pacdsp[core_id], core_base)
					+ multi_arg(pacdsp[core_id].biu, biu_offset);

			m1_icu_base = multi_arg(pacdsp[core_id], core_base)
					+ multi_arg(pacdsp[core_id].icu, icu_offset);

			m1_dmu_base = multi_arg(pacdsp[core_id], core_base)
					+ multi_arg(pacdsp[core_id].dmu, dmu_offset);

			m1_dma_base = multi_arg(pacdsp[core_id], core_base)
					+ multi_arg(pacdsp[core_id].dma, dma_offset);

			m1_res1_base = multi_arg(pacdsp[core_id], core_base)
					+ multi_arg(pacdsp[core_id].res1, res1_offset);

			m1_res2_base = multi_arg(pacdsp[core_id], core_base)
					+ multi_arg(pacdsp[core_id].res2, res2_offset);

			m1_mem_size = multi_arg(pacdsp[core_id].m1_mem, dmem_m1_size);
			m1_mem_bank_size = multi_arg(pacdsp[core_id].m1_mem, dmem_m1_bank_size);
			m1_mem_bank_num = m1_mem_size/m1_mem_bank_size;

			m1_biu_size = multi_arg(pacdsp[core_id].biu, biu_size);
			m1_icu_size = multi_arg(pacdsp[core_id].icu, icu_size);
			m1_dmu_size = multi_arg(pacdsp[core_id].dmu, dmu_size);
			m1_dma_size = multi_arg(pacdsp[core_id].dma, dma_size);
			m1_res1_size = multi_arg(pacdsp[core_id].res1, res1_size);
			m1_res2_size = multi_arg(pacdsp[core_id].res2, res2_size);

			core_size = m1_mem_size + m1_biu_size + m1_icu_size + m1_dmu_size
					+ m1_dma_size + m1_res1_size + m1_res2_size;

			c2cc_base = multi_arg(c2cc, c2cc_base);
			c2cc_size = multi_arg(c2cc, c2cc_size);

			dmem_m1_mem = (unsigned char *)multi_arg(shm_ptr, core_ptr)
					+ multi_arg(pacdsp[core_id].m1_mem, dmem_m1_offset) + core_id * core_size;

			biu_regs = (unsigned int *)multi_arg(shm_ptr, core_ptr)
					+ (multi_arg(pacdsp[core_id].biu, biu_offset) + core_id * core_size) / 4;

			icu_regs = (unsigned int *)multi_arg(shm_ptr, core_ptr)
					+ (multi_arg(pacdsp[core_id].icu, icu_offset) + core_id * core_size) / 4;

			dmu_regs = (unsigned int *)multi_arg(shm_ptr, core_ptr)
					+ (multi_arg(pacdsp[core_id].dmu, dmu_offset) + core_id * core_size) / 4;

			dma_regs = (unsigned int *)multi_arg(shm_ptr, core_ptr)
					+ (multi_arg(pacdsp[core_id].dma, dma_offset) + core_id * core_size) / 4;

			memset(dmem_m1_mem, 0, m1_mem_size);
			memset(biu_regs, 0, m1_biu_size / 4);
			memset(icu_regs, 0, m1_icu_size / 4);
			memset(dmu_regs, 0, m1_dmu_size / 4);
			memset(dma_regs, 0, m1_dma_size / 4);

			dmu_regs[DMU_DMASTAT >> 2] = 0x2222;	//DMA status Reg default is done

			unsigned int m1_dmanum = 0;
			for (m1_dmanum = 0; m1_dmanum < 4; m1_dmanum++) {
				dma_regs[(M1_DMASGR0 + 0x40 * m1_dmanum) >> 2] = 0x10000;
				dma_regs[(M1_DMADSR0 + 0x40 * m1_dmanum) >> 2] = 0x10000;
			}

			m1_section_desc[M1_MEM] = new M1_Section_Desc(m1_mem_base, m1_mem_size, 1, (unsigned char *)dmem_m1_mem);
			m1_section_desc[M1_RES1] = new M1_Section_Desc(m1_res1_base, m1_res1_size, 0, (unsigned char *)NULL);
			m1_section_desc[M1_BIU] = new M1_Section_Desc(m1_biu_base, m1_biu_size, 1, (unsigned char *)biu_regs);
			m1_section_desc[M1_ICU] = new M1_Section_Desc(m1_icu_base, m1_icu_size, 1, (unsigned char *)icu_regs);
			m1_section_desc[M1_DMU] = new M1_Section_Desc(m1_dmu_base, m1_dmu_size, 1, (unsigned char *)dmu_regs);
			m1_section_desc[M1_DMA] = new M1_Section_Desc(m1_dma_base, m1_dma_size, 1, (unsigned char *)dma_regs);
			m1_section_desc[M1_RES2] = new M1_Section_Desc(m1_res2_base, m1_res2_size, 0, (unsigned char *)NULL);

			m1_bus_targ_socket_tagged[0].register_nb_transport_fw(this, &M1_Bus::nb_transport_fw, 0); //connect to core_bus
			m1_bus_targ_socket_tagged[0].register_b_transport(this, &M1_Bus::b_transport, 0);

			m1_bus_targ_socket_tagged[1].register_nb_transport_fw(this, &M1_Bus::nb_transport_fw, 1); //connect to dma_bus
			dma_bus_init_socket.register_nb_transport_bw(this, &M1_Bus::dma_nb_transport_bw);

			m1_bus_targ_socket_tagged[2].register_nb_transport_fw(this, &M1_Bus::nb_transport_fw, 2);
			m1_bus_targ_socket_tagged[2].register_b_transport(this, &M1_Bus::b_transport, 2);

			SC_THREAD(M1_Bus_Request_Thread);
			SC_THREAD(M1_Bus_Request_Thread_Dma);
			//SC_THREAD(M1_Bus_Response_Thread);
			SC_THREAD(M1_Dma_Request_Thread);
			SC_THREAD(M1_Dma_Response_Thread);
		}

		~M1_Bus()
		{
			delete m1_section_desc[M1_MEM];
			delete m1_section_desc[M1_RES1];
			delete m1_section_desc[M1_BIU];
			delete m1_section_desc[M1_ICU];
			delete m1_section_desc[M1_DMU];
			delete m1_section_desc[M1_DMA];
			delete m1_section_desc[M1_RES2];
		}

	private:
		void M1_Bus_Request_Thread()
		{
			trans_extension *ext_ptr = NULL;
			tlm::tlm_generic_payload *trans_ptr;
			tlm::tlm_phase phase = tlm::BEGIN_REQ;
			sc_core::sc_time t = sc_core::SC_ZERO_TIME;
			sc_dt::uint64 addr;
			unsigned int len;
			unsigned int dmu_flag;

			while(true) {
				wait(m1_mem_RequestPEQ.get_event());
				wait(soc_core_req_event[core_id]);
				wait(sc_core::SC_ZERO_TIME);
				dmu_flag = 0;
				while(true) {
					trans_ptr = m1_mem_RequestPEQ.get_next_transaction(); 
					if (trans_ptr == NULL) {
						modify_other_core_delay_time(core_id, M1_RANGE);
//add by liuge			clear_self_soc_profile_table(core_id);
						if (dmu_flag & (1 << CORE0_ID)) {
							notify_core_finish(CORE0_ID, M1_RANGE);
						} 

						if (dmu_flag & (1 << CORE1_ID)) {
							notify_core_finish(CORE1_ID, M1_RANGE);
						} 

						if (dmu_flag & (1 << CORE2_ID)) {
							notify_core_finish(CORE2_ID, M1_RANGE);
						} 

						if (dmu_flag & (1 << CORE3_ID)) {
							notify_core_finish(CORE3_ID, M1_RANGE);
						} 

						if (dmu_flag == 0) {
							notify_core_finish(core_id, M1_RANGE);
						}
						break;
					} else {
						trans_ptr->get_extension(ext_ptr);
						addr = trans_ptr->get_address();
						len = trans_ptr->get_data_length();

						//wait_generic_delay(ext_ptr->inst_core_range);
						generate_generic_delay(ext_ptr->inst_core_range);
						generate_inst_bank_contention(ext_ptr->inst_core_range);
						generate_core_delay(ext_ptr->inst_core_range);
						//wait_inst_delay(ext_ptr->inst_core_range);
						//wait_core_delay(ext_ptr->inst_core_range);
						
						if (addr_valid(addr, len)) {	// internel m1 mem space
							Dmem_m1_access(trans_ptr);
						} 
#ifdef C2CC
						else if ((addr >= c2cc_base) && (addr + len) < (c2cc_base + c2cc_size)) { //internal c2cc mem space
							c2cc_init_socket->nb_transport_fw(*trans_ptr, phase, t);
						}
#endif

					}

					if (GET_INST(ext_ptr->inst_core_range) > INST_IF) { //it's DMU INST 
							dmu_flag |= 1 << GET_CORE(ext_ptr->inst_core_range);
					}
					tlm::tlm_phase phase = tlm::BEGIN_RESP;
					PendingTransactionsIterator it = mPendingTransactions_Core.find(trans_ptr);
					//m1_bus_targ_socket_tagged[it->second.from]->nb_transport_bw(*trans_ptr, phase, t);
					mPendingTransactions_Core.erase(it);
				}
			}
		}

		void M1_Bus_Request_Thread_Dma()
		{
			trans_extension *ext_ptr = NULL;
			tlm::tlm_generic_payload *trans_ptr;
			tlm::tlm_phase phase = tlm::BEGIN_REQ;
			sc_core::sc_time t = sc_core::SC_ZERO_TIME;
			sc_dt::uint64 addr;
			unsigned int len;

			while(true) {
				wait(m1_mem_RequestPEQ_Dma.get_event());
				while(true) {
					trans_ptr = m1_mem_RequestPEQ_Dma.get_next_transaction(); 
					if (trans_ptr == NULL) {
						break;
					} else {
						trans_ptr->get_extension(ext_ptr);
						addr = trans_ptr->get_address();
						len = trans_ptr->get_data_length();

						if (addr_valid(addr, len)) {	// internel m1 mem space
							Dmem_m1_access(trans_ptr);
						} 
#ifdef C2CC
						else if ((addr >= c2cc_base) && (addr + len) < (c2cc_base + c2cc_size)) { //internal c2cc mem space
							c2cc_init_socket->nb_transport_fw(*trans_ptr, phase, t);
						}
#endif

					}
					tlm::tlm_phase phase = tlm::BEGIN_RESP;
					PendingTransactionsIterator it = mPendingTransactions_Dma.find(trans_ptr);
					m1_bus_targ_socket_tagged[it->second.from]->nb_transport_bw(*trans_ptr, phase, t);
					mPendingTransactions_Dma.erase(it);
				}
			}
		}

		//void M1_Bus_Response_Thread()
		//{
		//	tlm::tlm_sync_enum ret;
		//	tlm::tlm_generic_payload * trans_ptr;
		//	tlm::tlm_phase phase = tlm::BEGIN_RESP;
		//	sc_core::sc_time t = sc_core::SC_ZERO_TIME;

		//	while (true) {
		//		wait(m1_mem_ResponsePEQ.get_event());
		//		trans_ptr = m1_mem_ResponsePEQ.get_next_transaction();
		//		PendingTransactionsIterator it = mPendingTransactions.find(trans_ptr);
		//		ret = m1_bus_targ_socket->nb_transport_bw(*trans_ptr, phase, t);
		//		mPendingTransactions.erase(it);
		//	}
		//}


		tlm::tlm_sync_enum nb_transport_fw(int id, tlm::tlm_generic_payload & trans, 
						tlm::tlm_phase & phase, sc_core::sc_time & t)
		{
			trans_extension *ext_ptr;
			sc_dt::uint64 addr;
			unsigned int len;
			unsigned int i;

			if (phase == tlm::BEGIN_REQ) {
				addr = trans.get_address();
				len = trans.get_data_length();
				trans.get_extension(ext_ptr);

				if (ext_ptr != NULL) {
					for (i = 0; i < m1_mem_bank_num; i++) {
						if ((addr >= (m1_mem_base + i*m1_mem_bank_size)) && ((addr + len) < (m1_mem_base + (i+1)*m1_mem_bank_size))) {
							generate_inst_table(ext_ptr->inst_core_range, (int)i, sc_core::sc_time_stamp().to_double(),
											trans.get_command());
							break;
						}
					}
				}

				switch (id) {
				case 0:
				case 2:
					addPendingTransaction(trans, 0, id);
					m1_mem_RequestPEQ.notify(trans, t);
					break;
				default:
					addPendingTransaction(trans, 0, id);
					m1_mem_RequestPEQ_Dma.notify(trans, t);
					break;
				}

			}

			return tlm::TLM_ACCEPTED;
		}

		//tlm::tlm_sync_enum nb_transport_bw(tlm::tlm_generic_payload & trans,
		//				tlm::tlm_phase & phase, sc_time & delay)
		//{
		//	if (phase == tlm::BEGIN_RESP) {
		//		m1_mem_ResponsePEQ.notfiy(trans, delay);
		//	}
		//	return tlm::TLM_COMPLETED;
		//}

		void b_transport(int id, tlm::tlm_generic_payload & trans, sc_time & delay)
		{
			unsigned int range = 100;
			tlm::tlm_command cmd = trans.get_command();
			sc_dt::uint64 addr = trans.get_address();
			unsigned char *ptr = trans.get_data_ptr();
			unsigned int len = trans.get_data_length();

			if (addr_valid(addr, len)) {										// internel m1 mem space
				if (cmd == tlm::TLM_READ_COMMAND) {
					if (m1_section_desc[M1_MEM]->addr_valid(addr, len))			// local m1 mem space
						memcpy(ptr, &dmem_m1_mem[addr - m1_mem_base], len);

					if (m1_section_desc[M1_RES1]->addr_valid(addr, len))		// local res1 mem space
						range = M1_RES1;

					if (m1_section_desc[M1_BIU]->addr_valid(addr, len))			// local biu mem space
						memcpy(ptr, (unsigned char *)&biu_regs[(addr - m1_section_desc[M1_BIU]->start_address) >> 2], len);

					if (m1_section_desc[M1_ICU]->addr_valid(addr, len))			// local icu mem space
						memcpy(ptr, (unsigned char *)&icu_regs[(addr - m1_section_desc[M1_ICU]->start_address) >> 2], len);

					if (m1_section_desc[M1_DMU]->addr_valid(addr, len))			// local dmu mem space
						memcpy(ptr, (unsigned char *)&dmu_regs[(addr - m1_section_desc[M1_DMU]->start_address) >> 2], len);

					if (m1_section_desc[M1_DMA]->addr_valid(addr, len))			// local dma mem space
						memcpy(ptr, (unsigned char *)&dma_regs[(addr - m1_section_desc[M1_DMA]->start_address) >> 2], len);

					if (m1_section_desc[M1_RES2]->addr_valid(addr, len))		// local res2 mem space
						range = M1_RES2;
				} else {
					if (m1_section_desc[M1_MEM]->addr_valid(addr, len))			// local m1 mem space
						memcpy(&dmem_m1_mem[addr - m1_mem_base], ptr, len);

					if (m1_section_desc[M1_RES1]->addr_valid(addr, len))		// local res1 mem space
						range = M1_RES1;

					if (m1_section_desc[M1_BIU]->addr_valid(addr, len))			// local biu mem space
						memcpy((unsigned char *)&biu_regs[(addr - m1_section_desc[M1_BIU]->start_address) >> 2], ptr, len);

					if (m1_section_desc[M1_ICU]->addr_valid(addr, len))			// local icu mem space
						memcpy((unsigned char *)&icu_regs[(addr - m1_section_desc[M1_ICU]->start_address) >> 2], ptr, len);

					if (m1_section_desc[M1_DMU]->addr_valid(addr, len))			// local dmu mem space
						memcpy((unsigned char *)&dmu_regs[(addr - m1_section_desc[M1_DMU]->start_address) >> 2], ptr, len);

					if (m1_section_desc[M1_DMA]->addr_valid(addr, len)) {		// local dma mem space
						memcpy((unsigned char *)&dma_regs[(addr - m1_section_desc[M1_DMA]->start_address) >> 2], ptr, len);
					}

					if (m1_section_desc[M1_RES2]->addr_valid(addr, len))		// local res2 mem space
						range = M1_RES2;
				}
				trans.set_response_status(tlm::TLM_OK_RESPONSE);
			}
#ifdef C2CC
			else if ((addr >= (c2cc_base + core_id * 0x1000))					// c2cc space
				 && ((addr + len) < (c2cc_base + (core_id + 1) * 0x1000))) {
				c2cc_init_socket->b_transport(trans, delay);
			}
#endif
		}

		
		tlm::tlm_sync_enum dma_nb_transport_bw(tlm::tlm_generic_payload & trans,
						tlm::tlm_phase & phase, sc_time & delay)
		{
			if (phase == tlm::BEGIN_RESP)
					m1_dma_ResponsePEQ.notify(trans, delay);

			return tlm::TLM_COMPLETED;
		}

		void M1_Dma_Request_Thread()
		{
			unsigned int dmaen;
			unsigned int len;
			int ret;
			int m1_dmanum;

			while (true) {
				wait(m1_dma_Request);

				while (true) {
					dmaen = 0;
					len = 0;
					for (m1_dmanum = 0; m1_dmanum < 4; m1_dmanum++) {
						if (dma_regs[(M1_DMACLR0 + 0x40 * m1_dmanum) >> 2] & 0x1) {
							dmu_regs[DMU_DMASTAT >> 2] = (dmu_regs[DMU_DMASTAT >> 2] & ~(0xF << m1_dmanum * 4));
							dma_regs[(M1_DMACLR0 + 0x40 * m1_dmanum) >> 2] = 0;
						}
						dmaen = (dma_regs[(M1_DMAEN0 + 0x40 * m1_dmanum) >> 2] & 0x1);
						len = (dma_regs[(M1_DMACTL0 + 0x40 * m1_dmanum) >> 2] & 0xfffff000) >> 12;
						if ((dmaen == DMAEN_ENABLE) && ((dmu_regs[DMU_DMASTAT >> 2] & (0x1 << m1_dmanum * 4)) == 0)) {
							break;
						}
					}

					if ((dmaen != DMAEN_ENABLE))
						break;

					tlm::tlm_generic_payload * trans = new tlm::tlm_generic_payload();
					tlm::tlm_phase phase = tlm::BEGIN_REQ;
					sc_core::sc_time delay = sc_core::SC_ZERO_TIME;
					dma_regs[(M1_DMAEN0 + 0x40 * m1_dmanum) >> 2] = DMAEN_WORKING;

					ret = m1_dma_process(*trans, m1_dmanum);

					if (ret) {
						dmu_regs[DMU_DMASTAT >> 2] |= 0x3 << (m1_dmanum * 4);
						dma_regs[(M1_DMAEN0 + 0x40 * m1_dmanum) >> 2] = DMAEN_IDLE;
					}
				}
			}
		}

		void M1_Dma_Response_Thread()
		{
			tlm::tlm_generic_payload * trans_ptr;
			tlm::tlm_phase phase = tlm::BEGIN_REQ;
			sc_core::sc_time delay = sc_core::SC_ZERO_TIME;
			dma_extension *ext_ptr;
			sc_dt::uint64 addr;
			unsigned int *p;

			while (true) {
				wait(m1_dma_ResponsePEQ.get_event());

				while (true) {
					trans_ptr = m1_dma_ResponsePEQ.get_next_transaction();
					if (trans_ptr == NULL) {
						break;
					}
					trans_ptr->get_extension(ext_ptr);

					if (trans_ptr->get_response_status() != tlm::TLM_OK_RESPONSE)
						dmu_regs[DMU_DMASTAT >> 2] |= 0x3 << (ext_ptr->ch_num * 4);

					if (dma_regs[(M1_DMACTL0 + 0x40 * ext_ptr->ch_num) >> 2] & 0x800) {
						addr = dma_regs[(M1_DMALLST0 + 0x40 * ext_ptr->ch_num) >> 2] & 0xfffff;
						if (addr >= m1_mem_size) {
							dmu_regs[DMU_DMASTAT >> 2] |= 0x7 << (ext_ptr->ch_num * 4);
							dma_regs[(M1_DMAEN0 + 0x40 * ext_ptr->ch_num) >> 2] = DMAEN_IDLE;
							delete trans_ptr;
							continue;
						}

						p = (unsigned int *)&dmem_m1_mem[addr];
						unsigned int m1_dma_llst = dma_regs[(M1_DMALLST0 + 0x40 * ext_ptr->ch_num) >> 2];
//it's for M1 spec 1.4
						if (m1_dma_llst & 0x80000000)
							dma_regs[(M1_DMASAR0 + 0x40 * ext_ptr->ch_num) >> 2] = *p++;

						if (m1_dma_llst & 0x40000000)
							dma_regs[(M1_DMADAR0 + 0x40 * ext_ptr->ch_num) >> 2] = *p++;
	
						if (m1_dma_llst & 0x20000000)
							dma_regs[(M1_DMASGR0 + 0x40 * ext_ptr->ch_num) >> 2] = *p++;

						if (m1_dma_llst & 0x10000000)
							dma_regs[(M1_DMADSR0 + 0x40 * ext_ptr->ch_num) >> 2] = *p++;

						if (m1_dma_llst & 0x8000000)
							dma_regs[(M1_DMACTL0 + 0x40 * ext_ptr->ch_num) >> 2] = *p++;

						if (m1_dma_llst & 0x4000000)
							dma_regs[(M1_DMALLST0 + 0x40 * ext_ptr->ch_num) >> 2] = *p;

						if (m1_dma_llst & 0x2000000)
							dma_regs[(M1_DMAPDCTL0 + 0x40 * ext_ptr->ch_num) >> 2] = *p++;
	
						if (m1_dma_llst & 0x1000000)
							dma_regs[(M1_DMASHAPE0 + 0x40 * ext_ptr->ch_num) >> 2] = *p++;

						if (m1_dma_llst & 0x800000)
							dma_regs[(M1_DMARES0 + 0x40 * ext_ptr->ch_num) >> 2] = *p++;

						dma_regs[(M1_DMAEN0 + 0x40 * ext_ptr->ch_num) >> 2] = DMAEN_ENABLE;
						dmu_regs[DMU_DMASTAT >> 2] &= ~(0x1 << (ext_ptr->ch_num * 4));
						m1_dma_Request.notify();
					} else {
						dma_regs[(M1_DMAEN0 + 0x40 * ext_ptr->ch_num) >> 2] = DMAEN_IDLE;
						dmu_regs[DMU_DMASTAT >> 2] &= ~(0x1 << (ext_ptr->ch_num * 4));
						dmu_regs[DMU_DMASTAT >> 2] |= 0x2 << (ext_ptr->ch_num * 4);
					}

					delete trans_ptr;
				}
			}
		}

		int Dmem_m1_access(tlm::tlm_generic_payload *trans_ptr) 
		{
			unsigned int range = 100;
			unsigned int m1_dmanum;
			sc_core::sc_time t = sc_core::SC_ZERO_TIME;
			dma_extension *ext_ptr;

			tlm::tlm_command cmd = trans_ptr->get_command();
			sc_dt::uint64 addr = trans_ptr->get_address();
			unsigned char *ptr = trans_ptr->get_data_ptr();
			unsigned int len = trans_ptr->get_data_length();

			trans_ptr->get_extension(ext_ptr);
			if (!ext_ptr) {
				if (cmd == tlm::TLM_READ_COMMAND) {
					if (m1_section_desc[M1_MEM]->addr_valid(addr, len))			// local m1 mem space
						memcpy(ptr, &dmem_m1_mem[addr - m1_mem_base], len);

					if (m1_section_desc[M1_RES1]->addr_valid(addr, len))		// local res1 mem space
						range = M1_RES1;

					if (m1_section_desc[M1_BIU]->addr_valid(addr, len))			// local biu mem space
						memcpy(ptr, (unsigned char *)&biu_regs[(addr - m1_section_desc[M1_BIU]->start_address) >> 2], len);

					if (m1_section_desc[M1_ICU]->addr_valid(addr, len))			// local icu mem space
						memcpy(ptr, (unsigned char *)&icu_regs[(addr - m1_section_desc[M1_ICU]->start_address) >> 2], len);

					if (m1_section_desc[M1_DMU]->addr_valid(addr, len))			// local dmu mem space
						memcpy(ptr, (unsigned char *)&dmu_regs[(addr - m1_section_desc[M1_DMU]->start_address) >> 2], len);

					if (m1_section_desc[M1_DMA]->addr_valid(addr, len))			// local dma mem space
						memcpy(ptr, (unsigned char *)&dma_regs[(addr - m1_section_desc[M1_DMA]->start_address) >> 2], len);

					if (m1_section_desc[M1_RES2]->addr_valid(addr, len))		// local res2 mem space
						range = M1_RES2;
				} else {
					if (m1_section_desc[M1_MEM]->addr_valid(addr, len))			// local m1 mem space
						memcpy(&dmem_m1_mem[addr - m1_mem_base], ptr, len);

					if (m1_section_desc[M1_RES1]->addr_valid(addr, len))		// local res1 mem space
						range = M1_RES1;

					if (m1_section_desc[M1_BIU]->addr_valid(addr, len))			// local biu mem space
						memcpy((unsigned char *)&biu_regs[(addr - m1_section_desc[M1_BIU]->start_address) >> 2], ptr, len);

					if (m1_section_desc[M1_ICU]->addr_valid(addr, len))			// local icu mem space
						memcpy((unsigned char *)&icu_regs[(addr - m1_section_desc[M1_ICU]->start_address) >> 2], ptr, len);

					if (m1_section_desc[M1_DMU]->addr_valid(addr, len))			// local dmu mem space
						memcpy((unsigned char *)&dmu_regs[(addr - m1_section_desc[M1_DMU]->start_address) >> 2], ptr, len);

					if (m1_section_desc[M1_DMA]->addr_valid(addr, len)) {		// local dma mem space
						memcpy((unsigned char *)&dma_regs[(addr - m1_section_desc[M1_DMA]->start_address) >> 2], ptr, len);
						for (m1_dmanum = 0; m1_dmanum < 4; m1_dmanum++) {
							if (addr == M1_DMAEN0 + m1_section_desc[M1_DMA]->start_address + 0x40 * m1_dmanum) {
								*ptr = 1;
								memcpy((unsigned char *)&dma_regs[(addr - m1_section_desc[M1_DMA]->start_address) >> 2], ptr, len);
								m1_dma_Request.notify();
								break;
							}
						}
					}

					if (m1_section_desc[M1_RES2]->addr_valid(addr, len))		// local res2 mem space
						range = M1_RES2;
				}
			} else
				dma_operation(trans_ptr, t);
			return true;
		}

		// 1 = valid, 0 = invalid
		int addr_valid(unsigned int start, unsigned int len)
		{
			if ((start >= m1_mem_base) && ((start + len) < (m1_mem_base + m1_mem_size))) {
				if ((start + len) > m1_mem_base)
					return true;
			}

			if ((start >= m1_res1_base) && ((start + len) < (m1_res1_base + m1_res1_size))) {
				if ((start + len) > m1_res1_base)
					return true;
			}

			if ((start >= m1_biu_base) && ((start + len) < (m1_biu_base + m1_biu_size))) {
				if ((start + len) > m1_biu_base)
					return true;
			}

			if ((start >= m1_icu_base) && ((start + len) < (m1_icu_base + m1_icu_size))) {
				if ((start + len) > m1_icu_base)
					return true;
			}

			if ((start >= m1_dmu_base) && ((start + len) < (m1_dmu_base + m1_dmu_size))) {
				if ((start + len) > m1_dmu_base)
					return true;
			}

			if ((start >= m1_dma_base) && ((start + len) < (m1_dma_base + m1_dma_size))) {
				if ((start + len) > m1_dma_base)
					return true;
			}

			if ((start >= m1_res2_base) && ((start + len) < (m1_res2_base + m1_res2_size))) {
				if ((start + len) > m1_res2_base)
					return true;
			}

			return false;
		}

	private:
		void addPendingTransaction(tlm::tlm_generic_payload & trans, int to, int initiatorId)
		{
			const ConnectionInfo info = { initiatorId, to };
			switch (initiatorId) {
			case 0:
			case 2:
				assert(mPendingTransactions_Core.find(&trans) == mPendingTransactions_Core.end());
				mPendingTransactions_Core[&trans] = info;
				break;
			default:
				assert(mPendingTransactions_Dma.find(&trans) == mPendingTransactions_Dma.end());
				mPendingTransactions_Dma[&trans] = info;
				break;
			}
		}

		struct ConnectionInfo {
			int from;
			int to;
		};

		typedef std::map < tlm::tlm_generic_payload *, ConnectionInfo > PendingTransactions;
		typedef PendingTransactions::iterator PendingTransactionsIterator;

		PendingTransactions mPendingTransactions_Core;
		PendingTransactions mPendingTransactions_Dma;

// dma out
		int m1_dma_process(tlm::tlm_generic_payload &trans, unsigned int m1_dmanum);
		int m1_dma_int2ext(tlm::tlm_generic_payload &trans, unsigned int m1_dmanum);
		int m1_dma_shape(tlm::tlm_generic_payload &trans, unsigned int m1_dmanum);
		int m1_dma_fifo(tlm::tlm_generic_payload &trans, unsigned int m1_dmanum);
		int m1_dma_sc(tlm::tlm_generic_payload &trans, unsigned int m1_dmanum);

//dma in
		void dma_operation(tlm::tlm_generic_payload *trans_ptr, sc_core::sc_time &delay);
		void extend_memcpy(unsigned char *dst, unsigned char *src, unsigned int len);
		void zone_memcpy_x0y0(tlm::tlm_generic_payload *trans_ptr);
		void zone_memcpy_x0y1(tlm::tlm_generic_payload *trans_ptr);
		void zone_memcpy_x1y0(tlm::tlm_generic_payload *trans_ptr);
		void zone_memcpy_x1y1(tlm::tlm_generic_payload *trans_ptr);
		void zone_memcpy_x0(tlm::tlm_generic_payload *trans_ptr);
		void zone_memcpy_x1(tlm::tlm_generic_payload *trans_ptr);
		void zone_memcpy_y0(tlm::tlm_generic_payload *trans_ptr);
		void zone_memcpy_y1(tlm::tlm_generic_payload *trans_ptr);
		void zone_memcpy_direct(tlm::tlm_generic_payload *trans_ptr);
		void dma_shape_operation(tlm::tlm_generic_payload *trans_ptr, sc_core::sc_time &delay);
		void padding_operation_x0y0(tlm::tlm_generic_payload *trans_ptr, sc_core::sc_time &delay);
		void padding_operation_x0y1(tlm::tlm_generic_payload *trans_ptr, sc_core::sc_time &delay);
		void padding_operation_x1y0(tlm::tlm_generic_payload *trans_ptr, sc_core::sc_time &delay);
		void padding_operation_x1y1(tlm::tlm_generic_payload *trans_ptr, sc_core::sc_time &delay);
		void padding_operation_x0(tlm::tlm_generic_payload *trans_ptr, sc_core::sc_time &delay);
		void padding_operation_x1(tlm::tlm_generic_payload *trans_ptr, sc_core::sc_time &delay);
		void padding_operation_y0(tlm::tlm_generic_payload *trans_ptr, sc_core::sc_time &delay);
		void padding_operation_y1(tlm::tlm_generic_payload *trans_ptr, sc_core::sc_time &delay);
		void dma_direct_operation(tlm::tlm_generic_payload *trans_ptr, sc_core::sc_time &delay);
		void dma_sc_operation(tlm::tlm_generic_payload *trans_ptr, sc_core::sc_time &delay);
		void dma_fifo_operation(tlm::tlm_generic_payload *trans_ptr, sc_core::sc_time &delay);
#endif
};

#endif
