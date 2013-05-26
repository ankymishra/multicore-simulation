
BASE_ADDR = 0x2400

;************************************************************** Set Start Address
{  COPY R1, SR15   |  NOP  |  NOP  |  NOP  |  NOP  }
{  SLLI R1, R1, 20 |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.L R0, 0x0000    |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R0, BASE_ADDR |  NOP  |  NOP  |  NOP  |  NOP  }
{  ADD R0, R0, R1       |  NOP  |  NOP  |  NOP  |  NOP  }

;**********************************************************************		with conditional bit
;************************************************************** AND, OR, XOR, NOT, ANDI, ORI, XORI
{  MOVI.L R1, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R1] = 0x0000_0000

{  MOVI.H R1, 0xFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R1] = 0xFFFF_0000

{  MOVI.L R2, 0xFF00  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_FF00

{  MOVI.H R2, 0xFF00  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0xFF00_FF00

{  MOVI.L R14, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R14] = 0x0000_0000

{  MOVI.H R14, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R14] = 0x0000_0000

{  SLT R7, P14, P15, R2, R14  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R7] = 0x0000_0001, Reg[P14] = 1, Reg[P15] = 0

;--------------------------------------------------------------
{  (P14) AND R3, R1, R2  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R3] = 0xFF00_0000

{  (P15) AND R3, R1, R14  |  NOP  |  NOP  |  NOP  |  NOP  }
;Not execute

{  (P14) OR R4, R1, R2  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R4] = 0xFFFF_FF00

{  (P15) OR R4, R1, R14  |  NOP  |  NOP  |  NOP  |  NOP  }
;Not execute

{  (P14) XOR R5, R1, R2  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R5] = 0x00FF_FF00

{  (P15) XOR R5, R1, R14  |  NOP  |  NOP  |  NOP  |  NOP  }
;Not execute

{  (P14) NOT R6, R1  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R6] = 0x0000_FFFF

{  (P15) NOT R6, R14  |  NOP  |  NOP  |  NOP  |  NOP  }
;Not execute

{  (P14) ANDI R7, R1, 0x0F0FFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R7] = 0x0F0F_0000

{  (P15) ANDI R7, R1, 0x00000000  |  NOP  |  NOP  |  NOP  |  NOP  }
;Not execute

{  (P14) ORI R8, R1, 0x0F0FFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R8] = 0xFFFF_FFFF

{  (P15) ORI R8, R1, 0x00000000  |  NOP  |  NOP  |  NOP  |  NOP  }
;Not execute

{  (P14) XORI R9, R1, 0x0F0FFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R9] = 0xF0F0_FFFF

{  (P15) XORI R9, R1, 0x00000000  |  NOP  |  NOP  |  NOP  |  NOP  }
;Not execute


;-------------------------------------------------------------- Store Result 
{  SW R3, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0000] = 0xFF00_0000, Reg[R0] = 0x1E00_0004

{  SW R4, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0004] = 0xFFFF_FF00, Reg[R0] = 0x1E00_0008

{  SW R5, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0008] = 0x00FF_FF00, Reg[R0] = 0x1E00_000C

{  SW R6, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_000C] = 0x0000_FFFF, Reg[R0] = 0x1E00_0010

{  SW R7, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0010] = 0x0F0F_0000, Reg[R0] = 0x1E00_0014

{  SW R8, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0014] = 0xFFFF_FFFF, Reg[R0] = 0x1E00_0018

{  SW R9, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0018] = 0xF0F0_FFFF, Reg[R0] = 0x1E00_001C


;************************************************************** ANDP, ORP, XORP, NOTP 
{  MOVI.L R15, 0xFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R15] = 0xFFFFFFFF

{  MOVI.H R15, 0xFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R15] = 0xFFFFFFFF

{  SLTI R14, P1, P2, R15, 0x7FFF   |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[P1] = 1, Reg[P2] = 0

;--------------------------------------------------------------  ANDP
{  (P14) ANDP P3, P1, P2  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[P3] = 0;

{  (P15) ANDP P3, P1, P1  |  NOP  |  NOP  |  NOP  |  NOP  }
;Not execute

{  (P3) MOVI.L R15, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
;Not execute

{  (P3) MOVI.H R15, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
;Not execute

{ SW R15, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_001C] = 0xFFFFFFFF, Reg[R0] = 0x1E00_0020

;--------------------------------------------------------------  ORP
{  (P14) ORP P4, P1, P2  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[P4] = 1;

{  (P3) ORP P4, P2, P2  |  NOP  |  NOP  |  NOP  |  NOP  }
;Not execute

{  (P4) MOVI.L R15, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R15] = 0xFFFF0000

{  (P4) MOVI.H R15, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R15] = 0x00000000

{ SW R15, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0020] = 0x00000000, Reg[R0] = 0x1E00_0024
;--------------------------------------------------------------  XORP
{  (P4) XORP P5, P1, P2  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[P5] = 1;

{  (P3) XORP P5, P1, P2  |  NOP  |  NOP  |  NOP  |  NOP  }
;Not execute

{  (P5) MOVI.L R15, 0x1111  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R15] = 0x00001111

{  (P5) MOVI.H R15, 0x1111  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R15] = 0x11111111

{ SW R15, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0024] = 0x11111111, Reg[R0] = 0x1E00_0028
;--------------------------------------------------------------  NOTP
{  (P5) NOTP P6, P1  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[P6] = 0

{  (P3) NOTP P6, P0  |  NOP  |  NOP  |  NOP  |  NOP  }
;Not execute

{  (P6) MOVI.L R15, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R15] = 0x00001111

{  (P6) MOVI.H R15, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R15] = 0x11111111

{ SW R15, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0028] = 0x11111111, Reg[R0] = 0x1E00_002C


;**********************************************************************		without conditional bit
;************************************************************** AND, OR, XOR, NOT, ANDI, ORI, XORI
{  MOVI.L R1, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R1] = 0x0000_0000

{  MOVI.H R1, 0xFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R1] = 0xFFFF_0000

{  MOVI.L R2, 0xFF00  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_FF00

{  MOVI.H R2, 0xFF00  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0xFF00_FF00

{  MOVI.L R14, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R14] = 0x0000_0000

{  MOVI.H R14, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R14] = 0x0000_0000

{  SLT R7, P14, P15, R2, R14  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R7] = 0x0000_0001, Reg[P14] = 1, Reg[P15] = 0

;--------------------------------------------------------------
{  AND R3, R1, R2  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R3] = 0xFF00_0000

{  OR R4, R1, R2  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R4] = 0xFFFF_FF00

{  XOR R5, R1, R2  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R5] = 0x00FF_FF00

;-------------------------------------------------------------- Store Result 
{  SW R3, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_002C] = 0xFF00_0000, Reg[R0] = 0x1E00_0030

{  SW R4, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0030] = 0xFFFF_FF00, Reg[R0] = 0x1E00_0034

{  SW R5, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0034] = 0x00FF_FF00, Reg[R0] = 0x1E00_0038

;************************************************************** ANDP, ORP, XORP, NOTP 
{  MOVI.L R15, 0xFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R15] = 0xFFFFFFFF

{  MOVI.H R15, 0xFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R15] = 0xFFFFFFFF

{  SLTI R14, P1, P2, R15, 0x7FFF   |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[P1] = 1, Reg[P2] = 0

;--------------------------------------------------------------  ANDP
{  ANDP P3, P1, P2  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[P3] = 0;

{  (P3) MOVI.L R15, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R15] = 0xFFFF0000

{  (P3) MOVI.H R15, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R15] = 0x00000000

{ SW R15, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0038] = 0xFFFFFFFF, Reg[R0] = 0x1E00_003C

;--------------------------------------------------------------  ORP
{  ORP P4, P1, P2  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[P4] = 1;

{  (P4) MOVI.L R15, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R15] = 0xFFFF0000

{  (P4) MOVI.H R15, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R15] = 0x00000000

{ SW R15, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_003C] = 0x00000000, Reg[R0] = 0x1E00_0040
;--------------------------------------------------------------  XORP
{  XORP P5, P1, P2  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[P5] = 1;

{  (P5) MOVI.L R15, 0x1111  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R15] = 0x00001111

{  (P5) MOVI.H R15, 0x1111  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R15] = 0x11111111

{ SW R15, R0, 0  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0040] = 0x11111111, Reg[R0] = 0x1E00_0044


;************************************************************** Program Terminate
{  TRAP  |  NOP  |  NOP  |  NOP  |  NOP  }
