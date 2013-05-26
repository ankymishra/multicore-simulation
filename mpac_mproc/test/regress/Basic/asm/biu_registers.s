;**********************************************************************
; To verify
; Memory mapped registers in BIU
;**********************************************************************
  
  BASE_ADDR = 0x2400
  CORE_ADDR = 0x24050000;
  IMEM_ADDR = 0x24054000;
  DMEM_ADDR = 0x24058000;

;Initial BIU Register  
;{  MOVI R0, CORE_ADDR  | NOP  |  NOP  |  NOP  |  NOP  }
;{  MOVI R1, 0x0        | NOP  |  NOP  |  NOP  |  NOP  }
;{  SW R1, R0, 0x4      | NOP  |  NOP  |  NOP  |  NOP  }  ; CPS
;{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

;{  MOVI R1, 0x00000001 | NOP  |  NOP  |  NOP  |  NOP  }
;{  SW R1, R0, 0x08     | NOP  |  NOP  |  NOP  |  NOP  } ; CBUSY is read-only
;{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

;{  MOVI R1, 0x10000000 | NOP  |  NOP  |  NOP  |  NOP  }
;{  SW R1, R0, 0x10     | NOP  |  NOP  |  NOP  |  NOP  }  ; ICPSA (start address for initial program)
;{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

;{  MOVI R1, 0x00000001 | NOP  |  NOP  |  NOP  |  NOP  }
;{  SW R1, R0, 0x14     | NOP  |  NOP  |  NOP  |  NOP  }  ; ICISIZE (number of initial cache lines)
;{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

;{  MOVI R1, 0x00000001 | NOP  |  NOP  |  NOP  |  NOP  }
;{  SW R1, R0, 0x18     | NOP  |  NOP  |  NOP  |  NOP  }  ; ICMSIZE (number of miss cache lines)
;{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

;{  MOVI R1, 0x12070000 | NOP  |  NOP  |  NOP  |  NOP  }
;{  SW R1, R0, 0x38     | NOP  |  NOP  |  NOP  |  NOP  }  ; BAR (Data memory base address)
;{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  MOVI.L R0, 0x0000    |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R0, BASE_ADDR |  NOP  |  NOP  |  NOP  |  NOP  }   ; modify by JH for 7056
;{  MOVI.L R1, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  MOVI.H R1, 0x1206  |  NOP  |  NOP  |  NOP  |  NOP  }


;************************************************************** Program start address (CPSA)
{  MOVI   R1, CORE_ADDR  | NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.L R2, 0x5A5A  |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R2, 0x5A5A  |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R2, R1, 0  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }  ; add by JH
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  LW R3, R1, 0  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R3, R0, 0  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x2400_0000] = 0x5A5A_5A5A

;************************************************************** Core status (CBUSY)
;{  LW R3, R1, 8  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  SW R3, R0, 4  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0004] = 0x0000_0001

;************************************************************** Instruction cache initial size (ICISIZE)
{  MOVI   R1, IMEM_ADDR |  NOP  |  NOP  |  NOP  |  NOP  }

{  LW R3, R1, 20        |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  ADDI R3, R3, 1  |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R3, R1, 20   |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }  ; add by JH
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  } 
{  LW R3, R1, 20  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R3, R0, 8  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0008] = 0x00000002

;************************************************************** Instruction cache start address (ICPSA)
{  LW R3, R1, 16  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R3, R0, 12  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_000C] = 0x00000000

;************************************************************** Instruction cache miss size (ICMSIZE)
{  MOVI.L R2, 0x0001  |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R2, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R2, R1, 24  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }  ; add by JH
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  } 
{  LW R3, R1, 24  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R3, R0, 16  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0010] = 0x0000_0001

;************************************************************** DBGISR, EXCISR, FIQISR, IRQISR
{  MOVI   R1, CORE_ADDR |  NOP  |  NOP  |  NOP  |  NOP  }

{  MOVI.L R2, 0x1111  |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R2, 0x1111  |  NOP  |  NOP  |  NOP  |  NOP  }
{  ADD R2, R2, R2     |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R2, R1, 0x1C    |  NOP  |  NOP  |  NOP  |  NOP  }  ;Mem[0x1201_001C] = 0x2222_2222
; Debugger ISR address (DBGISR)
{  ADD R2, R2, R2   |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R2, R1, 0x20  |  NOP  |  NOP  |  NOP  |  NOP  }    ;Mem[0x1201_0020] = 0x4444_4444
; Exception ISR address (EXCISR)
{  ADD R2, R2, R2   |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R2, R1, 0x24  |  NOP  |  NOP  |  NOP  |  NOP  }    ;Mem[0x1201_0024] = 0x8888_8888
; FIQ ISR address (FIQISR)
{  ADD R2, R2, R2   |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R2, R1, 0x28  |  NOP  |  NOP  |  NOP  |  NOP  }    ;Mem[0x1201_0028] = 0x1111_1110
; IRQ ISR address (IRQISR)

{  LW R3, R1, 0x1C  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R3, R0, 0x14  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0014] = 0x2222_2222
{  LW R3, R1, 0x20  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R3, R0, 0x18  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0018] = 0x4444_4444
{  LW R3, R1, 0x24  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R3, R0, 0x1C  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_001C] = 0x8888_8888
{  LW R3, R1, 0x28  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R3, R0, 0x20  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0020] = 0x1111_1110

;************************************************************** Base address (BAR)
{  MOVI   R1, DMEM_ADDR |  NOP  |  NOP  |  NOP  |  NOP  }

{  LW R3, R1, 0x38  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R3, R0, 0x24  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0024] = 0x1200_0000

;************************************************************** Interleaving (DMCFGI)
{  LW R3, R1, 0x3C  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R3, R0, 0x28  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0028] = 0x0000_0000

;************************************************************** Priority (DMCFGP)
{  LW R3, R1, 0x40  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R3, R0, 0x2C  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_002C] = 0x0000_0000
{  MOVI.L R2, 0x0001  |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R2, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R2, R1, 0x40  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }  ; add by JH
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  } 
{  LW R3, R1, 0x40  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R3, R0, 0x30  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0030] = 0x0000_0001

;************************************************************** Reserved0 (RSV0)
{  MOVI   R1, CORE_ADDR |  NOP  |  NOP  |  NOP  |  NOP  }

{  MOVI.L R2, 0x5A5A  |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R2, 0x5A5A  |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R2, R1, 0x5C  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }  ; add by JH
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  } 
{  LW R3, R1, 0x5C  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R3, R0, 0x34  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0034] = 0x5A5A_5A5A

;************************************************************** Reserved1 (RSV1)
{  MOVI.L R2, 0xA5A5  |  NOP  |  NOP  |  NOP  |  NOP  }
{  MOVI.H R2, 0xA5A5  |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R2, R1, 0x60  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }  ; add by JH
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  } 
{  LW R3, R1, 0x60  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  SW R3, R0, 0x38  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0038] = 0xA5A5_A5A5

;************************************************************** Version (VERSION)
;{  LW R3, R1, 0x58  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  SW R3, R0, 0x3C  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_003C] = 0x0000_0035

;************************************************************** (DBGS)
;{  MOVI.L R2, 0x0004  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  MOVI.H R2, 0x0000  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  SW R2, R1, 0x64  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  LW R3, R1, 0x8  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
;{  SW R3, R0, 0x40  |  NOP  |  NOP  |  NOP  |  NOP  }
;Mem[0x1E00_0040] = 0x0000_0005


;************************************************************** Program Terminates
{  TRAP  |  NOP  |  NOP  |  NOP  |  NOP  }
