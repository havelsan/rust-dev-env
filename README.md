# Rust Development Environment
This repository contains rust development environment preparation scripts, documentation, example codes and recommendations.

Rust development environment is installed in $HOME/sdk directory. This sdk directory may reside in any other directory (e.g. /opt/sdk).

SDK directory contains 3 sub directories :
1. infra :  This directory contains sub directories that are "version numbers" (e.g. /opt/sdk/infra/1.0.0/).  This "version numbered directory" contains
- rust compiler (e.g. $HOME/sdk/infra/1.0.0/rust-1.88.0)
- application libraries
- APIs to services.
- release file , sourcing all the sub directories release files.
2. tools :
3. services

These three sub directories also




## Table of Contents

1. [Preparing Rust SDK Directory](doc/01.preparing-rust-sdk-directory/)
2. [Preparing Local Source Code Repository](doc/02.preparing-local-source-code-repository/)  
3. [Preparing Local Crate Registry](doc/03.preparing-local-crate-repository/)
4. [Updating Local Thirdparty Crate Registry](doc/04.updating-local-thirdparty-crate-registry/)
5. [Preparing Local OS Package (rpm/deb) Repository](doc/05.preparing-local-package-repository/)
6. [Preparing Services](doc/06.preparing-services)
7. [Preparing IDEs](doc/07.preparing-ides)
8. [Preparing Data Tools](doc/08.preparing-data-tools)
9. [Rust Project Templates](doc/09-rust-project-templates)



