
BASE_ADDR = 0x2400
  
;================================================================= 
;test

{	NOP	|	MOVI.H A2,BASE_ADDR	|	MOVI.H D15,BASE_ADDR	|	MOVI.H A2,BASE_ADDR	|	MOVI.H D15,BASE_ADDR	}
{ NOP	|	MOVI.H A3,BASE_ADDR	|	NOP                 	|	MOVI.H A3,BASE_ADDR	|	NOP	                  }
{	NOP	|	MOVI.H A4,BASE_ADDR	|	NOP	                  |	MOVI.H A4,BASE_ADDR	|	NOP	}

{	MOVIU R2,2	|	MOVI.L A2,0x0050	|	MOVI.L D15,0x0070	|	MOVI.L A2,0x0058	|	MOVI.L D15,0x0072	}
{	MOVIU R1,10	|	MOVI.L A3,0x0070	|	DCLR D10	        |	MOVI.L A3,0x0072	|	DCLR D10	}
{	NOP	        |	MOVI.L A4,0x0000	|	NOP             	|	MOVI.L A4,0x0002	|	NOP	}
InverseCoefficient:										
{	NOP	|	DLW D2,A2, 0	|	NOP	|	DLW D2,A2, 16	|	NOP	}
{	NOP	|	DLW D8,A2, 8	|	NOP	|	DLW D8,A2, 8	|	NOP	}
{	NOP	|	DSW D10,D11,A3,8	|	NOP	|	DSW D10,D11,A3,14	|	NOP	}
{	NOP	|	DSW D10,D11,A3,0	|	PERMH4 D6,D2,D3,3,2,1,0	|	SW D10,A3,22	|	PERMH4 D6,D2,D3,3,2,1,0	}
{	NOP	|	DSW D6,D7,A2,24	|	PERMH4 D12,D8,D9,3,2,1,0	|	DSW D6,D7,A2,(-8)	|	PERMH4 D12,D8,D9,3,2,1,0	}
{	NOP	|	DSW D12,D13,A2,16	|	NOP	|	DSW D12,D13,A2,0	|	NOP	}
CopyDelayLine:										
{	NOP	|	NOP	|	NOP	|	SH D10,A3,26	|	NOP	}
_LOOP1:										
{	NOP	|	DLW D0,A2, 8+	|	NOP	|	DLW D2,A2, (-8)+	|	NOP	}
{	NOP	|	DLNW D4,A3, 8+	|	NOP	|	NOP	|	NOP	}
{	NOP	|	NOP	|	NOP	|	DLNW D4,A3, 8+	|	NOP	}
{	NOP	|	DLW D2,A2, 8+	|	NOP	|	DLW D0,A2, 16+	|	NOP	}
{	NOP	|	DLNW D6,A3, 8+	|	DCLR AC0	|	NOP	|	DCLR AC0	}
{	NOP	|	NOP	|	DCLR AC2	|	DLNW D6,A3, 8+	|	DCLR AC2	}
_LOOP2:										
{	NOP	|	DLNW D4,A3, 8+	|	FMAC.D AC0,D0,D4	|	NOP	|	FMAC.D AC0,D0,D4	}
{	NOP	|	NOP	|	FMAC.D AC2,D0,D5	|	DLW D0,A2, 8+	|	FMAC.D AC2,D0,D5	}
{	LBCB R2,_LOOP2	|	DLW D0,A2, 8+	|	FMAC.D AC0,D1,D5	|	NOP	|	FMAC.D AC0,D1,D5	}
{	NOP	|	NOP	|	FMAC.D AC2,D1,D6	|	DLNW D4,A3, 8+	|	FMAC.D AC2,D1,D6	}
{	NOP	|	DLNW D6,A3, 8+	|	FMAC.D AC0,D2,D6	|	NOP	|	FMAC.D AC0,D2,D6	}
{	NOP	|	NOP	|	FMAC.D AC2,D2,D7	|	DLW D2,A2, 8+	|	FMAC.D AC2,D2,D7	}
{	NOP	|	DLW D2,A2, 8+	|	FMAC.D AC0,D3,D7	|	NOP	|	FMAC.D AC0,D3,D7	}
{	NOP	|	NOP	|	FMAC.D AC2,D3,D4	|	DLNW D6,A3, 8+	|	FMAC.D AC2,D3,D4	}
{	LBCB R1,_LOOP1	|	NOP	|	ADD AC0,AC0,AC1	|	NOP	|	ADD AC0,AC0,AC1	}
{	MOVIU R2,2	|	MOVI.L A2,0x0050	|	SRAI  D0,AC0,18	|	MOVI.L A2,0x0058	|	ADD AC1,AC2,AC3	}
{	NOP	|	SH D0,A4, 4+	|	ADD AC1,AC2,AC3	|	ADDI D15,D15,8	|	SRAI  D0,AC0,18	}
{	NOP	|	ADDI D15,D15,8	|	SRAI  D1,AC1,18	|	SH D0,A4, 4+	|	NOP	}
{	NOP	|	SH D1,A4, 4+	|	NOP	|	COPY A3,D15	|	SRAI D1,AC1,18	}
{	NOP	|	COPY A3,D15	|	NOP	|	SH D1,A4, 4+	|	NOP	}
CopyDelayLineBack:										
{	NOP	|	MOVI.L A4,0x00F0	|	NOP	|	MOVI.L A4,0x0100	|	NOP	}
{	NOP	|	DLNW D0,A3,(-2)	|	NOP	|	NOP	|	NOP	}
{	NOP	|	NOP	|	NOP	|	DLNW D0,A3,20	|	NOP	}
{	NOP	|	DLNW D2,A3,6	|	NOP	|	NOP	|	NOP	}
{	NOP	|	NOP	|	NOP	|	DLNW D2,A3,12	|	NOP	}
{	NOP	|	DSW D0,D1,A4,0	|	NOP	|	DSW D0,D1,A4,8	|	NOP	}
{	NOP	|	DSW D2,D3,A4,8	|	NOP	|	NOP	|	NOP	}
{	NOP	|	NOP	|	NOP	|	DSW D2,D3,A4,0	|	NOP	}



  { NOP | NOP | NOP | NOP | NOP }  
  { NOP | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }  
  { NOP | NOP | NOP | NOP | NOP }

{	TRAP	|	NOP	|	NOP	|	NOP	|	NOP	}
