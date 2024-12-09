# Prepare Local Crate Repository

0. run the gitea start script : cd $HOME/sdk/tools/gitea-1.22.4 && ./run.sh

1. sudo apt-get install libssl-dev
   
2. cargo install cargo-local-registry

3. goto http://localhost:3000

4. login using adm001 (this user was created in step "Preparing Local Source Code Repository")

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
 
- write the access token previously generated access token to the file $HOME/.cargo/credentials.toml, **NOTE: 17e5616bf481c9f46350312ba533edfc8d383806 string should be replaced by what ever cargo-test access token is gernerated by you :) **
```
[registries.cargo-test]
token = "Bearer 17e5616bf481c9f46350312ba533edfc8d383806"
```
    
11. test the access :
- create a rust project :
 + source $HOME/sdk/infra/1.0.0/release
 + mkdir -p $HOME/workspace
 + cd $HOME/workspace
 + cargo new hello_cargo
 + cd hello_cargo
 + if you want to restrict the module to be ublished to only "cargo-test" registry, write ' publish = ["cargo-test"] ' in the " [package] " section of the  Cargo.toml file. But i would not recommend it because we will use different registry (cargo-prod) in the Jenkins builds.
 
- Make package
 + cargo package --allow-dirty
- Try to push to cargo-test registry
 + cargo publish --registry=cargo-test  --allow-dirty
 + The above command should write "Uploaded hello_cargo v0.1.0 to registry cargo-test" in the end. 
 + cargo yank --registry=cargo-test --version 0.1.0 # this command deletes the previously uploaded package from the cargo-test registry, yoou should also give the version!
 
 
