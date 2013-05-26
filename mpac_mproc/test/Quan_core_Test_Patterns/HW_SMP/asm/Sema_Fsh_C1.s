;;---------------------- To Verify ---------------------------
;;DSP1 semaphore registers seeting and flush
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
 
 
 SMP_CORE1_DONE					= 0x12345678

PACDSP_M1_BASE					= 0x24000000 
PACDSP_M2_BASE					= 0x25000000 

SMP_CORE1_CLEAR_FLAG:
{ NOP	| MOVI A0, PACDSP_M2_BASE | MOVI D1, 0 | NOP | NOP } 
{ NOP | SW D1, A0, 0x1000 | NOP | NOP | NOP } 




{ NOP | MOVI A2, PACDSP_M2_BASE |  NOP  |  NOP  |  NOP  } ;M2 LDM Core0 Base = 0x0900_0000 (A2)


;; (1) hard protect all 8 SMP
{ NOP	| MOVI A0, SMP_CTRL | MOVI D1, SMP_force_lock | NOP | NOP } 
{ NOP | SH D1, A0, 0x00 | NOP | NOP | NOP } ;enable hard protection
{ NOP | SH D1, A0, 0x10 | NOP | NOP | NOP } ;enable hard protection
{ NOP | SH D1, A0, 0x20 | NOP | NOP | NOP } ;enable hard protection
{ NOP | SH D1, A0, 0x30 | NOP | NOP | NOP } ;enable hard protection
{ NOP | SH D1, A0, 0x40 | NOP | NOP | NOP } ;enable hard protection
{ NOP | SH D1, A0, 0x50 | NOP | NOP | NOP } ;enable hard protection
{ NOP | SH D1, A0, 0x60 | NOP | NOP | NOP } ;enable hard protection
{ NOP | SH D1, A0, 0x70 | NOP | NOP | NOP } ;enable hard protection

;;(2) request all 8 SMP by DSP1
{ NOP	| MOVI A0, SMP_CTRL | MOVI D0, SMP_request | NOP | NOP } 
WAIT0_SMP:
{ NOP | SH D0, A0, 0x02 | NOP | NOP | NOP } ;REQ SEMAPHORE0
{ NOP | LH  D8, A0, 0x04 | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ NOP | SEQI D9, P1, P2, D8, 0x1 | NOP | NOP | NOP }
{ (P2)B WAIT0_SMP | (P1)SW D8, A2, 0x0 | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }

WAIT1_SMP:
{ NOP | SH D0, A0, 0x12 | NOP | NOP | NOP } ;REQ SEMAPHORE1
{ NOP | LH  D8, A0, 0x14 | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ NOP | SEQI D9, P1, P2, D8, 0x1 | NOP | NOP | NOP }
{ (P2)B WAIT1_SMP | (P1)SW D8, A2, 0x10 | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }

WAIT2_SMP:
{ NOP | SH D0, A0, 0x22 | NOP | NOP | NOP } ;REQ SEMAPHORE2
{ NOP | LH  D8, A0, 0x24 | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ NOP | SEQI D9, P1, P2, D8, 0x1 | NOP | NOP | NOP }
{ (P2)B WAIT2_SMP | (P1)SW D8, A2, 0x20 | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }

WAIT3_SMP:
{ NOP | SH D0, A0, 0x32 | NOP | NOP | NOP } ;REQ SEMAPHORE3
{ NOP | LH  D8, A0, 0x34 | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ NOP | SEQI D9, P1, P2, D8, 0x1 | NOP | NOP | NOP }
{ (P2)B WAIT3_SMP | (P1)SW D8, A2, 0x30 | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }

WAIT4_SMP:
{ NOP | SH D0, A0, 0x42 | NOP | NOP | NOP } ;REQ SEMAPHORE4
{ NOP | LH  D8, A0, 0x44 | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ NOP | SEQI D9, P1, P2, D8, 0x1 | NOP | NOP | NOP }
{ (P2)B WAIT4_SMP | (P1)SW D8, A2, 0x40 | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }

WAIT5_SMP:
{ NOP | SH D0, A0, 0x52 | NOP | NOP | NOP } ;REQ SEMAPHORE5
{ NOP | LH  D8, A0, 0x54 | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ NOP | SEQI D9, P1, P2, D8, 0x1 | NOP | NOP | NOP }
{ (P2)B WAIT5_SMP | (P1)SW D8, A2, 0x50 | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }

WAIT6_SMP:
{ NOP | SH D0, A0, 0x62 | NOP | NOP | NOP } ;REQ SEMAPHORE6
{ NOP | LH  D8, A0, 0x64 | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ NOP | SEQI D9, P1, P2, D8, 0x1 | NOP | NOP | NOP }
{ (P2)B WAIT6_SMP | (P1)SW D8, A2, 0x60 | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }

WAIT7_SMP:
{ NOP | SH D0, A0, 0x72 | NOP | NOP | NOP } ;REQ SEMAPHORE7
{ NOP | LH  D8, A0, 0x74 | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ NOP | SEQI D9, P1, P2, D8, 0x1 | NOP | NOP | NOP }
{ (P2)B WAIT7_SMP | (P1)SW D8, A2, 0x70 | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }


SMP_CORE1_WRITE_FLAG:
{ NOP	| MOVI A0, PACDSP_M2_BASE | MOVI D1, SMP_CORE1_DONE | NOP | NOP } 
{ NOP | SW D1, A0, 0x1000 | NOP | NOP | NOP } 



;;SMP_DSP1_MAIN:
;;{ MOVI R0, 0x400    | NOP | NOP | NOP | NOP }
;;SMP_REQ_DSP1_LOOP:
;;{ NOP							   | MOVI A0, SMP_CTRL | MOVI D0, SMP_force_lock | NOP | NOP }
;;{ NOP               | SH D0, A0, 0       | NOP                 | NOP | NOP }
;;{ NOP						    | MOVI A0, SMP_REQ	 | MOVI D0, SMP_request | NOP | NOP }
;;{ NOP               | SH D0, A0, 0       | NOP                 | NOP | NOP }
;;{ NOP						    | MOVI A0, SMP_VALID | NOP 									| NOP | NOP }
;;{ NOP               | LH D1, A0, 0       | NOP                 | NOP | NOP }
;;{ NOP   | SEQI D15,P1,P2,D1,SMP_Valid_OK | NOP 								| NOP |  NOP}
;;{ (P2)B R15, SMP_REQUEST_FAIL_DELAY  | NOP 	| NOP							 | NOP | NOP }
;;{ (P1)B R15, SMP_REQUEST_OK_TASK  | NOP | NOP 								| NOP | NOP }
;;{ NOP               | NOP                 | NOP                 | NOP | NOP } 
;;{ NOP               | NOP                 | NOP                 | NOP | NOP } 
;;{ NOP               | NOP                 | NOP                 | NOP | NOP } 
;;{ NOP               | NOP                 | NOP                 | NOP | NOP } 
;;{ NOP               | NOP                 | NOP                 | NOP | NOP } 
;;
;;{ NOP               | NOP                 | NOP                 | NOP | NOP } 
;;{ NOP               | NOP                 | NOP                 | NOP | NOP } 
;;{ LBCB R0, SMP_REQ_DSP1_LOOP  | NOP                 | NOP                 | NOP | NOP } 
;;{ NOP               | NOP                 | NOP                 | NOP | NOP } 
;;{ NOP               | NOP                 | NOP                 | NOP | NOP } 
;;{ NOP               | NOP                 | NOP                 | NOP | NOP } 
;;{ NOP               | NOP                 | NOP                 | NOP | NOP } 
;;{ NOP               | NOP                 | NOP                 | NOP | NOP } 
;;
;;{ B SMP_DSP1_END  | NOP 	| NOP							 | NOP | NOP }
;;{ NOP               | NOP                 | NOP                 | NOP | NOP } 
;;{ NOP               | NOP                 | NOP                 | NOP | NOP } 
;;{ NOP               | NOP                 | NOP                 | NOP | NOP } 
;;{ NOP               | NOP                 | NOP                 | NOP | NOP } 
;;{ NOP               | NOP                 | NOP                 | NOP | NOP } 
;;
;;
;;SMP_REQUEST_FAIL_DELAY:
;;{ MOVI R1, 0x100    | NOP | NOP | NOP | NOP }
;;SMP_REQUEST_FAIL_DELAY_LOOP:
;;{ LBCB R1, SMP_REQUEST_FAIL_DELAY_LOOP  | NOP                 | NOP                 | NOP | NOP } 
;;{ NOP               | NOP                 | NOP                 | NOP | NOP } 
;;{ NOP               | NOP                 | NOP                 | NOP | NOP } 
;;{ NOP               | NOP                 | NOP                 | NOP | NOP } 
;;{ NOP               | NOP                 | NOP                 | NOP | NOP } 
;;{ NOP               | NOP                 | NOP                 | NOP | NOP } 
;;{ BR R15              | NOP                 | NOP                 | NOP | NOP } 
;;{ NOP               | NOP                 | NOP                 | NOP | NOP } 
;;{ NOP               | NOP                 | NOP                 | NOP | NOP } 
;;{ NOP               | NOP                 | NOP                 | NOP | NOP } 
;;{ NOP               | NOP                 | NOP                 | NOP | NOP } 
;;{ NOP               | NOP                 | NOP                 | NOP | NOP } 
;;
;;
;;
;;
;;SMP_REQUEST_OK_TASK:
;;
;;for .tic file
;;{
;;read SMP register and write to DDR
;;incremental a number write to DDR
;;}
;;
;;
;;
;;{ NOP						    | MOVI A0, SMP_RELEASE	 | MOVI D0, SMP_release | NOP | NOP }
;;{ NOP               | SH D0, A0, 0       | NOP                 | NOP | NOP }
;;{BR R15               | NOP                 | NOP                 | NOP | NOP } 
;;{ NOP               | NOP                 | NOP                 | NOP | NOP } 
;;{ NOP               | NOP                 | NOP                 | NOP | NOP } 
;;{ NOP               | NOP                 | NOP                 | NOP | NOP } 
;;{ NOP               | NOP                 | NOP                 | NOP | NOP } 
;;{ NOP               | NOP                 | NOP                 | NOP | NOP } 



DELAY:
{ MOVI R1, 0x800    | NOP | NOP | NOP | NOP }
DELAY_LOOP:
{ LBCB R1, DELAY_LOOP  | NOP                 | NOP                 | NOP | NOP } 
{ NOP               | NOP                 | NOP                 | NOP | NOP } 
{ NOP               | NOP                 | NOP                 | NOP | NOP } 
{ NOP               | NOP                 | NOP                 | NOP | NOP } 
{ NOP               | NOP                 | NOP                 | NOP | NOP } 
{ NOP               | NOP                 | NOP                 | NOP | NOP } 





SMP_DSP1_END:
{ TRAP                             | NOP | NOP | NOP | NOP }
 