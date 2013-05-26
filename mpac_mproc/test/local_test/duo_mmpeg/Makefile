SRCS =		mmpg.c load_img.c dump.c

OBJS 		= $(SRCS:%.cpp=%.o)
#DEPS 		= $(SRCS:%.cpp=%.d)

SYSTEMC_HOME    = ../../../systemc/systemc-2.2.0/
TLM_HOME	= ../../../TLM-2009-07-15
SYSTEMC 	= $(SYSTEMC_HOME)
TLM		= $(TLM_HOME)

CXX		= pacdsp-elf-gcc
#DBGFLAG	= -DMEM_DBG -DNETPRINT -DROUTEPRINT
TLMFLAGS	= 
CXXFLAGS	=  
INCLUDES 	= -I./

LD		= $(CXX)
LDFLAGS 	= $(CXXFLAGS) 

LIBS		= -lc -lsim -Tpacdemo0.ld

PROGRAM 	= mmpg

default:	$(PROGRAM)

$(PROGRAM):	$(OBJS)
		$(LD) $(LDFLAGS) $(OBJS) $(LIBS) -o ./$@
		pacdsp-elf-objcopy -O binary mmpg mmpg.bin

clean:
	rm -f  *.o *.d mmpg.bin mmpg

# Cancel implicit rule
%.o:		%.c

%.o:		%.c %.d
		$(CXX) -g -c $< $(CXXFLAGS) $(INCLUDES)  -o $@

%.d: 		%.c
		@ echo Making dependencies for $<
		@ g++ -MM $(INCLUDES) $(CXXFLAGS) $< | sed 's#: # $*.d : #1' > $@

# Include dependency files .d
ifneq ("$(wildcard *.d)","")
  include $(wildcard *.d)
endif
