#/bin/bash

killall pac-soc-run

make -C ../test/regress/

sleep 1

	$PWD/../pac-soc/pac-soc-run -x ../ini/sim-runtest.ini &

sleep 2

	$PWD/pac-run-test -x ../ini/sim-runtest.ini -f Basic+BDTI+C2CC+DMA+DMA_PADD+DMU+ISA+M2_DMU -w logfile


	#$PWD/pac-run-test -x ../ini/sim-runtest.ini -f Basic -w logfile
	#$PWD/pac-run-test -x ../ini/sim-runtest.ini -f BDTI -w logfile
	#$PWD/pac-run-test -x ../ini/sim-runtest.ini -f DMA -w logfile
	#$PWD/pac-run-test -x ../ini/sim-runtest.ini -f DMA_PADD -w logfile
	#$PWD/pac-run-test -x ../ini/sim-runtest.ini -f DMU -w logfile
	#$PWD/pac-run-test -x ../ini/sim-runtest.ini -f ISA -w logfile
	#$PWD/pac-run-test -x ../ini/sim-runtest.ini -f C2CC -w logfile
	#$PWD/pac-run-test -x ../ini/sim-runtest.ini -f M2_DMU -w logfile

killall pac-soc-run
