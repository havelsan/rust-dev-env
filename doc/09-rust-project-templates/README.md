# Rust Project Templates
This page contains links to Rust Project Templates, but before giving project template links , we offered some notes on software development. The Rust Project Templates links are at the end of this page.

##  MAIN RULES: 
- Write readable code first, optimize second
- Break your system into isolated, focused services.
- Go for "Test Driven Development" when possible

## Elon Musk's 5 step process for making things in a better way

1. Make your requirements less dumb 
Your requirements are definitely dumb 
Its particularly dangerous if a smart person gave them to you as you might not question them enough

2. Delete the part or process
If you're not adding back then you're not deleting enough
Don't add requirements just in case, don't hedge your bets
```
   continue_to_delete=True
   while continue_to_delete:
     foreach part/process in parts/processes:
         try to delete a part or a process step that seems to be useless
     if you are adding at most 10% of the parts/processes back in the system in the functionality check last step :
         continue_to_delete=False
```

3. Simplify/Optimise 
Don't optimise if it shouldn't exist

4. Accelerate cycle times
But don't go faster if you haven't worked on the other 3 things first...
If you're digging your grave don't dig your grave faster

5. Automate
Don't reverse these 5 steps

## NASA : Rules For Developing Safety Critical Code

1. Avoid complex flow constructs, such as goto and recursion.
2. All loops must have fixed bounds. This prevents runaway code.
3. Avoid heap memory allocation after initialization.
4. Restrict functions to a single printed page.
5. Use a minimum of two runtime assertions per function.
6. Restrict the scope of data to the smallest possible.
7. Check the return value of all non-void functions, or cast to void to indicate the return value is useless.
8. Use the preprocessor only for header files and simple macros.
9. Limit pointer use to a single dereference, and do not use function pointers.
10. Compile with all possible warnings active; all warnings should then be addressed before release of the software.

## SOLID Principles
* S - Single Responsibility Principle : A class should have only one reason to change, meaning it should have only one job or responsibility. 
* O - Open-Closed Principle : Software entities (classes, modules, functions, etc.) should be open for extension but closed for modification. This means you can add new functionality without altering existing code.
* L - Liskov Substitution Principle : Subtypes should be substitutable for their base types without altering the correctness of the program. In simpler terms, if a class B inherits from class A, you should be able to use an object of class B wherever an object of class A is expected without breaking anything
* I - Interface Segregation Principle : Clients should not be forced to depend on methods they do not use. Instead of one large interface, create smaller, more specific interfaces that clients can use
* D - Dependency Inversion Principle : High-level modules should not depend on low-level modules. Both should depend on abstractions. This means using interfaces or abstract classes to decouple components and make them more flexible

## Common newbie mistakes or bad practices

- Strings are not paths : 
```
     use:
       &Path and join() 
     instead of :
       &str and format!("{}/{}", dir, filename)
```
- Unnecessary indirection fn foo(title: &String) :
Don't hard-code where you are reading data from  
```
     use:
       fn parse(reader: impl std::io::Read) 
     instead of :
       fn parse(filename: &str)
```
- Unnecessary use of "Rc < RefCell < T > >" because that's how you would write code in a GC'd language.
- Copies followed immediately by a borrow - e.g. function_taking_str(&"...".to_string())
- Loose typing/stringly typed APIs - e.g. pass around a String instead of an enum
- Not using ? to propagate errors or None
- Not knowing the distinction between runtime and compile time - e.g. trying to use include_str!() instead of std::fs::read_to_string()
- Not implementing Default, FromStr, From, or TryFrom
- Writing function_taking_slice(&array[..]) instead of function_taking_slice(&array) because you don't know array references coerce to slices
- Using "" instead of None when you don't have a useful value
- Not initializing your type with useful values - e.g. use Vec::new() when you construct your type then later populate the field (valid by construction, etc.)
- Measuring performance of unoptimized/debug builds.
Using an empty Vec<u8> as the buffer argument when calling Read::read.
- Calling Read::read or Write::write when read_exact or write_all is needed. (Clippy has a lint for this.)
- Unnecessarily converting String into something like Vec<char> (for use cases that could be rewritten to avoid char indices).
- Trying to do an early return from a function without using the return keyword, by just removing a semicolon. (Fortunately, this usually causes a compiler error.)
- Putting IO resources inside mutexes.
- Attempting self-referencial structs
- Long-lived reference-based structs generally Path::to_str().unwrap() instead of Path::display() to put a path into an error message
- Trait over-use: implementing From for something which could have been a named factory function; introducing a trait where a bunch of inherent methods would do.
- Trait miss-use: implementing TryFrom<&str> instead of FromStr.
Unnecessary .unwraps: if opt.is_some() { opt.unwrap() }.
- Generic bloat: pub fn do_something(path: impl AsRef<Path>) { 200 line function to monomorphise in every crate }
- Cyclic dependencies between crates (when a leaf crate have a dev-dependency on the root crate)
- Somewhat arbitrary splitting of code into crates in general.
- Error management. Rust has the tools to implement the best possible error management of any language, but there's no pit of success there. One stable state is a giant enum which combines errors from different subsystems, has an Other(String) variant just in case, and which is used for basically anything.


## 10 Things You’re Doing Wrong in Rust (and How to Fix Them)

- Overusing .clone() Instead of Borrowing 
```
     The Mistake:
     Repeatedly calling .clone() on data unnecessarily duplicates it, which can be both a performance and memory overhead.

     The Fix:
     Understand Rust’s borrowing rules. Use references (&T) or mutable references (&mut T) whenever possible. Use .clone() sparingly, only when ownership or independent copies are truly needed.

     Bad: Using .clone() unnecessarily
          let data = vec![1, 2, 3];
          let sum = data.clone().iter().sum::<i32>();

     Good: Borrowing instead
         let data = vec![1, 2, 3];
         let sum = data.iter().sum::<i32>();
```
- Ignoring Result and Option Error Handling
```
     The Mistake:
       Using .unwrap() or .expect() liberally without considering error cases. This can lead to runtime panics.

     The Fix:
       Always handle Result and Option values properly with match statements or combinators like .map() and .and_then(). For critical errors, use .expect() with meaningful error messages.

     Bad: Ignoring error cases
         let file = File::open("config.txt").unwrap();

     Good: Handling errors gracefully
         let file = File::open("config.txt").unwrap_or_else(|err| {
           eprintln!("Failed to open file: {err}");
           process::exit(1);
         });
```

- Writing Inefficient Loops Instead of Using Iterators
```
    The Mistake:
      Manually managing indices in loops instead of using Rust’s powerful iterator methods.

    The Fix:
      Leverage methods like .map(), .filter(), and .collect() for more readable and idiomatic code.

    Bad: Manual looping
       let mut squared = Vec::new();
       for x in vec![1, 2, 3] {
           squared.push(x * x);
       }

    Good: Using iterators
       let squared: Vec<_> = vec![1, 2, 3].iter().map(|x| x * x).collect();
```

- Misunderstanding Ownership and Borrowing Rules
```
    The Mistake:
      Trying to mutate borrowed values or misunderstanding Rust’s      strict aliasing rules.

   The Fix:
      Practice small exercises focusing on ownership, borrowing, and lifetimes. Rust’s compiler messages are helpful; read them carefully.

   Bad: Multiple mutable borrows
     let mut data = vec![1, 2, 3];
     let r1 = &mut data;
     let r2 = &mut data; // Error: second mutable borrow!

   Good: Sequential mutable borrows
     let mut data = vec![1, 2, 3];
     {
        let r1 = &mut data;
        r1.push(4);
     } // r1 goes out of scope here, so we can make a new reference with no problems.
     let r2 = &mut data;
     r2.push(5);
```
- Overcomplicating Lifetimes Unnecessarily
```
   The Mistake:
       Adding explicit lifetimes to every function or struct, even when Rust can infer them.

   The Fix:
       Use lifetimes only when necessary. Start simple and let the compiler guide you.

   Bad: Unnecessary lifetimes
       fn get_first<'a>(s: &'a str) -> &'a str {
           &s[..1]
       }

   Good: Let Rust infer lifetimes
      fn get_first(s: &str) -> &str {
          &s[..1]
      }
```
- Avoiding unsafe When It’s Actually Needed
```
   The Mistake:
      Shying away from unsafe code even when it’s the best tool for the job (e.g., FFI, manual memory management).

   The Fix:
      Understand when unsafe is appropriate, use it sparingly, and document its use thoroughly.

      unsafe {
         let ptr = libc::malloc(10) as *mut u8;
         if ptr.is_null() {
            panic!("Failed to allocate memory");
         }
         libc::free(ptr as *mut libc::c_void);
      }
```
- Using .unwrap() Everywhere
```
    The Mistake:
        Defaulting to .unwrap() instead of gracefully handling potential errors.

    The Fix:
        Use pattern matching or combinators like .ok_or_else(), .unwrap_or(), or .unwrap_or_else() to make your code more robust.

    Bad: Blindly unwrapping
         let value = some_function().unwrap();

    Good: Handling errors explicitly
         let value = some_function().unwrap_or_else(|e| {
            eprintln!("Error occurred: {e}");
            default_value()
         });
```
- Not Leveraging Crates for Async Programming
```
   The Mistake:
        Reinventing the wheel instead of using mature crates like tokio or async-std.

   The Fix:
        Adopt an async runtime and embrace the ecosystem. Use tokio::main to simplify async entry points.

    Good: Using Tokio for async tasks
          #[tokio::main]
          async fn main() {
            let response = reqwest::get("https://example.com").await.unwrap();
            println!("Response: {:?}", response);
          }
```
- Over-Optimizing Before Profiling
```
   The Mistake:
       Spending hours tweaking code for speed without identifying actual bottlenecks.

   The Fix:
       Use tools like cargo-flamegraph or perf or clippy to identify hotspots before optimizing. Write readable code first, optimize second.
```
- Ignoring Community Feedback and Idiomatic Rust Patterns
```
   The Mistake:
     Writing Rust like it’s another language (e.g., C++ or Python), ignoring idiomatic practices.

   The Fix:
     Read community resources like the Rust Book, participate in forums, and follow projects on GitHub to understand idiomatic patterns.

   Non-idiomatic Rust :
      let mut v = vec![];
      for i in 0..10 {
          v.push(i * 2);
      }

   Idiomatic Rust
      let v: Vec<_> = (0..10).map(|i| i * 2).collect();

   By following community-driven guidelines, your code will be easier for other Rustaceans to understand and maintain.
```

## Rust Links
- https://docs.rs/
- https://doc.rust-lang.org/book/
- https://doc.rust-lang.org/cargo/
- https://rust-unofficial.github.io/patterns/
- https://github.com/mre/idiomatic-rust
- https://www.mayhem.security/blog/best-practices-for-secure-programming-in-rust
- https://cratecode.com/info/rust-traits-best-practices
- https://web.mit.edu/rust-lang_v1.25/arch/amd64_ubuntu1404/share/doc/rust/html/book/first-edition/testing.html
- https://zerotomastery.io/blog/complete-guide-to-testing-code-in-rust/
- https://doc.rust-lang.org/book/ch11-01-writing-tests.html
- https://github.com/mozilla/rust-code-analysis
- https://github.com/vaaaaanquish/Awesome-Rust-MachineLearning
- https://github.com/Rust-GPU/Rust-CUDA

## Utilities
- https://www.geeksforgeeks.org/gdb-step-by-step-introduction/
- https://docs.redhat.com/en/documentation/red_hat_developer_toolset/9/html/user_guide/chap-gdb
- https://help.gnome.org/users/accerciser/stable/introduction.html.en
- https://github.com/tbsaunde/at-spi2-core/blob/master/bus/accessibility.conf

## Rust Project Templates
The template projects in the below list focuses only on a specific subject with minimal code.

1. Base
    1. Standard Rust Project Layout : [Project Layout](https://doc.rust-lang.org/cargo/guide/project-layout.html) 
        - Cargo.toml , .cargo/config.toml , src directory , tests directory (test directory for integration tests  not unit tests) ,  benches directory , examples directory
        - The [.gitignore](../../.gitignore) file in the main directory of the project ( we assume this is where .git directory resides, each project has a different git repository) should contain "target/" string to prevent generated files to be commit to git. We also add *.rpm, *.deb, *.tar, *.tar.gz, *.zip entries to the .gitignore file, as shown below:
            * target/
            * *.rpm
            * *.deb
            * *.tar
            * *.tar.gz
            * *.zip
    2. [Debugging With Gdb : Fast Introduction](../../src/rust-project-templates/1.i.base-debuggable-executable)
        - NOTE-1: project-01/build.sh file contains gdb usage commands.
        - NOTE-2: 'cargo build' command by default places debug information intothe generated  binary, 'cargo build --release' clears debug information from the binary.
    3. [Minimum Size Executable](../../src/rust-project-templates/1.ii.base-minimum_sized_executable) 
         - Binary size with "cargo build" command is 3.6 MB (hello world application). The generated binary contains symbols and debug info
         - compile parameters for optimization stripping (300 K, hello world application) (project-01/Cargo.toml compile paramaters)
         - non static binary, depending on other libs and rust env. (15K , hello world application) (project-02/build.sh compile paramaters)         
    4. [Versioning and dependency management](../../src/rust-project-templates/1.iii.base-versioning_and_dependency_management) 
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
    5. [Rust Project Configurations](../../src/rust-project-templates/1.iv.base-rust_project_configurations)
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
    6. Publishing to a registry is explained in the item 11 of [Preparing Local Create Repository](../03.preparing-local-crate-repository)

--------------------
    7. Rust Lib:
        - Create the project with "cargo new a_service_api_01 --lib", this command creates a_service_api_01 directory with Cargo.toml and src/lib.rs example files inside.
        - Write tests before writing the main code.
        - Write some functionality in  a_service_api_01
        - Compile and publish the a_service_api_01
        - Create a_service_01 project that a_service_api_01 forward the requests
        - Create a_user_project_01 that uses a_service_api_01 to reach the a_service_01 service.
        - Create a starter script to test all.
    8. RDLIB : Rust dynamic lib with binary so.
    9. Packaging
        - project/platform configurations 
        - RPM 
        - DEB 
        - Publishing DEB and RPM packages are explained in 
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
    4. Reinforcement learning 
    5. Cuda usage 
    6. Computer vision 
    7. Sound processing 
8. Qt
    1. Qt examples
    2. Automated testing qt applications using  dbus and accessibility 
9. Architecture/Design Templates
    1. Compiletime API and Runtime Service Architecture
    2. Design pattern 
    3. Using Common Enumeration With Other Languages
10. linux kernel module

