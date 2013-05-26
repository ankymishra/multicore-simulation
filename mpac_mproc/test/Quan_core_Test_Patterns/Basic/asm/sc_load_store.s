
BASE_ADDR = 0x2400

;************************************************************** Set Start Address
{  COPY R1, SR15   |  NOP  |  NOP  |  NOP  |  NOP  }
{  SLLI R1, R1, 20 |  NOP  |  NOP  |  NOP  |  NOP  }

{  MOVI.L R0, 0x0000    |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R0, BASE_ADDR |  NOP  |  NOP  |  NOP  |  NOP  }
{  ADD R0, R0, R1       |  NOP  |  NOP  |  NOP  |  NOP  }

{  MOVI.L R2, 0x0020    |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R2, BASE_ADDR |  NOP  |  NOP  |  NOP  |  NOP  }
{  ADD R2, R2, R1       |  NOP  |  NOP  |  NOP  |  NOP  }

;************************************************************** Initialize Memory
{  MOVI.L R3, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R3] = 0x0000_0000

{  MOVI.H R3, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R3] = 0x0000_0000

{  SW R3, R0, 0  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0000] = 0x0000_0000

{  SW R3, R0, 4  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0004] = 0x0000_0000

{  SW R3, R0, 8  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0008] = 0x0000_0000

{  SW R3, R0, 12  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_000C] = 0x0000_0000

{  SW R3, R0, 16  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0010] = 0x0000_0000

{  SW R3, R0, 20  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0014] = 0x0000_0000

{  SW R3, R0, 24  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0018] = 0x0000_0000

{  SW R3, R0, 28  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_001C] = 0x0000_0000

{  SW R3, R0, 32  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0020] = 0x0000_0000

{  SW R3, R0, 36  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0024] = 0x0000_0000

{  SW R3, R0, 40  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0028] = 0x0000_0000

{  SW R3, R0, 44  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_002C] = 0x0000_0000

{  SW R3, R0, 48  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0030] = 0x0000_0000

{  SW R3, R0, 52  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0034] = 0x0000_0000

{  SW R3, R0, 56  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0038] = 0x0000_0000

{  SW R3, R0, 60  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_003C] = 0x0000_0000

{  SW R3, R0, 64  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0040] = 0x0000_0000

{  SW R3, R0, 68  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0044] = 0x0000_0000



;**************************************************************¡iLinear:Offset¡j SW

{  MOVI.L R1, 0x000C  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R1] = 0x0000_000C

{  MOVI.H R1, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R1] = 0x0000_000C

{  MOVI.L R3, 0xFFF0  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R3] = 0x0000_FFF0

{  MOVI.H R3, 0xFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R3] = 0xFFFF_FFF0

{  MOVI.L R4, 0xDDCC  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R4] = 0x0000_DDCC

{  MOVI.H R4, 0x0FEE  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R4] = 0x0FEE_DDCC 



{  SW R4, R0, 4  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0004] = 0x0FEE_DDCC

{  SW R4, R2, -24  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0008] = 0x0FEE_DDCC


;-------------------------------------------------------------- Address Update
{  ADDI R0, R0, 0x00000010  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R0] = 0x1E00_0010

{  ADDI R2, R2, 0x00000010  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R0] = 0x1E00_0030




;**************************************************************¡iLinear:Offset¡j SH

{  SH R4, R0, 4  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0014] = 0x0000_DDCC

{  SH R4, R2, -22  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0018] = 0xDDCC_0000



;-------------------------------------------------------------- Address Update
{  ADDI R0, R0, 0x00000010  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R0] = 0x1E00_0020

{  ADDI R2, R2, 0x00000010  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R0] = 0x1E00_0040



;**************************************************************¡iLinear:Offset¡j SB


{  SB R4, R0, 5  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0024] = 0x0000_CC00

{  SB R4, R2, -21  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0028] = 0xCC00_0000



;-------------------------------------------------------------- Address Update
{  ADDI R0, R0, 0x00000010  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R0] = 0x1E00_0030

{  ADDI R2, R2, 0x00000010  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R0] = 0x1E00_0050

{  COPY R6, SR15   |  NOP  |  NOP  |  NOP  |  NOP  }
{  SLLI R6, R6, 20 |  NOP  |  NOP  |  NOP  |  NOP  }

{  MOVI.L R5, 0x0000    |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R5, BASE_ADDR |  NOP  |  NOP  |  NOP  |  NOP  }    ; modify by JH for 7056
{  ADD R5, R5, R6       |  NOP  |  NOP  |  NOP  |  NOP  }

{  MOVI.L R7, 0x0020    |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R7, BASE_ADDR |  NOP  |  NOP  |  NOP  |  NOP  }    ; modify by JH for 7056
{  ADD R7, R7, R6       |  NOP  |  NOP  |  NOP  |  NOP  }

{  MOVI.L R6, 0x000C  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R6] = 0x0000_000C

{  MOVI.H R6, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R6] = 0x0000_000C

{  MOVI.L R8, 0xFFF0  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R8] = 0x0000_FFF0

{  MOVI.H R8, 0xFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R8] = 0xFFFF_FFF0



;**************************************************************¡iLinear:Offset¡j LW


{  LW R9, R5, 4  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R9] = 0x0FEE_DDCC

{  LW R10, R7, -24  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R10] = 0x0FEE_DDCC

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

;-------------------------------------------------------------- Store Result 

{  SW R9, R0, 4  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0034] = 0x0FEE_DDCC

{  SW R10, R0, 8  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0038] = 0x0FEE_DDCC


;-------------------------------------------------------------- Address Update
{  ADDI R0, R0, 0x00000010  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R0] = 0x1E00_0040

{  ADDI R1, R2, 0x00000010  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R0] = 0x1E00_0060




;**************************************************************¡iLinear:Offset¡j LH
{  LH R9, R5, 4  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R9] = 0xFFFF_DDCC

{  LH R10, R7, -22  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R10] = 0x0000_0FEE

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
;-------------------------------------------------------------- Store Result 

{  SW R9, R0, 4  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0044] = 0xFFFF_DDCC

{  SW R10, R0, 8  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0048] = 0x0000_0FFF										0x0000_0FEE	 ********************* Sam



;-------------------------------------------------------------- Address Update
{  ADDI R0, R0, 0x00000010  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R0] = 0x1E00_0050

{  ADDI R2, R2, 0x00000010  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R0] = 0x1E00_0070



;**************************************************************¡iLinear:Offset¡j LHU
{  LHU R9, R5, 4  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R9] = 0x0000_DDCC

{  LHU R10, R7, -22  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R10] = 0x0000_0FFF

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
;-------------------------------------------------------------- Store Result 

{  SW R9, R0, 4  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0054] = 0x0000_DDCC

{  SW R10, R0, 8  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0058] = 0x0000_0FFF											0x0000_0FEE	 ********************* Sam



;-------------------------------------------------------------- Address Update
{  ADDI R0, R0, 0x00000010  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R0] = 0x1E00_0060

{  ADDI R2, R2, 0x00000010  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R0] = 0x1E00_0080




;**************************************************************¡iLinear:Offset¡j LB
{  LB R9, R5, 5  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R9] = 0xFFFF_FFDD

{  LB R10, R7, -21  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R10] = 0x0000_000F

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
;-------------------------------------------------------------- Store Result 

{  SW R9, R0, 4  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0064] = 0xFFFF_FFDD

{  SW R10, R0, 8  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0068] = 0x0000_000F


;-------------------------------------------------------------- Address Update
{  ADDI R0, R0, 0x00000010  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R0] = 0x1E00_0070

{  ADDI R2, R2, 0x00000010  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R0] = 0x1E00_0090



;**************************************************************¡iLinear:Offset¡j LBU
{  LBU R9, R5, 5  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R9] = 0x0000_00DD

{  LBU R10, R7, -21  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R10] = 0x0000_000F

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
;-------------------------------------------------------------- Store Result 

{  SW R9, R0, -16  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0060] = 0x0000_00DD

{  SW R10, R0, -4  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_006C] = 0x0000_000F


;**************************************************************¡iLinear:Post-Increment¡j SW
{  ADDI R0, R0, 0x00000004  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R0] = 0x1E00_0074

{  MOVI.L R1, 0x0008  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R1] = 0x0000_0008

{  MOVI.H R1, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R1] = 0x0000_0008


{  SW R4, R0, 8+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0074]  = 0x0FEE_DDCC, Reg[R0] = 0x1E00_007C

{  SW R0, R0, (-4)+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_007C]  = 0x1E00_007C, Reg[R0] = 0x1E00_0078

{  SW R4, R0, 8+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0078] = 0x0FEE_DDCC, Reg[R0] = 0x1E00_0080


;**************************************************************¡iLinear:Post-Increment¡j SH
{  SW R1, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0080]  = 0x0000_0008, Reg[R0] = 0x1E00_0084

{  SW R1, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0084]  = 0x0000_0008, Reg[R0] = 0x1E00_0088

{  SW R1, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0088]  = 0x0000_0008, Reg[R0] = 0x1E00_008C

{  SW R1, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_008C]  = 0x0000_0008, Reg[R0] = 0x1E00_0090

{  SW R1, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0090]  = 0x0000_0008, Reg[R0] = 0x1E00_0094

{  SW R1, R0, (-20)+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0094]  = 0x0000_0008, Reg[R0] = 0x1E00_0080



{  SH R4, R0, 8+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0080]  = 0x0000_DDCC, Reg[R0] = 0x1E00_0088

{  SH R0, R0, (-4)+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0088]  = 0x0000_0088, Reg[R0] = 0x1E00_0084

{  SH R4, R0, 8+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0084] = 0x0000_DDCC, Reg[R0] = 0x1E00_008C

{  ADDI R1, R1, 0x0000000C  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R1] = 0x0000_0008




;**************************************************************¡iLinear:Post-Increment¡j SB
{  SW R1, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_008C]  = 0x0000_0008, Reg[R0] = 0x1E00_0090

{  SW R1, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0090]  = 0x0000_0008, Reg[R0] = 0x1E00_0094

{  SW R1, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0094]  = 0x0000_0008, Reg[R0] = 0x1E00_0098

{  SW R1, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0098]  = 0x0000_0008, Reg[R0] = 0x1E00_009C

{  SW R1, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_009C]  = 0x0000_0008, Reg[R0] = 0x1E00_00A0

{  SW R1, R0, (-20)+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00A0]  = 0x0000_0008, Reg[R0] = 0x1E00_008C



{  SB R4, R0, 8+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_008C] = 0x0000_00CC, Reg[R0] = 0x1E00_0094

{  SB R0, R0, (-4)+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0094] = 0x0000_0094, Reg[R0] = 0x1E00_0090

{  SB R4, R0, 8+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0090] = 0x0000_00CC, Reg[R0] = 0x1E00_0098




;**************************************************************¡iLinear:Post-Increment¡j LW

{  ADDI R5, R5, 0x00000004  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R5] = 0x1E00_0004

{  MOVI.L R6, 0x0008  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R6] = 0x0000_0008

{  MOVI.H R6, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R6] = 0x0000_0008


{  LW R9, R5, 8+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[9] = 0x0FEE_DDCC , Reg[R5] = 0x1E00_000C

{  LW R10, R5, (-4)+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[10] = 0x0000_0000 , Reg[R5] = 0x1E00_0008

{  LW R11, R5, 8+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[11] = 0x0FEE_DDCC , Reg[R5] = 0x1E00_0010



;-------------------------------------------------------------- Store Result 

{  SW R9, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0098] = 0x0FEE_DDCC, Reg[R0] = 0x1E00_009C

{  SW R10, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_009C] = 0x0000_0000, Reg[R0] = 0x1E00_00A0

{  SW R11, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00A0] = 0x0FEE_DDCC, Reg[R0] = 0x1E00_00A4

{  SW R5, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00A4] = 0x1E00_0010, Reg[R0] = 0x1E00_00A8


;**************************************************************¡iLinear:Post-Increment¡j LH

{  LH R9, R5, 8+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[9] = 0x0000_0000 , Reg[R5] = 0x1E00_0018

{  LH R10, R5, (-4)+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[10] = 0x0000_0000 , Reg[R5] = 0x1E00_0014

{  LH R11, R5, 8+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[11] = 0xFFFF_DDCC , Reg[R5] = 0x1E00_001C


;-------------------------------------------------------------- Store Result 

{  SW R9, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00A8] = 0x0000_0000, Reg[R0] = 0x1E00_00AC

{  SW R10, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00AC] = 0x0000_0000, Reg[R0] = 0x1E00_00B0

{  SW R11, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00B0] = 0xFFFF_DDCC, Reg[R0] = 0x1E00_00B4

{  SW R5, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00B4] = 0x1E00_001C, Reg[R0] = 0x1E00_00B8



;**************************************************************¡iLinear:Post-Increment¡j LHU

{  LHU R9, R5, 8+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[9] = 0x0000_0000 , Reg[R5] = 0x1E00_0024

{  LHU R10, R5, (-4)+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[10] = 0x0000_CC00 , Reg[R5] = 0x1E00_0020

{  LHU R11, R5, 8+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[11] = 0x0000_0000 , Reg[R5] = 0x1E00_0028


;-------------------------------------------------------------- Store Result 

{  SW R9, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00B8] = 0x0000_0000, Reg[R0] = 0x1E00_00BC

{  SW R10, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00BC] = 0x0000_CC00, Reg[R0] = 0x1E00_00C0

{  SW R11, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00C0] = 0x0000_0000, Reg[R0] = 0x1E00_00C4

{  SW R5, R0, 8+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00C4] = 0x1E00_0028, Reg[R0] = 0x1E00_00C8


;**************************************************************¡iLinear:Post-Increment¡j LB

{  LB R9, R5, 15+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[9] = 0x0000_0000 , Reg[R5] = 0x1E00_0037

{  LB R10, R5, (-1)+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[10] = 0x0000_000F , Reg[R5] = 0x1E00_0036

{  LB R11, R5, (-2)+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[11] = 0xFFFF_FFEE , Reg[R5] = 0x1E00_0034


;-------------------------------------------------------------- Store Result 

{  SW R9, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00CC] = 0x0000_0000, Reg[R0] = 0x1E00_00D0

{  SW R10, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00D0] = 0x0000_000F, Reg[R0] = 0x1E00_00D4

{  SW R11, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00D4] = 0xFFFF_FFEE, Reg[R0] = 0x1E00_00D8

{  SW R5, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00D8] = 0x1E00_0034, Reg[R0] = 0x1E00_00DC





;**************************************************************¡iLinear:Post-Increment¡j LBU

{  LBU R9, R5, 8+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[9] = 0x0000_00CC , Reg[R5] = 0x1E00_003C

{  LBU R10, R5, (-4)+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[10] = 0x0000_0000 , Reg[R5] = 0x1E00_0038

{  LBU R11, R5, 8+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[11] = 0x0000_00CC , Reg[R5] = 0x1E00_0040


;-------------------------------------------------------------- Store Result 

{  SW R9, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00DC] = 0x0000_00CC, Reg[R0] = 0x1E00_00E0

{  SW R10, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00E0] = 0x0000_0000, Reg[R0] = 0x1E00_00E4

{  SW R11, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00E4] = 0x0000_00CC, Reg[R0] = 0x1E00_00E8

{  SW R5, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00E8] = 0x1E00_0040, Reg[R0] = 0x1E00_00EC



;************************************************************** Program Terminate
{  TRAP  |  NOP  |  NOP  |  NOP  |  NOP  }
