#include "pac-dsp.h"
#include "sc-pac-ex3.h"

void SC_pac_ex3::lw_ls_ex3(inst_t * curinst)
{
	int i;

	if (curinst->Rd1_Type != Reg_PSR) {
		regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
						(int) curinst->WB_Data);
		if (!write_conflict_check(curinst->Rd1_Type, curinst->Rd1_Addr)) {
			stage2_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
						   (int) curinst->WB_Data);
		}
		stage3_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
					   (int) curinst->WB_Data);
	} else {
		for (i = 0; i < 7; i++) {
			psr_write_stage3(curinst->Rd1_Addr, i, curinst->WB_Data & 0x1);
			curinst->WB_Data >>= 1;
		}
	}
}

void SC_pac_ex3::lwu_ls_ex3(inst_t * curinst)
{
	int i;

	if (curinst->Rd1_Type != Reg_PSR) {
		regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
						curinst->WB_Data);
		if (!write_conflict_check(curinst->Rd1_Type, curinst->Rd1_Addr)) {
			stage2_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
						   curinst->WB_Data);
		}
		stage3_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
					   curinst->WB_Data);
	} else {
		for (i = 0; i < 7; i++) {
			psr_write_stage3(curinst->Rd1_Addr, i, curinst->WB_Data & 0x1);
			curinst->WB_Data >>= 1;
		}
	}
}

void SC_pac_ex3::dlw_ls_ex3(inst_t * curinst)
{
	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
					(int) curinst->WB_Data);
	if (!write_conflict_check(curinst->Rd1_Type, curinst->Rd1_Addr)) {
		stage2_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
					   (int) curinst->WB_Data);
	}
	regfile_l_write(curinst->Rd1_Addr + 1, curinst->Rd1_Type,
					(int) curinst->WB_Data1);
	if (!write_conflict_check(curinst->Rd1_Type, curinst->Rd1_Addr + 1)) {
		stage2_l_write(curinst->Rd1_Addr + 1, curinst->Rd1_Type,
					   (int) curinst->WB_Data1);
	}
	stage3_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
				   (int) curinst->WB_Data);
	stage3_l_write(curinst->Rd1_Addr + 1, curinst->Rd1_Type,
				   (int) curinst->WB_Data1);
}

void SC_pac_ex3::dlwu_ls_ex3(inst_t * curinst)
{
	/*load double word */

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
					(unsigned int) curinst->WB_Data);
	if (!write_conflict_check(curinst->Rd1_Type, curinst->Rd1_Addr)) {
		stage2_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
					   (unsigned int) curinst->WB_Data);
	}
	regfile_l_write(curinst->Rd1_Addr + 1, curinst->Rd1_Type,
					(unsigned int) curinst->WB_Data1);
	if (!write_conflict_check(curinst->Rd1_Type, curinst->Rd1_Addr + 1)) {
		stage2_l_write(curinst->Rd1_Addr + 1, curinst->Rd1_Type,
					   (unsigned int) curinst->WB_Data1);
	}
	stage3_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
				   (unsigned int) curinst->WB_Data);
	stage3_l_write(curinst->Rd1_Addr + 1, curinst->Rd1_Type,
				   (unsigned int) curinst->WB_Data1);
}

void SC_pac_ex3::lh_ls_ex3(inst_t * curinst)
{
	int i;

	if (curinst->Rd1_Type != Reg_PSR) {
		regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
						(short) curinst->WB_Data);
		if (!write_conflict_check(curinst->Rd1_Type, curinst->Rd1_Addr)) {
			stage2_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
						   (short) curinst->WB_Data);
		}
		stage3_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
					   (short) curinst->WB_Data);
	} else {
		for (i = 0; i < 7; i++) {
			psr_write_stage3(curinst->Rd1_Addr, i, curinst->WB_Data & 0x1);
			curinst->WB_Data >>= 1;
		}
	}
}

void SC_pac_ex3::lhu_ls_ex3(inst_t * curinst)
{
	int i;

	if (curinst->Rd1_Type != Reg_PSR) {
		regfile_write(curinst->Rd1_Addr, curinst->Rd1_Type, curinst->WB_Data);
		if (!write_conflict_check(curinst->Rd1_Type, curinst->Rd1_Addr)) {
			stage2_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
						   (unsigned short) curinst->WB_Data);
		}
		stage3_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
					   (unsigned short) curinst->WB_Data);
	} else {
		for (i = 0; i < 7; i++) {
			psr_write_stage3(curinst->Rd1_Addr, i, curinst->WB_Data & 0x1);
			curinst->WB_Data >>= 1;
		}
	}
}

void SC_pac_ex3::dlh_ls_ex3(inst_t * curinst)
{
	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
					(short) curinst->WB_Data);
	if (!write_conflict_check(curinst->Rd1_Type, curinst->Rd1_Addr)) {
		stage2_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
					   (short) curinst->WB_Data);
	}
	regfile_l_write(curinst->Rd1_Addr + 1, curinst->Rd1_Type,
					(short) curinst->WB_Data1);
	if (!write_conflict_check(curinst->Rd1_Type, curinst->Rd1_Addr + 1)) {
		stage2_l_write(curinst->Rd1_Addr + 1, curinst->Rd1_Type,
					   (short) curinst->WB_Data1);
	}
	stage3_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
				   (short) curinst->WB_Data);
	stage3_l_write(curinst->Rd1_Addr + 1, curinst->Rd1_Type,
				   (short) curinst->WB_Data1);
}

void SC_pac_ex3::dlhu_ls_ex3(inst_t * curinst)
{
	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
					(unsigned short) curinst->WB_Data);
	if (!write_conflict_check(curinst->Rd1_Type, curinst->Rd1_Addr)) {
		stage2_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
					   (unsigned short) curinst->WB_Data);
	}
	regfile_l_write(curinst->Rd1_Addr + 1, curinst->Rd1_Type,
					(unsigned short) curinst->WB_Data1);
	if (!write_conflict_check(curinst->Rd1_Type, curinst->Rd1_Addr + 1)) {
		stage2_l_write(curinst->Rd1_Addr + 1, curinst->Rd1_Type,
					   (unsigned short) curinst->WB_Data1);
	}
	stage3_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
				   (unsigned short) curinst->WB_Data);
	stage3_l_write(curinst->Rd1_Addr + 1, curinst->Rd1_Type,
				   (unsigned short) curinst->WB_Data1);
}

void SC_pac_ex3::lb_ls_ex3(inst_t * curinst)
{
	int i;

	if (curinst->Rd1_Type != Reg_PSR) {
		regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
						(char) curinst->WB_Data);
		if (!write_conflict_check(curinst->Rd1_Type, curinst->Rd1_Addr)) {
			stage2_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
						   (char) curinst->WB_Data);
		}
		stage3_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
					   (char) curinst->WB_Data);
	} else {
		for (i = 0; i < 7; i++) {
			psr_write_stage3(curinst->Rd1_Addr, i, curinst->WB_Data & 0x1);
			curinst->WB_Data >>= 1;
		}
	}
}

void SC_pac_ex3::lbu_ls_ex3(inst_t * curinst)
{
	int i;

	if (curinst->Rd1_Type != Reg_PSR) {
		regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
						(unsigned char) curinst->WB_Data);
		if (!write_conflict_check(curinst->Rd1_Type, curinst->Rd1_Addr)) {
			stage2_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
						   (unsigned char) curinst->WB_Data);
		}
		stage3_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
					   (unsigned char) curinst->WB_Data);
	} else {
		for (i = 0; i < 7; i++) {
			psr_write_stage3(curinst->Rd1_Addr, i, curinst->WB_Data & 0x1);
			curinst->WB_Data >>= 1;
		}
	}
}

//memory operation in ex3
void SC_pac_ex3::sw_ls_ex3(inst_t * curinst)
{
}
void SC_pac_ex3::dsw_ls_ex3(inst_t * curinst)
{
}
void SC_pac_ex3::sh_ls_ex3(inst_t * curinst)
{
}
void SC_pac_ex3::dsh_ls_ex3(inst_t * curinst)
{
}
void SC_pac_ex3::sb_ls_ex3(inst_t * curinst)
{
}
void SC_pac_ex3::dsb_ls_ex3(inst_t * curinst)
{
}

void SC_pac_ex3::b_sc_ex3(inst_t * curinst)
{
	if (curinst->Rd1_Addr != (unsigned char) INVALID_REG) {
		regfile_write(curinst->Rd1_Addr, curinst->Rd1_Type, curinst->WB_Data);
		if (!write_conflict_check(curinst->Rd1_Type, curinst->Rd1_Addr)) {
			stage2_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
						   curinst->WB_Data);
		}
		stage3_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
					   curinst->WB_Data);
	}
}

void SC_pac_ex3::br_sc_ex3(inst_t * curinst)
{
	if (curinst->Rd1_Addr != (unsigned char) INVALID_REG) {
		regfile_write(curinst->Rd1_Addr, curinst->Rd1_Type, curinst->WB_Data);
		if (!write_conflict_check(curinst->Rd1_Type, curinst->Rd1_Addr)) {
			stage2_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
						   curinst->WB_Data);
		}
		stage3_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
					   curinst->WB_Data);
	}
}

void SC_pac_ex3::brr_sc_ex3(inst_t * curinst)
{
	if (curinst->Rd1_Addr != (unsigned char) INVALID_REG) {
		regfile_write(curinst->Rd1_Addr, curinst->Rd1_Type, curinst->WB_Data);
		if (!write_conflict_check(curinst->Rd1_Type, curinst->Rd1_Addr)) {
			stage2_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
						   curinst->WB_Data);
		}
		stage3_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
					   curinst->WB_Data);
	}
}

void SC_pac_ex3::lbcb_sc_ex3(inst_t * curinst)
{
	if (curinst->Rd1_Addr != (unsigned char) INVALID_REG) {
		regfile_write(curinst->Rd1_Addr, curinst->Rd1_Type, curinst->WB_Data);
		if (!write_conflict_check(curinst->Rd1_Type, curinst->Rd1_Addr)) {
			stage2_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
						   curinst->WB_Data);
		}
		stage3_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
					   curinst->WB_Data);
	}
}

void SC_pac_ex3::invalid_inst(inst_t * curinst)
{
	fprintf(stderr, "Invalid instrution, opcode : %d\n", curinst->op);
}

void SC_pac_ex3::nop_inst(inst_t * curinst)
{
	return;
}

void SC_pac_ex3::stage2_l_write(unsigned char num, unsigned char type, unsigned long long data)
{
	dsp_core->stage2_l_write(num, type, data);
}

void SC_pac_ex3::stage3_l_write(unsigned char num, unsigned char type, unsigned long long data)
{
	dsp_core->stage3_l_write(num, type, data);
}

void SC_pac_ex3::psr_write_stage3(unsigned char idx, unsigned char type, unsigned char data)
{
	dsp_core->psr_write_stage3(idx, type, data);
}

void SC_pac_ex3::regfile_write(unsigned char num, unsigned char type, unsigned int data)
{
	dsp_core->regfile_write(num, type, data);
}

void SC_pac_ex3::regfile_l_write(unsigned char num, unsigned char type, unsigned long long data)
{
	dsp_core->regfile_l_write(num, type, data);
}

int SC_pac_ex3::write_conflict_check(unsigned char type, unsigned char addr)
{
	return dsp_core->write_conflict_check(type, addr);
}

pac_funcs ls_funcs_e3_t[256] = {
	SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst,
		//25
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst,
		//50
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst,
		//75
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst,
		//100
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst,
		//125
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::dlh_ls_ex3, SC_pac_ex3::dlhu_ls_ex3, SC_pac_ex3::dlw_ls_ex3,
		SC_pac_ex3::dsb_ls_ex3, SC_pac_ex3::dsw_ls_ex3, SC_pac_ex3::lb_ls_ex3,
		SC_pac_ex3::lbu_ls_ex3, SC_pac_ex3::lh_ls_ex3, SC_pac_ex3::lhu_ls_ex3,
		SC_pac_ex3::lw_ls_ex3, SC_pac_ex3::lw_ls_ex3, SC_pac_ex3::sb_ls_ex3,
		SC_pac_ex3::sw_ls_ex3, SC_pac_ex3::lwu_ls_ex3, SC_pac_ex3::dlwu_ls_ex3,
		SC_pac_ex3::lwu_ls_ex3, SC_pac_ex3::dlw_ls_ex3, SC_pac_ex3::dlwu_ls_ex3,
		SC_pac_ex3::sw_ls_ex3,
		//150
		SC_pac_ex3::dsw_ls_ex3, SC_pac_ex3::sh_ls_ex3, SC_pac_ex3::nop_inst,
		SC_pac_ex3::dsh_ls_ex3, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst,
		//175
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst,
		//200
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst,
		//225
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst,
		//250
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		//255
SC_pac_ex3::nop_inst,};

static pac_funcs au_funcs_e3_t[256] = {
	SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst,
		//25
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst,
		//50
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst,
		//75
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst,
		//100
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst,
		//125
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst,
		//150
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst,
		//175
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst,
		//200
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst,
		//225
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst,
		//250
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		//255
SC_pac_ex3::nop_inst,};

static pac_funcs sc_funcs_e3_t[256] = {
	SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst,
		//25
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst,
		//50
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst,
		//75
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst,
		//100
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst,
		//125
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::lb_ls_ex3,
		SC_pac_ex3::lbu_ls_ex3, SC_pac_ex3::lh_ls_ex3, SC_pac_ex3::lhu_ls_ex3,
		SC_pac_ex3::nop_inst, SC_pac_ex3::lw_ls_ex3, SC_pac_ex3::sb_ls_ex3,
		SC_pac_ex3::sw_ls_ex3, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst,
		//150
		SC_pac_ex3::nop_inst, SC_pac_ex3::sh_ls_ex3, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst,
		//175
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst,
		//200
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst,
		//225
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::lbcb_sc_ex3, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::b_sc_ex3, SC_pac_ex3::br_sc_ex3,
		SC_pac_ex3::brr_sc_ex3, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst,
		//250
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		SC_pac_ex3::nop_inst, SC_pac_ex3::nop_inst,
		//255
SC_pac_ex3::nop_inst,};

void SC_pac_ex3::sc_pac_ex3_run()
{
	int i, cur_op;

	while(1) {
		wait(ex3_event);

		for (i = 0; i < INST_NO; i++) {
			if (!(exec_table[EX3_IDX].instr[i].execute))
				continue;
			else if (exec_table[EX3_IDX].instr[i].inst.op == NOP)
				continue;

			cur_op = exec_table[EX3_IDX].instr[i].inst.op;
			cluster_idx = i;
			if (i == 1 || i == 3) {
				ls_funcs_e3_t[cur_op](&(exec_table[EX3_IDX].instr[i].inst));
			} else if (i == 2 || i == 4) {
				au_funcs_e3_t[cur_op](&(exec_table[EX3_IDX].instr[i].inst));
			} else {
				sc_funcs_e3_t[cur_op](&(exec_table[EX3_IDX].instr[i].inst));
			}
		}

		ex3_resp_event.notify();
	}
}


