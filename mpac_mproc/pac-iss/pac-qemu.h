#ifndef PAC_QEMU_H_INCLUDED
#define PAC_QEMU_H_INCLUDED

struct arm_pac_con_arg {
	unsigned int flag;
	unsigned int start_pc;	
};

struct arm_pac_type {
	struct arm_pac_con_arg arm_pac_core[DSPNUM];
};

#endif
