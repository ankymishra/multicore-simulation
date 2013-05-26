#include "pac-dsp.h"
#include "pac-issshm-prot.h"

#ifdef PAC_2WAY_ICACHE_LINE
#include "sc-pac-if-way.h"
#elif PAC_4WAY_ICACHE_LINE
#include "sc-pac-if-way.h"
#elif PAC_8WAY_ICACHE_LINE
#include "sc-pac-if-way.h"
#else
#include "sc-pac-if-direct.h"
#endif

#include "sc-pac-memif.h"
#include "pac-parser.h"
#include "pac-profiling.h"

#define PIPELINE_CNT 8
#define MAX_WRITE_NODE 30

void pac_dsp::pipeline_id()
{}

void pac_dsp::pipeline_ro()
{}

void pac_dsp::clear_state()
{
	state_machine = STATE_NORMAL;
}

void pac_dsp::start_branch_slot()
{
	state_machine = STATE_BRANCH_SLOT1;
}

void pac_dsp::set_state()
{
	state_machine |= STATE_BREAK_IN_SLOT;
	state_pipe_empty = STATE_PIPELINE_EMPT;
	statetmp = state_machine & 0xff;
}

int pac_dsp::is_in_branch_slot()
{
	return ((unsigned int) state_machine != STATE_NORMAL);
}

int pac_dsp::pac_soc_init()
{
	break_init();
	return 0;
}

int pac_dsp::pac_soc_reset()
{
	int i, j;

	WB_IDX = 0;

	for (i = 0; i < 8; i++) {
		for (j = 0; j < 5; j++) {
			memset(&(exec_table[i].instr[j].inst), -1, sizeof(inst_t));
			exec_table[i].instr[j].inst.op = NOP;
			exec_table[i].instr[j].inst.Imm32 = 0x0;
			exec_table[i].instr[j].inst.Memory_Addr = 0x0;
		}
		exec_table[i].PC = 0xffffffff;
		UPDATE_REGNUM(i) = 0;
	}

	for (i = 0; i < 8; i++)
		for (j = 0; j < UPDATE_REGMAX; j++)
			memset(&WRITE_LOG(i, j), -1, sizeof(write_node_t));


	//init ro_regs.RF
	ro_regs.sim_end = 0;

	memset(&ro_regs, 0, sizeof(RF_t));
	memset(&global_regs, 0, sizeof(RF_t));
	branch_occur = 0;
	clear_state();
	//interrupt_reset();
	return 0;
}

int pac_dsp::pac_soc_step(int step)
{
	int i;
	unsigned char trap_opration, opration;
	unsigned int pc, tmp_pc = 0;

	//is_semihosting = 0;// Add by dengyong 2008/02/21
	assert(step == 1);
	update_fetch_pc();
	pc = get_fetch_pc();

	WB_IDX = 0;

	//user_profiling_preDrive(get_fetch_pc(), sim_cycle + stall_cycle); //add by dengyong 2008/04/10
//	pipeline_if
	if_event_step = 1;
	if_pin = 1;
	wait(if_resp_event);
	if_pin = 0;
	if_event_step = 0;

	//user_profiling_postDrive(get_fetch_pc(), sim_cycle + stall_cycle);//add by dengyong 2008/04/10
	WB_IDX = EX3_IDX;
	WB_IDX = EX3_IDX;

	trap_opration = exec_table[IDISP_IDX].instr[0].inst.op;
//	pipeline_idp();
	if (trap_opration == TRAP)
	    ro_regs.sim_end = 9;
	WB_IDX = EX3_IDX;

	//pipeline_id();
	WB_IDX = EX3_IDX;

	//pipeline_ro();
	WB_IDX = EX3_IDX;

//	pipeline_e1();
	ex1_pin = 1;
	wait(ex1_resp_event);
	ex1_pin = 0;
	WB_IDX = EX3_IDX;

	opration = exec_table[0].instr[0].inst.op;
	if (opration == B ||
		opration == BR || opration == BRR || opration == LBCB) {
		tmp_pc = fetch_pc;
		for (i = 0; i < 5; i++) {
			dbg_step_flag = 1;
			fetch_pc += sc_pac_if_ptr->pac_get_inst_packet(fetch_pc)->packet_len;
			dbg_step_flag = 0;
		}
	}

//	pipeline_e2();
	ex2_step_count = 0;
	ex2_pin = 1;
	wait(ex2_resp_event);
	ex2_pin = 0;
	ex2_step_count = 0;
	WB_IDX = EX3_IDX;

	if (opration == B ||
		opration == BR || opration == BRR || opration == LBCB) {
		fetch_pc = tmp_pc;;
	}

//liqin	pipeline_e3();
	ex3_event.notify();
	wait(ex3_resp_event);
	WB_IDX = EX3_IDX;

	update_registerfile(WB_IDX);

	if (branch_occur == 1) {
		branch_occur = 0;
		dbg_step_flag = 1;
		set_fetch_pc(sc_pac_if_ptr->pac_get_inst_packet(pc)->packet_len + pc);
		dbg_step_flag = 0;
	}

	int_process(get_fetch_pc());

	if (trap_opration == TRAP) {
		printf("is_trap\r\n");
		ro_regs.sim_end = 1;
		eStopFlag = STOP_EXIT;
		global_regs.RF[Reg_CR][9] = pc;
	}

	memif_req_count = 0;
	mod_count = 0;
	return pc;
}

void pac_dsp::pac_iss_init(const char *filename, unsigned int addr)
{
	step_num = -1;
	cluster_idx = 0;

	state_pipe_empty = 0;
	statetmp = 0;
	state_machine = 0;

	branch_occur = 0;
	branch_target = 0;

	regT1 = 0;
	regT2 = 0;
	regT1Type = 0;
	regT2Type = 0;
	regTFlag = 0;
	regTBDR1 = 0;
	regTBDR2 = 0;

	WB_IDX = 0;

	pre_breakpc = 0xffffffff;

	pac_exec_init();
	pac_semihost_init();
	pac_soc_init();
}

void pac_dsp::pac_iss_run()
{
	int ret;
	unsigned int pc;
	int int_occur = 0;

	eStopFlag = STOP_TRAP;	// Breakpoint

	while (1) {
		wait();
		pac_iss_wait();

		if (eStopFlag != STOP_EXIT) {
			if (step_num > 0) {
				pc = pac_soc_step(1);
				step_num = -1;
				active_core_stop = 1;
				if (eStopFlag != STOP_EXIT)
					eStopFlag = STOP_TRAP;

				SET_ISS_STOP;
				ret = write(gdb_iss_fifo_wr_fd, ISS_RESPONSE_OK, 1);
				continue;
			}
//liqin			pipeline_e3();
			//printf("fetch_pc 0x%08x\r\n", fetch_pc);
			ex3_event.notify();
			wait(ex3_resp_event);
			
			/*break point or interrupt occur */
			if (((int_occur = is_int_occur(&pc)) != 0) || (eStopFlag == STOP_INT) || be_stoped == 1) {
				SET_ISS_STOP;
				pc = exec_table[EX2_IDX].PC;
				if (pc == 0xffffffff) {				// trap / branch insn
					pc = exec_table[EX1_IDX].PC;
				}

				if (pc == 0xffffffff) {				// be_stop at first insn
					pc = exec_table[0].PC;
				}

				update_registerfile(WB_IDX);
				update_registerfile(EX3_IDX);
				int_process(pc);
				if (be_stoped != 1) {
					active_core_stop = 1;
					if (eStopFlag == STOP_SEMIHOST) {
						write(gdb_iss_fifo_wr_fd, ISS_RESPONSE_SEMI, 1);
					} else {
						eStopFlag = STOP_TRAP;
						printf("is breakpoint hit at address 0x%08x!\n\r", pc);
						write(gdb_iss_fifo_wr_fd, ISS_RESPONSE_OK, 1);
					}
				}
				be_stoped = 0;
				continue;
			}


			sc_pac_memif_ptr_0->dbg_start_profiling(get_fetch_pc());
			mod_count = 0;
			dsp_pin = 1;
			wait(mod_resp_event);
			dsp_pin = 0;
			mod_count = 0;
			sc_pac_memif_ptr_0->dbg_stop_profiling(exec_table[EX1_IDX].PC);
			
			if (eStopFlag == STOP_WB) {
				//int wb_idx = WB_IDX;

				SET_ISS_STOP;
				pc = exec_table[EX2_IDX].PC;
				int_occur = 1;
				update_registerfile(EX2_IDX);
				update_registerfile(EX3_IDX);
				update_registerfile(WB_IDX);
				WB_IDX = EX3_IDX;
				int_process(pc);
				eStopFlag = STOP_WB;
				printf("is watchpoint hit at address 0x%08x!\n\r", pc);
				active_core_stop = 1;
				write(gdb_iss_fifo_wr_fd, ISS_RESPONSE_OK, 1);
				continue;
			}

			WB_IDX = EX3_IDX;
		} else {
			if (eStopFlag == STOP_EXIT && (step_num != -1)) {
				SET_ISS_STOP;
				write(gdb_iss_fifo_wr_fd, ISS_RESPONSE_OK, 1);
				step_num = -1;
			}

			if (multi_arg(boot, use_gdbserver)) {
				continue;
			} else {
				break;
			}
		}

		if (ro_regs.sim_end == 1) {
			printf("is_trap\r\n");
			eStopFlag = STOP_EXIT;
			active_core_stop = 1;
			write(gdb_iss_fifo_wr_fd, ISS_RESPONSE_OK, 1);
			queue_uninit();
		}

		update_registerfile(IF_IDX);
	}
	sc_stop();
}

void pac_dsp::save_branch_target(unsigned int pc)
{
	branch_target = pc;
	start_branch_slot();
}

unsigned int pac_dsp::get_fetch_pc()
{
	return fetch_pc;
}

void pac_dsp::set_fetch_pc(unsigned int pc)
{
	fetch_pc = pc;
}

void pac_dsp::clear_pipeline()
{
	int i, j;

	//clear pipeline and return;
	memset(exec_table, 0, sizeof(exec_table));
	for (i = 0; i < 8; i++) {
		for (j = 0; j < 5; j++) {
			memset(&(exec_table[i].instr[j].inst), -1, sizeof(inst_t));
			exec_table[i].instr[j].inst.op = NOP;
			exec_table[i].instr[j].inst.Imm32 = 0x0;
			exec_table[i].instr[j].inst.Memory_Addr = 0x0;
		}
	}
}

int pac_dsp::is_int_occur(unsigned int *pc)
{
	unsigned int exe2pc = exec_table[EX2_IDX].PC;

	if (exec_table[EX2_IDX].breakpoint == 0xab) {
		if (exe2pc != pre_breakpc) {
			pre_breakpc = exe2pc;
			if (multi_arg(boot, use_semihost)) {
				eStopFlag = STOP_SEMIHOST;
				return 1;
			} else {
				syscall_proc();
				memcpy(&ro_regs, &global_regs, sizeof(RF_t));
			}
		}
		pre_breakpc = 0xffffffff;
	}

	if (is_bp_hit(exe2pc)) {
		*pc = exe2pc;
		pre_breakpc = exe2pc;
		return 1;
	}
	return 0;
}

void pac_dsp::int_process(unsigned int pc)
{
	clear_pipeline();
	//update_register_file;
	global_regs.RF[Reg_CR][9] = pc;
	global_regs.RF[Reg_CR][10] = branch_target;

	//synchronization all register file
	memcpy(&ro_regs, &global_regs, sizeof(RF_t));

	{
		for (int i = 0; i < 8; i++)
			UPDATE_REGNUM(i) = 0;
	}

	WB_IDX = 0;
	if (is_in_branch_slot())
		set_state();

	set_fetch_pc(pc);
}

void pac_dsp::update_fetch_pc()
{
	//user maybe changed the CP register ,so we must synchronization the CPP register
	memcpy(&global_regs.RF[Reg_CPP][0], &global_regs.RF[Reg_CP][0],
		   sizeof(global_regs.RF[Reg_CP]));
	memcpy(&ro_regs, &global_regs, sizeof(RF_t));

	if (get_fetch_pc() != global_regs.RF[Reg_CR][9]) {
		set_fetch_pc(global_regs.RF[Reg_CR][9]);
		clear_state();
	} else {
		branch_target = global_regs.RF[Reg_CR][10];
	}
}

int pac_dsp::soc_write_reg(unsigned int addr, unsigned char *buf)
{
	int i;
	unsigned long long data64;
	unsigned int data = *(unsigned int *) buf;

	if (addr >= 0 && addr <= 15)
		global_regs.RF[Reg_R][addr] = data;	// Scalar
	else if (addr >= 16 && addr <= 31)
		global_regs.RF[Reg_D][addr - 16] = data;	// Cluster 1
	else if (addr >= 32 && addr <= 39) {
		data64 = *(unsigned long long *) buf;
		global_regs.RF[Reg_AC][addr - 32] = (data64 & 0xffffffffffLLU);	//40bit
	} else if (addr >= 40 && addr <= 47)
		global_regs.RF[Reg_A][addr - 40] = data;
	else if (addr >= 48 && addr <= 55)
		global_regs.RF[Reg_C][addr - 48] = data;
	else if (addr >= 56 && addr <= 71)
		global_regs.RF[Reg_D][addr - 56 + 16] = data;	// Cluster 2
	else if (addr >= 72 && addr <= 79) {
		data64 = *(unsigned long long *) buf;
		global_regs.RF[Reg_AC][addr - 72 + 16] = (data64 & 0xffffffffffLLU);	//40bit
	} else if (addr >= 80 && addr <= 87)
		global_regs.RF[Reg_A][addr - 80 + 16] = data;
	else if (addr >= 88 && addr <= 95)
		global_regs.RF[Reg_C][addr - 88 + 16] = data;
	else if (addr == 96) {
		for (i = 0; i < 2; i++) {
			global_regs.PSR[0][i] = data & 0x1;
			data >>= 1;
		}
	} else if (addr >= 97 && addr <= 98)
		global_regs.RF[Reg_CP][addr - 97] = data & 0x7F;
	else if (addr == 99) {
		for (i = 0; i < 7; i++) {
			global_regs.PSR[2][i] = data & 0x1;
			data >>= 1;
		}
	} else if (addr == 100) {
		for (i = 0; i < 7; i++) {
			global_regs.PSR[1][i] = data & 0x1;
			data >>= 1;
		}
	} else if (addr == 101)
		global_regs.RF[Reg_AMCR][0] = data & 0xFFFF;
	else if (addr >= 102 && addr <= 103)
		global_regs.RF[Reg_CP][addr - 102 + 16] = data & 0x7F;
	else if (addr == 104) {
		for (i = 0; i < 7; i++) {
			global_regs.PSR[4][i] = data & 0x1;
			data >>= 1;
		}
	} else if (addr == 105) {
		for (i = 0; i < 7; i++) {
			global_regs.PSR[3][i] = data & 0x1;
			data >>= 1;
		}
	} else if (addr == 106)
		global_regs.RF[Reg_AMCR][16] = data & 0xFFFF;
	else if (addr == 107)
		global_regs.RF[Reg_CR][0] = data & 0xFFFF;
	else if (addr == 108)
		global_regs.RF[Reg_CR][1] = data & 0xFF;
	else if (addr >= 109 && addr <= 110)
		global_regs.RF[Reg_CR][addr - 107] = data & 0xFFFF;
	else if (addr >= 111 && addr <= 114)
		global_regs.RF[Reg_CR][addr - 107] = data;
	else if (addr == 115)
		global_regs.RF[Reg_CR][8] = data & 0xFF;
	else if (addr >= 116 && addr <= 118)
		global_regs.RF[Reg_CR][addr - 107] = data;
	else if (addr >= 119 && addr <= 120)
		global_regs.RF[Reg_CR][addr - 107] = data & 0xFF;
	else if (addr == 121)
		global_regs.RF[Reg_CR][14] = data & 0xFFFF;
	else {
		printf("Write unknow register number %d.\n", addr);
		return -1;
	}
	return 0;
}

int pac_dsp::soc_read_all_reg(unsigned char *buf)
{
	memcpy(buf, global_regs.RF, sizeof(global_regs.RF));
	memcpy((unsigned char *) (buf + sizeof(global_regs.RF)), global_regs.PSR,
		   sizeof(global_regs.PSR));
	return 0;
}

int pac_dsp::soc_read_reg(unsigned int addr, unsigned char *ret)
{
	int i;
	unsigned char tmp;

	// Scalar Register
	// R
	if (addr >= 0 && addr <= 15) {
		for (i = 0; i < 4; i++) {
			ret[i] = (global_regs.RF[Reg_R][addr] >> 8 * i) & 0xFF;	// & ((unsigned long long)0xFF << 8*i)) >> 8*i;
		}
	} else if (addr >= 16 && addr <= 31) {
		for (i = 0; i < 4; i++) {
			ret[i] = (global_regs.RF[Reg_D][addr - 16] >> 8 * i) & 0xFF;
		}
	} else if (addr >= 32 && addr <= 39) {	// AC
		for (i = 0; i < 5; i++) {
			ret[i] = (global_regs.RF[Reg_AC][addr - 32] >> 8 * i) & 0xFF;
		}
	} else if (addr >= 40 && addr <= 47) {	// A
		for (i = 0; i < 4; i++) {
			ret[i] = (global_regs.RF[Reg_A][addr - 40] >> 8 * i) & 0xFF;
		}
	} else if (addr >= 48 && addr <= 55) {	// C
		for (i = 0; i < 4; i++) {
			ret[i] = (global_regs.RF[Reg_C][addr - 48] >> 8 * i) & 0xFF;
		}
	} else if (addr >= 56 && addr <= 71) {	// D
		for (i = 0; i < 4; i++) {
			ret[i] = (global_regs.RF[Reg_D][addr - 56 + 16] >> 8 * i) & 0xFF;
		}
	} else if (addr >= 72 && addr <= 79) {
		for (i = 0; i < 5; i++) {
			ret[i] = (global_regs.RF[Reg_AC][addr - 72 + 16] >> 8 * i) & 0xFF;
		}
	} else if (addr >= 80 && addr <= 87) {	// A
		for (i = 0; i < 4; i++) {
			ret[i] = (global_regs.RF[Reg_A][addr - 80 + 16] >> 8 * i) & 0xFF;
		}
	} else if (addr >= 88 && addr <= 95) {	// C
		for (i = 0; i < 4; i++) {
			ret[i] = (global_regs.RF[Reg_C][addr - 88 + 16] >> 8 * i) & 0xFF;
		}
	} else if (addr == 96) {	// System Register, SC_PSR
		tmp = 0;
		for (i = 7; i > 0; i--) {
			tmp <<= 1;
			if (global_regs.PSR[0][i - 1] == 1)
				tmp |= 0x1;
			else
				tmp &= 0xFE;
		}
		ret[0] = tmp;
	} else if (addr >= 97 && addr <= 98) {	// CP0_1, CP1_1, LS_PSR_1, AU_PSR_1
		ret[0] = global_regs.RF[Reg_CP][addr - 97] & 0x7F;
	} else if (addr == 99) {
		tmp = 0;
		for (i = 7; i > 0; i--) {
			tmp <<= 1;
			if (global_regs.PSR[2][i - 1] == 1)
				tmp |= 0x1;
			else
				tmp &= 0xFE;
		}
		ret[0] = tmp;
	} else if (addr == 100) {
		tmp = 0;
		for (i = 7; i > 0; i--) {
			tmp <<= 1;
			if (global_regs.PSR[1][i - 1] == 1)
				tmp |= 0x1;
			else
				tmp &= 0xFE;
		}
		ret[0] = tmp;
	} else if (addr == 101) {	// AMCR_1
		for (i = 0; i < 2; i++) {
			ret[i] = (global_regs.RF[Reg_AMCR][0] >> 8 * i) & 0xFF;
		}
	} else if (addr >= 102 && addr <= 103) {	// CP0_2, CP1_2, LS_PSR_2, AU_PSR_2
		ret[0] = global_regs.RF[Reg_CP][addr - 102 + 16] & 0x7F;
	} else if (addr == 104) {
		tmp = 0;
		for (i = 7; i > 0; i--) {
			tmp <<= 1;
			if (global_regs.PSR[4][i - 1] == 1)
				tmp |= 0x1;
			else
				tmp &= 0xFE;
		}
		ret[0] = tmp;
	} else if (addr == 105) {
		tmp = 0;
		for (i = 7; i > 0; i--) {
			tmp <<= 1;
			if (global_regs.PSR[3][i - 1] == 1)
				tmp |= 0x1;
			else
				tmp &= 0xFE;
		}
		ret[0] = tmp;
	} else if (addr == 106) {	// AMCR_2
		for (i = 0; i < 2; i++) {
			ret[i] = (global_regs.RF[Reg_AMCR][16] >> 8 * i) & 0xFF;
		}
	} else if (addr == 107) {	// SR0
		for (i = 0; i < 2; i++) {
			ret[i] = (global_regs.RF[Reg_CR][0] >> 8 * i) & 0xFF;
		}
	} else if (addr == 108) {	// SR1
		ret[0] = global_regs.RF[Reg_CR][1] & 0xFF;
	} else if (addr >= 109 && addr <= 110) {	// SR2 & SR3
		for (i = 0; i < 2; i++) {
			ret[i] = (global_regs.RF[Reg_CR][addr - 107] >> 8 * i) & 0xFF;
		}
	} else if (addr >= 111 && addr <= 114) {	// SR4, SR5, SR6, & SR7
		for (i = 0; i < 4; i++) {
			ret[i] = (global_regs.RF[Reg_CR][addr - 107] >> 8 * i) & 0xFF;
		}
	} else if (addr == 115) {	// SR8
		ret[0] = global_regs.RF[Reg_CR][8] & 0xFF;
	} else if (addr == 116) {	// SR9  Now is current PC
		for (i = 0; i < 4; i++) {
			ret[i] = (global_regs.RF[Reg_CR][9] >> 8 * i) & 0xFF;
			//ret[i] = (inst_table[INST_IDX-1].PC >> 8*i) & 0xFF;
		}
	} else if (addr >= 117 && addr <= 118) {	// SR10, & SR11
		for (i = 0; i < 4; i++) {
			ret[i] = (global_regs.RF[Reg_CR][addr - 107] >> 8 * i) & 0xFF;
		}
	} else if (addr >= 119 && addr <= 120) {	// SR12 & SR13
		ret[0] = global_regs.RF[Reg_CR][addr - 107] & 0xFF;
	} else if (addr == 121) {	// SR14
		for (i = 0; i < 2; i++) {
			ret[i] = (global_regs.RF[Reg_CR][14] >> 8 * i) & 0xFF;
		}
	} else {
		printf("Write unknow register number %d.\n", addr);
		return -1;
	}
	return 0;
}
