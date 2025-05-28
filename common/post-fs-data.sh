#!/system/bin/sh

if [ -d /data/adb/modules/UnisocOverclock ]; then
    nohup /system/bin/oc_daemon &
fi