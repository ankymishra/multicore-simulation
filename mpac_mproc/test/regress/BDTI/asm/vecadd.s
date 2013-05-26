; vecadd for PACv30 functional-level ISS
; by asika
; 2006/01/03

BASE_ADDR = 0x2400

  {	NOP             |	MOVI.H A0, BASE_ADDR |	NOP	|	MOVI.H A0, BASE_ADDR |	NOP	}
  {	NOP             |	MOVI.H A1, BASE_ADDR |	NOP	|	MOVI.H A1, BASE_ADDR |	NOP	}
  {	NOP             |	MOVI.H A5, BASE_ADDR |	NOP	|	MOVI.H A5, BASE_ADDR |	NOP	}
 
	{	MOVI R0, 40	    |	MOVI.L A0, 0x1000	   |	NOP	|	MOVI.L A0, 0x1008	   |	NOP	}
	{	SRAI R1, R0, 4	|	MOVI.L A1, 0x1050	   |	NOP	|	MOVI.L A1, 0x1058	   |	NOP	}
	{	ADDI R1, R1, -1	|	MOVI.L A5, 0x10A0	   |	NOP	|	MOVI.L A5, 0x10A8	   |	NOP	}
	{	SGTI R7, P2, P3, R1, 0	|	DLW D0, A0, 16+	|	NOP	|	DLW D0, A0, 16+	|	NOP	}
	{	MOVI R6, 15	|	DLW D4, A1, 16+	|	NOP	|	DLW D4, A1, 16+	|	NOP	}
	{	AND R2, R0, R6	|	DLW D2, A0, 16+	|	NOP	|	DLW D2, A0, 16+	|	NOP	}
	{	SGTI R7, P4, P5, R2, 0	|	DLW D6, A1, 16+	|	NOP	|	DLW D6, A1, 16+	|	NOP	}
_LOOP:	
	{	(P2)B _LOOP	|	DLW D0, A0, 16+	|	ADD.D D8, D0, D4	|	DLW D0, A0, 16+	|	ADD.D D8, D0, D4	}
	{	ADDI R1, R1, -1	|	DLW D4, A1, 16+	|	ADD.D D9, D1, D5	|	DLW D4, A1, 16+	|	ADD.D D9, D1, D5	}
	{	SGTI R7, P2, P3, R1, 0	|	DLW D2, A0, 16+	|	ADD.D D10, D2, D6	|	DLW D2, A0, 16+	|	ADD.D D10, D2, D6	}
	{	NOP	|	DLW D6, A1, 16+	|	ADD.D D11, D3, D7	|	DLW D6, A1, 16+	|	ADD.D D11, D3, D7	}
	{	NOP	|	DSW D8, D9, A5, 16+	|	ADD.D D12, D0, D4	|	DSW D8, D9, A5, 16+	|	ADD.D D12, D0, D4	}
	{	NOP	|	DSW D10, D11, A5, 16+	|	ADD.D D13, D1, D5	|	DSW D10, D11, A5, 16+	|	ADD.D D13, D1, D5	}
	{	NOP	|	(P4)DSW D12, D13, A5, 16+	|	NOP	|	(P4)DSW D12, D13, A5, 16+	|	NOP	}
	
	
	
  { NOP | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }  
  { NOP | NOP | NOP | NOP | NOP }
  
	{	TRAP	|	NOP	|	NOP	|	NOP	|	NOP	}
	
                            