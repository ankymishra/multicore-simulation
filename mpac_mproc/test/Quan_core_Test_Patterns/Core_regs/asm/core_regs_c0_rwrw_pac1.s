;===============================================================================
; Author: Anthony
; Description: Access PAC0 register by PAC1;
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
  
 ;==Save data in PACDSP CORE0 
BASE_ADDR     = 0x2405;


;===== Set 0 =====
;DGBISR_OFFSET = 0x1C;
;EXCISR_OFFSET = 0x20;

;==== Set 1 =====
FIQISR_OFFSET  = 0x24;
IRQISR_OFFSET  = 0x28; 

;===== Set 2 =====
;RSV0_OFFSET           = 0x5C;
;RSV1_OFFSET           = 0x60; 
;BIU_TIMER_0_OFFSET    = 0x70;
;BIU_TIMER_1_OFFSET    = 0x78;

;===== Set 3 =====
;INTMASK_OFFSET = 0x68; width =1;
;BIU_TIMER_0_EN_OFFSET = 0x74; 
;BIU_TIMER_1_EN_OFFSET = 0x7C;

  ;=== Save the base address
  { NOP | MOVI.H D0,BASE_ADDR  | NOP   | NOP                 | NOP }
  { NOP | MOVI.L D0,0x0000     | NOP   | NOP                 | NOP }
  { NOP | NOP                  | NOP   | MOVI.H D2,BASE_ADDR | NOP }
  { NOP | NOP                  | NOP   | MOVI.L D2,0x0000    | NOP }  
  ;=== Calculate the destination address;
  { NOP | ADDI D0, D0,FIQISR_OFFSET    | NOP                 | NOP                       | NOP }
  { NOP | NOP                          | NOP                 | ADDI D2, D2,IRQISR_OFFSET | NOP }
  { NOP | MOVI D1,0x12345678           | NOP                 | NOP                       | NOP }
  { NOP | NOP                          | NOP                 | MOVI D3,0x53342212        | NOP } 
  ;=== Assign A0,A1 
  { NOP | ADDI A0,D0,0x0               | NOP                 | NOP            | NOP }
  { NOP | NOP                          | NOP                 | ADDI A1,D2,0x0 | NOP }
  ;==Save data
  { NOP | SW D1,A0,0x0                 | NOP                 | NOP            | NOP }
  { NOP | NOP                          | NOP                 | SW D3,A1,0x0   | NOP }  
  
  { NOP | NOP | NOP | NOP | NOP }  
  { TRAP | NOP | NOP | NOP | NOP }  
  
