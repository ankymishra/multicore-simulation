
BASE_ADDR = 0x2400

;************************************************************** Set Start Address
{  NOP  |  MOVI LS_PSR, 0x00000000  |  NOP  |  NOP  |  NOP  }

{  NOP  |  MOVI.L A0, 0x0000   |  NOP  |  NOP  |  NOP  }

{  NOP  |  MOVI.H A0, BASE_ADDR |  NOP  |  NOP  |  NOP  }

;/////////////////////////////////////// Flag & Function /////////////////////////////////////////////

;************************************************************** ADDI n/carry n/overflow
{  NOP  |  MOVI.L D0, 0xFFFF  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x0000_FFFF
;LS_PSR = 0x00

{  NOP  |  MOVI.H D0, 0x0000  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x0000_FFFF
;LS_PSR = 0x00

;-------------------------------------------------------------- 0 Byte imm
{  NOP  |  ADDI D0, D0, 0x00000000  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x0000_FFFF                      
;LS_PSR = 0x00

;-------------------------------------------------------------- 1 Byte imm
{  NOP  |  ADDI D1, D0, 0x0000002C  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x0001_002B 
;LS_PSR = 0x00

;-------------------------------------------------------------- 2 Byte imm
{  NOP  |  ADDI D2, D0, 0x0000FF2C  |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0x0001_FF2B 
;LS_PSR = 0x00

;-------------------------------------------------------------- 3 Byte imm
{  NOP  |  ADDI D3, D0, 0x0011FF2C  |  NOP  |  NOP  |  NOP  }
;Reg[D3] = 0x0012_FF2B 
;LS_PSR = 0x00

;-------------------------------------------------------------- 4 Byte imm
{  NOP  |  ADDI D4, D0, 0x2211FF2C  |  NOP  |  NOP  |  NOP  }
;Reg[D4] = 0x2212_FF2B 
;LS_PSR = 0x00
                    

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  COPY D5, LS_PSR  |  NOP  |  NOP  |  NOP   }
;Reg[D5] = 0x0000_0000
;LS_PSR = 0x00


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
{  NOP  |  MOVI.L D0, 0xFFFF |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x0000_FFFF
;LS_PSR = 0x00

{  NOP  |  MOVI.H D0, 0x7FFF  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x7FFF_FFFF
;LS_PSR = 0x00

{  NOP  |  ADDI D0, D0, 0x0001  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x8000_0000
;LS_PSR = 0x01

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  COPY D5, LS_PSR  |  NOP  |  NOP  |  NOP   }
;Reg[D5] = 0x0000_0001
;LS_PSR = 0x01

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D0, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0018] = 0x8000_0000, Reg[A0] = 0x1E00_001C

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_001C] = 0x0000_0001, Reg[A0] = 0x1E00_0020



;************************************************************** ADDI w/carry n/overflow
{  NOP  |  MOVI.L D0, 0xFFFF |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x8000_FFFF
;LS_PSR = 0x01

{  NOP  |  MOVI.H D0, 0x7FFF  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x7FFF_FFFF
;LS_PSR = 0x01

{  NOP  |  ADDI D0, D0, 0x8FFFFFFF  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x0FFF_FFFE
;LS_PSR = 0x00

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  COPY D5, LS_PSR  |  NOP  |  NOP  |  NOP   }
;Reg[D5] = 0x0000_0000
;LS_PSR = 0x00

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D0, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0020] = 0x0FFF_FFFE, Reg[A0] = 0x1E00_0024

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0024] = 0x0000_0000, Reg[A0] = 0x1E00_0028





;************************************************************** ADDI w/carry w/overflow
{  NOP  |  MOVI.L D0, 0x0000 |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x0FFF_0000
;LS_PSR = 0x00

{  NOP  |  MOVI.H D0, 0x8000  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x8000_0000
;LS_PSR = 0x00

{  NOP  |  ADDI D0, D0, 0x80000000  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x0000_0000
;LS_PSR = 0x01

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  COPY D5, LS_PSR  |  NOP  |  NOP  |  NOP   }
;Reg[D5] = 0x0000_0001
;LS_PSR = 0x01

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D0, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0028] = 0x0000_0000, Reg[A0] = 0x1E00_002C

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_002C] = 0x0000_0001, Reg[A0] = 0x1E00_0030




;************************************************************** ADD n/carry n/overflow
{  NOP  |  MOVI.L D0, 0xFFFF  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x0000_FFFF
;LS_PSR = 0x03

{  NOP  |  MOVI.H D0, 0x0000  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x0000_FFFF
;LS_PSR = 0x03

{  NOP  |  MOVI.L D1, 0x8000  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x0001_8000
;LS_PSR = 0x03

{  NOP  |  MOVI.H D1, 0x0000  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x0000_8000
;LS_PSR = 0x03

{  NOP  |  ADD D2, D0, D1  |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0x0001_7FFF
;LS_PSR = 0x00


{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  COPY D5, LS_PSR  |  NOP  |  NOP  |  NOP   }
;Reg[D5] = 0x0000_0000
;LS_PSR = 0x00

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0030] = 0x0001_7FFF, Reg[A0] = 0x1E00_0034

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0034] = 0x0000_0000, Reg[A0] = 0x1E00_0038





;************************************************************** ADD n/carry w/overflow
{  NOP  |  MOVI.L D0, 0xFFFF  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x0000_FFFF
;LS_PSR = 0x00

{  NOP  |  MOVI.H D0, 0x7FFF  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x7FFF_FFFF
;LS_PSR = 0x00

{  NOP  |  MOVI.L D1, 0x0001  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x0000_0001
;LS_PSR = 0x00

{  NOP  |  MOVI.H D1, 0x0000  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x0000_0001
;LS_PSR = 0x00

{  NOP  |  ADD D2, D0, D1  |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0x8000_0000
;LS_PSR = 0x01


{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  COPY D5, LS_PSR  |  NOP  |  NOP  |  NOP   }
;Reg[D5] = 0x0000_0001
;LS_PSR = 0x01

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0038] = 0x8000_0000, Reg[A0] = 0x1E00_003C

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_003C] = 0x0000_0001, Reg[A0] = 0x1E00_0040




;************************************************************** ADD w/carry n/overflow
{  NOP  |  MOVI.L D0, 0xFFFF  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x7FFF_FFFF
;LS_PSR = 0x01

{  NOP  |  MOVI.H D0, 0x7FFF  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x7FFF_FFFF
;LS_PSR = 0x01

{  NOP  |  MOVI.L D1, 0xFFFF  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x0000_FFFF
;LS_PSR = 0x01

{  NOP  |  MOVI.H D1, 0x8FFF  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x8FFF_FFFF
;LS_PSR = 0x01

{  NOP  |  ADD D2, D0, D1  |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0x0FFF_FFFE
;LS_PSR = 0x02


{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  COPY D5, LS_PSR  |  NOP  |  NOP  |  NOP   }
;Reg[D5] = 0x0000_0002
;LS_PSR = 0x02

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0040] = 0x0FFF_FFFE, Reg[A0] = 0x1E00_0044

{  NOP  |  SW D5, A0, 8+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0044] = 0x0000_0002, Reg[A0] = 0x1E00_004C



;************************************************************** ADD w/carry w/overflow
{  NOP  |  MOVI.L D0, 0x0000  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x7FFF_0000
;LS_PSR = 0x02

{  NOP  |  MOVI.H D0, 0x8000  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x8000_0000
;LS_PSR = 0x02

{  NOP  |  MOVI.L D1, 0x0000  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x8FFF_0000
;LS_PSR = 0x02

{  NOP  |  MOVI.H D1, 0x8000  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x8000_0000
;LS_PSR = 0x02

{  NOP  |  ADD D2, D0, D1  |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0x0000_0000
;LS_PSR = 0x03


{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  COPY D5, LS_PSR  |  NOP  |  NOP  |  NOP   }
;Reg[D5] = 0x0000_0003
;LS_PSR = 0x03

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_004C] = 0x0000_0000, Reg[A0] = 0x1E00_0050

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0050] = 0x0000_0003, Reg[A0] = 0x1E00_0054





;************************************************************** SUB n/carry n/overflow
{  NOP  |  MOVI.L D0, 0x3FFF  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x8000_3FFF
;LS_PSR = 0x03

{  NOP  |  MOVI.H D0, 0x04FF  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x04FF_3FFF
;LS_PSR = 0x03

{  NOP   |  MOVI.L D1, 0x2401  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x8000_2401
;LS_PSR = 0x03

{  NOP  |  MOVI.H D1, 0x002F  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x002F_2401
;LS_PSR = 0x03

{  NOP  |  SUB D2, D0, D1  |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0x04D0_1BFE
;LS_PSR = 0x02                                                  


{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  COPY D5, LS_PSR  |  NOP  |  NOP  |  NOP   }
;Reg[D5] = 0x0000_0002                                         
;LS_PSR = 0x02                                                 

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0054] = 0x04D0_1BFE, Reg[A0] = 0x1E00_0058

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0058] = 0x0000_0002, Reg[A0] = 0x1E00_005C         




;************************************************************** SUB n/carry w/overflow
{  NOP  |  MOVI.L D0, 0x0000  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x04FF_0000
;LS_PSR = 0x02                                                 

{  NOP  |  MOVI.H D0, 0x8FFF  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x8FFF_0000
;LS_PSR = 0x02                                                 

{  NOP  |  MOVI.L D1, 0x0000  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x002F_0000
;LS_PSR = 0x02                                                 

{  NOP  |  MOVI.H D1, 0x7FFF  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x7FFF_0000
;LS_PSR = 0x02                                                 

{  NOP  |  SUB D2, D0, D1  |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0x1000_0000
;LS_PSR = 0x03                                                 


{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  COPY D5, LS_PSR  |  NOP  |  NOP  |  NOP   }
;Reg[D5] = 0x0000_0003                                         
;LS_PSR = 0x03                                                 

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_005C] = 0x1000_0000, Reg[A0] = 0x1E00_0060

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0060] = 0x0000_0003, Reg[A0] = 0x1E00_0064        




;************************************************************** SUB w/carry n/overflow
{  NOP  |  MOVI.L D0, 0x0000  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x8FFF_0000
;LS_PSR = 0x03                                                 

{  NOP  |  MOVI.H D0, 0x1FFF  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x1FFF_0000
;LS_PSR = 0x03                                                 

{  NOP  |  MOVI.L D1, 0x0000  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x7FFF_0000
;LS_PSR = 0x03                                                 

{  NOP  |  MOVI.H D1, 0x4FFF  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x4FFF_0000
;LS_PSR = 0x03                                                 

{  NOP  |  SUB D2, D0, D1  |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0xD000_0000
;LS_PSR = 0x00                                                 


{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  COPY D5, LS_PSR  |  NOP  |  NOP  |  NOP   }
;Reg[D5] = 0x0000_0000                                         
;LS_PSR = 0x00                                                 

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0064] = 0xD000_0000, Reg[A0] = 0x1E00_0068

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0068] = 0x0000_0000, Reg[A0] = 0x1E00_006C          





;************************************************************** SUB w/carry w/overflow
{  NOP  |  MOVI.L D0, 0x0000  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x1FFF_0000
;LS_PSR = 0x00                                                  
 
{  NOP  |  MOVI.H D0, 0x7FFF  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x7FFF_0000
;LS_PSR = 0x00                                                  

{  NOP  |  MOVI.L D1, 0x0000  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x4FFF_0000
;LS_PSR = 0x00                                                  

{  NOP  |  MOVI.H D1, 0x8FFF  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x8FFF_0000
;LS_PSR = 0x00                                                  

{  NOP  |  SUB D2, D0, D1  |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0xF000_0000
;LS_PSR = 0x01                                                  


{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  COPY D5, LS_PSR  |  NOP  |  NOP  |  NOP   }
;Reg[D5] = 0x0000_0001                                          
;LS_PSR = 0x01                                                  
 
;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_006C] = 0xF000_0000, Reg[A0] = 0x1E00_0070

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0070] = 0x0000_0001, Reg[A0] = 0x1E00_0074          




;************************************************************** ADDI.D n/overflow
{  NOP  |  MOVI.L D0, 0x7FFF |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x7FFF_7FFF
;LS_PSR = 0x01

{  NOP  |  MOVI.H D0, 0x1234  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x1234_7FFF
;LS_PSR = 0x01

{  NOP  |  ADDI.D D0, D0, 0x8FFF  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0xA233_0FFE                                           <============update
;LS_PSR = 0x00

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  COPY D5, LS_PSR  |  NOP  |  NOP  |  NOP   }
;Reg[D5] = 0x0000_0000
;LS_PSR = 0x00

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D0, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0074] = 0xA233_0FFE, Reg[A0] = 0x1E00_0078          <============update

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0078] = 0x0000_0000, Reg[A0] = 0x1E00_007C




;************************************************************** ADDI.D w/overflow
{  NOP  |  MOVI.L D0, 0x7FFF |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x2468_7FFF
;LS_PSR = 0x00

{  NOP  |  MOVI.H D0, 0x1234  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x1234_7FFF
;LS_PSR = 0x00

{  NOP  |  ADDI.D D0, D0, 0x1000  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x2234_8FFF                                        <============update
;LS_PSR = 0x01

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  COPY D5, LS_PSR  |  NOP  |  NOP  |  NOP   }
;Reg[D5] = 0x0000_0001
;LS_PSR = 0x01

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D0, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_007C] = 0x2234_8FFF, Reg[A0] = 0x1E00_0080       <============update

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0080] = 0x0000_0001, Reg[A0] = 0x1E00_0084



;************************************************************** ADD.D n/overflow
{  NOP  |  MOVI.L D0, 0x7FFF  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x2468_7FFF
;LS_PSR = 0x01

{  NOP  |  MOVI.H D0, 0x1234  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x1234_7FFF
;LS_PSR = 0x01

{  NOP  |  MOVI.L D1, 0x8FFF  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x8FFF_8FFF
;LS_PSR = 0x01

{  NOP  |  MOVI.H D1, 0x1234  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x1234_8FFF
;LS_PSR = 0x01

{  NOP  |  ADD.D D2, D0, D1  |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0x2468_0FFE
;LS_PSR = 0x00


{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  COPY D5, LS_PSR  |  NOP  |  NOP  |  NOP   }
;Reg[D5] = 0x0000_0000
;LS_PSR = 0x00

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0084] = 0x2468_0FFE, Reg[A0] = 0x1E00_0088

{  NOP  |  SW D5, A0, 8+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0088] = 0x0000_0000, Reg[A0] = 0x1E00_0090




;************************************************************** ADD.D w/overflow
{  NOP  |  MOVI.L D0, 0x7FFF  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x1234_7FFF
;LS_PSR = 0x00

{  NOP  |  MOVI.H D0, 0x1234  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x1234_7FFF
;LS_PSR = 0x00

{  NOP  |  MOVI.L D1, 0x1000  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x1234_1000
;LS_PSR = 0x00

{  NOP  |  MOVI.H D1, 0x1234  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x1234_1000
;LS_PSR = 0x00

{  NOP  |  ADD.D D2, D0, D1  |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0x2468_8FFF
;LS_PSR = 0x01


{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  COPY D5, LS_PSR  |  NOP  |  NOP  |  NOP   }
;Reg[D5] = 0x0000_0001
;LS_PSR = 0x01

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0090] = 0x2468_8FFF, Reg[A0] = 0x1E00_0094

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0094] = 0x0000_0001, Reg[A0] = 0x1E00_0098




;************************************************************** SUB.D n/overflow
{  NOP  |  MOVI.L D0, 0x4FFF  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x1234_4FFF
;LS_PSR = 0x01                                                  

{  NOP  |  MOVI.H D0, 0x1234  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x1234_4FFF
;LS_PSR = 0x01                                                 

{  NOP  |  MOVI.L D1, 0x1000  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x1234_1000
;LS_PSR = 0x01

{  NOP  |  MOVI.H D1, 0x1234  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x1234_1000
;LS_PSR = 0x01

{  NOP  |  SUB.D D2, D0, D1  |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0x0000_3FFF
;LS_PSR = 0x00                                                    <============update


{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  COPY D5, LS_PSR  |  NOP  |  NOP  |  NOP   }
;Reg[D5] = 0x0000_0000                                            <============update
;LS_PSR = 0x00                                                     <============update

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0098] = 0x0000_3FFF, Reg[A0] = 0x1E00_009C

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_009C] = 0x0000_0000, Reg[A0] = 0x1E00_00A0             <============update



;************************************************************** SUB.D w/overflow
{  NOP  |  MOVI.L D0, 0x8FFF  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x1234_8FFF
;LS_PSR = 0x00                                                     <============update

{  NOP  |  MOVI.H D0, 0x1234  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x1234_4FFF
;LS_PSR = 0x00                                                    <============update

{  NOP  |  MOVI.L D1, 0x7FFF  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x1234_7FFF
;LS_PSR = 0x00                                                     <============update

{  NOP  |  MOVI.H D1, 0x1234  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x1234_7FFF
;LS_PSR = 0x00                                                     <============update

{  NOP  |  SUB.D D2, D0, D1  |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0x0000_1000
;LS_PSR = 0x01                                                     <============update
 

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  COPY D5, LS_PSR  |  NOP  |  NOP  |  NOP   }
;Reg[D5] = 0x0000_0001                                             <============update
;LS_PSR = 0x01                                                     <============update

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00A0] = 0x0000_1000, Reg[A0] = 0x1E00_00A4

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00A4] = 0x0000_0001, Reg[A0] = 0x1E00_00A8             <============update




;************************************************************** ADD.Q n/overflow
{  NOP  |  MOVI.L D0, 0x007F  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x1234_007F
;LS_PSR = 0x01

{  NOP  |  MOVI.H D0, 0x007F  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x007F_007F
;LS_PSR = 0x01

{  NOP  |  MOVI.L D1, 0x008F  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x8FFF_008F
;LS_PSR = 0x01

{  NOP  |  MOVI.H D1, 0x008F |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x008F_008F
;LS_PSR = 0x01

{  NOP  |  ADD.Q D2, D0, D1  |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0x000E_000E
;LS_PSR = 0x00


{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  COPY D5, LS_PSR  |  NOP  |  NOP  |  NOP   }
;Reg[D5] = 0x0000_0000
;LS_PSR = 0x00

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00A8] = 0x000E_000E, Reg[A0] = 0x1E00_00AC

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00AC] = 0x0000_0000, Reg[A0] = 0x1E00_00B0





;************************************************************** ADD.Q w/overflow
{  NOP  |  MOVI.L D0, 0x007F  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x007F_007F
;LS_PSR = 0x00

{  NOP  |  MOVI.H D0, 0x007F  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x007F_007F
;LS_PSR = 0x00

{  NOP  |  MOVI.L D1, 0x0010  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x008F_0010
;LS_PSR = 0x00

{  NOP  |  MOVI.H D1, 0x0010 |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x0010_0010
;LS_PSR = 0x00

{  NOP  |  ADD.Q D2, D0, D1  |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0x008F_008F
;LS_PSR = 0x01


{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  COPY D5, LS_PSR  |  NOP  |  NOP  |  NOP   }
;Reg[D5] = 0x0000_0001
;LS_PSR = 0x01

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D2, A0, 8+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00B0] = 0x008F_008F, Reg[A0] = 0x1E00_00B8

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00B8] = 0x0000_0001, Reg[A0] = 0x1E00_00BC



;************************************************************** SUB.Q n/overflow
{  NOP  |  MOVI.L D0, 0x7F7F  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x007F_7F7F
;LS_PSR = 0x01

{  NOP  |  MOVI.H D0, 0x7F7F  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x7F7F_7F7F
;LS_PSR = 0x01

{  NOP  |  MOVI.L D1, 0x3F3F  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x0010_3F3F
;LS_PSR = 0x01

{  NOP  |  MOVI.H D1, 0x3F3F  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x3F3F_3F3F
;LS_PSR = 0x01

{  NOP  |  SUB.Q D2, D0, D1  |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0x4040_4040
;LS_PSR = 0x00                                                 


{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  COPY D5, LS_PSR  |  NOP  |  NOP  |  NOP   }
;Reg[D5] = 0x0000_0002                                         
;LS_PSR = 0x00                                                 

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00BC] = 0x4040_4040, Reg[A0] = 0x1E00_00C0

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00C0] = 0x0000_0000, Reg[A0] = 0x1E00_00C4         




;************************************************************** SUB.Q w/overflow
{  NOP  |  MOVI.L D0, 0x8F8F  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x7F7F_8F8F      
;LS_PSR = 0x00                                                  

{  NOP  |  MOVI.H D0, 0x8F8F  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x8F8F_8F8F
;LS_PSR = 0x00                                                  

{  NOP  |  MOVI.L D1, 0x3F3F  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x3F3F_3F3F
;LS_PSR = 0x00                                                 

{  NOP  |  MOVI.H D1, 0x3F3F  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x3F3F_3F3F
;LS_PSR = 0x00                                                 

{  NOP  |  SUB.Q D2, D0, D1  |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0x5050_5050
;LS_PSR = 0x01                                                 


{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  COPY D5, LS_PSR  |  NOP  |  NOP  |  NOP   }
;Reg[D5] = 0x0000_0001
;LS_PSR = 0x01                                                 

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00C4] = 0x5050_5050, Reg[A0] = 0x1E00_00C8

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00C8] = 0x0000_0001, Reg[A0] = 0x1E00_00CC          



;************************************************************** ABS
{  NOP  |  MOVI.L D0, 0xFFFF  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x8F8F_FFFF
;LS_PSR = 0x01

{  NOP  |  MOVI.H D0, 0x0000  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x0000_FFFF
;LS_PSR = 0x01

{  NOP  |  MOVI.L D1, 0x0000  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x3F3F_0000
;LS_PSR = 0x01

{  NOP  |  MOVI.H D1, 0xFFFF  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0xFFFF_0000
;LS_PSR = 0x01

{  NOP  |  ABS D0, D0  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x0000_FFFF
;LS_PSR = 0x01

{  NOP  |  ABS D1, D1  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x0001_0000
;LS_PSR = 0x01


{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  COPY D5, LS_PSR  |  NOP  |  NOP  |  NOP   }
;Reg[D5] = 0x0000_0000
;LS_PSR = 0x01

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D0, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00CC] = 0x0000_FFFF, Reg[A0] = 0x1E00_00D0

{  NOP  |  SW D1, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00D0] = 0x0001_0000, Reg[A0] = 0x1E00_00D4

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00D4] = 0x0000_0000, Reg[A0] = 0x1E00_00D8			<== 3.1  <=====3.5 by jeremy




;************************************************************** ABS.D
{  NOP  |  MOVI.L D0, 0x00FF  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x0000_00FF
;LS_PSR = 0x01

{  NOP  |  MOVI.H D0, 0x00FF  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x00FF_00FF
;LS_PSR = 0x01

{  NOP  |  MOVI.L D1, 0xFF00  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x0001_FF00
;LS_PSR = 0x01

{  NOP  |  MOVI.H D1, 0xFF00  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0xFF00_FF00
;LS_PSR = 0x01

{  NOP  |  ABS.D D0, D0  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x00FF_00FF
;LS_PSR = 0x01

{  NOP  |  ABS.D D1, D1  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x0100_0100
;LS_PSR = 0x01


{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  COPY D5, LS_PSR  |  NOP  |  NOP  |  NOP   }
;Reg[D5] = 0x0000_0000
;LS_PSR = 0x01

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D0, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00D8] = 0x00FF_00FF, Reg[A0] = 0x1E00_00DC

{  NOP  |  SW D1, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00DC] = 0x0100_0100, Reg[A0] = 0x1E00_00E0

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00E0] = 0x0000_0000, Reg[A0] = 0x1E00_00E4			<== 3.1  <====3.5 jeremy




;************************************************************** ABS.Q
{  NOP  |  MOVI.L D0, 0x0F0F  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x00FF_0F0F
;LS_PSR = 0x01

{  NOP  |  MOVI.H D0, 0x0F0F  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x0F0F_0F0F
;LS_PSR = 0x01

{  NOP  |  MOVI.L D1, 0xF0F0  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x0100_F0F0
;LS_PSR = 0x01

{  NOP  |  MOVI.H D1, 0xF0F0  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0xF0F0_F0F0
;LS_PSR = 0x01

{  NOP  |  ABS.Q D0, D0  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x0F0F_0F0F
;LS_PSR = 0x01

{  NOP  |  ABS.Q D1, D1  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x1010_1010
;LS_PSR = 0x01


{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  COPY D5, LS_PSR  |  NOP  |  NOP  |  NOP   }
;Reg[D5] = 0x0000_0000
;LS_PSR = 0x01

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D0, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00E4] = 0x0F0F_0F0F, Reg[A0] = 0x1E00_00E8

{  NOP  |  SW D1, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00E8] = 0x1010_1010, Reg[A0] = 0x1E00_00EC

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00EC] = 0x0000_0000, Reg[A0] = 0x1E00_00F0			<== 3.1   <====3.5 jeremy




;************************************************************** NEG
{  NOP  |  MOVI.L D0, 0xFFFF  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x0F0F_FFFF
;LS_PSR = 0x00

{  NOP  |  MOVI.H D0, 0x0000  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x0000_FFFF
;LS_PSR = 0x00

{  NOP  |  MOVI.L D1, 0x0000  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x1010_0000
;LS_PSR = 0x00

{  NOP  |  MOVI.H D1, 0xFFFF  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0xFFFF_0000
;LS_PSR = 0x00

{  NOP  |  NEG D0, D0  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0xFFFF_0001
;LS_PSR = 0x00

{  NOP  |  NEG D1, D1  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x0001_0000
;LS_PSR = 0x00


{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  COPY D5, LS_PSR  |  NOP  |  NOP  |  NOP   }
;Reg[D5] = 0x0000_0000
;LS_PSR = 0x00

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D0, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00F0] = 0xFFFF_0001, Reg[A0] = 0x1E00_00F4

{  NOP  |  SW D1, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00F4] = 0x0001_0000, Reg[A0] = 0x1E00_00F8

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00F8] = 0x0000_0000, Reg[A0] = 0x1E00_00FC





;************************************************************** ADDC n/carry_in
{  NOP  |  MOVI.L D0, 0xFFFF  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x0000_FFFF
;LS_PSR = 0x00

{  NOP  |  MOVI.H D0, 0x7FFF  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x7FFF_FFFF
;LS_PSR = 0x00

{  NOP  |  MOVI.L D1, 0xFFFF  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x0000_FFFF
;LS_PSR = 0x00

{  NOP  |  MOVI.H D1, 0x8FFF  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x8FFF_FFFF
;LS_PSR = 0x00

{  NOP  |  ADDC D2, D0, D1  |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0x0FFF_FFFE
;LS_PSR = 0x02


{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  COPY D5, LS_PSR  |  NOP  |  NOP  |  NOP   }
;Reg[D5] = 0x0000_0002
;LS_PSR = 0x02

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00FC] = 0x0FFF_FFFE, Reg[A0] = 0x1E00_0100

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0100] = 0x0000_0002, Reg[A0] = 0x1E00_0104





;************************************************************** ADDC w/carry_in
{  NOP  |  MOVI.L D0, 0xFFFF  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x0000_FFFF
;LS_PSR = 0x02

{  NOP  |  MOVI.H D0, 0x0000  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x0000_FFFF
;LS_PSR = 0x02

{  NOP  |  MOVI.L D1, 0x0000  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x0000_0000
;LS_PSR = 0x02

{  NOP  |  MOVI.H D1, 0x0000  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x0000_0000
;LS_PSR = 0x02

{  NOP  |  ADDC D2, D0, D1  |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0x0001_0000
;LS_PSR = 0x00


{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  COPY D5, LS_PSR  |  NOP  |  NOP  |  NOP   }
;Reg[D5] = 0x0000_0000
;LS_PSR = 0x00

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0104] = 0x0001_0000, Reg[A0] = 0x1E00_0108

{  NOP  |  SW D5, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0108] = 0x0000_0000, Reg[A0] = 0x1E00_010C





;************************************************************** MERGEA, MERGES
{  NOP  |  MOVI.L D3, 0x8000  |  NOP  |  NOP  |  NOP  }
;Reg[D3] = 0x0012_8000
;LS_PSR = 0x00

{  NOP  |  MOVI.H D3, 0x7000  |  NOP  |  NOP  |  NOP  }
;Reg[D3] = 0x7000_8000
;LS_PSR = 0x00

{  NOP  |  ADDI D3, D3, 0x10000000  |  NOP  |  NOP  |  NOP  }
;Reg[D3] = 0x8000_8000
;LS_PSR = 0x01

{  NOP  |  MOVI.L D0, 0x8000  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0xFFFF_8000
;LS_PSR = 0x01

{  NOP  |  MOVI.H D0, 0x7FFF  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x7FFF_8000
;LS_PSR = 0x01

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  MERGEA D1, D0  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0xFFFF_FFFF
;LS_PSR = 0x00

{  NOP  |  MERGES D2, D0  |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0x0000_FFFF
;LS_PSR = 0x00

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  COPY D5, LS_PSR  |  NOP  |  NOP  |  NOP   }
;Reg[D5] = 0x0000_0000
;LS_PSR = 0x00

;-------------------------------------------------------------- Store Result
{  NOP  |  SW D1, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_010C] = 0xFFFF_FFFF, Reg[A0] = 0x1E00_0110

{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0110] = 0x0000_FFFF, Reg[A0] = 0x1E00_0114

{  NOP  |  SW D5, A0, 28+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0114] = 0x0000_0000, Reg[A0] = 0x1E00_0130


;///////////////////////////////////// Encoding ////////////////////////////////////////////
{  NOP  |  MOVI D15, 0x00000001  |  NOP  |  NOP  |  NOP  }
;Reg[D15] = 0x0000_0001

{  NOP  |  SLTI D0, P1, P2, D15, 0x0000FFFF  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x0000_0001, Reg[P1] = 1, Reg[P2] = 0

{  NOP  |  MOVI D0, 0x7000FFFF  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x7000_FFFF

{  NOP  |  MOVI D1, 0x00F00001  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x00F0_0001


;************************************************************** ADD
{  NOP  | (P1) ADD D2, D0, D1  |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0x70F1_0000

{  NOP  | (P2) ADD D3, D0, D1  |  NOP  |  NOP  |  NOP  }


;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D2, A0, 8+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0130] = 0x70F1_0000, Reg[A0] = 0x1E00_0138

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0138] = 0x8000_8000, Reg[A0] = 0x1E00_013C


;************************************************************** ADD.D
{  NOP  | (P1) ADD.D D2, D0, D1  |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0x70F0_0000

{  NOP  | (P2) ADD.D D3, D0, D1  |  NOP  |  NOP  |  NOP  }


;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_013C] = 0x70F0_0000, Reg[A0] = 0x1E00_0140

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0140] = 0x8000_8000, Reg[A0] = 0x1E00_0144


;************************************************************** ADD.Q
{  NOP  | (P1) ADD.Q D2, D0, D1  |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0x70F0_FF00

{  NOP  | (P2) ADD.Q D3, D0, D1  |  NOP  |  NOP  |  NOP  }


;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0144] = 0x70F0_FF00, Reg[A0] = 0x1E00_0148

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0148] = 0x8000_8000, Reg[A0] = 0x1E00_014C


;************************************************************** SUB
{  NOP  | (P1) SUB D2, D0, D1  |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0x6F10_FFFE

{  NOP  | (P2) SUB D3, D0, D1  |  NOP  |  NOP  |  NOP  }


;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_014C] = 0x6F10_FFFE, Reg[A0] = 0x1E00_0150

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0150] = 0x8000_8000, Reg[A0] = 0x1E00_0154



;************************************************************** SUB.D
{  NOP  | (P1) SUB.D D2, D0, D1  |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0x6F10_FFFE

{  NOP  | (P2) SUB.D D3, D0, D1  |  NOP  |  NOP  |  NOP  }


;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0154] = 0x6F10_FFFE, Reg[A0] = 0x1E00_0158

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0158] = 0x8000_8000, Reg[A0] = 0x1E00_015C



;************************************************************** SUB.Q
{  NOP  | (P1) SUB.Q D2, D0, D1  |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0x7010_FFFE

{  NOP  | (P2) SUB.Q D3, D0, D1  |  NOP  |  NOP  |  NOP  }


;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_015C] = 0x7010_FFFE, Reg[A0] = 0x1E00_0160

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0160] = 0x8000_8000, Reg[A0] = 0x1E00_0164



;************************************************************** ABS
{  NOP  | (P1) ABS D2, D0  |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0x7000_FFFF

{  NOP  | (P2) ABS D3, D0  |  NOP  |  NOP  |  NOP  }


;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0164] = 0x7000_FFFF, Reg[A0] = 0x1E00_0168

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0168] = 0x8000_8000, Reg[A0] = 0x1E00_016C




;************************************************************** ABS.D
{  NOP  | (P1) ABS.D D2, D0  |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0x7000_0001

{  NOP  | (P2) ABS.D D3, D0  |  NOP  |  NOP  |  NOP  }


;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_016C] = 0x7000_0001, Reg[A0] = 0x1E00_0170

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0170] = 0x8000_8000, Reg[A0] = 0x1E00_0174




;************************************************************** ABS.Q
{  NOP  | (P1) ABS.Q D2, D0  |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0x7000_0101

{  NOP  | (P2) ABS.Q D3, D0  |  NOP  |  NOP  |  NOP  }


;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0174] = 0x7000_0101, Reg[A0] = 0x1E00_0178

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0178] = 0x8000_8000, Reg[A0] = 0x1E00_017C


;************************************************************** ADDI
{  NOP  | (P1) ADDI D2, D0, 0x70F00001  |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0xE0F1_0000

{  NOP  | (P2) ADDI D3, D0, 0x70F00001  |  NOP  |  NOP  |  NOP  }


;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_017C] = 0xE0F1_0000, Reg[A0] = 0x1E00_0180

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0180] = 0x8000_8000, Reg[A0] = 0x1E00_0184


;************************************************************** ADDI.D
{  NOP  | (P1) ADDI.D D2, D0, 0x0010  |  NOP  |  NOP  |  NOP  }    
;Reg[D2] = 0x7010_000F                                               <============update

{  NOP  | (P2) ADDI.D D3, D0, 0x0010  |  NOP  |  NOP  |  NOP  }    
                                           

;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0184] = 0x7010_000F, Reg[A0] = 0x1E00_0188               <============update

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0188] = 0x8000_8000, Reg[A0] = 0x1E00_018C


;************************************************************** NEG
{  NOP  | (P1) NEG D2, D0  |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0x8FFF_0001

{  NOP  | (P2) NEG D3, D0  |  NOP  |  NOP  |  NOP  }


;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_018C] = 0x8FFF_0001, Reg[A0] = 0x1E00_0190

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0190] = 0x8000_8000, Reg[A0] = 0x1E00_0194


;************************************************************** MERGEA
{  NOP  | (P1) MERGEA D2, D0  |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0x 0000_6FFF

{  NOP  | (P2) MERGEA D3, D0  |  NOP  |  NOP  |  NOP  }


;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0194] = 0x0000_6FFF, Reg[A0] = 0x1E00_0198

{  NOP  |  SW D3, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0198] = 0x8000_8000, Reg[A0] = 0x1E00_019C




;************************************************************** MERGES
{  NOP  | (P1) MERGES D2, D0  |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0x0000_7001

{  NOP  | (P2) MERGES D3, D0  |  NOP  |  NOP  |  NOP  }


;-------------------------------------------------------------- Store Result 
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_019C] = 0x0000_7001, Reg[A0] = 0x1E00_01A0

{  NOP  |  SW D3, A0, 36+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01A0] = 0x8000_8000, Reg[A0] = 0x1E00_01C4


;///////////////////////////////////// Saturation ////////////////////////////////////////////

;************************************************************** Set Saturation Mode
{  NOP  |  MOVI LS_PSR, 0x000001C |  NOP  |  NOP  |  NOP  }
;LS_PSR[4](Sat_Q) = 0x1, LS_PSR[3](Sat_D) = 0x1, LS_PSR[2](Sat_S) = 0x1
;																	<============update for PACv3.1

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }


;************************************************************** ADDI, ADDI.D in Saturation Mode
{  NOP  |  MOVI.L D0, 0x8000 |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0xFFFF_8000 

{  NOP  |  MOVI.H D0, 0x7FFF |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x7FFF_8000 

{  NOP  |  ADDI.D D1, D0, 0xFFFF  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x7FFE_8000                                                 <============update

{  NOP  |  ADDI D2, D0, 0x00008000  |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0x7FFF_FFFF
;-------------------------------------------------------------- Store Result
{  NOP  |  SW D1, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01C4] = 0x7FFE_8000, Reg[A0] = 0x1E00_01C8                 <============update

{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01C8] = 0x7FFF_FFFF, Reg[A0] = 0x1E00_01CC


;************************************************************** ADD in Saturation Mode
{  NOP  |  MOVI.L D0, 0x8000  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x7FFF_8000 

{  NOP  |  MOVI.H D0, 0x7FFF  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x7FFF_8000

{  NOP  |  MOVI.L D1, 0x8000  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x7FFF_8000

{  NOP  |  MOVI.H D1, 0x0000 |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x0000_8000

{  NOP  |  ADD D2, D0, D1   |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0x7FFF_FFFF

{  NOP  |  NOP  |  NOP   |  NOP  |  NOP  }
;-------------------------------------------------------------- Store Result
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01CC] = 0x7FFF_FFFF, Reg[A0] = 0x1E00_01D0


;************************************************************** ADD.D in Saturation Mode
{  NOP  |  MOVI.L D0, 0x8000  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x7FFF_8000 

{  NOP  |  MOVI.H D0, 0x7FFF  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x7FFF_8000

{  NOP  |  MOVI.L D1, 0xFFFF  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x0000_FFFF 

{  NOP  |  MOVI.H D1, 0x0001 |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x0001_FFFF

{  NOP  |  ADD.D D2, D0, D1   |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0x7FFF_8000

{  NOP  |  NOP  |  NOP   |  NOP  |  NOP  }
;-------------------------------------------------------------- Store Result
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01D0] = 0x7FFF_8000, Reg[A0] = 0x1E00_01D4


;************************************************************** ADD.Q in Saturation Mode
{  NOP  |  MOVI.L D0, 0x8080  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x7FFF_8080

{  NOP  |  MOVI.H D0, 0x7F7F  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x7F7F_8080

{  NOP  |  MOVI.L D1, 0xFFFF  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x0001_FFFF

{  NOP  |  MOVI.H D1, 0x0101 |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x0101_FFFF

{  NOP  |  ADD.Q D2, D0, D1   |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0x7F7F_8080

{  NOP  |  NOP  |  NOP   |  NOP  |  NOP  }
;-------------------------------------------------------------- Store Result
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01D4] = 0x7F7F_8080, Reg[A0] = 0x1E00_01D8


;************************************************************** SUB in Saturation Mode
{  NOP  |  MOVI.L D0, 0x0001  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x7F7F_0001 

{  NOP  |  MOVI.H D0, 0x7FFF  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x7FFF_0001

{  NOP  |  MOVI.L D1, 0x0001  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x0101_0001

{  NOP  |  MOVI.H D1, 0xFFFF |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0xFFFF_0001

{  NOP  |  SUB D2, D0, D1   |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0x7FFF_FFFF

{  NOP  |  NOP  |  NOP   |  NOP  |  NOP  }
;-------------------------------------------------------------- Store Result
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01D8] = 0x7FFF_FFFF, Reg[A0] = 0x1E00_01DC


;************************************************************** SUB.D in Saturation Mode
{  NOP  |  MOVI.L D0, 0x8000  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x7FFF_8000 

{  NOP  |  MOVI.H D0, 0x7FFF  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x7FFF_8000

{  NOP  |  MOVI.L D1, 0x0001  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0xFFFF_0001

{  NOP  |  MOVI.H D1, 0xFFFF |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0xFFFF_0001

{  NOP  |  SUB.D D2, D0, D1   |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0x7FFF_8000

{  NOP  |  NOP  |  NOP   |  NOP  |  NOP  }
;-------------------------------------------------------------- Store Result
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01DC] = 0x7FFF_8000, Reg[A0] = 0x1E00_01E0


;************************************************************** SUB.Q in Saturation Mode
{  NOP  |  MOVI.L D0, 0x8080  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x7FFF_8080 

{  NOP  |  MOVI.H D0, 0x7F7F  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x7F7F_8080

{  NOP  |  MOVI.L D1, 0x0101  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0xFFFF_0101

{  NOP  |  MOVI.H D1, 0xFFFF  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0xFFFF_0101

{  NOP  |  SUB.Q D2, D0, D1   |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0x7F7F_8080

{  NOP  |  NOP  |  NOP   |  NOP  |  NOP  }
;-------------------------------------------------------------- Store Result
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01E0] = 0x7F7F_8080, Reg[A0] = 0x1E00_01E4


;************************************************************** ADDC in Saturation Mode
{  NOP  |  ADDI D3, D1, 0xFFFF0000  |  NOP  |  NOP  |  NOP  }
;Reg[D3] = 0xFFFE_0101
;LS_PSR = 0x1E

{  NOP  |  MOVI.L D0, 0x8080  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x7FFF_8080 

{  NOP  |  MOVI.H D0, 0x7F7F  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x7F7F_8080

{  NOP  |  MOVI.L D1, 0x0101  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0xFFFF_0101

{  NOP  |  MOVI.H D1, 0x7FFF |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x7FFF_0101

{  NOP  |  ADDC D2, D0, D1   |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0x7FFF_FFFF

{  NOP  |  NOP  |  NOP   |  NOP  |  NOP  }
;-------------------------------------------------------------- Store Result
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01E4] = 0x7FFF_FFFF, Reg[A0] = 0x1E00_01E8



;************************************************************** ADDU in Saturation Mode
{  NOP  |  MOVI.L D0, 0x8000  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x7F7F_8000 

{  NOP  |  MOVI.H D0, 0xFFFF  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0xFFFF_8000

{  NOP  |  MOVI.L D1, 0x8000  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x7FFF_8000

{  NOP  |  MOVI.H D1, 0x0000 |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x0000_8000

{  NOP  |  ADDU D2, D0, D1   |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0xFFFF_FFFF

{  NOP  |  NOP  |  NOP   |  NOP  |  NOP  }
;-------------------------------------------------------------- Store Result
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01E8] = 0xFFFF_FFFF, Reg[A0] = 0x1E00_01EC



;************************************************************** ADDU.D in Saturation Mode
{  NOP  |  MOVI.L D0, 0x8000  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0xFFFF_8000 

{  NOP  |  MOVI.H D0, 0xFFFF  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0xFFFF_8000

{  NOP  |  MOVI.L D1, 0xFFFF  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x0000_FFFF 

{  NOP  |  MOVI.H D1, 0x0001  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x0001_FFFF

{  NOP  |  ADDU.D D2, D0, D1   |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0xFFFF_FFFF

{  NOP  |  NOP  |  NOP   |  NOP  |  NOP  }
;-------------------------------------------------------------- Store Result
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01EC] = 0xFFFF_FFFF, Reg[A0] = 0x1E00_01F0



;************************************************************** ADDU.Q in Saturation Mode
{  NOP  |  MOVI.L D0, 0x8080  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0xFFFF_8080

{  NOP  |  MOVI.H D0, 0x7F7F  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x7F7F_8080

{  NOP  |  MOVI.L D1, 0xFFFF  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x0001_FFFF

{  NOP  |  MOVI.H D1, 0xF101  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0xF101_FFFF

{  NOP  |  ADDU.Q D2, D0, D1  |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0xFF80_FFFF

{  NOP  |  NOP  |  NOP   |  NOP  |  NOP  }
;-------------------------------------------------------------- Store Result
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01F0] = 0xFF80_FFFF, Reg[A0] = 0x1E00_01F4



;************************************************************** SUBU in Saturation Mode
{  NOP  |  MOVI.L D0, 0x0001  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x7F7F_0001 

{  NOP  |  MOVI.H D0, 0x7FFF  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x7FFF_0001

{  NOP  |  MOVI.L D1, 0x0001  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0x0101_0001

{  NOP  |  MOVI.H D1, 0xFFFF |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0xFFFF_0001

{  NOP  |  SUBU D2, D0, D1   |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0x0000_0000

{  NOP  |  NOP  |  NOP   |  NOP  |  NOP  }
;-------------------------------------------------------------- Store Result
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01F4] = 0x0000_0000, Reg[A0] = 0x1E00_01F8



;************************************************************** SUBU.D in Saturation Mode
{  NOP  |  MOVI.L D0, 0x8000  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x7FFF_8000 

{  NOP  |  MOVI.H D0, 0x7FFF  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x7FFF_8000

{  NOP  |  MOVI.L D1, 0x0001  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0xFFFF_0001

{  NOP  |  MOVI.H D1, 0xFFFF |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0xFFFF_0001

{  NOP  |  SUBU.D D2, D0, D1   |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0x0000_7FFF

{  NOP  |  NOP  |  NOP   |  NOP  |  NOP  }
;-------------------------------------------------------------- Store Result
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01F8] = 0x0000_7FFF, Reg[A0] = 0x1E00_01FC




;************************************************************** SUBU.Q in Saturation Mode
{  NOP  |  MOVI.L D0, 0x8080  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x7FFF_8080 

{  NOP  |  MOVI.H D0, 0x7F7F  |  NOP  |  NOP  |  NOP  }
;Reg[D0] = 0x7F7F_8080

{  NOP  |  MOVI.L D1, 0x0101  |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0xFFFF_0101

{  NOP  |  MOVI.H D1, 0xFFFF |  NOP  |  NOP  |  NOP  }
;Reg[D1] = 0xFFFF_0101

{  NOP  |  SUBU.Q D2, D0, D1  |  NOP  |  NOP  |  NOP  }
;Reg[D2] = 0x0000_7F7F

{  NOP  |  NOP  |  NOP   |  NOP  |  NOP  }
;-------------------------------------------------------------- Store Result
{  NOP  |  SW D2, A0, 4+    |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01FC] = 0x0000_7F7F, Reg[A0] = 0x1E00_0200



;************************************************************** Program Terminate
{  TRAP  |  NOP  |  NOP  |  NOP  |  NOP  }
