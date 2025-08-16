// src/bin/fuzzme.rs
#[macro_use]
extern crate afl;

fn main() {
    // The `fuzz!` macro handles all the boilerplate for us.
    // We just need to call our function within the macro:
    fuzz!(|data: &[u8]| {
        // `is_abcnum` requires &str for input, so we'll only 
        // try calling it if the generated data is a valid &str
        if let Ok(s) = std::str::from_utf8(data) {
            // Call the function. Ignore the result because all
            // we care about are crashes.
            let _ = project_06::is_abcnum(s);
        }
    });
}
