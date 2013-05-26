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
  .byte  244, 152, 118, 199, 177, 170, 208, 229,  18, 130, 117, 137, 177,  90, 207, 236
; Pre-col (+272)
.global PreColPelYBaseAddr
.align 3
PreColPelYBaseAddr:
  .byte   69,  59, 203, 128, 117, 144, 175, 213, 115, 149, 206, 163, 170,  13, 122,   7,  10
; input parameters (+296)
.global Input_Addr
.align 3
Input_Addr:
    .byte 0x00              ; Func_Mode             (0)
    .byte 0x0f              ; IntraRefAval          (15)
    .half 400               ; Output_Addr
    .half 512               ; Output_YAddr
    .half 272               ; PreColPelYBaseAddr
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

; store Input_Addr(Base+296) to ME (SR4-7 = CFU0-3, ME use SR6)
    {   MOVI R0, 0x80000128                 |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R0                                |   NOP |   NOP |   NOP |   NOP }

; test if store success
    {   TEST P1, P2, 0xFFFF, 0x8000 |   NOP |   NOP |   NOP |   NOP }

; start function (MD I16)
    {   MOVI.H R1, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R1, 0x0041                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R1                                |   NOP |   NOP |   NOP |   NOP }

; test if busy
    {   TEST P3, P4, 0xFFFF, 0x2041 |   NOP |   NOP |   NOP |   NOP }

; wait for done (400 cycles)
; change CFU_Command to Waiting
    {   MOVI.H R2, 0x2000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R2, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R2                                |   NOP |   NOP |   NOP |   NOP }

    {   MOVI R3, 400                               |   NOP |   NOP |   NOP |   NOP }
    {   WAIT R3, 0xFFFF, 0x0041         |   NOP |   NOP |   NOP |   NOP }
{  NOP                     |  NOP  |  NOP  |  NOP  |  NOP  }


; test output if cannot dump memory
;set dma (store data to ddr)
;Parameter0 (bitstrem)
{  MOVI.L R3, 0x0070  |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R3, 0x1E05  |  NOP  |  NOP  |  NOP  |  NOP  }
;SAR
{  MOVI.L R4, 0x0190  |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R4, 0x1E00  |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R4, R3, 4+      |  NOP  |  NOP  |  NOP  |  NOP  }
;DAR
{  MOVI.L R4, 0x0190  |  NOP  |  NOP  |  NOP  |  NOP  }
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
{  MOVI.H R4, 0x00a0  |  NOP  |  NOP  |  NOP  |  NOP  }
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

;.align 4
;OutAddr:
;SAD:
;.half   0x411f

;Intra16x16PredMode:
;.byte   0x02

;.align 4
;OutYBaseAddr:
;OutYResidual:
;/* Residual */
;.half      10,   39,   45,  -27,  -81,  109, -115,  -73, -135,   86,   56,   32,    7,   -9, -144,   98
;.half      11, -101,  -90,   -4,   -9,    3,   81,   81,   89,   33,   61,   97,  -19,  -35,   50, -119
;.half    -106,  -15,    0,  -41,  -16,   31,   32,   -5,    8,  -21,  -82,  -95, -140,  -80, -106,   17
;.half     -35,  -50,  -97,  102,   99, -126,   73,   79,   53,   24,   66,  -76, -120,    6,  -49,  -80
;.half    -119,   98,   26,   11,   19,  -52, -103,  -83,   73,  -39,  -31,   79,   27,    9,  -14, -118
;.half     105,   35, -126,   94,   55,   93,   63,   -1,    8,   19,   69,   34,  -85,  -89,  100,  -58
;.half    -101,   16,  100,   64, -145, -113, -128,   74,   -6,  -13,   44,  -89, -114,  -80,  -61, -119
;.half     102,  -41, -135,   47,  -58,   75,  -64,   96,  -16, -104,   20,   46,  -47,   11, -122,   -2
;.half     -83, -132,  -48,  -82,  -99,  -30, -117,   41,  103,   73,   98, -121, -117,  -73,  -94, -125
;.half      32,  -82,   69, -135, -117, -105,  107,   13,  -63,   18,  -51,   36,  -81,  -26,  -76,  -18
;.half     -12,   23,   47,   36, -117,   76,  -33, -123,   39,  -44,  -98,   68,   29,  -45,   90,  -48
;.half      19,   49,  -37,   48,   90,  -40,  -49,  -82, -132,   47,  100,  -67,  -89,  -85,   62,   45
;.half      84,   -1,  -29, -143,  -35,   85, -120, -106,  -69,  -71,  108,  106,   30,   88,  -52,  -61
;.half      27,   57, -123,    8,  -92,  -26,   72,  -78,  -89,   62,    2,  -32, -133,  -46,  -96,   97
;.half      99,   21,  101,  -46,   -4, -129,   -6,   73,  -54,   -8,   70, -134,  -29,  -92,  -49, -112
;.half    -144,  -26,   42,  -90,   95,    4,  -22, -104,  -43, -130,   11,  -30,  -30,   61,  -42,  -41

