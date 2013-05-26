SUBDIRS = Basic/asm  BDTI/asm C2CC/asm CFU/asm DMA/asm DMA_PADD/asm DMU/asm Entropy/asm HW_SMP/asm M2_DMU/asm ISA/asm ME/asm Regress/asm \
		  BRAM/asm C0_M1_MEM/asm C1_M1_MEM/asm C2_M1_MEM/asm C3_M1_MEM/asm  Core_regs/asm  DDR/asm M2_DMU_regs/asm M2_memory/asm \
		  M2_regs/asm

#ISA TestPattern can't assemble by pacdsp-elf-as !!

all:
	@set -e; for i in $(SUBDIRS); do $(MAKE) -C $$i; done

clean:
	@set -e; for i in $(SUBDIRS); do $(MAKE) clean -C $$i; done
