;===============================================================================
; Author: Anthony
; Description: Access M2 DMU controlling register
; Date: 2010/11/28
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
  
;==== Setting of M2 DMU address; 
M2_DMU_Base                  = 0x25810000;

M2_Priority_offset           = 0x0000; ;2 bits;
P0_contention_counter_offset = 0x0020; ;32 bits;  
P1_contention_counter_offset = 0x0024; ;32 bits;   

P2_contention_counter_offset = 0x0028; ;32 bits;  
P3_contention_counter_offset = 0x002C; ;32 bits;   

P4_contention_counter_offset = 0x0030; ;32 bits;   
P5_contention_counter_offset = 0x0034; ;32 bits;  

P6_contention_counter_offset = 0x0038; ;32 bits;  
P7_contention_counter_offset = 0x003C; ;32 bits;  

;==== Test for P2_contention_counter,P3_contention_counter; ====
    
  { movi r0, M2_DMU_Base          | movi a0, M2_DMU_Base         | nop | nop | nop }
  { NOP | NOP | NOP | NOP | NOP } 

  { movi r1, 0x24681357           | movi d0,0xFEDCBA98           | nop | nop | nop }
  { NOP | NOP | NOP | NOP | NOP }   
  { NOP | NOP | NOP | NOP | NOP }   
  
  { sw r1, r0, P3_contention_counter_offset  | sw d0, a0, P2_contention_counter_offset  | nop | nop | nop }

  { NOP  | NOP | NOP | NOP | NOP }  
  { NOP  | NOP | NOP | NOP | NOP }  
  { TRAP | NOP | NOP | NOP | NOP }  
  
