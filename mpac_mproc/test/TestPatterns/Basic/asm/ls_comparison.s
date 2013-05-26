
BASE_ADDR = 0x2400
  
;************************************************************** Set Start Address
{  NOP  |  MOVI.L A0, 0x0000    |  NOP  |  NOP  |  NOP  }

{  NOP  |  MOVI.H A0, BASE_ADDR |  NOP  |  NOP  |  NOP  }

;************************************************************** SLT(U), SGT(U)
{  NOP  | MOVI.L D0, 0x0000  |   NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x0000_0000

{  NOP  |  MOVI.H D0, 0x8000  |   NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x8000_0000

{  NOP  |  MOVI.L D1, 0xFFFF  |   NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x0000_FFFF

{  NOP  |  MOVI.H D1, 0x7FFF  |   NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x7FFF_FFFF

{  NOP  |  SLTI D6, P14, P15, D0, 0x00000000   |  NOP  |  NOP  |  NOP  }
;Reg[D6] = 0x0000_0001, Reg[P14] = 1, Reg[P15] = 0

{  NOP  |  (P14) SLT D2, P1, P2, D0, D1   |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0x0000_0001, Reg[P1] = 1, Reg[P2] = 0

{  NOP  |  (P15) SLT D2, P1, P2, D1, D0   |  NOP  |  NOP  |  NOP  }
;Not execute

{  NOP  |  (P1) SLTU D3, P3, P4, D0, D1   |  NOP  |  NOP  |  NOP  }
;Reg[D3] = 0x0000_0000, Reg[P3] = 0, Reg[P4] = 1

{  NOP  |  (P2) SLTU D3, P3, P4, D1, D0   |  NOP  |  NOP  |  NOP  }
;Not execute

{  NOP  |  (P4) SGT D4, P5, P6, D0, D1   |  NOP  |  NOP  |  NOP  }
;Reg[D4] = 0x0000_0000, Reg[P5] = 0, Reg[P6] = 1

{  NOP  |  (P3) SGT D4, P5, P6, D1, D0   |  NOP  |  NOP  |  NOP  }
;Not execute

{  NOP  |  (P6) SGTU D5, P7, P8, D0, D1   |  NOP  |  NOP  |  NOP  }
;Reg[D5] = 0x0000_0001, Reg[P7] = 1, Reg[P8] = 0

{  NOP  |  (P5) SGTU D5, P7, P8, D1, D0   |  NOP  |  NOP  |  NOP  }
;Not execute

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D0, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0000] = 0x8000_0000, Reg[A0] = 0x0000_0004

{  NOP  |  SW D1, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0004] = 0x7FFF_FFFF, Reg[A0] = 0x0000_0008

{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0008] = 0x0000_0001, Reg[A0] = 0x0000_000C

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_000C] = 0x0000_0000, Reg[A0] = 0x0000_0010

{  NOP  |  SW D4, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0010] = 0x0000_0000, Reg[A0] = 0x0000_0014

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0014] = 0x0000_0001, Reg[A0] = 0x0000_0018


;************************************************************** SLT(U).L, SGT(U).L
{  NOP  |  MOVI.L D0, 0x0000  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x8000_0000

{  NOP  |  MOVI.H D0, 0x8000  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x8000_0000

{  NOP  |  MOVI.L D1, 0xFFFF  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x7FFF_FFFF

{  NOP  |  MOVI.H D1, 0x7FFF  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x7FFF_FFFF

{  NOP  |  (P7) SLT.L D2, P1, P2, D0, D1   |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0x0000_0000, Reg[P1] = 0, Reg[P2] = 1

{  NOP  |  (P8) SLT.L D2, P1, P2, D1, D0   |  NOP  |  NOP  |  NOP  }
;Not execute

{  NOP  |  (P2) SLTU.L D3, P3, P4, D0, D1   |  NOP  |  NOP  |  NOP  }
;Reg[D3] = 0x0000_0001, Reg[P3] = 1, Reg[P4] = 0

{  NOP  |  (P1) SLTU.L D3, P3, P4, D1, D0   |  NOP  |  NOP  |  NOP  }
;Not execute

{  NOP  |  (P3) SGT.L D4, P5, P6, D0, D1   |  NOP  |  NOP  |  NOP  }
;Reg[D4] = 0x0000_0001, Reg[P5] = 1, Reg[P6] = 0

{  NOP  |  (P4) SGT.L D4, P5, P6, D1, D0   |  NOP  |  NOP  |  NOP  }
;Not execute

{  NOP  |  (P5) SGTU.L D5, P7, P8, D0, D1   |  NOP  |  NOP  |  NOP  }
;Reg[D5] = 0x0000_0000, Reg[P7] = 0, Reg[P8] = 1

{  NOP  |  (P6) SGTU.L D5, P7, P8, D1, D0   |  NOP  |  NOP  |  NOP  }
;Not execute

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D0, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0018] = 0x8000_0000, Reg[A0] = 0x0000_001C

{  NOP  |  SW D1, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_001C] = 0x7FFF_FFFF, Reg[A0] = 0x0000_0020

{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0020] = 0x0000_0000, Reg[A0] = 0x0000_0024

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0024] = 0x0000_0001, Reg[A0] = 0x0000_0028

{  NOP  |  SW D4, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0028] = 0x0000_0001, Reg[A0] = 0x0000_002C

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_002C] = 0x0000_0000, Reg[A0] = 0x0000_0030


;************************************************************** SLT(U).H, SGT(U).H
{  NOP  | MOVI.L D0, 0x0000  |   NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x8000_0000

{  NOP  |  MOVI.H D0, 0x8000  |   NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x8000_0000

{  NOP  |  MOVI.L D1, 0xFFFF  |   NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x7FFF_FFFF

{  NOP  |  MOVI.H D1, 0x7FFF  |   NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x7FFF_FFFF

{  NOP  |  (P8) SLT.H D2, P1, P2, D0, D1   |   NOP  |  NOP  |  NOP  }
;Reg[D2] = 0x0000_0001, Reg[P1] = 1, Reg[P2] = 0

{  NOP  |  (P7) SLT.H D2, P1, P2, D1, D0   |   NOP  |  NOP  |  NOP  }
;Not execute

{  NOP  |  (P1) SLTU.H D3, P3, P4, D0, D1   |   NOP  |  NOP  |  NOP  }
;Reg[D3] = 0x0000_0000, Reg[P3] = 0, Reg[P4] = 1

{  NOP  |  (P2) SLTU.H D3, P3, P4, D1, D0   |   NOP  |  NOP  |  NOP  }
;Not execute

{  NOP  |  (P4) SGT.H D4, P5, P6, D0, D1   |   NOP  |  NOP  |  NOP  }
;Reg[D4] = 0x0000_0000, Reg[P5] = 0, Reg[P6] = 1

{  NOP  |  (P3) SGT.H D4, P5, P6, D1, D0   |   NOP  |  NOP  |  NOP  }
;Not execute

{  NOP  |  (P6) SGTU.H D5, P7, P8, D0, D1   |   NOP  |  NOP  |  NOP  }
;Reg[D5] = 0x0000_0001, Reg[P7] = 1, Reg[P8] = 0

{  NOP  |  (P5) SGTU.H D5, P7, P8, D1, D0   |   NOP  |  NOP  |  NOP  }
;Not execute
;-------------------------------------------------------------- Store Result
{  NOP  |  SW D0, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0030] = 0x8000_0000, Reg[A0] = 0x0000_0034

{  NOP  |  SW D1, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0034] = 0x7FFF_FFFF, Reg[A0] = 0x0000_0038

{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0038] = 0x0000_0001, Reg[A0] = 0x0000_003C

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_003C] = 0x0000_0000, Reg[A0] = 0x0000_0040

{  NOP  |  SW D4, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0040] = 0x0000_0000, Reg[A0] = 0x0000_0044

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0044] = 0x0000_0001, Reg[A0] = 0x0000_0048


;************************************************************** SLTI(U), SGTI(U), SEQI(U) --4byte
{  NOP  |  MOVI.L D0, 0xFFFE  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x8000_FFFF

{  NOP  |  MOVI.H D0, 0xFFFF  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0xFFFF_FFFE

{  NOP  |  (P7) SLTI D1, P1, P2, D0, 0xFFFF8000   |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x0000_0000, Reg[P1] = 0, Reg[P2] = 1

{  NOP  |  (P8) SLTI D1, P1, P2, D0, 0x00000000   |  NOP  |  NOP  |  NOP  }
;Not execute

{  NOP  |  (P2) SLTIU D2, P3, P4, D0, 0xFFFF8000   |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0x0000_0000, Reg[P3] = 0, Reg[P4] = 1				

{  NOP  |  (P1) SLTIU D2, P3, P4, D0, 0xFFFFFFFF   |  NOP  |  NOP  |  NOP  }
;Not execute

{  NOP  |  (P4) SGTI D3, P5, P6, D0, 0xFFFF8000   |  NOP  |  NOP  |  NOP  }
;Reg[D3] = 0x0000_0001, Reg[P5] = 1, Reg[P6] = 0

{  NOP  |  (P3) SGTI D3, P5, P6, D0, 0x80000000   |  NOP  |  NOP  |  NOP  }
;Not execute

{  NOP  |  (P5) SGTIU D4, P7, P8, D0, 0xFFFF8000   |  NOP  |  NOP  |  NOP  }
;Reg[D4] = 0x0000_0001, Reg[P7] = 1, Reg[P8] = 0				

{  NOP  |  (P6) SGTIU D4, P7, P8, D0, 0xFFFFFFFF   |  NOP  |  NOP  |  NOP  }
;Not execute

{  NOP  |  (P7) SEQI D5, P9, P10, D0, 0xFFFFFFFE   |  NOP  |  NOP  |  NOP  }
;Reg[D5] = 0x0000_0001, Reg[P9] = 1, Reg[P10] = 0

{  NOP  |  (P8) SEQI D5, P9, P10, D0, 0xFFFFFF00   |  NOP  |  NOP  |  NOP  }
;Not execute

{  NOP  |  (P9) SEQIU D6, P11, P12, D0, 0xFFFF0000   |  NOP  |  NOP  |  NOP  }
;Reg[D6] = 0x0000_0000, Reg[P11] = 0, Reg[P12] = 1

{  NOP  |  (P10) SEQIU D6, P11, P12, D0, 0xFFFFFFFE   |  NOP  |  NOP  |  NOP  }
;Not execute
;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D0, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0048] = 0xFFFF_FFFE, Reg[A0] = 0x0000_004C

{  NOP  |  SW D1, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_004C] = 0x0000_0000, Reg[A0] = 0x0000_0050			

{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0050] = 0x0000_0000, Reg[A0] = 0x0000_0054			

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0054] = 0x0000_0001, Reg[A0] = 0x0000_0058

{  NOP  |  SW D4, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0058] = 0x0000_0001, Reg[A0] = 0x0000_005C 			

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_005C] = 0x0000_0001, Reg[A0] = 0x0000_0060

{  NOP  |  SW D6, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0060] = 0x0000_0000, Reg[A0] = 0x0000_0064

;************************************************************** SLTI(U), SGTI(U), SEQI(U) --3byte
{  NOP  |  MOVI.L D0, 0xFFFE  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x8000_FFFE

{  NOP  |  MOVI.H D0, 0xFFFF  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0xFFFF_FFFE

{  NOP  |  (P12) SLTI D1, P1, P2, D0, 0x00FF8000   |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x0000_0001, Reg[P1] = 1, Reg[P2] = 0

{  NOP  |  (P11) SLTI D1, P1, P2, D0, 0xFF000000   |  NOP  |  NOP  |  NOP  }
;Not execute

{  NOP  |  (P1) SLTIU D2, P3, P4, D0, 0x00FF8000   |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0x0000_0000, Reg[P3] = 0, Reg[P4] = 1				******** Sam

{  NOP  |  (P2) SLTIU D2, P3, P4, D0, 0xFFFFFFFF   |  NOP  |  NOP  |  NOP  }
;Not execute

{  NOP  |  (P4) SGTI D3, P5, P6, D0, 0x00FF8000   |  NOP  |  NOP  |  NOP  }
;Reg[D3] = 0x0000_0000, Reg[P5] = 0, Reg[P6] = 1

{  NOP  |  (P3) SGTI D3, P5, P6, D0, 0xFFFFFF00   |  NOP  |  NOP  |  NOP  }
;Not execute

{  NOP  |  (P6) SGTIU D4, P7, P8, D0, 0x00FF8000   |  NOP  |  NOP  |  NOP  }
;Reg[D4] = 0x0000_0001, Reg[P7] = 1, Reg[P8] = 0				******** Sam

{  NOP  |  (P5) SGTIU D4, P7, P8, D0, 0xFFFFFFFF   |  NOP  |  NOP  |  NOP  }
;Not execute

{  NOP  |  (P7) SEQI D5, P9, P10, D0, 0x00FFFFFE   |  NOP  |  NOP  |  NOP  }
;Reg[D5] = 0x0000_0000, Reg[P9] = 0, Reg[P10] = 1

{  NOP  |  (P8) SEQI D5, P9, P10, D0, 0xFFFFFFFE   |  NOP  |  NOP  |  NOP  }
;Not execute

{  NOP  |  (P10) SEQIU D6, P11, P12, D0, 0x00FF0000   |  NOP  |  NOP  |  NOP  }
;Reg[D6] = 0x0000_0000, Reg[P11] = 0, Reg[P12] = 1

{  NOP  |  (P9) SEQIU D6, P11, P12, D0, 0xFFFFFFFE   |  NOP  |  NOP  |  NOP  }
;Not execute
;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D0, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0064] = 0xFFFF_FFFE, Reg[A0] = 0x0000_0068

{  NOP  |  SW D1, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0068] = 0x0000_0001, Reg[A0] = 0x0000_006C			

{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_006C] = 0x0000_0000, Reg[A0] = 0x0000_0070			******** Sam

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0070] = 0x0000_0000, Reg[A0] = 0x0000_0074

{  NOP  |  SW D4, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0074] = 0x0000_0001, Reg[A0] = 0x0000_0078 			******** Sam

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0078] = 0x0000_0000, Reg[A0] = 0x0000_007C

{  NOP  |  SW D6, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_007C] = 0x0000_0000, Reg[A0] = 0x0000_0080

;************************************************************** SLTI(U), SGTI(U), SEQI(U) --2byte
{  NOP  |  MOVI.L D0, 0xFFFE  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x8000_FFFE

{  NOP  |  MOVI.H D0, 0xFFFF  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0xFFFF_FFFE

{  NOP  |  (P12) SLTI D1, P1, P2, D0, 0x0000FF80   |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x0000_0001, Reg[P1] = 1, Reg[P2] = 0

{  NOP  |  (P11) SLTI D1, P1, P2, D0, 0xFF000000   |  NOP  |  NOP  |  NOP  }
;Not execute

{  NOP  |  (P1) SLTIU D2, P3, P4, D0, 0x0000FF80   |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0x0000_0000, Reg[P3] = 0, Reg[P4] = 1				******** Sam

{  NOP  |  (P2) SLTIU D2, P3, P4, D0, 0xFFFFFFFF   |  NOP  |  NOP  |  NOP  }
;Not execute

{  NOP  |  (P4) SGTI D3, P5, P6, D0, 0x0000FF80   |  NOP  |  NOP  |  NOP  }
;Reg[D3] = 0x0000_0000, Reg[P5] = 0, Reg[P6] = 1

{  NOP  |  (P3) SGTI D3, P5, P6, D0, 0xFFFFFF00   |  NOP  |  NOP  |  NOP  }
;Not execute

{  NOP  |  (P6) SGTIU D4, P7, P8, D0, 0x0000FF80   |  NOP  |  NOP  |  NOP  }
;Reg[D4] = 0x0000_0001, Reg[P7] = 1, Reg[P8] = 0				******** Sam

{  NOP  |  (P5) SGTIU D4, P7, P8, D0, 0xFFFFFFFF   |  NOP  |  NOP  |  NOP  }
;Not execute

{  NOP  |  (P7) SEQI D5, P9, P10, D0, 0x0000FFFE   |  NOP  |  NOP  |  NOP  }
;Reg[D5] = 0x0000_0000, Reg[P9] = 0, Reg[P10] = 1

{  NOP  |  (P8) SEQI D5, P9, P10, D0, 0xFFFFFFFE   |  NOP  |  NOP  |  NOP  }
;Not execute

{  NOP  |  (P10) SEQIU D6, P11, P12, D0, 0x0000FFFE   |  NOP  |  NOP  |  NOP  }
;Reg[D6] = 0x0000_0000, Reg[P11] = 0, Reg[P12] = 1

{  NOP  |  (P9) SEQIU D6, P11, P12, D0, 0xFFFFFFFE   |  NOP  |  NOP  |  NOP  }
;Not execute
;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D0, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0080] = 0xFFFF_FFFE, Reg[A0] = 0x0000_0084

{  NOP  |  SW D1, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0084] = 0x0000_0001, Reg[A0] = 0x0000_0088			

{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0088] = 0x0000_0000, Reg[A0] = 0x0000_008C			******** Sam

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_008C] = 0x0000_0000, Reg[A0] = 0x0000_0090

{  NOP  |  SW D4, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0090] = 0x0000_0001, Reg[A0] = 0x0000_0094 			******** Sam

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0094] = 0x0000_0000, Reg[A0] = 0x0000_0098

{  NOP  |  SW D6, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0098] = 0x0000_0000, Reg[A0] = 0x0000_009C

;************************************************************** SLTI(U), SGTI(U), SEQI(U) --1byte
{  NOP  |  MOVI.L D0, 0xFFFE  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x8000_FFFE

{  NOP  |  MOVI.H D0, 0xFFFF  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0xFFFF_FFFE

{  NOP  |  (P12) SLTI D1, P1, P2, D0, 0x00000080   |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x0000_0001, Reg[P1] = 1, Reg[P2] = 0

{  NOP  |  (P11) SLTI D1, P1, P2, D0, 0xFF000000   |  NOP  |  NOP  |  NOP  }
;Not execute

{  NOP  |  (P1) SLTIU D2, P3, P4, D0, 0x00000080   |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0x0000_0000, Reg[P3] = 0, Reg[P4] = 1				******** Sam

{  NOP  |  (P2) SLTIU D2, P3, P4, D0, 0xFFFFFFFF   |  NOP  |  NOP  |  NOP  }
;Not execute

{  NOP  |  (P4) SGTI D3, P5, P6, D0, 0x00000080   |  NOP  |  NOP  |  NOP  }
;Reg[D3] = 0x0000_0000, Reg[P5] = 0, Reg[P6] = 1

{  NOP  |  (P3) SGTI D3, P5, P6, D0, 0xFFFFFF00   |  NOP  |  NOP  |  NOP  }
;Not execute

{  NOP  |  (P6) SGTIU D4, P7, P8, D0, 0x00000080   |  NOP  |  NOP  |  NOP  }
;Reg[D4] = 0x0000_0001, Reg[P7] = 1, Reg[P8] = 0				******** Sam

{  NOP  |  (P5) SGTIU D4, P7, P8, D0, 0xFFFFFFFF   |  NOP  |  NOP  |  NOP  }
;Not execute

{  NOP  |  (P7) SEQI D5, P9, P10, D0, 0x000000FE   |  NOP  |  NOP  |  NOP  }
;Reg[D5] = 0x0000_0000, Reg[P9] = 0, Reg[P10] = 1

{  NOP  |  (P8) SEQI D5, P9, P10, D0, 0xFFFFFFFE   |  NOP  |  NOP  |  NOP  }
;Not execute

{  NOP  |  (P10) SEQIU D6, P11, P12, D0, 0x000000FE   |  NOP  |  NOP  |  NOP  }
;Reg[D6] = 0x0000_0000, Reg[P11] = 0, Reg[P12] = 1

{  NOP  |  (P9) SEQIU D6, P11, P12, D0, 0xFFFFFFFE   |  NOP  |  NOP  |  NOP  }
;Not execute
;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D0, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_009C] = 0xFFFF_FFFE, Reg[A0] = 0x0000_00A0

{  NOP  |  SW D1, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_00A0] = 0x0000_0001, Reg[A0] = 0x0000_00A4			

{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_00A4] = 0x0000_0000, Reg[A0] = 0x0000_00A8			******** Sam

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_00A8] = 0x0000_0000, Reg[A0] = 0x0000_00AC

{  NOP  |  SW D4, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_00AC] = 0x0000_0001, Reg[A0] = 0x0000_00B0 			******** Sam

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_00B0] = 0x0000_0000, Reg[A0] = 0x0000_00B4

{  NOP  |  SW D6, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_00B4] = 0x0000_0000, Reg[A0] = 0x0000_00B8

;************************************************************** SLTI(U), SGTI(U), SEQI(U) --0byte
{  NOP  | MOVI.L D0, 0xFFFE  |   NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x8000_FFFE

{  NOP  |  MOVI.H D0, 0xFFFF  |   NOP  |  NOP  |  NOP  }
;Reg[D0] = 0xFFFF_FFFE

{  NOP  |  (P12) SLTI D1, P1, P2, D0, 0x00000000   |   NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x0000_0001, Reg[P1] = 1, Reg[P2] = 0

{  NOP  |  (P11) SLTI D1, P1, P2, D0, 0xFF000000   |   NOP  |  NOP  |  NOP  }
;Not execute

{  NOP  |  (P1) SLTIU D2, P3, P4, D0, 0x00000000   |   NOP  |  NOP  |  NOP  }
;Reg[D2] = 0x0000_0000, Reg[P3] = 0, Reg[P4] = 1				******** Sam

{  NOP  |  (P2) SLTIU D2, P3, P4, D0, 0xFFFFFFFF   |   NOP  |  NOP  |  NOP  }
;Not execute

{  NOP  |  (P4) SGTI D3, P5, P6, D0, 0x00000000   |   NOP  |  NOP  |  NOP  }
;Reg[D3] = 0x0000_0000, Reg[P5] = 0, Reg[P6] = 1

{  NOP  |  (P3) SGTI D3, P5, P6, D0, 0xFFFFFF00   |   NOP  |  NOP  |  NOP  }
;Not execute

{  NOP  |  (P6) SGTIU D4, P7, P8, D0, 0x00000000   |   NOP  |  NOP  |  NOP  }
;Reg[D4] = 0x0000_0001, Reg[P7] = 1, Reg[P8] = 0				******** Sam

{  NOP  |  (P5) SGTIU D4, P7, P8, D0, 0xFFFFFFFF   |   NOP  |  NOP  |  NOP  }
;Not execute

{  NOP  |  (P7) SEQI D5, P9, P10, D0, 0x00000000   |   NOP  |  NOP  |  NOP  }
;Reg[D5] = 0x0000_0000, Reg[P9] = 0, Reg[P10] = 1

{  NOP  |  (P8) SEQI D5, P9, P10, D0, 0xFFFFFFFE   |   NOP  |  NOP  |  NOP  }
;Not execute

{  NOP  |  (P10) SEQIU D6, P11, P12, D0, 0x00000000   |   NOP  |  NOP  |  NOP  }
;Reg[D6] = 0x0000_0000, Reg[P11] = 0, Reg[P12] = 1

{  NOP  |  (P9) SEQIU D6, P11, P12, D0, 0xFFFFFFFE   |   NOP  |  NOP  |  NOP  }
;Not execute
;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D0, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_00B8] = 0xFFFF_FFFE, Reg[A0] = 0x0000_00BC

{  NOP  |  SW D1, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_00BC] = 0x0000_0001, Reg[A0] = 0x0000_00C0			

{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_00C0] = 0x0000_0000, Reg[A0] = 0x0000_00C4			******** Sam

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_00C4] = 0x0000_0000, Reg[A0] = 0x0000_00C8

{  NOP  |  SW D4, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_00C8] = 0x0000_0001, Reg[A0] = 0x0000_00CC 			******** Sam

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_00CC] = 0x0000_0000, Reg[A0] = 0x0000_00D0

{  NOP  |  SW D6, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_00D0] = 0x0000_0000, Reg[A0] = 0x0000_00D4


;************************************************************** SEQ, SEQ.L, SEQ.H
{  NOP  |  MOVI.L D0, 0xFFFF  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0xFFFF_FFFF

{  NOP  |  MOVI.H D0, 0x7FFF  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x7FFF_FFFF

{  NOP  |  MOVI.L D1, 0xFFFF  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x0000_FFFF

{  NOP  |  MOVI.H D1, 0xFFFF  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0xFFFF_FFFF

{  NOP  |  MOVI.L D7, 0x7FFF  |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0x0000_7FFF

{  NOP  |  MOVI.H D7, 0xFFFF  |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0xFFFF_7FFF

{  NOP  |  (P12) SEQ D2, P1, P2, D0, D1   |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0x0000_0000, Reg[P1] = 0, Reg[P2] = 1

{  NOP  |  (P11) SEQ D2, P1, P2, D0, D0   |  NOP  |  NOP  |  NOP  }
;Not execute

{   NOP  |  (P2) SEQ.L D3, P3, P4, D0, D1   |  NOP  |  NOP  |  NOP  }
;Reg[D3] = 0x0000_0001, Reg[P3] = 1, Reg[P4] = 0

{  NOP  |  (P1) SEQ.L D3, P3, P4, D0, D7   |  NOP  |  NOP  |  NOP  }
;Not execute

{  NOP  |  (P3) SEQ.H D4, P5, P6, D0, D1   |  NOP  |  NOP  |  NOP  }
;Reg[D4] = 0x0000_0000, Reg[P5] = 0, Reg[P6] = 1

{  NOP  |  (P4) SEQ.H D4, P5, P6, D1, D7   |  NOP  |  NOP  |  NOP  }
;Not execute

;-------------------------------------------------------------- Store Result
{  NOP  |  SW D0, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_00D4] = 0x7FFF_FFFF, Reg[A0] = 0x0000_00D8

{  NOP  |  SW D1, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_00D8] = 0xFFFF_FFFF, Reg[A0] = 0x0000_00DC

{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_00DC] = 0x0000_0000, Reg[A0] = 0x0000_00E0

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_00E0] = 0x0000_0001, Reg[A0] = 0x0000_00E4

{  NOP  |  SW D4, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_00E4] = 0x0000_0000, Reg[A0] = 0x0000_00E8


;************************************************************** MIN(U), MIN(U).D, MIN(U).Q, DMIN(U) -- With condition bit
{  NOP  |  MOVI.L D0, 0x8000  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x7FFF_8000

{  NOP  |  MOVI.H D0, 0x7FFF  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x7FFF_8000

{  NOP  |  MOVI.L D1, 0x7FFF  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0xFFFF_7FFF

{  NOP  |  MOVI.H D1, 0x8000  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x8000_7FFF

{  NOP  |  MOVI.L D2, 0xFFFF  |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0xFFFF_FFFF

{  NOP  |  MOVI.H D2, 0xFFFF  |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0xFFFF_FFFF

{  NOP  |  (P6) MIN D3, D0, D1  |  NOP  |  NOP  |  NOP  }
;Reg[D3] = 0x8000_7FFF

{  NOP  |  (P5) MIN D3, D2, D0  |  NOP  |  NOP  |  NOP  }
;Not execute

{  NOP  |  (P6) MINU D4, D0, D1  |  NOP  |  NOP  |  NOP  }
;Reg[D4] = 0x7FFF_8000

{  NOP  |  (P5) MINU D4, D1, D2  |  NOP  |  NOP  |  NOP  }
;Not execute

{  NOP  |  (P6) MIN.D D5, D0, D1  |  NOP  |  NOP  |  NOP  }
;Reg[D5] = 0x8000_8000

{  NOP  |  (P5) MIN.D D5, D1, D2  |  NOP  |  NOP  |  NOP  }
;Not execute

{  NOP  |  (P6) MINU.D D6, D0, D1  |  NOP  |  NOP  |  NOP  }
;Reg[D6] = 0x7FFF_7FFF

{  NOP  |  (P5) MINU.D D6, D0, D2  |  NOP  |  NOP  |  NOP  }
;Not execute

{  NOP  |  (P6) MIN.Q D7, D0, D1  |  NOP  |  NOP  |  NOP  }
;Reg[D7] = 0x80FF_80FF

{  NOP  |  (P5) MIN.Q D7, D0, D2  |  NOP  |  NOP  |  NOP  }
;Not execute

{  NOP  |  (P6) MINU.Q D8, D0, D1  |  NOP  |  NOP  |  NOP  }
;Reg[D8] = 0x7F00_7F00

{  NOP  |  (P5) MINU.Q D8, D0, D2  |  NOP  |  NOP  |  NOP  }
;Not execute

{  NOP  |  (P6) DMIN D9, D0  |  NOP  |  NOP  |  NOP  }
;Reg[D9] = 0xFFFF_8000

{  NOP  |  (P5) DMIN D9, D2  |  NOP  |  NOP  |  NOP  }
;Not execute

{  NOP  |  (P6) DMINU D10, D0  |  NOP  |  NOP  |  NOP  }
;Reg[D10] = 0x0000_7FFF

{  NOP  |  (P5) DMINU D10, D2  |  NOP  |  NOP  |  NOP  }
;Not execute
;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D0, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_00E8] = 0x7FFF_8000, Reg[A0] = 0x0000_00EC

{  NOP  |  SW D1, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_00EC] = 0x8000_7FFF, Reg[A0] = 0x0000_00F0

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_00F0] = 0x8000_7FFF, Reg[A0] = 0x0000_00F4

{  NOP  |  SW D4, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_00F4] = 0x7FFF_8000, Reg[A0] = 0x0000_00F8

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_00F8] = 0x8000_8000, Reg[A0] = 0x0000_00FC

{  NOP  |  SW D6, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_00FC] = 0x7FFF_7FFF, Reg[A0] = 0x0000_0100

{  NOP  |  SW D7, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0100] = 0x80FF_80FF, Reg[A0] = 0x0000_0104

{  NOP  |  SW D8, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0104] = 0x7F00_7F00, Reg[A0] = 0x0000_0108

{  NOP  |  SW D9, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0108] = 0xFFFF_8000, Reg[A0] = 0x0000_010C

{  NOP  |  SW D10, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_010C] = 0x0000_7FFF, Reg[A0] = 0x0000_0110


;************************************************************** MAX(U), MAX(U).D, MAX(U).Q, DMAX(U) -- With condition bit
{  NOP  |  MOVI.L D0, 0x8000  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x7FFF_8000

{  NOP  |  MOVI.H D0, 0x7FFF  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x7FFF_8000

{  NOP  |  MOVI.L D1, 0x7FFF  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x8000_7FFF

{  NOP  |  MOVI.H D1, 0x8000  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x8000_7FFF

{  NOP  |  MOVI.L D2, 0xFFFF  |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0xFFFF_FFFF

{  NOP  |  MOVI.H D2, 0xFFFF  |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0xFFFF_FFFF

{  NOP  |  (P6) MAX D3, D0, D1  |  NOP  |  NOP  |  NOP  }
;Reg[D3] = 0x7FFF_8000

{  NOP  |  (P5) MAX D3, D2, D1  |  NOP  |  NOP  |  NOP  }
;Not execute

{  NOP  |  (P6) MAXU D4, D0, D1  |  NOP  |  NOP  |  NOP  }
;Reg[D4] = 0x8000_7FFF

{  NOP  |  (P5) MAXU D4, D0, D2  |  NOP  |  NOP  |  NOP  }
;Not execute

{  NOP  |  (P6) MAX.D D5, D0, D1  |  NOP  |  NOP  |  NOP  }
;Reg[D5] = 0x7FFF_7FFF

{  NOP  |  (P5) MAX.D D5, D0, D2  |  NOP  |  NOP  |  NOP  }
;Not execute

{  NOP  |   (P6) MAXU.D D6, D0, D1  |  NOP  |  NOP  |  NOP  }
;Reg[D6] = 0x8000_8000

{  NOP  |   (P5) MAXU.D D6, D0, D2  |  NOP  |  NOP  |  NOP  }
;Not execute

{  NOP  |  (P6) MAX.Q D7, D0, D1  |  NOP  |  NOP  |  NOP  }
;Reg[D7] = 0x7F00_7F00

{  NOP  |  (P5) MAX.Q D7, D0, D2  |  NOP  |  NOP  |  NOP  }
;Not execute

{  NOP  |  (P6) MAXU.Q D8, D0, D1  |  NOP  |  NOP  |  NOP  }
;Reg[D8] = 0x80FF_80FF

{  NOP  |  (P5) MAXU.Q D8, D0, D2  |  NOP  |  NOP  |  NOP  }
;Not execute

{  NOP  |  (P6) DMAX D9, D0  |  NOP  |  NOP  |  NOP  }
;Reg[D9] = 0x0000_7FFF

{  NOP  |  (P5) DMAX D9, D2  |  NOP  |  NOP  |  NOP  }
;Not execute

{  NOP  |  (P6) DMAXU D10, D0  |  NOP  |  NOP  |  NOP  }
;Reg[D10] = 0x0000_8000

{  NOP  |  (P5) DMAXU D10, D2  |  NOP  |  NOP  |  NOP  }
;Not execute
;-------------------------------------------------------------- Store Result
{  NOP  |  SW D0, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0110] = 0x7FFF_8000, Reg[A0] = 0x0000_0114

{  NOP  |  SW D1, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0114] = 0x8000_7FFF, Reg[A0] = 0x0000_0118

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0118] = 0x7FFF_8000, Reg[A0] = 0x0000_011C

{  NOP  |  SW D4, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_011C] = 0x8000_7FFF, Reg[A0] = 0x0000_0120

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0120] = 0x7FFF_7FFF, Reg[A0] = 0x0000_0124

{  NOP  |  SW D6, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0124] = 0x8000_8000, Reg[A0] = 0x0000_0128

{  NOP  |  SW D7, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0128] = 0x7F00_7F00, Reg[A0] = 0x0000_012C

{  NOP  |  SW D8, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_012C] = 0x80FF_80FF, Reg[A0] = 0x0000_0130

{  NOP  |  SW D9, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0130] = 0x0000_7FFF, Reg[A0] = 0x0000_0134

{  NOP  |  SW D10, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0134] = 0x0000_8000, Reg[A0] = 0x0000_0138 


;************************************************************** MIN(U), MIN(U).D, MIN(U).Q, DMIN(U) -- Without condition bit
{  NOP  |  MOVI.L D0, 0x8000  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x7FFF_8000

{  NOP  |  MOVI.H D0, 0x7FFF  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x7FFF_8000

{  NOP  |  MOVI.L D1, 0x7FFF  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0xFFFF_7FFF

{  NOP  |  MOVI.H D1, 0x8000  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x8000_7FFF

{  NOP  |  MIN D2, D0, D1  |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0x8000_7FFF

{  NOP  |  MINU D3, D0, D1  |  NOP  |  NOP  |  NOP  }
;Reg[D3] = 0x7FFF_8000

{  NOP  |  MIN.D D4, D0, D1  |  NOP  |  NOP  |  NOP  }
;Reg[D4] = 0x8000_8000

{  NOP  |  MINU.D D5, D0, D1  |  NOP  |  NOP  |  NOP  }
;Reg[D5] = 0x7FFF_7FFF

{  NOP  |  MIN.Q D6, D0, D1  |  NOP  |  NOP  |  NOP  }
;Reg[D6] = 0x80FF_80FF

{  NOP  |  MINU.Q D7, D0, D1  |  NOP  |  NOP  |  NOP  }
;Reg[D7] = 0x7F00_7F00

{  NOP  |  DMIN D8, D0  |  NOP  |  NOP  |  NOP  }
;Reg[D8] = 0xFFFF_8000

{  NOP  |  DMINU D9, D0  |  NOP  |  NOP  |  NOP  }
;Reg[D9] = 0x0000_7FFF
;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D0, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0138] = 0x7FFF_8000, Reg[A0] = 0x0000_013C

{  NOP  |  SW D1, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_013C] = 0x8000_7FFF, Reg[A0] = 0x0000_0140

{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0140] = 0x8000_7FFF, Reg[A0] = 0x0000_0144

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0144] = 0x7FFF_8000, Reg[A0] = 0x0000_0148

{  NOP  |  SW D4, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0148] = 0x8000_8000, Reg[A0] = 0x0000_014C

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_014C] = 0x7FFF_7FFF, Reg[A0] = 0x0000_0150

{  NOP  |  SW D6, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0150] = 0x80FF_80FF, Reg[A0] = 0x0000_0154

{  NOP  |  SW D7, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0154] = 0x7F00_7F00, Reg[A0] = 0x0000_0158

{  NOP  |  SW D8, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0158] = 0xFFFF_8000, Reg[A0] = 0x0000_015C

{  NOP  |  SW D9, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_015C] = 0x0000_7FFF, Reg[A0] = 0x0000_0160


;************************************************************** MAX(U), MAX(U).D, MAX(U).Q, DMAX(U) -- Without condition bit
{  NOP  |  MOVI.L D0, 0x8000  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x7FFF_8000

{  NOP  |  MOVI.H D0, 0x7FFF  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x7FFF_8000

{  NOP  |  MOVI.L D1, 0x7FFF  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x8000_7FFF

{  NOP  |  MOVI.H D1, 0x8000  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x8000_7FFF

{  NOP  |  MOVI.L D2, 0xFFFF  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0xFFFF_FFFF

{  NOP  |  MOVI.H D2, 0xFFFF  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0xFFFF_FFFF

{  NOP  |  MAX D2, D0, D1  |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0x7FFF_8000

{  NOP  |  MAXU D3, D0, D1  |  NOP  |  NOP  |  NOP  }
;Reg[D3] = 0x8000_7FFF

{  NOP  |  MAX.D D4, D0, D1  |  NOP  |  NOP  |  NOP  }
;Reg[D4] = 0x7FFF_7FFF

{  NOP  |   MAXU.D D5, D0, D1  |  NOP  |  NOP  |  NOP  }
;Reg[D5] = 0x8000_8000

{  NOP  |  MAX.Q D6, D0, D1  |  NOP  |  NOP  |  NOP  }
;Reg[D6] = 0x7F00_7F00

{  NOP  |  MAXU.Q D7, D0, D1  |  NOP  |  NOP  |  NOP  }
;Reg[D7] = 0x80FF_80FF

{  NOP  |  DMAX D8, D0  |  NOP  |  NOP  |  NOP  }
;Reg[D8] = 0x0000_7FFF

{  NOP  |  DMAXU D9, D0  |  NOP  |  NOP  |  NOP  }
;Reg[D9] = 0x0000_8000
;-------------------------------------------------------------- Store Result
{  NOP  |  SW D0, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0160] = 0x7FFF_8000, Reg[A0] = 0x0000_0164

{  NOP  |  SW D1, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0164] = 0x8000_7FFF, Reg[A0] = 0x0000_0168

{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0168] = 0x7FFF_8000, Reg[A0] = 0x0000_016C

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_016C] = 0x8000_7FFF, Reg[A0] = 0x0000_0170

{  NOP  |  SW D4, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0170] = 0x7FFF_7FFF, Reg[A0] = 0x0000_0174

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0174] = 0x8000_8000, Reg[A0] = 0x0000_0178

{  NOP  |  SW D6, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0178] = 0x7F00_7F00, Reg[A0] = 0x0000_017C

{  NOP  |  SW D7, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_017C] = 0x80FF_80FF, Reg[A0] = 0x0000_0180

{  NOP  |  SW D8, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0180] = 0x0000_7FFF, Reg[A0] = 0x0000_0184

{  NOP  |  SW D9, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0184] = 0x0000_8000, Reg[A0] = 0x0000_0188 



;************************************************************** Program Terminate
{  TRAP  |  NOP  |  NOP  |  NOP  |  NOP  }
