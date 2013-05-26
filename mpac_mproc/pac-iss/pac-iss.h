#ifndef _PAC_ISS_H_INCLUDED
#define _PAC_ISS_H_INCLUDED

#include <systemc.h>

#include "pac-iss-debug-def.h"
#include "pac-dsp-def.h"
#include "pac-exec-def.h"
#include "pac-semihost-def.h"

//from pac-ctrl-var.h
extern int cluster_idx;
extern int state_pipe_empty;
extern int statetmp;
extern int state_machine;

//from pac-exec-var.h
extern unsigned int regT1;
extern unsigned int regT2;
extern unsigned int regT1Type;
extern unsigned int regT2Type;
extern unsigned char regTFlag;
extern unsigned char regTBDR1;
extern unsigned char regTBDR2;
extern unsigned char regTBDT;

extern unsigned short cfu_resp;
extern unsigned int branch_Reg_P;

// Register File
extern RF_t ro_regs;
extern RF_t global_regs;

extern int WB_IDX;
extern inst_packet exec_table[8];
extern write_log pipeline_logtab[8];

//from pac-fetch-var.h
extern int branch_occur;
extern unsigned int fetch_pc;
extern unsigned int branch_target;
extern Inst_Package_more pac_packet;

//from pac-semihost-var.h
extern FILE *fp_buf[FP_MAX];
extern int fp_free;
extern int fp_count;
extern unsigned int pre_breakpc;

//for all module event
extern int if_event_step;
extern sc_event ex3_event;

extern sc_event if_resp_event;
extern sc_event ex1_resp_event;

extern int ex2_step_count;
extern sc_event ex2_resp_event;
extern sc_event ex3_resp_event;

extern int mod_count;
extern sc_event mod_resp_event;

extern int memif_req_count;	// max = 4
extern sc_event monitor_req_event, monitor_resp_event; // use to wake/wait monitor thread

extern int dbg_step_flag;
#endif
