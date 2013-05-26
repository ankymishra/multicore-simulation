
BASE_ADDR = 0x24FF

;************************************************************** Set Start Address
{  NOP  |  MOVI.L A0, 0xFFFF    |  NOP  |  NOP  |  NOP  }

{  NOP  |  MOVI.H A0, BASE_ADDR |  NOP  |  NOP  |  NOP  }

{  NOP  |  LW D0, A0, 0         |  NOP  |  NOP  |  NOP  }

{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }
{  NOP  |  NOP  |  NOP  |  NOP  |  NOP  }

{  TRAP |  NOP  |  NOP  |  NOP  |  NOP  }
