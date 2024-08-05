#!/bin/bash


# 检查指定服务是否运行，如果宕掉则重启该服务并发送通知邮件

SERVICE="nginx"
EMAIL="admin@example.com"

if ! systemctl is-active --quiet $SERVICE; then
  echo "$SERVICE is down. Attempting to restart..." | mail -s "$SERVICE is down" $EMAIL
  systemctl restart $SERVICE
  if systemctl is-active --quiet $SERVICE; then
    echo "$SERVICE was successfully restarted" | mail -s "$SERVICE restarted" $EMAIL
  else
    echo "Failed to restart $SERVICE" | mail -s "$SERVICE restart failed" $EMAIL
  fi
fi
