/****************************************************************
 *
 *       >>>> See header file for more information. <<<<
 ****************************************************************/

#include "stdcomm.h"
#include "mtools.h" /* For mt_halt() as replacement for exit(int) */

#include "jpeg.h"
#include "step3.h"
#include "color.h"

#include "intro.h"

//#ifdef CC_I386 /* gcc */
//#include "sunraster.h"
//#endif

/* real declaration of global variables here */
/* see jpeg.h for more info			*/

cd_t   comp[3];         /* descriptors all components. No. components*/
                        /* is 1 for grayscale and 3 for color images. */
PBlock MCU_buff[10];    /* decoded DCT blocks buffer */
int    MCU_valid[10];   /* components of above MCU blocks */

int   x_size,y_size;    /* Video frame size */
int   rx_size,ry_size;  /* down-rounded Video frame size (integer MCU) */
int   MCU_sx, MCU_sy;   /* MCU size in pixels	 */
int   mx_size, my_size; /* picture size in units of MCUs */
int   n_comp;           /* number of components: 1 for grayscale, 3 for color*/

typedef struct {
  unsigned long	MAGIC;
  unsigned long	Width;
  unsigned long	Heigth;
  unsigned long	Depth;
  unsigned long	Length;
  unsigned long	Type;
  unsigned long	CMapType;
  unsigned long	CMapLength;
} sunraster_header;

//extern char *intro_buffer;
//static sunraster_header *FrameHeader = (sunraster_header *)(0x00 + 256*1024);
//static unsigned char *FrameBuffer = (unsigned char *)(0x20 + 256*1024);   /* Complete final RGB image */
sunraster_header *FrameHeader;
unsigned char *FrameBuffer;   /* Complete final RGB image */

unsigned char ColorBuffer[2*8 /*= MCU_sx max*/ *2*8 /*= MCU_sy max*/ *3 /*= n_comp max*/];
        /* Temporary for the MCU after color conversion */

int	MCU_row, MCU_column; /* current position in MCU unit */

#ifndef CC_I386 /* lcc */
/* Returns ceil(N/D). */
int ceil_div(int N, int D)
{
  int i = N/D;
  if (N > D*i) i++;
  return i;
}
#endif

int process_MCU(void)
{
  int  i,j;
  long offset;
  int  goodrows, goodcolumns;

  if (MCU_column == mx_size) {
    MCU_column = 0;
    MCU_row++;
    if (MCU_row == my_size) {
      return 0;
    }
  }

  /* YCrCb to RGB color space transform here */
  if (n_comp > 1)
    color_conversion(ColorBuffer);
  else {
    for(i=0;i<64;i++)
      ColorBuffer[i] = MCU_buff[0].linear[i];
  };

  /* cut last row/column as needed */
  if ((y_size != ry_size) && (MCU_row == (my_size - 1)))
    goodrows = y_size - ry_size;
  else
    goodrows = MCU_sy;

  if ((x_size != rx_size) && (MCU_column == (mx_size - 1)))
    goodcolumns = x_size - rx_size;
  else
    goodcolumns = MCU_sx;

  offset = n_comp * (MCU_row * MCU_sy * x_size + MCU_column * MCU_sx);

  for (i = 0; i < goodrows; i++)
    for (j = 0; j < n_comp * goodcolumns; j++)
        FrameBuffer[offset + n_comp * i * x_size+j] = ColorBuffer[n_comp * i * MCU_sx+j];

  MCU_column++;
  return 1;
}

/*-----------------------------------------------------------------*/
/*		MAIN		MAIN		MAIN		   */
/*-----------------------------------------------------------------*/
void main(void)
{
    int i;
    
    sunraster_header *FrameHeader = intro_buffer;
    unsigned char *FrameBuffer = (unsigned char *)(0x20+intro_buffer);   /* Complete final RGB image */

printf("I am step3.\r\n");
    sc_my_address = 3; /* Set node number. */
    printf("Processor Step%d up and running!\n", sc_my_address);

    /* Get the MCU, (color)component and picture properties: */
    sc_receive(comp, sizeof(cd_t)*4);	
    /*sc_receive((int *)MCU_buff, sizeof(PBlock)*11); */
    sc_receive(MCU_valid, sizeof(int)*11);
    sc_receive(&x_size, sizeof(int));
    sc_receive(&y_size, sizeof(int));
    sc_receive(&rx_size, sizeof(int));
    sc_receive(&ry_size, sizeof(int));
    sc_receive(&MCU_sx, sizeof(int));
    sc_receive(&MCU_sy, sizeof(int));
    sc_receive(&mx_size, sizeof(int));
    sc_receive(&my_size, sizeof(int));
    sc_receive(&n_comp, sizeof(int));


    #ifndef CC_I386 /* lcc */
    /* Save sunraster header (32 bytes) at start of memory. */
    FrameHeader->MAGIC      = 0x59a66a95L;
    FrameHeader->Width      = 2 * ceil_div(x_size, 2); /* round to 2 more */
    FrameHeader->Heigth     = y_size;
    FrameHeader->Depth      = (n_comp>1) ? 24 : 8;
    FrameHeader->Length     = 0;	/* not required in v1.0 */
    FrameHeader->Type       = 0;	/* old one */
    FrameHeader->CMapType   = 0;	/* truecolor */
    FrameHeader->CMapLength = 0;	/* none */
    #endif
    
    if (verbose) {
        printf("x_size=%d, y_size=%d\nrx_size=%d, ry_size=%d\nMCU_sx=%d, MCU_sy=%d\nmx_size=%d, my_size=%d, n_comp=%d\n", \
            x_size, y_size, rx_size, ry_size, MCU_sx, MCU_sy, mx_size, my_size, n_comp);
        printf("All image properties have been received.\n");
    };

    /* Process all MCU's.*/
    MCU_column = 0;
    MCU_row = 0;
    for (i = 0; i < mx_size * my_size; i++)
    {
        /* Receive a complete MCU in MCU_buff and process it.*/
        int curcomp;
        for (curcomp = 0; MCU_valid[curcomp] != -1; curcomp++) {
            /* Receive a block from the previous node:*/
            if (verbose) {
                printf("Receiving block %d...", curcomp);
            };
            sc_receive(&MCU_buff[curcomp], sizeof(PBlock));
            if (verbose) {
                printf(" done.\n");
            };
        };
        if (verbose) {
            printf("Received MCU %d (x,y=%d,%d), processing...", i, MCU_row, MCU_column);
        };
        process_MCU();
        if (verbose) {
            printf(" done.\n");
        };
    };
    if (verbose) {
        printf("All done!\n");
    };

    printf("step3 finished.\r\n");
//    while(1) {
//	printf("step3 running.\r\n");
//    };
}
