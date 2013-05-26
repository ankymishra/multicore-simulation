;;============ To Verify ===============
;;DDR -> M2
;;Move 1KB Data from DDR to M2 Memory
;;======================================

;;M1 Base Address
PACDSP0_LDM_BaseAddr = 0x24000000

;;PACDSP CORE0 DMA SETTING
 PACDSP0_M1_DMA_Base = 0x2405C000
 
  M2_DMA_Base = 0x25820000
 
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

DMA_M1_SR      = 0x2405C054
DMA_M2_SR      = 0x25820054

; Move 8Kbyte data to M2 
                             
  DMA_SAR_DATA1 = 0x30020000 ; set DDR as start address 
  DMA_DAR_DATA1 = 0x25000000 ; set DMEM M2 as destination address 
  DMA_SGR_DATA1 = 0x00000000 ; not used
  DMA_DSR_DATA1 = 0x00000000 ; not used
  DMA_CTL_DATA1 = 0x00400004 ; DMA_CTL_DATA, BSZ[31:10] 00 1000 0000 0000 0000 0000 0011
  DMA_ENA_DATA1 = 0x00000001 ; active dma
  DMA_CLR_DATA1 = 0x00000000 ; not used
  
  SYS_DMA_STATUS_ADDR = 0x1C100300;
  
;;DDR 0x30020000 ~ 0x300200400
{ movi r0, 0x100                     | movi a0, 0x30020000     | movi d0, 0x04030201 | nop | nop }
INIT_DATA_FOR_DDR_TO_M2:
{ nop                                  | sw d0, a0, 4+           | nop                 | nop | nop }
{ nop                                  | nop                     | nop                 | nop | nop } 
{ nop                                  | nop                     | nop                 | nop | nop } 
{ lbcb r0, INIT_DATA_FOR_DDR_TO_M2     | nop                     | nop                 | nop | nop } 
{ nop                                  | nop                     | nop                 | nop | nop } 
{ nop                                  | nop                     | nop                 | nop | nop } 
{ nop                                  | nop                     | nop                 | nop | nop } 
{ nop                                  | nop                     | nop                 | nop | nop } 
{ nop                                  | nop                     | nop                 | nop | nop } 

  ;;SYSTEM DMA SETTING
{ nop | nop | nop | movi a0, M2_DMA_Base   | movi d0, DMA_SAR_DATA1        }
{ nop | nop | nop | nop                    | movi d1, DMA_DAR_DATA1        }
{ nop | nop | nop | nop                    | clr d2                        }
{ nop | nop | nop | nop                    | nop                           }
{ nop | nop | nop | nop                    | movi d3, DMA_CTL_DATA1        }
{ nop | nop | nop | nop                    | movi d4, DMA_CLR_DATA1        }
{ nop | nop | nop | sw d0, a0, DMA_SAR0_offset         | movi d5, DMA_ENA_DATA1        }
{ nop | nop | nop | sw d1, a0, DMA_DAR0_offset         | nop                           }
{ nop | nop | nop | sw d2, a0, DMA_SGR0_offset         | nop                           }
{ nop | nop | nop | sw d2, a0, DMA_DSR0_offset         | nop                           }
{ nop | nop | nop | sw d3, a0, DMA_CTL0_offset         | nop                           }
{ nop | nop | nop | sw d4, a0, DMA_CLR0_offset         | nop                           }
{ nop | nop | nop | nop                    | nop                           }
{ nop | nop | nop | nop                    | nop                           }


;;ENABLE DMA

{ nop | nop               | nop | nop | nop }
{ nop | nop               | nop | sw d5, a0,DMA_ENA0_offset | nop }
{ nop | nop               | nop | nop | nop }
{ nop | nop               | nop | nop | nop }

  { MOVI r0, DMA_M2_SR    | NOP | NOP | NOP | NOP }
DMA_BUSY:    
  { LW r1, r0, 0x0                   | NOP | NOP | NOP | NOP }
  { NOP                              | NOP | NOP | NOP | NOP }
  { NOP                              | NOP | NOP | NOP | NOP }
  { SEQI r2, p1, p2, r1, 0x00000002  | NOP | NOP | NOP | NOP }     ; (DMA_STATUS == 0) ? 
  { (p2) B DMA_BUSY                  | NOP | NOP | NOP | NOP }
  { NOP                              | NOP | NOP | NOP | NOP }
  { NOP                              | NOP | NOP | NOP | NOP }  
  { NOP                              | NOP | NOP | NOP | NOP }
  { NOP                              | NOP | NOP | NOP | NOP }  
  { NOP                              | NOP | NOP | NOP | NOP }
  
  { TRAP                        | NOP | NOP | NOP | NOP }
  