#ifndef PAC_BUS_H_INCLUDED
#define PAC_BUS_H_INCLUDED

#include "pac-profile.h"

extern struct sim_arg multi_sim_arg;
extern sc_core::sc_event soc_core_req_event[DSPNUM]; // 4 core request event
extern sc_core::sc_event soc_core_resp_event[DSPNUM]; // core finish response event
extern int soc_core_req_bit_mask[DSPNUM]; //m1 m2 ddr finish bit mask


class pac_bus {

	public:
		static struct profile_soc profile_soc_table;


	public:	
		pac_bus()
		{
			unsigned int core_id, inst;
			for (core_id = 0; core_id < DSPNUM; core_id++){
				memset(&(profile_soc_table.profile_core_table[core_id]), 0, sizeof(profile_soc_table.profile_core_table[core_id]));

				for (inst = INST_SC; inst <= INST_DMU_C2; inst++) {
					profile_soc_table.profile_core_table[core_id].inst[inst].cmd = tlm::TLM_IGNORE_COMMAND;
					profile_soc_table.profile_core_table[core_id].inst[inst].bank_num = -1;
				}
			}
		}

		~pac_bus()
		{}
		
		void notify_core_finish(unsigned int core_id, unsigned int range)
		{
			soc_core_req_bit_mask[core_id] &= ~(1 << range);

			if (soc_core_req_bit_mask[core_id] == 0x10000000)
				soc_core_resp_event[core_id].notify(); // core finish response event				
			
		}

#if 0
		void wait_generic_delay(unsigned int self_inst_core_range)
		{
			unsigned int core_id, range;
			
			core_id = GET_CORE(self_inst_core_range);
			range = GET_RANGE(self_inst_core_range);

			if (profile_soc_table.profile_core_table[core_id].generic_wait_flag == 0) {
				unsigned int m1_generic_rd_delay, m2_generic_rd_delay, ddr_generic_rd_delay;
				unsigned int m1_generic_wr_delay, m2_generic_wr_delay, ddr_generic_wr_delay;
				unsigned int dsp_num = 0, inst, max_delay;

				unsigned int max_delay_cmd_all = tlm::TLM_IGNORE_COMMAND * DSPNUM;
				unsigned int max_delay_cmd_dspnum = DSPNUM;
				tlm::tlm_command max_delay_cmd[DSPNUM];

				//memset(max_delay_cmd, (unsigned int)tlm::TLM_IGNORE_COMMAND, sizeof(max_delay_cmd));
				for(dsp_num = 0; dsp_num < DSPNUM; dsp_num++) {
					max_delay_cmd[dsp_num] = tlm::TLM_IGNORE_COMMAND;
				}

				m1_generic_rd_delay = MULTI_ARG(pacdsp[core_id].m1_mem, m1_rd_delay);
				m2_generic_rd_delay = MULTI_ARG(m2_mem, m2_rd_delay);
				ddr_generic_rd_delay = MULTI_ARG(ddr_mem, ddr_rd_delay);
				
				m1_generic_wr_delay = MULTI_ARG(pacdsp[core_id].m1_mem, m1_wr_delay);
				m2_generic_wr_delay = MULTI_ARG(m2_mem, m2_wr_delay);
				ddr_generic_wr_delay = MULTI_ARG(ddr_mem, ddr_wr_delay);

				switch (range) {
				case M1_RANGE:
					if (m1_generic_rd_delay < m1_generic_wr_delay) {
						max_delay = m1_generic_wr_delay;
					} else {
						max_delay = m1_generic_rd_delay;
					}
					
					for(dsp_num = 0; dsp_num < DSPNUM; dsp_num++) {
						for(inst = INST_SC; inst <= INST_DMU_C2; inst++) {
							if(profile_soc_table.profile_core_table[dsp_num].inst[inst].cmd == tlm::TLM_IGNORE_COMMAND)
								continue;
							if(GET_RANGE(profile_soc_table.profile_core_table[dsp_num].inst[inst].inst_core_range) != M1_RANGE)
								continue;

							if (max_delay_cmd[dsp_num] != profile_soc_table.profile_core_table[dsp_num].inst[inst].cmd) {
								if(max_delay_cmd[dsp_num] == tlm::TLM_IGNORE_COMMAND) {
									max_delay_cmd[dsp_num] = profile_soc_table.profile_core_table[dsp_num].inst[inst].cmd;
								} else if (max_delay_cmd[dsp_num] == tlm::TLM_READ_COMMAND) {
									if (m1_generic_rd_delay < m1_generic_wr_delay)
										max_delay_cmd[dsp_num] = tlm::TLM_WRITE_COMMAND;
								} else {
									if (m1_generic_rd_delay > m1_generic_wr_delay)
										max_delay_cmd[dsp_num] = tlm::TLM_READ_COMMAND;
								}
							}
						}
					}
					
					for (dsp_num = 0; dsp_num < DSPNUM; dsp_num++) {
						if (max_delay_cmd[dsp_num] == tlm::TLM_IGNORE_COMMAND) {
							max_delay_cmd_dspnum--;
							max_delay_cmd_all -= tlm::TLM_IGNORE_COMMAND;
						} else if (max_delay_cmd[dsp_num] == tlm::TLM_READ_COMMAND) {
							max_delay_cmd_all -= (tlm::TLM_IGNORE_COMMAND - tlm::TLM_READ_COMMAND);
						} else {
							max_delay_cmd_all -= (tlm::TLM_IGNORE_COMMAND - tlm::TLM_WRITE_COMMAND);
						}	
					}

					if (max_delay_cmd_all == (max_delay_cmd_dspnum * tlm::TLM_READ_COMMAND)) {
						wait(m1_generic_rd_delay, SC_NS);
					} else if (max_delay_cmd_all == (max_delay_cmd_dspnum *tlm::TLM_WRITE_COMMAND)) {
						wait(m1_generic_wr_delay, SC_NS);
					} else {
						wait(max_delay, SC_NS);
					}
					break;
				case M2_RANGE:
					if (m2_generic_rd_delay < m2_generic_wr_delay) {
						max_delay = m2_generic_wr_delay;
					} else {
						max_delay = m2_generic_rd_delay;
					}
					
					for(dsp_num = 0; dsp_num < DSPNUM; dsp_num++) {
						for(inst = INST_SC; inst <= INST_DMU_C2; inst++) {
							if(profile_soc_table.profile_core_table[dsp_num].inst[inst].cmd == tlm::TLM_IGNORE_COMMAND)
								continue;
							if(GET_RANGE(profile_soc_table.profile_core_table[dsp_num].inst[inst].inst_core_range) != M2_RANGE)
								continue;

							if (max_delay_cmd[dsp_num] != profile_soc_table.profile_core_table[dsp_num].inst[inst].cmd) {
								if(max_delay_cmd[dsp_num] == tlm::TLM_IGNORE_COMMAND) {
									max_delay_cmd[dsp_num] = profile_soc_table.profile_core_table[dsp_num].inst[inst].cmd;
								} else if (max_delay_cmd[dsp_num] == tlm::TLM_READ_COMMAND) {
									if (m2_generic_rd_delay < m2_generic_wr_delay)
										max_delay_cmd[dsp_num] = tlm::TLM_WRITE_COMMAND;
								} else {
									if (m2_generic_rd_delay > m2_generic_wr_delay)
										max_delay_cmd[dsp_num] = tlm::TLM_READ_COMMAND;
								}
							}
						}
					}
					
					for (dsp_num = 0; dsp_num < DSPNUM; dsp_num++) {
						if (max_delay_cmd[dsp_num] == tlm::TLM_IGNORE_COMMAND) {
							max_delay_cmd_dspnum--;
							max_delay_cmd_all -= tlm::TLM_IGNORE_COMMAND;
						} else if (max_delay_cmd[dsp_num] == tlm::TLM_READ_COMMAND) {
							max_delay_cmd_all -= (tlm::TLM_IGNORE_COMMAND - tlm::TLM_READ_COMMAND);
						} else {
							max_delay_cmd_all -= (tlm::TLM_IGNORE_COMMAND - tlm::TLM_WRITE_COMMAND);
						}	
					}

					if (max_delay_cmd_all == (max_delay_cmd_dspnum * tlm::TLM_READ_COMMAND)) {
						wait(m2_generic_rd_delay, SC_NS);
					} else if (max_delay_cmd_all == (max_delay_cmd_dspnum *tlm::TLM_WRITE_COMMAND)) {
						wait(m2_generic_wr_delay, SC_NS);
					} else {
						wait(max_delay, SC_NS);
					}
					break;
				case DDR_RANGE:
					if (ddr_generic_rd_delay < ddr_generic_wr_delay) {
						max_delay = ddr_generic_wr_delay;
					} else {
						max_delay = ddr_generic_rd_delay;
					}
					
					for(dsp_num = 0; dsp_num < DSPNUM; dsp_num++) {
						for(inst = INST_SC; inst <= INST_DMU_C2; inst++) {
							if(profile_soc_table.profile_core_table[dsp_num].inst[inst].cmd == tlm::TLM_IGNORE_COMMAND)
								continue;
							if(GET_RANGE(profile_soc_table.profile_core_table[dsp_num].inst[inst].inst_core_range) != DDR_RANGE)
								continue;

							if (max_delay_cmd[dsp_num] != profile_soc_table.profile_core_table[dsp_num].inst[inst].cmd) {
								if(max_delay_cmd[dsp_num] == tlm::TLM_IGNORE_COMMAND) {
									max_delay_cmd[dsp_num] = profile_soc_table.profile_core_table[dsp_num].inst[inst].cmd;
								} else if (max_delay_cmd[dsp_num] == tlm::TLM_READ_COMMAND) {
									if (ddr_generic_rd_delay < ddr_generic_wr_delay)
										max_delay_cmd[dsp_num] = tlm::TLM_WRITE_COMMAND;
								} else {
									if (ddr_generic_rd_delay > ddr_generic_wr_delay)
										max_delay_cmd[dsp_num] = tlm::TLM_READ_COMMAND;
								}
							}
						}
					}
					
					for (dsp_num = 0; dsp_num < DSPNUM; dsp_num++) {
						if (max_delay_cmd[dsp_num] == tlm::TLM_IGNORE_COMMAND) {
							max_delay_cmd_dspnum--;
							max_delay_cmd_all -= tlm::TLM_IGNORE_COMMAND;
						} else if (max_delay_cmd[dsp_num] == tlm::TLM_READ_COMMAND) {
							max_delay_cmd_all -= (tlm::TLM_IGNORE_COMMAND - tlm::TLM_READ_COMMAND);
						} else {
							max_delay_cmd_all -= (tlm::TLM_IGNORE_COMMAND - tlm::TLM_WRITE_COMMAND);
						}	
					}

					if (max_delay_cmd_all == (max_delay_cmd_dspnum * tlm::TLM_READ_COMMAND)) {
						wait(ddr_generic_rd_delay, SC_NS);
					} else if (max_delay_cmd_all == (max_delay_cmd_dspnum *tlm::TLM_WRITE_COMMAND)) {
						wait(ddr_generic_wr_delay, SC_NS);
					} else {
						wait(max_delay, SC_NS);
					}
					break;
				default:
					break;
				}
				profile_soc_table.profile_core_table[core_id].generic_wait_flag = 1;
			}
		}
#endif

		void generate_generic_delay(unsigned int self_inst_core_range)
		{
			unsigned int core_id, range, inst, max_delay;
			
			core_id = GET_CORE(self_inst_core_range);
			range = GET_RANGE(self_inst_core_range);
			inst = GET_INST(self_inst_core_range);

			unsigned int m1_generic_rd_delay, m2_generic_rd_delay, ddr_generic_rd_delay;
			unsigned int m1_generic_wr_delay, m2_generic_wr_delay, ddr_generic_wr_delay;

			m1_generic_rd_delay = MULTI_ARG(pacdsp[core_id].m1_mem, m1_rd_delay);
			m2_generic_rd_delay = MULTI_ARG(m2_mem, m2_rd_delay);
			ddr_generic_rd_delay = MULTI_ARG(ddr_mem, ddr_rd_delay);
			
			m1_generic_wr_delay = MULTI_ARG(pacdsp[core_id].m1_mem, m1_wr_delay);
			m2_generic_wr_delay = MULTI_ARG(m2_mem, m2_wr_delay);
			ddr_generic_wr_delay = MULTI_ARG(ddr_mem, ddr_wr_delay);

			
			switch (range) {
			case M1_RANGE:
				if (profile_soc_table.profile_core_table[core_id].inst[inst].cmd == tlm::TLM_READ_COMMAND) {
					max_delay = m1_generic_rd_delay;
				} else {
					max_delay = m1_generic_wr_delay;
				}
				
				profile_soc_table.profile_core_table[core_id].generic_delay = 
					profile_soc_table.profile_core_table[core_id].generic_delay > max_delay ? 
					profile_soc_table.profile_core_table[core_id].generic_delay : max_delay;

				break;
			case M2_RANGE:
				if (profile_soc_table.profile_core_table[core_id].inst[inst].cmd == tlm::TLM_READ_COMMAND) {
					max_delay = m2_generic_rd_delay;
				} else {
					max_delay = m2_generic_wr_delay;
				}
				
				profile_soc_table.profile_core_table[core_id].generic_delay = 
					profile_soc_table.profile_core_table[core_id].generic_delay > max_delay ? 
					profile_soc_table.profile_core_table[core_id].generic_delay : max_delay;

				break;
			case DDR_RANGE:
				if (profile_soc_table.profile_core_table[core_id].inst[inst].cmd == tlm::TLM_READ_COMMAND) {
					max_delay = ddr_generic_rd_delay;
				} else {
					max_delay = ddr_generic_wr_delay;
				}
				
				profile_soc_table.profile_core_table[core_id].generic_delay = 
					profile_soc_table.profile_core_table[core_id].generic_delay > max_delay ? 
					profile_soc_table.profile_core_table[core_id].generic_delay : max_delay;

				break;
			default:
				break;
			}
		}

		void generate_inst_table(unsigned int self_inst_core_range, int bank_num, double start_time, tlm::tlm_command cmd)
		{
			unsigned int core_id, inst;
			core_id = GET_CORE(self_inst_core_range);
			inst = GET_INST(self_inst_core_range);
			
			profile_soc_table.profile_core_table[core_id].start_time = start_time;
			profile_soc_table.profile_core_table[core_id].inst[inst].inst_core_range = self_inst_core_range;
			profile_soc_table.profile_core_table[core_id].inst[inst].cmd = cmd;
			profile_soc_table.profile_core_table[core_id].inst[inst].bank_num = bank_num;
		}


		void generate_inst_bank_contention(unsigned int self_inst_core_range)
		{
			unsigned int i, inst, core_id, range;
			unsigned int m1_contention_delay, m2_contention_delay, ddr_contention_delay;

			inst = GET_INST(self_inst_core_range);
			core_id = GET_CORE(self_inst_core_range);
			range = GET_RANGE(self_inst_core_range);

			if (profile_soc_table.profile_core_table[core_id].inst[inst].cmd == tlm::TLM_READ_COMMAND) {
				m1_contention_delay = MULTI_ARG(pacdsp[core_id].m1_mem, m1_rd_cont_delay);
				m2_contention_delay = MULTI_ARG(m2_mem, m2_rd_cont_delay);
				ddr_contention_delay = MULTI_ARG(ddr_mem, ddr_rd_cont_delay);
			} else {
				m1_contention_delay = MULTI_ARG(pacdsp[core_id].m1_mem, m1_wr_cont_delay);
				m2_contention_delay = MULTI_ARG(m2_mem, m2_wr_cont_delay);
				ddr_contention_delay = MULTI_ARG(ddr_mem, ddr_wr_cont_delay);
			}


			for (i = INST_SC; i <= INST_DMU_C2; i++) {
				if ((int)(inst - i) <= 0)
					continue;

				unsigned int other_range;
				other_range = GET_RANGE(profile_soc_table.profile_core_table[core_id].inst[i].inst_core_range);

				if (range == other_range) {
					if (profile_soc_table.profile_core_table[core_id].inst[inst].bank_num
						== profile_soc_table.profile_core_table[core_id].inst[i].bank_num)
					{
						switch (range) {
						case M1_RANGE:
							profile_soc_table.profile_core_table[core_id].inst_delay += m1_contention_delay;
							break;
						case M2_RANGE:
							profile_soc_table.profile_core_table[core_id].inst_delay += m2_contention_delay;
							break;
						case DDR_RANGE:
							profile_soc_table.profile_core_table[core_id].inst_delay += ddr_contention_delay;
							break;
						default:
							break;
						}
					}
				}
			}
		}

		unsigned int hit_bank_contention(unsigned int self_inst_core_range, unsigned int other_core_id)
		{
			unsigned int inst, core_id, range;
			unsigned int i,hit = 0;
			int self_bank_num, other_bank_num;

			inst = GET_INST(self_inst_core_range);
			core_id = GET_CORE(self_inst_core_range);
			range = GET_RANGE(self_inst_core_range);
			
			switch (range) {
			case M1_RANGE:
				self_bank_num = profile_soc_table.profile_core_table[core_id].inst[inst].bank_num;
				for (i = INST_SC; i <= INST_DMU_C2; i++) {
					other_bank_num = profile_soc_table.profile_core_table[other_core_id].inst[i].bank_num;
					if (self_bank_num == other_bank_num)
						hit++;
				}
				break;
			case M2_RANGE:
				self_bank_num = profile_soc_table.profile_core_table[core_id].inst[inst].bank_num;
				for (i = INST_SC; i <= INST_DMU_C2; i++) {
					other_bank_num = profile_soc_table.profile_core_table[other_core_id].inst[i].bank_num;
					if (self_bank_num == other_bank_num)
						hit++;
				}
				break;
			case DDR_RANGE:
				self_bank_num = profile_soc_table.profile_core_table[core_id].inst[inst].bank_num;
				for (i = INST_SC; i <= INST_DMU_C2; i++) {
					other_bank_num = profile_soc_table.profile_core_table[other_core_id].inst[i].bank_num;
					if (self_bank_num == other_bank_num)
						hit++;
				}
				break;
			default:
				break;
				
			}
			return hit;
		}

		int compare_start_time(unsigned int self_inst_core_range, unsigned int other_core_id)
		{
			unsigned int core_id;
			double self_start_time, other_start_time;

			core_id = GET_CORE(self_inst_core_range);

			self_start_time = profile_soc_table.profile_core_table[core_id].start_time;
			other_start_time = profile_soc_table.profile_core_table[other_core_id].start_time;
			
			if (self_start_time == other_start_time) {
				return 0;
			} else if (self_start_time < other_start_time) {
				return -1;
			} else {
				return 1;
			}
		return 0;
		}

		void generate_core_delay(unsigned int self_inst_core_range)
		{
			unsigned int dsp_num = 0, hit_bank_num;
			unsigned int m2_contention_delay, ddr_contention_delay;
			unsigned int inst, core_id, range;
			

			inst = GET_INST(self_inst_core_range);
			core_id = GET_CORE(self_inst_core_range);
			range = GET_RANGE(self_inst_core_range);

			if (profile_soc_table.profile_core_table[core_id].inst[inst].cmd == tlm::TLM_READ_COMMAND) {
				m2_contention_delay = MULTI_ARG(m2_mem, m2_rd_cont_delay);
				ddr_contention_delay = MULTI_ARG(ddr_mem, ddr_rd_cont_delay);
			} else {
				m2_contention_delay = MULTI_ARG(m2_mem, m2_wr_cont_delay);
				ddr_contention_delay = MULTI_ARG(ddr_mem, ddr_wr_cont_delay);
			}

			switch (range) {
			case M1_RANGE:
				break;
			case M2_RANGE:
				for (dsp_num = 0; dsp_num < DSPNUM; dsp_num++) {
					if (dsp_num -  core_id >= 0)
						continue;

					if (profile_soc_table.profile_core_table[dsp_num].start_time == 0)
						continue;

					hit_bank_num = hit_bank_contention(self_inst_core_range, dsp_num);
					if (hit_bank_num > 0) {
						if (compare_start_time(self_inst_core_range, dsp_num) >= 0) {
							profile_soc_table.profile_core_table[core_id].core_delay +=
								profile_soc_table.profile_core_table[dsp_num].core_delay
								+ profile_soc_table.profile_core_table[dsp_num].inst_delay
								+(profile_soc_table.profile_core_table[core_id].start_time
								  - profile_soc_table.profile_core_table[dsp_num].start_time)
								+ (m2_contention_delay * hit_bank_num);
						} else {
							// do nothing
						}
					}
				}
				break;
			case DDR_RANGE:
				for (dsp_num = 0; dsp_num < DSPNUM; dsp_num++) {
					if ((int)(dsp_num -  core_id) >= 0)
						continue;

					if (profile_soc_table.profile_core_table[dsp_num].start_time == 0)
						continue;

					hit_bank_num = hit_bank_contention(self_inst_core_range, dsp_num);
					if (hit_bank_num > 0) {
						if (compare_start_time(self_inst_core_range, dsp_num) >= 0) {
							profile_soc_table.profile_core_table[core_id].core_delay +=
								profile_soc_table.profile_core_table[dsp_num].core_delay
								+ profile_soc_table.profile_core_table[dsp_num].inst_delay
								+(profile_soc_table.profile_core_table[core_id].start_time
								  - profile_soc_table.profile_core_table[dsp_num].start_time)
								+ (ddr_contention_delay * hit_bank_num);
						} else {
							// do nothing
						}
					}
				}
				break;
			default:
				break;
			}
		}
	
		void wait_core_delay(unsigned int self_inst_core_range)
		{
			unsigned int core_id;
			
			core_id = GET_CORE(self_inst_core_range);
			
			wait(profile_soc_table.profile_core_table[core_id].core_delay, SC_NS);
		}

		void wait_inst_delay(unsigned int self_inst_core_range)
		{
			unsigned int core_id;
			
			core_id = GET_CORE(self_inst_core_range);
			
			wait(profile_soc_table.profile_core_table[core_id].inst_delay, SC_NS);
		}

		void modify_other_core_delay_time(unsigned int core_id, unsigned int range)
		{
			double self_core_delay, other_core_delay;
			unsigned int dsp_num, hit_bank_num;
			unsigned int inst, self_inst_core_range;

			self_core_delay = profile_soc_table.profile_core_table[core_id].core_delay
				+ profile_soc_table.profile_core_table[core_id].inst_delay;
			
			for (dsp_num = 0; dsp_num < DSPNUM; dsp_num++) {
				if (dsp_num == core_id)
					continue;

				for (inst = INST_SC; inst < INST_DMU_C2; inst++) {
					self_inst_core_range = GEN_INST_CORE_RANGE(inst, core_id, range);
					hit_bank_num = hit_bank_contention(self_inst_core_range, dsp_num);
					if (hit_bank_num > 0) {
						other_core_delay = profile_soc_table.profile_core_table[dsp_num].core_delay;
						if (compare_start_time(self_inst_core_range, dsp_num) < 0) {
							if (self_core_delay > other_core_delay) {
								profile_soc_table.profile_core_table[dsp_num].core_delay = self_core_delay;
								break;
							}
						} else {
							//do nothing
						}
					}
				}
			}
		}

		void clear_self_soc_profile_table(unsigned int core_id)
		{
			unsigned int inst;
			
			memset(&(profile_soc_table.profile_core_table[core_id]), 0, sizeof(profile_soc_table.profile_core_table[core_id]));

			for (inst = INST_SC; inst <= INST_DMU_C2; inst++) {
				profile_soc_table.profile_core_table[core_id].inst[inst].cmd = tlm::TLM_IGNORE_COMMAND;
				profile_soc_table.profile_core_table[core_id].inst[inst].bank_num = -1;
			}
		}


};

#endif
