;; DDR config data for DQS probing
;.include "./ddr_config_data.s"

; 128 Mbits
; DDR Setting
; ================================================
DSP_DMA_BaseAddr  =  0x25820000                          ;       64  ;   M2 DMA Base Address (BIU Base Address)

;********************** DMA Register Layout *************************											
;DMA Register Offset											

DSP_DMA_SR_offset	=	0x54 								;			;	DSP DMA Status Register	(0x09820054)	

DMA_SAR0_offset   = 0x70
DMA_DAR0_offset   = 0x74
DMA_SGR0_offset   = 0x78
DMA_DSR0_offset   = 0x7C
DMA_CTL0_offset   = 0x80
DMA_EN0_offset    = 0x84
DMA_CLR0_offset   = 0x88
DMA_LLST0_offset  = 0x8C
DMA_PDCTL0_offset = 0x90
DMA_SHAPE0_offset = 0x94
DMA_RES0_offset   = 0x98

						     										
DMA_SAR1_offset   = 0xB0
DMA_DAR1_offset   = 0xB4
DMA_SGR1_offset   = 0xB8
DMA_DSR1_offset   = 0xBC
DMA_CTL1_offset   = 0xC0
DMA_EN1_offset    = 0xC4
DMA_CLR1_offset   = 0xC8
DMA_LLST1_offset  = 0xCC
DMA_PDCTL1_offset = 0xD0
DMA_SHAPE1_offset = 0xD4
DMA_RES1_offset   = 0xD8
						     										
DMA_SAR2_offset   = 0xF0
DMA_DAR2_offset   = 0xF4
DMA_SGR2_offset   = 0xF8
DMA_DSR2_offset   = 0xFC
DMA_CTL2_offset   = 0x100
DMA_EN2_offset    = 0x104
DMA_CLR2_offset   = 0x108
DMA_LLST2_offset  = 0x10C
DMA_PDCTL2_offset = 0x110
DMA_SHAPE2_offset = 0x114
DMA_RES2_offset   = 0x118
						     										

DMA_SAR3_offset   = 0x130
DMA_DAR3_offset   = 0x134
DMA_SGR3_offset   = 0x138
DMA_DSR3_offset   = 0x13C
DMA_CTL3_offset   = 0x140
DMA_EN3_offset    = 0x144
DMA_CLR3_offset   = 0x148
DMA_LLST3_offset  = 0x14C
DMA_PDCTL3_offset = 0x150
DMA_SHAPE3_offset = 0x154
DMA_RES3_offset   = 0x158

DMA_SAR4_offset   = 0x170
DMA_DAR4_offset   = 0x174
DMA_SGR4_offset   = 0x178
DMA_DSR4_offset   = 0x17C
DMA_CTL4_offset   = 0x180
DMA_EN4_offset    = 0x184
DMA_CLR4_offset   = 0x188
DMA_LLST4_offset  = 0x18C
DMA_PDCTL4_offset = 0x190
DMA_SHAPE4_offset = 0x194
DMA_RES4_offset   = 0x198
				    					                    
DMA_SAR5_offset   = 0x1B0
DMA_DAR5_offset   = 0x1B4
DMA_SGR5_offset   = 0x1B8
DMA_DSR5_offset   = 0x1BC
DMA_CTL5_offset   = 0x1C0
DMA_EN5_offset    = 0x1C4
DMA_CLR5_offset   = 0x1C8
DMA_LLST5_offset  = 0x1CC
DMA_PDCTL5_offset = 0x1D0
DMA_SHAPE5_offset = 0x1D4
DMA_RES5_offset   = 0x1D8
				    					                    
DMA_SAR6_offset   = 0x1F0
DMA_DAR6_offset   = 0x1F4
DMA_SGR6_offset   = 0x1F8
DMA_DSR6_offset   = 0x1FC
DMA_CTL6_offset   = 0x200
DMA_EN6_offset    = 0x204
DMA_CLR6_offset   = 0x208
DMA_LLST6_offset  = 0x20C
DMA_PDCTL6_offset = 0x210
DMA_SHAPE6_offset = 0x214
DMA_RES6_offset   = 0x218
				    					                    
DMA_SAR7_offset   = 0x230
DMA_DAR7_offset   = 0x234
DMA_SGR7_offset   = 0x238
DMA_DSR7_offset   = 0x23C
DMA_CTL7_offset   = 0x240
DMA_EN7_offset    = 0x244
DMA_CLR7_offset   = 0x248
DMA_LLST7_offset  = 0x24C
DMA_PDCTL7_offset = 0x250
DMA_SHAPE7_offset = 0x254
DMA_RES7_offset   = 0x258
									                       

			
;DSP DMA Register Layout											
DSP_DMA_SAR0		=	DSP_DMA_BaseAddr       	+	0x00	;		32	;			
DSP_DMA_DAR0		=	DSP_DMA_BaseAddr       	+	0x04	;		32	;			
DSP_DMA_SGR0		=	DSP_DMA_BaseAddr       	+	0x08	;		32	;			
DSP_DMA_DSR0		=	DSP_DMA_BaseAddr       	+	0x0C	;		32	;			
DSP_DMA_CTL0		=	DSP_DMA_BaseAddr       	+	0x10	;		32	;			
DSP_DMA_EN0			=	DSP_DMA_BaseAddr       	+	0x14	;		32	;			
DSP_DMA_CLR0		=	DSP_DMA_BaseAddr       	+	0x18	;		32	;	
DSP_DMA_PAD0	  =	DSP_DMA_BaseAddr       	+	0x1C	;		32	;	
;EVB DMA Register Layout											
EVB_DMA_SAR0		=	EVB_DMA_BaseAddr       	+	0x00	;		32	;			
EVB_DMA_DAR0		=	EVB_DMA_BaseAddr       	+	0x04	;		32	;			
EVB_DMA_SGR0		=	EVB_DMA_BaseAddr       	+	0x08	;		32	;			
EVB_DMA_DSR0		=	EVB_DMA_BaseAddr       	+	0x0C	;		32	;			
EVB_DMA_CTL0		=	EVB_DMA_BaseAddr       	+	0x10	;		32	;			
EVB_DMA_EN0			=	EVB_DMA_BaseAddr       	+	0x14	;		32	;			
EVB_DMA_CLR0		=	EVB_DMA_BaseAddr       	+	0x18	;		32	;			
EVB_DMA_PAD0	  =	EVB_DMA_BaseAddr       	+	0x1C	;		32	;	
;********************* DMA Register Layout End ***********************				


DDRCTRL_BASE      =0x16020000 
MISC_IF_BASE_ADDR =0x16030000

.text

;;; ======================
;;; === config misc_if ===
;;; ======================

  {  MOVIU R0, MISC_IF_BASE_ADDR	|  NOP		|  NOP  |  NOP  |  NOP  }
	
  ;=== 0. DQS delay =====================
  {  MOVIU R1, 0x108a108a	|  NOP		|  NOP  |  NOP  |  NOP  }
  {  SW R1, R0, 0x20		  |  NOP		|  NOP  |  NOP  |  NOP  }
  
  ;=== 1. unknow =====================
  {  MOVIU R1, 0x00000100	|  NOP		|  NOP  |  NOP  |  NOP  }
  {  SW R1, R0, 0x08		  |  NOP		|  NOP  |  NOP  |  NOP  }
  
  ;=== 2. DDR 32-bit sync mode =====================
  {  MOVIU R1, 0x89000000	|  NOP		|  NOP  |  NOP  |  NOP  }
  {  SW R1, R0, 0x00 		  |  NOP		|  NOP  |  NOP  |  NOP  }
  
  ;=== 3. mem_type config in misc_if =====================
  {  MOVIU R1, 0x1	|  NOP		|  NOP  |  NOP  |  NOP  }
  {  SW R1, R0, 0x14		  |  NOP		|  NOP  |  NOP  |  NOP  }
  
  
  {  MOVIU R0, DDRCTRL_BASE	|  NOP		|  NOP  |  NOP  |  NOP  }
	
  ;===0-a.Set Control Mode (16-bits/32-bits, sync/async option) =====================
  ;{  MOVIU R1, 0x00890000	|  NOP		|  NOP  |  NOP  |  NOP  }
  ;{  SW R1, R0, 0x1000		|  NOP		|  NOP  |  NOP  |  NOP  }

  ;===0-c.Change memory controller state to "Pause" =================================
  { MOVIU r1, 0x3   | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x4  | NOP | NOP | NOP | NOP }

  ;===0-d.Change memory controller state to "Config" ================================
  { MOVIU r1, 0x4   | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x4  | NOP | NOP | NOP | NOP }

  ;===0-e.Set memory_cfg2 register, 32-bit sync mode DDR  =================================================
  { MOVIU r1, 0x251 | NOP | NOP | NOP | NOP } 
  { SW r1, r0, 0x4C | NOP | NOP | NOP | NOP }

  ;===1.Set refresh period register(refresh_prd) to 1600 clock cycles ===============
  { MOVIU r1, 0x640 | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x10 | NOP | NOP | NOP | NOP }

  ;===2.Set CAS latency register(cas_latency) to 2.5 clock cycles =====================
  ;{ MOVIU r1, 0x4   | NOP | NOP | NOP | NOP } ; CL = 2
  { MOVIU r1, 0x5   | NOP | NOP | NOP | NOP }; CL = 2.5
  ;{ MOVIU r1, 0x6   | NOP | NOP | NOP | NOP } ; CL = 3
  { SW r1, r0, 0x14 | NOP | NOP | NOP | NOP }

  ;===3.Set t_dqss register to 1 clock cycle ========================================
  { MOVIU r1, 0x1   | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x18 | NOP | NOP | NOP | NOP }

  ;===4.Set t_mrd register(mode register command time) to 2 clock cycles ============
  { MOVIU r1, 0x2   | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x1C | NOP | NOP | NOP | NOP }

  ;===5.Set t_ras register(RAS to precharge delay) to 7 clock cycles ================
  { MOVIU r1, 0x7   | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x20 | NOP | NOP | NOP | NOP }

  ;===6.Set t_rc register to (active bank x to active bank x delay) 11 clock cycles =
  { MOVIU r1, 0xB   | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x24 | NOP | NOP | NOP | NOP }

  ;===7.Set t_rcd register(RAS to CAS delay) to 5 clock cycles ======================
  { MOVIU r1, 0x15  | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x28 | NOP | NOP | NOP | NOP }

  ;===8.Set t_rfc register(auto-refresh command period) to 18 clock cycles ==========
  { MOVIU r1, 0x1F2 | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x2C | NOP | NOP | NOP | NOP }

  ;===9.Set t_rp Register(precharge to RAS delay) to 5 clock cycles =================
  { MOVIU r1, 0x15  | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x30 | NOP | NOP | NOP | NOP }

  ;===10.Set t_rrd Register(active bank x to active bank y delay) to 2 clock cycles =
  { MOVIU r1, 0x3   | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x34 | NOP | NOP | NOP | NOP }

  ;===11.Set t_wr Register (write to precharge delay) to 3 clock cycles =============
  { MOVIU r1, 0x3   | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x38 | NOP | NOP | NOP | NOP }

  ;===12.Set t_wtr Register (write to read delay) to 2 clock cycles =================
  { MOVIU r1, 0x2   | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x3C | NOP | NOP | NOP | NOP }

  ;===13.Set t_xp Register (exit power-down command time) to 1 clock cycles =========
  { MOVIU r1, 0x1   | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x40 | NOP | NOP | NOP | NOP }

  ;===14.Set t_xsr Register (exit self-refresh command time) to 10 clock cycles =====
  { MOVIU r1, 0xa   | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x44 | NOP | NOP | NOP | NOP }

  ;===15.Set t_esr Register (self-refresh command time) to 20 clock cycles ==========
  { MOVIU r1, 0x14   | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x48  | NOP | NOP | NOP | NOP }

  ;===16. Set memory_cfg Register  =====================================
  ;; Burst length 4, row=13, col=10 --> 0x00010012,
  ;; Burst length 8, row=13, col=10 --> 0x00018012,
  
  { MOVIU r1, 0x00018012   | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x0C  | NOP | NOP | NOP | NOP }

  ;===17. Set chip_cfg Registe to 0x0  ==============================================
  { MOVIU r1, 0x0     | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x200  | NOP | NOP | NOP | NOP }

  ;===18. Set Direct Command Register to 0x000C0000 (command NOP with bringing CKE high) ==================
  { MOVIU r1, 0x000C0000   | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x08        | NOP | NOP | NOP | NOP }

;;; nop for 200us
  { MOVIU r8, 0x3fc		     | NOP | NOP | NOP | NOP }
NOP_CMD_LOOP:
  ;===18. Set Direct Command Register to 0x000C0000 (command NOP with bringing CKE high) ==================
  { MOVIU r1, 0x000C0000   | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x08        | NOP | NOP | NOP | NOP } 
  { LBCB r8, NOP_CMD_LOOP	 | NOP | NOP | NOP | NOP }
  { NOP				             | NOP | NOP | NOP | NOP }
  { NOP				             | NOP | NOP | NOP | NOP }
  { NOP				             | NOP | NOP | NOP | NOP }
  { NOP				             | NOP | NOP | NOP | NOP }
  { NOP				             | NOP | NOP | NOP | NOP }

  ;===19. Set Direct Command Register to 0x00000000 (command Prechargeall) ================================
  { MOVIU r1, 0x00000000   | NOP | NOP | NOP | NOP } 
  { SW r1, r0, 0x08  | NOP | NOP | NOP | NOP }

  ;===20. Set Direct Command Register to 0x000C0000 (command NOP) for tRP(at least 20ns) time =============
  { MOVIU r1, 0x000C0000   | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x08  | NOP | NOP | NOP | NOP }
  { NOP		     | NOP | NOP | NOP | NOP }
  { NOP		     | NOP | NOP | NOP | NOP }
  { NOP		     | NOP | NOP | NOP | NOP }
  { NOP		     | NOP | NOP | NOP | NOP }
  { NOP		     | NOP | NOP | NOP | NOP }
  { NOP		     | NOP | NOP | NOP | NOP }

  ;=== 21. Set Direct Command Register to 0x00090000 (command LEMR) =======================================
  { MOVIU r1, 0x90000   | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x08  | NOP | NOP | NOP | NOP }

  ;=== 22. Set Direct Command Register to 0x000C0000 (command NOP) for tMRD(at least 15ns) time ===========
  { MOVIU r1, 0x000C0000   | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x08  | NOP | NOP | NOP | NOP }
  { NOP		     | NOP | NOP | NOP | NOP }
  { NOP		     | NOP | NOP | NOP | NOP }
  { NOP		     | NOP | NOP | NOP | NOP }
  { NOP		     | NOP | NOP | NOP | NOP }
  { NOP		     | NOP | NOP | NOP | NOP }
  { NOP		     | NOP | NOP | NOP | NOP }

  ;=== 23. Set Direct Command Register to 0x000080131 (command LMR, reset DLL) ============================
  ;; CL 2.5 with :
  ;; Burst length 2 --> 0x00080161,
  ;; Burst length 4 --> 0x00080162,
  ;; Burst length 8 --> 0x00080163,
  { MOVIU r1, 0x00080163   | NOP | NOP | NOP | NOP } ;CL = 2.5
  ;{ MOVIU r1, 0x00080131   | NOP | NOP | NOP | NOP } ;CL = 3
  { SW r1, r0, 0x08  | NOP | NOP | NOP | NOP }

  ;====24. Set Direct Command Register to 0x000C0000 (command NOP) for tMRD(at least 15ns) time ===========
  { MOVIU r1, 0x000C0000   | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x08  | NOP | NOP | NOP | NOP }
  { NOP		     | NOP | NOP | NOP | NOP }
  { NOP		     | NOP | NOP | NOP | NOP }
  { NOP		     | NOP | NOP | NOP | NOP }
  { NOP		     | NOP | NOP | NOP | NOP }
  { NOP		     | NOP | NOP | NOP | NOP }
  { NOP		     | NOP | NOP | NOP | NOP }

  ;=== 25. Set Direct Command Register to 0x00000000 (command Prechargeall) ===============================
  { MOVIU r1, 0x0   | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x08  | NOP | NOP | NOP | NOP }

  ;=== 26. Set Direct Command Register to 0x000C0000 (command NOP) for tRP(at least 20ns) time ============
  { MOVIU r1, 0x000C0000   | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x08  | NOP | NOP | NOP | NOP }
  { NOP		     | NOP | NOP | NOP | NOP }
  { NOP		     | NOP | NOP | NOP | NOP }
  { NOP		     | NOP | NOP | NOP | NOP }
  { NOP		     | NOP | NOP | NOP | NOP }
  { NOP		     | NOP | NOP | NOP | NOP }
  { NOP		     | NOP | NOP | NOP | NOP }

  ;=== 27. Set Direct Command Register to 0x00040000 (command auto-refresh) ===============================
  { MOVIU r1, 0x00040000   | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x08  | NOP | NOP | NOP | NOP }

  ;=== 28. Set Direct Command Register to 0x000C0000 (command NOP) for tREFC time ======
  { MOVIU r1, 0x000C0000   | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x08  | NOP | NOP | NOP | NOP }

	
  ;=== 29. Set Direct Command Register to 0x00040000 (command auto-refresh) ===============================
  { MOVIU r1, 0x00040000   | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x08  | NOP | NOP | NOP | NOP }

  ;=== 30. Set Direct Command Register to 0x000C0000 (command NOP) for tRFC(at least 120ns) time ==========
  { MOVIU r1, 0x000C0000   | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x08  | NOP | NOP | NOP | NOP }
  { MOVIU r8, 0x70		| NOP | NOP | NOP | NOP }
STEP30_LOOP:
 
  { LBCB r8, STEP30_LOOP	| NOP | NOP | NOP | NOP }
  { NOP				| NOP | NOP | NOP | NOP }
  { NOP				| NOP | NOP | NOP | NOP }
  { NOP				| NOP | NOP | NOP | NOP }
  { NOP				| NOP | NOP | NOP | NOP }
  { NOP				| NOP | NOP | NOP | NOP }

  ;=== 31. Set Direct Command Register to 0x000080021 (command LMR, clear reset DLL bit) ==================
  ;; CL 2.5 with:
  ;; Burst length 2 --> 0x00080061,
  ;; Burst length 4 --> 0x00080062,
  ;; Burst length 8 --> 0x00080063,
  { MOVIU r1, 0x00080063   | NOP | NOP | NOP | NOP } ;CL = 2.5
  ;{ MOVIU r1, 0x00080031   | NOP | NOP | NOP | NOP } ;CL = 3
  { SW r1, r0, 0x08  | NOP | NOP | NOP | NOP }

  ;=== 32. Set Direct Command Register to 0x000C0000 (command NOP) for tMRD (at least 15ns) time ==========
  { MOVIU r1, 0x000C0000   | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x08  | NOP | NOP | NOP | NOP }
  { NOP				| NOP | NOP | NOP | NOP }
  { NOP				| NOP | NOP | NOP | NOP }
  { NOP				| NOP | NOP | NOP | NOP }
  { NOP				| NOP | NOP | NOP | NOP }
  { NOP				| NOP | NOP | NOP | NOP }
  { NOP				| NOP | NOP | NOP | NOP }

  ;=== 33. Set Memory Controller Command Register  to 0x00000000 (Change PL340_DMC state to “Go”) =======
  { MOVIU r1, 0x00000000   | NOP | NOP | NOP | NOP }
  { SW r1, r0, 0x04  | NOP | NOP | NOP | NOP } 
   
  {  B R4, AUTO_DQS | NOP | NOP | NOP | NOP }
  {  NOP			|  NOP		|  NOP  |  NOP  |  NOP  }
  {  NOP			|  NOP		|  NOP  |  NOP  |  NOP  }
  {  NOP			|  NOP		|  NOP  |  NOP  |  NOP  }
  {  NOP			|  NOP		|  NOP  |  NOP  |  NOP  }
  {  NOP			|  NOP		|  NOP  |  NOP  |  NOP  }

  
  {  TRAP			|  NOP		|  NOP  |  NOP  |  NOP  }

.set DDR_BASE_ADDR_S,  0x30025000
.set DDR_BASE_ADDR_C1, 0x30035000
.set DDR_BASE_ADDR_C2, 0x30045000

;A2及A3用來記錄可以write/read成功的起始點跟終點, 初始值為0x0跟0xf
AUTO_DQS:

{ MOVIU R0, DDR_BASE_ADDR_S   | MOVI A6, DDR_BASE_ADDR_C1 | NOP | MOVI A0, 0x0 | MOVI D7, 0x0 }                 ;D7: max count, A0:Check Count
{ MOVIU R1, MISC_IF_BASE_ADDR | MOVI A1, 0x2500F000 | NOP | MOVI A6, DDR_BASE_ADDR_C2 | MOVI D6, 0x0 }          ;D6: same count

{ MOVI R10, 0x0           | MOVI A2, 0x0 | NOP | NOP | NOP }  ;dqs start point
{ MOVI R11, 0x10          | MOVI A3, 0x0 | NOP | NOP | NOP }  ;dqs end point
{ NOP                     | MOVI A0, 0x0 | NOP | NOP | NOP }  ;dqs_en delay value initial 0x0 

dqsen_loop:
{ LW R6, R1, 0x20        | NOP | NOP | MOVI A0, 0x0 | NOP }              ;write "dqs_en" delay value(A0) to reg_phy 
{ MOVI SR0, 0x0           | SLLI D0, A0, 0x9 | NOP | NOP | NOP } ;load reg_phy  to R6
{ NOP                     | SLLI D0, D0, 0x10 | NOP | NOP | NOP }
{ NOP                     | SLLI D1, A0, 0x9 | NOP | NOP | NOP }
{ NOP                     | ADD D0, D0, D1 | NOP | NOP | NOP }  
{ BDR R7                  | BDT D0         | NOP | NOP | NOP }   ;R7:dqs_en
{ NOP                     | NOP            | NOP | NOP | NOP }
{ NOP                     | NOP            | NOP | NOP | NOP }
{ NOP                     | NOP            | NOP | NOP | NOP }
{ NOP                     | NOP            | NOP | NOP | NOP }    ;write reg_phy for "dqs_en delay" back 
{ NOP                     | NOP            | NOP | NOP | NOP }
{ NOP                     | NOP            | NOP | NOP | NOP }

;write "dqs" delay to reg_phy
{ LW R6, r1, 0x20         | NOP            | NOP | NOP | NOP }    ;load reg_phy  to R6
{ NOP                     | MOVI D12, 0x0  | NOP | MOVI D12, 0x0 | NOP }
{ NOP                     | NOP            | NOP | NOP | NOP }
;{ ANDI R6, R6, 0xE01FE01F | NOP            | NOP | NOP | NOP }    ;clear bit[8:5] and bit[24:21] (dqs delay),
{ ANDI R6, R6, 0x000F000F | NOP            | NOP | NOP | NOP }     ;clear bit[8:5] and bit[24:21] (dqs delay),
{ MOVI R15, 0x0           | NOP            | NOP | NOP | NOP }    ;set initial dqs delay bit[8:5] and bit[24:21] as 0x0
test_loop: ;run loop for dqs delay(r15) from 0x0 to 0xf 
{ SLLI R14, R15, 0x5      | NOP            | NOP | NOP | NOP }
{ SLLI R14, R14, 0x10     | NOP            | NOP | NOP | NOP }
{ SLLI R13, R15, 0x5      | NOP            | NOP | NOP | NOP }
{ ADD  R12, R14, R13      | NOP            | NOP | NOP | NOP }
{ ADD  R8, R7, R12        | NOP            | NOP | NOP | NOP }
{ ADD  R8, R8, R6         | NOP            | NOP | NOP | NOP }
{ SW   R8, R1, 0x20       | NOP            | NOP | NOP | NOP }
{ MOVI R12,0x0            | NOP            | NOP | NOP | NOP }
;write reg_phy for "dqs delay" back
{ MOVI R8, 0x40       | NOP | NOP | NOP | NOP }
dma_rw_test_loop:
{ B R14, RW_TEST_DMA | NOP | NOP | NOP | NOP }
{ NOP                | NOP | NOP | NOP | NOP }
{ NOP                | NOP | NOP | NOP | NOP }
{ NOP                | NOP | NOP | NOP | NOP }
{ NOP                | NOP | NOP | NOP | NOP }
{ NOP                | NOP | NOP | NOP | NOP }
{ LBCB R8, dma_rw_test_loop | NOP | NOP | NOP | NOP }
{ ADDI R12, R12, 0x20000 | ADDI D12, D12, 0x20000 | NOP | ADDI D12, D12, 0x20000 | NOP }
{ NOP                | NOP | NOP | NOP | NOP }
{ NOP                | NOP | NOP | NOP | NOP }
{ NOP                | NOP | NOP | NOP | NOP }
{ NOP                | NOP | NOP | NOP | NOP }     
{ NOP                | NOP | NOP | NOP | NOP }     


;{ MOVI R9, 0x800 | NOP | NOP | NOP | NOP }
;random_rw_test:
;
;{ MOVI R0, 0x40 | NOP | MOVI D0,0 | NOP | MOVI D0, 0 }      ;Set Loop count, DDR Addr, test data
;{ MOVI SR0, 0 | MOVI D2, 1 | nop | MOVI D2, 1 | nop }
;rw_loop:
;{ (P15)B rw_fail | SW D0, A6, 0x0 | NOP | SW D0, A6, 0x0 | NOP }
;{ NOP | NOP | NOP | NOP | NOP }
;{ NOP | NOP | NOP | NOP | NOP }
;{ NOP | LW D1, A6, 0x0 | NOP | LW D1, A6, 0x0 | NOP } 
;{ NOP | NOP | NOP | NOP | NOP }
;{ NOP | NOP | NOP | NOP | NOP }
;{ NOP | SEQ A7, P12, P13, D0, D1 | NOP | SEQ A7, P14, P15, D0, D1 | NOP }
;{ (P13)B rw_fail | NOP | (P12)SLLI D0, D0, 0x1 | NOP |(P14)SLLI D0, D0, 0x1 }
;{ NOP            | NOP | (P12)ADD D0, D0, D2   | NOP |(P14)ADD D0, D0, D2 }
;{ NOP            | NOP | NOP | NOP | NOP }
;{ NOP            | NOP | NOP | NOP | NOP }
;{ NOP            | NOP | NOP | NOP | NOP }
;{ NOP            | NOP | NOP | NOP | NOP }
;{ LBCB R0, rw_loop | NOP | NOP | NOP | NOP }
;{ NOP | ADDI A6, A6, 0x4 | NOP | ADDI A6, A6, 0x4 | NOP }
;{ NOP | NOP | NOP | NOP | NOP }
;{ NOP | NOP | NOP | NOP | NOP }
;{ NOP | NOP | NOP | NOP | NOP }
;{ NOP | NOP | NOP | NOP | NOP }
;
;{ LBCB R9, random_rw_test | NOP | NOP | NOP | NOP }
;{ NOP                     | NOP | NOP | NOP | NOP }
;{ NOP                     | ADDI A6, A6, 0x10 | NOP | ADDI A6, A6, 0x10 | NOP }
;{ NOP                     | NOP | NOP | NOP | NOP }
;{ NOP                     | NOP | NOP | NOP | NOP }
;{ NOP                     | NOP | NOP | NOP | NOP }
;P14 = 1: RW Correct
;P15 = 1: RW Fail
{ NOP | NOP | NOP | NOP | SEQI AC7, P1, P2, AC0, 0x1 }
{ NOP | NOP | NOP | (P1)ADDI A0, A0, 0x1 | NOP }
{ NOP | NOP | NOP | (P1)SEQI A7, P12, P13, A0, 0x1 | NOP }
{ (P12)BDT R15 | (P12)BDR A4 | NOP | NOP | NOP }               ;Save dqs1
{ BDT R15     | BDR A5     | NOP | NOP | NOP }               ;Save dqs2
{ NOP         | NOP        | NOP | NOP | NOP }
{ NOP         | NOP            | NOP | NOP | NOP }
{ NOP         | SW A4, A1, 0 | NOP | NOP | NOP }
{ nop         | SW A5, A1, 4 | nop | nop | nop }  
rw_fail:
{ ADDI R15, R15, 0x1      | NOP | NOP | NOP | NOP }
{ SLTI R0, P12, P13, R15, 0x10 | NOP | NOP | NOP | NOP }
{ (P12)B test_loop | NOP | NOP | NOP | NOP }
{ NOP              | NOP | NOP | NOP | NOP }
{ nop              | NOP | nop | nop | nop }  
{ NOP              | NOP | NOP | NOP | NOP }
{ NOP              | NOP | NOP | NOP | NOP }
{ NOP              | NOP | NOP | NOP | NOP }
;Find dqs1, dqs2
{ NOP                     | NOP             | NOP | SLT A7, P5, P6, D7, A0 | NOP } ;small->large
{ NOP                     | (P5)COPY A2, A4 | NOP | (P5) COPY D7, A0 | NOP }
{ NOP                     | (P5)COPY A3, A5 | NOP | (P5) MOVI D6, 0 | NOP }
{ (P5)BDR R10             | (P5)BDT A0      | NOP | (P6)SGT A7, P7, P8, D7, A0 | NOP } ;large->small
{ NOP                     | NOP | NOP | (P7)SRLI D10, D6, 0x1 | NOP }
{ (P7)BDR R3              | NOP | NOP | (P7)BDT D10   | (P7)MOVI D6, 0 }
{ NOP                     | NOP | NOP | (P8)SEQ A7, P9, P10, D7, A0 | NOP }            ;the same 
{ NOP                     | NOP | NOP | (P9)ADDI D6, D6, 0x1 | NOP }
;{ NOP                    | (P9)SRLI A6, A4, 1 | NOP | NOP | NOP }
{ (P7)ADD R10, R10, R3    | (P9)SRLI A7, A5, 1 | NOP | NOP | NOP }
;{ NOP                    | (P9)ADD A2, A2, A6 | NOP | NOP | NOP }
;{ NOP                    | (P9)ADD A3, A3, A7 | NOP | NOP | NOP }
{ LBCB R11, dqsen_loop   | NOP | NOP | NOP | NOP }
{ NOP | ADDI A0, A0, 0x1 | NOP | NOP | NOP }
{ NOP | ADDI A1, A1, 0x8 | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ NOP | NOP | NOP | SRLI D6, D6, 0x1 | NOP }
{ BDR R3 | NOP | NOP | BDT D6 | NOP }
{ NOP | NOP | NOP | SLTI A7, P1, P2, D7, 0x4 | NOP }
{ (P1)B freq_too_high | NOP | NOP | NOP | NOP }

{ ADD R10, R10, R3 | ADD A7, A2, A3 | NOP | NOP | NOP }
{ LW R6, R1, 0x20 | SRLI A7, A7, 0x1 | NOP | NOP | NOP }
{ BDT R10 | BDR D0 | nop | nop | nop }
{ nop | nop | nop | nop | nop }
{ nop | movi A1, 0x2500F500 | nop | nop | nop }  ; modify by JH
{ nop | sw D0, A1, 0 | nop | nop | nop }
{ nop | sw A2, A1, 4 | nop | nop | nop }
{ nop | sw A3, A1, 8 | nop | nop | nop }
{ nop | sw A7, A1, 0xC | nop | nop | nop }
{ nop | nop | nop | nop | nop }
{ nop | nop | nop | nop | nop }
;load reg_phy  to R6
{ SLLI R14, R10, 0x9      | SLLI D0, A7, 0x5  | NOP | NOP | NOP }              
{ SLLI R14, R14, 0x10     | SLLI D1, D0, 0x10 | NOP | NOP | NOP }
{ SLLI R13, R10, 0x9      | SLLI D2, A7, 0x5 | NOP | NOP | NOP }
{ NOP                     | ADD  D3, D1, D2 | NOP | NOP | NOP }
;dqs_delay ok
{ ADD  R12, R13, R14      | NOP | NOP | NOP | NOP }
;;dqs_en ok
{ BDR R7                  | BDT D3 | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ ADD R8, R12, R7         | NOP | NOP | NOP | NOP }
{ LW  R10, R1, 0x20       | NOP | NOP | NOP | NOP }
;write reg_phy for "dqs_en delay" back 
freq_too_high:
{ (P1)MOVI R10, 0x000A000A | NOP | NOP | NOP | NOP }
{ (P1)MOVI R8, 0x01000100  | NOP | NOP | NOP | NOP }
{ ANDI R10, R10, 0x000F000F | NOP | NOP | NOP | NOP }   ;clear bit[8:5] and bit[24:21] (dqs delay),
{ ADD  R8, R8, R10          | NOP | NOP | NOP | NOP }
{ SW   R8, R1, 0x20         | NOP | NOP | NOP | NOP }  ;write reg_phy for "dqs delay" back
{ BR R4 | NOP | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }


;For Read/Write Checking
.set READ_FROM_DDR_Addr_b0, 0x25005000
.set READ_FROM_DDR_Addr_b1, 0x25006000
.set READ_FROM_DDR_Addr_b2, 0x25007000
.set READ_FROM_DDR_Addr_b3, 0x25008000

.set Correct_DATA_Addr_b0,  0x25000000
.set Correct_DATA_Addr_b1,  0x25001000
.set Correct_DATA_Addr_b2,  0x25002000
.set Correct_DATA_Addr_b3,  0x25003000

;===========================================================================================

;For DMA Setting
.set DDR_BASE_ADDR_0, 0x30020000
.set DDR_BASE_ADDR_1, 0x30021000
.set DDR_BASE_ADDR_2, 0x30022000
.set DDR_BASE_ADDR_3, 0x30023000

.set DDR_Interval,    0x00010000
.set Temp_Addr_S,     0x2500C000
.set Temp_Addr_C1,    0x2500C100
.set Temp_Addr_C2,    0x2500C200
;DMA Control Parameter
;[31:20]BSZ:256, INT_EN:0 DSEN:0 SGEN:0 Int2Ext:0, TR_WIDTH:2

RW_TEST_DMA:
{ MOVI R0, Temp_Addr_S          | MOVI A7, Temp_Addr_C1          | NOP | MOVI A7, Temp_Addr_C2          | NOP }
{ SW   R2, R0, 4+               | SW   A6, A7, 4+                | NOP | SW   A6, A7, 4+                | NOP }
{ SW   R3, R0, 4+               | SW   D15, A7, 4+               | NOP | SW   D15, A7, 4+               | NOP }
{ SW   R1, R0, 4+               | SW   A5, A7, 4+                | NOP | SW   A5, A7, 4+                | NOP }
{ SW   R8, R0, 4+               | SW   A4, A7, 4+                | NOP | SW   A4, A7, 4+                | NOP }
{ SW   R4, R0, 4+               | SW   D0, A7, 4+                | NOP | SW   D0, A7, 4+                | NOP }
{ SW   R15, R0, 4+              | SW   D1, A7, 4+                | NOP | SW   D1, A7, 4+                | NOP }
{ SW   R9, R0, 4+               | SW   D2, A7, 4+                | NOP | SW   D2, A7, 4+                | NOP }
{ NOP                           | SW   D3, A7, 4+                | NOP | SW   D3, A7, 4+                | NOP }
{ NOP                           | SW   A0, A7, 4+                | NOP | SW   A0, A7, 4+                | NOP }

{ MOVI R2, Correct_DATA_Addr_b0 | MOVI A7, Correct_DATA_Addr_b0  | NOP | MOVI A7, Correct_DATA_Addr_b1  | NOP }
{ MOVI R3, DDR_BASE_ADDR_0      | MOVI A6, READ_FROM_DDR_Addr_b0 | NOP | MOVI A6, READ_FROM_DDR_Addr_b1 | NOP }
{ NOP                           | MOVI D15, DDR_BASE_ADDR_1      | NOP | MOVI D15, DDR_BASE_ADDR_2      | NOP }
{ NOP                           | MOVI A5, Correct_DATA_Addr_b2  | NOP | MOVI A5, Correct_DATA_Addr_b3  | NOP }
{ ADD R3, R3, R12               | MOVI A4, READ_FROM_DDR_Addr_b2 | ADD D15, D12, D15 | MOVI A4, READ_FROM_DDR_Addr_b3 | ADD D15, D12, D15 }

{ MOVI R0, DSP_DMA_BaseAddr  | MOVI A0, DSP_DMA_BaseAddr | NOP | MOVI A0, DSP_DMA_BaseAddr | nop }
;CLR
{ MOVI R1, 0x1                 | MOVI D14, 0x1               | NOP | MOVI D14, 0x1               | NOP }
{ SW   R1, R0, DMA_CLR0_offset | SW D14, A0, DMA_CLR1_offset | NOP | SW D14, A0, DMA_CLR2_offset | NOP }
;CTL                         
{ MOVI R1, 0x0004000A        | SW D14, A0, DMA_CLR3_offset | nop | nop | nop }
{ SW R1, R0, DMA_CTL0_offset | nop | nop | nop | nop }
;SAR                          
{ SW R2, R0, DMA_SAR0_offset | nop | nop | nop | nop }
{ NOP                        | nop | nop | nop | nop }
;DAR     
{ SW R3, R0, DMA_DAR0_offset | nop | nop | nop | nop }
{ MOVI R8, 0x1               | nop | nop | nop | nop }
{ SW R8, R0, DMA_EN0_offset  | nop | nop | nop | nop }
{ NOP                        | NOP | NOP | NOP | NOP }
{ NOP                        | NOP | NOP | NOP | NOP }                          

DMA_BUSY_0:
{ LW R4, R0, DSP_DMA_SR_offset | NOP | NOP | NOP | NOP }
{ NOP                        | NOP | NOP | NOP | NOP }
{ NOP                        | NOP | NOP | NOP | NOP }
{ SEQI R15, P1, P2, R4, 0x00002222 | NOP | NOP | NOP | NOP }
{ (P2)B DMA_BUSY_0           | NOP | NOP | NOP | NOP }
{ NOP                        | NOP | NOP | NOP | NOP }
{ NOP                        | NOP | NOP | NOP | NOP }
{ NOP                        | NOP | NOP | NOP | NOP }
{ NOP                        | NOP | NOP | NOP | NOP }
{ NOP                        | NOP | NOP | NOP | NOP }

;Channel 0 : DDR -> Local                                                                 
;CTL                         
{ MOVI R1, 0x00040002        |   NOP | NOP | NOP | NOP }
{ SW R1, R0, DMA_CTL0_offset |   NOP | NOP | NOP | NOP }
;SAR                            
{ NOP                        |   NOP | NOP | NOP | NOP }
{ SW R3, R0, DMA_SAR0_offset |   NOP | NOP | NOP | NOP }
;DAR                            
{ MOVI R2, READ_FROM_DDR_Addr_b0 | NOP | NOP | NOP | NOP }
{ SW R2, R0, DMA_DAR0_offset |   NOP | NOP | NOP | NOP }
{ MOVI R8, 0x1               |   NOP | NOP | NOP | NOP }
;Enable DMA                     
{ SW R8, R0, DMA_EN0_offset  |   NOP | NOP | NOP | NOP }
{ NOP                        |   NOP | NOP | NOP | NOP }
{ NOP                        |   NOP | NOP | NOP | NOP } 

DMA_BUSY_1:
{ LW R4, R0, DSP_DMA_SR_offset     | NOP | NOP | NOP | NOP }
{ NOP                              | NOP | NOP | NOP | NOP }
{ NOP                              | NOP | NOP | NOP | NOP }
{ SEQI R15, P1, P2, R4, 0x00002222 | NOP | NOP | NOP | NOP }
{ (P2)B DMA_BUSY_1                 | NOP | NOP | NOP | NOP }
{ NOP                              | NOP | NOP | NOP | NOP }
{ NOP                              | NOP | NOP | NOP | NOP }
{ NOP                              | NOP | NOP | NOP | NOP }
{ NOP                              | NOP | NOP | NOP | NOP }
{ NOP                              | NOP | NOP | NOP | NOP }  

;First Block Transfer Complete
;Begin Second Block 
;Channel 1 : Local -> DDR (Block 2)
;CTL                         
{ MOVI R1, 0x0004000A         | NOP | NOP | NOP | NOP }
{ SW R1, R0, DMA_CTL1_offset  | NOP | NOP | NOP | NOP }
;SAR                         
{ MOVI  R2, Correct_DATA_Addr_b1 | NOP | NOP | NOP | NOP }
{ SW R2, R0, DMA_SAR1_offset | NOP | NOP | NOP | NOP }
;DAR                         
{ NOP                        | NOP | NOP | NOP | NOP }
{ SW R3, R0, DMA_DAR1_offset | NOP | NOP | NOP | NOP }
{ MOVI R8, 0x1               | NOP | NOP | NOP | NOP }
;Enable DMA                  
{ SW R8, R0, DMA_EN1_offset  | NOP | NOP | NOP | NOP }
{ NOP                          | NOP | NOP | NOP | NOP }
{ NOP                          | NOP | NOP | NOP | NOP }

DMA_BUSY_2:
{ LW R4, R0, DSP_DMA_SR_offset     | NOP | NOP | NOP | NOP }
{ NOP                              | NOP | NOP | NOP | NOP }
{ NOP                              | NOP | NOP | NOP | NOP }
{ SEQI R15, P1, P2, R4, 0x00002222 | NOP | NOP | NOP | NOP }
{ (P2)B DMA_BUSY_2                 | NOP | NOP | NOP | NOP }
{ NOP                              | NOP | NOP | NOP | NOP }
{ NOP                              | NOP | NOP | NOP | NOP }
{ NOP                              | NOP | NOP | NOP | NOP }
{ NOP                              | NOP | NOP | NOP | NOP }
{ NOP                              | NOP | NOP | NOP | NOP } 

;Channel 0 : DDR -> Local( Block 2 )                                                                 
;CTL                         
{ MOVI R1, 0x00040002            |   NOP | NOP | NOP | NOP }
{ SW R1, R0, DMA_CTL0_offset     |   NOP | NOP | NOP | NOP }
;SAR                                
{ NOP                            |   NOP | NOP | NOP | NOP }
{ SW R3, R0, DMA_SAR0_offset     |   NOP | NOP | NOP | NOP }
;DAR
{ MOVI R2, READ_FROM_DDR_Addr_b1 | NOP | NOP | NOP | NOP }                            
{ SW R2, R0, DMA_DAR0_offset     |   NOP | NOP | NOP | NOP }
{ MOVI R8, 0x1                   |   NOP | NOP | NOP | NOP }
;Enable DMA                     
{ SW R8, R0, DMA_EN0_offset      |   NOP | NOP | NOP | NOP }
{ NOP                            |   NOP | NOP | NOP | NOP }
{ NOP                            |   NOP | NOP | NOP | NOP }   

DMA_BUSY_3:
{ LW R4, R0, DSP_DMA_SR_offset      | NOP | NOP | NOP | NOP }
{ NOP                               | NOP | NOP | NOP | NOP }
{ NOP                               | NOP | NOP | NOP | NOP }
{ SEQI R15, P1, P2, R4, 0x00002222  | NOP | NOP | NOP | NOP }
{ (P2)B DMA_BUSY_3                  | NOP | NOP | NOP | NOP }
{ NOP                               | NOP | NOP | NOP | NOP }
{ NOP                               | NOP | NOP | NOP | NOP }
{ NOP                               | NOP | NOP | NOP | NOP }
{ NOP                               | NOP | NOP | NOP | NOP }
{ NOP                               | NOP | NOP | NOP | NOP } 

;Block1 and Block2 Read/Write Checking
{ MOVI R9, 0x200  | NOP | NOP | NOP | NOP }
test_rw_b1:
{ MOVI SR0, 0    | DLW D0, A7, 0 | NOP | DLW D0, A7, 0 | NOP }    ;Read from Local
{ NOP            | DLW D2, A6, 0 | NOP | DLW D2, A6, 0 | NOP }    ;Read from DDR    
{ NOP            | NOP | NOP | NOP | NOP }
{ NOP            | NOP | NOP | NOP | NOP }
{ NOP            | NOP | SEQ AC0, P1, P2, D0, D2 | NOP | SEQ AC0, P3, P4, D0, D2 }
{ (P2)B rw_error | NOP | (P1)SEQ AC0, P5, P6, D1, D3 | NOP | (P3)SEQ AC0, P7, P8, D1, D3 }
{ (P6)B rw_error | NOP | NOP | NOP | NOP }
{ NOP            | NOP | NOP | NOP | NOP }
{ NOP            | NOP | NOP | NOP | NOP }
{ NOP            | NOP | NOP | NOP | NOP }
{ NOP            | NOP | NOP | NOP | NOP }
{ NOP            | NOP | NOP | NOP | NOP } 
{ (P4)B rw_error | NOP | NOP | NOP | NOP }
{ (P8)B rw_error | NOP | NOP | NOP | NOP }
{ NOP            | NOP | NOP | NOP | NOP }
{ NOP            | NOP | NOP | NOP | NOP }
{ NOP            | NOP | NOP | NOP | NOP }
{ NOP            | NOP | NOP | NOP | NOP }
{ NOP            | NOP | NOP | NOP | NOP }
{ LBCB R9, test_rw_b1 | ADDI A7, A7, 0x8 | NOP | ADDI A7, A7, 0x8 | NOP } 
{ NOP | ADDI A6, A6, 0x8 | NOP | ADDI A6, A6, 0x8 | NOP }  
{ NOP | NOP | NOP | NOP | NOP }  
{ NOP            | NOP | NOP | NOP | NOP }  
{ NOP            | NOP | NOP | NOP | NOP }  
{ NOP            | NOP | NOP | NOP | NOP }  

;First Block and Second Block Transfer Complete
;Begin Third Block
;Channel 0 : Local -> DDR ( Block 3)
;CTL                         
{ MOVI R1, 0x0004000A        | NOP | nop | nop | nop }
{ SW R1, R0, DMA_CTL0_offset | nop | nop | nop | nop }
;SAR
{ MOVI R2, Correct_DATA_Addr_b2 | NOP | NOP | NOP | NOP }                          
{ SW R2, R0, DMA_SAR0_offset | nop | nop | nop | nop }
{ NOP                        | nop | nop | nop | nop }
;DAR     
{ SW R3, R0, DMA_DAR0_offset | nop | nop | nop | nop }
{ MOVI R8, 0xF               | nop | nop | nop | nop }
{ SW R8, R0, DMA_EN0_offset  | nop | nop | nop | nop }
{ NOP                        | NOP | NOP | NOP | NOP }
{ NOP                        | NOP | NOP | NOP | NOP } 

DMA_BUSY_4:
{ LW R4, R0, DSP_DMA_SR_offset | NOP | NOP | NOP | NOP }
{ NOP                          | NOP | NOP | NOP | NOP }
{ NOP                          | NOP | NOP | NOP | NOP }
{ ANDI R4, R4, 0x1             | NOP | NOP | NOP | NOP }
{ SEQI R15, P1, P2, R4, 0x0     | NOP | NOP | NOP | NOP }
{ (P2)B DMA_BUSY_4             | NOP | NOP | NOP | NOP }
{ NOP                          | NOP | NOP | NOP | NOP }
{ NOP                          | NOP | NOP | NOP | NOP }
{ NOP                          | NOP | NOP | NOP | NOP }
{ NOP                          | NOP | NOP | NOP | NOP }
{ NOP                          | NOP | NOP | NOP | NOP }   

;Channel 1 : DDR -> Local( Block 3 )                                                                 
;CTL                         
{ MOVI R1, 0x00040002        |   NOP | NOP | NOP | NOP }
{ SW R1, R0, DMA_CTL1_offset |   NOP | NOP | NOP | NOP }
;SAR                            
{ NOP                        |   NOP | NOP | NOP | NOP }
{ SW R3, R0, DMA_SAR1_offset |   NOP | NOP | NOP | NOP }
;DAR
{ MOVI R2, READ_FROM_DDR_Addr_b2 | NOP | NOP | NOP | NOP }                            
{ SW R2, R0, DMA_DAR1_offset |   NOP | NOP | NOP | NOP }
{ MOVI R8, 0x1               |   NOP | NOP | NOP | NOP }
;Enable DMA                     
{ SW R8, R0, DMA_EN1_offset  |   NOP | NOP | NOP | NOP }
{ NOP                        |   NOP | NOP | NOP | NOP }
{ NOP                        |   NOP | NOP | NOP | NOP }   

DMA_BUSY_5:
{ LW R4, R0, DSP_DMA_SR_offset | NOP | NOP | NOP | NOP }
{ NOP                          | NOP | NOP | NOP | NOP }
{ NOP                          | NOP | NOP | NOP | NOP }
{ ANDI R4, R4, 0x2             | NOP | NOP | NOP | NOP }
{ SEQI R15, P1, P2, R4, 0x0     | NOP | NOP | NOP | NOP }
{ (P2)B DMA_BUSY_5           | NOP | NOP | NOP | NOP }
{ NOP                          | NOP | NOP | NOP | NOP }
{ NOP                          | NOP | NOP | NOP | NOP }
{ NOP                          | NOP | NOP | NOP | NOP }
{ NOP                          | NOP | NOP | NOP | NOP }
{ NOP                          | NOP | NOP | NOP | NOP } 

;Third Block Transfer Complete
;Begin Forth Block
;Channel 0 : Local -> DDR ( Block 4)
;CTL                         
{ MOVI R1, 0x0004000A        | NOP | nop | nop | nop }
{ SW R1, R0, DMA_CTL0_offset | nop | nop | nop | nop }
;SAR
{ MOVI R2, Correct_DATA_Addr_b3 | NOP | NOP | NOP | NOP }                          
{ SW R2, R0, DMA_SAR0_offset | nop | nop | nop | nop }
{ NOP                        | nop | nop | nop | nop }
;DAR     
{ SW R3, R0, DMA_DAR0_offset | nop | nop | nop | nop }
{ MOVI R8, 0xF               | nop | nop | nop | nop }
{ SW R8, R0, DMA_EN0_offset  | nop | nop | nop | nop }
{ NOP                        | NOP | NOP | NOP | NOP }
{ NOP                        | NOP | NOP | NOP | NOP } 

DMA_BUSY_6:
{ LW R4, R0, DSP_DMA_SR_offset | NOP | NOP | NOP | NOP }
{ NOP                          | NOP | NOP | NOP | NOP }
{ NOP                          | NOP | NOP | NOP | NOP }
{ ANDI R4, R4, 0x1             | NOP | NOP | NOP | NOP }
{ SEQI R15, P1, P2, R4, 0x0     | NOP | NOP | NOP | NOP }
{ (P2)B DMA_BUSY_6             | NOP | NOP | NOP | NOP }
{ NOP                          | NOP | NOP | NOP | NOP }
{ NOP                          | NOP | NOP | NOP | NOP }
{ NOP                          | NOP | NOP | NOP | NOP }
{ NOP                          | NOP | NOP | NOP | NOP }
{ NOP                          | NOP | NOP | NOP | NOP }   

;Channel 1 : DDR -> Local( Block 4 )                                                                 
;CTL                         
{ MOVI R1, 0x00040002        |   NOP | NOP | NOP | NOP }
{ SW R1, R0, DMA_CTL1_offset |   NOP | NOP | NOP | NOP }
;SAR                            
{ NOP                        |   NOP | NOP | NOP | NOP }
{ SW R3, R0, DMA_SAR1_offset |   NOP | NOP | NOP | NOP }
;DAR
{ MOVI R2, READ_FROM_DDR_Addr_b3 | NOP | NOP | NOP | NOP }                            
{ SW R2, R0, DMA_DAR1_offset |   NOP | NOP | NOP | NOP }
{ MOVI R8, 0x1               |   NOP | NOP | NOP | NOP }
;Enable DMA                     
{ SW R8, R0, DMA_EN1_offset  |   NOP | NOP | NOP | NOP }
{ NOP                        |   NOP | NOP | NOP | NOP }
{ NOP                        |   NOP | NOP | NOP | NOP }   

DMA_BUSY_7:
{ LW R4, R0, DSP_DMA_SR_offset | NOP | NOP | NOP | NOP }
{ NOP                          | NOP | NOP | NOP | NOP }
{ NOP                          | NOP | NOP | NOP | NOP }
{ ANDI R4, R4, 0x2             | NOP | NOP | NOP | NOP }
{ SEQI R15, P1, P2, R4, 0x0     | NOP | NOP | NOP | NOP }
{ (P2)B DMA_BUSY_7           | NOP | NOP | NOP | NOP }
{ NOP                          | NOP | NOP | NOP | NOP }
{ NOP                          | NOP | NOP | NOP | NOP }
{ NOP                          | NOP | NOP | NOP | NOP }
{ NOP                          | NOP | NOP | NOP | NOP }
{ NOP                          | NOP | NOP | NOP | NOP }

;Block3 and Block4 Read/Write Checking
{ MOVI R9, 0x200  | NOP | NOP | NOP | NOP }
test_rw_b2:
{ MOVI SR0, 0    | DLW D0, A5, 0 | NOP | DLW D0, A5, 0 | NOP }    ;Read from Local
{ NOP            | DLW D2, A4, 0 | NOP | DLW D2, A4, 0 | NOP }    ;Read from DDR    
{ NOP            | NOP | NOP | NOP | NOP }
{ NOP            | NOP | NOP | NOP | NOP }
{ NOP            | NOP | SEQ AC0, P1, P2, D0, D2 | NOP | SEQ AC0, P3, P4, D0, D2 }
{ (P2)B rw_error | NOP | (P1)SEQ AC0, P5, P6, D1, D3 | NOP | (P3)SEQ AC0, P7, P8, D1, D3 }
{ (P6)B rw_error | NOP | NOP | NOP | NOP }
{ NOP            | NOP | NOP | NOP | NOP }
{ NOP            | NOP | NOP | NOP | NOP }
{ NOP            | NOP | NOP | NOP | NOP }
{ NOP            | NOP | NOP | NOP | NOP }
{ NOP            | NOP | NOP | NOP | NOP } 
{ (P4)B rw_error | NOP | NOP | NOP | NOP }
{ (P8)B rw_error | NOP | NOP | NOP | NOP }
{ NOP            | NOP | NOP | NOP | NOP }
{ NOP            | NOP | NOP | NOP | NOP }
{ NOP            | NOP | NOP | NOP | NOP }
{ NOP            | NOP | NOP | NOP | NOP }
{ NOP            | NOP | NOP | NOP | NOP }
{ LBCB R9, test_rw_b2 | ADDI A5, A5, 0x8 | NOP | ADDI A5, A5, 0x8 | NOP } 
{ NOP | ADDI A4, A4, 0x8 | NOP | ADDI A4, A4, 0x8 | NOP }  
{ NOP | NOP | NOP | NOP | NOP }  
{ NOP | NOP | NOP | NOP | NOP }  
{ NOP | NOP | NOP | NOP | NOP }  
{ NOP | NOP | NOP | NOP | NOP }  
         

{ MOVI R0, Temp_Addr_S          | MOVI A7, Temp_Addr_C1          | NOP | MOVI A7, Temp_Addr_C2          | NOP }
{ LW   R2, R0, 4+               | LW   A6, A7, 4+                | NOP | LW   A6, A7, 4+                | NOP }
{ LW   R3, R0, 4+               | LW   D15, A7, 4+               | NOP | LW   D15, A7, 4+               | NOP }
{ LW   R1, R0, 4+               | LW   A5, A7, 4+                | NOP | LW   A5, A7, 4+                | NOP }
{ LW   R8, R0, 4+               | LW   A4, A7, 4+                | NOP | LW   A4, A7, 4+                | NOP }
{ LW   R4, R0, 4+               | LW   D0, A7, 4+                | NOP | LW   D0, A7, 4+                | NOP }
{ LW   R15, R0, 4+              | LW   D1, A7, 4+                | NOP | LW   D1, A7, 4+                | NOP }
{ LW   R9, R0, 4+               | LW   D2, A7, 4+                | NOP | LW   D2, A7, 4+                | NOP }
{ NOP                           | LW   D3, A7, 4+                | NOP | LW   D3, A7, 4+                | NOP }
{ NOP                           | LW   A0, A7, 4+                | NOP | LW   A0, A7, 4+                | NOP }
{ BR R14                        | NOP                            | NOP | NOP                            | NOP }
{ NOP            | NOP | NOP | NOP | NOP }  
{ NOP            | NOP | NOP | NOP | NOP }  
{ NOP            | NOP | NOP | NOP | NOP }  
{ NOP            | NOP | NOP | NOP | NOP }  
{ NOP            | NOP | NOP | NOP | NOP }  

rw_error:
{ MOVI R0, Temp_Addr_S          | MOVI A7, Temp_Addr_C1          | NOP | MOVI A7, Temp_Addr_C2          | NOP }
{ LW   R2, R0, 4+               | LW   A6, A7, 4+                | NOP | LW   A6, A7, 4+                | NOP }
{ LW   R3, R0, 4+               | LW   D15, A7, 4+               | NOP | LW   D15, A7, 4+               | NOP }
{ LW   R1, R0, 4+               | LW   A5, A7, 4+                | NOP | LW   A5, A7, 4+                | NOP }
{ LW   R8, R0, 4+               | LW   A4, A7, 4+                | NOP | LW   A4, A7, 4+                | NOP }
{ LW   R4, R0, 4+               | LW   D0, A7, 4+                | NOP | LW   D0, A7, 4+                | NOP }
{ LW   R15, R0, 4+              | LW   D1, A7, 4+                | NOP | LW   D1, A7, 4+                | NOP }
{ LW   R9, R0, 4+               | LW   D2, A7, 4+                | NOP | LW   D2, A7, 4+                | NOP }
{ NOP                           | LW   D3, A7, 4+                | NOP | LW   D3, A7, 4+                | NOP }
{ NOP                           | LW   A0, A7, 4+                | NOP | LW   A0, A7, 4+                | NOP }
{ B rw_fail                     | NOP                            | NOP | NOP                            | NOP }
{ NOP            | NOP | NOP | NOP | NOP }  
{ NOP            | NOP | NOP | NOP | NOP }  
{ NOP            | NOP | NOP | NOP | NOP }  
{ NOP            | NOP | NOP | NOP | NOP }  
{ NOP            | NOP | NOP | NOP | NOP }  



  