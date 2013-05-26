;**************************************************************
; To verify the forwarding paths in Scalar, Cluster1 and Cluster2,
; including the predicate registers

BASE_ADDR = 0x2400

;************************************************************** Set Start Address
{  MOVI.L R0, 0x0000    |  MOVI.L A0, 0x0010    |  NOP  |  NOP  |  NOP  }
{  MOVI.H R0, BASE_ADDR |  MOVI.H A0, BASE_ADDR |  NOP  |  NOP  |  NOP  }

;************************************************************** Scalar

{  MOVI R1, 0x00000001 |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R1] = 0x0000_0001

{  MOVI R2, 0x00000002 |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0002

{  ADD R3, R1, R2  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R3] = 0x0000_0003,	Rs1 from E2, Rs2 from E1

{  ADD R4, R3, R2  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R4] = 0x0000_0005,	Rs1 from E1, Rs2 from E2

{  ADD R5, R2, R3  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R5] = 0x0000_0005,	Rs1 from E3, Rs2 from E2

{  ADD R6, R5, R3  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R6] = 0x0000_0008,	Rs1 from E1, Rs2 from E3

;-------------------------------------------------------------- Store Result
{  SW R3, R0, 4+  |   NOP   |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0000] = 0x0000_0003

{  SW R4, R0, 4+  |   NOP   |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0004] = 0x0000_0005

{  SW R5, R0, 4+  |   NOP   |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0008] = 0x0000_0005

{  SW R6, R0, 4+  |   NOP   |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_000C] = 0x0000_0008

;************************************************************** AU, LS
{  NOP  |  MOVI D0, 0x00000000  |  MOVI D8, 0x00000008 |   NOP  |  NOP  }

{  NOP  |  MOVI D1, 0x00000001  |  MOVI D9, 0x00000009 |   NOP  |  NOP  }

{  NOP  |  ADD D2, D0, D1  |  ADD D10, D8, D9  |  NOP  |  NOP  }
;Reg[D2] = 0x0000_0001,	Rs1 from AU_E2, Rs2 from AU_E1
;Reg[D10] = 0x0000_0011, Rs1 from LS_E2, Rs2 from LS_E1

{  NOP  |  ADD D3, D2, D1  |  ADD D11, D10, D9  |  NOP  |  NOP  }
;Reg[D3] = 0x0000_0002,	Rs1 from AU_E1, Rs2 from AU_E2
;Reg[D11] = 0x0000_001A, Rs1 from LS_E1, Rs2 from LS_E2

{  NOP  |  ADD D4, D1, D3  |  ADD D12, D9, D11  |  NOP  |  NOP  }
;Reg[D4] = 0x0000_0003,	Rs1 from AU_E3, Rs2 from AU_E1
;Reg[D12] = 0x0000_0023, Rs1 from LS_E3, Rs2 from LS_E1

{  NOP  |  ADD D5, D4, D2  |  ADD D13, D12, D10  |  NOP  |  NOP  }
;Reg[D5] = 0x0000_0004,	Rs1 from AU_E1, Rs2 from AU_E3
;Reg[D13] = 0x0000_0034, Rs1 from LS_E1, Rs2 from LS_E3

;-------------------------------------------------------------- Store Result
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0010] = 0x0000_0001

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0014] = 0x0000_0002

{  NOP  |  SW D4, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0018] = 0x0000_0003

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_001C] = 0x0000_0004

{  NOP  |  SW D10, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0020] = 0x0000_0011

{  NOP  |  SW D11, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0024] = 0x0000_001A

{  NOP  |  SW D12, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0028] = 0x0000_0023

{  NOP  |  SW D13, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_002C] = 0x0000_0034

;************************************************************** AU, LS (Rs1, Rs2)
{  NOP  |  ADD D10, D0, D1  |  ADD D2, D8, D9  |  NOP  |  NOP  }
;Reg[D10] = 0x0000_0001,	
;Reg[D2] = 0x0000_0011, 

{  NOP  |  ADD D11, D2, D1  |  ADD D3, D10, D8  |  NOP  |  NOP  }
;Reg[D11] = 0x0000_0012, Rs1 from LS_E1, Rs2 from RF	
;Reg[D3] = 0x0000_0009, Rs1 from AU_E1, Rs2 from RF

{  NOP  |  ADD D12, D2, D3  |  ADD D4, D10, D11  |  NOP  |  NOP  }
;Reg[D12] = 0x0000_001A, Rs1 from LS_E2, Rs2 from LS_E1	
;Reg[D4] = 0x0000_0013, Rs1 from AU_E2, Rs2 from AU_E1

{  NOP  |  ADD D13, D2, D3  |  ADD D5, D10, D11  |  NOP  |  NOP  }
;Reg[D13] = 0x0000_001A, Rs1 from LS_E3, Rs2 from LS_E2	
;Reg[D5] = 0x0000_0013, Rs1 from AU_E3, Rs2 from AU_E2

{  NOP  |  ADD D14, D3, D3  |  ADD D6, D11, D11  |  NOP  |  NOP  }
;Reg[D14] = 0x0000_0012, Rs1 from LS_E3, Rs2 from LS_E3	
;Reg[D6] = 0x0000_0024, Rs1 from AU_E3, Rs2 from AU_E3

;-------------------------------------------------------------- Store Result
{  NOP  |  SW D11, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0030] = 0x0000_0012

{  NOP  |  SW D12, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0034] = 0x0000_001A

{  NOP  |  SW D13, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0038] = 0x0000_001A

{  NOP  |  SW D14, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_003C] = 0x0000_0012

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0040] = 0x0000_0009

{  NOP  |  SW D4, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0044] = 0x0000_0013

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0048] = 0x0000_0013

{  NOP  |  SW D6, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_004C] = 0x0000_0024

;************************************************************** SC, AU, LS (Rsd)
{  MOVI.L R0, 0x0070    |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R0, BASE_ADDR |  MOVI D0, 0x44444444  |  MOVI D8, 0x11111111 |   NOP  |  NOP  }

{  MOVI R1, 0x11111111  |  MOVI D1, 0x55555555  |  MOVI D9, 0x22222222 |   NOP  |  NOP  }

{  MOVI R2, 0x22222222  |  MOVI D2, 0x66666666  |  MOVI D10, 0x33333333 |   NOP  |  NOP  }

{  SW R2, R0, 4+  |  SW D2, A0, 4+  |  MAC.D D8, D8, D9  |  NOP  |  NOP  }
;Mem[0x1E00_0070] = 0x2222_2222, Rs1 from SC_E1
;Mem[0x1E00_0050] = 0x6666_6666, Rs1 from LS_E1
;Reg[D8] = 0x9753_9753  , Rsd from AU_E3, Rs1 from AU_E3, Rs2 from AU_E2

{  SW R2, R0, 4+  |  SW D2, A0, 4+  |  MAC.D D10, D8, D9  |  NOP  |  NOP  }
;Mem[0x1E00_0074] = 0x2222_2222, Rs1 from SC_E2
;Mem[0x1E00_0054] = 0x6666_6666, Rs1 from LS_E2
;Reg[D10] = 0xB975_B975  , Rsd from AU_E2, Rs1 from RF, Rs2 from AU_E3

{  SW R2, R0, 4+  |  SW D2, A0, 4+  |  MAC.D D10, D8, D9  |  NOP  |  NOP  }
;Mem[0x1E00_0078] = 0x2222_2222, Rs1 from SC_E3
;Mem[0x1E00_0058] = 0x6666_6666, Rs1 from LS_E3
;Reg[D10] = 0x5239_5239  , Rsd from AU_E3, Rs1 from AU_E2, Rs2 from RF

;************************************************************** Store results
{  NOP  |  SW D8, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_005C] = 0x9753_9753

{  NOP  |  SW D10, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0060] = 0x5239_5239

;************************************************************** SC, AU, LS (Rsd)
{  NOP  |  MOVI D0, 0x44444444  |  MOVI D8, 0x11111111 |   NOP  |  NOP  }

{  NOP  |  MOVI D1, 0x55555555  |  MOVI D9, 0x22222222 |   NOP  |  NOP  }

{  NOP  |  MOVI D2, 0x66666666  |  MOVI D10, 0x33333333 |   NOP  |  NOP  }

{  NOP  |  SW D10, A0, 4+  |  MAC.D D0, D0, D1  |  NOP  |  NOP  }
;Mem[0x1E00_0064] = 0x3333_3333, Rs1 from AU_E1
;Reg[D0] = 0x82D8_82D8  , Rsd from LS_E3, Rs1 from LS_E3, Rs2 from LS_E2

{  NOP  |  SW D10, A0, 4+  |  MAC.D D2, D0, D1  |  NOP  |  NOP  }
;Mem[0x1E00_0068] = 0x3333_3333, Rs1 from AU_E2
;Reg[D2] = 0xA4FA_A4FA  , Rsd from LS_E2, Rs1 from RF, Rs2 from LS_E3

{  NOP  |  SW D10, A0, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_006C] = 0x3333_3333, Rs1 from AU_E3

{  NOP  |  MOVI D1, 0x77777777  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  MAC.D D1, D0, D1  |  NOP  |  NOP  }
;Reg[D1] = 0xB1DF_B1DF  , Rsd from LS_E1, Rs1 from AU_E3, Rs2 from LS_E1

;************************************************************** Store results
{  NOP  |  SW D0, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0070] = 0x82D8_82D8

{  NOP  |  SW D1, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0074] = 0xB1DF_B1DF

{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0078] = 0xA4FA_A4FA

;************************************************************** AU, LS (Rsd+1)
{  NOP  |  NOP  |  MOVI AC0, 0x11111111  |  NOP  |  NOP  }
{  NOP  |  NOP  |  MOVI AC1, 0x22222222  |  NOP  |  NOP  }
{  NOP  |  NOP  |  MOVI AC2, 0x33333333  |  NOP  |  NOP  }
{  NOP  |  NOP  |  MOVI AC3, 0x44444444  |  NOP  |  NOP  }
{  NOP  |   NOP   |  FMAC.D AC0, AC1, AC2  |  NOP  |  NOP  }
;Reg[AC0] = 0x17E4_A3D7  , Rsd from RF, Rsd+1 from AU_E3
;Reg[AC1] = 0x28F5_B4E8    
{  NOP  |   NOP   |  FMAC.D AC2, AC1, AC2  |  NOP  |  NOP  }
;Reg[AC2] = 0x3A06_C5F9  , Rsd from AU_E3, Rsd+1 from AU_E2
;Reg[AC3] = 0x4B17_D70A
{  NOP  |  NOP  |  MOVI AC4, 0x55555555  |  NOP  |  NOP  }
{  NOP  |  NOP  |  MOVI AC5, 0x66666666  |  NOP  |  NOP  }
{  NOP  |   NOP   |  FMAC.D AC4, AC1, AC2  |  NOP  |  NOP  }
;Reg[AC4] = 0x665A_D2FD  , Rsd from AU_E2, Rsd+1 from AU_E1
;Reg[AC5] = 0x6FAE_DE24

{  NOP  |  NOP  |  COPY D0, AC0  |  NOP  |  NOP  }
{  NOP  |  NOP  |  COPY D1, AC1  |  NOP  |  NOP  }
{  NOP  |  NOP  |  COPY D2, AC2  |  NOP  |  NOP  }
{  NOP  |  NOP  |  COPY D3, AC3  |  NOP  |  NOP  }
{  NOP  |  NOP  |  COPY D4, AC4  |  NOP  |  NOP  }
{  NOP  |  NOP  |  COPY D5, AC5  |  NOP  |  NOP  }

;************************************************************** Store results
{  NOP  |  SW D0, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_007C] = 0x17E4_A3D7

{  NOP  |  SW D1, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0080] = 0x28F5_B4E8

{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0084] = 0x3A06_C5F9

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0088] = 0x4B17_D70A

{  NOP  |  SW D4, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_008C] = 0x665A_D2FD

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0090] = 0x6FAE_DE24
 
;************************************************************** SC, LS1, AU1, LS2, AU2  (predicate registers)
{  ANDP P1, P0, P0  |  NOP  |  ORP P2, P0, P0  |  NOP  |  XORP P3, P0, P0  }
;Reg[P1] = 0x1, Reg[P2] = 0x1, Reg[P3] = 0x0

{  ANDP P4, P2, P3  |  NOP  |  ORP P5, P1, P3  |  NOP  |  XORP P6, P1, P2  }
;Reg[P4] = 0x0, Ps1 from AU1_E1, Ps2 from AU2_E1
;Reg[P5] = 0x1, Ps1 from SC_E1 , Ps2 from AU2_E1
;Reg[P6] = 0x0, Ps1 from SC_E1 , Ps2 from AU1_E1

{  ANDP P7, P4, P5  |  NOP  |  ORP P8, P5, P6  |  NOP  |  XORP P9, P6, P4  }
;Reg[P7] = 0x0, Ps1 from SC_E1 , Ps2 from AU1_E1
;Reg[P8] = 0x1, Ps1 from AU1_E1, Ps2 from AU2_E1
;Reg[P9] = 0x0, Ps1 from AU2_E1, Ps2 from SC_E1

{  ANDP P10, P5, P6  |  NOP  |  ORP P11, P4, P6  |  NOP  |  XORP P12, P4, P5  }
;Reg[P10] = 0x0, Ps1 from AU1_E2, Ps2 from AU2_E2
;Reg[P11] = 0x0, Ps1 from SC_E2 , Ps2 from AU2_E2
;Reg[P12] = 0x1, Ps1 from SC_E2 , Ps2 from AU1_E2

{  ANDP P13, P7, P8  |  NOP  |  ORP P14, P8, P9  |  NOP  |  XORP P15, P9, P7  }
;Reg[P13] = 0x0, Ps1 from SC_E2 , Ps2 from AU1_E2
;Reg[P14] = 0x1, Ps1 from AU1_E2, Ps2 from AU2_E2
;Reg[P15] = 0x0, Ps1 from AU2_E2, Ps2 from SC_E2

{  ANDP P1, P8, P9  |  NOP  |  ORP P2, P7, P9  |  NOP  |  XORP P3, P7, P8  }
;Reg[P1] = 0x0, Ps1 from AU1_E3, Ps2 from AU2_E3
;Reg[P2] = 0x0, Ps1 from SC_E3 , Ps2 from AU2_E3
;Reg[P3] = 0x1, Ps1 from SC_E3 , Ps2 from AU1_E3

{  ANDP P4, P10, P11  |  NOP  |  ORP P5, P11, P12  |  NOP  |  XORP P6, P12, P10  }
;Reg[P4] = 0x0, Ps1 from SC_E3 , Ps2 from AU1_E3
;Reg[P5] = 0x1, Ps1 from AU1_E3, Ps2 from AU2_E3
;Reg[P6] = 0x1, Ps1 from AU2_E3, Ps2 from SC_E3

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  ANDP P1, P0, P0  |  ORP P2, P0, P0  |  NOP  |  XORP P3, P0, P0  |  NOP  }
;Reg[P1] = 0x1, Reg[P2] = 0x1, Reg[P3] = 0x0

{  ANDP P4, P2, P3  |  ORP P5, P1, P3  |  NOP  |  XORP P6, P1, P2  |  NOP  }
;Reg[P4] = 0x0, Ps1 from LS1_E1, Ps2 from LS2_E1
;Reg[P5] = 0x1, Ps1 from SC_E1 , Ps2 from LS2_E1
;Reg[P6] = 0x0, Ps1 from SC_E1 , Ps2 from LS1_E1

{  ANDP P7, P4, P5  |  ORP P8, P5, P6  |  NOP  |  XORP P9, P6, P4  |  NOP  }
;Reg[P7] = 0x0, Ps1 from SC_E1 , Ps2 from LS1_E1
;Reg[P8] = 0x1, Ps1 from LS1_E1, Ps2 from LS2_E1
;Reg[P9] = 0x0, Ps1 from LS2_E1, Ps2 from SC_E1

{  ANDP P10, P5, P6  |  ORP P11, P4, P6  |  NOP  |  XORP P12, P4, P5  |  NOP  }
;Reg[P10] = 0x0, Ps1 from LS1_E2, Ps2 from LS2_E2
;Reg[P11] = 0x0, Ps1 from SC_E2 , Ps2 from LS2_E2
;Reg[P12] = 0x1, Ps1 from SC_E2 , Ps2 from LS1_E2

{  ANDP P13, P7, P8  |  ORP P14, P8, P9  |  NOP  |  XORP P15, P9, P7  |  NOP  }
;Reg[P13] = 0x0, Ps1 from SC_E2 , Ps2 from LS1_E2
;Reg[P14] = 0x1, Ps1 from LS1_E2, Ps2 from LS2_E2
;Reg[P15] = 0x0, Ps1 from LS2_E2, Ps2 from SC_E2

{  ANDP P1, P8, P9  |  ORP P2, P7, P9  |  NOP  |  XORP P3, P7, P8  |  NOP  }
;Reg[P1] = 0x0, Ps1 from LS1_E3, Ps2 from LS2_E3
;Reg[P2] = 0x0, Ps1 from SC_E3 , Ps2 from LS2_E3
;Reg[P3] = 0x1, Ps1 from SC_E3 , Ps2 from LS1_E3

{  ANDP P4, P10, P11  |  ORP P5, P11, P12  |  NOP  |  XORP P6, P12, P10  |  NOP  }
;Reg[P4] = 0x0, Ps1 from SC_E3 , Ps2 from LS1_E3
;Reg[P5] = 0x1, Ps1 from LS1_E3, Ps2 from LS2_E3
;Reg[P6] = 0x1, Ps1 from LS2_E3, Ps2 from SC_E3




;************************************************************** Program Terminate
{  TRAP  |  NOP  |  NOP  |  NOP  |  NOP  }
