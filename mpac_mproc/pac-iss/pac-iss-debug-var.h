#ifndef PAC_ISS_DEBUG_VAR_H_INCLUDED
#define PAC_ISS_DEBUG_VAR_H_INCLUDED

int break_init();
int break_uninit();
int is_bp_hit(unsigned int pc);
int insert_bp(unsigned int pc);
int del_bp(unsigned int pc);

int get_max_wbp();
int is_wbp_hit(unsigned int addr, int len, int type);
int insert_wbp(unsigned int addr, int len, int type);
int del_wbp(unsigned int addr, int len, int type);

int pac_stack_init(Pac_Stack * stack, int size);
int pac_stack_uninit(Pac_Stack * stack);
void *pac_stack_malloc(Pac_Stack * stack, int size, int isgrow);
int pac_stack_grow(Pac_Stack * stack, int size);


#endif
