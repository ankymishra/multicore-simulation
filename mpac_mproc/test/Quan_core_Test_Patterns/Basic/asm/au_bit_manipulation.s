
BASE_ADDR = 0x2400

;************************************************************** Set Start Address
{  COPY R0, SR15   |  MOVI.L A0, 0x0000    |  MOVI AU_PSR, 0x0000000  |  NOP  |  NOP  }

{  SLLI R0, R0, 20 |  MOVI.H A0, BASE_ADDR |  NOP  |  NOP  |  NOP  }

{  BDT R0  | BDR D0  |  NOP  |  NOP  |  NOP  }

{  NOP  |  MOVI.L A1, 0x0000    |  NOP  |  NOP  |  NOP  }

{  NOP  |  MOVI.H A1, BASE_ADDR |  NOP  |  NOP  |  NOP  }

{  NOP  |  ADD A0, A0, D0  |  NOP  |  NOP  |  NOP  }

{  NOP  |  ADD A1, A1, D0  |  NOP  |  NOP  |  NOP  }



;/////////////////////////////////////// Function /////////////////////////////////////////////
;************************************************************** SLL.(D), SLLI.(D), SRL.(D), SRLI.(D), SRA.(D), SRAI.(D)  
{  NOP  |  NOP  |  MOVI.L D0, 0xFFFF  |  NOP  |  NOP  }
;Reg[D0] = 0x0000_FFFF
;AU_PSR = 0x00

{  NOP  |  NOP  |  MOVI.H D0, 0x7FFF  |  NOP  |  NOP  }
;Reg[D0] = 0x7FFF_FFFF
;AU_PSR = 0x00

{  NOP  |  NOP  |  MOVI.L D1, 0x0008  |  NOP  |  NOP  }
;Reg[D1] = 0x0000_0008
;AU_PSR = 0x00

{  NOP  |  NOP  |  MOVI.H D1, 0x0000  |  NOP  |  NOP  }
;Reg[D1] = 0x0000_0008
;AU_PSR = 0x00

{  NOP  |  NOP  |  SLL D2, D0, D1  |  NOP  |  NOP  }
;Reg[D2] = 0xFFFF_FF00
;AU_PSR = 0x03

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D15, AU_PSR  |  NOP  |  NOP   }
;Reg[D15] = 0x0000_0003
;AU_PSR = 0x03

{  NOP  |  SW D15, A1, 408  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0198] = 0x0000_0003


{  NOP  |  NOP  |  SLL.D D3, D0, D1  |  NOP  |  NOP  }
;Reg[D3] = 0x7FFF_FF00
;AU_PSR = 0x02

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D15, AU_PSR  |  NOP  |  NOP   }
;Reg[D15] = 0x0000_0002
;AU_PSR = 0x02

{  NOP  |  SW D15, A1, 412  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_019C] = 0x0000_0002


{  NOP  |  NOP  |  SLLI D4, D0, 15  |  NOP  |  NOP  }
;Reg[D4] = 0xFFFF_8000
;AU_PSR = 0x03

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D15, AU_PSR  |  NOP  |  NOP   }
;Reg[D15] = 0x0000_0003
;AU_PSR = 0x03

{  NOP  |  SW D15, A1, 416  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01A0] = 0x0000_0003

{  NOP  |  NOP  |  SLLI.D D5, D0, 15  |  NOP  |  NOP  }
;Reg[D5] = 0x8000_8000
;AU_PSR = 0x03

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D15, AU_PSR  |  NOP  |  NOP   }
;Reg[D15] = 0x0000_0003
;AU_PSR = 0x03

{  NOP  |  SW D15, A1, 420  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01A4] = 0x0000_0003


{  NOP  |  NOP  |  SRL D6, D0, D1  |  NOP  |  NOP  }
;Reg[D6] = 0x007F_FFFF
;AU_PSR = 0x01

{  NOP  |  NOP  |  SRL.D D7, D0, D1  |  NOP  |  NOP  }
;Reg[D7] = 0x7FFF_00FF
;AU_PSR = 0x01

{  NOP  |  NOP  |  SRLI D8, D0, 4  |  NOP  |  NOP  }
;Reg[D8] = 0x07FF_FFFF
;AU_PSR = 0x01

{  NOP  |  NOP  |  SRLI.D D9, D0, 4 |  NOP  |  NOP  }
;Reg[D9] = 0x07FF_0FFF
;AU_PSR = 0x01

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D15, AU_PSR  |  NOP  |  NOP   }
;Reg[D15] = 0x0000_0001
;AU_PSR = 0x01

{  NOP  |  SW D15, A1, 424  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01A8] = 0x0000_0001

{  NOP  |  NOP  |  SRA D10, D0, D1  |  NOP  |  NOP  }
;Reg[D10] = 0x007F_FFFF
;AU_PSR = 0x00

{  NOP  |  NOP  |  SRA.D D11, D0, D1  |  NOP  |  NOP  }
;Reg[D11] = 0x7FFF_FFFF
;AU_PSR = 0x00

{  NOP  |  NOP  |  SRAI D12, D0, 4  |  NOP  |  NOP  }
;Reg[D12] = 0x07FF_FFFF
;AU_PSR = 0x00

{  NOP  |  NOP  |  SRAI.D D13, D0, 4 |  NOP  |  NOP  }
;Reg[D13] = 0x07FF_FFFF
;AU_PSR = 0x00

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D15, AU_PSR  |  NOP  |  NOP   }
;Reg[D15] = 0x0000_0000
;AU_PSR = 0x00

{  NOP  |  SW D15, A1, 428  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01AC] = 0x0000_0000

;-------------------------------------------------------------- Store Result
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0000] = 0xFFFF_FF00, Reg[A0] = 0x1E00_0004

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0004] = 0x7FFF_FF00, Reg[A0] = 0x1E00_0008

{  NOP  |  SW D4, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0008] = 0xFFFF_8000, Reg[A0] = 0x1E00_000C

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_000C] = 0x8000_8000, Reg[A0] = 0x1E00_0010

{  NOP  |  SW D6, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0010] = 0x007F_FFFF, Reg[A0] = 0x1E00_0014

{  NOP  |  SW D7, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0014] = 0x7FFF_00FF, Reg[A0] = 0x1E00_0018

{  NOP  |  SW D8, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0018] = 0x07FF_FFFF, Reg[A0] = 0x1E00_001C

{  NOP  |  SW D9, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_001C] = 0x07FF_0FFF, Reg[A0] = 0x1E00_0020

{  NOP  |  SW D10, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0020] = 0x007F_FFFF, Reg[A0] = 0x1E00_0024

{  NOP  |  SW D11, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0024] = 0x7FFF_FFFF, Reg[A0] = 0x1E00_0028

{  NOP  |  SW D12, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0028] = 0x07FF_FFFF, Reg[A0] = 0x1E00_002C

{  NOP  |  SW D13, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_002C] = 0x07FF_FFFF, Reg[A0] = 0x1E00_0030


;************************************************************** EXTRACT(U), EXTRACTI(U) , INSERT, INSERTI
{  NOP  |  NOP  |  MOVI.L D0, 0x5678  |  NOP  |  NOP  }
;Reg[D0] = 0x7FFF_5678

{  NOP  |  NOP  |  MOVI.H D0, 0x1234  |  NOP  |  NOP  }
;Reg[D0] = 0x1234_5678

{  NOP  |  NOP  |  MOVI.L D1, 0x0008  |  NOP  |  NOP  }
;Reg[D1] = 0x0000_0008

{  NOP  |  NOP  |  MOVI.H D1, 0x0010  |  NOP  |  NOP  }
;Reg[D1] = 0x0010_0008

{  NOP  |  NOP  |  EXTRACT D2, D0, D1  |  NOP  |  NOP  }
;Reg[D2] = 0x0000_3456

{  NOP  |  NOP  |  EXTRACTU D3, D0, D1  |  NOP  |  NOP  }
;Reg[D3] = 0x0000_3456

{  NOP  |  NOP  |  MOVI.L D4, 0xBA98  |  NOP  |  NOP  }
;Reg[D4] = 0xFFFF_BA98

{  NOP  |  NOP  |  MOVI.H D4, 0xFEDC  |  NOP  |  NOP  }
;Reg[D4] = 0xFEDC_BA98

{  NOP  |  NOP  |  EXTRACTI D5, D4, 16, 8  |  NOP  |  NOP  }
;Reg[D5] = 0xFFFF_DCBA

{  NOP  |  NOP  |  EXTRACTIU D6, D4, 16, 8  |  NOP  |  NOP  }
;Reg[D6] = 0x0000_DCBA

{  NOP  |  NOP  |  MOVI.L D8, 0x4321  |  NOP  |  NOP  }
;Reg[D8] = 0x07FF_4321

{  NOP  |  NOP  |  MOVI.H D8, 0x8765  |  NOP  |  NOP  }
;Reg[D8] = 0x8765_4321

{  NOP  |  NOP  |  MOVI.L D9, 0x0008  |  NOP  |  NOP  }
;Reg[D9] = 0x07FF_0008 

{  NOP  |  NOP  |  MOVI.H D9, 0x0010  |  NOP  |  NOP  }
;Reg[D9] = 0x0010_0008

{  NOP  |  NOP  |  INSERT D10, D8, D9  |  NOP  |  NOP  }
;Reg[D10] = 0x0043_21FF

{  NOP  |  NOP  |  INSERTI D11, D8, 8, 8  |  NOP  |  NOP  }
;Reg[D11] = 0x7FFF_21FF
;-------------------------------------------------------------- Store Result
{  NOP  |  SW D0, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0030] = 0x1234_5678, Reg[A0] = 0x1E00_0034

{  NOP  |  SW D1, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0034] = 0x0010_0008, Reg[A0] = 0x1E00_0038

{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0038] = 0x0000_3456, Reg[A0] = 0x1E00_003C

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_003C] = 0x0000_3456, Reg[A0] = 0x1E00_0040

{  NOP  |  SW D4, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0040] = 0xFEDC_BA98, Reg[A0] = 0x1E00_0044

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0044] = 0xFFFF_DCBA, Reg[A0] = 0x1E00_0048

{  NOP  |  SW D6, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0048] = 0x0000_DCBA, Reg[A0] = 0x1E00_004C

{  NOP  |  SW D8, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_004C] = 0x8765_4321, Reg[A0] = 0x1E00_0050

{  NOP  |  SW D9, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0050] = 0x0010_0008, Reg[A0] = 0x1E00_0054

{  NOP  |  SW D10, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0054] = 0x0043_21FF, Reg[A0] = 0x1E00_0058

{  NOP  |  SW D11, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0058] = 0x7FFF_21FF, Reg[A0] = 0x1E00_005C


;************************************************************** ROL, ROR
{  NOP  |  NOP  |  MOVI.L D0, 0xFFFF  |  NOP  |  NOP  }
;Reg[D0] = 0x1234_FFFF 

{  NOP  |  NOP  |  MOVI.H D0, 0xFFFF  |  NOP  |  NOP  }
;Reg[D0] = 0xFFFF_FFFF

{  NOP  |  NOP  |  MOVI.L D1, 0x000F  |  NOP  |  NOP  }
;Reg[D1] = 0x0010_000F

{  NOP  |  NOP  |  MOVI.H D1, 0x0000  |  NOP  |  NOP  }
;Reg[D1] = 0x0000_000F

{  NOP  |  NOP  |  ADD D2, D0, D1  |  NOP  |  NOP  }
;Reg[D2] = 0x0000_000E, AU_PSR[1](C) = 0x1

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  ROL D3, D2  |  NOP  |  NOP  }
;Reg[D3] = 0x0000_001D, AU_PSR[1](C) = 0x0

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  } 

{  NOP  |  NOP  |  ROR D4, D2  |  NOP  |  NOP  }
;Reg[D4] = 0x0000_0007, AU_PSR[1](C) = 0x0
;-------------------------------------------------------------- Store Result
{  NOP  |  SW D0, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_005C] = 0xFFFF_FFFF, Reg[A0] = 0x1E00_0060

{  NOP  |  SW D1, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0060] = 0x0000_000F, Reg[A0] = 0x1E00_0064

{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0064] = 0x0000_000E, Reg[A0] = 0x1E00_0068

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0068] = 0x0000_001D, Reg[A0] = 0x1E00_006C

{  NOP  |  SW D4, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_006C] = 0x0000_0007, Reg[A0] = 0x1E00_0070


;************************************************************** AND, OR, XOR, NOT, ANDI, ORI, XORI
{  NOP  |  NOP  |  MOVI.L D0, 0x0000  |  NOP  |  NOP  }
;Reg[D0] = 0xFFFF_0000

{  NOP  |  NOP  |  MOVI.H D0, 0xFFFF  |  NOP  |  NOP  }
;Reg[D0] = 0xFFFF_0000

{  NOP  |  NOP  |  MOVI.L D1, 0xFF00  |  NOP  |  NOP  }
;Reg[D1] = 0x0000_FF00

{  NOP  |  NOP  |  MOVI.H D1, 0xFF00  |  NOP  |  NOP  }
;Reg[D1] = 0xFF00_FF00

{  NOP  |  NOP  |  AND D2, D0, D1  |  NOP  |  NOP  }
;Reg[D2] = 0xFF00_0000

{  NOP  |  NOP  |  OR D3, D0, D1  |  NOP  |  NOP  }
;Reg[D3] = 0xFFFF_FF00

{  NOP  |  NOP  |  XOR D4, D0, D1  |  NOP  |  NOP  }
;Reg[D4] = 0x00FF_FF00

{  NOP  |  NOP  |  NOT D5, D0  |  NOP  |  NOP  }
;Reg[D5] = 0x0000_FFFF

{  NOP  |  NOP  |  ANDI D6, D0, 0xFFFF  |  NOP  |  NOP  }
;Reg[D6] = 0x0000_0000

{  NOP  |  NOP  |  ORI D7, D0, 0xFFFF  |  NOP  |  NOP  }
;Reg[D7] = 0xFFFF_FFFF

{  NOP  |  NOP  |  XORI D8, D0, 0xFFFF  |  NOP  |  NOP  }
;Reg[D8] = 0xFFFF_FFFF
;-------------------------------------------------------------- Store Result
{  NOP  |  SW D0, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0070] = 0xFFFF_0000, Reg[A0] = 0x1E00_0074

{  NOP  |  SW D1, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0074] = 0xFF00_FF00, Reg[A0] = 0x1E00_0078

{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0078] = 0xFF00_0000, Reg[A0] = 0x1E00_007C

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_007C] = 0xFFFF_FF00, Reg[A0] = 0x1E00_0080

{  NOP  |  SW D4, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0080] = 0x00FF_FF00, Reg[A0] = 0x1E00_0084

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0084] = 0x0000_FFFF, Reg[A0] = 0x1E00_0088

{  NOP  |  SW D6, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0088] = 0x0000_0000, Reg[A0] = 0x1E00_008C

{  NOP  |  SW D7, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_008C] = 0xFFFF_FFFF, Reg[A0] = 0x1E00_0090

{  NOP  |  SW D8, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0090] = 0xFFFF_FFFF, Reg[A0] = 0x1E00_0094


;************************************************************** ANDP, ORP, XORP, NOTP 
{  NOP  |  NOP  |  MOVI.L D0, 0xFFFF  |  NOP  |  NOP  }
;Reg[D0] = 0xFFFF_FFFF

{  NOP  |  NOP  |  MOVI.H D0, 0xFFFF  |  NOP  |  NOP  }
;Reg[D0] = 0xFFFF_FFFF

{  NOP  |  NOP  |  SLTI D15, P1, P2, D0, 0x7FFF   |  NOP  |  NOP  }
;Reg[P1] = 0x1, Reg[P2] = 0x0

{  NOP  |  NOP  |  ANDP P3, P1, P2  |  NOP  |  NOP  }
;Reg[P3] = 0x0;

{  NOP  |  NOP  |  ORP P4, P1, P2  |  NOP  |  NOP  }
;Reg[P4] = 0x1;

{  NOP  |  NOP  |  XORP P5, P1, P2  |  NOP  |  NOP  }
;Reg[P5] = 0x1;

{  NOP  |  NOP  |  NOTP P6, P1  |  NOP  |  NOP  }
;Reg[P6] = 0x0;                     
;-------------------------------------------------------------- Store Result
{  NOP  |  (P1) SW D0, A0, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0094] = 0xFFFF_FFFF, Reg[A0] = 0x1E00_0098

{  NOP  |  (P2) SW D1, A0, 0  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  NOP  |  (P3) SW D1, A0, 0  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  NOP  |  (P4) SW D0, A0, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0098] = 0xFFFF_FFFF, Reg[A0] = 0x1E00_009C

{  NOP  |  (P5) SW D0, A0, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_009C] = 0xFFFF_FFFF, Reg[A0] = 0x1E00_00A0

{  NOP  |  (P6) SW D1, A0, 4+  |  NOP  |  NOP  |  NOP  }
; Non-Execution


;/////////////////////////////////////// Encode /////////////////////////////////////////////
{  NOP  |  NOP  |  MOVI.L D0, 0x8FFF  |  NOP  |  NOP  }
;Reg[D0] = 0xFFFF_8FFF

{  NOP  |  NOP  |  MOVI.H D0, 0x7FFF  |  NOP  |  NOP  }
;Reg[D0] = 0x7FFF_8FFF

{  NOP  |  NOP  |  MOVI.L D1, 0x0008  |  NOP  |  NOP  }
;Reg[D1] = 0xFF00_0008

{  NOP  |  NOP  |  MOVI.H D1, 0x0000  |  NOP  |  NOP  }
;Reg[D1] = 0x0000_0008

{  NOP  |  NOP  |  MOVI.L D2, 0x1111  |  NOP  |  NOP  }
;Reg[D2] = 0xFF00_1111

{  NOP  |  NOP  |  MOVI.H D2, 0x1111  |  NOP  |  NOP  }
;Reg[D2] = 0x1111_1111

{  NOP  |  NOP  |  MOVI.L D3, 0x1111  |  NOP  |  NOP  }
;Reg[D3] = 0xFFFF_1111

{  NOP  |  NOP  |  MOVI.H D3, 0x1111  |  NOP  |  NOP  }
;Reg[D3] = 0x1111_1111

{  NOP  |  NOP  |  MOVI.L D4, 0x1111  |  NOP  |  NOP  }
;Reg[D4] = 0x00FF_1111

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
;Reg[D7] = 0xFFFF_1111

{  NOP  |  NOP  |  MOVI.H D7, 0x1111  |  NOP  |  NOP  }
;Reg[D7] = 0x1111_1111

{  NOP  |  NOP  |  MOVI.L D8, 0x1111  |  NOP  |  NOP  }
;Reg[D8] = 0xFFFF_1111

{  NOP  |  NOP  |  MOVI.H D8, 0x1111  |  NOP  |  NOP  }
;Reg[D8] = 0x1111_1111

{  NOP  |  NOP  |  MOVI.L D9, 0x1111  |  NOP  |  NOP  }
;Reg[D9] = 0x0010_1111

{  NOP  |  NOP  |  MOVI.H D9, 0x1111  |  NOP  |  NOP  }
;Reg[D9] = 0x1111_1111

{  NOP  |  NOP  |  SLTI D15, P1, P2, D0, 0x7FFFFFFF  |  NOP  |  NOP  }
;Reg[D15] = 0x0000_0001, Reg[P1] = 0x1, Reg[P2] = 0x0

;************************************************************** SLL.(D), SLLI.(D)
{  NOP  |  NOP  | (P1) SLL D2, D0, D1  |  NOP  |  NOP  }
;Reg[D2] = 0xFF8F_FF00
;AU_PSR = 0x03

{  NOP  |  NOP  | (P2) SLL D3, D0, D1  |  NOP  |  NOP  }
; Non-Execution

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D15, AU_PSR  |  NOP  |  NOP   }
;Reg[D15] = 0x0000_0003
;AU_PSR = 0x03

{  NOP  |  SW D15, A1, 432  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01B0] = 0x0000_0003

{  NOP  |  NOP  | (P1) SLL.D D4, D0, D1  |  NOP  |  NOP  }
;Reg[D4] = 0x7FFF_FF00
;AU_PSR = 0x0002

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D15, AU_PSR  |  NOP  |  NOP   }
;Reg[D15] = 0x0000_0002
;AU_PSR = 0x02

{  NOP  |  SW D15, A1, 436  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01B4] = 0x0000_0002

{  NOP  |  NOP  | (P2) SLL.D D5, D0, D1  |  NOP  |  NOP  }
; Non-Execution

{  NOP  |  NOP  | (P1) SLLI D6, D0, 15  |  NOP  |  NOP  }
;Reg[D6] = 0xC7FF_8000

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D15, AU_PSR  |  NOP  |  NOP   }
;Reg[D15] = 0x0000_0003
;AU_PSR = 0x03

{  NOP  |  SW D15, A1, 440  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01B8] = 0x0000_0003

{  NOP  |  NOP  | (P2) SLLI D7, D0, 15  |  NOP  |  NOP  }
; Non-Execution

{  NOP  |  NOP  | (P1) SLLI.D D8, D0, 15  |  NOP  |  NOP  }
;Reg[D8] = 0x8000_8000

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D15, AU_PSR  |  NOP  |  NOP   }
;Reg[D15] = 0x0000_0003
;AU_PSR = 0x03

{  NOP  |  SW D15, A1, 444  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01BC] = 0x0000_0003

{  NOP  |  NOP  | (P2) SLLI.D D9, D0, 15  |  NOP  |  NOP  }
; Non-Execution

;-------------------------------------------------------------- Store Result
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00A0] = 0xFF8F_FF00, Reg[A0] = 0x1E00_00A4

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00A4] = 0x1111_1111, Reg[A0] = 0x1E00_00A8

{  NOP  |  SW D4, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00A8] = 0x7FFF_FF00, Reg[A0] = 0x1E00_00AC

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00AC] = 0x1111_1111, Reg[A0] = 0x1E00_00B0

{  NOP  |  SW D6, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00B0] = 0xC7FF_8000, Reg[A0] = 0x1E00_00B4

{  NOP  |  SW D7, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00B4] = 0x1111_1111, Reg[A0] = 0x1E00_00B8

{  NOP  |  SW D8, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00B8] = 0x8000_8000, Reg[A0] = 0x1E00_00BC

{  NOP  |  SW D9, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00BC] = 0x1111_1111, Reg[A0] = 0x1E00_00C0



;************************************************************** SRL.(D), SRLI.(D)
{  NOP  |  NOP  | (P1) SRL D2, D0, D1  |  NOP  |  NOP  }
;Reg[D2] = 0x007F_FF8F
;AU_PSR = 0x01

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D15, AU_PSR  |  NOP  |  NOP   }
;Reg[D15] = 0x0000_0001
;AU_PSR = 0x01

{  NOP  |  SW D15, A1, 448  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01C0] = 0x0000_0001

{  NOP  |  NOP  | (P2) SRL D3, D0, D1  |  NOP  |  NOP  }
; Non-Execution

{  NOP  |  NOP  | (P1) SRL.D D4, D0, D1  |  NOP  |  NOP  }
;Reg[D4] = 0x7FFF_008F
;AU_PSR = 0x01

{  NOP  |  NOP  | (P2) SRL.D D5, D0, D1  |  NOP  |  NOP  }
; Non-Execution

{  NOP  |  NOP  | (P1) SRLI D6, D0, 15  |  NOP  |  NOP  }
;Reg[D6] = 0x0000_FFFF
;AU_PSR = 0x01

{  NOP  |  NOP  | (P2) SRLI D7, D0, 15  |  NOP  |  NOP  }
; Non-Execution

{  NOP  |  NOP  | (P1) SRLI.D D8, D0, 15  |  NOP  |  NOP  }
;Reg[D8] = 0x0000_0001
;AU_PSR = 0x01

{  NOP  |  NOP  | (P2) SRLI.D D9, D0, 15  |  NOP  |  NOP  }
; Non-Execution

;-------------------------------------------------------------- Store Result
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00C0] = 0x007F_FF8F, Reg[A0] = 0x1E00_00C4

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00C4] = 0x1111_1111, Reg[A0] = 0x1E00_00C8

{  NOP  |  SW D4, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00C8] = 0x7FFF_008F, Reg[A0] = 0x1E00_00CC

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00CC] = 0x1111_1111, Reg[A0] = 0x1E00_00D0

{  NOP  |  SW D6, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00D0] = 0x0000_FFFF, Reg[A0] = 0x1E00_00D4

{  NOP  |  SW D7, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00D4] = 0x1111_1111, Reg[A0] = 0x1E00_00D8

{  NOP  |  SW D8, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00D8] = 0x0000_0001, Reg[A0] = 0x1E00_00DC

{  NOP  |  SW D9, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00DC] = 0x1111_1111, Reg[A0] = 0x1E00_00E0




;************************************************************** SRA.(D), SRAI.(D)  
{  NOP  |  NOP  | (P1) SRA D2, D0, D1  |  NOP  |  NOP  }
;Reg[D2] = 0x007F_FF8F
;AU_PSR = 0x00

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D15, AU_PSR  |  NOP  |  NOP   }
;Reg[D15] = 0x0000_0000
;AU_PSR = 0x00

{  NOP  |  SW D15, A1, 452  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01C4] = 0x0000_0000

{  NOP  |  NOP  | (P2) SRA D3, D0, D1  |  NOP  |  NOP  }
; Non-Execution

{  NOP  |  NOP  | (P1) SRA.D D4, D0, D1  |  NOP  |  NOP  }
;Reg[D4] = 0x7FFF_FF8F

{  NOP  |  NOP  | (P2) SRA.D D5, D0, D1  |  NOP  |  NOP  }
; Non-Execution

{  NOP  |  NOP  | (P1) SRAI D6, D0, 15  |  NOP  |  NOP  }
;Reg[D6] = 0x0000_FFFF

{  NOP  |  NOP  | (P2) SRAI D7, D0, 15  |  NOP  |  NOP  }
; Non-Execution

{  NOP  |  NOP  | (P1) SRAI.D D8, D0, 15  |  NOP  |  NOP  }
;Reg[D8] = 0x0000_FFFF

{  NOP  |  NOP  | (P2) SRAI.D D9, D0, 15  |  NOP  |  NOP  }
; Non-Execution

;-------------------------------------------------------------- Store Result
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00E0] = 0x007F_FF8F, Reg[A0] = 0x1E00_00E4

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00E4] = 0x1111_1111, Reg[A0] = 0x1E00_00E8

{  NOP  |  SW D4, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00E8] = 0x7FFF_FF8F, Reg[A0] = 0x1E00_00EC

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00EC] = 0x1111_1111, Reg[A0] = 0x1E00_00F0

{  NOP  |  SW D6, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00F0] = 0x0000_FFFF, Reg[A0] = 0x1E00_00F4

{  NOP  |  SW D7, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00F4] = 0x1111_1111, Reg[A0] = 0x1E00_00F8

{  NOP  |  SW D8, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00F8] = 0x0000_FFFF, Reg[A0] = 0x1E00_00FC

{  NOP  |  SW D9, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00FC] = 0x1111_1111, Reg[A0] = 0x1E00_0100


;************************************************************** AND, OR, XOR, NOT
{  NOP  |  NOP  |  MOVI.L D0, 0x0000  |  NOP  |  NOP  }
;Reg[D0] = 0x7FFF_0000

{  NOP  |  NOP  |  MOVI.H D0, 0xFFFF  |  NOP  |  NOP  }
;Reg[D0] = 0xFFFF_0000

{  NOP  |  NOP  |  MOVI.L D1, 0xFF00  |  NOP  |  NOP  }
;Reg[D1] = 0x0000_FF00

{  NOP  |  NOP  |  MOVI.H D1, 0xFF00  |  NOP  |  NOP  }
;Reg[D1] = 0xFF00_FF00

{  NOP  |  NOP  | (P1) AND D2, D0, D1  |  NOP  |  NOP  }
;Reg[D2] = 0xFF00_0000

{  NOP  |  NOP  | (P2) AND D3, D0, D1  |  NOP  |  NOP  }
; Non-Execution

{  NOP  |  NOP  | (P1) OR D4, D0, D1  |  NOP  |  NOP  }
;Reg[D4] = 0xFFFF_FF00

{  NOP  |  NOP  | (P2) OR D5, D0, D1  |  NOP  |  NOP  }
; Non-Execution

{  NOP  |  NOP  | (P1) XOR D6, D0, D1  |  NOP  |  NOP  }
;Reg[D6] = 0x00FF_FF00

{  NOP  |  NOP  | (P2) XOR D7, D0, D1  |  NOP  |  NOP  }
; Non-Execution

{  NOP  |  NOP  | (P1) NOT D8, D0  |  NOP  |  NOP  }
;Reg[D8] = 0x0000_FFFF

{  NOP  |  NOP  | (P2) NOT D9, D0  |  NOP  |  NOP  }
; Non-Execution
;-------------------------------------------------------------- Store Result
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0100] = 0xFF00_0000, Reg[A0] = 0x1E00_0104

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0104] = 0x1111_1111, Reg[A0] = 0x1E00_0108

{  NOP  |  SW D4, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0108] = 0xFFFF_FF00, Reg[A0] = 0x1E00_010C

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_010C] = 0x1111_1111, Reg[A0] = 0x1E00_0110

{  NOP  |  SW D6, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0110] = 0x00FFFF00, Reg[A0] = 0x1E00_0114

{  NOP  |  SW D7, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0114] = 0x1111_1111, Reg[A0] = 0x1E00_0118

{  NOP  |  SW D8, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0118] = 0x0000_FFFF, Reg[A0] = 0x1E00_011C

{  NOP  |  SW D9, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_011C] = 0x1111_1111, Reg[A0] = 0x1E00_0120



;************************************************************** ANDI, ORI, XORI
{  NOP  |  NOP  | (P1) ANDI D2, D1, 0xFFFF  |  NOP  |  NOP  }
;Reg[D2] = 0x0000_FF00

{  NOP  |  NOP  | (P2) ANDI D3, D1, 0xFFFF  |  NOP  |  NOP  }
; Non-Execution

{  NOP  |  NOP  | (P1) ORI D4, D1, 0xFFFF  |  NOP  |  NOP  }
;Reg[D4] = 0xFF00_FFFF

{  NOP  |  NOP  | (P2) ORI D5, D1, 0xFFFF  |  NOP  |  NOP  }
; Non-Execution

{  NOP  |  NOP  | (P1) XORI D6, D1, 0xFFFF  |  NOP  |  NOP  }
;Reg[D6] = 0xFF00_00FF

{  NOP  |  NOP  | (P2) XORI D7, D1, 0xFFFF  |  NOP  |  NOP  }
; Non-Execution
;-------------------------------------------------------------- Store Result
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0120] = 0x0000_FF00, Reg[A0] = 0x1E00_0124

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0124] = 0x1111_1111, Reg[A0] = 0x1E00_0128

{  NOP  |  SW D4, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0128] = 0xFF00_FFFF, Reg[A0] = 0x1E00_012C

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_012C] = 0x1111_1111, Reg[A0] = 0x1E00_0130

{  NOP  |  SW D6, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0130] = 0xFF00_00FF, Reg[A0] = 0x1E00_0134

{  NOP  |  SW D7, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0134] = 0x1111_1111, Reg[A0] = 0x1E00_0138


;************************************************************** EXTRACT(U), EXTRACTI(U)
{  NOP  |  NOP  |  MOVI.L D0, 0x5678  |  NOP  |  NOP  }
;Reg[D0] = 0xFFFF_5678

{  NOP  |  NOP  |  MOVI.H D0, 0xFFFF  |  NOP  |  NOP  }
;Reg[D0] = 0xFFFF_5678

{  NOP  |  NOP  |  MOVI.L D1, 0x0008  |  NOP  |  NOP  }
;Reg[D1] = 0xFF00_0008

{  NOP  |  NOP  |  MOVI.H D1, 0x0010  |  NOP  |  NOP  }
;Reg[D1] = 0x0010_0008

{  NOP  |  NOP  | (P1) EXTRACT D2, D0, D1  |  NOP  |  NOP  }
;Reg[D2] = 0xFFFF_FF56

{  NOP  |  NOP  | (P2) EXTRACT D3, D0, D1  |  NOP  |  NOP  }
; Non-Execution

{  NOP  |  NOP  | (P1) EXTRACTU D4, D0, D1  |  NOP  |  NOP  }
;Reg[D4] = 0x0000_FF56

{  NOP  |  NOP  | (P2) EXTRACTU D5, D0, D1  |  NOP  |  NOP  }
; Non-Execution

{  NOP  |  NOP  | (P1) EXTRACTI D6, D0, 16, 8  |  NOP  |  NOP  }
;Reg[D6] = 0xFFFF_FF56

{  NOP  |  NOP  | (P2) EXTRACTI D7, D0, 16, 8  |  NOP  |  NOP  }
; Non-Execution

{  NOP  |  NOP  | (P1) EXTRACTIU D8, D0, 16, 8  |  NOP  |  NOP  }
;Reg[D8] = 0x0000_FF56

{  NOP  |  NOP  | (P2) EXTRACTIU D9, D0, 16, 8  |  NOP  |  NOP  }
; Non-Execution
;-------------------------------------------------------------- Store Result
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0138] = 0xFFFF_FF56, Reg[A0] = 0x1E00_013C

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_013C] = 0x1111_1111, Reg[A0] = 0x1E00_0140

{  NOP  |  SW D4, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0140] = 0x0000_FF56, Reg[A0] = 0x1E00_0144

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0144] = 0x1111_1111, Reg[A0] = 0x1E00_0148

{  NOP  |  SW D6, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0148] = 0xFFFF_FF56, Reg[A0] = 0x1E00_014C

{  NOP  |  SW D7, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_014C] = 0x1111_1111, Reg[A0] = 0x1E00_0150

{  NOP  |  SW D8, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0150] = 0x0000_FF56, Reg[A0] = 0x1E00_0154

{  NOP  |  SW D9, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0154] = 0x1111_1111, Reg[A0] = 0x1E00_0158



;************************************************************** NSERT, INSERTI
{  NOP  |  NOP  |  MOVI.L D0, 0x4321  |  NOP  |  NOP  }
;Reg[D0] = 0xFFFF_4321

{  NOP  |  NOP  |  MOVI.H D0, 0x8765  |  NOP  |  NOP  }
;Reg[D0] = 0x8765_4321				

{  NOP  |  NOP  |  MOVI.L D1, 0x0008  |  NOP  |  NOP  }
;Reg[D1] = 0x0010_0008 

{  NOP  |  NOP  |  MOVI.H D1, 0x0010  |  NOP  |  NOP  }
;Reg[D1] = 0x0010_0008

{  NOP  |  NOP  | (P1) INSERT D2, D0, D1  |  NOP  |  NOP  }
;Reg[D2] = 0xFF43_2156												************* Sam

{  NOP  |  NOP  | (P2) INSERT D3, D0, D1  |  NOP  |  NOP  }
; Non-Execution

{  NOP  |  NOP  | (P1) INSERTI D4, D0, 8, 8  |  NOP  |  NOP  }
;Reg[D4] = 0x0000_2156												************* Sam

{  NOP  |  NOP  | (P2) INSERTI D5, D0, 8, 8  |  NOP  |  NOP  }
; Non-Execution
;-------------------------------------------------------------- Store Result
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0158] = 0xFF43_2156, Reg[A0] = 0x1E00_015C

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_015C] = 0x1111_1111, Reg[A0] = 0x1E00_0160

{  NOP  |  SW D4, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0160] = 0x0000_2156, Reg[A0] = 0x1E00_0164

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0164] = 0x1111_1111, Reg[A0] = 0x1E00_0168


;************************************************************** ANDP, ORP, XORP, NOTP 
{  NOP  |  NOP  |  NOTP P3, P1  |  NOP  |  NOP  }
;Reg[P3] = 0x0;   

{  NOP  |  NOP  |  NOTP P4, P1  |  NOP  |  NOP  }
;Reg[P4] = 0x0;  

{  NOP  |  NOP  |  NOTP P5, P1  |  NOP  |  NOP  }
;Reg[P5] = 0x0;  

{  NOP  |  NOP  |  NOTP P6, P1  |  NOP  |  NOP  }
;Reg[P6] = 0x0;  

{  NOP  |  NOP  |  NOTP P7, P1  |  NOP  |  NOP  }
;Reg[P7] = 0x0;  

{  NOP  |  NOP  |  NOTP P8, P1  |  NOP  |  NOP  }
;Reg[P8] = 0x0;  

{  NOP  |  NOP  |  NOTP P9, P1  |  NOP  |  NOP  }
;Reg[P9] = 0x0;  

{  NOP  |  NOP  |  NOTP P10, P1  |  NOP  |  NOP  }
;Reg[P10] = 0x0; 

{  NOP  |  NOP  | (P1) ANDP P3, P1, P1  |  NOP  |  NOP  }
;Reg[P3] = 0x1;

{  NOP  |  NOP  | (P2) ANDP P4, P1, P1  |  NOP  |  NOP  }
; Non-Execution

{  NOP  |  NOP  | (P1) ORP P5, P1, P2  |  NOP  |  NOP  }
;Reg[P5] = 0x1;

{  NOP  |  NOP  | (P2) ORP P6, P1, P2  |  NOP  |  NOP  }
; Non-Execution

{  NOP  |  NOP  | (P1) XORP P7, P1, P2  |  NOP  |  NOP  }
;Reg[P7] = 0x1;

{  NOP  |  NOP  | (P2) XORP P8, P1, P2  |  NOP  |  NOP  }
; Non-Execution

{  NOP  |  NOP  | (P1) NOTP P9, P2  |  NOP  |  NOP  }
;Reg[P9] = 0x1;          

{  NOP  |  NOP  | (P2) NOTP P10, P2  |  NOP  |  NOP  }
; Non-Execution             
;-------------------------------------------------------------- Store Result
{  NOP  | (P3) SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0168] = 0xFF43_2156, Reg[A0] = 0x1E00_016C

{  NOP  | (P4) SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
; Non-Execution 

{  NOP  | (P5) SW D4, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_016C] = 0x0000_2156, Reg[A0] = 0x1E00_0170

{  NOP  | (P6) SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  NOP  | (P7) SW D6, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0170] = 0xFFFF_FF56, Reg[A0] = 0x1E00_0174

{  NOP  | (P8) SW D7, A0, 4+    |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  NOP  | (P9) SW D8, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0174] = 0x0000_FF56, Reg[A0] = 0x1E00_0178

{  NOP  | (P10) SW D9, A0, 4+    |  NOP  |  NOP  |  NOP  }
; Non-Execution



;************************************************************** ROL, ROR
{  NOP  |  NOP  |  MOVI.L D0, 0xFFFF  |  NOP  |  NOP  }
;Reg[D0] = 0x8765_FFFF 

{  NOP  |  NOP  |  MOVI.H D0, 0xFFFF  |  NOP  |  NOP  }
;Reg[D0] = 0xFFFF_FFFF

{  NOP  |  NOP  |  MOVI.L D1, 0x000F  |  NOP  |  NOP  }
;Reg[D1] = 0x0010_000F

{  NOP  |  NOP  |  MOVI.H D1, 0x0000  |  NOP  |  NOP  }
;Reg[D1] = 0x0000_000F

{  NOP  |  NOP  |  ADD D2, D0, D1  |  NOP  |  NOP  }
;Reg[D2] = 0x0000_000E, AU_PSR[1](C) = 0x1

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  | (P1) ROL D2, D2  |  NOP  |  NOP  }
;Reg[D2] = 0x0000_001D, AU_PSR[1](C) = 0x0

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  } 

{  NOP  |  NOP  | (P2) ROL D3, D2  |  NOP  |  NOP  }
; Non-Execution

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  } 

{  NOP  |  NOP  | (P1) ROR D4, D2  |  NOP  |  NOP  }
;Reg[D4] = 0x0000_000E, AU_PSR[1](C) = 0x1

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  } 

{  NOP  |  NOP  | (P2) ROR D5, D2  |  NOP  |  NOP  }
; Non-Execution
;-------------------------------------------------------------- Store Result
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0178] = 0x0000_001D, Reg[A0] = 0x1E00_017C

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_017C] = 0x1111_1111, Reg[A0] = 0x1E00_0180

{  NOP  |  SW D4, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0180] = 0x0000_000E, Reg[A0] = 0x1E00_0184

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0184] = 0x1111_1111, Reg[A0] = 0x1E00_0188




;************************************************************** SFRA.(D)
{  NOP  |  NOP  |  MOVI.L D0, 0x1234  |  NOP  |  NOP  }
;Reg[D0] = 0xFFFF_1234 

{  NOP  |  NOP  |  MOVI.H D0, 0x8FFF  |  NOP  |  NOP  }
;Reg[D0] = 0x8FFF_1234

{  NOP  |  NOP  | (P1) SFRA D2, D0, 8  |  NOP  |  NOP  }
;Reg[D2] = 0xFF8F_FF2F

{  NOP  |  NOP  | (P2) SFRA D3, D0, 8  |  NOP  |  NOP  }
; Non-Execution

{  NOP  |  NOP  | (P1) SFRA.D D4, D0, 8  |  NOP  |  NOP  }
;Reg[D4] = 0xFF8F_0020

{  NOP  |  NOP  | (P2) SFRA.D D5, D0, 8  |  NOP  |  NOP  }
; Non-Execution

;-------------------------------------------------------------- Store Result
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0188] = 0xFF8F_FF2F, Reg[A0] = 0x1E00_018C

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_018C] = 0x1111_1111, Reg[A0] = 0x1E00_0190

{  NOP  |  SW D4, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0190] = 0xFF8F_0020, Reg[A0] = 0x1E00_0194

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0194] = 0x1111_1111, Reg[A0] = 0x1E00_0198



;************************************************************** Program Terminate
{  TRAP  |  NOP  |  NOP  |  NOP  |  NOP  }
