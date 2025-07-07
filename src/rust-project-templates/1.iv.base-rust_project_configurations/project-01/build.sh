cargo build --release
cargo tree
echo 'Change regex="1.11.*" in Cargo.toml file and rerun this build.sh script to see how cargo behaves according to semantic versioning'

#ls -lh target/release/project-01
#echo "for strings output , see target/release/project-01.stringsoutput.txt file"
#ldd target/release/project-01
#file target/release/project-01
#readelf -x .rodata target/release/project-01
#objdump -s -j .rodata  target/release/project-01
