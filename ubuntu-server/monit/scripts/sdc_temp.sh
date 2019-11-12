#!/bin/sh
HDDTP=`/usr/sbin/smartctl -a /dev/sdc | grep Temp | awk -F " " '{printf "%d",$10}'`
#echo $HDDTP # for debug only
exit $HDDTP