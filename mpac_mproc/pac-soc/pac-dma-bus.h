#ifndef PAC_DMA_BUS_H_INCLUDED
#define PAC_DMA_BUS_H_INCLUDED

#include <systemc.h>
using namespace sc_core;
using namespace sc_dt;
using namespace std;

#include "tlm.h"
#include "tlm_utils/simple_target_socket.h"
#include "tlm_utils/simple_initiator_socket.h"
#include "tlm_utils/peq_with_get.h"

struct Dma_Bus:public sc_core::sc_module, public pac_bus
{
	private:
		struct sim_arg *multi_sim_arg;
		unsigned int m1_bus_base[DSPNUM], m1_bus_size[DSPNUM];
		unsigned int m2_bus_base, m2_bus_size;
		unsigned int biu_bus_base, biu_bus_size;
		unsigned int i;

	public:
		tlm_utils::simple_target_socket_tagged < Dma_Bus > dma_targ_socket_tagged[DSPNUM + 2];
		tlm_utils::simple_initiator_socket_tagged < Dma_Bus > dma_init_socket_tagged[DSPNUM + 2];

		tlm_utils::simple_initiator_socket_tagged < Dma_Bus > dma_d1_dcache_init_socket_tagged[DSPNUM];
		tlm_utils::simple_initiator_socket_tagged < Dma_Bus > dma_d2_dcache_init_socket;
	public:
		Dma_Bus(sc_module_name _name, struct sim_arg *arg)
		:sc_core::sc_module(_name)
		, multi_sim_arg(arg)
		{

			for (i = 0; i < DSPNUM; i++) {
				m1_bus_size[i] = 0;
				m1_bus_base[i] = multi_arg(pacdsp[i], core_base);
				m1_bus_size[i] += multi_arg(pacdsp[i].m1_mem, dmem_m1_size) + 
						multi_arg(pacdsp[i].res1, res1_size) + multi_arg(pacdsp[i].biu, biu_size) + 
						multi_arg(pacdsp[i].icu, icu_size) + multi_arg(pacdsp[i].dmu, dmu_size) +
						multi_arg(pacdsp[i].dma, dma_size) + multi_arg(pacdsp[i].res2, res2_size);
			}

			m2_bus_base = multi_arg(m2_mem, dmem_m2_base);
			m2_bus_size = multi_arg(m2_mem, dmem_m2_size) + multi_arg(l2_icu, l2_icu_size) +
					multi_arg(m2_dmu, m2_dmu_size) + multi_arg(m2_dma, m2_dma_size) + 
					multi_arg(sem, sem_size) + multi_arg(c2cc, c2cc_size);

			biu_bus_base = multi_arg(ddr_mem, ddr_memory_base);
			biu_bus_size = multi_arg(ddr_mem, ddr_memory_size);
			
			for (i = 0; i < (DSPNUM + 2); i++) {
				dma_targ_socket_tagged[i].register_nb_transport_fw(this, &Dma_Bus::nb_transport_fw, i);
				dma_init_socket_tagged[i].register_nb_transport_bw(this, &Dma_Bus::nb_transport_bw, i);
			}
		}

		~Dma_Bus()
		{
		}

	private:
		void d1_dcache_flush(void)
		{
#if 0
			tlm::tlm_generic_payload trans;
			sc_time delay = sc_core::SC_ZERO_TIME;
			trans_extension *trans_ext = new trans_extension;

			trans_ext->flag = ISS_DATA;
			trans.set_command(tlm::TLM_IGNORE_COMMAND);
			trans.set_extension(trans_ext);
			trans.set_response_status(tlm::TLM_INCOMPLETE_RESPONSE);

			dma_d1_dcache_init_socket->b_transport(trans, delay);
#endif
		}

		void d2_dcache_flush(void)
		{
#ifndef PAC_SOC_PROFILE
			tlm::tlm_generic_payload trans;
			sc_time delay = sc_core::SC_ZERO_TIME;
			trans_extension *trans_ext = new trans_extension;

			trans_ext->flag = ISS_DATA;
			trans_ext->inst_core_range = GEN_INST_CORE_RANGE(0, 0, 0);
			trans.set_command(tlm::TLM_IGNORE_COMMAND);
			trans.set_extension(trans_ext);
			trans.set_response_status(tlm::TLM_INCOMPLETE_RESPONSE);

			dma_d2_dcache_init_socket->b_transport(trans, delay);
#endif
		}

		tlm::tlm_sync_enum nb_transport_fw(int id, tlm::tlm_generic_payload &trans,
						tlm::tlm_phase &phase, sc_core::sc_time &t)
		{
			int len;
			tlm::tlm_command cmd;

			cmd = trans.get_command();
			dma_extension *dma_ext;
			trans.get_extension(dma_ext);
			len = trans.get_data_length();
//D1 Dcache flush
			d1_dcache_flush();
//D2 Dcache flush			
			d2_dcache_flush();

			if (cmd == tlm::TLM_WRITE_COMMAND) {
				for (i = 0; i < DSPNUM; i++) {
					if (m1_addr_valid(dma_ext->dar, len, i)) {
						dma_init_socket_tagged[i]->nb_transport_fw(trans, phase, t);
					}
				}

				if (m2_addr_valid(dma_ext->dar, len)) {
					dma_init_socket_tagged[DSPNUM]->nb_transport_fw(trans, phase, t);
				}

				if (biu_addr_valid(dma_ext->dar, len)) {
					dma_init_socket_tagged[DSPNUM + 1]->nb_transport_fw(trans, phase, t);
				}
			} else {
				for (i = 0; i < DSPNUM; i++) {
					if (m1_addr_valid(dma_ext->sar, len, i)) {
						dma_init_socket_tagged[i]->nb_transport_fw(trans, phase, t);
					}
				}

				if (m2_addr_valid(dma_ext->sar, len)) {
					dma_init_socket_tagged[DSPNUM]->nb_transport_fw(trans, phase, t);
				}

				if (biu_addr_valid(dma_ext->sar, len)) {
					dma_init_socket_tagged[DSPNUM + 1]->nb_transport_fw(trans, phase, t);
				}
			}

			return tlm::TLM_ACCEPTED;
		}

		tlm::tlm_sync_enum nb_transport_bw(int id, tlm::tlm_generic_payload &trans,
						tlm::tlm_phase &phase, sc_core::sc_time &t)
		{
			int len;
			tlm::tlm_command cmd;

			cmd = trans.get_command();
			dma_extension *dma_ext;
			trans.get_extension(dma_ext);
			len = trans.get_data_length();


			if (cmd == tlm::TLM_WRITE_COMMAND) {
				for (i = 0; i < DSPNUM; i++) {
					if (m1_addr_valid(dma_ext->sar, len, i)) {
							dma_targ_socket_tagged[i]->nb_transport_bw(trans, phase, t);
					}
				}

				if (m2_addr_valid(dma_ext->sar, len)) {
					dma_targ_socket_tagged[DSPNUM]->nb_transport_bw(trans, phase, t);
				}

				if (biu_addr_valid(dma_ext->sar, len)) {
					dma_targ_socket_tagged[DSPNUM + 1]->nb_transport_bw(trans, phase, t);
				}
			} else {
				for (i = 0; i < DSPNUM; i++) {
					if (m1_addr_valid(dma_ext->dar, len, i)) {
							dma_targ_socket_tagged[i]->nb_transport_bw(trans, phase, t);
					}
				}

				if (m2_addr_valid(dma_ext->dar, len)) {
					dma_targ_socket_tagged[DSPNUM]->nb_transport_bw(trans, phase, t);
				}

				if (biu_addr_valid(dma_ext->dar, len)) {
					dma_targ_socket_tagged[DSPNUM + 1]->nb_transport_bw(trans, phase, t);
				}

			}

			return tlm::TLM_COMPLETED;
		}
		
		//1 = valid, 0 = invalid
		int m1_addr_valid(unsigned int start, int len, int core_id)
		{
			if ((start >= m1_bus_base[core_id]) && ((start + len) < (m1_bus_base[core_id] + m1_bus_size[core_id])))	
					if ((start + len) > m1_bus_base[core_id])
							return true;

			return false;
		}

		int m2_addr_valid(unsigned int start, int len)
		{
			if ((start >= m2_bus_base) && ((start + len) < (m2_bus_base + m2_bus_size)))
					if ((start + len) > m2_bus_base)
							return true;

			return false;
		}

		int biu_addr_valid(unsigned int start, int len)
		{
			if ((start >= biu_bus_base) && ((start + len) < (biu_bus_base + biu_bus_size)))
					if ((start + len) > biu_bus_base)
							return true;

			return false;
		}
};

#endif
