#!/bin/bash

which cargo

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

CARGO_TOML_FILE=$1

rm -Rf $HOME/download-crates
mkdir -p $HOME/download-crates
cd $HOME/download-crates
cargo init
cd -
rm -f $HOME/download-crates/Cargo.toml
cp -f $CARGO_TOML_FILE $HOME/download-crates/Cargo.toml
cd $HOME/download-crates/

cargo fetch

cd $HOME/.cargo/registry/src/index.crates.io*/
CURRENT_DIR=$(pwd)
for i in *
do
 if [ -d $CURRENT_DIR/$i ]
 then
    cd $CURRENT_DIR/$i
    echo $CURRENT_DIR/$i
    rm -f Cargo.toml.orig Cargo.lock
    cargo publish --registry=cargo-thirdparty
 fi
done



rm -Rf $HOME/download-crates

