; iir for PACv30 function-level ISS
; by asika
; 2006/01/03

BASE_ADDR = 0x2400
  
  {	MOVI.L R0, 0x10B8   	|	MOVI.L A2, 0x1000    	|	NOP	|	MOVI.L A2, 0x1000   	|	NOP	}	; add by JH
	{	MOVI.H R0, BASE_ADDR	|	MOVI.H A2, BASE_ADDR	|	NOP	|	MOVI.H A2, BASE_ADDR	|	NOP	}	
	
	{	NOP	|	MOVI.L A1, 0x10B0	|	NOP	|	MOVI.L A1, 0x10B0	|	NOP	}	 ; add by JH
	{	NOP	|	DLW D0, A2, 0	|	NOP	|	MOVI.H A1, BASE_ADDR	|	NOP	}	
	{	LW R1, R0, 0	|	MOVI.H A1, BASE_ADDR	|	NOP	|	NOP	|	NOP	}	
	
  {	NOP	|	MOVI.L A0, 0x1010	   |	NOP	|	NOP	|	NOP	}	 ; add by JH
	{	NOP	|	MOVI.H A0, BASE_ADDR |	NOP	|	DLW D2, A2, 8	|	NOP	}	
	
	{	NOP	|	MOVI.L A3, 0x1060	    |	NOP	|	NOP	|	NOP	}	; add by JH
	{	NOP	|	MOVI.H A3, BASE_ADDR	|	NOP	|	NOP	|	NOP	}	
	
_LOOP:	
	{	NOP	|	DLW D4, A1, 0	|	NOP	|	NOP	|	NOP	}	
	{	NOP	|	NOP	|	NOP	|	DLW D4, A1, 0	|	NOP	}	
	{	NOP	|	LHU D12, A0, 2+	|	NOP	|	NOP	|	NOP	}	
	{	ADDI R1, R1, -1	|	NOP	|	XMUL.D D11, D1, D4	|	NOP	|	NOP	}	
	{	SGTI R7, P2, P3, R1, 0	|	MERGEA D13, D11	|	XMUL.D AC1, D0, D4	|	NOP	|	XMUL.D AC0, D3, D5	}	
	{	NOP	|	SRAI D12, D12, 1	|	MERGEA AC1, AC1	|	NOP	|	XMUL.D AC1, D2, D5	}	
	{	NOP	|	ADD D8, D12, D13	|	NOP	|	SH D5, A1, 6	|	MERGEA D6, AC0	}	
	{	NOP	|	BDR D14	|	ADD AC2, D8, AC1	|	BDT D6	|	MERGEA D7, AC1	}	
	{	(P2)B _LOOP	|	BDR D15	|	ADD D6, D8, D8	|	BDT D7	|	NOP	}	
	{	NOP	|	SH D6, A1, 0	|	ADD D9, D14, AC2	|	NOP	|	NOP	}	
	{	NOP	|	SH D4, A1, 2	|	ADD D10, D9, D15	|	NOP	|	NOP	}	
	{	NOP	|	NOP	|	ADD D7, D9, D9	|	NOP	|	NOP	}	
	{	NOP	|	SH D7, A1, 4	|	ADD D10, D10, D10	|	NOP	|	NOP	}	
	{	NOP	|	SH D10, A3, 2+	|	NOP	|	NOP	|	NOP	}	


  { NOP | NOP | NOP | NOP | NOP }  
  { NOP | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }  
  { NOP | NOP | NOP | NOP | NOP }
	{	TRAP	|	NOP	|	NOP	|	NOP	|	NOP	}	


