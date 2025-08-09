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

echo '#!/bin/bash
export RUST_HOME=`cd \`dirname $( readlink -f $BASH_SOURCE ) \` && pwd`
export PATH=$RUST_HOME/bin:$PATH
export LD_LIBRARY_PATH=$RUST_HOME/lib:$RUST_HOME/lib/rustlib/x86_64-unknown-linux-gnu/lib/:$LD_LIBRARY_PATH
export LIBRARY_PATH=$RUST_HOME/lib:$RUST_HOME/lib/rustlib/x86_64-unknown-linux-gnu/lib/:$LIBRARY_PATH
export LIBRARY_PATH=$RUST_HOME/lib:$RUST_HOME/lib/rustlib/x86_64-unknown-linux-gnu/lib/:$LIBRARY_PATH
export CPATH=$RUST_HOME/lib:$RUST_HOME/lib/rustlib/x86_64-unknown-linux-gnu/lib/:$CPATH
export CARGO_HTTP_CHECK_REVOKE=false
WHICH_RUSTC=$(which rustc)
RUSTC_VERSION=$(rustc --version)

echo ">>> RUST_HOME=$RUST_HOME "
echo ">>> RUSTC_VERSION=$RUSTC_VERSION "
'  > release


