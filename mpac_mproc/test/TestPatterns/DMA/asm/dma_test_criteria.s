;;M1 Base Address
PACDSP0_LDM_BaseAddr = 0x24000000
PACDSP0_M2_BaseAddr  = 0x25000000

;;PACDSP M2 DMA SETTING
 PACDSP0_M2_DMA_Base = 0x25820000

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

;;================= DDR to M2 DMA SETTING ================================================= 
DMA_SAR_DATA1 = 0x30020000 ; set DDR as start address 
DMA_DAR_DATA1 = 0x25000000 ; set DMEM M2 as destination address 
DMA_SGR_DATA1 = 0x00000000 ; not used
DMA_DSR_DATA1 = 0x00000000 ; not used
DMA_CTL_DATA1 = 0x00400004 ; DMA_CTL_DATA, BSZ[31:12] 1Kbytes, External to Internal
DMA_ENA_DATA1 = 0x00000001 ; active dma
DMA_CLR_DATA1 = 0x00000000 ; not used
;==========================================================================================



DDR_InitDATA_BaseAddr = 0x30020000

Ref_Data_BaseAddr     = 0x30040000
D1_Size_Data_BaseAddr = 0x30060000

M2_TO_M1_Test_Data    = 0x25000000
M2_TO_M1_Result_Data  = 0x24004000

DDR_TO_M1_Ref_Data    = 0x24000000

DMA_M1_SR      = 0x2405C054
DMA_M2_SR      = 0x25820054


Luma_BaseAddr          = 0x30040000
Chroma_BaseAddr        = 0x30045000
M1_Luma_result         = 0x24000000 
M1_Cb_result           = 0x24001000
                       
M1_MB_Trans_2D_to_2D   = 0x24002000
M1_MB_Trans_1D_to_2D   = 0x24003000    
M2_2D_To_2D_result     = 0x25007000   
M2_1D_To_2D_result     = 0x2500F000
M2_1D_To_2D_MB_Data    = 0x25005000

DDR_2D_To_2D_result    = 0x30006000
DDR_1D_To_2D_result    = 0x3000E000

DDR_MB_2D_to_2D_result = 0x30050000
DDR_MB_1D_to_2D_result = 0x30058000

M1_Rec_MB_Addr         = 0x24006000

M1_llist_BaseAddr  = 0x24007000
LL_DMASAR_offset   = 0x0
LL_DMADAR_offset   = 0x4
LL_DMACTL_offset   = 0x8


Initial_Data:
;;DDR 0x30020000 ~ 0x300200400
{ movi r0, 0x200                     | movi a0, DDR_InitDATA_BaseAddr | movi d0, 0x00000000 | nop | nop }
INIT_DATA_FOR_DDR_TO_M2:
{ nop                                | addi d0, d0, 0x00010001        | nop                 | nop | nop }
{ nop                                | sw d0, a0, 4+                  | nop                 | nop | nop } 
{ nop                                | nop                            | nop                 | nop | nop } 
{ lbcb r0, INIT_DATA_FOR_DDR_TO_M2   | nop                            | nop                 | nop | nop } 
{ nop                                | nop                            | nop                 | nop | nop } 
{ nop                                | nop                            | nop                 | nop | nop } 
{ nop                                | nop                            | nop                 | nop | nop } 
{ nop                                | nop                            | nop                 | nop | nop } 
{ nop                                | nop                            | nop                 | nop | nop } 

Initial_Data_for_MB_Transfer:
{ movi r0, 64                  | movi a0, M1_MB_Trans_2D_to_2D | movi d0, 0x04030201 | nop                          | nop          }
_LOOP2:                                                                                                                             
{ nop                          | sw d0, a0, 4+                 | nop                 | nop                          | nop          }
{ nop                          | addi d0, d0, 0x04040404       | nop                 | nop                          | nop          }
{ lbcb r0, _LOOP2              | nop                           | nop                 | nop                          | nop          }
{ nop                          | nop                           | nop                 | nop                          | nop          } 
{ nop                          | nop                           | nop                 | nop                          | nop          } 
{ nop                          | nop                           | nop                 | nop                          | nop          } 
{ nop                          | nop                           | nop                 | nop                          | nop          } 
{ nop                          | nop                           | nop                 | nop                          | nop          } 

{ movi r0, 64                  | movi a0, M1_MB_Trans_1D_to_2D | movi d0, 0x04030201 | nop                          | nop          }
{ nop                          | nop                           | nop                 | nop                          | nop          }
_LOOP3:                                                                                                                             
{ nop                          | sw d0, a0, 4+                 | nop                 | nop                          | nop          }
{ nop                          | addi d0, d0, 0x04040404       | nop                 | nop                          | nop          }
{ lbcb r0, _LOOP3              | nop                           | nop                 | nop                          | nop          }
{ nop                          | nop                           | nop                 | nop                          | nop          } 
{ nop                          | nop                           | nop                 | nop                          | nop          } 
{ nop                          | nop                           | nop                 | nop                          | nop          } 
{ nop                          | nop                           | nop                 | nop                          | nop          } 
{ nop                          | nop                           | nop                 | nop                          | nop          } 

{ movi r0, 64                  | movi a0, M2_1D_To_2D_MB_Data | movi d0, 0x04030201 | nop                          | nop          }
_LOOP4:                                                                                                                             
{ nop                          | sw d0, a0, 4+                 | nop                 | nop                          | nop          }
{ nop                          | addi d0, d0, 0x04040404       | nop                 | nop                          | nop          }
{ lbcb r0, _LOOP4              | nop                           | nop                 | nop                          | nop          }
{ nop                          | nop                           | nop                 | nop                          | nop          } 
{ nop                          | nop                           | nop                 | nop                          | nop          } 
{ nop                          | nop                           | nop                 | nop                          | nop          } 
{ nop                          | nop                           | nop                 | nop                          | nop          } 
{ nop                          | nop                           | nop                 | nop                          | nop          } 




;;================= DDR -> M2 Size = 1K Data ==============================
  ;;M2 DMA SETTING
{ nop | nop | nop | movi a0, PACDSP0_M2_DMA_Base | movi d0, DMA_SAR_DATA1  }
{ nop | nop | nop | nop                          | movi d1, DMA_DAR_DATA1  }
{ nop | nop | nop | nop                          | clr d2                  }
{ nop | nop | nop | nop                          | nop                     }
{ nop | nop | nop | nop                          | movi d3, DMA_CTL_DATA1  }
{ nop | nop | nop | nop                          | movi d4, DMA_CLR_DATA1  }
{ nop | nop | nop | sw d0, a0, DMA_SAR0_offset   | movi d5, DMA_ENA_DATA1  }
{ nop | nop | nop | sw d1, a0, DMA_DAR0_offset   | nop                     }
{ nop | nop | nop | sw d2, a0, DMA_SGR0_offset   | nop                     }
{ nop | nop | nop | sw d2, a0, DMA_DSR0_offset   | nop                     }
{ nop | nop | nop | sw d3, a0, DMA_CTL0_offset   | nop                     }
{ nop | nop | nop | sw d4, a0, DMA_CLR0_offset   | nop                     }
{ nop | nop | nop | nop                          | nop                     }
{ nop | nop | nop | nop                          | nop                     }


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
  
  
;;================= M2 -> M1 Size = 1K Data ==============================
;;Scalar Set CH0 DMA, 
{ movi r0, PACDSP0_M2_DMA_Base  | NOP  |NOP | NOP | nop          }
;;SAR
{ movi r1, M2_TO_M1_Test_Data   | NOP | NOP  | NOP | nop          }
{ nop                           | NOP | nop  | NOP | nop          }
{ sw r1, r0, DMA_SAR0_offset    | NOP | NOP | NOP | nop          }
;;DAR
{ movi r2, M2_TO_M1_Result_Data | NOP | NOP | NOP  | nop          }
{ sw r2, r0, DMA_DAR0_offset    | NOP | NOP | NOP  | nop          }
;;SGR
{ movi r3, 0x00000000           | NOP | NOP   | NOP          | nop          }
{ sw r3, r0, DMA_SGR0_offset    | NOP | NOP    | NOP   | nop          }
;;DSR
{ movi r4, 0x00000000           | NOP | NOP   | NOP          | nop          }
{ sw r4, r0, DMA_DSR0_offset    | NOP | NOP    | NOP   | nop          }
;;CTL
{ movi r5, 0x0040000C           | NOP | NOP | NOP         | nop          }
{ sw r5, r0, DMA_CTL0_offset    | NOP | NOP   | NOP   | nop          }
;;Enable DMA
{ movi r6, 0x1                  | NOP | NOP        | NOP                 | nop          }
{ sw r6, r0, DMA_ENA0_offset    | NOP | NOP  | NOP   | nop          }
{  NOP                          | NOP | NOP  |  NOP  |  NOP  }
{  NOP                          | NOP | NOP  |  NOP  |  NOP  }
;;WAIT DMA Transfer Complete
;************************************************************** wait until DMA done
{  MOVI R5, DMA_M2_SR      |  NOP  |  NOP  |  NOP  |  NOP  }
_Label1:
{  LW R6, R5, 0            |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                     |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                     |  NOP  |  NOP  |  NOP  |  NOP  }
{  SEQI R7, P1, P2, R6, 0x00000002  |  NOP  |  NOP  |  NOP  |  NOP  }
{  (P2)B _Label1           |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                     |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                     |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                     |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                     |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                     |  NOP  |  NOP  |  NOP  |  NOP  }    



;;============================== Sim Ref. DATA, DDR -> M1 ========================================

;======= CLEAR DMA STATUS scalar clr ch0, c1 clr ch1, c2 clr ch2, ch3 ======================

{ movi r0, PACDSP0_M1_DMA_Base | movi a0, PACDSP0_M1_DMA_Base  | movi d0, 0x1        | movi a0, PACDSP0_M1_DMA_Base | movi d0, 0x1 }
{ movi r1, 0x1                 | sw d0, a0, DMA_CLR1_offset    | nop                 | nop                          | nop          }
{ sw r1, r0, DMA_CLR0_offset   | nop                           | nop                 | nop                          | nop          }
{ movi r11, 0                  | nop                           | nop                 | nop                          | nop          }
{ movi r10, 16                 | movi d6, 0                    | nop                 | nop                          | nop          }
{ movi r8, 0                   | movi d7, 0                    | nop                 | nop                          | nop          }

;;CH0 Test 2D -> 1D 16 9x9 Luma Transfer, CH1 Test 2D -> 1D 32 4x4 Chroma Transfer

Sim_Trans_Ref_Data:
{ nop                          | bdt d6                        | nop                 | bdr d6                     | nop          }
{ nop                          | bdt d7                        | nop                 | bdr d7                     | nop          }

;;Scalar Set CH0 DMA, C1 set CH1 DMA, C2 set CH2 DMA
{ movi r0, PACDSP0_M1_DMA_Base | movi a0, PACDSP0_M1_DMA_Base  | nop                 | movi a0, M1_llist_BaseAddr  | nop          }
;;SAR                                                                                      
{ movi r1, Luma_BaseAddr       | movi d0, Chroma_BaseAddr      | nop                 | movi d0, Chroma_BaseAddr    | nop          }
{ add r1, r1, r11              | add d0, d0, d6                | nop                 | addi d0, d0, 0x4            | nop          }
{ sw r1, r0, DMA_SAR0_offset   | sw d0, a0, DMA_SAR1_offset    | nop                 | add d0, d0, d6              | nop          }
;;DAR                                                                                      
{ movi r2, M1_Luma_result      | movi a1, M1_Cb_result         | nop                 | sw d0, a0, LL_DMASAR_offset | nop          }
{ add r2, r2, r8               | add a1, a1, d7                | nop                 | movi a1, M1_Cb_result       | nop          }
{ sw r2, r0, DMA_DAR0_offset   | sw a1, a0, DMA_DAR1_offset    | nop                 | add  a1, a1, d7             | nop          }
;;SGR                                                                                      
{ movi r3, 0x00900780          | movi d1, 0x00400780           | nop                 | addi a1, a1, 0x10           | nop          }
{ sw r3, r0, DMA_SGR0_offset   | sw d1, a0, DMA_SGR1_offset    | nop                 | sw a1, a0, LL_DMADAR_offset | nop          }
;;DSR                                                                                      
{ movi r4, 0x00000000          | movi d2, 0x00000000           | nop                 | movi d3, 0x00010104         | nop          }
{ sw r4, r0, DMA_DSR0_offset   | sw d2, a0, DMA_DSR1_offset    | nop                 | sw d3, a0, LL_DMACTL_offset | nop          }
;;CTL                                                                                      
{ movi r5, 0x00051104          | movi d3, 0x00010904           | nop                 | nop | nop          }
{ sw r5, r0, DMA_CTL0_offset   | sw d3, a0, DMA_CTL1_offset    | nop                 | nop | nop          }
;;LLIST SETING
{  nop                         | movi d5, 0x19007000           | nop                 | nop | nop }
{  nop                         | sw d5, a0, DMA_LLST1_offset   | nop                 | nop | nop }
{  NOP                         |  NOP                          |  NOP                | NOP | NOP  }
{  NOP                         |  NOP                          |  NOP                | NOP | NOP  }
;;Enable DMA                                                                               
{ movi r6, 0x1                 | movi d4, 0x1                  | nop                 | nop | nop          }
{ sw r6, r0, DMA_ENA0_offset   | sw d4, a0, DMA_ENA1_offset    | nop                 | nop | nop          }
{  NOP                         |  NOP                          |  NOP                | NOP | NOP  }
{  NOP                         |  NOP                          |  NOP                | NOP | NOP  }
;;WAIT DMA Transfer Complete
;************************************************************** wait until DMA done
{  MOVI R5, DMA_M1_SR      |  NOP  |  NOP  |  NOP  |  NOP  }
_Label2:
{  LW R6, R5, 0            |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                     |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                     |  NOP  |  NOP  |  NOP  |  NOP  }
{  SEQI R7, P1, P2, R6, 0x00000022  |  NOP  |  NOP  |  NOP  |  NOP  }
{  (P2)B _Label2           |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                     |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                     |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                     |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                     |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                     |  NOP  |  NOP  |  NOP  |  NOP  }       

{ LBCB r10, Sim_Trans_Ref_Data  |  NOP               |  NOP  |  NOP  |  NOP  }    
{  addi r8, r8, 0x60            |  addi d7, d7, 0x20  |  NOP  |  NOP  |  NOP  }
{  addi r11, r11, 0x9           |  addi d6, d6, 0x8 |  NOP  |  NOP  |  NOP  }
{  NOP                          |  NOP               |  NOP  |  NOP  |  NOP  }
{  NOP                          |  NOP               |  NOP  |  NOP  |  NOP  }
{  NOP                          |  NOP               |  NOP  |  NOP  |  NOP  }           


;;================================== SIM MB Transfer, M1->M2 Memory ===============================
;;CH0 Test 2D -> 2D Transfer, CH2 Test 1D -> 2D

;;Scalar Set CH0 DMA, C2 set CH2 DMA
{ movi r0, PACDSP0_M1_DMA_Base    | nop | nop                 | movi a0, PACDSP0_M1_DMA_Base  | nop          }
;;SAR                             
{ movi r1, M1_MB_Trans_2D_to_2D   | nop | nop                 | movi d0, M1_MB_Trans_1D_to_2D   | nop          }
{ nop                             | nop | nop                 | nop                           | nop          }
{ sw r1, r0, DMA_SAR0_offset      | nop | nop                 | sw d0, a0, DMA_SAR2_offset    | nop          }
;;DAR                                                                                       
{ movi r2, M2_2D_To_2D_result | nop | nop                 | movi a1, M2_1D_To_2D_result   | nop          }
{ sw r2, r0, DMA_DAR0_offset      | nop | nop                 | sw a1, a0, DMA_DAR2_offset    | nop          }
;;SGR                                                                                         
{ movi r3, 0x01000010             | nop | nop                 | movi d1, 0x00000000           | nop          }
{ sw r3, r0, DMA_SGR0_offset      | nop | nop                 | sw d1, a0, DMA_SGR2_offset    | nop          }
;;DSR                                                                                         
{ movi r4, 0x01000780             | nop | nop                 | movi d2, 0x01000780           | nop          }
{ sw r4, r0, DMA_DSR0_offset      | nop | nop                 | sw d2, a0, DMA_DSR2_offset    | nop          }
;;CTL                                                                                         
{ movi r5, 0x0010030C             | nop | nop                 | movi d3, 0x0010020C           | nop          }
{ sw r5, r0, DMA_CTL0_offset      | nop | nop                 | sw d3, a0, DMA_CTL2_offset    | nop          }
;;Enable DMA                                                                                  
{ movi r6, 0x1                    | nop | nop                 | movi d4, 0x1                  | nop          }
{ sw r6, r0, DMA_ENA0_offset      | nop | nop                 | sw d4, a0, DMA_ENA2_offset    | nop          }
{  NOP                            | NOP | NOP                 | NOP                           | NOP  }
{  NOP                            | NOP | NOP                 | NOP                           | NOP  }
;;WAIT DMA Transfer Complete
;************************************************************** wait until DMA done
{  MOVI R5, DMA_M1_SR      |  NOP  |  NOP  |  NOP  |  NOP  }
_Label3:
{  LW R6, R5, 0            |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                     |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                     |  NOP  |  NOP  |  NOP  |  NOP  }
{  SEQI R7, P1, P2, R6, 0x00000202  |  NOP  |  NOP  |  NOP  |  NOP  }
{  (P2)B _Label3           |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                     |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                     |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                     |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                     |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                     |  NOP  |  NOP  |  NOP  |  NOP  }

;;================================== SIM MB Transfer, M2->DDR Memory ===============================                           
;;Scalar Set CH0 DMA, C2 set CH2 DMA
{ movi r0, PACDSP0_M2_DMA_Base    | nop | nop                 | movi a0, PACDSP0_M2_DMA_Base    | nop          }
;;SAR                                                                                           
{ movi r1, M2_2D_To_2D_result     | nop | nop                 | movi d0, M2_1D_To_2D_MB_Data    | nop          }
{ nop                             | nop | nop                 | nop                             | nop          }
{ sw r1, r0, DMA_SAR0_offset      | nop | nop                 | sw d0, a0, DMA_SAR2_offset      | nop          }
;;DAR                             
{ movi r2, DDR_MB_2D_to_2D_result | nop | nop                 | movi a1, DDR_MB_1D_to_2D_result | nop          }
{ sw r2, r0, DMA_DAR0_offset      | nop | nop                 | sw a1, a0, DMA_DAR2_offset      | nop          }
;;SGR                                                                                           
{ movi r3, 0x01000780             | nop | nop                 | movi d1, 0x00000000             | nop          }
{ sw r3, r0, DMA_SGR0_offset      | nop | nop                 | sw d1, a0, DMA_SGR2_offset      | nop          }
;;DSR                                                                                           
{ movi r4, 0x01000780             | nop | nop                 | movi d2, 0x01000780             | nop          }
{ sw r4, r0, DMA_DSR0_offset      | nop | nop                 | sw d2, a0, DMA_DSR2_offset      | nop          }
;;CTL                                                                                           
{ movi r5, 0x0010030C             | nop | nop                 | movi d3, 0x0010020C             | nop          }
{ sw r5, r0, DMA_CTL0_offset      | nop | nop                 | sw d3, a0, DMA_CTL2_offset      | nop          }
;;Enable DMA                                                                                    
{ movi r6, 0x1                    | nop | nop                 | movi d4, 0x1                    | nop          }
{ sw r6, r0, DMA_ENA0_offset      | nop | nop                 | sw d4, a0, DMA_ENA2_offset      | nop          }
{  NOP                            |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                            |  NOP  |  NOP  |  NOP  |  NOP  }
;;WAIT DMA Transfer Complete
;************************************************************** wait until DMA done
{  MOVI R5, DMA_M2_SR      |  NOP  |  NOP  |  NOP  |  NOP  }
_Label4:
{  LW R6, R5, 0            |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                     |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                     |  NOP  |  NOP  |  NOP  |  NOP  }
{  SEQI R7, P1, P2, R6, 0x00000202  |  NOP  |  NOP  |  NOP  |  NOP  }
{  (P2)B _Label4           |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                     |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                     |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                     |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                     |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                     |  NOP  |  NOP  |  NOP  |  NOP  }  

;;================================== SIM MB Transfer, M1->DDR Memory ===============================                               

;;CH0 Test 2D -> 2D Transfer, CH2 Test 1D -> 2D

;;Scalar Set CH0 DMA, C2 set CH2 DMA
{ movi r0, PACDSP0_M1_DMA_Base    | nop | nop                 | movi a0, PACDSP0_M1_DMA_Base  | nop          }
;;SAR                             
{ movi r1, M1_MB_Trans_2D_to_2D   | nop | nop                 | movi d0, M1_MB_Trans_1D_to_2D | nop          }
{ nop                             | nop | nop                 | nop                           | nop          }
{ sw r1, r0, DMA_SAR0_offset      | nop | nop                 | sw d0, a0, DMA_SAR2_offset    | nop          }
;;DAR                                                                                       
{ movi r2, DDR_2D_To_2D_result    | nop | nop                 | movi a1, DDR_1D_To_2D_result  | nop          }
{ sw r2, r0, DMA_DAR0_offset      | nop | nop                 | sw a1, a0, DMA_DAR2_offset    | nop          }
;;SGR                                                                                         
{ movi r3, 0x01000010             | nop | nop                 | movi d1, 0x00000000           | nop          }
{ sw r3, r0, DMA_SGR0_offset      | nop | nop                 | sw d1, a0, DMA_SGR2_offset    | nop          }
;;DSR                                                                                         
{ movi r4, 0x01000780             | nop | nop                 | movi d2, 0x01000780           | nop          }
{ sw r4, r0, DMA_DSR0_offset      | nop | nop                 | sw d2, a0, DMA_DSR2_offset    | nop          }
;;CTL                                                                                         
{ movi r5, 0x0010030C             | nop | nop                 | movi d3, 0x0010020C           | nop          }
{ sw r5, r0, DMA_CTL0_offset      | nop | nop                 | sw d3, a0, DMA_CTL2_offset    | nop          }
;;Enable DMA                                                                                  
{ movi r6, 0x1                    | nop | nop                 | movi d4, 0x1                  | nop          }
{ sw r6, r0, DMA_ENA0_offset      | nop | nop                 | sw d4, a0, DMA_ENA2_offset    | nop          }
{  NOP                            | NOP | NOP                 | NOP                           | NOP  }
{  NOP                            | NOP | NOP                 | NOP                           | NOP  }
;;WAIT DMA Transfer Complete
;************************************************************** wait until DMA done
{  MOVI R5, DMA_M1_SR      |  NOP  |  NOP  |  NOP  |  NOP  }
_Label5:
{  LW R6, R5, 0            |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                     |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                     |  NOP  |  NOP  |  NOP  |  NOP  }
{  SEQI R7, P1, P2, R6, 0x00000202  |  NOP  |  NOP  |  NOP  |  NOP  }
{  (P2)B _Label5           |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                     |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                     |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                     |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                     |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                     |  NOP  |  NOP  |  NOP  |  NOP  }


;;Generate D1 Size Data in DDR Memory
{ movi r0, 0x1EF00         | movi a0, D1_Size_Data_BaseAddr | movi d0, 0x00000001 | nop | nop }
Gen_Data:
{ lbcb r0, Gen_Data        | sw d0, a0, 4+                  | nop                 | nop | nop }
{ nop                      | addi d0, d0, 0x1               | nop                 | nop | nop }
{ NOP                      | NOP                            | NOP                 | NOP |  NOP  }
{ NOP                      | NOP                            | NOP                 | NOP |  NOP  }
{ NOP                      | NOP                            | NOP                 | NOP |  NOP  }
{ NOP                      | NOP                            | NOP                 | NOP |  NOP  }
{ NOP                      | NOP                            | NOP                 | NOP |  NOP  }  


{ TRAP                     | nop | nop | nop | nop }            
     