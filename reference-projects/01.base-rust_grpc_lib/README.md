# LIBRARY EXAMPLE

- We make a demostration of rust library usage as grpc microservice architecture.
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

## publish project-01 crate

```
cd project-01
cargo build
cargo publish --registry=cargo-test  --allow-dirty
```
after running these commands , you should see the uploaded package "project-01" on the page "http://localhost:3000/cargo-test/-/packages"
IMPOTANT NOTE: you have to indicate the generated grpc code in the lib.rs file as "pub mod PROTO_FILE_NAME" like "pub mod helloworld" .

## use proto in project-01 from project-02 service
We used the proto library "project-01" in server project (project-02) and client project (project-03).
To use the project-01 in those projects we put dependency in the Cargo.toml file and used in server.rs and client.rs as "use project_01::helloworld:: ...." 
