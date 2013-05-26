#ifndef PAC_SHM_H_INCLUDED
#define PAC_SHM_H_INCLUDED

struct shm_type {
	void *core_ptr;
	void *m2_ptr;
	void *ddr_ptr;
	void *sysdma_ptr;
};

void *shm_create(char *name, unsigned int size, int flag);
void shm_del(char *name);

#endif
