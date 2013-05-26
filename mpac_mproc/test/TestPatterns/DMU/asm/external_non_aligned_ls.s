DDR_ADDR = 0x3000

;************************************************************** Set Start Address
{  MOVI.L R0, 0x0000   |  MOVI.L A0, 0x0000   |  NOP  |  MOVI.L A0, 0x4000   |  NOP  }
{  MOVI.H R0, DDR_ADDR |  MOVI.H A0, DDR_ADDR |  NOP  |  MOVI.H A0, DDR_ADDR |  NOP  }
{  NOP  |  MOVI D1, 0x11111111  |  NOP  |  MOVI D1, 0x11111111  |  NOP  }
{  NOP  |  MOVI D2, 0x22222222  |  NOP  |  MOVI D2, 0x22222222  |  NOP  }
{  NOP  |  MOVI D3, 0x33333333  |  NOP  |  MOVI D3, 0x33333333  |  NOP  }
{  NOP  |  MOVI D4, 0x44444444  |  NOP  |  MOVI D4, 0x44444444  |  NOP  }
{  NOP  |  MOVI D5, 0x55555555  |  NOP  |  MOVI D5, 0x55555555  |  NOP  }
{  NOP  |  MOVI D6, 0x66666666  |  NOP  |  MOVI D6, 0x66666666  |  NOP  }
{  NOP  |  MOVI D7, 0x77777777  |  NOP  |  MOVI D7, 0x77777777  |  NOP  }

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
;Mem[0x0000_0054] = 0x1100_0000, Mem[0x0000_0058] = 0x0011_1111
{  NOP  |  NOP  |  NOP  |  SNW D1, A0, 2  |  NOP  }
;Mem[0x0000_4050] = 0x1111_0000, Mem[0x0000_4054] = 0x0000_1111
{  NOP  |  DSNW D2, D3, A0, 7  |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0058] = 0x2211_1111, Mem[0x0000_005C] = 0x3322_2222, Mem[0x0000_0060] = 0x0033_3333
{  NOP  |  NOP  |  NOP  |  DSNW D2, D3, A0, 6  |  NOP  }
;Mem[0x0000_4054] = 0x2222_1111, Mem[0x0000_4058] = 0x3333_2222, Mem[0x0000_405C] = 0x0000_3333


;--------------------------------------------------------------  (D)SNW/(D)SW pair operation
{  NOP  |  SNW D4, A0, 17  |  NOP  |  SW D4, A0, 16  |  NOP  }
;Mem[0x0000_0064] = 0x4444_4400, Mem[0x0000_0068] = 0x0000_0044
;Mem[0x0000_4060] = 0x4444_4444

{  NOP  |  SW D5, A0, 24  |  NOP  |  SNW D5, A0, 18  |  NOP  }
;Mem[0x0000_006C] = 0x5555_5555
;Mem[0x0000_4060] = 0x5555_4444, Mem[0x0000_4064] = 0x0000_5555

{  NOP  |  DSNW D6, D7, A0, 30  |  NOP  |  DSW D6, D7, A0, 24  |  NOP  }
;Mem[0x0000_0070] = 0x6666_0000, Mem[0x0000_0074] = 0x7777_6666, Mem[0x0000_0078] = 0x0000_7777
;Mem[0x0000_4068] = 0x6666_6666, Mem[0x0000_406C] = 0x7777_7777

{  NOP  |  SW D2, A0, 40  |  NOP  |  DSNW D2, D3, A0, 33  |  NOP  }
;Mem[0x0000_007C] = 0x2222_2222
;Mem[0x0000_4070] = 0x2222_2200, Mem[0x0000_4074] = 0x3333_3322, Mem[0x0000_4078] = 0x0000_0033

{  NOP  |  SW D3, A0, 44  |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0080] = 0x3333_3333
;--------------------------------------------------------------  single (D)LNW operation
{  NOP  |  LNW D8, A0, 2  |  NOP  |  NOP  |  NOP  }
;Cluster1: Reg[D8] = 0x1111_1100
{  NOP  |  NOP  |  NOP  |  LNW D8, A0, 2  |  NOP  }
;Cluster2: Reg[D8] = 0x1111_1111
{  NOP  |  DLNW D10, A0, 9  |  NOP  |  NOP  |  NOP  }   //?????
;Cluster1:Reg[D10] = 0x3333_2222
;Cluster1:Reg[D11] = 0x0000_3333
{  NOP  |  NOP  |  NOP  |  DLNW D10, A0, 10  |  NOP  }
;Cluster2:Reg[D10] = 0x3333_3333
;Cluster2:Reg[D11] = 0x4444_0000

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
;--------------------------------------------------------------  store results
{  NOP  |  SW D8, A0, 48  |  NOP  |  SW D8, A0, 44  |  NOP  }
;Mem[0x0000_0084] = 0x1111_1100
;Mem[0x0000_407C] = 0x1111_1111
{  NOP  |  SW D10, A0, 52  |  NOP  |  SW D10, A0, 48  |  NOP  }
;Mem[0x0000_0088] = 0x3333_2222
;Mem[0x0000_4080] = 0x3333_3333
{  NOP  |  SW D11, A0, 56  |  NOP  |  SW D11, A0, 52  |  NOP  }
;Mem[0x0000_008C] = 0x4400_0033
;Mem[0x0000_4084] = 0x4444_0000



;--------------------------------------------------------------  (D)LNW/(D)LW pair operation
{  NOP  |  LNW D8, A0, 19  |  NOP  |  LW D8, A0, 16  |  NOP  }
;Cluster1: Reg[D8] = 0x0000_4444
;Cluster2: Reg[D8] = 0x4444_4444
{  NOP  |  LW D9, A0, 20  |  NOP  |  LNW D9, A0, 21  |  NOP  }
;Cluster1: Reg[D9] = 0x0000_0044
;Cluster2: Reg[D9] = 0x6600_0055

{  NOP  |  DLNW D10, A0, 26  |  NOP  |  DLW D10, A0, 24  |  NOP  }  //????
;Cluster1: Reg[D10] = 0x0000_5555
;Cluster1: Reg[D11] = 0x6666_6666
;Cluster2: Reg[D10] = 0x6666_6666
;Cluster2: Reg[D11] = 0x7777_7777

{  NOP  |  DLW D12, A0, 28  |  NOP  |  DLNW D12, A0, 29  |  NOP  }
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


  { NOP | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }  
  { NOP | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }  
  { NOP | NOP | NOP | NOP | NOP }


{  TRAP  |  NOP  |  NOP  |  NOP  |  NOP  }
