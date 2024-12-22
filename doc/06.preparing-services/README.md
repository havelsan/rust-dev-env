# Preparing Services
Aerospike,FastDDS,Nginx. 

Note : 
  - Aerospike occupies the ports "2$UID", "3$UID", "4$UID", "5$UID"  
  - FastDDS discovery service occupies the port "1$UID"
  - Nginx occupies the port "6$UID", with $UID=$((UID%5000))
  
   
## Preparing Aerospike 

1. Checkout and build the aerospike server :
```
mkdir -p $HOME/workspace
cd $HOME/workspace
git clone https://github.com/aerospike/aerospike-server.git
cd aerospike-server
git submodule update --init
./bin/install-dependencies.sh  # (needs direct internet connection)
make -j4
make rpm
mkdir aerospike
cd aerospike
rpm2cpio  ../pkg/packages/*.rpm | cpio -idmv
mkdir a ; mv * a
mkdir -p etc bin udf smd data
mv a/etc/* etc; mv a/usr/lib/systemd/system/aerospike.service etc/systemd/system/
rm -Rf a/etc/sysconfig
rm -Rf a/etc/tmpfiles.d
mv a/usr/bin/* bin; mv a/opt/aerospike/bin/* bin; 
mv a/opt/aerospike/usr/udf/lua udf
rm -Rf a; cd ..
rm -Rf $HOME/workspace/tmp
mkdir -p $HOME/workspace/tmp
git tag| sort -V| tail -1> aerospike/version
mv aerospike $HOME/workspace/tmp/ 
```

2. Checkout and build the Aerospike server admin
```
cd $HOME/workspace
git clone https://github.com/aerospike/aerospike-admin.git
cd aerospike-admin
install python 3.10 or later (python3 --version)
install pipenv (pip3 install pipenv)
git submodule update --init
export PATH="$PATH:$HOME/.local/bin"
echo 'export PATH="$PATH:$HOME/.local/bin"' >> $HOME/.bash_profile
make one-dir # (requires internet connection)
cp makefile makefile.org
perl -pi -e 's#INSTALL_ROOT =.*#INSTALL_ROOT = \$\(HOME\)/workspace/tmp/aerospike/bin/#g' makefile
perl -pi -e 's#SYMLINK_ASADM =.*#SYMLINK_ASADM = \$\(HOME\)/.local/bin/asadm#g' makefile
perl -pi -e 's#SYMLINK_ASINFO =.*#SYMLINK_ASINFO = \$\(HOME\)/.local/bin/asinfo#g' makefile
make install
```

3. Checkout and build the Aerospike query command line tool
   First of all you should confiure ssh based login from github (https://docs.github.com/en/authentication/connecting-to-github-with-ssh)
```
cd $HOME/workspace
git clone --recursive git@github.com:aerospike/aql.git
sudo apt-get install libreadline8 libreadline-dev flex
# for redhat yum -y install readline readline-devel flex which
make clean
make
mv target/Linux-x86_64/bin/aql $HOME/workspace/tmp/aerospike/bin/
mv pkg/astools.conf $HOME/workspace/tmp/aerospike/etc/
```

4. Checkout and configure Aerospike zabbix connector
```
cd $HOME/workspace
git clone https://github.com/aerospike-community/aerospike-zabbix.git
sudo pip3 install -r aerospike-zabbix/requirements.txt
mv aerospike-zabbix $HOME/workspace/tmp/aerospike/zabbix
```

5. Move aerospike directory to sdk/services directory
```
mkdir -p $HOME/sdk/services/1.0.0/
mv $HOME/workspace/tmp/aerospike $HOME/sdk/services/1.0.0/
```

6. Write $HOME/sdk/services/1.0.0/aerospike/release file
```
#!/bin/bash
export AEROSPIKE_HOME=`cd \`dirname $( readlink -f $BASH_SOURCE ) \` && pwd`
echo ">>>  AEROSPIKE_HOME=$AEROSPIKE_HOME "

```

7. Write $AEROSPIKE_HOME/bin/start.sh file and make it executable (chmod +x $AEROSPIKE_HOME/bin/start.sh)
```
#!/bin/bash
if [ "$AEROSPIKE_HOME" = "" ]
then
     echo $BASH_SOURCE| grep '^/'
     if [ $? = 0 ]
     then
        export AEROSPIKE_HOME=$(echo $BASH_SOURCE| sed -e 's#/bin/start.sh##')
     else
        echo "Either call this script using absolute path, or set the AEROSPIKE_HOME env. variable"
        exit 1
     fi
fi

CURRENT_TIMESTAMP=$(date '+%Y%m%d%H%M%S')
mkdir -p $HOME/.aerospike

grep "work-directory $AEROSPIKE_HOME" $HOME/.aerospike/aerospike.conf >/dev/null
if [ $? != 0 ]
then
        mv $HOME/.aerospike/aerospike.conf $HOME/.aerospike/aerospike.conf.$CURRENT_TIMESTAMP
fi

if [ ! -f $HOME/.aerospike/aerospike.conf ]
then
     USER_ID=$(id -u)
     if [ $USER_ID -lt 1000 ]
     then
          USER_PORT=$(($USER_ID+5000))
     else
          USER_PORT=$USER_ID
     fi
     USER_PORT=$(($USER_PORT%10000))
     USER_PORT_1="2$USER_PORT"
     USER_PORT_2="3$USER_PORT"
     USER_PORT_3="4$USER_PORT"
     USER_PORT_4="5$USER_PORT"
     cp $AEROSPIKE_HOME/etc/aerospike/aerospike.conf $HOME/.aerospike/aerospike.conf
     perl -pi -e "s/port 3000/port $USER_PORT_1/" $HOME/.aerospike/aerospike.conf
     perl -pi -e "s/port 9918/port $USER_PORT_2/" $HOME/.aerospike/aerospike.conf
     perl -pi -e "s/port 3001/port $USER_PORT_3/" $HOME/.aerospike/aerospike.conf
     perl -pi -e "s/port 3003/port $USER_PORT_4/" $HOME/.aerospike/aerospike.conf
     perl -pi -e "s/proto-fd-max 15000/proto-fd-max 1024/" $HOME/.aerospike/aerospike.conf
     perl -pi -e "s#proto-fd-max#work-directory $AEROSPIKE_HOME\nproto-fd-max#" $HOME/.aerospike/aerospike.conf
     echo " mod-lua {
        user-path $AEROSPIKE_HOME/udf/lua
     }
     ">> $HOME/.aerospike/aerospike.conf

     # ulimit -n 15000
fi

mkdir -p $HOME/.aerospike/log

echo "Configuration file is $HOME/.aerospike/aerospike.conf"
echo "Log file is $HOME/.aerospike/log/$CURRENT_TIMESTAMP.log"

$AEROSPIKE_HOME/bin/asd --cold-start --config-file $HOME/.aerospike/aerospike.conf --fgdaemon>& $HOME/.aerospike/log/$CURRENT_TIMESTAMP.log

```

8. Write $AEROSPIKE_HOME/etc/aerospike.service file ( This is not necessary for development environment , this is necessary only for test and target environments, prefereably this configuration can be made in the postinstall script of the operating system package such as rpm or deb)
```
[Unit]
Description=Aerospike Server
After=network-online.target
Wants=network.target

[Service]
LimitNOFILE=100000
TimeoutSec=600
User=root
Group=root
#EnvironmentFile=/etc/sysconfig/aerospike
PermissionsStartOnly=True
ExecStart=AEROSPIKE_HOME/bin/start.sh

[Install]
WantedBy=multi-user.target

```

9. Configure aerospike service (this is necessary only for test and target environments)
```
USER_ID=$(id -u)
if [ "$AEROSPIKE_HOME" = "" ]
then
   echo "Please set the AEROSPIKE_HOME env. variable ( there should be a release file within the aerospike directory, you may source it )" 
   echo "Not configureing service"
elif [ "$USER_ID" != "0" ]
then
   echo "You should be root to configure system service"   
else
   CURRENT_TIMESTAMP=$(date '+%Y%m%d%H%M%S')
   mv /etc/systemd/system/aerospike.service /etc/systemd/system/aerospike.service.$CURRENT_TIMESTAMP
   cp $AEROSPIKE_HOME/etc/aerospike.service /etc/systemd/system/
   perl -pi -e "s#AEROSPIKE_HOME#$AEROSPIKE_HOME#" /etc/systemd/system/aerospike.service
   systemctl enable aerospike
   systemctl start aerospike
   systemctl status aerospike
fi
```

10. Write $AEROSPIKE_HOME/bin/admin.sh file and make it executable (chmod +x $AEROSPIKE_HOME/bin/admin.sh)
```
if [ ! -f $HOME/.aerospike/aerospike.conf ]
then
   echo "Aerospike server is not started using this user "
   exit 1
fi

USER_ID=$(id -u)
if [ $USER_ID -lt 1000 ]
then
      USER_PORT=$(($USER_ID+5000))
else
      USER_PORT=$USER_ID
fi
USER_PORT=$(($USER_PORT%10000))
USER_PORT_1="2$USER_PORT"
     
$AEROSPIKE_HOME/bin/asadm/asadm -h localhost -p $USER_PORT_1

```

11. Write $AEROSPIKE_HOME/bin/aql.sh file and make it executable (chmod +x $AEROSPIKE_HOME/bin/aql.sh)
```
if [ ! -f $HOME/.aerospike/aerospike.conf ]
then
   echo "Aerospike server is not started using this user "
   exit 1
fi

USER_ID=$(id -u)
if [ $USER_ID -lt 1000 ]
then
      USER_PORT=$(($USER_ID+5000))
else
      USER_PORT=$USER_ID
fi
USER_PORT=$(($USER_PORT%10000))
USER_PORT_1="2$USER_PORT"

$AEROSPIKE_HOME/bin/aql -h localhost -p $USER_PORT_1

```


## Preparing FastDDS
https://fast-dds.docs.eprosima.com/en/latest/installation/sources/sources_linux.html

0. Prepare libraries
```
sudo apt install cmake g++ python3-pip wget git
sudo apt install libasio-dev libtinyxml2-dev
sudo apt install libssl-dev
sudo apt install softhsm2
sudo usermod -a -G softhsm $(whoami)
sudo apt install libengine-pkcs11-openssl
```


1. Checkout Fast-DDS
```
cd ~/workspace
git clone https://github.com/eProsima/Fast-DDS
git clone https://github.com/eProsima/foonathan_memory_vendor.git
git clone https://github.com/eProsima/Fast-CDR.git
```

2. Build and install
```
mkdir ~/workspace/foonathan_memory_vendor/build
cd foonathan_memory_vendor/build
cmake .. -DCMAKE_INSTALL_PREFIX=~/workspace/Fast-DDS/install -DBUILD_SHARED_LIBS=ON
cmake --build . --target install

cd ~/workspace
mkdir Fast-CDR/build
cd Fast-CDR/build
cmake .. -DCMAKE_INSTALL_PREFIX=~/workspace/Fast-DDS/install
cmake --build . --target install

cd ~/workspace
mkdir Fast-DDS/build
cd Fast-DDS/build
cmake ..  -DCMAKE_INSTALL_PREFIX=~/workspace/Fast-DDS/install
cmake --build . --target install

cd ~/workspace/Fast-DDS
git tag| sort -V| tail -1 > install/version
mv install $HOME/sdk/services/1.0.0/Fast-DDS
```

3. Write $HOME/sdk/services/1.0.0/Fast-DDS/release file 
```
#!/bin/bash
export FAST_DDS_HOME=`cd \`dirname $( readlink -f $BASH_SOURCE ) \` && pwd`

PATH=$PATH:$FAST_DDS_HOME/bin
LD_LIBRARY_PATH=$LS_LIBRARY_PATH:$FAST_DDS_HOME/lib

echo ">>>  FAST_DDS_HOME=$FAST_DDS_HOME "
```

4. Write $FAST_DDS_HOME/bin/start_discovery_server.sh and make it executable (chmod +x $FAST_DDS_HOME/bin/start_discovery_server.sh)
```
USER_ID=$(id -u)
if [ $USER_ID -lt 1000 ]
then
      USER_PORT=$((USER_ID+5000))
else
      USER_PORT=$USER_ID
fi
USER_PORT=$(($USER_PORT%10000))
USER_PORT_1="1$USER_PORT"

fastdds discovery -p $USER_PORT_1
```

## Preparing Nginx
Nginx server may be used as http web server as well as tcp/udp proxy server or load balancer(https://docs.nginx.com/nginx/admin-guide/load-balancer/tcp-udp-load-balancer/)

0. Download and build
```
cd ~/workspace
git clone https://github.com/nginx/nginx.git
sudo apt install libpcre3-dev zlib1g-dev
sudo apt install libssl-dev
mkdir -p $HOME/workspace/nginx/install
auto/configure --prefix=$HOME/workspace/nginx/install --with-http_ssl_module --with-stream
make
make install
git tag| sort -V| tail -1 > install/version
mv install nginx
mv nginx $HOME/sdk/services/1.0.0/
cd $HOME/sdk/services/1.0.0/nginx/
mkdir -p bin
```

1. Write $HOME/sdk/services/1.0.0/nginx/release file
```
#!/bin/bash
export NGINX_HOME=`cd \`dirname $( readlink -f $BASH_SOURCE ) \` && pwd`
export PATH=$PATH:$NGINX_HOME/bin
echo ">>>  NGINX_HOME=$NGINX_HOME "
```

2. Write $HOME/sdk/services/1.0.0/nginx/bin/start_nginx.sh file and make it executable
```
#!/bin/bash
if [ "$NGINX_HOME" = "" ]
then
     echo $BASH_SOURCE| grep '^/'
     if [ $? = 0 ]
     then
        export NGINX_HOME=$(echo $BASH_SOURCE| sed -e 's#/bin/start_nginx.sh##')
     else
        echo "Either call this script using absolute path, or set the NGINX_HOME env. variable"
        exit 1
     fi
fi

CURRENT_TIMESTAMP=$(date '+%Y%m%d%H%M%S')
mkdir -p $HOME/.nginx

if [ ! -d $HOME/.nginx/conf ]
then
     USER_ID=$(id -u)
     if [ $USER_ID -lt 1000 ]
     then
          USER_PORT=$((USER_ID+5000))
     else
          USER_PORT=$USER_ID
     fi
     USER_PORT=$(($USER_PORT%5000))
     USER_PORT_1="6$USER_PORT"

     cp -Rf $NGINX_HOME/conf $HOME/.nginx/
     perl -pi -e "s/listen\s*80\s*;/listen $USER_PORT_1;/" $HOME/.nginx/conf/nginx.conf

     mkdir -p $HOME/.nginx/logs

     mkdir -p $HOME/.nginx/html

     echo $HOSTNAME > $HOME/.nginx/html/index.html

fi


echo "Configuration file is $HOME/.nginx/conf/nginx.conf"
echo "Log file is $HOME/.nginx/logs/$CURRENT_TIMESTAMP.log"

$NGINX_HOME/sbin/nginx -V >& $HOME/.nginx/logs/nginx.version.and.properties.log

$NGINX_HOME/sbin/nginx -p $HOME/.nginx/ >& $HOME/.nginx/logs/$CURRENT_TIMESTAMP.log
```


