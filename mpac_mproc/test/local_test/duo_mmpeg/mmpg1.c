#include "load_img.h"
#include "dump.h"

#define BIN_FILE	"simulation/mpeg2_decoder.bin"
#define BIN2_FILE	"simulation/mpeg2_decoder_1.bin"
#define BIT_FILE	"simulation/test1.mpeg2"
#define BIN_ADDR	0x30100000
#define BIN2_ADDR	0x30180000
#define BIT_ADDR	0x31000000
#define DUMP_FILE	"/tmp/dump.file"

int main(int argc, char *argv[])
{
	unsigned int *p;
	int ret;

#if 0	
	p = (unsigned int *)0x24000110;
	*p = 0x31000000;

	p = (unsigned int *)0x24000114;
	*p = 0xa1dc;

	p = (unsigned int *)0x24001f14;
	*p = 0x33a00000;

	p = (unsigned int *)0x24001f18;
	*p = 0x33d00000;

	p = (unsigned int *)0x24001f00;
	*p = 0x33000000;
#endif
	//my_mdelay(200);
	
	ret = load_image(BIN2_FILE, BIN2_ADDR);
	if (ret < 0) {
		printf("load image error!\r\n");
		exit(-1);
	}

	//ret = load_image(BIT_FILE, BIT_ADDR);
	//if (ret < 0) {
	//	printf("load image error!\r\n");
	//	exit(-1);
	//}

	printf("start jump core1\r\n");

#if 0
	p = (unsigned int *)0x30fff804;
	*p = 0x0;

	p = (unsigned int *)0x30fff808;
	*p = 0xa1dc;

	p = (unsigned int *)0x30fff80c;
	*p = 0x31000000;

	p = (unsigned int *)0x30fff800;
	*p = 0x0000abcd;
#endif

	run_image(BIN2_ADDR);

	//dump_memory(DUMP_FILE, 0x33d00000, 128, HEX_FORMAT << 4 | LONG_FORMAT);
}
