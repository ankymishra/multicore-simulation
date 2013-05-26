#include <stdio.h>
#include <string.h>
#include "dump.h"

unsigned char dest[128];
void dump_memory(char *filename, unsigned long start_addr, unsigned long len, unsigned char format)
{
	FILE *fp;
	int dump_fmt, show_fmt;
	unsigned long length = len;
	int i = 0;

	dump_fmt = format >> 4;
	show_fmt = format & 0x0f;
	
	fp = fopen(filename, "wb");
	if (fp == NULL) {
		printf("can't open dump file\r\n");
		exit(-1);
	}

	switch (dump_fmt) {
		case HEX_FORMAT:
			for(i = 0; i < (int)(length/16); i++) {
				fprintf(fp, "0x%08x: %08x %08x %08x %08x\n", start_addr, *(unsigned int*)start_addr, 
					*(unsigned int*)(start_addr+4), *(unsigned int*)(start_addr+8), *(unsigned int*)(start_addr+12));

				start_addr += 16;
			}
			break;
		case OCT_FORMAT:
			for(i = 0; i < length/16; i++) {
				fprintf(fp, "0x%08x: %o %o %o %o\n", start_addr, *(unsigned int*)start_addr, 
					*(unsigned int*)(start_addr+4), *(unsigned int*)(start_addr+8), *(unsigned int*)(start_addr+12));

				start_addr += 16;
			}
			break;
		case DEC_FORMAT:
			for(i = 0; i < length/16; i++) {
				fprintf(fp, "0x%08x: %d %d %d %d\n", start_addr, *(unsigned int*)start_addr, 
					*(unsigned int*)(start_addr+4), *(unsigned int*)(start_addr+8), *(unsigned int*)(start_addr+12));

				start_addr += 16;
			}
			break;
		default:
			break;
	}
	printf("dump finish\r\n");
	fclose(fp);
//	free(dest);
}
