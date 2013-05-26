/****************************************************************
 *
 *       >>>> See header file for more information. <<<<
 ****************************************************************/

#include <stdio.h>
#include <stdlib.h>

/* Sun raster header */

typedef struct {
  unsigned long	MAGIC;
  unsigned long	Width;
  unsigned long	Heigth;
  unsigned long	Depth;
  unsigned long	Length;
  unsigned long	Type;
  unsigned long	CMapType;
  unsigned long	CMapLength;
} sunraster;

void RGB_save(char *file_name, unsigned char *FrameBuffer, int x_size, int y_size, int n_comp)
{
#if 1
    return;
#else
  FILE *fo;
  sunraster *FrameHeader;
  int i;
  unsigned long bigendian_value;
  
  fo=fopen(file_name,"wb");
  if (fo == NULL) {
    fprintf(stderr, "ERROR: Could not open output file %s.\n", file_name);
    exit(1);
  };
  fo = fopen(file_name,"ab");

  FrameHeader = (sunraster *) malloc(sizeof(sunraster));
  FrameHeader->MAGIC      = 0x59a66a95L;
  FrameHeader->Width      = 2 * ceil_div(x_size, 2); /* round to 2 more */
  FrameHeader->Heigth     = y_size;
  FrameHeader->Depth      = (n_comp>1) ? 24 : 8;
  FrameHeader->Length     = 0;	/* not required in v1.0 */
  FrameHeader->Type       = 0;	/* old one */
  FrameHeader->CMapType   = 0;	/* truecolor */
  FrameHeader->CMapLength = 0;	/* none */

  /* Frameheader must be in Big-Endian format */
#if BYTE_ORDER == LITTLE_ENDIAN
  
#define MACHINE_2_BIGENDIAN(value)\
 ((( (value) & (unsigned long)(0x000000FF)) << 24) | \
  (( (value) & (unsigned long)(0x0000FF00)) << 8) | \
  (( (value) & (unsigned long)(0x00FF0000)) >> 8) | \
  (( (value) & (unsigned long)(0xFF000000)) >> 24))
  
  bigendian_value = MACHINE_2_BIGENDIAN(FrameHeader->MAGIC);
  fwrite(&bigendian_value, 4, 1, fo);
  
  bigendian_value = MACHINE_2_BIGENDIAN(FrameHeader->Width);
  fwrite(&bigendian_value, 4, 1, fo);
  
  bigendian_value = MACHINE_2_BIGENDIAN(FrameHeader->Heigth);
  fwrite(&bigendian_value, 4, 1, fo);
  
  bigendian_value = MACHINE_2_BIGENDIAN(FrameHeader->Depth);
  fwrite(&bigendian_value, 4, 1, fo);
  
  bigendian_value = MACHINE_2_BIGENDIAN(FrameHeader->Length);
  fwrite(&bigendian_value, 4, 1, fo);
  
  bigendian_value = MACHINE_2_BIGENDIAN(FrameHeader->Type);
  fwrite(&bigendian_value, 4, 1, fo);
  
  bigendian_value = MACHINE_2_BIGENDIAN(FrameHeader->CMapType);
  fwrite(&bigendian_value, 4, 1, fo);
  
  bigendian_value = MACHINE_2_BIGENDIAN(FrameHeader->CMapLength);
  fwrite(&bigendian_value, 4, 1, fo);
  
#else
  fwrite(FrameHeader, sizeof(sunraster), 1, fo);
#endif

  for (i=0; i<y_size; i++)
    fwrite(FrameBuffer+n_comp*i*x_size, n_comp, FrameHeader->Width, fo);

  fclose(fo);
#endif
}
