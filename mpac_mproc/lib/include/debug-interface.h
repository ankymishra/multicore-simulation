#ifndef MPAC_DEBUGINF_H_INCLUDED
#define MPAC_DEBUGINF_H_INCLUDED

#ifndef WIN32
#include <sys/socket.h>
#include <netinet/in.h>
#else
#include <winsock2.h>
#include <ws2tcpip.h>
#endif

#include "fcntl.h"
#include "string.h"
#include "stdio.h"
#include "unistd.h"

#include "pac-types.h"

//use for communicate between gdb and iss
#define ISS_RESPONSE_OK		"0"
#define ISS_RESPONSE_FAIL	"1"
#define ISS_RESPONSE_SEMI	"2"

enum STOP_REASON {
        STOP_EXIT = 0, 		// Normal exit
        STOP_INT, 		// Ctrl + C
        STOP_TRAP, 		// Breakpoint , Step
		STOP_WB,        //WatchPoint
        STOP_EXCEP,		
		STOP_SEMIHOST
};

// use for client send cmd to server
#define GDB_ICE_GET_ID			1
#define GDB_ICE_INIT			2
#define GDB_ICE_EXIT			3
#define GDB_ICE_WRITE_MEM		4
#define GDB_ICE_READ_MEM		5
#define GDB_ICE_WRITE_DATA_REG		6
#define GDB_ICE_READ_DATA_REG		7
#define GDB_ICE_RESET			8
#define GDB_ICE_RUN			9
#define GDB_ICE_STEP			10
#define GDB_ICE_STOP			11
#define GDB_ICE_STOP_REASON		12
#define GDB_ICE_INSERT_BP		13
#define GDB_ICE_REMOVE_BP		14
#define GDB_ICE_INSERT_HARD_BP		15
#define GDB_ICE_REMOVE_HARD_BP		16
#define GDB_ICE_INSERT_WP		17
#define GDB_ICE_REMOVE_WP		18
#define GDB_ICE_DUMP_ICE_REGS		19
#define GDB_ICE_KILL			20
#define GDB_ICE_DUMP_DATA_REGS		21
#define GDB_ICE_SET_PC_ADDR		22
#define GDB_ICE_READ_ALL_DATA_REG	23
#define GDB_ICE_STOP_OTHER_CORE		24
#define GDB_ICE_SET_PROFILING_DATA	25
#define GDB_ICE_GET_PROFILING_HEAD	26
#define GDB_ICE_GET_PROFILING_DATA	27
#define GDB_ICE_GET_PROFILING_DMA_DATA	28
#define GDB_ICE_GET_PROFILING_CONTENTION_DATA	29

#define PAC_SOC_SERVER_PORT	(6000 + 600)

struct pthread_information
{
	int used;
	int tid;
	int gdb_fd;
	int core_mask;
};

struct pac_soc_init
{
	int core_mask;
};

struct pac_soc_exit
{
	int core_mask;
};

struct pac_soc_write_mem
{
	unsigned int addr;
	int len;
};

struct pac_soc_read_mem
{
	unsigned int addr;
	int len;
};

struct pac_soc_read_all_reg
{
	int core_id;
	int len;
};

struct pac_soc_write_reg
{
	int regno;
	int value_h;
	int value_l;
};

struct pac_soc_read_reg
{
	int regno;
	int value_h;
	int value_l;	
};

struct pac_soc_reset
{
	int core_mask;
};

struct pac_soc_run
{
	int core_mask;
};

struct pac_soc_step
{
	int core_mask;
	int step;
};

struct pac_soc_stop
{
	int core_mask;
};

struct pac_soc_stop_reason
{
	int core_mask;
	int reason;
	int active_core;
	int result;
};

struct pac_soc_insert_bp
{
	unsigned int addr;
};

struct pac_soc_remove_bp
{
	unsigned int addr;
};

struct pac_soc_insert_wp
{
	unsigned int addr;
	unsigned int len;
	unsigned int type;
};

struct pac_soc_remove_wp
{
	unsigned int addr;
	unsigned int len;
	unsigned int type;
};

struct pac_soc_set_pc
{
	int core_id;
	unsigned int addr;
};

struct pac_soc_set_profiling_data
{
	long long date;
	int core_id;
	unsigned int start_pc, end_pc;
	unsigned int usused;
};

struct pac_soc_get_profiling_data
{
	int core_id;
	int len;
	unsigned int start_pc, end_pc;
};

struct pac_soc_get_profiling_head
{
	int core_id;
	unsigned int start_pc, end_pc;
};

struct pac_soc_get_profiling_dma_data
{
	int core_id;
	int len;
	unsigned int start_pc, end_pc;
};

struct pac_soc_get_profiling_cont_data
{
	int core_id;
	int len;
	unsigned int start_pc, end_pc; 
};

//struct pac_soc_dump_ice_regs
//{};

//struct pac_soc_kill
//{};

//struct pac_soc_dump_data_regs
//{};

struct pac_soc_cmd
{
	unsigned int cmd_code;
	unsigned int unused;
	union {
		struct pac_soc_init		init;
		struct pac_soc_exit		exit;
		struct pac_soc_write_mem	write_mem;
		struct pac_soc_read_mem		read_mem;
		struct pac_soc_write_reg	write_reg;
		struct pac_soc_read_reg		read_reg;
		struct pac_soc_read_all_reg 	read_all_reg;
		struct pac_soc_reset		reset;
		struct pac_soc_run		run;
		struct pac_soc_step		step;
		struct pac_soc_stop		stop;
		struct pac_soc_stop_reason	reason;
		struct pac_soc_insert_bp	insert_bp;
		struct pac_soc_remove_bp	remove_bp;
		struct pac_soc_insert_wp	insert_wp;
		struct pac_soc_remove_wp	remove_wp;
		struct pac_soc_set_pc		set_pc;
		struct pac_soc_set_profiling_data set_profiling_data;
		struct pac_soc_get_profiling_data get_profiling_data;
		struct pac_soc_get_profiling_head get_profiling_head;
		struct pac_soc_get_profiling_dma_data get_profiling_dma_data;
		struct pac_soc_get_profiling_cont_data get_profiling_cont_data;
	};
};

// use for iss send response gdb
struct pac_soc_response
{
    int ret;
    int len;
};

struct core_reason {
	int active_core;
	int result;
	int have_reported;
	enum STOP_REASON reason;
};

struct reg_file {
	unsigned long long RF[10][32];
	unsigned char PSR[5][7];
};

#if 1
int gdb_ice_get_id(void);
int gdb_ice_init(BODY body, char **p);
int gdb_ice_exit(int code_bit_map);
int gdb_ice_write_mem(unsigned int addr, unsigned char *buf, int len);
int gdb_ice_read_mem(unsigned int addr, unsigned char *buf, int len);
int gdb_ice_write_data_reg(int regno, unsigned char *buf);
int gdb_ice_read_data_reg(int regno, unsigned char *buf);
int gdb_ice_reset(start_prog_addr pc, int core_bit_map);
int gdb_ice_run(int core_bit_map);
int gdb_ice_step(int step, int core_bit_map);
int gdb_ice_stop(int core_bit_map);
int gdb_ice_stop_reason(enum STOP_REASON *reason, int *ret, int core_bit_map, int *active_core_bit_map);
int gdb_ice_insert_bp(unsigned int addr);
int gdb_ice_remove_bp(unsigned int addr);
int gdb_ice_insert_hard_bp(unsigned int addr, int core_bit_map);
int gdb_ice_remove_hard_bp(unsigned int addr, int core_bit_map);
int gdb_ice_insert_wp(unsigned int addr, int len, int type, int core_bit_map);
int gdb_ice_remove_wp(unsigned int addr, int len, int type, int core_bit_map);
int gdb_ice_dump_ice_regs(int core_bit_map);
int gdb_ice_kill(int core_bit_map);
int gdb_ice_dump_data_regs(int core_bit_map);
int gdb_ice_read_all_data_reg(struct reg_file *buf, int size, int core_id);
int gdb_ice_set_profiling_data(unsigned int start_pc, unsigned int end_pc, int core_id, long long date);
int gdb_ice_get_profiling_data(unsigned int start_pc, unsigned int end_pc, int core_id, unsigned char *buf, int len);
int gdb_ice_get_profiling_head(unsigned int start_pc, unsigned int end_pc, int core_id);
int gdb_ice_get_profiling_dma_data(unsigned int start_pc, unsigned int end_pc, int core_id, unsigned char *buf, int len);
int gdb_ice_get_profiling_cont_data(unsigned int start_pc, unsigned int end_pc, int core_id, unsigned char *buf, int len);

void *server_pthread(void *port);
int read_socket(int fd, unsigned char *buf, int len);
void dump_memory(struct sim_arg *arg);

#define  PAC_SIM_GetCycle user_get_tick
#define  PAC_SIM_Init pac_soc_init
#define  PAC_SIM_Exit pac_soc_exit
#define  PAC_SIM_WriteMem pac_soc_write_mem
#define  PAC_SIM_ReadMem pac_soc_read_mem
#define  PAC_SIM_WriteReg pac_soc_write_reg
#define  PAC_SIM_ReadReg pac_soc_read_reg
#define  PAC_SIM_Reset pac_soc_reset
#define  PAC_SIM_Run pac_soc_run
#define  PAC_SIM_Step pac_soc_step
#define  PAC_SIM_Stop pac_soc_stop
#define  PAC_SIM_StopReason pac_soc_stop_reason
#define  PAC_SIM_DoCommand pac_soc_do_command
#define PAC_SIM_IntertSoftBP pac_soc_insert_bp
#define PAC_SIM_RemoveSoftBP pac_soc_remove_bp
#define MAX_WATCH_POINT 30
#define PAC_SIM_IntertWP pac_soc_insert_wp
#define PAC_SIM_RemoveWP pac_soc_remove_wp
#define PAC_SIM_AddUserProfiling user_profiling_add
#define PAC_SIM_DelUserProfiling user_profiling_delete

#endif

#endif
