;===============================================================================
; Author: Anthony
; Description: Read data from M2 DMA register;
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
    
;==== M2 DMA offset ====
M2_DMA_Base = 0x25820000;

;CH0 Register Offset 
DMA_SAR0_offset	    =	0x0070;
DMA_DAR0_offset	    =	0x0074;
DMA_SGR0_offset	    =	0x0078;
DMA_DSR0_offset     =	0x007C;
DMA_CTL0_offset     =	0x0080;
DMA_LLST0_offset    =	0x008C;
DMA_PDCTL0_offset   =	0x0090;

;CH1 Register Offset 
DMA_SAR1_offset	   =	0x00B0;
DMA_DAR1_offset	   =	0x00B4;
DMA_SGR1_offset	   =	0x00B8;
DMA_DSR1_offset	   =	0x00BC;
DMA_CTL1_offset	   =	0x00C0;
DMA_LLST1_offset   =	0x00CC;
DMA_PDCTL1_offset  =	0x00D0;

;CH2 Register Offset 
DMA_SAR2_offset	   =	0x00F0;
DMA_DAR2_offset	   =	0x00F4;
DMA_SGR2_offset	   =	0x00F8;
DMA_DSR2_offset	   =	0x00FC;
DMA_CTL2_offset	   =	0x0100;
DMA_LLST2_offset   =	0x010C;
DMA_PDCTL2_offset  =	0x0110;

;CH3 Register Offset 
DMA_SAR3_offset	   =	0x0130;
DMA_DAR3_offset	   =	0x0134;
DMA_SGR3_offset	   =	0x0138;
DMA_DSR3_offset	   =	0x013C;
DMA_CTL3_offset	   =	0x0140;
DMA_LLST3_offset   =	0x014C;
DMA_PDCTL3_offset  =	0x0150;

;CH4 Register Offset 
DMA_SAR4_offset	   =	0x0170;
DMA_DAR4_offset	   =	0x0174;
DMA_SGR4_offset	   =	0x0178;
DMA_DSR4_offset	   =	0x017C;
DMA_CTL4_offset	   =	0x0180;
DMA_LLST4_offset   =	0x018C;
DMA_PDCTL4_offset  =	0x0190;

;CH5 Register Offset 
DMA_SAR5_offset	   =	0x01B0;
DMA_DAR5_offset	   =	0x01B4;
DMA_SGR5_offset	   =	0x01B8;
DMA_DSR5_offset	   =	0x01BC;
DMA_CTL5_offset	   =	0x01C0;
DMA_LLST5_offset   =	0x01CC;
DMA_PDCTL5_offset  =	0x01D0;

;CH6 Register Offset 
DMA_SAR6_offset	   =	0x01F0;
DMA_DAR6_offset	   =	0x01F4;
DMA_SGR6_offset	   =	0x01F8;
DMA_DSR6_offset	   =	0x01FC;
DMA_CTL6_offset	   =	0x0200;
DMA_LLST6_offset   =	0x020C;
DMA_PDCTL6_offset  =	0x0210;

;CH7 Register Offset 
DMA_SAR7_offset	   =	0x0230;
DMA_DAR7_offset	   =	0x0234;
DMA_SGR7_offset	   =	0x0238;
DMA_DSR7_offset	   =	0x023C;
DMA_CTL7_offset	   =	0x0240;
DMA_LLST7_offset   =	0x024C;
DMA_PDCTL7_offset  =	0x0250;

Luma_BaseAddr = 0x3005D000;
Chroma_BaseAddr = 0x30046000;
M2_Luma_result = 0x2500C200;
M2_Chroma_result = 0x25005800;

Scalar_Saving_data_BaseAddr = 0x2500;
Cluster1_Saving_data_BaseAddr = 0x2502;

  ;==== Test for channel 4,channe 3; ====
  { movi   r0, M2_DMA_Base                    | movi a0, M2_DMA_Base                       | nop | nop | nop }
  { movi.h r11, Scalar_Saving_data_BaseAddr   | movi.h a1, Cluster1_Saving_data_BaseAddr   | nop | nop | nop }
  { movi.l r11, 0x0000                        | movi.l a1, 0x0000                          | nop | nop | nop }
  
  { NOP | NOP | NOP | NOP | NOP } 

  ;===== Read data from DMA register;
  { lw r1, r0, DMA_SAR4_offset    | lw d0, a0, DMA_SAR3_offset   | nop | nop | nop }
  { lw r2, r0, DMA_DAR4_offset    | lw d1, a0, DMA_DAR3_offset   | nop | nop | nop }
  { lw r3, r0, DMA_SGR4_offset    | lw d2, a0, DMA_SGR3_offset   | nop | nop | nop }
  { lw r4, r0, DMA_DSR4_offset    | lw d3, a0, DMA_DSR3_offset   | nop | nop | nop }
  { lw r5, r0, DMA_CTL4_offset    | lw d4, a0, DMA_CTL3_offset   | nop | nop | nop }
  { lw r6, r0, DMA_LLST4_offset   | lw d5, a0, DMA_LLST3_offset  | nop | nop | nop }
  { lw r7, r0, DMA_PDCTL4_offset  | lw d6, a0, DMA_PDCTL3_offset | nop | nop | nop }
  
  ;===== Write data to Share memory;
  { sw r1, r11, DMA_SAR4_offset   | sw d0, a1, DMA_SAR3_offset   | nop | nop | nop }
  { sw r2, r11, DMA_DAR4_offset   | sw d1, a1, DMA_DAR3_offset   | nop | nop | nop }
  { sw r3, r11, DMA_SGR4_offset   | sw d2, a1, DMA_SGR3_offset   | nop | nop | nop }
  { sw r4, r11, DMA_DSR4_offset   | sw d3, a1, DMA_DSR3_offset   | nop | nop | nop }
  { sw r5, r11, DMA_CTL4_offset   | sw d4, a1, DMA_CTL3_offset   | nop | nop | nop }
  { sw r6, r11, DMA_LLST4_offset  | sw d5, a1, DMA_LLST3_offset  | nop | nop | nop }
  { sw r7, r11, DMA_PDCTL4_offset | sw d6, a1, DMA_PDCTL3_offset | nop | nop | nop }  
     
  { NOP | NOP | NOP | NOP | NOP }   
  { TRAP | NOP | NOP | NOP | NOP }  
  
