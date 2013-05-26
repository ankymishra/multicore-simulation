#ifndef SC_PAC_EX2_H_INCLUDED
#define SC_PAC_EX2_H_INCLUDED

#include "systemc"
#include "sys/time.h"

using namespace sc_core;

#include "pac-iss.h"
#include "pac-dsp.h"
#include "sc-pac-memif.h"

SC_MODULE(SC_pac_ex2)
{
	typedef void (SC_pac_ex2::*pac_ex2_funcs)(inst_t *t);

public:
	int ex2_id;
	sc_in < bool > dsp_pin;
	sc_in < bool > ex2_pin;
	
	pac_ex2_funcs ls_funcs_e2_t[256];
	pac_ex2_funcs au_funcs_e2_t[256];
	pac_ex2_funcs sc_funcs_e2_t[256];

	void sc_pac_ex2_run();
	SC_HAS_PROCESS(SC_pac_ex2);
	SC_pac_ex2(sc_module_name _name, int id)
	: ex2_id(id)
	{
		ex2_init_funcs_table();

		SC_THREAD(sc_pac_ex2_run);
		sensitive << dsp_pin.pos();
		sensitive << ex2_pin.pos();
	}
	
	void ex2_init_funcs_table();

	void adds_ls_ex2(inst_t * curinst);
	void addus_ls_ex2(inst_t * curinst);
	void addds_ls_ex2(inst_t * curinst);
	void addqs_ls_ex2(inst_t * curinst);
	void adduds_ls_ex2(inst_t * curinst);
	void adduqs_ls_ex2(inst_t * curinst);
	void addis_ls_ex2(inst_t * curinst);
	void addids_ls_ex2(inst_t * curinst);
	void addiuds_ls_ex2(inst_t * curinst);
	void subs_ls_ex2(inst_t * curinst);
	void subds_ls_ex2(inst_t * curinst);
	void subqs_ls_ex2(inst_t * curinst);
	void subus_ls_ex2(inst_t * curinst);
	void subuds_ls_ex2(inst_t * curinst);
	void subuqs_ls_ex2(inst_t * curinst);
	void addcs_ls_ex2(inst_t * curinst);
	void addcus_ls_ex2(inst_t * curinst);
	void lw_ls_ex2(inst_t * curinst);
	void lwu_ls_ex2(inst_t * curinst);
	void dlw_ls_ex2(inst_t * curinst);
	void dlwu_ls_ex2(inst_t * curinst);
	void lh_ls_ex2(inst_t * curinst);
	void lhu_ls_ex2(inst_t * curinst);
	void dlh_ls_ex2(inst_t * curinst);
	void dlhu_ls_ex2(inst_t * curinst);
	void lb_ls_ex2(inst_t * curinst);
	void lbu_ls_ex2(inst_t * curinst);
	void sw_ls_ex2(inst_t * curinst);
	void dsw_ls_ex2(inst_t * curinst);
	void sh_ls_ex2(inst_t * curinst);
	void sb_ls_ex2(inst_t * curinst);
	void bdr_ls_ex2(inst_t * curinst);
	void dbdr_ls_ex2(inst_t * curinst);
	void bdt_ls_ex2(inst_t * curinst);
	void dbdt_ls_ex2(inst_t * curinst);
	void dex_ls_ex2(inst_t * curinst);
	void ddex_ls_ex2(inst_t * curinst);
	void mulds_au_ex2(inst_t * curinst);
	void fmac_au_ex2(inst_t * curinst);
	void fmacd_au_ex2(inst_t * curinst);
	void fmacuud_au_ex2(inst_t * curinst);
	void fmacusd_au_ex2(inst_t * curinst);
	void fmacsud_au_ex2(inst_t * curinst);
	void fmacuu_au_ex2(inst_t * curinst);
	void fmacsu_au_ex2(inst_t * curinst);
	void fmacus_au_ex2(inst_t * curinst);
	void macd_au_ex2(inst_t * curinst);
	void macds_au_ex2(inst_t * curinst);
	void msud_au_ex2(inst_t * curinst);
	void msuds_au_ex2(inst_t * curinst);
	void xfmac_au_ex2(inst_t * curinst);
	void xfmacd_au_ex2(inst_t * curinst);
	void xmacd_au_ex2(inst_t * curinst);
	void xmacds_au_ex2(inst_t * curinst);
	void xmsud_au_ex2(inst_t * curinst);
	void xmsuds_au_ex2(inst_t * curinst);
	void sfra_au_ex2(inst_t * curinst);
	void sfrad_au_ex2(inst_t * curinst);
	void dotp2_au_ex2(inst_t * curinst);
	void xdotp2_au_ex2(inst_t * curinst);
	void saaq_au_ex2(inst_t * curinst);
	void b_sc_ex2(inst_t * curinst);
	void br_sc_ex2(inst_t * curinst);
	void brr_sc_ex2(inst_t * curinst);
	void lbcb_sc_ex2(inst_t * curinst);
	void adsr_au_ex2(inst_t * curinst);
	void adsru_au_ex2(inst_t * curinst);
	void adsrd_au_ex2(inst_t * curinst);
	void adsrud_au_ex2(inst_t * curinst);
	void adsrf_au_ex2(inst_t * curinst);
	void adsrfu_au_ex2(inst_t * curinst);
	void adsrfd_au_ex2(inst_t * curinst);
	void adsrfud_au_ex2(inst_t * curinst);

	void invalid_inst(inst_t * curinst);
	void nop_inst(inst_t * curinst);

	unsigned int regfile_read(unsigned char num, unsigned char type);
	void regfile_write(unsigned char num, unsigned char type, unsigned int data);
	void regfile_l_write(unsigned char num, unsigned char type, unsigned long long data);
	void stage2_l_write(unsigned char num, unsigned char type, unsigned long long data);

	unsigned long long data_access(unsigned char type, unsigned int addr,
					   unsigned char size, unsigned long long data);

	unsigned int get_fetch_pc();
	void set_fetch_pc(unsigned int pc);
	void save_branch_target(unsigned int pc);
	
	void idle(volatile int *flag);
	void dmem_read(unsigned int addr, unsigned long long *udata, unsigned char size);
	int  dmem_write(unsigned int addr, unsigned long long *data, unsigned char size);
};


#endif

