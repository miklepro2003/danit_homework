#! /bin/bash

POROG=$1

LOG_FILE="/var/log/disk.log"

DISK_NOW=$(df -h | grep mapper | awk '{print $5}' | tr -d '%') 

if (( DISK_NOW > POROG )); then
    echo "$(date) -- порог заполнения диска превысил ${POROG}% и заполнен на ${DISK_NOW}% " >> /var/log/disk.log
fi