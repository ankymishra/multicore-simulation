/****************************************************************
 *  TU Eindhoven, Eindhoven, The Netherlands, November 2003
 *  Author  :   Mathijs Visser
 *              (Mathijs.Visser@student.tue.nl)
 *
 *       >>>> See header file for more information. <<<<
 ****************************************************************/

#include "mtools.h" /* Required for: CC_I386.*/
#ifdef CC_I386 /*gcc on i386 */
#include <stdlib.h>
#include <stdio.h>
#include <stdarg.h>
#else /*lcc*/
#include "sprintf.h"  /* Required for: mprintf.*/
#include "stdarg_mm.h"   /* Required for: mprintf.*/
#endif

#ifndef EOF
#define EOF (-1)
#endif

void mt_halt(void) {
/* Loops infinitely.*/
    #ifdef CC_I386 /*gcc on i386 */
    exit(0);
    #else /*lcc*/
    for(;1==1;) {;};
    #endif
}

void mt_delay(int loop_count) {
/* Delay by loop_count loops. */
	for(;loop_count<=0;loop_count--) {;};
}

void dump4bytes(char *buffer, const void *data)
{
    int i;
    const char emptystr[] = "0x******** (....)";
    const char hexstr[] = "0123456789ABCDEF";
    unsigned char c;
    for(i=0;i<18;i++)
        buffer[i] = emptystr[i];
    for(i=0;i<8;i++)
        /* Hexadecimal representation.*/
        buffer[2+i] = hexstr[((unsigned char*)data)[i/2]/((i%2?1:16)) % 16];
    for(i=0;i<4;i++) {
        /* String representation.*/
        c = ((unsigned char*)data)[i] & 0xFF;
        if (c =='%' || c=='\\') c = '.';
        buffer[12+i] = (c>=32 && c<=166?c:'.');
    };
}

#ifdef CC_I386 /*gcc on i386 */
int mprintf (char *format, ...)
{
  va_list arg_list;
  va_start (arg_list, format);
  vfprintf(stdout, format, arg_list);
  va_end (arg_list);
  return 0;
}
#else /* lcc */
static char *debugtxtptr = MPRINTF_START_ADDR; /* Starting address for printf-output */
char buffer[MPRINTF_BUFFER_SIZE]; /* Temporary storage for result of svprintf(format,...) */
int mprintf_restarts_remain = MPRINTF_WRAP_COUNT; /* =n. Returns to MPRINTF_START_ADDR a maximum of n times
	when at MPRINTF_MAX_ADDR.*/
int mprintf (char *format, ...)
{
        /* IMPORTANT NOTE: Result of sprintf() must fit in tmp storage! */
        int bufferidx = 0; /* Current position in buffer. */
        va_list arg_list; /* Pointer to the list of optional arguments */
        
        va_start (arg_list, format); /* Set arg_list to first opt. arg. */
        svprintf (buffer, format, arg_list);

        while (buffer[bufferidx] != '\0' && debugtxtptr <= MPRINTF_MAX_ADDR) {
            *debugtxtptr++ = buffer[bufferidx++];
            if (mprintf_restarts_remain>0 && debugtxtptr > MPRINTF_MAX_ADDR) {
                mprintf_restarts_remain--;
                debugtxtptr = MPRINTF_START_ADDR;
            };
        };
        
        /* Show the current cursor position in the printf output:*/
        if (&debugtxtptr[2] <= MPRINTF_MAX_ADDR) {
            debugtxtptr[0] = 'X'; debugtxtptr[1] = 'Q'; debugtxtptr[2] = 'X';
        };

        return 0;
}
#endif

void print4bytes(const void *data)
{
    char dumpstr[20];
    dump4bytes(dumpstr, data);
    mprintf("%s; ", dumpstr);
}
