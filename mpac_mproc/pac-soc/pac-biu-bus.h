#ifndef PAC_BIU_BUS_H_INCLUDED
#define PAC_BIU_BUS_H_INCLUDED

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
#include "sys-dma-def.h"
#include "dma.h"

#include "fcntl.h"

extern sc_core::sc_event soc_core_req_event[DSPNUM]; // 4 core request event
extern int soc_core_req_bit_mask[DSPNUM]; //m1 m2 ddr finish bit mask

#ifndef PAC_SOC_PROFILE
struct Biu_Bus:public sc_core::sc_module, public pac_bus
{
	private:
		struct sim_arg *multi_sim_arg;
		unsigned int ddr_memory_base, ddr_memory_size;
		unsigned int ddr_memory_bank_size, ddr_memory_bank_num;
		unsigned char *ddr_memory;

		unsigned int sysdma_base, sysdma_size;	
		unsigned int *sys_dma;	
		unsigned int sys_dmanum;

	public:
		tlm_utils::simple_target_socket_tagged < Biu_Bus > biu_bus_targ_socket_tagged[DSPNUM + 2]; 	//connect to core_bus l2_bus
		tlm_utils::simple_initiator_socket < Biu_Bus > dma_bus_init_socket;
		
		tlm_utils::peq_with_get < tlm::tlm_generic_payload > ddr_mem_RequestPEQ;
		//tlm_utils::peq_with_get < tlm::tlm_generic_payload > ddr_mem_ResponsePEQ;	

		sc_core::sc_event sysdma_Request;
		tlm_utils::peq_with_get < tlm::tlm_generic_payload > sysdma_ResponsePEQ;

		SC_HAS_PROCESS(Biu_Bus);

	public:
		Biu_Bus(sc_module_name _name, struct sim_arg *arg)
		:sc_core::sc_module(_name)
		, multi_sim_arg(arg)
		, dma_bus_init_socket("dma_bus_init_socket")
		, ddr_mem_RequestPEQ("ddr_mem_Request")
		//, ddr_mem_ResponsePEQ("ddr_mem_ResponsePEQ")
		, sysdma_ResponsePEQ("sysdma_ResponsePEQ")
		{
			ddr_memory_base = multi_arg(ddr_mem, ddr_memory_base);
			ddr_memory_size = multi_arg(ddr_mem, ddr_memory_size);

			ddr_memory_bank_size = multi_arg(ddr_mem, ddr_memory_bank_size);
			ddr_memory_bank_num = ddr_memory_size / ddr_memory_bank_size;

		
			ddr_memory = (unsigned char *)multi_arg(shm_ptr, ddr_ptr);
			memset(ddr_memory, 0, ddr_memory_size);



			sysdma_base = multi_arg(sys_dma, sys_dma_base);
			sysdma_size = multi_arg(sys_dma, sys_dma_size);
			sys_dma = (unsigned int *)multi_arg(shm_ptr, sysdma_ptr);
			memset(sys_dma, 0, sysdma_size / 4);

			for (sys_dmanum = 0; sys_dmanum < 16; sys_dmanum++) {
				sys_dma[(SYS_DMASGR0 + sys_dmanum * 0x40) >> 2] = 0x10000;
				sys_dma[(SYS_DMADSR0 + sys_dmanum * 0x40) >> 2] = 0x10000;
			}

			for (unsigned int i = 0; i < (DSPNUM + 2); i++) {
				biu_bus_targ_socket_tagged[i].register_nb_transport_fw(this, &Biu_Bus::nb_transport_fw, i);
				biu_bus_targ_socket_tagged[i].register_b_transport(this, &Biu_Bus::b_transport, i);
			}

			dma_bus_init_socket.register_nb_transport_bw(this, &Biu_Bus::dma_nb_transport_bw);	

			SC_THREAD(Biu_Bus_Request_Thread);
			//SC_THREAD(Biu_Bus_Response_Thread);
			SC_THREAD(Sys_Dma_Request_Thread);
			SC_THREAD(Sys_Dma_Response_Thread);
		}

		~Biu_Bus()
		{
		}

	private:
		void Biu_Bus_Request_Thread()
		{
			trans_extension *ext_ptr;
			sc_dt::uint64 addr;
			unsigned int len;
			tlm::tlm_sync_enum ret;
			tlm::tlm_generic_payload * trans_ptr;
			tlm::tlm_phase phase = tlm::BEGIN_RESP;
			sc_core::sc_time t = sc_core::SC_ZERO_TIME;

			while (true) {
				wait(ddr_mem_RequestPEQ.get_event());
				while (true) {
					trans_ptr = ddr_mem_RequestPEQ.get_next_transaction();
					if (trans_ptr == NULL)
							break;

					trans_ptr->get_extension(ext_ptr);
					addr = trans_ptr->get_address();
					len = trans_ptr->get_data_length();

					if (ddr_addr_valid(addr, len)) {
						Dmem_ddr_access(trans_ptr);
					} else if (sysdma_addr_valid(addr, len)) {
						Sys_dma_access(trans_ptr);
					}

					tlm::tlm_phase phase = tlm::BEGIN_RESP;
					trans_ptr->set_response_status(tlm::TLM_OK_RESPONSE);
					PendingTransactionsIterator it = mPendingTransactions.find(trans_ptr);
					ret = biu_bus_targ_socket_tagged[it->second.from]->nb_transport_bw(*trans_ptr, phase, t);
					mPendingTransactions.erase(it);
				}
			}
		}

		//void Biu_Bus_Response_Thread()
		//{
		//	tlm::tlm_sync_enum ret;
		//	tlm::tlm_generic_payload * trans_ptr;
		//	tlm::tlm_phase phase = tlm::BEGIN_RESP;
		//	sc_core::sc_time t = sc_core::SC_ZERO_TIME;

		//	while (true) {
		//		wait(ddr_mem_ResponsePEQ.get_event());
		//		trans_ptr = ddr_mem_ResponsePEQ.get_next_transaction();
		//		PendingTransactionsIterator it = mPendingTransactions.find(trans_ptr);
		//		ret = m2_bus_targ_socket_tagged[it->second.from]->nb_transport_bw(*trans_ptr, phase, t);
		//		mPendingTransactions.erase(it);
		//	}
		//}

		tlm::tlm_sync_enum nb_transport_fw(int id, tlm::tlm_generic_payload &trans, 
						tlm::tlm_phase &phase, sc_time & t)
		{
			if (phase == tlm::BEGIN_REQ) {
				addPendingTransaction(trans, 0, id);
				ddr_mem_RequestPEQ.notify(trans, t);
			}

			return tlm::TLM_ACCEPTED;
		}
	
		void b_transport(int id, tlm::tlm_generic_payload & trans, sc_time & t)
		{
			tlm::tlm_command cmd = trans.get_command();
			sc_dt::uint64 addr = trans.get_address();
			unsigned char *ptr = trans.get_data_ptr();
			unsigned int len = trans.get_data_length();

			if (ddr_addr_valid(addr, len)) {
				addr -= ddr_memory_base;
				if (cmd == tlm::TLM_READ_COMMAND) {
					memcpy(ptr, &ddr_memory[addr], len);
				} else {
					memcpy(&ddr_memory[addr], ptr, len);
				}

				trans.set_response_status(tlm::TLM_OK_RESPONSE);
			} else if (sysdma_addr_valid(addr, len)) {
				if (cmd == tlm::TLM_READ_COMMAND) {
					memcpy(ptr, (unsigned char *)&sys_dma[(addr - sysdma_base) >> 2], len);
				} else {
					memcpy((unsigned char *)&sys_dma[(addr - sysdma_base) >> 2], ptr, len);
				}

				trans.set_response_status(tlm::TLM_OK_RESPONSE);
			} else {

				printf("In RequestThread: Access address not in ddr space. addr = 0x%08x\r\n", (unsigned int)addr);
				trans.set_response_status(tlm::TLM_ADDRESS_ERROR_RESPONSE);
			}

		}

		//tlm::tlm_sync_enum nb_transport_bw(int portId, tlm::tlm_generic_payload &trans, 
		//				tlm::tlm_phase & phase, sc_core::sc_time & t)
		//{
		//	if (phase == tlm::BEGIN_RESP) {
		//		ddr_mem_ResponsePEQ.notfiy(trans, t);
		//	}
		//	return tlm::TLM_ACCEPTED;
		//}

		void Sys_Dma_Request_Thread()
		{
			sc_dt::uint64 addr;
			unsigned int dmaen;
			unsigned int status;
			unsigned int dmactl;

			unsigned int len;

			while (true) {
				wait(sysdma_Request);

				for (sys_dmanum = 0; sys_dmanum < 16; sys_dmanum++) {
					if (sys_dma[(SYS_DMACLR0 + 0x30 * sys_dmanum) >> 2] & 0x1) {
						sys_dma[SYS_DMABUSY >> 2] &= ~(0x1 << (sys_dmanum));
						sys_dma[(SYS_DMACLR0 + 0x30 * sys_dmanum) >> 2] = 0;
					}

					dmaen = sys_dma[(SYS_DMAEN0 + 0x30 * sys_dmanum) >> 2];
					addr = sys_dma[(SYS_DMASAR0 + 0x30 * sys_dmanum) >> 2];
					len = (sys_dma[(SYS_DMACTL0 + 0x30 * sys_dmanum) >> 2] & 0xfffffc00) >> 10;
					dmactl = sys_dma[(SYS_DMACTL0 + 0x30 * sys_dmanum) >> 2];
					status = sys_dma[SYS_DMABUSY >> 2] & (0x1 << sys_dmanum);

					if (dmaen && len && (status == 0))
						break;
				}

				if (!dmaen || !len)
					continue;

				tlm::tlm_generic_payload *trans = new tlm::tlm_generic_payload();
				tlm::tlm_phase phase = tlm::BEGIN_REQ;
				sc_core::sc_time delay = sc_core::SC_ZERO_TIME;

				sys_dma_process(*trans, sys_dmanum);
			}
		}

		void Sys_Dma_Response_Thread()
		{
			tlm::tlm_generic_payload * trans_ptr;

			while(true) {
				wait(sysdma_ResponsePEQ.get_event());
				trans_ptr = sysdma_ResponsePEQ.get_next_transaction();

				sys_dma[SYS_DMABUSY >> 2] &= ~(0x1 << (sys_dmanum));
				sys_dma[(SYS_DMAEN0 + 0x30 * sys_dmanum) >> 2] = 0;
				delete  trans_ptr;
			}
		}


		tlm::tlm_sync_enum dma_nb_transport_bw(tlm::tlm_generic_payload &trans,
						tlm::tlm_phase & phase, sc_core::sc_time & t)
		{
			if (phase == tlm::BEGIN_RESP) {
				sysdma_ResponsePEQ.notify(trans, t);
			}
			return tlm::TLM_ACCEPTED;
		}

		// 1 = valid, 0 = invalid
		int ddr_addr_valid(unsigned int start, unsigned int len)
		{
			if ((start >= ddr_memory_base) && ((start + len) < (ddr_memory_base + ddr_memory_size))) {
				if ((start + len) > ddr_memory_base)
					return true;
			}

			return false;
		}
		// 1 = valid, 0 = invalid
		int sysdma_addr_valid(unsigned int start, unsigned int len)
		{
			if ((start >= sysdma_base) && ((start + len) < (sysdma_base + sysdma_size))) {
				if ((start + len) > sysdma_base)
						return true;
			}

			return false;
		}

		int Dmem_ddr_access(tlm::tlm_generic_payload *trans_ptr)
		{
			tlm::tlm_command cmd = trans_ptr->get_command();
			sc_core::sc_time delay = sc_core::SC_ZERO_TIME;
			sc_dt::uint64 addr = trans_ptr->get_address();
			unsigned char *ptr = trans_ptr->get_data_ptr();
			unsigned int len = trans_ptr->get_data_length();
			dma_extension *ext_ptr;

			addr -= ddr_memory_base;

			trans_ptr->get_extension(ext_ptr);
			if (!ext_ptr) {
				if (cmd == tlm::TLM_READ_COMMAND) {
					memcpy(ptr, &ddr_memory[addr], len);
				} else {
					memcpy(&ddr_memory[addr], ptr, len);
				}

				trans_ptr->set_response_status(tlm::TLM_OK_RESPONSE);
			} else
				dma_operation(trans_ptr, delay);

			return 0;
		}

		int Sys_dma_access(tlm::tlm_generic_payload *trans_ptr)
		{
			unsigned int ret;
			tlm::tlm_command cmd = trans_ptr->get_command();
			sc_dt::uint64 addr = trans_ptr->get_address();
			unsigned char *ptr = trans_ptr->get_data_ptr();
			unsigned int len = trans_ptr->get_data_length();

			if (cmd == tlm::TLM_READ_COMMAND) {
				if (sysdma_addr_valid(addr, len))
					memcpy(ptr, (unsigned char *)&sys_dma[(addr - sysdma_base) >> 2], len);
				else
					ret = 0;
			} else {
				if (sysdma_addr_valid(addr, len)) {
					memcpy((unsigned char *)&sys_dma[(addr - sysdma_base) >> 2], ptr, len);
					for (sys_dmanum = 0; sys_dmanum < 16; sys_dmanum++) {
						if (addr == SYS_DMAEN0 + sysdma_base + 0x30 * sys_dmanum) {
							*ptr = 1;
							memcpy((unsigned char *)&sys_dma[(addr - sysdma_base) >> 2], ptr, len);
							sysdma_Request.notify();
						}
					}
				} else
					ret = 0;
			}

			return ret;
		}

	private:
		void addPendingTransaction(tlm::tlm_generic_payload & trans,
						int to, int initiatorId)
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
		void operation(tlm::tlm_generic_payload * trans_ptr, sc_core::sc_time & delay);
		void dma_operation(tlm::tlm_generic_payload * trans_ptr, sc_core::sc_time & delay);
		void dma_direct_operation(tlm::tlm_generic_payload * trans_ptr, sc_core::sc_time & delay);
		void sys_dma_sc(tlm::tlm_generic_payload &trans, unsigned int sysdma_num);
		void sys_dma_int2ext(tlm::tlm_generic_payload &trans, unsigned int sysdma_num);
		void sys_dma_process(tlm::tlm_generic_payload &trans, unsigned int sysdma_num);

		void extend_memcpy(unsigned char *dst, unsigned char *src, unsigned int len);
		void zone_memcpy_x0y0(tlm::tlm_generic_payload * trans_ptr);
		void zone_memcpy_x0y1(tlm::tlm_generic_payload * trans_ptr);
		void zone_memcpy_x1y0(tlm::tlm_generic_payload * trans_ptr);
		void zone_memcpy_x1y1(tlm::tlm_generic_payload * trans_ptr);
		void zone_memcpy_x0(tlm::tlm_generic_payload * trans_ptr);
		void zone_memcpy_x1(tlm::tlm_generic_payload * trans_ptr);
		void zone_memcpy_y0(tlm::tlm_generic_payload * trans_ptr);
		void zone_memcpy_y1(tlm::tlm_generic_payload * trans_ptr);
		void zone_memcpy_direct(tlm::tlm_generic_payload * trans_ptr);
		void dma_shape_operation(tlm::tlm_generic_payload * trans_ptr, sc_core::sc_time & delay);
		void padding_operation_x0y0(tlm::tlm_generic_payload * trans_ptr, sc_core::sc_time & delay);
		void padding_operation_x0y1(tlm::tlm_generic_payload * trans_ptr, sc_core::sc_time & delay);
		void padding_operation_x1y0(tlm::tlm_generic_payload * trans_ptr, sc_core::sc_time & delay);
		void padding_operation_x1y1(tlm::tlm_generic_payload * trans_ptr, sc_core::sc_time & delay);
		void padding_operation_x0(tlm::tlm_generic_payload * trans_ptr, sc_core::sc_time & delay);
		void padding_operation_x1(tlm::tlm_generic_payload * trans_ptr, sc_core::sc_time & delay);
		void padding_operation_y0(tlm::tlm_generic_payload * trans_ptr, sc_core::sc_time & delay);
		void padding_operation_y1(tlm::tlm_generic_payload * trans_ptr, sc_core::sc_time & delay);
		void dma_sc_operation(tlm::tlm_generic_payload * trans_ptr, sc_core::sc_time & delay);
		void dma_fifo_operation(tlm::tlm_generic_payload * trans_ptr, sc_core::sc_time & delay);
		void ddr_memory_init(char *file, unsigned int addr);
};

#else //IN PAC_SOC_PROFILE

struct Biu_Bus:public sc_core::sc_module, public pac_bus
{
	private:
		struct sim_arg *multi_sim_arg;
		unsigned int ddr_memory_base, ddr_memory_size;
		unsigned int ddr_memory_bank_size, ddr_memory_bank_num;
		unsigned char *ddr_memory;

		unsigned int sysdma_base, sysdma_size;	
		unsigned int *sys_dma;	
		unsigned int sys_dmanum;

	public:
		tlm_utils::simple_target_socket_tagged < Biu_Bus > biu_bus_targ_socket_tagged[DSPNUM + 2]; 	//connect to core_bus l2_bus
		tlm_utils::simple_initiator_socket < Biu_Bus > dma_bus_init_socket;
		
		tlm_utils::peq_with_get < tlm::tlm_generic_payload > ddr_mem_RequestPEQ_Dma;
		tlm_utils::peq_with_get < tlm::tlm_generic_payload > ddr_mem_RequestPEQ_C0;
		tlm_utils::peq_with_get < tlm::tlm_generic_payload > ddr_mem_RequestPEQ_C1;
		tlm_utils::peq_with_get < tlm::tlm_generic_payload > ddr_mem_RequestPEQ_C2;
		tlm_utils::peq_with_get < tlm::tlm_generic_payload > ddr_mem_RequestPEQ_C3;
		
		//tlm_utils::peq_with_get < tlm::tlm_generic_payload > ddr_mem_ResponsePEQ;	

		sc_core::sc_event sysdma_Request;
		tlm_utils::peq_with_get < tlm::tlm_generic_payload > sysdma_ResponsePEQ;

		SC_HAS_PROCESS(Biu_Bus);

	public:
		Biu_Bus(sc_module_name _name, struct sim_arg *arg)
		:sc_core::sc_module(_name)
		, multi_sim_arg(arg)
		, dma_bus_init_socket("dma_bus_init_socket")
		, ddr_mem_RequestPEQ_Dma("ddr_mem_Request_Dma")
		, ddr_mem_RequestPEQ_C0("ddr_mem_Request_C0")
		, ddr_mem_RequestPEQ_C1("ddr_mem_Request_C1")
		, ddr_mem_RequestPEQ_C2("ddr_mem_Request_C2")
		, ddr_mem_RequestPEQ_C3("ddr_mem_Request_C3")
		//, ddr_mem_ResponsePEQ("ddr_mem_ResponsePEQ")
		, sysdma_ResponsePEQ("sysdma_ResponsePEQ")
		{
			ddr_memory_base = multi_arg(ddr_mem, ddr_memory_base);
			ddr_memory_size = multi_arg(ddr_mem, ddr_memory_size);

			ddr_memory_bank_size = multi_arg(ddr_mem, ddr_memory_bank_size);
			ddr_memory_bank_num = ddr_memory_size / ddr_memory_bank_size;

		
			ddr_memory = (unsigned char *)multi_arg(shm_ptr, ddr_ptr);
			memset(ddr_memory, 0, ddr_memory_size);


			sysdma_base = multi_arg(sys_dma, sys_dma_base);
			sysdma_size = multi_arg(sys_dma, sys_dma_size);
			sys_dma = (unsigned int *)multi_arg(shm_ptr, sysdma_ptr);
			memset(sys_dma, 0, sysdma_size / 4);
#if 0
			memset(&ddr_memory[0], '1', 16384);
			memset(&ddr_memory[32768], '2', 16384);
			memset(&ddr_memory[49152], '3', 16384);
			memset(&ddr_memory[65536], '4', 16384);
#endif

			for (sys_dmanum = 0; sys_dmanum < 16; sys_dmanum++) {
				sys_dma[(SYS_DMASGR0 + sys_dmanum * 0x40) >> 2] = 0x10000;
				sys_dma[(SYS_DMADSR0 + sys_dmanum * 0x40) >> 2] = 0x10000;
			}

			for (unsigned int i = 0; i < (DSPNUM + 2); i++) {
				biu_bus_targ_socket_tagged[i].register_nb_transport_fw(this, &Biu_Bus::nb_transport_fw, i);
				biu_bus_targ_socket_tagged[i].register_b_transport(this, &Biu_Bus::b_transport, i);
			}

			dma_bus_init_socket.register_nb_transport_bw(this, &Biu_Bus::dma_nb_transport_bw);	

			SC_THREAD(Biu_Bus_Request_Thread_Dma)
			SC_THREAD(Biu_Bus_Request_Thread_C0);
			SC_THREAD(Biu_Bus_Request_Thread_C1);
			SC_THREAD(Biu_Bus_Request_Thread_C2);
			SC_THREAD(Biu_Bus_Request_Thread_C3);
			//SC_THREAD(Biu_Bus_Response_Thread);
			SC_THREAD(Sys_Dma_Request_Thread);
			SC_THREAD(Sys_Dma_Response_Thread);
		}

		~Biu_Bus()
		{
		}

	private:
		void Biu_Bus_Request_Thread_Dma()
		{
			trans_extension *ext_ptr = NULL;
			sc_dt::uint64 addr;
			unsigned int len;
			tlm::tlm_sync_enum ret;
			tlm::tlm_generic_payload * trans_ptr;
			tlm::tlm_phase phase = tlm::BEGIN_RESP;
			sc_core::sc_time t = sc_core::SC_ZERO_TIME;

			while (true) {
				wait(ddr_mem_RequestPEQ_Dma.get_event());
				while (true) {
					trans_ptr = ddr_mem_RequestPEQ_Dma.get_next_transaction();
					if (trans_ptr == NULL) {
						break;
					}

					trans_ptr->get_extension(ext_ptr);
					addr = trans_ptr->get_address();
					len = trans_ptr->get_data_length();

					if (ddr_addr_valid(addr, len)) {
						Dmem_ddr_access(trans_ptr);
					} else if (sysdma_addr_valid(addr, len)) {
						Sys_dma_access(trans_ptr);
					}

					tlm::tlm_phase phase = tlm::BEGIN_RESP;
					trans_ptr->set_response_status(tlm::TLM_OK_RESPONSE);
					PendingTransactionsIterator it = mPendingTransactions_Dma.find(trans_ptr);
					ret = biu_bus_targ_socket_tagged[it->second.from]->nb_transport_bw(*trans_ptr, phase, t);
					mPendingTransactions_Dma.erase(it);
				}
			}
		}

		void Biu_Bus_Request_Thread_C0()
		{
			trans_extension *ext_ptr = NULL;
			sc_dt::uint64 addr;
			unsigned int len;
			tlm::tlm_generic_payload * trans_ptr;
			tlm::tlm_phase phase = tlm::BEGIN_RESP;
			sc_core::sc_time t = sc_core::SC_ZERO_TIME;

			while (true) {
				wait(ddr_mem_RequestPEQ_C0.get_event());
				wait(soc_core_req_event[CORE0_ID] | soc_core_req_event[CORE1_ID]
					 | soc_core_req_event[CORE2_ID] | soc_core_req_event[CORE3_ID]);
				wait(sc_core::SC_ZERO_TIME);
				while (true) {
					trans_ptr = ddr_mem_RequestPEQ_C0.get_next_transaction();
					if (trans_ptr == NULL) {
						modify_other_core_delay_time(CORE0_ID, DDR_RANGE);
//add by liuge			clear_self_soc_profile_table(CORE0_ID);
						notify_core_finish(CORE0_ID, DDR_RANGE);
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

					if (ddr_addr_valid(addr, len)) {
						Dmem_ddr_access(trans_ptr);
					} else if (sysdma_addr_valid(addr, len)) {
						Sys_dma_access(trans_ptr);
					}

					tlm::tlm_phase phase = tlm::BEGIN_RESP;
					trans_ptr->set_response_status(tlm::TLM_OK_RESPONSE);
					PendingTransactionsIterator it = mPendingTransactions_C0.find(trans_ptr);
					//ret = biu_bus_targ_socket_tagged[it->second.from]->nb_transport_bw(*trans_ptr, phase, t);
					mPendingTransactions_C0.erase(it);
				}
			}
		}

		void Biu_Bus_Request_Thread_C1()
		{
			trans_extension *ext_ptr = NULL;
			sc_dt::uint64 addr;
			unsigned int len;
			tlm::tlm_generic_payload * trans_ptr;
			tlm::tlm_phase phase = tlm::BEGIN_RESP;
			sc_core::sc_time t = sc_core::SC_ZERO_TIME;

			while (true) {
				wait(ddr_mem_RequestPEQ_C1.get_event());
				wait(soc_core_req_event[CORE0_ID] | soc_core_req_event[CORE1_ID]
					 | soc_core_req_event[CORE2_ID] | soc_core_req_event[CORE3_ID]);
				wait(sc_core::SC_ZERO_TIME);
				while (true) {
					trans_ptr = ddr_mem_RequestPEQ_C1.get_next_transaction();
					if (trans_ptr == NULL) {
						modify_other_core_delay_time(CORE1_ID, DDR_RANGE);
//add by liuge			clear_self_soc_profile_table(CORE1_ID);
						notify_core_finish(CORE1_ID, DDR_RANGE);
						break;
					}

					trans_ptr->get_extension(ext_ptr);
					addr = trans_ptr->get_address();
					len = trans_ptr->get_data_length();

					//wait_generic_delay(ext_ptr->inst_core_range);
					generate_generic_delay(ext_ptr->inst_core_range);
					generate_inst_bank_contention(ext_ptr->inst_core_range);
					generate_core_delay(ext_ptr->inst_core_range);
					//wait_core_delay(ext_ptr->inst_core_range);
					//wait_inst_delay(ext_ptr->inst_core_range);

					if (ddr_addr_valid(addr, len)) {
						Dmem_ddr_access(trans_ptr);
					} else if (sysdma_addr_valid(addr, len)) {
						Sys_dma_access(trans_ptr);
					}

					tlm::tlm_phase phase = tlm::BEGIN_RESP;
					trans_ptr->set_response_status(tlm::TLM_OK_RESPONSE);
					PendingTransactionsIterator it = mPendingTransactions_C1.find(trans_ptr);
					//ret = biu_bus_targ_socket_tagged[it->second.from]->nb_transport_bw(*trans_ptr, phase, t);
					mPendingTransactions_C1.erase(it);
				}
			}
		}

		void Biu_Bus_Request_Thread_C2()
		{
			trans_extension *ext_ptr = NULL;
			sc_dt::uint64 addr;
			unsigned int len;
			tlm::tlm_generic_payload * trans_ptr;
			tlm::tlm_phase phase = tlm::BEGIN_RESP;
			sc_core::sc_time t = sc_core::SC_ZERO_TIME;

			while (true) {
				wait(ddr_mem_RequestPEQ_C2.get_event());
				wait(soc_core_req_event[CORE0_ID] | soc_core_req_event[CORE1_ID]
					 | soc_core_req_event[CORE2_ID] | soc_core_req_event[CORE3_ID]);
				wait(sc_core::SC_ZERO_TIME);
				while (true) {
					trans_ptr = ddr_mem_RequestPEQ_C2.get_next_transaction();
					if (trans_ptr == NULL) {
						modify_other_core_delay_time(CORE2_ID, DDR_RANGE);
//add by liuge			clear_self_soc_profile_table(CORE2_ID);
						notify_core_finish(CORE2_ID, DDR_RANGE);
						break;
					}

					trans_ptr->get_extension(ext_ptr);
					addr = trans_ptr->get_address();
					len = trans_ptr->get_data_length();

					//wait_generic_delay(ext_ptr->inst_core_range);
					generate_generic_delay(ext_ptr->inst_core_range);
					generate_inst_bank_contention(ext_ptr->inst_core_range);
					generate_core_delay(ext_ptr->inst_core_range);
					//wait_core_delay(ext_ptr->inst_core_range);
					//wait_inst_delay(ext_ptr->inst_core_range);

					if (ddr_addr_valid(addr, len)) {
						Dmem_ddr_access(trans_ptr);
					} else if (sysdma_addr_valid(addr, len)) {
						Sys_dma_access(trans_ptr);
					}

					tlm::tlm_phase phase = tlm::BEGIN_RESP;
					trans_ptr->set_response_status(tlm::TLM_OK_RESPONSE);
					PendingTransactionsIterator it = mPendingTransactions_C2.find(trans_ptr);
					//ret = biu_bus_targ_socket_tagged[it->second.from]->nb_transport_bw(*trans_ptr, phase, t);
					mPendingTransactions_C2.erase(it);
				}
			}
		}

		void Biu_Bus_Request_Thread_C3()
		{
			trans_extension *ext_ptr = NULL;
			sc_dt::uint64 addr;
			unsigned int len;
			tlm::tlm_generic_payload * trans_ptr;
			tlm::tlm_phase phase = tlm::BEGIN_RESP;
			sc_core::sc_time t = sc_core::SC_ZERO_TIME;

			while (true) {
				wait(ddr_mem_RequestPEQ_C3.get_event());
				wait(soc_core_req_event[CORE0_ID] | soc_core_req_event[CORE1_ID]
					 | soc_core_req_event[CORE2_ID] | soc_core_req_event[CORE3_ID]);
				wait(sc_core::SC_ZERO_TIME);
				while (true) {
					trans_ptr = ddr_mem_RequestPEQ_C3.get_next_transaction();
					if (trans_ptr == NULL) {
						modify_other_core_delay_time(CORE3_ID, DDR_RANGE);
//add by liuge			clear_self_soc_profile_table(CORE3_ID);
						notify_core_finish(CORE3_ID, DDR_RANGE);
						break;
					}

					trans_ptr->get_extension(ext_ptr);
					addr = trans_ptr->get_address();
					len = trans_ptr->get_data_length();

					//wait_generic_delay(ext_ptr->inst_core_range);
					generate_generic_delay(ext_ptr->inst_core_range);
					generate_inst_bank_contention(ext_ptr->inst_core_range);
					generate_core_delay(ext_ptr->inst_core_range);
					//wait_core_delay(ext_ptr->inst_core_range);
					//wait_inst_delay(ext_ptr->inst_core_range);

					if (ddr_addr_valid(addr, len)) {
						Dmem_ddr_access(trans_ptr);
					} else if (sysdma_addr_valid(addr, len)) {
						Sys_dma_access(trans_ptr);
					}

					tlm::tlm_phase phase = tlm::BEGIN_RESP;
					trans_ptr->set_response_status(tlm::TLM_OK_RESPONSE);
					PendingTransactionsIterator it = mPendingTransactions_C3.find(trans_ptr);
					//ret = biu_bus_targ_socket_tagged[it->second.from]->nb_transport_bw(*trans_ptr, phase, t);
					mPendingTransactions_C3.erase(it);
				}
			}
		}

		//void Biu_Bus_Response_Thread()
		//{
		//	tlm::tlm_sync_enum ret;
		//	tlm::tlm_generic_payload * trans_ptr;
		//	tlm::tlm_phase phase = tlm::BEGIN_RESP;
		//	sc_core::sc_time t = sc_core::SC_ZERO_TIME;

		//	while (true) {
		//		wait(ddr_mem_ResponsePEQ.get_event());
		//		trans_ptr = ddr_mem_ResponsePEQ.get_next_transaction();
		//		PendingTransactionsIterator it = mPendingTransactions.find(trans_ptr);
		//		ret = m2_bus_targ_socket_tagged[it->second.from]->nb_transport_bw(*trans_ptr, phase, t);
		//		mPendingTransactions.erase(it);
		//	}
		//}

		tlm::tlm_sync_enum nb_transport_fw(int id, tlm::tlm_generic_payload &trans, 
						tlm::tlm_phase &phase, sc_time & t)
		{
			sc_dt::uint64 addr;
			unsigned int len, i;
			int self_core_id = 0;
			trans_extension *ext_ptr;

			if (phase == tlm::BEGIN_REQ) {
				addr = trans.get_address();
				len = trans.get_data_length();
				trans.get_extension(ext_ptr);
				if (ext_ptr != NULL) {
					self_core_id = GET_CORE(ext_ptr->inst_core_range);
					for (i = 0; i < ddr_memory_bank_num; i++) {
						if ((addr >= (ddr_memory_base + i*ddr_memory_bank_size)) &&
							((addr + len) < (ddr_memory_base + (i+1)*ddr_memory_bank_size)))
						{
							generate_inst_table(ext_ptr->inst_core_range, (int)i, sc_core::sc_time_stamp().to_double(),
											trans.get_command());
							break;
						}
					}
				}

				switch (id) {
				case CORE0_ID:
					addPendingTransaction(trans, 0, id);
					ddr_mem_RequestPEQ_C0.notify(trans, t);
					break;
				case CORE1_ID:
					addPendingTransaction(trans, 0, id);
					ddr_mem_RequestPEQ_C1.notify(trans, t);
					break;
				case CORE2_ID:
					addPendingTransaction(trans, 0, id);
					ddr_mem_RequestPEQ_C2.notify(trans, t);
					break;
				case CORE3_ID:
					addPendingTransaction(trans, 0, id);
					ddr_mem_RequestPEQ_C3.notify(trans, t);
					break;
				case 4: //IF
					if (self_core_id == CORE0_ID) {
						addPendingTransaction(trans, 0, CORE0_ID);
						ddr_mem_RequestPEQ_C0.notify(trans, t);
					} else if (self_core_id == CORE1_ID) {
						addPendingTransaction(trans, 0, CORE1_ID);
						ddr_mem_RequestPEQ_C1.notify(trans, t);
					} else if (self_core_id == CORE2_ID) {
						addPendingTransaction(trans, 0, CORE2_ID);
						ddr_mem_RequestPEQ_C2.notify(trans, t);
					} else {
						addPendingTransaction(trans, 0, CORE3_ID);
						ddr_mem_RequestPEQ_C3.notify(trans, t);
					}
					break;
				default:
					addPendingTransaction(trans, 0, id);
					ddr_mem_RequestPEQ_Dma.notify(trans, t);
					break;
				}

			}

			return tlm::TLM_ACCEPTED;
		}
	
		void b_transport(int id, tlm::tlm_generic_payload & trans, sc_time & t)
		{
			tlm::tlm_command cmd = trans.get_command();
			sc_dt::uint64 addr = trans.get_address();
			unsigned char *ptr = trans.get_data_ptr();
			unsigned int len = trans.get_data_length();

			if (ddr_addr_valid(addr, len)) {
				addr -= ddr_memory_base;
				if (cmd == tlm::TLM_READ_COMMAND) {
					memcpy(ptr, &ddr_memory[addr], len);
				} else {
					memcpy(&ddr_memory[addr], ptr, len);
				}

				trans.set_response_status(tlm::TLM_OK_RESPONSE);
			} else if (sysdma_addr_valid(addr, len)) {
				if (cmd == tlm::TLM_READ_COMMAND) {
					memcpy(ptr, (unsigned char *)&sys_dma[(addr - sysdma_base) >> 2], len);
				} else {
					memcpy((unsigned char *)&sys_dma[(addr - sysdma_base) >> 2], ptr, len);
				}

				trans.set_response_status(tlm::TLM_OK_RESPONSE);
			} else {

				printf("In RequestThread: Access address not in ddr space. addr = 0x%08x\r\n", (unsigned int)addr);
				trans.set_response_status(tlm::TLM_ADDRESS_ERROR_RESPONSE);
			}

		}

		//tlm::tlm_sync_enum nb_transport_bw(int portId, tlm::tlm_generic_payload &trans, 
		//				tlm::tlm_phase & phase, sc_core::sc_time & t)
		//{
		//	if (phase == tlm::BEGIN_RESP) {
		//		ddr_mem_ResponsePEQ.notfiy(trans, t);
		//	}
		//	return tlm::TLM_ACCEPTED;
		//}

		void Sys_Dma_Request_Thread()
		{
			sc_dt::uint64 addr;
			unsigned int dmaen;
			unsigned int status;
			unsigned int dmactl;

			unsigned int len;

			while (true) {
				wait(sysdma_Request);

				for (sys_dmanum = 0; sys_dmanum < 16; sys_dmanum++) {
					if (sys_dma[(SYS_DMACLR0 + 0x30 * sys_dmanum) >> 2] & 0x1) {
						sys_dma[SYS_DMABUSY >> 2] &= ~(0x1 << (sys_dmanum));
						sys_dma[(SYS_DMACLR0 + 0x30 * sys_dmanum) >> 2] = 0;
					}

					dmaen = sys_dma[(SYS_DMAEN0 + 0x30 * sys_dmanum) >> 2];
					addr = sys_dma[(SYS_DMASAR0 + 0x30 * sys_dmanum) >> 2];
					len = (sys_dma[(SYS_DMACTL0 + 0x30 * sys_dmanum) >> 2] & 0xfffffc00) >> 10;
					dmactl = sys_dma[(SYS_DMACTL0 + 0x30 * sys_dmanum) >> 2];
					status = sys_dma[SYS_DMABUSY >> 2] & (0x1 << sys_dmanum);

					if (dmaen && len && (status == 0))
						break;
				}

				if (!dmaen || !len)
					continue;

				tlm::tlm_generic_payload *trans = new tlm::tlm_generic_payload();
				tlm::tlm_phase phase = tlm::BEGIN_REQ;
				sc_core::sc_time delay = sc_core::SC_ZERO_TIME;

				sys_dma_process(*trans, sys_dmanum);
			}
		}

		void Sys_Dma_Response_Thread()
		{
			tlm::tlm_generic_payload * trans_ptr;

			while(true) {
				wait(sysdma_ResponsePEQ.get_event());
				while (true) {
					trans_ptr = sysdma_ResponsePEQ.get_next_transaction();
					if (trans_ptr == NULL) {
							break;
					}

					sys_dma[SYS_DMABUSY >> 2] &= ~(0x1 << (sys_dmanum));
					sys_dma[(SYS_DMAEN0 + 0x30 * sys_dmanum) >> 2] = 0;
					delete  trans_ptr;
				}
			}
		}


		tlm::tlm_sync_enum dma_nb_transport_bw(tlm::tlm_generic_payload &trans,
						tlm::tlm_phase & phase, sc_core::sc_time & t)
		{
			if (phase == tlm::BEGIN_RESP) {
				sysdma_ResponsePEQ.notify(trans, t);
			}
			return tlm::TLM_ACCEPTED;
		}

		// 1 = valid, 0 = invalid
		int ddr_addr_valid(unsigned int start, unsigned int len)
		{
			if ((start >= ddr_memory_base) && ((start + len) < (ddr_memory_base + ddr_memory_size))) {
				if ((start + len) > ddr_memory_base)
					return true;
			}

			return false;
		}
		// 1 = valid, 0 = invalid
		int sysdma_addr_valid(unsigned int start, unsigned int len)
		{
			if ((start >= sysdma_base) && ((start + len) < (sysdma_base + sysdma_size))) {
				if ((start + len) > sysdma_base)
						return true;
			}

			return false;
		}

		int Dmem_ddr_access(tlm::tlm_generic_payload *trans_ptr)
		{
			tlm::tlm_command cmd = trans_ptr->get_command();
			sc_core::sc_time delay = sc_core::SC_ZERO_TIME;
			sc_dt::uint64 addr = trans_ptr->get_address();
			unsigned char *ptr = trans_ptr->get_data_ptr();
			unsigned int len = trans_ptr->get_data_length();
			dma_extension *ext_ptr;

			addr -= ddr_memory_base;

			trans_ptr->get_extension(ext_ptr);
			if (!ext_ptr) {
				if (cmd == tlm::TLM_READ_COMMAND) {
					memcpy(ptr, &ddr_memory[addr], len);
				} else {
					memcpy(&ddr_memory[addr], ptr, len);
				}

				trans_ptr->set_response_status(tlm::TLM_OK_RESPONSE);
			} else
				dma_operation(trans_ptr, delay);

			return 0;
		}

		int Sys_dma_access(tlm::tlm_generic_payload *trans_ptr)
		{
			unsigned int ret;
			tlm::tlm_command cmd = trans_ptr->get_command();
			sc_dt::uint64 addr = trans_ptr->get_address();
			unsigned char *ptr = trans_ptr->get_data_ptr();
			unsigned int len = trans_ptr->get_data_length();

			if (cmd == tlm::TLM_READ_COMMAND) {
				if (sysdma_addr_valid(addr, len))
					memcpy(ptr, (unsigned char *)&sys_dma[(addr - sysdma_base) >> 2], len);
				else
					ret = 0;
			} else {
				if (sysdma_addr_valid(addr, len)) {
					memcpy((unsigned char *)&sys_dma[(addr - sysdma_base) >> 2], ptr, len);
					for (sys_dmanum = 0; sys_dmanum < 16; sys_dmanum++) {
						if (addr == SYS_DMAEN0 + sysdma_base + 0x30 * sys_dmanum) {
							*ptr = 1;
							memcpy((unsigned char *)&sys_dma[(addr - sysdma_base) >> 2], ptr, len);
							sysdma_Request.notify();
						}
					}
				} else
					ret = 0;
			}

			return ret;
		}

	private:
		void addPendingTransaction(tlm::tlm_generic_payload & trans,
						int to, int initiatorId)
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
		
		void operation(tlm::tlm_generic_payload * trans_ptr, sc_core::sc_time & delay);
		void dma_operation(tlm::tlm_generic_payload * trans_ptr, sc_core::sc_time & delay);
		void dma_direct_operation(tlm::tlm_generic_payload * trans_ptr, sc_core::sc_time & delay);
		void sys_dma_sc(tlm::tlm_generic_payload &trans, unsigned int sysdma_num);
		void sys_dma_int2ext(tlm::tlm_generic_payload &trans, unsigned int sysdma_num);
		void sys_dma_process(tlm::tlm_generic_payload &trans, unsigned int sysdma_num);

		void extend_memcpy(unsigned char *dst, unsigned char *src, unsigned int len);
		void zone_memcpy_x0y0(tlm::tlm_generic_payload * trans_ptr);
		void zone_memcpy_x0y1(tlm::tlm_generic_payload * trans_ptr);
		void zone_memcpy_x1y0(tlm::tlm_generic_payload * trans_ptr);
		void zone_memcpy_x1y1(tlm::tlm_generic_payload * trans_ptr);
		void zone_memcpy_x0(tlm::tlm_generic_payload * trans_ptr);
		void zone_memcpy_x1(tlm::tlm_generic_payload * trans_ptr);
		void zone_memcpy_y0(tlm::tlm_generic_payload * trans_ptr);
		void zone_memcpy_y1(tlm::tlm_generic_payload * trans_ptr);
		void zone_memcpy_direct(tlm::tlm_generic_payload * trans_ptr);
		void dma_shape_operation(tlm::tlm_generic_payload * trans_ptr, sc_core::sc_time & delay);
		void padding_operation_x0y0(tlm::tlm_generic_payload * trans_ptr, sc_core::sc_time & delay);
		void padding_operation_x0y1(tlm::tlm_generic_payload * trans_ptr, sc_core::sc_time & delay);
		void padding_operation_x1y0(tlm::tlm_generic_payload * trans_ptr, sc_core::sc_time & delay);
		void padding_operation_x1y1(tlm::tlm_generic_payload * trans_ptr, sc_core::sc_time & delay);
		void padding_operation_x0(tlm::tlm_generic_payload * trans_ptr, sc_core::sc_time & delay);
		void padding_operation_x1(tlm::tlm_generic_payload * trans_ptr, sc_core::sc_time & delay);
		void padding_operation_y0(tlm::tlm_generic_payload * trans_ptr, sc_core::sc_time & delay);
		void padding_operation_y1(tlm::tlm_generic_payload * trans_ptr, sc_core::sc_time & delay);
		void dma_sc_operation(tlm::tlm_generic_payload * trans_ptr, sc_core::sc_time & delay);
		void dma_fifo_operation(tlm::tlm_generic_payload * trans_ptr, sc_core::sc_time & delay);
		void ddr_memory_init(char *file, unsigned int addr);
};

#endif

#endif
