#ifndef SC_PAC_MONITOR_H_INCLUDED
#define SC_PAC_MONITOR_H_INCLUDED

#include "systemc"
#include "sys/time.h"

SC_MODULE(SC_pac_monitor)
{
	void sc_pac_monitor_run();

	SC_HAS_PROCESS(SC_pac_monitor);
	SC_pac_monitor(sc_module_name _name)
	{
		SC_THREAD(sc_pac_monitor_run);
	}
};

#endif
