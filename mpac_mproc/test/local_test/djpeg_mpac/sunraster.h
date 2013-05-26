/****************************************************************
 *  Purpose     :   Save final RGB image to disk using the
 *                  sunraster uncompressed format.
 *  Author      :   Pierre Guerrier, March 1998, ported to
 *                  the minimips platform by
 *                  Mathijs Visser, November 2003.
 ****************************************************************/

#ifndef SUNRASTER_H
#define SUNRASTER_H

void RGB_save(char *file_name, unsigned char *FrameBuffer, int x_size, int y_size, int n_comp);

#endif
