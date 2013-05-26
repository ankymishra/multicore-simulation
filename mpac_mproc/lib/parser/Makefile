CC     = gcc
AR     = ar
CFLAGS = -Wall -g
ARFLAGS = cruv
LIB    = libparser.a

$(LIB) : parser.o scanner.o
	$(AR) $(ARFLAGS) $(LIB) scanner.o parser.o

parser.o : parser.y
	/usr/bin/bison -d -l parser.y
	$(CC) $(CFLAGS) -c -o parser.o parser.tab.c  -I../include

scanner.o : parser.y scanner.l
	/usr/bin/flex scanner.l
	$(CC) $(CFLAGS) -c -o scanner.o lex.yy.c -I../include

.PHONY : clean
clean :
# remove bison generated files
	rm -rf parser.tab.c parser.tab.h location.hh position.hh stack.hh libparser.a lex.yy.c
# remove flex generated files
	rm -rf lex.yy.cc
# remove compiled files
	rm -rf $(BIN) *.o
