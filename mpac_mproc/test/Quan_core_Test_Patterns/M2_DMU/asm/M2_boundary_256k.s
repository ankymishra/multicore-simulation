; Move 8Kbyte data to M2 
;=== SYSTEM DMA Setting, DMEM -> DDR ===
  SYS_DMA_SAR_ADDR1 = 0x1C100090 ;
  SYS_DMA_DAR_ADDR1 = 0x1C100094 ;
  SYS_DMA_SGR_ADDR1 = 0x1C100098 ;
  SYS_DMA_DSR_ADDR1 = 0x1C10009C ;
  SYS_DMA_CTL_ADDR1 = 0x1C1000A0 ;
  SYS_DMA_ENA_ADDR1 = 0x1C1000A4 ;
  SYS_DMA_CLR_ADDR1 = 0x1C1000A8 ;
                             
  SYS_DMA_SAR_DATA1 = 0x30020000 ; set DDR as start address 
  SYS_DMA_DAR_DATA1 = 0x2502EFFF ; set DMEM M2 as destination address 
  SYS_DMA_SGR_DATA1 = 0x00000000 ; not used
  SYS_DMA_DSR_DATA1 = 0x00000000 ; not used
  SYS_DMA_CTL_DATA1 = 0x00800003 ; DMA_CTL_DATA, BSZ[31:10] 00 1000 0000 0000 0000 0000 0011
  SYS_DMA_ENA_DATA1 = 0x00000001 ; active dma
  SYS_DMA_CLR_DATA1 = 0x00000000 ; not used
  
  SYS_DMA_STATUS_ADDR = 0x1C100300;
  
;;DDR 0x30020000 ~ 0x300200800
{ movi r0, 0x200                     | movi a0, 0x30020000     | movi d0, 0x04030201 | nop | nop }
INIT_DATA_FOR_SYSTME_DMA_1:
{ nop                                  | sw d0, a0, 4+           | nop                 | nop | nop }
{ nop                                  | nop                     | nop                 | nop | nop } 
{ nop                                  | nop                     | nop                 | nop | nop } 
{ lbcb r0, INIT_DATA_FOR_SYSTME_DMA_1  | nop                     | nop                 | nop | nop } 
{ nop                                  | nop                     | nop                 | nop | nop } 
{ nop                                  | nop                     | nop                 | nop | nop } 
{ nop                                  | nop                     | nop                 | nop | nop } 
{ nop                                  | nop                     | nop                 | nop | nop } 
{ nop                                  | nop                     | nop                 | nop | nop } 

;;DDR 0x30020800 ~ 0x30021000
{ movi r0, 0x200                       | movi a0, 0x30020800     | movi d0, 0x40302010 | nop | nop }
INIT_DATA_FOR_SYSTME_DMA_2:            
{ nop                                  | sw d0, a0, 4+           | nop                 | nop | nop }
{ nop                                  | nop                     | nop                 | nop | nop } 
{ nop                                  | nop                     | nop                 | nop | nop } 
{ lbcb r0, INIT_DATA_FOR_SYSTME_DMA_2  | nop                     | nop                 | nop | nop } 
{ nop                                  | nop                     | nop                 | nop | nop } 
{ nop                                  | nop                     | nop                 | nop | nop } 
{ nop                                  | nop                     | nop                 | nop | nop } 
{ nop                                  | nop                     | nop                 | nop | nop } 
{ nop                                  | nop                     | nop                 | nop | nop } 

;;DDR 0x30021000 ~ 0x30021800
{ movi r0, 0x200                       | movi a0, 0x30021000     | movi d0, 0x77778888 | nop | nop }
INIT_DATA_FOR_SYSTME_DMA_3:            
{ nop                                  | sw d0, a0, 4+           | nop                 | nop | nop }
{ nop                                  | nop                     | nop                 | nop | nop } 
{ nop                                  | nop                     | nop                 | nop | nop } 
{ lbcb r0, INIT_DATA_FOR_SYSTME_DMA_3  | nop                     | nop                 | nop | nop } 
{ nop                                  | nop                     | nop                 | nop | nop } 
{ nop                                  | nop                     | nop                 | nop | nop } 
{ nop                                  | nop                     | nop                 | nop | nop } 
{ nop                                  | nop                     | nop                 | nop | nop } 
{ nop                                  | nop                     | nop                 | nop | nop } 

;;DDR 0x30021800 ~ 0x30022000
{ movi r0, 0x200                       | movi a0, 0x30021800     | movi d0, 0x55551234 | nop | nop }
INIT_DATA_FOR_SYSTME_DMA_4:            
{ nop                                  | sw d0, a0, 4+           | nop                 | nop | nop }
{ nop                                  | nop                     | nop                 | nop | nop } 
{ nop                                  | nop                     | nop                 | nop | nop } 
{ lbcb r0, INIT_DATA_FOR_SYSTME_DMA_4  | nop                     | nop                 | nop | nop } 
{ nop                                  | nop                     | nop                 | nop | nop } 
{ nop                                  | nop                     | nop                 | nop | nop } 
{ nop                                  | nop                     | nop                 | nop | nop } 
{ nop                                  | nop                     | nop                 | nop | nop } 
{ nop                                  | nop                     | nop                 | nop | nop } 

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

{ nop | nop               | nop | movi a0, SYS_DMA_ENA_ADDR1 | nop }
{ nop | nop               | nop | sw d5, a0,0x0 | nop }
{ nop | nop               | nop | nop | nop }
{ nop | nop               | nop | nop | nop }

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
  