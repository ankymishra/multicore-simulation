
BASE_ADDR = 0x2400

;************************************************************** Set Start Address
{  MOVI.L R0, 0x0000    |  MOVI.L A0, 0x0100    |  NOP  |  MOVI.L A1, 0x0200    |  NOP  }

{  MOVI.H R0, BASE_ADDR |  MOVI.H A0, BASE_ADDR |  NOP  |  MOVI.H A1, BASE_ADDR |  NOP  }

;**************************************************************
{  NOP  |  NOP  |  MOVI.L D15, 0xFFFF  |  NOP  |  NOP  }
;Reg[D15] = 0x0000_FFFF

{  NOP  |  NOP  |  MOVI.H D15, 0xFFFF  |  NOP  |  NOP  }
;Reg[D15] = 0xFFFF_FFFF

{  NOP  |  NOP  |  SLTI D14, P14, P15, D15, 0x00000000   |  NOP  |  NOP  }
;Reg[D14] = 0x0000_0001, Reg[P14] = 1, Reg[P15] = 0

;**************************************************************With conditional execution
;************************************************************** BDT, BDR, DEX
{  MOVI.L R1, 0xBBBB  |  MOVI.L D0, 0x2222  |  NOP  |  MOVI.L D0, 0x4444  |  NOP  }
;Reg[R1] = 0x0000_BBBB, Reg[D0] = 0x0000_2222,		;Reg[D0] = 0x0000_4444

{  MOVI.H R1, 0xAAAA  |  MOVI.H D0, 0x1111  |  NOP  |  MOVI.H D0, 0x3333  |  NOP  }
;Reg[R1] = 0xAAAA_BBBB, Reg[D0] = 0x1111_2222		;Reg[D0] = 0x3333_4444

{  MOVI.L R15, 0xFFFF  |  MOVI.L D7, 0xFFFF  |  NOP  |  MOVI.L D7, 0xFFFF  |  NOP  }
;Reg[R15] = 0x0000_FFFF, Reg[D7] = 0x0000_FFFF,		;Reg[D7] = 0x0000_FFFF

{  MOVI.H R15, 0xFFFF  |  MOVI.H D7, 0xFFFF  |  NOP  |  MOVI.H D7, 0xFFFF  |  NOP  }
;Reg[R15] = 0xFFFF_FFFF, Reg[D7] = 0xFFFF_FFFF		;Reg[D7] = 0xFFFF_FFFF

{  MOVI.L R14, 0xFFFF  |  MOVI.L D6, 0xFFFF  |  NOP  |  MOVI.L D6, 0xFFFF  |  NOP  }
;Reg[R14] = 0x0000_FFFF, Reg[D6] = 0x0000_FFFF,		;Reg[D6] = 0x0000_FFFF

{  MOVI.H R14, 0xFFFF  |  MOVI.H D6, 0xFFFF  |  NOP  |  MOVI.H D6, 0xFFFF  |  NOP  }
;Reg[R14] = 0xFFFF_FFFF, Reg[D6] = 0xFFFF_FFFF		;Reg[D6] = 0xFFFF_FFFF

;-------------------------------------------------------------- SC&LS
{  (P14) BDT R1  |  (P14) BDR D1  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0xAAAA_BBBB

{  (P15) BDT R15  |  (P15) BDR D1  |  NOP  |  NOP  |  NOP  }
;Not execute
;--------------------------------------------------------------
{  (P14) BDT R1  |  NOP  |  NOP  |  (P14) BDR D1  |  NOP  }
				;Reg[D1] = 0xAAAA_BBBB

{  (P15) BDT R15  |  NOP  |  NOP  |  (P15) BDR D1  |  NOP  }
;Not execute
;--------------------------------------------------------------
{  (P14) BDR R2  |  (P14) BDT D0  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x1111_2222

{  (P15) BDR R2  |  (P15) BDT D7  |  NOP  |  NOP  |  NOP  }
;Not execute
;--------------------------------------------------------------
{  (P14) BDR R3  |  NOP  |  NOP  |  (P14) BDT D0  |  NOP  }
;Reg[R3] = 0x3333_4444

{  (P15) BDR R3  |  NOP  |  NOP  |  (P15) BDT D7  |  NOP  }
;Not execute
;--------------------------------------------------------------
{  NOP  |  (P14) BDT D0  |  NOP  |  (P14) BDR D2  |  NOP  }
;				Reg[D2] = 0x1111_2222

{  NOP  |  (P15) BDT D7  |  NOP  |  (P15) BDR D2  |  NOP  }
;Not execute
;--------------------------------------------------------------
{  NOP  |  (P14) BDR D2  |  NOP  |  (P14) BDT D0  |  NOP  }
;Reg[D2] = 0x3333_4444

{  NOP  |  (P15) BDR D2  |  NOP  |  (P15) BDT D7  |  NOP  }
;Not execute
;--------------------------------------------------------------
{  (P14) DEX R4, R1  |  (P14) DEX D3, D0  |  NOP  |  NOP  |  NOP  }
;Reg[R4] = 0x1111_2222
;Reg[D3] = 0xAAAA_BBBB

{  (P15) DEX R4, R15  |  (P15) DEX D3, D7  |  NOP  |  NOP  |  NOP  }
;Not execute
;--------------------------------------------------------------
{  (P14) DEX R5, R1  |  NOP  |  NOP  |  (P14) DEX D3, D0  |  NOP  }
;Reg[R5] = 0x3333_4444, 	;Reg[D3] = 0xAAAA_BBBB 

{  (P15) DEX R5, R15  |  NOP  |  NOP  |  (P15) DEX D3, D7  |  NOP  }
;Not execute
;--------------------------------------------------------------
{  NOP  |  (P14) DEX D4, D0  |  NOP  |  (P14) DEX D4, D0  |  NOP  }
;Reg[D4] = 0x3333_4444,		;Reg[D4] = 0x1111_2222

{  NOP  |  (P15) DEX D4, D7  |  NOP  |  (P15) DEX D4, D7  |  NOP  }
;Not execute
;-------------------------------------------------------------- Store Result 
{  SW R2, R0, 4+  |  SW D1, A0, 4+  |  NOP  |  SW D1, A1, 4+  |  NOP  }
;Mem[0x1E00_0000] = 0x1111_2222, Reg[R0] = 0x1E00_0004
;Mem[0x1E00_0100] = 0xAAAA_BBBB, Reg[A0] = 0x1E00_0104
;Mem[0x1E00_0200] = 0xAAAA_BBBB, Reg[A1] = 0x1E00_0204

{  SW R3, R0, 4+  |  SW D2, A0, 4+  |  NOP  |  SW D2, A1, 4+  |  NOP  }
;Mem[0x1E00_0004] = 0x3333_4444, Reg[R0] = 0x1E00_0008
;Mem[0x1E00_0104] = 0x3333_4444, Reg[A0] = 0x1E00_0108
;Mem[0x1E00_0204] = 0x1111_2222, Reg[A1] = 0x1E00_0208

{  SW R4, R0, 4+  |  SW D3, A0, 4+  |  NOP  |  SW D3, A1, 4+  |  NOP  }
;Mem[0x1E00_0008] = 0x1111_2222, Reg[R0] = 0x1E00_000C
;Mem[0x1E00_0108] = 0xAAAA_BBBB, Reg[A0] = 0x1E00_010C
;Mem[0x1E00_0208] = 0xAAAA_BBBB, Reg[A1] = 0x1E00_020C

{  SW R5, R0, 4+  |  SW D4, A0, 4+  |  NOP  |  SW D4, A1, 4+  |  NOP  }
;Mem[0x1E00_000C] = 0x3333_4444, Reg[R0] = 0x1E00_0010
;Mem[0x1E00_010C] = 0x3333_4444, Reg[A0] = 0x1E00_0110
;Mem[0x1E00_020C] = 0x1111_2222, Reg[A1] = 0x1E00_0210

;************************************************************** DBDT, DBDR, DDEX
{  NOP  |  MOVI.L D2, 0x0000  |  NOP  |  MOVI.L D2, 0x0000  |  NOP  }
;Reg[D2] = 0x3333_0000,		;Reg[D2] = 0x1111_0000

{  NOP  |  MOVI.H D2, 0x0000  |  NOP  |  MOVI.H D2, 0x0000  |  NOP  }
;Reg[D2] = 0x0000_0000		;Reg[D2] = 0x0000_0000

{  NOP  |  MOVI.L D3, 0x0000  |  NOP  |  MOVI.L D3, 0x0000  |  NOP  }
;Reg[D3] = 0x3333_0000,		;Reg[D3] = 0x1111_0000

{  NOP  |  MOVI.H D3, 0x0000  |  NOP  |  MOVI.H D3, 0x0000  |  NOP  }
;Reg[D3] = 0x0000_0000		;Reg[D3] = 0x0000_0000

{  NOP  |  MOVI.L D4, 0x0000  |  NOP  |  MOVI.L D4, 0x0000  |  NOP  }
;Reg[D4] = 0x3333_0000,		;Reg[D4] = 0x1111_0000

{  NOP  |  MOVI.H D4, 0x0000  |  NOP  |  MOVI.H D4, 0x0000  |  NOP  }
;Reg[D4] = 0x0000_0000		;Reg[D4] = 0x0000_0000

{  NOP  |  MOVI.L D5, 0x0000  |  NOP  |  MOVI.L D5, 0x0000  |  NOP  }
;Reg[D5] = 0x3333_0000,		;Reg[D5] = 0x1111_0000

{  NOP  |  MOVI.H D5, 0x0000  |  NOP  |  MOVI.H D5, 0x0000  |  NOP  }
;Reg[D5] = 0x0000_0000		;Reg[D5] = 0x0000_0000

;--------------------------------------------------------------
{  NOP  |  (P14) DBDT D0, D1  |  NOP  |  (P14) DBDR D2  |  NOP  }
;				Reg[D2] = 0x1111_2222
;				Reg[D3] = 0xAAAA_BBBB

{  NOP  |  (P15) DBDT D6, D7  |  NOP  |  (P15) DBDR D2  |  NOP  }
;Not execute
;--------------------------------------------------------------
{  NOP  |  (P14) DBDR D2  |  NOP  |  (P14) DBDT D0, D1  |  NOP  }
;Reg[D2] = 0x3333_4444
;Reg[D3] = 0xAAAA_BBBB

{  NOP  |  (P15) DBDR D2  |  NOP  |  (P15) DBDT D6, D7  |  NOP  }
;Not execute
;--------------------------------------------------------------
{  NOP  |  (P14) DDEX D4, D0, D1  |  NOP  |  (P14) DDEX D4, D0, D1  |  NOP  }
;Reg[D4] = 0x3333_4444,		;Reg[D4] = 0x1111_2222
;Reg[D5] = 0xAAAA_BBBB,		;Reg[D5] = 0xAAAA_BBBB

{  NOP  |  (P15) DDEX D4, D6, D7  |  NOP  |  (P15) DDEX D4, D6, D7  |  NOP  }
;Not execute
;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D2, A0, 4+  |  NOP  |  SW D2, A1, 4+  |  NOP  }
;Mem[0x1E00_0110] = 0x3333_4444, Reg[A0] = 0x1E00_0114
;Mem[0x1E00_0210] = 0x1111_2222, Reg[A1] = 0x1E00_0214

{  NOP  |  SW D3, A0, 4+  |  NOP  |  SW D3, A1, 4+  |  NOP  }
;Mem[0x1E00_0114] = 0xAAAA_BBBB, Reg[A0] = 0x1E00_0118
;Mem[0x1E00_0214] = 0xAAAA_BBBB, Reg[A1] = 0x1E00_0218

{  NOP  |  SW D4, A0, 4+  |  NOP  |  SW D4, A1, 4+  |  NOP  }
;Mem[0x1E00_0118] = 0x3333_4444, Reg[A0] = 0x1E00_011C
;Mem[0x1E00_0218] = 0x1111_2222, Reg[A1] = 0x1E00_021C

{  NOP  |  SW D5, A0, 4+  |  NOP  |  SW D5, A1, 4+  |  NOP  }
;Mem[0x1E00_011C] = 0xAAAA_BBBB, Reg[A0] = 0x1E00_0120
;Mem[0x1E00_021C] = 0xAAAA_BBBB, Reg[A1] = 0x1E00_0220

;**************************************************************Without conditional execution
{  MOVI.L R1, 0x0000  |  MOVI.L D0, 0x0000  |  NOP  |  MOVI.L D0, 0x0000  |  NOP  }
;Reg[R1] = 0xAAAA_0000, Reg[D0] = 0x1111_0000,		;Reg[D0] = 0x3333_0000

{  MOVI.H R1, 0x0000  |  MOVI.H D0, 0x0000  |  NOP  |  MOVI.H D0, 0x0000  |  NOP  }
;Reg[R1] = 0x0000_0000, Reg[D0] = 0x0000_0000		;Reg[D0] = 0x0000_0000
;-------------------------------------------------------------- SC&LS
{  BDT R1  |  BDR D1  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x0000_0000
;--------------------------------------------------------------
{  BDT R1  |  NOP  |  NOP  |  BDR D1  |  NOP  }
				;Reg[D1] = 0x0000_0000
;--------------------------------------------------------------
{  BDR R2  |  BDT D0  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0000
;--------------------------------------------------
{  BDR R3  |  NOP  |  NOP  |  BDT D0  |  NOP  }
;Reg[R3] = 0x0000_0000
;--------------------------------------------------------------
{  NOP  |  BDT D0  |  NOP  |  BDR D2  |  NOP  }
;				Reg[D2] = 0x0000_0000
;--------------------------------------------------------------
{  NOP  |  BDR D2  |  NOP  |  BDT D0  |  NOP  }
;Reg[D2] = 0x0000_0000
;--------------------------------------------------------------
{  NOP  |  DBDT D0, D1  |  NOP  |  DBDR D4  |  NOP  }
;				Reg[D4] = 0x0000_0000
;				Reg[D5] = 0x0000_0000
;--------------------------------------------------------------
{  NOP  |  DBDR D4  |  NOP  |  DBDT D0, D1  |  NOP  }
;Reg[D2] = 0x0000_0000
;Reg[D3] = 0x0000_0000

;-------------------------------------------------------------- Store Result 
{  SW R2, R0, 4+  |  SW D1, A0, 4+  |  NOP  |  SW D1, A1, 4+  |  NOP  }
;Mem[0x1E00_0010] = 0x0000_0000, Reg[R0] = 0x1E00_0014
;Mem[0x1E00_0120] = 0x0000_0000, Reg[A0] = 0x1E00_0124
;Mem[0x1E00_0220] = 0x0000_0000, Reg[A1] = 0x1E00_0224

{  SW R3, R0, 4+  |  SW D2, A0, 4+  |  NOP  |  SW D2, A1, 4+  |  NOP  }
;Mem[0x1E00_0014] = 0x0000_0000, Reg[R0] = 0x1E00_0018
;Mem[0x1E00_0124] = 0x0000_0000, Reg[A0] = 0x1E00_0128
;Mem[0x1E00_0224] = 0x0000_0000, Reg[A1] = 0x1E00_0228

{  NOP  |  SW D4, A0, 4+  |  NOP  |  SW D4, A1, 4+  |  NOP  }
;Mem[0x1E00_0128] = 0x0000_0000, Reg[A0] = 0x1E00_012C
;Mem[0x1E00_0228] = 0x0000_0000, Reg[A1] = 0x1E00_022C

{  NOP  |  SW D5, A0, 4+  |  NOP  |  SW D5, A1, 4+  |  NOP  }
;Mem[0x1E00_012C] = 0x0000_0000, Reg[A0] = 0x1E00_0130
;Mem[0x1E00_022C] = 0x0000_0000, Reg[A1] = 0x1E00_0230


;************************************************************** Program Terminate
{  TRAP  |  NOP  |  NOP  |  NOP  |  NOP  }
