#ifndef PAC_PROFILE_H_INCLUDED
#define PAC_PROFILE_H_INCLUDED

struct profile_inst {
	tlm::tlm_command cmd;
	int bank_num;
	unsigned int inst_core_range;
};

struct profile_core {
	unsigned int generic_wait_flag[3];
	double start_time;
	double core_delay;
	double inst_delay;
	double generic_delay;

	struct profile_inst inst[7]; //sc c1 c2 dmu_sc dmu_c1 dmu_c2 if
};

struct profile_soc {
	struct profile_core profile_core_table[DSPNUM];
};
#endif
