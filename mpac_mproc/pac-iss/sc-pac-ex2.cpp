#include "pac-dsp.h"
#include "pac-socshm-prot.h"
#include "sc-pac-ex2.h"
#include "sc-pac-memif.h"

void SC_pac_ex2::idle(volatile int *flag)
{
//	while (*flag != RESPONSE) {}

	if(memif_req_count == 4)
		monitor_req_event.notify();
	
	wait(monitor_resp_event);

}

void SC_pac_ex2::dmem_read(unsigned int addr, unsigned long long *buf,
						unsigned char len)
{
	struct soc_shm_prot *base_ptr = soc_shm_base_ptr + ex2_id;
	//printf("SC_pac_memif::dmem_read addr = 0x%08x.\r\n", (int)addr);

	base_ptr->addr = addr;
	base_ptr->len = (unsigned int) len;
	base_ptr->cmd = DMEM_READ;
	base_ptr->flag = REQUEST;

//	if (!multi_arg(boot, share_mode)) {
		idle(&base_ptr->flag);
//	} else {
//		int dummy_space, i;

//		i = read(iss_soc_fifo_fd, &dummy_space, 1);
//	}

	memcpy((unsigned char *) buf, (unsigned char *) base_ptr->buf, len);
	base_ptr->flag = IDLE;
	return;
}

int SC_pac_ex2::dmem_write(unsigned int addr, unsigned long long *buf,
						unsigned char len)
{
	struct soc_shm_prot *base_ptr = soc_shm_base_ptr + ex2_id;
	//printf("SC_pac_memif::dmem_write addr = 0x%08x.\r\n", (int)addr);

	base_ptr->addr = addr;
	base_ptr->len = (unsigned int) len;
	memcpy((unsigned char *) base_ptr->buf, (unsigned char *) buf, len);
	base_ptr->cmd = DMEM_WRITE;
	base_ptr->flag = REQUEST;
	base_ptr->futex = 0x11;

//	if (!multi_arg(boot, share_mode)) {
		idle(&base_ptr->flag);
//	} else {
//		int dummy_space, i;
//		i = read(iss_soc_fifo_fd, &dummy_space, 1);
//	}

	base_ptr->flag = IDLE;
	return 0;
}

unsigned long long SC_pac_ex2::data_access(unsigned char type,
										 unsigned int addr,
										 unsigned char size,
										 unsigned long long data)
{
	unsigned long long udata = 0;

	if (dsp_core->is_wbp_hit(addr, size, type) == 1) {
		dsp_core->eStopFlag = STOP_WB;
		return 0;
	}

	if (type == READ) {
		dmem_read(addr, &udata, size);
		return udata;
	} else if ((type == WRITE) || (type == WRITED)) {
		dmem_write(addr, &data, size);
	} else {
		printf("Unsupport memory accces type\n");
		return (1);
	}
	return 0;
}

void SC_pac_ex2::adds_ls_ex2(inst_t * curinst)
{
	unsigned long long udst;

	udst = curinst->WB_Data | ((unsigned long long) curinst->WB_Data1 << 32);
	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst);
	stage2_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst);
}

void SC_pac_ex2::addus_ls_ex2(inst_t * curinst)
{
	unsigned long long uldst;

	uldst = curinst->WB_Data | ((unsigned long long) curinst->WB_Data1 << 32);

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, uldst);
	stage2_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, uldst);
}

void SC_pac_ex2::addds_ls_ex2(inst_t * curinst)
{
	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
					(unsigned long long) (curinst->WB_Data));
	stage2_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
				   (unsigned long long) (curinst->WB_Data));
}

void SC_pac_ex2::addqs_ls_ex2(inst_t * curinst)
{
	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
					(unsigned long long) (curinst->WB_Data));
	stage2_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
				   (unsigned long long) (curinst->WB_Data));
}

void SC_pac_ex2::adduds_ls_ex2(inst_t * curinst)
{
	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
					(unsigned long long) (curinst->WB_Data));
	stage2_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
				   (unsigned long long) (curinst->WB_Data));
}

void SC_pac_ex2::adduqs_ls_ex2(inst_t * curinst)
{
	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
					(unsigned long long) (curinst->WB_Data));
	stage2_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
				   (unsigned long long) (curinst->WB_Data));
}

void SC_pac_ex2::addis_ls_ex2(inst_t * curinst)
{
	unsigned long long uldst;

	uldst = curinst->WB_Data | ((unsigned long long) curinst->WB_Data1 << 32);

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, uldst);
	stage2_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, uldst);
}

void SC_pac_ex2::addids_ls_ex2(inst_t * curinst)
{
	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
					(unsigned long long) (curinst->WB_Data));
	stage2_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
				   (unsigned long long) (curinst->WB_Data));
}

void SC_pac_ex2::addiuds_ls_ex2(inst_t * curinst)
{
	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
					(unsigned long long) (curinst->WB_Data));
	stage2_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
				   (unsigned long long) (curinst->WB_Data));
}

void SC_pac_ex2::subs_ls_ex2(inst_t * curinst)
{
	unsigned long long uldst;

	uldst = curinst->WB_Data | ((unsigned long long) curinst->WB_Data1 << 32);
	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, uldst);
	stage2_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, uldst);
}

void SC_pac_ex2::subds_ls_ex2(inst_t * curinst)
{
	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
					(unsigned long long) (curinst->WB_Data));
	stage2_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
				   (unsigned long long) (curinst->WB_Data));
}

void SC_pac_ex2::subqs_ls_ex2(inst_t * curinst)
{
	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
					(unsigned long long) (curinst->WB_Data));
	stage2_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
				   (unsigned long long) (curinst->WB_Data));
}

void SC_pac_ex2::subus_ls_ex2(inst_t * curinst)
{
	unsigned long long uldst;

	uldst = curinst->WB_Data | ((unsigned long long) curinst->WB_Data1 << 32);
	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, uldst);
	stage2_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, uldst);
}

void SC_pac_ex2::subuds_ls_ex2(inst_t * curinst)
{
	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
					(unsigned long long) (curinst->WB_Data));
	stage2_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
				   (unsigned long long) (curinst->WB_Data));
}

void SC_pac_ex2::subuqs_ls_ex2(inst_t * curinst)
{
	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
					(unsigned long long) (curinst->WB_Data));
	stage2_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
				   (unsigned long long) (curinst->WB_Data));
}

void SC_pac_ex2::addcs_ls_ex2(inst_t * curinst)
{
	unsigned long long udst;

	udst = curinst->WB_Data | ((unsigned long long) curinst->WB_Data1 << 32);
	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst);
	stage2_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst);
}

void SC_pac_ex2::addcus_ls_ex2(inst_t * curinst)
{
	unsigned long long udst;

	udst = curinst->WB_Data | ((unsigned long long) curinst->WB_Data1 << 32);
	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst);
	stage2_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst);
}

void SC_pac_ex2::lw_ls_ex2(inst_t * curinst)
{
#if 1 //liqin
	curinst->WB_Data = (int) data_access(READ, curinst->Memory_Addr, 4, 0);
#else
	unsigned int tmp;
	unsigned short base, end;

	if (curinst->op != LNW || curinst->WB_Data == 0) {
		curinst->WB_Data =
			(int) data_access(READ, curinst->Memory_Addr, 4, 0);
	} else {
		base = curinst->WB_Data >> 16;
		end = curinst->WB_Data;
		if ((end - curinst->Memory_Addr) < 4) {
			tmp =
				data_access(READ, curinst->Memory_Addr,
							end - curinst->Memory_Addr, 0);
			tmp |=
				(data_access(READ, base, 4 - (end - curinst->Memory_Addr), 0)
				 << ((end - curinst->Memory_Addr) * 8));
		} else
			tmp = data_access(READ, curinst->Memory_Addr, 4, 0);

		curinst->WB_Data = (int) tmp;
	}
#endif
}

void SC_pac_ex2::lwu_ls_ex2(inst_t * curinst)
{
	curinst->WB_Data = data_access(READ, curinst->Memory_Addr, 4, 0);
}

void SC_pac_ex2::dlw_ls_ex2(inst_t * curinst)
{
	unsigned long long udst;

#if 1 //liqin
	udst = data_access(READ, curinst->Memory_Addr, 8, 0);
#else
	unsigned long long tmp;
	unsigned short base, end;

	if (curinst->op != DLNW || curinst->WB_Data == 0) {
		udst = data_access(READ, curinst->Memory_Addr, 8, 0);
	} else {
		base = curinst->WB_Data >> 16;
		end = curinst->WB_Data;
		if ((end - curinst->Memory_Addr) < 8) {
			tmp =
				data_access(READ, curinst->Memory_Addr,
							end - curinst->Memory_Addr, 0);
			tmp |=
				(data_access(READ, base, 8 - (end - curinst->Memory_Addr), 0)
				 << ((end - curinst->Memory_Addr) * 8));
		} else
			tmp = data_access(READ, curinst->Memory_Addr, 8, 0);

		udst = tmp;
	}

#endif
	curinst->WB_Data = (int) udst;
	curinst->WB_Data1 = (int) (udst >> 32);
}

void SC_pac_ex2::dlwu_ls_ex2(inst_t * curinst)
{
	unsigned long long udst;

	udst = data_access(READ, curinst->Memory_Addr, 8, 0);
	curinst->WB_Data = (unsigned int) udst;
	curinst->WB_Data1 = (unsigned int) (udst >> 32);
}

void SC_pac_ex2::lh_ls_ex2(inst_t * curinst)
{
	curinst->WB_Data = data_access(READ, curinst->Memory_Addr, 2, 0);
}

void SC_pac_ex2::lhu_ls_ex2(inst_t * curinst)
{
	curinst->WB_Data = data_access(READ, curinst->Memory_Addr, 2, 0);
}

void SC_pac_ex2::dlh_ls_ex2(inst_t * curinst)
{
	unsigned long long udst;

	udst = data_access(READ, curinst->Memory_Addr, 6, 0);
	curinst->WB_Data = (short) udst;
	curinst->WB_Data1 = (short) (udst >> 32);
}

void SC_pac_ex2::dlhu_ls_ex2(inst_t * curinst)
{
	unsigned long long udst;

	udst = data_access(READ, curinst->Memory_Addr, 6, 0);
	curinst->WB_Data = (unsigned short) udst;
	curinst->WB_Data1 = (unsigned short) (udst >> 32);
}

void SC_pac_ex2::lb_ls_ex2(inst_t * curinst)
{
	curinst->WB_Data = data_access(READ, curinst->Memory_Addr, 1, 0);
}

void SC_pac_ex2::lbu_ls_ex2(inst_t * curinst)
{
	curinst->WB_Data = data_access(READ, curinst->Memory_Addr, 1, 0);
}

//read data in ex2
void SC_pac_ex2::sw_ls_ex2(inst_t * curinst)
{
#if 1 //liqin
	data_access(WRITE, curinst->Memory_Addr, 4, curinst->WB_Data);
#else
	unsigned short base, end;

	if (curinst->op != SNW || (curinst->WM == 0 && curinst->WV == 0)) {
		//data_access(READ, curinst->Memory_Addr, 4, 0);	// for memory contention detection
		data_access(WRITE, curinst->Memory_Addr, 4, curinst->WB_Data);
	} else {
		base = curinst->WM;
		end = curinst->WV;
		if ((end - curinst->Memory_Addr) < 4) {
			//data_access(READ, curinst->Memory_Addr, end - curinst->Memory_Addr, 0);	// for memory contention detection
			data_access(WRITE, curinst->Memory_Addr,
						end - curinst->Memory_Addr, curinst->WB_Data);
			//data_access(READ, base, 4 - (end - curinst->Memory_Addr), 0);	// for memory contention detection
			data_access(WRITE, base, 4 - (end - curinst->Memory_Addr),
						curinst->WB_Data >> ((end - curinst->Memory_Addr) * 8));
		} else {
			//data_access(READ, curinst->Memory_Addr, 4, 0);	// for memory contention detection
			data_access(WRITE, curinst->Memory_Addr, 4, curinst->WB_Data);
		}
	}
#endif
}

void SC_pac_ex2::dsw_ls_ex2(inst_t * curinst)
{
#if 1
	unsigned long long u = ((unsigned long long)(curinst->WB_Data1) << 32) | (curinst->WB_Data);
	data_access(WRITE, curinst->Memory_Addr, 8, u);
#else
	unsigned short base, end;

	if (curinst->op != DSNW || (curinst->WM == 0 && curinst->WV == 0)) {
		data_access(WRITE, curinst->Memory_Addr, 4, curinst->WB_Data);
		data_access(WRITED, curinst->Memory_Addr + 4, 4, curinst->WB_Data1);
	} else {
		base = curinst->WM;
		end = curinst->WV;
		if ((end - curinst->Memory_Addr) < 4) {
			data_access(WRITE, curinst->Memory_Addr,
						end - curinst->Memory_Addr, curinst->WB_Data);
			data_access(WRITE, base, 4 - (end - curinst->Memory_Addr),
						curinst->WB_Data >> ((end - curinst->Memory_Addr) *
											 8));
			data_access(WRITE, base + (4 - (end - curinst->Memory_Addr)), 4,
						curinst->WB_Data1);
		} else if ((end - curinst->Memory_Addr) < 8) {
			data_access(WRITE, curinst->Memory_Addr, 4, curinst->WB_Data);
			data_access(WRITE, curinst->Memory_Addr + 4,
						end - curinst->Memory_Addr - 4, curinst->WB_Data1);
			data_access(WRITE, base, 8 - (end - curinst->Memory_Addr),
						curinst->
						WB_Data1 >> ((end - curinst->Memory_Addr - 4) * 8));
		} else {
			data_access(WRITE, curinst->Memory_Addr, 4, curinst->WB_Data);
			data_access(WRITED, curinst->Memory_Addr + 4, 4,
						curinst->WB_Data1);
		}
	}
#endif
}

void SC_pac_ex2::sh_ls_ex2(inst_t * curinst)
{
	//data_access(READ, curinst->Memory_Addr, 2, 0);	// for memory contention detection
	data_access(WRITE, curinst->Memory_Addr, 2, curinst->WB_Data);
}

void SC_pac_ex2::sb_ls_ex2(inst_t * curinst)
{
	//data_access(READ, curinst->Memory_Addr, 1, 0);	// for memory contention detection
	data_access(WRITE, curinst->Memory_Addr, 1, curinst->WB_Data);
}
// end of store functions.

void SC_pac_ex2::bdr_ls_ex2(inst_t * curinst)
{
	if (regTBDT == 0) {
		if (regTBDR1 == 0) {
			regT1Type = ((curinst->Rd1_Addr << 16) | curinst->Rd1_Type);
			regTBDR1 = cluster_idx + 1;
		} else {
			regT2Type = ((curinst->Rd1_Addr << 16) | curinst->Rd1_Type);
			regTBDR2 = cluster_idx + 1;
		}
	} else {
		regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, (int) regT1);
		stage2_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, (int) regT1);
	}
}

void SC_pac_ex2::dbdr_ls_ex2(inst_t * curinst)
{
	if (regTBDT == 0) {
		if (regTBDR1 == 0) {
			regT1Type = ((curinst->Rd1_Addr << 16) | curinst->Rd1_Type);
			regTBDR1 = cluster_idx + 1;
		} else {
			regT2Type = ((curinst->Rd1_Addr << 16) | curinst->Rd1_Type);
			regTBDR2 = cluster_idx + 1;
		}
	} else {
		regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, (int) regT1);
		regfile_l_write(curinst->Rd1_Addr + 1, curinst->Rd1_Type,
						(int) regT2);
		stage2_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, (int) regT1);
		stage2_l_write(curinst->Rd1_Addr + 1, curinst->Rd1_Type, (int) regT2);
	}
}

void SC_pac_ex2::bdt_ls_ex2(inst_t * curinst)
{
	int tmp;

	regT1 = curinst->WB_Data;
	regTBDT = cluster_idx + 1;

	if (regTBDR1 != 0) {
		tmp = cluster_idx;
		cluster_idx = regTBDR1 - 1;
		regfile_l_write((regT1Type >> 16), LOW16MASK(regT1Type), (int) regT1);
		stage2_l_write((regT1Type >> 16), LOW16MASK(regT1Type), (int) regT1);
		cluster_idx = tmp;
		regTBDR1 = 0;
	}
	if (regTBDR2 != 0) {
		tmp = cluster_idx;
		cluster_idx = regTBDR2 - 1;
		regfile_l_write((regT2Type >> 16), LOW16MASK(regT2Type), (int) regT1);
		stage2_l_write((regT2Type >> 16), LOW16MASK(regT2Type), (int) regT1);
		cluster_idx = tmp;
		regTBDR2 = 0;
	}
}

void SC_pac_ex2::dbdt_ls_ex2(inst_t * curinst)
{
	int tmp;

	regT1 = curinst->WB_Data;
	regT2 = curinst->WB_Data1;
	regTBDT = cluster_idx + 1;

	if (regTBDR1 != 0) {
		tmp = cluster_idx;
		cluster_idx = regTBDR1 - 1;
		regfile_l_write((regT1Type >> 16), LOW16MASK(regT1Type), (int) regT1);
		regfile_l_write((regT1Type >> 16) + 1, LOW16MASK(regT1Type),
						(int) regT2);
		stage2_l_write((regT1Type >> 16), LOW16MASK(regT1Type), (int) regT1);
		stage2_l_write((regT1Type >> 16) + 1, LOW16MASK(regT1Type),
					   (int) regT2);
		cluster_idx = tmp;
		regTBDR1 = 0;
	}
	if (regTBDR2 != 0) {
		tmp = cluster_idx;
		cluster_idx = regTBDR2 - 1;
		regfile_l_write((regT2Type >> 16), LOW16MASK(regT2Type), (int) regT1);
		regfile_l_write((regT2Type >> 16) + 1, LOW16MASK(regT2Type),
						(int) regT2);
		stage2_l_write((regT2Type >> 16), LOW16MASK(regT2Type), (int) regT1);
		stage2_l_write((regT2Type >> 16) + 1, LOW16MASK(regT2Type),
					   (int) regT2);
		cluster_idx = tmp;
		regTBDR2 = 0;
	}
}

void SC_pac_ex2::dex_ls_ex2(inst_t * curinst)
{
	unsigned int usrc;
	int tmp;

	usrc = curinst->WB_Data;
	if (regTFlag == 0) {
		regT1 = usrc;
		regT1Type = ((curinst->Rd1_Addr << 16) | curinst->Rd1_Type);
		regTFlag = cluster_idx + 1;
	} else {
		regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, (int) regT1);
		stage2_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, (int) regT1);
		tmp = cluster_idx;
		cluster_idx = regTFlag - 1;
		regfile_l_write(regT1Type >> 16, LOW16MASK(regT1Type), (int) usrc);
		stage2_l_write(regT1Type >> 16, LOW16MASK(regT1Type), (int) usrc);
		cluster_idx = tmp;
		regTFlag = 0;
	}
}

void SC_pac_ex2::ddex_ls_ex2(inst_t * curinst)
{
	unsigned int usrc1, usrc2;
	int tmp;

	usrc1 = curinst->WB_Data;
	usrc2 = curinst->WB_Data1;
	if (regTFlag == 0) {
		regT1 = usrc1;
		regT1Type = ((curinst->Rd1_Addr << 16) | curinst->Rd1_Type);
		regT2 = usrc2;
		regTFlag = cluster_idx + 1;
	} else {
		regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, (int) regT1);
		regfile_l_write(curinst->Rd1_Addr + 1, curinst->Rd1_Type, (int) regT2);
		stage2_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, (int) regT1);
		stage2_l_write(curinst->Rd1_Addr + 1, curinst->Rd1_Type, (int) regT2);
		tmp = cluster_idx;
		cluster_idx = regTFlag - 1;
		regfile_l_write(regT1Type >> 16, LOW16MASK(regT1Type), (int) usrc1);
		regfile_l_write((regT1Type >> 16) + 1, LOW16MASK(regT1Type), (int) usrc2);
		stage2_l_write(regT1Type >> 16, LOW16MASK(regT1Type), (int) usrc1);
		stage2_l_write((regT1Type >> 16) + 1, LOW16MASK(regT1Type), (int) usrc2);
		cluster_idx = tmp;
		regTFlag = 0;
	}
}

void SC_pac_ex2::mulds_au_ex2(inst_t * curinst)
{
	regfile_write(curinst->Rd1_Addr, curinst->Rd1_Type, curinst->WB_Data);
	stage2_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
				   (unsigned long long) (curinst->WB_Data));
}

void SC_pac_ex2::fmac_au_ex2(inst_t * curinst)
{
	unsigned long long udst;

	udst =
		(((unsigned long long) (curinst->
								WB_Data1)) << 32) | (unsigned long long)
		curinst->WB_Data;
	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
					(unsigned long long) udst);
	stage2_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
				   (unsigned long long) udst);
}

void SC_pac_ex2::fmacd_au_ex2(inst_t * curinst)
{
	unsigned long long udst1, udst2;

	udst1 =
		(unsigned long long) curinst->
		WB_Data | (((unsigned long long) (curinst->Memory_Addr) << 32));
	udst2 =
		(unsigned long long) curinst->
		WB_Data1 | (((unsigned long long) (curinst->WM) << 32))
		| (((unsigned long long) (curinst->WV) << 48));

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst1);
	regfile_l_write(curinst->Rd1_Addr + 1, curinst->Rd1_Type, udst2);
	stage2_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst1);
	stage2_l_write(curinst->Rd1_Addr + 1, curinst->Rd1_Type, udst2);
}

void SC_pac_ex2::fmacuud_au_ex2(inst_t * curinst)
{
	unsigned long long udst1, udst2;

	udst1 =
		(unsigned long long) curinst->
		WB_Data | (((unsigned long long) (curinst->Memory_Addr) << 32));
	udst2 =
		(unsigned long long) curinst->
		WB_Data1 | (((unsigned long long) (curinst->WM) << 32))
		| (((unsigned long long) (curinst->WV) << 48));
	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst1);
	regfile_l_write(curinst->Rd1_Addr + 1, curinst->Rd1_Type, udst2);
	stage2_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst1);
	stage2_l_write(curinst->Rd1_Addr + 1, curinst->Rd1_Type, udst2);
}

void SC_pac_ex2::fmacusd_au_ex2(inst_t * curinst)
{
	unsigned long long udst1, udst2;

	udst1 =
		(unsigned long long) curinst->
		WB_Data | (((unsigned long long) (curinst->Memory_Addr) << 32));
	udst2 =
		(unsigned long long) curinst->
		WB_Data1 | (((unsigned long long) (curinst->WM) << 32))
		| (((unsigned long long) (curinst->WV) << 48));
	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst1);
	regfile_l_write(curinst->Rd1_Addr + 1, curinst->Rd1_Type, udst2);
	stage2_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst1);
	stage2_l_write(curinst->Rd1_Addr + 1, curinst->Rd1_Type, udst2);
}

void SC_pac_ex2::fmacsud_au_ex2(inst_t * curinst)
{
	unsigned long long udst1, udst2;

	udst1 =
		(unsigned long long) curinst->
		WB_Data | (((unsigned long long) (curinst->Memory_Addr) << 32));
	udst2 =
		(unsigned long long) curinst->
		WB_Data1 | (((unsigned long long) (curinst->WM) << 32))
		| (((unsigned long long) (curinst->WV) << 48));
	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst1);
	regfile_l_write(curinst->Rd1_Addr + 1, curinst->Rd1_Type, udst2);
	stage2_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst1);
	stage2_l_write(curinst->Rd1_Addr + 1, curinst->Rd1_Type, udst2);
}

void SC_pac_ex2::fmacuu_au_ex2(inst_t * curinst)
{
	unsigned long long udst;

	udst =
		(((unsigned long long) (curinst->
								WB_Data1)) << 32) | (unsigned long long)
		curinst->WB_Data;
	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
					(unsigned long long) udst);
	stage2_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
				   (unsigned long long) udst);
}

void SC_pac_ex2::fmacsu_au_ex2(inst_t * curinst)
{
	unsigned long long udst;

	udst =
		(((unsigned long long) (curinst->
								WB_Data1)) << 32) | (unsigned long long)
		curinst->WB_Data;
	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
					(unsigned long long) udst);
	stage2_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
				   (unsigned long long) udst);
}

void SC_pac_ex2::fmacus_au_ex2(inst_t * curinst)
{
	unsigned long long udst;

	udst =
		(((unsigned long long) (curinst->
								WB_Data1)) << 32) | (unsigned long long)
		curinst->WB_Data;
	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
					(unsigned long long) udst);
	stage2_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
				   (unsigned long long) udst);
}

void SC_pac_ex2::macd_au_ex2(inst_t * curinst)
{
	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
					(unsigned long long) curinst->WB_Data);
	stage2_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
				   (unsigned long long) curinst->WB_Data);
}

void SC_pac_ex2::macds_au_ex2(inst_t * curinst)
{
	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
					(unsigned long long) curinst->WB_Data);
	stage2_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
				   (unsigned long long) curinst->WB_Data);
}

void SC_pac_ex2::msud_au_ex2(inst_t * curinst)
{
	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
					(unsigned long long) curinst->WB_Data);
	stage2_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
				   (unsigned long long) curinst->WB_Data);
}

void SC_pac_ex2::msuds_au_ex2(inst_t * curinst)
{
	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
					(unsigned long long) curinst->WB_Data);
	stage2_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
				   (unsigned long long) curinst->WB_Data);
}

void SC_pac_ex2::xfmac_au_ex2(inst_t * curinst)
{
	unsigned long long udst;

	udst =
		(((unsigned long long) (curinst->
								WB_Data1)) << 32) | (unsigned long long)
		curinst->WB_Data;
	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst);
	stage2_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst);
}

void SC_pac_ex2::xfmacd_au_ex2(inst_t * curinst)
{
	unsigned long long udst1, udst2;

	udst1 =	(((unsigned long long) (curinst-> WB_Data1)) << 32) | (unsigned long long) curinst->WB_Data;
	udst2 =	(((unsigned long long) (curinst-> Imm32)) << 32) | (unsigned long long) curinst->Memory_Addr;

	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst1);
	regfile_l_write(curinst->Rd1_Addr + 1, curinst->Rd1_Type, udst2);
	stage2_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst1);
	stage2_l_write(curinst->Rd1_Addr + 1, curinst->Rd1_Type, udst2);
}

void SC_pac_ex2::xmacd_au_ex2(inst_t * curinst)
{
	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
					(unsigned long long) curinst->WB_Data);
	stage2_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
				   (unsigned long long) curinst->WB_Data);
}

void SC_pac_ex2::xmacds_au_ex2(inst_t * curinst)
{
	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
					(unsigned long long) curinst->WB_Data);
	stage2_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
				   (unsigned long long) curinst->WB_Data);
}

void SC_pac_ex2::xmsud_au_ex2(inst_t * curinst)
{
	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
					(unsigned long long) curinst->WB_Data);
	stage2_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
				   (unsigned long long) curinst->WB_Data);
}

void SC_pac_ex2::xmsuds_au_ex2(inst_t * curinst)
{
	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
					(unsigned long long) curinst->WB_Data);
	stage2_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
				   (unsigned long long) curinst->WB_Data);
}

void SC_pac_ex2::sfra_au_ex2(inst_t * curinst)
{
	unsigned long long udst;

	udst =
		((unsigned long long) curinst->
		 WB_Data) | ((unsigned long long) curinst->WB_Data1 << 32);
	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst);
	stage2_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst);
}

void SC_pac_ex2::sfrad_au_ex2(inst_t * curinst)
{
	regfile_write(curinst->Rd1_Addr, curinst->Rd1_Type, curinst->WB_Data);
	stage2_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
				   (unsigned long long) (curinst->WB_Data));
}

void SC_pac_ex2::dotp2_au_ex2(inst_t * curinst)
{
	unsigned long long udst;

	udst =
		(((unsigned long long) (curinst->
								WB_Data1)) << 32) | (unsigned long long)
		curinst->WB_Data;
	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
					(unsigned long long) udst);
	stage2_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
				   (unsigned long long) udst);
}

void SC_pac_ex2::xdotp2_au_ex2(inst_t * curinst)
{
	unsigned long long udst;

	udst =
		(((unsigned long long) (curinst->
								WB_Data1)) << 32) | (unsigned long long) curinst->WB_Data;
	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, (unsigned long long) udst);
	stage2_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, (unsigned long long) udst);
}

void SC_pac_ex2::saaq_au_ex2(inst_t * curinst)
{
	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
					(unsigned long long) curinst->WB_Data);
	regfile_l_write(curinst->Rd1_Addr + 1, curinst->Rd1_Type,
					(unsigned long long) curinst->WB_Data1);
	stage2_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
				   (unsigned long long) curinst->WB_Data);
	stage2_l_write(curinst->Rd1_Addr + 1, curinst->Rd1_Type,
				   (unsigned long long) curinst->WB_Data1);
}

void SC_pac_ex2::b_sc_ex2(inst_t * curinst)
{
	unsigned int usrc1;

	if (curinst->Rd1_Addr != (unsigned char) INVALID_REG) {
		curinst->WB_Data = get_fetch_pc();
	}
	if (branch_Reg_P) {
		usrc1 = curinst->Imm32 + exec_table[EX2_IDX].PC;
		set_fetch_pc(usrc1);
		save_branch_target(usrc1);
		branch_occur = 1;
	}
}

void SC_pac_ex2::br_sc_ex2(inst_t * curinst)
{
	unsigned int usrc1;

	if (curinst->Rd1_Addr != (unsigned char) INVALID_REG) {
		curinst->WB_Data = get_fetch_pc();
	}
	if (branch_Reg_P) {
		usrc1 = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
		set_fetch_pc(usrc1);
		save_branch_target(usrc1);
		branch_occur = 1;
	}
}

void SC_pac_ex2::brr_sc_ex2(inst_t * curinst)
{
	unsigned int usrc1;

	if (curinst->Rd1_Addr != (unsigned char) INVALID_REG) {
		curinst->WB_Data = get_fetch_pc();
	}
	if (branch_Reg_P) {
		usrc1 = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
		usrc1 = usrc1 + curinst->Imm32;
		set_fetch_pc(usrc1);
		save_branch_target(usrc1);
		branch_occur = 1;
	}
}

void SC_pac_ex2::lbcb_sc_ex2(inst_t * curinst)
{
	unsigned int udst1, usrc1, usrc2;

	if (curinst->Rd1_Addr != (unsigned char) INVALID_REG) {
		curinst->WB_Data = get_fetch_pc();
	}
	usrc1 = regfile_read(curinst->Rs1_Addr, curinst->Rs1_Type);
	curinst->WB_Data1 = usrc1;

	if (usrc1 > 1) {
		usrc2 = curinst->Imm32 + exec_table[EX2_IDX].PC;
		set_fetch_pc(usrc2);
		save_branch_target(usrc2);
		branch_occur = 1;
		udst1 = usrc1 - 1;
	} else
		udst1 = 0;
	regfile_write(curinst->Rs1_Addr, curinst->Rs1_Type, udst1);
	stage2_l_write(curinst->Rs1_Addr, curinst->Rs1_Type, udst1);
}

void SC_pac_ex2::adsr_au_ex2(inst_t * curinst)
{
	unsigned long long udst;

	udst = curinst->WB_Data | ((unsigned long long) curinst->WB_Data1 << 32);
	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst);
	stage2_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst);
}

void SC_pac_ex2::adsru_au_ex2(inst_t * curinst)
{
	unsigned long long udst;

	udst = curinst->WB_Data | ((unsigned long long) curinst->WB_Data1 << 32);
	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst);
	stage2_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst);
}

void SC_pac_ex2::adsrd_au_ex2(inst_t * curinst)
{
	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
					(unsigned long long) (curinst->WB_Data));
	stage2_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
				   (unsigned long long) (curinst->WB_Data));
}

void SC_pac_ex2::adsrud_au_ex2(inst_t * curinst)
{
	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
					(unsigned long long) (curinst->WB_Data));
	stage2_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
				   (unsigned long long) (curinst->WB_Data));
}

void SC_pac_ex2::adsrf_au_ex2(inst_t * curinst)
{
	unsigned long long udst;

	udst = curinst->WB_Data | ((unsigned long long) curinst->WB_Data1 << 32);
	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst);
	stage2_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst);
}

void SC_pac_ex2::adsrfu_au_ex2(inst_t * curinst)
{
	unsigned long long udst;

	udst = curinst->WB_Data | ((unsigned long long) curinst->WB_Data1 << 32);
	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst);
	stage2_l_write(curinst->Rd1_Addr, curinst->Rd1_Type, udst);
}

void SC_pac_ex2::adsrfd_au_ex2(inst_t * curinst)
{
	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
					(unsigned long long) (curinst->WB_Data));
	stage2_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
				   (unsigned long long) (curinst->WB_Data));
}

void SC_pac_ex2::adsrfud_au_ex2(inst_t * curinst)
{
	regfile_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
					(unsigned long long) (curinst->WB_Data));
	stage2_l_write(curinst->Rd1_Addr, curinst->Rd1_Type,
				   (unsigned long long) (curinst->WB_Data));
}

void SC_pac_ex2::invalid_inst(inst_t * curinst)
{
	fprintf(stderr, "Invalid instrution, opcode : %d\n", curinst->op);
}

void SC_pac_ex2::nop_inst(inst_t * curinst)
{
	return;
}

void SC_pac_ex2::stage2_l_write(unsigned char num, unsigned char type, unsigned long long data)
{
	dsp_core->stage2_l_write(num, type, data);
}

void SC_pac_ex2::regfile_write(unsigned char num, unsigned char type, unsigned int data)
{
	dsp_core->regfile_write(num, type, data);
}

void SC_pac_ex2::regfile_l_write(unsigned char num, unsigned char type, unsigned long long data)
{
	dsp_core->regfile_l_write(num, type, data);
}


void SC_pac_ex2::save_branch_target(unsigned int pc)
{
	dsp_core->save_branch_target(pc);
}

unsigned int SC_pac_ex2::get_fetch_pc()
{
	return dsp_core->get_fetch_pc();
}

void SC_pac_ex2::set_fetch_pc(unsigned int pc)
{
	return dsp_core->set_fetch_pc(pc);
}

unsigned int SC_pac_ex2::regfile_read(unsigned char num, unsigned char type)
{
	return dsp_core->regfile_read(num, type);
}

void SC_pac_ex2::sc_pac_ex2_run()
{
//	int i = ex2_id;
    int step = 0;
	int cur_op;
	struct soc_shm_prot *base_ptr = soc_shm_base_ptr + ex2_id;

	while(1) {
		wait();
		//printf("%s wakeup\r\n", __func__);
		if(ex2_pin.event())
		    step = 1;

		if(ex2_id == 0) {
//			wait();
			if (step == 1) {
				memif_req_count = 4;
			} else {
				memif_req_count++;
			}
			base_ptr->inst_mode = INST_SC;
			if (exec_table[EX2_IDX].instr[0].execute
				&& (exec_table[EX2_IDX].instr[0].inst.op != NOP)) {
				cluster_idx = 0;
				cur_op = exec_table[EX2_IDX].instr[0].inst.op;
				(this->*sc_funcs_e2_t[cur_op])(&(exec_table[EX2_IDX].instr[0].inst));
			}
		} else if (ex2_id == 1) {
//			wait();
			if (step == 1) {
				memif_req_count = 4;
			} else {
				memif_req_count++;
			}
			base_ptr->inst_mode = INST_C1;
			if (exec_table[EX2_IDX].instr[1].execute
				&& (exec_table[EX2_IDX].instr[1].inst.op != NOP)) {
				cluster_idx = 1;
				cur_op = exec_table[EX2_IDX].instr[1].inst.op;
				(this->*ls_funcs_e2_t[cur_op])(&(exec_table[EX2_IDX].instr[1].inst));
			}

			if (exec_table[EX2_IDX].instr[2].execute
				&& (exec_table[EX2_IDX].instr[2].inst.op != NOP)) {
				cluster_idx = 2;
				cur_op = exec_table[EX2_IDX].instr[2].inst.op;
				(this->*au_funcs_e2_t[cur_op])(&(exec_table[EX2_IDX].instr[2].inst));
			}
		} else if (ex2_id == 2) {
//			wait();
			if (step == 1) {
				memif_req_count = 4;
			} else {
				memif_req_count++;
			}

			base_ptr->inst_mode = INST_C2;
			if (exec_table[EX2_IDX].instr[3].execute
				&& (exec_table[EX2_IDX].instr[3].inst.op != NOP)) {
				cluster_idx = 3;
				cur_op = exec_table[EX2_IDX].instr[3].inst.op;
				(this->*ls_funcs_e2_t[cur_op])(&(exec_table[EX2_IDX].instr[3].inst));
			}

			if (exec_table[EX2_IDX].instr[4].execute
				&& (exec_table[EX2_IDX].instr[4].inst.op != NOP)) {
				cluster_idx = 4;
				cur_op = exec_table[EX2_IDX].instr[4].inst.op;
				(this->*au_funcs_e2_t[cur_op])(&(exec_table[EX2_IDX].instr[4].inst));
			}
		}
		
		if(step) {
		    ex2_step_count++;
		    if(ex2_step_count == 3)
				ex2_resp_event.notify();

		    step = 0;
		} else {    
		    mod_count++;
	            //printf("ex2 mod count %d\r\n", mod_count);
		    if(mod_count == 5)
			mod_resp_event.notify();
		}
	}
}

void SC_pac_ex2::ex2_init_funcs_table()
{
	ls_funcs_e2_t[0] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[1] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[2] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[3] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[4] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[5] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[6] = &SC_pac_ex2::addds_ls_ex2;
	ls_funcs_e2_t[7] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[8] = &SC_pac_ex2::addqs_ls_ex2;
	ls_funcs_e2_t[9] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[10] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[11] = &SC_pac_ex2::addids_ls_ex2;
	ls_funcs_e2_t[12] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[13] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[14] = &SC_pac_ex2::adduds_ls_ex2;
	ls_funcs_e2_t[15] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[16] = &SC_pac_ex2::adduqs_ls_ex2;
	ls_funcs_e2_t[17] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[18] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[19] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[20] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[21] = &SC_pac_ex2::subds_ls_ex2;
	ls_funcs_e2_t[22] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[23] = &SC_pac_ex2::subqs_ls_ex2;
	ls_funcs_e2_t[24] = &SC_pac_ex2::nop_inst;
		//25
	ls_funcs_e2_t[25] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[26] = &SC_pac_ex2::subuds_ls_ex2;
	ls_funcs_e2_t[27] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[28] = &SC_pac_ex2::subuqs_ls_ex2;
	ls_funcs_e2_t[29] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[30] = &SC_pac_ex2::addiuds_ls_ex2;
	ls_funcs_e2_t[31] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[32] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[33] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[34] = &SC_pac_ex2::adds_ls_ex2;
	ls_funcs_e2_t[35] = &SC_pac_ex2::subs_ls_ex2;
	ls_funcs_e2_t[36] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[37] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[38] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[39] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[40] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[41] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[42] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[43] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[44] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[45] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[46] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[47] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[48] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[49] = &SC_pac_ex2::nop_inst;
		//50
	ls_funcs_e2_t[50] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[51] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[52] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[53] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[54] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[55] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[56] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[57] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[58] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[59] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[60] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[61] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[62] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[63] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[64] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[65] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[66] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[67] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[68] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[69] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[70] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[71] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[72] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[73] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[74] = &SC_pac_ex2::nop_inst;
		//75
	ls_funcs_e2_t[75] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[76] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[77] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[78] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[79] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[80] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[81] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[82] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[83] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[84] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[85] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[86] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[87] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[88] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[89] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[90] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[91] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[92] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[93] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[94] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[95] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[96] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[97] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[98] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[99] = &SC_pac_ex2::nop_inst;
		//100
	ls_funcs_e2_t[100] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[101] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[102] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[103] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[104] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[105] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[106] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[107] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[108] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[109] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[110] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[111] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[112] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[113] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[114] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[115] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[116] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[117] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[118] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[119] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[120] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[121] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[122] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[123] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[124] = &SC_pac_ex2::nop_inst;
		//125
	ls_funcs_e2_t[125] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[126] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[127] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[128] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[129] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[130] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[131] = &SC_pac_ex2::dlh_ls_ex2;
	ls_funcs_e2_t[132] = &SC_pac_ex2::dlhu_ls_ex2;
	ls_funcs_e2_t[133] = &SC_pac_ex2::dlw_ls_ex2;
	ls_funcs_e2_t[134] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[135] = &SC_pac_ex2::dsw_ls_ex2;
	ls_funcs_e2_t[136] = &SC_pac_ex2::lb_ls_ex2;
	ls_funcs_e2_t[137] = &SC_pac_ex2::lbu_ls_ex2;
	ls_funcs_e2_t[138] = &SC_pac_ex2::lh_ls_ex2;
	ls_funcs_e2_t[139] = &SC_pac_ex2::lhu_ls_ex2;
	ls_funcs_e2_t[140] = &SC_pac_ex2::lw_ls_ex2;
	ls_funcs_e2_t[141] = &SC_pac_ex2::lw_ls_ex2;
	ls_funcs_e2_t[142] = &SC_pac_ex2::sb_ls_ex2;
	ls_funcs_e2_t[143] = &SC_pac_ex2::sw_ls_ex2;
	ls_funcs_e2_t[144] = &SC_pac_ex2::lwu_ls_ex2;
	ls_funcs_e2_t[145] = &SC_pac_ex2::dlwu_ls_ex2;
	ls_funcs_e2_t[146] = &SC_pac_ex2::lwu_ls_ex2;
	ls_funcs_e2_t[147] = &SC_pac_ex2::dlw_ls_ex2;
	ls_funcs_e2_t[148] = &SC_pac_ex2::dlwu_ls_ex2;
	ls_funcs_e2_t[149] = &SC_pac_ex2::sw_ls_ex2;
		//150
	ls_funcs_e2_t[150] = &SC_pac_ex2::dsw_ls_ex2;
	ls_funcs_e2_t[151] = &SC_pac_ex2::sh_ls_ex2;
	ls_funcs_e2_t[152] = &SC_pac_ex2::invalid_inst;
	ls_funcs_e2_t[153] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[154] = &SC_pac_ex2::invalid_inst;
	ls_funcs_e2_t[155] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[156] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[157] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[158] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[159] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[160] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[161] = &SC_pac_ex2::bdr_ls_ex2;
	ls_funcs_e2_t[162] = &SC_pac_ex2::bdt_ls_ex2;
	ls_funcs_e2_t[163] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[164] = &SC_pac_ex2::dbdr_ls_ex2;
	ls_funcs_e2_t[165] = &SC_pac_ex2::dbdt_ls_ex2;
	ls_funcs_e2_t[166] = &SC_pac_ex2::ddex_ls_ex2;
	ls_funcs_e2_t[167] = &SC_pac_ex2::dex_ls_ex2;
	ls_funcs_e2_t[168] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[169] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[170] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[171] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[172] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[173] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[174] = &SC_pac_ex2::nop_inst;
		//175
	ls_funcs_e2_t[175] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[176] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[177] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[178] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[179] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[180] = &SC_pac_ex2::dex_ls_ex2;
	ls_funcs_e2_t[181] = &SC_pac_ex2::bdt_ls_ex2;
	ls_funcs_e2_t[182] = &SC_pac_ex2::adsr_au_ex2;
	ls_funcs_e2_t[183] = &SC_pac_ex2::adsrd_au_ex2;
	ls_funcs_e2_t[184] = &SC_pac_ex2::adsru_au_ex2;
	ls_funcs_e2_t[185] = &SC_pac_ex2::adsrud_au_ex2;
	ls_funcs_e2_t[186] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[187] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[188] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[189] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[190] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[191] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[192] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[193] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[194] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[195] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[196] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[197] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[198] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[199] = &SC_pac_ex2::nop_inst;
		//200
	ls_funcs_e2_t[200] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[201] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[202] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[203] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[204] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[205] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[206] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[207] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[208] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[209] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[210] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[211] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[212] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[213] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[214] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[215] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[216] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[217] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[218] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[219] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[220] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[221] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[222] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[223] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[224] = &SC_pac_ex2::nop_inst;
		//225
	ls_funcs_e2_t[225] = &SC_pac_ex2::adsrf_au_ex2;
	ls_funcs_e2_t[226] = &SC_pac_ex2::adsrfu_au_ex2;
	ls_funcs_e2_t[227] = &SC_pac_ex2::adsrfd_au_ex2;
	ls_funcs_e2_t[228] = &SC_pac_ex2::adsrfud_au_ex2;
	ls_funcs_e2_t[229] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[230] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[231] = &SC_pac_ex2::subus_ls_ex2;
	ls_funcs_e2_t[232] = &SC_pac_ex2::addcus_ls_ex2;
	ls_funcs_e2_t[233] = &SC_pac_ex2::addus_ls_ex2;
	ls_funcs_e2_t[234] = &SC_pac_ex2::addcs_ls_ex2;
	ls_funcs_e2_t[235] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[236] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[237] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[238] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[239] = &SC_pac_ex2::addis_ls_ex2;
	ls_funcs_e2_t[240] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[241] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[242] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[243] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[244] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[245] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[246] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[247] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[248] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[249] = &SC_pac_ex2::nop_inst;
		//250
	ls_funcs_e2_t[250] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[251] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[252] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[253] = &SC_pac_ex2::nop_inst;
	ls_funcs_e2_t[254] = &SC_pac_ex2::nop_inst;
		//255
	ls_funcs_e2_t[255] = &SC_pac_ex2::nop_inst;

// init au_funcs_e2_t
	au_funcs_e2_t[0] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[1] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[2] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[3] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[4] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[5] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[6] = &SC_pac_ex2::addds_ls_ex2;
	au_funcs_e2_t[7] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[8] = &SC_pac_ex2::addqs_ls_ex2;
	au_funcs_e2_t[9] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[10] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[11] = &SC_pac_ex2::addids_ls_ex2;
	au_funcs_e2_t[12] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[13] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[14] = &SC_pac_ex2::adduds_ls_ex2;
	au_funcs_e2_t[15] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[16] = &SC_pac_ex2::adduqs_ls_ex2;
	au_funcs_e2_t[17] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[18] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[19] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[20] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[21] = &SC_pac_ex2::subds_ls_ex2;
	au_funcs_e2_t[22] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[23] = &SC_pac_ex2::subqs_ls_ex2;
	au_funcs_e2_t[24] = &SC_pac_ex2::nop_inst;
	//25
	au_funcs_e2_t[25] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[26] = &SC_pac_ex2::subuds_ls_ex2;
	au_funcs_e2_t[27] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[28] = &SC_pac_ex2::subuqs_ls_ex2;
	au_funcs_e2_t[29] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[30] = &SC_pac_ex2::addiuds_ls_ex2;
	au_funcs_e2_t[31] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[32] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[33] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[34] = &SC_pac_ex2::adds_ls_ex2;
	au_funcs_e2_t[35] = &SC_pac_ex2::subs_ls_ex2;
	au_funcs_e2_t[36] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[37] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[38] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[39] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[40] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[41] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[42] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[43] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[44] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[45] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[46] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[47] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[48] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[49] = &SC_pac_ex2::nop_inst;
	//50
	au_funcs_e2_t[50] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[51] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[52] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[53] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[54] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[55] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[56] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[57] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[58] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[59] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[60] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[61] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[62] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[63] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[64] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[65] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[66] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[67] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[68] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[69] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[70] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[71] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[72] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[73] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[74] = &SC_pac_ex2::nop_inst;
	//75
	au_funcs_e2_t[75] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[76] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[77] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[78] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[79] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[80] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[81] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[82] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[83] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[84] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[85] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[86] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[87] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[88] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[89] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[90] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[91] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[92] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[93] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[94] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[95] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[96] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[97] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[98] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[99] = &SC_pac_ex2::nop_inst;
	//100
	au_funcs_e2_t[100] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[101] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[102] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[103] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[104] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[105] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[106] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[107] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[108] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[109] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[110] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[111] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[112] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[113] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[114] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[115] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[116] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[117] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[118] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[119] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[120] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[121] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[122] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[123] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[124] = &SC_pac_ex2::nop_inst;
	//125
	au_funcs_e2_t[125] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[126] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[127] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[128] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[129] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[130] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[131] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[132] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[133] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[134] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[135] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[136] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[137] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[138] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[139] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[140] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[141] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[142] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[143] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[144] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[145] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[146] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[147] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[148] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[149] = &SC_pac_ex2::nop_inst;
	//150
	au_funcs_e2_t[150] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[151] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[152] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[153] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[154] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[155] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[156] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[157] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[158] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[159] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[160] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[161] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[162] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[163] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[164] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[165] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[166] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[167] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[168] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[169] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[170] = &SC_pac_ex2::sfra_au_ex2;
	au_funcs_e2_t[171] = &SC_pac_ex2::sfrad_au_ex2;
	au_funcs_e2_t[172] = &SC_pac_ex2::saaq_au_ex2;
	au_funcs_e2_t[173] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[174] = &SC_pac_ex2::nop_inst;
	//175
	au_funcs_e2_t[175] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[176] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[177] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[178] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[179] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[180] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[181] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[182] = &SC_pac_ex2::adsr_au_ex2;
	au_funcs_e2_t[183] = &SC_pac_ex2::adsrd_au_ex2;
	au_funcs_e2_t[184] = &SC_pac_ex2::adsru_au_ex2;
	au_funcs_e2_t[185] = &SC_pac_ex2::adsrud_au_ex2;
	au_funcs_e2_t[186] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[187] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[188] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[189] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[190] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[191] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[192] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[193] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[194] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[195] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[196] = &SC_pac_ex2::fmac_au_ex2;
	au_funcs_e2_t[197] = &SC_pac_ex2::fmacuu_au_ex2;
	au_funcs_e2_t[198] = &SC_pac_ex2::fmacus_au_ex2;
	au_funcs_e2_t[199] = &SC_pac_ex2::fmacsu_au_ex2;
	//200
	au_funcs_e2_t[200] = &SC_pac_ex2::fmacd_au_ex2;
	au_funcs_e2_t[201] = &SC_pac_ex2::fmacuud_au_ex2;
	au_funcs_e2_t[202] = &SC_pac_ex2::fmacusd_au_ex2;
	au_funcs_e2_t[203] = &SC_pac_ex2::fmacsud_au_ex2;
	au_funcs_e2_t[204] = &SC_pac_ex2::macd_au_ex2;
	au_funcs_e2_t[205] = &SC_pac_ex2::xmacd_au_ex2;
	au_funcs_e2_t[206] = &SC_pac_ex2::xmacds_au_ex2;
	au_funcs_e2_t[207] = &SC_pac_ex2::dotp2_au_ex2;
	au_funcs_e2_t[208] = &SC_pac_ex2::mulds_au_ex2;
	au_funcs_e2_t[209] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[210] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[211] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[212] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[213] = &SC_pac_ex2::macds_au_ex2;
	au_funcs_e2_t[214] = &SC_pac_ex2::msud_au_ex2;
	au_funcs_e2_t[215] = &SC_pac_ex2::msuds_au_ex2;
	au_funcs_e2_t[216] = &SC_pac_ex2::xfmac_au_ex2;
	au_funcs_e2_t[217] = &SC_pac_ex2::xfmacd_au_ex2;
	au_funcs_e2_t[218] = &SC_pac_ex2::xmsud_au_ex2;
	au_funcs_e2_t[219] = &SC_pac_ex2::xmsuds_au_ex2;
	au_funcs_e2_t[220] = &SC_pac_ex2::xdotp2_au_ex2;
	au_funcs_e2_t[221] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[222] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[223] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[224] = &SC_pac_ex2::nop_inst;
	//225
	au_funcs_e2_t[225] = &SC_pac_ex2::adsrf_au_ex2;
	au_funcs_e2_t[226] = &SC_pac_ex2::adsrfu_au_ex2;
	au_funcs_e2_t[227] = &SC_pac_ex2::adsrfd_au_ex2;
	au_funcs_e2_t[228] = &SC_pac_ex2::adsrfud_au_ex2;
	au_funcs_e2_t[229] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[230] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[231] = &SC_pac_ex2::subus_ls_ex2;
	au_funcs_e2_t[232] = &SC_pac_ex2::addcus_ls_ex2;
	au_funcs_e2_t[233] = &SC_pac_ex2::addus_ls_ex2;
	au_funcs_e2_t[234] = &SC_pac_ex2::addcs_ls_ex2;
	au_funcs_e2_t[235] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[236] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[237] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[238] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[239] = &SC_pac_ex2::addis_ls_ex2;
	au_funcs_e2_t[240] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[241] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[242] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[243] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[244] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[245] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[246] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[247] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[248] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[249] = &SC_pac_ex2::nop_inst;
	//250
	au_funcs_e2_t[250] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[251] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[252] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[253] = &SC_pac_ex2::nop_inst;
	au_funcs_e2_t[254] = &SC_pac_ex2::nop_inst;
	//255
	au_funcs_e2_t[255] = &SC_pac_ex2::nop_inst;

// init sc_funcs_e2_t
	sc_funcs_e2_t[0] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[1] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[2] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[3] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[4] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[5] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[6] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[7] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[8] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[9] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[10] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[11] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[12] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[13] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[14] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[15] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[16] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[17] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[18] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[19] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[20] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[21] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[22] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[23] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[24] = &SC_pac_ex2::nop_inst;
	//25
	sc_funcs_e2_t[25] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[26] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[27] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[28] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[29] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[30] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[31] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[32] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[33] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[34] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[35] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[36] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[37] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[38] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[39] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[40] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[41] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[42] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[43] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[44] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[45] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[46] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[47] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[48] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[49] = &SC_pac_ex2::nop_inst;
	//50
	sc_funcs_e2_t[50] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[51] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[52] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[53] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[54] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[55] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[56] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[57] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[58] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[59] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[60] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[61] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[62] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[63] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[64] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[65] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[66] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[67] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[68] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[69] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[70] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[71] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[72] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[73] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[74] = &SC_pac_ex2::nop_inst;
	//75
	sc_funcs_e2_t[75] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[76] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[77] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[78] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[79] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[80] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[81] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[82] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[83] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[84] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[85] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[86] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[87] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[88] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[89] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[90] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[91] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[92] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[93] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[94] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[95] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[96] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[97] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[98] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[99] = &SC_pac_ex2::nop_inst;
	//100
	sc_funcs_e2_t[100] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[101] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[102] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[103] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[104] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[105] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[106] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[107] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[108] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[109] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[110] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[111] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[112] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[113] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[114] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[115] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[116] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[117] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[118] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[119] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[120] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[121] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[122] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[123] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[124] = &SC_pac_ex2::nop_inst;
	//125
	sc_funcs_e2_t[125] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[126] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[127] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[128] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[129] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[130] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[131] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[132] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[133] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[134] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[135] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[136] = &SC_pac_ex2::lb_ls_ex2;
	sc_funcs_e2_t[137] = &SC_pac_ex2::lbu_ls_ex2;
	sc_funcs_e2_t[138] = &SC_pac_ex2::lh_ls_ex2;
	sc_funcs_e2_t[139] = &SC_pac_ex2::lhu_ls_ex2;
	sc_funcs_e2_t[140] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[141] = &SC_pac_ex2::lw_ls_ex2;
	sc_funcs_e2_t[142] = &SC_pac_ex2::sb_ls_ex2;
	sc_funcs_e2_t[143] = &SC_pac_ex2::sw_ls_ex2;
	sc_funcs_e2_t[144] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[145] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[146] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[147] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[148] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[149] = &SC_pac_ex2::nop_inst;
	//150
	sc_funcs_e2_t[150] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[151] = &SC_pac_ex2::sh_ls_ex2;
	sc_funcs_e2_t[152] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[153] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[154] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[155] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[156] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[157] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[158] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[159] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[160] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[161] = &SC_pac_ex2::bdr_ls_ex2;
	sc_funcs_e2_t[162] = &SC_pac_ex2::bdt_ls_ex2;
	sc_funcs_e2_t[163] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[164] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[165] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[166] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[167] = &SC_pac_ex2::dex_ls_ex2;
	sc_funcs_e2_t[168] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[169] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[170] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[171] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[172] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[173] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[174] = &SC_pac_ex2::nop_inst;
	//175
	sc_funcs_e2_t[175] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[176] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[177] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[178] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[179] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[180] = &SC_pac_ex2::dex_ls_ex2;
	sc_funcs_e2_t[181] = &SC_pac_ex2::bdt_ls_ex2;
	sc_funcs_e2_t[182] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[183] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[184] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[185] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[186] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[187] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[188] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[189] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[190] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[191] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[192] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[193] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[194] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[195] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[196] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[197] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[198] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[199] = &SC_pac_ex2::nop_inst;
	//200
	sc_funcs_e2_t[200] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[201] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[202] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[203] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[204] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[205] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[206] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[207] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[208] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[209] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[210] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[211] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[212] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[213] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[214] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[215] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[216] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[217] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[218] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[219] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[220] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[221] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[222] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[223] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[224] = &SC_pac_ex2::nop_inst;
	//225
	sc_funcs_e2_t[225] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[226] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[227] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[228] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[229] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[230] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[231] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[232] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[233] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[234] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[235] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[236] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[237] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[238] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[239] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[240] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[241] = &SC_pac_ex2::lbcb_sc_ex2;
	sc_funcs_e2_t[242] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[243] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[244] = &SC_pac_ex2::b_sc_ex2;
	sc_funcs_e2_t[245] = &SC_pac_ex2::br_sc_ex2;
	sc_funcs_e2_t[246] = &SC_pac_ex2::brr_sc_ex2;
	sc_funcs_e2_t[247] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[248] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[249] = &SC_pac_ex2::nop_inst;
	//250
	sc_funcs_e2_t[250] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[251] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[252] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[253] = &SC_pac_ex2::nop_inst;
	sc_funcs_e2_t[254] = &SC_pac_ex2::nop_inst;
	//255
	sc_funcs_e2_t[255] = &SC_pac_ex2::nop_inst;
}

#if 0
static pac_funcs ls_funcs_e2_t[256] = {
	SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::addds_ls_ex2, SC_pac_ex2::nop_inst, SC_pac_ex2::addqs_ls_ex2,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::addids_ls_ex2,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::adduds_ls_ex2,
		SC_pac_ex2::nop_inst, SC_pac_ex2::adduqs_ls_ex2, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::subds_ls_ex2, SC_pac_ex2::nop_inst, SC_pac_ex2::subqs_ls_ex2,
		SC_pac_ex2::nop_inst,
		//25
		SC_pac_ex2::nop_inst, SC_pac_ex2::subuds_ls_ex2, SC_pac_ex2::nop_inst,
		SC_pac_ex2::subuqs_ls_ex2, SC_pac_ex2::nop_inst,
		SC_pac_ex2::addiuds_ls_ex2, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::adds_ls_ex2, SC_pac_ex2::subs_ls_ex2,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		//50
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst,
		//75
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst,
		//100
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst,
		//125
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::dlh_ls_ex2, SC_pac_ex2::dlhu_ls_ex2, SC_pac_ex2::dlw_ls_ex2,
		SC_pac_ex2::nop_inst, SC_pac_ex2::dsw_ls_ex2, SC_pac_ex2::lb_ls_ex2,
		SC_pac_ex2::lbu_ls_ex2, SC_pac_ex2::lh_ls_ex2, SC_pac_ex2::lhu_ls_ex2,
		SC_pac_ex2::lw_ls_ex2, SC_pac_ex2::lw_ls_ex2, SC_pac_ex2::sb_ls_ex2,
		SC_pac_ex2::sw_ls_ex2, SC_pac_ex2::lwu_ls_ex2, SC_pac_ex2::dlwu_ls_ex2,
		SC_pac_ex2::lwu_ls_ex2, SC_pac_ex2::dlw_ls_ex2, SC_pac_ex2::dlwu_ls_ex2,
		SC_pac_ex2::sw_ls_ex2,
		//150
		SC_pac_ex2::dsw_ls_ex2, SC_pac_ex2::sh_ls_ex2, SC_pac_ex2::invalid_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::invalid_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::bdr_ls_ex2,
		SC_pac_ex2::bdt_ls_ex2, SC_pac_ex2::nop_inst, SC_pac_ex2::dbdr_ls_ex2,
		SC_pac_ex2::dbdt_ls_ex2, SC_pac_ex2::ddex_ls_ex2, SC_pac_ex2::dex_ls_ex2,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst,
		//175
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::dex_ls_ex2, SC_pac_ex2::bdt_ls_ex2, SC_pac_ex2::adsr_au_ex2, SC_pac_ex2::adsrd_au_ex2, SC_pac_ex2::adsru_au_ex2,	/*nop_inst, nop_inst, nop_inst, *//* v3.6 2010.1.22 */
		SC_pac_ex2::adsrud_au_ex2, /* nop_inst, v3.6 */ SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst,
		//200
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst,
		//225
		//nop_inst, nop_inst, nop_inst, nop_inst, nop_inst, 
		SC_pac_ex2::adsrf_au_ex2, SC_pac_ex2::adsrfu_au_ex2, SC_pac_ex2::adsrfd_au_ex2, SC_pac_ex2::adsrfud_au_ex2, SC_pac_ex2::nop_inst,	/* v3.6 2009.12.1 */
		SC_pac_ex2::nop_inst, SC_pac_ex2::subus_ls_ex2,
		SC_pac_ex2::addcus_ls_ex2, SC_pac_ex2::addus_ls_ex2,
		SC_pac_ex2::addcs_ls_ex2, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::addis_ls_ex2,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst,
		//250
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		//255
SC_pac_ex2::nop_inst,};

static pac_funcs au_funcs_e2_t[256] = {
	SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::addds_ls_ex2, SC_pac_ex2::nop_inst, SC_pac_ex2::addqs_ls_ex2,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::addids_ls_ex2,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::adduds_ls_ex2,
		SC_pac_ex2::nop_inst, SC_pac_ex2::adduqs_ls_ex2, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::subds_ls_ex2, SC_pac_ex2::nop_inst, SC_pac_ex2::subqs_ls_ex2,
		SC_pac_ex2::nop_inst,
		//25
		SC_pac_ex2::nop_inst, SC_pac_ex2::subuds_ls_ex2, SC_pac_ex2::nop_inst,
		SC_pac_ex2::subuqs_ls_ex2, SC_pac_ex2::nop_inst,
		SC_pac_ex2::addiuds_ls_ex2, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::adds_ls_ex2, SC_pac_ex2::subs_ls_ex2,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		//50
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst,
		//75
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst,
		//100
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst,
		//125
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst,
		//150
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::sfra_au_ex2,
		SC_pac_ex2::sfrad_au_ex2, SC_pac_ex2::saaq_au_ex2, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst,
		//175
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::adsr_au_ex2, SC_pac_ex2::adsrd_au_ex2, SC_pac_ex2::adsru_au_ex2,	/*nop_inst, nop_inst, nop_inst, *//* v3.6 */
		SC_pac_ex2::adsrud_au_ex2, /* nop_inst, v3.6 */ SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::fmac_au_ex2, SC_pac_ex2::fmacuu_au_ex2,
		SC_pac_ex2::fmacus_au_ex2, SC_pac_ex2::fmacsu_au_ex2,
		//200
		SC_pac_ex2::fmacd_au_ex2, SC_pac_ex2::fmacuud_au_ex2,
		SC_pac_ex2::fmacusd_au_ex2, SC_pac_ex2::fmacsud_au_ex2,
		SC_pac_ex2::macd_au_ex2, SC_pac_ex2::xmacd_au_ex2,
		SC_pac_ex2::xmacds_au_ex2, SC_pac_ex2::dotp2_au_ex2,
		SC_pac_ex2::mulds_au_ex2, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::macds_au_ex2,
		SC_pac_ex2::msud_au_ex2, SC_pac_ex2::msuds_au_ex2,
		SC_pac_ex2::xfmac_au_ex2, SC_pac_ex2::xfmacd_au_ex2,
		SC_pac_ex2::xmsud_au_ex2, SC_pac_ex2::xmsuds_au_ex2,
		SC_pac_ex2::xdotp2_au_ex2, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		//225
		//nop_inst, nop_inst, nop_inst, nop_inst, nop_inst,
		SC_pac_ex2::adsrf_au_ex2, SC_pac_ex2::adsrfu_au_ex2, SC_pac_ex2::adsrfd_au_ex2, SC_pac_ex2::adsrfud_au_ex2, SC_pac_ex2::nop_inst,	/*v3.6 2009.12.1 */
		SC_pac_ex2::nop_inst, SC_pac_ex2::subus_ls_ex2,
		SC_pac_ex2::addcus_ls_ex2, SC_pac_ex2::addus_ls_ex2,
		SC_pac_ex2::addcs_ls_ex2, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::addis_ls_ex2,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst,
		//250
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		//255
SC_pac_ex2::nop_inst,};

static pac_funcs sc_funcs_e2_t[256] = {
	SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst,
		//25
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst,
		//50
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst,
		//75
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst,
		//100
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst,
		//125
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::lb_ls_ex2,
		SC_pac_ex2::lbu_ls_ex2, SC_pac_ex2::lh_ls_ex2, SC_pac_ex2::lhu_ls_ex2,
		SC_pac_ex2::nop_inst, SC_pac_ex2::lw_ls_ex2, SC_pac_ex2::sb_ls_ex2,
		SC_pac_ex2::sw_ls_ex2, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst,
		//150
		SC_pac_ex2::nop_inst, SC_pac_ex2::sh_ls_ex2, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::bdr_ls_ex2,
		SC_pac_ex2::bdt_ls_ex2, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::dex_ls_ex2,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst,
		//175
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::dex_ls_ex2,
		SC_pac_ex2::bdt_ls_ex2, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst,
		//200
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst,
		//225
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::lbcb_sc_ex2, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::b_sc_ex2, SC_pac_ex2::br_sc_ex2,
		SC_pac_ex2::brr_sc_ex2, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst,
		//250
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		SC_pac_ex2::nop_inst, SC_pac_ex2::nop_inst,
		//255
SC_pac_ex2::nop_inst,};

#endif

