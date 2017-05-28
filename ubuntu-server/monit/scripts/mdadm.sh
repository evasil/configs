#!/bin/bash

if [ -z "$1" ]
  then
    DEVICE="/dev/md0"
  else
    DEVICE="$1"
fi


MDRESULT=`/sbin/mdadm --detail $DEVICE | grep degraded | wc -l`

# echo $MDRESULT

if [[ $MDRESULT -eq "0" ]]
 then
  echo "OK"
else
  echo "DEGRADED!"
fi

exit $MDRESULT
