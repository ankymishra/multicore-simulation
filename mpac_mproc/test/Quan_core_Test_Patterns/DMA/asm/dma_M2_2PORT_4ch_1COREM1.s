;===============================================================================
; Author: Jack
; Description: Move 1KB data from M2 to DDR by DMA
; Date: 2009/11/04
;===============================================================================

  INI_NUM  = 256
  INI_CH   = 8  
  M2_BASE  = 0x25000000
  DDR_BASE = 0x30000000
  C0_FLAG  = 0x2501F000  
  C1_FLAG  = 0x25010000  

  DMA_SAR_ADDR0 = 0x25820070 ;
  DMA_DAR_ADDR0 = 0x25820074 ;
  DMA_SGR_ADDR0 = 0x25820078 ;
  DMA_DSR_ADDR0 = 0x2582007C ;
  DMA_CTL_ADDR0 = 0x25820080 ;
  DMA_ENA_ADDR0 = 0x25820084 ;
  DMA_CLR_ADDR0 = 0x25820088 ;
                            
  DMA_SAR_DATA0 = 0x25000000 ; set M2 as start address 
  DMA_DAR_DATA0 = 0x24000000 ; set CORE0M1 as destination address 
  DMA_SGR_DATA0 = 0x00000000 ; not used
  DMA_DSR_DATA0 = 0x00000000 ; not used
  DMA_CTL_DATA0 = 0x0040000C ; DMA_CTL_DATA, BSZ[31:12], DSEN[9], SGEN[8], Int2Ext[3], TRZ[1:0]
  DMA_ENA_DATA0 = 0x00000000 ; active dma
  DMA_CLR_DATA0 = 0x00000000 ; not used

  DMA_SAR_ADDR1 = 0x258200B0 ;
  DMA_DAR_ADDR1 = 0x258200B4 ;
  DMA_SGR_ADDR1 = 0x258200B8 ;
  DMA_DSR_ADDR1 = 0x258200BC ;
  DMA_CTL_ADDR1 = 0x258200C0 ;
  DMA_ENA_ADDR1 = 0x258200C4 ;
  DMA_CLR_ADDR1 = 0x258200C8 ;

  DMA_SAR_DATA1 = 0x24000000 ; set CORE0M1 as start address 
  DMA_DAR_DATA1 = 0x25001000 ; set M2 as destination address 
  DMA_SGR_DATA1 = 0x00000000 ; set SGC[31:20]:8, SGO[19:0]:14
  DMA_DSR_DATA1 = 0x00000000 ; set DSC[31:20]:8, DSO[19:0]:14
  DMA_CTL_DATA1 = 0x00400004 ; DMA_CTL_DATA,BSZ[31:12], DSEN[9], SGEN[8], Int2Ext[3], TRZ[1:0]
  DMA_ENA_DATA1 = 0x00000000 ; active dma
  DMA_CLR_DATA1 = 0x00000000 ; not used 

  DMA_SAR_ADDR2 = 0x258200F0 ;
  DMA_DAR_ADDR2 = 0x258200F4 ;
  DMA_SGR_ADDR2 = 0x258200F8 ;
  DMA_DSR_ADDR2 = 0x258200FC ;
  DMA_CTL_ADDR2 = 0x25820100 ;
  DMA_ENA_ADDR2 = 0x25820104 ;
  DMA_CLR_ADDR2 = 0x25820108 ;
                            
  DMA_SAR_DATA2 = 0x25000800 ; set M2 as start address 
  DMA_DAR_DATA2 = 0x24000800 ; set CORE0M1 as destination address 
  DMA_SGR_DATA2 = 0x00000000 ; not used
  DMA_DSR_DATA2 = 0x00000000 ; not used
  DMA_CTL_DATA2 = 0x0040000C ; DMA_CTL_DATA, BSZ[31:12], DSEN[9], SGEN[8], Int2Ext[3], TRZ[1:0]
  DMA_ENA_DATA2 = 0x00000000 ; active dma
  DMA_CLR_DATA2 = 0x00000000 ; not used

  DMA_SAR_ADDR3 = 0x25820130 ;
  DMA_DAR_ADDR3 = 0x25820134 ;
  DMA_SGR_ADDR3 = 0x25820138 ;
  DMA_DSR_ADDR3 = 0x2582013C ;
  DMA_CTL_ADDR3 = 0x25820140 ;
  DMA_ENA_ADDR3 = 0x25820144 ;
  DMA_CLR_ADDR3 = 0x25820148 ;

  DMA_SAR_DATA3 = 0x24000800 ; set CORE0M1 as start address 
  DMA_DAR_DATA3 = 0x25001800 ; set M2 as destination address 
  DMA_SGR_DATA3 = 0x00000000 ; set SGC[31:20]:8, SGO[19:0]:14
  DMA_DSR_DATA3 = 0x00000000 ; set DSC[31:20]:8, DSO[19:0]:14
  DMA_CTL_DATA3 = 0x00400004 ; DMA_CTL_DATA,BSZ[31:12], DSEN[9], SGEN[8], Int2Ext[3], TRZ[1:0]
  DMA_ENA_DATA3 = 0x00000000 ; active dma
  DMA_CLR_DATA3 = 0x00000000 ; not used 

  DMA_SAR_ADDR4 = 0x25820170 ;
  DMA_DAR_ADDR4 = 0x25820174 ;
  DMA_SGR_ADDR4 = 0x25820178 ;
  DMA_DSR_ADDR4 = 0x2582017C ;
  DMA_CTL_ADDR4 = 0x25820180 ;
  DMA_ENA_ADDR4 = 0x25820184 ;
  DMA_CLR_ADDR4 = 0x25820188 ;
                            
  DMA_SAR_DATA4 = 0x25000400 ; set M2 as start address 
  DMA_DAR_DATA4 = 0x24000400 ; set CORE0M1 as destination address 
  DMA_SGR_DATA4 = 0x00000000 ; not used
  DMA_DSR_DATA4 = 0x00000000 ; not used
  DMA_CTL_DATA4 = 0x0040000C ; DMA_CTL_DATA, BSZ[31:12], DSEN[9], SGEN[8], Int2Ext[3], TRZ[1:0]
  DMA_ENA_DATA4 = 0x00000000 ; active dma
  DMA_CLR_DATA4 = 0x00000000 ; not used

  DMA_SAR_ADDR5 = 0x258201B0 ;
  DMA_DAR_ADDR5 = 0x258201B4 ;
  DMA_SGR_ADDR5 = 0x258201B8 ;
  DMA_DSR_ADDR5 = 0x258201BC ;
  DMA_CTL_ADDR5 = 0x258201C0 ;
  DMA_ENA_ADDR5 = 0x258201C4 ;
  DMA_CLR_ADDR5 = 0x258201C8 ;

  DMA_SAR_DATA5 = 0x24000400 ; set CORE0M1 as start address 
  DMA_DAR_DATA5 = 0x25001400 ; set M2 as destination address 
  DMA_SGR_DATA5 = 0x00000000 ; set SGC[31:20]:8, SGO[19:0]:14
  DMA_DSR_DATA5 = 0x00000000 ; set DSC[31:20]:8, DSO[19:0]:14
  DMA_CTL_DATA5 = 0x00400004 ; DMA_CTL_DATA,BSZ[31:12], DSEN[9], SGEN[8], Int2Ext[3], TRZ[1:0]
  DMA_ENA_DATA5 = 0x00000000 ; active dma
  DMA_CLR_DATA5 = 0x00000000 ; not used 

  DMA_SAR_ADDR6 = 0x258201F0 ;
  DMA_DAR_ADDR6 = 0x258201F4 ;
  DMA_SGR_ADDR6 = 0x258201F8 ;
  DMA_DSR_ADDR6 = 0x258201FC ;
  DMA_CTL_ADDR6 = 0x25820200 ;
  DMA_ENA_ADDR6 = 0x25820204 ;
  DMA_CLR_ADDR6 = 0x25820208 ;
                            
  DMA_SAR_DATA6 = 0x25000C00 ; set M2 as start address 
  DMA_DAR_DATA6 = 0x24000C00 ; set CORE0M1 as destination address 
  DMA_SGR_DATA6 = 0x00000000 ; not used
  DMA_DSR_DATA6 = 0x00000000 ; not used
  DMA_CTL_DATA6 = 0x0040000C ; DMA_CTL_DATA, BSZ[31:12], DSEN[9], SGEN[8], Int2Ext[3], TRZ[1:0]
  DMA_ENA_DATA6 = 0x00000000 ; active dma
  DMA_CLR_DATA6 = 0x00000000 ; not used

  DMA_SAR_ADDR7 = 0x25820230 ;
  DMA_DAR_ADDR7 = 0x25820234 ;
  DMA_SGR_ADDR7 = 0x25820238 ;
  DMA_DSR_ADDR7 = 0x2582023C ;
  DMA_CTL_ADDR7 = 0x25820240 ;
  DMA_ENA_ADDR7 = 0x25820244 ;
  DMA_CLR_ADDR7 = 0x25820248 ;

  DMA_SAR_DATA7 = 0x24000C00 ; set CORE0M1 as start address 
  DMA_DAR_DATA7 = 0x25001C00 ; set M2 as destination address 
  DMA_SGR_DATA7 = 0x00000000 ; set SGC[31:20]:8, SGO[19:0]:14
  DMA_DSR_DATA7 = 0x00000000 ; set DSC[31:20]:8, DSO[19:0]:14
  DMA_CTL_DATA7 = 0x00400004 ; DMA_CTL_DATA,BSZ[31:12], DSEN[9], SGEN[8], Int2Ext[3], TRZ[1:0]
  DMA_ENA_DATA7 = 0x00000000 ; active dma
  DMA_CLR_DATA7 = 0x00000000 ; not used 

  DMA_STATUS_ADDR = 0x25820054;

;===== Initialize 2KB M2 =====

  {  MOVI R0, 0x03020100 | NOP | NOP | NOP | NOP }
  {  MOVI R1,  M2_BASE  | NOP | NOP | NOP | NOP }  
  {  MOVI R10, INI_NUM   | NOP | NOP | NOP | NOP }
  {  MOVI R11, INI_CH    | NOP | NOP | NOP | NOP }  

INIT_CH:  
INIT_DATA:
  {  SW R0, R1, 4+       | NOP | NOP | NOP | NOP }
  {  ADDI R0, R0, 0x04040404 | NOP | NOP | NOP | NOP }
  {  LBCB R10, INIT_DATA | NOP | NOP | NOP | NOP }
  {  NOP | NOP | NOP | NOP | NOP }
  {  NOP | NOP | NOP | NOP | NOP }
  {  NOP | NOP | NOP | NOP | NOP }
  {  NOP | NOP | NOP | NOP | NOP }
  {  NOP | NOP | NOP | NOP | NOP }  

  {  MOVI R0, 0x03020100 | NOP | NOP | NOP | NOP }
  {  MOVI R10, INI_NUM   | NOP | NOP | NOP | NOP }    
  {  LBCB R11, INIT_CH | NOP | NOP | NOP | NOP }
  {  NOP | NOP | NOP | NOP | NOP }
  {  NOP | NOP | NOP | NOP | NOP }
  {  NOP | NOP | NOP | NOP | NOP }
  {  NOP | NOP | NOP | NOP | NOP }
  {  NOP | NOP | NOP | NOP | NOP }  

    
;===== Move 1KB data from M2 to DDR =====  

  ;=== PACDMA Setting CH0,CH1,CH2, M2 -> DDR ===

  { MOVI r0, DMA_SAR_ADDR0 | MOVI a0, DMA_SAR_ADDR1 | NOP | MOVI a0, DMA_SAR_ADDR2 | NOP } 
  { MOVI r1, DMA_SAR_DATA0 | MOVI a1, DMA_SAR_DATA1 | NOP | MOVI a1, DMA_SAR_DATA2 | NOP }
  { SW r1, r0, 0x0         | SW a1, a0, 0x0	    | NOP | SW a1, a0, 0x0	   | NOP }
  
  { MOVI r0, DMA_DAR_ADDR0 | MOVI a0, DMA_DAR_ADDR1 | NOP | MOVI a0, DMA_DAR_ADDR2 | NOP } 
  { MOVI r1, DMA_DAR_DATA0 | MOVI a1, DMA_DAR_DATA1 | NOP | MOVI a1, DMA_DAR_DATA2 | NOP }
  { SW r1, r0, 0x0         | SW a1, a0, 0x0	    | NOP | SW a1, a0, 0x0	   | NOP }
  
  { MOVI r0, DMA_SGR_ADDR0 | MOVI a0, DMA_SGR_ADDR1 | NOP | MOVI a0, DMA_SGR_ADDR2 | NOP } 
  { MOVI r1, DMA_SGR_DATA0 | MOVI a1, DMA_SGR_DATA1 | NOP | MOVI a1, DMA_SGR_DATA2 | NOP }
  { SW r1, r0, 0x0         | SW a1, a0, 0x0	    | NOP | SW a1, a0, 0x0	   | NOP }
  
  { MOVI r0, DMA_DSR_ADDR0 | MOVI a0, DMA_DSR_ADDR1 | NOP | MOVI a0, DMA_DSR_ADDR2 | NOP } 
  { MOVI r1, DMA_DSR_DATA0 | MOVI a1, DMA_DSR_DATA1 | NOP | MOVI a1, DMA_DSR_DATA2 | NOP }
  { SW r1, r0, 0x0         | SW a1, a0, 0x0	    | NOP | SW a1, a0, 0x0	   | NOP }
  
  { MOVI r0, DMA_CTL_ADDR0 | MOVI a0, DMA_CTL_ADDR1 | NOP | MOVI a0, DMA_CTL_ADDR2 | NOP } 
  { MOVI r1, DMA_CTL_DATA0 | MOVI a1, DMA_CTL_DATA1 | NOP | MOVI a1, DMA_CTL_DATA2 | NOP }
  { SW r1, r0, 0x0         | SW a1, a0, 0x0	    | NOP | SW a1, a0, 0x0	   | NOP }

  ;=== PACDMA Setting CH3,CH4,CH5, M2 -> DDR ===

  { MOVI r0, DMA_SAR_ADDR3 | MOVI a0, DMA_SAR_ADDR4 | NOP | MOVI a0, DMA_SAR_ADDR5 | NOP } 
  { MOVI r1, DMA_SAR_DATA3 | MOVI a1, DMA_SAR_DATA4 | NOP | MOVI a1, DMA_SAR_DATA5 | NOP }
  { SW r1, r0, 0x0         | SW a1, a0, 0x0	    | NOP | SW a1, a0, 0x0	   | NOP }
  
  { MOVI r0, DMA_DAR_ADDR3 | MOVI a0, DMA_DAR_ADDR4 | NOP | MOVI a0, DMA_DAR_ADDR5 | NOP } 
  { MOVI r1, DMA_DAR_DATA3 | MOVI a1, DMA_DAR_DATA4 | NOP | MOVI a1, DMA_DAR_DATA5 | NOP }
  { SW r1, r0, 0x0         | SW a1, a0, 0x0	    | NOP | SW a1, a0, 0x0	   | NOP }
  
  { MOVI r0, DMA_SGR_ADDR3 | MOVI a0, DMA_SGR_ADDR4 | NOP | MOVI a0, DMA_SGR_ADDR5 | NOP } 
  { MOVI r1, DMA_SGR_DATA3 | MOVI a1, DMA_SGR_DATA4 | NOP | MOVI a1, DMA_SGR_DATA5 | NOP }
  { SW r1, r0, 0x0         | SW a1, a0, 0x0	    | NOP | SW a1, a0, 0x0	   | NOP }
  
  { MOVI r0, DMA_DSR_ADDR3 | MOVI a0, DMA_DSR_ADDR4 | NOP | MOVI a0, DMA_DSR_ADDR5 | NOP } 
  { MOVI r1, DMA_DSR_DATA3 | MOVI a1, DMA_DSR_DATA4 | NOP | MOVI a1, DMA_DSR_DATA5 | NOP }
  { SW r1, r0, 0x0         | SW a1, a0, 0x0	    | NOP | SW a1, a0, 0x0	   | NOP }
  
  { MOVI r0, DMA_CTL_ADDR3 | MOVI a0, DMA_CTL_ADDR4 | NOP | MOVI a0, DMA_CTL_ADDR5 | NOP } 
  { MOVI r1, DMA_CTL_DATA3 | MOVI a1, DMA_CTL_DATA4 | NOP | MOVI a1, DMA_CTL_DATA5 | NOP }
  { SW r1, r0, 0x0         | SW a1, a0, 0x0	    | NOP | SW a1, a0, 0x0	   | NOP }

  ;=== PACDMA Setting CH6,CH7 M2 -> DDR ===

  { MOVI r0, DMA_SAR_ADDR6 | MOVI a0, DMA_SAR_ADDR7 | NOP | NOP | NOP } 
  { MOVI r1, DMA_SAR_DATA6 | MOVI a1, DMA_SAR_DATA7 | NOP | NOP | NOP }
  { SW r1, r0, 0x0         | SW a1, a0, 0x0	    | NOP | NOP | NOP }
  
  { MOVI r0, DMA_DAR_ADDR6 | MOVI a0, DMA_DAR_ADDR7 | NOP | NOP | NOP } 
  { MOVI r1, DMA_DAR_DATA6 | MOVI a1, DMA_DAR_DATA7 | NOP | NOP | NOP }
  { SW r1, r0, 0x0         | SW a1, a0, 0x0	    | NOP | NOP | NOP }
  
  { MOVI r0, DMA_SGR_ADDR6 | MOVI a0, DMA_SGR_ADDR7 | NOP | NOP | NOP } 
  { MOVI r1, DMA_SGR_DATA6 | MOVI a1, DMA_SGR_DATA7 | NOP | NOP | NOP }
  { SW r1, r0, 0x0         | SW a1, a0, 0x0	    | NOP | NOP | NOP }
  
  { MOVI r0, DMA_DSR_ADDR6 | MOVI a0, DMA_DSR_ADDR7 | NOP | NOP | NOP } 
  { MOVI r1, DMA_DSR_DATA6 | MOVI a1, DMA_DSR_DATA7 | NOP | NOP | NOP }
  { SW r1, r0, 0x0         | SW a1, a0, 0x0	    | NOP | NOP | NOP }
  
  { MOVI r0, DMA_CTL_ADDR6 | MOVI a0, DMA_CTL_ADDR7 | NOP | NOP | NOP } 
  { MOVI r1, DMA_CTL_DATA6 | MOVI a1, DMA_CTL_DATA7 | NOP | NOP | NOP }
  { SW r1, r0, 0x0         | SW a1, a0, 0x0	    | NOP | NOP | NOP }

  ;=== PACDMA ENABLE ALL CH, M2 -> DDR ===

  { MOVI r0, DMA_ENA_ADDR0 | MOVI a0, DMA_ENA_ADDR4 | NOP | NOP | NOP } 
  { MOVI r1, DMA_ENA_DATA0 | MOVI a1, DMA_ENA_DATA4 | NOP | NOP | NOP }
  { SW r1, r0, 0x0         | SW a1, a0, 0x0         | NOP | NOP | NOP }
                                                   
  { MOVI r0, DMA_ENA_ADDR1 | MOVI a0, DMA_ENA_ADDR5 | NOP | NOP | NOP } 
  { MOVI r1, DMA_ENA_DATA1 | MOVI a1, DMA_ENA_DATA5 | NOP | NOP | NOP }
  { SW r1, r0, 0x0         | SW a1, a0, 0x0         | NOP | NOP | NOP }
                                                   
  { MOVI r0, DMA_ENA_ADDR2 | MOVI a0, DMA_ENA_ADDR6 | NOP | NOP | NOP } 
  { MOVI r1, DMA_ENA_DATA2 | MOVI a1, DMA_ENA_DATA6 | NOP | NOP | NOP }
  { SW r1, r0, 0x0         | SW a1, a0, 0x0         | NOP | NOP | NOP }
                                                   
  { MOVI r0, DMA_ENA_ADDR3 | MOVI a0, DMA_ENA_ADDR7 | NOP | NOP | NOP } 
  { MOVI r1, DMA_ENA_DATA3 | MOVI a1, DMA_ENA_DATA7 | NOP | NOP | NOP }
  { SW r1, r0, 0x0         | SW a1, a0, 0x0         | NOP | NOP | NOP }

  ;=== waiting dma finish transfer ===
  { MOVI r0, DMA_STATUS_ADDR | NOP | NOP | NOP | NOP }
DMEM2DDR:    
  { LW r1, r0, 0x0  | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }
  { SEQI r2, p1, p2, r1, 0x22222222 | NOP | NOP | NOP | NOP }     ; (DMA_STATUS == 0) ? 
  { (p2) B DMEM2DDR                 | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }  
  { NOP | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }  
  { NOP | NOP | NOP | NOP | NOP }

;************************************************************** Program Terminate
   
  {  TRAP  |  NOP  |  NOP  |  NOP  |  NOP  }  
  
  
