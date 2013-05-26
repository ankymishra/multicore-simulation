;;---------------------- To Verify ---------------------------
;;DMA Transfer : M1 Bank0 -> M2 Bank0 and M2 Bank0 -> M1 Bank0
;;------------------------------------------------------------

;;PACDSP CORE0 DMA SETTING
 PACDSP_M1_DMA_SAR0 = 0x2405C070
 PACDSP_M1_DMA_DAR0 = 0x2405C074
 PACDSP_M1_DMA_SGR0 = 0x2405C078
 PACDSP_M1_DMA_DSR0 = 0x2405C07C
 PACDSP_M1_DMA_CTL0 = 0x2405C080
 PACDSP_M1_DMA_ENA0 = 0x2405C084
 PACDSP_M1_DMA_CLR0 = 0x2405C088
 
 PACDSP_M1_DMA_STAT = 0x2405C054
 
;;PACDSP CORE0 DMA SETTING DATA
 PACDSP_M1_DMA_DATA_SAR0 = 0x24000000   ;CORE0 Bank0
 PACDSP_M1_DMA_DATA_DAR0 = 0x25000000   ;M2 Memory Bank0
 PACDSP_M1_DMA_DATA_SGR0 = 0x00000000   ;not used
 PACDSP_M1_DMA_DATA_DSR0 = 0x00000000   ;not used
 PACDSP_M1_DMA_DATA_CTL0 = 0x0100000C   ;BSZ[31:12], DSEN[9], SGEN[8], Int2Ext[3], Burst[2], TRZ[1:0], for 7056 DSP DMA
 PACDSP_M1_DMA_DATA_ENA0 = 0x00000001   ;Enable DMA
 PACDSP_M1_DMA_DATA_CLR0 = 0x00000001   ;CLR DMR INT


;;PACDMP M2 DMA SETTING
 PACDMP_M2_DMA_SAR0 = 0x25820070
 PACDMP_M2_DMA_DAR0 = 0x25820074
 PACDMP_M2_DMA_SGR0 = 0x25820078
 PACDMP_M2_DMA_DSR0 = 0x2582007C
 PACDMP_M2_DMA_CTL0 = 0x25820080
 PACDMP_M2_DMA_ENA0 = 0x25820084
 PACDMP_M2_DMA_CLR0 = 0x25820088
 
 PACDMP_M2_DMA_STAT = 0x25820054
 
;;PACDMP M2 DMA SETTING DATA
 PACDMP_M2_DMA_DATA_SAR0 = 0x25001000   ;M2 Bank0
 PACDMP_M2_DMA_DATA_DAR0 = 0x24001000   ;Core0 Memory Bank0
 PACDMP_M2_DMA_DATA_SGR0 = 0x00000000   ;not used
 PACDMP_M2_DMA_DATA_DSR0 = 0x00000000   ;not used
 PACDMP_M2_DMA_DATA_CTL0 = 0x0100000C   ;BSZ[31:12], DSEN[9], SGEN[8], Int2Ext[3], Burst[2], TRZ[1:0], for 7056 DSP DMA
 PACDMP_M2_DMA_DATA_ENA0 = 0x00000001   ;Enable DMA
 PACDMP_M2_DMA_DATA_CLR0 = 0x00000001   ;CLR DMR INT 
 
 
INIT_DATA:
;;CORE0_M1_Bank0 0x24000000 ~ 0x24001000

{ movi r0, 0x400    | movi a0, 0x24000000 | movi d0, 0x12345678 | nop | nop }
INIT_M1:
{ nop               | sw d0, a0, 4+       | nop                 | nop | nop }
{ nop               | nop                 | nop                 | nop | nop } 
{ nop               | nop                 | nop                 | nop | nop } 
{ lbcb r0, INIT_M1  | nop                 | nop                 | nop | nop } 
{ nop               | nop                 | nop                 | nop | nop } 
{ nop               | nop                 | nop                 | nop | nop } 
{ nop               | nop                 | nop                 | nop | nop } 
{ nop               | nop                 | nop                 | nop | nop } 
{ nop               | nop                 | nop                 | nop | nop } 
{ nop               | nop                 | nop                 | nop | nop } 

;;M2_Bank0 0x25001000 ~ 0x25002000
{ movi r0, 0x400    | movi a0, 0x25001000 | movi d0, 0x87654321 | nop | nop }
INIT_M2:
{ nop               | sw d0, a0, 4+       | nop                 | nop | nop }
{ nop               | nop                 | nop                 | nop | nop } 
{ nop               | nop                 | nop                 | nop | nop } 
{ lbcb r0, INIT_M2  | nop                 | nop                 | nop | nop } 
{ nop               | nop                 | nop                 | nop | nop } 
{ nop               | nop                 | nop                 | nop | nop } 
{ nop               | nop                 | nop                 | nop | nop } 
{ nop               | nop                 | nop                 | nop | nop } 
{ nop               | nop                 | nop                 | nop | nop } 
{ nop               | nop                 | nop                 | nop | nop }

M1_DMA_CH0_Check: 
{ movi r0, PACDSP_M1_DMA_STAT | nop | nop | nop | nop }
{ lw r1, r0, 0x0              | nop | nop | nop | nop }
{ nop                         | nop | nop | nop | nop } 
{ nop                         | nop | nop | nop | nop }
{ andi r2, r1, 0x00000001     | nop | nop | nop | nop }
{ seqi r15, p1, p2, r2, 0x1   | nop | nop | nop | nop } 
{ (p1)b M1_DMA_CH0_Check      | nop | nop | nop | nop }
{ nop                         | nop | nop | nop | nop } 
{ nop                         | nop | nop | nop | nop }
{ nop                         | nop | nop | nop | nop } 
{ nop                         | nop | nop | nop | nop }
{ nop                         | nop | nop | nop | nop } 

M2_DMA_CH0_Check: 
{ movi r0, PACDMP_M2_DMA_STAT | nop | nop | nop | nop }
{ lw r1, r0, 0x0              | nop | nop | nop | nop }
{ nop                         | nop | nop | nop | nop } 
{ nop                         | nop | nop | nop | nop }
{ andi r2, r1, 0x00000001     | nop | nop | nop | nop }
{ seqi r15, p1, p2, r2, 0x1   | nop | nop | nop | nop } 
{ (p1)b M2_DMA_CH0_Check      | nop | nop | nop | nop }
{ nop                         | nop | nop | nop | nop } 
{ nop                         | nop | nop | nop | nop }
{ nop                         | nop | nop | nop | nop } 
{ nop                         | nop | nop | nop | nop }
{ nop                         | nop | nop | nop | nop } 

 
;;DMA TRANSFER TEST
;;DMA CORE0 M1 SETTING
{ nop | movi a0, PACDSP_M1_DMA_SAR0 | movi d0, PACDSP_M1_DMA_DATA_SAR0 | movi a0, PACDMP_M2_DMA_SAR0 | movi d0, PACDMP_M2_DMA_DATA_SAR0 }
{ nop | movi a1, PACDSP_M1_DMA_DAR0 | movi d1, PACDSP_M1_DMA_DATA_DAR0 | movi a1, PACDMP_M2_DMA_DAR0 | movi d1, PACDMP_M2_DMA_DATA_DAR0 }
{ nop | movi a2, PACDSP_M1_DMA_SGR0 | clr d2                           | movi a2, PACDMP_M2_DMA_SGR0 | clr d2                           }
{ nop | movi a3, PACDSP_M1_DMA_DSR0 | nop                              | movi a3, PACDMP_M2_DMA_DSR0 | nop                              }
{ nop | movi a4, PACDSP_M1_DMA_CTL0 | movi d3, PACDSP_M1_DMA_DATA_CTL0 | movi a4, PACDMP_M2_DMA_CTL0 | movi d3, PACDMP_M2_DMA_DATA_CTL0 }
{ nop | movi a5, PACDSP_M1_DMA_CLR0 | movi d4, PACDSP_M1_DMA_DATA_CLR0 | movi a5, PACDMP_M2_DMA_CLR0 | movi d4, PACDMP_M2_DMA_DATA_CLR0 }
{ nop | sw d0, a0, 0x0              | movi d5, PACDSP_M1_DMA_DATA_ENA0 | sw d0, a0, 0x0              | movi d5, PACDMP_M2_DMA_DATA_ENA0 }
{ nop | sw d1, a1, 0x0              | nop                              | sw d1, a1, 0x0              | nop                              }
{ nop | sw d2, a2, 0x0              | nop                              | sw d2, a2, 0x0              | nop                              }
{ nop | sw d2, a3, 0x0              | nop                              | sw d2, a3, 0x0              | nop                              }
{ nop | sw d3, a4, 0x0              | nop                              | sw d3, a4, 0x0              | nop                              }
{ nop | sw d4, a5, 0x0              | nop                              | sw d4, a5, 0x0              | nop                              }
{ nop | nop                         | nop                              | nop                         | nop                              }
{ nop | nop                         | nop                              | nop                         | nop                              }

;;ENABLE DMA

{ nop | movi a0, PACDSP_M1_DMA_ENA0 | nop                              | movi a0, PACDMP_M2_DMA_ENA0 | nop                              }
{ nop | sw d5, a0, 0x0              | nop                              | sw d5, a0, 0x0              | nop                              }
{ nop | nop                         | nop                              | nop                         | nop                              }
{ nop | nop                         | nop                              | nop                         | nop                              }

M1_DMA_CH0_Check_Complete: 
{ movi r0, PACDSP_M1_DMA_STAT      | nop | nop | nop | nop }
{ lw r1, r0, 0x0                   | nop | nop | nop | nop }
{ nop                              | nop | nop | nop | nop } 
{ nop                              | nop | nop | nop | nop }
{ andi r2, r1, 0x00000001          | nop | nop | nop | nop }
{ seqi r15, p1, p2, r2, 0x1        | nop | nop | nop | nop } 
{ (p1)b M1_DMA_CH0_Check_Complete  | nop | nop | nop | nop }
{ nop                              | nop | nop | nop | nop } 
{ nop                              | nop | nop | nop | nop }
{ nop                              | nop | nop | nop | nop } 
{ nop                              | nop | nop | nop | nop }
{ nop                              | nop | nop | nop | nop } 

M2_DMA_CH0_Check_Complete: 
{ movi r0, PACDMP_M2_DMA_STAT      | nop | nop | nop | nop }
{ lw r1, r0, 0x0                   | nop | nop | nop | nop }
{ nop                              | nop | nop | nop | nop } 
{ nop                              | nop | nop | nop | nop }
{ andi r2, r1, 0x00000001          | nop | nop | nop | nop }
{ seqi r15, p1, p2, r2, 0x1        | nop | nop | nop | nop } 
{ (p1)b M2_DMA_CH0_Check_Complete  | nop | nop | nop | nop }
{ nop                              | nop | nop | nop | nop } 
{ nop                              | nop | nop | nop | nop }
{ nop                              | nop | nop | nop | nop } 
{ nop                              | nop | nop | nop | nop }
{ nop                              | nop | nop | nop | nop } 

{ TRAP                             | nop | nop | nop | nop }
 