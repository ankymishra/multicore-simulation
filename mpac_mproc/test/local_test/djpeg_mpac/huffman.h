/****************************************************************
 *  Contents    :   Utilities for jfif view
 *  Author      :   Pierre Guerrier, March 1998, ported to
 *                  the minimips platform by
 *                  Mathijs Visser, November 2003.
 ****************************************************************/

#ifndef HUFFMAN_H
#define HUFFMAN_H

#include "jpeg.h"

/*--------------------------------------*/
/* private huffman.c defines and macros */
/*--------------------------------------*/
#define HUFF_EOB		0x00
#define HUFF_ZRL		0xF0

/*-------------------------------------------------*/
/* here we unpack, predict, unquantify and reorder */
/* a complete 8*8 DCT block ...			   */
/*-------------------------------------------------*/
void unpack_block(FBlock *T, int select);

#endif
