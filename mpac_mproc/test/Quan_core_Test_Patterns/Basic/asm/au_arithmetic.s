
BASE_ADDR = 0x2400

;************************************************************** Set Start Address

{  COPY R0, SR15   |  MOVI.L A0, 0x0000    |  MOVI AU_PSR, 0x0000000  |  NOP  |  NOP  }

{  SLLI R0, R0, 20 |  MOVI.H A0, BASE_ADDR |  NOP  |  NOP  |  NOP  }   ;Reg[A0] = 0x24?0_0000,

{  BDT R0  | BDR D0  |  NOP  |  NOP  |  NOP  }

{  NOP  | NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  | NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  ADD A0, A0, D0  |  NOP  |  NOP  |  NOP  }


;/////////////////////////////////////// Flag & Function /////////////////////////////////////////////

;************************************************************** ADDI n/carry n/overflow
{  NOP  |  NOP  |  MOVI.L D0, 0xFFFF  |  NOP  |  NOP  }
;Reg[D0] = 0x0000_FFFF
;AU_PSR = 0x00

{  NOP  |  NOP  |  MOVI.H D0, 0x0000  |  NOP  |  NOP  }
;Reg[D0] = 0x0000_FFFF
;AU_PSR = 0x00

;-------------------------------------------------------------- 0 Byte imm
{  NOP  |  NOP  |  ADDI D0, D0, 0x00000000  |  NOP  |  NOP  }
;Reg[D0] = 0x0000_FFFF                      
;AU_PSR = 0x00

;-------------------------------------------------------------- 1 Byte imm
{  NOP  |  NOP  |  ADDI D1, D0, 0x0000002C  |  NOP  |  NOP  }
;Reg[D1] = 0x0001_002B 
;AU_PSR = 0x00

;-------------------------------------------------------------- 2 Byte imm
{  NOP  |  NOP  |  ADDI D2, D0, 0x0000FF2C  |  NOP  |  NOP  }
;Reg[D2] = 0x0001_FF2B 
;AU_PSR = 0x00

;-------------------------------------------------------------- 3 Byte imm
{  NOP  |  NOP  |  ADDI D3, D0, 0x0011FF2C  |  NOP  |  NOP  }
;Reg[D3] = 0x0012_FF2B 
;AU_PSR = 0x00

;-------------------------------------------------------------- 4 Byte imm
{  NOP  |  NOP  |  ADDI D4, D0, 0x2211FF2C  |  NOP  |  NOP  }
;Reg[D4] = 0x2212_FF2B 
;AU_PSR = 0x00
                    

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D5, AU_PSR  |  NOP  |  NOP   }
;Reg[D5] = 0x0000_0000
;AU_PSR = 0x00


;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D0, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0000] = 0x0000_FFFF, Reg[A0] = 0x1E00_0004

{  NOP  |  SW D1, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0004] = 0x0001_002B, Reg[A0] = 0x1E00_0008

{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0008] = 0x0001_FF2B, Reg[A0] = 0x1E00_000C

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_000C] = 0x0012_FF2B, Reg[A0] = 0x1E00_0010

{  NOP  |  SW D4, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0010] = 0x2212_FF2B, Reg[A0] = 0x1E00_0014

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0014] = 0x0000_0000, Reg[A0] = 0x1E00_0018



;************************************************************** ADDI n/carry w/overflow
{  NOP  |  NOP  |  MOVI.L D0, 0xFFFF |  NOP  |  NOP  }
;Reg[D0] = 0x0000_FFFF
;AU_PSR = 0x00

{  NOP  |  NOP  |  MOVI.H D0, 0x7FFF  |  NOP  |  NOP  }
;Reg[D0] = 0x7FFF_FFFF
;AU_PSR = 0x00

{  NOP  |  NOP  |  ADDI D0, D0, 0x0001  |  NOP  |  NOP  }
;Reg[D0] = 0x8000_0000
;AU_PSR = 0x01

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D5, AU_PSR  |  NOP  |  NOP   }
;Reg[D5] = 0x0000_0001
;AU_PSR = 0x01

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D0, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0018] = 0x8000_0000, Reg[A0] = 0x1E00_001C

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_001C] = 0x0000_0001, Reg[A0] = 0x1E00_0020



;************************************************************** ADDI w/carry n/overflow
{  NOP  |  NOP  |  MOVI.L D0, 0xFFFF |  NOP  |  NOP  }
;Reg[D0] = 0x8000_FFFF
;AU_PSR = 0x01

{  NOP  |  NOP  |  MOVI.H D0, 0x7FFF  |  NOP  |  NOP  }
;Reg[D0] = 0x7FFF_FFFF
;AU_PSR = 0x01

{  NOP  |  NOP  |  ADDI D0, D0, 0x8FFFFFFF  |  NOP  |  NOP  }
;Reg[D0] = 0x0FFF_FFFE
;AU_PSR = 0x00

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D5, AU_PSR  |  NOP  |  NOP   }
;Reg[D5] = 0x0000_0002
;AU_PSR = 0x00

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D0, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0020] = 0x0FFF_FFFE, Reg[A0] = 0x1E00_0024

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0024] = 0x0000_0000, Reg[A0] = 0x1E00_0028





;************************************************************** ADDI w/carry w/overflow
{  NOP  |  NOP  |  MOVI.L D0, 0x0000 |  NOP  |  NOP  }
;Reg[D0] = 0x8000_0000
;AU_PSR = 0x00

{  NOP  |  NOP  |  MOVI.H D0, 0x8000  |  NOP  |  NOP  }
;Reg[D0] = 0x8000_0000
;AU_PSR = 0x00

{  NOP  |  NOP  |  ADDI D0, D0, 0x80000000  |  NOP  |  NOP  }
;Reg[D0] = 0x0000_0000
;AU_PSR = 0x01

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D5, AU_PSR  |  NOP  |  NOP   }
;Reg[D5] = 0x0000_0003
;AU_PSR = 0x01

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D0, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0028] = 0x0000_0000, Reg[A0] = 0x1E00_002C

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_002C] = 0x0000_0001, Reg[A0] = 0x1E00_0030




;************************************************************** ADD n/carry n/overflow
{  NOP  |  NOP  |  MOVI.L D0, 0xFFFF  |  NOP  |  NOP  }
;Reg[D0] = 0x0000_FFFF
;AU_PSR = 0x03

{  NOP  |  NOP  |  MOVI.H D0, 0x0000  |  NOP  |  NOP  }
;Reg[D0] = 0x0000_FFFF
;AU_PSR = 0x03

{  NOP  |  NOP  |  MOVI.L D1, 0x8000  |  NOP  |  NOP  }
;Reg[D1] = 0x0001_0000
;AU_PSR = 0x03

{  NOP  |  NOP  |  MOVI.H D1, 0x0000  |  NOP  |  NOP  }
;Reg[D1] = 0x0000_8000
;AU_PSR = 0x03

{  NOP  |  NOP  |  ADD D2, D0, D1  |  NOP  |  NOP  }
;Reg[D2] = 0x0001_7FFF
;AU_PSR = 0x00


{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D5, AU_PSR  |  NOP  |  NOP   }
;Reg[D5] = 0x0000_0000
;AU_PSR = 0x00

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0030] = 0x0001_7FFF, Reg[A0] = 0x1E00_0034

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0034] = 0x0000_0000, Reg[A0] = 0x1E00_0038





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

{  NOP  |  NOP  |  COPY D5, AU_PSR  |  NOP  |  NOP   }
;Reg[D5] = 0x0000_0001
;AU_PSR = 0x01

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0038] = 0x8000_0000, Reg[A0] = 0x1E00_003C

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_003C] = 0x0000_0001, Reg[A0] = 0x1E00_0040




;************************************************************** ADD w/carry n/overflow
{  NOP  |  NOP  |  MOVI.L D0, 0xFFFF  |  NOP  |  NOP  }
;Reg[D0] = 0x0000_FFFF
;AU_PSR = 0x01

{  NOP  |  NOP  |  MOVI.H D0, 0x7FFF  |  NOP  |  NOP  }
;Reg[D0] = 0x7FFF_FFFF
;AU_PSR = 0x01

{  NOP  |  NOP  |  MOVI.L D1, 0xFFFF  |  NOP  |  NOP  }
;Reg[D1] = 0x0000_FFFF
;AU_PSR = 0x01

{  NOP  |  NOP  |  MOVI.H D1, 0x8FFF  |  NOP  |  NOP  }
;Reg[D1] = 0x8FFF_FFFF
;AU_PSR = 0x01

{  NOP  |  NOP  |  ADD D2, D0, D1  |  NOP  |  NOP  }
;Reg[D2] = 0x0FFF_FFFE
;AU_PSR = 0x02


{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D5, AU_PSR  |  NOP  |  NOP   }
;Reg[D5] = 0x0000_0002
;AU_PSR = 0x02

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0040] = 0x0FFF_FFFE, Reg[A0] = 0x1E00_0044

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0044] = 0x0000_0002, Reg[A0] = 0x1E00_0048



;************************************************************** ADD w/carry w/overflow
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

{  NOP  |  NOP  |  ADD D2, D0, D1  |  NOP  |  NOP  }
;Reg[D2] = 0x0000_0000
;AU_PSR = 0x03


{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D5, AU_PSR  |  NOP  |  NOP   }
;Reg[D5] = 0x0000_0003
;AU_PSR = 0x03

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_004C] = 0x0000_0000, Reg[A0] = 0x1E00_0050    (MEM[0x1E00_0048]??)

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0050] = 0x0000_0003, Reg[A0] = 0x1E00_0054





;************************************************************** SUB n/carry n/overflow
{  NOP  |  NOP  |  MOVI.L D0, 0x3FFF  |  NOP  |  NOP  }
;Reg[D0] = 0x8000_3FFF
;AU_PSR = 0x03

{  NOP  |  NOP  |  MOVI.H D0, 0x04FF  |  NOP  |  NOP  }
;Reg[D0] = 0x04FF_3FFF
;AU_PSR = 0x03

{  NOP  |  NOP  |  MOVI.L D1, 0x2401  |  NOP  |  NOP  }
;Reg[D1] = 0x8000_2401
;AU_PSR = 0x03

{  NOP  |  NOP  |  MOVI.H D1, 0x002F  |  NOP  |  NOP  }
;Reg[D1] = 0x0000_002F
;AU_PSR = 0x03

{  NOP  |  NOP  |  SUB D2, D0, D1  |  NOP  |  NOP  }
;Reg[D2] = 0x04D0_1BFE
;AU_PSR = 0x02                                                  


{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D5, AU_PSR  |  NOP  |  NOP   }
;Reg[D5] = 0x0000_0002                                         
;AU_PSR = 0x02                                                 

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0054] = 0x04D0_1BFE, Reg[A0] = 0x1E00_0058

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0058] = 0x0000_0002, Reg[A0] = 0x1E00_005C         




;************************************************************** SUB n/carry w/overflow
{  NOP  |  NOP  |  MOVI.L D0, 0x0000  |  NOP  |  NOP  }
;Reg[D0] = 0x04FF_0000
;AU_PSR = 0x02                                                 

{  NOP  |  NOP  |  MOVI.H D0, 0x8FFF  |  NOP  |  NOP  }
;Reg[D0] = 0x8FFF_0000
;AU_PSR = 0x02                                                 

{  NOP  |  NOP  |  MOVI.L D1, 0x0000  |  NOP  |  NOP  }
;Reg[D1] = 0x0000_0000
;AU_PSR = 0x02                                                 

{  NOP  |  NOP  |  MOVI.H D1, 0x7FFF  |  NOP  |  NOP  }
;Reg[D1] = 0x7FFF_0000
;AU_PSR = 0x02                                                 

{  NOP  |  NOP  |  SUB D2, D0, D1  |  NOP  |  NOP  }
;Reg[D2] = 0x1000_0000
;AU_PSR = 0x03                                                 


{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D5, AU_PSR  |  NOP  |  NOP   }
;Reg[D5] = 0x0000_0003                                         
;AU_PSR = 0x03                                                 

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_005C] = 0x1000_0000, Reg[A0] = 0x1E00_0060

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0060] = 0x0000_0003, Reg[A0] = 0x1E00_0064        




;************************************************************** SUB w/carry n/overflow
{  NOP  |  NOP  |  MOVI.L D0, 0x0000  |  NOP  |  NOP  }
;Reg[D0] = 0x8FFF_0000
;AU_PSR = 0x03                                                 

{  NOP  |  NOP  |  MOVI.H D0, 0x1FFF  |  NOP  |  NOP  }
;Reg[D0] = 0x1FFF_0000
;AU_PSR = 0x03                                                 

{  NOP  |  NOP  |  MOVI.L D1, 0x0000  |  NOP  |  NOP  }
;Reg[D1] = 0x7FFF_0000
;AU_PSR = 0x03                                                 

{  NOP  |  NOP  |  MOVI.H D1, 0x4FFF  |  NOP  |  NOP  }
;Reg[D1] = 0x4FFF_0000
;AU_PSR = 0x03                                                 

{  NOP  |  NOP  |  SUB D2, D0, D1  |  NOP  |  NOP  }
;Reg[D2] = 0xD000_0000
;AU_PSR = 0x00                                                 


{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D5, AU_PSR  |  NOP  |  NOP   }
;Reg[D5] = 0x0000_0000                                         
;AU_PSR = 0x00                                                 

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0064] = 0xD000_0000, Reg[A0] = 0x1E00_0068

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0068] = 0x0000_0000, Reg[A0] = 0x1E00_006C          





;************************************************************** SUB w/carry w/overflow
{  NOP  |  NOP  |  MOVI.L D0, 0x0000  |  NOP  |  NOP  }
;Reg[D0] = 0x1FFF_0000
;AU_PSR = 0x00                                                  
 
{  NOP  |  NOP  |  MOVI.H D0, 0x7FFF  |  NOP  |  NOP  }
;Reg[D0] = 0x7FFF_0000
;AU_PSR = 0x00                                                  

{  NOP  |  NOP  |  MOVI.L D1, 0x0000  |  NOP  |  NOP  }
;Reg[D1] = 0x4FFF_0000
;AU_PSR = 0x00                                                  

{  NOP  |  NOP  |  MOVI.H D1, 0x8FFF  |  NOP  |  NOP  }
;Reg[D1] = 0x8FFF_0000
;AU_PSR = 0x00                                                  

{  NOP  |  NOP  |  SUB D2, D0, D1  |  NOP  |  NOP  }
;Reg[D2] = 0xF000_0000
;AU_PSR = 0x01                                                  


{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D5, AU_PSR  |  NOP  |  NOP   }
;Reg[D5] = 0x0000_0001                                          
;AU_PSR = 0x01                                                  
 
;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_006C] = 0xF000_0000, Reg[A0] = 0x1E00_0070

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0070] = 0x0000_0001, Reg[A0] = 0x1E00_0074          




;************************************************************** ADDI.D n/overflow
{  NOP  |  NOP  |  MOVI.L D0, 0x7FFF |  NOP  |  NOP  }
;Reg[D0] = 0x7FFF_7FFF
;AU_PSR = 0x01

{  NOP  |  NOP  |  MOVI.H D0, 0x1234  |  NOP  |  NOP  }
;Reg[D0] = 0x1234_7FFF
;AU_PSR = 0x01

{  NOP  |  NOP  |  ADDI.D D0, D0, 0x8FFF  |  NOP  |  NOP  }
;Reg[D0] = 0xA233_0FFE                                           <============update
;AU_PSR = 0x00

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D5, AU_PSR  |  NOP  |  NOP   }
;Reg[D5] = 0x0000_0000
;AU_PSR = 0x00

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D0, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0074] = 0xA233_0FFE, Reg[A0] = 0x1E00_0078          <============update

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0078] = 0x0000_0000, Reg[A0] = 0x1E00_007C




;************************************************************** ADDI.D w/overflow
{  NOP  |  NOP  |  MOVI.L D0, 0x7FFF |  NOP  |  NOP  }
;Reg[D0] = 0x2468_7FFF
;AU_PSR = 0x00

{  NOP  |  NOP  |  MOVI.H D0, 0x1234  |  NOP  |  NOP  }
;Reg[D0] = 0x1234_7FFF
;AU_PSR = 0x00

{  NOP  |  NOP  |  ADDI.D D0, D0, 0x1000  |  NOP  |  NOP  }
;Reg[D0] = 0x2234_8FFF                                        <============update
;AU_PSR = 0x01

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D5, AU_PSR  |  NOP  |  NOP   }
;Reg[D5] = 0x0000_0001
;AU_PSR = 0x01

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D0, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_007C] = 0x2234_8FFF, Reg[A0] = 0x1E00_0080       <============update

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0080] = 0x0000_0001, Reg[A0] = 0x1E00_0084



;************************************************************** ADD.D n/overflow
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

{  NOP  |  NOP  |  ADD.D D2, D0, D1  |  NOP  |  NOP  }
;Reg[D2] = 0x2468_0FFE
;AU_PSR = 0x00


{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D5, AU_PSR  |  NOP  |  NOP   }
;Reg[D5] = 0x0000_0000
;AU_PSR = 0x00

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0084] = 0x2468_0FFE, Reg[A0] = 0x1E00_0088

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0088] = 0x0000_0000, Reg[A0] = 0x1E00_008C




;************************************************************** ADD.D w/overflow
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

{  NOP  |  NOP  |  ADD.D D2, D0, D1  |  NOP  |  NOP  }
;Reg[D2] = 0x2468_8FFF
;AU_PSR = 0x01


{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D5, AU_PSR  |  NOP  |  NOP   }
;Reg[D5] = 0x0000_0001
;AU_PSR = 0x01

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0090] = 0x2468_8FFF, Reg[A0] = 0x1E00_0094      <=====MEM[0x1E00_008C]??

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0094] = 0x0000_0001, Reg[A0] = 0x1E00_0098




;************************************************************** SUB.D n/overflow
{  NOP  |  NOP  |  MOVI.L D0, 0x4FFF  |  NOP  |  NOP  }
;Reg[D0] = 0x1234_4FFF
;AU_PSR = 0x01                                                  

{  NOP  |  NOP  |  MOVI.H D0, 0x1234  |  NOP  |  NOP  }
;Reg[D0] = 0x1234_4FFF
;AU_PSR = 0x01                                                 

{  NOP  |  NOP  |  MOVI.L D1, 0x1000  |  NOP  |  NOP  }
;Reg[D1] = 0x1234_1000
;AU_PSR = 0x01

{  NOP  |  NOP  |  MOVI.H D1, 0x1234  |  NOP  |  NOP  }
;Reg[D1] = 0x1234_1000
;AU_PSR = 0x01

{  NOP  |  NOP  |  SUB.D D2, D0, D1  |  NOP  |  NOP  }
;Reg[D2] = 0x0000_3FFF
;AU_PSR = 0x00                                                    <============update


{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D5, AU_PSR  |  NOP  |  NOP   }
;Reg[D5] = 0x0000_0000                                            <============update
;AU_PSR = 0x00                                                     <============update

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0098] = 0x0000_3FFF, Reg[A0] = 0x1E00_009C

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_009C] = 0x0000_0000, Reg[A0] = 0x1E00_00A0             <============update



;************************************************************** SUB.D w/overflow
{  NOP  |  NOP  |  MOVI.L D0, 0x8FFF  |  NOP  |  NOP  }
;Reg[D0] = 0x1234_8FFF
;AU_PSR = 0x00                                                     <============update

{  NOP  |  NOP  |  MOVI.H D0, 0x1234  |  NOP  |  NOP  }
;Reg[D0] = 0x1234_4FFF
;AU_PSR = 0x00                                                    <============update

{  NOP  |  NOP  |  MOVI.L D1, 0x7FFF  |  NOP  |  NOP  }
;Reg[D1] = 0x1234_7FFF
;AU_PSR = 0x00                                                     <============update

{  NOP  |  NOP  |  MOVI.H D1, 0x1234  |  NOP  |  NOP  }
;Reg[D1] = 0x1234_7FFF
;AU_PSR = 0x00                                                     <============update

{  NOP  |  NOP  |  SUB.D D2, D0, D1  |  NOP  |  NOP  }
;Reg[D2] = 0x0000_1000
;AU_PSR = 0x01                                                     <============update
 

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D5, AU_PSR  |  NOP  |  NOP   }
;Reg[D5] = 0x0000_0001                                             <============update
;AU_PSR = 0x01                                                     <============update

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00A0] = 0x0000_1000, Reg[A0] = 0x1E00_00A4

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00A4] = 0x0000_0001, Reg[A0] = 0x1E00_00A8             <============update




;************************************************************** ADD.Q n/overflow
{  NOP  |  NOP  |  MOVI.L D0, 0x007F  |  NOP  |  NOP  }
;Reg[D0] = 0x1234_007F
;AU_PSR = 0x01

{  NOP  |  NOP  |  MOVI.H D0, 0x007F  |  NOP  |  NOP  }
;Reg[D0] = 0x007F_007F
;AU_PSR = 0x01

{  NOP  |  NOP  |  MOVI.L D1, 0x008F  |  NOP  |  NOP  }
;Reg[D1] = 0x8FFF_008F
;AU_PSR = 0x01

{  NOP  |  NOP  |  MOVI.H D1, 0x008F |  NOP  |  NOP  }
;Reg[D1] = 0x008F_008F
;AU_PSR = 0x01

{  NOP  |  NOP  |  ADD.Q D2, D0, D1  |  NOP  |  NOP  }
;Reg[D2] = 0x000E_000E
;AU_PSR = 0x00


{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D5, AU_PSR  |  NOP  |  NOP   }
;Reg[D5] = 0x0000_0000
;AU_PSR = 0x00

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00A8] = 0x000E_000E, Reg[A0] = 0x1E00_00AC

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00AC] = 0x0000_0000, Reg[A0] = 0x1E00_00B0





;************************************************************** ADD.Q w/overflow
{  NOP  |  NOP  |  MOVI.L D0, 0x007F  |  NOP  |  NOP  }
;Reg[D0] = 0x007F_007F
;AU_PSR = 0x00

{  NOP  |  NOP  |  MOVI.H D0, 0x007F  |  NOP  |  NOP  }
;Reg[D0] = 0x007F_007F
;AU_PSR = 0x00

{  NOP  |  NOP  |  MOVI.L D1, 0x0010  |  NOP  |  NOP  }
;Reg[D1] = 0x008F_0010
;AU_PSR = 0x00

{  NOP  |  NOP  |  MOVI.H D1, 0x0010 |  NOP  |  NOP  }
;Reg[D1] = 0x0010_0010
;AU_PSR = 0x00

{  NOP  |  NOP  |  ADD.Q D2, D0, D1  |  NOP  |  NOP  }
;Reg[D2] = 0x008F_008F
;AU_PSR = 0x01


{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D5, AU_PSR  |  NOP  |  NOP   }
;Reg[D5] = 0x0000_0001
;AU_PSR = 0x01

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00B0] = 0x008F_008F, Reg[A0] = 0x1E00_00B4

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00B8] = 0x0000_0001, Reg[A0] = 0x1E00_00BC     <=====???????



;************************************************************** SUB.Q n/overflow
{  NOP  |  NOP  |  MOVI.L D0, 0x7F7F  |  NOP  |  NOP  }
;Reg[D0] = 0x007F_7F7F
;AU_PSR = 0x01

{  NOP  |  NOP  |  MOVI.H D0, 0x7F7F  |  NOP  |  NOP  }
;Reg[D0] = 0x7F7F_7F7F
;AU_PSR = 0x01

{  NOP  |  NOP  |  MOVI.L D1, 0x3F3F  |  NOP  |  NOP  }
;Reg[D1] = 0x0010_3F3F
;AU_PSR = 0x01

{  NOP  |  NOP  |  MOVI.H D1, 0x3F3F  |  NOP  |  NOP  }
;Reg[D1] = 0x3F3F_3F3F
;AU_PSR = 0x01

{  NOP  |  NOP  |  SUB.Q D2, D0, D1  |  NOP  |  NOP  }
;Reg[D2] = 0x4040_4040
;AU_PSR = 0x00                                                 


{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D5, AU_PSR  |  NOP  |  NOP   }
;Reg[D5] = 0x0000_0002                                         
;AU_PSR = 0x00                                                 

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00BC] = 0x4040_4040, Reg[A0] = 0x1E00_00C0

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00C0] = 0x0000_0000, Reg[A0] = 0x1E00_00C4         




;************************************************************** SUB.Q w/overflow
{  NOP  |  NOP  |  MOVI.L D0, 0x8F8F  |  NOP  |  NOP  }
;Reg[D0] = 0x7F7F_8F8F      
;AU_PSR = 0x00                                                  

{  NOP  |  NOP  |  MOVI.H D0, 0x8F8F  |  NOP  |  NOP  }
;Reg[D0] = 0x8F8F_8F8F
;AU_PSR = 0x00                                                  

{  NOP  |  NOP  |  MOVI.L D1, 0x3F3F  |  NOP  |  NOP  }
;Reg[D1] = 0x3F3F_3F3F
;AU_PSR = 0x00                                                 

{  NOP  |  NOP  |  MOVI.H D1, 0x3F3F  |  NOP  |  NOP  }
;Reg[D1] = 0x3F3F_3F3F
;AU_PSR = 0x00                                                 

{  NOP  |  NOP  |  SUB.Q D2, D0, D1  |  NOP  |  NOP  }
;Reg[D2] = 0x5050_5050
;AU_PSR = 0x01                                                 



{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D5, AU_PSR  |  NOP  |  NOP   }
;Reg[D5] = 0x0000_0001
;AU_PSR = 0x01                                                 

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00C4] = 0x5050_5050, Reg[A0] = 0x1E00_00C8

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00C8] = 0x0000_0001, Reg[A0] = 0x1E00_00CC          <====0x1e0000bc?


;===================for test========================
;{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  NOP  |  MOVIU A4, 0x1E0000B8  |  NOP  |  NOP  |  NOP  }
;{  NOP  |  LW D5, A4, 0x4+  |  NOP  |  NOP  |  NOP  }
;{  NOP  |  LW D6, A4, 0x4+  |  NOP  |  NOP  |  NOP  }
;{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }


;************************************************************** ABS
{  NOP  |  NOP  |  MOVI.L D0, 0xFFFF  |  NOP  |  NOP  }
;Reg[D0] = 0x8F8F_FFFF
;AU_PSR = 0x01

{  NOP  |  NOP  |  MOVI.H D0, 0x0000  |  NOP  |  NOP  }
;Reg[D0] = 0x0000_FFFF
;AU_PSR = 0x01

{  NOP  |  NOP  |  MOVI.L D1, 0x0000  |  NOP  |  NOP  }
;Reg[D1] = 0x3F3F_0000
;AU_PSR = 0x01

{  NOP  |  NOP  |  MOVI.H D1, 0xFFFF  |  NOP  |  NOP  }
;Reg[D1] = 0xFFFF_0000
;AU_PSR = 0x01

{  NOP  |  NOP  |  ABS D0, D0  |  NOP  |  NOP  }
;Reg[D0] = 0x0000_FFFF
;AU_PSR = 0x01

{  NOP  |  NOP  |  ABS D1, D1  |  NOP  |  NOP  }
;Reg[D1] = 0x0001_0000
;AU_PSR = 0x01


{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D5, AU_PSR  |  NOP  |  NOP   }
;Reg[D5] = 0x0000_0000
;AU_PSR = 0x01

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D0, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00CC] = 0x0000_FFFF, Reg[A0] = 0x1E00_00D0

{  NOP  |  SW D1, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00D0] = 0x0001_0000, Reg[A0] = 0x1E00_00D4

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00D4] = 0x0000_0000, Reg[A0] = 0x1E00_00D8			<== 3.1    <====3.5 jeremy   0x1e0000c8?




;************************************************************** ABS.D
{  NOP  |  NOP  |  MOVI.L D0, 0x00FF  |  NOP  |  NOP  }
;Reg[D0] = 0x0000_00FF
;AU_PSR = 0x01

{  NOP  |  NOP  |  MOVI.H D0, 0x00FF  |  NOP  |  NOP  }
;Reg[D0] = 0x00FF_00FF
;AU_PSR = 0x01

{  NOP  |  NOP  |  MOVI.L D1, 0xFF00  |  NOP  |  NOP  }
;Reg[D1] = 0x0001_FF00
;AU_PSR = 0x01

{  NOP  |  NOP  |  MOVI.H D1, 0xFF00  |  NOP  |  NOP  }
;Reg[D1] = 0xFF00_FF00
;AU_PSR = 0x01

{  NOP  |  NOP  |  ABS.D D0, D0  |  NOP  |  NOP  }
;Reg[D0] = 0x00FF_00FF
;AU_PSR = 0x01

{  NOP  |  NOP  |  ABS.D D1, D1  |  NOP  |  NOP  }
;Reg[D1] = 0x0100_0100
;AU_PSR = 0x01


{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D5, AU_PSR  |  NOP  |  NOP   }
;Reg[D5] = 0x0000_0000
;AU_PSR = 0x01

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D0, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00D8] = 0x00FF_00FF, Reg[A0] = 0x1E00_00DC

{  NOP  |  SW D1, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00DC] = 0x0100_0100, Reg[A0] = 0x1E00_00E0

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00E0] = 0x0000_0000, Reg[A0] = 0x1E00_00E4			<== 3.1   <===3.5 jeremy   0x1e0000d4??




;************************************************************** ABS.Q
{  NOP  |  NOP  |  MOVI.L D0, 0x0F0F  |  NOP  |  NOP  }
;Reg[D0] = 0x00FF_0F0F
;AU_PSR = 0x00

{  NOP  |  NOP  |  MOVI.H D0, 0x0F0F  |  NOP  |  NOP  }
;Reg[D0] = 0x0F0F_0F0F
;AU_PSR = 0x00

{  NOP  |  NOP  |  MOVI.L D1, 0xF0F0  |  NOP  |  NOP  }
;Reg[D1] = 0x0100_F0F0
;AU_PSR = 0x00

{  NOP  |  NOP  |  MOVI.H D1, 0xF0F0  |  NOP  |  NOP  }
;Reg[D1] = 0xF0F0_F0F0
;AU_PSR = 0x00

{  NOP  |  NOP  |  ABS.Q D0, D0  |  NOP  |  NOP  }
;Reg[D0] = 0x0F0F_0F0F
;AU_PSR = 0x01

{  NOP  |  NOP  |  ABS.Q D1, D1  |  NOP  |  NOP  }
;Reg[D1] = 0x1010_1010
;AU_PSR = 0x01


{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D5, AU_PSR  |  NOP  |  NOP   }
;Reg[D5] = 0x0000_0000
;AU_PSR = 0x01

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D0, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00E4] = 0x0F0F_0F0F, Reg[A0] = 0x1E00_00E8

{  NOP  |  SW D1, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00E8] = 0x1010_1010, Reg[A0] = 0x1E00_00EC

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00EC] = 0x0000_0001, Reg[A0] = 0x1E00_00F0			<== 3.1   <====0x1e0000e0?  jeremy3.5




;************************************************************** NEG
{  NOP  |  NOP  |  MOVI.L D0, 0xFFFF  |  NOP  |  NOP  }
;Reg[D0] = 0x0F0F_FFFF
;AU_PSR = 0x00

{  NOP  |  NOP  |  MOVI.H D0, 0x0000  |  NOP  |  NOP  }
;Reg[D0] = 0x0000_FFFF
;AU_PSR = 0x00

{  NOP  |  NOP  |  MOVI.L D1, 0x0000  |  NOP  |  NOP  }
;Reg[D1] = 0x1010_0000
;AU_PSR = 0x00

{  NOP  |  NOP  |  MOVI.H D1, 0xFFFF  |  NOP  |  NOP  }
;Reg[D1] = 0xFFFF_0000
;AU_PSR = 0x00

{  NOP  |  NOP  |  NEG D0, D0  |  NOP  |  NOP  }
;Reg[D0] = 0xFFFF_0001
;AU_PSR = 0x00

{  NOP  |  NOP  |  NEG D1, D1  |  NOP  |  NOP  }
;Reg[D1] = 0x0001_0000
;AU_PSR = 0x00


{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D5, AU_PSR  |  NOP  |  NOP   }
;Reg[D5] = 0x0000_0000
;AU_PSR = 0x00

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D0, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00F0] = 0xFFFF_0001, Reg[A0] = 0x1E00_00F4

{  NOP  |  SW D1, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00F4] = 0x0001_0000, Reg[A0] = 0x1E00_00F8

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00F8] = 0x0000_0000, Reg[A0] = 0x1E00_00FC





;************************************************************** ADDC n/carry_in
{  NOP  |  NOP  |  MOVI.L D0, 0xFFFF  |  NOP  |  NOP  }
;Reg[D0] = 0x0000_FFFF
;AU_PSR = 0x00

{  NOP  |  NOP  |  MOVI.H D0, 0x7FFF  |  NOP  |  NOP  }
;Reg[D0] = 0x7FFF_FFFF
;AU_PSR = 0x00

{  NOP  |  NOP  |  MOVI.L D1, 0xFFFF  |  NOP  |  NOP  }
;Reg[D1] = 0x0000_FFFF
;AU_PSR = 0x00

{  NOP  |  NOP  |  MOVI.H D1, 0x8FFF  |  NOP  |  NOP  }
;Reg[D1] = 0x8FFF_FFFF
;AU_PSR = 0x00

{  NOP  |  NOP  |  ADDC D2, D0, D1  |  NOP  |  NOP  }
;Reg[D2] = 0x0FFF_FFFE
;AU_PSR = 0x02


{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D5, AU_PSR  |  NOP  |  NOP   }
;Reg[D5] = 0x0000_0002
;AU_PSR = 0x02

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00FC] = 0x0FFF_FFFE, Reg[A0] = 0x1E00_0100

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0100] = 0x0000_0002, Reg[A0] = 0x1E00_0104





;************************************************************** ADDC w/carry_in
{  NOP  |  NOP  |  MOVI.L D0, 0xFFFF  |  NOP  |  NOP  }
;Reg[D0] = 0x0000_FFFF
;AU_PSR = 0x02

{  NOP  |  NOP  |  MOVI.H D0, 0x0000  |  NOP  |  NOP  }
;Reg[D0] = 0x0000_FFFF
;AU_PSR = 0x02

{  NOP  |  NOP  |  MOVI.L D1, 0x0000  |  NOP  |  NOP  }
;Reg[D1] = 0x0000_0000
;AU_PSR = 0x02

{  NOP  |  NOP  |  MOVI.H D1, 0x0000  |  NOP  |  NOP  }
;Reg[D1] = 0x0000_0000
;AU_PSR = 0x02

{  NOP  |  NOP  |  ADDC D2, D0, D1  |  NOP  |  NOP  }
;Reg[D2] = 0x0001_0000
;AU_PSR = 0x00


{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D5, AU_PSR  |  NOP  |  NOP   }
;Reg[D5] = 0x0000_0000
;AU_PSR = 0x00

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0104] = 0x0001_0000, Reg[A0] = 0x1E00_0108

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0108] = 0x0000_0000, Reg[A0] = 0x1E00_010C





;************************************************************** MERGEA, MERGES
{  NOP  |  NOP  |  MOVI.L D3, 0x8000  |  NOP  |  NOP  }
;Reg[D3] = 0x0012_8000
;AU_PSR = 0x00

{  NOP  |  NOP  |  MOVI.H D3, 0x7000  |  NOP  |  NOP  }
;Reg[D3] = 0x7000_8000
;AU_PSR = 0x00

{  NOP  |  NOP  |  ADDI D3, D3, 0x10000000  |  NOP  |  NOP  }
;Reg[D3] = 0x8000_8000
;AU_PSR = 0x01

{  NOP  |  NOP  |  MOVI.L D0, 0x8000  |  NOP  |  NOP  }
;Reg[D0] = 0xFFFF_8000
;AU_PSR = 0x01

{  NOP  |  NOP  |  MOVI.H D0, 0x7FFF  |  NOP  |  NOP  }
;Reg[D0] = 0x7FFF_8000
;AU_PSR = 0x01

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  MERGEA D1, D0  |  NOP  |  NOP  }
;Reg[D1] = 0xFFFF_FFFF
;AU_PSR = 0x00

{  NOP  |  NOP  |  MERGES D2, D0  |  NOP  |  NOP  }
;Reg[D2] = 0x0000_FFFF
;AU_PSR = 0x00

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D5, AU_PSR  |  NOP  |  NOP   }
;Reg[D5] = 0x0000_0000
;AU_PSR = 0x00

;-------------------------------------------------------------- Store Result
{  NOP  |  SW D1, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_010C] = 0xFFFF_FFFF, Reg[A0] = 0x1E00_0110

{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0110] = 0x0000_FFFF, Reg[A0] = 0x1E00_0114

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0114] = 0x0000_0000, Reg[A0] = 0x1E00_0118



;************************************************************** BF, BF.D
{  NOP  |  NOP  |  MOVI D0, 0x7FFF8FFF  |  NOP  |  NOP  }
;Reg[D0] = 0x7FFF_8FFF
;AU_PSR = 0x00

{  NOP  |  NOP  |  MOVI D1, 0x00017FFF  |  NOP  |  NOP  }
;Reg[D1] = 0x0001_7FFF
;AU_PSR = 0x00

{  NOP  |  NOP  |  BF D2, D0, D1  |  NOP  |  NOP  }
;Reg[D2] = 0x8001_0FFE, Reg[D3] = 0x7FFE_1000
;AU_PSR = 0x00

{  NOP  |  NOP  |  BF.D D4, D0, D1  |  NOP  |  NOP  }
;Reg[D4] = 0x8000_0FFE, Reg[D5] = 0x7FFE_1000
;AU_PSR = 0x00

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0118] = 0x8001_0FFE, Reg[A0] = 0x1E00_011C

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_011C] = 0x7FFE_1000, Reg[A0] = 0x1E00_0120

{  NOP  |  SW D4, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0120] = 0x8000_0FFE, Reg[A0] = 0x1E00_0124

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0124] = 0x7FFE_1000, Reg[A0] = 0x1E00_0128




;************************************************************** SAA.Q
{  NOP  |  NOP  |  MOVI D0, 0x7F7F7F7F  |  NOP  |  NOP  }
;Reg[D0] = 0x7F7F_7F7F
;AU_PSR = 0x00

{  NOP  |  NOP  |  MOVI D1, 0x8F8F8F8F  |  NOP  |  NOP  }
;Reg[D1] = 0x8F8F_8F8F
;AU_PSR = 0x00

{  NOP  |  NOP  |  MOVI AC0, 0x01010101  |  NOP  |  NOP  }
;Reg[AC0] = 0x00_0101_0101
;AU_PSR = 0x00

{  NOP  |  NOP  |  MOVI AC1, 0x01010101  |  NOP  |  NOP  }
;Reg[AC1] = 0x00_0101_0101
;AU_PSR = 0x00

{  NOP  |  NOP  |  SAA.Q AC0, D0, D1  |  NOP  |  NOP  }
;Reg[AC0] = 0x00_0111_0111, Reg[AC1] = 0x00_0111_0111
;AU_PSR = 0x00

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  COPY D0, AC0  |  NOP  |  NOP   }
;Reg[D0] = 0x0111_0111
;AU_PSR = 0x00

{  NOP  |  NOP  |  COPY D1, AC1  |  NOP  |  NOP   }
;Reg[D1] = 0x0111_0111
;AU_PSR = 0x00

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D0, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0128] = 0x0111_0111, Reg[A0] = 0x1E00_012C

{  NOP  |  SW D1, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_012C] = 0x0111_0111, Reg[A0] = 0x1E00_0130



;///////////////////////////////////// Encoding ////////////////////////////////////////////
{  NOP  |  NOP  |  MOVI D15, 0x00000001  |  NOP  |  NOP  }
;Reg[D15] = 0x0000_0001

{  NOP  |  NOP  |  SLTI D0, P1, P2, D15, 0x0000FFFF  |  NOP  |  NOP  }
;Reg[D0] = 0x0000_0001, Reg[P1] = 1, Reg[P2] = 0

{  NOP  |  NOP  |  MOVI D0, 0x7000FFFF  |  NOP  |  NOP  }
;Reg[D0] = 0x7000_FFFF

{  NOP  |  NOP  |  MOVI D1, 0x00F00001  |  NOP  |  NOP  }
;Reg[D1] = 0x00F0_0001


;************************************************************** ADD
{  NOP  |  NOP  | (P1) ADD D2, D0, D1  |  NOP  |  NOP  }
;Reg[D2] = 0x70F1_0000

{  NOP  |  NOP  | (P2) ADD D3, D0, D1  |  NOP  |  NOP  }
;Reg[D3] = 0x7FFE_1000

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0130] = 0x70F1_0000, Reg[A0] = 0x1E00_0134

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0138] = 0x7FFE_1000, Reg[A0] = 0x1E00_013C




;************************************************************** ADD.D
{  NOP  |  NOP  | (P1) ADD.D D2, D0, D1  |  NOP  |  NOP  }
;Reg[D2] = 0x70F0_0000

{  NOP  |  NOP  | (P2) ADD.D D3, D0, D1  |  NOP  |  NOP  }
;Reg[D3] = 0x7FFE_1000

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_013C] = 0x70F0_0000, Reg[A0] = 0x1E00_0140

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0140] = 0x7FFE_1000, Reg[A0] = 0x1E00_0144






;************************************************************** ADD.Q
{  NOP  |  NOP  | (P1) ADD.Q D2, D0, D1  |  NOP  |  NOP  }
;Reg[D2] = 0x70F0_FF00

{  NOP  |  NOP  | (P2) ADD.Q D3, D0, D1  |  NOP  |  NOP  }
;Reg[D3] = 0x7FFE_1000

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0144] = 0x70F0_FF00, Reg[A0] = 0x1E00_0148

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0148] = 0x7FFE_1000, Reg[A0] = 0x1E00_014C






;************************************************************** SUB
{  NOP  |  NOP  | (P1) SUB D2, D0, D1  |  NOP  |  NOP  }
;Reg[D2] = 0x6F10_FFFE

{  NOP  |  NOP  | (P2) SUB D3, D0, D1  |  NOP  |  NOP  }
;Reg[D3] = 0x7FFE_1000

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_014C] = 0x6F10_FFFE, Reg[A0] = 0x1E00_0150

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0150] = 0x7FFE_1000, Reg[A0] = 0x1E00_0154




;************************************************************** SUB.D
{  NOP  |  NOP  | (P1) SUB.D D2, D0, D1  |  NOP  |  NOP  }
;Reg[D2] = 0x6F10_FFFE

{  NOP  |  NOP  | (P2) SUB.D D3, D0, D1  |  NOP  |  NOP  }
;Reg[D3] = 0x7FFE_1000

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0154] = 0x6F10_FFFE, Reg[A0] = 0x1E00_0158

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0158] = 0x7FFE_1000, Reg[A0] = 0x1E00_015C





;************************************************************** SUB.Q
{  NOP  |  NOP  | (P1) SUB.Q D2, D0, D1  |  NOP  |  NOP  }
;Reg[D2] = 0x7010_FFFE

{  NOP  |  NOP  | (P2) SUB.Q D3, D0, D1  |  NOP  |  NOP  }
;Reg[D3] = 0x7FFE_1000

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_014C] = 0x7010_FFFE, Reg[A0] = 0x1E00_0160

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0150] = 0x7FFE_1000, Reg[A0] = 0x1E00_0164




;************************************************************** ABS
{  NOP  |  NOP  | (P1) ABS D2, D0  |  NOP  |  NOP  }
;Reg[D2] = 0x7000_FFFF

{  NOP  |  NOP  | (P2) ABS D3, D0  |  NOP  |  NOP  }
;Reg[D3] = 0x7FFE_1000

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0154] = 0x7000_FFFF, Reg[A0] = 0x1E00_0168

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0158] = 0x7FFE_1000, Reg[A0] = 0x1E00_016C




;************************************************************** ABS.D
{  NOP  |  NOP  | (P1) ABS.D D2, D0  |  NOP  |  NOP  }
;Reg[D2] = 0x7000_0001

{  NOP  |  NOP  | (P2) ABS.D D3, D0  |  NOP  |  NOP  }
;Reg[D3] = 0x7FFE_1000

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_015C] = 0x7000_0001, Reg[A0] = 0x1E00_0170

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0160] = 0x7FFE_1000, Reg[A0] = 0x1E00_0174




;************************************************************** ABS.Q
{  NOP  |  NOP  | (P1) ABS.Q D2, D0  |  NOP  |  NOP  }
;Reg[D2] = 0x7000_0101

{  NOP  |  NOP  | (P2) ABS.Q D3, D0  |  NOP  |  NOP  }
;Reg[D3] = 0x7FFE_1000

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0164] = 0x7000_0101, Reg[A0] = 0x1E00_0178

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0168] = 0x7FFE_1000, Reg[A0] = 0x1E00_017C




;************************************************************** ADDI
{  NOP  |  NOP  | (P1) ADDI D2, D0, 0x70F00001  |  NOP  |  NOP  }
;Reg[D2] = 0xE0F1_0000

{  NOP  |  NOP  | (P2) ADDI D3, D0, 0x70F00001  |  NOP  |  NOP  }
;Reg[D3] = 0x7FFE_1000

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_016C] = 0xE0F1_0000, Reg[A0] = 0x1E00_0180

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0170] = 0x7FFE_1000, Reg[A0] = 0x1E00_0184





;************************************************************** ADDI.D
{  NOP  |  NOP  | (P1) ADDI.D D2, D0, 0x0010  |  NOP  |  NOP  }    
;Reg[D2] = 0x7010_000F                                               <============update

{  NOP  |  NOP  | (P2) ADDI.D D3, D0, 0x0010  |  NOP  |  NOP  }    
;Reg[D3] = 0x7FFE_1000                                               <============update

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0174] = 0x7010_000F, Reg[A0] = 0x1E00_0188               <============update

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0178] = 0x7FFE_1000, Reg[A0] = 0x1E00_018C




;************************************************************** NEG
{  NOP  |  NOP  | (P1) NEG D2, D0  |  NOP  |  NOP  }
;Reg[D2] = 0x8FFF_0001

{  NOP  |  NOP  | (P2) NEG D3, D0  |  NOP  |  NOP  }
;Reg[D3] = 0x7FFE_1000

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_017C] = 0x8FFF_0001, Reg[A0] = 0x1E00_0190

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0180] = 0x7FFE_1000, Reg[A0] = 0x1E00_0194


;************************************************************** MERGEA
{  NOP  |  NOP  | (P1) MERGEA D2, D0  |  NOP  |  NOP  }
;Reg[D2] = 0x 0000_6FFF

{  NOP  |  NOP  | (P2) MERGEA D3, D0  |  NOP  |  NOP  }
;Reg[D3] = 0x7FFE_1000

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0184] = 0x0000_6FFF, Reg[A0] = 0x1E00_0198

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0188] = 0x7FFE_1000, Reg[A0] = 0x1E00_019C




;************************************************************** MERGES
{  NOP  |  NOP  | (P1) MERGES D2, D0  |  NOP  |  NOP  }
;Reg[D2] = 0x0000_7001

{  NOP  |  NOP  | (P2) MERGES D3, D0  |  NOP  |  NOP  }
;Reg[D3] = 0x7FFE_1000

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_018C] = 0x0000_7001, Reg[A0] = 0x1E00_01A0

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0190] = 0x7FFE_1000, Reg[A0] = 0x1E00_01A4




;************************************************************** BF
{  NOP  |  NOP  |  MOVI D6, 0xFFFFFFFF  |  NOP  |  NOP  }
;Reg[D6] = 0xFFFF_FFFF

{  NOP  |  NOP  |  MOVI D7, 0xFFFFFFFF  |  NOP  |  NOP  }
;Reg[D7] = 0xFFFF_FFFF

{  NOP  |  NOP  | (P1) BF D2, D0, D1  |  NOP  |  NOP  }
;Reg[D2] = 0x70F1_0000, Reg[D3] = 0x6F10_FFFE

{  NOP  |  NOP  | (P2) BF D4, D0, D1  |  NOP  |  NOP  }
;Reg[D4] = 0x8000_0FFE, Reg[D5] = 0x7FFE_1000 


;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0194] = 0x70F1_0000, Reg[A0] = 0x1E00_01A8

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0198] = 0x6F10_FFFE, Reg[A0] = 0x1E00_01AC

{  NOP  |  SW D4, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_019C] = 0x8000_0FFE, Reg[A0] = 0x1E00_01B0

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01A0] = 0x7FFE_1000, Reg[A0] = 0x1E00_01B4




;************************************************************** BF.D
{  NOP  |  NOP  | (P1) BF.D D2, D0, D1  |  NOP  |  NOP  }
;Reg[D2] = 0x70F0_0000, Reg[D3] = 0x6F10_FFFE

{  NOP  |  NOP  | (P2) BF.D D4, D0, D1  |  NOP  |  NOP  }
;Reg[D4] = 0x8000_0FFE, Reg[D5] = 0x7FFE_1000

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01A4] = 0x70F0_0000, Reg[A0] = 0x1E00_01B8

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01A8] = 0x6F10_FFFE, Reg[A0] = 0x1E00_01BC

{  NOP  |  SW D4, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01AC] = 0x8000_0FFE, Reg[A0] = 0x1E00_01C0

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01B0] = 0x7FFE_1000, Reg[A0] = 0x1E00_01C4




;************************************************************** SAA.Q
{  NOP  |  NOP  |  MOVI AC0, 0x00FF0011  |  NOP  |  NOP  }
;Reg[AC0] = 0xFFFF_FFFF

{  NOP  |  NOP  |  MOVI AC1, 0x00FF0011  |  NOP  |  NOP  }
;Reg[AC1] = 0xFFFF_FFFF

{  NOP  |  NOP  |  MOVI AC2, 0x00FF0011  |  NOP  |  NOP  }
;Reg[AC2] = 0xFFFF_FFFF

{  NOP  |  NOP  |  MOVI AC3, 0x00FF0011  |  NOP  |  NOP  }
;Reg[AC3] = 0xFFFF_FFFF

{  NOP  |  NOP  | (P1) SAA.Q AC0, D0, D1  |  NOP  |  NOP  }
;Reg[AC0] = 0x016F_0101, Reg[AC1] = 0x01FE_010F

{  NOP  |  NOP  | (P2) SAA.Q AC2, D0, D1  |  NOP  |  NOP  }
;Reg[AC2] = 0x00FF_0011, Reg[AC3] = 0x00FF_0011

{  NOP  |  NOP  |  COPY D2, AC0  |  NOP  |  NOP   }
;Reg[D2] = 0x0100_0013

{  NOP  |  NOP  |  COPY D3, AC1  |  NOP  |  NOP   }
;Reg[D3] = 0x016F_0101

{  NOP  |  NOP  |  COPY D4, AC2  |  NOP  |  NOP   }
;Reg[D4] = 0x00FF_0011

{  NOP  |  NOP  |  COPY D5, AC3  |  NOP  |  NOP   }
;Reg[D5] = 0x00FF_0011

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01B4] = 0x016F_0101, Reg[A0] = 0x1E00_01C8

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01B8] = 0x01FE_010F, Reg[A0] = 0x1E00_01CC

{  NOP  |  SW D4, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01BC] = 0x00FF_0011, Reg[A0] = 0x1E00_01D0

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01C0] = 0x00FF_0011, Reg[A0] = 0x1E00_01D4





;///////////////////////////////////// Saturation ////////////////////////////////////////////

;************************************************************** Set Saturation Mode
{  NOP  |  NOP  |  MOVI AU_PSR, 0x000001C |  NOP  |  NOP  }			
;AU_PSR[4](Sat_Q) = 0x1, AU_PSR[3](Sat_D) = 0x1, AU_PSR[2](Sat_S) = 0x1
;																	<============update for PACv3.1

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }


;************************************************************** ADDI, ADDI.D in Saturation Mode
{  NOP  |  NOP  |  MOVI.L D0, 0x8000 |  NOP  |  NOP  }
;Reg[D0] = 0xFFFF_8000 

{  NOP  |  NOP  |  MOVI.H D0, 0x7FFF |  NOP  |  NOP  }
;Reg[D0] = 0x7FFF_8000 

{  NOP  |  NOP  |  ADDI.D D1, D0, 0xFFFF  |  NOP  |  NOP  }
;Reg[D1] = 0x7FFE_8000                                                 <============update

{  NOP  |  NOP  |  ADDI D2, D0, 0x00008000  |  NOP  |  NOP  }
;Reg[D2] = 0x7FFF_FFFF
;-------------------------------------------------------------- Store Result
{  NOP  |  SW D1, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01C4] = 0x7FFE_8000, Reg[A0] = 0x1E00_01D8                 <============update

{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01C8] = 0x7FFF_FFFF, Reg[A0] = 0x1E00_01DC


;************************************************************** ADD in Saturation Mode
{  NOP  |  NOP  |  MOVI.L D0, 0x8000  |  NOP  |  NOP  }
;Reg[D0] = 0x7FFF_8000 

{  NOP  |  NOP  |  MOVI.H D0, 0x7FFF  |  NOP  |  NOP  }
;Reg[D0] = 0x7FFF_8000

{  NOP  |  NOP  |  MOVI.L D1, 0x8000  |  NOP  |  NOP  }
;Reg[D1] = 0x7FFF_8000

{  NOP  |  NOP  |  MOVI.H D1, 0x0000 |  NOP  |  NOP  }
;Reg[D1] = 0x0000_8000

{  NOP  |  NOP  |  ADD D2, D0, D1   |  NOP  |  NOP  }
;Reg[D2] = 0x7FFF_FFFF

{  NOP  |  NOP  |  NOP   |  NOP  |  NOP  }
;-------------------------------------------------------------- Store Result
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01CC] = 0x7FFF_FFFF, Reg[A0] = 0x1E00_01E0


;************************************************************** ADD.D in Saturation Mode
{  NOP  |  NOP  |  MOVI.L D0, 0x8000  |  NOP  |  NOP  }
;Reg[D0] = 0x7FFF_8000 

{  NOP  |  NOP  |  MOVI.H D0, 0x7FFF  |  NOP  |  NOP  }
;Reg[D0] = 0x7FFF_8000

{  NOP  |  NOP  |  MOVI.L D1, 0xFFFF  |  NOP  |  NOP  }
;Reg[D1] = 0x0000_FFFF 

{  NOP  |  NOP  |  MOVI.H D1, 0x0001 |  NOP  |  NOP  }
;Reg[D1] = 0x0001_FFFF

{  NOP  |  NOP  |  ADD.D D2, D0, D1   |  NOP  |  NOP  }
;Reg[D2] = 0x7FFF_8000

{  NOP  |  NOP  |  NOP   |  NOP  |  NOP  }
;-------------------------------------------------------------- Store Result
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01D0] = 0x7FFF_8000, Reg[A0] = 0x1E00_01E4


;************************************************************** ADD.Q in Saturation Mode
{  NOP  |  NOP  |  MOVI.L D0, 0x8080  |  NOP  |  NOP  }
;Reg[D0] = 0x7FFF_8080

{  NOP  |  NOP  |  MOVI.H D0, 0x7F7F  |  NOP  |  NOP  }
;Reg[D0] = 0x7F7F_8080

{  NOP  |  NOP  |  MOVI.L D1, 0xFFFF  |  NOP  |  NOP  }
;Reg[D1] = 0x0001_FFFF

{  NOP  |  NOP  |  MOVI.H D1, 0x0101 |  NOP  |  NOP  }
;Reg[D1] = 0x0101_FFFF

{  NOP  |  NOP  |  ADD.Q D2, D0, D1   |  NOP  |  NOP  }
;Reg[D2] = 0x7F7F_8080

{  NOP  |  NOP  |  NOP   |  NOP  |  NOP  }
;-------------------------------------------------------------- Store Result
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01D4] = 0x7F7F_8080, Reg[A0] = 0x1E00_01E8


;************************************************************** SUB in Saturation Mode
{  NOP  |  NOP  |  MOVI.L D0, 0x0001  |  NOP  |  NOP  }
;Reg[D0] = 0x7F7F_0001 

{  NOP  |  NOP  |  MOVI.H D0, 0x7FFF  |  NOP  |  NOP  }
;Reg[D0] = 0x7FFF_0001

{  NOP  |  NOP  |  MOVI.L D1, 0x0001  |  NOP  |  NOP  }
;Reg[D1] = 0x0101_0001

{  NOP  |  NOP  |  MOVI.H D1, 0xFFFF |  NOP  |  NOP  }
;Reg[D1] = 0xFFFF_0001

{  NOP  |  NOP  |  SUB D2, D0, D1   |  NOP  |  NOP  }
;Reg[D2] = 0x7FFF_FFFF

{  NOP  |  NOP  |  NOP   |  NOP  |  NOP  }
;-------------------------------------------------------------- Store Result
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01D8] = 0x7FFF_FFFF, Reg[A0] = 0x1E00_01EC


;************************************************************** SUB.D in Saturation Mode
{  NOP  |  NOP  |  MOVI.L D0, 0x8000  |  NOP  |  NOP  }
;Reg[D0] = 0x7FFF_8000 

{  NOP  |  NOP  |  MOVI.H D0, 0x7FFF  |  NOP  |  NOP  }
;Reg[D0] = 0x7FFF_8000

{  NOP  |  NOP  |  MOVI.L D1, 0x0001  |  NOP  |  NOP  }
;Reg[D1] = 0xFFFF_0001

{  NOP  |  NOP  |  MOVI.H D1, 0xFFFF |  NOP  |  NOP  }
;Reg[D1] = 0xFFFF_0001

{  NOP  |  NOP  |  SUB.D D2, D0, D1   |  NOP  |  NOP  }
;Reg[D2] = 0x7FFF_8000

{  NOP  |  NOP  |  NOP   |  NOP  |  NOP  }
;-------------------------------------------------------------- Store Result
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01DC] = 0x7FFF_8000, Reg[A0] = 0x1E00_01F0


;************************************************************** SUB.Q in Saturation Mode
{  NOP  |  NOP  |  MOVI.L D0, 0x8080  |  NOP  |  NOP  }
;Reg[D0] = 0x7FFF_8080 

{  NOP  |  NOP  |  MOVI.H D0, 0x7F7F  |  NOP  |  NOP  }
;Reg[D0] = 0x7F7F_8080

{  NOP  |  NOP  |  MOVI.L D1, 0x0101  |  NOP  |  NOP  }
;Reg[D1] = 0xFFFF_0101

{  NOP  |  NOP  |  MOVI.H D1, 0xFFFF |  NOP  |  NOP  }
;Reg[D1] = 0xFFFF_0101

{  NOP  |  NOP  |  SUB.Q D2, D0, D1   |  NOP  |  NOP  }
;Reg[D2] = 0x7F7F_8080

{  NOP  |  NOP  |  NOP   |  NOP  |  NOP  }
;-------------------------------------------------------------- Store Result
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01E0] = 0x7F7F_8080, Reg[A0] = 0x1E00_01F4


;************************************************************** ADDC in Saturation Mode
{  NOP  |  NOP  |  ADDI D3, D1, 0xFFFF0000  |  NOP  |  NOP  }
;Reg[D3] = 0xFFFE_0101
;AU_PSR = 0x1E

{  NOP  |  NOP  |  MOVI.L D0, 0x8080  |  NOP  |  NOP  }
;Reg[D0] = 0x7FFF_8080 

{  NOP  |  NOP  |  MOVI.H D0, 0x7F7F  |  NOP  |  NOP  }
;Reg[D0] = 0x7F7F_8080

{  NOP  |  NOP  |  MOVI.L D1, 0x0101  |  NOP  |  NOP  }
;Reg[D1] = 0xFFFF_0101

{  NOP  |  NOP  |  MOVI.H D1, 0x7FFF |  NOP  |  NOP  }
;Reg[D1] = 0x7FFF_0101

{  NOP  |  NOP  |  ADDC D2, D0, D1   |  NOP  |  NOP  }
;Reg[D2] = 0x7FFF_FFFF

{  NOP  |  NOP  |  NOP   |  NOP  |  NOP  }
;-------------------------------------------------------------- Store Result
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01E4] = 0x7FFF_FFFF, Reg[A0] = 0x1E00_01F8



;************************************************************** ADDU in Saturation Mode
{  NOP  |  NOP  |  MOVI.L D0, 0x8000  |  NOP  |  NOP  }
;Reg[D0] = 0x7F7F_8000 

{  NOP  |  NOP  |  MOVI.H D0, 0xFFFF  |  NOP  |  NOP  }
;Reg[D0] = 0xFFFF_8000

{  NOP  |  NOP  |  MOVI.L D1, 0x8000  |  NOP  |  NOP  }
;Reg[D1] = 0x7FFF_8000

{  NOP  |  NOP  |  MOVI.H D1, 0x0000 |  NOP  |  NOP  }
;Reg[D1] = 0x0000_8000

{  NOP  |  NOP  |  ADDU D2, D0, D1   |  NOP  |  NOP  }
;Reg[D2] = 0xFFFF_FFFF

{  NOP  |  NOP  |  NOP   |  NOP  |  NOP  }
;-------------------------------------------------------------- Store Result
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01E8] = 0xFFFF_FFFF, Reg[A0] = 0x1E00_01FC



;************************************************************** ADDU.D in Saturation Mode
{  NOP  |  NOP  |  MOVI.L D0, 0x8000  |  NOP  |  NOP  }
;Reg[D0] = 0xFFFF_8000 

{  NOP  |  NOP  |  MOVI.H D0, 0xFFFF  |  NOP  |  NOP  }
;Reg[D0] = 0xFFFF_8000

{  NOP  |  NOP  |  MOVI.L D1, 0xFFFF  |  NOP  |  NOP  }
;Reg[D1] = 0x0000_FFFF 

{  NOP  |  NOP  |  MOVI.H D1, 0x0001 |  NOP  |  NOP  }
;Reg[D1] = 0x0001_FFFF

{  NOP  |  NOP  |  ADDU.D D2, D0, D1   |  NOP  |  NOP  }
;Reg[D2] = 0xFFFF_FFFF

{  NOP  |  NOP  |  NOP   |  NOP  |  NOP  }
;-------------------------------------------------------------- Store Result
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01EC] = 0xFFFF_FFFF, Reg[A0] = 0x1E00_0200



;************************************************************** ADDU.Q in Saturation Mode
{  NOP  |  NOP  |  MOVI.L D0, 0x8080  |  NOP  |  NOP  }
;Reg[D0] = 0xFFFF_8080

{  NOP  |  NOP  |  MOVI.H D0, 0x7F7F  |  NOP  |  NOP  }
;Reg[D0] = 0x7F7F_8080

{  NOP  |  NOP  |  MOVI.L D1, 0xFFFF  |  NOP  |  NOP  }
;Reg[D1] = 0x0001_FFFF

{  NOP  |  NOP  |  MOVI.H D1, 0xF101 |  NOP  |  NOP  }
;Reg[D1] = 0xF101_FFFF

{  NOP  |  NOP  |  ADDU.Q D2, D0, D1   |  NOP  |  NOP  }
;Reg[D2] = 0xFF80_FFFF

{  NOP  |  NOP  |  NOP   |  NOP  |  NOP  }
;-------------------------------------------------------------- Store Result
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01F0] = 0xFF80_FFFF, Reg[A0] = 0x1E00_0204



;************************************************************** SUBU in Saturation Mode
{  NOP  |  NOP  |  MOVI.L D0, 0x0001  |  NOP  |  NOP  }
;Reg[D0] = 0x7F7F_0001 

{  NOP  |  NOP  |  MOVI.H D0, 0x7FFF  |  NOP  |  NOP  }
;Reg[D0] = 0x7FFF_0001

{  NOP  |  NOP  |  MOVI.L D1, 0x0001  |  NOP  |  NOP  }
;Reg[D1] = 0x0101_0001

{  NOP  |  NOP  |  MOVI.H D1, 0xFFFF |  NOP  |  NOP  }
;Reg[D1] = 0xFFFF_0001

{  NOP  |  NOP  |  SUBU D2, D0, D1   |  NOP  |  NOP  }
;Reg[D2] = 0x0000_0000

{  NOP  |  NOP  |  NOP   |  NOP  |  NOP  }
;-------------------------------------------------------------- Store Result
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01F4] = 0x0000_0000, Reg[A0] = 0x1E00_0208



;************************************************************** SUBU.D in Saturation Mode
{  NOP  |  NOP  |  MOVI.L D0, 0x8000  |  NOP  |  NOP  }
;Reg[D0] = 0x7FFF_8000 

{  NOP  |  NOP  |  MOVI.H D0, 0x7FFF  |  NOP  |  NOP  }
;Reg[D0] = 0x7FFF_8000

{  NOP  |  NOP  |  MOVI.L D1, 0x0001  |  NOP  |  NOP  }
;Reg[D1] = 0xFFFF_0001

{  NOP  |  NOP  |  MOVI.H D1, 0xFFFF |  NOP  |  NOP  }
;Reg[D1] = 0xFFFF_0001

{  NOP  |  NOP  |  SUBU.D D2, D0, D1   |  NOP  |  NOP  }
;Reg[D2] = 0x0000_7FFF

{  NOP  |  NOP  |  NOP   |  NOP  |  NOP  }
;-------------------------------------------------------------- Store Result
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01F8] = 0x0000_7FFF, Reg[A0] = 0x1E00_020C




;************************************************************** SUBU.Q in Saturation Mode
{  NOP  |  NOP  |  MOVI.L D0, 0x8080  |  NOP  |  NOP  }
;Reg[D0] = 0x7FFF_8080 

{  NOP  |  NOP  |  MOVI.H D0, 0x7F7F  |  NOP  |  NOP  }
;Reg[D0] = 0x7F7F_8080

{  NOP  |  NOP  |  MOVI.L D1, 0x0101  |  NOP  |  NOP  }
;Reg[D1] = 0xFFFF_0101

{  NOP  |  NOP  |  MOVI.H D1, 0xFFFF |  NOP  |  NOP  }
;Reg[D1] = 0xFFFF_0101

{  NOP  |  NOP  |  SUBU.Q D2, D0, D1   |  NOP  |  NOP  }
;Reg[D2] = 0x0000_7F7F

{  NOP  |  NOP  |  NOP   |  NOP  |  NOP  }
;-------------------------------------------------------------- Store Result
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01FC] = 0x0000_7F7F, Reg[A0] = 0x1E00_0210




;************************************************************** Program Terminate
{  TRAP  |  NOP  |  NOP  |  NOP  |  NOP  }
