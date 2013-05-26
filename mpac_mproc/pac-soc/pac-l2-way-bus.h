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

struct icache_replace {
	unsigned int max_lru_count;
	unsigned int block;
	unsigned int hit;
};

#ifdef  PAC_2WAY_ICACHE_LINE //2-WAY
#define GROUP_WAY 2
struct l2_icache_addr {
	unsigned int offset:8;
	unsigned int group:7;
	unsigned int line:1;
	unsigned int tag:16;
};

struct l2_icache_flag {
	unsigned int invalid:1;
	unsigned int lru_count:7;
	unsigned int group:7;
	unsigned int line:1;
	unsigned int tag:16;
};
#elif PAC_4WAY_ICACHE_LINE //4-WAY 
#define GROUP_WAY 4
struct l2_icache_addr {
	unsigned int offset:8;
	unsigned int group:6;
	unsigned int line:2;
	unsigned int tag:16;
};

struct l2_icache_flag {
	unsigned int invalid:1;
	unsigned int lru_count:7;
	unsigned int group:6;
	unsigned int line:2;
	unsigned int tag:16;
};

#elif PAC_8WAY_ICACHE_LINE //8-WAY
#define GROUP_WAY 8
struct l2_icache_addr {
	unsigned int offset:8;
	unsigned int group:5;
	unsigned int line:3;
	unsigned int tag:16;
};

struct l2_icache_flag {
	unsigned int invalid:1;
	unsigned int lru_count:7;
	unsigned int group:5;
	unsigned int line:3;
	unsigned int tag:16;
};
#endif

struct l2_icache_line {
	struct l2_icache_flag flag;
	unsigned char *insn;
};

struct l2_icache_group {
	struct l2_icache_line icache_line[GROUP_WAY];
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

		struct l2_icache_group *l2_icache_mem;
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

			l2_icache_mem = new l2_icache_group[l2_icache_size / l2_icache_line_size / GROUP_WAY];
			unsigned int gb = 0;
			for (i = 0; i < (l2_icache_size / l2_icache_line_size / GROUP_WAY); i++) {
				gb = GROUP_WAY;
 				while(gb--) {
					l2_icache_mem[i].icache_line[gb].insn = new unsigned char[l2_icache_line_size];
					l2_icache_mem[i].icache_line[gb].flag.tag = 0;
					l2_icache_mem[i].icache_line[gb].flag.group = i;
					l2_icache_mem[i].icache_line[gb].flag.lru_count = 0;
					l2_icache_mem[i].icache_line[gb].flag.invalid = 1;
					l2_icache_mem[i].icache_line[gb].flag.line = 0;
				}
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
			struct icache_replace ir_data;
			unsigned int gb, max_lru_count;
			unsigned int block_num, hit;

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
					gb = 0;
					block_num = 0;
					hit = 0;
					max_lru_count = 0;

					if (cmd == tlm::TLM_READ_COMMAND) {
						for (i = 0; i < len; i+=l2_icache_line_size) {
							struct l2_icache_addr iaddr = *(struct l2_icache_addr *)&(addr);
							for (block_num = 0; block_num < GROUP_WAY; block_num++) {
								if ((l2_icache_mem[iaddr.group].icache_line[block_num].flag.invalid == 0)
										&& (l2_icache_mem[iaddr.group].icache_line[block_num].flag.tag == iaddr.tag)
										&& (l2_icache_mem[iaddr.group].icache_line[block_num].flag.line == iaddr.line)) {	
									memcpy(ptr, l2_icache_mem[iaddr.group].icache_line[block_num].insn, l2_icache_line_size);
									l2_icache_mem[iaddr.group].icache_line[block_num].flag.lru_count = 0;
									gb = GROUP_WAY;	
									while (gb--) {
										if (gb == block_num)
												continue;
	
										l2_icache_mem[iaddr.group].icache_line[gb].flag.lru_count++;
									}
									hit = 1;
								}
							}
						
							if (hit == 0) {
								tlm::tlm_generic_payload l2_cache_trans;
								trans_extension *trans_extension_ptr = new trans_extension();
								memcpy(trans_extension_ptr, ext_ptr, sizeof(trans_extension));
								l2_cache_trans.set_command(tlm::TLM_READ_COMMAND);
								l2_cache_trans.set_address(addr & ~(l2_icache_line_size - 1));
	
								gb = GROUP_WAY;
								ir_data.max_lru_count = 0;
								ir_data.block = 0;
	
								while(gb--) {
									max_lru_count =
										max_lru_count 	
										>= l2_icache_mem[iaddr.group].icache_line[gb].flag.lru_count
										? max_lru_count
										: l2_icache_mem[iaddr.group].icache_line[gb].flag.lru_count ;
	
									if (max_lru_count != ir_data.max_lru_count) {
										ir_data.max_lru_count = max_lru_count;	
										ir_data.block = gb;
									}
								}

								l2_cache_trans.set_data_ptr(l2_icache_mem[iaddr.group].icache_line[ir_data.block].insn);
								l2_icache_mem[iaddr.group].icache_line[ir_data.block].flag.lru_count = 0;

								gb = GROUP_WAY;
								while(gb--) {
									if (gb == ir_data.block)
											continue;
					
									l2_icache_mem[iaddr.group].icache_line[gb].flag.lru_count++;
								}

								l2_cache_trans.set_data_length(l2_icache_line_size);
								l2_cache_trans.set_extension(trans_extension_ptr);
	
								if (pcore[GET_CORE(ext_ptr->inst_core_range)].flag == 1) {
									pcore[GET_CORE(ext_ptr->inst_core_range)].core_data.l2_pdata.cache_miss++;
								}
						
								ret = ddr_mem_init_socket->nb_transport_fw(l2_cache_trans, phase, t);
	
								wait(ddr_mem_ResponsePEQ.get_event());
								ddr_mem_ResponsePEQ.get_next_transaction();

								l2_icache_mem[iaddr.group].icache_line[ir_data.block].flag.invalid = 0;
								l2_icache_mem[iaddr.group].icache_line[ir_data.block].flag.line = iaddr.line;
								l2_icache_mem[iaddr.group].icache_line[ir_data.block].flag.tag = iaddr.tag;
						
#if 0
								static int pro_c = 0;
								printf("Miss %d\r\n",pro_c);
								fflush(stdout);
								pro_c++;
#endif
								memcpy(ptr, l2_icache_mem[iaddr.group].icache_line[ir_data.block].insn, l2_icache_line_size);
							}
							addr += l2_icache_line_size;
							ptr += l2_icache_line_size;
							hit = 0;
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
			unsigned int gb;
			tlm::tlm_command cmd = trans.get_command();
			if (cmd == tlm::TLM_WRITE_COMMAND) {
				for (unsigned int i = 0; i < (l2_icache_size / l2_icache_line_size / GROUP_WAY); i++) {
					gb = GROUP_WAY;
					while (gb--) {
						l2_icache_mem[i].icache_line[gb].flag.tag = 0;
						l2_icache_mem[i].icache_line[gb].flag.group = i;
						l2_icache_mem[i].icache_line[gb].flag.lru_count = 0;
						l2_icache_mem[i].icache_line[gb].flag.invalid = 1;
						l2_icache_mem[i].icache_line[gb].flag.line = 0;
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

		struct l2_icache_group *l2_icache_mem;
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

			l2_icache_mem = new l2_icache_group[l2_icache_size / l2_icache_line_size / 2];
			unsigned int gb = 0;

			for (i = 0; i < (l2_icache_size / l2_icache_line_size / GROUP_WAY); i++) {
				gb = GROUP_WAY;
 				while(gb--) {
					l2_icache_mem[i].icache_line[gb].insn = new unsigned char[l2_icache_line_size];
					l2_icache_mem[i].icache_line[gb].flag.tag = 0;
					l2_icache_mem[i].icache_line[gb].flag.group = i;
					l2_icache_mem[i].icache_line[gb].flag.lru_count = 0;
					l2_icache_mem[i].icache_line[gb].flag.invalid = 1;
					l2_icache_mem[i].icache_line[gb].flag.line = 0;
				}
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
			tlm::tlm_generic_payload *trans_ptr;
			trans_extension *ext_ptr;
			unsigned int addr_line1, addr_line2;
			struct l2_icache_addr iaddr, iaddr_line1, iaddr_line2;
			struct icache_replace ir_data_line1;
			struct icache_replace ir_data_line2;
			unsigned int gb, max_lru_count;
			unsigned int block_num, hit;

			while(true) {
				wait(l2_bus_RequestPEQ_C0.get_event());

				//while (true) {
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
					memset(&ir_data_line1, 0 , sizeof(struct icache_replace));
					memset(&ir_data_line2, 0 , sizeof(struct icache_replace));
	
					gb = 0;
					block_num = 0;
					hit = 0;
					max_lru_count = 0;
	
					if (cmd == tlm::TLM_READ_COMMAND) {
						for (i = 0; i < len; i += l2_icache_line_size) {
							iaddr = *(struct l2_icache_addr *)&addr;
							for (block_num = 0; block_num < GROUP_WAY; block_num++) {
								if ((l2_icache_mem[iaddr.group].icache_line[block_num].flag.invalid == 0)
										&& (l2_icache_mem[iaddr.group].icache_line[block_num].flag.tag == iaddr.tag)
										&& (l2_icache_mem[iaddr.group].icache_line[block_num].flag.line == iaddr.line)) {	
//Hit
									l2_icache_mem[iaddr.group].icache_line[block_num].flag.lru_count = 0;
	
	
									if (addr == tmp_addr) {
										ir_data_line1.block = block_num;
										if (ir_data_line1.hit == 0) {
											gb = GROUP_WAY;
											while(gb--) {
												if (gb == block_num)
													continue;
				
												l2_icache_mem[iaddr.group].icache_line[gb].flag.lru_count++;
											}
										ir_data_line1.hit = 1;
										}
									} else {
										ir_data_line2.block = block_num;
										if (ir_data_line2.hit == 0) {
											gb = GROUP_WAY;
											while(gb--) {
												if (gb == block_num)
													continue;
				
												l2_icache_mem[iaddr.group].icache_line[gb].flag.lru_count++;
											}
	
										}
										ir_data_line2.hit = 1;
									}
									hit = 1;
								}
							}
	
							if (hit == 0) {
//Miss
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
	
								if ((tmp_addr + len) >= ((tmp_addr & ~(l2_icache_line_size - 1)) + l2_icache_line_size)) {
//Read 2 LINE										
//LINE 1
									addr_line1 = (unsigned int)tmp_addr;
									iaddr_line1 = *(struct l2_icache_addr *)&addr_line1;
									for (block_num = 0; block_num < GROUP_WAY; block_num++) {
										if ((l2_icache_mem[iaddr_line1.group].icache_line[block_num].flag.invalid == 0)
											&& (l2_icache_mem[iaddr_line1.group].icache_line[block_num].flag.tag == iaddr_line1.tag)
											&& (l2_icache_mem[iaddr_line1.group].icache_line[block_num].flag.line == iaddr_line1.line)) {

											ir_data_line1.hit = 1;
										}
									}
	
									if (ir_data_line1.hit == 0) {
										max_lru_count = 0;
										gb = GROUP_WAY;
	
										while(gb--) {
											max_lru_count =
												max_lru_count >= l2_icache_mem[iaddr_line1.group].icache_line[gb].flag.lru_count
												? max_lru_count
												: l2_icache_mem[iaddr_line1.group].icache_line[gb].flag.lru_count;
	
											if (max_lru_count != ir_data_line1.max_lru_count) {
												ir_data_line1.max_lru_count = max_lru_count;
												ir_data_line1.block = gb;
											}
										}
	
										l2_icache_mem[iaddr_line1.group].icache_line[ir_data_line1.block].flag.invalid = 0;
										l2_icache_mem[iaddr_line1.group].icache_line[ir_data_line1.block].flag.line = iaddr_line1.line;
										l2_icache_mem[iaddr_line1.group].icache_line[ir_data_line1.block].flag.tag = iaddr_line1.tag;
										l2_icache_mem[iaddr_line1.group].icache_line[ir_data_line1.block].flag.lru_count = 0;
										gb = GROUP_WAY;
										while(gb--) {
											if (gb == ir_data_line1.block)
												continue;
	
											l2_icache_mem[iaddr_line1.group].icache_line[gb].flag.lru_count++;
										}
										ir_data_line1.hit = 1;
									}
//LINE 2							
									addr_line2 = (unsigned int)((tmp_addr & ~(l2_icache_line_size -1)) + l2_icache_line_size);
									iaddr_line2 = *(struct l2_icache_addr *)&addr_line2;
									for (block_num = 0; block_num < GROUP_WAY; block_num++) {
										if ((l2_icache_mem[iaddr_line2.group].icache_line[block_num].flag.invalid == 0)
											&& (l2_icache_mem[iaddr_line2.group].icache_line[block_num].flag.tag == iaddr_line2.tag)
											&& (l2_icache_mem[iaddr_line2.group].icache_line[block_num].flag.line == iaddr_line2.line)) {
	
											ir_data_line2.hit = 1;
										}
									}
	
									if (ir_data_line2.hit == 0) {
										max_lru_count = 0;
										gb = GROUP_WAY;
	
										while(gb--) {
											max_lru_count =
												max_lru_count >= l2_icache_mem[iaddr_line2.group].icache_line[gb].flag.lru_count
												? max_lru_count
												: l2_icache_mem[iaddr_line2.group].icache_line[gb].flag.lru_count;
	
											if (max_lru_count != ir_data_line2.max_lru_count) {
												ir_data_line2.max_lru_count = max_lru_count;
												ir_data_line2.block = gb;
											}
										}
	
										l2_icache_mem[iaddr_line2.group].icache_line[ir_data_line2.block].flag.invalid = 0;
										l2_icache_mem[iaddr_line2.group].icache_line[ir_data_line2.block].flag.line = iaddr_line2.line;
										l2_icache_mem[iaddr_line2.group].icache_line[ir_data_line2.block].flag.tag = iaddr_line2.tag;
										l2_icache_mem[iaddr_line2.group].icache_line[ir_data_line2.block].flag.lru_count = 0;
										gb = GROUP_WAY;
										while(gb--) {
											if (gb == ir_data_line2.block)
												continue;
	
											l2_icache_mem[iaddr_line2.group].icache_line[gb].flag.lru_count++;
										}
									}
									ir_data_line2.hit = 1;
								} else {
//Read 1 LINE										
//LINE 1
									if (ir_data_line1.hit == 0) {
										addr_line1 = (unsigned int)tmp_addr;
										max_lru_count = 0;
										gb = GROUP_WAY;
	
										while(gb--) {
											max_lru_count =
												max_lru_count >= l2_icache_mem[iaddr_line1.group].icache_line[gb].flag.lru_count
												? max_lru_count
												: l2_icache_mem[iaddr_line1.group].icache_line[gb].flag.lru_count;
	
											if (max_lru_count != ir_data_line1.max_lru_count) {
												ir_data_line1.max_lru_count = max_lru_count;
												ir_data_line1.block = gb;
											}
										}
	
										l2_icache_mem[iaddr_line1.group].icache_line[ir_data_line1.block].flag.invalid = 0;
										l2_icache_mem[iaddr_line1.group].icache_line[ir_data_line1.block].flag.line = iaddr_line1.line;
										l2_icache_mem[iaddr_line1.group].icache_line[ir_data_line1.block].flag.tag = iaddr_line1.tag;
										l2_icache_mem[iaddr_line1.group].icache_line[ir_data_line1.block].flag.lru_count = 0;
										gb = GROUP_WAY;
										while(gb--) {
											if (gb == ir_data_line1.block)
												continue;
	
											l2_icache_mem[iaddr_line1.group].icache_line[gb].flag.lru_count++;
										}
										ir_data_line1.hit = 1;
									}
								}
							}
							addr += l2_icache_line_size;
							ptr += l2_icache_line_size;
							hit = 0;
						}
					}
						
					wait(soc_core_req_event[CORE0_ID] | soc_core_req_event[CORE1_ID]
							| soc_core_req_event[CORE2_ID] | soc_core_req_event[CORE3_ID]);
					wait(sc_core::SC_ZERO_TIME);
					wait(sc_core::SC_ZERO_TIME);
//LINE 	1
					addr_line1 = (unsigned int)tmp_addr;
					iaddr_line1 = *(struct l2_icache_addr *)&addr_line1;
//LINE 	2					
					addr_line2 = (unsigned int)((tmp_addr & ~(l2_icache_line_size -1)) + l2_icache_line_size);
					iaddr_line2 = *(struct l2_icache_addr *)&addr_line2;
	
					if ((tmp_addr + len) >= ((tmp_addr & ~(l2_icache_line_size - 1)) + l2_icache_line_size)) {
//Sync L2 2 LINE							
						if (l2_sync[CORE0_ID] == 1) {
							memcpy(l2_icache_mem[iaddr_line1.group].icache_line[ir_data_line1.block].insn,
									l2_icache_buf[CORE0_ID], l2_icache_line_size);
	
							memcpy(l2_icache_mem[iaddr_line2.group].icache_line[ir_data_line2.block].insn,
									l2_icache_buf[CORE0_ID] + l2_icache_line_size, l2_icache_line_size);
						}
	
						memcpy(tmp_ptr, l2_icache_mem[iaddr_line1.group].icache_line[ir_data_line1.block].insn, l2_icache_line_size);
						memcpy(tmp_ptr + l2_icache_line_size, l2_icache_mem[iaddr_line2.group].icache_line[ir_data_line2.block].insn,
									l2_icache_line_size);
					} else {
//Sync L2 1 LINE							
						if (l2_sync[CORE0_ID] == 1) {
							memcpy(l2_icache_mem[iaddr_line1.group].icache_line[ir_data_line1.block].insn,
									l2_icache_buf[CORE0_ID], l2_icache_line_size);
	
							memcpy(tmp_ptr, l2_icache_mem[iaddr_line1.group].icache_line[ir_data_line1.block].insn,
									l2_icache_line_size);
						}
					}
					phase = tlm::BEGIN_RESP;
					PendingTransactionsIterator it = mPendingTransactions_C0.find(trans_ptr);
					mPendingTransactions_C0.erase(it);
					notify_core_finish(CORE0_ID, 3); 	//INST_IF
				//}
			}
		}

		void L2_Bus_Request_Thread_C1()
		{
			unsigned int i, len;
			unsigned char *ptr, *tmp_ptr;
			tlm::tlm_sync_enum ret;
			tlm::tlm_generic_payload *trans_ptr;
			trans_extension *ext_ptr;
			unsigned int addr_line1, addr_line2;
			struct l2_icache_addr iaddr, iaddr_line1, iaddr_line2;
			struct icache_replace ir_data_line1;
			struct icache_replace ir_data_line2;
			unsigned int gb, max_lru_count;
			unsigned int block_num, hit;

			while(true) {
				wait(l2_bus_RequestPEQ_C1.get_event());

				//while (true) {
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
					memset(&ir_data_line1, 0 , sizeof(struct icache_replace));
					memset(&ir_data_line2, 0 , sizeof(struct icache_replace));
	
					gb = 0;
					block_num = 0;
					hit = 0;
					max_lru_count = 0;
	
					if (cmd == tlm::TLM_READ_COMMAND) {
						for (i = 0; i < len; i += l2_icache_line_size) {
							iaddr = *(struct l2_icache_addr *)&addr;
							for (block_num = 0; block_num < GROUP_WAY; block_num++) {
								if ((l2_icache_mem[iaddr.group].icache_line[block_num].flag.invalid == 0)
									&& (l2_icache_mem[iaddr.group].icache_line[block_num].flag.tag == iaddr.tag)
									&& (l2_icache_mem[iaddr.group].icache_line[block_num].flag.line == iaddr.line)) {	
//Hit
									l2_icache_mem[iaddr.group].icache_line[block_num].flag.lru_count = 0;
	
	
									if (addr == tmp_addr) {
										ir_data_line1.block = block_num;
										if (ir_data_line1.hit == 0) {
											gb = GROUP_WAY;
											while(gb--) {
												if (gb == block_num)
													continue;
				
												l2_icache_mem[iaddr.group].icache_line[gb].flag.lru_count++;
											}
										ir_data_line1.hit = 1;
										}
									} else {
										ir_data_line2.block = block_num;
										if (ir_data_line2.hit == 0) {
											gb = GROUP_WAY;
											while(gb--) {
												if (gb == block_num)
													continue;
				
												l2_icache_mem[iaddr.group].icache_line[gb].flag.lru_count++;
											}
	
										}
										ir_data_line2.hit = 1;
									}
									hit = 1;
								}
							}
	
							if (hit == 0) {
//Miss
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
#if 0
								static int pro_c = 0;
	
								printf("Miss %d\r\n",pro_c);
								fflush(stdout);
								pro_c++;
#endif
	
								ret = ddr_mem_init_socket->nb_transport_fw(l2_cache_trans[CORE1_ID], phase, t);
	
								if ((tmp_addr + len) >= ((tmp_addr & ~(l2_icache_line_size - 1)) + l2_icache_line_size)) {
//Read 2 LINE										
//LINE 1
									addr_line1 = (unsigned int)tmp_addr;
									iaddr_line1 = *(struct l2_icache_addr *)&addr_line1;
									for (block_num = 0; block_num < GROUP_WAY; block_num++) {
										if ((l2_icache_mem[iaddr_line1.group].icache_line[block_num].flag.invalid == 0)
											&& (l2_icache_mem[iaddr_line1.group].icache_line[block_num].flag.tag == iaddr_line1.tag)
											&& (l2_icache_mem[iaddr_line1.group].icache_line[block_num].flag.line == iaddr_line1.line)) {
	
											ir_data_line1.hit = 1;
										}
									}
	
									if (ir_data_line1.hit == 0) {
										max_lru_count = 0;
										gb = GROUP_WAY;
	
										while(gb--) {
											max_lru_count =
												max_lru_count >= l2_icache_mem[iaddr_line1.group].icache_line[gb].flag.lru_count
												? max_lru_count
												: l2_icache_mem[iaddr_line1.group].icache_line[gb].flag.lru_count;
	
											if (max_lru_count != ir_data_line1.max_lru_count) {
												ir_data_line1.max_lru_count = max_lru_count;
												ir_data_line1.block = gb;
											}
										}
	
										l2_icache_mem[iaddr_line1.group].icache_line[ir_data_line1.block].flag.invalid = 0;
										l2_icache_mem[iaddr_line1.group].icache_line[ir_data_line1.block].flag.line = iaddr_line1.line;
										l2_icache_mem[iaddr_line1.group].icache_line[ir_data_line1.block].flag.tag = iaddr_line1.tag;
										l2_icache_mem[iaddr_line1.group].icache_line[ir_data_line1.block].flag.lru_count = 0;
										gb = GROUP_WAY;
										while(gb--) {
											if (gb == ir_data_line1.block)
												continue;
	
											l2_icache_mem[iaddr_line1.group].icache_line[gb].flag.lru_count++;
										}
										ir_data_line1.hit = 1;
									}
//LINE 2							
									addr_line2 = (unsigned int)((tmp_addr & ~(l2_icache_line_size -1)) + l2_icache_line_size);
									iaddr_line2 = *(struct l2_icache_addr *)&addr_line2;
									for (block_num = 0; block_num < GROUP_WAY; block_num++) {
										if ((l2_icache_mem[iaddr_line2.group].icache_line[block_num].flag.invalid == 0)
											&& (l2_icache_mem[iaddr_line2.group].icache_line[block_num].flag.tag == iaddr_line2.tag)
											&& (l2_icache_mem[iaddr_line2.group].icache_line[block_num].flag.line == iaddr_line2.line)) {
	
											ir_data_line2.hit = 1;
										}
									}
	
									if (ir_data_line2.hit == 0) {
										max_lru_count = 0;
										gb = GROUP_WAY;
	
										while(gb--) {
											max_lru_count =
												max_lru_count >= l2_icache_mem[iaddr_line2.group].icache_line[gb].flag.lru_count
												? max_lru_count
												: l2_icache_mem[iaddr_line2.group].icache_line[gb].flag.lru_count;
	
											if (max_lru_count != ir_data_line2.max_lru_count) {
												ir_data_line2.max_lru_count = max_lru_count;
												ir_data_line2.block = gb;
											}
										}
	
										l2_icache_mem[iaddr_line2.group].icache_line[ir_data_line2.block].flag.invalid = 0;
										l2_icache_mem[iaddr_line2.group].icache_line[ir_data_line2.block].flag.line = iaddr_line2.line;
										l2_icache_mem[iaddr_line2.group].icache_line[ir_data_line2.block].flag.tag = iaddr_line2.tag;
										l2_icache_mem[iaddr_line2.group].icache_line[ir_data_line2.block].flag.lru_count = 0;
										gb = GROUP_WAY;
										while(gb--) {
											if (gb == ir_data_line2.block)
												continue;
	
											l2_icache_mem[iaddr_line2.group].icache_line[gb].flag.lru_count++;
										}
									}
									ir_data_line2.hit = 1;
								} else {
//Read 1 LINE										
//LINE 1
									if (ir_data_line1.hit == 0) {
										addr_line1 = (unsigned int)tmp_addr;
										max_lru_count = 0;
										gb = GROUP_WAY;
	
										while(gb--) {
											max_lru_count =
												max_lru_count >= l2_icache_mem[iaddr_line1.group].icache_line[gb].flag.lru_count
												? max_lru_count
												: l2_icache_mem[iaddr_line1.group].icache_line[gb].flag.lru_count;
	
											if (max_lru_count != ir_data_line1.max_lru_count) {
												ir_data_line1.max_lru_count = max_lru_count;
												ir_data_line1.block = gb;
											}
										}
	
										l2_icache_mem[iaddr_line1.group].icache_line[ir_data_line1.block].flag.invalid = 0;
										l2_icache_mem[iaddr_line1.group].icache_line[ir_data_line1.block].flag.line = iaddr_line1.line;
										l2_icache_mem[iaddr_line1.group].icache_line[ir_data_line1.block].flag.tag = iaddr_line1.tag;
										l2_icache_mem[iaddr_line1.group].icache_line[ir_data_line1.block].flag.lru_count = 0;
										gb = GROUP_WAY;
										while(gb--) {
											if (gb == ir_data_line1.block)
												continue;
	
											l2_icache_mem[iaddr_line1.group].icache_line[gb].flag.lru_count++;
										}
										ir_data_line1.hit = 1;
									}
								}
							}
							addr += l2_icache_line_size;
							ptr += l2_icache_line_size;
							hit = 0;
						}
					}
						
					wait(soc_core_req_event[CORE0_ID] | soc_core_req_event[CORE1_ID]
							| soc_core_req_event[CORE2_ID] | soc_core_req_event[CORE3_ID]);
					wait(sc_core::SC_ZERO_TIME);
					wait(sc_core::SC_ZERO_TIME);
//LINE 1
					addr_line1 = (unsigned int)tmp_addr;
					iaddr_line1 = *(struct l2_icache_addr *)&addr_line1;
//LINE 2					
					addr_line2 = (unsigned int)((tmp_addr & ~(l2_icache_line_size -1)) + l2_icache_line_size);
					iaddr_line2 = *(struct l2_icache_addr *)&addr_line2;
	
					if ((tmp_addr + len) >= ((tmp_addr & ~(l2_icache_line_size - 1)) + l2_icache_line_size)) {
//Sync L2 2 LINE							
						if (l2_sync[CORE1_ID] == 1) {
							memcpy(l2_icache_mem[iaddr_line1.group].icache_line[ir_data_line1.block].insn,
									l2_icache_buf[CORE1_ID], l2_icache_line_size);
	
							memcpy(l2_icache_mem[iaddr_line2.group].icache_line[ir_data_line2.block].insn,
									l2_icache_buf[CORE1_ID] + l2_icache_line_size, l2_icache_line_size);
						}
	
						memcpy(tmp_ptr, l2_icache_mem[iaddr_line1.group].icache_line[ir_data_line1.block].insn, l2_icache_line_size);
						memcpy(tmp_ptr + l2_icache_line_size, l2_icache_mem[iaddr_line2.group].icache_line[ir_data_line2.block].insn,
									l2_icache_line_size);
					} else {
//Sync L2 1 LINE							
						if (l2_sync[CORE1_ID] == 1) {
							memcpy(l2_icache_mem[iaddr_line1.group].icache_line[ir_data_line1.block].insn,
									l2_icache_buf[CORE1_ID], l2_icache_line_size);
	
							memcpy(tmp_ptr, l2_icache_mem[iaddr_line1.group].icache_line[ir_data_line1.block].insn,
									l2_icache_line_size);
						}
					}
					phase = tlm::BEGIN_RESP;
					PendingTransactionsIterator it = mPendingTransactions_C1.find(trans_ptr);
					mPendingTransactions_C1.erase(it);
					notify_core_finish(CORE1_ID, 3); 	//INST_IF
				//}
			}
		}

		void L2_Bus_Request_Thread_C2()
		{
			unsigned int i, len;
			unsigned char *ptr, *tmp_ptr;
			tlm::tlm_sync_enum ret;
			tlm::tlm_generic_payload *trans_ptr;
			trans_extension *ext_ptr;
			unsigned int addr_line1, addr_line2;
			struct l2_icache_addr iaddr, iaddr_line1, iaddr_line2;
			struct icache_replace ir_data_line1;
			struct icache_replace ir_data_line2;
			unsigned int gb, max_lru_count;
			unsigned int block_num, hit;

			while(true) {
				wait(l2_bus_RequestPEQ_C2.get_event());
				
				//while (true) {
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
					memset(&ir_data_line1, 0 , sizeof(struct icache_replace));
					memset(&ir_data_line2, 0 , sizeof(struct icache_replace));
	
					gb = 0;
					block_num = 0;
					hit = 0;
					max_lru_count = 0;
	
					if (cmd == tlm::TLM_READ_COMMAND) {
						for (i = 0; i < len; i += l2_icache_line_size) {
							iaddr = *(struct l2_icache_addr *)&addr;
							for (block_num = 0; block_num < GROUP_WAY; block_num++) {
								if ((l2_icache_mem[iaddr.group].icache_line[block_num].flag.invalid == 0)
										&& (l2_icache_mem[iaddr.group].icache_line[block_num].flag.tag == iaddr.tag)
										&& (l2_icache_mem[iaddr.group].icache_line[block_num].flag.line == iaddr.line)) {	
//Hit
									l2_icache_mem[iaddr.group].icache_line[block_num].flag.lru_count = 0;
	
	
									if (addr == tmp_addr) {
										ir_data_line1.block = block_num;
										if (ir_data_line1.hit == 0) {
											gb = GROUP_WAY;
											while(gb--) {
												if (gb == block_num)
													continue;
				
												l2_icache_mem[iaddr.group].icache_line[gb].flag.lru_count++;
											}
										ir_data_line1.hit = 1;
										}
									} else {
										ir_data_line2.block = block_num;
										if (ir_data_line2.hit == 0) {
											gb = GROUP_WAY;
											while(gb--) {
												if (gb == block_num)
													continue;
				
												l2_icache_mem[iaddr.group].icache_line[gb].flag.lru_count++;
											}
	
										}
										ir_data_line2.hit = 1;
									}
									hit = 1;
								}
							}
	
							if (hit == 0) {
//Miss
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
#if 0
								static int pro_c = 0;
	
								printf("Miss %d\r\n",pro_c);
								fflush(stdout);
								pro_c++;
#endif

								ret = ddr_mem_init_socket->nb_transport_fw(l2_cache_trans[CORE2_ID], phase, t);
	
								if ((tmp_addr + len) >= ((tmp_addr & ~(l2_icache_line_size - 1)) + l2_icache_line_size)) {
//Read 2 LINE										
//LINE 1
									addr_line1 = (unsigned int)tmp_addr;
									iaddr_line1 = *(struct l2_icache_addr *)&addr_line1;
									for (block_num = 0; block_num < GROUP_WAY; block_num++) {
										if ((l2_icache_mem[iaddr_line1.group].icache_line[block_num].flag.invalid == 0)
											&& (l2_icache_mem[iaddr_line1.group].icache_line[block_num].flag.tag == iaddr_line1.tag)
											&& (l2_icache_mem[iaddr_line1.group].icache_line[block_num].flag.line == iaddr_line1.line)) {
	
											ir_data_line1.hit = 1;
										}
									}
	
									if (ir_data_line1.hit == 0) {
										max_lru_count = 0;
										gb = GROUP_WAY;
	
										while(gb--) {
											max_lru_count =
												max_lru_count >= l2_icache_mem[iaddr_line1.group].icache_line[gb].flag.lru_count
												? max_lru_count
												: l2_icache_mem[iaddr_line1.group].icache_line[gb].flag.lru_count;
	
											if (max_lru_count != ir_data_line1.max_lru_count) {
												ir_data_line1.max_lru_count = max_lru_count;
												ir_data_line1.block = gb;
											}
										}
	
										l2_icache_mem[iaddr_line1.group].icache_line[ir_data_line1.block].flag.invalid = 0;
										l2_icache_mem[iaddr_line1.group].icache_line[ir_data_line1.block].flag.line = iaddr_line1.line;
										l2_icache_mem[iaddr_line1.group].icache_line[ir_data_line1.block].flag.tag = iaddr_line1.tag;
										l2_icache_mem[iaddr_line1.group].icache_line[ir_data_line1.block].flag.lru_count = 0;
										gb = GROUP_WAY;
										while(gb--) {
											if (gb == ir_data_line1.block)
												continue;
	
											l2_icache_mem[iaddr_line1.group].icache_line[gb].flag.lru_count++;
										}
										ir_data_line1.hit = 1;
									}
//LINE 	2							
									addr_line2 = (unsigned int)((tmp_addr & ~(l2_icache_line_size -1)) + l2_icache_line_size);
									iaddr_line2 = *(struct l2_icache_addr *)&addr_line2;
									for (block_num = 0; block_num < GROUP_WAY; block_num++) {
										if ((l2_icache_mem[iaddr_line2.group].icache_line[block_num].flag.invalid == 0)
											&& (l2_icache_mem[iaddr_line2.group].icache_line[block_num].flag.tag == iaddr_line2.tag)
											&& (l2_icache_mem[iaddr_line2.group].icache_line[block_num].flag.line == iaddr_line2.line)) {
	
											ir_data_line2.hit = 1;
										}
									}
	
									if (ir_data_line2.hit == 0) {
										max_lru_count = 0;
										gb = GROUP_WAY;
	
										while(gb--) {
											max_lru_count =
												max_lru_count >= l2_icache_mem[iaddr_line2.group].icache_line[gb].flag.lru_count
												? max_lru_count
												: l2_icache_mem[iaddr_line2.group].icache_line[gb].flag.lru_count;
	
											if (max_lru_count != ir_data_line2.max_lru_count) {
												ir_data_line2.max_lru_count = max_lru_count;
												ir_data_line2.block = gb;
											}
										}
	
										l2_icache_mem[iaddr_line2.group].icache_line[ir_data_line2.block].flag.invalid = 0;
										l2_icache_mem[iaddr_line2.group].icache_line[ir_data_line2.block].flag.line = iaddr_line2.line;
										l2_icache_mem[iaddr_line2.group].icache_line[ir_data_line2.block].flag.tag = iaddr_line2.tag;
										l2_icache_mem[iaddr_line2.group].icache_line[ir_data_line2.block].flag.lru_count = 0;
										gb = GROUP_WAY;
										while(gb--) {
											if (gb == ir_data_line2.block)
												continue;
	
											l2_icache_mem[iaddr_line2.group].icache_line[gb].flag.lru_count++;
										}
									}
									ir_data_line2.hit = 1;
								} else {
//Read 1 LINE										
//LINE 1
									if (ir_data_line1.hit == 0) {
										addr_line1 = (unsigned int)tmp_addr;
										max_lru_count = 0;
										gb = GROUP_WAY;
	
										while(gb--) {
											max_lru_count =
												max_lru_count >= l2_icache_mem[iaddr_line1.group].icache_line[gb].flag.lru_count
												? max_lru_count
												: l2_icache_mem[iaddr_line1.group].icache_line[gb].flag.lru_count;
	
											if (max_lru_count != ir_data_line1.max_lru_count) {
												ir_data_line1.max_lru_count = max_lru_count;
												ir_data_line1.block = gb;
											}
										}
	
										l2_icache_mem[iaddr_line1.group].icache_line[ir_data_line1.block].flag.invalid = 0;
										l2_icache_mem[iaddr_line1.group].icache_line[ir_data_line1.block].flag.line = iaddr_line1.line;
										l2_icache_mem[iaddr_line1.group].icache_line[ir_data_line1.block].flag.tag = iaddr_line1.tag;
										l2_icache_mem[iaddr_line1.group].icache_line[ir_data_line1.block].flag.lru_count = 0;
										gb = GROUP_WAY;
										while(gb--) {
											if (gb == ir_data_line1.block)
												continue;
	
											l2_icache_mem[iaddr_line1.group].icache_line[gb].flag.lru_count++;
										}
										ir_data_line1.hit = 1;
									}
								}
							}
							addr += l2_icache_line_size;
							ptr += l2_icache_line_size;
							hit = 0;
						}
					}
						
					wait(soc_core_req_event[CORE0_ID] | soc_core_req_event[CORE1_ID]
							| soc_core_req_event[CORE2_ID] | soc_core_req_event[CORE3_ID]);
					wait(sc_core::SC_ZERO_TIME);
					wait(sc_core::SC_ZERO_TIME);
//LINE 1
					addr_line1 = (unsigned int)tmp_addr;
					iaddr_line1 = *(struct l2_icache_addr *)&addr_line1;
//LINE 2					
					addr_line2 = (unsigned int)((tmp_addr & ~(l2_icache_line_size -1)) + l2_icache_line_size);
					iaddr_line2 = *(struct l2_icache_addr *)&addr_line2;

					if ((tmp_addr + len) >= ((tmp_addr & ~(l2_icache_line_size - 1)) + l2_icache_line_size)) {
//Sync 	L2 2 LINE							
						if (l2_sync[CORE2_ID] == 1) {
							memcpy(l2_icache_mem[iaddr_line1.group].icache_line[ir_data_line1.block].insn,
									l2_icache_buf[CORE2_ID], l2_icache_line_size);
	
							memcpy(l2_icache_mem[iaddr_line2.group].icache_line[ir_data_line2.block].insn,
									l2_icache_buf[CORE2_ID] + l2_icache_line_size, l2_icache_line_size);
						}
	
						memcpy(tmp_ptr, l2_icache_mem[iaddr_line1.group].icache_line[ir_data_line1.block].insn, l2_icache_line_size);
						memcpy(tmp_ptr + l2_icache_line_size, l2_icache_mem[iaddr_line2.group].icache_line[ir_data_line2.block].insn,
									l2_icache_line_size);
					} else {
//Sync L2 1 LINE							
						if (l2_sync[CORE2_ID] == 1) {
							memcpy(l2_icache_mem[iaddr_line1.group].icache_line[ir_data_line1.block].insn,
									l2_icache_buf[CORE2_ID], l2_icache_line_size);
	
							memcpy(tmp_ptr, l2_icache_mem[iaddr_line1.group].icache_line[ir_data_line1.block].insn,
									l2_icache_line_size);
						}
					}
					phase = tlm::BEGIN_RESP;
					PendingTransactionsIterator it = mPendingTransactions_C2.find(trans_ptr);
					mPendingTransactions_C2.erase(it);
					notify_core_finish(CORE2_ID, 3); 	//INST_IF
				//}
			}
		}

		void L2_Bus_Request_Thread_C3()
		{
			unsigned int i, len;
			unsigned char *ptr, *tmp_ptr;
			tlm::tlm_sync_enum ret;
			tlm::tlm_generic_payload *trans_ptr;
			trans_extension *ext_ptr;
			unsigned int addr_line1, addr_line2;
			struct l2_icache_addr iaddr, iaddr_line1, iaddr_line2;
			struct icache_replace ir_data_line1;
			struct icache_replace ir_data_line2;
			unsigned int gb, max_lru_count;
			unsigned int block_num, hit;

			while(true) {
				wait(l2_bus_RequestPEQ_C3.get_event());

				//while (true) {
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
					memset(&ir_data_line1, 0 , sizeof(struct icache_replace));
					memset(&ir_data_line2, 0 , sizeof(struct icache_replace));
	
					gb = 0;
					block_num = 0;
					hit = 0;
					max_lru_count = 0;
	
					if (cmd == tlm::TLM_READ_COMMAND) {
						for (i = 0; i < len; i += l2_icache_line_size) {
							iaddr = *(struct l2_icache_addr *)&addr;
							for (block_num = 0; block_num < GROUP_WAY; block_num++) {
								if ((l2_icache_mem[iaddr.group].icache_line[block_num].flag.invalid == 0)
										&& (l2_icache_mem[iaddr.group].icache_line[block_num].flag.tag == iaddr.tag)
										&& (l2_icache_mem[iaddr.group].icache_line[block_num].flag.line == iaddr.line)) {	
//Hi	t
									l2_icache_mem[iaddr.group].icache_line[block_num].flag.lru_count = 0;
	
	
									if (addr == tmp_addr) {
										ir_data_line1.block = block_num;
										if (ir_data_line1.hit == 0) {
											gb = GROUP_WAY;
											while(gb--) {
												if (gb == block_num)
													continue;
				
												l2_icache_mem[iaddr.group].icache_line[gb].flag.lru_count++;
											}
										ir_data_line1.hit = 1;
										}
									} else {
										ir_data_line2.block = block_num;
										if (ir_data_line2.hit == 0) {
											gb = GROUP_WAY;
											while(gb--) {
												if (gb == block_num)
													continue;
				
												l2_icache_mem[iaddr.group].icache_line[gb].flag.lru_count++;
											}
	
										}
										ir_data_line2.hit = 1;
									}
									hit = 1;
								}
							}
	
							if (hit == 0) {
//Miss
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
#if 0
								static int pro_c = 0;
	
								printf("Miss %d\r\n",pro_c);
								fflush(stdout);
								pro_c++;
#endif

								ret = ddr_mem_init_socket->nb_transport_fw(l2_cache_trans[CORE3_ID], phase, t);
	
								if ((tmp_addr + len) >= ((tmp_addr & ~(l2_icache_line_size - 1)) + l2_icache_line_size)) {
//Read 2 LINE										
//LINE 1
									addr_line1 = (unsigned int)tmp_addr;
									iaddr_line1 = *(struct l2_icache_addr *)&addr_line1;
									for (block_num = 0; block_num < GROUP_WAY; block_num++) {
										if ((l2_icache_mem[iaddr_line1.group].icache_line[block_num].flag.invalid == 0)
											&& (l2_icache_mem[iaddr_line1.group].icache_line[block_num].flag.tag == iaddr_line1.tag)
											&& (l2_icache_mem[iaddr_line1.group].icache_line[block_num].flag.line == iaddr_line1.line)) {
	
											ir_data_line1.hit = 1;
										}
									}

									if (ir_data_line1.hit == 0) {
										max_lru_count = 0;
										gb = GROUP_WAY;
	
										while(gb--) {
											max_lru_count =
												max_lru_count >= l2_icache_mem[iaddr_line1.group].icache_line[gb].flag.lru_count
												? max_lru_count
												: l2_icache_mem[iaddr_line1.group].icache_line[gb].flag.lru_count;
	
											if (max_lru_count != ir_data_line1.max_lru_count) {
												ir_data_line1.max_lru_count = max_lru_count;
												ir_data_line1.block = gb;
											}
										}
	
										l2_icache_mem[iaddr_line1.group].icache_line[ir_data_line1.block].flag.invalid = 0;
										l2_icache_mem[iaddr_line1.group].icache_line[ir_data_line1.block].flag.line = iaddr_line1.line;
										l2_icache_mem[iaddr_line1.group].icache_line[ir_data_line1.block].flag.tag = iaddr_line1.tag;
										l2_icache_mem[iaddr_line1.group].icache_line[ir_data_line1.block].flag.lru_count = 0;
										gb = GROUP_WAY;
										while(gb--) {
											if (gb == ir_data_line1.block)
												continue;
	
											l2_icache_mem[iaddr_line1.group].icache_line[gb].flag.lru_count++;
										}
										ir_data_line1.hit = 1;
									}
//LINE 2							
									addr_line2 = (unsigned int)((tmp_addr & ~(l2_icache_line_size -1)) + l2_icache_line_size);
									iaddr_line2 = *(struct l2_icache_addr *)&addr_line2;
									for (block_num = 0; block_num < GROUP_WAY; block_num++) {
										if ((l2_icache_mem[iaddr_line2.group].icache_line[block_num].flag.invalid == 0)
											&& (l2_icache_mem[iaddr_line2.group].icache_line[block_num].flag.tag == iaddr_line2.tag)
											&& (l2_icache_mem[iaddr_line2.group].icache_line[block_num].flag.line == iaddr_line2.line)) {
	
											ir_data_line2.hit = 1;
										}
									}
	
									if (ir_data_line2.hit == 0) {
										max_lru_count = 0;
										gb = GROUP_WAY;
	
										while(gb--) {
											max_lru_count =
												max_lru_count >= l2_icache_mem[iaddr_line2.group].icache_line[gb].flag.lru_count
												? max_lru_count
												: l2_icache_mem[iaddr_line2.group].icache_line[gb].flag.lru_count;
	
											if (max_lru_count != ir_data_line2.max_lru_count) {
												ir_data_line2.max_lru_count = max_lru_count;
												ir_data_line2.block = gb;
											}
										}
	
										l2_icache_mem[iaddr_line2.group].icache_line[ir_data_line2.block].flag.invalid = 0;
										l2_icache_mem[iaddr_line2.group].icache_line[ir_data_line2.block].flag.line = iaddr_line2.line;
										l2_icache_mem[iaddr_line2.group].icache_line[ir_data_line2.block].flag.tag = iaddr_line2.tag;
										l2_icache_mem[iaddr_line2.group].icache_line[ir_data_line2.block].flag.lru_count = 0;
										gb = GROUP_WAY;
										while(gb--) {
											if (gb == ir_data_line2.block)
												continue;
	
											l2_icache_mem[iaddr_line2.group].icache_line[gb].flag.lru_count++;
										}
									}
									ir_data_line2.hit = 1;
								} else {
//Read 1 LINE										
//LINE 1
									if (ir_data_line1.hit == 0) {
										addr_line1 = (unsigned int)tmp_addr;
										max_lru_count = 0;
										gb = GROUP_WAY;
	
										while(gb--) {
											max_lru_count =
												max_lru_count >= l2_icache_mem[iaddr_line1.group].icache_line[gb].flag.lru_count
												? max_lru_count
												: l2_icache_mem[iaddr_line1.group].icache_line[gb].flag.lru_count;
	
											if (max_lru_count != ir_data_line1.max_lru_count) {
												ir_data_line1.max_lru_count = max_lru_count;
												ir_data_line1.block = gb;
											}
										}
	
										l2_icache_mem[iaddr_line1.group].icache_line[ir_data_line1.block].flag.invalid = 0;
										l2_icache_mem[iaddr_line1.group].icache_line[ir_data_line1.block].flag.line = iaddr_line1.line;
										l2_icache_mem[iaddr_line1.group].icache_line[ir_data_line1.block].flag.tag = iaddr_line1.tag;
										l2_icache_mem[iaddr_line1.group].icache_line[ir_data_line1.block].flag.lru_count = 0;
										gb = GROUP_WAY;
										while(gb--) {
											if (gb == ir_data_line1.block)
												continue;
	
											l2_icache_mem[iaddr_line1.group].icache_line[gb].flag.lru_count++;
										}
										ir_data_line1.hit = 1;
									}
								}
							}
							addr += l2_icache_line_size;
							ptr += l2_icache_line_size;
							hit = 0;
						}
					}
						
					wait(soc_core_req_event[CORE0_ID] | soc_core_req_event[CORE1_ID]
							| soc_core_req_event[CORE2_ID] | soc_core_req_event[CORE3_ID]);
					wait(sc_core::SC_ZERO_TIME);
					wait(sc_core::SC_ZERO_TIME);
//LINE 	1
					addr_line1 = (unsigned int)tmp_addr;
					iaddr_line1 = *(struct l2_icache_addr *)&addr_line1;
//LINE 2					
					addr_line2 = (unsigned int)((tmp_addr & ~(l2_icache_line_size -1)) + l2_icache_line_size);
					iaddr_line2 = *(struct l2_icache_addr *)&addr_line2;
	
					if ((tmp_addr + len) >= ((tmp_addr & ~(l2_icache_line_size - 1)) + l2_icache_line_size)) {
//Sync L2 2 LINE							
						if (l2_sync[CORE3_ID] == 1) {
							memcpy(l2_icache_mem[iaddr_line1.group].icache_line[ir_data_line1.block].insn,
									l2_icache_buf[CORE3_ID], l2_icache_line_size);
	
							memcpy(l2_icache_mem[iaddr_line2.group].icache_line[ir_data_line2.block].insn,
									l2_icache_buf[CORE3_ID] + l2_icache_line_size, l2_icache_line_size);
						}
	
						memcpy(tmp_ptr, l2_icache_mem[iaddr_line1.group].icache_line[ir_data_line1.block].insn, l2_icache_line_size);
						memcpy(tmp_ptr + l2_icache_line_size, l2_icache_mem[iaddr_line2.group].icache_line[ir_data_line2.block].insn,
									l2_icache_line_size);
					} else {
//Sync 	L2 1 LINE							
						if (l2_sync[CORE3_ID] == 1) {
							memcpy(l2_icache_mem[iaddr_line1.group].icache_line[ir_data_line1.block].insn,
									l2_icache_buf[CORE3_ID], l2_icache_line_size);
	
							memcpy(tmp_ptr, l2_icache_mem[iaddr_line1.group].icache_line[ir_data_line1.block].insn,
									l2_icache_line_size);
						}
					}
					phase = tlm::BEGIN_RESP;
					PendingTransactionsIterator it = mPendingTransactions_C3.find(trans_ptr);
					mPendingTransactions_C3.erase(it);
					notify_core_finish(CORE3_ID, 3); 	//INST_IF
				//}
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
			unsigned int gb;
			if (cmd == tlm::TLM_WRITE_COMMAND) {
				for (unsigned int i = 0; i < (l2_icache_size / l2_icache_line_size / GROUP_WAY); i++) {
					gb = GROUP_WAY;
					while (gb--) {
						l2_icache_mem[i].icache_line[gb].flag.tag = 0;
						l2_icache_mem[i].icache_line[gb].flag.group = i;
						l2_icache_mem[i].icache_line[gb].flag.lru_count = 0;
						l2_icache_mem[i].icache_line[gb].flag.invalid = 1;
						l2_icache_mem[i].icache_line[gb].flag.line = 0;
					}
				}
			}
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
