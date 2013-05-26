;************************************************************** Set Start Address

{  NOP  |  MOVI.L A0, 0x0000  |  MOVI AU_PSR, 0x0000000  |  NOP  |  NOP  }
;Reg[A0] = 0x0000_0000

{  NOP  |  MOVI.H A0, 0x2400  |  NOP  |  NOP  |  NOP  }
;Reg[A0] = 0x1207_0000, modify by JH

;/////////////////////////////////////// Flag & Function /////////////////////////////////////////////
;;===============================================AU=======================================================
;************************************************************** ADSRF n/carry n/overflow
{  NOP  |  NOP  |  MOVI.L D0, 0xFFFF  |  NOP  |  NOP  }
;Reg[D0] = 0x0000_FFFF
;AU_PSR = 0x00

{  NOP  |  NOP  |  MOVI.H D0, 0x0000  |  NOP  |  NOP  }
;Reg[D0] = 0x0000_FFFF
;AU_PSR = 0x00


{  NOP  |  NOP  |  ADSRF D0, 0x1  |  NOP  |  NOP  }
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



;************************************************************** ADSRF n/carry w/overflow
{  NOP  |  NOP  |  MOVI.L D0, 0xFFFF  |  NOP  |  NOP  }
;Reg[D0] = 0x0000_FFFF
;AU_PSR = 0x00

{  NOP  |  NOP  |  MOVI.H D0, 0x7FFF  |  NOP  |  NOP  }
;Reg[D0] = 0x0000_FFFF
;AU_PSR = 0x00


{  NOP  |  NOP  |  ADSRF D0, 0x1  |  NOP  |  NOP  }
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
;Mem[0x1E00_0008] = 0x, Reg[A0] = 0x1E00_0008

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_000c] = 0x, Reg[A0] = 0x1E00_000C


;************************************************************** ADSRF w/carry w/overflow
{  NOP  |  NOP  |  MOVI.L D0, 0x0000  |  NOP  |  NOP  }
;Reg[D0] = 0x0000_FFFF
;AU_PSR = 0x00

{  NOP  |  NOP  |  MOVI.H D0, 0x8000  |  NOP  |  NOP  }
;Reg[D0] = 0x0000_FFFF
;AU_PSR = 0x00


{  NOP  |  NOP  |  ADSRF D0, 0x20  |  NOP  |  NOP  }
;Reg[D2] = 0x0001
;AU_PSR = 0x00


{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D5, AU_PSR  |  NOP  |  NOP   }
;Reg[D5] = 0x0000_0000
;AU_PSR = 0x03

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D0, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0010] = 0x, Reg[A0] = 0x1E00_0010

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0014] = 0x3, Reg[A0] = 0x1E00_0014


;************************************************************** ADSRF.D n/overflow
{  NOP  |  NOP  |  MOVI.L D0, 0x7FFF  |  NOP  |  NOP  }
;Reg[D0] = 0x2468_7FFF
;AU_PSR = 0x01

{  NOP  |  NOP  |  MOVI.H D0, 0x1234  |  NOP  |  NOP  }
;Reg[D0] = 0x1234_7FFF
;AU_PSR = 0x01


{  NOP  |  NOP  |  ADSRF.D D0, 0x10  |  NOP  |  NOP  }
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
;Mem[0x1E00_0018] = 0x2468_0FFE, Reg[A0] = 0x1E00_0018

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_001C] = 0x0000_0000, Reg[A0] = 0x1E00_001C


;************************************************************** ADSRF.D w/overflow
{  NOP  |  NOP  |  MOVI.L D0, 0x7FFF  |  NOP  |  NOP  }
;Reg[D0] = 0x2468_7FFF
;AU_PSR = 0x01

{  NOP  |  NOP  |  MOVI.H D0, 0x1234  |  NOP  |  NOP  }
;Reg[D0] = 0x1234_7FFF
;AU_PSR = 0x01


{  NOP  |  NOP  |  ADSRF.D D0, 0xD  |  NOP  |  NOP  }
;Reg[D2] = 0x2468_0FFE
;AU_PSR = 0x00


{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D5, AU_PSR  |  NOP  |  NOP   }
;Reg[D5] = 0x0000_0000
;AU_PSR = 0x01

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D0, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0020] = 0x2468_0FFE, Reg[A0] = 0x1E00_0020

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0024] = 0x0000_0001, Reg[A0] = 0x1E00_0024

;;============================end of AU=========================================================



;;================================LS========================================================
;************************************************************** ADSRF n/carry n/overflow
{  NOP    |  MOVI.L D0, 0xFFFF  |  NOP  |  NOP  |  NOP }
;Reg[D0] = 0x0000_FFFF
;LS_PSR = 0x00

{  NOP  |  MOVI.H D0, 0x0000  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x0000_FFFF
;LS_PSR = 0x00


{  NOP  |  ADSRF D0, 0x1  |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0x0001
;LS_PSR = 0x00


{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  COPY D5, LS_PSR  |  NOP  |  NOP   |  NOP  }
;Reg[D5] = 0x0000_0000
;LS_PSR = 0x00

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D0, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0028] = 0x0001_7FFF, Reg[A0] = 0x1E00_0028

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_002c] = 0x0000_0000, Reg[A0] = 0x1E00_002c



;************************************************************** ADSRF n/carry w/overflow
{  NOP  |  MOVI.L D0, 0xFFFF  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x0000_FFFF
;LS_PSR = 0x00

{  NOP  |  MOVI.H D0, 0x7FFF  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x0000_FFFF
;LS_PSR = 0x00


{  NOP  |  ADSRF D0, 0x1  |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0x0001
;LS_PSR = 0x00


{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  COPY D5, LS_PSR  |  NOP  |  NOP   |  NOP  }
;Reg[D5] = 0x0000_0000
;LS_PSR = 0x00

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D0, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0030] = 0x, Reg[A0] = 0x1E00_0030

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0034] = 0x, Reg[A0] = 0x1E00_0034


;************************************************************** ADSRF w/carry w/overflow
{  NOP  |  MOVI.L D0, 0x0000  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x0000_FFFF
;LS_PSR = 0x00

{  NOP  |  MOVI.H D0, 0x8000  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x0000_FFFF
;LS_PSR = 0x00


{  NOP  |  ADSRF D0, 0x20  |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0x0001
;LS_PSR = 0x00


{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  COPY D5, LS_PSR  |  NOP  |  NOP  |  NOP   }
;Reg[D5] = 0x0000_0000
;LS_PSR = 0x03

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D0, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0038] = 0x, Reg[A0] = 0x1E00_0038

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_003c] = 0x3, Reg[A0] = 0x1E00_003c


;************************************************************** ADSRF.D n/overflow
{  NOP  |  MOVI.L D0, 0x7FFF  |  NOP  |  NOP |  NOP   }
;Reg[D0] = 0x2468_7FFF
;LS_PSR = 0x01

{  NOP  |  MOVI.H D0, 0x1234  |  NOP  |  NOP |  NOP   }
;Reg[D0] = 0x1234_7FFF
;LS_PSR = 0x01


{  NOP  |  ADSRF.D D0, 0x10  |  NOP  |  NOP |  NOP   }
;Reg[D2] = 0x2468_0FFE
;LS_PSR = 0x00


{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  COPY D5, LS_PSR  |  NOP  |  NOP  |  NOP   }
;Reg[D5] = 0x0000_0000
;LS_PSR = 0x00

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D0, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0040] = 0x2468_0FFE, Reg[A0] = 0x1E00_0040

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0044] = 0x0000_0000, Reg[A0] = 0x1E00_0044


;************************************************************** ADSRF.D w/overflow
{  NOP  |  MOVI.L D0, 0x7FFF  |  NOP  |  NOP |  NOP   }
;Reg[D0] = 0x2468_7FFF
;LS_PSR = 0x01

{  NOP  |  MOVI.H D0, 0x1234  |  NOP  |  NOP |  NOP   }
;Reg[D0] = 0x1234_7FFF
;LS_PSR = 0x01


{  NOP  |  ADSRF.D D0, 0xD  |  NOP  |  NOP |  NOP   }
;Reg[D2] = 0x2468_0FFE
;LS_PSR = 0x00


{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  COPY D5, LS_PSR  |  NOP  |  NOP  |  NOP   }
;Reg[D5] = 0x0000_0000
;LS_PSR = 0x01

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D0, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0048] = 0x2468_0FFE, Reg[A0] = 0x1E00_0048

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_004c] = 0x0000_0001, Reg[A0] = 0x1E00_004c









;************************************************************** Program Terminate
{  TRAP  |  NOP  |  NOP  |  NOP  |  NOP  }

