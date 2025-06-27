# Preparing Rust SDK Directory
This section contains rust sdk directory preparation scripts and documentation.

1. Goto https://forge.rust-lang.org/infra/other-installation-methods.html
2. Find the Standalone Installers section.
3. Find the rust version compatible with your machine and download ( for me it is x86_64-unknown-linux-gnu) 
   (wget --no-check-certificate https://static.rust-lang.org/dist/rust-1.82.0-x86_64-unknown-linux-gnu.tar.xz)
4. run the ../../src/prepare-env-scripts/01.prepare.rust.sdk.directory.sh  script with the download file's name without tar.xz (for me it is rust-1.82.0-x86_64-unknown-linux-gnu)
   for example : "cd ../../src/prepare-env-scripts/; ./01.prepare.rust.sdk.directory.sh rust-1.82.0-x86_64-unknown-linux-gnu"
   This script creates $HOME/tmp directory and creates temperary files in this directory, you may delete this directory manually after installation.
   This script creates $HOME/sdk directory amd installs rust and release files in this directory. You may move this directory anuwhere you want. ( For example /opt/sdk, then mount this directory from other developers' computers using nfs readonly)
   You should source the $HOME/sdk/infra/1.0.0/release to use rust environment.
 
