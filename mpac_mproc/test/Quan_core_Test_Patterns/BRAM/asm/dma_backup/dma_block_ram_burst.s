;===============================================================================
; Author: Anthony
; Description: M1 to block ram,block ram to M1;
; Date: 2010/10/22
;===============================================================================


  M1_BASE = 0x24000000
  BLOCK_RAM_BASE = 0x18000000  

;//** Block 0 **//
;1KB data transform 
  INI_NUM = 256  
  
;===== Initialize Local Data Memory =====

  {  MOVI R0, 0x00000000 | NOP | NOP | NOP | NOP }
  ;R0 = 0x03020100;
  
  {  MOVI R1,  M1_BASE  | NOP | NOP | NOP | NOP }  

  {  MOVI R10, INI_NUM   | NOP | NOP | NOP | NOP }

INIT_DATA0:  
  {  SW R0, R1, 8+       | NOP | NOP | NOP | NOP }
   ;Reg[R1] =R0,R1 = R1+8;
  
  {  ADDI R0, R0, 0x00000001 | NOP | NOP | NOP | NOP }
     R0 = R0+00000001;
     
  {  LBCB R10, INIT_DATA0 | NOP | NOP | NOP | NOP }
   
  {  NOP | NOP | NOP | NOP | NOP }
  {  NOP | NOP | NOP | NOP | NOP }
  {  NOP | NOP | NOP | NOP | NOP }
  {  NOP | NOP | NOP | NOP | NOP }
  {  NOP | NOP | NOP | NOP | NOP }  
  
  
;===== Move  data from PAC0 M1 to block ram =====  

  ;=== PACDMA Setting, PAC0 M1 -> block ramz ===
  DMA_SAR_ADDR1 = 0x2405C0B0 ; use
  DMA_DAR_ADDR1 = 0x2405C0B4 ; use
  DMA_SGR_ADDR1 = 0x2405C0B8 ; 
  DMA_DSR_ADDR1 = 0x2405C0BC ; 
  DMA_CTL_ADDR1 = 0x2405C0C0 ; use
  DMA_ENA_ADDR1 = 0x2405C0C4 ; use
  DMA_CLR_ADDR1 = 0x2405C0C8 ;
                             
  DMA_SAR_DATA1 = 0x24000000 ; set M1 as start address 
  DMA_DAR_DATA1 = 0x18000000 ; set block ram as destination address 
  DMA_SGR_DATA1 = 0x00000000 ; not used
  DMA_DSR_DATA1 = 0x00000000 ; not used

  DMA_CTL_DATA1 = 0x0020000C ; 
  ; DMA_CTL_DATA,
  ; 0000_0000_0000_0000_0000_0000_0000_0000;       
  ; 0000_0000_0100_0000_0000_0000_0000_1100
  ;            100_0000_0000 =2KB; 
  ; [31:12] BSZ, [11]LLEN, [10]INTEN, [9]DSEN, [8]SGEN, [5]DTEN,[4]STEN,
  ; [3]Int2Ext, [2]Burst, TRZ[1:0]


  DMA_ENA_DATA1 = 0x00000000 ; active dma
  DMA_CLR_DATA1 = 0x00000000 ; not used

  DMA_STATUS_ADDR = 0x24058054;
    
  { MOVI r0, DMA_SAR_ADDR1 | NOP | NOP | NOP | NOP } 
  { MOVI r1, DMA_SAR_DATA1 | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x0         | NOP | NOP | NOP | NOP }
  
  { MOVI r0, DMA_DAR_ADDR1 | NOP | NOP | NOP | NOP } 
  { MOVI r1, DMA_DAR_DATA1 | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x0         | NOP | NOP | NOP | NOP }
  
  { MOVI r0, DMA_CTL_ADDR1 | NOP | NOP | NOP | NOP } 
  { MOVI r1, DMA_CTL_DATA1 | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x0         | NOP | NOP | NOP | NOP }
  
  { MOVI r0, DMA_ENA_ADDR1 | NOP | NOP | NOP | NOP } 
  { MOVI r1, DMA_ENA_DATA1 | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x0         | NOP | NOP | NOP | NOP }
  
  ;=== waiting dma finish transfer ===
  { MOVI r0, DMA_STATUS_ADDR | NOP | NOP | NOP | NOP }
M1_M2_0:    
  { LW r1, r0, 0x0  | NOP | NOP | NOP | NOP }
  ;r1 = r0;
  
  { NOP | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }
  { SEQI r2, p1, p2, r1, 0x00002222 | NOP | NOP | NOP | NOP }     ; (DMA_STATUS == 0) 
  { (p2) B M1_M2_0                 | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }  
  { NOP | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }  
  { NOP | NOP | NOP | NOP | NOP }

;===== Move data from block ram to PAC0 M1 =====  

  ;=== PACDMA Setting, block ram -> PAC0 M1 ===
  DMA_SAR_ADDR1 = 0x2405C0B0 ;
  DMA_DAR_ADDR1 = 0x2405C0B4 ;
  DMA_SGR_ADDR1 = 0x2405C0B8 ;
  DMA_DSR_ADDR1 = 0x2405C0BC ;
  DMA_CTL_ADDR1 = 0x2405C0C0 ;
  DMA_ENA_ADDR1 = 0x2405C0C4 ;
  DMA_CLR_ADDR1 = 0x2405C0C8 ;
                             
  DMA_SAR_DATA1 = 0x18000000 ; set block ram as start address 
  DMA_DAR_DATA1 = 0x24001000 ; set M1 as destination address 
  DMA_SGR_DATA1 = 0x00000000 ; not used
  DMA_DSR_DATA1 = 0x00000000 ; not used
  DMA_CTL_DATA1 = 0x00200004 ; DMA_CTL_DATA, BSZ[31:12], DSEN[9], SGEN[8], Int2Ext[3], Burst[2], TRZ[1:0]
  DMA_ENA_DATA1 = 0x00000000 ; active dma
  DMA_CLR_DATA1 = 0x00000000 ; not used

  DMA_STATUS_ADDR = 0x24058054;
    
  { MOVI r0, DMA_SAR_ADDR1 | NOP | NOP | NOP | NOP } 
  { MOVI r1, DMA_SAR_DATA1 | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x0         | NOP | NOP | NOP | NOP }
  
  { MOVI r0, DMA_DAR_ADDR1 | NOP | NOP | NOP | NOP } 
  { MOVI r1, DMA_DAR_DATA1 | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x0         | NOP | NOP | NOP | NOP }
  
  { MOVI r0, DMA_CTL_ADDR1 | NOP | NOP | NOP | NOP } 
  { MOVI r1, DMA_CTL_DATA1 | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x0         | NOP | NOP | NOP | NOP }
  
  { MOVI r0, DMA_ENA_ADDR1 | NOP | NOP | NOP | NOP } 
  { MOVI r1, DMA_ENA_DATA1 | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x0         | NOP | NOP | NOP | NOP }
  
  ;=== waiting dma finish transfer ===
  { MOVI r0, DMA_STATUS_ADDR | NOP | NOP | NOP | NOP }
M2_M1_0:    
  { LW r1, r0, 0x0  | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }
  { SEQI r2, p1, p2, r1, 0x00002222 | NOP | NOP | NOP | NOP }     ; (DMA_STATUS == 0) 
  { (p2) B M2_M1_0                 | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }  
  { NOP | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }  
  { NOP | NOP | NOP | NOP | NOP }

  INI_NUM = 512
  M1_BASE = 0x24000000
  BLOCK_RAM_BASE = 0x18000000  
  
  
;===== Initialize 2KB Local Data Memory =====

  {  MOVI R0, 0x00000000 | NOP | NOP | NOP | NOP }
  ;R0 = 0x03020100;
  
  {  MOVI R1,  M1_BASE  | NOP | NOP | NOP | NOP }  

  {  MOVI R10, INI_NUM   | NOP | NOP | NOP | NOP }

INIT_DATA:  
  {  SW R0, R1, 8+       | NOP | NOP | NOP | NOP }
   ;Reg[R1] =R0,R1 = R1+8;
  
  {  ADDI R0, R0, 0x00000002 | NOP | NOP | NOP | NOP }
     R0 = R0+00000001;
     
  {  LBCB R10, INIT_DATA | NOP | NOP | NOP | NOP }
  
  ;512*(8*4) =512*4*(8) =2KB data; 
  ;8 bits for hexadecimal /per bit;
   
  {  NOP | NOP | NOP | NOP | NOP }
  {  NOP | NOP | NOP | NOP | NOP }
  {  NOP | NOP | NOP | NOP | NOP }
  {  NOP | NOP | NOP | NOP | NOP }
  {  NOP | NOP | NOP | NOP | NOP }  
  
  
;===== Move  data from PAC0 M1 to block ram =====  

  ;=== PACDMA Setting, PAC0 M1 -> M2 ===
  DMA_SAR_ADDR1 = 0x2405C0B0 ; use
  DMA_DAR_ADDR1 = 0x2405C0B4 ; use
  DMA_SGR_ADDR1 = 0x2405C0B8 ; 
  DMA_DSR_ADDR1 = 0x2405C0BC ; 
  DMA_CTL_ADDR1 = 0x2405C0C0 ; use
  DMA_ENA_ADDR1 = 0x2405C0C4 ; use
  DMA_CLR_ADDR1 = 0x2405C0C8 ;
                             
  DMA_SAR_DATA1 = 0x24000000 ; set M1 as start address 
  DMA_DAR_DATA1 = 0x18000000 ; set block ram as destination address 
  DMA_SGR_DATA1 = 0x00000000 ; not used
  DMA_DSR_DATA1 = 0x00000000 ; not used

  DMA_CTL_DATA1 = 0x0040000C ; 
  ; DMA_CTL_DATA,
  ; 0000_0000_0000_0000_0000_0000_0000_0000;       
  ; 0000_0000_0100_0000_0000_0000_0000_1100
  ;            100_0000_0000 =2KB; 
  ; [31:12] BSZ, [11]LLEN, [10]INTEN, [9]DSEN, [8]SGEN, [5]DTEN,[4]STEN,
  ; [3]Int2Ext, [2]Burst, TRZ[1:0]


  DMA_ENA_DATA1 = 0x00000000 ; active dma
  DMA_CLR_DATA1 = 0x00000000 ; not used

  DMA_STATUS_ADDR = 0x24058054;
    
  { MOVI r0, DMA_SAR_ADDR1 | NOP | NOP | NOP | NOP } 
  { MOVI r1, DMA_SAR_DATA1 | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x0         | NOP | NOP | NOP | NOP }
  
  { MOVI r0, DMA_DAR_ADDR1 | NOP | NOP | NOP | NOP } 
  { MOVI r1, DMA_DAR_DATA1 | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x0         | NOP | NOP | NOP | NOP }
  
  { MOVI r0, DMA_CTL_ADDR1 | NOP | NOP | NOP | NOP } 
  { MOVI r1, DMA_CTL_DATA1 | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x0         | NOP | NOP | NOP | NOP }
  
  { MOVI r0, DMA_ENA_ADDR1 | NOP | NOP | NOP | NOP } 
  { MOVI r1, DMA_ENA_DATA1 | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x0         | NOP | NOP | NOP | NOP }
  
  ;=== waiting dma finish transfer ===
  { MOVI r0, DMA_STATUS_ADDR | NOP | NOP | NOP | NOP }
M1_M2:    
  { LW r1, r0, 0x0  | NOP | NOP | NOP | NOP }
  ;r1 = r0;
  
  { NOP | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }
  { SEQI r2, p1, p2, r1, 0x00002222 | NOP | NOP | NOP | NOP }     ; (DMA_STATUS == 0) ? 
  { (p2) B M1_M2                 | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }  
  { NOP | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }  
  { NOP | NOP | NOP | NOP | NOP }

;===== Move 1KB data from block ram to PAC0 M1 =====  

  ;=== PACDMA Setting, block ram -> PAC0 M1 ===
  DMA_SAR_ADDR1 = 0x2405C0B0 ;
  DMA_DAR_ADDR1 = 0x2405C0B4 ;
  DMA_SGR_ADDR1 = 0x2405C0B8 ;
  DMA_DSR_ADDR1 = 0x2405C0BC ;
  DMA_CTL_ADDR1 = 0x2405C0C0 ;
  DMA_ENA_ADDR1 = 0x2405C0C4 ;
  DMA_CLR_ADDR1 = 0x2405C0C8 ;
                             
  DMA_SAR_DATA1 = 0x18000000 ; set block ram as start address 
  DMA_DAR_DATA1 = 0x24001000 ; set M1 as destination address 
  DMA_SGR_DATA1 = 0x00000000 ; not used
  DMA_DSR_DATA1 = 0x00000000 ; not used
  DMA_CTL_DATA1 = 0x00400004 ; DMA_CTL_DATA, BSZ[31:12], DSEN[9], SGEN[8], Int2Ext[3], Burst[2], TRZ[1:0]
  DMA_ENA_DATA1 = 0x00000000 ; active dma
  DMA_CLR_DATA1 = 0x00000000 ; not used

  DMA_STATUS_ADDR = 0x24058054;
    
  { MOVI r0, DMA_SAR_ADDR1 | NOP | NOP | NOP | NOP } 
  { MOVI r1, DMA_SAR_DATA1 | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x0         | NOP | NOP | NOP | NOP }
  
  { MOVI r0, DMA_DAR_ADDR1 | NOP | NOP | NOP | NOP } 
  { MOVI r1, DMA_DAR_DATA1 | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x0         | NOP | NOP | NOP | NOP }
  
  { MOVI r0, DMA_CTL_ADDR1 | NOP | NOP | NOP | NOP } 
  { MOVI r1, DMA_CTL_DATA1 | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x0         | NOP | NOP | NOP | NOP }
  
  { MOVI r0, DMA_ENA_ADDR1 | NOP | NOP | NOP | NOP } 
  { MOVI r1, DMA_ENA_DATA1 | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x0         | NOP | NOP | NOP | NOP }
  
  ;=== waiting dma finish transfer ===
  { MOVI r0, DMA_STATUS_ADDR | NOP | NOP | NOP | NOP }
M2_M1:    
  { LW r1, r0, 0x0  | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }
  { SEQI r2, p1, p2, r1, 0x00002222 | NOP | NOP | NOP | NOP }     ; (DMA_STATUS == 0) 
  { (p2) B M2_M1                 | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }  
  { NOP | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }  
  { NOP | NOP | NOP | NOP | NOP }


;************************************************************** Program Terminate
   
  {  TRAP  |  NOP  |  NOP  |  NOP  |  NOP  }  
  
  
