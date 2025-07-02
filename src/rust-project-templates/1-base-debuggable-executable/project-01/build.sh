cargo build 
ls -lh target/debug/project-01
strings target/debug/project-01 >& target/debug/project-01.stringsoutput.txt
echo "for strings output , see target/release/project-01.stringsoutput.txt file"
ldd target/debug/project-01
file target/debug/project-01
gdb target/debug/project-01
## run
## list
## b 3 ## set break point at line 3
## info b 
## print x 
## disable b ## cancel break point
## r
## exit

#readelf -x .rodata target/release/project-01
#objdump -s -j .rodata  target/release/project-01

