#ifndef SC_PAC_MEMIF_DEF_H_INCLUDED
#define SC_PAC_MEMIF_DEF_H_INCLUDED

#ifdef PAC_2WAY_ICACHE_LINE
#define GROUP_WAY 2
struct icache_addr {
	unsigned int offset:8;
	unsigned int group:6;
	unsigned int line:1;
	unsigned int tag:17;
};

struct icache_flag {
	unsigned int invalid:1;
	unsigned int lru_count:7;
	unsigned int group:6;
	unsigned int line:1;
	unsigned int tag:17;
};
#elif PAC_4WAY_ICACHE_LINE
#define GROUP_WAY 4
struct icache_addr {
	unsigned int offset:8;
	unsigned int group:5;
	unsigned int line:2;
	unsigned int tag:17;
};

struct icache_flag {
	unsigned int invalid:1;
	unsigned int lru_count:7;
	unsigned int group:5;
	unsigned int line:2;
	unsigned int tag:17;
};

#elif PAC_8WAY_ICACHE_LINE
#define GROUP_WAY 8
struct icache_addr {
	unsigned int offset:8;
	unsigned int group:4;
	unsigned int line:3;
	unsigned int tag:17;
};

struct icache_flag {
	unsigned int invalid:1;
	unsigned int lru_count:7;
	unsigned int group:4;
	unsigned int line:3;
	unsigned int tag:17;
};
#endif

struct icache_line {
	struct icache_flag flag;
	unsigned char *insn;
};

struct icache_group {
	struct icache_line l1_icache_line[GROUP_WAY];
};

struct icache_replace {
	unsigned int max_lru_count;
	unsigned int block;
	unsigned int hit;
};

struct core_insnbuf {
	unsigned int addr;
	unsigned char buf[256];
};

#endif
