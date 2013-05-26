/****************************************************************
 *
 *       >>>> See header file for more information. <<<<
 ****************************************************************/

#include "huffman.h"
#include "tree_vld.h" /*for: get_symbol() */
#include "step1.h"
#include "parse.h" /*for: get_bits() */

/*------------------------------------------*/
/* some constants for on-the-fly IQ and IZZ */
/*------------------------------------------*/
static const int G_ZZ[] = {
   0,  1,  8, 16,  9,  2,  3, 10,
  17, 24, 32, 25, 18, 11,  4,  5,
  12, 19, 26, 33, 40, 48, 41, 34,
  27, 20, 13,  6,  7, 14, 21, 28,
  35, 42, 49, 56, 57, 50, 43, 36,
  29, 22, 15, 23, 30, 37, 44, 51,
  58, 59, 52, 45, 38, 31, 39, 46,
  53, 60, 61, 54, 47, 55, 62, 63
};

/* Transform JPEG number format into usual 2's-complement format. */
/* Copied from utils.c */
int reformat(unsigned long S, int good)
{
  int St;
 
  if (!good)
    return 0;
  St = 1 << (good-1);	/* 2^(good-1) */
  if (S < (unsigned long) St)
    return (S+1+((-1) << good));
  else
    return S;
}

/*-------------------------------------------------*/
/* here we unpack, predict, unquantify and reorder */
/* a complete 8*8 DCT block ...			   */
/*-------------------------------------------------*/
void unpack_block(FBlock *T, int select)
{
  unsigned int i, run, cat;
  int value;
  unsigned char	symbol;

  /* Init the block with 0's: */
  for (i=0; i<64; i++) T->linear[i] = 0;

  /* First get the DC coefficient: */
  symbol = get_symbol(HUFF_ID(DC_CLASS, comp[select].DC_HT));
  value = reformat(get_bits(symbol), symbol);

#ifdef SPY
  trace_bits(symbol, 1);
#endif

  value += comp[select].PRED;
  comp[select].PRED = value;
  T->linear[0] = value * QTable[comp[select].QT].linear[0];

  /* Now get all 63 AC values: */
  for (i=1; i<64; i++) {
    symbol = get_symbol(HUFF_ID(AC_CLASS, comp[select].AC_HT));
    if (symbol == HUFF_EOB) break;
    if (symbol == HUFF_ZRL) { i += 15; continue; }
    cat = symbol & 0x0F;
    run = (symbol>>4) & 0x0F;
    i += run;
    value = reformat(get_bits(cat), cat);

#ifdef SPY
    trace_bits(cat, 1);
#endif

    /* Dequantify and ZigZag-reorder: */
    T->linear[G_ZZ[i]] = value * QTable[comp[select].QT].linear[i];
  }
}
