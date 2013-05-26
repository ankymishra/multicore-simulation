/****************************************************************
 *  Contents    :   Utilities for jfif view
 *  Author      :   Pierre Guerrier, March 1998, ported to
 *                  the minimips platform by
 *                  Mathijs Visser, November 2003.
 ****************************************************************/

#ifndef TREE_VLD_H
#define TREE_VLD_H

#include "jpeg.h"

/*--------------------------------------*/
/* private huffman.c defines and macros */
/*--------------------------------------*/

/* Number of HTable words sacrificed to bookkeeping: */
#define GLOB_SIZE		32

/* Memory size of HTables: */
#define MAX_SIZE(hclass)		((hclass)?384:64)

/* Available cells, top of storage: */
#define MAX_CELLS(hclass)	(MAX_SIZE(hclass) - GLOB_SIZE)

/* for Huffman tree descent */
/* lower 8 bits are for value/left son */

#define GOOD_NODE_FLAG		0x100
#define GOOD_LEAF_FLAG		0x200
#define BAD_LEAF_FLAG		0x300
#define SPECIAL_FLAG		0x000
#define HUFF_FLAG_MSK		0x300

#define HUFF_FLAG(c)		((c) & HUFF_FLAG_MSK)
#define HUFF_VALUE(c)		((unsigned char)( (c) & (~HUFF_FLAG_MSK) ))


/*----------------------------------------------------------*/
/* Loading of Huffman table, with leaves drop ability	    */
/*----------------------------------------------------------*/
int load_huff_tables();

/*-----------------------------------*/
/* extract a single symbol from file */
/* using specified huffman table ... */
/*-----------------------------------*/
unsigned char get_symbol(int select);

#endif
