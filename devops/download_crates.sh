#!/bin/bash

CURRENT_TIMESTAMP=$(date '+%Y%m%d%H%M%S')

which cargo >/dev/null

if [ $? != 0 ]
then
   echo " Source rust-dev-env/release please, cargo command can not be found"
   exit 1
fi

if [ $# -lt 1 ]
then
        echo "Usage : $0 <cargo_toml_file>"
        exit 1
fi

rm -Rf $HOME/download-crates
mkdir -p $HOME/download-crates/cargo_home
cd $HOME/download-crates/
cargo init
rm -f Cargo.toml
cd -
export CARGO_HOME=$HOME/download-crates/cargo_home
cp $1 $HOME/download-crates/Cargo.toml
cd $HOME/download-crates
cargo fetch 

cd $HOME/download-crates/cargo_home/registry/src/index.crates.io-*/
tar cvfz crates.$CURRENT_TIMESTAMP.tar.gz *

mv crates.$CURRENT_TIMESTAMP.tar.gz $HOME

ls -l $HOME/crates.$CURRENT_TIMESTAMP.tar.gz

rm -Rf $HOME/download-crates

