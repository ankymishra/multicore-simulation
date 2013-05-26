SUBDIRS = Basic/asm  BDTI/asm C2CC/asm CFU/asm DMA/asm DMA_PADD/asm DMU/asm Entropy/asm HW_SMP/asm M2_DMU/asm ISA/asm ME/asm Regress/asm

#ISA TestPattern can't assemble by pacdsp-elf-as !!

all:
	@set -e; for i in $(SUBDIRS); do $(MAKE) -C $$i; done

clean:
	@set -e; for i in $(SUBDIRS); do $(MAKE) clean -C $$i; done
