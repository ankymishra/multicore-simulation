/****************************************************************
 *  TU Eindhoven, Eindhoven, The Netherlands, November 2003
 *  Author  :   Mathijs Visser
 *              (Mathijs.Visser@student.tue.nl)
 *  Purpose :   Perform the inverse DCT coding step of the JPEG
 *              decompression.
 ****************************************************************/

#include "jpeg.h"
#include "mtools.h" /* For printf() */
#include "stdcomm.h"
#include "fast_int_idct.h"

void main (void)
{
    FBlock input;
    PBlock output;
    int blocks_remain; /* A value of zero is used by step1 to tell us that there are no more FBlocks.*/
    int i = 0; /* Number of the current block. */

printf("I am step2.\r\n");
    sc_my_address = 2; /* Set node number. */
//    if (verbose)
 {
        printf("Processor Step%d up and running!\n", sc_my_address);
    };
    /* Process all blocks that we receive.*/
    sc_receive(&blocks_remain, sizeof(int)); /* Check if there is at least one block. */
    printf("blocks_remain %d\n",blocks_remain);
    while(blocks_remain) {
        sc_receive(&input, sizeof(FBlock)); /* Receive a block from the previous node:*/

//        if (verbose)
 {
            printf("Received block %d...", i++);
        };
        IDCT(&input, &output);
  //      if (verbose)
 {
            printf(" IDCT performed...");
        };
        sc_send(ADDR_STEP2TO3, &output, sizeof(PBlock)); /* Send result to next node:*/
//        if (verbose) 
{
            printf(" sent.\n");
        };
        sc_receive(&blocks_remain, sizeof(int)); /* Check if we are done. */
    };
//    if (verbose)
 {
        printf("All done!\n");
    };
    
    printf("step2 finished.\r\n");
//    while(1) {
//	printf("step2 running.\r\n");
//    };
}
