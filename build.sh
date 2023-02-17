#!/bin/bash

sudo apt-get update
sudo apt-get upgrade

echo "src-git PWpackages https://github.com/xiaorouji/openwrt-passwall.git;packages" >> feeds.conf.default
echo "src-git PWluci https://github.com/xiaorouji/openwrt-passwall.git;luci" >> feeds.conf.default

# sudo apt-get install upx -y
# cp /usr/bin/upx staging_dir/host/bin
# cp /usr/bin/upx-ucl staging_dir/host/bin

./scripts/feeds update -a

# pushd feeds/packages/lang
# rm -rf golang && svn co https://github.com/openwrt/packages/branches/openwrt-21.02/lang/golang
# popd

#在SDK根目录，强制优先安装PWpackages中的 feeds 软件包
./scripts/feeds install -a -f -p PWpackages
#在SDK根目录，安装 feeds 中luci-app-passwall的软件包
./scripts/feeds install luci-app-passwall

make defconfig

#进入make menuconfig
# make menuconfig
# #进入全局设置，如下面所示，然后保存，退出
# [*] Select all target specific packages by default                                                    
# [*] Select all kernel module packages by default                                                      
# [*] Select all userspace packages by default
# [*] Cryptographically sign package lists (NEW) 

make download -j8 V=s && find dl -size -1024c -exec ls -l {} \; && make package/luci-app-passwall/{clean,compile} -j4
# make package/luci-app-passwall/{clean,compile} -j4

make package/index

ls bin/*

