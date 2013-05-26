;============================================================================================================================================================================================================================================================================================================================================
;               frame=37681  mbx=2  mby=2
;============================================================================================================================================================================================================================================================================================================================================
.data

; Residual Y (+0)
.global InYBaseAddr
.align 3
InYBaseAddr:
  .half    -113, -113, -113, -113,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0
  .half    -113, -113, -113, -113,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0
  .half    -113, -113, -113, -113,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0
  .half    -113, -113, -113, -113,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0
  .half       0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0
  .half       0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0
  .half       0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0
  .half       0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0
  .half       0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0
  .half       0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0
  .half       0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0
  .half       0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0
  .half       0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0
  .half       0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0
  .half       0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0
  .half       0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0

; Pre-row (+512)
.global PreRowPelYBaseAddr
.align 3
PreRowPelYBaseAddr:
  .byte   10,  10,  10,  10,  10,  10,  10,  10,  10,  10,  10,  10,  10,  10,  10,  10,  10,  10,  10,  10,   0,   0,   0,   0
; Pre-col (+536)
.global PreColPelYBaseAddr
.align 3
PreColPelYBaseAddr:
  .byte   20,  20,  20,  20,  20,  20,  20,  20,  20,  20,  20,  20,  20,  20,  20,  20,  20,   0,   0,   0,   0,   0,   0,   0

; Intra4x4PredModeBaseAddr (+560)
.global Intra4x4PredModeBaseAddr
.align 3
Intra4x4PredModeBaseAddr:
.byte   0x02
.byte   0x01
.byte   0x00
.byte   0x00
.byte   0x01
.byte   0x01
.byte   0x00
.byte   0x00
.byte   0x00
.byte   0x00
.byte   0x00
.byte   0x00
.byte   0x00
.byte   0x00
.byte   0x00
.byte   0x00

; input parameters (+576)
.global Input_Addr
.align 3
Input_Addr:
    .byte 0x00              ; Func_Mode             (0)
    .byte 0x00              ; IntraRefAval          (0)
    .half 560               ; Intra4x4PredModeBaseAddr
    .half 600               ; OutAddr
    .half 0xffff            ; CBP
    .half 536               ; PreColPelYBaseAddr
    .half 512               ; PreRowPelYBaseAddr
    .half 0                 ; InYBaseAddr
.text
; set CFU_Info_Sel(SR13) according to interested

    {   MOVI.L SR13, 2                          |   NOP |   NOP |   NOP |   NOP }

; store Input_Addr(Base+576) to ME (SR4-7 = CFU0-3, ME use SR6)
    {   MOVI R0, 0x00000240                 |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R0                                |   NOP |   NOP |   NOP |   NOP }

; test if store success
    {   TEST P1, P2, 0xFFFF, 0x8000 |   NOP |   NOP |   NOP |   NOP }

; start function (decode I4 reconstruct)
    {   MOVI.H R1, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R1, 0x0060                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R1                                |   NOP |   NOP |   NOP |   NOP }

; test if busy
    {   TEST P3, P4, 0xFFFF, 0x2060 |   NOP |   NOP |   NOP |   NOP }

; wait for done (2000 cycles)
; change CFU_Command to Waiting
    {   MOVI.H R2, 0x2000                       |   NOP |   NOP |   NOP |   NOP }
    {   MOVI.L R2, 0x0000                       |   NOP |   NOP |   NOP |   NOP }
    {   COPY SR6, R2                                |   NOP |   NOP |   NOP |   NOP }

    {   MOVI R3, 2000                               |   NOP |   NOP |   NOP |   NOP }
    {   WAIT R3, 0xFFFF, 0x0060         |   NOP |   NOP |   NOP |   NOP }

; test output if cannot dump memory

; trap
    {   NOP                         |   NOP |   NOP |   NOP |   NOP }
    {   NOP                         |   NOP |   NOP |   NOP |   NOP }
    {   NOP                         |   NOP |   NOP |   NOP |   NOP }
    {   NOP                         |   NOP |   NOP |   NOP |   NOP }
    { TRAP                      |   NOP |   NOP |   NOP |   NOP }

; values to be checked

;.align 4
;  /* OutYReconstructed */
;  .byte     15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15
;  .byte     15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15
;  .byte     15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15
;  .byte     15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15
;  .byte     15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15
;  .byte     15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15
;  .byte     15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15
;  .byte     15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15
;  .byte     15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15
;  .byte     15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15
;  .byte     15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15
;  .byte     15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15
;  .byte     15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15
;  .byte     15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15
;  .byte     15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15
;  .byte     15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15
