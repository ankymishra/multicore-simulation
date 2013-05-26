/****************************************************************
 *
 *       >>>> See header file for more information. <<<<
 ****************************************************************/

#include "jpeg.h"
#include "fast_int_idct.h"

/* Inverse 1-D Discrete Cosine Transform.
   Result Y is scaled up by factor sqrt(8).
   Original Loeffler algorithm.
*/
static void idct_1d(int *Y)
{
  int z1[8], z2[8], z3[8];

  /* Stage 1: */
  but(Y[0], Y[4], z1[1], z1[0]);
  /* rot(sqrt(2), 6, Y[2], Y[6], &z1[2], &z1[3]); */
  z1[2] = SUB(CMUL( 8867, Y[2]), CMUL(21407, Y[6]));
  z1[3] = ADD(CMUL(21407, Y[2]), CMUL( 8867, Y[6]));
  but(Y[1], Y[7], z1[4], z1[7]);
  /* z1[5] = CMUL(sqrt(2), Y[3]);
     z1[6] = CMUL(sqrt(2), Y[5]);
  */
  z1[5] = CMUL(23170, Y[3]);
  z1[6] = CMUL(23170, Y[5]);

  /* Stage 2: */
  but(z1[0], z1[3], z2[3], z2[0]);
  but(z1[1], z1[2], z2[2], z2[1]);
  but(z1[4], z1[6], z2[6], z2[4]);
  but(z1[7], z1[5], z2[5], z2[7]);

  /* Stage 3: */
  z3[0] = z2[0];
  z3[1] = z2[1];
  z3[2] = z2[2];
  z3[3] = z2[3];
  /* rot(1, 3, z2[4], z2[7], &z3[4], &z3[7]); */
  z3[4] = SUB(CMUL(13623, z2[4]), CMUL( 9102, z2[7]));
  z3[7] = ADD(CMUL( 9102, z2[4]), CMUL(13623, z2[7]));
  /* rot(1, 1, z2[5], z2[6], &z3[5], &z3[6]); */
  z3[5] = SUB(CMUL(16069, z2[5]), CMUL( 3196, z2[6]));
  z3[6] = ADD(CMUL( 3196, z2[5]), CMUL(16069, z2[6]));

  /* Final stage 4: */
  but(z3[0], z3[7], Y[7], Y[0]);
  but(z3[1], z3[6], Y[6], Y[1]);
  but(z3[2], z3[5], Y[5], Y[2]);
  but(z3[3], z3[4], Y[4], Y[3]);
}

/* Inverse 2-D Discrete Cosine Transform. */
void IDCT(const FBlock *input, PBlock *output)
{
  int Y[64];
  int k,l;

  /* Pass 1: process rows. */
  for (k = 0; k < 8; k++) {

    /* Prescale k-th row: */
    for (l = 0; l < 8; l++)
      Y(k,l) = SCALE(input->block[k][l], S_BITS);

    /* 1-D IDCT on k-th row: */
    idct_1d(&Y(k,0));
    /* Result Y is scaled up by factor sqrt(8)*2^S_BITS. */
  }

  /* Pass 2: process columns. */
  for (l = 0; l < 8; l++) {
    int Yc[8];

    for (k = 0; k < 8; k++) Yc[k] = Y(k,l);
    /* 1-D IDCT on l-th column: */
    idct_1d(Yc);
    /* Result is once more scaled up by a factor sqrt(8). */
    for (k = 0; k < 8; k++) {
      int r = 128 + DESCALE(Yc[k], S_BITS+3); /* includes level shift */

      /* Clip to 8 bits unsigned: */
      r = r > 0 ? (r < 255 ? r : 255) : 0;
      X(k,l) = r;
    }
  }
}
