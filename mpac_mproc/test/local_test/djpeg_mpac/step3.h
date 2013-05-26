/****************************************************************
 *  Purpose     :   Perform color conversion on the PBlock-s
 *                  received from step2.c using the picture
 *                  attributes received from step1.c. Generate
 *                  the final bitmap.
 *  Author      :   Pierre Guerrier, March 1998, ported to
 *                  the minimips platform by
 *                  Mathijs Visser, November 2003.
 ****************************************************************/

#ifndef STEP3_H
#define STEP3_H

#include "jpeg.h"

/*--------------------------------------------
 * global variables here
 *--------------------------------------------*/
extern cd_t   comp[3]; /* for every component, useful stuff */

extern PBlock MCU_buff[10];  /* decoded component buffer */
                /* between IDCT and color convert */
extern int    MCU_valid[10];  /* for every DCT block, component id then -1 */

/* picture attributes */
extern int x_size, y_size;	/* Video frame size     */
extern int rx_size, ry_size;	/* down-rounded Video frame size */
				/* in pixel units, multiple of MCU */
extern int MCU_sx, MCU_sy;  	/* MCU size in pixels   */
extern int mx_size, my_size;	/* picture size in units of MCUs */
extern int n_comp;		/* number of components 1,3 */

/*-----------------------------------------
 * prototypes from utils.c
 *-----------------------------------------*/

/*extern void show_FBlock(FBlock *S);
extern void show_PBlock(PBlock *S);
extern void bin_dump(FILE *fi);

extern int      ceil_div(int N, int D);
extern int      floor_div(int N, int D);
extern void     reset_prediction();
extern int	reformat(unsigned long S, int good);
extern void	suicide();
extern void	RGB_save(FILE *fo);*/

/*-----------------------------------------
 * prototypes from parse.c
 *-----------------------------------------*/

/*extern void	clear_bits(void);
extern unsigned long	get_bits(int number);
extern unsigned char	get_one_bit(void);
extern unsigned int	get_size(void);
extern unsigned int     get_next_MK(void);
extern int	load_quant_tables(void);
extern int      init_MCU();
extern void     skip_segment(void);
extern int      process_MCU(void);*/

/*-------------------------------------------
 * prototypes from fast_idct.c               
 *-------------------------------------------*/

/*extern void	IDCT(const FBlock *S, PBlock *T);*/

/*-----------------------------------------
 * prototypes from color.c
 *-----------------------------------------*/

/*extern void	color_conversion();*/

/*-------------------------------------------
 * prototypes from table_vld.c or tree_vld.c
 *-------------------------------------------*/

/*extern int	load_huff_tables();
extern unsigned char    get_symbol(FILE *fi, int select);*/

/*-----------------------------------------
 * prototypes from huffman.c
 *-----------------------------------------*/

/*extern void	unpack_block(FILE *fi, FBlock *T, int comp);*/
        /*unpack, predict, dequantize, reorder on store */

/*-----------------------------------------
 * prototypes from spy.c
 *-----------------------------------------*/

/*extern void 	trace_bits(int number, int type);
extern void	output_stats(char *dumpfile);*/

#endif
