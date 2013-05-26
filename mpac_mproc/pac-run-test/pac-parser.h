#include "pac-shm.h"
#include "mpac-mproc-sim-arg.h"

struct pattern_arg {
	char *core_bin[PATTERN_DSPNUM];
	char *core_tic[PATTERN_DSPNUM];
};

int pattern_stok(char *buf, struct pattern_arg *arg);
void iss_tic_setup(void);
void iss_tic_parser(char *filename);
void iss_setup(void);
void iss_compare(FILE * fp);
void pattern_sim_parser_setup(struct pattern_arg *arg);
void pattern_sim_parser(char *filename);
void pattern_sim_parser_del(struct pattern_arg *arg);
