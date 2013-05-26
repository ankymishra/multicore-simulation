/*
Copyright (C)  IP Design Dept.1 Sunplus Technology Co., Ltd.

Author HowardChen / ibanez@sunplus.com

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

Also add information on how to contact you by electronic and paper mail.

If the program is interactive, make it output a short notice like this when it starts in an interactive mode:

Gnomovision version 69, Copyright (C) year name of author
Gnomovision comes with ABSOLUTELY NO WARRANTY; for details
type `show w'.  This is free software, and you are welcome
to redistribute it under certain conditions; type `show c'
for details.
*/
#ifndef SOC_TYPE_H_INCLUDED
#define SOC_TYPE_H_INCLUDED


typedef unsigned char                       UINT8;
typedef signed char                         INT8;
typedef unsigned short                      UINT16;
typedef signed short                        INT16;
typedef unsigned int                        UINT32;
typedef signed int                          INT32;

#ifdef WIN32
    #ifdef __MINGW32__
    __extension__ typedef unsigned long long    UINT64;
    __extension__ typedef signed long long      INT64;
    #else
    typedef signed __int64                      INT64;
    typedef unsigned __int64                    UINT64;
    #endif
#else
    __extension__ typedef unsigned long long    UINT64;
    __extension__ typedef signed long long      INT64;
#endif

#define BS_REG_MAX          256
#define MAX_ERR_MSG         256
#define MAX_FILE_PATH       512

#ifndef _WINDEF_
    #define BOOL    int
#endif

#define FALSE   0
#define TRUE    1

enum DataAccess {SOC_WRITE = 0 , SOC_READ = 1, SOC_RW = 2};

/**
 *  Description: memory access unit
 */
enum BS_MEM_UNIT{
    BS_BYTE = 0,
    BS_HWORD= 1,
    BS_WORD = 2,
    BS_INVALID
};

// instruction type
enum BS_INST_TYPE {
    BS_INST_16BIT,
    BS_INST_32BIT,
    BS_INST_48BIT,
    BS_INST_INVALID
};

/**
 *  Description: register file, which contains all register values
 */
typedef struct{
    UINT32 regs[BS_REG_MAX];
}BS_REG_FILE;

#endif

