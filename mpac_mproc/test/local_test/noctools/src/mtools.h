/****************************************************************
 *  TU Eindhoven, Eindhoven, The Netherlands, November 2003
 *  Name    :   mtools.h
 *  Author  :   Mathijs Visser
 *              (Mathijs.Visser@student.tue.nl)
 *  Purpose :   Tools for the mini-MIPS
 ****************************************************************/

#ifndef MTOOLS_H_
#define MTOOLS_H_

void mt_halt(void);
/****************************************************************
 * DESCRIPTION of mt_halt(): Halt the processor.
 ****************************************************************/

void mt_delay(int loop_count);
/****************************************************************
 * DESCRIPTION of mt_delay(): Delay for loop_count loops.
 ****************************************************************/

#define MPRINTF_START_ADDR 	((char *)0xE00)
#define MPRINTF_MAX_ADDR 	((char *)0xFFF)
#define MPRINTF_BUFFER_SIZE 	200
#define MPRINTF_WRAP_COUNT 	1000
int mprintf (char *format, ...);
/****************************************************************
 * DESCRIPTION of mprintf():
 *   Same as printf() except that output is saved on a rotating store
 *   in (data) memory starting at MPRINTF_START_ADDR and ending
 *   at MPRINTF_MAX_ADDR. MPRINTF_WRAP_COUNT is decreased
 *   whenever saving restarts at MPRINTF_START_ADDR. If the
 *   position is MPRINTF_MAX_ADDR and the counter is zero no data 
 *   is saved. Before output is saved, it is stored in a buffer that is
 *   MPRINTF_BUFFER_SIZE bytes. If the output has more bytes, then
 *   that may lead to corruption.
 ****************************************************************/

void print4bytes(const void *data);
/****************************************************************
 * DESCRIPTION of print4bytes():
 * Saves the first 4 bytes of the data pointed to by data in both 
  * hexadecimal and ASCII format using mprintf().
 ****************************************************************/

void dump4bytes(char *buffer, const void *data);
/****************************************************************
 * DESCRIPTION of dump4bytes():
 * Saves the first 4 bytes of the data pointed to by data in both
 * hexadecimal and ASCII format to buffer.
 ****************************************************************/

#endif
