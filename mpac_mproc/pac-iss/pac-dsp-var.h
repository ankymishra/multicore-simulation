#ifndef PAC_DSP_VAR_H_INCLUDED
#define PAC_DSP_VAR_H_INCLUDED

//soc interface
int pac_soc_init();
int pac_soc_reset();
int pac_soc_step(int step_num);
void pac_iss_wait(void);

//gdb interface
int dbg_read_reg(int regno, unsigned char *buf);
int dbg_write_reg(int regno, unsigned char *buf);
int dbg_read_all_reg(struct reg_file *buf);
int dbg_insert_wbp(unsigned int addr, int len, int type);
int dbg_remove_wbp(unsigned int addr, int len, int type);
int dbg_insert_bp(unsigned int pc);
int dbg_remove_bp(unsigned int pc);
int dbg_reset(void);
int dbg_soc_reset(void);

int pac_iss_process_gdb_cmd(char c);
int pac_dsp_get_id(struct iss_shm_prot *prot);
int pac_dsp_init_cmd(struct iss_shm_prot *prot);
int pac_dsp_exit_cmd(struct iss_shm_prot *prot);
int pac_dsp_write_mem_cmd(struct iss_shm_prot *prot);
int pac_dsp_read_mem_cmd(struct iss_shm_prot *prot);
int pac_dsp_write_reg_cmd(struct iss_shm_prot *prot);
int pac_dsp_read_reg_cmd(struct iss_shm_prot *prot);
int pac_dsp_read_all_reg_cmd(struct iss_shm_prot *prot);
int pac_dsp_reset_cmd(struct iss_shm_prot *prot);
int pac_dsp_stop_cmd(struct iss_shm_prot *prot);
int pac_dsp_get_stop_reason(struct iss_shm_prot *prot);
int pac_dsp_run_cmd(struct iss_shm_prot *prot);
int pac_dsp_stop_other_core(struct iss_shm_prot *prot);
int pac_dsp_step(int n);
int pac_dsp_insert_wbp_cmd(struct iss_shm_prot *prot);
int pac_dsp_remove_wbp_cmd(struct iss_shm_prot *prot);
int pac_dsp_insert_bp_cmd(struct iss_shm_prot *prot);
int pac_dsp_remove_bp_cmd(struct iss_shm_prot *prot);
int pac_dsp_set_pc_addr(struct iss_shm_prot *prot);
int pac_dsp_set_profiling_data(struct iss_shm_prot *prot);
int pac_dsp_get_profiling_data(struct iss_shm_prot *prot);
int pac_dsp_get_profiling_head(struct iss_shm_prot *prot);
int pac_dsp_get_profiling_dma_data(struct iss_shm_prot *prot);
int pac_dsp_get_profiling_cont_data(struct iss_shm_prot *prot);

void pipeline_id();
void pipeline_ro();

void set_state();
void clear_state();
void clear_pipeline(void);
int  is_int_occur(unsigned int *pc);
void int_process(unsigned int pc);

int soc_read_reg(unsigned int addr, unsigned char *ret);
int soc_write_reg(unsigned int addr, unsigned char *buf);
int soc_read_all_reg(unsigned char *buf);

unsigned int get_fetch_pc();
void set_fetch_pc(unsigned int pc);
void update_fetch_pc();

void start_branch_slot();
int  is_in_branch_slot();
void save_branch_target(unsigned int pc);

void pac_iss_init(const char *filename, unsigned int addr);
void pac_iss_run();

#endif
