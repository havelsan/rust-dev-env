fn main() {
    println!("Hello, world!");
}

pub fn add(a: i32, b: i32) -> i32 {
    a + b
}

// This is a really bad adding function, its purpose is to fail in this
// example.
#[allow(dead_code)]
fn bad_add(a: i32, b: i32) -> i32 {
    a - b
}

#[cfg(test)]
mod tests {
    // Note this useful idiom: importing names from outer (for mod tests) scope.
    use super::*;
    use pretty_assertions::assert_eq; // crate for test-only use. Cannot be used in non-test code.


    #[test]
    fn test_add() {
        assert_eq!(add(1, 2), 3);
    }
    #[test]
    fn test_bad_add() {
       // This assert would fire and test will fail.
       // Please note, that private functions can be tested too!
       assert_eq!(bad_add(1, 2), 3);
   }
   #[test]
   #[ignore]
   fn ignored_test() {
        assert_eq!(add(0, 0), 0);
   }
}
