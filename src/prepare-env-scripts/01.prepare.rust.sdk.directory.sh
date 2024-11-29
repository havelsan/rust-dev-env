#Goto https://forge.rust-lang.org/infra/other-installation-methods.html
#Find the Standalone Installers section.
#Find the rust version compatible with your machine and download ( for me it is x86_64-unknown-linux-gnu) 
#Then create rust sdk dir and prepare release files.

if [ $# -gt 0 ]
then
     RUST_VERSION=$1
else
     RUST_VERSION=rust-1.82.0-x86_64-unknown-linux-gnu
fi

mkdir -p $HOME/tmp
cd $HOME/tmp
rm -Rf $RUST_VERSION*

wget --no-check-certificate https://static.rust-lang.org/dist/$RUST_VERSION.tar.xz
mkdir -p $HOME/sdk/tools
mkdir -p $HOME/sdk/infra/1.0.0/
tar xvf $RUST_VERSION.tar.xz
cd $RUST_VERSION
./install.sh --prefix=$HOME/sdk/infra/1.0.0/$RUST_VERSION

echo '#!/bin/bash
export RUST_HOME=`cd \`dirname $( readlink -f $BASH_SOURCE ) \` && pwd`
export PATH=$PATH:$RUST_HOME/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$RUST_HOME/lib
export CARGO_HTTP_CHECK_REVOKE=false
WHICH_RUSTC=$(which rustc)
RUSTC_VERSION=$(rustc --version)
echo ">>> RUST_HOME=$RUST_HOME "
'  > $HOME/sdk/infra/1.0.0/$RUST_VERSION/release

echo '#!/bin/bash
export SDK_INFRA_DIR=`cd \`dirname $( readlink -f $BASH_SOURCE ) \` && pwd`
export SDK_VERSION=$(echo $SDK_INFRA_DIR| sed -e "s#.*/sdk/infra/##")
for i in $SDK_INFRA_DIR/*
do
	if [ -e $i/release ]
	then
		. $i/release
	fi
done
' > $HOME/sdk/infra/1.0.0/release


echo '#!/bin/bash
export SDK_TOOLS_DIR=`cd \`dirname $( readlink -f $BASH_SOURCE ) \` && pwd`

for i in $SDK_TOOLS_DIR/*
do
	if [ -e $i/release ]
	then
		. $i/release
	fi
done
' > $HOME/sdk/tools/release



