;************************************************************** Set Start Address

{  NOP  |  MOVI.L A0, 0x0000  |  MOVI AU_PSR, 0x0000000  |  NOP  |  NOP  }
;Reg[A0] = 0x0000_0000

{  NOP  |  MOVI.H A0, 0x2400  |  NOP  |  NOP  |  NOP  }

;************************************************************** ADD n/carry w/overflow
{  NOP  |  NOP  |  MOVI.L D0, 0xFFFF  |  NOP  |  NOP  }
;Reg[D0] = 0x0000_FFFF
;AU_PSR = 0x00

{  NOP  |  NOP  |  MOVI.H D0, 0x7FFF  |  NOP  |  NOP  }
;Reg[D0] = 0x7FFF_FFFF
;AU_PSR = 0x00

{  NOP  |  NOP  |  MOVI.L D1, 0x0001  |  NOP  |  NOP  }
;Reg[D1] = 0x0000_0000
;AU_PSR = 0x00

{  NOP  |  NOP  |  MOVI.H D1, 0x0000  |  NOP  |  NOP  }
;Reg[D1] = 0x0000_0001
;AU_PSR = 0x00

{  NOP  |  NOP  |  ADD D2, D0, D1  |  NOP  |  NOP  }
;Reg[D2] = 0x8000_0000
;AU_PSR = 0x01


{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  READ_FLAG D5  |  NOP  |  NOP   }
;Reg[D5] = 0x0000_0001
;AU_PSR = 0x01

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_003C] = 0x0000_0001, Reg[A0] = 0x1E00_0040

{ NOP | MOVIU D7, 0x3 | NOP | NOP | NOP }

{ NOP | WRITE_FLAG D7 | NOP | NOP | NOP }

{  NOP  |  NOP  |  WRITE_FLAG D7  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{ NOP | READ_FLAG D1 | READ_FLAG D2 | NOP | NOP }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  SW D1, A0, 4+    |  NOP  |  NOP  |  NOP  }

{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  TRAP  |  NOP  |  NOP  |  NOP  |  NOP  }