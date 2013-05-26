;;---------------------- To Verify ---------------------------
;;DMA Transfer : M2 DMA and SYSTEM DMA Access DDR Memory Concurrently
;; Core0 :
;;    - Initial M2 Data for DMA transfer test
;;    - Set System DMA to move data from DDR
;;    - Set M2 DMA to move data from M2 to DDR
;;------------------------------------------------------------

;;PACDSP CORE0 DMA SETTING
 PACDSP0_M1_DMA_SAR0 = 0x2405C070
 PACDSP0_M1_DMA_DAR0 = 0x2405C074
 PACDSP0_M1_DMA_SGR0 = 0x2405C078
 PACDSP0_M1_DMA_DSR0 = 0x2405C07C
 PACDSP0_M1_DMA_CTL0 = 0x2405C080
 PACDSP0_M1_DMA_ENA0 = 0x2405C084
 PACDSP0_M1_DMA_CLR0 = 0x2405C088
 
 PACDSP0_M1_DMA_STAT = 0x08058054
 
;;PACDSP CORE0 DMA SETTING DATA
 PACDSP0_M1_DMA_DATA_SAR0 = 0x24000000   ;M2 Bank1
 PACDSP0_M1_DMA_DATA_DAR0 = 0x25002000   ;Core0 Memory Bank0
 PACDSP0_M1_DMA_DATA_SGR0 = 0x00000000   ;not used
 PACDSP0_M1_DMA_DATA_DSR0 = 0x00000000   ;not used
 PACDSP0_M1_DMA_DATA_CTL0 = 0x0020000E   ;BSZ[31:12], DSEN[9], SGEN[8], Int2Ext[3], Burst[2], TRZ[1:0], for 7056 DSP DMA
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
 
 PACDSP1_M1_DMA_STAT = 0x08158054
 
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
;; Move 2KB Data to DDR Memory
 PACDMP_M2_DMA_DATA_SAR0 = 0x25024000   ;M2 Bank1
 PACDMP_M2_DMA_DATA_DAR0 = 0x24004000   ;DDR Memory 
 PACDMP_M2_DMA_DATA_SGR0 = 0x00000000   ;not used
 PACDMP_M2_DMA_DATA_DSR0 = 0x00000000   ;not used
 PACDMP_M2_DMA_DATA_CTL0 = 0x0080000C   ;BSZ[31:12], DSEN[9], SGEN[8], Int2Ext[3], Burst[2], TRZ[1:0], for 7056 DSP DMA
 PACDMP_M2_DMA_DATA_ENA0 = 0x00000001   ;Enable DMA
 PACDMP_M2_DMA_DATA_CLR0 = 0x00000001   ;CLR DMR INT 

; Move 2K byte data to DDR 
;=== SYSTEM DMA Setting, DMEM -> DDR ===
  SYS_DMA_SAR_ADDR1 = 0x1C100090 ;
  SYS_DMA_DAR_ADDR1 = 0x1C100094 ;
  SYS_DMA_SGR_ADDR1 = 0x1C100098 ;
  SYS_DMA_DSR_ADDR1 = 0x1C10009C ;
  SYS_DMA_CTL_ADDR1 = 0x1C1000A0 ;
  SYS_DMA_ENA_ADDR1 = 0x1C1000A4 ;
  SYS_DMA_CLR_ADDR1 = 0x1C1000A8 ;
                             
  SYS_DMA_SAR_DATA1 = 0x30020000 ; set DDR as start address 
  SYS_DMA_DAR_DATA1 = 0x24004800 ; set DMEM as destination address 
  SYS_DMA_SGR_DATA1 = 0x00000000 ; not used
  SYS_DMA_DSR_DATA1 = 0x00000000 ; not used
  SYS_DMA_CTL_DATA1 = 0x00200003 ; DMA_CTL_DATA, BSZ[31:10] 0010 0000  0000 0000 0000 0011
  SYS_DMA_ENA_DATA1 = 0x00000000 ; active dma
  SYS_DMA_CLR_DATA1 = 0x00000000 ; not used
  
  SYS_DMA_STATUS_ADDR = 0x1C100300;
  
INITIAL_DATA:
;;M2_Bank1 0x25004000 ~ 0x25004800

{ movi r0, 0x200    | movi a0, 0x25024000 | movi d0, 0x25869799 | nop | nop }
INIT_DATA_FOR_M2:
{ nop                           | sw d0, a0, 4+       | nop                 | nop | nop }
{ nop                           | nop                 | nop                 | nop | nop } 
{ nop                           | nop                 | nop                 | nop | nop } 
{ lbcb r0, INIT_DATA_FOR_M2     | nop                 | nop                 | nop | nop } 
{ nop                           | nop                 | nop                 | nop | nop } 
{ nop                           | nop                 | nop                 | nop | nop } 
{ nop                           | nop                 | nop                 | nop | nop } 
{ nop                           | nop                 | nop                 | nop | nop } 
{ nop                           | nop                 | nop                 | nop | nop } 


;;DDR 0x30020000 ~ 0x30020800
{ movi r0, 0x200    | movi a0, 0x30020000 | movi d0, 0x189856ba | nop | nop }
INIT_DATA_FOR_SYSTME_DMA:
{ nop                                | sw d0, a0, 4+       | nop                 | nop | nop }
{ nop                                | nop                 | nop                 | nop | nop } 
{ nop                                | nop                 | nop                 | nop | nop } 
{ lbcb r0, INIT_DATA_FOR_SYSTME_DMA  | nop                 | nop                 | nop | nop } 
{ nop                                | nop                 | nop                 | nop | nop } 
{ nop                                | nop                 | nop                 | nop | nop } 
{ nop                                | nop                 | nop                 | nop | nop } 
{ nop                                | nop                 | nop                 | nop | nop } 
{ nop                                | nop                 | nop                 | nop | nop } 

START_MEMORY_TEST:
M2_DMA_CH0_Check: 
{ movi r0, PACDMP_M2_DMA_STAT       | nop | nop | nop | nop }
{ lw r1, r0, 0x0                    | nop | nop | nop | nop }
{ nop                               | nop | nop | nop | nop } 
{ nop                               | nop | nop | nop | nop }
{ andi r2, r1, 0x00000001           | nop | nop | nop | nop }
{ seqi r15, p1, p2, r2, 0x1         | nop | nop | nop | nop } 
{ (p1)b M2_DMA_CH0_Check            | nop | nop | nop | nop }
{ nop                               | nop | nop | nop | nop } 
{ nop                               | nop | nop | nop | nop }
{ nop                               | nop | nop | nop | nop } 
{ nop                               | nop | nop | nop | nop }
{ nop                               | nop | nop | nop | nop } 

  { MOVI r0, SYS_DMA_STATUS_ADDR | NOP | NOP | NOP | NOP }
SYSDMA_CHECK:    
  { LW r1, r0, 0x0              | NOP | NOP | NOP | NOP }
  { NOP                         | NOP | NOP | NOP | NOP }
  { NOP                         | NOP | NOP | NOP | NOP }
  { SEQI r2, p1, p2, r1, 0x0    | NOP | NOP | NOP | NOP }     ; (DMA_STATUS == 0) ? 
  { (p2) B SYSDMA_CHECK         | NOP | NOP | NOP | NOP }
  { NOP                         | NOP | NOP | NOP | NOP }
  { NOP                         | NOP | NOP | NOP | NOP }  
  { NOP                         | NOP | NOP | NOP | NOP }
  { NOP                         | NOP | NOP | NOP | NOP }  
  { NOP                         | NOP | NOP | NOP | NOP }


 
;;DMA TRANSFER TEST
;;M2 DMA SETTING
{ nop | movi a0, PACDMP_M2_DMA_SAR0  | movi d0, PACDMP_M2_DMA_DATA_SAR0  | nop | nop }
{ nop | movi a1, PACDMP_M2_DMA_DAR0  | movi d1, PACDMP_M2_DMA_DATA_DAR0  | nop | nop }
{ nop | movi a2, PACDMP_M2_DMA_SGR0  | clr d2                            | nop | nop }
{ nop | movi a3, PACDMP_M2_DMA_DSR0  | nop                               | nop | nop }
{ nop | movi a4, PACDMP_M2_DMA_CTL0  | movi d3, PACDMP_M2_DMA_DATA_CTL0  | nop | nop }
{ nop | movi a5, PACDMP_M2_DMA_CLR0  | movi d4, PACDMP_M2_DMA_DATA_CLR0  | nop | nop }
{ nop | sw d0, a0, 0x0               | movi d5, PACDMP_M2_DMA_DATA_ENA0  | nop | nop }
{ nop | sw d1, a1, 0x0               | nop                               | nop | nop }
{ nop | sw d2, a2, 0x0               | nop                               | nop | nop }
{ nop | sw d2, a3, 0x0               | nop                               | nop | nop }
{ nop | sw d3, a4, 0x0               | nop                               | nop | nop }
{ nop | sw d4, a5, 0x0               | nop                               | nop | nop }
{ nop | nop                          | nop                               | nop | nop }
{ nop | nop                          | nop                               | nop | nop }

;;SYSTEM DMA SETTING
{ nop | nop | nop | movi a0, SYS_DMA_SAR_ADDR1   | movi d0, SYS_DMA_SAR_DATA1        }
{ nop | nop | nop | movi a1, SYS_DMA_DAR_ADDR1   | movi d1, SYS_DMA_DAR_DATA1        }
{ nop | nop | nop | movi a2, SYS_DMA_SGR_ADDR1   | clr d2                            }
{ nop | nop | nop | movi a3, SYS_DMA_DSR_ADDR1   | nop                               }
{ nop | nop | nop | movi a4, SYS_DMA_CTL_ADDR1   | movi d3, SYS_DMA_CTL_DATA1        }
{ nop | nop | nop | movi a5, SYS_DMA_CLR_ADDR1   | movi d4, SYS_DMA_CLR_DATA1        }
{ nop | nop | nop | sw d0, a0, 0x0               | movi d5, SYS_DMA_ENA_DATA1        }
{ nop | nop | nop | sw d1, a1, 0x0               | nop                               }
{ nop | nop | nop | sw d2, a2, 0x0               | nop                               }
{ nop | nop | nop | sw d2, a3, 0x0               | nop                               }
{ nop | nop | nop | sw d3, a4, 0x0               | nop                               }
{ nop | nop | nop | sw d4, a5, 0x0               | nop                               }
{ nop | nop | nop | nop                          | nop                               }
{ nop | nop | nop | nop                          | nop                               }


;;ENABLE DMA

{ nop | movi a0, PACDMP_M2_DMA_ENA0  | nop | nop | nop }
{ nop | sw d5, a0, 0x0               | nop | nop | nop }
{ movi r0, SYS_DMA_ENA_ADDR1 | nop                          | nop | nop | nop }
{ movi r1, SYS_DMA_ENA_DATA1 | nop                          | nop | nop | nop }
{ sw r1, r0, 0x0             | nop | nop | nop | nop }

M2_DMA_CH0_Check_Complete: 
{ movi r0, PACDMP_M2_DMA_STAT            | nop | nop | nop | nop }
{ lw r1, r0, 0x0                         | nop | nop | nop | nop }
{ nop                                    | nop | nop | nop | nop } 
{ nop                                    | nop | nop | nop | nop }
{ andi r2, r1, 0x00000001                | nop | nop | nop | nop }
{ seqi r15, p1, p2, r2, 0x1              | nop | nop | nop | nop } 
{ (p1)b M2_DMA_CH0_Check_Complete        | nop | nop | nop | nop }
{ nop                                    | nop | nop | nop | nop } 
{ nop                                    | nop | nop | nop | nop }
{ nop                                    | nop | nop | nop | nop } 
{ nop                                    | nop | nop | nop | nop }
{ nop                                    | nop | nop | nop | nop } 

  { MOVI r0, SYS_DMA_STATUS_ADDR | NOP | NOP | NOP | NOP }
SYSDMA_BUSY:    
  { LW r1, r0, 0x0              | NOP | NOP | NOP | NOP }
  { NOP                         | NOP | NOP | NOP | NOP }
  { NOP                         | NOP | NOP | NOP | NOP }
  { SEQI r2, p1, p2, r1, 0x0    | NOP | NOP | NOP | NOP }     ; (DMA_STATUS == 0) ? 
  { (p2) B SYSDMA_BUSY          | NOP | NOP | NOP | NOP }
  { NOP                         | NOP | NOP | NOP | NOP }
  { NOP                         | NOP | NOP | NOP | NOP }  
  { NOP                         | NOP | NOP | NOP | NOP }
  { NOP                         | NOP | NOP | NOP | NOP }  
  { NOP                         | NOP | NOP | NOP | NOP }
  
  { TRAP                        | NOP | NOP | NOP | NOP }
  