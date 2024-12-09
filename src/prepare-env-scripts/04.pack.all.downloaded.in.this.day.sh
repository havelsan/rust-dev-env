cd $HOME/.cargo/registry/src/index.crates.io*/
rm -f crates.$(date '+%Y%m%d').tar.gz
tar cvzf crates.$(date '+%Y%m%d').tar.gz $(find .  -maxdepth 1 -mtime -1 -type d| grep '\./'| sed -e 's#./##')
mkdir -p $HOME/crates
mv crates.$(date '+%Y%m%d').tar.gz $HOME/crates

