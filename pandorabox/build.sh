#!/bin/sh

#apt-get install g++ libncurses5-dev zlib1g-dev bison flex unzip autoconf gawk make gettext gettext texinfo sharutils gcc binutils ncurses-term patch bzip2 libbz2-dev libz-dev asciidoc subversion sphinxsearch libtool git git-core curl

cd ~/openwrt

svn checkout svn://svn.openwrt.org.cn/dreambox/trunk pandorabox
git clone git://github.com/sancome/zd_openwrt_mod.git
#git clone git://github.com/binux/yaaw.git
#git clone git://github.com/ziahamza/webui-aria2.git

cp ./pandorabox/feeds.conf.default ./pandorabox/feeds.conf
#echo "src-git exopenwrt https://github.com/black-roland/exOpenWrt.git" >> ./pandorabox/feeds.conf
#echo "src-git mwan git://github.com/Adze1502/mwan.git" >> ./pandorabox/feeds.conf

./pandorabox/scripts/feeds update -a
./pandorabox/scripts/feeds install -a

#RA MOD
#package files
#openssl
cp -rf ./zd_openwrt_mod/package/openssl ./pandorabox/package/
patch -p0 ./pandorabox/package/openssl/Makefile < ./pandorabox/package/openssl/Makefile.diff
rm ./pandorabox/package/openssl/Makefile.diff
#switch vlan 96
cp -rf ./zd_openwrt_mod/package/switch ./pandorabox/package/
patch -p0 ./pandorabox/package/switch/src/switch-robo.c < ./pandorabox/package/switch/src/switch-robo.c.diff
rm ./pandorabox/package/switch/src/switch-robo.c.diff

#package install
#exfat-nofuse
cp -rf ./zd_openwrt_mod/package/exfat-nofuse ./pandorabox/package/
#redsocks
cp -rf ./zd_openwrt_mod/package/redsocks2/ ./pandorabox/package/
#shadowsocks-libev
cp -rf ./zd_openwrt_mod/package/shadowsocks-libev ./pandorabox/package/
#添加tsocks 远程dns支持
cp -rf ./zd_openwrt_mod/package/tsocks ./pandorabox/feeds/packages/net/
#dnscrypt-proxy
cp -rf ./zd_openwrt_mod/package/dnscrypt-proxy ./pandorabox/package/
#libsodium
cp -rf ./zd_openwrt_mod/package/libsodium ./pandorabox/package/
#nodejs
cp -rf ./zd_openwrt_mod/package/nodejs ./pandorabox/package/
#cpulimit-ng
cp -rf ./zd_openwrt_mod/package/cpulimit-ng ./pandorabox/package/
#gevent
cp -rf ./zd_openwrt_mod/package/gevent ./pandorabox/package/
#greenlet
cp -rf ./zd_openwrt_mod/package/greenlet ./pandorabox/package/
#shairport-new
cp -rf ./zd_openwrt_mod/package/shairport-new ./pandorabox/package/

#luci
cp -rf ./zd_openwrt_mod/luci ./pandorabox/feeds/
patch -p0 ./pandorabox/feeds/luci/contrib/package/luci/Makefile < ./pandorabox/feeds/luci/contrib/package/luci/Makefile.diff
rm ./pandorabox/feeds/luci/contrib/package/luci/Makefile.diff
#luci vlan 96
patch -p0 ./pandorabox/feeds/luci/modules/admin-full/luasrc/model/cbi/admin_network/vlan.lua < ./pandorabox/feeds/luci/modules/admin-full/luasrc/model/cbi/admin_network/vlan.lua.diff
rm ./pandorabox/feeds/luci/modules/admin-full/luasrc/model/cbi/admin_network/vlan.lua.diff

#files
cp -rf ./zd_openwrt_mod/files ./pandorabox/

#copy config files to folder, it's a bug for aa and pandorabox version, not for trunk
cp -rf ./zd_openwrt_mod/luci/applications/luci-pdnsd/root/etc ./pandorabox/files/
cp -rf ./zd_openwrt_mod/luci/applications/luci-vsftpd/root/etc ./pandorabox/files/
chmod 644 ./pandorabox/files/etc/pdnsd.conf

#add yaaw
#cp -rf ./yaaw ./pandorabox/feeds/luci/modules/admin-core/root/www/
#add webui-aria2
#cp -rf ./webui-aria2 ./pandorabox/feeds/luci/modules/admin-core/root/www/

#delete zd_openwrt_mod
rm -rf ./zd_openwrt_mod

#save dl files to dl-pandorabox
if [ ! -d dl-pandorabox ]; then
    mkdir ~/openwrt/dl-pandorabox
fi

#make
cd pandorabox
# create symbolic link to download directory
if [ ! -d dl ]; then
    ln -s ~/openwrt/dl-pandorabox dl
fi

#make defconfig
#cp ../zd_openwrt_scripts/pandorabox/config.db120 ./.config
#make menuconfig
#make V=99
