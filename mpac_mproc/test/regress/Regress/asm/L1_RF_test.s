
BASE_ADDR = 0x2400
L1RF_BASE = 0x2405


;************************************************************** Set Start Address
{  NOP  |  MOVI.L A0, 0x4000    |  NOP  |  NOP  |  NOP  }

{  NOP  |  MOVI.H A0, L1RF_BASE |  NOP  |  NOP  |  NOP  }

{  NOP  |  LW D0, A0, 0x44 |  NOP  |  NOP  |  NOP  }

{  NOP  |  LW D1, A0, 0x48 |  NOP  |  NOP  |  NOP  }

{  NOP  |  SW D0, A0, 0x34 |  NOP  |  NOP  |  NOP  }


{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  TRAP |  NOP  |  NOP  |  NOP  |  NOP  }
