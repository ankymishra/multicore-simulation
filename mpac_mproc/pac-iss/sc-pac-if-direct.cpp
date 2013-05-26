#include <systemc.h>
#include <sys/time.h>
#include "errno.h"

#include "mpac-mproc-define.h"
#include "sc-pac-if-direct.h"
#include "pac-socshm-prot.h"

void SC_pac_if::idle(volatile int *flag)
{
//	while (*flag != RESPONSE) {}

	if(memif_req_count == 4)
		monitor_req_event.notify();
	
	wait(monitor_resp_event);
}

void SC_pac_if::l1_icache_read(unsigned int addr, unsigned char *buf, int len)
{
	int i, t = -1;
	unsigned int tmp_addr = addr;
	struct soc_shm_prot *base_ptr = soc_shm_base_ptr + 3;
	struct icache_addr iaddr_line1, iaddr_line2;
	unsigned int addr_line2;

	
	for (i = 0; i < len; i++) {
		struct icache_addr iaddr = *(struct icache_addr *) &(addr);

		if ((icache_mem[iaddr.index].flag.invalid == 1)
			|| (icache_mem[iaddr.index].flag.tag != iaddr.tag)) {
			
			if ((tmp_addr + len) >= (tmp_addr & ~(l1_icache_line_size - 1)) + l1_icache_line_size) {
				t = 1;
				base_ptr->addr = tmp_addr & ~(l1_icache_line_size - 1);
				base_ptr->len = 2 * l1_icache_line_size;
			} else {
				t = 0;
				base_ptr->addr = tmp_addr & ~(l1_icache_line_size - 1);
				base_ptr->len = l1_icache_line_size;
			}
			base_ptr->cmd = ICACHE_READ;
			base_ptr->flag = REQUEST;
			base_ptr->futex = 0x11;
			base_ptr->inst_mode = INST_IF;
//			if (!multi_arg(boot, share_mode)) {
			idle(&base_ptr->flag);
#if 0
			static int pro_c = 0;
			printf("Miss !! %d\r\n", pro_c);
			fflush(stdout);
			pro_c++;
#endif

//			} else {
//				int dummy_space, i;

//				i = read(iss_soc_fifo_fd, &dummy_space, 1);
//			}
			if (t == 0) {
				iaddr_line1 = *(struct icache_addr *) &(tmp_addr);
			    icache_mem[iaddr_line1.index].flag.invalid = 0;
			    icache_mem[iaddr_line1.index].flag.tag = iaddr.tag;
			    memcpy((unsigned char *) icache_mem[iaddr_line1.index].insn,
				    (unsigned char *) base_ptr->buf,  l1_icache_line_size);
			} else {
				iaddr_line1 = *(struct icache_addr *) &(tmp_addr);
			    icache_mem[iaddr_line1.index].flag.invalid = 0;
			    icache_mem[iaddr_line1.index].flag.tag = iaddr.tag;
			    memcpy((unsigned char *) icache_mem[iaddr_line1.index].insn,
				    (unsigned char *) base_ptr->buf,  l1_icache_line_size);

			    //icache_mem[iaddr.index+1].flag.invalid = 0;
			    //icache_mem[iaddr.index+1].flag.tag = (iaddr+l1_iccahe_line_size).tag;
			    //memcpy((unsigned char *) icache_mem[iaddr.index+1].insn,
			    //	    (unsigned char *) base_ptr->buf+l1_icache_line_size, l1_icache_line_size);

			    addr_line2 = (tmp_addr & ~(l1_icache_line_size - 1)) + l1_icache_line_size;
			    iaddr_line2 = *(struct icache_addr *)&(addr_line2);
			    icache_mem[iaddr_line2.index].flag.invalid = 0;
			    icache_mem[iaddr_line2.index].flag.tag = iaddr_line2.tag;
			    memcpy((unsigned char *) icache_mem[iaddr_line2.index].insn,
				    (unsigned char *) (base_ptr->buf + l1_icache_line_size),  l1_icache_line_size);
			}
		}
		
		*buf = icache_mem[iaddr.index].insn[addr & (l1_icache_line_size - 1)];
		addr++;
		buf++;
	}

	if (t == -1)
		idle(&base_ptr->flag);

	base_ptr->flag = IDLE;
}

int SC_pac_if::icache_read(unsigned int addr, unsigned char *buf, int len)
{
	struct soc_shm_prot *base_ptr = soc_shm_base_ptr + 3;
	//printf("SC_pac_memif::icache_read addr = 0x%08x.\r\n", (int)addr);
	
	if (len > 256) {
		printf("pac_dsp_proxy::icache_read addr=0x%08x len=%d > 256.\r\n",
			   addr, len);
		exit(1);
	}

	if ((addr >= core_insnbuf0.addr)
		&& ((addr + len) < (core_insnbuf0.addr + 256))) 
	{
		memcpy(buf, &core_insnbuf0.buf[(addr - core_insnbuf0.addr)], len);
		idle(&base_ptr->flag);
	} else {
		l1_icache_read(addr, core_insnbuf0.buf, 256);
		memcpy(buf, core_insnbuf0.buf, len);
		core_insnbuf0.addr = addr;
	}
	return 0;
}

int SC_pac_if::icache_write(unsigned int addr, unsigned char *buf, int len)
{
	//struct soc_shm_prot *base_ptr = soc_shm_base_ptr + 3;

	//base_ptr->addr = addr;
	//base_ptr->len = (unsigned int) len;
	//base_ptr->cmd = ICACHE_WRITE;
	//base_ptr->flag = REQUEST;
	//base_ptr->futex = 0x11;

	//Flush optimization icache
	memset(core_insnbuf0.buf, 0, sizeof(core_insnbuf0.buf));
	core_insnbuf0.addr = 0;

	for (unsigned int i = 0; i < (l1_icache_size / l1_icache_line_size); i++) {
		icache_mem[i].flag.tag = 0;
		icache_mem[i].flag.index = 0;
		icache_mem[i].flag.invalid = 1;
	}

//	if (!multi_arg(boot, share_mode)) {
	//	idle(&base_ptr->flag);
//	} else {
//		int dummy_space, i;

//		i = read(iss_soc_fifo_fd, &dummy_space, 1);
//	}

	//memcpy((unsigned char *) buf, (unsigned char *) base_ptr->buf, len);
	//base_ptr->flag = IDLE;

	return 0;
}


int SC_pac_if::length_decode(unsigned long long raw)
{
	int len = 0;

	if ((raw & 0x7F) == 0x66)
		len = 4;
	else if ((raw & 0x7F) == 0x26)
		len = 4;
	else if ((raw & 0x3F) == 0x06)
		len = 3;
	else if ((raw & 0x1F) == 0x16)
		len = 2;
	else if ((raw & 0x1F) == 0x1E)
		len = 1;
	else if ((raw & 0x1F) == 0x0E)
		len = 1;
	else if ((raw & 0xF) == 0xA)
		len = 2;
	else if ((raw & 0xF) == 0xC)
		len = (raw >> 4) & 0x7;
	else if ((raw & 0xF) == 0x2)
		len = (raw >> 7) & 0x7;
	else if ((raw & 0xF) == 0x4) {
		if (((raw >> 4) & 0x3) == 0x0)
			len = 4;
		else
			len = (raw >> 4) & 0x3;
	} else if ((raw & 0x7) == 0x1) {
		if (((raw >> 3) & 0x3) == 0x0)
			len = 4;
		else
			len = (raw >> 3) & 0x3;
	} else if ((raw & 0x7) == 0x5)
		len = (raw >> 3) & 0x7;
	else if ((raw & 0x7) == 0x0)
		len = (raw >> 3) & 0x7;
	else if ((raw & 0x3) == 0x3)
		len = (raw >> 2) & 0x1 ? 1 : 2;
	else {
		printf("Unknown type code!! Abort!!\n");
		exit(-1);
	}

	return len;
}

int SC_pac_if::pac_length_decode(unsigned long long raw)
{
	return length_decode(raw);
}

unsigned short SC_pac_if::operand_decode(unsigned char raw)
{
	unsigned short data = 0;

	if (cluster_idx == 0) {	// Scalar
		if (((raw >> 4) & 0x1) == 0x0)
			data = (raw & 0xF) | (Reg_R << 8);
		else if (((raw >> 4) & 0x1) == 0x1)
			data = (raw & 0xF) | (Reg_CR << 8);
		else {
			printf("Unknown register data in Scalar!! Abort!!\n");
			exit(-1);
		}
	} else if ((cluster_idx == 1 || cluster_idx == 3)) {	// LS
		if (((raw >> 4) & 0x1) == 0x1)
			data = (raw & 0xF) | (Reg_D << 8);
		else if (((raw >> 3) & 0x3) == 0x0)
			data = (raw & 0x7) | (Reg_A << 8);
		else if (((raw >> 3) & 0x3) == 0x1) {
			if (((raw >> 1) & 0x3) == 0x0)
				data = (raw & 0x1) | (Reg_CPP << 8);
			else if (((raw >> 1) & 0x3) == 0x1)
				data = (raw & 0x1) | (Reg_CP << 8);
			else if ((raw & 0x7) == 0x4)
				data = (1 & 0x1) | (Reg_PSR << 8);
			else if ((raw & 0x7) == 0x5)
				data = (0 & 0x1) | (Reg_PSR << 8);
			else
				data = (0 & 0x1) | (Reg_AMCR << 8);
		} else {
			printf("Unknown register data in LS!! Abort!!\n");
			exit(-1);
		}
	} else if ((cluster_idx == 2 || cluster_idx == 4)) {	// AU
		if (((raw >> 4) & 0x1) == 0x1)
			data = (raw & 0xF) | (Reg_D << 8);
		else if (((raw >> 3) & 0x3) == 0x0)
			data = (raw & 0x7) | (Reg_AC << 8);
		else if (((raw >> 3) & 0x3) == 0x1) {
			if (((raw >> 1) & 0x3) == 0x0)
				data = (raw & 0x1) | (Reg_CPP << 8);
			else if (((raw >> 1) & 0x3) == 0x1)
				data = (raw & 0x1) | (Reg_CP << 8);
			else if ((raw & 0x7) == 0x4)
				data = (1 & 0x1) | (Reg_PSR << 8);
			else if ((raw & 0x7) == 0x5)
				data = (0 & 0x1) | (Reg_PSR << 8);
			else
				data = (0 & 0x1) | (Reg_AMCR << 8);
		} else {
			printf("Unknown register data in AU!! Abort!!\n");
			exit(-1);
		}
	}

	return data;
}

void SC_pac_if::decode_A(inst_type raw, inst_t * inst)
{
	unsigned short data;

	//printf("Decoding A Type\n");
	// op
	if (raw.A11.opcode == 0x0) {
		if (raw.A11.func1 == 0x0)
			inst->op = B;
		else if (raw.A11.func1 == 0x1)
			inst->op = LBCB;
	} else if (raw.A11.opcode == 0x1) {
		if (raw.A11.func1 == 0x0)
			inst->op = BDR;
		else if (raw.A11.func1 == 0x1)
			inst->op = DBDR;
		else if (raw.A11.func1 == 0x3)
			inst->op = DCLR;
	} else if (raw.A11.opcode == 0x2) {
		if (raw.A11.func1 == 0x0)
			inst->op = MOVI;
		else if (raw.A11.func1 == 0x1)
			inst->op = MOVIU;
	} else if (raw.A11.opcode == 0x3) {
		if (raw.A11.func1 == 0x0)
			inst->op = COPY_FC;
		else if (raw.A11.func1 == 0x1)
			inst->op = COPY_FV;
		else if (raw.A11.func1 == 0x2)
			inst->op = READ_FLAG;
		else if (raw.A11.func1 == 0x3)
			inst->op = WRITE_FLAG;
	}
	// SEZE
	if (inst->op == MOVIU)
		inst->SEZE = 1;
	else
		inst->SEZE = 0;

	if (raw.A11.uc) {	// unconditional - A12
		// Rd
		if (inst->op == B || inst->op == LBCB) {
			if ((raw.A12.rd & 0x10) == 0x0) {
				data = operand_decode(raw.A12.rd);
				inst->Rd1_Addr = data & 0xFF;
				inst->Rd1_Type = data >> 8;
			}
		} else {
			data = operand_decode(raw.A12.rd);
			if (inst->op == WRITE_FLAG) {
				inst->Rs1_Addr = data & 0xFF;
				inst->Rs1_Type = data >> 8;
			} else if (inst->op == DCLR) {
				inst->Rd1_Addr = data & 0xFF;
				inst->Rd1_Type = data >> 8;
			} else {
				inst->Rd1_Addr = data & 0xFF;
				inst->Rd1_Type = data >> 8;
			}
		}
		// Imm32
		if (inst->op != MOVIU) {
			if (raw.A12.length == 0x4) {
				inst->Imm32 = ((raw.A12.imm0) | (raw.A12.imm1 << 8)
							   | (raw.A12.imm2 << 16) | (raw.A12.imm3 << 24));
			} else if (raw.A12.length == 0x3) {
				inst->Imm32 = (((int) ((raw.A12.imm0) | (raw.A12.imm1 << 8)
									   | (raw.A12.imm2 << 16))) << 8) >> 8;
			} else if (raw.A12.length == 0x2) {
				inst->Imm32 = (short) ((raw.A12.imm0) | (raw.A12.imm1 << 8));
			} else if (raw.A12.length == 0x1) {
				inst->Imm32 = (char) (raw.A12.imm0);
			} else
				inst->Imm32 = 0x0;
		} else {
			inst->Imm32 = ((raw.A12.imm0) | (raw.A12.imm1 << 8)
						   | (raw.A12.imm2 << 16) | (raw.A12.imm3 << 24));
		}

		if (inst->op == COPY_FC || inst->op == COPY_FV) {
			inst->Rd1_Type = Reg_P;
			inst->Rd1_Addr = raw.A12.rd & 0xF;
		}
	} else {			// conditional - A11
		// CEB
		if (inst->op == LBCB) {
			inst->P_Addr = (unsigned char) INVALID_REG;
			inst->Rs1_Addr = raw.A11.ceb;
			inst->Rs1_Type = Reg_R;
		} else {
			if (raw.A11.ceb == 0x0)
				inst->P_Addr = (unsigned char) INVALID_REG;
			else
				inst->P_Addr = raw.A11.ceb;
		}
		// Rd
		if (inst->op == B || inst->op == LBCB) {
			if ((raw.A11.rd & 0x10) == 0x0) {
				data = operand_decode(raw.A11.rd);
				inst->Rd1_Addr = data & 0xFF;
				inst->Rd1_Type = data >> 8;
			}
		} else {
			data = operand_decode(raw.A11.rd);
			if (inst->op == WRITE_FLAG) {
				inst->Rs1_Addr = data & 0xFF;
				inst->Rs1_Type = data >> 8;
			} else if (inst->op == DCLR) {
				inst->Rd1_Addr = data & 0xFF;
				inst->Rd1_Type = data >> 8;
			} else {
				inst->Rd1_Addr = data & 0xFF;
				inst->Rd1_Type = data >> 8;
			}
		}
		// Imm32
		if (inst->op != MOVIU) {
			if (raw.A11.length == 0x5) {
				inst->Imm32 = ((raw.A11.imm0) | (raw.A11.imm1 << 8)
							   | (raw.A11.imm2 << 16) | (raw.A11.imm3 << 24));
			} else if (raw.A11.length == 0x4) {
				inst->Imm32 = (((int) ((raw.A11.imm0) | (raw.A11.imm1 << 8)
									   | (raw.A11.imm2 << 16))) << 8) >> 8;
			} else if (raw.A11.length == 0x3) {
				inst->Imm32 = (short) ((raw.A11.imm0) | (raw.A11.imm1 << 8));
			} else if (raw.A11.length == 0x2) {
				inst->Imm32 = (char) (raw.A11.imm0);
			} else
				inst->Imm32 = 0x0;
		} else {
			inst->Imm32 = ((raw.A11.imm0) | (raw.A11.imm1 << 8)
						   | (raw.A11.imm2 << 16) | (raw.A11.imm3 << 24));
		}

		if (inst->op == COPY_FC || inst->op == COPY_FV) {
			inst->Rd1_Type = Reg_P;
			inst->Rd1_Addr = raw.A11.rd & 0xF;
		}
	}
}

void SC_pac_if::decode_B(inst_type raw, inst_t * inst)
{
	unsigned short data;

	//printf("Decoding B Type\n");
	// op
	if (raw.B11.opcode == 0x0) {
		if (raw.B11.func1 == 0x0)
			inst->op = ADD;
		else if (raw.B11.func1 == 0x1)
			inst->op = ADDU;
		else if (raw.B11.func1 == 0x2)
			inst->op = ADDQ;
		else if (raw.B11.func1 == 0x3)
			inst->op = ADDUQ;
		else if (raw.B11.func1 == 0x4)
			inst->op = ADDD;
		else if (raw.B11.func1 == 0x5)
			inst->op = ADDUD;
		else if (raw.B11.func1 == 0x6)
			inst->op = ADDC;
		else if (raw.B11.func1 == 0x7)
			inst->op = ADDCU;
	} else if (raw.B11.opcode == 0x1) {
		if (raw.B11.func1 == 0x2)
			inst->op = PACK4;
		else if (raw.B11.func1 == 0x0)
			inst->op = SLL;
		else if (raw.B11.func1 == 0x1)
			inst->op = SLLD;
		else if (raw.B11.func1 == 0x4)
			inst->op = SRL;
		else if (raw.B11.func1 == 0x5)
			inst->op = SRLD;
		else if (raw.B11.func1 == 0x6)
			inst->op = SRA;
		else if (raw.B11.func1 == 0x7)
			inst->op = SRAD;
		else if (raw.B11.func1 == 0x3)
			inst->op = DDEX;
	} else if (raw.B11.opcode == 0x2) {
		if (raw.B11.func1 == 0x0)
			inst->op = SUB;
		else if (raw.B11.func1 == 0x1)
			inst->op = SUBU;
		else if (raw.B11.func1 == 0x2)
			inst->op = SUBQ;
		else if (raw.B11.func1 == 0x3)
			inst->op = SUBUQ;
		else if (raw.B11.func1 == 0x4)
			inst->op = SUBD;
		else if (raw.B11.func1 == 0x5)
			inst->op = SUBUD;
		else if (raw.B11.func1 == 0x6)
			inst->op = EXTRACT;
		else if (raw.B11.func1 == 0x7)
			inst->op = EXTRACTU;
	} else if (raw.B11.opcode == 0x3) {
		if (raw.B11.func1 == 0x0)
			inst->op = MIN;
		else if (raw.B11.func1 == 0x1)
			inst->op = MINU;
		else if (raw.B11.func1 == 0x2)
			inst->op = MINQ;
		else if (raw.B11.func1 == 0x3)
			inst->op = MINUQ;
		else if (raw.B11.func1 == 0x4)
			inst->op = MIND;
		else if (raw.B11.func1 == 0x5)
			inst->op = MINUD;
		else if (raw.B11.func1 == 0x6)
			inst->op = DMIN;
		else if (raw.B11.func1 == 0x7)
			inst->op = DMINU;
	} else if (raw.B11.opcode == 0x4) {
		if (raw.B11.func1 == 0x0)
			inst->op = MAX;
		else if (raw.B11.func1 == 0x1)
			inst->op = MAXU;
		else if (raw.B11.func1 == 0x2)
			inst->op = MAXQ;
		else if (raw.B11.func1 == 0x3)
			inst->op = MAXUQ;
		else if (raw.B11.func1 == 0x4)
			inst->op = MAXD;
		else if (raw.B11.func1 == 0x5)
			inst->op = MAXUD;
		else if (raw.B11.func1 == 0x6)
			inst->op = DMAX;
		else if (raw.B11.func1 == 0x7)
			inst->op = DMAXU;
	} else if (raw.B11.opcode == 0x5) {
		if (raw.B11.func1 == 0x0)
			inst->op = BF;
		else if (raw.B11.func1 == 0x1)
			inst->op = BFD;
		else if (raw.B11.func1 == 0x2)
			inst->op = AND;
		else if (raw.B11.func1 == 0x3)
			inst->op = ANDP;
		else if (raw.B11.func1 == 0x4)
			inst->op = OR;
		else if (raw.B11.func1 == 0x5)
			inst->op = ORP;
		else if (raw.B11.func1 == 0x6)
			inst->op = XOR;
		else if (raw.B11.func1 == 0x7)
			inst->op = XORP;
	} else if (raw.B11.opcode == 0x6) {
		if (raw.B11.func1 == 0x0)
			inst->op = FMUL;
		else if (raw.B11.func1 == 0x1)
			inst->op = FMULD;
		else if (raw.B11.func1 == 0x3)
			inst->op = DOTP2;
		else if (raw.B11.func1 == 0x4)
			inst->op = FMULus;
		else if (raw.B11.func1 == 0x5)
			inst->op = FMULusD;
		else if (raw.B11.func1 == 0x6)
			inst->op = FMULuu;
		else if (raw.B11.func1 == 0x7)
			inst->op = FMULuuD;
	} else if (raw.B11.opcode == 0x7) {
		if (raw.B11.func1 == 0x0)
			inst->op = MULD;
		else if (raw.B11.func1 == 0x2)
			inst->op = XMULD;
		else if (raw.B11.func1 == 0x4)
			inst->op = XFMUL;
		else if (raw.B11.func1 == 0x5)
			inst->op = XFMULD;
		else if (raw.B11.func1 == 0x7)
			inst->op = XDOTP2;
	}
	// SEZE
	if (raw.B11.opcode == 0x0 || raw.B11.opcode == 0x2 ||
		raw.B11.opcode == 0x3 || raw.B11.opcode == 0x4) {
		inst->SEZE = raw.B11.func1 & 0x1;
	} else if (inst->op == SRL || inst->op == SRLD ||
			   inst->op == FMULuu || inst->op == FMULuuD) {
		inst->SEZE = 1;
	} else {
		inst->SEZE = 0;
	}

	if (raw.B11.uc) {	// unconditional - B12
		// Rd
		data = operand_decode(raw.B12.rd);
		inst->Rd1_Addr = data & 0xFF;
		inst->Rd1_Type = data >> 8;
		// Rs2 & Rs1
		if (inst->op == DMIN || inst->op == DMINU ||
			inst->op == DMAX || inst->op == DMAXU) {
			data = operand_decode(raw.B12.rs2);
			inst->Rs1_Addr = data & 0xFF;
			inst->Rs1_Type = data >> 8;
		} else {
			data = operand_decode(raw.B12.rs2);
			inst->Rs2_Addr = data & 0xFF;
			inst->Rs2_Type = data >> 8;
			data = operand_decode(raw.B12.rs1);
			inst->Rs1_Addr = data & 0xFF;
			inst->Rs1_Type = data >> 8;
		}

		if (inst->op == ANDP || inst->op == ORP || inst->op == XORP) {
			inst->Rd1_Type = Reg_P;
			inst->Rd1_Addr = raw.B12.rd & 0xF;
			inst->Rs1_Type = Reg_P;
			inst->Rs1_Addr = raw.B12.rs1 & 0xF;
			inst->Rs2_Type = Reg_P;
			inst->Rs2_Addr = raw.B12.rs2 & 0xF;
		}
	} else {			// conditional - B11
		// CEB
		if (raw.B11.ceb == 0x0)
			inst->P_Addr = (unsigned char) INVALID_REG;
		else
			inst->P_Addr = raw.B11.ceb;
		// Rs2 & Rs1
		if (inst->op == DMIN || inst->op == DMINU ||
			inst->op == DMAX || inst->op == DMAXU) {
			data = operand_decode(raw.B11.rs2);
			inst->Rs1_Addr = data & 0xFF;
			inst->Rs1_Type = data >> 8;
		} else {
			data = operand_decode(raw.B11.rs2);
			inst->Rs2_Addr = data & 0xFF;
			inst->Rs2_Type = data >> 8;
			data = operand_decode(raw.B11.rs1);
			inst->Rs1_Addr = data & 0xFF;
			inst->Rs1_Type = data >> 8;
		}
		// Rd
		data = operand_decode(raw.B11.rd);
		inst->Rd1_Addr = data & 0xFF;
		inst->Rd1_Type = data >> 8;

		if (inst->op == ANDP || inst->op == ORP || inst->op == XORP) {
			inst->Rd1_Type = Reg_P;
			inst->Rd1_Addr = raw.B11.rd & 0xF;
			inst->Rs1_Type = Reg_P;
			inst->Rs1_Addr = raw.B11.rs1 & 0xF;
			inst->Rs2_Type = Reg_P;
			inst->Rs2_Addr = raw.B11.rs2 & 0xF;
		}
	}
	inst->Imm32 = 0;
}

void SC_pac_if::decode_C1(inst_type raw, inst_t * inst)
{
	unsigned short data;

	//printf("Decoding C1 Type\n");
	// op
	if (raw.C11.opcode == 0x0) {
		if (raw.C11.func1 == 0x1)
			inst->op = ANDI;
		else if (raw.C11.func1 == 0x2)
			inst->op = ORI;
		else if (raw.C11.func1 == 0x3)
			inst->op = XORI;
	} else if (raw.C11.opcode == 0x1) {
		if (raw.C11.func1 == 0x2)
			inst->op = BRR;
		else if (raw.C11.func1 == 0x1)
			inst->op = EXTRACT;
		else if (raw.C11.func1 == 0x3)
			inst->op = EXTRACTU;
	} else if (raw.C11.opcode == 0x2) {
		if (raw.C11.func1 == 0x0)
			inst->op = ADDI;
		else if (raw.C11.func1 == 0x2)
			inst->op = ADDID;
		else if (raw.C11.func1 == 0x1)
			inst->op = SRAI;
		else if (raw.C11.func1 == 0x3)
			inst->op = SRAID;
	} else if (raw.C11.opcode == 0x3) {
		if (raw.C11.func1 == 0x0)
			inst->op = SLLI;
		else if (raw.C11.func1 == 0x2)
			inst->op = SLLID;
		else if (raw.C11.func1 == 0x1)
			inst->op = SRLI;
		else if (raw.C11.func1 == 0x3)
			inst->op = SRLID;
	}
	// SEZE
	if (inst->op == EXTRACTU || inst->op == SRLI)
		inst->SEZE = 1;
	else
		inst->SEZE = 0;
	// CEB
	if (raw.C11.ceb == 0x0)
		inst->P_Addr = (unsigned char) INVALID_REG;
	else
		inst->P_Addr = raw.C11.ceb;
	// Rd & Rs1
	if (inst->op == BRR) {
		// Rs1
		data = operand_decode(raw.C11.rs1);
		inst->Rs1_Addr = data & 0xFF;
		inst->Rs1_Type = data >> 8;
		// Rd
		if ((raw.C11.rd & 0x10) == 0x00) {
			data = operand_decode(raw.C11.rd);
			inst->Rd1_Addr = data & 0xFF;
			inst->Rd1_Type = data >> 8;
		}
	} else {
		data = operand_decode(raw.C11.rs1);
		inst->Rs1_Addr = data & 0xFF;
		inst->Rs1_Type = data >> 8;
		data = operand_decode(raw.C11.rd);
		inst->Rd1_Addr = data & 0xFF;
		inst->Rd1_Type = data >> 8;
	}
	// Imm32
	if (inst->op == ADDID) {
		if (raw.C11.length == 0x4 || raw.C11.length == 0x5)
			inst->Imm32 =
				(unsigned short) ((raw.C11.imm0) | (raw.C11.imm1 << 8));
		else if (raw.C11.length == 0x3)
			inst->Imm32 = (short) ((raw.C11.imm0) | (raw.C11.imm1 << 8));
		else if (raw.C11.length == 0x2)
			inst->Imm32 = (char) (raw.C11.imm0);
		else
			inst->Imm32 = 0x0;
	} else if (inst->op == EXTRACT || inst->op == EXTRACTU) {
		inst->Imm32 = raw.C11.imm0;
		inst->offset = raw.C11.imm1;
	} else if (inst->op == ORI || inst->op == ANDI || inst->op == XORI) {
		if (raw.C11.length == 0x5)
			inst->Imm32 = (raw.C11.imm0) | (raw.C11.imm1 << 8)
				| (raw.C11.imm2 << 16) | (raw.C11.imm3 << 24);
		else if (raw.C11.length == 0x4)
			inst->Imm32 =
				(raw.C11.imm0) | (raw.C11.imm1 << 8) | (raw.C11.imm2 << 16);
		else if (raw.C11.length == 0x3)
			inst->Imm32 = (raw.C11.imm0) | (raw.C11.imm1 << 8);
		else if (raw.C11.length == 0x2)
			inst->Imm32 = raw.C11.imm0;
		else
			inst->Imm32 = 0x0;
	} else {
		if (raw.C11.length == 0x5)
			inst->Imm32 = (raw.C11.imm0) | (raw.C11.imm1 << 8)
				| (raw.C11.imm2 << 16) | (raw.C11.imm3 << 24);
		else if (raw.C11.length == 0x4)
			inst->Imm32 = (((int) ((raw.C11.imm0) | (raw.C11.imm1 << 8)
								   | (raw.C11.imm2 << 16))) << 8) >> 8;
		else if (raw.C11.length == 0x3)
			inst->Imm32 = (short) ((raw.C11.imm0) | (raw.C11.imm1 << 8));
		else if (raw.C11.length == 0x2)
			inst->Imm32 = (char) (raw.C11.imm0);
		else
			inst->Imm32 = 0x0;
	}
}

void SC_pac_if::decode_C2(inst_type raw, inst_t * inst)
{
	unsigned short data;

	//printf("Decoding C2 Type\n");
	// op
	if (raw.C21.opcode == 0x0) {
		if ((raw.C21.func1 & 0x1) == 0x1)
			inst->op = DLW;
		else
			inst->op = LW;
	} else if (raw.C21.opcode == 0x1) {
		if ((raw.C21.func1 & 0x1) == 0x1)
			inst->op = LHU;
		else
			inst->op = LH;
	} else if (raw.C21.opcode == 0x2) {
		if ((raw.C21.func1 & 0x1) == 0x1)
			inst->op = LBU;
		else
			inst->op = LB;
	} else if (raw.C21.opcode == 0x3) {
		if ((raw.C21.func1 & 0x1) == 0x1)
			inst->op = DLNW;
		else
			inst->op = LNW;
	}
	// CEB
	if (raw.C21.ceb == 0x0)
		inst->P_Addr = (unsigned char) INVALID_REG;
	else
		inst->P_Addr = raw.C21.ceb;
	// Addressing Mode
	inst->offset = raw.C21.am + 1;
	// Rd & Rsd
	data = operand_decode(raw.C21.rd);
	inst->Rd1_Addr = data & 0xFF;
	inst->Rd1_Type = data >> 8;
	data = operand_decode(raw.C21.rsd);
	inst->Rs1_Addr = data & 0xFF;
	inst->Rs1_Type = data >> 8;
	// RsB
	if ((raw.C21.func1 & 0x2) == 0x0) {
		inst->Rs2_Addr = (data & 0xFF) + 1;
		inst->Rs2_Type = data >> 8;
	}
	// Imm32
	if (raw.C21.length == 0x0)
		inst->Imm32 = (((int) ((raw.C21.imm0) | (raw.C21.imm1 << 8)
							   | (raw.C21.imm2 << 16))) << 8) >> 8;
	else if (raw.C21.length == 0x3)
		inst->Imm32 = (short) ((raw.C21.imm0) | (raw.C21.imm1 << 8));
	else if (raw.C21.length == 0x2) {
		inst->Imm32 = (char) (raw.C21.imm0);
	} else
		inst->Imm32 = 0;

}

void SC_pac_if::decode_C3(inst_type raw, inst_t * inst)
{
	unsigned short data;

	//printf("Decoding C3 Type\n");
	// op
	if (raw.C31.opcode == 0x0) {
		inst->op = INSERT;
	} else if (raw.C31.opcode == 0x3) {
		if (raw.C31.func1 == 0x1)
			inst->op = SFRA;
		else if (raw.C31.func1 == 0x3)
			inst->op = SFRAD;
	} else if (raw.C31.opcode == 0x4) {
		inst->op = SW;
	} else if (raw.C31.opcode == 0x5) {
		inst->op = SH;
	} else if (raw.C31.opcode == 0x6) {
		inst->op = SB;
	} else if (raw.C31.opcode == 0x7) {
		inst->op = SNW;
	} else if (raw.C31.opcode == 0x1) {	//v3.6 2008.8.18
		if (raw.C31.func1 == 0)
			inst->op = ADSR;
		else if (raw.C31.func1 == 1)
			inst->op = ADSRU;
		else if (raw.C31.func1 == 2)
			inst->op = ADSRD;
		else
			inst->op = ADSRUD;
	}
	// Addressing Mode
	if (inst->op == SW || inst->op == SH || inst->op == SB || inst->op == SNW) {
		if ((raw.C31.func1 & 0x2) == 0x2)
			inst->offset = 2;
		else
			inst->offset = 1;
	}
	// CEB
	if (raw.C31.ceb == 0x0)
		inst->P_Addr = (unsigned char) INVALID_REG;
	else
		inst->P_Addr = raw.C31.ceb;
	// Rsd & Rs1
	if (inst->op == SFRA || inst->op == SFRAD || inst->op == INSERT || inst->op == ADSR || inst->op == ADSRU || inst->op == ADSRD || inst->op == ADSRUD) {	// v3.6 2008.8.18
		data = operand_decode(raw.C31.rsd);
		inst->Rd1_Addr = data & 0xFF;
		inst->Rd1_Type = data >> 8;
		data = operand_decode(raw.C31.rs1);
		inst->Rs1_Addr = data & 0xFF;
		inst->Rs1_Type = data >> 8;
	} else {
		data = operand_decode(raw.C31.rs1);
		inst->Rd1_Addr = data & 0xFF;
		inst->Rd1_Type = data >> 8;
		data = operand_decode(raw.C31.rsd);
		inst->Rs1_Addr = data & 0xFF;
		inst->Rs1_Type = data >> 8;
		// RsB
		if ((raw.C31.func1 & 0x1) == 0x0) {
			inst->Rs2_Addr = (data & 0xFF) + 1;
			inst->Rs2_Type = data >> 8;
		}
	}
	// Imm32 & offset
	if (inst->op == INSERT) {
		inst->Imm32 = raw.C31.imm0;
		inst->offset = raw.C31.imm1;
	} else {
		if (raw.C31.length == 0x0)
			inst->Imm32 = (((int) ((raw.C31.imm0) | (raw.C31.imm1 << 8)
								   | (raw.C31.imm2 << 16))) << 8) >> 8;
		else if (raw.C31.length == 0x3)
			inst->Imm32 = (short) ((raw.C31.imm0) | (raw.C31.imm1 << 8));
		else if (raw.C31.length == 0x2)
			inst->Imm32 = (char) (raw.C31.imm0);
		else
			inst->Imm32 = 0x0;
	}

}

void SC_pac_if::decode_C4(inst_type raw, inst_t * inst)
{
	unsigned short data;

	//printf("Decoding C4 Type\n");
	// op
	if (raw.C41.opcode == 0x0) {
		inst->op = INSERT;
	} else if (raw.C41.opcode == 0x1) {
		if (raw.C41.func1 == 0x1)
			inst->op = MACD;
		else if (raw.C41.func1 == 0x5)
			inst->op = MSUD;
	} else if (raw.C41.opcode == 0x3) {
		if (raw.C41.func1 == 0x2)
			inst->op = SAAQ;
		else if (raw.C41.func1 == 0x0)
			inst->op = FMAC;
		else if (raw.C41.func1 == 0x4)
			inst->op = FMACus;
		else if (raw.C41.func1 == 0x6)
			inst->op = FMACuu;
		else if (raw.C41.func1 == 0x1)
			inst->op = FMACD;
		else if (raw.C41.func1 == 0x5)
			inst->op = FMACusD;
		else if (raw.C41.func1 == 0x7)
			inst->op = FMACuuD;
	} else if (raw.C41.opcode == 0x4) {
		inst->op = DSW;
	} else if (raw.C41.opcode == 0x5) {
		if (raw.C41.func1 == 0x1)
			inst->op = XMACD;
		else if (raw.C41.func1 == 0x5)
			inst->op = XMSUD;
	} else if (raw.C41.opcode == 0x6) {
		if (raw.C41.func1 == 0x0)
			inst->op = XFMAC;
		//    else if (raw.C41.func1 = 0x1) inst->op = XFMACD;
		else if (raw.C41.func1 == 0x1)
			inst->op = XFMACD;	// Modified by dengyong 2007/12/12
	} else if (raw.C41.opcode == 0x7) {
		inst->op = DSNW;
	} else if (raw.C41.opcode == 0x2) {	// v3.6 2009.12.1 liukai
		if (raw.C41.func1 == 0x0)
			inst->op = ADSRF;
		else if (raw.C41.func1 == 0x1)
			inst->op = ADSRFD;
		else if (raw.C41.func1 == 0x2)
			inst->op = ADSRFU;
		else if (raw.C41.func1 == 0x3)
			inst->op = ADSRFUD;
		else if (raw.C41.func1 == 0x4)
			inst->op = CLIP;	// v3.6 2010/7/7
		else if (raw.C41.func1 == 0x5)
			inst->op = CLIPD;
		else if (raw.C41.func1 == 0x6)
			inst->op = CLIPU;
		else if (raw.C41.func1 == 0x7)
			inst->op = CLIPUD;
	}
	// SEZE
	if (inst->op == FMACuu || inst->op == FMACuuD)
		inst->SEZE = 1;
	else
		inst->SEZE = 0;
	// CEB
	if (raw.C41.ceb == 0x0)
		inst->P_Addr = (unsigned char) INVALID_REG;
	else
		inst->P_Addr = raw.C41.ceb;
	// Addressing Mode
	if (inst->op == DSW || inst->op == DSNW) {
		if ((raw.C41.func1 & 0x4) == 0x4)
			inst->offset = 2;
		else
			inst->offset = 1;
	}
	// Rs2 & Rs1 & Rd
	if (inst->op == DSW || inst->op == DSNW) {
		// Rs2
		data = operand_decode(raw.C41.rs2);
		inst->Rd2_Addr = data & 0xFF;
		inst->Rd2_Type = data >> 8;
		// Rs1
		data = operand_decode(raw.C41.rs1);
		inst->Rd1_Addr = data & 0xFF;
		inst->Rd1_Type = data >> 8;
		// Rsd
		data = operand_decode(raw.C41.rsd);
		inst->Rs1_Addr = data & 0xFF;
		inst->Rs1_Type = data >> 8;
		// RsB
		if ((raw.C41.func1 & 0x3) == 0x1) {
			inst->Rs2_Addr = (data & 0xFF) + 1;
			inst->Rs2_Type = data >> 8;
		}
	} else {
		// Rs2
		data = operand_decode(raw.C41.rs2);
		inst->Rs2_Addr = data & 0xFF;
		inst->Rs2_Type = data >> 8;
		// Rs1
		data = operand_decode(raw.C41.rs1);
		inst->Rs1_Addr = data & 0xFF;
		inst->Rs1_Type = data >> 8;
		// Rsd
		data = operand_decode(raw.C41.rsd);
		inst->Rd1_Addr = data & 0xFF;
		inst->Rd1_Type = data >> 8;
	}
	// Imm32
	if (raw.C41.length == 0x5)
		inst->Imm32 = (((int) ((raw.C41.imm0) | (raw.C41.imm1 << 8)
							   | (raw.C41.imm2 << 16))) << 8) >> 8;
	else if (raw.C41.length == 0x4)
		inst->Imm32 = (short) ((raw.C41.imm0) | (raw.C41.imm1 << 8));
	else if (raw.C41.length == 0x3)
		inst->Imm32 = (char) (raw.C41.imm0);
	else
		inst->Imm32 = 0x0;

}

void SC_pac_if::decode_C5(inst_type raw, inst_t * inst)
{
	unsigned short data;

	//printf("Decoding C5 Type\n");
	// op
	if (raw.C51.opcode == 0x0) {
		if (raw.C51.u == 0x0)
			inst->op = SEQI;
		else
			inst->op = SEQIU;
	} else if (raw.C51.opcode == 0x2) {
		if (raw.C51.u == 0x0)
			inst->op = SLTI;
		else
			inst->op = SLTIU;
	} else if (raw.C51.opcode == 0x3) {
		if (raw.C51.u == 0x0)
			inst->op = SGTI;
		else
			inst->op = SGTIU;
	}
	// SEZE
	inst->SEZE = raw.C51.u;
	// CEB
	if (raw.C51.ceb == 0x0)
		inst->P_Addr = (unsigned char) INVALID_REG;
	else
		inst->P_Addr = raw.C51.ceb;
	// Rd
	data = operand_decode(raw.C51.rd);
	inst->Rd1_Addr = data & 0xFF;
	inst->Rd1_Type = data >> 8;
	// Rs1
	data = operand_decode(raw.C51.rs1);
	inst->Rs1_Addr = data & 0xFF;
	inst->Rs1_Type = data >> 8;
	// Pd1
	inst->Rd2_Addr = raw.C51.pd1;
	inst->Rd2_Type = Reg_P;
	// Pd2
	inst->Rs2_Addr = raw.C51.pd2;
	inst->Rs2_Type = Reg_P;
	// Imm32
	if (inst->op == SLTIU) {
		if (raw.C51.length == 0x6)
			inst->Imm32 = (raw.C51.imm0) | (raw.C51.imm1 << 8) |
				(raw.C51.imm2 << 16) | (raw.C51.imm3 << 24);
		else if (raw.C51.length == 0x5)
			inst->Imm32 =
				(raw.C51.imm0) | (raw.C51.imm1 << 8) | (raw.C51.imm2 << 16);
		else if (raw.C51.length == 0x4)
			inst->Imm32 = (raw.C51.imm0) | (raw.C51.imm1 << 8);
		else if (raw.C51.length == 0x3)
			inst->Imm32 = raw.C51.imm0;
		else
			inst->Imm32 = 0x0;
	} else {
		if (raw.C51.length == 0x6)
			inst->Imm32 = (raw.C51.imm0) | (raw.C51.imm1 << 8)
				| (raw.C51.imm2 << 16) | (raw.C51.imm3 << 24);
		else if (raw.C51.length == 0x5)
			inst->Imm32 = (((int) ((raw.C51.imm0) | (raw.C51.imm1 << 8)
								   | (raw.C51.imm2 << 16))) << 8) >> 8;
		else if (raw.C51.length == 0x4)
			inst->Imm32 = (short) ((raw.C51.imm0) | (raw.C51.imm1) << 8);
		else if (raw.C51.length == 0x3)
			inst->Imm32 = (char) (raw.C51.imm0);
		else
			inst->Imm32 = 0x0;
	}

}

void SC_pac_if::decode_D1(inst_type raw, inst_t * inst)
{
	unsigned short data;

	//printf("Decoding D1 Type\n");
	// op
	if (raw.D11.opcode == 0x0) {
		if (raw.D11.func1 == 0x0)
			inst->op = ABS;
		else if (raw.D11.func1 == 0x1)
			inst->op = ABSQ;
		else if (raw.D11.func1 == 0x2)
			inst->op = ABSD;
	} else if (raw.D11.opcode == 0x1) {
		if (raw.D11.func1 == 0x1)
			inst->op = MERGEA;
		else if (raw.D11.func1 == 0x3)
			inst->op = MERGES;
	} else if (raw.D11.opcode == 0x2) {
		if (raw.D11.func1 == 0x0)
			inst->op = LIMWCP;
		else if (raw.D11.func1 == 0x1)
			inst->op = LIMWUCP;
		else if (raw.D11.func1 == 0x2)
			inst->op = LIMHWCP;
		else if (raw.D11.func1 == 0x3)
			inst->op = LIMHWUCP;
	} else if (raw.D11.opcode == 0x3) {
		if (raw.D11.func1 == 0x0)
			inst->op = LIMBCP;
		else if (raw.D11.func1 == 0x1)
			inst->op = LIMBUCP;
		else if (raw.D11.func1 == 0x2)
			inst->op = COPY;
		else if (raw.D11.func1 == 0x3)
			inst->op = COPYU;
	} else if (raw.D11.opcode == 0x4) {
		if (raw.D11.func1 == 0x0)
			inst->op = NOT;
		else if (raw.D11.func1 == 0x2)
			inst->op = NOTP;
		else if (raw.D11.func1 == 0x1)
			inst->op = ROL;
		else if (raw.D11.func1 == 0x3)
			inst->op = ROR;
	} else if (raw.D11.opcode == 0x5) {
		if (raw.D11.func1 == 0x0)
			inst->op = UNPACK2;
		else if (raw.D11.func1 == 0x1)
			inst->op = UNPACK2U;
		else if (raw.D11.func1 == 0x2)
			inst->op = SWAP4;
		else if (raw.D11.func1 == 0x3)
			inst->op = SWAP4E;
	} else if (raw.D11.opcode == 0x6) {
		if (raw.D11.func1 == 0x0)
			inst->op = UNPACK4;
		else if (raw.D11.func1 == 0x1)
			inst->op = UNPACK4U;
		else if (raw.D11.func1 == 0x2)
			inst->op = NEG;
		else if (raw.D11.func1 == 0x3)
			inst->op = SWAP2;
	} else {
		if (raw.D11.func1 == 0x0)
			inst->op = CLS;
		else if (raw.D11.func1 == 0x1)
			inst->op = LMBD;
		else if (raw.D11.func1 == 0x2)
			inst->op = RND;
		else if (raw.D11.func1 == 0x3)
			inst->op = DEX;
	}
	// SEZE
	if (raw.D11.opcode == 0x2 || raw.D11.opcode == 0x3)
		inst->SEZE = raw.D11.func1 & 0x1;
	else if (inst->op == UNPACK4U)
		inst->SEZE = 1;
	else
		inst->SEZE = 0;
	// CEB
	if (raw.D11.ceb == 0x0)
		inst->P_Addr = (unsigned char) INVALID_REG;
	else
		inst->P_Addr = raw.D11.ceb;
	// Rs1
	data = operand_decode(raw.D11.rs2);
	inst->Rs1_Addr = data & 0xFF;
	inst->Rs1_Type = data >> 8;
	// Rd
	data = operand_decode(raw.D11.rd);
	inst->Rd1_Addr = data & 0xFF;
	inst->Rd1_Type = data >> 8;

	if (inst->op == NOTP) {
		inst->Rd1_Type = Reg_P;
		inst->Rd1_Addr = raw.D11.rd & 0xF;
		inst->Rs1_Type = Reg_P;
		inst->Rs1_Addr = raw.D11.rs2 & 0xF;
	}

	inst->Imm32 = 0;
}

void SC_pac_if::decode_D2(inst_type raw, inst_t * inst)
{
	unsigned short data;

	//printf("Decoding D2 Type\n");
	// op
	if (raw.D21.op == 0x0)
		inst->op = BDT;
	else
		inst->op = DBDT;
	// CEB
	if (raw.D21.ceb == 0x0)
		inst->P_Addr = (unsigned char) INVALID_REG;
	else
		inst->P_Addr = raw.D21.ceb;
	// Rs2
	if (inst->op == DBDT) {
		data = operand_decode(raw.D21.rs2);
		inst->Rs2_Addr = data & 0xFF;
		inst->Rs2_Type = data >> 8;
	}
	// Rs1
	data = operand_decode(raw.D21.rs1);
	inst->Rs1_Addr = data & 0xFF;
	inst->Rs1_Type = data >> 8;

	inst->Imm32 = 0;
}

void SC_pac_if::decode_D3(inst_type raw, inst_t * inst)
{
	//printf("Decoding D3 Type\n");

	// op
	inst->op = TEST;
	// Pd1
	inst->Rd1_Addr = raw.D31.pd1;
	inst->Rd1_Type = Reg_P;
	// Pd2
	inst->Rd2_Addr = raw.D31.pd2;
	inst->Rd2_Type = Reg_P;
	// offset
	inst->offset = (raw.D31.imm0) | (raw.D31.imm1 << 8);
	// Imm32
	inst->Imm32 = (raw.D31.imm2) | (raw.D31.imm3 << 8);
}

void SC_pac_if::decode_D4(inst_type raw, inst_t * inst)
{
	unsigned short data;

	//printf("Decoding D4 Type\n");
	// op
	if (raw.D41.op == 0x0)
		inst->op = PERMH2;
	else
		inst->op = PERMH4;
	// Rd
	data = operand_decode(raw.D41.rd);
	inst->Rd1_Addr = data & 0xFF;
	inst->Rd1_Type = data >> 8;
	// CEB
	if (raw.D41.ceb == 0x0)
		inst->P_Addr = (unsigned char) INVALID_REG;
	else
		inst->P_Addr = raw.D41.ceb;
	// Rs2
	data = operand_decode(raw.D41.rs2);
	inst->Rs2_Addr = data & 0xFF;
	inst->Rs2_Type = data >> 8;
	// Rs1
	data = operand_decode(raw.D41.rs1);
	inst->Rs1_Addr = data & 0xFF;
	inst->Rs1_Type = data >> 8;
	// Imm32
	inst->Imm32 = raw.D41.imm0;

}

void SC_pac_if::decode_D5(inst_type raw, inst_t * inst)
{
	unsigned short data;

	//printf("Decoding D5 Type\n");
	// op
	if (raw.D51.op == 0x0) {
		if (raw.D51.u == 0)
			inst->op = MOVIL;
		else
			inst->op = COPY_CFI;	// v3.6 2008.8.18
	} else {
		if (raw.D51.u == 0x0)
			inst->op = MOVIH;
		else
			inst->op = MOVIUH;
	}
	// SEZE
	if (inst->op == MOVIUH)
		inst->SEZE = 1;
	else
		inst->SEZE = 0;
	// Rsd
	data = operand_decode(raw.D51.rsd);
	inst->Rd1_Addr = data & 0xFF;
	inst->Rd1_Type = data >> 8;
	// CEB
	if (raw.D51.ceb == 0x0)
		inst->P_Addr = (unsigned char) INVALID_REG;
	else
		inst->P_Addr = raw.D51.ceb;
	// Imm32
	inst->Imm32 = (raw.D51.imm0) | (raw.D51.imm1 << 8);
}

void SC_pac_if::decode_D6(inst_type raw, inst_t * inst)
{
	unsigned short data;

	//printf("Decoding D6 Type\n");
	// op
	inst->op = PAC_WAIT;
	// Rsd
	data = operand_decode(raw.D61.rsd);
	inst->Rd1_Addr = data & 0xFF;
	inst->Rd1_Type = data >> 8;
	// offset
	inst->offset = (raw.D61.imm0) | (raw.D61.imm1 << 8);
	// Imm32
	inst->Imm32 = (raw.D61.imm2) | (raw.D61.imm3 << 8);
}

void SC_pac_if::decode_D7(inst_type raw, inst_t * inst)
{
	unsigned short data;

	//printf("Decoding D7 Type\n");
	// op
	if (raw.D71.opcode == 0x0) {
		switch (raw.D71.func1) {
		case 0:
			inst->op = SLT;
			break;
		case 1:
			inst->op = SLTU;
			break;
		case 2:
			inst->op = SLTL;
			break;
		case 3:
			inst->op = SLTUL;
			break;
		default:
			printf("Undefined func1 in D7 type!! Abort!!\n");
			exit(-1);
		}
	} else if (raw.D71.opcode == 0x1) {
		switch (raw.D71.func1) {
		case 2:
			inst->op = SLTH;
			break;
		case 3:
			inst->op = SLTUH;
			break;
		default:
			printf("Undefined func1 in D7 type!! Abort!!\n");
			exit(-1);
		}
	} else if (raw.D71.opcode == 0x2) {
		switch (raw.D71.func1) {
		case 0:
			inst->op = SEQ;
			break;
		case 2:
			inst->op = SEQL;
			break;
		default:
			printf("Undefined func1 in D7 type!! Abort!!\n");
			exit(-1);
		}
	} else if (raw.D71.opcode == 0x3) {
		switch (raw.D71.func1) {
		case 2:
			inst->op = SEQH;
			break;
		default:
			printf("Undefined func1 in D7 type!! Abort!!\n");
			exit(-1);
		}
	} else {
		printf("Undefined opcode in D7 type!! Abort!!\n");
		exit(-1);
	}
	// SEZE
	if (raw.D71.opcode == 0x0 || raw.D71.opcode == 0x1)
		inst->SEZE = raw.D71.func1 & 0x1;
	else
		inst->SEZE = 0;
	// CEB
	if (raw.D71.ceb == 0x0)
		inst->P_Addr = (unsigned char) INVALID_REG;
	else
		inst->P_Addr = raw.D71.ceb;
	// Rs2
	data = operand_decode(raw.D71.rs2);
	inst->Rs2_Addr = data & 0xFF;
	inst->Rs2_Type = data >> 8;
	// Rs1
	data = operand_decode(raw.D71.rs1);
	inst->Rs1_Addr = data & 0xFF;
	inst->Rs1_Type = data >> 8;
	// Rd
	data = operand_decode(raw.D71.rd);
	inst->Rd1_Addr = data & 0xFF;
	inst->Rd1_Type = data >> 8;
	// Pd1
	inst->Rd2_Addr = raw.D71.pd1;
	inst->Rd2_Type = Reg_P;
	// Pd2
	inst->WB_Data = raw.D71.pd2;
	inst->WB_Data1 = Reg_P;

	inst->Imm32 = 0;

}

int SC_pac_if::decode_P1(inst_type * pkt_inst, inst_packet * package,
						int *isbranch)
{
	int i;
	inst_t *inst;
	inst_type raw;

	for (i = 0; i < 5; i++) {
		// init
		inst = &(package->instr[i].inst);
		inst->Memory_Addr = 0;
		raw.RAW = pkt_inst[i].RAW;
		cluster_idx = i;
		if (raw.RAW == 0x0) {
			if (inst->op == 0xff) {
				inst->op = NOP;
				inst->Imm32 = 0x0;
				inst->Memory_Addr = 0x0;
			}
			continue;
		}
		// decide inst type
		if ((raw.RAW & 0x7F) == 0x66)
			decode_D6(raw, inst);	// D6
		else if ((raw.RAW & 0x7F) == 0x26)
			decode_D3(raw, inst);	// D3
		else if ((raw.RAW & 0x3F) == 0x06)
			decode_D7(raw, inst);	// D7
		else if ((raw.RAW & 0x1F) == 0x16)
			decode_D5(raw, inst);	// D5
		else if ((raw.RAW & 0x1F) == 0x1E)
			decode_D2(raw, inst);	// D2
		else if ((raw.RAW & 0x1F) == 0x0E)
			decode_D1(raw, inst);	// D1
		else if ((raw.RAW & 0xF) == 0xA)
			decode_D4(raw, inst);	// D4
		else if ((raw.RAW & 0xF) == 0xC)
			decode_C5(raw, inst);	// C5
		else if ((raw.RAW & 0xF) == 0x2)
			decode_C4(raw, inst);	// C4
		else if ((raw.RAW & 0xF) == 0x4)
			decode_C2(raw, inst);	// C2
		else if ((raw.RAW & 0x7) == 0x1)
			decode_C3(raw, inst);	// C3
		else if ((raw.RAW & 0x7) == 0x5)
			decode_C1(raw, inst);	// C1
		else if ((raw.RAW & 0x7) == 0x0)
			decode_A(raw, inst);	// A
		else if ((raw.RAW & 0x3) == 0x3)
			decode_B(raw, inst);	// B
		else {
			return -1;
		}
	}
	inst = &package->instr[0].inst;
	if (inst->op == B || inst->op == BR || inst->op == BRR)
		*isbranch = 1;
	return 0;

}

int SC_pac_if::decode(Inst_Package_more * instpacket, unsigned int pc, int *isbranch)
{
	int i;
	unsigned int package_len = 0;
	int inst_length = 0;
	int inst_idx = 0;
	unsigned long long inst_tail = 0;
	unsigned char instcode[64];
	unsigned char buf[72];

	cap_type cap;
	inst_type inst;
	inst_type pkt_inst[5];


	// init
	memset(pkt_inst, 0, sizeof(inst_type) * 5);
	memset(instpacket, -1, sizeof(Inst_Package_more));
	cap.RAW = 0x0;
	inst.RAW = 0x0;
	inst_length = 0x0;
	// fetch CAP
	//if (icache_read(pc, (unsigned char *) (&cap.RAW), 2) == -1)

	if (icache_read(pc, buf, sizeof(buf)) == -1)
		return -1;

	memcpy((unsigned char *)(&cap.RAW), buf, 2);

	// fill in PC field in inst_table 
	instpacket->package.PC = pc;
	if (cap.RAW == 0x0) {
		instpacket->package.instr[0].inst.op = TRAP;
		return 2;
	}
	//semihosting break check , cap bit8 bit9 must be 1
	if ((cap.RAW & 0x300) == 0x300) {
		instpacket->package.breakpoint = 0xab;
		for (i = 0; i < 5; i++) {
			instpacket->package.instr[i].inst.op = NOP;
			instpacket->package.instr[i].inst.Imm32 = 0x0;
			instpacket->package.instr[i].inst.Memory_Addr = 0x0;
		}
		instpacket->packet_len = 2;
		return 2;
	}

	if ((cap.RAW & 1) == 1)	// trap / roe
	{
		// TRAP & ROE
		if (cap.VC.func == 0xF) {
			instpacket->package.instr[0].inst.op = TRAP;
			instpacket->packet_len = 2;
		} else if (cap.VC.func == 0x0) {
			instpacket->package.instr[0].inst.op = ROE;
			instpacket->packet_len = 2;
		} else {
			printf("invalade cap  PC=%d RAW=%x!\n", pc, cap.RAW);
			return -1;
		}
	} else {
		package_len = (cap.RAW >> 10) & 0x3f;
		//icache_read(pc + 2, instcode, package_len - 2);

		memcpy(instcode, &buf[2], package_len - 2);
		inst_idx = 0;

		// fetch header
		if (cap.Normal.ps == 0x1) {
			memcpy((char *) &pkt_inst[0].RAW, &instcode[inst_idx], 2);
			inst_idx += 2;
		}
		if (cap.Normal.ls1 == 0x1) {
			memcpy((char *) &pkt_inst[1].RAW, &instcode[inst_idx], 2);
			inst_idx += 2;
		}
		if (cap.Normal.a1 == 0x1) {
			memcpy((char *) &pkt_inst[2].RAW, &instcode[inst_idx], 2);
			inst_idx += 2;
		}
		if (cap.Normal.ls2 == 0x1) {
			memcpy((char *) &pkt_inst[3].RAW, &instcode[inst_idx], 2);
			inst_idx += 2;
		}
		if (cap.Normal.a2 == 0x1) {
			memcpy((char *) &pkt_inst[4].RAW, &instcode[inst_idx], 2);
			inst_idx += 2;
		}
		// fetch tail
		if (cap.Normal.ps == 0x1) {
			inst_tail = 0x0;
			inst_length = pac_length_decode(pkt_inst[0].RAW);
			if (inst_length == -1)
				return -1;
			memcpy((char *) ((char *) &pkt_inst[0].RAW + 2),
				   &instcode[inst_idx], inst_length);
			inst_idx += inst_length;
		}
		if (cap.Normal.ls1 == 0x1) {
			inst_tail = 0x0;
			inst_length = pac_length_decode(pkt_inst[1].RAW);
			if (inst_length == -1)
				return -1;
			memcpy((char *) ((char *) &pkt_inst[1].RAW + 2),
				   &instcode[inst_idx], inst_length);
			inst_idx += inst_length;
		}
		if (cap.Normal.a1 == 0x1) {
			inst_tail = 0x0;
			inst_length = pac_length_decode(pkt_inst[2].RAW);
			if (inst_length == -1)
				return -1;
			memcpy((char *) ((char *) (&pkt_inst[2].RAW) + 2),
				   &instcode[inst_idx], inst_length);
			inst_idx += inst_length;
		}
		if (cap.Normal.ls2 == 0x1) {
			inst_tail = 0x0;
			inst_length = pac_length_decode(pkt_inst[3].RAW);
			if (inst_length == -1)
				return -1;
			memcpy((char *) ((char *) &pkt_inst[3].RAW + 2),
				   &instcode[inst_idx], inst_length);
			inst_idx += inst_length;
		}

		if (cap.Normal.a2 == 0x1) {
			inst_tail = 0x0;
			inst_length = pac_length_decode(pkt_inst[4].RAW);
			if (inst_length == -1)
				return -1;
			memcpy((char *) ((char *) &pkt_inst[4].RAW + 2),
				   &instcode[inst_idx], inst_length);
			inst_idx += inst_length;
		}
		// check broadcast
		if (cap.Normal.bls == 0x1)
			pkt_inst[3].RAW = pkt_inst[1].RAW;
		if (cap.Normal.ba == 0x1)
			pkt_inst[4].RAW = pkt_inst[2].RAW;
		instpacket->packet_len = package_len;
	}
	return decode_P1(pkt_inst, &instpacket->package, isbranch);
}

Inst_Package_more * SC_pac_if::pac_get_inst_packet(unsigned int pc)
{
	int is_branch;

	if (dbg_step_flag == 1) {
			memif_req_count = 4;
	}
	if (decode(&pac_packet, pc, &is_branch) == -1) {
		printf("Decode fail PC= %d", pc);
		return 0;
	}
	return &pac_packet;
}

void SC_pac_if::sc_pac_pipeline_if(int is_step)
{
	int i;
	inst_packet nop_packet;
	inst_packet trap_packet;
	Inst_Package_more *packet;
	struct soc_shm_prot *base_ptr = soc_shm_base_ptr + 3;
	
	memset(&nop_packet, 0, sizeof(inst_packet));

	for (i = 0; i < 5; i++) {
		memset(&(nop_packet.instr[i].inst), -1, sizeof(inst_t));
		nop_packet.instr[i].inst.op = NOP;
//              nop_packet.instr[i].inst.Imm32 = 0x0;
//              nop_packet.instr[i].inst.Memory_Addr = 0x0;
	}
	nop_packet.PC = 0xffffffff;

	if (ro_regs.sim_end == 0) {	// Run
		if (branch_occur == 1) {	// Branch
			branch_occur = 0;
			memcpy(&(exec_table[WB_IDX]), &nop_packet, sizeof(inst_packet));
			idle(&base_ptr->flag);
		}
		else {			// Normal
			packet = pac_get_inst_packet(fetch_pc);
			if (packet == NULL)
				exit(-1);
			memcpy(&(exec_table[WB_IDX]), &(packet->package), sizeof(inst_packet));
			fetch_pc += packet->packet_len;

			if (is_step && ((unsigned int) state_machine != STATE_NORMAL)) {
				state_machine--;
				if ((state_machine & 0xff) == 0) {
					fetch_pc = branch_target;
					state_machine = STATE_NORMAL;
				}

			} else if (((unsigned int) state_machine != STATE_NORMAL)
					   && (state_machine & STATE_BREAK_IN_SLOT) != 0) {
				if (state_pipe_empty != 0) {
					statetmp--;
					state_pipe_empty--;
					if (statetmp == 0) {
						branch_occur = 1;
						fetch_pc = branch_target;
					}
					if (state_pipe_empty == 0)
						state_machine &= ~STATE_BREAK_IN_SLOT;
				}
			} else if ((unsigned int) state_machine != STATE_NORMAL) {
				state_machine--;
				if ((state_machine & 0xff) == 0)
					state_machine = STATE_NORMAL;
			}
		}
	} else {			// TRAP
		int pc;

		ro_regs.sim_end--;
		if (ro_regs.sim_end == 4) {
			pc = exec_table[EX2_IDX].PC;
			global_regs.RF[7][9] = pc;
		}

		memset(&trap_packet, 0, sizeof(inst_packet));
		for (i = 0; i < 5; i++) {
			memset(&(trap_packet.instr[i].inst), -1, sizeof(inst_t));
			trap_packet.instr[i].inst.op = NOP;
		}
		memcpy(&(exec_table[WB_IDX]), &trap_packet, sizeof(inst_packet));
		if (ro_regs.sim_end == 8) {
			memcpy(&(exec_table[IF_IDX]), &nop_packet, sizeof(inst_packet));
		}
		
		idle(&base_ptr->flag);
	}
}

void SC_pac_if::sc_pac_if_run()
{
	struct soc_shm_prot *base_ptr = soc_shm_base_ptr + 3;
	while (1) {
		wait();
		if (if_pin.event())
		    dbg_step_flag = 1;

		// start running after ex1
		wait(SC_ZERO_TIME);
		wait(SC_ZERO_TIME);

		//printf("%s wakeup\r\n", __func__);
		if (exec_table[IDISP_IDX].instr[0].inst.op == TRAP)
			ro_regs.sim_end = 9;

		if (dbg_step_flag == 1) {
			memif_req_count = 4;
		} else {
			memif_req_count++;
		}
		base_ptr->inst_mode = INST_IF;

		sc_pac_pipeline_if(if_event_step);
		
		wait(SC_ZERO_TIME);
		wait(SC_ZERO_TIME);
		
		if(dbg_step_flag) {
		    if_resp_event.notify();
		    dbg_step_flag = 0;    
		} else {
		    mod_count++;
		    //printf("if mod_count %d\r\n", mod_count);
		    if(mod_count == 5)
			mod_resp_event.notify();
		}
	}
}
