
;; ###################
;; ### system flag ###
;; ###################
;; core0_ready_flag, [0x3000_0000], 0x0 = not ready, 0x1 = ready
;; core1_ready_flag, [0x3000_0004], 0x0 = not ready, 0x1 = ready
;; core2_ready_flag, [0x3000_0008], 0x0 = not ready, 0x1 = ready
;; core3_ready_flag, [0x3000_000c], 0x0 = not ready, 0x1 = ready

;; ##########################
;; ### m1_c0_bank0 layout ###
;; ###########################
;; # 0x2400_0000 ~ 0x2400_01FF, r 0x1, core0 emau read to ddr(0x3001_0000)
;; # 0x2400_0200 ~ 0x2400_03FF, r 0x2, m1_dma0 read to ddr(0x3001_0200)
;;   0x2400_0400 ~ 0x2400_05FF, r 0x3, core1 emau read to ddr(0x3001_0400)
;;   0x2400_0600 ~ 0x2400_07FF, r 0x4, core2 emau read to ddr(0x3001_0600)
;;   0x2400_0800 ~ 0x2400_09FF, r 0x5, core3 emau read to ddr(0x3001_0800)
;; # 0x2400_0A00 ~ 0x2400_0BFF, r 0x6, m2_dma0 read to m2(0x2500_0000)
;; # 0x2400_0C00 ~ 0x2400_0DFF, r 0x7, m2_dma1 read to m2(0x2500_0200)
;;   0x2400_0E00 ~ 0x2400_0FFF, null

;;-----M1 memory map
C0_M1_base_address = 0x24000000
C1_M1_base_address = 0x24100000
C2_M1_base_address = 0x24200000
C3_M1_base_address = 0x24300000

M1_bank0 = 0x0000
M1_bank1 = 0x1000
M1_bank2 = 0x2000
M1_bank3 = 0x3000
M1_bank4 = 0x4000
M1_bank5 = 0x5000
M1_bank6 = 0x6000
M1_bank7 = 0x7000

M1_SubBank0 = 0x000
M1_SubBank1 = 0x200
M1_SubBank2 = 0x400
M1_SubBank3 = 0x600
M1_SubBank4 = 0x800
M1_SubBank5 = 0xa00
M1_SubBank6 = 0xc00
M1_SubBank7 = 0xe00
;;--------------------

;;-----M2 memory map
M2_base_address = 0x25000000

M2_bank0 = 0x0000
M2_bank1 = 0x4000
M2_bank2 = 0x8000
M2_bank3 = 0xc000

M2_SubBank0 = 0x000
M2_SubBank1 = 0x200
M2_SubBank2 = 0x400
M2_SubBank3 = 0x600
;;--------------------

;;-----DDR memory map
DDR_base_address = 0x30010000

DDR_bank0 = 0x000
DDR_bank1 = 0x200
DDR_bank2 = 0x400
DDR_bank3 = 0x600
DDR_bank4 = 0x800
;;--------------------

;;-----M1_DMA memory map
C0_M1_DMA_base_address = 0x2405c000
C1_M1_DMA_base_address = 0x2415c000
C2_M1_DMA_base_address = 0x2425c000
C3_M1_DMA_base_address = 0x2435c000

M1_DMASAR0 = 0x70
M1_DMADAR0 = 0x74
M1_DMASGR0 = 0x78
M1_DMADSR0 = 0x7c
M1_DMACTL0 = 0x80
M1_DMAEN0  = 0x84
M1_DMASTAT = 0x54

;;--------------------

;;-----M2_DMA memory map
M2_DMA_base_address = 0x25820000

M2_DMA0_SAR0 = 0x70
M2_DMA0_DAR0 = 0x74
M2_DMA0_SGR0 = 0x78
M2_DMA0_DSR0 = 0x7c
M2_DMA0_CTL0 = 0x80
M2_DMA0_EN0  = 0x84

M2_DMA1_SAR0 = 0x170
M2_DMA1_DAR0 = 0x174
M2_DMA1_SGR0 = 0x178
M2_DMA1_DSR0 = 0x17c
M2_DMA1_CTL0 = 0x180
M2_DMA1_EN0  = 0x184

M2_DMASTAT   = 0x54

;;--------------------
;#######################
;#######################
;;--------------------
;;memory bank
M2_start_address_SubBank0   = M2_base_address + M2_bank0 + M2_SubBank0
M2_start_address_SubBank1   = M2_base_address + M2_bank0 + M2_SubBank1

DDR_start_address_SubBank0  = DDR_base_address + DDR_bank0
DDR_start_address_SubBank1  = DDR_base_address + DDR_bank1
DDR_start_address_SubBank2  = DDR_base_address + DDR_bank2
DDR_start_address_SubBank3  = DDR_base_address + DDR_bank3
DDR_start_address_SubBank4  = DDR_base_address + DDR_bank4
DDR_start_address_SubBank5  = DDR_base_address + DDR_bank5
;;
;;DMA
M1_DMA0_start_SAR0 = C1_M1_DMA_base_address + M1_DMASAR0
M1_DMA0_start_DAR0 = C1_M1_DMA_base_address + M1_DMADAR0
M1_DMA0_start_SGR0 = C1_M1_DMA_base_address + M1_DMASGR0
M1_DMA0_start_DSR0 = C1_M1_DMA_base_address + M1_DMADSR0
M1_DMA0_start_CTL0 = C1_M1_DMA_base_address + M1_DMACTL0
M1_DMA0_start_EN0  = C1_M1_DMA_base_address + M1_DMAEN0

M2_DMA0_start_SAR0 = M2_DMA_base_address + M2_DMA0_SAR0
M2_DMA0_start_DAR0 = M2_DMA_base_address + M2_DMA0_DAR0
M2_DMA0_start_SGR0 = M2_DMA_base_address + M2_DMA0_SGR0
M2_DMA0_start_DSR0 = M2_DMA_base_address + M2_DMA0_DSR0
M2_DMA0_start_CTL0 = M2_DMA_base_address + M2_DMA0_CTL0
M2_DMA0_start_EN0  = M2_DMA_base_address + M2_DMA0_EN0

M2_DMA1_start_SAR0 = M2_DMA_base_address + M2_DMA1_SAR0
M2_DMA1_start_DAR0 = M2_DMA_base_address + M2_DMA1_DAR0
M2_DMA1_start_SGR0 = M2_DMA_base_address + M2_DMA1_SGR0
M2_DMA1_start_DSR0 = M2_DMA_base_address + M2_DMA1_DSR0
M2_DMA1_start_CTL0 = M2_DMA_base_address + M2_DMA1_CTL0
M2_DMA1_start_EN0  = M2_DMA_base_address + M2_DMA1_EN0

M1_DMA0_start_STAT = C1_M1_DMA_base_address + M1_DMASTAT
M2_DMA0_start_STAT = M2_DMA_base_address + M2_DMASTAT
;;

;;----------------------------------------
M1_start_address_SubBank0 = C1_M1_base_address + M1_bank0 + M1_SubBank0
M1_start_address_SubBank1 = C1_M1_base_address + M1_bank0 + M1_SubBank1
M1_start_address_SubBank2 = C1_M1_base_address + M1_bank0 + M1_SubBank2
M1_start_address_SubBank3 = C1_M1_base_address + M1_bank0 + M1_SubBank3
M1_start_address_SubBank4 = C1_M1_base_address + M1_bank0 + M1_SubBank4
M1_start_address_SubBank5 = C1_M1_base_address + M1_bank0 + M1_SubBank5
M1_start_address_SubBank6 = C1_M1_base_address + M1_bank0 + M1_SubBank6
M1_start_address_SubBank7 = C1_M1_base_address + M1_bank0 + M1_SubBank7

initial_flag = 0x30000004;


EMAU_COREX_M1  = DDR_base_address   + DDR_bank2
EMAU_COREX_DDR = C1_M1_base_address + M1_bank0 + M1_SubBank2

;;set reg
M1_SAR0_DATA = DDR_start_address_SubBank1
M1_DAR0_DATA = M1_start_address_SubBank1
M1_CTL0_DATA = 0x00200004 ; DMA_CTL_DATA, BSZ[31:12], DSEN[9], SGEN[8], Int2Ext[3], Burst[2], TRZ[1:0]
M1_EN0_DATA  = 0x1

M2_dma0_SAR0_DATA = M2_start_address_SubBank0
M2_dma0_DAR0_DATA = M1_start_address_SubBank5
M2_dma0_CTL0_DATA = 0x0020000c ; DMA_CTL_DATA, BSZ[31:12], DSEN[9], SGEN[8], Int2Ext[3], Burst[2], TRZ[1:0]
M2_dma0_EN0_DATA  = 0x1

M2_dma1_SAR0_DATA = M2_start_address_SubBank1
M2_dma1_DAR0_DATA = M1_start_address_SubBank6
M2_dma1_CTL0_DATA = 0x0020000c ; DMA_CTL_DATA, BSZ[31:12], DSEN[9], SGEN[8], Int2Ext[3], Burst[2], TRZ[1:0]
M2_dma1_EN0_DATA  = 0x1


;; =====================================================================================
;; === 1.1 initial memory M1_SubBank0 ~ M1_SubBank6 =0                               ===
;; === 1.2 initial M2_SubBank0=6 ,M2_SubBank0=7                                      ===
;; === 1.3 initial DDR_SubBank0=1  ~ DDR_SubBank4=5                                  ===
;; =====================================================================================
INI_NUM_M2   = 128
INI_NUM_DDR  = 128
INI_NUM_M1   = 1024
INI_NUM_M1_1 = 128
test_pattern:
;;1.1
;;initial M1 = 0
{ MOVIU r0,0                          | NOP | NOP | NOP | NOP }
{ MOVIU r1,M1_start_address_SubBank0  | NOP | NOP | NOP | NOP }
{ MOVIU r2,INI_NUM_M1                 | NOP | NOP | NOP | NOP }
INI_M1_LOOP:
{ SW r0,r1,4+                         | NOP | NOP | NOP | NOP }
{ LBCB r2,INI_M1_LOOP                 | NOP | NOP | NOP | NOP }
{ NOP                                 | NOP | NOP | NOP | NOP }
{ NOP                                 | NOP | NOP | NOP | NOP }
{ NOP                                 | NOP | NOP | NOP | NOP }
{ NOP                                 | NOP | NOP | NOP | NOP }
{ NOP                                 | NOP | NOP | NOP | NOP }
{ NOP                                 | NOP | NOP | NOP | NOP }
;;1.2
;; initial M2_SubBank0=6
{ MOVIU r0,6                          | NOP | NOP | NOP | NOP }
{ MOVIU r1,M2_start_address_SubBank0  | NOP | NOP | NOP | NOP }
{ MOVIU r2,INI_NUM_M2                 | NOP | NOP | NOP | NOP }
INI_M2_SubBank0_LOOP:
{ SW r0,r1,4+                  | NOP | NOP | NOP | NOP }
{ LBCB r2,INI_M2_SubBank0_LOOP | NOP | NOP | NOP | NOP }
{ NOP                          | NOP | NOP | NOP | NOP }
{ NOP                          | NOP | NOP | NOP | NOP }
{ NOP                          | NOP | NOP | NOP | NOP }
{ NOP                          | NOP | NOP | NOP | NOP }
{ NOP                          | NOP | NOP | NOP | NOP }
{ NOP                          | NOP | NOP | NOP | NOP }

;; initial M2_SubBank1=7
{ MOVIU r0,7                          | NOP | NOP | NOP | NOP }
{ MOVIU r1,M2_start_address_SubBank1  | NOP | NOP | NOP | NOP }
{ MOVIU r2,INI_NUM_M2                 | NOP | NOP | NOP | NOP }
INI_M2_SubBank1_LOOP:
{ SW r0,r1,4+                  | NOP | NOP | NOP | NOP }
{ LBCB r2,INI_M2_SubBank1_LOOP | NOP | NOP | NOP | NOP }
{ NOP                          | NOP | NOP | NOP | NOP }
{ NOP                          | NOP | NOP | NOP | NOP }
{ NOP                          | NOP | NOP | NOP | NOP }
{ NOP                          | NOP | NOP | NOP | NOP }
{ NOP                          | NOP | NOP | NOP | NOP }
{ NOP                          | NOP | NOP | NOP | NOP }

;;1.3
;; initial DDR_SubBank0=1
{ MOVIU r0,1                          | NOP | NOP | NOP | NOP }
{ MOVIU r1,DDR_start_address_SubBank0 | NOP | NOP | NOP | NOP }
{ MOVIU r2,INI_NUM_DDR                | NOP | NOP | NOP | NOP }
INI_DDR_SubBank0_LOOP:
{ SW r0,r1,4+                   | NOP | NOP | NOP | NOP }
{ LBCB r2,INI_DDR_SubBank0_LOOP | NOP | NOP | NOP | NOP }
{ NOP                           | NOP | NOP | NOP | NOP }
{ NOP                           | NOP | NOP | NOP | NOP }
{ NOP                           | NOP | NOP | NOP | NOP }
{ NOP                           | NOP | NOP | NOP | NOP }
{ NOP                           | NOP | NOP | NOP | NOP }
{ NOP                           | NOP | NOP | NOP | NOP }

;; initial DDR_SubBank1=2
{ MOVIU r0,2                          | NOP | NOP | NOP | NOP }
{ MOVIU r1,DDR_start_address_SubBank1 | NOP | NOP | NOP | NOP }
{ MOVIU r2,INI_NUM_DDR                | NOP | NOP | NOP | NOP }
INI_DDR_SubBank1_LOOP:
{ SW r0,r1,4+                   | NOP | NOP | NOP | NOP }
{ LBCB r2,INI_DDR_SubBank1_LOOP | NOP | NOP | NOP | NOP }
{ NOP                           | NOP | NOP | NOP | NOP }
{ NOP                           | NOP | NOP | NOP | NOP }
{ NOP                           | NOP | NOP | NOP | NOP }
{ NOP                           | NOP | NOP | NOP | NOP }
{ NOP                           | NOP | NOP | NOP | NOP }
{ NOP                           | NOP | NOP | NOP | NOP }

;; initial DDR_SubBank2=3
{ MOVIU r0,3                          | NOP | NOP | NOP | NOP }
{ MOVIU r1,DDR_start_address_SubBank2 | NOP | NOP | NOP | NOP }
{ MOVIU r2,INI_NUM_DDR                | NOP | NOP | NOP | NOP }
INI_DDR_SubBank2_LOOP:
{ SW r0,r1,4+                   | NOP | NOP | NOP | NOP }
{ LBCB r2,INI_DDR_SubBank2_LOOP | NOP | NOP | NOP | NOP }
{ NOP                           | NOP | NOP | NOP | NOP }
{ NOP                           | NOP | NOP | NOP | NOP }
{ NOP                           | NOP | NOP | NOP | NOP }
{ NOP                           | NOP | NOP | NOP | NOP }
{ NOP                           | NOP | NOP | NOP | NOP }
{ NOP                           | NOP | NOP | NOP | NOP }

;; initial DDR_SubBank3=4
{ MOVIU r0,4                          | NOP | NOP | NOP | NOP }
{ MOVIU r1,DDR_start_address_SubBank3 | NOP | NOP | NOP | NOP }
{ MOVIU r2,INI_NUM_DDR                | NOP | NOP | NOP | NOP }
INI_DDR_SubBank3_LOOP:
{ SW r0,r1,4+                   | NOP | NOP | NOP | NOP }
{ LBCB r2,INI_DDR_SubBank3_LOOP | NOP | NOP | NOP | NOP }
{ NOP                           | NOP | NOP | NOP | NOP }
{ NOP                           | NOP | NOP | NOP | NOP }
{ NOP                           | NOP | NOP | NOP | NOP }
{ NOP                           | NOP | NOP | NOP | NOP }
{ NOP                           | NOP | NOP | NOP | NOP }
{ NOP                           | NOP | NOP | NOP | NOP }

;; initial DDR_SubBank4=5
{ MOVIU r0,5                          | NOP | NOP | NOP | NOP }
{ MOVIU r1,DDR_start_address_SubBank4 | NOP | NOP | NOP | NOP }
{ MOVIU r2,INI_NUM_DDR                | NOP | NOP | NOP | NOP }
INI_DDR_SubBank4_LOOP:
{ SW r0,r1,4+                   | NOP | NOP | NOP | NOP }
{ LBCB r2,INI_DDR_SubBank4_LOOP | NOP | NOP | NOP | NOP }
{ NOP                           | NOP | NOP | NOP | NOP }
{ NOP                           | NOP | NOP | NOP | NOP }
{ NOP                           | NOP | NOP | NOP | NOP }
{ NOP                           | NOP | NOP | NOP | NOP }
{ NOP                           | NOP | NOP | NOP | NOP }
{ NOP                           | NOP | NOP | NOP | NOP }


;; =====================================================================================
;; === 2.1 set m1_dma,  SubBank1 -> DDR_bank1                                        ===
;; === 2.2 set m2_dma0, SubBank5 -> M2_bank0                                         ===
;; === 2.3 set m2_dma0, SubBank6 -> M2_bank1                                         ===
;; =====================================================================================
;;2.1 set m1_dma
{ MOVIU r0,M1_DMA0_start_SAR0 | NOP | NOP | NOP | NOP }
{ MOVIU r1,M1_DMA0_start_DAR0 | NOP | NOP | NOP | NOP }
{ MOVIU r2,M1_DMA0_start_CTL0 | NOP | NOP | NOP | NOP }

{ MOVIU r3,M1_SAR0_DATA       | NOP | NOP | NOP | NOP }
{ MOVIU r4,M1_DAR0_DATA       | NOP | NOP | NOP | NOP }
{ MOVIU r5,M1_CTL0_DATA       | NOP | NOP | NOP | NOP }

{ SW r3,r0,0                  | NOP | NOP | NOP | NOP }
{ SW r4,r1,0                  | NOP | NOP | NOP | NOP }
{ SW r5,r2,0                  | NOP | NOP | NOP | NOP }

;;2.2 set m2_dma0
{ MOVIU r0,M2_DMA0_start_SAR0 | NOP | NOP | NOP | NOP }
{ MOVIU r1,M2_DMA0_start_DAR0 | NOP | NOP | NOP | NOP }
{ MOVIU r2,M2_DMA0_start_CTL0 | NOP | NOP | NOP | NOP }

{ MOVIU r3,M2_dma0_SAR0_DATA  | NOP | NOP | NOP | NOP }
{ MOVIU r4,M2_dma0_DAR0_DATA  | NOP | NOP | NOP | NOP }
{ MOVIU r5,M2_dma0_CTL0_DATA  | NOP | NOP | NOP | NOP }

{ SW r3,r0,0                  | NOP | NOP | NOP | NOP }
{ SW r4,r1,0                  | NOP | NOP | NOP | NOP }
{ SW r5,r2,0                  | NOP | NOP | NOP | NOP }

;;2.2 set m2_dma1
{ MOVIU r0,M2_DMA1_start_SAR0 | NOP | NOP | NOP | NOP }
{ MOVIU r1,M2_DMA1_start_DAR0 | NOP | NOP | NOP | NOP }
{ MOVIU r2,M2_DMA1_start_CTL0 | NOP | NOP | NOP | NOP }

{ MOVIU r3,M2_dma1_SAR0_DATA  | NOP | NOP | NOP | NOP }
{ MOVIU r4,M2_dma1_DAR0_DATA  | NOP | NOP | NOP | NOP }
{ MOVIU r5,M2_dma1_CTL0_DATA  | NOP | NOP | NOP | NOP }

{ SW r3,r0,0                  | NOP | NOP | NOP | NOP }
{ SW r4,r1,0                  | NOP | NOP | NOP | NOP }
{ SW r5,r2,0                  | NOP | NOP | NOP | NOP }


;; ==============================================================
;; === 3.  initial flag,                                      ===
;; ==============================================================
  {  MOVIU R0, initial_flag | NOP | NOP | NOP | NOP }
  {  MOVIU R1, 0x1          | NOP | NOP | NOP | NOP }
  {  SW R1, R0, 0x0         | NOP | NOP | NOP | NOP }
  {  NOP                    | NOP | NOP | NOP | NOP }
  {  NOP                    | NOP | NOP | NOP | NOP }

;; ============================================
;; 4. core0 polling core0_ready_flag &
;;                  core1_ready_flag &
;;                  core2_ready_flag &
;;                  core3_ready_flag = 0x1
;; ============================================
POLLING_QUAD_CORE_READY:
{ MOVIU R0, 0x30000000           | NOP | NOP | NOP | NOP }
{ CLR R1                         | NOP | NOP | NOP | NOP }
{ CLR R2                         | NOP | NOP | NOP | NOP }
{ CLR R3                         | NOP | NOP | NOP | NOP }
{ CLR R4                         | NOP | NOP | NOP | NOP }
{ LW R1, R0, 0x0                 | NOP | NOP | NOP | NOP }
{ LW R2, R0, 0x4                 | NOP | NOP | NOP | NOP }
{ LW R3, R0, 0x8                 | NOP | NOP | NOP | NOP }
{ LW R4, R0, 0xC                 | NOP | NOP | NOP | NOP }
{ NOP                            | NOP | NOP | NOP | NOP }
{ NOP                            | NOP | NOP | NOP | NOP }
{ AND R1, R1, R2                 | NOP | NOP | NOP | NOP }
{ AND R3, R3, R4                 | NOP | NOP | NOP | NOP }
{ AND R1, R1, R3                 | NOP | NOP | NOP | NOP }
{ SEQI r2, p1, p2, r1, 0x1       | NOP | NOP | NOP | NOP }
{ (p2) B POLLING_QUAD_CORE_READY | NOP | NOP | NOP | NOP }
{ NOP                            | NOP | NOP | NOP | NOP }
{ NOP                            | NOP | NOP | NOP | NOP }
{ NOP                            | NOP | NOP | NOP | NOP }
{ NOP                            | NOP | NOP | NOP | NOP }
{ NOP                            | NOP | NOP | NOP | NOP }


;;============================================
;;5. set M1 ,M2 DMA ENABLE
;;============================================
{ MOVIU r0,0x1                | NOP | NOP | NOP | NOP }
{ MOVIU r1,M1_DMA0_start_EN0  | NOP | NOP | NOP | NOP }
{ MOVIU r2,M2_DMA0_start_EN0  | NOP | NOP | NOP | NOP }
{ MOVIU r3,M2_DMA1_start_EN0  | NOP | NOP | NOP | NOP }
{ SW r0,r1,0                  | NOP | NOP | NOP | NOP }
{ SW r0,r2,0                  | NOP | NOP | NOP | NOP }
{ SW r0,r3,0                  | NOP | NOP | NOP | NOP }
{ NOP                         | NOP | NOP | NOP | NOP }


;;====================================================
;;6. core1 emau, M1_SubBank2 -> DDR_SubBank2
;;     read size = 128 words
;;====================================================

{  MOVIU R0, EMAU_COREX_M1    | NOP | NOP | NOP | NOP }
{  MOVIU R1, EMAU_COREX_DDR   | NOP | NOP | NOP | NOP }
{  MOVIU R10, INI_NUM_M1_1    | NOP | NOP | NOP | NOP }
READ_C0_M1_BANK:
{  LW R2, R0, 4+              | NOP | NOP | NOP | NOP }
{  NOP                        | NOP | NOP | NOP | NOP }
{  NOP                        | NOP | NOP | NOP | NOP }
{  SW R2, R1, 4+              | NOP | NOP | NOP | NOP }
{  LBCB R10, READ_C0_M1_BANK  | NOP | NOP | NOP | NOP }
{  NOP                        | NOP | NOP | NOP | NOP }
{  NOP                        | NOP | NOP | NOP | NOP }
{  NOP                        | NOP | NOP | NOP | NOP }
{  NOP                        | NOP | NOP | NOP | NOP }
{  NOP                        | NOP | NOP | NOP | NOP }

;;====================================================
;;7. polling M1,M2 DMA status
;;====================================================
M1_DMA_STAT:
{ MOVIU R0,M1_DMA0_start_STAT | NOP | NOP | NOP | NOP }
{ LW R1,R0,0                  | NOP | NOP | NOP | NOP }
{ NOP                         | NOP | NOP | NOP | NOP }
{ NOP                         | NOP | NOP | NOP | NOP }
{ ANDI R1,R1,0xF              | NOP | NOP | NOP | NOP }
{ SEQIU R2,P1,P2,R1,0x0       | NOP | NOP | NOP | NOP }
{ (P2)B M1_DMA_STAT           | NOP | NOP | NOP | NOP }
{ NOP                         | NOP | NOP | NOP | NOP }
{ NOP                         | NOP | NOP | NOP | NOP }
{ NOP                         | NOP | NOP | NOP | NOP }
{ NOP                         | NOP | NOP | NOP | NOP }
{ NOP                         | NOP | NOP | NOP | NOP }

M2_DMA0_STAT:
{ MOVIU R0,M2_DMA0_start_STAT | NOP | NOP | NOP | NOP }
{ LW R1,R0,0                  | NOP | NOP | NOP | NOP }
{ NOP                         | NOP | NOP | NOP | NOP }
{ NOP                         | NOP | NOP | NOP | NOP }
{ ANDI R1,R1,0xF              | NOP | NOP | NOP | NOP }
{ SEQIU R2,P1,P2,R1,0x2       | NOP | NOP | NOP | NOP }
{ (P2)B M2_DMA0_STAT          | NOP | NOP | NOP | NOP }
{ NOP                         | NOP | NOP | NOP | NOP }
{ NOP                         | NOP | NOP | NOP | NOP }
{ NOP                         | NOP | NOP | NOP | NOP }
{ NOP                         | NOP | NOP | NOP | NOP }
{ NOP                         | NOP | NOP | NOP | NOP }

M2_DMA1_STAT:
{ MOVIU R0,M2_DMA0_start_STAT | NOP | NOP | NOP | NOP }
{ LW R1,R0,0                  | NOP | NOP | NOP | NOP }
{ NOP                         | NOP | NOP | NOP | NOP }
{ NOP                         | NOP | NOP | NOP | NOP }
{ ANDI R1,R1,0xF0000          | NOP | NOP | NOP | NOP }
{ SEQIU R2,P1,P2,R1,0x20000   | NOP | NOP | NOP | NOP }
{ (P2)B M2_DMA1_STAT          | NOP | NOP | NOP | NOP }
{ NOP                         | NOP | NOP | NOP | NOP }
{ NOP                         | NOP | NOP | NOP | NOP }
{ NOP                         | NOP | NOP | NOP | NOP }
{ NOP                         | NOP | NOP | NOP | NOP }
{ NOP                         | NOP | NOP | NOP | NOP }


  { NOP  | NOP | NOP | NOP | NOP }
  { NOP  | NOP | NOP | NOP | NOP }
  { TRAP | NOP | NOP | NOP | NOP }
  { NOP  | NOP | NOP | NOP | NOP }
  { NOP  | NOP | NOP | NOP | NOP }
  { NOP  | NOP | NOP | NOP | NOP }


