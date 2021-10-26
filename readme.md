# NjitPortal

NjitPortal 是一个用于登录 NJIT 无线 Wi-Fi 网络，或者有线校园网的 Bash 脚本。

此登录脚本针对于城市热点 (Dr.com) 计费系统设计，可以很方便地运行在具有 *nix 操作系统 (Unix, Linux, macOS等) 的机器上。

此脚本对于 OpenWRT 路由器友好，可在具有 Bash 和 Curl 的环境下正常运行，无需安装较大体积的解释器如 Python 等。


## 运行
```bash
bash njitlogin.sh
```


## 依赖于

- **Bash** (`/bin/bash`)
- **Curl** (`/usr/bin/curl`)

*使用的命令：`base64`, `cut`, `grep`, `sed`, `tr`，可借助于 BusyBox。*


## 配置解释

```bash
# AC名称，一般情况为 'njit_off'，宿舍区 NJIT 和 WeNet 为 'NJIT-BRAS'
wlan_ac_name='njit_off'
# 客户端 IP 地址
ip_address='0.0.0.0'
# 客户端 MAC 地址
mac_address='00:00:00:00:00:00'
# 用户名，一般为学工号
username='201234567'
# ISP 选择，外网访问为 '@outnjit' ，内网访问为 '@innjit'
isp='@outnjit'
# 密码，一般为门户密码
password='123456'
```
