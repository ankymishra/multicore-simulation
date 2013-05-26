;===============================================================================
; Author: Anthony
; Description: Read PAC0 Register by PAC2; 
; Date: 2010/11/20
;===============================================================================

;=== Polling M2 for sync. ===
  { MOVI r0, 0x25005000 | NOP | NOP | NOP | NOP }
_LOOP:    
  { LW r1, r0, 0x0  | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }
  { SEQI r2, p1, p2, r1, 0xFFFFFFFF | NOP | NOP | NOP | NOP }
  { (p2) B _LOOP                    | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }  
  { NOP | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP }  
  { NOP | NOP | NOP | NOP | NOP } 

;===== Save data in PACDSP CORE0 ===== 
BASE_CORE_ADDR     = 0x2405;
BASE_LDM_ADDR      = 0x2400;

;===== Set 0 =====
;DGBISR_OFFSET = 0x1C;
;EXCISR_OFFSET = 0x20;

;==== Set 1 =====
;FIQISR_OFFSET  = 0x24;
;IRQISR_OFFSET  = 0x28; 
;RSV0_OFFSET    = 0x5C;
;RSV1_OFFSET    = 0x60; 

;===== Set 2 =====
INTMASK_OFFSET = 0x68; width =1;
BIU_TIMER_0_OFFSET    = 0x70;
BIU_TIMER_1_OFFSET    = 0x78;

;===== Set 3 =====
;BIU_TIMER_0_EN_OFFSET = 0x74;  width =1
;BIU_TIMER_1_EN_OFFSET = 0x7C;  width =1
    

;===== Set Start Address =====
 ;Save the core base address in r0;
  { NOP | NOP | NOP  |  MOVI.L d0, 0x0000  |  NOP  } 
  { NOP | NOP | NOP  |  MOVI.H d0, BASE_CORE_ADDR  |  NOP  }
  
;Save the local data memory  base address in r1;
  { NOP | NOP | NOP  |  MOVI.L a0, 0x0000  |  NOP  } 
  { NOP | NOP | NOP  |  MOVI.H a0, BASE_LDM_ADDR  |  NOP  }  


 ;Calculate the addreess to read data;
  { NOP | NOP | NOP | ADDI a1,d0,BIU_TIMER_0_OFFSET | NOP }
  { NOP | NOP | NOP | ADDI a2,d0,BIU_TIMER_1_OFFSET | NOP } 
  { NOP | NOP | NOP | ADDI a3,d0,INTMASK_OFFSET | NOP } 
  
   ;Load data;
  { NOP | NOP | NOP | LW d1, a1,0x0 | NOP }  
  { NOP | NOP | NOP | LW d2, a2,0x0 | NOP } 
  ;From INTMASK_OFFSET-2,since INTMASK from 68 and 70 is  BIU_TIMER_0_OFFSET;
  { NOP | NOP | NOP | LW d3, a3,0x0 | NOP }  
  
    ;Save data to local data memory;     
  { NOP | NOP | NOP | SW d1 ,a0,BIU_TIMER_0_OFFSET | NOP }   
  { NOP | NOP | NOP | SW d2 ,a0,BIU_TIMER_1_OFFSET | NOP }   
  { NOP | NOP | NOP | SW d3 ,a0,INTMASK_OFFSET | NOP }   
  
  { NOP | NOP | NOP | NOP | NOP } 
  { TRAP | NOP | NOP | NOP | NOP }  
  
