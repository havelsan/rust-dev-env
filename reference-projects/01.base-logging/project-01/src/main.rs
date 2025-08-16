extern crate syslog;

use syslog::{Facility, Formatter3164};
use std::process;

fn main() {
    let formatter = Formatter3164 {
        facility: Facility::LOG_USER,
        hostname: None,
        process: "process-01".into(),
        pid: process::id(),
    };

    let message=file!().to_owned()+":"+&line!().to_string().to_owned()+": HELLO WORLD MESSGAE ";

    
    match syslog::unix(formatter) {
        Err(e) => println!("impossible to connect to syslog: {:?}", e),
        Ok(mut writer) => {
            writer.err(message).expect("could not write error message");
        }
    }
}
