#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

echo '添加自定义源'
# sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default
# sed -i '$a src-git kenzo https://github.com/kenzok8/small-package' feeds.conf.default
sed -i '$a src-git kenzo https://github.com/kenzok8/openwrt-packages' feeds.conf.default
sed -i '$a src-git small https://github.com/kenzok8/small' feeds.conf.default
echo '=========Add a feed source OK!========='

# echo '修改5.4分支为5.4.150'
 # sed -i '/^LINUX_VERSION-5.4/c LINUX_VERSION-5.4 = .150' include/kernel-version.mk
 # sed -i '/^LINUX_KERNEL_HASH-5.4/c LINUX_KERNEL_HASH-5.4.150 = f424a9bbb05007f04c17f96a2e4f041a8001554a9060d2c291606e8a97c62aa2' include/kernel-version.mk
 # wget -nv https://github.com/yangxu52/OP-old-kernel-target/raw/main/target-5.4.150.tar.gz
 # rm -rf ./target/
 # tar -zxf ./target-5.4.150.tar.gz
 # rm -rf ./target-5.4.150.tar.gz
# echo '=========Alert kernel to 5.4.150 OK!========='

echo '添加lwz322的K3屏幕插件'
rm -rf package/lean/luci-app-k3screenctrl
git clone https://github.com/yangxu52/luci-app-k3screenctrl.git package/lean/luci-app-k3screenctrl
echo '=========Add k3screen plug OK!========='

echo '替换lwz322的K3屏幕驱动插件'
rm -rf package/lean/k3screenctrl
git clone https://github.com/yangxu52/k3screenctrl_build.git package/lean/k3screenctrl/
echo '=========Replace k3screen drive plug OK!========='

echo '添加jerrykuku的argon-mod主题'
rm -rf package/lean/luci-theme-argon  
git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon package/lean/luci-theme-argon
echo '=========Add argon-mod OK!========='

echo '添加jerrykuku的argon-mod主题自定义配置'
rm -rf package/lean/luci-app-argon-config 
git clone https://github.com/jerrykuku/luci-app-argon-config package/lean/luci-app-argon-config
echo '=========Add argon-mod config OK!========='

# echo '移除bcm53xx中的其他机型'
# sed -i '421,453d' target/linux/bcm53xx/image/Makefile
# sed -i '140,412d' target/linux/bcm53xx/image/Makefile
# sed -i 's/$(USB3_PACKAGES) k3screenctrl/luci-app-k3screenctrl/g' target/linux/bcm53xx/image/Makefile
# sed -n '140,146p' target/linux/bcm53xx/image/Makefile
# echo '=========Remove other devices of bcm53xx OK!========='

echo '移除主页跑分信息显示'
sed -i 's/ <%=luci.sys.exec("cat \/etc\/bench.log") or ""%>//g' package/lean/autocore/files/arm/index.htm
echo '=========Remove benchmark display in index OK!========='

echo '修改主机名'
sed -i "s/hostname='OpenWrt'/hostname='PHICOMM'/g" package/base-files/files/bin/config_generate
cat package/base-files/files/bin/config_generate |grep hostname=
echo '=========Alert hostname OK!========='

echo '修改路由器默认IP'
sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate
echo '=========Alert default IP OK!========='

# 修改插件名字
# sed -i 's/"aMule设置"/"电驴下载"/g' `grep "aMule设置" -rl ./`
# sed -i 's/"网络存储"/"NAS"/g' `grep "网络存储" -rl ./`
sed -i 's/"Turbo ACC 网络加速"/"网络加速"/g' `grep "Turbo ACC 网络加速" -rl ./`
# sed -i 's/"实时流量监测"/"流量"/g' `grep "实时流量监测" -rl ./`
# sed -i 's/"KMS 服务器"/"KMS激活"/g' `grep "KMS 服务器" -rl ./`
# sed -i 's/"TTYD 终端"/"命令窗"/g' `grep "TTYD 终端" -rl ./`
sed -i 's/"USB 打印服务器"/"打印服务"/g' `grep "USB 打印服务器" -rl ./`
# sed -i 's/"Web 管理"/"Web"/g' `grep "Web 管理" -rl ./`
# sed -i 's/"管理权"/"改密码"/g' `grep "管理权" -rl ./`
# sed -i 's/"带宽监控"/"监控"/g' `grep "带宽监控" -rl ./`
sed -i 's/"Argon 主题设置"/"Argon设置"/g' `grep "Argon 主题设置" -rl ./`

echo 'K3专用，编译K3的时候只会出K3固件（去掉sed前面的#生效）'
sed -i 's|^TARGET_|# TARGET_|g; s|# TARGET_DEVICES += phicomm-k3|TARGET_DEVICES += phicomm-k3|' target/linux/bcm53xx/image/Makefile
echo '=========Build K3 only OK!========='


# Add a feed source
#echo 'src-git helloworld https://github.com/fw876/helloworld' >>feeds.conf.default
#echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall' >>feeds.conf.default

# Add cpufreq
#rm -rf package/lean/luci-app-cpufreq
#svn co https://github.com/immortalwrt/luci/trunk/applications/luci-app-cpufreq feeds/luci/applications/luci-app-cpufreq
#ln -sf ../../../feeds/luci/applications/luci-app-cpufreq ./package/feeds/luci/luci-app-cpufreq

#添加主页的CPU温度显示
#sed -i "/<tr><td width=\"33%\"><%:Load Average%>/a \ \t\t<tr><td width=\"33%\"><%:CPU Temperature%></td><td><%=luci.sys.exec(\"sed 's/../&./g' /sys/class/thermal/thermal_zone0/temp|cut -c1-4\")%></td></tr>" feeds/luci/modules/luci-mod-admin-full/luasrc/view/admin_status/index.htm
#cat feeds/luci/modules/luci-mod-admin-full/luasrc/view/admin_status/index.htm |grep Temperature
#echo "Add CPU Temperature in Admin Index OK====================="
