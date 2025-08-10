#!/bin/bash

if [ ! -d VSCode-linux-x64 ]
then
  if [ ! -f  VSCode-linux-x64.tar.gz ]
  then
     wget  "https://code.visualstudio.com/sha/download?build=stable&os=linux-x64" -O VSCode-linux-x64.tar.gz
  fi

  tar xvzf VSCode-linux-x64.tar.gz
  rm -f VSCode-linux-x64.tar.gz
fi

cp code.sh VSCode-linux-x64


