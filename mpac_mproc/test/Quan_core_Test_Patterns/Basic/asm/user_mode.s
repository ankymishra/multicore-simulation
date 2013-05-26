
BASE_ADDR = 0x2400
  
{ MOVI.L R0, 0 | MOVIU D0, 0 | NOP | MOVIU D0, 0 | NOP } 
{ MOVI.H R0, 0 | NOP | NOP | NOP | NOP } 

{ COPY R2, SR15   |  NOP    |  NOP  |  NOP    |  NOP  }
{ SLLI R2, R2, 20 |  NOP    |  NOP  |  NOP    |  NOP  }
{ BDT R2          |  BDR D1 |  NOP  |  BDR D1 |  NOP  }
{ MOVI.L R1, 0         | MOVI.L A0, 0x0000    | NOP | MOVI.L A0, 0x0000    | NOP }
{ MOVI.H R1, BASE_ADDR | MOVI.H A0, BASE_ADDR | NOP | MOVI.H A0, BASE_ADDR | NOP }
{  ADD R1, R1, R2  |  ADD A0, A0, D1  |  NOP  |  ADD A0, A0, D1  |  NOP  }

{ ADDI R0, R0, 1 | NOP | ADDI D0, D0, 1 | NOP | ADDI D0, D0, 1 }
{ ADDI R0, R0, 1 | NOP | ADDI D0, D0, 1 | NOP | ADDI D0, D0, 1 }
{ ADDI R0, R0, 1 | NOP | ADDI D0, D0, 1 | NOP | ADDI D0, D0, 1 }
{ ADDI R0, R0, 1 | NOP | ADDI D0, D0, 1 | NOP | ADDI D0, D0, 1 }
{ ADDI R0, R0, 1 | NOP | ADDI D0, D0, 1 | NOP | ADDI D0, D0, 1 }
{ SET_MODE 2 | NOP | NOP | NOP | NOP }   

{ NOP | NOP | ADDI D0, D0, 1 | NOP | ADDI D0, D0, 1 }
{ ADDI R0, R0, 1 | NOP | ADDI D0, D0, 1 | NOP | ADDI D0, D0, 1 }
{ ADDI R0, R0, 1 | NOP | ADDI D0, D0, 1 | NOP | ADDI D0, D0, 1 }
{ ADDI R0, R0, 1 | NOP | ADDI D0, D0, 1 | NOP | ADDI D0, D0, 1 }
{ ADDI R0, R0, 1 | NOP | ADDI D0, D0, 1 | NOP | ADDI D0, D0, 1 }
{ ADDI R0, R0, 1 | NOP | ADDI D0, D0, 1 | NOP | ADDI D0, D0, 1 }
{ SET_MODE 3 | NOP | NOP | NOP | NOP }

{ NOP | NOP | ADDI D0, D0, 1 | NOP | ADDI D0, D0, 1 }
{ ADDI R0, R0, 1 | NOP | ADDI D0, D0, 1 | NOP | ADDI D0, D0, 1 }
{ ADDI R0, R0, 1 | NOP | ADDI D0, D0, 1 | NOP | ADDI D0, D0, 1 }
{ ADDI R0, R0, 1 | NOP | ADDI D0, D0, 1 | NOP | ADDI D0, D0, 1 }
{ ADDI R0, R0, 1 | NOP | ADDI D0, D0, 1 | NOP | ADDI D0, D0, 1 }
{ ADDI R0, R0, 1 | NOP | ADDI D0, D0, 1 | NOP | ADDI D0, D0, 1 }
{ SET_MODE 0 | NOP | NOP | NOP | NOP }

{ NOP | NOP | ADDI D0, D0, 1 | NOP | ADDI D0, D0, 1 }
{ ADDI R0, R0, 1 | NOP | ADDI D0, D0, 1 | NOP | ADDI D0, D0, 1 }
{ ADDI R0, R0, 1 | NOP | ADDI D0, D0, 1 | NOP | ADDI D0, D0, 1 }
{ ADDI R0, R0, 1 | NOP | ADDI D0, D0, 1 | NOP | ADDI D0, D0, 1 }
{ SW R0, R1, 0 | NOP | NOP | NOP | NOP }
{ NOP | SW D0, A0, 4 | NOP | SW D0, A0, 8 | NOP }


{ TRAP | NOP | NOP | NOP | NOP }
