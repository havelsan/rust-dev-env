fn main(){
let vec: Vec<isize> = Vec::new();
if vec.len() <= 0 {}
if 100 > i32::MAX {}
assert!(false);
assert!(true);
const B: bool = false;
assert!(B);

}

struct Thing;

impl Clone for Thing {
    fn clone(&self) -> Self { todo!() }
    fn clone_from(&mut self, other: &Self) { todo!() }
}

pub fn assign_to_ref(a: &mut Thing, b: Thing) {
    *a = b.clone();
}
