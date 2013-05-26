/*****************************************************************************

  The following code is derived, directly or indirectly, from the SystemC
  source code Copyright (c) 1996-2008 by all Contributors.
  All Rights reserved.

  The contents of this file are subject to the restrictions and limitations
  set forth in the SystemC Open Source License Version 3.0 (the "License");
  You may not use this file except in compliance with such restrictions and
  limitations. You may obtain instructions on how to receive a copy of the
  License at http://www.systemc.org/. Software distributed by Contributors
  under the License is distributed on an "AS IS" basis, WITHOUT WARRANTY OF
  ANY KIND, either express or implied. See the License for the specific
  language governing rights and limitations under the License.

 *****************************************************************************/

#include "tlm.h"

#include "SimpleLTInitiator3.h"
#include "SimpleLTTarget2.h"

int sc_main(int argc, char* argv[])
{
  SimpleLTInitiator3 initiator("initiator");
  SimpleLTTarget2 target("target");

  initiator.socket(target.socket);

  sc_core::sc_start();
  sc_core::sc_stop();

  return 0;
}
