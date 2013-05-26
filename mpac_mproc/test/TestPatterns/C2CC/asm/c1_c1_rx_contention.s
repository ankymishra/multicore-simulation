
.set C2CC_BASE,         0x25841000
.set LMEM_BASE,         0x24100000
.set BACKUP_POINTER,    0x24100010
.set BACKUP_POINTER_C1, 0x24100080
.set START_DATA,        0xBBBB0fff
;;; =====================================================
.set TX_SEND_TRIG_OFFSET,	     0x00
.set TX_STAT_OFFSET,           0x04
.set TX_CTRL_OFFSET,           0x08
.set TX_TIMEOUT_OFFSET,        0x0C
.set TX_MSG_0_OFFSET,          0x10
.set TX_MSG_1_OFFSET,          0x14
.set TX_MSG_2_OFFSET,	         0x18
.set TX_MSG_3_OFFSET,	         0x1C
.set TX_CANCEL_OFFSET,         0x20
.set TX_MNTR_DEST_ID_OFFSET,   0x24
.set TX_MNTR_DEST_STAT_OFFSET, 0x28
.set TX_RESER_OFFSET,	         0x2C

;;; =====================================================
.set RX_STAT_OFFSET,	         0x40
.set RX_SOUR_ID_OFFSET,	       0x44
.set RX_MSG_0_OFFSET,	         0x48
.set RX_MSG_1_OFFSET,	         0x4C
.set RX_MSG_2_OFFSET,	         0x50
.set RX_MSG_3_OFFSET,	         0x54
.set RX_ACCEPT_OFFSET,	       0x58
.set RX_INT_CLR_OFFSET,	       0x5C
.set RX_INT_EN_OFFSET,	       0x60
.set RX_RESER_OFFSET,	         0x64

;;; =====================================================
.set TX_CTRL,           0x00010000
.set TX_TIMEOUT,        0x00000000
.set TX_MSG_0,          0x25840001
.set TX_MSG_1,          0x25840002
.set TX_MSG_2,	        0x25840003
.set TX_MSG_3,	        0x25840004
.set TX_CANCEL,         0x00000000
.set TX_MNTR_DEST_ID,   0x00000001
.set TX_RESER,	        0x12345678

;;; =====================================================
.set RX_ACCEPT,	        0x00000001
.set RX_INT_CLR,	      0x00000001
.set RX_INT_EN,	        0x00000001
.set RX_RESERT,	        0x87654321

{	CLR R0 |	NOP	|	NOP	|	NOP	|	NOP	}
{	CLR R1 |	NOP	|	NOP	|	NOP	|	NOP	}
{	CLR R2 |	NOP	|	NOP	|	NOP	|	NOP	}
{	CLR R3 |	NOP	|	NOP	|	NOP	|	NOP	}
{	CLR R4 |	NOP	|	NOP	|	NOP	|	NOP	}
{	CLR R5 |	NOP	|	NOP	|	NOP	|	NOP	}

{	CLR R9 |	NOP	|	NOP	|	NOP	|	NOP	} ;;; tx loop counter

;;; =====================================================
;;; Initial 
;;; [LMEM+0x0] = BACKUP_POINTER    (from core 0)
;;; [LMEM+0x4] = START_DATA
;;; [LMEM+0x8] = BACKUP_POINTER_C1 (from core 1)
;;; [LMEM+0xC] = BACKUP_COUNT
;;; =====================================================
{	MOVIU R3,LMEM_BASE         |	NOP	|	NOP	|	NOP	|	NOP	}
{	MOVIU R1,BACKUP_POINTER    |	NOP	|	NOP	|	NOP	|	NOP	}
{	SW R1,R3,0x00              |	NOP	|	NOP	|	NOP	|	NOP	}
{	NOP                        |	NOP	|	NOP	|	NOP	|	NOP	}
{	NOP                        |	NOP	|	NOP	|	NOP	|	NOP	}
{	MOVIU R1,START_DATA        |	NOP	|	NOP	|	NOP	|	NOP	}
{	SW R1,R3,0x04              |	NOP	|	NOP	|	NOP	|	NOP	}
{	NOP                        |	NOP	|	NOP	|	NOP	|	NOP	}
{	NOP                        |	NOP	|	NOP	|	NOP	|	NOP	}
{	MOVIU R1,BACKUP_POINTER_C1 |	NOP	|	NOP	|	NOP	|	NOP	}
{	SW R1,R3,0x08              |	NOP	|	NOP	|	NOP	|	NOP	}
{	NOP                        |	NOP	|	NOP	|	NOP	|	NOP	}
{	NOP                        |	NOP	|	NOP	|	NOP	|	NOP	}
{	MOVIU R1,0x00              |	NOP	|	NOP	|	NOP	|	NOP	}
{	SW R1,R3,0x0C              |	NOP	|	NOP	|	NOP	|	NOP	}
{	NOP                        |	NOP	|	NOP	|	NOP	|	NOP	}
{	NOP                        |	NOP	|	NOP	|	NOP	|	NOP	}

;;; =====================================================
;;; Initial
;;; [C2CC_BASE+TX_CTRL_OFFSET] = TX_CTRL
;;; [C2CC_BASE+TX_TIMEOUT_OFFSET] = TX_TIMEOUT
;;; =====================================================
{	MOVIU R0,C2CC_BASE         |	NOP	|	NOP	|	NOP	|	NOP	}
{	MOVIU R1,TX_CTRL           |	NOP	|	NOP	|	NOP	|	NOP	}
{	SW R1,R0,TX_CTRL_OFFSET    |	NOP	|	NOP	|	NOP	|	NOP	}
{	NOP                        |	NOP	|	NOP	|	NOP	|	NOP	}
{	NOP                        |	NOP	|	NOP	|	NOP	|	NOP	}
{	MOVIU R1,TX_TIMEOUT        |	NOP	|	NOP	|	NOP	|	NOP	}
{	SW R1,R0,TX_TIMEOUT_OFFSET |	NOP	|	NOP	|	NOP	|	NOP	}
{	NOP                        |	NOP	|	NOP	|	NOP	|	NOP	}
{	NOP                        |	NOP	|	NOP	|	NOP	|	NOP	}

;;; r6=0
;;; r5=r5+1
;;; if (r5>8) goto LEVEL_TRAP
;;; r6=r5&0x01
;;; if (r6=0) goto LEVEL_CHECK_RX 
;;; else goto LEVEL_CHECK_TX

LEVEL_MAIN:
;;; =====================================================
{	MOVIU R3,LMEM_BASE         |	NOP	|	NOP	|	NOP	|	NOP	}
{	NOP                       | NOP | NOP | NOP | NOP }
{	NOP                       | NOP | NOP | NOP | NOP }
{	NOP                       | NOP | NOP | NOP | NOP }
{	CLR R6                    | NOP | NOP | NOP | NOP }
{	LW R5,R3,0x0C             | NOP | NOP | NOP | NOP }
{	NOP                       | NOP | NOP | NOP | NOP }
{	NOP                       | NOP | NOP | NOP | NOP }
{	SGTI R8,P1,P2,R5,0x7      | NOP | NOP | NOP | NOP }
{	(P1)B LEVEL_TRAP          | NOP | NOP | NOP | NOP }
{	NOP                       | NOP | NOP | NOP | NOP }
{	NOP                       | NOP | NOP | NOP | NOP }
{	NOP                       | NOP | NOP | NOP | NOP }
{	NOP                       | NOP | NOP | NOP | NOP }
{	NOP                       | NOP | NOP | NOP | NOP }
{	ANDI R6,R5,0x01           | NOP | NOP | NOP | NOP }
{	SEQI R8,P1,P2,R6,0x00     | NOP | NOP | NOP | NOP }
{	(P1)B LEVEL_CHECK_RX      | NOP | NOP | NOP | NOP }
{	(P2)B LEVEL_CHECK_TX      | NOP | NOP | NOP | NOP }
{	NOP                       | NOP | NOP | NOP | NOP }
{	NOP                       | NOP | NOP | NOP | NOP }
{	NOP                       | NOP | NOP | NOP | NOP }
{	NOP                       | NOP | NOP | NOP | NOP }
{	NOP                       | NOP | NOP | NOP | NOP }
{	NOP                       | NOP | NOP | NOP | NOP }

LEVEL_CHECK_RX:
;;; =====================================================
;;; check rx status 
;;; =====================================================
{	MOVIU R0,C2CC_BASE      |	NOP	|	NOP	|	NOP	|	NOP	}
LEVEL_CHK_RX_STAT:
{	LW R1,R0,RX_STAT_OFFSET | NOP | NOP | NOP | NOP }
{	NOP                     | NOP | NOP | NOP | NOP }
{	NOP                     | NOP | NOP | NOP | NOP }
{ SEQI R8,P1,P2,R1,0x02   | NOP | NOP | NOP | NOP }
{	(P2)B LEVEL_CHK_RX_STAT | NOP | NOP | NOP | NOP }
{	NOP                     | NOP | NOP | NOP | NOP }
{	NOP                     | NOP | NOP | NOP | NOP }
{	NOP                     | NOP | NOP | NOP | NOP }
{	NOP                     | NOP | NOP | NOP | NOP }
{	NOP                     | NOP | NOP | NOP | NOP }

;;; =====================================================
;;; backup rx msg to local memory
;;; =====================================================
;;; R0, C2CC_BASE
;;; R1, Tmp_Data
;;; R2, RX_SOUR_ID
;;; R3, LMEM_BASE
;;; R4, Backup Pointer

{	MOVIU R0,C2CC_BASE         |	NOP	|	NOP	|	NOP	|	NOP	}
{	MOVIU R3,LMEM_BASE         |	NOP	|	NOP	|	NOP	|	NOP	}
{	CLR R1                     |	NOP	|	NOP	|	NOP	|	NOP	}
{	CLR R2                     |	NOP	|	NOP	|	NOP	|	NOP	}
{	CLR R4                     |	NOP	|	NOP	|	NOP	|	NOP	}

;;; ------------------------
;;; get backup pointer
;;; ------------------------

{	LW R2,R0,RX_SOUR_ID_OFFSET |	NOP	|	NOP	|	NOP	|	NOP	}
{	NOP                        |	NOP	|	NOP	|	NOP	|	NOP	}
{	NOP                        |	NOP	|	NOP	|	NOP	|	NOP	}
{	SEQI R8,P1,P2,R2,0x0       |	NOP	|	NOP	|	NOP	|	NOP	}
{	(P1)LW R4,R3,0x00          |	NOP	|	NOP	|	NOP	|	NOP	}
{	NOP                        |	NOP	|	NOP	|	NOP	|	NOP	}
{	NOP                        |	NOP	|	NOP	|	NOP	|	NOP	}
{	SEQI R8,P1,P2,R2,0x1       |	NOP	|	NOP	|	NOP	|	NOP	}
{	(P1)LW R4,R3,0x08          |	NOP	|	NOP	|	NOP	|	NOP	}
{	NOP                        |	NOP	|	NOP	|	NOP	|	NOP	}
{	NOP                        |	NOP	|	NOP	|	NOP	|	NOP	}

;;; -------------------------------
;;; rx_msg -> lmem[pointer]
;;; -------------------------------
;;; R0, C2CC_BASE (RX_MSG_0, _1, _2, _3)
;;; R1, Tmp_Data
;;; R2, Loop Counter(fix 0x4)
;;; R4, Backup Pointer

;;; =====================================================
{	MOVIU R0,C2CC_BASE         |	NOP	|	NOP	|	NOP	|	NOP	}
{	ADDI R0,R0,RX_MSG_0_OFFSET |	NOP	|	NOP	|	NOP	|	NOP	}
{ SET_LBCI R2,0x4            |  NOP | NOP | NOP | NOP }
;;; =====================================================
LEVEL_LOAD_RX_MSG_:
{	LW R1,R0,0x04+   | NOP | NOP | NOP | NOP }
{	NOP              | NOP | NOP | NOP | NOP }
{	NOP              | NOP | NOP | NOP | NOP }
;;; =====================================================
{ LBCB R2, LEVEL_LOAD_RX_MSG_ | NOP | NOP | NOP | NOP }
{	SW R1,R4,0x04+              | NOP | NOP | NOP | NOP }
{	NOP                         | NOP | NOP | NOP | NOP }
{	NOP                         | NOP | NOP | NOP | NOP }
{	NOP                         | NOP | NOP | NOP | NOP }
{	NOP                         | NOP | NOP | NOP | NOP }
{	NOP                         | NOP | NOP | NOP | NOP }

;;; ------------------------
;;; store backup pointer
;;; ------------------------
;;; R0, C2CC_BASE
;;; R2, RX_SOUR_ID
;;; R3, LMEM_BASE
;;; R4, Backup Pointer

{	MOVIU R0,C2CC_BASE         | NOP | NOP | NOP | NOP }
{	MOVIU R3,LMEM_BASE         | NOP | NOP | NOP | NOP }
{	LW R2,R0,RX_SOUR_ID_OFFSET | NOP | NOP | NOP | NOP }
{	NOP                        | NOP | NOP | NOP | NOP }
{	NOP                        | NOP | NOP | NOP | NOP }
{	SEQI R8,P1,P2,R2,0x0       | NOP | NOP | NOP | NOP }
{	(P1)SW R4,R3,0x00          | NOP | NOP | NOP | NOP }
{	NOP                        | NOP | NOP | NOP | NOP }
{	NOP                        | NOP | NOP | NOP | NOP }
{	SEQI R8,P1,P2,R2,0x1       | NOP | NOP | NOP | NOP }
{	(P1)SW R4,R3,0x08          | NOP | NOP | NOP | NOP }
{	NOP                        | NOP | NOP | NOP | NOP }
{	NOP                        | NOP | NOP | NOP | NOP }


;;; =====================================================
;;; rx accept
;;; =====================================================
{	MOVIU R0,C2CC_BASE        |	NOP	|	NOP	|	NOP	|	NOP	}
{	MOVIU R1,0x01             |	NOP	|	NOP	|	NOP	|	NOP	}
{	SW R1,R0,RX_ACCEPT_OFFSET |	NOP	|	NOP	|	NOP	|	NOP	}
{	NOP                       |	NOP	|	NOP	|	NOP	|	NOP	}
{	NOP                       |	NOP	|	NOP	|	NOP	|	NOP	}

{	MOVIU R3,LMEM_BASE        | NOP | NOP | NOP | NOP }
{	LW R5,R3,0x0C             | NOP | NOP | NOP | NOP }
{	NOP                       | NOP | NOP | NOP | NOP }  
{	NOP                       | NOP | NOP | NOP | NOP }  
{	ADDI R5,R5,0x01           | NOP | NOP | NOP | NOP }  
{	SW R5,R3,0x0C             | NOP | NOP | NOP | NOP }
{	NOP                       | NOP | NOP | NOP | NOP }  
{	NOP                       | NOP | NOP | NOP | NOP }

{	B LEVEL_MAIN              | NOP | NOP | NOP | NOP }             
{	NOP                       | NOP | NOP | NOP | NOP }  
{	NOP                       | NOP | NOP | NOP | NOP }  
{	NOP                       | NOP | NOP | NOP | NOP }  
{	NOP                       | NOP | NOP | NOP | NOP }  
{	NOP                       | NOP | NOP | NOP | NOP }  





;;; =====================================================
;;; check tx status 
;;; =====================================================
LEVEL_CHECK_TX:
{	CLR R6                  |	NOP	|	NOP	|	NOP	|	NOP	}
{	MOVIU R0,C2CC_BASE      |	NOP	|	NOP	|	NOP	|	NOP	}
{	SGTI R8,P1,P2,R9,0x3    |	NOP	|	NOP	|	NOP	|	NOP	}
{	(P1)B LEVEL_CHECK_RX    | NOP | NOP | NOP | NOP }
{	NOP                     | NOP | NOP | NOP | NOP }
{	NOP                     | NOP | NOP | NOP | NOP }
{	NOP                     | NOP | NOP | NOP | NOP }
{	NOP                     | NOP | NOP | NOP | NOP }
{	NOP                     | NOP | NOP | NOP | NOP }

LEVEL_CHK_TX_STAT:
{	ADDI R6,R6,0x1          | NOP | NOP | NOP | NOP }
{	SGTI R8,P1,P2,R6,0x20   | NOP | NOP | NOP | NOP }
{	(P1)B LEVEL_CHECK_RX    | NOP | NOP | NOP | NOP }
{	NOP                     | NOP | NOP | NOP | NOP }
{	NOP                     | NOP | NOP | NOP | NOP }
{	NOP                     | NOP | NOP | NOP | NOP }
{	NOP                     | NOP | NOP | NOP | NOP }
{	NOP                     | NOP | NOP | NOP | NOP }
{	LW R1,R0,TX_STAT_OFFSET | NOP | NOP | NOP | NOP }
{	NOP                     | NOP | NOP | NOP | NOP }
{	NOP                     | NOP | NOP | NOP | NOP }
{ SEQI R8,P1,P2,R1,0x00   | NOP | NOP | NOP | NOP }
{	(P2)B LEVEL_CHK_TX_STAT | NOP | NOP | NOP | NOP }
{	NOP                     | NOP | NOP | NOP | NOP }
{	NOP                     | NOP | NOP | NOP | NOP }
{	NOP                     | NOP | NOP | NOP | NOP }
{	NOP                     | NOP | NOP | NOP | NOP }
{	NOP                     | NOP | NOP | NOP | NOP }

;;; get tx data
{	MOVIU R0,C2CC_BASE |	NOP	|	NOP	|	NOP	|	NOP	}
{	MOVIU R3,LMEM_BASE |	NOP	|	NOP	|	NOP	|	NOP	}
{	LW R1,R3,0x04      |	NOP	|	NOP	|	NOP	|	NOP	}
{	NOP                |	NOP	|	NOP	|	NOP	|	NOP	}
{	NOP                |	NOP	|	NOP	|	NOP	|	NOP	}

;;; =====================================================
{	ADDI R1,R1,0x01          |	NOP	|	NOP	|	NOP	|	NOP	}
{	SW R1,R0,TX_MSG_0_OFFSET |	NOP	|	NOP	|	NOP	|	NOP	}
{	NOP                      |	NOP	|	NOP	|	NOP	|	NOP	}
{	NOP                      |	NOP	|	NOP	|	NOP	|	NOP	}

;;; =====================================================
{	ADDI R1,R1,0x01          |	NOP	|	NOP	|	NOP	|	NOP	}
{	SW R1,R0,TX_MSG_1_OFFSET |	NOP	|	NOP	|	NOP	|	NOP	}
{	NOP                      |	NOP	|	NOP	|	NOP	|	NOP	}
{	NOP                      |	NOP	|	NOP	|	NOP	|	NOP	}

;;; =====================================================
{	ADDI R1,R1,0x01          |	NOP	|	NOP	|	NOP	|	NOP	}
{	SW R1,R0,TX_MSG_2_OFFSET |	NOP	|	NOP	|	NOP	|	NOP	}
{	NOP                      |	NOP	|	NOP	|	NOP	|	NOP	}
{	NOP                      |	NOP	|	NOP	|	NOP	|	NOP	}

;;; =====================================================
{	ADDI R1,R1,0x01          |	NOP	|	NOP	|	NOP	|	NOP	}
{	SW R1,R0,TX_MSG_3_OFFSET |	NOP	|	NOP	|	NOP	|	NOP	}
{	NOP                      |	NOP	|	NOP	|	NOP	|	NOP	}
{	NOP                      |	NOP	|	NOP	|	NOP	|	NOP	}

;;; store tx data
{	MOVIU R3,LMEM_BASE |	NOP	|	NOP	|	NOP	|	NOP	}
{	SW R1,R3,0x04      |	NOP	|	NOP	|	NOP	|	NOP	}
{	NOP                |	NOP	|	NOP	|	NOP	|	NOP	}
{	NOP                |	NOP	|	NOP	|	NOP	|	NOP	}

;;; =====================================================
;;; start tx 
;;; =====================================================
{	MOVIU R1,0x01                |	NOP	|	NOP	|	NOP	|	NOP	}
{	SW R1,R0,TX_SEND_TRIG_OFFSET |	NOP	|	NOP	|	NOP	|	NOP	}
{	NOP                          |	NOP	|	NOP	|	NOP	|	NOP	}
{	NOP                          |	NOP	|	NOP	|	NOP	|	NOP	}
{	ADDI R9,R9,0x1               |	NOP	|	NOP	|	NOP	|	NOP	}

{	B LEVEL_MAIN | NOP | NOP | NOP | NOP }             
{	NOP          | NOP | NOP | NOP | NOP }  
{	NOP          | NOP | NOP | NOP | NOP }  
{	NOP          | NOP | NOP | NOP | NOP }  
{	NOP          | NOP | NOP | NOP | NOP }  
{	NOP          | NOP | NOP | NOP | NOP } 
{	NOP          | NOP | NOP | NOP | NOP } 

LEVEL_TRAP:
{	NOP                         | NOP | NOP | NOP | NOP }
{	NOP                         | NOP | NOP | NOP | NOP }
{	NOP                         | NOP | NOP | NOP | NOP }
{	NOP                         | NOP | NOP | NOP | NOP }
{	trap                        | NOP | NOP | NOP | NOP }









