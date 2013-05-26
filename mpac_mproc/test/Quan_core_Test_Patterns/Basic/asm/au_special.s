
BASE_ADDR = 0x2400

;************************************************************** Set Start Address

{  COPY R0, SR15   |  MOVI.L A0, 0x0000    |  MOVI AU_PSR, 0x0000000  |  NOP  |  NOP  }

{  SLLI R0, R0, 20 |  MOVI.H A0, BASE_ADDR |  NOP  |  NOP  |  NOP  }   ;Reg[A0] = 0x24?0_0000,

{  BDT R0  | BDR D0  |  NOP  |  NOP  |  NOP  }

{  NOP  | NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  | NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  ADD A0, A0, D0  |  NOP  |  NOP  |  NOP  }


;**************************************************************

{  NOP  |  NOP  |  MOVI.L D0, 0x0000  |  NOP  |  NOP  }
;Reg[D0] = 0x0000_0000

{  NOP  |  NOP  |  MOVI.H D0, 0x8000  |  NOP  |  NOP  }
;Reg[D0] = 0x8000_0000

{  NOP  |  NOP  |  SLTI D6, P14, P15, D0, 0x00000000   |  NOP  |  NOP  }
;Reg[D6] = 0x0000_0001, Reg[P14] = 1, Reg[P15] = 0
;************************************************************** BF.(D)
{  NOP  |  NOP  |  MOVI.L D0, 0x1111  |  NOP  |  NOP  }
;Reg[D0] = 0x0000_1111

{  NOP  |  NOP  |  MOVI.H D0, 0x2222  |  NOP  |  NOP  }
;Reg[D0] = 0x2222_1111

{  NOP  |  NOP  |  MOVI.L D1, 0x2222  |  NOP  |  NOP  }
;Reg[D1] = 0x0000_2222

{  NOP  |  NOP  |  MOVI.H D1, 0x1111  |  NOP  |  NOP  }
;Reg[D1] = 0x1111_2222

{  NOP  |  NOP  |  (P14) BF D2, D0, D1  |  NOP  |  NOP  }
;Reg[D2] = 0x3333_3333, Reg[D3] = 0x1110_EEEF

{  NOP  |  NOP  |  (P15) BF D2, D0, D0  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  (P14) BF.D D4, D0, D1  |  NOP  |  NOP  }
;Reg[D4] = 0x3333_3333, Reg[D5] = 0x1111_EEEF

{  NOP  |  NOP  |  (P15) BF.D D4, D0, D0  |  NOP  |  NOP  }
;Not execute

;-------------------------------------------------------------- Store Result
{  NOP  |  SW D0, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0000] = 0x2222_1111, Reg[A0] = 0x0000_0004

{  NOP  |  SW D1, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0004] = 0x1111_2222, Reg[A0] = 0x0000_0008

{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0008] = 0x3333_3333, Reg[A0] = 0x0000_000C

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_000C] = 0x1110_EEEF, Reg[A0] = 0x0000_0010

{  NOP  |  SW D4, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0010] = 0x3333_3333, Reg[A0] = 0x0000_0014

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0014] = 0x1111_EEEF, Reg[A0] = 0x0000_0018


;************************************************************** SAA.Q
{  NOP  |  NOP  |  MOVI.L D0, 0x2211  |  NOP  |  NOP  }
;Reg[D0] = 0x2222_2211

{  NOP  |  NOP  |  MOVI.H D0, 0x4433  |  NOP  |  NOP  }
;Reg[D0] = 0x4433_2211

{  NOP  |  NOP  |  MOVI.L D1, 0x1122  |  NOP  |  NOP  }
;Reg[D1] = 0x1111_1122

{  NOP  |  NOP  |  MOVI.H D1, 0x3344  |  NOP  |  NOP  }
;Reg[D1] = 0x3344_1122

{  NOP  |  NOP  |  MOVI.L D2, 0x1111  |  NOP  |  NOP  }
;Reg[D2] = 0x3333_1111

{  NOP  |  NOP  |  MOVI.H D2, 0x2222  |  NOP  |  NOP  }
;Reg[D2] = 0x2222_1111

{  NOP  |  NOP  |  MOVI.L D3, 0x2222  |  NOP  |  NOP  }
;Reg[D3] = 0x1110_2222

{  NOP  |  NOP  |  MOVI.H D3, 0x1111  |  NOP  |  NOP  }
;Reg[D3] = 0x1111_2222


{  NOP  |  NOP  |  MOVIU AC0, 0x22221111  |  NOP  |  NOP  }
;Reg[AC0] = 0x00_0000_0000

{  NOP  |  NOP  |  MOVIU AC1, 0x11112222  |  NOP  |  NOP  }
;Reg[AC1] = 0x00_0000_0000

{  NOP  |  NOP  |  (P14) SAA.Q AC0, D0, D1  |  NOP  |  NOP  }
;Reg[AC0] = 0x2233_1122, Reg[AC1] = 0x1122_2233

{  NOP  |  NOP  |  (P15) SAA.Q AC0, D0, D0  |  NOP  |  NOP  }
;Not execute

;-------------------------------------------------------------- Store Result
{  NOP  |  SW D0, A0, 4+    |  COPY D2, AC0  |  NOP  |  NOP  }
;Mem[0x0000_0018] = 0x4433_2211, Reg[A0] = 0x0000_001C

{  NOP  |  SW D1, A0, 4+    |  COPY D3, AC1  |  NOP  |  NOP  }
;Mem[0x0000_001C] = 0x3344_1122, Reg[A0] = 0x0000_0020

{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0020] = 0x2233_1122, Reg[A0] = 0x0000_0024

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0024] = 0x1122_2233, Reg[A0] = 0x0000_0028


;************************************************************** SFRA.(D)
{  NOP  |  NOP  |  MOVI.L D0, 0x2222  |  NOP  |  NOP  }
;Reg[D0] = 0x4433_2222

{  NOP  |  NOP  |  MOVI.H D0, 0x1111  |  NOP  |  NOP  }
;Reg[D0] = 0x1111_2222

{  NOP  |  NOP  |  MOVI.L D1, 0x1111  |  NOP  |  NOP  }
;Reg[D1] = 0x3344_1111

{  NOP  |  NOP  |  MOVI.H D1, 0x1111  |  NOP  |  NOP  }
;Reg[D1] = 0x1111_1111

{  NOP  |  NOP  |  MOVI.L D2, 0x1111  |  NOP  |  NOP  }
;Reg[D2] = 0x2233_1111

{  NOP  |  NOP  |  MOVI.H D2, 0x1111  |  NOP  |  NOP  }
;Reg[D2] = 0x1111_1111

{  NOP  |  NOP  |  (P14) SFRA D1, D0, 0x2  |  NOP  |  NOP  }
;Reg[D1] = 0x1555_5999

{  NOP  |  NOP  |  (P15) SFRA D1, D0, 0x4  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  (P14) SFRA.D D2, D0, 0x2  |  NOP  |  NOP  }
;Reg[D2] = 0x1555_1999

{  NOP  |  NOP  |  (P15) SFRA.D D2, D0, 0x4  |  NOP  |  NOP  }
;Not execute
;-------------------------------------------------------------- Store Result
{  NOP  |  SW D0, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0028] = 0x1111_2222, Reg[A0] = 0x0000_002C

{  NOP  |  SW D1, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_002C] = 0x1555_5999, Reg[A0] = 0x0000_0030

{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0030] = 0x1555_1999, Reg[A0] = 0x0000_0034


;************************************************************** CLS, RND
{  NOP  |  NOP  |  DCLR D0  |  NOP  |  NOP  }
;Reg[D0] = 0x0000_0000, Reg[D1] = 0x0000_0000

{  NOP  |  NOP  |  MOVI.L D0, 0x8000  |  NOP  |  NOP  }
;Reg[D0] = 0x0000_8000

{  NOP  |  NOP  |  MOVI.H D0, 0x0001  |  NOP  |  NOP  }
;Reg[D0] = 0x0001_8000

{  NOP  |  NOP  |  MOVI.L D1, 0x8001  |  NOP  |  NOP  }
;Reg[D1] = 0x0000_8001

{  NOP  |  NOP  |  MOVI.H D1, 0x00FF  |  NOP  |  NOP  }
;Reg[D1] = 0x00FF_8001

{  NOP  |  NOP  |  (P14) CLS D2, D0  |  NOP  |  NOP  }
;Reg[D2] = 0x0000_000F

{  NOP  |  NOP  |  (P15) CLS D2, D1  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  (P14) RND D3, D0  |  NOP  |  NOP  }
;Reg[D3] = 0x0002_0000

{  NOP  |  NOP  |  (P15) RND D3, D1  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  (P14) RND D4, D1  |  NOP  |  NOP  }
;Reg[D4] = 0x0100_0000

{  NOP  |  NOP  |  (P15) RND D4, D2  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  (P14) RND D5, D2  |  NOP  |  NOP  }
;Reg[D5] = 0x0000_0000

{  NOP  |  NOP  |  (P15) RND D5, D0  |  NOP  |  NOP  }
;Not execute

;-------------------------------------------------------------- Store Result
{  NOP  |  SW D0, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0034] = 0x0001_8000, Reg[A0] = 0x0000_0038

{  NOP  |  SW D1, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0038] = 0x00FF_8001, Reg[A0] = 0x0000_003C

{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_003C] = 0x0000_000F, Reg[A0] = 0x0000_0040

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0040] = 0x0002_0000, Reg[A0] = 0x0000_0044

{  NOP  |  SW D4, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0044] = 0x0100_0000, Reg[A0] = 0x0000_0048

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0048] = 0x0000_0000, Reg[A0] = 0x0000_004C

;************************************************************** DCLR
{  NOP  |  NOP  |  (P14) DCLR D0  |  NOP  |  NOP  }
;Reg[D0] = 0x0000_0000, Reg[D1] = 0x0000_0000

{  NOP  |  NOP  |  (P15) DCLR D2  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  DCLR D2  |  NOP  |  NOP  }
;Reg[D2] = 0x0000_0000, Reg[D3] = 0x0000_0000

;-------------------------------------------------------------- Store Result
{  NOP  |  SW D0, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_004C] = 0x0000_0000, Reg[A0] = 0x0000_0050

{  NOP  |  SW D1, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0050] = 0x0000_0000, Reg[A0] = 0x0000_0054

{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0054] = 0x0000_0000, Reg[A0] = 0x0000_0058

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0058] = 0x0000_0000, Reg[A0] = 0x0000_005C



;************************************************************** Program Terminate
{  TRAP  |  NOP  |  NOP  |  NOP  |  NOP  }
