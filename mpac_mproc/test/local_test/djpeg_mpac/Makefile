# toolchain
GCC = pacdsp-elf-gcc
OBJCOPY = pacdsp-elf-objcopy
OBJDUMP = pacdsp-elf-objdump

GCCFLAGS = 
NOCTOOLS = ../noctools
INCS = -I$(NOCTOOLS)/src -Dverbose
LIBS = -L$(NOCTOOLS)/pac -lmtools -lstdcomm -lsprintf -lm -lc -lsim

NODE1 = mpac_rom_x0y0
NODE1_SOURCES = parse.c tree_vld.c huffman.c step1.c
NODE2 = mpac_rom_x1y0
NODE2_SOURCES = fast_int_idct.c step2.c
NODE3 = mpac_rom_x0y1
NODE3_SOURCES = color.c sunraster.c step3.c
NODE4 = mpac_rom_x1y1
NODE4_SOURCES = step4-null.c

all: $(NODE1) $(NODE2) $(NODE3) $(NODE4)

$(NODE1): $(NODE1_SOURCES)
	$(GCC) $(GCCFLAGS) -o $(NODE1) $(INCS) $(NODE1_SOURCES) $(LIBS) -Tpacdemo0.ld -Wl,-Map=$@.map
	$(OBJDUMP) -d -S $@ > $@.asm
	$(OBJCOPY) -O binary $@ $@.bin

$(NODE2) :$(NODE2_SOURCES) 
	$(GCC) $(GCCFLAGS) -o $(NODE2) $(INCS) $(NODE2_SOURCES) $(LIBS) -Tpacdemo1.ld -Wl,-Map=$@.map
	$(OBJDUMP) -d -S $@ > $@.asm
	$(OBJCOPY) -O binary $@ $@.bin

$(NODE3): $(NODE3_SOURCES)
	$(GCC) $(GCCFLAGS) -o $(NODE3) $(INCS) $(NODE3_SOURCES) $(LIBS) -Tpacdemo2.ld -Wl,-Map=$@.map
	$(OBJDUMP) -d -S $@ > $@.asm
	$(OBJCOPY) -O binary $@ $@.bin

$(NODE4): $(NODE4_SOURCES)
	$(GCC) $(GCCFLAGS) -o $(NODE4) $(INCS) $(NODE4_SOURCES) $(LIBS) -Tpacdemo3.ld -Wl,-Map=$@.map
	$(OBJDUMP) -d -S $@ > $@.asm
	$(OBJCOPY) -O binary $@ $@.bin

clean:
	$(RM) $(NODE1) $(NODE2) $(NODE3) $(NODE4) *.o *.bin *.map *.s *.asm
