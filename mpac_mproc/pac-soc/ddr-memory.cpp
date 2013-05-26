#include "mpac-mproc-define.h"
#include "pac-parser.h"
#include "pac-socshm-prot.h"
#include "pac-soc.h"
#include "pac-biu-bus.h"

void Biu_Bus::dma_direct_operation(tlm::tlm_generic_payload * trans_ptr, sc_core::sc_time & delay)
{
	unsigned int padding_dirc2, padding_dirc1;
	unsigned int padding_num2, padding_num1;
	dma_extension *ext_ptr;
	unsigned int padding_en;

	trans_ptr->get_extension(ext_ptr);
	padding_dirc2 = ext_ptr->padding_dirc2;
	padding_dirc1 = ext_ptr->padding_dirc1;
	padding_num2 = ext_ptr->padding_num2;
	padding_num1 = ext_ptr->padding_num1;
	padding_en = ext_ptr->padding_en;

	if (padding_en) {
		if (!padding_num1 && !padding_dirc2) {
			zone_memcpy_y0(trans_ptr);
			padding_operation_y0(trans_ptr, delay);
		} else if (!padding_num1 && padding_dirc2) {
			zone_memcpy_y1(trans_ptr);
			padding_operation_y1(trans_ptr, delay);
		} else if (!padding_num2 && !padding_dirc1) {
			zone_memcpy_x0(trans_ptr);
			padding_operation_x0(trans_ptr, delay);
		} else if (!padding_num2 && padding_dirc1) {
			zone_memcpy_x1(trans_ptr);
			padding_operation_x1(trans_ptr, delay);
		} else if (!padding_dirc1 && !padding_dirc2) {
			zone_memcpy_x0y0(trans_ptr);
			padding_operation_x0y0(trans_ptr, delay);
		} else if (!padding_dirc1 && padding_dirc2) {
			zone_memcpy_x0y1(trans_ptr);
			padding_operation_x0y1(trans_ptr, delay);
		} else if (padding_dirc1 && !padding_dirc2) {
			zone_memcpy_x1y0(trans_ptr);
			padding_operation_x1y0(trans_ptr, delay);
		} else if (padding_dirc1 && padding_dirc2) {
			zone_memcpy_x1y1(trans_ptr);
			padding_operation_x1y1(trans_ptr, delay);
		}
	} else {
		zone_memcpy_direct(trans_ptr);
	}

	trans_ptr->set_response_status(tlm::TLM_OK_RESPONSE);
}

void Biu_Bus::dma_sc_operation(tlm::tlm_generic_payload * trans_ptr, sc_core::sc_time & delay)
{
	unsigned int padding_dirc2, padding_dirc1;
	unsigned int padding_num2, padding_num1;
	dma_extension *ext_ptr;
	unsigned int padding_en;

	trans_ptr->get_extension(ext_ptr);
	padding_dirc2 = ext_ptr->padding_dirc2;
	padding_dirc1 = ext_ptr->padding_dirc1;
	padding_num2 = ext_ptr->padding_num2;
	padding_num1 = ext_ptr->padding_num1;
	padding_en = ext_ptr->padding_en;

	if (padding_en) {
		if (!padding_num1 && !padding_dirc2) {
			zone_memcpy_y0(trans_ptr);
			padding_operation_y0(trans_ptr, delay);
		} else if (!padding_num1 && padding_dirc2) {
			zone_memcpy_y1(trans_ptr);
			padding_operation_y1(trans_ptr, delay);
		} else if (!padding_num2 && !padding_dirc1) {
			zone_memcpy_x0(trans_ptr);
			padding_operation_x0(trans_ptr, delay);
		} else if (!padding_num2 && padding_dirc1) {
			zone_memcpy_x1(trans_ptr);
			padding_operation_x1(trans_ptr, delay);
		} else if (!padding_dirc1 && !padding_dirc2) {
			zone_memcpy_x0y0(trans_ptr);
			padding_operation_x0y0(trans_ptr, delay);
		} else if (!padding_dirc1 && padding_dirc2) {
			zone_memcpy_x0y1(trans_ptr);
			padding_operation_x0y1(trans_ptr, delay);
		} else if (padding_dirc1 && !padding_dirc2) {
			zone_memcpy_x1y0(trans_ptr);
			padding_operation_x1y0(trans_ptr, delay);
		} else if (padding_dirc1 && padding_dirc2) {
			zone_memcpy_x1y1(trans_ptr);
			padding_operation_x1y1(trans_ptr, delay);
		}
	} else {
		zone_memcpy_direct(trans_ptr);
	}

	trans_ptr->set_response_status(tlm::TLM_OK_RESPONSE);
}

void Biu_Bus::dma_fifo_operation(tlm::tlm_generic_payload * trans_ptr, sc_core::sc_time & delay)
{
}

void Biu_Bus::zone_memcpy_direct(tlm::tlm_generic_payload * trans_ptr)
{
	unsigned int i;
	unsigned int sar, dar;
	unsigned int padding_num2, padding_num1;
	unsigned int padding_unit2, padding_unit1;
	unsigned int padding_dirc2, padding_dirc1;
	unsigned int padding_en;
	unsigned int src_x, src_y;
	unsigned int des_x, des_y;
	unsigned int src_resx, des_resx;

	sc_dt::uint64 src_addr;
	sc_dt::uint64 tmp_addr;
	unsigned char *des_ptr;
	unsigned char *tmp_ptr;

	tlm::tlm_command cmd = trans_ptr->get_command();
	sc_dt::uint64 addr = trans_ptr->get_address();
	unsigned char *ptr = trans_ptr->get_data_ptr();
	unsigned int len = trans_ptr->get_data_length();

	dma_extension *ext_ptr;
	trans_ptr->get_extension(ext_ptr);

	sar = ext_ptr->sar;
	dar = ext_ptr->dar;
	padding_num2 = ext_ptr->padding_num2;
	padding_num1 = ext_ptr->padding_num1;
	padding_unit2 = ext_ptr->padding_unit2;
	padding_unit1 = ext_ptr->padding_unit1;
	padding_dirc2 = ext_ptr->padding_dirc2;
	padding_dirc1 = ext_ptr->padding_dirc1;
	padding_en = ext_ptr->padding_en;
	src_x = ext_ptr->src_x;
	src_y = ext_ptr->src_y;
	des_x = ext_ptr->des_x;
	des_y = ext_ptr->des_y;
	src_resx = ext_ptr->src_resx;
	des_resx = ext_ptr->des_resx;

	src_addr = addr - ddr_memory_base;
	tmp_addr = addr - ddr_memory_base;
	des_ptr = ptr;
	tmp_ptr = ptr;

	if (cmd == tlm::TLM_READ_COMMAND) {
		if (ddr_addr_valid(addr, len)) {	// local ddr mem space
			for (i = 0; i < len; i++, src_addr++, des_ptr++) {
				if (ext_ptr->flag == SYS_DMA_DATA) {
					if ((ext_ptr->dma_ctl & 0x80) || (ext_ptr->dma_ctl & 0x10)) {
						if (src_addr >= tmp_addr + src_x) {
							tmp_addr += src_resx;
							src_addr = tmp_addr;
						}
					}

					if ((ext_ptr->dma_ctl & 0x100) || (ext_ptr->dma_ctl & 0x20)) {
						if (des_ptr >= tmp_ptr + des_x) {
							tmp_ptr += des_resx;
							des_ptr = tmp_ptr;
						}
					}
				} else {
					if ((ext_ptr->dma_ctl & 0x100) || (ext_ptr->dma_ctl & 0x10)) {
						if (src_addr >= tmp_addr + src_x) {
							tmp_addr += src_resx;
							src_addr = tmp_addr;
						}
					}

					if ((ext_ptr->dma_ctl & 0x200) || (ext_ptr->dma_ctl & 0x20)) {
						if (des_ptr >= tmp_ptr + des_x) {
							tmp_ptr += des_resx;
							des_ptr = tmp_ptr;
						}
					}
				}
				*des_ptr = ddr_memory[src_addr];
			}
		}
	} else {
		if (ddr_addr_valid(addr, len)) {	// local ddr mem space
			for (i = 0; i < len; i++, src_addr++, des_ptr++) {
				if (ext_ptr->flag == SYS_DMA_DATA) {
					if ((ext_ptr->dma_ctl & 0x80) || (ext_ptr->dma_ctl & 0x10)) {
						if (des_ptr >= tmp_ptr + src_x) {
							tmp_ptr += src_resx;
							des_ptr = tmp_ptr;
						}
					}

					if ((ext_ptr->dma_ctl & 0x100) || (ext_ptr->dma_ctl & 0x20)) {
						if (src_addr >= tmp_addr + des_x) {
							tmp_addr += des_resx;
							src_addr = tmp_addr;
						}
					}
				} else {
					if ((ext_ptr->dma_ctl & 0x100) || (ext_ptr->dma_ctl & 0x10)) {
						if (des_ptr >= tmp_ptr + src_x) {
							tmp_ptr += src_resx;
							des_ptr = tmp_ptr;
						}
					}

					if ((ext_ptr->dma_ctl & 0x200) || (ext_ptr->dma_ctl & 0x20)) {
						if (src_addr >= tmp_addr + des_x) {
							tmp_addr += des_resx;
							src_addr = tmp_addr;
						}
					}
				}
				ddr_memory[src_addr] = *des_ptr;
			}
		}
	}
}

void Biu_Bus::zone_memcpy_x0(tlm::tlm_generic_payload * trans_ptr)
{
	unsigned int i;
	unsigned int sar, dar;
	unsigned int padding_num2, padding_num1;
	unsigned int padding_unit2, padding_unit1;
	unsigned int padding_dirc2, padding_dirc1;
	unsigned int padding_en;
	unsigned int src_x, src_y;
	unsigned int des_x, des_y;
	unsigned int src_resx, des_resx;

	sc_dt::uint64 src_addr;
	sc_dt::uint64 tmp_addr;
	unsigned char *des_ptr;
	unsigned char *tmp_ptr;

	tlm::tlm_command cmd = trans_ptr->get_command();
	sc_dt::uint64 addr = trans_ptr->get_address();
	unsigned char *ptr = trans_ptr->get_data_ptr();
	unsigned int len = trans_ptr->get_data_length();

	dma_extension *ext_ptr;
	trans_ptr->get_extension(ext_ptr);

	sar = ext_ptr->sar;
	dar = ext_ptr->dar;
	padding_num2 = ext_ptr->padding_num2;
	padding_num1 = ext_ptr->padding_num1;
	padding_unit2 = ext_ptr->padding_unit2;
	padding_unit1 = ext_ptr->padding_unit1;
	padding_dirc2 = ext_ptr->padding_dirc2;
	padding_dirc1 = ext_ptr->padding_dirc1;
	padding_en = ext_ptr->padding_en;
	src_x = ext_ptr->src_x;
	src_y = ext_ptr->src_y;
	des_x = ext_ptr->des_x;
	des_y = ext_ptr->des_y;
	src_resx = ext_ptr->src_resx;
	des_resx = ext_ptr->des_resx;

	src_addr = addr - ddr_memory_base;
	tmp_addr = addr - ddr_memory_base;
	des_ptr = ptr + padding_num1;
	tmp_ptr = ptr + padding_num1;

	if (cmd == tlm::TLM_READ_COMMAND) {
		if (ddr_addr_valid(addr, len)) {	// local ddr mem space
			for (i = 0; i < len; i++, src_addr++, des_ptr++) {
				if ((ext_ptr->dma_ctl & 0x100) || (ext_ptr->dma_ctl & 0x10)) {
					if (src_addr >= tmp_addr + src_x) {
						tmp_addr += src_resx;
						src_addr = tmp_addr;
					}
				}

				if ((ext_ptr->dma_ctl & 0x200) || (ext_ptr->dma_ctl & 0x20)) {
					if (des_ptr >= tmp_ptr + des_x) {
						tmp_ptr += des_resx;
						des_ptr = tmp_ptr;
					}
				}

				*des_ptr = ddr_memory[src_addr];
			}
		}
	} else {
		if (ddr_addr_valid(addr, len)) {	// local ddr mem space
			for (i = 0; i < len; i++, src_addr++, des_ptr++) {
				if ((ext_ptr->dma_ctl & 0x100) || (ext_ptr->dma_ctl & 0x10)) {
					if (des_ptr >= tmp_ptr + src_x) {
						tmp_ptr += src_resx;
						des_ptr = tmp_ptr;
					}
				}

				if ((ext_ptr->dma_ctl & 0x200) || (ext_ptr->dma_ctl & 0x20)) {
					if (src_addr >= tmp_addr + des_x) {
						tmp_addr += des_resx;
						src_addr = tmp_addr;
					}
				}

				ddr_memory[src_addr] = *des_ptr;
			}
		}
	}
}

void Biu_Bus::zone_memcpy_x1(tlm::tlm_generic_payload * trans_ptr)
{
	unsigned int i;
	unsigned int sar, dar;
	unsigned int padding_num2, padding_num1;
	unsigned int padding_unit2, padding_unit1;
	unsigned int padding_dirc2, padding_dirc1;
	unsigned int padding_en;
	unsigned int src_x, src_y;
	unsigned int des_x, des_y;
	unsigned int src_resx, des_resx;

	sc_dt::uint64 src_addr;
	sc_dt::uint64 tmp_addr;
	unsigned char *des_ptr;
	unsigned char *tmp_ptr;

	tlm::tlm_command cmd = trans_ptr->get_command();
	sc_dt::uint64 addr = trans_ptr->get_address();
	unsigned char *ptr = trans_ptr->get_data_ptr();
	unsigned int len = trans_ptr->get_data_length();

	dma_extension *ext_ptr;
	trans_ptr->get_extension(ext_ptr);

	sar = ext_ptr->sar;
	dar = ext_ptr->dar;
	padding_num2 = ext_ptr->padding_num2;
	padding_num1 = ext_ptr->padding_num1;
	padding_unit2 = ext_ptr->padding_unit2;
	padding_unit1 = ext_ptr->padding_unit1;
	padding_dirc2 = ext_ptr->padding_dirc2;
	padding_dirc1 = ext_ptr->padding_dirc1;
	padding_en = ext_ptr->padding_en;
	src_x = ext_ptr->src_x;
	src_y = ext_ptr->src_y;
	des_x = ext_ptr->des_x;
	des_y = ext_ptr->des_y;
	src_resx = ext_ptr->src_resx;
	des_resx = ext_ptr->des_resx;

	src_addr = addr - ddr_memory_base;
	tmp_addr = addr - ddr_memory_base;
	des_ptr = ptr;
	tmp_ptr = ptr;

	if (cmd == tlm::TLM_READ_COMMAND) {
		if (ddr_addr_valid(addr, len)) {	// local ddr mem space
			for (i = 0; i < len; i++, src_addr++, des_ptr++) {
				if ((ext_ptr->dma_ctl & 0x100) || (ext_ptr->dma_ctl & 0x10)) {
					if (src_addr >= tmp_addr + src_x) {
						tmp_addr += src_resx;
						src_addr = tmp_addr;
					}
				}

				if ((ext_ptr->dma_ctl & 0x200) || (ext_ptr->dma_ctl & 0x20)) {
					if (des_ptr >= tmp_ptr + des_x) {
						tmp_ptr += des_resx;
						des_ptr = tmp_ptr;
					}
				}

				*des_ptr = ddr_memory[src_addr];
			}
		}
	} else {
		if (ddr_addr_valid(addr, len)) {	// local ddr mem space
			for (i = 0; i < len; i++, src_addr++, des_ptr++) {
				if ((ext_ptr->dma_ctl & 0x100) || (ext_ptr->dma_ctl & 0x10)) {
					if (des_ptr >= tmp_ptr + src_x) {
						tmp_ptr += src_resx;
						des_ptr = tmp_ptr;
					}
				}

				if ((ext_ptr->dma_ctl & 0x200) || (ext_ptr->dma_ctl & 0x20)) {
					if (src_addr >= tmp_addr + des_x) {
						tmp_addr += des_resx;
						src_addr = tmp_addr;
					}
				}

				ddr_memory[src_addr] = *des_ptr;
			}
		}
	}
}

void Biu_Bus::zone_memcpy_y0(tlm::tlm_generic_payload * trans_ptr)
{
	unsigned int i;
	unsigned int sar, dar;
	unsigned int padding_num2, padding_num1;
	unsigned int padding_unit2, padding_unit1;
	unsigned int padding_dirc2, padding_dirc1;
	unsigned int padding_en;
	unsigned int src_x, src_y;
	unsigned int des_x, des_y;
	unsigned int src_resx, des_resx;

	sc_dt::uint64 src_addr;
	sc_dt::uint64 tmp_addr;
	unsigned char *des_ptr;
	unsigned char *tmp_ptr;

	tlm::tlm_command cmd = trans_ptr->get_command();
	sc_dt::uint64 addr = trans_ptr->get_address();
	unsigned char *ptr = trans_ptr->get_data_ptr();
	unsigned int len = trans_ptr->get_data_length();

	dma_extension *ext_ptr;
	trans_ptr->get_extension(ext_ptr);

	sar = ext_ptr->sar;
	dar = ext_ptr->dar;
	padding_num2 = ext_ptr->padding_num2;
	padding_num1 = ext_ptr->padding_num1;
	padding_unit2 = ext_ptr->padding_unit2;
	padding_unit1 = ext_ptr->padding_unit1;
	padding_dirc2 = ext_ptr->padding_dirc2;
	padding_dirc1 = ext_ptr->padding_dirc1;
	padding_en = ext_ptr->padding_en;
	src_x = ext_ptr->src_x;
	src_y = ext_ptr->src_y;
	des_x = ext_ptr->des_x;
	des_y = ext_ptr->des_y;
	src_resx = ext_ptr->src_resx;
	des_resx = ext_ptr->des_resx;

	src_addr = addr - ddr_memory_base;
	tmp_addr = addr - ddr_memory_base;
	des_ptr = ptr + (des_resx * (padding_num2));
	tmp_ptr = ptr + (des_resx * (padding_num2));

	if (cmd == tlm::TLM_READ_COMMAND) {
		if (ddr_addr_valid(addr, len)) {	// local ddr mem space
			for (i = 0; i < len; i++, src_addr++, des_ptr++) {
				if ((ext_ptr->dma_ctl & 0x100) || (ext_ptr->dma_ctl & 0x10)) {
					if (src_addr >= tmp_addr + src_x) {
						tmp_addr += src_resx;
						src_addr = tmp_addr;
					}
				}

				if ((ext_ptr->dma_ctl & 0x200) || (ext_ptr->dma_ctl & 0x20)) {
					if (des_ptr >= tmp_ptr + des_x) {
						tmp_ptr += des_resx;
						des_ptr = tmp_ptr;
					}
				}

				*des_ptr = ddr_memory[src_addr];
			}
		}
	} else {
		if (ddr_addr_valid(addr, len)) {	// local ddr mem space
			for (i = 0; i < len; i++, src_addr++, des_ptr++) {
				if ((ext_ptr->dma_ctl & 0x100) || (ext_ptr->dma_ctl & 0x10)) {
					if (des_ptr >= tmp_ptr + src_x) {
						tmp_ptr += src_resx;
						des_ptr = tmp_ptr;
					}
				}

				if ((ext_ptr->dma_ctl & 0x200) || (ext_ptr->dma_ctl & 0x20)) {
					if (src_addr >= tmp_addr + des_x) {
						tmp_addr += des_resx;
						src_addr = tmp_addr;
					}
				}

				ddr_memory[src_addr] = *des_ptr;
			}
		}
	}
}

void Biu_Bus::zone_memcpy_y1(tlm::tlm_generic_payload * trans_ptr)
{
	unsigned int i;
	unsigned int sar, dar;
	unsigned int padding_num2, padding_num1;
	unsigned int padding_unit2, padding_unit1;
	unsigned int padding_dirc2, padding_dirc1;
	unsigned int padding_en;
	unsigned int src_x, src_y;
	unsigned int des_x, des_y;
	unsigned int src_resx, des_resx;

	sc_dt::uint64 src_addr;
	sc_dt::uint64 tmp_addr;
	unsigned char *des_ptr;
	unsigned char *tmp_ptr;

	tlm::tlm_command cmd = trans_ptr->get_command();
	sc_dt::uint64 addr = trans_ptr->get_address();
	unsigned char *ptr = trans_ptr->get_data_ptr();
	unsigned int len = trans_ptr->get_data_length();

	dma_extension *ext_ptr;
	trans_ptr->get_extension(ext_ptr);

	sar = ext_ptr->sar;
	dar = ext_ptr->dar;
	padding_num2 = ext_ptr->padding_num2;
	padding_num1 = ext_ptr->padding_num1;
	padding_unit2 = ext_ptr->padding_unit2;
	padding_unit1 = ext_ptr->padding_unit1;
	padding_dirc2 = ext_ptr->padding_dirc2;
	padding_dirc1 = ext_ptr->padding_dirc1;
	padding_en = ext_ptr->padding_en;
	src_x = ext_ptr->src_x;
	src_y = ext_ptr->src_y;
	des_x = ext_ptr->des_x;
	des_y = ext_ptr->des_y;
	src_resx = ext_ptr->src_resx;
	des_resx = ext_ptr->des_resx;

	src_addr = addr - ddr_memory_base;
	tmp_addr = addr - ddr_memory_base;
	des_ptr = ptr;
	tmp_ptr = ptr;

	if (cmd == tlm::TLM_READ_COMMAND) {
		if (ddr_addr_valid(addr, len)) {	// local ddr mem space
			for (i = 0; i < len; i++, src_addr++, des_ptr++) {
				if ((ext_ptr->dma_ctl & 0x100) || (ext_ptr->dma_ctl & 0x10)) {
					if (src_addr >= tmp_addr + src_x) {
						tmp_addr += src_resx;
						src_addr = tmp_addr;
					}
				}

				if ((ext_ptr->dma_ctl & 0x200) || (ext_ptr->dma_ctl & 0x20)) {
					if (des_ptr >= tmp_ptr + des_x) {
						tmp_ptr += des_resx;
						des_ptr = tmp_ptr;
					}
				}

				*des_ptr = ddr_memory[src_addr];
			}
		}
	} else {
		if (ddr_addr_valid(addr, len)) {	// local m1 mem space
			for (i = 0; i < len; i++, src_addr++, des_ptr++) {
				if ((ext_ptr->dma_ctl & 0x100) || (ext_ptr->dma_ctl & 0x10)) {
					if (des_ptr >= tmp_ptr + src_x) {
						tmp_ptr += src_resx;
						des_ptr = tmp_ptr;
					}
				}

				if ((ext_ptr->dma_ctl & 0x200) || (ext_ptr->dma_ctl & 0x20)) {
					if (src_addr >= tmp_addr + des_x) {
						tmp_addr += des_resx;
						src_addr = tmp_addr;
					}
				}

				ddr_memory[src_addr] = *des_ptr;
			}
		}
	}
}

void Biu_Bus::zone_memcpy_x0y0(tlm::tlm_generic_payload * trans_ptr)
{
	unsigned int i;
	unsigned int sar, dar;
	unsigned int padding_num2, padding_num1;
	unsigned int padding_unit2, padding_unit1;
	unsigned int padding_dirc2, padding_dirc1;
	unsigned int padding_en;
	unsigned int src_x, src_y;
	unsigned int des_x, des_y;
	unsigned int src_resx, des_resx;

	sc_dt::uint64 src_addr;
	sc_dt::uint64 tmp_addr;
	unsigned char *des_ptr;
	unsigned char *tmp_ptr;

	tlm::tlm_command cmd = trans_ptr->get_command();
	sc_dt::uint64 addr = trans_ptr->get_address();
	unsigned char *ptr = trans_ptr->get_data_ptr();
	unsigned int len = trans_ptr->get_data_length();

	dma_extension *ext_ptr;
	trans_ptr->get_extension(ext_ptr);

	sar = ext_ptr->sar;
	dar = ext_ptr->dar;
	padding_num2 = ext_ptr->padding_num2;
	padding_num1 = ext_ptr->padding_num1;
	padding_unit2 = ext_ptr->padding_unit2;
	padding_unit1 = ext_ptr->padding_unit1;
	padding_dirc2 = ext_ptr->padding_dirc2;
	padding_dirc1 = ext_ptr->padding_dirc1;
	padding_en = ext_ptr->padding_en;
	src_x = ext_ptr->src_x;
	src_y = ext_ptr->src_y;
	des_x = ext_ptr->des_x;
	des_y = ext_ptr->des_y;
	src_resx = ext_ptr->src_resx;
	des_resx = ext_ptr->des_resx;

	src_addr = addr - ddr_memory_base;
	tmp_addr = addr - ddr_memory_base;
	des_ptr = (ptr + (des_resx * (padding_num2) + padding_num1));
	tmp_ptr = (ptr + (des_resx * (padding_num2) + padding_num1));

	if (cmd == tlm::TLM_READ_COMMAND) {
		if (ddr_addr_valid(addr, len)) {	// local ddr mem space
			for (i = 0; i < len; i++, src_addr++, des_ptr++) {
				if ((ext_ptr->dma_ctl & 0x100) || (ext_ptr->dma_ctl & 0x10)) {
					if (src_addr >= tmp_addr + src_x) {
						tmp_addr += src_resx;
						src_addr = tmp_addr;
					}
				}

				if ((ext_ptr->dma_ctl & 0x200) || (ext_ptr->dma_ctl & 0x20)) {
					if (des_ptr >= tmp_ptr + des_x) {
						tmp_ptr += des_resx;
						des_ptr = tmp_ptr;
					}
				}

				*des_ptr = ddr_memory[src_addr];
			}
		}
	} else {
		if (ddr_addr_valid(addr, len)) {	// local ddr mem space
			for (i = 0; i < len; i++, src_addr++, des_ptr++) {
				if ((ext_ptr->dma_ctl & 0x100) || (ext_ptr->dma_ctl & 0x10)) {
					if (des_ptr >= tmp_ptr + src_x) {
						tmp_ptr += src_resx;
						des_ptr = tmp_ptr;
					}
				}

				if ((ext_ptr->dma_ctl & 0x200) || (ext_ptr->dma_ctl & 0x20)) {
					if (src_addr >= tmp_addr + des_x) {
						tmp_addr += des_resx;
						src_addr = tmp_addr;
					}
				}

				ddr_memory[src_addr] = *des_ptr;
			}
		}
	}
}

void Biu_Bus::zone_memcpy_x1y0(tlm::tlm_generic_payload * trans_ptr)
{
	unsigned int i;
	unsigned int sar, dar;
	unsigned int padding_num2, padding_num1;
	unsigned int padding_unit2, padding_unit1;
	unsigned int padding_dirc2, padding_dirc1;
	unsigned int padding_en;
	unsigned int src_x, src_y;
	unsigned int des_x, des_y;
	unsigned int src_resx, des_resx;

	sc_dt::uint64 src_addr;
	sc_dt::uint64 tmp_addr;
	unsigned char *des_ptr;
	unsigned char *tmp_ptr;

	tlm::tlm_command cmd = trans_ptr->get_command();
	sc_dt::uint64 addr = trans_ptr->get_address();
	unsigned char *ptr = trans_ptr->get_data_ptr();
	unsigned int len = trans_ptr->get_data_length();

	dma_extension *ext_ptr;
	trans_ptr->get_extension(ext_ptr);

	sar = ext_ptr->sar;
	dar = ext_ptr->dar;
	padding_num2 = ext_ptr->padding_num2;
	padding_num1 = ext_ptr->padding_num1;
	padding_unit2 = ext_ptr->padding_unit2;
	padding_unit1 = ext_ptr->padding_unit1;
	padding_dirc2 = ext_ptr->padding_dirc2;
	padding_dirc1 = ext_ptr->padding_dirc1;
	padding_en = ext_ptr->padding_en;
	src_x = ext_ptr->src_x;
	src_y = ext_ptr->src_y;
	des_x = ext_ptr->des_x;
	des_y = ext_ptr->des_y;
	src_resx = ext_ptr->src_resx;
	des_resx = ext_ptr->des_resx;

	src_addr = addr - ddr_memory_base;
	tmp_addr = addr - ddr_memory_base;
	des_ptr = (ptr + (des_resx * (padding_num2)));
	tmp_ptr = (ptr + (des_resx * (padding_num2)));

	if (cmd == tlm::TLM_READ_COMMAND) {
		if (ddr_addr_valid(addr, len)) {	// local ddr mem space
			for (i = 0; i < len; i++, src_addr++, des_ptr++) {
				if ((ext_ptr->dma_ctl & 0x100) || (ext_ptr->dma_ctl & 0x10)) {
					if (src_addr >= tmp_addr + src_x) {
						tmp_addr += src_resx;
						src_addr = tmp_addr;
					}
				}

				if ((ext_ptr->dma_ctl & 0x200) || (ext_ptr->dma_ctl & 0x20)) {
					if (des_ptr >= tmp_ptr + des_x) {
						tmp_ptr += des_resx;
						des_ptr = tmp_ptr;
					}
				}

				*des_ptr = ddr_memory[src_addr];
			}
		}
	} else {
		if (ddr_addr_valid(addr, len)) {	// local ddr mem space
			for (i = 0; i < len; i++, src_addr++, des_ptr++) {
				if ((ext_ptr->dma_ctl & 0x100) || (ext_ptr->dma_ctl & 0x10)) {
					if (des_ptr >= tmp_ptr + src_x) {
						tmp_ptr += src_resx;
						des_ptr = tmp_ptr;
					}
				}

				if ((ext_ptr->dma_ctl & 0x200) || (ext_ptr->dma_ctl & 0x20)) {
					if (src_addr >= tmp_addr + des_x) {
						tmp_addr += des_resx;
						src_addr = tmp_addr;
					}
				}

				ddr_memory[src_addr] = *des_ptr;
			}
		}
	}
}

void Biu_Bus::zone_memcpy_x0y1(tlm::tlm_generic_payload * trans_ptr)
{
	unsigned int i;
	unsigned int sar, dar;
	unsigned int padding_num2, padding_num1;
	unsigned int padding_unit2, padding_unit1;
	unsigned int padding_dirc2, padding_dirc1;
	unsigned int padding_en;
	unsigned int src_x, src_y;
	unsigned int des_x, des_y;
	unsigned int src_resx, des_resx;

	sc_dt::uint64 src_addr;
	sc_dt::uint64 tmp_addr;
	unsigned char *des_ptr;
	unsigned char *tmp_ptr;

	tlm::tlm_command cmd = trans_ptr->get_command();
	sc_dt::uint64 addr = trans_ptr->get_address();
	unsigned char *ptr = trans_ptr->get_data_ptr();
	unsigned int len = trans_ptr->get_data_length();

	dma_extension *ext_ptr;
	trans_ptr->get_extension(ext_ptr);

	sar = ext_ptr->sar;
	dar = ext_ptr->dar;
	padding_num2 = ext_ptr->padding_num2;
	padding_num1 = ext_ptr->padding_num1;
	padding_unit2 = ext_ptr->padding_unit2;
	padding_unit1 = ext_ptr->padding_unit1;
	padding_dirc2 = ext_ptr->padding_dirc2;
	padding_dirc1 = ext_ptr->padding_dirc1;
	padding_en = ext_ptr->padding_en;
	src_x = ext_ptr->src_x;
	src_y = ext_ptr->src_y;
	des_x = ext_ptr->des_x;
	des_y = ext_ptr->des_y;
	src_resx = ext_ptr->src_resx;
	des_resx = ext_ptr->des_resx;

	src_addr = addr - ddr_memory_base;
	tmp_addr = addr - ddr_memory_base;
	des_ptr = (ptr + padding_num1);
	tmp_ptr = (ptr + padding_num1);

	if (cmd == tlm::TLM_READ_COMMAND) {
		if (ddr_addr_valid(addr, len)) {	// local ddr mem space
			for (i = 0; i < len; i++, src_addr++, des_ptr++) {
				if ((ext_ptr->dma_ctl & 0x100) || (ext_ptr->dma_ctl & 0x10)) {
					if (src_addr >= tmp_addr + src_x) {
						tmp_addr += src_resx;
						src_addr = tmp_addr;
					}
				}

				if ((ext_ptr->dma_ctl & 0x200) || (ext_ptr->dma_ctl & 0x20)) {
					if (des_ptr >= tmp_ptr + des_x) {
						tmp_ptr += des_resx;
						des_ptr = tmp_ptr;
					}
				}

				*des_ptr = ddr_memory[src_addr];
			}
		}
	} else {
		if (ddr_addr_valid(addr, len)) {	// local ddr mem space
			for (i = 0; i < len; i++, src_addr++, des_ptr++) {
				if ((ext_ptr->dma_ctl & 0x100) || (ext_ptr->dma_ctl & 0x10)) {
					if (des_ptr >= tmp_ptr + src_x) {
						tmp_ptr += src_resx;
						des_ptr = tmp_ptr;
					}

					if ((ext_ptr->dma_ctl & 0x200) || (ext_ptr->dma_ctl & 0x20)) {
						if (src_addr >= tmp_addr + des_x) {
							tmp_addr += des_resx;
							src_addr = tmp_addr;
						}
					}

					ddr_memory[src_addr] = *des_ptr;
				}
			}
		}
	}
}

void Biu_Bus::zone_memcpy_x1y1(tlm::tlm_generic_payload * trans_ptr)
{
	unsigned int i;
	unsigned int sar, dar;
	unsigned int padding_num2, padding_num1;
	unsigned int padding_unit2, padding_unit1;
	unsigned int padding_dirc2, padding_dirc1;
	unsigned int padding_en;
	unsigned int src_x, src_y;
	unsigned int des_x, des_y;
	unsigned int src_resx, des_resx;

	sc_dt::uint64 src_addr;
	sc_dt::uint64 tmp_addr;
	unsigned char *des_ptr;
	unsigned char *tmp_ptr;

	tlm::tlm_command cmd = trans_ptr->get_command();
	sc_dt::uint64 addr = trans_ptr->get_address();
	unsigned char *ptr = trans_ptr->get_data_ptr();
	unsigned int len = trans_ptr->get_data_length();

	dma_extension *ext_ptr;
	trans_ptr->get_extension(ext_ptr);

	sar = ext_ptr->sar;
	dar = ext_ptr->dar;
	padding_num2 = ext_ptr->padding_num2;
	padding_num1 = ext_ptr->padding_num1;
	padding_unit2 = ext_ptr->padding_unit2;
	padding_unit1 = ext_ptr->padding_unit1;
	padding_dirc2 = ext_ptr->padding_dirc2;
	padding_dirc1 = ext_ptr->padding_dirc1;
	padding_en = ext_ptr->padding_en;
	src_x = ext_ptr->src_x;
	src_y = ext_ptr->src_y;
	des_x = ext_ptr->des_x;
	des_y = ext_ptr->des_y;
	src_resx = ext_ptr->src_resx;
	des_resx = ext_ptr->des_resx;

	src_addr = addr - ddr_memory_base;
	tmp_addr = addr - ddr_memory_base;
	des_ptr = ptr;
	tmp_ptr = ptr;

	if (cmd == tlm::TLM_READ_COMMAND) {
		if (ddr_addr_valid(addr, len)) {	// local ddr mem space
			for (i = 0; i < len; i++, src_addr++, des_ptr++) {
				if ((ext_ptr->dma_ctl & 0x100) || (ext_ptr->dma_ctl & 0x10)) {
					if (src_addr >= tmp_addr + src_x) {
						tmp_addr += src_resx;
						src_addr = tmp_addr;
					}
				}

				if ((ext_ptr->dma_ctl & 0x200) || (ext_ptr->dma_ctl & 0x20)) {
					if (des_ptr >= tmp_ptr + des_x) {
						tmp_ptr += des_resx;
						des_ptr = tmp_ptr;
					}
				}

				*des_ptr = ddr_memory[src_addr];
			}
		}
	} else {
		if (ddr_addr_valid(addr, len)) {	// local ddr mem space
			for (i = 0; i < len; i++, src_addr++, des_ptr++) {
				if ((ext_ptr->dma_ctl & 0x100) || (ext_ptr->dma_ctl & 0x10)) {
					if (des_ptr >= tmp_ptr + src_x) {
						tmp_ptr += src_resx;
						des_ptr = tmp_ptr;
					}
				}

				if ((ext_ptr->dma_ctl & 0x200) || (ext_ptr->dma_ctl & 0x20)) {
					if (src_addr >= tmp_addr + des_x) {
						tmp_addr += des_resx;
						src_addr = tmp_addr;
					}
				}

				ddr_memory[src_addr] = *des_ptr;
			}
		}
	}
}

void Biu_Bus::extend_memcpy(unsigned char *dst, unsigned char *src, unsigned int len)
{
	unsigned int i;
	for (i = 0; i < len; i++) {
		dst[i] = src[i];
	}
}

// copy zone define
//  Z0  |   A
void Biu_Bus::padding_operation_x0(tlm::tlm_generic_payload * trans_ptr, sc_core::sc_time & delay)
{
	unsigned int i = 0, j = 0;
	sc_dt::uint64 address;		// create trans's module memory address
	unsigned int sar, dar;
	unsigned int padding_num2, padding_num1;
	unsigned int padding_unit2, padding_unit1;
	unsigned int padding_dirc2, padding_dirc1;
	unsigned int padding_en;
	unsigned int src_x, src_y;
	unsigned int des_x, des_y;
	unsigned int src_resx, des_resx;
	unsigned char *ptr = trans_ptr->get_data_ptr();

	dma_extension *ext_ptr;
	trans_ptr->get_extension(ext_ptr);
	address = ext_ptr->address;
	sar = ext_ptr->sar;
	dar = ext_ptr->dar;
	padding_num2 = ext_ptr->padding_num2;
	padding_num1 = ext_ptr->padding_num1;
	padding_unit2 = ext_ptr->padding_unit2;
	padding_unit1 = ext_ptr->padding_unit1;
	padding_dirc2 = ext_ptr->padding_dirc2;
	padding_dirc1 = ext_ptr->padding_dirc1;
	padding_en = ext_ptr->padding_en;
	src_x = ext_ptr->src_x;
	src_y = ext_ptr->src_y;
	des_x = ext_ptr->des_x;
	des_y = ext_ptr->des_y;
	src_resx = ext_ptr->src_resx;
	des_resx = ext_ptr->des_resx;

	unsigned char *des_ptr = ptr + padding_num1;	//zone A ptr

	unsigned char *src_ptr;
	unsigned char *dst_ptr;

	if (padding_en != 0) {
//copy Z0
		dst_ptr = ptr + padding_num1 % padding_unit1;
		src_ptr = des_ptr;

		for (i = 0; i < padding_num1 / padding_unit1; i++) {
			for (j = 0; j < des_y; j++) {
				extend_memcpy(dst_ptr, src_ptr, padding_unit1);
				dst_ptr += des_resx;
				src_ptr += des_resx;
			}
			src_ptr = des_ptr;
			dst_ptr = ptr + padding_num1 % padding_unit1 + (1 + i) * padding_unit1;
		}

		if ((padding_num1 % padding_unit1) != 0) {
			dst_ptr = ptr;
			src_ptr = des_ptr + (padding_unit1 - padding_num1 % padding_unit1);
			for (i = 0; i < (padding_num1 % padding_unit1); i++) {
				for (j = 0; j < des_y; j++) {
					extend_memcpy(dst_ptr, src_ptr, 1);
					dst_ptr += des_resx;
					src_ptr += des_resx;
				}
				src_ptr = des_ptr + (padding_unit1 - padding_num1 % padding_unit1) + (1 + i) * 1;
				dst_ptr = ptr + (1 + i) * 1;
			}
		}
	}
	trans_ptr->set_response_status(tlm::TLM_OK_RESPONSE);
}

//copy zone define
//  A   |   Z0
void Biu_Bus::padding_operation_x1(tlm::tlm_generic_payload * trans_ptr, sc_core::sc_time & delay)
{
	unsigned int i = 0, j = 0;
	sc_dt::uint64 address;		// create trans's module memory address
	unsigned int sar, dar;
	unsigned int padding_num2, padding_num1;
	unsigned int padding_unit2, padding_unit1;
	unsigned int padding_dirc2, padding_dirc1;
	unsigned int padding_en;
	unsigned int src_x, src_y;
	unsigned int des_x, des_y;
	unsigned int src_resx, des_resx;
	unsigned char *ptr = trans_ptr->get_data_ptr();

	dma_extension *ext_ptr;
	trans_ptr->get_extension(ext_ptr);
	address = ext_ptr->address;
	sar = ext_ptr->sar;
	dar = ext_ptr->dar;
	padding_num2 = ext_ptr->padding_num2;
	padding_num1 = ext_ptr->padding_num1;
	padding_unit2 = ext_ptr->padding_unit2;
	padding_unit1 = ext_ptr->padding_unit1;
	padding_dirc2 = ext_ptr->padding_dirc2;
	padding_dirc1 = ext_ptr->padding_dirc1;
	padding_en = ext_ptr->padding_en;
	src_x = ext_ptr->src_x;
	src_y = ext_ptr->src_y;
	des_x = ext_ptr->des_x;
	des_y = ext_ptr->des_y;
	src_resx = ext_ptr->src_resx;
	des_resx = ext_ptr->des_resx;

	unsigned char *src_ptr;
	unsigned char *dst_ptr;

	if (padding_en != 0) {
//copy Z0
		dst_ptr = ptr + des_x;
		src_ptr = ptr + (des_x - padding_unit1);

		for (i = 0; i < (padding_num1 / padding_unit1); i++) {
			for (j = 0; j < des_y; j++) {
				extend_memcpy(dst_ptr, src_ptr, padding_unit1);
				dst_ptr += des_resx;
				src_ptr += des_resx;
			}
			src_ptr = ptr + (des_x - padding_unit1);
			dst_ptr = ptr + des_x + (1 + i) * padding_unit1;
		}

		if ((padding_num1 % padding_unit1) != 0) {
			dst_ptr = ptr + des_x + (padding_num1 / padding_unit1) * padding_unit1;
			src_ptr = ptr + (des_x - padding_unit1);
			for (i = 0; i < (padding_num1 % padding_unit1); i++) {
				for (j = 0; j < des_y; j++) {
					extend_memcpy(dst_ptr, src_ptr, 1);
					dst_ptr += des_resx;
					src_ptr += des_resx;
				}
				dst_ptr = ptr + des_x + (padding_num1 / padding_unit1) * padding_unit1 + (1 + i) * 1;
				src_ptr = ptr + (des_x - padding_unit1) + (1 + i) * 1;
			}
		}
	}
	trans_ptr->set_response_status(tlm::TLM_OK_RESPONSE);
}

//copy zone define
//  Z0
//  A
void Biu_Bus::padding_operation_y0(tlm::tlm_generic_payload * trans_ptr, sc_core::sc_time & delay)
{
	unsigned int i = 0, j = 0;
	sc_dt::uint64 address;		// create trans's module memory address
	unsigned int sar, dar;
	unsigned int padding_num2, padding_num1;
	unsigned int padding_unit2, padding_unit1;
	unsigned int padding_dirc2, padding_dirc1;
	unsigned int padding_en;
	unsigned int src_x, src_y;
	unsigned int des_x, des_y;
	unsigned int src_resx, des_resx;
	unsigned char *ptr = trans_ptr->get_data_ptr();

	dma_extension *ext_ptr;
	trans_ptr->get_extension(ext_ptr);
	address = ext_ptr->address;
	sar = ext_ptr->sar;
	dar = ext_ptr->dar;
	padding_num2 = ext_ptr->padding_num2;
	padding_num1 = ext_ptr->padding_num1;
	padding_unit2 = ext_ptr->padding_unit2;
	padding_unit1 = ext_ptr->padding_unit1;
	padding_dirc2 = ext_ptr->padding_dirc2;
	padding_dirc1 = ext_ptr->padding_dirc1;
	padding_en = ext_ptr->padding_en;
	src_x = ext_ptr->src_x;
	src_y = ext_ptr->src_y;
	des_x = ext_ptr->des_x;
	des_y = ext_ptr->des_y;
	src_resx = ext_ptr->src_resx;
	des_resx = ext_ptr->des_resx;

	unsigned char *des_ptr = ptr + des_resx * (padding_num2);	//zone A ptr

	unsigned char *src_ptr;
	unsigned char *dst_ptr;

	if (padding_en != 0) {
//copy Z0
		dst_ptr = ptr + (padding_num2 % padding_unit2) * des_resx;
		src_ptr = des_ptr;

		for (i = 0; i < padding_num2 / padding_unit2; i++) {
			for (j = 0; j < padding_unit2; j++) {
				extend_memcpy(dst_ptr, src_ptr, des_x);
				dst_ptr += des_resx;
				src_ptr += des_resx;
			}
			src_ptr = des_ptr;
		}

		if ((padding_num2 % padding_unit2) != 0) {
			dst_ptr = ptr;
			src_ptr = des_ptr + (padding_unit2 - padding_num2 % padding_unit2) * des_resx;
			for (j = 0; j < (padding_num2 % padding_unit2); j++) {
				extend_memcpy(dst_ptr, src_ptr, des_x);
				dst_ptr += des_resx;
				src_ptr += des_resx;
			}
		}
	}
	trans_ptr->set_response_status(tlm::TLM_OK_RESPONSE);
}

//copy zone define
//  A
//  Z0
void Biu_Bus::padding_operation_y1(tlm::tlm_generic_payload * trans_ptr, sc_core::sc_time & delay)
{
	unsigned int i = 0, j = 0;
	sc_dt::uint64 address;		// create trans's module memory address
	unsigned int sar, dar;
	unsigned int padding_num2, padding_num1;
	unsigned int padding_unit2, padding_unit1;
	unsigned int padding_dirc2, padding_dirc1;
	unsigned int padding_en;
	unsigned int src_x, src_y;
	unsigned int des_x, des_y;
	unsigned int src_resx, des_resx;
	unsigned char *ptr = trans_ptr->get_data_ptr();

	dma_extension *ext_ptr;
	trans_ptr->get_extension(ext_ptr);
	address = ext_ptr->address;
	sar = ext_ptr->sar;
	dar = ext_ptr->dar;
	padding_num2 = ext_ptr->padding_num2;
	padding_num1 = ext_ptr->padding_num1;
	padding_unit2 = ext_ptr->padding_unit2;
	padding_unit1 = ext_ptr->padding_unit1;
	padding_dirc2 = ext_ptr->padding_dirc2;
	padding_dirc1 = ext_ptr->padding_dirc1;
	padding_en = ext_ptr->padding_en;
	src_x = ext_ptr->src_x;
	src_y = ext_ptr->src_y;
	des_x = ext_ptr->des_x;
	des_y = ext_ptr->des_y;
	src_resx = ext_ptr->src_resx;
	des_resx = ext_ptr->des_resx;

	unsigned char *des_ptr = ptr;	//zone A ptr

	unsigned char *src_ptr;
	unsigned char *dst_ptr;

	if (padding_en != 0) {
//copy Z0
		dst_ptr = ptr + (des_y * des_resx);
		src_ptr = ptr + (des_y - padding_unit2) * des_resx;

		for (i = 0; i < (padding_num2 / padding_unit2); i++) {
			for (j = 0; j < padding_unit2; j++) {
				extend_memcpy(dst_ptr, src_ptr, des_x);
				dst_ptr += des_resx;
				src_ptr += des_resx;
			}
			src_ptr = ptr + (des_y - padding_unit2) * des_resx;
		}

		if ((padding_num2 % padding_unit2) != 0) {
			dst_ptr = des_ptr + des_y * des_resx + (padding_num2 / padding_unit2) * padding_unit2 * des_resx;
			src_ptr = des_ptr + (des_y - padding_unit2) * des_resx;
			for (j = 0; j < (padding_num2 % padding_unit2); j++) {
				extend_memcpy(dst_ptr, src_ptr, des_x);
				dst_ptr += des_resx;
				src_ptr += des_resx;
			}
		}
	}
	trans_ptr->set_response_status(tlm::TLM_OK_RESPONSE);
}

// copy zone define
//  Z1  |   Z0
//  Z2  |   A
void Biu_Bus::padding_operation_x0y0(tlm::tlm_generic_payload * trans_ptr, sc_core::sc_time & delay)
{
	unsigned int i = 0, j = 0;
	sc_dt::uint64 address;		// create trans's module memory address
	unsigned int sar, dar;
	unsigned int padding_num2, padding_num1;
	unsigned int padding_unit2, padding_unit1;
	unsigned int padding_dirc2, padding_dirc1;
	unsigned int padding_en;
	unsigned int src_x, src_y;
	unsigned int des_x, des_y;
	unsigned int src_resx, des_resx;
	unsigned char *ptr = trans_ptr->get_data_ptr();

	dma_extension *ext_ptr;
	trans_ptr->get_extension(ext_ptr);
	address = ext_ptr->address;
	sar = ext_ptr->sar;
	dar = ext_ptr->dar;
	padding_num2 = ext_ptr->padding_num2;
	padding_num1 = ext_ptr->padding_num1;
	padding_unit2 = ext_ptr->padding_unit2;
	padding_unit1 = ext_ptr->padding_unit1;
	padding_dirc2 = ext_ptr->padding_dirc2;
	padding_dirc1 = ext_ptr->padding_dirc1;
	padding_en = ext_ptr->padding_en;
	src_x = ext_ptr->src_x;
	src_y = ext_ptr->src_y;
	des_x = ext_ptr->des_x;
	des_y = ext_ptr->des_y;
	src_resx = ext_ptr->src_resx;
	des_resx = ext_ptr->des_resx;

	unsigned char *des_ptr = (ptr + (des_resx * (padding_num2) + padding_num1));	//zone A ptr

	unsigned char *src_ptr;
	unsigned char *dst_ptr;

	if (padding_en != 0) {
//copy Z0
		dst_ptr = ptr + padding_num1 + (padding_num2 % padding_unit2) * des_resx;
		src_ptr = des_ptr;

		for (i = 0; i < (padding_num2 / padding_unit2); i++) {
			for (j = 0; j < padding_unit2; j++) {
				extend_memcpy(dst_ptr, src_ptr, des_x);
				dst_ptr += des_resx;
				src_ptr += des_resx;
			}
			src_ptr = des_ptr;
		}

		if ((padding_num2 % padding_unit2) != 0) {
			dst_ptr = ptr + padding_num1;
			src_ptr = des_ptr + (padding_unit2 - padding_num2 % padding_unit2) * des_resx;
			for (j = 0; j < (padding_num2 % padding_unit2); j++) {
				extend_memcpy(dst_ptr, src_ptr, des_x);
				dst_ptr += des_resx;
				src_ptr += des_resx;
			}
		}
//copy Z1
		dst_ptr = ptr + (padding_num1 % padding_unit1);
		src_ptr = ptr + padding_num1;

		for (i = 0; i < (padding_num1 / padding_unit1); i++) {
			for (j = 0; j < padding_num2; j++) {
				extend_memcpy(dst_ptr, src_ptr, padding_unit1);
				dst_ptr += des_resx;
				src_ptr += des_resx;
			}
			src_ptr = ptr + padding_num1;
			dst_ptr = ptr + (padding_num1 % padding_unit1) + (1 + i) * padding_unit1;
		}

		if ((padding_num1 % padding_unit1) != 0) {
			dst_ptr = ptr;
			src_ptr = ptr + padding_num1 + (padding_unit1 - (padding_num1 % padding_unit1));
			for (i = 0; i < (padding_num1 % padding_unit1); i++) {
				for (j = 0; j < padding_num2; j++) {
					extend_memcpy(dst_ptr, src_ptr, 1);
					dst_ptr += des_resx;
					src_ptr += des_resx;
				}
				src_ptr = ptr + padding_num1 + (padding_unit1 - (padding_num1 % padding_unit1)) + (1 + i) * 1;
				dst_ptr = ptr + (1 + i) * 1;
			}
		}
//copy Z2
		dst_ptr = ptr + (des_resx * padding_num2) + (padding_num1 % padding_unit1);
		src_ptr = des_ptr;

		for (i = 0; i < (padding_num1 / padding_unit1); i++) {
			for (j = 0; j < des_y; j++) {
				extend_memcpy(dst_ptr, src_ptr, padding_unit1);
				dst_ptr += des_resx;
				src_ptr += des_resx;
			}

			src_ptr = des_ptr;
			dst_ptr = ptr + (des_resx * padding_num2) + (padding_num1 % padding_unit1) + (1 + i) * padding_unit1;
		}

		if ((padding_num1 % padding_unit1) != 0) {
			dst_ptr = ptr + (des_resx * padding_num2);
			src_ptr = des_ptr + (padding_unit1 - (padding_num1 % padding_unit1));
			for (i = 0; i < (padding_num1 % padding_unit1); i++) {
				for (j = 0; j < des_y; j++) {
					extend_memcpy(dst_ptr, src_ptr, 1);
					dst_ptr += des_resx;
					src_ptr += des_resx;
				}
				src_ptr = des_ptr + (padding_unit1 - (padding_num1 % padding_unit1)) + (1 + i) * 1;
				dst_ptr = ptr + (des_resx * padding_num2) + (1 + i) * 1;
			}
		}
	}
	trans_ptr->set_response_status(tlm::TLM_OK_RESPONSE);
}

// copy zone define
//  Z0  |   Z1
//  A   |   Z2
void Biu_Bus::padding_operation_x1y0(tlm::tlm_generic_payload * trans_ptr, sc_core::sc_time & delay)
{
	unsigned int i, j;
	sc_dt::uint64 address;		// create trans's module memory address
	unsigned int sar, dar;
	unsigned int padding_num2, padding_num1;
	unsigned int padding_unit2, padding_unit1;
	unsigned int padding_dirc2, padding_dirc1;
	unsigned int padding_en;
	unsigned int src_x, src_y;
	unsigned int des_x, des_y;
	unsigned int src_resx, des_resx;
	unsigned char *ptr = trans_ptr->get_data_ptr();

	dma_extension *ext_ptr;
	trans_ptr->get_extension(ext_ptr);
	address = ext_ptr->address;
	sar = ext_ptr->sar;
	dar = ext_ptr->dar;
	padding_num2 = ext_ptr->padding_num2;
	padding_num1 = ext_ptr->padding_num1;
	padding_unit2 = ext_ptr->padding_unit2;
	padding_unit1 = ext_ptr->padding_unit1;
	padding_dirc2 = ext_ptr->padding_dirc2;
	padding_dirc1 = ext_ptr->padding_dirc1;
	padding_en = ext_ptr->padding_en;
	src_x = ext_ptr->src_x;
	src_y = ext_ptr->src_y;
	des_x = ext_ptr->des_x;
	des_y = ext_ptr->des_y;
	src_resx = ext_ptr->src_resx;
	des_resx = ext_ptr->des_resx;

	unsigned char *des_ptr = (ptr + (des_resx * (padding_num2)));

	unsigned char *dst_ptr;
	unsigned char *src_ptr;

	if (padding_en != 0) {
//copy Z0
		dst_ptr = ptr + (padding_num2 % padding_unit2) * des_resx;
		src_ptr = des_ptr;

		for (i = 0; i < (padding_num2 / padding_unit2); i++) {
			for (j = 0; j < padding_unit2; j++) {
				extend_memcpy(dst_ptr, src_ptr, des_x);
				dst_ptr += des_resx;
				src_ptr += des_resx;
			}
			src_ptr = des_ptr;
		}

		if ((padding_num2 % padding_unit2) != 0) {
			dst_ptr = ptr;
			src_ptr = des_ptr + (padding_unit2 - padding_num2 % padding_unit2) * des_resx;
			for (i = 0; i < (padding_num2 % padding_unit2); i++) {
				extend_memcpy(dst_ptr, src_ptr, des_x);
				dst_ptr += des_resx;
				src_ptr += des_resx;
			}
		}
//copy Z1
		dst_ptr = ptr + des_x;
		src_ptr = ptr + (des_x - padding_unit1);

		for (i = 0; i < (padding_num1 / padding_unit1); i++) {
			for (j = 0; j < padding_num2; j++) {
				extend_memcpy(dst_ptr, src_ptr, padding_unit1);
				src_ptr += des_resx;
				dst_ptr += des_resx;
			}
			src_ptr = ptr + (des_x - padding_unit1);
			dst_ptr = ptr + des_x + (1 + i) * padding_unit1;
		}

		if ((padding_num1 % padding_unit1) != 0) {
			dst_ptr = ptr + des_x + (padding_num1 / padding_unit1) * padding_unit1;
			src_ptr = ptr + (des_x - padding_unit1);
			for (i = 0; i < (padding_num1 % padding_unit1); i++) {
				for (j = 0; j < padding_num2; j++) {
					extend_memcpy(dst_ptr, src_ptr, 1);
					dst_ptr += des_resx;
					src_ptr += des_resx;
				}
				dst_ptr = ptr + des_x + (padding_num1 / padding_unit1) * padding_unit1 + (1 + i) * 1;
				src_ptr = ptr + (des_x - padding_unit1) + (1 + i) * 1;
			}

		}
//copy Z2
		dst_ptr = des_ptr + des_x;
		src_ptr = des_ptr + (des_x - padding_unit1);

		for (i = 0; i < (padding_num1 / padding_unit1); i++) {
			for (j = 0; j < des_y; j++) {
				extend_memcpy(dst_ptr, src_ptr, padding_unit1);
				dst_ptr += des_resx;
				src_ptr += des_resx;
			}
			src_ptr = des_ptr + (des_x - padding_unit1);
			dst_ptr = des_ptr + des_x + (1 + i) * padding_unit1;
		}

		if ((padding_num1 % padding_unit1) != 0) {
			dst_ptr = des_ptr + des_x + (padding_num1 / padding_unit1) * padding_unit1;
			src_ptr = des_ptr + (des_x - padding_unit1);
			for (i = 0; i < (padding_num1 % padding_unit1); i++) {
				for (j = 0; j < des_y; j++) {
					extend_memcpy(dst_ptr, src_ptr, 1);
					dst_ptr += des_resx;
					src_ptr += des_resx;
				}
				dst_ptr = des_ptr + des_x + (padding_num1 / padding_unit1) * padding_unit1 + (1 + i) * 1;
				src_ptr = des_ptr + (des_x - padding_unit1) + (1 + i) * 1;
			}
		}
	}
	trans_ptr->set_response_status(tlm::TLM_OK_RESPONSE);
}

// copy zone define
//  Z2  |   A   
//  Z1  |   Z0
void Biu_Bus::padding_operation_x0y1(tlm::tlm_generic_payload * trans_ptr, sc_core::sc_time & delay)
{
	unsigned int i, j;
	sc_dt::uint64 address;		// create trans's module memory address
	unsigned int sar, dar;
	unsigned int padding_num2, padding_num1;
	unsigned int padding_unit2, padding_unit1;
	unsigned int padding_dirc2, padding_dirc1;
	unsigned int padding_en;
	unsigned int src_x, src_y;
	unsigned int des_x, des_y;
	unsigned int src_resx, des_resx;
	unsigned char *ptr = trans_ptr->get_data_ptr();

	dma_extension *ext_ptr;
	trans_ptr->get_extension(ext_ptr);
	address = ext_ptr->address;
	sar = ext_ptr->sar;
	dar = ext_ptr->dar;
	padding_num2 = ext_ptr->padding_num2;
	padding_num1 = ext_ptr->padding_num1;
	padding_unit2 = ext_ptr->padding_unit2;
	padding_unit1 = ext_ptr->padding_unit1;
	padding_dirc2 = ext_ptr->padding_dirc2;
	padding_dirc1 = ext_ptr->padding_dirc1;
	padding_en = ext_ptr->padding_en;
	src_x = ext_ptr->src_x;
	src_y = ext_ptr->src_y;
	des_x = ext_ptr->des_x;
	des_y = ext_ptr->des_y;
	src_resx = ext_ptr->src_resx;
	des_resx = ext_ptr->des_resx;

	unsigned char *des_ptr = (ptr + padding_num1);

	unsigned char *src_ptr;
	unsigned char *dst_ptr;
	//copy ZONE A
	//zone_memcpy_x0y1(trans_ptr);

	if (padding_en != 0) {
//copy Z0
		dst_ptr = des_ptr + des_y * des_resx;
		src_ptr = des_ptr + (des_y - padding_unit2) * des_resx;

		for (i = 0; i < (padding_num2 / padding_unit2); i++) {
			for (j = 0; j < padding_unit2; j++) {
				extend_memcpy(dst_ptr, src_ptr, des_x);
				dst_ptr += des_resx;
				src_ptr += des_resx;
			}
			src_ptr = des_ptr + (des_y - padding_unit2) * des_resx;
		}

		if ((padding_num2 % padding_unit2) != 0) {
			dst_ptr = des_ptr + des_y * des_resx + (padding_num2 / padding_unit2) * padding_unit2 * des_resx;
			src_ptr = des_ptr + (des_y - padding_unit2) * des_resx;
			for (j = 0; j < (padding_num2 % padding_unit2); j++) {
				extend_memcpy(dst_ptr, src_ptr, des_x);
				dst_ptr += des_resx;
				src_ptr += des_resx;
			}
		}
//copy Z1
		dst_ptr = ptr + des_y * des_resx + padding_num1 % padding_unit1;
		src_ptr = des_ptr + des_y * des_resx;

		for (i = 0; i < (padding_num1 / padding_unit1); i++) {
			for (j = 0; j < padding_num2; j++) {
				extend_memcpy(dst_ptr, src_ptr, padding_unit1);
				dst_ptr += des_resx;
				src_ptr += des_resx;
			}
			src_ptr = des_ptr + (des_y * des_resx);
			dst_ptr = ptr + (des_y * des_resx) + padding_num1 % padding_unit1 + (1 + i) * padding_unit1;
		}

		if ((padding_num1 % padding_unit1) != 0) {
			dst_ptr = ptr + des_y * des_resx;
			src_ptr = des_ptr + des_y * des_resx + (padding_unit1 - padding_num1 % padding_unit1);
			for (i = 0; i < (padding_num1 % padding_unit1); i++) {
				for (j = 0; j < padding_num2; j++) {
					extend_memcpy(dst_ptr, src_ptr, 1);
					dst_ptr += des_resx;
					src_ptr += des_resx;
				}
				src_ptr = des_ptr + des_y * des_resx + (padding_unit1 - padding_num1 % padding_unit1) + (1 + i) * 1;
				dst_ptr = ptr + des_y * des_resx + (1 + i) * 1;
			}
		}
//copy Z2
		dst_ptr = ptr + padding_num1 % padding_unit1;
		src_ptr = des_ptr;

		for (i = 0; i < (padding_num1 / padding_unit1); i++) {
			for (j = 0; j < des_y; j++) {
				extend_memcpy(dst_ptr, src_ptr, padding_unit1);
				dst_ptr += des_resx;
				src_ptr += des_resx;
			}
			src_ptr = des_ptr;
			dst_ptr = ptr + padding_num1 % padding_unit1 + (1 + i) * padding_unit1;
		}

		if ((padding_num1 % padding_unit1) != 0) {
			dst_ptr = ptr;
			src_ptr = des_ptr + (padding_unit1 - padding_num1 % padding_unit1);
			for (i = 0; i < (padding_num1 % padding_unit1); i++) {
				for (j = 0; j < des_y; j++) {
					extend_memcpy(dst_ptr, src_ptr, 1);
					src_ptr += des_resx;
					dst_ptr += des_resx;
				}
				src_ptr = des_ptr + (padding_unit1 - padding_num1 % padding_unit1) + (1 + i) * 1;
				dst_ptr = ptr + (1 + i) * 1;
			}
		}
	}
	trans_ptr->set_response_status(tlm::TLM_OK_RESPONSE);
}

// copy zone define
//  A   |   Z2
//  Z0  |   Z1
void Biu_Bus::padding_operation_x1y1(tlm::tlm_generic_payload * trans_ptr, sc_core::sc_time & delay)
{
	unsigned int i, j;
	sc_dt::uint64 address;		// create trans's module memory address
	unsigned int sar, dar;
	unsigned int padding_num2, padding_num1;
	unsigned int padding_unit2, padding_unit1;
	unsigned int padding_dirc2, padding_dirc1;
	unsigned int padding_en;
	unsigned int src_x, src_y;
	unsigned int des_x, des_y;
	unsigned int src_resx, des_resx;
	unsigned char *ptr = trans_ptr->get_data_ptr();

	dma_extension *ext_ptr;
	trans_ptr->get_extension(ext_ptr);
	address = ext_ptr->address;
	sar = ext_ptr->sar;
	dar = ext_ptr->dar;
	padding_num2 = ext_ptr->padding_num2;
	padding_num1 = ext_ptr->padding_num1;
	padding_unit2 = ext_ptr->padding_unit2;
	padding_unit1 = ext_ptr->padding_unit1;
	padding_dirc2 = ext_ptr->padding_dirc2;
	padding_dirc1 = ext_ptr->padding_dirc1;
	padding_en = ext_ptr->padding_en;
	src_x = ext_ptr->src_x;
	src_y = ext_ptr->src_y;
	des_x = ext_ptr->des_x;
	des_y = ext_ptr->des_y;
	src_resx = ext_ptr->src_resx;
	des_resx = ext_ptr->des_resx;

	unsigned char *des_ptr = ptr;

	unsigned char *dst_ptr;
	unsigned char *src_ptr;

	if (padding_en != 0) {
//copy Z0
		dst_ptr = ptr + (des_y * des_resx);
		src_ptr = ptr + (des_y - padding_unit2) * des_resx;

		for (i = 0; i < (padding_num2 / padding_unit2); i++) {
			for (j = 0; j < padding_unit2; j++) {
				extend_memcpy(dst_ptr, src_ptr, des_x);
				dst_ptr += des_resx;
				src_ptr += des_resx;
			}
			src_ptr = ptr + (des_y - padding_unit2) * des_resx;
		}

		if ((padding_num2 % padding_unit2) != 0) {
			dst_ptr = des_ptr + des_y * des_resx + (padding_num2 / padding_unit2) * padding_unit2 * des_resx;
			src_ptr = des_ptr + (des_y - padding_unit2) * des_resx;
			for (j = 0; j < (padding_num2 % padding_unit2); j++) {
				extend_memcpy(dst_ptr, src_ptr, des_x);
				dst_ptr += des_resx;
				src_ptr += des_resx;
			}
		}
//copy Z1
		dst_ptr = ptr + (des_y * des_resx) + des_x;
		src_ptr = ptr + (des_y * des_resx) + (des_x - padding_unit1);

		for (i = 0; i < (padding_num1 / padding_unit1); i++) {
			for (j = 0; j < padding_num2; j++) {
				extend_memcpy(dst_ptr, src_ptr, padding_unit1);
				dst_ptr += des_resx;
				src_ptr += des_resx;
			}
			src_ptr = ptr + des_y * des_resx + (des_x - padding_unit1);
			dst_ptr = ptr + (des_y * des_resx) + des_x + (1 + i) * padding_unit1;
		}

		if ((padding_num1 % padding_unit1) != 0) {
			dst_ptr = ptr + (des_y * des_resx) + des_x + (padding_num1 / padding_unit1) * padding_unit1;
			src_ptr = ptr + (des_y * des_resx) + (des_x - padding_unit1);
			for (i = 0; i < (padding_num1 % padding_unit1); i++) {
				for (j = 0; j < padding_num2; j++) {
					extend_memcpy(dst_ptr, src_ptr, 1);
					dst_ptr += des_resx;
					src_ptr += des_resx;
				}
				dst_ptr = ptr + (des_y * des_resx) + des_x + (padding_num1 / padding_unit1) * padding_unit1 + (1 + i) * 1;
				src_ptr = ptr + (des_y * des_resx) + (des_x - padding_unit1) + (1 + i) * 1;
			}
		}
//copy Z2
		dst_ptr = ptr + des_x;
		src_ptr = ptr + (des_x - padding_unit1);

		for (i = 0; i < (padding_num1 / padding_unit1); i++) {
			for (j = 0; j < des_y; j++) {
				extend_memcpy(dst_ptr, src_ptr, padding_unit1);
				dst_ptr += des_resx;
				src_ptr += des_resx;
			}
			src_ptr = ptr + (des_x - padding_unit1);
			dst_ptr = ptr + des_x + (1 + i) * padding_unit1;
		}

		if ((padding_num1 % padding_unit1) != 0) {
			dst_ptr = ptr + des_x + (padding_num1 / padding_unit1) * padding_unit1;
			src_ptr = ptr + (des_x - padding_unit1);
			for (i = 0; i < (padding_num1 % padding_unit1); i++) {
				for (j = 0; j < des_y; j++) {
					extend_memcpy(dst_ptr, src_ptr, 1);
					dst_ptr += des_resx;
					src_ptr += des_resx;
				}
				dst_ptr = ptr + des_x + (padding_num1 / padding_unit1) * padding_unit1 + (1 + i) * 1;
				src_ptr = ptr + (des_x - padding_unit1) + (1 + i) * 1;
			}
		}

	}
	trans_ptr->set_response_status(tlm::TLM_OK_RESPONSE);
}

void Biu_Bus::dma_shape_operation(tlm::tlm_generic_payload * trans_ptr, sc_core::sc_time & delay)
{
	unsigned int padding_dirc2, padding_dirc1;
	unsigned int padding_num2, padding_num1;
	dma_extension *ext_ptr;
	unsigned int padding_en;

	trans_ptr->get_extension(ext_ptr);
	padding_dirc2 = ext_ptr->padding_dirc2;
	padding_dirc1 = ext_ptr->padding_dirc1;
	padding_num2 = ext_ptr->padding_num2;
	padding_num1 = ext_ptr->padding_num1;
	padding_en = ext_ptr->padding_en;

	if (padding_en) {
		if (!padding_num1 && !padding_dirc2) {
			zone_memcpy_y0(trans_ptr);
			padding_operation_y0(trans_ptr, delay);
		} else if (!padding_num1 && padding_dirc2) {
			zone_memcpy_y1(trans_ptr);
			padding_operation_y1(trans_ptr, delay);
		} else if (!padding_num2 && !padding_dirc1) {
			zone_memcpy_x0(trans_ptr);
			padding_operation_x0(trans_ptr, delay);
		} else if (!padding_num2 && padding_dirc1) {
			zone_memcpy_x1(trans_ptr);
			padding_operation_x1(trans_ptr, delay);
		} else if (!padding_dirc1 && !padding_dirc2) {
			zone_memcpy_x0y0(trans_ptr);
			padding_operation_x0y0(trans_ptr, delay);
		} else if (!padding_dirc1 && padding_dirc2) {
			zone_memcpy_x0y1(trans_ptr);
			padding_operation_x0y1(trans_ptr, delay);
		} else if (padding_dirc1 && !padding_dirc2) {
			zone_memcpy_x1y0(trans_ptr);
			padding_operation_x1y0(trans_ptr, delay);
		} else if (padding_dirc1 && padding_dirc2) {
			zone_memcpy_x1y1(trans_ptr);
			padding_operation_x1y1(trans_ptr, delay);
		}
	} else {
		zone_memcpy_direct(trans_ptr);
	}

}

void Biu_Bus::dma_operation(tlm::tlm_generic_payload * trans_ptr, sc_core::sc_time & delay)
{
	dma_extension *ext_ptr;
	trans_ptr->get_extension(ext_ptr);

	switch (ext_ptr->dma_mode) {
	case DMA_MEM_MODE:
		dma_direct_operation(trans_ptr, delay);
		break;
	case DMA_SHAPE_MODE:
		dma_shape_operation(trans_ptr, delay);
		break;
	case DMA_SC_MODE:
		dma_sc_operation(trans_ptr, delay);
		break;
	case DMA_FIFO_MODE:
		dma_fifo_operation(trans_ptr, delay);
		break;
	default:
		break;
	}
}

void Biu_Bus::sys_dma_sc(tlm::tlm_generic_payload &trans, unsigned int sysdma_num)
{
	unsigned int len, dir = 0;
	sc_dt::uint64 addr;
	unsigned char *p;
	tlm::tlm_phase phase = tlm::BEGIN_REQ;
	sc_core::sc_time delay = sc_core::SC_ZERO_TIME;

	dma_extension *dma_extension_ptr = new dma_extension();
	addr = sys_dma[(SYS_DMASAR0 + 0x30 * sys_dmanum) >> 2];
	len = (sys_dma[(SYS_DMACTL0 + 0x30 * sys_dmanum) >> 2] & 0xfffffc00) >> 10;

	if (ddr_addr_valid(addr, len)) {
		dir = 1;
	} else {
		addr = sys_dma[(SYS_DMADAR0 + 0x30 * sys_dmanum) >> 2];
		if (ddr_addr_valid(addr, len))
			dir = 0;
	}

	if (dir) {		// Write
		addr = sys_dma[(SYS_DMASAR0 + 0x30 * sys_dmanum) >> 2];
		p = (unsigned char *)&ddr_memory[addr - ddr_memory_base];
		trans.set_command(tlm::TLM_WRITE_COMMAND);
		addr = sys_dma[(SYS_DMADAR0 + 0x30 * sys_dmanum) >> 2];
		trans.set_address(addr);
	} else {		// Read
		addr = sys_dma[(SYS_DMADAR0 + 0x30 * sys_dmanum) >> 2];
		p = (unsigned char *)&ddr_memory[addr - ddr_memory_base];
		trans.set_command(tlm::TLM_READ_COMMAND);
		addr = sys_dma[(SYS_DMASAR0 + 0x30 * sys_dmanum) >> 2];
		trans.set_address(addr);
	}

	trans.set_data_length(len);
	trans.set_data_ptr(p);
	trans.set_response_status(tlm::TLM_INCOMPLETE_RESPONSE);

	dma_extension_ptr->flag = SYS_DMA_DATA;
	dma_extension_ptr->ch_num = sys_dmanum;
	dma_extension_ptr->sar = sys_dma[(SYS_DMASAR0 + 0x30 * sys_dmanum) >> 2];
	dma_extension_ptr->dar = sys_dma[(SYS_DMADAR0 + 0x30 * sys_dmanum) >> 2];
	dma_extension_ptr->dma_mode = DMA_SC_MODE;
	dma_extension_ptr->src_gsc = sys_dma[(SYS_DMASGR0 + 0x30 * sys_dmanum) >> 2] >> 20;
	dma_extension_ptr->src_gso = sys_dma[(SYS_DMASGR0 + 0x30 * sys_dmanum) >> 2] & 0xfffff;
	dma_extension_ptr->des_dsc = sys_dma[(SYS_DMADSR0 + 0x30 * sys_dmanum) >> 2] >> 20;
	dma_extension_ptr->des_dso = sys_dma[(SYS_DMADSR0 + 0x30 * sys_dmanum) >> 2] & 0xfffff;

	dma_extension_ptr->src_x = dma_extension_ptr->src_gsc;
	if (dma_extension_ptr->src_x != 0) {
		dma_extension_ptr->src_y = len / dma_extension_ptr->src_x;
	} else {
		dma_extension_ptr->src_y = 0;
	}
	dma_extension_ptr->des_x = dma_extension_ptr->des_dsc;
	if (dma_extension_ptr->des_x != 0) {
		dma_extension_ptr->des_y = len / dma_extension_ptr->des_x;
	} else {
		dma_extension_ptr->des_y = 0;
	}

	dma_extension_ptr->src_resx = dma_extension_ptr->src_gso;
	dma_extension_ptr->des_resx = dma_extension_ptr->des_dso;
	dma_extension_ptr->dma_ctl = sys_dma[(SYS_DMACTL0 + 0x30 * sys_dmanum) >> 2];

	trans.set_extension(dma_extension_ptr);

	dma_bus_init_socket->nb_transport_fw(trans, phase, delay);
}

void Biu_Bus::sys_dma_int2ext(tlm::tlm_generic_payload &trans, unsigned int sysdma_num)
{
	unsigned int len, dir = 0;
	sc_dt::uint64 addr;
	unsigned char *p;
	tlm::tlm_phase phase = tlm::BEGIN_REQ;
	sc_core::sc_time delay = sc_core::SC_ZERO_TIME;

	dma_extension *dma_extension_ptr = new dma_extension();
	addr = sys_dma[(SYS_DMASAR0 + 0x30 * sys_dmanum) >> 2];
	len = (sys_dma[(SYS_DMACTL0 + 0x30 * sys_dmanum) >> 2] & 0xfffffc00) >> 10;
	if (ddr_addr_valid(addr, len)) {
		dir = 1;
	} else {
		addr = sys_dma[(SYS_DMADAR0 + 0x30 * sys_dmanum) >> 2];
		if (ddr_addr_valid(addr, len))
			dir = 0;
	}

	if (dir) {		// Write
		addr = sys_dma[(SYS_DMASAR0 + 0x30 * sys_dmanum) >> 2];
		p = (unsigned char *)&ddr_memory[addr - ddr_memory_base];
		trans.set_command(tlm::TLM_WRITE_COMMAND);
		addr = sys_dma[(SYS_DMADAR0 + 0x30 * sys_dmanum) >> 2];
		trans.set_address(addr);
	} else {		// Read
		addr = sys_dma[(SYS_DMADAR0 + 0x30 * sys_dmanum) >> 2];
		p = (unsigned char *)&ddr_memory[addr - ddr_memory_base];
		trans.set_command(tlm::TLM_READ_COMMAND);
		addr = sys_dma[(SYS_DMASAR0 + 0x30 * sys_dmanum) >> 2];
		trans.set_address(addr);
	}

	trans.set_data_length(len);
	trans.set_data_ptr(p);
	trans.set_response_status(tlm::TLM_INCOMPLETE_RESPONSE);

	dma_extension_ptr->flag = SYS_DMA_DATA;
	dma_extension_ptr->ch_num = sys_dmanum;
	dma_extension_ptr->sar = sys_dma[(SYS_DMASAR0 + 0x30 * sys_dmanum) >> 2];
	dma_extension_ptr->dar = sys_dma[(SYS_DMADAR0 + 0x30 * sys_dmanum) >> 2];
	dma_extension_ptr->dma_mode = DMA_MEM_MODE;
	dma_extension_ptr->src_gsc = sys_dma[(SYS_DMASGR0 + 0x30 * sys_dmanum) >> 2] >> 20;
	dma_extension_ptr->src_gso = sys_dma[(SYS_DMASGR0 + 0x30 * sys_dmanum) >> 2] & 0xfffff;
	dma_extension_ptr->des_dsc = sys_dma[(SYS_DMADSR0 + 0x30 * sys_dmanum) >> 2] >> 20;
	dma_extension_ptr->des_dso = sys_dma[(SYS_DMADSR0 + 0x30 * sys_dmanum) >> 2] & 0xfffff;

	dma_extension_ptr->src_x = dma_extension_ptr->src_gsc;
	if (dma_extension_ptr->src_x != 0) {
		dma_extension_ptr->src_y = len / dma_extension_ptr->src_x;
	} else {
		dma_extension_ptr->src_y = 0;
	}
	dma_extension_ptr->des_x = dma_extension_ptr->des_dsc;
	if (dma_extension_ptr->des_x != 0) {
		dma_extension_ptr->des_y = len / dma_extension_ptr->des_x;
	} else {
		dma_extension_ptr->des_y = 0;
	}

	dma_extension_ptr->src_resx = dma_extension_ptr->src_gso;
	dma_extension_ptr->des_resx = dma_extension_ptr->des_dso;
	dma_extension_ptr->dma_ctl = sys_dma[(SYS_DMACTL0 + 0x30 * sys_dmanum) >> 2];

	trans.set_extension(dma_extension_ptr);

	dma_bus_init_socket->nb_transport_fw(trans, phase, delay);
}

void Biu_Bus::sys_dma_process(tlm::tlm_generic_payload &trans, unsigned int sysdma_num)
{
	unsigned int dmactl;
	
	sys_dma[SYS_DMABUSY >> 2] |= (0x1 << (sys_dmanum));
	dmactl = sys_dma[(SYS_DMACTL0 + 0x30 * sys_dmanum) >> 2];
	
	if ((dmactl & 0x80) || (dmactl & 0x100)) {	//scatter gather
			sys_dma_sc(trans, sysdma_num);
	} else { 								//normal
			sys_dma_int2ext(trans, sysdma_num);
	}
}

#define BUFSIZE (64*1024)
void Biu_Bus::ddr_memory_init(char *file, unsigned int addr)
{
	int fd, len = 0;
	unsigned int i = 0;
	unsigned char *buf;
	addr -= ddr_memory_base;

	if (file != NULL) {

		fd = open(file, O_RDONLY);
		if (fd == -1) {
			printf("can't open file %s.\r\n", file);
			exit(-1);
		}

		buf = (unsigned char *)malloc(BUFSIZE);
		if (buf == NULL) {
			printf("can't malloc buf 64K.\r\n");
			exit(-1);
		}

		for (i = 0; i < ddr_memory_size; i++) {
			len = read(fd, buf, BUFSIZE);
			if (len == -1)
				break;

			memcpy(&ddr_memory[addr + i * BUFSIZE], buf, len);

			if (len != BUFSIZE)
				break;
		}

		free(buf);
		printf("\nddr_memory_init. get data from file %s\t", file);
		printf("i = %d len = %d.\r\n", i, i * BUFSIZE + len);
	} else {
		printf("have no bin-file it will be skip\n\r");
	}
}
