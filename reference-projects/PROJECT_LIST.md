# Rust Reference Projects
The reference projects in the below list focuses only on a specific subject with minimal code.

1. Base
    - Standard Rust Project Layout : [Project Layout](https://doc.rust-lang.org/cargo/guide/project-layout.html) 
        - Cargo.toml , .cargo/config.toml , src directory , tests directory (test directory for integration tests  not unit tests) ,  benches directory , examples directory
        - The [.gitignore](../../.gitignore) file in the main directory of the project ( we assume this is where .git directory resides, each project has a different git repository) should contain "target/" string to prevent generated files to be commit to git. We also add *.rpm, *.deb, *.tar, *.tar.gz, *.zip entries to the .gitignore file, as shown below:
            * target/
            * *.rpm
            * *.deb
            * *.tar
            * *.tar.gz
            * *.zip
    - [Debugging With Gdb : Fast Introduction](../../src/rust-project-templates/1.i.base-debuggable-executable)
        - NOTE-1: project-01/build.sh file contains gdb usage commands.
        - NOTE-2: 'cargo build' command by default places debug information intothe generated  binary, 'cargo build --release' clears debug information from the binary.
    - [Minimum Size Executable](../../src/rust-project-templates/1.ii.base-minimum_sized_executable) 
         - Binary size with "cargo build" command is 3.6 MB (hello world application). The generated binary contains symbols and debug info
         - compile parameters for optimization stripping (300 K, hello world application) (project-01/Cargo.toml compile paramaters)
         - non static binary, depending on other libs and rust env. (15K , hello world application) (project-02/build.sh compile paramaters)         
    - [Versioning and dependency management](../../src/rust-project-templates/1.iii.base-versioning_and_dependency_management) 
         - You only write direct dependencies, cargo build system will resolv sub dependencies. Similiar functionality as maven/gradle.
         - dev-dependencies only used when compiling examples, tests, benches ( e.g. : cargo build --examples )
         - "cargo tree" shows sub dependencies.
         - "cargo info time@1.0.0" gives information about the time package with version 1.0.0
         - if the project  depends on module "log" with version :
             * log = "^1.2.3" is exactly equivalent to log = "1.2.3".
             * log="~1.2.3"  is for  >=1.2.3, <1.3.0
             * log="~1.2"  is for  >=1.2.0,  <1.3.0
             * log="~1"  is for  >=1.0.0,  <2.0.0
             * log="*"  is for  >=0.0.0
             * log="1.*"  is for  >=1.0.0,  <2.0.0
             * log="1.2.*"  is for  >=1.2.0,  <1.3.0
    - [Rust Project Configurations](../../src/rust-project-templates/1.iv.base-rust_project_configurations)
         - If, for example, Cargo were invoked in /projects/foo/bar/baz, then the following configuration files would be probed for and unified in this order:
             * /projects/foo/.cargo/config.toml
             * /projects/.cargo/config.toml
             * /.cargo/config.toml
             * $CARGO_HOME/config.toml which defaults to $HOME/.cargo/config.toml
        - If a key is specified in multiple config files, the values will get merged together. 
             * Numbers, strings, and booleans will use the value in the deeper config directory taking precedence over ancestor directories
        - Credentials are stored in $HOME/.cargo/credentials.toml , but registry/repository urls are stored in $HOME/.cargo/config.toml file. This will be explained in the next section.
        - NOTE: there is no way to override the variables in Cargo.toml using config.toml files. You should replace the key in Cargo.toml file using a linux command before executing it.
            * For Example : perl -pi -e "s/mykey=.*/mykey=$ENVVAR/" Cargo.toml
    - Publishing to a registry is explained in the item 11 of [Preparing Local Create Repository](../03.preparing-local-crate-repository)

--------------------
    - Rust Lib:
        - Create the project with "cargo new a_service_api_01 --lib", this command creates a_service_api_01 directory with Cargo.toml and src/lib.rs example files inside.
        - Write tests before writing the main code.
        - Write some functionality in  a_service_api_01
        - Compile and publish the a_service_api_01
        - Create a_service_01 project that a_service_api_01 forward the requests
        - Create a_user_project_01 that uses a_service_api_01 to reach the a_service_01 service.
        - Create a starter script to test all.
    - RDLIB : Rust dynamic lib with binary so.
    - Packaging
        - project/platform configurations 
        - RPM 
        - DEB 
        - Publishing DEB and RPM packages are explained in 
2. Code Quality: clippy
2. Validation in Code : (https://github.com/jprochazk/garde)
2. Test
    1. Unit 
    2. Integration 
    3. Fuzz 
    4. Scenario 
    5. Test code generation
    6. Selenium tests 
    7. Test driven development 
    8. Data driven test 
    9. Tackle-test
3. Log4rs 
    1. Log usage templates 
    2. log redirection to LogServer 
    3. Probe placement strategies
4. Web
    1. Wasm 
    2. WebGL
    3. Rocket web framework
5. Data Science
    1. Array slicing 
    2. Aerospike usage and modules
    3. Redis usage and udf 
6. Network 
    1. Tokio and GRPC 
    2. Netty 
    3. secure connection and encrypt/decrypt 
7. AI
    1. Simple machine learning examples
    2. Burn 
    3. Trochrs
9. Architecture/Design Templates
    1. Compiletime API and Runtime Service Architecture
    2. Design pattern 
    3. Using Common Enumeration With Other Languages

