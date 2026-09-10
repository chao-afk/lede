#!/bin/bash
# 开机延时5秒，等待FM350模组上电
sed -i 's/exit 0/sleep 5\nexit 0/' package/base-files/files/etc/rc.local

# 加入WebUI后端启动（socat串口转WebSocket，供前端连接）
cat >> package/base-files/files/etc/rc.local << 'EOF'
# FM350 AT串口转WebSocket 端口8765
socat TCP-LISTEN:8765,fork,reuseaddr /dev/ttyUSB4,raw,echo=0,nonblock,cs8,b115200 &
EOF
