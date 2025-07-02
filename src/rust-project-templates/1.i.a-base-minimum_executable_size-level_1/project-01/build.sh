cargo build --release
strip target/release/project-01
ls -lh target/release/project-01
strings target/release/project-01 >& target/release/project-01.stringsoutput.txt
echo "for strings output , see target/release/project-01.stringsoutput.txt file"
ldd target/release/project-01
file target/release/project-01
#readelf -x .rodata target/release/project-01
#objdump -s -j .rodata  target/release/project-01

