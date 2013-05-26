;;------------------------------- To Verify ---------------------------------
;;DMA Transfer : DMA transfer 16*Luma4x4, 16*Chroma4x2 2D->2D from DDR to LDM
;;16*Luma4x4
;;  16(block)*4(bytes/each memory line)*4(writing times)
;;16*Chroma4x2
;;  16(block)*4(bytes/each memory line)*2(writing times)
;;
;;---------------------------------------------------------------------------

;;M1 Base Address
PACDSP0_LDM_BaseAddr = 0x24000000

;;PACDSP CORE0 DMA SETTING
;DMA base address in core 0;
PACDSP0_M1_DMA_Base = 0x2405C000
 
;CH0 Register Offset 
 DMA_SAR0_offset   = 0x70;
 DMA_DAR0_offset   = 0x74;
 DMA_SGR0_offset   = 0x78;
 DMA_DSR0_offset   = 0x7C;
 DMA_CTL0_offset   = 0x80;
 DMA_ENA0_offset   = 0x84;
 DMA_CLR0_offset   = 0x88;
 DMA_LLST0_offset  = 0x8C;
 DMA_PDCTL0_offset = 0x90;
 DMA_SHAPE0_offset = 0x94;
 DMA_RES0_offset   = 0x98;
 
;CH1 Register Offset 
 DMA_SAR1_offset   = 0xB0;
 DMA_DAR1_offset   = 0xB4;
 DMA_SGR1_offset   = 0xB8;
 DMA_DSR1_offset   = 0xBC;
 DMA_CTL1_offset   = 0xC0;
 DMA_ENA1_offset   = 0xC4;
 DMA_CLR1_offset   = 0xC8;
 DMA_LLST1_offset  = 0xCC;
 DMA_PDCTL1_offset = 0xD0;
 DMA_SHAPE1_offset = 0xD4;
 DMA_RES1_offset   = 0xD8;
 
;CH2 Register Offset 
; DMA_SAR2_offset   = 0xF0;
; DMA_DAR2_offset   = 0xF4;
; DMA_SGR2_offset   = 0xF8;
; DMA_DSR2_offset   = 0xFC;
; DMA_CTL2_offset   = 0x100;
; DMA_ENA2_offset   = 0x104;
; DMA_CLR2_offset   = 0x108;
; DMA_LLST2_offset  = 0x10C;
; DMA_PDCTL2_offset = 0x110;
; DMA_SHAPE2_offset = 0x114;
; DMA_RES2_offset   = 0x118;
 
;CH3 Register Offset 
;DMA_SAR3_offset   = 0x130;
;DMA_DAR3_offset   = 0x134;
;DMA_SGR3_offset   = 0x138;
;DMA_DSR3_offset   = 0x13C;
;DMA_CTL3_offset   = 0x140;
;DMA_ENA3_offset   = 0x144;
;DMA_CLR3_offset   = 0x148;
;DMA_LLST3_offset  = 0x14C;
;DMA_PDCTL3_offset = 0x150;
;DMA_SHAPE3_offset = 0x154;
;DMA_RES3_offset   = 0x158; 

;Luma_BaseAddr      = 0x30022000
;Chroma_BaseAddr    = 0x30040000
Luma_BaseAddr      = 0x18022000
Chroma_BaseAddr    = 0x18040000

M1_Luma_result     = 0x24000000 
M1_Chroma_result   = 0x24001000

DMA_M1_SR      = 0x24058054
 

;======= DMA setup/control setting for ch0,ch1 ======================

{ movi r0, PACDSP0_M1_DMA_Base | movi a0, PACDSP0_M1_DMA_Base  | movi d0, 0x1        | nop | nop}
;r0=PACDSP0_M1_DMA_Base; a0=PACDSP0_M1_DMA_Base;d=0x1; 
{ movi r1, 0x1                 | sw d0, a0, DMA_CLR1_offset    | nop                 | nop                          | nop          }
;r1=1;DMA_CLR1=0x1; 
{ sw r1, r0, DMA_CLR0_offset   | nop                           | nop                 | nop                          | nop          }
;DMA_CLR0=0x1;

{ movi r11, 0                  | nop                           | nop                 | nop                          | nop          }
{ movi r10, 16                 | movi d6, 0                    | nop                 | nop                          | nop          }
{ movi r8, 0                   | movi d7, 0                    | nop                 | nop                          | nop          }
 ;r11=0;r10=16;d6=0;r8=0;d7=0;

;;CH0 Test 2D -> 2D Luma Transfer, CH1 Test 2D -> 2D Chroma Transfer
DMA_Setup:
;;Scalar Set CH0 DMA, C1 set CH1 DMA, C2 set CH2 DMA
{ movi r0, PACDSP0_M1_DMA_Base | movi a0, PACDSP0_M1_DMA_Base  | nop                 | nop | nop          }
;r0=PACDSP0_M1_DMA_Base;a0=PACDSP0_M1_DMA_Base;

;;SAR                                                                                      
{ movi r1, Luma_BaseAddr       | movi d0, Chroma_BaseAddr      | nop                 | nop | nop          }
;r1=Luma_BaseAddr;d0=Chroma_BaseAddr;

{ add r1, r1, r11              | add d0, d0, d6                | nop                 | nop | nop          }
;r1=r1+r11=r1+0;d0=d0+d6; 

{ sw r1, r0, DMA_SAR0_offset   | sw d0, a0, DMA_SAR1_offset    | nop                 | nop | nop          }
;DMA_SAR0=r1,DMA_SAR1=d0;

;;DAR                                                                                      
{ movi r2, M1_Luma_result      | movi a1, M1_Chroma_result     | nop                 | nop | nop          }
;r2=M1_Luma_result;a1=M1_Chroma_result; 

{ add r2, r2, r8               | add a1, a1, d7                | nop                 | nop | nop          }
;r2=r2+r8;a1=a1+d7;

{ sw r2, r0, DMA_DAR0_offset   | sw a1, a0, DMA_DAR1_offset    | nop                 | nop | nop          }
;DMA_DAR0=r2;DMA_DAR1=a1;


;;SGR                                                                                      
{ movi r3, 0x00400780          | movi d1, 0x00400780           | nop                 | nop | nop          }
{ movi r3, 0x00800780          | movi d1, 0x00800780           | nop                 | nop | nop          }
;r3=0x004 00780;d1=0x00400780; 

{ sw r3, r0, DMA_SGR0_offset   | sw d1, a0, DMA_SGR1_offset    | nop                 | nop | nop          }
;DMA_SGR0=r3;DMA_SGR1=d1
;0000_0000_0000 0000_0000_0000_0000_0000
;0x008 00780 =

;0000_0000_1000 0000_0000_0111_1000_0000
;Gather count=8;    gather offset =1920;
;Offset =1920 =780h;see tic.c file
;A(0x30022000); W(0x55229988,NO_Mask); 
;A(0x30022780); W(0x11223344,NO_Mask);
;A(0x30022F00); W(0x55687abc,NO_Mask);
;A(0x30023680); W(0x76854321,NO_Mask);



;;DSR                                                                                      
{ movi r4, 0x00000000          | movi d2, 0x00000000           | nop                 | nop | nop          }
;r4=0x0;d2=0x0;
{ sw r4, r0, DMA_DSR0_offset   | sw d2, a0, DMA_DSR1_offset    | nop                 | nop | nop          }
;DMA_DSR0=r4;DMA_DSR1=d2

;now
;;CTL                                                                                      
{ movi r5, 0x00010104          | movi d3, 0x00008104           | nop                 | nop | nop          }
;r5=0x10104;d3=0x8104;
{ sw r5, r0, DMA_CTL0_offset   | sw d3, a0, DMA_CTL1_offset    | nop                 | nop | nop          }
;0000_0000_0000_0000_0000_0000_0000_0000;       
; [31:12] BSZ, [11]LLEN, [10]INTEN, [9]DSEN, [8]SGEN, [5]DTEN,[4]STEN,
; [3]Int2Ext, [2]Burst, TRZ[1:0]

;0x00010104  
;0000_0000_0000_0001_0000 0001_0000_0100;
;size=16(4x8(a word)x4) bytes;SGEN=1;Burst=1;
;0x000081041
;0000_0000_0000_0000_1000 0001_0000_0100
;size=8(4x8(a word)x2);SGEN=1;Burst=1;

;;Enable DMA                                                                               
{ movi r6, 0x1                 | movi d4, 0x1                  | nop                 | nop | nop          }
;r6=0x1;d4=0x1;
{ sw r6, r0, DMA_ENA0_offset   | sw d4, a0, DMA_ENA1_offset    | nop                 | nop | nop          }
;DMA_ENA0=r6=0x1;DMA_ENA1=d4=0x1;
{  NOP                         |  NOP                          |  NOP                | NOP | NOP  }
{  NOP                         |  NOP                          |  NOP                | NOP | NOP  }

;;WAIT DMA Transfer Complete
;************************************************************** wait until DMA done
{  MOVI R5, DMA_M1_SR      |  NOP  |  NOP  |  NOP  |  NOP  }
;R5=0x24058054;
_Label1:
{  LW R6, R5, 0            |  NOP  |  NOP  |  NOP  |  NOP  }
;R6=R5;
{  NOP                     |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                     |  NOP  |  NOP  |  NOP  |  NOP  }
{  SEQI R7, P1, P2, R6, 0x00002222  |  NOP  |  NOP  |  NOP  |  NOP  }

{  (P2)B _Label1           |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                     |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                     |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                     |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                     |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP                     |  NOP  |  NOP  |  NOP  |  NOP  }       

{ LBCB r10, DMA_Setup      |  NOP               |  NOP  |  NOP  |  NOP  }   
;LBCB can insert 5(may be 4) instructions since LBCB is in the last
{  addi r8, r8, 0x10       |  addi d7, d7, 0x8  |  NOP  |  NOP  |  NOP  }
;
{  addi r11, r11, 0x4      |  addi d6, d6, 0x4  |  NOP  |  NOP  |  NOP  }
{  NOP                     |  NOP               |  NOP  |  NOP  |  NOP  }
{  NOP                     |  NOP               |  NOP  |  NOP  |  NOP  }
{  NOP                     |  NOP               |  NOP  |  NOP  |  NOP  }                 

;************************************************************** Program Terminates
{  TRAP  |  NOP  |  NOP  |  NOP  |  NOP  }

