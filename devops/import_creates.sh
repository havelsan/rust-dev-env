#!/bin/bash

CURRENT_TIMESTAMP=$(date '+%Y%m%d%H%M%S')

which cargo >/dev/null


if [ $? != 0 ]
then
   echo " Source sdk release please, cargo command can not be found"
   exit 1
fi


if [ $# -lt 1 ]
then
        echo "Usage : $0 <tar_gz_file_containing_crates>"
        echo "Example : $0 crates.123123123.tar.gz"
        exit 1
fi


rm -Rf $HOME/import_crates
mkdir -p $HOME/import_crates

cp $1 $HOME/import_crates

cd $HOME/import_crates

tar xvzf *.tar.gz

for i in *
do
 if [ -d $HOME/import_crates/$i ]
 then
    cd $HOME/import_crates/$i
    echo ">>>> IMPORTING : $HOME/import_crates/$i"
    rm -f Cargo.toml.orig Cargo.lock
    cargo publish --registry=cargo-thirdparty
 fi
done

rm -Rf $HOME/import_crates

echo "#### $1 is imported "

