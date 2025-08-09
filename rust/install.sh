#!/bin/bash
#Goto https://forge.rust-lang.org/infra/other-installation-methods.html
#Find the Standalone Installers section.
#Find the rust version compatible with your machine and download ( for me it is x86_64-unknown-linux-gnu) 
#Then create rust sdk dir and prepare release files.

if [ ! -f *.tar.xz ]
then
    wget --no-check-certificate https://forge.rust-lang.org/infra/other-installation-methods.html
    DOWNLOAD_URL=$(grep x86_64 other-installation-methods.html | grep  'https://.*dist/rust-[0-9].*-x86_64-unknown-linux-gnu.tar.xz' | sed -e 's/tar.xz.*/tar.xz/'| sed -e 's/.*"//'| grep https)
    wget --no-check-certificate $DOWNLOAD_URL
    rm other-installation-methods.html*
fi

tar xvf *.tar.xz

./rust-*/install.sh --prefix=.

d=$(ls *.tar.xz | sed -e 's/.tar.xz//')

#echo $d | cut -d- -f2 > VERSION

rm -Rf $d *.tar.xz

