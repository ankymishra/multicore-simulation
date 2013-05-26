#ifndef PAC_D2_BUS_H_INCLUDED
#define PAC_D2_BUS_H_INCLUDED

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

extern sc_core::sc_event soc_core_req_event[DSPNUM];	// 4 core request event
extern int soc_core_req_bit_mask[DSPNUM];				//m1 m2 ddr finish bit mask

struct d2_dcache_addr {
	unsigned int offset:8;
	unsigned int index:8;
	unsigned int tag:16;
};

struct d2_dcache_flag {
	unsigned int invalid:1;
	unsigned int dirty:1;
	unsigned int reserved:6;
	unsigned int index:8;
	unsigned int tag:16;
};

struct d2_dcache_line {
	struct d2_dcache_flag flag;
	unsigned char *insn;
};


#ifndef PAC_SOC_PROFILE
struct D2_Bus:public sc_core::sc_module, public pac_bus
{
	private:
		unsigned int r_lock, w_lock;
		struct sim_arg *multi_sim_arg;
		unsigned int d2_dcache_type;
		unsigned int d2_dcache_size;
		unsigned int d2_dcache_line_size;
		struct d2_dcache_line *d2_dcache_mem;
		unsigned int m1_bus_base_array[DSPNUM], m1_bus_size_array[DSPNUM];
	 	unsigned int m1_bus_base_array_no_mem[DSPNUM], m1_bus_size_array_no_mem[DSPNUM];
		unsigned int m2_bus_base, m2_bus_size;
		unsigned int m2_bus_base_no_mem, m2_bus_size_no_mem;
		unsigned int biu_bus_base, biu_bus_size;
		unsigned int sysdma_base, sysdma_size;
		unsigned int c2cc_base, c2cc_size;
		unsigned int i;

	public:
		tlm_utils::simple_initiator_socket_tagged < D2_Bus > m1_bus_init_socket_tagged[DSPNUM];
		tlm_utils::simple_initiator_socket_tagged < D2_Bus > m2_bus_init_socket_tagged[DSPNUM];
		tlm_utils::simple_initiator_socket_tagged < D2_Bus > biu_bus_init_socket_tagged[DSPNUM];
		tlm_utils::simple_initiator_socket_tagged < D2_Bus > dmu_bus_init_socket_tagged[DSPNUM];
		
		tlm_utils::simple_target_socket_tagged < D2_Bus > d2_bus_targ_socket_tagged[DSPNUM+1];	//connect to core_bus dma_bus

		tlm_utils::peq_with_get < tlm::tlm_generic_payload > m1_bus_ResponsePEQ;
		tlm_utils::peq_with_get < tlm::tlm_generic_payload > m2_bus_ResponsePEQ;
		tlm_utils::peq_with_get < tlm::tlm_generic_payload > biu_bus_ResponsePEQ;
		tlm_utils::peq_with_get < tlm::tlm_generic_payload > dmu_bus_ResponsePEQ;

		tlm_utils::peq_with_get < tlm::tlm_generic_payload > d2_bus_RequestPEQ;

		SC_HAS_PROCESS(D2_Bus);	
		
	public:
		D2_Bus(sc_module_name _name, struct sim_arg *arg)
		: sc_core::sc_module(_name)
		, multi_sim_arg(arg)
		, m1_bus_ResponsePEQ("m1_bus_ResponsePEQ")
		, m2_bus_ResponsePEQ("m2_bus_ResponsePEQ")
		, biu_bus_ResponsePEQ("biu_bus_ResponsePEQ")
		, dmu_bus_ResponsePEQ("dmu_bus_Response")
		, d2_bus_RequestPEQ("d2_bus_RequestPEQ")
		{
			d2_dcache_type = multi_arg(d2_cache, d2_cache_type);
			d2_dcache_size = multi_arg(d2_cache, d2_cache_size);
			d2_dcache_line_size = multi_arg(d2_cache, d2_cache_line_size);

			d2_dcache_mem = new d2_dcache_line[d2_dcache_size / d2_dcache_line_size];
			
			for (i = 0; i < (d2_dcache_size / d2_dcache_line_size); i++) {
				d2_dcache_mem[i].insn = new unsigned char[d2_dcache_line_size];
			}

			for (i = 0; i < (d2_dcache_size / d2_dcache_line_size); i++) {
				d2_dcache_mem[i].flag.tag = 0;
				d2_dcache_mem[i].flag.index = 0;
				d2_dcache_mem[i].flag.reserved = 0;
				d2_dcache_mem[i].flag.invalid = 1;
				d2_dcache_mem[i].flag.dirty = 0;
				memset(d2_dcache_mem[i].insn, 0, d2_dcache_line_size);
			}

			for (i = 0; i < DSPNUM; i++) {
				m1_bus_base_array[i] = multi_arg(pacdsp[i], core_base);
				m1_bus_size_array[i] = multi_arg(pacdsp[i].m1_mem, dmem_m1_size)
					+ multi_arg(pacdsp[i].res1, res1_size)
					+ multi_arg(pacdsp[i].biu, biu_size)
					+ multi_arg(pacdsp[i].icu, icu_size)
					+ multi_arg(pacdsp[i].dmu, dmu_size)
					+ multi_arg(pacdsp[i].dma, dma_size)
					+ multi_arg(pacdsp[i].res2, res2_size);

				m1_bus_base_array_no_mem[i] = m1_bus_base_array[i] + multi_arg(pacdsp[i].m1_mem, dmem_m1_size);
				m1_bus_size_array_no_mem[i] = multi_arg(pacdsp[i].res1, res1_size)
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

			m2_bus_base_no_mem = m2_bus_base + multi_arg(m2_mem, dmem_m2_size);
			m2_bus_size_no_mem = multi_arg(l2_icu, l2_icu_size)
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

			for (i = 0; i < DSPNUM; i++) {
				m1_bus_init_socket_tagged[i].register_nb_transport_bw(this, &D2_Bus::nb_transport_bw, i);
				m2_bus_init_socket_tagged[i].register_nb_transport_bw(this, &D2_Bus::nb_transport_bw, i);
				biu_bus_init_socket_tagged[i].register_nb_transport_bw(this, &D2_Bus::nb_transport_bw, i);
				dmu_bus_init_socket_tagged[i].register_nb_transport_bw(this, &D2_Bus::nb_transport_bw, i);
			}

			for (i = 0; i < (DSPNUM + 1); i++) {
				d2_bus_targ_socket_tagged[i].register_nb_transport_fw(this, &D2_Bus::nb_transport_fw, i);
				d2_bus_targ_socket_tagged[i].register_b_transport(this, &D2_Bus::b_transport, i);
			}

			SC_THREAD(D2_Bus_Request_Thread);
		}

		~D2_Bus()
		{}

	private:
		void D2_Bus_Request_Thread()
		{
			unsigned int i, len, offset;
			tlm::tlm_sync_enum ret;
			tlm::tlm_generic_payload *trans_ptr;
			trans_extension *ext_ptr;
			unsigned char *ptr;
			tlm::tlm_phase phase = tlm::BEGIN_REQ;
			sc_core::sc_time t = sc_core::SC_ZERO_TIME;
			sc_dt::uint64 addr;
			int skip, core_id;
			tlm::tlm_command cmd;

			while (true) {
				wait(d2_bus_RequestPEQ.get_event());
				while (true) {
					trans_ptr = d2_bus_RequestPEQ.get_next_transaction();
					if (trans_ptr == NULL)
						break;

					skip = 0;
					addr = trans_ptr->get_address();
					cmd = trans_ptr->get_command();
					trans_ptr->get_extension(ext_ptr);
					ptr = trans_ptr->get_data_ptr();
					len = trans_ptr->get_data_length();
					core_id = GET_CORE(ext_ptr->inst_core_range);

					//if (cmd == tlm::TLM_WRITE_COMMAND) {
					//	printf("write addr 0x%08x\r\n", addr);
					//} else {
					//	printf("read addr 0x%08x\r\n", addr);
					//}
//uncached
					if (cmd == tlm::TLM_READ_COMMAND) {
						lock(r_lock);
						if (((addr >= m1_bus_base_array_no_mem[core_id])
							&& ((addr + len) < (m1_bus_base_array_no_mem[core_id] + m1_bus_size_array_no_mem[core_id])))
							|| ((addr >= c2cc_base) && (addr < c2cc_base + c2cc_size))) {
							m1_mem_read(*trans_ptr, ext_ptr->inst_core_range);
							skip  = 1;
						} else if ((addr >= m2_bus_base_no_mem)
							&& ((addr + len) < (m2_bus_base_no_mem + m2_bus_size_no_mem))){
							m2_mem_read(*trans_ptr, ext_ptr->inst_core_range);
							skip = 1;
						} else if ((addr >= sysdma_base) && ((addr + len) < (sysdma_base + sysdma_size))) {
							ddr_mem_read(*trans_ptr, ext_ptr->inst_core_range);
							skip = 1;
						} else {
							for (i = 0; i < DSPNUM; i++) {
								if ((addr >= m1_bus_base_array_no_mem[i])
									&& ((addr + len) < (m1_bus_base_array_no_mem[i] + m1_bus_size_array_no_mem[i]))) {
									dmu_mem_read(*trans_ptr, ext_ptr->inst_core_range);
									//dmu_flag |= 1 << i;
									skip = 1;
									break;
								}
							}
						}
						unlock(r_lock);
					} else if (cmd == tlm::TLM_WRITE_COMMAND) {
						lock(w_lock);
						if (((addr >= m1_bus_base_array_no_mem[core_id])
							&& ((addr + len) < (m1_bus_base_array_no_mem[core_id] + m1_bus_size_array_no_mem[core_id])))
							|| ((addr >= c2cc_base) && (addr < c2cc_base + c2cc_size))) {
							m1_mem_write(*trans_ptr, ext_ptr->inst_core_range);
							skip  = 1;
						} else if ((addr >= m2_bus_base_no_mem)
							&& ((addr + len) < (m2_bus_base_no_mem + m2_bus_size_no_mem))){
							m2_mem_write(*trans_ptr, ext_ptr->inst_core_range);
							skip = 1;
						} else if ((addr >= sysdma_base) && ((addr + len) < (sysdma_base + sysdma_size))) {
							ddr_mem_write(*trans_ptr, ext_ptr->inst_core_range);
							skip = 1;
						} else {
							for (i = 0; i < DSPNUM; i++) {
								if ((addr >= m1_bus_base_array_no_mem[i])
									&& ((addr + len) < (m1_bus_base_array_no_mem[i] + m1_bus_size_array_no_mem[i]))) {
									dmu_mem_write(*trans_ptr, ext_ptr->inst_core_range);
									//dmu_flag |= 1 << i;
									skip = 1;
									break;
								}
							}
						}
						unlock(w_lock);
					}
//cached
					if (skip == 0) {
						if (cmd == tlm::TLM_READ_COMMAND) {
							lock(r_lock);
							for (offset = 0; offset < len; offset++) {
								struct d2_dcache_addr iaddr = *(struct d2_dcache_addr *)&(addr);
//invalid or not
								if ((d2_dcache_mem[iaddr.index].flag.invalid == 1))
								{
									sc_dt::uint64 read_addr = (addr & ~(d2_dcache_line_size - 1));
									unsigned int read_length = d2_dcache_line_size;
									trans_ptr->set_address(read_addr);
									trans_ptr->set_data_length(read_length);
									trans_ptr->set_data_ptr(d2_dcache_mem[iaddr.index].insn);
									trans_ptr->set_command(tlm::TLM_READ_COMMAND);

									if ((read_addr >= multi_arg(pacdsp[core_id], core_base))
										&& ((read_addr + read_length) < (multi_arg(pacdsp[core_id], core_base)
										+ multi_arg(pacdsp[core_id].m1_mem, dmem_m1_size))))
									{
										m1_mem_read(*trans_ptr, ext_ptr->inst_core_range);
									} else if ((read_addr >= multi_arg(m2_mem, dmem_m2_base))
										&& ((read_addr + read_length) < (multi_arg(m2_mem, dmem_m2_base)
										+ multi_arg(m2_mem, dmem_m2_size))))
									{
										m2_mem_read(*trans_ptr, ext_ptr->inst_core_range);
									} else if ((read_addr >= multi_arg(ddr_mem, ddr_memory_base))
										&& ((read_addr + read_length) < (multi_arg(ddr_mem, ddr_memory_base)
										+ multi_arg(ddr_mem, ddr_memory_size))))
									{
										ddr_mem_read(*trans_ptr, ext_ptr->inst_core_range);
									} else {
										for (i = 0; i < DSPNUM; i++) {
											if ((read_addr >= multi_arg(pacdsp[i], core_base))
												&& ((read_addr + read_length)
												< (multi_arg(pacdsp[i], core_base)
												+ multi_arg(pacdsp[i].m1_mem, dmem_m1_size))))
											{
												dmu_mem_read(*trans_ptr, ext_ptr->inst_core_range);
												//dmu_flag |= 1 << i;
													break;
											}
										}

										if (i == DSPNUM) {
											printf("No read mem address (0x%llx) in simulator\r\n", read_addr);
											//debug_inst[core_id] = 1;
										}
									}
									d2_dcache_mem[iaddr.index].flag.dirty = 0;
								} else {
									if (d2_dcache_mem[iaddr.index].flag.tag != iaddr.tag) {
//replace or not										
										if (d2_dcache_mem[iaddr.index].flag.dirty == 1) {
//dirty or not
											sc_dt::uint64 write_addr = (d2_dcache_mem[iaddr.index].flag.tag << 16)
																		| (iaddr.index << 8);
											unsigned int write_length = d2_dcache_line_size;
											trans_ptr->set_address(write_addr);
											trans_ptr->set_data_length(write_length);
											trans_ptr->set_data_ptr(d2_dcache_mem[iaddr.index].insn);
											trans_ptr->set_command(tlm::TLM_WRITE_COMMAND);
											lock(w_lock);

											if ((write_addr >= multi_arg(pacdsp[core_id], core_base))
												&& ((write_addr + write_length) < (multi_arg(pacdsp[core_id], core_base)
												+ multi_arg(pacdsp[core_id].m1_mem, dmem_m1_size))))
											{
												m1_mem_write(*trans_ptr, ext_ptr->inst_core_range);
											} else if ((write_addr >= multi_arg(m2_mem, dmem_m2_base))
												&& ((write_addr + write_length) < (multi_arg(m2_mem, dmem_m2_base)
												+ multi_arg(m2_mem, dmem_m2_size))))
											{
												m2_mem_write(*trans_ptr, ext_ptr->inst_core_range);
											} else if ((write_addr >= multi_arg(ddr_mem, ddr_memory_base))
												&& ((write_addr + write_length) < (multi_arg(ddr_mem, ddr_memory_base)
												+ multi_arg(ddr_mem, ddr_memory_size))))
											{
												ddr_mem_write(*trans_ptr, ext_ptr->inst_core_range);
											} else {
												for (i = 0; i < DSPNUM; i++) {
													if ((write_addr >= multi_arg(pacdsp[i], core_base))
														&& ((write_addr + write_length)
														< (multi_arg(pacdsp[i], core_base)
														+ multi_arg(pacdsp[i].m1_mem, dmem_m1_size))))
													{
														dmu_mem_write(*trans_ptr, ext_ptr->inst_core_range);
														//dmu_flag |= 1 << i;
														break;
													}
												}

												if (i == DSPNUM) {
													printf("No write mem address (0x%llx) in simulator\r\n", write_addr);
													//debug_inst[core_id] = 1;
												}
											}

											//d2_dcache_mem[iaddr.index].flag.invalid = 1;
											//d2_dcache_mem[iaddr.index].flag.tag = 0;
											memset(d2_dcache_mem[iaddr.index].insn, 0, d2_dcache_line_size);
											d2_dcache_mem[iaddr.index].flag.dirty = 0;
											unlock(w_lock);
										}

										sc_dt::uint64 read_addr = (addr & ~(d2_dcache_line_size - 1));
										unsigned int read_length = d2_dcache_line_size;
										trans_ptr->set_address(read_addr);
										trans_ptr->set_data_length(read_length);
										trans_ptr->set_data_ptr(d2_dcache_mem[iaddr.index].insn);
										trans_ptr->set_command(tlm::TLM_READ_COMMAND);

										if ((read_addr >= multi_arg(pacdsp[core_id], core_base))
											&& ((read_addr + read_length) < (multi_arg(pacdsp[core_id], core_base)
											+ multi_arg(pacdsp[core_id].m1_mem, dmem_m1_size))))
										{
											m1_mem_read(*trans_ptr, ext_ptr->inst_core_range);
										} else if ((read_addr >= multi_arg(m2_mem, dmem_m2_base))
											&& ((read_addr + read_length) < (multi_arg(m2_mem, dmem_m2_base)
											+ multi_arg(m2_mem, dmem_m2_size))))
										{
											m2_mem_read(*trans_ptr, ext_ptr->inst_core_range);
										} else if ((read_addr >= multi_arg(ddr_mem, ddr_memory_base))
											&& ((read_addr + read_length) < (multi_arg(ddr_mem, ddr_memory_base)
											+ multi_arg(ddr_mem, ddr_memory_size))))
										{
											ddr_mem_read(*trans_ptr, ext_ptr->inst_core_range);
										} else {
											for (i = 0; i < DSPNUM; i++) {
												if ((read_addr >= multi_arg(pacdsp[i], core_base))
													&& ((read_addr + read_length)
													< (multi_arg(pacdsp[i], core_base)
													+ multi_arg(pacdsp[i].m1_mem, dmem_m1_size))))
												{
													dmu_mem_read(*trans_ptr, ext_ptr->inst_core_range);
													//dmu_flag |= 1 << i;
													break;
												}
											}
											if (i == DSPNUM) {
												printf("No read mem address (0x%llx) in simulator\r\n", read_addr);
												//debug_inst[core_id] = 1;
											}
										}
									}
								}

								*ptr = d2_dcache_mem[iaddr.index].insn[addr & (d2_dcache_line_size - 1)];
								d2_dcache_mem[iaddr.index].flag.invalid = 0;
								d2_dcache_mem[iaddr.index].flag.tag = iaddr.tag;
								addr++;
								ptr++;
							}
							unlock(r_lock);
 						} else if (cmd == tlm::TLM_WRITE_COMMAND) {
//write to main mem/cache								
							lock(w_lock);
							for (offset = 0; offset < len; offset++) {
								struct d2_dcache_addr iaddr = *(struct d2_dcache_addr *)&(addr);	
//invalid or not								
								if ((d2_dcache_mem[iaddr.index].flag.invalid == 0))
								{
									if (d2_dcache_mem[iaddr.index].flag.tag != iaddr.tag) {
//replace or not											
										if (d2_dcache_mem[iaddr.index].flag.dirty == 1) {
//dirty or not
											sc_dt::uint64 write_addr = (d2_dcache_mem[iaddr.index].flag.tag << 16)
													| (iaddr.index << 8) ;
											unsigned int write_length = d2_dcache_line_size;
											trans_ptr->set_address(write_addr);
											trans_ptr->set_data_length(write_length);
											trans_ptr->set_data_ptr(d2_dcache_mem[iaddr.index].insn);
											trans_ptr->set_command(tlm::TLM_WRITE_COMMAND);

											if ((write_addr >= multi_arg(pacdsp[core_id], core_base))
												&& ((write_addr + write_length) < (multi_arg(pacdsp[core_id], core_base)
												+ multi_arg(pacdsp[core_id].m1_mem, dmem_m1_size))))
											{
												m1_mem_write(*trans_ptr, ext_ptr->inst_core_range);
											} else if ((write_addr >= multi_arg(m2_mem, dmem_m2_base))
												&& ((write_addr + write_length) < (multi_arg(m2_mem, dmem_m2_base)
												+ multi_arg(m2_mem, dmem_m2_size))))
											{
												m2_mem_write(*trans_ptr, ext_ptr->inst_core_range);
											} else if ((write_addr >= multi_arg(ddr_mem, ddr_memory_base))
												&& ((write_addr + write_length) < (multi_arg(ddr_mem, ddr_memory_base)
												+ multi_arg(ddr_mem, ddr_memory_size))))
											{
												ddr_mem_write(*trans_ptr, ext_ptr->inst_core_range);
											} else {
												for (i = 0; i < DSPNUM; i++) {
													if ((write_addr >= multi_arg(pacdsp[i], core_base))
														&& ((write_addr + write_length)
														< (multi_arg(pacdsp[i], core_base)
														+ multi_arg(pacdsp[i].m1_mem, dmem_m1_size))))
													{
														dmu_mem_write(*trans_ptr, ext_ptr->inst_core_range);
														//dmu_flag |= 1 << i;
														break;
													}
												}

												if (i == DSPNUM) {
													printf("No write mem address (0x%llx) in simulator\r\n", write_addr);
													//debug_inst[core_id] = 1;
												}
											}

											//d2_dcache_mem[iaddr.index].flag.invalid = 1;
											//d2_dcache_mem[iaddr.index].flag.tag = 0;
											memset(d2_dcache_mem[iaddr.index].insn, 0, d2_dcache_line_size);
											d2_dcache_mem[iaddr.index].flag.dirty = 0;

											sc_dt::uint64 read_addr = (addr & ~(d2_dcache_line_size - 1));
											unsigned int read_length = d2_dcache_line_size;
											trans_ptr->set_address(read_addr);
											trans_ptr->set_data_length(read_length);
											trans_ptr->set_data_ptr(d2_dcache_mem[iaddr.index].insn);
											trans_ptr->set_command(tlm::TLM_READ_COMMAND);
											lock(r_lock);
	
											if ((read_addr >= multi_arg(pacdsp[core_id], core_base))
												&& ((read_addr + read_length) < (multi_arg(pacdsp[core_id], core_base)
												+ multi_arg(pacdsp[core_id].m1_mem, dmem_m1_size))))
											{
												m1_mem_read(*trans_ptr, ext_ptr->inst_core_range);
											} else if ((read_addr >= multi_arg(m2_mem, dmem_m2_base))
												&& ((read_addr + read_length) < (multi_arg(m2_mem, dmem_m2_base)
												+ multi_arg(m2_mem, dmem_m2_size))))
											{
												m2_mem_read(*trans_ptr, ext_ptr->inst_core_range);
											} else if ((read_addr >= multi_arg(ddr_mem, ddr_memory_base))
												&& ((read_addr + read_length) < (multi_arg(ddr_mem, ddr_memory_base)
												+ multi_arg(ddr_mem, ddr_memory_size))))
											{
												ddr_mem_read(*trans_ptr, ext_ptr->inst_core_range);
											} else {
												for (i = 0; i < DSPNUM; i++) {
													if ((read_addr >= multi_arg(pacdsp[i], core_base))
														&& ((read_addr + read_length)
														< (multi_arg(pacdsp[i], core_base)
														+ multi_arg(pacdsp[i].m1_mem, dmem_m1_size))))
													{
														dmu_mem_read(*trans_ptr, ext_ptr->inst_core_range);
														//dmu_flag |= 1 << i;
															break;
													}
												}
												if (i == DSPNUM) {
													printf("No read mem address (0x%llx) in simulator\r\n", read_addr);
													//debug_inst[core_id] = 1;
												}
											}
											unlock(r_lock);
										} else {
//no-dirty												
											sc_dt::uint64 read_addr = (addr & ~(d2_dcache_line_size - 1));
											unsigned int read_length = d2_dcache_line_size;
											trans_ptr->set_address(read_addr);
											trans_ptr->set_data_length(read_length);
											trans_ptr->set_data_ptr(d2_dcache_mem[iaddr.index].insn);
											trans_ptr->set_command(tlm::TLM_READ_COMMAND);
											lock(r_lock);
	
											if ((read_addr >= multi_arg(pacdsp[core_id], core_base))
												&& ((read_addr + read_length) < (multi_arg(pacdsp[core_id], core_base)
												+ multi_arg(pacdsp[core_id].m1_mem, dmem_m1_size))))
											{
												m1_mem_read(*trans_ptr, ext_ptr->inst_core_range);
											} else if ((read_addr >= multi_arg(m2_mem, dmem_m2_base))
												&& ((read_addr + read_length) < (multi_arg(m2_mem, dmem_m2_base)
												+ multi_arg(m2_mem, dmem_m2_size))))
											{
												m2_mem_read(*trans_ptr, ext_ptr->inst_core_range);
											} else if ((read_addr >= multi_arg(ddr_mem, ddr_memory_base))
												&& ((read_addr + read_length) < (multi_arg(ddr_mem, ddr_memory_base)
												+ multi_arg(ddr_mem, ddr_memory_size))))
											{
												ddr_mem_read(*trans_ptr, ext_ptr->inst_core_range);
											} else {
												for (i = 0; i < DSPNUM; i++) {
													if ((read_addr >= multi_arg(pacdsp[i], core_base))
														&& ((read_addr + read_length)
														< (multi_arg(pacdsp[i], core_base)
														+ multi_arg(pacdsp[i].m1_mem, dmem_m1_size))))
													{
														dmu_mem_read(*trans_ptr, ext_ptr->inst_core_range);
														//dmu_flag |= 1 << i;
															break;
													}
												}
												if (i == DSPNUM) {
													printf("No read mem address (0x%llx) in simulator\r\n", read_addr);
													//debug_inst[core_id] = 1;
												}
											}
											unlock(r_lock);
										}
									}
								} else {
									sc_dt::uint64 read_addr = (addr & ~(d2_dcache_line_size - 1));
									unsigned int read_length = d2_dcache_line_size;
									trans_ptr->set_address(read_addr);
									trans_ptr->set_data_length(read_length);
									trans_ptr->set_data_ptr(d2_dcache_mem[iaddr.index].insn);
									trans_ptr->set_command(tlm::TLM_READ_COMMAND);
									lock(r_lock);
									
									if ((read_addr >= multi_arg(pacdsp[core_id], core_base))
										&& ((read_addr + read_length) < (multi_arg(pacdsp[core_id], core_base)
										+ multi_arg(pacdsp[core_id].m1_mem, dmem_m1_size))))
									{
										m1_mem_read(*trans_ptr, ext_ptr->inst_core_range);
									} else if ((read_addr >= multi_arg(m2_mem, dmem_m2_base))
										&& ((read_addr + read_length) < (multi_arg(m2_mem, dmem_m2_base)
										+ multi_arg(m2_mem, dmem_m2_size))))
									{
										m2_mem_read(*trans_ptr, ext_ptr->inst_core_range);
									} else if ((read_addr >= multi_arg(ddr_mem, ddr_memory_base))
										&& ((read_addr + read_length) < (multi_arg(ddr_mem, ddr_memory_base)
										+ multi_arg(ddr_mem, ddr_memory_size))))
									{
										ddr_mem_read(*trans_ptr, ext_ptr->inst_core_range);
									} else {
										for (i = 0; i < DSPNUM; i++) {
											if ((read_addr >= multi_arg(pacdsp[i], core_base))
												&& ((read_addr + read_length)
												< (multi_arg(pacdsp[i], core_base)
												+ multi_arg(pacdsp[i].m1_mem, dmem_m1_size))))
											{
												dmu_mem_read(*trans_ptr, ext_ptr->inst_core_range);
												//dmu_flag |= 1 << i;
													break;
											}
										}
										if (i == DSPNUM) {
											printf("No read mem address (0x%llx) in simulator\r\n", read_addr);
											//debug_inst[core_id] = 1;
										}
									}
									d2_dcache_mem[iaddr.index].flag.dirty = 0;
									unlock(r_lock);
								}

								if (d2_dcache_type == 1) { 	//write_back
									d2_dcache_mem[iaddr.index].insn[addr & (d2_dcache_line_size - 1)] = *ptr;
									d2_dcache_mem[iaddr.index].flag.invalid = 0;
									d2_dcache_mem[iaddr.index].flag.tag = iaddr.tag;
									d2_dcache_mem[iaddr.index].flag.dirty = 1;
								} else { 					//write through
									d2_dcache_mem[iaddr.index].insn[addr & (d2_dcache_line_size - 1)] = *ptr;
									d2_dcache_mem[iaddr.index].flag.invalid = 0;
									d2_dcache_mem[iaddr.index].flag.tag = iaddr.tag;
									d2_dcache_mem[iaddr.index].flag.dirty = 0;

									sc_dt::uint64 write_addr = (d2_dcache_mem[iaddr.index].flag.tag << 16)
													| (iaddr.index << 8) ;

									unsigned int write_length = d2_dcache_line_size;
									trans_ptr->set_address(write_addr);
									trans_ptr->set_data_length(write_length);
									trans_ptr->set_data_ptr(d2_dcache_mem[iaddr.index].insn);
									trans_ptr->set_command(tlm::TLM_WRITE_COMMAND);


									if ((write_addr >= multi_arg(pacdsp[core_id], core_base))
										&& ((write_addr + write_length) < (multi_arg(pacdsp[core_id], core_base)
										+ multi_arg(pacdsp[core_id].m1_mem, dmem_m1_size))))
									{
										m1_mem_write(*trans_ptr, ext_ptr->inst_core_range);
									} else if ((write_addr >= multi_arg(m2_mem, dmem_m2_base))
										&& ((write_addr + write_length) < (multi_arg(m2_mem, dmem_m2_base)
										+ multi_arg(m2_mem, dmem_m2_size))))
									{
										m2_mem_write(*trans_ptr, ext_ptr->inst_core_range);
									} else if ((write_addr >= multi_arg(ddr_mem, ddr_memory_base))
										&& ((write_addr + write_length) < (multi_arg(ddr_mem, ddr_memory_base)
										+ multi_arg(ddr_mem, ddr_memory_size))))
									{
										ddr_mem_write(*trans_ptr, ext_ptr->inst_core_range);
									} else {
										for (i = 0; i < DSPNUM; i++) {
											if ((write_addr >= multi_arg(pacdsp[i], core_base))
												&& ((write_addr + write_length)
												< (multi_arg(pacdsp[i], core_base)
												+ multi_arg(pacdsp[i].m1_mem, dmem_m1_size))))
											{
												dmu_mem_write(*trans_ptr, ext_ptr->inst_core_range);
												//dmu_flag |= 1 << i;
												break;
											}
										}

										if (i == DSPNUM) {
											printf("No write mem address (0x%llx) in simulator\r\n", write_addr);
											//debug_inst[core_id] = 1;
										}
									}
								}
								addr++;
								ptr++;
							}
							unlock(w_lock);
						}	
					}
					tlm::tlm_phase phase = tlm::BEGIN_RESP;
					PendingTransactionsIterator it = mPendingTransactions.find(trans_ptr);
					ret = d2_bus_targ_socket_tagged[it->second.from]->nb_transport_bw(*trans_ptr, phase, t);
					mPendingTransactions.erase(it);
				}
			}
		}

	private:
		int d2_cache_read(tlm::tlm_generic_payload *trans_ptr)
		{
			return CACHE_MISS;
		}

		int d2_cache_write(tlm::tlm_generic_payload *trans_ptr)
		{
			return CACHE_MISS;
		}

		int dbg_d2cache_read(tlm::tlm_generic_payload &trans)
		{
			return CACHE_MISS;
		}

		int dbg_d2cache_write(tlm::tlm_generic_payload &trans)
		{
			return CACHE_MISS;
		}

		void m1_mem_read(tlm::tlm_generic_payload &trans_ptr, unsigned int inst_core)
		{
			trans_extension *ext_ptr;
			unsigned int inst_mode = GET_INST(inst_core);
			unsigned int core_id = GET_CORE(inst_core);
			trans_ptr.get_extension(ext_ptr);

			soc_core_req_bit_mask[core_id] |= 1 << 0;
			ext_ptr->inst_core_range = GEN_INST_CORE_RANGE(inst_mode, core_id, M1_RANGE);
			tlm::tlm_phase phase = tlm::BEGIN_REQ;
			sc_time delay = sc_core::SC_ZERO_TIME;

			trans_ptr.set_extension(ext_ptr);
			m1_bus_init_socket_tagged[core_id]->nb_transport_fw(trans_ptr, phase, delay);
	
			tlm::tlm_generic_payload *trans;
			wait(m1_bus_ResponsePEQ.get_event());
			trans = m1_bus_ResponsePEQ.get_next_transaction();
		}

		void m1_mem_write(tlm::tlm_generic_payload &trans_ptr, unsigned int inst_core)
		{
			trans_extension *ext_ptr;
			unsigned int inst_mode = GET_INST(inst_core);
			unsigned int core_id = GET_CORE(inst_core);
			trans_ptr.get_extension(ext_ptr);

			soc_core_req_bit_mask[core_id] |= 1 << 0;
			ext_ptr->inst_core_range = GEN_INST_CORE_RANGE(inst_mode, core_id, M1_RANGE);
			tlm::tlm_phase phase = tlm::BEGIN_REQ;
			sc_time delay = sc_core::SC_ZERO_TIME;

			trans_ptr.set_extension(ext_ptr);
			m1_bus_init_socket_tagged[core_id]->nb_transport_fw(trans_ptr, phase, delay);

			tlm::tlm_generic_payload *trans;
			wait(m1_bus_ResponsePEQ.get_event());
			trans = m1_bus_ResponsePEQ.get_next_transaction();
		}

		void m2_mem_read(tlm::tlm_generic_payload &trans_ptr, unsigned int inst_core)
		{
			trans_extension *ext_ptr;
			unsigned int inst_mode = GET_INST(inst_core);
			unsigned int core_id = GET_CORE(inst_core);
			trans_ptr.get_extension(ext_ptr);

			soc_core_req_bit_mask[core_id] |= 1 << 1;
			ext_ptr->inst_core_range = GEN_INST_CORE_RANGE(inst_mode, core_id, M2_RANGE);
			tlm::tlm_phase phase = tlm::BEGIN_REQ;
			sc_time delay = sc_core::SC_ZERO_TIME;

			trans_ptr.set_extension(ext_ptr);
			m2_bus_init_socket_tagged[core_id]->nb_transport_fw(trans_ptr, phase, delay);

			tlm::tlm_generic_payload *trans;
			wait(m2_bus_ResponsePEQ.get_event());
			trans = m2_bus_ResponsePEQ.get_next_transaction();
		}

		void m2_mem_write(tlm::tlm_generic_payload &trans_ptr, unsigned int inst_core)
		{
			trans_extension *ext_ptr;
			unsigned int inst_mode = GET_INST(inst_core);
			unsigned int core_id = GET_CORE(inst_core);
			trans_ptr.get_extension(ext_ptr);

			soc_core_req_bit_mask[core_id] |= 1 << 1;
			ext_ptr->inst_core_range = GEN_INST_CORE_RANGE(inst_mode, core_id, M2_RANGE);
			tlm::tlm_phase phase = tlm::BEGIN_REQ;
			sc_time delay = sc_core::SC_ZERO_TIME;

			trans_ptr.set_extension(ext_ptr);
			m2_bus_init_socket_tagged[core_id]->nb_transport_fw(trans_ptr, phase, delay);

			tlm::tlm_generic_payload *trans;
			wait(m2_bus_ResponsePEQ.get_event());
			trans = m2_bus_ResponsePEQ.get_next_transaction();
		}

		void ddr_mem_read(tlm::tlm_generic_payload &trans_ptr, unsigned int inst_core)
		{
			trans_extension *ext_ptr;
			unsigned int inst_mode = GET_INST(inst_core);
			unsigned int core_id = GET_CORE(inst_core);
			trans_ptr.get_extension(ext_ptr);

			soc_core_req_bit_mask[core_id] |= 1 << 2;
			ext_ptr->inst_core_range = GEN_INST_CORE_RANGE(inst_mode, core_id, DDR_RANGE);
			tlm::tlm_phase phase = tlm::BEGIN_REQ;
			sc_time delay = sc_core::SC_ZERO_TIME;

			trans_ptr.set_extension(ext_ptr);
			biu_bus_init_socket_tagged[core_id]->nb_transport_fw(trans_ptr, phase, delay);

			tlm::tlm_generic_payload *trans;
			wait(biu_bus_ResponsePEQ.get_event());
			trans = biu_bus_ResponsePEQ.get_next_transaction();
		}

		void ddr_mem_write(tlm::tlm_generic_payload &trans_ptr, unsigned int inst_core)
		{
			trans_extension *ext_ptr;
			unsigned int inst_mode = GET_INST(inst_core);
			unsigned int core_id = GET_CORE(inst_core);
			trans_ptr.get_extension(ext_ptr);

			soc_core_req_bit_mask[core_id] |= 1 << 2;
			ext_ptr->inst_core_range = GEN_INST_CORE_RANGE(inst_mode, core_id, DDR_RANGE);
			tlm::tlm_phase phase = tlm::BEGIN_REQ;
			sc_time delay = sc_core::SC_ZERO_TIME;

			trans_ptr.set_extension(ext_ptr);
			biu_bus_init_socket_tagged[core_id]->nb_transport_fw(trans_ptr, phase, delay);

			tlm::tlm_generic_payload *trans;
			wait(biu_bus_ResponsePEQ.get_event());
			trans = biu_bus_ResponsePEQ.get_next_transaction();
		}

		void dmu_mem_read(tlm::tlm_generic_payload &trans_ptr, unsigned int inst_core)
		{
			trans_extension *ext_ptr;
			unsigned int inst_mode = GET_INST(inst_core);
			unsigned int core_id = GET_CORE(inst_core);
			trans_ptr.get_extension(ext_ptr);

			soc_core_req_bit_mask[core_id] |= 1 << 0;

			switch (inst_mode) {
			case INST_SC:
				ext_ptr->inst_core_range = GEN_INST_CORE_RANGE(INST_DMU_SC, core_id, M1_RANGE);
				break;
			case INST_C1:
				ext_ptr->inst_core_range = GEN_INST_CORE_RANGE(INST_DMU_C1, core_id, M1_RANGE);
				break;
			case INST_C2:
				ext_ptr->inst_core_range = GEN_INST_CORE_RANGE(INST_DMU_C2, core_id, M1_RANGE);
				break;
			default:
				break;
			}

			tlm::tlm_phase phase = tlm::BEGIN_REQ;
			sc_time delay = sc_core::SC_ZERO_TIME;
			trans_ptr.set_extension(ext_ptr);
			dmu_bus_init_socket_tagged[core_id]->nb_transport_fw(trans_ptr, phase, delay);

			tlm::tlm_generic_payload *trans;
			wait(dmu_bus_ResponsePEQ.get_event());
			trans = dmu_bus_ResponsePEQ.get_next_transaction();
		}

		void dmu_mem_write(tlm::tlm_generic_payload &trans_ptr, unsigned int inst_core)
		{
			trans_extension *ext_ptr;
			unsigned int inst_mode = GET_INST(inst_core);
			unsigned int core_id = GET_CORE(inst_core);
			trans_ptr.get_extension(ext_ptr);

			soc_core_req_bit_mask[core_id] |= 1 << 0;
			switch (inst_mode) {
			case INST_SC:
				ext_ptr->inst_core_range = GEN_INST_CORE_RANGE(INST_DMU_SC, core_id, M1_RANGE);
				break;
			case INST_C1:
				ext_ptr->inst_core_range = GEN_INST_CORE_RANGE(INST_DMU_C1, core_id, M1_RANGE);
				break;
			case INST_C2:
				ext_ptr->inst_core_range = GEN_INST_CORE_RANGE(INST_DMU_C2, core_id, M1_RANGE);
				break;
			default:
				break;
			}

			tlm::tlm_phase phase = tlm::BEGIN_REQ;
			sc_time delay = sc_core::SC_ZERO_TIME;

			trans_ptr.set_extension(ext_ptr);
			dmu_bus_init_socket_tagged[core_id]->nb_transport_fw(trans_ptr, phase, delay);

			tlm::tlm_generic_payload *trans;
			wait(dmu_bus_ResponsePEQ.get_event());
			trans = dmu_bus_ResponsePEQ.get_next_transaction();
		}

	private:
		tlm::tlm_sync_enum nb_transport_bw(int portId, tlm::tlm_generic_payload &trans, tlm::tlm_phase &phase, sc_time &delay)
		{
			sc_dt::uint64 addr;
			unsigned int len;
			trans_extension *ext_ptr;
			trans.get_extension(ext_ptr);
			int core_id = GET_CORE(ext_ptr->inst_core_range);
			addr = trans.get_address();
			len = trans.get_data_length();
			if (phase == tlm::BEGIN_RESP) {
				if (ext_ptr->flag == ISS_DATA) {
					if (((addr >= m1_bus_base_array[core_id])
							&& ((addr + len) < (m1_bus_base_array[core_id] + m1_bus_size_array[core_id])))
							|| ((addr >= c2cc_base) && (addr < c2cc_base + c2cc_size))) {
						m1_bus_ResponsePEQ.notify(trans, delay);	
					} else if ((addr >= m2_bus_base) && ((addr + len) < (m2_bus_base + m2_bus_size))) {
						m2_bus_ResponsePEQ.notify(trans, delay);
					} else if (((addr >= biu_bus_base) && ((addr + len) < (biu_bus_base + biu_bus_size)))
							|| ((addr >= sysdma_base) && ((addr + len) < (sysdma_base + sysdma_size)))) {
						biu_bus_ResponsePEQ.notify(trans, delay);
					} else {
						for (i = 0; i < DSPNUM; i++) {
							if ((addr >= m1_bus_base_array[i]) && ((addr + len) < (m1_bus_base_array[i] + m1_bus_size_array[i]))) {
								dmu_bus_ResponsePEQ.notify(trans, delay);
								break;
							}
						}
					}
				}
			}
			return tlm::TLM_COMPLETED;
		}

		int dbg_addr_valid(int *core_id, int range, unsigned int addr, int len)
		{
			unsigned int i;
			int ret = -1;
			switch (range) {
				case DBG_CORE_M1_MEM:
					for (i = 0; i < DSPNUM; i++) {
						*core_id = i;
						if ((addr >= multi_arg(pacdsp[i], core_base) + multi_arg(pacdsp[i].m1_mem, dmem_m1_offset)) &&
							(addr < multi_arg(pacdsp[i], core_base) + multi_arg(pacdsp[i].m1_mem, dmem_m1_offset) +
				 			multi_arg(pacdsp[i].m1_mem, dmem_m1_size)) && ((addr + len) < multi_arg(pacdsp[i], core_base) +
							multi_arg(pacdsp[i].m1_mem, dmem_m1_offset) + multi_arg(pacdsp[i].m1_mem, dmem_m1_size))) {
							ret = 1;
							break;
						} else if ((addr >= multi_arg(pacdsp[i], core_base) + multi_arg(pacdsp[i].m1_mem, dmem_m1_offset)) &&
					   		(addr < multi_arg(pacdsp[i], core_base) + multi_arg(pacdsp[i].m1_mem, dmem_m1_offset) +
							multi_arg(pacdsp[i].m1_mem, dmem_m1_size)) && ((addr + len) >= multi_arg(pacdsp[i], core_base) +
							multi_arg(pacdsp[i].m1_mem, dmem_m1_offset) + multi_arg(pacdsp[i].m1_mem, dmem_m1_size))) {
							ret = 2;
							break;
						}
					}
				break;
				case DBG_CORE_BIU:
					for (i = 0; i < DSPNUM; i++) {
						*core_id = i;
						if ((addr >= multi_arg(pacdsp[i], core_base) + multi_arg(pacdsp[i].biu, biu_offset)) &&
							(addr < multi_arg(pacdsp[i], core_base) + multi_arg(pacdsp[i].biu, biu_offset) +
				 			multi_arg(pacdsp[i].biu, biu_size)) && ((addr + len) < multi_arg(pacdsp[i], core_base) +
							multi_arg(pacdsp[i].biu, biu_offset) + multi_arg(pacdsp[i].biu, biu_size))) {
							ret = 1;
							break;
						} else if ((addr >= multi_arg(pacdsp[i], core_base) + multi_arg(pacdsp[i].biu, biu_offset)) &&
					   		(addr < multi_arg(pacdsp[i], core_base) + multi_arg(pacdsp[i].biu, biu_offset) +
							multi_arg(pacdsp[i].biu, biu_size)) && ((addr + len) >= multi_arg(pacdsp[i], core_base) +
							multi_arg(pacdsp[i].biu, biu_offset) + multi_arg(pacdsp[i].biu, biu_size))) {
							ret = 2;
							break;
						}
					}
				break;
				case DBG_CORE_ICU:
					for (i = 0; i < DSPNUM; i++) {
						*core_id = i;
						if ((addr >= multi_arg(pacdsp[i], core_base) + multi_arg(pacdsp[i].icu, icu_offset)) &&
							(addr < multi_arg(pacdsp[i], core_base) + multi_arg(pacdsp[i].icu, icu_offset) +
				 			multi_arg(pacdsp[i].icu, icu_size)) && ((addr + len) < multi_arg(pacdsp[i], core_base) +
							multi_arg(pacdsp[i].icu, icu_offset) + multi_arg(pacdsp[i].icu, icu_size))) {
							ret = 1;
							break;
						} else if ((addr >= multi_arg(pacdsp[i], core_base) + multi_arg(pacdsp[i].icu, icu_offset)) &&
					   		(addr < multi_arg(pacdsp[i], core_base) + multi_arg(pacdsp[i].icu, icu_offset) +
							multi_arg(pacdsp[i].icu, icu_size)) && ((addr + len) >= multi_arg(pacdsp[i], core_base) +
							multi_arg(pacdsp[i].icu, icu_offset) + multi_arg(pacdsp[i].icu, icu_size))) {
							ret = 2;
							break;
						}
					}
				break;
				case DBG_CORE_DMU:
					for (i = 0; i < DSPNUM; i++) {
						*core_id = i;
						if ((addr >= multi_arg(pacdsp[i], core_base) + multi_arg(pacdsp[i].dmu, dmu_offset)) &&
							(addr < multi_arg(pacdsp[i], core_base) + multi_arg(pacdsp[i].dmu, dmu_offset) +
				 			multi_arg(pacdsp[i].dmu, dmu_size)) && ((addr + len) < multi_arg(pacdsp[i], core_base) +
							multi_arg(pacdsp[i].dmu, dmu_offset) + multi_arg(pacdsp[i].dmu, dmu_size))) {
							ret = 1;
							break;
						} else if ((addr >= multi_arg(pacdsp[i], core_base) + multi_arg(pacdsp[i].dmu, dmu_offset)) &&
					   		(addr < multi_arg(pacdsp[i], core_base) + multi_arg(pacdsp[i].dmu, dmu_offset) +
							multi_arg(pacdsp[i].dmu, dmu_size)) && ((addr + len) >= multi_arg(pacdsp[i], core_base) +
							multi_arg(pacdsp[i].dmu, dmu_offset) + multi_arg(pacdsp[i].dmu, dmu_size))) {
							ret = 2;
							break;
						}
					}
				break;
				case DBG_CORE_DMA:
					for (i = 0; i < DSPNUM; i++) {
						*core_id = i;
						if ((addr >= multi_arg(pacdsp[i], core_base) + multi_arg(pacdsp[i].dma, dma_offset)) &&
							(addr < multi_arg(pacdsp[i], core_base) + multi_arg(pacdsp[i].dma, dma_offset) +
				 			multi_arg(pacdsp[i].dma, dma_size)) && ((addr + len) < multi_arg(pacdsp[i], core_base) +
				 			multi_arg(pacdsp[i].dma, dma_offset) + multi_arg(pacdsp[i].dma, dma_size))) {
							ret = 1;
							break;
						} else if ((addr >= multi_arg(pacdsp[i], core_base) + multi_arg(pacdsp[i].dma, dma_offset)) &&
					   		(addr < multi_arg(pacdsp[i], core_base) + multi_arg(pacdsp[i].dma, dma_offset) +
							multi_arg(pacdsp[i].dma, dma_size)) && ((addr + len) >= multi_arg(pacdsp[i], core_base) +
							multi_arg(pacdsp[i].dma, dma_offset) + multi_arg(pacdsp[i].dma, dma_size))) {
							ret = 2;
							break;
						}
					}
				break;
				case DBG_M2_MEM:
					if ((addr >= multi_arg(m2_mem, dmem_m2_base)) && (addr < multi_arg(m2_mem, dmem_m2_base) +
						multi_arg(m2_mem, dmem_m2_size)) && ((addr + len) < multi_arg(m2_mem, dmem_m2_base) + 
						multi_arg(m2_mem, dmem_m2_size))) {
						ret = 1;
					} else if ((addr >= multi_arg(m2_mem, dmem_m2_base)) && (addr < multi_arg(m2_mem, dmem_m2_base) +
						multi_arg(m2_mem, dmem_m2_size)) && ((addr + len) >= multi_arg(m2_mem, dmem_m2_base) + 
						multi_arg(m2_mem, dmem_m2_size))) {
						ret = 2;
					}
				break;
				case DBG_M2_ICU:
					if ((addr >= multi_arg(l2_icu, l2_icu_base)) && (addr < multi_arg(l2_icu, l2_icu_base) +
						multi_arg(l2_icu, l2_icu_size)) && ((addr + len) < multi_arg(l2_icu, l2_icu_base) + 
						multi_arg(l2_icu, l2_icu_size))) {
						ret = 1;
					} else if ((addr >= multi_arg(l2_icu, l2_icu_base)) && (addr < multi_arg(l2_icu, l2_icu_base) +
						multi_arg(l2_icu, l2_icu_size)) && ((addr + len) >= multi_arg(l2_icu, l2_icu_base) + 
						multi_arg(l2_icu, l2_icu_size))) {
						ret = 2;
					}
				break;
				case DBG_M2_DMU:
					if ((addr >= multi_arg(m2_dmu, m2_dmu_base)) &&
						(addr < multi_arg(m2_dmu, m2_dmu_base) + multi_arg(m2_dmu, m2_dmu_size)) &&
						((addr + len) < multi_arg(m2_dmu, m2_dmu_base) + multi_arg(m2_dmu, m2_dmu_size))) {
						ret = 1;
					} else if ((addr >= multi_arg(m2_dmu, m2_dmu_base)) &&
				   		(addr < multi_arg(m2_dmu, m2_dmu_base) + multi_arg(m2_dmu, m2_dmu_size)) &&
				   		((addr + len) >= multi_arg(m2_dmu, m2_dmu_base) + multi_arg(m2_dmu, m2_dmu_size))) {
						ret = 2;
					}
				break;
				case DBG_M2_DMA:
					if ((addr >= multi_arg(m2_dma, m2_dma_base)) &&
						(addr < multi_arg(m2_dma, m2_dma_base) + multi_arg(m2_dma, m2_dma_size)) &&
						((addr + len) < multi_arg(m2_dma, m2_dma_base) + multi_arg(m2_dma, m2_dma_size))) {
						ret = 1;
					} else if ((addr >= multi_arg(m2_dma, m2_dma_base)) &&
				   		(addr < multi_arg(m2_dma, m2_dma_base) + multi_arg(m2_dma, m2_dma_size)) &&
				   		((addr + len) >= multi_arg(m2_dma, m2_dma_base) + multi_arg(m2_dma, m2_dma_size))) {
						ret = 2;
					}
				break;
				case DBG_C2CC_INTERFACE:
					if ((addr >= multi_arg(c2cc, c2cc_base)) &&
						(addr < multi_arg(c2cc, c2cc_base) + multi_arg(c2cc, c2cc_size)) &&
						((addr + len) < multi_arg(c2cc, c2cc_base) + multi_arg(c2cc, c2cc_size))) {
						ret = 1;
					} else if ((addr >= multi_arg(c2cc, c2cc_base)) &&
				   		(addr < multi_arg(c2cc, c2cc_base) + multi_arg(c2cc, c2cc_size)) &&
				   		((addr + len) >= multi_arg(c2cc, c2cc_base) + multi_arg(c2cc, c2cc_size))) {
					ret = 2;
					}
				break;
				case DBG_DDR_MEM:
					if ((addr >= multi_arg(ddr_mem, ddr_memory_base)) &&
						(addr < multi_arg(ddr_mem, ddr_memory_base) + multi_arg(ddr_mem, ddr_memory_size)) &&
						((addr + len) < multi_arg(ddr_mem, ddr_memory_base) + multi_arg(ddr_mem, ddr_memory_size))) {
						ret = 1;
					} else if ((addr >= multi_arg(ddr_mem, ddr_memory_base)) &&
				   		(addr < multi_arg(ddr_mem, ddr_memory_base) + multi_arg(ddr_mem, ddr_memory_size)) &&
				   		((addr + len) >= multi_arg(ddr_mem, ddr_memory_base) + multi_arg(ddr_mem, ddr_memory_size))) {
						ret = 2;
					}
				break;
				case DBG_SYS_DMA:
					if ((addr >= multi_arg(sys_dma, sys_dma_base)) &&
						(addr < multi_arg(sys_dma, sys_dma_base) + multi_arg(sys_dma, sys_dma_size)) &&
						((addr + len) < multi_arg(sys_dma, sys_dma_base) + multi_arg(sys_dma, sys_dma_size))) {
						ret = 1;
					} else if ((addr >= multi_arg(sys_dma, sys_dma_base)) &&
				   		(addr < multi_arg(sys_dma, sys_dma_base) + multi_arg(sys_dma, sys_dma_size)) &&
				   		((addr + len) >= multi_arg(sys_dma, sys_dma_base) + multi_arg(sys_dma, sys_dma_size))) {
						ret = 2;
					}
				break;
				default:
					ret = -1;
				break;
			}
			return ret;
		}
		
		tlm::tlm_sync_enum nb_transport_fw(int id, tlm::tlm_generic_payload &trans, tlm::tlm_phase &phase, sc_time & t)
		{
			if(phase == tlm::BEGIN_REQ) {
				addPendingTransaction(trans, 0, id);
				d2_bus_RequestPEQ.notify(trans, t);
			}

			return tlm::TLM_ACCEPTED;
		}

		void b_transport(int id, tlm::tlm_generic_payload & trans, sc_time & t)
		{
			trans_extension *ext_ptr;
			trans.get_extension(ext_ptr);
			tlm::tlm_command cmd = trans.get_command();
			sc_dt::uint64 addr = trans.get_address();
			unsigned int len = trans.get_data_length();
			sc_time delay = sc_core::SC_ZERO_TIME;

			unsigned int range;
			int ret;
			int core_id = 0, miss = 0;
			int length = len;
			int coreid = GET_CORE(ext_ptr->inst_core_range);

//flush dcache			
			unsigned int i;
			unsigned int offset;
			tlm::tlm_generic_payload cache_trans;
			lock(w_lock);
			for (offset = 0; offset < (d2_dcache_size / d2_dcache_line_size); offset++) {
				if (d2_dcache_mem[offset].flag.dirty == 1) {
					sc_dt::uint64 write_addr = (d2_dcache_mem[offset].flag.tag << 16)
											| (offset << 8);

					unsigned int write_length = d2_dcache_line_size;
					cache_trans.set_address(write_addr);
					cache_trans.set_data_length(write_length);
					cache_trans.set_data_ptr(d2_dcache_mem[offset].insn);
					cache_trans.set_command(tlm::TLM_WRITE_COMMAND);

					if ((write_addr >= m2_bus_base) && ((write_addr + write_length) < (m2_bus_base + m2_bus_size))){
						m2_bus_init_socket_tagged[0]->b_transport(cache_trans, delay);
					} else if (((write_addr >= biu_bus_base) && ((write_addr + write_length) < (biu_bus_base + biu_bus_size))))
					{
						biu_bus_init_socket_tagged[0]->b_transport(cache_trans, delay);
					} else {
						for (i = 0; i < DSPNUM; i++) {
							if ((write_addr >= m1_bus_base_array[i])
								&& ((write_addr + write_length) < (m1_bus_base_array[i] + m1_bus_size_array[i]))) {
								m1_bus_init_socket_tagged[i]->b_transport(cache_trans, delay);
								break;
							}
						}
					}
				}
//set all to invalid					
				d2_dcache_mem[offset].flag.tag = 0;
				d2_dcache_mem[offset].flag.index = 0;
				d2_dcache_mem[offset].flag.reserved = 0;
				d2_dcache_mem[offset].flag.invalid = 1;
				d2_dcache_mem[offset].flag.dirty = 0;
				memset(d2_dcache_mem[offset].insn, 0, d2_dcache_line_size);
			}
			unlock(w_lock);

			if (cmd == tlm::TLM_READ_COMMAND) {
				lock(r_lock);
				for (range = DBG_CORE_M1_MEM; range <= DBG_SYS_DMA; range++) {
					ret = dbg_addr_valid(&core_id, range, addr, len);
					if (ret == 1) {
						break;
					} else if (ret == 2) {
						printf("addr(0x%llx) + len(0x%08x) is out of memory range(%d)\r\n", addr, len, range);
						switch (range) {
						case DBG_CORE_M1_MEM:
							length -= addr + length - multi_arg(pacdsp[core_id], core_base) -
								multi_arg(pacdsp[core_id].m1_mem, dmem_m1_offset)
								- multi_arg(pacdsp[core_id].m1_mem, dmem_m1_size) + 1;
						break;
						case DBG_CORE_BIU:
							length -= addr + length - multi_arg(pacdsp[core_id], core_base) -
								multi_arg(pacdsp[core_id].biu, biu_offset) - multi_arg(pacdsp[core_id].biu, biu_size) + 1;
						break;
						case DBG_CORE_ICU:
							length -= addr + length - multi_arg(pacdsp[core_id], core_base) -
								multi_arg(pacdsp[core_id].icu, icu_offset) - multi_arg(pacdsp[core_id].icu, icu_size) + 1;
						break;
						case DBG_CORE_DMU:
							length -= addr + length - multi_arg(pacdsp[core_id], core_base) -
								multi_arg(pacdsp[core_id].dmu, dmu_offset) - multi_arg(pacdsp[core_id].dmu, dmu_size) + 1;
						break;
						case DBG_CORE_DMA:
							length -= addr + length - multi_arg(pacdsp[core_id], core_base) -
								multi_arg(pacdsp[core_id].dma, dma_offset) - multi_arg(pacdsp[core_id].dma, dma_size) + 1;
						break;
						case DBG_M2_MEM:
							length -= addr + length - multi_arg(m2_mem, dmem_m2_base) - multi_arg(m2_mem, dmem_m2_size) + 1;
						break;
						case DBG_M2_ICU:
							length -= addr + length - multi_arg(l2_icu, l2_icu_base) - multi_arg(l2_icu, l2_icu_size) + 1;
						break;
						case DBG_M2_DMU:
							length -= addr + length - multi_arg(m2_dmu, m2_dmu_base) - multi_arg(m2_dmu, m2_dmu_size) + 1;
						break;
						case DBG_M2_DMA:
							length -= addr + length - multi_arg(m2_dma, m2_dma_base) - multi_arg(m2_dma, m2_dma_size) + 1;
						break;
						case DBG_C2CC_INTERFACE:
							length -= addr + length - multi_arg(c2cc, c2cc_base) - multi_arg(c2cc, c2cc_size) + 1;
						break;
						case DBG_DDR_MEM:
							length -= addr + length
									- multi_arg(ddr_mem, ddr_memory_base) - multi_arg(ddr_mem, ddr_memory_size) + 1;
						break;
						case DBG_SYS_DMA:
							length -= addr + length - multi_arg(sys_dma, sys_dma_base) - multi_arg(sys_dma, sys_dma_size) + 1;
						break;
						}
						printf("\nNow that read mem addr(0x%llx) len(0x%08x)\r\n", addr, length);
						break;
					}
				}
				if (ret == -1) {
					printf("Not that memory in simulator addr(0x%llx) len(0x%08x)\r\n", addr, length);
				}
	
				trans.set_data_length(length);
				miss = dbg_d2cache_read(trans);

				if (miss == CACHE_MISS) {
					if (((addr >= m1_bus_base_array[coreid])
							&& ((addr + len) < (m1_bus_base_array[coreid] + m1_bus_size_array[coreid])))
							|| ((addr >= c2cc_base) && (addr < c2cc_base + c2cc_size)))
					{

						m1_bus_init_socket_tagged[coreid]->b_transport(trans, delay);
					} else if ((addr >= m2_bus_base) && ((addr + len) < (m2_bus_base + m2_bus_size))){

						m2_bus_init_socket_tagged[coreid]->b_transport(trans, delay);
					} else if (((addr >= biu_bus_base) && ((addr + len) < (biu_bus_base + biu_bus_size)))
							|| ((addr >= sysdma_base) && ((addr + len) < (sysdma_base + sysdma_size)))){

						biu_bus_init_socket_tagged[coreid]->b_transport(trans, delay);
					} else {
						for (i = 0; i < DSPNUM; i++) {
							if ((addr >= m1_bus_base_array[i])
									&& ((addr + len) < (m1_bus_base_array[i] + m1_bus_size_array[i])))
							{
								dmu_bus_init_socket_tagged[i]->b_transport(trans, delay);
								break;
							}
						}

						if (i == DSPNUM) {
							printf("b_transport No read mem address (0x%llx) in simualtor\r\n",addr);
						}
					}
				}
				unlock(r_lock);
			} else if (cmd == tlm::TLM_WRITE_COMMAND) {
				lock(w_lock);
				for (range = DBG_CORE_M1_MEM; range <= DBG_SYS_DMA; range++) {
					ret = dbg_addr_valid(&core_id, range, addr, len);
					if (ret == 1) {
						break;
					} else if (ret == 2) {
						printf("addr(0x%llx) + len(0x%08x) is out of memory range(%d)\r\n", addr, len, range);
						switch (range) {
						case DBG_CORE_M1_MEM:
							length -= addr + length - multi_arg(pacdsp[core_id], core_base) -
								multi_arg(pacdsp[core_id].m1_mem, dmem_m1_offset)
								- multi_arg(pacdsp[core_id].m1_mem, dmem_m1_size) + 1;
						break;
						case DBG_CORE_BIU:
							length -= addr + length - multi_arg(pacdsp[core_id], core_base) -
								multi_arg(pacdsp[core_id].biu, biu_offset) - multi_arg(pacdsp[core_id].biu, biu_size) + 1;
						break;
						case DBG_CORE_ICU:
							length -= addr + length - multi_arg(pacdsp[core_id], core_base) -
								multi_arg(pacdsp[core_id].icu, icu_offset) - multi_arg(pacdsp[core_id].icu, icu_size) + 1;
						break;
						case DBG_CORE_DMU:
							length -= addr + length - multi_arg(pacdsp[core_id], core_base) -
								multi_arg(pacdsp[core_id].dmu, dmu_offset) - multi_arg(pacdsp[core_id].dmu, dmu_size) + 1;
						break;
						case DBG_CORE_DMA:
							length -= addr + length - multi_arg(pacdsp[core_id], core_base) -
								multi_arg(pacdsp[core_id].dma, dma_offset) - multi_arg(pacdsp[core_id].dma, dma_size) + 1;
						break;
						case DBG_M2_MEM:
							length -= addr + length - multi_arg(m2_mem, dmem_m2_base) - multi_arg(m2_mem, dmem_m2_size) + 1;
						break;
						case DBG_M2_ICU:
							length -= addr + length - multi_arg(l2_icu, l2_icu_base) - multi_arg(l2_icu, l2_icu_size) + 1;
						break;
						case DBG_M2_DMU:
							length -= addr + length - multi_arg(m2_dmu, m2_dmu_base) - multi_arg(m2_dmu, m2_dmu_size) + 1;
						break;
						case DBG_M2_DMA:
							length -= addr + length - multi_arg(m2_dma, m2_dma_base) - multi_arg(m2_dma, m2_dma_size) + 1;
						break;
						case DBG_C2CC_INTERFACE:
							length -= addr + length - multi_arg(c2cc, c2cc_base) - multi_arg(c2cc, c2cc_size) + 1;
						break;
						case DBG_DDR_MEM:
							length -= addr + length - multi_arg(ddr_mem, ddr_memory_base)
									- multi_arg(ddr_mem, ddr_memory_size) + 1;
						break;
						case DBG_SYS_DMA:
							length -= addr + length - multi_arg(sys_dma, sys_dma_base) - multi_arg(sys_dma, sys_dma_size) + 1;
						break;
						}
						printf("\nNow that write mem addr(0x%llx) len(0x%08x)\r\n", addr, length);
						break;
					}
				}
				if (ret == -1) {
					printf("Not that memory in simulator addr(0x%llx) len(0x%08x)\r\n", addr, length);
				}
	
				trans.set_data_length(length);
				miss = dbg_d2cache_write(trans);

				if (miss == CACHE_MISS) {
					if (((addr >= m1_bus_base_array[coreid])
							&& ((addr + len) < (m1_bus_base_array[coreid] + m1_bus_size_array[coreid])))
							|| ((addr >= c2cc_base) && (addr < c2cc_base + c2cc_size)))
					{
						m1_bus_init_socket_tagged[coreid]->b_transport(trans, delay);
					} else if ((addr >= m2_bus_base) && ((addr + len) < (m2_bus_base + m2_bus_size))){
						m2_bus_init_socket_tagged[coreid]->b_transport(trans, delay);
					} else if (((addr >= biu_bus_base) && ((addr + len) < (biu_bus_base + biu_bus_size)))
							|| ((addr >= sysdma_base) && ((addr + len) < (sysdma_base + sysdma_size)))){
						biu_bus_init_socket_tagged[coreid]->b_transport(trans, delay);
					} else {
						for (i = 0; i < DSPNUM; i++) {
							if ((addr >= m1_bus_base_array[i]) && ((addr + len) < (m1_bus_base_array[i] + m1_bus_size_array[i]))) {
								dmu_bus_init_socket_tagged[coreid]->b_transport(trans, delay);
								break;
							}
						}

						if (i == DSPNUM) {
							printf("b_transport No write mem address(0x%llx) in simualtor\r\n",addr);
						}
					}
				}
				unlock(w_lock);
			}
		}

		void lock(unsigned int lock)
		{
			//printf("lock !!\r\n");
			while (lock != 0) {
				printf("still lock !!\r\n");
			}

			lock = 1;
		}

		void unlock(unsigned int lock)
		{
			//printf("unlock !!\r\n");
			lock = 0;
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
};

#else //IN PAC_SOC_PROFILE
struct D2_Bus:public sc_core::sc_module, public pac_bus
{
	private:
		struct sim_arg *multi_sim_arg;
		unsigned int m1_bus_base_array[DSPNUM], m1_bus_size_array[DSPNUM];
		unsigned int m2_bus_base, m2_bus_size;
		unsigned int biu_bus_base, biu_bus_size;
		unsigned int sysdma_base, sysdma_size;
		unsigned int c2cc_base, c2cc_size;
		unsigned int i;

	public:
		tlm_utils::simple_initiator_socket_tagged < D2_Bus > m1_bus_init_socket_tagged[DSPNUM];
		tlm_utils::simple_initiator_socket_tagged < D2_Bus > m2_bus_init_socket_tagged[DSPNUM];
		tlm_utils::simple_initiator_socket_tagged < D2_Bus > biu_bus_init_socket_tagged[DSPNUM];
		tlm_utils::simple_initiator_socket_tagged < D2_Bus > dmu_bus_init_socket_tagged[DSPNUM];
		
		tlm_utils::simple_target_socket_tagged < D2_Bus > d2_bus_targ_socket_tagged[DSPNUM+1];	//connect to core_bus

		tlm_utils::peq_with_get < tlm::tlm_generic_payload > m1_bus_ResponsePEQ;
		tlm_utils::peq_with_get < tlm::tlm_generic_payload > m2_bus_ResponsePEQ;
		tlm_utils::peq_with_get < tlm::tlm_generic_payload > biu_bus_ResponsePEQ;
		tlm_utils::peq_with_get < tlm::tlm_generic_payload > dmu_bus_ResponsePEQ;

		tlm_utils::peq_with_get < tlm::tlm_generic_payload > d2_bus_RequestPEQ;

		SC_HAS_PROCESS(D2_Bus);	
		
	public:
		D2_Bus(sc_module_name _name, struct sim_arg *arg)
		: sc_core::sc_module(_name)
		, multi_sim_arg(arg)
		, m1_bus_ResponsePEQ("m1_bus_ResponsePEQ")
		, m2_bus_ResponsePEQ("m2_bus_ResponsePEQ")
		, biu_bus_ResponsePEQ("biu_bus_ResponsePEQ")
		, dmu_bus_ResponsePEQ("dmu_bus_ResponsePEQ")
		, d2_bus_RequestPEQ("d2_bus_RequestPEQ")
		{
			for (i = 0; i < DSPNUM; i++) {
				m1_bus_base_array[i] = multi_arg(pacdsp[i], core_base);

				m1_bus_size_array[i] += multi_arg(pacdsp[i].m1_mem, dmem_m1_size)
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

			for (i = 0; i < DSPNUM; i++) {
				m1_bus_init_socket_tagged[i].register_nb_transport_bw(this, &D2_Bus::nb_transport_bw, i);
				m2_bus_init_socket_tagged[i].register_nb_transport_bw(this, &D2_Bus::nb_transport_bw, i);
				biu_bus_init_socket_tagged[i].register_nb_transport_bw(this, &D2_Bus::nb_transport_bw, i);
				dmu_bus_init_socket_tagged[i].register_nb_transport_bw(this, &D2_Bus::nb_transport_bw, i);
			}

			for (i = 0; i < (DSPNUM + 1); i++) {
				d2_bus_targ_socket_tagged[i].register_nb_transport_fw(this, &D2_Bus::nb_transport_fw, i);
				d2_bus_targ_socket_tagged[i].register_b_transport(this, &D2_Bus::b_transport, i);
			}

			SC_THREAD(D2_Bus_Request_Thread);
		}

		~D2_Bus()
		{}

	private:
		void D2_Bus_Request_Thread()
		{
			trans_extension *ext_ptr;
			tlm::tlm_generic_payload *trans_ptr;
			tlm::tlm_phase phase = tlm::BEGIN_REQ;
			sc_core::sc_time t = sc_core::SC_ZERO_TIME;
			sc_dt::uint64 addr;
			unsigned int len, i;
			int cmd, core_id, miss = 0;

			while (true) {
				wait(d2_bus_RequestPEQ.get_event());
				while(true) {
					trans_ptr = d2_bus_RequestPEQ.get_next_transaction();
					if (trans_ptr == NULL) {
							break;
					}

					addr = trans_ptr->get_address();
					len = trans_ptr->get_data_length();
					trans_ptr->get_extension(ext_ptr);
					cmd = trans_ptr->get_command();
					core_id = GET_CORE(ext_ptr->inst_core_range);

					if (cmd == tlm::TLM_READ_COMMAND) {
						miss = d2_cache_read(trans_ptr);
						if (miss == CACHE_MISS) {
							if (((addr >= m1_bus_base_array[core_id])
								&& ((addr + len) < (m1_bus_base_array[core_id] + m1_bus_size_array[core_id])))
								|| ((addr >= c2cc_base) && (addr < c2cc_base + c2cc_size))) {
	
								m1_mem_read(*trans_ptr, ext_ptr->inst_core_range);
							} else if ((addr >= m2_bus_base) && ((addr + len) < (m2_bus_base + m2_bus_size))) {
	
								m2_mem_read(*trans_ptr, ext_ptr->inst_core_range);
							} else if (((addr >= biu_bus_base) && ((addr + len) < (biu_bus_base + biu_bus_size)))
											|| ((addr >= sysdma_base) && ((addr + len) < (sysdma_base + sysdma_size)))) {
	
								ddr_mem_read(*trans_ptr, ext_ptr->inst_core_range);
							} else {
								for (i = 0; i < DSPNUM; i++) {
									if ((addr >= m1_bus_base_array[i])
										&& ((addr + len) < (m1_bus_base_array[i] + m1_bus_size_array[i]))) {
	
										dmu_mem_read(*trans_ptr, ext_ptr->inst_core_range);
										//dmu_flag |= 1 << i;
										break;
									}
								}
								if (i == DSPNUM) {
									printf("No read mem address (0x%llx) in simulator\r\n", addr);
									//debug_inst[core_id] = 1;
								}
							}
						}
					} else if (cmd == tlm::TLM_WRITE_COMMAND) {
						miss = d2_cache_write(trans_ptr); 
						if (miss == CACHE_MISS) {
							if (((addr >= m1_bus_base_array[core_id])
								&& ((addr + len) < (m1_bus_base_array[core_id] + m1_bus_size_array[core_id])))
								|| ((addr >= c2cc_base) && (addr < c2cc_base + c2cc_size))) {
	
								m1_mem_write(*trans_ptr, ext_ptr->inst_core_range);
							} else if ((addr >= m2_bus_base) && ((addr + len) < (m2_bus_base + m2_bus_size))) {
	
								m2_mem_write(*trans_ptr, ext_ptr->inst_core_range);
							} else if (((addr >= biu_bus_base) && ((addr + len) < (biu_bus_base + biu_bus_size)))
										|| ((addr >= sysdma_base) && ((addr + len) < (sysdma_base + sysdma_size)))) {
	
								ddr_mem_write(*trans_ptr, ext_ptr->inst_core_range);
							} else {
								for (i = 0; i < DSPNUM; i++) {
									if ((addr >= m1_bus_base_array[i])
										&& ((addr + len) < (m1_bus_base_array[i] + m1_bus_size_array[i]))) {
	
										dmu_mem_write(*trans_ptr, ext_ptr->inst_core_range);
										//dmu_flag |= 1 << i;
										break;
									}
								}
	
								if (i == DSPNUM) {
									printf("No write mem address (0x%llx) in simulator\r\n", addr);
									//debug_inst[core_id] = 1;
								}
							}
						}	
					}

//					tlm::tlm_phase phase = tlm::BEGIN_RESP;
					PendingTransactionsIterator it = mPendingTransactions.find(trans_ptr);
//					d2_bus_targ_socket_tagged[it->second.from]->nb_transport_bw(*trans_ptr, phase, t);
					mPendingTransactions.erase(it);
				}
			}
		}

	private:
		int d2_cache_read(tlm::tlm_generic_payload *trans_ptr)
		{
			return CACHE_MISS;
		}

		int d2_cache_write(tlm::tlm_generic_payload *trans_ptr)
		{
			return CACHE_MISS;
		}

		int dbg_d2cache_read(tlm::tlm_generic_payload &trans)
		{
			return CACHE_MISS;
		}

		int dbg_d2cache_write(tlm::tlm_generic_payload &trans)
		{
			return CACHE_MISS;
		}

		void m1_mem_read(tlm::tlm_generic_payload &trans_ptr, unsigned int inst_core)
		{
			trans_extension *ext_ptr;
			unsigned int inst_mode = GET_INST(inst_core);
			unsigned int core_id = GET_CORE(inst_core);
			trans_ptr.get_extension(ext_ptr);

			soc_core_req_bit_mask[core_id] |= 1 << 0;
			ext_ptr->inst_core_range = GEN_INST_CORE_RANGE(inst_mode, core_id, M1_RANGE);
			tlm::tlm_phase phase = tlm::BEGIN_REQ;
			sc_time delay = sc_core::SC_ZERO_TIME;

			trans_ptr.set_extension(ext_ptr);
			m1_bus_init_socket_tagged[core_id]->nb_transport_fw(trans_ptr, phase, delay);
	
//			tlm::tlm_generic_payload *trans;
//			wait(m1_bus_ResponsePEQ.get_event());
//			trans = m1_bus_ResponsePEQ.get_next_transaction();
		}

		void m1_mem_write(tlm::tlm_generic_payload &trans_ptr, unsigned int inst_core)
		{
			trans_extension *ext_ptr;
			unsigned int inst_mode = GET_INST(inst_core);
			unsigned int core_id = GET_CORE(inst_core);
			trans_ptr.get_extension(ext_ptr);

			soc_core_req_bit_mask[core_id] |= 1 << 0;
			ext_ptr->inst_core_range = GEN_INST_CORE_RANGE(inst_mode, core_id, M1_RANGE);
			tlm::tlm_phase phase = tlm::BEGIN_REQ;
			sc_time delay = sc_core::SC_ZERO_TIME;

			trans_ptr.set_extension(ext_ptr);
			m1_bus_init_socket_tagged[core_id]->nb_transport_fw(trans_ptr, phase, delay);

//			tlm::tlm_generic_payload *trans;
//			wait(m1_bus_ResponsePEQ.get_event());
//			trans = m1_bus_ResponsePEQ.get_next_transaction();
		}

		void m2_mem_read(tlm::tlm_generic_payload &trans_ptr, unsigned int inst_core)
		{
			trans_extension *ext_ptr;
			unsigned int inst_mode = GET_INST(inst_core);
			unsigned int core_id = GET_CORE(inst_core);
			trans_ptr.get_extension(ext_ptr);

			soc_core_req_bit_mask[core_id] |= 1 << 1;
			ext_ptr->inst_core_range = GEN_INST_CORE_RANGE(inst_mode, core_id, M2_RANGE);
			tlm::tlm_phase phase = tlm::BEGIN_REQ;
			sc_time delay = sc_core::SC_ZERO_TIME;

			trans_ptr.set_extension(ext_ptr);
			m2_bus_init_socket_tagged[core_id]->nb_transport_fw(trans_ptr, phase, delay);

//			tlm::tlm_generic_payload *trans;
//			wait(m2_bus_ResponsePEQ.get_event());
//			trans = m2_bus_ResponsePEQ.get_next_transaction();
		}

		void m2_mem_write(tlm::tlm_generic_payload &trans_ptr, unsigned int inst_core)
		{
			trans_extension *ext_ptr;
			unsigned int inst_mode = GET_INST(inst_core);
			unsigned int core_id = GET_CORE(inst_core);
			trans_ptr.get_extension(ext_ptr);

			soc_core_req_bit_mask[core_id] |= 1 << 1;
			ext_ptr->inst_core_range = GEN_INST_CORE_RANGE(inst_mode, core_id, M2_RANGE);
			tlm::tlm_phase phase = tlm::BEGIN_REQ;
			sc_time delay = sc_core::SC_ZERO_TIME;

			trans_ptr.set_extension(ext_ptr);
			m2_bus_init_socket_tagged[core_id]->nb_transport_fw(trans_ptr, phase, delay);

//			tlm::tlm_generic_payload *trans;
//			wait(m2_bus_ResponsePEQ.get_event());
//			trans = m2_bus_ResponsePEQ.get_next_transaction();
		}

		void ddr_mem_read(tlm::tlm_generic_payload &trans_ptr, unsigned int inst_core)
		{
			trans_extension *ext_ptr;
			unsigned int inst_mode = GET_INST(inst_core);
			unsigned int core_id = GET_CORE(inst_core);
			trans_ptr.get_extension(ext_ptr);

			soc_core_req_bit_mask[core_id] |= 1 << 2;
			ext_ptr->inst_core_range = GEN_INST_CORE_RANGE(inst_mode, core_id, DDR_RANGE);
			tlm::tlm_phase phase = tlm::BEGIN_REQ;
			sc_time delay = sc_core::SC_ZERO_TIME;

			trans_ptr.set_extension(ext_ptr);
			biu_bus_init_socket_tagged[core_id]->nb_transport_fw(trans_ptr, phase, delay);

//			tlm::tlm_generic_payload *trans;
//			wait(biu_bus_ResponsePEQ.get_event());
//			trans = biu_bus_ResponsePEQ.get_next_transaction();
		}

		void ddr_mem_write(tlm::tlm_generic_payload &trans_ptr, unsigned int inst_core)
		{
			trans_extension *ext_ptr;
			unsigned int inst_mode = GET_INST(inst_core);
			unsigned int core_id = GET_CORE(inst_core);
			trans_ptr.get_extension(ext_ptr);

			soc_core_req_bit_mask[core_id] |= 1 << 2;
			ext_ptr->inst_core_range = GEN_INST_CORE_RANGE(inst_mode, core_id, DDR_RANGE);
			tlm::tlm_phase phase = tlm::BEGIN_REQ;
			sc_time delay = sc_core::SC_ZERO_TIME;

			trans_ptr.set_extension(ext_ptr);
			biu_bus_init_socket_tagged[core_id]->nb_transport_fw(trans_ptr, phase, delay);

//			tlm::tlm_generic_payload *trans;
//			wait(biu_bus_ResponsePEQ.get_event());
//			trans = biu_bus_ResponsePEQ.get_next_transaction();
		}

		void dmu_mem_read(tlm::tlm_generic_payload &trans_ptr, unsigned int inst_core)
		{
			trans_extension *ext_ptr;
			unsigned int inst_mode = GET_INST(inst_core);
			unsigned int core_id = GET_CORE(inst_core);
			trans_ptr.get_extension(ext_ptr);

			soc_core_req_bit_mask[core_id] |= 1 << 0;

			switch (inst_mode) {
			case INST_SC:
				ext_ptr->inst_core_range = GEN_INST_CORE_RANGE(INST_DMU_SC, core_id, M1_RANGE);
				break;
			case INST_C1:
				ext_ptr->inst_core_range = GEN_INST_CORE_RANGE(INST_DMU_C1, core_id, M1_RANGE);
				break;
			case INST_C2:
				ext_ptr->inst_core_range = GEN_INST_CORE_RANGE(INST_DMU_C2, core_id, M1_RANGE);
				break;
			default:
				break;
			}

			tlm::tlm_phase phase = tlm::BEGIN_REQ;
			sc_time delay = sc_core::SC_ZERO_TIME;
			trans_ptr.set_extension(ext_ptr);
			dmu_bus_init_socket_tagged[core_id]->nb_transport_fw(trans_ptr, phase, delay);

//			tlm::tlm_generic_payload *trans;
//			wait(dmu_bus_ResponsePEQ.get_event());
//			trans = dmu_bus_ResponsePEQ.get_next_transaction();
		}

		void dmu_mem_write(tlm::tlm_generic_payload &trans_ptr, unsigned int inst_core)
		{
			trans_extension *ext_ptr;
			unsigned int inst_mode = GET_INST(inst_core);
			unsigned int core_id = GET_CORE(inst_core);
			trans_ptr.get_extension(ext_ptr);

			soc_core_req_bit_mask[core_id] |= 1 << 0;
			switch (inst_mode) {
			case INST_SC:
				ext_ptr->inst_core_range = GEN_INST_CORE_RANGE(INST_DMU_SC, core_id, M1_RANGE);
				break;
			case INST_C1:
				ext_ptr->inst_core_range = GEN_INST_CORE_RANGE(INST_DMU_C1, core_id, M1_RANGE);
				break;
			case INST_C2:
				ext_ptr->inst_core_range = GEN_INST_CORE_RANGE(INST_DMU_C2, core_id, M1_RANGE);
				break;
			default:
				break;
			}

			tlm::tlm_phase phase = tlm::BEGIN_REQ;
			sc_time delay = sc_core::SC_ZERO_TIME;

			trans_ptr.set_extension(ext_ptr);
			dmu_bus_init_socket_tagged[core_id]->nb_transport_fw(trans_ptr, phase, delay);

//			tlm::tlm_generic_payload *trans;
//			wait(dmu_bus_ResponsePEQ.get_event());
//			trans = dmu_bus_ResponsePEQ.get_next_transaction();
		}

	private:
		tlm::tlm_sync_enum nb_transport_bw(int portId, tlm::tlm_generic_payload &trans, tlm::tlm_phase &phase, sc_time &delay)
		{
//			sc_dt::uint64 addr;
//			unsigned int len;
//			trans_extension *ext_ptr;
//			trans.get_extension(ext_ptr);
//			int core_id = GET_CORE(ext_ptr->inst_core_range);
//			addr = trans.get_address();
//			len = trans.get_data_length();
//			if (phase == tlm::BEGIN_RESP) {
//				if (ext_ptr->flag == ISS_DATA) {
//					if (((addr >= m1_bus_base_array[core_id])
//							&& ((addr + len) < (m1_bus_base_array[core_id] + m1_bus_size_array[core_id])))
//							|| ((addr >= c2cc_base) && (addr < c2cc_base + c2cc_size))) {
//						m1_bus_ResponsePEQ.notify(trans, delay);	
//					} else if ((addr >= m2_bus_base) && ((addr + len) < (m2_bus_base + m2_bus_size))) {
//						m2_bus_ResponsePEQ.notify(trans, delay);
//					} else if (((addr >= biu_bus_base) && ((addr + len) < (biu_bus_base + biu_bus_size)))
//							|| ((addr >= sysdma_base) && ((addr + len) < (sysdma_base + sysdma_size)))) {
//						biu_bus_ResponsePEQ.notify(trans, delay);
//					} else {
//						for (i = 0; i < DSPNUM; i++) {
//							if ((addr >= m1_bus_base_array[i]) && ((addr + len) < (m1_bus_base_array[i] + m1_bus_size_array[i]))) {
//								dmu_bus_ResponsePEQ.notify(trans, delay);
//								break;
//							}
//						}
//					}
//				}
//			}
			return tlm::TLM_COMPLETED;
		}

		int dbg_addr_valid(int *core_id, int range, unsigned int addr, int len)
		{
			unsigned int i;
			int ret = -1;
			switch (range) {
				case DBG_CORE_M1_MEM:
					for (i = 0; i < DSPNUM; i++) {
						*core_id = i;
						if ((addr >= multi_arg(pacdsp[i], core_base) + multi_arg(pacdsp[i].m1_mem, dmem_m1_offset)) &&
							(addr < multi_arg(pacdsp[i], core_base) + multi_arg(pacdsp[i].m1_mem, dmem_m1_offset) +
				 			multi_arg(pacdsp[i].m1_mem, dmem_m1_size)) && ((addr + len) < multi_arg(pacdsp[i], core_base) +
							multi_arg(pacdsp[i].m1_mem, dmem_m1_offset) + multi_arg(pacdsp[i].m1_mem, dmem_m1_size))) {
							ret = 1;
							break;
						} else if ((addr >= multi_arg(pacdsp[i], core_base) + multi_arg(pacdsp[i].m1_mem, dmem_m1_offset)) &&
					   		(addr < multi_arg(pacdsp[i], core_base) + multi_arg(pacdsp[i].m1_mem, dmem_m1_offset) +
							multi_arg(pacdsp[i].m1_mem, dmem_m1_size)) && ((addr + len) >= multi_arg(pacdsp[i], core_base) +
							multi_arg(pacdsp[i].m1_mem, dmem_m1_offset) + multi_arg(pacdsp[i].m1_mem, dmem_m1_size))) {
							ret = 2;
							break;
						}
					}
				break;
				case DBG_CORE_BIU:
					for (i = 0; i < DSPNUM; i++) {
						*core_id = i;
						if ((addr >= multi_arg(pacdsp[i], core_base) + multi_arg(pacdsp[i].biu, biu_offset)) &&
							(addr < multi_arg(pacdsp[i], core_base) + multi_arg(pacdsp[i].biu, biu_offset) +
				 			multi_arg(pacdsp[i].biu, biu_size)) && ((addr + len) < multi_arg(pacdsp[i], core_base) +
							multi_arg(pacdsp[i].biu, biu_offset) + multi_arg(pacdsp[i].biu, biu_size))) {
							ret = 1;
							break;
						} else if ((addr >= multi_arg(pacdsp[i], core_base) + multi_arg(pacdsp[i].biu, biu_offset)) &&
					   		(addr < multi_arg(pacdsp[i], core_base) + multi_arg(pacdsp[i].biu, biu_offset) +
							multi_arg(pacdsp[i].biu, biu_size)) && ((addr + len) >= multi_arg(pacdsp[i], core_base) +
							multi_arg(pacdsp[i].biu, biu_offset) + multi_arg(pacdsp[i].biu, biu_size))) {
							ret = 2;
							break;
						}
					}
				break;
				case DBG_CORE_ICU:
					for (i = 0; i < DSPNUM; i++) {
						*core_id = i;
						if ((addr >= multi_arg(pacdsp[i], core_base) + multi_arg(pacdsp[i].icu, icu_offset)) &&
							(addr < multi_arg(pacdsp[i], core_base) + multi_arg(pacdsp[i].icu, icu_offset) +
				 			multi_arg(pacdsp[i].icu, icu_size)) && ((addr + len) < multi_arg(pacdsp[i], core_base) +
							multi_arg(pacdsp[i].icu, icu_offset) + multi_arg(pacdsp[i].icu, icu_size))) {
							ret = 1;
							break;
						} else if ((addr >= multi_arg(pacdsp[i], core_base) + multi_arg(pacdsp[i].icu, icu_offset)) &&
					   		(addr < multi_arg(pacdsp[i], core_base) + multi_arg(pacdsp[i].icu, icu_offset) +
							multi_arg(pacdsp[i].icu, icu_size)) && ((addr + len) >= multi_arg(pacdsp[i], core_base) +
							multi_arg(pacdsp[i].icu, icu_offset) + multi_arg(pacdsp[i].icu, icu_size))) {
							ret = 2;
							break;
						}
					}
				break;
				case DBG_CORE_DMU:
					for (i = 0; i < DSPNUM; i++) {
						*core_id = i;
						if ((addr >= multi_arg(pacdsp[i], core_base) + multi_arg(pacdsp[i].dmu, dmu_offset)) &&
							(addr < multi_arg(pacdsp[i], core_base) + multi_arg(pacdsp[i].dmu, dmu_offset) +
				 			multi_arg(pacdsp[i].dmu, dmu_size)) && ((addr + len) < multi_arg(pacdsp[i], core_base) +
							multi_arg(pacdsp[i].dmu, dmu_offset) + multi_arg(pacdsp[i].dmu, dmu_size))) {
							ret = 1;
							break;
						} else if ((addr >= multi_arg(pacdsp[i], core_base) + multi_arg(pacdsp[i].dmu, dmu_offset)) &&
					   		(addr < multi_arg(pacdsp[i], core_base) + multi_arg(pacdsp[i].dmu, dmu_offset) +
							multi_arg(pacdsp[i].dmu, dmu_size)) && ((addr + len) >= multi_arg(pacdsp[i], core_base) +
							multi_arg(pacdsp[i].dmu, dmu_offset) + multi_arg(pacdsp[i].dmu, dmu_size))) {
							ret = 2;
							break;
						}
					}
				break;
				case DBG_CORE_DMA:
					for (i = 0; i < DSPNUM; i++) {
						*core_id = i;
						if ((addr >= multi_arg(pacdsp[i], core_base) + multi_arg(pacdsp[i].dma, dma_offset)) &&
							(addr < multi_arg(pacdsp[i], core_base) + multi_arg(pacdsp[i].dma, dma_offset) +
				 			multi_arg(pacdsp[i].dma, dma_size)) && ((addr + len) < multi_arg(pacdsp[i], core_base) +
				 			multi_arg(pacdsp[i].dma, dma_offset) + multi_arg(pacdsp[i].dma, dma_size))) {
							ret = 1;
							break;
						} else if ((addr >= multi_arg(pacdsp[i], core_base) + multi_arg(pacdsp[i].dma, dma_offset)) &&
					   		(addr < multi_arg(pacdsp[i], core_base) + multi_arg(pacdsp[i].dma, dma_offset) +
							multi_arg(pacdsp[i].dma, dma_size)) && ((addr + len) >= multi_arg(pacdsp[i], core_base) +
							multi_arg(pacdsp[i].dma, dma_offset) + multi_arg(pacdsp[i].dma, dma_size))) {
							ret = 2;
							break;
						}
					}
				break;
				case DBG_M2_MEM:
					if ((addr >= multi_arg(m2_mem, dmem_m2_base)) && (addr < multi_arg(m2_mem, dmem_m2_base) +
						multi_arg(m2_mem, dmem_m2_size)) && ((addr + len) < multi_arg(m2_mem, dmem_m2_base) + 
						multi_arg(m2_mem, dmem_m2_size))) {
						ret = 1;
					} else if ((addr >= multi_arg(m2_mem, dmem_m2_base)) && (addr < multi_arg(m2_mem, dmem_m2_base) +
						multi_arg(m2_mem, dmem_m2_size)) && ((addr + len) >= multi_arg(m2_mem, dmem_m2_base) + 
						multi_arg(m2_mem, dmem_m2_size))) {
						ret = 2;
					}
				break;
				case DBG_M2_ICU:
					if ((addr >= multi_arg(l2_icu, l2_icu_base)) && (addr < multi_arg(l2_icu, l2_icu_base) +
						multi_arg(l2_icu, l2_icu_size)) && ((addr + len) < multi_arg(l2_icu, l2_icu_base) + 
						multi_arg(l2_icu, l2_icu_size))) {
						ret = 1;
					} else if ((addr >= multi_arg(l2_icu, l2_icu_base)) && (addr < multi_arg(l2_icu, l2_icu_base) +
						multi_arg(l2_icu, l2_icu_size)) && ((addr + len) >= multi_arg(l2_icu, l2_icu_base) + 
						multi_arg(l2_icu, l2_icu_size))) {
						ret = 2;
					}
				break;
				case DBG_M2_DMU:
					if ((addr >= multi_arg(m2_dmu, m2_dmu_base)) &&
						(addr < multi_arg(m2_dmu, m2_dmu_base) + multi_arg(m2_dmu, m2_dmu_size)) &&
						((addr + len) < multi_arg(m2_dmu, m2_dmu_base) + multi_arg(m2_dmu, m2_dmu_size))) {
						ret = 1;
					} else if ((addr >= multi_arg(m2_dmu, m2_dmu_base)) &&
				   		(addr < multi_arg(m2_dmu, m2_dmu_base) + multi_arg(m2_dmu, m2_dmu_size)) &&
				   		((addr + len) >= multi_arg(m2_dmu, m2_dmu_base) + multi_arg(m2_dmu, m2_dmu_size))) {
						ret = 2;
					}
				break;
				case DBG_M2_DMA:
					if ((addr >= multi_arg(m2_dma, m2_dma_base)) &&
						(addr < multi_arg(m2_dma, m2_dma_base) + multi_arg(m2_dma, m2_dma_size)) &&
						((addr + len) < multi_arg(m2_dma, m2_dma_base) + multi_arg(m2_dma, m2_dma_size))) {
						ret = 1;
					} else if ((addr >= multi_arg(m2_dma, m2_dma_base)) &&
				   		(addr < multi_arg(m2_dma, m2_dma_base) + multi_arg(m2_dma, m2_dma_size)) &&
				   		((addr + len) >= multi_arg(m2_dma, m2_dma_base) + multi_arg(m2_dma, m2_dma_size))) {
						ret = 2;
					}
				break;
				case DBG_C2CC_INTERFACE:
					if ((addr >= multi_arg(c2cc, c2cc_base)) &&
						(addr < multi_arg(c2cc, c2cc_base) + multi_arg(c2cc, c2cc_size)) &&
						((addr + len) < multi_arg(c2cc, c2cc_base) + multi_arg(c2cc, c2cc_size))) {
						ret = 1;
					} else if ((addr >= multi_arg(c2cc, c2cc_base)) &&
				   		(addr < multi_arg(c2cc, c2cc_base) + multi_arg(c2cc, c2cc_size)) &&
				   		((addr + len) >= multi_arg(c2cc, c2cc_base) + multi_arg(c2cc, c2cc_size))) {
					ret = 2;
					}
				break;
				case DBG_DDR_MEM:
					if ((addr >= multi_arg(ddr_mem, ddr_memory_base)) &&
						(addr < multi_arg(ddr_mem, ddr_memory_base) + multi_arg(ddr_mem, ddr_memory_size)) &&
						((addr + len) < multi_arg(ddr_mem, ddr_memory_base) + multi_arg(ddr_mem, ddr_memory_size))) {
						ret = 1;
					} else if ((addr >= multi_arg(ddr_mem, ddr_memory_base)) &&
				   		(addr < multi_arg(ddr_mem, ddr_memory_base) + multi_arg(ddr_mem, ddr_memory_size)) &&
				   		((addr + len) >= multi_arg(ddr_mem, ddr_memory_base) + multi_arg(ddr_mem, ddr_memory_size))) {
						ret = 2;
					}
				break;
				case DBG_SYS_DMA:
					if ((addr >= multi_arg(sys_dma, sys_dma_base)) &&
						(addr < multi_arg(sys_dma, sys_dma_base) + multi_arg(sys_dma, sys_dma_size)) &&
						((addr + len) < multi_arg(sys_dma, sys_dma_base) + multi_arg(sys_dma, sys_dma_size))) {
						ret = 1;
					} else if ((addr >= multi_arg(sys_dma, sys_dma_base)) &&
				   		(addr < multi_arg(sys_dma, sys_dma_base) + multi_arg(sys_dma, sys_dma_size)) &&
				   		((addr + len) >= multi_arg(sys_dma, sys_dma_base) + multi_arg(sys_dma, sys_dma_size))) {
						ret = 2;
					}
				break;
				default:
					ret = -1;
				break;
			}
			return ret;
		}
		
		tlm::tlm_sync_enum nb_transport_fw(int id, tlm::tlm_generic_payload &trans, tlm::tlm_phase &phase, sc_time & t)
		{
			if(phase == tlm::BEGIN_REQ) {
				addPendingTransaction(trans, 0, id);
				d2_bus_RequestPEQ.notify(trans, t);
			}

			return tlm::TLM_ACCEPTED;
		}

		void b_transport(int id, tlm::tlm_generic_payload & trans, sc_time & t)
		{
			trans_extension *ext_ptr;
			trans.get_extension(ext_ptr);
			tlm::tlm_command cmd = trans.get_command();
			sc_dt::uint64 addr = trans.get_address();
			unsigned int len = trans.get_data_length();
			sc_time delay = sc_core::SC_ZERO_TIME;

			unsigned int range;
			int ret;
			int core_id = 0, miss = 0;
			int length = len;
			int coreid = GET_CORE(ext_ptr->inst_core_range);

			if (cmd == tlm::TLM_READ_COMMAND) {
				for (range = DBG_CORE_M1_MEM; range <= DBG_SYS_DMA; range++) {
					ret = dbg_addr_valid(&core_id, range, addr, len);
					if (ret == 1) {
						break;
					} else if (ret == 2) {
						printf("addr(0x%llx) + len(0x%08x) is out of memory range(%d)\r\n", addr, len, range);
						switch (range) {
						case DBG_CORE_M1_MEM:
							length -= addr + length - multi_arg(pacdsp[core_id], core_base) -
								multi_arg(pacdsp[core_id].m1_mem, dmem_m1_offset) - multi_arg(pacdsp[core_id].m1_mem, dmem_m1_size) + 1;
						break;
						case DBG_CORE_BIU:
							length -= addr + length - multi_arg(pacdsp[core_id], core_base) -
								multi_arg(pacdsp[core_id].biu, biu_offset) - multi_arg(pacdsp[core_id].biu, biu_size) + 1;
						break;
						case DBG_CORE_ICU:
							length -= addr + length - multi_arg(pacdsp[core_id], core_base) -
								multi_arg(pacdsp[core_id].icu, icu_offset) - multi_arg(pacdsp[core_id].icu, icu_size) + 1;
						break;
						case DBG_CORE_DMU:
							length -= addr + length - multi_arg(pacdsp[core_id], core_base) -
								multi_arg(pacdsp[core_id].dmu, dmu_offset) - multi_arg(pacdsp[core_id].dmu, dmu_size) + 1;
						break;
						case DBG_CORE_DMA:
							length -= addr + length - multi_arg(pacdsp[core_id], core_base) -
								multi_arg(pacdsp[core_id].dma, dma_offset) - multi_arg(pacdsp[core_id].dma, dma_size) + 1;
						break;
						case DBG_M2_MEM:
							length -= addr + length - multi_arg(m2_mem, dmem_m2_base) - multi_arg(m2_mem, dmem_m2_size) + 1;
						break;
						case DBG_M2_ICU:
							length -= addr + length - multi_arg(l2_icu, l2_icu_base) - multi_arg(l2_icu, l2_icu_size) + 1;
						break;
						case DBG_M2_DMU:
							length -= addr + length - multi_arg(m2_dmu, m2_dmu_base) - multi_arg(m2_dmu, m2_dmu_size) + 1;
						break;
						case DBG_M2_DMA:
							length -= addr + length - multi_arg(m2_dma, m2_dma_base) - multi_arg(m2_dma, m2_dma_size) + 1;
						break;
						case DBG_C2CC_INTERFACE:
							length -= addr + length - multi_arg(c2cc, c2cc_base) - multi_arg(c2cc, c2cc_size) + 1;
						break;
						case DBG_DDR_MEM:
							length -= addr + length - multi_arg(ddr_mem, ddr_memory_base) - multi_arg(ddr_mem, ddr_memory_size) + 1;
						break;
						case DBG_SYS_DMA:
							length -= addr + length - multi_arg(sys_dma, sys_dma_base) - multi_arg(sys_dma, sys_dma_size) + 1;
						break;
						}
						printf("\nNow that read mem addr(0x%llx) len(0x%08x)\r\n", addr, length);
						break;
					}
				}
				if (ret == -1) {
					printf("Not that memory in simulator addr(0x%llx) len(0x%08x)\r\n", addr, length);
				}
	
				trans.set_data_length(length);
				miss = dbg_d2cache_read(trans);

				if (miss == CACHE_MISS) {
					if (((addr >= m1_bus_base_array[coreid]) && ((addr + len) < (m1_bus_base_array[coreid] + m1_bus_size_array[coreid])))
							|| ((addr >= c2cc_base) && (addr < c2cc_base + c2cc_size))) {

						m1_bus_init_socket_tagged[coreid]->b_transport(trans, delay);
					} else if ((addr >= m2_bus_base) && ((addr + len) < (m2_bus_base + m2_bus_size))){

						m2_bus_init_socket_tagged[coreid]->b_transport(trans, delay);
					} else if (((addr >= biu_bus_base) && ((addr + len) < (biu_bus_base + biu_bus_size)))
							|| ((addr >= sysdma_base) && ((addr + len) < (sysdma_base + sysdma_size)))){

						biu_bus_init_socket_tagged[coreid]->b_transport(trans, delay);
					} else {
						for (i = 0; i < DSPNUM; i++) {
							if ((addr >= m1_bus_base_array[i]) && ((addr + len) < (m1_bus_base_array[i] + m1_bus_size_array[i]))) {
								dmu_bus_init_socket_tagged[coreid]->b_transport(trans, delay);
								break;
							}
						}

						if (i == DSPNUM) {
							printf("No read mem address(0x%llx) in simualtor\r\n",addr);
						}
					}
				}
			} else if (cmd == tlm::TLM_WRITE_COMMAND) {
				for (range = DBG_CORE_M1_MEM; range <= DBG_SYS_DMA; range++) {
					ret = dbg_addr_valid(&core_id, range, addr, len);
					if (ret == 1) {
						break;
					} else if (ret == 2) {
						printf("addr(0x%llx) + len(0x%08x) is out of memory range(%d)\r\n", addr, len, range);
						switch (range) {
						case DBG_CORE_M1_MEM:
							length -= addr + length - multi_arg(pacdsp[core_id], core_base) -
								multi_arg(pacdsp[core_id].m1_mem, dmem_m1_offset) - multi_arg(pacdsp[core_id].m1_mem, dmem_m1_size) + 1;
						break;
						case DBG_CORE_BIU:
							length -= addr + length - multi_arg(pacdsp[core_id], core_base) -
								multi_arg(pacdsp[core_id].biu, biu_offset) - multi_arg(pacdsp[core_id].biu, biu_size) + 1;
						break;
						case DBG_CORE_ICU:
							length -= addr + length - multi_arg(pacdsp[core_id], core_base) -
								multi_arg(pacdsp[core_id].icu, icu_offset) - multi_arg(pacdsp[core_id].icu, icu_size) + 1;
						break;
						case DBG_CORE_DMU:
							length -= addr + length - multi_arg(pacdsp[core_id], core_base) -
								multi_arg(pacdsp[core_id].dmu, dmu_offset) - multi_arg(pacdsp[core_id].dmu, dmu_size) + 1;
						break;
						case DBG_CORE_DMA:
							length -= addr + length - multi_arg(pacdsp[core_id], core_base) -
								multi_arg(pacdsp[core_id].dma, dma_offset) - multi_arg(pacdsp[core_id].dma, dma_size) + 1;
						break;
						case DBG_M2_MEM:
							length -= addr + length - multi_arg(m2_mem, dmem_m2_base) - multi_arg(m2_mem, dmem_m2_size) + 1;
						break;
						case DBG_M2_ICU:
							length -= addr + length - multi_arg(l2_icu, l2_icu_base) - multi_arg(l2_icu, l2_icu_size) + 1;
						break;
						case DBG_M2_DMU:
							length -= addr + length - multi_arg(m2_dmu, m2_dmu_base) - multi_arg(m2_dmu, m2_dmu_size) + 1;
						break;
						case DBG_M2_DMA:
							length -= addr + length - multi_arg(m2_dma, m2_dma_base) - multi_arg(m2_dma, m2_dma_size) + 1;
						break;
						case DBG_C2CC_INTERFACE:
							length -= addr + length - multi_arg(c2cc, c2cc_base) - multi_arg(c2cc, c2cc_size) + 1;
						break;
						case DBG_DDR_MEM:
							length -= addr + length - multi_arg(ddr_mem, ddr_memory_base) - multi_arg(ddr_mem, ddr_memory_size) + 1;
						break;
						case DBG_SYS_DMA:
							length -= addr + length - multi_arg(sys_dma, sys_dma_base) - multi_arg(sys_dma, sys_dma_size) + 1;
						break;
						}
						printf("\nNow that write mem addr(0x%llx) len(0x%08x)\r\n", addr, length);
						break;
					}
				}
				if (ret == -1) {
					printf("Not that memory in simulator addr(0x%llx) len(0x%08x)\r\n", addr, length);
				}
	
				trans.set_data_length(length);
				miss = dbg_d2cache_write(trans);

				if (miss == CACHE_MISS) {
					if (((addr >= m1_bus_base_array[coreid]) && ((addr + len) < (m1_bus_base_array[coreid] + m1_bus_size_array[coreid])))
							|| ((addr >= c2cc_base) && (addr < c2cc_base + c2cc_size))) {
						m1_bus_init_socket_tagged[coreid]->b_transport(trans, delay);
					} else if ((addr >= m2_bus_base) && ((addr + len) < (m2_bus_base + m2_bus_size))){
						m2_bus_init_socket_tagged[coreid]->b_transport(trans, delay);
					} else if (((addr >= biu_bus_base) && ((addr + len) < (biu_bus_base + biu_bus_size)))
							|| ((addr >= sysdma_base) && ((addr + len) < (sysdma_base + sysdma_size)))){
						biu_bus_init_socket_tagged[coreid]->b_transport(trans, delay);
					} else {
						for (i = 0; i < DSPNUM; i++) {
							if ((addr >= m1_bus_base_array[i]) && ((addr + len) < (m1_bus_base_array[i] + m1_bus_size_array[i]))) {
								dmu_bus_init_socket_tagged[coreid]->b_transport(trans, delay);
								break;
							}
						}

						if (i == DSPNUM) {
							printf("No write mem address(0x%llx) in simualtor\r\n",addr);
						}
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

	private:
		PendingTransactions mPendingTransactions;
};

#endif
#endif
