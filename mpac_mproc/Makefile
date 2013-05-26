SUBDIRS = pac-soc pac-iss pac-fe pac-cfu pac-run-test client

all:
	@set -e; for i in $(SUBDIRS); do $(MAKE) -C $$i ; done


clean:
	@set -e; for i in $(SUBDIRS) ; do $(MAKE) -C $$i clean ; done
