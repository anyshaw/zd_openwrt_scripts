#!/bin/sh

cd ~/openwrt/pandorabox
# update source
svn update

# update feeds
./scripts/feeds update -a
./scripts/feeds install -a

# create symbolic link to download directory
if [ ! -d dl ]; then
	ln -s ~/openwrt/dl-pandorabox dl
fi

make defconfig

echo "Make clean? Please answer yes or no."
read YES_OR_NO
case "$YES_OR_NO" in
	yes|y|Yes|YES)
		make clean
		make V=99
	;;

	[nN]*)
		echo "DO NOT make clean!"
		make V=99
	;;

	*)
		echo "Sorry, $YES_OR_NO not recognized. Enter yes or no."
		exit 1
	;;
esac