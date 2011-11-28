#!/system/bin/sh
#
# init_01_system_apps.sh
#
#
# 2011 nubecoder
# http://www.nubecoder.com/
#

#defines
MV_SYS_APPS_FILE="/data/local/.mv_sys_apps"
RM_SYS_APPS_FILE="/data/local/.rm_sys_apps"

#functions
SEND_LOG()
{
	/system/bin/log -p i -t init:init_scripts "init_01_system_apps : $1"
}
REMOVE_SYSTEM_APP()
{
	local ARGS="$1"
	set -- junk $ARGS;
	shift
	local APK="$1"
	local DATA="$2"
	SEND_LOG "  test -f /system/app/${APK}.apk"
	if /sbin/busybox test -f "/system/app/${APK}.apk"; then
		SEND_LOG "  rm -f /system/app/${APK}.apk"
		/sbin/busybox rm -f "/system/app/${APK}.apk"
	fi
	SEND_LOG "  test -f /system/app/${APK}.odex"
	if /sbin/busybox test -f "/system/app/${APK}.odex"; then
		SEND_LOG "  rm -f /system/app/${APK}.odex"
		/sbin/busybox rm -f "/system/app/${APK}.odex"
	fi
	SEND_LOG "  test -d /data/data/${DATA}"
	if /sbin/busybox test -d "/data/data/${DATA}"; then
		SEND_LOG "  rm -rf /data/data/${DATA}"
		/sbin/busybox rm -rf "data/data/${DATA}"
	fi
}
MOVE_SYSTEM_APP()
{
	local ARGS="$1"
	set -- junk $ARGS;
	shift
	local APK="$1"
	local DATA="$2"
	local CACHE="system@app@${APK}.apk@classes.dex"
	SEND_LOG "  test -f /system/app/${APK}.odex"
	if /sbin/busybox test -f "/system/app/${APK}.odex"; then
		SEND_LOG "  Detected odex file, app will not be moved"
		return 1
	fi
	SEND_LOG "  test -f /system/app/${APK}.apk"
	if /sbin/busybox test -f "/system/app/${APK}.apk"; then
		SEND_LOG "  Detected ${APK}.apk file, moving to /data/app"
		local EXISTING_APP_FIND=$(/sbin/busybox find /data/app -iname "${DATA}*")
		for EXISTING_APP in $EXISTING_APP_FIND ; do
			SEND_LOG "  rm -f $EXISTING_APP"
			/sbin/busybox rm -f "$EXISTING_APP"
		done
		SEND_LOG "  mv -f /system/app/${APK}.apk /data/app/${DATA}-1.apk"
		/sbin/busybox mv -f "/system/app/${APK}.apk" "/data/app/${DATA}-1.apk"
		/sbin/busybox chown system.system "/data/app/${DATA}-1.apk"
		/sbin/busybox chmod 0644 "/data/app/${DATA}-1.apk"

		SEND_LOG "  test -d /data/data/${DATA}"
		if /sbin/busybox test -d "/data/data/${DATA}"; then
			SEND_LOG "  rm -rf /data/data/${DATA}"
			/sbin/busybox rm -rf "/data/data/${DATA}"
		fi
		SEND_LOG "  test -f /data/dalvik-cache/${CACHE}"
		if /sbin/busybox test -f "/data/dalvik-cache/${CACHE}"; then
			SEND_LOG "  rm -f /data/dalvik-cache/${CACHE}"
			/sbin/busybox rm -f "/data/dalvik-cache/${CACHE}"
		fi
	fi
}

#main
SEND_LOG "Start"

if /sbin/busybox test "$1" = "recovery"; then
	# do nothing
else
	SEND_LOG "Ensuring there is room for busybox and root"

	SEND_LOG "Looking for $MV_SYS_APPS_FILE"
	if /sbin/busybox test -f $MV_SYS_APPS_FILE; then
		SEND_LOG "  Using: $MV_SYS_APPS_FILE"
	else
		echo "Asphalt5_DEMO_SAMSUNG_D700_Sprint_ML_330 com.gameloft.android.ANMP.GloftAsphalt5Demo.asphalt5" >$MV_SYS_APPS_FILE
		echo "FreeHDGameDemos com.gameloft.microwidget" >>$MV_SYS_APPS_FILE
		echo "nascar09-prod-release com.handson.h2o.nascar09" >>$MV_SYS_APPS_FILE
		echo "qik-8.66-release-ffc com.qikffc.android" >>$MV_SYS_APPS_FILE
		echo "sfl-prod-release com.handson.h2o.nfl" >>$MV_SYS_APPS_FILE
		echo "SprintTV com.mobitv.client.sprinttv" >>$MV_SYS_APPS_FILE
		echo "SprintTVWidget com.mobitv.sprint.tvwidget" >>$MV_SYS_APPS_FILE
		echo "SprintZone com.sprint.dsa" >>$MV_SYS_APPS_FILE
		echo "TN6.2-sprint-handset-6201501 com.telenav.app.android.sprint" >>$MV_SYS_APPS_FILE
		SEND_LOG "  Created: $MV_SYS_APPS_FILE"
	fi
	SEND_LOG "  Moving apps to /data/app"
	while read LINE ; do
		MOVE_SYSTEM_APP "$LINE"
	done < $MV_SYS_APPS_FILE

	SEND_LOG "Looking for $RM_SYS_APPS_FILE"
	if /sbin/busybox test -f $RM_SYS_APPS_FILE; then
		SEND_LOG "  Using: $RM_SYS_APPS_FILE"
	else
		echo "Term1 com.android.term1" >$RM_SYS_APPS_FILE
		echo "Term2 com.android.term2" >>$RM_SYS_APPS_FILE
		echo "Term3 com.android.term3" >>$RM_SYS_APPS_FILE
		echo "Term4 com.android.term4" >>$RM_SYS_APPS_FILE
		echo "Term5 com.android.term5" >>$RM_SYS_APPS_FILE
		SEND_LOG "  Created: $RM_SYS_APPS_FILE"
	fi
	SEND_LOG "  Removing apps from /system/app"
	while read LINE ; do
		REMOVE_SYSTEM_APP "$LINE"
	done < $RM_SYS_APPS_FILE

	SEND_LOG "Sync filesystem"
	/system/xbin/busybox sync
fi

SEND_LOG "End"

