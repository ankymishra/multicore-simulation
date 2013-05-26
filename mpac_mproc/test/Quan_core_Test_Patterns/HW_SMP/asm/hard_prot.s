{ NOP | MOVI.L A0, 0x0000 |  NOP  |  NOP  |  NOP  }
{ NOP | MOVI.H A0, 0x2583 |  NOP  |  NOP  |  NOP  } ;SEMAPHORE Base

{ NOP | MOVI.L A1, 0x0000 |  NOP  |  NOP  |  NOP  }
{ NOP | MOVI.H A1, 0x2582 |  NOP  |  NOP  |  NOP  } ;M2 DMA Base

{ NOP | MOVI.L A2, 0x0000 |  NOP  |  NOP  |  NOP  }
{ NOP | MOVI.H A2, 0x2400 |  NOP  |  NOP  |  NOP  } ;L1 LDM Core0 Base = 0x0800_0000 (A2)

{ NOP | MOVI.L D0, 0x0001 |  NOP  |  NOP  |  NOP  }
{ NOP | MOVI.H D0, 0x0000 |  NOP  |  NOP  |  NOP  }

{ NOP | MOVI.L D1, 0x0001 |  NOP  |  NOP  |  NOP  }
{ NOP | MOVI.H D1, 0x0000 |  NOP  |  NOP  |  NOP  } ;CTRL register setting

;{ NOP | MOVI.L D2, 0x5555 |  NOP  |  NOP  |  NOP  }
;{ NOP | MOVI.H D2, 0x1234 |  NOP  |  NOP  |  NOP  } ;initial value

{ NOP | MOVI.L D3, 0xAAAA |  NOP  |  NOP  |  NOP  }
{ NOP | MOVI.H D3, 0x4321 |  NOP  |  NOP  |  NOP  } ;modified value

;{ NOP | SW D2, A1, 0x0070 | NOP | NOP | NOP } ;DMA0 SAR
;{ NOP | SW D2, A1, 0x00B4 | NOP | NOP | NOP } ;DMA1 DAR
;{ NOP | SW D2, A1, 0x00F0 | NOP | NOP | NOP } ;DMA2 SAR
;{ NOP | SW D2, A1, 0x0134 | NOP | NOP | NOP } ;DMA3 DAR
;{ NOP | SW D2, A1, 0x0170 | NOP | NOP | NOP } ;DMA4 SAR
;{ NOP | SW D2, A1, 0x01B4 | NOP | NOP | NOP } ;DMA5 DAR
;{ NOP | SW D2, A1, 0x01F0 | NOP | NOP | NOP } ;DMA6 SAR
;{ NOP | SW D2, A1, 0x0234 | NOP | NOP | NOP } ;DMA7 DAR

;{ NOP | SH D1, A0, 0x00 | NOP | NOP | NOP } ;enable hard protection
;{ NOP | SH D1, A0, 0x10 | NOP | NOP | NOP } ;enable hard protection
;{ NOP | SH D1, A0, 0x20 | NOP | NOP | NOP } ;enable hard protection
;{ NOP | SH D1, A0, 0x30 | NOP | NOP | NOP } ;enable hard protection
;{ NOP | SH D1, A0, 0x40 | NOP | NOP | NOP } ;enable hard protection
;{ NOP | SH D1, A0, 0x50 | NOP | NOP | NOP } ;enable hard protection
;{ NOP | SH D1, A0, 0x60 | NOP | NOP | NOP } ;enable hard protection
;{ NOP | SH D1, A0, 0x70 | NOP | NOP | NOP } ;enable hard protection

{ NOP | SW D3, A1, 0x0070 | NOP | NOP | NOP } ;DMA0 SAR
{ NOP | SW D3, A1, 0x00B4 | NOP | NOP | NOP } ;DMA1 DAR
{ NOP | SW D3, A1, 0x00F0 | NOP | NOP | NOP } ;DMA2 SAR
{ NOP | SW D3, A1, 0x0134 | NOP | NOP | NOP } ;DMA3 DAR
{ NOP | SW D3, A1, 0x0170 | NOP | NOP | NOP } ;DMA4 SAR
{ NOP | SW D3, A1, 0x01B4 | NOP | NOP | NOP } ;DMA5 DAR
{ NOP | SW D3, A1, 0x01F0 | NOP | NOP | NOP } ;DMA6 SAR
{ NOP | SW D3, A1, 0x0234 | NOP | NOP | NOP } ;DMA7 DAR

{ NOP | LW D15, A1, 0x0070 | NOP | NOP | NOP } ;DMA0 SAR
{ NOP | LW D14, A1, 0x00B4 | NOP | NOP | NOP } ;DMA1 DAR
{ NOP | LW D13, A1, 0x00F0 | NOP | NOP | NOP } ;DMA2 SAR
{ NOP | LW D12, A1, 0x0134 | NOP | NOP | NOP } ;DMA3 DAR
{ NOP | LW D11, A1, 0x0170 | NOP | NOP | NOP } ;DMA4 SAR
{ NOP | LW D10, A1, 0x01B4 | NOP | NOP | NOP } ;DMA5 DAR
{ NOP | LW  D9, A1, 0x01F0 | NOP | NOP | NOP } ;DMA6 SAR
{ NOP | LW  D8, A1, 0x0234 | NOP | NOP | NOP } ;DMA7 DAR

{ NOP | SW D15, A2, 0x00 | NOP | NOP | NOP } ;DMA0 SAR
{ NOP | SW D14, A2, 0x04 | NOP | NOP | NOP } ;DMA1 DAR
{ NOP | SW D13, A2, 0x08 | NOP | NOP | NOP } ;DMA2 SAR
{ NOP | SW D12, A2, 0x0C | NOP | NOP | NOP } ;DMA3 DAR
{ NOP | SW D11, A2, 0x10 | NOP | NOP | NOP } ;DMA4 SAR
{ NOP | SW D10, A2, 0x14 | NOP | NOP | NOP } ;DMA5 DAR
{ NOP | SW  D9, A2, 0x18 | NOP | NOP | NOP } ;DMA6 SAR
{ NOP | SW  D8, A2, 0x1C | NOP | NOP | NOP } ;DMA7 DAR

{ NOP | NOP | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ NOP | NOP | NOP | NOP | NOP }
{ TRAP | NOP | NOP | NOP | NOP }
