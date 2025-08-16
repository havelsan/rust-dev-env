// importing common module.
mod common;

use test_case::test_case;

#[test_case(2,  4, 6  ; "when both operands are positive")]
#[test_case(4,  2, 6  ; "when operands are swapped")]
#[test_case(-4,  -2, -6  ; "when operands are negative")]
fn test_add(x: i32, y: i32, z: i32) {
    // using common code.
    common::setup();
    assert_eq!(project_04::add(x, y), z);
}


