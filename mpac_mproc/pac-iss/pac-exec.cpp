#include "pac-dsp.h"
#include "sc-pac-memif.h"

unsigned char pac_dsp::psr_read_addv(unsigned char idx, int dummy)
{
	int i;
	unsigned char data;

	//printf("psr_read_addv WN_IDX %d WB_IDX %d\r\n",WB_IDX, WB_IDX);
	if (cluster_idx == 1 || cluster_idx == 2)
		idx += 1;
	else if (cluster_idx == 3 || cluster_idx == 4)
		idx += 3;
	else
		idx = 0;

	data = global_regs.PSR[idx][PSR_OV];
	for (i = 0; i < UPDATE_REGNUM(WB_IDX); i++) {
		if (WRITE_LOG(WB_IDX, i).type == Reg_PSR &&
			WRITE_LOG(WB_IDX, i).addr == (PSR_OV | (idx << 3))) {
			data = WRITE_LOG(WB_IDX, i).data;
			break;
		}
	}

	return data;
}

unsigned char pac_dsp::psr_read_addc(unsigned char idx, int dummy)
{
	int i;
	unsigned char data;

	//printf("psr_read_addc WN_IDX %d WB_IDX %d\r\n",WB_IDX, WB_IDX);
	if (cluster_idx == 1 || cluster_idx == 2)
		idx += 1;
	else if (cluster_idx == 3 || cluster_idx == 4)
		idx += 3;
	else
		idx = 0;

	data = global_regs.PSR[idx][PSR_CA];
	for (i = 0; i < UPDATE_REGNUM(WB_IDX); i++) {
		if (WRITE_LOG(WB_IDX, i).type == Reg_PSR &&
			WRITE_LOG(WB_IDX, i).addr == (PSR_CA | (idx << 3))) {
			data = WRITE_LOG(WB_IDX, i).data;
			break;
		}
	}

	return data;
}

unsigned char pac_dsp::psr_read(unsigned char idx, unsigned char type)
{
	assert(type <= PSR_Maxnum);

	if (cluster_idx == 1 || cluster_idx == 2)
		idx += 1;
	else if (cluster_idx == 3 || cluster_idx == 4)
		idx += 3;
	else
		idx = 0;

	return global_regs.PSR[idx][type];
}

void pac_dsp::psr_write(unsigned char idx, unsigned char type,
						 unsigned char data)
{
	int w_idx;

	assert(type <= PSR_Maxnum);

	//printf("psr_write WN_IDX %d WB_IDX %d\r\n",WB_IDX, WB_IDX);
	w_idx = EX1_IDX;

	if (cluster_idx == 1 || cluster_idx == 2)
		idx += 1;
	else if (cluster_idx == 3 || cluster_idx == 4)
		idx += 3;
	else
		idx = 0;

	WRITE_LOG_MAX(w_idx).type = Reg_PSR;
	WRITE_LOG_MAX(w_idx).addr = type | (idx << 3);
	WRITE_LOG_MAX(w_idx).data = (data == 0) ? 0 : 1;

	UPDATE_REGNUM(w_idx)++;
}

void pac_dsp::psr_write_stage3(unsigned char idx, unsigned char type,
								unsigned char data)
{
	int w_idx;

	assert(type <= PSR_Maxnum);

	//printf("psr_write_stage3 WN_IDX %d WB_IDX %d\r\n",WB_IDX, WB_IDX);
	w_idx = EX3_IDX;

	if (cluster_idx == 1 || cluster_idx == 2)
		idx += 1;
	else if (cluster_idx == 3 || cluster_idx == 4)
		idx += 3;
	else
		idx = 0;

	WRITE_LOG_MAX(w_idx).type = Reg_PSR;
	WRITE_LOG_MAX(w_idx).addr = type | (idx << 3);
	WRITE_LOG_MAX(w_idx).data = (data == 0) ? 0 : 1;
	UPDATE_REGNUM(w_idx)++;
}

void pac_dsp::cp_gen(unsigned char *num, unsigned char *type)
{
	unsigned int usrc, udst;
	unsigned char base, newbase, offset;

	//printf("cp_gen WN_IDX %d WB_IDX %d\r\n",WB_IDX, WB_IDX);
	usrc = (unsigned int) (global_regs.RF[Reg_CPP][*num]);

	base = usrc & 0x7;
	offset = (usrc >> 3) & 0xf;

	if (offset & 0x8)
		newbase = base - (~offset + 1);
	else
		newbase = base + offset;

	udst = newbase & 0x7;
	udst |= (offset << 3) & 0x78;

	WRITE_LOG_MAX(EX1_IDX).type = Reg_CP;
	WRITE_LOG_MAX(EX1_IDX).addr = *num;
	WRITE_LOG_MAX(EX1_IDX).data = udst;
	UPDATE_REGNUM(EX1_IDX)++;
	WRITE_LOG_MAX(EX1_IDX).type = Reg_CPP;
	WRITE_LOG_MAX(EX1_IDX).addr = *num;
	WRITE_LOG_MAX(EX1_IDX).data = udst;
	UPDATE_REGNUM(EX1_IDX)++;
	WRITE_LOG_MAX(EX2_IDX).type = Reg_CPP;
	WRITE_LOG_MAX(EX2_IDX).addr = *num;
	WRITE_LOG_MAX(EX2_IDX).data = udst;
	UPDATE_REGNUM(EX2_IDX)++;
	WRITE_LOG_MAX(EX3_IDX).type = Reg_CPP;
	WRITE_LOG_MAX(EX3_IDX).addr = *num;
	WRITE_LOG_MAX(EX3_IDX).data = udst;
	UPDATE_REGNUM(EX3_IDX)++;
	WRITE_LOG_MAX(WB_IDX).type = Reg_CPP;
	WRITE_LOG_MAX(WB_IDX).addr = *num;
	WRITE_LOG_MAX(WB_IDX).data = udst;
	UPDATE_REGNUM(WB_IDX)++;

	*type = Reg_C;
	*num = base;
	if (cluster_idx / 3)
		*num += 16;
}

void pac_dsp::regfile_write(unsigned char num, unsigned char type,
							 unsigned int data)
{
	int idx;

	assert(type <= Reg_Maxindex);
	assert(num <= Reg_Maxnum);

	//printf("regfile_write WN_IDX %d WB_IDX %d\r\n",WB_IDX, WB_IDX);
	idx = EX1_IDX;

	if (cluster_idx / 3 && type != Reg_P && type != Reg_R)
		num += 16;

	if (type == Reg_CPP)
		cp_gen(&num, &type);
	else if (type == Reg_CP) {
		WRITE_LOG_MAX(idx).type = Reg_CPP;
		WRITE_LOG_MAX(idx).addr = num;
		WRITE_LOG_MAX(idx).data = (unsigned long long) data;
		UPDATE_REGNUM(idx)++;
	}

	WRITE_LOG_MAX(idx).type = type;
	WRITE_LOG_MAX(idx).addr = num;
	WRITE_LOG_MAX(idx).data = (unsigned long long) data;
	UPDATE_REGNUM(idx)++;

	if (type == Reg_CR) {
		if ((num == 4) || (num == 5) || (num == 6) || (num == 7))
			sc_pac_memif_ptr_0->cfu_module(num, data);
	}
}

unsigned long long pac_dsp::regfile_l_read(unsigned char num,
											unsigned char type)
{
	assert(type <= Reg_Maxindex);
	assert(num <= Reg_Maxnum);

	if (cluster_idx / 3 && type != Reg_P && type != Reg_R)
		num += 16;

	if (type == Reg_CPP)
		cp_gen(&num, &type);

	if (type == Reg_CP || type == Reg_C || type == Reg_CR || type == Reg_AMCR)
		return global_regs.RF[type][num];
	else
		return ro_regs.RF[type][num];
}

void pac_dsp::regfile_l_write(unsigned char num, unsigned char type,
							   unsigned long long data)
{
	int idx;

	assert(type <= Reg_Maxindex);
	assert(num <= Reg_Maxnum);

	//printf("regfile_l_write WN_IDX %d WB_IDX %d\r\n",WB_IDX, WB_IDX);
	idx = EX1_IDX;
	if (cluster_idx / 3 && type != Reg_P && type != Reg_R)
		num += 16;

	if (type == Reg_CPP)
		cp_gen(&num, &type);
	else if (type == Reg_CP) {
		WRITE_LOG_MAX(idx).type = Reg_CPP;
		WRITE_LOG_MAX(idx).addr = num;
		WRITE_LOG_MAX(idx).data = data;
		UPDATE_REGNUM(idx)++;
	}

	WRITE_LOG_MAX(idx).type = type;
	WRITE_LOG_MAX(idx).addr = num;
	WRITE_LOG_MAX(idx).data = data;
	UPDATE_REGNUM(idx)++;

	if (type == Reg_CR) {
		if ((num == 4) || (num == 5) || (num == 6) || (num == 7))
			sc_pac_memif_ptr_0->cfu_module(num, data);
	}
}

void pac_dsp::stage3_l_write(unsigned char num, unsigned char type,
							  unsigned long long data)
{
	int i;
	int idx;

	assert(type <= Reg_Maxindex);
	assert(num <= Reg_Maxnum);

	//printf("stage3_l_write WN_IDX %d WB_IDX %d\r\n",WB_IDX, WB_IDX);
	idx = EX3_IDX;
	if (cluster_idx / 3)
		num += 16;

	WRITE_LOG_MAX(idx).type = type;
	WRITE_LOG_MAX(idx).addr = num;
	WRITE_LOG_MAX(idx).data = data;
	UPDATE_REGNUM(idx)++;

	if (type == Reg_CP) {
		for (i = 0; i < UPDATE_REGNUM(idx); i++)
			if (WRITE_LOG(idx, i).type == Reg_CPP
				&& WRITE_LOG(idx, i).addr == num)
				return;

		WRITE_LOG_MAX(idx).type = Reg_CPP;
		WRITE_LOG_MAX(idx).addr = num;
		WRITE_LOG_MAX(idx).data = data;
		UPDATE_REGNUM(idx)++;
	}
}

void pac_dsp::stage2_l_write(unsigned char num, unsigned char type,
							  unsigned long long data)
{
	int idx;

	assert(type <= Reg_Maxindex);
	assert(num <= Reg_Maxnum);

	//printf("stage2_l_write WN_IDX %d WB_IDX %d\r\n",WB_IDX, WB_IDX);
	idx = EX2_IDX;
	if (cluster_idx / 3)
		num += 16;

	WRITE_LOG_MAX(idx).type = type;
	WRITE_LOG_MAX(idx).addr = num;
	WRITE_LOG_MAX(idx).data = data;
	UPDATE_REGNUM(idx)++;

	if (type == Reg_CP) {
		WRITE_LOG_MAX(idx).type = Reg_CPP;
		WRITE_LOG_MAX(idx).addr = num;
		WRITE_LOG_MAX(idx).data = data;
		UPDATE_REGNUM(idx)++;
	}
}

int pac_dsp::write_conflict_check(unsigned char type, unsigned char addr)
{
	int i, idx, ret;
	inst_t *inst;
//	Inst_Package_more *inst_p;

	//printf("write_conflict_check WN_IDX %d WB_IDX %d\r\n",WB_IDX, WB_IDX);
	ret = 0;
	idx = EX2_IDX;

	for (i = 0; i < UPDATE_REGNUM(idx); i++) {
		if (type != Reg_CP) {
			if ((type == WRITE_LOG(idx, i).type) &&
				(((cluster_idx > 2) ? addr + 16 : addr) ==
				 WRITE_LOG(idx, i).addr)) {
				ret = 1;
				break;
			}
		} else {
//			inst_p = pac_get_inst_packet(exec_table[idx].PC);
//			inst = &(inst_p->package.instr[cluster_idx].inst);
			inst = &(exec_table[EX2_IDX].instr[cluster_idx].inst);
			
			if ((inst->Rd1_Type == Reg_CPP && addr == inst->Rd1_Addr) ||
				(inst->Rd2_Type == Reg_CPP && addr == inst->Rd2_Addr) ||
				(inst->Rs1_Type == Reg_CPP && addr == inst->Rs1_Addr) ||
				(inst->Rs2_Type == Reg_CPP && addr == inst->Rs2_Addr)) {
				ret = 1;
				break;
			}

			if ((inst->Rd1_Type == Reg_CP && addr == inst->Rd1_Addr) ||
				(inst->Rd2_Type == Reg_CP && addr == inst->Rd2_Addr) ||
				(inst->Rs1_Type == Reg_CP && addr == inst->Rs1_Addr) ||
				(inst->Rs2_Type == Reg_CP && addr == inst->Rs2_Addr)) {
				ret = 1;
				break;
			}

//			inst = &(inst_p->package.instr[cluster_idx + 1].inst);
			inst = &(exec_table[EX2_IDX].instr[cluster_idx+1].inst);

			if ((inst->Rd1_Type == Reg_CPP && addr == inst->Rd1_Addr) ||
				(inst->Rd2_Type == Reg_CPP && addr == inst->Rd2_Addr) ||
				(inst->Rs1_Type == Reg_CPP && addr == inst->Rs1_Addr) ||
				(inst->Rs2_Type == Reg_CPP && addr == inst->Rs2_Addr)) {
				ret = 1;
				break;
			}

			if ((inst->Rd1_Type == Reg_CP && addr == inst->Rd1_Addr) ||
				(inst->Rd2_Type == Reg_CP && addr == inst->Rd2_Addr) ||
				(inst->Rs1_Type == Reg_CP && addr == inst->Rs1_Addr) ||
				(inst->Rs2_Type == Reg_CP && addr == inst->Rs2_Addr)) {
				ret = 1;
				break;
			}
		}
	}

	if ((ret == 1) &&
		(exec_table[EX3_IDX].instr[0].inst.op == B ||
		 exec_table[EX3_IDX].instr[0].inst.op == BR ||
		 exec_table[EX3_IDX].instr[0].inst.op == BRR ||
		 exec_table[EX3_IDX].instr[0].inst.op == LBCB ||
		 exec_table[EX3_IDX].instr[0].inst.op == LW ||
		 exec_table[EX3_IDX].instr[0].inst.op == LH ||
		 exec_table[EX3_IDX].instr[0].inst.op == LB ||
		 exec_table[EX3_IDX].instr[0].inst.op == LHU ||
		 exec_table[EX3_IDX].instr[0].inst.op == LBU)) {
		inst = &(exec_table[WB_IDX].instr[0].inst);
		if ((inst->op == LW || inst->op == LH || inst->op == LB
			 || inst->op == LHU || inst->op == LBU || inst->op == B
			 || inst->op == BR || inst->op == BRR || inst->op == LBCB)
			&& (inst->Rd1_Type == type && inst->Rd1_Addr == addr
				&& exec_table[WB_IDX].instr[0].execute == 1)) {
			for (i = 0; i < UPDATE_REGNUM(idx); i++) {
				if ((type == WRITE_LOG(idx, i).type) &&
					(((cluster_idx > 2) ? addr + 16 : addr) ==
					 WRITE_LOG(idx, i).addr)) {
//liqin   WRITE_LOG(idx, i).type = INVALID_REG;
					WRITE_LOG(idx, i).type = 1;
					ret = 0;
					for (i = 0; i < UPDATE_REGNUM(idx); i++) {
						if ((type == WRITE_LOG(idx, i).type) &&
							(((cluster_idx > 2) ? addr + 16 : addr) ==
							 WRITE_LOG(idx, i).addr)) {
							ret = 1;
							break;
						}
					}
					break;
				}
			}
		}
	}

	return ret;
}

unsigned int pac_dsp::detect_overflow(unsigned long long uldst,
									   unsigned long long ulsrc1,
									   unsigned long long ulsrc2)
{
	unsigned int data = 0;

	if (((int) ulsrc1 >= 0) && ((int) ulsrc2 >= 0) && ((int) uldst < 0)) {
		data = 1;
	} else if (((int) ulsrc1 < 0) && ((int) ulsrc2 < 0) && ((int) uldst >= 0)) {
		data = 1;
	}
	return data;
}

unsigned int pac_dsp::detect_overflow_sub(unsigned long long uldst,
										   unsigned long long ulsrc1,
										   unsigned long long ulsrc2)
{
	unsigned int data = 0;

	if (((int) ulsrc1 > 0) && ((int) ulsrc2 < 0) && ((int) uldst < 0)) {
		data = 1;
	} else if (((int) ulsrc1 < 0) && ((int) ulsrc2 > 0) && ((int) uldst >= 0)) {
		data = 1;
	}

	return data;
}

unsigned int pac_dsp::detect_overflow16(unsigned int udst1,
										 unsigned int udst2,
										 unsigned int usrc1,
										 unsigned int usrc2)
{
	unsigned int data = 0;

	if (((short) (usrc1 >> 16) > 0) && ((short) (usrc2 >> 16) > 0) &&
		((short) udst1 < 0)) {
		data = 1 << 1;
	} else if (((short) (usrc1 >> 16) < 0) && ((short) (usrc2 >> 16) < 0) &&
			   ((short) udst1 >= 0)) {
		data = 1 << 1;
	}
	if (((short) (usrc1) > 0) && ((short) (usrc2) > 0) && ((short) udst2 < 0)) {
		data |= 1;
	} else if (((short) (usrc1) < 0) && ((short) (usrc2) < 0) &&
			   ((short) udst2 >= 0)) {
		data |= 1;
	}

	return data;
}

unsigned int pac_dsp::detect_overflow16_sub(unsigned int udst1,
											 unsigned int udst2,
											 unsigned int usrc1,
											 unsigned int usrc2)
{
	unsigned int data = 0;

	if (((short) (usrc1 >> 16) > 0) && ((short) (usrc2 >> 16) < 0) &&
		((short) udst1 < 0)) {
		data = 1 << 1;
	} else if (((short) (usrc1 >> 16) < 0) && ((short) (usrc2 >> 16) > 0) &&
			   ((short) udst1 >= 0)) {
		data = 1 << 1;
	}
	if (((short) (usrc1) > 0) && ((short) (usrc2) < 0) && ((short) udst2 < 0)) {
		data |= 1;
	} else if (((short) (usrc1) < 0) && ((short) (usrc2) > 0) &&
			   ((short) udst2 >= 0)) {
		data |= 1;
	}

	return data;
}

unsigned int pac_dsp::detect_overflow8(unsigned int udst1,
										unsigned int udst2,
										unsigned int udst3,
										unsigned int udst4,
										unsigned int usrc1,
										unsigned int usrc2)
{
	unsigned int data = 0;

	if (((char) (usrc1) > 0) && ((char) (usrc2) > 0) && ((char) udst1 < 0)) {
		data = 1;
	} else if (((char) (usrc1) < 0) && ((char) (usrc2) < 0)
			   && ((char) udst1 >= 0)) {
		data = 1;
	}
	if (((char) (usrc1 >> 8) > 0) && ((char) (usrc2 >> 8) > 0) &&
		((char) udst2 < 0)) {
		data = 1;
	} else if (((char) (usrc1 >> 8) < 0) && ((char) (usrc2 >> 8) < 0) &&
			   ((char) udst2 >= 0)) {
		data = 1;
	}
	if (((char) (usrc1 >> 16) > 0) && ((char) (usrc2 >> 16) > 0) &&
		((char) udst3 < 0)) {
		data = 1;
	} else if (((char) (usrc1 >> 16) < 0) && ((char) (usrc2 >> 16) < 0) &&
			   ((char) udst3 >= 0)) {
		data = 1;
	}
	if (((char) (usrc1 >> 24) > 0) && ((char) (usrc2 >> 24) > 0) &&
		((char) udst4 < 0)) {
		data = 1;
	} else if (((char) (usrc1 >> 24) < 0) && ((char) (usrc2 >> 24) < 0) &&
			   ((char) udst4 >= 0)) {
		data = 1;
	}

	return data;
}

unsigned int pac_dsp::detect_overflow8_sub(unsigned int udst1,
											unsigned int udst2,
											unsigned int udst3,
											unsigned int udst4,
											unsigned int usrc1,
											unsigned int usrc2)
{
	unsigned int data = 0;

	if (((char) (usrc1) > 0) && ((char) (usrc2) < 0) && ((char) udst1 < 0)) {
		data = 1;
	} else if (((char) (usrc1) < 0) && ((char) (usrc2) > 0)
			   && ((char) udst1 >= 0)) {
		data = 1;
	}
	if (((char) (usrc1 >> 8) > 0) && ((char) (usrc2 >> 8) < 0) &&
		((char) udst2 < 0)) {
		data = 1;
	} else if (((char) (usrc1 >> 8) < 0) && ((char) (usrc2 >> 8) > 0) &&
			   ((char) udst2 >= 0)) {
		data = 1;
	}
	if (((char) (usrc1 >> 16) > 0) && ((char) (usrc2 >> 16) < 0) &&
		((char) udst3 < 0)) {
		data = 1;
	} else if (((char) (usrc1 >> 16) < 0) && ((char) (usrc2 >> 16) > 0) &&
			   ((char) udst3 >= 0)) {
		data = 1;
	}
	if (((char) (usrc1 >> 24) > 0) && ((char) (usrc2 >> 24) < 0) &&
		((char) udst4 < 0)) {
		data = 1;
	} else if (((char) (usrc1 >> 24) < 0) && ((char) (usrc2 >> 24) > 0) &&
			   ((char) udst4 >= 0)) {
		data = 1;
	}

	return data;
}

unsigned int pac_dsp::detect_carry(unsigned long long uldst,
									unsigned long long ulsrc1,
									unsigned long long ulsrc2)
{
	unsigned int data = 0;

	if ((((ulsrc1 >> 32) & 0x1) && ((ulsrc2 >> 32) & 0x1)) ||
		((!((ulsrc1 >> 32) & 0x1)) && (!((ulsrc2 >> 32) & 0x1)))) {
		if ((uldst >> 32) & 0x1)
			data = 1;
	} else {
		if (!((uldst >> 32) & 0x1))
			data = 1;
	}

	return data;
}

void pac_dsp::sc_addr_gen(inst_t * curinst)
{
	unsigned long long uaddr, uctrl;


	uaddr = regfile_l_read(curinst->Rs1_Addr, curinst->Rs1_Type);

	uctrl = 0;

	switch ((uctrl >> (curinst->Rs1_Addr * 2)) & 0x11) {
		//linear
	case 0:
		if (curinst->offset == 1)	//offset addressing
		{
			if (curinst->Rs2_Type == Reg_R) {
				curinst->Memory_Addr =
					uaddr + regfile_read(curinst->Rs2_Addr,
										 curinst->Rs2_Type);
			} else
				curinst->Memory_Addr =
					uaddr + ((int) ((((int) curinst->Imm32) << 8) >> 8));
		} else if (curinst->offset == 2)	//post incremental addressing
		{
			curinst->Memory_Addr = uaddr;
			if (curinst->Rs2_Type == Reg_R) {
				regfile_l_write(curinst->Rs1_Addr, curinst->Rs1_Type,
								(uaddr +
								 (long long) regfile_read(curinst->Rs2_Addr,
														  curinst->Rs2_Type))
					);
			} else
				regfile_l_write(curinst->Rs1_Addr, curinst->Rs1_Type,
								(int) (uaddr +
									   ((int)
										((((int) curinst->
										   Imm32) << 8) >> 8))));
		} else
			fprintf(stderr, "Unsuppoted linear addressing mode\n");
		break;
		//Bit-Reverse
	case 1:
		fprintf(stderr, "(sc_addr_gen)Bit_Reverse is unsupported\n");
		break;
		//Module
	case 2:
		fprintf(stderr, "(sc_addr_gen)Module is unsupported\n");
		break;
		//Reserved
	case 3:
		break;
	}
}

unsigned int pac_dsp::bit_reverse(unsigned int data, int width)
{
	int i;
	unsigned int udata = 0;

	for (i = 0; i < width; i++)
		udata |= ((data >> i) & 0x1) << (31 - i);

	udata >>= 32 - width;
	return udata;
}

unsigned int pac_dsp::ls_addr_gen(inst_t * curinst)
{
	unsigned int uaddr, uctrl;
	unsigned int tmp;
	unsigned int base, end, offset;
	unsigned int ret;

	ret = 0;
	uaddr = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);	// & MEMORY_MASK; //liukai
	uctrl = regfile_read(0, Reg_AMCR);	//read AMCR;

	switch ((uctrl >> (curinst->Rs1_Addr * 2)) & 0x3) {
	case 0:			// linear
		if (curinst->offset == 1) {	//offset addressing
			if (curinst->Rs2_Type == Reg_A)
				curinst->Memory_Addr =
					uaddr + (long long) regfile_l_read(curinst->Rs2_Addr,
													   curinst->Rs2_Type);
			else
				curinst->Memory_Addr =
					uaddr + (int) ((((int) curinst->Imm32) << 8) >> 8);
		} else if (curinst->offset == 2) {	//post incremental addressing
			curinst->Memory_Addr = uaddr;
			if (curinst->Rs2_Type == Reg_A) {
				// Deleted MEMORY_MASK by dengyong 2007/12/26
				regfile_write(curinst->Rs1_Addr, curinst->Rs1_Type,
							  uaddr +
							  (long long) regfile_l_read(curinst->Rs2_Addr,
														 curinst->Rs2_Type));
			} else
				regfile_write(curinst->Rs1_Addr, curinst->Rs1_Type,
							  uaddr +
							  (int) ((((int) curinst->Imm32) << 8) >> 8));
		} else
			fprintf(stderr, "Unsuppoted linear addressing mode\n");
		break;
	case 1:			// Bit-Reverse
		curinst->Memory_Addr = uaddr;
		if (curinst->Rs2_Type == Reg_A) {
			tmp = regfile_l_read(curinst->Rs2_Addr, curinst->Rs2_Type);
			tmp = bit_reverse(tmp, 16);
			tmp = bit_reverse(uaddr, 16) + tmp;
			regfile_write(curinst->Rs1_Addr, curinst->Rs1_Type,
						  (uaddr & 0xFFFF0000) | bit_reverse(tmp, 16));
		} else {
			tmp = bit_reverse((short) curinst->Imm32, 16);
			tmp = bit_reverse(uaddr, 16) + tmp;
			regfile_write(curinst->Rs1_Addr, curinst->Rs1_Type,
						  (uaddr & 0xFFFF0000) | bit_reverse(tmp, 16));
		}
		break;
	case 2:			// Module
		curinst->Memory_Addr = uaddr;
		base = (short) regfile_read(curinst->Rs1_Addr + 1, curinst->Rs1_Type);
		end = (short) regfile_read(curinst->Rs1_Addr + 4, curinst->Rs1_Type);
		if (curinst->Rs2_Type == Reg_A) {
			offset =
				(short) regfile_read(curinst->Rs1_Addr + 5,
									 curinst->Rs2_Type);
		} else {
			offset = (short) curinst->Imm32;
		}

		tmp = uaddr + offset;
		if ((short) offset > 0) {
			if (tmp > (unsigned short) (end - 1))
				tmp = tmp - end + base;
		} else {
			if (tmp < (unsigned short) base || (int) tmp < 0)
				tmp = tmp - base + end;
		}
		regfile_write(curinst->Rs1_Addr, curinst->Rs1_Type,
					  (uaddr & 0xFFFF0000) | LOW16MASK(tmp));
		ret = (end & 0xFFFF) | ((base & 0xFFFF) << 16);
		break;
	case 3:			// Reserved
		break;
	}

	return ret;
}

unsigned char pac_dsp::cp_read(unsigned char addr)
{
	if (cluster_idx / 3)
		addr += 16;

	return global_regs.RF[Reg_CPP][addr];
}

void pac_dsp::regfile_update()
{
	//user maybe changed the CP register ,so we must synchronization the CPP register
	memcpy(&global_regs.RF[Reg_CPP][0], &global_regs.RF[Reg_CP][0],
		   sizeof(global_regs.RF[Reg_CP]));
	memcpy(&ro_regs, &global_regs, sizeof(RF_t));
}

unsigned int pac_dsp::regfile_read(unsigned char num, unsigned char type)
{
	assert(type <= Reg_Maxindex);
	assert(num <= Reg_Maxnum);

	if (cluster_idx / 3 && type != Reg_P && type != Reg_R)
		num += 16;

	if (type == Reg_CPP)
		cp_gen(&num, &type);

	if (type == Reg_CP || type == Reg_C || type == Reg_CR || type == Reg_AMCR)
		return (unsigned int) global_regs.RF[type][num];
	else
		return (unsigned int) ro_regs.RF[type][num];
}

void pac_dsp::pac_exec_init()
{
	// init ro_regs.RF
	ro_regs.sim_end = 0;
	memset(&(ro_regs.RF), 0, sizeof(unsigned long long) * 10 * 32);
	memset(&(global_regs.RF), 0, sizeof(unsigned long long) * 10 * 32);
	ro_regs.RF[Reg_P][0] = global_regs.RF[Reg_P][0] = 1;
	ro_regs.RF[Reg_CR][1] = global_regs.RF[Reg_CR][1] = 0x1;	// Enable Interrupt
	ro_regs.RF[Reg_CR][2] = global_regs.RF[Reg_CR][2] = 0x0101;	// Exception Mask
}

void pac_dsp::update_p(unsigned int data, int stage)
{
	int i;

	data >>= 1;
	for (i = 1; i < 16; i++) {
		if (stage == PP_E1) {
			if (data & 0x1)
				ro_regs.RF[Reg_P][i] = 1;
			else
				ro_regs.RF[Reg_P][i] = 0;
		} else if (stage == PP_WB) {
			if (data & 0x1)
				global_regs.RF[Reg_P][i] = 1;
			else
				global_regs.RF[Reg_P][i] = 0;
		} else if (stage == PP_E2) {
		} else if (stage == PP_E3) {
		}
		data >>= 1;
	}
}

void pac_dsp::update_registerfile(int wn_idx)
{
	int i;
	int idx;

	//printf("update registerfile WN_IDX %d WB_IDX %d\r\n",wn_idx, WB_IDX);
	// Write data into forward register file
	idx = (wn_idx + 3) % 8;
	for (i = 0; i < UPDATE_REGNUM(idx); i++) {
		if (WRITE_LOG(idx, i).type < 10) {
			ro_regs.RF[WRITE_LOG(idx, i).type][WRITE_LOG(idx, i).addr] = WRITE_LOG(idx, i).data;
			if (WRITE_LOG(idx, i).type == Reg_CR && WRITE_LOG(idx, i).addr == 0)
				update_p(WRITE_LOG(idx, i).data, PP_E1);
		} else if (WRITE_LOG(idx, i).type == Reg_PSR) {
			ro_regs.PSR[WRITE_LOG(idx, i).addr >> 3][WRITE_LOG(idx, i).addr & 0x7]
				= WRITE_LOG(idx, i).data;
		}
	}

	// Write data into register file
	idx = wn_idx;
	for (i = 0; i < UPDATE_REGNUM(idx); i++) {
		if (WRITE_LOG(idx, i).type < 10) {
			global_regs.RF[WRITE_LOG(idx, i).type][WRITE_LOG(idx, i).addr] = WRITE_LOG(idx, i).data;
			if (WRITE_LOG(idx, i).type == Reg_CR && WRITE_LOG(idx, i).addr == 0)
				update_p(WRITE_LOG(idx, i).data, PP_WB);
		} else if (WRITE_LOG(idx, i).type == Reg_PSR) {
			global_regs.PSR[WRITE_LOG(idx, i).addr >> 3][WRITE_LOG(idx, i).addr & 0x7]
				= WRITE_LOG(idx, i).data;
		}
	}

	// Reset WR_IDX
	UPDATE_REGNUM(idx) = 0;

	// P[0] is always 1.
	ro_regs.RF[Reg_P][0] = 1;
	global_regs.RF[Reg_P][0] = 1;

	// copy predict register to CR0
	ro_regs.RF[Reg_CR][0] = 0;
	global_regs.RF[Reg_CR][0] = 0;

	for (i = 0; i < 16; i++) {
		ro_regs.RF[Reg_CR][0] |= ro_regs.RF[Reg_P][i] << i;
		global_regs.RF[Reg_CR][0] |= global_regs.RF[Reg_P][i] << i;
	}

	// LS_PSR is 5-bits width.
	ro_regs.PSR[2][5] = 0;
	ro_regs.PSR[2][6] = 0;
	ro_regs.PSR[4][5] = 0;
	ro_regs.PSR[4][6] = 0;
	global_regs.PSR[2][5] = 0;
	global_regs.PSR[2][6] = 0;
	global_regs.PSR[4][5] = 0;
	global_regs.PSR[4][6] = 0;

	// AMCR is 16-bits width.
	ro_regs.RF[Reg_AMCR][0] &= 0xFFFF;
	ro_regs.RF[Reg_AMCR][16] &= 0xFFFF;
	global_regs.RF[Reg_AMCR][0] &= 0xFFFF;
	global_regs.RF[Reg_AMCR][16] &= 0xFFFF;

	// CP is 7-bits width.
	ro_regs.RF[Reg_CP][0] &= 0x7F;
	ro_regs.RF[Reg_CP][1] &= 0x7F;
	ro_regs.RF[Reg_CP][16] &= 0x7F;
	ro_regs.RF[Reg_CP][17] &= 0x7F;
	global_regs.RF[Reg_CP][0] &= 0x7F;
	global_regs.RF[Reg_CP][1] &= 0x7F;
	global_regs.RF[Reg_CP][16] &= 0x7F;
	global_regs.RF[Reg_CP][17] &= 0x7F;

	// Enable Int
	if (ro_regs.sim_end == 2)
		global_regs.RF[Reg_CR][1] = 1;
}

