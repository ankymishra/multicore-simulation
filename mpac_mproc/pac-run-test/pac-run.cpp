#include "stdio.h"
#include "stdlib.h"
#include "sys/types.h"
#include "unistd.h"
#include "getopt.h"
#include "string.h"
#include "wait.h"

#include "pac-define.h"
#include "mpac-mproc-define.h"
#include "pac-parser.h"
#include "pac-mem.h"

struct pattern_arg arg;
static struct option long_options[] = {
	{"exec", required_argument, NULL, 'x'},
	{"file", required_argument, NULL, 'f'},
	{"log", required_argument, NULL, 'w'},
	{"help", no_argument, NULL, 'h'},
	{NULL, no_argument, NULL, 0}
};

static void show_help()
{
	printf("example: ./pac-run-test -x sim.ini -f directory -w log_file\r\n");
	printf("Argument:\r\n");
	printf("-x --exec		execve *.ini file\r\n");
	printf("-f --file 		testpattern dirctory name\r\n");
	printf("-w --log 		testpattern log name\r\n");
	printf("--help			help\r\n");
	exit(0);
}

int main(int argc, char *argv[])
{
	pid_t pid, pid2;
	pattern_arg arg;
	FILE *fp = NULL, *log_fp = NULL;
	char *filename = NULL, *all_pattern_filename = NULL, *log_file = NULL;
	char buf[1024];
	char tmp_buf[1024];
	char core0_bin[256];
	char core1_bin[256];
	int opt, option_index;

	char pattern_filename[1024];
	int i = 0, j = 0;

	while ((opt = getopt_long(argc, argv, "w:f:x:h", long_options, &option_index)) != -1) {
		switch (opt) {
		case 'x':
			filename = optarg;
			pattern_sim_parser_setup(&arg);
			pattern_sim_parser(filename);
			break;
		case 'f':
			all_pattern_filename = optarg;
			break;
		case 'w':
			log_file = optarg;
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

	dmem_setup();
	log_fp = fopen(log_file, "wb+");
	if (log_fp == NULL)
		printf("error to open log file\r\n");

	while (all_pattern_filename[i] != '\0') {
		memset(pattern_filename, '\0', sizeof(pattern_filename));
		while (all_pattern_filename[i] != '\0') {
			pattern_filename[j] = all_pattern_filename[i];
			if (pattern_filename[j] == '+') {
				pattern_filename[j] = '\0';
				i++;
				j = 0;
				break;
			} else {
				j++;
			}
			i++;
		}

		fprintf(log_fp, "\nPatterns in %s\r", pattern_filename);
		sprintf(tmp_buf, "../test/regress/%s/%s.rf", pattern_filename, pattern_filename);
		fp = fopen(tmp_buf, "r");
		if (fp == NULL) {
			printf("error to open this file %s\r\n", argv[1]);
			exit(-1);
		}

		int count = 0, skip = 0;
		while (fgets(buf, sizeof(buf), fp)) {
			count++;
			fprintf(log_fp, "\n[%d]\r\n", count);
			dmem_reset();
			skip = pattern_stok(buf, &arg);

			if (skip == 0)
				iss_tic_setup();

			if (strcmp(arg.core_tic[0], "")) {
				sprintf(tmp_buf, "../test/regress/%s/tic/%s.tic.c", pattern_filename, arg.core_tic[0]);
				fprintf(log_fp, "core0_run_tic: %s\r\n", arg.core_tic[0]);
				if (skip == 0)
					iss_tic_parser(tmp_buf);
			}
			if (strcmp(arg.core_tic[1], "")) {
				sprintf(tmp_buf, "../test/regress/%s/tic/%s.tic.c", pattern_filename, arg.core_tic[1]);
				fprintf(log_fp, "core1_run_tic: %s\r\n", arg.core_tic[1]);
				if (skip == 0)
					iss_tic_parser(tmp_buf);
			}
			if (strcmp(arg.core_bin[0], "")) {
				sprintf(core0_bin, "../pac-iss/pac-iss-run 0 -r -x ../ini/sim-runtest.ini --core ../test/regress/%s/asm/%s.bin",
						pattern_filename, arg.core_bin[0]);
				fprintf(log_fp, "core0_run_bin: %s\r\n", arg.core_bin[0]);
			}

			if (strcmp(arg.core_bin[1], "")) {
				sprintf(core1_bin, "../pac-iss/pac-iss-run 1 -r -x ../ini/sim-runtest.ini --core ../test/regress/%s/asm/%s.bin",
						pattern_filename, arg.core_bin[1]);
				fprintf(log_fp, "core1_run_bin: %s\r\n", arg.core_bin[1]);
			}
			fflush(log_fp);

			if (skip == 0) {
				iss_setup();
				pid = fork();
				if (pid < 0) {
					printf("error to fork child process\r\n");
				} else if (pid == 0) {	//child
					pid2 = fork();
					if (pid2 < 0) {
						printf("error to fork child process\r\n");
					} else if (pid2 == 0) {
						if (strcmp(arg.core_bin[0], "")) {
							system(core0_bin);
							exit(0);
						}
					} else {
						if (strcmp(arg.core_bin[1], "")) {
							system(core1_bin);
						}
						waitpid(pid2, NULL, 0);
						exit(0);
					}
				} else {
					waitpid(pid, NULL, 0);
					iss_compare(log_fp);
				}
			} else {
				fprintf(log_fp, "SKIP\r\n");
			}
		}
	}

	fclose(fp);
	fclose(log_fp);
	pattern_sim_parser_del(&arg);
	//dmem_del();
}
