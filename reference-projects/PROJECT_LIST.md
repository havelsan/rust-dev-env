# Rust Reference Projects
The reference projects in the below list focuses only on a specific subject with minimal code.

1. Base
    - [ Rust Documents ](../rust/share/doc/)
    - We use Cargo.toml file in a project directory to build and configure the project.
    - [ Debugging a project (gdb command is written in the build.sh) ](./01.base-debug)
         - "cargo build --release" clears debug information from the binary, if you want to debug a binary, you should build it only with "cargo build".
    - [ Example .gitignore file](./01.base-debug/project-01/gitignore_example) : 
         - .gitigonre file in the main directory of the project ,  we assume this is where .git directory resides, each project has a different git repository, should contain "target/" string to prevent generated files to be commit to git. We also add .rpm, .deb, .tar, .tar.gz, .zip entries to the .gitignore file.
    - [Minimum Size Executable](./01.base-minimum_sized_executable) 
         - Binary size with "cargo build" command is 3.6 MB (hello world application). The generated binary contains symbols and debug info
         - compile parameters for optimization stripping (300 K, hello world application) (project-01/Cargo.toml compile paramaters)
         - non static binary, depending on other libs and rust env. (15K , hello world application) (project-02/build.sh compile paramaters)         
         - This creates dependency to the specigic version of the rust compiler, this may not be preferred.
    - [Versioning and dependency management](./01.base-versioning_and_dependency_management) 
         - You only write direct dependencies, cargo build system will resolv sub dependencies. Similiar functionality as maven/gradle.
         - **dev-dependencies** (found in the Cargo.toml file) only used when compiling examples, tests, benches ( e.g. : cargo build --examples, cargo build --tests, ... )
         - "cargo tree" shows sub dependencies.
         - "cargo info time@1.0.0" gives information about the time package with version 1.0.0
         - if the project  depends on module "log" with version :
             - log = "^1.2.3" is exactly equivalent to log = "1.2.3".
             - log="~1.2.3"  is for  >=1.2.3, <1.3.0
             - log="~1.2"  is for  >=1.2.0,  <1.3.0
             - log="~1"  is for  >=1.0.0,  <2.0.0
             - log="*"  is for  >=0.0.0
             - log="1.*"  is for  >=1.0.0,  <2.0.0
    - [Rust Project Configurations](./01.base-rust_project_configurations)
         - If, for example, Cargo were invoked in /projects/foo/bar/baz, then the following configuration files would be probed for and unified in this order:
             - /projects/foo/.cargo/config.toml
             - /projects/.cargo/config.toml
             - /.cargo/config.toml
             - $CARGO_HOME/config.toml which defaults to $HOME/.cargo/config.toml
        - If a key is specified in multiple config files, the values will get merged together. 
             - The deeper config directory taking precedence over ancestor directories
        - Credentials are stored in $HOME/.cargo/credentials.toml , but registry/repository urls are stored in $HOME/.cargo/config.toml file. This is explained in the [devops](../devops) section.
        - NOTE: there is no way to override the variables in Cargo.toml using config.toml files. You should replace the key in Cargo.toml file using a linux command before executing it.
    - [Rust Library Project](./01.base-rust_lib)
        - project-01 : The project is api interface project that supplies the api to reach the related service.
            - "cargo new service_api_01 --lib" command creates service_api_01 directory with Cargo.toml and src/lib.rs example files inside.
        - project-02 :  service_01 project that service_api_01 forward the requests
        - project-03 :  This project uses service_api_01 to reach the service_01 service.
        - Create a starter script to test all.
    - [ Packaging ](./01.base-packaging)
        - project/platform configurations 
        - RPM 
        - DEB 
        - Publishing DEB and RPM packages 
    - [ Code Quality ](./01.base-code_quality)
        - Clippy
    - [ Validation ](./01.base-validation)
        - https://github.com/jprochazk/garde usage examples
2. Test
    - Unit 
    - Integration 
    - Fuzz 
    - Scenario 
    - Test code generation
    - Selenium tests 
    - Test driven development 
    - Data driven test 
    - Tackle-test
    - codet5
3. Log4rs 
    - Log usage templates 
    - log redirection to LogServer 
    - Probe placement strategies
4. Web
    - Wasm 
    - WebGL
    - Rocket web framework
5. Data Science
    - Array slicing 
    - Aerospike usage and modules
    - Redis usage and udf 
6. Network 
    - Tokio and GRPC 
    - secure connection and encrypt/decrypt 
7. AI
    - Simple machine learning examples
    - Burn 
    - Trochrs
9. Architecture/Design Templates
    - Compiletime API and Runtime Service Architecture
    - Design pattern 
    - Using Common Enumeration With Other Languages

