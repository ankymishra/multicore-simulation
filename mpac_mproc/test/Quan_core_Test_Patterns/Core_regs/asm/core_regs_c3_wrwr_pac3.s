;===============================================================================
; Author: Anthony
; Description: Read data from CORE 
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
  { NOP | NOP | NOP | NOP | NOP }
  { NOP | NOP | NOP | NOP | NOP } 
  
  
;===== Save data in PACDSP CORE0 ===== 
BASE_CORE_ADDR     = 0x2435;
BASE_LDM_ADDR      = 0x2430;

;===== Set 0 =====
;DGBISR_OFFSET = 0x1C;
;EXCISR_OFFSET = 0x20;

;==== Set 1 =====
;FIQISR_OFFSET  = 0x24;
;IRQISR_OFFSET  = 0x28; 
;RSV0_OFFSET    = 0x5C;
;RSV1_OFFSET    = 0x60; 


;===== Set 2 =====
;INTMASK_OFFSET = 0x68; width =1;
BIU_TIMER_0_OFFSET    = 0x70;
BIU_TIMER_1_OFFSET    = 0x78;


;===== Set 3 =====
BIU_TIMER_0_EN_OFFSET = 0x74;  width =1
BIU_TIMER_1_EN_OFFSET = 0x7C;  width =1


;===== Set Start Address =====
 ;Save the core base address in r0;
  {  NOP |  MOVI.L a0, 0x0000           |  NOP  |  NOP  |  NOP  } 
  {  NOP |  MOVI.H a0, BASE_CORE_ADDR   |  NOP  |  NOP  |  NOP  }
        
        
;Save the local data memory  base address in r1;
  {  NOP |  MOVI.L a1, 0x0000          |  NOP  |  NOP  |  NOP  } 
  {  NOP |  MOVI.H a1, BASE_LDM_ADDR   |  NOP  |  NOP  |  NOP  }


;Load data from BIU_TIMER_0_EN,BIU_TIMER_1_EN register;                                                                                                                    

  
  {  NOP |  DLW d2, a0, BIU_TIMER_0_OFFSET  |  NOP  |  NOP  |  NOP  }
  ;20'h50070: begin tmp_rdata = {31'd0,reg_BTR_timer_active0,reg_biu_timer0}; tmp_valid = 1'b1; end   
  {  NOP |  DLW d4, a0, BIU_TIMER_1_OFFSET  |  NOP  |  NOP  |  NOP  }
  ;20'h50078: begin tmp_rdata = {31'd0,reg_BTR_timer_active1,reg_biu_timer1}; tmp_valid = 1'b1; end 
  { NOP | NOP | NOP | NOP | NOP }
  { NOP |  SW d3 ,a1,BIU_TIMER_0_EN_OFFSET  | NOP | NOP | NOP }  
  { NOP |  SW d5 ,a1,BIU_TIMER_1_EN_OFFSET  | NOP | NOP | NOP }  
     
   
  { NOP | NOP | NOP | NOP | NOP }  
  { TRAP | NOP | NOP | NOP | NOP }  
  
