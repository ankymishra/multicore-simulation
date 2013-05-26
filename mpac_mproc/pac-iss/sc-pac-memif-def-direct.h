#ifndef SC_PAC_MEMIF_DEF_H_INCLUDED
#define SC_PAC_MEMIF_DEF_H_INCLUDED

struct icache_addr {
	unsigned int offset:8;
	unsigned int index:7;
	unsigned int tag:17;
};

struct icache_flag {
	unsigned int invalid:8;
	unsigned int index:7;
	unsigned int tag:17;
};

struct icache_line {
	struct icache_flag flag;
	unsigned char *insn;
};

struct core_insnbuf {
	unsigned int addr;
	unsigned char buf[256];
};

#endif
