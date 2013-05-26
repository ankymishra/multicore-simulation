#ifdef WIN32
#include "string.h"
#include "stdio.h"
#include "stdlib.h"
#include "winsock2.h"
#else
#include "sys/socket.h"
#include "netinet/in.h"
#include "arpa/inet.h"

#include "string.h"
#include "stdio.h"
#include "stdlib.h"
#include "unistd.h"
#endif
#include "debug-interface.h"

#define FILE_NAMESIZE   128
#define PAGE_SIZE       4096

#define DSPNUM		4
#ifdef WIN32
extern SOCKET connectfd;
#else
extern int connectfd;
#endif

#include "pac-profiling.h"
struct core_reason core_stop[DSPNUM];
int read_socket(int fd, unsigned char *buf, int len)
{
	int n;
	int buflen = len;

	while(1) {
		n = recv(fd, reinterpret_cast<char *>(buf), buflen, 0);
		
		if(n > 0) {
			buf += n;
			buflen -= n;
			if(buflen == 0)
				return len;
		} else 
			return n;
	}
}

int get_response(struct pac_soc_response *resp)
{
	int ret;
	ret = read_socket(connectfd, (unsigned char *)resp, sizeof(struct pac_soc_response));

#if 0
	if(ret == sizeof(pac_soc_response)) 
		printf("resp.ret %d resp.len %d \n",resp->ret, resp->len);
	else 
		printf("client close/error socket.\r\n");
#endif

	return resp->ret;
}

int gdb_set_pc_addr(int core_id, unsigned int pc)
{
	int write_len;
	struct pac_soc_cmd soc_cmd;
	struct pac_soc_response resp;

	soc_cmd.cmd_code = GDB_ICE_SET_PC_ADDR;
	soc_cmd.set_pc.addr = pc;
	soc_cmd.set_pc.core_id = core_id;

	write_len = send(connectfd, reinterpret_cast<char *>(&soc_cmd), sizeof(soc_cmd), 0);
	
	if (write_len > 0)  {
		if(get_response(&resp) == 0)
			return 0;
	} 
		
	return -1;
}

int gdb_ice_get_id(void)
{
	int write_len;
	struct pac_soc_cmd soc_cmd;
	struct pac_soc_response resp;

	soc_cmd.cmd_code = GDB_ICE_GET_ID;

	write_len = send(connectfd, reinterpret_cast<char *>(&soc_cmd), sizeof(soc_cmd), 0);
	
	if (write_len > 0)  {
		if(get_response(&resp) == 0)
			return 0;
	} 
		
	return -1;
}

int gdb_ice_init(BODY body, char **argv)
{
	int write_len;
	struct pac_soc_cmd soc_cmd;
	struct pac_soc_response resp;

	soc_cmd.cmd_code = GDB_ICE_INIT;
	soc_cmd.init.core_mask = body.core_bit_map;
	for (unsigned int i = 0; i < DSPNUM; i++) {
		if (soc_cmd.init.core_mask & (1 << i)) {
			core_stop[i].active_core = 0;
			core_stop[i].have_reported = 0;
			core_stop[i].reason = STOP_TRAP;
		}
	}

	write_len = send(connectfd, reinterpret_cast<char *>(&soc_cmd), sizeof(soc_cmd), 0);

	body.core0.prog_start_addr = 0x30000000;
	body.core1.prog_start_addr = 0x30080000;
	body.core2.prog_start_addr = 0x30100000;
	body.core3.prog_start_addr = 0x30180000;
	
	if (write_len > 0)  {
		if(get_response(&resp) == 0) {
			if (body.core_bit_map & 0x1) {
				gdb_set_pc_addr(0, body.core0.prog_start_addr);
			}

			if (body.core_bit_map & 0x2) {
				gdb_set_pc_addr(1, body.core1.prog_start_addr);
			}
	
			if (body.core_bit_map & 0x4) {
				gdb_set_pc_addr(2, body.core2.prog_start_addr);
			}

			if (body.core_bit_map & 0x8) {
				gdb_set_pc_addr(3, body.core3.prog_start_addr);
			}
			return 0;
		}
	}

	return -1;
}

int gdb_ice_exit(int core_bit_map)
{
	int write_len;
	struct pac_soc_cmd soc_cmd;
	struct pac_soc_response resp;

	soc_cmd.cmd_code = GDB_ICE_EXIT;
	soc_cmd.exit.core_mask = core_bit_map;

	write_len = send(connectfd, reinterpret_cast<char *>(&soc_cmd), sizeof(soc_cmd), 0);

	if (write_len > 0) {
		if (get_response(&resp) == 0) 
		{
#ifndef WIN32
			close(connectfd);
#else
			WSACleanup();
#endif
			return 0;
		}
	} 
#ifndef WIN32
	close(connectfd);
#else
    	WSACleanup();
#endif
	return -1;
}

int gdb_ice_write_mem(unsigned int addr, unsigned char *buf, int len)
{
	int write_len;
	struct pac_soc_cmd soc_cmd;
	struct pac_soc_response resp;

	int shm_size = PAGE_SIZE - FILE_NAMESIZE;
	soc_cmd.cmd_code = GDB_ICE_WRITE_MEM;
	int i = 0;
	while(1) {
		soc_cmd.write_mem.addr = addr + i*shm_size;
		soc_cmd.write_mem.len = len > shm_size ? shm_size : len;
		write_len = send(connectfd, reinterpret_cast<char *>(&soc_cmd), sizeof(soc_cmd), 0);

		if (write_len > 0) {
			if (get_response(&resp) == 0) {
				write_len = send(connectfd, reinterpret_cast<char *>(buf+i*shm_size), soc_cmd.write_mem.len, 0);
				if (write_len > 0) {
					get_response(&resp);
				} 
				len -= soc_cmd.write_mem.len;
				i++;
				if (len <= 0)
					return 0;
			}
		} 
	}
	return -1;
}

int gdb_ice_read_mem(unsigned int addr, unsigned char *buf, int len)
{
	int write_len;
	int ret;
	struct pac_soc_cmd soc_cmd;
	struct pac_soc_response resp;

	int shm_size = PAGE_SIZE - FILE_NAMESIZE;
	soc_cmd.cmd_code = GDB_ICE_READ_MEM;
	printf("soc_cmd.read_mem.len %d\r\n",len);

	int i = 0;
	while(1) {
		soc_cmd.read_mem.addr = addr + i*shm_size;
		soc_cmd.read_mem.len = len > shm_size ? shm_size : len;

		printf("soc_cmd.read_mem.addr 0x%08x \r\n",soc_cmd.read_mem.addr);
		write_len = send(connectfd, reinterpret_cast<char *>(&soc_cmd), sizeof(soc_cmd), 0);

		if (write_len > 0) {
			if (get_response(&resp) == 0) {
				ret = read_socket(connectfd, (unsigned char *)(buf + i*shm_size), resp.len);
				if (ret != resp.len) {
					return -1;
				}
				len -= soc_cmd.write_mem.len;
				i++;
				if (len <= 0)
					return 0;
			}
		} 
	}
	return -1;
}

int gdb_ice_write_data_reg(int regno, unsigned char *buf)
{
	int write_len;
	struct pac_soc_cmd soc_cmd;
	struct pac_soc_response resp;

	soc_cmd.cmd_code = GDB_ICE_WRITE_DATA_REG;
	soc_cmd.write_reg.regno = regno;
	soc_cmd.write_reg.value_h = *(long *)buf;
	soc_cmd.write_reg.value_l = *(long *)(buf+4);

	write_len = send(connectfd, reinterpret_cast<char *>(&soc_cmd), sizeof(soc_cmd), 0);

	if (write_len > 0) {
		if (get_response(&resp) == 0) 
			return 0;
	} 
	return -1;
}

int gdb_ice_read_data_reg(int regno, unsigned char *buf)
{
	int write_len;
	int ret;
	struct pac_soc_cmd soc_cmd;
	struct pac_soc_response resp;

	soc_cmd.cmd_code = GDB_ICE_READ_DATA_REG;
	soc_cmd.read_reg.regno = regno;

	write_len = send(connectfd, reinterpret_cast<char *>(&soc_cmd), sizeof(soc_cmd), 0);

	if (write_len > 0) {
		if (get_response(&resp) == 0) {
			ret = read_socket(connectfd, (unsigned char *)buf, 8);
			if (ret == 8) {
				printf("%x\n", *(unsigned int*)buf);
				return 0;
			}
		}
	} 
	return -1;
}

int gdb_ice_reset(start_prog_addr addr, int core_bit_map)
{
	int write_len;
	struct pac_soc_cmd soc_cmd;
	struct pac_soc_response resp;

	soc_cmd.cmd_code = GDB_ICE_RESET;
	soc_cmd.reset.core_mask = core_bit_map;
	for (unsigned int i = 0; i < DSPNUM; i++) {
		if (soc_cmd.reset.core_mask & (1 << i)) {
			core_stop[i].active_core = 0;
			core_stop[i].have_reported = 0;
			core_stop[i].reason = STOP_TRAP;
		}
	}

	write_len = send(connectfd, reinterpret_cast<char *>(&soc_cmd), sizeof(soc_cmd), 0);
	if (write_len > 0) {
		if (get_response(&resp) == 0) {
			if (core_bit_map & 0x1) {
				gdb_set_pc_addr(0, addr.core0_prog_start_addr);
			}

			if (core_bit_map & 0x2) {
				gdb_set_pc_addr(1, addr.core1_prog_start_addr);
			}
	
			if (core_bit_map & 0x4) {
				gdb_set_pc_addr(2, addr.core2_prog_start_addr);
			}

			if (core_bit_map & 0x8) {
				gdb_set_pc_addr(3, addr.core3_prog_start_addr);
			}

			return 0;
		}
	}
		
	return -1;
}

int gdb_ice_run(int core_bit_map)
{
	int write_len;
	int i, ret = 0;
	struct pac_soc_cmd soc_cmd;
	struct pac_soc_response resp;
	
	soc_cmd.cmd_code = GDB_ICE_RUN;
	soc_cmd.run.core_mask = core_bit_map;

	for (i = 0; i < DSPNUM; i++) {
		if (soc_cmd.run.core_mask & (1 << i)) {
			if (core_stop[i].have_reported == 1) {
				soc_cmd.run.core_mask &= ~(1 << i);
			}
		}
	}

	write_len = send(connectfd, reinterpret_cast<char *>(&soc_cmd), sizeof(soc_cmd), 0);

	if (write_len > 0) {
        	ret = get_response(&resp);
		if (ret == 0) {
			return 0;
	        } else if (ret == 1) {
			return 1;
	        }
	}
	return -1;
}

int gdb_ice_step(int step, int core_bit_map)
{
	int write_len, ret;
	int i;
	struct pac_soc_cmd soc_cmd;
	struct pac_soc_response resp;

	soc_cmd.cmd_code = GDB_ICE_STEP;
	soc_cmd.step.step = step;
	soc_cmd.step.core_mask = core_bit_map;

	for (i = 0; i < DSPNUM; i++) {
		if (soc_cmd.step.core_mask & (1 << i)) {
			if (core_stop[i].have_reported == 1) {
				soc_cmd.step.core_mask &= ~(1 << i);
			}
		}
	}

	write_len = send(connectfd, reinterpret_cast<char *>(&soc_cmd), sizeof(soc_cmd), 0);
	if (write_len > 0) {
		for (i = 0; i < DSPNUM; i++) {
			if (soc_cmd.step.core_mask & (1<< i)) {
				ret = get_response(&resp);
			}
	    } 
	}
	if (ret == 0)
		return 0;

	return -1;	
}

int gdb_ice_stop(int core_bit_map)
{
	int write_len;
	int i;
	struct pac_soc_cmd soc_cmd;
	struct pac_soc_response resp;

	soc_cmd.cmd_code = GDB_ICE_STOP;
	soc_cmd.stop.core_mask = core_bit_map;

	for (i = 0; i < DSPNUM; i++) {
		if (soc_cmd.stop.core_mask & (1 << i)) {
			if (core_stop[i].have_reported == 1) {
				soc_cmd.stop.core_mask &= ~(1 << i);
			}
		}
	}

	write_len = send(connectfd, reinterpret_cast<char *>(&soc_cmd), sizeof(soc_cmd), 0);

	if (write_len > 0) {
		if (get_response(&resp) == 0)
			return 0;
	} 
		
	return -1;	
}

int gdb_ice_stop_reason(enum STOP_REASON *reason, int *result, int core_bit_map, int *active_core_bit_map)
{
	int write_len;
	int ret;
	int i;
	struct pac_soc_cmd soc_cmd;
	struct pac_soc_response resp;

	soc_cmd.cmd_code = GDB_ICE_STOP_REASON;
	soc_cmd.reason.core_mask = core_bit_map;
	write_len = send(connectfd, reinterpret_cast<char *>(&soc_cmd), sizeof(soc_cmd), 0);

#if 0
	if (write_len > 0) {
		if (get_response(&resp) == 0) {
			ret = read_socket(connectfd, reinterpret_cast<unsigned char *>(active_core_bit_map), sizeof(int));
			if (ret == sizeof(int)) {
				//printf("%d \n",*active_core_bit_map);
				ret = read_socket(connectfd, reinterpret_cast<unsigned char *>(reason), resp.len);
				if (ret == resp.len) {
					return 0;
				}	
			}
		}
	}
#else
	if (write_len > 0) {
		if (get_response(&resp) == 0) {
			for (i = 0; i < DSPNUM; i++ ) {
				if (soc_cmd.reason.core_mask  & (1 << i)) {
					ret = read_socket(connectfd, reinterpret_cast<unsigned char *>(&core_stop[i].active_core), sizeof(int));
					if (ret == sizeof(int)) {
						ret = read_socket(connectfd, reinterpret_cast<unsigned char *>(&core_stop[i].reason), resp.len);
						if (ret != sizeof(enum STOP_REASON)) {
							return -1;
						}
						ret = read_socket(connectfd, reinterpret_cast<unsigned char *>(&core_stop[i].result), sizeof(int));
						if (ret != sizeof(int)) {
							return -1;
						}
					}
				}
			}
			
			for (i = 0; i < DSPNUM; i++ ) {
				if (soc_cmd.reason.core_mask  & (1 << i)) {
					if((soc_cmd.reason.core_mask & (1 << i)) && (core_stop[i].active_core)) {
						if ((core_stop[i].reason == STOP_EXIT) && (core_stop[i].have_reported != 1)) {
							*reason = core_stop[i].reason;
							*active_core_bit_map = i;
							*result = core_stop[i].result;
							core_stop[i].have_reported = 1;
							break;
						} else if ((core_stop[i].reason == STOP_EXIT) && (core_stop[i].have_reported == 1)) {
							continue;
						} else if (core_stop[i].reason == STOP_INT) {
							*reason = core_stop[i].reason;
							*active_core_bit_map = i;
							*result = core_stop[i].result;
							break;
						}
					}
					

					*reason = core_stop[i].reason;
					if (core_stop[i].active_core == 1) {
						*active_core_bit_map = i;
						*result = core_stop[i].result;
					}
#if 0
					if (core_stop[i].reason == STOP_INT) {
						*reason = core_stop[i].reason;
						*active_core_bit_map = i;	
					}
#endif

				}
			}
			return 0;
		}
	}
#endif
	
	return -1;
}

int gdb_ice_insert_bp(unsigned int addr)
{
	int write_len;
	struct pac_soc_cmd soc_cmd;
	struct pac_soc_response resp;

	soc_cmd.cmd_code = GDB_ICE_INSERT_BP;
	soc_cmd.insert_bp.addr = addr;

	write_len = send(connectfd, reinterpret_cast<char *>(&soc_cmd), sizeof(soc_cmd), 0);

	if (write_len > 0) {
		if (get_response(&resp) == 0)
			return 0;
	} 
		
	return -1;
}

int gdb_ice_remove_bp(unsigned int addr)
{
	int write_len;
	struct pac_soc_cmd soc_cmd;
	struct pac_soc_response resp;

	soc_cmd.cmd_code = GDB_ICE_REMOVE_BP;
	soc_cmd.remove_bp.addr = addr;

	write_len = send(connectfd, reinterpret_cast<char *>(&soc_cmd), sizeof(soc_cmd), 0);

	if (write_len > 0) {
		if( get_response(&resp) == 0)
			return 0;
	} 
		
	return -1;
}

int gdb_ice_insert_hard_bp(unsigned int addr, int core_bit_map)
{
	return 0;
}

int gdb_ice_remove_hard_bp(unsigned int addr, int core_bit_map)
{
	return 0;
}

int gdb_ice_insert_wp(unsigned int addr, int len, int type, int core_bit_map)
{
	int write_len;
	int i;
	struct pac_soc_cmd soc_cmd;
	struct pac_soc_response resp;
	int insert_wp_core_bit_map = core_bit_map;

	soc_cmd.cmd_code = GDB_ICE_INSERT_WP;
	soc_cmd.insert_wp.addr = addr;
	soc_cmd.insert_wp.len = len;

	for (i = 0; i < DSPNUM; i++) {
		if (insert_wp_core_bit_map & (1 << i)) {
			if (core_stop[i].have_reported == 1) {
				insert_wp_core_bit_map &= ~(1 << i);
			}		
		}
	}

	soc_cmd.insert_wp.type = type | insert_wp_core_bit_map << 24;

	write_len = send(connectfd, reinterpret_cast<char *>(&soc_cmd), sizeof(soc_cmd), 0);

	if (write_len > 0) {
		if (get_response(&resp) == 0)
			return 0;
	} 
		
	return -1;
}

int gdb_ice_remove_wp(unsigned int addr, int len, int type, int core_bit_map)
{
	int write_len;
	int i;
	int remove_wp_core_bit_map = core_bit_map;
	struct pac_soc_cmd soc_cmd;
	struct pac_soc_response resp;

	soc_cmd.cmd_code = GDB_ICE_REMOVE_WP;
	soc_cmd.remove_wp.addr = addr;
	soc_cmd.remove_wp.len = len;

	for (i = 0; i < DSPNUM; i++) {
		if (remove_wp_core_bit_map & (1 << i)) {
			if (core_stop[i].have_reported == 1) {
				remove_wp_core_bit_map &= ~(1 << i);
			}
		}
	}

	soc_cmd.remove_wp.type = type | remove_wp_core_bit_map << 24;

	write_len = send(connectfd, reinterpret_cast<char *>(&soc_cmd), sizeof(soc_cmd), 0);

	if (write_len > 0) {
		if (get_response(&resp) == 0)
			return 0;
	} 
		
	return -1;
}

int gdb_ice_dump_ice_regs(int core_bit_map)
{
	return 0;
}

int gdb_ice_kill(int core_bit_map)
{
	return 0;
}

int gdb_ice_dump_data_regs(int core_bit_map)
{
	return 0;
}

int gdb_ice_set_profiling_data(unsigned int start_pc, unsigned int end_pc, int core_id, long long date)
{
	int write_len;
	struct pac_soc_cmd soc_cmd;
	struct pac_soc_response resp;

	soc_cmd.cmd_code = GDB_ICE_SET_PROFILING_DATA;
	soc_cmd.set_profiling_data.start_pc = start_pc;
	soc_cmd.set_profiling_data.end_pc = end_pc;
	soc_cmd.set_profiling_data.core_id = core_id;
	soc_cmd.set_profiling_data.date = date;

	write_len = send(connectfd, reinterpret_cast<char *>(&soc_cmd), sizeof(soc_cmd), 0);
	
	if (write_len > 0)  {
		if(get_response(&resp) == 0)
			return 0;
	} 
		
	return -1;
}

int gdb_ice_get_profiling_dma_data(unsigned int start_pc, unsigned int end_pc, int core_id, unsigned char *buf, int len)
{
	int write_len, ret;
	struct pac_soc_cmd soc_cmd;
	struct pac_soc_response resp;

	soc_cmd.cmd_code = GDB_ICE_GET_PROFILING_DMA_DATA;
	soc_cmd.get_profiling_dma_data.start_pc = start_pc;
	soc_cmd.get_profiling_dma_data.end_pc = end_pc;
	soc_cmd.get_profiling_dma_data.core_id = core_id;
	soc_cmd.get_profiling_dma_data.len = len;

	write_len = send(connectfd, reinterpret_cast<char *>(&soc_cmd), sizeof(soc_cmd), 0);

	if (write_len > 0) {
		if (get_response(&resp) == 0) {
			ret = read_socket(connectfd, (unsigned char *)buf, resp.len);
			if (ret != resp.len)
				return -1;
		}
	}
	return 0;
}

int gdb_ice_get_profiling_cont_data(unsigned int start_pc, unsigned int end_pc, int core_id, unsigned char *buf, int len)
{
	int write_len, ret;
	struct pac_soc_cmd soc_cmd;
	struct pac_soc_response resp;

	soc_cmd.cmd_code = GDB_ICE_GET_PROFILING_CONTENTION_DATA;
	soc_cmd.get_profiling_cont_data.start_pc = start_pc;
	soc_cmd.get_profiling_cont_data.end_pc = end_pc;
	soc_cmd.get_profiling_cont_data.core_id = core_id;
	soc_cmd.get_profiling_cont_data.len = len;

	write_len = send(connectfd, reinterpret_cast<char *>(&soc_cmd), sizeof(soc_cmd), 0);

	if (write_len > 0) {
		if (get_response(&resp) == 0) {
			ret = read_socket(connectfd, (unsigned char *)buf, resp.len);
			if (ret != resp.len)
				return -1;
		}
	}
	return 0;
}

int gdb_ice_get_profiling_data(unsigned int start_pc, unsigned int end_pc, int core_id, unsigned char *buf, int len)
{
	int write_len, ret;
	struct pac_soc_cmd soc_cmd;
	struct pac_soc_response resp;

	if (((len) % sizeof(struct core_profiling_data)) != 0) {
		printf("len is not aligned to struct core_profiling_data type \r\n");
	}

	int shm_len =  (((PAGE_SIZE - FILE_NAMESIZE) / sizeof(struct core_profiling_data)) * sizeof(struct core_profiling_data));
	soc_cmd.cmd_code = GDB_ICE_GET_PROFILING_DATA;
	soc_cmd.get_profiling_data.start_pc = start_pc;
	soc_cmd.get_profiling_data.end_pc = end_pc;
	soc_cmd.get_profiling_data.core_id = core_id;

	int i = 0;
	while(1) {
		soc_cmd.get_profiling_data.len = len > shm_len ? shm_len : len;
		write_len = send(connectfd, reinterpret_cast<char *>(&soc_cmd), sizeof(soc_cmd), 0);
		if (write_len > 0) {
			if (get_response(&resp) == 0) {
				ret = read_socket(connectfd, (unsigned char *)(buf + i*shm_len), resp.len);
				if (ret != resp.len) {
					return -1;
				}
				len -= resp.len;
				i++;
				if (len <= 0) {
					return 0;
				}
			}
		} 
	}
	return -1;
}

int gdb_ice_get_profiling_head(unsigned int start_pc, unsigned int end_pc, int core_id)
{
	int write_len;
	struct pac_soc_cmd soc_cmd;
	struct pac_soc_response resp;

	soc_cmd.cmd_code = GDB_ICE_GET_PROFILING_HEAD;
	soc_cmd.get_profiling_head.start_pc = start_pc;
	soc_cmd.get_profiling_head.end_pc = end_pc;
	soc_cmd.get_profiling_head.core_id = core_id;

	write_len = send(connectfd, reinterpret_cast<char *>(&soc_cmd), sizeof(soc_cmd), 0);

	if (write_len > 0) {
		if (get_response(&resp) == 0) {
			return resp.len;
		}
	}
	return -1;
}
