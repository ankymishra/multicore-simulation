;===============================================================================
; Author: Jiahao
; Description: Move 1KB data from LDM to DDR, and from DDR to LDM by DMA
; Date: 2009/11/04
;===============================================================================

  WORD_SIZE = 512
  DMEM_BASE = 0x24100000
  M2_BASE = 0x2500C000  
  M2_SHP_ADDR0 = 0x25820094
  M2_REX_ADDR0 = 0x25820098
  M2_SHP_ADDR1 = 0x258200D4
  M2_REX_ADDR1 = 0x258200D8
  DDR_BASE  = 0x3000C000
  DspDMURegister = 0x2415
  C0_START_C1_DMA = 0x25010000
  C0_START_C1_DMA1 = 0x25010004 

;************************************************************** Initial data  
  {  NOP | NOP | NOP | NOP | NOP }
  {  MOVI R0, 0x03020100     | NOP | NOP | NOP | NOP }
  {  MOVI R1, DMEM_BASE  | NOP | NOP | NOP | NOP }  
  {  MOVI R10, WORD_SIZE | NOP | NOP | NOP | NOP }
INIT_DATA:
  {  SW R0, R1, 4+ | NOP | NOP | NOP | NOP }
  {  ADDI R0, R0, 0x04040404 | NOP | NOP | NOP | NOP }
  {  LBCB R10, INIT_DATA | NOP | NOP | NOP | NOP }
  {  NOP | NOP | NOP | NOP | NOP }
  {  NOP | NOP | NOP | NOP | NOP }
  {  NOP | NOP | NOP | NOP | NOP }
  {  NOP | NOP | NOP | NOP | NOP }
  {  NOP | NOP | NOP | NOP | NOP }

;clear c0 give c1 pointer
  { MOVI r0, C0_START_C1_DMA | NOP | NOP | NOP | NOP } 
  { MOVI r1, 0x0 | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x0         | NOP | NOP | NOP | NOP }  
  
;===== Move 1KB data from LDM to DDR =====  

  ;=== PACDMA Setting, DMEM -> DDR ===
  DMA_SAR_ADDR1 = 0x2415C0B0 ;
  DMA_DAR_ADDR1 = 0x2415C0B4 ;
  DMA_SGR_ADDR1 = 0x2415C0B8 ;
  DMA_DSR_ADDR1 = 0x2415C0BC ;
  DMA_CTL_ADDR1 = 0x2415C0C0 ;
  DMA_ENA_ADDR1 = 0x2415C0C4 ;
  DMA_CLR_ADDR1 = 0x2415C0C8 ;
                             
  DMA_SAR_DATA1 = 0x24100000 ; set DMEM as start address 
  DMA_DAR_DATA1 = 0x25008000 ; set M2 memory as destination address 
  DMA_SGR_DATA1 = 0x00000000 ; not used
  DMA_DSR_DATA1 = 0x00000000 ; not used
  DMA_CTL_DATA1 = 0x0040000C ; DMA_CTL_DATA, BSZ[31:20], DSEN[9], SGEN[8], Int2Ext[3], Burst[2], TRZ[1:0]
  DMA_ENA_DATA1 = 0x00000000 ; active dma
  DMA_CLR_DATA1 = 0x00000001 ;

  DMA_STATUS_ADDR = 0x24158054;

;======================== Move 1KB data from M1 to M2 =========================

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

;check c0 give c1 pointer  
  { MOVI r0, C0_START_C1_DMA | NOP | NOP | NOP | NOP } 
chk_start_pointer:    
  { LW r1, r0, 0x0  | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }
  { SEQI r2, p1, p2, r1, 0x11223344 | NOP | NOP | NOP | NOP }     ; (DMA_STATUS == 0) ? 
  { (p2) B chk_start_pointer                 | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }  
  { NOP | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }  
  { NOP | NOP | NOP | NOP | NOP }
    
  { MOVI r0, DMA_ENA_ADDR1 | NOP | NOP | NOP | NOP } 
  { MOVI r1, DMA_ENA_DATA1 | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x0         | NOP | NOP | NOP | NOP }

;======================== Move 1KB data from M2 to DDR =========================  
  
  ;=== waiting dma finish transfer ===
  { MOVI r0, DMA_STATUS_ADDR | NOP | NOP | NOP | NOP }  
;set M2 memory  
  { MOVI r6, M2_BASE | NOP | NOP | NOP | NOP }    
  { MOVI r7, 0x12345678 | NOP | NOP | NOP | NOP }      
  { SW r7, r6, 0x0         | NOP | NOP | NOP | NOP }  
;set DDR  
  { MOVI r8, DDR_BASE | NOP | NOP | NOP | NOP }    
  { MOVI r9, 0x87654321 | NOP | NOP | NOP | NOP }      
  { SW r9, r8, 0x0         | NOP | NOP | NOP | NOP }  
;set M2 REG DMASHAPE0
  { MOVI r10, M2_SHP_ADDR0 | NOP | NOP | NOP | NOP }    
  { MOVI r11, 0x11223344 | NOP | NOP | NOP | NOP }      
  { SW r11, r10, 0x0  | NOP | NOP | NOP | NOP }  

DMEM2DDR:    
  { LW r1, r0, 0x0  | NOP | NOP | NOP | NOP }
;read M2 memory  
  { LW r3, r6, 0x0 | NOP | NOP | NOP | NOP }  
;read DDR 
  { LW r4, r8, 0x0 | NOP | NOP | NOP | NOP }  
;read M2 REG DMASHAPE0 
  { LW r5, r10, 0x0 | NOP | NOP | NOP | NOP }    
  { NOP | NOP | NOP | NOP | NOP }
;write M2 memory    
  { SW r3, r6, 0x4 | NOP | NOP | NOP | NOP }    
;write DDR     
  { SW r4, r8, 0x4 | NOP | NOP | NOP | NOP }  
;write M2 REG DMAREX0
  { MOVI r10, M2_REX_ADDR0 | NOP | NOP | NOP | NOP }    
  { SW r5, r10, 0x0 | NOP | NOP | NOP | NOP }      
  { NOP | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }
  { SEQI r2, p1, p2, r1, 0x00002222 | NOP | NOP | NOP | NOP }     ; (DMA_STATUS == 0) ? 
  { (p2) B DMEM2DDR                 | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }  
  { NOP | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }  
  { NOP | NOP | NOP | NOP | NOP }
  
;===== Move 1KB data from DDR to LDM =====  
  
  ;=== PACDMA Setting, DDR -> DMEM ===
  DMA_SAR_ADDR0 = 0x2415C070 ;
  DMA_DAR_ADDR0 = 0x2415C074 ;
  DMA_SGR_ADDR0 = 0x2415C078 ;
  DMA_DSR_ADDR0 = 0x2415C07C ;
  DMA_CTL_ADDR0 = 0x2415C080 ;
  DMA_ENA_ADDR0 = 0x2415C084 ;
  DMA_CLR_ADDR0 = 0x2415C088 ;

  DMA_SAR_DATA0 = 0x25008000 ; set M2 memory as start address 
  DMA_DAR_DATA0 = 0x24101000 ; set DMEM as destination address 
  DMA_SGR_DATA0 = 0x00000000 ; set SGC[31:20]:8, SGO[19:0]:14
  DMA_DSR_DATA0 = 0x00000000 ; set DSC[31:20]:8, DSO[19:0]:14
  DMA_CTL_DATA0 = 0x00400004 ; DMA_CTL_DATA,BSZ[31:12], DSEN[9], SGEN[8], Int2Ext[3], Burst[2], TRZ[1:0]
  DMA_ENA_DATA0 = 0x00000000 ; active dma
  DMA_CLR_DATA0 = 0x00000001 ;

;======================== Move 1KB data from M2 to M1 =========================

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

;check c0 give c1 pointer  
  { MOVI r0, C0_START_C1_DMA1 | NOP | NOP | NOP | NOP } 
chk_start_pointer1:    
  { LW r1, r0, 0x0  | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }
  { SEQI r2, p1, p2, r1, 0x55667788 | NOP | NOP | NOP | NOP }     ; (DMA_STATUS == 0) ? 
  { (p2) B chk_start_pointer1                 | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }  
  { NOP | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }  
  { NOP | NOP | NOP | NOP | NOP }

  { MOVI r0, DMA_ENA_ADDR0 | NOP | NOP | NOP | NOP } 
  { MOVI r1, DMA_ENA_DATA0 | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x0         | NOP | NOP | NOP | NOP }

  ;=== waiting dma finish transfer ===
  { MOVI r0, DMA_STATUS_ADDR | NOP | NOP | NOP | NOP }
;set M2 memory  
  { MOVI r6, M2_BASE | NOP | NOP | NOP | NOP }    
  { MOVI r7, 0x87654321 | NOP | NOP | NOP | NOP }      
  { SW r7, r6, 0x0         | NOP | NOP | NOP | NOP }  
;set DDR  
  { MOVI r8, DDR_BASE | NOP | NOP | NOP | NOP }    
  { MOVI r9, 0x12345678 | NOP | NOP | NOP | NOP }      
  { SW r9, r8, 0x0         | NOP | NOP | NOP | NOP }  
;set M2 REG DMASHAPE1
  { MOVI r10, M2_SHP_ADDR1 | NOP | NOP | NOP | NOP }    
  { MOVI r11, 0x55667788 | NOP | NOP | NOP | NOP }      
  { SW r11, r10, 0x0  | NOP | NOP | NOP | NOP }  

DDR2DMEM:    
  { LW r1, r0, 0x0 | NOP | NOP | NOP | NOP }
;read M2 memory  
  { LW r3, r6, 0x0 | NOP | NOP | NOP | NOP }  
;read DDR 
  { LW r4, r8, 0x0 | NOP | NOP | NOP | NOP }  
;read M2 REG DMASHAPE1 
  { LW r5, r10, 0x0 | NOP | NOP | NOP | NOP }    
  { NOP | NOP | NOP | NOP | NOP }
;write M2 memory    
  { SW r3, r6, 0x8 | NOP | NOP | NOP | NOP }    
;write DDR     
  { SW r4, r8, 0x8 | NOP | NOP | NOP | NOP }  
;write M2 REG DMAREX1
  { MOVI r10, M2_REX_ADDR1 | NOP | NOP | NOP | NOP }    
  { SW r5, r10, 0x0 | NOP | NOP | NOP | NOP }      
  { NOP | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }
  { SEQI r2, p1, p2, r1, 0x00002222 | NOP | NOP | NOP | NOP }     ; (DMA_STATUS == 0) ? 
  { (p2) B DDR2DMEM                 | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }  
  { NOP | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }  
  { NOP | NOP | NOP | NOP | NOP }

;************************************************************** Program Terminate
   
  {  TRAP  |  NOP  |  NOP  |  NOP  |  NOP  }  
  
  
