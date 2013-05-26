
#include <systemc.h>
#include "tlm.h"
using namespace sc_core;
using namespace sc_dt;
using namespace std;

#include "mpac-mproc-define.h"
#include "pac-shm.h"
#include "mpac-mproc-sim-arg.h"
#include "pac-socshm-prot.h"
#include "pac-soc.h"
#include "pac-bus.h"


struct profile_soc pac_bus::profile_soc_table = {0};

