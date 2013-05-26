;;fail memory : store in 0x2400_0100 and 0x2400_1100

c0_M1_start_addr = 0x24000000
c1_M1_start_addr = 0x24100000
c2_M1_start_addr = 0x24200000
c3_M1_start_addr = 0x24300000

M2_start_addr = 0x25000000

DDR_start_addr = 0x30000000

M1_bank0  = 0x0
M1_bank1  = 0x1000
M1_bank2  = 0x2000
M1_bank3  = 0x3000
M1_bank4  = 0x4000
M1_bank5  = 0x5000
M1_bank6  = 0x6000
M1_bank7  = 0x7000

M2_bank0  = 0x0
M2_bank1  = 0x4000
M2_bank2  = 0x8000
M2_bank3  = 0xc000
M2_bank4  = 0x10000
M2_bank5  = 0x14000
M2_bank6  = 0x18000
M2_bank7  = 0x1c000
M2_bank8  = 0x20000
M2_bank9  = 0x24000
M2_bank10 = 0x28000
M2_bank11 = 0x2c000
M2_bank12 = 0x30000
M2_bank13 = 0x34000
M2_bank14 = 0x38000
M2_bank15 = 0x3c000

DDR_BANK0  = 0x100
DDR_BANK1  = 0x1100

result_bank       = 0x0
total_ddr0_count  = 0x4
total_ddr1_count  = 0x8
BANK0_status      = 0xc
BANK1_status      = 0x10
BANK2_status      = 0x14
BANK3_status      = 0x18
BANK4_status      = 0x1c
BANK5_status      = 0x20
BANK6_status      = 0x24
BANK7_status      = 0x28
ddr0_status       = 0x2c
ddr1_status       = 0x30
BANK8_status      = 0x34
BANK9_status      = 0x38
BANK10_status      = 0x3C
BANK11_status      = 0x40
BANK12_status      = 0x44
BANK13_status      = 0x48
BANK14_status      = 0x4C
BANK15_status      = 0x50
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  1.initial DDR:0x320_0000~0x320_0024 = 0 (or 0xffff_ffff)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
test_pattern_main:
;;1.1 DDR:0x320_0000~0x320_0024 = 0
{ NOP                  | MOVIU A0,c0_M1_start_addr    | MOVIU D0,0x0        | MOVIU A0,c0_M1_start_addr     | NOP           }
{ NOP                  | DSW D0,D0,A0,0               | NOP                 | NOP                           | NOP           }
{ NOP                  | DSW D0,D0,A0,8               | NOP                 | NOP                           | NOP           }
{ NOP                  | DSW D0,D0,A0,16              | NOP                 | NOP                           | NOP           }
{ NOP                  | DSW D0,D0,A0,24              | NOP                 | NOP                           | NOP           }
{ NOP                  | DSW D0,D0,A0,32              | NOP                 | NOP                           | NOP           }
{ NOP                  | DSW D0,D0,A0,40              | NOP                 | NOP                           | NOP           }
{ NOP                  | SW D0,A0,48                  | NOP                 | NOP                           | NOP           }
{ NOP                  | NOP                          | NOP                 | NOP                           | NOP           }

{ NOP                  | DLW D2,A0,0                  | NOP                 | DLW D2,A0,8                   | NOP           }
{ NOP                  | DLW D4,A0,16                 | NOP                 | DLW D4,A0,24                  | NOP           }
{ NOP                  | DLW D6,A0,32                 | NOP                 | DLW D6,A0,40                  | NOP           }
{ NOP                  | LW D8,A0,48                  | NOP                 | NOP                           | NOP           }
{ NOP                  | SEQIU D1,p1,P3,D2,0          | NOP                 | SEQIU D1,P2,P9,D2,0           | NOP           }
{ NOP                  | SEQIU D1,P1,P4,D3,0          | NOP                 | SEQIU D1,P2,P10,D3,0          | NOP           }
{ NOP                  | SEQIU D1,P1,P5,D4,0          | NOP                 | SEQIU D1,P2,P11,D4,0          | NOP           }
{ NOP                  | SEQIU D1,P1,P6,D5,0          | NOP                 | SEQIU D1,P2,P12,D5,0          | NOP           }
{ NOP                  | SEQIU D1,P1,P7,D6,0          | NOP                 | SEQIU D1,P2,P13,D6,0          | NOP           }
{ NOP                  | SEQIU D1,P1,P8,D7,0          | NOP                 | SEQIU D1,P2,P14,D7,0          | NOP           }
{ NOP                  | SEQIU D1,P1,P15,D8,0         | NOP                 | NOP                           | ORP P9,P9,P10 }
{ NOP                  | NOP                          | ORP P3,P3,P4        | NOP                           | ORP P9,P9,P11 }
{ NOP                  | NOP                          | ORP P3,P3,P5        | NOP                           | ORP P9,P9,P12 }
{ NOP                  | NOP                          | ORP P3,P3,P6        | NOP                           | ORP P9,P9,P13 }
{ NOP                  | NOP                          | ORP P3,P3,P7        | NOP                           | ORP P9,P9,P14 }
{ NOP                  | NOP                          | ORP P3,P3,P8        | NOP                           | NOP           }
{ NOP                  | NOP                          | ORP P3,P3,P9        | NOP                           | NOP           }
{ (P3)B c0_program_end | NOP                          | NOP                 | NOP                           | NOP           }
{ NOP                  | NOP                          | NOP                 | NOP                           | NOP           }
{ NOP                  | NOP                          | NOP                 | NOP                           | NOP           }
{ NOP                  | NOP                          | NOP                 | NOP                           | NOP           }
{ NOP                  | NOP                          | NOP                 | NOP                           | NOP           }
{ NOP                  | NOP                          | NOP                 | NOP                           | NOP           }



;;1.2 DDR:0x320_0000~0x320_0024 = 0xFFFF_FFFF
{ NOP                  | MOVIU A0,c0_M1_start_addr    | MOVIU D0,0xFFFFFFFF | MOVIU A0,c0_M1_start_addr     | NOP }
{ NOP                  | DSW D0,D0,A0,0               | NOP                 | NOP                           | NOP           }
{ NOP                  | DSW D0,D0,A0,8               | NOP                 | NOP                           | NOP           }
{ NOP                  | DSW D0,D0,A0,16              | NOP                 | NOP                           | NOP           }
{ NOP                  | DSW D0,D0,A0,24              | NOP                 | NOP                           | NOP           }
{ NOP                  | DSW D0,D0,A0,32              | NOP                 | NOP                           | NOP           }
{ NOP                  | DSW D0,D0,A0,40              | NOP                 | NOP                           | NOP           }
{ NOP                  | SW D0,A0,48                  | NOP                 | NOP                           | NOP           }
{ NOP                  | NOP                          | NOP                 | NOP                           | NOP           }

{ NOP                  | DLW D2,A0,0                  | NOP                 | DLW D2,A0,8                   | NOP           }
{ NOP                  | DLW D4,A0,16                 | NOP                 | DLW D4,A0,24                  | NOP           }
{ NOP                  | DLW D6,A0,32                 | NOP                 | DLW D6,A0,40                  | NOP           }
{ NOP                  | LW D8,A0,48                  | NOP                 | NOP                           | NOP           }
{ NOP                  | SEQIU D1,p1,P3,D2,0xffffffff | NOP                 | SEQIU D1,P2,P9,D2,0xffffffff  | NOP           }
{ NOP                  | SEQIU D1,P1,P4,D3,0xffffffff | NOP                 | SEQIU D1,P2,P10,D3,0xffffffff | NOP           }
{ NOP                  | SEQIU D1,P1,P5,D4,0xffffffff | NOP                 | SEQIU D1,P2,P11,D4,0xffffffff | NOP           }
{ NOP                  | SEQIU D1,P1,P6,D5,0xffffffff | NOP                 | SEQIU D1,P2,P12,D5,0xffffffff | NOP           }
{ NOP                  | SEQIU D1,P1,P7,D6,0xffffffff | NOP                 | SEQIU D1,P2,P13,D6,0xffffffff | NOP           }
{ NOP                  | SEQIU D1,P1,P8,D7,0xffffffff | NOP                 | SEQIU D1,P2,P14,D7,0xffffffff | NOP           }
{ NOP                  | SEQIU D1,P1,P15,D8,0XFFFFFFFF| NOP                 | NOP                           | ORP P9,P9,P10 }
{ NOP                  | NOP                          | ORP P3,P3,P4        | NOP                           | ORP P9,P9,P11 }
{ NOP                  | NOP                          | ORP P3,P3,P5        | NOP                           | ORP P9,P9,P12 }
{ NOP                  | NOP                          | ORP P3,P3,P6        | NOP                           | ORP P9,P9,P13 }
{ NOP                  | NOP                          | ORP P3,P3,P7        | NOP                           | ORP P9,P9,P14 }
{ NOP                  | NOP                          | ORP P3,P3,P8        | NOP                           | NOP           }
{ NOP                  | NOP                          | ORP P3,P3,P9        | NOP                           | NOP           }
{ (P3)B c0_program_end | NOP                          | NOP                 | NOP                           | NOP           }
{ NOP                  | NOP                          | NOP                 | NOP                           | NOP           }
{ NOP                  | NOP                          | NOP                 | NOP                           | NOP           }
{ NOP                  | NOP                          | NOP                 | NOP                           | NOP           }
{ NOP                  | NOP                          | NOP                 | NOP                           | NOP           }
{ NOP                  | NOP                          | NOP                 | NOP                           | NOP           }


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 2 CHECK M2_BANK
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
INI_M2_SIZE = 32768;65536
{ NOP                  | MOVIU A0,c0_M1_start_addr  | CLR AC6             | NOP | NOP }
{ NOP                  | ADDI A2,A0,DDR_BANK0       | CLR AC7             | NOP | NOP }
{ NOP                  | ADDI A3,A0,DDR_BANK1       | NOP                 | NOP | NOP }
;;INI_M2 = 0                                                                          
{ MOVIU R1,INI_M2_SIZE | MOVIU A1,M2_start_addr     | NOP                 | NOP | NOP }
{ NOP                  | CLR D8                     | NOP                 | NOP | NOP }
{ NOP                  | SW D8,A0,ddr0_status       | NOP                 | NOP | NOP }
{ NOP                  | NOP                        | NOP                 | NOP | NOP }
INI_M2_LOOP1:                                                             
{ NOP                  | MOVIU D0,0x0               | NOP                 | NOP | NOP }
{ NOP                  | SW D0,A1,0                 | NOP                 | NOP | NOP }
{ NOP                  | NOP                        | NOP                 | NOP | NOP }
{ NOP                  | LW D1,A1,0                 | NOP                 | NOP | NOP }
{ NOP                  | NOP                        | NOP                 | NOP | NOP }
{ LBCB R1,INI_M2_LOOP1 | NOP                        | NOP                 | NOP | NOP }
{ NOP                  | SEQIU D2,P1,P2,D1,0        | NOP                 | NOP | NOP }
{ NOP                  | (P2)SW A1,A2,4+            | (P2)ADDI AC6,AC6,1  | NOP | NOP }
{ NOP                  | NOP                        | NOP                 | NOP | NOP }
{ NOP                  | ADDI A1,A1,0x4             | NOP                 | NOP | NOP }
{ NOP                  | NOP                        | NOP                 | NOP | NOP }

{ NOP                  | NOP                        | SEQIU D1,P1,P2,AC6,0| NOP | NOP }
{ NOP                  | (P1)SW D1,A0,ddr0_status   | COPYU D8,AC6        | NOP | NOP }
{ NOP                  | SW D8,A0,total_ddr0_count  | NOP                 | NOP | NOP }
{ NOP                  | NOP                        | NOP                 | NOP | NOP }

;;INI_M2 = 0xFFFF_FFFF                                                                          
{ MOVIU R1,INI_M2_SIZE | MOVIU A1,M2_start_addr      | NOP                 | NOP | NOP }
{ NOP                  | CLR D8                      | NOP                 | NOP | NOP }
{ NOP                  | SW D8,A0,ddr1_status        | NOP                 | NOP | NOP }
{ NOP                  | NOP                         | NOP                 | NOP | NOP }
INI_M2_LOOP2:                                                              
{ NOP                  | MOVIU D0,0xFFFFFFFF         | NOP                 | NOP | NOP }
{ NOP                  | SW D0,A1,0                  | NOP                 | NOP | NOP }
{ NOP                  | NOP                         | NOP                 | NOP | NOP }
{ NOP                  | LW D1,A1,0                  | NOP                 | NOP | NOP }
{ NOP                  | NOP                         | NOP                 | NOP | NOP }
{ LBCB R1,INI_M2_LOOP2 | NOP                         | NOP                 | NOP | NOP }
{ NOP                  | SEQIU D2,P1,P2,D1,0xFFFFFFFF| NOP                 | NOP | NOP }
{ NOP                  | (P2)SW A1,A3,4+             | (P2)ADDI AC6,AC6,1  | NOP | NOP }
{ NOP                  | NOP                         | NOP                 | NOP | NOP }
{ NOP                  | ADDI A1,A1,0x4              | NOP                 | NOP | NOP }
{ NOP                  | NOP                         | NOP                 | NOP | NOP }
                                                     
{ NOP                  | NOP                         | SEQIU D1,P1,P2,AC6,0| NOP | NOP }
{ NOP                  | (P1)SW D1,A0,ddr1_status    | COPYU D8,AC6        | NOP | NOP }
{ NOP                  | SW D8,A0,total_ddr1_count   | NOP                 | NOP | NOP }
{ NOP                  | NOP                         | NOP                 | NOP | NOP }
{ NOP                  | NOP                         | NOP                 | NOP | NOP }

;; CHECK RESULT
{ NOP                  | LW D0,A0,ddr0_status        | NOP                 | NOP | NOP } 
{ NOP                  | LW D1,A0,ddr1_status        | NOP                 | NOP | NOP } 
{ NOP                  | NOP                         | NOP                 | NOP | NOP }
{ NOP                  | NOP                         | NOP                 | NOP | NOP }
{ NOP                  | SEQIU D2,P1,P2,D0,0x1       | NOP                 | NOP | NOP }
{ NOP                  | SEQIU D3,P3,P4,D1,0x1       | NOP                 | NOP | NOP }
{ NOP                  | NOP                         | NOP                 | NOP | NOP }
{ NOP                  | AND D2,D2,D3                | NOP                 | NOP | NOP }
{ NOP                  | SW D2,A0,result_bank        | NOP                 | NOP | NOP }
{ NOP                  | NOP                         | NOP                 | NOP | NOP }
{ NOP                  | NOP                         | NOP                 | NOP | NOP }

c0_program_end:
{ NOP                  | NOP                    | NOP          | NOP | NOP }
{ TRAP                 | NOP                    | NOP          | NOP | NOP }
{ NOP                  | NOP                    | NOP          | NOP | NOP }
{ NOP                  | NOP                    | NOP          | NOP | NOP }

