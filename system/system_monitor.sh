#!/bin/bash

## 每分钟记录系统的 CPU 和内存使用情况到日志文件中

LOG_FILE="/var/log/system_monitor.log"

while true; do
  echo "$(date): CPU: $(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')% MEM: $(free -m | awk 'NR==2{printf "%.2f%%", $3*100/$2 }')" >> $LOG_FILE
  sleep 60
done


