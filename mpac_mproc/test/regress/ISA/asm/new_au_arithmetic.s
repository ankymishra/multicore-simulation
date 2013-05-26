;************************************************************** Set Start Address

{  NOP  |  MOVI.L A0, 0x0000  |  MOVI AU_PSR, 0x0000000  |  NOP  |  NOP  }
;Reg[A0] = 0x0000_0000

{  NOP  |  MOVI.H A0, 0x2400  |  NOP  |  NOP  |  NOP  }
;Reg[A0] = 0x1207_0000, modify by JH

;/////////////////////////////////////// Flag & Function /////////////////////////////////////////////

;************************************************************** ADSR n/carry n/overflow
{  NOP  |  NOP  |  MOVI.L D0, 0xFFFF  |  NOP  |  NOP  }
;Reg[D0] = 0x0000_FFFF
;AU_PSR = 0x00

{  NOP  |  NOP  |  MOVI.H D0, 0x0000  |  NOP  |  NOP  }
;Reg[D0] = 0x0000_FFFF
;AU_PSR = 0x00

{  NOP  |  NOP  |  MOVI.L D1, 0x8000  |  NOP  |  NOP  }
;Reg[D1] = 0x0001_0000
;AU_PSR = 0x00

{  NOP  |  NOP  |  MOVI.H D1, 0x0000  |  NOP  |  NOP  }
;Reg[D1] = 0x0000_8000
;AU_PSR = 0x00

{  NOP  |  NOP  |  ADSR D0, D1, 0x10  |  NOP  |  NOP  }
;Reg[D2] = 0x0001
;AU_PSR = 0x00


{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D5, AU_PSR  |  NOP  |  NOP   }
;Reg[D5] = 0x0000_0000
;AU_PSR = 0x00

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D0, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0000] = 0x0001_7FFF, Reg[A0] = 0x1E00_0000

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0004] = 0x0000_0000, Reg[A0] = 0x1E00_0004





;************************************************************** ADSR n/carry w/overflow
{  NOP  |  NOP  |  MOVI.L D0, 0xFFFF  |  NOP  |  NOP  }
;Reg[D0] = 0x0000_FFFF
;AU_PSR = 0x00

{  NOP  |  NOP  |  MOVI.H D0, 0x7FFF  |  NOP  |  NOP  }
;Reg[D0] = 0x7FFF_FFFF
;AU_PSR = 0x00

{  NOP  |  NOP  |  MOVI.L D1, 0x0001  |  NOP  |  NOP  }
;Reg[D1] = 0x0000_0001
;AU_PSR = 0x00

{  NOP  |  NOP  |  MOVI.H D1, 0x0000  |  NOP  |  NOP  }
;Reg[D1] = 0x0000_0001
;AU_PSR = 0x00

{  NOP  |  NOP  |  ADSR D0, D1, 0x10  |  NOP  |  NOP  }
;Reg[D2] = 0x8000_0000
;AU_PSR = 0x01


{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D5, AU_PSR  |  NOP  |  NOP   }
;Reg[D5] = 0x0000_0001
;AU_PSR = 0x01

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D0, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0008] = 0x0001, Reg[A0] = 0x1E00_0008

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_000C] = 0x0000_0001, Reg[A0] = 0x1E00_000c






;************************************************************** ADSR w/carry n/overflow
{  NOP  |  NOP  |  MOVI.L D0, 0xFFFF  |  NOP  |  NOP  }
;Reg[D0] = 0x0000_FFFF
;AU_PSR = 0x00

{  NOP  |  NOP  |  MOVI.H D0, 0x7FFF  |  NOP  |  NOP  }
;Reg[D0] = 0x7FFF_FFFF
;AU_PSR = 0x00

{  NOP  |  NOP  |  MOVI.L D1, 0xFFFF  |  NOP  |  NOP  }
;Reg[D1] = 0x0001_0000
;AU_PSR = 0x00

{  NOP  |  NOP  |  MOVI.H D1, 0x8FFF  |  NOP  |  NOP  }
;Reg[D1] = 0x0000_0001
;AU_PSR = 0x00

{  NOP  |  NOP  |  ADSR D0, D1, 0x10  |  NOP  |  NOP  }
;Reg[D2] = 0xffff_0fff
;AU_PSR = 0x02


{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D5, AU_PSR  |  NOP  |  NOP   }
;Reg[D5] = 0x0000_0002
;AU_PSR = 0x02

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D0, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0010] = 0x0000_0FFF, Reg[A0] = 0x1E00_0010

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0014] = 0x0000_0000, Reg[A0] = 0x1E00_0014





;************************************************************** ADSR w/carry w/overflow
{  NOP  |  NOP  |  MOVI.L D0, 0x0000  |  NOP  |  NOP  }
;Reg[D0] = 0x7FFF_0000
;AU_PSR = 0x02

{  NOP  |  NOP  |  MOVI.H D0, 0x8000  |  NOP  |  NOP  }
;Reg[D0] = 0x8000_0000
;AU_PSR = 0x02

{  NOP  |  NOP  |  MOVI.L D1, 0x0000  |  NOP  |  NOP  }
;Reg[D1] = 0x8FFF_0000
;AU_PSR = 0x02

{  NOP  |  NOP  |  MOVI.H D1, 0x8000  |  NOP  |  NOP  }
;Reg[D1] = 0x8000_0000
;AU_PSR = 0x02

{  NOP  |  NOP  |  ADSR D0, D1, 0x10  |  NOP  |  NOP  }
;Reg[D2] = 0x0000_0000
;AU_PSR = 0x03


{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D5, AU_PSR  |  NOP  |  NOP   }
;Reg[D5] = 0x0000_0003
;AU_PSR = 0x03

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D0, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0018] = 0x0000_0000, Reg[A0] = 0x1E00_0018  

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_001c] = 0x0000_0003, Reg[A0] = 0x1E00_001c






;************************************************************** ADSR.D n/overflow
{  NOP  |  NOP  |  MOVI.L D0, 0x7FFF  |  NOP  |  NOP  }
;Reg[D0] = 0x2468_7FFF
;AU_PSR = 0x01

{  NOP  |  NOP  |  MOVI.H D0, 0x1234  |  NOP  |  NOP  }
;Reg[D0] = 0x1234_7FFF
;AU_PSR = 0x01

{  NOP  |  NOP  |  MOVI.L D1, 0x8FFF  |  NOP  |  NOP  }
;Reg[D1] = 0x8FFF_8FFF
;AU_PSR = 0x01

{  NOP  |  NOP  |  MOVI.H D1, 0x1234  |  NOP  |  NOP  }
;Reg[D1] = 0x1234_8FFF
;AU_PSR = 0x01

{  NOP  |  NOP  |  ADSR.D D0, D1, 0x3  |  NOP  |  NOP  }
;Reg[D2] = 0x2468_0FFE
;AU_PSR = 0x00


{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D5, AU_PSR  |  NOP  |  NOP   }
;Reg[D5] = 0x0000_0000
;AU_PSR = 0x00

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D0, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0020] = 0x2468_0FFE, Reg[A0] = 0x1E00_0020

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0024] = 0x0000_0000, Reg[A0] = 0x1E00_0024




;************************************************************** ADSR.D w/overflow
{  NOP  |  NOP  |  MOVI.L D0, 0x7FFF  |  NOP  |  NOP  }
;Reg[D0] = 0x1234_7FFF
;AU_PSR = 0x00

{  NOP  |  NOP  |  MOVI.H D0, 0x1234  |  NOP  |  NOP  }
;Reg[D0] = 0x1234_7FFF
;AU_PSR = 0x00

{  NOP  |  NOP  |  MOVI.L D1, 0x1000  |  NOP  |  NOP  }
;Reg[D1] = 0x1234_1000
;AU_PSR = 0x00

{  NOP  |  NOP  |  MOVI.H D1, 0x1234  |  NOP  |  NOP  }
;Reg[D1] = 0x1234_1000
;AU_PSR = 0x00

{  NOP  |  NOP  |  ADSR.D D0, D1, 0x3  |  NOP  |  NOP  }
;Reg[D2] = 0x2468_8FFF
;AU_PSR = 0x01


{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D5, AU_PSR  |  NOP  |  NOP   }
;Reg[D5] = 0x0000_0001
;AU_PSR = 0x01

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D0, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0028] = 0x2468_8FFF, Reg[A0] = 0x1E00_0028

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_002c] = 0x0000_0001, Reg[A0] = 0x1E00_002c





;************************************************************** Program Terminate
{  TRAP  |  NOP  |  NOP  |  NOP  |  NOP  }






