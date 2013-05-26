;************************************************************** Set Start Address

{  NOP  |  MOVI.L A0, 0x0000  |  MOVI AU_PSR, 0x0000000  |  NOP  |  NOP  }
;Reg[A0] = 0x0000_0000

{  NOP  |  MOVI.H A0, 0x2400  |  NOP  |  NOP  |  NOP  }
;Reg[A0] = 0x1207_0000, modify by JH



;///////////////////////////////////// Saturation ////////////////////////////////////////////

;************************************************************** Set Saturation Mode
{  NOP  |  NOP  |  MOVI AU_PSR, 0x000001C |  NOP  |  NOP  }			


{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }


;************************************************************** ADSRU in Saturation Mode
{  NOP  |  NOP  |  MOVI.L D0, 0x8000  |  NOP  |  NOP  }
;Reg[D0] = 0x7F7F_8000 

{  NOP  |  NOP  |  MOVI.H D0, 0xFFFF  |  NOP  |  NOP  }
;Reg[D0] = 0xFFFF_8000

{  NOP  |  NOP  |  MOVI.L D1, 0x8000  |  NOP  |  NOP  }
;Reg[D1] = 0x7FFF_8000

{  NOP  |  NOP  |  MOVI.H D1, 0x0000 |  NOP  |  NOP  }
;Reg[D1] = 0x0000_8000

{  NOP  |  NOP  |  ADSRU D1, D0, 0x5   |  NOP  |  NOP  }
;Reg[D2] = 0xFFFF_FFFF

{  NOP  |  NOP  |  NOP   |  NOP  |  NOP  }
;-------------------------------------------------------------- Store Result
{  NOP  |  SW D1, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01E8] = 0xFFFF_FFFF, Reg[A0] = 0x1E00_01FC



;************************************************************** ADSRU.D in Saturation Mode
{  NOP  |  NOP  |  MOVI.L D0, 0x8000  |  NOP  |  NOP  }
;Reg[D0] = 0xFFFF_8000 

{  NOP  |  NOP  |  MOVI.H D0, 0xFFFF  |  NOP  |  NOP  }
;Reg[D0] = 0xFFFF_8000

{  NOP  |  NOP  |  MOVI.L D1, 0xFFFF  |  NOP  |  NOP  }
;Reg[D1] = 0x0000_FFFF 

{  NOP  |  NOP  |  MOVI.H D1, 0x0001 |  NOP  |  NOP  }
;Reg[D1] = 0x0001_FFFF

{  NOP  |  NOP  |  ADSRU.D D1, D0, 0x5   |  NOP  |  NOP  }
;Reg[D2] = 0xFFFF_FFFF

{  NOP  |  NOP  |  NOP   |  NOP  |  NOP  }
;-------------------------------------------------------------- Store Result
{  NOP  |  SW D1, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01EC] = 0xFFFF_FFFF, Reg[A0] = 0x1E00_0200

;************************************************************** ADSRFU in Saturation Mode
{  NOP  |  NOP  |  MOVI.L D0, 0x8000  |  NOP  |  NOP  }
;Reg[D0] = 0x7F7F_8000 

{  NOP  |  NOP  |  MOVI.H D0, 0xFFFF  |  NOP  |  NOP  }
;Reg[D0] = 0xFFFF_8000



{  NOP  |  NOP  |  ADSRFU D0, 0x5   |  NOP  |  NOP  }
;Reg[D2] = 0xFFFF_FFFF

{  NOP  |  NOP  |  NOP   |  NOP  |  NOP  }
;-------------------------------------------------------------- Store Result
{  NOP  |  SW D0, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01E8] = 0xFFFF_FFFF, Reg[A0] = 0x1E00_01FC



;************************************************************** ADSRFU.D in Saturation Mode
{  NOP  |  NOP  |  MOVI.L D0, 0x8000  |  NOP  |  NOP  }
;Reg[D0] = 0xFFFF_8000 

{  NOP  |  NOP  |  MOVI.H D0, 0xFFFF  |  NOP  |  NOP  }
;Reg[D0] = 0xFFFF_8000

{  NOP  |  NOP  |  MOVI.L D1, 0xFFFF  |  NOP  |  NOP  }
;Reg[D1] = 0x0000_FFFF 

{  NOP  |  NOP  |  MOVI.H D1, 0x0001 |  NOP  |  NOP  }
;Reg[D1] = 0x0001_FFFF

{  NOP  |  NOP  |  ADSRFU.D D0, 0x5   |  NOP  |  NOP  }
;Reg[D2] = 0xFFFF_FFFF

{  NOP  |  NOP  |  NOP   |  NOP  |  NOP  }
;-------------------------------------------------------------- Store Result
{  NOP  |  SW D0, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01EC] = 0xFFFF_FFFF, Reg[A0] = 0x1E00_0200


{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

;************************************************************** Program Terminate
{  TRAP  |  NOP  |  NOP  |  NOP  |  NOP  }
