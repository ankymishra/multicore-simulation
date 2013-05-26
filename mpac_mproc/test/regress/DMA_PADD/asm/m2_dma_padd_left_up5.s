;===============================================================================
; Author: Jiahao
; Description: Move 1KB data from LDM to DDR, and from DDR to LDM by DMA
; Date: 2009/11/04
;===============================================================================

  INI_NUM = 512
  LDM1_BASE = 0x25000000
  DDR_BASE  = 0x30000000
  LDM0_BASE = 0x25001000  
  
;===== Initialize 2KB Local Data Memory =====

  {  MOVI R0, 0x03020100 | NOP | NOP | NOP | NOP }
  {  MOVI R1,  DDR_BASE  | NOP | NOP | NOP | NOP }  
  {  MOVI R10, INI_NUM   | NOP | NOP | NOP | NOP }
INIT_DATA1:
  {  SW R0, R1, 4+       | NOP | NOP | NOP | NOP }
  {  ADDI R0, R0, 0x04040404 | NOP | NOP | NOP | NOP }
  {  LBCB R10, INIT_DATA1 | NOP | NOP | NOP | NOP }
  {  NOP | NOP | NOP | NOP | NOP }
  {  NOP | NOP | NOP | NOP | NOP }
  {  NOP | NOP | NOP | NOP | NOP }
  {  NOP | NOP | NOP | NOP | NOP }
  {  NOP | NOP | NOP | NOP | NOP }  

  {  MOVI R0, 0x00000000 | NOP | NOP | NOP | NOP }
  {  MOVI R1,  LDM0_BASE  | NOP | NOP | NOP | NOP }  
  {  MOVI R10, INI_NUM   | NOP | NOP | NOP | NOP }
INIT_DATA0:
  {  SW R0, R1, 4+       | NOP | NOP | NOP | NOP }
  {  ADDI R0, R0, 0x00000000 | NOP | NOP | NOP | NOP }
  {  LBCB R10, INIT_DATA0 | NOP | NOP | NOP | NOP }
  {  NOP | NOP | NOP | NOP | NOP }
  {  NOP | NOP | NOP | NOP | NOP }
  {  NOP | NOP | NOP | NOP | NOP }
  {  NOP | NOP | NOP | NOP | NOP }
  {  NOP | NOP | NOP | NOP | NOP }  
    
;===== Move 2KB data from DDR to LDM =====  
  
  ;=== PACDMA Setting, DDR -> DMEM ===
  DMA_SAR_ADDR0 = 0x25820070 ;
  DMA_DAR_ADDR0 = 0x25820074 ;
  DMA_SGR_ADDR0 = 0x25820078 ;
  DMA_DSR_ADDR0 = 0x2582007C ;
  DMA_CTL_ADDR0 = 0x25820080 ;
  DMA_ENA_ADDR0 = 0x25820084 ;
  DMA_CLR_ADDR0 = 0x25820088 ;
  DMA_PAD_ADDR0 = 0x25820090 ;

  DMA_SAR_DATA0 = 0x30000000 ; set DDR as start address 
  DMA_DAR_DATA0 = 0x25000FFB ; set DMEM as destination address 
  DMA_SGR_DATA0 = 0x01F00020 ; set SGC[31:20]:8, SGO[19:0]:14
  DMA_DSR_DATA0 = 0x01F00031 ; set DSC[31:20]:8, DSO[19:0]:14
  DMA_CTL_DATA0 = 0x000F8306 ; DMA_CTL_DATA,BSZ[31:20], DSEN[9], SGEN[8], Int2Ext[4], TRZ[1:0]
  DMA_ENA_DATA0 = 0x00000000 ; active dma
  DMA_CLR_DATA0 = 0x00000000 ; not used 
  DMA_PAD_DATA0 = 0x03052301 ; PAD_NUM2[31:24],PAD_NUM1[23:16],PAD_UNIT2[15:12],PAD_UNIT1[11:8],PAD_DIR2[5],PAD_DIR1[4],PAD_EN[0]
                             ; up or down     ,left or right  ,up or down      ,left or right  ,0:up,1:down,0:left,1:right            

  DMA_STATUS_ADDR = 0x25820054;

  { MOVI r0, DMA_SAR_ADDR0 | NOP | NOP | NOP | NOP } 
  { MOVI r1, DMA_SAR_DATA0 | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x0         | NOP | NOP | NOP | NOP }
  
  { MOVI r0, DMA_DAR_ADDR0 | NOP | NOP | NOP | NOP } 
  { MOVI r1, DMA_DAR_DATA0 | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x0         | NOP | NOP | NOP | NOP }
  
  { MOVI r0, DMA_SGR_ADDR0 | NOP | NOP | NOP | NOP } 
  { MOVI r1, DMA_SGR_DATA0 | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x0         | NOP | NOP | NOP | NOP }
  
  { MOVI r0, DMA_DSR_ADDR0 | NOP | NOP | NOP | NOP } 
  { MOVI r1, DMA_DSR_DATA0 | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x0         | NOP | NOP | NOP | NOP }
  
  { MOVI r0, DMA_CTL_ADDR0 | NOP | NOP | NOP | NOP } 
  { MOVI r1, DMA_CTL_DATA0 | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x0         | NOP | NOP | NOP | NOP }

  { MOVI r0, DMA_PAD_ADDR0 | NOP | NOP | NOP | NOP } 
  { MOVI r1, DMA_PAD_DATA0 | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x0         | NOP | NOP | NOP | NOP }

  { MOVI r0, DMA_ENA_ADDR0 | NOP | NOP | NOP | NOP } 
  { MOVI r1, DMA_ENA_DATA0 | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x0         | NOP | NOP | NOP | NOP }


  ;=== waiting dma finish transfer ===
  { MOVI r0, DMA_STATUS_ADDR | NOP | NOP | NOP | NOP }
  { MOVI r3, LDM0_BASE | NOP | NOP | NOP | NOP }    
DDR2DMEM:    
  { LW r1, r0, 0x0 | NOP | NOP | NOP | NOP }
  { LW r4, r3, 0x0 | NOP | NOP | NOP | NOP }  
  { NOP | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }
  { SEQI r2, p1, p2, r1, 0x22222222 | NOP | NOP | NOP | NOP }     ; (DMA_STATUS == 0) ? 
  { (p2) B DDR2DMEM                 | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }  
  { NOP | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }  
  { NOP | NOP | NOP | NOP | NOP }


;************************************************************** Program Terminate
   
  {  TRAP  |  NOP  |  NOP  |  NOP  |  NOP  }  
  
  
