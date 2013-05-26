;============================================================================
;  Copyright (C) 2005 SoC Technology Center.
;  Industrial Technology Research Institute.
;  All right reserved. 
;
;  Written by Po-Chou Chen  pcchen1029@itri.org.tw
;  
;==============================================================================
;       Subject: The top module
;
;       File name: sc_comparison.s
;       $Revision: $ V1.01 add predicate bit test and test all length of immediate value
;
;       Description: 	This test bench is used for test comparison type instruction of scalar unit in PAC DSP version 3.0.
;       			
;                    
;       $Date: $		V1.00 @ 2006/01/26
;       			V1.01 @ 2006/02/07
;       
;       Note:		1.Evey comparison type instruction have three condition need to test(Rs1<Rs2, Rs1>Rs2, Rs1=Rs2)
;       			2.Use conditional execution to check if there is any error in Pd1 or Pd2 and Check if there is
;       			any error when conditionally execute all instruction
;
;       Author:         Po-Chou Chen
;                       SoC Technology Center
;                       Industrial Technology Research Institute
;
;===============================================================================

BASE_ADDR = 0x2400

;************************************************************** Set Start Address
{  COPY R0, SR15   |  NOP  |  NOP  |  NOP  |  NOP  }
{  SLLI R0, R0, 20 |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.L R15, 0x0000    |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R15, BASE_ADDR |  NOP  |  NOP  |  NOP  |  NOP  }
{  ADD R15, R15, R0      |  NOP  |  NOP  |  NOP  |  NOP  }

;*********************************** Initial Rs0 and Rs1
{  MOVI.L R0, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R0] = 0x0000_0000

{  MOVI.H R0, 0x8000  | NOP  |   NOP  |  NOP  |  NOP  }
;Reg[R0] = 0x8000_0000

{  MOVI.L R1, 0xFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R1] = 0x0000_FFFF

{  MOVI.H R1, 0x0FFF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R1] = 0x0FFF_FFFF

{  MOVI.L R3, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R3] = 0x0000_0000

{  MOVI.H R3, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R3] = 0x0000_0000

{  SLT R7, P14, P15, R0, R1  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R7] = 0x0000_0001, Reg[P14] = 1, Reg[P15] = 0


;************************************************************** SLT(U), SGT(U)

;************************************************************** SLT
;----------------------------------------------------------------

{  (P14) SLT R2, P1, P2, R0, R1  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0001, Reg[P1] = 1, Reg[P2] = 0

{  (P15) SLT R2, P1, P2, R1, R0  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0000] = 0x0000_0001, Reg[R15] = 0x1E00_0004

;----------------------------------------------------------------
{  (P1) SLT R2, P3, P4, R1, R0  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0000, Reg[P3] = 0, Reg[P4] = 1

{  (P2) SLT R2, P3, P4, R0, R1  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0004] = 0x0000_0000, Reg[R15] = 0x1E00_0008

;----------------------------------------------------------------
{  (P4) SLT R2, P5, P6, R1, R1  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0000, Reg[P5] = 0, Reg[P6] = 1

{  (P3) SLT R2, P5, P6, R0, R1  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0008] = 0x0000_0000, Reg[R15] = 0x1E00_000C

;************************************************************** SLTU
;----------------------------------------------------------------
{  (P6) SLTU R2, P1, P2, R0, R1  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0000, Reg[P1] = 0, Reg[P2] = 1

{  (P5) SLTU R2, P1, P2, R1, R0  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_000C] = 0x0000_0000, Reg[R15] = 0x1E00_0010

;----------------------------------------------------------------
{  (P2) SLTU R2, P3, P4, R1, R0  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0001, Reg[P3] = 1, Reg[P4] = 0

{  (P1) SLTU R2, P3, P4, R0, R1  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0010] = 0x0000_0001, Reg[R15] = 0x1E00_0014

;----------------------------------------------------------------
{  (P3) SLTU R2, P5, P6, R1, R1  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0000, Reg[P5] = 0, Reg[P6] = 1

{  (P4) SLTU R2, P5, P6, R1, R0  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0014] = 0x0000_0000, Reg[R15] = 0x1E00_0018

;************************************************************** SGT
;----------------------------------------------------------------
{  (P6) SGT R2, P1, P2, R0, R1  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0000, Reg[P1] = 0, Reg[P2] = 1

{  (P5) SGT R2, P1, P2, R1, R0  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0018] = 0x0000_0000, Reg[R15] = 0x1E00_001C

;----------------------------------------------------------------
{  (P2) SGT R2, P3, P4, R1, R0  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0001, Reg[P3] = 1, Reg[P4] = 0

{  (P1) SGT R2, P3, P4, R0, R1  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_001C] = 0x0000_0001, Reg[R15] = 0x1E00_0020

;----------------------------------------------------------------
{  (P3) SGT R2, P5, P6, R1, R1  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0000, Reg[P5] = 0, Reg[P6] = 1				******************** Sam

{  (P4) SGT R2, P5, P6, R1, R0  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution													******************** Sam   

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0020] = 0x0000_0000, Reg[R15] = 0x1E00_0024

;************************************************************** SGTU
;----------------------------------------------------------------
{  (P6) SGTU R2, P1, P2, R0, R1  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0001, Reg[P1] = 1, Reg[P2] = 0

{  (P5) SGTU R2, P1, P2, R1, R0  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0024] = 0x0000_0001, Reg[R15] = 0x1E00_0028

;----------------------------------------------------------------
{  (P1) SGTU R2, P3, P4, R1, R0  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0000, Reg[P3] = 0, Reg[P4] = 1

{  (P2) SGTU R2, P3, P4, R0, R1  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0028] = 0x0000_0000, Reg[R15] = 0x1E00_002C

;----------------------------------------------------------------
{  (P4) SGTU R2, P5, P6, R1, R1  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0000, Reg[P5] = 0, Reg[P6] = 1

{  (P3) SGTU R2, P5, P6, R0, R1  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_002C] = 0x0000_0000, Reg[R15] = 0x1E00_0030

;************************************************************** SEQ
;----------------------------------------------------------------
{  (P6) SEQ R2, P1, P2, R0, R1  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0000, Reg[P1] = 0, Reg[P2] = 1

{  (P5) SEQ R2, P1, P2, R0, R0  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0030] = 0x0000_0000, Reg[R15] = 0x1E00_0034

;----------------------------------------------------------------
{  (P2) SEQ R2, P3, P4, R1, R0  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0000, Reg[P3] = 0, Reg[P4] = 1

{  (P1) SEQ R2, P3, P4, R1, R0  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0034] = 0x0000_0000, Reg[R15] = 0x1E00_0038

;----------------------------------------------------------------
{  (P4) SEQ R2, P5, P6, R1, R1  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0001, Reg[P5] = 1, Reg[P6] = 0

{  (P3) SEQ R2, P5, P6, R1, R0  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0038] = 0x0000_0001, Reg[R15] = 0x1E00_003C

;************************************************************** SLTI(U), SGTI(U), SEQI(U) -- 4byte

;************************************************************** SLTI
;----------------------------------------------------------------
{  (P5)SLTI R2, P1, P2, R0, 0x7FFFFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0001, Reg[P1] = 1, Reg[P2] = 0

{  (P6)SLTI R2, P1, P2, R0, 0xFFFFFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_003C] = 0x0000_0001, Reg[R15] = 0x1E00_0040

;----------------------------------------------------------------
{  (P1) SLTI R2, P3, P4, R1, 0xFFFFFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0000, Reg[P3] = 0, Reg[P4] = 1						******************** Sam   

{  (P2) SLTI R2, P3, P4, R0, 0x7FFFFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution															

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0040] = 0x0000_0000, Reg[R15] = 0x1E00_0044

;----------------------------------------------------------------
{  (P4) SLTI R2, P5, P6, R0, 0x80000000  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0000, Reg[P5] = 0, Reg[P6] = 1

{  (P3) SLTI R2, P5, P6, R0, 0x7FFFFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0044] = 0x0000_0000, Reg[R15] = 0x1E00_0048

;************************************************************** SLTIU
;----------------------------------------------------------------
{  (P6) SLTIU R2, P1, P2, R0, 0x7F000000 |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0000, Reg[P1] = 0, Reg[P2] = 1

{  (P5) SLTIU R2, P1, P2, R0, 0x8FFFFFFF | NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0048] = 0x0000_0000, Reg[R15] = 0x1E00_004C

;----------------------------------------------------------------
{  (P2) SLTIU R2, P3, P4, R1, 0x8FFFFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0001, Reg[P3] = 1, Reg[P4] = 0

{  (P1) SLTIU R2, P3, P4, R1, 0x00000000  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_004C] = 0x0000_0001, Reg[R15] = 0x1E00_0050

;----------------------------------------------------------------
{  (P3) SLTIU R2, P5, P6, R0, 0x80000000  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0000, Reg[P5] = 0, Reg[P6] = 1

{  (P4) SLTIU R2, P5, P6, R0, 0x8FFFFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0050] = 0x0000_0000, Reg[R15] = 0x1E00_0054

;************************************************************** SGTI
;----------------------------------------------------------------
{  (P6) SGTI R2, P1, P2, R0, 0x7F000000 | NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0000, Reg[P1] = 0, Reg[P2] = 1

{  (P5) SGTI R2, P1, P2, R0, 0x8FFFFFFF | NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0054] = 0x0000_0000, Reg[R15] = 0x1E00_0058

;----------------------------------------------------------------
{  (P2) SGTI R2, P3, P4, R1, 0x8FFFFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0001, Reg[P3] = 1, Reg[P4] = 0						******************** Sam

{  (P1) SGTI R2, P3, P4, R0, 0x00000000  |  NOP  |  NOP  |  NOP  |  NOP  }

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0058] = 0x0000_0001, Reg[R15] = 0x1E00_005C

;----------------------------------------------------------------
{  (P3) SGTI R2, P5, P6, R0, 0x80000000  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0000, Reg[P5] = 0, Reg[P6] = 1

{  (P4) SGTI R2, P5, P6, R1, 0x8FFFFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution															******************** Sam

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_005C] = 0x0000_0000, Reg[R15] = 0x1E00_0060

;************************************************************** SGTIU
;----------------------------------------------------------------
{  (P6) SGTIU R2, P1, P2, R0, 0x7F000000  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0001, Reg[P1] = 1, Reg[P2] = 0

{  (P5) SGTIU R2, P1, P2, R0, 0x8FFFFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0060] = 0x0000_0001, Reg[R15] = 0x1E00_0064

;----------------------------------------------------------------
{  (P1) SGTIU R2, P3, P4, R0, 0x8FFFFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0000, Reg[P3] = 0, Reg[P4] = 1

{  (P2) SGTIU R2, P3, P4, R0, 0x00000000  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0064] = 0x0000_0000, Reg[R15] = 0x1E00_0068

;----------------------------------------------------------------
{  (P4) SGTIU R2, P5, P6, R0, 0x80000000  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0000, Reg[P5] = 0, Reg[P6] = 1

{  (P3) SGTIU R2, P5, P6, R0, 0x00000000  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0068] = 0x0000_0000, Reg[R15] = 0x1E00_006C

;************************************************************** SEQI
;----------------------------------------------------------------
{  (P6) SEQI R2, P1, P2, R0, 0x7F000000 | NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0000, Reg[P1] = 0, Reg[P2] = 1

{  (P5) SEQI R2, P1, P2, R0, 0x80000000 | NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_006C] = 0x0000_0000, Reg[R15] = 0x1E00_0070

;----------------------------------------------------------------
{  (P2) SEQI R2, P3, P4, R0, 0x8FFFFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0000, Reg[P3] = 0, Reg[P4] = 1

{  (P1) SEQI R2, P3, P4, R0, 0x80000000  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0070] = 0x0000_0000, Reg[R15] = 0x1E00_0074

;----------------------------------------------------------------
{  (P4) SEQI R2, P5, P6, R0, 0x80000000  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0001, Reg[P5] = 1, Reg[P6] = 0

{  (P3) SEQI R2, P5, P6, R0, 0x8FFFFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0074] = 0x0000_0001, Reg[R15] = 0x1E00_0078

;************************************************************** SEQIU
;----------------------------------------------------------------
{  (P5) SEQIU R2, P1, P2, R0, 0x7F000000  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0000, Reg[P1] = 0, Reg[P2] = 1

{  (P6) SEQIU R2, P1, P2, R0, 0x80000000  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0078] = 0x0000_0000, Reg[R15] = 0x1E00_007C

;----------------------------------------------------------------
{  (P2) SEQIU R2, P3, P4, R0, 0x8FFFFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0000, Reg[P3] = 0, Reg[P4] = 1

{  (P1) SEQIU R2, P3, P4, R0, 0x80000000  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_007C] = 0x0000_0000, Reg[R15] = 0x1E00_0080

;----------------------------------------------------------------
{  (P4) SEQIU R2, P5, P6, R0, 0x80000000  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0001, Reg[P5] = 1, Reg[P6] = 0

{  (P3) SEQIU R2, P5, P6, R0, 0x8FFFFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0080] = 0x0000_0001, Reg[R15] = 0x1E00_0084

;************************************************************** SLTI(U), SGTI(U), SEQI(U) -- 3byte

{  MOVI.L R4, 0xFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R4] = 0x0000_FFFF

{  MOVI.H R4, 0x00FF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R4] = 0x00FF_FFFF

;************************************************************** SLTI
;----------------------------------------------------------------
{  (P5)SLTI R2, P1, P2, R0, 0x00FFFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0001, Reg[P1] = 1, Reg[P2] = 0

{  (P6)SLTI R2, P1, P2, R0, 0xFFFFFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0084] = 0x0000_0001, Reg[R15] = 0x1E00_0088

;----------------------------------------------------------------
{  (P1) SLTI R2, P3, P4, R1, 0x00FFFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0000, Reg[P3] = 0, Reg[P4] = 1

{  (P2) SLTI R2, P3, P4, R0, 0x7FFFFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0088] = 0x0000_0000, Reg[R15] = 0x1E00_008C

;----------------------------------------------------------------
{  (P4) SLTI R2, P5, P6, R4, 0x00FFFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0000, Reg[P5] = 0, Reg[P6] = 1

{  (P3) SLTI R2, P5, P6, R0, 0x7FFFFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_008C] = 0x0000_0000, Reg[R15] = 0x1E00_0090

;************************************************************** SLTIU
;----------------------------------------------------------------
{  (P6) SLTIU R2, P1, P2, R0, 0x00FFFFFF | NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0000, Reg[P1] = 0, Reg[P2] = 1

{  (P5) SLTIU R2, P1, P2, R0, 0x8FFFFFFF | NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0090] = 0x0000_0000, Reg[R15] = 0x1E00_0094

;----------------------------------------------------------------
{  (P2) SLTIU R2, P3, P4, R3, 0x00FFFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0001, Reg[P3] = 1, Reg[P4] = 0

{  (P1) SLTIU R2, P3, P4, R1, 0x00000000  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0094] = 0x0000_0001, Reg[R15] = 0x1E00_0098

;----------------------------------------------------------------
{  (P3) SLTIU R2, P5, P6, R4, 0x00FFFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0000, Reg[P5] = 0, Reg[P6] = 1

{  (P4) SLTIU R2, P5, P6, R0, 0x8FFFFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0098] = 0x0000_0000, Reg[R15] = 0x1E00_009C

;************************************************************** SGTI
;----------------------------------------------------------------
{  (P6) SGTI R2, P1, P2, R0, 0x00FFFFFF | NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0000, Reg[P1] = 0, Reg[P2] = 1

{  (P5) SGTI R2, P1, P2, R0, 0x8FFFFFFF | NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_009C] = 0x0000_0000, Reg[R15] = 0x1E00_00A0

;----------------------------------------------------------------
{  (P2) SGTI R2, P3, P4, R1, 0x00FFFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0001, Reg[P3] = 1, Reg[P4] = 0

{  (P1) SGTI R2, P3, P4, R0, 0x00000000  |  NOP  |  NOP  |  NOP  |  NOP  }

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00A0] = 0x0000_0001, Reg[R15] = 0x1E00_00A4

;----------------------------------------------------------------
{  (P3) SGTI R2, P5, P6, R4, 0x00FFFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0000, Reg[P5] = 0, Reg[P6] = 1

{  (P4) SGTI R2, P5, P6, R0, 0x8FFFFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00A4] = 0x0000_0000, Reg[R15] = 0x1E00_00A8

;************************************************************** SGTIU
;----------------------------------------------------------------
{  (P6) SGTIU R2, P1, P2, R0, 0x00FFFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0001, Reg[P1] = 1, Reg[P2] = 0

{  (P5) SGTIU R2, P1, P2, R0, 0x8FFFFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00A8] = 0x0000_0001, Reg[R15] = 0x1E00_00AC

;----------------------------------------------------------------
{  (P1) SGTIU R2, P3, P4, R3, 0x00FFFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0000, Reg[P3] = 0, Reg[P4] = 1

{  (P2) SGTIU R2, P3, P4, R0, 0x00000000  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00AC] = 0x0000_0000, Reg[R15] = 0x1E00_00B0

;----------------------------------------------------------------
{  (P4) SGTIU R2, P5, P6, R4, 0x00FFFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0000, Reg[P5] = 0, Reg[P6] = 1

{  (P3) SGTIU R2, P5, P6, R0, 0x00000000  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00B0] = 0x0000_0000, Reg[R15] = 0x1E00_00B4

;************************************************************** SEQI
;----------------------------------------------------------------
{  (P6) SEQI R2, P1, P2, R0, 0x00FFFFFF | NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0000, Reg[P1] = 0, Reg[P2] = 1

{  (P5) SEQI R2, P1, P2, R0, 0x80000000 | NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00B4] = 0x0000_0000, Reg[R15] = 0x1E00_00B8

;----------------------------------------------------------------
{  (P2) SEQI R2, P3, P4, R1, 0x00FFFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0000, Reg[P3] = 0, Reg[P4] = 1

{  (P1) SEQI R2, P3, P4, R0, 0x80000000  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00B8] = 0x0000_0000, Reg[R15] = 0x1E00_00BC

;----------------------------------------------------------------
{  (P4) SEQI R2, P5, P6, R4, 0x00FFFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0001, Reg[P5] = 1, Reg[P6] = 0

{  (P3) SEQI R2, P5, P6, R0, 0x8FFFFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00BC] = 0x0000_0001, Reg[R15] = 0x1E00_00C0

;************************************************************** SEQIU
;----------------------------------------------------------------
{  (P5) SEQIU R2, P1, P2, R0, 0x00FFFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0000, Reg[P1] = 0, Reg[P2] = 1

{  (P6) SEQIU R2, P1, P2, R0, 0x80000000  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00C0] = 0x0000_0000, Reg[R15] = 0x1E00_00C4

;----------------------------------------------------------------
{  (P2) SEQIU R2, P3, P4, R3, 0x00FFFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0000, Reg[P3] = 0, Reg[P4] = 1

{  (P1) SEQIU R2, P3, P4, R0, 0x80000000  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00C4] = 0x0000_0000, Reg[R15] = 0x1E00_00C8

;----------------------------------------------------------------
{  (P4) SEQIU R2, P5, P6, R4, 0x00FFFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0001, Reg[P5] = 1, Reg[P6] = 0

{  (P3) SEQIU R2, P5, P6, R0, 0x8FFFFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00C8] = 0x0000_0001, Reg[R15] = 0x1E00_00CC

;************************************************************** SLTI(U), SGTI(U), SEQI(U) -- 2byte

{  MOVI.L R4, 0xFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R4] = 0x00FF_FFFF

{  MOVI.H R4, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R4] = 0x0000_FFFF

;************************************************************** SLTI
;----------------------------------------------------------------
{  (P5)SLTI R2, P1, P2, R0, 0x0000FFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0001, Reg[P1] = 1, Reg[P2] = 0

{  (P6)SLTI R2, P1, P2, R0, 0xFFFFFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00CC] = 0x0000_0001, Reg[R15] = 0x1E00_00D0

;----------------------------------------------------------------
{  (P1) SLTI R2, P3, P4, R1, 0x0000FFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0000, Reg[P3] = 0, Reg[P4] = 1

{  (P2) SLTI R2, P3, P4, R0, 0x7FFFFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00D0] = 0x0000_0000, Reg[R15] = 0x1E00_00D4

;----------------------------------------------------------------
{  (P4) SLTI R2, P5, P6, R4, 0x0000FFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0000, Reg[P5] = 0, Reg[P6] = 1

{  (P3) SLTI R2, P5, P6, R0, 0x7FFFFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00D4] = 0x0000_0000, Reg[R15] = 0x1E00_00D8

;************************************************************** SLTIU
;----------------------------------------------------------------
{  (P6) SLTIU R2, P1, P2, R0, 0x0000FFFF | NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0000, Reg[P1] = 0, Reg[P2] = 1

{  (P5) SLTIU R2, P1, P2, R0, 0x8FFFFFFF | NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00D8] = 0x0000_0000, Reg[R15] = 0x1E00_00DC

;----------------------------------------------------------------
{  (P2) SLTIU R2, P3, P4, R3, 0x0000FFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0001, Reg[P3] = 1, Reg[P4] = 0

{  (P1) SLTIU R2, P3, P4, R1, 0x00000000  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00DC] = 0x0000_0001, Reg[R15] = 0x1E00_00E0

;----------------------------------------------------------------
{  (P3) SLTIU R2, P5, P6, R4, 0x0000FFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0000, Reg[P5] = 0, Reg[P6] = 1

{  (P4) SLTIU R2, P5, P6, R0, 0x8FFFFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00E0] = 0x0000_0000, Reg[R15] = 0x1E00_00E4

;************************************************************** SGTI
;----------------------------------------------------------------
{  (P6) SGTI R2, P1, P2, R0, 0x0000FFFF | NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0000, Reg[P1] = 0, Reg[P2] = 1

{  (P5) SGTI R2, P1, P2, R0, 0x8FFFFFFF | NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00E4] = 0x0000_0000, Reg[R15] = 0x1E00_00E8

;----------------------------------------------------------------
{  (P2) SGTI R2, P3, P4, R1, 0x0000FFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0001, Reg[P3] = 1, Reg[P4] = 0

{  (P1) SGTI R2, P3, P4, R0, 0x00000000  |  NOP  |  NOP  |  NOP  |  NOP  }

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00E8] = 0x0000_0001, Reg[R15] = 0x1E00_00EC

;----------------------------------------------------------------
{  (P3) SGTI R2, P5, P6, R4, 0x0000FFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0000, Reg[P5] = 0, Reg[P6] = 1

{  (P4) SGTI R2, P5, P6, R0, 0x8FFFFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00EC] = 0x0000_0000, Reg[R15] = 0x1E00_00F0

;************************************************************** SGTIU
;----------------------------------------------------------------
{  (P6) SGTIU R2, P1, P2, R0, 0x0000FFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0001, Reg[P1] = 1, Reg[P2] = 0

{  (P5) SGTIU R2, P1, P2, R0, 0x8FFFFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00F0] = 0x0000_0001, Reg[R15] = 0x1E00_00F4

;----------------------------------------------------------------
{  (P1) SGTIU R2, P3, P4, R3, 0x0000FFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0000, Reg[P3] = 0, Reg[P4] = 1

{  (P2) SGTIU R2, P3, P4, R0, 0x00000000  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00F4] = 0x0000_0000, Reg[R15] = 0x1E00_00F8

;----------------------------------------------------------------
{  (P4) SGTIU R2, P5, P6, R4, 0x0000FFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0000, Reg[P5] = 0, Reg[P6] = 1

{  (P3) SGTIU R2, P5, P6, R0, 0x00000000  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00F8] = 0x0000_0000, Reg[R15] = 0x1E00_00FC

;************************************************************** SEQI
;----------------------------------------------------------------
{  (P6) SEQI R2, P1, P2, R0, 0x0000FFFF | NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0000, Reg[P1] = 0, Reg[P2] = 1

{  (P5) SEQI R2, P1, P2, R0, 0x80000000 | NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_00FC] = 0x0000_0000, Reg[R15] = 0x1E00_0100

;----------------------------------------------------------------
{  (P2) SEQI R2, P3, P4, R1, 0x0000FFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0000, Reg[P3] = 0, Reg[P4] = 1

{  (P1) SEQI R2, P3, P4, R0, 0x80000000  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0100] = 0x0000_0000, Reg[R15] = 0x1E00_0104

;----------------------------------------------------------------
{  (P4) SEQI R2, P5, P6, R4, 0x0000FFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0001, Reg[P5] = 1, Reg[P6] = 0

{  (P3) SEQI R2, P5, P6, R0, 0x8FFFFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0104] = 0x0000_0001, Reg[R15] = 0x1E00_0108

;************************************************************** SEQIU
;----------------------------------------------------------------
{  (P5) SEQIU R2, P1, P2, R0, 0x0000FFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0000, Reg[P1] = 0, Reg[P2] = 1

{  (P6) SEQIU R2, P1, P2, R0, 0x80000000  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0108] = 0x0000_0000, Reg[R15] = 0x1E00_010C

;----------------------------------------------------------------
{  (P2) SEQIU R2, P3, P4, R3, 0x0000FFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0000, Reg[P3] = 0, Reg[P4] = 1

{  (P1) SEQIU R2, P3, P4, R0, 0x80000000  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_010C] = 0x0000_0000, Reg[R15] = 0x1E00_0110

;----------------------------------------------------------------
{  (P4) SEQIU R2, P5, P6, R4, 0x0000FFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0001, Reg[P5] = 1, Reg[P6] = 0

{  (P3) SEQIU R2, P5, P6, R0, 0x8FFFFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0110] = 0x0000_0001, Reg[R15] = 0x1E00_0114

;************************************************************** SLTI(U), SGTI(U), SEQI(U) -- 1byte

{  MOVI.L R4, 0x00FF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R4] = 0x0000_00FF

{  MOVI.H R4, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R4] = 0x0000_00FF

;************************************************************** SLTI
;----------------------------------------------------------------
{  (P5)SLTI R2, P1, P2, R0, 0x000000FF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0001, Reg[P1] = 1, Reg[P2] = 0

{  (P6)SLTI R2, P1, P2, R0, 0xFFFFFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0114] = 0x0000_0001, Reg[R15] = 0x1E00_0118

;----------------------------------------------------------------
{  (P1) SLTI R2, P3, P4, R1, 0x000000FF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0000, Reg[P3] = 0, Reg[P4] = 1

{  (P2) SLTI R2, P3, P4, R0, 0x7FFFFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0118] = 0x0000_0000, Reg[R15] = 0x1E00_011C

;----------------------------------------------------------------
{  (P4) SLTI R2, P5, P6, R4, 0x000000FF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0000, Reg[P5] = 0, Reg[P6] = 1

{  (P3) SLTI R2, P5, P6, R0, 0x7FFFFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_011C] = 0x0000_0000, Reg[R15] = 0x1E00_0120

;************************************************************** SLTIU
;----------------------------------------------------------------
{  (P6) SLTIU R2, P1, P2, R0, 0x000000FF | NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0000, Reg[P1] = 0, Reg[P2] = 1

{  (P5) SLTIU R2, P1, P2, R0, 0x8FFFFFFF | NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0120] = 0x0000_0000, Reg[R15] = 0x1E00_0124

;----------------------------------------------------------------
{  (P2) SLTIU R2, P3, P4, R3, 0x000000FF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0001, Reg[P3] = 1, Reg[P4] = 0

{  (P1) SLTIU R2, P3, P4, R1, 0x00000000  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0124] = 0x0000_0001, Reg[R15] = 0x1E00_0128

;----------------------------------------------------------------
{  (P3) SLTIU R2, P5, P6, R4, 0x000000FF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0000, Reg[P5] = 0, Reg[P6] = 1

{  (P4) SLTIU R2, P5, P6, R0, 0x8FFFFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0128] = 0x0000_0000, Reg[R15] = 0x1E00_012C

;************************************************************** SGTI
;----------------------------------------------------------------
{  (P6) SGTI R2, P1, P2, R0, 0x000000FF | NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0000, Reg[P1] = 0, Reg[P2] = 1

{  (P5) SGTI R2, P1, P2, R0, 0x8FFFFFFF | NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_012C] = 0x0000_0000, Reg[R15] = 0x1E00_0130

;----------------------------------------------------------------
{  (P2) SGTI R2, P3, P4, R1, 0x000000FF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0001, Reg[P3] = 1, Reg[P4] = 0

{  (P1) SGTI R2, P3, P4, R0, 0x00000000  |  NOP  |  NOP  |  NOP  |  NOP  }

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0130] = 0x0000_0001, Reg[R15] = 0x1E00_0134

;----------------------------------------------------------------
{  (P3) SGTI R2, P5, P6, R4, 0x000000FF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0000, Reg[P5] = 0, Reg[P6] = 1

{  (P4) SGTI R2, P5, P6, R0, 0x8FFFFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0134] = 0x0000_0000, Reg[R15] = 0x1E00_0138

;************************************************************** SGTIU
;----------------------------------------------------------------
{  (P6) SGTIU R2, P1, P2, R0, 0x000000FF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0001, Reg[P1] = 1, Reg[P2] = 0

{  (P5) SGTIU R2, P1, P2, R0, 0x8FFFFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0138] = 0x0000_0001, Reg[R15] = 0x1E00_013C

;----------------------------------------------------------------
{  (P1) SGTIU R2, P3, P4, R3, 0x000000FF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0000, Reg[P3] = 0, Reg[P4] = 1

{  (P2) SGTIU R2, P3, P4, R0, 0x00000000  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_013C] = 0x0000_0000, Reg[R15] = 0x1E00_0140

;----------------------------------------------------------------
{  (P4) SGTIU R2, P5, P6, R4, 0x000000FF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0000, Reg[P5] = 0, Reg[P6] = 1

{  (P3) SGTIU R2, P5, P6, R0, 0x00000000  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0140] = 0x0000_0000, Reg[R15] = 0x1E00_0144

;************************************************************** SEQI
;----------------------------------------------------------------
{  (P6) SEQI R2, P1, P2, R0, 0x000000FF | NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0000, Reg[P1] = 0, Reg[P2] = 1

{  (P5) SEQI R2, P1, P2, R0, 0x80000000 | NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0144] = 0x0000_0000, Reg[R15] = 0x1E00_0148

;----------------------------------------------------------------
{  (P2) SEQI R2, P3, P4, R1, 0x000000FF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0000, Reg[P3] = 0, Reg[P4] = 1

{  (P1) SEQI R2, P3, P4, R0, 0x80000000  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0148] = 0x0000_0000, Reg[R15] = 0x1E00_014C

;----------------------------------------------------------------
{  (P4) SEQI R2, P5, P6, R4, 0x000000FF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0001, Reg[P5] = 1, Reg[P6] = 0

{  (P3) SEQI R2, P5, P6, R0, 0x8FFFFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_014C] = 0x0000_0001, Reg[R15] = 0x1E00_0150

;************************************************************** SEQIU
;----------------------------------------------------------------
{  (P5) SEQIU R2, P1, P2, R0, 0x000000FF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0000, Reg[P1] = 0, Reg[P2] = 1

{  (P6) SEQIU R2, P1, P2, R0, 0x80000000  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0150] = 0x0000_0000, Reg[R15] = 0x1E00_0154

;----------------------------------------------------------------
{  (P2) SEQIU R2, P3, P4, R3, 0x000000FF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0000, Reg[P3] = 0, Reg[P4] = 1

{  (P1) SEQIU R2, P3, P4, R0, 0x80000000  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0154] = 0x0000_0000, Reg[R15] = 0x1E00_0158

;----------------------------------------------------------------
{  (P4) SEQIU R2, P5, P6, R4, 0x000000FF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0001, Reg[P5] = 1, Reg[P6] = 0

{  (P3) SEQIU R2, P5, P6, R0, 0x8FFFFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0158] = 0x0000_0001, Reg[R15] = 0x1E00_015C

;************************************************************** SLTI(U), SGTI(U), SEQI(U) -- 0byte

{  MOVI.L R4, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R4] = 0x0000_0000

{  MOVI.H R4, 0xFF00  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R4] = 0xFF00_0000

;************************************************************** SLTI
;----------------------------------------------------------------	<
{  (P5)SLTI R2, P1, P2, R4, 0x00000000  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0001, Reg[P1] = 1, Reg[P2] = 0

{  (P6)SLTI R2, P1, P2, R0, 0xFFFFFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_015C] = 0x0000_0001, Reg[R15] = 0x1E00_0160

;----------------------------------------------------------------	>
{  (P1) SLTI R2, P3, P4, R1, 0x00000000  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0000, Reg[P3] = 0, Reg[P4] = 1

{  (P2) SLTI R2, P3, P4, R0, 0x7FFFFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0160] = 0x0000_0000, Reg[R15] = 0x1E00_0164

;----------------------------------------------------------------	=
{  (P4) SLTI R2, P5, P6, R3, 0x00000000  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0000, Reg[P5] = 0, Reg[P6] = 1

{  (P3) SLTI R2, P5, P6, R0, 0x7FFFFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0164] = 0x0000_0000, Reg[R15] = 0x1E00_0168

;************************************************************** SLTIU
;----------------------------------------------------------------	>
{  (P6) SLTIU R2, P1, P2, R0, 0x00000000 | NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0000, Reg[P1] = 0, Reg[P2] = 1

{  (P5) SLTIU R2, P1, P2, R0, 0x8FFFFFFF | NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0168] = 0x0000_0000, Reg[R15] = 0x1E00_016C

;----------------------------------------------------------------	=
{  (P2) SLTIU R2, P5, P6, R3, 0x00000000  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0000, Reg[P5] = 0, Reg[P6] = 1

{  (P1) SLTIU R2, P5, P6, R0, 0x8FFFFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_016C] = 0x0000_0000, Reg[R15] = 0x1E00_0170

;************************************************************** SGTI
;----------------------------------------------------------------	<
{  (P6) SGTI R2, P1, P2, R4, 0x00000000 | NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0000, Reg[P1] = 0, Reg[P2] = 1

{  (P5) SGTI R2, P1, P2, R0, 0x8FFFFFFF | NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0170] = 0x0000_0000, Reg[R15] = 0x1E00_0174

;----------------------------------------------------------------	>
{  (P2) SGTI R2, P3, P4, R1, 0x00000000  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0001, Reg[P3] = 1, Reg[P4] = 0

{  (P1) SGTI R2, P3, P4, R0, 0x00000000  |  NOP  |  NOP  |  NOP  |  NOP  }

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0174] = 0x0000_0001, Reg[R15] = 0x1E00_0178

;----------------------------------------------------------------	=
{  (P3) SGTI R2, P5, P6, R3, 0x00000000  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0000, Reg[P5] = 0, Reg[P6] = 1

{  (P4) SGTI R2, P5, P6, R0, 0x8FFFFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0178] = 0x0000_0000, Reg[R15] = 0x1E00_017C

;************************************************************** SGTIU
;----------------------------------------------------------------	>
{  (P6) SGTIU R2, P1, P2, R0, 0x00000000  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0001, Reg[P1] = 1, Reg[P2] = 0

{  (P5) SGTIU R2, P1, P2, R0, 0x8FFFFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_017C] = 0x0000_0001, Reg[R15] = 0x1E00_0180

;----------------------------------------------------------------	=
{  (P1) SGTIU R2, P5, P6, R3, 0x00000000  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0000, Reg[P5] = 0, Reg[P6] = 1

{  (P2) SGTIU R2, P5, P6, R0, 0x00000000  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0180] = 0x0000_0000, Reg[R15] = 0x1E00_0184

;************************************************************** SEQI
;----------------------------------------------------------------	<	
{  (P6) SEQI R2, P1, P2, R4, 0x00000000 | NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0000, Reg[P1] = 0, Reg[P2] = 1

{  (P5) SEQI R2, P1, P2, R0, 0x80000000 | NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0184] = 0x0000_0000, Reg[R15] = 0x1E00_0188

;----------------------------------------------------------------	>
{  (P2) SEQI R2, P3, P4, R1, 0x00000000  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0000, Reg[P3] = 0, Reg[P4] = 1

{  (P1) SEQI R2, P3, P4, R0, 0x80000000  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0188] = 0x0000_0000, Reg[R15] = 0x1E00_018C

;----------------------------------------------------------------	=
{  (P4) SEQI R2, P5, P6, R3, 0x00000000  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0001, Reg[P5] = 1, Reg[P6] = 0

{  (P3) SEQI R2, P5, P6, R0, 0x8FFFFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_018C] = 0x0000_0001, Reg[R15] = 0x1E00_0190

;************************************************************** SEQIU
;----------------------------------------------------------------	>
{  (P5) SEQIU R2, P1, P2, R0, 0x00000000  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0000, Reg[P1] = 0, Reg[P2] = 1

{  (P6) SEQIU R2, P1, P2, R0, 0x80000000  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0190] = 0x0000_0000, Reg[R15] = 0x1E00_0194

;----------------------------------------------------------------	=
{  (P2) SEQIU R2, P5, P6, R3, 0x00000000  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0000_0001, Reg[P5] = 1, Reg[P6] = 0

{  (P1) SEQIU R2, P5, P6, R0, 0x8FFFFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0194] = 0x0000_0001, Reg[R15] = 0x1E00_0198

;************************************************************** MIN(U), MAX(U)	---- with conditional bit
;----------------------------------------------------------------	MIN
{  (P5) MIN R2, R0, R1  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x8000_0000

{  (P6) MIN R2, R1, R3  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+    |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0198] = 0x8000_0000, Reg[R15] = 0x1E00_019C

;----------------------------------------------------------------
{  (P5) MIN R4, R1, R3  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R4] = 0x0000_0000

{  (P6) MIN R4, R0, R1  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R4, R15, 4+    |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_019C] = 0x0000_0000, Reg[R15] = 0x1E00_01A0

;----------------------------------------------------------------
{  (P5) MIN R5, R0, R3  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R5] = 0x8000_0000

{  (P6) MIN R5, R0, R4  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R5, R15, 4+    |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01A0] = 0x8000_0000, Reg[R15] = 0x1E00_01A4

;----------------------------------------------------------------	MINU
{  (P5) MINU R2, R0, R1  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0FFF_FFFF

{  (P6) MINU R2, R1, R3  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+    |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01A4] = 0x0FFF_FFFF, Reg[R15] = 0x1E00_01A8

;----------------------------------------------------------------
{  (P5) MINU R4, R1, R3  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R4] = 0x0000_0000

{  (P6) MINU R4, R0, R1  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R4, R15, 4+    |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01A8] = 0x0000_0000, Reg[R15] = 0x1E00_01AC

;----------------------------------------------------------------
{  (P5) MINU R5, R0, R3  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R5] = 0x0000_0000

{  (P6) MINU R5, R0, R4  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R5, R15, 4+    |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01AC] = 0x0000_0000, Reg[R15] = 0x1E00_01B0

;----------------------------------------------------------------	MAX
{  (P5) MAX R2, R0, R1  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x0FFF_FFFF

{  (P6) MAX R2, R0, R3  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+    |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01B0] = 0x0FFF_FFFF, Reg[R15] = 0x1E00_01B4

;----------------------------------------------------------------
{  (P5) MAX R4, R1, R3  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R4] = 0x0FFF_FFFF

{  (P6) MAX R4, R0, R3  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R4, R15, 4+    |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01B4] = 0x0FFF_FFFF, Reg[R15] = 0x1E00_01B8

;----------------------------------------------------------------
{  (P5) MAX R5, R0, R3  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R5] = 0x0000_0000

{  (P6) MAX R5, R0, R4  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R5, R15, 4+    |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01B8] = 0x0000_0000, Reg[R15] = 0x1E00_01BC

;----------------------------------------------------------------	MAXU
{  (P5) MAXU R2, R0, R1  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x8000_0000

{  (P6) MAXU R2, R1, R3  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R2, R15, 4+    |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01BC] = 0x8000_0000, Reg[R15] = 0x1E00_01C0

;----------------------------------------------------------------
{  (P5) MAXU R4, R1, R3  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R4] = 0x0FFF_FFFF

{  (P6) MAXU R4, R0, R1  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R4, R15, 4+    |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01C0] = 0x0FFF_FFFF, Reg[R15] = 0x1E00_01C4

;----------------------------------------------------------------
{  (P5) MAXU R5, R0, R3  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R5] = 0x8000_0000

{  (P6) MAXU R5, R0, R4  |  NOP  |  NOP  |  NOP  |  NOP  }
; Non-Execution

{  SW R5, R15, 4+    |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01C4] = 0x8000_0000, Reg[R15] = 0x1E00_01C8


;************************************************************** MIN(U), MAX(U)	---- without conditional bit
;----------------------------------------------------------------
{  MIN R2, R0, R1  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x8000_0000

{  SW R2, R15, 4+    |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01C8] = 0x8000_0000, Reg[R15] = 0x1E00_01CC

;----------------------------------------------------------------
{  MIN R4, R1, R3  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R4] = 0x0000_0000

{  SW R4, R15, 4+    |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01CC] = 0x0000_0000, Reg[R15] = 0x1E00_01D0

;----------------------------------------------------------------
{  MIN R5, R0, R3  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R5] = 0x8000_0000									******************** Sam

{  SW R5, R15, 4+    |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01D0] = 0x8000_0000, Reg[R15] = 0x1E00_01D4	******************** Sam

;----------------------------------------------------------------
{  MINU R6, R0, R1  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R6] = 0x0FFF_FFFF

{  SW R6, R15, 4+    |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01D4] = 0x0FFF_FFFF, Reg[R15] = 0x1E00_01D8

;----------------------------------------------------------------
{  MINU R7, R3, R1  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R7] = 0x0000_0000

{  SW R7, R15, 4+    |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01D8] = 0x0000_0000, Reg[R15] = 0x1E00_01DC

;----------------------------------------------------------------
{  MINU R8, R0, R0  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R8] = 0x8000_0000

{  SW R8, R15, 4+    |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01DC] = 0x8000_0000, Reg[R15] = 0x1E00_01E0

;----------------------------------------------------------------
{  MAX R9, R0, R1  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R9] = 0x0FFF_FFFF

{  SW R9, R15, 4+    |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01E0] = 0x0FFF_FFFF, Reg[R15] = 0x1E00_01E4

;----------------------------------------------------------------
{  MAX R10, R1, R3  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R10] = 0x0FFF_FFFF

{  SW R10, R15, 4+    |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01E4] = 0x0FFF_FFFF, Reg[R15] = 0x1E00_01E8

;----------------------------------------------------------------
{  MAX R11, R3, R0  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R11] = 0x0000_0000											******************** Sam

{  SW R11, R15, 4+    |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01E8] = 0x0000_0000, Reg[R15] = 0x1E00_01EC			******************** Sam

;----------------------------------------------------------------
{  MAXU R12, R0, R1  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R12] = 0x8000_0000

{  SW R12, R15, 4+    |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01EC] = 0x8000_0000, Reg[R15] = 0x1E00_01F0

;----------------------------------------------------------------
{  MAXU R13, R3, R1  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R13] = 0x0FFF_FFFF											******************** Sam

{  SW R13, R15, 4+    |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01F0] = 0x0FFF_FFFF, Reg[R15] = 0x1E00_01F4

;----------------------------------------------------------------
{  MAXU R14, R0, R0  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R14] = 0x8000_0000

{  SW R14, R15, 4+    |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_01F4] = 0x8000_0000, Reg[R15] = 0x1E00_01F8



;************************************************************** Program Terminate
{  TRAP  |  NOP  |  NOP  |  NOP  |  NOP  } 
