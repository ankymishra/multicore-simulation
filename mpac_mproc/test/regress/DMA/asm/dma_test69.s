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
DspDataMemAddr = 0x2500
DspDMURegister = 0x2582
ExternalMemAddr7 = 0x3007
ExternalMemAddr6 = 0x3006
ExternalMemAddr5 = 0x3005
ExternalMemAddr4 = 0x3004
.text
;************************************************************** Initial data
{  MOVI.L R0, 0x1000        |  NOP  |  NOP  |  NOP  |  NOP  }
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

;Use sc, c1, c2 set ch0, ch1, ch2
;************************************************************** Parameter0
{  MOVI.L R3, 0x0070  |  MOVI.L A0, 0x00B0  |  NOP  |  MOVI.L A3, 0x00F0  |  NOP  }
{  MOVI.H R3, DspDMURegister  |  MOVI.H A0, DspDMURegister  |  NOP  |  MOVI.H A3, DspDMURegister  |  NOP  }
;SAR                                                ;SAR
{  MOVI.L R4, 0x1000  |  MOVI.L A1, 0x2013  |  NOP  |  MOVI.L A4, 0x2030  |  NOP  }
{  MOVI.H R4, ExternalMemAddr7  |  MOVI.H A1, ExternalMemAddr7  |  NOP  |  MOVI.H A4, ExternalMemAddr7  |  NOP  }
{  SW R4, R3, 0       |  SW A1, A0, 0       |  NOP  |  SW A4, A3, 0       |  NOP  }
;DAR                                                ;DAR
{  MOVI.L R4, 0x0001  |  MOVI.L A1, 0x0031  |  NOP  |  MOVI.L A4, 0x0050  |  NOP  }
{  MOVI.H R4, DspDataMemAddr  |  MOVI.H A1, DspDataMemAddr  |  NOP  |  MOVI.H A4, DspDataMemAddr  |  NOP  }
{  SW R4, R3, 4       |  SW A1, A0, 4       |  NOP  |  SW A4, A3, 4       |  NOP  }
;SGR                                                ;DSR
{  MOVI.L R4, 0x001A  |  MOVI.L A1, 0x0015  |  NOP  |  MOVI.L A4, 0x000B  |  NOP  }
{  MOVI.H R4, 0x0130  |  MOVI.H A1, 0x00E0  |  NOP  |  MOVI.H A4, 0x0070  |  NOP  }
{  SW R4, R3, 8       |  SW A1, A0, 8       |  NOP  |  SW A4, A3, 12      |  NOP  }
;DSR                                                ;CTL
{  MOVI.L R4, 0x0002  |  MOVI.L A1, 0x0003  |  NOP  |  MOVI.L A4, 0x0A04  |  NOP  }
{  MOVI.H R4, 0x0010  |  MOVI.H A1, 0x0020  |  NOP  |  MOVI.H A4, 0x0004  |  NOP  }
{  SW R4, R3, 12      |  SW A1, A0, 12      |  NOP  |  SW A4, A3, 16      |  NOP  }
;CTL                                                ;LLST 
{  MOVI.L R4, 0x8304  |  MOVI.L A1, 0x0304  |  NOP  |  MOVI.L A4, 0x6000  |  NOP  }
{  MOVI.H R4, 0x0001  |  MOVI.H A1, 0x0001  |  NOP  |  MOVI.H A4, 0xDC00  |  NOP  }
{  SW R4, R3, 16      |  SW A1, A0, 16      |  NOP  |  SW A4, A3, 28      |  NOP  }
;LLST
{  NOP                |  NOP                |  NOP  |  NOP                |  NOP  }
{  NOP                |  NOP                |  NOP  |  NOP                |  NOP  }
{  NOP                |  NOP                |  NOP  |  NOP                |  NOP  }

;Use sc set ch3, c1 set ch2 llst item1, c2 set ch3 llst item1 
;************************************************************** Parameter1
{  MOVI.L R3, 0x0130  |  MOVI.L A0, 0x6000  |  NOP  |  MOVI.L A3, 0x7000  |  NOP  }
{  MOVI.H R3, DspDMURegister  |  MOVI.H A0, DspDataMemAddr  |  NOP  |  MOVI.H A3, DspDataMemAddr  |  NOP  }
;SAR                  ;SAR,DAR                      ;SAR,DAR
{  MOVI.L R4, 0x1003  |  MOVI.L A1, 0x0071  |  NOP  |  MOVI.L A4, 0x2071  |  NOP  }
{  MOVI.H R4, DspDataMemAddr  |  MOVI.H A1, DspDataMemAddr  |  NOP  |  MOVI.H A4, ExternalMemAddr7  |  NOP  }
{  SW R4, R3, 0       |  MOVI.L A2, 0x3002  |  NOP  |  MOVI.L A5, 0x0121  |  NOP  }
{  NOP                |  MOVI.H A2, ExternalMemAddr7  |  NOP  |  MOVI.H A5, DspDataMemAddr  |  NOP  }
;DAR 
{  MOVI.L R4, 0x3011  |  DSW A1, A2, A0, 0  |  NOP  |  DSW A4, A5, A3, 0  |  NOP  }
{  MOVI.H R4, ExternalMemAddr7  |  NOP                |  NOP  |  NOP                |  NOP  }
{  SW R4, R3, 4       |  NOP                |  NOP  |  NOP                |  NOP  }
;SGR                  ;DSR,CTL                      ;SGR,DSR
{  MOVI.L R4, 0x001F  |  MOVI.L A1, 0x0006  |  NOP  |  MOVI.L A4, 0x0009  |  NOP  }
{  MOVI.H R4, 0x01D0  |  MOVI.H A1, 0x0040  |  NOP  |  MOVI.H A4, 0x0050  |  NOP  }
{  SW R4, R3, 8       |  MOVI.L A2, 0x6A0C  |  NOP  |  MOVI.L A5, 0x0009  |  NOP  }
{  NOP                |  MOVI.H A2, 0x0000  |  NOP  |  MOVI.H A5, 0x0060  |  NOP  }
;DSR
{  MOVI.L R4, 0x000A  |  DSW A1, A2, A0, 8  |  NOP  |  DSW A4, A5, A3, 8  |  NOP  }
{  MOVI.H R4, 0x0040  |  NOP                |  NOP  |  NOP  |  NOP  }
{  SW R4, R3, 12      |  NOP                |  NOP  |  NOP  |  NOP  }
;CTL                  ;LLST                         ;CTL.LLST
{  MOVI.L R4, 0xEB0C  |  MOVI.L A1, 0x6030  |  NOP  |  MOVI.L A4, 0x0B04  |  NOP  }
{  MOVI.H R4, 0x0001  |  MOVI.H A1, 0xE800  |  NOP  |  MOVI.H A4, 0x0001  |  NOP  }
{  SW R4, R3, 16      |  SW A1, A0, 16      |  NOP  |  MOVI.L A5, 0x7200  |  NOP  }
;LLST                                       
{  MOVI.L R4, 0x7000  |  NOP                |  NOP  |  MOVI.H A5, 0xF800  |  NOP  }
{  MOVI.H R4, 0xFC00  |  NOP                |  NOP  |  DSW A4, A5, A3, 16 |  NOP  }
{  SW R4, R3, 28      |  NOP                |  NOP  |  NOP                |  NOP  }
{  NOP                |  NOP                |  NOP  |  NOP                |  NOP  }                                                                         
{  NOP                |  NOP                |  NOP  |  NOP                |  NOP  }
{  NOP                |  NOP                |  NOP  |  NOP                |  NOP  }
{  NOP                |  NOP                |  NOP  |  NOP                |  NOP  }

;Use c1 set ch3 llst item2, c2 set ch2 llst item2 
;**************************************************************
{  NOP                |  MOVI.L A0, 0x7200  |  NOP  |  MOVI.L A3, 0x6030  |  NOP  }
{  NOP                |  MOVI.H A0, DspDataMemAddr  |  NOP  |  MOVI.H A3, DspDataMemAddr  |  NOP  }
;SAR                  ;SAR,DAR                      ;SAR,DAR
{  NOP                |  MOVI.L A1, 0x2094  |  NOP  |  MOVI.L A4, 0x20A6  |  NOP  }
{  NOP                |  MOVI.H A1, ExternalMemAddr7  |  NOP  |  MOVI.H A4, ExternalMemAddr7  |  NOP  }
{  NOP                |  MOVI.L A2, 0x0142  |  NOP  |  MOVI.L A5, 0x0152  |  NOP  }
{  NOP                |  MOVI.H A2, DspDataMemAddr  |  NOP  |  MOVI.H A5, DspDataMemAddr  |  NOP  }
;DAR 
{  NOP                |  DSW A1, A2, A0, 0  |  NOP  |  DSW A4, A5, A3, 0  |  NOP  }
{  NOP                |  NOP                |  NOP  |  NOP                |  NOP  }
{  NOP                |  NOP                |  NOP  |  NOP                |  NOP  }
;SGR                  ;SGR,DSR                      ;SGR,CTL
{  NOP                |  MOVI.L A1, 0x0002  |  NOP  |  MOVI.L A4, 0x0004  |  NOP  }
{  NOP                |  MOVI.H A1, 0x0010  |  NOP  |  MOVI.H A4, 0x0010  |  NOP  }
{  NOP                |  MOVI.L A2, 0x0008  |  NOP  |  MOVI.L A5, 0x3104  |  NOP  }
{  NOP                |  MOVI.H A2, 0x0040  |  NOP  |  MOVI.H A5, 0x0000  |  NOP  }
;DSR
{  NOP                |  DSW A1, A2, A0, 8  |  NOP  |  DSW A4, A5, A3, 8  |  NOP  }
{  NOP                |  NOP                |  NOP  |  NOP                |  NOP  }
{  NOP                |  NOP                |  NOP  |  NOP                |  NOP  }
;CTL                  ;CTL                                                    
{  NOP                |  MOVI.L A1, 0x6304  |  NOP  |  NOP                |  NOP  }
{  NOP                |  MOVI.H A1, 0x0000  |  NOP  |  NOP                |  NOP  }
{  NOP                |  SW A1, A0, 16      |  NOP  |  NOP                |  NOP  }
;LLST                                                                     
{  NOP                |  NOP                |  NOP  |  NOP                |  NOP  }
{  NOP                |  NOP                |  NOP  |  NOP                |  NOP  }
{  NOP                |  NOP                |  NOP  |  NOP                |  NOP  }                                                                        

;EN ch3
{  MOVI.L R3, 0x0144  |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R3, DspDMURegister  |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.L R4, 0x0001  |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R4, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R4, R3, 0       |  NOP  |  NOP  |  NOP  |  NOP  }

;EN ch2
{  MOVI.L R3, 0x0104  |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R3, DspDMURegister  |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.L R4, 0x0001  |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R4, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R4, R3, 0       |  NOP  |  NOP  |  NOP  |  NOP  }

;EN ch1
{  MOVI.L R3, 0x00C4  |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R3, DspDMURegister  |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.L R4, 0x0001  |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R4, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R4, R3, 0       |  NOP  |  NOP  |  NOP  |  NOP  }

;EN ch0
{  MOVI.L R3, 0x0084  |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R3, DspDMURegister  |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.L R4, 0x0001  |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R4, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R4, R3, 0       |  NOP  |  NOP  |  NOP  |  NOP  }

;read DMA ch0,ch1,ch2 setting for coverage
{  MOVI.L R3, 0x0070  |  MOVI.L A0, 0x00B0  |  NOP  |  MOVI.L A3, 0x00F0  |  NOP  }
{  MOVI.H R3, DspDMURegister  |  MOVI.H A0, DspDMURegister  |  NOP  |  MOVI.H A3, DspDMURegister  |  NOP  }
;SAR                                                
{  LW R4, R3, 0       |  LW A1, A0, 0       |  NOP  |  LW A4, A3, 0       |  NOP  }
{  NOP                |  NOP                |  NOP  |  NOP                |  NOP  }
{  NOP                |  NOP                |  NOP  |  NOP                |  NOP  }
;DAR                                                
{  LW R4, R3, 4       |  LW A1, A0, 4       |  NOP  |  LW A4, A3, 4       |  NOP  }
{  NOP                |  NOP                |  NOP  |  NOP                |  NOP  }
{  NOP                |  NOP                |  NOP  |  NOP                |  NOP  }
;SGR                                                
{  LW R4, R3, 8       |  LW A1, A0, 8       |  NOP  |  LW A4, A3, 8       |  NOP  }
{  NOP                |  NOP                |  NOP  |  NOP                |  NOP  }
{  NOP                |  NOP                |  NOP  |  NOP                |  NOP  }
;DSR                                                
{  LW R4, R3, 12      |  LW A1, A0, 12      |  NOP  |  LW A4, A3, 12      |  NOP  }
{  NOP                |  NOP                |  NOP  |  NOP                |  NOP  }
{  NOP                |  NOP                |  NOP  |  NOP                |  NOP  }
;CTL                                                
{  LW R4, R3, 16      |  LW A1, A0, 16      |  NOP  |  LW A4, A3, 16      |  NOP  }
{  NOP                |  NOP                |  NOP  |  NOP                |  NOP  }
{  NOP                |  NOP                |  NOP  |  NOP                |  NOP  }
;LLST
{  LW R4, R3, 28      |  LW A1, A0, 28      |  NOP  |  LW A4, A3, 28      |  NOP  }
{  NOP                |  NOP                |  NOP  |  NOP                |  NOP  }
{  NOP                |  NOP                |  NOP  |  NOP                |  NOP  }

;read DMA ch3 setting for coverage, write Mspace,BaseAddr,Priority
{  MOVI.L R3, 0x0130  |  MOVI.L A0, 0x8030  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R3, DspDMURegister  |  MOVI.H A0, DspDMURegister  |  NOP  |  NOP  |  NOP  }
;SAR                                                
{  LW R4, R3, 0       |  MOVI.L A1, 0x0001  |  NOP  |  NOP  |  NOP  }
{  NOP                |  MOVI.H A1, 0x0000  |  NOP  |  NOP  |  NOP  }
{  NOP                |  SW A1, A0, 0x30    |  NOP  |  NOP  |  NOP  }
;DAR                                                
{  LW R4, R3, 4       |  MOVI.L A1, 0x0000  |  NOP  |  NOP  |  NOP  }
{  NOP                |  MOVI.H A1, 0x2500  |  NOP  |  NOP  |  NOP  }
{  NOP                |  SW A1, A0, 0x8       |  NOP  |  NOP  |  NOP  }
;SGR                                                
{  LW R4, R3, 8       |  MOVI.L A1, 0x0011  |  NOP  |  NOP  |  NOP  }
{  NOP                |  MOVI.H A1, 0x0000  |  NOP  |  NOP  |  NOP  }
{  NOP                |  SW A1, A0, 0x10      |  NOP  |  NOP  |  NOP  }
;DSR                                                
{  LW R4, R3, 12      |  LW A2, A0, 4       |  NOP  |  NOP  |  NOP  }
{  NOP                |  NOP                |  NOP  |  NOP  |  NOP  }
{  NOP                |  NOP                |  NOP  |  NOP  |  NOP  }
;CTL                                                              
{  LW R4, R3, 16      |  LW A2, A0, 0       |  NOP  |  NOP  |  NOP  }
{  NOP                |  NOP                |  NOP  |  NOP  |  NOP  }
{  NOP                |  NOP                |  NOP  |  NOP  |  NOP  }
;LLST                                       
{  LW R4, R3, 28      |  NOP                |  NOP  |  NOP  |  NOP  }
{  NOP                |  NOP                |  NOP  |  NOP  |  NOP  }
{  NOP                |  NOP                |  NOP  |  NOP  |  NOP  }
;nothing                                    
{  LW R4, R3, 32      |  NOP                |  NOP  |  NOP  |  NOP  }
{  NOP                |  NOP                |  NOP  |  NOP  |  NOP  }
{  NOP                |  NOP                |  NOP  |  NOP  |  NOP  }

;************************************************************** wait until DMA done
{  MOVI.L R5, 0x0054       |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R5, DspDMURegister       |  NOP  |  NOP  |  NOP  |  NOP  }
_Label1:
{  LW R6, R5, 0            |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                     |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                     |  NOP  |  NOP  |  NOP  |  NOP  }
{  SEQI R7, P1, P2, R6, 0x22222222  |  NOP  |  NOP  |  NOP  |  NOP  }
{  (P2)B _Label1           |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                     |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                     |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                     |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                     |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                     |  NOP  |  NOP  |  NOP  |  NOP  }                     

;************************************************************** Program Term
;************************************************************** Program Terminates
{  TRAP  |  NOP  |  NOP  |  NOP  |  NOP  }
