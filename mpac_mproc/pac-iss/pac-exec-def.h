#ifndef _PAC_EXEC_DEF_H_
#define _PAC_EXEC_DEF_H_

// mask
#define LOW16MASK(var)		((var) & 0x0000FFFF)
#define HIGH16MASK(var)		((var) & 0xFFFF0000)
#define LOW16MASK64(var)	((var) & 0x000000000000FFFF)

#define HIGH16MASK64(var)	((var) & 0xFFFFFFFFFFFF0000LL)

#define BYTE1MASK(var)		((var) & 0x000000FF)
#define BYTE2MASK(var)		((var) & 0x0000FF00)
#define BYTE3MASK(var)		((var) & 0x00FF0000)
#define BYTE4MASK(var)		((var) & 0xFF000000)
#define SIGN_EXT_POS(var, num, pos)  (((var) << num) >> pos)
#define SIGN_EXT(var, num)	SIGN_EXT_POS(var, num, num)
#define UPPER_MASK_GEN(var)	((int)0x80000000 >> (var - 1))
#define LOWER_MASK_GEN(var)	(~((int)0x80000000 >> (31 - var)))
#define MASK_GEN(upper, lower)	(~(UPPER_MASK_GEN(upper) ^ LOWER_MASK_GEN(lower)))

#define UPPER_MASK_GEN64(var)	((long long)0x8000000000000000LL >> (var - 1))
#define LOWER_MASK_GEN64(var)	(~((long long)0x8000000000000000LL >> (63 - var)))
#define MASK_GEN64(upper, lower) (~(UPPER_MASK_GEN64(upper) ^ LOWER_MASK_GEN64(lower)))

//small function
#define _MAX(a, b) (((a) >= (b)) ? (a) : (b))
#define _MIN(a, b) (((a) <= (b)) ? (a) : (b))
#define _ABS(a) (((a) >= 0) ? (a) : -(a))
#define SWAP(a, b, c) ((c) = (a), (a) = (b), (b) = (c))


#define LS_PRINT_ERR(OP,pipeline_PC,address)\
  printf("[PC = 0x%X]%s accesses address (0x%X) across the boundary.\n", pipeline_PC, OP, address);

#define BRANCH_PRINT_ERR(OP,pipeline_PC,address)\
  printf("[PC = 0x%X](%s) invalid address[0x%X]. Aborted!\n", pipeline_PC, OP, address);

#define IF_IDX		((WB_IDX + 7) % 8)
#define IDISP_IDX	((WB_IDX + 6) % 8)
#define IDECODE_IDX	((WB_IDX + 5) % 8)
#define RO_IDX		((WB_IDX + 4) % 8)
#define EX1_IDX		((WB_IDX + 3) % 8)
#define EX2_IDX		((WB_IDX + 2) % 8)
#define EX3_IDX		((WB_IDX + 1) % 8)
//#define WB_IDX		((WB_IDX + 0) % 8)

#define EX1_PC		exec_table[EX1_IDX].PC
#define EX2_PC		exec_table[EX2_IDX].PC
#define EX3_PC		exec_table[EX3_IDX].PC

#define UPDATE_REGNUM(IDX)	pipeline_logtab[IDX].update_regnum
#define WRITE_LOG(IDX, I)	pipeline_logtab[IDX].write_node[I]
#define WRITE_LOG_MAX(IDX)	pipeline_logtab[IDX].write_node[UPDATE_REGNUM(IDX)]

#define READ   1
#define WRITE  0
#define WRITED 2

#endif							/* PAC_EXEC_DEF_H */
