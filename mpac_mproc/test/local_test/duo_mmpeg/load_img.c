#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

void (*start_simulator)(void);

int load_image(char *filename, unsigned long addr)
{
	int fd, ret;
	char *p;

	p = (char *)addr;

	fd = open(filename, O_RDONLY);
	if (fd < 0) {
		printf("can't open load_image file\r\n");
		return -1;
	}

	while (1) {
		ret = read(fd, p, 200);
		if (ret <= 0) {
			break;
		}
		p += 200;
	}
	if (ret < 0) {
		printf("can't read load_image_file \r\n");
		return -1;
	}

	return 0;
}

void run_image(unsigned long addr)
{
	start_simulator = (void *)addr;
	(*start_simulator)();
}
