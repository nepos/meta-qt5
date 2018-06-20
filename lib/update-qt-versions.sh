#!/bin/sh

GIT=https://code.qt.io/cgit/qt
VERSION=$1
MODULES="				\
	qt3d				\
	qtbase				\
	qtbase-native			\
	qtcanvas3d			\
	qtcharts			\
	qtconnectivity			\
	qtdatavis3d			\
	qtdeclarative			\
	qtgamepad			\
	qtgraphicaleffects		\
	qtimageformats			\
	qtknx				\
	qtlocation			\
	qtmqtt				\
	qtmultimedia			\
	qtnetworkauth			\
	qtpurchasing			\
	qtquickcontrols2		\
	qtquickcontrols			\
	qtremoteobjects			\
	qtscript			\
	qtscxml				\
	qtsensors			\
	qtserialbus			\
	qtserialport			\
	qtsvg				\
	qttools				\
	qttranslations			\
	qtvirtualkeyboard		\
	qtwayland			\
	qtwebchannel			\
	qtwebengine			\
	qtwebsockets			\
	qtwebview			\
	qtx11extras			\
	qtxmlpatterns			\
"

if [ -z "$VERSION" ]; then
	echo "Usage: $0 <version>"
	exit 1
fi

if [ ! -f README ]; then
	echo "Error: must be called from top-level of meta-qt5."
	exit 1
fi

for m in $MODULES; do
        p=${m%-native}
        sha=$(git ls-remote $GIT/$p.git refs/tags/v$VERSION | cut -f1)

	if [ -z "$sha" ]; then
		echo "Unable to determine SHA1 of module $m!"
		continue
	fi

        echo "$m is now at SHA1 $sha"
        sed -i -e 's/SRCREV = ".*"/SRCREV = "'$sha'"/' recipes-qt/qt5/${m}_git.bb
done

sed -i \
	-e 's/QT_MODULE_BRANCH ?= ".*"/QT_MODULE_BRANCH ?= "'$VERSION'"/' \
	-e 's/PV = ".*"/PV = "'$VERSION'+git${SRCPV}"/' \
	recipes-qt/qt5/qt5-git.inc

