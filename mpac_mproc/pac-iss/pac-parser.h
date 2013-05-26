#ifndef PAC_PARSER_H_INCLUDED
#define PAC_PARSER_H_INCLUDED

void download_binary(int core_id);

void iss_sim_setup(int core_id);
void iss_sim_del(int core_id);
void iss_sim_parser(unsigned int core_id, char *filename, struct sim_arg *multi_sim_arg);
void iss_tic_setup(int core_id);
void iss_tic_compare(void);

extern struct sim_arg multi_sim_arg;

#endif
