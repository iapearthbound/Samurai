#!/system/bin/sh
#
# run_init_scripts.sh
#
#
# 2011 nubecoder
# http://www.nubecoder.com/
#

#functions
SEND_LOG()
{
	/system/bin/log -p i -t init:init_scripts "run_init_scripts : $1"
}

#main
SEND_LOG "Start"

if busybox test "$1" = "recovery" ; then
	for x in /nubernel/scripts/init*; do
		SEND_LOG "Running: $x \"recovery\""
		/system/bin/logwrapper "$x" "recovery"
	done
	SEND_LOG "Execute recovery binary"
	/sbin/recovery
else
	for x in /nubernel/scripts/init*; do
		SEND_LOG "Running: $x"
		/system/bin/logwrapper "$x"
	done
	SEND_LOG "Running: /nubernel/scripts/run_parts.sh"
	/system/bin/logwrapper /nubernel/scripts/run_parts.sh
fi

SEND_LOG "End"

