#include <systemc.h>
#include <sys/time.h>
#include "errno.h"

#include "pac-iss.h"
#include "sc-pac-memif.h"
#include "pac-socshm-prot.h"
#include "sc-pac-monitor.h"

extern struct soc_shm_prot *soc_shm_base_ptr;
void SC_pac_monitor::sc_pac_monitor_run()
{
	struct soc_shm_prot *base_ptr = soc_shm_base_ptr;

	while (1) {
		wait(monitor_req_event);
		//printf("%s wakeup\r\n", __func__);
		base_ptr->ls_flag = 4;
		//while ((base_ptr->flag) != RESPONSE) {}
		while((base_ptr->ls_flag) != 0) {}
		memif_req_count = 0;

		monitor_resp_event.notify();
	}
}
