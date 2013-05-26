#include "stdio.h"
#include "fcntl.h"
#include "stdlib.h"
#include "string.h"
#include "getopt.h"

#include "mpac-mproc-define.h"
#include "pac-cfu.h"
#include "pac-parser.h"

extern struct sim_arg multi_sim_arg;
static struct option long_options[] = {
	{"exec", required_argument, NULL, 'x'},
	{"help", no_argument, NULL, 'h'},
	{NULL, no_argument, NULL, 0}
};

static void show_help()
{
	printf("example: ./pac-cfu-run -x sim.ini \r\n");
	printf("Argument:\r\n");
	printf("-x --exec		execve *.ini file\r\n");
	printf("--help			help\r\n");
	exit(0);
}

int main(int argc, char *argv[])
{
	int i;
	int opt, option_index;
	unsigned short status;
	cfu_func	func;
	char *filename = NULL;
	unsigned short *cfu_shm_base_ptr;

	while((opt = getopt_long(argc, argv, "x:h", long_options, &option_index)) != -1) {
		switch (opt) {
			case 'x':
				filename = optarg;
				cfu_sim_parser_setup();
				cfu_sim_parser(filename);
				break;
			case 'h':
				show_help();
				break;
			default:
				printf("Invalid Argument \r\n");
				exit(-1);
		}
	}

	if (filename == NULL) {
		printf("No sim.ini file .\r\n");
		exit(-1);
	}

		cfu_mem_setup();

		register_cfu_functions();

		cfu_shm_base_ptr = (unsigned short *)shm_create(MULTI_ARG(boot, cfu_shm_name), 
						(CFU_NUM*CFU_BUFSIZE*2), O_CREAT|O_RDWR|O_TRUNC);

		while(1) {
			for (i = 0; i < CFU_NUM; i++) {
				volatile unsigned short *func_start_ptr = cfu_shm_base_ptr + CFU_BUFSIZE*i + CFU_FLAG_OFFSET;
				unsigned short func_start = *func_start_ptr;
				if(func_start & CFU_FUNC_START) {
					func = cfu_func_sets[i][func_start & 0xff];
					if(func) {
						status = func(func_start & 0xff, cfu_shm_base_ptr + CFU_BUFSIZE*i);
						*(volatile unsigned short *)func_start_ptr= 0x0;
					}
				}
			}
		}

	cfu_sim_parser_del();
}
