#include "stdio.h"
#include "string.h"
#include "stdlib.h"
#include "pac-cfu.h"

unsigned short sr4_55_memcpy(unsigned char func_id, unsigned short *func_base)
{
	unsigned char *buf;
	printf("func_id = %d.\r\n", func_id);
	printf("func_base = 0x%08x \r\n", (unsigned int)func_base);

	buf = (unsigned char *)malloc(256);
	memset(buf, '\0', 256);

	memcpy(buf, ddr_ptr, 128);
	return 0;
}

