/****************************************************************
 *
 *       >>>> See header file for more information. <<<<
 ****************************************************************/

#include "jpeg.h"
#include "parse.h"
#include "step1.h"
#include "huffman.h" /*For unpack_block()*/
#include "mtools.h"
#include "stdcomm.h"
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

#ifdef CC_I386 /* gcc */
#include <stdio.h>
#include <stdlib.h> /* for exit() */
#endif

#ifndef EOF
#define EOF (-1)
#endif

#include "intro.h"
/*----------------------------------------------------------*/

int image_pos = 0; /* Offset in chars of the next character to be read */
                   /* from the memory area that represents the image*/
                   /* file loaded in memory.*/
/* mgetc() reads one character from the input image in memory and*/
/* increases image_pos.*/

static unsigned char *image_buffer;
#if 0
static unsigned char *image_buffer = (unsigned char *)(256*1024);

int mgetc(void)
{
    if (image_pos > JPG_IMAGE_MAX_ADDR) {
        if (verbose) {
            printf("%ld:\tWARNING: Attempt to read past the end of the file.\n",image_pos);
        };
        return EOF;
    } else {
        if (verbose) {
/*        if ((image_pos > 187 && image_pos < 213) || (image_pos > 315 && image_pos < 333)) printf("[%d@%d]\n",(int)image_buffer[image_pos],image_pos);*/
        };
        return (int)image_buffer[image_pos++];
    };
}
#endif

//static unsigned char image_buffer[JPG_IMAGE_BUFFER_SIZE];
void load_image(void)
{
  //int fi; /* Stream pointer of file to dump.*/
  //int aux; /* Integer representation of the last character read.*/
  //int ret = 0;
  //fi = open("test_images/intro.jpg",O_RDWR);
  //printf("open fd %d\n", fi);
  //image_pos = 0;
#if 0
  while (1)  {
    //aux = fgetc(fi);
    ret = read(fi, &aux, sizeof(char));
    if (ret == 0) break;
    if (image_pos == JPG_IMAGE_BUFFER_SIZE) {
        /* Picture is larger than image buffer! */
        printf("ERROR: Image is larger than %d bytes (= size of image_buffer)", image_pos);
        //exit(1);
    };
    image_buffer[image_pos++] = (unsigned char)aux;
  };
#endif
  image_buffer = intro_buffer ;
  //printf("%s\n",image_buffer);
  //image_pos = 0;
}                            
/* mgetc() reads one character from the input image in memory and
 * increases image_pos.*/
int mgetc(void)
{
  if (image_pos ==0) load_image();
  if (verbose) {
      mprintf("[%d@%d]\n",(int)image_buffer[image_pos],image_pos);
  };
  return image_buffer[image_pos++];
}



/* For all components reset DC prediction value to 0. */
void reset_prediction(cd_t *comp)
{
  int i;

  for (i=0; i<3; i++) comp[i].PRED = 0;
}

/*-------------------------------------------*/

/* Returns ceil(N/D). */
int
ceil_div(int N, int D)
{
  int i = N/D;

  if (N > D*i) i++;
  return i;
}


/* Returns floor(N/D). */
int
floor_div(int N, int D)
{
  int i = N/D;

  if (N < D*i) i--;
  return i;
}

/*---------------------------------------------------------------------*/

/* utility and counter to return the number of bits from file */
/* right aligned, masked, first bit towards MSB's		*/

static unsigned char bit_count;	/* available bits in the window */
static unsigned char window;
        /* MSB is next bit to be returned by
         * get_one_bit() and get_bits(). window contains
         * bit_count read bits starting at MSB. */

unsigned long
get_bits(int number)
{
  int i, newbit;
  unsigned long result = 0;
  unsigned char aux, wwindow;

  if (!number)
    return 0;

  for (i = 0; i < number; i++) {
    if (bit_count == 0) {
      wwindow = mgetc();

      if (wwindow == 0xFF)
	switch (aux = mgetc()) {	/* skip stuffer 0 byte */
	case EOF:
	case 0xFF:
	  printf("%ld:\tERROR:\tRan out of bit stream\n", image_pos);
	  mt_halt();
	  break;

	case 0x00:
	  /*stuffers++;*/
	  break;

	default:
	  if (RST_MK(0xFF00 | aux))
	    printf("%ld:\tERROR:\tSpontaneously found restart!\n", image_pos);
	  printf("%ld:\tERROR:\tLost sync in bit stream\n", image_pos);
	  mt_halt();
	  break;
	}

      bit_count = 8;
    }
    else wwindow = window;
    newbit = (wwindow>>7) & 1;
    window = wwindow << 1;
    bit_count--;
    result = (result << 1) | newbit;
  }
  return result;
}


void
clear_bits(void)
{
  bit_count = 0;
}


unsigned char get_one_bit(void)
{
  int newbit;
  unsigned char aux, wwindow;

  if (bit_count == 0) {
    wwindow = mgetc();

    if (wwindow == 0xFF) {
      switch (aux = mgetc()) {	/* skip stuffer 0 byte */
      case EOF:
      case 0xFF:
        printf("%ld:\tERROR:\tRan out of bit stream\n", image_pos);
        mt_halt();
        break;
      case 0x00:
        /*stuffers++;*/
        break;
      default:
        if (RST_MK(0xFF00 | aux))
            printf("%ld:\tERROR:\tSpontaneously found restart!\n", image_pos);
        printf("%ld:\tERROR:\tLost sync in bit stream\n", image_pos);
        mt_halt();
        break;
      }
    };
    bit_count = 8;
  } 
  else
    wwindow = window;

  newbit = (wwindow >> 7) & 1;
  window = wwindow << 1;
  bit_count--;
  return newbit;
}

/*----------------------------------------------------------*/


unsigned int
get_size(void)
{
/*  int retval;

  retval = mgetc();
  retval = mgetc()+retval*256;
  return (unsigned int)retval;*/
  
  unsigned char aux;
  aux = mgetc();
/*  if (verbose) {
    printf("*%d*", (int)aux);
    printf("*%d*", mgetc()); image_pos--;
    printf("*%d*", (aux<<8));
    printf("*%d*", (aux << 8) | mgetc()); image_pos--;
  };*/
  return (aux << 8) | mgetc(); /* big endian */
}


/*----------------------------------------------------------*/


void
skip_segment(void)	/* skip a segment we don't want */
{
  unsigned int size;
  char tag[5];
  int i;

  size = get_size();
  if (verbose)
    printf("%ld:\tINFO:\tSize is %d\n", image_pos, size);
  if (size > 5) {
    for (i = 0; i < 4; i++) 
      tag[i] = mgetc();
    tag[4] = '\0';
    if (verbose)
      printf("%ld:\tINFO:\tTag is %s\n", image_pos, tag);
    size -= 4;
  }
  image_pos += size-2; /*fseek(fi, size-2, SEEK_CUR);*/
}


/*----------------------------------------------------------------*/
/* find next marker of any type, returns it, positions just after */
/* EOF instead of marker if end of file met while searching ...	  */
/*----------------------------------------------------------------*/

unsigned int
get_next_MK(void)
{
  unsigned int c;
  int ffmet = 0;
  int locpassed = -1;

  /*passed--;*/ /* as we fetch one anyway */

  while ((c = mgetc()) != (unsigned int) EOF) {
    switch (c) {
    case 0xFF:
      ffmet = 1;
      break;
    case 0x00:
      ffmet = 0;
      break;
    default:
      if (locpassed > 1) printf("%d:\tNOTE: passed %d bytes\n",image_pos,locpassed);
      if (ffmet)
        return (0xFF00 | c);
      ffmet = 0;
      break;
    }
    locpassed++;
    /*passed++;*/ /* Not essential would only increase communication */
  }

  return (unsigned int) EOF;
}


/*----------------------------------------------------------*/
/* loading and allocating of quantization table             */
/* table elements are in ZZ order (same as unpack output)   */
/*----------------------------------------------------------*/

int
load_quant_tables(void)
{
  char aux;
  unsigned int size, n, i, id, x;

  size = get_size(); /* this is the tables' size */
  n = (size - 2) / 65;

  for (i = 0; i < n; i++) {
    aux = mgetc();
    if (first_quad(aux) > 0) {
      printf("\tERROR:\tBad QTable precision!\n");
      return -1;
    }
    id = second_quad(aux);
    if (verbose)
      printf("\tINFO:\tLoading table %d\n", id);
    /*QTable[id] = (PBlock *) malloc(sizeof(PBlock));
    if (QTable[id] == NULL) {
      printf("\tERROR:\tCould not allocate table storage!\n");*/
      /*exit(1);
    }*/
    QTvalid[id] = 1;
    for (x = 0; x < 64; x++)
      QTable[id].linear[x] = mgetc();
      /*
         -- This is useful to print out the table content --
         for (x = 0; x < 64; x++)
         fprintf(stderr, "%d\n", QTable[id].linear[x]);
      */
  }
  return 0;
}


/*----------------------------------------------------------*/
/* initialise MCU block descriptors	                    */
/*----------------------------------------------------------*/

int
init_MCU(void)
/* Description: 
  * sets MCU_valid[10]
  * comp[i].IDX, comp[i].HDIV, comp[i].VDIV
  * MCU_sx, MCU_sy, mx_size, my_size, rx_size, ry_size
*/
{
  int i, j, k, n, hmax = 0, vmax = 0;

  for (i = 0; i < 10; i++)
    MCU_valid[i] = -1;

  k = 0;

  for (i = 0; i < n_comp; i++) {
    if (comp[i].HS > hmax)
      hmax = comp[i].HS;
    if (comp[i].VS > vmax)
      vmax = comp[i].VS;
    n = comp[i].HS * comp[i].VS;

    comp[i].IDX = k;
    for (j = 0; j < n; j++) {
      MCU_valid[k] = i;
      k++;
      if (k == 10) {
	printf("\tERROR:\tMax subsampling exceeded!\n");
	return -1;
      }
    }
  }

  MCU_sx = 8 * hmax;
  MCU_sy = 8 * vmax;
  for (i = 0; i < n_comp; i++) {
    comp[i].HDIV = (hmax / comp[i].HS > 1);	/* if 1 shift by 0 */
    comp[i].VDIV = (vmax / comp[i].VS > 1);	/* if 2 shift by one */
  }

  mx_size = ceil_div(x_size,MCU_sx);
  my_size = ceil_div(y_size,MCU_sy);
  rx_size = MCU_sx * floor_div(x_size,MCU_sx);
  ry_size = MCU_sy * floor_div(y_size,MCU_sy);

  return 0;
}


/*----------------------------------------------------------*/
/* this takes care for processing all the blocks in one MCU */
/*----------------------------------------------------------*/

int
process_MCU(void)
{
  FBlock FBuff;
  int blocks_remain = 1; /* A value of zero tells node step2 that the last FBlock has been sent.*/
  for (curcomp = 0; MCU_valid[curcomp] != -1; curcomp++) {
    unpack_block(&FBuff, MCU_valid[curcomp]); /* pass index to HT,QT,pred */
    printf("%ld:\tINFO:\tSending a FBlock.\n", image_pos);
    
    /* Tell step2 that a FBlock will be sent next.*/
    sc_send(ADDR_STEP1TO2, &blocks_remain, sizeof(int));

    /* Send the FBlock.*/
    sc_send(ADDR_STEP1TO2, &FBuff, sizeof(FBlock));
    /*IDCT(&FBuff, &MCU_buff[curcomp]);*/
  };
  return 1;
}
