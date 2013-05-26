;;---------------------- To Verify ---------------------------
;;DMA Transfer : M2 DMA and SYSTEM DMA Access DDR Memory Concurrently
;; Core0 :
;;    - Initial M2 Data for DMA transfer test
;;    - Set System DMA to move data from DDR
;;    - Set M2 DMA to move data from M2 to DDR
;;------------------------------------------------------------

;;PACDSP CORE0 DMA SETTING
 PACDSP0_M1_DMA_SAR0 = 0x2405C070
 PACDSP0_M1_DMA_DAR0 = 0x2405C074
 PACDSP0_M1_DMA_SGR0 = 0x2405C078
 PACDSP0_M1_DMA_DSR0 = 0x2405C07C
 PACDSP0_M1_DMA_CTL0 = 0x2405C080
 PACDSP0_M1_DMA_ENA0 = 0x2405C084
 PACDSP0_M1_DMA_CLR0 = 0x2405C088
 
 PACDSP0_M1_DMA_STAT = 0x24058054
 
;;PACDSP CORE0 DMA SETTING DATA CH0
 PACDSP0_M1_DMA_DATA_SAR0 = 0x24000000   ;M1 Bank0
 PACDSP0_M1_DMA_DATA_DAR0 = 0x25002000   ;Core0 Memory Bank0
 PACDSP0_M1_DMA_DATA_SGR0 = 0x00000000   ;not used
 PACDSP0_M1_DMA_DATA_DSR0 = 0x00000000   ;not used
 PACDSP0_M1_DMA_DATA_CTL0 = 0x0080000E   ;BSZ[31:12], DSEN[9], SGEN[8], Int2Ext[3], Burst[2], TRZ[1:0], for 7056 DSP DMA
 PACDSP0_M1_DMA_DATA_ENA0 = 0x00000001   ;Enable DMA
 PACDSP0_M1_DMA_DATA_CLR0 = 0x00000001   ;CLR DMR INT

;;PACDSP CORE0 DMA SETTING
 PACDSP0_M1_DMA_SAR1 = 0x2405C0B0
 PACDSP0_M1_DMA_DAR1 = 0x2405C0B4
 PACDSP0_M1_DMA_SGR1 = 0x2405C0B8
 PACDSP0_M1_DMA_DSR1 = 0x2405C0BC
 PACDSP0_M1_DMA_CTL1 = 0x2405C0C0
 PACDSP0_M1_DMA_ENA1 = 0x2405C0C4
 PACDSP0_M1_DMA_CLR1 = 0x2405C0C8

;;PACDSP CORE0 DMA SETTING DATA CH1
 PACDSP0_M1_DMA_DATA_SAR1 = 0x24002000   ;M1 Bank1
 PACDSP0_M1_DMA_DATA_DAR1 = 0x30020000   ;DDR Memory
 PACDSP0_M1_DMA_DATA_SGR1 = 0x00000000   ;not used
 PACDSP0_M1_DMA_DATA_DSR1 = 0x00000000   ;not used
 PACDSP0_M1_DMA_DATA_CTL1 = 0x0080000E   ;BSZ[31:12], DSEN[9], SGEN[8], Int2Ext[3], Burst[2], TRZ[1:0], for 7056 DSP DMA
 PACDSP0_M1_DMA_DATA_ENA1 = 0x00000001   ;Enable DMA
 PACDSP0_M1_DMA_DATA_CLR1 = 0x00000001   ;CLR DMR INT

;;PACDSP CORE0 DMA SETTING
 PACDSP0_M1_DMA_SAR2 = 0x2405C0F0
 PACDSP0_M1_DMA_DAR2 = 0x2405C0F4
 PACDSP0_M1_DMA_SGR2 = 0x2405C0F8
 PACDSP0_M1_DMA_DSR2 = 0x2405C0FC
 PACDSP0_M1_DMA_CTL2 = 0x2405C100
 PACDSP0_M1_DMA_ENA2 = 0x2405C104
 PACDSP0_M1_DMA_CLR2 = 0x2405C108
 
 
;;PACDSP CORE0 DMA SETTING DATA CH0
 PACDSP0_M1_DMA_DATA_SAR2 = 0x24004000   ;M1 Bank2
 PACDSP0_M1_DMA_DATA_DAR2 = 0x24102000   ;Core1 Memory Bank1
 PACDSP0_M1_DMA_DATA_SGR2 = 0x00000000   ;not used
 PACDSP0_M1_DMA_DATA_DSR2 = 0x00000000   ;not used
 PACDSP0_M1_DMA_DATA_CTL2 = 0x0080000E   ;BSZ[31:12], DSEN[9], SGEN[8], Int2Ext[3], Burst[2], TRZ[1:0], for 7056 DSP DMA
 PACDSP0_M1_DMA_DATA_ENA2 = 0x00000001   ;Enable DMA
 PACDSP0_M1_DMA_DATA_CLR2 = 0x00000001   ;CLR DMR INT
 



;;PACDMP M2 DMA SETTING
 PACDMP_M2_DMA_SAR0 = 0x25820070
 PACDMP_M2_DMA_DAR0 = 0x25820074
 PACDMP_M2_DMA_SGR0 = 0x25820078
 PACDMP_M2_DMA_DSR0 = 0x2582007C
 PACDMP_M2_DMA_CTL0 = 0x25820080
 PACDMP_M2_DMA_ENA0 = 0x25820084
 PACDMP_M2_DMA_CLR0 = 0x25820088
 
 PACDMP_M2_DMA_STAT = 0x25820054
 
;;PACDMP M2 DMA SETTING DATA 
;; Move 2KB Data to DDR Memory
 PACDMP_M2_DMA_DATA_SAR0 = 0x25004000   ;M2 Bank1
 PACDMP_M2_DMA_DATA_DAR0 = 0x30050000   ;DDR Memory 
 PACDMP_M2_DMA_DATA_SGR0 = 0x00000000   ;not used
 PACDMP_M2_DMA_DATA_DSR0 = 0x00000000   ;not used
 PACDMP_M2_DMA_DATA_CTL0 = 0x0080000E   ;BSZ[31:12], DSEN[9], SGEN[8], Int2Ext[3], Burst[2], TRZ[1:0], for 7056 DSP DMA
 PACDMP_M2_DMA_DATA_ENA0 = 0x00000001   ;Enable DMA
 PACDMP_M2_DMA_DATA_CLR0 = 0x00000001   ;CLR DMR INT 

; Move 2K byte data to DDR 
;=== SYSTEM DMA Setting, DMEM -> DDR ===
  SYS_DMA_SAR_ADDR1 = 0x1C100090 ;
  SYS_DMA_DAR_ADDR1 = 0x1C100094 ;
  SYS_DMA_SGR_ADDR1 = 0x1C100098 ;
  SYS_DMA_DSR_ADDR1 = 0x1C10009C ;
  SYS_DMA_CTL_ADDR1 = 0x1C1000A0 ;
  SYS_DMA_ENA_ADDR1 = 0x1C1000A4 ;
  SYS_DMA_CLR_ADDR1 = 0x1C1000A8 ;
                             
  SYS_DMA_SAR_DATA1 = 0x30020000 ; set DDR as start address 
  SYS_DMA_DAR_DATA1 = 0x25006000 ; set DMEM as destination address 
  SYS_DMA_SGR_DATA1 = 0x00000000 ; not used
  SYS_DMA_DSR_DATA1 = 0x00000000 ; not used
  SYS_DMA_CTL_DATA1 = 0x00020003 ; DMA_CTL_DATA, BSZ[31:10] 0010 0000  0000 0000 0000 0011
  SYS_DMA_ENA_DATA1 = 0x00000001 ; active dma
  SYS_DMA_CLR_DATA1 = 0x00000000 ; not used
  
  SYS_DMA_STATUS_ADDR = 0x1C100300;

;======= Memory Base Address ========  
C0_M1_Memory_BaseAddr_Bank0     = 0x24000000
C0_M1_Memory_BaseAddr_Bank1     = 0x24002000
C0_M1_Memory_BaseAddr_Bank2     = 0x24004000

C1_M1_Memory_BaseAddr_Bank0     = 0x24100000
C1_M1_Memory_BaseAddr_Bank1     = 0x24102000

Share_M2_Memory_BaseAddr_Bank_0 = 0x25000000


  
;;Load / Store
;;Store 2KB Data in C0 M1 Memory
{ movi r0, 0x200              | movi a0, C0_M1_Memory_BaseAddr_Bank0 | movi d0, 0x11119999 | nop | nop }
Initial_Data_C0_M1:
{ lbcb r0, Initial_Data_C0_M1 | sw d0, a0, 4+                        | nop                 | nop | nop }
{ nop                         | nop                                  | nop                 | nop | nop } 
{ nop                         | nop                                  | nop                 | nop | nop } 
{ nop                         | nop                                  | nop                 | nop | nop } 
{ nop                         | nop                                  | nop                 | nop | nop } 
{ nop                         | nop                                  | nop                 | nop | nop } 
{ nop                         | nop                                  | nop                 | nop | nop } 

;;Store 2KB Data in C1 M1 Memory
{ movi r0, 0x200              | movi a0, C1_M1_Memory_BaseAddr_Bank0 | movi d0, 0x22447766 | nop | nop }
Initial_Data_C1_M1:
{ lbcb r0, Initial_Data_C1_M1 | sw d0, a0, 4+                        | nop                 | nop | nop }
{ nop                         | nop                                  | nop                 | nop | nop } 
{ nop                         | nop                                  | nop                 | nop | nop } 
{ nop                         | nop                                  | nop                 | nop | nop } 
{ nop                         | nop                                  | nop                 | nop | nop } 
{ nop                         | nop                                  | nop                 | nop | nop } 
{ nop                         | nop                                  | nop                 | nop | nop } 

;;Store 2KB Data in C0 M1 Memory
{ movi r0, 0x200                 | movi a0, C0_M1_Memory_BaseAddr_Bank1 | movi d0, 0x22228888 | nop | nop }
Initial_Data_C0_M1_B1:
{ lbcb r0, Initial_Data_C0_M1_B1 | sw d0, a0, 4+                        | nop                 | nop | nop }
{ nop                            | nop                                  | nop                 | nop | nop } 
{ nop                            | nop                                  | nop                 | nop | nop } 
{ nop                            | nop                                  | nop                 | nop | nop } 
{ nop                            | nop                                  | nop                 | nop | nop } 
{ nop                            | nop                                  | nop                 | nop | nop } 
{ nop                            | nop                                  | nop                 | nop | nop } 

;;Store 2KB Data in C0 M1 Memory
{ movi r0, 0x200                 | movi a0, C0_M1_Memory_BaseAddr_Bank2 | movi d0, 0x77775555 | nop | nop }
Initial_Data_C0_M1_B2:
{ lbcb r0, Initial_Data_C0_M1_B2 | sw d0, a0, 4+                        | nop                 | nop | nop }
{ nop                            | nop                                  | nop                 | nop | nop } 
{ nop                            | nop                                  | nop                 | nop | nop } 
{ nop                            | nop                                  | nop                 | nop | nop } 
{ nop                            | nop                                  | nop                 | nop | nop } 
{ nop                            | nop                                  | nop                 | nop | nop } 
{ nop                            | nop                                  | nop                 | nop | nop } 


;;DMA Transfer
;;================================================================================================================
;;Move 2KB data in M1 Memory to M2 Memory

M1_DMA_CH0_Check: 
{ movi r0, PACDSP0_M1_DMA_STAT | nop | nop | nop | nop }
{ lw r1, r0, 0x0              | nop | nop | nop | nop }
{ nop                         | nop | nop | nop | nop } 
{ nop                         | nop | nop | nop | nop }
{ andi r2, r1, 0x00000001     | nop | nop | nop | nop }
{ seqi r15, p1, p2, r2, 0x1   | nop | nop | nop | nop } 
{ (p1)b M1_DMA_CH0_Check      | nop | nop | nop | nop }
{ nop                         | nop | nop | nop | nop } 
{ nop                         | nop | nop | nop | nop }
{ nop                         | nop | nop | nop | nop } 
{ nop                         | nop | nop | nop | nop }
{ nop                         | nop | nop | nop | nop } 

;;DMA TRANSFER TEST
;;DMA CORE0 M1 SETTING
{ nop | movi a0, PACDSP0_M1_DMA_SAR0 | movi d0, PACDSP0_M1_DMA_DATA_SAR0 | nop | nop }
{ nop | movi a1, PACDSP0_M1_DMA_DAR0 | movi d1, PACDSP0_M1_DMA_DATA_DAR0 | nop | nop }
{ nop | movi a2, PACDSP0_M1_DMA_SGR0 | clr d2                            | nop | nop }
{ nop | movi a3, PACDSP0_M1_DMA_DSR0 | nop                               | nop | nop }
{ nop | movi a4, PACDSP0_M1_DMA_CTL0 | movi d3, PACDSP0_M1_DMA_DATA_CTL0 | nop | nop }
{ nop | movi a5, PACDSP0_M1_DMA_CLR0 | movi d4, PACDSP0_M1_DMA_DATA_CLR0 | nop | nop }
{ nop | sw d0, a0, 0x0               | movi d5, PACDSP0_M1_DMA_DATA_ENA0 | nop | nop }
{ nop | sw d1, a1, 0x0               | nop                               | nop | nop }
{ nop | sw d2, a2, 0x0               | nop                               | nop | nop }
{ nop | sw d2, a3, 0x0               | nop                               | nop | nop }
{ nop | sw d3, a4, 0x0               | nop                               | nop | nop }
{ nop | sw d4, a5, 0x0               | nop                               | nop | nop }
{ nop | nop                          | nop                               | nop | nop }
{ nop | nop                          | nop                               | nop | nop }

;;ENABLE DMA

{ nop | movi a0, PACDSP0_M1_DMA_ENA0  | nop                               | nop | nop }
{ nop | sw d5, a0, 0x0               | nop                               | nop | nop }
{ nop | nop                          | nop                               | nop | nop }
{ nop | nop                          | nop                               | nop | nop }

M1_DMA_CH0_Check_Complete: 
{ movi r0, PACDSP0_M1_DMA_STAT      | nop | nop | nop | nop }
{ lw r1, r0, 0x0                    | nop | nop | nop | nop }
{ nop                               | nop | nop | nop | nop } 
{ nop                               | nop | nop | nop | nop }
{ andi r2, r1, 0x00000001           | nop | nop | nop | nop }
{ seqi r15, p1, p2, r2, 0x1         | nop | nop | nop | nop } 
{ (p1)b M1_DMA_CH0_Check_Complete   | nop | nop | nop | nop }
{ nop                               | nop | nop | nop | nop } 
{ nop                               | nop | nop | nop | nop }
{ nop                               | nop | nop | nop | nop } 
{ nop                               | nop | nop | nop | nop }
{ nop                               | nop | nop | nop | nop } 

;===========================================================================================================

;;================================================================================================================
;;Move 2KB data in M1 Memory to DDR Memory

M1_DMA_CH1_Check: 
{ movi r0, PACDSP0_M1_DMA_STAT | nop | nop | nop | nop }
{ lw r1, r0, 0x0               | nop | nop | nop | nop }
{ nop                          | nop | nop | nop | nop } 
{ nop                          | nop | nop | nop | nop }
{ andi r2, r1, 0x00000010      | nop | nop | nop | nop }
{ seqi r15, p1, p2, r2, 0x10   | nop | nop | nop | nop } 
{ (p1)b M1_DMA_CH1_Check       | nop | nop | nop | nop }
{ nop                          | nop | nop | nop | nop } 
{ nop                          | nop | nop | nop | nop }
{ nop                          | nop | nop | nop | nop } 
{ nop                          | nop | nop | nop | nop }
{ nop                          | nop | nop | nop | nop } 

;;DMA TRANSFER TEST
;;DMA CORE0 M1 SETTING
{ nop | movi a0, PACDSP0_M1_DMA_SAR1 | movi d0, PACDSP0_M1_DMA_DATA_SAR1 | nop | nop }
{ nop | movi a1, PACDSP0_M1_DMA_DAR1 | movi d1, PACDSP0_M1_DMA_DATA_DAR1 | nop | nop }
{ nop | movi a2, PACDSP0_M1_DMA_SGR1 | clr d2                           | nop | nop }
{ nop | movi a3, PACDSP0_M1_DMA_DSR1 | nop                              | nop | nop }
{ nop | movi a4, PACDSP0_M1_DMA_CTL1 | movi d3, PACDSP0_M1_DMA_DATA_CTL1 | nop | nop }
{ nop | movi a5, PACDSP0_M1_DMA_CLR1 | movi d4, PACDSP0_M1_DMA_DATA_CLR1 | nop | nop }
{ nop | sw d0, a0, 0x0               | movi d5, PACDSP0_M1_DMA_DATA_ENA1 | nop | nop }
{ nop | sw d1, a1, 0x0               | nop                              | nop | nop }
{ nop | sw d2, a2, 0x0               | nop                              | nop | nop }
{ nop | sw d2, a3, 0x0               | nop                              | nop | nop }
{ nop | sw d3, a4, 0x0               | nop                              | nop | nop }
{ nop | sw d4, a5, 0x0               | nop                              | nop | nop }
{ nop | nop                          | nop                              | nop | nop }
{ nop | nop                          | nop                              | nop | nop }

;;ENABLE DMA

{ nop | movi a0, PACDSP0_M1_DMA_ENA1 | nop                              | nop | nop }
{ nop | sw d5, a0, 0x0              | nop                              | nop | nop }
{ nop | nop                         | nop                              | nop | nop }
{ nop | nop                         | nop                              | nop | nop }

M1_DMA_CH1_Check_Complete: 
{ movi r0, PACDSP0_M1_DMA_STAT     | nop | nop | nop | nop }
{ lw r1, r0, 0x0                   | nop | nop | nop | nop }
{ nop                              | nop | nop | nop | nop } 
{ nop                              | nop | nop | nop | nop }
{ andi r2, r1, 0x00000010          | nop | nop | nop | nop }
{ seqi r15, p1, p2, r2, 0x10       | nop | nop | nop | nop } 
{ (p1)b M1_DMA_CH1_Check_Complete  | nop | nop | nop | nop }
{ nop                              | nop | nop | nop | nop } 
{ nop                              | nop | nop | nop | nop }
{ nop                              | nop | nop | nop | nop } 
{ nop                              | nop | nop | nop | nop }
{ nop                              | nop | nop | nop | nop } 

;===========================================================================================================


;;================================================================================================================
;;Move 2KB data in Core0 M1 Memory to Core1 Memory

M1_DMA_CH2_Check: 
{ movi r0, PACDSP0_M1_DMA_STAT   | nop | nop | nop | nop }
{ lw r1, r0, 0x0                 | nop | nop | nop | nop }
{ nop                            | nop | nop | nop | nop } 
{ nop                            | nop | nop | nop | nop }
{ andi r2, r1, 0x00000100        | nop | nop | nop | nop }
{ seqi r15, p1, p2, r2, 0x100    | nop | nop | nop | nop } 
{ (p1)b M1_DMA_CH2_Check         | nop | nop | nop | nop }
{ nop                            | nop | nop | nop | nop } 
{ nop                            | nop | nop | nop | nop }
{ nop                            | nop | nop | nop | nop } 
{ nop                            | nop | nop | nop | nop }
{ nop                            | nop | nop | nop | nop } 

;;DMA TRANSFER TEST
;;DMA CORE0 M1 SETTING
{ nop | movi a0, PACDSP0_M1_DMA_SAR2 | movi d0, PACDSP0_M1_DMA_DATA_SAR2 | nop | nop }
{ nop | movi a1, PACDSP0_M1_DMA_DAR2 | movi d1, PACDSP0_M1_DMA_DATA_DAR2 | nop | nop }
{ nop | movi a2, PACDSP0_M1_DMA_SGR2 | clr d2                            | nop | nop }
{ nop | movi a3, PACDSP0_M1_DMA_DSR2 | nop                               | nop | nop }
{ nop | movi a4, PACDSP0_M1_DMA_CTL2 | movi d3, PACDSP0_M1_DMA_DATA_CTL2 | nop | nop }
{ nop | movi a5, PACDSP0_M1_DMA_CLR2 | movi d4, PACDSP0_M1_DMA_DATA_CLR2 | nop | nop }
{ nop | sw d0, a0, 0x0               | movi d5, PACDSP0_M1_DMA_DATA_ENA2 | nop | nop }
{ nop | sw d1, a1, 0x0               | nop                               | nop | nop }
{ nop | sw d2, a2, 0x0               | nop                               | nop | nop }
{ nop | sw d2, a3, 0x0               | nop                               | nop | nop }
{ nop | sw d3, a4, 0x0               | nop                               | nop | nop }
{ nop | sw d4, a5, 0x0               | nop                               | nop | nop }
{ nop | nop                          | nop                               | nop | nop }
{ nop | nop                          | nop                               | nop | nop }

;;ENABLE DMA

{ nop | movi a0, PACDSP0_M1_DMA_ENA2 | nop                              | nop | nop }
{ nop | sw d5, a0, 0x0              | nop                              | nop | nop }
{ nop | nop                         | nop                              | nop | nop }
{ nop | nop                         | nop                              | nop | nop }

M1_DMA_CH2_Check_Complete: 
{ movi r0, PACDSP0_M1_DMA_STAT      | nop | nop | nop | nop }
{ lw r1, r0, 0x0                   | nop | nop | nop | nop }
{ nop                              | nop | nop | nop | nop } 
{ nop                              | nop | nop | nop | nop }
{ andi r2, r1, 0x00000100          | nop | nop | nop | nop }
{ seqi r15, p1, p2, r2, 0x100      | nop | nop | nop | nop } 
{ (p1)b M1_DMA_CH2_Check_Complete  | nop | nop | nop | nop }
{ nop                              | nop | nop | nop | nop } 
{ nop                              | nop | nop | nop | nop }
{ nop                              | nop | nop | nop | nop } 
{ nop                              | nop | nop | nop | nop }
{ nop                              | nop | nop | nop | nop } 

;===========================================================================================================

{ TRAP                              | nop | nop | nop | nop } 
