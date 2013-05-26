
SRCS =		pac-cfu.cpp pac-parser.cpp ../lib/pacshm/pac-shm.cpp pac-cfu-main.cpp \
			pac-cfu-demo.cpp 

OBJS 		= $(SRCS:%.cpp=%.o)
DEPS 		= $(SRCS:%.cpp=%.d)


CXX			= g++
CXXFLAGS	= -O0 -Wall -g -ansi -Di386
INCLUDES 	= -I.  -I../lib/include -I../lib/parser

LD			= $(CXX)
LDFLAGS 	= $(CXXFLAGS) 

LIBS		= -lrt

PROGRAM 	= pac-cfu-run

default:	$(PROGRAM)

$(PROGRAM):	$(OBJS) 
		$(LD) $(LDFLAGS) $(OBJS) $(LIBS) -o ./$@

clean:
	rm -f $(PROGRAM) *.o $(OBJS) *.d $(DEPS) 

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
