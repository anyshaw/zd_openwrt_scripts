#!/bin/sh

#apt-get install g++ libncurses5-dev zlib1g-dev bison flex unzip autoconf gawk make gettext gettext texinfo sharutils gcc binutils ncurses-term patch bzip2 libbz2-dev libz-dev asciidoc subversion sphinxsearch libtool git git-core curl

cd ~/openwrt

#svn checkout svn://svn.openwrt.org/openwrt/branches/attitude_adjustment attitude_adjustment
git clone git://git.openwrt.org/12.09/openwrt.git attitude_adjustment
git clone git://github.com/sancome/zd_openwrt_mod.git
#git clone git://github.com/binux/yaaw.git
#git clone git://github.com/ziahamza/webui-aria2.git

cp ./attitude_adjustment/feeds.conf.default ./attitude_adjustment/feeds.conf
sed -i 's/\/contrib\/package//g' ./attitude_adjustment/feeds.conf
#echo "src-git exopenwrt https://github.com/black-roland/exOpenWrt.git" >> ./attitude_adjustment/feeds.conf
#echo "src-git mwan git://github.com/Adze1502/mwan.git" >> ./attitude_adjustment/feeds.conf

./attitude_adjustment/scripts/feeds update -a
./attitude_adjustment/scripts/feeds install -a

#RA MOD
#package files
#openssl
cp -rf ./zd_openwrt_mod/package/openssl ./attitude_adjustment/package/
patch -p0 ./attitude_adjustment/package/openssl/Makefile < ./attitude_adjustment/package/openssl/Makefile.diff
rm ./attitude_adjustment/package/openssl/Makefile.diff
#switch vlan 96
cp -rf ./zd_openwrt_mod/package/switch ./attitude_adjustment/package/
patch -p0 ./attitude_adjustment/package/switch/src/switch-robo.c < ./attitude_adjustment/package/switch/src/switch-robo.c.diff
rm ./attitude_adjustment/package/switch/src/switch-robo.c.diff

#package install
#exfat-nofuse
cp -rf ./zd_openwrt_mod/package/exfat-nofuse ./attitude_adjustment/package/
#redsocks
cp -rf ./zd_openwrt_mod/package/redsocks2/ ./attitude_adjustment/package/
#shadowsocks-libev
cp -rf ./zd_openwrt_mod/package/shadowsocks-libev ./attitude_adjustment/package/
#添加tsocks 远程dns支持
cp -rf ./zd_openwrt_mod/package/tsocks ./attitude_adjustment/feeds/packages/net/
#dnscrypt-proxy
cp -rf ./zd_openwrt_mod/package/dnscrypt-proxy ./attitude_adjustment/package/
#libsodium
cp -rf ./zd_openwrt_mod/package/libsodium ./attitude_adjustment/package/
#nodejs
cp -rf ./zd_openwrt_mod/package/nodejs ./attitude_adjustment/package/
#cpulimit-ng
cp -rf ./zd_openwrt_mod/package/cpulimit-ng ./attitude_adjustment/package/
#gevent
cp -rf ./zd_openwrt_mod/package/gevent ./attitude_adjustment/package/
#greenlet
cp -rf ./zd_openwrt_mod/package/greenlet ./attitude_adjustment/package/
#shairport-new
cp -rf ./zd_openwrt_mod/package/shairport-new ./attitude_adjustment/package/
#gmediarender
cp -rf ./zd_openwrt_mod/package/gmediarender ./attitude_adjustment/package/

#luci
cp -rf ./zd_openwrt_mod/luci ./attitude_adjustment/feeds/
patch -p0 ./attitude_adjustment/feeds/luci/contrib/package/luci/Makefile < ./attitude_adjustment/feeds/luci/contrib/package/luci/Makefile.diff
rm ./attitude_adjustment/feeds/luci/contrib/package/luci/Makefile.diff
#luci vlan 96
patch -p0 ./attitude_adjustment/feeds/luci/modules/admin-full/luasrc/model/cbi/admin_network/vlan.lua < ./attitude_adjustment/feeds/luci/modules/admin-full/luasrc/model/cbi/admin_network/vlan.lua.diff
rm ./attitude_adjustment/feeds/luci/modules/admin-full/luasrc/model/cbi/admin_network/vlan.lua.diff

#files
cp -rf ./zd_openwrt_mod/files ./attitude_adjustment/

#copy config files to folder, it's a bug for aa and pandorabox version, not for trunk
cp -rf ./zd_openwrt_mod/luci/applications/luci-pdnsd/root/etc ./attitude_adjustment/files/
cp -rf ./zd_openwrt_mod/luci/applications/luci-vsftpd/root/etc ./attitude_adjustment/files/
chmod 644 ./attitude_adjustment/files/etc/pdnsd.conf

#add yaaw
#cp -rf ./yaaw ./attitude_adjustment/feeds/luci/modules/admin-core/root/www/
#add webui-aria2
#cp -rf ./webui-aria2 ./attitude_adjustment/feeds/luci/modules/admin-core/root/www/

#delete zd_openwrt_mod
rm -rf ./zd_openwrt_mod

#save dl files to dl-attitude_adjustment
if [ ! -d dl-attitude_adjustment ]; then
    mkdir ~/openwrt/dl-attitude_adjustment
fi

#make
cd attitude_adjustment
# create symbolic link to download directory
if [ ! -d dl ]; then
    ln -s ~/openwrt/dl-attitude_adjustment dl
fi

#make defconfig
#cp ../zd_openwrt_scripts/attitude_adjustment/config.db120 ./.config
#make menuconfig
#make V=99
