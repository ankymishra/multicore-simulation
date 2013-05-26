#include "pac-dsp.h"
#include "sc-pac-memif.h"
#include "tic-parser.h"
#include "pac-parser.h"
#include "IniLoader.h"

struct tic_head *list_set;
struct tic_head *list_compare;

extern FILE *yyin;

extern "C" {
	int yyparse();
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

static void iss_tic_parser(char *filename)
{
	struct list_head *pos;

	yyin = fopen(filename, "r");
	if (yyin == NULL) {
		fprintf(stderr, "Can't open tic file\r\n");
		exit(-1);
	}

	do {
		yyparse();
	} while (!feof(yyin));

	list_for_each(pos, &(list_set->list)) {
		sc_pac_memif_ptr_0->dbg_dmem_write(((struct tic_head *)pos)->address,
			reinterpret_cast <unsigned char *>(&(((struct tic_head *)pos)->value)),sizeof(((struct tic_head *)pos)->value));
		free(pos->prev);
	}
}

void iss_tic_setup(int core_id)
{
	list_compare = (struct tic_head *) malloc(sizeof(struct tic_head));
	list_set = (struct tic_head *) malloc(sizeof(struct tic_head));

	INIT_LIST_HEAD(&(list_compare->list));
	INIT_LIST_HEAD(&(list_set->list));

	if (strcmp(MULTI_ARG(pacdsp[core_id].core, core_tic), "") != 0)
		iss_tic_parser(MULTI_ARG(pacdsp[core_id].core, core_tic));
}

void iss_sim_setup(int core_id)
{
	multi_sim_arg.boot.cfu_shm_name = (char *) malloc(256 * sizeof(char));
	memset((void *) multi_sim_arg.boot.cfu_shm_name, '\0',
		   sizeof(multi_sim_arg.boot.cfu_shm_name));

	multi_sim_arg.boot.soc_shm_name = (char *) malloc(256 * sizeof(char));
	memset((void *) multi_sim_arg.boot.soc_shm_name, '\0',
		   sizeof(multi_sim_arg.boot.soc_shm_name));

	multi_sim_arg.boot.iss_shm_name = (char *) malloc(256 * sizeof(char));
	memset((void *) multi_sim_arg.boot.iss_shm_name, '\0',
		   sizeof(multi_sim_arg.boot.iss_shm_name));

	multi_sim_arg.boot.soc_fifo_name = (char *) malloc(256 * sizeof(char));
	memset((void *) multi_sim_arg.boot.soc_fifo_name, '\0',
		   sizeof(multi_sim_arg.boot.soc_fifo_name));

	multi_sim_arg.boot.iss_fifo_rd_name = (char *) malloc(256 * sizeof(char));
	memset((void *) multi_sim_arg.boot.iss_fifo_rd_name, '\0',
		   sizeof(multi_sim_arg.boot.iss_fifo_rd_name));

	multi_sim_arg.boot.iss_fifo_wr_name = (char *) malloc(256 * sizeof(char));
	memset((void *) multi_sim_arg.boot.iss_fifo_wr_name, '\0',
		   sizeof(multi_sim_arg.boot.iss_fifo_wr_name));

	multi_sim_arg.pacdsp[core_id].core.core_bin =
		(char *) malloc(256 * sizeof(char));
	memset((void *) multi_sim_arg.pacdsp[core_id].core.core_bin, '\0',
		   sizeof(multi_sim_arg.pacdsp[core_id].core.core_bin));

	multi_sim_arg.pacdsp[core_id].core.core_tic =
		(char *) malloc(256 * sizeof(char));
	memset((void *) multi_sim_arg.pacdsp[core_id].core.core_tic, '\0',
		   sizeof(multi_sim_arg.pacdsp[core_id].core.core_tic));

	multi_sim_arg.dump.dump_file = (char *) malloc(256 * sizeof(char));
	memset((void *) multi_sim_arg.dump.dump_file, '\0',
		   sizeof(multi_sim_arg.dump.dump_file));
}

void iss_sim_del(int core_id)
{
	free((void *) MULTI_ARG(boot, soc_shm_name));
	free((void *) MULTI_ARG(boot, iss_shm_name));
	free((void *) MULTI_ARG(boot, soc_fifo_name));
	free((void *) MULTI_ARG(boot, iss_fifo_rd_name));
	free((void *) MULTI_ARG(boot, iss_fifo_wr_name));
	free((void *) MULTI_ARG(boot, cfu_shm_name));
	free((void *) MULTI_ARG(pacdsp[core_id].core, core_bin));
	free((void *) MULTI_ARG(pacdsp[core_id].core, core_tic));
	free((void *) MULTI_ARG(dump, dump_file));
	shm_del(multi_sim_arg.boot.iss_shm_name);
	shm_del(multi_sim_arg.boot.soc_shm_name);
}

void download_binary(int core_id)
{
	int fd, len;	
	unsigned char *buf;

	if (strcmp(MULTI_ARG(pacdsp[core_id].core, core_bin), "") != 0) {
		fd = open(MULTI_ARG(pacdsp[core_id].core, core_bin), O_RDONLY);
		if (fd == -1) {
			printf("can't to open file %s\r\n",
				   MULTI_ARG(pacdsp[core_id].core, core_bin));
			exit(-1);
		}

		buf = (unsigned char *) malloc(PROT_BUFSIZE);
		if (buf == NULL) {
			printf("can't malloc buf 64K\r\n");
			exit(-1);
		}

		printf("begin download prog binary file %s \r\n", MULTI_ARG(pacdsp[core_id].core, core_bin));
		for (unsigned int i = 0;
			 (i * PROT_BUFSIZE) < MULTI_ARG(ddr_mem, ddr_memory_size); i++) {
			len = read(fd, buf, PROT_BUFSIZE);
			if (len == -1)
				break;

			sc_pac_memif_ptr_0->dbg_dmem_write(MULTI_ARG(pacdsp[core_id].core, core_load_addr) 
				+ (i * PROT_BUFSIZE), buf, len);

			if (len != PROT_BUFSIZE)
				break;
		}

		printf("finish download prog binary file \r\n");
		free(buf);
	}
}

void iss_sim_parser(unsigned int core_id, char *filename,
					struct sim_arg *multi_sim_arg)
{
	char core_name[128];

	sprintf(core_name, "CORE%d", core_id);
//BOOT
	multi_sim_arg->boot.use_gdbserver =
		Get_Value(filename, "BOOT_OPTION", "BOOT_MODE", 0);
	multi_sim_arg->boot.gdbserver_port =
		Get_Value(filename, "BOOT_OPTION", "PORT", 0);
	multi_sim_arg->boot.use_profiling =
		Get_Value(filename, "BOOT_OPTION", "PROFILE", 0);
	multi_sim_arg->boot.use_semihost =
		Get_Value(filename, "BOOT_OPTION", "SEMIHOST", 0);
	multi_sim_arg->boot.share_mode =
		Get_Value(filename, "BOOT_OPTION", "SHARE_MODE", 0);
	multi_sim_arg->boot.qemu_addr =
		Get_Value(filename, "BOOT_OPTION", "QEMU_ADDR", 0);

//CFU_SHM_NAME
	if (Get_String(filename, "BOOT_OPTION", "CFU_SHM_NAME") != NULL) {
		strcpy((char *) multi_sim_arg->boot.cfu_shm_name,
			   Get_String(filename, "BOOT_OPTION", "CFU_SHM_NAME"));
	}
//SOC_SHM_NAME
	if (Get_String(filename, "BOOT_OPTION", "SOC_SHM_NAME") != NULL) {
		strcpy((char *) multi_sim_arg->boot.soc_shm_name,
			   Get_String(filename, "BOOT_OPTION", "SOC_SHM_NAME"));
	}
//ISS_SHM_NAME
	if (Get_String(filename, "BOOT_OPTION", "ISS_SHM_NAME") != NULL) {
		strcpy((char *) multi_sim_arg->boot.iss_shm_name,
			   Get_String(filename, "BOOT_OPTION", "ISS_SHM_NAME"));
	}
//SOC_FIFO_NAME
	if (Get_String(filename, "BOOT_OPTION", "SOC_FIFO_NAME") != NULL) {
		strcpy((char *) multi_sim_arg->boot.soc_fifo_name,
			   Get_String(filename, "BOOT_OPTION", "SOC_FIFO_NAME"));
	}
//ISS_FIFO_NAME_READ
	if (Get_String(filename, "BOOT_OPTION", "ISS_FIFO_RD_NAME") != NULL) {
		strcpy((char *) multi_sim_arg->boot.iss_fifo_rd_name,
			   Get_String(filename, "BOOT_OPTION", "ISS_FIFO_RD_NAME"));
	}
//ISS_FIFO_NAME_WRITE
	if (Get_String(filename, "BOOT_OPTION", "ISS_FIFO_WR_NAME") != NULL) {
		strcpy((char *) multi_sim_arg->boot.iss_fifo_wr_name,
			   Get_String(filename, "BOOT_OPTION", "ISS_FIFO_WR_NAME"));
	}
//CORE
	if (Get_String(filename, core_name, "BIN") != NULL) {
		strcpy((char *) multi_sim_arg->pacdsp[core_id].core.core_bin,
			   Get_String(filename, core_name, "BIN"));
	}

	if (Get_String(filename, core_name, "TIC") != NULL) {
		strcpy((char *) multi_sim_arg->pacdsp[core_id].core.core_tic,
			   Get_String(filename, core_name, "TIC"));
	}

	multi_sim_arg->pacdsp[core_id].core.core_load_addr =
		Get_Value(filename, core_name, "LOAD_ADDR", 0);
	multi_sim_arg->pacdsp[core_id].core.core_start_pc =
		Get_Value(filename, core_name, "PC_ADDR", 0);

//L1
	multi_sim_arg->pacdsp[core_id].l1_cache.l1_cache_type =
		Get_Value(filename, core_name, "L1_CACHE_LINE_TYPE", 0);
	multi_sim_arg->pacdsp[core_id].l1_cache.l1_cache_size =
		Get_Value(filename, core_name, "L1_CACHE_SIZE", 0);
	multi_sim_arg->pacdsp[core_id].l1_cache.l1_cache_line_size =
		Get_Value(filename, core_name, "L1_CACHE_LINE_SIZE", 0);
	multi_sim_arg->pacdsp[core_id].l1_cache.l1_rd_delay =
		Get_Value(filename, core_name, "L1_CACHE_LINE_RD_DELAY", 0);

//DDR
	multi_sim_arg->ddr_mem.ddr_memory_base =
		Get_Value(filename, "DDR", "BASE", 0);
	multi_sim_arg->ddr_mem.ddr_memory_size =
		Get_Value(filename, "DDR", "SIZE", 0);

//DUMP
	if (Get_String(filename, "DUMP_INFO", "DUMP_MEM_FILE") != NULL) {
		strcpy((char *) multi_sim_arg->dump.dump_file,
			   Get_String(filename, "DUMP_INFO", "DUMP_MEM_FILE"));
	}

	multi_sim_arg->dump.dump_mode =
		Get_Value(filename, "DUMP_INFO", "DUMP_MEM_ADDR", 0);
	multi_sim_arg->dump.dump_addr =
		Get_Value(filename, "DUMP_INFO", "DUMP_MEM_LENGTH", 0);
	multi_sim_arg->dump.dump_len =
		Get_Value(filename, "DUMP_INFO", "DUMP_MEM_MODE", 0);

//OTHER
	multi_sim_arg->other.sim_time_unit =
		Get_Value(filename, "OTHER", "SIM_TIME_UNIT", 0);
}

void iss_tic_compare()
{
	struct list_head *pos;
	int dmem_read_value;
	int error = 0;

	list_for_each(pos, &(list_compare->list)) {
		sc_pac_memif_ptr_0->dbg_dmem_read(((struct tic_head *)pos)->address, 
							reinterpret_cast<unsigned char*>(&dmem_read_value), sizeof(dmem_read_value));

		if (dmem_read_value != ((struct tic_head *)pos)->value) {
			printf("address 0x%08x read value 0x%08x, want value 0x%08x\n",((struct tic_head *)pos)->address, 
							dmem_read_value, ((struct tic_head *)pos)->value);
			error = -1;
		}

		free(pos->prev);
	}

	if (error == -1) 
		exit(-1);
}


