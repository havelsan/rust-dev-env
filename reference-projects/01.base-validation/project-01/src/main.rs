
//use garde::{Validate, Valid};
use garde::Validate;
use garde_derive::Validate;
fn main(){
#[derive(Validate)]
struct User<'a> {
    #[garde(ascii, length(min=3, max=25))]
    username: &'a str,
    #[garde(length(min=15))]
    password: &'a str,
    #[garde(ipv4)]
    ipv4: &'a str,
}

let user = User {
    username: "_more_than_25_more_than_25_more_than_25_more_than_25_more_than_25_",
    password: "less_then_15",
    ipv4: "127.0.0.500",
};

if let Err(e) = user.validate() {
    println!("invalid user: {e}");
}
}
