#include "pac-dsp.h"
#include "sc-pac-ex1.h"

void SC_pac_ex1::movil_ls_ex1(inst_t * curinst)
{
	/*rd[15:0] = imm; */
	int i;
	unsigned long long uldst;

	uldst = regfile_l_read(curinst->Rd1_Addr, curinst->Rd1_Type);

	uldst = ((unsigned long long) curinst->Imm32) | HIGH16MASK64(uldst);

	if (curinst->Rd1_Type != Reg_PSR) {
		regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, uldst);
	} else {
		uldst >>= 2;
		for (i = 2; i < 7; i++) {
			psr_write(curinst->Rd1_Addr, i, uldst & 0x1);
			uldst >>= 1;
		}
	}
}

void SC_pac_ex1::movi_ls_ex1(inst_t * curinst)
{
	unsigned long long uldst;
	int i;

	uldst = (int) curinst->Imm32;

	if (curinst->Rd1_Type != Reg_PSR) {
		regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, uldst);
	} else {
		uldst >>= 2;
		for (i = 2; i < 7; i++) {
			psr_write(curinst->Rd1_Addr, i, uldst & 0x1);
			uldst >>= 1;
		}
	}
}

void SC_pac_ex1::moviu_ls_ex1(inst_t * curinst)
{
	unsigned long long uldst;
	int i;

	uldst = (unsigned int) curinst->Imm32;

	if (curinst->Rd1_Type != Reg_PSR) {
		if (curinst->Rd1_Type == Reg_AC)
			regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, uldst);
		else
			regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
							(int) uldst);
	} else {
		uldst >>= 2;
		for (i = 2; i < 7; i++) {
			psr_write(curinst->Rd1_Addr, i, uldst & 0x1);
			uldst >>= 1;
		}
	}
}

void SC_pac_ex1::movih_ls_ex1(inst_t * curinst)
{
	/*rd[31:16] = imm, and do signed extension */
	unsigned long long uldst;

	uldst = regfile_l_read(curinst->Rd1_Addr, curinst->Rd1_Type);
	uldst = (int) ((curinst->Imm32 << 16) | LOW16MASK(uldst));

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, uldst);
}

void SC_pac_ex1::moviuh_ls_ex1(inst_t * curinst)
{
	/*rd[31:16] = imm, and do zero extension */
	unsigned long long uldst;

	uldst = regfile_l_read(curinst->Rd1_Addr, curinst->Rd1_Type);
	uldst = (curinst->Imm32 << 16) | LOW16MASK(uldst);

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, uldst);
}

void SC_pac_ex1::copy_ls_ex1(inst_t * curinst)
{
	/*copy a value from one register to another */
	unsigned long long udst, usrc;
	int i;

	if (curinst->Rs1_Type != Reg_PSR) {
		if (curinst->Rs1_Type != Reg_AC)
			usrc = (int) regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
		else
			usrc = regfile_l_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	} else {
		usrc = 0;
		for (i = 6; i > -1; i--) {
			usrc <<= 1;
			if (psr_read(curinst->Rs1_Addr, i))
				usrc |= 0x1;
			else
				usrc &= 0xFE;
		}
	}

	udst = usrc;

	if (curinst->Rd1_Type != Reg_PSR) {
		regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst);
	} else {
		udst >>= 2;
		for (i = 2; i < 7; i++) {
			psr_write(curinst->Rd1_Addr, i, udst & 0x1);
			udst >>= 1;
		}
	}
}

void SC_pac_ex1::copyu_ls_ex1(inst_t * curinst)
{
	/*copy a unsigned value from one register to another */
	unsigned long long udst, usrc;
	int i;

	if (curinst->Rs1_Type != Reg_PSR) {
		if (curinst->Rs1_Type != Reg_AC)
			usrc = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
		else
			usrc = regfile_l_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	} else {
		usrc = 0;
		for (i = 6; i > -1; i--) {
			usrc <<= 1;
			if (psr_read(curinst->Rs1_Addr, i))
				usrc |= 0x1;
			else
				usrc &= 0xFE;
		}
	}

	udst = usrc;

	if (curinst->Rd1_Type != Reg_PSR) {
		regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst);
	} else {
		udst >>= 2;
		for (i = 2; i < 7; i++) {
			psr_write(curinst->Rd1_Addr, i, udst & 0x1);
			udst >>= 1;
		}
	}
}

void SC_pac_ex1::limwcp_ls_ex1(inst_t * curinst)
{
	unsigned long long uldst, ulsrc;

	if (curinst->Rs1_Type != Reg_AC)
		ulsrc = (int) regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	else
		ulsrc = regfile_l_read(curinst->Rs1_Addr, curinst->Rs1_Type);

	if ((long long) ulsrc > (int) 0x7fffffff)
		uldst = (int) 0x7fffffff;
	else if ((long long) ulsrc < (int) 0x80000000)
		uldst = (int) 0x80000000;
	else
		uldst = ulsrc;

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, uldst);
}

void SC_pac_ex1::limwucp_ls_ex1(inst_t * curinst)
{
	unsigned long long uldst, ulsrc;

	if (curinst->Rs1_Type != Reg_AC)
		ulsrc =
			(unsigned int) regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	else
		ulsrc = regfile_l_read(curinst->Rs1_Addr, curinst->Rs1_Type);

	if (ulsrc > 0xffffffff)
		uldst = 0xffffffff;
	else
		uldst = ulsrc;

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, uldst);
}

void SC_pac_ex1::limhwcp_ls_ex1(inst_t * curinst)
{
	/*saturize the value of rs and store in rd */
	unsigned int ulsrc;
	unsigned long long uldst;

	ulsrc = (int) regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);

	if (((int) ulsrc) > ((short) 0x7fff))
		uldst = (short) 0x7fff;
	else if (((int) ulsrc) < ((short) 0x8000))
		uldst = (short) 0x8000;
	else
		uldst = (int) ulsrc;

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, uldst);
}

void SC_pac_ex1::limhwucp_ls_ex1(inst_t * curinst)
{
	/*saturize the value of rs and store in rd */
	unsigned int uldst, ulsrc;

	ulsrc = (unsigned int) regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);

	if (ulsrc > 0xffff)
		uldst = 0xffff;
	else
		uldst = ulsrc;

	regfile_write(curinst->Rd1_Addr, curinst->Rd1_Type, uldst);
}

void SC_pac_ex1::limbcp_ls_ex1(inst_t * curinst)
{
	/*saturize the value of rs and store in rd */
	unsigned int usrc, udst;

	usrc = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);

	if ((short) (LOW16MASK(usrc)) > (char) (0x7f))
		udst = 0x7f;
	else if ((short) (LOW16MASK(usrc)) < (char) (0x80))
		udst = 0xff80;
	else
		udst = LOW16MASK(usrc);

	if ((short) ((HIGH16MASK(usrc) >> 16)) > (char) (0x7f))
		udst |= 0x7f0000;
	else if ((short) ((HIGH16MASK(usrc) >> 16)) < (char) (0x80))
		udst |= 0xff800000;
	else
		udst |= HIGH16MASK(usrc);

	regfile_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst);
}

void SC_pac_ex1::limbucp_ls_ex1(inst_t * curinst)
{
	/*saturize the value of rs and store in rd */
	unsigned int usrc, udst;

	usrc = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);

	if (((short) LOW16MASK(usrc)) > (short) (0x00ff))
		udst = 0xff;
	else if (((short) LOW16MASK(usrc)) < 0)
		udst = 0;
	else
		udst = LOW16MASK(usrc);

	if (((short) (HIGH16MASK(usrc) >> 16)) > (short) (0x00ff))
		udst |= 0xff0000;
	else if (((short) (HIGH16MASK(usrc) >> 16)) < 0)
		udst &= 0x0000ffff;
	else
		udst |= HIGH16MASK(usrc);

	regfile_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst);
}

void SC_pac_ex1::pack2_ls_ex1(inst_t * curinst)
{
	/*rd[31:0] = {rs1.l, rs2.l} */
	unsigned int usrc1, usrc2, udst;

	usrc1 = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	usrc2 = regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);
	udst = ((usrc1 << 16) | LOW16MASK(usrc2));

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst);
}

void SC_pac_ex1::unpack2_ls_ex1(inst_t * curinst)
{
	 /**/ unsigned int usrc;
	unsigned long long uldst1, uldst2;

//  unsigned char tmp;

	usrc = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);

	uldst1 = (short) LOW16MASK(usrc);
	uldst2 = (short) (HIGH16MASK(usrc) >> 16);

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, uldst1);
	regfile_l_write(curinst->Rd1_Addr + 1, curinst->Rd1_Type, uldst2);
}

void SC_pac_ex1::unpack2u_ls_ex1(inst_t * curinst)
{
	 /**/ unsigned int usrc;	// , udst1, udst2;
	unsigned long long uldst1, uldst2;

//  unsigned char tmp;

	usrc = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);

	uldst1 = LOW16MASK(usrc);
	uldst2 = HIGH16MASK(usrc) >> 16;

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, uldst1);
	regfile_l_write(curinst->Rd1_Addr + 1, curinst->Rd1_Type, uldst2);
}

void SC_pac_ex1::swap2_ls_ex1(inst_t * curinst)
{
	 /**/ unsigned int udst, usrc;

	usrc = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	udst = ((usrc << 16) | (usrc >> 16));

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst);
}

void SC_pac_ex1::pack4_ls_ex1(inst_t * curinst)
{
	 /**/ unsigned int udst, usrc1, usrc2;

	usrc1 = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	usrc2 = regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	udst = ((BYTE3MASK(usrc1) << 8) |
			(BYTE1MASK(usrc1) << 16) |
			(BYTE3MASK(usrc2) >> 8) | (BYTE1MASK(usrc2)));

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst);
}

void SC_pac_ex1::unpack4_ls_ex1(inst_t * curinst)
{
	 /**/ unsigned int udst1, udst2, usrc;

//  unsigned char tmp;

	usrc = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);

	udst1 = HIGH16MASK((((int) (usrc & 0xFF000000)) >> 8)) |
		LOW16MASK((((int) ((usrc & 0x00FF0000) << 8)) >> 24));
	udst2 = HIGH16MASK((((int) ((usrc & 0x0000FF00) << 16)) >> 8)) |
		LOW16MASK((((int) ((usrc & 0x000000FF) << 24)) >> 24));

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst1);
	regfile_l_write(curinst->Rd1_Addr + 1, curinst->Rd1_Type, udst2);
}

void SC_pac_ex1::unpack4u_ls_ex1(inst_t * curinst)
{
	 /**/ unsigned int udst1, udst2, usrc1;

//  unsigned char tmp;

	usrc1 = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);

	udst1 = ((usrc1 & 0xFF000000) >> 8) | (((usrc1 & 0x00FF0000) << 8) >> 24);
	udst2 =
		(((usrc1 & 0x0000FF00) << 16) >> 8) | (((usrc1 & 0x000000FF) << 24)
											   >> 24);
	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst1);
	regfile_l_write(curinst->Rd1_Addr + 1, curinst->Rd1_Type, udst2);
}

void SC_pac_ex1::swap4_ls_ex1(inst_t * curinst)
{
	 /**/ unsigned int udst, usrc;

	usrc = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	udst = ((usrc & 0x00FF0000) << 8) |
		((usrc & 0xFF000000) >> 8) |
		((usrc & 0x000000FF) << 8) | ((usrc & 0x0000FF00) >> 8);

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst);
}

void SC_pac_ex1::swap4e_ls_ex1(inst_t * curinst)
{
	 /**/ unsigned int udst, usrc;

	usrc = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	udst = ((usrc & 0x000000FF) << 24) |
		((usrc & 0x0000FF00) << 8) |
		((usrc & 0x00FF0000) >> 8) | ((usrc & 0xFF000000) >> 24);

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst);
}

void SC_pac_ex1::copy_fc_ls_ex1(inst_t * curinst)
{
	unsigned char carry;

	if (cluster_idx == 0 || cluster_idx == 2 || cluster_idx == 4)
		carry = psr_read_addc(0, PSR_CA);
	else
		carry = psr_read_addc(1, PSR_CA);

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, carry);
}

void SC_pac_ex1::copy_fv_ls_ex1(inst_t * curinst)
{
	unsigned char overflow;

	if (cluster_idx == 0 || cluster_idx == 2 || cluster_idx == 4)
		overflow = psr_read_addv(0, PSR_OV);
	else
		overflow = psr_read_addv(1, PSR_OV);

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, overflow);
}

void SC_pac_ex1::set_cpi_ls_ex1(inst_t * curinst)
{
	unsigned long long uldst;

	uldst = curinst->Imm32 & 0x7;
	uldst |= (curinst->offset << 3) & 0x18;

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, uldst);
}

void SC_pac_ex1::read_cpi_ls_ex1(inst_t * curinst)
{
	unsigned long long uldst, ulsrc;

	ulsrc = regfile_l_read(curinst->Rs1_Addr, curinst->Rs1_Type);

	uldst = ulsrc;

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, uldst);
}

void SC_pac_ex1::permh2_ls_ex1(inst_t * curinst)
{
	unsigned int udst, usrc1, usrc2;
	unsigned char imm20, imm21;
	unsigned short data[4];

	usrc1 = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	usrc2 = regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);
	imm20 = ((unsigned char) curinst->Imm32) & 0x3;
	imm21 = (((unsigned char) curinst->Imm32) >> 2) & 0x3;

	data[0] = (unsigned short) usrc1;
	data[1] = (unsigned short) (usrc1 >> 16);
	data[2] = (unsigned short) usrc2;
	data[3] = (unsigned short) (usrc2 >> 16);

	udst = data[imm20] | (data[imm21] << 16);

	regfile_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst);
}

void SC_pac_ex1::permh4_ls_ex1(inst_t * curinst)
{
	unsigned int udst1, udst2, usrc1, usrc2;
	unsigned char imm20, imm21, imm22, imm23;
	unsigned short data[4];

//  unsigned char tmp;

	usrc1 = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	usrc2 = regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);
	imm20 = ((unsigned char) curinst->Imm32) & 0x3;
	imm21 = (((unsigned char) curinst->Imm32) >> 2) & 0x3;
	imm22 = (((unsigned char) curinst->Imm32) >> 4) & 0x3;
	imm23 = (((unsigned char) curinst->Imm32) >> 6) & 0x3;

	data[0] = (unsigned short) usrc1;
	data[1] = (unsigned short) (usrc1 >> 16);
	data[2] = (unsigned short) usrc2;
	data[3] = (unsigned short) (usrc2 >> 16);

	udst1 = data[imm20] | (data[imm21] << 16);
	udst2 = data[imm22] | (data[imm23] << 16);

	regfile_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst1);
	regfile_write(curinst->Rd1_Addr + 1, curinst->Rd1_Type, udst2);
}

//////////////////////////////////////////////////////////
// compare instruction
//
void SC_pac_ex1::slt_ls_ex1(inst_t * curinst)
{
	unsigned long long udst, usrc1, usrc2;

	if (curinst->Rs1_Type != Reg_AC)
		usrc1 = (int) regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	else
		usrc1 = regfile_l_read(curinst->Rs1_Addr, curinst->Rs1_Type);

	if (curinst->Rs2_Type != Reg_AC)
		usrc2 = (int) regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);
	else
		usrc2 = regfile_l_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	if (((long long) usrc1) < ((long long) usrc2))
		udst = 1;
	else
		udst = 0;

	if (curinst->Rd1_Type == Reg_P) {
		regfile_l_write(curinst->Rd1_Addr, Reg_P, udst);
		regfile_l_write(curinst->Rd2_Addr, Reg_P, !udst);
	} else {
		regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst);
		regfile_l_write(curinst->Rd2_Addr, curinst->Rd2_Type, udst);
		regfile_l_write(curinst->WB_Data, curinst->WB_Data1, !udst);
	}
}

void SC_pac_ex1::sltu_ls_ex1(inst_t * curinst)
{
	unsigned long long udst, usrc1, usrc2;

	if (curinst->Rs1_Type != Reg_AC)
		usrc1 =
			(unsigned int) regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	else
		usrc1 = regfile_l_read(curinst->Rs1_Addr, curinst->Rs1_Type);

	if (curinst->Rs2_Type != Reg_AC)
		usrc2 =
			(unsigned int) regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);
	else
		usrc2 = regfile_l_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	if (usrc1 < usrc2)
		udst = 1;
	else
		udst = 0;

	if (curinst->Rd1_Type == Reg_P) {
		regfile_l_write(curinst->Rd1_Addr, Reg_P, udst);
		regfile_l_write(curinst->Rd2_Addr, Reg_P, !udst);
	} else {
		regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst);
		regfile_l_write(curinst->Rd2_Addr, curinst->Rd2_Type, udst);
		regfile_l_write(curinst->WB_Data, curinst->WB_Data1, !udst);
	}
}

void SC_pac_ex1::sltll_ls_ex1(inst_t * curinst)
{
	unsigned long long udst, usrc1, usrc2;

	usrc1 = regfile_l_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	usrc2 = regfile_l_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	if ((short) (LOW16MASK(usrc1)) < (short) (LOW16MASK(usrc2)))
		udst = 1;
	else
		udst = 0;

	if (curinst->Rd1_Type == Reg_P) {
		regfile_l_write(curinst->Rd1_Addr, Reg_P, udst);
		regfile_l_write(curinst->Rd2_Addr, Reg_P, !udst);
	} else {
		regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst);
		regfile_l_write(curinst->Rd2_Addr, curinst->Rd2_Type, udst);
		regfile_l_write(curinst->WB_Data, curinst->WB_Data1, !udst);
	}
}

void SC_pac_ex1::slthh_ls_ex1(inst_t * curinst)
{
	unsigned long long udst, usrc1, usrc2;

	usrc1 = regfile_l_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	usrc2 = regfile_l_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	if ((short) (HIGH16MASK(usrc1) >> 16) < (short) (HIGH16MASK(usrc2) >> 16))
		udst = 1;
	else
		udst = 0;

	if (curinst->Rd1_Type == Reg_P) {
		regfile_l_write(curinst->Rd1_Addr, Reg_P, udst);
		regfile_l_write(curinst->Rd2_Addr, Reg_P, !udst);
	} else {
		regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst);
		regfile_l_write(curinst->Rd2_Addr, curinst->Rd2_Type, udst);
		regfile_l_write(curinst->WB_Data, curinst->WB_Data1, !udst);
	}
}

void SC_pac_ex1::sltull_ls_ex1(inst_t * curinst)
{
	unsigned long long udst, usrc1, usrc2;

	usrc1 = regfile_l_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	usrc2 = regfile_l_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	if ((unsigned short) (LOW16MASK(usrc1)) <
		(unsigned short) (LOW16MASK(usrc2)))
		udst = 1;
	else
		udst = 0;

	if (curinst->Rd1_Type == Reg_P) {
		regfile_l_write(curinst->Rd1_Addr, Reg_P, udst);
		regfile_l_write(curinst->Rd2_Addr, Reg_P, !udst);
	} else {
		regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst);
		regfile_l_write(curinst->Rd2_Addr, curinst->Rd2_Type, udst);
		regfile_l_write(curinst->WB_Data, curinst->WB_Data1, !udst);
	}
}

void SC_pac_ex1::sltuhh_ls_ex1(inst_t * curinst)
{
	unsigned long long udst, usrc1, usrc2;

	usrc1 = regfile_l_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	usrc2 = regfile_l_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	if ((unsigned short) (HIGH16MASK(usrc1) >> 16) <
		(unsigned short) (HIGH16MASK(usrc2) >> 16))
		udst = 1;
	else
		udst = 0;

	if (curinst->Rd1_Type == Reg_P) {
		regfile_l_write(curinst->Rd1_Addr, Reg_P, udst);
		regfile_l_write(curinst->Rd2_Addr, Reg_P, !udst);
	} else {
		regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst);
		regfile_l_write(curinst->Rd2_Addr, curinst->Rd2_Type, udst);
		regfile_l_write(curinst->WB_Data, curinst->WB_Data1, !udst);
	}
}

void SC_pac_ex1::slti_ls_ex1(inst_t * curinst)
{
	unsigned long long usrc, udst;

	if (curinst->Rs1_Type != Reg_AC)
		usrc = (int) regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	else
		usrc = regfile_l_read(curinst->Rs1_Addr, curinst->Rs1_Type);

	udst = ((long long) usrc) < ((int) curinst->Imm32) ? 1 : 0;

	if (curinst->Rs2_Addr == (unsigned char) INVALID_REG) {
		regfile_l_write(curinst->Rd1_Addr, Reg_P, udst);
		regfile_l_write(curinst->Rd2_Addr, Reg_P, !udst);
	} else {
		regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst);
		regfile_l_write(curinst->Rd2_Addr, Reg_P, udst);
		regfile_l_write(curinst->Rs2_Addr, Reg_P, !udst);
	}
}

void SC_pac_ex1::sltiu_ls_ex1(inst_t * curinst)
{
	unsigned long long usrc, udst;

	if (curinst->Rs1_Type != Reg_AC)
		usrc =
			(unsigned int) regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	else
		usrc = regfile_l_read(curinst->Rs1_Addr, curinst->Rs1_Type);

	udst =
		((unsigned long long) usrc) < ((unsigned int) curinst->Imm32) ? 1 : 0;

	if (curinst->Rs2_Addr == (unsigned char) INVALID_REG) {
		regfile_l_write(curinst->Rd1_Addr, Reg_P, udst);
		regfile_l_write(curinst->Rd2_Addr, Reg_P, !udst);
	} else {
		regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst);
		regfile_l_write(curinst->Rd2_Addr, Reg_P, udst);
		regfile_l_write(curinst->Rs2_Addr, Reg_P, !udst);
	}
}

void SC_pac_ex1::sgti_ls_ex1(inst_t * curinst)
{
	unsigned long long usrc, udst;

	if (curinst->Rs1_Type != Reg_AC)
		usrc = (int) regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	else
		usrc = regfile_l_read(curinst->Rs1_Addr, curinst->Rs1_Type);

	udst = ((long long) usrc) > ((int) curinst->Imm32) ? 1 : 0;

	if (curinst->Rs2_Addr == (unsigned char) INVALID_REG) {
		regfile_l_write(curinst->Rd1_Addr, Reg_P, udst);
		regfile_l_write(curinst->Rd2_Addr, Reg_P, !udst);
	} else {
		regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst);
		regfile_l_write(curinst->Rd2_Addr, Reg_P, udst);
		regfile_l_write(curinst->Rs2_Addr, Reg_P, !udst);
	}
}

void SC_pac_ex1::sgtiu_ls_ex1(inst_t * curinst)
{
	unsigned long long usrc, udst;

	if (curinst->Rs1_Type != Reg_AC)
		usrc =
			(unsigned int) regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	else
		usrc = regfile_l_read(curinst->Rs1_Addr, curinst->Rs1_Type);

	udst =
		((unsigned long long) usrc) > ((unsigned int) curinst->Imm32) ? 1 : 0;

	if (curinst->Rs2_Addr == (unsigned char) INVALID_REG) {
		regfile_l_write(curinst->Rd1_Addr, Reg_P, udst);
		regfile_l_write(curinst->Rd2_Addr, Reg_P, !udst);
	} else {
		regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst);
		regfile_l_write(curinst->Rd2_Addr, Reg_P, udst);
		regfile_l_write(curinst->Rs2_Addr, Reg_P, !udst);
	}
}

void SC_pac_ex1::seq_ls_ex1(inst_t * curinst)
{
	unsigned long long usrc1, usrc2, udst;

	if (curinst->Rs1_Type != Reg_AC)
		usrc1 = (int) regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	else
		usrc1 = regfile_l_read(curinst->Rs1_Addr, curinst->Rs1_Type);

	if (curinst->Rs2_Type != Reg_AC)
		usrc2 = (int) regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);
	else
		usrc2 = regfile_l_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	udst = (usrc1 == usrc2) ? 1 : 0;

	if (curinst->Rd1_Type == Reg_P) {
		regfile_l_write(curinst->Rd1_Addr, Reg_P, udst);
		regfile_l_write(curinst->Rd2_Addr, Reg_P, !udst);
	} else {
		regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst);
		regfile_l_write(curinst->Rd2_Addr, Reg_P, udst);
		regfile_l_write(curinst->WB_Data, Reg_P, !udst);
	}
}

void SC_pac_ex1::seqll_ls_ex1(inst_t * curinst)
{
	unsigned long long usrc1, usrc2, udst;

	usrc1 = regfile_l_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	usrc2 = regfile_l_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	udst = ((LOW16MASK(usrc1)) == (LOW16MASK(usrc2))) ? 1 : 0;

	if (curinst->Rd1_Type == Reg_P) {
		regfile_l_write(curinst->Rd1_Addr, Reg_P, udst);
		regfile_l_write(curinst->Rd2_Addr, Reg_P, !udst);
	} else {
		regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst);
		regfile_l_write(curinst->Rd2_Addr, Reg_P, udst);
		regfile_l_write(curinst->WB_Data, Reg_P, !udst);
	}
}

void SC_pac_ex1::seqhh_ls_ex1(inst_t * curinst)
{
	unsigned long long usrc1, usrc2, udst;

	usrc1 = regfile_l_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	usrc2 = regfile_l_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	udst = ((HIGH16MASK(usrc1) >> 16) == (HIGH16MASK(usrc2) >> 16)) ? 1 : 0;

	if (curinst->Rd1_Type == Reg_P) {
		regfile_l_write(curinst->Rd1_Addr, Reg_P, udst);
		regfile_l_write(curinst->Rd2_Addr, Reg_P, !udst);
	} else {
		regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst);
		regfile_l_write(curinst->Rd2_Addr, Reg_P, udst);
		regfile_l_write(curinst->WB_Data, Reg_P, !udst);
	}
}

void SC_pac_ex1::seqi_ls_ex1(inst_t * curinst)
{
	unsigned long long usrc1, udst;

	if (curinst->Rs1_Type != Reg_AC)
		usrc1 = (int) regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	else
		usrc1 = regfile_l_read(curinst->Rs1_Addr, curinst->Rs1_Type);

	udst = ((long long) usrc1 == (int) curinst->Imm32) ? 1 : 0;

	if (curinst->Rd1_Type == Reg_P) {
		regfile_l_write(curinst->Rd1_Addr, Reg_P, udst);
		regfile_l_write(curinst->Rd2_Addr, Reg_P, !udst);
	} else {
		regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst);
		regfile_l_write(curinst->Rd2_Addr, Reg_P, udst);
		regfile_l_write(curinst->Rs2_Addr, Reg_P, !udst);
	}
}

//////////////////////////////////////
//min serial
//
#if 1
void SC_pac_ex1::min_ls_ex1(inst_t * curinst)
{
	unsigned long long uldst, ulsrc1, ulsrc2;

	if (curinst->Rs1_Type != Reg_AC)
		ulsrc1 = (int) regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	else
		ulsrc1 = regfile_l_read(curinst->Rs1_Addr, curinst->Rs1_Type);

	if (curinst->Rs2_Type != Reg_AC)
		ulsrc2 = (int) regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);
	else
		ulsrc2 = regfile_l_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	uldst = (((long long) ulsrc1) < ((long long) ulsrc2)) ? ulsrc1 : ulsrc2;

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, uldst);
}

void SC_pac_ex1::minu_ls_ex1(inst_t * curinst)
{
	unsigned long long uldst, ulsrc1, ulsrc2;

	if (curinst->Rs1_Type != Reg_AC)
		ulsrc1 =
			(unsigned int) regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	else
		ulsrc1 = regfile_l_read(curinst->Rs1_Addr, curinst->Rs1_Type);

	if (curinst->Rs2_Type != Reg_AC)
		ulsrc2 =
			(unsigned int) regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);
	else
		ulsrc2 = regfile_l_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	uldst = (ulsrc1 < ulsrc2) ? ulsrc1 : ulsrc2;

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, uldst);
}

void SC_pac_ex1::mind_ls_ex1(inst_t * curinst)
{
	 /**/ unsigned int udst1, udst2, usrc1, usrc2;

	usrc1 = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	usrc2 = regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	udst1 = ((int) HIGH16MASK(usrc1)) < ((int) HIGH16MASK(usrc2)) ?
		HIGH16MASK(usrc1) : HIGH16MASK(usrc2);
	udst2 = ((short) LOW16MASK(usrc1)) < ((short) LOW16MASK(usrc2)) ?
		LOW16MASK(usrc1) : LOW16MASK(usrc2);

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, (udst1 | udst2));
}

void SC_pac_ex1::minud_ls_ex1(inst_t * curinst)
{
	 /**/ unsigned int udst1, udst2, usrc1, usrc2;

	usrc1 = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	usrc2 = regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	udst1 = (HIGH16MASK(usrc1) < HIGH16MASK(usrc2)) ?
		HIGH16MASK(usrc1) : HIGH16MASK(usrc2);
	udst2 = (LOW16MASK(usrc1) < LOW16MASK(usrc2)) ?
		LOW16MASK(usrc1) : LOW16MASK(usrc2);

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, (udst1 | udst2));
}

void SC_pac_ex1::minq_ls_ex1(inst_t * curinst)
{
	 /**/ unsigned int udst1, udst2, udst3, udst4, usrc1, usrc2;

	usrc1 = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	usrc2 = regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	udst1 = ((int) BYTE1MASK(usrc1) << 24) < ((int) BYTE1MASK(usrc2) << 24) ?
		BYTE1MASK(usrc1) : BYTE1MASK(usrc2);
	udst2 =
		((int) (BYTE2MASK(usrc1) << 16)) <
		((int) (BYTE2MASK(usrc2) << 16)) ? BYTE2MASK(usrc1) :
		BYTE2MASK(usrc2);
	udst3 =
		((int) (BYTE3MASK(usrc1) << 8)) <
		((int) (BYTE3MASK(usrc2) << 8)) ? BYTE3MASK(usrc1) : BYTE3MASK(usrc2);
	udst4 =
		((int) (BYTE4MASK(usrc1))) <
		((int) (BYTE4MASK(usrc2))) ? BYTE4MASK(usrc1) : BYTE4MASK(usrc2);

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
					(udst1 | udst2 | udst3 | udst4));
}

void SC_pac_ex1::minuq_ls_ex1(inst_t * curinst)
{
	 /**/ unsigned int udst1, udst2, udst3, udst4, usrc1, usrc2;

	usrc1 = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	usrc2 = regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	udst1 = ((int) BYTE1MASK(usrc1)) < ((int) BYTE1MASK(usrc2)) ?
		BYTE1MASK(usrc1) : BYTE1MASK(usrc2);
	udst2 = ((int) BYTE2MASK(usrc1)) < ((int) BYTE2MASK(usrc2)) ?
		BYTE2MASK(usrc1) : BYTE2MASK(usrc2);
	udst3 = ((int) BYTE3MASK(usrc1)) < ((int) BYTE3MASK(usrc2)) ?
		BYTE3MASK(usrc1) : BYTE3MASK(usrc2);
	udst4 =
		((int) (BYTE4MASK(usrc1) >> 8)) <
		((int) (BYTE4MASK(usrc2) >> 8)) ? BYTE4MASK(usrc1) : BYTE4MASK(usrc2);

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
					(udst1 | udst2 | udst3 | udst4));
}

void SC_pac_ex1::dmin_ls_ex1(inst_t * curinst)
{
	unsigned int udst1, udst2, usrc;

	usrc = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);

	if (((int) HIGH16MASK(usrc)) < ((int) (LOW16MASK(usrc) << 16))) {
		udst1 = ((int) usrc) >> 16;
		udst2 = 0;
	} else {
		udst1 = ((int) (usrc << 16)) >> 16;
		udst2 = 1;
	}

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, (int) udst1);
}

void SC_pac_ex1::dminu_ls_ex1(inst_t * curinst)
{
	unsigned int udst1, udst2, usrc;

	usrc = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);

	if (HIGH16MASK(usrc) < (LOW16MASK(usrc) << 16)) {
		udst1 = usrc >> 16;
		udst2 = 0;
	} else {
		udst1 = LOW16MASK(usrc);
		udst2 = 1;
	}

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst1);
	if (curinst->Rd2_Addr != (unsigned char) INVALID_REG)
		regfile_l_write(curinst->Rd2_Addr, curinst->Rd2_Type, udst2);
}
#else
void SC_pac_ex1::min_ls_ex1(inst_t * curinst)
{
	unsigned long long uldst, ulsrc1, ulsrc2;

	if (curinst->Rs1_Type != Reg_AC)
		ulsrc1 = (int) regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	else
		ulsrc1 = regfile_l_read(curinst->Rs1_Addr, curinst->Rs1_Type);

	if (curinst->Rs2_Type != Reg_AC)
		ulsrc2 = (int) regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);
	else
		ulsrc2 = regfile_l_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	uldst = (((long long) ulsrc1) < ((long long) ulsrc2)) ? ulsrc1 : ulsrc2;

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, uldst);
}

void SC_pac_ex1::minu_ls_ex1(inst_t * curinst)
{
	unsigned long long uldst, ulsrc1, ulsrc2;

	if (curinst->Rs1_Type != Reg_AC)
		ulsrc1 =
			(unsigned int) regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	else
		ulsrc1 = regfile_l_read(curinst->Rs1_Addr, curinst->Rs1_Type);

	if (curinst->Rs2_Type != Reg_AC)
		ulsrc2 =
			(unsigned int) regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);
	else
		ulsrc2 = regfile_l_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	uldst = (ulsrc1 < ulsrc2) ? ulsrc1 : ulsrc2;

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, uldst);
}

void SC_pac_ex1::mind_ls_ex1(inst_t * curinst)
{
	 /**/ unsigned int udst1, udst2, usrc1, usrc2;

	usrc1 = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	usrc2 = regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	udst1 = ((int) HIGH16MASK(usrc1)) < ((int) HIGH16MASK(usrc2)) ?
		HIGH16MASK(usrc1) : HIGH16MASK(usrc2);
	udst2 = ((short) LOW16MASK(usrc1)) < ((short) LOW16MASK(usrc2)) ?
		LOW16MASK(usrc1) : LOW16MASK(usrc2);

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, (udst1 | udst2));
}

void SC_pac_ex1::minud_ls_ex1(inst_t * curinst)
{
	 /**/ unsigned int udst1, udst2, usrc1, usrc2;

	usrc1 = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	usrc2 = regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	udst1 = (HIGH16MASK(usrc1) < HIGH16MASK(usrc2)) ?
		HIGH16MASK(usrc1) : HIGH16MASK(usrc2);
	udst2 = (LOW16MASK(usrc1) < LOW16MASK(usrc2)) ?
		LOW16MASK(usrc1) : LOW16MASK(usrc2);

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, (udst1 | udst2));
}

void SC_pac_ex1::minq_ls_ex1(inst_t * curinst)
{
	 /**/ unsigned int udst1, udst2, udst3, udst4, usrc1, usrc2;

	usrc1 = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	usrc2 = regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	udst1 = ((int) BYTE1MASK(usrc1) << 24) < ((int) BYTE1MASK(usrc2) << 24) ?
		BYTE1MASK(usrc1) : BYTE1MASK(usrc2);
	udst2 =
		((int) (BYTE2MASK(usrc1) << 16)) <
		((int) (BYTE2MASK(usrc2) << 16)) ? BYTE2MASK(usrc1) :
		BYTE2MASK(usrc2);
	udst3 =
		((int) (BYTE3MASK(usrc1) << 8)) <
		((int) (BYTE3MASK(usrc2) << 8)) ? BYTE3MASK(usrc1) : BYTE3MASK(usrc2);
	udst4 =
		((int) (BYTE4MASK(usrc1))) <
		((int) (BYTE4MASK(usrc2))) ? BYTE4MASK(usrc1) : BYTE4MASK(usrc2);

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
					(udst1 | udst2 | udst3 | udst4));
}

void SC_pac_ex1::minuq_ls_ex1(inst_t * curinst)
{
	 /**/ unsigned int udst1, udst2, udst3, udst4, usrc1, usrc2;

	usrc1 = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	usrc2 = regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	udst1 = ((int) BYTE1MASK(usrc1)) < ((int) BYTE1MASK(usrc2)) ?
		BYTE1MASK(usrc1) : BYTE1MASK(usrc2);
	udst2 = ((int) BYTE2MASK(usrc1)) < ((int) BYTE2MASK(usrc2)) ?
		BYTE2MASK(usrc1) : BYTE2MASK(usrc2);
	udst3 = ((int) BYTE3MASK(usrc1)) < ((int) BYTE3MASK(usrc2)) ?
		BYTE3MASK(usrc1) : BYTE3MASK(usrc2);
	udst4 =
		((int) (BYTE4MASK(usrc1) >> 8)) <
		((int) (BYTE4MASK(usrc2) >> 8)) ? BYTE4MASK(usrc1) : BYTE4MASK(usrc2);

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
					(udst1 | udst2 | udst3 | udst4));
}

void SC_pac_ex1::dmin_ls_ex1(inst_t * curinst)
{
	unsigned int udst1, udst2, usrc;

	usrc = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);

	if (((int) HIGH16MASK(usrc)) < ((int) (LOW16MASK(usrc) << 16))) {
		udst1 = ((int) usrc) >> 16;
		udst2 = 0;
	} else {
		udst1 = ((int) (usrc << 16)) >> 16;
		udst2 = 1;
	}

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, (int) udst1);
}

void SC_pac_ex1::dminu_ls_ex1(inst_t * curinst)
{
	unsigned int udst1, udst2, usrc;

	usrc = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);

	if (HIGH16MASK(usrc) < (LOW16MASK(usrc) << 16)) {
		udst1 = usrc >> 16;
		udst2 = 0;
	} else {
		udst1 = LOW16MASK(usrc);
		udst2 = 1;
	}

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst1);
	if (curinst->Rd2_Addr != (unsigned char) INVALID_REG)
		regfile_l_write(curinst->Rd2_Addr, curinst->Rd2_Type, udst2);
}


#endif

//////////////////////////////////////
//max serial
//
void SC_pac_ex1::max_ls_ex1(inst_t * curinst)
{
	unsigned long long uldst, ulsrc1, ulsrc2;

	if (curinst->Rs1_Type != Reg_AC)
		ulsrc1 = (int) regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	else
		ulsrc1 =
			(((long long) regfile_l_read(curinst->Rs1_Addr, curinst->Rs1_Type)
			  << 24)) >> 24;

	if (curinst->Rs2_Type != Reg_AC)
		ulsrc2 = (int) regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);
	else
		ulsrc2 =
			(((long long) regfile_l_read(curinst->Rs2_Addr, curinst->Rs2_Type)
			  << 24)) >> 24;

	uldst = (((long long) ulsrc1) > ((long long) ulsrc2)) ? ulsrc1 : ulsrc2;

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, uldst);
}

void SC_pac_ex1::maxu_ls_ex1(inst_t * curinst)
{
	unsigned long long uldst, ulsrc1, ulsrc2;

	if (curinst->Rs1_Type != Reg_AC)
		ulsrc1 =
			(unsigned int) regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	else
		ulsrc1 = regfile_l_read(curinst->Rs1_Addr, curinst->Rs1_Type);

	if (curinst->Rs2_Type != Reg_AC)
		ulsrc2 =
			(unsigned int) regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);
	else
		ulsrc2 = regfile_l_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	uldst = (ulsrc1 > ulsrc2) ? ulsrc1 : ulsrc2;

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, uldst);
}

void SC_pac_ex1::maxd_ls_ex1(inst_t * curinst)
{
	unsigned int udst1, udst2, usrc1, usrc2;

	usrc1 = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	usrc2 = regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	udst1 = ((int) HIGH16MASK(usrc1)) > ((int) HIGH16MASK(usrc2)) ?
		HIGH16MASK(usrc1) : HIGH16MASK(usrc2);
	udst2 = ((short) LOW16MASK(usrc1)) > ((short) LOW16MASK(usrc2)) ?
		LOW16MASK(usrc1) : LOW16MASK(usrc2);

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, (udst1 | udst2));
}

void SC_pac_ex1::maxud_ls_ex1(inst_t * curinst)
{
	 /**/ unsigned int udst1, udst2, usrc1, usrc2;

	usrc1 = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	usrc2 = regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	udst1 = (HIGH16MASK(usrc1) > HIGH16MASK(usrc2)) ?
		HIGH16MASK(usrc1) : HIGH16MASK(usrc2);
	udst2 = (LOW16MASK(usrc1) > LOW16MASK(usrc2)) ?
		LOW16MASK(usrc1) : LOW16MASK(usrc2);

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, (udst1 | udst2));
}

void SC_pac_ex1::maxq_ls_ex1(inst_t * curinst)
{
	 /**/ unsigned int udst1, udst2, udst3, udst4, usrc1, usrc2;

	usrc1 = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	usrc2 = regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	udst1 =
		((int) (BYTE1MASK(usrc1) << 24)) >
		((int) (BYTE1MASK(usrc2) << 24)) ? BYTE1MASK(usrc1) :
		BYTE1MASK(usrc2);
	udst2 =
		((int) (BYTE2MASK(usrc1) << 16)) >
		((int) (BYTE2MASK(usrc2) << 16)) ? BYTE2MASK(usrc1) :
		BYTE2MASK(usrc2);
	udst3 =
		((int) (BYTE3MASK(usrc1) << 8)) >
		((int) (BYTE3MASK(usrc2) << 8)) ? BYTE3MASK(usrc1) : BYTE3MASK(usrc2);
	udst4 =
		((int) (BYTE4MASK(usrc1))) >
		((int) (BYTE4MASK(usrc2))) ? BYTE4MASK(usrc1) : BYTE4MASK(usrc2);

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
					(udst1 | udst2 | udst3 | udst4));
}

void SC_pac_ex1::maxuq_ls_ex1(inst_t * curinst)
{
	 /**/ unsigned int udst1, udst2, udst3, udst4, usrc1, usrc2;

	usrc1 = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	usrc2 = regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	udst1 = ((int) BYTE1MASK(usrc1)) > ((int) BYTE1MASK(usrc2)) ?
		BYTE1MASK(usrc1) : BYTE1MASK(usrc2);
	udst2 = ((int) BYTE2MASK(usrc1)) > ((int) BYTE2MASK(usrc2)) ?
		BYTE2MASK(usrc1) : BYTE2MASK(usrc2);
	udst3 = ((int) BYTE3MASK(usrc1)) > ((int) BYTE3MASK(usrc2)) ?
		BYTE3MASK(usrc1) : BYTE3MASK(usrc2);
	udst4 =
		((int) (BYTE4MASK(usrc1) >> 8)) >
		((int) (BYTE4MASK(usrc2) >> 8)) ? BYTE4MASK(usrc1) : BYTE4MASK(usrc2);

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
					(udst1 | udst2 | udst3 | udst4));
}

void SC_pac_ex1::dmax_ls_ex1(inst_t * curinst)
{
	unsigned int udst1, udst2, usrc;

	usrc = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);

	if (((int) HIGH16MASK(usrc)) > ((int) (LOW16MASK(usrc) << 16))) {
		udst1 = ((int) usrc) >> 16;
		udst2 = 0;
	} else {
		udst1 = ((int) (usrc << 16)) >> 16;
		udst2 = 1;
	}

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, (int) udst1);
}

void SC_pac_ex1::dmaxu_ls_ex1(inst_t * curinst)
{
	unsigned int udst1, udst2, usrc;

	usrc = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);

	if (HIGH16MASK(usrc) > (LOW16MASK(usrc) << 16)) {
		udst1 = usrc >> 16;
		udst2 = 0;
	} else {
		udst1 = LOW16MASK(usrc);
		udst2 = 1;
	}

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst1);
	if (curinst->Rd2_Addr != (unsigned char) INVALID_REG)
		regfile_l_write(curinst->Rd2_Addr, curinst->Rd2_Type, udst2);
}

//void adds_ls_ex1(inst_t* curinst);
void SC_pac_ex1::add_ls_ex1(inst_t * curinst)
{
	unsigned long long udst, usrc1, usrc2;
	unsigned char psr_idx;

	if (cluster_idx == 1 || cluster_idx == 3)
		psr_idx = 1;
	else
		psr_idx = 0;

	if (psr_read(psr_idx, PSR_SATS)) {
		curinst->op = ADDS;
		adds_ls_ex1(curinst);
		return;
	}

	if (curinst->Rs1_Type != Reg_AC)
		usrc1 = (int) regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	else
		usrc1 = regfile_l_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	if (curinst->Rs2_Type != Reg_AC)
		usrc2 = (int) regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);
	else
		usrc2 = regfile_l_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	udst = (long long) usrc1 + (long long) usrc2;

	// detect carry
	curinst->WB_Data = detect_carry(udst, usrc1, usrc2);
	// detect overflow
	curinst->WB_Data1 = detect_overflow(udst, usrc1, usrc2);

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst);

	psr_write(psr_idx, PSR_CA, curinst->WB_Data);
	psr_write(psr_idx, PSR_OV, curinst->WB_Data1);
}

void SC_pac_ex1::adds_ls_ex1(inst_t * curinst)
{
	unsigned long long udst, usrc1, usrc2;
	unsigned char psr_idx;

	if (cluster_idx == 1 || cluster_idx == 3)
		psr_idx = 1;
	else
		psr_idx = 0;

	if (curinst->Rs1_Type != Reg_AC)
		usrc1 = (int) regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	else
		usrc1 = regfile_l_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	if (curinst->Rs2_Type != Reg_AC)
		usrc2 = (int) regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);
	else
		usrc2 = regfile_l_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	udst = (long long) usrc1 + (long long) usrc2;

	// detect carry
	curinst->WB_Data = detect_carry(udst, usrc1, usrc2);
	// detect overflow
	curinst->WB_Data1 = detect_overflow(udst, usrc1, usrc2);

	if (curinst->WB_Data1 == 1) {
		if ((int) usrc1 < 0)
			udst = (int) 0x80000000;
		else
			udst = 0x7fffffff;
	}
	curinst->WB_Data = 0;
	curinst->WB_Data1 = 0;

	psr_write(psr_idx, PSR_CA, curinst->WB_Data);
	psr_write(psr_idx, PSR_OV, curinst->WB_Data1);

	curinst->WB_Data = udst;
	curinst->WB_Data1 = udst >> 32;
}

void SC_pac_ex1::addu_ls_ex1(inst_t * curinst)
{
	unsigned long long usrc1, usrc2;
	unsigned long long uldst;
	int psr_idx;

	if (cluster_idx == 1 || cluster_idx == 3)
		psr_idx = 1;
	else
		psr_idx = 0;

	if (psr_read(psr_idx, PSR_SATS)) {
		curinst->op = ADDUS;
		addus_ls_ex1(curinst);
		return;
	}

	if (curinst->Rs1_Type != Reg_AC)
		usrc1 =
			(unsigned int) regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	else
		usrc1 = regfile_l_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	if (curinst->Rs2_Type != Reg_AC)
		usrc2 =
			(unsigned int) regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);
	else
		usrc2 = regfile_l_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	uldst = usrc1 + usrc2;

	curinst->WB_Data = detect_carry(uldst, usrc1, usrc2);

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, uldst);

	psr_write(psr_idx, PSR_CA, curinst->WB_Data);
}

void SC_pac_ex1::addus_ls_ex1(inst_t * curinst)
{
	unsigned long long usrc1, usrc2;
	unsigned long long uldst;
	int psr_idx;

	if (curinst->Rs1_Type != Reg_AC)
		usrc1 =
			(unsigned int) regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	else
		usrc1 = regfile_l_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	if (curinst->Rs2_Type != Reg_AC)
		usrc2 =
			(unsigned int) regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);
	else
		usrc2 = regfile_l_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	uldst = usrc1 + usrc2;

	curinst->WB_Data = detect_carry(uldst, usrc1, usrc2);

	if (cluster_idx == 1 || cluster_idx == 3)
		psr_idx = 1;
	else
		psr_idx = 0;

	if (curinst->WB_Data == 1)
		uldst = 0xffffffff;
	curinst->WB_Data = 0;

	psr_write(psr_idx, PSR_CA, curinst->WB_Data);

	curinst->WB_Data = uldst;
	curinst->WB_Data1 = uldst >> 32;
}

void SC_pac_ex1::addd_ls_ex1(inst_t * curinst)
{
	unsigned int udst1, udst2, usrc1, usrc2;
	int psr_idx;

	if (cluster_idx == 1 || cluster_idx == 3)
		psr_idx = 1;
	else
		psr_idx = 0;

	if (psr_read(psr_idx, PSR_SATD)) {
		curinst->op = ADDDS;
		addds_ls_ex1(curinst);
		return;
	}

	usrc1 = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	usrc2 = regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	udst1 = (short) (usrc1 >> 16) + (short) (usrc2 >> 16);
	udst2 = (short) LOW16MASK(usrc1) + (short) LOW16MASK(usrc2);

	// detect overflow
	curinst->WB_Data = detect_overflow16(udst1, udst2, usrc1, usrc2);

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
					(udst1 << 16) | LOW16MASK(udst2));

	psr_write(psr_idx, PSR_OV, curinst->WB_Data);
}

//void addqs_ls_ex1(inst_t* curinst);
void SC_pac_ex1::addq_ls_ex1(inst_t * curinst)
{
	unsigned int udst, usrc1, usrc2, udst1, udst2, udst3, udst4;
	int psr_idx;

	if (cluster_idx == 1 || cluster_idx == 3)
		psr_idx = 1;
	else
		psr_idx = 0;

	if (psr_read(psr_idx, PSR_SATQ)) {
		curinst->op = ADDQS;
		addqs_ls_ex1(curinst);
		return;
	}

	usrc1 = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	usrc2 = regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	udst1 = (char) usrc1 + (char) usrc2;
	udst2 = (char) (usrc1 >> 8) + (char) (usrc2 >> 8);
	udst3 = (char) (usrc1 >> 16) + (char) (usrc2 >> 16);
	udst4 = (char) (usrc1 >> 24) + (char) (usrc2 >> 24);

	// detect overflow
	curinst->WB_Data =
		detect_overflow8(udst1, udst2, udst3, udst4, usrc1, usrc2);

	udst = BYTE4MASK(usrc1) + BYTE4MASK(usrc2) +
		BYTE3MASK(BYTE3MASK(usrc1) + BYTE3MASK(usrc2)) +
		BYTE2MASK(BYTE2MASK(usrc1) + BYTE2MASK(usrc2)) +
		BYTE1MASK(BYTE1MASK(usrc1) + BYTE1MASK(usrc2));

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst);

	psr_write(psr_idx, PSR_OV, curinst->WB_Data);
}

void SC_pac_ex1::addds_ls_ex1(inst_t * curinst)
{
	unsigned int udst1, udst2, usrc1, usrc2;

//  unsigned char tmp;
	int psr_idx;

	usrc1 = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	usrc2 = regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	udst1 = (((int) usrc1) >> 16) + (((int) usrc2) >> 16);
	udst2 = (short) usrc1 + (short) usrc2;

	curinst->WB_Data1 = detect_overflow16(udst1, udst2, usrc1, usrc2);

	// saturation
	if (cluster_idx == 1 || cluster_idx == 3)
		psr_idx = 1;
	else
		psr_idx = 0;

	if ((int) udst1 > 0x7fff)
		udst1 = 0x7fff;
	else if ((int) udst1 < -(0x8000))
		udst1 = 0x8000;

	if ((int) udst2 > 0x7fff)
		udst2 = 0x7fff;
	else if ((int) udst2 < -(0x8000))
		udst2 = 0x8000;

	curinst->WB_Data1 = 0;

	curinst->WB_Data = (udst1 << 16) | LOW16MASK(udst2);

	if (cluster_idx == 1 || cluster_idx == 3)
		psr_write(1, PSR_OV, curinst->WB_Data1);
	else
		psr_write(0, PSR_OV, curinst->WB_Data1);
}

void SC_pac_ex1::addqs_ls_ex1(inst_t * curinst)
{
	unsigned int udst1, udst2, udst3, udst4, usrc1, usrc2;
	int psr_idx;

	usrc1 = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	usrc2 = regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	udst1 = (char) (usrc1 >> 24) + (char) (usrc2 >> 24);
	udst2 = (char) (usrc1 >> 16) + (char) (usrc2 >> 16);
	udst3 = (char) (usrc1 >> 8) + (char) (usrc2 >> 8);
	udst4 = (char) usrc1 + (char) usrc2;

	// detect overflow
	curinst->WB_Data1 = 0;
	curinst->WB_Data1 =
		detect_overflow8(udst4, udst3, udst2, udst1, usrc1, usrc2);

	// saturation
	if (cluster_idx == 1 || cluster_idx == 3)
		psr_idx = 1;
	else
		psr_idx = 0;

	if ((int) udst1 > 0x7f)
		udst1 = 0x7f;
	else if ((int) udst1 < -(0x80))
		udst1 = 0x80;
	else
		udst1 = BYTE1MASK(udst1);

	if ((int) udst2 > 0x7f)
		udst2 = 0x7f;
	else if ((int) udst2 < -(0x80))
		udst2 = 0x80;
	else
		udst2 = BYTE1MASK(udst2);

	if ((int) udst3 > 0x7f)
		udst3 = 0x7f;
	else if ((int) udst3 < -(0x80))
		udst3 = 0x80;
	else
		udst3 = BYTE1MASK(udst3);

	if ((int) udst4 > 0x7f)
		udst4 = 0x7f;
	else if ((int) udst4 < -(0x80))
		udst4 = 0x80;
	else
		udst4 = BYTE1MASK(udst4);

	curinst->WB_Data1 = 0;

	curinst->WB_Data = ((udst1 & 0xFF) << 24) | ((udst2 & 0xFF) << 16) |
		((udst3 & 0xFF) << 8) | (udst4 & 0xFF);

	if (cluster_idx == 1 || cluster_idx == 3)
		psr_write(1, PSR_OV, curinst->WB_Data1);
	else
		psr_write(0, PSR_OV, curinst->WB_Data1);
}

void SC_pac_ex1::addud_ls_ex1(inst_t * curinst)
{
	unsigned int udst1, udst2, usrc1, usrc2;
	int psr_idx;

	if (cluster_idx == 1 || cluster_idx == 3)
		psr_idx = 1;
	else
		psr_idx = 0;

	if (psr_read(psr_idx, PSR_SATD)) {
		curinst->op = ADDUDS;
		adduds_ls_ex1(curinst);
		return;
	}

	usrc1 = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	usrc2 = regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	udst1 = HIGH16MASK(usrc1) + HIGH16MASK(usrc2);
	udst2 = LOW16MASK(LOW16MASK(usrc1) + LOW16MASK(usrc2));

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst1 | udst2);
}

void SC_pac_ex1::adduds_ls_ex1(inst_t * curinst)
{
	unsigned int udst1, udst2, usrc1, usrc2;
	int psr_idx;

	if (cluster_idx == 1 || cluster_idx == 3)
		psr_idx = 1;
	else
		psr_idx = 0;

	usrc1 = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	usrc2 = regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	udst1 = (usrc1 >> 16) + (usrc2 >> 16);
	udst2 = LOW16MASK(usrc1) + LOW16MASK(usrc2);

	if (udst1 > 0xffff)
		udst1 = 0xffff;
	if (udst2 > 0xffff)
		udst2 = 0xffff;

	curinst->WB_Data = (udst1 << 16) | LOW16MASK(udst2);
}

void SC_pac_ex1::adduq_ls_ex1(inst_t * curinst)
{
	unsigned int udst, usrc1, usrc2;
	int psr_idx;

	if (cluster_idx == 1 || cluster_idx == 3)
		psr_idx = 1;
	else
		psr_idx = 0;

	if (psr_read(psr_idx, PSR_SATQ)) {
		curinst->op = ADDUQS;
		adduqs_ls_ex1(curinst);
		return;
	}

	usrc1 = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	usrc2 = regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	udst = BYTE4MASK(usrc1) + BYTE4MASK(usrc2) +
		BYTE3MASK(BYTE3MASK(usrc1) + BYTE3MASK(usrc2)) +
		BYTE2MASK(BYTE2MASK(usrc1) + BYTE2MASK(usrc2)) +
		BYTE1MASK(BYTE1MASK(usrc1) + BYTE1MASK(usrc2));

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst);
}

void SC_pac_ex1::adduqs_ls_ex1(inst_t * curinst)
{
	unsigned int udst1, udst2, udst3, udst4, usrc1, usrc2;
	int psr_idx;

	if (cluster_idx == 1 || cluster_idx == 3)
		psr_idx = 1;
	else
		psr_idx = 0;

	usrc1 = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	usrc2 = regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	udst1 = (unsigned char) (usrc1 >> 24) + (unsigned char) (usrc2 >> 24);
	udst2 = (unsigned char) (usrc1 >> 16) + (unsigned char) (usrc2 >> 16);
	udst3 = (unsigned char) (usrc1 >> 8) + (unsigned char) (usrc2 >> 8);
	udst4 = (unsigned char) (usrc1) + (unsigned char) (usrc2);

	if (udst1 > 0xff)
		udst1 = 0xff;

	if (udst2 > 0xff)
		udst2 = 0xff;

	if (udst3 > 0xff)
		udst3 = 0xff;

	if (udst4 > 0xff)
		udst4 = 0xff;

	curinst->WB_Data = (BYTE1MASK(udst1) << 24) | (BYTE1MASK(udst2) << 16) |
		(BYTE1MASK(udst3) << 8) | BYTE1MASK(udst4);
}

void SC_pac_ex1::addi_ls_ex1(inst_t * curinst)
{
	unsigned long long uldst, ulsrc, imm;
	int psr_idx;

	if (cluster_idx == 1 || cluster_idx == 3)
		psr_idx = 1;
	else
		psr_idx = 0;

	if (psr_read(psr_idx, PSR_SATS)) {
		curinst->op = ADDIS;
		addis_ls_ex1(curinst);
		return;
	}

	if (curinst->Rs1_Type != Reg_AC)
		ulsrc = (int) regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	else
		ulsrc = regfile_l_read(curinst->Rs1_Addr, curinst->Rs1_Type);

	imm = (int) curinst->Imm32;

	uldst = ulsrc + imm;

	// detect overflow
	curinst->WB_Data1 = detect_overflow(uldst, ulsrc, imm);

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, uldst);

	psr_write(psr_idx, PSR_OV, curinst->WB_Data1);
}

void SC_pac_ex1::addis_ls_ex1(inst_t * curinst)
{
	unsigned long long uldst, ulsrc, imm;
	int psr_idx;

	if (cluster_idx == 1 || cluster_idx == 3)
		psr_idx = 1;
	else
		psr_idx = 0;

	if (curinst->Rs1_Type != Reg_AC)
		ulsrc = (int) regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	else
		ulsrc = regfile_l_read(curinst->Rs1_Addr, curinst->Rs1_Type);

	imm = (int) curinst->Imm32;

	uldst = ulsrc + imm;

	// detect overflow
	curinst->WB_Data1 = detect_overflow(uldst, ulsrc, imm);

	if (curinst->WB_Data1 == 1) {
		if ((int) ulsrc < 0)
			uldst = (int) 0x80000000;
		else
			uldst = 0x7fffffff;
	}
	curinst->WB_Data1 = 0;

	psr_write(psr_idx, PSR_OV, curinst->WB_Data1);

	curinst->WB_Data = uldst;
	curinst->WB_Data1 = uldst >> 32;
}

void SC_pac_ex1::addid_ls_ex1(inst_t * curinst)
{
	unsigned int udst1, udst2, usrc;
	int psr_idx;

	if (cluster_idx == 1 || cluster_idx == 3)
		psr_idx = 1;
	else
		psr_idx = 0;

	if (psr_read(psr_idx, PSR_SATD)) {
		curinst->op = ADDIDS;
		addids_ls_ex1(curinst);
		return;
	}

	usrc = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);

	udst1 = ((short) (usrc >> 16) + (short) (curinst->Imm32));
	udst2 = (short) usrc + (short) (curinst->Imm32);

	// detect overflow
	curinst->WB_Data = detect_overflow16(udst1, udst2, usrc,
										 (curinst->Imm32 & 0xFFFF) |
										 ((curinst->
										   Imm32 << 16) & 0xFFFF0000));

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
					(udst1 << 16) | LOW16MASK(udst2));

	psr_write(psr_idx, PSR_OV, curinst->WB_Data);
}

void SC_pac_ex1::addids_ls_ex1(inst_t * curinst)
{
	unsigned int udst1, udst2, usrc;
	int psr_idx;

	usrc = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);

	udst1 = ((short) (usrc >> 16) + (short) curinst->Imm32);
	udst2 = (int) ((short) usrc + (short) curinst->Imm32);

	// detect overflow
	curinst->WB_Data1 = detect_overflow16(udst1, udst2, usrc,
										  (curinst->Imm32 & 0xFFFF) |
										  ((curinst->
											Imm32 << 16) & 0xFFFF0000));

	if (cluster_idx == 1 || cluster_idx == 3)
		psr_idx = 1;
	else
		psr_idx = 0;

	// saturation
	if ((int) udst1 > 0x7fff)
		udst1 = 0x7fff;
	else if ((int) udst1 < -(0x8000))
		udst1 = 0x8000;

	if ((int) udst2 > 0x7fff)
		udst2 = 0x7fff;
	else if ((int) udst2 < -(0x8000))
		udst2 = 0x8000;

	curinst->WB_Data1 = 0;

	curinst->WB_Data = (udst1 << 16) | LOW16MASK(udst2);

	if (cluster_idx == 1 || cluster_idx == 3)
		psr_write(1, PSR_OV, curinst->WB_Data1);
	else
		psr_write(0, PSR_OV, curinst->WB_Data1);
}

void SC_pac_ex1::addiud_ls_ex1(inst_t * curinst)
{
	unsigned int udst1, udst2, usrc;
	int psr_idx;

	if (cluster_idx == 1 || cluster_idx == 3)
		psr_idx = 1;
	else
		psr_idx = 0;

	if (psr_read(psr_idx, PSR_SATD)) {
		curinst->op = ADDIUDS;
		addiuds_ls_ex1(curinst);
		return;
	}

	usrc = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);

	udst1 =
		((unsigned short) (usrc >> 16) + (unsigned short) (curinst->Imm32));
	udst2 = (unsigned short) usrc + (unsigned short) (curinst->Imm32);

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
					(udst1 << 16) | LOW16MASK(udst2));
}

void SC_pac_ex1::addiuds_ls_ex1(inst_t * curinst)
{
	unsigned int udst1, udst2, usrc;

	usrc = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);

	udst1 = (usrc + (((unsigned short) curinst->Imm32) << 16)) >> 16;
	udst2 = (unsigned short) (usrc + (unsigned short) curinst->Imm32);

	// saturation
	if (udst1 > 0xffff)
		udst1 = 0xffff0000;
	else
		udst1 <<= 16;
	if (udst2 > 0xffff)
		udst2 = 0xffff;
	else
		udst2 = udst2;

	curinst->WB_Data = udst1 | udst2;
}

void SC_pac_ex1::sub_ls_ex1(inst_t * curinst)
{
	unsigned long long uldst, ulsrc1, ulsrc2;
	int psr_idx;

	if (cluster_idx == 1 || cluster_idx == 3)
		psr_idx = 1;
	else
		psr_idx = 0;

	if (psr_read(psr_idx, PSR_SATS)) {
		curinst->op = SUBS;
		subs_ls_ex1(curinst);
		return;
	}

	if (curinst->Rs1_Type != Reg_AC)
		ulsrc1 = (int) regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	else
		ulsrc1 = regfile_l_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	if (curinst->Rs2_Type != Reg_AC)
		ulsrc2 = (int) regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);
	else
		ulsrc2 = regfile_l_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	uldst = ((long long) ulsrc1) - ((long long) ulsrc2);

	// detect carry
	curinst->WB_Data = (~detect_carry(uldst, ulsrc1, ulsrc2)) & 0x1;
	// detect overflow
	curinst->WB_Data1 = 0;
	if ((ulsrc2 == 0x80000000) && ((ulsrc1 >> 31) & 0x1) == 0x0)
		curinst->WB_Data1 = 1;

	curinst->WB_Data1 |= detect_overflow_sub(uldst, ulsrc1, ulsrc2);

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, uldst);

	psr_write(psr_idx, PSR_CA, curinst->WB_Data);
	psr_write(psr_idx, PSR_OV, curinst->WB_Data1);
}

void SC_pac_ex1::subs_ls_ex1(inst_t * curinst)
{
	unsigned long long uldst, ulsrc1, ulsrc2;
	int psr_idx;

	if (cluster_idx == 1 || cluster_idx == 3)
		psr_idx = 1;
	else
		psr_idx = 0;

	if (curinst->Rs1_Type != Reg_AC)
		ulsrc1 = (int) regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	else
		ulsrc1 = regfile_l_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	if (curinst->Rs2_Type != Reg_AC)
		ulsrc2 = (int) regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);
	else
		ulsrc2 = regfile_l_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	uldst = ((long long) ulsrc1) - ((long long) ulsrc2);

	// detect carry
	curinst->WB_Data = (~detect_carry(uldst, ulsrc1, ulsrc2)) & 0x1;
	// detect overflow
	curinst->WB_Data1 = 0;
	if ((ulsrc2 == 0x80000000) && ((ulsrc1 >> 31) & 0x1) == 0x0)
		curinst->WB_Data1 = 1;
	curinst->WB_Data1 |= detect_overflow_sub(uldst, ulsrc1, ulsrc2);

	if (curinst->WB_Data1 == 1) {
		if ((int) ulsrc1 < 0x0)
			uldst = (int) 0x80000000;
		else
			uldst = 0x7fffffff;
	}
	curinst->WB_Data1 = 0;
	curinst->WB_Data = 0;

	psr_write(psr_idx, PSR_CA, curinst->WB_Data);
	psr_write(psr_idx, PSR_OV, curinst->WB_Data1);

	curinst->WB_Data = uldst;
	curinst->WB_Data1 = uldst >> 32;
}

void SC_pac_ex1::subd_ls_ex1(inst_t * curinst)
{
	unsigned int udst1, udst2, usrc1, usrc2;
	int psr_idx;

	if (cluster_idx == 1 || cluster_idx == 3)
		psr_idx = 1;
	else
		psr_idx = 0;

	if (psr_read(psr_idx, PSR_SATD)) {
		curinst->op = SUBDS;
		subds_ls_ex1(curinst);
		return;
	}

	usrc1 = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	usrc2 = regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	udst1 = (usrc1 >> 16) + ((~usrc2) >> 16) + 1;
	udst2 = LOW16MASK(usrc1) + LOW16MASK(~usrc2) + 1;

	// detect overflow
	curinst->WB_Data = 0;
	if (((unsigned short) (usrc2) == 0x8000) && (((usrc1 >> 15) & 0x1) == 0))
		curinst->WB_Data = 1;
	if (((unsigned short) (usrc2 >> 16) == 0x8000)
		&& (((usrc1 >> 31) & 0x1) == 0))
		curinst->WB_Data = 1;
	curinst->WB_Data |= detect_overflow16_sub(udst1, udst2, usrc1, usrc2);

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
					(udst1 << 16) | LOW16MASK(udst2));

	psr_write(psr_idx, PSR_OV, curinst->WB_Data);
}

void subqs_ls_ex1(inst_t * curinst);
void SC_pac_ex1::subq_ls_ex1(inst_t * curinst)
{
	unsigned int udst, udst1, udst2, udst3, udst4, usrc1, usrc2;
	int psr_idx;

	if (cluster_idx == 1 || cluster_idx == 3)
		psr_idx = 1;
	else
		psr_idx = 0;

	if (psr_read(psr_idx, PSR_SATQ)) {
		curinst->op = SUBQS;
		subqs_ls_ex1(curinst);
		return;
	}

	usrc1 = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	usrc2 = regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	udst1 = (unsigned char) usrc1 + (unsigned char) (~usrc2) + 1;
	udst2 =
		(unsigned char) (usrc1 >> 8) + (unsigned char) (~(usrc2 >> 8)) + 1;
	udst3 =
		(unsigned char) (usrc1 >> 16) + (unsigned char) (~(usrc2 >> 16)) + 1;
	udst4 =
		(unsigned char) (usrc1 >> 24) + (unsigned char) (~(usrc2 >> 24)) + 1;

	// detect overflow
	curinst->WB_Data = 0;
	if (((unsigned char) (usrc2) == 0x80) && (((usrc1 >> 7) & 0x1) == 0))
		curinst->WB_Data = 1;
	if (((unsigned char) (usrc2 >> 8) == 0x80)
		&& (((usrc1 >> 15) & 0x1) == 0))
		curinst->WB_Data = 1;
	if (((unsigned char) (usrc2 >> 16) == 0x80)
		&& (((usrc1 >> 23) & 0x1) == 0))
		curinst->WB_Data = 1;
	if (((unsigned char) (usrc2 >> 24) == 0x80)
		&& (((usrc1 >> 31) & 0x1) == 0))
		curinst->WB_Data = 1;
	curinst->WB_Data |=
		detect_overflow8_sub(udst1, udst2, udst3, udst4, usrc1, usrc2);

	udst = (udst1 & 0xFF) | ((udst2 & 0xFF) << 8)
		| ((udst3 & 0xFF) << 16) | ((udst4 & 0xFF) << 24);

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst);

	psr_write(psr_idx, PSR_OV, curinst->WB_Data);
}

void SC_pac_ex1::subds_ls_ex1(inst_t * curinst)
{
	unsigned int udst1, udst2, usrc1, usrc2;
	int psr_idx;

	if (cluster_idx == 1 || cluster_idx == 3)
		psr_idx = 1;
	else
		psr_idx = 0;

	usrc1 = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	usrc2 = regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	udst1 = (usrc1 >> 16) + ((~usrc2) >> 16) + 1;
	udst2 = LOW16MASK(usrc1) + LOW16MASK(~usrc2) + 1;

	// detect overflow
	curinst->WB_Data1 = 0;
	if (((unsigned short) (usrc2) == 0x8000) && (((usrc1 >> 15) & 0x1) == 0))
		curinst->WB_Data1 = 1;
	if (((unsigned short) (usrc2 >> 16) == 0x8000)
		&& (((usrc1 >> 31) & 0x1) == 0))
		curinst->WB_Data1 |= 1 << 1;
	curinst->WB_Data1 |= detect_overflow16_sub(udst1, udst2, usrc1, usrc2);

	// saturation
//liqin  if ((curinst->WB_Data1 >> 1) & 0x1 == 1) {
	if (((curinst->WB_Data1 >> 1) & 0x1) == 1) {
		if ((short) udst1 > 0)
			udst1 = 0x8000;
		else
			udst1 = 0x7fff;
	}
//liqin  if ((curinst->WB_Data1 >> 0) & 0x1 == 1) {
	if (((curinst->WB_Data1 >> 0) & 0x1) == 1) {
		if ((short) udst2 > 0)
			udst2 = 0x8000;
		else
			udst2 = 0x7fff;
	}
	curinst->WB_Data1 = 0;

	curinst->WB_Data = (udst1 << 16) | LOW16MASK(udst2);

	psr_write(psr_idx, PSR_OV, curinst->WB_Data1);
}

void SC_pac_ex1::subqs_ls_ex1(inst_t * curinst)
{
	unsigned int udst1, udst2, udst3, udst4, usrc1, usrc2;
	int psr_idx;

	if (cluster_idx == 1 || cluster_idx == 3)
		psr_idx = 1;
	else
		psr_idx = 0;

	usrc1 = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	usrc2 = regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	udst1 =
		SIGN_EXT_POS(((int) usrc1), 0, 24) - SIGN_EXT_POS(((int) usrc2), 0, 24);
	udst2 =
		SIGN_EXT_POS(((int) usrc1), 8, 24) - SIGN_EXT_POS(((int) usrc2), 8, 24);
	udst3 =
		SIGN_EXT_POS(((int) usrc1), 16, 24) - SIGN_EXT_POS(((int) usrc2), 16, 24);
	udst4 =
		SIGN_EXT_POS(((int) usrc1), 24, 24) - SIGN_EXT_POS(((int) usrc2), 24, 24);

	// detect overflow
	curinst->WB_Data1 = 0;
	if (((unsigned char) (usrc2) == 0x80) && (((usrc1 >> 7) & 0x1) == 0))
		curinst->WB_Data1 = 1;
	if (((unsigned char) (usrc2 >> 8) == 0x80)
		&& (((usrc1 >> 15) & 0x1) == 0))
		curinst->WB_Data1 = 1;
	if (((unsigned char) (usrc2 >> 16) == 0x80)
		&& (((usrc1 >> 23) & 0x1) == 0))
		curinst->WB_Data1 = 1;
	if (((unsigned char) (usrc2 >> 24) == 0x80)
		&& (((usrc1 >> 31) & 0x1) == 0))
		curinst->WB_Data1 = 1;
	curinst->WB_Data1 |=
		detect_overflow8_sub(udst4, udst3, udst2, udst1, usrc1, usrc2);
	// saturation
	curinst->WB_Data1 = 0;
	if ((int) udst1 > 0x7f)
		udst1 = 0x7f;
	else if ((int) udst1 < (int) (0xFFFFFF80))
		udst1 = 0x80;
	else
		udst1 &= 0xFF;

	if ((int) udst2 > 0x7f)
		udst2 = 0x7f;
	else if ((int) udst2 < (int) (0xFFFFFF80))
		udst2 = 0x80;
	else
		udst2 &= 0xFF;

	if ((int) udst3 > 0x7f)
		udst3 = 0x7f;
	else if ((int) udst3 < (int) (0xFFFFFF80))
		udst3 = 0x80;
	else
		udst3 &= 0xFF;

	if ((int) udst4 > 0x7f)
		udst4 = 0x7f;
	else if ((int) udst4 < (int) (0xFFFFFF80))
		udst4 = 0x80;
	else
		udst4 &= 0xFF;

	curinst->WB_Data = ((udst1 & 0xFF) << 24) | ((udst2 & 0xFF) << 16) |
		((udst3 & 0xFF) << 8) | (udst4 & 0xFF);

	psr_write(psr_idx, PSR_OV, curinst->WB_Data1);
}

void SC_pac_ex1::subu_ls_ex1(inst_t * curinst)
{
	unsigned long long uldst, ulsrc1, ulsrc2;
	int psr_idx;

	if (cluster_idx == 1 || cluster_idx == 3)
		psr_idx = 1;
	else
		psr_idx = 0;

	if (psr_read(psr_idx, PSR_SATS)) {
		curinst->op = SUBUS;
		subus_ls_ex1(curinst);
		return;
	}

	if (curinst->Rs1_Type != Reg_AC)
		ulsrc1 =
			(unsigned int) regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	else
		ulsrc1 = regfile_l_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	if (curinst->Rs2_Type != Reg_AC)
		ulsrc2 =
			(unsigned int) regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);
	else
		ulsrc2 = regfile_l_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	uldst = ((unsigned long long) ulsrc1) - ((unsigned long long) ulsrc2);

	// detect carry
	curinst->WB_Data = (~detect_carry(uldst, ulsrc1, ulsrc2)) & 0x1;

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, uldst);

	psr_write(psr_idx, PSR_CA, curinst->WB_Data);
}

void SC_pac_ex1::subus_ls_ex1(inst_t * curinst)
{
	unsigned long long uldst, ulsrc1, ulsrc2;
	int psr_idx;

	if (cluster_idx == 1 || cluster_idx == 3)
		psr_idx = 1;
	else
		psr_idx = 0;

	if (curinst->Rs1_Type != Reg_AC)
		ulsrc1 =
			(unsigned int) regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	else
		ulsrc1 = regfile_l_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	if (curinst->Rs2_Type != Reg_AC)
		ulsrc2 =
			(unsigned int) regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);
	else
		ulsrc2 = regfile_l_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	uldst = ((unsigned long long) ulsrc1) - ((unsigned long long) ulsrc2);

	// detect carry
	curinst->WB_Data = (~detect_carry(uldst, ulsrc1, ulsrc2)) & 0x1;

	if (curinst->WB_Data == 0)
		uldst = 0x0;
	curinst->WB_Data = 0;

	psr_write(psr_idx, PSR_CA, curinst->WB_Data);

	curinst->WB_Data = uldst;
	curinst->WB_Data1 = uldst >> 32;
}

void SC_pac_ex1::subud_ls_ex1(inst_t * curinst)
{
	unsigned int udst, usrc1, usrc2;
	int psr_idx;

	if (cluster_idx == 1 || cluster_idx == 3)
		psr_idx = 1;
	else
		psr_idx = 0;

	if (psr_read(psr_idx, PSR_SATD)) {
		curinst->op = SUBUDS;
		subuds_ls_ex1(curinst);
		return;
	}

	usrc1 = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	usrc2 = regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	udst = (HIGH16MASK(usrc1) - HIGH16MASK(usrc2)) +
		LOW16MASK(LOW16MASK(LOW16MASK(usrc1) - LOW16MASK(usrc2)));

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst);
}

void SC_pac_ex1::subuq_ls_ex1(inst_t * curinst)
{
	unsigned int udst, usrc1, usrc2;
	int psr_idx;

	if (cluster_idx == 1 || cluster_idx == 3)
		psr_idx = 1;
	else
		psr_idx = 0;

	if (psr_read(psr_idx, PSR_SATQ)) {
		curinst->op = SUBUQS;
		subuqs_ls_ex1(curinst);
		return;
	}

	usrc1 = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	usrc2 = regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	udst = (BYTE4MASK(usrc1) - BYTE4MASK(usrc2)) +
		BYTE3MASK(BYTE3MASK(usrc1) - BYTE3MASK(usrc2)) +
		BYTE2MASK(BYTE2MASK(usrc1) - BYTE2MASK(usrc2)) +
		BYTE1MASK(BYTE1MASK(usrc1) - BYTE1MASK(usrc2));

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst);
}

void SC_pac_ex1::subuds_ls_ex1(inst_t * curinst)
{
	unsigned int udst1, udst2, usrc1, usrc2;
	int psr_idx;

	usrc1 = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	usrc2 = regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	udst1 = (usrc1 >> 16) + (unsigned short) (~(usrc2 >> 16)) + 1;
	udst2 = LOW16MASK(usrc1) + (unsigned short) (~LOW16MASK(usrc2)) + 1;

	if (cluster_idx == 1 || cluster_idx == 3)
		psr_idx = 1;
	else
		psr_idx = 0;

	if (!(udst1 & 0xFFFF0000) && (usrc2 >> 16) != 0)
		udst1 = 0x0;
	if (!(udst2 & 0xFFFF0000) && (LOW16MASK(usrc2) != 0))
		udst2 = 0x0;

	curinst->WB_Data = (udst1 << 16) | LOW16MASK(udst2);
}

void SC_pac_ex1::subuqs_ls_ex1(inst_t * curinst)
{
	unsigned int udst1, udst2, udst3, udst4, usrc1, usrc2;
	int psr_idx;

	if (cluster_idx == 1 || cluster_idx == 3)
		psr_idx = 1;
	else
		psr_idx = 0;

	usrc1 = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	usrc2 = regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	udst1 =
		(unsigned char) (usrc1 >> 24) + (unsigned char) (~(usrc2 >> 24)) + 1;
	udst2 =
		(unsigned char) (usrc1 >> 16) + (unsigned char) (~(usrc2 >> 16)) + 1;
	udst3 =
		(unsigned char) (usrc1 >> 8) + (unsigned char) (~(usrc2 >> 8)) + 1;
	udst4 = (unsigned char) (usrc1) + (unsigned char) (~(usrc2)) + 1;

	if (!(udst1 & 0xFF00) && BYTE1MASK(usrc2 >> 24) != 0)
		udst1 = 0x0;
	if (!(udst2 & 0xFF00) && BYTE1MASK(usrc2 >> 16) != 0)
		udst2 = 0x0;
	if (!(udst3 & 0xFF00) && BYTE1MASK(usrc2 >> 8) != 0)
		udst3 = 0x0;
	if (!(udst4 & 0xFF00) && BYTE1MASK(usrc2) != 0)
		udst4 = 0x0;

	curinst->WB_Data = (udst1 << 24) | (BYTE1MASK(udst2) << 16) |
		(BYTE1MASK(udst3) << 8) | BYTE1MASK(udst4);
}

void SC_pac_ex1::mergea_ls_ex1(inst_t * curinst)
{
	unsigned int udst, usrc;
	int psr_idx;

	if (cluster_idx == 1 || cluster_idx == 3)
		psr_idx = 1;
	else
		psr_idx = 0;

	usrc = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	udst = (((int) usrc) >> 16) + SIGN_EXT(((int) usrc), 16);

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, (int) udst);

	if (cluster_idx == 1 || cluster_idx == 3) {
		psr_write(1, PSR_OV, 0);
	} else {
		psr_write(0, PSR_OV, 0);
	}
}

void SC_pac_ex1::merges_ls_ex1(inst_t * curinst)
{
	unsigned int udst, usrc;
	int psr_idx;

	if (cluster_idx == 1 || cluster_idx == 3)
		psr_idx = 1;
	else
		psr_idx = 0;

	usrc = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	udst = (((int) usrc) >> 16) - SIGN_EXT(((int) usrc), 16);

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, (int) udst);

	if (cluster_idx == 1 || cluster_idx == 3) {
		psr_write(1, PSR_OV, 0);
	} else {
		psr_write(0, PSR_OV, 0);
	}
}

void SC_pac_ex1::neg_ls_ex1(inst_t * curinst)
{
	unsigned long long udst, usrc;
	int psr_idx;

	if (cluster_idx == 1 || cluster_idx == 3)
		psr_idx = 1;
	else
		psr_idx = 0;

	if (curinst->Rs1_Type != Reg_AC)
		usrc = (int) regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	else
		usrc = regfile_l_read(curinst->Rs1_Addr, curinst->Rs1_Type);

	udst = -((long long) usrc);

	// overflow flag
	if ((usrc & 0xFFFFFFFF) == 0x80000000)
		curinst->WM = 1;
	else
		curinst->WM = 0;

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst);

	if (cluster_idx == 0)
		psr_write(psr_idx, PSR_OV, 0);
	else
		psr_write(psr_idx, PSR_OV, curinst->WM);
}

void SC_pac_ex1::abs_ls_ex1(inst_t * curinst)
{
	unsigned long long udst, usrc;
	int psr_idx;

	if (cluster_idx == 1 || cluster_idx == 3)
		psr_idx = 1;
	else
		psr_idx = 0;

	if (curinst->Rs1_Type != Reg_AC)
		usrc = (int) regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	else
		usrc = regfile_l_read(curinst->Rs1_Addr, curinst->Rs1_Type);

	udst = (((long long) usrc) > 0) ? usrc : -((long long) usrc);

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst);
}

void SC_pac_ex1::absd_ls_ex1(inst_t * curinst)
{
	unsigned int udst1, udst2, usrc;
	int psr_idx;

	if (cluster_idx == 1 || cluster_idx == 3)
		psr_idx = 1;
	else
		psr_idx = 0;

	usrc = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);

	udst1 = SIGN_EXT_POS(((int) usrc), 0, 16);
	udst2 = SIGN_EXT_POS(((int) usrc), 16, 16);
	udst1 = ((int) udst1) > 0 ? udst1 : -udst1;
	udst2 = ((int) udst2) > 0 ? udst2 : -udst2;

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
					(udst1 << 16) | udst2);
}

void SC_pac_ex1::absq_ls_ex1(inst_t * curinst)
{
	unsigned int udst1, udst2, udst3, udst4, usrc;
	int psr_idx;

	if (cluster_idx == 1 || cluster_idx == 3)
		psr_idx = 1;
	else
		psr_idx = 0;

	usrc = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);

	udst1 = SIGN_EXT_POS(((int) usrc), 0, 24);
	udst2 = SIGN_EXT_POS(((int) usrc), 8, 24);
	udst3 = SIGN_EXT_POS(((int) usrc), 16, 24);
	udst4 = SIGN_EXT_POS(((int) usrc), 24, 24);
	udst1 = ((char) udst1) > 0 ? udst1 : -udst1;
	udst2 = ((char) udst2) > 0 ? udst2 : -udst2;
	udst3 = ((char) udst3) > 0 ? udst3 : -udst3;
	udst4 = ((char) udst4) > 0 ? udst4 : -udst4;

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
					((udst1 << 24) | (udst2 << 16) | (udst3 << 8) | udst4));
}

void SC_pac_ex1::addc_ls_ex1(inst_t * curinst)
{
	unsigned long long udst, usrc1, usrc2;
	unsigned char carry;
	int psr_idx;

	if (cluster_idx == 1 || cluster_idx == 3)
		psr_idx = 1;
	else
		psr_idx = 0;

	if (psr_read(psr_idx, PSR_SATS)) {
		curinst->op = ADDCS;
		addcs_ls_ex1(curinst);
		return;
	}

	if (curinst->Rs1_Type != Reg_AC)
		usrc1 = (int) regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	else
		usrc1 = regfile_l_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	if (curinst->Rs2_Type != Reg_AC)
		usrc2 = (int) regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);
	else
		usrc2 = regfile_l_read(curinst->Rs2_Addr, curinst->Rs2_Type);
	carry = psr_read_addc(psr_idx, PSR_CA);

	udst = (long long) usrc1 + (long long) usrc2 + carry;

	// detect carry
	curinst->WB_Data = detect_carry(udst, usrc1, usrc2);
	// dectec overflow
	curinst->WB_Data1 = detect_overflow(udst, usrc1, usrc2);
	if ((carry == 1) &&
		((usrc1 == 0x7FFFFFFF && (int) usrc2 > -1) ||
		 (usrc2 == 0x7FFFFFFF && (int) usrc1 > -1)))
		curinst->WB_Data1 = 1;

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst);

	psr_write(psr_idx, PSR_CA, curinst->WB_Data);
	psr_write(psr_idx, PSR_OV, curinst->WB_Data1);
}

void SC_pac_ex1::addcs_ls_ex1(inst_t * curinst)
{
	unsigned long long udst, usrc1, usrc2;
	unsigned char carry;
	int psr_idx;

	if (cluster_idx == 1 || cluster_idx == 3)
		psr_idx = 1;
	else
		psr_idx = 0;

	if (curinst->Rs1_Type != Reg_AC)
		usrc1 = (int) regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	else
		usrc1 = regfile_l_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	if (curinst->Rs2_Type != Reg_AC)
		usrc2 = (int) regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);
	else
		usrc2 = regfile_l_read(curinst->Rs2_Addr, curinst->Rs2_Type);
	carry = psr_read_addc(psr_idx, PSR_CA);

	udst = (long long) usrc1 + (long long) usrc2 + carry;

	// detect carry
	curinst->WB_Data = detect_carry(udst, usrc1, usrc2 + carry);
	// dectec overflow
	curinst->WB_Data1 = detect_overflow(udst, usrc1, usrc2);
	if ((carry == 1) &&
		((usrc1 == 0x7FFFFFFF && (int) usrc2 > -1) ||
		 (usrc2 == 0x7FFFFFFF && (int) usrc1 > -1)))
		curinst->WB_Data1 = 1;

	if (curinst->WB_Data1 == 1) {
		if ((int) udst < 0)
			udst = 0x7fffffff;
		else
			udst = (int) 0x80000000;
	}
	curinst->WB_Data = 0;
	curinst->WB_Data1 = 0;

	psr_write(psr_idx, PSR_CA, curinst->WB_Data);
	psr_write(psr_idx, PSR_OV, curinst->WB_Data1);

	curinst->WB_Data = udst;
	curinst->WB_Data1 = udst >> 32;
}

void SC_pac_ex1::addcu_ls_ex1(inst_t * curinst)
{
	unsigned long long udst, usrc1, usrc2;
	unsigned char carry;
	int psr_idx;

	if (cluster_idx == 1 || cluster_idx == 3)
		psr_idx = 1;
	else
		psr_idx = 0;

	if (psr_read(psr_idx, PSR_SATS)) {
		curinst->op = ADDCUS;
		addcus_ls_ex1(curinst);
		return;
	}

	if (curinst->Rs1_Type != Reg_AC)
		usrc1 =
			(unsigned int) regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	else
		usrc1 = regfile_l_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	if (curinst->Rs2_Type != Reg_AC)
		usrc2 =
			(unsigned int) regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);
	else
		usrc2 = regfile_l_read(curinst->Rs2_Addr, curinst->Rs2_Type);
	carry = psr_read_addc(psr_idx, PSR_CA);

	udst = usrc1 + usrc2 + carry;

	// detect carry
	curinst->WB_Data = detect_carry(udst, usrc1, usrc2);

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst);

	psr_write(psr_idx, PSR_CA, curinst->WB_Data);
}

void SC_pac_ex1::addcus_ls_ex1(inst_t * curinst)
{
	unsigned long long udst, usrc1, usrc2;
	unsigned char carry;
	int psr_idx;

	if (cluster_idx == 1 || cluster_idx == 3)
		psr_idx = 1;
	else
		psr_idx = 0;

	if (curinst->Rs1_Type != Reg_AC)
		usrc1 =
			(unsigned int) regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	else
		usrc1 = regfile_l_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	if (curinst->Rs2_Type != Reg_AC)
		usrc2 =
			(unsigned int) regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);
	else
		usrc2 = regfile_l_read(curinst->Rs2_Addr, curinst->Rs2_Type);
	carry = psr_read_addc(psr_idx, PSR_CA);

	udst = usrc1 + usrc2 + carry;

	// detect carry
	curinst->WB_Data = detect_carry(udst, usrc1, usrc2);

	if (curinst->WB_Data == 1)
		udst = 0xffffffff;
	curinst->WB_Data = 0;

	psr_write(psr_idx, PSR_CA, curinst->WB_Data);

	curinst->WB_Data = udst;
	curinst->WB_Data1 = udst >> 32;
}

void SC_pac_ex1::and_ls_ex1(inst_t * curinst)
{
	unsigned long long udst, usrc1, usrc2;

	if (curinst->Rs1_Type != Reg_AC)
		usrc1 = (int) regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	else
		usrc1 = regfile_l_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	if (curinst->Rs2_Type != Reg_AC)
		usrc2 = (int) regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);
	else
		usrc2 = regfile_l_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	udst = usrc1 & usrc2;

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst);
}

void SC_pac_ex1::andi_ls_ex1(inst_t * curinst)
{
	unsigned long long udst, usrc1;

	if (curinst->Rs1_Type != Reg_AC)
		usrc1 = (int) regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	else
		usrc1 = regfile_l_read(curinst->Rs1_Addr, curinst->Rs1_Type);

	udst = usrc1 & ((unsigned int) curinst->Imm32);

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst);
}

void SC_pac_ex1::or_ls_ex1(inst_t * curinst)
{
	unsigned long long udst, usrc1, usrc2;

	if (curinst->Rs1_Type != Reg_AC)
		usrc1 = (int) regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	else
		usrc1 = regfile_l_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	if (curinst->Rs2_Type != Reg_AC)
		usrc2 = (int) regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);
	else
		usrc2 = regfile_l_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	udst = usrc1 | usrc2;

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst);
}

void SC_pac_ex1::ori_ls_ex1(inst_t * curinst)
{
	unsigned long long udst, usrc1;

	if (curinst->Rs1_Type != Reg_AC)
		usrc1 = (int) regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	else
		usrc1 = regfile_l_read(curinst->Rs1_Addr, curinst->Rs1_Type);

	udst = usrc1 | ((unsigned int) curinst->Imm32);

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst);
}

void SC_pac_ex1::xor_ls_ex1(inst_t * curinst)
{
	unsigned long long udst, usrc1, usrc2;

	if (curinst->Rs1_Type != Reg_AC)
		usrc1 = (int) regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	else
		usrc1 = regfile_l_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	if (curinst->Rs2_Type != Reg_AC)
		usrc2 = (int) regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);
	else
		usrc2 = regfile_l_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	udst = usrc1 ^ usrc2;

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst);
}

void SC_pac_ex1::xori_ls_ex1(inst_t * curinst)
{
	unsigned long long udst, usrc1;

	if (curinst->Rs1_Type != Reg_AC)
		usrc1 = (int) regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	else
		usrc1 = regfile_l_read(curinst->Rs1_Addr, curinst->Rs1_Type);

	udst = usrc1 ^ ((unsigned int) curinst->Imm32);

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst);
}

void SC_pac_ex1::not_ls_ex1(inst_t * curinst)
{
	unsigned long long udst, usrc;

	if (curinst->Rs1_Type != Reg_AC)
		usrc = (int) regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	else
		usrc = regfile_l_read(curinst->Rs1_Addr, curinst->Rs1_Type);

	udst = ~usrc;

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst);
}

/////////////////////////////////////////////////
//shift by register
//
void SC_pac_ex1::sll_ls_ex1(inst_t * curinst)
{
	unsigned long long udst, usrc1, usrc2;

	if (curinst->Rs1_Type != Reg_AC)
		usrc1 = (int) regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	else
		usrc1 = regfile_l_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	if (curinst->Rs2_Type != Reg_AC)
		usrc2 = (int) regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);
	else
		usrc2 = regfile_l_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	if (cluster_idx == 0)
		udst = usrc1 << (usrc2 & 0x1F);
	else
		udst = usrc1 << (usrc2 & 0x3F);

	// detect carry
	if (cluster_idx == 0 && (usrc2 & 0x1F) == 0)
		curinst->WB_Data = 0;
	else if (cluster_idx != 0 && (usrc2 & 0x3F) == 0)
		curinst->WB_Data = 0;
	else
		curinst->WB_Data = (udst >> 32) & 0x1;
	// detect overflow
	curinst->WB_Data1 = 0;
	if (((usrc1 >> 31) & 0x1) != ((udst >> 31) & 0x1))
		curinst->WB_Data1 = 1;

	if (curinst->Rd1_Type == Reg_AC)
		udst = SIGN_EXT((long long) udst, 24);
	else
		udst = SIGN_EXT((long long) udst, 32);
	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst);

	if (cluster_idx == 1 || cluster_idx == 3) {
		psr_write(1, PSR_CA, curinst->WB_Data);
		psr_write(1, PSR_OV, curinst->WB_Data1);
	} else {
		psr_write(0, PSR_CA, curinst->WB_Data);
		psr_write(0, PSR_OV, curinst->WB_Data1);
	}
}

void SC_pac_ex1::slld_ls_ex1(inst_t * curinst)
{
	unsigned int udst, usrc1, usrc2;
	unsigned int tmp1, tmp2;

//  int i;

	usrc1 = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	usrc2 = regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	if (((usrc2 >> 16) & 0x3F) > 31)
		tmp1 = (usrc1 & 0xFFFF0000) << 31;
	else
		tmp1 = (usrc1 & 0xFFFF0000) << ((usrc2 >> 16) & 0x3F);
	if ((usrc2 & 0x3F) > 31)
		tmp2 = (usrc1 & 0xFFFF) << 31;
	else
		tmp2 = (usrc1 & 0xFFFF) << (usrc2 & 0x3F);

	udst = HIGH16MASK(tmp1) + LOW16MASK(tmp2);

	// detect overflow
	curinst->WB_Data =
		detect_overflow16((udst >> 16) & 0xFFFF, udst & 0xFFFF, usrc1, usrc1);

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst);

	if (cluster_idx == 1 || cluster_idx == 3)
		psr_write(1, PSR_OV, curinst->WB_Data);
	else
		psr_write(0, PSR_OV, curinst->WB_Data);
}

void SC_pac_ex1::srl_ls_ex1(inst_t * curinst)
{
	unsigned long long udst, usrc1, usrc2;

	usrc1 = regfile_l_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	if (curinst->Rs1_Type == Reg_AC)
		usrc1 &= 0x000000FFFFFFFFFFLL;	// Added "LL" by dengyong 2007/12/14
	else
		usrc1 &= 0x00000000FFFFFFFFLL;	// Added "LL" by dengyong 2007/12/14
	usrc2 = regfile_l_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	if (cluster_idx == 0)
		udst = usrc1 >> (usrc2 & 0x1F);
	else
		udst = usrc1 >> (usrc2 & 0x3F);

	if (curinst->Rd1_Type != Reg_AC)
		udst = SIGN_EXT((long long) udst, 32);
	else
		udst = SIGN_EXT((long long) udst, 24);
	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst);

	if (cluster_idx == 1 || cluster_idx == 3)
		psr_write(1, PSR_CA, 0);
	else
		psr_write(0, PSR_CA, 0);
}

void SC_pac_ex1::srld_ls_ex1(inst_t * curinst)
{
	unsigned long long udst, usrc1, usrc2;

	usrc1 = (unsigned int) regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	usrc2 = (unsigned int) regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	udst = (HIGH16MASK(usrc1 >> ((usrc2 >> 16) & 0x3F))) +
		(LOW16MASK(usrc1) >> (usrc2 & 0x3F));

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst);
}

void SC_pac_ex1::sra_ls_ex1(inst_t * curinst)
{
	unsigned long long udst, usrc1, usrc2;

	if (curinst->Rs1_Type != Reg_AC)
		usrc1 = (int) regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	else
		usrc1 = regfile_l_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	if (curinst->Rs2_Type != Reg_AC)
		usrc2 = (int) regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);
	else
		usrc2 = regfile_l_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	if (cluster_idx == 0)
		udst = ((long long) usrc1) >> (usrc2 & 0x1F);
	else
		udst = SIGN_EXT((long long) usrc1, 24) >> (usrc2 & 0x3F);

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst);

	if (cluster_idx == 1 || cluster_idx == 3)
		psr_write(1, PSR_OV, 0);
	else
		psr_write(0, PSR_OV, 0);
}

void SC_pac_ex1::srad_ls_ex1(inst_t * curinst)
{
	unsigned int udst, usrc1, usrc2;
	unsigned long long utmp1, utmp2;

	usrc1 = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	usrc2 = regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	utmp1 = (int) HIGH16MASK(usrc1);
	utmp2 = (short) usrc1;

	utmp1 = (long long) utmp1 >> ((usrc2 >> 16) & 0x3F);
	utmp2 = (long long) utmp2 >> (usrc2 & 0x3F);

	udst = HIGH16MASK(utmp1) + LOW16MASK(utmp2);

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst);

	if (cluster_idx == 1 || cluster_idx == 3)
		psr_write(1, PSR_OV, 0);
	else
		psr_write(0, PSR_OV, 0);
}

///////////////////////////////////////////
//shift by imm
//
void SC_pac_ex1::slli_ls_ex1(inst_t * curinst)
{
	unsigned long long udst, usrc;

	if (curinst->Rs1_Type != Reg_AC)
		usrc = (int) regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	else
		usrc = regfile_l_read(curinst->Rs1_Addr, curinst->Rs1_Type);

	udst = usrc << (curinst->Imm32 & 0x3F);

	// detect carry
	if (curinst->Imm32 == 0)
		curinst->WB_Data = 0;
	else
		curinst->WB_Data = (udst >> 32) & 0x1;
	// detect overflow
	curinst->WB_Data1 = 0;
	if (((udst >> 31) & 0x1) != ((usrc >> 31) & 0x1))
		curinst->WB_Data1 = 1;

	if (curinst->Rd1_Type == Reg_AC)
		udst = SIGN_EXT((long long) udst, 24);
	else
		udst = SIGN_EXT((long long) udst, 32);
	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst);

	if (cluster_idx == 1 || cluster_idx == 3) {
		psr_write(1, PSR_CA, curinst->WB_Data);
		psr_write(1, PSR_OV, curinst->WB_Data1);
	} else {
		psr_write(0, PSR_CA, curinst->WB_Data);
		psr_write(0, PSR_OV, curinst->WB_Data1);
	}
}

void SC_pac_ex1::sllid_ls_ex1(inst_t * curinst)
{
	unsigned int udst, usrc;

	usrc = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);

	if ((curinst->Imm32 & 0x3F) > 31) {
		udst =
			(HIGH16MASK(usrc) << 31) +
			LOW16MASK(SIGN_EXT(((int) usrc), 16) << 31);
	} else {
		udst = (HIGH16MASK(usrc) << (curinst->Imm32 & 0x3F)) +
			LOW16MASK(SIGN_EXT(((int) usrc), 16) << (curinst->Imm32 & 0x3F));
	}

	curinst->WB_Data =
		detect_overflow16((udst >> 16) & 0xFFFF, udst & 0xFFFF, usrc, usrc);

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst);

	if (cluster_idx == 1 || cluster_idx == 3) {
		psr_write(1, PSR_OV, curinst->WB_Data);
	} else {
		psr_write(0, PSR_OV, curinst->WB_Data);
	}
}

void SC_pac_ex1::srli_ls_ex1(inst_t * curinst)
{
	unsigned long long udst, usrc;

	usrc = regfile_l_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	if (curinst->Rs1_Type == Reg_AC)
		usrc &= 0x000000FFFFFFFFFFLL;	// Added "LL" by dengyong 2007/12/14
	else
		usrc &= 0x00000000FFFFFFFFLL;	// Added "LL" by dengyong 2007/12/14

	udst = usrc >> (curinst->Imm32 & 0x3F);

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst);

	if (cluster_idx == 1 || cluster_idx == 3)
		psr_write(1, PSR_CA, 0);
	else
		psr_write(0, PSR_CA, 0);

}

void SC_pac_ex1::srlid_ls_ex1(inst_t * curinst)
{
	unsigned int udst, usrc;

	usrc = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);

	udst = HIGH16MASK(usrc >> (curinst->Imm32 & 0x3F)) +
		LOW16MASK(LOW16MASK(usrc) >> (curinst->Imm32 & 0x3F));

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst);
}

void SC_pac_ex1::srai_ls_ex1(inst_t * curinst)
{
	unsigned long long udst, usrc;

	if (curinst->Rs1_Type != Reg_AC)
		usrc = (int) regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	else
		usrc = regfile_l_read(curinst->Rs1_Addr, curinst->Rs1_Type);

	udst = ((long long) usrc) >> (curinst->Imm32 & 0x3F);

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst);

	if (cluster_idx == 1 || cluster_idx == 3)
		psr_write(1, PSR_OV, 0);
	else
		psr_write(0, PSR_OV, 0);
}

void SC_pac_ex1::sraid_ls_ex1(inst_t * curinst)
{
	unsigned int udst, usrc;

	usrc = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);

	udst = HIGH16MASK(((int) usrc) >> (curinst->Imm32 & 0x3F)) +
		LOW16MASK(SIGN_EXT(((int) usrc), 16) >> (curinst->Imm32 & 0x3F));

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst);

	if (cluster_idx == 1 || cluster_idx == 3)
		psr_write(1, PSR_OV, 0);
	else
		psr_write(0, PSR_OV, 0);
}

void SC_pac_ex1::extract_ls_ex1(inst_t * curinst)
{
	unsigned long long udst, usrc1, usrc2;
	unsigned short width, offset;

	usrc1 = regfile_l_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	if (curinst->Rs2_Addr != (unsigned char) INVALID_REG) {
		usrc2 = regfile_l_read(curinst->Rs2_Addr, curinst->Rs2_Type);
		offset = LOW16MASK(usrc2);
		width = usrc2 >> 16;
	} else {
		offset = curinst->Imm32;
		width = curinst->offset;
	}

	if (width == 0)
		udst = 0;
	else {
		if (curinst->Rs1_Type != Reg_AC) {
			if (offset + width > 31)
				udst = ((long long) ((int) usrc1)) >> offset;
			else
				udst =
					((int) (usrc1 << (32 - offset - width))) >> (32 - width);
		} else {
			if (offset + width > 39)
				udst = ((long long) (usrc1 << 24)) >> (offset + 24);
			else
				udst =
					((long long) (usrc1 << (24 + 40 - offset - width))) >> (64
																			-
																			width);
		}
	}

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst);
}

void SC_pac_ex1::extractu_ls_ex1(inst_t * curinst)
{
	unsigned long long udst, usrc1, usrc2;
	unsigned short width, offset;

	if (curinst->Rs1_Type != Reg_AC)
		usrc1 =
			(unsigned int) regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	else
		usrc1 = regfile_l_read(curinst->Rs1_Addr, curinst->Rs1_Type);

	if (curinst->Rs2_Addr != (unsigned char) INVALID_REG) {
		usrc2 = regfile_l_read(curinst->Rs2_Addr, curinst->Rs2_Type);
		offset = LOW16MASK(usrc2);
		width = usrc2 >> 16;
	} else {
		offset = curinst->Imm32;
		width = curinst->offset;
	}

	if (width == 0)
		udst = 0;
	else
		udst = (usrc1 << (64 - offset - width)) >> (64 - width);

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst);
}

void SC_pac_ex1::insert_ls_ex1(inst_t * curinst)
{
	unsigned long long udst, usrc1, usrc2;
	unsigned char offset6h, offset6l;

	if (curinst->Rs1_Type != Reg_AC)
		usrc1 = (int) regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	else
		usrc1 = regfile_l_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	if (curinst->Rd1_Type != Reg_AC)
		udst = (int) regfile_read(curinst->Rd1_Addr, curinst->Rd1_Type);
	else
		udst = regfile_l_read(curinst->Rd1_Addr, curinst->Rd1_Type);
	if (curinst->Rs2_Addr != (unsigned char) INVALID_REG) {
		usrc2 = regfile_l_read(curinst->Rs2_Addr, curinst->Rs2_Type);
		offset6l = LOW16MASK(usrc2);
		offset6h = usrc2 >> 16;
	} else {
		offset6l = (unsigned char) curinst->Imm32;
		offset6h = (unsigned char) curinst->offset;
	}

	usrc1 = (usrc1 & MASK_GEN64(63 - (offset6h - 1), 0)) << offset6l;
	udst =
		(udst & (~MASK_GEN64(63 - (offset6h + offset6l - 1), offset6l))) |
		usrc1;

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst);
}

void SC_pac_ex1::rol_ls_ex1(inst_t * curinst)
{
	unsigned long long udst, usrc;
	unsigned char carry;
	int psr_idx;

	if (cluster_idx == 1 || cluster_idx == 3)
		psr_idx = 1;
	else
		psr_idx = 0;

	if (curinst->Rs1_Type != Reg_AC)
		usrc = (int) regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	else
		usrc = regfile_l_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	carry = psr_read_addc(psr_idx, PSR_CA);

	curinst->WB_Data = (usrc >> 31) & 0x1;

	if (carry == 0)
		udst = (usrc << 1) & 0xFFFFFFFE;
	else
//liqin    udst = (usrc << 1) & 0xFFFFFFFE | 0x1;
		udst = ((usrc << 1) & 0xFFFFFFFE) | 0x1;

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst);

	psr_write(psr_idx, PSR_CA, curinst->WB_Data);
}

void SC_pac_ex1::ror_ls_ex1(inst_t * curinst)
{
	unsigned long long udst, usrc;
	unsigned char carry;
	int psr_idx;

	if (cluster_idx == 1 || cluster_idx == 3)
		psr_idx = 1;
	else
		psr_idx = 0;

	usrc = regfile_l_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	carry = psr_read_addc(psr_idx, PSR_CA);

	curinst->WB_Data = usrc & 0x1;

	if (carry == 0)
		udst = (usrc >> 1) & 0x7FFFFFFF;
	else
		udst = (usrc >> 1) | 0x80000000;

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
					(unsigned int) udst);

	psr_write(psr_idx, PSR_CA, curinst->WB_Data);
}

void SC_pac_ex1::andp_ls_ex1(inst_t * curinst)
{
	unsigned int udst, usrc1, usrc2;

	usrc1 = regfile_read(curinst->Rs1_Addr, Reg_P);
	usrc2 = regfile_read(curinst->Rs2_Addr, Reg_P);
	udst = usrc1 & usrc2;
	regfile_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst);
}

void SC_pac_ex1::orp_ls_ex1(inst_t * curinst)
{
	unsigned int udst, usrc1, usrc2;

	usrc1 = regfile_read(curinst->Rs1_Addr, Reg_P);
	usrc2 = regfile_read(curinst->Rs2_Addr, Reg_P);
	udst = usrc1 | usrc2;
	regfile_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst);
}

void SC_pac_ex1::xorp_ls_ex1(inst_t * curinst)
{
	unsigned int udst, usrc1, usrc2;

	usrc1 = regfile_read(curinst->Rs1_Addr, Reg_P);
	usrc2 = regfile_read(curinst->Rs2_Addr, Reg_P);
	udst = usrc1 ^ usrc2;
	regfile_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst);
}

void SC_pac_ex1::notp_ls_ex1(inst_t * curinst)
{
	unsigned int udst, usrc;

	usrc = regfile_read(curinst->Rs1_Addr, Reg_P);
	udst = usrc > 0 ? 0 : 1;
	regfile_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst);
}

/////////////////////////////////////////////
// Load/Store                              //
/////////////////////////////////////////////

/*load word*/
void SC_pac_ex1::lw_ls_ex1(inst_t * curinst)
{
//  int i;
	unsigned int ret;

	ret = ls_addr_gen(curinst);

	if ((curinst->op != LNW) && ((curinst->Memory_Addr & 0x3) != 0x0)) {
		LS_PRINT_ERR("LW", (unsigned int) EX1_PC,
					 (unsigned int) curinst->Memory_Addr);
		//exit(-1);
	}

	if (curinst->op != LNW || ret == 0)
		curinst->WB_Data = 0;
	else
		curinst->WB_Data = ret;
}

void SC_pac_ex1::lw_sc_ex1(inst_t * curinst)
{
	sc_addr_gen(curinst);

	if ((curinst->op != LNW) && ((curinst->Memory_Addr & 0x3) != 0x0)) {
		LS_PRINT_ERR("LW", (unsigned int) EX1_PC,
					 (unsigned int) curinst->Memory_Addr);
		//exit(-1);
	}
}

void SC_pac_ex1::lwu_ls_ex1(inst_t * curinst)
{
	ls_addr_gen(curinst);

	if ((curinst->op != LNW) && ((curinst->Memory_Addr & 0x3) != 0x0)) {
		LS_PRINT_ERR("LW", (unsigned int) EX1_PC,
					 (unsigned int) curinst->Memory_Addr);
		//exit(-1);
	}
}

void SC_pac_ex1::dlw_ls_ex1(inst_t * curinst)
{
	unsigned int ret;

	ret = ls_addr_gen(curinst);

	if ((curinst->op != DLNW) && ((curinst->Memory_Addr & 0x7) != 0x0)) {
		LS_PRINT_ERR("DLW", (unsigned int) EX1_PC,
					 (unsigned int) curinst->Memory_Addr);
		//exit(-1);
	}

	if (curinst->op != DLNW || ret == 0)
		curinst->WB_Data = 0;
	else
		curinst->WB_Data = ret;
}

void SC_pac_ex1::dlwu_ls_ex1(inst_t * curinst)
{
	ls_addr_gen(curinst);

	if ((curinst->op != DLNW) && ((curinst->Memory_Addr & 0x7) != 0x0)) {
		LS_PRINT_ERR("LW", (unsigned int) EX1_PC,
					 (unsigned int) curinst->Memory_Addr);
		//exit(-1);
	}
}

/*load half word*/
void SC_pac_ex1::lh_ls_ex1(inst_t * curinst)
{
	ls_addr_gen(curinst);

	if ((curinst->Memory_Addr & 0x1) != 0x0) {
		LS_PRINT_ERR("LH", (unsigned int) EX1_PC,
					 (unsigned int) curinst->Memory_Addr);
		//exit(-1);
	}
}

void SC_pac_ex1::lh_sc_ex1(inst_t * curinst)
{
	sc_addr_gen(curinst);

	if ((curinst->Memory_Addr & 0x1) != 0x0) {
		LS_PRINT_ERR("LH", (unsigned int) EX1_PC,
					 (unsigned int) curinst->Memory_Addr);
		//exit(-1);
	}
}

void SC_pac_ex1::lhu_ls_ex1(inst_t * curinst)
{
	ls_addr_gen(curinst);

	if ((curinst->Memory_Addr & 0x1) != 0x0) {
		LS_PRINT_ERR("LH", (unsigned int) EX1_PC,
					 (unsigned int) curinst->Memory_Addr);
		//exit(-1);
	}
}

void SC_pac_ex1::lhu_sc_ex1(inst_t * curinst)
{
	sc_addr_gen(curinst);

	if ((curinst->Memory_Addr & 0x1) != 0x0) {
		LS_PRINT_ERR("LH", (unsigned int) EX1_PC,
					 (unsigned int) curinst->Memory_Addr);
		//exit(-1);
	}
}

void SC_pac_ex1::dlh_ls_ex1(inst_t * curinst)
{
	ls_addr_gen(curinst);
}

void SC_pac_ex1::dlhu_ls_ex1(inst_t * curinst)
{
	ls_addr_gen(curinst);
}

/*load byte*/
void SC_pac_ex1::lb_ls_ex1(inst_t * curinst)
{
	ls_addr_gen(curinst);
}

void SC_pac_ex1::lb_sc_ex1(inst_t * curinst)
{
	sc_addr_gen(curinst);
}

void SC_pac_ex1::lbu_ls_ex1(inst_t * curinst)
{
	ls_addr_gen(curinst);
}

void SC_pac_ex1::lbu_sc_ex1(inst_t * curinst)
{
	sc_addr_gen(curinst);
}

////////////////////////////////////////////////////
//Store
//
//read data in ex1
void SC_pac_ex1::sw_ls_ex1(inst_t * curinst)
{
	int i;
	unsigned int ret;

	if (curinst->Rd1_Type != Reg_PSR) {
		curinst->WB_Data = regfile_read(curinst->Rd1_Addr, curinst->Rd1_Type);
	} else {
		curinst->WB_Data = 0;
		for (i = 6; i > -1; i--) {
			curinst->WB_Data <<= 1;
			if (psr_read(curinst->Rd1_Addr, i))
				curinst->WB_Data |= 0x1;
			else
				curinst->WB_Data &= 0xFE;
		}
	}

	ret = ls_addr_gen(curinst);

	if ((curinst->op != SNW) && ((curinst->Memory_Addr & 0x3) != 0x0)) {
		LS_PRINT_ERR("SW", (unsigned int) EX1_PC,
					 (unsigned int) curinst->Memory_Addr);
		//exit(-1);
	}

	if (curinst->op != SNW || ret == 0) {
		curinst->WM = curinst->WV = 0;
	} else {
		curinst->WM = ret >> 16;
		curinst->WV = ret;
	}
}

void SC_pac_ex1::sw_sc_ex1(inst_t * curinst)
{
	curinst->WB_Data = regfile_read(curinst->Rd1_Addr, curinst->Rd1_Type);
	sc_addr_gen(curinst);

	if ((curinst->op != SNW) && ((curinst->Memory_Addr & 0x3) != 0x0)) {
		LS_PRINT_ERR("SW", (unsigned int) EX1_PC,
					 (unsigned int) curinst->Memory_Addr);
		//exit(-1);
	}
}

void SC_pac_ex1::dsw_ls_ex1(inst_t * curinst)
{
	unsigned int ret;

	curinst->WB_Data = regfile_read(curinst->Rd1_Addr, curinst->Rd1_Type);
	curinst->WB_Data1 = regfile_read(curinst->Rd2_Addr, curinst->Rd2_Type);

	ret = ls_addr_gen(curinst);

	if ((curinst->op != DSNW) && ((curinst->Memory_Addr & 0x7) != 0x0)) {
		LS_PRINT_ERR("DSW", (unsigned int) EX1_PC,
					 (unsigned int) curinst->Memory_Addr);
		//exit(-1);
	}

	if (curinst->op != DSNW || ret == 0) {
		curinst->WM = curinst->WV = 0;
	} else {
		curinst->WM = ret >> 16;
		curinst->WV = ret;
	}
}

void SC_pac_ex1::sh_ls_ex1(inst_t * curinst)
{
	int i;

	if (curinst->Rd1_Type != Reg_PSR) {
		curinst->WB_Data =
			LOW16MASK(regfile_read(curinst->Rd1_Addr, curinst->Rd1_Type));
	} else {
		curinst->WB_Data = 0;
		for (i = 6; i > -1; i--) {
			curinst->WB_Data <<= 1;
			if (psr_read(curinst->Rd1_Addr, i))
				curinst->WB_Data |= 0x1;
			else
				curinst->WB_Data &= 0xFE;
		}
	}
	ls_addr_gen(curinst);

	if ((curinst->Memory_Addr & 0x1) != 0x0) {
		LS_PRINT_ERR("SH", (unsigned int) EX1_PC,
					 (unsigned int) curinst->Memory_Addr);
		//exit(-1);
	}
}

void SC_pac_ex1::sh_sc_ex1(inst_t * curinst)
{
	curinst->WB_Data =
		LOW16MASK(regfile_read(curinst->Rd1_Addr, curinst->Rd1_Type));
	sc_addr_gen(curinst);

	if ((curinst->Memory_Addr & 0x1) != 0x0) {
		LS_PRINT_ERR("SH", (unsigned int) EX1_PC,
					 (unsigned int) curinst->Memory_Addr);
		//exit(-1);
	}
}

void SC_pac_ex1::dsh_ls_ex1(inst_t * curinst)
{
	curinst->WB_Data =
		LOW16MASK(regfile_read(curinst->Rd1_Addr, curinst->Rd1_Type));
	curinst->WB_Data1 =
		LOW16MASK(regfile_read(curinst->Rd2_Addr, curinst->Rd2_Type));
	ls_addr_gen(curinst);
}

void SC_pac_ex1::sb_ls_ex1(inst_t * curinst)
{
	int i;

	if (curinst->Rd1_Type != Reg_PSR) {
		curinst->WB_Data =
			BYTE1MASK(regfile_read(curinst->Rd1_Addr, curinst->Rd1_Type));
	} else {
		curinst->WB_Data = 0;
		for (i = 6; i > -1; i--) {
			curinst->WB_Data <<= 1;
			if (psr_read(curinst->Rd1_Addr, i))
				curinst->WB_Data |= 0x1;
			else
				curinst->WB_Data &= 0xFE;
		}
	}
	ls_addr_gen(curinst);
}

void SC_pac_ex1::sb_sc_ex1(inst_t * curinst)
{
	curinst->WB_Data =
		BYTE1MASK(regfile_read(curinst->Rd1_Addr, curinst->Rd1_Type));
	sc_addr_gen(curinst);
}

void SC_pac_ex1::dsb_ls_ex1(inst_t * curinst)
{
	curinst->WB_Data =
		BYTE1MASK(regfile_read(curinst->Rd1_Addr, curinst->Rd1_Type));
	curinst->WB_Data1 =
		BYTE1MASK(regfile_read(curinst->Rd2_Addr, curinst->Rd2_Type));
	ls_addr_gen(curinst);
}

void SC_pac_ex1::bdr_ls_ex1(inst_t * curinst)
{
//  int tmp;

	if (regTBDT == 0) {
		if (regTBDR1 == 0) {
			regT1Type = ((curinst->Rd1_Addr << 16) | curinst->Rd1_Type);
			regTBDR1 = cluster_idx + 1;
		} else {
			regT2Type = ((curinst->Rd1_Addr << 16) | curinst->Rd1_Type);
			regTBDR2 = cluster_idx + 1;
		}
	}
}

void SC_pac_ex1::dbdr_ls_ex1(inst_t * curinst)
{
//  unsigned char tmp;

	if (regTBDT == 0) {
		if (regTBDR1 == 0) {
			regT1Type = ((curinst->Rd1_Addr << 16) | curinst->Rd1_Type);
			regTBDR1 = cluster_idx + 1;
		} else {
			regT2Type = ((curinst->Rd1_Addr << 16) | curinst->Rd1_Type);
			regTBDR2 = cluster_idx + 1;
		}
	}
}

void SC_pac_ex1::bdt_ls_ex1(inst_t * curinst)
{
	regT1 = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	curinst->WB_Data = regT1;
	regTBDT = cluster_idx + 1;
	regTBDR1 = 0;
	regTBDR2 = 0;
}

void SC_pac_ex1::dbdt_ls_ex1(inst_t * curinst)
{
	regT1 = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	regT2 = regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);
	curinst->WB_Data = regT1;
	curinst->WB_Data1 = regT2;
	regTBDT = cluster_idx + 1;

	regTBDR1 = 0;
	regTBDR2 = 0;
}

void SC_pac_ex1::dex_ls_ex1(inst_t * curinst)
{
	unsigned int usrc;
	int tmp;

	usrc = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	curinst->WB_Data = usrc;
	if (regTFlag == 0) {
		regT1 = usrc;
		regT1Type = ((curinst->Rd1_Addr << 16) | curinst->Rd1_Type);
		regTFlag = cluster_idx + 1;
	} else {
		tmp = cluster_idx;
		cluster_idx = regTFlag - 1;
		cluster_idx = tmp;
		regTFlag = 0;
	}
}

void SC_pac_ex1::ddex_ls_ex1(inst_t * curinst)
{
	unsigned int usrc1, usrc2;
	int tmp;

	usrc1 = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	usrc2 = regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);
	curinst->WB_Data = usrc1;
	curinst->WB_Data1 = usrc2;

	if (regTFlag == 0) {
		regT1 = usrc1;
		regT1Type = ((curinst->Rd1_Addr << 16) | curinst->Rd1_Type);
		regT2 = usrc2;
		regTFlag = cluster_idx + 1;
	} else {
		tmp = cluster_idx;
		cluster_idx = regTFlag - 1;
		cluster_idx = tmp;
		regTFlag = 0;
	}
}

void SC_pac_ex1::clr_ls_ex1(inst_t * curinst)
{
	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, 0);
}

void SC_pac_ex1::dclr_ls_ex1(inst_t * curinst)
{
//  unsigned char tmp;

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, 0);
	regfile_l_write(curinst->Rd1_Addr + 1, curinst->Rd1_Type, 0);
}

void SC_pac_ex1::lmbd_ls_ex1(inst_t * curinst)
{
	int i;
	unsigned int udst, usrc;

	usrc = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);

	for (i = 0; i < 32; i++) {
		if (usrc & (1 << (31 - i)))
			break;
	}
	udst = i;

	regfile_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst);
}

///////////////////////////////////////////////
//dedicated instruciton to AU
//
//multiplicaiton
void SC_pac_ex1::fmul_au_ex1(inst_t * curinst)
{
	unsigned int udst, usrc1, usrc2;

	usrc1 = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	usrc2 = regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	udst = SIGN_EXT(((int) usrc1), 16) * SIGN_EXT(((int) usrc2), 16);

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, (int) udst);

	if (cluster_idx == 1 || cluster_idx == 3) {
		psr_write(1, PSR_OV, 0);
	} else {
		psr_write(0, PSR_OV, 0);
	}
}

void SC_pac_ex1::fmuld_au_ex1(inst_t * curinst)
{
	unsigned int udst1, udst2, usrc1, usrc2;

	usrc1 = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	usrc2 = regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	udst1 = (((int) usrc1) >> 16) * (((int) usrc2) >> 16);
	udst2 = SIGN_EXT(((int) usrc1), 16) * SIGN_EXT(((int) usrc2), 16);

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, (int) udst2);
	regfile_l_write(curinst->Rd1_Addr + 1, curinst->Rd1_Type, (int) udst1);

	if (cluster_idx == 1 || cluster_idx == 3) {
		psr_write(1, PSR_OV, 0);
	} else {
		psr_write(0, PSR_OV, 0);
	}
}

void SC_pac_ex1::fmuluud_au_ex1(inst_t * curinst)
{
	unsigned int udst1, udst2, usrc1, usrc2;

	usrc1 = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	usrc2 = regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	udst1 = (unsigned short) usrc1 *(unsigned short) usrc2;

	udst2 = (((unsigned int) usrc1) >> 16) * (((unsigned int) usrc2) >> 16);

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst1);
	regfile_l_write(curinst->Rd1_Addr + 1, curinst->Rd1_Type, udst2);

	if (cluster_idx == 1 || cluster_idx == 3) {
		psr_write(1, PSR_CA, 0);
		psr_write(1, PSR_OV, 0);
	} else {
		psr_write(0, PSR_CA, 0);
		psr_write(0, PSR_OV, 0);
	}
}

void SC_pac_ex1::fmulusd_au_ex1(inst_t * curinst)
{
	unsigned int udst1, udst2, usrc1, usrc2;

	usrc1 = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	usrc2 = regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	udst1 = (unsigned short) usrc1 *SIGN_EXT(((int) usrc2), 16);

	udst2 = (((unsigned int) usrc1) >> 16) * (((int) usrc2) >> 16);

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, (int) udst1);
	regfile_l_write(curinst->Rd1_Addr + 1, curinst->Rd1_Type, (int) udst2);

	if (cluster_idx == 1 || cluster_idx == 3) {
		psr_write(1, PSR_OV, 0);
	} else {
		psr_write(0, PSR_OV, 0);
	}
}

void SC_pac_ex1::fmulsud_au_ex1(inst_t * curinst)
{
	unsigned int udst1, udst2, usrc1, usrc2;

	usrc1 = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	usrc2 = regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	udst1 = (unsigned short) usrc2 *SIGN_EXT(((int) usrc1), 16);

	udst2 = (((unsigned int) usrc2) >> 16) * (((int) usrc1) >> 16);

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, (int) udst1);
	regfile_l_write(curinst->Rd1_Addr + 1, curinst->Rd1_Type, (int) udst2);

	if (cluster_idx == 1 || cluster_idx == 3) {
		psr_write(1, PSR_OV, 0);
	} else {
		psr_write(0, PSR_OV, 0);
	}
}

void SC_pac_ex1::fmuluu_au_ex1(inst_t * curinst)
{
	unsigned int udst, usrc1, usrc2;

	udst = regfile_read(curinst->Rd1_Addr, curinst->Rd1_Type);
	usrc1 = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	usrc2 = regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	usrc1 = LOW16MASK(usrc1);
	usrc2 = LOW16MASK(usrc2);
	udst = (unsigned short) usrc1 *(unsigned short) usrc2;

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst);

	if (cluster_idx == 1 || cluster_idx == 3) {
		psr_write(1, PSR_CA, 0);
		psr_write(1, PSR_OV, 0);
	} else {
		psr_write(0, PSR_CA, 0);
		psr_write(0, PSR_OV, 0);
	}
}

void SC_pac_ex1::fmulsu_au_ex1(inst_t * curinst)
{
	unsigned int udst, usrc1, usrc2;

	udst = regfile_read(curinst->Rd1_Addr, curinst->Rd1_Type);
	usrc1 = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	usrc2 = regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	udst = (short) usrc1 *(unsigned short) usrc2;

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, (int) udst);

	if (cluster_idx == 1 || cluster_idx == 3) {
		psr_write(1, PSR_OV, 0);
	} else {
		psr_write(0, PSR_OV, 0);
	}
}

void SC_pac_ex1::fmulus_au_ex1(inst_t * curinst)
{
	unsigned int udst, usrc1, usrc2;

	udst = regfile_read(curinst->Rd1_Addr, curinst->Rd1_Type);
	usrc1 = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	usrc2 = regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	udst = (unsigned short) usrc1 *(short) usrc2;

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, (int) udst);

	if (cluster_idx == 1 || cluster_idx == 3) {
		psr_write(1, PSR_OV, 0);
	} else {
		psr_write(0, PSR_OV, 0);
	}
}

//void mulds_au_ex1(inst_t* curinst);
void SC_pac_ex1::muld_au_ex1(inst_t * curinst)
{
	unsigned int udst1, udst2, usrc1, usrc2;
	int psr_idx;

	if (cluster_idx == 1 || cluster_idx == 3)
		psr_idx = 1;
	else
		psr_idx = 0;

	if (psr_read(psr_idx, PSR_SATP)) {
		curinst->op = MULDS;
		mulds_au_ex1(curinst);
		return;
	}

	usrc1 = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	usrc2 = regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	udst1 = (((int) usrc1) >> 16) * (((int) usrc2) >> 16);
	udst2 = SIGN_EXT(((int) usrc1), 16) * SIGN_EXT(((int) usrc2), 16);

	// detect overflow
	curinst->WB_Data = 0;
	if (((((usrc1 >> 31) & 0x1) ^ ((usrc2 >> 31) & 0x1)) !=
		 ((udst1 >> 15) & 0x1)) && (((usrc1 >> 16) != 0)
									&& ((usrc2 >> 16) != 0)))
		curinst->WB_Data = 1;
	if (((udst1 >> 15) & 0x7) != 0x0 && ((udst1 >> 15) & 0x7) != 0x7)
		curinst->WB_Data = 1;
	if (((((usrc1 >> 15) & 0x1) ^ ((usrc2 >> 15) & 0x1)) !=
		 ((udst2 >> 15) & 0x1)) && (((usrc1 & 0xFFFF) != 0)
									&& ((usrc2 & 0xFFFF) != 0)))
		curinst->WB_Data = 1;
	if (((udst2 >> 15) & 0x7) != 0x0 && ((udst2 >> 15) & 0x7) != 0x7)
		curinst->WB_Data = 1;

	regfile_write(curinst->Rd1_Addr, curinst->Rd1_Type,
				  ((udst1 << 16) + LOW16MASK(udst2)));

	psr_write(psr_idx, PSR_OV, curinst->WB_Data);
}

void SC_pac_ex1::mulds_au_ex1(inst_t * curinst)
{
	unsigned int udst1, udst2, usrc1, usrc2;

	usrc1 = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	usrc2 = regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	udst1 = (((int) usrc1) >> 16) * (((int) usrc2) >> 16);
	udst2 = SIGN_EXT(((int) usrc1), 16) * SIGN_EXT(((int) usrc2), 16);

	// saturation
	if ((((udst1 >> 15) & 0x7) != 0x0 && ((udst1 >> 15) & 0x7) != 0x7) ||
		((((udst1 >> 15) & 0x1) !=
		  ((usrc1 >> 31) & 0x1)) ^ ((usrc2 >> 31) & 0x1))) {
//liqin       (((udst1 >> 15) & 0x1) != ((usrc1 >> 31) & 0x1) ^ ((usrc2 >> 31) & 0x1)) ) {
		if (((usrc1 >> 16) != 0) && ((usrc2 >> 16) != 0)) {
			if (((((short) (usrc1 >> 16)) > 0)
				 && (((short) (usrc2 >> 16)) > 0))
				|| ((((short) (usrc1 >> 16)) < 0)
					&& (((short) (usrc2 >> 16)) < 0)))
				udst1 = 0x7FFF;
			else
				udst1 = 0x8000;
		}
	}

	if ((((udst2 >> 15) & 0x7) != 0x0 && ((udst2 >> 15) & 0x7) != 0x7) ||
		((((udst2 >> 15) & 0x1) !=
		  ((usrc1 >> 15) & 0x1)) ^ ((usrc2 >> 15) & 0x1))) {
//liqin       (((udst2 >> 15) & 0x1) != ((usrc1 >> 15) & 0x1) ^ ((usrc2 >> 15) & 0x1)) ) {
		if (((usrc1 & 0xFFFF) != 0) && ((usrc2 & 0xFFFF) != 0)) {
			if (((((short) usrc1) > 0) && (((short) usrc2) > 0)) ||
				((((short) usrc1) < 0) && (((short) usrc2) < 0)))
				udst2 = 0x7FFF;
			else
				udst2 = 0x8000;
		}
	}

	curinst->WB_Data = ((udst1 << 16) + LOW16MASK(udst2));

	psr_write(0, PSR_OV, 0);
}

void SC_pac_ex1::xfmul_au_ex1(inst_t * curinst)
{
	unsigned int udst, usrc1, usrc2;

	udst = regfile_read(curinst->Rd1_Addr, curinst->Rd1_Type);
	usrc1 = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	usrc2 = regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	udst = ((short) usrc1 * (short) usrc2) << 1;

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, (int) udst);

	if (cluster_idx == 1 || cluster_idx == 3)
		psr_write(1, PSR_OV, 0);
	else
		psr_write(0, PSR_OV, 0);
}

void SC_pac_ex1::xfmuld_au_ex1(inst_t * curinst)
{
	unsigned int udst1, udst2, usrc1, usrc2;

	usrc1 = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	usrc2 = regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	udst1 = ((short) usrc1 * (short) usrc2) << 1;
	udst2 = ((short) (usrc1 >> 16) * (short) (usrc2 >> 16)) << 1;

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, (int) udst1);
	regfile_l_write(curinst->Rd1_Addr + 1, curinst->Rd1_Type, (int) udst2);

	if (cluster_idx == 1 || cluster_idx == 3)
		psr_write(1, PSR_OV, 0);
	else
		psr_write(0, PSR_OV, 0);
}

void SC_pac_ex1::xmuld_au_ex1(inst_t * curinst)
{
	unsigned int udst1, udst2, usrc1, usrc2;

	usrc1 = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	usrc2 = regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	udst1 = ((((int) usrc1) >> 16) * (((int) usrc2) >> 16) >> 15);
	udst2 = (SIGN_EXT(((int) usrc1), 16) * SIGN_EXT(((int) usrc2), 16) >> 15);

	regfile_write(curinst->Rd1_Addr, curinst->Rd1_Type,
				  ((udst1 << 16) + LOW16MASK(udst2)));

	if (cluster_idx == 1 || cluster_idx == 3)
		psr_write(1, PSR_OV, 0);
	else
		psr_write(0, PSR_OV, 0);
}

// multiplication and accumulation
void SC_pac_ex1::fmac_au_ex1(inst_t * curinst)
{
	unsigned int usrc1, usrc2;
	unsigned long long udst, udsttmp1, udsttmp2;

	udst = regfile_l_read(curinst->Rd1_Addr, curinst->Rd1_Type);
	usrc1 = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	usrc2 = regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	udsttmp1 = (SIGN_EXT(((int) usrc1), 16) * SIGN_EXT(((int) usrc2), 16));
	udsttmp2 = udst;
	udst = udsttmp1 + udsttmp2;

	curinst->WB_Data = udst;
	curinst->WB_Data1 = (unsigned int) (udst >> 32);
}

void SC_pac_ex1::fmacd_au_ex1(inst_t * curinst)
{
	unsigned int usrc1, usrc2;
	unsigned long long udst1, udst2;
	unsigned long long udst1tmp1, udst1tmp2, udst2tmp1, udst2tmp2;

	udst1 = regfile_l_read(curinst->Rd1_Addr, curinst->Rd1_Type);
	udst2 = regfile_l_read(curinst->Rd1_Addr + 1, curinst->Rd1_Type);
	usrc1 = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	usrc2 = regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	udst2tmp1 = (((int) usrc1) >> 16) * (((int) usrc2) >> 16);
	udst1tmp1 = SIGN_EXT(((int) usrc1), 16) * SIGN_EXT(((int) usrc2), 16);
	udst1tmp2 = udst1;
	udst2tmp2 = udst2;
	udst1 = udst1tmp1 + udst1tmp2;
	udst2 = udst2tmp1 + udst2tmp2;

	curinst->WB_Data = udst1;
	curinst->Memory_Addr = (unsigned int) (udst1 >> 32);
	curinst->WB_Data1 = udst2;
	curinst->WM = (unsigned short) (udst2 >> 32);
	curinst->WV = (unsigned short) (udst2 >> 48);
}

void SC_pac_ex1::fmacuud_au_ex1(inst_t * curinst)
{
	unsigned int usrc1, usrc2;
	unsigned long long udst1, udst2;
	unsigned long long udst1tmp1, udst1tmp2, udst2tmp1, udst2tmp2;

	udst1 = regfile_l_read(curinst->Rd1_Addr, curinst->Rd1_Type);
	udst2 = regfile_l_read(curinst->Rd1_Addr + 1, curinst->Rd1_Type);
	usrc1 = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	usrc2 = regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	udst1tmp1 =
		(unsigned long long) LOW16MASK(usrc1) *
		(unsigned long long) LOW16MASK(usrc2);
	udst2tmp1 =
		((unsigned long long) (usrc1 >> 16)) *
		((unsigned long long) (usrc2 >> 16));
	udst1tmp2 = udst1;
	udst2tmp2 = udst2;
	udst1 = udst1tmp1 + udst1tmp2;
	udst2 = udst2tmp1 + udst2tmp2;

	curinst->WB_Data = udst1;
	curinst->Memory_Addr = (unsigned int) (udst1 >> 32);
	curinst->WB_Data1 = udst2;
	curinst->WM = (unsigned short) (udst2 >> 32);
	curinst->WV = (unsigned short) (udst2 >> 48);
}

void SC_pac_ex1::fmacusd_au_ex1(inst_t * curinst)
{
	unsigned int usrc1, usrc2;
	unsigned long long udst1, udst2;
	unsigned long long udst1tmp1, udst1tmp2, udst2tmp1, udst2tmp2;

	udst1 = regfile_l_read(curinst->Rd1_Addr, curinst->Rd1_Type);
	udst2 = regfile_l_read(curinst->Rd1_Addr + 1, curinst->Rd1_Type);
	usrc1 = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	usrc2 = regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	udst1tmp1 = (unsigned short) usrc1 *(short) usrc2;

	udst2tmp1 = ((unsigned short) (usrc1 >> 16)) * ((short) (usrc2 >> 16));
	udst1tmp2 = udst1;
	udst2tmp2 = udst2;
	udst1 = udst1tmp1 + udst1tmp2;
	udst2 = udst2tmp1 + udst2tmp2;

	curinst->WB_Data = udst1;
	curinst->Memory_Addr = (unsigned int) (udst1 >> 32);
	curinst->WB_Data1 = udst2;
	curinst->WM = (unsigned short) (udst2 >> 32);
	curinst->WV = (unsigned short) (udst2 >> 48);
}

void SC_pac_ex1::fmacsud_au_ex1(inst_t * curinst)
{
	unsigned int usrc1, usrc2;
	unsigned long long udst1, udst2;
	unsigned long long udst1tmp1, udst1tmp2, udst2tmp1, udst2tmp2;

	udst1 = regfile_l_read(curinst->Rd1_Addr, curinst->Rd1_Type);
	udst2 = regfile_l_read(curinst->Rd1_Addr + 1, curinst->Rd1_Type);
	usrc1 = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	usrc2 = regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	udst1tmp1 = (unsigned short) usrc2 *(short) usrc1;

	udst2tmp1 = ((unsigned short) (usrc2 >> 16)) * ((short) (usrc1 >> 16));
	udst1tmp2 = udst1;
	udst2tmp2 = udst2;
	udst1 = udst1tmp1 + udst1tmp2;
	udst2 = udst2tmp1 + udst2tmp2;

	curinst->WB_Data = udst1;
	curinst->Memory_Addr = (unsigned int) (udst1 >> 32);
	curinst->WB_Data1 = udst2;
	curinst->WM = (unsigned short) (udst2 >> 32);
	curinst->WV = (unsigned short) (udst2 >> 48);
}

void SC_pac_ex1::fmacuu_au_ex1(inst_t * curinst)
{
	unsigned int usrc1, usrc2;
	unsigned long long udst, udsttmp1, udsttmp2;

	udst = regfile_l_read(curinst->Rd1_Addr, curinst->Rd1_Type);
	usrc1 = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	usrc2 = regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	udsttmp1 =
		(unsigned long long) LOW16MASK(usrc1) *
		(unsigned long long) LOW16MASK(usrc2);
	udsttmp2 = udst;
	udst = udsttmp1 + udsttmp2;

	curinst->WB_Data = udst;
	curinst->WB_Data1 = (unsigned int) (udst >> 32);
}

void SC_pac_ex1::fmacsu_au_ex1(inst_t * curinst)
{
	unsigned int usrc1, usrc2;
	unsigned long long udst, udsttmp1, udsttmp2;

	udst = regfile_l_read(curinst->Rd1_Addr, curinst->Rd1_Type);
	usrc1 = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	usrc2 = regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	udsttmp1 = (short) usrc1 *(unsigned short) usrc2;

	udsttmp2 = udst;
	udst = udsttmp1 + udsttmp2;

	curinst->WB_Data = udst;
	curinst->WB_Data1 = (unsigned int) (udst >> 32);
}

void SC_pac_ex1::fmacus_au_ex1(inst_t * curinst)
{
	unsigned int usrc1, usrc2;
	unsigned long long udst, udsttmp1, udsttmp2;

	udst = regfile_l_read(curinst->Rd1_Addr, curinst->Rd1_Type);
	usrc1 = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	usrc2 = regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	udsttmp1 = (unsigned short) usrc1 *(short) usrc2;

	udsttmp2 = udst;
	udst = udsttmp1 + udsttmp2;

	curinst->WB_Data = udst;
	curinst->WB_Data1 = (unsigned int) (udst >> 32);
}

//void macds_au_ex1(inst_t* curinst);
void SC_pac_ex1::macd_au_ex1(inst_t * curinst)
{
	unsigned int udst1, udst2, udsttmp, usrc1, usrc2;
	unsigned int udst1tmp1, udst1tmp2, udst2tmp1, udst2tmp2;
	int psr_idx;

	if (cluster_idx == 1 || cluster_idx == 3)
		psr_idx = 1;
	else
		psr_idx = 0;

	if (psr_read(psr_idx, PSR_SATP) || psr_read(psr_idx, PSR_SATAcc)) {
		curinst->op = MACDS;
		macds_au_ex1(curinst);
		return;
	}

	udsttmp = regfile_read(curinst->Rd1_Addr, curinst->Rd1_Type);
	usrc1 = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	usrc2 = regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	udst1tmp1 = (int) udsttmp >> 16;
	udst2tmp1 = SIGN_EXT((int) udsttmp, 16);
	udst1tmp2 = (((int) usrc1) >> 16) * (((int) usrc2) >> 16);
	udst2tmp2 = SIGN_EXT(((int) usrc1), 16) * SIGN_EXT(((int) usrc2), 16);
	udst1 = udst1tmp1 + LOW16MASK(udst1tmp2);
	udst2 = udst2tmp1 + LOW16MASK(udst2tmp2);

	// detect overflow, multipluation
	curinst->WB_Data1 = 0;
//liqin  if ( (((usrc1 >> 31) & 0x1) ^ ((usrc2 >> 31) & 0x1) != ((udst1tmp2 >> 15) & 0x1)) &&
	if ((((usrc1 >> 31) & 0x1) ^
		 (((usrc2 >> 31) & 0x1) != ((udst1tmp2 >> 15) & 0x1)))
		&& (((usrc1 >> 16) != 0) && ((usrc2 >> 16) != 0)))
		curinst->WB_Data1 = 1;
	if (((udst1tmp2 >> 15) & 0x7) != 0x0 && ((udst1tmp2 >> 15) & 0x7) != 0x7)
		curinst->WB_Data1 = 1;
//liqin  if ( (((usrc1 >> 15) & 0x1) ^ ((usrc2 >> 15) & 0x1) != ((udst2tmp2 >> 15) & 0x1)) &&
	if ((((usrc1 >> 15) & 0x1) ^
		 (((usrc2 >> 15) & 0x1) != ((udst2tmp2 >> 15) & 0x1)))
		&& (((usrc1 & 0xFFFF) != 0) && ((usrc2 & 0xFFFF) != 0)))
		curinst->WB_Data1 = 1;
	if (((udst2tmp2 >> 15) & 0x7) != 0x0 && ((udst2tmp2 >> 15) & 0x7) != 0x7)
		curinst->WB_Data1 = 1;

	// detect overflow, accumulation
	if (((short) (udst1tmp1) > 0) && ((short) (udst1tmp2) > 0) &&
		((short) udst1 < 0)) {
		curinst->WB_Data1 = 1;
	} else if (((short) (udst1tmp1) < 0) && ((short) (udst1tmp2) < 0) &&
			   ((short) udst1 > 0)) {
		curinst->WB_Data1 = 1;
	}
	if (((short) (udst2tmp1) > 0) && ((short) (udst2tmp2) > 0) &&
		((short) udst2 < 0)) {
		curinst->WB_Data1 = 1;
	} else if (((short) (udst2tmp1) < 0) && ((short) (udst2tmp2) < 0) &&
			   ((short) udst2 > 0)) {
		curinst->WB_Data1 = 1;
	}

	curinst->WB_Data = (udst1 << 16) + LOW16MASK(udst2);

	psr_write(psr_idx, PSR_OV, curinst->WB_Data1);
}

void SC_pac_ex1::macds_au_ex1(inst_t * curinst)
{
	unsigned int udst1, udst2, udsttmp, usrc1, usrc2;
	unsigned int udst1tmp1, udst1tmp2, udst2tmp1, udst2tmp2;
	int psr_idx;

	if (cluster_idx == 1 || cluster_idx == 3)
		psr_idx = 1;
	else
		psr_idx = 0;

	udsttmp = regfile_read(curinst->Rd1_Addr, curinst->Rd1_Type);
	usrc1 = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	usrc2 = regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	udst1tmp1 = (int) udsttmp >> 16;
	udst2tmp1 = SIGN_EXT((int) udsttmp, 16);
	udst1tmp2 = (((int) usrc1) >> 16) * (((int) usrc2) >> 16);
	udst2tmp2 = SIGN_EXT(((int) usrc1), 16) * SIGN_EXT(((int) usrc2), 16);

	// detect overflow, multipluation
	curinst->WB_Data1 = 0;

	if ((((udst1tmp2 >> 15) & 0x7) != 0x0 && ((udst1tmp2 >> 15) & 0x7) != 0x7)
		|| ((((udst1tmp2 >> 15) & 0x1) != ((usrc1 >> 31) & 0x1)) ^
			((usrc2 >> 31) & 0x1))) {
//liqin       || (((udst1tmp2 >> 15) & 0x1) != ((usrc1 >> 31) & 0x1) ^ ((usrc2 >> 31) & 0x1)) ) {
		if (((usrc1 >> 16) != 0) && ((usrc2 >> 16) != 0)) {
			if (psr_read(psr_idx, PSR_SATP)) {
				if ((((short) (usrc1 >> 16)) > 0
					 && ((short) (usrc2 >> 16) > 0))
					|| (((short) (usrc1 >> 16)) < 0
						&& ((short) (usrc2 >> 16) < 0))) {
					udst1tmp2 = 0x7FFF;
					curinst->WB_Data1 = 0;
				} else {
					udst1tmp2 = 0x8000;
					curinst->WB_Data1 = 0;
				}
			} else
				curinst->WB_Data1 = 1;
		}
	}
	if ((((udst2tmp2 >> 15) & 0x7) != 0x0 && ((udst2tmp2 >> 15) & 0x7) != 0x7)
		|| ((((udst2tmp2 >> 15) & 0x1) != ((usrc1 >> 15) & 0x1)) ^
			((usrc2 >> 15) & 0x1))) {
//liqin       || (((udst2tmp2 >> 15) & 0x1) != ((usrc1 >> 15) & 0x1) ^ ((usrc2 >> 15) & 0x1)) ) {
		if (((usrc1 & 0xFFFF) != 0) && ((usrc2 & 0xFFFF) != 0)) {
			if (psr_read(psr_idx, PSR_SATP)) {
				if (((short) usrc1 > 0 && (short) usrc2 > 0) ||
					((short) usrc1 < 0 && (short) usrc2 < 0)) {
					udst2tmp2 = 0x7FFF;
					curinst->WB_Data1 = 0;
				} else {
					udst2tmp2 = 0x8000;
					curinst->WB_Data1 = 0;
				}
			} else
				curinst->WB_Data1 = 1;
		}
	}

	udst1 = udst1tmp1 + LOW16MASK(udst1tmp2);
	udst2 = udst2tmp1 + LOW16MASK(udst2tmp2);

	// detect overflow, accumulation
	curinst->WV = 0;
	if (((short) (udst1tmp1) > 0) && ((short) (udst1tmp2) > 0) &&
		((short) udst1 < 0)) {
		if (psr_read(psr_idx, PSR_SATAcc)) {
			udst1 = 0x7FFF;
			curinst->WV = 0;
		} else
			curinst->WV = 1;
	} else if (((short) (udst1tmp1) < 0) && ((short) (udst1tmp2) < 0) &&
			   ((short) udst1 >= 0)) {
		if (psr_read(psr_idx, PSR_SATAcc)) {
			udst1 = 0x8000;
			curinst->WV = 0;
		} else
			curinst->WV = 1;
	}
	if (((short) (udst2tmp1) > 0) && ((short) (udst2tmp2) > 0) &&
		((short) udst2 < 0)) {
		if (psr_read(psr_idx, PSR_SATAcc)) {
			udst2 = 0x7FFF;
			curinst->WV = 0;
		} else
			curinst->WV = 1;
	} else if (((short) (udst2tmp1) < 0) && ((short) (udst2tmp2) < 0) &&
			   ((short) udst2 >= 0)) {
		if (psr_read(psr_idx, PSR_SATAcc)) {
			udst2 = 0x8000;
			curinst->WV = 0;
		} else
			curinst->WV = 1;
	}

	curinst->WB_Data = (udst1 << 16) + LOW16MASK(udst2);

	psr_write(psr_idx, PSR_OV, curinst->WB_Data1 | curinst->WV);
}

//void msuds_au_ex1(inst_t* curinst);
void SC_pac_ex1::msud_au_ex1(inst_t * curinst)
{
	unsigned int udst1, udst2, udsttmp, usrc1, usrc2;
	unsigned int udst1tmp1, udst1tmp2, udst2tmp1, udst2tmp2;
	int psr_idx;

	if (cluster_idx == 1 || cluster_idx == 3)
		psr_idx = 1;
	else
		psr_idx = 0;

	if (psr_read(psr_idx, PSR_SATP) || psr_read(psr_idx, PSR_SATAcc)) {
		curinst->op = MSUDS;
		msuds_au_ex1(curinst);
		return;
	}

	udsttmp = regfile_read(curinst->Rd1_Addr, curinst->Rd1_Type);
	usrc1 = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	usrc2 = regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	udst1tmp1 = (int) udsttmp >> 16;
	udst2tmp1 = SIGN_EXT((int) udsttmp, 16);
	udst1tmp2 = (((int) usrc1) >> 16) * (((int) usrc2) >> 16);
	udst2tmp2 = SIGN_EXT(((int) usrc1), 16) * SIGN_EXT(((int) usrc2), 16);
	udst1 = udst1tmp1 - udst1tmp2;
	udst2 = udst2tmp1 - udst2tmp2;

	// detect overflow, multipluation
	curinst->WB_Data1 = 0;
//liqin  if ( (((usrc1 >> 31) & 0x1) ^ ((usrc2 >> 31) & 0x1) != ((udst1tmp2 >> 15) & 0x1)) &&
	if ((((usrc1 >> 31) & 0x1) ^
		 (((usrc2 >> 31) & 0x1) != ((udst1tmp2 >> 15) & 0x1)))
		&& (((usrc1 >> 16) != 0) && ((usrc2 >> 16) != 0)))
		curinst->WB_Data1 = 1;
	if ((((udst1tmp2 >> 15) & 0x7) != 0x0)
		&& (((udst1tmp2 >> 15) & 0x7) != 0x7))
		curinst->WB_Data1 = 1;
//liqin  if ( (((usrc1 >> 15) & 0x1) ^ ((usrc2 >> 15) & 0x1) != ((udst2tmp2 >> 15) & 0x1)) &&
	if ((((usrc1 >> 15) & 0x1) ^
		 (((usrc2 >> 15) & 0x1) != ((udst2tmp2 >> 15) & 0x1)))
		&& (((usrc1 & 0xFFFF) != 0) && ((usrc2 & 0xFFFF) != 0)))
		curinst->WB_Data1 = 1;
	if ((((udst2tmp2 >> 15) & 0x7) != 0x0)
		&& (((udst2tmp2 >> 15) & 0x7) != 0x7))
		curinst->WB_Data1 = 1;

	// detect overflow, accumulation
	if (((short) (udst1tmp1) > 0) && ((short) (udst1tmp2) < 0) &&
		((short) udst1 < 0)) {
		curinst->WB_Data1 = 1;
	} else if (((short) (udst1tmp1) < 0) && ((short) (udst1tmp2) > 0) &&
			   ((short) udst1 > 0)) {
		curinst->WB_Data1 = 1;
	}
	if (((short) (udst2tmp1) > 0) && ((short) (udst2tmp2) < 0) &&
		((short) udst2 < 0)) {
		curinst->WB_Data1 = 1;
	} else if (((short) (udst2tmp1) < 0) && ((short) (udst2tmp2) > 0) &&
			   ((short) udst2 > 0)) {
		curinst->WB_Data1 = 1;
	}

	curinst->WB_Data = (udst1 << 16) + LOW16MASK(udst2);
	psr_write(0, PSR_OV, curinst->WB_Data1);
}

void SC_pac_ex1::msuds_au_ex1(inst_t * curinst)
{
	unsigned int udst1, udst2, udsttmp, usrc1, usrc2;
	unsigned int udst1tmp1, udst1tmp2, udst2tmp1, udst2tmp2;

	udsttmp = regfile_read(curinst->Rd1_Addr, curinst->Rd1_Type);
	usrc1 = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	usrc2 = regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	udst1tmp1 = (int) udsttmp >> 16;
	udst2tmp1 = SIGN_EXT((int) udsttmp, 16);
	udst1tmp2 = (((int) usrc1) >> 16) * (((int) usrc2) >> 16);
	udst2tmp2 = SIGN_EXT(((int) usrc1), 16) * SIGN_EXT(((int) usrc2), 16);

	// detect overflow, multipluation
	curinst->WB_Data1 = 0;
	if (((((udst1tmp2 >> 15) & 0x7) != 0x0)
		 && (((udst1tmp2 >> 15) & 0x7) != 0x7))
		|| (((usrc1 >> 31) & 0x1) ^
			(((usrc2 >> 31) & 0x1) != ((udst1tmp2 >> 15) & 0x1)))
//liqin       || (((usrc1 >> 31) & 0x1) ^ ((usrc2 >> 31) & 0x1) != ((udst1tmp2 >> 15) & 0x1))
		) {
		if (((usrc1 >> 16) != 0) && ((usrc2 >> 16) != 0)) {
			if (psr_read(0, PSR_SATP)) {
				if ((((short) (usrc1 >> 16)) > 0
					 && ((short) (usrc2 >> 16) > 0))
					|| (((short) (usrc1 >> 16)) < 0
						&& ((short) (usrc2 >> 16) < 0))) {
					udst1tmp2 = 0x7FFF;
					curinst->WB_Data1 = 0;
				} else {
					udst1tmp2 = 0x8000;
					curinst->WB_Data1 = 0;
				}
			} else
				curinst->WB_Data1 = 1;
		}
	}
	if (((((udst2tmp2 >> 15) & 0x7) != 0x0)
		 && (((udst2tmp2 >> 15) & 0x7) != 0x7))
		|| (((usrc1 >> 15) & 0x1) ^
			(((usrc2 >> 15) & 0x1) != ((udst2tmp2 >> 15) & 0x1)))
//liqin       || (((usrc1 >> 15) & 0x1) ^ ((usrc2 >> 15) & 0x1) != ((udst2tmp2 >> 15) & 0x1))
		) {
		if (((usrc1 & 0xFFFF) != 0) && ((usrc2 & 0xFFFF) != 0)) {
			if (psr_read(0, PSR_SATP)) {
				if (((short) usrc1 > 0 && (short) usrc2 > 0) ||
					((short) usrc1 < 0 && (short) usrc2 < 0)) {
					udst2tmp2 = 0x7FFF;
					curinst->WB_Data1 = 0;
				} else {
					udst2tmp2 = 0x8000;
					curinst->WB_Data1 = 0;
				}
			} else
				curinst->WB_Data1 = 1;
		}
	}

	udst1 = udst1tmp1 - udst1tmp2;
	udst2 = udst2tmp1 - udst2tmp2;

	// detect overflow, accumulation
	curinst->WV = 0;
	if ((((short) (udst1tmp1) > 0) && ((short) (udst1tmp2) < 0)
		 && ((short) udst1 < 0)) ||
		(((unsigned short) (udst1tmp1) == 0)
		 && ((unsigned short) (udst1tmp2) == 0x8000))) {
		if (psr_read(0, PSR_SATAcc)) {
			udst1 = 0x7FFF;
			curinst->WV = 0;
		} else
			curinst->WV = 1;
	} else if (((short) (udst1tmp1) < 0) && ((short) (udst1tmp2) > 0) &&
			   ((short) udst1 > 0)) {
		if (psr_read(0, PSR_SATAcc)) {
			udst1 = 0x8000;
			curinst->WV = 0;
		} else
			curinst->WV = 1;
	}
	if ((((short) (udst2tmp1) > 0) && ((short) (udst2tmp2) < 0) &&
		 ((short) udst2 < 0)) ||
		(((unsigned short) (udst2tmp1) == 0)
		 && ((unsigned short) (udst2tmp2) == 0x8000))) {
		if (psr_read(0, PSR_SATAcc)) {
			udst2 = 0x7FFF;
			curinst->WV = 0;
		} else
			curinst->WV = 1;
	} else if (((short) (udst2tmp1) < 0) && ((short) (udst2tmp2) > 0) &&
			   ((short) udst2 > 0)) {
		if (psr_read(0, PSR_SATAcc)) {
			udst2 = 0x8000;
			curinst->WV = 0;
		} else
			curinst->WV = 1;
	}

	curinst->WB_Data = (udst1 << 16) + LOW16MASK(udst2);
	psr_write(0, PSR_OV, curinst->WB_Data1 | curinst->WV);
}

void SC_pac_ex1::xfmac_au_ex1(inst_t * curinst)
{
	unsigned int usrc1, usrc2;
	unsigned long long udst, udsttmp1, udsttmp2;

	udst = regfile_l_read(curinst->Rd1_Addr, curinst->Rd1_Type);
	usrc1 = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	usrc2 = regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	udsttmp1 = ((short) usrc1 * (short) usrc2) << 1;
	udsttmp2 = udst;
	udst = udsttmp1 + udsttmp2;

	curinst->WB_Data = udst;
	curinst->WB_Data1 = (unsigned int) (udst >> 32);
}

void SC_pac_ex1::xfmacd_au_ex1(inst_t * curinst)
{
	unsigned int usrc1, usrc2;
	unsigned long long udst1, udst2;
	unsigned long long udst1tmp1, udst1tmp2, udst2tmp1, udst2tmp2;

	udst1 = regfile_l_read(curinst->Rd1_Addr, curinst->Rd1_Type);
	udst2 = regfile_l_read(curinst->Rd1_Addr + 1, curinst->Rd1_Type);
	usrc1 = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	usrc2 = regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	udst1tmp1 = ((short) usrc1 * (short) usrc2) << 1;
	udst2tmp1 = (((short) (usrc1 >> 16)) * ((short) (usrc2 >> 16))) << 1;
	udst1tmp2 = udst1;
	udst2tmp2 = udst2;
	udst1 = udst1tmp1 + udst1tmp2;
	udst2 = udst2tmp1 + udst2tmp2;

	curinst->WB_Data = udst1;
	curinst->WB_Data1 = (unsigned int) (udst1 >> 32);
	curinst->Memory_Addr = udst2;
	curinst->Imm32 = (unsigned int) (udst2 >> 32);
}

//void xmacds_au_ex1(inst_t* curinst);
void SC_pac_ex1::xmacd_au_ex1(inst_t * curinst)
{
	unsigned int udst1, udst2, udsttmp, usrc1, usrc2;
	unsigned int udst1tmp1, udst1tmp2, udst2tmp1, udst2tmp2;
	int psr_idx;

	if (cluster_idx == 1 || cluster_idx == 3)
		psr_idx = 1;
	else
		psr_idx = 0;

	if (psr_read(psr_idx, PSR_SATP) || psr_read(psr_idx, PSR_SATAcc)) {
		curinst->op = XMACDS;
		xmacds_au_ex1(curinst);
		return;
	}

	udsttmp = regfile_read(curinst->Rd1_Addr, curinst->Rd1_Type);
	usrc1 = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	usrc2 = regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	udst1tmp1 = (int) udsttmp >> 16;
	udst2tmp1 = SIGN_EXT((int) udsttmp, 16);
	udst1tmp2 = ((((int) usrc1) >> 16) * (((int) usrc2) >> 16) >> 15);
	udst2tmp2 =
		(SIGN_EXT(((int) usrc1), 16) * SIGN_EXT(((int) usrc2), 16) >> 15);

	curinst->WB_Data1 = 0;
	// detect overflow, multipluation

	udst1 = udst1tmp1 + udst1tmp2;
	udst2 = udst2tmp1 + udst2tmp2;

	// detect overflow, accumulation
	if (((short) (udst1tmp1) > 0) && ((short) (udst1tmp2) > 0) &&
		((short) udst1 < 0)) {
		curinst->WB_Data1 = 1;
	} else if (((short) (udst1tmp1) < 0) && ((short) (udst1tmp2) < 0) &&
			   ((short) udst1 >= 0)) {
		curinst->WB_Data1 = 1;
	}
	if (((short) (udst2tmp1) > 0) && ((short) (udst2tmp2) > 0) &&
		((short) udst2 < 0)) {
		curinst->WB_Data1 = 1;
	} else if (((short) (udst2tmp1) < 0) && ((short) (udst2tmp2) < 0) &&
			   ((short) udst2 >= 0)) {
		curinst->WB_Data1 = 1;
	}

	curinst->WB_Data = (udst1 << 16) + LOW16MASK(udst2);
	psr_write(psr_idx, PSR_OV, curinst->WB_Data1);
}

void SC_pac_ex1::xmacds_au_ex1(inst_t * curinst)
{
	unsigned int udst1, udst2, udsttmp, usrc1, usrc2, udst1tmp, udst2tmp;

	udsttmp = regfile_read(curinst->Rd1_Addr, curinst->Rd1_Type);
	usrc1 = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	usrc2 = regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	udst1 = ((((int) usrc1) >> 16) * (((int) usrc2) >> 16) >> 15);
	udst2 = (SIGN_EXT(((int) usrc1), 16) * SIGN_EXT(((int) usrc2), 16) >> 15);

	curinst->WB_Data1 = 0;
	// detect overflow, multipluation

	udst1 = LOW16MASK(udst1);
	udst2 = LOW16MASK(udst2);

	udst1tmp = udst1;
	udst2tmp = udst2;

	udst1 += (int) udsttmp >> 16;
	udst2 += SIGN_EXT((int) udsttmp, 16);

	// detect overflow, accumulation
	if (((short) udst1tmp > 0) && (((int) udsttmp >> 16) > 0)
		&& ((short) udst1 < 0)) {
		if (psr_read(0, PSR_SATAcc))
			udst1 = 0x7FFF;
		else
			curinst->WB_Data1 = 1;
	} else if (((short) udst1tmp < 0) && (((int) udsttmp >> 16) < 0)
			   && ((short) udst1 >= 0)) {
		if (psr_read(0, PSR_SATAcc))
			udst1 = 0x8000;
		else
			curinst->WB_Data1 = 1;
	}

	if (((short) udst2tmp > 0) && ((SIGN_EXT((int) udsttmp, 16)) > 0)
		&& ((short) udst2 < 0)) {
		if (psr_read(0, PSR_SATAcc))
			udst2 = 0x7FFF;
		else
			curinst->WB_Data1 = 1;
	} else if (((short) udst2tmp < 0) && ((SIGN_EXT((int) udsttmp, 16)) < 0)
			   && ((short) udst2 >= 0)) {
		if (psr_read(0, PSR_SATAcc))
			udst2 = 0x8000;
		else
			curinst->WB_Data1 = 1;
	}

	curinst->WB_Data = (udst1 << 16) + LOW16MASK(udst2);

	psr_write(0, PSR_OV, curinst->WB_Data1);
}

void SC_pac_ex1::xmsud_au_ex1(inst_t * curinst)
{
	unsigned int udst1, udst2, udsttmp, usrc1, usrc2;
	unsigned int udst1tmp1, udst1tmp2, udst2tmp1, udst2tmp2;
	int psr_idx;

	if (cluster_idx == 1 || cluster_idx == 3)
		psr_idx = 1;
	else
		psr_idx = 0;

	if (psr_read(psr_idx, PSR_SATP) || psr_read(psr_idx, PSR_SATAcc)) {
		curinst->op = XMSUDS;
		xmsuds_au_ex1(curinst);
		return;
	}

	udsttmp = regfile_read(curinst->Rd1_Addr, curinst->Rd1_Type);
	usrc1 = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	usrc2 = regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	udst1tmp1 = (int) udsttmp >> 16;
	udst2tmp1 = SIGN_EXT((int) udsttmp, 16);
	udst1tmp2 = ((((int) usrc1) >> 16) * (((int) usrc2) >> 16) >> 15);
	udst2tmp2 =
		(SIGN_EXT(((int) usrc1), 16) * SIGN_EXT(((int) usrc2), 16) >> 15);
	udst1 = udst1tmp1 - udst1tmp2;
	udst2 = udst2tmp1 - udst2tmp2;

	curinst->WB_Data1 = 0;
	// detect overflow, multipluation

	// detect overflow, accumulation
	if (((short) (udst1tmp1) > 0) && ((short) (udst1tmp2) < 0)
		&& ((short) udst1 < 0)) {
		curinst->WB_Data1 = 1;
	} else if (((short) (udst1tmp1) < 0) && ((short) (udst1tmp2) > 0)
			   && ((short) udst1 > 0)) {
		curinst->WB_Data1 = 1;
	} else if ((udst1tmp1 == 0x0) && (udst1tmp2 == 0xffff8000)) {
		curinst->WB_Data1 = 1;
	}
	if (((short) (udst2tmp1) > 0) && ((short) (udst2tmp2) < 0)
		&& ((short) udst2 < 0)) {
		curinst->WB_Data1 = 1;
	} else if (((short) (udst2tmp1) < 0) && ((short) (udst2tmp2) > 0)
			   && ((short) udst2 > 0)) {
		curinst->WB_Data1 = 1;
	} else if ((udst2tmp1 == 0x0) && (udst2tmp2 == 0xffff8000)) {
		curinst->WB_Data1 = 1;
	}

	curinst->WB_Data = (udst1 << 16) + LOW16MASK(udst2);
	psr_write(0, PSR_OV, curinst->WB_Data1);
}

void SC_pac_ex1::xmsuds_au_ex1(inst_t * curinst)
{
	unsigned int udst1, udst2, udsttmp, usrc1, usrc2, udst1tmp, udst2tmp;

	udsttmp = regfile_read(curinst->Rd1_Addr, curinst->Rd1_Type);
	usrc1 = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	usrc2 = regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	udst1 = ((((int) usrc1) >> 16) * (((int) usrc2) >> 16) >> 15);
	udst2 = (SIGN_EXT(((int) usrc1), 16) * SIGN_EXT(((int) usrc2), 16) >> 15);

	curinst->WB_Data1 = 0;
	// detect overflow, multipluation

	udst1 = LOW16MASK(udst1);
	udst2 = LOW16MASK(udst2);

	udst1tmp = udst1;
	udst2tmp = udst2;

	udst1 = ((short) (udsttmp >> 16)) - udst1;
	udst2 = SIGN_EXT((int) udsttmp, 16) - udst2;

	// detect overflow, accumulation
	if ((((short) udst1tmp < 0) && (((int) udsttmp >> 16) > 0)
		 && ((short) udst1 < 0)) || (((short) udst1tmp == (short) 0x8000)
									 && ((short) (udsttmp >> 16) == 0x0))) {
		if (psr_read(0, PSR_SATAcc))
			udst1 = 0x7FFF;
		else
			curinst->WB_Data1 = 1;
	} else if (((short) udst1tmp > 0) && (((int) udsttmp >> 16) < 0)
			   && ((short) udst1 > 0)) {
		if (psr_read(0, PSR_SATAcc))
			udst1 = 0x8000;
		else
			curinst->WB_Data1 = 1;
	}

	if ((((short) udst2tmp < 0) && ((SIGN_EXT((int) udsttmp, 16)) > 0)
		 && ((short) udst2 < 0)) || (((short) udst2tmp == (short) 0x8000)
									 && ((short) (udsttmp) == 0x0))) {
		if (psr_read(0, PSR_SATAcc))
			udst2 = 0x7FFF;
		else
			curinst->WB_Data1 = 1;
	} else if (((short) udst2tmp > 0) && ((SIGN_EXT((int) udsttmp, 16)) < 0)
			   && ((short) udst2 > 0)) {
		if (psr_read(0, PSR_SATAcc))
			udst2 = 0x8000;
		else
			curinst->WB_Data1 = 1;
	}

	curinst->WB_Data = (udst1 << 16) + LOW16MASK(udst2);

	psr_write(0, PSR_OV, curinst->WB_Data1);
}

void SC_pac_ex1::cls_au_ex1(inst_t * curinst)
{
	char i;
	unsigned int udst, usrc;

	usrc = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	if (usrc & 0x80000000) {
		udst = 1;
		for (i = 1; i <= 31; ++i)
			if (usrc & (0x80000000 >> i))
				udst++;
			else
				break;
	} else {
		udst = 1;
		for (i = 1; i <= 31; ++i)
			if (!(usrc & (0x80000000 >> i)))
				udst++;
			else
				break;
	}

	regfile_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst);
}

void SC_pac_ex1::sfra_au_ex1(inst_t * curinst)
{
	unsigned long long udst, usrc;	//, udsttmp, usrctmp;

	if (curinst->Rs1_Type != Reg_AC)
		usrc = (int) regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	else
		usrc = regfile_l_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	if (curinst->Rd1_Type != Reg_AC)
		udst = (int) regfile_read(curinst->Rd1_Addr, curinst->Rd1_Type);
	else
		udst = regfile_l_read(curinst->Rd1_Addr, curinst->Rd1_Type);

	udst += ((long long) usrc >> (curinst->Imm32 & 0x3F));

	curinst->WB_Data = udst;
	curinst->WB_Data1 = udst >> 32;
}

void SC_pac_ex1::sfrad_au_ex1(inst_t * curinst)
{
	unsigned int udst1, udst2, usrc;
	unsigned int usrc1tmp, usrc2tmp, udst1tmp, udst2tmp;

	usrc = (int) regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	udst1 = (int) regfile_read(curinst->Rd1_Addr, curinst->Rd1_Type);

	udst1tmp = (int) udst1 >> 16;
	udst2tmp = (short) udst1;
	usrc1tmp = (((int) usrc >> 16) >> curinst->Imm32);
	usrc2tmp = (short) usrc >> curinst->Imm32;
	udst2 = (short) udst1;
	udst1 = (int) udst1 >> 16;

	udst1 += (((int) usrc >> 16) >> (curinst->Imm32 & 0x1F));
	udst2 += (SIGN_EXT((int) usrc, 16) >> (curinst->Imm32 & 0x1F));

	// detect overflow
	curinst->WM = 0;
	curinst->WV = 0;
	if (((short) udst1tmp > 0) && ((short) usrc1tmp > 0)
		&& ((short) udst1 < 0))
		curinst->WV = 1;
	else if (((short) udst1tmp < 0) && ((short) usrc1tmp < 0)
			 && ((short) udst1 > 0))
		curinst->WM = 1;
	if (((short) udst2tmp > 0) && ((short) usrc2tmp > 0)
		&& ((short) udst2 < 0))
		curinst->WV = 1;
	else if (((short) udst2tmp < 0) && ((short) usrc2tmp < 0)
			 && ((short) udst2 > 0))
		curinst->WM = 1;

	curinst->WB_Data = ((udst1 << 16) + LOW16MASK(udst2));

	psr_write(0, PSR_OV, curinst->WM | curinst->WV);
}

void SC_pac_ex1::bf_au_ex1(inst_t * curinst)
{
	unsigned long long usrc1, usrc2;
	unsigned long long udst1, udst2;
	char psr_idx;

	if (cluster_idx == 1 || cluster_idx == 3)
		psr_idx = 1;
	else
		psr_idx = 0;

	if (curinst->Rs1_Type != Reg_AC)
		usrc1 = (int) regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	else
		usrc1 = regfile_l_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	if (curinst->Rs2_Type != Reg_AC)
		usrc2 = (int) regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);
	else
		usrc2 = regfile_l_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	udst1 = usrc1 + usrc2;
	udst2 = usrc1 - usrc2;

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst1);
	regfile_l_write(curinst->Rd1_Addr + 1, curinst->Rd1_Type, udst2);
}

void SC_pac_ex1::bfd_au_ex1(inst_t * curinst)
{
	unsigned int udst1, udst2, usrc1, usrc2;
	char psr_idx;

	if (cluster_idx == 1 || cluster_idx == 3)
		psr_idx = 1;
	else
		psr_idx = 0;

	usrc1 = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	usrc2 = regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	udst1 = (HIGH16MASK(usrc1) + HIGH16MASK(usrc2)) +
		LOW16MASK(SIGN_EXT(usrc1, 16) + SIGN_EXT(usrc2, 16));
	udst2 = (HIGH16MASK(usrc1) - HIGH16MASK(usrc2)) +
		LOW16MASK(SIGN_EXT(usrc1, 16) - SIGN_EXT(usrc2, 16));

	regfile_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst1);
	regfile_write(curinst->Rd1_Addr + 1, curinst->Rd1_Type, udst2);
}

void SC_pac_ex1::dotp2_au_ex1(inst_t * curinst)
{
	unsigned int usrc1, usrc2;
	unsigned long long uldst, ulsrc1, ulsrc2;

	usrc1 = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	usrc2 = regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	ulsrc1 =
		(int) (SIGN_EXT_POS((int) usrc1, 0, 16) *
			   SIGN_EXT_POS((int) usrc2, 0, 16));
	ulsrc2 = (int) (SIGN_EXT((int) usrc1, 16) * SIGN_EXT((int) usrc2, 16));

	uldst = ulsrc1 + ulsrc2;

	curinst->WB_Data = uldst;
	curinst->WB_Data1 = (int) (uldst >> 32);
}

void SC_pac_ex1::xdotp2_au_ex1(inst_t * curinst)
{
	unsigned int usrc1, usrc2;
	unsigned long long uldst, ulsrc1, ulsrc2;

	usrc1 = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	usrc2 = regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);

	ulsrc1 = (int) (((short) (usrc1 >> 16)) * ((short) (usrc2 >> 16)));
	ulsrc2 = (int) ((short) usrc1 * (short) usrc2);

	ulsrc1 = (int) (ulsrc1 << 1);
	ulsrc2 = (int) (ulsrc2 << 1);

	uldst = ulsrc1 + ulsrc2;

	curinst->WB_Data = uldst;
	curinst->WB_Data1 = (int) (uldst >> 32);
}

void SC_pac_ex1::rnd_au_ex1(inst_t * curinst)
{
	unsigned long long udst, usrc;

	if (curinst->Rs1_Type != Reg_AC)
		usrc = (int) regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	else
		usrc = regfile_l_read(curinst->Rs1_Addr, curinst->Rs1_Type);

	if ((LOW16MASK(usrc) > 0x8000) ||
		((LOW16MASK(usrc) == 0x8000) && ((usrc >> 16) & 0x1))) {
		udst = ((usrc >> 16) + 1) << 16;
	} else
		udst = (usrc >> 16) << 16;

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst);
}

void SC_pac_ex1::saaq_au_ex1(inst_t * curinst)
{
	unsigned int udst1, udst2, udst3, udst4, usrc1, usrc2;

	usrc1 = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	usrc2 = regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);
	udst1 = regfile_read(curinst->Rd1_Addr, curinst->Rd1_Type);
	udst2 = regfile_read(curinst->Rd1_Addr + 1, curinst->Rd1_Type);

	udst3 = SIGN_EXT(udst1, 16);
	udst1 = (unsigned int) udst1 >> 16;
	udst4 = SIGN_EXT(udst2, 16);
	udst2 = (unsigned int) udst2 >> 16;
	udst1 +=
		_ABS((unsigned char) (usrc1 >> 24) - (unsigned char) (usrc2 >> 24));
	udst3 +=
		_ABS((unsigned char) (usrc1 >> 16) - (unsigned char) (usrc2 >> 16));
	udst2 +=
		_ABS((unsigned char) (usrc1 >> 8) - (unsigned char) (usrc2 >> 8));
	udst4 += _ABS((unsigned char) usrc1 - (unsigned char) usrc2);

	curinst->WB_Data = ((udst1 << 16) + LOW16MASK(udst3));
	curinst->WB_Data1 = ((udst2 << 16) + LOW16MASK(udst4));
}

///////////////////////////////////////////////
// Scalar instruction
//
void SC_pac_ex1::b_sc_ex1(inst_t * curinst)
{
	if (curinst->P_Addr == (unsigned char) INVALID_REG)
		curinst->P_Addr = 0;
	branch_Reg_P = regfile_read(curinst->P_Addr, Reg_P);
}

void SC_pac_ex1::br_sc_ex1(inst_t * curinst)
{
	if (curinst->P_Addr == (unsigned char) INVALID_REG)
		curinst->P_Addr = 0;
	branch_Reg_P = regfile_read(curinst->P_Addr, Reg_P);
}

void SC_pac_ex1::brr_sc_ex1(inst_t * curinst)
{
	if (curinst->P_Addr == (unsigned char) INVALID_REG)
		curinst->P_Addr = 0;
	branch_Reg_P = regfile_read(curinst->P_Addr, Reg_P);
}

void SC_pac_ex1::lbcb_sc_ex1(inst_t * curinst)
{
	unsigned int udst1, usrc1;	//, usrc2;

	usrc1 = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	if (usrc1 > 1)
		udst1 = usrc1 - 1;
	else
		udst1 = 0;
}

void SC_pac_ex1::test_sc_ex1(inst_t * curinst)
{
	unsigned int udst1, udst2, usrc1, usrc2;	//, usrc3;

	usrc1 = curinst->offset;
	usrc2 = curinst->Imm32;

	if (usrc1 == (usrc2 & P_CFU_INFO)) {
		udst1 = 1;
		udst2 = 0;
	} else {
		udst1 = 0;
		udst2 = 1;
	}

	regfile_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst1);
	regfile_write(curinst->Rd2_Addr, curinst->Rd2_Type, udst2);
}

void SC_pac_ex1::wait_sc_ex1(inst_t * curinst)
{
	unsigned int udst, usrc1, usrc2;	//, usrc3;

	usrc1 = curinst->offset;
	usrc2 = curinst->Imm32;

	udst = regfile_read(curinst->Rd1_Addr, curinst->Rd1_Type);

	if ((usrc1 == (usrc2 & P_CFU_INFO)) || (udst == 1)) {
//      is_wait = 0;
		regfile_write(curinst->Rd1_Addr, curinst->Rd1_Type, 0);
	} else {
//      is_wait = 1;
		regfile_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst - 1);
	}
}

void SC_pac_ex1::read_flag_sc_ex1(inst_t * curinst)
{
	unsigned int udst;

	//v3.6 2008.8.19
	unsigned char psr_idx;

	if (cluster_idx == 1 || cluster_idx == 3)
		psr_idx = 1;
	else
		psr_idx = 0;
	udst = psr_read(psr_idx, PSR_OV) | (psr_read(psr_idx, PSR_CA) << 1);

	//udst = psr_read(0, PSR_OV) | (psr_read(0, PSR_CA) << 1);

	regfile_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst);
}

void SC_pac_ex1::write_flag_sc_ex1(inst_t * curinst)
{
	unsigned int usrc;

	//v3.6 2008.8.19
	unsigned char psr_idx;

	if (cluster_idx == 1 || cluster_idx == 3)
		psr_idx = 1;
	else
		psr_idx = 0;

	usrc = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);

	psr_write(psr_idx, PSR_OV, usrc & 0x1);
	psr_write(psr_idx, PSR_CA, (usrc >> 1) & 0x1);
}

//////////////////////////////////////////////
//v3.6 2008.8.18
//v3.6 2010.1.22
void SC_pac_ex1::copy_cfi_sc_ex1(inst_t * curinst)
{
#if 0					//bixiong
	unsigned long udst;

	udst = regfile_read(curinst->Rd1_Addr, curinst->Rd1_Type);
	udst = udst & 0xffff0000;
	regfile_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst);
#else
	regfile_write(curinst->Rd1_Addr, curinst->Rd1_Type,
				  (unsigned int) cfu_resp);
#endif
}

void SC_pac_ex1::adsr_au_ex1(inst_t * curinst)
{
#if 0
	unsigned long long udst, usrc1, usrc2;
	unsigned char sbit;

	sbit = psr_read(0, PSR_SATS);

	if (curinst->Rs1_Type != Reg_AC)
		usrc1 = (long) regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	else
		usrc1 = regfile_l_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	if (curinst->Rd1_Type != Reg_AC)
		usrc2 = (long) regfile_read(curinst->Rd1_Addr, curinst->Rd1_Type);
	else
		usrc2 = regfile_l_read(curinst->Rd1_Addr, curinst->Rd1_Type);

	udst = (long long) usrc1 + (long long) usrc2;

	// detect carry
	curinst->WB_Data = detect_carry(udst, usrc1, usrc2);
	// detect overflow
	curinst->WB_Data1 = detect_overflow(udst, usrc1, usrc2);

	if (sbit == 1 && curinst->WB_Data1 == 1) {
		if ((long) usrc1 < 0)
			udst = (long) 0x80000000;
		else
			udst = 0x7fffffff;
		curinst->WB_Data = 0;
		curinst->WB_Data1 = 0;
	}

	psr_write(0, PSR_CA, 0);
	psr_write(0, PSR_OV, curinst->WB_Data1);

	udst = ((long long) udst) >> (curinst->Imm32 & 0x3f);
	curinst->WB_Data = udst;
	curinst->WB_Data1 = udst >> 32;
#else
	unsigned long long udst, usrc1, usrc2;
	unsigned char sbit;
	int psr_idx;

	if (cluster_idx == 1 || cluster_idx == 3)
		psr_idx = 1;
	else
		psr_idx = 0;

	sbit = psr_read(psr_idx, PSR_SATS);

	if (curinst->Rs1_Type != Reg_AC)
		usrc1 = (int) regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	else
		usrc1 = regfile_l_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	if (curinst->Rd1_Type != Reg_AC)
		usrc2 = (int) regfile_read(curinst->Rd1_Addr, curinst->Rd1_Type);
	else
		usrc2 = regfile_l_read(curinst->Rd1_Addr, curinst->Rd1_Type);

	udst = (long long) usrc1 + (long long) usrc2;

	// detect carry
	curinst->WB_Data = detect_carry(udst, usrc1, usrc2);
	// detect overflow
	curinst->WB_Data1 = detect_overflow(udst, usrc1, usrc2);
	if (sbit == 1 && curinst->WB_Data1 == 1) {
		if ((int) usrc1 < 0)
			udst = (int) 0x80000000;
		else
			udst = 0x7fffffff;
	}
	if (sbit == 1) {
		curinst->WB_Data = 0;
		curinst->WB_Data1 = 0;
	}
	psr_write(psr_idx, PSR_CA, curinst->WB_Data);
	psr_write(psr_idx, PSR_OV, curinst->WB_Data1);

	if (cluster_idx == 2 || cluster_idx == 4)
		udst = ((long long) udst) >> (curinst->Imm32 & 0x3f);
	else
		udst = ((int) udst) >> (curinst->Imm32 & 0x3f);
	curinst->WB_Data = udst;
	curinst->WB_Data1 = udst >> 32;
#endif
}

void SC_pac_ex1::adsru_au_ex1(inst_t * curinst)
{
#if 0
	unsigned long long udst, usrc1, usrc2;
	unsigned char sbit;

	sbit = psr_read(0, PSR_SATS);

	if (curinst->Rs1_Type != Reg_AC)
		usrc1 =
			(unsigned long) regfile_read(curinst->Rs1_Addr,
										 curinst->Rs1_Type);
	else
		usrc1 = regfile_l_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	if (curinst->Rd1_Type != Reg_AC)
		usrc2 =
			(unsigned long) regfile_read(curinst->Rd1_Addr,
										 curinst->Rd1_Type);
	else
		usrc2 = regfile_l_read(curinst->Rd1_Addr, curinst->Rd1_Type);

	udst = usrc1 + usrc2;

	// detect carry
	curinst->WB_Data = detect_carry(udst, usrc1, usrc2);

	if (sbit == 1 && curinst->WB_Data == 1) {
		udst = 0xffffffff;
		curinst->WB_Data = 0;
	}

	psr_write(0, PSR_CA, curinst->WB_Data);

	udst = (udst) >> (curinst->Imm32 & 0x3f);
	curinst->WB_Data = udst;
	curinst->WB_Data1 = udst >> 32;
#else
	unsigned long long udst, usrc1, usrc2;
	unsigned char sbit;
	int psr_idx;

	if (cluster_idx == 1 || cluster_idx == 3)
		psr_idx = 1;
	else
		psr_idx = 0;
	sbit = psr_read(psr_idx, PSR_SATS);

	if (curinst->Rs1_Type != Reg_AC)
		usrc1 =
			(unsigned int) regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	else
		usrc1 = regfile_l_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	if (curinst->Rd1_Type != Reg_AC)
		usrc2 =
			(unsigned int) regfile_read(curinst->Rd1_Addr, curinst->Rd1_Type);
	else
		usrc2 = regfile_l_read(curinst->Rd1_Addr, curinst->Rd1_Type);

	udst = usrc1 + usrc2;

	// detect carry
	curinst->WB_Data = detect_carry(udst, usrc1, usrc2);

	if (sbit == 1 && curinst->WB_Data == 1) {
		udst = 0xffffffff;
	}
	if (sbit == 1)
		curinst->WB_Data = 0;

	psr_write(psr_idx, PSR_CA, curinst->WB_Data);

	if (cluster_idx == 2 || cluster_idx == 4)
		udst = (udst) >> (curinst->Imm32 & 0x3f);
	else
		udst = (unsigned int) (udst) >> (curinst->Imm32 & 0x3f);
	curinst->WB_Data = udst;
	curinst->WB_Data1 = udst >> 32;
#endif
}

void SC_pac_ex1::adsrd_au_ex1(inst_t * curinst)
{
#if 0
	unsigned long udst1, udst2, usrc1, usrc2;
	unsigned char sbit = psr_read(0, PSR_SATD);

	usrc1 = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	usrc2 = regfile_read(curinst->Rd1_Addr, curinst->Rd1_Type);

	udst1 = (short) (usrc1 >> 16) + (short) (usrc2 >> 16);
	udst2 = (short) LOW16MASK(usrc1) + (short) LOW16MASK(usrc2);

	// detect overflow
	curinst->WB_Data = detect_overflow16(udst1, udst2, usrc1, usrc2);
	if (sbit == 1) {
		if ((long) udst1 > 0x7fff)
			udst1 = 0x7fff;
		else if ((long) udst1 < -(0x8000))
			udst1 = 0x8000;

		if ((long) udst2 > 0x7fff)
			udst2 = 0x7fff;
		else if ((long) udst2 < -(0x8000))
			udst2 = 0x8000;

		curinst->WB_Data1 = 0;
	}
	udst1 = (short) (udst1) >> (curinst->Imm32 & 0x1f);
	udst2 = (short) (udst2) >> (curinst->Imm32 & 0x1f);
	curinst->WB_Data = (udst1 << 16) | LOW16MASK(udst2);
	psr_write(0, PSR_OV, curinst->WB_Data1);
#else
	unsigned int udst1, udst2, usrc1, usrc2;
	int psr_idx;
	unsigned char sbit;

	if (cluster_idx == 1 || cluster_idx == 3)
		psr_idx = 1;
	else
		psr_idx = 0;

	sbit = psr_read(psr_idx, PSR_SATD);
	usrc1 = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	usrc2 = regfile_read(curinst->Rd1_Addr, curinst->Rd1_Type);

	udst1 = (short) (usrc1 >> 16) + (short) (usrc2 >> 16);
	udst2 = (short) LOW16MASK(usrc1) + (short) LOW16MASK(usrc2);

	// detect overflow
	curinst->WB_Data1 = detect_overflow16(udst1, udst2, usrc1, usrc2);
	if (sbit == 1) {
		if ((int) udst1 > 0x7fff)
			udst1 = 0x7fff;
		else if ((int) udst1 < -(0x8000))
			udst1 = 0x8000;

		if ((int) udst2 > 0x7fff)
			udst2 = 0x7fff;
		else if ((int) udst2 < -(0x8000))
			udst2 = 0x8000;

		curinst->WB_Data1 = 0;
	}
	if (cluster_idx == 2 || cluster_idx == 4)
		udst1 = (udst1) >> (curinst->Imm32 & 0x1f);
	else
		udst1 = (short) (udst1) >> (curinst->Imm32 & 0x1f);
	udst2 = (short) (udst2) >> (curinst->Imm32 & 0x1f);
	curinst->WB_Data = (udst1 << 16) | LOW16MASK(udst2);
	psr_write(psr_idx, PSR_OV, curinst->WB_Data1);
#endif
}

void SC_pac_ex1::adsrud_au_ex1(inst_t * curinst)
{
#if 0
	unsigned long udst1, udst2, usrc1, usrc2;
	unsigned char sbit = psr_read(0, PSR_SATD);

	usrc1 = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	usrc2 = regfile_read(curinst->Rd1_Addr, curinst->Rd1_Type);

	udst1 = (usrc1 >> 16) + (usrc2 >> 16);
	udst2 = LOW16MASK(usrc1) + LOW16MASK(usrc2);

	if (sbit == 1) {
		if (udst1 > 0xffff)
			udst1 = 0xffff;
		if (udst2 > 0xffff)
			udst2 = 0xffff;
		curinst->WB_Data1 = 0;
	}
	udst1 = (unsigned short) (udst1) >> (curinst->Imm32 & 0x1f);
	udst2 = (unsigned short) (udst2) >> (curinst->Imm32 & 0x1f);
	curinst->WB_Data = (udst1 << 16) | LOW16MASK(udst2);
#else
	unsigned int udst1, udst2, usrc1, usrc2;
	int psr_idx;
	unsigned char sbit;

	if (cluster_idx == 1 || cluster_idx == 3)
		psr_idx = 1;
	else
		psr_idx = 0;

	sbit = psr_read(psr_idx, PSR_SATD);
	usrc1 = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	usrc2 = regfile_read(curinst->Rd1_Addr, curinst->Rd1_Type);

	udst1 = (usrc1 >> 16) + (usrc2 >> 16);
	udst2 = LOW16MASK(usrc1) + LOW16MASK(usrc2);

	if (sbit == 1) {
		if (udst1 > 0xffff)
			udst1 = 0xffff;
		if (udst2 > 0xffff)
			udst2 = 0xffff;
		curinst->WB_Data1 = 0;
	}
	if (cluster_idx == 2 || cluster_idx == 4)
		udst1 = (udst1) >> (curinst->Imm32 & 0x1f);
	else
		udst1 = (ushort) (udst1) >> (curinst->Imm32 & 0x1f);
	udst2 = (ushort) (udst2) >> (curinst->Imm32 & 0x1f);
	curinst->WB_Data = (udst1 << 16) | LOW16MASK(udst2);
#endif
}

////////////////////////////////////////////////////////////////////////////////////////////////
//v3.6 2009.12.1
void SC_pac_ex1::adsrf_au_ex1(inst_t * curinst)
{
#if 0
	unsigned long long udst, usrc1, usrc2;
	unsigned char sbit;
	int psr_idx;

	if (cluster_idx == 1 || cluster_idx == 3)
		psr_idx = 1;
	else
		psr_idx = 0;

	sbit = psr_read(psr_idx, PSR_SATS);

	if (curinst->Rd1_Type != Reg_AC)
		usrc2 = (long) regfile_read(curinst->Rd1_Addr, curinst->Rd1_Type);
	else
		usrc2 = regfile_l_read(curinst->Rd1_Addr, curinst->Rd1_Type);

	usrc1 = 1 << ((curinst->Imm32 & 0x3f) - 1);

	udst = (long long) usrc1 + (long long) usrc2;

	// detect carry
	curinst->WB_Data = detect_carry(udst, usrc1, usrc2);
	// detect overflow
	curinst->WB_Data1 = detect_overflow(udst, usrc1, usrc2);

	if (sbit == 1 && curinst->WB_Data1 == 1) {
		if ((long) usrc1 < 0)
			udst = (long) 0x80000000;
		else
			udst = 0x7fffffff;
		curinst->WB_Data = 0;
		curinst->WB_Data1 = 0;
	}

	psr_write(psr_idx, PSR_CA, 0);
	psr_write(psr_idx, PSR_OV, curinst->WB_Data1);

	udst = ((long long) udst) >> (curinst->Imm32 & 0x3f);
	curinst->WB_Data = udst;
	curinst->WB_Data1 = udst >> 32;
#else
	unsigned long long udst, usrc1, usrc2;
	unsigned char sbit;
	int psr_idx;

	if (cluster_idx == 1 || cluster_idx == 3)
		psr_idx = 1;
	else
		psr_idx = 0;

	sbit = psr_read(psr_idx, PSR_SATS);

	if (curinst->Rd1_Type != Reg_AC)
		usrc2 = (int) regfile_read(curinst->Rd1_Addr, curinst->Rd1_Type);
	else
		usrc2 = regfile_l_read(curinst->Rd1_Addr, curinst->Rd1_Type);

	usrc1 = (unsigned long long) 1 << ((curinst->Imm32 & 0x3f) - 1);

	udst = (long long) usrc1 + (long long) usrc2;

	// detect carry
	curinst->WB_Data = detect_carry(udst, usrc1, usrc2);
	// detect overflow
	curinst->WB_Data1 = detect_overflow(udst, usrc1, usrc2);

	if (sbit == 1 && curinst->WB_Data1 == 1) {
		if ((int) usrc1 < 0)
			udst = (int) 0x80000000;
		else
			udst = 0x7fffffff;
	}
	if (sbit == 1) {
		curinst->WB_Data = 0;
		curinst->WB_Data1 = 0;
	}
	psr_write(psr_idx, PSR_CA, curinst->WB_Data);
	psr_write(psr_idx, PSR_OV, curinst->WB_Data1);

	if (cluster_idx == 2 || cluster_idx == 4)
		udst = (udst) >> (curinst->Imm32 & 0x3f);
	else
		udst = (int) (udst) >> (curinst->Imm32 & 0x3f);
	curinst->WB_Data = udst;
	curinst->WB_Data1 = udst >> 32;
#endif
}

void SC_pac_ex1::adsrfu_au_ex1(inst_t * curinst)
{
#if 0
	unsigned long long udst, usrc1, usrc2;
	unsigned char sbit;
	int psr_idx;

	if (cluster_idx == 1 || cluster_idx == 3)
		psr_idx = 1;
	else
		psr_idx = 0;

	sbit = psr_read(psr_idx, PSR_SATS);

	if (curinst->Rd1_Type != Reg_AC)
		usrc2 =
			(unsigned long) regfile_read(curinst->Rd1_Addr,
										 curinst->Rd1_Type);
	else
		usrc2 = regfile_l_read(curinst->Rd1_Addr, curinst->Rd1_Type);

	usrc1 = 1 << ((curinst->Imm32 & 0x3f) - 1);

	udst = usrc1 + usrc2;

	// detect carry
	curinst->WB_Data = detect_carry(udst, usrc1, usrc2);

	if (sbit == 1 && curinst->WB_Data == 1) {
		udst = 0xffffffff;
		curinst->WB_Data = 0;
	}

	psr_write(psr_idx, PSR_CA, curinst->WB_Data);

	udst = (udst) >> (curinst->Imm32 & 0x3f);
	curinst->WB_Data = udst;
	curinst->WB_Data1 = udst >> 32;
#else
	unsigned long long udst, usrc1, usrc2;
	unsigned char sbit;
	int psr_idx;

	if (cluster_idx == 1 || cluster_idx == 3)
		psr_idx = 1;
	else
		psr_idx = 0;

	sbit = psr_read(psr_idx, PSR_SATS);

	if (curinst->Rd1_Type != Reg_AC)
		usrc2 =
			(unsigned int) regfile_read(curinst->Rd1_Addr, curinst->Rd1_Type);
	else
		usrc2 = regfile_l_read(curinst->Rd1_Addr, curinst->Rd1_Type);

	usrc1 = (unsigned long long) 1 << ((curinst->Imm32 & 0x3f) - 1);

	udst = usrc1 + usrc2;

	// detect carry
	curinst->WB_Data = detect_carry(udst, usrc1, usrc2);

	if (sbit == 1 && curinst->WB_Data == 1) {
		udst = 0xffffffff;
	}
	if (sbit == 1)
		curinst->WB_Data = 0;

	psr_write(psr_idx, PSR_CA, curinst->WB_Data);
	if (cluster_idx == 2 || cluster_idx == 4)
		udst = (udst) >> (curinst->Imm32 & 0x3f);
	else
		udst = (unsigned int) (udst) >> (curinst->Imm32 & 0x3f);

	curinst->WB_Data = udst;
	curinst->WB_Data1 = udst >> 32;
#endif
}

void SC_pac_ex1::adsrfd_au_ex1(inst_t * curinst)
{
#if 0
	unsigned long udst1, udst2, usrc1, usrc2;
	unsigned char sbit;
	int psr_idx;

	if (cluster_idx == 1 || cluster_idx == 3)
		psr_idx = 1;
	else
		psr_idx = 0;

	sbit = psr_read(psr_idx, PSR_SATD);

	usrc1 = 1 << ((curinst->Imm32 & 0x1f) - 1);
	usrc2 = regfile_read(curinst->Rd1_Addr, curinst->Rd1_Type);

	udst1 = (short) (usrc1) + (short) (usrc2 >> 16);
	udst2 = (short) (usrc1) + (short) LOW16MASK(usrc2);

	// detect overflow
	curinst->WB_Data = detect_overflow16(udst1, udst2, usrc1, usrc2);
	if (sbit == 1) {
		if ((long) udst1 > 0x7fff)
			udst1 = 0x7fff;
		else if ((long) udst1 < -(0x8000))
			udst1 = 0x8000;

		if ((long) udst2 > 0x7fff)
			udst2 = 0x7fff;
		else if ((long) udst2 < -(0x8000))
			udst2 = 0x8000;

		curinst->WB_Data1 = 0;
	}
	udst1 = (short) (udst1) >> (curinst->Imm32 & 0x1f);
	udst2 = (short) (udst2) >> (curinst->Imm32 & 0x1f);
	curinst->WB_Data = (udst1 << 16) | LOW16MASK(udst2);
	psr_write(psr_idx, PSR_OV, curinst->WB_Data1);
#else
	unsigned int udst1, udst2, usrc1, usrc2;
	unsigned char sbit;
	int psr_idx;

	if (cluster_idx == 1 || cluster_idx == 3)
		psr_idx = 1;
	else
		psr_idx = 0;

	sbit = psr_read(psr_idx, PSR_SATD);

	usrc1 = (unsigned long long) 1 << ((curinst->Imm32 & 0x1f) - 1);
	usrc2 = regfile_read(curinst->Rd1_Addr, curinst->Rd1_Type);

	udst1 = (short) (usrc1) + (short) (usrc2 >> 16);
	udst2 = (short) (usrc1) + (short) LOW16MASK(usrc2);

	// detect overflow
	curinst->WB_Data1 = detect_overflow16(udst1, udst2, usrc1, usrc2);
	if (sbit == 1) {
		if ((int) udst1 > 0x7fff)
			udst1 = 0x7fff;
		else if ((int) udst1 < -(0x8000))
			udst1 = 0x8000;

		if ((int) udst2 > 0x7fff)
			udst2 = 0x7fff;
		else if ((int) udst2 < -(0x8000))
			udst2 = 0x8000;

		curinst->WB_Data1 = 0;
	}
	if (cluster_idx == 2 || cluster_idx == 4)
		udst1 = (int) (udst1) >> (curinst->Imm32 & 0x1f);
	else
		udst1 = (short) (udst1) >> (curinst->Imm32 & 0x1f);
	udst2 = (short) (udst2) >> (curinst->Imm32 & 0x1f);
	curinst->WB_Data = (udst1 << 16) | LOW16MASK(udst2);
	psr_write(psr_idx, PSR_OV, curinst->WB_Data1);
#endif
}

void SC_pac_ex1::adsrfud_au_ex1(inst_t * curinst)
{
#if 0
	unsigned long udst1, udst2, usrc1, usrc2;
	unsigned char sbit;
	int psr_idx;

	if (cluster_idx == 1 || cluster_idx == 3)
		psr_idx = 1;
	else
		psr_idx = 0;

	sbit = psr_read(psr_idx, PSR_SATD);

	usrc1 = 1 << ((curinst->Imm32 & 0x1f) - 1);
	usrc2 = regfile_read(curinst->Rd1_Addr, curinst->Rd1_Type);

	udst1 = (usrc1) + (usrc2 >> 16);
	udst2 = (usrc1) + LOW16MASK(usrc2);

	if (sbit == 1) {
		if (udst1 > 0xffff)
			udst1 = 0xffff;
		if (udst2 > 0xffff)
			udst2 = 0xffff;
		curinst->WB_Data1 = 0;
	}
	udst1 = (unsigned short) (udst1) >> (curinst->Imm32 & 0x1f);
	udst2 = (unsigned short) (udst2) >> (curinst->Imm32 & 0x1f);
	curinst->WB_Data = (udst1 << 16) | LOW16MASK(udst2);
#else
	unsigned int udst1, udst2, usrc1, usrc2;
	unsigned char sbit;
	int psr_idx;

	if (cluster_idx == 1 || cluster_idx == 3)
		psr_idx = 1;
	else
		psr_idx = 0;

	sbit = psr_read(psr_idx, PSR_SATD);

	usrc1 = 1 << ((curinst->Imm32 & 0x1f) - 1);
	usrc2 = regfile_read(curinst->Rd1_Addr, curinst->Rd1_Type);

	udst1 = (usrc1) + (usrc2 >> 16);
	udst2 = (usrc1) + LOW16MASK(usrc2);

	if (sbit == 1) {
		if (udst1 > 0xffff)
			udst1 = 0xffff;
		if (udst2 > 0xffff)
			udst2 = 0xffff;
		curinst->WB_Data1 = 0;
	}
	if (cluster_idx == 2 || cluster_idx == 4)
		udst1 = (udst1) >> (curinst->Imm32 & 0x1f);
	else
		udst1 = (unsigned short) (udst1) >> (curinst->Imm32 & 0x1f);
	udst2 = (unsigned short) (udst2) >> (curinst->Imm32 & 0x1f);
	curinst->WB_Data = (udst1 << 16) | LOW16MASK(udst2);
#endif
}

////////////////////////////////////////////////
//v 3.6 clip 2010/7/7

void SC_pac_ex1::clip_au_ex1(inst_t * curinst)
{
	long long dst2, src1, src2;

	if (curinst->Rs1_Type != Reg_AC)
		src1 = (int) regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	else
		src1 =
			(long long) regfile_l_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	if (curinst->Rs2_Type != Reg_AC)
		src2 = (int) regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);
	else
		src2 =
			(long long) regfile_l_read(curinst->Rs2_Addr, curinst->Rs2_Type);
	if (curinst->Rd1_Type != Reg_AC)
		dst2 = (int) regfile_read(curinst->Rd1_Addr, curinst->Rd1_Type);
	else
		dst2 =
			(long long) regfile_l_read(curinst->Rd1_Addr, curinst->Rd1_Type);

	if (dst2 > src1)
		dst2 = src1;
	else if (dst2 < src2)
		dst2 = src2;

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, dst2);
}

void SC_pac_ex1::clipd_au_ex1(inst_t * curinst)
{
	int dst2, src1, src2;
	short s1, s2, d1;

	src1 = (int) regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	src2 = (int) regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);
	dst2 = (int) regfile_read(curinst->Rd1_Addr, curinst->Rd1_Type);

	s1 = src1 & 0xFFFF;
	s2 = src2 & 0xFFFF;
	d1 = dst2 & 0xFFFF;
	if (d1 > s1)
		d1 = s1;
	else if (d1 < s2)
		d1 = s2;

	src1 = src1 & 0xFFFF0000;
	src2 = src2 & 0xFFFF0000;
	dst2 = dst2 & 0xFFFF0000;
	if (dst2 > src1)
		dst2 = src1;
	else if (dst2 < src2)
		dst2 = src2;
	dst2 |= (int) (d1 & 0xFFFF);
	regfile_write(curinst->Rd1_Addr, curinst->Rd1_Type, dst2);
}


void SC_pac_ex1::clipu_au_ex1(inst_t * curinst)
{
	unsigned long long dst2, src1, src2;

	if (curinst->Rs1_Type != Reg_AC)
		src1 = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	else
		src1 = regfile_l_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	if (curinst->Rs2_Type != Reg_AC)
		src2 = regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);
	else
		src2 = regfile_l_read(curinst->Rs2_Addr, curinst->Rs2_Type);
	if (curinst->Rd1_Type != Reg_AC)
		dst2 = regfile_read(curinst->Rd1_Addr, curinst->Rd1_Type);
	else
		dst2 = regfile_l_read(curinst->Rd1_Addr, curinst->Rd1_Type);

	if (dst2 > src1)
		dst2 = src1;
	else if (dst2 < src2)
		dst2 = src2;
	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, dst2);
}

void SC_pac_ex1::clipud_au_ex1(inst_t * curinst)
{
	unsigned int dst2, src1, src2;
	unsigned short s1, s2, d1;

	src1 = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	src2 = regfile_read(curinst->Rs2_Addr, curinst->Rs2_Type);
	dst2 = regfile_read(curinst->Rd1_Addr, curinst->Rd1_Type);

	s1 = src1 & 0xFFFF;
	s2 = src2 & 0xFFFF;
	d1 = dst2 & 0xFFFF;
	if (d1 > s1)
		d1 = s1;
	else if (d1 < s2)
		d1 = s2;

	src1 = src1 & 0xFFFF0000;
	src2 = src2 & 0xFFFF0000;
	dst2 = dst2 & 0xFFFF0000;
	if (dst2 > src1)
		dst2 = src1;
	else if (dst2 < src2)
		dst2 = src2;
	dst2 |= (unsigned int) (d1 & 0xFFFF);
	regfile_write(curinst->Rd1_Addr, curinst->Rd1_Type, dst2);
}

void SC_pac_ex1::invalid_inst(inst_t * curinst)
{
	fprintf(stderr, "Invalid instrution, opcode : %d\n", curinst->op);
}

void SC_pac_ex1::nop_inst(inst_t * curinst)
{
	return;
}

void SC_pac_ex1::regfile_write(unsigned char num, unsigned char type, unsigned int data)
{
	dsp_core->regfile_write(num, type, data);
}

void SC_pac_ex1::regfile_l_write(unsigned char num, unsigned char type, unsigned long long data)
{
	dsp_core->regfile_l_write(num, type, data);
}

unsigned int SC_pac_ex1::regfile_read(unsigned char num, unsigned char type)
{
	return dsp_core->regfile_read(num, type);
}

unsigned char SC_pac_ex1::cp_read(unsigned char addr)
{
	return dsp_core->cp_read(addr);
}

unsigned char SC_pac_ex1::psr_read(unsigned char idx, unsigned char type)
{
	return dsp_core->psr_read(idx, type);
}

void SC_pac_ex1::psr_write(unsigned char idx, unsigned char type, unsigned char data)
{
	dsp_core->psr_write(idx, type, data);
}

unsigned long long SC_pac_ex1::regfile_l_read(unsigned char num, unsigned char type)
{
	return dsp_core->regfile_l_read(num, type);
}

unsigned int SC_pac_ex1::detect_carry(unsigned long long uldst, unsigned long long ulsrc1, unsigned long long ulsrc2)
{
	return dsp_core->detect_carry(uldst, ulsrc1, ulsrc2);
}

unsigned int SC_pac_ex1::detect_overflow(unsigned long long uldst, unsigned long long ulsrc1, unsigned long long ulsrc2)
{
	return dsp_core->detect_overflow(uldst, ulsrc1, ulsrc2);
}

unsigned char SC_pac_ex1::psr_read_addv(unsigned char idx, int dummy)
{
	return dsp_core->psr_read_addv(idx, dummy);
}

unsigned char SC_pac_ex1::psr_read_addc(unsigned char idx, int dummy)
{
	return dsp_core->psr_read_addc(idx, dummy);
}

unsigned int SC_pac_ex1::detect_overflow_sub(unsigned long long uldst, unsigned long long ulsrc1, unsigned long long ulsrc2)
{
	return dsp_core->detect_overflow_sub(uldst, ulsrc1, ulsrc2);
}

unsigned int SC_pac_ex1::detect_overflow16(unsigned int udst1, unsigned int udst2, unsigned int usrc1, unsigned int usrc2)
{
	return dsp_core->detect_overflow16(udst1, udst2, usrc1, usrc2);
}

unsigned int SC_pac_ex1::detect_overflow16_sub(unsigned int udst1, unsigned int udst2, unsigned int usrc1, unsigned int usrc2)
{
	return dsp_core->detect_overflow16_sub(udst1, udst2, usrc1, usrc2);
}

unsigned int SC_pac_ex1::detect_overflow8(unsigned int udst1, unsigned int udst2, unsigned int udst3, unsigned int udst4, unsigned int usrc1, unsigned int usrc2)
{
	return dsp_core->detect_overflow8(udst1, udst2, udst3, udst4, usrc1, usrc2);
}

unsigned int SC_pac_ex1::detect_overflow8_sub(unsigned int udst1, unsigned int udst2, unsigned int udst3, unsigned int udst4, unsigned int usrc1, unsigned int usrc2)
{
	return dsp_core->detect_overflow8_sub(udst1, udst2, udst3, udst4, usrc1, usrc2);
}

unsigned int SC_pac_ex1::ls_addr_gen(inst_t * curinst)
{
	return dsp_core->ls_addr_gen(curinst);
}

void SC_pac_ex1::sc_addr_gen(inst_t * curinst)
{
	return dsp_core->sc_addr_gen(curinst);
}

//////////////////////////////////////////////
// inst table
//
static pac_funcs ls_funcs_e1_t[256] = {
	SC_pac_ex1::nop_inst, SC_pac_ex1::abs_ls_ex1, SC_pac_ex1::absd_ls_ex1,
		SC_pac_ex1::absq_ls_ex1, SC_pac_ex1::add_ls_ex1, SC_pac_ex1::addd_ls_ex1,
		SC_pac_ex1::addds_ls_ex1, SC_pac_ex1::addq_ls_ex1,
		SC_pac_ex1::addqs_ls_ex1, SC_pac_ex1::addi_ls_ex1,
		SC_pac_ex1::addid_ls_ex1, SC_pac_ex1::addids_ls_ex1,
		SC_pac_ex1::addu_ls_ex1, SC_pac_ex1::addud_ls_ex1,
		SC_pac_ex1::adduds_ls_ex1, SC_pac_ex1::adduq_ls_ex1,
		SC_pac_ex1::adduqs_ls_ex1, SC_pac_ex1::mergea_ls_ex1,
		SC_pac_ex1::neg_ls_ex1, SC_pac_ex1::sub_ls_ex1, SC_pac_ex1::subd_ls_ex1,
		SC_pac_ex1::subds_ls_ex1, SC_pac_ex1::subq_ls_ex1,
		SC_pac_ex1::subqs_ls_ex1, SC_pac_ex1::subu_ls_ex1,
		//25
		SC_pac_ex1::subud_ls_ex1, SC_pac_ex1::subuds_ls_ex1,
		SC_pac_ex1::subuq_ls_ex1, SC_pac_ex1::subuqs_ls_ex1,
		SC_pac_ex1::addiud_ls_ex1, SC_pac_ex1::addiuds_ls_ex1,
		SC_pac_ex1::merges_ls_ex1, SC_pac_ex1::addc_ls_ex1,
		SC_pac_ex1::addcu_ls_ex1, SC_pac_ex1::adds_ls_ex1,
		SC_pac_ex1::subs_ls_ex1, SC_pac_ex1::dmax_ls_ex1,
		SC_pac_ex1::dmin_ls_ex1, SC_pac_ex1::max_ls_ex1, SC_pac_ex1::maxd_ls_ex1,
		SC_pac_ex1::maxq_ls_ex1, SC_pac_ex1::maxu_ls_ex1,
		SC_pac_ex1::maxud_ls_ex1, SC_pac_ex1::maxuq_ls_ex1,
		SC_pac_ex1::min_ls_ex1, SC_pac_ex1::mind_ls_ex1, SC_pac_ex1::minq_ls_ex1,
		SC_pac_ex1::minu_ls_ex1, SC_pac_ex1::minud_ls_ex1,
		SC_pac_ex1::minuq_ls_ex1,
		//50
		SC_pac_ex1::seq_ls_ex1, SC_pac_ex1::sgti_ls_ex1, SC_pac_ex1::slt_ls_ex1,
		SC_pac_ex1::slti_ls_ex1, SC_pac_ex1::sltu_ls_ex1,
		SC_pac_ex1::sltll_ls_ex1, SC_pac_ex1::slthh_ls_ex1,
		SC_pac_ex1::sltull_ls_ex1, SC_pac_ex1::sltuhh_ls_ex1,
		SC_pac_ex1::seqll_ls_ex1, SC_pac_ex1::seqhh_ls_ex1,
		SC_pac_ex1::seqi_ls_ex1, SC_pac_ex1::dminu_ls_ex1,
		SC_pac_ex1::dmaxu_ls_ex1, SC_pac_ex1::seqi_ls_ex1,
		SC_pac_ex1::sltiu_ls_ex1, SC_pac_ex1::sgtiu_ls_ex1,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::and_ls_ex1, SC_pac_ex1::andp_ls_ex1,
		SC_pac_ex1::extract_ls_ex1, SC_pac_ex1::extractu_ls_ex1,
		//75
		SC_pac_ex1::insert_ls_ex1, SC_pac_ex1::not_ls_ex1,
		SC_pac_ex1::notp_ls_ex1, SC_pac_ex1::or_ls_ex1, SC_pac_ex1::orp_ls_ex1,
		SC_pac_ex1::rol_ls_ex1, SC_pac_ex1::ror_ls_ex1, SC_pac_ex1::sll_ls_ex1,
		SC_pac_ex1::slld_ls_ex1, SC_pac_ex1::slli_ls_ex1,
		SC_pac_ex1::sllid_ls_ex1, SC_pac_ex1::sra_ls_ex1,
		SC_pac_ex1::srad_ls_ex1, SC_pac_ex1::srai_ls_ex1,
		SC_pac_ex1::sraid_ls_ex1, SC_pac_ex1::srl_ls_ex1,
		SC_pac_ex1::srld_ls_ex1, SC_pac_ex1::srli_ls_ex1,
		SC_pac_ex1::srlid_ls_ex1, SC_pac_ex1::xor_ls_ex1,
		SC_pac_ex1::xorp_ls_ex1, SC_pac_ex1::andi_ls_ex1, SC_pac_ex1::ori_ls_ex1,
		SC_pac_ex1::xori_ls_ex1, SC_pac_ex1::invalid_inst,
		//100
		SC_pac_ex1::invalid_inst, SC_pac_ex1::copy_ls_ex1, SC_pac_ex1::limbcp_ls_ex1, SC_pac_ex1::limbucp_ls_ex1, SC_pac_ex1::limhwcp_ls_ex1, SC_pac_ex1::limhwucp_ls_ex1, SC_pac_ex1::movih_ls_ex1, SC_pac_ex1::movil_ls_ex1, SC_pac_ex1::pack2_ls_ex1, SC_pac_ex1::pack4_ls_ex1, SC_pac_ex1::swap2_ls_ex1, SC_pac_ex1::swap4_ls_ex1, SC_pac_ex1::swap4e_ls_ex1, SC_pac_ex1::read_flag_sc_ex1, SC_pac_ex1::write_flag_sc_ex1,	/*invalid_inst, invalid_inst, *//* for v3.6 */
		SC_pac_ex1::unpack4_ls_ex1, SC_pac_ex1::unpack4u_ls_ex1,
		SC_pac_ex1::moviuh_ls_ex1, SC_pac_ex1::limwcp_ls_ex1,
		SC_pac_ex1::limwucp_ls_ex1, SC_pac_ex1::movi_ls_ex1,
		SC_pac_ex1::moviu_ls_ex1, SC_pac_ex1::copy_fc_ls_ex1,
		SC_pac_ex1::copy_fv_ls_ex1, SC_pac_ex1::set_cpi_ls_ex1,
		//125
		SC_pac_ex1::read_cpi_ls_ex1, SC_pac_ex1::permh2_ls_ex1,
		SC_pac_ex1::permh4_ls_ex1, SC_pac_ex1::copyu_ls_ex1,
		SC_pac_ex1::unpack2_ls_ex1, SC_pac_ex1::unpack2u_ls_ex1,
		SC_pac_ex1::dlh_ls_ex1, SC_pac_ex1::dlhu_ls_ex1, SC_pac_ex1::dlw_ls_ex1,
		SC_pac_ex1::dsb_ls_ex1, SC_pac_ex1::dsw_ls_ex1, SC_pac_ex1::lb_ls_ex1,
		SC_pac_ex1::lbu_ls_ex1, SC_pac_ex1::lh_ls_ex1, SC_pac_ex1::lhu_ls_ex1,
		SC_pac_ex1::lw_ls_ex1, SC_pac_ex1::lw_ls_ex1, SC_pac_ex1::sb_ls_ex1,
		SC_pac_ex1::sw_ls_ex1, SC_pac_ex1::lwu_ls_ex1, SC_pac_ex1::dlwu_ls_ex1,
		SC_pac_ex1::lwu_ls_ex1, SC_pac_ex1::dlw_ls_ex1, SC_pac_ex1::dlwu_ls_ex1,
		SC_pac_ex1::sw_ls_ex1,
		//150
		SC_pac_ex1::dsw_ls_ex1, SC_pac_ex1::sh_ls_ex1, SC_pac_ex1::invalid_inst, SC_pac_ex1::dsh_ls_ex1, SC_pac_ex1::invalid_inst, SC_pac_ex1::clip_au_ex1, SC_pac_ex1::clipd_au_ex1, SC_pac_ex1::clipu_au_ex1, SC_pac_ex1::clipud_au_ex1, SC_pac_ex1::invalid_inst,	// for v3.6 2010.7.7
		/* SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst, *//* for v3.6 liukai 2010.7.7 */
		SC_pac_ex1::invalid_inst, SC_pac_ex1::bdr_ls_ex1, SC_pac_ex1::bdt_ls_ex1,
		SC_pac_ex1::clr_ls_ex1, SC_pac_ex1::dbdr_ls_ex1, SC_pac_ex1::dbdt_ls_ex1,
		SC_pac_ex1::ddex_ls_ex1, SC_pac_ex1::dex_ls_ex1, SC_pac_ex1::lmbd_ls_ex1,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		//175
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst, SC_pac_ex1::dclr_ls_ex1, SC_pac_ex1::dex_ls_ex1, SC_pac_ex1::bdt_ls_ex1, SC_pac_ex1::adsr_au_ex1, SC_pac_ex1::adsrd_au_ex1, SC_pac_ex1::adsru_au_ex1,	/*invalid_inst, invalid_inst, invalid_inst, *//* v3.6, 2010.1.22 */
		SC_pac_ex1::adsrud_au_ex1, /*invalid_inst, v3.6 */
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		//200
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst,
		//225
		//invalid_inst, invalid_inst, invalid_inst, invalid_inst, invalid_inst,
		SC_pac_ex1::adsrf_au_ex1, SC_pac_ex1::adsrfu_au_ex1, SC_pac_ex1::adsrfd_au_ex1, SC_pac_ex1::adsrfud_au_ex1, SC_pac_ex1::nop_inst,	/* v3.6 2009.12.1 */
		SC_pac_ex1::invalid_inst, SC_pac_ex1::subus_ls_ex1,
		SC_pac_ex1::addcus_ls_ex1, SC_pac_ex1::addus_ls_ex1,
		SC_pac_ex1::addcs_ls_ex1, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::addis_ls_ex1,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		//250
SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,};

static pac_funcs au_funcs_e1_t[256] = {
	SC_pac_ex1::nop_inst, SC_pac_ex1::abs_ls_ex1, SC_pac_ex1::absd_ls_ex1,
		SC_pac_ex1::absq_ls_ex1, SC_pac_ex1::add_ls_ex1, SC_pac_ex1::addd_ls_ex1,
		SC_pac_ex1::addds_ls_ex1, SC_pac_ex1::addq_ls_ex1,
		SC_pac_ex1::addqs_ls_ex1, SC_pac_ex1::addi_ls_ex1,
		SC_pac_ex1::addid_ls_ex1, SC_pac_ex1::addids_ls_ex1,
		SC_pac_ex1::addu_ls_ex1, SC_pac_ex1::addud_ls_ex1,
		SC_pac_ex1::adduds_ls_ex1, SC_pac_ex1::adduq_ls_ex1,
		SC_pac_ex1::adduqs_ls_ex1, SC_pac_ex1::mergea_ls_ex1,
		SC_pac_ex1::neg_ls_ex1, SC_pac_ex1::sub_ls_ex1, SC_pac_ex1::subd_ls_ex1,
		SC_pac_ex1::subds_ls_ex1, SC_pac_ex1::subq_ls_ex1,
		SC_pac_ex1::subqs_ls_ex1, SC_pac_ex1::subu_ls_ex1,
		//25
		SC_pac_ex1::subud_ls_ex1, SC_pac_ex1::subuds_ls_ex1,
		SC_pac_ex1::subuq_ls_ex1, SC_pac_ex1::subuqs_ls_ex1,
		SC_pac_ex1::addiud_ls_ex1, SC_pac_ex1::addiuds_ls_ex1,
		SC_pac_ex1::merges_ls_ex1, SC_pac_ex1::addc_ls_ex1,
		SC_pac_ex1::addcu_ls_ex1, SC_pac_ex1::adds_ls_ex1,
		SC_pac_ex1::subs_ls_ex1, SC_pac_ex1::dmax_ls_ex1,
		SC_pac_ex1::dmin_ls_ex1, SC_pac_ex1::max_ls_ex1, SC_pac_ex1::maxd_ls_ex1,
		SC_pac_ex1::maxq_ls_ex1, SC_pac_ex1::maxu_ls_ex1,
		SC_pac_ex1::maxud_ls_ex1, SC_pac_ex1::maxuq_ls_ex1,
		SC_pac_ex1::min_ls_ex1, SC_pac_ex1::mind_ls_ex1, SC_pac_ex1::minq_ls_ex1,
		SC_pac_ex1::minu_ls_ex1, SC_pac_ex1::minud_ls_ex1,
		SC_pac_ex1::minuq_ls_ex1,
		//50
		SC_pac_ex1::seq_ls_ex1, SC_pac_ex1::sgti_ls_ex1, SC_pac_ex1::slt_ls_ex1,
		SC_pac_ex1::slti_ls_ex1, SC_pac_ex1::sltu_ls_ex1,
		SC_pac_ex1::sltll_ls_ex1, SC_pac_ex1::slthh_ls_ex1,
		SC_pac_ex1::sltull_ls_ex1, SC_pac_ex1::sltuhh_ls_ex1,
		SC_pac_ex1::seqll_ls_ex1, SC_pac_ex1::seqhh_ls_ex1,
		SC_pac_ex1::seqi_ls_ex1, SC_pac_ex1::dminu_ls_ex1,
		SC_pac_ex1::dmaxu_ls_ex1, SC_pac_ex1::seqi_ls_ex1,
		SC_pac_ex1::sltiu_ls_ex1, SC_pac_ex1::sgtiu_ls_ex1,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::and_ls_ex1, SC_pac_ex1::andp_ls_ex1,
		SC_pac_ex1::extract_ls_ex1, SC_pac_ex1::extractu_ls_ex1,
		//75
		SC_pac_ex1::insert_ls_ex1, SC_pac_ex1::not_ls_ex1,
		SC_pac_ex1::notp_ls_ex1, SC_pac_ex1::or_ls_ex1, SC_pac_ex1::orp_ls_ex1,
		SC_pac_ex1::rol_ls_ex1, SC_pac_ex1::ror_ls_ex1, SC_pac_ex1::sll_ls_ex1,
		SC_pac_ex1::slld_ls_ex1, SC_pac_ex1::slli_ls_ex1,
		SC_pac_ex1::sllid_ls_ex1, SC_pac_ex1::sra_ls_ex1,
		SC_pac_ex1::srad_ls_ex1, SC_pac_ex1::srai_ls_ex1,
		SC_pac_ex1::sraid_ls_ex1, SC_pac_ex1::srl_ls_ex1,
		SC_pac_ex1::srld_ls_ex1, SC_pac_ex1::srli_ls_ex1,
		SC_pac_ex1::srlid_ls_ex1, SC_pac_ex1::xor_ls_ex1,
		SC_pac_ex1::xorp_ls_ex1, SC_pac_ex1::andi_ls_ex1, SC_pac_ex1::ori_ls_ex1,
		SC_pac_ex1::xori_ls_ex1, SC_pac_ex1::invalid_inst,
		//100
		SC_pac_ex1::invalid_inst, SC_pac_ex1::copy_ls_ex1, SC_pac_ex1::limbcp_ls_ex1, SC_pac_ex1::limbucp_ls_ex1, SC_pac_ex1::limhwcp_ls_ex1, SC_pac_ex1::limhwucp_ls_ex1, SC_pac_ex1::movih_ls_ex1, SC_pac_ex1::movil_ls_ex1, SC_pac_ex1::pack2_ls_ex1, SC_pac_ex1::pack4_ls_ex1, SC_pac_ex1::swap2_ls_ex1, SC_pac_ex1::swap4_ls_ex1, SC_pac_ex1::swap4e_ls_ex1, SC_pac_ex1::read_flag_sc_ex1, SC_pac_ex1::write_flag_sc_ex1,	/*invalid_inst, invalid_inst, *//* for v3.6 */
		SC_pac_ex1::unpack4_ls_ex1, SC_pac_ex1::unpack4u_ls_ex1,
		SC_pac_ex1::moviuh_ls_ex1, SC_pac_ex1::limwcp_ls_ex1,
		SC_pac_ex1::limwucp_ls_ex1, SC_pac_ex1::movi_ls_ex1,
		SC_pac_ex1::moviu_ls_ex1, SC_pac_ex1::copy_fc_ls_ex1,
		SC_pac_ex1::copy_fv_ls_ex1, SC_pac_ex1::set_cpi_ls_ex1,
		//125
		SC_pac_ex1::read_cpi_ls_ex1, SC_pac_ex1::permh2_ls_ex1,
		SC_pac_ex1::permh4_ls_ex1, SC_pac_ex1::copyu_ls_ex1,
		SC_pac_ex1::unpack2_ls_ex1, SC_pac_ex1::unpack2u_ls_ex1,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst,
		//150
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst, SC_pac_ex1::clip_au_ex1, SC_pac_ex1::clipd_au_ex1, SC_pac_ex1::clipu_au_ex1, SC_pac_ex1::clipud_au_ex1, SC_pac_ex1::invalid_inst,	//for v3.6 2010.7.7
		/* SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst, *//* for v3.6 liukai 2010.7.7 */
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::clr_ls_ex1,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::sfra_au_ex1, SC_pac_ex1::sfrad_au_ex1,
		SC_pac_ex1::saaq_au_ex1, SC_pac_ex1::bf_au_ex1, SC_pac_ex1::bfd_au_ex1,
		//175
		SC_pac_ex1::cls_au_ex1, SC_pac_ex1::rnd_au_ex1, SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst, SC_pac_ex1::dclr_ls_ex1, SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst, SC_pac_ex1::adsr_au_ex1, SC_pac_ex1::adsrd_au_ex1, SC_pac_ex1::adsru_au_ex1,	/*invalid_inst, invalid_inst, invalid_inst, *//* v3.6 */
		SC_pac_ex1::adsrud_au_ex1, /*invalid_inst, v3.6 */
		SC_pac_ex1::fmul_au_ex1, SC_pac_ex1::fmuluu_au_ex1,
		SC_pac_ex1::fmulus_au_ex1, SC_pac_ex1::fmulsu_au_ex1,
		SC_pac_ex1::fmuld_au_ex1, SC_pac_ex1::fmuluud_au_ex1,
		SC_pac_ex1::fmulusd_au_ex1, SC_pac_ex1::fmulsud_au_ex1,
		SC_pac_ex1::muld_au_ex1, SC_pac_ex1::xmuld_au_ex1,
		SC_pac_ex1::fmac_au_ex1, SC_pac_ex1::fmacuu_au_ex1,
		SC_pac_ex1::fmacus_au_ex1, SC_pac_ex1::fmacsu_au_ex1,
		//200
		SC_pac_ex1::fmacd_au_ex1, SC_pac_ex1::fmacuud_au_ex1,
		SC_pac_ex1::fmacusd_au_ex1, SC_pac_ex1::fmacsud_au_ex1,
		SC_pac_ex1::macd_au_ex1, SC_pac_ex1::xmacd_au_ex1,
		SC_pac_ex1::xmacds_au_ex1, SC_pac_ex1::dotp2_au_ex1,
		SC_pac_ex1::mulds_au_ex1, SC_pac_ex1::xfmul_au_ex1,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::macds_au_ex1,
		SC_pac_ex1::msud_au_ex1, SC_pac_ex1::msuds_au_ex1,
		SC_pac_ex1::xfmac_au_ex1, SC_pac_ex1::xfmacd_au_ex1,
		SC_pac_ex1::xmsud_au_ex1, SC_pac_ex1::xmsuds_au_ex1,
		SC_pac_ex1::xdotp2_au_ex1, SC_pac_ex1::xfmuld_au_ex1,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst,
		//225
		//invalid_inst, invalid_inst, invalid_inst, invalid_inst, invalid_inst,
		SC_pac_ex1::adsrf_au_ex1, SC_pac_ex1::adsrfu_au_ex1, SC_pac_ex1::adsrfd_au_ex1, SC_pac_ex1::adsrfud_au_ex1, SC_pac_ex1::invalid_inst,	/*v3.6 2009.12.1 */
		SC_pac_ex1::invalid_inst, SC_pac_ex1::subus_ls_ex1,
		SC_pac_ex1::addcus_ls_ex1, SC_pac_ex1::addus_ls_ex1,
		SC_pac_ex1::addcs_ls_ex1, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::addis_ls_ex1,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		//250
SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,};

static pac_funcs sc_funcs_e1_t[256] = {
	SC_pac_ex1::nop_inst, SC_pac_ex1::abs_ls_ex1, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::add_ls_ex1,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::addi_ls_ex1, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::addu_ls_ex1,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::neg_ls_ex1, SC_pac_ex1::sub_ls_ex1,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst,
		//25
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::max_ls_ex1,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::maxu_ls_ex1, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::min_ls_ex1,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::minu_ls_ex1, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst,
		//50
		SC_pac_ex1::seq_ls_ex1, SC_pac_ex1::sgti_ls_ex1, SC_pac_ex1::slt_ls_ex1,
		SC_pac_ex1::slti_ls_ex1, SC_pac_ex1::sltu_ls_ex1,
		SC_pac_ex1::sltll_ls_ex1, SC_pac_ex1::slthh_ls_ex1,
		SC_pac_ex1::sltull_ls_ex1, SC_pac_ex1::sltuhh_ls_ex1,
		SC_pac_ex1::seqll_ls_ex1, SC_pac_ex1::seqhh_ls_ex1,
		SC_pac_ex1::seqi_ls_ex1, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::seqi_ls_ex1,
		SC_pac_ex1::sltiu_ls_ex1, SC_pac_ex1::sgtiu_ls_ex1,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::and_ls_ex1, SC_pac_ex1::andp_ls_ex1,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		//75
		SC_pac_ex1::invalid_inst, SC_pac_ex1::not_ls_ex1, SC_pac_ex1::notp_ls_ex1, SC_pac_ex1::or_ls_ex1, SC_pac_ex1::orp_ls_ex1, SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst, SC_pac_ex1::sll_ls_ex1, SC_pac_ex1::invalid_inst, SC_pac_ex1::slli_ls_ex1, SC_pac_ex1::invalid_inst, SC_pac_ex1::sra_ls_ex1, SC_pac_ex1::invalid_inst, SC_pac_ex1::srai_ls_ex1, SC_pac_ex1::invalid_inst, SC_pac_ex1::srl_ls_ex1, SC_pac_ex1::invalid_inst, SC_pac_ex1::srli_ls_ex1, SC_pac_ex1::invalid_inst, SC_pac_ex1::xor_ls_ex1, SC_pac_ex1::xorp_ls_ex1, SC_pac_ex1::andi_ls_ex1, SC_pac_ex1::ori_ls_ex1, SC_pac_ex1::xori_ls_ex1, SC_pac_ex1::copy_cfi_sc_ex1,	/* invalid_inst, *//* v3.6 2008.8.18 */
		//100
		SC_pac_ex1::invalid_inst, SC_pac_ex1::copy_ls_ex1,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::movih_ls_ex1, SC_pac_ex1::movil_ls_ex1,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::read_flag_sc_ex1,
		SC_pac_ex1::write_flag_sc_ex1, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::movi_ls_ex1, SC_pac_ex1::moviu_ls_ex1,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst,
		//125
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::lb_sc_ex1, SC_pac_ex1::lbu_sc_ex1,
		SC_pac_ex1::lh_sc_ex1, SC_pac_ex1::lhu_sc_ex1, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::lw_sc_ex1, SC_pac_ex1::sb_sc_ex1, SC_pac_ex1::sw_sc_ex1,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		//150
		SC_pac_ex1::invalid_inst, SC_pac_ex1::sh_sc_ex1,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::bdr_ls_ex1, SC_pac_ex1::bdt_ls_ex1,
		SC_pac_ex1::clr_ls_ex1, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::dex_ls_ex1, SC_pac_ex1::invalid_inst, SC_pac_ex1::nop_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst,
		//175
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::dclr_ls_ex1, SC_pac_ex1::dex_ls_ex1, SC_pac_ex1::bdt_ls_ex1,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		//200
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst,
		//225
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::lbcb_sc_ex1, SC_pac_ex1::test_sc_ex1,
		SC_pac_ex1::wait_sc_ex1, SC_pac_ex1::b_sc_ex1, SC_pac_ex1::br_sc_ex1,
		SC_pac_ex1::brr_sc_ex1, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		//250
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst, SC_pac_ex1::invalid_inst,
		SC_pac_ex1::invalid_inst,
		//255
SC_pac_ex1::invalid_inst,};

void SC_pac_ex1::sc_pac_ex1_run()
{
	int i, cur_op;
	unsigned char tmp;

	while(1) {
		regTBDT = 0;		// reset broadcast flag
		wait();
		if (ex1_pin.event())
		    dbg_step_flag = 1;
		
		// start running after ex2
		wait(SC_ZERO_TIME);
		//printf("%s wakeup\r\n", __func__);
		for (i = 0; i < INST_NO; i++) {
			if (exec_table[EX1_IDX].instr[i].inst.op == NOP) {
				exec_table[EX1_IDX].instr[i].execute = 0;
				continue;
			} else if ((exec_table[EX1_IDX].instr[i].inst.P_Addr) != (unsigned char) (-1)) {
				if (!  (regfile_read (exec_table[EX1_IDX].instr[i].inst.P_Addr, Reg_P))) {
					exec_table[EX1_IDX].instr[i].execute = 0;
					continue;
				}
			} else if ((i != 0) && (((regfile_read(12, Reg_CR) >> (i / 3)) & 0x1) == 0x1)) {	// Power Mode
				exec_table[EX1_IDX].instr[i].inst.op = NOP;
				exec_table[EX1_IDX].instr[i].execute = 0;
				continue;
			}

			exec_table[EX1_IDX].instr[i].execute = 1;

			cur_op = exec_table[EX1_IDX].instr[i].inst.op;
			cluster_idx = i;

			// if register type is cpp, translate it first.
			// Rd1
			if (exec_table[EX1_IDX].instr[i].inst.Rd1_Type == Reg_CPP) {
				tmp = cp_read(exec_table[EX1_IDX].instr[i].inst.Rd1_Addr);
				regfile_read(exec_table[EX1_IDX].instr[i].inst.Rd1_Addr, Reg_CPP);	// for updating CP register
				exec_table[EX1_IDX].instr[i].inst.Rd1_Addr = tmp & 0x7;
				exec_table[EX1_IDX].instr[i].inst.Rd1_Type = Reg_C;
			}
			// Rd2
			if ((cur_op == UNPACK2) || (cur_op == UNPACK2U) ||
				(cur_op == UNPACK4) || (cur_op == UNPACK4U) ||
				(cur_op == PERMH4) ||
				(cur_op == DLW) || (cur_op == DLWU) ||
				(cur_op == DLH) || (cur_op == DLHU) ||
				(cur_op == DBDR) || (cur_op == DDEX) || (cur_op == DCLR) ||
				(cur_op == FMULD) || (cur_op == FMULuuD) ||
				(cur_op == FMULusD) || (cur_op == FMULsuD) ||
				(cur_op == XFMULD) ||
				(cur_op == FMACD) || (cur_op == FMACuuD) ||
				(cur_op == FMACusD) || (cur_op == FMACsuD) ||
				(cur_op == XFMACD) ||
				(cur_op == BF) || (cur_op == BFD) || (cur_op == SAAQ)) {
				exec_table[EX1_IDX].instr[i].inst.Rd2_Addr =
					exec_table[EX1_IDX].instr[i].inst.Rd1_Addr + 1;
				exec_table[EX1_IDX].instr[i].inst.Rd2_Type =
					exec_table[EX1_IDX].instr[i].inst.Rd1_Type;
			} else {
				if (exec_table[EX1_IDX].instr[i].inst.Rd2_Type == Reg_CPP) {
					tmp = cp_read(exec_table[EX1_IDX].instr[i].inst.Rd2_Addr);
					regfile_read(exec_table[EX1_IDX].instr[i].inst.Rd2_Addr, Reg_CPP);	// for updating CP register
					exec_table[EX1_IDX].instr[i].inst.Rd2_Addr = tmp & 0x7;
					exec_table[EX1_IDX].instr[i].inst.Rd2_Type = Reg_C;
				}
			}
			// Rs1
			if (exec_table[EX1_IDX].instr[i].inst.Rs1_Type == Reg_CPP) {
				tmp = cp_read(exec_table[EX1_IDX].instr[i].inst.Rs1_Addr);
				regfile_read(exec_table[EX1_IDX].instr[i].inst.Rs1_Addr, Reg_CPP);	// for updating CP register
				exec_table[EX1_IDX].instr[i].inst.Rs1_Addr = tmp & 0x7;
				exec_table[EX1_IDX].instr[i].inst.Rs1_Type = Reg_C;
			}
			// Rs2
			if (exec_table[EX1_IDX].instr[i].inst.Rs2_Type == Reg_CPP) {
				tmp = cp_read(exec_table[EX1_IDX].instr[i].inst.Rs2_Addr);
				regfile_read(exec_table[EX1_IDX].instr[i].inst.Rs2_Addr, Reg_CPP);	// for updating CP register
				exec_table[EX1_IDX].instr[i].inst.Rs2_Addr = tmp & 0x7;
				exec_table[EX1_IDX].instr[i].inst.Rs2_Type = Reg_C;
			}
			// inst func call
			if (i == 1 || i == 3) {
//				(this->* ls_funcs_e1[cur_op]) (&(exec_table[EX1_IDX].instr[i].inst));
				ls_funcs_e1_t[cur_op](&(exec_table[EX1_IDX].instr[i].inst));
			} else if (i == 2 || i == 4) {
//				(this->* au_funcs_e1[cur_op]) (&(exec_table[EX1_IDX].instr[i].inst));
				au_funcs_e1_t[cur_op](&(exec_table[EX1_IDX].instr[i].inst));
			} else {
//				(this->* sc_funcs_e1[cur_op]) (&(exec_table[EX1_IDX].instr[i].inst));
				sc_funcs_e1_t[cur_op](&(exec_table[EX1_IDX].instr[i].inst));
			}
		}

		wait(SC_ZERO_TIME);
		
		if (dbg_step_flag) {	// debug single step
		    ex1_resp_event.notify();
		    dbg_step_flag = 0;
		} else {
		    mod_count++;
		    //printf("ex1 mod_count %d\r\n", mod_count);
		    if(mod_count == 5)
			mod_resp_event.notify();
		}
	}
}


