#!/bin/sh

#apt-get install g++ libncurses5-dev zlib1g-dev bison flex unzip autoconf gawk make gettext gettext texinfo sharutils gcc binutils ncurses-term patch bzip2 libbz2-dev libz-dev asciidoc subversion sphinxsearch libtool git git-core curl

cd ~/openwrt

svn checkout svn://svn.openwrt.org/openwrt/trunk trunk
git clone git://github.com/sancome/zd_openwrt_mod.git
#git clone git://github.com/binux/yaaw.git
#git clone git://github.com/ziahamza/webui-aria2.git

cp ./trunk/feeds.conf.default ./trunk/feeds.conf
#echo "src-git exopenwrt https://github.com/black-roland/exOpenWrt.git" >> ./trunk/feeds.conf
#echo "src-git mwan git://github.com/Adze1502/mwan.git" >> ./trunk/feeds.conf

./trunk/scripts/feeds update -a
./trunk/scripts/feeds install -a

#RA MOD
#package files
#openssl
cp -rf ./zd_openwrt_mod/package/openssl ./trunk/package/libs/
patch -p0 ./trunk/package/libs/openssl/Makefile < ./trunk/package/libs/openssl/Makefile.diff
rm ./trunk/package/libs/openssl/Makefile.diff

#package install
#exfat-nofuse
cp -rf ./zd_openwrt_mod/package/exfat-nofuse ./trunk/package/
#redsocks
cp -rf ./zd_openwrt_mod/package/redsocks2/ ./trunk/package/
#shadowsocks-libev
cp -rf ./zd_openwrt_mod/package/shadowsocks-libev ./trunk/package/
#添加tsocks 远程dns支持
cp -rf ./zd_openwrt_mod/package/tsocks ./trunk/feeds/packages/net/
#dnscrypt-proxy
cp -rf ./zd_openwrt_mod/package/dnscrypt-proxy ./trunk/package/
#libsodium
cp -rf ./zd_openwrt_mod/package/libsodium ./trunk/package/
#nodejs
cp -rf ./zd_openwrt_mod/package/nodejs ./trunk/package/
#cpulimit-ng
cp -rf ./zd_openwrt_mod/package/cpulimit-ng ./trunk/package/
#gevent
cp -rf ./zd_openwrt_mod/package/gevent ./trunk/package/
#greenlet
cp -rf ./zd_openwrt_mod/package/greenlet ./trunk/package/
#shairport-new
cp -rf ./zd_openwrt_mod/package/shairport-new ./trunk/package/
#gmediarender
cp -rf ./zd_openwrt_mod/package/gmediarender ./trunk/package/

#luci
cp -rf ./zd_openwrt_mod/luci ./trunk/feeds/
patch -p0 ./trunk/feeds/luci/contrib/package/luci/Makefile < ./trunk/feeds/luci/contrib/package/luci/Makefile.diff
rm ./trunk/feeds/luci/contrib/package/luci/Makefile.diff

#files
cp -rf ./zd_openwrt_mod/files ./trunk/

#add yaaw
#cp -rf ./yaaw ./trunk/feeds/luci/modules/admin-core/root/www/
#add webui-aria2
#cp -rf ./webui-aria2 ./trunk/feeds/luci/modules/admin-core/root/www/

#delete zd_openwrt_mod
rm -rf ./zd_openwrt_mod

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
#cp ../zd_openwrt_scripts/trunk/config.db120 ./.config
#make menuconfig
#make V=99
