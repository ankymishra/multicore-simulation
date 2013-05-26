
SRCS =		pac-gdb-server.cpp interface.cpp pac-parser.cpp

OBJS 		= $(SRCS:%.cpp=%.o)
DEPS 		= $(SRCS:%.cpp=%.d)

CXX			= g++
CXXFLAGS	=  -O0 -Wno-deprecated -Wall -g -ansi -Di386 
INCLUDES 	=  -I. -I../lib/include -I../lib/shmlib -I../lib/parser

LD			= $(CXX)
LDFLAGS 	= $(CXXFLAGS) 

LIBS		= -L../lib/parser -lpthread -lparser -lrt

PROGRAM 	= pac-gdb-server-run

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
