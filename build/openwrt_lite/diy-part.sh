#!/bin/bash
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# DIY扩展二合一了，在此处可以增加插件
#

cat >$NETIP <<-EOF
uci set network.lan.ipaddr='192.168.2.3'                                    # IPv4 地址(openwrt后台地址)
uci set network.lan.netmask='255.255.255.0'                                 # IPv4 子网掩码
uci set network.lan.gateway='192.168.2.1'                                   # IPv4 网关
uci set network.lan.broadcast='192.168.2.254'                               # IPv4 广播
uci set network.lan.dns='223.6.6.6'                                         # DNS(多个DNS要用空格分开)
uci set network.lan.delegate='0'                                            # 去掉LAN口使用内置的 IPv6 管理
uci commit network                                                          # 不要删除跟注释,除非上面全部删除或注释掉了
uci set dhcp.lan.ignore='1'                                                 # 关闭DHCP功能
uci commit dhcp                                                             # 跟‘关闭DHCP功能’联动,同时启用或者删除跟注释
uci set system.@system[0].hostname='OpenWrt'                                # 修改主机名称为OpenWrt
EOF

# 版本号里显示一个自己的名字
sed -i "s/OpenWrt /jellyfin Compiled in $(TZ=UTC-8 date "+%Y.%m.%d") @ OpenWrt /g" package/lean/default-settings/files/zzz-default-settings
# 关闭IPv6 分配长度
sed -i '/ip6assign/d' package/base-files/files/bin/config_generate

# 添加新版argon主题
rm -rf ../lean/luci-theme-argon
rm -rf ..feeds/luci/themes/luci-theme-argon
git clone --depth=1 -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon
# git clone --depth=1 -b 18.06 https://github.com/jellyfina/luci-theme-argon package/luci-theme-argon
git clone --depth=1 -b 18.06 https://github.com/kiddin9/luci-theme-edge package/luci-theme-edge
# rm -rf ../lean/luci-theme-neobird
# svn co https://github.com/thinktip/luci-theme-neobird/trunk feeds/luci/themes/luci-theme-neobird

                                                
# 设置默认主题
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile
# sed -i "/commit luci/i\uci set luci.main.mediaurlbase='/luci-static/argon'" package/lean/default-settings/files/zzz-default-settings

# 替换密码（要替换密码就不能设置密码为空）
#sed -i 's/$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.:0/$1$PhflQnJ1$yamWfH5Mphs4hXV7UXWQ21:18725/g' $ZZZ          

# 设置密码为空（安装固件时无需密码登陆，然后自己修改想要的密码）
# sed -i '/CYXluq4wUazHjmCDBCqXF/d' $ZZZ

# 修改内核版本为5.4
sed -i 's/PATCHVER:=5.15/PATCHVER:=6.1/g' target/linux/x86/Makefile                          

# 修改内核版本为4.19
#sed -i 's/PATCHVER:=5.4/PATCHVER:=4.19/g' target/linux/x86/Makefile  
# 自定义软件源
#sed -i '$a src-git kenzok https://github.com/kenzok8/openwrt-packages' feeds.conf.default           # 常用插件源
#sed -i '$a src-git small https://github.com/kenzok8/small' feeds.conf.default                       # 常用插件源_依赖安装
# 删除自带插件
rm -rf ./feeds/packages/net/aria2                       # 删除aria2
rm -rf ./feeds/packages/net/ariang                      # 删除aria2
rm -rf ./feeds/luci/applications/luci-app-aria2         # 删除aria2
rm -rf ./feeds/luci/applications/luci-app-wol           # 删除wol网络唤醒
rm -rf ./package/lean/luci-app-pptp-server              # 删除PPTP-VPN服务端
rm -rf ./package/lean/luci-app-qbittorrent              # 删除qbittorrent
rm -rf ./package/lean/qBittorrent-static                # 删除qbittorrent
rm -rf ./package/lean/luci-app-qbittorrent_static       # 删除qbittorrent
rm -rf ./feeds/packages/net/zerotier                    # 删除zerotier内网穿透
rm -rf ./feeds/luci/applications/luci-app-zerotier
rm -rf ./feeds/luci/applications/luci-app-upnp
rm -rf ./feeds/luci/applications/luci-app-ipsec-vpnd
rm -rf ./feeds/luci/applications/luci-app-filetransfer
rm -rf ./feeds/luci/applications/luci-app-nlbwmon
rm -rf ./feeds/packages/net/nlbwmon
rm -rf ./feeds/danshui/luci-app-wrtbwmon
rm -rf ./feeds/danshui/wrtbwmon
rm -rf ./package/lean/luci-app-zerotier                 # 删除zerotier内网穿透
rm -rf ./package/lean/luci-app-unblockmusic             # 删除网易云音乐解锁
rm -rf ./package/lean/UnblockNeteaseMusic-Go            # 删除网易云音乐解锁
rm -rf ./feeds/luci/applications/luci-app-unblockmusic  # 删除网易云音乐解锁
rm -rf ./package/lean/adbyby                            # 删除广告大师
rm -rf ./package/lean/luci-app-adbyby-plus              # 删除广告大师
rm -rf ./feeds/luci/applications/luci-app-adbyby-plus   # 删除广告大师
rm -rf ./package/lean/luci-app-xlnetacc                 # 删除迅雷快鸟
rm -rf ./feeds/luci/applications/luci-app-xlnetacc      # 删除迅雷快鸟
rm -rf ./package/lean/uugamebooster                     # 删除UU游戏加速
rm -rf ./package/lean/luci-app-uugamebooster            # 删除UU游戏加速
# rm -rf ./feeds/luci/applications/luci-app-autoupdate  # 删除在线升级
# rm -rf ./package/luci-app-autoupdate
rm -rf ./package/lean/luci-app-ttyd
rm -rf ./feeds/luci/applications/luci-app-ttyd
# rm -rf ./feeds/packages/net/samba4
# rm -rf ./feeds/luci/applications/luci-app-samba4
rm -rf ./feeds/packages/utils/gzip                      # 去掉gzip,让固件支持自动升级

# 自定义插件
sed -i '$a src-git serverchan https://github.com/tty228/luci-app-serverchan' feeds.conf.defaul

# 增加防火墙规则
echo "iptables -t nat -I POSTROUTING -o eth0 -j MASQUERADE" >> package/network/config/firewall/files/firewall.user

# 整理固件包时候,删除您不想要的固件或者文件,让它不需要上传到Actions空间（根据编译机型变化,自行调整需要删除的固件名称）
cat >${GITHUB_WORKSPACE}/Clear <<-EOF
rm -rf packages
# rm -rf config.buildinfo
rm -rf feeds.buildinfo
rm -rf openwrt-x86-64-generic-kernel.bin
rm -rf openwrt-x86-64-generic.manifest
rm -rf openwrt-x86-64-generic-squashfs-rootfs.img.gz
rm -rf openwrt-x86-64-generic-squashfs-combined-efi.vmdk
rm -rf openwrt-x86-64-generic-squashfs-combined.vmdk
rm -rf sha256sums
rm -rf version.buildinfo
EOF

# 修改插件名字
#sed -i 's/"aMule设置"/"电驴下载"/g' `grep "aMule设置" -rl ./`
sed -i 's/"网络存储"/"存储"/g' `grep "网络存储" -rl ./`
sed -i 's/"Turbo ACC 网络加速"/"网络加速"/g' `grep "Turbo ACC 网络加速" -rl ./`
sed -i 's/"实时流量监测"/"流量"/g' `grep "实时流量监测" -rl ./`
sed -i 's/"KMS 服务器"/"KMS激活"/g' `grep "KMS 服务器" -rl ./`
sed -i 's/"TTYD 终端"/"shell终端"/g' `grep "TTYD 终端" -rl ./`
sed -i 's/"USB 打印服务器"/"网络打印"/g' `grep "USB 打印服务器" -rl ./`
sed -i 's/"FTP 服务器"/"FTP服务"/g' `grep "FTP 服务器" -rl ./`
sed -i 's/"Frp 内网穿透"/"内网穿透"/g' `grep "Frp 内网穿透" -rl ./`
#sed -i 's/"Web 管理"/"Web"/g' `grep "Web 管理" -rl ./`
sed -i 's/"管理权"/"改密码"/g' `grep "管理权" -rl ./`
sed -i 's/"带宽监控"/"监控"/g' `grep "带宽监控" -rl ./`
sed -i 's/"Argon 主题设置"/"Argon设置"/g' `grep "Argon 主题设置" -rl ./`
