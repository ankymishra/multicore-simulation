C0_M1_BASE_ADDRESS = 0x24000000
C1_M1_BASE_ADDRESS = 0x24100000
C2_M1_BASE_ADDRESS = 0x24200000
C3_M1_BASE_ADDRESS = 0x24300000

M1_BANK0 = 0x0000  
M1_BANK1 = 0x1000  
M1_BANK2 = 0x2000  
M1_BANK3 = 0x3000  
M1_BANK4 = 0x4000  
M1_BANK5 = 0x5000  
M1_BANK6 = 0x6000  
M1_BANK7 = 0x7000  
                   
M1_SUBBANK0 = 0x000
M1_SUBBANK1 = 0x200
M1_SUBBANK2 = 0x400
M1_SUBBANK3 = 0x600
M1_SUBBANK4 = 0x800
M1_SUBBANK5 = 0xA00
M1_SUBBANK6 = 0xC00
M1_SUBBANK7 = 0xE00


DDR_BASE_ADDRESS = 0x30010000

DDR_BANK0 = 0x000
DDR_BANK1 = 0x200
DDR_BANK2 = 0x400
DDR_BANK3 = 0x600
DDR_BANK4 = 0x800
DDR_BANK5 = 0xA00
DDR_BANK6 = 0xC00
DDR_BANK7 = 0xE00

INI_NUM  = 128

initial_flag = 0x30000000
          
SOURCE_BASE = DDR_BASE_ADDRESS   + DDR_BANK0
DESTIN_BASE = C3_M1_BASE_ADDRESS + M1_BANK3 + M1_SUBBANK0

;; ==============================================================
;; === 0. core1 initial core1_ready_flag, [0x3000_0004] = 0x1 ===
;; ==============================================================
  {  MOVIU R0, initial_flag | NOP | NOP | NOP | NOP }
  {  MOVIU R1, 0x1          | NOP | NOP | NOP | NOP }
  {  SW R1, R0, 0x0         | NOP | NOP | NOP | NOP }
  {  NOP                    | NOP | NOP | NOP | NOP }
  {  NOP                    | NOP | NOP | NOP | NOP }
  
;; ============================================
;; 1. core1 polling core0_ready_flag & 
;;                  core1_ready_flag & 
;;                  core2_ready_flag & 
;;                  core3_ready_flag = 0x1 
;; ============================================
POLLING_QUAD_CORE_READY:    
{ MOVIU R0, 0x30000000        | NOP | NOP | NOP | NOP }
{ CLR R1                      | NOP | NOP | NOP | NOP }
{ CLR R2                      | NOP | NOP | NOP | NOP }
{ CLR R3                      | NOP | NOP | NOP | NOP }
{ CLR R4                      | NOP | NOP | NOP | NOP }
{ LW R1, R0, 0x0              | NOP | NOP | NOP | NOP }
{ LW R2, R0, 0x4              | NOP | NOP | NOP | NOP }
{ LW R3, R0, 0x8              | NOP | NOP | NOP | NOP }
{ LW R4, R0, 0xC              | NOP | NOP | NOP | NOP }
{ NOP                         | NOP | NOP | NOP | NOP }
{ NOP                         | NOP | NOP | NOP | NOP }
{ AND R1, R1, R2              | NOP | NOP | NOP | NOP }
{ AND R3, R3, R4              | NOP | NOP | NOP | NOP }
{ AND R1, R1, R3              | NOP | NOP | NOP | NOP }
{ SEQI r2, p1, p2, r1, 0x1    | NOP | NOP | NOP | NOP }
{ (p2) B POLLING_QUAD_CORE_READY | NOP | NOP | NOP | NOP }
{ NOP                            | NOP | NOP | NOP | NOP }
{ NOP                            | NOP | NOP | NOP | NOP }  
{ NOP                            | NOP | NOP | NOP | NOP }
{ NOP                            | NOP | NOP | NOP | NOP }  
{ NOP                            | NOP | NOP | NOP | NOP }

;; ====================================================================
;; 0x2400_0400 ~ 0x2400_05FF, r 0x3, core1 emau read to ddr(0x3001_0400)
;; ====================================================================



  
  {  MOVIU R0, SOURCE_BASE | NOP | NOP | NOP | NOP }
  {  MOVIU R1, DESTIN_BASE | NOP | NOP | NOP | NOP }  
  {  MOVIU R10, INI_NUM    | NOP | NOP | NOP | NOP }
READ_C0_M1_BANK:
  {  LW R2, R0, 4+         | NOP | NOP | NOP | NOP }
  {  NOP                   | NOP | NOP | NOP | NOP }
  {  NOP                   | NOP | NOP | NOP | NOP }
  {  SW R2, R1, 4+         | NOP | NOP | NOP | NOP }
  {  NOP                   | NOP | NOP | NOP | NOP }
  {  NOP                   | NOP | NOP | NOP | NOP }
  
  {  LBCB R10, READ_C0_M1_BANK  | NOP | NOP | NOP | NOP }
  {  NOP                        | NOP | NOP | NOP | NOP }
  {  NOP                        | NOP | NOP | NOP | NOP }
  {  NOP                        | NOP | NOP | NOP | NOP }
  {  NOP                        | NOP | NOP | NOP | NOP }
  {  NOP                        | NOP | NOP | NOP | NOP }
                                
  { NOP                         | NOP | NOP | NOP | NOP }
  { NOP                         | NOP | NOP | NOP | NOP }  
  { NOP                         | NOP | NOP | NOP | NOP }
  { NOP                         | NOP | NOP | NOP | NOP }  
  { NOP                         | NOP | NOP | NOP | NOP }
  { TRAP                        | NOP | NOP | NOP | NOP }



