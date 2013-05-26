;===============================================================================
; Author: Anthony
; Description: Access M2DMA register;
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

Luma_BaseAddr = 0x3005F000;
Chroma_BaseAddr = 0x30044000;
M2_Luma_result = 0x2500A200;
M2_Chroma_result = 0x25001700;

r3_value = 0x13412341;
r4_value = 0x41234123;
r5_value = 0x31431414;
r6_value = 0x14314123;
r7_value = 0x12341134;

d1_value = 0x11143414;
d2_value = 0x33313413;
d3_value = 0x77743411;
d4_value = 0x13413411;
d5_value = 0x13341238;

  ;==== Test for channel 5,channe 0; ====
  { movi r11, 0                  | movi d6, 0                   | nop | nop | nop }
  { movi r8, 0                   | movi d7, 0                   | nop | nop | nop }
  
  { movi r0, M2_DMA_Base         | movi a0, M2_DMA_Base         | nop | nop | nop }
  { NOP | NOP | NOP | NOP | NOP } 
  ;;SAR                                                                                      
  { movi r1, Luma_BaseAddr       | movi d0, Chroma_BaseAddr     | nop | nop | nop }
  { add r1, r1, r11              | add d0, d0, d6               | nop | nop | nop }
  { sw r1, r0, DMA_SAR5_offset   | sw d0, a0, DMA_SAR0_offset   | nop | nop | nop }
   ;;DAR                                                                                      
  { movi r2, M2_Luma_result      | movi a1, M2_Chroma_result    | nop | nop | nop }
  { add r2, r2, r8               | add a1, a1, d7               | nop | nop | nop }
  { sw r2, r0, DMA_DAR5_offset   | sw a1, a0, DMA_DAR0_offset   | nop | nop | nop }
  ;;SGR                                                                                      
  { movi r3, r3_value            | movi d1, d1_value            | nop | nop | nop }
  { sw r3, r0, DMA_SGR5_offset   | sw d1, a0, DMA_SGR0_offset   | nop | nop | nop }
  ;;DSR                                                                                      
  { movi r4, r4_value            | movi d2, d2_value            | nop | nop | nop }
  { sw r4, r0, DMA_DSR5_offset   | sw d2, a0, DMA_DSR0_offset   | nop | nop | nop }
  ;;CTL                                                                                      
  { movi r5, r5_value            | movi d3, d3_value            | nop | nop | nop }
  { sw r5, r0, DMA_CTL5_offset   | sw d3, a0, DMA_CTL0_offset   | nop | nop | nop }
  ;;LLST
  { movi r6, r6_value            | movi d4, d4_value            | nop | nop | nop }
  { sw r6, r0, DMA_LLST5_offset  | sw d4, a0, DMA_LLST0_offset  | nop | nop | nop }
  ;;PDCTL
  { movi r7, r7_value            | movi d5, d5_value            | nop | nop | nop }
  { sw r7, r0, DMA_PDCTL5_offset | sw d5, a0, DMA_PDCTL0_offset | nop | nop | nop }
  
    
  { NOP  | NOP | NOP | NOP | NOP }   
  { TRAP | NOP | NOP | NOP | NOP }  
  
