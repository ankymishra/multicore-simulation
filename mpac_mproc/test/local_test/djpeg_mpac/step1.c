/****************************************************************
 *
 *       >>>> See header file for more information. <<<<
 ****************************************************************/

#include "stdio.h"
#include "stdcomm.h"
#include "jpeg.h"
#include "mtools.h"
#include "step1.h"
#include "parse.h"
#include "tree_vld.h"

#ifndef EOF
#define        EOF        (-1)
#endif

//int verbose=1;

cd_t   comp[3];              /* descriptors all components. No. components */
            /* is 1 for grayscale and 3 for color images. */
PBlock MCU_buff[10]; /* decoded DCT blocks buffer */
int    MCU_valid[10]; /* components of above MCU blocks */

PBlock QTable[4];        /* quantization tables */
int    QTvalid[4];

int   x_size,y_size;         /* Video frame size         */
int   rx_size,ry_size;         /* down-rounded Video frame size (integer MCU) */
int   MCU_sx, MCU_sy;         /* MCU size in pixels         */
int   mx_size, my_size;         /* picture size in units of MCUs */
int   n_comp;                 /* number of components: 1 for grayscale, 3 for color*/

int        in_frame, curcomp;   /* frame started ? current component ? */

unsigned char dummy = 0;  /* Avoid "Expression with no effect elided" */

/*-----------------------------------------------------------------
 *                MAIN                MAIN                MAIN
 *-----------------------------------------------------------------*/

void main(void)
{
  unsigned int aux, mark;
  int restart_interval; /* RST check */
  int i, j; /* j for debugging - remove in final version XXX */
  int continue_do = 1; /* Set to 0 to leave the main processing loop.*/

printf("I am step1. &aux = 0x%08x\r\n", (int)&aux);

  sc_my_address = 1; /* Set node number. */
  printf("Processor Step%d up and running!\n", sc_my_address);

  /* First find the SOI marker: */
  aux = get_next_MK();
  if (aux != SOI_MK) continue_do = 0;

  if (verbose)
    printf("%d:\tINFO:\tFound the SOI marker!\n", image_pos);
  in_frame = 0;
  restart_interval = 0;
  for (i = 0; i < 4; i++)
    QTvalid[i] = 0;

  /*image_pos = 189;*/ /* Skip to the SOF marker */
  /**((unsigned int*)0x10)=(unsigned int)comp;*/

  /* Now process segments as they appear: */
  while (continue_do) {
    mark = get_next_MK();

    switch (mark) {
    case SOF_MK:
      if (verbose)
        printf("%ld:\tINFO:\tFound the SOF marker!\n", image_pos);
      in_frame = 1;
      dummy = get_size();        /* header size, don't care */

      /* load basic image parameters */
      dummy = mgetc();        /* precision, 8bit, don't care */
      y_size = get_size();
      x_size = get_size();
      if (verbose)
        printf("\tINFO:\tImage size is %d by %d\n", x_size,y_size);

      n_comp = mgetc();        /* # of components */
      if (verbose) {
        printf("\tINFO:\t");
        switch (n_comp)
          {
          case 1:
            printf("Monochrome");
            break;
          case 3:
            printf("Color");
            break;
          default:
            printf("Not a");
            break;
          }
        printf(" JPEG image!\n");
      }

      for (i = 0; i < n_comp; i++) {
        /* component specifiers */
        comp[i].CID = mgetc();
        aux = mgetc();
        comp[i].HS = first_quad(aux);
        comp[i].VS = second_quad(aux);
        comp[i].QT = mgetc();
      }
      for (j = 0; j < n_comp; j++) {
        /* component specifiers */
        printf("\tINFO:\tcomp[%d].CID=%d,.HS=%d,.VS=%d,.QT=%d\n",
              j, comp[j].CID, comp[j].HS,
              comp[j].VS, comp[j].QT);
      }
      if ((n_comp > 1) && verbose)
        printf("\tINFO:\tColor format is %d:%d:%d, H=%d\n",
                comp[0].HS * comp[0].VS,
                comp[1].HS * comp[1].VS,
                comp[2].HS * comp[2].VS,
                comp[1].HS);

      if (init_MCU() == -1) continue_do = 0;
      break;

    case DHT_MK:
      if (verbose)
        printf("%ld:\tINFO:\tDefining Huffman Tables\n", image_pos);
      if (load_huff_tables() == -1) continue_do = 0;
      break;

    case DQT_MK:
      if (verbose)
        printf("%ld:\tINFO:\tDefining Quantization Tables\n", image_pos);
      if (load_quant_tables() == -1) continue_do = 0;
      break;

/*    case DRI_MK:*/ /*Only one interval.*/
/*      get_size();*/ /* skip size */
/*      restart_interval = get_size();
      if (verbose)
        fprintf(stderr, "%ld:\tINFO:\tDefining Restart Interval %d\n",
                ftell(fi), restart_interval);
      break;        */

    case SOS_MK:                /* lots of things to do here */
      if (verbose)
        printf("%ld:\tINFO:\tFound the SOS marker!\n", image_pos);
      get_size(); /* don't care */
      aux = mgetc();
      if (aux != (unsigned int) n_comp) {
        printf("\tERROR:\tBad component interleaving!\n");
        continue_do = 0;
        break;
      }

      for (i = 0; i < n_comp; i++) {
        aux = mgetc();
        if (aux != comp[i].CID) {
          printf("\tERROR:\tBad Component Order (expected %d, found %d)!\n", comp[i].CID, aux);
          continue_do = 0;
          break;
        }
        aux = mgetc();
        comp[i].DC_HT = first_quad(aux);
        comp[i].AC_HT = second_quad(aux);
      }

      /* All properties of comp[] and the other MCU and image properties
       * have been set. Send them to node STEP3.*/
#if 0
      sc_send(ADDR_STEP1TO3, comp, sizeof(cd_t)*4);        
      /*sc_send(ADDR_STEP1TO3, MCU_buff, sizeof(PBlock)*11); */
      sc_send(ADDR_STEP1TO3, MCU_valid, sizeof(int)*11);
      sc_send(ADDR_STEP1TO3, &x_size, sizeof(int));
      sc_send(ADDR_STEP1TO3, &y_size, sizeof(int));
      sc_send(ADDR_STEP1TO3, &rx_size, sizeof(int));
      sc_send(ADDR_STEP1TO3, &ry_size, sizeof(int));
      sc_send(ADDR_STEP1TO3, &MCU_sx, sizeof(int));
      sc_send(ADDR_STEP1TO3, &MCU_sy, sizeof(int));
      sc_send(ADDR_STEP1TO3, &mx_size, sizeof(int));
      sc_send(ADDR_STEP1TO3, &my_size, sizeof(int));
      sc_send(ADDR_STEP1TO3, &n_comp, sizeof(int));        
#else
      sc_send(ADDR_STEP1TO3, comp, sizeof(cd_t)*4);        
      /*sc_send(ADDR_STEP1TO3, MCU_buff, sizeof(PBlock)*11); */
      sc_send(ADDR_STEP1TO3, MCU_valid, sizeof(int)*11);
      sc_send(ADDR_STEP1TO3, &x_size, sizeof(int));
      sc_send(ADDR_STEP1TO3, &y_size, sizeof(int));
      sc_send(ADDR_STEP1TO3, &rx_size, sizeof(int));
      sc_send(ADDR_STEP1TO3, &ry_size, sizeof(int));
      sc_send(ADDR_STEP1TO3, &MCU_sx, sizeof(int));
      sc_send(ADDR_STEP1TO3, &MCU_sy, sizeof(int));
      sc_send(ADDR_STEP1TO3, &mx_size, sizeof(int));
      sc_send(ADDR_STEP1TO3, &my_size, sizeof(int));
      sc_send(ADDR_STEP1TO3, &n_comp, sizeof(int));        
#endif

      dummy = get_size(); dummy = mgetc();        /* skip things */

      clear_bits();
      reset_prediction(comp);
      
      /* Main MCU processing loop here.
       * We assume that there is no reset marker, so we have a single
       * sequence of blocks (and no redefinition of tables).
       * So code in this block should not execute.
       * process till end of row without restarts */
      for (i = 0; i < mx_size * my_size; i++)
        process_MCU();

      in_frame = 0;
      break;

    case EOI_MK:
      if (verbose)
        printf("%ld:\tINFO:\tFound the EOI marker!\n", image_pos);
      /*if (in_frame) mt_halt();*/
      printf("\nDone.\n");
      continue_do = 0;
      break;

    case COM_MK:
      if (verbose)
        printf("%ld:\tINFO:\tSkipping comments\n", image_pos);
      skip_segment();
      break;

    case EOF:
      if (verbose)
        printf("%ld:\tERROR:\tRan out of input data!\n", image_pos);
      continue_do = 0;
      break;

    default:
      if ((mark & MK_MSK) == APP_MK) {
        if (verbose)
          printf("%ld:\tINFO:\tSkipping application data\n", image_pos);
        skip_segment();
        break;
      }
      if (RST_MK(mark)) {
        reset_prediction(comp);
        break;
      }
      /* if all else has failed ... */
      printf("%ld:\tWARNING:\tLost Sync outside scan, %d!\n", mark);
      continue_do = 0;
      break;
    } /* end switch */
  };

  /* Tell the node2 that we are done.*/
  sc_send(ADDR_STEP1TO2, &continue_do, sizeof(int));  
  
  printf("step1 finished!\r\n");
//  while(1) {
//      printf("step1 running.\r\n");
//  };
}
