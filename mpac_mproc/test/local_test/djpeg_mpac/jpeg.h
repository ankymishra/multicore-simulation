/****************************************************************
 *  Contents    :   Header for all jpeg code.
 *  Author      :   Pierre Guerrier, March 1998,
 *                  edited by Koen van Eijk, January 1999,
 *                  ported to the minimips platform by
 *                  Mathijs Visser, November 2003.
 ****************************************************************/

#ifndef JPEG_H_
#define JPEG_H_

/* To enable debugging output, uncomment the next #define */
//#define verbose 1

/* Platform dependent settings */
#ifdef CC_I386 /* gcc on i386/PC */
#define JPG_IMAGE_BUFFER_SIZE  (100*1024) /* >= size of jpeg image in bytes */
#define BMP_IMAGE_BUFFER_SIZE (3000*1024) /* >= size of output bitmap in bytes */
#else /* lcc on miniMips */

//liqin #define JPG_IMAGE_MAX_ADDR 0xDFF    /* Address of the last byte that is can be part of the input image.*/
#define JPG_IMAGE_MAX_ADDR	(64*1024)    /* Address of the last byte that is can be part of the input image.*/

#define JPG_IMAGE_BUFFER_SIZE  (100*1024) /* >= size of jpeg image in bytes */
#define BMP_IMAGE_BUFFER_SIZE (3000*1024) /* >= size of output bitmap in bytes */
#endif

/*----------------------------------------------
 * Relative node addresses,
 * bits[15:8]: rela-x, bits[7:0]: rela-y
 * The network is assumed to be 2 by 2 with
 * x and y can be either 0x0 or 0x1.
 * Node address step 1 = 0x0000
 * Node address step 2 = 0x0100
 * Node address step 3 = 0x0001
 *----------------------------------------------*/
//#define ADDR_STEP1TO2 	0x0100
//#define ADDR_STEP1TO3   0x0001
//#define ADDR_STEP2TO3	0x0101

#define ADDR_STEP1TO2 	1
#define ADDR_STEP1TO3   2
#define ADDR_STEP2TO3	2
/*----------------------------------
 * JPEG format parsing markers here
 *----------------------------------*/

#define SOI_MK	0xFFD8		/* start of image	*/
#define APP_MK	0xFFE0		/* custom, up to FFEF */
#define COM_MK	0xFFFE		/* commment segment	*/
#define SOF_MK	0xFFC0		/* start of frame	*/
#define SOS_MK	0xFFDA		/* start of scan	*/
#define DHT_MK	0xFFC4		/* Huffman table	*/
#define DQT_MK	0xFFDB		/* Quant. table		*/
#define DRI_MK	0xFFDD		/* restart interval	*/
#define EOI_MK	0xFFD9		/* end of image		*/
#define MK_MSK	0xFFF0

#define RST_MK(x)	( (0xFFF8&(x)) == 0xFFD0 )
        /* is x a restart interval ? */

/*--------------------------------------------------------
 * all kinds of macros here
 *-------------------------------------------------------- */

#define first_quad(c)   ((c) >> 4)        /* first 4 bits in file order */
#define second_quad(c)  ((c) & 15)

#define HUFF_ID(hclass, id)       (2 * (hclass) + (id))

#define DC_CLASS        0
#define AC_CLASS        1

/*-------------------------------------------------------*/
/* JPEG data types here					*/
/*-------------------------------------------------------*/

typedef union {		/* block of pixel-space values */
  unsigned char	block[8][8];
  unsigned char	linear[64];
} PBlock;

typedef union {		/* block of frequency-space values */
  int block[8][8];
  int linear[64];
} FBlock;


/* component descriptor structure */

typedef struct {
  unsigned char	CID;	/* component ID (init in step1's main(), after SOF_MK) */
  unsigned char	IDX;	/* index of first block in MCU (in: init_MCU())*/

  unsigned char	HS;	/* sampling factors (init in step1's main(), after SOF_MK), 2bits*/
  unsigned char	VS;     /* (init in step1's main(), after SOF_MK), 2bits*/
  unsigned char	HDIV;	/* sample width ratios (in: init_MCU())*/
  unsigned char	VDIV;   /* (in: init_MCU())*/

  char		QT;	/* QTable index, 2bits (init in step1's main(), after SOF_MK)	*/
  char		DC_HT;	/* DC table index, 1bit (init in step1's main(), after SOS_MK) */
  char		AC_HT;	/* AC table index, 1bit (init in step1's main(), after SOS_MK) */
  int		PRED;	/* DC predictor value */
} cd_t;

/***********************************************
 * PROJECT GLOBAL VARIABLES HERE
***********************************************/

#endif
