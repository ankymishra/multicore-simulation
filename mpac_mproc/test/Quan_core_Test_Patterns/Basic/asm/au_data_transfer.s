
BASE_ADDR = 0x2400

;************************************************************** Set Start Address

{  COPY R0, SR15   |  MOVI.L A0, 0x0000    |  MOVI AU_PSR, 0x0000000  |  NOP  |  NOP  }

{  SLLI R0, R0, 20 |  MOVI.H A0, BASE_ADDR |  NOP  |  NOP  |  NOP  }   ;Reg[A0] = 0x24?0_0000,

{  BDT R0  | BDR D0  |  NOP  |  NOP  |  NOP  }

{  NOP  | NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  | NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  ADD A0, A0, D0  |  NOP  |  NOP  |  NOP  }

;************************************************************** MOVI.L, MOVI(U).H, MOVI(U), COPY, COPY_FC, COPY_FV
{  NOP  |  NOP  |  MOVI.L D0, 0xFFFF  |  NOP  |  NOP  }
;Reg[D0] = 0x0000_FFFF

{  NOP  |  NOP  |  MOVI.H D0, 0xFFFF  |  NOP  |  NOP  }
;Reg[D0] = 0xFFFF_FFFF

{  NOP  |  NOP  |  MOVI.L D1, 0x1111  |  NOP  |  NOP  }
;Reg[D1] = 0x0000_1111

{  NOP  |  NOP  |  MOVI.H D1, 0x1111  |  NOP  |  NOP  }
;Reg[D1] = 0x1111_1111

{  NOP  |  NOP  |  COPY D1, D0  |  NOP  |  NOP  }
;Reg[D1] = 0xFFFF_FFFF

{  NOP  |  NOP  |  MOVIU D2, 0x8000 |  NOP  |  NOP  }
;Reg[D2] = 0x0000_8000

{  NOP  |  NOP  |  MOVI D3, 0xFFFFFFFF |  NOP  |  NOP  }
;Reg[D3] = 0xFFFF_FFFF

{  NOP  |  NOP  |  ADD.D D4, D2, D3 |  NOP  |  NOP  }
;Reg[D4] = 0xFFFF_7FFF, AU_PSR[1](C) = 0x0, AU_PSR[0](V) = 0x1

{  NOP  |  NOP  |  NOP |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY_FC P1 |  NOP  |  NOP  }
;Reg[P1] = 0x0

{  NOP  |  NOP  |  COPY_FV P2 |  NOP  |  NOP  }
;Reg[P2] = 0x1

{  NOP  |  NOP  |  COPY D15, AU_PSR  |  NOP  |  NOP  }
;Reg[D15] = 0x0000_0001

;-------------------------------------------------------------- Store Result
{  NOP  |  SW D0, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0000] = 0xFFFF_FFFF, Reg[A0] = 0x0000_0004

{  NOP  |  SW D1, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0004] = 0xFFFF_FFFF, Reg[A0] = 0x0000_0008

{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0008] = 0x0000_8000, Reg[A0] = 0x0000_000C

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_000C] = 0xFFFF_FFFF, Reg[A0] = 0x0000_0010

{  NOP  |  SW D4, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0010] = 0xFFFF_7FFF, Reg[A0] = 0x0000_0014

{  NOP  |  SW D15, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0014] = 0x0000_0001, Reg[A0] = 0x0000_0018



;************************************************************** PERMH2, PERMH4, PACK4, UNPACK4(U), SWAP2, SWAP4(E)
{  NOP  |  NOP  |  MOVI.L D0, 0x3344  |  NOP  |  NOP  }
;Reg[D0] = 0xFFFF_3344 

{  NOP  |  NOP  |  MOVI.H D0, 0x1122  |  NOP  |  NOP  }
;Reg[D0] = 0x1122_3344

{  NOP  |  NOP  |  MOVI.L D1, 0xCCDD  |  NOP  |  NOP  }
;Reg[D1] = 0xFFFF_CCDD

{  NOP  |  NOP  |  MOVI.H D1, 0xAABB  |  NOP  |  NOP  }
;Reg[D1] = 0xAABB_CCDD

{  NOP  |  NOP  |  PERMH2 D2, D0, D1, 2, 0  |  NOP  |  NOP  }
;Reg[D2] = 0x3344_CCDD

{  NOP  |  NOP  |  PERMH4 D4, D0, D1, 0, 3, 1, 2  |  NOP  |  NOP  }
;Reg[D4] = 0xAABB_3344, Reg[D5] = 0xCCDD_1122

{  NOP  |  NOP  |  SWAP2 D6, D2  |  NOP  |  NOP  }
;Reg[D6] = 0xCCDD_3344

{  NOP  |  NOP  |  PACK4 D7, D0, D1  |  NOP  |  NOP  }
;Reg[D7] = 0x2244_BBDD

{  NOP  |  NOP  |  UNPACK4 D8, D7  |  NOP  |  NOP  }
;Reg[D8] = 0x0022_0044, Reg[D9] = 0xFFBB_FFDD

{  NOP  |  NOP  |  UNPACK4U D10, D7  |  NOP  |  NOP  }
;Reg[D10] = 0x0022_0044, Reg[D11] = 0x00BB_00DD

{  NOP  |  NOP  |  SWAP4 D12, D7  |  NOP  |  NOP  }
;Reg[D12] = 0x4422_DDBB

{  NOP  |  NOP  |  SWAP4E D13, D7  |  NOP  |  NOP  }
;Reg[D13] = 0xDDBB_4422
;-------------------------------------------------------------- Store Result
{  NOP  |  SW D0, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0018] = 0x1122_3344, Reg[A0] = 0x0000_001C

{  NOP  |  SW D1, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_001C] = 0xAABB_CCDD, Reg[A0] = 0x0000_0020

{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0020] = 0x3344_CCDD, Reg[A0] = 0x0000_0024

{  NOP  |  SW D4, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0024] = 0xAABB_3344, Reg[A0] = 0x0000_0028

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0028] = 0xCCDD_1122, Reg[A0] = 0x0000_002C

{  NOP  |  SW D6, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_002C] = 0xCCDD_3344, Reg[A0] = 0x0000_0030

{  NOP  |  SW D7, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0030] = 0x2244_BBDD, Reg[A0] = 0x0000_0034

{  NOP  |  SW D8, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0034] = 0x0022_0044, Reg[A0] = 0x0000_0038

{  NOP  |  SW D9, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0038] = 0xFFBB_FFDD, Reg[A0] = 0x0000_003C

{  NOP  |  SW D10, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_003C] = 0x0022_0044, Reg[A0] = 0x0000_0040

{  NOP  |  SW D11, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0040] = 0x00BB_00DD, Reg[A0] = 0x0000_0044

{  NOP  |  SW D12, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0044] = 0x4422_DDBB, Reg[A0] = 0x0000_0048

{  NOP  |  SW D13, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0048] = 0xDDBB_4422, Reg[A0] = 0x0000_004C


;************************************************************** LIMW(U)CP
{  NOP  |  NOP  |  MOVI.L AC0, 0xFFFF  |  NOP  |  NOP  }
;Reg[AC0] = 0x00_0000_FFFF

{  NOP  |  NOP  |  MOVI.H AC0, 0x7FFF  |  NOP  |  NOP  }
;Reg[AC0] = 0x00_7FFF_FFFF

{  NOP  |  NOP  |  ADDI AC0, AC0, 0x0001  |  NOP  |  NOP  }
;Reg[AC0] = 0x00_8000_0000

{  NOP  |  NOP  |  MOVI.L AC1, 0x0000  |  NOP  |  NOP  }
;Reg[AC1] = 0x00_0000_0000

{  NOP  |  NOP  |  MOVI.H AC1, 0x8000  |  NOP  |  NOP  }
;Reg[AC1] = 0xFF_8000_0000

{  NOP  |  NOP  |  ADDI AC1, AC1, 0xFFFFFFFF  |  NOP  |  NOP  }
;Reg[AC1] = 0xFF_7FFF_FFFF

{  NOP  |  NOP  |  MOVI.L AC2, 0xFFFF  |  NOP  |  NOP  }
;Reg[AC2] = 0x00_0000_FFFF

{  NOP  |  NOP  |  MOVI.H AC2, 0xFFFF  |  NOP  |  NOP  }
;Reg[AC2] = 0xFF_FFFF_FFFF

{  NOP  |  NOP  |  LIMWCP D0, AC0  |  NOP  |  NOP  }
;Reg[D0] = 0x7FFF_FFFF

{  NOP  |  NOP  |  LIMWCP D1, AC1  |  NOP  |  NOP  }
;Reg[D1] = 0x8000_0000

{  NOP  |  NOP  |  LIMWCP D2, AC2  |  NOP  |  NOP  }
;Reg[D2] = 0xFFFF_FFFF

{  NOP  |  NOP  |  LIMWUCP D3, AC0  |  NOP  |  NOP  }
;Reg[D3] = 0x8000_0000

{  NOP  |  NOP  |  LIMWUCP D4, AC1  |  NOP  |  NOP  }
;Reg[D4] = 0xFFFF_FFFF

{  NOP  |  NOP  |  LIMWUCP D5, AC2  |  NOP  |  NOP  }
;Reg[D5] = 0xFFFF_FFFF
;-------------------------------------------------------------- Store Result
{  NOP  |  SW D0, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_004C] = 0x7FFF_FFFF, Reg[A0] = 0x0000_0050

{  NOP  |  SW D1, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0050] = 0x8000_0000, Reg[A0] = 0x0000_0054

{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0054] = 0xFFFF_FFFF, Reg[A0] = 0x0000_0058

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0058] = 0x8000_0000, Reg[A0] = 0x0000_005C

{  NOP  |  SW D4, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_005C] = 0xFFFF_FFFF, Reg[A0] = 0x0000_0060

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0060] = 0xFFFF_FFFF, Reg[A0] = 0x0000_0064


;************************************************************** LIMHW(U)CP
{  NOP  |  NOP  |  MOVI.L D0, 0x7FFF  |  NOP  |  NOP  }
;Reg[D0] = 0x7FFF_7FFF

{  NOP  |  NOP  |  MOVI.H D0, 0x0000  |  NOP  |  NOP  }
;Reg[D0] = 0x0000_7FFF

{  NOP  |  NOP  |  ADDI D0, D0, 0x0001  |  NOP  |  NOP  }
;Reg[D0] = 0x0000_8000

{  NOP  |  NOP  |  MOVI.L D1, 0x8000  |  NOP  |  NOP  }
;Reg[D1] = 0x8000_8000

{  NOP  |  NOP  |  MOVI.H D1, 0xFFFF  |  NOP  |  NOP  }
;Reg[D1] = 0xFFFF_8000

{  NOP  |  NOP  |  ADDI D1, D1, 0xFFFFFFFF  |  NOP  |  NOP  }
;Reg[D1] = 0xFFFF_7FFF

{  NOP  |  NOP  |  MOVI.L D2, 0xFFFF  |  NOP  |  NOP  }
;Reg[D2] = 0xFFFF_FFFF

{  NOP  |  NOP  |  MOVI.H D2, 0xFFFF  |  NOP  |  NOP  }
;Reg[D2] = 0xFFFF_FFFF

{  NOP  |  NOP  |  LIMHWCP D3, D0  |  NOP  |  NOP  }
;Reg[D3] = 0x0000_7FFF

{  NOP  |  NOP  |  LIMHWCP D4, D1  |  NOP  |  NOP  }
;Reg[D4] = 0xFFFF_8000

{  NOP  |  NOP  |  LIMHWCP D5, D2  |  NOP  |  NOP  }
;Reg[D5] = 0xFFFF_FFFF

{  NOP  |  NOP  |  LIMHWUCP D6, D0  |  NOP  |  NOP  }
;Reg[D6] = 0x0000_8000

{  NOP  |  NOP  |  LIMHWUCP D7, D1  |  NOP  |  NOP  }
;Reg[D7] = 0x0000_FFFF

{  NOP  |  NOP  |  LIMHWUCP D8, D2  |  NOP  |  NOP  }
;Reg[D8] = 0x0000_FFFF
;-------------------------------------------------------------- Store Result
{  NOP  |  SW D0, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0064] = 0x0000_8000, Reg[A0] = 0x0000_0068

{  NOP  |  SW D1, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0068] = 0xFFFF_7FFF, Reg[A0] = 0x0000_006C

{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_006C] = 0xFFFF_FFFF, Reg[A0] = 0x0000_0070

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0070] = 0x0000_7FFF, Reg[A0] = 0x0000_0074

{  NOP  |  SW D4, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0074] = 0xFFFF_8000, Reg[A0] = 0x0000_0078

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0078] = 0xFFFF_FFFF, Reg[A0] = 0x0000_007C

{  NOP  |  SW D6, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_007C] = 0x0000_8000, Reg[A0] = 0x0000_0080

{  NOP  |  SW D7, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0080] = 0x0000_FFFF, Reg[A0] = 0x0000_0084

{  NOP  |  SW D8, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0084] = 0x0000_FFFF, Reg[A0] = 0x0000_0088


;************************************************************** LIMB(U)CP
{  NOP  |  NOP  |  MOVI.L D0, 0x007F  |  NOP  |  NOP  }
;Reg[D0] = 0x0000_007F

{  NOP  |  NOP  |  MOVI.H D0, 0x007F  |  NOP  |  NOP  }
;Reg[D0] = 0x007F_007F

{  NOP  |  NOP  |  ADDI.D D0, D0, 0x0001  |  NOP  |  NOP  }
;Reg[D0] = 0x0080_0080

{  NOP  |  NOP  |  MOVI.L D1, 0xFF80  |  NOP  |  NOP  }
;Reg[D1] = 0xFFFF_FF80

{  NOP  |  NOP  |  MOVI.H D1, 0xFF80  |  NOP  |  NOP  }
;Reg[D1] = 0xFF80_FF80

{  NOP  |  NOP  |  ADDI.D D1, D1, 0xFFFF  |  NOP  |  NOP  }
;Reg[D1] = 0xFF7F_FF7F

{  NOP  |  NOP  |  MOVI.L D2, 0xFFFF  |  NOP  |  NOP  }
;Reg[D2] = 0xFFFF_FFFF

{  NOP  |  NOP  |  MOVI.H D2, 0xFFFF  |  NOP  |  NOP  }
;Reg[D2] = 0xFFFF_FFFF

{  NOP  |  NOP  |  LIMBCP D3, D0  |  NOP  |  NOP  }
;Reg[D3] = 0x007F_007F										

{  NOP  |  NOP  |  LIMBCP D4, D1  |  NOP  |  NOP  }
;Reg[D4] = 0xFF80_FF80

{  NOP  |  NOP  |  LIMBCP D5, D2  |  NOP  |  NOP  }
;Reg[D5] = 0xFFFF_FFFF

{  NOP  |  NOP  |  LIMBUCP D6, D0  |  NOP  |  NOP  }
;Reg[D6] = 0x0080_0080										

{  NOP  |  NOP  |  LIMBUCP D7, D1  |  NOP  |  NOP  }
;Reg[D7] = 0x0000_0000

{  NOP  |  NOP  |  LIMBUCP D8, D2  |  NOP  |  NOP  }
;Reg[D8] = 0x0000_0000								 
;-------------------------------------------------------------- Store Result
{  NOP  |  SW D0, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0088] = 0x0080_0080, Reg[A0] = 0x0000_008C

{  NOP  |  SW D1, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_008C] = 0xFF7F_FF7F, Reg[A0] = 0x0000_0090

{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0090] = 0xFFFF_FFFF, Reg[A0] = 0x0000_0094

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0094] = 0x007F_007F, Reg[A0] = 0x0000_0098

{  NOP  |  SW D4, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0098] = 0xFF80_FF80, Reg[A0] = 0x0000_009C

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_009C] = 0xFFFF_FFFF, Reg[A0] = 0x0000_00A0

{  NOP  |  SW D6, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00A0] = 0x0080_0080, Reg[A0] = 0x0000_00A4

{  NOP  |  SW D7, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00A4] = 0x0000_0000, Reg[A0] = 0x0000_00A8

{  NOP  |  SW D8, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00A8] = 0x0000_0000, Reg[A0] = 0x0000_00AC


;************************************************************** SET_CPI, READ_CP
{  NOP  |  NOP  |  SET_CPI CP0, 0x0, 0x2 |  NOP  |  NOP  }
;Reg[CP0] = 0x10 (7'b0010_000)

{  NOP  |  NOP  |  SET_CPI CP1, 0x1, 0x2 |  NOP  |  NOP  }
;Reg[CP1] = 0x11 (7'b0010_001)

{  NOP  |  NOP  |  NOP |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP |  NOP  |  NOP  }

{  NOP  |  MOVI [CP0], 0x0000  |  NOP |  NOP  |  NOP  }
;Reg[C0] = 0x0000_0000

{  NOP  |  MOVI [CP1], 0x1111  |  NOP |  NOP  |  NOP  }
;Reg[C1] = 0x0000_1111

{  NOP  |  MOVI [CP0], 0x2222  |  NOP |  NOP  |  NOP  }
;Reg[C2] = 0x0000_2222

{  NOP  |  MOVI [CP1], 0x3333  |  NOP |  NOP  |  NOP  }
;Reg[C3] = 0x0000_3333

{  NOP  |  MOVI [CP0], 0x4444  |  NOP |  NOP  |  NOP  }
;Reg[C4] = 0x0000_4444

{  NOP  |  MOVI [CP1], 0x5555  |  NOP |  NOP  |  NOP  }
;Reg[C5] = 0x0000_5555

{  NOP  |  MOVI [CP0], 0x6666  |  NOP |  NOP  |  NOP  }
;Reg[C6] = 0x0000_6666

{  NOP  |  MOVI [CP1], 0x7777  |  NOP |  NOP  |  NOP  }
;Reg[C7] = 0x0000_7777

{  NOP  |  NOP  |  SET_CPI CP0, 0x0, 0x1 |  NOP  |  NOP  }
;Reg[CP0] = 0x08 (7'b0001_000)

{  NOP  |  NOP  |  NOP |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D0, [CP0] |  NOP  |  NOP  }
;Reg[D0] = 0x0000_0000

{  NOP  |  NOP  |  COPY D1, [CP0] |  NOP  |  NOP  }
;Reg[D1] = 0x0000_1111

{  NOP  |  NOP  |  COPY D2, [CP0] |  NOP  |  NOP  }
;Reg[D2] = 0x0000_2222

{  NOP  |  NOP  |  COPY D3, [CP0] |  NOP  |  NOP  }
;Reg[D3] = 0x0000_3333

{  NOP  |  NOP  |  COPY D4, [CP0] |  NOP  |  NOP  }
;Reg[D4] = 0x0000_4444

{  NOP  |  NOP  |  COPY D5, [CP0] |  NOP  |  NOP  }
;Reg[D5] = 0x0000_5555

{  NOP  |  NOP  |  COPY D6, [CP0] |  NOP  |  NOP  }
;Reg[D6] = 0x0000_6666

{  NOP  |  NOP  |  COPY D7, [CP0] |  NOP  |  NOP  }
;Reg[D7] = 0x0000_7777

{  NOP  |  NOP  |  READ_CP D8, CP0  |  NOP  |  NOP  }
;Reg[D8] = 0x0000_000D (7'b0001_101)

{  NOP  |  NOP  |  READ_CP D9, CP1 |  NOP  |  NOP  }
;Reg[D9] = 0x0000_0011 (7'b0010_001)
;-------------------------------------------------------------- Store Result
{  NOP  |  SW D0, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00AC] = 0x0000_0000, Reg[A0] = 0x0000_00B0

{  NOP  |  SW D1, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00B0] = 0x0000_1111, Reg[A0] = 0x0000_00B4

{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00B4] = 0x0000_2222, Reg[A0] = 0x0000_00B8

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00B8] = 0x0000_3333, Reg[A0] = 0x0000_00BC

{  NOP  |  SW D4, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00BC] = 0x0000_4444, Reg[A0] = 0x0000_00C0

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00C0] = 0x0000_5555, Reg[A0] = 0x0000_00C4

{  NOP  |  SW D6, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00C4] = 0x0000_6666, Reg[A0] = 0x0000_00C8

{  NOP  |  SW D7, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00C8] = 0x0000_7777, Reg[A0] = 0x0000_00CC

{  NOP  |  SW D8, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00CC] = 0x0000_000D, Reg[A0] = 0x0000_00D0

{  NOP  |  SW D9, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00D0] = 0x0000_0011, Reg[A0] = 0x0000_00D4


;/////////////////////////////////////Encode//////////////////////////////////////
{  NOP  |  NOP  |  MOVI.L D0, 0x1111  |  NOP  |  NOP  }
;Reg[D0] = 0x0000_8FFF

{  NOP  |  NOP  |  MOVI.H D0, 0x1111  |  NOP  |  NOP  }
;Reg[D0] = 0x7FFF_8FFF

{  NOP  |  NOP  |  MOVI.L D1, 0x1111  |  NOP  |  NOP  }
;Reg[D1] = 0x0000_1111

{  NOP  |  NOP  |  MOVI.H D1, 0x1111  |  NOP  |  NOP  }
;Reg[D1] = 0x1111_1111

{  NOP  |  NOP  |  MOVI.L D2, 0x1111  |  NOP  |  NOP  }
;Reg[D2] = 0x0000_1111

{  NOP  |  NOP  |  MOVI.H D2, 0x1111  |  NOP  |  NOP  }
;Reg[D2] = 0x1111_1111

{  NOP  |  NOP  |  MOVI.L D3, 0x1111  |  NOP  |  NOP  }
;Reg[D3] = 0x0000_1111

{  NOP  |  NOP  |  MOVI.H D3, 0x1111  |  NOP  |  NOP  }
;Reg[D3] = 0x1111_1111

{  NOP  |  NOP  |  MOVI.L D4, 0x1111  |  NOP  |  NOP  }
;Reg[D4] = 0x0000_1111

{  NOP  |  NOP  |  MOVI.H D4, 0x1111  |  NOP  |  NOP  }
;Reg[D4] = 0x1111_1111

{  NOP  |  NOP  |  MOVI.L D5, 0x1111  |  NOP  |  NOP  }
;Reg[D5] = 0x0000_1111

{  NOP  |  NOP  |  MOVI.H D5, 0x1111  |  NOP  |  NOP  }
;Reg[D5] = 0x1111_1111

{  NOP  |  NOP  |  MOVI.L D6, 0x1111  |  NOP  |  NOP  }
;Reg[D6] = 0x0000_1111

{  NOP  |  NOP  |  MOVI.H D6, 0x1111  |  NOP  |  NOP  }
;Reg[D6] = 0x1111_1111

{  NOP  |  NOP  |  MOVI.L D7, 0x1111  |  NOP  |  NOP  }
;Reg[D7] = 0x0000_1111

{  NOP  |  NOP  |  MOVI.H D7, 0x1111  |  NOP  |  NOP  }
;Reg[D7] = 0x1111_1111

{  NOP  |  NOP  |  MOVI.L D8, 0x1111  |  NOP  |  NOP  }
;Reg[D8] = 0x0000_1111

{  NOP  |  NOP  |  MOVI.H D8, 0x1111  |  NOP  |  NOP  }
;Reg[D8] = 0x1111_1111

{  NOP  |  NOP  |  MOVI.L D9, 0x1111  |  NOP  |  NOP  }
;Reg[D9] = 0x0000_1111

{  NOP  |  NOP  |  MOVI.H D9, 0x1111  |  NOP  |  NOP  }
;Reg[D9] = 0x1111_1111

{  NOP  |  NOP  |  MOVI.L D10, 0x1111  |  NOP  |  NOP  }
;Reg[D10] = 0x0022_1111

{  NOP  |  NOP  |  MOVI.H D10, 0x1111  |  NOP  |  NOP  }
;Reg[D10] = 0x1111_1111

{  NOP  |  NOP  |  MOVI.L D11, 0x1111  |  NOP  |  NOP  }
;Reg[D11] = 0x00BB_1111

{  NOP  |  NOP  |  MOVI.H D11, 0x1111  |  NOP  |  NOP  }
;Reg[D11] = 0x1111_1111

{  NOP  |  NOP  |  SLTI D15, P1, P2, D0, 0x7FFFFFFF  |  NOP  |  NOP  }
;Reg[D15] = 0x0000_0001, Reg[P1] = 0x1, Reg[P2] = 0x0

{  NOP  |  NOP  |  SLTI D15, P3, P5, D0, 0x7FFFFFFF  |  NOP  |  NOP  }
;Reg[D15] = 0x0000_0001, Reg[P3] = 0x1, Reg[P5] = 0x0

{  NOP  |  NOP  |  SLTI D15, P4, P6, D0, 0x7FFFFFFF  |  NOP  |  NOP  }
;Reg[D15] = 0x0000_0001, Reg[P4] = 0x1, Reg[P6] = 0x0

;************************************************************** MOVI.L, MOVI(U).H, MOVI(U), COPY, COPY_FC, COPY_FV
{  NOP  |  NOP  | (P1) MOVI.L D0, 0xFFFF  |  NOP  |  NOP  }
;Reg[D0] = 0x7FFF_FFFF

{  NOP  |  NOP  | (P1) MOVI.H D0, 0x7FFF  |  NOP  |  NOP  }
;Reg[D0] = 0x7FFF_FFFF

{  NOP  |  NOP  | (P2) MOVI.L D1, 0xFFFF  |  NOP  |  NOP  }
; Non-Execution

{  NOP  |  NOP  | (P2) MOVI.H D1, 0xFFFF  |  NOP  |  NOP  }
; Non-Execution

{  NOP  |  NOP  | (P1) MOVI D2, 0x01234567  |  NOP  |  NOP  }
;Reg[D2] = 0x0123_4567

{  NOP  |  NOP  | (P2) MOVI D3, 0x01234567  |  NOP  |  NOP  }
; Non-Execution

{  NOP  |  NOP  | (P1) COPY D4, D0  |  NOP  |  NOP  }
;Reg[D4] = 0x7FFF_FFFF

{  NOP  |  NOP  | (P2) COPY D5, D0  |  NOP  |  NOP  }
; Non-Execution

{  NOP  |  NOP  | (P1) MOVIU D6, 0x8000 |  NOP  |  NOP  }
;Reg[D6] = 0x0000_8000

{  NOP  |  NOP  | (P2) MOVIU D7, 0x8000 |  NOP  |  NOP  }
; Non-Execution

{  NOP  |  NOP  |  ADDI D15, D0, 0x10000000 |  NOP  |  NOP  }
;Reg[D15] = 0x8FFF_FFFF, AU_PSR[1](C) = 0x0, AU_PSR[0](V) = 0x1

{  NOP  |  NOP  |  NOP |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP |  NOP  |  NOP  }

{  NOP  |  NOP  | (P1) COPY_FC P3 |  NOP  |  NOP  }
;Reg[P3] = 0x0

{  NOP  |  NOP  | (P2) COPY_FC P3 |  NOP  |  NOP  }
; Non-Execution

{  NOP  |  NOP  | (P1) COPY_FV P4 |  NOP  |  NOP  }
;Reg[P4] = 0x1

{  NOP  |  NOP  | (P2) COPY_FV P6 |  NOP  |  NOP  }
; Non-Execution
;-------------------------------------------------------------- Store Result
{  NOP  |  SW D0, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00D4] = 0x7FFF_FFFF, Reg[A0] = 0x0000_00D8

{  NOP  |  SW D1, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00D8] = 0x1111_1111, Reg[A0] = 0x0000_00DC

{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00DC] = 0x0123_4567, Reg[A0] = 0x0000_00E0

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00E0] = 0x1111_1111, Reg[A0] = 0x0000_00E4

{  NOP  |  SW D4, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00E4] = 0x7FFF_FFFF, Reg[A0] = 0x0000_00E8

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00E8] = 0x1111_1111, Reg[A0] = 0x0000_00EC

{  NOP  |  SW D6, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00EC] = 0x0000_8000, Reg[A0] = 0x0000_00F0

{  NOP  |  SW D7, A0, 8+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00F0] = 0x1111_1111, Reg[A0] = 0x0000_00F4

{  NOP  | (P3) SW D0, A0, 4+    |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  NOP  | (P4) SW D1, A0, 12+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00F8] = 0x1111_1111, Reg[A0] = 0x0000_00FC

{  NOP  | (P5) SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
; Non-Execution 

{  NOP  | (P6) SW D6, A0, 4+    |  NOP  |  NOP  |  NOP  }
; Non-Execution


;************************************************************** PERMH2, PERMH4, SWAP2
{  NOP  |  NOP  |  MOVI.L D0, 0x3344  |  NOP  |  NOP  }
;Reg[D0] = 0x7FFF_3344 

{  NOP  |  NOP  |  MOVI.H D0, 0x1122  |  NOP  |  NOP  }
;Reg[D0] = 0x1122_3344

{  NOP  |  NOP  |  MOVI.L D1, 0xCCDD  |  NOP  |  NOP  }
;Reg[D1] = 0x1111_CCDD

{  NOP  |  NOP  |  MOVI.H D1, 0xAABB  |  NOP  |  NOP  }
;Reg[D1] = 0xAABB_CCDD

{  NOP  |  NOP  | (P1) PERMH2 D2, D0, D1, 2, 0  |  NOP  |  NOP  }
;Reg[D2] = 0x3344_CCDD

{  NOP  |  NOP  | (P2) PERMH2 D3, D0, D1, 2, 0  |  NOP  |  NOP  }
; Non-Execution

{  NOP  |  NOP  | (P1) PERMH4 D4, D0, D1, 0, 3, 1, 2  |  NOP  |  NOP  }
;Reg[D4] = 0xAABB_3344, Reg[D5] = 0xCCDD_1122

{  NOP  |  NOP  | (P2) PERMH4 D6, D0, D1, 0, 3, 1, 2  |  NOP  |  NOP  }
; Non-Execution

{  NOP  |  NOP  | (P1) SWAP2 D8, D2  |  NOP  |  NOP  }
;Reg[D8] = 0xCCDD_3344

{  NOP  |  NOP  | (P2) SWAP2 D9, D2  |  NOP  |  NOP  }
; Non-Execution
;-------------------------------------------------------------- Store Result
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0104] = 0x3344_CCDD, Reg[A0] = 0x0000_0108

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0108] = 0x1111_1111, Reg[A0] = 0x0000_010C

{  NOP  |  SW D4, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_010C] = 0xAABB_3344, Reg[A0] = 0x0000_0110

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0110] = 0xCCDD_1122, Reg[A0] = 0x0000_0114

{  NOP  |  SW D6, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0114] = 0x0000_8000, Reg[A0] = 0x0000_0118

{  NOP  |  SW D7, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0118] = 0x1111_1111, Reg[A0] = 0x0000_011C

{  NOP  |  SW D8, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_011C] = 0xCCDD_3344, Reg[A0] = 0x0000_0120

{  NOP  |  SW D9, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0120] = 0x1111_1111, Reg[A0] = 0x0000_0124


;************************************************************** PACK4, UNPACK4(U)
{  NOP  |  NOP  | (P1) PACK4 D2, D0, D1  |  NOP  |  NOP  }
;Reg[D2] = 0x2244_BBDD

{  NOP  |  NOP  | (P2) PACK4 D3, D0, D1  |  NOP  |  NOP  }
; Non-Execution

{  NOP  |  NOP  | (P1) UNPACK4 D4, D2  |  NOP  |  NOP  }
;Reg[D4] = 0x0022_0044, Reg[D5] = 0xFFBB_FFDD

{  NOP  |  NOP  | (P2) UNPACK4 D6, D2  |  NOP  |  NOP  }
; Non-Execution

{  NOP  |  NOP  | (P1) UNPACK4U D8, D2  |  NOP  |  NOP  }
;Reg[D8] = 0x0022_0044, Reg[D9] = 0x00BB_00DD

{  NOP  |  NOP  | (P2) UNPACK4U D10, D2  |  NOP  |  NOP  }
; Non-Execution
;-------------------------------------------------------------- Store Result
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0124] = 0x2244_BBDD, Reg[A0] = 0x0000_0128

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0128] = 0x1111_1111, Reg[A0] = 0x0000_012C

{  NOP  |  SW D4, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_012C] = 0x0022_0044, Reg[A0] = 0x0000_0130

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0130] = 0xFFBB_FFDD, Reg[A0] = 0x0000_0134

{  NOP  |  SW D6, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0134] = 0x0000_8000, Reg[A0] = 0x0000_0138

{  NOP  |  SW D7, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0138] = 0x1111_1111, Reg[A0] = 0x0000_013C

{  NOP  |  SW D8, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_013C] = 0x0022_0044, Reg[A0] = 0x0000_0140

{  NOP  |  SW D9, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0140] = 0x00BB_00DD, Reg[A0] = 0x0000_0144

{  NOP  |  SW D10, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0144] = 0x1111_1111, Reg[A0] = 0x0000_0148

{  NOP  |  SW D11, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0148] = 0x1111_1111, Reg[A0] = 0x0000_014C


;************************************************************** SWAP4(E)
{  NOP  |  NOP  | (P1) SWAP4 D4, D2  |  NOP  |  NOP  }
;Reg[D12] = 0x4422_DDBB

{  NOP  |  NOP  | (P2) SWAP4 D5, D2  |  NOP  |  NOP  }
; Non-Execution

{  NOP  |  NOP  | (P1) SWAP4E D6, D2  |  NOP  |  NOP  }
;Reg[D13] = 0xDDBB_4422

{  NOP  |  NOP  | (P2) SWAP4E D7, D2  |  NOP  |  NOP  }
; Non-Execution
;-------------------------------------------------------------- Store Result
{  NOP  |  SW D4, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_014C] = 0x4422_DDBB, Reg[A0] = 0x0000_0150

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0150] = 0xFFBB_FFDD, Reg[A0] = 0x0000_0154

{  NOP  |  SW D6, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0154] = 0xDDBB_4422, Reg[A0] = 0x0000_0158

{  NOP  |  SW D7, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0158] = 0x1111_1111, Reg[A0] = 0x0000_015C


;************************************************************** LIMW(U)CP
{  NOP  |  NOP  |  MOVI.L AC0, 0xFFFF  |  NOP  |  NOP  }
;Reg[AC0] = 0x00_0000_FFFF

{  NOP  |  NOP  |  MOVI.H AC0, 0x7FFF  |  NOP  |  NOP  }
;Reg[AC0] = 0x00_7FFF_FFFF

{  NOP  |  NOP  |  ADDI AC0, AC0, 0x0001  |  NOP  |  NOP  }
;Reg[AC0] = 0x00_8000_0000

{  NOP  |  NOP  |  MOVI.L AC1, 0x0000  |  NOP  |  NOP  }
;Reg[AC1] = 0x00_0000_0000

{  NOP  |  NOP  |  MOVI.H AC1, 0x8000  |  NOP  |  NOP  }
;Reg[AC1] = 0xFF_8000_0000

{  NOP  |  NOP  |  ADDI AC1, AC1, 0xFFFFFFFF  |  NOP  |  NOP  }
;Reg[AC1] = 0xFF_7FFF_FFFF

{  NOP  |  NOP  |  MOVI.L AC2, 0xFFFF  |  NOP  |  NOP  }
;Reg[AC2] = 0x00_0000_FFFF

{  NOP  |  NOP  |  MOVI.H AC2, 0xFFFF  |  NOP  |  NOP  }
;Reg[AC2] = 0xFF_FFFF_FFFF

{  NOP  |  NOP  | (P1) LIMWCP D0, AC0  |  NOP  |  NOP  }
;Reg[D0] = 0x7FFF_FFFF

{  NOP  |  NOP  | (P2) LIMWCP D1, AC0  |  NOP  |  NOP  }
; Non-Execution

{  NOP  |  NOP  | (P1) LIMWCP D2, AC1  |  NOP  |  NOP  }
;Reg[D2] = 0x8000_0000

{  NOP  |  NOP  | (P2) LIMWCP D3, AC1  |  NOP  |  NOP  }
; Non-Execution

{  NOP  |  NOP  | (P1) LIMWCP D4, AC2  |  NOP  |  NOP  }
;Reg[D4] = 0xFFFF_FFFF

{  NOP  |  NOP  | (P2) LIMWCP D5, AC2  |  NOP  |  NOP  }
; Non-Execution

{  NOP  |  NOP  | (P1) LIMWUCP D6, AC0  |  NOP  |  NOP  }
;Reg[D6] = 0x8000_0000

{  NOP  |  NOP  | (P2) LIMWUCP D7, AC0  |  NOP  |  NOP  }
; Non-Execution

{  NOP  |  NOP  | (P1) LIMWUCP D8, AC1  |  NOP  |  NOP  }
;Reg[D8] = 0xFFFF_FFFF

{  NOP  |  NOP  | (P2) LIMWUCP D9, AC1  |  NOP  |  NOP  }
; Non-Execution

{  NOP  |  NOP  | (P1) LIMWUCP D10, AC2  |  NOP  |  NOP  }
;Reg[D10] = 0xFFFF_FFFF

{  NOP  |  NOP  | (P2) LIMWUCP D11, AC2  |  NOP  |  NOP  }
; Non-Execution
;-------------------------------------------------------------- Store Result
{  NOP  |  SW D0, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_015C] = 0x7FFF_FFFF, Reg[A0] = 0x0000_0160

{  NOP  |  SW D1, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0160] = 0xAABB_CCDD, Reg[A0] = 0x0000_0164

{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0164] = 0x8000_0000, Reg[A0] = 0x0000_0168

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0168] = 0x1111_1111, Reg[A0] = 0x0000_016C

{  NOP  |  SW D4, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_016C] = 0xFFFF_FFFF, Reg[A0] = 0x0000_0170

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0170] = 0xFFBB_FFDD, Reg[A0] = 0x0000_0174

{  NOP  |  SW D6, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0174] = 0x8000_0000, Reg[A0] = 0x0000_0178

{  NOP  |  SW D7, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0178] = 0x1111_1111, Reg[A0] = 0x0000_017C

{  NOP  |  SW D8, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_017C] = 0xFFFF_FFFF, Reg[A0] = 0x0000_0180

{  NOP  |  SW D9, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0180] = 0x00BB_00DD, Reg[A0] = 0x0000_0184

{  NOP  |  SW D10, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0184] = 0xFFFF_FFFF, Reg[A0] = 0x0000_0188

{  NOP  |  SW D11, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0188] = 0x1111_1111, Reg[A0] = 0x0000_018C


;************************************************************** LIMHW(U)CP
{  NOP  |  NOP  |  MOVI.L AC1, 0x8000  |  NOP  |  NOP  }
;Reg[AC1] = 0xFF_7FFF_8000

{  NOP  |  NOP  |  MOVI.H AC1, 0xFFFF  |  NOP  |  NOP  }
;Reg[AC1] = 0xFF_FFFF_8000

{  NOP  |  NOP  |  ADDI AC1, AC1, 0xFFFFFFFF  |  NOP  |  NOP  }
;Reg[AC1] = 0xFFFF_7FFF

{  NOP  |  NOP  | (P1) LIMHWCP D0, AC0  |  NOP  |  NOP  }
;Reg[D0] = 0x0000_7FFF											0xFFFF_8000 ************************ Sam

{  NOP  |  NOP  | (P2) LIMHWCP D1, AC0  |  NOP  |  NOP  }
; Non-Execution

{  NOP  |  NOP  | (P1) LIMHWCP D2, AC1  |  NOP  |  NOP  }
;Reg[D2] = 0xFFFF_8000

{  NOP  |  NOP  | (P2) LIMHWCP D3, AC1  |  NOP  |  NOP  }
; Non-Execution

{  NOP  |  NOP  | (P1) LIMHWCP D4, AC2  |  NOP  |  NOP  }
;Reg[D4] = 0xFFFF_FFFF

{  NOP  |  NOP  | (P2) LIMHWCP D5, AC2  |  NOP  |  NOP  }
; Non-Execution

{  NOP  |  NOP  | (P1) LIMHWUCP D6, AC0  |  NOP  |  NOP  }
;Reg[D6] = 0x0000_8000											0x0000_FFFF ************************* Sam

{  NOP  |  NOP  | (P2) LIMHWUCP D7, AC0  |  NOP  |  NOP  }
; Non-Execution

{  NOP  |  NOP  | (P1) LIMHWUCP D8, AC1  |  NOP  |  NOP  }
;Reg[D8] = 0x0000_FFFF

{  NOP  |  NOP  | (P2) LIMHWUCP D9, AC1  |  NOP  |  NOP  }
; Non-Execution

{  NOP  |  NOP  | (P1) LIMHWUCP D10, AC2  |  NOP  |  NOP  }
;Reg[D10] = 0x0000_FFFF

{  NOP  |  NOP  | (P2) LIMHWUCP D11, AC2  |  NOP  |  NOP  }
; Non-Execution
;-------------------------------------------------------------- Store Result
{  NOP  |  SW D0, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_018C] = 0xFFFF_8000, Reg[A0] = 0x0000_0190

{  NOP  |  SW D1, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0190] = 0xAABB_CCDD, Reg[A0] = 0x0000_0194

{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0194] = 0xFFFF_8000, Reg[A0] = 0x0000_0198

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0198] = 0x1111_1111, Reg[A0] = 0x0000_019C

{  NOP  |  SW D4, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_019C] = 0xFFFF_FFFF, Reg[A0] = 0x0000_01A0

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01A0] = 0xFFBB_FFDD, Reg[A0] = 0x0000_01A4

{  NOP  |  SW D6, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01A4] = 0x0000_FFFF, Reg[A0] = 0x0000_01A8

{  NOP  |  SW D7, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01A8] = 0x1111_1111, Reg[A0] = 0x0000_01AC

{  NOP  |  SW D8, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01AC] = 0x0000_FFFF, Reg[A0] = 0x0000_01B0

{  NOP  |  SW D9, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01B0] = 0x00BB_00DD, Reg[A0] = 0x0000_01B4

{  NOP  |  SW D10, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01B4] = 0x0000_FFFF, Reg[A0] = 0x0000_01B8

{  NOP  |  SW D11, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01B8] = 0x1111_1111, Reg[A0] = 0x0000_01BC

;************************************************************** LIMB(U)CP
{  NOP  |  NOP  |  MOVI.L AC0, 0x007F  |  NOP  |  NOP  }
;Reg[AC0] = 0x00_0000_007F

{  NOP  |  NOP  |  MOVI.H AC0, 0x007F  |  NOP  |  NOP  }
;Reg[AC0] = 0x00_007F_007F

{  NOP  |  NOP  |  ADDI.D AC0, AC0, 0x0001  |  NOP  |  NOP  }
;Reg[AC0] = 0x0080_0080

{  NOP  |  NOP  |  MOVI.L AC1, 0xFF80  |  NOP  |  NOP  }
;Reg[AC1] = 0xFF_FFFF_FF80

{  NOP  |  NOP  |  MOVI.H AC1, 0xFF80  |  NOP  |  NOP  }
;Reg[AC1] = 0xFF_FF80_FF80

{  NOP  |  NOP  |  ADDI.D AC1, AC1, 0xFFFF  |  NOP  |  NOP  }
;Reg[AC1] = 0xFF_FF7F_FF7F

{  NOP  |  NOP  | (P1) LIMBCP D0, AC0  |  NOP  |  NOP  }
;Reg[D0] = 0x007F_007F	

{  NOP  |  NOP  | (P2) LIMBCP D1, AC0  |  NOP  |  NOP  }
; Non-Execution									

{  NOP  |  NOP  | (P1) LIMBCP D2, AC1  |  NOP  |  NOP  }
;Reg[D2] = 0xFF80_FF80

{  NOP  |  NOP  | (P2) LIMBCP D3, AC1  |  NOP  |  NOP  }
; Non-Execution

{  NOP  |  NOP  | (P1) LIMBCP D4, AC2  |  NOP  |  NOP  }
;Reg[D4] = 0xFFFF_FFFF

{  NOP  |  NOP  | (P2) LIMBCP D5, AC2  |  NOP  |  NOP  }
; Non-Execution

{  NOP  |  NOP  | (P1) LIMBUCP D6, AC0  |  NOP  |  NOP  }
;Reg[D6] = 0x0080_0080	

{  NOP  |  NOP  | (P2) LIMBUCP D7, AC0  |  NOP  |  NOP  }
; Non-Execution										

{  NOP  |  NOP  | (P1) LIMBUCP D8, AC1  |  NOP  |  NOP  }
;Reg[D8] = 0x0000_0000

{  NOP  |  NOP  | (P2) LIMBUCP D9, AC1  |  NOP  |  NOP  }
; Non-Execution

{  NOP  |  NOP  | (P1) LIMBUCP D10, AC2  |  NOP  |  NOP  }
;Reg[D10] = 0x0000_0000		

{  NOP  |  NOP  | (P2) LIMBUCP D11, AC2  |  NOP  |  NOP  }
; Non-Execution
;-------------------------------------------------------------- Store Result
{  NOP  |  SW D0, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01BC] = 0x007F_007F, Reg[A0] = 0x0000_01C0

{  NOP  |  SW D1, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01C0] = 0xAABB_CCDD, Reg[A0] = 0x0000_01C4

{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01C4] = 0xFF80_FF80, Reg[A0] = 0x0000_01C8

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01C8] = 0x1111_1111, Reg[A0] = 0x0000_01CC

{  NOP  |  SW D4, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01CC] = 0xFFFF_FFFF, Reg[A0] = 0x0000_01D0

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01D0] = 0xFFBB_FFDD, Reg[A0] = 0x0000_01D4

{  NOP  |  SW D6, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01D4] = 0x0080_0080, Reg[A0] = 0x0000_01D8

{  NOP  |  SW D7, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01D8] = 0x1111_1111, Reg[A0] = 0x0000_01DC

{  NOP  |  SW D8, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01DC] = 0x0000_0000, Reg[A0] = 0x0000_01E0

{  NOP  |  SW D9, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01E0] = 0x00BB_00DD, Reg[A0] = 0x0000_01E4

{  NOP  |  SW D10, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01E4] = 0x0000_0000, Reg[A0] = 0x0000_01E8

{  NOP  |  SW D11, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01E8] = 0x1111_1111, Reg[A0] = 0x0000_01EC

;************************************************************** UNPACK2(U)
{  NOP  |  (P1) UNPACK2 D8, D1  |  NOP  |  NOP  |  NOP  }
;Reg[D8] = 0xFFFF_CCDD, Reg[D9] = 0xFFFF_AABB

{  NOP  |  (P2) UNPACK2 D8, D2  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  NOP  |  (P1) UNPACK2U D10, D1  |  NOP  |  NOP  |  NOP  }
;Reg[D10] = 0x0000_CCDD, Reg[D11] = 0x0000_AABB

{  NOP  |  (P2) UNPACK2U D10, D2  |  NOP  |  NOP  |  NOP  }
; Non-Execution

;-------------------------------------------------------------- Store Result
{  NOP  |  SW D8, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_01EC] = 0xFFFF_CCDD, Reg[A0] = 0x0000_01F0

{  NOP  |  SW D9, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01F0] = 0xFFFF_AABB, Reg[A0] = 0x0000_01F4

{  NOP  |  SW D10, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01F4] = 0x0000_CCDD, Reg[A0] = 0x0000_01F8

{  NOP  |  SW D11, A0, 36+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01F8] = 0x0000_AABB, Reg[A0] = 0x0000_01FC




;************************************************************** Program Terminate
{  TRAP  |  NOP  |  NOP  |  NOP  |  NOP  }
