;**********************************************************************
; To verify
; 1. Load or store contentions at the same bank.
; 2. Contention counter
; 3. Miss counter (without initial program in instruction cache) 
; 4. Stop caused by instruction miss and data contention concurrently
; 5. Interleaving
; 6. Load and store instructions to the same address
;**********************************************************************

; PACDMA Setting
; ================================================   
  ; DMEM -> DDR 
  ; ##############################################
  DMA_SAR_ADDR0 = 0x2405C070 ;
  DMA_DAR_ADDR0 = 0x2405C074 ;
  DMA_SGR_ADDR0 = 0x2405C078 ;
  DMA_DSR_ADDR0 = 0x2405C07C ;
  DMA_CTL_ADDR0 = 0x2405C080 ;
  DMA_ENA_ADDR0 = 0x2405C084 ;
  DMA_CLR_ADDR0 = 0x2405C088 ;
                             
  DMA_SAR_DATA0 = 0x24002000 ; set DMEM as start address 
  DMA_DAR_DATA0 = 0x30002000 ; set DDR as destination address 
  DMA_SGR_DATA0 = 0x00000000 ; not used
  DMA_DSR_DATA0 = 0x00000000 ; not used
  DMA_CTL_DATA0 = 0x0004000E ; BSZ[31:20], DSEN[9], SGEN[8], Int2Ext[3], Burst[2], TRZ[1:0], for 7056 DSP DMA
  DMA_ENA_DATA0 = 0x00000000 ; dma active low
  DMA_CLR_DATA0 = 0x00000000 ; not used                             
  
  ; DMEM -> DDR
  ; ##############################################
  DMA_SAR_ADDR1 = 0x2405C0B0 ;
  DMA_DAR_ADDR1 = 0x2405C0B4 ;
  DMA_SGR_ADDR1 = 0x2405C0B8 ;
  DMA_DSR_ADDR1 = 0x2405C0BC ;
  DMA_CTL_ADDR1 = 0x2405C0C0 ;
  DMA_ENA_ADDR1 = 0x2405C0C4 ;
  DMA_CLR_ADDR1 = 0x2405C0C8 ;
                             
  DMA_SAR_DATA1 = 0x24004000 ; set DMEM as start address 
  DMA_DAR_DATA1 = 0x30004000 ; set DDR as destination address 
  DMA_SGR_DATA1 = 0x00000000 ; not used
  DMA_DSR_DATA1 = 0x00000000 ; not used
  DMA_CTL_DATA1 = 0x0004000E ; BSZ[31:20], DSEN[9], SGEN[8], Int2Ext[3], Burst[2], TRZ[1:0], for 7056 DSP DMA
  DMA_ENA_DATA1 = 0x00000000 ; dma active low
  DMA_CLR_DATA1 = 0x00000000 ; not used
  
  ; DMEM -> DDR
  ; ##############################################
  DMA_SAR_ADDR2 = 0x2405C0F0 ;
  DMA_DAR_ADDR2 = 0x2405C0F4 ;
  DMA_SGR_ADDR2 = 0x2405C0F8 ;
  DMA_DSR_ADDR2 = 0x2405C0FC ;
  DMA_CTL_ADDR2 = 0x2405C100 ;
  DMA_ENA_ADDR2 = 0x2405C104 ;
  DMA_CLR_ADDR2 = 0x2405C108 ;
                             
  DMA_SAR_DATA2 = 0x24008000 ; set DMEM as start address 
  DMA_DAR_DATA2 = 0x30008000 ; set DDR as destination address 
  DMA_SGR_DATA2 = 0x00000000 ; not used
  DMA_DSR_DATA2 = 0x00000000 ; not used
  DMA_CTL_DATA2 = 0x0004000E ; BSZ[31:20], DSEN[9], SGEN[8], Int2Ext[3], Burst[2], TRZ[1:0], for 7056 DSP DMA
  DMA_ENA_DATA2 = 0x00000000 ; dma active low
  DMA_CLR_DATA2 = 0x00000000 ; not used
  
  ; DMEM -> DDR
  ; ##############################################
  DMA_SAR_ADDR3 = 0x2405C130 ;
  DMA_DAR_ADDR3 = 0x2405C134 ;
  DMA_SGR_ADDR3 = 0x2405C138 ;
  DMA_DSR_ADDR3 = 0x2405C13C ;
  DMA_CTL_ADDR3 = 0x2405C140 ;
  DMA_ENA_ADDR3 = 0x2405C144 ;
  DMA_CLR_ADDR3 = 0x2405C148 ;
                             
  DMA_SAR_DATA3 = 0x2400C000 ; set DMEM as start address 
  DMA_DAR_DATA3 = 0x3000C000 ; set DDR as destination address 
  DMA_SGR_DATA3 = 0x00000000 ; not used
  DMA_DSR_DATA3 = 0x00000000 ; not used
  DMA_CTL_DATA3 = 0x0005800E ; BSZ[31:20], DSEN[9], SGEN[8], Int2Ext[3], Burst[2], TRZ[1:0], for 7056 DSP DMA
  DMA_ENA_DATA3 = 0x00000000 ; dma active low
  DMA_CLR_DATA3 = 0x00000000 ; not used
  
  DMA_STATUS_ADDR = 0x24058054;
  
  BASE_ADDR = 0x2400;
  IMEM_BASE = 0x2405;
  DMEM_BASE = 0x2405;

;************************************************************** Data memory interleaving
{  MOVI.L R2, 0x803C    |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R2, DMEM_BASE |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.L R3, 0x0001    |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R3, 0x0000    |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R3, R2, 0         |  NOP  |  NOP  |  NOP  |  NOP  }

{  MOVI.L R2, 0x8040    |  NOP  |  NOP  |  NOP  |  NOP  }  ; Data memory priority
{  MOVI.H R2, DMEM_BASE |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.L R3, 0x0000    |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R3, 0x0000    |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R3, R2, 0         |  NOP  |  NOP  |  NOP  |  NOP  }

;************************************************************** Contentions at Bank1 (Non-Interleaved)
{  MOVI.L R2, 0x803C    |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R2, DMEM_BASE |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.L R3, 0x0000    |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R3, 0x0000    |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R3, R2, 0         |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-interleaved
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
; Wait until interleave_reg is set

{  MOVI.L R0, 0x2000    |  MOVI.L A0, 0x2010    |  MOVI.L D0, 0x0002  |  MOVI.L A0, 0x2028    |  MOVI.L D0, 0x0004  }
{  MOVI.H R0, BASE_ADDR |  MOVI.H A0, BASE_ADDR |  MOVI.H D0, 0x0000  |  MOVI.H A0, BASE_ADDR |  MOVI.H D0, 0x0000  }
{  MOVI.L R1, 0x0001  |  NOP  |  MOVI.L D1, 0x0003  |  NOP  |  MOVI.L D1, 0x0005  }
{  MOVI.H R1, 0x0000  |  NOP  |  MOVI.H D1, 0x0000  |  NOP  |  MOVI.H D1, 0x0000  }
{  SW R1, R0, 0  |  DSW D0, D1, A0, 0  |  NOP  |  DSW D0, D1, A0, 0  |  NOP  }
;Mem[0x2400_2000] = 0x0000_0001
;Mem[0x2400_2010] = 0x0000_0002
;Mem[0x2400_2014] = 0x0000_0003
;Mem[0x2400_2028] = 0x0000_0004
;Mem[0x2400_202C] = 0x0000_0005
;Stalled for two cycles
{  ADD R1, R1, R1  |  NOP  |  ADD D0, D0, D1  |  NOP  |  ADD D0, D0, D1  }
;Reg[R1] = 0x0000_0002

{  SW R1, R0, 4  |  DSW D0, D1, A0, 8  |  NOP  |  DSW D0, D1, A0, 8  |  NOP  }
;Mem[0x2400_2004] = 0x0000_0002
;Mem[0x2400_2018] = 0x0000_0005
;Mem[0x2400_201C] = 0x0000_0003
;Mem[0x2400_2030] = 0x0000_0009
;Mem[0x2400_2034] = 0x0000_0005
;Stalled for two cycles
{  ADD R1, R1, R1  |  NOP  |  ADD D1, D0, D1  |  NOP  |  ADD D1, D0, D1  }
;Reg[R1] = 0x0000_0004

{  SW R1, R0, 8  |  DSW D0, D1, A0, 16  |  NOP  |  DSW D0, D1, A0, 16  |  NOP  }
;Mem[0x2400_2008] = 0x0000_0004
;Mem[0x2400_2020] = 0x0000_0005
;Mem[0x2400_2024] = 0x0000_0008
;Mem[0x2400_2038] = 0x0000_0009
;Mem[0x2400_203C] = 0x0000_000E
;Stalled for two cycles

;************************************************************** Read contentions at Bank1, write contention at Bank2 

{  MOVI.L R5, 0x4000    |  MOVI.L A1, 0x4010    |  NOP  |  MOVI.L A1, 0x4028    |  NOP  }
{  MOVI.H R5, BASE_ADDR |  MOVI.H A1, BASE_ADDR |  NOP  |  MOVI.H A1, BASE_ADDR |  NOP  }
; Set addresses to group2 (bank2 and bank3)
{  LW R6, R0, 0  |  DLW D2, A0, 0  |  NOP  |  DLW D2, A0, 0  |  NOP  }
;Stalled for two cycles
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R6, R5, 0  |  DSW D2, D3, A1, 0  |  NOP  |  DSW D2, D3, A1, 0  |  NOP  }
;Mem[0x2400_4000] = 0x0000_0001
;Mem[0x2400_4010] = 0x0000_0002
;Mem[0x2400_4014] = 0x0000_0003
;Mem[0x2400_4028] = 0x0000_0004
;Mem[0x2400_402C] = 0x0000_0005
;Stalled for two cycles
{  LW R6, R0, 4  |  DLW D2, A0, 8  |  NOP  |  DLW D2, A0, 8  |  NOP  }
;Stalled for two cycles
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R6, R5, 4  |  DSW D2, D3, A1, 8  |  NOP  |  DSW D2, D3, A1, 8  |  NOP  }
;Mem[0x2400_4004] = 0x0000_0002
;Mem[0x2400_4018] = 0x0000_0005
;Mem[0x2400_401C] = 0x0000_0003
;Mem[0x2400_4030] = 0x0000_0009
;Mem[0x2400_4034] = 0x0000_0005
;Stalled for two cycles
{  LW R6, R0, 8  |  DLW D2, A0, 16  |  NOP  |  DLW D2, A0, 16  |  NOP  }
;Stalled for two cycles
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R6, R5, 8  |  DSW D2, D3, A1, 16  |  NOP  |  DSW D2, D3, A1, 16  |  NOP  }
;Mem[0x2400_4008] = 0x0000_0004
;Mem[0x2400_4020] = 0x0000_0005
;Mem[0x2400_4024] = 0x0000_0008
;Mem[0x2400_4038] = 0x0000_0009
;Mem[0x2400_403C] = 0x0000_000E
;Stalled for two cycles


;************************************************************** Contention counter
{  MOVI.L R2, 0x8030  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
; Wait until contention_counter is set
{  LW R4, R2, 0  |  NOP  |  NOP  |  NOP  |  NOP  }
; Read Contention Counter in BIU
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  SW R4, R5, 16  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x2400_C050] = 0x0000_0022

;************************************************************** Miss counter
{  MOVI.L R2, 0x4034    |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R2, IMEM_BASE |  NOP  |  NOP  |  NOP  |  NOP  }
{  LW R4, R2, 0         |  NOP  |  NOP  |  NOP  |  NOP  }
; Miss Counter in BIU
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  SW R4, R5, 20  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x2400_C054] = 0x00000003

;************************************************************** Set Non-Interleaved
{  MOVI.L R2, 0x803C    |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R2, DMEM_BASE |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.L R3, 0x0000    |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R3, 0x0000    |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R3, R2, 0  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
;************************************************************** Program Terminate

;************************************************************** DMEM -> DDR {A(0x...) R(0x...)}
  { MOVI r0, DMA_SAR_ADDR0 | NOP | NOP | NOP | NOP } 
  { MOVI r1, DMA_SAR_DATA0 | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x0 | NOP | NOP | NOP | NOP }
  { MOVI r0, DMA_DAR_ADDR0 | NOP | NOP | NOP | NOP } 
  { MOVI r1, DMA_DAR_DATA0 | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x0 | NOP | NOP | NOP | NOP }
  { MOVI r0, DMA_CTL_ADDR0 | NOP | NOP | NOP | NOP } 
  { MOVI r1, DMA_CTL_DATA0 | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x0 | NOP | NOP | NOP | NOP }
  { MOVI r0, DMA_ENA_ADDR0 | NOP | NOP | NOP | NOP } 
  { MOVI r1, DMA_ENA_DATA0 | NOP | NOP | NOP | NOP }
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
  
;**********************************************************************  
    ; waiting dma finish transfer
  { MOVI r0, DMA_STATUS_ADDR | NOP | NOP | NOP | NOP }
DMEM2DDR1:    
  { LW r1, r0, 0x0  | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }
  { SEQI r2, p1, p2, r1, 0x00002222 | NOP | NOP | NOP | NOP } ; (DMA_STATUS == 0) ? 
  { (p2) B DMEM2DDR1 | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }  
  { NOP | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }  
  { NOP | NOP | NOP | NOP | NOP }
  

{  TRAP  |  NOP  |  NOP  |  NOP  |  NOP  }
