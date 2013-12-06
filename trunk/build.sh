#!/bin/sh

#apt-get install g++ libncurses5-dev zlib1g-dev bison flex unzip autoconf gawk make gettext gettext texinfo sharutils gcc binutils ncurses-term patch bzip2 libbz2-dev libz-dev asciidoc subversion sphinxsearch libtool git git-core curl

cd ~/openwrt

svn checkout svn://svn.openwrt.org/openwrt/trunk trunk
git clone git://github.com/sancome/my_openwrt_mod.git
#git clone git://github.com/binux/yaaw.git
#git clone git://github.com/ziahamza/webui-aria2.git

cp ./trunk/feeds.conf.default ./trunk/feeds.conf
echo "src-git exopenwrt https://github.com/black-roland/exOpenWrt.git" >> ./trunk/feeds.conf
echo "src-git mwan git://github.com/Adze1502/mwan.git" >> ./trunk/feeds.conf
./trunk/scripts/feeds update -a
./trunk/scripts/feeds install -a

#RA MOD
#patch
mkdir ./trunk/feeds/packages/net/aria2/patches
cp -rf ./my_openwrt_mod/patch/aria2/*.* ./trunk/feeds/packages/net/aria2/patches
cp -rf ./my_openwrt_mod/patch/uClibc/*.* ./trunk/toolchain/uClibc/patches-0.9.33.2
cp -rf ./my_openwrt_mod/patch/busybox/*.* ./trunk/package/utils/busybox/patches

#package base-files
cp -rf ./my_openwrt_mod/package/base-files/sysctl.conf.diff ./trunk/package/base-files/files/etc/
patch -p0 ./trunk/package/base-files/files/etc/sysctl.conf < ./trunk/package/base-files/files/etc/sysctl.conf.diff
rm ./trunk/package/base-files/files/etc/sysctl.conf.diff
cp -rf ./my_openwrt_mod/package/base-files/sysupgrade.conf ./trunk/package/base-files/files/etc/
cp -rf ./my_openwrt_mod/package/base-files/banner ./trunk/package/base-files/files/etc/
cp -rf ./my_openwrt_mod/package/base-files/profile ./trunk/package/base-files/files/etc/
cp -rf ./my_openwrt_mod/package/base-files/tsocks.conf ./trunk/package/base-files/files/etc/
cp -rf ./my_openwrt_mod/package/base-files/rc.button ./trunk/package/base-files/files/etc/
cp -rf ./my_openwrt_mod/package/base-files/dnsmasq.d ./trunk/package/base-files/files/etc/
cp -rf ./my_openwrt_mod/package/base-files/ipset ./trunk/package/base-files/files/etc/
#cp -rf ./my_openwrt_mod/package/base-files/config/wireless ./trunk/package/base-files/files/etc/config/
cp -rf ./my_openwrt_mod/package/base-files/sbin/aria2 ./trunk/package/base-files/files/sbin/
##for tl841v7
#cp -rf ./my_openwrt_mod/package/base-files/hotplug.d ./trunk/package/base-files/files/etc/

#package files
#dnsmasq
cp -rf ./my_openwrt_mod/package/dnsmasq/*.* ./trunk/package/network/services/dnsmasq/files/
#samba
cp -rf ./my_openwrt_mod/package/samba/*.* ./trunk/package/network/services/samba36/files
#ubox
cp -rf ./my_openwrt_mod/package/ubox ./trunk/package/system/
patch -p0 ./trunk/package/system/ubox/Makefile < ./trunk/package/system/ubox/Makefile.diff
rm ./trunk/package/system/ubox/Makefile.diff
#openssl
cp -rf ./my_openwrt_mod/package/openssl ./trunk/package/libs/
patch -p0 ./trunk/package/libs/openssl/Makefile < ./trunk/package/libs/openssl/Makefile.diff
rm ./trunk/package/libs/openssl/Makefile.diff

#package install
#exfat-nofuse
cp -rf ./my_openwrt_mod/package/exfat-nofuse ./trunk/package/
#redsocks
cp -rf ./my_openwrt_mod/package/redsocks2/ ./trunk/package/
#shadowsocks-libev
cp -rf ./my_openwrt_mod/package/shadowsocks-libev ./trunk/package/
#添加tsocks 远程dns支持
cp -rf ./my_openwrt_mod/package/tsocks ./trunk/feeds/packages/net/
#dnscrypt-proxy
cp -rf ./my_openwrt_mod/package/dnscrypt-proxy ./trunk/package/
#libsodium
cp -rf ./my_openwrt_mod/package/libsodium ./trunk/package/
#nodejs
cp -rf ./my_openwrt_mod/package/nodejs ./trunk/package/
#cpulimit-ng
cp -rf ./my_openwrt_mod/package/cpulimit-ng ./trunk/package/
#gevent
cp -rf ./my_openwrt_mod/package/gevent ./trunk/package/
#greenlet
cp -rf ./my_openwrt_mod/package/greenlet ./trunk/package/
#shairport-new
cp -rf ./my_openwrt_mod/package/shairport-new ./trunk/package/

#luci
cp -rf ./my_openwrt_mod/luci ./trunk/feeds/
patch -p0 ./trunk/feeds/luci/contrib/package/luci/Makefile < ./trunk/feeds/luci/contrib/package/luci/Makefile.diff
rm ./trunk/feeds/luci/contrib/package/luci/Makefile.diff

#files
cp -rf ./my_openwrt_mod/files ./trunk/

#add yaaw
#cp -rf ./yaaw ./trunk/feeds/luci/modules/admin-core/root/www/
#add webui-aria2
#cp -rf ./webui-aria2 ./trunk/feeds/luci/modules/admin-core/root/www/

#delete my_openwrt_mod
rm -rf ./my_openwrt_mod

#save dl files to dl-trunk
if [ ! -d dl-trunk ]; then
    mkdir ~/openwrt/dl-trunk
fi

#make
cd trunk
# create symbolic link to download directory
if [ ! -d dl ]; then
    ln -s ~/openwrt/dl-trunk dl
fi

#make defconfig
#cp ../db120-openwrt-scripts/trunk/config.db120 ./.config
#cp ../db120-openwrt-scripts/trunk/config.db120.pdnsd+dnscrypt ./.config
#cp ../db120-openwrt-scripts/trunk/config.db120.pdnsd ./.config
#make menuconfig
#make V=99
