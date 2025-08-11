# PRINCIPLES

1. Main Rules
2. Elon Musk's 5 step process for making things in a better way
3. NASA : Rules For Developing Safety Critical Code
4. SOLID Principles 
5. Rust Links
6. Utilities 

##  MAIN RULES: 
1. Write readable code first, optimize second
2. Break your system into isolated, focused services.
3. Go for "Test Driven Development" when possible

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
- https://github.com/jprochazk/garde

## Utilities
- https://www.geeksforgeeks.org/gdb-step-by-step-introduction/
- https://docs.redhat.com/en/documentation/red_hat_developer_toolset/9/html/user_guide/chap-gdb
- https://help.gnome.org/users/accerciser/stable/introduction.html.en
- https://github.com/tbsaunde/at-spi2-core/blob/master/bus/accessibility.conf


