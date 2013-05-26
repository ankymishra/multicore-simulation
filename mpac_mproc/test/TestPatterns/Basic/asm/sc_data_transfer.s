
BASE_ADDR = 0x2400

;************************************************************** Set Start Address
{  MOVI.L R0, 0x0000    |  NOP  |  NOP  |  NOP  |  NOP  }

{  MOVI.H R0, BASE_ADDR |  NOP  |  NOP  |  NOP  |  NOP  }


 ;************************************************************** MOVI(U), WRITE_FLAG, READ_FLAG without conditional bit
{  MOVI R1, 0x00000001  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R1] = 0x0000_0001

{  SW R1, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0000] = 0x0000_0001, Reg[R0] = 0x1E00_0004

{  MOVIU R2, 0x7FFFFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R1] = 0x7FFF_FFFF

{  SW R2, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0004] = 0x7FFF_FFFF, Reg[R0] = 0x1E00_0008

{  WRITE_FLAG R1  |  NOP  |  NOP  |  NOP  |  NOP  }
;carry = 0, overflow = 1

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  READ_FLAG R3  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R3] = 0x0000_0001

{  SW R3, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0008] = 0x0000_0001, Reg[R0] = 0x1E00_000C

{  SLT R15, P1, P2, R1, R2  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R15] = 0x0000_0001, Reg[P1] = 1, Reg[P2] = 0

 ;************************************************************** MOVI.L, MOVI.H, MOVI(U), COPY , WRITE_FLAG, READ_FLAG with conditional bit
;-------------------------------------------------------------- MOVI
 {  (P1) MOVI R1, 0xAAAABBBB  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R1] = 0xAAAA_BBBB

 {  (P2) MOVI R1, 0x00000000  |  NOP  |  NOP  |  NOP  |  NOP  }
;Not execute

{  SW R1, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_000C] = 0xAAAA_BBBB, Reg[R0] = 0x1E00_0010
;-------------------------------------------------------------- MOVIU
{  (P1) MOVIU R2, 0x77778888  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R2] = 0x7777_8888

{  (P2) MOVIU R2, 0x00000000  |  NOP  |  NOP  |  NOP  |  NOP  }
;Not execute

{  SW R2, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0010] = 0x7777_8888, Reg[R0] = 0x1E00_0014
;-------------------------------------------------------------- MOVI.L
{  (P1) MOVI.L R1, 0xFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R1] = 0xAAAA_FFFF

{  (P2) MOVI.L R1, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
;Not execute

{  SW R1, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0014] = 0xAAAA_FFFF, Reg[R0] = 0x1E00_0018
;-------------------------------------------------------------- MOVI.H
{  (P1) MOVI.H R1, 0xFFFF  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R1] = 0xFFFF_FFFF

{  (P2) MOVI.H R1, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }

{  SW R1, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0018] = 0xFFFF_FFFF, Reg[R0] = 0x1E00_001C
;-------------------------------------------------------------- COPY
{  (P1) COPY R3, R1  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R3] = 0xFFFF_FFFF

{  (P2) COPY R3, R2  |  NOP  |  NOP  |  NOP  |  NOP  }
;Not execute

{  SW R3, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_001C] = 0xFFFF_FFFF, Reg[R0] = 0x1E00_0020
;-------------------------------------------------------------- WRITE_FLAG, READ_FLAG
{  (P1) WRITE_FLAG R1  |  NOP  |  NOP  |  NOP  |  NOP  }
;carry = 1, overflow = 1

{  (P2) WRITE_FLAG R2  |  NOP  |  NOP  |  NOP  |  NOP  }
;Not execute

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  (P1) READ_FLAG R4  |  NOP  |  NOP  |  NOP  |  NOP  }
;Reg[R4] = 0x0000_0003

{  (P2) READ_FLAG R3  |  NOP  |  NOP  |  NOP  |  NOP  }
;Not execute

{  SW R3, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0020] = 0xFFFF_FFFF, Reg[R0] = 0x1E00_0024

{  SW R4, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0024] = 0x0000_0003, Reg[R0] = 0x1E00_0028

;************************************************************** Psuedo instruction
{  ENABLE_INT  |  NOP  |  NOP  |  NOP  |  NOP  }
 ;Reg[SR1] = 0x0000_0001
 
 {  SW SR1, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0028] = 0x0000_0001, Reg[R0] = 0x1E00_002C

{  DISABLE_INT  |  NOP  |  NOP  |  NOP  |  NOP  }
 ;Reg[SR1] = 0x0000_0000
 
 {  SW SR1, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_002C] = 0x0000_0000, Reg[R0] = 0x1E00_0030

{  SET_MODE 2  |  NOP  |  NOP  |  NOP  |  NOP  }
 ;Reg[SR9] = 0x0000_0002
 
 {  SW SR12, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0030] = 0x0000_0002, Reg[R0] = 0x1E00_0034

{  SET_WTMRI R5, 0x01234567  |  NOP  |  NOP  |  NOP  |  NOP  }
 ;Reg[R5] = 0x0123_4567
 
 {  SW R5, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0034] = 0x0123_4567, Reg[R0] = 0x1E00_0038

{  SET_LBCI R6, 0xAABBCCDD  |  NOP  |  NOP  |  NOP  |  NOP  }
 ;Reg[R6] = 0xAABB_CCDD
 
 {  SW R6, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0038] = 0xAABB_CCDD, Reg[R0] = 0x1E00_003C

{  SAVE_PREDN R7  |  NOP  |  NOP  |  NOP  |  NOP  }
 ;Reg[R7] = 0x0000_0003
 
 {  SW R7, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_003C] = 0x0000_0003, Reg[R0] = 0x1E00_0040

{  ROLLBACK_PREDN R7  |  NOP  |  NOP  |  NOP  |  NOP  }
 ;Reg[SR0] = 0x0000_0001
 
  {  SW SR0, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0040] = 0x0000_0003, Reg[R0] = 0x1E00_0044

{  SET_WTMR R8, R5  |  NOP  |  NOP  |  NOP  |  NOP  }
 ;Reg[R8] = 0x0123_4567
 
 {  SW R8, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0044] = 0x0123_4567, Reg[R0] = 0x1E00_0048

{  SET_LBC R9, R6  |  NOP  |  NOP  |  NOP  |  NOP  }
 ;Reg[R9] = 0xAABB_CCDD

 {  SW R9, R0, 4+  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0048] = 0xAABB_CCDD, Reg[R0] = 0x1E00_004C


 { NOP | NOP | NOP | NOP | NOP }  
 { NOP | NOP | NOP | NOP | NOP }
 { NOP | NOP | NOP | NOP | NOP }  
 { NOP | NOP | NOP | NOP | NOP }  
 { NOP | NOP | NOP | NOP | NOP }  
;************************************************************** Program Terminate
{  TRAP  |  NOP  |  NOP  |  NOP  |  NOP  }
