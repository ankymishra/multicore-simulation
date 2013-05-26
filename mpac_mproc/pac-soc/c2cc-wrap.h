#ifndef C2CC_WRAP_H_INCLUDED
#define C2CC_WRAP_H_INCLUDED

#include <systemc.h>
using namespace sc_core;
using namespace sc_dt;
using namespace std;

#include "tlm.h"
#include "tlm_utils/simple_target_socket.h"
#include "tlm_utils/simple_initiator_socket.h"
#include "tlm_utils/peq_with_get.h"

#include "fcntl.h"

#define NUM_OF_C2CC_REGS 	32

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

// c2cc_write
// host -> c2cc_wrap ----------> c2cc_bus ------> c2cc_wrap
//      W            -->Write
//                   <--COMPLETED
//                   <--TARG_BUSY

// c2cc_read
// host -> c2cc_wrap ----------> c2cc_bus ------> c2cc_wrap
//      R            -->READ              -->FLAG_CLEAR

struct C2CC_Bus_Trans {
	unsigned int from;
	unsigned int to;
	unsigned int message_0;
	unsigned int message_1;
	unsigned int message_2;
	unsigned int message_3;
};

struct C2CC_Arbit {
	unsigned int c2cc_tx_count;
	unsigned int c2cc_tx_from;
	unsigned int c2cc_tx_to;
};

static struct C2CC_Arbit c2cc_arbit[DSPNUM];

struct C2CC_Wrap: public sc_core::sc_module
{
  public:
	sc_in < bool > clk;

  private:
	unsigned int c2cc_wrap_id;
	unsigned int c2cc_regs[NUM_OF_C2CC_REGS];
	struct sim_arg *multi_sim_arg;
	unsigned int timeout;

  private:
	typedef tlm::tlm_generic_payload transaction_type;
	typedef tlm::tlm_phase phase_type;
	typedef tlm::tlm_sync_enum sync_enum_type;

  public:
	tlm_utils::simple_target_socket < C2CC_Wrap > tx_targ_socket;		// connect to m1
	tlm_utils::simple_initiator_socket < C2CC_Wrap > tx_init_socket;	// connect to c2cc_bus
	tlm_utils::simple_target_socket < C2CC_Wrap > rx_targ_socket;		// connect to c2cc_bus

	SC_HAS_PROCESS(C2CC_Wrap);

  public:
	C2CC_Wrap(sc_module_name _name, unsigned int cpu_id, struct sim_arg *arg)
	:sc_core::sc_module(_name)
	, c2cc_wrap_id(cpu_id)
	, multi_sim_arg(arg)
	, timeout(0)
	, tx_targ_socket("c2cc_tx_targ_socket")
	, tx_init_socket("c2cc_tx_init_socket")
	, rx_targ_socket("c2cc_rx_targ_socket")
	{
		memset(c2cc_regs, 0, sizeof(c2cc_regs));
		tx_targ_socket.register_nb_transport_fw(this, &C2CC_Wrap::tx_nb_transport_fw);
		tx_targ_socket.register_b_transport(this, &C2CC_Wrap::b_transport);
		rx_targ_socket.register_nb_transport_fw(this, &C2CC_Wrap::rx_nb_transport_fw);

		SC_METHOD(c2cc_wrap_tx_thread);
		sensitive << clk.pos();
	}

	// use for c2cc communication
	void c2cc_wrap_tx_thread()
	{
		tlm::tlm_sync_enum ret;
		struct C2CC_Bus_Trans c2cc_bus_trans;
		tlm::tlm_generic_payload trans;
		tlm::tlm_phase phase = tlm::BEGIN_RESP;
		sc_core::sc_time t = sc_core::SC_ZERO_TIME;

		// not set send flag
		if ((c2cc_regs[TX_SEND_TRIG] & 1) == 0)
			return;

		if (timeout != 0) {
			timeout--;
			if (timeout == 0) {
				c2cc_regs[TX_STATUS] |= 0x1;
				c2cc_regs[TX_SEND_TRIG] &= 0xfffffffe;
				c2cc_regs[TX_CANCEL] |= 0x1;
				return;
			}
			return;
		}

		if (c2cc_arbit[c2cc_wrap_id].c2cc_tx_count == 0) {
			c2cc_bus_trans.from = c2cc_wrap_id;;
			c2cc_bus_trans.to = (c2cc_regs[TX_CTRL] >> 16) & 0xf;
			c2cc_bus_trans.message_0 = c2cc_regs[TX_MESSAGE_0];
			c2cc_bus_trans.message_1 = c2cc_regs[TX_MESSAGE_1];
			c2cc_bus_trans.message_2 = c2cc_regs[TX_MESSAGE_2]; c2cc_bus_trans.message_3 = c2cc_regs[TX_MESSAGE_3]; trans.set_command(tlm::TLM_WRITE_COMMAND);
			trans.set_data_ptr(reinterpret_cast < unsigned char *>(&c2cc_bus_trans));

			c2cc_regs[TX_STATUS] |= 0x3;
			ret = tx_init_socket->nb_transport_fw(trans, phase, t);

			if (ret == tlm::TLM_COMPLETED) {	// targ free
				c2cc_regs[TX_SEND_TRIG] &= 0xfffffffe;
				c2cc_regs[TX_STATUS] &= 0xfffffffc;
			}
		} else {
			c2cc_arbit[c2cc_wrap_id].c2cc_tx_count--;
			//printf("\t\t\t\t\t\t\t\tSEND data delay from %d to %d tx_count %d\r\n",c2cc_wrap_id, 
			//			(c2cc_regs[TX_CTRL] >> 16) & 0xf, 
			//			c2cc_arbit[c2cc_wrap_id].c2cc_tx_count);
		}
		return;
	}

	// should be 4 Bytes aligned, size should be 4 Bytes
	tlm::tlm_sync_enum tx_nb_transport_fw(transaction_type & trans,
					tlm::tlm_phase & phase, sc_core::sc_time & t)
	{
		tlm::tlm_command cmd;
		sc_dt::uint64 addr;
		unsigned char *ptr;
		unsigned int len;
		unsigned int reg_no;

		cmd = trans.get_command();
		addr = (trans.get_address() & 0x00000fff) + multi_arg(c2cc, c2cc_base) + 0x1000 * c2cc_wrap_id;
		ptr = trans.get_data_ptr();
		len = trans.get_data_length();

		if ((addr < (multi_arg(c2cc, c2cc_base) + 0x1000 * c2cc_wrap_id)) ||
			(addr > (multi_arg(c2cc, c2cc_base) + 0x1000 * (c2cc_wrap_id + 1)))
			|| (len != 4)) {

			trans.set_response_status(tlm::TLM_ADDRESS_ERROR_RESPONSE);
			return tlm::TLM_COMPLETED;
		}

		reg_no = (addr - (multi_arg(c2cc, c2cc_base) + 0x1000 * c2cc_wrap_id)) >> 2;

		if (cmd == tlm::TLM_READ_COMMAND) {
			*(unsigned int*)ptr = c2cc_regs[reg_no];
			return tlm::TLM_COMPLETED;
		}

		if (cmd == tlm::TLM_WRITE_COMMAND) {	//tlm::TLM_WRITE_COMMAND
			c2cc_regs[reg_no] = *(unsigned int*)ptr;

			if (reg_no == TX_TIMEOUT)
				timeout = 10 * ((c2cc_regs[TX_TIMEOUT] & 0xff00) >> 8) * 2 * (c2cc_regs[TX_TIMEOUT] & 0xf);
			// found cancel flag
			if ((c2cc_regs[TX_CANCEL] & 1) == 1) {
				c2cc_regs[TX_SEND_TRIG] &= 0xfffffffe;
				c2cc_regs[TX_CANCEL] &= 0xfffffffe;
				c2cc_regs[TX_STATUS] &= 0xfffffffc;
			}

			if (reg_no == RX_ACCEPT) {	// clear dsp busy flag in c2cc_bus
				c2cc_regs[RX_STATUS] &= 0xfffffffc;
				c2cc_arbit[c2cc_arbit[c2cc_wrap_id].c2cc_tx_from].c2cc_tx_count = DSPNUM;
				//printf("\t\t\t\tCORE%d ACCEPT data from %d tx_count %d\r\n",c2cc_wrap_id, 
				//		c2cc_arbit[c2cc_wrap_id].c2cc_tx_from, 
				//		c2cc_arbit[c2cc_arbit[c2cc_wrap_id].c2cc_tx_from].c2cc_tx_count);
			}
		}

		return tlm::TLM_COMPLETED;
	}

	tlm::tlm_sync_enum rx_nb_transport_fw(transaction_type &trans, 
					tlm::tlm_phase & phase, sc_core::sc_time & t)
	{
		tlm::tlm_command cmd;
		struct C2CC_Bus_Trans *ptr;

		if ((c2cc_regs[RX_STATUS] & 3) && (c2cc_regs[RX_STATUS] & 2)) {
			trans.set_response_status(tlm::TLM_INCOMPLETE_RESPONSE);
			return tlm::TLM_ACCEPTED;
		}

		cmd = trans.get_command();
		ptr = (struct C2CC_Bus_Trans *)trans.get_data_ptr();

		if (ptr->to != c2cc_wrap_id) {
			trans.set_response_status(tlm::TLM_ADDRESS_ERROR_RESPONSE);
			return tlm::TLM_COMPLETED;
		}

		if ((c2cc_regs[TX_CTRL] & 0x100) == 1)
			c2cc_regs[RX_STATUS] |= 3;
		else
			c2cc_regs[RX_STATUS] |= 2;

		c2cc_regs[SOURCE_ID] = ptr->from;
		c2cc_regs[RX_MESSAGE_0] = ptr->message_0;
		c2cc_regs[RX_MESSAGE_1] = ptr->message_1;
		c2cc_regs[RX_MESSAGE_2] = ptr->message_2;
		c2cc_regs[RX_MESSAGE_3] = ptr->message_3;

		//printf("SEND data COMPLETE from %d to %d \r\n",ptr->from, ptr->to);
		c2cc_arbit[c2cc_wrap_id].c2cc_tx_from = ptr->from;
		c2cc_arbit[c2cc_wrap_id].c2cc_tx_to = ptr->to;
		return tlm::TLM_COMPLETED;
	}

	void b_transport(tlm::tlm_generic_payload & trans, sc_time & t)
	{
		tlm::tlm_command cmd;
		sc_dt::uint64 addr;
		unsigned char *ptr;
		unsigned int len;
		unsigned int reg_no;

		cmd = trans.get_command();
		addr = (trans.get_address() & 0x00000fff) + multi_arg(c2cc, c2cc_base) + 0x1000 * c2cc_wrap_id;
		ptr = trans.get_data_ptr();
		len = trans.get_data_length();

		//printf("C2CC_Wrap %s \n",__func__);       

		reg_no = (addr - (multi_arg(c2cc, c2cc_base) + 0x1000 * c2cc_wrap_id)) >> 2;
		if ((addr < (multi_arg(c2cc, c2cc_base) + 0x1000 * c2cc_wrap_id)) ||
			(addr > (multi_arg(c2cc, c2cc_base) + (1 + c2cc_wrap_id) * 0x1000)) || (len != 4)) {

			if (cmd == tlm::TLM_READ_COMMAND) {
				*(unsigned int*)ptr = c2cc_regs[reg_no];
			} else if (cmd == tlm::TLM_WRITE_COMMAND) {
				c2cc_regs[reg_no] = *(unsigned int*)ptr;
			}
			trans.set_response_status(tlm::TLM_OK_RESPONSE);
		}
	}
};

#endif
