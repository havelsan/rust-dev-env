# Updating Local Thirdparty Crate Registry


## Download the crates using a machine connected to internet :

1. Use always the same account to download the crates, so that every admin will connect to the same account and see accumulate the previously downloaded crates.
2. ssh to a machine which has internet connection.
3. In that account, ONLY for the first time, run the following steps (if you already executed the following steps, you may ommit this step): 
 - if you not already did, do the steps in "01.preparing-rust-sdk-directory" and source the release "source $HOME/sdk/infra/1.0.0/release"
 - if you are behind a proxy run the "cd ../../src/prepare-env-scripts/; ./04.configure.proxy.sh "
 - Prepare an empty rust project dir:
   + mkdir -p $HOME/download-crates
   + cd $HOME/download-crates
   + cargo init
4. run command : "source $HOME/release.proxy" if you are behind a proxy. (release.proxy file is created by 04.configure.proxy.sh script)
5. cd $HOME/download-crates
6. mkdir -p backup
7. cp Cargo.toml backup/Cargo.toml.$(date '+%Y%m%d%H%M%S')
8. Remove previous dependencies:
  - run the script "cd ../../src/prepare-env-scripts/; 04.clean.previous.dependencies.sh"
6. For each module and its version write the followwing command
 - cargo add --registry=crates-io <module>@<version> # for example : cargo add --registry=crates-io serde@1.0.100
 - cargo update -p <module> --precise <version> # for example : cargo update -p serde --precise 1.0.100
7. Download using the following command :
 - cargo fetch


## Pack all the downloaded crates (libraries) and copy to a intranet computer

1. run the script "cd ../../src/prepare-env-scripts/; ./04.pack.all.downloaded.in.this.day.sh " 
  - This script makes a tar.gz package of all the modules downloaded in the same day. and copies it to $HOME/creates directory. 
2. copy the $HOME/crates/crates.$(date '+%Y%m%d').tar.gz file to a intranet computer into the directory __$HOME/import_crates__
  - NOTE-1: crates.20241209.tar.gz means the packages of creates which are downloaded in 9 December 2024
  - NOTE-2: we assume local repository is found in the intranet. 


## UnPack the last copied tar.gz file and upload to cargo-thirdparty local repository

0. This step of installation should be made by someone who has write access to cargo-thirdparty repository.
1. run the script "cd ../../src/prepare-env-scripts/; ./04.unpack.and.upload.to.local.cargo-thirdpaty.registry.sh " 

Any of the crate publish (cargo-thirdparty registry) may fail with the following messsage, as it is written, this is because the crate already exists, no need to panic :)
 
```
error: failed to publish to registry at http://localhost:3000/api/packages/cargo-thirdparty/cargo

Caused by:
  the remote server responded with an error (status 409 Conflict): package version already exists
```

 

