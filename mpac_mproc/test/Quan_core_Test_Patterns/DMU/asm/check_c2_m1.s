;;fail memory : store in 0x3000_0100 and 0x3000_1100

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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  1.initial DDR:0x320_0000~0x320_0024 = 0 (or 0xffff_ffff)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
test_pattern_main:
;;1.1 DDR:0x320_0000~0x320_0024 = 0
{ NOP                  | MOVIU A0,DDR_start_addr      | MOVIU D0,0x0        | MOVIU A0,DDR_start_addr       | NOP           }
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
{ NOP                  | MOVIU A0,DDR_start_addr      | MOVIU D0,0xFFFFFFFF | MOVIU A0,DDR_start_addr       | NOP }
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
;; 2 CHECK M1_BANK0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

{ NOP | MOVIU A6,DDR_start_addr+DDR_BANK0 | CLR AC7 | NOP | NOP }
{ NOP | MOVIU A7,DDR_start_addr+DDR_BANK1 | CLR AC6 | NOP | NOP }
{ NOP | MOVIU A0,DDR_start_addr           | NOP     | NOP | NOP }
{ NOP | MOVIU A1,c2_M1_start_addr         | NOP     | NOP | NOP }

;;
;;2.1 ini_m1_bank0 = 0
{ NOP | ADDI A3,A0,ddr0_status            | CLR D0 | NOP | NOP }
{ NOP | ADDI A4,A0,ddr1_status            | NOP    | NOP | NOP }
{ NOP | ADDI A5,A0,BANK0_status           | NOP    | NOP | NOP }
{ NOP | SW D0,A3,0                        | NOP    | NOP | NOP }
{ NOP | SW D0,A4,0                        | NOP    | NOP | NOP }
{ NOP | SW D0,A5,0                        | NOP    | NOP | NOP }

ini_m1_size = 1024
{ MOVIU r1,ini_m1_size      | ADDI A2,A1,M1_bank0          | CLR D3             | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }

ini_m1_bank0_loop1:
{ NOP                       | MOVIU D0,0x0                 | NOP                | NOP | NOP }
{ NOP                       | SW D0,A2,0                   | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }
{ NOP                       | LW D0,A2,0                   | NOP                | NOP | NOP }
{ LBCB r1,ini_m1_bank0_loop1| NOP                          | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }
{ NOP                       | SEQIU D1,P1,P2,D0,0          | NOP                | NOP | NOP }
{ NOP                       | (P2)SW A2,A6,4+              | (P2)ADDI AC6,AC6,1 | NOP | NOP }
{ NOP                       | NOP                          | (P2)ADDI D3,D3,1   | NOP | NOP }
{ NOP                       | ADDI A2,A2,4                 | NOP                | NOP | NOP }

{ NOP                       | SW D3,A3,0                   | NOP                | NOP | NOP }

;;
;;2.2 ini_m1_bank0 = 0xffffffff
{ MOVIU r1,ini_m1_size      | ADDI A2,A1,M1_bank0          | CLR D3             | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }

ini_m1_bank0_loop2:
{ NOP                       | MOVIU D0,0xffffffff          | NOP                | NOP | NOP }
{ NOP                       | SW D0,A2,0                   | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }
{ NOP                       | LW D0,A2,0                   | NOP                | NOP | NOP }
{ LBCB r1,ini_m1_bank0_loop2| NOP                          | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }
{ NOP                       | SEQIU D1,P1,P2,D0,0xffffffff | NOP                | NOP | NOP }
{ NOP                       | (P2)SW A2,A7,4+              | (P2)ADDI AC7,AC7,1 | NOP | NOP }
{ NOP                       | NOP                          | (P2)ADDI D3,D3,1   | NOP | NOP }
{ NOP                       | ADDI A2,A2,4                 | NOP                | NOP | NOP }

{ NOP                       | SW D3,A4,0                   | NOP                | NOP | NOP }

;;
;;2.3 check m1_result
{ NOP                       | LW D0,A3,0                   | NOP                | NOP | NOP }
{ NOP                       | LW D1,A4,0                   | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }
{ NOP                       | SEQIU D3,P2,p1,D0,0          | NOP                | NOP | NOP }
{ NOP                       | SEQIU D4,P3,p1,D1,0          | NOP                | NOP | NOP }
{ NOP                       | AND D3,D3,D4                 | NOP                | NOP | NOP }
{ NOP                       | SW D3,A5,0                   | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 3 CHECK M1_BANK1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;3.1 ini_m1_bank1 = 0
{ NOP | ADDI A3,A0,ddr0_status            | CLR D0 | NOP | NOP }
{ NOP | ADDI A4,A0,ddr1_status            | NOP    | NOP | NOP }
{ NOP | ADDI A5,A0,BANK1_status           | NOP    | NOP | NOP }
{ NOP | SW D0,A3,0                        | NOP    | NOP | NOP }
{ NOP | SW D0,A4,0                        | NOP    | NOP | NOP }
{ NOP | SW D0,A5,0                        | NOP    | NOP | NOP }

ini_m1_size = 1024
{ MOVIU r1,ini_m1_size      | ADDI A2,A1,M1_bank1          | CLR D3             | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }

ini_m1_bank1_loop1:
{ NOP                       | MOVIU D0,0x0                 | NOP                | NOP | NOP }
{ NOP                       | SW D0,A2,0                   | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }
{ NOP                       | LW D0,A2,0                   | NOP                | NOP | NOP }
{ LBCB r1,ini_m1_bank1_loop1| NOP                          | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }
{ NOP                       | SEQIU D1,P1,P2,D0,0          | NOP                | NOP | NOP }
{ NOP                       | (P2)SW A2,A6,4+              | (P2)ADDI AC6,AC6,1 | NOP | NOP }
{ NOP                       | NOP                          | (P2)ADDI D3,D3,1   | NOP | NOP }
{ NOP                       | ADDI A2,A2,4                 | NOP                | NOP | NOP }

{ NOP                       | SW D3,A3,0                   | NOP                | NOP | NOP }

;;
;;3.2 ini_m1_bank1 = 0xffffffff
{ MOVIU r1,ini_m1_size      | ADDI A2,A1,M1_bank1          | CLR D3             | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }

ini_m1_bank1_loop2:
{ NOP                       | MOVIU D0,0xffffffff          | NOP                | NOP | NOP }
{ NOP                       | SW D0,A2,0                   | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }
{ NOP                       | LW D0,A2,0                   | NOP                | NOP | NOP }
{ LBCB r1,ini_m1_bank1_loop2| NOP                          | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }
{ NOP                       | SEQIU D1,P1,P2,D0,0xffffffff | NOP                | NOP | NOP }
{ NOP                       | (P2)SW A2,A7,4+              | (P2)ADDI AC7,AC7,1 | NOP | NOP }
{ NOP                       | NOP                          | (P2)ADDI D3,D3,1   | NOP | NOP }
{ NOP                       | ADDI A2,A2,4                 | NOP                | NOP | NOP }

{ NOP                       | SW D3,A4,0                   | NOP                | NOP | NOP }

;;
;;3.3 check m1_result
{ NOP                       | LW D0,A3,0                   | NOP                | NOP | NOP }
{ NOP                       | LW D1,A4,0                   | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }
{ NOP                       | SEQIU D3,P2,p1,D0,0          | NOP                | NOP | NOP }
{ NOP                       | SEQIU D4,P3,p1,D1,0          | NOP                | NOP | NOP }
{ NOP                       | AND D3,D3,D4                 | NOP                | NOP | NOP }
{ NOP                       | SW D3,A5,0                   | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 4 CHECK M1_BANK2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;4.1 ini_m1_bank2 = 0
{ NOP | ADDI A3,A0,ddr0_status            | CLR D0 | NOP | NOP }
{ NOP | ADDI A4,A0,ddr1_status            | NOP    | NOP | NOP }
{ NOP | ADDI A5,A0,BANK2_status           | NOP    | NOP | NOP }
{ NOP | SW D0,A3,0                        | NOP    | NOP | NOP }
{ NOP | SW D0,A4,0                        | NOP    | NOP | NOP }
{ NOP | SW D0,A5,0                        | NOP    | NOP | NOP }

ini_m1_size = 1024
{ MOVIU r1,ini_m1_size      | ADDI A2,A1,M1_bank2          | CLR D3             | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }

ini_m1_bank2_loop1:
{ NOP                       | MOVIU D0,0x0                 | NOP                | NOP | NOP }
{ NOP                       | SW D0,A2,0                   | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }
{ NOP                       | LW D0,A2,0                   | NOP                | NOP | NOP }
{ LBCB r1,ini_m1_bank2_loop1| NOP                          | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }
{ NOP                       | SEQIU D1,P1,P2,D0,0          | NOP                | NOP | NOP }
{ NOP                       | (P2)SW A2,A6,4+              | (P2)ADDI AC6,AC6,1 | NOP | NOP }
{ NOP                       | NOP                          | (P2)ADDI D3,D3,1   | NOP | NOP }
{ NOP                       | ADDI A2,A2,4                 | NOP                | NOP | NOP }

{ NOP                       | SW D3,A3,0                   | NOP                | NOP | NOP }

;;
;;4.2 ini_m1_bank2 = 0xffffffff
{ MOVIU r1,ini_m1_size      | ADDI A2,A1,M1_bank2          | CLR D3             | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }

ini_m1_bank2_loop2:
{ NOP                       | MOVIU D0,0xffffffff          | NOP                | NOP | NOP }
{ NOP                       | SW D0,A2,0                   | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }
{ NOP                       | LW D0,A2,0                   | NOP                | NOP | NOP }
{ LBCB r1,ini_m1_bank2_loop2| NOP                          | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }
{ NOP                       | SEQIU D1,P1,P2,D0,0xffffffff | NOP                | NOP | NOP }
{ NOP                       | (P2)SW A2,A7,4+              | (P2)ADDI AC7,AC7,1 | NOP | NOP }
{ NOP                       | NOP                          | (P2)ADDI D3,D3,1   | NOP | NOP }
{ NOP                       | ADDI A2,A2,4                 | NOP                | NOP | NOP }

{ NOP                       | SW D3,A4,0                   | NOP                | NOP | NOP }

;;
;;4.3 check m1_result
{ NOP                       | LW D0,A3,0                   | NOP                | NOP | NOP }
{ NOP                       | LW D1,A4,0                   | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }
{ NOP                       | SEQIU D3,P2,p1,D0,0          | NOP                | NOP | NOP }
{ NOP                       | SEQIU D4,P3,p1,D1,0          | NOP                | NOP | NOP }
{ NOP                       | AND D3,D3,D4                 | NOP                | NOP | NOP }
{ NOP                       | SW D3,A5,0                   | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 5 CHECK M1_BANK3
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;5.1 ini_m1_bank3 = 0
{ NOP | ADDI A3,A0,ddr0_status            | CLR D0 | NOP | NOP }
{ NOP | ADDI A4,A0,ddr1_status            | NOP    | NOP | NOP }
{ NOP | ADDI A5,A0,BANK3_status           | NOP    | NOP | NOP }
{ NOP | SW D0,A3,0                        | NOP    | NOP | NOP }
{ NOP | SW D0,A4,0                        | NOP    | NOP | NOP }
{ NOP | SW D0,A5,0                        | NOP    | NOP | NOP }

ini_m1_size = 1024
{ MOVIU r1,ini_m1_size      | ADDI A2,A1,M1_bank3          | CLR D3             | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }

ini_m1_bank3_loop1:
{ NOP                       | MOVIU D0,0x0                 | NOP                | NOP | NOP }
{ NOP                       | SW D0,A2,0                   | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }
{ NOP                       | LW D0,A2,0                   | NOP                | NOP | NOP }
{ LBCB r1,ini_m1_bank3_loop1| NOP                          | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }
{ NOP                       | SEQIU D1,P1,P2,D0,0          | NOP                | NOP | NOP }
{ NOP                       | (P2)SW A2,A6,4+              | (P2)ADDI AC6,AC6,1 | NOP | NOP }
{ NOP                       | NOP                          | (P2)ADDI D3,D3,1   | NOP | NOP }
{ NOP                       | ADDI A2,A2,4                 | NOP                | NOP | NOP }

{ NOP                       | SW D3,A3,0                   | NOP                | NOP | NOP }

;;
;;5.2 ini_m1_bank3 = 0xffffffff
{ MOVIU r1,ini_m1_size      | ADDI A2,A1,M1_bank3          | CLR D3             | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }

ini_m1_bank3_loop2:
{ NOP                       | MOVIU D0,0xffffffff          | NOP                | NOP | NOP }
{ NOP                       | SW D0,A2,0                   | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }
{ NOP                       | LW D0,A2,0                   | NOP                | NOP | NOP }
{ LBCB r1,ini_m1_bank3_loop2| NOP                          | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }
{ NOP                       | SEQIU D1,P1,P2,D0,0xffffffff | NOP                | NOP | NOP }
{ NOP                       | (P2)SW A2,A7,4+              | (P2)ADDI AC7,AC7,1 | NOP | NOP }
{ NOP                       | NOP                          | (P2)ADDI D3,D3,1   | NOP | NOP }
{ NOP                       | ADDI A2,A2,4                 | NOP                | NOP | NOP }

{ NOP                       | SW D3,A4,0                   | NOP                | NOP | NOP }

;;
;;5.3 check m1_result
{ NOP                       | LW D0,A3,0                   | NOP                | NOP | NOP }
{ NOP                       | LW D1,A4,0                   | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }
{ NOP                       | SEQIU D3,P2,p1,D0,0          | NOP                | NOP | NOP }
{ NOP                       | SEQIU D4,P3,p1,D1,0          | NOP                | NOP | NOP }
{ NOP                       | AND D3,D3,D4                 | NOP                | NOP | NOP }
{ NOP                       | SW D3,A5,0                   | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 6 CHECK M1_BANK4
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;6.1 ini_m1_bank4 = 0
{ NOP | ADDI A3,A0,ddr0_status            | CLR D0 | NOP | NOP }
{ NOP | ADDI A4,A0,ddr1_status            | NOP    | NOP | NOP }
{ NOP | ADDI A5,A0,BANK4_status           | NOP    | NOP | NOP }
{ NOP | SW D0,A3,0                        | NOP    | NOP | NOP }
{ NOP | SW D0,A4,0                        | NOP    | NOP | NOP }
{ NOP | SW D0,A5,0                        | NOP    | NOP | NOP }

ini_m1_size = 1024
{ MOVIU r1,ini_m1_size      | ADDI A2,A1,M1_bank4          | CLR D3             | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }

ini_m1_bank4_loop1:
{ NOP                       | MOVIU D0,0x0                 | NOP                | NOP | NOP }
{ NOP                       | SW D0,A2,0                   | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }
{ NOP                       | LW D0,A2,0                   | NOP                | NOP | NOP }
{ LBCB r1,ini_m1_bank4_loop1| NOP                          | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }
{ NOP                       | SEQIU D1,P1,P2,D0,0          | NOP                | NOP | NOP }
{ NOP                       | (P2)SW A2,A6,4+              | (P2)ADDI AC6,AC6,1 | NOP | NOP }
{ NOP                       | NOP                          | (P2)ADDI D3,D3,1   | NOP | NOP }
{ NOP                       | ADDI A2,A2,4                 | NOP                | NOP | NOP }

{ NOP                       | SW D3,A3,0                   | NOP                | NOP | NOP }

;;
;;6.2 ini_m1_bank4 = 0xffffffff
{ MOVIU r1,ini_m1_size      | ADDI A2,A1,M1_bank4          | CLR D3             | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }

ini_m1_bank4_loop2:
{ NOP                       | MOVIU D0,0xffffffff          | NOP                | NOP | NOP }
{ NOP                       | SW D0,A2,0                   | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }
{ NOP                       | LW D0,A2,0                   | NOP                | NOP | NOP }
{ LBCB r1,ini_m1_bank4_loop2| NOP                          | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }
{ NOP                       | SEQIU D1,P1,P2,D0,0xffffffff | NOP                | NOP | NOP }
{ NOP                       | (P2)SW A2,A7,4+              | (P2)ADDI AC7,AC7,1 | NOP | NOP }
{ NOP                       | NOP                          | (P2)ADDI D3,D3,1   | NOP | NOP }
{ NOP                       | ADDI A2,A2,4                 | NOP                | NOP | NOP }

{ NOP                       | SW D3,A4,0                   | NOP                | NOP | NOP }

;;
;;6.3 check m1_result
{ NOP                       | LW D0,A3,0                   | NOP                | NOP | NOP }
{ NOP                       | LW D1,A4,0                   | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }
{ NOP                       | SEQIU D3,P2,p1,D0,0          | NOP                | NOP | NOP }
{ NOP                       | SEQIU D4,P3,p1,D1,0          | NOP                | NOP | NOP }
{ NOP                       | AND D3,D3,D4                 | NOP                | NOP | NOP }
{ NOP                       | SW D3,A5,0                   | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 7 CHECK M1_BANK5
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;7.1 ini_m1_bank5 = 0
{ NOP | ADDI A3,A0,ddr0_status            | CLR D0 | NOP | NOP }
{ NOP | ADDI A4,A0,ddr1_status            | NOP    | NOP | NOP }
{ NOP | ADDI A5,A0,BANK5_status           | NOP    | NOP | NOP }
{ NOP | SW D0,A3,0                        | NOP    | NOP | NOP }
{ NOP | SW D0,A4,0                        | NOP    | NOP | NOP }
{ NOP | SW D0,A5,0                        | NOP    | NOP | NOP }

ini_m1_size = 1024
{ MOVIU r1,ini_m1_size      | ADDI A2,A1,M1_bank5          | CLR D3             | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }

ini_m1_bank5_loop1:
{ NOP                       | MOVIU D0,0x0                 | NOP                | NOP | NOP }
{ NOP                       | SW D0,A2,0                   | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }
{ NOP                       | LW D0,A2,0                   | NOP                | NOP | NOP }
{ LBCB r1,ini_m1_bank5_loop1| NOP                          | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }
{ NOP                       | SEQIU D1,P1,P2,D0,0          | NOP                | NOP | NOP }
{ NOP                       | (P2)SW A2,A6,4+              | (P2)ADDI AC6,AC6,1 | NOP | NOP }
{ NOP                       | NOP                          | (P2)ADDI D3,D3,1   | NOP | NOP }
{ NOP                       | ADDI A2,A2,4                 | NOP                | NOP | NOP }

{ NOP                       | SW D3,A3,0                   | NOP                | NOP | NOP }

;;
;;7.2 ini_m1_bank5 = 0xffffffff
{ MOVIU r1,ini_m1_size      | ADDI A2,A1,M1_bank5          | CLR D3             | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }

ini_m1_bank5_loop2:
{ NOP                       | MOVIU D0,0xffffffff          | NOP                | NOP | NOP }
{ NOP                       | SW D0,A2,0                   | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }
{ NOP                       | LW D0,A2,0                   | NOP                | NOP | NOP }
{ LBCB r1,ini_m1_bank5_loop2| NOP                          | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }
{ NOP                       | SEQIU D1,P1,P2,D0,0xffffffff | NOP                | NOP | NOP }
{ NOP                       | (P2)SW A2,A7,4+              | (P2)ADDI AC7,AC7,1 | NOP | NOP }
{ NOP                       | NOP                          | (P2)ADDI D3,D3,1   | NOP | NOP }
{ NOP                       | ADDI A2,A2,4                 | NOP                | NOP | NOP }

{ NOP                       | SW D3,A4,0                   | NOP                | NOP | NOP }

;;
;;7.3 check m1_result
{ NOP                       | LW D0,A3,0                   | NOP                | NOP | NOP }
{ NOP                       | LW D1,A4,0                   | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }
{ NOP                       | SEQIU D3,P2,p1,D0,0          | NOP                | NOP | NOP }
{ NOP                       | SEQIU D4,P3,p1,D1,0          | NOP                | NOP | NOP }
{ NOP                       | AND D3,D3,D4                 | NOP                | NOP | NOP }
{ NOP                       | SW D3,A5,0                   | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 8 CHECK M1_BANK6
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;8.1 ini_m1_bank6 = 0
{ NOP | ADDI A3,A0,ddr0_status            | CLR D0 | NOP | NOP }
{ NOP | ADDI A4,A0,ddr1_status            | NOP    | NOP | NOP }
{ NOP | ADDI A5,A0,BANK6_status           | NOP    | NOP | NOP }
{ NOP | SW D0,A3,0                        | NOP    | NOP | NOP }
{ NOP | SW D0,A4,0                        | NOP    | NOP | NOP }
{ NOP | SW D0,A5,0                        | NOP    | NOP | NOP }

ini_m1_size = 1024
{ MOVIU r1,ini_m1_size      | ADDI A2,A1,M1_bank6          | CLR D3             | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }

ini_m1_bank6_loop1:
{ NOP                       | MOVIU D0,0x0                 | NOP                | NOP | NOP }
{ NOP                       | SW D0,A2,0                   | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }
{ NOP                       | LW D0,A2,0                   | NOP                | NOP | NOP }
{ LBCB r1,ini_m1_bank6_loop1| NOP                          | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }
{ NOP                       | SEQIU D1,P1,P2,D0,0          | NOP                | NOP | NOP }
{ NOP                       | (P2)SW A2,A6,4+              | (P2)ADDI AC6,AC6,1 | NOP | NOP }
{ NOP                       | NOP                          | (P2)ADDI D3,D3,1   | NOP | NOP }
{ NOP                       | ADDI A2,A2,4                 | NOP                | NOP | NOP }

{ NOP                       | SW D3,A3,0                   | NOP                | NOP | NOP }

;;
;;8.2 ini_m1_bank6 = 0xffffffff
{ MOVIU r1,ini_m1_size      | ADDI A2,A1,M1_bank6          | CLR D3             | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }

ini_m1_bank6_loop2:
{ NOP                       | MOVIU D0,0xffffffff          | NOP                | NOP | NOP }
{ NOP                       | SW D0,A2,0                   | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }
{ NOP                       | LW D0,A2,0                   | NOP                | NOP | NOP }
{ LBCB r1,ini_m1_bank6_loop2| NOP                          | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }
{ NOP                       | SEQIU D1,P1,P2,D0,0xffffffff | NOP                | NOP | NOP }
{ NOP                       | (P2)SW A2,A7,4+              | (P2)ADDI AC7,AC7,1 | NOP | NOP }
{ NOP                       | NOP                          | (P2)ADDI D3,D3,1   | NOP | NOP }
{ NOP                       | ADDI A2,A2,4                 | NOP                | NOP | NOP }

{ NOP                       | SW D3,A4,0                   | NOP                | NOP | NOP }

;;
;;8.3 check m1_result
{ NOP                       | LW D0,A3,0                   | NOP                | NOP | NOP }
{ NOP                       | LW D1,A4,0                   | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }
{ NOP                       | SEQIU D3,P2,p1,D0,0          | NOP                | NOP | NOP }
{ NOP                       | SEQIU D4,P3,p1,D1,0          | NOP                | NOP | NOP }
{ NOP                       | AND D3,D3,D4                 | NOP                | NOP | NOP }
{ NOP                       | SW D3,A5,0                   | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 9 CHECK M1_BANK7
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;9.1 ini_m1_bank7 = 0
{ NOP | ADDI A3,A0,ddr0_status            | CLR D0 | NOP | NOP }
{ NOP | ADDI A4,A0,ddr1_status            | NOP    | NOP | NOP }
{ NOP | ADDI A5,A0,BANK7_status           | NOP    | NOP | NOP }
{ NOP | SW D0,A3,0                        | NOP    | NOP | NOP }
{ NOP | SW D0,A4,0                        | NOP    | NOP | NOP }
{ NOP | SW D0,A5,0                        | NOP    | NOP | NOP }

ini_m1_size = 1024
{ MOVIU r1,ini_m1_size      | ADDI A2,A1,M1_bank7          | CLR D3             | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }

ini_m1_bank7_loop1:
{ NOP                       | MOVIU D0,0x0                 | NOP                | NOP | NOP }
{ NOP                       | SW D0,A2,0                   | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }
{ NOP                       | LW D0,A2,0                   | NOP                | NOP | NOP }
{ LBCB r1,ini_m1_bank7_loop1| NOP                          | NOP                | NOP | NOP }
{ SEQIU r2,P3,P4,r1,0       | NOP                          | NOP                | NOP | NOP }
{ NOP                       | SEQIU D1,P1,P2,D0,0          | NOP                | NOP | NOP }
{ NOP                       | (P2)SW A2,A6,4+              | (P2)ADDI AC6,AC6,1 | NOP | NOP }
{ NOP                       | NOP                          | (P2)ADDI D3,D3,1   | NOP | NOP }
{ NOP                       | (P4)ADDI A2,A2,4             | NOP                | NOP | NOP }


{ NOP                       | SW D3,A3,0                   | NOP                | NOP | NOP }

;;
;;9.2 ini_m1_bank7 = 0xffffffff
{ MOVIU r1,ini_m1_size      | ADDI A2,A1,M1_bank7          | CLR D3             | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }

ini_m1_bank7_loop2:
{ NOP                       | MOVIU D0,0xffffffff          | NOP                | NOP | NOP }
{ NOP                       | SW D0,A2,0                   | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }
{ NOP                       | LW D0,A2,0                   | NOP                | NOP | NOP }
{ LBCB r1,ini_m1_bank7_loop2| NOP                          | NOP                | NOP | NOP }
{ SEQIU r2,P3,P4,r1,0       | NOP                          | NOP                | NOP | NOP }
{ NOP                       | SEQIU D1,P1,P2,D0,0xffffffff | NOP                | NOP | NOP }
{ NOP                       | (P2)SW A2,A7,4+              | (P2)ADDI AC7,AC7,1 | NOP | NOP }
{ NOP                       | NOP                          | (P2)ADDI D3,D3,1   | NOP | NOP }
{ NOP                       | (P4)ADDI A2,A2,4             | NOP                | NOP | NOP }

{ NOP                       | SW D3,A4,0                   | NOP                | NOP | NOP }

;;
;;9.3 check m1_result
{ NOP                       | LW D0,A3,0                   | NOP                | NOP | NOP }
{ NOP                       | LW D1,A4,0                   | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }
{ NOP                       | SEQIU D3,P2,p1,D0,0          | NOP                | NOP | NOP }
{ NOP                       | SEQIU D4,P3,p1,D1,0          | NOP                | NOP | NOP }
{ NOP                       | AND D3,D3,D4                 | NOP                | NOP | NOP }
{ NOP                       | SW D3,A5,0                   | NOP                | NOP | NOP }
{ NOP                       | NOP                          | NOP                | NOP | NOP }

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 10 CHECK M1_memory
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
{ NOP | CLR D8                     | NOP           | NOP           | NOP }
{ NOP | SW D8,A0,result_bank       | NOP           | NOP           | NOP }
{ NOP | LW D0,a0,BANK0_status      | NOP           | NOP           | NOP }
{ NOP | LW D1,a0,BANK1_status      | NOP           | NOP           | NOP }
{ NOP | LW D2,a0,BANK2_status      | NOP           | NOP           | NOP }
{ NOP | LW D3,a0,BANK3_status      | NOP           | NOP           | NOP }
{ NOP | LW D4,a0,BANK4_status      | NOP           | NOP           | NOP }
{ NOP | LW D5,a0,BANK5_status      | NOP           | NOP           | NOP }
{ NOP | LW D6,a0,BANK6_status      | NOP           | NOP           | NOP }
{ NOP | LW D7,a0,BANK7_status      | NOP           | NOP           | NOP }

{ NOP | SEQIU D8,P2,P1,D0,0x1      | NOP           | NOP           | NOP }
{ NOP | SEQIU D8,P3,P1,D1,0x1      | NOP           | NOP           | NOP }
{ NOP | SEQIU D8,P4,P1,D2,0x1      | NOP           | ANDP P2,P2,P3 | NOP }
{ NOP | SEQIU D8,P5,P1,D3,0x1      | NOP           | ANDP P2,P2,P4 | NOP }
{ NOP | SEQIU D8,P6,P1,D4,0x1      | NOP           | ANDP P2,P2,P5 | NOP }
{ NOP | SEQIU D8,P7,P1,D5,0x1      | NOP           | ANDP P2,P2,P6 | NOP }
{ NOP | SEQIU D8,P8,P1,D6,0x1      | NOP           | ANDP P2,P2,P7 | NOP }
{ NOP | SEQIU D8,P9,P1,D7,0x1      | NOP           | ANDP P2,P2,P8 | NOP }
{ NOP | MOVIU D0,1                 | COPYU D10,AC6 | ANDP P2,P2,P9 | NOP }
{ NOP | (P2)SW D0,A0,result_bank   | COPYU D11,AC7 | NOP           | NOP }
{ NOP | SW D10,A0,total_ddr0_count | NOP           | NOP           | NOP }

{ NOP | SW D11,A0,total_ddr1_count | NOP           | NOP           | NOP }
{ NOP | NOP                        | NOP           | NOP           | NOP }



c0_program_end:
{ NOP                  | NOP                    | NOP          | NOP | NOP }
{ TRAP                 | NOP                    | NOP          | NOP | NOP }
{ NOP                  | NOP                    | NOP          | NOP | NOP }
{ NOP                  | NOP                    | NOP          | NOP | NOP }
