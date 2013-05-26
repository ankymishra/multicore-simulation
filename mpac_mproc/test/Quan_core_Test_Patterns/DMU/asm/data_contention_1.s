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
                             
;  DMA_SAR_DATA0 = 0x24002000 ; set DMEM as start address 
;  DMA_DAR_DATA0 = 0x30002000 ; set DDR as destination address 
;  DMA_SGR_DATA0 = 0x00000000 ; not used
;  DMA_DSR_DATA0 = 0x00000000 ; not used
;  DMA_CTL_DATA0 = 0x00100012 ; DMA_CTL_DATA[31:16]=BSZ
;  DMA_ENA_DATA0 = 0x00000000 ; dma active low
;  DMA_CLR_DATA0 = 0x00000000 ; not used                             
  
  ; DMEM -> DDR
  ; ##############################################
  DMA_SAR_ADDR1 = 0x2405C0B0 ;
  DMA_DAR_ADDR1 = 0x2405C0B4 ;
  DMA_SGR_ADDR1 = 0x2405C0B8 ;
  DMA_DSR_ADDR1 = 0x2405C0BC ;
  DMA_CTL_ADDR1 = 0x2405C0C0 ;
  DMA_ENA_ADDR1 = 0x2405C0C4 ;
  DMA_CLR_ADDR1 = 0x2405C0C8 ;
                             
;  DMA_SAR_DATA1 = 0x24004000 ; set DMEM as start address 
;  DMA_DAR_DATA1 = 0x30004000 ; set DDR as destination address 
;  DMA_SGR_DATA1 = 0x00000000 ; not used
;  DMA_DSR_DATA1 = 0x00000000 ; not used
;  DMA_CTL_DATA1 = 0x00100012 ; DMA_CTL_DATA[31:16]=BSZ
;  DMA_ENA_DATA1 = 0x00000000 ; dma active low
;  DMA_CLR_DATA1 = 0x00000000 ; not used
  
  ; DMEM -> DDR
  ; ##############################################
  DMA_SAR_ADDR2 = 0x2405C0F0 ;
  DMA_DAR_ADDR2 = 0x2405C0F4 ;
  DMA_SGR_ADDR2 = 0x2405C0F8 ;
  DMA_DSR_ADDR2 = 0x2405C0FC ;
  DMA_CTL_ADDR2 = 0x2405C100 ;
  DMA_ENA_ADDR2 = 0x2405C104 ;
  DMA_CLR_ADDR2 = 0x2405C108 ;
                             
;  DMA_SAR_DATA2 = 0x24008000 ; set DMEM as start address 
;  DMA_DAR_DATA2 = 0x30008000 ; set DDR as destination address 
;  DMA_SGR_DATA2 = 0x00000000 ; not used
;  DMA_DSR_DATA2 = 0x00000000 ; not used
;  DMA_CTL_DATA2 = 0x00100012 ; DMA_CTL_DATA[31:16]=BSZ
;  DMA_ENA_DATA2 = 0x00000000 ; dma active low
;  DMA_CLR_DATA2 = 0x00000000 ; not used
  
  ; DMEM -> DDR
  ; ##############################################
  DMA_SAR_ADDR3 = 0x2405C130 ;
  DMA_DAR_ADDR3 = 0x2405C134 ;
  DMA_SGR_ADDR3 = 0x2405C138 ;
  DMA_DSR_ADDR3 = 0x2405C13C ;
  DMA_CTL_ADDR3 = 0x2405C140 ;
  DMA_ENA_ADDR3 = 0x2405C144 ;
  DMA_CLR_ADDR3 = 0x2405C148 ;
                             
;  DMA_SAR_DATA3 = 0x2400C000 ; set DMEM as start address 
;  DMA_DAR_DATA3 = 0x3000C000 ; set DDR as destination address 
;  DMA_SGR_DATA3 = 0x00000000 ; not used
;  DMA_DSR_DATA3 = 0x00000000 ; not used
;  DMA_CTL_DATA3 = 0x00160012 ; DMA_CTL_DATA[31:16]=BSZ
;  DMA_ENA_DATA3 = 0x00000000 ; dma active low
;  DMA_CLR_DATA3 = 0x00000000 ; not used
  
  DMA_STATUS_ADDR = 0x24058054;
  
  BASE_ADDR = 0x2400
  DMEM_BASE = 0x2405; 

;//////////////////////////////////////// Interleaved mode/////////////////////////////////////////////////////////
{  MOVI.L R2, 0x803C    |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R2, DMEM_BASE |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.L R3, 0x0001  |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R3, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R3, R2, 0  |  NOP  |  NOP  |  NOP  |  NOP  }
; Interleaved
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


;********************************************************************* One contention

;-------------------------------------------------------------- One contention in bank0
;Stalled for one cycles
{  MOVI.L R0, 0x0000    |  MOVI.L A0, 0x0000    |  NOP  |  MOVI.L A0, 0x0000    |  NOP  }
{  MOVI.H R0, BASE_ADDR |  MOVI.H A0, BASE_ADDR |  NOP  |  MOVI.H A0, BASE_ADDR |  NOP  }
{  MOVI.L R1, 0x1111    |  MOVI.L D0, 0x0000    |  NOP  |  MOVI.L D0, 0x0000    |  NOP  }
{  MOVI.H R1, 0x0000    |  MOVI.H D0, 0x1111    |  NOP  |  MOVI.H D0, 0x2222    |  NOP  }
{  MOVI.L R2, 0x2222    |  MOVI.L D1, 0x1111    |  NOP  |  MOVI.L D1, 0x1111    |  NOP  }
{  MOVI.H R2, 0x0000    |  MOVI.H D1, 0x1111    |  NOP  |  MOVI.H D1, 0x2222    |  NOP  }
;Reg[R0] = 0x1207_0000, Reg[R1] = 0x0000_1111, Reg[R2] = 0x0000_2222
;Reg[A0] = 0x1207_0000, Reg[D0] = 0x1111_0000, Reg[D1] = 0x1111_1111
;Reg[A0] = 0x1207_0000, Reg[D0] = 0x2222_0000, Reg[D1] = 0x2222_1111

;------------------------------------------------ write/write
{  SW R1, R0, 0  |  SW D0, A0, 4  |  NOP  |  NOP  |  NOP  }
;Mem[0x1207_0000] = 0x0000_1111
;Mem[0x1207_0004] = 0x1111_0000

{  SW R2, R0, 16  |  NOP  |  NOP  |  SW D0, A0, 20  |  NOP  }
;Mem[0x1207_0010] = 0x0000_2222
;Mem[0x1207_0014] = 0x2222_0000

{  NOP  |  SW D0, A0, 32  |  NOP  |  SW D0, A0, 36  |  NOP  }
;Mem[0x1207_0020] = 0x1111_0000
;Mem[0x1207_0024] = 0x2222_0000

;------------------------------------------------ read/write
{  LW R3, R0, 0  |  SW D0, A0, 48  |  NOP  |  NOP  |  NOP  }
;Reg[R3] = 0x0000_1111
;Mem[0x1207_0030] = 0x1111_0000

{  SW R2, R0, 52  |  NOP  |  NOP  |  LW D2, A0, 20  |  NOP  }
;Mem[0x1207_0034] = 0x0000_2222
;C1:Reg[D2] = 0x2222_0000

{  NOP  |  LW D2, A0, 32  |  NOP  |  SW D0, A0, 64  |  NOP  }
;C2:Reg[D2] = 0x1111_0000
;Mem[0x1207_0040] = 0x2222_0000

;------------------------------------------------ read/read
{  LW R4, R0, 0  |  LW D3, A0, 4  |  NOP  |  NOP  |  NOP  }
;Reg[R4] = 0x0000_1111
;C1:Reg[D3] = 0x1111_0000

{  LW R5, R0, 16  |  NOP  |  NOP  |  LW D3, A0, 20  |  NOP  }
;Reg[R5] = 0x0000_2222
;C2:Reg[D3] = 0x2222_0000

{  NOP  |  LW D4, A0, 32  |  NOP  |  LW D4, A0, 36  |  NOP  }
;C1:Reg[D4] = 0x1111_0000
;C2:Reg[D4] = 0x2222_0000

;------------------------------------------------ store result
{  SW R3, R0, 68  |  SW D2, A0, 80  |  NOP  |  SW D2, A0, 84  |  NOP  }
;Mem[0x1207_0044] = 0x0000_1111
;Mem[0x1207_0050] = 0x2222_0000
;Mem[0x1207_0054] = 0x1111_0000

{  SW R4, R0, 96  |  SW D3, A0, 100  |  NOP  |  SW D3, A0, 112  |  NOP  }
;Mem[0x1207_0060] = 0x0000_1111
;Mem[0x1207_0064] = 0x1111_0000
;Mem[0x1207_0070] = 0x2222_0000

{  SW R5, R0, 116  |  SW D4, A0, 128  |  NOP  |  SW D4, A0, 132  |  NOP  }
;Mem[0x1207_0074] = 0x0000_2222
;Mem[0x1207_0080] = 0x1111_0000
;Mem[0x1207_0084] = 0x2222_0000

;-------------------------------------------------------------- One contention in bank1
;Stalled for one cycles

;------------------------------------------------ write/write
{  SW R1, R0, 8  |  SW D0, A0, 12  |  NOP  |  NOP  |  NOP  }
;Mem[0x1207_0008] = 0x0000_1111
;Mem[0x1207_000C] = 0x1111_0000

{  SW R2, R0, 24  |  NOP  |  NOP  |  SW D0, A0, 28  |  NOP  }
;Mem[0x1207_0018] = 0x0000_2222
;Mem[0x1207_001C] = 0x2222_0000

{  NOP  |  SW D0, A0, 40  |  NOP  |  SW D0, A0, 44  |  NOP  }
;Mem[0x1207_0028] = 0x1111_0000
;Mem[0x1207_002C] = 0x2222_0000

;------------------------------------------------ read/write
{  LW R3, R0, 8  |  SW D0, A0, 56  |  NOP  |  NOP  |  NOP  }
;Reg[R3] = 0x0000_1111
;Mem[0x1207_0038] = 0x1111_0000

{  SW R2, R0, 60  |  NOP  |  NOP  |  LW D2, A0, 28  |  NOP  }
;Mem[0x1207_003C] = 0x0000_2222
;C1:Reg[D2] = 0x2222_0000

{  NOP  |  LW D2, A0, 40  |  NOP  |  SW D0, A0, 72  |  NOP  }
;C2:Reg[D2] = 0x1111_0000
;Mem[0x1207_0048] = 0x2222_0000

;------------------------------------------------ read/read
{  LW R4, R0, 8  |  LW D3, A0, 12  |  NOP  |  NOP  |  NOP  }
;Reg[R4] = 0x0000_1111
;C1:Reg[D3] = 0x1111_0000

{  LW R5, R0, 24  |  NOP  |  NOP  |  LW D3, A0, 28  |  NOP  }
;Reg[R5] = 0x0000_2222
;C2:Reg[D3] = 0x2222_0000

{  NOP  |  LW D4, A0, 40  |  NOP  |  LW D4, A0, 44  |  NOP  }
;C1:Reg[D4] = 0x1111_0000
;C2:Reg[D4] = 0x2222_0000

;------------------------------------------------ store result
{  SW R3, R0, 76  |  SW D2, A0, 88  |  NOP  |  SW D2, A0, 92  |  NOP  }
;Mem[0x1207_004C] = 0x0000_1111
;Mem[0x1207_0058] = 0x2222_0000
;Mem[0x1207_005C] = 0x1111_0000

{  SW R4, R0, 104  |  SW D3, A0, 108  |  NOP  |  SW D3, A0, 120  |  NOP  }
;Mem[0x1207_0068] = 0x0000_1111
;Mem[0x1207_006C] = 0x1111_0000
;Mem[0x1207_0078] = 0x2222_0000

{  SW R5, R0, 124  |  SW D4, A0, 136  |  NOP  |  SW D4, A0, 140  |  NOP  }
;Mem[0x1207_007C] = 0x0000_2222
;Mem[0x1207_0088] = 0x1111_0000
;Mem[0x1207_008C] = 0x2222_0000

;-------------------------------------------------------------- One contention in bank2
;Stalled for one cycles
{  MOVI.L R0, 0x4000  |  MOVI.L A0, 0x4000  |  NOP  |  MOVI.L A0, 0x4000  |  NOP  }
;Reg[R0] = 0x1207_4000
;Reg[A0] = 0x1207_4000
;Reg[A0] = 0x1207_4000

;------------------------------------------------ write/write
{  SW R1, R0, 0  |  SW D0, A0, 4  |  NOP  |  NOP  |  NOP  }
;Mem[0x1207_4000] = 0x0000_1111
;Mem[0x1207_4004] = 0x1111_0000

{  SW R2, R0, 16  |  NOP  |  NOP  |  SW D0, A0, 20  |  NOP  }
;Mem[0x1207_4010] = 0x0000_2222
;Mem[0x1207_4014] = 0x2222_0000

{  NOP  |  SW D0, A0, 32  |  NOP  |  SW D0, A0, 36  |  NOP  }
;Mem[0x1207_4020] = 0x1111_0000
;Mem[0x1207_4024] = 0x2222_0000

;------------------------------------------------ read/write
{  LW R3, R0, 0  |  SW D0, A0, 48  |  NOP  |  NOP  |  NOP  }
;Reg[R3] = 0x0000_1111
;Mem[0x1207_4030] = 0x1111_0000

{  SW R2, R0, 52  |  NOP  |  NOP  |  LW D2, A0, 20  |  NOP  }
;Mem[0x1207_4034] = 0x0000_2222
;C1:Reg[D2] = 0x2222_0000

{  NOP  |  LW D2, A0, 32  |  NOP  |  SW D0, A0, 64  |  NOP  }
;C2:Reg[D2] = 0x1111_0000
;Mem[0x1207_4040] = 0x2222_0000

;------------------------------------------------ read/read
{  LW R4, R0, 0  |  LW D3, A0, 4  |  NOP  |  NOP  |  NOP  }
;Reg[R4] = 0x0000_1111
;C1:Reg[D3] = 0x1111_0000

{  LW R5, R0, 16  |  NOP  |  NOP  |  LW D3, A0, 20  |  NOP  }
;Reg[R5] = 0x0000_2222
;C2:Reg[D3] = 0x2222_0000

{  NOP  |  LW D4, A0, 32  |  NOP  |  LW D4, A0, 36  |  NOP  }
;C1:Reg[D4] = 0x1111_0000
;C2:Reg[D4] = 0x2222_0000

;------------------------------------------------ store result
{  SW R3, R0, 68  |  SW D2, A0, 80  |  NOP  |  SW D2, A0, 84  |  NOP  }
;Mem[0x1207_4044] = 0x0000_1111
;Mem[0x1207_4050] = 0x2222_0000
;Mem[0x1207_4054] = 0x1111_0000

{  SW R4, R0, 96  |  SW D3, A0, 100  |  NOP  |  SW D3, A0, 112  |  NOP  }
;Mem[0x1207_4060] = 0x0000_1111
;Mem[0x1207_4064] = 0x1111_0000
;Mem[0x1207_4070] = 0x2222_0000

{  SW R5, R0, 116  |  SW D4, A0, 128  |  NOP  |  SW D4, A0, 132  |  NOP  }
;Mem[0x1207_4074] = 0x0000_2222
;Mem[0x1207_4080] = 0x1111_0000
;Mem[0x1207_4084] = 0x2222_0000


;-------------------------------------------------------------- One contention in bank3
;Stalled for one cycles

;------------------------------------------------ write/write
{  SW R1, R0, 8  |  SW D0, A0, 12  |  NOP  |  NOP  |  NOP  }
;Mem[0x1207_4008] = 0x0000_1111
;Mem[0x1207_400C] = 0x1111_0000

{  SW R2, R0, 24  |  NOP  |  NOP  |  SW D0, A0, 28  |  NOP  }
;Mem[0x1207_4018] = 0x0000_2222
;Mem[0x1207_401C] = 0x2222_0000

{  NOP  |  SW D0, A0, 40  |  NOP  |  SW D0, A0, 44  |  NOP  }
;Mem[0x1207_4028] = 0x1111_0000
;Mem[0x1207_402C] = 0x2222_0000

;------------------------------------------------ read/write
{  LW R3, R0, 8  |  SW D0, A0, 56  |  NOP  |  NOP  |  NOP  }
;Reg[R3] = 0x0000_1111
;Mem[0x1207_4038] = 0x1111_0000

{  SW R2, R0, 60  |  NOP  |  NOP  |  LW D2, A0, 28  |  NOP  }
;Mem[0x1207_403C] = 0x0000_2222
;C1:Reg[D2] = 0x2222_0000

{  NOP  |  LW D2, A0, 40  |  NOP  |  SW D0, A0, 72  |  NOP  }
;C2:Reg[D2] = 0x1111_0000
;Mem[0x1207_4048] = 0x2222_0000

;------------------------------------------------ read/read
{  LW R4, R0, 8  |  LW D3, A0, 12  |  NOP  |  NOP  |  NOP  }
;Reg[R4] = 0x0000_1111
;C1:Reg[D3] = 0x1111_0000

{  LW R5, R0, 24  |  NOP  |  NOP  |  LW D3, A0, 28  |  NOP  }
;Reg[R5] = 0x0000_2222
;C2:Reg[D3] = 0x2222_0000

{  NOP  |  LW D4, A0, 40  |  NOP  |  LW D4, A0, 44  |  NOP  }
;C1:Reg[D4] = 0x1111_0000
;C2:Reg[D4] = 0x2222_0000

;------------------------------------------------ store result
{  SW R3, R0, 76  |  SW D2, A0, 88  |  NOP  |  SW D2, A0, 92  |  NOP  }
;Mem[0x1207_404C] = 0x0000_1111
;Mem[0x1207_4058] = 0x2222_0000
;Mem[0x1207_405C] = 0x1111_0000

{  SW R4, R0, 104  |  SW D3, A0, 108  |  NOP  |  SW D3, A0, 120  |  NOP  }
;Mem[0x1207_4068] = 0x0000_1111
;Mem[0x1207_406C] = 0x1111_0000
;Mem[0x1207_4078] = 0x2222_0000

{  SW R5, R0, 124  |  SW D4, A0, 136  |  NOP  |  SW D4, A0, 140  |  NOP  }
;Mem[0x1207_407C] = 0x0000_2222
;Mem[0x1207_4088] = 0x1111_0000
;Mem[0x1207_408C] = 0x2222_0000



;********************************************************************* Two contentions

;-------------------------------------------------------------- Two contentions in bank0
;Stalled for two cycles
{  MOVI.L R0, 0x0090  |  MOVI.L A0, 0x0090  |  NOP  |  MOVI.L A0, 0x0090  |  NOP  }
;Reg[R0] = 0x1207_0090
;Reg[A0] = 0x1207_0090
;Reg[A0] = 0x1207_0090

;------------------------------------------------ write/write/write
{  SW R1, R0, 0  |  SW D0, A0, 4  |  NOP  |  DSW D0, D1, A0, 16  |  NOP  }
;Mem[0x1207_0090] = 0x0000_1111
;Mem[0x1207_0094] = 0x1111_0000
;Mem[0x1207_00A0] = 0x2222_0000
;Mem[0x1207_00A4] = 0x2222_1111

;------------------------------------------------ read/write/write
{  LW R3, R0, 0  |  SW D0, A0, 32  |  NOP  |  SW D0, A0, 36  |  NOP  }
;Reg[R3] = 0x0000_1111
;Mem[0x1207_00B0] = 0x1111_0000
;Mem[0x1207_00B4] = 0x2222_0000

;------------------------------------------------ write/read/write
{  SW R1, R0, 48  |  LW D2, A0, 0  |  NOP  |  SW D0, A0, 52  |  NOP  }
;Mem[0x1207_00C0] = 0x0000_1111
;Reg[D2] = 0x0000_1111
;Mem[0x1207_00C4] = 0x2222_0000

;------------------------------------------------ write/write/read
{  SW R1, R0, 64  |  SW D0, A0, 68  |  NOP  |  LW D2, A0, 20  |  NOP  }
;Mem[0x1207_00D0] = 0x0000_1111
;Mem[0x1207_00D4] = 0x1111_0000
;Reg[D2] = 0x2222_1111

;------------------------------------------------ read/read/write
{  LW R4, R0, 0  |  LW D3, A0, 16  |  NOP  |  SW D0, A0, 80  |  NOP  }
;Reg[R4] = 0x0000_1111
;Reg[D3] = 0x2222_0000
;Mem[0x1207_00E0] = 0x1111_0000

;------------------------------------------------ read/write/read
{  LW R5, R0, 0  |  SW D0, A0, 84  |  NOP  |  LW D3, A0, 16  |  NOP  }
;Reg[R5] = 0x0000_1111
;Mem[0x1207_00E4] = 0x1111_0000
;Reg[D3] = 0x2222_0000

;------------------------------------------------ write/read/read
{  SW R0, R0, 96  |  LW D4, A0, 4  |  NOP  |  LW D4, A0, 16  |  NOP  }
;Mem[0x1207_00F0] = 0x0000_1111
;Reg[D4] = 0x1111_0000
;Reg[D4] = 0x2222_0000

;------------------------------------------------ read/read/read
{  LW R6, R0, 0  |  LW D5, A0, 4  |  NOP  |  LW D5, A0, 16  |  NOP  }
;Reg[R6] = 0x0000_1111
;Reg[D5] = 0x1111_0000
;Reg[D5] = 0x2222_0000

;------------------------------------------------ store result
{  SW R3, R0, 100  |  SW D2, A0, 112  |  NOP  |  SW D2, A0, 116  |  NOP  }
;Mem[0x1207_00F4] = 0x0000_1111
;Mem[0x1207_0100] = 0x1111_0000
;Mem[0x1207_0104] = 0x2222_1111

{  SW R4, R0, 128  |  SW D3, A0, 132  |  NOP  |  SW D3, A0, 144  |  NOP  }
;Mem[0x1207_0110] = 0x0000_1111
;Mem[0x1207_0114] = 0x2222_0000
;Mem[0x1207_0120] = 0x2222_0000

{  SW R5, R0, 148  |  SW D4, A0, 160  |  NOP  |  SW D4, A0, 164  |  NOP  }
;Mem[0x1207_0124] = 0x0000_1111
;Mem[0x1207_0130] = 0x1111_0000
;Mem[0x1207_0134] = 0x2222_0000

{  SW R6, R0, 176  |  SW D5, A0, 180  |  NOP  |  SW D5, A0, 192  |  NOP  }
;Mem[0x1207_0140] = 0x0000_1111
;Mem[0x1207_0144] = 0x1111_0000
;Mem[0x1207_0150] = 0x2222_0000


;-------------------------------------------------------------- Two contentions in bank1
;Stalled for two cycles
;------------------------------------------------ write/write/write
{  SW R1, R0, 8  |  SW D0, A0, 12  |  NOP  |  DSW D0, D1, A0, 24  |  NOP  }
;Mem[0x1207_0098] = 0x0000_1111
;Mem[0x1207_009C] = 0x1111_0000
;Mem[0x1207_00A8] = 0x2222_0000
;Mem[0x1207_00AC] = 0x2222_1111

;------------------------------------------------ read/write/write
{  LW R3, R0, 8  |  SW D0, A0, 40  |  NOP  |  SW D0, A0, 44  |  NOP  }
;Reg[R3] = 0x0000_1111
;Mem[0x1207_00B8] = 0x1111_0000
;Mem[0x1207_00BC] = 0x2222_0000

;------------------------------------------------ write/read/write
{  SW R1, R0, 56  |  LW D2, A0, 8  |  NOP  |  SW D0, A0, 60  |  NOP  }
;Mem[0x1207_00C8] = 0x0000_1111
;Reg[D2] = 0x0000_1111
;Mem[0x1207_00CC] = 0x2222_0000

;------------------------------------------------ write/write/read
{  SW R1, R0, 72  |  SW D0, A0, 76  |  NOP  |  LW D2, A0, 28  |  NOP  }
;Mem[0x1207_00D8] = 0x0000_1111
;Mem[0x1207_00DC] = 0x1111_0000
;Reg[D2] = 0x2222_1111

;------------------------------------------------ read/read/write
{  LW R4, R0, 8  |  LW D3, A0, 24  |  NOP  |  SW D0, A0, 88  |  NOP  }
;Reg[R4] = 0x0000_1111
;Reg[D3] = 0x2222_0000
;Mem[0x1207_00E8] = 0x1111_0000

;------------------------------------------------ read/write/read
{  LW R5, R0, 8  |  SW D0, A0, 92  |  NOP  |  LW D3, A0, 24  |  NOP  }
;Reg[R5] = 0x0000_1111
;Mem[0x1207_00EC] = 0x1111_0000
;Reg[D3] = 0x2222_0000

;------------------------------------------------ write/read/read
{  SW R0, R0, 104  |  LW D4, A0, 12  |  NOP  |  LW D4, A0, 24  |  NOP  }
;Mem[0x1207_00F8] = 0x0000_1111
;Reg[D4] = 0x1111_0000
;Reg[D4] = 0x2222_0000

;------------------------------------------------ read/read/read
{  LW R6, R0, 8  |  LW D5, A0, 12  |  NOP  |  LW D5, A0, 24  |  NOP  }
;Reg[R6] = 0x0000_1111
;Reg[D5] = 0x1111_0000
;Reg[D5] = 0x2222_0000

;------------------------------------------------ store result
{  SW R3, R0, 108  |  SW D2, A0, 120  |  NOP  |  SW D2, A0, 124  |  NOP  }
;Mem[0x1207_00FC] = 0x0000_1111
;Mem[0x1207_0108] = 0x1111_0000
;Mem[0x1207_010C] = 0x2222_1111

{  SW R4, R0, 136  |  SW D3, A0, 140  |  NOP  |  SW D3, A0, 152  |  NOP  }
;Mem[0x1207_0118] = 0x0000_1111
;Mem[0x1207_011C] = 0x2222_0000
;Mem[0x1207_0128] = 0x2222_0000

{  SW R5, R0, 156  |  SW D4, A0, 168  |  NOP  |  SW D4, A0, 172  |  NOP  }
;Mem[0x1207_012C] = 0x0000_1111
;Mem[0x1207_0138] = 0x1111_0000
;Mem[0x1207_013C] = 0x2222_0000

{  SW R6, R0, 184  |  SW D5, A0, 188  |  NOP  |  SW D5, A0, 200  |  NOP  }
;Mem[0x1207_0148] = 0x0000_1111
;Mem[0x1207_014C] = 0x1111_0000
;Mem[0x1207_0158] = 0x2222_0000



;-------------------------------------------------------------- Two contentions in bank2
;Stalled for two cycl
{  MOVI.L R0, 0x4090  |  MOVI.L A0, 0x4090  |  NOP  |  MOVI.L A0, 0x4090  |  NOP  }
;Reg[R0] = 0x1207_4090
;Reg[A0] = 0x1207_4090
;Reg[A0] = 0x1207_4090

;------------------------------------------------ write/write/write
{  SW R1, R0, 0  |  SW D0, A0, 4  |  NOP  |  DSW D0, D1, A0, 16  |  NOP  }
;Mem[0x1207_4090] = 0x0000_1111
;Mem[0x1207_4094] = 0x1111_0000
;Mem[0x1207_40A0] = 0x2222_0000
;Mem[0x1207_40A4] = 0x2222_1111

;------------------------------------------------ read/write/write
{  LW R3, R0, 0  |  SW D0, A0, 32  |  NOP  |  SW D0, A0, 36  |  NOP  }
;Reg[R3] = 0x0000_1111
;Mem[0x1207_40B0] = 0x1111_0000
;Mem[0x1207_40B4] = 0x2222_0000

;------------------------------------------------ write/read/write
{  SW R1, R0, 48  |  LW D2, A0, 0  |  NOP  |  SW D0, A0, 52  |  NOP  }
;Mem[0x1207_40C0] = 0x0000_1111
;Reg[D2] = 0x0000_1111
;Mem[0x1207_40C4] = 0x2222_0000

;------------------------------------------------ write/write/read
{  SW R1, R0, 64  |  SW D0, A0, 68  |  NOP  |  LW D2, A0, 20  |  NOP  }
;Mem[0x1207_40D0] = 0x0000_1111
;Mem[0x1207_40D4] = 0x1111_0000
;Reg[D2] = 0x2222_1111

;------------------------------------------------ read/read/write
{  LW R4, R0, 0  |  LW D3, A0, 16  |  NOP  |  SW D0, A0, 80  |  NOP  }
;Reg[R4] = 0x0000_1111
;Reg[D3] = 0x2222_0000
;Mem[0x1207_40E0] = 0x1111_0000

;------------------------------------------------ read/write/read
{  LW R5, R0, 0  |  SW D0, A0, 84  |  NOP  |  LW D3, A0, 16  |  NOP  }
;Reg[R5] = 0x0000_1111
;Mem[0x1207_40E4] = 0x1111_0000
;Reg[D3] = 0x2222_0000

;------------------------------------------------ write/read/read
{  SW R0, R0, 96  |  LW D4, A0, 4  |  NOP  |  LW D4, A0, 16  |  NOP  }
;Mem[0x1207_40F0] = 0x0000_1111
;Reg[D4] = 0x1111_0000
;Reg[D4] = 0x2222_0000

;------------------------------------------------ read/read/read
{  LW R6, R0, 0  |  LW D5, A0, 4  |  NOP  |  LW D5, A0, 16  |  NOP  }
;Reg[R6] = 0x0000_1111
;Reg[D5] = 0x1111_0000
;Reg[D5] = 0x2222_0000

;------------------------------------------------ store result
{  SW R3, R0, 100  |  SW D2, A0, 112  |  NOP  |  SW D2, A0, 116  |  NOP  }
;Mem[0x1207_40F4] = 0x0000_1111
;Mem[0x1207_4100] = 0x1111_0000
;Mem[0x1207_4104] = 0x2222_1111

{  SW R4, R0, 128  |  SW D3, A0, 132  |  NOP  |  SW D3, A0, 144  |  NOP  }
;Mem[0x1207_4110] = 0x0000_1111
;Mem[0x1207_4114] = 0x2222_0000
;Mem[0x1207_4120] = 0x2222_0000

{  SW R5, R0, 148  |  SW D4, A0, 160  |  NOP  |  SW D4, A0, 164  |  NOP  }
;Mem[0x1207_4124] = 0x0000_1111
;Mem[0x1207_4130] = 0x1111_0000
;Mem[0x1207_4134] = 0x2222_0000

{  SW R6, R0, 176  |  SW D5, A0, 180  |  NOP  |  SW D5, A0, 192  |  NOP  }
;Mem[0x1207_4140] = 0x0000_1111
;Mem[0x1207_4144] = 0x1111_0000
;Mem[0x1207_4150] = 0x2222_0000



;-------------------------------------------------------------- Two contentions in bank3
;Stalled for two cycles
;------------------------------------------------ write/write/write
{  SW R1, R0, 8  |  SW D0, A0, 12  |  NOP  |  DSW D0, D1, A0, 24  |  NOP  }
;Mem[0x1207_4098] = 0x0000_1111
;Mem[0x1207_409C] = 0x1111_0000
;Mem[0x1207_40A8] = 0x2222_0000
;Mem[0x1207_40AC] = 0x2222_1111

;------------------------------------------------ read/write/write
{  LW R3, R0, 8  |  SW D0, A0, 40  |  NOP  |  SW D0, A0, 44  |  NOP  }
;Reg[R3] = 0x0000_1111
;Mem[0x1207_40B8] = 0x1111_0000
;Mem[0x1207_40BC] = 0x2222_0000

;------------------------------------------------ write/read/write
{  SW R1, R0, 56  |  LW D2, A0, 8  |  NOP  |  SW D0, A0, 60  |  NOP  }
;Mem[0x1207_40C8] = 0x0000_1111
;Reg[D2] = 0x0000_1111
;Mem[0x1207_40CC] = 0x2222_0000

;------------------------------------------------ write/write/read
{  SW R1, R0, 72  |  SW D0, A0, 76  |  NOP  |  LW D2, A0, 28  |  NOP  }
;Mem[0x1207_40D8] = 0x0000_1111
;Mem[0x1207_40DC] = 0x1111_0000
;Reg[D2] = 0x2222_1111

;------------------------------------------------ read/read/write
{  LW R4, R0, 8  |  LW D3, A0, 24  |  NOP  |  SW D0, A0, 88  |  NOP  }
;Reg[R4] = 0x0000_1111
;Reg[D3] = 0x2222_0000
;Mem[0x1207_40E8] = 0x1111_0000

;------------------------------------------------ read/write/read
{  LW R5, R0, 8  |  SW D0, A0, 92  |  NOP  |  LW D3, A0, 24  |  NOP  }
;Reg[R5] = 0x0000_1111
;Mem[0x1207_40EC] = 0x1111_0000
;Reg[D3] = 0x2222_0000

;------------------------------------------------ write/read/read
{  SW R0, R0, 104  |  LW D4, A0, 12  |  NOP  |  LW D4, A0, 24  |  NOP  }
;Mem[0x1207_40F8] = 0x0000_1111
;Reg[D4] = 0x1111_0000
;Reg[D4] = 0x2222_0000

;------------------------------------------------ read/read/read
{  LW R6, R0, 8  |  LW D5, A0, 12  |  NOP  |  LW D5, A0, 24  |  NOP  }
;Reg[R6] = 0x0000_1111
;Reg[D5] = 0x1111_0000
;Reg[D5] = 0x2222_0000

;------------------------------------------------ store result
{  SW R3, R0, 108  |  SW D2, A0, 120  |  NOP  |  SW D2, A0, 124  |  NOP  }
;Mem[0x1207_40FC] = 0x0000_1111
;Mem[0x1207_4108] = 0x1111_0000
;Mem[0x1207_410C] = 0x2222_1111

{  SW R4, R0, 136  |  SW D3, A0, 140  |  NOP  |  SW D3, A0, 152  |  NOP  }
;Mem[0x1207_4118] = 0x0000_1111
;Mem[0x1207_411C] = 0x2222_0000
;Mem[0x1207_4128] = 0x2222_0000

{  SW R5, R0, 156  |  SW D4, A0, 168  |  NOP  |  SW D4, A0, 172  |  NOP  }
;Mem[0x1207_412C] = 0x0000_1111
;Mem[0x1207_4138] = 0x1111_0000
;Mem[0x1207_413C] = 0x2222_0000

{  SW R6, R0, 184  |  SW D5, A0, 188  |  NOP  |  SW D5, A0, 200  |  NOP  }
;Mem[0x1207_4148] = 0x0000_1111
;Mem[0x1207_414C] = 0x1111_0000
;Mem[0x1207_4158] = 0x2222_0000



;-------------------------------------------------------------- Two contentions in bank4
;Stalled for two cycl
{  MOVI.L R0, 0x8090  |  MOVI.L A0, 0x8090  |  NOP  |  MOVI.L A0, 0x8090  |  NOP  }
;Reg[R0] = 0x1207_8090
;Reg[A0] = 0x1207_8090
;Reg[A0] = 0x1207_8090

;------------------------------------------------ write/write/write
{  SW R1, R0, 0  |  SW D0, A0, 4  |  NOP  |  DSW D0, D1, A0, 16  |  NOP  }
;Mem[0x1207_8090] = 0x0000_1111
;Mem[0x1207_8094] = 0x1111_0000
;Mem[0x1207_80A0] = 0x2222_0000
;Mem[0x1207_80A4] = 0x2222_1111

;------------------------------------------------ read/write/write
{  LW R3, R0, 0  |  SW D0, A0, 32  |  NOP  |  SW D0, A0, 36  |  NOP  }
;Reg[R3] = 0x0000_1111
;Mem[0x1207_80B0] = 0x1111_0000
;Mem[0x1207_80B4] = 0x2222_0000

;------------------------------------------------ write/read/write
{  SW R1, R0, 48  |  LW D2, A0, 0  |  NOP  |  SW D0, A0, 52  |  NOP  }
;Mem[0x1207_80C0] = 0x0000_1111
;Reg[D2] = 0x0000_1111
;Mem[0x1207_80C4] = 0x2222_0000

;------------------------------------------------ write/write/read
{  SW R1, R0, 64  |  SW D0, A0, 68  |  NOP  |  LW D2, A0, 20  |  NOP  }
;Mem[0x1207_80D0] = 0x0000_1111
;Mem[0x1207_80D4] = 0x1111_0000
;Reg[D2] = 0x2222_1111

;------------------------------------------------ read/read/write
{  LW R4, R0, 0  |  LW D3, A0, 16  |  NOP  |  SW D0, A0, 80  |  NOP  }
;Reg[R4] = 0x0000_1111
;Reg[D3] = 0x2222_0000
;Mem[0x1207_80E0] = 0x1111_0000

;------------------------------------------------ read/write/read
{  LW R5, R0, 0  |  SW D0, A0, 84  |  NOP  |  LW D3, A0, 16  |  NOP  }
;Reg[R5] = 0x0000_1111
;Mem[0x1207_80E4] = 0x1111_0000
;Reg[D3] = 0x2222_0000

;------------------------------------------------ write/read/read
{  SW R0, R0, 96  |  LW D4, A0, 4  |  NOP  |  LW D4, A0, 16  |  NOP  }
;Mem[0x1207_80F0] = 0x0000_1111
;Reg[D4] = 0x1111_0000
;Reg[D4] = 0x2222_0000

;------------------------------------------------ read/read/read
{  LW R6, R0, 0  |  LW D5, A0, 4  |  NOP  |  LW D5, A0, 16  |  NOP  }
;Reg[R6] = 0x0000_1111
;Reg[D5] = 0x1111_0000
;Reg[D5] = 0x2222_0000

;------------------------------------------------ store result
{  SW R3, R0, 100  |  SW D2, A0, 112  |  NOP  |  SW D2, A0, 116  |  NOP  }
;Mem[0x1207_80F4] = 0x0000_1111
;Mem[0x1207_8100] = 0x1111_0000
;Mem[0x1207_8104] = 0x2222_1111

{  SW R4, R0, 128  |  SW D3, A0, 132  |  NOP  |  SW D3, A0, 144  |  NOP  }
;Mem[0x1207_8110] = 0x0000_1111
;Mem[0x1207_8114] = 0x2222_0000
;Mem[0x1207_8120] = 0x2222_0000

{  SW R5, R0, 148  |  SW D4, A0, 160  |  NOP  |  SW D4, A0, 164  |  NOP  }
;Mem[0x1207_8124] = 0x0000_1111
;Mem[0x1207_8130] = 0x1111_0000
;Mem[0x1207_8134] = 0x2222_0000

{  SW R6, R0, 176  |  SW D5, A0, 180  |  NOP  |  SW D5, A0, 192  |  NOP  }
;Mem[0x1207_8140] = 0x0000_1111
;Mem[0x1207_8144] = 0x1111_0000
;Mem[0x1207_8150] = 0x2222_0000



;//////////////////////////////////////// Interleaved mode///////////////////////////////////////////////////////
{  MOVI.L R2, 0x803C    |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R2, DMEM_BASE |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.L R3, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R3, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R3, R2, 0  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-interleaved mode
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



;********************************************************************* One contention

;-------------------------------------------------------------- One contention in bank0
;Stalled for one cycles
{  MOVI.L R0, 0x00B0  |  MOVI.L A0, 0x00B0  |  NOP  |  MOVI.L A0, 0x00B0  |  NOP  }

;Reg[R0] = 0x1207_00B0
;Reg[A0] = 0x1207_00B0
;Reg[A0] = 0x1207_00B0

;------------------------------------------------ write/write
{  SW R1, R0, 0  |  SW D0, A0, 4  |  NOP  |  NOP  |  NOP  }
;Mem[0x1207_00B0] = 0x0000_1111
;Mem[0x1207_00B4] = 0x1111_0000

{  SW R2, R0, 8  |  NOP  |  NOP  |  SW D0, A0, 12  |  NOP  }
;Mem[0x1207_00B8] = 0x0000_2222
;Mem[0x1207_00BC] = 0x2222_0000

{  NOP  |  SW D0, A0, 16  |  NOP  |  SW D0, A0, 20  |  NOP  }
;Mem[0x1207_00C0] = 0x1111_0000
;Mem[0x1207_00C4] = 0x2222_0000

;------------------------------------------------ read/write
{  LW R3, R0, 0  |  SW D0, A0, 24  |  NOP  |  NOP  |  NOP  }
;Reg[R3] = 0x0000_1111
;Mem[0x1207_00C8] = 0x1111_0000

{  SW R2, R0, 28  |  NOP  |  NOP  |  LW D2, A0, 20  |  NOP  }
;Mem[0x1207_00CC] = 0x0000_2222
;C1:Reg[D2] = 0x2222_0000

{  NOP  |  LW D2, A0, 16  |  NOP  |  SW D0, A0, 32  |  NOP  }
;C2:Reg[D2] = 0x1111_0000
;Mem[0x1207_00D0] = 0x2222_0000

;------------------------------------------------ read/read
{  LW R4, R0, 0  |  LW D3, A0, 4  |  NOP  |  NOP  |  NOP  }
;Reg[R4] = 0x0000_1111
;C1:Reg[D3] = 0x1111_0000

{  LW R5, R0, 16  |  NOP  |  NOP  |  LW D3, A0, 12  |  NOP  }
;Reg[R5] = 0x0000_2222
;C2:Reg[D3] = 0x2222_0000

{  NOP  |  LW D4, A0, 16  |  NOP  |  LW D4, A0, 20  |  NOP  }
;C1:Reg[D4] = 0x1111_0000
;C2:Reg[D4] = 0x2222_0000

;------------------------------------------------ store result
{  SW R3, R0, 36  |  SW D2, A0, 40  |  NOP  |  SW D2, A0, 44  |  NOP  }
;Mem[0x1207_00D4] = 0x0000_1111
;Mem[0x1207_00D8] = 0x2222_0000
;Mem[0x1207_00DC] = 0x1111_0000

{  SW R4, R0, 48  |  SW D3, A0, 52  |  NOP  |  SW D3, A0, 56  |  NOP  }
;Mem[0x1207_00E0] = 0x0000_1111
;Mem[0x1207_00E4] = 0x1111_0000
;Mem[0x1207_00E8] = 0x2222_0000

{  SW R5, R0, 60  |  SW D4, A0, 64  |  NOP  |  SW D4, A0, 68  |  NOP  }
;Mem[0x1207_00EC] = 0x0000_2222
;Mem[0x1207_00F0] = 0x1111_0000
;Mem[0x1207_00F4] = 0x2222_0000

;-------------------------------------------------------------- One contention in bank1
;Stalled for one cycles
{  MOVI.L R0, 0x20B0  |  MOVI.L A0, 0x20B0  |  NOP  |  MOVI.L A0, 0x20B0  |  NOP  }

;Reg[R0] = 0x1207_20B0
;Reg[A0] = 0x1207_20B0
;Reg[A0] = 0x1207_20B0

;------------------------------------------------ write/write
{  SW R1, R0, 0  |  SW D0, A0, 4  |  NOP  |  NOP  |  NOP  }
;Mem[0x1207_20B0] = 0x0000_1111
;Mem[0x1207_20B4] = 0x1111_0000

{  SW R2, R0, 8  |  NOP  |  NOP  |  SW D0, A0, 12  |  NOP  }
;Mem[0x1207_20B8] = 0x0000_2222
;Mem[0x1207_20BC] = 0x2222_0000

{  NOP  |  SW D0, A0, 16  |  NOP  |  SW D0, A0, 20  |  NOP  }
;Mem[0x1207_20C0] = 0x1111_0000
;Mem[0x1207_20C4] = 0x2222_0000

;------------------------------------------------ read/write
{  LW R3, R0, 8  |  SW D0, A0, 24  |  NOP  |  NOP  |  NOP  }
;Reg[R3] = 0x0000_1111
;Mem[0x1207_20C8] = 0x1111_0000

{  SW R2, R0, 28  |  NOP  |  NOP  |  LW D2, A0, 12  |  NOP  }
;Mem[0x1207_20CC] = 0x0000_2222
;C1:Reg[D2] = 0x2222_0000

{  NOP  |  LW D2, A0, 16  |  NOP  |  SW D0, A0, 32  |  NOP  }
;C2:Reg[D2] = 0x1111_0000
;Mem[0x1207_20D0] = 0x2222_0000

;------------------------------------------------ read/read
{  LW R4, R0, 0  |  LW D3, A0, 4  |  NOP  |  NOP  |  NOP  }
;Reg[R4] = 0x0000_1111
;C1:Reg[D3] = 0x1111_0000

{  LW R5, R0, 8  |  NOP  |  NOP  |  LW D3, A0, 12  |  NOP  }
;Reg[R5] = 0x0000_2222
;C2:Reg[D3] = 0x2222_0000

{  NOP  |  LW D4, A0, 16  |  NOP  |  LW D4, A0, 20  |  NOP  }
;C1:Reg[D4] = 0x1111_0000
;C2:Reg[D4] = 0x2222_0000

;------------------------------------------------ store result
{  SW R3, R0, 36  |  SW D2, A0, 40  |  NOP  |  SW D2, A0, 44  |  NOP  }
;Mem[0x1207_20D4] = 0x0000_1111
;Mem[0x1207_20D8] = 0x2222_0000
;Mem[0x1207_20DC] = 0x1111_0000

{  SW R4, R0, 48  |  SW D3, A0, 52  |  NOP  |  SW D3, A0, 56  |  NOP  }
;Mem[0x1207_20E0] = 0x0000_1111
;Mem[0x1207_20E4] = 0x1111_0000
;Mem[0x1207_20E8] = 0x2222_0000

{  SW R5, R0, 60  |  SW D4, A0, 64  |  NOP  |  SW D4, A0, 68  |  NOP  }
;Mem[0x1207_20EC] = 0x0000_2222
;Mem[0x1207_20F0] = 0x1111_0000
;Mem[0x1207_20F4] = 0x2222_0000


;-------------------------------------------------------------- One contention in bank2
;Stalled for one cycles
{  MOVI.L R0, 0x40B0  |  MOVI.L A0, 0x40B0  |  NOP  |  MOVI.L A0, 0x40B0  |  NOP  }

;Reg[R0] = 0x1207_40B0
;Reg[A0] = 0x1207_40B0
;Reg[A0] = 0x1207_40B0

;------------------------------------------------ write/write
{  SW R1, R0, 0  |  SW D0, A0, 4  |  NOP  |  NOP  |  NOP  }
;Mem[0x1207_40B0] = 0x0000_1111
;Mem[0x1207_40B4] = 0x1111_0000

{  SW R2, R0, 8  |  NOP  |  NOP  |  SW D0, A0, 12  |  NOP  }
;Mem[0x1207_40B8] = 0x0000_2222
;Mem[0x1207_40BC] = 0x2222_0000

{  NOP  |  SW D0, A0, 16  |  NOP  |  SW D0, A0, 20  |  NOP  }
;Mem[0x1207_40C0] = 0x1111_0000
;Mem[0x1207_40C4] = 0x2222_0000

;------------------------------------------------ read/write
{  LW R3, R0, 8  |  SW D0, A0, 24  |  NOP  |  NOP  |  NOP  }
;Reg[R3] = 0x0000_1111
;Mem[0x1207_40C8] = 0x1111_0000

{  SW R2, R0, 28  |  NOP  |  NOP  |  LW D2, A0, 12  |  NOP  }
;Mem[0x1207_40CC] = 0x0000_2222
;C1:Reg[D2] = 0x2222_0000

{  NOP  |  LW D2, A0, 16  |  NOP  |  SW D0, A0, 32  |  NOP  }
;C2:Reg[D2] = 0x1111_0000
;Mem[0x1207_40D0] = 0x2222_0000

;------------------------------------------------ read/read
{  LW R4, R0, 0  |  LW D3, A0, 4  |  NOP  |  NOP  |  NOP  }
;Reg[R4] = 0x0000_1111
;C1:Reg[D3] = 0x1111_0000

{  LW R5, R0, 8  |  NOP  |  NOP  |  LW D3, A0, 12  |  NOP  }
;Reg[R5] = 0x0000_2222
;C2:Reg[D3] = 0x2222_0000

{  NOP  |  LW D4, A0, 16  |  NOP  |  LW D4, A0, 20  |  NOP  }
;C1:Reg[D4] = 0x1111_0000
;C2:Reg[D4] = 0x2222_0000

;------------------------------------------------ store result
{  SW R3, R0, 36  |  SW D2, A0, 40  |  NOP  |  SW D2, A0, 44  |  NOP  }
;Mem[0x1207_40D4] = 0x0000_1111
;Mem[0x1207_40D8] = 0x2222_0000
;Mem[0x1207_40DC] = 0x1111_0000

{  SW R4, R0, 48  |  SW D3, A0, 52  |  NOP  |  SW D3, A0, 56  |  NOP  }
;Mem[0x1207_40E0] = 0x0000_1111
;Mem[0x1207_40E4] = 0x1111_0000
;Mem[0x1207_40E8] = 0x2222_0000

{  SW R5, R0, 60  |  SW D4, A0, 64  |  NOP  |  SW D4, A0, 68  |  NOP  }
;Mem[0x1207_40EC] = 0x0000_2222
;Mem[0x1207_40F0] = 0x1111_0000
;Mem[0x1207_40F4] = 0x2222_0000


;-------------------------------------------------------------- One contention in bank3
;Stalled for one cycles
{  MOVI.L R0, 0x60B0  |  MOVI.L A0, 0x60B0  |  NOP  |  MOVI.L A0, 0x60B0  |  NOP  }

;Reg[R0] = 0x1207_60B0
;Reg[A0] = 0x1207_60B0
;Reg[A0] = 0x1207_60B0

;------------------------------------------------ write/write
{  SW R1, R0, 0  |  SW D0, A0, 4  |  NOP  |  NOP  |  NOP  }
;Mem[0x1207_60B0] = 0x0000_1111
;Mem[0x1207_60B4] = 0x1111_0000

{  SW R2, R0, 8  |  NOP  |  NOP  |  SW D0, A0, 12  |  NOP  }
;Mem[0x1207_60B8] = 0x0000_2222
;Mem[0x1207_60BC] = 0x2222_0000

{  NOP  |  SW D0, A0, 16  |  NOP  |  SW D0, A0, 20  |  NOP  }
;Mem[0x1207_60C0] = 0x1111_0000
;Mem[0x1207_60C4] = 0x2222_0000

;------------------------------------------------ read/write
{  LW R3, R0, 8  |  SW D0, A0, 24  |  NOP  |  NOP  |  NOP  }
;Reg[R3] = 0x0000_1111
;Mem[0x1207_60C8] = 0x1111_0000

{  SW R2, R0, 28  |  NOP  |  NOP  |  LW D2, A0, 12  |  NOP  }
;Mem[0x1207_60CC] = 0x0000_2222
;C1:Reg[D2] = 0x2222_0000

{  NOP  |  LW D2, A0, 16  |  NOP  |  SW D0, A0, 32  |  NOP  }
;C2:Reg[D2] = 0x1111_0000
;Mem[0x1207_60D0] = 0x2222_0000

;------------------------------------------------ read/read
{  LW R4, R0, 0  |  LW D3, A0, 4  |  NOP  |  NOP  |  NOP  }
;Reg[R4] = 0x0000_1111
;C1:Reg[D3] = 0x1111_0000

{  LW R5, R0, 8  |  NOP  |  NOP  |  LW D3, A0, 12  |  NOP  }
;Reg[R5] = 0x0000_2222
;C2:Reg[D3] = 0x2222_0000

{  NOP  |  LW D4, A0, 16  |  NOP  |  LW D4, A0, 20  |  NOP  }
;C1:Reg[D4] = 0x1111_0000
;C2:Reg[D4] = 0x2222_0000

;------------------------------------------------ store result
{  SW R3, R0, 36  |  SW D2, A0, 40  |  NOP  |  SW D2, A0, 44  |  NOP  }
;Mem[0x1207_60D4] = 0x0000_1111
;Mem[0x1207_60D8] = 0x2222_0000
;Mem[0x1207_60DC] = 0x1111_0000

{  SW R4, R0, 48  |  SW D3, A0, 52  |  NOP  |  SW D3, A0, 56  |  NOP  }
;Mem[0x1207_60E0] = 0x0000_1111
;Mem[0x1207_60E4] = 0x1111_0000
;Mem[0x1207_60E8] = 0x2222_0000

{  SW R5, R0, 60  |  SW D4, A0, 64  |  NOP  |  SW D4, A0, 68  |  NOP  }
;Mem[0x1207_60EC] = 0x0000_2222
;Mem[0x1207_60F0] = 0x1111_0000
;Mem[0x1207_60F4] = 0x2222_0000





;********************************************************************* Two contentions

;-------------------------------------------------------------- Two contentions in bank0
;Stalled for two cycles
{  MOVI.L R0, 0x00F8  |  MOVI.L A0, 0x00F8  |  NOP  |  MOVI.L A0, 0x00F8  |  NOP  }
;Reg[R0] = 0x1207_00F8
;Reg[A0] = 0x1207_00F8
;Reg[A0] = 0x1207_00F8

;------------------------------------------------ write/write/write
{  SW R1, R0, 0  |  SW D0, A0, 4  |  NOP  |  DSW D0, D1, A0, 8  |  NOP  }
;Mem[0x1207_00F8] = 0x0000_1111
;Mem[0x1207_00FC] = 0x1111_0000
;Mem[0x1207_0100] = 0x2222_0000
;Mem[0x1207_0104] = 0x2222_1111

;------------------------------------------------ read/write/write
{  LW R3, R0, 0  |  SW D0, A0, 16  |  NOP  |  SW D0, A0, 20  |  NOP  }
;Reg[R3] = 0x0000_1111
;Mem[0x1207_0108] = 0x1111_0000
;Mem[0x1207_010C] = 0x2222_0000

;------------------------------------------------ write/read/write
{  SW R1, R0, 24  |  LW D2, A0, 0  |  NOP  |  SW D0, A0, 28  |  NOP  }
;Mem[0x1207_0110] = 0x0000_1111
;Reg[D2] = 0x0000_1111
;Mem[0x1207_0114] = 0x2222_0000

;------------------------------------------------ write/write/read
{  SW R1, R0, 32  |  SW D0, A0, 36  |  NOP  |  LW D2, A0, 12  |  NOP  }
;Mem[0x1207_0118] = 0x0000_1111
;Mem[0x1207_011C] = 0x1111_0000
;Reg[D2] = 0x2222_1111

;------------------------------------------------ read/read/write
{  LW R4, R0, 0  |  LW D3, A0, 4  |  NOP  |  SW D0, A0, 40  |  NOP  }
;Reg[R4] = 0x0000_1111
;Reg[D3] = 0x2222_0000
;Mem[0x1207_0120] = 0x1111_0000

;------------------------------------------------ read/write/read
{  LW R5, R0, 0  |  SW D0, A0, 44  |  NOP  |  LW D3, A0, 8  |  NOP  }
;Reg[R5] = 0x0000_1111
;Mem[0x1207_0124] = 0x1111_0000
;Reg[D3] = 0x2222_0000

;------------------------------------------------ write/read/read
{  SW R0, R0, 48  |  LW D4, A0, 4  |  NOP  |  LW D4, A0, 8  |  NOP  }
;Mem[0x1207_0128] = 0x0000_1111
;Reg[D4] = 0x1111_0000
;Reg[D4] = 0x2222_0000

;------------------------------------------------ read/read/read
{  LW R6, R0, 0  |  LW D5, A0, 4  |  NOP  |  LW D5, A0, 8  |  NOP  }
;Reg[R6] = 0x0000_1111
;Reg[D5] = 0x1111_0000
;Reg[D5] = 0x2222_0000

;------------------------------------------------ store result
{  SW R3, R0, 52  |  SW D2, A0, 56  |  NOP  |  SW D2, A0, 60  |  NOP  }
;Mem[0x1207_012C] = 0x0000_1111
;Mem[0x1207_0130] = 0x1111_0000
;Mem[0x1207_0134] = 0x2222_1111

{  SW R4, R0, 64  |  SW D3, A0, 68  |  NOP  |  SW D3, A0, 72  |  NOP  }
;Mem[0x1207_0138] = 0x0000_1111
;Mem[0x1207_013C] = 0x2222_0000
;Mem[0x1207_0140] = 0x2222_0000

{  SW R5, R0, 76  |  SW D4, A0, 80  |  NOP  |  SW D4, A0, 84  |  NOP  }
;Mem[0x1207_0144] = 0x0000_1111
;Mem[0x1207_0148] = 0x1111_0000
;Mem[0x1207_014C] = 0x2222_0000

{  SW R6, R0, 88  |  SW D5, A0, 92  |  NOP  |  SW D5, A0, 96  |  NOP  }
;Mem[0x1207_0150] = 0x0000_1111
;Mem[0x1207_0154] = 0x1111_0000
;Mem[0x1207_0158] = 0x2222_0000


;-------------------------------------------------------------- Two contentions in bank1
;Stalled for two cycles
{  MOVI.L R0, 0x20F8  |  MOVI.L A0, 0x20F8  |  NOP  |  MOVI.L A0, 0x20F8  |  NOP  }
;Reg[R0] = 0x1207_20F8
;Reg[A0] = 0x1207_20F8
;Reg[A0] = 0x1207_20F8

;------------------------------------------------ write/write/write
{  SW R1, R0, 0  |  SW D0, A0, 4  |  NOP  |  DSW D0, D1, A0, 8  |  NOP  }
;Mem[0x1207_20F8] = 0x0000_1111
;Mem[0x1207_20FC] = 0x1111_0000
;Mem[0x1207_2100] = 0x2222_0000
;Mem[0x1207_2104] = 0x2222_1111

;------------------------------------------------ read/write/write
{  LW R3, R0, 0  |  SW D0, A0, 16  |  NOP  |  SW D0, A0, 20  |  NOP  }
;Reg[R3] = 0x0000_1111
;Mem[0x1207_2108] = 0x1111_0000
;Mem[0x1207_210C] = 0x2222_0000

;------------------------------------------------ write/read/write
{  SW R1, R0, 24  |  LW D2, A0, 0  |  NOP  |  SW D0, A0, 28  |  NOP  }
;Mem[0x1207_2110] = 0x0000_1111
;Reg[D2] = 0x0000_1111
;Mem[0x1207_2114] = 0x2222_0000

;------------------------------------------------ write/write/read
{  SW R1, R0, 32  |  SW D0, A0, 36  |  NOP  |  LW D2, A0, 12  |  NOP  }
;Mem[0x1207_2118] = 0x0000_1111
;Mem[0x1207_211C] = 0x1111_0000
;Reg[D2] = 0x2222_1111

;------------------------------------------------ read/read/write
{  LW R4, R0, 0  |  LW D3, A0, 4  |  NOP  |  SW D0, A0, 40  |  NOP  }
;Reg[R4] = 0x0000_1111
;Reg[D3] = 0x2222_0000
;Mem[0x1207_2120] = 0x1111_0000

;------------------------------------------------ read/write/read
{  LW R5, R0, 0  |  SW D0, A0, 44  |  NOP  |  LW D3, A0, 8  |  NOP  }
;Reg[R5] = 0x0000_1111
;Mem[0x1207_2124] = 0x1111_0000
;Reg[D3] = 0x2222_0000

;------------------------------------------------ write/read/read
{  SW R0, R0, 48  |  LW D4, A0, 4  |  NOP  |  LW D4, A0, 8  |  NOP  }
;Mem[0x1207_2128] = 0x0000_1111
;Reg[D4] = 0x1111_0000
;Reg[D4] = 0x2222_0000

;------------------------------------------------ read/read/read
{  LW R6, R0, 0  |  LW D5, A0, 4  |  NOP  |  LW D5, A0, 8  |  NOP  }
;Reg[R6] = 0x0000_1111
;Reg[D5] = 0x1111_0000
;Reg[D5] = 0x2222_0000

;------------------------------------------------ store result
{  SW R3, R0, 52  |  SW D2, A0, 56  |  NOP  |  SW D2, A0, 60  |  NOP  }
;Mem[0x1207_212C] = 0x0000_1111
;Mem[0x1207_2130] = 0x1111_0000
;Mem[0x1207_2134] = 0x2222_1111

{  SW R4, R0, 64  |  SW D3, A0, 68  |  NOP  |  SW D3, A0, 72  |  NOP  }
;Mem[0x1207_2138] = 0x0000_1111
;Mem[0x1207_213C] = 0x2222_0000
;Mem[0x1207_2140] = 0x2222_0000

{  SW R5, R0, 76  |  SW D4, A0, 80  |  NOP  |  SW D4, A0, 84  |  NOP  }
;Mem[0x1207_2144] = 0x0000_1111
;Mem[0x1207_2148] = 0x1111_0000
;Mem[0x1207_214C] = 0x2222_0000

{  SW R6, R0, 88  |  SW D5, A0, 92  |  NOP  |  SW D5, A0, 96  |  NOP  }
;Mem[0x1207_2150] = 0x0000_1111
;Mem[0x1207_2154] = 0x1111_0000
;Mem[0x1207_2158] = 0x2222_0000


;-------------------------------------------------------------- Two contentions in bank2
;Stalled for two cycles
{  MOVI.L R0, 0x40F8  |  MOVI.L A0, 0x40F8  |  NOP  |  MOVI.L A0, 0x40F8  |  NOP  }
;Reg[R0] = 0x1207_40F8
;Reg[A0] = 0x1207_40F8
;Reg[A0] = 0x1207_40F8

;------------------------------------------------ write/write/write
{  SW R1, R0, 0  |  SW D0, A0, 4  |  NOP  |  DSW D0, D1, A0, 8  |  NOP  }
;Mem[0x1207_40F8] = 0x0000_1111
;Mem[0x1207_40FC] = 0x1111_0000
;Mem[0x1207_4100] = 0x2222_0000
;Mem[0x1207_4104] = 0x2222_1111

;------------------------------------------------ read/write/write
{  LW R3, R0, 0  |  SW D0, A0, 16  |  NOP  |  SW D0, A0, 20  |  NOP  }
;Reg[R3] = 0x0000_1111
;Mem[0x1207_4108] = 0x1111_0000
;Mem[0x1207_410C] = 0x2222_0000

;------------------------------------------------ write/read/write
{  SW R1, R0, 24  |  LW D2, A0, 0  |  NOP  |  SW D0, A0, 28  |  NOP  }
;Mem[0x1207_4110] = 0x0000_1111
;Reg[D2] = 0x0000_1111
;Mem[0x1207_4114] = 0x2222_0000

;------------------------------------------------ write/write/read
{  SW R1, R0, 32  |  SW D0, A0, 36  |  NOP  |  LW D2, A0, 12  |  NOP  }
;Mem[0x1207_4118] = 0x0000_1111
;Mem[0x1207_411C] = 0x1111_0000
;Reg[D2] = 0x2222_1111

;------------------------------------------------ read/read/write
{  LW R4, R0, 0  |  LW D3, A0, 4  |  NOP  |  SW D0, A0, 40  |  NOP  }
;Reg[R4] = 0x0000_1111
;Reg[D3] = 0x2222_0000
;Mem[0x1207_4120] = 0x1111_0000

;------------------------------------------------ read/write/read
{  LW R5, R0, 0  |  SW D0, A0, 44  |  NOP  |  LW D3, A0, 8  |  NOP  }
;Reg[R5] = 0x0000_1111
;Mem[0x1207_4124] = 0x1111_0000
;Reg[D3] = 0x2222_0000

;------------------------------------------------ write/read/read
{  SW R0, R0, 48  |  LW D4, A0, 4  |  NOP  |  LW D4, A0, 8  |  NOP  }
;Mem[0x1207_4128] = 0x0000_1111
;Reg[D4] = 0x1111_0000
;Reg[D4] = 0x2222_0000

;------------------------------------------------ read/read/read
{  LW R6, R0, 0  |  LW D5, A0, 4  |  NOP  |  LW D5, A0, 8  |  NOP  }
;Reg[R6] = 0x0000_1111
;Reg[D5] = 0x1111_0000
;Reg[D5] = 0x2222_0000

;------------------------------------------------ store result
{  SW R3, R0, 52  |  SW D2, A0, 56  |  NOP  |  SW D2, A0, 60  |  NOP  }
;Mem[0x1207_412C] = 0x0000_1111
;Mem[0x1207_4130] = 0x1111_0000
;Mem[0x1207_4134] = 0x2222_1111

{  SW R4, R0, 64  |  SW D3, A0, 68  |  NOP  |  SW D3, A0, 72  |  NOP  }
;Mem[0x1207_4138] = 0x0000_1111
;Mem[0x1207_413C] = 0x2222_0000
;Mem[0x1207_4140] = 0x2222_0000

{  SW R5, R0, 76  |  SW D4, A0, 80  |  NOP  |  SW D4, A0, 84  |  NOP  }
;Mem[0x1207_4144] = 0x0000_1111
;Mem[0x1207_4148] = 0x1111_0000
;Mem[0x1207_414C] = 0x2222_0000

{  SW R6, R0, 88  |  SW D5, A0, 92  |  NOP  |  SW D5, A0, 96  |  NOP  }
;Mem[0x1207_4150] = 0x0000_1111
;Mem[0x1207_4154] = 0x1111_0000
;Mem[0x1207_4158] = 0x2222_0000


;-------------------------------------------------------------- Two contentions in bank3
;Stalled for two cycles
{  MOVI.L R0, 0x60F8  |  MOVI.L A0, 0x60F8  |  NOP  |  MOVI.L A0, 0x60F8  |  NOP  }
;Reg[R0] = 0x1207_60F8
;Reg[A0] = 0x1207_60F8
;Reg[A0] = 0x1207_60F8

;------------------------------------------------ write/write/write
{  SW R1, R0, 0  |  SW D0, A0, 4  |  NOP  |  DSW D0, D1, A0, 8  |  NOP  }
;Mem[0x1207_60F8] = 0x0000_1111
;Mem[0x1207_60FC] = 0x1111_0000
;Mem[0x1207_6100] = 0x2222_0000
;Mem[0x1207_6104] = 0x2222_1111

;------------------------------------------------ read/write/write
{  LW R3, R0, 0  |  SW D0, A0, 16  |  NOP  |  SW D0, A0, 20  |  NOP  }
;Reg[R3] = 0x0000_1111
;Mem[0x1207_6108] = 0x1111_0000
;Mem[0x1207_610C] = 0x2222_0000

;------------------------------------------------ write/read/write
{  SW R1, R0, 24  |  LW D2, A0, 0  |  NOP  |  SW D0, A0, 28  |  NOP  }
;Mem[0x1207_6110] = 0x0000_1111
;Reg[D2] = 0x0000_1111
;Mem[0x1207_6114] = 0x2222_0000

;------------------------------------------------ write/write/read
{  SW R1, R0, 32  |  SW D0, A0, 36  |  NOP  |  LW D2, A0, 12  |  NOP  }
;Mem[0x1207_6118] = 0x0000_1111
;Mem[0x1207_611C] = 0x1111_0000
;Reg[D2] = 0x2222_1111

;------------------------------------------------ read/read/write
{  LW R4, R0, 0  |  LW D3, A0, 4  |  NOP  |  SW D0, A0, 40  |  NOP  }
;Reg[R4] = 0x0000_1111
;Reg[D3] = 0x2222_0000
;Mem[0x1207_6120] = 0x1111_0000

;------------------------------------------------ read/write/read
{  LW R5, R0, 0  |  SW D0, A0, 44  |  NOP  |  LW D3, A0, 8  |  NOP  }
;Reg[R5] = 0x0000_1111
;Mem[0x1207_6124] = 0x1111_0000
;Reg[D3] = 0x2222_0000

;------------------------------------------------ write/read/read
{  SW R0, R0, 48  |  LW D4, A0, 4  |  NOP  |  LW D4, A0, 8  |  NOP  }
;Mem[0x1207_6128] = 0x0000_1111
;Reg[D4] = 0x1111_0000
;Reg[D4] = 0x2222_0000

;------------------------------------------------ read/read/read
{  LW R6, R0, 0  |  LW D5, A0, 4  |  NOP  |  LW D5, A0, 8  |  NOP  }
;Reg[R6] = 0x0000_1111
;Reg[D5] = 0x1111_0000
;Reg[D5] = 0x2222_0000

;------------------------------------------------ store result
{  SW R3, R0, 52  |  SW D2, A0, 56  |  NOP  |  SW D2, A0, 60  |  NOP  }
;Mem[0x1207_612C] = 0x0000_1111
;Mem[0x1207_6130] = 0x1111_0000
;Mem[0x1207_6134] = 0x2222_1111

{  SW R4, R0, 64  |  SW D3, A0, 68  |  NOP  |  SW D3, A0, 72  |  NOP  }
;Mem[0x1207_6138] = 0x0000_1111
;Mem[0x1207_613C] = 0x2222_0000
;Mem[0x1207_6140] = 0x2222_0000

{  SW R5, R0, 76  |  SW D4, A0, 80  |  NOP  |  SW D4, A0, 84  |  NOP  }
;Mem[0x1207_6144] = 0x0000_1111
;Mem[0x1207_6148] = 0x1111_0000
;Mem[0x1207_614C] = 0x2222_0000

{  SW R6, R0, 88  |  SW D5, A0, 92  |  NOP  |  SW D5, A0, 96  |  NOP  }
;Mem[0x1207_6150] = 0x0000_1111
;Mem[0x1207_6154] = 0x1111_0000
;Mem[0x1207_6158] = 0x2222_0000



;************************************************************** Program Terminate


;************************************************************** DMA
;****************************************************** Interleave mode
	{  MOVI.L R2, 0x803C    |  NOP  |  NOP  |  NOP  |  NOP  }
	{  MOVI.H R2, DMEM_BASE |  NOP  |  NOP  |  NOP  |  NOP  }
	{  MOVI.L R3, 0x0001  |  NOP  |  NOP  |  NOP  |  NOP  }
	{  MOVI.H R3, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
	{  SW R3, R2, 0  |  NOP  |  NOP  |  NOP  |  NOP  }
; Interleaved
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

; Set DMA 0x80000000 -> 0x90000000  1C200 words
	{  MOVI R0, DMA_SAR_ADDR0	|  NOP  |  NOP  |  NOP  |  NOP  }	
    
	{  MOVI R1, 0x24000000		|  NOP  |  NOP  |  NOP  |  NOP  }	
	{  SW R1, R0, 4+   			  |  NOP  |  NOP  |  NOP  |  NOP  }
    
	{  MOVI R1, 0x30000000		|  NOP  |  NOP  |  NOP  |  NOP  }	
	{  SW R1, R0, 4+   			  |  NOP  |  NOP  |  NOP  |  NOP  }
    
	{  MOVI R1, 0x00000000		|  NOP  |  NOP  |  NOP  |  NOP  }	
	{  SW R1, R0, 4+   	  		|  NOP  |  NOP  |  NOP  |  NOP  }
    
	{  MOVI R1, 0x00000000		|  NOP  |  NOP  |  NOP  |  NOP  }	
	{  SW R1, R0, 4+   		  	|  NOP  |  NOP  |  NOP  |  NOP  }
    
	{  MOVI R1, 0x0016000E	  |  NOP  |  NOP  |  NOP  |  NOP  }	 ; BSZ[31:20], DSEN[9], SGEN[8], Int2Ext[3], Burst[2], TRZ[1:0], for 7056 DSP DMA
	{  SW R1, R0, 4+   			  |  NOP  |  NOP  |  NOP  |  NOP  }
    
	;{  MOVI R1, 0x00000001		|  NOP  |  NOP  |  NOP  |  NOP  }	 ; mark by JH
	;{  SW R1, R0, 4+   			|  NOP  |  NOP  |  NOP  |  NOP  }  ; mark by JH
	
	{  MOVI R0, DMA_SAR_ADDR1	|  NOP  |  NOP  |  NOP  |  NOP  }	
    
	{  MOVI R1, 0x24004000		|  NOP  |  NOP  |  NOP  |  NOP  }	
	{  SW R1, R0, 4+   			  |  NOP  |  NOP  |  NOP  |  NOP  }
    
	{  MOVI R1, 0x30004000		|  NOP  |  NOP  |  NOP  |  NOP  }	
	{  SW R1, R0, 4+   		  	|  NOP  |  NOP  |  NOP  |  NOP  }
    
	{  MOVI R1, 0x00000000		|  NOP  |  NOP  |  NOP  |  NOP  }	
	{  SW R1, R0, 4+   			  |  NOP  |  NOP  |  NOP  |  NOP  }
    
	{  MOVI R1, 0x00000000		|  NOP  |  NOP  |  NOP  |  NOP  }	
	{  SW R1, R0, 4+   			  |  NOP  |  NOP  |  NOP  |  NOP  }
    
	{  MOVI R1, 0x0016000E		|  NOP  |  NOP  |  NOP  |  NOP  }	 ; BSZ[31:20], DSEN[9], SGEN[8], Int2Ext[3], Burst[2], TRZ[1:0], for 7056 DSP DMA
	{  SW R1, R0, 4+   			  |  NOP  |  NOP  |  NOP  |  NOP  }
    
	;{  MOVI R1, 0x00000001		|  NOP  |  NOP  |  NOP  |  NOP  }	 ; mark by JH
	;{  SW R1, R0, 4+   			|  NOP  |  NOP  |  NOP  |  NOP  }  ; mark by JH
	
	{  MOVI R0, DMA_SAR_ADDR2	|  NOP  |  NOP  |  NOP  |  NOP  }	
    
	{  MOVI R1, 0x24008000		|  NOP  |  NOP  |  NOP  |  NOP  }	
	{  SW R1, R0, 4+   			  |  NOP  |  NOP  |  NOP  |  NOP  }
    
	{  MOVI R1, 0x30008000		|  NOP  |  NOP  |  NOP  |  NOP  }	
	{  SW R1, R0, 4+   			  |  NOP  |  NOP  |  NOP  |  NOP  }
    
	{  MOVI R1, 0x00000000		|  NOP  |  NOP  |  NOP  |  NOP  }	
	{  SW R1, R0, 4+   			  |  NOP  |  NOP  |  NOP  |  NOP  }
    
	{  MOVI R1, 0x00000000		|  NOP  |  NOP  |  NOP  |  NOP  }	
	{  SW R1, R0, 4+   			  |  NOP  |  NOP  |  NOP  |  NOP  }
    
	{  MOVI R1, 0x0016000E		|  NOP  |  NOP  |  NOP  |  NOP  }	; BSZ[31:20], DSEN[9], SGEN[8], Int2Ext[3], Burst[2], TRZ[1:0], for 7056 DSP DMA
	{  SW R1, R0, 4+   		  	|  NOP  |  NOP  |  NOP  |  NOP  }
    
	;{  MOVI R1, 0x00000001		|  NOP  |  NOP  |  NOP  |  NOP  }	; mark by JH
	;{  SW R1, R0, 4+   			|  NOP  |  NOP  |  NOP  |  NOP  } ; mark by JH
	
	{  MOVI R0, DMA_SAR_ADDR3	|  NOP  |  NOP  |  NOP  |  NOP  }	
    
	{  MOVI R1, 0x2400C000		|  NOP  |  NOP  |  NOP  |  NOP  }	
	{  SW R1, R0, 4+   			  |  NOP  |  NOP  |  NOP  |  NOP  }
    
	{  MOVI R1, 0x3000C000		|  NOP  |  NOP  |  NOP  |  NOP  }	
	{  SW R1, R0, 4+   			  |  NOP  |  NOP  |  NOP  |  NOP  }
    
	{  MOVI R1, 0x00000000		|  NOP  |  NOP  |  NOP  |  NOP  }	
	{  SW R1, R0, 4+   			  |  NOP  |  NOP  |  NOP  |  NOP  }
    
	{  MOVI R1, 0x00000000		|  NOP  |  NOP  |  NOP  |  NOP  }	
	{  SW R1, R0, 4+   		  	|  NOP  |  NOP  |  NOP  |  NOP  }
    
	{  MOVI R1, 0x0016000E		|  NOP  |  NOP  |  NOP  |  NOP  }	; BSZ[31:20], DSEN[9], SGEN[8], Int2Ext[3], Burst[2], TRZ[1:0], for 7056 DSP DMA
	{  SW R1, R0, 4+   		  	|  NOP  |  NOP  |  NOP  |  NOP  }
    
	{  MOVI R1, 0x00000001		|  NOP  |  NOP  |  NOP  |  NOP  }	
	;{  SW R1, R0, 4+   			|  NOP  |  NOP  |  NOP  |  NOP  }  ; mark by JH
	
	; add by JH, enable DMA together
	{  MOVI R0, DMA_ENA_ADDR0 |  NOP  |  NOP  |  NOP  |  NOP  }
	{  SW R1, R0, 0      			|  NOP  |  NOP  |  NOP  |  NOP  }
	{  MOVI R0, DMA_ENA_ADDR1	|  NOP  |  NOP  |  NOP  |  NOP  }
	{  SW R1, R0, 0      			|  NOP  |  NOP  |  NOP  |  NOP  }
	;{  MOVI R0, DMA_ENA_ADDR2	|  NOP  |  NOP  |  NOP  |  NOP  }
	;{  SW R1, R0, 0      			|  NOP  |  NOP  |  NOP  |  NOP  }
	;{  MOVI R0, DMA_ENA_ADDR3	|  NOP  |  NOP  |  NOP  |  NOP  }
	;{  SW R1, R0, 0      			|  NOP  |  NOP  |  NOP  |  NOP  }

	
	; Check DMA Status
	{  MOVI R2, DMA_STATUS_ADDR	|  NOP  |  NOP  |  NOP  |  NOP  }
DMABUSY:
	{  LW R3, R2, 0   			|  NOP  |  NOP  |  NOP  |  NOP  }	
	{  NOP              		|  NOP  |  NOP  |  NOP  |  NOP  }	
	{  NOP              		|  NOP  |  NOP  |  NOP  |  NOP  }	
	{  SEQI R3, P2, P3, R3, 0x00002222	|  NOP  |  NOP  |  NOP  |  NOP  }
	{  (P3) B DMABUSY         	|  NOP  |  NOP  |  NOP  |  NOP  }
	{  NOP              		|  NOP  |  NOP  |  NOP  |  NOP  }
	{  NOP              		|  NOP  |  NOP  |  NOP  |  NOP  }
	{  NOP              		|  NOP  |  NOP  |  NOP  |  NOP  }
	{  NOP             			|  NOP  |  NOP  |  NOP  |  NOP  }
	{  NOP             			|  NOP  |  NOP  |  NOP  |  NOP  }
;****************************************	
	{  MOVI.L R2, 0x803C    |  NOP  |  NOP  |  NOP  |  NOP  }
	{  MOVI.H R2, DMEM_BASE |  NOP  |  NOP  |  NOP  |  NOP  }
	{  MOVI.L R3, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
	{  MOVI.H R3, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
	{  SW R3, R2, 0  |  NOP  |  NOP  |  NOP  |  NOP  }
	; Interleaved
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
	
	
	; Set DMA 0x80000000 -> 0x90000000  1C200 words
	{  MOVI R0, DMA_SAR_ADDR0	|  NOP  |  NOP  |  NOP  |  NOP  }	
    
	{  MOVI R1, 0x24000000		|  NOP  |  NOP  |  NOP  |  NOP  }	
	{  SW R1, R0, 4+   			  |  NOP  |  NOP  |  NOP  |  NOP  }
    
	{  MOVI R1, 0x30100000		|  NOP  |  NOP  |  NOP  |  NOP  }	
	{  SW R1, R0, 4+   			  |  NOP  |  NOP  |  NOP  |  NOP  }
    
	{  MOVI R1, 0x00000000		|  NOP  |  NOP  |  NOP  |  NOP  }	
	{  SW R1, R0, 4+   			  |  NOP  |  NOP  |  NOP  |  NOP  }
    
	{  MOVI R1, 0x00000000		|  NOP  |  NOP  |  NOP  |  NOP  }	
	{  SW R1, R0, 4+   			  |  NOP  |  NOP  |  NOP  |  NOP  }
    
	{  MOVI R1, 0x0016000E		|  NOP  |  NOP  |  NOP  |  NOP  }	 ; BSZ[31:20], DSEN[9], SGEN[8], Int2Ext[3], Burst[2], TRZ[1:0], for 7056 DSP DMA
	{  SW R1, R0, 4+   			  |  NOP  |  NOP  |  NOP  |  NOP  }
    
	{  MOVI R1, 0x00000001		|  NOP  |  NOP  |  NOP  |  NOP  }	
	{  SW R1, R0, 4+   			  |  NOP  |  NOP  |  NOP  |  NOP  }
	
	{  MOVI R0, DMA_SAR_ADDR1	|  NOP  |  NOP  |  NOP  |  NOP  }	
    
	{  MOVI R1, 0x24002000		|  NOP  |  NOP  |  NOP  |  NOP  }	
	{  SW R1, R0, 4+   			  |  NOP  |  NOP  |  NOP  |  NOP  }
    
	{  MOVI R1, 0x30102000		|  NOP  |  NOP  |  NOP  |  NOP  }	
	{  SW R1, R0, 4+   			  |  NOP  |  NOP  |  NOP  |  NOP  }
    
	{  MOVI R1, 0x00000000		|  NOP  |  NOP  |  NOP  |  NOP  }	
	{  SW R1, R0, 4+   			  |  NOP  |  NOP  |  NOP  |  NOP  }
    
	{  MOVI R1, 0x00000000		|  NOP  |  NOP  |  NOP  |  NOP  }	
	{  SW R1, R0, 4+   			  |  NOP  |  NOP  |  NOP  |  NOP  }
    
	{  MOVI R1, 0x0016000E		|  NOP  |  NOP  |  NOP  |  NOP  } ; BSZ[31:20], DSEN[9], SGEN[8], Int2Ext[3], Burst[2], TRZ[1:0], for 7056 DSP DMA	
	{  SW R1, R0, 4+   			  |  NOP  |  NOP  |  NOP  |  NOP  }
    
	{  MOVI R1, 0x00000001		|  NOP  |  NOP  |  NOP  |  NOP  }	
	{  SW R1, R0, 4+   			  |  NOP  |  NOP  |  NOP  |  NOP  }
	
	{  MOVI R0, DMA_SAR_ADDR2	|  NOP  |  NOP  |  NOP  |  NOP  }	
    
	{  MOVI R1, 0x24004000		|  NOP  |  NOP  |  NOP  |  NOP  }	
	{  SW R1, R0, 4+   	  		|  NOP  |  NOP  |  NOP  |  NOP  }
    
	{  MOVI R1, 0x30104000		|  NOP  |  NOP  |  NOP  |  NOP  }	
	{  SW R1, R0, 4+   		  	|  NOP  |  NOP  |  NOP  |  NOP  }
    
	{  MOVI R1, 0x00000000		|  NOP  |  NOP  |  NOP  |  NOP  }	
	{  SW R1, R0, 4+   			  |  NOP  |  NOP  |  NOP  |  NOP  }
    
	{  MOVI R1, 0x00000000		|  NOP  |  NOP  |  NOP  |  NOP  }	
	{  SW R1, R0, 4+   			  |  NOP  |  NOP  |  NOP  |  NOP  }
    
	{  MOVI R1, 0x0016000E		|  NOP  |  NOP  |  NOP  |  NOP  }	 ; BSZ[31:20], DSEN[9], SGEN[8], Int2Ext[3], Burst[2], TRZ[1:0], for 7056 DSP DMA
	{  SW R1, R0, 4+   			  |  NOP  |  NOP  |  NOP  |  NOP  }
    
	{  MOVI R1, 0x00000001		|  NOP  |  NOP  |  NOP  |  NOP  }	
	{  SW R1, R0, 4+   			  |  NOP  |  NOP  |  NOP  |  NOP  }
	
	{  MOVI R0, DMA_SAR_ADDR3	|  NOP  |  NOP  |  NOP  |  NOP  }	
    
	{  MOVI R1, 0x24006000		|  NOP  |  NOP  |  NOP  |  NOP  }	
	{  SW R1, R0, 4+   			  |  NOP  |  NOP  |  NOP  |  NOP  }
    
	{  MOVI R1, 0x30106000		|  NOP  |  NOP  |  NOP  |  NOP  }	
	{  SW R1, R0, 4+   			  |  NOP  |  NOP  |  NOP  |  NOP  }
    
	{  MOVI R1, 0x00000000		|  NOP  |  NOP  |  NOP  |  NOP  }	
	{  SW R1, R0, 4+   			  |  NOP  |  NOP  |  NOP  |  NOP  }
    
	{  MOVI R1, 0x00000000		|  NOP  |  NOP  |  NOP  |  NOP  }	
	{  SW R1, R0, 4+   		  	|  NOP  |  NOP  |  NOP  |  NOP  }
    
	{  MOVI R1, 0x0016000E		|  NOP  |  NOP  |  NOP  |  NOP  }	; BSZ[31:20], DSEN[9], SGEN[8], Int2Ext[3], Burst[2], TRZ[1:0], for 7056 DSP DMA
	{  SW R1, R0, 4+   		  	|  NOP  |  NOP  |  NOP  |  NOP  }
    
	{  MOVI R1, 0x00000001		|  NOP  |  NOP  |  NOP  |  NOP  }	
	{  SW R1, R0, 4+   		  	|  NOP  |  NOP  |  NOP  |  NOP  }
	
		; Check DMA Status
	{  MOVI R2, DMA_STATUS_ADDR	|  NOP  |  NOP  |  NOP  |  NOP  }
DMABUSY1:
	{  LW R3, R2, 0   			|  NOP  |  NOP  |  NOP  |  NOP  }	
	{  NOP              		|  NOP  |  NOP  |  NOP  |  NOP  }	
	{  NOP              		|  NOP  |  NOP  |  NOP  |  NOP  }	
	{  SEQI R3, P2, P3, R3, 0x00002222	|  NOP  |  NOP  |  NOP  |  NOP  }
	{  (P3) B DMABUSY1         	|  NOP  |  NOP  |  NOP  |  NOP  }
	{  NOP              		|  NOP  |  NOP  |  NOP  |  NOP  }
	{  NOP              		|  NOP  |  NOP  |  NOP  |  NOP  }
	{  NOP              		|  NOP  |  NOP  |  NOP  |  NOP  }
	{  NOP             			|  NOP  |  NOP  |  NOP  |  NOP  }
	{  NOP             			|  NOP  |  NOP  |  NOP  |  NOP  }
	
	; Set DMA 0x80000000 -> 0x90000000  1C200 words
	{  MOVI R0, DMA_SAR_ADDR0	|  NOP  |  NOP  |  NOP  |  NOP  }	
    
	{  MOVI R1, 0x24008000		|  NOP  |  NOP  |  NOP  |  NOP  }	
	{  SW R1, R0, 4+   		  	|  NOP  |  NOP  |  NOP  |  NOP  }
    
	{  MOVI R1, 0x30108000		|  NOP  |  NOP  |  NOP  |  NOP  }	
	{  SW R1, R0, 4+   			  |  NOP  |  NOP  |  NOP  |  NOP  }
    
	{  MOVI R1, 0x00000000		|  NOP  |  NOP  |  NOP  |  NOP  }	
	{  SW R1, R0, 4+   			  |  NOP  |  NOP  |  NOP  |  NOP  }
    
	{  MOVI R1, 0x00000000		|  NOP  |  NOP  |  NOP  |  NOP  }	
	{  SW R1, R0, 4+   			  |  NOP  |  NOP  |  NOP  |  NOP  }
    
	{  MOVI R1, 0x0016000E		|  NOP  |  NOP  |  NOP  |  NOP  }	 ; BSZ[31:20], DSEN[9], SGEN[8], Int2Ext[3], Burst[2], TRZ[1:0], for 7056 DSP DMA
	{  SW R1, R0, 4+    			|  NOP  |  NOP  |  NOP  |  NOP  }
    
	;{  MOVI R1, 0x00000001		|  NOP  |  NOP  |  NOP  |  NOP  }	
	;{  SW R1, R0, 4+    			|  NOP  |  NOP  |  NOP  |  NOP  }
	
	{  MOVI R0, DMA_SAR_ADDR1	|  NOP  |  NOP  |  NOP  |  NOP  }	
    
	{  MOVI R1, 0x2400A000		|  NOP  |  NOP  |  NOP  |  NOP  }	
	{  SW R1, R0, 4+    			|  NOP  |  NOP  |  NOP  |  NOP  }
    
	{  MOVI R1, 0x3010A000		|  NOP  |  NOP  |  NOP  |  NOP  }	
	{  SW R1, R0, 4+    			|  NOP  |  NOP  |  NOP  |  NOP  }
    
	{  MOVI R1, 0x00000000		|  NOP  |  NOP  |  NOP  |  NOP  }	
	{  SW R1, R0, 4+   	   		|  NOP  |  NOP  |  NOP  |  NOP  }
    
	{  MOVI R1, 0x00000000		|  NOP  |  NOP  |  NOP  |  NOP  }	
	{  SW R1, R0, 4+   			  |  NOP  |  NOP  |  NOP  |  NOP  }
    
	{  MOVI R1, 0x0016000E		|  NOP  |  NOP  |  NOP  |  NOP  }	; BSZ[31:20], DSEN[9], SGEN[8], Int2Ext[3], Burst[2], TRZ[1:0], for 7056 DSP DMA
	{  SW R1, R0, 4+   		  	|  NOP  |  NOP  |  NOP  |  NOP  }
    
	;{  MOVI R1, 0x00000001		|  NOP  |  NOP  |  NOP  |  NOP  }	
	;{  SW R1, R0, 4+   			  |  NOP  |  NOP  |  NOP  |  NOP  }
	
	{  MOVI R0, DMA_SAR_ADDR2	|  NOP  |  NOP  |  NOP  |  NOP  }	
    
	{  MOVI R1, 0x2400C000		|  NOP  |  NOP  |  NOP  |  NOP  }	
	{  SW R1, R0, 4+   			  |  NOP  |  NOP  |  NOP  |  NOP  }
    
	{  MOVI R1, 0x3010C000		|  NOP  |  NOP  |  NOP  |  NOP  }	
	{  SW R1, R0, 4+   		  	|  NOP  |  NOP  |  NOP  |  NOP  }
    
	{  MOVI R1, 0x00000000		|  NOP  |  NOP  |  NOP  |  NOP  }	
	{  SW R1, R0, 4+   		  	|  NOP  |  NOP  |  NOP  |  NOP  }
    
	{  MOVI R1, 0x00000000		|  NOP  |  NOP  |  NOP  |  NOP  }	
	{  SW R1, R0, 4+   			  |  NOP  |  NOP  |  NOP  |  NOP  }
    
	{  MOVI R1, 0x0016000E		|  NOP  |  NOP  |  NOP  |  NOP  }	; BSZ[31:20], DSEN[9], SGEN[8], Int2Ext[3], Burst[2], TRZ[1:0], for 7056 DSP DMA
	{  SW R1, R0, 4+   			  |  NOP  |  NOP  |  NOP  |  NOP  }
    
	;{  MOVI R1, 0x00000001		|  NOP  |  NOP  |  NOP  |  NOP  }	
	;{  SW R1, R0, 4+   			  |  NOP  |  NOP  |  NOP  |  NOP  }
	
	{  MOVI R0, DMA_SAR_ADDR3	|  NOP  |  NOP  |  NOP  |  NOP  }	
    
	{  MOVI R1, 0x2400E000		|  NOP  |  NOP  |  NOP  |  NOP  }	
	{  SW R1, R0, 4+   		  	|  NOP  |  NOP  |  NOP  |  NOP  }
    
	{  MOVI R1, 0x3010E000		|  NOP  |  NOP  |  NOP  |  NOP  }	
	{  SW R1, R0, 4+   		  	|  NOP  |  NOP  |  NOP  |  NOP  }
    
	{  MOVI R1, 0x00000000		|  NOP  |  NOP  |  NOP  |  NOP  }	
	{  SW R1, R0, 4+   		  	|  NOP  |  NOP  |  NOP  |  NOP  }
    
	{  MOVI R1, 0x00000000		|  NOP  |  NOP  |  NOP  |  NOP  }	
	{  SW R1, R0, 4+   		  	|  NOP  |  NOP  |  NOP  |  NOP  }
    
	{  MOVI R1, 0x0016000E		|  NOP  |  NOP  |  NOP  |  NOP  }	
	{  SW R1, R0, 4+   		  	|  NOP  |  NOP  |  NOP  |  NOP  }
    
	;{  MOVI R1, 0x00000001		|  NOP  |  NOP  |  NOP  |  NOP  }	
	;{  SW R1, R0, 4+   			|  NOP  |  NOP  |  NOP  |  NOP  }
	
		; Check DMA Status
	{  MOVI R2, DMA_STATUS_ADDR	|  NOP  |  NOP  |  NOP  |  NOP  }
DMABUSY2:
	{  LW R3, R2, 0   			|  NOP  |  NOP  |  NOP  |  NOP  }	
	{  NOP              		|  NOP  |  NOP  |  NOP  |  NOP  }	
	{  NOP              		|  NOP  |  NOP  |  NOP  |  NOP  }	
	{  SEQI R3, P2, P3, R3, 0x00002222	|  NOP  |  NOP  |  NOP  |  NOP  }
	{  (P3) B DMABUSY2         	|  NOP  |  NOP  |  NOP  |  NOP  }
	{  NOP              		|  NOP  |  NOP  |  NOP  |  NOP  }
	{  NOP              		|  NOP  |  NOP  |  NOP  |  NOP  }
	{  NOP              		|  NOP  |  NOP  |  NOP  |  NOP  }
	{  NOP             			|  NOP  |  NOP  |  NOP  |  NOP  }
	{  NOP             			|  NOP  |  NOP  |  NOP  |  NOP  }
	

;**************************************************************
{  TRAP  |  NOP  |  NOP  |  NOP  |  NOP  }
