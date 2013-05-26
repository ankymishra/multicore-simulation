#include "stdio.h"
#include "string.h"
#include "mpac-mproc-define.h"
#include "pac-parser.h"
#include "IniLoader.h"


static char *Get_String(char *Filename, char *Section, char *Value) 			
{
	if (getValue(Filename, Section, Value) == 0x0)	
		return NULL;				
	else							
		return getValue(Filename, Section, Value);
}


void fe_sim_parser(char *filename, struct sim_arg *multi_sim_arg)
{
//ISS_SHM_NAME
	if (Get_String(filename, "BOOT_OPTION", "ISS_SHM_NAME") != NULL) {
		strcpy((char *)multi_sim_arg->boot.iss_shm_name, Get_String(filename, "BOOT_OPTION", "ISS_SHM_NAME")); 
	}
//ISS_FIFO_NAME_READ
	if (Get_String(filename, "BOOT_OPTION", "ISS_FIFO_RD_NAME") != NULL) {
		strcpy((char *)multi_sim_arg->boot.iss_fifo_rd_name, Get_String(filename, 								"BOOT_OPTION", "ISS_FIFO_RD_NAME")); 
	}
//ISS_FIFO_NAME_WRITE
	if (Get_String(filename, "BOOT_OPTION", "ISS_FIFO_WR_NAME") != NULL) {
		strcpy((char *)multi_sim_arg->boot.iss_fifo_wr_name, Get_String(filename, 								"BOOT_OPTION", "ISS_FIFO_WR_NAME")); 
	}
}


