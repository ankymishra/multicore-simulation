
BASE_ADDR = 0x2400

;************************************************************** Set Start Address
{  NOP  |  MOVI.L A0, 0x0000    |  NOP  |  NOP  |  NOP  }

{  NOP  |  MOVI.H A0, BASE_ADDR |  NOP  |  NOP  |  NOP  }

;**************************************************************************************Without conditional bit
;************************************************************** FMUL(uu/us/su).(D)
{  NOP  |  NOP  |  MOVI.L D0, 0x0A81  |  NOP  |  NOP  }
;Reg[D0] = 0x0000_0A81 

{  NOP  |  NOP  |  MOVI.H D0, 0x0A81  |  NOP  |  NOP  }
;Reg[D0] = 0xFA81_FA81 

{  NOP  |  NOP  |  MOVI.L D1, 0x8FFF  |  NOP  |  NOP  }
;Reg[D1] = 0x0000_8FFF

{  NOP  |  NOP  |  MOVI.H D1, 0x8FFF  |  NOP  |  NOP  }
;Reg[D1] = 0x8FFF_8FFF

;--------------------------------------------------------------  FMUL
{  NOP  |  NOP  |  FMUL D2, D0, D0  |  NOP  |  NOP  }
;Reg[D2] = 0x006E_5501

{  NOP  |  NOP  |  FMUL D3, D0, D1  |  NOP  |  NOP  }
;Reg[D3] = 0xFB67_857F

{  NOP  |  NOP  |  FMUL D4, D1, D0  |  NOP  |  NOP  }
;Reg[D4] = 0xFB67_857F

{  NOP  |  NOP  |  FMUL D5, D1, D1  |  NOP  |  NOP  }
;Reg[D5] = 0x3100_E001

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D6, AU_PSR  |  NOP  |  NOP  }
;Reg[D6] = 0x0000_0000

;--------------------------------------------------------------  Store Result
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0000] = 0x006E_5501, Reg[A0] = 0x0000_0004

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0004] = 0xFB67_857F, Reg[A0] = 0x0000_0008

{  NOP  |  SW D4, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0008] = 0xFB67_857F, Reg[A0] = 0x0000_000C

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_000C] = 0x3100_E001, Reg[A0] = 0x0000_0010

{  NOP  |  SW D6, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0010] = 0x0000_0000, Reg[A0] = 0x0000_0014

;--------------------------------------------------------------  FMUL.D
{  NOP  |  NOP  |  FMUL.D D2, D0, D0  |  NOP  |  NOP  }
;Reg[D2] = 0x006E_5501, Reg[D3] = 0x006E_5501

{  NOP  |  NOP  |  FMUL.D D4, D0, D1  |  NOP  |  NOP  }
;Reg[D4] = 0xFB67_857F, Reg[D5] = 0xFB67_857F

{  NOP  |  NOP  |  FMUL.D D6, D1, D0  |  NOP  |  NOP  }
;Reg[D6] = 0xFB67_857F, Reg[D7] = 0xFB67_857F

{  NOP  |  NOP  |  FMUL.D D8, D1, D1  |  NOP  |  NOP  }
;Reg[D8] = 0x3100_E001, Reg[D9] = 0x3100_E001

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D10, AU_PSR  |  NOP  |  NOP  }
;Reg[D10] = 0x0000_0000

;--------------------------------------------------------------  Store Result
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0014] = 0x006E_5501, Reg[A0] = 0x0000_0018

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0018] = 0x006E_5501, Reg[A0] = 0x0000_001C

{  NOP  |  SW D4, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_001C] = 0xFB67_857F, Reg[A0] = 0x0000_0020

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0020] = 0xFB67_857F, Reg[A0] = 0x0000_0024

{  NOP  |  SW D6, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0024] = 0xFB67_857F, Reg[A0] = 0x0000_0028

{  NOP  |  SW D7, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0028] = 0xFB67_857F, Reg[A0] = 0x0000_002C

{  NOP  |  SW D8, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_002C] = 0x3100_E001, Reg[A0] = 0x0000_0030

{  NOP  |  SW D9, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0030] = 0x3100_E001, Reg[A0] = 0x0000_0034

{  NOP  |  SW D10, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0034] = 0x0000_0000, Reg[A0] = 0x0000_0038

;--------------------------------------------------------------  FMULUU
{  NOP  |  NOP  |  FMULUU D2, D0, D1  |  NOP  |  NOP  }
;Reg[D2] = 0x05E8_857F

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D3, AU_PSR  |  NOP  |  NOP  }
;Reg[D3] = 0x0000_0000

;--------------------------------------------------------------  Store Result
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0038] = 0x05E8_857F, Reg[A0] = 0x0000_003C

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_003C] = 0x0000_0000, Reg[A0] = 0x0000_0040

;--------------------------------------------------------------  FMULUU.D
{  NOP  |  NOP  |  FMULUU.D D2, D0, D1  |  NOP  |  NOP  }
;Reg[D2] = 0x05E8_857F, Reg[D3] = 0x05E8_857F

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D4, AU_PSR  |  NOP  |  NOP  }
;Reg[D4] = 0x0000_0000

;--------------------------------------------------------------  Store Result
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0040] = 0x05E8_857F, Reg[A0] = 0x0000_0044

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0044] = 0x05E8_857F, Reg[A0] = 0x0000_0048

{  NOP  |  SW D4, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0048] = 0x0000_0000, Reg[A0] = 0x0000_004C

;--------------------------------------------------------------  FMULUS
{  NOP  |  NOP  |  FMULUS D2, D1, D0  |  NOP  |  NOP  }
;Reg[D2] = 0x05E8_857F

{  NOP  |  NOP  |  FMULUS D3, D1, D1  |  NOP  |  NOP  }
;Reg[D3] = 0xC0FF_E001

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D4, AU_PSR  |  NOP  |  NOP  }
;Reg[D4] = 0x0000_0000

;--------------------------------------------------------------  Store Result
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_004C] = 0x05E8_857F, Reg[A0] = 0x0000_0050

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0050] = 0xC0FF_E001, Reg[A0] = 0x0000_0054

{  NOP  |  SW D4, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0054] = 0x0000_0000, Reg[A0] = 0x0000_0058

;--------------------------------------------------------------  FMULUS.D
{  NOP  |  NOP  |  FMULUS.D D2, D1, D0  |  NOP  |  NOP  }
;Reg[D2] = 0x05E8_857F, Reg[D3] = 0x05E8_857F

{  NOP  |  NOP  |  FMULUS.D D4, D1, D1  |  NOP  |  NOP  }
;Reg[D4] = 0xC0FF_E001, Reg[D5] = 0xC0FF_E001

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D6, AU_PSR  |  NOP  |  NOP  }
;Reg[D6] = 0x0000_0000

;--------------------------------------------------------------  Store Result
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0058] = 0x05E8_857F, Reg[A0] = 0x0000_005C

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_005C] = 0x05E8_857F, Reg[A0] = 0x0000_0060

{  NOP  |  SW D4, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0060] = 0xC0FF_E001, Reg[A0] = 0x0000_0064

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0064] = 0xC0FF_E001, Reg[A0] = 0x0000_0068

{  NOP  |  SW D6, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0068] = 0x0000_0000, Reg[A0] = 0x0000_006C

;--------------------------------------------------------------  
{  NOP  |  NOP  |  FMULSU D2, D1, D0  |  NOP  |  NOP  }
;Reg[D2] = 0xFB67_857F
 
{  NOP  |  NOP  |  FMULSU.D D4, D1, D0  |  NOP  |  NOP  }
;Reg[D4] = 0xFB67_857F, Reg[D5] = 0xFB67_857F

;-------------------------------------------------------------- Store Result
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_006C] = 0xFB67_857F, Reg[A0] = 0x0000_0070

{  NOP  |  SW D4, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0070] = 0xFB67_857F, Reg[A0] = 0x0000_0074

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0074] = 0xFB67_857F, Reg[A0] = 0x0000_0078

;************************************************************** MUL.D
{  NOP  |  NOP  |  MOVI.L D0, 0x0081  |  NOP  |  NOP  }
;Reg[D0] = 0x0000_0A81 

{  NOP  |  NOP  |  MOVI.H D0, 0x0081  |  NOP  |  NOP  }
;Reg[D0] = 0x0A81_0A81 

{  NOP  |  NOP  |  MOVI.L D1, 0x8FFF  |  NOP  |  NOP  }
;Reg[D1] = 0x0000_8FFF

{  NOP  |  NOP  |  MOVI.H D1, 0x8FFF  |  NOP  |  NOP  }
;Reg[D1] = 0x8FFF_8FFF
;--------------------------------------------------------------  MUL.D without saturation
{  NOP  |  NOP  |  MUL.D D2, D0, D0  |  NOP  |  NOP  }
;Reg[D2] = 0x4101_4101

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D3, AU_PSR  |  NOP  |  NOP  }
;Reg[D3] = 0x0000_0000

{  NOP  |  NOP  |  MUL.D D4, D0, D1  |  NOP  |  NOP  }
;Reg[D4] = 0x8F7F_8F7F

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D5, AU_PSR  |  NOP  |  NOP  }
;Reg[D5] = 0x0000_0000

{  NOP  |  NOP  |  MUL.D D6, D1, D0  |  NOP  |  NOP  }
;Reg[D6] = 0x8F7F_8F7F

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D7, AU_PSR  |  NOP  |  NOP  }
;Reg[D7] = 0x0000_0000

{  NOP  |  NOP  |  MUL.D D8, D1, D1  |  NOP  |  NOP  }
;Reg[D8] = 0xE001_E001

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D9, AU_PSR  |  NOP  |  NOP  }
;Reg[D9] = 0x0000_0001

;--------------------------------------------------------------  Store Result
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0078] = 0x4101_4101, Reg[A0] = 0x0000_007C

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_007C] = 0x0000_0000, Reg[A0] = 0x0000_0080

{  NOP  |  SW D4, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0080] = 0x8F7F_8F7F, Reg[A0] = 0x0000_0084

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0084] = 0x0000_0000, Reg[A0] = 0x0000_0088

{  NOP  |  SW D6, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0088] = 0x8F7F_8F7F, Reg[A0] = 0x0000_008C

{  NOP  |  SW D7, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_008C] = 0x0000_0000, Reg[A0] = 0x0000_0090

{  NOP  |  SW D8, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0090] = 0xE001_E001, Reg[A0] = 0x0000_0094

{  NOP  |  SW D9, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0094] = 0x0000_0001, Reg[A0] = 0x0000_0098

;--------------------------------------------------------------  MUL.D with saturation
{  NOP  |  NOP  |  MOVIU AU_PSR, 0x20  |  NOP  |  NOP  }
;SATP = 1														<===============update for PACv3.1                                  

{  NOP  |  NOP  |  MUL.D D2, D0, D0  |  NOP  |  NOP  }
;Reg[D2] = 0x4101_4101

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D3, AU_PSR  |  NOP  |  NOP  }
;Reg[D3] = 0x0000_0020

{  NOP  |  NOP  |  MUL.D D4, D0, D1  |  NOP  |  NOP  }
;Reg[D4] = 0x8000_8000

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D5, AU_PSR  |  NOP  |  NOP  }
;Reg[D5] = 0x0000_0020

{  NOP  |  NOP  |  MUL.D D6, D1, D0  |  NOP  |  NOP  }
;Reg[D6] = 0x8000_8000

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D7, AU_PSR  |  NOP  |  NOP  }
;Reg[D7] = 0x0000_0020

{  NOP  |  NOP  |  MUL.D D8, D1, D1  |  NOP  |  NOP  }
;Reg[D8] = 0x7FFF_7FFF

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D9, AU_PSR  |  NOP  |  NOP  }
;Reg[D9] = 0x0000_0020

{  NOP  |  NOP  |  MOVIU AU_PSR, 0x0  |  NOP  |  NOP  }
;SATP = 0

;--------------------------------------------------------------  Store Result
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0098] = 0x4101_4101, Reg[A0] = 0x0000_009C

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_009C] = 0x0000_0020, Reg[A0] = 0x0000_00A0

{  NOP  |  SW D4, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_00A0] = 0x8F7F_8F7F, Reg[A0] = 0x0000_00A4

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_00A4] = 0x0000_0020, Reg[A0] = 0x0000_00A8

{  NOP  |  SW D6, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_00A8] = 0x8F7F_8F7F, Reg[A0] = 0x0000_00AC

{  NOP  |  SW D7, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_00AC] = 0x0000_0020, Reg[A0] = 0x0000_00B0

{  NOP  |  SW D8, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_00B0] = 0x7FFF_7FFF, Reg[A0] = 0x0000_00B4           <===================================== Updated by ponpon

{  NOP  |  SW D9, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_00B4] = 0x0000_0021, Reg[A0] = 0x0000_00B8          <===================================== Updated by jeremy

;************************************************************** XFMUL.(D)
{  NOP  |  NOP  |  MOVI.L D0, 0x0A81  |  NOP  |  NOP  }
;Reg[D0] = 0x0000_0A81 

{  NOP  |  NOP  |  MOVI.H D0, 0x0A81  |  NOP  |  NOP  }
;Reg[D0] = 0xFA81_FA81 

{  NOP  |  NOP  |  MOVI.L D1, 0x8FFF  |  NOP  |  NOP  }
;Reg[D1] = 0x0000_8FFF

{  NOP  |  NOP  |  MOVI.H D1, 0x8FFF  |  NOP  |  NOP  }
;Reg[D1] = 0x8FFF_8FFF
;--------------------------------------------------------------  XFMUL
{  NOP  |  NOP  |  XFMUL D2, D0, D0  |  NOP  |  NOP  }
;Reg[D2] = 0x0DD5_BF02

{  NOP  |  NOP  |  XFMUL D3, D0, D1  |  NOP  |  NOP  }
;Reg[D3] = 0xF6CF_0AFE

{  NOP  |  NOP  |  XFMUL D4, D1, D0  |  NOP  |  NOP  }
;Reg[D4] = 0xF6CF_0AFE

{  NOP  |  NOP  |  XFMUL D5, D1, D1  |  NOP  |  NOP  }
;Reg[D5] = 0xA1FD_C002

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D6, AU_PSR  |  NOP  |  NOP  }
;Reg[D6] = 0x0000_0000

;--------------------------------------------------------------  Store Result
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_00B8] = 0x0DDC_AA02, Reg[A0] = 0x0000_00BC                    <========================= Updated by ponpon 

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_00BC] = 0xF6CF_0AFE, Reg[A0] = 0x0000_00C0

{  NOP  |  SW D4, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_00C0] = 0xF6CF_0AFE, Reg[A0] = 0x0000_00C4

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_00C4] = 0x6210_C002, Reg[A0] = 0x0000_00C8                    <========================= ponpon

{  NOP  |  SW D6, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_00C8] = 0x0000_0000, Reg[A0] = 0x0000_00CC

;--------------------------------------------------------------  XFMUL.D
{  NOP  |  NOP  |  XFMUL.D D2, D0, D0  |  NOP  |  NOP  }
;Reg[D2] = 0x0DD5_BF02, Reg[D3] = 0x0DD5_BF02

{  NOP  |  NOP  |  XFMUL.D D4, D0, D1  |  NOP  |  NOP  }
;Reg[D4] = 0xF6CF_0AFE, Reg[D5] = 0xF6CF_0AFE

{  NOP  |  NOP  |  XFMUL.D D6, D1, D0  |  NOP  |  NOP  }
;Reg[D6] = 0xF6CF_0AFE, Reg[D7] = 0xF6CF_0AFE

{  NOP  |  NOP  |  XFMUL.D D8, D1, D1  |  NOP  |  NOP  }
;Reg[D8] = 0xA1FD_C002, Reg[D9] = 0xA1FD_C002

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D10, AU_PSR  |  NOP  |  NOP  }
;Reg[D10] = 0x0000_0000

;--------------------------------------------------------------  Store Result
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_00CC] = 0x00DC_AA02, Reg[A0] = 0x0000_00D0                 <======================= ponpon

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_00D0] = 0x0DDC_AA02, Reg[A0] = 0x0000_00D4                 <======================= ponpon

{  NOP  |  SW D4, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_00D4] = 0xF6CF_0AFE, Reg[A0] = 0x0000_00D8

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_00D8] = 0xF6CF_0AFE, Reg[A0] = 0x0000_00DC

{  NOP  |  SW D6, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_00DC] = 0xF6CF_0AFE, Reg[A0] = 0x0000_00E0

{  NOP  |  SW D7, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_00E0] = 0xF6CF_0AFE, Reg[A0] = 0x0000_00E4

{  NOP  |  SW D8, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_00E4] = 0x6201_C002, Reg[A0] = 0x0000_00E8                 <======================= ponpon

{  NOP  |  SW D9, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_00E8] = 0x6201_C002, Reg[A0] = 0x0000_00EC                 <======================= ponpon

{  NOP  |  SW D10, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_00EC] = 0x0000_0000, Reg[A0] = 0x0000_00F0

;************************************************************** XMUL.D
{  NOP  |  NOP  |  XMUL.D D2, D0, D0  |  NOP  |  NOP  }
;Reg[D2] = 0x00DC_00DC

{  NOP  |  NOP  |  XMUL.D D3, D0, D1  |  NOP  |  NOP  }
;Reg[D3] = 0xF6CF_F6CF

{  NOP  |  NOP  |  XMUL.D D4, D1, D0  |  NOP  |  NOP  }
;Reg[D4] = 0xF6CF_F6CF

{  NOP  |  NOP  |  XMUL.D D5, D1, D1  |  NOP  |  NOP  }
;Reg[D5] = 0xA1FD_A1FD

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D6, AU_PSR  |  NOP  |  NOP  }
;Reg[D6] = 0x0000_0000

;-------------------------------------------------------------- Store Result
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_00F0] = 0x00DC_00DC, Reg[A0] = 0x0000_00F4

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_00F4] = 0xF6CF_F6CF, Reg[A0] = 0x0000_00F8

{  NOP  |  SW D4, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_00F8] = 0xF6CF_F6CF, Reg[A0] = 0x0000_00FC

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_00FC] = 0x6201_6201, Reg[A0] = 0x0000_0100                  <======================== ponpon

{  NOP  |  SW D6, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0100] = 0x0000_0000, Reg[A0] = 0x0000_0104

;************************************************************** DOTP2, XDOTP2 without predicate bit
{  NOP  |  NOP  |  MOVI.L D0, 0x0A81  |  NOP  |  NOP  }
;Reg[D0] = 0x0000_0A81 

{  NOP  |  NOP  |  MOVI.H D0, 0x0A81  |  NOP  |  NOP  }
;Reg[D0] = 0xFA81_FA81 

{  NOP  |  NOP  |  MOVI.L D1, 0x8FFF  |  NOP  |  NOP  }
;Reg[D1] = 0x0000_8FFF

{  NOP  |  NOP  |  MOVI.H D1, 0x8FFF  |  NOP  |  NOP  }
;Reg[D1] = 0x8FFF_8FFF

;--------------------------------------------------------------  DOTP2
{  NOP  |  NOP  |  DOTP2 D2, D0, D0  |  NOP  |  NOP  }
;Reg[D2] = 0x006E_5501 +  0x006E_5501 = 0x00DC_AA02

{  NOP  |  NOP  |  DOTP2 D3, D0, D1  |  NOP  |  NOP  }
;Reg[D3] = 0xFB67_857F +  0xFB67_857F = 0xF6CF_0AFE

{  NOP  |  NOP  |  DOTP2 D4, D1, D0  |  NOP  |  NOP  }
;Reg[D4] = 0xFB67_857F +  0xFB67_857F = 0xF6CF_0AFE

{  NOP  |  NOP  |  DOTP2 D5, D1, D1  |  NOP  |  NOP  }
;Reg[D5] = 0x3100_E001 +  0x3100_E001 = 0x6201_C002

;--------------------------------------------------------------  Store Result
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0104] = 0x00DC_AA02, Reg[A0] = 0x0000_0108

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0108] = 0xF6CF_0AFE, Reg[A0] = 0x0000_010C

{  NOP  |  SW D4, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_010C] = 0xF6CF_0AFE, Reg[A0] = 0x0000_0110

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0110] = 0x6201_C002, Reg[A0] = 0x0000_0114

;--------------------------------------------------------------  XDOTP2
{  NOP  |  NOP  |  XDOTP2 D2, D0, D0  |  NOP  |  NOP  }
;Reg[D2] = 0x006E_5501 +  0x006E_5501 = 0x00DC_AA02

{  NOP  |  NOP  |  XDOTP2 D3, D0, D1  |  NOP  |  NOP  }
;Reg[D3] = 0x7B67_857F +  0x7B67_857F = 0xF6CF_0AFE

{  NOP  |  NOP  |  XDOTP2 D4, D1, D0  |  NOP  |  NOP  }
;Reg[D4] = 0x7B67_857F +  0x7B67_857F = 0xF6CF_0AFE

{  NOP  |  NOP  |  XDOTP2 D5, D1, D1  |  NOP  |  NOP  }
;Reg[D5] = 0x3100_E001 +  0x3100_E001 = 0x6201_C002

;--------------------------------------------------------------  Store Result
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0114] = 0x01B9_5404, Reg[A0] = 0x0000_0118            <============ ponpon

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0118] = 0xED9E_15FC, Reg[A0] = 0x0000_011C            <============ ponpon

{  NOP  |  SW D4, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_011C] = 0xED9E_15FC, Reg[A0] = 0x0000_0120            <============ ponpon

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0120] = 0xC403_8004, Reg[A0] = 0x0000_0124            <============ ponpon

;**************************************************************************************With conditional bit
;**************************************************************
{  NOP  |  NOP  |  MOVI.L D15, 0xFFFF  |  NOP  |  NOP  }
;Reg[D15] = 0x0000_FFFF

{  NOP  |  NOP  |  MOVI.H D15, 0xFFFF  |  NOP  |  NOP  }
;Reg[D15] = 0xFFFF_FFFF

{  NOP  |  NOP  |  SLTI D14, P14, P15, D15, 0x00000000   |  NOP  |  NOP  }
;Reg[D14] = 0x0000_0001, Reg[P14] = 1, Reg[P15] = 0

;************************************************************** FMUL(uu/us/su).(D)
;--------------------------------------------------------------  FMUL
{  NOP  |  NOP  |  (P14) FMUL D2, D0, D0  |  NOP  |  NOP  }
;Reg[D2] = 0x006E_5501

{  NOP  |  NOP  |  (P15) FMUL D2, D1, D1  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  (P14) FMUL D3, D0, D1  |  NOP  |  NOP  }
;Reg[D3] = 0xFB67_857F

{  NOP  |  NOP  |  (P15) FMUL D3, D1, D1  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  (P14) FMUL D4, D1, D0  |  NOP  |  NOP  }
;Reg[D4] = 0xFB67_857F

{  NOP  |  NOP  |  (P15) FMUL D4, D1, D1  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  (P14) FMUL D5, D1, D1  |  NOP  |  NOP  }
;Reg[D5] = 0x3100_E001

{  NOP  |  NOP  |  (P15) FMUL D5, D0, D0  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D6, AU_PSR  |  NOP  |  NOP  }
;Reg[D6] = 0x0000_0000

;--------------------------------------------------------------  Store Result
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0124] = 0x006E_5501, Reg[A0] = 0x0000_0128

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0128] = 0xFB67_857F, Reg[A0] = 0x0000_012C

{  NOP  |  SW D4, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_012C] = 0xFB67_857F, Reg[A0] = 0x0000_0130

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0130] = 0x3100_E001, Reg[A0] = 0x0000_0134

{  NOP  |  SW D6, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0134] = 0x0000_0000, Reg[A0] = 0x0000_0138           <============ ponpon

;--------------------------------------------------------------  FMUL.D
{  NOP  |  NOP  |  (P14) FMUL.D D2, D0, D0  |  NOP  |  NOP  }
;Reg[D2] = 0x006E_5501, Reg[D3] = 0x006E_5501

{  NOP  |  NOP  |  (P15) FMUL.D D2, D1, D1  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  (P14) FMUL.D D4, D0, D1  |  NOP  |  NOP  }
;Reg[D4] = 0xFB67_857F, Reg[D5] = 0xFB67_857F

{  NOP  |  NOP  |  (P15) FMUL.D D4, D1, D1  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  (P14) FMUL.D D6, D1, D0  |  NOP  |  NOP  }
;Reg[D6] = 0xFB67_857F, Reg[D7] = 0xFB67_857F

{  NOP  |  NOP  |  (P15) FMUL.D D6, D1, D1  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  (P14) FMUL.D D8, D1, D1  |  NOP  |  NOP  }
;Reg[D8] = 0x3100_E001, Reg[D9] = 0x3100_E001

{  NOP  |  NOP  |  (P15) FMUL.D D8, D0, D0  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D10, AU_PSR  |  NOP  |  NOP  }
;Reg[D10] = 0x0000_0000

;--------------------------------------------------------------  Store Result
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0138] = 0x006E_5501, Reg[A0] = 0x0000_013C

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_013C] = 0x006E_5501, Reg[A0] = 0x0000_0140

{  NOP  |  SW D4, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0140] = 0xFB67_857F, Reg[A0] = 0x0000_0144

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0144] = 0xFB67_857F, Reg[A0] = 0x0000_0148

{  NOP  |  SW D6, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0148] = 0xFB67_857F, Reg[A0] = 0x0000_014C

{  NOP  |  SW D7, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_014C] = 0xFB67_857F, Reg[A0] = 0x0000_0150

{  NOP  |  SW D8, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0150] = 0x3100_E001, Reg[A0] = 0x0000_0154

{  NOP  |  SW D9, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0154] = 0x3100_E001, Reg[A0] = 0x0000_0158

{  NOP  |  SW D10, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0158] = 0x0000_0000, Reg[A0] = 0x0000_015C

;--------------------------------------------------------------  FMULUU
{  NOP  |  NOP  |  (P14) FMULUU D2, D0, D1  |  NOP  |  NOP  }
;Reg[D2] = 0x05E8_857F

{  NOP  |  NOP  |  (P15) FMULUU D2, D1, D1  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D3, AU_PSR  |  NOP  |  NOP  }
;Reg[D3] = 0x0000_0000

;--------------------------------------------------------------  Store Result
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_015C] = 0x05E8_857F, Reg[A0] = 0x0000_0160

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0160] = 0x0000_0000, Reg[A0] = 0x0000_0164

;--------------------------------------------------------------  FMULUU.D
{  NOP  |  NOP  |  (P14) FMULUU.D D2, D0, D1  |  NOP  |  NOP  }
;Reg[D2] = 0x05E8_857F, Reg[D3] = 0x05E8_857F

{  NOP  |  NOP  |  (P15) FMULUU.D D2, D1, D1  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D4, AU_PSR  |  NOP  |  NOP  }
;Reg[D4] = 0x0000_0000

;--------------------------------------------------------------  Store Result
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0164] = 0x05E8_857F, Reg[A0] = 0x0000_0168

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0168] = 0x05E8_857F, Reg[A0] = 0x0000_016C

{  NOP  |  SW D4, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_016C] = 0x0000_0000, Reg[A0] = 0x0000_0170

;--------------------------------------------------------------  FMULUS
{  NOP  |  NOP  |  (P14) FMULUS D2, D1, D0  |  NOP  |  NOP  }
;Reg[D2] = 0x05E8_857F

{  NOP  |  NOP  |  (P15) FMULUS D2, D1, D1  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  (P14) FMULUS D3, D1, D1  |  NOP  |  NOP  }
;Reg[D3] = 0xC0FF_E001

{  NOP  |  NOP  |  (P15) FMULUS D3, D1, D0  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D4, AU_PSR  |  NOP  |  NOP  }
;Reg[D4] = 0x0000_0000

;--------------------------------------------------------------  Store Result
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0170] = 0x05E8_857F, Reg[A0] = 0x0000_0174

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0174] = 0xC0FF_E001, Reg[A0] = 0x0000_0178

{  NOP  |  SW D4, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0178] = 0x0000_0000, Reg[A0] = 0x0000_017C

;--------------------------------------------------------------  FMULUS.D
{  NOP  |  NOP  |  (P14) FMULUS.D D2, D1, D0  |  NOP  |  NOP  }
;Reg[D2] = 0x05E8_857F, Reg[D3] = 0x05E8_857F

{  NOP  |  NOP  |  (P15) FMULUS.D D2, D1, D1  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  (P14) FMULUS.D D4, D1, D1  |  NOP  |  NOP  }
;Reg[D4] = 0xC0FF_E001, Reg[D5] = 0xC0FF_E001

{  NOP  |  NOP  |  (P15) FMULUS.D D4, D1, D0  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D6, AU_PSR  |  NOP  |  NOP  }
;Reg[D6] = 0x0000_0000

;--------------------------------------------------------------  Store Result
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_017C] = 0x05E8_857F, Reg[A0] = 0x0000_0180

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0180] = 0x05E8_857F, Reg[A0] = 0x0000_0184

{  NOP  |  SW D4, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0184] = 0xC0FF_E001, Reg[A0] = 0x0000_0188

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0188] = 0xC0FF_E001, Reg[A0] = 0x0000_018C

{  NOP  |  SW D6, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_018C] = 0x0000_0000, Reg[A0] = 0x0000_0190

;--------------------------------------------------------------  
{  NOP  |  NOP  |  (P14) FMULSU D2, D1, D0  |  NOP  |  NOP  }
;Reg[D2] = 0xC0FF_E001

{  NOP  |  NOP  |  (P15) FMULSU D2, D1, D1  |  NOP  |  NOP  }
;Not execute
 
{  NOP  |  NOP  |  (P14) FMULSU.D D4, D1, D0  |  NOP  |  NOP  }
;Reg[D4] = 0xC0FF_E001, Reg[D5] = 0xC0FF_E001

{  NOP  |  NOP  |  (P15) FMULSU.D D4, D1, D1  |  NOP  |  NOP  }
;Not execute

;-------------------------------------------------------------- Store Result
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0190] = 0xFB67_857F, Reg[A0] = 0x0000_0194      <============ ponpon

{  NOP  |  SW D4, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0194] = 0xFB67_857F, Reg[A0] = 0x0000_0198      <============ ponpon

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0198] = 0xFB67_857F, Reg[A0] = 0x0000_019C      <============ ponpon

;************************************************************** MUL.D
{  NOP  |  NOP  |  MOVI.L D0, 0x0081  |  NOP  |  NOP  }
;Reg[D0] = 0x0000_0A81 

{  NOP  |  NOP  |  MOVI.H D0, 0x0081  |  NOP  |  NOP  }
;Reg[D0] = 0x0A81_0A81 

{  NOP  |  NOP  |  MOVI.L D1, 0x8FFF  |  NOP  |  NOP  }
;Reg[D1] = 0x0000_8FFF

{  NOP  |  NOP  |  MOVI.H D1, 0x8FFF  |  NOP  |  NOP  }
;Reg[D1] = 0x8FFF_8FFF
;--------------------------------------------------------------  MUL.D without saturation
{  NOP  |  NOP  |  (P14) MUL.D D2, D0, D0  |  NOP  |  NOP  }
;Reg[D2] = 0x4101_4101

{  NOP  |  NOP  |  (P15) MUL.D D2, D1, D1  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D3, AU_PSR  |  NOP  |  NOP  }
;Reg[D3] = 0x0000_0000
;--------------------------------------------------------------
{  NOP  |  NOP  |  (P14) MUL.D D4, D0, D1  |  NOP  |  NOP  }
;Reg[D4] = 0x8F7F_8F7F

{  NOP  |  NOP  |  (P15) MUL.D D4, D1, D1  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D5, AU_PSR  |  NOP  |  NOP  }
;Reg[D5] = 0x0000_0000
;--------------------------------------------------------------
{  NOP  |  NOP  |  (P14) MUL.D D6, D1, D0  |  NOP  |  NOP  }
;Reg[D6] = 0x8F7F_8F7F

{  NOP  |  NOP  |  (P15) MUL.D D6, D1, D1  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D7, AU_PSR  |  NOP  |  NOP  }
;Reg[D7] = 0x0000_0000
;--------------------------------------------------------------  with overflow
{  NOP  |  NOP  |  (P14) MUL.D D8, D1, D1  |  NOP  |  NOP  }
;Reg[D8] = 0xE001_E001

{  NOP  |  NOP  |  (P15) MUL.D D8, D0, D0  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D9, AU_PSR  |  NOP  |  NOP  }
;Reg[D9] = 0x0000_0001

;--------------------------------------------------------------  Store Result
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_019C] = 0x4101_4101, Reg[A0] = 0x0000_01A0

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_01A0] = 0x0000_0000, Reg[A0] = 0x0000_01A4

{  NOP  |  SW D4, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_01A4] = 0x8F7F_8F7F, Reg[A0] = 0x0000_01A8

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_01A8] = 0x0000_0000, Reg[A0] = 0x0000_01AC

{  NOP  |  SW D6, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_01AC] = 0x8F7F_8F7F, Reg[A0] = 0x0000_01B0

{  NOP  |  SW D7, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_01B0] = 0x0000_0000, Reg[A0] = 0x0000_01B4

{  NOP  |  SW D8, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_01B4] = 0xE001_E001, Reg[A0] = 0x0000_01B8

{  NOP  |  SW D9, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_01B8] = 0x0000_0001, Reg[A0] = 0x0000_01BC

;--------------------------------------------------------------  MUL.D with saturation
{  NOP  |  NOP  |  MOVIU AU_PSR, 0x20  |  NOP  |  NOP  }
;SATP = 1														<===============update for PACv3.1 

{  NOP  |  NOP  |  (P14) MUL.D D2, D0, D0  |  NOP  |  NOP  }
;Reg[D2] = 0x4101_4101

{  NOP  |  NOP  |  (P15) MUL.D D2, D1, D1  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D3, AU_PSR  |  NOP  |  NOP  }
;Reg[D3] = 0x0000_0020
;--------------------------------------------------------------
{  NOP  |  NOP  |  (P14) MUL.D D4, D0, D1  |  NOP  |  NOP  }
;Reg[D4] = 0x8000_8000

{  NOP  |  NOP  |  (P15) MUL.D D4, D1, D1  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D5, AU_PSR  |  NOP  |  NOP  }
;Reg[D5] = 0x0000_0020
;--------------------------------------------------------------
{  NOP  |  NOP  |  (P14) MUL.D D6, D1, D0  |  NOP  |  NOP  }
;Reg[D6] = 0x8000_8000

{  NOP  |  NOP  |  (P15) MUL.D D6, D1, D1  |  NOP  |  NOP  }
;Not execute


{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D7, AU_PSR  |  NOP  |  NOP  }
;Reg[D7] = 0x0000_0020
;--------------------------------------------------------------
{  NOP  |  NOP  |  (P14) MUL.D D8, D1, D1  |  NOP  |  NOP  }
;Reg[D8] = 0x7FFF_7FFF

{  NOP  |  NOP  |  (P15) MUL.D D8, D0, D0  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D9, AU_PSR  |  NOP  |  NOP  }
;Reg[D9] = 0x0000_0020

{  NOP  |  NOP  |  MOVIU AU_PSR, 0x0  |  NOP  |  NOP  }
;SATP = 0

;--------------------------------------------------------------  Store Result
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_01BC] = 0x4101_4101, Reg[A0] = 0x0000_01C0

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_01C0] = 0x0000_0020, Reg[A0] = 0x0000_01C4

{  NOP  |  SW D4, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_01C4] = 0x8F7F_8F7F, Reg[A0] = 0x0000_01C8             <============= ponpon

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_01C8] = 0x0000_0020, Reg[A0] = 0x0000_01CC

{  NOP  |  SW D6, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_01CC] = 0x8F7F_8F7F, Reg[A0] = 0x0000_01D0             <============= ponpon

{  NOP  |  SW D7, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_01D0] = 0x0000_0020, Reg[A0] = 0x0000_01D4

{  NOP  |  SW D8, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_01D4] = 0x7FFF_7FFF, Reg[A0] = 0x0000_01D8

{  NOP  |  SW D9, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_01D8] = 0x0000_0021, Reg[A0] = 0x0000_01DC           <=============jeremy

;--------------------------------------------------------------

;************************************************************** XFMUL.(D)
{  NOP  |  NOP  |  MOVI.L D0, 0x0A81  |  NOP  |  NOP  }
;Reg[D0] = 0x0000_0A81 

{  NOP  |  NOP  |  MOVI.H D0, 0x0A81  |  NOP  |  NOP  }
;Reg[D0] = 0xFA81_FA81 

{  NOP  |  NOP  |  MOVI.L D1, 0x8FFF  |  NOP  |  NOP  }
;Reg[D1] = 0x0000_8FFF

{  NOP  |  NOP  |  MOVI.H D1, 0x8FFF  |  NOP  |  NOP  }
;Reg[D1] = 0x8FFF_8FFF
;--------------------------------------------------------------  XFMUL
{  NOP  |  NOP  |  (P14) XFMUL D2, D0, D0  |  NOP  |  NOP  }
;Reg[D2] = 0x0DD5_BF02

{  NOP  |  NOP  |  (P15) XFMUL D2, D1, D1  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  (P14) XFMUL D3, D0, D1  |  NOP  |  NOP  }
;Reg[D3] = 0xF6CF_0AFE

{  NOP  |  NOP  |  (P15) XFMUL D3, D1, D1  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  (P14) XFMUL D4, D1, D0  |  NOP  |  NOP  }
;Reg[D4] = 0xF6CF_0AFE

{  NOP  |  NOP  |  (P15) XFMUL D4, D1, D1  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  (P14) XFMUL D5, D1, D1  |  NOP  |  NOP  }
;Reg[D5] = 0xA1FD_C002

{  NOP  |  NOP  |  (P15) XFMUL D5, D0, D0  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D6, AU_PSR  |  NOP  |  NOP  }
;Reg[D6] = 0x0000_0000

;--------------------------------------------------------------  Store Result
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_01DC] = 0x00DC_AA02, Reg[A0] = 0x0000_01E0               <=============== ponpon

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_01E0] = 0xF6CF_0AFE, Reg[A0] = 0x0000_01E4

{  NOP  |  SW D4, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_01E4] = 0xF6CF_0AFE, Reg[A0] = 0x0000_01E8

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_01E8] = 0x6201_C002, Reg[A0] = 0x0000_01EC              <================ ponpon

{  NOP  |  SW D6, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_01EC] = 0x0000_0000, Reg[A0] = 0x0000_01F0

;--------------------------------------------------------------  XFMUL.D
{  NOP  |  NOP  |  (P14) XFMUL.D D2, D0, D0  |  NOP  |  NOP  }
;Reg[D2] = 0x0DD5_BF02, Reg[D3] = 0x0DD5_BF02

{  NOP  |  NOP  |  (P15) XFMUL.D D2, D1, D1  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  (P14) XFMUL.D D4, D0, D1  |  NOP  |  NOP  }
;Reg[D4] = 0xF6CF_0AFE, Reg[D5] = 0xF6CF_0AFE

{  NOP  |  NOP  |  (P15) XFMUL.D D4, D1, D1  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  (P14) XFMUL.D D6, D1, D0  |  NOP  |  NOP  }
;Reg[D6] = 0xF6CF_0AFE, Reg[D7] = 0xF6CF_0AFE

{  NOP  |  NOP  |  (P15) XFMUL.D D6, D1, D1  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  (P14) XFMUL.D D8, D1, D1  |  NOP  |  NOP  }
;Reg[D8] = 0xA1FD_C002, Reg[D9] = 0xA1FD_C002

{  NOP  |  NOP  |  (P15) XFMUL.D D8, D0, D0  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D10, AU_PSR  |  NOP  |  NOP  }
;Reg[D10] = 0x0000_0000

;--------------------------------------------------------------  Store Result
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_01F0] = 0x00DC_AA02, Reg[A0] = 0x0000_01F4               <============= ponpon

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_01F4] = 0x00DC_AA02, Reg[A0] = 0x0000_01F8               <============= ponpon

{  NOP  |  SW D4, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_01F8] = 0xF6CF_0AFE, Reg[A0] = 0x0000_01FC

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_01FC] = 0xF6CF_0AFE, Reg[A0] = 0x0000_0200

{  NOP  |  SW D6, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0200] = 0xF6CF_0AFE, Reg[A0] = 0x0000_0204

{  NOP  |  SW D7, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0204] = 0xF6CF_0AFE, Reg[A0] = 0x0000_0208

{  NOP  |  SW D8, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0208] = 0x6201_C002, Reg[A0] = 0x0000_020C               <============= ponpon

{  NOP  |  SW D9, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_020C] = 0x6201_C002, Reg[A0] = 0x0000_0210               <============= ponpon

{  NOP  |  SW D10, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0210] = 0x0000_0000, Reg[A0] = 0x0000_0214

;************************************************************** XMUL.D
{  NOP  |  NOP  |  (P14) XMUL.D D2, D0, D0  |  NOP  |  NOP  }
;Reg[D2] = 0x00DC_00DC

{  NOP  |  NOP  |  (P15) XMUL.D D2, D1, D1  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  (P14) XMUL.D D3, D0, D1  |  NOP  |  NOP  }
;Reg[D3] = 0xF6CF_F6CF

{  NOP  |  NOP  |  (P15) XMUL.D D3, D1, D1  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  (P14) XMUL.D D4, D1, D0  |  NOP  |  NOP  }
;Reg[D4] = 0xF6CF_F6CF

{  NOP  |  NOP  |  (P15) XMUL.D D4, D1, D1  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  (P14) XMUL.D D5, D1, D1  |  NOP  |  NOP  }
;Reg[D5] = 0xA1FD_A1FD

{  NOP  |  NOP  |  (P15) XMUL.D D5, D0, D0  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D6, AU_PSR  |  NOP  |  NOP  }
;Reg[D6] = 0x0000_0000

;-------------------------------------------------------------- Store Result
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0214] = 0x00DC_00DC, Reg[A0] = 0x0000_0218

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0218] = 0xF6CF_F6CF, Reg[A0] = 0x0000_021C

{  NOP  |  SW D4, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_021C] = 0xF6CF_F6CF, Reg[A0] = 0x0000_0220

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0220] = 0x6201_6201, Reg[A0] = 0x0000_0224          <============ ponpon

{  NOP  |  SW D6, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0224] = 0x0000_0000, Reg[A0] = 0x0000_0228

;************************************************************** FMAC(uu/us/su).(D)
{  NOP  |  NOP  |  MOVI.L AC0, 0x0000  |  NOP  |  NOP  }
;Reg[AC0] = 0x00_0000_0000 

{  NOP  |  NOP  |  MOVIU.H AC0, 0x0000  |  NOP  |  NOP  }
;Reg[AC0] = 0x00_0000_0000

{  NOP  |  NOP  |  MOVI.L AC1, 0x0000  |  NOP  |  NOP  }
;Reg[AC0] = 0x00_0000_0000 

{  NOP  |  NOP  |  MOVIU.H AC1, 0x0000  |  NOP  |  NOP  }
;Reg[AC1] = 0x00_0000_0000

{  NOP  |  NOP  |  MOVI.L D0, 0x0A81  |  NOP  |  NOP  }
;Reg[D0] = 0x0A81_0A81 

{  NOP  |  NOP  |  MOVI.H D0, 0x0A81  |  NOP  |  NOP  }
;Reg[D0] = 0x0A81_0A81 

{  NOP  |  NOP  |  MOVI.L D1, 0x8FFF  |  NOP  |  NOP  }
;Reg[D1] = 0x7FFF_8FFF

{  NOP  |  NOP  |  MOVI.H D1, 0x8FFF  |  NOP  |  NOP  }
;Reg[D1] = 0x8FFF_8FFF

;--------------------------------------------------------------  FMAC
{  NOP  |  NOP  |  (P14) FMAC AC0, D0, D0  |  NOP  |  NOP  }
;Reg[AC0] = (0x00_006E_5501 + 0x00_0000_0000) = 0x00_006E_5501

{  NOP  |  NOP  |  (P15) FMAC AC0, D1, D1  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  COPY D15, AC0  |  NOP  |  NOP  }
;Reg[D15] = 006E_5501

{  NOP  |  SW D15, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0228] = 006E_5501, Reg[A0] = 0x0000_022C
;--------------------------------------------------------------
{  NOP  |  NOP  |  (P14) FMAC AC0, D0, D1  |  NOP  |  NOP  }
;Reg[AC0] = (0x00_FB67_857F + 0x00_006E_5501) = 0xFF_FBD5_DA80

{  NOP  |  NOP  |  (P15) FMAC AC0, D1, D1  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  COPY D15, AC0  |  NOP  |  NOP  }
;Reg[D15] = FBD5_DA80

{  NOP  |  SW D15, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_022C] = FBD5_DA80, Reg[A0] = 0x0000_0230
;--------------------------------------------------------------
{  NOP  |  NOP  |  (P14) FMAC AC0, D1, D0  |  NOP  |  NOP  }
;Reg[AC0] = (0x00_FB67_857F + 0xFF_FBD5_DA80) = 0xFF_F73D_5FFF

{  NOP  |  NOP  |  (P15) FMAC AC0, D1, D1  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  COPY D15, AC0  |  NOP  |  NOP  }
;Reg[D15] = F73D_5FFF

{  NOP  |  SW D15, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0230] = F73D_5FFF, Reg[A0] = 0x0000_0234
;--------------------------------------------------------------
{  NOP  |  NOP  |  (P14) FMAC AC0, D1, D1  |  NOP  |  NOP  }
;Reg[AC2] = (0x00_3100_E001 + 0xFF_F73D_5FFF) = 0x00_283E_4000

{  NOP  |  NOP  |  (P15) FMAC AC0, D0, D0  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  COPY D15, AC0  |  NOP  |  NOP  }
;Reg[D15] = 0x283E_4000

{  NOP  |  SW D15, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0234] = 0x283E_4000, Reg[A0] = 0x0000_0238
;--------------------------------------------------------------  FMAC.D
{  NOP  |  NOP  |  (P14) FMAC.D AC0, D0, D0  |  NOP  |  NOP  }
;Reg[AC0] = (0x00_006E_5501 + 0x00_283E_4000) = 0x00_28AC_9501
;Reg[AC1] = (0x00_006E_5501 + 0x00_0000_0000) = 0x00_006E_5501

{  NOP  |  NOP  |  (P15) FMAC.D AC0, D1, D1  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  COPY D15, AC0  |  NOP  |  NOP  }
;Reg[D15] = 0x28AC_9501

{  NOP  |  NOP  |  COPY D14, AC1  |  NOP  |  NOP  }
;Reg[D15] = 0x006E_5501

{  NOP  |  SW D15, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0238] = 0x28AC_9501, Reg[A0] = 0x0000_023C

{  NOP  |  SW D14, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_023C] = 0x006E_5501, Reg[A0] = 0x0000_0240
;--------------------------------------------------------------
{  NOP  |  NOP  |  (P14) FMAC.D AC0, D0, D1  |  NOP  |  NOP  }
;Reg[AC0] = (0x00_FB67_857F + 0x00_28AC_9501) = 0x00_2414_1A80
;Reg[AC1] = (0x00_FB67_857F + 0x00_006E_5501) = 0xFF_FBD5_DA80

{  NOP  |  NOP  |  (P15) FMAC.D AC0, D1, D1  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  COPY D15, AC0  |  NOP  |  NOP  }
;Reg[D15] = 0x2414_1A80

{  NOP  |  NOP  |  COPY D14, AC1  |  NOP  |  NOP  }
;Reg[D14] = 0xFBD5_DA80

{  NOP  |  SW D15, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0240] = 0x2414_1A80, Reg[A0] = 0x0000_0244

{  NOP  |  SW D14, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0244] = 0xFBD5_DA80, Reg[A0] = 0x0000_0248
;--------------------------------------------------------------
{  NOP  |  NOP  |  (P14) FMAC.D AC0, D1, D0  |  NOP  |  NOP  }
;Reg[AC0] = (0x00_FB67_857F + 0x00_2414_1A80) = 0x00_1F7B_9FFF
;Reg[AC1] = (0x00_FB67_857F + 0xFF_FBD5_DA80) = 0xFF_F73D_5FFF

{  NOP  |  NOP  |  (P15) FMAC.D AC0, D1, D1  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  COPY D15, AC0  |  NOP  |  NOP  }
;Reg[D15] = 0x1F7B_9FFF

{  NOP  |  NOP  |  COPY D14, AC1  |  NOP  |  NOP  }
;Reg[D14] = 0xF73D_5FFF

{  NOP  |  SW D15, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0248] = 0x1F7B_9FFF, Reg[A0] = 0x0000_024C

{  NOP  |  SW D14, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_024C] = 0xF73D_5FFF, Reg[A0] = 0x0000_0250
;--------------------------------------------------------------
{  NOP  |  NOP  |  (P14) FMAC.D AC0, D1, D1  |  NOP  |  NOP  }
;Reg[AC0] = (0x00_3100_E001 + 0x00_1F7B_9FFF) = 0x00_507C_8000
;Reg[AC1] = (0x00_3100_E001 + 0xFF_F73D_5FFF) = 0x00_283E_4000

{  NOP  |  NOP  |  (P15) FMAC.D AC0, D0, D0  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  COPY D15, AC0  |  NOP  |  NOP  }
;Reg[D15] = 0x507C_8000

{  NOP  |  NOP  |  COPY D14, AC1  |  NOP  |  NOP  }
;Reg[D14] = 0x283E_4000

{  NOP  |  SW D15, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0250] = 0x507C_8000, Reg[A0] = 0x0000_0254

{  NOP  |  SW D14, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0254] = 0x283E_4000, Reg[A0] = 0x0000_0258
;--------------------------------------------------------------  FMACUU
{  NOP  |  NOP  |  (P14) FMACUU AC0, D0, D1  |  NOP  |  NOP  }
;Reg[AC0] = (0x00_05E8_857F + 0x00_507C_8000) = 0x00_5665_057F

{  NOP  |  NOP  |  (P15) FMACUU AC0, D1, D1  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  COPY D15, AC0  |  NOP  |  NOP  }
;Reg[D15] = 0x5665_057F

{  NOP  |  SW D15, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0258] = 0x5665_057F, Reg[A0] = 0x0000_025C
;--------------------------------------------------------------  FMACUU.D
{  NOP  |  NOP  |  (P14) FMACUU.D AC0, D0, D1  |  NOP  |  NOP  }
;Reg[AC0] = (0x00_05E8_857F + 0x00_5665_057F) = 0x00_5C4D_8AFE
;Reg[AC1] = (0x00_05E8_857F + 0x00_283E_4000) = 0x00_2E26_C57F

{  NOP  |  NOP  |  (P15) FMACUU.D AC0, D1, D1  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  COPY D15, AC0  |  NOP  |  NOP  }
;Reg[D15] = 0x5C4D_8AFE

{  NOP  |  NOP  |  COPY D14, AC1  |  NOP  |  NOP  }
;Reg[D14] = 0x2E26_C57F

{  NOP  |  SW D15, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_025C] = 0x5C4D_8AFE, Reg[A0] = 0x0000_0260

{  NOP  |  SW D14, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0260] = 0x2E26_C57F, Reg[A0] = 0x0000_0244                    <============ ponpon
;--------------------------------------------------------------  FMACUS
{  NOP  |  NOP  |  (P14) FMACUS AC0, D0, D0  |  NOP  |  NOP  }
;Reg[AC0] = (0x00_006E_5501 + 0x00_5C4D_8AFE) = 0x00_5CBB_DFFF

{  NOP  |  NOP  |  (P15) FMACUS AC0, D1, D1  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  COPY D15, AC0  |  NOP  |  NOP  }
;Reg[D15] = 0x5CBB_DFFF

{  NOP  |  SW D15, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0264] = 0x5CBB_DFFF, Reg[A0] = 0x0000_0268
;--------------------------------------------------------------
{  NOP  |  NOP  |  (P14) FMACUS AC0, D0, D1  |  NOP  |  NOP  }
;Reg[AC0] = 0x00_FB67_857F + 0x00_5CBB_DFFF = 0x00_5823_657E

{  NOP  |  NOP  |  (P15) FMACUS AC0, D1, D1  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  COPY D15, AC0  |  NOP  |  NOP  }
;Reg[D15] = 0x5823_657E

{  NOP  |  SW D15, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0268] = 0x5823_657E, Reg[A0] = 0x0000_026C

;--------------------------------------------------------------  FMACUS.D
{  NOP  |  NOP  |  (P14) FMACUS.D AC0, D0, D0  |  NOP  |  NOP  }
;Reg[AC0] = 0x00_006E_5501 + 0x00_5823_657E = 0x00_5891_BA7F
;Reg[AC1] = 0x00_006E_5501 + 0x00_2E26_C57F = 0x00_2E95_1A80

{  NOP  |  NOP  |  (P15) FMACUS.D AC0, D1, D1  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  COPY D15, AC0  |  NOP  |  NOP  }
;Reg[D15] = 0x5891_BA7F

{  NOP  |  NOP  |  COPY D14, AC1  |  NOP  |  NOP  }
;Reg[D14] = 0x2E95_1A80

{  NOP  |  SW D15, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_026C] = 0x5891_BA7F, Reg[A0] = 0x0000_0270

{  NOP  |  SW D14, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0270] = 0x2E95_1A80, Reg[A0] = 0x0000_0274
;--------------------------------------------------------------
{  NOP  |  NOP  |  (P14) FMACUS.D AC0, D0, D1  |  NOP  |  NOP  }
;Reg[AC0] = 0x00_FB67_857F + 0x00_5891_BA7F = 0x00_53F9_3FFE
;Reg[AC1] = 0x00_FB67_857F + 0x00_2E95_1A80 = 0x00_29FC_9FFF

{  NOP  |  NOP  |  (P15) FMACUS.D AC0, D1, D1  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  COPY D15, AC0  |  NOP  |  NOP  }
;Reg[D15] = 0x53F9_3FFE

{  NOP  |  NOP  |  COPY D14, AC1  |  NOP  |  NOP  }
;Reg[D14] = 0x29FC_9FFF

{  NOP  |  SW D15, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0274] = 0x53F9_3FFE, Reg[A0] = 0x0000_0278

{  NOP  |  SW D14, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0278] = 0x29FC_9FFF, Reg[A0] = 0x0000_027C

;--------------------------------------------------------------  FMACSU
{  NOP  |  NOP  |  (P14) FMACSU AC0, D0, D1  |  NOP  |  NOP  }
;Reg[AC0] = 0x00_05E8_857F + 0x00_53F9_3FFE = 0x00_59E1_C57D

{  NOP  |  NOP  |  (P15) FMACSU AC0, D1, D1  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  COPY D15, AC0  |  NOP  |  NOP  }
;Reg[D15] = 0x59E1_C57D

{  NOP  |  SW D15, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_027C] = 0x59E1_C57D, Reg[A0] = 0x0000_0280

;--------------------------------------------------------------  FMACSU.D

{  NOP  |  NOP  |  (P14) FMACSU.D AC0, D0, D1  |  NOP  |  NOP  }
;Reg[AC0] = 0x00_05E8_857F + 0x00_59E1_C57D = 0x00_5FCA_4AFC
;Reg[AC1] = 0x00_05E8_857F + 0x00_29FC_9FFF = 0x00_2FE5_257E

{  NOP  |  NOP  |  (P15) FMACSU.D AC0, D1, D1  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  COPY D15, AC0  |  NOP  |  NOP  }
;Reg[D15] = 0x5FCA_4AFC

{  NOP  |  NOP  |  COPY D14, AC1  |  NOP  |  NOP  }
;Reg[D14] = 0x2FE5_257E

{  NOP  |  SW D15, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0280] = 0x5FCA_4AFC, Reg[A0] = 0x0000_0284

{  NOP  |  SW D14, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0284] = 0x2FE5_257E, Reg[A0] = 0x0000_0288

;--------------------------------------------------------------
;************************************************************** MAC.D, MSU.D
{  NOP  |  NOP  |  MOVI.L AC0, 0x0000  |  NOP  |  NOP  }
;Reg[AC0] = 0x00_0000_0000 

{  NOP  |  NOP  |  MOVIU.H AC0, 0x0000  |  NOP  |  NOP  }
;Reg[AC0] = 0x00_0000_0000

{  NOP  |  NOP  |  MOVI.L AC1, 0x0000  |  NOP  |  NOP  }
;Reg[AC0] = 0x00_0000_0000 

{  NOP  |  NOP  |  MOVIU.H AC1, 0x0000  |  NOP  |  NOP  }
;Reg[AC1] = 0x00_0000_0000

{  NOP  |  NOP  |  MOVI.L D0, 0x0A81  |  NOP  |  NOP  }
;Reg[D0] = 0x0A81_0A81 

{  NOP  |  NOP  |  MOVI.H D0, 0x0A81  |  NOP  |  NOP  }
;Reg[D0] = 0x0A81_0A81 

{  NOP  |  NOP  |  MOVI.L D1, 0x8FFF  |  NOP  |  NOP  }
;Reg[D1] = 0x7FFF_8FFF

{  NOP  |  NOP  |  MOVI.H D1, 0x8FFF  |  NOP  |  NOP  }
;Reg[D1] = 0x8FFF_8FFF

;--------------------------------------------------------------  MAC.D without saturation
{  NOP  |  NOP  |  (P14) MAC.D AC0, D0, D0  |  NOP  |  NOP  }
;Reg[AC0].L = 0x5501 + 0x0000 = 0x5501
;Reg[AC0].H = 0x5501 + 0x0000 = 0x5501
;Reg[AC0] = 0x00_5501_5501

{  NOP  |  NOP  |  (P15) MAC.D AC0, D1, D1  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  COPY D15, AC0  |  NOP  |  NOP  }
;Reg[D15] = 0x5501_5501

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D6, AU_PSR  |  NOP  |  NOP  }
;Reg[D6] = 0x0000_0000

{  NOP  |  SW D15, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0288] = 0x5501_5501, Reg[A0] = 0x0000_028C

{  NOP  |  SW D6, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_028C] = 0x0000_0001, Reg[A0] = 0x0000_0290              <===================== ponpon
;--------------------------------------------------------------
{  NOP  |  NOP  |  (P14) MAC.D AC0, D0, D1  |  NOP  |  NOP  }
;Reg[AC0].L = 0x857F + 0x5501 = 0xDA80
;Reg[AC0].H = 0x857F + 0x5501 = 0xDA80
;Reg[AC0] = 0xFF_DA80_DA80

{  NOP  |  NOP  |  (P15) MAC.D AC0, D1, D1  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  COPY D15, AC0  |  NOP  |  NOP  }
;Reg[D15] = 0xDA80_DA80

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D6, AU_PSR  |  NOP  |  NOP  }
;Reg[D6] = 0x0000_0000

{  NOP  |  SW D15, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0290] = 0xDA80_DA80, Reg[A0] = 0x0000_0294

{  NOP  |  SW D6, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0294] = 0x0000_0000, Reg[A0] = 0x0000_0298
;--------------------------------------------------------------		with overflow
{  NOP  |  NOP  |  (P14) MAC.D AC0, D1, D0  |  NOP  |  NOP  }
;Reg[AC0].L = 0x857F + 0xDA80 = 0x5FFF
;Reg[AC0].H = 0x857F + 0xDA80 = 0x5FFF
;Reg[AC0] = 0x00_5FFF_5FFF

{  NOP  |  NOP  |  (P15) MAC.D AC0, D1, D1  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D6, AU_PSR  |  NOP  |  NOP  }
;Reg[D6] = 0x0000_0001

{  NOP  |  NOP  |  COPY D15, AC0  |  NOP  |  NOP  }
;Reg[D15] = 0x5FFF_5FFF

{  NOP  |  SW D15, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0298] = 0x5FFF_5FFF, Reg[A0] = 0x0000_029C

{  NOP  |  SW D6, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_029C] = 0x0000_0001, Reg[A0] = 0x0000_02A0
;--------------------------------------------------------------
{  NOP  |  NOP  |  (P14) MAC.D AC0, D1, D1  |  NOP  |  NOP  }
;Reg[AC0].L = 0xE001 + 0x5FFF = 0x4000
;Reg[AC0].H = 0xE001 + 0x5FFF = 0x4000
;Reg[AC0] = 0x00_4000_4000

{  NOP  |  NOP  |  (P15) MAC.D AC0, D0, D0  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D6, AU_PSR  |  NOP  |  NOP  }
;Reg[D6] = 0x0000_0000

{  NOP  |  NOP  |  COPY D15, AC0  |  NOP  |  NOP  }
;Reg[D15] = 0x4000_4000

{  NOP  |  SW D15, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_02A0] = 0x4000_4000, Reg[A0] = 0x0000_02A4

{  NOP  |  SW D6, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_02A4] = 0x0000_0001, Reg[A0] = 0x0000_02A8           <=============== ponpon

;--------------------------------------------------------------  MSU.D without saturation

{  NOP  |  NOP  |  (P14) MSU.D AC0, D1, D1  |  NOP  |  NOP  }
;Reg[AC0].L = 0x4000 - 0xE001 = 0x5FFF
;Reg[AC0].H = 0x4000 - 0xE001 = 0x5FFF
;Reg[AC0] = 0x00_5FFF_5FFF

{  NOP  |  NOP  |  (P15) MSU.D AC0, D0, D0  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D6, AU_PSR  |  NOP  |  NOP  }
;Reg[D6] = 0x0000_0000

{  NOP  |  NOP  |  COPY D15, AC0  |  NOP  |  NOP  }
;Reg[D15] = 0x5FFF_5FFF

{  NOP  |  SW D15, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_02A8] = 0x5FFF_5FFF, Reg[A0] = 0x0000_02AC

{  NOP  |  SW D6, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_02AC] = 0x0000_0000, Reg[A0] = 0x0000_02B0           <================= ponpon

;--------------------------------------------------------------		with overflow
{  NOP  |  NOP  |  (P14) MSU.D AC0, D1, D0  |  NOP  |  NOP  }
;Reg[AC0].L = 0x5FFF - 0x857F = 0xDA80
;Reg[AC0].H = 0x5FFF - 0x857F = 0xDA80
;Reg[AC0] = 0xFF_DA80_DA80

{  NOP  |  NOP  |  (P15) MSU.D AC0, D1, D1  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D6, AU_PSR  |  NOP  |  NOP  }
;Reg[D6] = 0x0000_0001

{  NOP  |  NOP  |  COPY D15, AC0  |  NOP  |  NOP  }
;Reg[D15] = 0xDA80_DA80

{  NOP  |  SW D15, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_02B0] = 0xDA80_DA80, Reg[A0] = 0x0000_02B4

{  NOP  |  SW D6, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_02B4] = 0x0000_0001, Reg[A0] = 0x0000_02B8
;--------------------------------------------------------------

{  NOP  |  NOP  |  (P14) MSU.D AC0, D0, D1  |  NOP  |  NOP  }
;Reg[AC0].L = 0xDA80 - 0x857F = 0x5501
;Reg[AC0].H = 0xDA80 + 0x857F = 0x5501
;Reg[AC0] = 0x00_5501_5501

{  NOP  |  NOP  |  (P15) MSU.D AC0, D1, D1  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  COPY D15, AC0  |  NOP  |  NOP  }
;Reg[D15] = 0xDA80_DA80

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D6, AU_PSR  |  NOP  |  NOP  }
;Reg[D6] = 0x0000_0000

{  NOP  |  SW D15, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_02B8] = 0x5501_5501, Reg[A0] = 0x0000_02BC      <=============== ponpon

{  NOP  |  SW D6, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_02BC] = 0x0000_0000, Reg[A0] = 0x0000_02C0

;--------------------------------------------------------------
{  NOP  |  NOP  |  (P14) MSU.D AC0, D0, D0  |  NOP  |  NOP  }
;Reg[AC0].L = 0x5501 - 0x5501 = 0x0000
;Reg[AC0].H = 0x5501 - 0x5501 = 0x0000
;Reg[AC0] = 0x00_0000_0000

{  NOP  |  NOP  |  (P15) MSU.D AC0, D1, D1  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  COPY D15, AC0  |  NOP  |  NOP  }
;Reg[D15] = 0x0000_0000

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D6, AU_PSR  |  NOP  |  NOP  }
;Reg[D6] = 0x0000_0000

{  NOP  |  SW D15, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_02C0] = 0x0000_0000, Reg[A0] = 0x0000_02C4

{  NOP  |  SW D6, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_02C4] = 0x0000_0001, Reg[A0] = 0x0000_02C8       <=============== ponpon

;--------------------------------------------------------------  MAC.D with accumulator saturation
{  NOP  |  NOP  |  MOVIU AU_PSR, 0x40  |  NOP  |  NOP  }
;SATAcc = 1															<===============update for PACv3.1 

{  NOP  |  NOP  |  (P14) MAC.D AC0, D0, D0  |  NOP  |  NOP  }
;Reg[AC0].L = 0x5501 + 0x0000 = 0x5501
;Reg[AC0].H = 0x5501 + 0x0000 = 0x5501
;Reg[AC0] = 0x00_5501_5501

{  NOP  |  NOP  |  (P15) MAC.D AC0, D1, D1  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  COPY D15, AC0  |  NOP  |  NOP  }
;Reg[D15] = 0x5501_5501

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D6, AU_PSR  |  NOP  |  NOP  }
;Reg[D6] = 0x0000_0040

{  NOP  |  SW D15, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_02C8] = 0x5501_5501, Reg[A0] = 0x0000_02CC

{  NOP  |  SW D6, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_02CC] = 0x0000_0041, Reg[A0] = 0x0000_02D0           <=============== ponpon
;--------------------------------------------------------------
{  NOP  |  NOP  |  (P14) MAC.D AC0, D0, D1  |  NOP  |  NOP  }
;Reg[AC0].L = 0x857F + 0x5501 = 0xDA80
;Reg[AC0].H = 0x857F + 0x5501 = 0xDA80
;Reg[AC0] = 0xFF_DA80_DA80

{  NOP  |  NOP  |  (P15) MAC.D AC0, D1, D1  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  COPY D15, AC0  |  NOP  |  NOP  }
;Reg[D15] = 0xDA80_DA80

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D6, AU_PSR  |  NOP  |  NOP  }
;Reg[D6] = 0x0000_0040

{  NOP  |  SW D15, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_02D0] = 0xDA80_DA80, Reg[A0] = 0x0000_02D4

{  NOP  |  SW D6, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_02D4] = 0x0000_0040, Reg[A0] = 0x0000_02D8
;--------------------------------------------------------------		with saturation
{  NOP  |  NOP  |  (P14) MAC.D AC0, D1, D0  |  NOP  |  NOP  }
;Reg[AC0].L = 0x857F + 0xDA80 = 0x8000
;Reg[AC0].H = 0x857F + 0xDA80 = 0x8000
;Reg[AC0] = 0x00_8000_8000

{  NOP  |  NOP  |  (P15) MAC.D AC0, D1, D1  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D6, AU_PSR  |  NOP  |  NOP  }
;Reg[D6] = 0x0000_0040

{  NOP  |  NOP  |  COPY D15, AC0  |  NOP  |  NOP  }
;Reg[D15] = 0x5FFF_5FFF

{  NOP  |  SW D15, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_02D8] = 0x8000_8000, Reg[A0] = 0x0000_02DC         <=========== ponpon

{  NOP  |  SW D6, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_02DC] = 0x0000_0041, Reg[A0] = 0x0000_02E0         <=========== jeremy
;--------------------------------------------------------------		with saturation
{  NOP  |  NOP  |  (P14) MAC.D AC0, D1, D1  |  NOP  |  NOP  }
;Reg[AC0].L = 0xE001 + 0x8000 = 0x8000
;Reg[AC0].H = 0xE001 + 0x8000 = 0x8000
;Reg[AC0] = 0x00_8000_8000

{  NOP  |  NOP  |  (P15) MAC.D AC0, D0, D0  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D6, AU_PSR  |  NOP  |  NOP  }
;Reg[D6] = 0x0000_0040

{  NOP  |  NOP  |  COPY D15, AC0  |  NOP  |  NOP  }
;Reg[D15] = 0x8000_8000

{  NOP  |  SW D15, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_02E0] = 0x8000_8000, Reg[A0] = 0x0000_02E4

{  NOP  |  SW D6, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_02E4] = 0x0000_0041, Reg[A0] = 0x0000_02E8           <============ ponpon

;--------------------------------------------------------------  MSU.D with accumulator saturation
{  NOP  |  NOP  |  (P14) MSU.D AC0, D1, D1  |  NOP  |  NOP  }
;Reg[AC0].L = 0x8000 - 0xE001 = 0x9FFF
;Reg[AC0].H = 0x8000 - 0xE001 = 0x9FFF
;Reg[AC0] = 0xFF_9FFF_9FFF

{  NOP  |  NOP  |  (P15) MSU.D AC0, D0, D0  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D6, AU_PSR  |  NOP  |  NOP  }
;Reg[D6] = 0x0000_0040

{  NOP  |  NOP  |  COPY D15, AC0  |  NOP  |  NOP  }
;Reg[D15] = 0x9FFF_9FFF

{  NOP  |  SW D15, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_02E8] = 0x9FFF_9FFF, Reg[A0] = 0x0000_02EC

{  NOP  |  SW D6, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_02EC] = 0x0000_0041, Reg[A0] = 0x0000_02F0          <=============== ponpon
;--------------------------------------------------------------
{  NOP  |  NOP  |  (P14) MSU.D AC0, D1, D0  |  NOP  |  NOP  }
;Reg[AC0].L = 0x9FFF - 0x857F = 0x1A80
;Reg[AC0].H = 0x9FFF - 0x857F = 0x1A80
;Reg[AC0] = 0x00_1A80_1A80

{  NOP  |  NOP  |  (P15) MSU.D AC0, D1, D1  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D6, AU_PSR  |  NOP  |  NOP  }
;Reg[D6] = 0x0000_0040

{  NOP  |  NOP  |  COPY D15, AC0  |  NOP  |  NOP  }
;Reg[D15] = 0x1A80_1A80

{  NOP  |  SW D15, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_02F0] = 0x1A80_1A80, Reg[A0] = 0x0000_02F4

{  NOP  |  SW D6, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_02F4] = 0x0000_0040, Reg[A0] = 0x0000_02F8
;--------------------------------------------------------------		with saturation
{  NOP  |  NOP  |  (P14) MSU.D AC0, D0, D1  |  NOP  |  NOP  }
;Reg[AC0].L = 0x1A80 - 0x857F = 0x7FFF
;Reg[AC0].H = 0x1A80 - 0x857F = 0x7FFF
;Reg[AC0] = 0x00_7FFF_7FFF

{  NOP  |  NOP  |  (P15) MSU.D AC0, D1, D1  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  COPY D15, AC0  |  NOP  |  NOP  }
;Reg[D15] = 0x7FFF_7FFF

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D6, AU_PSR  |  NOP  |  NOP  }
;Reg[D6] = 0x0000_0040

{  NOP  |  SW D15, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_02F8] = 0x7FFF_7FFF, Reg[A0] = 0x0000_02FC

{  NOP  |  SW D6, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_02FC] = 0x0000_0041, Reg[A0] = 0x0000_0300     <=======jeremy
;--------------------------------------------------------------
{  NOP  |  NOP  |  (P14) MSU.D AC0, D0, D0  |  NOP  |  NOP  }
;Reg[AC0].L = 0x7FFF - 0x5501 = 0x2AFE
;Reg[AC0].H = 0x7FFF - 0x5501 = 0x2AFE
;Reg[AC0] = 0x00_2AFE_2AFE

{  NOP  |  NOP  |  (P15) MSU.D AC0, D1, D1  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  COPY D15, AC0  |  NOP  |  NOP  }
;Reg[D15] = 0x2AFE_2AFE

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D6, AU_PSR  |  NOP  |  NOP  }
;Reg[D6] = 0x0000_0040

{  NOP  |  SW D15, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0300] = 0x2AFE_2AFE, Reg[A0] = 0x0000_0304

{  NOP  |  SW D6, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0304] = 0x0000_0041, Reg[A0] = 0x0000_0308          <=========== ponpon

{  NOP  |  NOP  |  MOVIU AU_PSR, 0x0  |  NOP  |  NOP  }
;SATAcc = 0

;************************************************************** XFMAC.(D)
{  NOP  |  NOP  |  MOVI.L AC0, 0x0000  |  NOP  |  NOP  }
;Reg[AC0] = 0x00_2AFE_0000 

{  NOP  |  NOP  |  MOVIU.H AC0, 0x0000  |  NOP  |  NOP  }
;Reg[AC0] = 0x00_0000_0000

{  NOP  |  NOP  |  MOVI.L AC1, 0x0000  |  NOP  |  NOP  }
;Reg[AC1] = 0x00_0000_0000 

{  NOP  |  NOP  |  MOVIU.H AC1, 0x0000  |  NOP  |  NOP  }
;Reg[AC1] = 0x00_0000_0000

;--------------------------------------------------------------  XFMAC
{  NOP  |  NOP  |  (P14) XFMAC AC0, D0, D0  |  NOP  |  NOP  }
;Reg[AC0] = (0x00_00DC_AA02 + 0x00_0000_0000) = 0x00_00DC_AA02				0x00DC_AA02 ******************* Sam

{  NOP  |  NOP  |  (P15) XFMAC AC0, D1, D1  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D15, AC0  |  NOP  |  NOP  }
;Reg[D15] = 0x00DC_AA02

{  NOP  |  SW D15, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0308] = 0x00DC_AA02, Reg[A0] = 0x0000_030C					modified
;--------------------------------------------------------------
{  NOP  |  NOP  |  (P14) XFMAC AC0, D0, D1  |  NOP  |  NOP  }
;Reg[AC0] = (0x00_F6CF_0AFE + 0x00_00DC_AA02) = 0xFF_F7AB_B500

{  NOP  |  NOP  |  (P15) XFMAC AC0, D1, D1  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D15, AC0  |  NOP  |  NOP  }
;Reg[D15] = 0xF7AB_B500

{  NOP  |  SW D15, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_030C] = 0xF7AB_B500, Reg[A0] = 0x0000_0310					modified
;--------------------------------------------------------------
{  NOP  |  NOP  |  (P14) XFMAC AC0, D1, D0  |  NOP  |  NOP  }
;Reg[AC0] = (0x00_F6CF_0AFE + 0x00_F7AB_B500) = 0xFF_EE7A_BFFE

{  NOP  |  NOP  |  (P15) XFMAC AC0, D1, D1  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D15, AC0  |  NOP  |  NOP  }
;Reg[D15] = 0xEE7A_BFFE

{  NOP  |  SW D15, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0310] = 0xEE7A_BFFE, Reg[A0] = 0x0000_0314					modified
;--------------------------------------------------------------
{  NOP  |  NOP  |  (P14) XFMAC AC0, D1, D1  |  NOP  |  NOP  }
;Reg[AC2] = (0x00_6201_C002 + 0xFF_EE7A_BFFE) = 0x00_507C_8000

{  NOP  |  NOP  |  (P15) XFMAC AC0, D0, D0  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D15, AC0  |  NOP  |  NOP  }
;Reg[D15] = 0x507C_8000

{  NOP  |  SW D15, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0314] = 0x507C_8000, Reg[A0] = 0x0000_0318					modified
;--------------------------------------------------------------  XFMAC.D
{  NOP  |  NOP  |  (P14) XFMAC.D AC0, D0, D0  |  NOP  |  NOP  }
;Reg[AC0] = (0x00_00DC_AA02 + 0x00_507C_8000) = 0x00_5159_2A02
;Reg[AC1] = (0x00_00DC_AA02 + 0x00_0000_0000) = 0x00_00DC_AA02

{  NOP  |  NOP  |  (P15) XFMAC.D AC0, D1, D1  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D15, AC0  |  NOP  |  NOP  }
;Reg[D15] = 0x5159_2A02

{  NOP  |  NOP  |  COPY D14, AC1  |  NOP  |  NOP  }
;Reg[D14] = 0x00DC_AA02

{  NOP  |  SW D15, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0318] = 0x5159_2A02, Reg[A0] = 0x0000_031C					modified

{  NOP  |  SW D14, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_031C] = 0x00DC_AA02, Reg[A0] = 0x0000_0320					modified
;--------------------------------------------------------------
{  NOP  |  NOP  |  (P14) XFMAC.D AC0, D0, D1  |  NOP  |  NOP  }
;Reg[AC0] = (0x00_F6CF_0AFE + 0x00_5159_2A02) = 0x00_4828_3500
;Reg[AC1] = (0x00_F6CF_0AFE + 0x00_00DC_AA02) = 0xFF_F7AB_B500

{  NOP  |  NOP  |  (P15) XFMAC.D AC0, D1, D1  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D15, AC0  |  NOP  |  NOP  }
;Reg[D15] = 0x4828_3500

{  NOP  |  NOP  |  COPY D14, AC1  |  NOP  |  NOP  }
;Reg[D14] = 0xF7AB_B500

{  NOP  |  SW D15, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0320] = 0x4828_3500, Reg[A0] = 0x0000_0324					modified

{  NOP  |  SW D14, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0324] = 0xF7AB_B500, Reg[A0] = 0x0000_0328					modified
;--------------------------------------------------------------
{  NOP  |  NOP  |  (P14) XFMAC.D AC0, D1, D0  |  NOP  |  NOP  }
;Reg[AC0] = (0x00_F6CF_0AFE + 0x00_4828_3500) = 0x00_3EF7_3FFE
;Reg[AC1] = (0x00_F6CF_0AFE + 0xFF_F7AB_B500) = 0xFF_EE7A_BFFE

{  NOP  |  NOP  |  (P15) XFMAC.D AC0, D1, D1  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D15, AC0  |  NOP  |  NOP  }
;Reg[D15] = 0x3EF7_3FFE

{  NOP  |  NOP  |  COPY D14, AC1  |  NOP  |  NOP  }
;Reg[D14] = 0xEE7A_BFFE

{  NOP  |  SW D15, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0328] = 0x3EF7_3FFE, Reg[A0] = 0x0000_032C					modified

{  NOP  |  SW D14, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_032C] = 0xEE7A_BFFE, Reg[A0] = 0x0000_0330					modified
;--------------------------------------------------------------
{  NOP  |  NOP  |  (P14) XFMAC.D AC0, D1, D1  |  NOP  |  NOP  }
;Reg[AC0] = (0x00_6201_C002 + 0x00_3EF7_3FFE) = 0xFF_A0F9_0000
;Reg[AC1] = (0x00_6201_C002 + 0xFF_EE7A_BFFE) = 0x00_507C_8000

{  NOP  |  NOP  |  (P15) XFMAC.D AC0, D0, D0  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D15, AC0  |  NOP  |  NOP  }
;Reg[D15] = 0xA0F9_0000

{  NOP  |  NOP  |  COPY D14, AC1  |  NOP  |  NOP  }
;Reg[D14] = 0x507C_8000

{  NOP  |  SW D15, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0330] = 0xA0F9_0000, Reg[A0] = 0x0000_0334					modified

{  NOP  |  SW D14, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0334] = 0x507C_8000, Reg[A0] = 0x0000_0338					modified

;************************************************************** XMAC.D, XMSU.D
{  NOP  |  NOP  |  MOVI.L D0, 0x5A81  |  NOP  |  NOP  }
;Reg[D0] = 0x0A81_5A81 

{  NOP  |  NOP  |  MOVI.H D0, 0x5A81  |  NOP  |  NOP  }
;Reg[D0] = 0x5A81_5A81 

{  NOP  |  NOP  |  MOVI.L AC0, 0x0000  |  NOP  |  NOP  }
;Reg[AC0] = 0x00_0000_0000 

{  NOP  |  NOP  |  MOVIU.H AC0, 0x0000  |  NOP  |  NOP  }
;Reg[AC0] = 0x00_0000_0000
;--------------------------------------------------------------  XMAC.D without saturation
{  NOP  |  NOP  |  (P14) XMAC.D AC0, D0, D0  |  NOP  |  NOP  }
;Reg[AC0].L = 0x3FFD + 0x0000 = 0x3FFD
;Reg[AC0].H = 0x3FFD + 0x0000 = 0x3FFD
;Reg[AC0] = 0x00_3FFD_3FFD

{  NOP  |  NOP  |  (P15) XMAC.D AC0, D1, D1  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D15, AC0  |  NOP  |  NOP  }
;Reg[D15] = 0x3FFD_3FFD

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D6, AU_PSR  |  NOP  |  NOP  }
;Reg[D6] = 0x0000_0000

{  NOP  |  SW D15, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0338] = 0x3FFD_3FFD, Reg[A0] = 0x0000_033C

{  NOP  |  SW D6, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_033C] = 0x0000_0000, Reg[A0] = 0x0000_0340
;--------------------------------------------------------------		with overflow
{  NOP  |  NOP  |  (P14) XMAC.D AC0, D1, D1  |  NOP  |  NOP  }
;Reg[AC0].L = 0x6201 + 0x3FFD = 0xA1FE
;Reg[AC0].H = 0x6201 + 0x3FFD = 0xA1FE
;Reg[AC0] = 0x00_A1FE_A1FE

{  NOP  |  NOP  |  (P15) XMAC.D AC0, D0, D0  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D6, AU_PSR  |  NOP  |  NOP  }
;Reg[D6] = 0x0000_0001

{  NOP  |  NOP  |  COPY D15, AC0  |  NOP  |  NOP  }
;Reg[D15] = 0xA1FE_A1FE

{  NOP  |  SW D15, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0340] = 0xA1FE_A1FE, Reg[A0] = 0x0000_0344

{  NOP  |  SW D6, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0344] = 0x0000_0001, Reg[A0] = 0x0000_0348
;--------------------------------------------------------------		with overflow
{  NOP  |  NOP  |  (P14) XMAC.D AC0, D0, D1  |  NOP  |  NOP  }
;Reg[AC0].L = 0xB0CE + 0xA1FE = 0x52CC
;Reg[AC0].H = 0xB0CE + 0xA1FE = 0x52CC
;Reg[AC0] = 0x00_52CC_52CC

{  NOP  |  NOP  |  (P15) XMAC.D AC0, D1, D1  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  COPY D15, AC0  |  NOP  |  NOP  }
;Reg[D15] = 0x52CC_52CC

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D6, AU_PSR  |  NOP  |  NOP  }
;Reg[D6] = 0x0000_0001

{  NOP  |  SW D15, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0348] = 0x52CC_52CC, Reg[A0] = 0x0000_034C

{  NOP  |  SW D6, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_034C] = 0x0000_0001, Reg[A0] = 0x0000_0350
;--------------------------------------------------------------
{  NOP  |  NOP  |  (P14) XMAC.D AC0, D1, D0  |  NOP  |  NOP  }
;Reg[AC0].L = 0xB0CE + 0x52CC = 0x039A
;Reg[AC0].H = 0xB0CE + 0x52CC = 0x039A
;Reg[AC0] = 0x00_039A_039A

{  NOP  |  NOP  |  (P15) XMAC.D AC0, D1, D1  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D6, AU_PSR  |  NOP  |  NOP  }
;Reg[D6] = 0x0000_0000

{  NOP  |  NOP  |  COPY D15, AC0  |  NOP  |  NOP  }
;Reg[D15] = 0x039A_039A

{  NOP  |  SW D15, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0350] = 0x039A_039A, Reg[A0] = 0x0000_0354

{  NOP  |  SW D6, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0354] = 0x0000_0000, Reg[A0] = 0x0000_0358

;--------------------------------------------------------------  XMSU.D without saturation

{  NOP  |  NOP  |  (P14) XMSU.D AC0, D1, D0  |  NOP  |  NOP  }
;Reg[AC0].L = 0x039A - 0xB0CE = 0x52CC
;Reg[AC0].H = 0x039A - 0xB0CE = 0x52CC
;Reg[AC0] = 0x00_52CC_52CC

{  NOP  |  NOP  |  (P15) XMSU.D AC0, D1, D1  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D6, AU_PSR  |  NOP  |  NOP  }
;Reg[D6] = 0x0000_0000

{  NOP  |  NOP  |  COPY D15, AC0  |  NOP  |  NOP  }
;Reg[D15] = 0x52CC_52CC

{  NOP  |  SW D15, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0358] = 0x52CC_52CC, Reg[A0] = 0x0000_035C

{  NOP  |  SW D6, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_035C] = 0x0000_0000, Reg[A0] = 0x0000_0360

;--------------------------------------------------------------		with overflow
{  NOP  |  NOP  |  (P14) XMSU.D AC0, D0, D1  |  NOP  |  NOP  }
;Reg[AC0].L = 0x52CC - 0xB0CE = 0xA1FE
;Reg[AC0].H = 0x52CC - 0xB0CE = 0xA1FE
;Reg[AC0] = 0xFF_A1FE_A1FE

{  NOP  |  NOP  |  (P15) XMSU.D AC0, D1, D1  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D6, AU_PSR  |  NOP  |  NOP  }
;Reg[D6] = 0x0000_0001

{  NOP  |  NOP  |  COPY D15, AC0  |  NOP  |  NOP  }
;Reg[D15] = 0xA1FE_A1FE

{  NOP  |  SW D15, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0360] = 0xA1FE_A1FE, Reg[A0] = 0x0000_0364

{  NOP  |  SW D6, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0364] = 0x0000_0001, Reg[A0] = 0x0000_0368
;--------------------------------------------------------------		with overflow

{  NOP  |  NOP  |  (P14) XMSU.D AC0, D1, D1  |  NOP  |  NOP  }
;Reg[AC0].L = 0xA1FE - 0x6201 = 0x3FFD
;Reg[AC0].H = 0xA1FE - 0x6201 = 0x3FFD
;Reg[AC0] = 0x00_3FFD_3FFD

{  NOP  |  NOP  |  (P15) XMSU.D AC0, D1, D1  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  COPY D15, AC0  |  NOP  |  NOP  }
;Reg[D15] = 0x3FFD_3FFD

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D6, AU_PSR  |  NOP  |  NOP  }
;Reg[D6] = 0x0000_0001

{  NOP  |  SW D15, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0368] = 0x3FFD_3FFD, Reg[A0] = 0x0000_036C

{  NOP  |  SW D6, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_036C] = 0x0000_0001, Reg[A0] = 0x0000_0370

;--------------------------------------------------------------
{  NOP  |  NOP  |  (P14) XMSU.D AC0, D0, D0  |  NOP  |  NOP  }
;Reg[AC0].L = 0x3FFD - 0x3FFD = 0x0000
;Reg[AC0].H = 0x3FFD - 0x3FFD = 0x0000
;Reg[AC0] = 0x00_0000_0000

{  NOP  |  NOP  |  (P15) XMSU.D AC0, D1, D1  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  COPY D15, AC0  |  NOP  |  NOP  }
;Reg[D15] = 0x0000_0000

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D6, AU_PSR  |  NOP  |  NOP  }
;Reg[D6] = 0x0000_0000

{  NOP  |  SW D15, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0370] = 0x0000_0000, Reg[A0] = 0x0000_0374

{  NOP  |  SW D6, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0374] = 0x0000_0000, Reg[A0] = 0x0000_0378

;--------------------------------------------------------------  XMAC.D with accumulator saturation
{  NOP  |  NOP  |  MOVIU AU_PSR, 0x40  |  NOP  |  NOP  }
;SATAcc = 1																<===============update for PACv3.1 

{  NOP  |  NOP  |  (P14) XMAC.D AC0, D0, D0  |  NOP  |  NOP  }
;Reg[AC0].L = 0x3FFD + 0x0000 = 0x3FFD
;Reg[AC0].H = 0x3FFD + 0x0000 = 0x3FFD
;Reg[AC0] = 0x00_3FFD_3FFD

{  NOP  |  NOP  |  (P15) XMAC.D AC0, D1, D1  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  COPY D15, AC0  |  NOP  |  NOP  }
;Reg[D15] = 0x3FFD_3FFD

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D6, AU_PSR  |  NOP  |  NOP  }
;Reg[D6] = 0x0000_0040

{  NOP  |  SW D15, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0378] = 0x3FFD_3FFD, Reg[A0] = 0x0000_037C

{  NOP  |  SW D6, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_037C] = 0x0000_0040, Reg[A0] = 0x0000_0380
;--------------------------------------------------------------		with saturation
{  NOP  |  NOP  |  (P14) XMAC.D AC0, D1, D1  |  NOP  |  NOP  }
;Reg[AC0].L = 0x6201 + 0x3FFD = 0x7FFF
;Reg[AC0].H = 0x6201 + 0x3FFD = 0x7FFF
;Reg[AC0] = 0x00_7FFF_7FFF

{  NOP  |  NOP  |  (P15) XMAC.D AC0, D0, D0  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  COPY D15, AC0  |  NOP  |  NOP  }
;Reg[D15] = 0xFFF_7FFF

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D6, AU_PSR  |  NOP  |  NOP  }
;Reg[D6] = 0x0000_0040

{  NOP  |  SW D15, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0380] = 0x7FFF_7FFF, Reg[A0] = 0x0000_0384              <========== ponpon

{  NOP  |  SW D6, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0384] = 0x0000_0041, Reg[A0] = 0x0000_0388             <============ jeremy
;--------------------------------------------------------------
{  NOP  |  NOP  |  (P14) XMAC.D AC0, D0, D1  |  NOP  |  NOP  }
;Reg[AC0].L = 0xB0CE + 0x7FFF = 0x30CD
;Reg[AC0].H = 0xB0CE + 0x7FFF = 0x30CD
;Reg[AC0] = 0x00_30CD_30CD

{  NOP  |  NOP  |  (P15) XMAC.D AC0, D1, D1  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D6, AU_PSR  |  NOP  |  NOP  }
;Reg[D6] = 0x0000_0040

{  NOP  |  NOP  |  COPY D15, AC0  |  NOP  |  NOP  }
;Reg[D15] = 0x30CD_30CD

{  NOP  |  SW D15, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0388] = 0x30CD_30CD, Reg[A0] = 0x0000_038C

{  NOP  |  SW D6, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_038C] = 0x0000_0040, Reg[A0] = 0x0000_0390
;--------------------------------------------------------------
{  NOP  |  NOP  |  (P14) XMAC.D AC0, D1, D0  |  NOP  |  NOP  }
;Reg[AC0].L = 0xB0CE + 0x30CD = 0xE19B
;Reg[AC0].H = 0xB0CE + 0x30CD = 0xE19B
;Reg[AC0] = 0x00_E19B_E19B

{  NOP  |  NOP  |  (P15) XMAC.D AC0, D1, D1  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D6, AU_PSR  |  NOP  |  NOP  }
;Reg[D6] = 0x0000_0040

{  NOP  |  NOP  |  COPY D15, AC0  |  NOP  |  NOP  }
;Reg[D15] = 0xE19B_E19B

{  NOP  |  SW D15, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0390] = 0xE19B_E19B, Reg[A0] = 0x0000_0394

{  NOP  |  SW D6, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0394] = 0x0000_0040, Reg[A0] = 0x0000_0398

;--------------------------------------------------------------  XMSU.D with accumulator saturation
{  NOP  |  NOP  |  (P14) XMSU.D AC0, D1, D1  |  NOP  |  NOP  }
;Reg[AC0].L = 0xE19B - 0x6201 = 0x8000
;Reg[AC0].H = 0xE19B - 0x6201 = 0x8000
;Reg[AC0] = 0x00_8000_8000

{  NOP  |  NOP  |  (P15) XMSU.D AC0, D0, D0  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D6, AU_PSR  |  NOP  |  NOP  }
;Reg[D6] = 0x0000_0040

{  NOP  |  NOP  |  COPY D15, AC0  |  NOP  |  NOP  }
;Reg[D15] = 0x8000_8000

{  NOP  |  SW D15, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_0398] = 0x8000_8000, Reg[A0] = 0x0000_039C

{  NOP  |  SW D6, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_039C] = 0x0000_0041, Reg[A0] = 0x0000_03A0           <==========jeremy
;--------------------------------------------------------------		with saturation
{  NOP  |  NOP  |  (P14) XMSU.D AC0, D0, D0  |  NOP  |  NOP  }
;Reg[AC0].L = 0x8000 - 0x3FFD = 0x8000
;Reg[AC0].H = 0x8000 - 0x3FFD = 0x8000
;Reg[AC0] = 0x00_8000_8000

{  NOP  |  NOP  |  (P15) XMSU.D AC0, D1, D1  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D6, AU_PSR  |  NOP  |  NOP  }
;Reg[D6] = 0x0000_0040

{  NOP  |  NOP  |  COPY D15, AC0  |  NOP  |  NOP  }
;Reg[D15] = 0x8000_8000

{  NOP  |  SW D15, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_03A0] = 0x8000_8000, Reg[A0] = 0x0000_03A4

{  NOP  |  SW D6, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_03A4] = 0x0000_0041, Reg[A0] = 0x0000_03A8          <==============jeremy
;--------------------------------------------------------------
{  NOP  |  NOP  |  (P14) XMSU.D AC0, D0, D1  |  NOP  |  NOP  }
;Reg[AC0].L = 0x8000 - 0xB0CE = 0xCF32
;Reg[AC0].H = 0x8000 - 0xB0CE = 0xCF32
;Reg[AC0] = 0x00_CF32_CF32

{  NOP  |  NOP  |  (P15) XMSU.D AC0, D1, D1  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  COPY D15, AC0  |  NOP  |  NOP  }
;Reg[D15] = 0xCF32_CF32

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D6, AU_PSR  |  NOP  |  NOP  }
;Reg[D6] = 0x0000_0040

{  NOP  |  SW D15, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_03A8] = 0xCF32_CF32, Reg[A0] = 0x0000_03AC

{  NOP  |  SW D6, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_03AC] = 0x0000_0040, Reg[A0] = 0x0000_03B0
;--------------------------------------------------------------
{  NOP  |  NOP  |  (P14) XMSU.D AC0, D1, D0  |  NOP  |  NOP  }
;Reg[AC0].L = 0xCF32 - 0xB0CE = 0x1E64
;Reg[AC0].H = 0xCF32 - 0xB0CE = 0x1E64
;Reg[AC0] = 0x00_1E64_1E64

{  NOP  |  NOP  |  (P15) XMSU.D AC0, D1, D1  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  COPY D15, AC0  |  NOP  |  NOP  }
;Reg[D15] = 0x1E64_1E64

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D6, AU_PSR  |  NOP  |  NOP  }
;Reg[D6] = 0x0000_0040

{  NOP  |  SW D15, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_03B0] = 0x1E64_1E64, Reg[A0] = 0x0000_03B4

{  NOP  |  SW D6, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_03B4] = 0x0000_0040, Reg[A0] = 0x0000_03B8

{  NOP  |  NOP  |  MOVIU AU_PSR, 0x0  |  NOP  |  NOP  }
;SATAcc = 0


;************************************************************** DOTP2, XDOTP2 with predicate bit
{  NOP  |  NOP  |  MOVI.L D0, 0x0A81  |  NOP  |  NOP  }
;Reg[D0] = 0x0000_0A81 

{  NOP  |  NOP  |  MOVI.H D0, 0x0A81  |  NOP  |  NOP  }
;Reg[D0] = 0xFA81_FA81 

{  NOP  |  NOP  |  MOVI.L D1, 0x8FFF  |  NOP  |  NOP  }
;Reg[D1] = 0x0000_8FFF

{  NOP  |  NOP  |  MOVI.H D1, 0x8FFF  |  NOP  |  NOP  }
;Reg[D1] = 0x8FFF_8FFF

;--------------------------------------------------------------  DOTP2
{  NOP  |  NOP  |  (P14) DOTP2 D2, D0, D0  |  NOP  |  NOP  }
;Reg[D2] = 0x006E_5501 +  0x006E_5501 = 0x00DC_AA02

{  NOP  |  NOP  |  (P15) DOTP2 D2, D1, D1  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  (P14) DOTP2 D3, D0, D1  |  NOP  |  NOP  }
;Reg[D3] = 0xFB67_857F +  0xFB67_857F = 0xF6CF_0AFE

{  NOP  |  NOP  |  (P15) DOTP2 D3, D1, D1  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  (P14) DOTP2 D4, D1, D0  |  NOP  |  NOP  }
;Reg[D4] = 0xFB67_857F +  0xFB67_857F = 0xF6CF_0AFE

{  NOP  |  NOP  |  (P15) DOTP2 D4, D1, D1  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  (P14) DOTP2 D5, D1, D1  |  NOP  |  NOP  }
;Reg[D5] = 0x3100_E001 +  0x3100_E001 = 0x6201_C002

{  NOP  |  NOP  |  (P15) DOTP2 D5, D0, D0  |  NOP  |  NOP  }
;Not execute

;--------------------------------------------------------------  Store Result
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_03B8] = 0x00DC_AA02, Reg[A0] = 0x0000_03BC

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_03BC] = 0xF6CF_0AFE, Reg[A0] = 0x0000_03C0

{  NOP  |  SW D4, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_03C0] = 0xF6CF_0AFE, Reg[A0] = 0x0000_03C4

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_03C4] = 0x6201_C002, Reg[A0] = 0x0000_03C8

;--------------------------------------------------------------  XDOTP2
{  NOP  |  NOP  |  (P14) XDOTP2 D2, D0, D0  |  NOP  |  NOP  }
;Reg[D2] = 0x00DC_AA02 +  0x00DC_AA02 = 0x01B9_5404

{  NOP  |  NOP  |  (P15) XDOTP2 D2, D1, D1  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  (P14) XDOTP2 D3, D0, D1  |  NOP  |  NOP  }
;Reg[D3] = 0xF6CF_0AFE +  0xF6CF_0AFE = 0xED9E_15FC

{  NOP  |  NOP  |  (P15) XDOTP2 D3, D1, D1  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  (P14) XDOTP2 D4, D1, D0  |  NOP  |  NOP  }
;Reg[D4] = 0xF6CF_0AFE +  0xF6CF_0AFE = 0xED9E_15FC

{  NOP  |  NOP  |  (P15) XDOTP2 D4, D1, D1  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  (P14) XDOTP2 D5, D1, D1  |  NOP  |  NOP  }
;Reg[D5] = 0x6201_C002 +  0x6201_C002 = 0xC403_8004

{  NOP  |  NOP  |  (P15) XDOTP2 D5, D0, D0  |  NOP  |  NOP  }
;Not execute

;--------------------------------------------------------------  Store Result
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_03C8] = 0x01B9_5404, Reg[A0] = 0x0000_03CC

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_03CC] = 0xED9E_15FC, Reg[A0] = 0x0000_03D0

{  NOP  |  SW D4, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_03D0] = 0xED9E_15FC, Reg[A0] = 0x0000_03D4

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x0000_03D4] = 0xC403_8004, Reg[A0] = 0x0000_03D8



;************************************************************** Program Terminate
{  TRAP  |  NOP  |  NOP  |  NOP  |  NOP  }
