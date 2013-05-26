DEMO = pacdemo
CC = pacdsp-elf-gcc
OBJCOPY = pacdsp-elf-objcopy
OBJDUMP = pacdsp-elf-objdump

INC_STDCOMMPATH = ../noctools/src
LIB_STDCOMMPATH = ../noctools/pac

all:$(DEMO)0.bin $(DEMO)1.bin $(DEMO)2.bin $(DEMO)3.bin
# $(DEMO)2.bin $(DEMO)3.bin $(DEMO)4.bin

#pacdemo.bin:pacdemo.elf
#	pacdsp-elf-objcopy -O binary pacdemo.elf pacdemo.bin
#	
#pacdemo.elf:pacdemo.c
#	pacdsp-elf-gcc -o pacdemo.elf pacdemo.c -lc -lsim -Wl,-Map=pacdemo.map -Wl,-Telf32_pacdsp.ld
#	pacdsp-elf-objdump -d -S pacdemo.elf >pacdemo.asm

#############################
$(DEMO)0.bin:$(DEMO)0.elf
	$(OBJCOPY) -O binary $< $@
	
$(DEMO)0.elf:$(DEMO)0.c
	$(CC) -o $@ $< -I$(INC_STDCOMMPATH) -L$(LIB_STDCOMMPATH) common.c -lc -lsim -Wl,-Map=$(DEMO)0.map -Wl,-Tpacdemo0.ld
	$(OBJDUMP) -d -S $@ >$(DEMO)0.asm

#############################
$(DEMO)1.bin:$(DEMO)1.elf
	$(OBJCOPY) -O binary $< $@
	
$(DEMO)1.elf:$(DEMO)1.c
	$(CC) -o $@ $< -I$(INC_STDCOMMPATH) -L$(LIB_STDCOMMPATH) common.c -lc -lsim -Wl,-Map=$(DEMO)1.map -Wl,-Tpacdemo1.ld
	$(OBJDUMP) -d -S $@ >$(DEMO)1.asm

#############################
$(DEMO)2.bin:$(DEMO)2.elf
	$(OBJCOPY) -O binary $< $@
	
$(DEMO)2.elf:$(DEMO)2.c
	$(CC) -o $@ $< -I$(INC_STDCOMMPATH) -L$(LIB_STDCOMMPATH) common.c -lc -lsim -Wl,-Map=$(DEMO)2.map -Wl,-Tpacdemo2.ld
	$(OBJDUMP) -d -S $@ >$(DEMO)2.asm

#############################
$(DEMO)3.bin:$(DEMO)3.elf
	$(OBJCOPY) -O binary $< $@
	
$(DEMO)3.elf:$(DEMO)3.c
	$(CC) -o $@ $< -I$(INC_STDCOMMPATH) -L$(LIB_STDCOMMPATH) common.c -lc -lsim -Wl,-Map=$(DEMO)3.map -Wl,-Tpacdemo3.ld
	$(OBJDUMP) -d -S $@ >$(DEMO)3.asm



clean:
	rm -rf *.elf *.bin *.o *.map *.asm
