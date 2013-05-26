#ifndef TRANS_EXTENSION_H_INCLUDED
#define TRANS_EXTENSION_H_INCLUDED

#include "sys/time.h"

#include "systemc"
using namespace sc_core;
using namespace sc_dt;
using namespace std;

struct trans_extension:tlm::tlm_extension < trans_extension > {
	trans_extension() {}

	virtual tlm_extension_base *clone() const {
		trans_extension *ext = new trans_extension();
		return ext;
	} 
	virtual void copy_from(tlm_extension_base const &ext) {}

	unsigned int flag;
	unsigned int inst_core_range;
};

#endif
