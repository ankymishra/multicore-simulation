;============================================================================================================================================================================================================================================================================================================================================
;               frame=32140  mbx=32  mby=21
;============================================================================================================================================================================================================================================================================================================================================
.data

; Raw Y (+0)
.global InYBaseAddr
.align 3
InYBaseAddr:
  .byte    156, 185, 191, 119,  65, 255,  31,  73,  11, 232, 202, 178, 153, 137,   2, 244
  .byte    157,  45,  56, 142, 137, 149, 227, 227, 235, 179, 207, 243, 127, 111, 196,  27
  .byte     40, 131, 146, 105, 130, 177, 178, 141, 154, 125,  64,  51,   6,  66,  40, 163
  .byte    111,  96,  49, 248, 245,  20, 219, 225, 199, 170, 212,  70,  26, 152,  97,  66
  .byte     27, 244, 172, 157, 165,  94,  43,  63, 219, 107, 115, 225, 173, 155, 132,  28
  .byte    251, 181,  20, 240, 201, 239, 209, 145, 154, 165, 215, 180,  61,  57, 246,  88
  .byte     45, 162, 246, 210,   1,  33,  18, 220, 140, 133, 190,  57,  32,  66,  85,  27
  .byte    248, 105,  11, 193,  88, 221,  82, 242, 130,  42, 166, 192,  99, 157,  24, 144
  .byte     63,  14,  98,  64,  47, 116,  29, 187, 249, 219, 244,  25,  29,  73,  52,  21
  .byte    178,  64, 215,  11,  29,  41, 253, 159,  83, 164,  95, 182,  65, 120,  70, 128
  .byte    134, 169, 193, 182,  29, 222, 113,  23, 185, 102,  48, 214, 175, 101, 236,  98
  .byte    165, 195, 109, 194, 236, 106,  97,  64,  14, 193, 246,  79,  57,  61, 208, 191
  .byte    230, 145, 117,   3, 111, 231,  26,  40,  77,  75, 254, 252, 176, 234,  94,  85
  .byte    173, 203,  23, 154,  54, 120, 218,  68,  57, 208, 148, 114,  13, 100,  50, 243
  .byte    245, 167, 247, 100, 142,  17, 140, 219,  92, 138, 216,  12, 117,  54,  97,  34
  .byte      2, 120, 188,  56, 241, 150, 124,  42, 103,  16, 157, 116, 116, 207, 104, 105

; Pre-row (+256)
.global PreRowPelYBaseAddr
.align 3
PreRowPelYBaseAddr:
  .byte  244, 152, 118, 199, 177, 170, 208, 229,  18, 130, 117, 137, 177,  90, 207, 236,  37,  79,  97, 181,   0,   0,   0,   0
; Pre-col (+280)
.global PreColPelYBaseAddr
.align 3
PreColPelYBaseAddr:
  .byte   69,  59, 203, 128, 117, 144, 175, 213, 115, 149, 206, 163, 170,  13, 122,   7,  10,   0,   0,   0,   0,   0,   0,   0
; input parameters (+304)
.global Input_Addr
.align 3
Input_Addr:
    .byte 0x00              ; Func_Mode             (0)
    .byte 0x0f              ; IntraRefAval          (15)
    .half 320               ; Intra4x4PredModeBaseAddr
    .half 1336              ; OutAddr
    .half 568               ; OutYBaseAddr
    .half 824               ; YResidualBaseAddr
    .half 280               ; PreColPelYBaseAddr
    .half 256               ; PreRowPelYBaseAddr
    .half 0                 ; InYBaseAddr
.text

;set dma (load data to dmem)
;Parameter0 (parameters)
{  MOVI.L R3, 0x0070  |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R3, 0x1E05  |  NOP  |  NOP  |  NOP  |  NOP  }
;SAR (Source)
{  MOVI.L R4, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R4, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R4, R3, 4+      |  NOP  |  NOP  |  NOP  |  NOP  }
;DAR (Destination)
{  MOVI.L R4, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R4, 0x1E00  |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R4, R3, 4+      |  NOP  |  NOP  |  NOP  |  NOP  }
;SGR
{  MOVI.L R4, 0x0007  |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R4, 0x00A0  |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R4, R3, 4+      |  NOP  |  NOP  |  NOP  |  NOP  }
;DSR
{  MOVI.L R4, 0x0004  |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R4, 0x0050  |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R4, R3, 4+      |  NOP  |  NOP  |  NOP  |  NOP  }
;CTL (Size)
{  MOVI.L R4, 0x0002  |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R4, 0x0050  |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R4, R3, 4+      |  NOP  |  NOP  |  NOP  |  NOP  }
;EN
{  MOVI.L R4, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R4, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R4, R3, 4+      |  NOP  |  NOP  |  NOP  |  NOP  }

;Check DMA Done
{  MOVI.L R5, 0x0054       |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R5, 0x1E05       |  NOP  |  NOP  |  NOP  |  NOP  }
Label2:
{  LW R6, R5, 0            |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                     |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                     |  NOP  |  NOP  |  NOP  |  NOP  }
{  SEQI R7, P1, P2, R6, 0  |  NOP  |  NOP  |  NOP  |  NOP  }
{  (P2)B Label2           |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                     |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                     |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                     |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                     |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                     |  NOP  |  NOP  |  NOP  |  NOP  }

; set CFU_Info_Sel(SR13) according to interested

    {   MOVI.L SR13, 2                          |   NOP |   NOP |   NOP |   NOP }

; store Input_Addr(Base+304) to ME (SR4-7 = CFU0-3, ME use SR6)
    {   MOVI R0, 0x80000130                 |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R0                                |   NOP |   NOP |   NOP |   NOP }

; test if store success
    {   TEST P1, P2, 0xFFFF, 0x8000 |   NOP |   NOP |   NOP |   NOP }

; start function (I4 real)
    {   MOVI.H R1, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R1, 0x0090                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R1                                |   NOP |   NOP |   NOP |   NOP }

; test if busy
    {   TEST P3, P4, 0xFFFF, 0x2090 |   NOP |   NOP |   NOP |   NOP }

; change CFU_Command to Waiting
    {   MOVI.H R2, 0x2000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R2, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R2                                |   NOP |   NOP |   NOP |   NOP }

    {   MOVI R3, 200                               |   NOP |   NOP |   NOP |   NOP }
    {   WAIT R3, 0xFFFF, 0x0090         |   NOP |   NOP |   NOP |   NOP }

    {   NOP                         |   NOP |   NOP |   NOP |   NOP }
;=======================================================================================
; phase 0
;=======================================================================================
; start function (I4 real)
    {   MOVI.H R1, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R1, 0x00a0                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R1                                |   NOP |   NOP |   NOP |   NOP }

; test if busy
    {   TEST P3, P4, 0xFFFF, 0x20a0 |   NOP |   NOP |   NOP |   NOP }

; wait for Phase 0 done (200 cycles)
; change CFU_Command to Waiting
    {   MOVI.H R2, 0x2000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R2, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R2                                |   NOP |   NOP |   NOP |   NOP }

    {   MOVI R3, 200                               |   NOP |   NOP |   NOP |   NOP }
    {   WAIT R3, 0xFFFF, 0x00a0         |   NOP |   NOP |   NOP |   NOP }

    {   NOP                         |   NOP |   NOP |   NOP |   NOP }
;=======================================================================================
; phase 1
;=======================================================================================
; start function (I4 real)
    {   MOVI.H R1, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R1, 0x00a1                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R1                                |   NOP |   NOP |   NOP |   NOP }

; test if busy
    {   TEST P3, P4, 0xFFFF, 0x20a1 |   NOP |   NOP |   NOP |   NOP }

; wait for Phase 1 done (200 cycles)
; change CFU_Command to Waiting
    {   MOVI.H R2, 0x2000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R2, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R2                                |   NOP |   NOP |   NOP |   NOP }

    {   MOVI R3, 200                               |   NOP |   NOP |   NOP |   NOP }
    {   WAIT R3, 0xFFFF, 0x00a1         |   NOP |   NOP |   NOP |   NOP }

    {   NOP                         |   NOP |   NOP |   NOP |   NOP }
;=======================================================================================
; phase 2
;=======================================================================================
; start function (I4 real)
    {   MOVI.H R1, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R1, 0x00a2                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R1                                |   NOP |   NOP |   NOP |   NOP }

; test if busy
    {   TEST P3, P4, 0xFFFF, 0x20a2 |   NOP |   NOP |   NOP |   NOP }

; wait for Phase 2 done (200 cycles)
; change CFU_Command to Waiting
    {   MOVI.H R2, 0x2000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R2, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R2                                |   NOP |   NOP |   NOP |   NOP }

    {   MOVI R3, 200                               |   NOP |   NOP |   NOP |   NOP }
    {   WAIT R3, 0xFFFF, 0x00a2         |   NOP |   NOP |   NOP |   NOP }

    {   NOP                         |   NOP |   NOP |   NOP |   NOP }
;=======================================================================================
; phase 4
;=======================================================================================
; start function (I4 real)
    {   MOVI.H R1, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R1, 0x00a4                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R1                                |   NOP |   NOP |   NOP |   NOP }

; test if busy
    {   TEST P3, P4, 0xFFFF, 0x20a4 |   NOP |   NOP |   NOP |   NOP }

; wait for Phase 4 done (200 cycles)
; change CFU_Command to Waiting
    {   MOVI.H R2, 0x2000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R2, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R2                                |   NOP |   NOP |   NOP |   NOP }

    {   MOVI R3, 200                               |   NOP |   NOP |   NOP |   NOP }
    {   WAIT R3, 0xFFFF, 0x00a4         |   NOP |   NOP |   NOP |   NOP }

    {   NOP                         |   NOP |   NOP |   NOP |   NOP }
;=======================================================================================
; phase 3
;=======================================================================================
; start function (I4 real)
    {   MOVI.H R1, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R1, 0x00a3                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R1                                |   NOP |   NOP |   NOP |   NOP }

; test if busy
    {   TEST P3, P4, 0xFFFF, 0x20a3 |   NOP |   NOP |   NOP |   NOP }

; wait for Phase 3 done (200 cycles)
; change CFU_Command to Waiting
    {   MOVI.H R2, 0x2000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R2, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R2                                |   NOP |   NOP |   NOP |   NOP }

    {   MOVI R3, 200                               |   NOP |   NOP |   NOP |   NOP }
    {   WAIT R3, 0xFFFF, 0x00a3         |   NOP |   NOP |   NOP |   NOP }

    {   NOP                         |   NOP |   NOP |   NOP |   NOP }
;=======================================================================================
; phase 5
;=======================================================================================
; start function (I4 real)
    {   MOVI.H R1, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R1, 0x00a5                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R1                                |   NOP |   NOP |   NOP |   NOP }

; test if busy
    {   TEST P3, P4, 0xFFFF, 0x20a5 |   NOP |   NOP |   NOP |   NOP }

; wait for Phase 5 done (200 cycles)
; change CFU_Command to Waiting
    {   MOVI.H R2, 0x2000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R2, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R2                                |   NOP |   NOP |   NOP |   NOP }

    {   MOVI R3, 200                               |   NOP |   NOP |   NOP |   NOP }
    {   WAIT R3, 0xFFFF, 0x00a5         |   NOP |   NOP |   NOP |   NOP }

    {   NOP                         |   NOP |   NOP |   NOP |   NOP }
;=======================================================================================
; phase 8
;=======================================================================================
; start function (I4 real)
    {   MOVI.H R1, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R1, 0x00a8                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R1                                |   NOP |   NOP |   NOP |   NOP }

; test if busy
    {   TEST P3, P4, 0xFFFF, 0x20a8 |   NOP |   NOP |   NOP |   NOP }

; wait for Phase 8 done (200 cycles)
; change CFU_Command to Waiting
    {   MOVI.H R2, 0x2000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R2, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R2                                |   NOP |   NOP |   NOP |   NOP }

    {   MOVI R3, 200                               |   NOP |   NOP |   NOP |   NOP }
    {   WAIT R3, 0xFFFF, 0x00a8         |   NOP |   NOP |   NOP |   NOP }

    {   NOP                         |   NOP |   NOP |   NOP |   NOP }
;=======================================================================================
; phase 6
;=======================================================================================
; start function (I4 real)
    {   MOVI.H R1, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R1, 0x00a6                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R1                                |   NOP |   NOP |   NOP |   NOP }

; test if busy
    {   TEST P3, P4, 0xFFFF, 0x20a6 |   NOP |   NOP |   NOP |   NOP }

; wait for Phase 6 done (200 cycles)
; change CFU_Command to Waiting
    {   MOVI.H R2, 0x2000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R2, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R2                                |   NOP |   NOP |   NOP |   NOP }

    {   MOVI R3, 200                               |   NOP |   NOP |   NOP |   NOP }
    {   WAIT R3, 0xFFFF, 0x00a6         |   NOP |   NOP |   NOP |   NOP }

    {   NOP                         |   NOP |   NOP |   NOP |   NOP }
;=======================================================================================
; phase 9
;=======================================================================================
; start function (I4 real)
    {   MOVI.H R1, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R1, 0x00a9                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R1                                |   NOP |   NOP |   NOP |   NOP }

; test if busy
    {   TEST P3, P4, 0xFFFF, 0x20a9 |   NOP |   NOP |   NOP |   NOP }

; wait for Phase 9 done (200 cycles)
; change CFU_Command to Waiting
    {   MOVI.H R2, 0x2000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R2, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R2                                |   NOP |   NOP |   NOP |   NOP }

    {   MOVI R3, 200                               |   NOP |   NOP |   NOP |   NOP }
    {   WAIT R3, 0xFFFF, 0x00a9         |   NOP |   NOP |   NOP |   NOP }

    {   NOP                         |   NOP |   NOP |   NOP |   NOP }
;=======================================================================================
; phase 7
;=======================================================================================
; start function (I4 real)
    {   MOVI.H R1, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R1, 0x00a7                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R1                                |   NOP |   NOP |   NOP |   NOP }

; test if busy
    {   TEST P3, P4, 0xFFFF, 0x20a7 |   NOP |   NOP |   NOP |   NOP }

; wait for Phase 7 done (200 cycles)
; change CFU_Command to Waiting
    {   MOVI.H R2, 0x2000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R2, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R2                                |   NOP |   NOP |   NOP |   NOP }

    {   MOVI R3, 200                               |   NOP |   NOP |   NOP |   NOP }
    {   WAIT R3, 0xFFFF, 0x00a7         |   NOP |   NOP |   NOP |   NOP }

    {   NOP                         |   NOP |   NOP |   NOP |   NOP }
;=======================================================================================
; phase 10
;=======================================================================================
; start function (I4 real)
    {   MOVI.H R1, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R1, 0x00aa                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R1                                |   NOP |   NOP |   NOP |   NOP }

; test if busy
    {   TEST P3, P4, 0xFFFF, 0x20aa |   NOP |   NOP |   NOP |   NOP }

; wait for Phase 10 done (200 cycles)
; change CFU_Command to Waiting
    {   MOVI.H R2, 0x2000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R2, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R2                                |   NOP |   NOP |   NOP |   NOP }

    {   MOVI R3, 200                               |   NOP |   NOP |   NOP |   NOP }
    {   WAIT R3, 0xFFFF, 0x00aa         |   NOP |   NOP |   NOP |   NOP }

    {   NOP                         |   NOP |   NOP |   NOP |   NOP }
;=======================================================================================
; phase 12
;=======================================================================================
; start function (I4 real)
    {   MOVI.H R1, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R1, 0x00ac                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R1                                |   NOP |   NOP |   NOP |   NOP }

; test if busy
    {   TEST P3, P4, 0xFFFF, 0x20ac |   NOP |   NOP |   NOP |   NOP }

; wait for Phase 12 done (200 cycles)
; change CFU_Command to Waiting
    {   MOVI.H R2, 0x2000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R2, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R2                                |   NOP |   NOP |   NOP |   NOP }

    {   MOVI R3, 200                               |   NOP |   NOP |   NOP |   NOP }
    {   WAIT R3, 0xFFFF, 0x00ac         |   NOP |   NOP |   NOP |   NOP }

    {   NOP                         |   NOP |   NOP |   NOP |   NOP }
;=======================================================================================
; phase 11
;=======================================================================================
; start function (I4 real)
    {   MOVI.H R1, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R1, 0x00ab                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R1                                |   NOP |   NOP |   NOP |   NOP }

; test if busy
    {   TEST P3, P4, 0xFFFF, 0x20ab |   NOP |   NOP |   NOP |   NOP }

; wait for Phase 11 done (200 cycles)
; change CFU_Command to Waiting
    {   MOVI.H R2, 0x2000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R2, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R2                                |   NOP |   NOP |   NOP |   NOP }

    {   MOVI R3, 200                               |   NOP |   NOP |   NOP |   NOP }
    {   WAIT R3, 0xFFFF, 0x00ab         |   NOP |   NOP |   NOP |   NOP }

    {   NOP                         |   NOP |   NOP |   NOP |   NOP }
;=======================================================================================
; phase 13
;=======================================================================================
; start function (I4 real)
    {   MOVI.H R1, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R1, 0x00ad                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R1                                |   NOP |   NOP |   NOP |   NOP }

; test if busy
    {   TEST P3, P4, 0xFFFF, 0x20ad |   NOP |   NOP |   NOP |   NOP }

; wait for Phase 13 done (200 cycles)
; change CFU_Command to Waiting
    {   MOVI.H R2, 0x2000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R2, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R2                                |   NOP |   NOP |   NOP |   NOP }

    {   MOVI R3, 200                               |   NOP |   NOP |   NOP |   NOP }
    {   WAIT R3, 0xFFFF, 0x00ad         |   NOP |   NOP |   NOP |   NOP }

    {   NOP                         |   NOP |   NOP |   NOP |   NOP }
;=======================================================================================
; phase 14
;=======================================================================================
; start function (I4 real)
    {   MOVI.H R1, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R1, 0x00ae                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R1                                |   NOP |   NOP |   NOP |   NOP }

; test if busy
    {   TEST P3, P4, 0xFFFF, 0x20ae |   NOP |   NOP |   NOP |   NOP }

; wait for Phase 14 done (200 cycles)
; change CFU_Command to Waiting
    {   MOVI.H R2, 0x2000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R2, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R2                                |   NOP |   NOP |   NOP |   NOP }

    {   MOVI R3, 200                               |   NOP |   NOP |   NOP |   NOP }
    {   WAIT R3, 0xFFFF, 0x00ae         |   NOP |   NOP |   NOP |   NOP }

    {   NOP                         |   NOP |   NOP |   NOP |   NOP }
;=======================================================================================
; phase 15
;=======================================================================================
; start function (I4 real)
    {   MOVI.H R1, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R1, 0x00af                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R1                                |   NOP |   NOP |   NOP |   NOP }

; test if busy
    {   TEST P3, P4, 0xFFFF, 0x20af |   NOP |   NOP |   NOP |   NOP }

; wait for Phase 15 done (200 cycles)
; change CFU_Command to Waiting
    {   MOVI.H R2, 0x2000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R2, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R2                                |   NOP |   NOP |   NOP |   NOP }

    {   MOVI R3, 200                               |   NOP |   NOP |   NOP |   NOP }
    {   WAIT R3, 0xFFFF, 0x00af         |   NOP |   NOP |   NOP |   NOP }

    {   NOP                         |   NOP |   NOP |   NOP |   NOP }
{  NOP                     |  NOP  |  NOP  |  NOP  |  NOP  }


; test output if cannot dump memory
;set dma (store data to ddr)
;Parameter0 (bitstrem)
{  MOVI.L R3, 0x0070  |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R3, 0x1E05  |  NOP  |  NOP  |  NOP  |  NOP  }
;SAR
{  MOVI.L R4, 0x0140  |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R4, 0x1E00  |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R4, R3, 4+      |  NOP  |  NOP  |  NOP  |  NOP  }
;DAR
{  MOVI.L R4, 0x0140  |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R4, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R4, R3, 4+      |  NOP  |  NOP  |  NOP  |  NOP  }
;SGR
{  MOVI.L R4, 0x0007  |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R4, 0x00A0  |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R4, R3, 4+      |  NOP  |  NOP  |  NOP  |  NOP  }
;DSR
{  MOVI.L R4, 0x0004  |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R4, 0x0050  |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R4, R3, 4+      |  NOP  |  NOP  |  NOP  |  NOP  }
;CTL
{  MOVI.L R4, 0x0012  |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R4, 0x0100  |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R4, R3, 4+      |  NOP  |  NOP  |  NOP  |  NOP  }
;EN
{  MOVI.L R4, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R4, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R4, R3, 4+      |  NOP  |  NOP  |  NOP  |  NOP  }

;Check DMA Done
{  MOVI.L R5, 0x0054       |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R5, 0x1E05       |  NOP  |  NOP  |  NOP  |  NOP  }
Label3:
{  LW R6, R5, 0            |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                     |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                     |  NOP  |  NOP  |  NOP  |  NOP  }
{  SEQI R7, P1, P2, R6, 0  |  NOP  |  NOP  |  NOP  |  NOP  }
{  (P2)B Label3           |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                     |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                     |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                     |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                     |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                     |  NOP  |  NOP  |  NOP  |  NOP  }
; trap
    {   NOP                         |   NOP |   NOP |   NOP |   NOP }
    {   NOP                         |   NOP |   NOP |   NOP |   NOP }
    {   NOP                         |   NOP |   NOP |   NOP |   NOP }
    {   NOP                         |   NOP |   NOP |   NOP |   NOP }
    { TRAP                      |   NOP |   NOP |   NOP |   NOP }

; values to be checked
; Intra4x4PredModeBaseAddr (+320)
;Intra4x4PredModeBaseAddr:
;.byte   0x05
;.byte   0x08
;.byte   0x08
;.byte   0x04
;.byte   0x01
;.byte   0x08
;.byte   0x02
;.byte   0x03
;.byte   0x01
;.byte   0x06
;.byte   0x05
;.byte   0x04
;.byte   0x06
;.byte   0x07
;.byte   0x02
;.byte   0x08

;  /* OutYReconstructed */
;  .byte    156, 185, 191, 119,  65, 255,  31,  73,  11, 232, 202, 178, 153, 137,   2, 244
;  .byte    157,  45,  56, 142, 137, 149, 227, 227, 235, 179, 207, 243, 127, 111, 196,  27
;  .byte     40, 131, 146, 105, 130, 177, 178, 141, 154, 125,  64,  51,   6,  66,  40, 163
;  .byte    111,  96,  49, 248, 245,  20, 219, 225, 199, 170, 212,  70,  26, 152,  97,  66
;  .byte     27, 244, 172, 157, 165,  94,  43,  63, 219, 107, 115, 225, 173, 155, 132,  28
;  .byte    251, 181,  20, 240, 201, 239, 209, 145, 154, 165, 215, 180,  61,  57, 246,  88
;  .byte     45, 162, 246, 210,   1,  33,  18, 220, 140, 133, 190,  57,  32,  66,  85,  27
;  .byte    248, 105,  11, 193,  88, 221,  82, 242, 130,  42, 166, 192,  99, 157,  24, 144
;  .byte     63,  14,  98,  64,  47, 116,  29, 187, 249, 219, 244,  25,  29,  73,  52,  21
;  .byte    178,  64, 215,  11,  29,  41, 253, 159,  83, 164,  95, 182,  65, 120,  70, 128
;  .byte    134, 169, 193, 182,  29, 222, 113,  23, 185, 102,  48, 214, 175, 101, 236,  98
;  .byte    165, 195, 109, 194, 236, 106,  97,  64,  14, 193, 246,  79,  57,  61, 208, 191
;  .byte    230, 145, 117,   3, 111, 231,  26,  40,  77,  75, 254, 252, 176, 234,  94,  85
;  .byte    173, 203,  23, 154,  54, 120, 218,  68,  57, 208, 148, 114,  13, 100,  50, 243
;  .byte    245, 167, 247, 100, 142,  17, 140, 219,  92, 138, 216,  12, 117,  54,  97,  34
;  .byte      2, 120, 188,  56, 241, 150, 124,  42, 103,  16, 157, 116, 116, 207, 104, 105
;  /* Residual Y */
;  .half      29,  -13,   56,  -40,  -66,  128,  -93,  -77,  -62,  159,  129,  105,  -58,  -42, -145,  140
;  .half      74, -118, -111,   -5,   13,   -1,   50,   15,    8,  -48,  -20,   16,  -20,    7,  135,  -38
;  .half     -12,    4,  -52,  -30,  -47,  -35,  -70, -107,   13,  -16,  -77,  -90,  -55,    1,  -30,   93
;  .half      13,   13, -114,   81,   -3, -228,  -29,  -23,  -26,  -55,  -13, -155,  -44,   82,   27,   -4
;  .half    -104,   99,   12,  -20,  -60,  -96,  -83, -108,   54,  -58,  -50,   60,   66,   52,   58,  -38
;  .half      91,    4, -174,   36,    0,   14,   19,   19,  -11,    0,   50,   15,  -42,  -17,  180,   22
;  .half    -149,  -42,   33,   -3, -211, -168, -207,   30,  -25,  -32,   25, -108,  -42,    0,   19,  -39
;  .half      35, -108, -202,  -20, -125,    9, -119,   17,  -35, -123,    1,   27,   33,   91,  -42,   78
;  .half     -52, -101,  -17,  -51,  -82,  -19, -119,   34,   34,   19,  108,  -70,  -99,  -18,  -32, -123
;  .half      29,  -85,   66, -138,   -9,  -42,  124,   24,  -90,  -30, -120,  -18,  -44,   33,  -44,  -16
;  .half     -72,  -37,  -13,  -24,  -68,  155,   75,  -60,   94,  -30, -125,   20,   84,   17,   92,  -46
;  .half       2,   32,  -54,   31,   48,  -36,    0,   -3,  -30,  126,  155,  -53,  -30,  -53,   64,   47
;  .half      66,  -35,  -35, -149,  -46,   38, -110,  -51,  -36,  -38,  141,  139,   -7,  111,   31,   21
;  .half       8,   31, -143,    2,  -35,  -37,   25,  -68,  -56,   95,   35,    1,  -50,   36,  -14,  153
;  .half     116,    3,   67,  -52,   39,  -72,  -17,   26,  -21,   25,  103, -101,   53,  -36,  -19,  -82
;  .half     -78,  -45,   16, -110,  138,   47,   35, -115,  -10,  -97,   44,    3,    0,   91,  -12,  -11

;  /* SAD */
;.half   0x39ae
