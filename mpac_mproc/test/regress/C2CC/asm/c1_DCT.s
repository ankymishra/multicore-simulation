

{
  NOP | MOVI.L A0,  0 | NOP | NOP | NOP
}
; Reg[A0] = 0

{
  NOP | MOVI.H A0,  0x2410 | NOP | NOP | NOP
}
; Reg[A0] = 2410_0000

{
  NOP | MOVI.L A1, 8 | NOP | NOP | NOP
}
; Reg[A1] = 8;

{
  NOP | MOVI.H A1, 0x2410 | NOP | NOP | NOP
}
; Reg[A1] = 2400_0008;

{
  NOP | MOVI.L A2, 8 | NOP | NOP | NOP
}
; Reg[A2] = 8;

{
  NOP | MOVI.H A2, 0x2410| NOP | NOP | NOP
}
; Reg[A2] = 0x2400_0008;

{
  NOP | LH D0, A1, 0 | NOP | NOP | NOP
}
; Reg[D0] = FFFF9900 -> CC00_9900

{
  NOP | LH D1, A2, 14 | NOP | NOP | NOP
}
; Reg[D1] = 00004C00

{
  NOP | LH D8, A1, 2 | NOP | NOP | NOP
}
; Reg[D8] = FFFFCC00 -> 0000_CC00

{
  NOP | LH D9, A2, 12 | NOP | NOP | NOP
}
; Reg[D9] = 00006600

{
  NOP | NOP | ADD AC0, D0, D1 | NOP | NOP
}
; Reg[AC0]= FFFFE500

{
  NOP | NOP | SUB AC1, D0, D1 | NOP | NOP
}
; Reg[AC1]= FFFF4D00

{
  NOP | LH D0, A1, 4 | ADD AC2, D8, D9 | NOP | NOP
}
; Reg[D0] = FFFFB300
; Reg[AC2]= 00003200

{
  NOP | LH D1, A2, 10 | SUB AC3, D8, D9 | NOP | NOP
}
; Reg[D1] = 00001900
; Reg[AC3]= FFFF6600

{
  NOP | NOP | NOP | NOP | NOP
}
; delay slot for D0, D1

{
  NOP | NOP | NOP | NOP | NOP
}
; delay slot for D1

{
  NOP | LH D8, A1, 6 | ADD AC4, D0, D1 | NOP | NOP
}
; Reg[D8] = FFFFE600
; Reg[AC4]= FFFFCC00

{
  NOP | LH D9, A2, 8 | SUB AC5, D0, D1 | NOP | NOP
}
; Reg[D9] = FFFF9900
; Reg[AC5]= FFFF9A00

{
  NOP | NOP | NOP | NOP | NOP
}
; delay slot for D8, D9

{
  NOP | NOP | NOP | NOP | NOP
}
; delay slot for D9

{
  NOP | LH D7, A0, 0 | ADD AC6, D8, D9 | NOP | NOP
}
; Reg[D7] = 00005A84
; Reg[AC6]= FFFF7F00

{
  NOP | NOP | SUB AC7, D8, D9 | NOP | NOP
}
; Reg[AC7]= 00004D00

{
  NOP | LH D12, A0, 0 | ADD D0, AC0, AC6 | NOP | NOP
}
; Reg[D12] = 00005A84
; Reg[D0] = FFFF6400

{
  NOP | NOP | SUB D1, AC0, AC6 | NOP | NOP
}
; Reg[D1] = 00006600

{
  NOP | LH D13, A0, 2 | ADD D2, AC2, AC4 | NOP | NOP
}
; Reg[D13]= 000030FC
; Reg[D2] = FFFFFE00

{
  NOP | NOP | SUB D3, AC2, AC4 | NOP | NOP
}
; Reg[D3] = 00006600

{
  NOP | LH D14, A0, 4 | ADD D3, D1, D3 | NOP | NOP
}
; Reg[D14]= 00004546
; Reg[D3] = 0000CC00

{
  NOP | LH D15, A0, 6 | XMUL.D D3, D3, D7 | NOP | NOP
}
; Reg[D15]= 0000273D
; Reg[D3] = 0000DB3A

{
  NOP | ADD D4, D0, D2 | ADD AC7, AC7, AC5 | NOP | NOP
}
; Reg[D4] = FFFF6200
; Reg[AC7]= FFFFE700

{
  NOP | SUB D5, D0, D2 | ADD AC5, AC5, AC3 | NOP | NOP
}
; Reg[D5] = FFFF6600
; Reg[AC5]= FFFF0000

{
  NOP | SH D4, A1, 16 | ADD AC3, AC3, AC1 | NOP | NOP
}
; Mem[25:24] = 6200
; Reg[AC3]   = FFFEB300

{
  NOP | SH D5, A2, 24 | NOP | NOP | NOP
}
; Mem[33:32] = 6600

{
  NOP | ADD D4, D1, D3 | XMUL.D AC5, AC5,  D12 | NOP | NOP
}
; Reg[D4] = 0001413A
; Reg[AC5]= 00000000

{
  NOP | NOP | MOVI.H AC5, 0xFFFF | NOP | NOP
}
; Reg[AC5] = FFFF0000

{
  NOP | SUB D5, D1, D3 | ADD D8, AC1, AC5 | NOP | NOP
}
; Reg[D5] = FFFF8AC6
; Reg[D8] = FFFE4D00

{
  NOP | NOP | SUB D9, AC1, AC5 | NOP | NOP
}
; Reg[D9] = 00004D00

{
  NOP | SH D4, A1, 22 | SUB AC0, AC7, AC3 | NOP | NOP
}
; Mem[31:30] = 413A
; Reg[AC0]   = 00013400

{
  NOP | SH D5, A2, 28 | NOP | NOP | NOP
}
; Mem[37:36] = 8AC6

{
  NOP | NOP | XMUL.D AC0, AC0,  D13 | NOP | NOP
}
; Reg[AC0]= 000013E6

{
  NOP | NOP | MOVI.H AC0, 0x0001 | NOP | NOP
}
; Reg[AC0] = 000113E6

{
  NOP | NOP | XMUL.D AC1, AC7, D14 | NOP | NOP
}
; Reg[AC1]= 0000F278

{
  NOP | NOP | MOVI.H AC1, 0xFFFF | NOP | NOP
}
; Reg[AC1] = FFFFF278

{
  NOP | NOP | XMUL.D AC2, AC3, D15 | NOP | NOP
}
; Reg[AC2]= 0000E865

{
  NOP | NOP | ADD D10, AC0, AC1 | NOP | NOP
}
; Reg[D10]= 0001065E

{
  NOP | NOP | ADD D11, AC0, AC2 | NOP | NOP
}
; Reg[D11]= 0001FC4B

{
  NOP | NOP | ADD D12, D9, D10 | NOP | NOP
}
; Reg[D12]= 0001535E

{
  NOP | NOP | SUB D13, D9, D10 | NOP | NOP
}
; Reg[D13]= FFFF46A2

{
  NOP | NOP | ADD D14, D8, D11 | NOP | NOP
}
; Reg[D14]= 0000494B

{
  NOP | NOP | SUB D15, D8, D11 | NOP | NOP
}
; Reg[D15]= FFFC50B5

{
  NOP | SH D12, A1, 26 | NOP | NOP | NOP
}
; Mem[35:34] = 535E

{
  NOP | SH D13, A2, 20 | NOP | NOP | NOP
}
; Mem[29:28] = 46A2

{
  NOP | SH D14, A1, 18 | NOP | NOP | NOP
}
; Mem[27:26] = 494B

{
  NOP | SH D15, A2, 30 | NOP | NOP | NOP
}
; Mem[39:38] = 50B5


{
  TRAP | NOP | NOP | NOP | NOP
}

                                     