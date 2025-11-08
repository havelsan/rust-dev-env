# Preparing Data Tools
DBeaver and jdbc driver for Aerospike, FastDDS Monior (https://github.com/eProsima/Fast-DDS-monitor)


## Preparing DBeaver

1. Download DBeaver and Aerospike Jdbc Driver

```
mkdir -p $HOME/workspace
cd $HOME/workspace
wget https://dbeaver.io/files/dbeaver-ce-latest-linux.gtk.x86_64.tar.gz
tar xvzf dbeaver-ce-latest-linux.gtk.x86_64.tar.gz
wget https://github.com/aerospike/aerospike-jdbc/releases/download/1.10.0/uber-aerospike-jdbc-1.10.0.jar
cp uber-aerospike-jdbc-1.10.0.jar dbeaver/plugins
```

2. Prepare sdk directory 
```
cd $HOME/workspace
mv dbeaver ~/sdk/tools/1.0.0/dbeaver
```

3. Prepare ~/sdk/tools/1.0.0/dbeaver/relase file 
```
export DBEAVER_HOME=`cd \`dirname $( readlink -f $BASH_SOURCE ) \` && pwd`
export PATH=$PATH:$DBEAVER_HOME
echo ">>> DBEAVER_HOME=$DBEAVER_HOME "
```

4. Prepare ~/sdk/tools/1.0.0/dbeaver/start_debeaver.sh file and make it executable
```
#!/bin/bash
if { "$DBEAVER_HOME" = "" ]
then
    echo "DBEAVER_HOME environment variable does not exist, please source release file in sdk/tools/<LAST_TOOL_VERSION>/release"
    exit 1
fi
if { "$AEROSPIKE_HOME" = "" ]
then
    echo "AEROSPIKE_HOME environment variable does not exist, please source release file in sdk/services/<LAST_TOOL_VERSION>/release"
    exit 1
fi

cd $DBEAVER_HOME
if [ ! -d  $HOME/.DBeaverData ]
then
  cp -Rf DBeaverTemplateDataDir ~/.DBeaverData
fi

./dbeaver -data ~/.DBeaverData >& ~/.DBeaverData/log_file &
echo "Log file is ~/.DBeaverData/log_file"

```

5. Example Connection Strings :
```
jdbc:aerospike:127.0.0.1:21000/test  
(when you dont specify the namespace "test" , dbeaver fails to show and edit the data using "right click > view data"  on the table's name.)
(this connection string is saved in $HOME/.local/share/DBeaverData/workspace6/General/.dbeaver/data-sources.json
```
 
6. Configure Aerospike Driver :
```
$HOME/.local/share/DBeaverData/workspace6/.metadata/.config/drivers.xml
<driver id="46803A21-E83B-255C-8812-E34608B1958E" name="Aerospike" class="com.aerospike.jdbc.AerospikeDriver" port="21000" custom="true">
   <library type="jar" path="${DBEAVER_HOME}/plugins/uber-aerospike-jdbc-1.10.0.jar" custom="true"/>
```

7. Example Usage:

Even tough the table "deneme2" does not exists in the namespace "test". You create it by inserting the first record :)

```
INSERT INTO test.deneme2(a, b,c) VALUES ('xyz', 'abc', 123)
SELECT * FROM test.deneme2
UPDATE test.deneme2 SET a='xyzs' WHERE a='xyz' AND b='abc' AND c=123;
```


