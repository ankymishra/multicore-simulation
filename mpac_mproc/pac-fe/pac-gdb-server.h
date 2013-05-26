
struct iss_rela_struct {
    int gdb_iss_rd_fifo_fd;
    int gdb_iss_wr_fifo_fd;
    struct iss_shm_prot *iss_shm_prot_ptr;
};

extern struct iss_rela_struct iss_rela[DSPNUM];

