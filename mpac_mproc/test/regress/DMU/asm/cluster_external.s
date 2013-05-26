
  BASE_ADDR = 0x2400

	{  MOVI R0, 0x30070000 		|  MOVI.L A0, 0x1000 	 |  NOP  |  MOVI.L A0, 0x2000	  |  NOP  }
	{  MOVI R3, 0x00000000 		|  MOVI.H A0, 0x3007	 |  NOP  |  MOVI.H A0, 0x3007	  |  NOP  }
	{  MOVI R4, 0x00000000 		|  MOVI.L D0, 0x7788	 |  NOP  |  MOVI.L D0, 0xBBCC	  |  NOP  }
	{  MOVI R5, 0x11223344		|  MOVI.H D0, 0x5566	 |  NOP  |  MOVI.H D0, 0x99AA   |  NOP  }
	{  MOVI R6, 0x00000000 		|  MOVI.L D1, 0x0000	 |  NOP  |  MOVI.L D1, 0x0000	  |  NOP  }
	{  MOVI R7, 0x00000000		|  MOVI.H D1, 0x0000	 |  NOP  |  MOVI.H D1, 0x0000   |  NOP  }
	{  MOVI.L R1, 0x0000  		|  MOVI.L D2, 0x0000	 |  NOP  |  MOVI.L D2, 0x0000	  |  NOP  }
	{  MOVI.H R1, BASE_ADDR   |  MOVI.H D2, 0x0000	 |  NOP  |  MOVI.H D2, 0x0000   |  NOP  }
	{  NOP								 		|  MOVI.L D3, 0x0000	 |  NOP  |  MOVI.L D3, 0x0000	  |  NOP  }
	{  NOP										|  MOVI.H D3, 0x0000	 |  NOP  |  MOVI.H D3, 0x0000   |  NOP  }
	{  NOP  									|  MOVI.L A1, 0x0000   |  NOP  |  MOVI.L A1, 0x0000   |  NOP  }
	{  NOP  									|  MOVI.H A1, BASE_ADDR|  NOP  |  MOVI.H A1, BASE_ADDR|  NOP  }
	{  SW R5, R0, 0+   			|  SW D0, A0, 0+  |  NOP  |  SW D0, A0, 0+  |  NOP  }
	{  NOP         	|  NOP  |  NOP  |  NOP  |  NOP  }
	{  NOP         	|  NOP  |  NOP  |  NOP  |  NOP  }
	{  NOP         	|  NOP  |  NOP  |  NOP  |  NOP  }
	{  NOP         	|  NOP  |  NOP  |  NOP  |  NOP  }
	{  NOP         	|  NOP  |  NOP  |  NOP  |  NOP  }
	{  LW R3, R0, 6+   			|  LW D1, A0, 6+  |  NOP  |  LW D1, A0, 6+	|  NOP  }
	{  NOP         	|  NOP  |  NOP  |  NOP  |  NOP  }
	{  NOP         	|  NOP  |  NOP  |  NOP  |  NOP  }
	{  SW R3, R1, 0 |  SW D1, A1, 4 |  NOP  |  SW D1, A1, 8  |  NOP  }   ;<<add by ponpon
	{  NOP         	|  NOP  |  NOP  |  NOP  |  NOP  }
	{  NOP         	|  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0000] = 0x11223344	
;Mem[0x1E00_0004] = 0x55667788
;Mem[0x1E00_0008] = 0x99AABBCC
	{  SH R5, R0, 0+   			|  SH D0, A0, 0+  |  NOP  |  SH D0, A0, 0+  |  NOP  }
	{  NOP         	|  NOP  |  NOP  |  NOP  |  NOP  }
	{  NOP         	|  NOP  |  NOP  |  NOP  |  NOP  }
	{  NOP          |  NOP  |  NOP  |  NOP  |  NOP  }
	{  NOP         	|  NOP  |  NOP  |  NOP  |  NOP  }
	{  NOP         	|  NOP  |  NOP  |  NOP  |  NOP  }
	{  LHU R4, R0, 3+   			|  LHU D2, A0, 3+  |  NOP  |  LHU D2, A0, 3+	|  NOP  }
	{  NOP         	|  NOP  |  NOP  |  NOP  |  NOP  }
	{  NOP         	|  NOP  |  NOP  |  NOP  |  NOP  }
	{  SW R4, R1, 12 |  SW D2, A1, 16  |  NOP  |  SW D2, A1, 20  |  NOP  }  ;<<add by ponpon
	{  NOP         	|  NOP  |  NOP  |  NOP  |  NOP  }
	{  NOP         	|  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_000C] = 0x00003344	
;Mem[0x1E00_0010] = 0x00007788
;Mem[0x1E00_0014] = 0x0000BBCC	
	{  SB R5, R0, 0+   			|  SB D0, A0, 0+  |  NOP  |  SB D0, A0, 0+  |  NOP  }
	{  NOP         	|  NOP  |  NOP  |  NOP  |  NOP  }
	{  NOP         	|  NOP  |  NOP  |  NOP  |  NOP  }
	{  NOP         	|  NOP  |  NOP  |  NOP  |  NOP  }
	{  NOP         	|  NOP  |  NOP  |  NOP  |  NOP  }
	{  NOP         	|  NOP  |  NOP  |  NOP  |  NOP  }
	{  LBU R6, R0, 3+ |  LBU D3, A0, 3+  |  NOP  |  LBU D3, A0, 3+	|  NOP  }
	{  NOP         	|  NOP  |  NOP  |  NOP  |  NOP  }
	{  NOP         	|  NOP  |  NOP  |  NOP  |  NOP  }
	{  SW R6, R1, 24 |  SW D3, A1, 28  |  NOP  |  SW D3, A1, 32  |  NOP  }
	{  NOP         	|  NOP  |  NOP  |  NOP  |  NOP  }
	{  NOP         	|  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0018] = 0x00000044	
;Mem[0x1E00_001C] = 0x00000088
;Mem[0x1E00_0020] = 0x000000CC		
	{  SW R5, R0, 0+   			|  SW D0, A0, 0+  |  NOP  |  SW D0, A0, 0+  |  NOP  }
	{  NOP         	|  NOP  |  NOP  |  NOP  |  NOP  }
	{  NOP         	|  NOP  |  NOP  |  NOP  |  NOP  }
	{  NOP         	|  NOP  |  NOP  |  NOP  |  NOP  }
	{  NOP         	|  NOP  |  NOP  |  NOP  |  NOP  }
	{  NOP         	|  NOP  |  NOP  |  NOP  |  NOP  }
	{  LW R7, R0, 6+   			|  NOP  |  NOP  |  NOP	|  NOP  }
	{  NOP         	|  LW D4, A0, 0+  |  NOP  |  NOP  |  NOP  }
	{  NOP         	|  NOP  |  NOP  |  LW D4, A0, 0+  |  NOP  }
	{  NOP         	|  NOP  |  NOP  |  NOP  |  NOP  }
	{  NOP         	|  NOP  |  NOP  |  NOP  |  NOP  }
	{  SW R7, R1, 36 |  SW D4, A1, 40  |  NOP  |  SW D4, A1, 44  |  NOP  }
	{  NOP         	|  NOP  |  NOP  |  NOP  |  NOP  }
	{  NOP         	|  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0024] = 0x11223344	
;Mem[0x1E00_0028] = 0x55667788
;Mem[0x1E00_002C] = 0x99AABBCC
	

  	                           	
	{  TRAP                    	|  NOP  |  NOP  |  NOP  |  NOP  }

