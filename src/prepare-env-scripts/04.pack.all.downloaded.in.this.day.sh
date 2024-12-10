CURRENT_DATE=$(date '+%Y%m%d')
cd $HOME/.cargo/registry/src/index.crates.io*/
rm -f crates.$CURRENT_DATE.tar.gz
tar cvzf crates.$CURRENT_DATE.tar.gz $(find .  -maxdepth 1 -mtime -1 -type d| grep '\./'| sed -e 's#./##')
mkdir -p $HOME/crates
mv crates.$CURRENT_DATE.tar.gz $HOME/crates

