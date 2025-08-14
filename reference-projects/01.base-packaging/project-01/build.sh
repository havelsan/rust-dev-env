export PLATFORM_GROUP=toyota
export PLATFORM=corolla

cd etc
ln -s $PLATFORM_GROUP-$PLATFORM.toml project-01.toml
cd ..


cargo build -vv --release

cargo generate-rpm
echo find . -name *.rpm
find . -name '*.rpm'
rpm -qpl $(find . -name '*.rpm')

curl --user cargo_test_access:05cf20f3c1d9e0b627330040bb89c0d299aa3dda --upload-file $(find . -name '*.rpm') http://localhost:3000/api/packages/rpm-test/rpm/$PLATFORM_GROUP-$PLATFORM-1.0.0/upload


cargo deb
echo find . -name *.deb
find . -name '*.deb'
dpkg -c $(find . -name '*.deb')

#sudo dpkg -i $(find . -name '*.deb')
#cd /opt/project-01/
#. ./release
#cd bin/
#./project-01 $PROJECT_01_HOME/etc/project-01.toml

curl --user cargo_test_access:05cf20f3c1d9e0b627330040bb89c0d299aa3dda --upload-file $(find . -name '*.deb') http://localhost:3000/api/packages/rpm-test/debian/pool/$PLATFORM_GROUP-$PLATFORM-1.0.0/main/upload
