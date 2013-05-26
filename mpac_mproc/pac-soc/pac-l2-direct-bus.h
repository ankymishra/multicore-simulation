#ifndef PAC_L2_BUS_H_INCLUDED
#define PAC_L2_BUS_H_INCLUDED

#include <systemc.h>
using namespace sc_core;
using namespace sc_dt;
using namespace std;

#include "tlm.h"
#include "tlm_utils/simple_target_socket.h"
#include "tlm_utils/simple_initiator_socket.h"
#include "tlm_utils/peq_with_get.h"

#include "pac-trans-extension.h"
#include "pac-profiling.h"
#include "pac-bus.h"

struct l2_icache_addr {
	unsigned int offset:8;
	unsigned int index:8;
	unsigned int tag:16;
};

struct l2_icache_flag {
	unsigned int invalid:8;
	unsigned int index:8;
	unsigned int tag:16;
};

struct l2_icache_line {
	struct l2_icache_flag flag;
	unsigned char *insn;
};

extern struct core_profiling_control  pcore[DSPNUM];

#ifndef PAC_SOC_PROFILE
struct L2_Bus:public sc_core::sc_module, public pac_bus
{
	private:
		unsigned int i;
		unsigned int l2_icache_type;
		unsigned int l2_icache_size;
		unsigned int l2_icache_line_size;

		struct l2_icache_line *l2_icache_mem;
		struct sim_arg *multi_sim_arg;


	public:
		tlm_utils::simple_target_socket_tagged < L2_Bus > l2_bus_targ_socket_tagged[DSPNUM];
		tlm_utils::simple_initiator_socket < L2_Bus > ddr_mem_init_socket;

		tlm_utils::peq_with_get < tlm::tlm_generic_payload > l2_bus_RequestPEQ;
		tlm_utils::peq_with_get < tlm::tlm_generic_payload > ddr_mem_ResponsePEQ;

		SC_HAS_PROCESS(L2_Bus);
	public:
		L2_Bus(sc_module_name _name, struct sim_arg *arg)
		:sc_core::sc_module(_name)
		, multi_sim_arg(arg)
		, ddr_mem_init_socket("ddr_mem_init_socket")
		, l2_bus_RequestPEQ("l2_bus_RequestPEQ")
		, ddr_mem_ResponsePEQ("ddr_mem_ResponsePEQ")
		{
			l2_icache_type = multi_arg(l2_cache, l2_cache_type);
			l2_icache_size = multi_arg(l2_cache, l2_cache_size);
			l2_icache_line_size = multi_arg(l2_cache, l2_cache_line_size);

			l2_icache_mem = new l2_icache_line[l2_icache_size / l2_icache_line_size];
			for (i = 0; i < l2_icache_size / l2_icache_line_size; i++) {
				l2_icache_mem[i].insn = new unsigned char[l2_icache_line_size];
			}

			for (i = 0; i < (l2_icache_size / l2_icache_line_size); i++) {
				l2_icache_mem[i].flag.tag = 0;
				l2_icache_mem[i].flag.index = 0;
				l2_icache_mem[i].flag.invalid = 1;
			}

			for (i = 0; i < DSPNUM; i++) {
				l2_bus_targ_socket_tagged[i].register_nb_transport_fw(this, &L2_Bus::nb_transport_fw, i);
				l2_bus_targ_socket_tagged[i].register_b_transport(this, &L2_Bus::b_transport, i);
			}

			ddr_mem_init_socket.register_nb_transport_bw(this, &L2_Bus::nb_transport_bw);

			SC_THREAD(L2_Bus_Request_Thread);
		}

		~L2_Bus()
		{
			delete[]l2_icache_mem;
		}

	private:
		void L2_Bus_Request_Thread()
		{
			unsigned int i, len;
			unsigned char *ptr;
			tlm::tlm_sync_enum ret;
			tlm::tlm_generic_payload * trans_ptr;
			trans_extension *ext_ptr;

			while (true) {
				wait(l2_bus_RequestPEQ.get_event());
				while (true) {
					trans_ptr = l2_bus_RequestPEQ.get_next_transaction();
					if (trans_ptr == NULL)
							break;

					tlm::tlm_phase phase = tlm::BEGIN_REQ;
					sc_core::sc_time t = sc_core::SC_ZERO_TIME;
					tlm::tlm_command cmd = trans_ptr->get_command();
					sc_dt::uint64 addr = trans_ptr->get_address();
					trans_ptr->get_extension(ext_ptr);
					ptr = trans_ptr->get_data_ptr();
					len = trans_ptr->get_data_length();

					if (cmd == tlm::TLM_READ_COMMAND) {
						for (i = 0; i < len; i++) {
							struct l2_icache_addr iaddr = *(struct l2_icache_addr *)&(addr);
	
							if ((l2_icache_mem[iaddr.index].flag.invalid == 1)
								|| (l2_icache_mem[iaddr.index].flag.tag != iaddr.tag)) {

								tlm::tlm_generic_payload l2_cache_trans;
								trans_extension *trans_extension_ptr = new trans_extension();
								memcpy(trans_extension_ptr, ext_ptr, sizeof(trans_extension));
								l2_cache_trans.set_command(tlm::TLM_READ_COMMAND);
								l2_cache_trans.set_address(addr & ~(l2_icache_line_size - 1));
								l2_cache_trans.set_data_ptr(l2_icache_mem[iaddr.index].insn);
								l2_cache_trans.set_data_length(l2_icache_line_size);
								l2_cache_trans.set_extension(trans_extension_ptr);
	
								if (pcore[GET_CORE(ext_ptr->inst_core_range)].flag == 1) {
									pcore[GET_CORE(ext_ptr->inst_core_range)].core_data.l2_pdata.cache_miss++;
								}
							
								ret = ddr_mem_init_socket->nb_transport_fw(l2_cache_trans, phase, t);

								wait(ddr_mem_ResponsePEQ.get_event());
								ddr_mem_ResponsePEQ.get_next_transaction();

								l2_icache_mem[iaddr.index].flag.invalid = 0;
								l2_icache_mem[iaddr.index].flag.tag = iaddr.tag;
							}

							*ptr = l2_icache_mem[iaddr.index].insn[addr & (l2_icache_line_size - 1)];
							addr++;
							ptr++;
						}

						phase = tlm::BEGIN_RESP;
						PendingTransactionsIterator it = mPendingTransactions.find(trans_ptr);
						ret = l2_bus_targ_socket_tagged[it->second.from]->nb_transport_bw(*trans_ptr, phase, t);
						mPendingTransactions.erase(it);
					}
				}
			}
		}

		tlm::tlm_sync_enum nb_transport_fw(int id, tlm::tlm_generic_payload &trans, 
						tlm::tlm_phase & phase, sc_core::sc_time & t)
		{
			if (phase == tlm::BEGIN_REQ) {
				addPendingTransaction(trans, 0, id);
				l2_bus_RequestPEQ.notify(trans, t);
			}

			return tlm::TLM_ACCEPTED;
		}

		tlm::tlm_sync_enum nb_transport_bw(tlm::tlm_generic_payload &trans, 
						tlm::tlm_phase & phase, sc_core::sc_time & t)
		{
			if (phase == tlm::BEGIN_RESP) {
				ddr_mem_ResponsePEQ.notify(trans, t);
			}

			return tlm::TLM_ACCEPTED;
		}

		void b_transport(int id, tlm::tlm_generic_payload & trans, sc_time & delay)
		{
			tlm::tlm_command cmd = trans.get_command();
			sc_dt::uint64 addr = trans.get_address();
			unsigned int len = trans.get_data_length();
			unsigned char *ptr = trans.get_data_ptr();;
			
			if (cmd == tlm::TLM_WRITE_COMMAND) {
				if (addr != 0) {
					struct l2_icache_addr iaddr = *(struct l2_icache_addr *)&(addr);
					memcpy(ptr, &l2_icache_mem[iaddr.index].insn[addr & ~(l2_icache_line_size - 1)], len);
				} else {
					for (unsigned int i = 0; i < (l2_icache_size / l2_icache_line_size); i++) {
						l2_icache_mem[i].flag.tag = 0;
						l2_icache_mem[i].flag.index = 0;
						l2_icache_mem[i].flag.invalid = 1;
					}
				}
			}
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
};

#else //IN PAC_SOC_PROFILE

struct L2_Bus:public sc_core::sc_module, public pac_bus
{
	private:
		unsigned int i;
		unsigned int l2_icache_type;
		unsigned int l2_icache_size;
		unsigned int l2_icache_line_size;
		unsigned int l2_rd_delay;

		struct l2_icache_line *l2_icache_mem;
		struct sim_arg *multi_sim_arg;
		tlm::tlm_generic_payload l2_cache_trans[DSPNUM];		
		trans_extension trans_extension_ptr[DSPNUM];
		unsigned char *l2_icache_buf[DSPNUM];
		unsigned int l2_sync[DSPNUM];

	public:
		tlm_utils::simple_target_socket_tagged < L2_Bus > l2_bus_targ_socket_tagged[DSPNUM];
		tlm_utils::simple_initiator_socket < L2_Bus > ddr_mem_init_socket;

		tlm_utils::peq_with_get < tlm::tlm_generic_payload > l2_bus_RequestPEQ_C0;
		tlm_utils::peq_with_get < tlm::tlm_generic_payload > l2_bus_RequestPEQ_C1;
		tlm_utils::peq_with_get < tlm::tlm_generic_payload > l2_bus_RequestPEQ_C2;
		tlm_utils::peq_with_get < tlm::tlm_generic_payload > l2_bus_RequestPEQ_C3;
		tlm_utils::peq_with_get < tlm::tlm_generic_payload > ddr_mem_ResponsePEQ;

		SC_HAS_PROCESS(L2_Bus);
	public:
		L2_Bus(sc_module_name _name, struct sim_arg *arg)
		:sc_core::sc_module(_name)
		, multi_sim_arg(arg)
		, ddr_mem_init_socket("ddr_mem_init_socket")
		, l2_bus_RequestPEQ_C0("l2_bus_RequestPEQ_C0")
		, l2_bus_RequestPEQ_C1("l2_bus_RequestPEQ_C1")
		, l2_bus_RequestPEQ_C2("l2_bus_RequestPEQ_C2")
		, l2_bus_RequestPEQ_C3("l2_bus_RequestPEQ_C3")
		, ddr_mem_ResponsePEQ("ddr_mem_ResponsePEQ")
		{
			l2_icache_type = multi_arg(l2_cache, l2_cache_type);
			l2_icache_size = multi_arg(l2_cache, l2_cache_size);
			l2_icache_line_size = multi_arg(l2_cache, l2_cache_line_size);
			l2_rd_delay = multi_arg(l2_cache, l2_rd_delay);

			l2_icache_buf[CORE0_ID] = new unsigned char[2 * l2_icache_line_size];
			l2_icache_buf[CORE1_ID] = new unsigned char[2 * l2_icache_line_size];
			l2_icache_buf[CORE2_ID] = new unsigned char[2 * l2_icache_line_size];
			l2_icache_buf[CORE3_ID] = new unsigned char[2 * l2_icache_line_size];

			l2_icache_mem = new l2_icache_line[l2_icache_size / l2_icache_line_size];
			for (i = 0; i < l2_icache_size / l2_icache_line_size; i++) {
				l2_icache_mem[i].insn = new unsigned char[l2_icache_line_size];
			}

			for (i = 0; i < (l2_icache_size / l2_icache_line_size); i++) {
				l2_icache_mem[i].flag.tag = 0;
				l2_icache_mem[i].flag.index = 0;
				l2_icache_mem[i].flag.invalid = 1;
			}

			for (i = 0; i < DSPNUM; i++) {
				l2_bus_targ_socket_tagged[i].register_nb_transport_fw(this, &L2_Bus::nb_transport_fw, i);
				l2_bus_targ_socket_tagged[i].register_b_transport(this, &L2_Bus::b_transport, i);
			}

			ddr_mem_init_socket.register_nb_transport_bw(this, &L2_Bus::nb_transport_bw);

			SC_THREAD(L2_Bus_Request_Thread_C0);
			SC_THREAD(L2_Bus_Request_Thread_C1);
			SC_THREAD(L2_Bus_Request_Thread_C2);
			SC_THREAD(L2_Bus_Request_Thread_C3);
		}

		~L2_Bus()
		{
			delete[]l2_icache_buf;
			delete[]l2_icache_mem;
		}

	private:
		void L2_Bus_Request_Thread_C0()
		{
			unsigned int i, len;
			unsigned char *ptr, *tmp_ptr;
			tlm::tlm_sync_enum ret;
			tlm::tlm_generic_payload * trans_ptr;
			trans_extension *ext_ptr;
			unsigned int addr_line2, addr_line1;
			struct l2_icache_addr iaddr;
			while (true) {
				wait(l2_bus_RequestPEQ_C0.get_event());

				l2_sync[CORE0_ID] = 0;
				trans_ptr = l2_bus_RequestPEQ_C0.get_next_transaction();

				tlm::tlm_phase phase = tlm::BEGIN_REQ;
				sc_core::sc_time t = sc_core::SC_ZERO_TIME;
				tlm::tlm_command cmd = trans_ptr->get_command();
				sc_dt::uint64 addr = trans_ptr->get_address();
				sc_dt::uint64 tmp_addr = addr;
				trans_ptr->get_extension(ext_ptr);
				ptr = trans_ptr->get_data_ptr();
				tmp_ptr = ptr;
				len = trans_ptr->get_data_length();

				if (cmd == tlm::TLM_READ_COMMAND) {
					for (i = 0; i < len; i++) {
						iaddr = *(struct l2_icache_addr *)&(addr);

						if ((l2_icache_mem[iaddr.index].flag.invalid == 1)
							|| (l2_icache_mem[iaddr.index].flag.tag != iaddr.tag)) {
							
							l2_sync[CORE0_ID] = 1;
							soc_core_req_bit_mask[CORE0_ID] |= 1 << 2;
							memcpy(&trans_extension_ptr[CORE0_ID], ext_ptr, sizeof(trans_extension));

							l2_cache_trans[CORE0_ID].set_command(tlm::TLM_READ_COMMAND);
							if((tmp_addr + len) >= ((tmp_addr & ~(l2_icache_line_size - 1)) + l2_icache_line_size)) {
								l2_cache_trans[CORE0_ID].set_data_length(2 * l2_icache_line_size);
								l2_cache_trans[CORE0_ID].set_address(tmp_addr & ~(l2_icache_line_size - 1));
							} else {
								l2_cache_trans[CORE0_ID].set_data_length(l2_icache_line_size);
								l2_cache_trans[CORE0_ID].set_address(tmp_addr & ~(l2_icache_line_size - 1));
							}

							l2_cache_trans[CORE0_ID].set_data_ptr(l2_icache_buf[CORE0_ID]);
							l2_cache_trans[CORE0_ID].set_extension(&trans_extension_ptr[CORE0_ID]);

							if (pcore[GET_CORE(ext_ptr->inst_core_range)].flag == 1) {
								pcore[GET_CORE(ext_ptr->inst_core_range)].core_data.l2_pdata.cache_miss++;
								profile_soc_table.profile_core_table[CORE0_ID].generic_delay = 
										profile_soc_table.profile_core_table[CORE0_ID].generic_delay > l2_rd_delay ?
										profile_soc_table.profile_core_table[CORE0_ID].generic_delay: l2_rd_delay;
							}
#if 0
							static int pro_c = 0;
							printf("Miss %d\r\n",pro_c);
							fflush(stdout);
							pro_c++;
#endif

							ret = ddr_mem_init_socket->nb_transport_fw(l2_cache_trans[CORE0_ID], phase, t);

#if 0
							if((tmp_addr + len) >= ((tmp_addr & ~(l2_icache_line_size - 1)) + l2_icache_line_size)) {
								addr_line1 = (unsigned int)tmp_addr;
								addr_line2 = (unsigned int)((tmp_addr & ~(l2_icache_line_size -1)) + l2_icache_line_size);

								iaddr = *(struct l2_icache_addr *)&(addr_line1);
								l2_icache_mem[iaddr.index].flag.invalid = 0;
								l2_icache_mem[iaddr.index].flag.tag = iaddr.tag;

								iaddr = *(struct l2_icache_addr *)&(addr_line2);
								l2_icache_mem[iaddr.index].flag.invalid = 0;
								l2_icache_mem[iaddr.index].flag.tag = iaddr.tag;
							} else {
								addr_line1 = (unsigned int)tmp_addr;
								iaddr = *(struct l2_icache_addr *)&(tmp_addr);
								l2_icache_mem[iaddr.index].flag.invalid = 0;
								l2_icache_mem[iaddr.index].flag.tag = iaddr.tag;
							}
#else
							break;
#endif

						}
						addr++;
						ptr++;
					}

					wait(soc_core_req_event[CORE0_ID] | soc_core_req_event[CORE1_ID]
					 	| soc_core_req_event[CORE2_ID] | soc_core_req_event[CORE3_ID]);
					wait(sc_core::SC_ZERO_TIME);
					wait(sc_core::SC_ZERO_TIME);
#if 1
					if((tmp_addr + len) >= ((tmp_addr & ~(l2_icache_line_size - 1)) + l2_icache_line_size)) {
						addr_line1 = (unsigned int)tmp_addr;
						addr_line2 = (unsigned int)((tmp_addr & ~(l2_icache_line_size -1)) + l2_icache_line_size);

						iaddr = *(struct l2_icache_addr *)&(addr_line1);
						l2_icache_mem[iaddr.index].flag.invalid = 0;
						l2_icache_mem[iaddr.index].flag.tag = iaddr.tag;

						iaddr = *(struct l2_icache_addr *)&(addr_line2);
						l2_icache_mem[iaddr.index].flag.invalid = 0;
						l2_icache_mem[iaddr.index].flag.tag = iaddr.tag;
					} else {
						addr_line1 = (unsigned int)tmp_addr;
						iaddr = *(struct l2_icache_addr *)&(tmp_addr);
						l2_icache_mem[iaddr.index].flag.invalid = 0;
						l2_icache_mem[iaddr.index].flag.tag = iaddr.tag;
					}
#endif
					if (len <= l2_icache_line_size) {
						addr_line1 = (unsigned int)tmp_addr;
						iaddr = *(struct l2_icache_addr *)&(addr_line1);
						if (l2_sync[CORE0_ID] == 1)
							memcpy((unsigned char *)l2_icache_mem[iaddr.index].insn,
										(unsigned char *)l2_icache_buf[CORE0_ID], l2_icache_line_size);

						memcpy(tmp_ptr, (unsigned char *)l2_icache_mem[iaddr.index].insn, l2_icache_line_size);
					} else {
						addr_line1 = (unsigned int)tmp_addr;
						iaddr = *(struct l2_icache_addr *)&(addr_line1);
						if (l2_sync[CORE0_ID] == 1)
							memcpy((unsigned char *)l2_icache_mem[iaddr.index].insn,
										(unsigned char *)l2_icache_buf[CORE0_ID], l2_icache_line_size);

						memcpy(tmp_ptr, (unsigned char *)l2_icache_mem[iaddr.index].insn, l2_icache_line_size);

						addr_line2 = (unsigned int)((tmp_addr & ~(l2_icache_line_size -1)) + l2_icache_line_size);
						iaddr = *(struct l2_icache_addr *)&(addr_line2);
						if (l2_sync[CORE0_ID] == 1)
							memcpy((unsigned char *)l2_icache_mem[iaddr.index].insn,
											(unsigned char *)l2_icache_buf[CORE0_ID] + l2_icache_line_size, l2_icache_line_size);

						memcpy((tmp_ptr + l2_icache_line_size), (unsigned char *)l2_icache_mem[iaddr.index].insn, l2_icache_line_size);	
					}

					phase = tlm::BEGIN_RESP;
					PendingTransactionsIterator it = mPendingTransactions_C0.find(trans_ptr);
					//ret = l2_bus_targ_socket_tagged[it->second.from]->nb_transport_bw(*trans_ptr, phase, t);
					mPendingTransactions_C0.erase(it);
					notify_core_finish(CORE0_ID, 3); //INST_IF
				}
			}
		}

		void L2_Bus_Request_Thread_C1()
		{
			unsigned int i, len;
			unsigned char *ptr, *tmp_ptr;
			tlm::tlm_sync_enum ret;
			tlm::tlm_generic_payload * trans_ptr;
			trans_extension *ext_ptr;
			unsigned int addr_line2, addr_line1;
			struct l2_icache_addr iaddr;
			while (true) {
				wait(l2_bus_RequestPEQ_C1.get_event());

				l2_sync[CORE1_ID] = 0;
				trans_ptr = l2_bus_RequestPEQ_C1.get_next_transaction();

				tlm::tlm_phase phase = tlm::BEGIN_REQ;
				sc_core::sc_time t = sc_core::SC_ZERO_TIME;
				tlm::tlm_command cmd = trans_ptr->get_command();
				sc_dt::uint64 addr = trans_ptr->get_address();
				sc_dt::uint64 tmp_addr = addr;
				trans_ptr->get_extension(ext_ptr);
				ptr = trans_ptr->get_data_ptr();
				tmp_ptr = ptr;
				len = trans_ptr->get_data_length();

				if (cmd == tlm::TLM_READ_COMMAND) {
					for (i = 0; i < len; i++) {
						iaddr = *(struct l2_icache_addr *)&(addr);

						if ((l2_icache_mem[iaddr.index].flag.invalid == 1)
							|| (l2_icache_mem[iaddr.index].flag.tag != iaddr.tag)) {

							l2_sync[CORE1_ID] = 1;
							soc_core_req_bit_mask[CORE1_ID] |= 1 << 2;
							memcpy(&trans_extension_ptr[CORE1_ID], ext_ptr, sizeof(trans_extension));

							l2_cache_trans[CORE1_ID].set_command(tlm::TLM_READ_COMMAND);
							if((tmp_addr + len) >= ((tmp_addr & ~(l2_icache_line_size - 1)) + l2_icache_line_size)) {
								l2_cache_trans[CORE1_ID].set_data_length(2 * l2_icache_line_size);
								l2_cache_trans[CORE1_ID].set_address(tmp_addr & ~(l2_icache_line_size - 1));
							} else {
								l2_cache_trans[CORE1_ID].set_data_length(l2_icache_line_size);
								l2_cache_trans[CORE1_ID].set_address(tmp_addr & ~(l2_icache_line_size - 1));
							}

							l2_cache_trans[CORE1_ID].set_data_ptr(l2_icache_buf[CORE1_ID]);
							l2_cache_trans[CORE1_ID].set_extension(&trans_extension_ptr[CORE1_ID]);

							if (pcore[GET_CORE(ext_ptr->inst_core_range)].flag == 1) {
								pcore[GET_CORE(ext_ptr->inst_core_range)].core_data.l2_pdata.cache_miss++;
								profile_soc_table.profile_core_table[CORE1_ID].generic_delay = 
										profile_soc_table.profile_core_table[CORE1_ID].generic_delay > l2_rd_delay ?
										profile_soc_table.profile_core_table[CORE1_ID].generic_delay: l2_rd_delay;
							}
							
							ret = ddr_mem_init_socket->nb_transport_fw(l2_cache_trans[CORE1_ID], phase, t);
#if 0
							if((tmp_addr + len) >= ((tmp_addr & ~(l2_icache_line_size - 1)) + l2_icache_line_size)) {
								addr_line1 = (unsigned int)tmp_addr;
								addr_line2 = (unsigned int)((tmp_addr & ~(l2_icache_line_size -1)) + l2_icache_line_size);

								iaddr = *(struct l2_icache_addr *)&(addr_line1);
								l2_icache_mem[iaddr.index].flag.invalid = 0;
								l2_icache_mem[iaddr.index].flag.tag = iaddr.tag;

								iaddr = *(struct l2_icache_addr *)&(addr_line2);
								l2_icache_mem[iaddr.index].flag.invalid = 0;
								l2_icache_mem[iaddr.index].flag.tag = iaddr.tag;
							} else {
								addr_line1 = (unsigned int)tmp_addr;
								iaddr = *(struct l2_icache_addr *)&(tmp_addr);
								l2_icache_mem[iaddr.index].flag.invalid = 0;
								l2_icache_mem[iaddr.index].flag.tag = iaddr.tag;
							}
#else
							break;
#endif

						}
						addr++;
						ptr++;
					}

					wait(soc_core_req_event[CORE0_ID] | soc_core_req_event[CORE1_ID]
					 	| soc_core_req_event[CORE2_ID] | soc_core_req_event[CORE3_ID]);
					wait(sc_core::SC_ZERO_TIME);
					wait(sc_core::SC_ZERO_TIME);
#if 1
					if((tmp_addr + len) >= ((tmp_addr & ~(l2_icache_line_size - 1)) + l2_icache_line_size)) {
						addr_line1 = (unsigned int)tmp_addr;
						addr_line2 = (unsigned int)((tmp_addr & ~(l2_icache_line_size -1)) + l2_icache_line_size);

						iaddr = *(struct l2_icache_addr *)&(addr_line1);
						l2_icache_mem[iaddr.index].flag.invalid = 0;
						l2_icache_mem[iaddr.index].flag.tag = iaddr.tag;

						iaddr = *(struct l2_icache_addr *)&(addr_line2);
						l2_icache_mem[iaddr.index].flag.invalid = 0;
						l2_icache_mem[iaddr.index].flag.tag = iaddr.tag;
					} else {
						addr_line1 = (unsigned int)tmp_addr;
						iaddr = *(struct l2_icache_addr *)&(tmp_addr);
						l2_icache_mem[iaddr.index].flag.invalid = 0;
						l2_icache_mem[iaddr.index].flag.tag = iaddr.tag;
					}
#endif

					if (len <= l2_icache_line_size) {
						addr_line1 = (unsigned int)tmp_addr;
						iaddr = *(struct l2_icache_addr *)&(addr_line1);
						if (l2_sync[CORE1_ID] == 1)
							memcpy((unsigned char *)l2_icache_mem[iaddr.index].insn,
										(unsigned char *)l2_icache_buf[CORE1_ID], l2_icache_line_size);

						memcpy(tmp_ptr, (unsigned char *)l2_icache_mem[iaddr.index].insn, l2_icache_line_size);
					} else {
						addr_line1 = (unsigned int)tmp_addr;
						iaddr = *(struct l2_icache_addr *)&(addr_line1);
						if (l2_sync[CORE1_ID] == 1)
							memcpy((unsigned char *)l2_icache_mem[iaddr.index].insn,
										(unsigned char *)l2_icache_buf[CORE1_ID], l2_icache_line_size);

						memcpy(tmp_ptr, (unsigned char *)l2_icache_mem[iaddr.index].insn, l2_icache_line_size);

						addr_line2 = (unsigned int)((tmp_addr & ~(l2_icache_line_size -1)) + l2_icache_line_size);
						iaddr = *(struct l2_icache_addr *)&(addr_line2);
						if (l2_sync[CORE1_ID] == 1)
							memcpy((unsigned char *)l2_icache_mem[iaddr.index].insn,
											(unsigned char *)l2_icache_buf[CORE1_ID] + l2_icache_line_size, l2_icache_line_size);

						memcpy((tmp_ptr + l2_icache_line_size), (unsigned char *)l2_icache_mem[iaddr.index].insn, l2_icache_line_size);	
					}

					phase = tlm::BEGIN_RESP;
					PendingTransactionsIterator it = mPendingTransactions_C1.find(trans_ptr);
					//ret = l2_bus_targ_socket_tagged[it->second.from]->nb_transport_bw(*trans_ptr, phase, t);
					mPendingTransactions_C1.erase(it);
					notify_core_finish(CORE1_ID, 3); //INST_IF
				}
			}
		}

		void L2_Bus_Request_Thread_C2()
		{
			unsigned int i, len;
			unsigned char *ptr, *tmp_ptr;
			tlm::tlm_sync_enum ret;
			tlm::tlm_generic_payload * trans_ptr;
			trans_extension *ext_ptr;
			unsigned int addr_line2, addr_line1;
			struct l2_icache_addr iaddr;
			while (true) {
				wait(l2_bus_RequestPEQ_C2.get_event());

				l2_sync[CORE2_ID] = 0;
				trans_ptr = l2_bus_RequestPEQ_C2.get_next_transaction();

				tlm::tlm_phase phase = tlm::BEGIN_REQ;
				sc_core::sc_time t = sc_core::SC_ZERO_TIME;
				tlm::tlm_command cmd = trans_ptr->get_command();
				sc_dt::uint64 addr = trans_ptr->get_address();
				sc_dt::uint64 tmp_addr = addr;
				trans_ptr->get_extension(ext_ptr);
				ptr = trans_ptr->get_data_ptr();
				tmp_ptr = ptr;
				len = trans_ptr->get_data_length();

				if (cmd == tlm::TLM_READ_COMMAND) {
					for (i = 0; i < len; i++) {
						iaddr = *(struct l2_icache_addr *)&(addr);

						if ((l2_icache_mem[iaddr.index].flag.invalid == 1)
							|| (l2_icache_mem[iaddr.index].flag.tag != iaddr.tag)) {

							l2_sync[CORE2_ID] = 1;
							soc_core_req_bit_mask[CORE2_ID] |= 1 << 2;
							memcpy(&trans_extension_ptr[CORE2_ID], ext_ptr, sizeof(trans_extension));

							l2_cache_trans[CORE2_ID].set_command(tlm::TLM_READ_COMMAND);
							if((tmp_addr + len) >= ((tmp_addr & ~(l2_icache_line_size - 1)) + l2_icache_line_size)) {
								l2_cache_trans[CORE2_ID].set_data_length(2 * l2_icache_line_size);
								l2_cache_trans[CORE2_ID].set_address(tmp_addr & ~(l2_icache_line_size - 1));
							} else {
								l2_cache_trans[CORE2_ID].set_data_length(l2_icache_line_size);
								l2_cache_trans[CORE2_ID].set_address(tmp_addr & ~(l2_icache_line_size - 1));
							}

							l2_cache_trans[CORE2_ID].set_data_ptr(l2_icache_buf[CORE2_ID]);
							l2_cache_trans[CORE2_ID].set_extension(&trans_extension_ptr[CORE2_ID]);

							if (pcore[GET_CORE(ext_ptr->inst_core_range)].flag == 1) {
								pcore[GET_CORE(ext_ptr->inst_core_range)].core_data.l2_pdata.cache_miss++;
								profile_soc_table.profile_core_table[CORE2_ID].generic_delay = 
										profile_soc_table.profile_core_table[CORE2_ID].generic_delay > l2_rd_delay ?
										profile_soc_table.profile_core_table[CORE2_ID].generic_delay: l2_rd_delay;
							}
							
							ret = ddr_mem_init_socket->nb_transport_fw(l2_cache_trans[CORE2_ID], phase, t);

#if 0
							if((tmp_addr + len) >= ((tmp_addr & ~(l2_icache_line_size - 1)) + l2_icache_line_size)) {
								addr_line1 = (unsigned int)tmp_addr;
								addr_line2 = (unsigned int)((tmp_addr & ~(l2_icache_line_size -1)) + l2_icache_line_size);

								iaddr = *(struct l2_icache_addr *)&(addr_line1);
								l2_icache_mem[iaddr.index].flag.invalid = 0;
								l2_icache_mem[iaddr.index].flag.tag = iaddr.tag;

								iaddr = *(struct l2_icache_addr *)&(addr_line2);
								l2_icache_mem[iaddr.index].flag.invalid = 0;
								l2_icache_mem[iaddr.index].flag.tag = iaddr.tag;
							} else {
								addr_line1 = (unsigned int)tmp_addr;
								iaddr = *(struct l2_icache_addr *)&(tmp_addr);
								l2_icache_mem[iaddr.index].flag.invalid = 0;
								l2_icache_mem[iaddr.index].flag.tag = iaddr.tag;
							}
#else
							break;
#endif

						}
						addr++;
						ptr++;
					}

					wait(soc_core_req_event[CORE0_ID] | soc_core_req_event[CORE1_ID]
					 	| soc_core_req_event[CORE2_ID] | soc_core_req_event[CORE3_ID]);
					wait(sc_core::SC_ZERO_TIME);
					wait(sc_core::SC_ZERO_TIME);
#if 1
					if((tmp_addr + len) >= ((tmp_addr & ~(l2_icache_line_size - 1)) + l2_icache_line_size)) {
						addr_line1 = (unsigned int)tmp_addr;
						addr_line2 = (unsigned int)((tmp_addr & ~(l2_icache_line_size -1)) + l2_icache_line_size);

						iaddr = *(struct l2_icache_addr *)&(addr_line1);
						l2_icache_mem[iaddr.index].flag.invalid = 0;
						l2_icache_mem[iaddr.index].flag.tag = iaddr.tag;

						iaddr = *(struct l2_icache_addr *)&(addr_line2);
						l2_icache_mem[iaddr.index].flag.invalid = 0;
						l2_icache_mem[iaddr.index].flag.tag = iaddr.tag;
					} else {
						addr_line1 = (unsigned int)tmp_addr;
						iaddr = *(struct l2_icache_addr *)&(tmp_addr);
						l2_icache_mem[iaddr.index].flag.invalid = 0;
						l2_icache_mem[iaddr.index].flag.tag = iaddr.tag;
					}
#endif

					if (len <= l2_icache_line_size) {
						addr_line1 = (unsigned int)tmp_addr;
						iaddr = *(struct l2_icache_addr *)&(addr_line1);
						if (l2_sync[CORE2_ID] == 1)
							memcpy((unsigned char *)l2_icache_mem[iaddr.index].insn,
										(unsigned char *)l2_icache_buf[CORE2_ID], l2_icache_line_size);

						memcpy(tmp_ptr, (unsigned char *)l2_icache_mem[iaddr.index].insn, l2_icache_line_size);
					} else {
						addr_line1 = (unsigned int)tmp_addr;
						iaddr = *(struct l2_icache_addr *)&(addr_line1);
						if (l2_sync[CORE2_ID] == 1)
							memcpy((unsigned char *)l2_icache_mem[iaddr.index].insn,
										(unsigned char *)l2_icache_buf[CORE2_ID], l2_icache_line_size);

						memcpy(tmp_ptr, (unsigned char *)l2_icache_mem[iaddr.index].insn, l2_icache_line_size);

						addr_line2 = (unsigned int)((tmp_addr & ~(l2_icache_line_size -1)) + l2_icache_line_size);
						iaddr = *(struct l2_icache_addr *)&(addr_line2);
						if (l2_sync[CORE2_ID] == 1)
							memcpy((unsigned char *)l2_icache_mem[iaddr.index].insn,
											(unsigned char *)l2_icache_buf[CORE2_ID] + l2_icache_line_size, l2_icache_line_size);

						memcpy((tmp_ptr + l2_icache_line_size), (unsigned char *)l2_icache_mem[iaddr.index].insn, l2_icache_line_size);	
					}

					phase = tlm::BEGIN_RESP;
					PendingTransactionsIterator it = mPendingTransactions_C2.find(trans_ptr);
					//ret = l2_bus_targ_socket_tagged[it->second.from]->nb_transport_bw(*trans_ptr, phase, t);
					mPendingTransactions_C2.erase(it);
					notify_core_finish(CORE2_ID, 3); //INST_IF
				}
			}
		}

		void L2_Bus_Request_Thread_C3()
		{
			unsigned int i, len;
			unsigned char *ptr, *tmp_ptr;
			tlm::tlm_sync_enum ret;
			tlm::tlm_generic_payload * trans_ptr;
			trans_extension *ext_ptr;
			unsigned int addr_line2, addr_line1;
			struct l2_icache_addr iaddr;
			while (true) {
				wait(l2_bus_RequestPEQ_C3.get_event());

				l2_sync[CORE3_ID] = 0;
				trans_ptr = l2_bus_RequestPEQ_C3.get_next_transaction();

				tlm::tlm_phase phase = tlm::BEGIN_REQ;
				sc_core::sc_time t = sc_core::SC_ZERO_TIME;
				tlm::tlm_command cmd = trans_ptr->get_command();
				sc_dt::uint64 addr = trans_ptr->get_address();
				sc_dt::uint64 tmp_addr = addr;
				trans_ptr->get_extension(ext_ptr);
				ptr = trans_ptr->get_data_ptr();
				tmp_ptr = ptr;
				len = trans_ptr->get_data_length();

				if (cmd == tlm::TLM_READ_COMMAND) {
					for (i = 0; i < len; i++) {
						iaddr = *(struct l2_icache_addr *)&(addr);

						if ((l2_icache_mem[iaddr.index].flag.invalid == 1)
							|| (l2_icache_mem[iaddr.index].flag.tag != iaddr.tag)) {

							l2_sync[CORE3_ID] = 1;
							soc_core_req_bit_mask[CORE3_ID] |= 1 << 2;
							memcpy(&trans_extension_ptr[CORE3_ID], ext_ptr, sizeof(trans_extension));

							l2_cache_trans[CORE3_ID].set_command(tlm::TLM_READ_COMMAND);
							if((tmp_addr + len) >= ((tmp_addr & ~(l2_icache_line_size - 1)) + l2_icache_line_size)) {
								l2_cache_trans[CORE3_ID].set_data_length(2 * l2_icache_line_size);
								l2_cache_trans[CORE3_ID].set_address(tmp_addr & ~(l2_icache_line_size - 1));
							} else {
								l2_cache_trans[CORE3_ID].set_data_length(l2_icache_line_size);
								l2_cache_trans[CORE3_ID].set_address(tmp_addr & ~(l2_icache_line_size - 1));
							}

							l2_cache_trans[CORE3_ID].set_data_ptr(l2_icache_buf[CORE3_ID]);
							l2_cache_trans[CORE3_ID].set_extension(&trans_extension_ptr[CORE3_ID]);

							if (pcore[GET_CORE(ext_ptr->inst_core_range)].flag == 1) {
								pcore[GET_CORE(ext_ptr->inst_core_range)].core_data.l2_pdata.cache_miss++;
								profile_soc_table.profile_core_table[CORE3_ID].generic_delay = 
										profile_soc_table.profile_core_table[CORE3_ID].generic_delay > l2_rd_delay ?
										profile_soc_table.profile_core_table[CORE3_ID].generic_delay: l2_rd_delay;
							}
							
							ret = ddr_mem_init_socket->nb_transport_fw(l2_cache_trans[CORE3_ID], phase, t);
#if 0
							if((tmp_addr + len) >= ((tmp_addr & ~(l2_icache_line_size - 1)) + l2_icache_line_size)) {
								addr_line1 = (unsigned int)tmp_addr;
								addr_line2 = (unsigned int)((tmp_addr & ~(l2_icache_line_size -1)) + l2_icache_line_size);

								iaddr = *(struct l2_icache_addr *)&(addr_line1);
								l2_icache_mem[iaddr.index].flag.invalid = 0;
								l2_icache_mem[iaddr.index].flag.tag = iaddr.tag;

								iaddr = *(struct l2_icache_addr *)&(addr_line2);
								l2_icache_mem[iaddr.index].flag.invalid = 0;
								l2_icache_mem[iaddr.index].flag.tag = iaddr.tag;
							} else {
								addr_line1 = (unsigned int)tmp_addr;
								iaddr = *(struct l2_icache_addr *)&(tmp_addr);
								l2_icache_mem[iaddr.index].flag.invalid = 0;
								l2_icache_mem[iaddr.index].flag.tag = iaddr.tag;
							}
#else
							break;
#endif

						}
						addr++;
						ptr++;
					}

					wait(soc_core_req_event[CORE0_ID] | soc_core_req_event[CORE1_ID]
					 	| soc_core_req_event[CORE2_ID] | soc_core_req_event[CORE3_ID]);
					wait(sc_core::SC_ZERO_TIME);
					wait(sc_core::SC_ZERO_TIME);
#if 1
					if((tmp_addr + len) >= ((tmp_addr & ~(l2_icache_line_size - 1)) + l2_icache_line_size)) {
						addr_line1 = (unsigned int)tmp_addr;
						addr_line2 = (unsigned int)((tmp_addr & ~(l2_icache_line_size -1)) + l2_icache_line_size);

						iaddr = *(struct l2_icache_addr *)&(addr_line1);
						l2_icache_mem[iaddr.index].flag.invalid = 0;
						l2_icache_mem[iaddr.index].flag.tag = iaddr.tag;

						iaddr = *(struct l2_icache_addr *)&(addr_line2);
						l2_icache_mem[iaddr.index].flag.invalid = 0;
						l2_icache_mem[iaddr.index].flag.tag = iaddr.tag;
					} else {
						addr_line1 = (unsigned int)tmp_addr;
						iaddr = *(struct l2_icache_addr *)&(tmp_addr);
						l2_icache_mem[iaddr.index].flag.invalid = 0;
						l2_icache_mem[iaddr.index].flag.tag = iaddr.tag;
					}
#endif

					if (len <= l2_icache_line_size) {
						addr_line1 = (unsigned int)tmp_addr;
						iaddr = *(struct l2_icache_addr *)&(addr_line1);
						if (l2_sync[CORE3_ID] == 1)
							memcpy((unsigned char *)l2_icache_mem[iaddr.index].insn,
										(unsigned char *)l2_icache_buf[CORE3_ID], l2_icache_line_size);

						memcpy(tmp_ptr, (unsigned char *)l2_icache_mem[iaddr.index].insn, l2_icache_line_size);
					} else {
						addr_line1 = (unsigned int)tmp_addr;
						iaddr = *(struct l2_icache_addr *)&(addr_line1);
						if (l2_sync[CORE3_ID] == 1)
							memcpy((unsigned char *)l2_icache_mem[iaddr.index].insn,
										(unsigned char *)l2_icache_buf[CORE3_ID], l2_icache_line_size);

						memcpy(tmp_ptr, (unsigned char *)l2_icache_mem[iaddr.index].insn, l2_icache_line_size);

						addr_line2 = (unsigned int)((tmp_addr & ~(l2_icache_line_size -1)) + l2_icache_line_size);
						iaddr = *(struct l2_icache_addr *)&(addr_line2);
						if (l2_sync[CORE3_ID] == 1)
							memcpy((unsigned char *)l2_icache_mem[iaddr.index].insn,
											(unsigned char *)l2_icache_buf[CORE3_ID] + l2_icache_line_size, l2_icache_line_size);

						memcpy((tmp_ptr + l2_icache_line_size), (unsigned char *)l2_icache_mem[iaddr.index].insn, l2_icache_line_size);	
					}

					phase = tlm::BEGIN_RESP;
					PendingTransactionsIterator it = mPendingTransactions_C3.find(trans_ptr);
					//ret = l2_bus_targ_socket_tagged[it->second.from]->nb_transport_bw(*trans_ptr, phase, t);
					mPendingTransactions_C3.erase(it);
					notify_core_finish(CORE3_ID, 3); //INST_IF
				}
			}
		}





		tlm::tlm_sync_enum nb_transport_fw(int id, tlm::tlm_generic_payload &trans, 
						tlm::tlm_phase & phase, sc_core::sc_time & t)
		{
			if (phase == tlm::BEGIN_REQ) {
				
				switch (id) {
				case CORE0_ID:
					addPendingTransaction(trans, 0, id);
					l2_bus_RequestPEQ_C0.notify(trans, t);
					break;
				case CORE1_ID:
					addPendingTransaction(trans, 0, id);
					l2_bus_RequestPEQ_C1.notify(trans, t);
					break;
				case CORE2_ID:
					addPendingTransaction(trans, 0, id);
					l2_bus_RequestPEQ_C2.notify(trans, t);
					break;
				case CORE3_ID:
					addPendingTransaction(trans, 0, id);
					l2_bus_RequestPEQ_C3.notify(trans, t);
					break;
				default:
					break;
				}
			}

			return tlm::TLM_ACCEPTED;
		}

		tlm::tlm_sync_enum nb_transport_bw(tlm::tlm_generic_payload &trans, 
						tlm::tlm_phase & phase, sc_core::sc_time & t)
		{
			if (phase == tlm::BEGIN_RESP) {
				ddr_mem_ResponsePEQ.notify(trans, t);
			}

			return tlm::TLM_ACCEPTED;
		}

		void b_transport(int id, tlm::tlm_generic_payload & trans, sc_time & delay)
		{
			tlm::tlm_command cmd = trans.get_command();
			//sc_dt::uint64 addr = trans.get_address();
			//unsigned int len = trans.get_data_length();
			//unsigned char *ptr = trans.get_data_ptr();;
			
			if (cmd == tlm::TLM_WRITE_COMMAND) {
			//	if (addr != 0) {
			//		if (len <= l2_icache_line_size) {
			//			struct l2_icache_addr iaddr = *(struct l2_icache_addr *)&(addr);
			//			if (debug_inst != 0)
			//				memcpy((unsigned char *)l2_icache_mem[iaddr.index].insn, (unsigned char *)l2_icache_buf[id], l2_icache_line_size);
			//			memcpy(ptr, (unsigned char *)l2_icache_mem[iaddr.index].insn, l2_icache_line_size);
			//		} else {
			//			struct l2_icache_addr iaddr = *(struct l2_icache_addr *)&(addr);
			//			if (debug_inst != 0)
			//				memcpy((unsigned char *)l2_icache_mem[iaddr.index].insn, (unsigned char *)l2_icache_buf[id], l2_icache_line_size);
			//			memcpy(ptr, (unsigned char *)l2_icache_mem[iaddr.index].insn, l2_icache_line_size);

			//			unsigned int addr_line2 = (addr & ~(l2_icache_line_size -1)) + l2_icache_line_size;
			//			struct l2_icache_addr iaddr_line2 = *(struct l2_icache_addr *)&(addr_line2);
			//			if (debug_inst != 0)
			//				memcpy((unsigned char *)l2_icache_mem[iaddr_line2.index].insn, (unsigned char *)l2_icache_buf[id] + l2_icache_line_size, l2_icache_line_size);
			//			memcpy((ptr + l2_icache_line_size), (unsigned char *)l2_icache_mem[iaddr_line2.index].insn, l2_icache_line_size);	
			//		}
			//	} else {
				for (unsigned int i = 0; i < (l2_icache_size / l2_icache_line_size); i++) {
					l2_icache_mem[i].flag.tag = 0;
					l2_icache_mem[i].flag.index = 0;
					l2_icache_mem[i].flag.invalid = 1;
				}
			}
			//}
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
				break;
			}
		}

		struct ConnectionInfo {
			int from;
			int to;
		};

		typedef std::map < tlm::tlm_generic_payload *, ConnectionInfo > PendingTransactions;

		typedef PendingTransactions::iterator PendingTransactionsIterator;

		PendingTransactions mPendingTransactions_C0;
		PendingTransactions mPendingTransactions_C1;
		PendingTransactions mPendingTransactions_C2;
		PendingTransactions mPendingTransactions_C3;
};
#endif


#endif
