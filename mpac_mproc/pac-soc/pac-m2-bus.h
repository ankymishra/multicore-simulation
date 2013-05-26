#ifndef PAC_M2_BUS_H_INCLUDED
#define PAC_M2_BUS_H_INCLUDED

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
#include "m2-dma-def.h"
#include "dma.h"

/* M1 subsystem	mmap space define */
// M2 (Data Memory)     0x25000000  0x800000
// DMU              0x25810000  0x10000
// DMA              0x25820000  0x10000

#define	M2_MEM 	0
#define	M2_DMU 	1
#define M2_DMA 	2

extern sc_core::sc_event soc_core_req_event[DSPNUM]; // 4 core request event
extern int soc_core_req_bit_mask[DSPNUM]; //m1 m2 ddr finish bit mask

class M2_Section_Desc {
	public:
		M2_Section_Desc(unsigned int start_address, int length, int flag, unsigned char *p)
			:start_address(start_address)
			, length(length)
			, flag(flag)
			, p(p) 
		{
		}

		~M2_Section_Desc()
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

struct M2_Bus:public sc_core::sc_module, public pac_bus
{
	private:
		struct sim_arg *multi_sim_arg;
		unsigned char *dmem_m2_mem;
		unsigned int *m2_dmu;
		unsigned int *m2_dma;

		unsigned int m2_mem_base, m2_mem_size;
		unsigned int m2_mem_bank_size, m2_mem_bank_num;
		unsigned int m2_dmu_base, m2_dmu_size;
		unsigned int m2_dma_base, m2_dma_size;

		unsigned int m2_dmanum;
		M2_Section_Desc *m2_section_desc[3];

	public:
		tlm_utils::simple_target_socket_tagged < M2_Bus > m2_bus_targ_socket_tagged[DSPNUM + 1];//connect to core_bus dma_bus
		tlm_utils::simple_initiator_socket < M2_Bus > dma_bus_init_socket; 						//connect to dma_bus

		tlm_utils::peq_with_get < tlm::tlm_generic_payload > m2_mem_RequestPEQ;
		//tlm_utils::peq_with_get < tlm::tlm_generic_payload > m2_mem_ResponsePEQ;
		tlm_utils::peq_with_get < tlm::tlm_generic_payload > m2_dma_ResponsePEQ;

		sc_core::sc_event m2_dma_Request;

		SC_HAS_PROCESS(M2_Bus);

	public:
		M2_Bus(sc_module_name _name, struct sim_arg *arg)
		:sc_core::sc_module(_name)
		, multi_sim_arg(arg)
		, dma_bus_init_socket("dma_bus_init_socket")
		, m2_mem_RequestPEQ("m2_mem_RequestPEQ")
		, m2_dma_ResponsePEQ("m2_dma_ResponsePEQ")
		{
			m2_mem_base = multi_arg(m2_mem, dmem_m2_base);
			m2_dmu_base = multi_arg(m2_dmu, m2_dmu_base);
			m2_dma_base = multi_arg(m2_dma, m2_dma_base);

			m2_mem_size = multi_arg(m2_mem, dmem_m2_size);
			m2_mem_bank_size = multi_arg(m2_mem, dmem_m2_bank_size);
			m2_mem_bank_num = m2_mem_size / m2_mem_bank_size;

			m2_dmu_size = multi_arg(m2_dmu, m2_dmu_size);
			m2_dma_size = multi_arg(m2_dma, m2_dma_size);
			dmem_m2_mem = (unsigned char *)multi_arg(shm_ptr, m2_ptr);
			m2_dmu = (unsigned int *)multi_arg(shm_ptr, m2_ptr) + (m2_dmu_base - m2_mem_base) / 4;
			m2_dma = (unsigned int *)multi_arg(shm_ptr, m2_ptr) + (m2_dma_base - m2_mem_base) / 4;

			memset(dmem_m2_mem, 0, m2_mem_size);
			memset(m2_dmu, 0, m2_dmu_size / 4);
			memset(m2_dma, 0, m2_dma_size / 4);

			m2_dma[M2_DMASTAT >> 2] = 0x22222222;	//DMA STATUS Reg default is done

			for (m2_dmanum = 0; m2_dmanum < 8; m2_dmanum++) {
				m2_dma[(M2_DMASGR0 + m2_dmanum * 0x40) >> 2] = 0x10000;
				m2_dma[(M2_DMADSR0 + m2_dmanum * 0x40) >> 2] = 0x10000;
			}

			m2_section_desc[M2_MEM] = new M2_Section_Desc(m2_mem_base, m2_mem_size, 1, (unsigned char*)dmem_m2_mem);
			m2_section_desc[M2_DMU] = new M2_Section_Desc(m2_dmu_base, m2_dmu_size, 1, (unsigned char*)m2_dmu);
			m2_section_desc[M2_DMA] = new M2_Section_Desc(m2_dma_base, m2_dma_size, 1, (unsigned char*)m2_dma);

			for (unsigned int i = 0; i < (DSPNUM + 1); i++) {
				m2_bus_targ_socket_tagged[i].register_nb_transport_fw(this, &M2_Bus::nb_transport_fw, i);
				m2_bus_targ_socket_tagged[i].register_b_transport(this, &M2_Bus::b_transport, i);
			} 
			
			dma_bus_init_socket.register_nb_transport_bw(this, &M2_Bus::dma_nb_transport_bw);

			SC_THREAD(M2_Bus_Request_Thread);
			//SC_THREAD(M2_Bus_Response_Thread);
			SC_THREAD(M2_Dma_Request_Thread);
			SC_THREAD(M2_Dma_Response_Thread);

		}

		~M2_Bus()
		{
				delete m2_section_desc[M2_MEM];
				delete m2_section_desc[M2_DMU];
				delete m2_section_desc[M2_DMA];
		}

	private:
		void M2_Dma_Request_Thread()
		{
			unsigned int dmaen;
			unsigned int len;
			int ret;
			int m2_dmanum;

			while (true) {
				wait(m2_dma_Request);

				while (true) {
					dmaen = 0;
					len = 0;
					for (m2_dmanum = 0; m2_dmanum < 8; m2_dmanum++) {
						if (m2_dma[(M2_DMACLR0 + 0x40 * m2_dmanum) >> 2] & 0x1) {
							m2_dma[M2_DMASTAT >> 2] = (m2_dma[M2_DMASTAT >> 2] & ~(0xF << m2_dmanum * 4));
							m2_dma[(M2_DMACLR0 + 0x40 * m2_dmanum) >> 2] = 0;
						}
						dmaen = (m2_dma[(M2_DMAEN0 + 0x40 * m2_dmanum) >> 2] & 0x1);
						len = (m2_dma[(M2_DMACTL0 + 0x40 * m2_dmanum) >> 2] & 0xfffff000) >> 12;
						if ((dmaen == DMAEN_ENABLE) && ((m2_dma[M2_DMASTAT >> 2] & (0x1 << m2_dmanum * 4)) == 0))
							break;
					}

					if ((dmaen != DMAEN_ENABLE))
						break;

					tlm::tlm_generic_payload *trans = new tlm::tlm_generic_payload();
					tlm::tlm_phase phase = tlm::BEGIN_REQ;
					sc_core::sc_time delay = sc_core::SC_ZERO_TIME;

					m2_dma[(M2_DMAEN0 + 0x40 * m2_dmanum) >> 2] = DMAEN_WORKING;
					ret = m2_dma_process(*trans, m2_dmanum);
					if (ret) {
						m2_dma[M2_DMASTAT >> 2] |= 0x3 << (m2_dmanum * 4);
						m2_dma[(M2_DMAEN0 + 0x40 * m2_dmanum) >> 2] = DMAEN_IDLE;
					}
				}
			}
		}

		void M2_Dma_Response_Thread()
		{
			tlm::tlm_generic_payload trans;
			tlm::tlm_phase phase = tlm::BEGIN_REQ;
			tlm::tlm_generic_payload * trans_ptr;
			sc_core::sc_time delay = sc_core::SC_ZERO_TIME;
			dma_extension *ext_ptr;
			sc_dt::uint64 addr;
			unsigned int *p;

			while (true) {
				wait(m2_dma_ResponsePEQ.get_event());
				trans_ptr = m2_dma_ResponsePEQ.get_next_transaction();
				trans_ptr->get_extension(ext_ptr);

				if (trans_ptr->get_response_status() != tlm::TLM_OK_RESPONSE)
					m2_dma[M2_DMASTAT >> 2] |= 0x3 << (ext_ptr->ch_num * 4);

				if (m2_dma[(M2_DMACTL0 + 0x40 * ext_ptr->ch_num) >> 2] & 0x800) {
					addr = m2_dma[(M2_DMALLST0 + 0x40 * ext_ptr->ch_num) >> 2] & 0xfffff;
					if (addr >= m2_mem_size) {
						m2_dma[M2_DMASTAT >> 2] |= 0x7 << (ext_ptr->ch_num * 4);
						m2_dma[(M2_DMAEN0 + 0x40 * ext_ptr->ch_num) >> 2] = DMAEN_IDLE;
						delete trans_ptr;
						continue;
					}

					p = (unsigned int*)&dmem_m2_mem[addr];
					unsigned int m2_dma_llst = m2_dma[(M2_DMALLST0 + 0x40 * ext_ptr->ch_num) >> 2];
//it's for M2 spce 1.4          
					if (m2_dma_llst & 0x80000000)
						m2_dma[(M2_DMASAR0 + 0x40 * ext_ptr->ch_num) >> 2] = *p++;

					if (m2_dma_llst & 0x40000000)
						m2_dma[(M2_DMADAR0 + 0x40 * ext_ptr->ch_num) >> 2] = *p++;

					if (m2_dma_llst & 0x20000000)
						m2_dma[(M2_DMASGR0 + 0x40 * ext_ptr->ch_num) >> 2] = *p++;

					if (m2_dma_llst & 0x10000000)
						m2_dma[(M2_DMADSR0 + 0x40 * ext_ptr->ch_num) >> 2] = *p++;

					if (m2_dma_llst & 0x8000000)
						m2_dma[(M2_DMACTL0 + 0x40 * ext_ptr->ch_num) >> 2] = *p++;

					if (m2_dma_llst & 0x4000000)
						m2_dma[(M2_DMALLST0 + 0x40 * ext_ptr->ch_num) >> 2] = *p++;

					if (m2_dma_llst & 0x2000000)
						m2_dma[(M2_DMAPDCTL0 + 0x40 * ext_ptr->ch_num) >> 2] = *p++;

					if (m2_dma_llst & 0x1000000)
						m2_dma[(M2_DMASHAPE0 + 0x40 * ext_ptr->ch_num) >> 2] = *p++;

					if (m2_dma_llst & 0x800000)
						m2_dma[(M2_DMARES0 + 0x40 * ext_ptr->ch_num) >> 2] = *p;

					m2_dma[(M2_DMAEN0 + 0x40 * ext_ptr->ch_num) >> 2] = DMAEN_ENABLE;
					m2_dma[M2_DMASTAT >> 2] &= ~(0x1 << (ext_ptr->ch_num * 4));
					m2_dma_Request.notify();
				} else {
					m2_dma[(M2_DMAEN0 + 0x40 * ext_ptr->ch_num) >> 2] = DMAEN_IDLE;
					m2_dma[M2_DMASTAT >> 2] |= 0x2 << (ext_ptr->ch_num * 4);
					m2_dma[M2_DMASTAT >> 2] &= ~(0x1 << (ext_ptr->ch_num * 4));
				}

				delete trans_ptr;
			}
		}

		void M2_Bus_Request_Thread()
		{
			trans_extension *ext_ptr;
			tlm::tlm_sync_enum ret;
			tlm::tlm_generic_payload *trans_ptr;
			tlm::tlm_phase phase = tlm::BEGIN_REQ;
			sc_core::sc_time t = sc_core::SC_ZERO_TIME;
			sc_dt::uint64 addr;
			unsigned int len;

			while (true) {
				wait(m2_mem_RequestPEQ.get_event());
				while (true) {
					trans_ptr = m2_mem_RequestPEQ.get_next_transaction();
					if (trans_ptr == NULL)
						break;

					trans_ptr->get_extension(ext_ptr);
					addr = trans_ptr->get_address();
					len = trans_ptr->get_data_length();

					if (addr_valid(addr, len)) {	// internel m2 mem space
						Dmem_m2_access(trans_ptr);
						tlm::tlm_phase phase = tlm::BEGIN_RESP;
						trans_ptr->set_response_status(tlm::TLM_OK_RESPONSE);
						PendingTransactionsIterator it = mPendingTransactions.find(trans_ptr);
						ret = m2_bus_targ_socket_tagged[it->second.from]->nb_transport_bw(*trans_ptr, phase, t);
						mPendingTransactions.erase(it);
					} 
				}
			}
		}

		//void M2_Bus_Response_Thread()
		//{
		//	tlm::tlm_sync_enum ret;
		//	tlm::tlm_generic_payload * trans_ptr;
		//	tlm::tlm_phase phase = tlm::BEGIN_RESP;
		//	sc_core::sc_time t = sc_core::SC_ZERO_TIME;

		//	while (true) {
		//		wait(m2_mem_ResponsePEQ.get_event());
		//		trans_ptr = m2_mem_ResponsePEQ.get_next_transaction();
		//		PendingTransactionsIterator it = mPendingTransactions.find(trans_ptr);
		//		ret = m2_bus_targ_socket_tagged[it->second.from]->nb_transport_bw(*trans_ptr, phase, t);
		//		mPendingTransactions.erase(it);
		//	}
		//}

		tlm::tlm_sync_enum nb_transport_fw(int id, tlm::tlm_generic_payload &trans, 
						tlm::tlm_phase & phase, sc_core::sc_time & t)
		{
			if (phase == tlm::BEGIN_REQ) {
				addPendingTransaction(trans, 0, id);
				m2_mem_RequestPEQ.notify(trans, t);
			}

			return tlm::TLM_ACCEPTED;
		}


		//tlm::tlm_sync_enum nb_transport_bw(int portId, tlm::tlm_generic_payload &trans, 
		//				tlm::tlm_phase & phase, sc_core::sc_time & t)
		//{
		//	if (phase == tlm::BEGIN_RESP) {
		//		m2_mem_ResponsePEQ.notfiy(trans, t);
		//	}
		//	return tlm::TLM_ACCEPTED;
		//}


		void b_transport(int id, tlm::tlm_generic_payload & trans, sc_time & t)
		{
			tlm::tlm_command cmd = trans.get_command();
			sc_dt::uint64 addr = trans.get_address();
			unsigned char *ptr = trans.get_data_ptr();
			unsigned int len = trans.get_data_length();

			if (addr_valid(addr, len)) {						// internel m2 mem space
				if (cmd == tlm::TLM_READ_COMMAND) {
					if (m2_section_desc[M2_MEM]->addr_valid(addr, len)) {
						memcpy(ptr, &dmem_m2_mem[addr - m2_mem_base], len);
					} else if (m2_section_desc[M2_DMU]->addr_valid(addr, len)) {
						memcpy(ptr, (unsigned char *)&m2_dmu[(addr - m2_dmu_base) >> 2], len);
					} else if (m2_section_desc[M2_DMA]->addr_valid(addr, len)) {
						memcpy(ptr, (unsigned char *)&m2_dma[(addr - m2_dma_base) >> 2], len);
					}
				} else {
					if (m2_section_desc[M2_MEM]->addr_valid(addr, len)) {
						memcpy(&dmem_m2_mem[addr - m2_mem_base], ptr, len);
					} else if (m2_section_desc[M2_DMU]->addr_valid(addr, len)) {
						memcpy((unsigned char *)&m2_dmu[(addr - m2_dmu_base) >> 2], ptr, len);
					} else if (m2_section_desc[M2_DMA]->addr_valid(addr, len)) {
						memcpy((unsigned char *)&m2_dma[(addr - m2_dma_base) >> 2], ptr, len);
					}
				}
			}

			trans.set_response_status(tlm::TLM_OK_RESPONSE);
		}

		tlm::tlm_sync_enum dma_nb_transport_bw(tlm::tlm_generic_payload &trans,
						tlm::tlm_phase & phase, sc_core::sc_time & t)
		{
			if (phase == tlm::BEGIN_RESP) {
				m2_dma_ResponsePEQ.notify(trans, t);
			}
			return tlm::TLM_ACCEPTED;
		}

		// 1 = valid, 0 = invalid
		int addr_valid(unsigned int start, unsigned int len)
		{
			if ((start >= m2_mem_base) && ((start + len) < (m2_mem_base + m2_mem_size))) {
				if ((start + len) > m2_mem_base)
					return true;
			}
		
			if ((start >= m2_dmu_base) && ((start + len) < (m2_dmu_base + m2_dmu_size))) {
				if ((start + len) > m2_dmu_base)
					return true;
			}

			if ((start >= m2_dma_base) && ((start + len) < (m2_dma_base + m2_dma_size))) {
				if ((start + len) > m2_dma_base)
					return true;
			}
			return false;
		}

		int Dmem_m2_access(tlm::tlm_generic_payload *trans_ptr)
		{
			int ret = 1;
			int m2_dmanum;
			sc_core::sc_time t = sc_core::SC_ZERO_TIME;
			dma_extension *ext_ptr;

			tlm::tlm_command cmd = trans_ptr->get_command();
			sc_dt::uint64 addr = trans_ptr->get_address();
			unsigned char *ptr = trans_ptr->get_data_ptr();
			unsigned int len = trans_ptr->get_data_length();

			trans_ptr->get_extension(ext_ptr);
			if (!ext_ptr) {
				if (cmd == tlm::TLM_READ_COMMAND) {
					if (m2_section_desc[M2_MEM]->addr_valid(addr, len)) {
						memcpy(ptr, &dmem_m2_mem[addr - m2_mem_base], len);
					} else if (m2_section_desc[M2_DMU]->addr_valid(addr, len)) {
						memcpy(ptr, (unsigned char *)&m2_dmu[(addr - m2_dmu_base) >> 2], len);
					} else if (m2_section_desc[M2_DMA]->addr_valid(addr, len)) {
						memcpy(ptr, (unsigned char *)&m2_dma[(addr - m2_dma_base) >> 2], len);
					} else
						ret = 0;
				} else {
					if (m2_section_desc[M2_MEM]->addr_valid(addr, len)) {
						memcpy(&dmem_m2_mem[addr - m2_mem_base], ptr, len);
					} else if (m2_section_desc[M2_DMU]->addr_valid(addr, len)) {
						memcpy((unsigned char *)&m2_dmu[(addr - m2_dmu_base) >> 2], ptr, len);
					} else if (m2_section_desc[M2_DMA]->addr_valid(addr, len)) {
						memcpy((unsigned char *)&m2_dma[(addr - m2_dma_base) >> 2], ptr, len);
						for (m2_dmanum = 0; m2_dmanum < 8; m2_dmanum++) {
							if (addr == M2_DMAEN0 + m2_dma_base + 0x40 * m2_dmanum) {
								*ptr = 1;
								memcpy((unsigned char *)&m2_dma[(addr - m2_dma_base) >> 2], ptr, len);
								m2_dma_Request.notify();
								break;
							}
						}
					} else
						ret = 0;
				}
			} else
				dma_operation(trans_ptr, t);

			return ret;
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

	private:
		PendingTransactions mPendingTransactions;
// dma out
		int m2_dma_process(tlm::tlm_generic_payload &trans, unsigned int m2_dmanum);
		int m2_dma_int2ext(tlm::tlm_generic_payload &trans, unsigned int m2_dmanum);
		int m2_dma_shape(tlm::tlm_generic_payload &trans, unsigned int m2_dmanum);
		int m2_dma_fifo(tlm::tlm_generic_payload &trans, unsigned int m2_dmanum);
		int m2_dma_sc(tlm::tlm_generic_payload &trans, unsigned int m2_dmanum);

//dma in
		void dma_operation(tlm::tlm_generic_payload *trans_ptr, sc_core::sc_time &delay);
		void extend_memcpy(unsigned char *dst, unsigned char *src, unsigned int len);
		void zone_memcpy_x0y0(tlm::tlm_generic_payload *trans_ptr);
		void zone_memcpy_x0y1(tlm::tlm_generic_payload *trans_ptr);
		void zone_memcpy_x1y0(tlm::tlm_generic_payload *trans_ptr);
		void zone_memcpy_x1y1(tlm::tlm_generic_payload *trans_ptr);
		void zone_memcpy_direct(tlm::tlm_generic_payload *trans_ptr);
		void zone_memcpy_x0(tlm::tlm_generic_payload *trans_ptr);
		void zone_memcpy_x1(tlm::tlm_generic_payload *trans_ptr);
		void zone_memcpy_y0(tlm::tlm_generic_payload *trans_ptr);
		void zone_memcpy_y1(tlm::tlm_generic_payload *trans_ptr);
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
};

#else //IN PAC_SOC_PROFILE

struct M2_Bus:public sc_core::sc_module, public pac_bus
{
	private:
		struct sim_arg *multi_sim_arg;
		unsigned char *dmem_m2_mem;
		unsigned int *m2_dmu;
		unsigned int *m2_dma;

		unsigned int m2_mem_base, m2_mem_size;
		unsigned int m2_mem_bank_size, m2_mem_bank_num;
		unsigned int m2_dmu_base, m2_dmu_size;
		unsigned int m2_dma_base, m2_dma_size;

		unsigned int m2_dmanum;
		M2_Section_Desc *m2_section_desc[3];

	public:
		tlm_utils::simple_target_socket_tagged < M2_Bus > m2_bus_targ_socket_tagged[DSPNUM + 1];//connect to core_bus dma_bus
		tlm_utils::simple_initiator_socket < M2_Bus > dma_bus_init_socket; 						//connect to dma_bus

		tlm_utils::peq_with_get < tlm::tlm_generic_payload > m2_mem_RequestPEQ_Dma;
		tlm_utils::peq_with_get < tlm::tlm_generic_payload > m2_mem_RequestPEQ_C0;
		tlm_utils::peq_with_get < tlm::tlm_generic_payload > m2_mem_RequestPEQ_C1;
		tlm_utils::peq_with_get < tlm::tlm_generic_payload > m2_mem_RequestPEQ_C2;
		tlm_utils::peq_with_get < tlm::tlm_generic_payload > m2_mem_RequestPEQ_C3;
		//tlm_utils::peq_with_get < tlm::tlm_generic_payload > m2_mem_ResponsePEQ;
		tlm_utils::peq_with_get < tlm::tlm_generic_payload > m2_dma_ResponsePEQ;

		sc_core::sc_event m2_dma_Request;

		SC_HAS_PROCESS(M2_Bus);

	public:
		M2_Bus(sc_module_name _name, struct sim_arg *arg)
		:sc_core::sc_module(_name)
		, multi_sim_arg(arg)
		, dma_bus_init_socket("dma_bus_init_socket")
		, m2_mem_RequestPEQ_Dma("m2_mem_RequestPEQ_Dma")
		, m2_mem_RequestPEQ_C0("m2_mem_RequestPEQ_C0")
		, m2_mem_RequestPEQ_C1("m2_mem_RequestPEQ_C1")
		, m2_mem_RequestPEQ_C2("m2_mem_RequestPEQ_C2")
		, m2_mem_RequestPEQ_C3("m2_mem_RequestPEQ_C3")
		, m2_dma_ResponsePEQ("m2_dma_ResponsePEQ")
		{
			m2_mem_base = multi_arg(m2_mem, dmem_m2_base);
			m2_dmu_base = multi_arg(m2_dmu, m2_dmu_base);
			m2_dma_base = multi_arg(m2_dma, m2_dma_base);

			m2_mem_size = multi_arg(m2_mem, dmem_m2_size);
			m2_mem_bank_size = multi_arg(m2_mem, dmem_m2_bank_size);
			m2_mem_bank_num = m2_mem_size / m2_mem_bank_size;

			m2_dmu_size = multi_arg(m2_dmu, m2_dmu_size);
			m2_dma_size = multi_arg(m2_dma, m2_dma_size);
			dmem_m2_mem = (unsigned char *)multi_arg(shm_ptr, m2_ptr);
			m2_dmu = (unsigned int *)multi_arg(shm_ptr, m2_ptr) + (m2_dmu_base - m2_mem_base) / 4;
			m2_dma = (unsigned int *)multi_arg(shm_ptr, m2_ptr) + (m2_dma_base - m2_mem_base) / 4;

			memset(dmem_m2_mem, 0, m2_mem_size);
			memset(m2_dmu, 0, m2_dmu_size / 4);
			memset(m2_dma, 0, m2_dma_size / 4);

			m2_dma[M2_DMASTAT >> 2] = 0x22222222;	//DMA STATUS Reg default is done

			for (m2_dmanum = 0; m2_dmanum < 8; m2_dmanum++) {
				m2_dma[(M2_DMASGR0 + m2_dmanum * 0x40) >> 2] = 0x10000;
				m2_dma[(M2_DMADSR0 + m2_dmanum * 0x40) >> 2] = 0x10000;
			}

			m2_section_desc[M2_MEM] = new M2_Section_Desc(m2_mem_base, m2_mem_size, 1, (unsigned char*)dmem_m2_mem);
			m2_section_desc[M2_DMU] = new M2_Section_Desc(m2_dmu_base, m2_dmu_size, 1, (unsigned char*)m2_dmu);
			m2_section_desc[M2_DMA] = new M2_Section_Desc(m2_dma_base, m2_dma_size, 1, (unsigned char*)m2_dma);

			for (unsigned int i = 0; i < (DSPNUM + 1); i++) {
				m2_bus_targ_socket_tagged[i].register_nb_transport_fw(this, &M2_Bus::nb_transport_fw, i);
				m2_bus_targ_socket_tagged[i].register_b_transport(this, &M2_Bus::b_transport, i);
			} 
			
			dma_bus_init_socket.register_nb_transport_bw(this, &M2_Bus::dma_nb_transport_bw);

			SC_THREAD(M2_Bus_Request_Thread_Dma);
			SC_THREAD(M2_Bus_Request_Thread_C0);
			SC_THREAD(M2_Bus_Request_Thread_C1);
			SC_THREAD(M2_Bus_Request_Thread_C2);
			SC_THREAD(M2_Bus_Request_Thread_C3);
			//SC_THREAD(M2_Bus_Response_Thread);
			SC_THREAD(M2_Dma_Request_Thread);
			SC_THREAD(M2_Dma_Response_Thread);

		}

		~M2_Bus()
		{
				delete m2_section_desc[M2_MEM];
				delete m2_section_desc[M2_DMU];
				delete m2_section_desc[M2_DMA];
		}

	private:
		void M2_Dma_Request_Thread()
		{
			unsigned int dmaen;
			unsigned int len;
			int ret;
			int m2_dmanum;

			while (true) {
				wait(m2_dma_Request);

				while (true) {
					dmaen = 0;
					len = 0;
					for (m2_dmanum = 0; m2_dmanum < 8; m2_dmanum++) {
						if (m2_dma[(M2_DMACLR0 + 0x40 * m2_dmanum) >> 2] & 0x1) {
							m2_dma[M2_DMASTAT >> 2] = (m2_dma[M2_DMASTAT >> 2] & ~(0xF << m2_dmanum * 4));
							m2_dma[(M2_DMACLR0 + 0x40 * m2_dmanum) >> 2] = 0;
						}
						dmaen = (m2_dma[(M2_DMAEN0 + 0x40 * m2_dmanum) >> 2] & 0x1);
						len = (m2_dma[(M2_DMACTL0 + 0x40 * m2_dmanum) >> 2] & 0xfffff000) >> 12;
						if ((dmaen == DMAEN_ENABLE) && ((m2_dma[M2_DMASTAT >> 2] & (0x1 << m2_dmanum * 4)) == 0))
							break;
					}

					if ((dmaen != DMAEN_ENABLE))
						break;

					tlm::tlm_generic_payload *trans = new tlm::tlm_generic_payload();
					tlm::tlm_phase phase = tlm::BEGIN_REQ;
					sc_core::sc_time delay = sc_core::SC_ZERO_TIME;

					m2_dma[(M2_DMAEN0 + 0x40 * m2_dmanum) >> 2] = DMAEN_WORKING;
					ret = m2_dma_process(*trans, m2_dmanum);
					if (ret) {
						m2_dma[M2_DMASTAT >> 2] |= 0x3 << (m2_dmanum * 4);
						m2_dma[(M2_DMAEN0 + 0x40 * m2_dmanum) >> 2] = DMAEN_IDLE;
					}
				}
			}
		}

		void M2_Dma_Response_Thread()
		{
			tlm::tlm_generic_payload trans;
			tlm::tlm_phase phase = tlm::BEGIN_REQ;
			tlm::tlm_generic_payload * trans_ptr;
			sc_core::sc_time delay = sc_core::SC_ZERO_TIME;
			dma_extension *ext_ptr;
			sc_dt::uint64 addr;
			unsigned int *p;

			while (true) {
				wait(m2_dma_ResponsePEQ.get_event());
				while (true) {
					trans_ptr = m2_dma_ResponsePEQ.get_next_transaction();
					if (trans_ptr == NULL) {
							break;
					}
					trans_ptr->get_extension(ext_ptr);

					if (trans_ptr->get_response_status() != tlm::TLM_OK_RESPONSE)
						m2_dma[M2_DMASTAT >> 2] |= 0x3 << (ext_ptr->ch_num * 4);

					if (m2_dma[(M2_DMACTL0 + 0x40 * ext_ptr->ch_num) >> 2] & 0x800) {
						addr = m2_dma[(M2_DMALLST0 + 0x40 * ext_ptr->ch_num) >> 2] & 0xfffff;
						if (addr >= m2_mem_size) {
							m2_dma[M2_DMASTAT >> 2] |= 0x7 << (ext_ptr->ch_num * 4);
							m2_dma[(M2_DMAEN0 + 0x40 * ext_ptr->ch_num) >> 2] = DMAEN_IDLE;
							delete trans_ptr;
							continue;
						}

						p = (unsigned int*)&dmem_m2_mem[addr];
						unsigned int m2_dma_llst = m2_dma[(M2_DMALLST0 + 0x40 * ext_ptr->ch_num) >> 2];
//it's for M2 spce 1.4          
						if (m2_dma_llst & 0x80000000)
							m2_dma[(M2_DMASAR0 + 0x40 * ext_ptr->ch_num) >> 2] = *p++;
	
						if (m2_dma_llst & 0x40000000)
							m2_dma[(M2_DMADAR0 + 0x40 * ext_ptr->ch_num) >> 2] = *p++;
	
						if (m2_dma_llst & 0x20000000)
							m2_dma[(M2_DMASGR0 + 0x40 * ext_ptr->ch_num) >> 2] = *p++;
	
						if (m2_dma_llst & 0x10000000)
							m2_dma[(M2_DMADSR0 + 0x40 * ext_ptr->ch_num) >> 2] = *p++;
	
						if (m2_dma_llst & 0x8000000)
							m2_dma[(M2_DMACTL0 + 0x40 * ext_ptr->ch_num) >> 2] = *p++;
	
						if (m2_dma_llst & 0x4000000)
							m2_dma[(M2_DMALLST0 + 0x40 * ext_ptr->ch_num) >> 2] = *p++;
	
						if (m2_dma_llst & 0x2000000)
							m2_dma[(M2_DMAPDCTL0 + 0x40 * ext_ptr->ch_num) >> 2] = *p++;
	
						if (m2_dma_llst & 0x1000000)
							m2_dma[(M2_DMASHAPE0 + 0x40 * ext_ptr->ch_num) >> 2] = *p++;
	
						if (m2_dma_llst & 0x800000)
							m2_dma[(M2_DMARES0 + 0x40 * ext_ptr->ch_num) >> 2] = *p;
	
						m2_dma[(M2_DMAEN0 + 0x40 * ext_ptr->ch_num) >> 2] = DMAEN_ENABLE;
						m2_dma[M2_DMASTAT >> 2] &= ~(0x1 << (ext_ptr->ch_num * 4));
						m2_dma_Request.notify();
					} else {
						m2_dma[(M2_DMAEN0 + 0x40 * ext_ptr->ch_num) >> 2] = DMAEN_IDLE;
						m2_dma[M2_DMASTAT >> 2] |= 0x2 << (ext_ptr->ch_num * 4);
						m2_dma[M2_DMASTAT >> 2] &= ~(0x1 << (ext_ptr->ch_num * 4));
					}

					delete trans_ptr;
				}
			}
		}

		void M2_Bus_Request_Thread_Dma()
		{
			trans_extension *ext_ptr = NULL;
			tlm::tlm_sync_enum ret;
			tlm::tlm_generic_payload *trans_ptr;
			tlm::tlm_phase phase = tlm::BEGIN_REQ;
			sc_core::sc_time t = sc_core::SC_ZERO_TIME;
			sc_dt::uint64 addr;
			unsigned int len;

			while (true) {
				wait(m2_mem_RequestPEQ_Dma.get_event());
				while (true) {
					trans_ptr = m2_mem_RequestPEQ_Dma.get_next_transaction();
					if (trans_ptr == NULL) {
						break;
					}
					trans_ptr->get_extension(ext_ptr);
					addr = trans_ptr->get_address();
					len = trans_ptr->get_data_length();

					if (addr_valid(addr, len)) {	// internel m2 mem space
						Dmem_m2_access(trans_ptr);
						tlm::tlm_phase phase = tlm::BEGIN_RESP;
						trans_ptr->set_response_status(tlm::TLM_OK_RESPONSE);
						PendingTransactionsIterator it = mPendingTransactions_Dma.find(trans_ptr);
						ret = m2_bus_targ_socket_tagged[it->second.from]->nb_transport_bw(*trans_ptr, phase, t);
						mPendingTransactions_Dma.erase(it);
					} 
				}
			}
		}


		void M2_Bus_Request_Thread_C0()
		{
			trans_extension *ext_ptr = NULL;
			tlm::tlm_generic_payload *trans_ptr;
			tlm::tlm_phase phase = tlm::BEGIN_REQ;
			sc_core::sc_time t = sc_core::SC_ZERO_TIME;
			sc_dt::uint64 addr;
			unsigned int len;

			while (true) {
				wait(m2_mem_RequestPEQ_C0.get_event());
				wait(soc_core_req_event[CORE0_ID] | soc_core_req_event[CORE1_ID]
					 | soc_core_req_event[CORE2_ID] | soc_core_req_event[CORE3_ID]);
				wait(sc_core::SC_ZERO_TIME);
				while (true) {
					trans_ptr = m2_mem_RequestPEQ_C0.get_next_transaction();
					if (trans_ptr == NULL) {
						modify_other_core_delay_time(CORE0_ID, M2_RANGE);
//add by liuge			clear_self_soc_profile_table(CORE0_ID);
						notify_core_finish(CORE0_ID, M2_RANGE);
						break;
					}
					trans_ptr->get_extension(ext_ptr);
					addr = trans_ptr->get_address();
					len = trans_ptr->get_data_length();

					//wait_generic_delay(ext_ptr->inst_core_range);
					generate_generic_delay(ext_ptr->inst_core_range);
					generate_inst_bank_contention(ext_ptr->inst_core_range);
					generate_core_delay(ext_ptr->inst_core_range);
					//wait_inst_delay(ext_ptr->inst_core_range);
					//wait_core_delay(ext_ptr->inst_core_range);

					if (addr_valid(addr, len)) {	// internel m2 mem space
						Dmem_m2_access(trans_ptr);
						tlm::tlm_phase phase = tlm::BEGIN_RESP;
						trans_ptr->set_response_status(tlm::TLM_OK_RESPONSE);
						PendingTransactionsIterator it = mPendingTransactions_C0.find(trans_ptr);
						//ret = m2_bus_targ_socket_tagged[it->second.from]->nb_transport_bw(*trans_ptr, phase, t);
						mPendingTransactions_C0.erase(it);
					} 
				}
			}
		}

		void M2_Bus_Request_Thread_C1()
		{
			trans_extension *ext_ptr = NULL;
			tlm::tlm_generic_payload *trans_ptr;
			tlm::tlm_phase phase = tlm::BEGIN_REQ;
			sc_core::sc_time t = sc_core::SC_ZERO_TIME;
			sc_dt::uint64 addr;
			unsigned int len;

			while (true) {
				wait(m2_mem_RequestPEQ_C1.get_event());
				wait(soc_core_req_event[CORE0_ID] | soc_core_req_event[CORE1_ID]
					 | soc_core_req_event[CORE2_ID] | soc_core_req_event[CORE3_ID]);
				wait(sc_core::SC_ZERO_TIME);
				while (true) {
					trans_ptr = m2_mem_RequestPEQ_C1.get_next_transaction();
					if (trans_ptr == NULL) {
 						modify_other_core_delay_time(CORE1_ID, M2_RANGE);
//add by liuge			clear_self_soc_profile_table(CORE1_ID);
						notify_core_finish(CORE1_ID, M2_RANGE);
						break;
					}

					trans_ptr->get_extension(ext_ptr);
					addr = trans_ptr->get_address();
					len = trans_ptr->get_data_length();

					//wait_generic_delay(ext_ptr->inst_core_range);
					generate_generic_delay(ext_ptr->inst_core_range);
					generate_inst_bank_contention(ext_ptr->inst_core_range);
					generate_core_delay(ext_ptr->inst_core_range);
					//wait_inst_delay(ext_ptr->inst_core_range);
					//wait_core_delay(ext_ptr->inst_core_range);

					if (addr_valid(addr, len)) {	// internel m2 mem space
						Dmem_m2_access(trans_ptr);
						tlm::tlm_phase phase = tlm::BEGIN_RESP;
						trans_ptr->set_response_status(tlm::TLM_OK_RESPONSE);
						PendingTransactionsIterator it = mPendingTransactions_C1.find(trans_ptr);
						//ret = m2_bus_targ_socket_tagged[it->second.from]->nb_transport_bw(*trans_ptr, phase, t);
						mPendingTransactions_C1.erase(it);
					} 
				}
			}
		}

		void M2_Bus_Request_Thread_C2()
		{
			trans_extension *ext_ptr = NULL;
			tlm::tlm_generic_payload *trans_ptr;
			tlm::tlm_phase phase = tlm::BEGIN_REQ;
			sc_core::sc_time t = sc_core::SC_ZERO_TIME;
			sc_dt::uint64 addr;
			unsigned int len;

			while (true) {
				wait(m2_mem_RequestPEQ_C2.get_event());
				wait(soc_core_req_event[CORE0_ID] | soc_core_req_event[CORE1_ID]
					 | soc_core_req_event[CORE2_ID] | soc_core_req_event[CORE3_ID]);
				wait(sc_core::SC_ZERO_TIME);
				while (true) {
					trans_ptr = m2_mem_RequestPEQ_C2.get_next_transaction();
					if (trans_ptr == NULL) {
 						modify_other_core_delay_time(CORE2_ID, M2_RANGE);
//add by liuge			clear_self_soc_profile_table(CORE2_ID);
						notify_core_finish(CORE2_ID, M2_RANGE);
						break;
					}

					trans_ptr->get_extension(ext_ptr);
					addr = trans_ptr->get_address();
					len = trans_ptr->get_data_length();

					//wait_generic_delay(ext_ptr->inst_core_range);
					generate_generic_delay(ext_ptr->inst_core_range);
					generate_inst_bank_contention(ext_ptr->inst_core_range);
					generate_core_delay(ext_ptr->inst_core_range);
					//wait_inst_delay(ext_ptr->inst_core_range);
					//wait_core_delay(ext_ptr->inst_core_range);
					
					if (addr_valid(addr, len)) {	// internel m2 mem space
						Dmem_m2_access(trans_ptr);
						tlm::tlm_phase phase = tlm::BEGIN_RESP;
						trans_ptr->set_response_status(tlm::TLM_OK_RESPONSE);
						PendingTransactionsIterator it = mPendingTransactions_C2.find(trans_ptr);
						//ret = m2_bus_targ_socket_tagged[it->second.from]->nb_transport_bw(*trans_ptr, phase, t);
						mPendingTransactions_C2.erase(it);
					} 
				}
			}
		}

		void M2_Bus_Request_Thread_C3()
		{
			trans_extension *ext_ptr = NULL;
			tlm::tlm_generic_payload *trans_ptr;
			tlm::tlm_phase phase = tlm::BEGIN_REQ;
			sc_core::sc_time t = sc_core::SC_ZERO_TIME;
			sc_dt::uint64 addr;
			unsigned int len;

			while (true) {
				wait(m2_mem_RequestPEQ_C3.get_event());
				wait(soc_core_req_event[CORE0_ID] | soc_core_req_event[CORE1_ID] 
					 | soc_core_req_event[CORE2_ID] | soc_core_req_event[CORE3_ID]);

				wait(sc_core::SC_ZERO_TIME);
				while (true) {
					trans_ptr = m2_mem_RequestPEQ_C3.get_next_transaction();
					if (trans_ptr == NULL) {
 						modify_other_core_delay_time(CORE3_ID, M2_RANGE);
//add by liuge			clear_self_soc_profile_table(CORE3_ID);
						notify_core_finish(CORE3_ID, M2_RANGE);
						break;
					}

					trans_ptr->get_extension(ext_ptr);
					addr = trans_ptr->get_address();
					len = trans_ptr->get_data_length();

					//wait_generic_delay(ext_ptr->inst_core_range);
					generate_generic_delay(ext_ptr->inst_core_range);
					generate_inst_bank_contention(ext_ptr->inst_core_range);
					generate_core_delay(ext_ptr->inst_core_range);
					//wait_inst_delay(ext_ptr->inst_core_range);
					//wait_core_delay(ext_ptr->inst_core_range);

					if (addr_valid(addr, len)) {	// internel m2 mem space
						Dmem_m2_access(trans_ptr);
						tlm::tlm_phase phase = tlm::BEGIN_RESP;
						trans_ptr->set_response_status(tlm::TLM_OK_RESPONSE);
						PendingTransactionsIterator it = mPendingTransactions_C3.find(trans_ptr);
						//ret = m2_bus_targ_socket_tagged[it->second.from]->nb_transport_bw(*trans_ptr, phase, t);
						mPendingTransactions_C3.erase(it);
					} 
				}
			}
		}

		//void M2_Bus_Response_Thread()
		//{
		//	tlm::tlm_sync_enum ret;
		//	tlm::tlm_generic_payload * trans_ptr;
		//	tlm::tlm_phase phase = tlm::BEGIN_RESP;
		//	sc_core::sc_time t = sc_core::SC_ZERO_TIME;

		//	while (true) {
		//		wait(m2_mem_ResponsePEQ.get_event());
		//		trans_ptr = m2_mem_ResponsePEQ.get_next_transaction();
		//		PendingTransactionsIterator it = mPendingTransactions.find(trans_ptr);
		//		ret = m2_bus_targ_socket_tagged[it->second.from]->nb_transport_bw(*trans_ptr, phase, t);
		//		mPendingTransactions.erase(it);
		//	}
		//}

		tlm::tlm_sync_enum nb_transport_fw(int id, tlm::tlm_generic_payload &trans, 
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
					for (i = 0; i < m2_mem_bank_num; i++) {
						if ((addr >= (m2_mem_base + i*m2_mem_bank_size)) && ((addr + len) < (m2_mem_base + (i+1)*m2_mem_bank_size))) {
							generate_inst_table(ext_ptr->inst_core_range, (int)i, sc_core::sc_time_stamp().to_double(),
												trans.get_command());
							break;
						}
					}
				}

				switch (id) {
				case CORE0_ID:
					addPendingTransaction(trans, 0, id);
					m2_mem_RequestPEQ_C0.notify(trans, t);
					break;
				case CORE1_ID:
					addPendingTransaction(trans, 0, id);
					m2_mem_RequestPEQ_C1.notify(trans, t);
					break;
				case CORE2_ID:
					addPendingTransaction(trans, 0, id);
					m2_mem_RequestPEQ_C2.notify(trans, t);
					break;
				case CORE3_ID:
					addPendingTransaction(trans, 0, id);
					m2_mem_RequestPEQ_C3.notify(trans, t);
					break;
				default:
				    	addPendingTransaction(trans, 0, id);
					m2_mem_RequestPEQ_Dma.notify(trans, t);
					break;
				}

			}

			return tlm::TLM_ACCEPTED;
		}


		//tlm::tlm_sync_enum nb_transport_bw(int portId, tlm::tlm_generic_payload &trans, 
		//				tlm::tlm_phase & phase, sc_core::sc_time & t)
		//{
		//	if (phase == tlm::BEGIN_RESP) {
		//		m2_mem_ResponsePEQ.notfiy(trans, t);
		//	}
		//	return tlm::TLM_ACCEPTED;
		//}


		void b_transport(int id, tlm::tlm_generic_payload & trans, sc_time & t)
		{
			tlm::tlm_command cmd = trans.get_command();
			sc_dt::uint64 addr = trans.get_address();
			unsigned char *ptr = trans.get_data_ptr();
			unsigned int len = trans.get_data_length();

			if (addr_valid(addr, len)) {						// internel m2 mem space
				if (cmd == tlm::TLM_READ_COMMAND) {
					if (m2_section_desc[M2_MEM]->addr_valid(addr, len)) {
						memcpy(ptr, &dmem_m2_mem[addr - m2_mem_base], len);
					} else if (m2_section_desc[M2_DMU]->addr_valid(addr, len)) {
						memcpy(ptr, (unsigned char *)&m2_dmu[(addr - m2_dmu_base) >> 2], len);
					} else if (m2_section_desc[M2_DMA]->addr_valid(addr, len)) {
						memcpy(ptr, (unsigned char *)&m2_dma[(addr - m2_dma_base) >> 2], len);
					}
				} else {
					if (m2_section_desc[M2_MEM]->addr_valid(addr, len)) {
						memcpy(&dmem_m2_mem[addr - m2_mem_base], ptr, len);
					} else if (m2_section_desc[M2_DMU]->addr_valid(addr, len)) {
						memcpy((unsigned char *)&m2_dmu[(addr - m2_dmu_base) >> 2], ptr, len);
					} else if (m2_section_desc[M2_DMA]->addr_valid(addr, len)) {
						memcpy((unsigned char *)&m2_dma[(addr - m2_dma_base) >> 2], ptr, len);
					}
				}
			}

			trans.set_response_status(tlm::TLM_OK_RESPONSE);
		}

		tlm::tlm_sync_enum dma_nb_transport_bw(tlm::tlm_generic_payload &trans,
						tlm::tlm_phase & phase, sc_core::sc_time & t)
		{
			if (phase == tlm::BEGIN_RESP) {
				m2_dma_ResponsePEQ.notify(trans, t);
			}
			return tlm::TLM_ACCEPTED;
		}

		// 1 = valid, 0 = invalid
		int addr_valid(unsigned int start, unsigned int len)
		{
			if ((start >= m2_mem_base) && ((start + len) < (m2_mem_base + m2_mem_size))) {
				if ((start + len) > m2_mem_base)
					return true;
			}
		
			if ((start >= m2_dmu_base) && ((start + len) < (m2_dmu_base + m2_dmu_size))) {
				if ((start + len) > m2_dmu_base)
					return true;
			}

			if ((start >= m2_dma_base) && ((start + len) < (m2_dma_base + m2_dma_size))) {
				if ((start + len) > m2_dma_base)
					return true;
			}
			return false;
		}

		int Dmem_m2_access(tlm::tlm_generic_payload *trans_ptr)
		{
			int ret = 1;
			int m2_dmanum;
			sc_core::sc_time t = sc_core::SC_ZERO_TIME;
			dma_extension *ext_ptr;

			tlm::tlm_command cmd = trans_ptr->get_command();
			sc_dt::uint64 addr = trans_ptr->get_address();
			unsigned char *ptr = trans_ptr->get_data_ptr();
			unsigned int len = trans_ptr->get_data_length();

			trans_ptr->get_extension(ext_ptr);
			if (!ext_ptr) {
				if (cmd == tlm::TLM_READ_COMMAND) {
					if (m2_section_desc[M2_MEM]->addr_valid(addr, len)) {
						memcpy(ptr, &dmem_m2_mem[addr - m2_mem_base], len);
					} else if (m2_section_desc[M2_DMU]->addr_valid(addr, len)) {
						memcpy(ptr, (unsigned char *)&m2_dmu[(addr - m2_dmu_base) >> 2], len);
					} else if (m2_section_desc[M2_DMA]->addr_valid(addr, len)) {
						memcpy(ptr, (unsigned char *)&m2_dma[(addr - m2_dma_base) >> 2], len);
					} else
						ret = 0;
				} else {
					if (m2_section_desc[M2_MEM]->addr_valid(addr, len)) {
						memcpy(&dmem_m2_mem[addr - m2_mem_base], ptr, len);
					} else if (m2_section_desc[M2_DMU]->addr_valid(addr, len)) {
						memcpy((unsigned char *)&m2_dmu[(addr - m2_dmu_base) >> 2], ptr, len);
					} else if (m2_section_desc[M2_DMA]->addr_valid(addr, len)) {
						memcpy((unsigned char *)&m2_dma[(addr - m2_dma_base) >> 2], ptr, len);
						for (m2_dmanum = 0; m2_dmanum < 8; m2_dmanum++) {
							if (addr == M2_DMAEN0 + m2_dma_base + 0x40 * m2_dmanum) {
								*ptr = 1;
								memcpy((unsigned char *)&m2_dma[(addr - m2_dma_base) >> 2], ptr, len);
								m2_dma_Request.notify();
								break;
							}
						}
					} else
						ret = 0;
				}
			} else
				dma_operation(trans_ptr, t);

			return ret;
		}

	private:
		void addPendingTransaction(tlm::tlm_generic_payload & trans, int to, int initiatorId)
		{
			const ConnectionInfo info = { initiatorId, to };
			switch (initiatorId) {
			case CORE0_ID:
				assert(mPendingTransactions_C0.find(&trans) == mPendingTransactions_C0.end());
				mPendingTransactions_C0[&trans] = info;
				break;
			case CORE1_ID:
				assert(mPendingTransactions_C1.find(&trans) == mPendingTransactions_C1.end());
				mPendingTransactions_C1[&trans] = info;
				break;
			case CORE2_ID:
				assert(mPendingTransactions_C2.find(&trans) == mPendingTransactions_C2.end());
				mPendingTransactions_C2[&trans] = info;
				break;
			case CORE3_ID:
				assert(mPendingTransactions_C3.find(&trans) == mPendingTransactions_C3.end());
				mPendingTransactions_C3[&trans] = info;
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

	private:
		PendingTransactions mPendingTransactions_C0;
		PendingTransactions mPendingTransactions_C1;
		PendingTransactions mPendingTransactions_C2;
		PendingTransactions mPendingTransactions_C3;
		PendingTransactions mPendingTransactions_Dma;
// dma out
		int m2_dma_process(tlm::tlm_generic_payload &trans, unsigned int m2_dmanum);
		int m2_dma_int2ext(tlm::tlm_generic_payload &trans, unsigned int m2_dmanum);
		int m2_dma_shape(tlm::tlm_generic_payload &trans, unsigned int m2_dmanum);
		int m2_dma_fifo(tlm::tlm_generic_payload &trans, unsigned int m2_dmanum);
		int m2_dma_sc(tlm::tlm_generic_payload &trans, unsigned int m2_dmanum);

//dma in
		void dma_operation(tlm::tlm_generic_payload *trans_ptr, sc_core::sc_time &delay);
		void extend_memcpy(unsigned char *dst, unsigned char *src, unsigned int len);
		void zone_memcpy_x0y0(tlm::tlm_generic_payload *trans_ptr);
		void zone_memcpy_x0y1(tlm::tlm_generic_payload *trans_ptr);
		void zone_memcpy_x1y0(tlm::tlm_generic_payload *trans_ptr);
		void zone_memcpy_x1y1(tlm::tlm_generic_payload *trans_ptr);
		void zone_memcpy_direct(tlm::tlm_generic_payload *trans_ptr);
		void zone_memcpy_x0(tlm::tlm_generic_payload *trans_ptr);
		void zone_memcpy_x1(tlm::tlm_generic_payload *trans_ptr);
		void zone_memcpy_y0(tlm::tlm_generic_payload *trans_ptr);
		void zone_memcpy_y1(tlm::tlm_generic_payload *trans_ptr);
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
};
#endif

#endif
