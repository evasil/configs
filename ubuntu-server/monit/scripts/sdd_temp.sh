#!/bin/sh
HDDTP=`/usr/sbin/smartctl -a /dev/sdd | grep Temp | awk -F " " '{printf "%d",$10}'`
#echo $HDDTP # for debug only
exit $HDDTP