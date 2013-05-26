SRCS =	pac-iss.cpp pac-dsp.cpp pac-exec.cpp pac-semihost.cpp \
		pac-iss-debug.cpp pac-parser.cpp pac-issshm-prot.cpp \
		../lib/pacshm/pac-shm.cpp pac-profiling.cpp \
		sc-pac-monitor.cpp sc-pac-if-direct.cpp sc-pac-ex1.cpp \
		sc-pac-ex2.cpp sc-pac-ex3.cpp sc-pac-memif.cpp
		
#SRCS =	pac-iss.cpp pac-dsp.cpp pac-exec.cpp pac-semihost.cpp \
		pac-iss-debug.cpp pac-parser.cpp pac-issshm-prot.cpp \
		../lib/pacshm/pac-shm.cpp pac-profiling.cpp \
		sc-pac-monitor.cpp sc-pac-if-way.cpp sc-pac-ex1.cpp \
		sc-pac-ex2.cpp sc-pac-ex3.cpp sc-pac-memif.cpp

OBJS = 	$(SRCS:%.cpp=%.o)
DEPS =	$(SRCS:%.cpp=%.d)

SYSTEMC_HOME    = ../../../systemc-2.2.0
TLM_HOME	= ../../../TLM-2009-07-15/
SYSTEMC 	= $(SYSTEMC_HOME)
TLM		= $(TLM_HOME)

CXX		= g++
TLMFLAGS	= -Wno-long-long  -DSC_INCLUDE_DYNAMIC_PROCESSES

#Direct-Map 2way 4way 8way
CXXFLAGS 	= $(TLMFLAGS) -O0 -Wno-deprecated -Wall -ansi -g -Di386 $(CCFLAGS) 
#CXXFLAGS 	= $(TLMFLAGS) -O0 -Wno-deprecated -Wall -ansi -g -Di386 $(CCFLAGS)  -DPAC_2WAY_ICACHE_LINE
#CXXFLAGS 	= $(TLMFLAGS) -O0 -Wno-deprecated -Wall -ansi -g -Di386 $(CCFLAGS)  -DPAC_4WAY_ICACHE_LINE
#CXXFLAGS 	= $(TLMFLAGS) -O0 -Wno-deprecated -Wall -ansi -g -Di386 $(CCFLAGS)  -DPAC_8WAY_ICACHE_LINE

INCLUDES 	= -I $(SYSTEMC)/include -I $(TLM)/include/tlm -I. -I../lib/include -I../lib/parser -I../pac-cfu

LD		= $(CXX)
LDFLAGS = 	$(CXXFLAGS) 

LIBS	= -L$(SYSTEMC)/lib-linux -L../lib/parser  -lrt -lsystemc -lpthread -lparser

PROGRAM	= pac-iss-run

default:$(PROGRAM)

$(PROGRAM):	$(OBJS)
	$(LD) $(LDFLAGS) $(OBJS) $(LIBS) -o ./$@

clean:
	rm -f $(PROGRAM) *.o $(OBJS) *.d $(DEPS)  *.ii *.s *.i

# Cancel implicit rule
%.o: %.cpp

%.o: %.cpp %.d
	$(CXX) -g -c $< $(CXXFLAGS) $(INCLUDES)  -o $@

%.d: %.cpp
	@ echo Making dependencies for $<
	@ g++ -MM $(INCLUDES) $(CXXFLAGS) $< | sed 's#: # $*.d : #1' > $@

# Include dependency files .d
ifneq ("$(wildcard *.d)","")
  include $(wildcard *.d)
endif
