// Define this in a crate called `adder`.
pub fn is_abcnum(s: &str) -> bool {
    let bytes = s.as_bytes();
    match bytes {
        [b'a', b'b', b'c', num @ ..] => {
            let num = std::str::from_utf8(num).unwrap();
            let _ = num.parse::<u8>().unwrap();
            true
        }
        _ => false,
    }
}
