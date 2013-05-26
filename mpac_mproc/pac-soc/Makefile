SRCS 		= pac-bus.cpp m1.cpp m2.cpp ddr-memory.cpp pac-parser.cpp pac-core-bus.cpp pac-socshm-prot.cpp \
			  ../lib/pacshm/pac-shm.cpp pac-soc.cpp  pac-soc-pthread.cpp

OBJS 		= $(SRCS:%.cpp=%.o)
DEPS 		= $(SRCS:%.cpp=%.d)

SYSTEMC_HOME    = ../../..//systemc-2.2.0/
TLM_HOME		= ../../../TLM-2009-07-15/
SYSTEMC 		= $(SYSTEMC_HOME)
TLM				= $(TLM_HOME)

CXX			= g++
TLMFLAGS    = -pedantic  -Wno-long-long  -DSC_INCLUDE_DYNAMIC_PROCESSES



#Direct-Map No profile
CXXFLAGS	= $(TLMFLAGS) -O0 -Wno-deprecated -Wall -ansi -Di386

#2-way 4-way 8-way No profile 
#CXXFLAGS	= $(TLMFLAGS) -O0 -Wno-deprecated -Wall -ansi -Di386 -DPAC_2WAY_ICACHE_LINE
#CXXFLAGS	= $(TLMFLAGS) -O0 -Wno-deprecated -Wall -ansi -Di386 -DPAC_4WAY_ICACHE_LINE
#CXXFLAGS	= $(TLMFLAGS) -O0 -Wno-deprecated -Wall -ansi -Di386 -DPAC_8WAY_ICACHE_LINE

#Direct-Map with profile
#CXXFLAGS	= $(TLMFLAGS) -O0 -Wno-deprecated -Wall -ansi -Di386 -DPAC_SOC_PROFILE

#2-way 4-way 8-way with profile
#CXXFLAGS	= $(TLMFLAGS) -O0 -Wno-deprecated -Wall -ansi -Di386 -DPAC_2WAY_ICACHE_LINE -DPAC_SOC_PROFILE
#CXXFLAGS	= $(TLMFLAGS) -O0 -Wno-deprecated -Wall -ansi -Di386 -DPAC_4WAY_ICACHE_LINE -DPAC_SOC_PROFILE
#CXXFLAGS	= $(TLMFLAGS) -O0 -Wno-deprecated -Wall -ansi -Di386 -DPAC_8WAY_ICACHE_LINE -DPAC_SOC_PROFILE



INCLUDES 	= -I $(SYSTEMC)/include  -I $(TLM)/include/tlm -I../lib/include -I../lib/parser -I../lib/shmlib

LD			= $(CXX)
LDFLAGS 	= $(CXXFLAGS) 

LIBS		= -L$(SYSTEMC)/lib-linux -L../lib/parser -lrt -lsystemc -lpthread -lparser

PROGRAM 	= pac-soc-run

default:	$(PROGRAM) 
	

$(PROGRAM):	$(OBJS)
		$(LD) $(LDFLAGS) $(OBJS) $(LIBS) -o ./$@

clean:
	rm -f $(PROGRAM) *.o $(OBJS) *.d $(DEPS) *.ii *.s

pattern:
	make -C $(PWD)/TestPatterns 
	make -C $(PWD)/regress

clean-pattern:
	make -C $(PWD)/TestPatterns clean
	make -C $(PWD)/regress clean

# Cancel implicit rule
%.o:		%.cpp

%.o:		%.cpp %.d
			$(CXX) -g -c $< $(CXXFLAGS) $(INCLUDES)  -o $@

%.d: 		%.cpp
			@ echo Making dependencies for $<
			@ g++ -MM $(INCLUDES) $(CXXFLAGS) $< | sed 's#: # $*.d : #1' > $@

# Include dependency files .d
ifneq ("$(wildcard *.d)","")
  include $(wildcard *.d)
endif
