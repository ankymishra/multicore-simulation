;;---------------------- To Verify ---------------------------
;;DMA Transfer : CORE0 M1 Bank0 -> M2 Bank0 and M2 Bank0 -> CORE1 M1 Bank0
;;Transfer by DSP DMA only
;;------------------------------------------------------------

;;PACDSP CORE0 DMA SETTING
 PACDSP0_M1_DMA_SAR0 = 0x2405C070
 PACDSP0_M1_DMA_DAR0 = 0x2405C074
 PACDSP0_M1_DMA_SGR0 = 0x2405C078
 PACDSP0_M1_DMA_DSR0 = 0x2405C07C
 PACDSP0_M1_DMA_CTL0 = 0x2405C080
 PACDSP0_M1_DMA_ENA0 = 0x2405C084
 PACDSP0_M1_DMA_CLR0 = 0x2405C088
 
 PACDSP0_M1_DMA_STAT = 0x24058054
 
;;PACDSP CORE0 DMA SETTING DATA
 PACDSP0_M1_DMA_DATA_SAR0 = 0x24000000   ;CORE0 Bank0
 PACDSP0_M1_DMA_DATA_DAR0 = 0x25000000   ;M2 Memory Bank0
 PACDSP0_M1_DMA_DATA_SGR0 = 0x00000000   ;not used
 PACDSP0_M1_DMA_DATA_DSR0 = 0x00000000   ;not used
 PACDSP0_M1_DMA_DATA_CTL0 = 0x0100000E   ;BSZ[31:12], DSEN[9], SGEN[8], Int2Ext[3], Burst[2], TRZ[1:0], for 7056 DSP DMA
 PACDSP0_M1_DMA_DATA_ENA0 = 0x00000001   ;Enable DMA
 PACDSP0_M1_DMA_DATA_CLR0 = 0x00000001   ;CLR DMR INT

;;PACDSP CORE1 DMA SETTING
 PACDSP1_M1_DMA_SAR0 = 0x2415C070
 PACDSP1_M1_DMA_DAR0 = 0x2415C074
 PACDSP1_M1_DMA_SGR0 = 0x2415C078
 PACDSP1_M1_DMA_DSR0 = 0x2415C07C
 PACDSP1_M1_DMA_CTL0 = 0x2415C080
 PACDSP1_M1_DMA_ENA0 = 0x2415C084
 PACDSP1_M1_DMA_CLR0 = 0x2415C088
 
 PACDSP1_M1_DMA_STAT = 0x24158054
 
;;PACDSP CORE1 DMA SETTING DATA
 PACDSP1_M1_DMA_DATA_SAR0 = 0x25001000   ;M1 Bank0
 PACDSP1_M1_DMA_DATA_DAR0 = 0x24100000   ;Core1 Memory Bank0
 PACDSP1_M1_DMA_DATA_SGR0 = 0x00000000   ;not used
 PACDSP1_M1_DMA_DATA_DSR0 = 0x00000000   ;not used
 PACDSP1_M1_DMA_DATA_CTL0 = 0x01000006   ;BSZ[31:12], DSEN[9], SGEN[8], Int2Ext[3], Burst[2], TRZ[1:0], for 7056 DSP DMA
 PACDSP1_M1_DMA_DATA_ENA0 = 0x00000001   ;Enable DMA
 PACDSP1_M1_DMA_DATA_CLR0 = 0x00000001   ;CLR DMR INT



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
 PACDMP_M2_DMA_DATA_DAR0 = 0x24100000   ;Core1 Memory Bank0
 PACDMP_M2_DMA_DATA_SGR0 = 0x00000000   ;not used
 PACDMP_M2_DMA_DATA_DSR0 = 0x00000000   ;not used
 PACDMP_M2_DMA_DATA_CTL0 = 0x0100000E   ;BSZ[31:12], DSEN[9], SGEN[8], Int2Ext[3], Burst[2], TRZ[1:0], for 7056 DSP DMA
 PACDMP_M2_DMA_DATA_ENA0 = 0x00000001   ;Enable DMA
 PACDMP_M2_DMA_DATA_CLR0 = 0x00000001   ;CLR DMR INT 
 
 
INIT_DATA:
;;CORE0_M1_Bank0 0x24000000 ~ 0x24001000

{ movi r0, 0x400    | movi a0, 0x25000000 | movi d0, 0x12345678 | nop | nop }
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

Core0_M1_DMA_CH0_Check: 
{ movi r0, PACDSP0_M1_DMA_STAT      | nop | nop | nop | nop }
{ lw r1, r0, 0x0                    | nop | nop | nop | nop }
{ nop                               | nop | nop | nop | nop } 
{ nop                               | nop | nop | nop | nop }
{ andi r2, r1, 0x00000001           | nop | nop | nop | nop }
{ seqi r15, p1, p2, r2, 0x1         | nop | nop | nop | nop } 
{ (p1)b Core0_M1_DMA_CH0_Check      | nop | nop | nop | nop }
{ nop                               | nop | nop | nop | nop } 
{ nop                               | nop | nop | nop | nop }
{ nop                               | nop | nop | nop | nop } 
{ nop                               | nop | nop | nop | nop }
{ nop                               | nop | nop | nop | nop } 

Core1_M1_DMA_CH0_Check: 
{ movi r0, PACDSP1_M1_DMA_STAT      | nop | nop | nop | nop }
{ lw r1, r0, 0x0                    | nop | nop | nop | nop }
{ nop                               | nop | nop | nop | nop } 
{ nop                               | nop | nop | nop | nop }
{ andi r2, r1, 0x00000001           | nop | nop | nop | nop }
{ seqi r15, p1, p2, r2, 0x1         | nop | nop | nop | nop } 
{ (p1)b Core1_M1_DMA_CH0_Check      | nop | nop | nop | nop }
{ nop                               | nop | nop | nop | nop } 
{ nop                               | nop | nop | nop | nop }
{ nop                               | nop | nop | nop | nop } 
{ nop                               | nop | nop | nop | nop }
{ nop                               | nop | nop | nop | nop } 

 
;;DMA TRANSFER TEST
;;DMA CORE0 M1 SETTING
{ nop | movi a0, PACDSP0_M1_DMA_SAR0 | movi d0, PACDSP0_M1_DMA_DATA_SAR0 | movi a0, PACDSP1_M1_DMA_SAR0 | movi d0, PACDSP1_M1_DMA_DATA_SAR0 }
{ nop | movi a1, PACDSP0_M1_DMA_DAR0 | movi d1, PACDSP0_M1_DMA_DATA_DAR0 | movi a1, PACDSP1_M1_DMA_DAR0 | movi d1, PACDSP1_M1_DMA_DATA_DAR0 }
{ nop | movi a2, PACDSP0_M1_DMA_SGR0 | clr d2                            | movi a2, PACDSP1_M1_DMA_SGR0 | clr d2                            }
{ nop | movi a3, PACDSP0_M1_DMA_DSR0 | nop                               | movi a3, PACDSP1_M1_DMA_DSR0 | nop                               }
{ nop | movi a4, PACDSP0_M1_DMA_CTL0 | movi d3, PACDSP0_M1_DMA_DATA_CTL0 | movi a4, PACDSP1_M1_DMA_CTL0 | movi d3, PACDSP1_M1_DMA_DATA_CTL0 }
{ nop | movi a5, PACDSP0_M1_DMA_CLR0 | movi d4, PACDSP0_M1_DMA_DATA_CLR0 | movi a5, PACDSP1_M1_DMA_CLR0 | movi d4, PACDSP1_M1_DMA_DATA_CLR0 }
{ nop | sw d0, a0, 0x0               | movi d5, PACDSP0_M1_DMA_DATA_ENA0 | sw d0, a0, 0x0               | movi d5, PACDSP1_M1_DMA_DATA_ENA0 }
{ nop | sw d1, a1, 0x0               | nop                               | sw d1, a1, 0x0               | nop                               }
{ nop | sw d2, a2, 0x0               | nop                               | sw d2, a2, 0x0               | nop                               }
{ nop | sw d2, a3, 0x0               | nop                               | sw d2, a3, 0x0               | nop                               }
{ nop | sw d3, a4, 0x0               | nop                               | sw d3, a4, 0x0               | nop                               }
{ nop | sw d4, a5, 0x0               | nop                               | sw d4, a5, 0x0               | nop                               }
{ nop | nop                          | nop                               | nop                          | nop                               }
{ nop | nop                          | nop                               | nop                          | nop                               }

;;ENABLE DMA

{ nop | movi a0, PACDSP0_M1_DMA_ENA0 | nop                              | movi a0, PACDSP1_M1_DMA_ENA0 | nop                              }
{ nop | sw d5, a0, 0x0              | nop                              | sw d5, a0, 0x0              | nop                              }
{ nop | nop                         | nop                              | nop                         | nop                              }
{ nop | nop                         | nop                              | nop                         | nop                              }

Core0_M1_DMA_CH0_Check_Complete: 
{ movi r0, PACDSP0_M1_DMA_STAT           | nop | nop | nop | nop }
{ lw r1, r0, 0x0                         | nop | nop | nop | nop }
{ nop                                    | nop | nop | nop | nop } 
{ nop                                    | nop | nop | nop | nop }
{ andi r2, r1, 0x00000001                | nop | nop | nop | nop }
{ seqi r15, p1, p2, r2, 0x1              | nop | nop | nop | nop } 
{ (p1)b Core0_M1_DMA_CH0_Check_Complete  | nop | nop | nop | nop }
{ nop                                    | nop | nop | nop | nop } 
{ nop                                    | nop | nop | nop | nop }
{ nop                                    | nop | nop | nop | nop } 
{ nop                                    | nop | nop | nop | nop }
{ nop                                    | nop | nop | nop | nop } 

Core1_M1_DMA_CH0_Check_Complete: 
{ movi r0, PACDSP1_M1_DMA_STAT           | nop | nop | nop | nop }
{ lw r1, r0, 0x0                         | nop | nop | nop | nop }
{ nop                                    | nop | nop | nop | nop } 
{ nop                                    | nop | nop | nop | nop }
{ andi r2, r1, 0x00000001                | nop | nop | nop | nop }
{ seqi r15, p1, p2, r2, 0x1              | nop | nop | nop | nop } 
{ (p1)b Core1_M1_DMA_CH0_Check_Complete  | nop | nop | nop | nop }
{ nop                                    | nop | nop | nop | nop } 
{ nop                                    | nop | nop | nop | nop }
{ nop                                    | nop | nop | nop | nop } 
{ nop                                    | nop | nop | nop | nop }
{ nop                                    | nop | nop | nop | nop } 

{ TRAP                             | nop | nop | nop | nop }
 