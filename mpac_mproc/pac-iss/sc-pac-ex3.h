#ifndef SC_PAC_EX3_H_INCLUDED
#define SC_PAC_EX3_H_INCLUDED

#include "systemc"
#include "sys/time.h"

using namespace sc_core;

#include "pac-iss.h"
#include "pac-dsp.h"

SC_MODULE(SC_pac_ex3)
{
	void sc_pac_ex3_run();

	SC_HAS_PROCESS(SC_pac_ex3);
	SC_pac_ex3(sc_module_name _name)
	{
		SC_THREAD(sc_pac_ex3_run);
	}

	static void lw_ls_ex3(inst_t * curinst);
	static void lwu_ls_ex3(inst_t * curinst);
	static void dlw_ls_ex3(inst_t * curinst);
	static void dlwu_ls_ex3(inst_t * curinst);
	static void lh_ls_ex3(inst_t * curinst);
	static void lhu_ls_ex3(inst_t * curinst);
	static void dlh_ls_ex3(inst_t * curinst);
	static void dlhu_ls_ex3(inst_t * curinst);
	static void lb_ls_ex3(inst_t * curinst);
	static void lbu_ls_ex3(inst_t * curinst);
	static void sw_ls_ex3(inst_t * curinst);
	static void dsw_ls_ex3(inst_t * curinst);
	static void sh_ls_ex3(inst_t * curinst);
	static void dsh_ls_ex3(inst_t * curinst);
	static void sb_ls_ex3(inst_t * curinst);
	static void dsb_ls_ex3(inst_t * curinst);
	static void b_sc_ex3(inst_t * curinst);
	static void br_sc_ex3(inst_t * curinst);
	static void brr_sc_ex3(inst_t * curinst);
	static void lbcb_sc_ex3(inst_t * curinst);

	static void invalid_inst(inst_t * curinst);
	static void nop_inst(inst_t * curinst);

	static void stage2_l_write(unsigned char num, unsigned char type, unsigned long long data);
	static void stage3_l_write(unsigned char num, unsigned char type, unsigned long long data);
	static void psr_write_stage3(unsigned char idx, unsigned char type, unsigned char data);

	static void regfile_write(unsigned char num, unsigned char type, unsigned int data);
	static void regfile_l_write(unsigned char num, unsigned char type, unsigned long long data);
	static int  write_conflict_check(unsigned char type, unsigned char addr);
};

#endif
