/****************************************************************
 *  Contents    :   Utilities for jfif view
 *  Author      :   Pierre Guerrier, March 1998, ported to
 *                  the minimips platform by
 *                  Mathijs Visser, November 2003.
 ****************************************************************/

#ifndef PARSE_H
#define PARSE_H

#include "jpeg.h"

/* Also referenced in step1.c:*/
extern void reset_prediction(cd_t *comp);
extern void clear_bits(void);
/* Defined in parse.c, used in step1.c: */
extern unsigned int get_next_MK(void);
extern int load_quant_tables(void);
extern int init_MCU();
extern void skip_segment(void);
extern int process_MCU(void);

/* Also referenced in huffman.c: */
extern unsigned long get_bits(int number);

/* Referenced in tree_vld.c: */
extern unsigned char get_one_bit(void);

/* Also referenced in step1.c & tree_vld.c: */
extern unsigned int get_size(void);

/****************************************************************
 * DESCRIPTION:
 *   Returns the char at the current position of the input 
 *   JPEG-image that resides in memory and increases its
 *   internal memory pointer image_pos so that next call of
 *   mgetc() returns the next char.
 ****************************************************************/
extern int mgetc(void); 
extern int image_pos; /* Offset in chars of the next character */

#endif
