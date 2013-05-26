#ifndef SC_PAC_IF_H_INCLUDED
#define SC_PAC_IF_H_INCLUDED

#include "systemc"
#include "sys/time.h"

using namespace sc_core;

#include "pac-iss.h"
#include "pac-dsp.h"
#include "sc-pac-memif.h"

SC_MODULE(SC_pac_if)
{
	int core_id;
	sc_in < bool > dsp_pin;
	sc_in < bool > if_pin;
	struct sim_arg *multi_sim_arg;

	struct core_insnbuf core_insnbuf0;
	struct icache_line *icache_mem;
	unsigned int l1_icache_type;
	unsigned int l1_icache_size;
	unsigned int l1_icache_line_size;

	void sc_pac_if_run();

	SC_HAS_PROCESS(SC_pac_if);
	SC_pac_if(sc_module_name _name, int id, struct sim_arg *arg)
	: core_id(id)
	, multi_sim_arg(arg) {
		unsigned int i;

		core_insnbuf0.addr = 0;
		l1_icache_type = multi_arg(pacdsp[core_id].l1_cache, l1_cache_type);
		l1_icache_size = multi_arg(pacdsp[core_id].l1_cache, l1_cache_size);
		l1_icache_line_size = multi_arg(pacdsp[core_id].l1_cache, l1_cache_line_size);

		icache_mem = new icache_line[l1_icache_size / l1_icache_line_size];
		for (i = 0; i < (l1_icache_size / l1_icache_line_size); i++) {
			icache_mem[i].insn = new unsigned char[l1_icache_line_size];
		}

		for (i = 0; i < (l1_icache_size / l1_icache_line_size); i++) {
			icache_mem[i].flag.tag = 0;
			icache_mem[i].flag.index = 0;
			icache_mem[i].flag.invalid = 1;
		}


		SC_THREAD(sc_pac_if_run);
		sensitive << dsp_pin.pos();
		sensitive << if_pin.pos();
	}

	void idle(volatile int *flag);

	void l1_icache_read(unsigned int addr, unsigned char *buf, int len);
	int  icache_read(unsigned int addr, unsigned char *buf, int len);
	int  icache_write(unsigned int addr, unsigned char *buf, int len);

	void sc_pac_pipeline_if(int is_step);
	Inst_Package_more * pac_get_inst_packet(unsigned int pc);
	int  length_decode(unsigned long long raw);
	int  pac_length_decode(unsigned long long raw);
	unsigned short operand_decode(unsigned char raw);
	void decode_A(inst_type raw, inst_t * inst);
	void decode_B(inst_type raw, inst_t * inst);
	void decode_C1(inst_type raw, inst_t * inst);
	void decode_C2(inst_type raw, inst_t * inst);
	void decode_C3(inst_type raw, inst_t * inst);
	void decode_C4(inst_type raw, inst_t * inst);
	void decode_C5(inst_type raw, inst_t * inst);
	void decode_D1(inst_type raw, inst_t * inst);
	void decode_D2(inst_type raw, inst_t * inst);
	void decode_D3(inst_type raw, inst_t * inst);
	void decode_D4(inst_type raw, inst_t * inst);
	void decode_D5(inst_type raw, inst_t * inst);
	void decode_D6(inst_type raw, inst_t * inst);
	void decode_D7(inst_type raw, inst_t * inst);
	int  decode_P1(inst_type *pkt_inst, inst_packet *package, int *isbranch);
	int  decode(Inst_Package_more *instpacket, unsigned int pc, int *isbranch);
};

extern SC_pac_if *sc_pac_if_ptr;
#endif
