#ifndef PAC_PARSER_H_INCLUDED
#define PAC_PARSER_H_INCLUDED

#include "pac-shm.h"
#include "mpac-mproc-sim-arg.h"

void soc_sim_parser(char *filename, struct sim_arg *multi_sim_arg);
void soc_sim_setup(struct sim_arg *multi_sim_arg);
void soc_sim_del(struct sim_arg *multi_sim_arg);

#endif
