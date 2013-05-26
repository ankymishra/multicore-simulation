#define HEX_FORMAT	0
#define OCT_FORMAT	1
#define DEC_FORMAT	2

#define BYTE_FORMAT	0
#define SHORT_FORMAT	1
#define LONG_FORMAT	2

extern void dump_memory(char *filename, unsigned long addr, unsigned long len, unsigned char format);
