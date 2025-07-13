# Preparing Services
Aerospike, Nginx, Redis

In a development server multiple developers login and work together, so while working in a development server, every developer's aerospike/nginx/redis service should use different port.
Port usage policy is listed below : 
  - Aerospike occupies the ports "2$UID", "3$UID", "4$UID", "5$UID"  
  - Nginx occupies the port "6$UID", with $UID=$((UID%5000))
  - Redis occupies (the biggest occupied port) + 1

These ports are managed automatically using "start scripts" explained below.
   
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

7. Write $AEROSPIKE_HOME/bin/start_aerospike.sh file and make it executable (chmod +x $AEROSPIKE_HOME/bin/start_aerospike.sh)
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

8. Write $AEROSPIKE_HOME/bin/aerospike_admin.sh file and make it executable (chmod +x $AEROSPIKE_HOME/bin/admin.sh)
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

9. Write $AEROSPIKE_HOME/bin/aql.sh file and make it executable (chmod +x $AEROSPIKE_HOME/bin/aql.sh)
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

## Preparing Redis
Redis is used as in-memory-database, cache, message-broker in some applications.
To install Redis in development environment , there are [Ubuntu-24.04 Installation](https://redis.io/docs/latest/operate/oss_and_stack/install/build-stack/ubuntu-noble/) or [Rocky Linux 8.10 Installation ](https://redis.io/docs/latest/operate/oss_and_stack/install/build-stack/almalinux-rocky-8/) documents. We use "Ubuntu-24.04 Installation" in this document as basis and we changed the scripts to match the needs of this development environment ( movable directory, different port per user). 

1. Install required libs to build the redis
```
sudo apt-get install -y --no-install-recommends \
    ca-certificates \
    wget \
    dpkg-dev \
    gcc \
    g++ \
    libc6-dev \
    libssl-dev \
    make \
    git \
    cmake \
    python3 \
    python3-pip \
    python3-venv \
    python3-dev \
    unzip \
    rsync \
    clang \
    automake \
    autoconf \
    libtool
```

2. Download and build
```
cd ~/workspace
REDIS_VERSION=8.0.3
wget -O redis-$REDIS_VERSION.tar.gz https://github.com/redis/redis/archive/refs/tags/$REDIS_VERSION.tar.gz
tar xvf redis-$REDIS_VERSION.tar.gz
export BUILD_TLS=yes
export BUILD_WITH_MODULES=yes
export INSTALL_RUST_TOOLCHAIN=yes
export DISABLE_WERRORS=yes
cd redis-$REDIS_VERSION
make -j "$(nproc)" all
mkdir -p $(pwd)/target
export PREFIX=$(pwd)/target
make install
mkdir target/conf
cp *.conf target/conf
mv target $HOME/sdk/services/1.0.0/redis-8.0.3

```


3. Write $HOME/sdk/services/1.0.0/redis-8.0.3/release file
```
#!/bin/bash
export REDIS_HOME=`cd \`dirname $( readlink -f $BASH_SOURCE ) \` && pwd`
export PATH=$REDIS_HOME/bin:$PATH
export LD_LIBRARY_PATH=$REDIS_HOME/lib:$LD_LIBRARY_PATH
echo ">>> REDIS_HOME=$REDIS_HOME "
```

4. Write $HOME/sdk/services/1.0.0/redis-8.0.3/bin/start_redis.sh file and make it executable
```
#!/bin/bash

lsof -i -n -P| grep redis | grep $USER
if [ $? = 0 ]
then
   echo "There already is a redis-server running for you"
   echo 'You may check it with command : lsof -i -n -P| grep redis | grep $USER'
   exit 1
fi



if [ "$REDIS_HOME" = "" ]
then
   echo "REDIS_HOME env. variable is not set, please source the redis release file in sdk/services directory"
   exit 1
fi

CURRENT_TIMESTAMP=$(date '+%Y%m%d%H%M%S')



if [ ! -d $HOME/.redis ]
then
     mkdir -p $HOME/.redis

     USER_PORT=$(lsof -i -n -P| cut -d: -f2 | sed -e 's/->.*//'|awk '{print $1}'| sort -n| tail -1)
     USER_PORT_1=$(($USER_PORT+1))

     cp -Rf $REDIS_HOME/conf $HOME/.redis/

     perl -pi -e "s#redis.conf#$HOME/.redis/conf/redis.conf#" $HOME/.redis/conf/redis-full.conf
     perl -pi -e "s#loadmodule ./modules/.*/#loadmodule $REDIS_HOME/lib/redis/modules/#" $HOME/.redis/conf/redis-full.conf
     perl -pi -e "s/port .*/port $USER_PORT_1/" $HOME/.redis/conf/redis.conf
     perl -pi -e "s#pidfile .*#pidfile $HOME/.redis/logs/pidfile.txt#" $HOME/.redis/conf/redis.conf


     mkdir -p $HOME/.redis/logs
fi


echo "Configuration file is $HOME/.redis/conf/redis-full.conf"
echo "Log file is $HOME/.redis/logs/$CURRENT_TIMESTAMP.log"

cd $REDIS_HOME/bin

./redis-server --version
./redis-server $HOME/.redis/conf/redis-full.conf >& $HOME/.redis/logs/$CURRENT_TIMESTAMP.log &
ps -ef | grep redis-server
lsof -i -n -P| grep redis | grep $USER

```


5. Write $HOME/sdk/services/1.0.0/redis-8.0.3/bin/stop_redis.sh file and make it executable
```
#!/bin/bash
pkill -U mpekmezci -9 redis-server
```

