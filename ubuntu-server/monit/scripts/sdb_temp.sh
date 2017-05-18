#!/bin/sh
HDDTP=`/usr/sbin/smartctl -a /dev/sdb | grep Temp | awk -F " " '{printf "%d",$10}'`
#echo $HDDTP # for debug only
exit $HDDTP