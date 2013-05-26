
BASE_ADDR = 0x2400

;************************************************************** Set Start Address
{  COPY R1, SR15   |  NOP  |  NOP  |  NOP  |  NOP  }
{  SLLI R1, R1, 20 |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.L R0, 0x0000    |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R0, BASE_ADDR |  NOP  |  NOP  |  NOP  |  NOP  }
{  ADD R0, R0, R1       |  NOP  |  NOP  |  NOP  |  NOP  }

;**********************************************************************		with conditional bit
;************************************************************** SLL(I), SRL(I), SRA(I)  
{  MOVI.L R1, 0xFE00  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R1] = 0x0000_FE00

{  MOVI.H R1, 0x7FFF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R1] = 0x7FFF_FE00

{  MOVI.L R2, 0x0008  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0008

{  MOVI.H R2, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0008

{  SLT R15, P14, P15, R2, R1  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R15] = 0x0000_0001, Reg[P14] = 1, Reg[P15] = 0
;-------------------------------------------------------------- SLL
{  (P14) SLL R3, R1, R2  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R3] = 0xFFFE_0000, carry = 1, overflow = 1

{  (P15) SLL R3, R1, R15  |  NOP  |  NOP  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  READ_FLAG R7  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R7] = 0x0000_0003

{  (P14) SLL R4, R3, R2  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R3] = 0xFE00_0000, carry = 1, overflow = 0

{  (P15) SLL R4, R1, R15  |  NOP  |  NOP  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  READ_FLAG R8  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R8] = 0x0000_0002

{  (P14) SLL R5, R4, R2  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R3] = 0x0000_0000, carry = 0, overflow = 1

{  (P15) SLL R5, R1, R15  |  NOP  |  NOP  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  READ_FLAG R9  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R9] = 0x0000_0001

{  (P14) SLL R6, R5, R2  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R3] = 0x0000_0000, carry = 0, overflow = 0

{  (P15) SLL R6, R1, R15  |  NOP  |  NOP  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  READ_FLAG R10  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R10] = 0x0000_0000

;-------------------------------------------------------------- Store Result 
{  SW R3, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0000] = 0xFFFE_0000, Reg[R0] = 0x1E00_0004

{  SW R4, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0004] = 0xFE00_0000, Reg[R0] = 0x1E00_0008

{  SW R5, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0008] = 0x0000_0000, Reg[R0] = 0x1E00_000C

{  SW R6, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_000C] = 0x0000_0000, Reg[R0] = 0x1E00_0010

{  SW R7, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0010] = 0x0000_0003, Reg[R0] = 0x1E00_0014

{  SW R8, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0014] = 0x0000_0002, Reg[R0] = 0x1E00_0018

{  SW R9, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0018] = 0x0000_0001, Reg[R0] = 0x1E00_001C

{  SW R10, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_001C] = 0x0000_0000, Reg[R0] = 0x1E00_0020

;-------------------------------------------------------------- SLLI
{  (P14) SLLI R3, R1, 0x08  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R3] = 0xFFFE_0000, carry = 1, overflow = 1

{  (P15) SLLI R3, R1, 0x04  |  NOP  |  NOP  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  READ_FLAG R7  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R7] = 0x0000_0003

{  (P14) SLLI R4, R3, 0x08  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R3] = 0xFE00_0000, carry = 1, overflow = 0

{  (P15) SLLI R4, R1, 0x08  |  NOP  |  NOP  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  READ_FLAG R8  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R8] = 0x0000_0002

{  (P14) SLLI R5, R4, 0x08  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R3] = 0x0000_0000, carry = 0, overflow = 1

{  (P15) SLLI R5, R1, 0x08  |  NOP  |  NOP  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  READ_FLAG R9  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R9] = 0x0000_0001

{  (P14) SLLI R6, R5, 0x08  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R3] = 0x0000_0000, carry = 0, overflow = 0

{  (P15) SLLI R6, R1, 0x08  |  NOP  |  NOP  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  READ_FLAG R10  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R10] = 0x0000_0000

;-------------------------------------------------------------- Store Result 
{  SW R3, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0020] = 0xFFFE_0000, Reg[R0] = 0x1E00_0024

{  SW R4, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0024] = 0xFE00_0000, Reg[R0] = 0x1E00_0028

{  SW R5, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0028] = 0x0000_0000, Reg[R0] = 0x1E00_002C

{  SW R6, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_002C] = 0x0000_0000, Reg[R0] = 0x1E00_0030

{  SW R7, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0030] = 0x0000_0003, Reg[R0] = 0x1E00_0034

{  SW R8, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0034] = 0x0000_0002, Reg[R0] = 0x1E00_0038

{  SW R9, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0038] = 0x0000_0001, Reg[R0] = 0x1E00_003C

{  SW R10, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_003C] = 0x0000_0000, Reg[R0] = 0x1E00_0040

;-------------------------------------------------------------- SRL, SRLI, SRA, SRAI
{  (P14) SRL R3, R1, R2  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R3] = 0x007F_FFFE

{  (P15) SRL R3, R1, R15  |  NOP  |  NOP  |  NOP  |  NOP  }
;Not execute

{  (P14) SRLI R4, R1, 0x04  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R4] = 0x07FF_FFE0

{  (P15) SRLI R4, R1, 0x02  |  NOP  |  NOP  |  NOP  |  NOP  }
;Not execute

{  MOVI.L R1, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R1] = 0x7FFF_0000

{  MOVI.H R1, 0x8000  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R1] = 0x8000_0000

{  (P14) SRA R5, R1, R2  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R5] = 0xFF80_0000

{  (P15) SRA R5, R1, R15  |  NOP  |  NOP  |  NOP  |  NOP  }
;Not execute

{  (P14) SRAI R6, R1, 0x04  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R6] = 0xF800_0000

{  (P15) SRAI R6, R1, 0x02  |  NOP  |  NOP  |  NOP  |  NOP  }
;Not execute

;-------------------------------------------------------------- Store Result 
{  SW R3, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0040] = 0x007F_FFFE, Reg[R0] = 0x1E00_0044

{  SW R4, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0044] = 0x07FF_FFE0, Reg[R0] = 0x1E00_0048

{  SW R5, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0048] = 0xFF80_0000, Reg[R0] = 0x1E00_004C

{  SW R6, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_004C] = 0xF800_0000, Reg[R0] = 0x1E00_0050

;**********************************************************************		without conditional bit
;************************************************************** SLL(I), SRL(I), SRA(I)  
{  MOVI.L R1, 0xFE00  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R1] = 0x0000_FE00

{  MOVI.H R1, 0x7FFF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R1] = 0x7FFF_FE00

{  MOVI.L R2, 0x0008  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0008

{  MOVI.H R2, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0008

;-------------------------------------------------------------- SLL
{  SLL R3, R1, R2  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R3] = 0xFFFE_0000, carry = 1, overflow = 1

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  READ_FLAG R7  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R7] = 0x0000_0003

{  SLL R4, R3, R2  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R3] = 0xFE00_0000, carry = 1, overflow = 0

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  READ_FLAG R8  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R8] = 0x0000_0002

{  SLL R5, R4, R2  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R3] = 0x0000_0000, carry = 0, overflow = 1

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  READ_FLAG R9  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R9] = 0x0000_0001

{  SLL R6, R5, R2  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R3] = 0x0000_0000, carry = 0, overflow = 0

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  READ_FLAG R10  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R10] = 0x0000_0000

;-------------------------------------------------------------- Store Result 
{  SW R3, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0050] = 0xFFFE_0000, Reg[R0] = 0x1E00_0054

{  SW R4, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0054] = 0xFE00_0000, Reg[R0] = 0x1E00_0058

{  SW R5, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0058] = 0x0000_0000, Reg[R0] = 0x1E00_005C

{  SW R6, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_005C] = 0x0000_0000, Reg[R0] = 0x1E00_0060

{  SW R7, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0060] = 0x0000_0003, Reg[R0] = 0x1E00_0064

{  SW R8, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0064] = 0x0000_0002, Reg[R0] = 0x1E00_0068

{  SW R9, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0068] = 0x0000_0001, Reg[R0] = 0x1E00_006C

{  SW R10, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_006C] = 0x0000_0000, Reg[R0] = 0x1E00_0070

;-------------------------------------------------------------- SRL, SRA
{  SRL R3, R1, R2  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R3] = 0x007F_FFFE

{  MOVI.L R1, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R1] = 0x7FFF_0000

{  MOVI.H R1, 0x8000  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R1] = 0x8000_0000

{  SRA R4, R1, R2  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R5] = 0xFF80_0000

;-------------------------------------------------------------- Store Result 
{  SW R3, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0070] = 0x007F_FFFE, Reg[R0] = 0x1E00_0074

{  SW R4, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0074] = 0xFF80_0000, Reg[R0] = 0x1E00_0078



;************************************************************** Program Terminate
{  TRAP  |  NOP  |  NOP  |  NOP  |  NOP  }
