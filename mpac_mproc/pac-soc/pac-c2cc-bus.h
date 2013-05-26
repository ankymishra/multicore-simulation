#ifndef C2CC_BUS_H_INCLUDED
#define C2CC_BUS_H_INCLUDED

#include <systemc.h>
using namespace sc_core;
using namespace sc_dt;
using namespace std;

#include "tlm.h"
#include "tlm_utils/simple_target_socket.h"
#include "tlm_utils/simple_initiator_socket.h"
#include "tlm_utils/peq_with_get.h"
#include "fcntl.h"

#define TX_REGS_NUM 	16
#define RX_REGS_NUM 	16

#define TX_SEND_TRIG 	0
#define TX_STATUS 	1
#define TX_CTRL 	2
#define TX_TIMEOUT 	3
#define TX_MESSAGE_0 	4
#define TX_MESSAGE_1 	5
#define TX_MESSAGE_2 	6
#define TX_MESSAGE_3 	7
#define TX_CANCEL 	8
#define MONITOR_DEST_ID 	9
#define MONITOR_DEST_STATUS 	10
#define TX_RESERVE 	11

#define RX_STATUS 	16
#define SOURCE_ID 	17
#define RX_MESSAGE_0 	18
#define RX_MESSAGE_1 	19
#define RX_MESSAGE_2 	20
#define RX_MESSAGE_3 	21
#define RX_ACCEPT 	22
#define RX_INT_CLEAR 	23
#define RX_INT_EN 	24
#define RX_RESERVE 	25

struct C2CC_Bus: public sc_core::sc_module
{
  private:
	struct sim_arg *multi_sim_arg;
	typedef tlm::tlm_generic_payload transaction_type;
	typedef tlm::tlm_phase phase_type;
	typedef tlm::tlm_sync_enum sync_enum_type;

  public:
	tlm_utils::simple_target_socket_tagged < C2CC_Bus > targ_socket[DSPNUM];	// c2cc_wrap -> c2cc_bus
	tlm_utils::simple_initiator_socket_tagged < C2CC_Bus > init_socket[DSPNUM];	// c2cc_bus -> c2cc_wrap

  public:
	C2CC_Bus(sc_module_name _name, struct sim_arg *arg)
	:sc_core::sc_module(_name)
	, multi_sim_arg(arg)
	{
		for (unsigned int i = 0; i < DSPNUM; ++i)
			targ_socket[i].register_nb_transport_fw(this, &C2CC_Bus::nb_transport_fw, i);
	}

	~C2CC_Bus() {
	}

	tlm::tlm_sync_enum nb_transport_fw(int id, transaction_type &trans, 
					tlm::tlm_phase & phase, sc_core::sc_time & t)
	{
		tlm::tlm_command cmd;
		struct C2CC_Bus_Trans *ptr;

		cmd = trans.get_command();
		ptr = (struct C2CC_Bus_Trans *)trans.get_data_ptr();

		if (cmd == tlm::TLM_WRITE_COMMAND) {
			return init_socket[ptr->to]->nb_transport_fw(trans, phase, t);
		}

		return tlm::TLM_COMPLETED;
	}

};

#endif
