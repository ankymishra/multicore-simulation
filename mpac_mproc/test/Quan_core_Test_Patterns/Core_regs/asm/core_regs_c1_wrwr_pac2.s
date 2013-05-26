;===============================================================================
; Author: Anthony
; Description: Write data to controlling register of PAC1; 
; Date: 2010/11/22
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
 
;==Save data in PACDSP CORE0 
BASE_ADDR     = 0x2415;  

;===== Set 0 =====
;DGBISR_OFFSET = 0x1C;
;EXCISR_OFFSET = 0x20;

;==== Set 1 =====
;FIQISR_OFFSET  = 0x24;
;IRQISR_OFFSET  = 0x28; 

;===== Set 2 =====
RSV1_OFFSET           = 0x60; 
BIU_TIMER_0_OFFSET    = 0x70;
BIU_TIMER_1_OFFSET    = 0x78;

;===== Set 3 =====
;INTMASK_OFFSET = 0x68;         width =1;
;BIU_TIMER_0_EN_OFFSET = 0x74;  width =1;
;BIU_TIMER_1_EN_OFFSET = 0x7C;  width =1;

  ;=== Save the base address
  { NOP | NOP |MOVI.H D0,BASE_ADDR  | NOP   | NOP }
  { NOP | NOP |MOVI.L D0,0x0000     | NOP   | NOP }
  
  ;== Save data to RSV1 register;
  { NOP | NOP |  MOVI D3,0x24681357                    | NOP   | NOP }
  { NOP | NOP | MOVI D1,RSV1_OFFSET    | NOP   | NOP  }
  { NOP | ADD A0,D0,D1 | NOP                    |  NOP   | NOP }
  { NOP | SW D3,A0,0x0                 | NOP                  | NOP   |  NOP }
 
   ;== Save data to ,BIU_TIMER_0 register;
  { NOP | NOP |  MOVI D3,0x98768931                    | NOP   | NOP }
  { NOP | NOP | MOVI D1,BIU_TIMER_0_OFFSET    | NOP   | NOP  }
  { NOP | ADD A0,D0,D1 | NOP                    |  NOP   | NOP }
  { NOP | SW D3,A0,0x0                 | NOP                  | NOP   |  NOP }
  
  ;== Save data to ,BIU_TIMER_1 register;
  { NOP | NOP |  MOVI D3,0x34135994                    | NOP   | NOP }
  { NOP | NOP | MOVI D1,BIU_TIMER_1_OFFSET    | NOP   | NOP  }
  { NOP | ADD A0,D0,D1 | NOP                    |  NOP   | NOP }
  { NOP | SW D3,A0,0x0                 | NOP                  | NOP   |  NOP }
    
  { NOP | NOP | NOP | NOP | NOP }  
  { TRAP | NOP | NOP | NOP | NOP }  
  
