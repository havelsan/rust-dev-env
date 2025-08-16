use mockall::automock;

// This annotation will generate a mock struct that we can
// use in testing.
#[automock]
pub trait Calc {
    /// adds `n` to some number stored in the struct
    fn add(&mut self, n: u32) -> u32;
}

pub struct CurrentNumber { pub num: u32 }

impl Calc for CurrentNumber {
    fn add(&mut self, n: u32)-> u32{
        self.num=n+self.num;
        return self.num;
    }
}
