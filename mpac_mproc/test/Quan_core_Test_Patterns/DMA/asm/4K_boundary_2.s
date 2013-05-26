;;------------------------------- To Verify ---------------------------------
;;DMA Transfer : DMA transfer 16*Luma9x9, 2D->1D from DDR to LDM
;; Modify from dma_test_case13, in order to test cross 4K boundary
;;---------------------------------------------------------------------------

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

Luma_BaseAddr      = 0x24000000
Chroma_BaseAddr    = 0x24005000
;;M1_Luma_result     = 0x30020000 
M1_Luma_result     = 0x30020F00 
M1_Chroma_result   = 0x30021000

DMA_M1_SR      = 0x24058054
 

;======= CLEAR DMA STATUS scalar clr ch0, c1 clr ch1, c2 clr ch2, ch3 ======================

{ movi r0, PACDSP0_M1_DMA_Base | nop        | movi d0, 0x1        | movi a0, PACDSP0_M1_DMA_Base | movi d0, 0x1 }
{ movi r1, 0x1                 | nop        | nop                 | nop                          | nop          }
{ sw r1, r0, DMA_CLR0_offset   | nop                           | nop                 | nop                          | nop          }
{ movi r11, 0                  | nop                           | nop                 | nop                          | nop          }
{ movi r10, 16                 | movi d6, 0                    | nop                 | nop                          | nop          }
{ movi r8, 0                   | movi d7, 0                    | nop                 | nop                          | nop          }

;;CH0 Test 2D -> 1D Luma Transfer, CH1 Test 2D -> 1D Chroma Transfer

DMA_Setup:
;;Scalar Set CH0 DMA, C1 set CH1 DMA, C2 set CH2 DMA
{ movi r0, PACDSP0_M1_DMA_Base | movi a0, PACDSP0_M1_DMA_Base  | nop                 | nop | nop          }
;;SAR                                                                                      
{ movi r1, Luma_BaseAddr       | nop    | nop                 | nop | nop          }
{ add r1, r1, r11              | nop    | nop                 | nop | nop          }
{ sw r1, r0, DMA_SAR0_offset   | nop    | nop                 | nop | nop          }
;;DAR                                                                                      
{ movi r2, M1_Luma_result      | nop    | nop                 | nop | nop          }
{ add r2, r2, r8               | nop    | nop                 | nop | nop          }
{ sw r2, r0, DMA_DAR0_offset   | nop    | nop                 | nop | nop          }
;;SGR                                                                                      
{ movi r3, 0x00900780          | nop    | nop                 | nop | nop          }
{ sw r3, r0, DMA_SGR0_offset   | nop    | nop                 | nop | nop          }
;;DSR                                                                                      
{ movi r4, 0x00000000          | nop    | nop                 | nop | nop          }
{ sw r4, r0, DMA_DSR0_offset   | nop    | nop                 | nop | nop          }
;;CTL                                                                                      
{ movi r5, 0x0005110C          | nop    | nop                 | nop | nop          }
{ sw r5, r0, DMA_CTL0_offset   | nop    | nop                 | nop | nop          }
;;Enable DMA                                                                               
{ movi r6, 0x1                 | nop    | nop                 | nop | nop          }
{ sw r6, r0, DMA_ENA0_offset   | nop    | nop                 | nop | nop          }
{  NOP                         |  NOP                          |  NOP                | NOP | NOP  }
{  NOP                         |  NOP                          |  NOP                | NOP | NOP  }
;;WAIT DMA Transfer Complete
;************************************************************** wait until DMA done
{  MOVI R5, DMA_M1_SR      |  NOP  |  NOP  |  NOP  |  NOP  }
_Label1:
{  LW R6, R5, 0            |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                     |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                     |  NOP  |  NOP  |  NOP  |  NOP  }
{  SEQI R7, P1, P2, R6, 0x00002222  |  NOP  |  NOP  |  NOP  |  NOP  }
{  (P2)B _Label1           |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                     |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                     |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                     |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                     |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                     |  NOP  |  NOP  |  NOP  |  NOP  }       

{ LBCB r10, DMA_Setup      |  NOP               |  NOP  |  NOP  |  NOP  }    
{  addi r8, r8, 0x60       |  addi d7, d7, 0x20  |  NOP  |  NOP  |  NOP  }
{  addi r11, r11, 0x9      |  addi d6, d6, 0x8 |  NOP  |  NOP  |  NOP  }
{  NOP                     |  NOP               |  NOP  |  NOP  |  NOP  }
{  NOP                     |  NOP               |  NOP  |  NOP  |  NOP  }
{  NOP                     |  NOP               |  NOP  |  NOP  |  NOP  }                 

;************************************************************** Program Terminates
{  TRAP  |  NOP  |  NOP  |  NOP  |  NOP  }

