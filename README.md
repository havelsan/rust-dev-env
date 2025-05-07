# Rust Development Environment
This repository contains rust development environment preparation scripts and documentation.

NOTE:
 - If your target systems (production systems, computers on the cars/trucks/ships/airplanes) will all have the same operating system ( e.g. RHEL 8.10)
   Then it is a good idea to build your development environment on RHEL 8.10 or similar 8.X
 - You may update the tools, infra or services directories in sdk. (sdk/tools/1.0.0, sdk/infra/1.0.0, sdk/services/1.0.0)
  * If you add/remove or change a component, then you make a new directory, and you link the unchanged components to the previous version directory .
  * for example if you update aerospike service but let the fastdds and nginx services unchanged  
   + first you create a new directory sdk/services/1.1.0 , 
   + place the new aerospike installation in it, 
   + create links nginx and fastdds to the sdk/services/1.0.0/nginx, and fastdds
     

## Table of Contents

1. [Preparing Rust SDK Directory](doc/01.preparing-rust-sdk-directory/)
2. [Preparing Local Source Code Repository](doc/02.preparing-local-source-code-repository/)  
2. [Preparing Local Crate Registry](doc/03.preparing-local-crate-registry/)
4. [Updating Local Thirdparty Crate Registry](doc/04.updating-local-thirdparty-crate-registry/)
5. [Preparing Local OS Package (rpm/deb) Repository](doc/05.preparing-local-package-repository/)
6. [Preparing Services](doc/06.preparing-services)
7. [Preparing IDEs](doc/07.preparing-ides)
8. [Preparing Data Tools](doc/08.preparing-data-tools)
9. [Preparing Log Monitoring Tools](doc/09.preparing-log-monitoring-tools)
10. [Preparing Network Monitoring Tools](doc/10.preparing-network-monitoring-tools)
11. [Debugging Tools Installation and Usage Examples](doc/11.debugging-tools)
12. [Rust Project Templates](doc/12-rust-project-templates)
13. [Architecture Templates](doc/13-rust-arhitecture-templates)
14. Full cycle test example
15. [CI/CD](#ci-cd) Sonarqube rust analyzer.





## Preparing  Data Monitoring Tools    
Clairvoyance for Aerospike, Fast DDS Monitor, 
Log Server ELK-Graphana
Wireshark, tcpduöp , 
os-command-scripts : df, ps (cpu,memory), top, iftop, nethogs?


## Debugging and Test Tools Installation and Usage Examples
gdb, sar, accerciser, dbus-accessibility-conf, Selenium, tackle-test
 
## Rust Project Templates

Minimum executble size example

Test : Unit, Integration, Fuzz, Scenario, test code generation templates, python gui tests qt accessibility, selenium tests, test driven development, data driven test, tackle-test

Log4rs : Log usage templates, log redirection to LogServer, Probe placement strategies 

Wasm : Wasm usage templates.

WebGL: WebGL usage templates.

Aerospike : Aerospike usage templates.

Fast DDS : Fast DDS usage templates.

Rust DDS : Rust DDS usage templates.

Tokio : Tokio GRPC usage templates.

Netty : Netty usage templates.

Burn : Burn usage templates.

Trochrs : Torchrs usage templates.

packaging : project/platform configurations, rpm usage templates, deb usage templates.

qt : qt usage templates.

rdlib : Rust dynamic lib with so templates.

## Architecture Templates
Compiletime API and Runtime Service Architecture 

## CI/CD
codet5, codeTF, RUSTASSISTANT,  code review
Gitea human code review
Jenkins compile
Distro Manager (python(web)+redis), pkgset preparation and dependency checks.





