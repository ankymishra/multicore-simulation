;============================================================================================================================================================================================================================================================================================================================================
;               frame=23807  mbx=2  mby=2
;============================================================================================================================================================================================================================================================================================================================================
.data

; Residual Cb (+0)
.global InCbBaseAddr
.align 3
InCbBaseAddr:
  .half    -118, -118, -118, -118, -118, -118, -118, -118
  .half    -118, -118, -118, -118, -118, -118, -118, -118
  .half    -118, -118, -118, -118, -118, -118, -118, -118
  .half    -118, -118, -118, -118, -118, -118, -118, -118
  .half    -118, -118, -118, -118, -118, -118, -118, -118
  .half    -118, -118, -118, -118, -118, -118, -118, -118
  .half    -118, -118, -118, -118, -118, -118, -118, -118
  .half    -118, -118, -118, -118, -118, -118, -118, -118

; Residual Cr (+128)
.global InCrBaseAddr
.align 3
InCrBaseAddr:
  .half    -118, -118, -118, -118, -118, -118, -118, -118
  .half    -118, -118, -118, -118, -118, -118, -118, -118
  .half    -118, -118, -118, -118, -118, -118, -118, -118
  .half    -118, -118, -118, -118, -118, -118, -118, -118
  .half    -118, -118, -118, -118, -118, -118, -118, -118
  .half    -118, -118, -118, -118, -118, -118, -118, -118
  .half    -118, -118, -118, -118, -118, -118, -118, -118
  .half    -118, -118, -118, -118, -118, -118, -118, -118

; PreColPelCb (+256)
.global PreColPelCbBaseAddr
.align 3
PreColPelCbBaseAddr:
  .byte   0x3c,0x14,0x14,0x14,0x14,0x14,0x14,0x14,0x14,0x00,0x00,0x00,0x00,0x00,0x00,0x00

; PreColPelCr (+272)
.global PreColPelCrBaseAddr
.align 3
PreColPelCrBaseAddr:
  .byte   0x3c,0x14,0x14,0x14,0x14,0x14,0x14,0x14,0x14,0x00,0x00,0x00,0x00,0x00,0x00,0x00

; PreRowPelCb (+288)
.global PreRowPelCbBaseAddr
.align 3
PreRowPelCbBaseAddr:
  .byte   0x0a,0x0a,0x0a,0x0a,0x0a,0x0a,0x0a,0x0a

; PreRowPelCr (+296)
.global PreRowPelCrBaseAddr
.align 3
PreRowPelCrBaseAddr:
  .byte   0x0a,0x0a,0x0a,0x0a,0x0a,0x0a,0x0a,0x0a

; input parameters (+304)
.global Input_Addr
.align 3
Input_Addr:
    .byte 0x00              ; Func_Mode             (0)
    .byte 0x00              ; IntraRefAval          (0)
    .half 0x0000            ; IntraChromaPredMode   (0)
    .half 512               ; OutCbBaseAddr
    .half 576               ; OutCrBaseAddr
    .half 0xffff            ; CBP_Cb
    .half 0xffff            ; CBP_Cr
    .half 256               ; PreColPelCbBaseAddr
    .half 288               ; PreRowPelCbBaseAddr
    .half 272               ; PreColPelCrBaseAddr
    .half 296               ; PreRowPelCrBaseAddr
    .half 0                 ; InCbBaseAddr
    .half 128               ; InCbBaseAddr
.text
; set CFU_Info_Sel(SR13) according to interested

    {   MOVI.L SR13, 2                          |   NOP |   NOP |   NOP |   NOP }

; store Input_Addr(Base+304) to ME (SR4-7 = CFU0-3, ME use SR6)
    {   MOVI R0, 0x80000130                 |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R0                                |   NOP |   NOP |   NOP |   NOP }

; test if store success
    {   TEST P1, P2, 0xFFFF, 0x8000 |   NOP |   NOP |   NOP |   NOP }

; start function (Reconstruct Chroma)
    {   MOVI.H R1, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R1, 0x005a                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R1                                |   NOP |   NOP |   NOP |   NOP }

; test if busy
    {   TEST P3, P4, 0xFFFF, 0x205a |   NOP |   NOP |   NOP |   NOP }

; wait for done (100 cycles)
; change CFU_Command to Waiting
    {   MOVI.H R2, 0x2000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R2, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R2                                |   NOP |   NOP |   NOP |   NOP }

    {   MOVI R3, 100                               |   NOP |   NOP |   NOP |   NOP }
    {   WAIT R3, 0xFFFF, 0x005a         |   NOP |   NOP |   NOP |   NOP }

; test output if cannot dump memory

; trap
    {   NOP                         |   NOP |   NOP |   NOP |   NOP }
    {   NOP                         |   NOP |   NOP |   NOP |   NOP }
    {   NOP                         |   NOP |   NOP |   NOP |   NOP }
    {   NOP                         |   NOP |   NOP |   NOP |   NOP }
    { TRAP                      |   NOP |   NOP |   NOP |   NOP }

; values to be checked
;.align 4
;OutCbBaseAddr:
;/* ReconstructCb */
;.byte    10, 10, 10, 10, 10, 10, 10, 10
;.byte    10, 10, 10, 10, 10, 10, 10, 10
;.byte    10, 10, 10, 10, 10, 10, 10, 10
;.byte    10, 10, 10, 10, 10, 10, 10, 10
;.byte    10, 10, 10, 10, 10, 10, 10, 10
;.byte    10, 10, 10, 10, 10, 10, 10, 10
;.byte    10, 10, 10, 10, 10, 10, 10, 10
;.byte    10, 10, 10, 10, 10, 10, 10, 10

;.align 4
;OutCrBaseAddr:
;/* ReconstructCr */
;.byte    10, 10, 10, 10, 10, 10, 10, 10
;.byte    10, 10, 10, 10, 10, 10, 10, 10
;.byte    10, 10, 10, 10, 10, 10, 10, 10
;.byte    10, 10, 10, 10, 10, 10, 10, 10
;.byte    10, 10, 10, 10, 10, 10, 10, 10
;.byte    10, 10, 10, 10, 10, 10, 10, 10
;.byte    10, 10, 10, 10, 10, 10, 10, 10
;.byte    10, 10, 10, 10, 10, 10, 10, 10

