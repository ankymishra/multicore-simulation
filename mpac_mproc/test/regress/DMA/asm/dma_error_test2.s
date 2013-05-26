;**********************************************************************
; To verify DMA CH1 address error setting for coverage
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


;;************************************************************** Parameter0
;{  MOVI.L R3, 0xC070  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  MOVI.H R3, DspDMURegister  |  NOP  |  NOP  |  NOP  |  NOP  }
;;SAR
;{  MOVI.L R4, 0x0001  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  MOVI.H R4, ExternalMemAddr7  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  SW R4, R3, 4+      |  NOP  |  NOP  |  NOP  |  NOP  }
;;DAR
;{  MOVI.L R4, 0x0001  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  MOVI.H R4, ExternalMemAddr7  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  SW R4, R3, 4+      |  NOP  |  NOP  |  NOP  |  NOP  }
;;SGR
;{  MOVI.L R4, 0x0011  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  MOVI.H R4, 0x00A0  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  SW R4, R3, 4+      |  NOP  |  NOP  |  NOP  |  NOP  }
;;DSR
;{  MOVI.L R4, 0x0009  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  MOVI.H R4, 0x0050  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  SW R4, R3, 4+      |  NOP  |  NOP  |  NOP  |  NOP  }
;;CTL
;{  MOVI.L R4, 0x8304  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  MOVI.H R4, 0x0001  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  SW R4, R3, 4+      |  NOP  |  NOP  |  NOP  |  NOP  }
;;EN
;{  MOVI.L R4, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  MOVI.H R4, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  SW R4, R3, 4+      |  NOP  |  NOP  |  NOP  |  NOP  }


;;************************************************************** Parameter1
;{  MOVI.L R3, 0xC0B0  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  MOVI.H R3, DspDMURegister  |  NOP  |  NOP  |  NOP  |  NOP  }
;;SAR
;{  MOVI.L R4, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  MOVI.H R4, ExternalMemAddr7  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  SW R4, R3, 4+      |  NOP  |  NOP  |  NOP  |  NOP  }
;;DAR
;{  MOVI.L R4, 0x0030  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  MOVI.H R4, ExternalMemAddr7  |  NOP  |  NOP  |  NOP  |  NOP  }         
;{  SW R4, R3, 4+      |  NOP  |  NOP  |  NOP  |  NOP  }
;;SGR
;{  MOVI.L R4, 0x0011  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  MOVI.H R4, 0x00A0  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  SW R4, R3, 4+      |  NOP  |  NOP  |  NOP  |  NOP  }
;;DSR
;{  MOVI.L R4, 0x0009  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  MOVI.H R4, 0x0050  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  SW R4, R3, 4+      |  NOP  |  NOP  |  NOP  |  NOP  }
;;CTL
;{  MOVI.L R4, 0x0304  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  MOVI.H R4, 0x0180  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  SW R4, R3, 4+      |  NOP  |  NOP  |  NOP  |  NOP  }
;;EN
;{  MOVI.L R4, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  MOVI.H R4, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  SW R4, R3, 4+      |  NOP  |  NOP  |  NOP  |  NOP  }


;************************************************************** Parameter2
{  MOVI.L R3, 0xC0F0  |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R3, DspDMURegister  |  NOP  |  NOP  |  NOP  |  NOP  }
;SAR
{  MOVI.L R4, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R4, ExternalMemAddr7  |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R4, R3, 4+      |  NOP  |  NOP  |  NOP  |  NOP  }
;DAR
{  MOVI.L R4, 0x00D0  |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R4, ExternalMemAddr7  |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R4, R3, 4+      |  NOP  |  NOP  |  NOP  |  NOP  }
;SGR
{  MOVI.L R4, 0x0011  |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R4, 0x00A0  |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R4, R3, 4+      |  NOP  |  NOP  |  NOP  |  NOP  }
;DSR
{  MOVI.L R4, 0x0009  |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R4, 0x0050  |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R4, R3, 4+      |  NOP  |  NOP  |  NOP  |  NOP  }
;CTL
{  MOVI.L R4, 0x1304  |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R4, 0x0002  |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R4, R3, 4+      |  NOP  |  NOP  |  NOP  |  NOP  }
;EN
{  MOVI.L R4, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R4, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R4, R3, 4+      |  NOP  |  NOP  |  NOP  |  NOP  }


;;************************************************************** Parameter3
;{  MOVI.L R3, 0x00D0  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  MOVI.H R3, DspDMURegister  |  NOP  |  NOP  |  NOP  |  NOP  }
;;SAR
;{  MOVI.L R4, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  MOVI.H R4, ExternalMemAddr7  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  SW R4, R3, 4+      |  NOP  |  NOP  |  NOP  |  NOP  }
;;DAR
;{  MOVI.L R4, 0x0150  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  MOVI.H R4, ExternalMemAddr7  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  SW R4, R3, 4+      |  NOP  |  NOP  |  NOP  |  NOP  }
;;SGR
;{  MOVI.L R4, 0x001A  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  MOVI.H R4, 0x0030  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  SW R4, R3, 4+      |  NOP  |  NOP  |  NOP  |  NOP  }
;;DSR
;{  MOVI.L R4, 0x0009  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  MOVI.H R4, 0x0050  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  SW R4, R3, 4+      |  NOP  |  NOP  |  NOP  |  NOP  }
;;CTL
;{  MOVI.L R4, 0x0304  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  MOVI.H R4, 0x0120  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  SW R4, R3, 4+      |  NOP  |  NOP  |  NOP  |  NOP  }
;;EN
;{  MOVI.L R4, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  MOVI.H R4, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  SW R4, R3, 4+      |  NOP  |  NOP  |  NOP  |  NOP  }


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
