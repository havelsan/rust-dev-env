# Preparing IDEs
VSCode, Helix 

## Preparing VSCode 

1. Download vscode :
```
mkdir -p $HOME/workspace
cd $HOME/workspace
wget  "https://code.visualstudio.com/sha/download?build=stable&os=linux-x64"
mv 'download?build=stable&os=linux-x64' VSCode-linux-x64.tar.gz
tar xvzf VSCode-linux-x64.tar.gz
```

2. Install rust extensions :
  - Assumption : While installing rust extensions, VSCode should be running on a machine taht has no internet restriction. After installing the extensions, you may move it to intranet that has no internet connection.
  - cd $HOME/workspace/VSCode-linux-x64 
  - mkdir extensions
  - ___./code --extensions-dir $HOME/workspace/VSCode-linux-x64/extensions___ 
  - Press " Ctrl + Shift + x "  for extension screen.
  - install "Rust Extension Pack" , caution: there are some other plugins that have the same name, this pack hast the following sub components :
   * Rust Analyzer
   * Even Better TOML
   * Code LLDB
   * Dependi
   * Rust config
  - install also
   * Cargo.toml Snippets
   * Cargo
   * Rust test generator
   * Rust test explorer
   * Rust test lens
      
3. Place VSCode in tools directory
```
mkdir -p $HOME/workspace
cd $HOME/workspace
mv VSCode-linux-x64 ~/sdk/tools/1.0.0/
```

4. Write $HOME/sdk/tools/1.0.0/VSCode-linux-x64/release file
```
#!/bin/bash
export VSCODE_HOME=`cd \`dirname $( readlink -f $BASH_SOURCE ) \` && pwd`
export PATH=$PATH:$VSCODE_HOME
echo ">>> VSCODE_HOME=$VSCODE_HOME "
```

5. Write $HOME/sdk/tools/1.0.0/VSCode-linux-x64/start_vscode.sh and make it executable
```
#!/bin/bash

if [ "$VSCODE_HOME" = "" ]
then
  echo "Please source the VSCode release file first, or set VSCODE_HOME env. vraiable"
  exit 1
fi

cd $VSCODE_HOME

./code --extensions-dir $VSCODE_HOME/extensions

```


## Preparing Helix


1. Checkout and build Helix :
```
mkdir -p $HOME/workspace
cd $HOME/workspace
git clone https://github.com/helix-editor/helix
. ~/sdk/infra/1.0.0/release ## to source rust release.
cd helix
cargo install --path helix-term --locked

```

2. Move hx binary to the sdk directory
```
cd $HOME/workspace
mkdir ~/sdk/tools/1.0.0/helix
mv target/release/hx  ~/sdk/tools/1.0.0/helix
```

3. Create  ~/sdk/tools/1.0.0/helix/release file
```
#!/bin/bash
export HELIX_HOME=`cd \`dirname $( readlink -f $BASH_SOURCE ) \` && pwd`
export PATH=$PATH:$HELIX_HOME
echo ">>> HELIX_HOME=$HELIX_HOME "
```





