#!/bin/sh

TP=`sensors | grep 'Physical id' | awk '{ printf "%d",$4 }'`

#echo $TP
exit $TP



