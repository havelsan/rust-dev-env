# Preparing Local OS Package (rpm/deb) Repository


## Preparing RPM Repositories


0. run the gitea start script : cd $HOME/sdk/tools/gitea-1.22.4 && ./run.sh

1. goto http://localhost:3000

2. login using adm001 (this user was created in step "Preparing Local Source Code Repository")

3. create an organization with the name "rpm-test" 
   - click on the "+" sign on the right-top of the page
   - click on the "New Organization" button.
   - Organization Name= "rpm-test", visibility = "Public" , Permissions = "Reposiroty Admin ..." is selected.
   - click on "Create Organization"
   - Create new team in this organization with "all repositories" and "create repositories" authozation, and code and packages write access. 
   - For only rpm-test organization : add usr001, or any other developer's account to this team, so that developers may freely upload their rpm to rpm-test organization's package repository. 
   - You may also map ldap groups to the teams (https://forum.gitea.com/t/map-ldap-groups-to-organization-teams/6385/3)

4. We don't have to do anything more to create rpm repository, the url http://localhost:3000/api/packages/rpm-test/rpm/upload and other services immediately become available when you create the rpm-test organization in gitea.

5. Repeat the step 3 for "rpm-prod" and "rpm-thirdparty" organization.

## Uploading/Listing/Deleting rpm package to repository

1. Install rpm package manager on ubuntu ( on redhat machine, this is not needed :) )
  - sudo apt install rpm
  - mkdir -p ~/rpmbuild/SOURCES ~/rpmbuild/SPECS
  - cd ~/rpmbuild/SOURCES

2. Prepare sample project "hello" 
  - wget http://ftp.gnu.org/gnu/hello/hello-2.8.tar.gz
  - cd ~/rpmbuild/SPECS
  - write the following text into the hello-2.8.spec file
```
Summary: The "Hello World" program from GNU
Name: hello
Version: 2.8
Release: 1%{?dist}
Source0: %{name}-%{version}.tar.gz
License: GPLv3+
Group: TARGET_PLATFORM_GROUP-TARGET_PLATFORM-1.0.0

Requires(post): info
Requires(preun): info

%description 
The "Hello World" program, done with all bells and whistles of a proper FOSS 
project, including configuration, build, internationalization, help files, etc.

%prep
%setup -q

%build
%configure
make %{?_smp_mflags}

%install
%make_install
%find_lang %{name}
rm -f %{buildroot}/%{_infodir}/dir

%post
/sbin/install-info %{_infodir}/%{name}.info %{_infodir}/dir || :

%preun
if [ $1 = 0] ; then
/sbin/install-info --delete %{_infodir}/%{name}.info %{_infodir}/dir || :
fi

%files -f %{name}.lang
%doc AUTHORS ChangeLog COPYING NEWS README THANKS TODO
%{_mandir}/man1/hello.1.gz
%{_infodir}/%{name}.info.gz
%{_bindir}/hello

%changelog
* Tue Sep 06 2011 The Coon of Ty <Ty@coon.org> 2.8-1
- Initial version of the package
ORG-LIST-END-MARKER

```
  - "rpmbuild -bb hello-2.8.spec" command builds the  hello-2.8-1.x86_64.rpm file in the ~/rpmbuild/RPMS/x86_64/  directory
  - "cd ~/rpmbuild/RPMS/x86_64/"
3. Upload generated rpm to the repository
  - By using the following curl command, we upload directly to http://localhost:3000/api/packages/rpm-test/rpm/TARGET_PLATFORM_GROUP-TARGET_PLATFORM-1.0.0 url. We don't need to create any directory, this directory becomes immediately available after the first package upload.
  - "curl --user adm001:<adm001_token_created_in_settings_applications> --upload-file hello-2.8-1.x86_64.rpm http://localhost:3000/api/packages/rpm-test/rpm/TARGET_PLATFORM_GROUP-TARGET_PLATFORM-1.0.0/upload"
  - TARGET_PLATFORM_GROUP is generally the customer name, or categorical name of the platform in the literature (e.g. ship, plane, car ...), or any logical categorization name you may give.
  - TARGET_PLATFORM is the physical name of the environment for deployment. (e.g. datacenter01, or ship_no_05, or airplane_no_125, ...)
  - 1.0.0 is the version of that platform. 
  - TARGET_PLATFORM_GROUP-TARGET_PLATFORM-1.0.0 indicates a set of software packages compatible with each other that can be deployed to that platform. 

4. Listing the rpm packages in the repository  
  - If you don't have root access to the operating system (client OS that will use the repository to install rpm), you may use the following commands to list the rpms in the repository
```
rm -f primary.xml*
wget http://localhost:3000/api/packages/rpm-test/rpm/TARGET_PLATFORM_GROUP-TARGET_PLATFORM-1.0.0/repodata/primary.xml.gz
gunzip -f primary.xml.gz
cat primary.xml | sed -e 's#</location>#\n#g'| sed -e 's#<location #\n#g'| grep 'href="'| cut -d\" -f2

```
  - İf you have root access to the operating system (client OS that will use the repository to install rpm), you may use the following commands to list the rpms in the repository
```
sudo su -
mkdir -p /etc/yum.repos.d/
cd /etc/yum.repos.d/
wget  http://localhost:3000/api/packages/rpm-test/rpm/TARGET_PLATFORM_GROUP-TARGET_PLATFORM-1.0.0.repo
dnf repository-packages gitea-rpm-test-TARGET_PLATFORM_GROUP-TARGET_PLATFORM-1.0.0 list

```

5. Installing the "hello" rpm form the repository
  - Do the configureations shown in second part of the "step 4". (yum repository configurations)
  - "dns install hello"

6. Deleting package from the repository 
  - You may delete the rpm packages from the web user interface : 
   * goto http://localhost:3000/rpm-test/-/packages (login using adm001 admin user)
   * click on the "hello" package
   * click on the "2.8-1" version,  on the right most panel.
   * click on the settings,  on the right most panel.
   * click on the "Delete Package" button.
  
  - You may also delete rpm package using the following curl command 
```  
  curl --user adm001:401e7c68f09e4e10ad483ba97a50c84086eedb25 -X DELETE http://localhost:3000/api/packages/rpm-test/rpm/TARGET_PLATFORM_GROUP-TARGET_PLATFORM-1.0.0/package/hello/2.8-1/x86_64
```


## Preparing Debian (deb) Repositories

0. run the gitea start script : cd $HOME/sdk/tools/gitea-1.22.4 && ./run.sh

1. goto http://localhost:3000

2. login using adm001 (this user was created in step "Preparing Local Source Code Repository")

3. create an organization with the name "deb-test" 
   - click on the "+" sign on the right-top of the page
   - click on the "New Organization" button.
   - Organization Name= "deb-test", visibility = "Public" , Permissions = "Reposiroty Admin ..." is selected.
   - click on "Create Organization"
   - Create new team in this organization with "all repositories" and "create repositories" authozation, and code and packages write access. 
   - For only deb-test organization : add usr001, or any other developer's account to this team, so that developers may freely upload their rpm to deb-test organization's package repository. 
   - You may also map ldap groups to the teams (https://forum.gitea.com/t/map-ldap-groups-to-organization-teams/6385/3)

4. We don't have to do anything more to create debian repository, the services immediately become available when you create the any organization in gitea.

5. Repeat the step 3 for "deb-prod" and "deb-thirdparty" organization.


## Uploading/Listing/Deleting deb package to repository

1. Prepare sample project "testpkg"
  - Create directories : 
   * mkdir -p testpkg/DEBIAN testpkg/opt/testpkg/bin  testpkg/opt/testpkg/etc
  - Create sample files :
   * echo 'source ../etc/deneme.conf; echo $DENEME' > testpkg/opt/testpkg/bin/test.sh; chmod +x testpkg/opt/testpkg/bin/test.sh
   * echo 'export DENEME=1234' > testpkg/opt/testpkg/etc/deneme.conf
  - Create control file in testpkg/DEBIAN/control
```
Package: testpkg
Version: 1.0.0-1
Section: TARGET_GROUP-TARGET_PLATFORM-PLATFORM_VERSION
Priority: optional
Architecture: amd64
Maintainer: Deneme <test@test.com>
Description: This is a test application
 for packaging
```
  
  - Set the owner as maintain:staff for the testpkg file in testpkg/DEBIAN/postinst, and chmod +x testpkg/DEBIAN/postinst :
```
chown -Rf maintain:staff /opt/testpkg
```
  - Create testpkg.deb package file 
   * dpkg-deb -b testpkg
   
2. Upload generated deb package to the repository
  - By using the following curl command, we upload directly to http://localhost:3000/api/packages/deb-test/debian/pool/TARGET_PLATFORM_GROUP-TARGET_PLATFORM-1.0.0/main/upload url. We don't need to create any directory, this directory becomes immediately available after the first package upload.
  - "curl --user usr001:<usr001_token_created_in_settings_applications> --upload-file testpkg.deb http://localhost:3000/api/packages/deb-test/debian/pool/TARGET_PLATFORM_GROUP-TARGET_PLATFORM-1.0.0/main/upload"
  - TARGET_PLATFORM_GROUP is generally the customer name, or categorical name of the platform in the literature (e.g. ship, plane, car ...), or any logical categorization name you may give.
  - TARGET_PLATFORM is the physical name of the environment for deployment. (e.g. datacenter01, or ship_no_05, or airplane_no_125, ...)
  - 1.0.0 is the version of that platform. 
  - TARGET_PLATFORM_GROUP-TARGET_PLATFORM-1.0.0 indicates a set of software packages compatible with each other that can be deployed to that platform. 

4. Listing the rpm packages in the repository  
```
sudo su -
echo "deb [signed-by=/etc/apt/keyrings/gitea-deb-test.asc] http://localhost:3000/api/packages/deb-test/debian TARGET_PLATFORM_GROUP-TARGET_PLATFORM-1.0.0 main" | sudo tee -a /etc/apt/sources.list.d/gitea.list
sudo curl http://localhost:3000/api/packages/deb-test/debian/repository.key -o /etc/apt/keyrings/gitea-deb-test.asc
apt update
grep ^Package: /var/lib/apt/lists/localhost:3000_api_packages_deb-test_debian_dists_TARGET%5fPLATFORM%5fGROUP-TARGET%5fPLATFORM-1.0.0_main_binary-amd64_Packages

```

5. Installing the "testpkg" rpm form the repository
  - Do the configurations shown in the "step 4". (apt repository configurations)
  - "apt install testpkg"

6. Deleting package from the repository 
  - You may delete the rpm packages from the web user interface : 
   * goto http://localhost:3000/deb-test/-/packages (login using adm001 admin user)
   * click on the "testpkg" package
   * click on the "1.0.0-1" version,  on the right most panel.
   * click on the settings,  on the right most panel.
   * click on the "Delete Package" button.
  
  - You may also delete rpm package using the following curl command 
```  
  curl --user adm001:401e7c68f09e4e10ad483ba97a50c84086eedb25 -X DELETE http://localhost:3000/api/packages/deb-test/debian/pool/TARGET_PLATFORM_GROUP-TARGET_PLATFORM-1.0.0/main/testpkg/1.0.0-1/amd64
```


