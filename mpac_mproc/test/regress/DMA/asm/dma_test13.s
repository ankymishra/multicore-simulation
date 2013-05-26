;**********************************************************************
; To verify DMA ch2 E->I Addr ERROR
; para0: BSZ = 25, SC = 7, SI = 2, DC = 0, DI = 0, SAR = ExternalMemAddr70000, DAR = DspDataMemAddr0000, LLST_Addr = xxxx
; para1: BSZ = 20, SC = 8, SI = 3, DC = 0, DI = 0, SAR = ExternalMemAddr70026, DAR = DspDataMemAddr0020, LLST_Addr = xxxx
; para3: BSZ = 14, SC = 7, SI = 6, DC = 0, DI = 0, SAR = ExternalMemAddr70043, DAR = DspDataMemAddr4040, LLST_Addr = xxxx
; para2: E -> I Address Error
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
{  NOP                      |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                      |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                      |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                      |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                      |  NOP  |  NOP  |  NOP  |  NOP  }

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

;************************************************************** Parameter0
{  MOVI.L R3, 0xC070  |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R3, DspDMURegister  |  NOP  |  NOP  |  NOP  |  NOP  }
;SAR
{  MOVI.L R4, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R4, ExternalMemAddr7  |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R4, R3, 4+      |  NOP  |  NOP  |  NOP  |  NOP  }
;DAR
{  MOVI.L R4, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R4, DspDataMemAddr  |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R4, R3, 4+      |  NOP  |  NOP  |  NOP  |  NOP  }
;SGR
{  MOVI.L R4, 0x0009  |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R4, 0x0070  |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R4, R3, 4+      |  NOP  |  NOP  |  NOP  |  NOP  }
;DSR
{  MOVI.L R4, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R4, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R4, R3, 4+      |  NOP  |  NOP  |  NOP  |  NOP  }
;CTL
{  MOVI.L R4, 0x9104  |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R4, 0x0001  |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R4, R3, 4+      |  NOP  |  NOP  |  NOP  |  NOP  }
;EN_CH0
{  MOVI.L R4, 0x0001  |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R4, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R4, R3, 4+      |  NOP  |  NOP  |  NOP  |  NOP  }

;************************************************************** Parameter1
{  MOVI.L R3, 0xC0B0  |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R3, DspDMURegister  |  NOP  |  NOP  |  NOP  |  NOP  }
;SAR
{  MOVI.L R4, 0x0026  |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R4, ExternalMemAddr7  |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R4, R3, 4+      |  NOP  |  NOP  |  NOP  |  NOP  }
;DAR
{  MOVI.L R4, 0x0020  |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R4, DspDataMemAddr  |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R4, R3, 4+      |  NOP  |  NOP  |  NOP  |  NOP  }
;SGR
{  MOVI.L R4, 0x000B  |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R4, 0x0080  |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R4, R3, 4+      |  NOP  |  NOP  |  NOP  |  NOP  }
;DSR
{  MOVI.L R4, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R4, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R4, R3, 4+      |  NOP  |  NOP  |  NOP  |  NOP  }
;CTL
{  MOVI.L R4, 0x4104  |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R4, 0x0001  |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R4, R3, 4+      |  NOP  |  NOP  |  NOP  |  NOP  }
;EN
{  MOVI.L R4, 0x0001  |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R4, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R4, R3, 4+      |  NOP  |  NOP  |  NOP  |  NOP  }

;************************************************************** Parameter3
{  MOVI.L R3, 0xC130  |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R3, DspDMURegister  |  NOP  |  NOP  |  NOP  |  NOP  }
;SAR
{  MOVI.L R4, 0x0043  |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R4, ExternalMemAddr7  |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R4, R3, 4+      |  NOP  |  NOP  |  NOP  |  NOP  }
;DAR
{  MOVI.L R4, 0x0040  |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R4, DspDataMemAddr  |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R4, R3, 4+      |  NOP  |  NOP  |  NOP  |  NOP  }
;SGR
{  MOVI.L R4, 0x000D  |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R4, 0x0070  |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R4, R3, 4+      |  NOP  |  NOP  |  NOP  |  NOP  }
;DSR
{  MOVI.L R4, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R4, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R4, R3, 4+      |  NOP  |  NOP  |  NOP  |  NOP  }
;CTL
{  MOVI.L R4, 0xE104  |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R4, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R4, R3, 4+      |  NOP  |  NOP  |  NOP  |  NOP  }
;EN
{  MOVI.L R4, 0x0001  |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R4, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R4, R3, 4+      |  NOP  |  NOP  |  NOP  |  NOP  }

;************************************************************** Parameter2
{  MOVI.L R3, 0xC0F0  |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R3, DspDMURegister  |  NOP  |  NOP  |  NOP  |  NOP  }
;SAR
{  MOVI.L R4, 0x0004  |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R4, DspDataMemAddr  |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R4, R3, 4+      |  NOP  |  NOP  |  NOP  |  NOP  }
;DAR
{  MOVI.L R4, 0x3000  |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R4, ExternalMemAddr7  |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R4, R3, 4+      |  NOP  |  NOP  |  NOP  |  NOP  }
;SGR
{  MOVI.L R4, 0x0008  |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R4, 0x0040  |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R4, R3, 4+      |  NOP  |  NOP  |  NOP  |  NOP  }
;DSR
{  MOVI.L R4, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R4, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R4, R3, 4+      |  NOP  |  NOP  |  NOP  |  NOP  }
;CTL
{  MOVI.L R4, 0x0104  |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R4, 0x0001  |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R4, R3, 4+      |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                |  NOP  |  NOP  |  NOP  |  NOP  }
;EN
{  MOVI.L R4, 0x0001  |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R4, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R4, R3, 4+      |  NOP  |  NOP  |  NOP  |  NOP  }

;;EN ch1
;{  MOVI.L R3, 0xC0C4  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  MOVI.H R3, DspDMURegister  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  MOVI.L R4, 0x0001  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  MOVI.H R4, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  SW R4, R3, 0       |  NOP  |  NOP  |  NOP  |  NOP  }
;
;;EN ch0
;{  MOVI.L R3, 0x0084  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  MOVI.H R3, DspDMURegister  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  MOVI.L R4, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  MOVI.H R4, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  SW R4, R3, 0       |  NOP  |  NOP  |  NOP  |  NOP  }
;
;;EN ch3
;{  MOVI.L R3, 0x00E4  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  MOVI.H R3, DspDMURegister  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  MOVI.L R4, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  MOVI.H R4, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  SW R4, R3, 0       |  NOP  |  NOP  |  NOP  |  NOP  }
;
;;EN ch2
;{  MOVI.L R3, 0x00C4  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  MOVI.H R3, DspDMURegister  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  MOVI.L R4, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  MOVI.H R4, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  SW R4, R3, 0       |  NOP  |  NOP  |  NOP  |  NOP  }
;************************************************************** Check DMA Done
{  MOVI.L R5, 0x8054                |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R5, DspDMURegister                |  NOP  |  NOP  |  NOP  |  NOP  }
_Label1:                            
{  LW R6, R5, 0                     |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                              |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                              |  NOP  |  NOP  |  NOP  |  NOP  }
{  SEQI R7, P1, P2, R6, 0x00002322  |  NOP  |  NOP  |  NOP  |  NOP  }
{  (P2)B _Label1                    |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                              |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                              |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                              |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                              |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                              |  NOP  |  NOP  |  NOP  |  NOP  }


;************************************************************** Program Terminates
{  TRAP  |  NOP  |  NOP  |  NOP  |  NOP  }
