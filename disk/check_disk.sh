#!/bin/bash

## 
# 检查系统的磁盘使用情况，并发送邮件通知磁盘使用超过阈值的情况。

THRESHOLD=80
EMAIL="admin@example.com"

df -H | grep -vE '^Filesystem|tmpfs|cdrom' | awk '{ print $5 " " $1 }' | while read output;
do
  usep=$(echo $output | awk '{ print $1}' | cut -d'%' -f1  )
  partition=$(echo $output | awk '{ print $2 }' )
  if [ $usep -ge $THRESHOLD ]; then
    echo "Warning: The partition \"$partition\" has used $usep% at $(date)" | mail -s "Disk Space Alert: $partition" $EMAIL
  fi
done
