#!/bin/bash
# 网段IP扫描脚本

if [ -z "$1" ]; then
    echo "Usage: $0 <subnet>"
    echo "Example: $0 192.168.1"
    exit 1
fi

SUBNET=$1

echo "开始扫描网段 $SUBNET.0/24 ..."

for i in {1..254}; do
    IP="$SUBNET.$i"
    ping -c 1 -W 1 $IP &>/dev/null
    
    if [ $? -eq 0 ]; then
        echo "IP $IP 存活"
    fi
done

echo "扫描完成。"

