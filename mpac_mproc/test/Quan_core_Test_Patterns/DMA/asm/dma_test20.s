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
;{  MOVI.L R3, 0x0088  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  MOVI.H R3, DspDMURegister  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  MOVI.L R4, 0x0001  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  MOVI.H R4, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  SW R4, R3, 0       |  NOP  |  NOP  |  NOP  |  NOP  }
;;************************************************************** Clear status1
;{  MOVI.L R3, 0x00A8  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  MOVI.H R3, DspDMURegister  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  MOVI.L R4, 0x0001  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  MOVI.H R4, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  SW R4, R3, 0       |  NOP  |  NOP  |  NOP  |  NOP  }
;;************************************************************** Clear status2
;{  MOVI.L R3, 0x00C8  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  MOVI.H R3, DspDMURegister  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  MOVI.L R4, 0x0001  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  MOVI.H R4, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  SW R4, R3, 0       |  NOP  |  NOP  |  NOP  |  NOP  }
;;************************************************************** Clear status3
;{  MOVI.L R3, 0x00E8  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  MOVI.H R3, DspDMURegister  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  MOVI.L R4, 0x0001  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  MOVI.H R4, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  SW R4, R3, 0       |  NOP  |  NOP  |  NOP  |  NOP  }

;************************************************************** Initial data
{  MOVI.L R0, 0x2000        |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R0, ExternalMemAddr7        |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.L R1, 0x0100        |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R1, 0x0302        |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI R2, 64              |  NOP  |  NOP  |  NOP  |  NOP  }

_LOOP4:
{  SW R1, R0, 4+            |  NOP  |  NOP  |  NOP  |  NOP  }
{  ADDI R1, R1, 0x04040404  |  NOP  |  NOP  |  NOP  |  NOP  }
{  LBCB R2, _LOOP4           |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

;************************************************************** Initial data
{  MOVI.L R0, 0x1000        |  NOP  |  NOP  |  NOP  |  NOP  }
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

;;************************************************************** Initial data
;{  MOVI.L R0, 0xB000        |  NOP  |  NOP  |  NOP  |  NOP  }
;{  MOVI.H R0, DspDataMemAddr        |  NOP  |  NOP  |  NOP  |  NOP  }
;{  MOVI.L R1, 0x0100        |  NOP  |  NOP  |  NOP  |  NOP  }
;{  MOVI.H R1, 0x0302        |  NOP  |  NOP  |  NOP  |  NOP  }
;{  MOVI R2, 64              |  NOP  |  NOP  |  NOP  |  NOP  }
;
;_LOOP1:
;{  SW R1, R0, 4+            |  NOP  |  NOP  |  NOP  |  NOP  }
;{  ADDI R1, R1, 0x04040404  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  LBCB R2, _LOOP1           |  NOP  |  NOP  |  NOP  |  NOP  }
;{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
;
;;************************************************************** Initial data
;{  MOVI.L R0, 0xC000        |  NOP  |  NOP  |  NOP  |  NOP  }
;{  MOVI.H R0, DspDataMemAddr        |  NOP  |  NOP  |  NOP  |  NOP  }
;{  MOVI.L R1, 0x0100        |  NOP  |  NOP  |  NOP  |  NOP  }
;{  MOVI.H R1, 0x0302        |  NOP  |  NOP  |  NOP  |  NOP  }
;{  MOVI R2, 64              |  NOP  |  NOP  |  NOP  |  NOP  }
;
;_LOOP3:
;{  SW R1, R0, 4+            |  NOP  |  NOP  |  NOP  |  NOP  }
;{  ADDI R1, R1, 0x04040404  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  LBCB R2, _LOOP3           |  NOP  |  NOP  |  NOP  |  NOP  }
;{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

;Set DMU Priority
{  MOVI.L R3, 0x8040  | NOP                 |  NOP  |  NOP                |  NOP  }
{  MOVI.H R3, DspDMURegister  | NOP                 |  NOP  |  NOP                |  NOP  }
{  MOVI.L R4, 0x0003  | NOP                 |  NOP  |  NOP                |  NOP  }
{  MOVI.H R4, DspDMURegister  | NOP                 |  NOP  |  NOP                |  NOP  }
{  SW R4, R3, 0       | NOP                 |  NOP  |  NOP                |  NOP  }
{  NOP                | NOP                 |  NOP  |  NOP                |  NOP  }

;Use sc, c1, set ch1, ch3, c2 set ch1 LL_Item1
;************************************************************** Parameter0
{  MOVI.L R3, 0xC0B0  |  MOVI.L A0, 0xC130  |  NOP  |  MOVI.L A3, 0x3000  |  NOP  }
{  MOVI.H R3, DspDMURegister  |  MOVI.H A0, DspDMURegister  |  NOP  |  MOVI.H A3, DspDataMemAddr  |  NOP  }
;SAR                                                ;SAR,DAR
{  MOVI.L R4, 0x0019  |  MOVI.L A1, 0x0042  |  NOP  |  MOVI.L A4, 0x0021  |  NOP  }
{  MOVI.H R4, ExternalMemAddr7  |  MOVI.H A1, ExternalMemAddr7  |  NOP  |  MOVI.H A4, ExternalMemAddr7  |  NOP  }
{  SW R4, R3, 0       |  SW A1, A0, 0       |  NOP  |  MOVI.L A5, 0x0024  |  NOP  }
;DAR                                                
{  MOVI.L R4, 0x0019  |  MOVI.L A1, 0x0044  |  NOP  |  MOVI.H A5, DspDataMemAddr  |  NOP  }
{  MOVI.H R4, DspDataMemAddr  |  MOVI.H A1, DspDataMemAddr  |  NOP  |  DSW A4, A5, A3, 0  |  NOP  }
{  SW R4, R3, 4       |  SW A1, A0, 4       |  NOP  |  NOP                |  NOP  }
;SGR                                                ;DSR,CTL
{  MOVI.L R4, 0x0000  |  MOVI.L A1, 0x0008  |  NOP  |  NOP                |  NOP  }
{  MOVI.H R4, 0x0000  |  MOVI.H A1, 0x0030  |  NOP  |  MOVI.L A4, 0x0005  |  NOP  }
{  SW R4, R3, 8       |  SW A1, A0, 8       |  NOP  |  MOVI.H A4, 0x0040  |  NOP  }
;DSR                                                
{  MOVI.L R4, 0x0000  |  MOVI.L A1, 0x0008  |  NOP  |  MOVI.L A5, 0x5A04  |  NOP  }
{  MOVI.H R4, 0x0000  |  MOVI.H A1, 0x0020  |  NOP  |  MOVI.H A5, 0x0000  |  NOP  }
{  SW R4, R3, 12      |  SW A1, A0, 12      |  NOP  |  DSW A4, A5, A3, 8  |  NOP  }
;CTL                                                ;LLST 
{  MOVI.L R4, 0x4804  |  MOVI.L A1, 0x6B04  |  NOP  |  NOP                |  NOP  }
{  MOVI.H R4, 0x0000  |  MOVI.H A1, 0x0000  |  NOP  |  NOP                |  NOP  }
{  SW R4, R3, 16      |  SW A1, A0, 16      |  NOP  |  MOVI.L A4, 0x3018  |  NOP  }
;LLST
{  MOVI.L R4, 0x3000  |  MOVI.L A1, 0x5000  |  NOP  |  MOVI.H A4, 0xCC00  |  NOP  }
{  MOVI.H R4, 0xDC00  |  MOVI.H A1, 0xCC00  |  NOP  |  SW A4, A3, 16      |  NOP  }
{  SW R4, R3, 28      |  SW A1, A0, 28      |  NOP  |  NOP                |  NOP  }

;Use sc set ch1 LL_Item2, c1 set ch1 LL_Item3, c2 set ch3 LL_item1 
;************************************************************** Parameter1
{  MOVI.L R3, 0x3018  |  MOVI.L A0, 0x3030  |  NOP  |  MOVI.L A3, 0x5000  |  NOP  }
{  MOVI.H R3, DspDataMemAddr  |  MOVI.H A0, DspDataMemAddr  |  NOP  |  MOVI.H A3, DspDataMemAddr  |  NOP  }
;SAR                  ;SAR,DAR                      ;SAR,DAR
{  MOVI.L R4, 0x002A  |  MOVI.L A1, 0x0034  |  NOP  |  MOVI.L A4, 0x0053  |  NOP  }
{  MOVI.H R4, ExternalMemAddr7  |  MOVI.H A1, ExternalMemAddr7  |  NOP  |  MOVI.H A4, ExternalMemAddr7  |  NOP  }
{  SW R4, R3, 0       |  MOVI.L A2, 0x0032  |  NOP  |  MOVI.L A5, 0x0065  |  NOP  }
{  NOP                |  MOVI.H A2, DspDataMemAddr  |  NOP  |  MOVI.H A5, DspDataMemAddr  |  NOP  } 
;DAR
{  MOVI.L R4, 0x002C  |  DSW A1, A2, A0, 0  |  NOP  |  DSW A4, A5, A3, 0  |  NOP  }
{  MOVI.H R4, DspDataMemAddr  |  NOP                |  NOP  |  NOP                |  NOP  }
{  SW R4, R3, 4       |  NOP                |  NOP  |  NOP                |  NOP  }
;CTL                  ;SGR,CTL                      ;CTL,LLST
{  MOVI.L R4, 0x1804  |  MOVI.L A1, 0x0006  |  NOP  |  MOVI.L A4, 0x2804  |  NOP  }
{  MOVI.H R4, 0x0000  |  MOVI.H A1, 0x0020  |  NOP  |  MOVI.H A4, 0x0000  |  NOP  }
{  SW R4, R3, 8       |  MOVI.L A2, 0x4104  |  NOP  |  MOVI.L A5, 0x5010  |  NOP  }
{  NOP                |  MOVI.H A2, 0x0000  |  NOP  |  MOVI.H A5, 0xC400  |  NOP  }
;LLST
{  MOVI.L R4, 0x3030  |  DSW A1, A2, A0, 8  |  NOP  |  DSW A4, A5, A3, 8  |  NOP  }
{  MOVI.H R4, 0xE800  |  NOP                |  NOP  |  NOP                |  NOP  }
{  SW R4, R3, 12      |  NOP                |  NOP  |  NOP                |  NOP  }
{  NOP                |  NOP                |  NOP  |  NOP                |  NOP  }
{  NOP                |  NOP                |  NOP  |  NOP                |  NOP  }                                                                         
{  NOP                |  NOP                |  NOP  |  NOP                |  NOP  }
{  NOP                |  NOP                |  NOP  |  NOP                |  NOP  }
{  NOP                |  NOP                |  NOP  |  NOP                |  NOP  }

;Use sc set ch3 LL_Item2, c1 set ch3 LL_item3, c2 set ch3 LL_item4 
;**************************************************************
{  MOVI.L R3, 0x5010  |  MOVI.L A0, 0x5020  |  NOP  |  MOVI.L A3, 0x5030  |  NOP  }
{  MOVI.H R3, DspDataMemAddr  |  MOVI.H A0, DspDataMemAddr  |  NOP  |  MOVI.H A3, DspDataMemAddr  |  NOP  }
;SAR                  ;SAR,DAR                      ;SAR,DAR
{  MOVI.L R4, 0x005C  |  MOVI.L A1, 0x0065  |  NOP  |  MOVI.L A4, 0x006E  |  NOP  }
{  MOVI.H R4, ExternalMemAddr7  |  MOVI.H A1, ExternalMemAddr7  |  NOP  |  MOVI.H A4, ExternalMemAddr7  |  NOP  }
{  SW R4, R3, 0       |  MOVI.L A2, 0x0075  |  NOP  |  MOVI.L A5, 0x007E  |  NOP  }
{  NOP                |  MOVI.H A2, DspDataMemAddr  |  NOP  |  MOVI.H A5, DspDataMemAddr  |  NOP  }
;DAR 
{  MOVI.L R4, 0x006C  |  DSW A1, A2, A0, 0  |  NOP  |  DSW A4, A5, A3, 0  |  NOP  }
{  MOVI.H R4, DspDataMemAddr  |  NOP                |  NOP  |  NOP                |  NOP  }
{  SW R4, R3, 4       |  NOP                |  NOP  |  NOP                |  NOP  }
;LLST                 ;CTL,LLST                      ;CTL
{  MOVI.L R4, 0x5020  |  MOVI.L A1, 0x1804  |  NOP  |  MOVI.L A4, 0x1004  |  NOP  }
{  MOVI.H R4, 0xCC00  |  MOVI.H A1, 0x0000  |  NOP  |  MOVI.H A4, 0x0000  |  NOP  }
{  SW R4, R3, 8       |  MOVI.L A2, 0x5030  |  NOP  |  SW A4, A3, 8       |  NOP  }
{  NOP                |  MOVI.H A2, 0xC800  |  NOP  |  NOP                |  NOP  }
;DSR                                                                      
{  NOP                |  DSW A1, A2, A0, 8  |  NOP  |  NOP                |  NOP  }
{  NOP                |  NOP                |  NOP  |  NOP                |  NOP  }
{  NOP                |  NOP                |  NOP  |  NOP                |  NOP  }
                                                                       

;EN ch3
{  MOVI.L R3, 0xC144  |  NOP  |  NOP  |  NOP  |  NOP  }
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



;************************************************************** wait until DMA done
{  MOVI.L R5, 0x8054       |  NOP  |  NOP  |  NOP  |  NOP  }
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
