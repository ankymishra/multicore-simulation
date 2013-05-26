#include "stdio.h"
#include "string.h"
#include "stdlib.h"
#include "mpac-mproc-define.h"
#include "pac-parser.h"
#include "IniLoader.h"

struct sim_arg multi_sim_arg;

void cfu_sim_parser_setup()
{
	multi_sim_arg.boot.core_shm_name = (char *)malloc(256*sizeof(char));
	memset((void *)multi_sim_arg.boot.core_shm_name, '\0', sizeof(multi_sim_arg.boot.core_shm_name));

	multi_sim_arg.boot.m2_shm_name = (char *)malloc(256*sizeof(char));
	memset((void *)multi_sim_arg.boot.m2_shm_name, '\0', sizeof(multi_sim_arg.boot.m2_shm_name));

	multi_sim_arg.boot.ddr_shm_name = (char *)malloc(256*sizeof(char));
	memset((void *)multi_sim_arg.boot.ddr_shm_name, '\0', sizeof(multi_sim_arg.boot.ddr_shm_name));

	multi_sim_arg.boot.sysdma_shm_name = (char *)malloc(256*sizeof(char));
	memset((void *)multi_sim_arg.boot.sysdma_shm_name, '\0', sizeof(multi_sim_arg.boot.sysdma_shm_name));

	multi_sim_arg.boot.cfu_shm_name = (char *)malloc(256*sizeof(char));
	memset((void *)multi_sim_arg.boot.cfu_shm_name, '\0', sizeof(multi_sim_arg.boot.cfu_shm_name));

}

static int Get_Value(char *Filename, char *Section, char *Value, int Format) 
{
	if (getValue(Filename, Section, Value) == 0x0)
		return 0;
	else
		return strtol(getValue(Filename, Section, Value), NULL, Format);
}

static char *Get_String(char *Filename, char *Section, char *Value) 			
{
	if (getValue(Filename, Section, Value) == 0x0)	
		return NULL;				
	else							
		return getValue(Filename, Section, Value);
}

void cfu_sim_parser(char *filename)
{
	int i;

	char core_name[128];

	multi_sim_arg.boot.share_mode = Get_Value(filename, "BOOT_OPTION", "SHARE_MODE", 0);

//CFU_SHM_NAME
	if (Get_String(filename, "BOOT_OPTION", "CFU_SHM_NAME") != NULL) {
		strcpy((char *)multi_sim_arg.boot.cfu_shm_name, Get_String(filename, "BOOT_OPTION", "CFU_SHM_NAME")); 
	}

//SOC_SHM_NAME
	if (Get_String(filename, "BOOT_OPTION", "CORE_SHM_NAME") != NULL) {
		strcpy((char *)multi_sim_arg.boot.core_shm_name, Get_String(filename, "BOOT_OPTION", "CORE_SHM_NAME")); 
	}

	if (Get_String(filename, "BOOT_OPTION", "M2_SHM_NAME") != NULL) {
		strcpy((char *)multi_sim_arg.boot.m2_shm_name, Get_String(filename, "BOOT_OPTION", "M2_SHM_NAME")); 
	}

	if (Get_String(filename, "BOOT_OPTION", "DDR_SHM_NAME") != NULL) {
		strcpy((char *)multi_sim_arg.boot.ddr_shm_name, Get_String(filename, "BOOT_OPTION", "DDR_SHM_NAME")); 
	}

	if (Get_String(filename, "BOOT_OPTION", "SYSDMA_SHM_NAME") != NULL) {
		strcpy((char *)multi_sim_arg.boot.sysdma_shm_name, Get_String(filename, "BOOT_OPTION", "SYSDMA_SHM_NAME")); 
	}

	for (i = 0; i< DSPNUM; i++) {
		sprintf(core_name, "CORE%d", i);

		multi_sim_arg.pacdsp[i].core_base = Get_Value(filename, core_name, "BASE", 0);
//M1
		multi_sim_arg.pacdsp[i].m1_mem.dmem_m1_offset = Get_Value(filename, core_name, "M1_MEM_OFFSET", 0);
		multi_sim_arg.pacdsp[i].m1_mem.dmem_m1_size = Get_Value(filename, core_name, "M1_MEM_SIZE", 0);
		multi_sim_arg.pacdsp[i].m1_mem.m1_rd_delay = Get_Value(filename, core_name, "M1_MEM_RD_DELAY", 0);
		multi_sim_arg.pacdsp[i].m1_mem.m1_wr_delay = Get_Value(filename, core_name, "M1_MEM_WR_DELAY", 0);

//Res1
		multi_sim_arg.pacdsp[i].res1.res1_offset = Get_Value(filename, core_name, "RES1_OFFSET", 0);
		multi_sim_arg.pacdsp[i].res1.res1_size = Get_Value(filename, core_name, "RES1_SIZE", 0);

//L1
		multi_sim_arg.pacdsp[i].l1_cache.l1_cache_type = Get_Value(filename, core_name, "L1_CACHE_LINE_TYPE", 0);
		multi_sim_arg.pacdsp[i].l1_cache.l1_cache_size = Get_Value(filename, core_name, "L1_CACHE_SIZE", 0);
		multi_sim_arg.pacdsp[i].l1_cache.l1_cache_line_size = Get_Value(filename, core_name, "L1_CACHE_LINE_SIZE", 0);
		multi_sim_arg.pacdsp[i].l1_cache.l1_rd_delay = Get_Value(filename, core_name, "L1_CACHE_LINE_RD_DELAY", 0);

//CORE BIU
		multi_sim_arg.pacdsp[i].biu.biu_offset = Get_Value(filename, core_name, "BIU_OFFSET", 0);
		multi_sim_arg.pacdsp[i].biu.biu_size = Get_Value(filename, core_name, "BIU_SIZE", 0);
		multi_sim_arg.pacdsp[i].biu.biu_rd_delay = Get_Value(filename, core_name, "BIU_RD_DELAY", 0);
		multi_sim_arg.pacdsp[i].biu.biu_wr_delay = Get_Value(filename, core_name, "BIU_WR_DELAY", 0);

//CORE ICU
		multi_sim_arg.pacdsp[i].icu.icu_offset = Get_Value(filename, core_name, "ICU_OFFSET", 0);
		multi_sim_arg.pacdsp[i].icu.icu_size = Get_Value(filename, core_name, "ICU_SIZE", 0);
		multi_sim_arg.pacdsp[i].icu.icu_rd_delay = Get_Value(filename, core_name, "ICU_RD_DELAY", 0);
		multi_sim_arg.pacdsp[i].icu.icu_wr_delay = Get_Value(filename, core_name, "ICU_WR_DELAY", 0);

//CORE DMU
		multi_sim_arg.pacdsp[i].dmu.dmu_offset = Get_Value(filename, core_name, "DMU_OFFSET", 0);
		multi_sim_arg.pacdsp[i].dmu.dmu_size = Get_Value(filename, core_name, "DMU_SIZE", 0);
		multi_sim_arg.pacdsp[i].dmu.dmu_rd_delay = Get_Value(filename, core_name, "DMU_RD_DELAY", 0);
		multi_sim_arg.pacdsp[i].dmu.dmu_wr_delay = Get_Value(filename, core_name, "DMU_WR_DELAY", 0);

//CORE DMA
		multi_sim_arg.pacdsp[i].dma.dma_offset = Get_Value(filename, core_name, "DMA_OFFSET", 0);
		multi_sim_arg.pacdsp[i].dma.dma_size = Get_Value(filename, core_name, "DMA_SIZE", 0);
		multi_sim_arg.pacdsp[i].dma.dma_rd_delay = Get_Value(filename, core_name, "DMA_RD_DELAY", 0);
		multi_sim_arg.pacdsp[i].dma.dma_wr_delay = Get_Value(filename, core_name, "DMA_WR_DELAY", 0);
//CORE Res2
		multi_sim_arg.pacdsp[i].res2.res2_offset = Get_Value(filename, core_name, "RES2_OFFSET", 0);
		multi_sim_arg.pacdsp[i].res2.res2_size = Get_Value(filename, core_name, "RES2_SIZE", 0);
	}

//M2	
	multi_sim_arg.m2_mem.dmem_m2_base = Get_Value(filename, "M2_MEM", "BASE", 0);
	multi_sim_arg.m2_mem.dmem_m2_size = Get_Value(filename, "M2_MEM", "SIZE", 0);
	multi_sim_arg.m2_mem.m2_rd_delay = Get_Value(filename, "M2_MEM", "RD_DELAY", 0);
	multi_sim_arg.m2_mem.m2_wr_delay = Get_Value(filename, "M2_MEM", "WR_DELAY", 0);

//L2
	multi_sim_arg.l2_cache.l2_cache_type = Get_Value(filename, "L2_CACHE", "L2_CACHE_LINE_TYPE", 0);
	multi_sim_arg.l2_cache.l2_cache_size = Get_Value(filename, "L2_CACHE", "L2_CACHE_SIZE", 0);
	multi_sim_arg.l2_cache.l2_cache_line_size = Get_Value(filename, "L2_CACHE", "L2_CACHE_LINE_SIZE", 0);
	multi_sim_arg.l2_cache.l2_rd_delay = Get_Value(filename, "L2_CACHE", "L2_CACHE_LINE_RD_DELAY", 0);
	
//L2 ICU
	multi_sim_arg.l2_icu.l2_icu_base = Get_Value(filename, "L2_ICU", "BASE", 0);
	multi_sim_arg.l2_icu.l2_icu_size = Get_Value(filename, "L2_ICU", "SIZE", 0);
	multi_sim_arg.l2_icu.l2_icu_rd_delay = Get_Value(filename, "L2_ICU", "RD_DELAY", 0);
	multi_sim_arg.l2_icu.l2_icu_wr_delay = Get_Value(filename, "L2_ICU", "WR_DELAY", 0);
	
//M2 DMU
	multi_sim_arg.m2_dmu.m2_dmu_base = Get_Value(filename, "M2_DMU", "BASE", 0);
	multi_sim_arg.m2_dmu.m2_dmu_size = Get_Value(filename, "M2_DMU", "SIZE", 0);
	multi_sim_arg.m2_dmu.m2_dmu_rd_delay = Get_Value(filename, "M2_DMU", "RD_DELAY", 0);
	multi_sim_arg.m2_dmu.m2_dmu_wr_delay = Get_Value(filename, "M2_DMU", "WR_DELAY", 0);

//M2 DMA
	multi_sim_arg.m2_dma.m2_dma_base = Get_Value(filename, "M2_DMA", "BASE", 0);
	multi_sim_arg.m2_dma.m2_dma_size = Get_Value(filename, "M2_DMA", "SIZE", 0);
	multi_sim_arg.m2_dma.m2_dma_rd_delay = Get_Value(filename, "M2_DMA", "RD_DELAY", 0);
	multi_sim_arg.m2_dma.m2_dma_wr_delay = Get_Value(filename, "M2_DMA", "WR_DELAY", 0);

//SEM
	multi_sim_arg.sem.sem_base = Get_Value(filename, "SEMAPHORE", "BASE", 0);
	multi_sim_arg.sem.sem_size = Get_Value(filename, "SEMAPHORE", "SIZE", 0);
	multi_sim_arg.sem.sem_rd_delay = Get_Value(filename, "SEMAPHORE", "RD_DELAY", 0);
	multi_sim_arg.sem.sem_wr_delay = Get_Value(filename, "SEMAPHORE", "WR_DELAY", 0);	

//C2CC
	multi_sim_arg.c2cc.c2cc_base = Get_Value(filename, "C2CC_INTERFACE", "BASE", 0);
	multi_sim_arg.c2cc.c2cc_size = Get_Value(filename, "C2CC_INTERFACE", "SIZE", 0);
	multi_sim_arg.c2cc.c2cc_rd_delay = Get_Value(filename, "C2CC_INTERFACE", "RD_DELAY", 0);
	multi_sim_arg.c2cc.c2cc_wr_delay = Get_Value(filename, "C2CC_INTERFACE", "WR_DELAY", 0);

//DDR
	multi_sim_arg.ddr_mem.ddr_memory_base = Get_Value(filename, "DDR", "BASE", 0);
	multi_sim_arg.ddr_mem.ddr_memory_size = Get_Value(filename, "DDR", "SIZE", 0);
	multi_sim_arg.ddr_mem.ddr_shm_base = Get_Value(filename, "DDR", "DDR_SHM_BASE", 0);
	multi_sim_arg.ddr_mem.ddr_shm_size = Get_Value(filename, "DDR", "DDR_SHM_SIZE", 0);
	multi_sim_arg.ddr_mem.ddr_rd_delay = Get_Value(filename, "DDR", "RD_DELAY", 0);
	multi_sim_arg.ddr_mem.ddr_wr_delay = Get_Value(filename, "DDR", "WR_DELAY", 0);

//BIU
	multi_sim_arg.biu.biu_rd_delay = Get_Value(filename, "BIU", "RD_DELAY", 0);
	multi_sim_arg.biu.biu_wr_delay = Get_Value(filename, "BIU", "WR_DELAY", 0);

//SYS_DMA
	multi_sim_arg.sys_dma.sys_dma_base = Get_Value(filename, "SYS_DMA", "BASE", 0);
	multi_sim_arg.sys_dma.sys_dma_size = Get_Value(filename, "SYS_DMA", "SIZE", 0);
	multi_sim_arg.sys_dma.sys_dma_rd_delay = Get_Value(filename, "SYS_DMA", "RD_DELAY", 0);
	multi_sim_arg.sys_dma.sys_dma_wr_delay = Get_Value(filename, "SYS_DMA", "WR_DELAY", 0);
//OTHER
	multi_sim_arg.other.sim_time_unit = Get_Value(filename, "OTHER", "SIM_TIME_UNIT", 0);

}

void cfu_sim_parser_del()
{
	free((void *)MULTI_ARG(boot, core_shm_name));
	free((void *)MULTI_ARG(boot, m2_shm_name));
	free((void *)MULTI_ARG(boot, ddr_shm_name));
	free((void *)MULTI_ARG(boot, sysdma_shm_name));
	free((void *)MULTI_ARG(boot, cfu_shm_name));
}
