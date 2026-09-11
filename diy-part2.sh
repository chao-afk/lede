#!/bin/bash
# 开机等待QModem启动，再拉起websocket网关
sed -i 's/exit 0/sleep 8\nexit 0/' package/base-files/files/etc/rc.local

# 创建AT转ubus的websocket网关脚本
mkdir -p package/base-files/files/usr/bin
cat > package/base-files/files/usr/bin/at_ws_gateway.lua <<'EOF'
local websocket = require "websocket.server"
local ubus = require "ubus"
local u = ubus.connect()

local function handle_at(attxt)
    local res = u:call("qmodem.at", "run_at", {slot=0, cmd=attxt})
    if res and res.result then
        return res.result
    end
    return "AT ERROR"
end

websocket.listen({
    port=8765,
    on_message = function(conn, data)
        local ret = handle_at(data)
        conn:send(ret)
    end
})
EOF

# 开机自动启动网关
cat >> package/base-files/files/etc/rc.local <<'EOF'
lua /usr/bin/at_ws_gateway.lua &
EOF
