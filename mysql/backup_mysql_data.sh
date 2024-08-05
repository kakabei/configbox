#!/bin/bash

## 每天自动备份 MySQL 数据库，并保留最近 7 天的备份。

BACKUP_DIR="/backup/mysql"
MYSQL_USER="root"
MYSQL_PASSWORD="password"
DATABASE_NAME="mydatabase"

# 创建备份目录
mkdir -p $BACKUP_DIR

# 创建一个新的备份
mysqldump -u $MYSQL_USER -p$MYSQL_PASSWORD $DATABASE_NAME > $BACKUP_DIR/$DATABASE_NAME-$(date +\%F).sql

# 移除超过七天备份文件
find $BACKUP_DIR -type f -mtime +7 -exec rm {} \;
