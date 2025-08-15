#[cfg(not(tarpaulin_include))]
fn main() {
    println!("Hello, world!");
}

pub fn add(a: i32, b: i32) -> i32 {
    a + b
}

pub fn add_ten(a: i32) -> i32 {
    a + 10
}



#[cfg(test)]
mod tests {
    // Note this useful idiom: importing names from outer (for mod tests) scope.
    use super::*;

    #[test]
    fn test_add() {
        assert_eq!(add(1, 2), 3);
    }
   #[test]
   #[ignore]
   fn ignored_test() {
        assert_eq!(add(0, 0), 0);
   }
}
