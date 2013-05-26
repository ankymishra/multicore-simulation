  
BASE_ADDR = 0x2400
  
{ MOVI.L R0, 0x1111 | MOVIU D0, 0x11111111 | NOP | MOVIU D0, 0x55555555 | NOP } 
{ MOVI.H R0, 0xAAAA | MOVIU D1, 0xAABBCCDD | NOP | MOVIU D1, 0xFFFFFFFF | NOP } 
{ MOVI.L R1, 0      | MOVI.L A0, 0x0000    | NOP | MOVI.L A0, 0x0000      | NOP }
{ MOVI.H R1, 0x1E00 | MOVI.H A0, BASE_ADDR | NOP | MOVI.H A0, BASE_ADDR | NOP }
{ NOP | SW D0, A0, 0 | NOP | SW D0, A0, 4 | NOP }
;Mem[0x1E00_0000] = 0x11111111
;Mem[0x1E00_0004] = 0x55555555
{ NOP | SW D1, A0, 8 | NOP | SW D1, A0, 12 | NOP }
;Mem[0x1E00_0008] = 0xAABBCCDD
;Mem[0x1E00_000C] = 0xFFFFFFFF
;============================================================ Load + E3 Forwarding
{ NOP | LB D2, A0, 9 | NOP | LB D2, A0, 10 | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ NOP | ADDI D3, D2, 1 | NOP | NOP | ADDI D3, D2, 1 }
; Reg[D3] = 0xFFFFFFCD   LS_E3 -> LS_RO
; Reg[D3] = 0xFFFFFFBC   LS_E3 -> AU_RO

{ NOP | LB D4, A0, 8 | NOP | LB D4, A0, 11 | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ NOP | NOP | ADDI D5, D4, 1 | ADDI D5, D4, 1 | NOP }
; Reg[D5] = 0xFFFFFFDE   LS_E3 -> AU_RO
; Reg[D5] = 0xFFFFFFAB   LS_E3 -> LS_RO
;===================================================== Store Results
{ NOP | SW D3, A0, 16 | NOP | SW D3, A0, 20 | NOP }
;Mem[0x1E00_0010] = 0xFFFFFFCD
;Mem[0x1E00_0014] = 0xFFFFFFBC
{ NOP | SW D5, A0, 24 | NOP | SW D5, A0, 28 | NOP }
;Mem[0x1E00_0018] = 0xFFFFFFDE
;Mem[0x1E00_001C] = 0xFFFFFFAB

;============================================================ MUL + E1 Forwarding
{ NOP | NOP | FMUL D2, D1, D0 | NOP | FMUL D2, D1, D0 }
; Reg[D2] = 0xFC9747AD
; Reg[D2] = 0xFFFFAAAB
{ NOP | NOP | MUL.D D3, D2, D0 | NOP | MUL.D D3, D2, D0 }
; Reg[D3] = 0xCD073F7D   AU_E1 -> AU_RO
; Reg[D3] = 0xAAAB71C7   AU_E1 -> AU_RO
{ NOP | ADDI D4, D3, 1 | NOP | ADDI D4, D3, 1 | NOP }
; Reg[D4] = 0xCD073F7E   AU_E1 -> LS_RO
; Reg[D4] = 0xAAAB71C8   AU_E1 -> LS_RO
;===================================================== Store Results
{ NOP | SW D2, A0, 32 | NOP | SW D2, A0, 36 | NOP }
;Mem[0x1E00_0020] = 0xFC9747AD
;Mem[0x1E00_0024] = 0xFFFFAAAB
{ NOP | SW D3, A0, 40 | NOP | SW D3, A0, 44 | NOP }
;Mem[0x1E00_0028] = 0xCD073F7D                
;Mem[0x1E00_002C] = 0xAAAB71C7                
{ NOP | SW D4, A0, 48 | NOP | SW D4, A0, 52 | NOP }
;Mem[0x1E00_0030] = 0xCD073F7E
;Mem[0x1E00_0034] = 0xAAAB71C8


{ TRAP | NOP | NOP | NOP | NOP }
                