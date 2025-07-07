cargo build --release
cargo tree
ls -lh target/release/project-01
echo "for strings output , see target/release/project-01.stringsoutput.txt file"
ldd target/release/project-01
file target/release/project-01
#readelf -x .rodata target/release/project-01
#objdump -s -j .rodata  target/release/project-01
