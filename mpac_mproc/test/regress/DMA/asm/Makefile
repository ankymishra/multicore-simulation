SRCS = $(wildcard *.s)
OBJS = $(patsubst %.s,%.o,$(SRCS))
BINS = $(patsubst %.s,%.bin,$(SRCS))
#OBJS = $(wildcard *.o)
#BINS = $(wildcard *.bin)

CROSS_COMPILER = pacdsp-elf-
CC=$(CROSS_COMPILER)gcc
OBJCOPY=$(CROSS_COMPILER)objcopy
OBJDUMP=$(CROSS_COMPILER)objdump
AS=$(CROSS_COMPILER)as

ASFLAGS=-horizontaledit -g --isa=ISA3.6
#ASFLAGS=-horizontaledit -g

all: $(BINS)

%.bin:%.o
	$(OBJCOPY) -O binary $< $@

%.o:%.s
	$(AS) $(ASFLAGS) $< -o $@

clean:
	rm -rf *.o *.bin *.asm
	
