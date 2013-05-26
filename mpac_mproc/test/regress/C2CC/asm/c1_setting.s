
.set C2CC_BASE,         0x25841000
.set LMEM_BASE,         0x24100000

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
.set TX_CTRL,           0x00010100
.set TX_TIMEOUT,        0x0000FF0F
.set TX_MSG_0,          0xBBBBBBB1
.set TX_MSG_1,          0xBBBBBBB2
.set TX_MSG_2,	        0xBBBBBBB3
.set TX_MSG_3,	        0xBBBBBBB4
.set TX_CANCEL,         0x00000000
.set TX_MNTR_DEST_ID,   0x00000001
.set TX_RESER,	        0xBBBBBBB5

;;; =====================================================
.set RX_ACCEPT,	        0x00000001
.set RX_INT_CLR,	      0x00000001
.set RX_INT_EN,	        0x00000001
.set RX_RESERT,	        0xBBBBBBB6

{	CLR R0 |	NOP	|	NOP	|	NOP	|	NOP	}
{	CLR R1 |	NOP	|	NOP	|	NOP	|	NOP	}
{	CLR R2 |	NOP	|	NOP	|	NOP	|	NOP	}
{	CLR R3 |	NOP	|	NOP	|	NOP	|	NOP	}

;;; =====================================================
{	MOVIU R0,C2CC_BASE      |	NOP	|	NOP	|	NOP	|	NOP	}
{	MOVIU R1,TX_CTRL        |	NOP	|	NOP	|	NOP	|	NOP	}
{	SW R1,R0,TX_CTRL_OFFSET |	NOP	|	NOP	|	NOP	|	NOP	}
{	NOP                     |	NOP	|	NOP	|	NOP	|	NOP	}
{	NOP                     |	NOP	|	NOP	|	NOP	|	NOP	}

;;; =====================================================
{	MOVIU R1,TX_TIMEOUT        |	NOP	|	NOP	|	NOP	|	NOP	}
{	SW R1,R0,TX_TIMEOUT_OFFSET |	NOP	|	NOP	|	NOP	|	NOP	}
{	NOP                        |	NOP	|	NOP	|	NOP	|	NOP	}
{	NOP                        |	NOP	|	NOP	|	NOP	|	NOP	}

;;; =====================================================
{	MOVIU R1,TX_MSG_0        |	NOP	|	NOP	|	NOP	|	NOP	}
{	SW R1,R0,TX_MSG_0_OFFSET |	NOP	|	NOP	|	NOP	|	NOP	}
{	NOP                      |	NOP	|	NOP	|	NOP	|	NOP	}
{	NOP                      |	NOP	|	NOP	|	NOP	|	NOP	}

;;; =====================================================
{	MOVIU R1,TX_MSG_1        |	NOP	|	NOP	|	NOP	|	NOP	}
{	SW R1,R0,TX_MSG_1_OFFSET |	NOP	|	NOP	|	NOP	|	NOP	}
{	NOP                      |	NOP	|	NOP	|	NOP	|	NOP	}
{	NOP                      |	NOP	|	NOP	|	NOP	|	NOP	}

;;; =====================================================
{	MOVIU R1,TX_MSG_2        |	NOP	|	NOP	|	NOP	|	NOP	}
{	SW R1,R0,TX_MSG_2_OFFSET |	NOP	|	NOP	|	NOP	|	NOP	}
{	NOP                      |	NOP	|	NOP	|	NOP	|	NOP	}
{	NOP                      |	NOP	|	NOP	|	NOP	|	NOP	}

;;; =====================================================
{	MOVIU R1,TX_MSG_3        |	NOP	|	NOP	|	NOP	|	NOP	}
{	SW R1,R0,TX_MSG_3_OFFSET |	NOP	|	NOP	|	NOP	|	NOP	}
{	NOP                      |	NOP	|	NOP	|	NOP	|	NOP	}
{	NOP                      |	NOP	|	NOP	|	NOP	|	NOP	}

;;; =====================================================
{	MOVIU R1,TX_CANCEL        |	NOP	|	NOP	|	NOP	|	NOP	}
{	SW R1,R0,TX_CANCEL_OFFSET |	NOP	|	NOP	|	NOP	|	NOP	}
{	NOP                       |	NOP	|	NOP	|	NOP	|	NOP	}
{	NOP                       |	NOP	|	NOP	|	NOP	|	NOP	}

;;; =====================================================
{	MOVIU R1,TX_MNTR_DEST_ID        |	NOP	|	NOP	|	NOP	|	NOP	}
{	SW R1,R0,TX_MNTR_DEST_ID_OFFSET |	NOP	|	NOP	|	NOP	|	NOP	}
{	NOP                             |	NOP	|	NOP	|	NOP	|	NOP	}
{	NOP                             |	NOP	|	NOP	|	NOP	|	NOP	}

;;; =====================================================
{	MOVIU R1,TX_RESER        |	NOP	|	NOP	|	NOP	|	NOP	}
{	SW R1,R0,TX_RESER_OFFSET |	NOP	|	NOP	|	NOP	|	NOP	}
{	NOP                      |	NOP	|	NOP	|	NOP	|	NOP	}
{	NOP                      |	NOP	|	NOP	|	NOP	|	NOP	}

;;; =====================================================
{	MOVIU R1,RX_ACCEPT        |	NOP	|	NOP	|	NOP	|	NOP	}
{	SW R1,R0,RX_ACCEPT_OFFSET |	NOP	|	NOP	|	NOP	|	NOP	}
{	NOP                       |	NOP	|	NOP	|	NOP	|	NOP	}
{	NOP                       |	NOP	|	NOP	|	NOP	|	NOP	}

;;; =====================================================
{	MOVIU R1,RX_INT_CLR        |	NOP	|	NOP	|	NOP	|	NOP	}
{	SW R1,R0,RX_INT_CLR_OFFSET |	NOP	|	NOP	|	NOP	|	NOP	}
{	NOP                        |	NOP	|	NOP	|	NOP	|	NOP	}
{	NOP                        |	NOP	|	NOP	|	NOP	|	NOP	}

;;; =====================================================
{	MOVIU R1,RX_INT_EN        |	NOP	|	NOP	|	NOP	|	NOP	}
{	SW R1,R0,RX_INT_EN_OFFSET |	NOP	|	NOP	|	NOP	|	NOP	}
{	NOP                       |	NOP	|	NOP	|	NOP	|	NOP	}
{	NOP                       |	NOP	|	NOP	|	NOP	|	NOP	}

;;; =====================================================
{	MOVIU R1,RX_RESERT        |	NOP	|	NOP	|	NOP	|	NOP	}
{	SW R1,R0,RX_RESER_OFFSET  |	NOP	|	NOP	|	NOP	|	NOP	}
{	NOP                       |	NOP	|	NOP	|	NOP	|	NOP	}
{	NOP                       |	NOP	|	NOP	|	NOP	|	NOP	}

;;; =====================================================
{	MOVIU R3,LMEM_BASE |	NOP	|	NOP	|	NOP	|	NOP	}
{ SET_LBCI R2,0x1C   | NOP | NOP | NOP | NOP }

;;; =====================================================
LEVEL_LOAD_RESULT:
{	LW R1,R0,0x04+   | NOP | NOP | NOP | NOP }
{	NOP              | NOP | NOP | NOP | NOP }
{	NOP              | NOP | NOP | NOP | NOP }
;;; =====================================================
{ LBCB R2, LEVEL_LOAD_RESULT | NOP | NOP | NOP | NOP }
{	NOP                        | NOP | NOP | NOP | NOP }
{	SW R1,R3,0x04+             | NOP | NOP | NOP | NOP }
{	NOP                        | NOP | NOP | NOP | NOP }
{	NOP                        | NOP | NOP | NOP | NOP }
{	NOP                        | NOP | NOP | NOP | NOP }
{	NOP                        | NOP | NOP | NOP | NOP }
{	TRAP                       | NOP | NOP | NOP | NOP }











