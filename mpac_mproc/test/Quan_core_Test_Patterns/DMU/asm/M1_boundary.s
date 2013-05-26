;;============ To Verify ===============
;;M2 Memory Boundary
;;Move 8KB Data from DDR to M1 Memory
;;======================================

;;M1 Base Address
PACDSP0_LDM_BaseAddr = 0x24000000

;;PACDSP CORE0 DMA SETTING
 PACDSP0_M1_DMA_Base = 0x2405C000
 
;CH0 Register Offset 
 DMA_SAR0_offset   = 0x70;
 DMA_DAR0_offset   = 0x74;
 DMA_SGR0_offset   = 0x78;
 DMA_DSR0_offset   = 0x7C;
 DMA_CTL0_offset   = 0x80;
 DMA_ENA0_offset   = 0x84;
 DMA_CLR0_offset   = 0x88;
 DMA_LLST0_offset  = 0x8C;
 DMA_PDCTL0_offset = 0x90;
 DMA_SHAPE0_offset = 0x94;
 DMA_RES0_offset   = 0x98;
 
;CH1 Register Offset 
 DMA_SAR1_offset   = 0xB0;
 DMA_DAR1_offset   = 0xB4;
 DMA_SGR1_offset   = 0xB8;
 DMA_DSR1_offset   = 0xBC;
 DMA_CTL1_offset   = 0xC0;
 DMA_ENA1_offset   = 0xC4;
 DMA_CLR1_offset   = 0xC8;
 DMA_LLST1_offset  = 0xCC;
 DMA_PDCTL1_offset = 0xD0;
 DMA_SHAPE1_offset = 0xD4;
 DMA_RES1_offset   = 0xD8;
 
;CH2 Register Offset 
 DMA_SAR2_offset   = 0xF0;
 DMA_DAR2_offset   = 0xF4;
 DMA_SGR2_offset   = 0xF8;
 DMA_DSR2_offset   = 0xFC;
 DMA_CTL2_offset   = 0x100;
 DMA_ENA2_offset   = 0x104;
 DMA_CLR2_offset   = 0x108;
 DMA_LLST2_offset  = 0x10C;
 DMA_PDCTL2_offset = 0x110;
 DMA_SHAPE2_offset = 0x114;
 DMA_RES2_offset   = 0x118;
 
;CH3 Register Offset 
 DMA_SAR3_offset   = 0x130;
 DMA_DAR3_offset   = 0x134;
 DMA_SGR3_offset   = 0x138;
 DMA_DSR3_offset   = 0x13C;
 DMA_CTL3_offset   = 0x140;
 DMA_ENA3_offset   = 0x144;
 DMA_CLR3_offset   = 0x148;
 DMA_LLST3_offset  = 0x14C;
 DMA_PDCTL3_offset = 0x150;
 DMA_SHAPE3_offset = 0x154;
 DMA_RES3_offset   = 0x158; 
 
M1_2D_To_2D_result    = 0x30020000 
M1_2D_To_1D_result    = 0x30021000
M1_1D_To_1D_result    = 0x30022000

DMA_M1_SR      = 0x24058054

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
  SYS_DMA_DAR_DATA1 = 0x24000000 ; set DMEM M1 as destination address 
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
  