;===============================================================================
; Author: Jack
; Description: Move 1KB data from M2 to DDR by DMA
; Date: 2009/11/04
;===============================================================================

  INI_NUM = 512
  M2_BASE = 0x25000000
  M1_BASE = 0x24000000
  
  
;===== Initialize 2KB M2 =====

  {  MOVI R0, 0x03020100 | NOP | NOP | NOP | NOP }
  {  MOVI R1,  M2_BASE  | NOP | NOP | NOP | NOP }  
  {  MOVI R10, INI_NUM   | NOP | NOP | NOP | NOP }
INIT_DATA:
  {  SW R0, R1, 4+       | NOP | NOP | NOP | NOP }
  {  ADDI R0, R0, 0x04040404 | NOP | NOP | NOP | NOP }
  {  LBCB R10, INIT_DATA | NOP | NOP | NOP | NOP }
  {  NOP | NOP | NOP | NOP | NOP }
  {  NOP | NOP | NOP | NOP | NOP }
  {  NOP | NOP | NOP | NOP | NOP }
  {  NOP | NOP | NOP | NOP | NOP }
  {  NOP | NOP | NOP | NOP | NOP }  
  
  
;===== Move 1KB data from M2 to M1 =====  

  ;=== PACDMA Setting, M2 -> M1 ===
  DMA_SAR_ADDR1 = 0x258200B0 ;
  DMA_DAR_ADDR1 = 0x258200B4 ;
  DMA_SGR_ADDR1 = 0x258200B8 ;
  DMA_DSR_ADDR1 = 0x258200BC ;
  DMA_CTL_ADDR1 = 0x258200C0 ;
  DMA_ENA_ADDR1 = 0x258200C4 ;
  DMA_CLR_ADDR1 = 0x258200C8 ;
                             
  DMA_SAR_DATA1 = 0x25000000 ; set M2 as start address 
  DMA_DAR_DATA1 = 0x24000000 ; set M1 as destination address 
  DMA_SGR_DATA1 = 0x00000000 ; not used
  DMA_DSR_DATA1 = 0x00000000 ; not used
  DMA_CTL_DATA1 = 0x0040000C ; DMA_CTL_DATA, BSZ[31:12], DSEN[9], SGEN[8], Int2Ext[3], TRZ[1:0]
  DMA_ENA_DATA1 = 0x00000000 ; active dma
  DMA_CLR_DATA1 = 0x00000000 ; not used

  DMA_STATUS_ADDR = 0x25820054;
    
  { MOVI r0, DMA_SAR_ADDR1 | NOP | NOP | NOP | NOP } 
  { MOVI r1, DMA_SAR_DATA1 | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x0         | NOP | NOP | NOP | NOP }
  
  { MOVI r0, DMA_DAR_ADDR1 | NOP | NOP | NOP | NOP } 
  { MOVI r1, DMA_DAR_DATA1 | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x0         | NOP | NOP | NOP | NOP }
  
  { MOVI r0, DMA_SGR_ADDR1 | NOP | NOP | NOP | NOP } 
  { MOVI r1, DMA_SGR_DATA1 | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x0         | NOP | NOP | NOP | NOP }
  
  { MOVI r0, DMA_DSR_ADDR1 | NOP | NOP | NOP | NOP } 
  { MOVI r1, DMA_DSR_DATA1 | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x0         | NOP | NOP | NOP | NOP }

  { MOVI r0, DMA_CTL_ADDR1 | NOP | NOP | NOP | NOP } 
  { MOVI r1, DMA_CTL_DATA1 | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x0         | NOP | NOP | NOP | NOP }
  
  { MOVI r0, DMA_ENA_ADDR1 | NOP | NOP | NOP | NOP } 
  { MOVI r1, DMA_ENA_DATA1 | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x0         | NOP | NOP | NOP | NOP }
  
  ;=== waiting dma finish transfer ===
  { MOVI r0, DMA_STATUS_ADDR | NOP | NOP | NOP | NOP }
M2M1:    
  { LW r1, r0, 0x0  | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }
  { SEQI r2, p1, p2, r1, 0x22222222 | NOP | NOP | NOP | NOP }     ; (DMA_STATUS == 0) ? 
  { (p2) B M2M1                 | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }  
  { NOP | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }  
  { NOP | NOP | NOP | NOP | NOP }
  
  ;=== SDMA Setting, DMEM -> DDR ===
  DMA_SAR_ADDR1 = 0x1C100090 ;
  DMA_DAR_ADDR1 = 0x1C100094 ;
  DMA_SGR_ADDR1 = 0x1C100098 ;
  DMA_DSR_ADDR1 = 0x1C10009C ;
  DMA_CTL_ADDR1 = 0x1C1000A0 ;
  DMA_ENA_ADDR1 = 0x1C1000A4 ;
  DMA_CLR_ADDR1 = 0x1C1000A8 ;
                             
  DMA_SAR_DATA1 = 0x24000000 ; set DMEM as start address 
  DMA_DAR_DATA1 = 0x30000000 ; set DDR as destination address 
  DMA_SGR_DATA1 = 0x00000000 ; not used
  DMA_DSR_DATA1 = 0x00000000 ; not used
  DMA_CTL_DATA1 = 0x00100003 ; DMA_CTL_DATA, BSZ[31:10]
  DMA_ENA_DATA1 = 0x00000000 ; active dma
  DMA_CLR_DATA1 = 0x00000000 ; not used
  
  SDMA_STATUS_ADDR = 0x1C100300;
   
  { MOVI r0, DMA_CLR_ADDR1 | NOP | NOP | NOP | NOP } 
  { MOVI r1, DMA_CLR_DATA1 | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x0 | NOP | NOP | NOP | NOP } 
    
  { MOVI r0, DMA_SAR_ADDR1 | NOP | NOP | NOP | NOP } 
  { MOVI r1, DMA_SAR_DATA1 | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x0 | NOP | NOP | NOP | NOP }
  
  { MOVI r0, DMA_DAR_ADDR1 | NOP | NOP | NOP | NOP } 
  { MOVI r1, DMA_DAR_DATA1 | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x0 | NOP | NOP | NOP | NOP }
  
  { MOVI r0, DMA_CTL_ADDR1 | NOP | NOP | NOP | NOP } 
  { MOVI r1, DMA_CTL_DATA1 | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x0 | NOP | NOP | NOP | NOP }
  
  { MOVI r0, DMA_ENA_ADDR1 | NOP | NOP | NOP | NOP } 
  { MOVI r1, DMA_ENA_DATA1 | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x0 | NOP | NOP | NOP | NOP }
    
  ;=== waiting dma finish transfer ===
  { MOVI r0, SDMA_STATUS_ADDR | NOP | NOP | NOP | NOP }
DMEM2DDR:    
  { LW r1, r0, 0x0 | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }
  { SEQI r2, p1, p2, r1, 0x0 | NOP | NOP | NOP | NOP }     ; (DMA_STATUS == 0) ? 
  { (p2) B DMEM2DDR          | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }  
  { NOP | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }  
  { NOP | NOP | NOP | NOP | NOP }
;===== Move 1KB data from M1 to M2 =====  

  ;=== PACDMA Setting, M1 -> M2 ===
  DMA_SAR_ADDR1 = 0x258200B0 ;
  DMA_DAR_ADDR1 = 0x258200B4 ;
  DMA_SGR_ADDR1 = 0x258200B8 ;
  DMA_DSR_ADDR1 = 0x258200BC ;
  DMA_CTL_ADDR1 = 0x258200C0 ;
  DMA_ENA_ADDR1 = 0x258200C4 ;
  DMA_CLR_ADDR1 = 0x258200C8 ;
                             
  DMA_SAR_DATA1 = 0x24000000 ; set M1 as start address 
  DMA_DAR_DATA1 = 0x25001000 ; set M2 as destination address 
  DMA_SGR_DATA1 = 0x00000000 ; not used
  DMA_DSR_DATA1 = 0x00000000 ; not used
  DMA_CTL_DATA1 = 0x00400004 ; DMA_CTL_DATA, BSZ[31:12], DSEN[9], SGEN[8], Int2Ext[3], TRZ[1:0]
  DMA_ENA_DATA1 = 0x00000000 ; active dma
  DMA_CLR_DATA1 = 0x00000000 ; not used

  DMA_STATUS_ADDR = 0x25820054;
    
  { MOVI r0, DMA_SAR_ADDR1 | NOP | NOP | NOP | NOP } 
  { MOVI r1, DMA_SAR_DATA1 | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x0         | NOP | NOP | NOP | NOP }
  
  { MOVI r0, DMA_DAR_ADDR1 | NOP | NOP | NOP | NOP } 
  { MOVI r1, DMA_DAR_DATA1 | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x0         | NOP | NOP | NOP | NOP }
  
  { MOVI r0, DMA_SGR_ADDR1 | NOP | NOP | NOP | NOP } 
  { MOVI r1, DMA_SGR_DATA1 | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x0         | NOP | NOP | NOP | NOP }
  
  { MOVI r0, DMA_DSR_ADDR1 | NOP | NOP | NOP | NOP } 
  { MOVI r1, DMA_DSR_DATA1 | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x0         | NOP | NOP | NOP | NOP }

  { MOVI r0, DMA_CTL_ADDR1 | NOP | NOP | NOP | NOP } 
  { MOVI r1, DMA_CTL_DATA1 | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x0         | NOP | NOP | NOP | NOP }
  
  { MOVI r0, DMA_ENA_ADDR1 | NOP | NOP | NOP | NOP } 
  { MOVI r1, DMA_ENA_DATA1 | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x0         | NOP | NOP | NOP | NOP }
  
  ;=== waiting dma finish transfer ===
  { MOVI r0, DMA_STATUS_ADDR | NOP | NOP | NOP | NOP }
  { MOVI r3, 0x24000000 | NOP | NOP | NOP | NOP }  
M1M2:    
  { LW r4, r3, 0x0  | NOP | NOP | NOP | NOP }  
  { LW r1, r0, 0x0  | NOP | NOP | NOP | NOP }
  { LW r4, r3, 0x0  | NOP | NOP | NOP | NOP }  
  { NOP | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }
  { SEQI r2, p1, p2, r1, 0x22222222 | NOP | NOP | NOP | NOP }     ; (DMA_STATUS == 0) ? 
  { (p2) B M1M2                 | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }  
  { NOP | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }  
  { NOP | NOP | NOP | NOP | NOP }
    
;************************************************************** Program Terminate
   
  {  TRAP  |  NOP  |  NOP  |  NOP  |  NOP  }
  
