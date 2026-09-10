#!/bin/bash
# 添加QModem模组管理软件源
echo 'src-git qmodem https://github.com/FUjr/QModem.git;main' >> feeds.conf.default
# 更新并安装所有软件源
./scripts/feeds update -a
./scripts/feeds install -a
