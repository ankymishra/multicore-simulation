
BASE_ADDR = 0x2400
  
;************************************************************** Set Start Address
{  NOP  |  MOVI.L A0, 0x0000    |  NOP  |  NOP  |  NOP  }

{  NOP  |  MOVI.H A0, BASE_ADDR |  NOP  |  NOP  |  NOP  }


;/////////////////////////////////////Function & Linear Addressing//////////////////////////////////////
;************************************************************** Initialize Memory
{  NOP  |  MOVI.L D0, 0x0000  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x0000_0000

{  NOP  |  MOVI.H D0, 0x0000  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x0000_0000

{  NOP  |  SW D0, A0, 0  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0000] = 0x0000_0000

{  NOP  |  SW D0, A0, 4  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0004] = 0x0000_0000

{  NOP  |  SW D0, A0, 8  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0008] = 0x0000_0000

{  NOP  |  SW D0, A0, 12  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_000C] = 0x0000_0000

{  NOP  |  SW D0, A0, 16  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0010] = 0x0000_0000

{  NOP  |  SW D0, A0, 20  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0014] = 0x0000_0000

{  NOP  |  SW D0, A0, 24  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0018] = 0x0000_0000

{  NOP  |  SW D0, A0, 28  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_001C] = 0x0000_0000

{  NOP  |  SW D0, A0, 32  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0020] = 0x0000_0000

{  NOP  |  SW D0, A0, 36  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0024] = 0x0000_0000

{  NOP  |  SW D0, A0, 40  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0028] = 0x0000_0000

{  NOP  |  SW D0, A0, 44  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_002C] = 0x0000_0000

{  NOP  |  SW D0, A0, 48  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0030] = 0x0000_0000

{  NOP  |  SW D0, A0, 52  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0034] = 0x0000_0000

{  NOP  |  SW D0, A0, 56  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0038] = 0x0000_0000

{  NOP  |  SW D0, A0, 60  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_003C] = 0x0000_0000

{  NOP  |  SW D0, A0, 64  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0040] = 0x0000_0000

{  NOP  |  SW D0, A0, 68  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0044] = 0x0000_0000

{  NOP  |  SW D0, A0, 72  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0048] = 0x0000_0000

{  NOP  |  SW D0, A0, 76  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_004C] = 0x0000_0000

{  NOP  |  SW D0, A0, 80  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0050] = 0x0000_0000

{  NOP  |  SW D0, A0, 84  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0054] = 0x0000_0000

{  NOP  |  SW D0, A0, 88  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0058] = 0x0000_0000

{  NOP  |  SW D0, A0, 92  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_005C] = 0x0000_0000

{  NOP  |  SW D0, A0, 96  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0060] = 0x0000_0000

{  NOP  |  SW D0, A0, 100  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0064] = 0x0000_0000

{  NOP  |  SW D0, A0, 104  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0068] = 0x0000_0000

{  NOP  |  SW D0, A0, 108  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_006C] = 0x0000_0000

{  NOP  |  SW D0, A0, 112  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0070] = 0x0000_0000

{  NOP  |  SW D0, A0, 116  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0074] = 0x0000_0000

{  NOP  |  SW D0, A0, 120  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0078] = 0x0000_0000

{  NOP  |  SW D0, A0, 124  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_007C] = 0x0000_0000

{  NOP  |  SW D0, A0, 128  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0080] = 0x0000_0000

{  NOP  |  SW D0, A0, 132  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0084] = 0x0000_0000

{  NOP  |  SW D0, A0, 136  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0088] = 0x0000_0000

{  NOP  |  SW D0, A0, 140  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_008C] = 0x0000_0000

{  NOP  |  SW D0, A0, 144  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0090] = 0x0000_0000

{  NOP  |  SW D0, A0, 148  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0094] = 0x0000_0000

;**************************************************************¡iLinear:Offset¡j (D)SW

{  NOP  |  MOVI.L A1, 0x000C  |  NOP  |  NOP  |  NOP  }
;Reg[A1] = 0x0000_000C

{  NOP  |  MOVI.H A1, 0x0000  |  NOP  |  NOP  |  NOP  }
;Reg[A1] = 0x0000_000C

{  NOP  |  MOVI.L A2, 0x0020  |  NOP  |  NOP  |  NOP  }
;Reg[A2] = 0x0000_0020

{  NOP  |  MOVI.H A2, BASE_ADDR  |  NOP  |  NOP  |  NOP  }
;Reg[A2] = 0x0800_0020, modify by JH for 7056

{  NOP  |  MOVI.L A3, 0xFFF0  |  NOP  |  NOP  |  NOP  }
;Reg[A3] = 0x0000_FFF0

{  NOP  |  MOVI.H A3, 0xFFFF  |  NOP  |  NOP  |  NOP  }
;Reg[A3] = 0xFFFF_FFF0

{  NOP  |  MOVI.L A4, 0x0034  |  NOP  |  NOP  |  NOP  }
;Reg[A4] = 0x0000_0034

{  NOP  |  MOVI.H A4, 0x0000  |  NOP  |  NOP  |  NOP  }
;Reg[A4] = 0x0000_0034

{  NOP  |  MOVI.L A5, 0x0024  |  NOP  |  NOP  |  NOP  }
;Reg[A5] = 0x0000_0024

{  NOP  |  MOVI.H A5, 0x0000  |  NOP  |  NOP  |  NOP  }
;Reg[A5] = 0x0000_0024

{  NOP  |  MOVI.L A6, 0x0044  |  NOP  |  NOP  |  NOP  }
;Reg[A6] = 0x0000_0044

{  NOP  |  MOVI.H A6, 0x0000  |  NOP  |  NOP  |  NOP  }
;Reg[A6] = 0x0000_0044

{  NOP  |  MOVI.L D2, 0xDDCC  |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0x0000_DDCC

{  NOP  |  MOVI.H D2, 0x0FEE  |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0x0FEE_DDCC 

{  NOP  |  MOVI.L D3, 0x5678  |  NOP  |  NOP  |  NOP  }
;Reg[D3] = 0x0000_5678

{  NOP  |  MOVI.H D3, 0x1234  |  NOP  |  NOP  |  NOP  }
;Reg[D3] = 0x1234_5678 



{  NOP  |  DSW D2, D3, A0, 0  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0000] = 0x0FEE_DDCC, Mem[0x1E00_0004] = 0x1234_5678

{  NOP  |  DSW D2, D3, A2, -24  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0008] = 0x0FEE_DDCC, Mem[0x1E00_000C] = 0x1234_5678

{  NOP  |  ADDI A0, A0, 0x00000004  |  NOP  |  NOP  |  NOP  }
;Reg[A0] = 0x1E00_0004

{  NOP  |  ADDI A2, A2, 0x00000008  |  NOP  |  NOP  |  NOP  }
;Reg[A2] = 0x1E00_0028

{  NOP  |  DSW D2, D3, A0, A1  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0010] = 0x0FEE_DDCC, Mem[0x1E00_0014] = 0x1234_5678

{  NOP  |  DSW D2, D3, A2, A3  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0018] = 0x0FEE_DDCC, Mem[0x1E00_001C] = 0x1234_5678

{  NOP  |  ADDI A0, A0, 0x0000001C  |  NOP  |  NOP  |  NOP  }
;Reg[A0] = 0x1E00_0020

{  NOP  |  ADDI A2, A2, 0x00000018  |  NOP  |  NOP  |  NOP  }
;Reg[A2] = 0x1E00_0040

{  NOP  |  SW D2, A0, 4  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0024] = 0x0FEE_DDCC

{  NOP  |  SW D2, A2, -24  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0028] = 0x0FEE_DDCC

{  NOP  |  SW D2, A0, A1  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_002C] = 0x0FEE_DDCC
 
{  NOP  |  SW D2, A2, A3  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0030] = 0x0FEE_DDCC



;-------------------------------------------------------------- Address Update
{  NOP  |  ADDI A0, A0, 0x00000010  |  NOP  |  NOP  |  NOP  }
;Reg[A0] = 0x1E00_0030

{  NOP  |  ADDI A2, A2, 0x00000010  |  NOP  |  NOP  |  NOP  }
;Reg[A2] = 0x1E00_0050




;**************************************************************¡iLinear:Offset¡j SH

{  NOP  |  SH D2, A0, 4  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0034] = 0x0000_DDCC

{  NOP  |  SH D2, A2, -22 |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0038] = 0xDDCC_0000

{  NOP  |  SH D2, A0, A1  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_003C] = 0x0000_DDCC

{  NOP  |  SH D2, A2, A3  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0040] = 0x0000_DDCC


;-------------------------------------------------------------- Address Update
{  NOP  |  ADDI A0, A0, 0x00000010  |  NOP  |  NOP  |  NOP  }
;Reg[A0] = 0x1E00_0040

{  NOP  |  ADDI A2, A2, 0x00000010  |  NOP  |  NOP  |  NOP  }
;Reg[A2] = 0x1E00_0060



;**************************************************************¡iLinear:Offset¡j SB
{  NOP  |  SB D2, A0, 5  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0044] = 0x0000_CC00

{  NOP  |  SB D2, A2, -21  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0048] = 0xCC00_0000

{  NOP  |  SB D2, A0, A1  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_004C] = 0x0000_00CC

{  NOP  |  SB D2, A2, A3  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0050] = 0x0000_00CC

;-------------------------------------------------------------- Address Update
{  NOP  |  ADDI A0, A0, 0x00000010  |  NOP  |  NOP  |  NOP  }
;Reg[A0] = 0x1E00_0050

{  NOP  |  ADDI A2, A2, 0x00000010  |  NOP  |  NOP  |  NOP  }
;Reg[A2] = 0x1E00_0070



;**************************************************************¡iLinear:Offset¡j (D)SNW
{  NOP  |  MOVI.L A1, 0x000D  |  NOP  |  NOP  |  NOP  }
;Reg[A1] = 0x0000_000D

{  NOP  |  MOVI.H A1, 0x0000  |  NOP  |  NOP  |  NOP  }
;Reg[A1] = 0x0000_000D

{  NOP  |  MOVI.L A3, 0xFFF7  |  NOP  |  NOP  |  NOP  }
;Reg[A3] = 0xFFFF_FFF7

{  NOP  |  MOVI.H A3, 0xFFFF  |  NOP  |  NOP  |  NOP  }
;Reg[A3] = 0xFFFF_FFF7

{  NOP  |  MOVI.L A4, 0x008C  |  NOP  |  NOP  |  NOP  }
;Reg[A4] = 0x0000_008C

{  NOP  |  MOVI.H A4, BASE_ADDR  |  NOP  |  NOP  |  NOP  }  ;modify by JH for 7056

{  NOP  |  SNW D2, A0, 4  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0054] = 0x0FEE_DDCC

{  NOP  |  SNW D2, A2, -22  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0058] = 0xDDCC_0000, Mem[0x1E00_005C] = 0x0000_0FEE

{  NOP  |  SNW D2, A0, A1  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_005C] = 0xEEDD_CCEE, Mem[0x1E00_0060] = 0x0000_000F
 
{  NOP  |  SNW D2, A2, A3  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0064] = 0xCC00_0000, Mem[0x1E00_0068] = 0x000F_EEDD

{  NOP  |  DSNW D2, D3, A0, 28  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_006C] = 0x0FEE_DDCC, Mem[0x1E00_0070] = 0x1234_5678

{  NOP  |  DSNW D2, D3, A4, -22  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0074] = 0xDDCC_0000, Mem[0x1E00_0078] = 0x5678_0FEE
;Mem[0x1E00_007C] = 0x0000_1234

{  NOP  |  ADDI A0, A0, 0x00000024  |  NOP  |  NOP  |  NOP  }
;Reg[A0] = 0x1E00_0074

{  NOP  |  ADDI A2, A2, 0x0000002C  |  NOP  |  NOP  |  NOP  }
;Reg[A2] = 0x1E00_009C

{  NOP  |  DSNW D2, D3, A0, A1  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0080] = 0xEEDD_CC00, Mem[0x1E00_0084] = 0x3456_780F
;Mem[0x1E00_0088] = 0x0000_0012

{  NOP  |  MOVI.L A2, 0x0095  |  NOP  |  NOP  |  NOP  }
;Reg[A2] = 0x1E00_0095

{  NOP  |  DSNW D2, D3, A2, A3  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_008C] = 0x0FEE_DDCC, Mem[0x1E00_0090] = 0x1234_5678


;-------------------------------------------------------------- Address Update
{  NOP  |  ADDI A0, A0, 0x00000020  |  NOP  |  NOP  |  NOP  }
;Reg[A0] = 0x1E00_0094

{  NOP  |  COPY A7, A0  |  NOP  |  NOP  |  NOP  }
;Reg[A7] = 0x1E00_0094


;**************************************************************¡iLinear:Offset¡j (D)LW
{  NOP  |  MOVI.L A0, 0x0000  |  NOP  |  NOP  |  NOP  }

{  NOP  |  MOVI.H A0, BASE_ADDR  |  NOP  |  NOP  |  NOP  } ; modify by JH for 7056


{  NOP  |  MOVI.L A1, 0x000C  |  NOP  |  NOP  |  NOP  }

{  NOP  |  MOVI.H A1, 0x0000  |  NOP  |  NOP  |  NOP  }


{  NOP  |  MOVI.L A2, 0x0020  |  NOP  |  NOP  |  NOP  }

{  NOP  |  MOVI.H A2, BASE_ADDR  |  NOP  |  NOP  |  NOP  } ; modify by JH for 7056


{  NOP  |  MOVI.L A3, 0xFFF0  |  NOP  |  NOP  |  NOP  }

{  NOP  |  MOVI.H A3, 0xFFFF  |  NOP  |  NOP  |  NOP  }



{  NOP  |  DLW D4, A0, 0  |  NOP  |  NOP  |  NOP  }
;Reg[D4] = 0x0FEE_DDCC, Reg[D5] = 0x1234_5678       //Mem[0x1E00_0000]

{  NOP  |  DLW D6, A2, -24  |  NOP  |  NOP  |  NOP  }
;Reg[D6] = 0x0FEE_DDCC, Reg[D7] = 0x1234_5678       //Mem[0x1E00_0008]

{  NOP  |  ADDI A0, A0, 0x00000004  |  NOP  |  NOP  |  NOP  }
;Reg[A0] = 0x1E00_0004

{  NOP  |  ADDI A2, A2, 0x00000008  |  NOP  |  NOP  |  NOP  }
;Reg[A2] = 0x1E00_0028

{  NOP  |  DLW D8, A0, A1  |  NOP  |  NOP  |  NOP  }
;Reg[D8] = 0x0FEE_DDCC, Reg[D9] = 0x1234_5678       //Mem[0x1E00_0010]

{  NOP  |  DLW D10, A2, A3  |  NOP  |  NOP  |  NOP  }
;Reg[D10] = 0x0FEE_DDCC, Reg[D11] = 0x1234_5678     //Mem[0x1E00_0018]

{  NOP  |  ADDI A0, A0, 0x0000001C  |  NOP  |  NOP  |  NOP  }
;Reg[A0] = 0x1E00_0020

{  NOP  |  ADDI A2, A2, 0x00000018  |  NOP  |  NOP  |  NOP  }
;Reg[A2] = 0x1E00_0040

{  NOP  |  LW D0, A0, 4  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x0FEE_DDCC       //Mem[0x1E00_0024]

{  NOP  |  LW D1, A2, -24  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x0FEE_DDCC       //Mem[0x1E00_0028]

{  NOP  |  LW D2, A0, A1  |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0x0FEE_DDCC       //Mem[0x1E00_002C]

{  NOP  |  LW D3, A2, A3  |  NOP  |  NOP  |  NOP  }
;Reg[D3] = 0x0FEE_DDCC       //Mem[0x1E00_0030]

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D0, A7, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0094] = 0x0FEE_DDCC, Reg[A7] = 0x1E00_0098

{  NOP  |  SW D1, A7, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0098] = 0x0FEE_DDCC, Reg[A7] = 0x1E00_009C

{  NOP  |  SW D2, A7, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_009C] = 0x0FEE_DDCC, Reg[A7] = 0x1E00_00A0

{  NOP  |  SW D3, A7, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00A0] = 0x0FEE_DDCC, Reg[A7] = 0x1E00_00A4

{  NOP  |  SW D4, A7, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00A4] = 0x0FEE_DDCC, Reg[A7] = 0x1E00_00A8

{  NOP  |  SW D5, A7, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00A8] = 0x1234_5678, Reg[A7] = 0x1E00_00AC

{  NOP  |  SW D6, A7, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00AC] = 0x0FEE_DDCC, Reg[A7] = 0x1E00_00B0

{  NOP  |  SW D7, A7, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00B0] = 0x1234_5678, Reg[A7] = 0x1E00_00B4

{  NOP  |  SW D8, A7, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00B4] = 0x0FEE_DDCC, Reg[A7] = 0x1E00_00B8

{  NOP  |  SW D9, A7, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00B8] = 0x1234_5678, Reg[A7] = 0x1E00_00BC

{  NOP  |  SW D10, A7, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00BC] = 0x0FEE_DDCC, Reg[A7] = 0x1E00_00C0

{  NOP  |  SW D11, A7, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00C0] = 0x1234_5678, Reg[A7] = 0x1E00_00C4


;-------------------------------------------------------------- Address Update
{  NOP  |  ADDI A0, A0, 0x00000010  |  NOP  |  NOP  |  NOP  }
;Reg[A0] = 0x1E00_0030

{  NOP  |  ADDI A2, A2, 0x00000010  |  NOP  |  NOP  |  NOP  }
;Reg[A2] = 0x1E00_0050




;**************************************************************¡iLinear:Offset¡j LH
{  NOP  |  LH D0, A0, 4  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0xFFFF_DDCC      //Mem[0x1E00_0034]

{  NOP  |  LH D1, A2, -22  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0xFFFF_DDCC      //Mem[0x1E00_0038]

{  NOP  |  LH D2, A0, A1  |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0xFFFF_DDCC      //Mem[0x1E00_003C]

{  NOP  |  LH D3, A2, A3  |  NOP  |  NOP  |  NOP  }
;Reg[D3] = 0xFFFF_DDCC      //Mem[0x1E00_0040]
;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D0, A7, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00C4] = 0xFFFF_DDCC, Reg[A7] = 0x1E00_00C8

{  NOP  |  SW D1, A7, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00C8] = 0xFFFF_DDCC, Reg[A7] = 0x1E00_00CC

{  NOP  |  SW D2, A7, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00CC] = 0xFFFF_DDCC, Reg[A7] = 0x1E00_00D0

{  NOP  |  SW D3, A7, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00D0] = 0xFFFF_DDCC, Reg[A7] = 0x1E00_00D4


;-------------------------------------------------------------- Address Update

{  NOP  |  ADDI A2, A2, 0x00000010  |  NOP  |  NOP  |  NOP  }
;Reg[A2] = 0x1E00_0060



;**************************************************************¡iLinear:Offset¡j LHU
{  NOP  |  LHU D0, A0, 4  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x0000_DDCC       //Mem[0x1E00_0034]

{  NOP  |  LHU D1, A2, -22  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x0000_CC00       //Mem[0x1E00_004A]

{  NOP  |  LHU D2, A0, A1  |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0x0000_DDCC       //Mem[0x1E00_003C]

{  NOP  |  LHU D3, A2, A3  |  NOP  |  NOP  |  NOP  }
;Reg[D3] = 0x0000_00CC       //Mem[0x1E00_0050]
;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D0, A7, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00D4] = 0x0000_DDCC, Reg[A7] = 0x1E00_00D8

{  NOP  |  SW D1, A7, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00D8] = 0x0000_CC00, Reg[A7] = 0x1E00_00DC

{  NOP  |  SW D2, A7, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00DC] = 0x0000_DDCC, Reg[A7] = 0x1E00_00E0

{  NOP  |  SW D3, A7, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00E0] = 0x0000_00CC, Reg[A7] = 0x1E00_00E4


;-------------------------------------------------------------- Address Update

{  NOP  |  ADDI A2, A2, 0x00000010  |  NOP  |  NOP  |  NOP  }
;Reg[A2] = 0x1E00_0070



;**************************************************************¡iLinear:Offset¡j LB
{  NOP  |  LB D0, A0, 5  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0xFFFF_FFDD      //Mem[0x1E00_0034]					**************************** Sam

{  NOP  |  LB D1, A2, -21  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0xFFFF_FFDD      //Mem[0x1E00_005B]

{  NOP  |  LB D2, A0, A1  |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0xFFFF_FFCC      //Mem[0x1E00_003C]

{  NOP  |  LB D3, A2, A3  |  NOP  |  NOP  |  NOP  }
;Reg[D3] = 0x0000_000F      //Mem[0x1E00_0060]
;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D0, A7, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00E4] = 0xFFFF_FFDD, Reg[A7] = 0x1E00_00E8

{  NOP  |  SW D1, A7, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00E8] = 0xFFFF_FFDD, Reg[A7] = 0x1E00_00EC

{  NOP  |  SW D2, A7, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00EC] = 0xFFFF_FFCC, Reg[A7] = 0x1E00_00F0

{  NOP  |  SW D3, A7, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00F0] = 0x0000_000F, Reg[A7] = 0x1E00_00F4

;-------------------------------------------------------------- Address Update
{  NOP  |  ADDI A0, A0, 0x00000030  |  NOP  |  NOP  |  NOP  }
;Reg[A0] = 0x1E00_0060													**************************** Sam

{  NOP  |  ADDI A2, A2, 0x00000010  |  NOP  |  NOP  |  NOP  }
;Reg[A2] = 0x1E00_0080



;**************************************************************¡iLinear:Offset¡j LBU
{  NOP  |  LBU D0, A0, 7  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x0000_00CC       //Mem[0x1E00_0067]

{  NOP  |  LBU D1, A2, -23  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x0000_00EE       //Mem[0x1E00_0068]

{  NOP  |  LBU D2, A0, A1  |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0x0000_00CC       //Mem[0x1E00_006C]

{  NOP  |  LBU D3, A2, A3  |  NOP  |  NOP  |  NOP  }
;Reg[D3] = 0x0000_0078       //Mem[0x1E00_0070]
;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D0, A7, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00F4] = 0x0000_00CC, Reg[A7] = 0x1E00_00F8

{  NOP  |  SW D1, A7, 4+  |  NOP  |  NOP  |  NOP }
;Mem[0x1E00_00F8] = 0x0000_00EE, Reg[A7] = 0x1E00_00FC

{  NOP  |  SW D2, A7, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00FC] = 0x0000_00CC, Reg[A7] = 0x1E00_0100

{  NOP  |  SW D3, A7, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0100] = 0x0000_0078, Reg[A7] = 0x1E00_0104
;-------------------------------------------------------------- Address Update
{  NOP  |  ADDI A0, A0, 0x00000010  |  NOP  |  NOP  |  NOP  }
;Reg[A0] = 0x1E00_0070

{  NOP  |  ADDI A2, A2, 0x00000010  |  NOP  |  NOP  |  NOP  }
;Reg[A2] = 0x1E00_0090



;**************************************************************¡iLinear:Offset¡j (D)LNW
{  NOP  |  MOVI.L A1, 0x000D  |  NOP  |  NOP  |  NOP  }
;Reg[A1] = 0x0000_000D

{  NOP  |  MOVI.H A1, 0x0000  |  NOP  |  NOP  |  NOP  }
;Reg[A1] = 0x0000_000D

{  NOP  |  MOVI.L A3, 0xFFF7  |  NOP  |  NOP  |  NOP  }
;Reg[A3] = 0xFFFF_FFF7

{  NOP  |  MOVI.H A3, 0xFFFF  |  NOP  |  NOP  |  NOP  }
;Reg[A3] = 0xFFFF_FFF7

{  NOP  |  MOVI.L A4, 0x00A4  |  NOP  |  NOP  |  NOP  }
;Reg[A4] = 0x0000_00A4

{  NOP  |  MOVI.H A4, BASE_ADDR  |  NOP  |  NOP  |  NOP  }
;Reg[A4] = 0x0800_00A4, modify by JH for 7056

{  NOP  |  LNW D0, A0, 4  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0xDDCC_0000     //Mem[0x1E00_0074]

{  NOP  |  LNW D1, A2, -22  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x1234_5678     //Mem[0x1E00_0078]

{  NOP  |  LNW D2, A0, A1  |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0x0000_0012     //Mem[0x1E00_007C]
 
{  NOP  |  LNW D3, A2, A3  |  NOP  |  NOP  |  NOP  }
;Reg[D3] = 0x0000_1234     //Mem[0x1E00_0087]				**************************** Sam

{  NOP  |  DLNW D4, A0, 20  |  NOP  |  NOP  |  NOP  }
;Reg[D4] = 0x3456_780F, Reg[D5] = 0x0000_0012       //Mem[0x1E00_0084]

{  NOP  |  DLNW D6, A4, -23  |  NOP  |  NOP  |  NOP  }
;Reg[D6] = 0x780F_EEDD, Reg[D7] = 0xCC12_3456       //Mem[0x1E00_008D]	*************************** Sam

{  NOP  |  ADDI A0, A0, 0x00000018  |  NOP  |  NOP  |  NOP  }
;Reg[A0] = 0x1E00_0088                             

{  NOP  |  ADDI A2, A2, 0x00000018  |  NOP  |  NOP  |  NOP  }
;Reg[A2] = 0x1E00_00A8                							 *************************** Sam

{  NOP  |  DLNW D8, A0, A1  |  NOP  |  NOP  |  NOP  }
;Reg[D8] = 0xCC0F_EEDD, Reg[D9] = 0xCC0F_EEDD       //Mem[0x1E00_0094]

{  NOP  |  DLNW D10, A2, A3  |  NOP  |  NOP  |  NOP  }
;Reg[D10] = 0xEEDD_CC0F, Reg[D11] = 0xEEDD_CC0F     //Mem[0x1E00_009C]
;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D0, A7, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0104] = 0xDDCC_0000, Reg[A7] = 0x1E00_0108

{  NOP  |  SW D1, A7, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0108] = 0x1234_5678, Reg[A7] = 0x1E00_010C

{  NOP  |  SW D2, A7, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_010C] = 0x0000_0012, Reg[A7] = 0x1E00_0110

{  NOP  |  SW D3, A7, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0110] = 0x0000_1234, Reg[A7] = 0x1E00_0114

{  NOP  |  SW D4, A7, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0114] = 0x3456_780F, Reg[A7] = 0x1E00_0118

{  NOP  |  SW D5, A7, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0118] = 0x0000_0012, Reg[A7] = 0x1E00_011C

{  NOP  |  SW D6, A7, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_011C] = 0x780F_EEDD, Reg[A7] = 0x1E00_0120

{  NOP  |  SW D7, A7, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0120] = 0xCC12_3456, Reg[A7] = 0x1E00_0124

{  NOP  |  SW D8, A7, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0124] = 0xCC0F_EEDD, Reg[A7] = 0x1E00_0128

{  NOP  |  SW D9, A7, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0128] = 0xCC0F_EEDD, Reg[A7] = 0x1E00_012C

{  NOP  |  SW D10, A7, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_012C] = 0xEEDD_CC0F, Reg[A7] = 0x1E00_0130

{  NOP  |  SW D11, A7, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0130] = 0xEEDD_CC0F, Reg[A7] = 0x1E00_0134




;**************************************************************¡iLinear:Post-Increment¡j (D)SW
{  NOP  |  COPY A0, A7  |  NOP  |  NOP  |  NOP  }
;Reg[A0] = 0x1E00_0134

{  NOP  |  MOVI.L A1, 0x0008  |  NOP  |  NOP  |  NOP  }
;Reg[A1] = 0x0000_0008

{  NOP  |  MOVI.H A1, 0x0000  |  NOP  |  NOP  |  NOP  }
;Reg[A1] = 0x0000_0008

{  NOP  |  MOVI.L D0, 0x0000  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0xDDCC_0000

{  NOP  |  MOVI.H D0, 0x0000  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x0000_0000 

{  NOP  |  MOVI.L D2, 0xDDCC  |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0x0000_DDCC

{  NOP  |  MOVI.H D2, 0x0FEE  |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0x0FEE_DDCC 

{  NOP  |  MOVI.L D3, 0x5678  |  NOP  |  NOP  |  NOP  }
;Reg[D3] = 0x5678_5678

{  NOP  |  MOVI.H D3, 0x1234  |  NOP  |  NOP  |  NOP  }
;Reg[D3] = 0x1234_5678 




{  NOP  |  SW D2, A0, 8+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0134] = 0x0FEE_DDCC, Reg[A0] = 0x1E00_013C

{  NOP  |  SW A0, A0, (-4)+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_013C] = 0x1E00_013C, Reg[A0] = 0x1E00_0138				*************************** Sam

{  NOP  |  SW D2, A0, A1+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0138] = 0x0FEE_DDCC, Reg[A0] = 0x1E00_0140

{  NOP  |  DSW D2, D3, A0, 16+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0140] = 0x0FEE_DDCC, Mem[0x1E00_0144] = 0x1234_5678
;Reg[A0] = 0x1E00_0150

{  NOP  |  DSW D2, D3, A0, (-8)+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0150] = 0x0FEE_DDCC, Mem[0x1E00_0154] = 0x1234_5678
;Reg[A0] = 0x1E00_0148

{  NOP  |  MOVI.L A1, 0x0010  |  NOP  |  NOP  |  NOP  }
;Reg[A1] = 0x0000_0010

{  NOP  |  DSW D2, D3, A0, A1+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0148] = 0x0FEE_DDCC, Mem[0x1E00_014C] = 0x1234_5678
;Reg[A0] = 0x1E00_0158

{  NOP  |  MOVI.L A1, 0x0003  |  NOP  |  NOP  |  NOP  }
;Reg[A1] = 0x0000_0003


;**************************************************************¡iLinear:Post-Increment¡j SB
{  NOP  |  SW D0, A0, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0158]  = 0x0000_0000, Reg[A0] = 0x1E00_015C

{  NOP  |  SW D0, A0, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_015C]  = 0x0000_0000, Reg[A0] = 0x1E00_0160

{  NOP  |  SW D0, A0, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0160]  = 0x0000_0000, Reg[A0] = 0x1E00_0164

{  NOP  |  SW D0, A0, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0164]  = 0x0000_0000, Reg[A0] = 0x1E00_0168

{  NOP  |  SW D0, A0, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0168]  = 0x0000_0000, Reg[A0] = 0x1E00_016C

{  NOP  |  SW D0, A0, (-20)+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_016C]  = 0x0000_0000, Reg[A0] = 0x1E00_0158					*********************** Sam



{  NOP  |  SB D2, A0, 2+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0158] = 0x0000_00CC, Reg[A0] = 0x1E00_015A

{  NOP  |  SB A0, A0, (-1)+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0158] = 0x005A_00CC, Reg[A0] = 0x1E00_0159

{  NOP  |  SB D2, A0, A1+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0158] = 0x005A_CCCC, Reg[A0] = 0x1E00_015C


;**************************************************************¡iLinear:Post-Increment¡j SH
{  NOP  |  MOVI.L A1, 0x0004  |  NOP  |  NOP  |  NOP  }
;Reg[A1] = 0x0000_0004


{  NOP  |  SH D2, A0, 6+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_015C] = 0x0000_DDCC, Reg[A0] = 0x1E00_0162

{  NOP  |  SH A0, A0, (-2)+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0160] = 0x0162_0000, Reg[A0] = 0x1E00_0160

{  NOP  |  SH D2, A0, A1+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0160] = 0x0162_DDCC, Reg[A0] = 0x1E00_0164


;**************************************************************¡iLinear:Post-Increment¡j (D)LW
{  NOP  |  MOVI.L A1, 0x0008  |  NOP  |  NOP  |  NOP  }
;Reg[A1] = 0x0000_0008															*********************** Sam


{  NOP  |  COPY A7, A0  |  NOP  |  NOP  |  NOP  }
;Reg[A7] = 0x1E00_0164

{  NOP  |  MOVI.L A0, 0x0134  |  NOP  |  NOP  |  NOP  }
;Reg[A0] = 0x1E00_0134

{  NOP  |  MOVI.H A0, BASE_ADDR  |  NOP  |  NOP  |  NOP  }
;Reg[A0] = 0x0800_0134, modify by JH for 7056


{  NOP  |  LW D0, A0, 8+  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x0FEE_DDCC , Reg[A0] = 0x1E00_013C       //Mem[0x1E00_0134]

{  NOP  |  LW D1, A0, (-4)+  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x1E00_013C , Reg[A0] = 0x1E00_0138       //Mem[0x1E00_013C]			*********************** Sam

{  NOP  |  LW D2, A0, A1+  |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0x0FEE_DDCC , Reg[A0] = 0x1E00_0140       //Mem[0x1E00_0138]			

{  NOP  |  DLW D4, A0, 16+  |  NOP  |  NOP  |  NOP  }
;Reg[D4] = 0x0FEE_DDCC, Reg[D5] = 0x1234_5678        //Mem[0x1E00_0140]			*********************** Sam
;Reg[A0] = 0x1E00_0150

{  NOP  |  DLW D6, A0, (-8)+  |  NOP  |  NOP  |  NOP  }
;Reg[D6] = 0x0FEE_DDCC, Reg[D7] = 0x1234_5678        //Mem[0x1E00_0150]			*********************** Sam
;Reg[A0] = 0x1E00_0148

{  NOP  |  MOVI.L A1, 0x0010  |  NOP  |  NOP  |  NOP  }
;Reg[A1] = 0x0000_0010

{  NOP  |  DLW D8, A0, A1+  |  NOP  |  NOP  |  NOP  }
;Reg[D8] = 0x0FEE_DDCC, Reg[D9] = 0x1234_5678        //Mem[0x1E00_0148]			*********************** Sam
;Reg[A0] = 0x1E00_0158

{  NOP  |  MOVI.L A1, 0x0008  |  NOP  |  NOP  |  NOP  }
;Reg[A1] = 0x0000_0008
;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D0, A7, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0164] = 0x0FEE_DDCC, Reg[A7] = 0x1E00_0168

{  NOP  |  SW D1, A7, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0168] = 0x1E00_013C, Reg[A7] = 0x1E00_016C

{  NOP  |  SW D2, A7, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_016C] = 0x0FEE_DDCC, Reg[A7] = 0x1E00_0170

{  NOP  |  SW D4, A7, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0170] = 0x0FEE_DDCC, Reg[A7] = 0x1E00_0174

{  NOP  |  SW D5, A7, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0174] = 0x1234_5678, Reg[A7] = 0x1E00_0178

{  NOP  |  SW D6, A7, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0178] = 0x0FEE_DDCC, Reg[A7] = 0x1E00_017C

{  NOP  |  SW D7, A7, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_017C] = 0x1234_5678, Reg[A7] = 0x1E00_0180

{  NOP  |  SW D8, A7, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0180] = 0x0FEE_DDCC, Reg[A7] = 0x1E00_0184

{  NOP  |  SW D9, A7, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0184] = 0x1234_5678, Reg[A7] = 0x1E00_0188



;**************************************************************¡iLinear:Post-Increment¡j LH

{  NOP  |  LH D0, A0, 8+  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0xFFFF_CCCC , Reg[A0] = 0x1E00_0160      //Mem[0x1E00_0158]			*********************** Sam

{  NOP  |  LH D1, A0, (-4)+  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0xFFFF_DDCC , Reg[A0] = 0x1E00_015C      //Mem[0x1E00_0160]			*********************** Sam

{  NOP  |  LH D2, A0, A1+  |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0xFFFF_DDCC , Reg[A0] = 0x1E00_0164      //Mem[0x1E00_015C]			*********************** Sam
;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D0, A7, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0188] = 0xFFFF_CCCC, Reg[A7] = 0x1E00_018C

{  NOP  |  SW D1, A7, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_018C] = 0xFFFF_DDCC, Reg[A7] = 0x1E00_0190

{  NOP  |  SW D2, A7, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0190] = 0xFFFF_DDCC, Reg[A7] = 0x1E00_0194




;**************************************************************¡iLinear:Post-Increment¡j LHU

{  NOP  |  LHU D0, A0, 8+  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x0000_DDCC , Reg[A0] = 0x1E00_016C     //Mem[0x1E00_0164]

{  NOP  |  LHU D1, A0, (-4)+  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x0000_DDCC , Reg[A0] = 0x1E00_0168     //Mem[0x1E00_016C]

{  NOP  |  LHU D2, A0, A1+  |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0x0000_013C , Reg[A0] = 0x1E00_0170     //Mem[0x1E00_0168]
;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D0, A7, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0194] = 0x0000_DDCC, Reg[A7] = 0x1E00_0198

{  NOP  |  SW D1, A7, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0198] = 0x0000_DDCC, Reg[A7] = 0x1E00_019C

{  NOP  |  SW D2, A7, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_019C] = 0x0000_013C, Reg[A7] = 0x1E00_01A0


;**************************************************************¡iLinear:Post-Increment¡j LB

{  NOP  |  LB D0, A0, 8+  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0xFFFF_FFCC , Reg[A0] = 0x1E00_0178     //Mem[0x1E00_0170]

{  NOP  |  LB D1, A0, (-4)+  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0xFFFF_FFCC , Reg[A0] = 0x1E00_0174     //Mem[0x1E00_0178]

{  NOP  |  LB D2, A0, A1+  |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0x0000_0078 , Reg[A0] = 0x1E00_017C     //Mem[0x1E00_0174]
;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D0, A7, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01A0] = 0xFFFF_FFCC, Reg[A7] = 0x1E00_01A4

{  NOP  |  SW D1, A7, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01A4] = 0xFFFF_FFCC, Reg[A7] = 0x1E00_01A8

{  NOP  |  SW D2, A7, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01A8] = 0x0000_0078, Reg[A7] = 0x1E00_01AC



;**************************************************************¡iLinear:Post-Increment¡j LBU

{  NOP  |  LBU D0, A0, 8+  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x0000_0078 , Reg[A0] = 0x1E00_0178     //Mem[0x1E00_017C]

{  NOP  |  LBU D1, A0, (-4)+  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x0000_0078 , Reg[A0] = 0x1E00_0174     //Mem[0x1E00_0184]

{  NOP  |  LBU D2, A0, A1+  |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0x0000_00CC , Reg[A0] = 0x1E00_017C     //Mem[0x1E00_0180]
;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D0, A7, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01AC] = 0x0000_0078, Reg[A7] = 0x1E00_01B0

{  NOP  |  SW D1, A7, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01B0] = 0x0000_0078, Reg[A7] = 0x1E00_01B4

{  NOP  |  SW D2, A7, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01B4] = 0x0000_00CC, Reg[A7] = 0x1E00_01B8



;/////////////////////////////////////Special Addressing Mode//////////////////////////////////////
{  NOP  |  MOVI D0, 0x00000000  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x0000_0000

{  NOP  |  MOVI D1, 0x11111111  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x1111_1111

{  NOP  |  MOVI D2, 0x22222222  |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0x2222_2222

{  NOP  |  MOVI D3, 0x33333333  |  NOP  |  NOP  |  NOP  }
;Reg[D3] = 0x3333_3333

{  NOP  |  MOVI D4, 0x44444444  |  NOP  |  NOP  |  NOP  }
;Reg[D4] = 0x4444_4444

{  NOP  |  MOVI D5, 0x55555555  |  NOP  |  NOP  |  NOP  }
;Reg[D5] = 0x5555_5555

{  NOP  |  MOVI D6, 0x66666666  |  NOP  |  NOP  |  NOP  }
;Reg[D6] = 0x6666_6666

{  NOP  |  MOVI D7, 0x77777777  |  NOP  |  NOP  |  NOP  }
;Reg[D7] = 0x7777_7777

{  NOP  |  MOVI D8, 0x88888888  |  NOP  |  NOP  |  NOP  }
;Reg[D8] = 0x8888_8888

{  NOP  |  MOVI D9, 0x99999999  |  NOP  |  NOP  |  NOP  }
;Reg[D9] = 0x9999_9999

{  NOP  |  MOVI D10, 0xAAAAAAAA  |  NOP  |  NOP  |  NOP  }
;Reg[D10] = 0xAAAA_AAAA

{  NOP  |  MOVI D11, 0xBBBBBBBB  |  NOP  |  NOP  |  NOP  }
;Reg[D11] = 0xBBBB_BBBB

{  NOP  |  MOVI D12, 0xCCCCCCCC  |  NOP  |  NOP  |  NOP  }
;Reg[D12] = 0xCCCC_CCCC

{  NOP  |  MOVI D13, 0xDDDDDDDD  |  NOP  |  NOP  |  NOP  }
;Reg[D13] = 0xDDDD_DDDD

{  NOP  |  MOVI D14, 0xEEEEEEEE  |  NOP  |  NOP  |  NOP  }
;Reg[D14] = 0xEEEE_EEEE

{  NOP  |  MOVI D15, 0xFFFFFFFF  |  NOP  |  NOP  |  NOP  }
;Reg[D15] = 0xFFFF_FFFF

{  NOP  |  COPY A0, A7  |  NOP  |  NOP  |  NOP  }
;Reg[A0] = 0x1E00_01B8

{  NOP  |  MOVI.L A2, 0x0000    |  NOP  |  NOP  |  NOP  }
{  NOP  |  MOVI.H A2, BASE_ADDR |  NOP  |  NOP  |  NOP  } ; modify by JH for 7056

;************************************************************** Bit Reverse Addressing Mode
{  NOP  |  MOVI AMCR, 0x0010  |  NOP  |  NOP  |  NOP  }
;Set A2 as Bit Reverse Addressing Mode

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
;delay slot

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
;delay slot

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
;delay slot

{  NOP  |  COPY A1, A2  |  NOP  |  NOP  |  NOP  }
;Reg[A1] = 0x1E00_0000

{  NOP  |  LW D0, A2, 16+  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x0000_0000, Reg[A2] = 0x1E00_0010

{  NOP  |  SUB A1, A2, A1  |  NOP  |  NOP  |  NOP  }
;Reg[A1] = 0x0000_0010

{  NOP  |  SW D0, A0, A1+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01B8] = 0x0000_0000, Reg[A0] = 0x1E00_01C8

{  NOP  |  COPY A1, A2  |  NOP  |  NOP  |  NOP  }
;Reg[A1] = 0x1E00_0010

{  NOP  |  LW D0, A2, 16+  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x0FEE_DDCC, Reg[A2] = 0x1E00_0008

{  NOP  |  SUB A1, A2, A1  |  NOP  |  NOP  |  NOP  }
;Reg[A1] = 0xFFFF_FFF8

{  NOP  |  SW D1, A0, A1+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01C8] = 0x1111_1111, Reg[A0] = 0x1E00_01C0

{  NOP  |  COPY A1, A2  |  NOP  |  NOP  |  NOP  }
;Reg[A1] = 0x1E00_0008

{  NOP  |  LW D0, A2, 16+  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x0FEE_DDCC, Reg[A2] = 0x1E00_0018

{  NOP  |  SUB A1, A2, A1  |  NOP  |  NOP  |  NOP  }
;Reg[A1] = 0x0000_0010

{  NOP  |  SW D2, A0, A1+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01C0] = 0x2222_2222, Reg[A0] = 0x1E00_01D0

{  NOP  |  COPY A1, A2  |  NOP  |  NOP  |  NOP  }
;Reg[A1] = 0x1E00_0018

{  NOP  |  LW D0, A2, 16+  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x1234_5678, Reg[A2] = 0x1E00_0004

{  NOP  |  SUB A1, A2, A1  |  NOP  |  NOP  |  NOP  }
;Reg[A1] = 0xFFFF_FFEC

{  NOP  |  SW D3, A0, A1+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01D0] = 0x3333_3333, Reg[A0] = 0x1E00_01BC

{  NOP  |  COPY A1, A2  |  NOP  |  NOP  |  NOP  }
;Reg[A1] = 0x1E00_0004

{  NOP  |  LW D0, A2, 16+  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x0FEE_DDCC, Reg[A2] = 0x1E00_0014

{  NOP  |  SUB A1, A2, A1  |  NOP  |  NOP  |  NOP  }
;Reg[A1] = 0x0000_0010

{  NOP  |  SW D4, A0, A1+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01BC] = 0x4444_4444, Reg[A0] = 0x1E00_01CC

{  NOP  |  COPY A1, A2  |  NOP  |  NOP  |  NOP  }
;Reg[A1] = 0x1E00_0014

{  NOP  |  LW D0, A2, 16+  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x0FEE_DDCC, Reg[A2] = 0x1E00_000C

{  NOP  |  SUB A1, A2, A1  |  NOP  |  NOP  |  NOP  }
;Reg[A1] = 0xFFFF_FFF8

{  NOP  |  SW D5, A0, A1+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01CC] = 0x5555_5555, Reg[A0] = 0x1E00_01C4

{  NOP  |  COPY A1, A2  |  NOP  |  NOP  |  NOP  }
;Reg[A1] = 0x1E00_000C

{  NOP  |  LW D0, A2, 16+  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x1234_5678, Reg[A2] = 0x1E00_001C					***************************** Sam

{  NOP  |  SUB A1, A2, A1  |  NOP  |  NOP  |  NOP  }
;Reg[A1] = 0x0000_0010

{  NOP  |  SW D6, A0, A1+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01C4] = 0x6666_6666, Reg[A0] = 0x1E00_01D4

{  NOP  |  SW D7, A0, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01D4] = 0x7777_7777, Reg[A0] = 0x1E00_01D8


;************************************************************** Modulo Addressing Mode
{  NOP  |  MOVI AMCR, 0xAAAA  |  NOP  |  NOP  |  NOP  }
;Set A0, A1, A4, A5 and A2, A3, A6, A7 as Modulo Addressing Mode

{  NOP  |  MOVI.L A1, 0x01D8    |  NOP  |  NOP  |  NOP  }
{  NOP  |  MOVI.H A1, BASE_ADDR |  NOP  |  NOP  |  NOP  }  ; modify by JH for 7056

{  NOP  |  MOVI.L A4, 0x0218    |  NOP  |  NOP  |  NOP  }
{  NOP  |  MOVI.H A4, BASE_ADDR |  NOP  |  NOP  |  NOP  }  ; modify by JH for 7056

{  NOP  |  MOVI A5, 0x00000004  |  NOP  |  NOP  |  NOP  }
;Reg[A5] = 0x0000_0004

{  NOP  |  SW D0, A0, A5+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01D8] = 0x1234_5678, Reg[A0] = 0x1E00_01DC			***************************** Sam

{  NOP  |  SW D1, A0, A5+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01DC] = 0x1111_1111, Reg[A0] = 0x1E00_01E0

{  NOP  |  SW D2, A0, A5+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01E0] = 0x2222_2222, Reg[A0] = 0x1E00_01E4

{  NOP  |  SW D3, A0, A5+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01E4] = 0x3333_3333, Reg[A0] = 0x1E00_01E8

{  NOP  |  SW D4, A0, A5+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01E8] = 0x4444_4444, Reg[A0] = 0x1E00_01EC

{  NOP  |  SW D5, A0, A5+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01EC] = 0x5555_5555, Reg[A0] = 0x1E00_01F0

{  NOP  |  SW D6, A0, A5+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01F0] = 0x6666_6666, Reg[A0] = 0x1E00_01F4

{  NOP  |  SW D7, A0, A5+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01F4] = 0x7777_7777, Reg[A0] = 0x1E00_01F8

{  NOP  |  SW D8, A0, A5+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01F8] = 0x8888_8888, Reg[A0] = 0x1E00_01FC

{  NOP  |  SW D9, A0, A5+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01FC] = 0x9999_9999, Reg[A0] = 0x1E00_0200

{  NOP  |  SW D10, A0, A5+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0200] = 0xAAAA_AAAA, Reg[A0] = 0x1E00_0204

{  NOP  |  SW D11, A0, A5+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0204] = 0xBBBB_BBBB, Reg[A0] = 0x1E00_0208

{  NOP  |  SW D12, A0, A5+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0208] = 0xCCCC_CCCC, Reg[A0] = 0x1E00_020C

{  NOP  |  SW D13, A0, A5+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_020C] = 0xDDDD_DDDD, Reg[A0] = 0x1E00_0210

{  NOP  |  SW D14, A0, A5+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0210] = 0xEEEE_EEEE, Reg[A0] = 0x1E00_0214

{  NOP  |  SW D15, A0, A5+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0214] = 0xFFFF_FFFF, Reg[A0] = 0x1E00_01D8

{  NOP  |  SW D15, A0, A5+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01D8] = 0xFFFF_FFFF, Reg[A0] = 0x1E00_01DC

{  NOP  |  SW D14, A0, A5+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01DC] = 0xEEEE_EEEE, Reg[A0] = 0x1E00_01E0

{  NOP  |  SW D13, A0, A5+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01E0] = 0xDDDD_DDDD, Reg[A0] = 0x1E00_01E4




{  NOP  |  MOVI.L A2, 0x0258    |  NOP  |  NOP  |  NOP  }
{  NOP  |  MOVI.H A2, BASE_ADDR |  NOP  |  NOP  |  NOP  }  ; modify by JH for 7056						

{  NOP  |  MOVI.L A3, 0x0218    |  NOP  |  NOP  |  NOP  }
{  NOP  |  MOVI.H A3, BASE_ADDR |  NOP  |  NOP  |  NOP  }  ; modify by JH for 7056												***************************** Sam

{  NOP  |  MOVI.L A6, 0x0258    |  NOP  |  NOP  |  NOP  } 
{  NOP  |  MOVI.H A6, BASE_ADDR |  NOP  |  NOP  |  NOP  }  ; modify by JH for 7056												***************************** Sam

{  NOP  |  MOVI A7, 0xFFFFFFFC  |  NOP  |  NOP  |  NOP  }
;Reg[A7] = 0xFFFF_FFFC						

{  NOP  |  SW D0, A2, A7+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0258] = 0x1234_5678, Reg[A0] = 0x1E00_0254				***************************** Sam

{  NOP  |  SW D1, A2, A7+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0254] = 0x1111_1111, Reg[A0] = 0x1E00_0250

{  NOP  |  SW D2, A2, A7+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0250] = 0x2222_2222, Reg[A0] = 0x1E00_024C

{  NOP  |  SW D3, A2, A7+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_024C] = 0x3333_3333, Reg[A0] = 0x1E00_0248

{  NOP  |  SW D4, A2, A7+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0248] = 0x4444_4444, Reg[A0] = 0x1E00_0244

{  NOP  |  SW D5, A2, A7+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0244] = 0x5555_5555, Reg[A0] = 0x1E00_0240

{  NOP  |  SW D6, A2, A7+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0240] = 0x6666_6666, Reg[A0] = 0x1E00_023C

{  NOP  |  SW D7, A2, A7+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_023C] = 0x7777_7777, Reg[A0] = 0x1E00_0238

{  NOP  |  SW D8, A2, A7+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0238] = 0x8888_8888, Reg[A0] = 0x1E00_0234

{  NOP  |  SW D9, A2, A7+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0234] = 0x9999_9999, Reg[A0] = 0x1E00_0230

{  NOP  |  SW D10, A2, A7+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0230] = 0xAAAA_AAAA, Reg[A0] = 0x1E00_022C

{  NOP  |  SW D11, A2, A7+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_022C] = 0xBBBB_BBBB, Reg[A0] = 0x1E00_0228

{  NOP  |  SW D12, A2, A7+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0228] = 0xCCCC_CCCC, Reg[A0] = 0x1E00_0224

{  NOP  |  SW D13, A2, A7+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0224] = 0xDDDD_DDDD, Reg[A0] = 0x1E00_0220

{  NOP  |  SW D14, A2, A7+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0220] = 0xEEEE_EEEE, Reg[A0] = 0x1E00_021C

{  NOP  |  SW D15, A2, A7+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_021C] = 0xFFFF_FFFF, Reg[A0] = 0x1E00_0258

{  NOP  |  SW D15, A2, A7+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0218] = 0xFFFF_FFFF, Reg[A0] = 0x1E00_0254

{  NOP  |  SW D14, A2, A7+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0254] = 0xEEEE_EEEE, Reg[A0] = 0x1E00_0250

{  NOP  |  SW D13, A2, A7+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0250] = 0xDDDD_DDDD, Reg[A0] = 0x1E00_024C

{  NOP  |  MOVI.L A0, 0x025C    |  NOP  |  NOP  |  NOP  }
{  NOP  |  MOVI.H A0, BASE_ADDR |  NOP  |  NOP  |  NOP  }  ; modify by JH for 7056


;/////////////////////////////////////Encoding//////////////////////////////////////
{  NOP  |  MOVI AMCR, 0x0000  |  NOP  |  NOP  |  NOP  }
;Set A2 as Bit Reverse Addressing Mode

{  NOP  |  MOVI D15, 0x00000001  |  NOP  |  NOP  |  NOP  }
;Reg[D15] = 0x0000_0001

{  NOP  |  SLTI D0, P1, P2, D15, 0x0000FFFF  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x0000_0001, Reg[P1] = 1, Reg[P2] = 0

;**************************************************************¡iLinear:Offset¡j (D)SW

{  NOP  |  MOVI D0, 0x00000000  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x0000_0000

{  NOP  | (P1) SW D0, A0, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_025C] = 0x0000_0000, Reg[A0] = 0x1E00_0260

{  NOP  | (P2) SW D1, A0, 4+  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  NOP  |  SW D2, A0, 16+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0260] = 0x2222_2222, Reg[A0] = 0x1E00_0270

{  NOP  |  SW A0, A0, -4  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_026C] = 0x1E00_0270											************************ Sam

{  NOP  |  SW D2, A0, 256+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0270] = 0x2222_2222, Reg[A0] = 0x1E00_0370

{  NOP  |  SW A0, A0, -268  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0264] = 0x1E00_0370											************************ Sam

{  NOP  |  SW D2, A0, 4096+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0370] = 0x2222_2222, Reg[A0] = 0x1E00_1370

{  NOP  |  SW A0, A0, -4360  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0268] = 0x1E00_1370											************************ Sam

{  NOP  |  MOVI.L A0, 0x0270    |  NOP  |  NOP  |  NOP  }
{  NOP  |  MOVI.H A0, BASE_ADDR |  NOP  |  NOP  |  NOP  } ; modify by JH for 7056

{  NOP  | (P1) DSW D2, D3, A0, 8+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0270] = 0x2222_2222, Mem[0x1E00_0274] = 0x3333_3333
;Reg[A0] = 0x1E00_0278

{  NOP  | (P2) DSW D2, D3, A0, 8+  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  NOP  |  DSW D2, D3, A0, 16+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0278] = 0x2222_2222, Mem[0x1E00_027C] = 0x3333_3333
;Reg[A0] = 0x1E00_0288

{  NOP  |  SW A0, A0, -16  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0278] = 0x1E00_0288											************************ Sam

{  NOP  |  DSW D2, D3, A0, 256+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0288] = 0x2222_2222, Mem[0x1E00_028C] = 0x3333_3333
;Reg[A0] = 0x1E00_0388

																		

{  NOP  |  DSW D2, D3, A0, 4096+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0388] = 0x2222_2222, Mem[0x1E00_038C] = 0x3333_3333
;Reg[A0] = 0x1E00_1388

{  NOP  |  SW A0, A0, -4360  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0280] = 0x1E00_1388											************************ Sam

{  NOP  |  MOVI.L A0, 0x0284    |  NOP  |  NOP  |  NOP  }
{  NOP  |  MOVI.H A0, BASE_ADDR |  NOP  |  NOP  |  NOP  }  ; modify by JH for 7056


;**************************************************************¡iLinear:Offset¡j SH
{  NOP  |  MOVI A1, 0x00000002  |  NOP  |  NOP  |  NOP  }
;Reg[A1] = 0x0000_0002

{  NOP  | (P1) SH D1, A0, 2+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0284] = 0x0000_1111, Reg[A0] = 0x1E00_0286

{  NOP  | (P2) SH D2, A0, 2+  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  NOP  | (P1) SH D3, A0, A1+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0284] = 0x3333_1111, Reg[A0] = 0x1E00_0288

{  NOP  | (P2) SH D4, A0, 2+  |  NOP  |  NOP  |  NOP  }
; Non-Execution


;**************************************************************¡iLinear:Offset¡j SB
{  NOP  |  MOVI A1, 0x00000001  |  NOP  |  NOP  |  NOP  }
;Reg[A1] = 0x0000_0002

{  NOP  | (P1) SB D1, A0, 1+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0288] = 0x0000_0011, Reg[A0] = 0x1E00_0289

{  NOP  | (P2) SB D2, A0, 1+  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  NOP  | (P1) SB D3, A0, 1+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0289] = 0x0000_3311, Reg[A0] = 0x1E00_028A

{  NOP  | (P2) SB D4, A0, 1+  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  NOP  | (P1) SB D5, A0, A1+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_028A] = 0x0055_3311, Reg[A0] = 0x1E00_028B

{  NOP  | (P2) SB D6, A0, A1+  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  NOP  | (P1) SB D7, A0, A1+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_028B] = 0x7755_3311, Reg[A0] = 0x1E00_028C

{  NOP  | (P2) SB D8, A0, A1+  |  NOP  |  NOP  |  NOP  }
; Non-Execution

;**************************************************************¡iLinear:Offset¡j (D)SNW

{  NOP  | (P1) SNW D0, A0, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_028C] = 0x0000_0000, Reg[A0] = 0x1E00_0290

{  NOP  | (P2) SNW D1, A0, 4+  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  NOP  | (P1) DSNW D2, D3, A0, 8+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0290] = 0x2222_2222, Mem[0x1E00_0294] = 0x3333_3333
;Reg[A0] = 0x1E00_0298

{  NOP  | (P2) DSNW D2, D3, A0, 8+  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  NOP  |  COPY A7, A0  |  NOP  |  NOP  |  NOP  }
;Reg[A7] = 0x1E00_0298

;**************************************************************¡iLinear:Offset¡j (D)LW
{  NOP  |  MOVI.L A0, 0x025C    |  NOP  |  NOP  |  NOP  }
{  NOP  |  MOVI.H A0, BASE_ADDR |  NOP  |  NOP  |  NOP  }  ; modify by JH for 7056

{  NOP  | (P1) LW D0, A0, 4+  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x0000_0000, Reg[A0] = 0x1E00_0260

{  NOP  | (P2) LW D1, A0, 4+  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  NOP  |  LW D2, A0, 16+  |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0x22222222, Reg[A0] = 0x1E00_0270

{  NOP  |  LW D3, A0, 256+  |  NOP  |  NOP  |  NOP  }
;Reg[D3] = 0x2222_2222, Reg[A0] = 0x1E00_0370

{  NOP  |  LW D4, A0, 4096+  |  NOP  |  NOP  |  NOP  }
;Reg[D4] = 0x2222_2222, Reg[A0] = 0x1E00_1370

{  NOP  |  MOVI.L A0, 0x0270    |  NOP  |  NOP  |  NOP  }
{  NOP  |  MOVI.H A0, BASE_ADDR |  NOP  |  NOP  |  NOP  }  ; modify by JH for 7056

{  NOP  | (P1) DLW D6, A0, 8+  |  NOP  |  NOP  |  NOP  }
;Reg[D6] = 0x2222_2222, Reg[D7] = 0x3333_3333
;Reg[A0] = 0x1E00_0278

{  NOP  | (P2) DLW D8, A0, 8+  |  NOP  |  NOP  |  NOP  }
; Non-Execution
;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D0, A7, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0298] = 0x0000_0000, Reg[A7] = 0x1E00_029C

{  NOP  |  SW D1, A7, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_029C] = 0x1111_1111, Reg[A7] = 0x1E00_02A0

{  NOP  |  SW D2, A7, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_02A0] = 0x22222222, Reg[A7] = 0x1E00_02A4

{  NOP  |  SW D3, A7, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_02A4] = 0x2222_2222, Reg[A7] = 0x1E00_02A8

{  NOP  |  SW D4, A7, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_02A8] = 0x2222_2222, Reg[A7] = 0x1E00_02AC

{  NOP  |  SW D6, A7, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_02AC] = 0x2222_2222, Reg[A7] = 0x1E00_02B0

{  NOP  |  SW D7, A7, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_02B0] = 0x3333_3333, Reg[A7] = 0x1E00_02B4

{  NOP  |  SW D8, A7, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_02B4] = 0x8888_8888, Reg[A7] = 0x1E00_02B8

{  NOP  |  SW D9, A7, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_02B8] = 0x9999_9999, Reg[A7] = 0x1E00_02BC



;**************************************************************¡iLinear:Offset¡j LH(U)

{  NOP  | (P1) LH D0, A0, 2+  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x0000_0288, Reg[A0] = 0x1E00_027A							******************* Sam

{  NOP  | (P2) LH D1, A0, 2+  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  NOP  | (P1) LHU D2, A0, 2+  |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0x0000_1E00, Reg[A0] = 0x1E00_027C							******************* Sam

{  NOP  | (P2) LHU D3, A0, 2+  |  NOP  |  NOP  |  NOP  }
; Non-Execution
;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D0, A7, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_02BC] = 0x0000_0288, Reg[A7] = 0x1E00_02C0					******************* Sam

{  NOP  |  SW D1, A7, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_02C0] = 0x1111_1111, Reg[A7] = 0x1E00_02C4

{  NOP  |  SW D2, A7, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_02C4] = 0x0000_1E00, Reg[A7] = 0x1E00_02C8					******************* Sam

{  NOP  |  SW D3, A7, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_02C8] = 0x2222_2222, Reg[A7] = 0x1E00_02CC


;**************************************************************¡iLinear:Offset¡j LB(U)

{  NOP  | (P1) LB D0, A0, 4+  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x0000_0033, Reg[A0] = 0x1E00_027E								******************* Sam

{  NOP  | (P2) LB D1, A0, 2+  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  NOP  | (P1) LBU D2, A0, 0+  |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0x0000_0088, Reg[A0] = 0x1E00_0280								******************* Sam

{  NOP  | (P2) LBU D3, A0, 2+  |  NOP  |  NOP  |  NOP  }
; Non-Execution
;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D0, A7, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_02CC] = 0x0000_0033, Reg[A7] = 0x1E00_02D0

{  NOP  |  SW D1, A7, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_02D0] = 0x1111_1111, Reg[A7] = 0x1E00_02D4

{  NOP  |  SW D2, A7, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_02D4] = 0x0000_0088, Reg[A7] = 0x1E00_02D8

{  NOP  |  SW D3, A7, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_02D8] = 0x2222_2222, Reg[A7] = 0x1E00_02DC



;**************************************************************¡iLinear:Offset¡j (D)LNW

{  NOP  | (P1) LNW D0, A0, 4+  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x1E00_1388, Reg[A0] = 0x1E00_0284				**************************** Sam

{  NOP  | (P2) LNW D1, A0, 4+  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  NOP  | (P1) DLNW D2, A0, 8+  |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0x3333_1111, Reg[D3] = 0x7755_3311				**************************** Sam
;Reg[A0] = 0x1E00_028C

{  NOP  | (P2) DLNW D4, A0, 8+  |  NOP  |  NOP  |  NOP  }
; Non-Execution
;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D0, A7, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_02DC] = 0x0000_1388, Reg[A7] = 0x1E00_02E0

{  NOP  |  SW D1, A7, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_02E0] = 0x1111_1111, Reg[A7] = 0x1E00_02E4

{  NOP  |  SW D2, A7, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_02E4] = 0x3333_1111, Reg[A7] = 0x1E00_02E8

{  NOP  |  SW D3, A7, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_02E8] = 0x7755_3311, Reg[A7] = 0x1E00_02EC

{  NOP  |  SW D4, A7, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_02EC] = 0x2222_2222, Reg[A7] = 0x1E00_02F0			**************************** Sam

{  NOP  |  SW D5, A7, 4+  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_02F0] = 0x5555_5555, Reg[A7] = 0x1E00_02F4			**************************** Sam



;************************************************************** Program Terminate
{  TRAP  |  NOP  |  NOP  |  NOP  |  NOP  }
