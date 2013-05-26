BASE_ADDR = 0x2405

BTR_VALUE_ADDR = 112
BTR_CONTROL_ADDR = 116 
  
  
  
;************************************************************** Set Start Address
{  NOP  |  NOP    |  NOP  |  MOVI.L A0, 0x0000  |  NOP  } ;Move 0x0000 to the low address of A0;

{  NOP  |  NOP    |  NOP  |  MOVI.H A0, BASE_ADDR  |  NOP  } ;Move 0x0000 to the high address of A0;
                                                          ;A0 =0x2400 0x0000



;/////////////////////////////////////Function & Linear Addressing//////////////////////////////////////
;************************************************************** Initialize Memory


;//Task description:
;//RUN1:setup timer(from 0),enable timer,disable the timer;
;//RUN2:Clean the timer,Save some value to timer,enable timer;


;////RUN1:Count from 0,disable the timer;
;//Start value is 0;
{  NOP  |  NOP  |  NOP  |  MOVI.L D0, 0x0000  |  NOP  }


{  NOP  |  NOP  |  NOP  |  MOVI.H D0, 0x0000  |  NOP  }

;//Setup the timer value;
{  NOP  |  NOP  |  NOP  |  SW D0, A0, BTR_VALUE_ADDR  |  NOP  }


;//Enable timer: the enable value is 32h'0000_0001;
{  NOP  |  NOP  |  NOP  |  MOVI.L D1, 0x0001  |  NOP  }


{  NOP  |  NOP  |  NOP  |  MOVI.H D1, 0x0000  |  NOP  }


;//Enable timer;
{  NOP  |  NOP  |  NOP  |  SW D1, A0, BTR_CONTROL_ADDR  |  NOP  }


;//Some operations;
{  NOP  |  NOP  |  NOP  |  MOVI.L D0, 0x1111  |  NOP  }


{  NOP  |  NOP  |  NOP  |  MOVI.H D0, 0x2222  |  NOP  }


{  NOP  |  NOP  |  NOP  |  SW D0, A0, 0  |  NOP  }





;//Disable timer:the disable value is 32h'0000_0000;
{  NOP  |  NOP  |  NOP  |  MOVI.L D0, 0x0000  |  NOP  }

{  NOP  |  NOP  |  NOP  |  MOVI.H D0, 0x0000  |  NOP  }

{  NOP  |  NOP  |  NOP  |  SW D0, A0, BTR_CONTROL_ADDR  |  NOP  }



;//Some operations;
{  NOP  |  NOP  |  NOP  |  MOVI.H D0, 0x3333  |  NOP  }

{  NOP  |  NOP  |  NOP  |  SW D0, A0, 200  |  NOP  }

{  NOP  |  NOP  |  NOP  |  SW D0, A0, 210  |  NOP  }

{  NOP  |  NOP  |  NOP  |  SW D0, A0, 220  |  NOP  }

{  NOP  |  NOP  |  NOP  |  SW D0, A0, 230  |  NOP  }

{  NOP  |  NOP  |  NOP  |  SW D0, A0, 240  |  NOP  }


;//RUN2:Clean the timer,Save some value to timer;

;//Clean the timer
{  NOP  |  NOP  |  NOP  |  MOVI.L D1, 0x0000 |  NOP  }


{  NOP  |  NOP  |  NOP  |  MOVI.H D1, 0x0000 |  NOP  }



{  NOP  |  NOP  |  NOP  |  SW D1, A0, BTR_VALUE_ADDR  |  NOP  }


;//Some operation;
{  NOP  |  NOP  |  NOP  |  SW D0, A0, 44  |  NOP  }

{  NOP  |  SW D0, A0, 48  | NOP   | NOP   |  NOP  }

{  NOP  |  SW D0, A0, 52  | NOP   | NOP   |  NOP  }

{  NOP  |  SW D0, A0, 56  | NOP   | NOP   |  NOP  }

{  NOP  |  SW D0, A0, 58  | NOP   | NOP   |  NOP  }


;//Give a value to timer ;
{  NOP  |  NOP  |  NOP  |  MOVI.L D2, 0x0026 |  NOP  }

{  NOP  |  NOP  |  NOP  |  MOVI.H D2, 0x0000 |  NOP  }

{  NOP  |  NOP  |  NOP  |  SW D2, A0,BTR_VALUE_ADDR  |  NOP  }


;//Some operations;
{  NOP  |  NOP  |  NOP  |  SW D0, A0, 244  |  NOP  }


{  NOP  |  NOP  |  NOP  |  SW D0, A0, 248  |  NOP  }



;//Enable timer;
{  NOP  |  NOP  |  NOP  |  MOVI.L D1, 0x0001  |  NOP  }

{  NOP  |  NOP  |  NOP  |  MOVI.H D1, 0x0000  |  NOP  }

{  NOP  |  NOP  |  NOP  |  SW D1, A0, BTR_CONTROL_ADDR  |  NOP  }

;//Some operaiton;
{  NOP  |  NOP  |  NOP  |  SW D0, A0, 300  |  NOP  }


{  NOP  |  NOP  |  NOP  |  SW D0, A0, 308  |  NOP  }


{  NOP  |  NOP  |  NOP  |  SW D0, A0, 316  |  NOP  }


{  NOP  |  NOP  |  NOP  |  SW D0, A0, 314  |  NOP  }


{  NOP  |  NOP  |  NOP  |  SW D0, A0, 318  |  NOP  }


{  NOP  |  NOP  |  NOP  |  SW D0, A0, 322  |  NOP  }


{  NOP  |  NOP  |  NOP  |  SW D0, A0, 324  |  NOP  }


{  NOP  |  NOP  |  NOP  |  SW D0, A0, 328  |  NOP  }


{  NOP  |  NOP  |  NOP  |  SW D0, A0, 332  |  NOP  }



;//Disable timer:the disable value is 32h'0000_0000;
{  NOP  |  NOP  |  NOP  |  MOVI.L D0, 0x0000  |  NOP  }

{  NOP  |  NOP  |  NOP  |  MOVI.H D0, 0x0000  |  NOP  }

{  NOP  |  NOP  |  NOP  |  SW D0, A0, BTR_CONTROL_ADDR  |  NOP  }


;//Give a value to timer ;
;//Detect error;
;{  NOP  |  NOP  |  NOP  |  MOVI.L D2, 0xffff |  NOP  }

;{  NOP  |  NOP  |  NOP  |  MOVI.H D2, 0x0000 |  NOP  }

;{  NOP  |  NOP  |  NOP  |  SW D2, A0,BTR_VALUE_ADDR  |  NOP  }





;************************************************************** Program Terminate
{  TRAP  |  NOP  |  NOP  |  NOP  |  NOP  }
