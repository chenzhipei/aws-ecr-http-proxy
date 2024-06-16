#!/bin/sh

# 目标 URL 和端口
URL="localhost"
PORT="5000"

# DNS 服务器地址列表
DNS_SERVERS="8.8.8.8"

# 要解析的域名
DOMAIN="252208178451.dkr.ecr.cn-northwest-1.amazonaws.com.cn"

# 检查 DNS 解析
for DNS in $DNS_SERVERS; do
  nslookup $DOMAIN $DNS > /dev/null 2>&1
  if [ $? -ne 0 ]; then
    echo "DNS 解析失败: $DNS"
    exit 1
  fi
done

# 检查网络连接
ping -c 1 $URL > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "无法连接到 $URL"
  exit 1
fi

# 检查健康检查端点
wget http://$URL:$PORT/healthz -q -O - > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "健康检查失败: http://$URL:$PORT/healthz"
  exit 1
fi

echo "所有检查通过"
exit 0