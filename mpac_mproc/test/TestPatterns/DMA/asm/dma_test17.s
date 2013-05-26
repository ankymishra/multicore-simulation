;**********************************************************************
; To verify
; DMA
; 3.  BustoDmem, para1: TR_WIDTH = 3, SC =  1, SI = 7,  SAddr = 0x1, BSZ = 24, DC =  1, DI = 6, DAddr = 0x0.
;                para2: TR_WIDTH = 2, SC =  2, SI = 5,  SAddr = 0x0, BSZ = 19, DC =  2, DI = 1, DAddr = 0x0.
;                para3: TR_WIDTH = 1, SC =  0, SI = 0,  SAddr = 0x0, BSZ = 33, DC =  5, DI = 4, DAddr = 0x0.
;                para4: TR_WIDTH = 0, SC =  0, SI = 0,  SAddr = 0x0, BSZ = 18, DC =  5, DI = 4, DAddr = 0x0.
;**********************************************************************
.data
;16
DspDataMemAddr = 0x2400
DspDMURegister = 0x2405
ExternalMemAddr7 = 0x3007
ExternalMemAddr6 = 0x3006
ExternalMemAddr5 = 0x3005
ExternalMemAddr4 = 0x3004
DspM2MemAddr = 0x2500
.text
;************************************************************** Initial data
{  MOVI.L R0, 0x0000        |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R0, ExternalMemAddr7        |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.L R1, 0x0100        |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R1, 0x0302        |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI R2, 64              |  NOP  |  NOP  |  NOP  |  NOP  }

_LOOP:
{  SW R1, R0, 4+            |  NOP  |  NOP  |  NOP  |  NOP  }
{  ADDI R1, R1, 0x04040404  |  NOP  |  NOP  |  NOP  |  NOP  }
{  LBCB R2, _LOOP           |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

;;************************************************************** Clear status0
;{  MOVI.L R3, 0xC088  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  MOVI.H R3, DspDMURegister  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  MOVI.L R4, 0x0001  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  MOVI.H R4, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  SW R4, R3, 0       |  NOP  |  NOP  |  NOP  |  NOP  }
;;************************************************************** Clear status1
;{  MOVI.L R3, 0xC0C8  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  MOVI.H R3, DspDMURegister  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  MOVI.L R4, 0x0001  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  MOVI.H R4, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  SW R4, R3, 0       |  NOP  |  NOP  |  NOP  |  NOP  }
;;************************************************************** Clear status2
;{  MOVI.L R3, 0xC108  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  MOVI.H R3, DspDMURegister  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  MOVI.L R4, 0x0001  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  MOVI.H R4, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  SW R4, R3, 0       |  NOP  |  NOP  |  NOP  |  NOP  }
;;************************************************************** Clear status3
;{  MOVI.L R3, 0xC148  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  MOVI.H R3, DspDMURegister  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  MOVI.L R4, 0x0001  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  MOVI.H R4, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  SW R4, R3, 0       |  NOP  |  NOP  |  NOP  |  NOP  }

;************************************************************** Initial data
{  MOVI.L R0, 0x0000        |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R0, DspDataMemAddr        |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.L R1, 0x0100        |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R1, 0x0302        |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI R2, 64              |  NOP  |  NOP  |  NOP  |  NOP  }

_LOOP2:
{  SW R1, R0, 4+            |  NOP  |  NOP  |  NOP  |  NOP  }
{  ADDI R1, R1, 0x04040404  |  NOP  |  NOP  |  NOP  |  NOP  }
{  LBCB R2, _LOOP2           |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

;************************************************************** Initial data
{  MOVI.L R0, 0x3000        |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R0, DspDataMemAddr        |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.L R1, 0x0100        |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R1, 0x0302        |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI R2, 64              |  NOP  |  NOP  |  NOP  |  NOP  }

_LOOP1:
{  SW R1, R0, 4+            |  NOP  |  NOP  |  NOP  |  NOP  }
{  ADDI R1, R1, 0x04040404  |  NOP  |  NOP  |  NOP  |  NOP  }
{  LBCB R2, _LOOP1           |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

;************************************************************** Initial data
{  MOVI.L R0, 0x4000        |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R0, DspDataMemAddr        |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.L R1, 0x0100        |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R1, 0x0302        |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI R2, 64              |  NOP  |  NOP  |  NOP  |  NOP  }

_LOOP3:
{  SW R1, R0, 4+            |  NOP  |  NOP  |  NOP  |  NOP  }
{  ADDI R1, R1, 0x04040404  |  NOP  |  NOP  |  NOP  |  NOP  }
{  LBCB R2, _LOOP3           |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

;Use sc, c1, c2 set ch0, ch1, ch2
;************************************************************** Parameter0
{  MOVI.L R3, 0xC070  |  MOVI.L A0, 0xC0B0  |  NOP  |  MOVI.L A3, 0xC0F0  |  NOP  }
{  MOVI.H R3, DspDMURegister  |  MOVI.H A0, DspDMURegister  |  NOP  |  MOVI.H A3, DspDMURegister  |  NOP  }
;SAR
{  MOVI.L R4, 0x0003  |  MOVI.L A1, 0x00A3  |  NOP  |  MOVI.L A4, 0x0020  |  NOP  }
{  MOVI.H R4, ExternalMemAddr7  |  MOVI.H A1, ExternalMemAddr7  |  NOP  |  MOVI.H A4, DspDataMemAddr  |  NOP  }
{  SW R4, R3, 0       |  SW A1, A0, 0       |  NOP  |  SW A4, A3, 0       |  NOP  }
;DAR
{  MOVI.L R4, 0x7004  |  MOVI.L A1, 0x50E0  |  NOP  |  MOVI.L A4, 0x3014  |  NOP  }
{  MOVI.H R4, DspDataMemAddr  |  MOVI.H A1, DspDataMemAddr  |  NOP  |  MOVI.H A4, ExternalMemAddr7  |  NOP  }
{  SW R4, R3, 4       |  SW A1, A0, 4       |  NOP  |  SW A4, A3, 4       |  NOP  }
;SGR
{  MOVI.L R4, 0x001B  |  MOVI.L A1, 0x000A  |  NOP  |  MOVI.L A4, 0x0012  |  NOP  }
{  MOVI.H R4, 0x0070  |  MOVI.H A1, 0x0080  |  NOP  |  MOVI.H A4, 0x00F0  |  NOP  }
{  SW R4, R3, 8       |  SW A1, A0, 8       |  NOP  |  SW A4, A3, 8       |  NOP  }
;DSR
{  MOVI.L R4, 0x0012  |  MOVI.L A1, 0x000C  |  NOP  |  MOVI.L A4, 0x410C  |  NOP  }
{  MOVI.H R4, 0x0080  |  MOVI.H A1, 0x0090  |  NOP  |  MOVI.H A4, 0x0001  |  NOP  }
{  SW R4, R3, 12      |  SW A1, A0, 12      |  NOP  |  SW A4, A3, 16      |  NOP  }
;CTL
{  MOVI.L R4, 0x8B04  |  MOVI.L A1, 0x5304  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R4, 0x0001  |  MOVI.H A1, 0x0003  |  NOP  |  NOP  |  NOP  }
{  SW R4, R3, 16      |  SW A1, A0, 16      |  NOP  |  NOP  |  NOP  }
;LLST
{  MOVI.L R4, 0x6000  |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R4, 0x1F80  |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R4, R3, 28      |  NOP  |  NOP  |  NOP  |  NOP  }
;PADD
;{  MOVI.L R4, 0x0001  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  MOVI.H R4, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  SW R4, R3, 32      |  NOP  |  NOP  |  NOP  |  NOP  }


;Use sc set ch3, c1 set ch0 llst item1, c2 set ch0 llst item2 
;************************************************************** Parameter1
{  MOVI.L R3, 0xC130  |  MOVI.L A0, 0x6000  |  NOP  |  MOVI.L A3, 0x6500  |  NOP  }
{  MOVI.H R3, DspDMURegister  |  MOVI.H A0, DspDataMemAddr  |  NOP  |  MOVI.H A3, DspDataMemAddr  |  NOP  }
;SAR
{  MOVI.L R4, 0x00A6  |  MOVI.L A1, 0x3001  |  NOP  |  MOVI.L A4, 0x4001  |  NOP  }
{  MOVI.H R4, ExternalMemAddr7  |  MOVI.H A1, DspDataMemAddr  |  NOP  |  MOVI.H A4, DspDataMemAddr  |  NOP  }
{  SW R4, R3, 0       |  MOVI.L A2, 0x1015  |  NOP  |  MOVI.L A5, 0x2050  |  NOP  }
{  NOP                |  MOVI.H A2, ExternalMemAddr7  |  NOP  |  MOVI.H A5, ExternalMemAddr7  |  NOP  }
;DAR 
{  MOVI.L R4, 0x0135  |  DSW A1, A2, A0, 0  |  NOP  |  DSW A4, A5, A3, 0  |  NOP  }
{  MOVI.H R4, DspDataMemAddr  |  NOP                |  NOP  |  NOP                |  NOP  }
{  SW R4, R3, 4       |  NOP                |  NOP  |  NOP                |  NOP  }
;SGR
{  MOVI.L R4, 0x0000  |  MOVI.L A1, 0x0007  |  NOP  |  MOVI.L A4, 0x0005  |  NOP  }
{  MOVI.H R4, 0x0000  |  MOVI.H A1, 0x0030  |  NOP  |  MOVI.H A4, 0x0030  |  NOP  }
{  SW R4, R3, 8       |  MOVI.L A2, 0x000C  |  NOP  |  MOVI.L A5, 0x000F  |  NOP  }
{  NOP                |  MOVI.H A2, 0x0070  |  NOP  |  MOVI.H A5, 0x0020  |  NOP  }
;DSR
{  MOVI.L R4, 0x0015  |  DSW A1, A2, A0, 8  |  NOP  |  DSW A4, A5, A3, 8  |  NOP  }
{  MOVI.H R4, 0x0140  |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R4, R3, 12      |  NOP  |  NOP  |  NOP  |  NOP  }
;CTL
{  MOVI.L R4, 0x0204  |  MOVI.L A1, 0x5B0C  |  NOP  |  MOVI.L A4, 0x130C  |  NOP  }
{  MOVI.H R4, 0x0005  |  MOVI.H A1, 0x0002  |  NOP  |  MOVI.H A4, 0x0001  |  NOP  }
{  SW R4, R3, 16      |  MOVI.L A2, 0x6500  |  NOP  |  SW A4, A3, 16      |  NOP  }
{  NOP                |  MOVI.H A2, 0x1F00  |  NOP  |  NOP  |  NOP  }

{  NOP                |  DSW A1, A2, A0, 16 |  NOP  |  NOP  |  NOP  }
{  NOP                |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                |  NOP  |  NOP  |  NOP  |  NOP  }

;EN ch0
{  MOVI.L R3, 0xC084  |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R3, DspDMURegister  |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.L R4, 0x0001  |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R4, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R4, R3, 0       |  NOP  |  NOP  |  NOP  |  NOP  }
;EN ch1
{  MOVI.L R3, 0xC0C4  |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R3, DspDMURegister  |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.L R4, 0x0001  |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R4, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R4, R3, 0       |  NOP  |  NOP  |  NOP  |  NOP  }
;EN ch2
{  MOVI.L R3, 0xC104  |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R3, DspDMURegister  |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.L R4, 0x0001  |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R4, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R4, R3, 0       |  NOP  |  NOP  |  NOP  |  NOP  }
;EN ch3
{  MOVI.L R3, 0xC144  |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R3, DspDMURegister  |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.L R4, 0x0001  |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R4, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R4, R3, 0       |  NOP  |  NOP  |  NOP  |  NOP  }

;************************************************************** wait until DMA done
{  MOVI.L R5, 0xC054       |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R5, DspDMURegister       |  NOP  |  NOP  |  NOP  |  NOP  }
_Label1:
{  LW R6, R5, 0            |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                     |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                     |  NOP  |  NOP  |  NOP  |  NOP  }
{  SEQI R7, P1, P2, R6, 0x00002222  |  NOP  |  NOP  |  NOP  |  NOP  }
{  (P2)B _Label1           |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                     |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                     |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                     |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                     |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                     |  NOP  |  NOP  |  NOP  |  NOP  }                     

;************************************************************** Program Terminates
{  TRAP  |  NOP  |  NOP  |  NOP  |  NOP  }
