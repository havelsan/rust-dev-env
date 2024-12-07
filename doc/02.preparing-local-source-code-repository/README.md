# Prepare Gitea Source Code Repository

1. Download gitea from hhttps://dl.gitea.com/gitea/
   for example :  wget --no-check-certificate  https://dl.gitea.com/gitea/1.22.4/gitea-1.22.4-linux-amd64.xz
2. run the "cd ../../src/prepare-env-scripts/; ./02.prepare.gitea.source.repo.sh 1.22.4 linux-amd64 ./gitea.app.ini" command

3. NOTE: if the main ditectory of the gitea changes , all the following variables in the $GITEA_HOME/custom/conf/app.ini file should be changed accordingly. 
   - WORK_PATH = GITEA_HOME
   - PATH = GITEA_HOME/data/gitea.db
   - ROOT = GITEA_HOME/data/gitea-repositories
   - APP_DATA_PATH = GITEA_HOME/data
   - PATH = GITEA_HOME/data/lfs
   - ROOT_PATH = GITEA_HOME/log

4. Goto http://localhost:3000/ adress and create the admin user :
   - Click on the "Register" link found on the left top of the page.
   - username= adm001, email=adm001@localhost.com, password=adm001+++
   - NOTE : email and ldap configurations will not be covered in this tutorial. So we used a fake email adress for admin001


   


