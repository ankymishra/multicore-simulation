#ifndef _PAC_EXEC_VAR_H_
#define _PAC_EXEC_VAR_H_

void pac_exec_init();

unsigned char psr_read(unsigned char idx, unsigned char type);
unsigned char psr_read_addv(unsigned char idx, int dummy);
unsigned char psr_read_addc(unsigned char idx, int dummy);
void psr_write(unsigned char idx, unsigned char type, unsigned char data);
void psr_write_stage3(unsigned char idx, unsigned char type, unsigned char data);

void cp_gen(unsigned char *num, unsigned char *type);
unsigned char cp_read(unsigned char addr);

unsigned int regfile_read(unsigned char num, unsigned char type);
void regfile_write(unsigned char num, unsigned char type, unsigned int data);
void regfile_l_write(unsigned char num, unsigned char type, unsigned long long data);
unsigned long long regfile_l_read(unsigned char num, unsigned char type);
void regfile_update();
void update_p(unsigned int data, int stage);
void update_registerfile(int idx);

void stage2_l_write(unsigned char num, unsigned char type, unsigned long long data);
void stage3_l_write(unsigned char num, unsigned char type, unsigned long long data);
int  write_conflict_check(unsigned char type, unsigned char addr);

unsigned int detect_carry(unsigned long long uldst, unsigned long long ulsrc1, unsigned long long ulsrc2);
unsigned int detect_overflow8(unsigned int udst1, unsigned int udst2,
							  unsigned int udst3, unsigned int udst4,
							  unsigned int usrc1, unsigned int usrc2);
unsigned int detect_overflow8_sub(unsigned int udst1, unsigned int udst2,
								  unsigned int udst3, unsigned int udst4,
								  unsigned int usrc1, unsigned int usrc2);
unsigned int detect_overflow16(unsigned int udst1, unsigned int udst2,
							   unsigned int usrc1, unsigned int usrc2);
unsigned int detect_overflow16_sub(unsigned int udst1, unsigned int udst2,
								   unsigned int usrc1, unsigned int usrc2);
unsigned int detect_overflow(unsigned long long uldst, unsigned long long ulsrc1,
							 unsigned long long ulsrc2);
unsigned int detect_overflow_sub(unsigned long long uldst, unsigned long long ulsrc1,
								 unsigned long long ulsrc2);								   

void sc_addr_gen(inst_t * curinst);
unsigned int ls_addr_gen(inst_t * curinst);
unsigned int bit_reverse(unsigned int data, int width);

#endif
