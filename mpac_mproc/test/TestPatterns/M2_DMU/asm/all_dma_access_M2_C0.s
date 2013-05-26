;;---------------------- To Verify ---------------------------
;;DMA Transfer : CORE0&CORE1&SYSTEM DMA Access M2 Memory Concurrently
;; Core0 :
;;    - Initial M2 Data for DMA transfer test
;;    - Set M1 DMA to move data from M2
;;    - Set System DMA to move data from M2 to DDR
;;------------------------------------------------------------

;;PACDSP CORE0 DMA SETTING
 PACDSP0_M1_DMA_SAR0 = 0x2405C070
 PACDSP0_M1_DMA_DAR0 = 0x2405C074
 PACDSP0_M1_DMA_SGR0 = 0x2405C078
 PACDSP0_M1_DMA_DSR0 = 0x2405C07C
 PACDSP0_M1_DMA_CTL0 = 0x2405C080
 PACDSP0_M1_DMA_ENA0 = 0x2405C084
 PACDSP0_M1_DMA_CLR0 = 0x2405C088
 
 PACDSP0_M1_DMA_STAT = 0x2405C054
 
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
 
 PACDSP1_M1_DMA_STAT = 0x2415C054
 
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

; Move 512 byte data to DDR 
;=== SYSTEM DMA Setting, DMEM -> DDR ===
  SYS_DMA_SAR_ADDR1 = 0x1C100090 ;
  SYS_DMA_DAR_ADDR1 = 0x1C100094 ;
  SYS_DMA_SGR_ADDR1 = 0x1C100098 ;
  SYS_DMA_DSR_ADDR1 = 0x1C10009C ;
  SYS_DMA_CTL_ADDR1 = 0x1C1000A0 ;
  SYS_DMA_ENA_ADDR1 = 0x1C1000A4 ;
  SYS_DMA_CLR_ADDR1 = 0x1C1000A8 ;
                             
  SYS_DMA_SAR_DATA1 = 0x30020000 ; set DDR as start address 
  SYS_DMA_DAR_DATA1 = 0x25002400 ; set DMEM M2 as destination address 
  SYS_DMA_SGR_DATA1 = 0x00000000 ; not used
  SYS_DMA_DSR_DATA1 = 0x00000000 ; not used
  SYS_DMA_CTL_DATA1 = 0x00080003 ; DMA_CTL_DATA, BSZ[31:10] 00 1000 0000 0000 0000 0011
  SYS_DMA_ENA_DATA1 = 0x00000001 ; active dma
  SYS_DMA_CLR_DATA1 = 0x00000000 ; not used
  
  SYS_DMA_STATUS_ADDR = 0x1C100300;
  
Store_Check_Flag_for_C1:
{ movi r1, 0x25004000 | nop | nop | nop | nop }
{ movi r2, 0x0        | nop | nop | nop | nop }
{ sw r2, r1, 0x0      | nop | nop | nop | nop }
{ nop                 | nop | nop | nop | nop } 
{ nop                 | nop | nop | nop | nop } 

  
INITIAL_DATA:
;;C0_M1_Bank1 0x24000000 ~ 0x24000200

{ movi r0, 0x80    | movi a0, 0x24000000 | movi d0, 0x12345678 | nop | nop }
INIT_DATA_FOR_C0_M1:
{ nop                           | sw d0, a0, 4+       | nop                 | nop | nop }
{ nop                           | nop                 | nop                 | nop | nop } 
{ nop                           | nop                 | nop                 | nop | nop } 
{ lbcb r0, INIT_DATA_FOR_C0_M1  | nop                 | nop                 | nop | nop } 
{ nop                           | nop                 | nop                 | nop | nop } 
{ nop                           | nop                 | nop                 | nop | nop } 
{ nop                           | nop                 | nop                 | nop | nop } 
{ nop                           | nop                 | nop                 | nop | nop } 
{ nop                           | nop                 | nop                 | nop | nop } 


;;DDR 0x30020000 ~ 0x30022000
{ movi r0, 0x80    | movi a0, 0x30020000 | movi d0, 0x55558888 | nop | nop }
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

Initial_Data_Complete:
{ movi r1, 0x25004000 | nop | nop | nop | nop }
{ movi r2, 0x77779999 | nop | nop | nop | nop }
{ sw r2, r1, 0x0      | nop | nop | nop | nop }
{ nop                 | nop | nop | nop | nop } 
{ nop                 | nop | nop | nop | nop } 


;;=================================================================================================
START_MEMORY_TEST:
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
;;DMA CORE0 M1 SETTING
{ nop | movi a0, PACDSP0_M1_DMA_SAR0 | movi d0, PACDSP0_M1_DMA_DATA_SAR0 | nop | nop }
{ nop | movi a1, PACDSP0_M1_DMA_DAR0 | movi d1, PACDSP0_M1_DMA_DATA_DAR0 | nop | nop }
{ nop | movi a2, PACDSP0_M1_DMA_SGR0 | clr d2                            | nop | nop }
{ nop | movi a3, PACDSP0_M1_DMA_DSR0 | nop                               | nop | nop }
{ nop | movi a4, PACDSP0_M1_DMA_CTL0 | movi d3, PACDSP0_M1_DMA_DATA_CTL0 | nop | nop }
{ nop | movi a5, PACDSP0_M1_DMA_CLR0 | movi d4, PACDSP0_M1_DMA_DATA_CLR0 | nop | nop }
{ nop | sw d0, a0, 0x0               | movi d5, PACDSP0_M1_DMA_DATA_ENA0 | nop | nop }
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

{ nop | movi a0, PACDSP0_M1_DMA_ENA0 | nop | movi a0, SYS_DMA_ENA_ADDR1 | nop }
{ nop | sw d5, a0, 0x0               | nop | sw d5, a0,0x0 | nop }
{ nop | nop                          | nop | nop | nop }
{ nop | nop                          | nop | nop | nop }

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