# Prepare Gitea Source Code / Crate / RPM / DEB  Repository

1. Run install.sh in the current directory
```
./install.sh
```
2. Run run_gitea.sh found in the bin directory
```
cd bin
./run_gitea.sh &
```
3. Goto http://localhost:3000/ adress and create the admin user :
   - Click on the "Register" link found on the left top of the page.
   - username= adm001, email=adm001@localhost.com, password=adm001+++
   - NOTE : email and ldap configurations will not be covered in this tutorial. So we used a fake email adress for admin001


   


## Prepare Local Crate Registry

1. sudo apt-get install libssl-dev

2. Clean previous $HOME/.cargo directory :
```
mv $HOME/.cargo $HOME/_.cargo
```

2. cargo install cargo-local-registry --registry crates-io
   NOTE: "error: config.json not found in registry" means, you did not do the previous step :)


3. goto http://localhost:3000

4. login using adm001 

5. create an organization with the name "cargo-test" 
   - click on the "+" sign on the right-top of the page
   - click on the "New Organization" button.
   - Organization Name= "cargo-test", visibility = "Public" , Permissions = "Reposiroty Admin ..." is selected.
   - click on "Create Organization"

6. create "crate registry" 
   - Click "Explore" link on the top, and select "Organization" tab in the page and click on the "cargo-test" link
   - Click on the "Settings" link on the right-top of the page.
   - Click on the "Packages" link on the left menu.
   - Click on the "Initilize Index" button in the "Cargo Registry Index" section.
   
7. Repeat the steps 5 and 6 for the "cargo-prod" organization.

8. Now we will configure the access authorization for cargo-test and cargo-prod crate registries. We will restrict only the write access for cargo-prod registry.

- create "cargo-test-access" user : 
  + Click on the icon on the rigt-top most of the page (you are adm001 user). Click on the "Site Administration", then  "Identity & Access" on the left menu, and then "User Accounts". 
  + This user will be used for uploading crates to "cargo-test" registry, this will be especially needed by library developers, to let the experimental libraries reached by the application developers.
      
- create "cargo-prod-access" user : 
  + Click on the icon on the rigt-top most of the page (you are adm001 user). Click on the "Site Administration", then  "Identity & Access" on the left menu, and then "User Accounts". 
  + This user will be used for uploading crates to "cargo-prod" registry, this will be used only by jenkins to write to prod registry. Normal users will only have read access to cargo-prod registry. 

- Configure authorization for cargo-test organization :
  + Click "Explore" link on the top, and select "Organization" tab in the page and click on the "cargo-test" link
  + Click on the "Teams" link on the page.
  + Click on the "New Team" button
    * Team Name = cargo-test-writers
    * Description = cargo-test-writers
    * Repository Access = All Repositories
    * Permission = General Access
    * Allow Access Repository Sections = Code = "WRITE", Packages= "WRITE", the rest will be "READ".
  + Click on the Create Team Button           
  + Add team member "cargo-test-access" 

- The same previous operation should be made for "cargo-prod" organization.

9. Now we will generate "Access Token" for cargo-test-access and cargo-prod-access users. We will give cargo-test-access user's token to all developers, cargo-prod-access user's token will only be used by jenkins.

- Sign-in to gitea as the cargo-test-access user.
- Click on the icon on the right-top most of the page
- Click on the "Settings" link
- Click on the "Applications" link on the left menu.
  + Token Name = token1
  + Repository and Organization Access = All
  + Select Permissions = Package = "Read and Write", Reposiroty="Read nd Write", the rest is "No Access".
  + Click on the "Generate Token" button.
  + When you click on the "Generate Token" button, there will appear a token key on the top of the page with blue background. 
  + CAUTION : Save this key to a file. ( Example key : 17e5616bf481c9f46350312ba533edfc8d383806).

- Do all of the steps above for also the cargo-prod-access user.

10. create also cargo-thirdparty organization and crate registry within it. We will use this repository for all libs downloaded from internet.
    Also create a team for this organization and team member will be cargo-test-access. (Step 8, Configure authorization for cargo-test organization )

11. Configure cargo-test, cargo-thirdparty and cargo-prod registries in the developers home directory and configure write access to cargo-test registry:
- Write the following into the $HOME/.cargo/config.toml file. ** NOTE: change localhost to your hostname accordingly :) **
```
[registry]
default = "cargo-prod"

[registries.crates-io]
index = "sparse+https://index.crates.io/" # Sparse index

[registries.cargo-prod]
index = "sparse+http://localhost:3000/api/packages/cargo-prod/cargo/" # Sparse index

[registries.cargo-test]
index = "sparse+http://localhost:3000/api/packages/cargo-test/cargo/" # Sparse index

[registries.cargo-thirdparty]
index = "sparse+http://localhost:3000/api/packages/cargo-thirdparty/cargo/" # Sparse index

[net]
git-fetch-with-cli = true

```
 
- write the access token previously generated access token to the file $HOME/.cargo/credentials.toml, **NOTE: 17e5616bf481c9f46350312ba533edfc8d383806 string should be replaced by what ever cargo-test access token is gernerated by you :)**
```
[registries.cargo-test]
token = "Bearer 17e5616bf481c9f46350312ba533edfc8d383806"

[registries.cargo-prod]
token = "Bearer 7e8151d93523ec30ffe1d00862747ca80a96320c"

[registries.cargo-thirdparty]
token = "Bearer 17e5616bf481c9f46350312ba533edfc8d383806"

```
- CAUTION : Do not supply the access token for the prod repository to a non-admin developer. This access token should only be used by devops scripts, admin-developers or devops staff.
- NOTE : Thirdparty repository may be accessed via cargo-test-access user.
    
11. test the access :
- create a rust project :
 + source rust-dev-env/release
 + mkdir -p $HOME/workspace
 + cd $HOME/workspace
 + cargo new hello_cargo
 + cd hello_cargo
 + Enter 'publish = ["cargo-prod","cargo-test"] ' under the " [package] " section of the  Cargo.toml file.
 + cargo package --allow-dirty
 + cargo publish --registry=cargo-test  --allow-dirty
 + The above command prints "Uploaded hello_cargo v0.1.0 to registry cargo-test" text in the end. 
 + cargo yank --registry=cargo-test --version 0.1.0 # this command deletes the previously uploaded package from the cargo-test registry, yoou should also give the version!
 
 
## Updating Local Thirdparty Crate Registry

1. If you are behind a company proxy, run the following commands:
```
source ./release.proxy
```

2. Download thirdparty crates from crate-io and upload it to local thirdparty registry :
```
download_crates.sh <Cargo.toml file>
```

3. Copy the $HOME/crates.*.tar.gz file to the computer that has access to your local registry.

4. 


## Preparing RPM Repositories


0. if GITEA is not already running, "cd rust-dev-env/devops/bin; ./run_gitea.sh"

1. goto http://localhost:3000

2. login using adm001 (this user was created in step "Preparing Local Source Code Repository")

3. create an organization with the name "rpm-test" 
   - click on the "+" sign on the right-top of the page
   - click on the "New Organization" button.
   - Organization Name= "rpm-test", visibility = "Public" , Permissions = "Reposiroty Admin ..." is selected.
   - click on "Create Organization"
   - Create new team in this organization with "all repositories" and "create repositories" authozation, and code and packages write access. 
   - For only rpm-test organization : add usr001 (or use cargo-test-access) , or any other developer's account to this team, so that developers may freely upload their rpm to rpm-test organization's package repository. 
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
  - "curl --user cargo_test_access:<cargo_test_access_token_created_in_settings_applications> --upload-file hello-2.8-1.x86_64.rpm http://localhost:3000/api/packages/rpm-test/rpm/TARGET_PLATFORM_GROUP-TARGET_PLATFORM-1.0.0/upload"
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
  - "dnf install hello"

6. Deleting package from the repository 
  - You may delete the rpm packages from the web user interface : 
   * goto http://localhost:3000/rpm-test/-/packages (login using adm001 or cargo_test_access admin user)
   * click on the "hello" package
   * click on the "2.8-1" version,  on the right most panel.
   * click on the settings,  on the right most panel.
   * click on the "Delete Package" button.
  
  - You may also delete rpm package using the following curl command 
```  
  curl --user adm001:401e7c68f09e4e10ad483ba97a50c84086eedb25 -X DELETE http://localhost:3000/api/packages/rpm-test/rpm/TARGET_PLATFORM_GROUP-TARGET_PLATFORM-1.0.0/package/hello/2.8-1/x86_64
```


## Preparing Debian (deb) Repositories

0. if GITEA is not already running, "cd rust-dev-env/devops/bin; ./run_gitea.sh"

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

  - Check the contents of testpkg.deb package file 
   * dpkg -c testpkg.deb

2. Upload generated deb package to the repository
  - By using the following curl command, we upload directly to http://localhost:3000/api/packages/deb-test/debian/pool/TARGET_PLATFORM_GROUP-TARGET_PLATFORM-1.0.0/main/upload url. We don't need to create any directory, this directory becomes immediately available after the first package upload.
  - "curl --user cargo_test_access:<cargo_test_access_token_created_in_settings_applications> --upload-file testpkg.deb http://localhost:3000/api/packages/deb-test/debian/pool/TARGET_PLATFORM_GROUP-TARGET_PLATFORM-1.0.0/main/upload"
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
  - Check the installed files of testpkg package 
   * dpkg -L testpkg
  - You can remove the testpkg package with
   * dpkg -r testpkg

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


