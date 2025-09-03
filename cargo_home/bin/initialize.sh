#!/bin/bash

CURRENT_TIMESTAMP=$(date '+%Y%m%d%H%M%S')

which cargo >/dev/null

if [ $? != 0 ]
then
   echo " Source rust-dev-env/release please, cargo command can not be found"
   exit 1
fi

$CARGO_HOME/bin/update.sh $CARGO_HOME/etc/initial.Cargo.toml


