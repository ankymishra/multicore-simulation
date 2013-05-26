#!/bin/sh

setup()
{
    export SERVER_ROOT=${PWD}
    export SERVER_BASE="/tmp"
    export TMP="${SERVER_BASE}/gdb-server-$$"
    mkdir -p $TMP 
};

usage()
{
    echo "-s ISS_NUM      Run GDB-Server want to control ISS_NUM core."
    echo "-n GDB_PORT     Run GDB-Server want to use GDB_PORT to connect GDB."
    echo "-h              Help. Prints all available options."
    echo "-c              Run GDB-Server with CFU"
    echo "-t              Use semihost 0 is local disable 1 is local enable."
    echo "-x INI_FILE     Run GDB-Server in genernal ini file."
	
    echo "example: ./run-gdb.sh -x xxx.ini -s 4 -n 7788"
    exit 0
}

main()
{
	local ISS_NUM=4
	local GDB_PORT=0
	local INI_FILE="$SERVER_ROOT/ini/sim-gdbserver.ini"
	local SEMIHOST=0
	local CFU_MODE=0
	
    while getopts cths:n:x: OPTION 
    do
		case $OPTION
			in
			h)usage;;
			
			s)ISS_NUM=$OPTARG;;
			
			n)GDB_PORT=$OPTARG;;
			
			x)INI_FILE=$OPTARG;;
			
			t)SEMIHOST=1;;
		
			c)CFU_MODE=1;;
			
			\?) usage;;
		esac
	done
	
    echo "CORE_NUM $ISS_NUM"
    echo "GDB_PORT $GDB_PORT"
    echo "INI_FILE $INI_FILE"

	echo ""
    echo "###############################################################"
    
    echo "Now executing gdb-server."
    echo "tmp file is in the /tmp/gdb-server-pid directory"
    
    echo "###############################################################"
	echo ""

	$SERVER_ROOT/pac-soc/pac-soc-run -x $INI_FILE &> $TMP/soc.log &

   	sleep 1
	if [ $CFU_MODE == 1 ];then
		$SERVER_ROOT/pac-cfu/pac-cfu-run -x $INI_FILE &> $TMP/cfu.log &	
	fi

   	sleep 1
	CORE_ID=$ISS_NUM
	while [ $CORE_ID != 0 ];
	do
		let ID=CORE_ID-1;
		if [ $SEMIHOST == 0 ];then
			if [ $CFU_MODE == 1 ];then
				$SERVER_ROOT/pac-iss/pac-iss-run $ID -x $INI_FILE -s -c &>$TMP/iss$ID.log &
			else
				$SERVER_ROOT/pac-iss/pac-iss-run $ID -x $INI_FILE -s &>$TMP/iss$ID.log &
			fi
		else
			if [ $CFU_MODE == 1 ];then
				$SERVER_ROOT/pac-iss/pac-iss-run $ID -x $INI_FILE -s -t -c &>$TMP/iss$ID.log &
			else
				$SERVER_ROOT/pac-iss/pac-iss-run $ID -x $INI_FILE -s -t &>$TMP/iss$ID.log &
			fi
		fi
		let CORE_ID=$CORE_ID-1 
	done
	
	sleep 1
	$SERVER_ROOT/pac-fe/pac-gdb-server-run -x $INI_FILE -s $ISS_NUM -n $GDB_PORT  &> $TMP/fe.log &

	BACK_PID=`jobs -p |wc -l`
	let BACK_PID=$BACK_PID+0;
	if [ $CFU_MODE == 1 ];then
		let NEED_PID=$ISS_NUM+3;
	else
		let NEED_PID=$ISS_NUM+2;
	fi

	if [ $BACK_PID != $NEED_PID ];then
		echo "Running Fail"
		echo  "for detail to see /tmp/gdb-server-pid directory log"
	fi
	
};

cleanup()
{
    rm -rf ${TMP}
};

#trap "cleanup" 0
setup
main  "$@"
