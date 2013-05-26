;;---------------------- To Verify ---------------------------
;;DSP2 semaphore registers seeting and flush
;;------------------------------------------------------------

;;Semaphore base address and registers
 PACDSP_SEMAPHORE_BASE 	= 0x25830000
 SMP_CTRL 							= PACDSP_SEMAPHORE_BASE + 0x0000
 SMP_REQ 								= PACDSP_SEMAPHORE_BASE + 0x0002
 SMP_VALID 							= PACDSP_SEMAPHORE_BASE + 0x0004
 SMP_RELEASE 						= PACDSP_SEMAPHORE_BASE + 0x0006
 SMP_TIMEOUT_VALUE 			= PACDSP_SEMAPHORE_BASE + 0x0008
 SMP_ERROR 							= PACDSP_SEMAPHORE_BASE + 0x000C
 
 SMP_force_lock					= 0x0001
 SMP_flush 							= 0x0004
 SMP_request						= 0x0001
 SMP_Valid_OK						= 0x0001
 SMP_Valid_FAIL					= 0x0000
 SMP_release 						= 0x0001
 
PACDSP_M1_BASE					= 0x24000000 
PACDSP_M2_BASE					= 0x25000000 
SMP_DSP2_DUMP 					= PACDSP_M2_BASE + 0x100  

C2_DELAY:
{ MOVI R1, 0x10    | NOP | NOP | NOP | NOP }
C2_DELAY_LOOP:
{ LBCB R1, C2_DELAY_LOOP  | NOP                 | NOP                 | NOP | NOP } 
{ NOP               | NOP                 | NOP                 | NOP | NOP } 
{ NOP               | NOP                 | NOP                 | NOP | NOP } 
{ NOP               | NOP                 | NOP                 | NOP | NOP } 
{ NOP               | NOP                 | NOP                 | NOP | NOP } 
{ NOP               | NOP                 | NOP                 | NOP | NOP } 




SMP_CORE2_WAIT_FLAG:
{ NOP	| MOVI A0, PACDSP_M2_BASE | NOP | NOP | NOP } 
{ NOP | LW D8, A0, 0x1000 | NOP | NOP | NOP } 
{ NOP | NOP | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ NOP | SEQI D9, P1, P2, D8, 0x12345678 | NOP | NOP | NOP }
{ (P2)B SMP_CORE2_WAIT_FLAG | (P1)SW D8, A0, 0x1004 | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }

;;(4) DSP 2 flush all SMP register
{ NOP	| MOVI A0, SMP_CTRL | MOVI D1, SMP_flush | NOP | NOP } 
{ NOP | SH D1, A0, 0x00 | NOP | NOP | NOP } ;enable hard protection
{ NOP | SH D1, A0, 0x10 | NOP | NOP | NOP } ;enable hard protection
{ NOP | SH D1, A0, 0x20 | NOP | NOP | NOP } ;enable hard protection
{ NOP | SH D1, A0, 0x30 | NOP | NOP | NOP } ;enable hard protection
{ NOP | SH D1, A0, 0x40 | NOP | NOP | NOP } ;enable hard protection
{ NOP | SH D1, A0, 0x50 | NOP | NOP | NOP } ;enable hard protection
{ NOP | SH D1, A0, 0x60 | NOP | NOP | NOP } ;enable hard protection
{ NOP | SH D1, A0, 0x70 | NOP | NOP | NOP } ;enable hard protection

;;(5) Dump SMP registers to PACDSP_M2_BASE + 0x100
{ NOP	| MOVI A2, SMP_DSP2_DUMP | NOP | NOP | NOP } 
{ NOP	| MOVI A0, SMP_CTRL | NOP | NOP | NOP } 

{ MOVI R1, 8    | NOP | NOP | NOP | NOP }
SMP_DSP2_DUMP_LOOP:
{ NOP | LH  D8, A0, 0x00 | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ NOP | SW D8, A2, 4+ | NOP | NOP | NOP }
{ NOP | LH  D8, A0, 0x02 | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ NOP | SW D8, A2, 4+ | NOP | NOP | NOP }
{ NOP | LH  D8, A0, 0x04 | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ NOP | SW D8, A2, 4+ | NOP | NOP | NOP }
{ NOP | LH  D8, A0, 0x06 | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ NOP | SW D8, A2, 4+ | NOP | NOP | NOP }
{ NOP | LW  D8, A0, 0x08 | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ NOP | SW D8, A2, 4+ | NOP | NOP | NOP }
{ NOP | LW  D8, A0, 0x0C | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ NOP | SW D8, A2, 4+ | NOP | NOP | NOP }

{ LBCB R1, SMP_DSP2_DUMP_LOOP  | ADDI A0,A0,0x10                 | NOP                 | NOP | NOP } 
{ NOP               | NOP                 | NOP                 | NOP | NOP } 
{ NOP               | NOP                 | NOP                 | NOP | NOP } 
{ NOP               | NOP                 | NOP                 | NOP | NOP } 
{ NOP               | NOP                 | NOP                 | NOP | NOP } 
{ NOP               | NOP                 | NOP                 | NOP | NOP } 







RELEASE_ALL:
{ NOP	| MOVI A0, SMP_CTRL | MOVI D0, SMP_release | NOP | NOP } 
{ NOP | SH D0, A0, 0x76 | NOP | NOP | NOP } ;RELEASE SEMAPHORE7
{ NOP | SH D0, A0, 0x66 | NOP | NOP | NOP } ;RELEASE SEMAPHORE6
{ NOP | SH D0, A0, 0x56 | NOP | NOP | NOP } ;RELEASE SEMAPHORE5
{ NOP | SH D0, A0, 0x46 | NOP | NOP | NOP } ;RELEASE SEMAPHORE4
{ NOP | SH D0, A0, 0x36 | NOP | NOP | NOP } ;RELEASE SEMAPHORE3
{ NOP | SH D0, A0, 0x26 | NOP | NOP | NOP } ;RELEASE SEMAPHORE2
{ NOP | SH D0, A0, 0x16 | NOP | NOP | NOP } ;RELEASE SEMAPHORE1
{ NOP | SH D0, A0, 0x06 | NOP | NOP | NOP } ;RELEASE SEMAPHORE0

{ NOP | NOP | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }


SMP_DSP2_END:
{ TRAP                             | NOP | NOP | NOP | NOP }
 