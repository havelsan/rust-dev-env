which cargo
if [ $? != 0 ]
then
   echo " Source sdk release please, cargo command can not be found"
   exit 1
fi


cd $HOME/import_crates

rm -Rf tmp
mkdir -p tmp
last_tr_gz=$(ls -rt *.tar.gz| tail -1)
cd tmp
tar xvzf ../$last_tr_gz >&/dev/null
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


rm -Rf $CURRENT_DIR


