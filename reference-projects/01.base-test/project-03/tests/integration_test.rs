// importing common module.
mod common;

#[test]
fn test_add() {
    // using common code.
    common::setup();
    assert_eq!(project_03::add(3, 2), 5);
}
