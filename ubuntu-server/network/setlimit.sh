#!/bin/bash

if [ -z "$1" ]
  then
    echo "No speed (in mbps) supplied!"
    exit 1
fi

speedUp=$1

netdev="enp7s0f0"


# Удаление очередей
/sbin/tc qdisc del dev ${netdev} root handle 1:

# Ограничение скорости отдачи
/sbin/tc qdisc add dev ${netdev} root handle 1: htb default 10 r2q 1
/sbin/tc class add dev ${netdev} parent 1: classid 1:5 htb rate ${speedUp}mbit quantum 8000 burst 32k
/sbin/tc filter add dev ${netdev} parent 1:0 prio 1 protocol ip handle 5 fw flowid 1:5

exit 0

