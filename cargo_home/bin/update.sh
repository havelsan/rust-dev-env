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

rm -Rf $CARGO_HOME/work
mkdir -p $CARGO_HOME/work
cd $CARGO_HOME/work
cargo init
cd -
cp $1 $CARGO_HOME/work/Cargo.toml
cd $CARGO_HOME/work
cargo fetch 


