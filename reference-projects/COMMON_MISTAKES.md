# Rust Common Mistakes

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
- Using an empty Vec<u8> as the buffer argument when calling Read::read.
- Calling Read::read or Write::write when read_exact or write_all is needed. (Clippy has a lint for this.)
- Unnecessarily converting String into something like Vec<char> (for use cases that could be rewritten to avoid char indices).
- Trying to do an early return from a function without using the return keyword, by just removing a semicolon. (Fortunately, this usually causes a compiler error.)
- Putting IO resources inside mutexes.
- Attempting self-referencial structs
- Long-lived reference-based structs generally Path::to_str().unwrap() instead of Path::display() to put a path into an error message
- Trait over-use: implementing From for something which could have been a named factory function; introducing a trait where a bunch of inherent methods would do.
- Trait miss-use: implementing TryFrom<&str> instead of FromStr.
- Unnecessary .unwraps: if opt.is_some() { opt.unwrap() }.
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
      Trying to mutate borrowed values or misunderstanding Rust’s strict aliasing rules.

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



