#!/bin/bash
# 自动添加用户并授予sudo权限脚本

if [ -z "$1" ]; then
    echo "Usage: $0 <username>"
    exit 1
fi

USERNAME=$1
PASSWORD="initial_password"  # 可以修改初始密码

# 检查用户是否已经存在
if id "$USERNAME" &>/dev/null; then
    echo "用户 $USERNAME 已存在。"
    exit 1
fi

# 添加用户
useradd -m $USERNAME
if [ $? -ne 0 ]; then
    echo "添加用户 $USERNAME 失败。"
    exit 1
fi

# 设置用户密码
echo "$USERNAME:$PASSWORD" | chpasswd
if [ $? -ne 0 ]; then
    echo "设置用户 $USERNAME 的密码失败。"
    exit 1
fi

# 授予用户 sudo 权限（ubuntu为sudo组）
usermod -aG wheel $USERNAME
if [ $? -ne 0 ]; then
    echo "添加用户 $USERNAME 到 sudo 组失败。"
    exit 1
fi

echo "用户 $USERNAME 已添加并授予 sudo 权限。"
