#!/bin/bash

if [ $# -lt 2 ]
then
    echo "Usage :  $0 <http_proxy_address> <username>"
    echo "Example : $0 http://proxy01.company.net:8080 usr001"
    exit 1
else
    PROXY_URL=$( echo $1 | sed -e 's#http://##' | sed -e 's#https://##')
    USERNAME=$2

    echo "alias wget='wget --no-check-certificate'" >> $HOME/release.proxy
    echo "echo 'password for username $USERNAME : ( we read silently , no print to console) '" >>  $HOME/release.proxy
    echo "read -s PASSWORD" >>  $HOME/release.proxy
    echo "export http_proxy='http://$USERNAME:\$PASSWORD@$PROXY_URL/'" >>  $HOME/release.proxy
    echo 'export https_proxy=$http_proxy' >>  $HOME/release.proxy
    echo 'wget www.google.com' >>  $HOME/release.proxy
    echo 'rm index.html*' >> $HOME/release.proxy
    git config --global http.proxy $http_proxy
    git config --global http.sslVerify false
    git config --global http.proxyAuthMethod 'basic'
fi


mkdir -p $HOME/.cargo

grep cainfo  $HOME/.cargo/config.toml >/dev/null
if [ $? != 0 ]
then

  echo 'openssl s_client -showcerts -connect www.google.com:443 </dev/null'
  (
     openssl s_client -showcerts -connect www.google.com:443 </dev/null | sed -n -e '/-.BEGIN/,/-.END/ p' > ~/.cargo/certs.pem
  )>&/dev/null

  echo '
[http]
check-revoke=false
timeout=60
multiplexing = false
cainfo=".cargo/certs.pem"
   ' >> $HOME/.cargo/config.toml

fi


   


