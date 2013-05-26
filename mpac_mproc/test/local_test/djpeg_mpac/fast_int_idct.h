/****************************************************************
 *  Contents    :   Utilities for jfif view
 *  Author      :   Pierre Guerrier, March 1998
 *                  IDCT code by Geert Janssen, ported to
 *                  the minimips platform by
 *                  Mathijs Visser, November 2003.
 ****************************************************************/

#include "jpeg.h"

#ifndef FAST_INT_IDCT_C
#define FAST_INT_IDCT_C

#define Y(i,j)		Y[8*i+j]
#define X(i,j)		(output->block[i][j])

/* This version is IEEE compliant using 16-bit arithmetic. */

/* The number of bits coefficients are scaled up before 2-D IDCT: */
#define S_BITS	         3
/* The number of bits in the fractional part of a fixed point constant: */
#define C_BITS		14

#define SCALE(x,n)	((x) << (n))

/* This version is vital in passing overall mean error test. */
#define DESCALE(x, n)	(((x) + (1 << ((n)-1)) - ((x) < 0)) >> (n))

#define ADD(x, y)	((x) + (y))
#define SUB(x, y)	((x) - (y))
#define CMUL(C, x)	(((C) * (x) + (1 << (C_BITS-1))) >> C_BITS)

/* Butterfly: but(a,b,x,y) = rot(sqrt(2),4,a,b,x,y) */
#define but(a,b,x,y)	{ x = SUB(a,b); y = ADD(a,b); }

/* Inverse 1-D Discrete Cosine Transform.
   Result Y is scaled up by factor sqrt(8).
   Original Loeffler algorithm.
*/
/*static void idct_1d(int *Y); static: visible in only the file where defined*/

/* Inverse 2-D Discrete Cosine Transform. */
void IDCT(const FBlock *input, PBlock *output);

#endif
