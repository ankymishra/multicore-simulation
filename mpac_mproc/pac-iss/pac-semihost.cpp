#include "pac-dsp.h"
#include "mpac-mproc-define.h"
#include "sc-pac-memif.h"

void pac_dsp::pac_semihost_init()
{
	fp_buf[0] = stdin;
	fp_buf[1] = stdout;
	fp_buf[2] = stderr;
	fp_free = 4;
	fp_count = 0;
}

int pac_dsp::syscall_proc()
{
	int sc_no = 0;
	FILE *fp;
	char ch;
	int fd;
	char m[32];
	int mode;
	int res;
	int len;
	char buffer[SIZE];
	clock_t value;
	time_t lt;
	int i;
	char *pbuf;
	unsigned int ptr;
	char buffer1[SIZE];
	struct timeval tv;
	struct timezone tz;

	soc_read_reg(58, (unsigned char *) &sc_no);	// Cluser2 D2

	switch (sc_no) {	//Cluser2 D2
	case SYS_UNLINK:
		len = 0;
		soc_read_reg(PARAM_1, (unsigned char *) &ptr);
		do {
			sc_pac_memif_ptr_0->dbg_dmem_read(ptr, (unsigned char *) &ch, 1);
			buffer[len] = ch;
			len++;
			ptr += 1;
		} while (ch != '\0' && len < (SIZE - 1));
		buffer[len] = '\0';

		res = unlink(buffer);
		soc_write_reg(RES_R, (unsigned char *) &res);
		break;
	case SYS_LINK:
		len = 0;
		soc_read_reg(PARAM_1, (unsigned char *) &ptr);
		do {
			sc_pac_memif_ptr_0->dbg_dmem_read(ptr, (unsigned char *) &ch, 1);
			buffer[len] = ch;
			len++;
			ptr += 1;
		} while (ch != '\0' && len < (SIZE - 1));
		buffer[len] = '\0';

		len = 0;
		soc_read_reg(PARAM_2, (unsigned char *) &ptr);
		do {
			sc_pac_memif_ptr_0->dbg_dmem_read(ptr, (unsigned char *) &ch, 1);
			buffer1[len] = ch;
			len++;
			ptr += 1;
		} while (ch != '\0' && len < (SIZE - 1));
		buffer1[len] = '\0';

		res = link(buffer, buffer1);
		soc_write_reg(RES_R, (unsigned char *) &res);
		break;
	case SYS_GETTIMEOFDAY:
		res = gettimeofday(&tv, &tz);
		soc_read_reg(PARAM_1, (unsigned char *) &ptr);
		sc_pac_memif_ptr_0->dbg_dmem_write(ptr, (unsigned char *) &tv, sizeof(struct timeval));
		soc_write_reg(RES_R, (unsigned char *) &res);
		break;
	case SYS_TIME:
		lt = time(NULL);
		value = clock();
		//res = user_get_tick();
		soc_write_reg(59, (unsigned char *) &value);
		soc_write_reg(19, (unsigned char *) &lt);
		soc_write_reg(17, (unsigned char *) &res);
		break;
	case SYS_WRITE:
		soc_read_reg(PARAM_1, (unsigned char *) &fd);
		soc_read_reg(PARAM_2, (unsigned char *) &ptr);
		soc_read_reg(PARAM_3, (unsigned char *) &len);

		res = -1;
		if (!len) {
			res = 0;
			soc_write_reg(RES_R, (unsigned char *) &res);
			break;
		}

		pbuf = (char *) malloc(len + 1);
		if (pbuf == NULL) {
			printf("Internal error : memory not enough !");
			soc_write_reg(RES_R, (unsigned char *) &res);
			break;
		}
		sc_pac_memif_ptr_0->dbg_dmem_read(ptr, (unsigned char *) pbuf, len);
		pbuf[len] = '\0';
#if 1
		if ((fd < FP_MAX) && (fp_buf[fd] != NULL)) {
			res = fwrite(pbuf, 1, len, fp_buf[fd]);
			fflush(fp_buf[fd]);
		}
#else
		printf("%s : %s", this->name(), pbuf);
#endif
		free(pbuf);
		soc_write_reg(RES_R, (unsigned char *) &res);
		break;
	case SYS_READ:
		soc_read_reg(PARAM_1, (unsigned char *) &fd);
		soc_read_reg(PARAM_2, (unsigned char *) &ptr);
		soc_read_reg(PARAM_3, (unsigned char *) &len);
		res = -1;
		if (!len) {
			res = 0;
			soc_write_reg(RES_R, (unsigned char *) &res);
			break;
		}
		pbuf = (char *) malloc(len + 1);
		if (pbuf == NULL) {
			printf("Internal error : memory not enough !");
			soc_write_reg(RES_R, (unsigned char *) &res);
			break;
		}

		for (i = 0; i < (len + 1); i++) {
			pbuf[i] = 0;
		}

		if (fd >= FP_MAX) {
			res = -1;	//printf("invalidate FILE pointer %d !\n",fd);
		} else if (fd > 3 && fp_buf[fd] == NULL) {
			res = -1;
			printf("File closed !");
		} else {
			if (fp_buf[fd] == stdin) {
				fgets(pbuf, len, stdin);
				res = strlen(pbuf);
			} else {
				res = fread(pbuf, 1, len, fp_buf[fd]);
			}

			sc_pac_memif_ptr_0->dbg_dmem_write(ptr, (unsigned char *) pbuf, len);
		}
		free(pbuf);
		soc_write_reg(RES_R, (unsigned char *) &res);
		break;

	case SYS_OPEN:
		len = 0;
		soc_read_reg(PARAM_1, (unsigned char *) &ptr);
		soc_read_reg(PARAM_2, (unsigned char *) &mode);
		if (fp_count >= FP_MAX) {
			printf
				("Too many file be opened !, only %d file can be opened at same time!",
				 FP_MAX);
			break;
		}
		do {
			sc_pac_memif_ptr_0->dbg_dmem_read(ptr, (unsigned char *) &ch, 1);
			buffer[len] = ch;
			len++;
			ptr += 1;
		} while (ch != '\0' && len < (SIZE - 1));
		buffer[len] = '\0';
		len = 0, res = sizeof(m);
		switch (mode & 0x3) {
		case NLIB_O_RDONLY:
			if (mode & NLIB_O_CREAT) {
				fp = fopen(buffer, "w");
				if (fp != NULL)
					fclose(fp);
			}
			len += snprintf(m + len, res - len, "rb");
			break;
		case NLIB_O_WRONLY:
			len += snprintf(m + len, res - len, "wb");
			if (mode & NLIB_O_APPEND) {
				len = 0;
				len += snprintf(m + len, res - len, "ab");
			}
			break;
		case NLIB_O_RDWR:
			if (mode & NLIB_O_CREAT) {
				fp = fopen(buffer, "w");
				if (fp != NULL)
					fclose(fp);
			}
			if ((mode & NLIB_O_CREAT) && (mode & NLIB_O_TRUNC))
				len += snprintf(m + len, res - len, "wb+");
			else
				len += snprintf(m + len, res - len, "rb+");
			if (mode & NLIB_O_APPEND) {
				len = 0;
				len += snprintf(m + len, res - len, "ab+");
			}
			break;
		default:
			printf("mode %8x\n", mode & 0x3);
			return RET_FAIL;
		}
		fp = fopen(buffer, m);
		if (fp == NULL) {
			res = -1;
			soc_write_reg(RES_R, (unsigned char *) &res);
			break;
		} else {
			fp_buf[fp_free] = fp;
			fp_count++;
			soc_write_reg(RES_R, (unsigned char *) &fp_free);
			for (i = 4; i < FP_MAX; i++) {
				if (fp_buf[i] == NULL) {
					fp_free = i;
					break;
				}
			}
		}
		break;
	case SYS_CLOSE:
		soc_read_reg(PARAM_1, (unsigned char *) &fd);
		res = 0;
		if (fd > 3 && fd < FP_MAX) {
			res = fclose(fp_buf[fd]);
			fp_buf[fd] = NULL;
			fp_free = fd;
		} else if (fd < 3) {
			res = fflush(fp_buf[fd]);
		}
		soc_write_reg(RES_R, (unsigned char *) &res);
		break;
	case SYS_LSEEK:
		soc_read_reg(PARAM_1, (unsigned char *) &fd);
		soc_read_reg(PARAM_2, (unsigned char *) &ptr);
		soc_read_reg(PARAM_3, (unsigned char *) &len);
		if (fd > FP_MAX) {
			printf("Invalidate FILE pointer ! %d ", fd);
			break;
		}
		fp = fp_buf[fd];
		res = -1;
		switch (len) {
		case NLIB_SEEK_SET:
			if (!(res = fseek(fp, ptr, SEEK_SET)))
				res = ftell(fp);
			break;
		case NLIB_SEEK_CUR:
			if (!(res = fseek(fp, ptr, SEEK_CUR)))
				res = ftell(fp);
			break;
		case NLIB_SEEK_END:
			if (!(res = fseek(fp, ptr, SEEK_END)))
				res = ftell(fp);
			break;

		default:
			res = -1;
			break;
		}
		soc_write_reg(RES_R, (unsigned char *) &res);
		break;
	default:
		//  res = -1;
		//  soc_write_reg(RES_R, (unsigned char*)&res);
		break;

	}

	return RET_SUCCESS;
}
