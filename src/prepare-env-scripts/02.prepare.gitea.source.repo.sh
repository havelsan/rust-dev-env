
if [ $# -lt 3 ]
then
  GITEA_VERSION=1.24.2
  GITEA_OS_ARCH=linux-amd64
  GITEA_APP_INI_FILE=./gitea.app.ini
else
  GITEA_VERSION=$1
  GITEA_OS_ARCH=$2
  GITEA_APP_INI_FILE=$3
fi

if [ ! -f $GITEA_APP_INI_FILE ]
then
   echo "please go into the directory that conntains the file $GITEA_APP_INI_FILE"
   echo "quiting..."
   exit 1
fi


export GITEA_HOME=$HOME/sdk/tools/1.0.0/gitea-$GITEA_VERSION/
rm -Rf $GITEA_HOME
mkdir -p $GITEA_HOME/custom/conf
mkdir -p $GITEA_HOME/data/gitea-repositories
mkdir -p $GITEA_HOME/data/lfs
mkdir -p $GITEA_HOME/log

cp ./gitea.app.ini $GITEA_HOME/custom/conf/app.ini
#cp ./gitea.db $GITEA_HOME/data

perl -pi -e "s/GITEA_RUN_USER/$USER/g" $GITEA_HOME/custom/conf/app.ini
perl -pi -e "s#GITEA_HOME#$GITEA_HOME#g" $GITEA_HOME/custom/conf/app.ini
 
mkdir -p $HOME/tmp
cd $HOME/tmp
if [ ! -f  gitea-$GITEA_VERSION-$GITEA_OS_ARCH*.xz* ]
then
    wget --no-check-certificate https://dl.gitea.com/gitea/$GITEA_VERSION/gitea-$GITEA_VERSION-$GITEA_OS_ARCH.xz
fi
xz -d -v gitea-$GITEA_VERSION-$GITEA_OS_ARCH.xz
chmod +x gitea-$GITEA_VERSION-$GITEA_OS_ARCH




mv gitea-$GITEA_VERSION-$GITEA_OS_ARCH $GITEA_HOME

cd $GITEA_HOME

rm -f gitea_executable
ln -s gitea-$GITEA_VERSION-$GITEA_OS_ARCH gitea_executable

echo '#!/bin/bash
export GITEA_HOME=`cd \`dirname $( readlink -f $BASH_SOURCE ) \` && pwd`
export PATH=$PATH:$GITEA_HOME/

echo ">>> GITEA_HOME=$GITEA_HOME "
'  >release

echo '#!/bin/bash
cd $GITEA_HOME
nohup ./gitea_executable >& $GITEA_HOME/log/gitea.run.log &
' > run.sh
chmod +x run.sh






