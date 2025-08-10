#!/bin/bash

if [ ! -f ./release ]
then
	echo "Please run this script within its own directory : ./install.sh"
	exit 1
else
        grep GITEA_HOME release > /dev/null
	if [ $? != 0 ]
	then
	    echo "release file in this directory does not contain GITEA_HOME variable"
	    exit 1
	fi
fi


wget --no-check-certificate https://dl.gitea.com/gitea/
GITEA_VERSION=$(grep 'href="/gitea/' index.html | head -1| sed -e 's#.*href="/gitea/##'| sed -e 's#/.*##' | sed -e 's#".*##')
rm -f index.html*

GITEA_OS_ARCH=linux-amd64
GITEA_APP_INI_FILE=./gitea.app.ini

source ./release

mkdir -p bin
mkdir -p custom/conf
mkdir -p data/gitea-repositories
mkdir -p data/lfs
mkdir -p log

mv ./gitea.app.ini custom/conf/app.ini.default
cp custom/conf/app.ini.default custom/conf/app.ini

perl -pi -e "s/GITEA_RUN_USER/$USER/g" custom/conf/app.ini
perl -pi -e "s#GITEA_HOME#$GITEA_HOME#g" custom/conf/app.ini
 
wget --no-check-certificate https://dl.gitea.com/gitea/$GITEA_VERSION/gitea-$GITEA_VERSION-$GITEA_OS_ARCH.xz
xz -d -v gitea-$GITEA_VERSION-$GITEA_OS_ARCH.xz
chmod +x gitea-$GITEA_VERSION-$GITEA_OS_ARCH

rm -f gitea_executable
ln -s gitea-$GITEA_VERSION-$GITEA_OS_ARCH gitea_executable
mv gitea-$GITEA_VERSION-$GITEA_OS_ARCH gitea_executable bin

chmod +x run.sh
mv run.sh bin/run_gitea.sh

chmod +x update.sh
mv update.sh bin/update_thirdparty_gitea.sh







