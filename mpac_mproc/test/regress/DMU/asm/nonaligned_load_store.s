
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
                             
  DMA_SAR_DATA0 = 0x24000000 ; set DMEM as start address 
  DMA_DAR_DATA0 = 0x30000000 ; set DDR as destination address 
  DMA_SGR_DATA0 = 0x00000000 ; not used
  DMA_DSR_DATA0 = 0x00000000 ; not used
  DMA_CTL_DATA0 = 0x0007C00E ; BSZ[31:12], DSEN[9], SGEN[8], Int2Ext[3], Burst[2], TRZ[1:0], for 7056 DSP DMA
  DMA_ENA_DATA0 = 0x00000000 ; dma active low
  DMA_CLR_DATA0 = 0x00000001 ; not used                             
  
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
  DMA_CTL_DATA1 = 0x0007800E ; DMA_CTL_DATA[31:20]=BSZ
  DMA_ENA_DATA1 = 0x00000000 ; dma active low
  DMA_CLR_DATA1 = 0x00000001 ; not used
  
  ; DMEM -> DDR
  ; ##############################################
  DMA_SAR_ADDR2 = 0x2405C0F0 ;
  DMA_DAR_ADDR2 = 0x2405C0F4 ;
  DMA_SGR_ADDR2 = 0x2405C0F8 ;
  DMA_DSR_ADDR2 = 0x2405C0FC ;
  DMA_CTL_ADDR2 = 0x2405C100 ;
  DMA_ENA_ADDR2 = 0x2405C104 ;
  DMA_CLR_ADDR2 = 0x2405C108 ;
                             
  DMA_SAR_DATA2 = 0x24000054 ; set DMEM as start address 
  DMA_DAR_DATA2 = 0x30000054 ; set DDR as destination address 
  DMA_SGR_DATA2 = 0x00000000 ; not used
  DMA_DSR_DATA2 = 0x00000000 ; not used
  DMA_CTL_DATA2 = 0x0007C00E ; DMA_CTL_DATA[31:20]=BSZ
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
                             
  DMA_SAR_DATA3 = 0x24004050 ; set DMEM as start address 
  DMA_DAR_DATA3 = 0x30004050 ; set DDR as destination address 
  DMA_SGR_DATA3 = 0x00000000 ; not used
  DMA_DSR_DATA3 = 0x00000000 ; not used
  DMA_CTL_DATA3 = 0x0007800E ; DMA_CTL_DATA[31:20]=BSZ
  DMA_ENA_DATA3 = 0x00000000 ; dma active low
  DMA_CLR_DATA3 = 0x00000000 ; not used
  
  DMA_STATUS_ADDR = 0x24058054;

  BASE_ADDR = 0x2400
  DMEM_BASE = 0x2405;

;************************************************************** Set Start Address
{  MOVI.L R0, 0x0000    |  MOVI.L A0, 0x0000    |  NOP  |  MOVI.L A0, 0x4000    |  NOP  }
{  MOVI.H R0, BASE_ADDR |  MOVI.H A0, BASE_ADDR |  NOP  |  MOVI.H A0, BASE_ADDR |  NOP  }

;//////////////////////////////////////////// Interleaved Mode/////////////////////////////////////////
;************************************************************** Non-aligned access
{  MOVI.L R2, 0x803C    |  NOP  |  NOP  |  NOP  |  NOP  }  ; Data memory interleaving
{  MOVI.H R2, DMEM_BASE |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.L R1, 0x0001    |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R1, R2, 0         |  NOP  |  NOP  |  NOP  |  NOP  }
;Set Interleaved Mode
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
{  NOP  |  MOVI D1, 0x11111111  |  NOP  |  MOVI D1, 0x11111111  |  NOP  }
{  NOP  |  MOVI D2, 0x22222222  |  NOP  |  MOVI D2, 0x22222222  |  NOP  }
{  NOP  |  MOVI D3, 0x33333333  |  NOP  |  MOVI D3, 0x33333333  |  NOP  }
{  NOP  |  MOVI D4, 0x44444444  |  NOP  |  MOVI D4, 0x44444444  |  NOP  }
{  NOP  |  MOVI D5, 0x55555555  |  NOP  |  MOVI D5, 0x55555555  |  NOP  }
{  NOP  |  MOVI D6, 0x66666666  |  NOP  |  MOVI D6, 0x66666666  |  NOP  }
{  NOP  |  MOVI D7, 0x77777777  |  NOP  |  MOVI D7, 0x77777777  |  NOP  }

;************************************************************** Initialize Memory
{  MOVI.L R1, 0x0000  |  MOVI.L D0, 0x0000  |  NOP  |  MOVI.L D0, 0x0000  |  NOP  }
{  MOVI.H R1, 0x1200  |  MOVI.H D0, 0x0000  |  NOP  |  MOVI.H D0, 0x0000  |  NOP  }
{  SW R1, R0, 4+  |  SW D0, A0, 4+  |  NOP  |  SW D0, A0, 4+  |  NOP  }
{  SW R1, R0, 4+  |  SW D0, A0, 4+  |  NOP  |  SW D0, A0, 4+  |  NOP  }
{  SW R1, R0, 4+  |  SW D0, A0, 4+  |  NOP  |  SW D0, A0, 4+  |  NOP  }
{  SW R1, R0, 4+  |  SW D0, A0, 4+  |  NOP  |  SW D0, A0, 4+  |  NOP  }
{  SW R1, R0, 4+  |  SW D0, A0, 4+  |  NOP  |  SW D0, A0, 4+  |  NOP  }
{  SW R1, R0, 4+  |  SW D0, A0, 4+  |  NOP  |  SW D0, A0, 4+  |  NOP  }
{  SW R1, R0, 4+  |  SW D0, A0, 4+  |  NOP  |  SW D0, A0, 4+  |  NOP  }
{  SW R1, R0, 4+  |  SW D0, A0, 4+  |  NOP  |  SW D0, A0, 4+  |  NOP  }
{  SW R1, R0, 4+  |  SW D0, A0, 4+  |  NOP  |  SW D0, A0, 4+  |  NOP  }
{  SW R1, R0, 4+  |  SW D0, A0, 4+  |  NOP  |  SW D0, A0, 4+  |  NOP  }
{  SW R1, R0, 4+  |  SW D0, A0, 4+  |  NOP  |  SW D0, A0, 4+  |  NOP  }
{  SW R1, R0, 4+  |  SW D0, A0, 4+  |  NOP  |  SW D0, A0, 4+  |  NOP  }
{  SW R1, R0, 4+  |  SW D0, A0, 4+  |  NOP  |  SW D0, A0, 4+  |  NOP  }
{  SW R1, R0, 4+  |  SW D0, A0, 4+  |  NOP  |  SW D0, A0, 4+  |  NOP  }
{  SW R1, R0, 4+  |  SW D0, A0, 4+  |  NOP  |  SW D0, A0, 4+  |  NOP  }
{  SW R1, R0, 4+  |  SW D0, A0, 4+  |  NOP  |  SW D0, A0, 4+  |  NOP  }
{  SW R1, R0, 4+  |  SW D0, A0, 4+  |  NOP  |  SW D0, A0, 4+  |  NOP  }


;--------------------------------------------------------------  single (D)SNW operation
{  NOP  |  MOVI.L A0, 0x0000  |  NOP  |  MOVI.L A0, 0x4000  |  NOP  }
{  NOP  |  SNW D1, A0, 3  |  NOP  |  NOP  |  NOP  }
;Mem[0x1200_0000] = 0x1100_0000, Mem[0x1200_0004] = 0x0011_1111
{  NOP  |  NOP  |  NOP  |  SNW D1, A0, 2  |  NOP  }
;Mem[0x1200_4000] = 0x1111_0000, Mem[0x1200_4004] = 0x0000_1111
{  NOP  |  DSNW D2, D3, A0, 7  |  NOP  |  NOP  |  NOP  }
;Mem[0x1200_0004] = 0x2211_1111, Mem[0x1200_0008] = 0x3322_2222, Mem[0x1200_000C] = 0x0033_3333
{  NOP  |  NOP  |  NOP  |  DSNW D2, D3, A0, 6  |  NOP  }
;Mem[0x1200_4004] = 0x2222_1111, Mem[0x1200_4008] = 0x3333_2222, Mem[0x1200_400C] = 0x0000_3333


;--------------------------------------------------------------  (D)SNW/(D)SW pair operation
{  NOP  |  SNW D4, A0, 17  |  NOP  |  SW D4, A0, 16  |  NOP  }
;Mem[0x1200_0010] = 0x4444_4400, Mem[0x1200_0014] = 0x0000_0044
;Mem[0x1200_4010] = 0x4444_4444

{  NOP  |  SW D5, A0, 24  |  NOP  |  SNW D5, A0, 18  |  NOP  }
;Mem[0x1200_0018] = 0x5555_5555
;Mem[0x1200_4010] = 0x5555_4444, Mem[0x1200_4014] = 0x0000_5555

{  NOP  |  DSNW D6, D7, A0, 30  |  NOP  |  DSW D6, D7, A0, 24  |  NOP  }
;Mem[0x1200_001C] = 0x6666_0000, Mem[0x1200_0020] = 0x7777_6666, Mem[0x1200_0024] = 0x0000_7777
;Mem[0x1200_4018] = 0x6666_6666, Mem[0x1200_401C] = 0x7777_7777

{  NOP  |  DSW D2, D3, A0, 40  |  NOP  |  DSNW D2, D3, A0, 33  |  NOP  }
;Mem[0x1200_0028] = 0x2222_2222, Mem[0x1200_002C] = 0x3333_3333
;Mem[0x1200_4020] = 0x2222_2200, Mem[0x1200_4024] = 0x3333_3322, Mem[0x1200_4028] = 0x0000_0033



;--------------------------------------------------------------  single (D)LNW operation
{  NOP  |  LNW D8, A0, 2  |  NOP  |  NOP  |  NOP  }
;Cluster1: Reg[D8] = 0x1111_1100
{  NOP  |  NOP  |  NOP  |  LNW D8, A0, 2  |  NOP  }
;Cluster2: Reg[D8] = 0x1111_1111
{  NOP  |  DLNW D10, A0, 9  |  NOP  |  NOP  |  NOP  }
;Cluster1:Reg[D10] = 0x3333_2222
;Cluster1:Reg[D11] = 0x0000_3333
{  NOP  |  NOP  |  NOP  |  DLNW D10, A0, 10  |  NOP  }
;Cluster2:Reg[D10] = 0x3333_3333
;Cluster2:Reg[D11] = 0x4444_0000

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

;--------------------------------------------------------------  store results
{  NOP  |  SW D8, A0, 48  |  NOP  |  SW D8, A0, 44  |  NOP  }
;Mem[0x1200_0030] = 0x1111_1100
;Mem[0x1200_402C] = 0x1111_1111
{  NOP  |  SW D10, A0, 52  |  NOP  |  SW D10, A0, 48  |  NOP  }
;Mem[0x1200_0034] = 0x3333_2222
;Mem[0x1200_4030] = 0x3333_3333
{  NOP  |  SW D11, A0, 56  |  NOP  |  SW D11, A0, 52  |  NOP  }
;Mem[0x1200_0038] = 0x4400_0033
;Mem[0x1200_4034] = 0x4444_0000



;--------------------------------------------------------------  (D)LNW/(D)LW pair operation
{  NOP  |  LNW D8, A0, 19  |  NOP  |  LW D8, A0, 16  |  NOP  }
;Cluster1: Reg[D8] = 0x0000_4444
;Cluster2: Reg[D8] = 0x4444_4444
{  NOP  |  LW D9, A0, 20  |  NOP  |  LNW D9, A0, 21  |  NOP  }
;Cluster1: Reg[D9] = 0x0000_0044
;Cluster2: Reg[D9] = 0x6600_0055

{  NOP  |  DLNW D10, A0, 26  |  NOP  |  DLW D10, A0, 24  |  NOP  }
;Cluster1: Reg[D10] = 0x0000_5555
;Cluster1: Reg[D11] = 0x6666_6666
;Cluster2: Reg[D10] = 0x6666_6666
;Cluster2: Reg[D11] = 0x7777_7777

{  NOP  |  DLW D12, A0, 24  |  NOP  |  DLNW D12, A0, 29  |  NOP  }
;Cluster1: Reg[D12] = 0x6666_0000
;Cluster1: Reg[D13] = 0x7777_6666
;Cluster2: Reg[D12] = 0x0077_7777
;Cluster2: Reg[D13] = 0x2222_2222


;--------------------------------------------------------------  store results
{  NOP  |  SW D8, A0, 60  |  NOP  |  SW D8, A0, 56  |  NOP  }
;Mem[0x1200_003C] = 0x0000_4444
;Mem[0x1200_4038] = 0x4444_4444
{  NOP  |  SW D9, A0, 64  |  NOP  |  SW D9, A0, 60  |  NOP  }
;Mem[0x1200_0040] = 0x0000_0044
;Mem[0x1200_403C] = 0x6600_0055
{  NOP  |  SW D10, A0, 68  |  NOP  |  SW D10, A0, 64  |  NOP  }
;Mem[0x1200_0044] = 0x0000_5555
;Mem[0x1200_4040] = 0x6666_6666
{  NOP  |  SW D11, A0, 72  |  NOP  |  SW D11, A0, 68  |  NOP  }
;Mem[0x1200_0048] = 0x6666_6666
;Mem[0x1200_4044] = 0x7777_7777
{  NOP  |  SW D12, A0, 76  |  NOP  |  SW D12, A0, 72  |  NOP  }
;Mem[0x1200_004C] = 0x6666_0000
;Mem[0x1200_4048] = 0x7777_6666
{  NOP  |  SW D13, A0, 80  |  NOP  |  SW D13, A0, 76  |  NOP  }
;Mem[0x1200_0050] = 0x0077_7777
;Mem[0x1200_404C] = 0x2222_2222






;//////////////////////////////////////////// Non-interleaved Mode/////////////////////////////////////////
{  MOVI.L R2, 0x803C    |  NOP  |  NOP  |  NOP  |  NOP  }  ; Data memory interleaving
{  MOVI.H R2, DMEM_BASE |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.L R3, 0x0000    |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R3, 0x0000    |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R3, R2, 0  |  NOP  |  NOP  |  NOP  |  NOP  }
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
; Wait until interleave_reg

;************************************************************** Initialize Memory
{  NOP  |  MOVI.L A0, 0x0054  |  NOP  |  MOVI.L A0, 0x4050  |  NOP  }
{  NOP  |  MOVI.L D0, 0x0000  |  NOP  |  MOVI.L D0, 0x0000  |  NOP  }
{  NOP  |  MOVI.H D0, 0x0000  |  NOP  |  MOVI.H D0, 0x0000  |  NOP  }
{  NOP  |  SW D0, A0, 4+  |  NOP  |  SW D0, A0, 4+  |  NOP  }
{  NOP  |  SW D0, A0, 4+  |  NOP  |  SW D0, A0, 4+  |  NOP  }
{  NOP  |  SW D0, A0, 4+  |  NOP  |  SW D0, A0, 4+  |  NOP  }
{  NOP  |  SW D0, A0, 4+  |  NOP  |  SW D0, A0, 4+  |  NOP  }
{  NOP  |  SW D0, A0, 4+  |  NOP  |  SW D0, A0, 4+  |  NOP  }
{  NOP  |  SW D0, A0, 4+  |  NOP  |  SW D0, A0, 4+  |  NOP  }
{  NOP  |  SW D0, A0, 4+  |  NOP  |  SW D0, A0, 4+  |  NOP  }
{  NOP  |  SW D0, A0, 4+  |  NOP  |  SW D0, A0, 4+  |  NOP  }
{  NOP  |  SW D0, A0, 4+  |  NOP  |  SW D0, A0, 4+  |  NOP  }
{  NOP  |  SW D0, A0, 4+  |  NOP  |  SW D0, A0, 4+  |  NOP  }
{  NOP  |  SW D0, A0, 4+  |  NOP  |  SW D0, A0, 4+  |  NOP  }
{  NOP  |  SW D0, A0, 4+  |  NOP  |  SW D0, A0, 4+  |  NOP  }
{  NOP  |  SW D0, A0, 4+  |  NOP  |  SW D0, A0, 4+  |  NOP  }
{  NOP  |  SW D0, A0, 4+  |  NOP  |  SW D0, A0, 4+  |  NOP  }
{  NOP  |  SW D0, A0, 4+  |  NOP  |  SW D0, A0, 4+  |  NOP  }
{  NOP  |  SW D0, A0, 4+  |  NOP  |  SW D0, A0, 4+  |  NOP  }
{  NOP  |  SW D0, A0, 4+  |  NOP  |  SW D0, A0, 4+  |  NOP  }
;--------------------------------------------------------------  single (D)SNW operation
{  NOP  |  MOVI.L A0, 0x0054  |  NOP  |  MOVI.L A0, 0x4050  |  NOP  }
{  NOP  |  SNW D1, A0, 3  |  NOP  |  NOP  |  NOP  }
;Mem[0x1200_0054] = 0x1100_0000, Mem[0x1200_0058] = 0x0011_1111
{  NOP  |  NOP  |  NOP  |  SNW D1, A0, 2  |  NOP  }
;Mem[0x1200_4050] = 0x1111_0000, Mem[0x1200_4054] = 0x0000_1111
{  NOP  |  DSNW D2, D3, A0, 7  |  NOP  |  NOP  |  NOP  }
;Mem[0x1200_0058] = 0x2211_1111, Mem[0x1200_005C] = 0x3322_2222, Mem[0x1200_0060] = 0x0033_3333
{  NOP  |  NOP  |  NOP  |  DSNW D2, D3, A0, 6  |  NOP  }
;Mem[0x1200_4054] = 0x2222_1111, Mem[0x1200_4058] = 0x3333_2222, Mem[0x1200_405C] = 0x0000_3333


;--------------------------------------------------------------  (D)SNW/(D)SW pair operation
{  NOP  |  SNW D4, A0, 17  |  NOP  |  SW D4, A0, 16  |  NOP  }
;Mem[0x1200_0064] = 0x4444_4400, Mem[0x1200_0068] = 0x0000_0044
;Mem[0x1200_4060] = 0x4444_4444

{  NOP  |  SW D5, A0, 24  |  NOP  |  SNW D5, A0, 18  |  NOP  }
;Mem[0x1200_006C] = 0x5555_5555
;Mem[0x1200_4060] = 0x5555_4444, Mem[0x1200_4064] = 0x0000_5555

{  NOP  |  DSNW D6, D7, A0, 30  |  NOP  |  DSW D6, D7, A0, 24  |  NOP  }
;Mem[0x1200_0070] = 0x6666_0000, Mem[0x1200_0074] = 0x7777_6666, Mem[0x1200_0078] = 0x0000_7777
;Mem[0x1200_4068] = 0x6666_6666, Mem[0x1200_406C] = 0x7777_7777

{  NOP  |  SW D2, A0, 40  |  NOP  |  DSNW D2, D3, A0, 33  |  NOP  }
;Mem[0x1200_007C] = 0x2222_2222
;Mem[0x1200_4070] = 0x2222_2200, Mem[0x1200_4074] = 0x3333_3322, Mem[0x1200_4078] = 0x0000_0033

{  NOP  |  SW D3, A0, 44  |  NOP  |  NOP  |  NOP  }
;Mem[0x1200_0080] = 0x3333_3333
;--------------------------------------------------------------  single (D)LNW operation
{  NOP  |  LNW D8, A0, 2  |  NOP  |  NOP  |  NOP  }
;Cluster1: Reg[D8] = 0x1111_1100
{  NOP  |  NOP  |  NOP  |  LNW D8, A0, 2  |  NOP  }
;Cluster2: Reg[D8] = 0x1111_1111
{  NOP  |  DLNW D10, A0, 9  |  NOP  |  NOP  |  NOP  }
;Cluster1:Reg[D10] = 0x3333_2222
;Cluster1:Reg[D11] = 0x0000_3333
{  NOP  |  NOP  |  NOP  |  DLNW D10, A0, 10  |  NOP  }
;Cluster2:Reg[D10] = 0x3333_3333
;Cluster2:Reg[D11] = 0x4444_0000

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
;--------------------------------------------------------------  store results
{  NOP  |  SW D8, A0, 48  |  NOP  |  SW D8, A0, 44  |  NOP  }
;Mem[0x1200_0084] = 0x1111_1100
;Mem[0x1200_407C] = 0x1111_1111
{  NOP  |  SW D10, A0, 52  |  NOP  |  SW D10, A0, 48  |  NOP  }
;Mem[0x1200_0088] = 0x3333_2222
;Mem[0x1200_4080] = 0x3333_3333
{  NOP  |  SW D11, A0, 56  |  NOP  |  SW D11, A0, 52  |  NOP  }
;Mem[0x1200_008C] = 0x4400_0033
;Mem[0x1200_4084] = 0x4444_0000



;--------------------------------------------------------------  (D)LNW/(D)LW pair operation
{  NOP  |  LNW D8, A0, 19  |  NOP  |  LW D8, A0, 16  |  NOP  }
;Cluster1: Reg[D8] = 0x0000_4444
;Cluster2: Reg[D8] = 0x4444_4444
{  NOP  |  LW D9, A0, 20  |  NOP  |  LNW D9, A0, 21  |  NOP  }
;Cluster1: Reg[D9] = 0x0000_0044
;Cluster2: Reg[D9] = 0x6600_0055

{  NOP  |  DLNW D10, A0, 26  |  NOP  |  DLW D10, A0, 24  |  NOP  }
;Cluster1: Reg[D10] = 0x0000_5555
;Cluster1: Reg[D11] = 0x6666_6666
;Cluster2: Reg[D10] = 0x6666_6666
;Cluster2: Reg[D11] = 0x7777_7777

{  NOP  |  DLW D12, A0, 24  |  NOP  |  DLNW D12, A0, 29  |  NOP  }
;Cluster1: Reg[D12] = 0x6666_0000
;Cluster1: Reg[D13] = 0x7777_6666
;Cluster2: Reg[D12] = 0x0077_7777
;Cluster2: Reg[D13] = 0x2222_2222


;--------------------------------------------------------------  store results
{  NOP  |  SW D8, A0, 60  |  NOP  |  SW D8, A0, 56  |  NOP  }
;Mem[0x1200_0090] = 0x0000_4444
;Mem[0x1200_4088] = 0x4444_4444
{  NOP  |  SW D9, A0, 64  |  NOP  |  SW D9, A0, 60  |  NOP  }
;Mem[0x1200_0094] = 0x0000_0044
;Mem[0x1200_408C] = 0x6600_0055
{  NOP  |  SW D10, A0, 68  |  NOP  |  SW D10, A0, 64  |  NOP  }
;Mem[0x1200_0098] = 0x0000_5555
;Mem[0x1200_4090] = 0x6666_6666
{  NOP  |  SW D11, A0, 72  |  NOP  |  SW D11, A0, 68  |  NOP  }
;Mem[0x1200_009C] = 0x6666_6666
;Mem[0x1200_4094] = 0x7777_7777
{  NOP  |  SW D12, A0, 76  |  NOP  |  SW D12, A0, 72  |  NOP  }
;Mem[0x1200_00A0] = 0x6666_0000
;Mem[0x1200_4098] = 0x7777_6666
{  NOP  |  SW D13, A0, 80  |  NOP  |  SW D13, A0, 76  |  NOP  }
;Mem[0x1200_00A4] = 0x0077_7777
;Mem[0x1200_409C] = 0x2222_2222


;************************************************************** Program Terminate
;************************************************************** DMEM -> DDR {A(0x...) R(0x...)}
  {  MOVI.L R2, 0x803C    |  NOP  |  NOP  |  NOP  |  NOP  }
  {  MOVI.H R2, DMEM_BASE |  NOP  |  NOP  |  NOP  |  NOP  }
  {  MOVI.L R3, 0x0001    |  NOP  |  NOP  |  NOP  |  NOP  }
  {  MOVI.H R3, 0x0000    |  NOP  |  NOP  |  NOP  |  NOP  }
  {  SW R3, R2, 0  |  NOP  |  NOP  |  NOP  |  NOP  }
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
  
  { MOVI r0, DMA_CLR_ADDR1 | NOP | NOP | NOP | NOP } 
  { MOVI r1, DMA_CLR_DATA1 | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x0 | NOP | NOP | NOP | NOP }
    
  { MOVI r0, DMA_ENA_ADDR1 | NOP | NOP | NOP | NOP } 
  { MOVI r1, DMA_ENA_DATA1 | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x0 | NOP | NOP | NOP | NOP }
  
  ; waiting dma finish transfer
  { MOVI r0, DMA_STATUS_ADDR | NOP | NOP | NOP | NOP }
DMEM2DDR_1:    
  { LW r1, r0, 0x0 | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }
  { SEQI r2, p1, p2, r1, 0x00002222 | NOP | NOP | NOP | NOP } ; (DMA_STATUS == 0) ? 
  { (p2) B DMEM2DDR_1               | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }  
  { NOP | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }  
  { NOP | NOP | NOP | NOP | NOP }
 
  
  {  MOVI.L R2, 0x803C    |  NOP  |  NOP  |  NOP  |  NOP  }
  {  MOVI.H R2, DMEM_BASE |  NOP  |  NOP  |  NOP  |  NOP  }
  {  MOVI.L R3, 0x0000    |  NOP  |  NOP  |  NOP  |  NOP  }
  {  MOVI.H R3, 0x0000    |  NOP  |  NOP  |  NOP  |  NOP  }
  {  SW R3, R2, 0  |  NOP  |  NOP  |  NOP  |  NOP  }
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
  
  
  { MOVI r0, DMA_SAR_ADDR2 | NOP | NOP | NOP | NOP } 
  { MOVI r1, DMA_SAR_DATA2 | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x0 | NOP | NOP | NOP | NOP }
  { MOVI r0, DMA_DAR_ADDR2 | NOP | NOP | NOP | NOP } 
  { MOVI r1, DMA_DAR_DATA2 | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x0 | NOP | NOP | NOP | NOP }
  { MOVI r0, DMA_CTL_ADDR2 | NOP | NOP | NOP | NOP } 
  { MOVI r1, DMA_CTL_DATA2 | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x0 | NOP | NOP | NOP | NOP }
  
  
  { MOVI r0, DMA_SAR_ADDR3 | NOP | NOP | NOP | NOP } 
  { MOVI r1, DMA_SAR_DATA3 | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x0 | NOP | NOP | NOP | NOP }
  { MOVI r0, DMA_DAR_ADDR3 | NOP | NOP | NOP | NOP } 
  { MOVI r1, DMA_DAR_DATA3 | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x0 | NOP | NOP | NOP | NOP }
  { MOVI r0, DMA_CTL_ADDR3 | NOP | NOP | NOP | NOP } 
  { MOVI r1, DMA_CTL_DATA3 | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x0 | NOP | NOP | NOP | NOP }
  
  { MOVI r0, DMA_ENA_ADDR2 | NOP | NOP | NOP | NOP } 
  { MOVI r1, DMA_ENA_DATA2 | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x0 | NOP | NOP | NOP | NOP }
  
  
  { MOVI r0, DMA_ENA_ADDR3 | NOP | NOP | NOP | NOP } 
  { MOVI r1, DMA_ENA_DATA3 | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x0 | NOP | NOP | NOP | NOP }
  
  
  ; waiting dma finish transfer
  { MOVI r0, DMA_STATUS_ADDR | NOP | NOP | NOP | NOP }
DMEM2DDR:    
  { LW r1, r0, 0x0 | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }
  { SEQI r2, p1, p2, r1, 0x00002222 | NOP | NOP | NOP | NOP } ; (DMA_STATUS == 0) ? 
  { (p2) B DMEM2DDR                 | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }  
  { NOP | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }  
  { NOP | NOP | NOP | NOP | NOP }


{  TRAP  |  NOP  |  NOP  |  NOP  |  NOP  }
