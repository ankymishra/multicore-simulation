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
    .half 416               ; Intra4x4PredModeBaseAddr
    .half 400               ; OutAddr
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

; start function (I4 Fake)
    {   MOVI.H R1, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R1, 0x005b                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R1                                |   NOP |   NOP |   NOP |   NOP }

; test if busy
    {   TEST P3, P4, 0xFFFF, 0x205b |   NOP |   NOP |   NOP |   NOP }

; wait for done (800 cycles)
; change CFU_Command to Waiting
    {   MOVI.H R2, 0x2000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R2, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R2                                |   NOP |   NOP |   NOP |   NOP }

    {   MOVI R3, 800                               |   NOP |   NOP |   NOP |   NOP }
    {   WAIT R3, 0xFFFF, 0x005b         |   NOP |   NOP |   NOP |   NOP }
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
{  MOVI.H R4, 0x0008  |  NOP  |  NOP  |  NOP  |  NOP  }
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
;.half   0x39ae

;Intra4x4PredMode:
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

