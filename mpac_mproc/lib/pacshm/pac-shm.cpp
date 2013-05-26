#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/mman.h>
#include "unistd.h"
#include "string.h"
#include "mpac-mproc-define.h"
#include "pac-shm.h"

void *shm_create(char *name, unsigned int size, int flag)
{
	int fd, len;
	void *ptr;
	
	fd = shm_open(name, flag, 0666);
	if (fd < 0) {
		printf("can't open %s file\r\n",name);
		close(fd);
		exit(1);
	}
	
	len = ftruncate(fd, size);
	if (len < 0) {
		printf("can't ftruncate %s file %d size\r\n", name, size);
		exit(-1);
	}

	ptr = mmap(0, size, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
	if(ptr == MAP_FAILED) {
		printf("mmap %s fail. \r\n", name);
		exit(-1);
	}

	if (flag & O_CREAT) {
		memset(ptr, 0, size);
	}
	return ptr;
}

void shm_del(char *name)
{
	shm_unlink(name);
}
