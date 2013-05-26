;**********************************************************************
; To verify Linked List
; DMA
;    para0: BSZ = 24, SC = 19, SI = 7, DC = 1, DI = 2, SAR = ExternalMemAddr71000, DAR = DspDataMemAddr0001, LLST_Addr = xxxx
;                                                                              
;    para1: BSZ = 16, SC = 14, SI = 7, DC = 2, DI = 1, SAR = ExternalMemAddr72013, DAR = DspDataMemAddr0031, LLST_Addr = xxxx
;                                                                              
;    para2: BSZ = 64, SC =  0, SI = 0, DC = 7, DI = 4, SAR = ExternalMemAddr72030, DAR = DspDataMemAddr0050, LLST_Addr = 6000
;    Item1: BSZ =  6, SC =  0, SI = 0, DC = 4, DI = 2, SAR = DspDataMemAddr0071, DAR = ExternalMemAddr73002, LLST_Addr = 6030
;    Item2: BSZ =  3, SC =  1, SI = 3, DC = 0, DI = 0, SAR = ExternalMemAddr720A6, DAR = DspDataMemAddr0152, LLST_Addr = xxxx
;                                                                              
;    para3: BSZ = 30, SC = 29, SI = 2, DC = 4, DI = 6, SAR = DspDataMemAddr1003, DAR = ExternalMemAddr73011, LLST_Addr = 8000
;    Item1: BSZ = 16, SC =  5, SI = 4, DC = 6, DI = 3, SAR = ExternalMemAddr72071, DAR = DspDataMemAddr0121, LLST_Addr = A000 
;    Item2: BSZ =  6, SC =  1, SI = 1, DC = 4, DI = 4, SAR = ExternalMemAddr72094, DAR = DspDataMemAddr0142, LLST_Addr = xxxx 
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
{  MOVI.L R3, 0xC070  |  MOVI.L A0, 0xC0B0  |  NOP  |  MOVI.L A3, 0xC0F0  |  NOP  }
{  MOVI.H R3, DspDMURegister  |  MOVI.H A0, DspDMURegister  |  NOP  |  MOVI.H A3, DspDMURegister  |  NOP  }
;SAR                                                ;SAR
{  MOVI.L R4, 0x0001  |  MOVI.L A1, 0x0018  |  NOP  |  MOVI.L A4, 0x0020  |  NOP  }
{  MOVI.H R4, DspDataMemAddr  |  MOVI.H A1, DspDataMemAddr  |  NOP  |  MOVI.H A4, DspDataMemAddr  |  NOP  }
{  SW R4, R3, 0       |  SW A1, A0, 0       |  NOP  |  SW A4, A3, 0       |  NOP  }
;DAR                                                ;DAR
{  MOVI.L R4, 0x0000  |  MOVI.L A1, 0x0018  |  NOP  |  MOVI.L A4, 0x0020  |  NOP  }
{  MOVI.H R4, ExternalMemAddr7  |  MOVI.H A1, ExternalMemAddr7  |  NOP  |  MOVI.H A4, ExternalMemAddr7  |  NOP  }
{  SW R4, R3, 4       |  SW A1, A0, 4       |  NOP  |  SW A4, A3, 4       |  NOP  }
;SGR                                                ;DSR
{  MOVI.L R4, 0x0000  |  MOVI.L A1, 0x0005  |  NOP  |  MOVI.L A4, 0x0000  |  NOP  }
{  MOVI.H R4, 0x0000  |  MOVI.H A1, 0x0030  |  NOP  |  MOVI.H A4, 0x0000  |  NOP  }
{  SW R4, R3, 8       |  SW A1, A0, 8       |  NOP  |  SW A4, A3, 12      |  NOP  }
;DSR                                                ;CTL
{  MOVI.L R4, 0x0000  |  MOVI.L A1, 0x0000  |  NOP  |  MOVI.L A4, 0x000C  |  NOP  }
{  MOVI.H R4, 0x0000  |  MOVI.H A1, 0x0000  |  NOP  |  MOVI.H A4, 0x0001  |  NOP  }
{  SW R4, R3, 12      |  SW A1, A0, 12      |  NOP  |  SW A4, A3, 16      |  NOP  }
;CTL                                                ;LLST 
{  MOVI.L R4, 0x700C  |  MOVI.L A1, 0x710C  |  NOP  |  NOP                |  NOP  }
{  MOVI.H R4, 0x0001  |  MOVI.H A1, 0x0000  |  NOP  |  NOP                |  NOP  }
{  SW R4, R3, 16      |  SW A1, A0, 16      |  NOP  |  NOP                |  NOP  }
;LLST
{  NOP                |  NOP                |  NOP  |  NOP                |  NOP  }
{  NOP                |  NOP                |  NOP  |  NOP                |  NOP  }
{  NOP                |  NOP                |  NOP  |  NOP                |  NOP  }

;Use sc set ch3, c1 set ch3 llst item1 
;************************************************************** Parameter1
{  MOVI.L R3, 0xC130  |  MOVI.L A0, 0xF004  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R3, DspDMURegister  |  MOVI.H A0, DspDataMemAddr  |  NOP  |  NOP  |  NOP  }
;SAR                  ;SAR                          
{  MOVI.L R4, 0x0030  |  MOVI.L A1, 0x0040  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R4, DspDataMemAddr  |  MOVI.H A1, DspDataMemAddr  |  NOP  |  NOP  |  NOP  }
{  SW R4, R3, 0       |  SW A1, A0, 0       |  NOP  |  NOP  |  NOP  }
{  NOP                |  NOP                |  NOP  |  NOP  |  NOP  }
;DAR                  ;DAR,CTL
{  MOVI.L R4, 0x0030  |  MOVI.L A1, 0x0040  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R4, ExternalMemAddr7  |  MOVI.H A1, ExternalMemAddr7  |  NOP  |  NOP  |  NOP  }
{  SW R4, R3, 4       |  MOVI.L A2, 0x000C  |  NOP  |  NOP  |  NOP  }
;SGR                                                
{  MOVI.L R4, 0x0000  |  MOVI.H A2, 0x0001  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R4, 0x0000  |  DSW A1, A2, A0, 4  |  NOP  |  NOP  |  NOP  }
{  SW R4, R3, 8       |  NOP                |  NOP  |  NOP  |  NOP  }
{  NOP                |  NOP                |  NOP  |  NOP  |  NOP  }
;DSR                                        
{  MOVI.L R4, 0x0000  |  NOP                |  NOP  |  NOP  |  NOP  }
{  MOVI.H R4, 0x0000  |  NOP                |  NOP  |  NOP  |  NOP  }
{  SW R4, R3, 12      |  NOP                |  NOP  |  NOP  |  NOP  }
;CTL                  ;LLST                         
{  MOVI.L R4, 0xD80C  |  NOP                |  NOP  |  NOP  |  NOP  }
{  MOVI.H R4, 0x0000  |  NOP                |  NOP  |  NOP  |  NOP  }
{  SW R4, R3, 16      |  NOP                |  NOP  |  NOP  |  NOP  }
;LLST                                       
{  MOVI.L R4, 0xF004  |  NOP                |  NOP  |  NOP  |  NOP  }
{  MOVI.H R4, 0x1900  |  NOP                |  NOP  |  NOP  |  NOP  }
{  SW R4, R3, 28      |  NOP                |  NOP  |  NOP  |  NOP  }
{  NOP                |  NOP                |  NOP  |  NOP  |  NOP  }                                                                         
{  NOP                |  NOP                |  NOP  |  NOP  |  NOP  }
{  NOP                |  NOP                |  NOP  |  NOP  |  NOP  }
{  NOP                |  NOP                |  NOP  |  NOP  |  NOP  }

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
