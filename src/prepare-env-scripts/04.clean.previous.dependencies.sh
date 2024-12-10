which cargo
if [ $? != 0 ]
then
   echo " Source sdk release please, cargo command can not be found"
   exit 1
fi

cd $HOME/download-crates
for i in $(cat Cargo.toml| grep -v  'version' | egrep '= "[0-9]+\.[0-9]+\.[0-9]+"' | cut -d\= -f1); do    cargo remove $i>/dev/null; done

