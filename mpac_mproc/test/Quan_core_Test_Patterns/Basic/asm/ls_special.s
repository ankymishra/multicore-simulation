
BASE_ADDR = 0x2400

;************************************************************** Set Start Address
{  COPY R0, SR15   |  MOVI.L A0, 0x0000    |  NOP  |  NOP  |  NOP  }
{  SLLI R0, R0, 20 |  MOVI.H A0, BASE_ADDR |  NOP  |  NOP  |  NOP  } ; modify by JH for 7056
{  BDT R0  |  BDR D0 |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  ADD A0, A0, D0       |  NOP  |  NOP  |  NOP  }


{  NOP  |  MOVI.L D0, 0x0123  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x0000_0123

{  NOP  |  MOVI.H D0, 0xABCD  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0xABCD_0123

{  NOP  |  MOVI.L D1, 0x1111  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x0000_1111

{  NOP  |  MOVI.H D1, 0x2222  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x2222_1111

{  NOP  |  MOVI.L D2, 0x0001  |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0x0000_0001

{  NOP  |  MOVI.H D2, 0x0000  |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0x0000_0001

{  NOP  |  NOP  |  SLTI D6, P14, P15, D0, 0x00000000   |  NOP  |  NOP  }
;Reg[D6] = 0x0000_0001, Reg[P14] = 1, Reg[P15] = 0

;************************************************************** LMBD
{  NOP  |  (P14) LMBD D3, D0  |  NOP  |  NOP  |  NOP  }
;Reg[D3] = 0x0000_0000

{  NOP  |  (P15) LMBD D3, D1  |  NOP  |  NOP  |  NOP  }
;Not execute

{  NOP  |  (P14) LMBD D4, D1  |  NOP  |  NOP  |  NOP  }
;Reg[D3] = 0x0000_0002

{  NOP  |  (P14) LMBD D5, D2  |  NOP  |  NOP  |  NOP  }
;Reg[D3] = 0x0000_001F

{  NOP  |  (P14) LMBD D6, D3  |  NOP  |  NOP  |  NOP  }
;Reg[D3] = 0x0000_0020

;-------------------------------------------------------------- Store Result
{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0000] = 0x0000_0000, Reg[A0] = 0x0000_0004

{  NOP  |  SW D4, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0004] = 0x0000_0002, Reg[A0] = 0x0000_0004

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0008] = 0x0000_001F, Reg[A0] = 0x0000_0004

{  NOP  |  SW D6, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_000C] = 0x0000_0020, Reg[A0] = 0x0000_0004

;************************************************************** DCLR
{  NOP  |  (P14) DCLR D0  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x0000_0000, Reg[D1] = 0x0000_0000

{  NOP  |  (P15) DCLR D2  |  NOP  |  NOP  |  NOP  }
;Not execute

{  NOP  |  DCLR D2  |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0x0000_0000, Reg[D3] = 0x0000_0000

;-------------------------------------------------------------- Store Result
{  NOP  |  SW D0, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0010] = 0x0000_0000, Reg[A0] = 0x0000_0008

{  NOP  |  SW D1, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0014] = 0x0000_0000, Reg[A0] = 0x0000_000C

{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0018] = 0x0000_0000, Reg[A0] = 0x0000_0010

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_001C] = 0x0000_0000, Reg[A0] = 0x0000_0014


;************************************************************** Program Terminate
{  TRAP  |  NOP  |  NOP  |  NOP  |  NOP  }
