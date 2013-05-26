# gcc
GCC = pacdsp-elf-gcc
GCCFLAGS =

# common
RM = rm -f
SOURCES = src/stdcomm.c src/sprintf.c src/mtools.c
DEBUG =
#-DDEBUGMODE
DEBUG2FILE = 
#-DDEBUG2FILE

release: $(SOURCES)
	echo Release version of libraries: no debugging output.
	echo To create debug versions: make debug
	echo Creating stdcomm and mtools libraries for pac with gcc...
	$(GCC) $(GCCFLAGS) $(DEBUG) -c src/stdcomm.c
	mv stdcomm.o pac/libstdcomm.a
	$(GCC) $(GCCFLAGS) -c src/sprintf.c
	mv sprintf.o pac/libsprintf.a
	$(GCC) $(GCCFLAGS) -c src/mtools.c
	mv mtools.o pac/libmtools.a

debug: $(SOURCES)
	echo Debug version of libraries: extra debugging output using mprintf.
	echo To create non-debug versions: make release
	echo Creating stdcomm and mtools libraries for i386 with gcc...
	$(GCC) $(GCCFLAGS) $(DEBUG) $(DEBUG2FILE) -c src/stdcomm.c
	mv stdcomm.o pac/libstdcomm.a
	$(GCC) $(GCCFLAGS) -c src/sprintf.c
	mv sprintf.o pac/libsprintf.a
	$(GCC) $(GCCFLAGS) -c src/mtools.c
	mv mtools.o pac/libmtools.a

clean:
	$(RM) pac/*
	$(RM) *.o
