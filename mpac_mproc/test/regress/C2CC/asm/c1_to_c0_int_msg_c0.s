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

CORE0_CONFIG_ADDR          = 0x24050000
FIQ_ISR_Offset             = 0x24
IRQ_ISR_Offset             = 0x28
INT_Mask                   = 0x68

C2CC_ISR_ADDRESS           = 0x30005000


;Set VIC
{ ENABLE_INT | movi a0, CORE0_CONFIG_ADDR | movi d0, C2CC_ISR_ADDRESS | nop | nop }
{ nop        | nop                        | nop                       | nop | nop }
{ nop        | nop                        | nop                       | nop | nop }
{ nop        | nop | nop | nop | nop }
{ nop        | nop | nop | nop | nop }


;;Enable RX_INT

{ movi r0, CFU_Interface_BaseAddr | nop | nop | nop | nop }
{ movi r1, 0x1                    | nop | nop | nop | nop }
{ sw r1, r0, RX_INT_EN            | nop | nop | nop | nop } 
{ nop                             | nop | nop | nop | nop }
{ nop                             | nop | nop | nop | nop }

polling_status:
{ movi r8, SHARE_MEM_ADDR         | nop | nop | nop | nop }
{ lw r9, r8, 0x4                  | nop | nop | nop | nop }
{ nop                             | nop | nop | nop | nop }
{ nop                             | nop | nop | nop | nop }
{ seqi r10, p7, p8, r9, 0x2       | nop | nop | nop | nop }
{ (p8)B polling_status            | nop | nop | nop | nop }
{ nop                             | nop | nop | nop | nop }
{ nop                             | nop | nop | nop | nop }
{ nop                             | nop | nop | nop | nop }
{ nop                             | nop | nop | nop | nop }
{ nop                             | nop | nop | nop | nop }


{ trap                            | nop | nop | nop | nop }




