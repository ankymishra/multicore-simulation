#ifndef PAC_DMU_BUS_H_INCLUDED
#define PAC_DMU_BUS_H_INCLUDED

#include <systemc.h>
using namespace sc_core;
using namespace sc_dt;
using namespace std;

#include "tlm.h"
#include "tlm_utils/simple_target_socket.h"
#include "tlm_utils/simple_initiator_socket.h"
#include "tlm_utils/peq_with_get.h"

struct Dmu_Bus:public sc_core::sc_module, public pac_bus
{
	private:
		struct sim_arg *multi_sim_arg;
		unsigned int m1_bus_base[DSPNUM], m1_bus_size[DSPNUM];
		unsigned int i;

	public:
		tlm_utils::simple_target_socket_tagged < Dmu_Bus > dmu_bus_targ_socket_tagged[DSPNUM];
		tlm_utils::simple_initiator_socket_tagged < Dmu_Bus > m1_dmu_init_socket_tagged[DSPNUM];

	public:
		Dmu_Bus(sc_module_name _name, struct sim_arg *arg)
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

			for (i = 0; i < (DSPNUM); i++) {
				dmu_bus_targ_socket_tagged[i].register_nb_transport_fw(this, &Dmu_Bus::nb_transport_fw, i);
				dmu_bus_targ_socket_tagged[i].register_b_transport(this, &Dmu_Bus::b_transport, i);
				m1_dmu_init_socket_tagged[i].register_nb_transport_bw(this, &Dmu_Bus::nb_transport_bw, i);
			}


		}

		~Dmu_Bus()
		{
		}

	private:
		tlm::tlm_sync_enum nb_transport_fw(int id, tlm::tlm_generic_payload &trans,
						tlm::tlm_phase &phase, sc_core::sc_time &t)
		{
			int len;
			sc_dt::uint64 addr;

			len = trans.get_data_length();
			addr = trans.get_address();

			addPendingTransaction(trans, 0, id);

			for (i = 0; i < DSPNUM; i++) {
				if (m1_addr_valid(addr, len, i)) {
					m1_dmu_init_socket_tagged[i]->nb_transport_fw(trans, phase, t);
					break;
				}
			}
#ifndef PAC_SOC_PROFILE
#ifdef PAC_SOC_PROFILE
			PendingTransactionsIterator it = mPendingTransactions.find(&trans);
			//dmu_bus_targ_socket_tagged[it->second.from]->nb_transport_bw(trans, phase, t);
			mPendingTransactions.erase(it);
#endif
#else
			PendingTransactionsIterator it = mPendingTransactions.find(&trans);
			//dmu_bus_targ_socket_tagged[it->second.from]->nb_transport_bw(trans, phase, t);
			mPendingTransactions.erase(it);
#endif

			return tlm::TLM_ACCEPTED;
		}

		tlm::tlm_sync_enum nb_transport_bw(int id, tlm::tlm_generic_payload &trans,
						tlm::tlm_phase &phase, sc_core::sc_time &t)
		{
			int len;
			sc_dt::uint64 addr;

			len = trans.get_data_length();
			addr = trans.get_address();

			PendingTransactionsIterator it = mPendingTransactions.find(&trans);
			dmu_bus_targ_socket_tagged[it->second.from]->nb_transport_bw(trans, phase, t);
			mPendingTransactions.erase(it);

			return tlm::TLM_COMPLETED;
		}

		void b_transport(int id, tlm::tlm_generic_payload &trans,
						sc_core::sc_time &t)
		{
			int len;
			sc_dt::uint64 addr;

			len = trans.get_data_length();
			addr = trans.get_address();

			for (i = 0; i < DSPNUM; i++) {
				if (m1_addr_valid(addr, len, i))
						m1_dmu_init_socket_tagged[i]->b_transport(trans, t);
			}
		}
		
		//1 = valid, 0 = invalid
		int m1_addr_valid(unsigned int start, int len, int core_id)
		{
			if ((start >= m1_bus_base[core_id]) && ((start + len) < (m1_bus_base[core_id] + m1_bus_size[core_id])))	
					if ((start + len) > m1_bus_base[core_id])
							return true;

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
};

#endif
