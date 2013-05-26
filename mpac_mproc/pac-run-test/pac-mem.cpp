#include "fcntl.h"
#include "stdlib.h"
#include "string.h"
#include "sys/mman.h"

#include "pac-shm.h"
#include "pac-mem.h"
#include "mpac-mproc-define.h"
#include "mpac-mproc-sim-arg.h"

void *sysdma_ptr;
void *ddr_ptr;
void *m2_ptr;
void *core_ptr;

extern struct sim_arg multi_sim_arg;

void dmem_read(unsigned int addr, unsigned char *buf, int len)
{
	unsigned int core_size = 0, m2_size = 0, ddr_size = 0, sysdma_size = 0;
	unsigned int core_base = 0, m2_base = 0, ddr_base = 0, sysdma_base = 0;
	for (int i = 0; i < 4; i++) {
		core_size += MULTI_ARG(pacdsp[i].m1_mem, dmem_m1_size) + MULTI_ARG(pacdsp[i].res1, res1_size) +
			MULTI_ARG(pacdsp[i].biu, biu_size) + MULTI_ARG(pacdsp[i].icu, icu_size) +
			MULTI_ARG(pacdsp[i].dmu, dmu_size) + MULTI_ARG(pacdsp[i].dma, dma_size) + MULTI_ARG(pacdsp[i].res2, res2_size);
	}

	m2_size = MULTI_ARG(m2_mem, dmem_m2_size) + MULTI_ARG(l2_icu, l2_icu_size) + MULTI_ARG(m2_dmu, m2_dmu_size) +
		MULTI_ARG(m2_dma, m2_dma_size) + MULTI_ARG(sem, sem_size) + MULTI_ARG(c2cc, c2cc_size);

	ddr_size = MULTI_ARG(ddr_mem, ddr_memory_size);
	sysdma_size = MULTI_ARG(sys_dma, sys_dma_size);

	core_base = MULTI_ARG(pacdsp[0], core_base);
	m2_base = MULTI_ARG(m2_mem, dmem_m2_base);
	ddr_base = MULTI_ARG(ddr_mem, ddr_memory_base);
	sysdma_base = MULTI_ARG(sys_dma, sys_dma_base);

	if ((addr >= core_base) && ((addr + len) < (core_base + core_size))) {
		memcpy(buf, (unsigned char *)((addr - core_base) + (unsigned char *)core_ptr), len);
	} else if ((addr >= m2_base) && ((addr + len) < (m2_base + m2_size))) {
		memcpy(buf, (unsigned char *)((addr - m2_base) + (unsigned char *)m2_ptr), len);
	} else if ((addr >= ddr_base) && ((addr + len) < (ddr_base + ddr_size))) {
		memcpy(buf, (unsigned char *)((addr - ddr_base) + (unsigned char *)ddr_ptr), len);
	} else if ((addr >= sysdma_base) && ((addr + len) < (sysdma_base + sysdma_size))) {
		memcpy(buf, (unsigned char *)((addr - sysdma_base) + (unsigned char *)sysdma_ptr), len);
	}
}

void dmem_write(unsigned int addr, unsigned char *buf, int len)
{
	unsigned int core_size = 0, m2_size = 0, ddr_size = 0, sysdma_size = 0;
	unsigned int core_base = 0, m2_base = 0, ddr_base = 0, sysdma_base = 0;
	for (int i = 0; i < 4; i++) {
		core_size += MULTI_ARG(pacdsp[i].m1_mem, dmem_m1_size) + MULTI_ARG(pacdsp[i].res1, res1_size) +
			MULTI_ARG(pacdsp[i].biu, biu_size) + MULTI_ARG(pacdsp[i].icu, icu_size) +
			MULTI_ARG(pacdsp[i].dmu, dmu_size) + MULTI_ARG(pacdsp[i].dma, dma_size) + MULTI_ARG(pacdsp[i].res2, res2_size);
	}

	m2_size = MULTI_ARG(m2_mem, dmem_m2_size) + MULTI_ARG(l2_icu, l2_icu_size) +
		MULTI_ARG(m2_dmu, m2_dmu_size) + MULTI_ARG(m2_dma, m2_dma_size) + MULTI_ARG(sem, sem_size) +
		MULTI_ARG(c2cc, c2cc_size);

	ddr_size = MULTI_ARG(ddr_mem, ddr_memory_size);
	sysdma_size = MULTI_ARG(sys_dma, sys_dma_size);
	core_base = MULTI_ARG(pacdsp[0], core_base);
	m2_base = MULTI_ARG(m2_mem, dmem_m2_base);
	ddr_base = MULTI_ARG(ddr_mem, ddr_memory_base);
	sysdma_base = MULTI_ARG(sys_dma, sys_dma_base);

	if ((addr >= core_base) && ((addr + len) < (core_base + core_size))) {
		memcpy((unsigned char *)((addr - core_base) + (unsigned char *)core_ptr), buf, len);
	} else if ((addr >= m2_base) && ((addr + len) < (m2_base + m2_size))) {
		memcpy((unsigned char *)((addr - m2_base) + (unsigned char *)m2_ptr), buf, len);
	} else if ((addr >= ddr_base) && ((addr + len) < (ddr_base + ddr_size))) {
		memcpy((unsigned char *)((addr - ddr_base) + (unsigned char *)ddr_ptr), buf, len);
	} else if ((addr >= sysdma_base) && ((addr + len) < (sysdma_base + sysdma_size))) {
		memcpy((unsigned char *)((addr - sysdma_base) + (unsigned char *)sysdma_ptr), buf, len);
	}
}

void dmem_setup()
{
	unsigned int i, core_size = 0, m2_size = 0, ddr_size = 0, sysdma_size = 0;

	for (i = 0; i < 4; i++) {
		core_size += MULTI_ARG(pacdsp[i].m1_mem, dmem_m1_size) + MULTI_ARG(pacdsp[i].res1, res1_size) +
			MULTI_ARG(pacdsp[i].biu, biu_size) + MULTI_ARG(pacdsp[i].icu, icu_size) +
			MULTI_ARG(pacdsp[i].dmu, dmu_size) + MULTI_ARG(pacdsp[i].dma, dma_size) + MULTI_ARG(pacdsp[i].res2, res2_size);
	}

	m2_size = MULTI_ARG(m2_mem, dmem_m2_size) + MULTI_ARG(l2_icu, l2_icu_size) +
		MULTI_ARG(m2_dmu, m2_dmu_size) + MULTI_ARG(m2_dma, m2_dma_size) + MULTI_ARG(sem, sem_size) +
		MULTI_ARG(c2cc, c2cc_size);

	ddr_size = MULTI_ARG(ddr_mem, ddr_memory_size);
	sysdma_size = MULTI_ARG(sys_dma, sys_dma_size);

	core_ptr = shm_create(MULTI_ARG(boot, core_shm_name), core_size, O_RDWR);
	m2_ptr = shm_create(MULTI_ARG(boot, m2_shm_name), m2_size, O_RDWR);
	ddr_ptr = shm_create(MULTI_ARG(boot, ddr_shm_name), ddr_size, O_RDWR);
	sysdma_ptr = shm_create(MULTI_ARG(boot, sysdma_shm_name), sysdma_size, O_RDWR);
}

void dmem_del()
{
	shm_del(MULTI_ARG(boot, core_shm_name));
	shm_del(MULTI_ARG(boot, m2_shm_name));
	shm_del(MULTI_ARG(boot, ddr_shm_name));
	shm_del(MULTI_ARG(boot, sysdma_shm_name));
}

void dmem_reset()
{
	unsigned int m1_mem_base, m2_mem_base;
	unsigned int biu_base, icu_base;
	unsigned int dmu_base, dma_base;
	unsigned int m2_dmu_base, m2_dma_base;
	unsigned int sys_dma_base;
	unsigned int c2cc_base, ddr_base;
	unsigned int m1_sgr_base, m1_dsr_base;
	unsigned int m2_sgr_base, m2_dsr_base;
	unsigned int m1_stat_base, m2_stat_base;

	unsigned int m1_mem_size, m2_mem_size;
	unsigned int biu_size, icu_size;
	unsigned int dmu_size, dma_size;
	unsigned int m2_dmu_size, m2_dma_size;
	unsigned int sys_dma_size;
	unsigned int c2cc_size, ddr_size;

	m1_mem_base = MULTI_ARG(pacdsp[0], core_base);
	m2_mem_base = MULTI_ARG(m2_mem, dmem_m2_base);
	biu_base = MULTI_ARG(pacdsp[0], core_base) + MULTI_ARG(pacdsp[0].biu, biu_offset);
	icu_base = MULTI_ARG(pacdsp[0], core_base) + MULTI_ARG(pacdsp[0].icu, icu_offset);
	dmu_base = MULTI_ARG(pacdsp[0], core_base) + MULTI_ARG(pacdsp[0].dmu, dmu_offset);
	dma_base = MULTI_ARG(pacdsp[0], core_base) + MULTI_ARG(pacdsp[0].dma, dma_offset);
	m2_dmu_base = MULTI_ARG(m2_dmu, m2_dmu_base);
	m2_dma_base = MULTI_ARG(m2_dma, m2_dma_base);
	sys_dma_base = MULTI_ARG(sys_dma, sys_dma_base);
	c2cc_base = MULTI_ARG(c2cc, c2cc_base);
	ddr_base = MULTI_ARG(ddr_mem, ddr_memory_base);
	m1_sgr_base = MULTI_ARG(pacdsp[0], core_base) + MULTI_ARG(pacdsp[0].biu, biu_offset) + 0xC078;
	m1_dsr_base = MULTI_ARG(pacdsp[0], core_base) + MULTI_ARG(pacdsp[0].biu, biu_offset) + 0xC07C;
	m2_sgr_base = MULTI_ARG(m2_dma, m2_dma_base) + 0x78;
	m2_dsr_base = MULTI_ARG(m2_dma, m2_dma_base) + 0x7C;
	m1_stat_base = MULTI_ARG(pacdsp[0], core_base) + MULTI_ARG(pacdsp[0].biu, biu_offset) + 0x8054;
	m2_stat_base = MULTI_ARG(m2_dma, m2_dma_base) + 0x54;

	m1_mem_size = MULTI_ARG(pacdsp[0].m1_mem, dmem_m1_size);
	m2_mem_size = MULTI_ARG(m2_mem, dmem_m2_size);
	biu_size = MULTI_ARG(pacdsp[0].biu, biu_size);
	icu_size = MULTI_ARG(pacdsp[0].icu, icu_size);
	dmu_size = MULTI_ARG(pacdsp[0].dmu, dmu_size);
	dma_size = MULTI_ARG(pacdsp[0].dma, dma_size);
	m2_dmu_size = MULTI_ARG(m2_dmu, m2_dmu_size);
	m2_dma_size = MULTI_ARG(m2_dma, m2_dma_size);
	sys_dma_size = MULTI_ARG(sys_dma, sys_dma_size);
	c2cc_size = MULTI_ARG(c2cc, c2cc_size);
	ddr_size = MULTI_ARG(ddr_mem, ddr_memory_size);

	unsigned char *buf;
	unsigned int m1_corenum;
	buf = (unsigned char *)malloc(sizeof(char) * (ddr_size - 1));
	memset(buf, 0, sizeof(char) * (ddr_size - 1));

	for (m1_corenum = 0; m1_corenum < 4; m1_corenum++) {
		//m1_mem        
		dmem_write((m1_mem_base + 0x100000 * m1_corenum), (unsigned char *)buf, sizeof(char) * (m1_mem_size - 1));
		//biu
		dmem_write((biu_base + 0x100000 * m1_corenum), (unsigned char *)buf, sizeof(char) * (biu_size - 1));
		//icu
		dmem_write((icu_base + 0x100000 * m1_corenum), (unsigned char *)buf, sizeof(char) * (icu_size - 1));
		//dmu
		dmem_write((dmu_base + 0x100000 * m1_corenum), (unsigned char *)buf, sizeof(char) * (dmu_size - 1));
		//dma
		dmem_write((dma_base + 0x100000 * m1_corenum), (unsigned char *)buf, sizeof(char) * (dma_size - 1));
	}

	//sys_dma
	dmem_write(sys_dma_base, (unsigned char *)buf, sizeof(char) * (sys_dma_size - 1));

	//m2_mem
	dmem_write(m2_mem_base, (unsigned char *)buf, sizeof(char) * (m2_mem_size - 1));

	//m2_dmu
	dmem_write(m2_dmu_base, (unsigned char *)buf, sizeof(char) * (m2_dmu_size - 1));

	//m2_dma
	dmem_write(m2_dma_base, (unsigned char *)buf, sizeof(char) * (m2_dma_size - 1));

	//c2cc
	dmem_write(c2cc_base, (unsigned char *)buf, sizeof(char) * (c2cc_size - 1));

	//ddr
	dmem_write(ddr_base, (unsigned char *)buf, sizeof(char) * (ddr_size - 1));

	free(buf);

	//m1_sgr&dsr                          
	unsigned int buf0 = 0x00100000;

	unsigned int m1_dmanum = 0;
	for (m1_corenum = 0; m1_corenum < 4; m1_corenum++) {
		for (m1_dmanum = 0; m1_dmanum < 4; m1_dmanum++) {
			dmem_write((m1_sgr_base + 0x100000 * m1_corenum + 0x40 * m1_dmanum), (unsigned char *)(&buf0), sizeof(char) * 4);
			dmem_write((m1_dsr_base + 0x100000 * m1_corenum + 0x40 * m1_dmanum), (unsigned char *)(&buf0), sizeof(char) * 4);
		}
	}

	//m2_sgr&dsr
	unsigned int m2_dmanum = 0;
	for (m2_dmanum = 0; m2_dmanum < 8; m2_dmanum++) {
		dmem_write((m2_sgr_base + 0x40 * m2_dmanum), (unsigned char *)(&buf0), sizeof(char) * 4);
		dmem_write((m2_dsr_base + 0x40 * m2_dmanum), (unsigned char *)(&buf0), sizeof(char) * 4);
	}

	//M1_STAT
	unsigned int buf1 = 0x00002222;
	for (m1_corenum = 0; m1_corenum < 4; m1_corenum++) {
		dmem_write((m1_stat_base + 0x100000 * m1_corenum), (unsigned char *)(&buf1), sizeof(char) * 4);
	}

	//M2_STAT                                                                                    
	unsigned int buf2 = 0x22222222;
	dmem_write(m2_stat_base, (unsigned char *)(&buf2), sizeof(char) * 4);
}
