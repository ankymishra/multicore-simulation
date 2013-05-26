;;============= To Verify =================
;;C0 transfer 32x4x2 Messages to C1 by C2CC
;;but C1 is busy, and C0 timeout occur
;;check C0 timeout event is right
;;=========================================

;;PACDSP CORE0 C2CC REGISTER MEMORY MAP

CFU_Interface_BaseAddr     = 0x25840000
TX_Send_Trig_offset        = 0x00
TX_Status_offset           = 0x04
TX_Ctrl_offset             = 0x08
TX_TimeOut_offset          = 0x0C
TX_Message0_offset         = 0x10
TX_Message1_offset         = 0x14
TX_Message2_offset         = 0x18
TX_Message3_offset         = 0x1C
TX_Cancel_offset           = 0x20
Monitor_Dest_ID_offset     = 0x24
Monitor_Dest_Status_offset = 0x28
TX_Reserve_offset          = 0x2C
RX_Status_offset           = 0x40 
Source_ID_offset           = 0x44
RX_Message0_offset         = 0x48
RX_Message1_offset         = 0x4C
RX_Message2_offset         = 0x50
RX_Message3_offset         = 0x54
RX_Accept_offset           = 0x58
RX_INT_Clear               = 0x5C
RX_INT_EN                  = 0x60
RX_Reserve_offset          = 0x64    

;;TimeOccur Check Address
MEM_CHECK_ADDR             = 0x24005000
SHARE_MEM_ADDR             = 0x25001000



{ movi r9, 0x0                    | nop | nop | nop | nop }
{ movi r8, SHARE_MEM_ADDR         | nop | nop | nop | nop }
{ sw r9, r8, 0x0                  | nop | nop | nop | nop } ;ISR Result Address
{ sw r9, r8, 0x4                  | nop | nop | nop | nop }

Polling_TX_Status_1:
{ movi r0, CFU_Interface_BaseAddr | nop | nop | nop | nop }
{ lw r1, r0, TX_Status_offset     | nop | nop | nop | nop }
{ nop                             | nop | nop | nop | nop }
{ nop                             | nop | nop | nop | nop }
{ seqi r15, p1, p2, r1, 0x0       | nop | nop | nop | nop }
{ (p2)B Polling_TX_Status_1       | nop | nop | nop | nop }
{ nop                             | nop | nop | nop | nop }
{ nop                             | nop | nop | nop | nop }
{ nop                             | nop | nop | nop | nop }
{ nop                             | nop | nop | nop | nop }
{ nop                             | nop | nop | nop | nop }

;;Set CTL Register
{ movi r7, 0x00010100             | nop | nop | nop | nop }  ;;Core0 send Massage with INT to Core1
{ sw r7, r0, TX_Ctrl_offset       | nop | nop | nop | nop }
{ nop                             | nop | nop | nop | nop }
{ nop                             | nop | nop | nop | nop }



;;Set TX_Message 0~3
{ movi r2, 0x12345678             | nop | nop | nop | nop }
{ movi r3, 0x87654321             | nop | nop | nop | nop }
{ movi r4, 0x11111111             | nop | nop | nop | nop }
{ movi r5, 0x22222222             | nop | nop | nop | nop }
{ sw r2, r0, TX_Message0_offset   | nop | nop | nop | nop }
{ sw r3, r0, TX_Message1_offset   | nop | nop | nop | nop }
{ sw r4, r0, TX_Message2_offset   | nop | nop | nop | nop }
{ sw r5, r0, TX_Message3_offset   | nop | nop | nop | nop }
{ nop                             | nop | nop | nop | nop }

;;Send Trig
{ movi r7, 0x1                    | nop | nop | nop | nop }
{ sw r7, r0, TX_Send_Trig_offset  | nop | nop | nop | nop }
{ nop                             | nop | nop | nop | nop }
{ nop                             | nop | nop | nop | nop }

Polling_TX_Status_2:
{ movi r0, CFU_Interface_BaseAddr | nop | nop | nop | nop }
{ lw r1, r0, TX_Status_offset     | nop | nop | nop | nop }
{ nop                             | nop | nop | nop | nop }
{ nop                             | nop | nop | nop | nop }
{ seqi r15, p1, p2, r1, 0x0       | nop | nop | nop | nop }
{ (p2)B Polling_TX_Status_2       | nop | nop | nop | nop }
{ nop                             | nop | nop | nop | nop }
{ nop                             | nop | nop | nop | nop }
{ nop                             | nop | nop | nop | nop }
{ nop                             | nop | nop | nop | nop }
{ nop                             | nop | nop | nop | nop }

;;Send TX_Message 4~7
{ movi r2, 0xFFF0FFF0             | movi a0, SHARE_MEM_ADDR | movi d0, 0x10 | nop | nop }
{ movi r3, 0x88888888             | nop                     | nop           | nop | nop }
{ movi r4, 0xAAAAAAAA             | nop                     | nop           | nop | nop }
{ movi r5, 0x55555555             | nop                     | nop           | nop | nop }
{ sw r2, r0, TX_Message0_offset   | nop                     | nop           | nop | nop }
{ sw r3, r0, TX_Message1_offset   | nop                     | nop           | nop | nop }
{ sw r4, r0, TX_Message2_offset   | nop                     | nop           | nop | nop }
{ sw r5, r0, TX_Message3_offset   | nop                     | nop           | nop | nop }
{ nop                             | nop                     | nop           | nop | nop }

;;Send Trig
{ movi r7, 0x1                    | nop | nop | nop | nop }
{ sw r7, r0, TX_Send_Trig_offset  | nop | nop | nop | nop }
{ nop                             | nop | nop | nop | nop }
{ nop                             | nop | nop | nop | nop }


Polling_TX_Status_3:
{ movi r0, CFU_Interface_BaseAddr | nop | nop | nop | nop }
{ lw r1, r0, TX_Status_offset     | nop | nop | nop | nop }
{ nop                             | nop | nop | nop | nop }
{ nop                             | nop | nop | nop | nop }
{ seqi r15, p1, p2, r1, 0x0       | nop | nop | nop | nop }
{ (p2)B Polling_TX_Status_3       | nop | nop | nop | nop }
{ nop                             | nop | nop | nop | nop }
{ nop                             | nop | nop | nop | nop }
{ nop                             | nop | nop | nop | nop }
{ nop                             | nop | nop | nop | nop }
{ nop                             | nop | nop | nop | nop }


{ movi r0, CFU_Interface_BaseAddr | nop | nop | nop | nop }
{ movi r3, MEM_CHECK_ADDR         | nop | nop | nop | nop }
{ movi r2, 0x8                    | nop | nop | nop | nop }
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

{ trap                            | nop | nop | nop | nop }




