{ NOP | MOVI.L A0, 0x0000 |  NOP  |  NOP  |  NOP  }
{ NOP | MOVI.H A0, 0x2583 |  NOP  |  NOP  |  NOP  } ;SEMAPHORE Base

{ NOP | MOVI.L A1, 0x0000 |  NOP  |  NOP  |  NOP  }
{ NOP | MOVI.H A1, 0x2582 |  NOP  |  NOP  |  NOP  } ;M2 DMA Base

{ NOP | MOVI.L A2, 0x0000 |  NOP  |  NOP  |  NOP  }
{ NOP | MOVI.H A2, 0x2400 |  NOP  |  NOP  |  NOP  } ;L1 LDM Core0 Base = 0x0800_0000 (A2)

{ NOP | MOVI.L D8, 0xAAAA |  NOP  |  NOP  |  NOP  }
{ NOP | MOVI.H D8, 0x4321 |  NOP  |  NOP  |  NOP  } ;modified value

{ NOP | SW D8, A1, 0x0070 | NOP | NOP | NOP } ;DMA0 SAR
{ NOP | SW D8, A1, 0x00B4 | NOP | NOP | NOP } ;DMA1 DAR
{ NOP | SW D8, A1, 0x00F0 | NOP | NOP | NOP } ;DMA2 SAR
{ NOP | SW D8, A1, 0x0134 | NOP | NOP | NOP } ;DMA3 DAR
{ NOP | SW D8, A1, 0x0170 | NOP | NOP | NOP } ;DMA4 SAR
{ NOP | SW D8, A1, 0x01B4 | NOP | NOP | NOP } ;DMA5 DAR
{ NOP | SW D8, A1, 0x01F0 | NOP | NOP | NOP } ;DMA6 SAR
{ NOP | SW D8, A1, 0x0234 | NOP | NOP | NOP } ;DMA7 DAR

{ NOP | LW D0, A0, 0x0C | NOP | NOP | NOP } ;SMP0 error
{ NOP | LW D1, A0, 0x1C | NOP | NOP | NOP } ;SMP1 error
{ NOP | LW D2, A0, 0x2C | NOP | NOP | NOP } ;SMP2 error
{ NOP | LW D3, A0, 0x3C | NOP | NOP | NOP } ;SMP3 error
{ NOP | LW D4, A0, 0x4C | NOP | NOP | NOP } ;SMP4 error
{ NOP | LW D5, A0, 0x5C | NOP | NOP | NOP } ;SMP5 error
{ NOP | LW D6, A0, 0x6C | NOP | NOP | NOP } ;SMP6 error
{ NOP | LW D7, A0, 0x7C | NOP | NOP | NOP } ;SMP7 error

{ NOP | SW D0, A2, 0x00 | NOP | NOP | NOP } ;SMP0 error
{ NOP | SW D1, A2, 0x04 | NOP | NOP | NOP } ;SMP1 error
{ NOP | SW D2, A2, 0x08 | NOP | NOP | NOP } ;SMP2 error
{ NOP | SW D3, A2, 0x0C | NOP | NOP | NOP } ;SMP3 error
{ NOP | SW D4, A2, 0x10 | NOP | NOP | NOP } ;SMP4 error
{ NOP | SW D5, A2, 0x14 | NOP | NOP | NOP } ;SMP5 error
{ NOP | SW D6, A2, 0x18 | NOP | NOP | NOP } ;SMP6 error
{ NOP | SW D7, A2, 0x1C | NOP | NOP | NOP } ;SMP7 error

{ NOP | NOP | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ TRAP | NOP | NOP | NOP | NOP }
