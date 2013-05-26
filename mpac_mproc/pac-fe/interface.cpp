#include <stdlib.h>
#include <sys/types.h>
#include <linux/unistd.h>
#include "pthread.h"

#include "mpac-mproc-define.h"
#include "debug-interface.h"
#include "pac-gdb-server.h"
#include "pac-issshm-prot.h"

#undef DEBUG
//#define DEBUG 1

#ifdef DEBUG
#define dprintf(x...)	printf(x)
#else
#define dprintf(x...)		
#endif

int process_soc_cmd(int pthread_no, struct pac_soc_cmd *soc_cmd);

int pthread_num = 0;
struct pthread_information pthread_info[DSPNUM];

// return sizeof(struct pac_soc_cmd)>0 succ, 0/-1 fail
int read_socket(int fd, unsigned char *buf, int len)
{
	int n;
	int buflen = len;

	while(1) {
		n = recv(fd, buf, buflen, 0);
		
		if(n > 0) {
			buf += n;
			buflen -= n;
			if(buflen == 0)
				return len;
		} else 
			return n;
	}
}

// write to iss fifo, wait for response. 0 succ, 1 fail
int iss_cmd_request(int core_id, char cmd)
{
	int len;

	len = write(iss_rela[core_id].gdb_iss_wr_fifo_fd, &cmd, 1);
	if (len < 0)
		printf("pac_gdb_server iss_cmd_request to core %d fail.\r\n", core_id);

	len = read (iss_rela[core_id].gdb_iss_rd_fifo_fd, &cmd, 1);
	if (len < 0) {
		printf("pac_gdb_server iss_cmd read core %d fail.\r\n", core_id);
		return -1;
	} else if (cmd != '0') {
		if (cmd == '2') {
			return 1;
		} else {
			printf("pac_gdb_server iss_cmd resp core %d fail.\r\n", core_id);
			return -1;
		}
	}
	return 0;
}

// 0 succ, 1 fail
int gdb_response(int pthread_no, struct pac_soc_response *resp)
{
	int len;

	len = send(pthread_info[pthread_no].gdb_fd, resp, sizeof(*resp), 0);

	if (len == -1)
		return -1;
	else
		return 0;
}

int pac_soc_get_id(int pthread_no, struct pac_soc_cmd *soc_cmd)
{
	return 0;
}

int pac_soc_init_cmd(int pthread_no, struct pac_soc_cmd *soc_cmd)
{
	char cmd = GDB_ICE_INIT;
	struct pac_soc_response resp = {0, 0};

	pthread_info[pthread_no].core_mask = soc_cmd->init.core_mask;

	for (int i = 0; i < DSPNUM; i++) {
		if (soc_cmd->init.core_mask & (1 << i)) {
			iss_rela[i].iss_shm_prot_ptr->flag = ISS_STOP;
			iss_rela[i].iss_shm_prot_ptr->cmd.cmd_code = cmd;
			iss_cmd_request(i, cmd);
		}
	}

	return gdb_response(pthread_no, &resp);
}

int pac_soc_exit_cmd(int pthread_no, struct pac_soc_cmd *soc_cmd)
{
	char cmd = GDB_ICE_EXIT;
	struct pac_soc_response resp = {0, 0};
	dprintf("PAC_SOC_EXIT core_mask %d\r\n",pthread_info[pthread_no].core_mask);
	for (int i = 0; i < DSPNUM; i++) {
		if (pthread_info[pthread_no].core_mask & (1 << i)) {
			iss_rela[i].iss_shm_prot_ptr->flag = ISS_EXIT;
			iss_rela[i].iss_shm_prot_ptr->cmd.cmd_code = cmd;
			iss_cmd_request(i, cmd);
		}
	}

	return gdb_response(pthread_no, &resp);
}

int pac_soc_write_mem_cmd(int pthread_no, struct pac_soc_cmd *soc_cmd)
{
	char cmd = GDB_ICE_WRITE_MEM;
	int len;
	struct pac_soc_response resp = {0, 0};

	for (int i = 0; i < DSPNUM; i++) {
		if (pthread_info[pthread_no].core_mask & (1 << i)) {
			iss_rela[i].iss_shm_prot_ptr->flag = ISS_STOP;
			gdb_response(pthread_no, &resp);

			len = read_socket(pthread_info[pthread_no].gdb_fd,
							iss_rela[i].iss_shm_prot_ptr->buf,
							soc_cmd->write_mem.len);

			iss_rela[i].iss_shm_prot_ptr->cmd.cmd_code = cmd;
			iss_rela[i].iss_shm_prot_ptr->cmd.write_mem.addr = soc_cmd->write_mem.addr;
			iss_rela[i].iss_shm_prot_ptr->cmd.write_mem.len = soc_cmd->write_mem.len;
			iss_cmd_request(i, cmd);
			break;
		}
	}
	return gdb_response(pthread_no, &resp);
}

int pac_soc_read_mem_cmd(int pthread_no, struct pac_soc_cmd *soc_cmd)
{
	char cmd = GDB_ICE_READ_MEM;
	int  ret = 0;
	struct pac_soc_response resp = {0, 0};

	for (int i = 0; i < DSPNUM; i++) {
		if (pthread_info[pthread_no].core_mask & (1 << i)) {
			iss_rela[i].iss_shm_prot_ptr->flag = ISS_STOP;
			iss_rela[i].iss_shm_prot_ptr->cmd.cmd_code = cmd;
			iss_rela[i].iss_shm_prot_ptr->cmd.read_mem.addr = soc_cmd->read_mem.addr;
			iss_rela[i].iss_shm_prot_ptr->cmd.read_mem.len = soc_cmd->read_mem.len;
			iss_cmd_request(i, cmd);

			resp.ret = 0;
			resp.len = soc_cmd->read_mem.len;
			ret = gdb_response(pthread_no, &resp);

			ret = send(pthread_info[pthread_no].gdb_fd,
					 iss_rela[i].iss_shm_prot_ptr->buf,
					 soc_cmd->read_mem.len, 0);
			break;
		}
	}
	return 0;
}

int pac_soc_write_reg_cmd(int pthread_no, struct pac_soc_cmd *soc_cmd)
{
	char cmd = GDB_ICE_WRITE_DATA_REG;
	int  regno, core_id;
	struct pac_soc_response resp = {0, 0};

	regno = (soc_cmd->write_reg.regno & 0xffffff);
	core_id = (soc_cmd->write_reg.regno >> 24);

	iss_rela[core_id].iss_shm_prot_ptr->flag = ISS_STOP;
	iss_rela[core_id].iss_shm_prot_ptr->cmd.cmd_code = cmd;
	iss_rela[core_id].iss_shm_prot_ptr->cmd.write_reg.regno = regno;
	iss_rela[core_id].iss_shm_prot_ptr->cmd.write_reg.value_h = soc_cmd->write_reg.value_h;
	iss_cmd_request(core_id, cmd);

	return gdb_response(pthread_no, &resp);
}

int pac_soc_read_reg_cmd(int pthread_no, struct pac_soc_cmd *soc_cmd)
{
	char cmd = GDB_ICE_READ_DATA_REG;
	int  regno, core_id;
	struct pac_soc_response resp = {0, 0};

	regno = (soc_cmd->read_reg.regno & 0xffffff);
	core_id = (soc_cmd->read_reg.regno >> 24);

	iss_rela[core_id].iss_shm_prot_ptr->flag = ISS_STOP;
	iss_rela[core_id].iss_shm_prot_ptr->cmd.cmd_code = cmd;
	iss_rela[core_id].iss_shm_prot_ptr->cmd.read_reg.regno = regno;
	iss_cmd_request(core_id, cmd);

	gdb_response(pthread_no, &resp);

	send(pthread_info[pthread_no].gdb_fd,
		&iss_rela[core_id].iss_shm_prot_ptr->cmd.read_reg.value_l,
		sizeof(long long), 0);

	return 0;
}

int pac_soc_read_all_reg_cmd(int pthread_no, struct pac_soc_cmd *soc_cmd)
{
	char cmd = GDB_ICE_READ_ALL_DATA_REG;
	int core_id = soc_cmd->read_all_reg.core_id;
	struct pac_soc_response resp = {0, 0};

	iss_rela[core_id].iss_shm_prot_ptr->flag = ISS_STOP;
	iss_rela[core_id].iss_shm_prot_ptr->cmd.cmd_code = cmd;

	iss_cmd_request(core_id, cmd);

	resp.len = soc_cmd->read_all_reg.len;

	gdb_response(pthread_no, &resp);

	send(pthread_info[pthread_no].gdb_fd,
		&iss_rela[core_id].iss_shm_prot_ptr->buf,
		soc_cmd->read_all_reg.len, 0);

	return 0;
}

int pac_soc_reset_cmd(int pthread_no, struct pac_soc_cmd *soc_cmd)
{
	char cmd = GDB_ICE_RESET;
	struct pac_soc_response resp = {0, 0};

	for (int i = 0; i < DSPNUM; i++) {
		if (pthread_info[pthread_no].core_mask & (1 << i)) {
			iss_rela[i].iss_shm_prot_ptr->flag = ISS_STOP;
			iss_rela[i].iss_shm_prot_ptr->cmd.cmd_code = cmd;
			iss_cmd_request(i, cmd);
		}
	}

	return gdb_response(pthread_no, &resp);
}

int pac_soc_stop_cmd(int pthread_no, struct pac_soc_cmd *soc_cmd)
{
	char cmd = GDB_ICE_STOP;
	struct pac_soc_response resp = {0, 0};

	for (int i = 0; i < DSPNUM; i++) {
		if (soc_cmd->stop.core_mask & (1 << i)) {
			iss_rela[i].iss_shm_prot_ptr->flag = ISS_STOP;
			iss_rela[i].iss_shm_prot_ptr->cmd.cmd_code = cmd;
			iss_cmd_request(i, cmd);
		}
	}

	return gdb_response(pthread_no, &resp);
}

// only return one core's stop reason,  so core_mask only one bit mask.
int pac_soc_get_stop_reason(int pthread_no, struct pac_soc_cmd *soc_cmd)
{
	char cmd = GDB_ICE_STOP_REASON;
	int core_mask = soc_cmd->reason.core_mask;
	struct pac_soc_response resp = {0, 0};
	resp.len = sizeof(enum STOP_REASON);
	gdb_response(pthread_no, &resp);

	for (int i = 0; i < DSPNUM; i++) {
		if (core_mask & (1 << i)) {
			iss_rela[i].iss_shm_prot_ptr->flag = ISS_STOP;
			iss_rela[i].iss_shm_prot_ptr->cmd.cmd_code = cmd;
			iss_cmd_request(i, cmd);

			send(pthread_info[pthread_no].gdb_fd,
				(unsigned char *)&(iss_rela[i].iss_shm_prot_ptr->cmd.reason.active_core),
				sizeof(int), 0);

			send(pthread_info[pthread_no].gdb_fd,
				(unsigned char *)&(iss_rela[i].iss_shm_prot_ptr->cmd.reason.reason),
				sizeof(enum STOP_REASON), 0);

			send(pthread_info[pthread_no].gdb_fd,
				(unsigned char *)&(iss_rela[i].iss_shm_prot_ptr->cmd.reason.result),
				sizeof(int), 0);
		}
	}
	return 0;
}

int pac_soc_run_cmd(int pthread_no, struct pac_soc_cmd *soc_cmd)
{
	char cmd = GDB_ICE_RUN;
	struct pac_soc_response resp = {0, 0};
	int core_id = 0, ret = 0;
	int i;
	struct timeval tv;
	struct pac_soc_cmd soc_gdb_cmd;

	dprintf("run cmd core_mask %d\r\n",soc_cmd->run.core_mask);

	if (soc_cmd->run.core_mask == 0)
		return gdb_response(pthread_no, &resp);

// startup every core
	for (i = 0; i < DSPNUM; i++) {
		if (soc_cmd->run.core_mask & (1 << i)) {
			iss_rela[i].iss_shm_prot_ptr->flag = ISS_STOP;
			iss_rela[i].iss_shm_prot_ptr->cmd.cmd_code = cmd;
			iss_cmd_request(i, cmd);
		}
	}

// waiting for response
	int maxfd = 0;
	int tmpfd = 0;
	int n = 0;
	fd_set rfds;
	FD_ZERO(&rfds);

//select gdb cmd
	for (i = 0; i < (pthread_no+1); i++) {
		FD_SET(pthread_info[i].gdb_fd, &rfds);
		tmpfd = pthread_info[i].gdb_fd;
		maxfd = maxfd > tmpfd? maxfd : tmpfd;
	}

//select pac-iss response
	for (i = 0; i < DSPNUM; i++) {
		if (soc_cmd->run.core_mask & (1 << i)) {
			FD_SET(iss_rela[i].gdb_iss_rd_fifo_fd, &rfds);
			tmpfd = iss_rela[i].gdb_iss_rd_fifo_fd;
			maxfd = maxfd > tmpfd? maxfd : tmpfd;
			n++;
		}
	}

	if(select(maxfd+1, &rfds, (fd_set *)0, (fd_set *)0, (struct timeval *)0) < 0) {
		printf("pac_gdb_server run select fail.\r\n");
		exit(-1);
	}

//if have gdb cmd then do it
	for (i = 0; i < (pthread_no+1); i++) {
		if(FD_ISSET(pthread_info[i].gdb_fd, &rfds)) {
			ret = read_socket(pthread_info[i].gdb_fd, (unsigned char *)&soc_gdb_cmd, sizeof(struct pac_soc_cmd));

			if(ret == sizeof(pac_soc_cmd)) {
				ret = process_soc_cmd(pthread_no, &soc_gdb_cmd);
				if (ret != -1)
					return 0;
				else
					return -1;
			} else {
				printf("pthread_no = %d\t client close/error socket.\r\n", pthread_no);
				break;
			}
			if (ret == -1)
				printf("process_soc_cmd in server error!\r\n");
		}
	}

//if have pac-iss response do it
	for (i = 0; i < DSPNUM; i++) {
		if (FD_ISSET(iss_rela[i].gdb_iss_rd_fifo_fd, &rfds)) {
			core_id = i;
			ret = read (iss_rela[i].gdb_iss_rd_fifo_fd, &cmd, 1);
			if (ret < 0) {
				printf("pac_gdb_server iss_cmd read core %d fail.\r\n", core_id);
				resp.ret = -1;
			} else if (cmd != '0') {
				if (cmd == '2') {
					resp.ret = 1;
				} else {
					resp.ret = -1;
					printf("pac_gdb_server iss_cmd resp core %d fail.\r\n", core_id);
				}
			}
		}
	}

// stop every core	
	for (i = 0; i < DSPNUM; i++) {
		if ((soc_cmd->run.core_mask & ~(1 << core_id)) & (1 << i)) {
			iss_rela[i].iss_shm_prot_ptr->flag = ISS_STOP;
			cmd = GDB_ICE_STOP_OTHER_CORE;
			iss_rela[i].iss_shm_prot_ptr->cmd.cmd_code = cmd;
			iss_cmd_request(i, cmd);
		}
	}

//read pending response 
	maxfd = 0;
	tmpfd = 0;
	n = 0;
	FD_ZERO(&rfds);

	for (i = 0; i < DSPNUM; i++) {
		if ((soc_cmd->run.core_mask & ~(1 << core_id)) & (1 << i)) {
			FD_SET(iss_rela[i].gdb_iss_rd_fifo_fd, &rfds);
			tmpfd = iss_rela[i].gdb_iss_rd_fifo_fd;
			maxfd = maxfd > tmpfd? maxfd : tmpfd;
			n++;
		}
	}
	
	tv.tv_sec = 0;
	tv.tv_usec = 1000;

	if(select(maxfd+1, &rfds, (fd_set *)0, (fd_set *)0, &tv) < 0) {
		printf("pac_gdb_server run select fail.\r\n");
		exit(-1);
	}

	for (i = 0; i < DSPNUM; i++) {
		if (FD_ISSET(iss_rela[i].gdb_iss_rd_fifo_fd, &rfds)) {
			core_id = i;
			ret = read (iss_rela[i].gdb_iss_rd_fifo_fd, &cmd, 1);
			if (ret < 0) {
				printf("pac_gdb_server iss_cmd read core %d fail.\r\n", core_id);
				resp.ret = -1;
			} else if (cmd != '0') {
				if (cmd == '2') {
					resp.ret = 1;
				} else {
					resp.ret = -1;
					printf("pac_gdb_server iss_cmd resp core %d fail.\r\n", core_id);
				}
			}
		}
	}
	return gdb_response(pthread_no, &resp);
}

int pac_soc_step(int pthread_no, struct pac_soc_cmd *soc_cmd)
{
	int i;
	char cmd = GDB_ICE_STEP;
	struct pac_soc_response resp = {0, 0};

	for (i = 0; i < DSPNUM; i++) {
		if (soc_cmd->step.core_mask & (1 << i)) {
			iss_rela[i].iss_shm_prot_ptr->flag = ISS_STOP;
			iss_rela[i].iss_shm_prot_ptr->cmd.cmd_code = cmd;
			iss_cmd_request(i, cmd);
			gdb_response(pthread_no, &resp);
		}
	}

	return 0;
}

int pac_soc_insert_wbp_cmd(int pthread_no, struct pac_soc_cmd *soc_cmd)
{
	char cmd = GDB_ICE_INSERT_WP;
	int core_mask, type;
	struct pac_soc_response resp = {0, 0};

	core_mask = (soc_cmd->insert_wp.type >> 24);
	type = (soc_cmd->insert_wp.type & 0xffffff);

	for (int i = 0; i < DSPNUM; i++) {
		if (core_mask & (1 << i)) {
			iss_rela[i].iss_shm_prot_ptr->flag = ISS_STOP;
			iss_rela[i].iss_shm_prot_ptr->cmd.cmd_code = cmd;
			iss_rela[i].iss_shm_prot_ptr->cmd.insert_wp.addr = soc_cmd->insert_wp.addr;
			iss_rela[i].iss_shm_prot_ptr->cmd.insert_wp.len = soc_cmd->insert_wp.len;
			iss_rela[i].iss_shm_prot_ptr->cmd.insert_wp.type = type;
			iss_cmd_request(i, cmd);
		}
	}
	resp.len = soc_cmd->insert_wp.len;
	return gdb_response(pthread_no, &resp);
}

int pac_soc_remove_wbp_cmd(int pthread_no, struct pac_soc_cmd *soc_cmd)
{
	char cmd = GDB_ICE_REMOVE_WP;
	int core_mask, type;
	struct pac_soc_response resp = {0, 0};

	core_mask = (soc_cmd->remove_wp.type >> 24);
	type = (soc_cmd->remove_wp.type & 0xffffff);

	for (int i = 0; i < DSPNUM; i++) {
		if (core_mask & (1 << i)) {
			iss_rela[i].iss_shm_prot_ptr->flag = ISS_STOP;
			iss_rela[i].iss_shm_prot_ptr->cmd.cmd_code = cmd;
			iss_rela[i].iss_shm_prot_ptr->cmd.remove_wp.addr = soc_cmd->remove_wp.addr;
			iss_rela[i].iss_shm_prot_ptr->cmd.remove_wp.len = soc_cmd->remove_wp.len;
			iss_rela[i].iss_shm_prot_ptr->cmd.remove_wp.type = type;
			iss_cmd_request(i, cmd);
		}
	}

	resp.len = soc_cmd->remove_wp.len;
	return gdb_response(pthread_no, &resp);
}

int pac_soc_insert_bp_cmd(int pthread_no, struct pac_soc_cmd *soc_cmd)
{
	char cmd = GDB_ICE_INSERT_BP;
	struct pac_soc_response resp = {0, 0};

	for (int i = 0; i < DSPNUM; i++) {
		if (pthread_info[pthread_no].core_mask & (1 << i)) {
			iss_rela[i].iss_shm_prot_ptr->flag = ISS_STOP;
			iss_rela[i].iss_shm_prot_ptr->cmd.cmd_code = cmd;
			iss_rela[i].iss_shm_prot_ptr->cmd.insert_bp.addr = soc_cmd->insert_bp.addr;
			iss_cmd_request(i, cmd);
		}
	}

	return gdb_response(pthread_no, &resp);
}

int pac_soc_remove_bp_cmd(int pthread_no, struct pac_soc_cmd *soc_cmd)
{
	char cmd = GDB_ICE_REMOVE_BP;
	struct pac_soc_response resp = {0, 0};

	for (int i = 0; i < DSPNUM; i++) {
		if (pthread_info[pthread_no].core_mask & (1 << i)) {
			iss_rela[i].iss_shm_prot_ptr->flag = ISS_STOP;
			iss_rela[i].iss_shm_prot_ptr->cmd.cmd_code = cmd;
			iss_rela[i].iss_shm_prot_ptr->cmd.remove_bp.addr = soc_cmd->remove_bp.addr;
			iss_cmd_request(i, cmd);
		}
	}

	return gdb_response(pthread_no, &resp);
}

// only set one core's pc
int pac_soc_set_pc_addr(int pthread_no, struct pac_soc_cmd *soc_cmd)
{
	char cmd = GDB_ICE_SET_PC_ADDR;
	int  core_id = soc_cmd->set_pc.core_id;
	struct pac_soc_response resp = {0, 0};

	iss_rela[core_id].iss_shm_prot_ptr->flag = ISS_STOP;
	iss_rela[core_id].iss_shm_prot_ptr->cmd.cmd_code = cmd;
	iss_rela[core_id].iss_shm_prot_ptr->cmd.set_pc.addr = soc_cmd->set_pc.addr;
	iss_cmd_request(core_id, cmd);

	return gdb_response(pthread_no, &resp);
}

int pac_soc_set_profiling_data(int pthread_no, struct pac_soc_cmd *soc_cmd)
{
	char cmd = GDB_ICE_SET_PROFILING_DATA;
	int core_id = soc_cmd->set_profiling_data.core_id;
	struct pac_soc_response resp = {0 , 0};
	
	iss_rela[core_id].iss_shm_prot_ptr->flag = ISS_STOP;
	iss_rela[core_id].iss_shm_prot_ptr->cmd.cmd_code = cmd;
	iss_rela[core_id].iss_shm_prot_ptr->cmd.set_profiling_data.start_pc = soc_cmd->set_profiling_data.start_pc;
	iss_rela[core_id].iss_shm_prot_ptr->cmd.set_profiling_data.end_pc = soc_cmd->set_profiling_data.end_pc;
	iss_rela[core_id].iss_shm_prot_ptr->cmd.set_profiling_data.date = soc_cmd->set_profiling_data.date;
	iss_cmd_request(core_id, cmd);

	return gdb_response(pthread_no, &resp);

}

int pac_soc_get_profiling_head(int pthread_no, struct pac_soc_cmd *soc_cmd)
{
	char cmd = GDB_ICE_GET_PROFILING_HEAD;
	int core_id = soc_cmd->get_profiling_head.core_id;
	struct pac_soc_response resp = {0, 0};

	iss_rela[core_id].iss_shm_prot_ptr->flag = ISS_STOP;
	iss_rela[core_id].iss_shm_prot_ptr->cmd.cmd_code = cmd;
	iss_rela[core_id].iss_shm_prot_ptr->cmd.get_profiling_head.start_pc = soc_cmd->get_profiling_head.start_pc;
	iss_rela[core_id].iss_shm_prot_ptr->cmd.get_profiling_head.end_pc = soc_cmd->get_profiling_head.end_pc;
	iss_cmd_request(core_id, cmd);

	resp.len = *(unsigned int *)iss_rela[core_id].iss_shm_prot_ptr->buf;
	return gdb_response(pthread_no, &resp);
}

int pac_soc_get_profiling_data(int pthread_no, struct pac_soc_cmd *soc_cmd)
{
	int ret;
	char cmd = GDB_ICE_GET_PROFILING_DATA;
	int core_id = soc_cmd->get_profiling_data.core_id;
	struct pac_soc_response resp = {0, 0};

	iss_rela[core_id].iss_shm_prot_ptr->flag = ISS_STOP;
	iss_rela[core_id].iss_shm_prot_ptr->cmd.cmd_code = cmd;
	iss_rela[core_id].iss_shm_prot_ptr->cmd.get_profiling_data.start_pc = soc_cmd->get_profiling_data.start_pc;
	iss_rela[core_id].iss_shm_prot_ptr->cmd.get_profiling_data.end_pc = soc_cmd->get_profiling_data.end_pc;
	iss_rela[core_id].iss_shm_prot_ptr->cmd.get_profiling_data.len = soc_cmd->get_profiling_data.len;
	iss_cmd_request(core_id, cmd);
	
	resp.ret = 0;
	resp.len = soc_cmd->get_profiling_data.len;
	ret = gdb_response(pthread_no, &resp);
	ret = send(pthread_info[pthread_no].gdb_fd, 
				iss_rela[core_id].iss_shm_prot_ptr->buf,
				soc_cmd->get_profiling_data.len, 0);

	return 0;
}

int pac_soc_get_profiling_dma_data(int pthread_no, struct pac_soc_cmd *soc_cmd)
{
	int ret;
	char cmd = GDB_ICE_GET_PROFILING_DMA_DATA;
	int core_id = soc_cmd->get_profiling_dma_data.core_id;
	struct pac_soc_response resp = {0, 0};

	iss_rela[core_id].iss_shm_prot_ptr->flag = ISS_STOP;
	iss_rela[core_id].iss_shm_prot_ptr->cmd.cmd_code = cmd;
	iss_rela[core_id].iss_shm_prot_ptr->cmd.get_profiling_dma_data.start_pc = soc_cmd->get_profiling_dma_data.start_pc;
	iss_rela[core_id].iss_shm_prot_ptr->cmd.get_profiling_dma_data.end_pc = soc_cmd->get_profiling_dma_data.end_pc;
	iss_rela[core_id].iss_shm_prot_ptr->cmd.get_profiling_dma_data.len = soc_cmd->get_profiling_dma_data.len;
	iss_cmd_request(core_id, cmd);
	
	resp.ret = 0;
	resp.len = soc_cmd->get_profiling_dma_data.len;
	ret = gdb_response(pthread_no, &resp);
	ret = send(pthread_info[pthread_no].gdb_fd, 
				iss_rela[core_id].iss_shm_prot_ptr->buf,
				soc_cmd->get_profiling_dma_data.len, 0);

	return 0;
}

int pac_soc_get_profiling_cont_data(int pthread_no, struct pac_soc_cmd *soc_cmd)
{
	int ret;
	char cmd = GDB_ICE_GET_PROFILING_CONTENTION_DATA;
	int core_id = soc_cmd->get_profiling_cont_data.core_id;
	struct pac_soc_response resp = {0, 0};

	iss_rela[core_id].iss_shm_prot_ptr->flag = ISS_STOP;
	iss_rela[core_id].iss_shm_prot_ptr->cmd.cmd_code = cmd;
	iss_rela[core_id].iss_shm_prot_ptr->cmd.get_profiling_cont_data.start_pc = soc_cmd->get_profiling_cont_data.start_pc;
	iss_rela[core_id].iss_shm_prot_ptr->cmd.get_profiling_cont_data.end_pc = soc_cmd->get_profiling_cont_data.end_pc;
	iss_rela[core_id].iss_shm_prot_ptr->cmd.get_profiling_cont_data.len = soc_cmd->get_profiling_cont_data.len;
	iss_cmd_request(core_id, cmd);
	
	resp.ret = 0;
	resp.len = soc_cmd->get_profiling_cont_data.len;
	ret = gdb_response(pthread_no, &resp);
	ret = send(pthread_info[pthread_no].gdb_fd, 
				iss_rela[core_id].iss_shm_prot_ptr->buf,
				soc_cmd->get_profiling_cont_data.len, 0);

	return 0;
}

int process_soc_cmd(int pthread_no, struct pac_soc_cmd *soc_cmd)
{
	int ret = 0;
	switch (soc_cmd->cmd_code) {
	case GDB_ICE_GET_ID:
		break;
	case GDB_ICE_INIT: 
		dprintf("pthread_no = %d\t get GDB_ICE_INIT\r\n", pthread_no);
		ret = pac_soc_init_cmd(pthread_no, soc_cmd);
		break;
	case GDB_ICE_EXIT: 
		dprintf("pthread_no = %d\t get GDB_ICE_EXIT\r\n", pthread_no);
		ret = pac_soc_exit_cmd(pthread_no, soc_cmd);
		break;
	case GDB_ICE_WRITE_MEM: 
		dprintf("pthread_no = %d\t get GDB_ICE_WRITE_MEM\r\n", pthread_no);
		ret = pac_soc_write_mem_cmd(pthread_no, soc_cmd);
		break;
	case GDB_ICE_READ_MEM: 
		dprintf("pthread_no = %d\t get GDB_ICE_READ_MEM\r\n", pthread_no);
		ret = pac_soc_read_mem_cmd(pthread_no, soc_cmd);
		break;
	case GDB_ICE_WRITE_DATA_REG: 
		dprintf("pthread_no = %d\t get GDB_ICE_WRITE_REG\r\n", pthread_no);
		ret = pac_soc_write_reg_cmd(pthread_no, soc_cmd);
		break;
	case GDB_ICE_READ_DATA_REG:
		dprintf("pthread_no = %d\t get GDB_ICE_READ_REG\r\n", pthread_no);
		ret = pac_soc_read_reg_cmd(pthread_no, soc_cmd);
		break;
	case GDB_ICE_READ_ALL_DATA_REG:
		dprintf("pthread_no = %d\t get GDB_ICE_READ_ALL_REG\r\n", pthread_no);
		ret = pac_soc_read_all_reg_cmd(pthread_no, soc_cmd);
		break;
	case GDB_ICE_RESET:
		dprintf("pthread_no = %d\t get GDB_ICE_RESET\r\n", pthread_no);
		ret = pac_soc_reset_cmd(pthread_no, soc_cmd);
		break;
	case GDB_ICE_RUN: 
		dprintf("pthread_no = %d\t get PAC_SOC_RUN\r\n", pthread_no);
		ret = pac_soc_run_cmd(pthread_no, soc_cmd);
		break;
	case GDB_ICE_STEP: 
		dprintf("pthread_no = %d\t get PAC_SOC_STEP\r\n", pthread_no);
		ret = pac_soc_step(pthread_no, soc_cmd);
		break;
	case GDB_ICE_STOP: 
		dprintf("pthread_no = %d\t get GDB_ICE_STOP\r\n", pthread_no);
		ret =pac_soc_stop_cmd(pthread_no, soc_cmd);
		break;
	case GDB_ICE_STOP_REASON:
		dprintf("pthread_no = %d\t get GDB_ICE_STOP_REASON\r\n", pthread_no);
		ret = pac_soc_get_stop_reason(pthread_no, soc_cmd);
		break;
	case GDB_ICE_INSERT_BP: 
		dprintf("pthread_no = %d\t get GDB_ICE_INSERT_BP\r\n", pthread_no);
		ret = pac_soc_insert_bp_cmd(pthread_no, soc_cmd);
		break;
	case GDB_ICE_REMOVE_BP: 
		dprintf("pthread_no = %d\t get GDB_ICE_REMOVE_BP\r\n", pthread_no);
		ret = pac_soc_remove_bp_cmd(pthread_no, soc_cmd);
		break;
	case GDB_ICE_INSERT_HARD_BP:
		break;
	case GDB_ICE_REMOVE_HARD_BP:
		break;
	case GDB_ICE_INSERT_WP: 
		dprintf("pthread_no = %d\t get PAC_SOC_INSERT_WP\r\n", pthread_no);
		ret = pac_soc_insert_wbp_cmd(pthread_no, soc_cmd);
		break;
	case GDB_ICE_REMOVE_WP: 
		dprintf("pthread_no = %d\t get GDB_ICE_REMOVE_WP\r\n", pthread_no);
		ret = pac_soc_remove_wbp_cmd(pthread_no, soc_cmd);
		break;
	case GDB_ICE_DUMP_ICE_REGS:
		break;
	case GDB_ICE_KILL:
		break;
	case GDB_ICE_DUMP_DATA_REGS:
		break;	
	case GDB_ICE_SET_PC_ADDR:
		dprintf("pthread_no = %d\t get PAC_SOC_SET_PC_ADDR\r\n", pthread_no);
		ret = pac_soc_set_pc_addr(pthread_no, soc_cmd);
		break;
	case GDB_ICE_SET_PROFILING_DATA:
		dprintf("pthread_no = %d\t get PAC_SOC_SET_PROFILING_DATA\r\n", pthread_no);
		ret = pac_soc_set_profiling_data(pthread_no, soc_cmd);
		break;
	case GDB_ICE_GET_PROFILING_DATA:
		dprintf("pthread_no = %d\t get PAC_SOC_GET_PROFILING_DATA\r\n", pthread_no);
		ret = pac_soc_get_profiling_data(pthread_no, soc_cmd);	
		break;
	case GDB_ICE_GET_PROFILING_HEAD:
		dprintf("pthread_no = %d\t get PAC_SOC_GET_PROFILING_HEAD\r\n", pthread_no);
		ret = pac_soc_get_profiling_head(pthread_no, soc_cmd);
		break;
	case GDB_ICE_GET_PROFILING_DMA_DATA:
		dprintf("pthread_no = %d\t get PAC_SOC_GET_DMA_PROFILING_HEAD\r\n", pthread_no);
		ret = pac_soc_get_profiling_dma_data(pthread_no, soc_cmd);
		break;
	case GDB_ICE_GET_PROFILING_CONTENTION_DATA:
		dprintf("pthread_no = %d\t get PAC_SOC_GET_CONT_PROFILING_HEAD\r\n", pthread_no);
		ret = pac_soc_get_profiling_cont_data(pthread_no, soc_cmd);
		break;
	default: 
		printf("pthread_no = %d\t get invalid cmd\r\n", pthread_no);
		break;
	}
	return ret;
}

static pid_t gettid (void)
{
    return (pid_t)syscall(__NR_gettid);
}

static int get_freeslot()
{
	int i;
	for (i = 0; i < DSPNUM; i++) {
		if (pthread_info[i].used == 0) {
			pthread_info[i].used = 1;
			return i;
		}
	}
	return -1;
}

void *jtag_pthread(void *pfd)
{
	int ret;
	int pthread_no;
	int fd = *(int *)pfd;
	struct pac_soc_cmd soc_cmd;

	pthread_no = get_freeslot();
	if(pthread_no == -1) {
		printf("Can not get free slot.\r\n");
		close(fd);
		return (void *)0;
	}

	pthread_info[pthread_no].gdb_fd = fd;
	pthread_info[pthread_no].tid = gettid();

	printf("slot=%d, tid=%d working. fd=%d\r\n", pthread_no, gettid(), fd);
	while(1) {
		ret = read_socket(fd, (unsigned char *)&soc_cmd, sizeof(struct pac_soc_cmd));

		if(ret == sizeof(pac_soc_cmd)) {
			ret = process_soc_cmd(pthread_no, &soc_cmd);
		} else {
			printf("pthread_no = %d\t client close/error socket.\r\n", pthread_no);
			break;
		}
		if (ret == -1)
			printf("process_soc_cmd in server error!\r\n");
	}
	pthread_info[pthread_no].used = 0;
	close(fd);
	return (void *)0;
}

void *server_pthread(void *port)
{
	int i;
	int gdbport = *(int *)port;
	int	serverfd, connectfd;
	struct sockaddr_in serveraddr;
	pthread_t th;

	for (i = 0; i < DSPNUM; i++) {
		pthread_info[i].used = 0;
	}

	serverfd = socket(AF_INET, SOCK_STREAM, 0);
	memset(&serveraddr, 0, sizeof(serveraddr));
	serveraddr.sin_family = AF_INET;
	serveraddr.sin_addr.s_addr = htonl(INADDR_ANY);
	if (gdbport == 0)
		serveraddr.sin_port = htons(PAC_SOC_SERVER_PORT);
	else
		serveraddr.sin_port = htons(gdbport);

	bind(serverfd, (struct sockaddr *)&serveraddr, sizeof(serveraddr));

	listen(serverfd, 5);

	while(1) {
		connectfd = accept(serverfd, (struct sockaddr *)NULL, NULL);
		if (connectfd > 0) {
			printf("get succ connect from remote. serverfd = %d, connectfd = %d\r\n", serverfd, connectfd);
		} else {
			printf("get fial connect from remote. serverfd = %d, connectfd = %d\r\n", serverfd, connectfd);
		}

		if (pthread_create(&th, NULL, jtag_pthread, &connectfd) < 0) {
			printf("pthread_create fail.\r\n");
			close(connectfd);
		}
	}
	return NULL;
}
