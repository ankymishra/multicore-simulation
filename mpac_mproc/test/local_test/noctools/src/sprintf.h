/****************************************************************
 *  TU Eindhoven, Eindhoven, The Netherlands, November 2003
 *  Contents    :   svprintf() is equivalent to vprintf(), but
 *                  with output written to the buffer argument
 *                  instead of stdout.
 *  Author      :   Mathijs Visser, November 2003
 *                  Based on printf.c included in the distribution
 *                  of the lcc compiler.
 ****************************************************************/

#ifndef SPRINTF_H
#define SPRINTF_H

#include "stdarg_mm.h"

int svprintf (char *buffer, char *format, va_list arg_list);

#endif
