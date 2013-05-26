
SRCS 		= pac-run.cpp pac-parser.cpp pac-mem.cpp ../lib/pacshm/pac-shm.cpp
OBJS 		= $(SRCS:%.cpp=%.o)
DEPS 		= $(SRCS:%.cpp=%.d)

CXX			= g++
CXXFLAGS	= -O0 -Wno-deprecated -Wall -ansi -g -Di386 
INCLUDES 	=  -I. -I../lib/parser -I../lib/include

LD			= $(CXX)
LDFLAGS 	= $(CXXFLAGS) 

LIBS		= -L../lib/parser -lparser -lrt

PROGRAM 	= pac-run-test

default:	$(PROGRAM)

$(PROGRAM):	$(OBJS) 
		$(LD) $(LDFLAGS) $(OBJS)  $(LIBS) -o ./$@

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
