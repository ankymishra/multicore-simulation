#include "stdio.h"
#include "stdlib.h"
#include "sys/mman.h"
#include "unistd.h"

#include "mpac-mproc-define.h"
#include "pac-issshm-prot.h"
#include "debug-interface.h"
#include "pac-parser.h"
#include "getopt.h"

#include "pac-gdb-server.h"

char *gdb_iss_wr_fifo_name[DSPNUM];
char *gdb_iss_rd_fifo_name[DSPNUM];
char *iss_shm_name[DSPNUM];
struct iss_rela_struct iss_rela[DSPNUM];

static struct option long_options[] = {
	{"exec", required_argument, NULL, 'x'},
	{"help", no_argument, NULL, 'h'},
	{"port", no_argument, NULL, 'n'},
	{NULL, no_argument, NULL, 0}
};

static void show_help()
{
	printf("example: ./gdb-gdb-server-run -x xxx.ini -n port\r\n");
	printf("Argument:\r\n");
	printf("-x --exec		execve *.ini file\r\n");
	printf("-s --num		control pac-iss num\r\n");
	printf("-o --port		gdbserverr connect port\r\n");
	printf("--help			help\r\n");
	exit(0);
}


struct sim_arg multi_sim_arg;
void gdb_server_setup(int dspnum, struct iss_rela_struct *iss_rela)
{
    int i, fd;
    char buf[256];

    for(i = 0; i< dspnum; i++) {

		sprintf(buf, "%s%d", MULTI_ARG(boot, iss_fifo_rd_name), i);
		gdb_iss_rd_fifo_name[i] = buf;
		printf("open rd fifo %s\r\n",gdb_iss_rd_fifo_name[i]);
		fd = open(gdb_iss_rd_fifo_name[i], O_RDONLY);
		if (fd < 0) {
			printf("gdb_server_setup open gdb_iss_fifo %s fail.\r\n", gdb_iss_rd_fifo_name[i]);
			exit(-1);
		} else {
			iss_rela[i].gdb_iss_rd_fifo_fd = fd;
		}

		sprintf(buf, "%s%d", MULTI_ARG(boot, iss_fifo_wr_name), i);
		gdb_iss_wr_fifo_name[i] = buf;
		printf("open wr fifo %s\r\n",gdb_iss_wr_fifo_name[i]);
		fd = open(gdb_iss_wr_fifo_name[i], O_WRONLY);
		if (fd < 0) {
			printf("gdb_server_setup open gdb_iss_fifo %s fail.\r\n", gdb_iss_wr_fifo_name[i]);
			exit(-1);
		} else {
			iss_rela[i].gdb_iss_wr_fifo_fd = fd;
		}

		sprintf(buf, "%s-%d", MULTI_ARG(boot, iss_shm_name), i);
		iss_shm_name[i] = buf;
		printf("open shm %s\r\n",iss_shm_name[i]);
		fd = shm_open(iss_shm_name[i], O_RDWR, 0666);
		if (fd < 0) {
			printf("gdb_server_setup open iss_shm %s fail.\r\n", iss_shm_name[i]);
			exit(-1);
		} else {
			iss_rela[i].iss_shm_prot_ptr = (struct iss_shm_prot *)
				mmap(0, PAGE_SIZE, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
		}
	}
}

int main(int argc, char *argv[])
{
	int dspnum;
	int opt,option_index;
	char *filename;
	multi_sim_arg.boot.iss_shm_name = (char *)malloc(256*sizeof(char));
	memset((void *)multi_sim_arg.boot.iss_shm_name, '\0', sizeof(multi_sim_arg.boot.iss_shm_name));

	multi_sim_arg.boot.iss_fifo_rd_name = (char *)malloc(256*sizeof(char));
	memset((void *)multi_sim_arg.boot.iss_fifo_rd_name, '\0', sizeof(multi_sim_arg.boot.iss_fifo_rd_name));

	multi_sim_arg.boot.iss_fifo_wr_name = (char *)malloc(256*sizeof(char));
	memset((void *)multi_sim_arg.boot.iss_fifo_wr_name, '\0', sizeof(multi_sim_arg.boot.iss_fifo_wr_name));

	while((opt = getopt_long(argc, argv, "hx:n:s:", long_options, &option_index)) != -1) {
		switch (opt) {
			case 'x':
				filename = optarg;
				fe_sim_parser(filename, &multi_sim_arg);
				break;
			case 'h':
				show_help();	
				break;
			case 'n':
				MULTI_ARG(boot, gdbserver_port) = atoi(optarg);
				break;		    
			case 's':
				dspnum = atoi(optarg);
				break;
			default:
				printf("Invalid Argument \r\n");
				exit(-1);
		}
	}

    gdb_server_setup(dspnum, iss_rela);
    server_pthread(&MULTI_ARG(boot, gdbserver_port));
	free((void *)MULTI_ARG(boot, iss_shm_name));
	free((void *)MULTI_ARG(boot, iss_fifo_rd_name));
	free((void *)MULTI_ARG(boot, iss_fifo_wr_name));
}
