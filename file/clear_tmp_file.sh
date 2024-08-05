#!/bin/bash

# 脚本清理 /tmp 目录下超过 7 天未修改的文件，以释放磁盘空间

TEMP_DIR="/tmp"
DAYS=7

find $TEMP_DIR -type f -mtime +$DAYS -exec rm -f {} \;
find $TEMP_DIR -type d -empty -delete
