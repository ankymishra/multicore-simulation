;============================================================================================================================================================================================================================================================================================================================================
;               frame=32140  mbx=32  mby=21
;============================================================================================================================================================================================================================================================================================================================================
.data

; Raw Cb (+0)
.global InCbBaseAddr
.align 3
InCbBaseAddr:
  .byte   118,205,112,224,228,217,239,123
  .byte   179, 41,206,207,182,170, 59,148
  .byte   113,182,187,174, 79,248,195, 47
  .byte   171, 27,254,175, 86,222,107, 66
  .byte   212,190,144, 46,244, 30,153, 46
  .byte   166,191, 51, 88,200, 26,169, 16
  .byte    85, 12, 58,197, 96,230, 48, 62
  .byte    93,122,108, 25,  9,103,144, 47

; Raw Cr (+64)
.global InCrBaseAddr
.align 3
InCrBaseAddr:
  .byte    95,  5, 89,205,184, 89, 59,241
  .byte    56,164,165, 53,108, 42, 18,177
  .byte    97,225,151,159,136, 62,115,118
  .byte    88,122,234,180, 89,145,114,220
  .byte   249,143,108,223, 38,183, 77, 69
  .byte    73,164,110,137, 54, 51, 92,125
  .byte   206,229, 58, 47,227,249, 20,214
  .byte   253,144,210, 52, 51,178,119,229

; PreColPelCb (+128)
.global PreColPelCbBaseAddr
.align 3
PreColPelCbBaseAddr:
  .byte   0xfe,0x28,0x04,0x3d,0x46,0x1c,0xdd,0x01,0x3d,0x00,0x00,0x00,0x00,0x00,0x00,0x00

; PreColPelCr (+144)
.global PreColPelCrBaseAddr
.align 3
PreColPelCrBaseAddr:
  .byte   0x36,0x93,0xcc,0x11,0x45,0x3a,0x92,0x8e,0xd1,0x00,0x00,0x00,0x00,0x00,0x00,0x00

; PreRowPelCb (+160)
.global PreRowPelCbBaseAddr
.align 3
PreRowPelCbBaseAddr:
  .byte   0x73,0x53,0xd8,0x43,0xf0,0xf6,0x1e,0x87

; PreRowPelCr (+168)
.global PreRowPelCrBaseAddr
.align 3
PreRowPelCrBaseAddr:
  .byte   0x4f,0xe8,0x04,0xa7,0x68,0x51,0xf4,0x46

; input parameters (+176)
.global Input_Addr
.align 3
Input_Addr:
    .byte 0x00              ; Func_Mode             (0)
    .byte 0x0f              ; IntraRefAval          (15)
    .half 400               ; OutAddr
    .half 512               ; OutCbBaseAddr
    .half 640               ; OutCrBaseAddr
    .half 128               ; PreColPelCbBaseAddr
    .half 160               ; PreRowPelCbBaseAddr
    .half 144               ; PreColPelCrBaseAddr
    .half 168               ; PreRowPelCrBaseAddr
    .half 0                 ; InCbBaseAddr
    .half 64                ; InCbBaseAddr
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
{  MOVI.H R4, 0x0040  |  NOP  |  NOP  |  NOP  |  NOP  }
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

; store Input_Addr(Base+176) to ME (SR4-7 = CFU0-3, ME use SR6)
    {   MOVI R0, 0x800000b0                 |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R0                                |   NOP |   NOP |   NOP |   NOP }

; test if store success
    {   TEST P1, P2, 0xFFFF, 0x8000 |   NOP |   NOP |   NOP |   NOP }

; start function (MD Chroma)
    {   MOVI.H R1, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R1, 0x0059                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R1                                |   NOP |   NOP |   NOP |   NOP }

; test if busy
    {   TEST P3, P4, 0xFFFF, 0x2059 |   NOP |   NOP |   NOP |   NOP }

; wait for done (200 cycles)
; change CFU_Command to Waiting
    {   MOVI.H R2, 0x2000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R2, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R2                                |   NOP |   NOP |   NOP |   NOP }

    {   MOVI R3, 200                               |   NOP |   NOP |   NOP |   NOP }
    {   WAIT R3, 0xFFFF, 0x0059         |   NOP |   NOP |   NOP |   NOP }
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
{  MOVI.H R4, 0x0060  |  NOP  |  NOP  |  NOP  |  NOP  }
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
;IntraChromaPredMode:
;.byte   0x00

;.align 4
;OutCbBaseAddr:
;/* ResidualCb */
;.half      13,  100,    7,  119,   65,   54,   76,  -40
;.half      74,  -64,  101,  102,   19,    7, -104,  -15
;.half       8,   77,   82,   69,  -84,   85,   32, -116
;.half      66,  -78,  149,   70,  -77,   59,  -56,  -97
;.half     132,  110,   64,  -34,  123,  -91,   32,  -75
;.half      86,  111,  -29,    8,   79,  -95,   48, -105
;.half       5,  -68,  -22,  117,  -25,  109,  -73,  -59
;.half      13,   42,   28,  -55, -112,  -18,   23,  -74

;.align 4
;OutCrBaseAddr:
;/* ResidualCr */
;.half     -18, -108,  -24,   92,   59,  -36,  -66,  116
;.half     -57,   51,   52,  -60,  -17,  -83, -107,   52
;.half     -16,  112,   38,   46,   11,  -63,  -10,   -7
;.half     -25,    9,  121,   67,  -36,   20,  -11,   95
;.half     145,   39,    4,  119,  -76,   69,  -37,  -45
;.half     -31,   60,    6,   33,  -60,  -63,  -22,   11
;.half     102,  125,  -46,  -57,  113,  135,  -94,  100
;.half     149,   40,  106,  -52,  -63,   64,    5,  115

