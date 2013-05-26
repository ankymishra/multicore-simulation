#ifndef DMA_H_INCLUDED
#define DMA_H_INCLUDED

#include "systemc"
using namespace sc_core;
using namespace sc_dt;
using namespace std;

#include "tlm.h"

#define DMA_MEM_MODE	1
#define DMA_SHAPE_MODE	2
#define DMA_SC_MODE	3
#define DMA_FIFO_MODE	4

#define DMAEN_IDLE	0
#define DMAEN_ENABLE	1
#define DMAEN_WORKING	2

#define SET(X)	ext->X = X
#define STATIC_CAST(X)	X = static_cast<dma_extension const &>(ext).X

struct dma_extension:tlm::tlm_extension < dma_extension > {
	dma_extension() {
	} virtual tlm_extension_base *clone() const {
		dma_extension *ext = new dma_extension;
		SET(flag);
		SET(ch_num);
		SET(address);
		SET(sar);
		SET(dar);
		SET(dma_mode);
		SET(padding_num2);
		SET(padding_num1);
		SET(padding_unit2);
		SET(padding_unit1);
		SET(padding_dirc2);
		SET(padding_dirc1);
		SET(padding_en);
		SET(src_x);
		SET(src_y);
		SET(des_x);
		SET(des_y);
		SET(src_resx);
		SET(des_resx);

		return ext;
	} virtual void copy_from(tlm_extension_base const &ext) {
		STATIC_CAST(flag);
		STATIC_CAST(ch_num);
		STATIC_CAST(address);
		STATIC_CAST(sar);
		STATIC_CAST(dar);
		STATIC_CAST(dma_mode);
		STATIC_CAST(padding_num2);
		STATIC_CAST(padding_num1);
		STATIC_CAST(padding_unit2);
		STATIC_CAST(padding_unit1);
		STATIC_CAST(padding_dirc2);
		STATIC_CAST(padding_dirc1);
		STATIC_CAST(padding_en);
		STATIC_CAST(src_x);
		STATIC_CAST(src_y);
		STATIC_CAST(des_x);
		STATIC_CAST(des_y);
		STATIC_CAST(src_resx);
		STATIC_CAST(des_resx);
	}

	unsigned int core_id;		// SOURCE core id
	unsigned int flag;			// DMA data or ISS data
	unsigned int ch_num;
	unsigned int address;		// create trans's module memory address
	unsigned int sar, dar;
	unsigned int dma_mode;

	unsigned int padding_num2;
	unsigned int padding_num1;
	unsigned int padding_unit2;
	unsigned int padding_unit1;
	unsigned int padding_dirc2;
	unsigned int padding_dirc1;
	unsigned int padding_en;

	unsigned int src_x;
	unsigned int src_y;
	unsigned int des_x;
	unsigned int des_y;

	unsigned int src_resx;
	unsigned int des_resx;

	unsigned int src_gsc;
	unsigned int src_gso;
	unsigned int des_dsc;
	unsigned int des_dso;

	unsigned int dma_ctl;
};

#endif
