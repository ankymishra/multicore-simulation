
BASE_ADDR = 0x2400
  
;************************************************************** Set Start Address
{  COPY R1, SR15        |  NOP  |  NOP  |  NOP  |  NOP  }
{  SLLI R1, R1, 20      |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.L R0, 0x0000    |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R0, BASE_ADDR |  NOP  |  NOP  |  NOP  |  NOP  }
{  ADD R0, R0, R1       |  NOP  |  NOP  |  NOP  |  NOP  }

;///////////////////////////////////Function//////////////////////////////////
;************************************************************** ADDI n/carry n/overflow
{  MOVI.L R1, 0xFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R1] = 0x0000_FFFF
;Reg[C] = 0, Reg[V] = 0

{  MOVI.H R1, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R1] = 0x0000_FFFF
;Reg[C] = 0, Reg[V] = 0

{  ADDI R1, R1, 0x8000  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R1] = 0x0001_7FFF                      
;Reg[C] = 0, Reg[V] = 0                      

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  READ_FLAG R15  |  NOP  |  NOP  |  NOP  |  NOP   }
;Reg[R15] = 0x0000_0000
;Reg[C] = 0, Reg[V] = 0

;-------------------------------------------------------------- Store Result 
{  SW R1, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0000] = 0x0001_7FFF, Reg[R0] = 0x1E00_0004

{  SW R15, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0004] = 0x0000_0000, Reg[R0] = 0x1E00_0008



;************************************************************** ADDI n/carry w/overflow
{  MOVI.L R3, 0xFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R3] = 0x0000_FFFF
;Reg[C] = 0, Reg[V] = 0

{  MOVI.H R3, 0x7FFF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R3] = 0x7FFF_FFFF
;Reg[C] = 0, Reg[V] = 0

{  ADDI R3, R3, 0x0001  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R3] = 0x8000_0000
;Reg[C] = 0, Reg[V] = 1

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  READ_FLAG R15  |  NOP  |  NOP  |  NOP  |  NOP   }
;Reg[R15] = 0x0000_0001
;Reg[C] = 0, Reg[V] = 1

;-------------------------------------------------------------- Store Result 
{  SW R3, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0008] = 0x8000_0000, Reg[R0] = 0x1E00_000C

{  SW R15, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_000C] = 0x0000_0001, Reg[R0] = 0x1E00_0010



;************************************************************** ADDI w/carry n/overflow
{  MOVI.L R3, 0xFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R3] = 0x0000_FFFF
;Reg[C] = 0, Reg[V] = 1

{  MOVI.H R3, 0x7FFF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R3] = 0x7FFF_FFFF
;Reg[C] = 0, Reg[V] = 1

{  ADDI R3, R3, 0x8FFFFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R3] = 0x0FFF_FFFE
;Reg[C] = 0, Reg[V] = 0

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }



{  READ_FLAG R15  |  NOP  |  NOP  |  NOP  |  NOP   }
;Reg[R15] = 0x0000_0000
;Reg[C] = 0, Reg[V] = 0

;-------------------------------------------------------------- Store Result 
{  SW R3, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0010] = 0x0FFF_FFFE, Reg[R0] = 0x1E00_0014

{  SW R15, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0014] = 0x0000_0000, Reg[R0] = 0x1E00_0018



;************************************************************** ADDI w/carry w/overflow
{  MOVI.L R4, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R4] = 0x0000_0000
;Reg[C] = 1, Reg[V] = 0

{  MOVI.H R4, 0x8000  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R4] = 0x8000_0000
;Reg[C] = 1, Reg[V] = 0

{  ADDI R4, R4, 0x80000000  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R4] = 0x0000_0000
;Reg[C] = 0, Reg[V] = 1


{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }


{  READ_FLAG R15  |  NOP  |  NOP  |  NOP  |  NOP   }
;Reg[R15] = 0x0000_0001
;Reg[C] = 0, Reg[V] = 1

;-------------------------------------------------------------- Store Result 
{  SW R4, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0018] = 0x0000_0000, Reg[R0] = 0x1E00_001C

{  SW R15, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_001C] = 0x0000_0001, Reg[R0] = 0x1E00_0020



;************************************************************** ADD n/carry n/overflow
{  MOVI.L R5, 0xFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R5] = 0x0000_FFFF
;Reg[C] = 1, Reg[V] = 1

{  MOVI.H R5, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R5] = 0x0000_FFFF
;Reg[C] = 1, Reg[V] = 1

{  MOVI.L R6, 0x8000  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R5] = 0x0000_0000
;Reg[C] = 1, Reg[V] = 1

{  MOVI.H R6, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R5] = 0x0000_8000
;Reg[C] = 1, Reg[V] = 1

{  ADD R7, R5, R6  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R7] = 0x0001_7FFF
;Reg[C] = 0, Reg[V] = 0


{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  READ_FLAG R15  |  NOP  |  NOP  |  NOP  |  NOP   }
;Reg[R15] = 0x0000_0000
;Reg[C] = 0, Reg[V] = 0

;-------------------------------------------------------------- Store Result 
{  SW R7, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0020] = 0x0001_7FFF, Reg[R0] = 0x1E00_0024

{  SW R15, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0024] = 0x0000_0000, Reg[R0] = 0x1E00_0028




;************************************************************** ADD n/carry w/overflow
{  MOVI.L R8, 0xFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R8] = 0x0000_FFFF
;Reg[C] = 0, Reg[V] = 0

{  MOVI.H R8, 0x7FFF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R8] = 0x7FFF_FFFF
;Reg[C] = 0, Reg[V] = 0

{  MOVI.L R9, 0x0001  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R9] = 0x0000_0001
;Reg[C] = 0, Reg[V] = 0

{  MOVI.H R9, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R9] = 0x0000_0001
;Reg[C] = 0, Reg[V] = 0

{  ADD R10, R8, R9  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R10] = 0x8000_0000
;Reg[C] = 0, Reg[V] = 1

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  READ_FLAG R15  |  NOP  |  NOP  |  NOP  |  NOP   }
;Reg[R15] = 0x0000_0001
;Reg[C] = 0, Reg[V] = 1

;-------------------------------------------------------------- Store Result 
{  SW R10, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0028] = 0x8000_0000, Reg[R0] = 0x1E00_002C

{  SW R15, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_002C] = 0x0000_0001, Reg[R0] = 0x1E00_0030



;************************************************************** ADD w/carry n/overflow
{  MOVI.L R11, 0xFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R11] = 0x0000_FFFF
;Reg[C] = 0, Reg[V] = 1

{  MOVI.H R11, 0x7FFF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R11] = 0x7FFF_FFFF
;Reg[C] = 0, Reg[V] = 1

{  MOVI.L R12, 0xFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R12] = 0x0000_FFFF
;Reg[C] = 0, Reg[V] = 0

{  MOVI.H R12, 0x8FFF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R12] = 0x8FFF_FFFF
;Reg[C] = 0, Reg[V] = 1

{  ADD R13, R11, R12  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R13] = 0x0FFF_FFFE
;Reg[C] = 1, Reg[V] = 0

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }


{  READ_FLAG R15  |  NOP  |  NOP  |  NOP  |  NOP   }
;Reg[R15] = 0x0000_0002
;Reg[C] = 1, Reg[V] = 0

;-------------------------------------------------------------- Store Result 
{  SW R13, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0030] = 0x0FFF_FFFE, Reg[R0] = 0x1E00_0034

{  SW R15, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0034] = 0x0000_0002, Reg[R0] = 0x1E00_0038



;************************************************************** ADD w/carry w/overflow
{  MOVI.L R1, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R1] = 0x0000_0000
;Reg[C] = 0, Reg[V] = 0

{  MOVI.H R1, 0x8000  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R1] = 0x8000_0000
;Reg[C] = 0, Reg[V] = 0

{  MOVI.L R2, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0000
;Reg[C] = 0, Reg[V] = 0

{  MOVI.H R2, 0x8000  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x8000_0000
;Reg[C] = 0, Reg[V] = 0

{  ADD R3, R1, R2  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R3] = 0x0000_0000
;Reg[C] = 1, Reg[V] = 1

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  READ_FLAG R15  |  NOP  |  NOP  |  NOP  |  NOP   }
;Reg[R15] = 0x0000_0003
;Reg[C] = 1, Reg[V] = 1

;-------------------------------------------------------------- Store Result 
{  SW R3, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0038] = 0x0000_0000, Reg[R0] = 0x1E00_003C

{  SW R15, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_003C] = 0x0000_0003, Reg[R0] = 0x1E00_0040



;************************************************************** SUB n/carry n/overflow
{  MOVI.L R4, 0x3FFF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R4] = 0x0000_3FFF
;Reg[C] = 1, Reg[V] = 1

{  MOVI.H R4, 0x04FF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R4] = 0x04FF_3FFF
;Reg[C] = 1, Reg[V] = 1

{  MOVI.L R5, 0x2401  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R5] = 0x0000_2401
;Reg[C] = 1, Reg[V] = 1

{  MOVI.H R5, 0x002F  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R5] = 0x002F_2401
;Reg[C] = 1, Reg[V] = 1

{  SUB R6, R4, R5  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R6] = 0x04D0_1BFE
;Reg[C] = 1, Reg[V] = 0


{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }


{  READ_FLAG R15  |  NOP  |  NOP  |  NOP  |  NOP   }
;Reg[R15] = 0x0000_0002
;Reg[C] = 0, Reg[V] = 0

;-------------------------------------------------------------- Store Result 
{  SW R6, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0040] = 0x04D0_1BFE, Reg[R0] = 0x1E00_0044

{  SW R15, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0044] = 0x0000_0002, Reg[R0] = 0x1E00_0048



;************************************************************** SUB n/carry w/overflow
{  MOVI.L R7, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R7] = 0x0000_0000
;Reg[C] = 0, Reg[V] = 0

{  MOVI.H R7, 0x8FFF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R7] = 0x8FFF_0000
;Reg[C] = 0, Reg[V] = 0

{  MOVI.L R8, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R8] = 0x0000_0000
;Reg[C] = 0, Reg[V] = 0

{  MOVI.H R8, 0x7FFF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R8] = 0x7FFF_0000
;Reg[C] = 0, Reg[V] = 0

{  SUB R9, R7, R8  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R9] = 0x1000_0000
;Reg[C] = 1, Reg[V] = 1


{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }


{  READ_FLAG R15  |  NOP  |  NOP  |  NOP  |  NOP   }
;Reg[R15] = 0x0000_0003
;Reg[C] = 0, Reg[V] = 1

;-------------------------------------------------------------- Store Result 
{  SW R9, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0048] = 0x1000_0000, Reg[R0] = 0x1E00_004C

{  SW R15, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_004C] = 0x0000_0003, Reg[R0] = 0x1E00_0050



;************************************************************** SUB w/carry n/overflow
{  MOVI.L R10, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R10] = 0x0000_0000
;Reg[C] = 0, Reg[V] = 1

{  MOVI.H R10, 0x1FFF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R10] = 0x1FFF_0000
;Reg[C] = 0, Reg[V] = 1

{  MOVI.L R11, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R11] = 0x0000_0000
;Reg[C] = 0, Reg[V] = 1

{  MOVI.H R11, 0x4FFF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R11] = 0x4FFF_0000
;Reg[C] = 0, Reg[V] = 1

{  SUB R12, R10, R11  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R12] = 0xD000_0000
;Reg[C] = 0, Reg[V] = 0


{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }


{  READ_FLAG R15  |  NOP  |  NOP  |  NOP  |  NOP   }
;Reg[R15] = 0x0000_0000
;Reg[C] = 1, Reg[V] = 0

;-------------------------------------------------------------- Store Result 
{  SW R12, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0050] = 0xD000_0000, Reg[R0] = 0x1E00_0054

{  SW R15, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0054] = 0x0000_0000, Reg[R0] = 0x1E00_0058




;************************************************************** SUB w/carry w/overflow
{  MOVI.L R1, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R1] = 0x0000_0000
;Reg[C] = 1, Reg[V] = 0

{  MOVI.H R1, 0x7FFF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R1] = 0x7FFF_0000
;Reg[C] = 1, Reg[V] = 0

{  MOVI.L R2, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0000
;Reg[C] = 1, Reg[V] = 0

{  MOVI.H R2, 0x8FFF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x8FFF_0000
;Reg[C] = 1, Reg[V] = 0

{  SUB R3, R1, R2  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R3] = 0xF000_0000
;Reg[C] = 0, Reg[V] = 1

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }


{  READ_FLAG R15  |  NOP  |  NOP  |  NOP  |  NOP   }
;Reg[R15] = 0x0000_0001
;Reg[C] = 1, Reg[V] = 1

;-------------------------------------------------------------- Store Result 
{  SW R3, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0058] = 0xF000_0000, Reg[R0] = 0x1E00_005C

{  SW R15, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_005C] = 0x0000_0001, Reg[R0] = 0x1E00_0060



;************************************************************** ABS
{  MOVI.L R4, 0xFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R4] = 0x0000_FFFF

{  MOVI.H R4, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R4] = 0x0000_FFFF

{  MOVI.L R5, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R5] = 0x0000_0000

{  MOVI.H R5, 0xFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R5] = 0xFFFF_0000

{  ABS R6, R4  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R6] = 0x0000_FFFF

{  ABS R7, R5  |  NOP  |  NOP  |  NOP  |  NOP   }
;Reg[R7] = 0x0001_0000

;-------------------------------------------------------------- Store Result 
{  SW R6, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0060] = 0x0000_FFFF, Reg[R0] = 0x1E00_0064

{  SW R7, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0064] = 0x0001_0000, Reg[R0] = 0x1E00_0068



;************************************************************** NEG
{  MOVI.L R8, 0xFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R8] = 0x0000_FFFF

{  MOVI.H R8, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R8] = 0x0000_FFFF

{  MOVI.L R9, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R9] = 0x0000_0000

{  MOVI.H R9, 0xFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R9] = 0xFFFF_0000

{  NEG R10, R8  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R10] = 0xFFFF_0001

{  NEG R11, R9  |  NOP  |  NOP  |  NOP  |  NOP   }
;Reg[R11] = 0x0001_0000

;-------------------------------------------------------------- Store Result 
{  SW R10, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0068] = 0xFFFF_0001, Reg[R0] = 0x1E00_006C

{  SW R11, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_006C] = 0x0001_0000, Reg[R0] = 0x1E00_0070



;/////////////////////////////////////Encoding//////////////////////////////////////
;************************************************************** ADDI
{  MOVI R15, 0x00000001  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[D15] = 0x0000_0001

{  SLTI R1, P1, P2, R15, 0x0000FFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x0000_0001, Reg[P1] = 1, Reg[P2] = 0

{  MOVI R1, 0x11111111  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R1] = 0x1111_1111

{  MOVI R2, 0x22222222  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x2222_2222

{  MOVI R3, 0x33333333  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R3] = 0x3333_3333

{  MOVI R4, 0x44444444  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R4] = 0x4444_4444

{  MOVI R5, 0x55555555  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R5] = 0x5555_5555

{  ADDI R6, R1, 0x00000000  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R6] = 0x1111_1111                      
    
{  ADDI R7, R1, 0x00000011  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R7] = 0x1111_1122    

{  ADDI R8, R1, 0x00001111  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R8] = 0x1111_2222   

{  ADDI R9, R1, 0x00111111  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R9] = 0x1122_2222   

{  ADDI R10, R1, 0x11111111  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R10] = 0x2222_2222   

{ (P1) ADDI R2, R5, 0x55555555  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0xAAAA_AAAA

{ (P2) ADDI R3, R5, 0x55555555  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution
;-------------------------------------------------------------- Store Result 
{  SW R6, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0070] = 0x1111_1111, Reg[R0] = 0x1E00_0074

{  SW R7, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0074] = 0x1111_1122, Reg[R0] = 0x1E00_0078

{  SW R8, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0078] = 0x1111_2222, Reg[R0] = 0x1E00_007C

{  SW R9, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_007C] = 0x1122_2222, Reg[R0] = 0x1E00_0080

{  SW R10, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0080] = 0x2222_2222, Reg[R0] = 0x1E00_0084

{  SW R2, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0084] = 0xAAAA_AAAA, Reg[R0] = 0x1E00_0088

{  SW R3, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0088] = 0x3333_3333, Reg[R0] = 0x1E00_008C


;************************************************************** ADD
{ (P1) ADD R2, R4, R5  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x9999_9999

{ (P2) ADD R3, R4, R5  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution
;-------------------------------------------------------------- Store Result 
{  SW R2, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_008C] = 0x9999_9999 Reg[R0] = 0x1E00_0090

{  SW R3, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0090] = 0x3333_3333, Reg[R0] = 0x1E00_0094


;************************************************************** ADD
{ (P1) SUB R2, R5, R4  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x1111_1111

{ (P2) SUB R3, R5, R4  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution
;-------------------------------------------------------------- Store Result 
{  SW R2, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0094] = 0x1111_1111 Reg[R0] = 0x1E00_0098

{  SW R3, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0098] = 0x3333_3333, Reg[R0] = 0x1E00_009C


;************************************************************** NEG
{ (P1) NEG R2, R5  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0xAAAA_AAAB

{ (P2) NEG R3, R5  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution
;-------------------------------------------------------------- Store Result 
{  SW R2, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_009C] = 0xAAAA_AAAB Reg[R0] = 0x1E00_00A0

{  SW R3, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00A0] = 0x3333_3333, Reg[R0] = 0x1E00_00A4


;************************************************************** ABS
{ (P1) ABS R2, R2  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x5555_5555

{ (P2) ABS R3, R5  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution
;-------------------------------------------------------------- Store Result 
{  SW R2, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00A4] = 0x5555_5555 Reg[R0] = 0x1E00_00A8

{  SW R3, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00A8] = 0x3333_3333, Reg[R0] = 0x1E00_00AC



;************************************************************** Program Terminate
{  TRAP  |  NOP  |  NOP  |  NOP  |  NOP  }
