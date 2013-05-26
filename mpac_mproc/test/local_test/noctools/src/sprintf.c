/****************************************************************
 *       >>>> See header file for more information. <<<<
 ****************************************************************/

#include "sprintf.h"

int char_pos; /* Number of characters written to buffer (not counting \0) */

static void
serial_out_hex (char *out, unsigned int n)
{
  static char *digit = "0123456789abcdef";
  int i;

  for (i = 7; i >= 0; i--)
    out[char_pos++] = digit[(n >> (4 * i)) & 15];
}

static void
serial_out_chars (char *out, int n, char c)
{
  while (n-- > 0)
    out[char_pos++] = c;
}

static void
serial_out_str (char *out, char *s, int left, int field)
{
  char *p;
  int len;

  if (s == 0)
    s = "<NULL>";

  if (field)
    {
      for (p = s, len = 0; *p; p++)
	len++;

      if (!left)
	serial_out_chars (out, field - len, ' ');

      while (*s)
	out[char_pos++] = *s++;

      if (left)
	serial_out_chars (out, field - len, ' ');
    }
  else
    {
      while (*s)
	out[char_pos++] = *s++;
    }
}

void
serial_out_dec (char *out, int n, int is_signed, int left, int field)
{
  char buff[40], *s = &buff[39];
  unsigned int un, negative;

  if (is_signed && n < 0)
    {
      negative = 1;
      un = (unsigned int) -n;
    }
  else
    {
      negative = 0;
      un = (unsigned int) n;
    }

  *s = '\0';

  do
    {
      *(--s) = '0' + un % 10;
      un /= 10;
    }
  while (un > 0);

  if (negative)
    *(--s) = '-';

  serial_out_str (out, s, left, field);
}

void formated_out (char *out, char *format, va_list arg_list)
{
  int field, left;

  if (format == 0)
    format = "<NULL>";

  while (*format)
    {
      if (*format != '%')
	{
	  out[char_pos++] = *format++;
	  continue;
	}

      format++;
      
      if (*format == 'h' || *format == 'l' || *format == 'L')
        format++; /* Skip unsupported type prefixes */

      if (*format == '-')
	{
	  format++;
	  left = 1;
	}
      else
	left = 0;

      field = 0;
      while (*format >= '0' && *format <= '9')
	field = 10 * field + *format++ - '0';

      switch (*format)
	{
	case 's':
	  serial_out_str (out, va_arg (arg_list, char *), left, field);
	  break;
	case 'u':
	  serial_out_dec (out, va_arg (arg_list, int), 0, left, field);
	  break;
	case 'd':
	  serial_out_dec (out, va_arg (arg_list, int), 1, left, field);
	  break;
	case 'x':
	  serial_out_hex (out, va_arg (arg_list, int));
	  break;
	case 'p':
	  serial_out_hex (out, va_arg (arg_list, int));
	  break;
	case 'c':
	  out[char_pos++] = va_arg (arg_list, int);
	  break;
	case '%':
	  out[char_pos++] = *format;
	  break;
	default:
	  out[char_pos++] = '%';
	  out[char_pos++] = *format;
	  (void) va_arg (arg_list, int);
	  break;
	}

      format++;
    }
    
  /* Output the trailing \0 of the format string. */
  out[char_pos] = '\0';
}

int svprintf (char *buffer, char *format, va_list arg_list)
{
  char_pos = 0;
  formated_out (buffer, format, arg_list);  
  return char_pos;
}
