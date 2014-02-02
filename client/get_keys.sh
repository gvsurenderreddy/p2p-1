#!/bin/bash
### this is used to update keys when they are regenerated on the server

### go to the script directory
cd $(dirname $0)

### get the server
. ./ssh.rc

### get the keys
url="http://$p2p_server:800/keys"
for keyname in create delete get
do
    wget -O keys/$keyname.key $url/$keyname.key >> $logfile 2>&1
done

### set proper permissions
chmod 600 keys/*.key