# LIBRARY EXAMPLE

- We will use [GRPC](https://github.com/hyperium/tonic/tree/master/examples) to communicate api (lib) and service.
- project-01 (LIB) : The project is api interface project that supplies the api to reach the related service.
    - "cargo new service_api_01 --lib" command creates service_api_01 directory with Cargo.toml and src/lib.rs example files inside.
- project-02 (SERVICE) :  service_01 project that service_api_01 forward the requests
- project-03 (CLIENT-APPLICATION):  This project uses service_api_01 to reach the service_01 service.
- Create a starter script to test all.

## Installations for GRPC on Ubuntu
We will install protobuff compiler into the rust-dev-env/grpc directory and use this compiler to generate rust code for corresponding proto files.
```
cd rust-dev-env
rm -Rf grpc
mkdir -p grpc
cd grpc
wget https://github.com/protocolbuffers/protobuf/releases
wget https://github.com/protocolbuffers/protobuf/releases/$(grep  protoc-.*-linux-x86_64.zip releases| sed -e 's/.*href="//'| sed -e 's/".*//' | head -1| sed -e 's/.*releases//')
rm releases
unzip protoc-*-linux-x86_64.zip 
echo '
export PROTOC_HOME=`cd \`dirname $( readlink -f $BASH_SOURCE ) \` && pwd`
export PATH=$PROTOC_HOME/bin:$PATH
' > release
```


