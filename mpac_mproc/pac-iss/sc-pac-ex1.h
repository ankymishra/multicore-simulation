#ifndef SC_PAC_EX1_H_INCLUDED
#define SC_PAC_EX1_H_INCLUDED

#include "systemc"
#include "sys/time.h"

using namespace sc_core;

#include "pac-iss.h"
#include "pac-dsp.h"

SC_MODULE(SC_pac_ex1)
{
	sc_in < bool > dsp_pin;
	sc_in < bool > ex1_pin;
	void sc_pac_ex1_run();

	SC_HAS_PROCESS(SC_pac_ex1);
	SC_pac_ex1(sc_module_name _name)
	{
		SC_THREAD(sc_pac_ex1_run);
		sensitive << dsp_pin.pos();
		sensitive << ex1_pin.pos();
	}

	static void movil_ls_ex1(inst_t * curinst);
	static void movi_ls_ex1(inst_t * curinst);
	static void moviu_ls_ex1(inst_t * curinst);
	static void movih_ls_ex1(inst_t * curinst);
	static void moviuh_ls_ex1(inst_t * curinst);
	static void copy_ls_ex1(inst_t * curinst);
	static void copyu_ls_ex1(inst_t * curinst);
	static void limwcp_ls_ex1(inst_t * curinst);
	static void limwucp_ls_ex1(inst_t * curinst);
	static void limhwcp_ls_ex1(inst_t * curinst);
	static void limhwucp_ls_ex1(inst_t * curinst);
	static void limbcp_ls_ex1(inst_t * curinst);
	static void limbucp_ls_ex1(inst_t * curinst);
	static void pack2_ls_ex1(inst_t * curinst);
	static void unpack2_ls_ex1(inst_t * curinst);
	static void unpack2u_ls_ex1(inst_t * curinst);
	static void swap2_ls_ex1(inst_t * curinst);
	static void pack4_ls_ex1(inst_t * curinst);
	static void unpack4_ls_ex1(inst_t * curinst);
	static void unpack4u_ls_ex1(inst_t * curinst);
	static void swap4_ls_ex1(inst_t * curinst);
	static void swap4e_ls_ex1(inst_t * curinst);
	static void copy_fc_ls_ex1(inst_t * curinst);
	static void copy_fv_ls_ex1(inst_t * curinst);
	static void set_cpi_ls_ex1(inst_t * curinst);
	static void read_cpi_ls_ex1(inst_t * curinst);
	static void permh2_ls_ex1(inst_t * curinst);
	static void permh4_ls_ex1(inst_t * curinst);
	static void slt_ls_ex1(inst_t * curinst);
	static void sltu_ls_ex1(inst_t * curinst);
	static void sltll_ls_ex1(inst_t * curinst);
	static void slthh_ls_ex1(inst_t * curinst);
	static void sltull_ls_ex1(inst_t * curinst);
	static void sltuhh_ls_ex1(inst_t * curinst);
	static void slti_ls_ex1(inst_t * curinst);
	static void sltiu_ls_ex1(inst_t * curinst);
	static void sgti_ls_ex1(inst_t * curinst);
	static void sgtiu_ls_ex1(inst_t * curinst);
	static void seq_ls_ex1(inst_t * curinst);
	static void seqll_ls_ex1(inst_t * curinst);
	static void seqhh_ls_ex1(inst_t * curinst);
	static void seqi_ls_ex1(inst_t * curinst);
	static void min_ls_ex1(inst_t * curinst);
	static void minu_ls_ex1(inst_t * curinst);
	static void mind_ls_ex1(inst_t * curinst);
	static void minud_ls_ex1(inst_t * curinst);
	static void minq_ls_ex1(inst_t * curinst);
	static void minuq_ls_ex1(inst_t * curinst);
	static void dmin_ls_ex1(inst_t * curinst);
	static void dminu_ls_ex1(inst_t * curinst);
	static void max_ls_ex1(inst_t * curinst);
	static void maxu_ls_ex1(inst_t * curinst);
	static void maxd_ls_ex1(inst_t * curinst);
	static void maxud_ls_ex1(inst_t * curinst);
	static void maxq_ls_ex1(inst_t * curinst);
	static void maxuq_ls_ex1(inst_t * curinst);
	static void dmax_ls_ex1(inst_t * curinst);
	static void dmaxu_ls_ex1(inst_t * curinst);

	//void adds_ls_ex1(inst_t* curinst);
	static void add_ls_ex1(inst_t * curinst);
	static void adds_ls_ex1(inst_t * curinst);
	static void addu_ls_ex1(inst_t * curinst);
	static void addus_ls_ex1(inst_t * curinst);
	static void addd_ls_ex1(inst_t * curinst);
	static void addq_ls_ex1(inst_t * curinst);
	static void addds_ls_ex1(inst_t * curinst);
	static void addqs_ls_ex1(inst_t * curinst);
	static void addud_ls_ex1(inst_t * curinst);
	static void adduds_ls_ex1(inst_t * curinst);
	static void adduq_ls_ex1(inst_t * curinst);
	static void adduqs_ls_ex1(inst_t * curinst);
	static void addi_ls_ex1(inst_t * curinst);
	static void addis_ls_ex1(inst_t * curinst);
	static void addid_ls_ex1(inst_t * curinst);
	static void addids_ls_ex1(inst_t * curinst);
	static void addiud_ls_ex1(inst_t * curinst);
	static void addiuds_ls_ex1(inst_t * curinst);
	static void sub_ls_ex1(inst_t * curinst);
	static void subs_ls_ex1(inst_t * curinst);

	//void subds_ls_ex1(inst_t* curinst);
	static void subd_ls_ex1(inst_t * curinst);
	static void subq_ls_ex1(inst_t * curinst);
	static void subds_ls_ex1(inst_t * curinst);
	static void subqs_ls_ex1(inst_t * curinst);
	static void subu_ls_ex1(inst_t * curinst);
	static void subus_ls_ex1(inst_t * curinst);
	static void subud_ls_ex1(inst_t * curinst);
	static void subuq_ls_ex1(inst_t * curinst);
	static void subuds_ls_ex1(inst_t * curinst);
	static void subuqs_ls_ex1(inst_t * curinst);
	static void mergea_ls_ex1(inst_t * curinst);
	static void merges_ls_ex1(inst_t * curinst);
	static void neg_ls_ex1(inst_t * curinst);
	static void abs_ls_ex1(inst_t * curinst);
	static void absd_ls_ex1(inst_t * curinst);
	static void absq_ls_ex1(inst_t * curinst);
	static void addc_ls_ex1(inst_t * curinst);
	static void addcs_ls_ex1(inst_t * curinst);
	static void addcu_ls_ex1(inst_t * curinst);
	static void addcus_ls_ex1(inst_t * curinst);
	static void and_ls_ex1(inst_t * curinst);
	static void andi_ls_ex1(inst_t * curinst);
	static void or_ls_ex1(inst_t * curinst);
	static void ori_ls_ex1(inst_t * curinst);
	static void xor_ls_ex1(inst_t * curinst);
	static void xori_ls_ex1(inst_t * curinst);
	static void not_ls_ex1(inst_t * curinst);
	static void sll_ls_ex1(inst_t * curinst);
	static void slld_ls_ex1(inst_t * curinst);
	static void srl_ls_ex1(inst_t * curinst);
	static void srld_ls_ex1(inst_t * curinst);
	static void sra_ls_ex1(inst_t * curinst);
	static void srad_ls_ex1(inst_t * curinst);
	static void slli_ls_ex1(inst_t * curinst);
	static void sllid_ls_ex1(inst_t * curinst);
	static void srli_ls_ex1(inst_t * curinst);
	static void srlid_ls_ex1(inst_t * curinst);
	static void srai_ls_ex1(inst_t * curinst);
	static void sraid_ls_ex1(inst_t * curinst);
	static void extract_ls_ex1(inst_t * curinst);
	static void extractu_ls_ex1(inst_t * curinst);
	static void insert_ls_ex1(inst_t * curinst);
	static void rol_ls_ex1(inst_t * curinst);
	static void ror_ls_ex1(inst_t * curinst);
	static void andp_ls_ex1(inst_t * curinst);
	static void orp_ls_ex1(inst_t * curinst);
	static void xorp_ls_ex1(inst_t * curinst);
	static void notp_ls_ex1(inst_t * curinst);
	static void lw_ls_ex1(inst_t * curinst);
	static void lw_sc_ex1(inst_t * curinst);
	static void lwu_ls_ex1(inst_t * curinst);
	static void dlw_ls_ex1(inst_t * curinst);
	static void dlwu_ls_ex1(inst_t * curinst);
	static void lh_ls_ex1(inst_t * curinst);
	static void lh_sc_ex1(inst_t * curinst);
	static void lhu_ls_ex1(inst_t * curinst);
	static void lhu_sc_ex1(inst_t * curinst);
	static void dlh_ls_ex1(inst_t * curinst);
	static void dlhu_ls_ex1(inst_t * curinst);
	static void lb_ls_ex1(inst_t * curinst);
	static void lb_sc_ex1(inst_t * curinst);
	static void lbu_ls_ex1(inst_t * curinst);
	static void lbu_sc_ex1(inst_t * curinst);
	static void sw_ls_ex1(inst_t * curinst);
	static void sw_sc_ex1(inst_t * curinst);
	static void dsw_ls_ex1(inst_t * curinst);
	static void sh_ls_ex1(inst_t * curinst);
	static void sh_sc_ex1(inst_t * curinst);
	static void dsh_ls_ex1(inst_t * curinst);
	static void sb_ls_ex1(inst_t * curinst);
	static void sb_sc_ex1(inst_t * curinst);
	static void dsb_ls_ex1(inst_t * curinst);
	static void bdr_ls_ex1(inst_t * curinst);
	static void dbdr_ls_ex1(inst_t * curinst);
	static void bdt_ls_ex1(inst_t * curinst);
	static void dbdt_ls_ex1(inst_t * curinst);
	static void dex_ls_ex1(inst_t * curinst);
	static void ddex_ls_ex1(inst_t * curinst);
	static void clr_ls_ex1(inst_t * curinst);
	static void dclr_ls_ex1(inst_t * curinst);
	static void lmbd_ls_ex1(inst_t * curinst);
	static void fmul_au_ex1(inst_t * curinst);
	static void fmuld_au_ex1(inst_t * curinst);
	static void fmuluud_au_ex1(inst_t * curinst);
	static void fmulusd_au_ex1(inst_t * curinst);
	static void fmulsud_au_ex1(inst_t * curinst);
	static void fmuluu_au_ex1(inst_t * curinst);
	static void fmulsu_au_ex1(inst_t * curinst);
	static void fmulus_au_ex1(inst_t * curinst);
	static void muld_au_ex1(inst_t * curinst);
	static void mulds_au_ex1(inst_t * curinst);
	static void xfmul_au_ex1(inst_t * curinst);
	static void xfmuld_au_ex1(inst_t * curinst);
	static void xmuld_au_ex1(inst_t * curinst);
	static void fmac_au_ex1(inst_t * curinst);
	static void fmacd_au_ex1(inst_t * curinst);
	static void fmacuud_au_ex1(inst_t * curinst);
	static void fmacusd_au_ex1(inst_t * curinst);
	static void fmacsud_au_ex1(inst_t * curinst);
	static void fmacuu_au_ex1(inst_t * curinst);
	static void fmacsu_au_ex1(inst_t * curinst);
	static void fmacus_au_ex1(inst_t * curinst);
	static void macd_au_ex1(inst_t * curinst);
	static void macds_au_ex1(inst_t * curinst);
	static void msud_au_ex1(inst_t * curinst);
	static void msuds_au_ex1(inst_t * curinst);
	static void xfmac_au_ex1(inst_t * curinst);
	static void xfmacd_au_ex1(inst_t * curinst);
	static void xmacd_au_ex1(inst_t * curinst);
	static void xmacds_au_ex1(inst_t * curinst);
	static void xmsud_au_ex1(inst_t * curinst);
	static void xmsuds_au_ex1(inst_t * curinst);
	static void cls_au_ex1(inst_t * curinst);
	static void sfra_au_ex1(inst_t * curinst);
	static void sfrad_au_ex1(inst_t * curinst);
	static void bf_au_ex1(inst_t * curinst);
	static void bfd_au_ex1(inst_t * curinst);
	static void dotp2_au_ex1(inst_t * curinst);
	static void xdotp2_au_ex1(inst_t * curinst);
	static void rnd_au_ex1(inst_t * curinst);
	static void saaq_au_ex1(inst_t * curinst);
	static void b_sc_ex1(inst_t * curinst);
	static void br_sc_ex1(inst_t * curinst);
	static void brr_sc_ex1(inst_t * curinst);
	static void lbcb_sc_ex1(inst_t * curinst);
	static void test_sc_ex1(inst_t * curinst);
	static void wait_sc_ex1(inst_t * curinst);
	static void read_flag_sc_ex1(inst_t * curinst);
	static void write_flag_sc_ex1(inst_t * curinst);
	static void copy_cfi_sc_ex1(inst_t * curinst);
	static void adsr_au_ex1(inst_t * curinst);
	static void adsru_au_ex1(inst_t * curinst);
	static void adsrd_au_ex1(inst_t * curinst);
	static void adsrud_au_ex1(inst_t * curinst);
	static void adsrf_au_ex1(inst_t * curinst);
	static void adsrfu_au_ex1(inst_t * curinst);
	static void adsrfd_au_ex1(inst_t * curinst);
	static void adsrfud_au_ex1(inst_t * curinst);
	static void clip_au_ex1(inst_t * curinst);
	static void clipd_au_ex1(inst_t * curinst);
	static void clipu_au_ex1(inst_t * curinst);
	static void clipud_au_ex1(inst_t * curinst);

	static void invalid_inst(inst_t * curinst);
	static void nop_inst(inst_t * curinst);

	static unsigned int regfile_read(unsigned char num, unsigned char type);
	static unsigned long long regfile_l_read(unsigned char num, unsigned char type);
	static void regfile_write(unsigned char num, unsigned char type, unsigned int data);
	static void regfile_l_write(unsigned char num, unsigned char type, unsigned long long data);

	static unsigned char cp_read(unsigned char addr);
	static unsigned char psr_read(unsigned char idx, unsigned char type);
	static unsigned char psr_read_addv(unsigned char idx, int dummy);
	static unsigned char psr_read_addc(unsigned char idx, int dummy);
	static void psr_write(unsigned char idx, unsigned char type, unsigned char data);

	static unsigned int detect_carry(unsigned long long uldst, unsigned long long ulsrc1,
									 unsigned long long ulsrc2);
	static unsigned int detect_overflow8(unsigned int udst1, unsigned int udst2, unsigned int udst3,
										unsigned int udst4, unsigned int usrc1, unsigned int usrc2);
	static unsigned int detect_overflow8_sub(unsigned int udst1, unsigned int udst2, unsigned int udst3,
										unsigned int udst4, unsigned int usrc1, unsigned int usrc2);
	static unsigned int detect_overflow16(unsigned int udst1, unsigned int udst2,
										unsigned int usrc1, unsigned int usrc2);
	static unsigned int detect_overflow16_sub(unsigned int udst1, unsigned int udst2,
										unsigned int usrc1, unsigned int usrc2);
	static unsigned int detect_overflow(unsigned long long uldst, unsigned long long ulsrc1,
										unsigned long long ulsrc2);
	static unsigned int detect_overflow_sub(unsigned long long uldst, unsigned long long ulsrc1,
										unsigned long long ulsrc2);

	static unsigned int ls_addr_gen(inst_t * curinst);
	static void sc_addr_gen(inst_t * curinst);
};

#endif

