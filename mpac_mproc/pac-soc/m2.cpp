#include "mpac-mproc-define.h"
#include "pac-parser.h"
#include "pac-socshm-prot.h"
#include "pac-soc.h"
#include "pac-m2-bus.h"

void M2_Bus::dma_direct_operation(tlm::tlm_generic_payload * trans_ptr, sc_core::sc_time & delay)
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

void M2_Bus::dma_sc_operation(tlm::tlm_generic_payload * trans_ptr, sc_core::sc_time & delay)
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

void M2_Bus::dma_fifo_operation(tlm::tlm_generic_payload * trans_ptr, sc_core::sc_time & delay)
{
}

void M2_Bus::zone_memcpy_direct(tlm::tlm_generic_payload * trans_ptr)
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

	src_addr = addr - m2_mem_base;
	tmp_addr = addr - m2_mem_base;
	des_ptr = ptr;
	tmp_ptr = ptr;

	if (cmd == tlm::TLM_READ_COMMAND) {
		if (addr_valid(addr, len)) {	// local m2 mem space
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

				*des_ptr = dmem_m2_mem[src_addr];
			}
		}
	} else {
		if (addr_valid(addr, len)) {	// local m2 mem space
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

				dmem_m2_mem[src_addr] = *des_ptr;
			}
		}
	}
}

void M2_Bus::zone_memcpy_x0(tlm::tlm_generic_payload * trans_ptr)
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

	src_addr = addr - m2_mem_base;
	tmp_addr = addr - m2_mem_base;
	des_ptr = ptr + padding_num1;
	tmp_ptr = ptr + padding_num1;

	if (cmd == tlm::TLM_READ_COMMAND) {
		if (addr_valid(addr, len)) {	// local m2 mem space
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

				*des_ptr = dmem_m2_mem[src_addr];
			}
		}
	} else {
		if (addr_valid(addr, len)) {	// local m2 mem space
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

				dmem_m2_mem[src_addr] = *des_ptr;
			}
		}
	}
}

void M2_Bus::zone_memcpy_x1(tlm::tlm_generic_payload * trans_ptr)
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

	src_addr = addr - m2_mem_base;
	tmp_addr = addr - m2_mem_base;
	des_ptr = ptr;
	tmp_ptr = ptr;

	if (cmd == tlm::TLM_READ_COMMAND) {
		if (addr_valid(addr, len)) {	// local m2 mem space
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

				*des_ptr = dmem_m2_mem[src_addr];
			}
		}
	} else {
		if (addr_valid(addr, len)) {	// local m2 mem space
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

				dmem_m2_mem[src_addr] = *des_ptr;
			}
		}
	}
}

void M2_Bus::zone_memcpy_y0(tlm::tlm_generic_payload * trans_ptr)
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

	src_addr = addr - m2_mem_base;
	tmp_addr = addr - m2_mem_base;
	des_ptr = ptr + (des_resx * (padding_num2));
	tmp_ptr = ptr + (des_resx * (padding_num2));

	if (cmd == tlm::TLM_READ_COMMAND) {
		if (addr_valid(addr, len)) {	// local m2 mem space
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

				*des_ptr = dmem_m2_mem[src_addr];
			}
		}
	} else {
		if (addr_valid(addr, len)) {	// local m2 mem space
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

				dmem_m2_mem[src_addr] = *des_ptr;
			}
		}
	}
}

void M2_Bus::zone_memcpy_y1(tlm::tlm_generic_payload * trans_ptr)
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

	src_addr = addr - m2_mem_base;
	tmp_addr = addr - m2_mem_base;
	des_ptr = ptr;
	tmp_ptr = ptr;

	if (cmd == tlm::TLM_READ_COMMAND) {
		if (addr_valid(addr, len)) {	// local m2 mem space
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

				*des_ptr = dmem_m2_mem[src_addr];
			}
		}
	} else {
		if (addr_valid(addr, len)) {	// local m2 mem space
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

				dmem_m2_mem[src_addr] = *des_ptr;
			}
		}
	}
}

void M2_Bus::zone_memcpy_x0y0(tlm::tlm_generic_payload * trans_ptr)
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

	src_addr = addr - m2_mem_base;
	tmp_addr = addr - m2_mem_base;
	des_ptr = (ptr + (des_resx * (padding_num2) + padding_num1));
	tmp_ptr = (ptr + (des_resx * (padding_num2) + padding_num1));

	if (cmd == tlm::TLM_READ_COMMAND) {
		if (addr_valid(addr, len)) {	// local m2 mem space
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

				*des_ptr = dmem_m2_mem[src_addr];
			}
		}
	} else {
		if (addr_valid(addr, len)) {	// local m2 mem space
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

				dmem_m2_mem[src_addr] = *des_ptr;
			}
		}
	}
}

void M2_Bus::zone_memcpy_x1y0(tlm::tlm_generic_payload * trans_ptr)
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

	src_addr = addr - m2_mem_base;
	tmp_addr = addr - m2_mem_base;
	des_ptr = (ptr + (des_resx * (padding_num2)));
	tmp_ptr = (ptr + (des_resx * (padding_num2)));

	if (cmd == tlm::TLM_READ_COMMAND) {
		if (addr_valid(addr, len)) {	// local m2 mem space
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

				*des_ptr = dmem_m2_mem[src_addr];
			}
		}
	} else {
		if (addr_valid(addr, len)) {	// local m2 mem space
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

				dmem_m2_mem[src_addr] = *des_ptr;
			}
		}
	}
}

void M2_Bus::zone_memcpy_x0y1(tlm::tlm_generic_payload * trans_ptr)
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

	src_addr = addr - m2_mem_base;
	tmp_addr = addr - m2_mem_base;
	des_ptr = (ptr + padding_num1);
	tmp_ptr = (ptr + padding_num1);

	if (cmd == tlm::TLM_READ_COMMAND) {
		if (addr_valid(addr, len)) {	// local m2 mem space
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

				*des_ptr = dmem_m2_mem[src_addr];
			}
		}
	} else {
		if (addr_valid(addr, len))	// local m2 mem space
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

					dmem_m2_mem[src_addr] = *des_ptr;
				}
			}
	}
}

void M2_Bus::zone_memcpy_x1y1(tlm::tlm_generic_payload * trans_ptr)
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

	src_addr = addr - m2_mem_base;
	tmp_addr = addr - m2_mem_base;
	des_ptr = ptr;
	tmp_ptr = ptr;

	if (cmd == tlm::TLM_READ_COMMAND) {
		if (addr_valid(addr, len)) {	// local m2 mem space
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

				*des_ptr = dmem_m2_mem[src_addr];
			}
		}
	} else {
		if (addr_valid(addr, len)) {	// local m2 mem space
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

				dmem_m2_mem[src_addr] = *des_ptr;
			}
		}
	}
}

void M2_Bus::extend_memcpy(unsigned char *dst, unsigned char *src, unsigned int len)
{
	unsigned int i;
	for (i = 0; i < len; i++) {
		dst[i] = src[i];
	}
}

// copy zone define
//  Z0  |   A
void M2_Bus::padding_operation_x0(tlm::tlm_generic_payload * trans_ptr, sc_core::sc_time & delay)
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
void M2_Bus::padding_operation_x1(tlm::tlm_generic_payload * trans_ptr, sc_core::sc_time & delay)
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
void M2_Bus::padding_operation_y0(tlm::tlm_generic_payload * trans_ptr, sc_core::sc_time & delay)
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
void M2_Bus::padding_operation_y1(tlm::tlm_generic_payload * trans_ptr, sc_core::sc_time & delay)
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
void M2_Bus::padding_operation_x0y0(tlm::tlm_generic_payload * trans_ptr, sc_core::sc_time & delay)
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

//copy ZONE A
	//zone_memcpy_x0y0(trans_ptr);

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
void M2_Bus::padding_operation_x1y0(tlm::tlm_generic_payload * trans_ptr, sc_core::sc_time & delay)
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

//copy ZONE A
	//zone_memcpy_x1y0(trans_ptr);

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
void M2_Bus::padding_operation_x0y1(tlm::tlm_generic_payload * trans_ptr, sc_core::sc_time & delay)
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
			dst_ptr = ptr + (des_y * des_resx) + (padding_num1 % padding_unit1) + (1 + i) * padding_unit1;
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
void M2_Bus::padding_operation_x1y1(tlm::tlm_generic_payload * trans_ptr, sc_core::sc_time & delay)
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

//copy ZONE A
	//zone_memcpy_x1y1(trans_ptr);

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

void M2_Bus::dma_shape_operation(tlm::tlm_generic_payload * trans_ptr, sc_core::sc_time & delay)
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

void M2_Bus::dma_operation(tlm::tlm_generic_payload * trans_ptr, sc_core::sc_time & delay)
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

///////////////////////////////////////////////////////////
// Sent out
//////////////////////////////////////////////////////////
int M2_Bus::m2_dma_fifo(tlm::tlm_generic_payload & trans, unsigned int m2_dmanum)
{
	unsigned int dir, len;
	sc_dt::uint64 src_addr, dst_addr;
	dir = (m2_dma[(M2_DMACTL0 + 0x40 * m2_dmanum) >> 2] & 8) >> 3;	// read : dir = 0; write : dir =1;
	len = (m2_dma[(M2_DMACTL0 + 0x40 * m2_dmanum) >> 2] & 0xfffff000) >> 12;
	src_addr = m2_dma[(M2_DMASAR0 + 0x40 * m2_dmanum) >> 2];
	dst_addr = m2_dma[(M2_DMADAR0 + 0x40 * m2_dmanum) >> 2];

	if (dir) {
		if (!addr_valid(src_addr, len))
			return -1;
	} else {
		if (!addr_valid(dst_addr, len))
			return -1;
	}

	return 0;
}

int M2_Bus::m2_dma_sc(tlm::tlm_generic_payload & trans, unsigned int m2_dmanum)
{
	unsigned int dir, len;
	sc_dt::uint64 src_addr, dst_addr;
	unsigned char *p;
	tlm::tlm_sync_enum ret;
	tlm::tlm_phase phase = tlm::BEGIN_REQ;
	sc_core::sc_time delay = sc_core::SC_ZERO_TIME;
	dma_extension *dma_extension_ptr = new dma_extension();

	dir = (m2_dma[(M2_DMACTL0 + 0x40 * m2_dmanum) >> 2] & 8) >> 3;	// read : dir = 0; write : dir =1;
	len = (m2_dma[(M2_DMACTL0 + 0x40 * m2_dmanum) >> 2] & 0xfffff000) >> 12;
	src_addr = m2_dma[(M2_DMASAR0 + 0x40 * m2_dmanum) >> 2];
	dst_addr = m2_dma[(M2_DMADAR0 + 0x40 * m2_dmanum) >> 2];
	if (len == 0) {
		len =
			((m2_dma[(M2_DMASHAPE0 + 0x40 * m2_dmanum) >> 2] >> 8) & 0xff) *
			((m2_dma[(M2_DMASHAPE0 + 0x40 * m2_dmanum) >> 2]) & 0xff);
	}

	if (dir) {
		if (!addr_valid(src_addr, len))
			return -1;

		p = (unsigned char *)&dmem_m2_mem[m2_dma[(M2_DMASAR0 + 0x40 * m2_dmanum) >> 2] - m2_mem_base];
		trans.set_command(tlm::TLM_WRITE_COMMAND);
		trans.set_address(dst_addr);
		trans.set_data_ptr(p);
		trans.set_data_length(len);
		trans.set_response_status(tlm::TLM_INCOMPLETE_RESPONSE);
	} else {
		if (!addr_valid(dst_addr, len))
			return -1;

		p = (unsigned char *)&dmem_m2_mem[m2_dma[(M2_DMADAR0 + 0x40 * m2_dmanum) >> 2] - m2_mem_base];
		trans.set_command(tlm::TLM_READ_COMMAND);
		trans.set_address(src_addr);
		trans.set_data_ptr(p);
		trans.set_data_length(len);
		trans.set_response_status(tlm::TLM_INCOMPLETE_RESPONSE);
	}

	dma_extension_ptr->flag = M2_DMA_DATA;
	dma_extension_ptr->ch_num = m2_dmanum;
	dma_extension_ptr->address = (sc_dt::uint64) dmem_m2_mem;
	dma_extension_ptr->sar = m2_dma[(M2_DMASAR0 + 0x40 * m2_dmanum) >> 2];
	dma_extension_ptr->dar = m2_dma[(M2_DMADAR0 + 0x40 * m2_dmanum) >> 2];
	dma_extension_ptr->dma_mode = DMA_SC_MODE;
	dma_extension_ptr->padding_num2 = (m2_dma[(M2_DMAPDCTL0 + 0x40 * m2_dmanum) >> 2] >> 24) & 0xff;
	dma_extension_ptr->padding_num1 = (m2_dma[(M2_DMAPDCTL0 + 0x40 * m2_dmanum) >> 2] >> 16) & 0xff;
	dma_extension_ptr->padding_unit2 = (m2_dma[(M2_DMAPDCTL0 + 0x40 * m2_dmanum) >> 2] >> 12) & 0xf;
	dma_extension_ptr->padding_unit1 = (m2_dma[(M2_DMAPDCTL0 + 0x40 * m2_dmanum) >> 2] >> 8) & 0xf;
	dma_extension_ptr->padding_dirc2 = (m2_dma[(M2_DMAPDCTL0 + 0x40 * m2_dmanum) >> 2] >> 5) & 0x1;
	dma_extension_ptr->padding_dirc1 = (m2_dma[(M2_DMAPDCTL0 + 0x40 * m2_dmanum) >> 2] >> 4) & 0x1;
	dma_extension_ptr->padding_en = (m2_dma[(M2_DMAPDCTL0 + 0x40 * m2_dmanum) >> 2] >> 0) & 0x1;

	dma_extension_ptr->src_gsc = m2_dma[(M2_DMASGR0 + 0x40 * m2_dmanum) >> 2] >> 20;
	dma_extension_ptr->src_gso = m2_dma[(M2_DMASGR0 + 0x40 * m2_dmanum) >> 2] & 0xfffff;
	dma_extension_ptr->des_dsc = m2_dma[(M2_DMADSR0 + 0x40 * m2_dmanum) >> 2] >> 20;
	dma_extension_ptr->des_dso = m2_dma[(M2_DMADSR0 + 0x40 * m2_dmanum) >> 2] & 0xfffff;

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

	dma_extension_ptr->dma_ctl = m2_dma[(M2_DMACTL0 + 0x40 * m2_dmanum) >> 2];

	trans.set_extension(dma_extension_ptr);
	ret = dma_bus_init_socket->nb_transport_fw(trans, phase, delay);

	return 0;
}

int M2_Bus::m2_dma_shape(tlm::tlm_generic_payload & trans, unsigned int m2_dmanum)
{
	unsigned int dir, len;
	sc_dt::uint64 src_addr, dst_addr;
	unsigned char *p;
	tlm::tlm_sync_enum ret;
	tlm::tlm_phase phase = tlm::BEGIN_REQ;
	sc_core::sc_time delay = sc_core::SC_ZERO_TIME;
	dma_extension *dma_extension_ptr = new dma_extension();

	dir = (m2_dma[(M2_DMACTL0 + 0x40 * m2_dmanum) >> 2] & 8) >> 3;	// read : dir = 0; write : dir =1;
	len = (m2_dma[(M2_DMACTL0 + 0x40 * m2_dmanum) >> 2] & 0xfffff000) >> 12;
	src_addr = m2_dma[(M2_DMASAR0 + 0x40 * m2_dmanum) >> 2];
	dst_addr = m2_dma[(M2_DMADAR0 + 0x40 * m2_dmanum) >> 2];
	if (len == 0) {
		len =
			((m2_dma[(M2_DMASHAPE0 + 0x40 * m2_dmanum) >> 2] >> 8) & 0xff) *
			((m2_dma[(M2_DMASHAPE0 + 0x40 * m2_dmanum) >> 2]) & 0xff);
	}

	if (dir) {
		if (!addr_valid(src_addr, len))
			return -1;

		p = (unsigned char *)&dmem_m2_mem[m2_dma[(M2_DMASAR0 + 0x40 * m2_dmanum) >> 2] - m2_mem_base];
		trans.set_command(tlm::TLM_WRITE_COMMAND);
		trans.set_address(dst_addr);
		trans.set_data_ptr(p);
		trans.set_data_length(len);
		trans.set_response_status(tlm::TLM_INCOMPLETE_RESPONSE);
	} else {
		if (!addr_valid(dst_addr, len))
			return -1;

		p = (unsigned char *)&dmem_m2_mem[m2_dma[(M2_DMADAR0 + 0x40 * m2_dmanum) >> 2] - m2_mem_base];
		trans.set_command(tlm::TLM_READ_COMMAND);
		trans.set_address(src_addr);
		trans.set_data_ptr(p);
		trans.set_data_length(len);
		trans.set_response_status(tlm::TLM_INCOMPLETE_RESPONSE);
	}

	dma_extension_ptr->flag = M2_DMA_DATA;
	dma_extension_ptr->ch_num = m2_dmanum;
	dma_extension_ptr->address = (sc_dt::uint64) dmem_m2_mem;
	dma_extension_ptr->sar = m2_dma[(M2_DMASAR0 + 0x40 * m2_dmanum) >> 2];
	dma_extension_ptr->dar = m2_dma[(M2_DMADAR0 + 0x40 * m2_dmanum) >> 2];
	dma_extension_ptr->dma_mode = DMA_SHAPE_MODE;
	dma_extension_ptr->padding_num2 = (m2_dma[(M2_DMAPDCTL0 + 0x40 * m2_dmanum) >> 2] >> 24) & 0xff;
	dma_extension_ptr->padding_num1 = (m2_dma[(M2_DMAPDCTL0 + 0x40 * m2_dmanum) >> 2] >> 16) & 0xff;
	dma_extension_ptr->padding_unit2 = (m2_dma[(M2_DMAPDCTL0 + 0x40 * m2_dmanum) >> 2] >> 12) & 0xf;
	dma_extension_ptr->padding_unit1 = (m2_dma[(M2_DMAPDCTL0 + 0x40 * m2_dmanum) >> 2] >> 8) & 0xf;
	dma_extension_ptr->padding_dirc2 = (m2_dma[(M2_DMAPDCTL0 + 0x40 * m2_dmanum) >> 2] >> 5) & 0x1;
	dma_extension_ptr->padding_dirc1 = (m2_dma[(M2_DMAPDCTL0 + 0x40 * m2_dmanum) >> 2] >> 4) & 0x1;
	dma_extension_ptr->padding_en = (m2_dma[(M2_DMAPDCTL0 + 0x40 * m2_dmanum) >> 2] >> 0) & 0x1;

	dma_extension_ptr->src_x = (m2_dma[(M2_DMASHAPE0 + 0x40 * m2_dmanum) >> 2] >> 24) & 0xff;
	dma_extension_ptr->src_y = (m2_dma[(M2_DMASHAPE0 + 0x40 * m2_dmanum) >> 2] >> 16) & 0xff;
	dma_extension_ptr->des_x = (m2_dma[(M2_DMASHAPE0 + 0x40 * m2_dmanum) >> 2] >> 8) & 0xff;
	dma_extension_ptr->des_y = (m2_dma[(M2_DMASHAPE0 + 0x40 * m2_dmanum) >> 2]) & 0xff;

	dma_extension_ptr->src_resx = m2_dma[(M2_DMARES0 + 0x40 * m2_dmanum) >> 2] >> 16;
	dma_extension_ptr->des_resx = m2_dma[(M2_DMARES0 + 0x40 * m2_dmanum) >> 2] & 0x0000ffff;

	dma_extension_ptr->src_gsc = m2_dma[(M2_DMASGR0 + 0x40 * m2_dmanum) >> 2] >> 20;
	dma_extension_ptr->src_gso = m2_dma[(M2_DMASGR0 + 0x40 * m2_dmanum) >> 2] & 0xfffff;
	dma_extension_ptr->des_dsc = m2_dma[(M2_DMADSR0 + 0x40 * m2_dmanum) >> 2] >> 20;
	dma_extension_ptr->des_dso = m2_dma[(M2_DMADSR0 + 0x40 * m2_dmanum) >> 2] & 0xfffff;

	dma_extension_ptr->dma_ctl = m2_dma[(M2_DMACTL0 + 0x40 * m2_dmanum) >> 2];

	trans.set_extension(dma_extension_ptr);
	ret = dma_bus_init_socket->nb_transport_fw(trans, phase, delay);

	return 0;
}

int M2_Bus::m2_dma_int2ext(tlm::tlm_generic_payload & trans, unsigned int m2_dmanum)
{
	unsigned int dir, len;
	sc_dt::uint64 src_addr, dst_addr;
	unsigned char *p;
	tlm::tlm_sync_enum ret;
	tlm::tlm_phase phase = tlm::BEGIN_REQ;
	sc_core::sc_time delay = sc_core::SC_ZERO_TIME;
	dma_extension *dma_extension_ptr = new dma_extension();

	dir = (m2_dma[(M2_DMACTL0 + 0x40 * m2_dmanum) >> 2] & 8) >> 3;	// read : dir = 0; write : dir =1;
	len = (m2_dma[(M2_DMACTL0 + 0x40 * m2_dmanum) >> 2] & 0xfffff000) >> 12;
	src_addr = m2_dma[(M2_DMASAR0 + 0x40 * m2_dmanum) >> 2];
	dst_addr = m2_dma[(M2_DMADAR0 + 0x40 * m2_dmanum) >> 2];
	if (len == 0) {
		len =
			((m2_dma[(M2_DMASHAPE0 + 0x40 * m2_dmanum) >> 2] >> 8) & 0xff) *
			((m2_dma[(M2_DMASHAPE0 + 0x40 * m2_dmanum) >> 2]) & 0xff);
	}

	if (dir) {
		if (!addr_valid(src_addr, len))
			return -1;

		p = (unsigned char *)&dmem_m2_mem[m2_dma[(M2_DMASAR0 + 0x40 * m2_dmanum) >> 2] - m2_mem_base];
		trans.set_command(tlm::TLM_WRITE_COMMAND);
		trans.set_address(dst_addr);
		trans.set_data_ptr(p);
		trans.set_data_length(len);
		trans.set_response_status(tlm::TLM_INCOMPLETE_RESPONSE);
	} else {
		if (!addr_valid(dst_addr, len))
			return -1;

		p = (unsigned char *)&dmem_m2_mem[m2_dma[(M2_DMADAR0 + 0x40 * m2_dmanum) >> 2] - m2_mem_base];
		trans.set_command(tlm::TLM_READ_COMMAND);
		trans.set_address(src_addr);
		trans.set_data_ptr(p);
		trans.set_data_length(len);
		trans.set_response_status(tlm::TLM_INCOMPLETE_RESPONSE);
	}

	dma_extension_ptr->flag = M2_DMA_DATA;
	dma_extension_ptr->ch_num = m2_dmanum;
	dma_extension_ptr->address = (sc_dt::uint64) dmem_m2_mem;
	dma_extension_ptr->sar = m2_dma[(M2_DMASAR0 + 0x40 * m2_dmanum) >> 2];
	dma_extension_ptr->dar = m2_dma[(M2_DMADAR0 + 0x40 * m2_dmanum) >> 2];
	dma_extension_ptr->dma_mode = DMA_MEM_MODE;
	dma_extension_ptr->padding_num2 = (m2_dma[(M2_DMAPDCTL0 + 0x40 * m2_dmanum) >> 2] >> 24) & 0xff;
	dma_extension_ptr->padding_num1 = (m2_dma[(M2_DMAPDCTL0 + 0x40 * m2_dmanum) >> 2] >> 16) & 0xff;
	dma_extension_ptr->padding_unit2 = (m2_dma[(M2_DMAPDCTL0 + 0x40 * m2_dmanum) >> 2] >> 12) & 0xf;
	dma_extension_ptr->padding_unit1 = (m2_dma[(M2_DMAPDCTL0 + 0x40 * m2_dmanum) >> 2] >> 8) & 0xf;
	dma_extension_ptr->padding_dirc2 = (m2_dma[(M2_DMAPDCTL0 + 0x40 * m2_dmanum) >> 2] >> 5) & 0x1;
	dma_extension_ptr->padding_dirc1 = (m2_dma[(M2_DMAPDCTL0 + 0x40 * m2_dmanum) >> 2] >> 4) & 0x1;
	dma_extension_ptr->padding_en = (m2_dma[(M2_DMAPDCTL0 + 0x40 * m2_dmanum) >> 2] >> 0) & 0x1;

	dma_extension_ptr->src_x = (m2_dma[(M2_DMASHAPE0 + 0x40 * m2_dmanum) >> 2] >> 24) & 0xff;
	dma_extension_ptr->src_y = (m2_dma[(M2_DMASHAPE0 + 0x40 * m2_dmanum) >> 2] >> 16) & 0xff;
	dma_extension_ptr->des_x = (m2_dma[(M2_DMASHAPE0 + 0x40 * m2_dmanum) >> 2] >> 8) & 0xff;
	dma_extension_ptr->des_y = (m2_dma[(M2_DMASHAPE0 + 0x40 * m2_dmanum) >> 2]) & 0xff;

	dma_extension_ptr->src_resx = m2_dma[(M2_DMARES0 + 0x40 * m2_dmanum) >> 2] >> 16;
	dma_extension_ptr->des_resx = m2_dma[(M2_DMARES0 + 0x40 * m2_dmanum) >> 2] & 0x0000ffff;

	dma_extension_ptr->src_gsc = m2_dma[(M2_DMASGR0 + 0x40 * m2_dmanum) >> 2] >> 20;
	dma_extension_ptr->src_gso = m2_dma[(M2_DMASGR0 + 0x40 * m2_dmanum) >> 2] & 0xfffff;
	dma_extension_ptr->des_dsc = m2_dma[(M2_DMADSR0 + 0x40 * m2_dmanum) >> 2] >> 20;
	dma_extension_ptr->des_dso = m2_dma[(M2_DMADSR0 + 0x40 * m2_dmanum) >> 2] & 0xfffff;

	dma_extension_ptr->dma_ctl = m2_dma[(M2_DMACTL0 + 0x40 * m2_dmanum) >> 2];

	trans.set_extension(dma_extension_ptr);
	ret = dma_bus_init_socket->nb_transport_fw(trans, phase, delay);

	return 0;
}

int M2_Bus::m2_dma_process(tlm::tlm_generic_payload & trans, unsigned int m2_dmanum)
{
	unsigned int dmactl;
	int ret;

	dmactl = m2_dma[(M2_DMACTL0 + 0x40 * m2_dmanum) >> 2];
	m2_dma[M2_DMASTAT >> 2] = (m2_dma[M2_DMASTAT >> 2] & ~(0xF << m2_dmanum * 4)) | 0x1 << (m2_dmanum * 4);

	if ((dmactl & 0x20) || (dmactl & 0x10)) {	//shape
		ret = m2_dma_shape(trans, m2_dmanum);
	} else if ((dmactl & 0x200) || (dmactl & 0x100)) {	//scatter gather
		ret = m2_dma_sc(trans, m2_dmanum);
	} else if (!(dmactl & 0x4)) {	//FIFO
		ret = m2_dma_fifo(trans, m2_dmanum);
	} else {					//normal
		ret = m2_dma_int2ext(trans, m2_dmanum);
	}

	return ret;
}
