#ifndef PAC_ISS_DEBUG_DEF_H_INCLUDED
#define PAC_ISS_DEBUG_DEF_H_INCLUDED

typedef struct _sbbp {
	unsigned int pc;
	struct _sbbp *next;
} Sbbp;

typedef struct _watch_point {
	unsigned int addr;
	int len;
	int type;
	struct _watch_point *next;
} Watch_Point;

typedef struct _pac_chunk {
	struct _pac_chunk *pprev;
	char mem[1];
} Pac_Chunk;

typedef struct _pac_stack {
	Pac_Chunk *header;
	int size;
	char *limit;
	char *next_free;
} Pac_Stack;

#endif
