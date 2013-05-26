
.set C2CC_BASE,         0x25840000
.set LMEM_BASE,         0x24000000
.set BACKUP_POINTER,    0x24000010
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
.set TX_CTRL,           0x00000000
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


;;; =====================================================
;;; [LMEM+0x0] = backup_pointer
;;; =====================================================


{	MOVIU R0,C2CC_BASE      |	NOP	|	NOP	|	NOP	|	NOP	}
{	MOVIU R3,LMEM_BASE      |	NOP	|	NOP	|	NOP	|	NOP	}
{	MOVIU R1,BACKUP_POINTER |	NOP	|	NOP	|	NOP	|	NOP	}
{	SW R1,R3,0x00           |	NOP	|	NOP	|	NOP	|	NOP	}
{	NOP                     |	NOP	|	NOP	|	NOP	|	NOP	}
{	NOP                     |	NOP	|	NOP	|	NOP	|	NOP	}

LEVEL_CHECK_RX_STATUS:

;;; =====================================================
;;; check rx status 
;;; =====================================================
{	MOVIU R0,C2CC_BASE      |	NOP	|	NOP	|	NOP	|	NOP	}
LEVEL_CHK_RX_STAT:
{	LW R1,R0,0x40           | NOP | NOP | NOP | NOP }
{	NOP                     | NOP | NOP | NOP | NOP }
{	NOP                     | NOP | NOP | NOP | NOP }
{ SEQI R4,P1,P2,R1,0x02   | NOP | NOP | NOP | NOP }
{	(P2)B LEVEL_CHK_RX_STAT | NOP | NOP | NOP | NOP }
{	NOP                     | NOP | NOP | NOP | NOP }
{	NOP                     | NOP | NOP | NOP | NOP }
{	NOP                     | NOP | NOP | NOP | NOP }
{	NOP                     | NOP | NOP | NOP | NOP }
{	NOP                     | NOP | NOP | NOP | NOP }

;;; =====================================================
;;; backup rx msg to core 1 local memory
;;; =====================================================
;;; R0, rx_msg0
;;; R4, backup address
;;; R2, rx_msg count = 0x4
;;; R3, LMEM_BASE

{	MOVIU R0,C2CC_BASE         |	NOP	|	NOP	|	NOP	|	NOP	}
{	MOVIU R3,LMEM_BASE         |	NOP	|	NOP	|	NOP	|	NOP	}
{	ADDI R0,R0,RX_MSG_0_OFFSET |	NOP	|	NOP	|	NOP	|	NOP	}
{	CLR R4                     |	NOP	|	NOP	|	NOP	|	NOP	}
{	MOVIU R3,LMEM_BASE         |	NOP	|	NOP	|	NOP	|	NOP	}
{	LW R4,R3,0x00              |	NOP	|	NOP	|	NOP	|	NOP	}
{	NOP                        | NOP | NOP | NOP | NOP }
{	NOP                        | NOP | NOP | NOP | NOP }
{ SET_LBCI R2,0x4            | NOP | NOP | NOP | NOP }

;;; =====================================================
LEVEL_LOAD_RESULT:
{	LW R1,R0,0x04+   | NOP | NOP | NOP | NOP }
{	NOP              | NOP | NOP | NOP | NOP }
{	NOP              | NOP | NOP | NOP | NOP }
;;; =====================================================
{ LBCB R2, LEVEL_LOAD_RESULT | NOP | NOP | NOP | NOP }
{	NOP                        | NOP | NOP | NOP | NOP }
{	SW R1,R4,0x04+             | NOP | NOP | NOP | NOP }
{	NOP                        | NOP | NOP | NOP | NOP }
{	NOP                        | NOP | NOP | NOP | NOP }
{	NOP                        | NOP | NOP | NOP | NOP }
{	NOP                        | NOP | NOP | NOP | NOP }
{	SW R4,R3,0x00              | NOP | NOP | NOP | NOP }
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

;;; =====================================================
;;; 2nd loop
;;; =====================================================
{	ADDI R5,R5,0x01            | NOP | NOP | NOP | NOP }
{ SEQI R4,P1,P2,R5,0x04      | NOP | NOP | NOP | NOP }
{	(P2)B LEVEL_CHECK_RX_STATUS | NOP | NOP | NOP | NOP }
{	NOP                        | NOP | NOP | NOP | NOP }
{	NOP                        | NOP | NOP | NOP | NOP }
{	NOP                        | NOP | NOP | NOP | NOP }
{	NOP                        | NOP | NOP | NOP | NOP }
{	NOP                        | NOP | NOP | NOP | NOP }
{	NOP                        | NOP | NOP | NOP | NOP }
{	trap                       | NOP | NOP | NOP | NOP }









