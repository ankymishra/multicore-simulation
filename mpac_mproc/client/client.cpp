
#ifdef WIN32
#include "string.h"
#include "stdio.h"
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

#include "pac-profiling.h"
#define BUFSIZE		128

#ifdef WIN32
SOCKET connectfd;
#else
int connectfd;
#endif

int profiling_len;

int process_cmd(int cmd_code)
{
	int ret, len, type, regno, value;
	int active_core_mask = 0;
	int core_mask,core_id;
	unsigned int v;
	int step;
	unsigned int addr, start_pc, end_pc;
	BODY body;
	char *p;
	enum STOP_REASON reason;

	switch(cmd_code) {
	case GDB_ICE_GET_ID:
		ret = gdb_ice_get_id();
		break;
	case GDB_ICE_INIT:
		printf("input gdb-init core_mask:\r\n");					scanf("%x", &v);	body.core_bit_map = v;	
		ret = gdb_ice_init(body, &p);
		break;
	case GDB_ICE_EXIT:
		printf("input gdb-exit core_mask:\r\n");					scanf("%x", &v);	core_mask = v;	
		ret = gdb_ice_exit(core_mask);	
		break;
	case GDB_ICE_WRITE_MEM:
		printf("input write-mem addr:\r\n");						scanf("%x", &v);	addr = v;
		printf("input write-mem value:\r\n");						scanf("%x", &v);	value = v;
		printf("input write-mem len:\r\n");							scanf("%x", &v);	len = v;
		ret = gdb_ice_write_mem(addr, reinterpret_cast<unsigned char*>(&value), len);
		break;
	case GDB_ICE_READ_MEM:
		printf("input read-mem addr:\r\n");							scanf("%x", &v);	addr = v;
		printf("input read-mem len:\r\n");							scanf("%x", &v);	len = v;
		unsigned char *mem_rd_buf;
		mem_rd_buf = (unsigned char *)malloc(sizeof(len));
		ret = gdb_ice_read_mem(addr, mem_rd_buf, len);	
		free(mem_rd_buf);
		break;
	case GDB_ICE_WRITE_DATA_REG:
		printf("input write-reg core_mask:\r\n");					scanf("%x", &v);	core_mask = v;
		printf("input write-reg regno:\r\n");						scanf("%x", &v);	regno = v;
		printf("input write-reg value:\r\n");						scanf("%x", &v);	value = v;
		regno = core_mask << 24 | regno;
		ret = gdb_ice_write_data_reg(regno, reinterpret_cast<unsigned char*>(&value));	
		break;
	case GDB_ICE_READ_DATA_REG:
		printf("input read-reg core_mask:\r\n");					scanf("%x", &v);	core_mask = v;
		printf("input read-reg regno:\r\n");						scanf("%x", &v);	regno = v;
		unsigned char *reg_rd_buf;
		reg_rd_buf = (unsigned char *)malloc(sizeof(len));
		regno = core_mask << 24 | regno;
		ret = gdb_ice_read_data_reg(regno, reinterpret_cast<unsigned char *>(&value));
		free(reg_rd_buf);
		break;
	case GDB_ICE_RESET:
		printf("input reset core_mask:\r\n");						scanf("%x", &v);	core_mask = v;
		start_prog_addr pc_addr;
		ret = gdb_ice_reset(pc_addr, core_mask);
		break;
	case GDB_ICE_RUN:
		printf("input gdb-run core_mask:\r\n");						scanf("%x", &v);	core_mask = v;
		ret = gdb_ice_run(core_mask);
		break;
	case GDB_ICE_STEP:
		printf("input gdb-step step:\r\n");							scanf("%x", &v);	step = v;
		printf("input gdb-step core_mask:\r\n");					scanf("%x", &v);	core_mask = v;
		ret = gdb_ice_step(step, core_mask);
		break;
	case GDB_ICE_STOP:
		printf("input gdb-stop core_mask:\r\n");					scanf("%x", &v);	core_mask = v;
		ret = gdb_ice_stop(core_mask);
		break;
	case GDB_ICE_STOP_REASON:
		printf("input gdb-stop-reason core_mask:\r\n");				scanf("%x", &v);	core_mask = v;
		ret = gdb_ice_stop_reason(&reason, &ret, core_mask, &active_core_mask);
		break;
	case GDB_ICE_INSERT_BP:
		printf("input insert break-point addr:\r\n");				scanf("%x", &v);	addr = v;
		ret = gdb_ice_insert_bp(addr);
		break;
	case GDB_ICE_REMOVE_BP:
		printf("input insert break-point addr:\r\n");				scanf("%x", &v);	addr = v;
		ret = gdb_ice_remove_bp(addr);
		break;
	case GDB_ICE_INSERT_HARD_BP:
		printf("input gdb-insert-hard-bp addr:\r\n");				scanf("%x", &v);	addr = v;
		printf("input gdb-insert-hard-bp core_mask:\r\n");			scanf("%x", &v);	core_mask = v;
		ret = gdb_ice_insert_hard_bp(addr, core_mask);
		break;
	case GDB_ICE_REMOVE_HARD_BP:
		printf("input gdb-remove-hard-bp addr:\r\n");				scanf("%x", &v);	addr = v;
		printf("input gdb-remove-hard-bp core_mask:\r\n");			scanf("%x", &v);	core_mask = v;
		ret = gdb_ice_remove_hard_bp(addr, core_mask);
		break;
	case GDB_ICE_INSERT_WP:
		printf("input insert watch-point addr:\r\n");				scanf("%x", &v);	addr = v;
		printf("input insert watch-point len:\r\n");				scanf("%x", &v);	len = v;
		printf("input insert watch-point type:\r\n");				scanf("%x", &v);	type = v;
		printf("input insert watch-point core_mask:\r\n");			scanf("%x", &v);	core_mask = v;
		ret = gdb_ice_insert_wp(addr, len, type, core_mask);
		break;
	case GDB_ICE_REMOVE_WP:
		printf("input remove watch-point addr:\r\n");				scanf("%x", &v);	addr = v;
		printf("input remove watch-point len:\r\n");				scanf("%x", &v);	len = v;
		printf("input remove watch-point type:\r\n");				scanf("%x", &v);	type = v;
		printf("input remove watch-point core_mask:\r\n");			scanf("%x", &v);	core_mask = v;
		ret = gdb_ice_remove_wp(addr, len, type, core_mask);	
		break;
	case GDB_ICE_DUMP_ICE_REGS:
		break;
	case GDB_ICE_KILL:
		break;
	case GDB_ICE_DUMP_DATA_REGS:
		break;
	case GDB_ICE_SET_PROFILING_DATA:
		long long date;
		printf("input set profiling start_pc:\r\n");				scanf("%x", &v);	start_pc = v;
		printf("input set profiling end_pc:\r\n");					scanf("%x", &v);	end_pc = v;
		printf("input set profiling core_id:\r\n");					scanf("%x", &v);	core_id = v;
		printf("input set profiling date:\r\n");                    scanf("%lld", &v);   date = v;
		ret = gdb_ice_set_profiling_data(start_pc, end_pc, core_id, date);
		break;	
	case GDB_ICE_GET_PROFILING_HEAD:
		printf("input set profiling start_pc:\r\n");				scanf("%x", &v);	start_pc = v;
		printf("input set profiling end_pc:\r\n");					scanf("%x", &v);	end_pc = v;
		printf("input set profiling core_id:\r\n");					scanf("%x", &v);	core_id = v;
		profiling_len = gdb_ice_get_profiling_head(start_pc, end_pc, core_id);	
		printf("profiling len %d\r\n", profiling_len);
		ret = 0;
		break;
	case GDB_ICE_GET_PROFILING_DATA:
		printf("input get profiling start_pc:\r\n");				scanf("%x", &v);	start_pc = v;
		printf("input get profiling end_pc:\r\n");					scanf("%x", &v);	end_pc = v;
		printf("input get profiling core_id:\r\n");					scanf("%x", &v);	core_id = v;
		unsigned char *profiling_buf; 
		profiling_buf = (unsigned char *)malloc((profiling_len));
		ret = gdb_ice_get_profiling_data(start_pc, end_pc, core_id, profiling_buf, profiling_len);
		free(profiling_buf);
		break;
	case GDB_ICE_GET_PROFILING_DMA_DATA:
		printf("input get profiling start_pc:\r\n");				scanf("%x", &v);	start_pc = v;
		printf("input get profiling end_pc:\r\n");					scanf("%x", &v);	end_pc = v;
		printf("input get profiling core_id:\r\n");					scanf("%x", &v);	core_id = v;
		unsigned char *profiling_dma_buf;
		profiling_dma_buf = (unsigned char *)malloc(3 * sizeof(struct dma_profiling_data));
		ret = gdb_ice_get_profiling_dma_data(start_pc, end_pc, core_id, profiling_dma_buf, 3*sizeof(struct dma_profiling_data));
		free(profiling_dma_buf);
		break;
	case GDB_ICE_GET_PROFILING_CONTENTION_DATA:
		printf("input get profiling start_pc:\r\n");				scanf("%x", &v);	start_pc = v;
		printf("input get profiling end_pc:\r\n");					scanf("%x", &v);	end_pc = v;
		printf("input get profiling core_id:\r\n");					scanf("%x", &v);	core_id = v;
		unsigned char *profiling_cont_buf;
		profiling_cont_buf = (unsigned char *)malloc(sizeof(struct contention_profiling_data));
		ret = gdb_ice_get_profiling_cont_data(start_pc, end_pc, core_id, profiling_cont_buf, sizeof(struct contention_profiling_data));
		free(profiling_cont_buf);
		break;	
	default:
		printf("Error Cmd\n");
	}
	return ret; 
}

int main(int argc, char **argv)
{
	int cmd_code;
	int v;

#if 0
	if (argc < 2) {
		printf("client_main <ip_address> <string>.\r\n");
		exit(1);
	}
#endif

#ifdef WIN32
	WSADATA wsaData;
	WSAStartup(MAKEWORD(2,2), &wsaData);
	connectfd = socket(AF_INET, SOCK_STREAM, 0);

	if(connectfd == INVALID_SOCKET) {
		printf("socket error\r\n");
	}
	
	sockaddr_in sin;
	sin.sin_addr.s_addr = inet_addr("172.20.45.95");
	sin.sin_family = AF_INET;
	sin.sin_port = htons(PAC_SOC_SERVER_PORT);
	int icnn = connect(connectfd, (sockaddr*)&sin, sizeof(sin));
	if (icnn == SOCKET_ERROR) {
		printf("can't connect\r\n");
	}	
#else
	
	struct sockaddr_in serveraddr;

	connectfd = socket(AF_INET, SOCK_STREAM, 0);
	printf("client connectedfd %d\n",connectfd);

	memset(&serveraddr, 0, sizeof(serveraddr));
	serveraddr.sin_family = AF_INET;
	serveraddr.sin_port = htons(PAC_SOC_SERVER_PORT);

	inet_pton(AF_INET, argv[1], &serveraddr.sin_addr);

	connect(connectfd, (struct sockaddr *)&serveraddr, sizeof(serveraddr));
#endif

	while(1) {
		printf("input cmd no:\r\n");	scanf("%d", &v);	cmd_code = v;
		
		if (process_cmd(cmd_code) == 0)
			printf("succ\n");
		else
			printf("fail\n");
	}

#ifdef WIN32
	WSACleanup();
#else
	close(connectfd);
#endif

	return 0;
}
