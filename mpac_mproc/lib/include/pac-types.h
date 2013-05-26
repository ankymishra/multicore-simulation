#ifndef _PAC_TYPE_H_INCLUDED
#define _PAC_TYPE_H_INCLUDED

#include "soc-types.h"

//modified by huawei.shen@sunnorth.com.cn
//2010-9-25
//for spct 6200 PACDSP multi-core debugging support
//enum BD_ISA{PAC_6100,BD_BODY};
enum BD_ISA{PAC_6100,PAC_6200,BD_BODY};

//#define MAX_MEM_NUM    10
#define MAX_MEM_NUM    20
#define MAX_SEC_NUM    10

//memory type 
#define MEM_TYPE_DDR   0
#define MEM_TYPE_SDRAM 1
#define MEM_TYPE_ASRAM 2
#define MEM_TYPE_ESRAM 3
#define MEM_TYPE_DMEM  4
#define MEM_TYPE_IMEM  5

//section type
#define SEC_TYPE_TXT  0
#define SEC_TYPE_DATA 1

typedef struct {
	UINT32 start;
	UINT32 size;
	UINT32 type;
}MEM_REGION;

//added by huawei.shen@sunnorth.com.cn
//2010-9-25
typedef struct {
	    unsigned int debug_isr_file_addr;                        //debug isr file address		
		unsigned int eice_share_mem;                             //share memory
		unsigned int cso_ptr;
		unsigned int cso_ptr_val;
    
		unsigned int prog_start_addr;                            // no used, default 0
        unsigned int data_base_addr;                             // no used, default 0
        unsigned int biu_base_addr;                              // no used, default 0
     //  unsigned int magic_pointer;                             // no used, default 0
     //  unsigned int magic_data;                                // no used, default 0
        unsigned int scalar_pointer;                             // no used, default 0
    //    unsigned int cluster1_pointer;                         // no used, default 0 
    //    unsigned int cluster2_pointer;                         // no used, default 0
}core_setting;

typedef struct {
    //for both spct6100 and multi-core
	enum BD_ISA   body;
	BOOL endian;	//0 little , 1 big ,default little

    //only for spct6100
	char debug_isr_file[MAX_FILE_PATH];
	char ddr_setting_file1[MAX_FILE_PATH];
	char ddr_setting_file2[MAX_FILE_PATH];
	char reset_pac_regs_file[MAX_FILE_PATH];
	char des_fpga_file[MAX_FILE_PATH];
	MEM_REGION mem[MAX_MEM_NUM];
	MEM_REGION section[MAX_SEC_NUM];

    //only for multi core
    unsigned int  clk_sel;                                   //0x00-12M;           0x01-ext_clk/4;    0x10-24M; 
                                                            //0x11--ext_clk/2;    0x20-48M;           0x21-ext_clk;
    unsigned char case_sel;                                  //0x00- JTAG mode;  0x01-Parallel_8bits mode;  
                                                            //0x10-Parallel_16bits mode  
    unsigned char  turbo_mode;                               //0x1- turbo_mode enable(fast mode)    0x0-turbo_mode off
    int  multi_core_ice_id;
    int  core_bit_map;                                       // ex, 4'b0110, indicate core2 & core1
    char debug_isr_file0[MAX_FILE_PATH];
    char debug_isr_file1[MAX_FILE_PATH];
    char debug_isr_file2[MAX_FILE_PATH];
    char debug_isr_file3[MAX_FILE_PATH];
    unsigned int core0_level_1_cache_flush_addr;
    unsigned int core1_level_1_cache_flush_addr;
    unsigned int core2_level_1_cache_flush_addr;
    unsigned int core3_level_1_cache_flush_addr;
    unsigned int level_2_cache_flush_addr;
    unsigned int system_sw_reset_addr; 

    core_setting core0;
    core_setting core1;
    core_setting core2;
    core_setting core3;
}BODY;

typedef struct {
    unsigned int core0_prog_start_addr;
    unsigned int core1_prog_start_addr;
    unsigned int core2_prog_start_addr;
    unsigned int core3_prog_start_addr;
}start_prog_addr;
#endif
